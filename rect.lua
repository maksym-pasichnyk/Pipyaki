module()

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