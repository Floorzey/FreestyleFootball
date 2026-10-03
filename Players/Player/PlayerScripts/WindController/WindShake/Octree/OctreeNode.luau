--[[
    Script Path: Game/Players/Player/PlayerScripts/WindController/WindShake/Octree/OctreeNode
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local tbl_upv_1 = {ClassName = "OctreeNode"}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new(a1, a2)
    --[[
      name: new
      line: 7
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local tbl_2 = {Octree = 0, Object = 0}
    tbl_2.Octree = a1 or error("No octree")
    tbl_2.Object = a2 or error("No object")
    return (setmetatable(tbl_2, tbl_upv_1))
end
function tbl_upv_1.KNearestNeighborsSearch(a1, a2, a3)
    --[[
      name: KNearestNeighborsSearch
      line: 20
    ]]
    return a1.Octree:KNearestNeighborsSearch(a1.Position, a2, a3)
end
function tbl_upv_1.GetObject(a1)
    --[[
      name: GetObject
      line: 24
    ]]
    warn("OctreeNode:GetObject is deprecated.")
    return a1.Object
end
function tbl_upv_1.RadiusSearch(a1, a2)
    --[[
      name: RadiusSearch
      line: 29
    ]]
    return a1.Octree:RadiusSearch(a1.Position, a2)
end
function tbl_upv_1.GetPosition(a1)
    --[[
      name: GetPosition
      line: 33
    ]]
    warn("OctreeNode:GetPosition is deprecated.")
    return a1.Position
end
function tbl_upv_1.GetRawPosition(a1)
    --[[
      name: GetRawPosition
      line: 38
    ]]
    return a1.PositionX, a1.PositionY, a1.PositionZ
end
function tbl_upv_1.SetPosition(a1, a2)
    --[[
      name: SetPosition
      line: 42
    ]]
    if a1.Position == a2 then
        return
    end
    local X_1 = a2.X
    local Y_1 = a2.Y
    local Z_1 = a2.Z
    a1.PositionX = X_1
    a1.PositionY = Y_1
    a1.PositionZ = Z_1
    a1.Position = a2
    local v3, v4 = nil, nil
    if a1.CurrentLowestRegion then
        local CurrentLowestRegion_1 = a1.CurrentLowestRegion
        v3 = CurrentLowestRegion_1.LowerBounds
        v4 = CurrentLowestRegion_1.UpperBounds
        if v3[1] <= X_1 and X_1 <= v4[1] and v3[2] <= Y_1 and Y_1 <= v4[2] and v3[3] <= Z_1 and Z_1 <= v4[3] then
            return
        end
    end
    local v5 = a1.Octree:GetOrCreateLowestSubRegion(X_1, Y_1, Z_1)
    local v6 = nil
    if a1.CurrentLowestRegion then
        v6 = a1.CurrentLowestRegion
        if v6.Depth ~= v5.Depth then
            error("fromLowest.Depth ~= toLowest.Depth")
        end
        if v6 == v5 then
            error("fromLowest == toLowest")
        end
        local v7
        v4, v7 = v6, v5
        while v4 ~= v7 do
            local Nodes_1 = v4.Nodes
            if not (Nodes_1[a1]) then
                error("CurrentFrom.Nodes doesn't have a node here.")
            end
            local NodeCount_1 = v4.NodeCount
            if NodeCount_1 <= 0 then
                error("NodeCount is <= 0.")
            end
            NodeCount_1 = NodeCount_1 - 1
            Nodes_1[a1] = nil
            v4.NodeCount = NodeCount_1
            local ParentIndex_1 = v4.ParentIndex
            if NodeCount_1 <= 0 and ParentIndex_1 then
                local Parent_1 = v4.Parent
                if not (Parent_1) then
                    error("CurrentFrom.Parent doesn't exist.")
                end
                local SubRegions_1 = Parent_1.SubRegions
                if SubRegions_1[ParentIndex_1] ~= v4 then
                    error("Failed equality check.")
                end
                SubRegions_1[ParentIndex_1] = nil
            end
            local Nodes_2 = v7.Nodes
            if Nodes_2[a1] then
                error("CurrentTo.Nodes already has a node here.")
            end
            Nodes_2[a1] = a1
            v7.NodeCount = v7.NodeCount + 1
            v4, v7 = v4.Parent, v7.Parent
        end
    else
        v3 = v5
        while v3 do
            local Nodes_3 = v3.Nodes
            if not (Nodes_3[a1]) then
                Nodes_3[a1] = a1
                v3.NodeCount = v3.NodeCount + 1
            end
            v3 = v3.Parent
        end
    end
    a1.CurrentLowestRegion = v5
end
function tbl_upv_1.Destroy(a1)
    --[[
      name: Destroy
      line: 137
    ]]
    local CurrentLowestRegion_2 = a1.CurrentLowestRegion
    if CurrentLowestRegion_2 then
        local v8 = CurrentLowestRegion_2
        while v8 do
            local Nodes_4 = v8.Nodes
            if not (Nodes_4[a1]) then
                error("CurrentFrom.Nodes doesn't have a node here.")
            end
            local NodeCount_2 = v8.NodeCount
            if NodeCount_2 <= 0 then
                error("NodeCount is <= 0.")
            end
            NodeCount_2 = NodeCount_2 - 1
            Nodes_4[a1] = nil
            v8.NodeCount = NodeCount_2
            local Parent_2 = v8.Parent
            local ParentIndex_2 = v8.ParentIndex
            if not (NodeCount_2 <= 0) or not (ParentIndex_2) then
                v8 = Parent_2
                continue
            end
            if not (Parent_2) then
                error("Current.Parent doesn't exist.")
            end
            local SubRegions_2 = Parent_2.SubRegions
            if SubRegions_2[ParentIndex_2] ~= v8 then
                error("Failed equality check.")
            end
            SubRegions_2[ParentIndex_2] = nil
            v8 = Parent_2
        end
    end
end
return tbl_upv_1