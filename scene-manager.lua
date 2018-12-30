import 'class'
import 'scene'

local scene = nil
local stack = {}
local scenes = {}

function addScene(name, path, type)
    scenes[name] = module.load(path)[type]
end

function startScene(name)
    if scene then
        scene:exit()
        scene = nil
    end
    
    SceneManager.scene_name = name

    if name then
        local Scene = scenes[name]
        assert (Scene, 'Unable to find scene: '..name)

        scene = setmetatable({}, Scene)
        scene:new()


        scene:enter()
        scene.entered = true
    end
end

function getScene()
    return scene
end

SceneManager = {}
function SceneManager:switch(name)
    stack = {}

    startScene(name)
end

function SceneManager:push(name)
    table.insert(stack, SceneManager.scene_name)
    startScene(name)
end

function SceneManager:pop()
    local name = stack[#stack]
    assert(name, 'Unable to pop parent scene')
    table.remove(stack)
    SceneManager:switch(name)
end

function SceneManager:render()
    if scene then
        scene:render()
    end
end

function SceneManager:update(dt)
    if scene then
        scene:update(dt)
    end
end

function SceneManager:resize(w, h)
    if scene then
        scene:resize(w, h)
    end
end

function SceneManager:mousepressed(x, y, button, istouch)
    if scene then
        scene:mousepressed(x, y, button, istouch)
    end
end

function SceneManager:mousereleased(x, y, button, istouch, presses)
    if scene then
        scene:mousereleased(x, y, button, istouch, presses)
    end
end

function SceneManager:mousemoved(x, y, dx, dy)
    if scene then
        scene:mousemoved(x, y, dx, dy)
    end
end

function SceneManager:keypressed(key, scancode, isrepeat)
    if scene then
        scene:keypressed(key, scancode, isrepeat)
    end
end

function SceneManager:keyreleased(key)
    if scene then
        scene:keyreleased(key)
    end
end

function SceneManager:textinput(text)
    if scene then
        scene:textinput(text)
    end
end

function SceneManager:joystickpressed(joystick, button)
    if scene then
        scene:joystickpressed(joystick, button)
    end
end

function SceneManager:joystickreleased(joystick, button)
    if scene then
        scene:joystickreleased(joystick, button)
    end
end

function SceneManager:joystickaxis(joystick, axis, value)
    if scene then
        scene:joystickaxis(joystick, axis, value)
    end
end

function SceneManager:joystickhat(joystick, hat, direction)
    if scene then
        scene:joystickhat(joystick, hat, direction)
    end
end