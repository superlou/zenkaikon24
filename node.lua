gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local font = resoure.load_font "fonts/Lato-Regular.ttf"

function node.render()
    font:write(250, 300, "Hello, World", 64, 1, 1, 1, 1)
end