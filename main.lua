package.path = package.path..';src/?.lua'
love.filesystem.setRequirePath(package.path)

class = require 'general/class'

require 'general/module'

--------------------------------------------------------

import 'general/scene/scene-manager'
import 'general/graphics/screen'
import 'general/input'
import 'general/timer'

function love.load()
    love.keyboard.setKeyRepeat(true)

    module.load('game/init')
end

function love.resize(w, h)
    Screen.width = w
    Screen.height = h
    SceneManager.resize(w, h)
end

function love.keypressed(key, scancode, isrepeat)
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
    SceneManager.render()
    love.graphics.reset()
    love.graphics.print(love.timer.getFPS()..'fps', 10, 10)
end