local c = require 'core.pallete'

return {
  -- Keywords
  ['@keyword'] = {
    fg = c.adwaita_orange,
  },

  ['@keyword.conditional'] = {
    fg = c.adwaita_orange,
  },

  ['@keyword.repeat'] = {
    fg = c.adwaita_orange,
  },

  ['@keyword.return'] = {
    fg = c.adwaita_orange,
  },

  ['@keyword.exception'] = {
    fg = c.adwaita_orange,
  },

  ['@keyword.modifier'] = {
    fg = c.primitive_blue,
  },

  ['@type.qualifier'] = {
    fg = c.primitive_blue,
  },

  -- Functions / methods
  ['@function'] = {
    fg = c.method_yellow,
  },

  ['@function.call'] = {
    fg = c.method_yellow,
  },

  ['@function.method'] = {
    fg = c.method_yellow,
  },

  ['@function.method.call'] = {
    fg = c.method_yellow,
  },

  ['@method'] = {
    fg = c.method_yellow,
  },

  ['@method.call'] = {
    fg = c.method_yellow,
  },

  -- Types
  ['@type'] = {
    fg = c.type_blue,
  },

  ['@type.builtin'] = {
    fg = c.primitive_blue,
  },

  -- Variables
  ['@variable'] = {
    fg = c.adwaita_white,
  },

  ['@variable.builtin'] = {
    fg = c.primitive_blue,
  },

  ['@variable.parameter'] = {
    fg = c.adwaita_white,
  },

  ['@variable.member'] = {
    fg = c.field_purple,
  },

  ['@parameter'] = { fg = c.type_blue },

  ['@field'] = { fg = c.field_purple },

  -- Operators
  ['@operator'] = {
    fg = c.operator,
  },

  -- Constants / literals
  ['@constant'] = {
    fg = c.literal,
  },

  ['@constant.builtin'] = {
    fg = c.literal,
  },

  ['@number'] = {
    fg = c.literal,
  },

  ['@boolean'] = {
    fg = c.literal,
  },

  -- Strings
  ['@string'] = {
    fg = c.green,
  },

  ['@string.escape'] = {
    fg = c.adwaita_orange,
  },

  -- Comments
  ['@comment'] = {
    link = 'Comment'
  },

  -- Punctuation
  ['@punctuation.bracket'] = {
    fg = c.adwaita_white,
  },

  ['@punctuation.delimiter'] = {
    fg = c.adwaita_white,
  },

  ['@punctuation.special'] = {
    fg = c.operator,
  },

  -- UI
  ['MatchParen'] = {
    link = 'Visual',
  },

  ['NeoTreeNormal'] = {
    bg = c.bg_dark,
  },

  ['NeoTreeNormalNC'] = {
    bg = c.bg_dark,
  },

  -- DAP
  ['DapBreakpoint'] = {
    fg = '#993939',
    bg = '#31353f',
  },

  ['DapLogPoint'] = {
    fg = '#61afef',
    bg = '#31353f',
  },

  ['DapStopped'] = {
    fg = '#98c379',
    bg = '#31353f',
    bold = true,
  },
}
