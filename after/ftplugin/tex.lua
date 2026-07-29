-- LaTeX filetype settings and keymaps
local keymap = vim.keymap.set

-- Compile LaTeX document
keymap('n', '<leader>lb', '<cmd>Dispatch latexmk -pdf %<CR>', { desc = '[L]aTeX [B]uild', buffer = true })

-- View compiled PDF (opens in default PDF viewer)
keymap('n', '<leader>lv', '<cmd>VimtexView<CR>', { desc = '[L]aTeX [V]iew', buffer = true })

-- Clean auxiliary files
keymap('n', '<leader>lc', '<cmd>!latexmk -c %<CR>', { desc = '[L]aTeX [C]lean', buffer = true })

-- Toggle compilation (start/stop)
keymap('n', '<leader>lt', '<cmd>VimtexCompileToggle<CR>', { desc = '[L]aTeX [T]oggle compile', buffer = true })

-- Show compilation status
keymap('n', '<leader>ls', '<cmd>VimtexStatus<CR>', { desc = '[L]aTeX [S]tatus', buffer = true })

-- Open quickfix for errors
keymap('n', '<leader>le', '<cmd>VimtexErrors<CR>', { desc = '[L]aTeX [E]rrors', buffer = true })

-- Set local options
vim.opt_local.wrap = true
vim.opt_local.linebreak = true

local c = require 'core.pallete'

-- LSP Semantic Tokens and C++ specific Treesitter
local tex_hl = {
  ['Statement'] = { fg = c.primitive_blue },
  ['Type'] = { fg = c.type_blue },
  ['PreCondit'] = { fg = c.dark_green, bold = true },
  ['Identifier'] = { fg = c.literal },
  ['Special'] = { fg = c.method_yellow },
  ['SpecialChar'] = { fg = c.adwaita_orange, bold = true },
  ['Delimiter'] = { fg = c.operator },
}

for group, opts in pairs(tex_hl) do
  vim.api.nvim_set_hl(0, group, opts)
end
