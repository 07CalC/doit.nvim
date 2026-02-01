local tasks = require("doit.tasks")

local M = {}

local function block_default_motions(buf)
	local opts = { buffer = buf, silent = true, nowait = true }

	local blocked = {
		"h",
		"l",
		"w",
		"b",
		"e",
		"0",
		"^",
		"$",
		"gg",
		"G",
		"{",
		"}",
		"f",
		"F",
		"t",
		"T",
		";",
		",",
		"<C-d>",
		"<C-u>",
		"<C-f>",
		"<C-b>",
		"H",
		"M",
		"L",
		"%",
		"*",
		"#",
		"n",
		"N",
		"z",
		"zt",
		"zz",
		"zb",
		"o",
		"O",
		"i",
		"I",
		"a",
		"A",
		"v",
		"V",
		"<C-v>",
		"s",
		"S",
		"c",
		"C",
		"r",
		"R",
		"u",
		"<C-r>",
		"x",
		"X",
		"dd",
		"D",
		"yy",
		"p",
		"P",
	}

	for _, key in ipairs(blocked) do
		vim.keymap.set("n", key, "<Nop>", opts)
	end
end

local state = {
	buf = nil,
	win = nil,
}

local function get_tasks()
	return tasks.list() or {}
end

local function apply_highlights(items)
	vim.api.nvim_buf_clear_namespace(state.buf, -1, 0, -1)

	for i, t in ipairs(items) do
		if t.pinned then
			vim.api.nvim_buf_add_highlight(state.buf, -1, "Keyword", i - 1, 0, -1)
		elseif t.done then
			vim.api.nvim_buf_add_highlight(state.buf, -1, "Comment", i - 1, 0, -1)
		end
	end
end

local function render(keep_cursor)
	local items = get_tasks()
	local lines = {}

	if #items == 0 then
		lines = { "No tasks yet. Press 'a' to add one." }
	else
		for i, t in ipairs(items) do
			local mark = t.done and "[x]" or "[ ]"
			local pin = t.pinned and "@ " or ""
			table.insert(lines, string.format("%2d %s %s%s", i, mark, pin, t.title))
		end
	end

	local cursor
	if keep_cursor then
		cursor = vim.api.nvim_win_get_cursor(state.win)
	end

	vim.bo[state.buf].modifiable = true
	vim.bo[state.buf].readonly = false

	vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)

	vim.bo[state.buf].modifiable = false
	vim.bo[state.buf].readonly = true

	apply_highlights(items)

	if cursor then
		vim.api.nvim_win_set_cursor(state.win, { math.min(cursor[1], #lines), cursor[2] })
	end
end

local function current_task()
	local items = get_tasks()
	local row = vim.api.nvim_win_get_cursor(state.win)[1]
	return items[row]
end

local function with_task(fn)
	return function()
		local task = current_task()
		if not task then
			return
		end

		fn(task.id)

		render(false)

		local items = get_tasks()
		for i, t in ipairs(items) do
			if t.id == task.id then
				vim.api.nvim_win_set_cursor(state.win, { i, 0 })
				return
			end
		end
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
	block_default_motions(state.buf)

	vim.bo[state.buf].buftype = "nofile"
	vim.bo[state.buf].bufhidden = "wipe"
	vim.bo[state.buf].swapfile = false
	vim.bo[state.buf].filetype = "doit"
	vim.bo[state.buf].readonly = true
	vim.bo[state.buf].modifiable = false
	vim.wo[state.win].wrap = true
	vim.wo[state.win].linebreak = true
	vim.wo[state.win].breakindent = true
	vim.wo[state.win].number = false
	vim.wo[state.win].relativenumber = false
	vim.wo[state.win].cursorline = true

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

	map("p", with_task(tasks.toggle_pin_by_id))
	map("x", with_task(tasks.toggle_done_by_id))
	map("<CR>", with_task(tasks.toggle_done_by_id))
	map("d", with_task(tasks.delete_by_id))

	map("a", function()
		vim.ui.input({ prompt = "New task: " }, function(input)
			if input and input ~= "" then
				tasks.add(input)
				render(true)
			end
		end)
	end)
end

return M
