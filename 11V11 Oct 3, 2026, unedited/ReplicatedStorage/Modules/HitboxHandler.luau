--[[
    Script Path: Game/ReplicatedStorage/Modules/HitboxHandler
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local tbl_1 = {}
tbl_1.Create = function(a1, a2)
    --[[
      line: 3
    ]]
    local _ = game.Players:GetPlayerFromCharacter(a2)
    local size_1 = a1.size
    local cframe_1 = a1.cframe
    local v1 = OverlapParams.new()
    v1.FilterType = Enum.RaycastFilterType.Include
    v1.FilterDescendantsInstances = {game.Workspace.Temp}
    local v2
    if (a1.isSphere or false) ~= true then
        v2 = workspace:GetPartBoundsInBox(cframe_1, size_1, v1)
    else
        v2 = workspace:GetPartBoundsInRadius(cframe_1.Position, size_1.X / 2, v1)
    end
    for v3, value_1 in pairs(v2) do
        if value_1.Name ~= "Ball" or value_1:FindFirstChild("Scored") then
            continue
        end
        return value_1
    end
    return nil
end
return tbl_1