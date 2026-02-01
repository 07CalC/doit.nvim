local M = {}

function M.root()
	local git = vim.fn.finddir(".git", ".;")
	if git ~= "" then
		return vim.fn.fnamemodify(git, ":h")
	end
	return vim.fn.getcwd()
end

function M.id()
	return vim.fn.sha256(M.root())
end

return M
