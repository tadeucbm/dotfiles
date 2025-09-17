return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	config = function()
		local lualine_config = {
			options = {
				theme = {
					normal = {
						a = { fg = "#101010", bg = "#ffc799", gui = "bold" }, -- peach background for mode
						b = { fg = "#ffc799", bg = "#101010" }, -- simplified background
						c = { fg = "#ffc799", bg = "#101010" }, -- consistent background
					},
					insert = {
						a = { fg = "#101010", bg = "#ffc799", gui = "bold" },
						b = { fg = "#ffc799", bg = "#101010" },
						c = { fg = "#ffc799", bg = "#101010" },
					},
					visual = {
						a = { fg = "#101010", bg = "#ffc799", gui = "bold" },
						b = { fg = "#ffc799", bg = "#101010" },
						c = { fg = "#ffc799", bg = "#101010" },
					},
					replace = {
						a = { fg = "#101010", bg = "#ffc799", gui = "bold" },
						b = { fg = "#ffc799", bg = "#101010" },
						c = { fg = "#ffc799", bg = "#101010" },
					},
					command = {
						a = { fg = "#101010", bg = "#ffc799", gui = "bold" },
						b = { fg = "#ffc799", bg = "#101010" },
						c = { fg = "#ffc799", bg = "#101010" },
					},
				},
				globalstatus = true,
				component_separators = { left = "│", right = "│" }, -- tmux-style separators
				section_separators = { left = "", right = "" }, -- clean sections
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{
						"branch",
						icon = "",
					},
					{
						"diff",
						symbols = { added = "+", modified = "~", removed = "-" },
					},
				},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
		}

		-- Always setup lualine - vim-tpipeline will handle hiding it in tmux
		require("lualine").setup(lualine_config)
	end,
}
