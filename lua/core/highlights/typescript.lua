local c = require 'core.pallete'

local ts_hl = {
  ['@lsp.type.class.typescript'] = { fg = c.type_blue },
  ['@lsp.type.interface.typescript'] = { fg = c.type_blue },
  ['@lsp.type.enum.typescript'] = { link = 'Structure' },
  ['@lsp.type.type.typescript'] = { fg = c.primitive_blue },
  ['@lsp.type.typeParameter.typescript'] = { fg = c.primitive_blue },
  ['@lsp.type.function.typescript'] = { fg = c.method_yellow },
  ['@lsp.type.method.typescript'] = { fg = c.method_yellow },
  ['@lsp.typemod.method.declaration.typescript'] = { fg = c.method_yellow },
  ['@lsp.type.property.typescript'] = { fg = c.field_purple },
  ['@lsp.typemod.property.declaration.typescript'] = { fg = c.field_purple },
  ['@lsp.typemod.parameter.declaration.typescript'] = { fg = c.adwaita_white },
  ['@lsp.mod.local.typescript'] = { fg = c.adwaita_white },
  ['@lsp.type.modifier.typescript'] = { fg = c.blue_gray },
  ['@lsp.typemod.type.defaultLibrary.typescript'] = { fg = c.primitive_blue },
  ['@lsp.typemod.variable.defaultLibrary.typescript'] = { fg = c.primitive_blue },
  ['@lsp.typemod.variable.global.typescript'] = { fg = c.primitive_blue },
  ['@namespace'] = { link = '@parameter' },
  ['@variable.member'] = { fg = c.field_purple },
  ['@variable.builtin'] = { fg = c.primitive_blue },
  ['@type.builtin'] = { fg = c.primitive_blue },
}

return ts_hl
