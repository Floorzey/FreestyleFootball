--[[
    Script Path: Game/ReplicatedStorage/Modules/HitboxHandlerPlayers
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
    v1.FilterDescendantsInstances = {game.Workspace.CharacterContainer}
    local v2
    if (a1.isSphere or false) ~= true then
        v2 = workspace:GetPartBoundsInBox(cframe_1, size_1, v1)
    else
        v2 = workspace:GetPartBoundsInRadius(cframe_1.Position, size_1.X / 2, v1)
    end
    local tbl_2 = {}
    for v3, value_1 in pairs(v2) do
        if value_1.Name ~= "HumanoidRootPart" then
            continue
        end
        if value_1.Parent ~= a2 then
            table.insert(tbl_2, value_1)
        end
    end
    return tbl_2
end
return tbl_1