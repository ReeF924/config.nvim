return {
  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    branch = 'v0.6', -- Recommended branch
    opts = {
      -- 1. Manages pairs () [] {} automatically
      -- 2. Handles the "Enter" formatting
      fastwarp = {
        enable = true,
        map = '<C-f>', -- A bonus feature to wrap existing text
      },
      tabout = {
        enable = true,
        map = '<Tab>', -- This handles jumping over the closing bracket
        hopout = true, -- Allows jumping even if there's text in between
      },
    },
  },
}
