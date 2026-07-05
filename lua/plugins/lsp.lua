return {
  -- lazydev configures Lua LSP for your Neovim config, runtime and plugins
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- Main LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      vim.diagnostic.config {
        update_in_insert = true,
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- Set up capabilities for blink.cmp
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Custom Clangd command fallback logic
      local function clangd_cmd(dispatchers, config)
        local bufname = vim.api.nvim_buf_get_name(0)
        local start_dir = (bufname ~= '' and vim.fs.dirname(bufname)) or (config and config.root_dir) or vim.fn.getcwd()
        local has_project_config = vim.fs.find('.clangd', { upward = true, path = start_dir })[1] ~= nil

        local cmd = {
          'clangd',
          '--background-index',
          '--clang-tidy',
          '--header-insertion=iwyu',
          '--completion-style=detailed',
          '--function-arg-placeholders=true',
          '--fallback-style=llvm',
        }

        local spawn_opts = {}
        if not has_project_config then
          spawn_opts.env = {
            XDG_CONFIG_HOME = vim.fn.stdpath 'config' .. '/lspConfigs/clangd-fallback',
          }
        end

        return vim.lsp.rpc.start(cmd, dispatchers, spawn_opts)
      end

      -- Define LSP server configurations
      local servers = {
        clangd = {
          cmd = clangd_cmd,
          init_options = {},
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
            },
          },
        },
        vtsls = {
          settings = {
            typescript = {
              updateImportsOnFileMove = { enabled = 'always' },
              suggest = { completeFunctionCalls = true },
              inlayHints = {
                parameterNames = { enabled = 'all' },
                variableTypes = { enabled = true },
              },
            },
          },
        },
        roslyn_ls = {
          on_attach = function(client, bufnr)
            local last_diag_time = {}
            local debounce_ms = 100
            
            client.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx)
              if err then
                return
              end
              local buf = ctx.bufnr ~= 0 and ctx.bufnr or vim.api.nvim_get_current_buf()
              local now = vim.loop.now()
              local last_time = last_diag_time[buf] or 0
              
              if now - last_time < debounce_ms then
                return
              end
              last_diag_time[buf] = now
              
              vim.schedule(function()
                vim.diagnostic.set(client, buf, result.diagnostics or {})
              end)
            end
          end,
        },
      }

      -- Combine LSPs from above with all your extra non-LSP tools
      local ensure_installed = vim.tbl_keys(servers)
      vim.list_extend(ensure_installed, {
        -- Formatters
        'prettier',
        'clang-format',
        'stylua',
        'csharpier',

        -- Linters
        'markdownlint',

        -- DAPs
        'codelldb',
        'js-debug-adapter',
        'netcoredbg',
        'roslyn-language-server',
      })

      -- Initialize Tool Installer
      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
        run_on_start = true,
      }

      -- Initialize LSPs (Compatible with Neovim 0.11+)
      for server_name, server_opts in pairs(servers) do
        server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})
        vim.lsp.config(server_name, server_opts)
      end

      -- Initialize the Mason-LSPConfig bridge
      require('mason-lspconfig').setup {
        ensure_installed = {},
      }
    end,
  },
}
