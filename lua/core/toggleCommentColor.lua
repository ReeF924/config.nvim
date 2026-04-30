local original_colors = {}

local function toggle_comment_color()
  local target_green = 5680384
  local groups = { 'Comment', '@comment' }
  local first_hl = vim.api.nvim_get_hl(0, { name = groups[1], link = false })
  local is_turning_on = (first_hl.fg ~= target_green)

  for _, group in ipairs(groups) do
    if is_turning_on then
      if not original_colors[group] then
        original_colors[group] = vim.api.nvim_get_hl(0, { name = group, link = false }).fg
      end
      vim.api.nvim_set_hl(0, group, { fg = '#56ad00' })
    else
      if original_colors[group] then
        vim.api.nvim_set_hl(0, group, { fg = original_colors[group] })
      else
        vim.cmd('hi clear ' .. group)
      end
    end
  end
end

return toggle_comment_color
