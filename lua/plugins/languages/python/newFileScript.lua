return {
  dir = vim.fn.stdpath 'config',
  name = 'python-boilerplate',
  config = function()
    vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
      pattern = '*.py',
      callback = function()
        local current_file = vim.fn.expand '%:p'
        local filesize = vim.fn.getfsize(current_file)
        if filesize > 0 then
          return
        end

        local filename = vim.fn.expand '%:t:r'
        local current_dir = vim.fs.dirname(current_file)

        -- Look for __init__.py to determine if this is a package
        local is_package = #vim.fs.find('__init__.py', { upward = true, path = current_dir, limit = 1 }) > 0

        -- Build template
        local template = {
          '#!/usr/bin/env python3',
          '"""' .. filename .. ' module."""',
          '',
          '',
          'def main():',
          '    """Entry point for the application script."""',
          '    # TODO: Add your code here',
          '    pass',
          '',
          '',
          'if __name__ == "__main__":',
          '    main()',
        }

        vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
        vim.api.nvim_win_set_cursor(0, { 7, 4 })
      end,
    })
  end,
}
