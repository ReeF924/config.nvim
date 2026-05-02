-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      window = {
        mappings = {
          ['u'] = 'navigate_up',
          ['.'] = 'set_root',
          ['P'] = { 'toggle_preview', config = { use_float = true } },
          ['l'] = function(state)
            local node = state.tree:get_node()
            if node.type == 'file' then
              require('neo-tree.sources.common.commands').open(state)
              vim.cmd 'Neotree focus'
            else
              -- If it's a directory, just toggle it
              require('neo-tree.sources.common.commands').toggle_node(state)
            end
          end,
        },
      },
    },
  },
}
