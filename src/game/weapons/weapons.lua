import 'game/tile/tile'
import 'game/tile/tile-sprite'
import 'general/math/rect'
import 'general/graphics/sprite'
import 'game/inventory'

local random = love.math.random

TileWeapon = class(TileSprite)
function TileWeapon:new(scene, info, x, y)
    self.scene = scene
    self.time = scene.timer

    local clip = random(0, info.count - 1)
    TileSprite.new(self, info.sprite, clip, info.size.x, info.size.y, x, y, 0, 0, 0)

    if info.start then
        info.start(info, self)
    end
end

Melon = {
    sprite = 'weapons/melon.png',
    size = { x = 20, y = 20 },
    count = 6
}

MelonHard = {
    sprite = 'weapons/melon_hard.png',
    size = { x = 20, y = 20 },
    count = 6
}

Brick = class(TileSprite)

MelonThr = {
    sprite = 'weapons/melon_thr.png',
    size = { x = 20, y = 20 },
    count = 6
}

MelonThrHard = {
    sprite = 'weapons/melon_thr_hard.png',
    size = { x = 20, y = 20 }
}

Melon3 = class(TileSprite)
Melon3Hard = class(TileSprite)

Ananas = class(TileSprite)
AnanasHard = class(TileSprite)

Sock = class(TileSprite)

BananasSkin = class(TileSprite)

Grabli = class(TileSprite)

Bomb = class(TileSprite)

Mine = {
    sprite = 'weapons/mine.png',
    size = { x = 16, y = 14 },
    count = 1,
    start = function(self, tile)
    end
}

Bananas = class(TileSprite)

Helmet = class(TileSprite)

InvisibleHelmet = class(TileSprite)

Kaska = class(TileSprite)

Carrot = class(TileSprite)

Shield = class(TileSprite)