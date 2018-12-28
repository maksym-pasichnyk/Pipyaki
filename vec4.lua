import 'class'

vec4 = class()
function vec4:new(x, y, z, w)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    self.w = w or 0
end

function vec4.__add(a, b)
    return vec4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w)
end

function vec4.__sub(a, b)
    return vec4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w)
end

function vec4.__mul(a, b)
    return vec4(a.x * b, a.y * b, a.z * b, a.w * b)
end

function vec4.__div(a, b)
    return vec4(a.x / b, a.y / b, a.z / b, a.w / b)
end

function vec4.dot(a, b)
    return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
end

function vec4:length()
    return math.sqrt(self:dot(self))
end

function vec4:normalized()
    return self / self:length()
end