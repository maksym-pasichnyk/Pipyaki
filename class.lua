local Class = {}

function Class:__index(key)
    local value = rawget(self, key)
        
    if not value then
        for k, base in pairs(self.__bases) do
            value = base[key]

            if value then
                break
            end
        end
    end

    return value
end

function Class:__call(...)
    local this = setmetatable({}, self)
    invoke(this, 'new', ...)
    return this
end

-- function Class:is(T)
--     local mt = getmetatable(self)
--     while mt do
--         if mt == T then
--             return true
--         end

--         mt = getmetatable(mt)
--     end
--     return false
-- end

function class(...)
    local class = {}
    class.__bases = {...}
    class.__index = class
    return setmetatable(class, Class)
end