-- See `:help lua-guide-autocommands`
-- Suppress E211 for oil:// buffers (stale after tmux detach/reattach)
vim.api.nvim_create_autocmd('FileChangedShell', {
  pattern = 'oil://*',
  callback = function(args)
    -- Silently delete the stale oil buffer instead of showing E211
    vim.schedule(function()
      pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
    end)
    return true -- Suppress the default E211 message
  end,
})

-- Auto-change window-local directory to current buffer's directory (like autochdir),
-- but skip oil:// buffers so Oil works correctly.
vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
  desc = 'Set lcd to buffer directory (autochdir replacement, oil-safe)',
  group = vim.api.nvim_create_augroup('oil-safe-autochdir', { clear = true }),
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local dir
    if bufname:match '^oil://' then
      -- Extract the real path from oil:// URI
      dir = bufname:gsub('^oil://', '')
    else
      dir = vim.fn.expand '%:p:h'
    end
    if dir and dir ~= '' and vim.fn.isdirectory(dir) == 1 then
      vim.cmd.lcd(dir)
    end
  end,
})

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

-- Create necessary sub-directories when creating a
-- new file through vim and saving with :w in a
-- non-existing file.
local mkdir_group = vim.api.nvim_create_augroup('Mkdir', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  group = mkdir_group,
  callback = function()
    vim.fn.mkdir(vim.fn.expand '%:p:h', 'p')
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
