module()

Utils = {}
function Utils.contains(list, item)
    for k, v in pairs(list) do
        if rawequal(v, item) then
            return true
        end
    end

    return false
end

function Utils.remove(list, item)
    for k, v in pairs(list) do
        if rawequal(v, item) then
            table.remove(list, k)
            return true
        end
    end

    return false
end