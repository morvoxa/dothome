local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.default_prog = { "powershell.exe", "-NoLogo" }
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
return config
