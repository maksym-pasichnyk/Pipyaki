module()

import 'class'
import 'rect'
import 'input'
import 'event'
import 'scene_manager'

import 'ui/element'

local DefaultStyle = require 'ui/default_style'
local Style = DefaultStyle.button

Button = class(UIElement)
function Button:new(x, y, w, h)
    UIElement.new(self, x, y, w, h)
    self.onClick = Event()
end

function Button:OnDraw()
    love.graphics.setColor(self:get_background_color())
    love.graphics.rectangle('fill', self.rect.x, self.rect.y, self.rect.w, self.rect.h, 4, 4)    
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

function Button:OnUpdate(dt)

end

function Button:OnClick(x, y)
    self.onClick:invoke(self, x, y)
end