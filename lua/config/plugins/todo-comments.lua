return {
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
			keywords = {
				TODO = { color = "warning" },
				HACK = { color = "warning" },
				TEMP = { color = "warning" },
			},
			gui_style = {
				fg = "NONE",
				bg = "NONE",
			},
			highlight = {
				multiline = false,  -- enable multine todo comments
				before = "",        -- "fg" or "bg" or empty
				keyword = "bg",     -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
				after = "",         -- "fg" or "bg" or empty
				pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlighting (vim regex)
			},
			colors = {
				warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
			},
			search = {
				pattern = [[\b(KEYWORDS)\b]],
			},
		}
	},
}
