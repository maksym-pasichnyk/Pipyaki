import 'game/tile/tile'
import 'game/tile/tile-sprite'
import 'general/math/rect'
import 'general/graphics/sprite'
import 'game/inventory'

local random = love.math.random

TileWeapon = class(TileSprite)
function TileWeapon:new(data, x, y)
    TileSprite.new(self, data.sprite, data.clip or random(0, data.count - 1), data.size.x, data.size.y, x, y, 0, 0, 0)

    self.data = data
end

function TileWeapon:placeEvent()
    local data = self.data.explosion

    if data then
        local clips = data.count
        local frames = clips - 1

        local sprite = Sprite:create(data.sprite)
        for i = 0, frames do
            sprite:add(rect(data.w * i, 0, data.w, data.h))
        end

        self.timer:after(data.delay, function()
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
        end)
    end
end