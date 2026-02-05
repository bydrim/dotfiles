return {
  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
    -- and elegantly composed help section, `:help lsp-vs-treesitter`
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      {
        'mason-org/mason.nvim',
        opts = {
          registries = {
            -- custom registry location to test contributions
            -- 'file:~/Workspaces/contributions/neovim/mason-registry',
            -- mason registry to get latest jdtls
            'github:nvim-java/mason-registry',
            'github:mason-org/mason-registry',
          },
        },
      },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      'nvim-java/nvim-java',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      require('config.keymaps').set_lsp_keymaps()

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- This needs to run before lspconfig and language server(jdtls) setup
      require('config.nvim-java').init()

      -- LSP configs
      local server_configs = require 'config.servers'

      -- The following loop will configure each lsp with the new api.
      for server_name, server_config in pairs(server_configs) do
        -- require('lspconfig')[server_name].setup(server_config)
        vim.lsp.config[server_name] = server_config
        vim.lsp.enable(server_name)
      end

      -- Ensure the servers and tools above are installed
      local ensure_installed = vim.tbl_keys(server_configs or {})
      local mason_installs = require 'config.mason_installs'
      vim.list_extend(ensure_installed, mason_installs or {})
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    end,
  },
}
