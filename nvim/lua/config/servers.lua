--  THESE ARE nvim-lspconfig NAMES!
--  See `:help lspconfig-all` for a list of all the pre-configured LSPs
--
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
local servers = {
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
    capabilities = require('blink.cmp').get_lsp_capabilities(),
  },
  jdtls = {},
  yamlls = {},
  ts_ls = {},
}

return servers
