local class = require "middleclass"
local Topic = require "topic"
local tw = require "tween"
local json = require "json"
local list = require "list_util"

local SessionListTopic = class("SessionListTopic", Topic)
local SessionListItem = class("SessionListItem")

function SessionListTopic:initialize(w, h, style, duration, heading, text)
    Topic.initialize(self, w, h, style, duration)
    self.heading = heading
    self.text = text
    self.text_color = {hex2rgb(self.style.text.color)}
    self.font_size = 40

    self.heading = Heading(heading, style.heading)
    
    data_filename = text:match("data:([%w_.]+)")
    local session_data_text = resource.load_file(data_filename)
    self.sessions_data = json.decode(session_data_text)

    self.sessions_per_page = 5  -- todo This should be based on height and session size
    self.sessions_by_page = list.split_every_n(self.sessions_data.sessions, self.sessions_per_page)
    self.session_items = {}     -- the session drawing objects

    if #self.sessions_by_page == 0 then
        -- If nothing to show, wait for 1 page duration
        tw:timer(duration):on_done(function()
            self.heading:start_exit()
            tw:timer(0.5):on_done(function() self:set_done() end)
        end)
    else
        self:load_page()
    end
end

function SessionListTopic:load_page()
    local sessions = table.remove(self.sessions_by_page, 1)
    self.session_items = {}

    for i, session in ipairs(sessions) do
        local item = SessionListItem:new(
            session.name, session.location, session.start_hhmm, session.start_ampm,
            self.w, 200,
            self.duration,
            (i - 1) * 0.1,
            self.style
        )

        table.insert(self.session_items, item)
    end

    if #self.sessions_by_page > 0 then
        -- Need to exit the current page's sessions and load next ones
        tw:timer(self.duration + 0.5):on_done(function()
            self:load_page()
        end)
    else
        -- No more session pages to show
        tw:timer(self.duration):on_done(function()
            self.heading:start_exit()
        end)

        tw:timer(self.duration + 0.5):on_done(function()
            self:set_done()        
        end)
    end
end

function SessionListTopic:draw()
    local r, g, b = unpack(self.text_color)

    offset(self.w / 2, self.style.heading_y, function()
        self.heading:draw()
    end)

    for i, session_item in ipairs(self.session_items) do
        offset(0, self.style.message_y + (i - 1) * 140 + 60, function()
            session_item:draw()
        end)
    end
end

function SessionListItem:initialize(name, location, start_hhmm, start_ampm, w, h, duration, enter_delay, style)
    self.name = name
    self.location = location
    self.start_hhmm = start_hhmm
    self.start_ampm = start_ampm
    self.w, self.h = w, h
    self.duration = duration
    self.style = style

    self.text_color = {hex2rgb(self.style.text.color)}
    self.font_size = 50
    self.font = self.style.text.font

    -- Calculations to right align
    self.date_w = 120
    self.start_hhmm_x = self.date_w - self.font:width(self.start_hhmm, self.font_size)
    self.start_ampm_x = self.date_w - self.font:width(self.start_ampm, self.font_size * 0.8)

    self.alpha = 0

    tw:tween(self, "alpha", 0, 1, 0.5):delay(enter_delay)
    tw:timer(self.duration):on_done(function()
        tw:tween(self, "alpha", 1, 0, 0.5)
    end)
end

function SessionListItem:draw()
    local r, g, b = unpack(self.text_color)

    self.font:write(
        self.start_hhmm_x, 0, self.start_hhmm, self.font_size,
        r, g, b, self.alpha
    )

    self.font:write(
        self.start_ampm_x, 60, self.start_ampm, self.font_size * 0.8,
        r, g, b, self.alpha
    )    

    self.font:write(
        self.date_w + 30, 0, self.name, self.font_size,
        r, g, b, self.alpha
    )

    self.font:write(
        self.date_w + 30, 60, self.location, self.font_size * 0.8,
        r, g, b, self.alpha
    )
end

return SessionListTopic