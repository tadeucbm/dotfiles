-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Toggle blink.cmp completion
vim.keymap.set("n", "<leader>tc", function()
	vim.g.blink_cmp_enabled = not vim.g.blink_cmp_enabled
	local status = vim.g.blink_cmp_enabled and "enabled" or "disabled"
	vim.notify("Blink.cmp completion " .. status, vim.log.levels.INFO)
end, { desc = "Toggle blink.cmp completion" })