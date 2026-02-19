return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local function get_git_root()
      local out = vim.fn.systemlist('git rev-parse --show-toplevel')
      if vim.v.shell_error == 0 and out[1] then
        return out[1]
      end
      return vim.fn.getcwd()
    end

    local tree_width = math.floor(vim.o.columns / 5)

    require('nvim-tree').setup({
      hijack_netrw = true,
      root_dirs = { get_git_root() },
      prefer_startup_root = true,
      sync_root_with_cwd = false,
      view = {
        width = tree_width,
        side = 'left',
      },
      actions = {
        open_file = {
          window_picker = { enable = false },
        },
      },
      on_attach = function(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.map.on_attach.default(bufnr)

        local function open_vsplit()
          local node = api.tree.get_node_under_cursor()
          if not node then
            return
          end
          if node.type == 'directory' then
            api.node.open.edit()
            return
          end
          api.node.open.vertical()
          local new_width = math.floor(vim.o.columns / 5)
          api.tree.resize({ absolute = new_width })
        end

        vim.keymap.set('n', '<CR>', open_vsplit, opts('Open: Vertical Split'))
        vim.keymap.set('n', 'o', open_vsplit, opts('Open: Vertical Split'))
      end,
    })
  end,
}
