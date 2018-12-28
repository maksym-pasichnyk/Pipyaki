import 'class'
import 'rect'
import 'ui/element'

local DefaultStyle = require 'ui/default_style'
local Style = DefaultStyle.label

Label = class(GraphicsItem)
function Label:new(parent, text, x, y, w, h, align)
    GraphicsItem.new(self, parent)
    self:setXY(x, y)
    self:setSize(w, h)
    self.text = text
    self.font = love.graphics.getFont()
    self.align = align or 'center' 
end

function Label:paintEvent()
    local font = self.font or love.graphics.getFont()
    local _, lines = font:getWrap(self.text, self.w)
    local fh = font:getHeight()

    love.graphics.setColor(self:get_text_color())
    love.graphics.printf(self.text, 0, (self.h - fh * #lines) / 2, self.w, self.align)
end

function Label:get_text_color()
    return Style.color
end