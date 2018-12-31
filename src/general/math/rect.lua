rect = class()
function rect:new(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

function rect.contains(a, x, y)
    return x >= a.x and x <= a.x + a.w and y >= a.y and y <= a.y + a.h
end

function rect.intersect(a, b)
    return a.x + a.w > b.x and a.y + a.h > b.y and b.x + b.w > a.x and b.y + b.h > a.y 
end