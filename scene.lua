module()

import 'class'
import 'list'
import 'ui/element'
import 'ui/container'

Scene = class(UIContainer)
function Scene:new()
    UIContainer.new(self)
end

function Scene:destroy()

end

function Scene:enter()
    pcall(UIElement.reset, self.pressed)
    pcall(UIElement.reset, self.hovered)
    pcall(UIElement.reset, self.focused)

    self.pressed = nil
    self.hovered = nil
    self.focused = nil
end

function Scene:exit()

end

function Scene:mousepressed(x, y, button, istouch)
    local element = self:hit(x, y)

    if element then
        self.pressed = element

        element.isPressed = true
        invoke(element, 'OnMouseDown', x, y, button, istouch)
    end

    self:setFocus(element)
end

function Scene:mousereleased(x, y, button, istouch, presses)
    local element = self:hit(x, y)

    if element and rawequal(self.pressed, element) and element.isPressed then
        invoke(element, 'OnClick', x, y, button, istouch)
        element.isPressed = false
    elseif self.pressed then
        invoke(self.pressed, 'OnMouseUp', x, y, button, istouch)
        self.pressed.isPressed = false
    end

    self.pressed = nil
end

function Scene:mousemoved(x, y, dx, dy)
    local element = self:hit(x, y)

    if not rawequal(self.hovered, element) then
        if self.hovered then
            self.hovered.isPressed = false
            self.hovered.isMouseOver = false
            invoke(self.hovered, 'OnMouseLeave')
        end

        self.hovered = element

        if self.hovered then
            self.hovered.isMouseOver = true
            invoke(self.hovered, 'OnMouseEnter')
        end
    end

    if self.pressed then
        invoke(self.pressed, 'OnMouseDrag', x, y, dx, dy)
    elseif self.hovered then
        invoke(self.hovered, 'OnMouseMove', x, y, dx, dy)
    end
end

function Scene:keypressed(key, scancode, isrepeat)
    if self.focused then
        invoke(self.focused, 'OnKeyDown', key, scancode, isrepeat)
    end
end

function Scene:keyreleased(key)
    if self.focused then
        invoke(self.focused, 'OnKeyUp', key)
    end
end

function Scene:textinput(text)
    if self.focused then
        invoke(self.focused, 'OnTextInput', text)
    end
end

function Scene:setFocus(element)
    if rawequal(self.focused, element) then
        return
    end

    if self.focused then
        self.focused.isFocused = false
        invoke(self.focused, 'OnLostFocus')
    end

    self.focused = element

    if self.focused then
        self.focused.isFocused = true
        invoke(self.focused, 'OnGainFocus')
    end
end