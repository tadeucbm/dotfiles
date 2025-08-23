return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"giuxtaposition/blink-cmp-copilot",
		},
		
		opts = {
			-- Default configuration that we'll modify
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
				menu = {
					enabled = true,
				},
			},
		},
		
		config = function(_, opts)
			local blink = require('blink.cmp')
			
			-- Set up blink.cmp with the provided options
			blink.setup(opts)
			
			-- Store state for toggles
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
			
			-- Store original configuration for reference
			local original_config = vim.deepcopy(opts)
			
			-- Helper function to reload blink.cmp with new configuration
			local function reload_blink_config(new_config)
				local success, err = pcall(function()
					-- Try to reload the configuration
					blink.setup(new_config)
				end)
				
				if not success then
					vim.notify("Failed to reload Blink CMP configuration: " .. tostring(err), vim.log.levels.ERROR)
					return false
				end
				return true
			end
			
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
				
				-- Create new configuration
				local new_config = vim.tbl_deep_extend("force", original_config, {
					sources = {
						default = new_sources,
						providers = original_config.sources.providers,
					}
				})
				
				-- Try to apply new configuration
				if reload_blink_config(new_config) then
					local status = state.sources[source_name] and "enabled" or "disabled"
					vim.notify("Blink CMP " .. source_name .. " source " .. status, vim.log.levels.INFO)
				else
					-- Revert state on failure
					state.sources[source_name] = not state.sources[source_name]
				end
			end
			
			-- Helper function to toggle ghost text
			local function toggle_ghost_text()
				-- Toggle state
				state.features.ghost_text = not state.features.ghost_text
				
				-- Create new configuration
				local new_config = vim.tbl_deep_extend("force", original_config, {
					completion = {
						ghost_text = {
							enabled = state.features.ghost_text
						}
					}
				})
				
				-- Try to apply new configuration
				if reload_blink_config(new_config) then
					local status = state.features.ghost_text and "enabled" or "disabled"
					vim.notify("Blink CMP ghost text " .. status, vim.log.levels.INFO)
				else
					-- Revert state on failure
					state.features.ghost_text = not state.features.ghost_text
				end
			end
			
			-- Helper function to toggle completion menu
			local function toggle_completion_menu()
				-- Toggle state
				state.features.completion_menu = not state.features.completion_menu
				
				-- Create new configuration
				local new_config = vim.tbl_deep_extend("force", original_config, {
					completion = {
						menu = {
							enabled = state.features.completion_menu
						}
					}
				})
				
				-- Try to apply new configuration
				if reload_blink_config(new_config) then
					local status = state.features.completion_menu and "enabled" or "disabled"
					vim.notify("Blink CMP completion menu " .. status, vim.log.levels.INFO)
				else
					-- Revert state on failure
					state.features.completion_menu = not state.features.completion_menu
				end
			end
			
			-- Alternative approach: If dynamic reconfiguration doesn't work,
			-- provide a simpler toggle that temporarily disables all completion
			local completion_enabled = true
			local function toggle_completion()
				completion_enabled = not completion_enabled
				
				if completion_enabled then
					-- Re-enable completion
					vim.cmd('autocmd! BlinkCmpDisabled')
					vim.notify("Blink CMP re-enabled", vim.log.levels.INFO)
				else
					-- Disable completion by preventing it from triggering
					vim.cmd([[
						augroup BlinkCmpDisabled
						autocmd!
						autocmd InsertCharPre * lua vim.schedule(function() 
							if require('blink.cmp').is_open() then 
								require('blink.cmp').hide() 
							end 
						end)
						augroup END
					]])
					vim.notify("Blink CMP disabled", vim.log.levels.INFO)
				end
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
				toggle_completion = toggle_completion,
				-- Helper to show current state
				show_status = function()
					local sources_status = {}
					for src, enabled in pairs(state.sources) do
						table.insert(sources_status, src .. ": " .. (enabled and "✓" or "✗"))
					end
					local features_status = {}
					for feat, enabled in pairs(state.features) do
						table.insert(features_status, feat:gsub("_", " ") .. ": " .. (enabled and "✓" or "✗"))
					end
					local completion_status = completion_enabled and "✓" or "✗"
					
					vim.notify(
						"Blink CMP Status:\n" ..
						"Completion: " .. completion_status .. "\n" ..
						"Sources: " .. table.concat(sources_status, ", ") .. "\n" ..
						"Features: " .. table.concat(features_status, ", "),
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
				"<leader>Bt",
				function()
					if _G.blink_cmp_toggles then
						_G.blink_cmp_toggles.toggle_completion()
					else
						vim.notify("Blink CMP toggles not initialized", vim.log.levels.ERROR)
					end
				end,
				desc = "Toggle Blink CMP completely",
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