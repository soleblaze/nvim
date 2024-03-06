return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = function()
      if vim.g.autoFormat then
        return { timeout_ms = 500, lsp_fallback = true }
      end
    end,
    formatters_by_ft = {
      ["*"] = { "trim_whitespace" },
      ["json"] = { "fixjson" },
      ["markdown"] = { "mdformat" },
      ["sh"] = { "shfmt" },
      python = { "isort", "black" },
      packer = { "packer_fmt" },
    },
    formatters = {
      shfmt = {
        prepend_args = { "-ci", "-s", "-i", "2", "-bn", "-sr" },
      },
    },
    format = {
      async = false,
      lsp_fallback = true,
      quiet = false,
      timeout_ms = 3000,
    },
  },
}
