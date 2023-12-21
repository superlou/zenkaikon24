local class = require "middleclass"
local Topic = require "topic"
local InfoTopic = class("InfoTopic", Topic)
require "text_util"
local Tween, _ = unpack(require "tween")

function InfoTopic:initialize(w, h, style, duration, heading, text)
    Topic.initialize(self, w, h, style, duration)
    self.heading = heading
    self.text = text
    self.font_size = 40

    self.lines = wrap_text(self.text, self.style.text.font, self.font_size, self.w)
    self.alpha = 0
    self.y_offset = 0

    Tween:new(self, "alpha", 0, 1, 0.5)
    Tween:new(self, "y_offset", 20, 0, 0.5)

    Tween:new(self, "alpha", 1, 0, 0.5):delay(duration):on_done(function()
        self:set_done()
    end)
end

function InfoTopic:draw()
    local r, g, b = self.style.text.color[1], self.style.text.color[2], self.style.text.color[3]

    for i, line in ipairs(self.lines) do
        self.style.text.font:write(
            0, i * self.font_size * 1.5 - self.y_offset,
            line, self.font_size,
            r, g, b, self.alpha
        )
    end
end

return InfoTopic