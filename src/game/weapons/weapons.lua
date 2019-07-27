import 'game/tile/tile'
import 'game/tile/tile-sprite'
import 'general/math/rect'
import 'general/graphics/sprite'
import 'game/inventory'

local random = love.math.random

local function Clip(item, data)
    return item.clip or random(0, data.count - 1)
end

TileWeapon = class(TileSprite)
function TileWeapon:new(item, x, y)
    local data = item.sprite

    TileSprite.new(self, data.texture, Clip(item, data), data.w, data.h, x, y, 0, 0, 0)

    self.item = item
end

function TileWeapon:placeEvent()
    local delayed = self.item.delayed

    if delayed then
        self.timer:after(delayed.time, function()
            self:delayedEvent(delayed.sprite)

            local trace = delayed.trace

            if trace then
                local data = trace.sprite
                local tile = TileSprite(data.texture, Clip(trace, data), data.w, data.h, self.x, self.y, 0, 0, 0)

                self.level:addTile('middle', tile)
    
                self.timer:after(trace.time, function()
                    self.level:removeTile(tile)
                end)
            end
        end)
    end

    
end

function TileWeapon:delayedEvent(data)
    local clips = data.count
    local frames = clips - 1

    local sprite = Sprite:create(data.texture)
    for i = 0, frames do
        sprite:add(rect(data.w * i, 0, data.w, data.h))
    end

    self.sprite = sprite

    local time = 0
    local duration = clips / 60
    self.timer:during(duration, function(dt)
        local i = math.ceil(frames * math.min(time / duration, 1)) + 1
        self.clip = sprite.clips[i]
        time = time + dt
    end, function()
        self.level:removeTile(self)
    end)
end