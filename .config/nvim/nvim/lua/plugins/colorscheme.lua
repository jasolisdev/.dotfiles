return {
	{
		"sainnhe/gruvbox-material",
		lazy = false, -- load at startup
		priority = 1000, -- load before other UI plugins
		config = function()
			vim.opt.termguicolors = true

			-- gruvbox-material options
			vim.g.gruvbox_material_background = "medium" -- "hard", "medium", "soft"
			vim.g.gruvbox_material_enable_bold = 1
			vim.g.gruvbox_material_enable_italic = 1
			vim.g.gruvbox_material_transparent_background = 1

			-- DO NOT call :colorscheme here, LazyVim will do it
		end,
	},
}
