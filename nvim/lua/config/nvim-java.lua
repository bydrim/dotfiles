local M = {}

--- Sets up nvim-java and related keymaps.
--- nvim-java must set up before jdtls config(lspconfig.jdtls.setup).
M.init = function()
  -- nvim-java
  require('java').setup {
    jdk = {
      auto_install = false,
      -- version = 21.0.7,
    },
  }

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('nvim-java-augroup', { clear = true }),
    pattern = { '*.java' },
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.bufnr, desc = 'Java: ' .. desc })
      end

      -- Build & Run
      map('<leader>jb', ':JavaBuildBuildWorkspace<CR>', 'Runs a full workspace build')
      map('<leader>jr', ':JavaRunnerRunMain<CR>', 'Run the application or selected main class')
      map('<leader>js', ':JavaRunnerStopMain<CR>', 'Stops the running application')
      -- Testing
      map('<leader>jtc', ':JavaTestRunCurrentClass<CR>', 'Runs the test class in the current buffer')
      map('<leader>jtm', ':JavaTestRunCurrentMethod<CR>', 'Runs the test method on the cursor')
    end,
  })
end

return M
