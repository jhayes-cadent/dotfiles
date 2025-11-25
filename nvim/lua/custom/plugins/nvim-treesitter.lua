return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'OXY2DEV/markview.nvim',
  },
  build = ':TSUpdate',
  priority = 50,
}
