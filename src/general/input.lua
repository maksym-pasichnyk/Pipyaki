import 'general/event/event-manager'
import 'general/list'

local MouseEventType = class()

InputEvent = class()
function InputEvent:new(data)
    if data then
        for k, v in pairs(data) do
            self[k] = v
        end
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

MOUSE_PRESSED  = 0
MOUSE_RELEASED = 1
MOUSE_MOVED    = 2
KEY_PRESSED    = 3
KEY_RELEASED   = 4
TEXT_INPUT     = 5

local mouse = {}
local keys = {}
local axis = {}
local queue = {}

Input = {}

function Input.getButtonDown(key, isrepeat)
    local info = keys[key]
    return info and info.state and not info.prev and (isrepeat or not info.isrepeat)
end

function Input.getAnyButtonDown(keys, isrepeat)
    for k, key in pairs(keys) do
        if Input.getButtonDown(key) then
            return true
        end
    end
    return false
end

function Input.getButton(key)
    local info = keys[key]
    return info and info.state
end

function Input.getAnyButton(keys)
    for k, key in pairs(keys) do
        if Input.getButton(key) then
            return true
        end
    end

    return false
end

function Input.getButtonUp(key)
    local info = keys[key]
    return info and not info.state and info.prev
end

function Input.getAnyButtonUp(keys)
    for k, key in pairs(keys) do
        if Input.getButtonUp(key) then
            return true
        end
    end

    return false
end

function Input.getMouseButtonDown(button)
    local info = mouse[button]
    return info and info.state and not info.prev
end

function Input.getMouseButton(button)
    local info = mouse[button]
    return info and info.state
end

function Input.getMouseButtonUp(button)
    local info = mouse[button]
    return info and not info.state and info.prev
end

function Input.update()
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
        end
    end

    queue = {}
end

function Input.mousepressed(x, y, button, istouch)
    table.insert(queue, {
        type = MOUSE_PRESSED,
        button = button,
        x = x,
        y = y,
        istouch = istouch
    })
end

function Input.mousereleased(x, y, button, istouch, presses)
    table.insert(queue, {
        type = MOUSE_RELEASED,
        button = button,
        x = x,
        y = y,
        istouch = istouch,
        presses = presses
    })
end

function Input.mousemoved(x, y, dx, dy)
end

function Input.keypressed(key, scancode, isrepeat)
    if key ~= 'unknown' then
        table.insert(queue, {
            type = KEY_PRESSED,
            key = key,
            code = scancode,
            isrepeat = isrepeat
        })
    end
end

function Input.keyreleased(key)
    if key ~= 'unknown' then
        table.insert(queue, {
            type = KEY_RELEASED,
            key = key
        })
    end
end

function Input.textinput(text)
end