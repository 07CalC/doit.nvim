> This document is partially AI generated

# doit.nvim

A simple todo/task manager for Neovim that stays scoped to your project. Tasks are automatically organized by project based on your git root directory, so you get a clean, relevant list no matter where you're working.


## Features

- Project-scoped tasks - each project gets its own task list
- Floating window UI for easy task management
- Toggle tasks as done/undone
- Pin important tasks to the top
- Add and delete tasks
- Quick keybindings for all actions
- Minimal and distraction-free design


## Installation

### Using lazy.nvim

```lua
{
  "username/doit.nvim",
  config = function()
    require("doit").setup({})
  end,
}
```

### Using packer.nvim

```lua
use {
  "username/doit.nvim",
  config = function()
    require("doit").setup({})
  end,
}
```


## Configuration

The plugin works out of the box with sensible defaults, but you can customize it:

```lua
require("doit").setup({
  data_dir = vim.fn.stdpath("data") .. "/doit",
  keymaps = {
    open = "<leader><leader>d",
  },
})
```

### Options

| Option | Default | Description |
|--------|---------|-------------|
| `data_dir` | `vim.fn.stdpath("data") .. "/doit"` | Directory where tasks are stored |
| `keymaps.open` | `"<leader><leader>d"` | Keybinding to open the task list |

Set `keymaps = false` to disable default keymaps entirely.


## Commands

| Command | Arguments | Description |
|---------|-----------|-------------|
| `:DoitList` | None | Open the task list UI |
| `:DoitAdd` | Task title (required) | Add a new task |

Examples:

```vim
:DoitList
:DoitAdd "Fix the bug in main.lua"
:DoitAdd "Review pull requests"
```


## Usage

### Opening the Task List

Press your configured keybinding (default `<leader><leader>d`) or run `:DoitList`.

### Task List Keybindings

When the task list window is open:

| Key | Action |
|-----|--------|
| `a` | Add a new task (prompts for title) |
| `x` or `Enter` | Toggle selected task done/undone |
| `p` | Pin or unpin the selected task |
| `d` | Delete the selected task |
| `q` | Close the task list |

### Task Display

Tasks are shown with visual indicators:

- `[ ]` - Task is not done
- `[x]` - Task is done
- `@` - Task is pinned (pinned tasks appear at the top)

Tasks are automatically sorted: pinned tasks first, then incomplete tasks, then completed tasks ordered by creation time.


## How It Works

### Project Detection

doit automatically determines your project context:

1. Looks for a `.git` directory starting from your current file and walking up
2. If no git repo found, uses the current file's directory
3. Falls back to Neovim's current working directory

Each project gets a unique ID based on its root path, ensuring tasks stay organized by project.

### Data Storage

Tasks are stored as JSON files in your configured `data_dir` under the `projects/` subdirectory. Each project has its own file named with a hash of the project path.


## Tips

- Tasks persist across Neovim sessions
- Switching between projects automatically shows the relevant task list
- The UI is read-only except for the defined keybindings to keep things simple
- Use pinning for tasks you want to keep visible at the top of your list


## License

MIT
