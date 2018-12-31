local textures = {}

AssetManager = {}
function AssetManager:readFile(path)
    local file = love.filesystem.newFile('assets/'..path, 'r')
    local data = file:read()
    file:close()
    return data
end

function AssetManager:loadTexture(path)
    local image = textures[path]
    if not image then
        image = love.graphics.newImage('assets/'..path)
        image:setFilter('nearest', 'nearest')
        textures[path] = image
    end
    return image
end