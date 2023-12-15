local json = require "json"
local class = require "middleclass"

local Ticker = class("Ticker")

local separator_img = resource.load_image("img_separator.png")

function Ticker:initialize()
end

function Ticker:initialize(data_filename, x, y, w, h)
    self.x, self.y = x, y
    self.w, self.h = w, h
    self.active = false
    self.bg = resource.create_colored_texture(1, 1, 1, 0.8)
    self.ticker_msgs = {}
    self.next_msg_id = 1

    self.viewing_area_end = self.x + self.w

    util.file_watch(data_filename, function(content)
        local data = json.decode(content)
        self.speed = data.speed
        self.font = resource.load_font(data.font)
        self.active = data.active
        self.messages = data.messages
    end)
end

function Ticker:draw()
end

return Ticker