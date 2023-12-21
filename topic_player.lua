local class = require "middleclass"

local TopicPlayer = class("TopicPlayer")
local InfoTopic = require "topic_info"

function TopicPlayer:initialize(w, h, style, bg)
    self.w, self.h = w, h
    self.style = style
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

    if self.active_topic == nil or self.active_topic:is_done() then
        -- Reset if the next_topic_id is out of bounds
        if self.next_topic_id > #self.topic_configs then
            self.next_topic_id = 1
        end

        self.active_topic = self:create_topic(self.topic_configs[self.next_topic_id])

        self.next_topic_id = self.next_topic_id + 1
    end

    self.active_topic:draw()
end

function TopicPlayer:create_topic(topic_config)
    -- For now, always make an InfoTopic
    return InfoTopic:new(self.w, self.h, self.style,
                         topic_config.duration,
                         topic_config.heading,
                         topic_config.message)
end

return TopicPlayer