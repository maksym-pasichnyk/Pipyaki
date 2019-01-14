import 'general/scene/scene-manager'
import 'game/entity/entity'
import 'general/input'

Bombaka = class(Entity)
function Bombaka:new(tile_x, tile_y)
    Entity.new(self, 'chars/pipyaka.png', tile_x, tile_y, 32, 30, 30)

    self.anims = {
        down   = make_anim(0, 12, 5, 10),
        left   = make_anim(3, 17, 5, 10),
        up     = make_anim(6, 22, 5, 10),
        right  = make_anim(9, 27, 5, 10)
    }
end