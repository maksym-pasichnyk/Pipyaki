import 'general/graphics/sprite'
import 'general/math/rect'
import 'game/tile/tile'

TileSprite = class(Tile)
function TileSprite:new(path, clip, rw, rh, x, y, dx, dy, layer)
    Tile.new(self, x, y, dx, dy, layer)

    self.sprite = Sprite.create(path)
    self.clip = self.sprite:clip(rect(clip * rw, 0, rw, rh))
    self.dx = 0
    self.dy = 0
end

function TileSprite:boundingRect()
    local r = self.clip.rect
    return rect(self.x - r.w * self.clip.pivot.x, self.y - r.h * self.clip.pivot.y, r.w, r.h)
end

function TileSprite:render()
    Sprite.render(self.clip, self.x + self.dx, self.y + self.dy)
end