local M = {}

M.options = {
	data_dir = vim.fn.stdpath("data") .. "/doit",
}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
