import 'general/ui/graphics-item'
import 'general/event/event'
import 'general/math/rect'

local DefaultStyle = require 'general/ui/style/default'
local Style = DefaultStyle.slider

Slider = class(GraphicsItem)
function Slider:new(parent, x, y, w)
    GraphicsItem.new(self, parent)
    
    self:setXY(x, y)
    self:setSize(w, 10)
    self.thumb = rect(0, 5, 20, 20)
    self.rect = rect(x, y, w, 5)
    self.value = 0
    self.onChange = Event()
end

function Slider:boundingRect()
    return rect(self.x - 10, self.y - 5, self.w + 20, 20)
end

function Slider:paintEvent()
    love.graphics.setColor(Style.normal.color)
    love.graphics.rectangle('fill', 0, 0, self.w, self.h, 4, 4)  

    love.graphics.setColor(Style.normal.thumb_color)
    love.graphics.circle('fill', self.thumb.x, self.thumb.y, 10)
end

function Slider:setValue(value)
    value = math.min(math.max(0, value), 1)

    if value ~= self.value then
        self.value = value
        self.thumb.x = self.w * value

        self.onChange:invoke(self)
    end
end

function Slider:mousePressEvent(event)
    GraphicsItem.mouseMoveEvent(self, event)

    if event.accepted then
        return
    end

    event:accept()

    local x = self:mapFromScene(event.x, 0)
    self:setValue(math.min(self.w, math.max(0, x)) / self.w)
end

function Slider:mouseMoveEvent(event)
    if self.isDragging then
        event:accept()

        local x = self:mapFromScene(event.x, 0)
        self:setValue(math.min(self.w, math.max(0, x)) / self.w)
    end
end