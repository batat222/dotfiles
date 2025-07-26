return {
  "epwalsh/obsidian.nvim",
  lazy = true,
  event = {
    "BufReadPre /home/batat/lections/*.md",
    "BufNewFile /home/batat/lections/*.md",
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    workspaces = {
      {
        name = "vault",
        path = "~/lections/",
      },
    },
  },
}
