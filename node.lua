gl.setup(1920, 1080)
require "heading"
local Ticker = require "ticker"
local offset = require "offset"

local font = resource.load_font "font_Lato-Regular.ttf"
local right_bg = resource.load_image "img_right_bg.png"

local ticker = Ticker:new("config.json", 0, HEIGHT - 116, WIDTH, 116)

function node.render()
    gl.clear(1, 1, 1, 1)
    right_bg:draw(903, 0, 903 + 1017, 1080)

    draw_heading_light(font, 450, 100, "YOU ARE HERE")

    offset(1030, 0, function ()
        draw_heading_dark(font, 430, 100, "HAPPENING NOW")
    end)

    ticker:draw()
end