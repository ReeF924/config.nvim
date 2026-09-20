local c = require 'core.pallete'

local tex_hl = {
  ['Statement'] = { fg = c.primitive_blue },
  ['Type'] = { fg = c.type_blue },
  ['PreCondit'] = { fg = c.dark_green, bold = true },
  ['Identifier'] = { fg = c.literal },
  ['Special'] = { fg = c.method_yellow },
  ['SpecialChar'] = { fg = c.adwaita_orange, bold = true },
  ['Delimiter'] = { fg = c.operator },
}

return tex_hl
