import 'class'
import 'sprite'
import 'resources'

local function make_part(x, y, l, r, t, b, sx, sy, w, h)
    return {
        x = x,
        y = y,
        sx = sx,
        sy = sy,
        quad = love.graphics.newQuad(l, t, r - l, b - t, w, h)
    }
end

Ninepath = class()
function Ninepath:new(path, l, r, t, b, w, h)
    local texture = Resources:LoadTexture(path)
    local tw, th = texture:getDimensions()

    local dw = w - tw
    local dh = h - th

    local sx = 1 + dw / (r - l)
    local sy = 1 + dh / (b - t)

    local x = r + dw
    local y = b + dh

    self.texture = texture
    self.parts = {
        make_part(0, 0, 0,  l, 0,  t,  1,  1, tw, th),
        make_part(l, 0, l,  r, 0,  t, sx,  1, tw, th),
        make_part(x, 0, r, tw, 0,  t,  1,  1, tw, th),
        make_part(0, t, 0,  l, t,  b,  1, sy, tw, th),
        make_part(l, t, l,  r, t,  b, sx, sy, tw, th),
        make_part(x, t, r, tw, t,  b,  1, sy, tw, th),
        make_part(0, y, 0,  l, b, th,  1,  1, tw, th),
        make_part(l, y, l,  r, b, th, sx,  1, tw, th),
        make_part(x, y, r, tw, b, th,  1,  1, tw, th)
    }
end

function Ninepath:render()
    for k, part in pairs(self.parts) do
        love.graphics.draw(self.texture, part.quad, part.x, part.y, 0, part.sx, part.sy)
    end
end