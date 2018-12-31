import 'general/ui/graphics-item'
import 'general/graphics/screen'

GraphicsScene = class(GraphicsItem)
function GraphicsScene:new()
    GraphicsItem.new(self)
    self.w = Screen.width
    self.h = Screen.height
end

function GraphicsScene:add(child)
    child.scene = self
    self.childs:add(child)
    return child
end

function GraphicsScene:remove(child)
    child.scene = nil
    self.childs:remove(child)
end

function GraphicsScene:resizeEvent(w, h)
    self.w = w
    self.h = h
end