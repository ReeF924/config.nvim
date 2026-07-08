local c = require 'core.pallete'

local ts_hl = {
  -- LSP Semantic Tokens
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
  ['typescriptFuncCallArg'] = { fg = c.adwaita_white },
  ['typescriptFuncComma'] = { fg = c.adwaita_white },

  ['@lsp.type.modifier.typescript'] = { fg = c.blue_gray },

  ['@lsp.typemod.type.defaultLibrary.typescript'] = { fg = c.primitive_blue },
  ['@lsp.typemod.variable.defaultLibrary.typescript'] = { fg = c.primitive_blue },
  ['@lsp.typemod.variable.global.typescript'] = { fg = c.primitive_blue },

  -- Custom keyword highlights (regex matched)
  ['CustomOperatorKeyword'] = { fg = c.operator },
  ['CustomPrimitiveKeyword'] = { fg = c.primitive_blue },
  ['CustomAccessKeyword'] = { fg = c.blue_gray },
  ['CustomStaticKeyword'] = { fg = c.blue_gray },
  ['CustomModifierKeyword'] = { fg = c.blue_gray },
  ['CustomThisKeyword'] = { fg = c.field_purple, bold = false },
  ['CustomAsyncKeyword'] = { fg = c.dark_green },
  ['CustomClassKeyword'] = { link = 'Structure' },
  ['CustomLiteralKeyword'] = { fg = c.literal },
  ['CustomPolymorhismKeyword'] = { fg = c.lime_green },
  ['CustomGetSetKeyword'] = { link = '@function' },

  -- Tree-sitter captures
  ['@namespace'] = { link = '@parameter' },
  ['@variable.member'] = { fg = c.field_purple },
  ['@variable.builtin'] = { fg = c.primitive_blue },
  ['@type.builtin'] = { fg = c.primitive_blue },

  ['typescriptMember'] = { fg = c.primitive_blue },
  ['typescriptBraces'] = { fg = c.adwaita_white },
  ['typescriptIdentifier'] = { fg = c.adwaita_white, bold = false },
  ['typescriptGlobal'] = { bold = false },
  ['typescriptCastKeyword'] = { fg = c.operator },
}

for group, opts in pairs(ts_hl) do
  vim.api.nvim_set_hl(0, group, opts)
end

local keyword_map = {
  -- Primitives & Types
  ['string'] = 'CustomPrimitiveKeyword',
  ['number'] = 'CustomPrimitiveKeyword',
  ['boolean'] = 'CustomPrimitiveKeyword',
  ['any'] = 'CustomPrimitiveKeyword',
  ['void'] = 'CustomPrimitiveKeyword',
  ['never'] = 'CustomPrimitiveKeyword',
  ['unknown'] = 'CustomPrimitiveKeyword',
  ['bigint'] = 'CustomPrimitiveKeyword',
  ['symbol'] = 'CustomPrimitiveKeyword',
  ['null'] = 'CustomLiteralKeyword',
  ['undefined'] = 'CustomPrimitiveKeyword',

  -- Literals
  ['true'] = 'CustomLiteralKeyword',
  ['false'] = 'CustomLiteralKeyword',

  -- Operators
  ['new'] = 'CustomOperatorKeyword',
  ['instanceof'] = 'CustomOperatorKeyword',
  ['typeof'] = 'CustomOperatorKeyword',
  ['as'] = 'CustomOperatorKeyword',
  ['is'] = 'CustomOperatorKeyword',
  ['in'] = 'CustomOperatorKeyword',
  ['of'] = 'CustomOperatorKeyword',

  -- Access modifiers
  ['public'] = 'CustomAccessKeyword',
  ['private'] = 'CustomAccessKeyword',
  ['protected'] = 'CustomAccessKeyword',

  -- Modifiers
  ['static'] = 'CustomStaticKeyword',
  ['readonly'] = 'CustomModifierKeyword',
  ['const'] = 'CustomModifierKeyword',
  ['let'] = 'CustomModifierKeyword',
  ['var'] = 'CustomModifierKeyword',
  ['export'] = 'CustomModifierKeyword',
  ['import'] = 'CustomModifierKeyword',
  ['from'] = 'CustomModifierKeyword',
  ['default'] = 'CustomModifierKeyword',
  ['abstract'] = 'CustomPolymorhismKeyword',

  -- This/Super
  ['this'] = 'CustomThisKeyword',
  ['super'] = 'CustomThisKeyword',

  -- Async
  ['async'] = 'CustomAsyncKeyword',
  ['await'] = 'CustomOperatorKeyword',
  ['yield'] = 'CustomOperatorKeyword',

  -- Class/Type declarations
  ['class'] = 'CustomClassKeyword',
  ['interface'] = 'CustomClassKeyword',
  ['type'] = 'CustomClassKeyword',
  ['enum'] = 'CustomClassKeyword',
  ['namespace'] = 'CustomClassKeyword',
  ['module'] = 'CustomClassKeyword',

  -- Control flow
  ['if'] = 'CustomOperatorKeyword',
  ['else'] = 'CustomOperatorKeyword',
  ['switch'] = 'CustomOperatorKeyword',
  ['case'] = 'CustomOperatorKeyword',
  ['break'] = 'CustomOperatorKeyword',
  ['continue'] = 'CustomOperatorKeyword',
  ['return'] = 'CustomOperatorKeyword',
  ['throw'] = 'CustomOperatorKeyword',
  ['try'] = 'CustomOperatorKeyword',
  ['catch'] = 'CustomOperatorKeyword',
  ['finally'] = 'CustomOperatorKeyword',

  -- Loops
  ['for'] = 'CustomOperatorKeyword',
  ['while'] = 'CustomOperatorKeyword',
  ['do'] = 'CustomOperatorKeyword',

  -- Polymorphism
  ['extends'] = 'CustomPolymorhismKeyword',
  ['implements'] = 'CustomPolymorhismKeyword',

  -- Get/Set accessors
  ['get'] = 'CustomGetSetKeyword',
  ['set'] = 'CustomGetSetKeyword',

  -- Other
  ['function'] = 'CustomClassKeyword',
  ['arrow'] = 'CustomOperatorKeyword',
  ['infer'] = 'CustomOperatorKeyword',
  ['keyof'] = 'CustomOperatorKeyword',
  ['unique'] = 'CustomModifierKeyword',
  ['optional'] = 'CustomModifierKeyword',
}

pcall(vim.fn.clearmatches)
for word, group in pairs(keyword_map) do
  vim.fn.matchadd(group, '\\<' .. word .. '\\>', 1000)
end

_G.ufo_keywords = _G.ufo_keywords or {}
_G.ufo_keywords.ts = keyword_map
