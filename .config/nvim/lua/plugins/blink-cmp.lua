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
				menu = {
					enabled = true,
					mini = false,
				},
				ghost_text = {
					enabled = true,
				},
			},
		},
		config = function(_, opts)
			local blink = require("blink.cmp")
			blink.setup(opts)

			-- Store original configuration
			local original_config = vim.deepcopy(opts)
			
			-- Toggle state for different sources and features
			_G.blink_toggle_state = {
				lsp = true,
				path = true,
				snippets = true,
				buffer = true,
				copilot = true,
				ghost_text = true,
				mini_menu = false,
			}

			-- Function to get current active sources
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

			-- Function to update blink configuration
			local function update_blink_config()
				local new_config = vim.deepcopy(original_config)
				new_config.sources.default = get_active_sources()
				new_config.completion.ghost_text.enabled = _G.blink_toggle_state.ghost_text
				new_config.completion.menu.mini = _G.blink_toggle_state.mini_menu
				
				-- Reinitialize blink.cmp with new configuration
				blink.setup(new_config)
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

			-- Function to toggle mini menu
			local function toggle_mini_menu()
				_G.blink_toggle_state.mini_menu = not _G.blink_toggle_state.mini_menu
				update_blink_config()
				
				local status = _G.blink_toggle_state.mini_menu and "enabled" or "disabled"
				vim.notify("Blink.cmp mini menu " .. status, vim.log.levels.INFO)
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
			keymap("n", "<leader>Bm", toggle_mini_menu, 
				vim.tbl_extend("force", opts_keymap, { desc = "Toggle mini menu" }))

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
				table.insert(status_lines, "  " .. (_G.blink_toggle_state.mini_menu and "✓" or "✗") .. " mini menu")
				
				vim.notify(table.concat(status_lines, "\n"), vim.log.levels.INFO)
			end, { desc = "Show blink.cmp toggle status" })
		end,
	},
}