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
local item_table = {
    { 
        type = 'tile';
        itemId = 'melon';
        sprite = sprite('weapons/melon.png', 20, 20, 6);
        delay = 5;
        explosion = {
            sprite = sprite('weapons/melon_explosion.png', 60, 60, 11);
            parts = {
                sprite = sprite('weapons/melon_parts.png', 20, 20, 10);
            };
            decal = {
                sprite = sprite('weapons/melon_crater.png', 35, 35, 3);
            }
        };
    },
    {
        type = 'tile';
        itemId = 'melon_hard';
        sprite = sprite('weapons/melon_hard.png', 20, 20, 6);
        delay = 5;
        explosion = {
            sprite = sprite('weapons/melon_explosion_hard.png', 60, 60, 11);
            parts = {
                sprite = sprite('weapons/melon_parts_hard.png', 20, 20, 10);
            };
            decal = {
                sprite = sprite('weapons/melon_crater.png', 35, 35, 3);
            }
        }
    },
    {
        type = 'throwable';
        itemId = 'brick';
        sprite = sprite('weapons/brick.png', 20, 17, 6);
        collision = 'inside';
        explosion = {
            sprite = sprite('weapons/brick_explosion.png', 45, 45, 12);
            -- parts = {
            --     sprite = sprite('weapons/melon_parts.png', 20, 20, 10);
            -- };
            -- decal = {
            --     sprite = sprite('weapons/melon_crater.png', 35, 35, 3);
            -- }
        }
    },
    {
        type = 'throwable';
        itemId = 'melon_thr';
        sprite = sprite('weapons/melon_thr.png', 20, 20, 6);
        explosion = {
            sprite = sprite('weapons/melon_explosion.png', 60, 60, 11);
            parts = {
                sprite = sprite('weapons/melon_parts.png', 20, 20, 10);
            };
            decal = {
                sprite = sprite('weapons/melon_crater.png', 35, 35, 3);
            }
        }
    },
    {
        type = 'throwable';
        itemId = 'melon_thr_hard';
        sprite = sprite('weapons/melon_thr_hard.png', 20, 20, 6);
        explosion = {
            -- time = 0.25;
            sprite = sprite('weapons/melon_explosion_hard.png', 60, 60, 11);
            parts = {
                sprite = sprite('weapons/melon_parts_hard.png', 20, 20, 10);
            };
            decal = {
                sprite = sprite('weapons/melon_crater.png', 35, 35, 3);
            }
        }
    },
    {
        type = 'item';
        itemId = 'melon_2';
    },
    {
        type = 'item';
        itemId = 'melon_2_hard';
    },
    {
        type = 'throwable';
        itemId = 'ananas';
        sprite = sprite('weapons/ananas.png', 40, 40, 1);
        explosion = {
            sprite = sprite('weapons/ananas_exploding.png', 60, 60, 6);
            parts = {
                sprite = sprite('weapons/ananas_parts.png', 26, 26, 7);
            }
        }
    },
    {
        type = 'throwable';
        itemId = 'ananas_hard';
        sprite = sprite('weapons/ananas_hard.png', 40, 40, 1);
        explosion = {
            sprite = sprite('weapons/ananas_exploding_hard.png', 60, 60, 6);
            parts = {
                sprite = sprite('weapons/ananas_parts_hard.png', 26, 26, 7);
            }
        }
    },
    {
        type = 'item';
        itemId = 'sock';
    },
    {
        type = 'item';
        itemId = 'bananas_skin';
    },
    {
        type = 'item';
        itemId = 'grabli';
    },
    {
        type = 'item';
        itemId = 'bomb';
    },
    {
        type = 'tile';
        itemId = 'mine';
        sprite = sprite('weapons/mine.png', 16, 14, 1);
    },
    {
        type = 'item';
        itemId = 'bananas';
    },
    {
        type = 'item';
        itemId = 'helmet';
    },
    {
        type = 'item';
        itemId = 'invisible_helmet';
    },
    {
        type = 'item';
        itemId = 'kaska';
    },
    {
        type = 'item';
        itemId = 'carrot';
    },
    {
        type = 'item';
        itemId = 'shield';
    }
}

