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
  cmd = { 'Neotree', 'NeotreeToggle', 'NeotreeFocus', 'NeotreeReveal', 'NeotreeOpen' },
  keys = {
    { '<leader>n', ':Neotree toggle float right<cr>', desc = 'Neo-tree Toggle' },
    { '<leader>N', ':Neotree focus<CR>', desc = 'Neo-tree Focus' },
  },
  opts = {
    auto_clean_after_session_restore = false,
    close_if_last_window = true,
    enable_diagnostics = true,
    enable_git_status = true,
    enable_normal_mode_for_inputs = false,
    use_popups_for_input = false,
    open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
    buffers = {
      bind_to_cwd = false,
    },
    default_component_configs = {
      indent = {
        indent_size = 2,
        padding = 1,
        indent_guides_hi = 'NeoTreeIndentMarker',
      },
    },
    filesystem = {
      auto_open = false,
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
