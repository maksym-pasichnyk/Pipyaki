import 'general/list'
import 'general/input'
import 'general/scene/scene'
import 'general/graphics/sprite'
import 'general/scene/scene-manager'
import 'general/camera'

import 'game/level'
import 'game/characters/pipyaka'
import 'game/inventory'
import 'game/weapons/weapons'

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
    'maps/campaign/map16.map',
    'maps/campaign/map17.map',
    'maps/campaign/map18.map',
    'maps/campaign/map19.map',
    'maps/campaign/map20.map',
    'maps/campaign/map21.map',
    'maps/campaign/map22.map',
    'maps/campaign/map23.map',
    'maps/campaign/map24.map',

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

local Indicator = class(GraphicsItem)
function Indicator:new(scene)
    GraphicsItem.new(self, scene)
    self:resizeEvent(Screen.width, Screen.height)
end

function Indicator:resizeEvent(w, h)
    self.x = w - 48 - 32
    self.y = h - 48
end

function Indicator:paintEvent()
    local item = self.item
    if item then
        Sprite.render(item.icon, 0, 0)
        love.graphics.printf(tostring(item.count), -10, 12, 48 + 32, 'right')
    end
end

GameScene = class(Scene)
function GameScene:new()
    Scene.new(self)

    self.camera = Camera()

    self.camera_target_x = 0
    self.camera_target_y = 0
    
    self.level = Level(self)
    self.inventory = Inventory(self)
    self.indicator = Indicator(self)
    self.default_item = self.inventory:getItemById('melon')
end

function GameScene:enter()
    Scene.reset(self)

    self.default_item:set(100)
    self.inventory:selectSlot(self.default_item.slot)

    self:startLevel(1)

    self.inventory.enabled = false
    self:resetCamera()
end

function GameScene:OnItemChange(item)
    self.indicator.item = item
end

function GameScene:startLevel(index)
    self.level_index = index
    self.level:load(maps[index])
    self.level_width = (self.level.width - 1) * 30
    self.level_height = (self.level.height - 1) * 30
    self:spawnPlayer()

    self:resetCamera()
end

function GameScene:spawnPlayer()
    local tile = self.level:getSpawnTile(SpawnRace.Pipyaka)
    self.player = Pipyaka(tile.tile_x, tile.tile_y)
    self.level:addTile('middle', self.player)
end

function GameScene:resetCamera()
    local hw = Screen.width * 0.5
    local hh = Screen.height * 0.5

    self.camera.x = -self.player.x + hw
    self.camera.y = -self.player.y + hh

    self:move_camera(0, 0)
end

function GameScene:updateCamera(dt)
    local hw = Screen.width * 0.5
    local hh = Screen.height * 0.5

    local x = -(self.player.x + self.camera_target_x - hw)
    local y = -(self.player.y + self.camera_target_y - hh)

    local dx = x - self.camera.x
    local dy = y - self.camera.y

    -- if math.abs(dx) > 31 then
        self.camera.x = self.camera.x + dx * dt * 5
    -- end

    -- if math.abs(dy) > 31 then
        self.camera.y = self.camera.y + dy * dt * 5
    -- end
end

function GameScene:keyPressEvent(event)
    if Scene.keyPressEvent(self, event) then
        return true
    end

    if event:single() then
        local key = event.key
        if key == 'escape' then
            SceneManager.switch('main')
            return true
        elseif key == 'i' then
            self.inventory.enabled = not self.inventory.enabled
            return true
        elseif debug_enable then
            if key == 'c' then
                self.free_camera = not self.free_camera
                return true
            elseif key == ',' then
                local index = self.level_index - 1
                if index == 0 then
                    index = 34
                end
                self:startLevel(index)
                return true
            elseif key == '.' then
                self:startLevel(self.level_index % 34 + 1)
                return true
            end
        end
        return false
    end
    return false
end

function GameScene:move_camera(x, y)
    self.camera_target_x = x
    self.camera_target_y = y
end

function GameScene:pickup(tile)
    local item = self.inventory:getItemById(tile.itemId)
    item.count = item.count + love.math.random(10, 20)
end

function GameScene:updateEvent(dt)
    if self.inventory.enabled then
        
    else
        local player = self.player
        if player:isIdle() then
            if Input.getAnyButton {'left', 'a'} then
                player:move('left', self.level:canWalk(player.tile_x - 1, player.tile_y))
                self:move_camera(-60, 0)
            elseif Input.getAnyButton {'right', 'd'} then
                player:move('right', self.level:canWalk(player.tile_x + 1, player.tile_y))
                self:move_camera(60, 0)
            elseif Input.getAnyButton {'up', 'w'} then
                player:move('up', self.level:canWalk(player.tile_x, player.tile_y - 1))
                self:move_camera(0, -60)
            elseif Input.getAnyButton {'down', 's'} then
                player:move('down', self.level:canWalk(player.tile_x, player.tile_y + 1))
                self:move_camera(0, 60)
            end
        end

        if player:isIdle() then
            if Input.getButtonDown('space') then
                local item = self.inventory.item
                if item and item:use() then
                    local data = item.data
                    if data.type == 'tile' then
                        self.level:addTile('middle', TileWeapon(data, self.player.x, self.player.y))
                    elseif data.type == 'throwable' then
                        self.level:addTile('middle', Throwable(data, self.player.x, self.player.y, self.player.direction))
                    end
                end
            end
        end
    end

    if self.free_camera or self.level.dragging then
        return
    end

    self:updateCamera(dt)
end