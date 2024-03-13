require "color_util"
local class = require "middleclass"
local Topic = require "topic"
require "text_util"
local tw = require "tween"
local Heading = require "heading"
local offset = require "offset"

local InfoTopic = class("InfoTopic", Topic)

local mask_shader = resource.create_shader[[
    uniform sampler2D mask;
    uniform sampler2D Texture;
    uniform float alpha;
    varying vec2 TexCoord;

    void main() {
        vec4 img = texture2D(Texture, TexCoord).rgba;
        img.a = texture2D(mask, TexCoord).a * alpha;
        gl_FragColor = img;
    }
]]

function InfoTopic:initialize(w, h, style, duration, heading, text, media)
    Topic.initialize(self, w, h, style, duration)
    self.text = text
    self.text_color = {hex2rgb(self.style.text.color)}
    self.font_size = 40

    if media.filename ~= "img_no_media.png" then
        self.background = resource.load_image(media.asset_name)
    end

    if style.player_bg_mask then
        self.mask = resource.load_image(style.player_bg_mask)
    else
        self.mask = nil
    end    

    self.style = style
    self.margin = self.style.margin
    self.content_w = self.w - self.margin[2] - self.margin[4]
    self.lines = wrap_text(self.text, self.style.text.font, self.font_size, self.content_w)
    self.alpha = 0
    self.y_offset = 0

    self.heading = Heading(heading, style.heading)

    tw:tween(self, "alpha", 0, 1, 0.5)
    tw:tween(self, "y_offset", 20, 0, 0.5)

    tw:tween(self, "alpha", 1, 0, 0.5):delay(duration):on_done(function()
        self:set_done()
    end)

    tw:timer(duration):on_done(function()
        self.heading:start_exit()
    end)
end

function InfoTopic:draw()
    local r, g, b = unpack(self.text_color)

    if self.background then
        if self.mask then
            mask_shader:use {mask = self.mask, alpha = self.alpha}
        end
        self.background:draw(0, 0, self.w, self.h, self.alpha)
        if self.mask then
            mask_shader:deactivate()
        end
    end

    offset(self.w / 2, self.style.heading_y, function()
        self.heading:draw()
    end)

    for i, line in ipairs(self.lines) do
        self.style.text.font:write(
            self.margin[4], i * self.font_size * 1.5 - self.y_offset + self.style.message_y,
            line, self.font_size,
            r, g, b, self.alpha
        )
    end
end

return InfoTopic