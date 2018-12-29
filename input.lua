import 'class'
import 'event-manager'

local mouse = {}
local keys = {}
local queue = {}

local MouseEventType = class()

InputEvent = class()
function InputEvent:new()
    self.accepted = false
end

function InputEvent:accept()
    self.accepted = true
end

function InputEvent:ignore()
    self.accepted = false
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
    self.y = dy
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

Input = {}
function Input:GetButtonDown(key, isrepeat)
    local info = keys[key]
    return info and info.state and not info.prev and (isrepeat or not info.isrepeat)
end

function Input:GetButton(key)
    local info = keys[key]
    return info and info.state
end

function Input:GetButtonUp(key)
    local info = keys[key]
    return info and not info.state and info.prev
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

end

function Input:keypressed(key, scancode, isrepeat)
    InputListener:invoke(KEY_PRESSED, key, scancode, isrepeat)

    table.insert(queue, {
        type = KEY_PRESSED,
        key = key,
        scancode = scancode,
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