return {
	'maxmx03/solarized.nvim',
	lazy = false,
	priority = 1000,
	---@type solarized.config
	opts = {
		-- palette = "selenized"
		variant = "spring",

		transparent = {
			enabled = true,
		},
	},
	config = function(_, opts)
		require('solarized').setup(opts)
	end,
}
