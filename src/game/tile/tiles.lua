import 'game/tile/tile-sprite'
import 'general/graphics/screen'

local function sprite(texture, w, h, count)
    return { texture = texture, w = w, h = h, count = count }
end

TileGrass = class(TileSprite)
function TileGrass:new(type, x, y)
    TileSprite.new(self, 'ground_grass.png', type, 30, 30, x * 30, y * 30, 0, 0, 0)
end

TileTrail = class(TileSprite)
function TileTrail:new(type, x, y)
    TileSprite.new(self, 'trails.png', type, 30, 30, x * 30, y * 30, 0, 0, 1)
end

TileWall = class(TileSprite)
function TileWall:new(x, y, properties)
    TileSprite.new(self, 'walls.png', properties[1], 45, 55, x * 30, y * 30, 0, 0)
end

TileWoodWall = class(TileSprite)
function TileWoodWall:new(x, y, properties)
    TileSprite.new(self, 'wood_walls.png', properties[1], 55, 55, x * 30, y * 30, 0, 0)
end

TileGates = class(TileSprite)
function TileGates:new(x, y, properties)
    TileSprite.new(self, 'gates.png', properties[1], 110, 80, x * 30, y * 30, 30, -10)
end

TileTreeStubs = class(TileSprite)
function TileTreeStubs:new(x, y, properties)
    TileSprite.new(self, 'tree_stubs.png', properties[1], 50, 60, x * 30, y * 30, 0, -15)
end

TileTreeCrown = class(TileSprite)
function TileTreeCrown:new(x, y, properties)
    TileSprite.new(self, 'tree_crowns.png', properties[2] - 1, 105, 92, x * 30, y * 30, 0, -50, 1)

    self.level.updates:add(self)
end

function TileTreeCrown:onRemove()
    self.level.updates:remove(self)
end

function TileTreeCrown:updateEvent(dt)
    local hw = Screen.width * 0.5
    local hh = Screen.height * 0.5

    local c = self.camera

    local cx = -c.x + hw
    local cy = -c.y + hw

    local ox = math.max(-10, math.min((cx - self.x) / 20, 10))
    local oy = math.max(-10, math.min((cy - self.y) / 40, 10))

    self.dx = -ox
    self.dy = -oy

    -- local dx = -self.dx - ox
    -- local dy = -self.dy - oy

    -- self.dx = self.dx + dx * dt * 10
    -- self.dy = self.dy + dy * dt * 10
end

TileTreeShadow = class(TileSprite)
function TileTreeShadow:new(x, y)
    TileSprite.new(self, 'tree_shadow.png', 0, 150, 105, x * 30, y * 30, 0, 0, 2)
end

TileHouseBottom = class(TileSprite)
function TileHouseBottom:new(x, y)
    TileSprite.new(self, 'house_bottom.png', 0, 150, 150, x * 30, y * 30, 30, 30)
end

TileHouseTop = class(TileSprite)
function TileHouseTop:new(x, y)
    TileSprite.new(self, 'house_top.png', 0, 150, 150, x * 30, y * 30, 30, 30)
end

TileWell = class(TileSprite)
function TileWell:new(x, y, properties)
    TileSprite.new(self, 'well.png', 0, 81, 65, x * 30, y * 30, 0, 0)
end

TileTent = class(TileSprite)
function TileTent:new(x, y, properties)
    -- TileSprite.new(self, 'well.png', 0, 81, 65, x * 30, y * 30, 0, 0)
end

TileChest = class(TileSprite)
function TileChest:new(x, y, properties)
    -- TileSprite.new(self, 'well.png', 0, 81, 65, x * 30, y * 30, 0, 0)
end

TileUnknown = class(TileSprite)
function TileUnknown:new(x, y)
    TileSprite.new(self, 'menu/signs.png', 0, 18, 18, x * 30, y * 30, 0, 0)
end

TileStones20 = class(TileSprite)
function TileStones20:new(x, y, type)
    TileSprite.new(self, 'stones_20.png', type, 20, 20, x, y, -15, -15, 3)
end

TileStones30 = class(TileSprite)
function TileStones30:new(x, y, type)
    TileSprite.new(self, 'stones_30.png', type, 30, 30, x, y, -15, -15, 3)
end

TileBushesBig = class(TileSprite)
function TileBushesBig:new(x, y, type)
    TileSprite.new(self, 'bushes_big.png', type, 55, 55, x, y, -15, -15)
end

TileBushesBananas = class(TileSprite)
function TileBushesBananas:new(x, y, type)
    TileSprite.new(self, 'bushes_bananas.png', type, 60, 60, x, y, -15, -15)
end

