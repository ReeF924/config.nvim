return {
  -- nvim-foldsign: Visual indicators in the gutter
  {
    'yaocccc/nvim-foldsign',
    event = 'CursorHold',
    config = function()
      -- The author named the internal module 'foldsign'
      -- If 'require' fails, we wrap it in a pcall to prevent the error screen
      local ok, foldsign = pcall(require, 'foldsign')
      if ok then
        foldsign.setup {
          closed = '',
          opened = '',
        }
      end
    end,
  },
  -- nvim-ufo: The folding engine
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Custom handler to show line count and custom text
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ('  󰁂 %d lines folded '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              table.insert(newVirtText, { (' '):rep(targetWidth - curWidth - chunkWidth), 'UfoFoldedEllipsis' })
            end
            curWidth = targetWidth
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end

      -- Using ufo with LSP
      require('ufo').setup {
        fold_virt_text_handler = handler,
        provider_selector = function(bufnr, filetype, buftype)
          return { 'lsp', 'indent' }
        end,
      }

      -- Standard UFO Keymaps
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
      vim.keymap.set('n', 'zp', function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = 'Peek Fold' })

      -- Fold ONLY methods (Uses LSP to perfectly identify methods)
      vim.keymap.set('n', 'zm', function()
        require('ufo').openAllFolds() -- Reset state
        local bufnr = vim.api.nvim_get_current_buf()
        local params = { textDocument = vim.lsp.util.make_text_document_params() }

        -- Ask the LSP exactly where the methods and functions are
        vim.lsp.buf_request(bufnr, 'textDocument/documentSymbol', params, function(err, result)
          if err or not result then
            vim.notify('LSP symbols not ready yet', vim.log.levels.WARN)
            return
          end

          local method_lines = {}
          local function get_methods(symbols)
            for _, sym in ipairs(symbols) do
              -- LSP Kind 6 is Method, Kind 12 is Function
              if sym.kind == 6 or sym.kind == 12 then
                table.insert(method_lines, sym.range.start.line)
              end
              if sym.children then
                get_methods(sym.children)
              end
            end
          end
          get_methods(result)

          -- Match the LSP method lines to UFO folds and close them
          require('ufo').getFolds(bufnr, 'lsp'):thenCall(function(ranges)
            if not ranges then
              return
            end
            for _, range in ipairs(ranges) do
              for _, m_line in ipairs(method_lines) do
                -- Allow 1 line difference for variations in how LSP/UFO count annotations
                if math.abs(range.startLine - m_line) <= 1 then
                  pcall(function()
                    vim.cmd((range.startLine + 1) .. 'foldclose')
                  end)
                  break
                end
              end
            end
          end)
        end)
      end, { desc = 'Fold ONLY methods (Entire File)' })

      -- Fold INNER blocks >= 10 lines (Current block stays OPEN)
      vim.keymap.set('n', 'zn', function() -- 'zn' for 'Inner' or 'Next' level
        local ufo = require 'ufo'
        local bufnr = vim.api.nvim_get_current_buf()
        local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1

        ufo.getFolds(bufnr, 'lsp'):thenCall(function(ranges)
          if not ranges then
            return
          end

          -- Find the block the cursor is currently inside
          local current_block = nil
          local min_size = math.huge
          for _, range in ipairs(ranges) do
            if cursor_line >= range.startLine and cursor_line <= range.endLine then
              local size = range.endLine - range.startLine
              if size < min_size then
                min_size = size
                current_block = range
              end
            end
          end

          if not current_block then
            return
          end

          -- Sort bottom-up
          table.sort(ranges, function(a, b)
            return a.startLine > b.startLine
          end)

          for _, range in ipairs(ranges) do
            -- Only fold if it's INSIDE the current block, but NOT the current block itself
            if range.startLine >= current_block.startLine and range.endLine <= current_block.endLine then
              if range.startLine ~= current_block.startLine then -- This skips the top-level block
                if (range.endLine - range.startLine + 1) >= 10 then
                  pcall(function()
                    vim.cmd((range.startLine + 1) .. 'foldclose')
                  end)
                end
              end
            end
          end
        end)
      end, { desc = 'Fold 10+ line blocks inside current block' })

      -- Fold blocks >= 10 lines ONLY in the CURRENT block (where your cursor is)
      vim.keymap.set('n', 'zN', function()
        local ufo = require 'ufo'
        local bufnr = vim.api.nvim_get_current_buf()
        local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1

        ufo.getFolds(bufnr, 'lsp'):thenCall(function(ranges)
          if not ranges then
            return
          end

          -- Find the tightest fold block that currently contains your cursor
          local current_block = nil
          local min_size = math.huge
          for _, range in ipairs(ranges) do
            if cursor_line >= range.startLine and cursor_line <= range.endLine then
              local size = range.endLine - range.startLine
              if size < min_size then
                min_size = size
                current_block = range
              end
            end
          end

          if not current_block then
            return
          end

          -- Sort bottom-up so inner blocks close before outer ones
          table.sort(ranges, function(a, b)
            return a.startLine > b.startLine
          end)

          for _, range in ipairs(ranges) do
            -- Check if this fold is strictly inside our current block
            if range.startLine >= current_block.startLine and range.endLine <= current_block.endLine then
              if (range.endLine - range.startLine + 1) >= 10 then
                pcall(function()
                  vim.cmd((range.startLine + 1) .. 'foldclose')
                end)
              end
            end
          end
        end)
      end, { desc = 'Fold >= 10 lines in current block (including cur. block)' })

      -- Fold blocks >= 10 lines for the ENTIRE FILE
      vim.keymap.set('n', 'zr', function()
        local ufo = require 'ufo'
        ufo.openAllFolds() -- Reset state
        local bufnr = vim.api.nvim_get_current_buf()

        ufo.getFolds(bufnr, 'lsp'):thenCall(function(ranges)
          if not ranges then
            return
          end

          table.sort(ranges, function(a, b)
            return a.startLine > b.startLine
          end)

          for _, range in ipairs(ranges) do
            if (range.endLine - range.startLine + 1) >= 10 then
              pcall(function()
                vim.cmd((range.startLine + 1) .. 'foldclose')
              end)
            end
          end
        end)
      end, { desc = 'Fold >= 10 lines in entire file' })

      -- Undo for zr/zn: Recursively OPEN all folds in the current block
      vim.keymap.set('n', 'zx', function()
        local ufo = require 'ufo'
        local bufnr = vim.api.nvim_get_current_buf()
        local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1

        ufo.getFolds(bufnr, 'lsp'):thenCall(function(ranges)
          if not ranges then
            return
          end

          -- Find the block the cursor is currently inside
          local current_block = nil
          local min_size = math.huge
          for _, range in ipairs(ranges) do
            if cursor_line >= range.startLine and cursor_line <= range.endLine then
              local size = range.endLine - range.startLine
              if size < min_size then
                min_size = size
                current_block = range
              end
            end
          end

          if not current_block then
            -- If not in a specific block, just open the fold under cursor
            vim.cmd 'normal! zO'
            return
          end

          -- Open everything within the range of the current block
          for _, range in ipairs(ranges) do
            if range.startLine >= current_block.startLine and range.endLine <= current_block.endLine then
              pcall(function()
                vim.cmd((range.startLine + 1) .. 'foldopen')
              end)
            end
          end
        end)
      end, { desc = 'Undo zr/zn (Open all folds in current block)' })
    end,
  },
}
