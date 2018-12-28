import 'class'
import 'rect'
import 'ui/button'
import 'ui/element'
import 'scene-manager'
import 'event'

local DefaultStyle = require 'ui/default_style'
local Style = DefaultStyle.slider


Slider = class(GraphicsItem)
function Slider:new(parent, x, y, w)
    GraphicsItem.new(self, parent)
    
    self:setXY(x, y)
    self:setSize(w, 10)
    self.thumb = Rect(0, 5, 20, 20)
    self.rect = Rect(x, y, w, 5)
    self.value = 0
    self.onChange = Event()
end

function Slider:get_background_color()
    return Style.normal.color
end

function Slider:get_thumb_color()
    return Style.normal.thumb_color
end

function Slider:paintEvent()
    Button.paintEvent(self)

    love.graphics.setColor(self:get_thumb_color())
    love.graphics.circle('fill', self.thumb.x, self.thumb.y, 10)
end

function Slider:OnMouseDrag(x, y)
    self.thumb.x = math.min(self.w, math.max(0, x))

    local old_value = self.value
    self.value = self.thumb.x / self.w

    if old_value ~= self.value then
        self.onChange:invoke(self)
    end
end