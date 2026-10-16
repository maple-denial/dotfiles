-- 配色方案：Catppuccin Mocha
-- 与 yazi 的 flavor（catppuccin-mocha）保持一致
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = { flavour = "mocha" },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
