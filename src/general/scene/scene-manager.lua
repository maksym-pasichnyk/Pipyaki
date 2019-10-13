local scene = nil
local stack = {}
local scenes = {}
local scene_name = nil

function addScene(name, path, type)
    scenes[name] = module.load(path)[type]
end

function startScene(name)
    if scene then
        scene:leave()
        scene = nil
    end
    
    scene_name = name

    if name then
        scene = scenes[name]()

        scene:enter()
        scene.entered = true
    end
end

function getScene()
    return scene
end

SceneManager = {}
function SceneManager.switch(name)
    stack = {}

    startScene(name)
end

function SceneManager.push(name)
    table.insert(stack, scene_name)
    startScene(name)
end

function SceneManager.pop()
    local name = stack[#stack]
    table.remove(stack)
    SceneManager.switch(name)
end

function SceneManager.render()
    if scene then
        scene:render()
    end
end

function SceneManager.update(dt)

    if scene then
        scene:update(dt)
    end
end

function SceneManager.resize(w, h)
    if scene then
        scene:resize(w, h)
    end
end

function SceneManager.mousepressed(x, y, button, istouch)
    if scene then
        scene:mousepressed(x, y, button, istouch)
    end
end

function SceneManager.mousereleased(x, y, button, istouch, presses)
    if scene then
        scene:mousereleased(x, y, button, istouch, presses)
    end
end

function SceneManager.mousemoved(x, y, dx, dy)
    if scene then
        scene:mousemoved(x, y, dx, dy)
    end
end

function SceneManager.keypressed(key, scancode, isrepeat)
    if scene then
        scene:keypressed(key, scancode, isrepeat)
    end
end

function SceneManager.keyreleased(key)
    if scene then
        scene:keyreleased(key)
    end
end

function SceneManager.textinput(text)
    if scene then
        scene:textinput(text)
    end
end