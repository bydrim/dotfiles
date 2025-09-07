--  THESE ARE nvim-lspconfig NAMES!
--
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
  --
  -- Some languages (like typescript) have entire language plugins that can be useful:
  --    https://github.com/pmizio/typescript-tools.nvim
  --
  -- But for many setups, the LSP (`ts_ls`) will work just fine
  -- ts_ls = {},

  lua_ls = {
    automatic_enable = true,
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
  jdtls = {
    settings = {
      java = {
        configuration = {
          runtimes = {
            {
              name = 'openJDK-21.0.7-Temurin',
              path = 'java',
              default = true,
            },
          },
        },
      },
    },
    on_attach = function(some_table)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = some_table.bufnr, desc = 'Java: ' .. desc })
      end

      local java = require 'java'

      -- Build & Run
      map('<leader>jb', ':JavaBuildBuildWorkspace<CR>', 'Runs a full workspace build')
      map('<leader>jr', ':JavaRunnerRunMain<CR>', 'Run the application or selected main class')
      map('<leader>js', ':JavaRunnerStopMain<CR>', 'Stops the running application')
      -- Testing
      map('<leader>jtc', ':JavaTestRunCurrentClass<CR>', 'Runs the test class in the current buffer')
      map('<leader>jtm', ':JavaTestRunCurrentMethod<CR>', 'Runs the test method on the cursor')
    end,
  },
  yamlls = {},
  biome = {},
}

return servers
