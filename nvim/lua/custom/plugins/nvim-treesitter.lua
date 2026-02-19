return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup()

      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      -- Auto-install parsers on startup
      local ensure_installed = {
        'c',
        'lua',
        'java',
        'javascript',
        'html',
        'css',
        'markdown',
        'python',
        'sql',
        'bash',
        'vim',
      }
      vim.api.nvim_create_autocmd('VimEnter', {
        once = true,
        callback = function()
          local to_install = vim.tbl_filter(function(lang)
            local ok = pcall(vim.treesitter.language.add, lang)
            return not ok
          end, ensure_installed)
          if #to_install > 0 then
            require('nvim-treesitter').install(to_install)
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      -- Configure textobjects options (lookahead for select, set_jumps for move)
      require('nvim-treesitter-textobjects').setup({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      })

      -- Textobject selection keymaps
      local ts_select = require('nvim-treesitter-textobjects.select')
      local select_maps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['ap'] = '@parameter.outer',
        ['ip'] = '@parameter.inner',
      }
      for key, query in pairs(select_maps) do
        vim.keymap.set({ 'x', 'o' }, key, function()
          ts_select.select_textobject(query, 'textobjects')
        end, { desc = 'TS select ' .. query })
      end

      -- Textobject movement keymaps
      local ts_move = require('nvim-treesitter-textobjects.move')
      local move_maps = {
        [']m'] = { query = '@function.outer', method = 'goto_next_start' },
        [']]'] = { query = '@class.outer', method = 'goto_next_start' },
        [']M'] = { query = '@function.outer', method = 'goto_next_end' },
        [']['] = { query = '@class.outer', method = 'goto_next_end' },
        ['[m'] = { query = '@function.outer', method = 'goto_previous_start' },
        ['[['] = { query = '@class.outer', method = 'goto_previous_start' },
        ['[M'] = { query = '@function.outer', method = 'goto_previous_end' },
        ['[]'] = { query = '@class.outer', method = 'goto_previous_end' },
      }
      for key, spec in pairs(move_maps) do
        vim.keymap.set({ 'n', 'x', 'o' }, key, function()
          ts_move[spec.method](spec.query, 'textobjects')
        end, { desc = 'TS move ' .. spec.method .. ' ' .. spec.query })
      end
    end,
  },
}
