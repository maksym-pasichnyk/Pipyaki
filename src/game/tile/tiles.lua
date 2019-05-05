import 'game/tile/tile-sprite'

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
    TileSprite.new(self, 'tree_crowns.png', properties[2] - 1, 105, 92, x * 30, y * 30, 0, -50)
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
TileSpawnPoint.Race = {
    Pipyaka = 0,
    Bombaka = 1,
    Slonyaka = 2,
    Ulityaka = 3,
    Cannon = 4,
    Kamikaze = 5,
    Rocketman = 6,
    Miner = 7,
    Digger = 8,
    Spider = 9
}

TileSpawnPoint.Behaviour = {
    Default = 0,
    Blind_N_Deaf = 1,
    Camper = 2,
    ProtectRadius_3 = 3,
    ProtectRadius_1 = 4
}

TileSpawnPoint.Team = {
    SinglePlayer = 0,
    Neutral = 1,
    Team_0 = 2,
    Team_1 = 3
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
TileStaticWeapon.Type = {
    Rake = 0,
    Bananas_Skin = 1,
    RabberMelon_Down = 2,
    RabberMelon_Left = 3,
    RabberMelon_Up = 4,
    RabberMelon_Right = 5
}

function TileStaticWeapon:new(x, y, properties)
    TileSprite.new(self, 'weapons/bomb.png', 0, 30, 30, x * 30, y * 30, 0, 0)

    self.type = properties[1]
    self.spawned = properties[2] ~= 0
end

TileTrampoline = class(TileSprite)
TileTrampoline.Direction = {
    Down = 0,
    Left = 1,
    Up = 2,
    Right = 3
}

function TileTrampoline:new(x, y, properties)
    TileSprite.new(self, 'trampoline.png', 0, 35, 35, x * 30, y * 30, 0, 0)

    self.direction = properties[1]
    self.distance = properties[2]
end

TileItems = class(TileSprite)
TileItems.Type = {
    Berzerker = 0,
    Invisibility = 1,
    Banana = 2,
    Sock = 3,
    Brick = 4,
    RabberMelon = 5,
    ThrowableMelon = 6,
    Carrot = 7,
    Melon = 8,
    Helmet = 9,
    Pineapple = 10,
    Bomb = 11,
    Mine = 12,
    Coins = 13
}
function TileItems:new(x, y, properties)
    TileSprite.new(self, 'menu/signs.png', 0, 18, 18, x * 30, y * 30, 0, 0)

    self.type = properties[1]
    self.invisible = properties[2] ~= 0
    self.spawned = properties[3] ~= 0
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
TileTrigger.Action = {
    None = 0,
    TriggerToggle = 1,
    TriggerExec = 2,
    LevelWin = 3,
    LevelLose = 4,
    PointerSet = 5,
    PointerDelete = 6,
    Damage50 = 7,
    TriggerExec_WO_Delay = 8,
    SP_Active = 9,
    SP_Deactive = 10,
    EmitterToggle = 11,
    WeaponSpawn = 12,
    ItemSpawn = 13,
    WallSpawn = 14,
    WallRemove = 15,
    CameraSet = 16,
    CameraSlide = 17,
    CameraFree = 18,
    BotRemove = 19,
    Counter = 20,
    Message = 21,
    Damage50_Silent = 22,
    CameraSlide_Slowest = 23,
    WeaponRemove = 24
}

TileTrigger.Executor = {
    Player = 0,
    Nobody = 1,
    Anybody = 2,
    Teams = 3,
    Neutrals = 4,
    Team_0 = 5,
    Team_1 = 6,
    OnStart = 7
}

function TileTrigger:new(x, y, properties)
    -- TileSprite.new(self, 'fx/ctf_flag.png', 1, 17, 20, x * 30, y * 30, 0, 0)

    self.action = properties[1]
    self.executor = properties[2]
    self.width = properties[3]
    self.height = properties[4]
    self.target_x = properties[5]
    self.target_y = properties[6]
    self.trigger_x = properties[7]
    self.trigger_y = properties[8]

    self.delay = properties[11]
end