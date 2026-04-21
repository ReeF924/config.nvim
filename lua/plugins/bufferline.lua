return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    local bufferline = require 'bufferline'
    require('bufferline').setup {
      options = {
        mode = 'buffers', -- Tabs will represent open files
        numbers = 'ordinal',
        separator_style = 'slant', -- Looks modern (or use "thin", "thick")
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        diagnostics = 'nvim_lsp', -- Shows red/yellow icons if Clangd finds errors
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

    vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { silent = true })
    vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { silent = true })

    -- Jump to specific buffer index using <leader>1-9
    for i = 1, 9 do
      vim.keymap.set('n', '<leader>' .. i, function()
        bufferline.go_to(i, true)
      end)
    end

    -- <leader>0 for the 10th buffer
    vim.keymap.set('n', '<leader>0', function()
      bufferline.go_to(10, true)
    end)

    -- Close buffer
    vim.keymap.set('n', '<leader>x', ':bd<CR>', { desc = 'Close Buffer' })
  end,
}