TileTelegaBricks = class(TileSprite)
function TileTelegaBricks:new(x, y, type)
    TileSprite.new(self, 'telega_bricks.png', type, 50, 50, x, y, -15, -15)
end

TileRidge = class(TileSprite)
function TileRidge:new(x, y, type)
    TileSprite.new(self, 'ridge.png', type, 70, 70, x, y, -15, -15)
end

TileCactusesSmall = class(TileSprite)
function TileCactusesSmall:new(x, y, type)
    TileSprite.new(self, 'cactuses_small.png', type, 25, 25, x, y, -15, -15)
end

TileSpawnPoint = class(TileSprite)
SpawnRace = enum {
    'Pipyaka',
    'Bombaka',
    'Slonyaka',
    'Ulityaka',
    'Cannon',
    'Kamikaze',
    'Rocketman',
    'Miner',
    'Digger',
    'Spider'
}

SpawnBehaviour = enum {
    'Default',
    'Blind_N_Deaf',
    'Camper',
    'ProtectRadius_3',
    'ProtectRadius_1'
}

SpawnTeam = enum {
    'SinglePlayer',
    'Neutral',
    'Team_0',
    'Team_1'
}

function TileSpawnPoint:new(x, y, properties)
    TileSprite.new(self, 'icon.png', 0, 16, 16, x * 30, y * 30, 0, 0)

    self.tile_x = x
    self.tile_y = y
    self.race = properties[1]
    self.total_count = properties[2]
    self.max_alives = properties[3]
    self.spawn_period = properties[4]
    self.behaviour = properties[5]
    self.team = properties[6]
    self.inactive = properties[7] ~= 0
    self.skill_level = properties[8]
    self.can_kill = properties[9] == 0
    self.can_prosecue = properties[10] == 0
    self.fast_spawn = properties[11] ~= 0
end

function TileSpawnPoint:equals(race)
    return self.race == race
end

TileStaticWeapon = class(TileSprite)
StaticWeaponType = enum {
    'Rake',
    'Bananas_Skin',
    'RabberMelon_Down',
    'RabberMelon_Left',
    'RabberMelon_Up',
    'RabberMelon_Right'
}

function TileStaticWeapon:new(x, y, properties)
    TileSprite.new(self, 'weapons/bomb.png', 0, 30, 30, x * 30, y * 30, 0, 0)

    self.type = properties[1]
    self.spawned = properties[2] ~= 0
end

TileTrampoline = class(TileSprite)
TrampolineDirection = enum {
    'down',
    'left',
    'up',
    'right'
}
local trampoline_directions = {
    { x =  0, y =  1 },
    { x = -1, y =  0 },
    { x =  0, y = -1 },
    { x =  1, y =  0 }
}
local trampoline_directions_name = {
    'down',
    'left',
    'up',
    'right'
}

function TileTrampoline:new(x, y, properties)
    TileSprite.new(self, 'trampoline.png', 0, 40, 35, x * 30, y * 30, 0, -1)

    local direction = properties[1] + 1
    local distance = properties[2]
    local offset = trampoline_directions[direction]

    self.direction = trampoline_directions_name[direction]
    self.distance = distance
    self.offset = {
        x = offset.x * distance,
        y = offset.y * distance
    }
end

function TileTrampoline:render()
    TileSprite.render(self)

    if debug_enable then
        love.graphics.setColor({0, 0.1, 1})

        local tx = self.x + self.offset.x * 30
        local ty = self.y + self.offset.y * 30

        if self.x ~= tx or self.y ~= ty then
            love.graphics.circle('line', self.x, self.y, 15 + 10)
            love.graphics.line(self.x, self.y, tx, ty)
            love.graphics.circle('line', tx, ty, 15 + 10)
        end
        love.graphics.setColor({1, 1, 1})
    end
end

TileItems = class(TileSprite)
ItemType = enum {
    'Berzerker',
    'Invisibility',
    'Banana',
    'Sock',
    'Brick',
    'RabberMelon',
    'ThrowableMelon',
    'Carrot',
    'Melon',
    'Helmet',
    'Pineapple' ,
    'Bomb',
    'Mine',
    'Coins' 
}

TileItems.ItemData = {
    [ItemType.Berzerker]      = nil,
    [ItemType.Invisibility]   = nil,
    [ItemType.Banana]         = nil,
    [ItemType.Sock]           = nil,
    [ItemType.Brick]          = nil,
    [ItemType.RabberMelon]    = nil,
    [ItemType.ThrowableMelon] = nil,
    [ItemType.Carrot]         = nil,
    [ItemType.Melon]          = {
        itemId = 'melon',
        sprite = sprite('weapons/melon.png', 20, 20, 6)
    },
    [ItemType.Helmet]         = nil,
    [ItemType.Pineapple]      = nil,
    [ItemType.Bomb]           = nil,
    [ItemType.Mine]           = nil,
    [ItemType.Coins]          = nil,
    Default                         = {
        sprite = sprite('menu/signs.png', 18, 18, 2)
    }
} 

