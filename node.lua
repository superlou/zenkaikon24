gl.setup(1920, 1080)
local Heading = require "heading"
require "color_util"
require "json_util"
require "glass"
local Ticker = require "ticker"
local Clock = require "clock"
local offset = require "offset"
local json = require "json"
local TopicPlayer = require "topic_player"
local tw = require "tween"
local ServiceIndicator = require "service_indicator"

local right_bg = resource.load_image "img_right_bg_wide3.png"
local ticker_left_crop = resource.load_image "img_ticker_left_crop.png"
local ticker_right_crop = resource.load_image "img_ticker_right_crop.png"

local ticker = Ticker:new(0, HEIGHT - 116, WIDTH, 116)
local clock = Clock:new(1710, 972, 200, 96)
local service_indicator = ServiceIndicator()

local style = require "style"
local left_style = style["left_style"]
local right_style = style["right_style"]

local topic_left = TopicPlayer(694, 964, left_style)
local topic_right = TopicPlayer(1150, 970, right_style)

util.data_mapper {
    ["clock/update"] = function(data)
        data = json.decode(data)
        clock:update(data.hh_mm, data.am_pm)
    end;
    ["guidebook/update"] = function(data)
        data = json.decode(data)
        service_indicator:update(data.updating, data.checks, data.desc)
    end;
}

json_watch("config.json", function(config)
    ticker:set_speed(config.ticker_speed)
    ticker:set_msgs_from_config(config)
    topic_left:set_topics_from_config(config["left_topic_player"])
    topic_right:set_topics_from_config(config["right_topic_player"])
end)

function node.render()
    tw:update(1 / 60)

    gl.clear(1, 1, 1, 1)

    offset(0, 0, function()
        topic_left:draw()
    end)

    right_bg:draw(575, 0, 575 + 1345, 1080)
    draw_glass()

    offset(680, 0, function()
        topic_right:draw()
    end)

    ticker:draw()

    ticker_left_crop:draw(0, 964, 47, 964 + 116)
    ticker_right_crop:draw(1692, 964, 1692 + 228, 964 + 116)

    clock:draw()

    offset(10, 978, function()
        service_indicator:draw()
    end)
end