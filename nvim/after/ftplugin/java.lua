-- See `:help vim.lsp.start` for an overview of the supported `config` options.
local config = {
  name = 'jdtls',

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = {
          {
            name = 'JavaSE-21',
            path = os.getenv 'JAVA21',
          },
          {
            name = 'JavaSE-25',
            path = os.getenv 'JAVA25',
          },
        },
      },
      import = {
        gradle = {
          enabled = true,
        },
        maven = {
          enabled = true,
        },
        exclusions = {
          '**/node_modules/**',
          '**/.metadata/**',
          '**/archetype-resources/**',
          '**/META-INF/maven/**',
          '/**/test/**',
        },
      },
      maven = {
        downloadSources = true,
      },
      references = {
        includeDecompiledSources = true,
      },
    },
  },

  capabilities = require('blink.cmp').get_lsp_capabilities(),
}

-- `root_dir` must point to the root of your project.
-- See `:help vim.fs.root`
local root_dir = vim.fs.root(0, { 'gradlew', '.git', 'mvnw' })
config.root_dir = root_dir

-- `cmd` defines the executable to launch eclipse.jdt.ls.
-- `jdtls` must be available in $PATH and you must have Python3.9 for this to work.
--
-- As alternative you could also avoid the `jdtls` wrapper and launch
-- eclipse.jdt.ls via the `java` executable
-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
-- cmd = { 'jdtls' },
local cmd = {
  os.getenv 'JAVA25' .. '/bin/java',
  '-Declipse.application=org.eclipse.jdt.ls.core.id1',
  '-Dosgi.bundles.defaultStartLevel=4',
  '-Declipse.product=org.eclipse.jdt.ls.core.product',
  '-Dlog.protocol=true',
  '-Dlog.level=ALL',
  '-XX:+UseTransparentHugePages',
  '-XX:+AlwaysPreTouch',
  '-Xmx2G',
  '--add-modules=ALL-SYSTEM',
  '--add-opens',
  'java.base/java.util=ALL-UNNAMED',
  '--add-opens',
  'java.base/java.lang=ALL-UNNAMED',
  '-jar',
  vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
  '-data',
  os.getenv 'HOME' .. '/.cache/jdtls/projects/' .. vim.fn.sha256(root_dir),
}

-- vim.fn.has => 'win32' (for 32 and 64 bits), 'linux', 'mac', 'wsl'
-- `:help has` for more
-- alternative: `vim.uv.os_uname().sysname`
local config_dir = ''
if vim.fn.has 'win32' == 1 then
  config_dir = 'config_win'
elseif vim.fn.has 'mac' == 1 then
  -- I assume a macbook would have arm
  config_dir = 'config_mac_arm'
else
  config_dir = 'config_linux'
end
vim.list_extend(cmd, { '-configuration', vim.fn.stdpath 'data' .. '/mason/packages/jdtls/' .. config_dir })

config.cmd = cmd
-- config.cmd = {
--   'jdtls',
--   'Xmx2G',
--   '-data',
--   os.getenv 'HOME' .. '/.cache/jdtls/projects/' .. vim.fn.sha256(root_dir),
-- }

-- This sets the `initializationOptions` sent to the language server
-- If you plan on using additional eclipse.jdt.ls plugins like java-debug
-- you'll need to set the `bundles`
--
-- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
--
-- If you don't plan on any eclipse.jdt.ls plugins you can remove this
local bundles = {
  -- java debug adapter
  vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', 1),
}

local java_test_bundles = vim.split(vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/packages/java-test/extension/server/*.jar', 1), '\n')
local excluded = {
  'com.microsoft.java.test.runner-jar-with-dependencies.jar',
  'jacocoagent.jar',
}
for _, java_test_jar in ipairs(java_test_bundles) do
  local fname = vim.fn.fnamemodify(java_test_jar, ':t')
  if not vim.tbl_contains(excluded, fname) then
    table.insert(bundles, java_test_jar)
  end
end

config.init_options = {
  bundles = bundles,
}

vim.lsp.set_log_level(vim.log.levels.DEBUG)

-- this is nvim-jdtls, not the lsp from mason
require('jdtls').start_or_attach(config)
