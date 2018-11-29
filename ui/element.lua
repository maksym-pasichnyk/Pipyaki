module()

import 'class'
import 'rect'
import 'list'
import 'ui/container'

UIElement = class(UIContainer)
function UIElement:new(x, y, w, h)
    UIContainer.new(self)

    self.visible = true
    self.enabled = true
    self.isDirty = false

    self.x = x or 0
    self.y = y or 0
    self.w = w or 0
    self.h = h or 0
    self.anchorX = 0
    self.anchorY = 0
    self.rect = Rect(self.x, self.y, self.w, self.h)
end

function UIElement:setData(data)
    self.data = data
end

function UIElement:setAnchor(x, y)
    self.anchorX = x
    self.anchorY = y
    self.isDirty = true
end

function UIElement:getAnchor()
    return self.anchorX, self.anchorY
end

function UIElement:setAnchorX(x)
    self.anchorX = x
    self.isDirty = true
end

function UIElement:getAnchorX()
    return self.anchorX
end

function UIElement:setAnchorY(y)
    self.anchorY = y
    self.isDirty = true
end

function UIElement:getAnchorY()
    return self.anchorY
end

function UIElement:setXY(x, y)
    if self.x ~= x or self.y ~= y then
        self.isDirty = true
    end
    
    self.x = x
    self.y = y
end

function UIElement:getXY()
    return self.x, self.y
end

function UIElement:setX(x)
    if self.x ~= x then
        self.x = x
        self.isDirty = true
    end
end

function UIElement:getX()
    return self.x
end

function UIElement:setY(y)
    if self.y ~= y then
        self.y = y
        self.isDirty = true
    end
end

function UIElement:getY()
    return self.y
end

function UIElement:setSize(width, height)
    self.w = width
    self.h = height
    self.isDirty = true
end

function UIElement:getSize()
    return self.w, self.h
end

function UIElement:setWidth(width)
    self.w = width
    self.isDirty = true
end

function UIElement:getWidth()
    return self.w
end

function UIElement:setHeight(height)
    self.h = height
    self.isDirty = true
end

function UIElement:getHeight()
    return self.h
end

function UIElement:localToGlobal(x, y)
    x = (x or 0) + self.x
    y = (y or 0) + self.y

    if self.parent then
        x, y = self.parent:localToGlobal(x, y)
    end

    return x, y
end

function UIElement:globalToLocal(x, y)
    x = (x or 0) - self.x
    y = (y or 0) - self.y

    if self.parent then
        x, y = self.parent:globalToLocal(x, y)
    end

    return x, y
end

function UIElement:OnValidate()
    local x, y = self:localToGlobal()

    local rect = self.rect
    rect.x = x - self.w * self.anchorX
    rect.y = y - self.h * self.anchorY
    rect.w = self.w
    rect.h = self.h

    self.elements:foreach(function(element)
        element:OnValidate()
    end)
end

function UIElement:hit(x, y)
    if self.rect:contains(x, y) then
        return UIContainer.hit(self, x, y) or self
    end

    return nil
end

local getScissor = love.graphics.getScissor
local setScissor = love.graphics.setScissor
local intersectScissor = love.graphics.intersectScissor
function UIElement:draw()
    if self.enabled then
        local r, g, b, a = love.graphics.getColor()
        invoke(self, 'OnDraw')
        love.graphics.setColor(r, g, b, a)

        local ox, oy, ow, oh = getScissor()
        intersectScissor(self.rect.x, self.rect.y, self.rect.w, self.rect.h)

        UIContainer.draw(self)

        setScissor(ox, oy, ow, oh)
    end
end

function UIElement:update(dt)
    if self.enabled then
        if self.isDirty then
            self:OnValidate()
            self.isDirty = false
        end

        invoke(self, 'OnUpdate', dt)

        UIContainer.update(self, dt)
    end
end

function UIElement:reset()
    self.isPressed = false
    self.isMouseOver = false
    self.isFocused = false
end
