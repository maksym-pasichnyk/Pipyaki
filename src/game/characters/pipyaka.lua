import 'game/entity/entity'
import 'game/inventory'
import 'game/weapons/weapons'

Pipyaka = class(Entity)
function Pipyaka:init()
    Entity.init(self, 'chars/pipyaka.png', 32, 30, 30)

    self.rotation_speed = 20
    self.movement_speed = 2

    self.anims = {
        down   = make_anim(0, 12, 5, 10),
        left   = make_anim(3, 17, 5, 10),
        up     = make_anim(6, 22, 5, 10),
        right  = make_anim(9, 27, 5, 10)
    }
end