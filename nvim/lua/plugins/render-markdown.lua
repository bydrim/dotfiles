return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  keys = {
    { '<leader>tm', ':RenderMarkdown buf_toggle<CR>', desc = '[T]oggle [M]arkdown preview' },
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
}
