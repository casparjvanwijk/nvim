return {
	{
		enabled = true,
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua", "markdown", "templ", "go",
					"javascript", "typescript", "php", "liquid" },
				auto_install = false,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "php" },
				},
			})
		end
	},
}
