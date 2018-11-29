module()

import 'class'

List = class()
function List:new()
    self.data = {}
end

function List:get(index)
    assert(index >= 1 and index <= self:size())

    return self.data[index]
end

function List:set(index, element)
    assert(index >= 1 and index <= self:size())
    self.data[index] = element
end

function List:add(element)
    table.insert(self.data, element)
end

function List:contains(element)
    local k, v = self:find(function (v) 
        return rawequal(v, element) 
    end)
    
    return k ~= nil
end

function List:remove(element)
    local k, v = self:find(function (v) 
        return rawequal(v, element) 
    end)

    if k ~= nil then
        table.remove(self.data, k)
    end
end

function List:clear()
    self.data = {}
end

function List:find(predicate)
    for k, v in ipairs(self.data) do
        if predicate(v) then
            return k, v
        end
    end

    return nil, nil
end

function List:sort(predicate)
    table.sort(self.data, predicate)
end

function List:foreach(predicate)
    for k, v in pairs(self.data) do
        predicate(v)
    end
end

function List:removeAt(index)
    assert(index >= 1 and index <= self:size())

    table.remove(self.data, index)
end

function List:size()
    return #self.data
end

function List:__pairs()
    return pairs, self.data, nil
end

function List:__ipairs()
    return pairs, self.data, nil
end

-- list = getmetatable(List())
-- list.__index = List.get
-- list.__newindex = List.set