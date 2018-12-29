import 'class'
import 'tile'
import 'rect'
import 'sprite'
import 'timer'
import 'rect'

import 'scene-manager'

Entity = class(Tile)
EntityState = {
    Idle = 0,
    Move = 1,
}

function Entity:new(path, tile_x, tile_y, clips, rw, rh, anims)
    Tile.new(self, 0, 0, 0, 0, 0)

    self.timer = getScene().timer

    self.sprite = Sprite:Load(path)
    self.anims = anims or {}

    self.tile_x = tile_x
    self.tile_y = tile_y

    self.x = tile_x * 30
    self.y = tile_y * 30

    self.target_x = 0
    self.target_y = 0
    self.time = 0
    self.clip = 1
    self.index = 0
    self.frames = 0
    self.speed = 0

    self.direction = 'down'

    self.state = EntityState.Idle

    for i = 0, clips - 1 do
        self.sprite:add(Rect(rw * i, 0, rw, rh))
    end
end

function Entity:render()
    Sprite.render(self.sprite:get(self.clip), self.x, self.y)
end

function Entity:boundingRect()
    return Rect(self.x - 16, self.y - 16, 32, 32)
end

function math.clamp(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    end

    return value
end

function Entity:move(direction)    
    if self.state == EntityState.Move then
        return
    end

    self.state = EntityState.Move

    local anim = self.anims[direction]
    if self.direction ~= direction then
        local clip = self.clip - 1
        local idle = anim.idle

        local frames = idle - clip

        if math.abs(frames) == 9 then
            frames = -frames / 3
        end

        local func
        if frames > 0 then
            func = math.ceil
        else
            func = math.floor
        end

        self.time = 0
        local duration = math.abs(frames) / 15
        self.timer:during(duration, function(dt)
            local c = func(clip + frames * math.min(self.time / duration, 1))
            self.clip = math.clamp(c - math.floor(c / 12) * 12, 0, 11) + 1
            self.time = self.time + dt
        end, function()
            self.clip = anim.idle + 1
            self.state = EntityState.Idle
        end)
    else
        local target
        if direction == 'left' then
            self.tile_x = self.tile_x - 1
            target = { x = self.x - 30 }            
        elseif direction == 'right' then
            self.tile_x = self.tile_x + 1
            target = { x = self.x + 30 }
        elseif direction == 'up' then
            self.tile_y = self.tile_y - 1
            target = { y = self.y - 30 }
        elseif direction == 'down' then
            self.tile_y = self.tile_y + 1
            target = { y = self.y + 30 }
        end

        local clip = anim.index
        local frames = anim.frames
        local speed = anim.speed

        local tween = self.timer:tween(0.6, self, target)        

        tween.step = function(dt)
            self.clip = clip + math.floor(self.time) % frames + 1
            self.time = self.time + speed * dt
        end

        tween.after = function()
            self.clip = anim.idle + 1
            self.state = EntityState.Idle
        end
    end

    self.direction = direction
end