import 'class'
import 'graphics'
import 'ui/element'
import 'screen'

WeaponManager = class(GraphicsItem)
function WeaponManager:new()
    GraphicsItem.new(self)

    self.w = 300
    self.h = 300

    self.x = (Screen.width - self.w) * 0.5
    self.y = (Screen.height - self.h) * 0.5
    
    self.fragswin = Ninepath('menu/fragswin.png', 20, 40, 20, 40, self.w, self.h)
end

function WeaponManager:resizeEvent(w, h)
    self.x = (w - self.w) * 0.5
    self.y = (h - self.h) * 0.5
end

function WeaponManager:paintEvent()
    self.fragswin:render()
end

function WeaponManager:mousePressEvent(event)
    event:accept()
end

function WeaponManager:mouseMoveEvent(event)
    if event.drag then
        event:accept()
    end
end