import 'game/tile/tile'
import 'game/tile/tile-sprite'
import 'general/math/rect'
import 'general/graphics/sprite'
import 'game/inventory'

local random = love.math.random

TileWeapon = class(TileSprite)
function TileWeapon:new(level, data, x, y)
    TileSprite.new(self, data.sprite, data.clip or random(0, data.count - 1), data.size.x, data.size.y, x, y, 0, 0, 0)

    self.level = level
    self.timer = level.scene.timer
    self.data = data
end

function TileWeapon:placeEvent()
    local explosion = self.data.explosion

    if explosion then
        self.timer:after(explosion.delay, function()
            self.level:removeTile(self)
        end)
    end
end