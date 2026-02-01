local M = {}

local cached_project_id = nil
local cached_project_root = nil

function M.root()
	local git = vim.fn.finddir(".git", ".;")
	if git ~= "" then
		return vim.fn.fnamemodify(git, ":p:h")
	end
	local buf_path = vim.fn.expand("%:p:h")
	if buf_path ~= "" and buf_path ~= "." then
		return buf_path
	end
	return vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
end

function M.id()
	return vim.fn.sha256(M.root())
end

function M.cached_id()
	if cached_project_id then
		return cached_project_id
	end
	return M.id()
end

function M.set_context()
	cached_project_root = M.root()
	cached_project_id = vim.fn.sha256(cached_project_root)
	return cached_project_id
end

function M.clear_context()
	cached_project_id = nil
	cached_project_root = nil
end

function M.cached_root()
	return cached_project_root or M.root()
end

return M
