local string_format = string.format
local string_gmatch = string.gmatch
local string_gsub   = string.gsub
local string_match  = string.match
local table_concat  = table.concat
local table_insert  = table.insert

local module = {
    loaded = {};
    preload = {};
    path = package.path
}

local function path_loader(name, paths, loader_func)
    local errors = {}
    local loader

    name = string_gsub(name, '%.', '/')

    for path in string_gmatch(paths, '[^;]+') do
        path = string_gsub(path, '%?', name)

        local errmsg

        loader, errmsg = loader_func(path)

        if loader then
            break
        end

        table_insert(errors, string.format("no file '%s'", path))
    end

    if loader then
        return loader
    end

    return table_concat(errors, '\n') .. '\n'
end

local function preload_loader(name)
    local chunk = module.preload[name]
    if chunk then
        return chunk
    end
    return string_format("no field package.preload['%s']\n", name)
end

local function lua_loader(name)
    return path_loader(name, module.path, loadfile)
end

local loaders = {
    preload_loader,
    lua_loader,
}

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

local function findchunk(name)
    local errors = {
        string.format("module '%s' not found\n", name) 
    }

    for _, loader in ipairs(loaders) do
        local chunk = loader(name)

        if type(chunk) == 'function' then
            return chunk
        elseif type(chunk) == 'string' then
            table_insert(errors, chunk)
        end
    end

    return nil, table_concat(errors, '')
end

function module.load(name)
    local env = module.loaded[name]
    if env == nil then
        local chunk, errors = findchunk(name)
        if not chunk then
            error(errors, 2)
        end

        env = module.new()
        module.loaded[name] = env

        setfenv(chunk, env)()
    end
    return env
end

_G.module = module
_G.import = function(name)
    local L = getfenv(2)._L
    if not L[name] then
        L[name] = module.load(name)
    end
end
-- _G.export = function(name, value)
--     _G[name] = value or getfenv(2)[name]
-- end

setfenv(3, module.new())