return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = {
        char = '│',
        tab_char = '│',
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = true,
        priority = 1000,
      },
      exclude = {
        filetypes = {
          'help',
          'dashboard',
          'neo-tree',
          'Trouble',
          'lazy',
          'mason',
          'terminal',
        },
      },
    },
  },
}
