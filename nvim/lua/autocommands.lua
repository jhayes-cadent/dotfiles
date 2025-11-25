-- See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Disable auto-commenting on new lines
-- vim.api.nvim_create_autocmd('BufEnter', {
--   desc = 'Disable auto-commenting on new lines',
--   group = vim.api.nvim_create_augroup('kickstart-formatoptions', { clear = true }),
--   pattern = '*',
--   callback = function()
--     vim.opt_local.formatoptions-='cro'
--   end,
-- })

