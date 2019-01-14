function invoke(self, name, ...)
    if self[name] then
        self[name](self, ...)
    end
end