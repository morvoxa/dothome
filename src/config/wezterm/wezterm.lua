local wezterm = require("wezterm")
local config = wezterm.config_builder()

if wezterm.target_triple == "x86_64-pc-windows-msvc" or wezterm.target_triple:find("windows") then
	config.default_prog = { "powershell.exe", "-NoLogo" }
else
	config.default_prog = { os.getenv("SHELL") or "bash" }
end

config.keys = {
	{
		key = "L",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "H",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateTabRelative(-1),
	},
}

config.font = wezterm.font("JetBrainsMono Nerd Font")

config.window_decorations = "NONE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
return config
