return {
  'Mofiqul/adwaita.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'adwaita'

    local c = require 'core.pallete'
    --By default keywords are bold, undo that
    local unbold_groups = {
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
    for _, group in ipairs(unbold_groups) do
      local current_hl = vim.api.nvim_get_hl(0, { name = group, link = false })
      vim.api.nvim_set_hl(0, group, {
        fg = current_hl.fg,
        bold = false,
        italic = false,
      })
    end

    local global_hl = {
      ['@function'] = { fg = c.method_yellow },
      ['@method'] = { fg = c.method_yellow },
      ['@function.call'] = { fg = c.method_yellow },
      ['@method.call'] = { fg = c.method_yellow },

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
    -- Define the Highlight Groups (signs are defined in debug.lua)
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#993939', bg = '#31353f' })
    vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef', bg = '#31353f' })
    vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379', bg = '#31353f', bold = true })

    local togglefunc = require 'core.toggleCommentColor'

    vim.keymap.set('n', '<leader>tc', togglefunc, { desc = 'Toggle Comment Color (All Languages)' })
  end,
}
