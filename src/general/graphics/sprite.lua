import 'general/assets'
import 'general/math/vec2'
import 'general/math/vec4'

Sprite = class()
function Sprite:create(path)
    return Sprite(AssetManager:loadTexture(path))
end

function Sprite:new(texture)
    self.texture = texture
    self.clips = {}
end

function Sprite:add(rect, pivot, border)
    table.insert(self.clips, self:clip(rect, pivot, border))
end

function Sprite:clip(rect, pivot, border)
    return {
        texture = self.texture,
        rect = rect,
        pivot = pivot or vec2(0.5, 0.5),
        border = border or vec4(0, 0, 0, 0),
        quad = love.graphics.newQuad(rect.x, rect.y, rect.w, rect.h, self.texture:getDimensions())
    }
end

function Sprite:getWidth()
    return self.texture:getWidth()
end

function Sprite:getHeight()
    return self.texture:getHeight()
end

function Sprite:get(index)
    return self.clips[index]
end

function Sprite:clear()
    self.clips = {}
end

function Sprite:boundingRect()
    return self.rect
end

local love_graphics_draw = love.graphics.draw
function Sprite:render(x, y, w, h)
    local sx = (w or self.rect.w) / self.rect.w
    local sy = (h or self.rect.h) / self.rect.h

    love_graphics_draw(self.texture, self.quad, x - self.rect.w * self.pivot.x, y - self.rect.h * self.pivot.y, 0, sx, sy)
end