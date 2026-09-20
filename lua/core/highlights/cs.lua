local c = require 'core.pallete'

local cs_hl = {
  ['@lsp.type.extensionMethod.cs'] = { link = '@function' },
  ['@lsp.type.property.cs'] = { fg = c.field_purple },
  ['@lsp.type.field.cs'] = { fg = c.field_purple },
  ['@lsp.typemod.property.classScope.cs'] = { fg = c.field_purple },
  ['@namespace'] = { link = '@parameter' },
  ['@keyword.coroutine.c_sharp'] = { fg = c.dark_blue_gray },
  ['@keyword.type.c_sharp'] = { fg = c.dark_green },
  ['@keyword.operator.c_sharp'] = { fg = c.operator },

  ['@keyword.conditional.ternary.c_sharp'] = { fg = c.adwaita_white },
  ['@keyword.c_sharp'] = { fg = c.primitive_blue },
  ['@keyword.modifier.c_sharp'] = { fg = c.dark_blue_gray },


}

return cs_hl
