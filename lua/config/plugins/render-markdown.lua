return {
    enabled = true,
    'MeanderingProgrammer/render-markdown.nvim',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    config = function()
        local heading_pad = { 40, 25, 4, 4, 4, 4 }
        require('render-markdown').setup({
            render_modes = { 'n', 'no', 'v', 'V', 'i', 'R', 'c', 't' },
            anti_conceal = {
                enabled = false,
            },
            heading = {
                sign = false,
                width = 'block',
                icons = '',
                backgrounds = 'CursorLine',
                foregrounds = 'CursorLine',
                -- Use indentation to show heading level.
                left_pad = { heading_pad[1] - 2, heading_pad[2] - 3, heading_pad[3] - 4, heading_pad[4] - 5, heading_pad[5] - 6, heading_pad[6] - 7 }, -- Use indentation to show heading level.
                -- Make text appear centered within the block background.
                right_pad = { heading_pad[1], heading_pad[2], heading_pad[3], heading_pad[4], heading_pad[5], heading_pad[6] },                        -- Make text appear centered within the block background.
                -- OLD:
                -- icons = false, -- Setting icons to false keeps the # symbols.
                -- sign = true,
                -- signs = { '1', '2', '3', '4' },
                -- left_margin = { 0, 1, 2, 3, 4, 5 },
                -- border = { true, false },
                -- border_virtual = { true, false },
                -- border_prefix = true,
            },
            link = {
                -- Turn off inline link icon rendering.
                enabled = false,
            },
            checkbox = {
                checked = {
                    scope_highlight = '@markup.strikethrough',
                },
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
