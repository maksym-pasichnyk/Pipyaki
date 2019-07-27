import 'general/ui/graphics-item'
import 'general/scene/scene-manager'

Tile = class(GraphicsItem)
function Tile:new(x, y, dx, dy, layer)
    GraphicsItem.new(self, nil)
    
    self.scene = getScene()
    self.level = self.scene.level
    self.timer = self.scene.timer
    self.camera = self.scene.camera
    self.tile_x = math.floor(x / 30)
    self.tile_y = math.floor(y / 30)
    self.x = x + dx
    self.y = y + dy
    self.layer = layer or 0
end