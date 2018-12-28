import 'class'

BufferStream = class()
function BufferStream:new(data)
    self.data = data
    self.index = 1
end

function BufferStream:i8()
    return self:read(1):byte(1, -1)
end

function BufferStream:i16()
    local b1, b2 = self:read(2):byte(1, -1)
    return b1 * 256 + b2
end

function BufferStream:i32()
    local b1, b2, b3, b4 = self:read(4):byte(1, -1)
    return ((b1 * 256 + b2) * 256 + b3) * 256 + b4
end

function BufferStream:read(size)
    local index = self.index
    self.index = index + size
    return self.data:sub(index, self.index - 1)
end

function BufferStream:__boolean()
    return self.index < self.data:len()
end