import 'general/ui/graphics-item'
import 'general/event/event'

local DefaultStyle = require 'general/ui/style/default'
local Style = DefaultStyle.button

Button = class(GraphicsItem)
function Button:new(parent, x, y, w, h)
    GraphicsItem.new(self, parent)
    self:setXY(x, y)
    self:setSize(w, h)
    self.onClick = Event()
    self.ignore_self_touches = false
end

function Button:get_background_color()
    if self.isPressed then
        return Style.pressed.color
    elseif self.isMouseOver then
        return Style.hover.color
    else
        return Style.normal.color
    end
end

function Button:paintEvent()
    love.graphics.setColor(self:get_background_color())
    love.graphics.rectangle('fill', 0, 0, self.w, self.h, 4, 4)
end

function Button:updateEvent(dt)

end

function Button:mouseReleaseEvent(event)
    if event.click then 
        self.onClick:invoke(self, event.x, event.y)
    end
end