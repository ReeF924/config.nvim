local original_colors = {}
local is_enabled = false

local function toggle_comment_color()
  local groups = { 'Comment' }
  local new_fg = '#56ad00' -- bright green

  if not is_enabled then
    -- Enable custom comment color, saving original fg values
    for _, group in ipairs(groups) do
      if original_colors[group] == nil then
        local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
        original_colors[group] = hl.fg
      end
      vim.api.nvim_set_hl(0, group, { fg = new_fg })
    end
    is_enabled = true
  else
    -- Restore original comment colors
    for _, group in ipairs(groups) do
      if original_colors[group] ~= nil then
        vim.api.nvim_set_hl(0, group, { fg = original_colors[group] })
      else
        vim.cmd('hi clear ' .. group)
      end
    end
    is_enabled = false
  end
end

return toggle_comment_color
