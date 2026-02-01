local M = {}

function M.setup(opts)
	local config = require("doit.config")
	config.setup(opts)

	require("doit.commands").register()

	local km = config.options.keymaps
	if km ~= false and km and km.open then
		vim.keymap.set("n", km.open, "<cmd>DoitList<CR>", { desc = "DoIt: open task list" })
	end
end

return M
