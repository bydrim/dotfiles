return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = require('config.keymaps').conform_getkeys(),
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters = {
        -- ['google-java-format'] = {
        --   -- ensure 4 space indentation
        --   prepend_args = { '--aosp' },
        -- },
        xmlformatter = {
          prepend_args = { '--indent', '4' },
        },
        astyle = {
          prepend_args = {
            '--indent-after-parens',
            '--squeeze-ws',
            '--squeeze-lines=1',
            '--max-code-length=120',
            '--add-braces',
          },
        },
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        java = { 'astyle' },
        xml = { 'xmlformatter' },

        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        vue = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        less = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        ['markdown.mdx'] = { 'prettier' },
        graphql = { 'prettier' },
        handlebars = { 'prettier' },
      },
    },
  },
}
