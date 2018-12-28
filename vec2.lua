import 'class'

vec2 = class()
function vec2:new(x, y)
    self.x = x or 0
    self.y = y or 0
end

function vec2.__add(a, b)
    return vec2(a.x + b.x, a.y + b.y)
end

function vec2.__sub(a, b)
    return vec2(a.x - b.x, a.y - b.y)
end

function vec2.__mul(a, b)
    return vec2(a.x * b, a.y * b)
end

function vec2.__div(a, b)
    return vec2(a.x / b, a.y / b)
end

function vec2.dot(a, b)
    return a.x * b.x + a.y * b.y
end

function vec2:length()
    return math.sqrt(self:dot(self))
end

function vec2:normalized()
    return self / self:length()
end