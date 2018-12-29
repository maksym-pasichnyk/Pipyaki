import 'class'

List = class()
function List:new()
    self.data = {}
end

function List:get(index)
    assert(index >= 1 and index <= self:size())

    return self.data[index]
end

function List:first()
    return self:get(1)
end

function List:back()
    return self:get(self:size())
end

function List:pop_back()
    assert(not self:empty())
    table.remove(self.data)
end

function List:set(index, element)
    assert(index >= 1 and index <= self:size())
    self.data[index] = element
end

function List:add(element)
    table.insert(self.data, element)
end

function List:contains(element)
    for k, v in ipairs(self.data) do
        if rawequal(v, element) then
            return true
        end
    end
    return false
end

function List:remove(element)
    for k, v in ipairs(self.data) do
        if rawequal(v, element) then
            table.remove(self.data, k)
            return
        end
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
end

function List:sort(predicate)
    table.sort(self.data, predicate)
end

function List:foreach(predicate, ...)
    for k, v in pairs(self.data) do
        predicate(v, ...)
    end
end

function List:erase(index)
    assert(index >= 1 and index <= self:size())
    table.remove(self.data, index)
end

function List:size()
    return #self.data
end

function List:empty()
    return #self.data == 0
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