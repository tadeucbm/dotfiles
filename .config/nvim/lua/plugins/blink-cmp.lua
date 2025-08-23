return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"giuxtaposition/blink-cmp-copilot",
		},
		
		config = function(_, opts)
			local blink = require('blink.cmp')
			
			-- Set up blink.cmp with the provided options
			blink.setup(opts)
			
			-- Store state for toggles - initialize based on current config
			local state = {
				sources = {
					lsp = true,
					path = true,
					snippets = true,
					buffer = true,
					copilot = true,
				},
				features = {
					ghost_text = true,
					completion_menu = true,
				}
			}
			
			-- Helper function to get current sources
			local function get_current_sources()
				local current_config = blink.config or {}
				local sources = current_config.sources or {}
				return sources.default or { "lsp", "path", "snippets", "buffer" }
			end
			
			-- Helper function to check if a source is currently enabled
			local function is_source_enabled(source_name)
				local current_sources = get_current_sources()
				for _, source in ipairs(current_sources) do
					if source == source_name then
						return true
					end
				end
				return false
			end
			
			-- Update initial state based on actual configuration
			local function update_initial_state()
				for source_name, _ in pairs(state.sources) do
					state.sources[source_name] = is_source_enabled(source_name)
				end
			end
			
			-- Call this after setup
			vim.schedule(update_initial_state)
			
			-- Helper function to toggle source
			local function toggle_source(source_name)
				-- Toggle state
				state.sources[source_name] = not state.sources[source_name]
				
				-- Build new sources list based on current state
				local new_sources = {}
				for src, enabled in pairs(state.sources) do
					if enabled then
						table.insert(new_sources, src)
					end
				end
				
				-- Try to update configuration dynamically
				local success, err = pcall(function()
					blink.setup(vim.tbl_deep_extend("force", blink.config or {}, {
						sources = {
							default = new_sources
						}
					}))
				end)
				
				if not success then
					-- Fallback: just update our state and notify
					vim.notify("Blink CMP configuration update failed, toggling state only", vim.log.levels.WARN)
				end
				
				-- Provide user feedback
				local status = state.sources[source_name] and "enabled" or "disabled"
				vim.notify("Blink CMP " .. source_name .. " source " .. status, vim.log.levels.INFO)
			end
			
			-- Helper function to toggle ghost text
			local function toggle_ghost_text()
				state.features.ghost_text = not state.features.ghost_text
				
				local success, err = pcall(function()
					blink.setup(vim.tbl_deep_extend("force", blink.config or {}, {
						completion = {
							ghost_text = {
								enabled = state.features.ghost_text
							}
						}
					}))
				end)
				
				if not success then
					vim.notify("Blink CMP ghost text toggle failed: " .. tostring(err), vim.log.levels.WARN)
				end
				
				local status = state.features.ghost_text and "enabled" or "disabled"
				vim.notify("Blink CMP ghost text " .. status, vim.log.levels.INFO)
			end
			
			-- Helper function to toggle completion menu
			local function toggle_completion_menu()
				state.features.completion_menu = not state.features.completion_menu
				
				local success, err = pcall(function()
					blink.setup(vim.tbl_deep_extend("force", blink.config or {}, {
						completion = {
							menu = {
								enabled = state.features.completion_menu
							}
						}
					}))
				end)
				
				if not success then
					vim.notify("Blink CMP completion menu toggle failed: " .. tostring(err), vim.log.levels.WARN)
				end
				
				local status = state.features.completion_menu and "enabled" or "disabled"
				vim.notify("Blink CMP completion menu " .. status, vim.log.levels.INFO)
			end
			
			-- Store toggle functions globally for keymap access
			_G.blink_cmp_toggles = {
				toggle_lsp = function() toggle_source("lsp") end,
				toggle_path = function() toggle_source("path") end,
				toggle_snippets = function() toggle_source("snippets") end,
				toggle_buffer = function() toggle_source("buffer") end,
				toggle_copilot = function() toggle_source("copilot") end,
				toggle_ghost_text = toggle_ghost_text,
				toggle_completion_menu = toggle_completion_menu,
				-- Helper to show current state
				show_status = function()
					local sources_status = {}
					for src, enabled in pairs(state.sources) do
						table.insert(sources_status, src .. ": " .. (enabled and "✓" or "✗"))
					end
					local features_status = {}
					for feat, enabled in pairs(state.features) do
						table.insert(features_status, feat .. ": " .. (enabled and "✓" or "✗"))
					end
					vim.notify(
						"Blink CMP Status:\nSources: " .. table.concat(sources_status, ", ") ..
						"\nFeatures: " .. table.concat(features_status, ", "),
						vim.log.levels.INFO
					)
				end,
			}
		end,
		
		keys = {
			{
				"<leader>Bl",
				function()
					if _G.blink_cmp_toggles then
						_G.blink_cmp_toggles.toggle_lsp()
					else
						vim.notify("Blink CMP toggles not initialized", vim.log.levels.ERROR)
					end
				end,
				desc = "Toggle Blink CMP LSP source",
			},
			{
				"<leader>Bp",
				function()
					if _G.blink_cmp_toggles then
						_G.blink_cmp_toggles.toggle_path()
					else
						vim.notify("Blink CMP toggles not initialized", vim.log.levels.ERROR)
					end
				end,
				desc = "Toggle Blink CMP Path source",
			},
			{
				"<leader>Bs",
				function()
					if _G.blink_cmp_toggles then
						_G.blink_cmp_toggles.toggle_snippets()
					else
						vim.notify("Blink CMP toggles not initialized", vim.log.levels.ERROR)
					end
				end,
				desc = "Toggle Blink CMP Snippets source",
			},
			{
				"<leader>Bb",
				function()
					if _G.blink_cmp_toggles then
						_G.blink_cmp_toggles.toggle_buffer()
					else
						vim.notify("Blink CMP toggles not initialized", vim.log.levels.ERROR)
					end
				end,
				desc = "Toggle Blink CMP Buffer source",
			},
			{
				"<leader>Bc",
				function()
					if _G.blink_cmp_toggles then
						_G.blink_cmp_toggles.toggle_copilot()
					else
						vim.notify("Blink CMP toggles not initialized", vim.log.levels.ERROR)
					end
				end,
				desc = "Toggle Blink CMP Copilot source",
			},
			{
				"<leader>Bg",
				function()
					if _G.blink_cmp_toggles then
						_G.blink_cmp_toggles.toggle_ghost_text()
					else
						vim.notify("Blink CMP toggles not initialized", vim.log.levels.ERROR)
					end
				end,
				desc = "Toggle Blink CMP ghost text",
			},
			{
				"<leader>Bm",
				function()
					if _G.blink_cmp_toggles then
						_G.blink_cmp_toggles.toggle_completion_menu()
					else
						vim.notify("Blink CMP toggles not initialized", vim.log.levels.ERROR)
					end
				end,
				desc = "Toggle Blink CMP completion menu",
			},
			{
				"<leader>BS",
				function()
					if _G.blink_cmp_toggles then
						_G.blink_cmp_toggles.show_status()
					else
						vim.notify("Blink CMP toggles not initialized", vim.log.levels.ERROR)
					end
				end,
				desc = "Show Blink CMP status",
			},
		},
	},
}