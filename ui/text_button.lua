module()

import 'class'
import 'ui/button'
import 'ui/label'

local DefaultStyle = require 'ui/default_style'
local Style = DefaultStyle.button

TextButton = class(Button)
function TextButton:new(text, x, y, w, h)
    Button.new(self, x, y, w, h)
    
    self.text = text
    self.align = 'center'
end

function TextButton:OnDraw()
    Button.OnDraw(self)
    Label.OnDraw(self)
end

function TextButton:get_text_color()
    if self.isPressed then
        return Style.pressed.text_color
    elseif self.isMouseOver then
        return Style.hover.text_color
    else
        return Style.normal.text_color
    end
end