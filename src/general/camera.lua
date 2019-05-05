import 'general/math/rect'
import 'general/graphics/screen'

Camera = class()
function Camera:new()
    self.x = 0
    self.y = 0
end

function Camera:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

function Camera:getRect()
    return rect(-self.x, -self.y, Screen.width, Screen.height)
end

function Camera:beforeRenderEvent()
    love.graphics.translate(self.x, self.y)
end

function Camera:afterRenderEvent()
    
end

