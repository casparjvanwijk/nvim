return {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependencies = {
			'nvim-lua/plenary.nvim'
		},
		config = function()
			require("telescope").setup({
				defaults = require("telescope.themes").get_dropdown({
					preview = false,
				}),
				extensions = {
					fzf = {}
				}
			})

			require("telescope").load_extension("fzf")

			vim.keymap.set("n", "<C-p>", require("telescope.builtin").git_files)
			vim.keymap.set("n", "<leader>f", require("telescope.builtin").live_grep)
			vim.keymap.set("n", "<leader>b", require("telescope.builtin").buffers)
			vim.keymap.set("n", "<leader>h", require("telescope.builtin").help_tags)
			vim.keymap.set("n", "<leader>s", require("telescope.builtin").lsp_document_symbols)
			vim.keymap.set("n", "<leader>,", function()
				require("telescope.builtin").find_files({
					cwd = vim.fn.stdpath("config"),
				})
			end)
		end
	},


}
