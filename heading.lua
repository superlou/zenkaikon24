require "color_util"
require "text_util"

local heading_dark_bg = create_color_resource_hex("e91e63")
local heading_dark_bg_shadow = create_color_resource_hex("bb114b")

local heading_light_bg_shadow = create_color_resource_hex("333195")
local light_r, light_g, light_b = hex2rgb("333195")
local size = 64

function draw_heading_dark(font, x, y, text)
    local font_w = font:width(text, size)
    heading_dark_bg:draw(x - font_w / 2 - 50, y - 24, x + font_w / 2 + 50, y + size + 16)
    heading_dark_bg_shadow:draw(x - font_w / 2 - 50, y + size + 16, x + font_w / 2 + 50, y + size + 16 + 8)
    write_centered(font, x, y, text, size, 1, 1, 1, 1)
end

function draw_heading_light(font, x, y, text)
    local font_w = font:width(text, size)
    heading_light_bg_shadow:draw(x - font_w / 2 - 50, y + size + 16, x + font_w / 2 + 50, y + size + 16 + 8)
    write_centered(font, x, y, text, size, light_r, light_g, light_b, 1)
end
