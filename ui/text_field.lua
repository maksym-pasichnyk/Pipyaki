import 'class'
import 'ui/button'
import 'ui/label'
import 'event'
import 'scene-manager'

local utf8 = require 'utf8'

local DefaultStyle = require 'ui/default_style'
local Style = DefaultStyle.text_field

TextField = class(Label)
function TextField:new(parent, text, hint, x, y, w, h)
    Label.new(self, parent, text, x, y, w, h, 'left')

    self.clip = true
    self.hint = hint
    self.onEdit = Event()
end

function TextField:paintEvent()
    Button.paintEvent(self)
    Label.paintEvent(self)
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

function TextField:removeLast()
    local offset = utf8.offset(self.text, -1)
    if offset then
        self.text = self.text:sub(1, offset - 1)

        self.onEdit:invoke(self)    
    end
end

function TextField:append(text)
    self.text = self.text..text
    self.onEdit:invoke(self)
end

function TextField:keyPressEvent(event)
    local key = event.key
    if key == 'backspace' then
        self:removeLast()
        event:accept()
    elseif key == 'escape' then
        if event:single() then
            event:accept()
            getScene():setFocus(nil)
        end
    end
end

function TextField:inputTextEvent(text)
    self:append(text)
end