local store = require("doit.store")
local project = require("doit.project")

local M = {}

local function gen_id()
	return tostring(os.time()) .. "-" .. tostring(math.random(100000, 999999))
end

local function current_project_id()
	return project.cached_id()
end

function M.add(title)
	local tasks = store.load()
	table.insert(tasks, {
		id = gen_id(),
		title = title,
		done = false,
		pinned = false,
		created_at = os.time(),
		project_id = current_project_id(),
	})
	store.save(tasks)
end

local function find_task_by_id(items, id)
	local pid = current_project_id()
	for i, t in ipairs(items) do
		if t.id == id then
			if t.project_id == nil or t.project_id == pid then
				return i, t
			end
		end
	end
	return nil, nil
end

function M.toggle_done(index)
	local tasks = store.load()
	if tasks[index] then
		local pid = current_project_id()
		if tasks[index].project_id == nil or tasks[index].project_id == pid then
			tasks[index].done = not tasks[index].done
			store.save(tasks)
		end
	end
end

function M.delete(index)
	local tasks = store.load()
	if tasks[index] then
		local pid = current_project_id()
		if tasks[index].project_id == nil or tasks[index].project_id == pid then
			table.remove(tasks, index)
			store.save(tasks)
		end
	end
end

function M.toggle_pin_by_id(id)
	local items = store.load()
	local _, t = find_task_by_id(items, id)
	if t then
		t.pinned = not t.pinned
		store.save(items)
	end
end

function M.toggle_done_by_id(id)
	local items = store.load()
	local _, t = find_task_by_id(items, id)
	if t then
		t.done = not t.done
		store.save(items)
	end
end

function M.delete_by_id(id)
	local items = store.load()
	local i, _ = find_task_by_id(items, id)
	if i then
		table.remove(items, i)
		store.save(items)
	end
end

function M.list()
	local items = store.load()
	local pid = current_project_id()

	local filtered = {}
	for _, t in ipairs(items) do
		if t.project_id == nil or t.project_id == pid then
			table.insert(filtered, t)
		end
	end

	table.sort(filtered, function(a, b)
		if a.pinned ~= b.pinned then
			return a.pinned
		end
		if a.done ~= b.done then
			return not a.done
		end
		return a.created_at < b.created_at
	end)
	return filtered
end

return M
