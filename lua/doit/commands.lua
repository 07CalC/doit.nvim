local tasks = require("doit.tasks")

local M = {}

function M.register()
	vim.api.nvim_create_user_command("DoitAdd", function(opts)
		tasks.add(opts.args)
	end, { nargs = 1 })

	vim.api.nvim_create_user_command("DoitList", function()
		require("doit.ui").open()
	end, {})
end

return M
