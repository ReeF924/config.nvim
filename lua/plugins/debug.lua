-- debug.lua
return {

  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },
  keys = {
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<F4>',
      function()
        require('dap').terminate()
        require('dapui').close()
        -- This ensures the internal state is cleared even if the process is a zombie
        require('dap').disconnect { terminateDebuggee = true }
      end,
      desc = 'Debug: Stop and Close UI',
    },
    {
      '<F5>',
      function()
        local dap = require 'dap'
        -- If a session is already active, just continue
        if dap.session() then
          dap.continue()
          return
        end

        -- Otherwise, find and run the "Standard" config automatically
        local ft = vim.bo.filetype
        local configs = dap.configurations[ft]
        if configs then
          for _, config in ipairs(configs) do
            if config.name == 'Launch file' then
              dap.run(config)
              return
            end
          end
        end

        -- Fallback if specific name isn't found
        dap.continue()
      end,
      desc = 'Debug: Start Standard / Continue',
    },
    {
      '<F6>',
      function()
        local dap = require 'dap'
        -- 1. Ensure configurations are loaded for the current filetype
        local ft = vim.bo.filetype
        local configs = dap.configurations[ft]

        if not configs then
          print('No debug configurations found for ' .. ft)
          return
        end

        -- 2. Find the specific config by name
        local target = nil
        for _, config in ipairs(configs) do
          if config.name == 'Launch with Stdin Redirection' then
            target = config
            break
          end
        end

        -- 3. Run it specifically, or fallback to standard continue if not found
        if target then
          dap.run(target)
        else
          print 'Stdin config not found! Falling back to standard menu...'
          dap.continue()
        end
      end,
      desc = 'Debug: Run with Stdin (< file)',
    },
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },

  config = function()
    -- Custom function to toggle between Console and Scopes
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'codelldb',
        'js-debug-adapter',
      },
    }

    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        -- We use absolute path expansion to be safe
        command = vim.fn.expand '$HOME' .. '/.local/share/nvim/mason/bin/codelldb',
        args = { '--port', '${port}' },
      },
    }

    -- Adapter configuration for Node/JS/TS
    -- NOTE: typecript files have to have "sourceMap": true in tsconfig.json
    if not dap.adapters['pwa-node'] then
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          -- This path is where Mason installs the js-debug-adapter
          args = {
            vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
            '${port}',
          },
        },
      }
    end
    -- Custom function to toggle between Console and Scopes
    local function toggle_console_scopes()
      local wins = vim.api.nvim_tabpage_list_wins(0)
      local console_win = nil
      local scopes_win = nil

      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local name = vim.api.nvim_buf_get_name(buf)
        if name:match 'DAP Console' then
          console_win = win
        end
        if name:match 'DAP Scopes' then
          scopes_win = win
        end
      end

      -- If we are in the console, go to scopes. If in scopes, go to console.
      local cur_win = vim.api.nvim_get_current_win()
      if cur_win == console_win and scopes_win then
        vim.api.nvim_set_current_win(scopes_win)
      elseif cur_win == scopes_win and console_win then
        vim.api.nvim_set_current_win(console_win)
      elseif console_win then
        vim.api.nvim_set_current_win(console_win)
      end

      -- Optional: Maximize the current window to "hide" the other
      vim.cmd 'vertical resize' -- Reset sizes
      vim.cmd 'resize'
      -- If you want it to truly "hide" the other, you can use:
      -- vim.api.nvim_win_set_height(0, 15)
    end
    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {

      layouts = {
        {
          elements = {
            -- Elements for the left sidebar
            { id = 'stacks', size = 0.25 },
            { id = 'breakpoints', size = 0.25 },
            { id = 'repl', size = 0.5 },
          },
          size = 40, -- This makes the left sidebar 40 columns wide
          position = 'left',
        },
        {
          elements = {
            { id = 'scopes', size = 0.75 },
            { id = 'watches', size = 0.25 },
          },
          size = 16,
          position = 'bottom',
        },
      },

      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.configurations.cpp = {
      {
        -- WARN: if this name is changed, it must be changed in the keys array too
        name = 'Launch file',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        console = 'integratedTerminal',
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        setupCommands = {
          {
            text = '-enable-pretty-printing',
            description = 'enable pretty printing',
            ignoreFailures = false,
          },
        },
      },
      {
        -- WARN: if this name is changed, it must be changed in the keys array too
        name = 'Launch with Stdin Redirection',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        stdio = function()
          local input_file = vim.fn.input('Path to input file: ', vim.fn.getcwd() .. '/', 'file')
          if input_file ~= '' and input_file ~= vim.fn.getcwd() .. '/' then
            return { input_file, nil, nil }
          end
          return nil
        end,
        console = 'integratedTerminal',
      },
    }

    local js_config = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Current File (Node.js)',
        program = '${file}',
        cwd = '${workspaceFolder}',
        sourceMaps = true, -- Crucial for TypeScript!
        protocol = 'inspector',
        console = 'integratedTerminal',
      },
      {
        type = 'pwa-node',
        request = 'attach',
        name = 'Attach to Process',
        processId = require('dap.utils').pick_process,
        cwd = '${workspaceFolder}',
      },
    }

    -- Apply the config to the relevant filetypes
    dap.configurations.javascript = js_config
    dap.configurations.typescript = js_config

    -- Support C and Rust too since they use the same debugger
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