local Item = class(GraphicsItem)
function Item:new(inventory, slot, icon, disable_icon, data)
    GraphicsItem.new(self, inventory)
    self.slot = slot
    self.icon = icon
    self.disable_icon = disable_icon
    self.data = data
    self.count = 0
    self.active = false
end

function Item:paintEvent()
    if self.count > 0 then
        Sprite.render(self.icon, 0, 0)
        love.graphics.printf(tostring(self.count), -40, 27, 48 + 32, 'right')
    else
        Sprite.render(self.disable_icon, 0, 0)
    end
end

function Item:mousePressEvent(event)
    self.parent:selectSlot(self.slot)
    return true
end

function Item:set(count)
    self.count = count

    if count > 0 then
        self.active = true
    end
end

function Item:add(count)
    self:set(self.count + count)
end

function Item:use()
    if self.count > 0 then
        self.count = self.count - 1
        self.parent:updateSlot(self.slot)
        return true
    end
    return false
end

local items = {}
function Inventory:new(scene)
    GraphicsItem.new(self, scene)
    self.ignore_self_touches = false

    self.w = (SIZE + SPACE) * COLUMNS + SPACE
    self.h = (SIZE + SPACE) * ROWS + SPACE

    self.x = (Screen.width - self.w) * 0.5
    self.y = (Screen.height - self.h) * 0.5
    
    self.fragswin = Ninepath('menu/fragswin.png', 20, 40, 20, 40, self.w, self.h)
    self.weapons = Sprite.create('menu/weapons.png')
    self.icons = {}

    local w = self.weapons:getWidth()
    local h = self.weapons:getHeight()

    for i = 0, w / h - 1 do
        table.insert(self.icons, self.weapons:clip(rect(h * i, 0, h, h), vec2(0, 0)))
    end

    items = {}
    for i = 0, 25 - 6 do
        local item = Item(self, i + 1, self.icons[i + 6], self.icons[5], item_table[i + 1])
        item:set(100)
        
        item.x = (i % COLUMNS) * (SIZE + SPACE) + SPACE
        item.y = math.floor(i / COLUMNS) * (SIZE + SPACE) + SPACE
        item.w = h
        item.h = h

        table.insert(items, item)
    end
end

function Inventory:selectSlot(slot)
    local item = slot and items[slot] or nil
    self.slot = slot
    self.item = item
    self.parent:OnItemChange(item)
end

function Inventory:getAvailableItem()
    for slot, item in ipairs(items) do
        if item.count > 0 then
            return slot
        end
    end
    return nil
end

function Inventory:updateSlot(slot)
    local item = items[slot]
    if item.count == 0 then
        item.active = false
        if item.slot == slot then
            self:selectSlot(self:getAvailableItem())
        end
    end
end

function Inventory:getItemById(itemId)
    for slot, item in ipairs(items) do
        if item.data.itemId == itemId then
            return item
        end
    end

    return nil
end

function Inventory:getSlotById(itemId)
    local item = self:getItemById(itemId)
    if item then
        return item.slot
    end
    return nil
end

function Inventory:resizeEvent(w, h)
    self.x = (w - self.w) * 0.5
    self.y = (h - self.h) * 0.5
end

function Inventory:paintEvent()
    self.fragswin:render()
end

function Inventory:paintAfterChilds()
    if self.item then
        if self.item.count > 0 then
            local i = self.item.slot - 1
            local x = (i % COLUMNS) * (SIZE + SPACE) + SPACE
            local y = math.floor(i / COLUMNS) * (SIZE + SPACE) + SPACE
            Sprite.render(self.icons[1], x, y)
        end
    end
end

function Inventory:keyPressEvent(event)
    local key = event.key
    if key == 'escape' or key == 'i' then
        self.enabled = false
    end
    return true
end