return {
  'rose-pine/neovim',
  name = 'rose-pine',
  priority = 1000,

  config = function()
    require('rose-pine').setup({
      variant = 'auto',
    })

    vim.cmd.colorscheme 'rose-pine'
    vim.cmd.hi 'Comment gui=none'
  end,
}
