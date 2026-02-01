local store = require("doit.store")

local M = {}

local function gen_id()
	return tostring(os.time()) .. "-" .. tostring(math.random(100000, 999999))
end

function M.add(title)
	local tasks = store.load()
	table.insert(tasks, {
		id = gen_id(),
		title = title,
		done = false,
		created_at = os.time(),
	})
	store.save(tasks)
end

function M.toggle_done(index)
	local tasks = store.load()
	if tasks[index] then
		tasks[index].done = not tasks[index].done
		store.save(tasks)
	end
end

function M.delete(index)
	local tasks = store.load()
	if tasks[index] then
		table.remove(tasks, index)
		store.save(tasks)
	end
end

function M.list()
	return store.load()
end

return M
