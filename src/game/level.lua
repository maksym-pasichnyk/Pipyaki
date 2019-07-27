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
function Level:new()
    GraphicsItem.new(self)
    self:setSize(Screen.width, Screen.height)
end

function Level:resizeEvent(w, h)
    self:setSize(w, h)
end

function Level:load(path)
    self.ground = List()
    self.bottom = List()
    self.middle = List()
    self.top = List()
    self.special = List()
    self.update_tiles = List()
    self.spawners = List()

    local buffer = BufferStream(AssetManager.readFile(path))

    local magic = buffer:i8()
	local type = buffer:i8()
    local version = buffer:i32()

    local width = buffer:i8()
    local height = buffer:i8()

    self.width = width
    self.height = height
    
    local size = width * height

    local data = BufferStream(buffer:read(buffer:i32()))
    
    while data:__boolean() do
        local layer = data:i8()

        if layer == 0 then
            local buf = { data:read(size):byte(1, -1) }

            local i = 1
            for tile_x = 0, width - 1 do
                for tile_y = 0, height - 1 do
                    if buf[i] ~= 0 then
                        self.ground:add(TileGrass(buf[i] - 1, tile_x, tile_y))
                    end
                    i = i + 1
                end
            end
        elseif layer == 1 then
            local buf = { data:read(size):byte(1, -1) }

            local i = 1
            for tile_x = 0, width - 1 do
                for tile_y = 0, height - 1 do
                    if buf[i] ~= 0 then
                        self.ground:add(TileTrail(buf[i] - 1, tile_x, tile_y))
                    end
                    i = i + 1
                end
            end
        elseif layer == 2 then
            local count = data:i16()

            for i = 1, count do
                local tile_x = data:i8()
                local tile_y = data:i8()
                local type = data:i8()

                if type ~= 0xFF then 
                    local properties = { data:read(3):byte(1, -1) }

                    if type == 0 then
                        self.middle:add(TileWall(tile_x, tile_y, properties))
                    elseif type == 1 then
                        self.middle:add(TileWoodWall(tile_x, tile_y, properties))
                    elseif type == 2 then
                        self.middle:add(TileGates(tile_x, tile_y, properties))
                    elseif type == 3 then
                        self.middle:add(TileHouseBottom(tile_x, tile_y))
                        self.top:add(TileHouseTop(tile_x, tile_y))
                    elseif type == 4 then
                        self.bottom:add(TileTreeShadow(tile_x, tile_y))
                        self.middle:add(TileTreeStubs(tile_x, tile_y, properties))
                        if properties[2] > 1 then
                           self.top:add(TileTreeCrown(tile_x, tile_y, properties))
                        end
                    elseif type == 5 then
                        self.middle:add(TileWell(tile_x, tile_y, properties))
                    elseif type == 6 then
                        -- self.middle:add(TileTent(tile_x, tile_y, properties))
                    elseif type == 7 then
                        -- self.middle:add(TileChest(tile_x, tile_y, properties))
                    end
                end
            end
        elseif layer == 3 then
            local count = data:i32()

			for i = 1, count do
				local x = data:i16()
				local y = data:i16()
				local type = data:i8()
                local subtype = data:i8()

                if type == 0 then
                    self.bottom:add(TileStones20(x, y, subtype))
                elseif type == 1 then
                    self.bottom:add(TileStones30(x, y, subtype))
                elseif type == 2 then
                    self.middle:add(TileBushesBig(x, y, subtype))
                elseif type == 3 then
                    self.middle:add(TileBushesBananas(x, y, subtype))
                elseif type == 4 then
                    self.middle:add(TileTelegaBricks(x, y, subtype))
                elseif type == 5 then
                    self.middle:add(TileRidge(x, y, subtype))
                elseif type == 6 then
                    self.bottom:add(TileCactusesSmall(x, y, subtype))
                end
            end
        elseif layer == 4 then
            local count = data:i16()

            for i = 1, count do
                local type = data:i8()
                local tile_x = data:i8()
                local tile_y = data:i8()
                local properties = { data:read(16):byte(1, -1) }

                if type == 0 then
                    self.spawners:add(TileSpawnPoint(tile_x, tile_y, properties))
                elseif type == 1 then
                    self.special:add(TileStaticWeapon(tile_x, tile_y, properties))
                elseif type == 2 then
                    self.special:add(TileTrampoline(tile_x, tile_y, properties))
                elseif type == 3 then
                    self.special:add(TileItems(tile_x, tile_y, properties))
                elseif type == 4 then
                    self.special:add(TileFlagBlue(tile_x, tile_y))
                elseif type == 5 then
                    self.special:add(TileFlagRed(tile_x, tile_y))
                elseif type == 6 then
                    print ('death zone', unpack(properties))
                elseif type == 7 then
                    -- print ('trigger\t', 'tile_x = '..tile_x, 'tile_y = '..tile_y, unpack(properties))
                elseif type == 8 then
                    print ('particles', unpack(properties))
                end
            end
        else
            break
        end
    end

    self.bottom:stable_sort(compare_tiles)
    self.top:stable_sort(compare_tiles)
    self.middle:stable_sort(compare_tiles)

    self.unknown = buffer:i32()
	self.track = buffer:i8()
	self.difficulty = buffer:i8()
    self.intro = buffer:i8()
    
    -- collectgarbage 'collect'
end

function Level:getSpawnTile(race)
    return self.spawners:find(Self.equals, race).value
end

local function drawLayer(level, layer, bounds)
    layer:foreach(function(tile)
        if bounds:intersect(tile:boundingRect()) then
            tile:render(level)
        end
    end)
end

function Level:mouseMoveEvent(event)
    if event.drag then
        self.scene.camera:move(event.dx, event.dy)
    end
end

function Level:paintEvent()
    self.scene.camera:beforeRenderEvent()

    local r = self.scene.camera:getRect()

    drawLayer(self, self.ground, r)
    drawLayer(self, self.bottom, r)
    drawLayer(self, self.middle, r)
    drawLayer(self, self.special, r)
    drawLayer(self, self.top, r)
    
    self.scene.camera:afterRenderEvent()
end

function Level:removeTile(tile)
    tile.level_layer:remove(tile)
    tile.level_layer = nil
end

function Level:addTile(layer_name, tile)
    local layer = self[layer_name]

    tile.level_layer = layer
    layer:add(tile)
    layer:stable_sort(compare_tiles)
    
    invoke(tile, 'placeEvent')
end

function Level:updateEvent(dt)
    self.update_tiles:foreach(Self.updateEvent, dt)

    local it = self.special:find(function(tile, player)
        local dx = math.abs(tile.x - player.x)
        local dy = math.abs(tile.y - player.y)
        return dx < 5 and dy < 5
    end, self.scene.player)

    if it then
        local tile = it.value

        if tile:is(TileItems) then
            self.scene:pickup(tile)
            self.special:remove(tile)
        end
    end
end