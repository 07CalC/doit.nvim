local M = {}

M.options = {
	data_dir = vim.fn.stdpath("data") .. "/doit",
	keymaps = {
		open = "<leader><leader>d",
	},
}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
