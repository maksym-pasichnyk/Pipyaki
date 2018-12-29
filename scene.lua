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
    pcall(GraphicsItem.reset, self.pressed)
    pcall(GraphicsItem.reset, self.hovered)
    pcall(GraphicsItem.reset, self.focused)

    self.pressed = nil
    self.hovered = nil
    self.focused = nil
end

function Scene:exit()

end

function Scene:update(dt)
    GraphicsScene.update(self, dt)
    self.timer:update(dt)
end

function Scene:mousepressed(x, y, button, istouch)
    local event = MouseEvent(x, y, button)

    local element = self:itemAt(x, y)
    if element then
        self.pressed = element
        
        element.isPressed = true
        element:mousePressEvent(event)
    end
    self:setFocus(element)
    self:mousePressEvent(event)
    return event.accepted
end

function Scene:mousereleased(x, y, button, istouch, presses)
    local event = MouseEvent(x, y, button)

    local element = self:itemAt(x, y)

    if element and rawequal(self.pressed, element) and element.isPressed then
        element:mouseClickEvent(event)
        element.isPressed = false
    elseif self.pressed then
        self.pressed:mouseReleaseEvent(event)
        self.pressed.isPressed = false
    end
    self.pressed = nil
    self:mouseReleaseEvent(event)
    return event.accepted
end

function Scene:mousemoved(x, y, dx, dy)
    local element = self:itemAt(x, y)

    if not rawequal(self.hovered, element) then
        if self.hovered then
            self.hovered.isPressed = false
            self.hovered.isMouseOver = false
            invoke(self.hovered, 'mouseLeaveEvent')
        end

        self.hovered = element

        if self.hovered then
            self.hovered.isMouseOver = true
            invoke(self.hovered, 'mouseEnterEvent')
        end
    end

    local event = InputEvent()
    event.x = x
    event.y = y
    event.dx = dx
    event.dy = dy
    event.drag = false

    if self.pressed then
        event.drag = true
        self.pressed:mouseMoveEvent(event)
        event.drag = false
    elseif self.hovered then
        self.hovered:mouseMoveEvent(event)
    end
    self:mouseMoveEvent(event)
    return event.accepted
end

function Scene:keypressed(key, scancode, isrepeat)
    local event = KeyEvent(key, scancode, '', isrepeat)

    if self.focused then
        self.focused:keyPressEvent(event)
    end
    self:keyPressEvent(event)
    return event.accepted
end

function Scene:keyreleased(key, scancode)
    local event = KeyEvent(key, scancode, '', false)

    if self.focused then
        self.focused:keyReleaseEvent(event)
    end
    self:keyReleaseEvent(event)
    return event.accepted
end

function Scene:textinput(text)
    if self.focused then
        invoke(self.focused, 'inputTextEvent', text)
    end
end

function Scene:setFocus(element)
    if rawequal(self.focused, element) then
        return
    end

    if self.focused then
        self.focused.isFocused = false
        invoke(self.focused, 'lostFocusEvent')
    end

    self.focused = element

    if self.focused then
        self.focused.isFocused = true
        invoke(self.focused, 'gainFocusEvent')
    end
end