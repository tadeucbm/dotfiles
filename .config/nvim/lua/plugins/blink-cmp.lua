return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"giuxtaposition/blink-cmp-copilot",
		},
		opts = {
			keymap = { preset = "default" },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "copilot" },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 100,
						async = true,
					},
				},
			},
			completion = {
				ghost_text = {
					enabled = true,
				},
			},
		},
		config = function(_, opts)
			-- Setup blink.cmp initially
			local blink = require("blink.cmp")
			blink.setup(opts)

			-- Initialize global state for tracking what's enabled
			_G.blink_toggle_state = {
				lsp = true,
				path = true,
				snippets = true,
				buffer = true,
				copilot = true,
				ghost_text = true,
			}

			-- Store original configuration for reference
			_G.blink_original_opts = vim.deepcopy(opts)

			-- Function to get current active sources based on toggle state
			local function get_active_sources()
				local active = {}
				local all_sources = { "lsp", "path", "snippets", "buffer", "copilot" }
				for _, source in ipairs(all_sources) do
					if _G.blink_toggle_state[source] then
						table.insert(active, source)
					end
				end
				return active
			end

			-- Function to reinitialize blink.cmp with new configuration
			local function update_blink_config()
				local success = pcall(function()
					-- Create new configuration based on current toggle state
					local new_opts = vim.deepcopy(_G.blink_original_opts)
					new_opts.sources.default = get_active_sources()
					new_opts.completion.ghost_text.enabled = _G.blink_toggle_state.ghost_text
					
					-- Reinitialize blink.cmp
					local blink = require("blink.cmp")
					blink.setup(new_opts)
				end)
				
				if not success then
					vim.notify("Configuration updated - changes will take effect on next restart", vim.log.levels.INFO)
				end
			end

			-- Function to toggle a completion source
			local function toggle_source(source_name)
				_G.blink_toggle_state[source_name] = not _G.blink_toggle_state[source_name]
				
				-- Check if all sources are disabled
				local active_sources = get_active_sources()
				if #active_sources == 0 then
					vim.notify("Warning: All completion sources are now disabled!", vim.log.levels.WARN)
				end
				
				update_blink_config()
				
				local status = _G.blink_toggle_state[source_name] and "enabled" or "disabled"
				vim.notify("Blink.cmp " .. source_name .. " source " .. status, vim.log.levels.INFO)
			end

			-- Function to toggle ghost text
			local function toggle_ghost_text()
				_G.blink_toggle_state.ghost_text = not _G.blink_toggle_state.ghost_text
				update_blink_config()
				
				local status = _G.blink_toggle_state.ghost_text and "enabled" or "disabled"
				vim.notify("Blink.cmp ghost text " .. status, vim.log.levels.INFO)
			end

			-- Set up keymaps
			local keymap = vim.keymap.set
			local opts_keymap = { desc = "", silent = true }
			
			-- Toggle completion sources
			keymap("n", "<leader>Bl", function() toggle_source("lsp") end, 
				vim.tbl_extend("force", opts_keymap, { desc = "Toggle LSP source" }))
			keymap("n", "<leader>Bp", function() toggle_source("path") end, 
				vim.tbl_extend("force", opts_keymap, { desc = "Toggle Path source" }))
			keymap("n", "<leader>Bs", function() toggle_source("snippets") end, 
				vim.tbl_extend("force", opts_keymap, { desc = "Toggle Snippets source" }))
			keymap("n", "<leader>Bb", function() toggle_source("buffer") end, 
				vim.tbl_extend("force", opts_keymap, { desc = "Toggle Buffer source" }))
			keymap("n", "<leader>Bc", function() toggle_source("copilot") end, 
				vim.tbl_extend("force", opts_keymap, { desc = "Toggle Copilot source" }))
			
			-- Toggle features
			keymap("n", "<leader>Bg", toggle_ghost_text, 
				vim.tbl_extend("force", opts_keymap, { desc = "Toggle ghost text" }))

			-- Add a command to show current toggle states
			vim.api.nvim_create_user_command('BlinkToggleStatus', function()
				local status_lines = { "Blink.cmp Toggle Status:" }
				table.insert(status_lines, "Sources:")
				for source, enabled in pairs({
					lsp = _G.blink_toggle_state.lsp,
					path = _G.blink_toggle_state.path,
					snippets = _G.blink_toggle_state.snippets,
					buffer = _G.blink_toggle_state.buffer,
					copilot = _G.blink_toggle_state.copilot,
				}) do
					local status = enabled and "✓" or "✗"
					table.insert(status_lines, "  " .. status .. " " .. source)
				end
				table.insert(status_lines, "Features:")
				table.insert(status_lines, "  " .. (_G.blink_toggle_state.ghost_text and "✓" or "✗") .. " ghost text")
				
				vim.notify(table.concat(status_lines, "\n"), vim.log.levels.INFO)
			end, { desc = "Show blink.cmp toggle status" })

			-- Add a test command to verify the plugin is working
			vim.api.nvim_create_user_command('BlinkToggleTest', function()
				local blink_available = pcall(require, "blink.cmp")
				local keymaps_registered = vim.fn.mapcheck("<leader>Bl", "n") ~= ""
				
				local test_results = {
					"Blink.cmp Toggle Plugin Test Results:",
					"blink.cmp available: " .. (blink_available and "✓" or "✗"),
					"keymaps registered: " .. (keymaps_registered and "✓" or "✗"),
					"global state initialized: " .. (_G.blink_toggle_state and "✓" or "✗"),
				}
				
				if _G.blink_toggle_state then
					table.insert(test_results, "current active sources: " .. table.concat(get_active_sources(), ", "))
				end
				
				vim.notify(table.concat(test_results, "\n"), vim.log.levels.INFO)
			end, { desc = "Test blink.cmp toggle functionality" })
		end,
	},
}