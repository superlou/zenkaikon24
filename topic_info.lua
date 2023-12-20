local class = require "middleclass"
local Topic = require "topic"
local InfoTopic = class("InfoTopic", Topic)

function InfoTopic:initialize(w, h)
    Topic.initialize(self, w, h)
end

return InfoTopic