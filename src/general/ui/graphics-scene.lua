import 'general/ui/graphics-item'
import 'general/graphics/screen'

GraphicsScene = class(GraphicsItem)
function GraphicsScene:new()
    GraphicsItem.new(self)
    self.w = Screen.width
    self.h = Screen.height
end

function GraphicsScene:add(child)
    child:setParent(self)
    return child
end

function GraphicsScene:remove(child)
    child:setParent(nil)
end

function GraphicsScene:resizeEvent(w, h)
    self.w = w
    self.h = h
end