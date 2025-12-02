return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    ---@class PluginLspOpts
    opts = {
      -- servers = {},
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },
}
