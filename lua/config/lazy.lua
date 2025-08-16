-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			opts = {},
		},
		{
			"nvim-treesitter/nvim-treesitter",
			branch = 'master',
			lazy = false,
			build = ":TSUpdate",
			config = function()
				require 'nvim-treesitter.configs'.setup {
					-- A list of parser names, or "all" (the listed parsers MUST always be installed)
					ensure_installed = { "lua", "markdown", "templ", "go" },
					auto_install = false,
					highlight = {
						enable = true,
						disable = function(lang, buf)
							local max_filesize = 100 * 1024 -- 100 KB
							local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
							if ok and stats and stats.size > max_filesize then
								return true
							end
						end,

						-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
						-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
						-- Using this option may slow down your editor, and you may see some duplicate highlights.
						-- Instead of true it can also be a list of languages

						-- TODO: might be useful to enable for php.
						additional_vim_regex_highlighting = { "php" },
					},
				}
			end
		},
		{
			'nvim-telescope/telescope.nvim',
			tag = '0.1.8',
			dependencies = {
				'nvim-lua/plenary.nvim'
			},
			config = function()
				vim.keymap.set("n", "<space>fd", require("telescope.builtin").find_files)
				vim.keymap.set("n", "<space>en", function()
					require("telescope.builtin").find_files {
						cwd = vim.fn.stdpath("config")
					}
				end)
			end

		},
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make'
		},
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
