module()

import 'class'
import 'ui/button'
import 'event'
import 'scene_manager'

Checkbox = class(Button)
function Checkbox:new(x, y)
    Button.new(self, x, y, 30, 30)

    self.value = false
    self.onToggle = Event()
end

function Checkbox:OnDraw()
    love.graphics.setColor(self:get_background_color())
    love.graphics.rectangle('line', self.rect.x, self.rect.y, self.rect.w, self.rect.h, 4, 4)  

    if self.value then
        love.graphics.setColor(self:get_thumb_color())
        love.graphics.rectangle('fill', self.rect.x + 5, self.rect.y + 5, 20, 20, 4, 4)        
    end
end

function Checkbox:get_thumb_color()
    return {200/255, 200/255, 200/255}
end

function Checkbox:OnClick()
    self.value = not self.value

    self.onToggle:invoke(self)
end