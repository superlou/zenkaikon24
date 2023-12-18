local class = require "middleclass"
require "color_util"

local Clock = class("Clock")

local font = resource.load_font "font_Lato-Regular.ttf"
local debug_bg = create_color_resource_hex("ffffff", 0.4)

function Clock:initialize(x, y, w, h, show_rect)
    self.x, self.y = x, y
    self.w, self.h = w, h
    self.font = font
    self.font_h = 55
    self.hh_mm = ""
    self.am_pm = ""
    self.spacing = 8
    self.show_rect = show_rect or false
end

function Clock:update(hh_mm, am_pm)
    self.hh_mm = hh_mm
    self.am_pm = am_pm
end

function Clock:draw()
    local x, y, w, h = self.x, self.y, self.w, self.h

    if self.show_rect then
        debug_bg:draw(x, y, x + w, y + h)
    end

    local hh_mm_w = self.font:width(self.hh_mm, self.font_h)
    local am_pm_w = self.font:width(self.am_pm, self.font_h * 0.5)
    local clock_w = hh_mm_w + self.spacing + am_pm_w
    local clock_h = self.font_h

    local text_y = y + h / 2 - clock_h / 2
    local hh_mm_x = x + w / 2 - clock_w / 2

    self.font:write(hh_mm_x, text_y,
                    self.hh_mm,
                    self.font_h,
                    1, 1, 1, 1)

    self.font:write(hh_mm_x + hh_mm_w + self.spacing, text_y,
                    self.am_pm,
                    self.font_h * 0.5,
                    1, 1, 1, 1)
end

return Clock