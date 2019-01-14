
import 'general/input'

local function getInputAxis()
    local horizontal = Input:GetAxis 'leftx#1'
    local vertical = Input:GetAxis 'lefty#1'

    if math.abs(horizontal) > math.abs(vertical) then
        vertical = 0
    else
        horizontal = 0
    end

    return horizontal, vertical
end

PlayerController = {}
function PlayerController.update()
    local h, v = getInputAxis()

    if Input:GetAnyButton {'left', 'dpleft#1', 'a'} or h < 0 then
        self:move('left')
    end
    
    if Input:GetAnyButton {'right', 'dpright#1', 'd'} or h > 0 then
        self:move('right')
    end
    
    if Input:GetAnyButton {'up', 'dpup#1', 'w'} or v < 0 then
        self:move('up')
    end
    
    if Input:GetAnyButton {'down', 'dpdown#1', 's'} or v > 0 then
        self:move('down')
    end
end