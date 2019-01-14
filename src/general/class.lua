local Class = {
    __call = function(self, ...)
        local this = setmetatable({}, self)
        local new = this.new
        if new then
            new(this, ...)
        end
        return this
    end
}

return function(base)
    local class = {
        __call = Class.__call
    }
    class.__index = class
    return setmetatable(class, base or Class)
end