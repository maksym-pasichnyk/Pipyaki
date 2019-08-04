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
function Indicator:new(inventory)
    GraphicsItem.new(self)
    self.inventory = inventory

    self:resizeEvent(Screen.width, Screen.height)
end

function Indicator:resizeEvent(w, h)
    self.x = w - 48 - 32
    self.y = h - 48
end

function Indicator:paintEvent()
    Sprite.render(self.inventory:getIcon(), 0, 0)
    love.graphics.printf(tostring(self.inventory:getCount()), -10, 12, 48 + 32, 'right')
end

GameScene = class(Scene)
function GameScene:new()
    Scene.new(self)

    self.camera = Camera()

    self.camera_target_x = 0
    self.camera_target_y = 0
    
    self.level = Level()

    self.level_index = 1

    self.inventory = Inventory()
    self.indicator = Indicator(self.inventory)

    self:add(self.level)
    self:add(self.inventory)
    self:add(self.indicator)

    self:startLevel()
end

function GameScene:startLevel()
    self.level:load(maps[self.level_index])
    self.level_width = (self.level.width - 1) * 30
    self.level_height = (self.level.height - 1) * 30
    self:spawnPlayer()

    self:resetCamera()
end

function GameScene:spawnPlayer()
    local tile = self.level:getSpawnTile(TileSpawnPoint.Race.Pipyaka)
    self.player = Pipyaka(tile.tile_x, tile.tile_y)
    self.level:addTile('middle', self.player)
end

function GameScene:enter()
    self.inventory.enabled = false
    self:resetCamera()
end

function GameScene:resetCamera()
    local hw = Screen.width * 0.5
    local hh = Screen.height * 0.5

    self.camera.x = -self.player.x + hw
    self.camera.y = -self.player.y + hh

    self.camera.rx = self.camera.x
    self.camera.ry = self.camera.y

    self:move_camera(0, 0)
end

function GameScene:updateCamera(dt)
    if self.pressed then
        return
    end
    local hw = Screen.width * 0.5
    local hh = Screen.height * 0.5

    local x = -(self.player.x + self.camera_target_x - hw)
    local y = -(self.player.y + self.camera_target_y - hh)

    self.camera.rx = x
    self.camera.ry = y

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
    Scene.keyPressEvent(self, event)

    if event.accepted then
        return
    end

    if event:single() then
        local key = event.key
        if key == 'escape' then
            event:accept()
            SceneManager.switch('main')
        elseif key == 'i' then
            event:accept()
            self.inventory.enabled = not self.inventory.enabled
        elseif debug_enable then
            if key == 'c' then
                event:accept()
                self.free_camera = not self.free_camera
            elseif key == ',' then
                self.level_index = self.level_index - 1
                if self.level_index == 0 then
                    self.level_index = 34
                end
                self:startLevel()
            elseif key == '.' then
                self.level_index = self.level_index % 34 + 1
                self:startLevel()
            end
        end
    end
end

function GameScene:move_camera(x, y)
    self.camera_target_x = x
    self.camera_target_y = y
end

function GameScene:pickup(tile)
    local slot = self.inventory:getSlot(tile.itemId)

    local count = self.inventory.counts[slot]
    self.inventory.counts[slot] = count + love.math.random(10, 20)
end

function GameScene:updateEvent(dt)
    if self.inventory.enabled then

    else
        if self.player:isIdle() then
            if Input.getAnyButton {'left', 'a'} then
                self.player:move('left')
                self:move_camera(-60, 0)
            elseif Input.getAnyButton {'right', 'd'} then
                self.player:move('right')
                self:move_camera(60, 0)
            elseif Input.getAnyButton {'up', 'w'} then
                self.player:move('up')
                self:move_camera(0, -60)
            elseif Input.getAnyButton {'down', 's'} then
                self.player:move('down')
                self:move_camera(0, 60)
            end
        end

        if self.player:isIdle() then
            if Input.getButtonDown('space') then
                local item = self.inventory:useItem()
                if item then
                    if item.type == 'tile' then
                        self.level:addTile('middle', TileWeapon(item, self.player.x, self.player.y))
                    end
                end
            end
        end
    end

    if not self.free_camera then
        self:updateCamera(dt)
    end
end