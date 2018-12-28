import 'class'
import 'tiles'
import 'buffer'
import 'list'
import 'rect'
import 'resources'

local function compare_tiles(a, b)
    if a.layer == b.layer then
        if a.y == b.y then
            return a.x < b.x
        end

        return a.y < b.y
    end

    return a.layer < b.layer
end

Level = class()
function Level:load(path)    
    self.ground = List()
    self.bottom = List()
    self.middle = List()
    self.top = List()
    self.special = List()
    self.update_tiles = List()
    self.spawners = List()

    local buffer = BufferStream(Resources:ReadFile(path))

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

    self.bottom:sort(compare_tiles)
    self.top:sort(compare_tiles)
    self.middle:sort(compare_tiles)

    self.unknown = buffer:i32()
	self.track = buffer:i8()
	self.difficulty = buffer:i8()
    self.intro = buffer:i8()
    
    -- collectgarbage 'collect'
end

function Level:getPlayerSpawnTile()
    for i, tile in ipairs(self.spawners) do
        if tile.race == TileSpawnPoint.Race.Pipyaka then
            return tile
        end
    end

    return nil
end

local getScreenWidth = love.graphics.getWidth
local getScreenHeight = love.graphics.getHeight
local function drawLayer(layer, dx, dy)
    local boundingRect = Rect(-dx, -dy, getScreenWidth(), getScreenHeight())
    
    layer:foreach(function(tile)
        if boundingRect:intersect(tile:boundingRect()) then
            tile:render()
        end
    end)
end

function Level:render(dx, dy)
    drawLayer(self.ground, dx, dy)
    drawLayer(self.bottom, dx, dy)
    drawLayer(self.middle, dx, dy)
    drawLayer(self.top, dx, dy)

    -- self:drawLayer(self.spawners)
    -- self:drawLayer(self.special)
end

function Level:update(dt)
    self.update_tiles:foreach(function(tile)
        tile:update(dt)
    end)
end

function Level:addEntity(entity)
    self.middle:add(entity)
    self.update_tiles:add(entity)
end