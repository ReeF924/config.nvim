return {
  {
    'grammar-syntax',
    dir = vim.fn.stdpath 'config',
    lazy = false,
    config = function()
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = '*.grm',
        callback = function()
          vim.bo.filetype = 'grm'
        end,
      })

      local c = require 'core.pallete'

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'grm',
        callback = function()
          vim.schedule(function()
            vim.cmd 'syntax clear'

            vim.api.nvim_set_hl(0, 'GrmNonTerminal', { fg = '#FFFFFF' })
            vim.api.nvim_set_hl(0, 'GrmTerminal', { fg = c.literal })
            vim.api.nvim_set_hl(0, 'GrmArrow', { fg = c.light_yellow })

            vim.api.nvim_set_hl(0, 'GrmPipe', { link = 'Operator' })

            vim.cmd [[syntax match GrmTerminal "\<[a-z][a-zA-Z0-9]*\>"]]

            vim.cmd [[syntax match GrmTerminal "[\[\]()<>+= \/&%@#$!~?':;]"]]

            vim.cmd [[syntax match GrmTerminal '"[^"]*"']]

            vim.cmd [[syntax match GrmNonTerminal "\<[A-Z][a-zA-Z0-9]*\>"]]

            vim.cmd [[syntax match GrmArrow "->"]]
            vim.cmd [[syntax match GrmPipe "|"]]
          end)
        end,
      })
    end,
  },
}
