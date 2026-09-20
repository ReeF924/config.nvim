return {
  {
    'Mofiqul/adwaita.nvim',

    lazy = false,
    priority = 1000,

    config = function()
      vim.cmd.colorscheme 'adwaita'

      local highlights = require 'core.highlights'

      -- Apply our custom highlights.
      highlights.apply()

      -- Re-apply them whenever another colorscheme is loaded.
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = highlights.apply,
      })

      -- Comment color toggle.
      local togglefunc = require 'core.toggleCommentColor'

      vim.keymap.set('n', '<leader>tc', togglefunc, {
        desc = 'Toggle Comment Color (All Languages)',
      })
    end,
  },
}
