return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- fancy icons
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {
      window = {
        position = 'right',
        width = 35,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
      },
      filesystem = {
        window = {
          mappings = {
            ['tf'] = 'telescope_find', -- Shortcut to use telescope inside the tree
          },
        },
        -- This uses the floating strategy you wanted
        renderers = {
          layout = {
            position = 'float',
          },
        },
      },
    }
  end,
}
