import 'general/event/event-manager'
import 'general/list'

local mouse = {}
local keys = {}
local axis = {}
local queue = {}
local joysticks = List()

local MouseEventType = class()

InputEvent = class()
function InputEvent:new(data)
    if data then
        for k, v in pairs(data) do
            self[k] = v
        end
    end

    self.accepted = false
end

function InputEvent:accept(target)
    self.accepted = true
    if target then
        self.target = target
    end
end

local KeyEventType = class()
KeyPress = KeyEventType()
KeyRelease = KeyEventType()

KeyEvent = class(InputEvent)
function KeyEvent:new(key, code, text, isrepeat)
    InputEvent.new(self)

    self.key = key
    self.code = code
    self.isrepeat = isrepeat
end

function KeyEvent:single()
    return not self.isrepeat
end

MouseEvent = class(InputEvent)
function MouseEvent:new(x, y, button, dx, dy)
    self.x = x
    self.y = y
    self.button = button
    self.dx = dx
    self.dy = dy
end

InputListener = EventManager()

MOUSE_PRESSED  = 0
MOUSE_RELEASED = 1
MOUSE_MOVED    = 2
KEY_PRESSED    = 3
KEY_RELEASED   = 4
TEXT_INPUT     = 5

JOYSTICK_ADDED   = 6
JOYSTICK_REMOVED = 7

GAMEPAD_PRESSED  = 8
GAMEPAD_RELEASED = 9
GAMEPAD_AXIS     = 10

GAMEPAD_DEAD_ZONE = 0.15

Input = {}
function Input:GetButtonDown(key, isrepeat)
    local info = keys[key]
    return info and info.state and not info.prev and (isrepeat or not info.isrepeat)
end

function Input:GetAnyButtonDown(keys)
    for k, key in pairs(keys) do
        if Input:GetButtonDown(key) then
            return true
        end
    end

    return false
end

function Input:GetButton(key)
    local info = keys[key]
    return info and info.state
end

function Input:GetAnyButton(keys)
    for k, key in pairs(keys) do
        if Input:GetButton(key) then
            return true
        end
    end

    return false
end

function Input:GetButtonUp(key)
    local info = keys[key]
    return info and not info.state and info.prev
end

function Input:GetAnyButtonUp(keys)
    for k, key in pairs(keys) do
        if Input:GetButtonUp(key) then
            return true
        end
    end

    return false
end

function Input:GetAxis(axis)
    local name, id = axis:match("(.+)#(%d+)")
    local joystick = self:getJoystick(tonumber(id))
    local value = joystick and joystick:getGamepadAxis(name) or 0

    if value >= GAMEPAD_DEAD_ZONE then
        return (value - GAMEPAD_DEAD_ZONE) / (1 - GAMEPAD_DEAD_ZONE)
    elseif value <= -GAMEPAD_DEAD_ZONE then
        return (value + GAMEPAD_DEAD_ZONE) / (1 - GAMEPAD_DEAD_ZONE)
    end

    return 0
end

function Input:GetMouseButtonDown(button)
    local info = mouse[button]
    return info and info.state and not info.prev
end

function Input:GetMouseButton(button)
    local info = mouse[button]
    return info and info.state
end

function Input:GetMouseButtonUp(button)
    local info = mouse[button]
    return info and not info.state and info.prev
end

