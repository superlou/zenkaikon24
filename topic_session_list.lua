local class = require "middleclass"
local Topic = require "topic"
local tw = require "tween"

local SessionListTopic = class("SessionListTopic", Topic)

function SessionListTopic:initialize(w, h, style, duration, heading, text)
    Topic.initialize(self, w, h, style, duration)
    self.heading = heading
    self.text = text
    self.text_color = {hex2rgb(self.style.text.color)}
    self.font_size = 40

    self.heading = Heading(heading, style.heading)
    self.data_filename = text:match("")

    tw:timer(duration):on_done(function()
        self.heading:start_exit()
        self:set_done()
    end)
end

function SessionListTopic:draw()
    local r, g, b = unpack(self.text_color)

    offset(self.w / 2, self.style.heading_y, function()
        self.heading:draw()
    end)
end

return SessionListTopic