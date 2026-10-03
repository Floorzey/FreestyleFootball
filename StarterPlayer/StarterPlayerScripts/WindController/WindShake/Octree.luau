--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/WindController/WindShake/Octree
    Class: ModuleScript
    Time: 2026-10-03 12:27:04
--]]

local OctreeNode_1 = require(script.OctreeNode)
local OctreeRegionUtils_1 = require(script.OctreeRegionUtils)
local tbl_upv_1 = {{0.25, 0.25, -0.25}, {-0.25, 0.25, -0.25}, {0.25, 0.25, 0.25}, {-0.25, 0.25, 0.25}, {0.25, -0.25, -0.25}, {-0.25, -0.25, -0.25}, {0.25, -0.25, 0.25}, {-0.25, -0.25, 0.25}}
local tbl_upv_2 = {ClassName = "Octree"}
tbl_upv_2.__index = tbl_upv_2
local new_upv_1 = OctreeNode_1.new
local GetNeighborsWithinRadius_upv_1 = OctreeRegionUtils_1.GetNeighborsWithinRadius
function tbl_upv_2.new()
    --[[
      name: new
      line: 28
      upvalues:
        tbl_upv_2 (copy, index: 1)
    ]]
    return (setmetatable({MaxDepth = 4, MaxRegionSize = table.create(3, 512), RegionHashMap = {}}, tbl_upv_2))
end
function tbl_upv_2.ClearNodes(a1)
    --[[
      name: ClearNodes
      line: 36
    ]]
    a1.MaxDepth = 4
    a1.MaxRegionSize = table.create(3, 512)
    table.clear(a1.RegionHashMap)
end
function tbl_upv_2.GetAllNodes(a1)
    --[[
      name: GetAllNodes
      line: 42
    ]]
    local tbl_3 = {}
    local v1 = 0
    for _, value_1 in next, a1.RegionHashMap do
        for v2, value_2 in ipairs(value_1) do
            for key_1 in next, value_2.Nodes do
                v1 = v1 + 1
                tbl_3[v1] = key_1
            end
        end
    end
    return tbl_3
end
function tbl_upv_2.CreateNode(a1, a2, a3)
    --[[
      name: CreateNode
      line: 58
      upvalues:
        new_upv_1 (copy, index: 1)
    ]]
    if typeof(a2) ~= "Vector3" then
        error("Bad position value")
    end
    if not (a3) then
        error("Bad object value.")
    end
    local v2 = new_upv_1(a1, a3)
    v2:SetPosition(a2)
    return v2
end
function tbl_upv_2.RadiusSearch(a1, a2, a3)
    --[[
      name: RadiusSearch
      line: 72
      upvalues:
        GetNeighborsWithinRadius_upv_1 (copy, index: 1)
    ]]
    if typeof(a2) ~= "Vector3" then
        error("Bad position value")
    end
    if type(a3) ~= "number" then
        error("Bad radius value")
    end
    local X_1 = a2.X
    local Y_1 = a2.Y
    local Z_1 = a2.Z
    local tbl_4 = {}
    local tbl_5 = {}
    local v3 = 0
    local v4 = 0
    local v5 = a3 + 0.8660254037844386 * a1.MaxRegionSize[1]
    for _, value_3 in next, a1.RegionHashMap do
        for v11, value_4 in ipairs(value_3) do
            local Position_1 = value_4.Position
            local v6 = X_1 - Position_1[1]
            local v7 = Y_1 - Position_1[2]
            local v8 = Z_1 - Position_1[3]
            if ((v6 * v6) + (v7 * v7)) + (v8 * v8) <= (v5 * v5) + 1e-09 then
                local v9, v10 = GetNeighborsWithinRadius_upv_1(value_4, a3, X_1, Y_1, Z_1, tbl_4, tbl_5, a1.MaxDepth, v3, v4)
                v3, v4 = v9, v10
            end
        end
    end
    return tbl_4, tbl_5
end
local function NearestNeighborSort(a1, a2)
    --[[
      name: NearestNeighborSort
      line: 110
    ]]
    return a1.Distance2 < a2.Distance2
end
function tbl_upv_2.KNearestNeighborsSearch(a1, a2, a3, a4)
    --[[
      name: KNearestNeighborsSearch
      line: 114
      upvalues:
        GetNeighborsWithinRadius_upv_1 (copy, index: 1)
        NearestNeighborSort (copy, index: 2)
    ]]
    if typeof(a2) ~= "Vector3" then
        error("Bad position value")
    end
    if type(a4) ~= "number" then
        error("Bad radius value")
    end
    local X_2 = a2.X
    local Y_2 = a2.Y
    local Z_2 = a2.Z
    local tbl_6 = {}
    local tbl_7 = {}
    local v11 = 0
    local v12 = 0
    local v13 = a4 + 0.8660254037844386 * a1.MaxRegionSize[1]
    for _, value_5 in next, a1.RegionHashMap do
        for v24, value_6 in ipairs(value_5) do
            local Position_2 = value_6.Position
            local v14 = X_2 - Position_2[1]
            local v15 = Y_2 - Position_2[2]
            local v16 = Z_2 - Position_2[3]
            if ((v14 * v14) + (v15 * v15)) + (v16 * v16) <= (v13 * v13) + 1e-09 then
                local v17, v18 = GetNeighborsWithinRadius_upv_1(value_6, a4, X_2, Y_2, Z_2, tbl_6, tbl_7, a1.MaxDepth, v11, v12)
                v11, v12 = v17, v18
            end
        end
    end
    local v19 = table.create(v12)
    for key_2, value_7 in ipairs(tbl_7) do
        v19[key_2] = {Distance2 = value_7, Index = key_2}
    end
    table.sort(v19, NearestNeighborSort)
    local v20 = math.min(v12, a3)
    local v21 = table.create(v20)
    local v22 = table.create(v20)
    for n_1 = 1, v20 do
        local v23 = v19[n_1]
        v22[n_1] = v23.Distance2
        v21[n_1] = tbl_6[v23.Index]
    end
    return v21, v22
