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

local function sprite(texture, w, h, count)
    return { texture = texture, w = w, h = h, count = count }
end

Inventory = class(GraphicsItem)
Inventory.items = {
    { 
        type = 'tile';
        name = 'melon';
        sprite = sprite('weapons/melon.png', 20, 20, 6);
        delayed = {
            time = 5;
            sprite = sprite('weapons/melon_explosion.png', 60, 60, 11);
            trace = {
                time = 30;
                sprite = sprite('weapons/melon_crater.png', 35, 35, 3);
            }
        };
    },
    {
        type = 'tile';
        name = 'melon_hard';
        sprite = sprite('weapons/melon_hard.png', 20, 20, 6);
        delayed = {
            time = 5;
            sprite = sprite('weapons/melon_explosion_hard.png', 60, 60, 11)
        }
    },
    {
        type = 'tile';
        name = 'melon_thr';
        sprite = sprite('weapons/melon_thr.png', 20, 20, 6);
    },
    {
        type = 'tile';
        name = 'melon_thr_hard';
        sprite = sprite('weapons/melon_thr_hard.png', 20, 20, 6);
    },
    {
        type = 'tile';
        name = 'melon_thr_hard';
        sprite = sprite('weapons/melon_thr_hard.png', 20, 20, 1);
    },
    {
        type = 'item';
        name = 'brick';
    },
    {
        type = 'item';
        name = 'melon_2';
    },
    {
        type = 'item';
        name = 'melon_2_hard';
    },
    {
        type = 'item';
        name = 'ananas';
    },
    {
        type = 'item';
        name = 'ananas_hard';
    },
    {
        type = 'item';
        name = 'sock';
    },
    {
        type = 'item';
        name = 'bananas_skin';
    },
    {
        type = 'item';
        name = 'grabli';
    },
    {
        type = 'item';
        name = 'bomb';
    },
    {
        type = 'tile';
        name = 'mine';
        sprite = sprite('weapons/mine.png', 16, 14, 1);
    },
    {
        type = 'item';
        name = 'bananas';
    },
    {
        type = 'item';
        name = 'helmet';
    },
    {
        type = 'item';
        name = 'invisible_helmet';
    },
    {
        type = 'item';
        name = 'kaska';
    },
    {
        type = 'item';
        name = 'carrot';
    },
    {
        type = 'item';
        name = 'shield';
    }
}

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
    self.counts = {50}

    local w = self.weapons:getWidth()
    local h = self.weapons:getHeight()

    for i = 0, w / h - 1 do
        table.insert(self.icons, self.weapons:clip(rect(h * i, 0, h, h), vec2(0, 0)))
    end
end

function Inventory:getIcon()
    return self.icons[self.current + 5]
end

function Inventory:getCount()
    return self.counts[self.current] or 0
end

function Inventory:useItem()
    local count = self:getCount()
    if count > 0 then
        self.counts[self.current] = count - 1
        return self.items[self.current]
    end
    return nil
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