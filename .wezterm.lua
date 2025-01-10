local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

local config = wezterm.config_builder()

config.default_prog = { '/opt/homebrew/bin/fish', '-l' }
config.window_close_confirmation = 'NeverPrompt'


-- config.color_scheme = "Earthsong (base16)"
-- config.color_scheme = "Dracula+"
config.color_scheme = "Espresso"
config.window_frame = {
    font_size = 14,
}
config.command_palette_font_size = 14
config.tab_bar_at_bottom = true
-- config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
-- config.font = wezterm.font_with_fallback({
-- { family = "FiraCode Nerd Font", weight = "Regular" }
-- })
config.font_size = 13
config.front_end = "OpenGL"
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.cell_width = 0.9
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20
config.inactive_pane_hsb = {
    saturation = 0.7,
    brightness = 0.5,
}
-- config.initial_rows = 40
-- config.initial_cols = 150
config.keys = {
    -- { key = "Enter", mods = "ALT", action = "DisableDefaultAssignment" },
    { key = "a",          mods = "SHIFT|SUPER", action = wezterm.action.ActivateCommandPalette },
    {
        key = "d",
        mods = "CMD",
        action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
    },
    {
        key = "d",
        mods = "CMD|SHIFT",
        action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
    },
    {
        key = 'Enter',
        mods = 'SHIFT|CMD',
        action = wezterm.action.TogglePaneZoomState,
    },
    { key = "LeftArrow",  mods = "OPT|CMD",     action = wezterm.action({ ActivatePaneDirection = "Left" }) },
    { key = "RightArrow", mods = "OPT|CMD",     action = wezterm.action({ ActivatePaneDirection = "Right" }) },
    { key = "UpArrow",    mods = "OPT|CMD",     action = wezterm.action({ ActivatePaneDirection = "Up" }) },
    { key = "DownArrow",  mods = "OPT|CMD",     action = wezterm.action({ ActivatePaneDirection = "Down" }) },
}
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config)

return config
