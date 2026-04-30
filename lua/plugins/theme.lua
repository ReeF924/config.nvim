return {
  'Mofiqul/adwaita.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'adwaita'

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
      'Exception', -- try, catch
    }

    for _, group in ipairs(keyword_groups) do
      -- We get the current color of the group so we don't change the actual color,
      -- then we force bold to false.
      local current_hl = vim.api.nvim_get_hl(0, { name = group, link = false })
      vim.api.nvim_set_hl(0, group, {
        fg = current_hl.fg,
        bold = false,
        italic = false, -- Optional: set to true if you prefer italics over bold
      })
    end

    local colours = {
      --call = '#FFE48A',
      meth = '#F1D164',
      operator = '#DC88DA',
      type_blue = '#60C9E1',
      primitive_blue = '#A1EDFC',
      --field_purple = '#B093BF',
      field_purple = '#E2BBF7',
      literal = '#9fabf4',
    }

    --function declare colour
    vim.api.nvim_set_hl(0, '@function', { fg = colours.meth })
    vim.api.nvim_set_hl(0, '@method', { fg = colours.meth })

    --function call colour
    vim.api.nvim_set_hl(0, '@function.call', { fg = colours.meth })
    vim.api.nvim_set_hl(0, '@method.call', { fg = colours.meth })

    -- Operator Highlights
    -- Standard Vim operator group
    vim.api.nvim_set_hl(0, 'Operator', { fg = colours.operator })
    -- Treesitter operator group
    vim.api.nvim_set_hl(0, '@operator', { fg = colours.operator })

    -- Classes, Structs, and Types
    -- In C++, these fall under @type and @type.builtin
    vim.api.nvim_set_hl(0, '@type', { fg = colours.type_blue })
    vim.api.nvim_set_hl(0, '@type.definition', { fg = colours.type_blue })
    vim.api.nvim_set_hl(0, 'StorageClass', { fg = colours.type_blue }) -- For 'struct'/'class' keywords

    -- Simple Data Types (Barely Blue)
    vim.api.nvim_set_hl(0, '@type.builtin', { fg = colours.primitive_blue })
    vim.api.nvim_set_hl(0, 'Type', { fg = colours.primitive_blue })

    -- Class Fields (Members)
    vim.api.nvim_set_hl(0, '@variable.member', { fg = colours.field_purple })
    -- Some languages/versions still use @field
    vim.api.nvim_set_hl(0, '@field', { fg = colours.field_purple })

    -- Specifically for cpp as the above doesn't work for it
    -- Target the high-priority LSP Semantic Tokens directly
    vim.api.nvim_set_hl(0, '@lsp.type.property.cpp', { fg = colours.field_purple })
    -- Also target the complex 'typemod' tokens shown in your Inspect output
    vim.api.nvim_set_hl(0, '@lsp.typemod.property.classScope.cpp', { fg = colours.field_purple })

    -- Match the neo-tree sidebar background to a slightly darker Adwaita grey
    vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = '#2d2d2d' })
    vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { bg = '#2d2d2d' })

    -- Change the matchparen highlight to look like Visual mode
    vim.api.nvim_set_hl(0, 'MatchParen', { link = 'Visual' })

    -- General Constants (Numbers, etc.)
    vim.api.nvim_set_hl(0, 'Constant', { fg = colours.literal })
    vim.api.nvim_set_hl(0, '@constant', { link = 'Constant' })
    -- 2. Numbers
    vim.api.nvim_set_hl(0, 'Number', { link = 'Constant' })
    vim.api.nvim_set_hl(0, '@number', { link = 'Constant' })
    vim.api.nvim_set_hl(0, '@number.float', { link = 'Constant' })

    -- Boolean Literals
    vim.api.nvim_set_hl(0, '@boolean', { link = 'Constant' })
    vim.api.nvim_set_hl(0, 'Boolean', { link = 'Constant' })

    -- Fix for size_t, uint32_t, and other standard types
    -- clangd labels these as "type" but with the "defaultLibrary" modifier
    vim.api.nvim_set_hl(0, '@lsp.type.type.cpp', { fg = colours.primitive_blue })
    vim.api.nvim_set_hl(0, '@lsp.typemod.type.defaultLibrary.cpp', { fg = colours.primitive_blue })

    -- Fix for auto* and auto&
    -- Treesitter often splits 'auto' and '*' - we ensure both stay primitive_blue
    -- or that the LSP type for the variable remains consistent.
    vim.api.nvim_set_hl(0, '@lsp.type.builtin.cpp', { fg = colours.primitive_blue })

    -- This targets the '*' when it is part of a type declaration in C++
    vim.api.nvim_set_hl(0, '@type.builtin.cpp', { fg = colours.primitive_blue })

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

    local original_colors = {}

    local function toggle_comment_color()
      -- The custom green in decimal
      local target_green = 5680384

      -- Groups to toggle
      local groups = { 'Comment', '@comment' }

      -- Check the first group to decide if we are turning it ON or OFF
      local first_hl = vim.api.nvim_get_hl(0, { name = groups[1], link = false })
      local is_turning_on = (first_hl.fg ~= target_green)

      for _, group in ipairs(groups) do
        if is_turning_on then
          -- Save the original color if we haven't yet
          if not original_colors[group] then
            local current_hl = vim.api.nvim_get_hl(0, { name = group, link = false })
            original_colors[group] = current_hl.fg
          end
          -- Apply custom green
          vim.api.nvim_set_hl(0, group, { fg = '#56ad00' })
        else
          -- Restore original color
          if original_colors[group] then
            vim.api.nvim_set_hl(0, group, { fg = original_colors[group] })
          else
            -- Fallback if we somehow lost the original (resets to theme)
            vim.cmd('hi clear ' .. group)
          end
        end
      end
    end

    vim.keymap.set('n', '<leader>tc', toggle_comment_color, { desc = 'Toggle Comment Color (All Languages)' })
  end,
}