function TileItems:new(x, y, properties)
    self.type = properties[1]
    self.invisible = properties[2] ~= 0
    self.spawned = properties[3] ~= 0
    self.properties = properties

    local item = TileItems.ItemData[self.type] or self.ItemData.Default
    local data = item.sprite

    TileSprite.new(self, data.texture, 0, data.w, data.h, x * 30, y * 30, 0, 0)

    self.itemId = item.itemId

    self.time = love.math.random(math.pi * 2)
end

function TileItems:onCreate()
    self.level.updates:add(self)
end

function TileItems:onRemove()
    self.level.updates:remove(self)
end

function TileItems:updateEvent(dt)
    self.time = self.time + dt * 4

    self.dy = -(math.sin(self.time) + 1) * 4
end

TileFlagBlue = class(TileSprite)
function TileFlagBlue:new(x, y)
    TileSprite.new(self, 'fx/ctf_flag.png', 0, 17, 20, x * 30, y * 30, 0, 0)
end

TileFlagRed = class(TileSprite)
function TileFlagRed:new(x, y)
    TileSprite.new(self, 'fx/ctf_flag.png', 1, 17, 20, x * 30, y * 30, 0, 0)
end

TileTrigger = class(TileSprite)
TriggerAction = enum {
    'None',
    'TriggerToggle',
    'TriggerExec',
    'LevelWin',
    'LevelLose',
    'PointerSet',
    'PointerDelete',
    'Damage50',
    'TriggerExec_WO_Delay',
    'SP_Active',
    'SP_Deactive',
    'EmitterToggle',
    'WeaponSpawn',
    'ItemSpawn',
    'WallSpawn',
    'WallRemove',
    'CameraSet',
    'CameraSlide',
    'CameraFree',
    'BotRemove',
    'Counter',
    'Message',
    'Damage50_Silent',
    'CameraSlide_Slowest',
    'WeaponRemove'
}

TriggerExecutor = enum {
    'Player',
    'Nobody',
    'Anybody',
    'Teams',
    'Neutrals',
    'Team_0',
    'Team_1',
    'OnStart'
}

function TileTrigger:new(x, y, properties)
    TileSprite.new(self, 'menu/signs.png', 0, 18, 18, x * 30, y * 30, 0, 0)

    self.action = properties[1]
    self.width = properties[2]
    self.height = properties[3]
    self.executor = properties[4]
    self.target_x = properties[5]
    self.target_y = properties[6]
    self.execution_times = properties[7]
    self.execution_delay = properties[8]
    self.active = properties[9]
    self.execute_at_fire = properties[10]
    self.execute_at_use = properties[11]
    self.activate_trigger_x = properties[12]
    self.activate_trigger_y = properties[13]
    self.execute_trigger = properties[14]
    self.parameter = properties[15] -- delay?
end

function TileTrigger:isAutoTrigger()
    return self.execution_delay ~= 0
end

function TileTrigger:render()
    if debug_enable then
        local x = self.x
        local y = self.y
        local w = self.width * 30
        local h = self.height * 30

        local tx = x
        local ty = y
        
        local ax = x
        local ay = y

        if self.target_x ~= 255 then
            tx = self.target_x * 30
        end
        if self.target_y ~= 255 then
            ty = self.target_y * 30
        end

        if self.activate_trigger_x ~= 255 then
            ax = self.activate_trigger_x * 30
        end
        if self.activate_trigger_y ~= 255 then
            ay = self.activate_trigger_y * 30
        end

        local action = self.action

        if action == TriggerAction.PointerSet and self:isAutoTrigger() then
            love.graphics.circle('line', x, y, 15)
        end

        love.graphics.setColor({0, 0.1, 1})
        love.graphics.rectangle('line', x - 15, y - 15, w, h, 5, 5)

        if self.x ~= tx or self.y ~= ty then
            love.graphics.line(self.x, self.y, tx, ty)
            love.graphics.circle('line', tx, ty, 15 + 10)
        end

        if self.x ~= ax or self.y ~= ay then
            love.graphics.setColor({0.8, 0.8, 0.8})
            love.graphics.line(self.x, self.y, ax, ay)
            love.graphics.circle('line', ax, ay, 10)
        end

        love.graphics.setColor({1, 1, 1})
    end

    TileSprite.render(self)
end