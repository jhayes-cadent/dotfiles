return {
  'AndrewRadev/undoquit.vim',
  config = function()
    -- Make <C-w>c save window history before closing, so <C-w>u can restore it
    vim.keymap.set('n', '<C-w>c', function()
      vim.fn['undoquit#SaveWindowQuitHistory']()
      vim.cmd('close')
    end, { desc = 'Close window (undoable with <C-w>u)' })

    -- Make :close save window history too
    vim.cmd([[cabbrev close <C-r>=(getcmdtype() == ':' && getcmdpos() == 1 ? 'call undoquit#SaveWindowQuitHistory() <bar> close' : 'close')<CR>]])
  end,
}
