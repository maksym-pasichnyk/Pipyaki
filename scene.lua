import 'class'
import 'list'
import 'ui/element'
import 'ui/container'
import 'timer'

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
    self.timer:update(dt)
end

function Scene:OnMouseDown(x, y, button, istouch)
    local element = self:itemAt(x, y)

    if element then
        self.pressed = element

        element.isPressed = true
        invoke(element, 'OnMouseDown', x, y, button, istouch)
    end

    self:setFocus(element)
end

function Scene:OnMouseUp(x, y, button, istouch, presses)
    local element = self:itemAt(x, y)

    if element and rawequal(self.pressed, element) and element.isPressed then
        invoke(element, 'OnClick', x, y, button, istouch)
        element.isPressed = false
    elseif self.pressed then
        invoke(self.pressed, 'OnMouseUp', x, y, button, istouch)
        self.pressed.isPressed = false
    end

    self.pressed = nil
end

function Scene:OnMouseMove(x, y, dx, dy)
    local element = self:itemAt(x, y)

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

function Scene:OnKeyDown(key, scancode)
    if self.focused then
        invoke(self.focused, 'OnKeyDown', key, scancode)
    end
end

function Scene:OnKeyRepeat(key, scancode)
    if self.focused then
        invoke(self.focused, 'OnKeyRepeat', key, scancode)
    end
end

function Scene:OnKeyUp(key)
    if self.focused then
        invoke(self.focused, 'OnKeyUp', key)
    end
end

function Scene:OnTextInput(text)
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