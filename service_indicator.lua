local class = require "middleclass"
local tw = require "tween"
local font = resource.load_font "font_Lato-Regular.ttf"

local ServiceIndicator = class("ServiceIndicator")

function ServiceIndicator:initialize()
    self.text = ""
    self.alpha = 1
end

function ServiceIndicator:update(status)
    -- todo Handle all cases to fade out
    if self.text ~= "updated" and status == "updated" then
        tw:tween(self, "alpha", 1, 0, 2)
    else
        self.alpha = 1
    end

    self.text = status
end

function ServiceIndicator:draw()
    font:write(0, 0, self.text, 24, 1, 1, 1, self.alpha)
end

return ServiceIndicator