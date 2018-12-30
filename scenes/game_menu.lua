import 'class'
import 'scene'
import 'scene-manager'
import 'input'
import 'pipyaka'
import 'level'
import 'resources'
import 'graphics'
import 'ui/element'
import 'weapon-manager'
import 'list'

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

GameMenu = class(Scene)
function GameMenu:new()
    Scene.new(self)

    self.dx = 0
    self.dy = 0
 
    self.stack = List()
    self.stack:add(self)
    
    self.level = Level()
    self.level:load(maps[1])

    local tile = self.level:getPlayerSpawnTile()
    self.level:addEntity(Pipyaka(tile.tile_x, tile.tile_y))

    self.weapons = WeaponManager()

    self:add(self.level)
    self:add(self.weapons)
end

function GameMenu:enter()
    self.weapons.enabled = false
end

function GameMenu:escape_action()
end

function GameMenu:joystickPressEvent(event)
    Scene.joystickPressEvent(self, event)

    if event.accepted then
        return
    end

    if event.button == 'b' then
        event:accept()
        SceneManager:switch('main')
    elseif event.button == 'y' then
        event:accept()
        self.weapons.enabled = not self.weapons.enabled
    end
end

function GameMenu:keyPressEvent(event)
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
            self.weapons.enabled = not self.weapons.enabled
        elseif key == 'space' then
            event:accept()
        end
    end
end