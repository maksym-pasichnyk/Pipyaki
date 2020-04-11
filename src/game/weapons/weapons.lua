import 'game/tile/tile'
import 'game/tile/tile-sprite'
import 'general/math/rect'
import 'general/graphics/sprite'
import 'game/inventory'
import 'general/math/vec2'

local random = love.math.random

local function Clip(item, data)
    return item.clip or random(0, data.count - 1)
end

TileWeapon = class(TileSprite)
function TileWeapon:new(item, x, y)
    local data = item.sprite_data

    TileSprite.new(self, data.texture, Clip(item, data), data.w, data.h, x, y, 0, 0, 1)

    self.item = item
end

function TileWeapon:onCreate(level)
    self:destroy()
end

function TileWeapon:destroy()
    local explosion = self.item.explosion

    if explosion then
        local function start()
            self:explosionEvent(explosion.sprite_data)

            local parts = explosion.parts
            if parts then

            end

            local decal = explosion.decal
            if decal then
                local data = decal.sprite_data
                local tile = TileSprite(data.texture, Clip(decal, data), data.w, data.h, self.x, self.y, 0, 0, 0)

                self.level:addTile('bottom', tile)
    
                -- self.timer:after(decal.time, function()
                    -- self.level:removeTile(tile)
                -- end)
            end
        end

        self.timer:after(self.item.delay or 0, start)
    else
        self.timer:after(self.item.delay or 0, function()
            self.level:removeTile(self)
        end)
    end
end

function TileWeapon:explosionEvent(data)
    local clips = data.count
    local frames = clips - 1

    local sprite = Sprite.create(data.texture)
    for i = 0, frames do
        sprite:add(rect(data.w * i, 0, data.w, data.h))
    end

    self.sprite = sprite

    local time = 0
    local duration = clips / 30
    self.timer:during(duration, function(dt)
        local i = math.ceil(frames * math.min(time / duration, 1)) + 1
        self.clip = sprite.clips[i]
        time = time + dt
    end, function()
        self.level:removeTile(self)
    end)
end

Throwable = class(TileWeapon)

local throw_axis = {
    left  = vec2(-1,  0),
    right = vec2( 1,  0),
    up    = vec2( 0, -1),
    down  = vec2( 0,  1)
}

local ThrowableState = enum {
    'Move',
    'Static'
}

function Throwable:new(item, x, y, direction)
    TileWeapon.new(self, item, x, y)

    self.axis = throw_axis[direction]
    self.power = 300
    self.collision = item.collision or 'default'
end

function Throwable:onCreate(level)
    self.state = ThrowableState.Move
    local collision = self.collision

    local start = vec2(self.x, self.y)
    local target = start + self.axis * 300

    local tween = self.timer:tween(0.6, start, target)
    if collision == 'inside' then
        local inside = false
        local target_x = 0
        local target_y = 0
        tween.step = function(dt)
            local tile_x = start.x / 30
            if self.axis.x < 0 then
                tile_x = math.floor(tile_x)
            elseif self.axis.x > 0 then
                tile_x = math.ceil(tile_x)
            end

            local tile_y = start.y / 30
            if self.axis.y < 0 then
                tile_y = math.floor(tile_y)
            elseif self.axis.y > 0 then
                tile_y = math.ceil(tile_y)
            end

            if inside then
                if tile_x == target_x and tile_y == target_y then
                    self.tile_x = tile_x
                    self.tile_y = tile_y
                    self.x = tile_x * 30
                    self.y = tile_y * 30
                    self.timer:cancel(tween)
    
                    self:destroy()
                end
            else
                inside = not self.level:canWalk(tile_x, tile_y)
                if inside then
                    target_x = tile_x
                    target_y = tile_y
                end
                self.tile_x = tile_x
                self.tile_y = tile_y
                self.x = start.x
                self.y = start.y
            end
        end
    else
        tween.step = function(dt)
            local tile_x = start.x / 30
            if self.axis.x < 0 then
                tile_x = math.floor(tile_x)
            elseif self.axis.x > 0 then
                tile_x = math.ceil(tile_x)
            end

            local tile_y = start.y / 30
            if self.axis.y < 0 then
                tile_y = math.floor(tile_y)
            elseif self.axis.y > 0 then
                tile_y = math.ceil(tile_y)
            end

            if self.level:canWalk(tile_x, tile_y) then
                self.tile_x = tile_x
                self.tile_y = tile_y
                self.x = start.x
                self.y = start.y
            else
                self.x = self.tile_x * 30
                self.y = self.tile_y * 30
                self.timer:cancel(tween)

                self:destroy()
            end
        end
    end

    tween.after = function()
        self:destroy()
    end
    -- level.updates:add(self)
end

function Throwable:onRemove(level)
    -- level.updates:remove(self)
end