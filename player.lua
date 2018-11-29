module()

import 'class'
import 'entity'
import 'input'

local function Animation(idle, index, frames, speed)
    return { idle = idle, index = index, frames = frames, speed = speed }
end

Player = class(Entity)
function Player:new(tile_x, tile_y)
    Entity.new(self, 'chars/pipyaka.png', tile_x, tile_y, 32, 30, 30)

    self.anims = {
        down   = Animation(0, 12, 5, 10),
        left   = Animation(3, 17, 5, 10),
        up     = Animation(6, 22, 5, 10),
        right  = Animation(9, 27, 5, 10)
    }
end

function Player:update(dt)
    if Input:GetButton('left') then
        self:move('left')
    end
    
    if Input:GetButton('right') then
        self:move('right')
    end
    
    if Input:GetButton('up') then
        self:move('up')
    end
    
    if Input:GetButton('down') then
        self:move('down')
    end
end