gl.setup(1920, 1080)
local Heading = require "heading"
require "color_util"
require "json_util"
local Ticker = require "ticker"
local Clock = require "clock"
local offset = require "offset"
local json = require "json"
local TopicPlayer = require "topic_player"
local tw = require "tween"

local font = resource.load_font "font_Lato-Regular.ttf"
local right_bg = resource.load_image "img_right_bg_wide2.png"
local ticker_left_crop = resource.load_image "img_ticker_left_crop.png"
local ticker_right_crop = resource.load_image "img_ticker_right_crop.png"

local glass1 = resource.load_image "img_glass1.png"
local glass2 = resource.load_image "img_glass2.png"
local glass3 = resource.load_image "img_glass3.png"
local glass4 = resource.load_image "img_glass4.png"

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

local t = 0

function draw_glass()
    local x, y = 1150, 280
    glass1:draw(x, y, x + 123, y + 178, 0.2 * math.sin(2 * 3.1415 * 0.1 * t + 7) + 0.2)
    local x, y = 1345, 210
    glass2:draw(x, y, x + 100, y + 170, 0.2 * math.sin(2 * 3.1415 * 0.15 * t + 3.5) + 0.2)
    local x, y = 1175, 40
    glass3:draw(x, y, x + 160, y + 224, 0.5 * math.sin(2 * 3.1415 * 0.17 * t + 2) + 0.5)
    local x, y = 1290, 315
    glass4:draw(x, y, x + 52, y + 120, 0.3 * math.sin(2 * 3.1415 * 0.08 * t + 4.1) + 0.3)
    t = t + 1 / 60
end

function node.render()
    tw:update(1 / 60)

    gl.clear(1, 1, 1, 1)
    right_bg:draw(521, 0, 521 + 1399, 1080)
    draw_glass()

    offset(0, 0, function()
        topic_left:draw()
    end)

    offset(680, 0, function()
        topic_right:draw()
    end)

    ticker:draw()

    ticker_left_crop:draw(0, 964, 47, 964 + 116)
    ticker_right_crop:draw(1692, 964, 1692 + 228, 964 + 116)

    clock:draw()
end