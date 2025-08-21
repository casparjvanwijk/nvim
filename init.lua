require("config.lazy")

-- TODO: check color scheme "vague"
-- TODO: check harpoon
-- TODO: auto complete

-- LSP
vim.lsp.enable({ "gopls", "html", "lua_ls", "shopify_theme_ls", "templ", "ts_ls", "eslint" })
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

-- Options
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

-- Keymaps
vim.keymap.set("n", "-", "<cmd>Ex<CR>")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("n", "V", "V$")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

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
