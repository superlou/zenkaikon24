local class = require "middleclass"

local TopicPlayer = class("TopicPlayer")

function TopicPlayer:initialize(w, h, bg)
    self.w, self.h = w, h
    self.bg = bg
end

function TopicPlayer:draw()
    if self.bg then
        self.bg:draw(0, 0, self.w, self.h)
        print("test")
    end
end

return TopicPlayer