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
      require('config.keymaps').nvimjava_setkeys(event)
    end,
  })
end

return M
