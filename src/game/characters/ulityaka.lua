import 'game/entity/entity'

Ulityaka = class(Entity)
function Ulityaka:init()
    Entity.init(self, 'chars/ulityaka.png', 32, 40, 40)

    self.rotation_speed = 15
    self.movement_speed = 1

    self.anims = {
        down   = make_anim(0, 12, 4, 7),
        left   = make_anim(3, 16, 4, 7),
        up     = make_anim(6, 20, 4, 7),
        right  = make_anim(9, 24, 4, 7)
    }
end