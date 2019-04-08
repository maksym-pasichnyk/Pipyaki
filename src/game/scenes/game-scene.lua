import 'general/list'
import 'general/input'
import 'general/scene/scene'
import 'general/graphics/sprite'
import 'general/scene/scene-manager'

import 'game/level'
import 'game/characters/pipyaka'
import 'game/inventory'
import 'game/weapons/weapons'

local function getInputAxis()
    local horizontal = Input:GetAxis 'leftx#1'
    local vertical = Input:GetAxis 'lefty#1'

    if math.abs(horizontal) > math.abs(vertical) then
        vertical = 0
    else
        horizontal = 0
    end

    return horizontal, vertical
end

local maps = {
    'maps/campaign/map0.map',
    'maps/campaign/map1.map',
    'maps/campaign/map2.map',
    'maps/campaign/map3.map',
    'maps/campaign/map4.map',
    'maps/campaign/map5.map',
    'maps/campaign/map6.map',
    'maps/campaign/map7.map',
    'maps/campaign/map8.map',
    'maps/campaign/map9.map',
    'maps/campaign/map10.map',
    'maps/campaign/map11.map',
    'maps/campaign/map12.map',
    'maps/campaign/map13.map',
    'maps/campaign/map14.map',
    'maps/campaign/map15.map',

    'maps/ctf_headphones.map',
    'maps/ctf_microscheme.map',
    'maps/ctf_monster.map',

    'maps/dm_crossroad.map',
    'maps/dm_fall.map',
    'maps/dm_placidity.map',
    'maps/dm_target.map',
    
    'maps/tm_bouncing.map',
    'maps/tm_suicide.map'
}

Indicator = class(GraphicsItem)
function Indicator:new(inventory)
    GraphicsItem.new(self)
    self.inventory = inventory
    self.x = Screen.width - 48 - 32
    self.y = Screen.height - 48
end

function Indicator:paintEvent()
    Sprite.render(self.inventory:getIcon(), 0, 0)
    love.graphics.printf(tostring(self.inventory:getCount()), -10, 12, 48 + 32, 'right')
end

GameScene = class(Scene)
function GameScene:new()
    Scene.new(self)

    self.dx = 0
    self.dy = 0
    
    self.level = Level()
    self.level:load(maps[1])

    local tile = self.level:getPlayerSpawnTile()
    self.player = Pipyaka(tile.tile_x, tile.tile_y)
    self.level.middle:add(self.player)

    self.inventory = Inventory()
    self.indicator = Indicator(self.inventory)

    self:add(self.level)
    self:add(self.inventory)
    self:add(self.indicator)
end

function GameScene:enter()
    self.inventory.enabled = false
end

function GameScene:joystickPressEvent(event)
    Scene.joystickPressEvent(self, event)

    if event.accepted then
        return
    end

    if event.button == 'b' then
        event:accept()
        SceneManager:switch('main')
    elseif event.button == 'y' then
        event:accept()
        self.inventory.enabled = not self.inventory.enabled
    end
end

function GameScene:keyPressEvent(event)
    Scene.keyPressEvent(self, event)

    if event.accepted then
        return
    end

    if event:single() then
        local key = event.key
        if key == 'escape' then
            event:accept()
            SceneManager:switch('main')
        elseif key == 'i' then
            event:accept()
            self.inventory.enabled = not self.inventory.enabled
        end
    end
end

function GameScene:updateEvent()
    local h, v = getInputAxis()

    if Input:GetAnyButton {'left', 'dpleft#1', 'a'} or h < 0 then
        self.player:move('left')
    end
    
    if Input:GetAnyButton {'right', 'dpright#1', 'd'} or h > 0 then
        self.player:move('right')
    end
    
    if Input:GetAnyButton {'up', 'dpup#1', 'w'} or v < 0 then
        self.player:move('up')
    end
    
    if Input:GetAnyButton {'down', 'dpdown#1', 's'} or v > 0 then
        self.player:move('down')
    end

    if self.player:isIdle() then
        if Input:GetAnyButtonDown {'space'} then
            local item = self.inventory:useItem()
            if item then
                if item.type == 'tile' then
                    self.level.middle:add(TileWeapon(self, item, self.player.x, self.player.y))
                end
            end
        end
    end
end