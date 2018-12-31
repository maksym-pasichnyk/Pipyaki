local __pairs = pairs
function pairs(self)
    return (self.__pairs or __pairs)(self)
end

local __ipairs = ipairs
function ipairs(self)
    return (self.__ipairs or __ipairs)(self)
end