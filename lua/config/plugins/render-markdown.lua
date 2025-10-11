return {
    enabled = false,
    'MeanderingProgrammer/render-markdown.nvim',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    config = function()
        require('render-markdown').setup({
            anti_conceal = {
                enabled = false,
            },
            heading = {
                sign = false,
                icons = '',
                border = true,
                border_virtual = true,
            },
            link = {
                -- Turn on / off inline link icon rendering.
                enabled = false,
            },
            code = {
                sign = false,
                language_icon = false,
                language_name = false,
                border = 'thick',
            },
        })
    end

}
