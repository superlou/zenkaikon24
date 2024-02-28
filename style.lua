local font = resource.load_font "font_Lato-Regular.ttf"
local font_bold = resource.load_font "font_Lato-Bold.ttf"

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
        font_bold = font_bold,
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
        font_bold = font_bold,
        color = "ffffff",
    },
    margin = 80,
    heading_y = 100,
    message_y = 180,
}

return {
    left_style = left_style,
    right_style = right_style,
}