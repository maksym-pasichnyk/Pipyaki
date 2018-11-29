module()

import 'class'
import 'scene'
import 'scene_manager'
import 'input'

import 'ui/element'
import 'ui/text_button'
import 'ui/label'
import 'ui/text_field'
import 'ui/slider'
import 'ui/checkbox'

local function Menu(text, action)
    return { action = action, text = text }
end
 
MainMenu = class(Scene)
function MainMenu:new()
    Scene.new(self)

    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()

    local cx = sw / 2
    local cy = sh / 2

    local menu = {
        Menu('Play', function()
            SceneManager:switch('game')
        end),
        Menu('Settings', function()
        
        end),
        Menu('About', function()
        
        end),
        Menu('Exit', function()
            love.event.quit()
        end)
    }

    local space = 10
    local w = 150
    local h = 40

    local x = cx - w / 2
    local y = cy - (4 * (h + space) - space) / 2

    self:add(Label('Main Menu', 0, 0, love.graphics.getWidth(), 40))

    for i, entry in ipairs(menu) do
        local button = self:add(TextButton(entry.text, x, y, w, h))
        button.onClick:add(entry.action)
        y = y + h + space
    end

    local label = self:add(Label('Hello', cx - 100, 140, 200, 30))
    local username = self:add(TextField('Username', '', cx - 100, 20, 200, 40))
    local volume = self:add(Slider(cx - 100, 120, 200))
    volume.onChange:add(function (this)
        label.text = tostring(this.value)
    end)
    local music = self:add(Checkbox(10, 200))
    music.onToggle:add(function (this)
        volume.enabled = this.value
    end)

    -- self.

    -- local cols = 1
    -- local rows = 1

    -- local px = 10
    -- local space = 10

    -- local w = 200

    -- local width = cols * (w + space) - space
    -- local left = cx - width / 2

    -- for j = 1, rows do
    --     local x = left
    --     for i = 1, cols do
    --         -- self:add(TextButton('Hello', x, 0 + (w + space) * (j - 1), w, w))
    --         x = x + w + space
    --     end
    -- end
end

function MainMenu:keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
    end
end
