return {
  {
    "rktjmp/playtime.nvim",
    cmd = "Playtime",
    lazy = true,
    opts = {
      window_border = "shadow",
    },
  },
  {
    "alanfortlink/blackjack.nvim",
    cmd = "BlackJackNewGame",
    lazy = true,
    dependencies = {
      { "nvim-lua/plenary.nvim", }
    },
  }
}

