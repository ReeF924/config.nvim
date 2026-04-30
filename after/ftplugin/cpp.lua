local c = require 'core.pallete'

-- LSP Semantic Tokens and C++ specific Treesitter
local cpp_hl = {
  ['@variable.member'] = { fg = c.field_purple },
  ['@field'] = { fg = c.field_purple },
  ['@lsp.type.property.cpp'] = { fg = c.field_purple },
  ['@lsp.typemod.property.classScope.cpp'] = { fg = c.field_purple },
  ['@lsp.type.type.cpp'] = { fg = c.primitive_blue },
  ['@lsp.typemod.type.defaultLibrary.cpp'] = { fg = c.primitive_blue },
  ['@lsp.type.builtin.cpp'] = { fg = c.primitive_blue },
  ['@type.builtin.cpp'] = { fg = c.primitive_blue },
}

for group, opts in pairs(cpp_hl) do
  vim.api.nvim_set_hl(0, group, opts)
end
