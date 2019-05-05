return setmetatable({}, {
    __newindex = function(key, value) end,
    __index = function(_, key)
        return function(self, ...)
            return self[key](self, ...)
        end
    end
})