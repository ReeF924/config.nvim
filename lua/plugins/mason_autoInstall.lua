return {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  dependencies = {
    'williamboman/mason.nvim',
  },
  config = function()
    require('mason-tool-installer').setup {
      -- List the tools you want Mason to install automatically
      ensure_installed = {
        -- Formatters
        'prettier',
        'clang-format',
        'stylua',

        -- Linters
        'tidy',
        'markdownlint',
        'vtsls',

        -- LSP Servers
        'clangd',
        'lua-language-server',

        -- Dap
        'codelldb',
      },

      -- Run the installer on startup
      auto_install = true,
    }
  end,
}
