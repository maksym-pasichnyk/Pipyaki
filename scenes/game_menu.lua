import 'class'
import 'scene'
import 'scene-manager'
import 'input'
import 'player'
import 'level'
import 'resources'
import 'graphics'
import 'ui/element'
import 'ui/label'
import 'screen'
import 'weapon-manager'

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

    self.level = Level()
    self.level:load(maps[1])
    self.level:addEntity(Player(5, 9))

    self:add(self.level)
    self:add(WeaponManager())
end

function GameMenu:keyPressEvent(event)
    if event:single() then
        local key = event.key
        if key == 'escape' then
            event:accept()
            SceneManager:switch('main')
        elseif key == 'i' then
            event:accept()
        elseif key == 'space' then
            event:accept()
        end
    end
end