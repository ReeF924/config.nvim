local c = require 'core.pallete'

local scala_hl = {
  -- Modifiers and qualifiers
  ['@keyword.modifier.scala'] = { fg = c.dark_blue_grey },
  ['@type.qualifier.scala']   = { fg = c.dark_blue_grey },
  ['@operator.scala']          = { link = '@operator' },
  -- def (function definition) – not bold
  ['@keyword.function.scala'] = { fg = c.adwaita_orange, bold = false },
  -- new – not bold
  ['@keyword.operator.scala'] = { fg = c.adwaita_orange, bold = false },
  -- Float literals – same colour as other literals
  ['@number.float']            = { fg = c.literal },
  ['@number.float.scala']      = { fg = c.literal },

  -- Parameters and argument names (the identifier, not its type)
  ['@parameter']               = { fg = c.adwaita_white },
  ['@variable.parameter']      = { fg = c.adwaita_white },
}


return scala_hl
