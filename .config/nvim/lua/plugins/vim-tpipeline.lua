return {
	"vimpostor/vim-tpipeline",
	dependencies = { "nvim-lualine/lualine.nvim" },
	config = function()
		-- Let vim-tpipeline handle everything automatically
		vim.g.tpipeline_autoembed = 1
		
		-- Ensure focus events are properly handled
		vim.g.tpipeline_focusevents = 1
		
		-- Force hide statusline in tmux after lualine loads
		if vim.env.TMUX then
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					vim.opt.laststatus = 0
				end,
			})
		end
	end,
}