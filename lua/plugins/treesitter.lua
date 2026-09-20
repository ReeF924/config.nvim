return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,

    build = ":TSUpdate",

    opts = {
      install_dir = vim.fn.stdpath("data") .. "/site",
    },

    config = function(_, opts)
      local ts = require("nvim-treesitter")

      ts.setup(opts)

      local ensure_installed = {
        "bash",
        "c",
        "cpp",
        "c_sharp",
        "css",
        "html",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "vim",
        "vimdoc",
        "javascript",
        "typescript",
      }

      ts.install(ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "bash",
          "c",
          "cpp",
          "cs", -- Neovim filetype; Tree-sitter parser is c_sharp
          "css",
          "html",
          "json",
          "lua",
          "markdown",
          "python",
          "query",
          "vim",
          "vimdoc",
          "javascript",
          "typescript",
        },

        callback = function()
          vim.treesitter.start()

          vim.wo.foldmethod = "expr"
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo[0][0].foldmethod = 'expr'
        end,
      })
    end,
  },
}
