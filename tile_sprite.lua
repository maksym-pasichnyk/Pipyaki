module()

import 'class'
import 'sprite'
import 'rect'
import 'tile'

TileSprite = class(Tile)
function TileSprite:new(path, clip, rw, rh, x, y, dx, dy, layer)
    Tile.new(self, x, y, dx, dy, layer)

    self.sprite = Sprite:Load(path)
    self.clip = self.sprite:add(Rect(clip * rw, 0, rw, rh))
end

function TileSprite:draw()
    Sprite.draw(self.clip, self.x, self.y)
end