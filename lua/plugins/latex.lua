-- LaTeX editing with vimtex and vim-dispatch
return {
  -- Modern LaTeX editing with compilation, snippets, and navigation
  {
    'lervag/vimtex',
    ft = 'tex',
    config = function()
      vim.g.vimtex_view_method = 'general'
      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_compiler_latexmk = {
        options = {
          '-pdf',
          '-interaction=nonstopmode',
          '-synctex=1',
        },
      }
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_mappings_enabled = 0
    end,
  },

  -- Async compilation and dispatch
  'tpope/vim-dispatch',
}
