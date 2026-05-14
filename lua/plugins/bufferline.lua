return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    local bufferline = require 'bufferline'

    bufferline.setup {
      options = {
        mode = 'buffers',
        -- 'none' allows us to manually reorder and ensures new files stay at the end
        sort_by = 'none',
        numbers = 'ordinal',
        separator_style = 'slant',
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        diagnostics = 'nvim_lsp',
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            text_align = 'left',
            separator = true,
          },
        },
      },
    }

    local function move_to_ordinal(target_idx)
      local state = require 'bufferline.state'
      local components = state.components
      local current_buf = vim.api.nvim_get_current_buf()

      local current_idx = -1
      for i, component in ipairs(components) do
        if component.id == current_buf then
          current_idx = i
          break
        end
      end

      if current_idx == -1 then
        return
      end

      -- Clamp target index to the actual number of buffers available
      local total_buffers = #components
      if target_idx > total_buffers then
        target_idx = total_buffers
      end

      -- Calculate how many shifts are needed
      local diff = target_idx - current_idx
      if diff > 0 then
        for _ = 1, diff do
          vim.cmd 'BufferLineMoveNext'
        end
      elseif diff < 0 then
        for _ = 1, math.abs(diff) do
          vim.cmd 'BufferLineMovePrev'
        end
      end
    end

    vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { silent = true })
    vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { silent = true })

    for i = 1, 9 do
      vim.keymap.set('n', '<leader>' .. i, function()
        bufferline.go_to(i, true)
      end, { desc = 'Go to buffer ' .. i })
    end
    vim.keymap.set('n', '<leader>0', function()
      bufferline.go_to(10, true)
    end)

    for i = 1, 9 do
      vim.keymap.set('n', '<leader>b' .. i, function()
        move_to_ordinal(i)
      end, { desc = 'Move buffer to pos ' .. i })
    end

    vim.keymap.set('n', '<leader>b0', function()
      move_to_ordinal(10)
    end, { desc = 'Move buffer to pos 10' })

    vim.keymap.set('n', '<leader>x', ':bd<CR>', { desc = 'Close Buffer' })
  end,
}
