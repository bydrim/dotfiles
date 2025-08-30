-- ':h neo-tree' for full documentation

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons', -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    keys = {
      { '<leader>e', ':Neotree reveal<CR>', mode = 'n', desc = 'NeoTree reveal', silent = true },
    },
    ---@module 'neo-tree'
    ---@type neotree.Config
    opts = {
      -- options go here
      window = {
        position = 'right',
      },
    },
  },
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neo-tree/neo-tree.nvim', -- makes sure that this loads after Neo-tree.
    },
  },
}
