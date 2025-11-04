return {
    "L3MON4D3/LuaSnip",
    version = "v2.4",
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    config = function()
        local ls = require("luasnip")
        local s = ls.snippet
        local i = ls.insert_node
        local rep = require("luasnip.extras").rep
        local fmt = require("luasnip.extras.fmt").fmt

        ls.setup({
            history = false,
            update_events = { "TextChanged", "TextChangedI" },
        })

        ls.add_snippets("go", {
            s("fp", fmt('fmt.Println("{}")', { i(1) })),
            s("fpd", fmt('fmt.Println("{}", {})', { i(1), rep(1) }))
        })
        ls.add_snippets("javascript", {
            s("cl", fmt('console.log("{}", {})', { i(1), rep(1) }))
        })
        ls.filetype_extend("javascriptreact", { "javascript" })
        ls.filetype_extend("typescript", { "javascript" })
        ls.filetype_extend("typescriptreact", { "javascriptreact" })
    end,
}
