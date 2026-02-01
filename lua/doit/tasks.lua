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
		pinned = false,
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

function M.toggle_pin_by_id(id)
	local items = store.load()
	for _, t in ipairs(items) do
		if t.id == id then
			t.pinned = not t.pinned
			break
		end
	end
	store.save(items)
end

function M.toggle_done_by_id(id)
	local items = store.load()
	for _, t in ipairs(items) do
		if t.id == id then
			t.done = not t.done
			break
		end
	end
	store.save(items)
end

function M.delete_by_id(id)
	local items = store.load()
	for i, t in ipairs(items) do
		if t.id == id then
			table.remove(items, i)
			break
		end
	end
	store.save(items)
end

function M.list()
	local items = store.load()
	table.sort(items, function(a, b)
		-- pinned first
		if a.pinned ~= b.pinned then
			return a.pinned
		end
		-- undone before done
		if a.done ~= b.done then
			return not a.done
		end
		-- aat the end done one
		return a.created_at < b.created_at
	end)
	return items
end

return M
