local tasks = require("doit.tasks")

local M = {}

local state = {
	buf = nil,
	win = nil,
}

local function get_tasks()
	return tasks.list() or {}
end

local function render()
	local items = get_tasks()
	local lines = {}

	if #items == 0 then
		lines = { "No tasks yet. Press 'a' to add one." }
	else
		for i, t in ipairs(items) do
			local mark = t.done and "[x]" or "[ ]"
			table.insert(lines, string.format("%2d %s %s", i, mark, t.title))
		end
	end

	vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
end

local function current_index()
	local row = vim.api.nvim_win_get_cursor(state.win)[1]
	return row
end

local function with_task(fn)
	return function()
		local items = get_tasks()
		if #items == 0 then
			return
		end
		fn(current_index())
		render()
	end
end

function M.open()
	state.buf = vim.api.nvim_create_buf(false, true)
	state.win = vim.api.nvim_open_win(state.buf, true, {
		relative = "editor",
		width = 60,
		height = 20,
		row = math.floor((vim.o.lines - 20) / 2),
		col = math.floor((vim.o.columns - 60) / 2),
		border = "rounded",
	})

	vim.bo[state.buf].buftype = "nofile"
	vim.bo[state.buf].bufhidden = "wipe"
	vim.bo[state.buf].modifiable = true
	vim.bo[state.buf].swapfile = false
	vim.bo[state.buf].filetype = "doit"

	render()

	local map = function(lhs, rhs)
		vim.keymap.set("n", lhs, rhs, {
			buffer = state.buf,
			silent = true,
			nowait = true,
		})
	end

	map("q", function()
		vim.api.nvim_win_close(state.win, true)
	end)

	map(
		"x",
		with_task(function(idx)
			tasks.toggle_done(idx)
		end)
	)

	map(
		"d",
		with_task(function(idx)
			tasks.delete(idx)
		end)
	)

	map("a", function()
		vim.ui.input({ prompt = "New task: " }, function(input)
			if input and input ~= "" then
				tasks.add(input)
				render()
			end
		end)
	end)
end

return M
