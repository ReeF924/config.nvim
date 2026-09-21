local c = require 'core.pallete'

local python_hl = {
  ['@lsp.type.function.python'] = { fg = c.method_yellow },
  ['@lsp.type.method.python'] = { fg = c.method_yellow },
  ['@lsp.type.parameter.python'] = { fg = c.type_blue },
  ['@lsp.type.variable.python'] = { fg = c.adwaita_white },
  ['@lsp.type.class.python'] = { fg = c.type_blue },
  ['@lsp.type.type.python'] = { fg = c.type_blue },
  ['@lsp.type.decorator.python'] = { fg = c.method_yellow },
  ['@lsp.type.property.python'] = { fg = c.field_purple },

  ['@module'] = { fg = c.adwaita_white },
  ['@namespace'] = { fg = c.adwaita_white },
  ['@decorator'] = { fg = c.method_yellow },
  ['@attribute.builtin.python'] = { link = '@attribute' },


  ['@function.builtin.python'] = { fg = c.method_yellow },
  ['@keyword.operator.python'] = { fg = c.operator },

  ['@keyword.function.python'] = { fg = c.dark_blue_gray },

  ['@keyword.coroutine.python'] = { fg = c.dark_blue_gray },


}

return python_hl
