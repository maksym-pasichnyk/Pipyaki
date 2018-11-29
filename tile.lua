module()

import 'class'

Tile = class()
function Tile:new(x, y, dx, dy, layer)
    self.tile_x = math.floor(x / 30)
    self.tile_y = math.floor(y / 30)
    self.x = x + dx
    self.y = y + dy
    self.layer = layer or 0
end