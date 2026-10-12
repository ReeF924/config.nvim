
return {
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt", "java" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local metals = require("metals")
      local metals_config = metals.bare_config()

      metals_config.settings = {
        metals = {
          useGlobalExecutable = true,
        },
      }

      metals_config.on_attach = function(client, befnr)
        require("metals").setup_dap()
      end

      metals_config.capabilities =
        require("blink.cmp").get_lsp_capabilities()

      local group = vim.api.nvim_create_augroup(
        "nvim-metals",
        { clear = true }
      )

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        group = group,
        callback = function()
          vim.notify("Metals reached")
          metals.initialize_or_attach(metals_config)
        end,
      })

    end,
  },
}

