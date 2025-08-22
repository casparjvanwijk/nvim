require("config.lazy")

-- TODO: snippets

-- Options
vim.opt.background = "dark"
vim.opt.title = true
vim.opt.titlestring = "%m %t"
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.wrap = false
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 0
vim.opt.winborder = "rounded" -- Required to show border on hover popup.
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

-- Themes
vim.cmd("colorscheme github_dark_default")
-- vim.cmd("colorscheme catppuccin-frappe")
-- vim.cmd("colorscheme solarized")
-- vim.cmd("colorscheme tokyonight-night")
-- vim.cmd("colorscheme zenbones")
-- vim.cmd("colorscheme arctic")
-- vim.cmd("colorscheme mellow")

-- vim.cmd("colorscheme mellifluous")
-- vim.cmd("Mellifluous toggle_transparency")
-- vim.cmd("Mellifluous mountain")

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		-- Remove background from any theme.
		vim.cmd([[
		  hi Normal guibg=NONE ctermbg=NONE
		  hi NormalNC guibg=NONE ctermbg=NONE
		  hi SignColumn guibg=NONE ctermbg=NONE
		  hi VertSplit guibg=NONE ctermbg=NONE
		  hi StatusLine guibg=NONE ctermbg=NONE
		  hi StatusLineNC guibg=NONE ctermbg=NONE
		  hi LineNr guibg=NONE ctermbg=NONE
		  hi EndOfBuffer guibg=NONE ctermbg=NONE
		]])

		-- Do not use italics in any highlight group.
		for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
			local hl = vim.api.nvim_get_hl(0, { name = group })
			if hl.italic then
				hl.italic = false
				vim.api.nvim_set_hl(0, group, hl)
			end
		end
	end,
})

-- Keymaps
vim.keymap.set("n", "-", "<cmd>Ex<CR>")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("n", "V", "V$")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("n", "gco", "o" .. vim.bo.commentstring:gsub("%%s", ""))
vim.keymap.set("n", "gcO", "O" .. vim.bo.commentstring:gsub("%%s", ""))

-- LSP
vim.lsp.enable({ "gopls", "html", "lua_ls", "shopify_theme_ls",
	"templ", "ts_ls", "eslint", "cssls" })
vim.lsp.config("*", {
	root_markers = { ".git" },
})
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				-- Define vim global.
				library = vim.api.nvim_get_runtime_file("", true),
			}
		}
	}
})
vim.lsp.config("eslint", {})

vim.diagnostic.config({ jump = { float = true } })

-- Autocommands
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	callback = function()
		-- Do not continue comments when inserting newline.
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({
			higroup = "Visual",
		})
	end
})

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		if client:supports_method('textDocument/definition') then
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
		end

		if not client:supports_method('textDocument/willSaveWaitUntil')
			and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000, })
				end,
			})
		end
	end,
})
