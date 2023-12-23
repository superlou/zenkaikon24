require "color_util"
require "text_util"
local Tween, _ = unpack(require "tween")
local class = require "middleclass"

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

local Heading = class("Heading")

function Heading:initialize(text, heading_style)
    self.text = text
    self.font = heading_style.font
    self.font_size = heading_style.font_size
    self.text_color = heading_style.text_color
    self.bg_color = heading_style.bg_color or create_color_resource_hex("ffffff", 0)
    self.shadow_color = heading_style.shadow_color or create_color_resource_hex("ffffff", 0)
    self.padding = heading_style.padding or 0

    self.text_y_offset = 0
    self.text_alpha = 0
    self.width_animator = 0
    Tween:new(self, "text_y_offset", 40, 0, 0.5)
    Tween:new(self, "text_alpha", 0, 1, 0.5)
    Tween:new(self, "width_animator", 0.8, 1, 0.5)
end

function Heading:draw()
    local text_r, text_g, text_b = unpack(self.text_color)
    local font_w = self.font:width(self.text, self.font_size)

    heading_light_bg_shadow:draw(
        -(font_w / 2 + self.padding) * self.width_animator, size + 16,
        (font_w / 2 + self.padding) * self.width_animator, size + 16 + 8
    )

    write_centered(
        self.font, 0, self.text_y_offset, self.text, self.font_size,
        text_r, text_g, text_b, self.text_alpha
    )
end

function Heading:start_exit()
    Tween:new(self, "text_alpha", 1, 0, 0.5)
    Tween:new(self, "width_animator", 1, 0, 0.5)
end

return Heading