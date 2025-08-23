return {
	"saghen/blink.cmp",
	opts = function(_, opts)
		-- Initialize toggle state
		if vim.g.blink_cmp_enabled == nil then
			vim.g.blink_cmp_enabled = true
		end

		-- Simple approach: override the enabled function completely
		opts.completion = opts.completion or {}
		opts.completion.enabled = function()
			return vim.g.blink_cmp_enabled
		end

		return opts
	end,
	keys = {
		{
			"<leader>tc",
			function()
				-- Toggle the state
				vim.g.blink_cmp_enabled = not vim.g.blink_cmp_enabled
				local status = vim.g.blink_cmp_enabled and "enabled" or "disabled"
				
				-- Cancel any active completion menu immediately
				local ok, blink = pcall(require, "blink.cmp")
				if ok and blink.cancel then
					blink.cancel()
				end
				
				-- Show notification
				vim.notify("Blink.cmp completion " .. status, vim.log.levels.INFO)
			end,
			desc = "Toggle blink.cmp completion",
		},
	},
}