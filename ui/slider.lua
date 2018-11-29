module()

import 'class'
import 'rect'
import 'ui/button'
import 'ui/element'
import 'scene_manager'
import 'event'

local DefaultStyle = require 'ui/default_style'
local Style = DefaultStyle.slider


Slider = class(UIElement)
function Slider:new(x, y, w)
    UIElement.new(self, x, y, w, 10)
    self.thumb = Rect(x, y + 5 / 2, 20, 20)
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

function Slider:OnDraw()
    Button.OnDraw(self)

    love.graphics.setColor(self:get_thumb_color())
    love.graphics.circle('fill', self.thumb.x, self.thumb.y, 10)
end

function Slider:OnMouseDrag(x, y)
    self.thumb.x = math.min(self.rect.x + self.rect.w, math.max(self.rect.x, x))

    local old_value = self.value
    self.value = (self.thumb.x - self.rect.x) / self.rect.w

    if old_value ~= self.value then
        self.onChange:invoke(self)
    end
end

function Slider:OnValidate()
    UIElement.OnValidate(self)

    self.thumb.y = self.rect.y + self.rect.h / 2
end