import 'class'
import 'event-manager'

Input = class()
InputEvent = EventManager()
Input.mouse = {}
Input.keys = {}
Input.queue = {}

MOUSE_PRESSED  = 0
MOUSE_RELEASED = 1
KEY_PRESSED    = 2
KEY_RELEASED   = 3
TEXT_INPUT     = 4

function Input:GetButtonDown(key, isrepeat)
    local info = self.keys[key]
    return info and info.state and not info.prev and (isrepeat or not info.isrepeat)
end

function Input:GetButton(key)
    local info = self.keys[key]
    return info and info.state
end

function Input:GetButtonUp(key)
    local info = self.keys[key]
    return info and not info.state and info.prev
end

function Input:GetMouseButtonDown(button)
    local info = self.mouse[button]
    return info and info.state and not info.prev
end

function Input:GetMouseButton(button)
    local info = self.mouse[button]
    return info and info.state
end

function Input:GetMouseButtonUp(button)
    local info = self.mouse[button]
    return info and not info.state and info.prev
end

function Input:update()
    for k, event in pairs(self.mouse) do
        if not event.state then
            self.mouse[k] = nil
        else
            event.prev = true
        end
    end

    for k, event in pairs(self.keys) do
        if not event.state then
            self.keys[k] = nil
        else
            event.prev = true
        end
    end

    for k, v in pairs(self.queue) do
        if v.type == 0 then
            local event = {}
            event.state = true
            event.x = v.x
            event.y = v.y
            self.mouse[v.button] = event
        elseif v.type == 1 then
            local event = self.mouse[v.button]
            event.prev = true
            event.state = false
            event.x = v.x
            event.y = v.y
            event.presses = v.presses
        elseif v.type == 2 then
            local event = {}
            event.state = true
            event.isrepeat = v.isrepeat
            self.keys[v.key] = event
        elseif v.type == 3 then
            local event = self.keys[v.key]
            event.prev = true
            event.state = false
        end
    end

    self.queue = {}
end

function Input:mousepressed(x, y, button, istouch)
    InputEvent:invoke(MOUSE_PRESSED, x, y, button, istouch)

    table.insert(self.queue, {
        type = 0,
        button = button,
        x = x,
        y = y,
        istouch = istouch
    })
end

function Input:mousereleased(x, y, button, istouch, presses)
    InputEvent:invoke(MOUSE_RELEASED, x, y, button, istouch)

    table.insert(self.queue, {
        type = 1,
        button = button,
        x = x,
        y = y,
        istouch = istouch,
        presses = presses
    })
end

function Input:keypressed(key, scancode, isrepeat)
    InputEvent:invoke(KEY_PRESSED, key, scancode, isrepeat)

    table.insert(self.queue, {
        type = 2,
        key = key,
        scancode = scancode,
        isrepeat = isrepeat
    })
end

function Input:keyreleased(key)
    InputEvent:invoke(KEY_RELEASED, key)

    table.insert(self.queue, {
        type = 3,
        key = key
    })
end

function Input:textinput(text)
    InputEvent:invoke(TEXT_INPUT, text)
end