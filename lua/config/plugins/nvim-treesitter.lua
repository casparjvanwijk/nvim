return {
	{
		enabled = true,
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua", "markdown", "templ", "go", "sql",
					"javascript", "typescript", "php", "liquid" },
				auto_install = false,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "php" },
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["if"] = "@function.inner",
							["af"] = "@function.outer",
							["ia"] = "@parameter.inner",
							["aa"] = "@parameter.outer",
						},
						include_surrounding_whitespace = true,
					},
				},
			})
		end
	},
}
