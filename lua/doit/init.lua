local M = {}

function M.setup(opts)
	require("doit.config").setup(opts)
	require("doit.commands").register()
end

return M
