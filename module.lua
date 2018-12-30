local module = {}
function module.new()
    return setmetatable({ _L = {} }, { 
        __index = function(self, key)
            for k, env in pairs(self._L) do
                local value = env[key]
                if value then
                    return value
                end
            end

            return _G[key]
        end
    })
end

local modules = {}
function module.load(path)
    local env = modules[path]

    if not env then
        env = module.new()
        modules[path] = env
        assert(pcall(setfenv(loadfile(path..'.lua'), env)))
    end

    local L = {}
    for k, v in pairs(env) do
        L[k] = v
    end
    return L
end

_G.module = module
_G.import = function(path)
    local L = getfenv(2)._L
    if not L[path] then
        L[path] = module.load(path)
    end
end
_G.export = function(name, value)
    _G[name] = value or getfenv(2)[name]
end

setfenv(3, module.new())