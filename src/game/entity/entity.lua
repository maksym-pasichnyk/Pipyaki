import 'game/tile/tile'
import 'general/math/rect'
import 'general/graphics/sprite'
import 'general/scene/scene-manager'

function make_anim(idle, index, frames, speed)
    return { idle = idle, index = index, frames = frames, speed = speed }
end

Entity = class(Tile)
EntityState = enum {
    'Idle',
    'Move',
}

function Entity:new(path, tile_x, tile_y, clips, rw, rh, anims)
    Tile.new(self, 0, 0, 0, 0, 2)

    self.sprite = Sprite.create(path)
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
        self.sprite:add(rect(rw * i, 0, rw, rh))
    end
end

function Entity:render()
    Sprite.render(self.sprite:get(self.clip), self.x, self.y)
end

function Entity:boundingRect()
    return rect(self.x - 16, self.y - 16, 32, 32)
end

function math.clamp(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    end

    return value
end

function Entity:is_local()
    -- todo: network
    return true
end

function Entity:move(direction, walk)
    if self.direction ~= direction then
        self.direction = direction
        
        local anim = self.anims[direction]
        self.state = EntityState.Move

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
        local duration = math.abs(frames) / 60
        self.timer:during(duration, function(dt)
            local c = func(clip + frames * math.min(self.time / duration, 1))
            self.clip = math.clamp(c - math.floor(c / 12) * 12, 0, 11) + 1
            self.time = self.time + dt
        end, function()
            self.clip = anim.idle + 1
            self.state = EntityState.Idle
        end)
    elseif walk then
        local anim = self.anims[direction]
        self.state = EntityState.Move

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
end

function Entity:execute(tile)
    -- if self.state == EntityState.Move then
    --     return
    -- end

    self.isExecuting = true

    self.timer:clear()

    self.x = self.tile_x * 30
    self.y = self.tile_y * 30

    self.state = EntityState.Move
    if tile:is(TileTrampoline) then
        -- if tile.distance == 0 then
        --     return
        -- end

        self.clip = self.anims[tile.direction].idle + 1
        local offset = tile.offset
        local time = tile.distance / 15

        self.isExecuting = true

        self.state = EntityState.Move
        local tween = self.timer:tween(time, self, {
            x = self.x + offset.x * 30,
            y = self.y + offset.y * 30
        })

        self.tile_x = self.tile_x + offset.x
        self.tile_y = self.tile_y + offset.y

        tween.after = function()
            self.isExecuting = false
            self.state = EntityState.Idle
        end
    end
end

function Entity:try_execute(tile)
    if not self.isExecuting then
        self:execute(tile)
    end
end

function Entity:try_move(direction)
    if self.state == EntityState.Move then
        return false
    end
    self:move(direction)
    return true
end

function Entity:isIdle()
    return self.state == EntityState.Idle
end

function Entity:tile()
    return self.tile_x, self.tile_y
end