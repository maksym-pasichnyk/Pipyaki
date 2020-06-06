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

local Item = class()
function Item:new(properties)
    for k, v in pairs(properties) do
        self[k] = v
    end
end

local ThrowableItem = class(Item)
function ThrowableItem:use(this)
    this.level:addTile('middle', Throwable(self, this.player.x, this.player.y, this.player.direction))
end

ThrowableSkinItem = class(ThrowableItem)
function ThrowableSkinItem:new(properties)
    ThrowableItem.new(self, properties)
    local skin_data = self.skin_data
    self.skin = Sprite.create(skin_data.texture)
    for i = 0, skin_data.count - 1 do
        self.skin:add(rect(skin_data.w * i, 0, skin_data.w, skin_data.h))
    end
end

function ThrowableSkinItem:destroy()

end

function ThrowableSkinItem:useOnSelf(this)
    this.player:setHelmet(self)
end

function ThrowableSkinItem:render(entity)
    local clip = self.skin:get(entity.dir_clip or 1)
    local x = entity.x + self.offset_x
    local y = entity.y + self.offset_y

    Sprite.render(clip, x, y)
end

local ArmorItem = class()
function ArmorItem:new(texture, w, h, count, offset_x, offset_y, hide_player)
    self.offset_x = offset_x
    self.offset_y = offset_y
    self.hide_player = hide_player
    self.sprite = Sprite.create(texture)
    for i = 0, count - 1 do
        self.sprite:add(rect(w * i, 0, w, h))
    end
end

function ArmorItem:render(entity)
    local clip = self.sprite:get(entity.dir_clip or 1)
    local x = entity.x + self.offset_x
    local y = entity.y + self.offset_y

    Sprite.render(clip, x, y)
end

function ArmorItem:use(this)
    this.player:setHelmet(self)
end

ExplosionItem = class(Item)
function ExplosionItem:new(properties)
    Item.new(self, properties)
end
function ExplosionItem:use(this)
    this.level:addTile('middle', TileWeapon(self, this.player.x, this.player.y))
end

local Items = {}

Items['melon'] = ExplosionItem {
    sprite_data = sprite('weapons/melon.png', 20, 20, 6);
    delay = 5;
    explosion = {
        sprite_data = sprite('weapons/melon_explosion.png', 60, 60, 11);
        parts = {
            sprite_data = sprite('weapons/melon_parts.png', 20, 20, 10);
        };
        decal = {
            sprite_data = sprite('weapons/melon_crater.png', 35, 35, 3);
        }
    };
};

Items['melon_hard'] = ExplosionItem {
    sprite_data = sprite('weapons/melon_hard.png', 20, 20, 6);
    delay = 5;
    explosion = {
        sprite_data = sprite('weapons/melon_explosion_hard.png', 60, 60, 11);
        parts = {
            sprite_data = sprite('weapons/melon_parts_hard.png', 20, 20, 10);
        };
        decal = {
            sprite_data = sprite('weapons/melon_crater.png', 35, 35, 3);
        }
    }
};

Items['melon_thr'] = ThrowableItem {
    sprite_data = sprite('weapons/melon_thr.png', 20, 20, 6);
    explosion = {
        -- time = 0.25;
        sprite_data = sprite('weapons/melon_explosion.png', 60, 60, 11);
        parts = {
            sprite_data = sprite('weapons/melon_parts.png', 20, 20, 10);
        };
        decal = {
            sprite_data = sprite('weapons/melon_crater.png', 35, 35, 3);
        }
    }
};

Items['melon_thr_hard'] = ThrowableItem {
    sprite_data = sprite('weapons/melon_thr_hard.png', 20, 20, 6);
    explosion = {
        -- time = 0.25;
        sprite_data = sprite('weapons/melon_explosion_hard.png', 60, 60, 11);
        parts = {
            sprite_data = sprite('weapons/melon_parts_hard.png', 20, 20, 10);
        };
        decal = {
            sprite_data = sprite('weapons/melon_crater.png', 35, 35, 3);
        }
    }
};

Items['brick'] = ThrowableItem {
    sprite_data = sprite('weapons/brick.png', 20, 17, 6);
    collision = 'inside';
    explosion = {
        sprite_data = sprite('weapons/brick_explosion.png', 45, 45, 12);
    }
};

Items['ananas'] = ThrowableItem {
    sprite_data = sprite('weapons/ananas.png', 40, 40, 1);
    explosion = {
        sprite_data = sprite('weapons/ananas_exploding.png', 60, 60, 6);
        parts = {
            sprite_data = sprite('weapons/ananas_parts.png', 26, 26, 7);
        }
    }
};

