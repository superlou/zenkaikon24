gl.setup(1920, 1080)
require "heading"
require "color_util"
require "json_util"
local Ticker = require "ticker"
local Clock = require "clock"
local offset = require "offset"
local json = require "json"
local TopicPlayer = require "topic_player"

local font = resource.load_font "font_Lato-Regular.ttf"
local right_bg = resource.load_image "img_right_bg.png"
local right_bg_fold = resource.load_image "img_right_bg_fold.png"
local ticker_left_crop = resource.load_image "img_ticker_left_crop.png"
local ticker_right_crop = resource.load_image "img_ticker_right_crop.png"

local ticker = Ticker:new(0, HEIGHT - 116, WIDTH, 116)
local clock = Clock:new(1710, 972, 200, 96)

local topic_left = TopicPlayer(800, 750)

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
end)

function node.render()
    gl.clear(1, 1, 1, 1)
    right_bg:draw(903, 0, 903 + 1017, 1080)

    offset(80, 200, function()
        topic_left:draw()
    end)

    draw_heading_light(font, 475, 100, "YOU ARE HERE")

    offset(1030, 0, function()
        draw_heading_dark(font, 430, 100, "HAPPENING NOW")
    end)

    ticker:draw()

    right_bg_fold:draw(885, 1048, 885 + 1035, 1048 + 32)
    ticker_left_crop:draw(0, 964, 47, 964 + 116)
    ticker_right_crop:draw(1692, 964, 1692 + 228, 964 + 116)

    clock:draw()
end