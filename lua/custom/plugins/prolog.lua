return {
  -- 1. Syntax Highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        table.insert(opts.ensure_installed, 'prolog')
      end
    end,
  },

  -- 2. LSP Setup
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        prolog_ls = {
          -- This forces the LSP to start even for single files
          root_dir = function(fname)
            return require('lspconfig.util').find_git_ancestor(fname) or vim.loop.cwd()
          end,
          settings = {},
        },
      },
    },
  },
}
