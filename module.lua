_G.modules = {}
_G.module = function()
    local file = debug.getinfo(2,'S').short_src
    assert(_G.modules[file] == nil, 'module \''..file..'\' is already exist')

    local L = {}

    local module = setmetatable({}, { 
        __index = function(self, k)
            if k == '_L' then
                return L
            end

            return L[k] or _G[k]
        end
    })
    setfenv(2, module)
    
    _G.modules[file] = module
end

_G.import = function(name, packed)
    local module = _G.modules[name..'.lua']
    
    if not module then
        local status, result = pcall(loadfile, name..'.lua')

        assert(status, result)
        assert(pcall(setfenv(result, setmetatable({}, { __index = _G }))))
        module = _G.modules[name..'.lua']
        assert(module, 'module \''..name..'\' not found')
    end

    local env = packed and {} or getfenv(2)._L
    for k, v in pairs(module) do
        env[k] = v
    end

    return env
end