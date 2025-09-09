return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    strategies = {
      chat = {
        name = "deepseek-coder",
        model = "deepseek-coder:latest",
      },
      inline = {
        adapter = "ollama",
      },
    },
    opts = {
      log_level = "DEBUG",
    },
  },
}
