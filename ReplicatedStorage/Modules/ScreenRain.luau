--[[
    Script Path: Game/ReplicatedStorage/Modules/ScreenRain
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local tbl_upv_1 = {UpdateFreq = 0.022222222222222223, Fade = 1.5, Rate = 8, Size = 0.09}
tbl_upv_1.Tint = Color3.fromRGB(226, 244, 255)
local Players_1 = game:GetService("Players")
local RunService_1 = game:GetService("RunService")
local ObjectPool_1 = require(script.ObjectPool)
local CurrentCamera_upv_1 = workspace.CurrentCamera
local LocalPlayer_1 = Players_1.LocalPlayer
local GameSettings_upv_1 = UserSettings().GameSettings
local u1 = GameSettings_upv_1.SavedQualityLevel.Value >= 8
GameSettings_upv_1:GetPropertyChangedSignal("SavedQualityLevel"):Connect(
    function()
        --[[
          line: 41
          upvalues:
            u1 (ref,  index: 1)
            GameSettings_upv_1 (copy, index: 2)
        ]]
        local v1 = true
        if not (GameSettings_upv_1.SavedQualityLevel.Value >= 8) then
            v1 = GameSettings_upv_1.SavedQualityLevel.Value == 0
        end
        u1 = v1
    end
)
tbl_upv_1.Rate = tbl_upv_1.Rate or 5
tbl_upv_1.Size = tbl_upv_1.Size or 1.5
tbl_upv_1.Tint = tbl_upv_1.Tint or Color3.fromRGB(226, 244, 255)
tbl_upv_1.Fade = tbl_upv_1.Fade or 1.5
tbl_upv_1.UpdateFreq = tbl_upv_1.UpdateFreq or 0.022222222222222223
local tbl_upv_2 = {}
local u2 = 0
local function addToIgnore(a1)
    --[[
      name: addToIgnore
      line: 55
      upvalues:
        u2 (ref,  index: 1)
        tbl_upv_2 (copy, index: 2)
    ]]
    if a1 then
        local v3 = u2 + 1
        u2 = u2 + 1
        tbl_upv_2[v3] = a1
        local _ = nil
        local v4 = a1.AncestryChanged:Connect(function() end)
        _ = v4
    end
end
local Character_1 = LocalPlayer_1.Character
if Character_1 then
    local v5 = u2 + 1
    u2 = u2 + 1
    tbl_upv_2[v5] = Character_1
    local _ = nil
    local v6 = Character_1.AncestryChanged:Connect(function() end)
    _ = v6
end
LocalPlayer_1.CharacterAdded:Connect(addToIgnore)
local u3 = Instance.new("Folder")
u3.Name = "ScreenDroplets"
u3.Parent = CurrentCamera_upv_1
if u3 then
    local u4 = u2 + 1
    u2 = u2 + 1
    tbl_upv_2[u4] = u3
    local u5 = nil
    local v7 = u3.AncestryChanged:Connect(
        function()
            --[[
              line: 62
              upvalues:
                u3 (copy, index: 1)
                u5 (ref,  index: 2)
                tbl_upv_2 (copy, index: 3)
                u4 (copy, index: 4)
                u2 (ref,  index: 5)
            ]]
            if u3:IsDescendantOf(game) then
                return
            end
            u5:Disconnect()
            tbl_upv_2[u4] = tbl_upv_2[u2]
            tbl_upv_2[u2] = nil
            u2 = u2 - 1
        end
    )
    u5 = v7
end
local tbl_upv_3 = {}
local tbl_upv_4 = {}
local CFrame_upv_1 = CurrentCamera_upv_1.CFrame
local u6 = tbl_upv_1.Rate * tbl_upv_1.Fade * 3
RunService_1:BindToRenderStep(
    "ScreenRainUpdate",
    Enum.RenderPriority.Camera.Value + 2,
    function()
        --[[
          line: 91
          upvalues:
            CFrame_upv_1 (ref,  index: 1)
            CurrentCamera_upv_1 (copy, index: 2)
            u6 (ref,  index: 3)
            tbl_upv_4 (copy, index: 4)
        ]]
        CFrame_upv_1 = CurrentCamera_upv_1.CFrame
        local v8 = table.create(u6)
        local v9 = table.create(u6)
        local v10 = 0
        local v11 = math.tan(math.rad(CurrentCamera_upv_1.FieldOfView * 0.5)) / 0.7002075382097097
        for key_1, value_1 in pairs(tbl_upv_4) do
            local v12 = v10 + 1
            local Position_1 = value_1.Position
            local v13 = CFrame.new(Vector3.new(Position_1.X * v11, Position_1.Y * v11, Position_1.Z))
            v9[v12] = CFrame_upv_1 * (v13 * (value_1 - value_1.Position))
            v8[v12] = key_1
            v10 = v12
        end
        u6 = v10
        workspace:BulkMoveTo(v8, v9, Enum.BulkMoveMode.FireCFrameChanged)
    end
)
local v14 = Instance.new("Part")
v14.Name = "Droplet"
v14.Material = Enum.Material.Glass
v14.CastShadow = false
v14.CanCollide = false
v14.CanQuery = false
v14.CanTouch = false
v14.Anchored = true
v14.Transparency = 0.5
v14.Color = tbl_upv_1.Tint
v14.Size = Vector3.new(1, 1, 1)
local new_1 = Instance.new
local v15 = new_1("SpecialMesh")
v15.Name = "Mesh"
v15.MeshType = Enum.MeshType.Sphere
v15.Parent = v14
local u7 = ObjectPool_1.new(v14, (tbl_upv_1.Rate * tbl_upv_1.Fade) * 3)
local function Cleanup(a1)
    --[[
      name: Cleanup
      line: 136
      upvalues:
        tbl_upv_3 (copy, index: 1)
        tbl_upv_4 (copy, index: 2)
        u7 (ref,  index: 3)
    ]]
    tbl_upv_3[a1] = nil
    tbl_upv_4[a1] = nil
    u7:Return(a1)
end
local function UnderObject(a1, a2)
    --[[
      name: UnderObject
      line: 143
      upvalues:
        tbl_upv_2 (copy, index: 1)
        UnderObject (copy, index: 2)
    ]]
    a2 = a2 or 120
    local v16, v17 = workspace:FindPartOnRayWithIgnoreList(Ray.new(a1, Vector3.new(0, 1, 0) * a2), tbl_upv_2)
    if v16 then
        if v16.Transparency == 1 then
            return (UnderObject(v17 + Vector3.new(0, 1, 0), a2 - (a1 - v17).Magnitude))
        end
        return true
    end
    return false
end
local function CreateDroplet()
    --[[
      name: CreateDroplet
      line: 155
      upvalues:
        tbl_upv_1 (copy, index: 1)
        u7 (ref,  index: 2)
        tbl_upv_4 (copy, index: 3)
        tbl_upv_3 (copy, index: 4)
        u3 (copy, index: 5)
    ]]
    local v18 = tbl_upv_1.Size + math.random((tbl_upv_1.Size / 3) * -10, (tbl_upv_1.Size / 3) * 10) / 10
    local v19 = u7:Get()
    v19.Mesh.Scale = Vector3.new(v18, v18, v18)
    v19.Mesh.Offset = Vector3.new(0, 0, 0)
    v19.Color = tbl_upv_1.Tint
    v19.Transparency = 0.7
    local v20 = CFrame.new(math.random(-120, 120) / 100, math.random(-100, 100) / 100, -1)
    tbl_upv_4[v19] = v20
    tbl_upv_3[v19] = {startClock = os.clock(), scale = v18, stretch = (math.random(5, 10) / 10) * v18, mesh = v19.Mesh}
    v19.Parent = u3
    for _ = 1, math.random(4) do
        local v21 = v18 / 1.5 + math.random((v18 / 3) * -100, (v18 / 3) * 100) / 100
        local v22 = u7:Get()
        v22.Mesh.Scale = Vector3.new(v21, v21, v21)
        v22.Mesh.Offset = Vector3.new(0, 0, 0)
        v22.Color = tbl_upv_1.Tint
        v22.Transparency = 0.7
        local v23 = v21 * 60
        tbl_upv_4[v22] = v20 * CFrame.new(math.random(-v23, v23) / 100, math.random(-v23, v23) / 100, 0)
        tbl_upv_3[v22] = {startClock = os.clock(), scale = v21, stretch = (math.random(5, 10) / 10) * v21, mesh = v22.Mesh}
        v22.Parent = u3
    end
end
local tbl_5 = {Enabled = false, _activeUpdater = false}
function tbl_5.Enable(a1, a2)
    --[[
      name: Enable
      line: 206
      upvalues:
        tbl_upv_1 (copy, index: 1)
        tbl_upv_3 (copy, index: 2)
        tbl_upv_4 (copy, index: 3)
        u7 (ref,  index: 4)
        u1 (ref,  index: 5)
        CFrame_upv_1 (ref,  index: 6)
        tbl_upv_2 (copy, index: 7)
        UnderObject (copy, index: 8)
        CreateDroplet (copy, index: 9)
    ]]
    a1.Enabled = true
    a1:Configure(a2)
    if a1._activeUpdater then
        return
    end
    a1._activeUpdater = true
    local u8 = 0
    task.defer(
        function()
            --[[
              line: 217
              upvalues:
                tbl_upv_1 (copy, index: 1)
                a1 (copy, index: 2)
                tbl_upv_3 (copy, index: 3)
                tbl_upv_4 (copy, index: 4)
                u7 (ref,  index: 5)
                u1 (ref,  index: 6)
                CFrame_upv_1 (ref,  index: 7)
                tbl_upv_2 (copy, index: 8)
                UnderObject (copy, index: 9)
                u8 (ref,  index: 10)
                CreateDroplet (copy, index: 11)
            ]]
            print("spawned updater")
            local v24 = os.clock()
            local v25 = nil
            while task.wait(tbl_upv_1.UpdateFreq) do
                if a1.Enabled or next(tbl_upv_3) then
                    debug.profilebegin("ScreenRainUpdate")
                    local v26 = os.clock()
                    debug.profilebegin("Animations")
                    for key_2, value_2 in pairs(tbl_upv_3) do
                        local v27 = v26 - value_2.startClock
                        if tbl_upv_1.Fade <= v27 then
                            tbl_upv_3[key_2] = nil
                            tbl_upv_4[key_2] = nil
                            u7:Return(key_2)
                        else
                            local mesh_1 = value_2.mesh
                            local scale_1 = value_2.scale
                            local v28 = v27 / tbl_upv_1.Fade
                            local v29 = scale_1 + value_2.stretch * (((v28 * v28) * v28) * v28)
                            key_2.Transparency = 0.7 + (0.3 * (v28 * v28))
                            mesh_1.Scale = Vector3.new(scale_1, v29, scale_1)
                            mesh_1.Offset = Vector3.new(0, v29 / -2, 0)
                        end
                    end
                    debug.profileend()
                    debug.profilebegin("Droplet Creation")
                    if not (a1.Enabled) or not (u1) or not (CFrame_upv_1.LookVector.Y > -0.4) then
                        u8 = u8 % 1
                        debug.profileend()
                        debug.profileend()
                        v24 = v26
                        continue
                    end
                    local Position_2 = CFrame_upv_1.Position
                    local v30 = nil or 120
                    local v31, v32 = workspace:FindPartOnRayWithIgnoreList(Ray.new(Position_2, Vector3.new(0, 1, 0) * v30), tbl_upv_2)
                    if v31 then
                        v25 = ((v31.Transparency ~= 1) and true) or (UnderObject(v32 + Vector3.new(0, 1, 0), v30 - (Position_2 - v32).Magnitude))
                    else
                        v25 = false
                    end
                    if v25 then
                        u8 = u8 % 1
                        debug.profileend()
                        debug.profileend()
                        v24 = v26
                        continue
                    end
                    u8 = u8 + ((v26 - v24) * tbl_upv_1.Rate)
                    for _ = 1, math.floor(u8) do
                        CreateDroplet()
                    end
                    u8 = u8 % 1
                    debug.profileend()
                    debug.profileend()
                    v24 = v26
                    continue
                else
                    a1._activeUpdater = false
                    print("closed updater")
                    return
                end
            end
        end
    )
end
function tbl_5.Disable(a1)
    --[[
      name: Disable
      line: 272
    ]]
    a1.Enabled = false
end
function tbl_5.Configure(a1, a2)
    --[[
      name: Configure
      line: 276
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if type(a2) ~= "table" then
        return
    end
    for key_3, value_3 in pairs(a2) do
        print(key_3, value_3)
        tbl_upv_1[key_3] = value_3
    end
end
return tbl_5