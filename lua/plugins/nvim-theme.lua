return {
  'Mofiqul/adwaita.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'adwaita'

    local colors = {
      call = '#FFE48A',
      decl = '#F1D164',
      operator = '#DC88DA',
      type_blue = '#60C9E1',
      primitive_blue = '#B5F0FC',
      --field_purple = '#B093BF',
      field_purple = '#E2BBF7',
    }

    --function declare colour
    vim.api.nvim_set_hl(0, '@function', { fg = colors.decl })
    vim.api.nvim_set_hl(0, '@method', { fg = colors.decl })

    --function call colour
    vim.api.nvim_set_hl(0, '@function.call', { fg = colors.call })
    vim.api.nvim_set_hl(0, '@method.call', { fg = colors.call })

    -- Operator Highlights
    -- Standard Vim operator group
    vim.api.nvim_set_hl(0, 'Operator', { fg = colors.operator })
    -- Treesitter operator group
    vim.api.nvim_set_hl(0, '@operator', { fg = colors.operator })

    -- Classes, Structs, and Types
    -- In C++, these fall under @type and @type.builtin
    vim.api.nvim_set_hl(0, '@type', { fg = colors.type_blue })
    vim.api.nvim_set_hl(0, '@type.definition', { fg = colors.type_blue })
    vim.api.nvim_set_hl(0, 'StorageClass', { fg = colors.type_blue }) -- For 'struct'/'class' keywords

    -- 4. Simple Data Types (Barely Blue)
    vim.api.nvim_set_hl(0, '@type.builtin', { fg = colors.primitive_blue })
    vim.api.nvim_set_hl(0, 'Type', { fg = colors.primitive_blue })

    -- 5. Class Fields (Members)
    vim.api.nvim_set_hl(0, '@variable.member', { fg = colors.field_purple })
    -- Some languages/versions still use @field
    vim.api.nvim_set_hl(0, '@field', { fg = colors.field_purple })

    -- Specifically for cpp as the above doesn't work for it
    -- Target the high-priority LSP Semantic Tokens directly
    vim.api.nvim_set_hl(0, '@lsp.type.property.cpp', { fg = colors.field_purple })
    -- Also target the complex 'typemod' tokens shown in your Inspect output
    vim.api.nvim_set_hl(0, '@lsp.typemod.property.classScope.cpp', { fg = colors.field_purple })

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

    -- 6. Namespaces (e.g., std::)
    -- The same colour as the keyword class and struct
    vim.api.nvim_set_hl(0, '@lsp.type.namespace.cpp', { link = 'Keyword' })

    -- Treesitter fallback for other languages or if LSP is slow to load
    vim.api.nvim_set_hl(0, '@module', { link = 'Keyword' })
    vim.api.nvim_set_hl(0, '@namespace', { link = 'Keyword' })

    -- ... (your existing namespace highlights) ...
    vim.api.nvim_set_hl(0, '@namespace', { link = 'Keyword' })

    -- Match the neo-tree sidebar background to a slightly darker Adwaita grey
    vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = '#2d2d2d' })
    vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { bg = '#2d2d2d' })

    ---------------------------------------------------------
    -- DEBUGGER (DAP) STYLING
    ---------------------------------------------------------
    -- 1. Define the Highlight Groups
    -- We use the same dark grey background (#31353f) from your previous snippet
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#993939', bg = '#31353f' })
    vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef', bg = '#31353f' })
    vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379', bg = '#31353f', bold = true })

    -- 2. Define the Signs (Icons and Line/Number highlights)
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
  end,
}
