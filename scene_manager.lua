module()

import 'class'
import 'scene'

local function change_scene(self, name)
    if self.current then
        self.current:exit()
        self.current = nil
    end
    
    self.current_scene_name = name

    if name then
        local scene = self.scenes[name]

        assert (scene, 'Unable to find scene: '..name)

        self.current = scene
        self.current:enter()
        self.current.entered = true
    end
end

SceneManager = class()
function SceneManager:new(scenes)
    self.current = nil
    self.stack = {}
    self.scenes = {}

    dir = dir or ''

    if scenes then
        for name, data in pairs(scenes) do
            local module = import(data.path, true)
            local scene = module[data.type]

            assert(scene:is(Scene))

            self.scenes[name] = scene()
        end
    end
end

function SceneManager:switch(name)
    self.stack = {}

    change_scene(self, name)
end

function SceneManager:push(name)
    table.insert(self.stack, self.current_scene_name)
    change_scene(self, name)
end

-- function SceneManager:add(name, scene)
--     assert(scene:is(Scene) and type(name) == 'string')

--     self.scenes[name] = scene
-- end

-- function SceneManager:remove(name)
--     local scene = self.scenes[name]

--     if scene then
--         scene:destroy()
--         self.scenes[name] = nil

--         if self.current_scene_name == name then
--             self.current = nil
--             self.current_scene_name = nil
--         end
--     end
-- end

function SceneManager:pop()
    local name = self.stack[#self.stack]

    assert(name, 'Unable to pop parent scene')

    table.remove(self.stack)

    self:switch(name)
end

function SceneManager:draw()
    if self.current then
        self.current:draw()
    end
end

function SceneManager:update(dt)
    if self.current then
        self.current:update(dt)
    end
end

function SceneManager:OnButtonClick(obj)
    if self.current then
        invoke(self.current, 'OnButtonClick', obj)
    end
end

function SceneManager:OnSliderChange(obj)
    if self.current then
        invoke(self.current, 'OnSliderChange', obj)
    end
end

function SceneManager:OnCheckboxChange(obj)
    if self.current then
        invoke(self.current, 'OnCheckboxChange', obj)
    end
end

function SceneManager:mousepressed(x, y, button, istouch)
    if self.current then
        self.current:mousepressed(x, y, button, istouch)
    end
end

function SceneManager:mousereleased(x, y, button, istouch, presses)
    if self.current then
        self.current:mousereleased(x, y, button, istouch, presses)
    end
end

function SceneManager:mousemoved(x, y, dx, dy)
    if self.current then
        self.current:mousemoved(x, y, dx, dy)
    end
end

function SceneManager:keypressed(key, scancode, isrepeat)
    if self.current then
        self.current:keypressed(key, scancode, isrepeat)
    end
end

function SceneManager:keyreleased(key)
    if self.current then
        self.current:keyreleased(key)
    end
end

function SceneManager:textinput(text)
    if self.current then
        self.current:textinput(text)
    end
end