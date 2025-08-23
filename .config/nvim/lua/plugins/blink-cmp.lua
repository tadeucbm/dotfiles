return {
	"saghen/blink.cmp",
	opts = function(_, opts)
		-- Initialize toggle state if not already set
		if vim.g.blink_cmp_enabled == nil then
			vim.g.blink_cmp_enabled = true
		end
		
		-- Override the completion configuration
		opts.completion = opts.completion or {}
		
		-- Store the original enabled setting
		local original_enabled = opts.completion.enabled
		
		-- Create a function that respects both the toggle and original settings
		opts.completion.enabled = function()
			-- If toggle is disabled, always return false
			if not vim.g.blink_cmp_enabled then
				return false
			end
			
			-- Otherwise respect the original setting
			if type(original_enabled) == "function" then
				return original_enabled()
			elseif type(original_enabled) == "boolean" then
				return original_enabled
			else
				return true -- default enabled
			end
		end

		return opts
	end,
	keys = {
		{
			"<leader>tc",
			function()
				vim.g.blink_cmp_enabled = not vim.g.blink_cmp_enabled
				local status = vim.g.blink_cmp_enabled and "enabled" or "disabled"
				vim.notify("Blink.cmp completion " .. status, vim.log.levels.INFO)
			end,
			desc = "Toggle blink.cmp completion",
		},
	},
}