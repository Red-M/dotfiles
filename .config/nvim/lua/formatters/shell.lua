return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
      },
      formatters = {
        shfmt = {
          prepend_args = {
            "-i", "2",
            "-ci",
            "-kp",
            "-sr",
          },
        },
      },
    },
  },
}
