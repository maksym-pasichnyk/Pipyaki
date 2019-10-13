import 'general/ui/controls/button'
import 'general/ui/controls/label'
import 'general/event/event'
import 'general/scene/scene-manager'

local utf8 = require 'utf8'

local DefaultStyle = require 'general/ui/style/default'
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
    if self.isFocused then
        local key = event.key
        if key == 'backspace' then
            self:removeLast()
            return true
        elseif key == 'escape' then
            if event:single() then
                self.scene:setFocus(nil)
                return true
            end
        end
    end
    return false
end

function TextField:inputTextEvent(event)
    if self.isFocused then
        self:append(event.text)
        return true
    end
    return false
end