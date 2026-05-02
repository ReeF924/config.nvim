return {
  'Mofiqul/adwaita.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'adwaita'

    local c = require 'core.pallete'
    --By default keywords are bold, undo that
    local keyword_groups = {
      'Keyword',
      '@keyword',
      'Conditional', -- if, else
      '@keyword.conditional',
      'Repeat', -- for, while
      '@keyword.repeat',
      'Statement', -- return, break
      '@keyword.return',
      'Exception',
      'StorageClass',
      '@type.qualifier',
      '@keyword.modifier',
    }

    -- Default for these keywords is bold, turn that off
    for _, group in ipairs(keyword_groups) do
      local current_hl = vim.api.nvim_get_hl(0, { name = group, link = false })
      vim.api.nvim_set_hl(0, group, {
        fg = current_hl.fg,
        bold = false,
        italic = false,
      })
    end

    local global_hl = {
      ['@function'] = { fg = c.meth },
      ['@method'] = { fg = c.meth },
      ['@function.call'] = { fg = c.meth },
      ['@method.call'] = { fg = c.meth },

      ['Operator'] = { fg = c.operator },
      ['@operator'] = { fg = c.operator },

      ['StorageClass'] = { fg = c.primitive_blue },
      ['@type.qualifier'] = { fg = c.primitive_blue },
      ['@keyword.modifier'] = { fg = c.primitive_blue },

      ['@type'] = { fg = c.type_blue },
      ['Type'] = { fg = c.primitive_blue },
      ['@type.builtin'] = { fg = c.primitive_blue },

      ['Constant'] = { fg = c.literal },

      ['MatchParen'] = { link = 'Visual' },

      ['NeoTreeNormal'] = { bg = c.bg_dark },
      ['NeoTreeNormalNC'] = { bg = c.bg_dark },

      ['@variable.member'] = { fg = c.field_purple },

      ['Number'] = { link = 'Constant' },
      ['@number'] = { link = 'Constant' },
      ['Boolean'] = { link = 'Constant' },
      ['@boolean'] = { link = 'Constant' },
    }

    for group, opts in pairs(global_hl) do
      vim.api.nvim_set_hl(0, group, opts)
    end

    -- DEBUGGER (DAP) STYLING
    -- Define the Highlight Groups
    -- We use the same dark grey background (#31353f) from your previous snippet
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#993939', bg = '#31353f' })
    vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef', bg = '#31353f' })
    vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379', bg = '#31353f', bold = true })

    -- Define the Signs (Icons and Line/Number highlights)
    -- 'linehl' is what colors the background of the entire row
    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition', { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = '', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = '', numhl = 'DapLogPoint' })

    -- For the active line (Stopped), we apply the background to 'linehl'
    vim.fn.sign_define('DapStopped', {
      text = '',
      texthl = 'DapStopped',
      linehl = 'DapStopped', -- This creates the highlight bar
      numhl = 'DapStopped',
    })

    local togglefunc = require 'core.toggleCommentColor'

    vim.keymap.set('n', '<leader>tc', togglefunc, { desc = 'Toggle Comment Color (All Languages)' })
  end,
}
