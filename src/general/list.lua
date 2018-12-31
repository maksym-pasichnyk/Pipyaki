List = class()
function List:new()
    self.__data = {}
    self.__size = 0
end

function List:get(index)
    assert(index >= 1 and index <= self.__size)
    return self.__data[index]
end

function List:first()
    return List.get(self, 1)
end

function List:back()
    return List.get(self, self.__size)
end

function List:pop_back()
    assert(self.__size > 0)
    table.remove(self.__data)
    self.__size = self.__size - 1
end

function List:set(index, value)
    assert(index >= 1 and index <= self.__size)
    self.__data[index] = value
end

function List:add(value)
    table.insert(self.__data, value)
    self.__size = self.__size + 1
end

function List:contains(value)
    for k, v in List.__iterator(self) do
        if rawequal(v, value) then
            return true
        end
    end
    return false
end

function List:remove(value)
    for i, v in List.__iterator(self) do
        if rawequal(v, value) then
            table.remove(self.__data, i)
            self.__size = self.__size - 1
            return
        end
    end
end

function List:clear()
    self.__data = {}
    self.__size = 0
end

function List:find(predicate)
    for i, v in List.__iterator(self) do
        if predicate(v) then
            return i, v
        end
    end
end

function List:sort(predicate)
    table.sort(self.__data, predicate)
end

function List:foreach(predicate, ...)
    for i, v in List.__iterator(self) do
        if rawequal(predicate(v, ...), true) then
            break
        end
    end
end

function List:erase(index)
    assert(index >= 1 and index <= self.__size)
    table.remove(self.__data, index)
end

function List:size()
    return self.__size
end

function List:empty()
    return self.__size == 0
end

function List:__iterator()
    local data = self.__data
    local i = 0
    return function()
        i = i + 1
        if i <= self.__size then
            return i, data[i]
        end
    end
end

function List:__pairs()
    return List.__iterator(self)
end

function List:__ipairs()
    return List.__iterator(self)
end