import 'general/list'
import 'general/scene/scene'
import 'general/scene/scene-manager'

import 'game/level'
import 'game/characters/pipyaka'
import 'game/inventory'

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

GameScene = class(Scene)
function GameScene:new()
    Scene.new(self)

    self.dx = 0
    self.dy = 0
 
    self.stack = List()
    self.stack:add(self)
    
    self.level = Level()
    self.level:load(maps[1])

    local tile = self.level:getPlayerSpawnTile()
    self.level:addEntity(Pipyaka(tile.tile_x, tile.tile_y))

    self.inventory = Inventory()

    self:add(self.level)
    self:add(self.inventory)
end

function GameScene:enter()
    self.inventory.enabled = false
end

function GameScene:escape_action()
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
        elseif key == 'space' then
            event:accept()
        end
    end
end