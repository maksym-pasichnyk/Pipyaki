import 'class'

Resources = class()
Resources.textures = {}

function Resources:ReadFile(path)
    local file = love.filesystem.newFile('assets/'..path, 'r')
    local data = file:read()
    file:close()
    return data
end

function Resources:LoadTexture(path)
    local image = self.textures[path]
    if not image then
        image = love.graphics.newImage('assets/'..path)
        image:setFilter('nearest', 'nearest')
        self.textures[path] = image
    end
    return image
end