module()

import 'class'
import 'rect'
import 'ui/element'

local DefaultStyle = require 'ui/default_style'
local Style = DefaultStyle.label

Label = class(UIElement)
function Label:new(text, x, y, w, h, align)
    UIElement.new(self, x, y, w, h)

    self.text = text
    self.font = love.graphics.getFont()
    
    self.align = align or 'center' 
end

function Label:OnDraw()
    local font = self.font or love.graphics.getFont()
    local _, lines = font:getWrap(self.text, self.rect.w)
    local fh = font:getHeight()

    love.graphics.setColor(self:get_text_color())
    love.graphics.printf(self.text, self.rect.x, self.rect.y + (self.rect.h - fh * #lines) / 2, self.rect.w, self.align)
end

function Label:get_text_color()
    return Style.color
end