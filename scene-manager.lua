import 'class'
import 'scene'

local scene = nil
local stack = {}
local scenes = {}

function addScene(name, path, type)
    scenes[name] = module.load(path)[type]()
end

function startScene(name)
    if scene then
        scene:exit()
        scene = nil
    end
    
    SceneManager.scene_name = name

    if name then
        scene = scenes[name]

        assert (scene, 'Unable to find scene: '..name)

        scene:enter()
        scene.entered = true
    end
end

function getScene()
    return scene
end

SceneManager = class()
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

function SceneManager:OnButtonClick(obj)
    if scene then
        invoke(scene, 'OnButtonClick', obj)
    end
end

function SceneManager:OnSliderChange(obj)
    if scene then
        invoke(scene, 'OnSliderChange', obj)
    end
end

function SceneManager:OnCheckboxChange(obj)
    if scene then
        invoke(scene, 'OnCheckboxChange', obj)
    end
end

function SceneManager:mousepressed(x, y, button, istouch)
    if scene then
        invoke(scene, 'OnMouseDown', x, y, button, istouch)
    end
end

function SceneManager:mousereleased(x, y, button, istouch, presses)
    if scene then
        invoke(scene, 'OnMouseUp', x, y, button, istouch, presses)
    end
end

function SceneManager:mousemoved(x, y, dx, dy)
    if scene then
        invoke(scene, 'OnMouseMove', x, y, dx, dy)
    end
end

function SceneManager:keypressed(key, scancode, isrepeat)
    if scene then
        if isrepeat then
            invoke(scene, 'OnKeyRepeat', key, scancode)
        else
            invoke(scene, 'OnKeyDown', key, scancode)
        end
    end
end

function SceneManager:keyreleased(key)
    if scene then
        invoke(scene, 'OnKeyUp', key)
    end
end

function SceneManager:textinput(text)
    if scene then
        invoke(scene, 'OnTextInput', text)
    end
end