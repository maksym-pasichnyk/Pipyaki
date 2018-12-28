import 'class'
import 'rect'
import 'list'

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

function GraphicsItem:boundingRect()
    return Rect(self.x, self.y, self.w, self.h)
end

function GraphicsItem:setParent(parent)
    -- assert(not parent or parent:is(GraphicsItem))

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

function GraphicsItem:update(dt)
    if self.enabled and self.active then
        invoke(self, 'updateEvent', dt)
        
        self.childs:foreach(function(child)
            child:update(dt)
        end)
    end
end

function GraphicsItem:reset()
    self.isPressed = false
    self.isMouseOver = false
    self.isFocused = false
end
