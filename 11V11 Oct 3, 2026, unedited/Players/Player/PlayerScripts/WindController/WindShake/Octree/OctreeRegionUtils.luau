--[[
    Script Path: Game/Players/Player/PlayerScripts/WindController/WindShake/Octree/OctreeRegionUtils
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local tbl_1 = {}
local function GetNeighborsWithinRadius(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
    --[[
      name: GetNeighborsWithinRadius
      line: 23
      upvalues:
        GetNeighborsWithinRadius (copy, index: 1)
    ]]
    if not (a8) then
        error("Missing MaxDepth.")
    end
    local v1 = a2 + 0.8660254037844386 * (a1.Size[1] / 2)
    for _, value_1 in next, a1.SubRegions do
        local Position_1 = value_1.Position
        local v2 = a3 - Position_1[1]
        local v3 = a4 - Position_1[2]
        local v4 = a5 - Position_1[3]
        if not (((v2 * v2) + (v3 * v3)) + (v4 * v4) <= (v1 * v1) + 1e-06) then
            continue
        end
        if value_1.Depth ~= a8 then
            local v5, v6 = GetNeighborsWithinRadius(value_1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
            a9, a10 = v5, v6
            continue
        end
        for key_1 in next, value_1.Nodes do
            local v7 = key_1.PositionX - a3
            local v8 = key_1.PositionY - a4
            local v9 = key_1.PositionZ - a5
            local v10 = (v7 * v7) + (v8 * v8) + v9 * v9
            if v10 <= a2 * a2 then
                a9 = a9 + 1
                a10 = a10 + 1
                a6[a9] = key_1.Object
                a7[a10] = v10
            end
        end
    end
    return a9, a10
end
tbl_1.GetNeighborsWithinRadius = GetNeighborsWithinRadius
return tbl_1