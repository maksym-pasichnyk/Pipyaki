import 'class'

Rect = class()
function Rect:new(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

function Rect:contains(x, y)
    return x >= self.x and x <= self.x + self.w and y >= self.y and y <= self.y + self.h
end

function Rect:intersect(other)
    return 
        other.x + other.w >  self.x and 
        other.y + other.h >  self.y and 
         self.x +  self.w > other.x and 
         self.y +  self.h > other.y
end