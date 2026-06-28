return {
  dir = vim.fn.stdpath 'config',
  name = 'csharp-boilerplate',
  config = function()
    vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
      pattern = '*.cs',
      callback = function()
        -- Safety Check: Ensure the file is completely empty before adding boilerplate
        local current_file = vim.fn.expand '%:p'
        local filesize = vim.fn.getfsize(current_file)
        if filesize > 0 then
          return
        end

        local filename = vim.fn.expand '%:t:r'
        local current_dir = vim.fs.dirname(current_file)

        -- 1. Look upward for the nearest .csproj file
        local namespace = 'App' -- Default fallback
        local csproj_match = vim.fs.find(function(name, _)
          return name:match '%.csproj$'
        end, { upward = true, path = current_dir, limit = 1 })[1]

        -- 2. If found, calculate the nested namespace
        if csproj_match then
          local csproj_dir = vim.fs.dirname(csproj_match)
          local project_name = vim.fs.basename(csproj_match):gsub('%.csproj$', '')

          if current_dir == csproj_dir then
            -- File is right next to the .csproj file
            namespace = project_name
          else
            -- File is nested in subdirectories. Strip out the base project path.
            local relative_path = current_dir:sub(#csproj_dir + 2)

            -- Convert directory slashes (both / and \) into dots
            local nested_dots = relative_path:gsub('[/\\]', '.')

            namespace = project_name .. '.' .. nested_dots
          end
        end

        -- 3. Construct the template with the dynamic nested namespace
        local template = {
          'namespace ' .. namespace .. ';',
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
