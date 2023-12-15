gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)
local Ticker = require "ticker"
local draw_heading = require "heading"

local font = resource.load_font "font_Lato-Regular.ttf"

local ticker = Ticker:new("data_ticker.json", 0, 800, WIDTH, 100)

function node.render()
    gl.clear(0, 0, 0, 1)
    font:write(250, 300, "Zenkaikon 2024", 64, 1, 1, 1, 1)
    draw_heading(1000, 300, "HAPPENING NOW", font, false)
    ticker:draw()
end