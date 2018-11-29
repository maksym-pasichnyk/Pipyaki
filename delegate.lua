module()

import 'class'

Delegate = class()
function Delegate:new(wrap)
    self.wrap = wrap
    self.callbacks = {}
end

function Delegate:invoke(...)
    if self.invoking then
        return
    end

    self.invoking = true

    local callbacks = {}
    for k, v in pairs(self.callbacks) do
        table.insert(callbacks, v)
    end
    
    for k, callback in pairs(callbacks) do
        if self.prevent then
            self.prevent = true
            return
        end
        
        pcall(callback, ...)
    end

    if self.wrap then
        pcall(self.wrap, ...)
    end

    self.invoking = false
end

function Delegate:__call(...)
    self:invoke(...)
end

function Delegate:bind(callback)
    for k, v in pairs(self.callbacks) do
        if rawequal(v, callback) then
            return false
        end
    end

    table.insert(self.callbacks, callback)

    return true
end

function Delegate:unbind(callback)
    for k, v in pairs(self.callbacks) do
        if rawequal(v, callback) then
            table.remove(self.callbacks, k)
            return true
        end
    end

    return false
end

function Delegate:cancel()
    if self.invoking then
        self.prevent = true
        self.invoking = false
    end
end

function Delegate:clear()
    self.callbacks = {}
end