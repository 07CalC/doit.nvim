local M = {}
local projects = require("doit.project")

local base = vim.fn.stdpath("data") .. "/doit/projects/"

local function path()
	return base .. projects.id() .. ".json"
end

function M.load()
	local p = path()
	if vim.fn.filereadable(p) == 0 then
		return {}
	end
	local data = vim.fn.readfile(p)
	return vim.json.decode(table.concat(data, "\n"))
end

function M.save(tasks)
	vim.fn.mkdir(base, "p")
	vim.fn.writefile({ vim.json.encode(tasks) }, path())
end

return M
