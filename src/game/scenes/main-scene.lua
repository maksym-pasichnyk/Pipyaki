import 'general/scene/scene'
import 'general/scene/scene-manager'

import 'general/graphics/screen'
import 'general/ui/controls/checkbox'
import 'general/ui/controls/slider'
import 'general/ui/controls/text-field'
import 'general/ui/controls/text-button'
import 'general/ui/controls/label'

local function Menu(text, action)
    return { action = action, text = text }
end
 
MainScene = class(Scene)
function MainScene:new()
    Scene.new(self)

    local sw = Screen.width
    local sh = Screen.height

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

    self:add(Label(nil, 'Main Menu', 0, 0, Screen.width, 40))

    for i, entry in ipairs(menu) do
        local button = self:add(TextButton(nil, entry.text, x, y, w, h))
        button.onClick:add(entry.action)
        y = y + h + space
    end

    local label = self:add(Label(nil, 'Hello', cx - 100, 140, 200, 30))
    local username = self:add(TextField(nil, 'Username', '', cx - 100, 20, 200, 40))
    local volume = self:add(Slider(nil, cx - 100, 120, 200))
    volume.onChange:add(function (this)
        label.text = tostring(this.value)
    end)
    local music = self:add(Checkbox(nil, 10, 200))
    music.onToggle:add(function (this)
        volume.enabled = this.value
    end)
end

function MainScene:joystickPressEvent(event)
    if event.button == 'b' then
        event:accept()
        love.event.quit()
    end
end

function MainScene:keyPressEvent(event)
    Scene.keyPressEvent(self, event)
    
    if event.accepted or not event:single() then
        return
    end

    if event.key == 'escape' then
        event:accept()
        love.event.quit()
    end
end