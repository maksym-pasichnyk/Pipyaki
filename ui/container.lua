import 'class'
import 'list'
import 'rect'
import 'ui/element'

GraphicsScene = class()
function GraphicsScene:new()
    self.childs = List()
end

function GraphicsScene:itemAt(x, y)
    for i = self.childs:size(), 1, -1 do
        local obj = self.childs:get(i):itemAt(x, y)
        
        if obj then
            return obj
        end
    end
end

function GraphicsScene:add(child)
    -- assert(child:is(GraphicsItem) and rawequal(child.scene, nil))
    child.scene = self
    self.childs:add(child)
    return child
end

function GraphicsScene:remove(child)
    -- assert(child:is(GraphicsItem) and rawequal(child.scene, self))
    child.scene = nil
    self.childs:remove(child)
end

local getScreenWidth = love.graphics.getWidth
local getScreenHeight = love.graphics.getHeight

function GraphicsScene:render()
    local boundingRect = Rect(0, 0, getScreenWidth(), getScreenHeight())
    
    self.childs:foreach(function(child)
        if boundingRect:intersect(child:boundingRect()) then
            child:render()
        end
    end)
end

function GraphicsScene:update(dt)
    self.childs:foreach(function(child)
        child:update(dt)
    end)
end