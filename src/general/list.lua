local max_chunk_size = 72

local function insertion_sort(list, first, last, predicate)
    for i = first + 1, last do
        local k = first
        local v = list[i]
        for j = i, first + 1, -1 do
            if predicate(v, list[j-1]) then
                list[j] = list[j-1]
            else
                k = j
                break
            end
        end
        list[k] = v
    end
end

local function merge(list, workspace, low, middle, high, predicate)
    local i, j, k
    i = 1
    for j = low, middle do
        workspace[i] = list[j]
        i = i + 1
    end
    i = 1
    j = middle + 1
    k = low
    while true do
        if (k >= j) or (j > high) then
            break
        end
        if predicate(list[j], workspace[i]) then
            list[k] = list[j]
            j = j + 1
        else
            list[k] = workspace[i]
            i = i + 1
        end
        k = k + 1
    end

    for k = k, j-1 do
        list[k] = workspace[i]
        i = i + 1
    end
end

local function merge_sort(list, workspace, low, high, predicate)
    if high - low < max_chunk_size then
        insertion_sort(list, low, high, predicate)
    else
        local middle = math.floor((low + high)/2)
        merge_sort(list, workspace, low, middle, predicate)
        merge_sort(list, workspace, middle + 1, high, predicate)
        merge(list, workspace, low, middle, high, predicate)
    end
end

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
    for i = 1, self.__size do
        if rawequal(self.__data[i], value) then
            return true
        end
    end
    return false
end

function List:remove(value)
    for i = 1, self.__size do
        if rawequal(self.__data[i], value) then
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

function List:find(predicate, ...)
    for i = 1, self.__size do
        local v = self.__data[i]
        if predicate(v, ...) then
            return { key = i, value = v }
        end
    end
end

function List:sort(predicate)
    table.sort(self.__data, predicate)
end

function List:stable_sort(predicate)
    if self.__size < 2 then 
        table.sort(self.__data, predicate)
    end

    local workspace = {}
    workspace[math.floor((self.__size + 1) / 2)] = self.__data[1]
    merge_sort(self.__data, workspace, 1, self.__size, predicate)
end

function List:foreach(predicate, ...)
    for i = 1, self.__size do
        if rawequal(predicate(self.__data[i], ...), true) then
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
    local size = self.__size
    local i = 0
    return function()
        i = i + 1
        if i <= size then
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