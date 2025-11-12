require("config.lazy")

-- Options
vim.opt.background = "dark"
vim.opt.title = true
vim.opt.titlestring = "%m %t"
vim.opt.swapfile = false
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
vim.opt.mouse = ""
vim.opt.expandtab = true
vim.opt.showmode = false
vim.g.netrw_fastbrowse = 0 -- Do not keep netrw buffer open.

-- Theme
vim.cmd("colorscheme quiet")
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

-- Disable mouse scroll, sent as arrow keys by terminal.
vim.keymap.set("", "<up>", "<nop>", { noremap = true })
vim.keymap.set("", "<down>", "<nop>", { noremap = true })
vim.keymap.set("i", "<up>", "<nop>", { noremap = true })
vim.keymap.set("i", "<down>", "<nop>", { noremap = true })
-- TODO: this would be simpler, but does not work?
-- vim.opt.mousescroll = "ver:0,hor:0"

-- Keymaps
vim.keymap.set("n", "-", "<cmd>Ex<CR>")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("n", "V", "V$")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
local ls = require("luasnip")
vim.keymap.set("i", "<Tab>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    else
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true),
            "n",
            true
        )
    end
end)

-- Use harpoon instead of some global marks so that cursor position is saved.
local harpoon = require("harpoon")
vim.keymap.set("n", "m1", function() harpoon:list():replace_at(1) end)
vim.keymap.set("n", "m2", function() harpoon:list():replace_at(2) end)
vim.keymap.set("n", "m3", function() harpoon:list():replace_at(3) end)
vim.keymap.set("n", "m4", function() harpoon:list():replace_at(4) end)
vim.keymap.set("n", "1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "4", function() harpoon:list():select(4) end)

-- TODO: fix:
vim.keymap.set("n", "gco", "o" .. vim.bo.commentstring:gsub("%%s", ""))
vim.keymap.set("n", "gcO", "O" .. vim.bo.commentstring:gsub("%%s", ""))

-- LSP
vim.lsp.enable({ "gopls", "html", "lua_ls", "shopify_theme_ls",
    "templ", "ts_ls", "eslint", "cssls", "astro", "phpactor" })
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

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    callback = function(args)
        if vim.bo[args.buf].filetype == 'markdown' then
            vim.keymap.set("n", "<leader>r", "<cmd>RenderMarkdown toggle<CR>", { buffer = true })
            vim.cmd('RenderMarkdown enable')
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
            vim.opt_local.columns = 80
            -- Move cursor over wrapped lines.
            vim.keymap.set("n", "j", "gj", { buffer = true })
            vim.keymap.set("n", "k", "gk", { buffer = true })
        end
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

        -- Format on save.
        if not (client:supports_method('textDocument/willSaveWaitUntil')
                and client:supports_method('textDocument/formatting')) then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                buffer = 0,
                callback = function()
                    vim.lsp.buf.format({ bufnr = 0, id = client.id, timeout_ms = 1000, })
                end
            })
        end
    end,
})
