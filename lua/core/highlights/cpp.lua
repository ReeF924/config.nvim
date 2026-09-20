local c = require 'core.pallete'

local cpp_hl = {
  ['@variable.member'] = { fg = c.field_purple },
  ['@field'] = { fg = c.field_purple },
  ['@lsp.type.property.cpp'] = { fg = c.field_purple },
  ['@lsp.typemod.property.classScope.cpp'] = { fg = c.field_purple },
  ['@lsp.type.modifier.cpp'] = { fg = c.primitive_blue},
  ['@lsp.type.type.cpp'] = { fg = c.primitive_blue },
  ['@lsp.typemod.type.defaultLibrary.cpp'] = { fg = c.primitive_blue },
  ['@lsp.type.builtin.cpp'] = { fg = c.primitive_blue },
  ['@type.builtin.cpp'] = { fg = c.primitive_blue },
}

return cpp_hl
