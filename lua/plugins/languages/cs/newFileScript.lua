return {
  dir = vim.fn.stdpath 'config',
  name = 'csharp-boilerplate',
  -- 'config' tells lazy to run this function automatically when Neovim starts up
  config = function()
    vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
      pattern = '*.cs',
      callback = function()
        -- Safety Check: Ensure the file is completely empty before adding boilerplate
        local filesize = vim.fn.getfsize(vim.fn.expand '%:p')
        if filesize > 0 then
          return
        end

        local filename = vim.fn.expand '%:t:r'

        local template = {
          'namespace App;',
          '',
          'public class ' .. filename,
          '{',
          '    ',
          '}',
        }

        vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
        vim.api.nvim_win_set_cursor(0, { 5, 4 })
      end,
    })
  end,
}
