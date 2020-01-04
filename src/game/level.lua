import 'general/list'
import 'general/invoke'
import 'general/assets'
import 'general/math/rect'
import 'general/buffer-stream'
import 'general/graphics/screen'
import 'general/ui/graphics-item'

import 'game/tile/tiles'

local function compare_tiles(a, b)
    if a.layer == b.layer then
        if a.y == b.y then
            return a.x < b.x
        end

        return a.y < b.y
    end

    return a.layer < b.layer
end


Level = class(GraphicsItem)
function Level:new(scene)
    GraphicsItem.new(self, scene)
    self:setSize(Screen.width, Screen.height)
    self.ignore_self_touches = false

    -- todo: make layers as GraphicsItem
    self.ground   = List()
    self.bottom   = List()
    self.middle   = List()
    self.top      = List()
    self.special  = List()
    self.updates  = List()
    self.spawners = List()
    self.triggers = List()
end

function Level:resizeEvent(w, h)
    self:setSize(w, h)
end

function Level:loadLite()
    error("function 'Level:loadLite' is not implemented")
end

function Level:addCollision(x, y)
    local i = y * self.width + x
    self.collision[i] = (self.collision[i] or 0) + 1
end

function Level:removeCollision(x, y)
    local i = x * width + y
    self.collision[i] = self.collision[i] - 1
end

function Level:loadFull()
    local width = self.width
    local height = self.height

    local size = width * height

    local data = self.layers_data

    local layer_parsers = {
        [0] = function()
            local buf = { data:read(size):byte(1, -1) }

            local i = 1
            for tile_x = 0, width - 1 do
                for tile_y = 0, height - 1 do
                    if buf[i] ~= 0 then
                        self:addTile('ground', TileGrass(buf[i] - 1, tile_x, tile_y))
                    end
                    i = i + 1
                end
            end
        end;
        [1] = function()
            local buf = { data:read(size):byte(1, -1) }

            local i = 1
            for tile_x = 0, width - 1 do
                for tile_y = 0, height - 1 do
                    if buf[i] ~= 0 then
                        self:addTile('ground', TileTrail(buf[i] - 1, tile_x, tile_y))
                    end
                    i = i + 1
                end
            end
        end;
        [2] = function()
            local count = data:i16()

            for i = 1, count do
                local tile_x = data:i8()
                local tile_y = data:i8()
                local type = data:i8()

                if type ~= 0xFF then 
                    local properties = { data:read(2):byte(1, -1) }

                    if type == 0 then
                        self:addCollision(tile_x, tile_y)
                        self:addTile('middle', TileWall(tile_x, tile_y, properties))
                    elseif type == 1 then
                        self:addCollision(tile_x, tile_y)
                        self:addTile('middle', TileWoodWall(tile_x, tile_y, properties))
                    elseif type == 2 then
                        self:addCollision(tile_x, tile_y)
                        self:addCollision(tile_x + 2, tile_y)
                        self:addTile('middle', TileGates(tile_x, tile_y, properties))
                    elseif type == 3 then
                        self:addCollision(tile_x + 0, tile_y)
                        self:addCollision(tile_x + 1, tile_y)
                        self:addCollision(tile_x + 2, tile_y)

                        self:addCollision(tile_x + 0, tile_y + 1)
                        self:addCollision(tile_x + 2, tile_y + 1)

                        self:addCollision(tile_x + 0, tile_y + 2)
                        self:addCollision(tile_x + 2, tile_y + 2)
                        self:addTile('middle', TileHouseBottom(tile_x, tile_y))
                        self:addTile('top', TileHouseTop(tile_x, tile_y))
                    elseif type == 4 then
                        self:addCollision(tile_x, tile_y)
                        self:addTile('bottom', TileTreeShadow(tile_x, tile_y))
                        self:addTile('middle', TileTreeStubs(tile_x, tile_y, properties))
                        if properties[2] > 1 then
                            self:addTile('top', TileTreeCrown(tile_x, tile_y, properties))
                        end
                    elseif type == 5 then
                        self:addCollision(tile_x, tile_y)
                        self:addTile('middle', TileWell(tile_x, tile_y, properties))
                    elseif type == 6 then
                        -- self:addTile('middle', TileTent(tile_x, tile_y, properties))
                    elseif type == 7 then
                        -- self:addTile('middle', TileChest(tile_x, tile_y, properties))
                    end
                end
            end
        end;
        [3] = function()
            local count = data:i32()

            for i = 1, count do
                local x = data:i16()
                local y = data:i16()
                local type = data:i8()
                local subtype = data:i8()
                local tile_x = math.floor(x / 30)
                local tile_y = math.floor(y / 30)

                if type == 0 then
                    self:addTile('bottom', TileStones20(x, y, subtype))
                elseif type == 1 then
                    self:addTile('bottom', TileStones30(x, y, subtype))
                elseif type == 2 then
                    self:addTile('middle', TileBushesBig(x, y, subtype))
                elseif type == 3 then
                    self:addCollision(tile_x, tile_y)
                    self:addTile('middle', TileBushesBananas(x, y, subtype))
                elseif type == 4 then
                    self:addCollision(tile_x, tile_y)
                    self:addTile('middle', TileTelegaBricks(x, y, subtype))
                elseif type == 5 then
                    self:addTile('middle', TileRidge(x, y, subtype))
                elseif type == 6 then
                    self:addTile('bottom', TileCactusesSmall(x, y, subtype))
                end
            end
        end;
        [4] = function()
            local count = data:i32()

            for i = 1, count do
                local type = data:i8()
                local tile_x = data:i8()
                local tile_y = data:i8()
                local properties
                
                local params_count = data:i8()
                if params_count > 0 then
                    properties = { data:read(params_count):byte(1, -1) }
                end

                if type == 0 then
                    self:addTile('spawners', TileSpawnPoint(tile_x, tile_y, properties))
                elseif type == 1 then
                    self:addTile('special', TileStaticWeapon(tile_x, tile_y, properties))
                elseif type == 2 then
                    self:addTile('middle', TileTrampoline(tile_x, tile_y, properties))
                elseif type == 3 then
                    self:addTile('special', TileItems(tile_x, tile_y, properties))
                elseif type == 4 then
                    self:addTile('special', TileFlagBlue(tile_x, tile_y))
                elseif type == 5 then
                    self:addTile('special', TileFlagRed(tile_x, tile_y))
                elseif type == 6 then
                    -- self:addTile('special', TileDeathZone(tile_x, tile_y))
                elseif type == 7 then
                    self:addTile('triggers', TileTrigger(tile_x, tile_y, properties))
                elseif type == 8 then
                    -- self.triggers:add(TileParticle(tile_x, tile_y, properties))
                end
            end
        end
    }
    
    while data:__boolean() do
        layer_parsers[data:i8()]()
    end
