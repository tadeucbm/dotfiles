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
		if vim.g.blink_cmdline_ghost_text_enabled == nil then
			vim.g.blink_cmdline_ghost_text_enabled = true
		end
		-- Initialize source toggles
		if vim.g.blink_lsp_enabled == nil then
			vim.g.blink_lsp_enabled = true
		end
		if vim.g.blink_snippets_enabled == nil then
			vim.g.blink_snippets_enabled = true
		end
		if vim.g.blink_buffer_enabled == nil then
			vim.g.blink_buffer_enabled = true
		end
		if vim.g.blink_path_enabled == nil then
			vim.g.blink_path_enabled = true
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

		-- Set up cmdline ghost text configuration
		opts.cmdline = opts.cmdline or {}
		opts.cmdline.completion = opts.cmdline.completion or {}
		opts.cmdline.completion.ghost_text = {
			enabled = function()
				return vim.g.blink_cmdline_ghost_text_enabled
			end,
		}

		-- Set up source toggles
		opts.sources = opts.sources or {}
		opts.sources.providers = opts.sources.providers or {}
		
		-- LSP source toggle
		if opts.sources.providers.lsp then
			local original_lsp_enabled = opts.sources.providers.lsp.enabled
			opts.sources.providers.lsp.enabled = function()
				local base_enabled = type(original_lsp_enabled) == "function" and original_lsp_enabled() or (original_lsp_enabled ~= false)
				return base_enabled and vim.g.blink_lsp_enabled
			end
		end

		-- Snippets source toggle
		if opts.sources.providers.snippets then
			local original_snippets_enabled = opts.sources.providers.snippets.enabled
			opts.sources.providers.snippets.enabled = function()
				local base_enabled = type(original_snippets_enabled) == "function" and original_snippets_enabled() or (original_snippets_enabled ~= false)
				return base_enabled and vim.g.blink_snippets_enabled
			end
		end

		-- Buffer source toggle
		if opts.sources.providers.buffer then
			local original_buffer_enabled = opts.sources.providers.buffer.enabled
			opts.sources.providers.buffer.enabled = function()
				local base_enabled = type(original_buffer_enabled) == "function" and original_buffer_enabled() or (original_buffer_enabled ~= false)
				return base_enabled and vim.g.blink_buffer_enabled
			end
		end

		-- Path source toggle
		if opts.sources.providers.path then
			local original_path_enabled = opts.sources.providers.path.enabled
			opts.sources.providers.path.enabled = function()
				local base_enabled = type(original_path_enabled) == "function" and original_path_enabled() or (original_path_enabled ~= false)
				return base_enabled and vim.g.blink_path_enabled
			end
		end

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
			"<leader>Bc",
			function()
				-- Toggle ghost text for cmdline
				vim.g.blink_cmdline_ghost_text_enabled = not vim.g.blink_cmdline_ghost_text_enabled
				local status = vim.g.blink_cmdline_ghost_text_enabled and "enabled" or "disabled"

				-- Show notification
				vim.notify("Blink.cmp cmdline ghost text " .. status, vim.log.levels.INFO)
			end,
			desc = "Toggle blink.cmp cmdline ghost text",
		},
		-- Source-specific toggles
		{
			"<leader>Bl",
			function()
				-- Toggle LSP source
				vim.g.blink_lsp_enabled = not vim.g.blink_lsp_enabled
				local status = vim.g.blink_lsp_enabled and "enabled" or "disabled"

				-- Cancel any active completion menu immediately
				local ok, blink = pcall(require, "blink.cmp")
				if ok and blink.cancel then
					blink.cancel()
				end

				-- Show notification
				vim.notify("Blink.cmp LSP source " .. status, vim.log.levels.INFO)
			end,
			desc = "Toggle blink.cmp LSP source",
		},
		{
			"<leader>Bs",
			function()
				-- Toggle snippets source
				vim.g.blink_snippets_enabled = not vim.g.blink_snippets_enabled
				local status = vim.g.blink_snippets_enabled and "enabled" or "disabled"

				-- Cancel any active completion menu immediately
				local ok, blink = pcall(require, "blink.cmp")
				if ok and blink.cancel then
					blink.cancel()
				end

				-- Show notification
				vim.notify("Blink.cmp snippets source " .. status, vim.log.levels.INFO)
			end,
			desc = "Toggle blink.cmp snippets source",
		},
		{
			"<leader>Bb",
			function()
				-- Toggle buffer source
				vim.g.blink_buffer_enabled = not vim.g.blink_buffer_enabled
				local status = vim.g.blink_buffer_enabled and "enabled" or "disabled"

				-- Cancel any active completion menu immediately
				local ok, blink = pcall(require, "blink.cmp")
				if ok and blink.cancel then
					blink.cancel()
				end

				-- Show notification
				vim.notify("Blink.cmp buffer source " .. status, vim.log.levels.INFO)
			end,
			desc = "Toggle blink.cmp buffer source",
		},
		{
			"<leader>Bp",
			function()
				-- Toggle path source
				vim.g.blink_path_enabled = not vim.g.blink_path_enabled
				local status = vim.g.blink_path_enabled and "enabled" or "disabled"

				-- Cancel any active completion menu immediately
				local ok, blink = pcall(require, "blink.cmp")
				if ok and blink.cancel then
					blink.cancel()
				end

				-- Show notification
				vim.notify("Blink.cmp path source " .. status, vim.log.levels.INFO)
			end,
			desc = "Toggle blink.cmp path source",
		},
	},
}
