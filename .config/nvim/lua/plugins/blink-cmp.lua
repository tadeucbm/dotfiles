return {
	"saghen/blink.cmp",
	opts = function(_, opts)
		-- Initialize toggle state
		if vim.g.blink_cmp_enabled == nil then
			vim.g.blink_cmp_enabled = true
		end

		-- Ensure completion is configured
		opts.completion = opts.completion or {}
		
		-- Store the original enabled setting if it exists
		local original_enabled = opts.completion.enabled
		
		-- Create a dynamic enabled function that checks our toggle
		opts.completion.enabled = function(ctx)
			-- Always check our global toggle first
			if not vim.g.blink_cmp_enabled then
				return false
			end
			
			-- If we have an original enabled function/value, use it
			if type(original_enabled) == "function" then
				return original_enabled(ctx)
			elseif original_enabled ~= nil then
				return original_enabled
			end
			
			-- Default behavior - enabled in insert mode, configurable for command mode
			local mode = vim.api.nvim_get_mode().mode
			if mode == "c" then
				return true -- Enable in command mode by default
			end
			return true -- Enable in other modes
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
				
				-- Try to cancel any active completion menu
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