end
local function GetOrCreateRegion(a1, a2, a3, a4)
    --[[
      name: GetOrCreateRegion
      line: 171
    ]]
    local RegionHashMap_1 = a1.RegionHashMap
    local MaxRegionSize_1 = a1.MaxRegionSize
    local v24 = MaxRegionSize_1[1]
    local v25 = MaxRegionSize_1[2]
    local v26 = MaxRegionSize_1[3]
    local v27 = math.floor((a2 / v24) + 0.5)
    local v28 = math.floor((a3 / v25) + 0.5)
    local v29 = math.floor((a4 / v26) + 0.5)
    local v30 = (v27 * 73856093) + (v28 * 19351301) + v29 * 83492791
    local v31 = RegionHashMap_1[v30]
    if not (v31) then
        v31 = {}
        RegionHashMap_1[v30] = v31
    end
    local v32 = v24 * v27
    local v33 = v25 * v28
    local v34 = v26 * v29
    for _, value_8 in ipairs(v31) do
        local Position_3 = value_8.Position
        if Position_3[1] ~= v32 or Position_3[2] ~= v33 or Position_3[3] ~= v34 then
            continue
        end
        return value_8
    end
    local v35 = v24 / 2
    local v36 = v25 / 2
    local v37 = v26 / 2
    local tbl_8 = {v32 - v35, v33 - v36, v34 - v37}
    local tbl_9 = {v32, v33, v34}
    local tbl_10 = {v24, v25, v26}
    local tbl_11 = {v32 + v35, v33 + v36, v34 + v37}
    local tbl_12 = {NodeCount = 0, Depth = 1}
    tbl_12.LowerBounds = tbl_8
    tbl_12.Nodes = {}
    tbl_12.Position = tbl_9
    tbl_12.Size = tbl_10
    tbl_12.SubRegions = {}
    tbl_12.UpperBounds = tbl_11
    table.insert(v31, tbl_12)
    return tbl_12
end
function tbl_upv_2.GetOrCreateLowestSubRegion(a1, a2, a3, a4)
    --[[
      name: GetOrCreateLowestSubRegion
      line: 216
      upvalues:
        GetOrCreateRegion (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
    ]]
    local v38 = GetOrCreateRegion(a1, a2, a3, a4)
    local v39 = nil
    local v40 = v38
    for _ = v38.Depth, a1.MaxDepth do
        local Position_4 = v40.Position
        local v41 = ((Position_4[1] < a2) and 1) or 2
        v41 = ((a3 <= Position_4[2]) and (v41 + 4)) or v41
        v41 = ((Position_4[3] <= a4) and (v41 + 2)) or v41
        local SubRegions_1 = v40.SubRegions
        v39 = SubRegions_1[v41]
        if not (v39) then
            local v51 = v40.Size
            local v52 = tbl_upv_1[v41]
            local v53 = v40.Size[1]
            local v54 = v40.Size[2]
            local v55 = v40.Size[3]
            local v42 = Position_4[1] + tbl_upv_1[v41][1] * v40.Size[1]
            local v43 = Position_4[2] + tbl_upv_1[v41][2] * v40.Size[2]
            local v44 = Position_4[3] + tbl_upv_1[v41][3] * v40.Size[3]
            local v45 = v40.Size[1] / 2
            local v46 = v40.Size[2] / 2
            local v47 = v40.Size[3] / 2
            local v48 = v40.Size[1] / 2 / 2
            local v49 = v40.Size[2] / 2 / 2
            local v50 = v40.Size[3] / 2 / 2
            local tbl_13 = {Position_4[1] + tbl_upv_1[v41][1] * v40.Size[1] - v40.Size[1] / 2 / 2, Position_4[2] + tbl_upv_1[v41][2] * v40.Size[2] - v40.Size[2] / 2 / 2, Position_4[3] + tbl_upv_1[v41][3] * v40.Size[3] - v40.Size[3] / 2 / 2}
            local tbl_14 = {v42, v43, v44}
            local tbl_15 = {v45, v46, v47}
            local tbl_16 = {v42 + v48, v43 + v49, v44 + v50}
            local tbl_17 = {LowerBounds = 0, UpperBounds = 0, SubRegions = 0, NodeCount = 0, ParentIndex = 0, Position = 0, Nodes = 0, Depth = 0, Parent = 0, Size = 0}
            tbl_17.Depth = (v40 and (v40.Depth + 1)) or 1
            tbl_17.LowerBounds = tbl_13
            tbl_17.Nodes = {}
            tbl_17.Parent = v40
            tbl_17.ParentIndex = v41
            tbl_17.Position = tbl_14
            tbl_17.Size = tbl_15
            tbl_17.SubRegions = {}
            tbl_17.UpperBounds = tbl_16
            SubRegions_1[v41] = tbl_17
            v39 = tbl_17
        end
        v40 = v39
    end
    return v40
end
return tbl_upv_2