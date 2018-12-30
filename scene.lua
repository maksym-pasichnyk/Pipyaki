import 'class'
import 'list'
import 'ui/element'
import 'ui/container'
import 'timer'

local input = module.load 'input'
local InputEvent = input.InputEvent
local KeyEvent = input.KeyEvent
local MouseEvent = input.MouseEvent

Scene = class(GraphicsScene)
function Scene:new()
    GraphicsScene.new(self)
    self.timer = Timer()
end

function Scene:destroy()

end

function Scene:enter()
    self:reset()
end

function Scene:exit()

end

function Scene:update(dt)
    GraphicsScene.update(self, dt)
    self.timer:update(dt)
end

function Scene:mousepressed(x, y, button, istouch)
    self:mousePressEvent(MouseEvent(x, y, button))

    if self.focused and not self.focused:contains(x, y) then
        self:setFocus(nil)
    end
end

function Scene:mousereleased(x, y, button, istouch, presses)
    self:mouseReleaseEvent(MouseEvent(x, y, button))
end

function Scene:mousemoved(x, y, dx, dy)
    local element = self:itemAt(x, y)

    if not rawequal(self.hovered, element) then
        if self.hovered then
            self.hovered:mouseLeaveEvent()
        end

        self.hovered = element

        if self.hovered then
            self.hovered:mouseEnterEvent()
        end
    end

    self:mouseMoveEvent(InputEvent { x = x, y = y, dx = dx, dy = dy })
end

function Scene:keypressed(key, scancode, isrepeat)
    self:keyPressEvent(KeyEvent(key, scancode, '', isrepeat))
end

function Scene:keyreleased(key, scancode)
    self:keyReleaseEvent(KeyEvent(key, scancode, '', false))
end

function Scene:textinput(text)
    self:inputTextEvent(InputEvent { text = text })
end

function Scene:joystickpressed(joystick, button)
    self:joystickPressEvent(InputEvent { joystick = joystick, button = button })
end

function Scene:joystickreleased(joystick, button)
    self:joystickReleaseEvent(InputEvent { joystick = joystick, button = button })
end

function Scene:joystickaxis(joystick, axis, value)
    self:joystickAxisEvent(InputEvent { joystick = joystick, axis = axis, value = value })
end

function Scene:joystickhat(joystick, hat, direction)
    self:joystickHatEvent(InputEvent { joystick = joystick, hat = hat, direction = direction })
end

function Scene:setFocus(element)
    if rawequal(self.focused, element) then
        return
    end

    if self.focused then
        self.focused:lostFocusEvent()
    end

    self.focused = element

    if self.focused then
        self.focused:gainFocusEvent()
    end
end