function Input:update()
    for k, event in pairs(mouse) do
        if not event.state then
            mouse[k] = nil
        else
            event.prev = true
        end
    end

    for k, event in pairs(keys) do
        if not event.state then
            keys[k] = nil
        else
            event.prev = true
        end
    end

    for k, v in pairs(queue) do
        if v.type == MOUSE_PRESSED then
            local event = {}
            event.state = true
            event.x = v.x
            event.y = v.y
            mouse[v.button] = event
        elseif v.type == MOUSE_RELEASED then
            local event = mouse[v.button]
            event.prev = true
            event.state = false
            event.x = v.x
            event.y = v.y
            event.presses = v.presses
        elseif v.type == KEY_PRESSED then
            local event = {}
            event.state = true
            event.code = v.code
            event.isrepeat = v.isrepeat
            keys[v.key] = event
        elseif v.type == KEY_RELEASED then
            local event = keys[v.key]
            event.prev = true
            event.state = false
        elseif v.type == GAMEPAD_PRESSED then
            local event = {}
            event.state = true
            keys[v.button..'#'..v.id] = event
        elseif v.type == GAMEPAD_RELEASED then
            local event = keys[v.button..'#'..v.id]
            event.prev = true
            event.state = false
        -- elseif v.type == GAMEPAD_AXIS then
        --     local event = {}
        --     event.value = v.value
        --     axis[v.axis..'#'..v.id] = event
        end
    end

    queue = {}
end

function Input:getJoystick(index)
    if joysticks:empty() then
        return nil
    end

    return joysticks:get(index)
end

function Input:mousepressed(x, y, button, istouch)
    InputListener:invoke(MOUSE_PRESSED, x, y, button, istouch)

    table.insert(queue, {
        type = MOUSE_PRESSED,
        button = button,
        x = x,
        y = y,
        istouch = istouch
    })
end

function Input:mousereleased(x, y, button, istouch, presses)
    InputListener:invoke(MOUSE_RELEASED, x, y, button, istouch, presses)

    table.insert(queue, {
        type = MOUSE_RELEASED,
        button = button,
        x = x,
        y = y,
        istouch = istouch,
        presses = presses
    })
end

function Input:mousemoved(x, y, dx, dy)
    InputListener:invoke(MOUSE_MOVED, x, y, dx, dy)
end

function Input:keypressed(key, scancode, isrepeat)
    InputListener:invoke(KEY_PRESSED, key, scancode, isrepeat)

    table.insert(queue, {
        type = KEY_PRESSED,
        key = key,
        code = scancode,
        isrepeat = isrepeat
    })
end

function Input:keyreleased(key)
    InputListener:invoke(KEY_RELEASED, key)

    table.insert(queue, {
        type = KEY_RELEASED,
        key = key
    })
end

function Input:textinput(text)
    InputListener:invoke(TEXT_INPUT, text)
end

function Input:joystickadded(joystick)
    InputListener:invoke(JOYSTICK_ADDED, joystick)
    joysticks:add(joystick)
end

function Input:joystickremoved(joystick)
    InputListener:invoke(JOYSTICK_REMOVED, joystick)
    joysticks:remove(joystick)
end

function Input:joystickpressed(joystick, button)
    InputListener:invoke(GAMEPAD_PRESSED, joystick, button)

    local id, unique = joystick:getID()
    table.insert(queue, {
        type = GAMEPAD_PRESSED,
        id = id,
        unique = unique,
        joystick = joystick,
        button = button
    })
end

function Input:joystickreleased(joystick, button)
    InputListener:invoke(GAMEPAD_RELEASED, joystick, button)
    
    local id, unique = joystick:getID()
    table.insert(queue, {
        type = GAMEPAD_RELEASED,
        id = id,
        unique = unique,
        joystick = joystick,
        button = button
    })
end

function Input:joystickaxis(joystick, axis, value)
    if math.abs(value) < GAMEPAD_DEAD_ZONE then
        return
    end

    if value > 0 then
        value = (value - GAMEPAD_DEAD_ZONE) / (1 - GAMEPAD_DEAD_ZONE)
    elseif value < 0 then
        value = (value + GAMEPAD_DEAD_ZONE) / (1 - GAMEPAD_DEAD_ZONE)
    end

    InputListener:invoke(GAMEPAD_AXIS, joystick, axis, value)

    -- local id, unique = joystick:getID()
    -- table.insert(queue, {
    --     type = GAMEPAD_AXIS,
    --     id = id,
    --     unique = unique,
    --     joystick = joystick,
    --     axis = axis,
    --     value = value
    -- })
end