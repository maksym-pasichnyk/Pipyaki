module()

import 'class'
import 'ui/button'
import 'ui/label'
import 'event'

local utf8 = require 'utf8'

local DefaultStyle = require 'ui/default_style'
local Style = DefaultStyle.text_field

TextField = class(Label)
function TextField:new(text, hint, x, y, w, h)
    Label.new(self, text, x, y, w, h, 'left')

    self.hint = hint
    self.onEdit = Event()
end

function TextField:OnDraw()
    Button.OnDraw(self)
    Label.OnDraw(self)
end

function TextField:get_background_color()
    if self.isFocused then
        return Style.focused.color
    else
        return Style.normal.color
    end
end

function TextField:get_text_color()
    if self.isFocused then
        return Style.focused.text_color
    else
        return Style.normal.text_color
    end
end

function TextField:OnKeyDown(key, scancode, isrepeat)
    if key == 'backspace' then
        local offset = utf8.offset(self.text, -1)
        if offset then
            self.text = self.text:sub(1, offset - 1)

            self.onEdit:invoke(self)    
        end
    end
end

function TextField:OnTextInput(text)
    self.text = self.text..text

    self.onEdit:invoke(self)
end