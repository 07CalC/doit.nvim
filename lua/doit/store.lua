local M = {}
local projects = require("doit.project")

local base = vim.fn.stdpath("data") .. "/doit/projects/"

local function path(project_id)
	local id = project_id or projects.cached_id()
	return base .. id .. ".json"
end

function M.load(project_id)
	local p = path(project_id)
	if vim.fn.filereadable(p) == 0 then
		return {}
	end
	local data = vim.fn.readfile(p)
	return vim.json.decode(table.concat(data, "\n"))
end

function M.save(tasks, project_id)
	vim.fn.mkdir(base, "p")
	vim.fn.writefile({ vim.json.encode(tasks) }, path(project_id))
end

return M
