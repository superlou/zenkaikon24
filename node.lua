gl.setup(1920, 1080)
require "heading"
local Ticker = require "ticker"
local Clock = require "clock"
local offset = require "offset"
local json = require "json"

local font = resource.load_font "font_Lato-Regular.ttf"
local right_bg = resource.load_image "img_right_bg.png"
local right_bg_fold = resource.load_image "img_right_bg_fold.png"
local ticker_left_crop = resource.load_image "img_ticker_left_crop.png"
local ticker_right_crop = resource.load_image "img_ticker_right_crop.png"

local ticker = Ticker:new("config.json", 0, HEIGHT - 116, WIDTH, 116)
local clock = Clock:new(1710, 972, 200, 96)

util.data_mapper {
    ["clock/update"] = function(data)
        data = json.decode(data)
        clock:update(data.hh_mm, data.am_pm)
    end;
}

function node.render()
    gl.clear(1, 1, 1, 1)
    right_bg:draw(903, 0, 903 + 1017, 1080)

    draw_heading_light(font, 450, 100, "YOU ARE HERE")

    offset(1030, 0, function ()
        draw_heading_dark(font, 430, 100, "HAPPENING NOW")
    end)

    ticker:draw()

    right_bg_fold:draw(885, 1048, 885 + 1035, 1048 + 32)
    ticker_left_crop:draw(0, 964, 47, 964 + 116)
    ticker_right_crop:draw(1692, 964, 1692 + 228, 964 + 116)

    clock:draw()
end