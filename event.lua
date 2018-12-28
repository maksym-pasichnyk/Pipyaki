import 'class'

Event = class()
function Event:new()
    self.listeners = {}
end

function Event:add(listener)
    for k, v in pairs(self.listeners) do
        if rawequal(v, listener) then
            return false
        end
    end

    table.insert(self.listeners, listener)

    return true
end

function Event:remove(listener)    
    for k, v in pairs(self.listeners) do
        if rawequal(v, listener) then
            table.remove(self.listeners, k)
            return true
        end
    end

    return false
end

function Event:clear()
    self.listeners = {}
end

function Event:invoke(...)
    for k, listener in pairs(self.listeners) do
        listener(...)
    end
end