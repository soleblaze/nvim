local lazypath = vim.fn.stdpath("data") .. "/vscode/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)
package.path = package.path .. ";" .. vim.fn.expand("~/git/nvim/vscode/lua") .. "/?.lua"

require("options")

require("lazy").setup(vim.fn.expand("~/git/nvim/vscode/lua/plugins"), {
  root = vim.fn.stdpath("data") .. "/vscode",
  checker = {
    enabled = true,
    frequency = 604800,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
require("keymaps")
