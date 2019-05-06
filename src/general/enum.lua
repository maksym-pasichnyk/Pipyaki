return function(keys)
    local out = {}
    local ID = 0
    for i, v in ipairs(keys) do
        out[v] = ID
        ID = ID + 1
    end
    return out
end