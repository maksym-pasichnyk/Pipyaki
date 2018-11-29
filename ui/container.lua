module()

import 'class'
import 'list'
import 'ui/element'

UIContainer = class()
function UIContainer:new()
    self.elements = List()
end

function UIContainer:OnValidate()
    self.elements:foreach(function(element)
        element:OnValidate()
    end)
end

function UIContainer:hit(x, y)
    for i = self.elements:size(), 1, -1 do
        local element = self.elements:get(i)
        local obj = element:hit(x, y)

        if obj then
            return obj
        end
    end
end

function UIContainer:add(element)
    assert(rawequal(element.parent, nil))

    element.parent = self
    element.isDirty = true

    self.elements:add(element)

    return element
end

function UIContainer:localToGlobal(x, y)
    return x, y
end

function UIContainer:globalToLocal(x, y)
    return x, y
end

function UIContainer:remove(element)
    assert(element:is(UIElement) and rawequal(element.parent, self))

    element.parent = nil
    element.isDirty = true

    self.elements:remove(element)
end

function UIContainer:draw()
    self.elements:foreach(function(element)
        element:draw()
    end)
end

function UIContainer:update(dt)
    self.elements:foreach(function(element)
        element:update(dt)
    end)
end