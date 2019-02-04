import 'general/math/vec2'
import 'general/math/rect'
import 'general/graphics/screen'
import 'general/graphics/sprite'
import 'general/graphics/ninepath'
import 'general/ui/graphics-item'

local SIZE    = 44
local SPACE   = 10
local COLUMNS = 5
local ROWS    = 4

Inventory = class(GraphicsItem)
function Inventory:new()
    GraphicsItem.new(self)

    self.current = 1
    self.w = (SIZE + SPACE) * COLUMNS + SPACE
    self.h = (SIZE + SPACE) * ROWS + SPACE

    self.x = (Screen.width - self.w) * 0.5
    self.y = (Screen.height - self.h) * 0.5
    
    self.fragswin = Ninepath('menu/fragswin.png', 20, 40, 20, 40, self.w, self.h)
    self.weapons = Sprite:create('menu/weapons.png')
    self.icons = {}
    self.ammos = {
        50, 0, 0, 0, 0,
         0, 0, 0, 0, 0,
         0, 0, 0, 0, 0,
         0, 0, 0, 0, 0,
    }

    local w = self.weapons:getWidth()
    local h = self.weapons:getHeight()

    for i = 0, w / h - 1 do
        table.insert(self.icons, self.weapons:clip(rect(h * i, 0, h, h), vec2(0, 0)))
    end
end

function Inventory:getIcon()
    return self.icons[self.current + 5]
end

function Inventory:getAmmo()
    return self.ammos[self.current];
end

function Inventory:resizeEvent(w, h)
    self.x = (w - self.w) * 0.5
    self.y = (h - self.h) * 0.5
end

function Inventory:paintEvent()
    self.fragswin:render()

    for i = 0, 25 - 6 do
        local x = (i % COLUMNS) * (SIZE + SPACE) + SPACE
        local y = math.floor(i / COLUMNS) * (SIZE + SPACE) + SPACE

        Sprite.render(self.icons[i + 6], x, y)
    end
end

function Inventory:joystickPressEvent(event)
    if event.button == 'b' then
        self.enabled = false
        event:accept()
    end
end

function Inventory:keyPressEvent(event)
    if event:single() then
        if event.key == 'escape' then
            self.enabled = false
            event:accept()
        end
    end
end