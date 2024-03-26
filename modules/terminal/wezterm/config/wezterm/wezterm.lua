local wezterm = require 'wezterm'
local config = {}
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 10.0
config.enable_tab_bar = false
config.line_height = 1.0
config.warn_about_missing_glyphs = false
config.window_background_opacity = 0.8
config.color_scheme = 'Catppuccin mocha'
config.default_cursor_style = 'SteadyBar'
-- config.keys = {
--     {
--         key = 'r',
--         mod = 'Control',
--         action = 'fzf',
--     }
-- }
-- config.window_padding = {
--   top = 0,
-- }
return config
