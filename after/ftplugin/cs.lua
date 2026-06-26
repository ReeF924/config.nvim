local c = require 'core.pallete'

local cs_hl = {
  ['@lsp.type.extensionMethod.cs'] = { link = '@function' },
  ['@field'] = { fg = c.field_purple },
  ['@lsp.type.property.cs'] = { fg = c.field_purple },
  ['@lsp.typemod.property.classScope.cs'] = { fg = c.field_purple },

  -- Define these names exactly
  ['CustomOperatorKeyword'] = { fg = c.operator },
  ['CustomPrimitiveKeyword'] = { fg = c.primitive_blue },
  ['CustomAccessKeyword'] = { fg = c.blue_gray },
  ['CustomThisKeyword'] = { fg = c.field_purple },
  ['CustomAsyncKeyword'] = { fg = c.dark_green },
  ['CustomClassKeyword'] = { fg = c.dark_green },
  ['CustomLiteralKeyword'] = { fg = c.literal },
}

-- Set highlights
for group, opts in pairs(cs_hl) do
  vim.api.nvim_set_hl(0, group, opts)
end

local keyword_map = {
  -- Primitives & Variables
  ['int'] = 'CustomPrimitiveKeyword',
  ['uint'] = 'CustomPrimitiveKeyword',
  ['long'] = 'CustomPrimitiveKeyword',
  ['ulong'] = 'CustomPrimitiveKeyword',
  ['short'] = 'CustomPrimitiveKeyword',
  ['ushort'] = 'CustomPrimitiveKeyword',
  ['byte'] = 'CustomPrimitiveKeyword',
  ['sbyte'] = 'CustomPrimitiveKeyword',
  ['char'] = 'CustomPrimitiveKeyword',
  ['bool'] = 'CustomPrimitiveKeyword',
  ['float'] = 'CustomPrimitiveKeyword',
  ['double'] = 'CustomPrimitiveKeyword',
  ['decimal'] = 'CustomPrimitiveKeyword',
  ['string'] = 'CustomPrimitiveKeyword',
  ['object'] = 'CustomPrimitiveKeyword',
  ['void'] = 'CustomPrimitiveKeyword',
  ['var'] = 'CustomPrimitiveKeyword',

  -- Keywords
  ['new'] = 'CustomOperatorKeyword',
  ['is'] = 'CustomOperatorKeyword',
  ['true'] = 'CustomLiteralKeyword',
  ['false'] = 'CustomLiteralKeyword',
  ['await'] = 'CustomOperatorKeyword',
  ['public'] = 'CustomAccessKeyword',
  ['private'] = 'CustomAccessKeyword',
  ['this'] = 'CustomThisKeyword',
  ['async'] = 'CustomAsyncKeyword',
  ['class'] = 'CustomClassKeyword',
  ['null'] = 'CustomLiteralKeyword',
}

-- Apply matches
pcall(vim.fn.clearmatches)
for word, group in pairs(keyword_map) do
  vim.fn.matchadd(group, '\\<' .. word .. '\\>', 1000)
end
