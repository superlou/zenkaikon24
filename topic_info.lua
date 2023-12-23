local class = require "middleclass"
local Topic = require "topic"
local InfoTopic = class("InfoTopic", Topic)
require "text_util"
local tw = require "tween"
local Heading = require "heading"
local offset = require "offset"

function InfoTopic:initialize(w, h, style, duration, heading, text)
    Topic.initialize(self, w, h, style, duration)
    self.heading = heading
    self.text = text
    self.font_size = 40

    self.style = style
    self.margin = self.style.margin
    self.lines = wrap_text(self.text, self.style.text.font, self.font_size, self.w - self.margin * 2)
    self.alpha = 0
    self.y_offset = 0

    self.heading = Heading(heading, style.heading)

    tw:tween(self, "alpha", 0, 1, 0.5)
    tw:tween(self, "y_offset", 20, 0, 0.5)

    tw:tween(self, "alpha", 1, 0, 0.5):delay(duration):on_done(function()
        self:set_done()
    end)

    tw:timer(duration):on_done(function()
        self.heading:start_exit()
    end)
end

function InfoTopic:draw()
    local r, g, b = self.style.text.color[1], self.style.text.color[2], self.style.text.color[3]

    for i, line in ipairs(self.lines) do
        self.style.text.font:write(
            self.margin, i * self.font_size * 1.5 - self.y_offset + self.style.message_y,
            line, self.font_size,
            r, g, b, self.alpha
        )
    end

    offset(self.w / 2, self.style.heading_y, function()
        self.heading:draw()
    end)
end

return InfoTopic