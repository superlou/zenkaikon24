local class = require "middleclass"

local TopicPlayer = class("TopicPlayer")
local InfoTopic = require "topic_info"

function TopicPlayer:initialize(w, h, bg)
    self.w, self.h = w, h
    self.bg = bg

    self.topic_configs = {}
    self.active_topic = nil
    self.next_topic_id = 1
end

function TopicPlayer:set_topics_from_config(config)
    self.topic_configs = config
end

function TopicPlayer:draw()
    if self.bg then self.bg:draw(0, 0, self.w, self.h) end

    if self.active_topic == nil then
        self.active_topic = self:create_topic(self.topic_configs[self.next_topic_id])
    end
end

function TopicPlayer:create_topic(topic_config)
    -- For now, always make an InfoTopic
    return InfoTopic:new(self.w, self.h)
end

return TopicPlayer