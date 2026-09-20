local function apply(groups)
  for group, opts in pairs(groups) do
    if opts.bold == nil then
      opts.bold = false
    end

    if opts.italic == nil then
      opts.italic = false
    end


    vim.api.nvim_set_hl(0, group, opts)
  end
end

local function apply_highlights()
  -- Apply global highlights first
  apply(require 'core.highlights.global')

  -- Language‑specific highlight modules
  local ft_modules = {
    tex = 'core.highlights.tex',
    cpp = 'core.highlights.cpp',
    typescript = 'core.highlights.typescript',
    python = 'core.highlights.python',
    cs = 'core.highlights.cs',
  }

  -- Apply highlights for the current buffer's filetype (if any)
  local cur_ft = vim.bo.filetype
  if ft_modules[cur_ft] then
    apply(require(ft_modules[cur_ft]))
  end

  -- Ensure future buffers get their language‑specific highlights on FileType
  vim.api.nvim_create_autocmd('FileType', {
    pattern = vim.tbl_keys(ft_modules),
    callback = function()
      local ft = vim.bo.filetype
      local mod = ft_modules[ft]
      if mod then
        apply(require(mod))
      end
    end,
  })
end

return {
  apply = apply_highlights,
}
