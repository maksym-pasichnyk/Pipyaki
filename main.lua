package.path = package.path..';src/?.lua'
package.cpath = package.cpath..';libs/?.so'
love.filesystem.setRequirePath(package.path)

class = require 'general/class'
enum = require 'general/enum'
Self = require 'general/self'

ImGui = require 'imgui.imgui'

debug_enable = false

require 'general/module'

--------------------------------------------------------

import 'general/scene/scene-manager'
import 'general/graphics/screen'
import 'general/input'
import 'general/timer'

function love.load()
    ImGui.CreateContext(nil)
    ImGui.StyleColorsDark()
    ImGui.ImplLove_Init()

    love.keyboard.setKeyRepeat(true)

    module.load('game/init')
end

function love.resize(w, h)
    Screen.width = w
    Screen.height = h
    SceneManager.resize(w, h)
end

function love.keypressed(key, scancode, isrepeat)
    if not isrepeat then
        if key == 'q' or key == 'Q' then
            debug_enable = not debug_enable
        end
    end
    Input.keypressed(key, scancode, isrepeat)
    SceneManager.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key)
    Input.keyreleased(key)
    SceneManager.keyreleased(key)
end

function love.mousepressed(x, y, button, istouch)
    Input.mousepressed(x, y, button, istouch)
    SceneManager.mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch, presses)
    Input.mousereleased(x, y, button, istouch, presses)
    SceneManager.mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy)
    Input.mousemoved(x, y, dx, dy)
    SceneManager.mousemoved(x, y, dx, dy)
end

function love.textinput(text)
    Input.textinput(text)
    SceneManager.textinput(text)
end

-------------------------------------------------------

function love.update(dt)
    Input.update(dt)
    SceneManager.update(dt)
end

function love.draw()
    ImGui.ImplLove_NewFrame()
    ImGui.NewFrame();

    ImGui.Begin("Hello, world!"); 

    -- ImGui.Text("This is some useful text."); 

    -- SceneManager.render()
    -- love.graphics.reset()
    -- love.graphics.print(love.timer.getFPS()..'fps', 10, 10)

    -- ImGui.ShowDemoWindow(nil)

    ImGui.End();

    ImGui.EndFrame()
    ImGui.Render()

    ImGui.RenderDrawData(ImGui.GetDrawData())
end

function love.boot()

end