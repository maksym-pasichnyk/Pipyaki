import 'class'

List = class()
function List:new(data)
    self.data = {}
    if data then
        for i, v in ipairs(data) do
            self.data[i] = v
        end
    end
end

function List:__data()
    return self.data or self
end

function List:get(index)
    assert(index >= 1 and index <= List.size(self))

    return List.__data(self)[index]
end

function List:try_get(index)
    if (index >= 1 and index <= List.size(self)) then
        return List.__data(self)[index]
    end

    return nil
end

function List:first()
    return List.get(self, 1)
end

function List:back()
    return List.get(self, List.size(self))
end

function List:pop_back()
    assert(not List.empty(self))
    local out = List.back(self)
    table.remove(List.__data(self))
    return out
end

function List:set(index, element)
    assert(index >= 1 and index <= List.size(self))
    List.__data(self)[index] = element
end

function List:add(element)
    table.insert(List.__data(self), element)
end

function List:contains(element)
    for k, v in ipairs(List.__data(self)) do
        if rawequal(v, element) then
            return true
        end
    end
    return false
end

function List:remove(element)
    for k, v in ipairs(List.__data(self)) do
        if rawequal(v, element) then
            table.remove(List.__data(self), k)
            return
        end
    end
end

function List:clear()
    local data = List.__data(self)
    for i = 1, #data do
        data[i] = nil
    end
end

function List:find(predicate)
    for i, v in ipairs(List.__data(self)) do
        if predicate(v) then
            return i, v
        end
    end
end

function List:sort(predicate)
    table.sort(List.__data(self), predicate)
end

function List:foreach(predicate, ...)
    for i, v in ipairs(List.__data(self)) do
        predicate(v, ...)
    end
end

function List:erase(index)
    assert(index >= 1 and index <= List.size(self))
    table.remove(List.__data(self), index)
end

function List:size()
    return #List.__data(self)
end

function List:empty()
    return List.size(self) == 0
end

function List:__pairs()
    return pairs, List.__data(self), nil
end

function List:__ipairs()
    return pairs, List.__data(self), nil
end

-- list = getmetatable(List())
-- list.__index = List.get
-- list.__newindex = List.set