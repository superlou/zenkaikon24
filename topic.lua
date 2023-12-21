local class = require "middleclass"

local Topic = class("Topic")

function Topic:initialize(w, h, style, duration)
    self.w, self.h = w, h
    self.style = style
    self.duration = duration
    self.done = false
end

function Topic:set_done()
    self.done = true
end

function Topic:is_done()
    return self.done
end

return Topic