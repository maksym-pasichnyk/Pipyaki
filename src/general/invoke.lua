function invoke(self, name, ...)
    local action = self[name]
    
    if action then
        action(self, ...)
    end
end