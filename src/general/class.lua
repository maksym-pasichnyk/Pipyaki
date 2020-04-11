local Class = {
    __call = function(self, ...)
        local this = setmetatable({}, self)
        local new = self.new
        if new then
            new(this, ...)
        end
        return this
    end;
    __is = function(self, T)
        local t = self

        while t do
            if rawequal(t, T) then
                return true
            end
            t = getmetatable(t)
        end

        return false
    end
}

return function(base)
    local class = {
        __call = Class.__call,
        is = Class.__is
    }
    class.__index = class
    return setmetatable(class, base or Class)
end