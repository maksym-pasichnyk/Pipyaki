import 'class'
import 'list'
import 'rect'
import 'screen'
import 'ui/element'

GraphicsScene = class()
function GraphicsScene:new()
    self.childs = List()
    self.boundingRect = Rect(0, 0, Screen.width, Screen.height)
end

function GraphicsScene:itemAt(x, y)
    for i = self.childs:size(), 1, -1 do
        local obj = self.childs:get(i):itemAt(x, y)
        
        if obj then
            return obj
        end
    end

    -- return self
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

function GraphicsScene:resize(w, h)
    self.boundingRect = Rect(0, 0, w, h)
    
    invoke(self, 'resizeEvent', w, h)
    self.childs:foreach(function(child)
        child:resize(w, h)
    end)
end

function GraphicsScene:render()
    local color = { love.graphics.getColor() }
    love.graphics.push()
    invoke(self, 'paintEvent')
    love.graphics.pop()
    love.graphics.setColor(color)

    self.childs:foreach(function(child)
        if self.boundingRect:intersect(child:boundingRect()) then
            child:render()
        end
    end)
end

function GraphicsScene:update(dt)
    invoke(self, 'updateEvent', dt)

    self.childs:foreach(function(child)
        child:update(dt)
    end)
end

function GraphicsScene:mousePressEvent(event)
end

function GraphicsScene:mouseClickEvent(event)
end

function GraphicsScene:mouseReleaseEvent(event)
end

function GraphicsScene:mouseMoveEvent(event)
end

function GraphicsScene:keyPressEvent(event)
end

function GraphicsScene:keyReleaseEvent(event)
end