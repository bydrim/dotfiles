-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Everforest Dark (Gogh)"

config.font = wezterm.font("RobotoMono Nerd Font")
config.font_size = 13

-- disable ligatures
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.window_background_opacity = 0.97
config.enable_scroll_bar = true

config.initial_cols = 130 -- max 138 currently
config.initial_rows = 16

config.hide_tab_bar_if_only_one_tab = true

-- disable window title
config.window_decorations = "RESIZE"

-- and finally, return the configuration to wezterm
return config
