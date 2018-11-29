module()

local Class = {}
Class.__index = Class

function Class:__call(...)
    local this = setmetatable({}, self)
    invoke(this, 'new', ...)
    return this
end

function Class:is(T)
    local mt = getmetatable(self)
    while mt do
        if mt == T then
            return true
        end

        mt = getmetatable(mt)
    end
    return false
end

function class(base)
    if base then
        assert(base:is(Class))
    end

    local class = {}
    class.__call = Class.__call
    class.__index = class

    return setmetatable(class, base or Class)
end