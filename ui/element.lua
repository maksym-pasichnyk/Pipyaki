import 'class'
import 'rect'
import 'list'
import 'scene-manager'

GraphicsItem = class()
function GraphicsItem:new(parent)
    self.childs = List()

    self.visible = true
    self.enabled = true
    self.active = true

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
            for i = self.childs:size(), 1, -1 do
                local obj = self.childs:get(i):itemAt(x, y)

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
    return Rect(self.x, self.y, self.w, self.h)
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
        love.graphics.pop()

        love.graphics.setColor(color)

        self.childs:foreach(function(child)
            if not clip or boundingRect:intersect(child:boundingRect()) then
                child:render()
            end
        end)

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

    for i = self.childs:size(), 1, -1 do
        self.childs:get(i):reset()
    end
end

function GraphicsItem:active_and_enabled()
    return self.enabled and self.active
end

function GraphicsItem:contains(x, y)
    return self:boundingRect():contains(x, y)
end

function GraphicsItem:mousePressEvent(event)
    for i = self.childs:size(), 1, -1 do
        local child = self.childs:get(i)
        if child:active_and_enabled() and child:contains(event.x, event.y) then
            child:mousePressEvent(event)
            if event.accepted then
                return
            end
        end
    end

    self.isPressed = true
    self.isDragging = true
end

function GraphicsItem:mouseClickEvent(event)
    
end

function GraphicsItem:mouseReleaseEvent(event)
    local pressed = self.isPressed
    self.isPressed = false
    self.isDragging = false

    for i = self.childs:size(), 1, -1 do
        local child = self.childs:get(i)
        if child:active_and_enabled() and child:contains(event.x, event.y) then
            child:mouseReleaseEvent(event)
            if event.accepted then
                return
            end
        end
    end

    if pressed then
        self:mouseClickEvent(event)
    end
end

function GraphicsItem:mouseMoveEvent(event)
    for i = self.childs:size(), 1, -1 do
        local child = self.childs:get(i)
        if child:active_and_enabled() and child:contains(event.x, event.y) then
            child:mouseMoveEvent(event)
            if event.accepted then
                return
            end
        end
    end
end

function GraphicsItem:mouseLeaveEvent()
    self.isPressed   = false
    self.isMouseOver = false    
end

function GraphicsItem:mouseEnterEvent()
    self.isMouseOver = true    
end

function GraphicsItem:keyPressEvent(event)
    for i = self.childs:size(), 1, -1 do
        local child = self.childs:get(i)
        if child:active_and_enabled() then
            child:keyPressEvent(event)
            if event.accepted then
                return
            end
        end
    end
end

function GraphicsItem:keyReleaseEvent(event)
    for i = self.childs:size(), 1, -1 do
        local child = self.childs:get(i)
        if child:active_and_enabled() then
            child:keyReleaseEvent(event)
            if event.accepted then
                return
            end
        end
    end
end

function GraphicsItem:inputTextEvent(event)
    for i = self.childs:size(), 1, -1 do
        local child = self.childs:get(i)
        if child:active_and_enabled() then
            child:inputTextEvent(event)
            if event.accepted then
                return
            end
        end
    end
end

function GraphicsItem:joystickPressEvent(event)
    for i = self.childs:size(), 1, -1 do
        local child = self.childs:get(i)
        if child:active_and_enabled() then
            child:joystickPressEvent(event)
            if event.accepted then
                return
            end
        end
    end
end

function GraphicsItem:joystickReleaseEvent(event)
    for i = self.childs:size(), 1, -1 do
        local child = self.childs:get(i)
        if child:active_and_enabled() then
            child:joystickReleaseEvent(event)
            if event.accepted then
                return
            end
        end
    end
end

function GraphicsItem:joystickAxisEvent(event)
    for i = self.childs:size(), 1, -1 do
        local child = self.childs:get(i)
        if child:active_and_enabled() then
            child:joystickAxisEvent(event)
            if event.accepted then
                return
            end
        end
    end
end

function GraphicsItem:joystickHatEvent(event)
    for i = self.childs:size(), 1, -1 do
        local child = self.childs:get(i)
        if child:active_and_enabled() then
            child:joystickHatEvent(event)
            if event.accepted then
                return
            end
        end
    end
end

function GraphicsItem:lostFocusEvent()
    self.isFocused = false
end

function GraphicsItem:gainFocusEvent()
    self.isFocused = true
end