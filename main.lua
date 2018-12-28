require 'module'

function invoke(self, name, ...)
    local action = self[name]
    
    if action then
        action(self, ...)
    end
end

export 'invoke'

import 'class'
import 'input'
import 'timer'
import 'event-manager'
import 'scene-manager'

addScene('main', 'scenes/main_menu', 'MainMenu')
addScene('game', 'scenes/game_menu', 'GameMenu')

function love.load()
    love.keyboard.setKeyRepeat(true)

    SceneManager:switch('main')
end

function love.keypressed(key, scancode, isrepeat)
    Input:keypressed(key, scancode, isrepeat)
    SceneManager:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key)
    Input:keyreleased(key)
    SceneManager:keyreleased(key)
end

function love.mousepressed(x, y, button, istouch)
    Input:mousepressed(x, y, button, istouch)
    SceneManager:mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch, presses)
    Input:mousereleased(x, y, button, istouch, presses)
    SceneManager:mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy)
    SceneManager:mousemoved(x, y, dx, dy)
end

function love.textinput(text)
    Input:textinput(text)
    SceneManager:textinput(text)
end

function love.draw()
    SceneManager:render()

    local stats = love.graphics.getStats()
    love.graphics.reset()
    love.graphics.setColor(0, 0, 0, 255 * .75)
    love.graphics.rectangle("fill", 5, 5, 220, 85, 2)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(love.timer.getFPS() .. "fps", 10, 10)
    -- love.graphics.print('x = '..player.tile_x..'\t'..'y = '..player.tile_y, 10, 30)
    love.graphics.print("drawcalls: " .. stats.drawcalls, 10, 30)
    -- love.graphics.print("map: " .. map, 10, 50)
    love.graphics.print('memory (MB): ' .. (collectgarbage 'count' / 1024), 10,70)
end

function love.update(dt)
    Input:update(dt)
    Timer:update(dt)
    SceneManager:update(dt)
end
