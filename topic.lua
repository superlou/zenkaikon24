local class = require "middleclass"

local Topic = class("Topic")

function Topic:initialize(w, h)
    self.w, self.h = w, h
end

return Topic