Items['ananas_hard'] = ThrowableItem {
    sprite_data = sprite('weapons/ananas_hard.png', 40, 40, 1);
    explosion = {
        sprite_data = sprite('weapons/ananas_exploding_hard.png', 60, 60, 6);
        parts = {
            sprite_data = sprite('weapons/ananas_parts_hard.png', 26, 26, 7);
        }
    }
};

Items['sock'] = ThrowableSkinItem {
    sprite_data = sprite('weapons/sock.png', 20, 20, 7);
    skin_data = sprite('chars/skins/sock_helm.png', 36, 36, 12);
    offset_x = 0;
    offset_y = 0
};

Items['bomb'] = ExplosionItem {
    sprite_data = sprite('weapons/bomb.png', 30, 30, 4);
    delay = 5;
    explosion = {
        sprite_data = sprite('weapons/bomb_explosion.png', 60, 60, 9);
        parts = {
            sprite_data = sprite('weapons/bomb_parts_hard.png', 22, 22, 8);
        };
        decal = {
            sprite_data = sprite('weapons/bomb_crater.png', 40, 40, 2);
        }
    }
};

Items['helmet'] = ArmorItem('items/berserker.png', 35, 35, 12, 0, -14)
Items['invisible_helmet'] = ArmorItem('items/invisible.png', 35, 35, 12, 0, -20, true)
Items['kaska'] = ArmorItem('items/kaska.png', 36, 36, 12, 0, -5)

local item_table = {
    'melon',
    'melon_hard',
    'brick',
    'melon_thr',
    'melon_thr_hard',
    'melon_2',
    'melon_2_hard',
    'ananas',
    'ananas_hard',
    'sock',
    'bananas_skin',
    'grabli',
    'bomb',
    'mine',
    'bananas',
    'helmet',
    'invisible_helmet',
    'kaska',
    'carrot',
    'shield'
}

local InventorySlot = class(GraphicsItem)
function InventorySlot:new(inventory, slot_idx, icon, disable_icon, itemId)
    GraphicsItem.new(self, inventory)
    self.slot_idx = slot_idx
    self.icon = icon
    self.disable_icon = disable_icon
    self.itemId = itemId
    self.count = 0
    self.active = false
end

function InventorySlot:paintEvent()
    if self.count > 0 then
        Sprite.render(self.icon, 0, 0)
        love.graphics.printf(tostring(self.count), -40, 27, 48 + 32, 'right')
    else
        Sprite.render(self.disable_icon, 0, 0)
    end
end

function InventorySlot:mousePressEvent(event)
    self.parent:selectSlot(self.slot_idx)
    return true
end

function InventorySlot:set(count)
    self.count = count

    if count > 0 then
        self.active = true
    end
end

function InventorySlot:add(count)
    self:set(self.count + count)
end

function InventorySlot:use()
    if self.count > 0 then
        self.count = self.count - 1
        self.parent:updateSlot(self.slot_idx)
        return true
    end
    return false
end

function InventorySlot:getItem()
    return Items[self.itemId]
end

local slots = {}

Inventory = class(GraphicsItem)
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

    slots = {}
    for i = 0, 25 - 6 do
        local slot = InventorySlot(self, i + 1, self.icons[i + 6], self.icons[5], item_table[i + 1])
        slot:set(100)
        
        slot.x = (i % COLUMNS) * (SIZE + SPACE) + SPACE
        slot.y = math.floor(i / COLUMNS) * (SIZE + SPACE) + SPACE
        slot.w = h
        slot.h = h

        table.insert(slots, slot)
    end
end

function Inventory:selectSlot(slot_idx)
    local slot = slot_idx and slots[slot_idx] or nil
    self.slot_idx = slot_idx
    self.slot = slot
    self.parent:OnItemChange(slot)
end

function Inventory:getAvailableItem()
    for slot_idx, slot in ipairs(slots) do
        if slot.count > 0 then
            return slot_idx
        end
    end
    return nil
end

function Inventory:updateSlot(slot_idx)
    local slot = slots[slot_idx]
    if slot.count == 0 then
        slot.active = false
        if slot.slot_idx == slot_idx then
            self:selectSlot(self:getAvailableItem())
        end
    end
end

function Inventory:getSlotById(itemId)
    for slot_idx, slot in ipairs(slots) do
        if slot.itemId == itemId then
            return slot
        end
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
    if self.slot then
        if self.slot.count > 0 then
            local i = self.slot.slot_idx - 1
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