end

local function loadBuffer(path)
    return BufferStream(AssetManager.readFile(path))
end

function Level:load(path)
    self.ground:clear()
    self.bottom:clear()
    self.middle:clear()
    self.top:clear()
    self.special:clear()
    self.updates:clear()
    self.spawners:clear()
    self.triggers:clear()

    local buffer = loadBuffer(path)

    local magic = buffer:i8()
	local format = buffer:i8()
    local version = buffer:i32()
    self.width = buffer:i8()
    self.height = buffer:i8()

    self.layers_data = BufferStream(buffer:read(buffer:i32()))
    self.collision = {}

    local params_count = buffer:i32()
	self.track = buffer:i8()
	self.difficulty = buffer:i8()
    self.intro = buffer:i8()
    
    local loaders = {
        Level.loadLite, 
        Level.loadFull
    }
    
    loaders[format](self)

    self.bottom:stable_sort(compare_tiles)
    self.top:stable_sort(compare_tiles)
    self.middle:stable_sort(compare_tiles)
end

function Level:canWalk(x, y)
    if x < 0 or x > self.width -1 or y < 0 or y > self.height - 1 then
        return false
    end
    return (self.collision[y * self.width + x] or 0) == 0
end

function Level:getSpawnTile(race)
    return self.spawners:find(Self.equals, race).value
end

function Level:mouseMoveEvent(event)
    if event.drag then
        self.dragging = true
        self.parent.camera:move(event.dx, event.dy)
        return true
    end
    return false
end

function Level:mouseReleaseEvent(event)
    self.dragging = false
end

local function draw(level, layer, bounds)
    layer:foreach(function(tile)
        if bounds:intersect(tile:boundingRect()) then
            tile:render()
        end
    end)
end

function Level:paintEvent()
    self.parent.camera:beforeRenderEvent()

    local bounds = self.parent.camera:getRect()

    draw(self, self.ground, bounds)
    draw(self, self.bottom, bounds)
    draw(self, self.middle, bounds)
    draw(self, self.special, bounds)
    draw(self, self.top, bounds)
    draw(self, self.triggers, bounds)
    
    self.parent.camera:afterRenderEvent()
end

function Level:addTile(layer_name, tile)
    assert(rawequal(tile.level_layer, nil))

    local layer = self[layer_name]
    tile.level_layer = layer
    layer:add(tile)
    layer:stable_sort(compare_tiles)
    
    invoke(tile, 'onCreate', self)
end

function Level:removeTile(tile)
    invoke(tile, 'onDestroy', self)

    tile.level_layer:remove(tile)
    tile.level_layer = nil
end

function Level:updateEvent(dt)
    self.updates:foreach(Self.updateEvent, dt)

    local player = self.parent.player

    if player.isExecuting then
        return
    end

    local it = self.special:find(function(tile, player)
        local dx = math.abs(tile.x - player.x)
        local dy = math.abs(tile.y - player.y)
        return dx < 5 and dy < 5
    end, player)

    if it then
        local tile = it.value

        if tile:is(TileItems) then
            self.parent:pickup(tile)
            self:removeTile(tile)
        end
        return
    end

    it = self.middle:find(function(tile, player)
        if tile:is(TileTrampoline) then
            local dx = math.abs(tile.x - player.x)
            local dy = math.abs(tile.y - player.y)
            return dx < 5 and dy < 5
        end
        return false
    end, player)

    if it then
        player:execute(it.value)
        return
    end
end