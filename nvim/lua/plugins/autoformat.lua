return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
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
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
        -- java = { 'google-java-format', lsp_format = 'fallback' },
        java = { 'astyle', lsp_format = 'fallback' },
        xml = { 'xmlformatter' },
      },
    },
  },
}
