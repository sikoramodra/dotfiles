-- See current bindings and descriptions:
-- omarchy menu keybindings --print

-- Disable a default binding without replacing it.
hl.unbind("SUPER + J")
hl.unbind("SUPER + P")
hl.unbind("SUPER + CTRL + F")
hl.unbind("SUPER + ALT + F")
hl.unbind("SUPER + ALT + Home")
hl.unbind("SUPER + Home")
hl.unbind("SUPER + L")
hl.unbind("SUPER + SHIFT + RETURN")

-- Add a new binding.
-- o.bind("SUPER + ALT + RETURN", "Tmux", { omarchy = "terminal-tmux" })
-- o.bind("SUPER + CTRL + RETURN", "Herdr", { omarchy = "terminal-herdr" })
o.bind("SUPER + SHIFT + M", "Music TUI", { tui = "cliamp", focus = true })
o.bind("SUPER + SHIFT + D", "Docker", { tui = "omarchy-launch-docker-tui" })
-- o.bind("SUPER + SHIFT + O", "Obsidian", { launch = "obsidian", focus = "^obsidian$" })

-- Change an existing binding by unbinding it first, then binding the key again.
hl.unbind("SUPER + SHIFT + N")
o.bind("SUPER + SHIFT + N", "Editor", { launch = "zeditor" })

hl.unbind("SUPER + K")
o.bind("SUPER + B", "Keybindings", "omarchy-menu-keybindings")

hl.unbind("SUPER + CTRL + V")
o.bind("SUPER + SHIFT + P", "Clipboard manager", "omarchy-shell shell toggle omarchy.clipboard")

hl.unbind("SUPER + ALT + SPACE")
o.bind("SUPER + SHIFT + RETURN", "Apps menu", "omarchy-menu toggle apps")

hl.unbind("SUPER + SPACE")
o.bind("SUPER + SHIFT + CTRL + RETURN", "Omarchy menu", "omarchy-menu toggle")

hl.unbind("SUPER + W")
o.bind("SUPER + SHIFT + C", "Close window", hl.dsp.window.close())

for workspace = 1, 10 do
	local key = "code:" .. tostring(workspace + 9)
	hl.unbind("SUPER + SHIFT + " .. key)
	hl.unbind("SUPER + SHIFT + ALT + " .. key)
	o.bind(
		"SUPER + SHIFT + " .. key,
		"Move window to workspace " .. workspace,
		hl.dsp.window.move({ workspace = tostring(workspace), follow = false })
	)
end

hl.unbind("SUPER + ALT + S")
o.bind(
	"SUPER + SHIFT + S",
	"Move window to scratchpad",
	hl.dsp.window.move({ workspace = "special:scratchpad", follow = false })
)

hl.unbind("SUPER + CTRL + Q")
o.bind("SUPER + CTRL + Q", "Calculator", "gnome-calculator")
hl.unbind("XF86Calculator")
o.bind("XF86Calculator", "Calculator", "gnome-calculator")

o.bind("SUPER + J", "Focus next window in layout", hl.dsp.layout("cyclenext"))
o.bind("SUPER + K", "Focus previous window in layout", hl.dsp.layout("cycleprev"))

o.bind("SUPER + SHIFT + J", "Swap next window in layout", hl.dsp.layout("swapnext"))
o.bind("SUPER + SHIFT + K", "Swap previous window in layout", hl.dsp.layout("swapprev"))

o.bind("SUPER + H", "Expand window left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
o.bind("SUPER + L", "Shrink window left", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))

o.bind("SUPER + SHIFT + H", "Add master window", hl.dsp.layout("addmaster"))
o.bind("SUPER + SHIFT + L", "Remove master window", hl.dsp.layout("removemaster"))
