--[[
    Script Path: Game/Players/Player/PlayerScripts/PlayerModule/ControlModule/PathDisplay
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local tbl_upv_1 = {}
tbl_upv_1.spacing = 8
tbl_upv_1.image = "rbxasset://textures/Cursors/Gamepad/Pointer.png"
tbl_upv_1.imageSize = Vector2.new(2, 2)
local u1 = {}
local tbl_upv_2 = {}
local u2 = Instance.new("Model")
u2.Name = "PathDisplayPoints"
local v1 = Instance.new("Part")
v1.Anchored = true
v1.CanCollide = false
v1.Transparency = 1
v1.Name = "PathDisplayAdornee"
v1.CFrame = CFrame.new(0, 0, 0)
v1.Parent = u2
local tbl_upv_3 = {}
local u3 = 30
for n_1 = 1, u3 do
    local v2 = Instance.new("ImageHandleAdornment")
    v2.Archivable = false
    v2.Adornee = v1
    v2.Image = tbl_upv_1.image
    v2.Size = tbl_upv_1.imageSize
    tbl_upv_3[n_1] = v2
end
local function retrieveFromPool()
    --[[
      name: retrieveFromPool
      line: 34
      upvalues:
        tbl_upv_3 (copy, index: 1)
        u3 (ref,  index: 2)
    ]]
    local v3 = tbl_upv_3[1]
    if not v3 then
        return nil
    end
    local v4 = u3
    tbl_upv_3[1] = tbl_upv_3[u3]
    tbl_upv_3[v4] = nil
    u3 = u3 - 1
    return v3
end
local function returnToPool(a1)
    --[[
      name: returnToPool
      line: 45
      upvalues:
        u3 (ref,  index: 1)
        tbl_upv_3 (copy, index: 2)
    ]]
    u3 = u3 + 1
    tbl_upv_3[u3] = a1
end
local function renderPoint(a1, a2)
    --[[
      name: renderPoint
      line: 50
      upvalues:
        u3 (ref,  index: 1)
        tbl_upv_3 (copy, index: 2)
        u2 (copy, index: 3)
    ]]
    if u3 == 0 then
        return nil
    end
    local v5, v6, v7 = workspace:FindPartOnRayWithIgnoreList(Ray.new(a1 + Vector3.new(0, 2, 0), Vector3.new(0, -8, 0)), {game.Players.LocalPlayer.Character, workspace.CurrentCamera})
    if not v5 then
        return nil
    end
    local v8 = CFrame.new(v6, v6 + v7)
    local v9 = tbl_upv_3[1]
    local v10
    if v9 then
        local v11 = u3
        tbl_upv_3[1] = tbl_upv_3[u3]
        tbl_upv_3[v11] = nil
        u3 = u3 - 1
        v10 = v9
    else
        v10 = nil
    end
    v10.CFrame = v8
    v10.Parent = u2
    return v10
end
function tbl_upv_1.setCurrentPoints(a1)
    --[[
      name: setCurrentPoints
      line: 69
      upvalues:
        u1 (ref, index: 1)
    ]]
    if typeof(a1) ~= "table" then
        u1 = {}
    else
        u1 = a1
    end
end
function tbl_upv_1.clearRenderedPath()
    --[[
      name: clearRenderedPath
      line: 77
      upvalues:
        tbl_upv_2 (ref,  index: 1)
        u3 (ref,  index: 2)
        tbl_upv_3 (copy, index: 3)
        u2 (copy, index: 4)
    ]]
    for _, value_1 in ipairs(tbl_upv_2) do
        value_1.Parent = nil
        u3 = u3 + 1
        tbl_upv_3[u3] = value_1
    end
    tbl_upv_2 = {}
    u2.Parent = nil
end
function tbl_upv_1.renderPath()
    --[[
      name: renderPath
      line: 86
      upvalues:
        tbl_upv_1 (copy, index: 1)
        u1 (ref,  index: 2)
        tbl_upv_2 (ref,  index: 3)
        renderPoint (copy, index: 4)
        u2 (copy, index: 5)
    ]]
    tbl_upv_1.clearRenderedPath()
    if not u1 or #u1 == 0 then
        return
    end
    local v12 = #u1
    local v13 = 0
    tbl_upv_2[1] = renderPoint(u1[v12], true)
    if not tbl_upv_2[1] then
        return
    end
    while true do
        local v14 = u1[v12]
        local v15 = u1[v12 - 1]
        if v12 < 2 then
            break
        end
        local v16 = v15 - v14
        local magnitude_1 = v16.magnitude
        if magnitude_1 < v13 then
            local v17 = v13 - magnitude_1
            v12 = v12 - 1
            v13 = v17
            continue
        end
        local v18 = renderPoint(v14 + (v16.unit * v13), false)
        if v18 then
            tbl_upv_2[#tbl_upv_2 + 1] = v18
        end
        v13 = v13 + tbl_upv_1.spacing
    end
    u2.Parent = workspace.CurrentCamera
end
return tbl_upv_1