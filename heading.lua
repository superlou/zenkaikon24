-- local heading_bg = resource.create_colored_texture()

function draw_heading(x, y, text, font, style)
    font:write(x, y, text, 64, 1, 1, 1, 1)
end

return draw_heading