local c = require 'core.pallete'

local python_hl = {

  ['Function'] = { fg = c.method_yellow },
  ['Statement'] = { fg = c.method_yellow },



  -- LSP Semantic Tokens
  ['@lsp.type.function.python'] = { fg = c.method_yellow },
  ['@lsp.type.method.python'] = { fg = c.method_yellow },
  ['@lsp.type.parameter.python'] = { fg = c.type_blue },
  ['@lsp.type.variable.python'] = { fg = c.adwaita_white },
  ['@lsp.type.class.python'] = { fg = c.type_blue },
  ['@lsp.type.type.python'] = { fg = c.type_blue },
  ['@lsp.type.decorator.python'] = { fg = c.method_yellow },
  ['@lsp.type.property.python'] = { fg = c.field_purple },

  -- Treesitter captures
  ['@function'] = { fg = c.method_yellow },
  ['@function.call'] = { fg = c.method_yellow },
  ['@method'] = { fg = c.method_yellow },
  ['@method.call'] = { fg = c.method_yellow },
  ['@variable.parameter'] = { fg = c.type_blue },
  ['@parameter'] = { fg = c.type_blue },
  ['@variable.member'] = { fg = c.field_purple },
  ['@field'] = { fg = c.field_purple },
  ['@type'] = { fg = c.type_blue },
  ['@type.builtin'] = { fg = c.primitive_blue },
  ['@constant'] = { fg = c.literal },
  ['@constant.builtin'] = { fg = c.literal },
  ['@operator'] = { fg = c.operator },
  ['@string'] = { fg = c.literal },
  ['@string.special'] = { fg = c.light_yellow },
  ['@string.escape'] = { fg = c.light_yellow },
  ['@comment'] = { fg = c.blue_gray },
  ['@comment.todo'] = { fg = c.light_yellow, bold = true },
  ['@comment.note'] = { fg = c.dark_blue, bold = true },
  ['@number'] = { fg = c.literal },
  ['@boolean'] = { fg = c.literal },
  ['@module'] = { fg = c.adwaita_white },
  ['@namespace'] = { fg = c.adwaita_white },
  ['@decorator'] = { fg = c.method_yellow },

  -- Custom keyword highlights (matching C# style)
  ['CustomOperatorKeyword'] = { fg = c.operator },
  ['CustomPrimitiveKeyword'] = { fg = c.primitive_blue },
  ['CustomAccessKeyword'] = { fg = c.blue_gray },
  ['CustomStaticKeyword'] = { fg = c.blue_gray },
  ['CustomModifierKeyword'] = { fg = c.blue_gray },
  ['CustomThisKeyword'] = { fg = c.field_purple },
  ['CustomAsyncKeyword'] = { fg = c.dark_green },
  ['CustomClassKeyword'] = { fg = c.dark_green },
  ['CustomLiteralKeyword'] = { fg = c.literal },
  ['CustomPolymorhismKeyword'] = { fg = c.lime_green },
  ['CustomDefKeyword'] = { fg = c.dark_green },
  ['CustomImportKeyword'] = { fg = c.lime_green },
  ['CustomConditionalKeyword'] = { fg = c.blue_gray },
  ['CustomLoopKeyword'] = { fg = c.blue_gray },
  ['CustomExceptionKeyword'] = { fg = c.blue_gray },
  ['CustomReturnKeyword'] = { fg = c.blue_gray },
  ['CustomStatementKeyword'] = { fg = c.blue_gray },
}

for group, opts in pairs(python_hl) do
  vim.api.nvim_set_hl(0, group, opts)
end

local keyword_map = {
  -- Built-in types (primitives)
  ['int'] = 'CustomPrimitiveKeyword',
  ['float'] = 'CustomPrimitiveKeyword',
  ['str'] = 'CustomPrimitiveKeyword',
  ['bool'] = 'CustomPrimitiveKeyword',
  ['bytes'] = 'CustomPrimitiveKeyword',
  ['list'] = 'CustomPrimitiveKeyword',
  ['dict'] = 'CustomPrimitiveKeyword',
  ['tuple'] = 'CustomPrimitiveKeyword',
  ['set'] = 'CustomPrimitiveKeyword',
  ['frozenset'] = 'CustomPrimitiveKeyword',
  ['range'] = 'CustomPrimitiveKeyword',
  ['complex'] = 'CustomPrimitiveKeyword',
  ['bytearray'] = 'CustomPrimitiveKeyword',
  ['memoryview'] = 'CustomPrimitiveKeyword',
  ['type'] = 'CustomPrimitiveKeyword',
  ['object'] = 'CustomPrimitiveKeyword',
  ['None'] = 'CustomLiteralKeyword',
  ['True'] = 'CustomLiteralKeyword',
  ['False'] = 'CustomLiteralKeyword',

  -- Operators
  ['and'] = 'CustomOperatorKeyword',
  ['or'] = 'CustomOperatorKeyword',
  ['not'] = 'CustomOperatorKeyword',
  ['in'] = 'CustomOperatorKeyword',
  ['is'] = 'CustomOperatorKeyword',
  ['lambda'] = 'CustomOperatorKeyword',

  -- Access/visibility (Python doesn't have explicit modifiers, but these are conceptually similar)
  ['__private'] = 'CustomAccessKeyword',

  -- Static/Class methods
  ['staticmethod'] = 'CustomStaticKeyword',
  ['classmethod'] = 'CustomStaticKeyword',

  -- This/Self
  ['self'] = 'CustomThisKeyword',
  ['cls'] = 'CustomThisKeyword',

  -- Async
  ['async'] = 'CustomAsyncKeyword',
  ['await'] = 'CustomAsyncKeyword',

  -- Class/Function definitions
  ['def'] = 'CustomDefKeyword',
  ['class'] = 'CustomClassKeyword',

  -- Imports
  ['import'] = 'CustomImportKeyword',
  ['from'] = 'CustomImportKeyword',
  ['as'] = 'CustomImportKeyword',

  -- Control flow (conditionals)
  ['if'] = 'CustomConditionalKeyword',
  ['elif'] = 'CustomConditionalKeyword',
  ['else'] = 'CustomConditionalKeyword',

  -- Loops
  ['for'] = 'CustomLoopKeyword',
  ['while'] = 'CustomLoopKeyword',

  -- Exception handling
  ['try'] = 'CustomExceptionKeyword',
  ['except'] = 'CustomExceptionKeyword',
  ['finally'] = 'CustomExceptionKeyword',
  ['raise'] = 'CustomExceptionKeyword',
  ['assert'] = 'CustomExceptionKeyword',

  -- Return/Yield
  ['return'] = 'CustomReturnKeyword',
  ['yield'] = 'CustomReturnKeyword',

  -- Statements
  ['pass'] = 'CustomStatementKeyword',
  ['break'] = 'CustomStatementKeyword',
  ['continue'] = 'CustomStatementKeyword',
  ['with'] = 'CustomStatementKeyword',
  ['global'] = 'CustomStatementKeyword',
  ['nonlocal'] = 'CustomStatementKeyword',
  ['del'] = 'CustomStatementKeyword',

  -- Polymorphism
  ['abc'] = 'CustomPolymorhismKeyword',
  ['abstractmethod'] = 'CustomPolymorhismKeyword',
}

pcall(vim.fn.clearmatches)
for word, group in pairs(keyword_map) do
  vim.fn.matchadd(group, '\\<' .. word .. '\\>', 1000)
end

_G.ufo_keywords = _G.ufo_keywords or {}
_G.ufo_keywords.python = keyword_map
