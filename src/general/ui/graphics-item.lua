import 'general/math/rect'
import 'general/list'
import 'general/invoke'

GraphicsItem = class()
function GraphicsItem:new(parent)
    self.childs = List()

    self.visible = true
    self.enabled = true
    self.active = true
    self.ignore_self_touches = true
    self.x = 0
    self.y = 0
    self.w = 0
    self.h = 0
    
    self:setParent(parent)
end

function GraphicsItem:itemAt(x, y)
    if self.enabled then
        local contains = self:boundingRect():contains(x, y)

        if not self.clip or contains then
            for i = self.childs.__size, 1, -1 do
                local obj = self.childs.__data[i]:itemAt(self.x + x, self.y + y)

                if obj then
                    return obj
                end
            end

            if contains then
                return self
            end
        end
    end
end

function GraphicsItem:boundingRect()
    return rect(self.x, self.y, self.w, self.h)
end

function GraphicsItem:setParent(parent)
    if self.parent then
        self.parent.childs:remove(self)
    end

    self.parent = parent

    if self.parent then
        self.parent.childs:add(self)
    end
end

function GraphicsItem:setClip(clip)
    self.clip = clip
end

function GraphicsItem:setXY(x, y)
    self.x = x
    self.y = y
end

function GraphicsItem:getXY()
    return self.x, self.y
end

function GraphicsItem:setX(x)
    self.x = x
end

function GraphicsItem:getX()
    return self.x
end

function GraphicsItem:setY(y)
    self.y = y
end

function GraphicsItem:getY()
    return self.y
end

function GraphicsItem:setSize(w, h)
    self.w = w
    self.h = h
end

function GraphicsItem:getSize()
    return self.w, self.h
end

function GraphicsItem:setWidth(w)
    self.w = w
end

function GraphicsItem:getWidth()
    return self.w
end

function GraphicsItem:setHeight(h)
    self.h = h
end

function GraphicsItem:getHeight()
    return self.h
end

function GraphicsItem:mapToScene(x, y)
    x = (x or 0) + self.x
    y = (y or 0) + self.y

    if self.parent then
        x, y = self.parent:mapToScene(x, y)
    end

    return x, y
end

function GraphicsItem:mapFromScene(x, y)
    x = (x or 0) - self.x
    y = (y or 0) - self.y

    if self.parent then
        x, y = self.parent:mapFromScene(x, y)
    end

    return x, y
end

local getScissor = love.graphics.getScissor
local setScissor = love.graphics.setScissor
local intersectScissor = love.graphics.intersectScissor
function GraphicsItem:render()
    if self.enabled and self.visible then
        local scissors = { getScissor() }

        local boundingRect = self:boundingRect()
        local clip = self.clip
        if clip then
            intersectScissor(boundingRect.x, boundingRect.y, boundingRect.w, boundingRect.h)
        end
        local color = { love.graphics.getColor() }

        love.graphics.push()
        love.graphics.translate(self.x, self.y)
        invoke(self, 'paintEvent')
        love.graphics.setColor(color)

        self.childs:foreach(function(child)
            if not clip or boundingRect:intersect(child:boundingRect()) then
                child:render()
            end
        end)
        invoke(self, 'paintAfterChilds')
        love.graphics.setColor(color)
        love.graphics.pop()

        if clip then
            setScissor(unpack(scissors))
        end
    end
end

function GraphicsItem:resize(w, h)
    invoke(self, 'resizeEvent', w, h)
        
    self.childs:foreach(function(child)
        if child:active_and_enabled() then
            child:resize(w, h)
        end
    end)
end

function GraphicsItem:update(dt)
    invoke(self, 'updateEvent', dt)
        
    self.childs:foreach(function(child)
        if child:active_and_enabled() then
            child:update(dt)
        end
    end)
end

function GraphicsItem:reset()
    self.isPressed   = false
    self.isMouseOver = false
    self.isFocused   = false

    for i = self.childs.__size, 1, -1 do
        self.childs.__data[i]:reset()
    end
end

function GraphicsItem:active_and_enabled()
    return self.enabled and self.active
end

function GraphicsItem:contains(x, y)
    return self:boundingRect():contains(x, y)
end

function GraphicsItem:mousePressEvent(event)
    local x, y = self:mapFromScene(event.x, event.y)
    for i = self.childs.__size, 1, -1 do
        local child = self.childs.__data[i]
        if child:active_and_enabled() and child:contains(x, y) then
            if child:mousePressEvent(event) then
                return true
            end
        end
    end

    if self.ignore_self_touches then
        return false
    end

    event.target = self
    return true
end

function GraphicsItem:mouseReleaseEvent(event)

end

function GraphicsItem:mouseMoveEvent(event)
    for i = self.childs.__size, 1, -1 do
        local child = self.childs.__data[i]
        if child:active_and_enabled() and child:contains(event.x, event.y) then
            if child:mouseMoveEvent(event) then
                return true
            end
        end
    end
    return false
end

function GraphicsItem:mouseEnterEvent()
        
end

function GraphicsItem:mouseLeaveEvent()
        
end

function GraphicsItem:keyPressEvent(event)
    for i = self.childs.__size, 1, -1 do
        local child = self.childs.__data[i]
        if child:active_and_enabled() then
            if child:keyPressEvent(event) then
                return true
            end
        end
    end
    return false
end

function GraphicsItem:keyReleaseEvent(event)
    for i = self.childs.__size, 1, -1 do
        local child = self.childs.__data[i]
        if child:active_and_enabled() then
            if child:keyReleaseEvent(event) then
                return true
            end
        end
    end
    return false
end

function GraphicsItem:inputTextEvent(event)
    for i = self.childs.__size, 1, -1 do
        local child = self.childs.__data[i]
        if child:active_and_enabled() then
            if child:inputTextEvent(event) then
                return true
            end
        end
    end
    return false
end

function GraphicsItem:joystickPressEvent(event)
    for i = self.childs.__size, 1, -1 do
        local child = self.childs.__data[i]
        if child:active_and_enabled() then
            if child:joystickPressEvent(event) then
                return true
            end
        end
    end
    return false
end

function GraphicsItem:joystickReleaseEvent(event)
    for i = self.childs.__size, 1, -1 do
        local child = self.childs.__data[i]
        if child:active_and_enabled() then
            if child:joystickReleaseEvent(event) then
                return true
            end
        end
    end
    return false
end

function GraphicsItem:joystickAxisEvent(event)
    for i = self.childs.__size, 1, -1 do
        local child = self.childs.__data[i]
        if child:active_and_enabled() then
            if child:joystickAxisEvent(event) then
                return true
            end
        end
    end
    return false
end

function GraphicsItem:joystickHatEvent(event)
    for i = self.childs.__size, 1, -1 do
        local child = self.childs.__data[i]
        if child:active_and_enabled() then
            if child:joystickHatEvent(event) then
                return true
            end
        end
    end
    return false
end

function GraphicsItem:lostFocusEvent()

end

function GraphicsItem:gainFocusEvent()
end