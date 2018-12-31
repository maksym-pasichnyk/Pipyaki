import 'general/event/event'

EventManager = class()
EventManager.events = {}
function EventManager:new()
    self.events = {}
end

function EventManager:bind(name, listener)
    local event = self.events[name]

    if event then
        event:add(listener)
    else
        event = Event()
        event:add(listener)

        self.events[name] = event
    end
end

function EventManager:unbind(name, listener)
    local event = self.events[name]

    if event then
        event:remove(listener)
    end
end

function EventManager:invoke(name, ...)
    local event = self.events[name]

    if event then
        event:invoke(...)
    end
end