import 'game/entity/entity'

Cannon = class(Entity)
function Cannon:init()
    Entity.init(self, 'chars/cannon.png', 12, 54, 54)

    self.rotation_speed = 10
    self.movement_speed = 2

    self.anims = {
        down   = make_anim(0, 0, 1, 0),
        left   = make_anim(3, 3, 1, 0),
        up     = make_anim(6, 6, 1, 0),
        right  = make_anim(9, 9, 1, 0)
    }
end