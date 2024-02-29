local class = require "middleclass"
local tw = require "tween"
local font = resource.load_font "font_Lato-Regular.ttf"

local ServiceIndicator = class("ServiceIndicator")

function ServiceIndicator:initialize()
    self.status = "ok"
    self.code = 0
    self.desc = ""
    self.alpha = 0
end

function ServiceIndicator:update(status, code, desc)
    -- todo Handle all cases to fade out
    if self.status ~= "ok" and status == "ok" then
        tw:tween(self, "alpha", 1, 0, 2)
    else
        self.alpha = 1
    end

    self.status = status
    self.code = code
    self.desc = desc
end

function ServiceIndicator:draw()
    font:write(0, 0, self.desc, 24, 1, 1, 1, self.alpha)
end

return ServiceIndicator