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

local font = resource.load_font "font_Lato-Regular.ttf"
local right_bg = resource.load_image "img_right_bg_wide3.png"
local ticker_left_crop = resource.load_image "img_ticker_left_crop.png"
local ticker_right_crop = resource.load_image "img_ticker_right_crop.png"

local ticker = Ticker:new(0, HEIGHT - 116, WIDTH, 116)
local clock = Clock:new(1710, 972, 200, 96)

local left_style = {
    heading = {
        style = "underline",
        font = font,
        font_size = 64,
        text_color = "333195",
        shadow_color = "333195",
        padding = 50,
    },
    text = {
        font = font,
        color = "333195",
    },
    margin = 70,
    heading_y = 100,
    message_y = 180,
}

local right_style = {
    heading = {
        style = "box",
        font = font,
        text_color = "ffffff",
        font_size = 64,
        padding = 50,
        bg_color = "e91e63",
        shadow_color = "bb114b",
    },
    text = {
        font = font,
        color = "ffffff",
    },
    margin = 80,
    heading_y = 100,
    message_y = 180,
}

local topic_left = TopicPlayer(640, 970, left_style)
local topic_right = TopicPlayer(1150, 970, right_style)

util.data_mapper {
    ["clock/update"] = function(data)
        data = json.decode(data)
        clock:update(data.hh_mm, data.am_pm)
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
end