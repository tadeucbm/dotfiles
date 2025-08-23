-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options

vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_ptyhon_ruff = "ruff"

-- Initialize blink.cmp toggle state
vim.g.blink_cmp_enabled = vim.g.blink_cmp_enabled ~= false -- default to true
