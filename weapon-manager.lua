import 'class'
import 'graphics'
import 'ui/element'
import 'screen'
import 'sprite'
import 'rect'
import 'vec2'
import 'scene-manager'
import 'screen'

local SPACE = 10

WeaponManager = class(GraphicsItem)
function WeaponManager:new()
    GraphicsItem.new(self)

    self.w = 44 * 5 + 10 * 4 + 10 + 10
    self.h = 300

    self.x = (Screen.width - self.w) * 0.5
    self.y = (Screen.height - self.h) * 0.5
    
    self.fragswin = Ninepath('menu/fragswin.png', 20, 40, 20, 40, self.w, self.h)
    self.weapons = Sprite:Load 'menu/weapons.png'
    self.icons = {}

    local w = self.weapons:getWidth()
    local h = self.weapons:getHeight()

    for i = 0, w / h - 1 do
        table.insert(self.icons, self.weapons:add(Rect(h * i, 0, h, h), vec2(0, 0)))
    end
end

function WeaponManager:resizeEvent(w, h)
    self.x = (w - self.w) * 0.5
    self.y = (h - self.h) * 0.5
end

function WeaponManager:paintEvent()
    self.fragswin:render()

    for i = 0, 25 - 7 do
        local x = (i % 5) * (44 + SPACE) + SPACE
        local y = math.floor(i / 5) * (44 + SPACE) + SPACE

        Sprite.render(self.icons[i + 6], x, y)
    end
end

function WeaponManager:joystickPressEvent(event)
    if event.button == 'b' then
        self.enabled = false
        event:accept()
    end
end

function WeaponManager:keyPressEvent(event)
    if event:single() then
        if event.key == 'escape' then
            self.enabled = false
            event:accept()
        end
    end
end

function WeaponManager:mousePressEvent(event)
    event:accept()
end

function WeaponManager:mouseMoveEvent(event)
    
end