return {
	"saghen/blink.cmp",
	opts = function(_, opts)
		-- Initialize toggle states if not set
		if vim.g.blink_cmp_enabled == nil then
			vim.g.blink_cmp_enabled = true
		end
		if vim.g.blink_ghost_text_enabled == nil then
			vim.g.blink_ghost_text_enabled = true
		end
		-- Initialize copilot toggle
		if vim.g.blink_copilot_enabled == nil then
			vim.g.blink_copilot_enabled = true
		end

		-- Override the top-level enabled function
		opts.enabled = function()
			return vim.g.blink_cmp_enabled
		end

		-- Set up completion ghost text configuration
		opts.completion = opts.completion or {}
		opts.completion.ghost_text = {
			enabled = function()
				return vim.g.blink_ghost_text_enabled
			end,
		}

		-- Set up copilot source toggle
		opts.sources = opts.sources or {}
		opts.sources.providers = opts.sources.providers or {}

		-- Copilot source toggle
		if opts.sources.providers.copilot then
			local original_copilot_enabled = opts.sources.providers.copilot.enabled
			opts.sources.providers.copilot.enabled = function()
				local base_enabled = type(original_copilot_enabled) == "function" and original_copilot_enabled()
					or (original_copilot_enabled ~= false)
				return base_enabled and vim.g.blink_copilot_enabled
			end
		end

		opts.cmdline.enabled = true

		return opts
	end,
	keys = {
		{
			"<leader>Bt",
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
		{
			"<leader>Bg",
			function()
				-- Toggle ghost text for completion
				vim.g.blink_ghost_text_enabled = not vim.g.blink_ghost_text_enabled
				local status = vim.g.blink_ghost_text_enabled and "enabled" or "disabled"

				-- Cancel any active completion menu immediately
				local ok, blink = pcall(require, "blink.cmp")
				if ok and blink.cancel then
					blink.cancel()
				end

				-- Show notification
				vim.notify("Blink.cmp ghost text " .. status, vim.log.levels.INFO)
			end,
			desc = "Toggle blink.cmp ghost text",
		},
		{
			"<leader>Bo",
			function()
				-- Toggle copilot source
				vim.g.blink_copilot_enabled = not vim.g.blink_copilot_enabled
				local status = vim.g.blink_copilot_enabled and "enabled" or "disabled"

				-- Cancel any active completion menu immediately
				local ok, blink = pcall(require, "blink.cmp")
				if ok and blink.cancel then
					blink.cancel()
				end

				-- Show notification
				vim.notify("Blink.cmp copilot source " .. status, vim.log.levels.INFO)
			end,
			desc = "Toggle blink.cmp copilot source",
		},
	},
}
