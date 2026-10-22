--[[
    Script Path: Game/Players/Player/PlayerScripts/WindController/WindShake
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local CollectionService_upv_1 = game:GetService("CollectionService")
local RunService_upv_1 = game:GetService("RunService")
local Settings_upv_1 = require(script.Settings)
local Octree_1 = require(script.Octree)
local u1 = Settings_upv_1.new(script, {WindDirection = Vector3.new(0.5, 0, 0.5), WindPower = 0.5, WindSpeed = 20})
local u2 = Instance.new("BindableEvent")
local u3 = Instance.new("BindableEvent")
local u4 = Instance.new("BindableEvent")
local u5 = Instance.new("BindableEvent")
local u6 = Instance.new("BindableEvent")
local tbl_1 = {Handled = 0, Active = 0}
tbl_1.ObjectMetadata = {}
tbl_1.Octree = Octree_1.new()
tbl_1.LastUpdate = os.clock()
tbl_1.ObjectShakeAdded = u2.Event
tbl_1.ObjectShakeRemoved = u3.Event
tbl_1.ObjectShakeUpdated = u4.Event
tbl_1.Paused = u5.Event
tbl_1.Resumed = u6.Event
function tbl_1.Connect(a1, a2, a3)
    --[[
      name: Connect
      line: 59
    ]]
    local u7 = a1[a2]
    local v1 = typeof(u7) == "function"
    assert(v1, "Unknown function: " .. a2)
    return a3:Connect(
        function(...)
            --[[
              line: 63
              upvalues:
                u7 (copy, index: 1)
                a1 (copy, index: 2)
            ]]
            return u7(a1, ...)
        end
    )
end
function tbl_1.AddObjectShake(a1, a2, a3)
    --[[
      name: AddObjectShake
      line: 68
      upvalues:
        Settings_upv_1 (copy, index: 1)
        u1 (copy, index: 2)
        u2 (copy, index: 3)
    ]]
    if typeof(a2) ~= "Instance" or not a2:IsA("BasePart") then
        return
    end
    local ObjectMetadata_1 = a1.ObjectMetadata
    if ObjectMetadata_1[a2] then
        return
    end
    a1.Handled = a1.Handled + 1
    ObjectMetadata_1[a2] = {Node = a1.Octree:CreateNode(a2.Position, a2), Settings = Settings_upv_1.new(a2, u1), Seed = math.random(1000) * 0.1, Origin = a2.CFrame}
    a1:UpdateObjectSettings(a2, a3)
    u2:Fire(a2)
end
function tbl_1.RemoveObjectShake(a1, a2)
    --[[
      name: RemoveObjectShake
      line: 98
      upvalues:
        u3 (copy, index: 1)
    ]]
    if typeof(a2) ~= "Instance" then
        return
    end
    local ObjectMetadata_2 = a1.ObjectMetadata
    local v2 = ObjectMetadata_2[a2]
    if v2 then
        a1.Handled = a1.Handled - 1
        ObjectMetadata_2[a2] = nil
        v2.Settings:Destroy()
        v2.Node:Destroy()
        if a2:IsA("BasePart") then
            a2.CFrame = v2.Origin
        end
    end
    u3:Fire(a2)
end
function tbl_1.Update(a1)
    --[[
      name: Update
      line: 120
    ]]
    local v3 = os.clock()
    local v4 = v3 - a1.LastUpdate
    if v4 < 0.022222222222222223 then
        return
    end
    a1.LastUpdate = v3
    debug.profilebegin("WindShake")
    local CurrentCamera_1 = workspace.CurrentCamera
    local v5 = CurrentCamera_1 and (CurrentCamera_1.CFrame)
    debug.profilebegin("Octree Search")
    local v6 = a1.Octree:RadiusSearch(v5.Position + (v5.LookVector * 115), 120)
    debug.profileend()
    local v7 = #v6
    a1.Active = v7
    if v7 < 1 then
        return
    end
    local v8 = math.min(1, v4 * 8)
    local v9 = table.create(v7)
    local ObjectMetadata_3 = a1.ObjectMetadata
    debug.profilebegin("Calc")
    for key_1, value_1 in ipairs(v6) do
        local v10 = ObjectMetadata_3[value_1]
        local Origin_1 = v10.Origin
        if v3 - (v10.LastCompute or 0) > 0.03333333333333333 then
            local Settings_2 = v10.Settings
            local Seed_1 = v10.Seed
            local v11 = Settings_2.WindPower * 0.1
            local v12 = v3 * (Settings_2.WindSpeed * 0.08)
            local v13 = math.noise(v12, 0, Seed_1) * v11
            local v14 = math.noise(v12, 0, -Seed_1) * v11
            local v15 = math.noise(v12, 0, Seed_1 + Seed_1) * v11
            local PivotOffset_1 = value_1.PivotOffset
            v10.Target = (((Origin_1 * PivotOffset_1) * CFrame.Angles(v13, v14, v15)) + (Settings_2.WindDirection * ((0.5 + math.noise(v12, Seed_1, Seed_1)) * v11))) * PivotOffset_1:Inverse()
            v10.LastCompute = v3
        end
        local v16 = (v10.CFrame or Origin_1):Lerp(v10.Target, v8)
        v10.CFrame = v16
        v9[key_1] = v16
    end
    debug.profileend()
    workspace:BulkMoveTo(v6, v9, Enum.BulkMoveMode.FireCFrameChanged)
    debug.profileend()
end
function tbl_1.Pause(a1)
    --[[
      name: Pause
      line: 187
      upvalues:
        u5 (copy, index: 1)
    ]]
    if a1.UpdateConnection then
        a1.UpdateConnection:Disconnect()
        a1.UpdateConnection = nil
    end
    a1.Active = 0
    a1.Running = false
    u5:Fire()
end
function tbl_1.Resume(a1)
    --[[
      name: Resume
      line: 199
      upvalues:
        RunService_upv_1 (copy, index: 1)
        u6 (copy, index: 2)
    ]]
    if a1.Running then
        return
    end
    a1.Running = true
    a1.UpdateConnection = a1:Connect("Update", RunService_upv_1.Heartbeat)
    u6:Fire()
end
function tbl_1.Init(a1)
    --[[
      name: Init
      line: 212
      upvalues:
        u1 (copy, index: 1)
        CollectionService_upv_1 (copy, index: 2)
    ]]
    if a1.Initialized then
        return
    end
    a1.Initialized = true
    local v17 = script:GetAttribute("WindPower")
    local v18 = script:GetAttribute("WindSpeed")
    local v19 = script:GetAttribute("WindDirection")
    if typeof(v17) ~= "number" then
        script:SetAttribute("WindPower", u1.WindPower)
    end
    if typeof(v18) ~= "number" then
        script:SetAttribute("WindSpeed", u1.WindSpeed)
    end
    if typeof(v19) ~= "Vector3" then
        script:SetAttribute("WindDirection", u1.WindDirection)
    end
    a1:Cleanup()
    a1.AddedConnection = a1:Connect("AddObjectShake", CollectionService_upv_1:GetInstanceAddedSignal("WindShake"))
    a1.RemovedConnection = a1:Connect("RemoveObjectShake", CollectionService_upv_1:GetInstanceRemovedSignal("WindShake"))
    for _, value_2 in pairs(CollectionService_upv_1:GetTagged("WindShake")) do
        a1:AddObjectShake(value_2)
    end
    a1:Resume()
end
function tbl_1.Cleanup(a1)
    --[[
      name: Cleanup
      line: 254
    ]]
    if not a1.Initialized then
        return
    end
    a1:Pause()
    if a1.AddedConnection then
        a1.AddedConnection:Disconnect()
        a1.AddedConnection = nil
    end
    if a1.RemovedConnection then
        a1.RemovedConnection:Disconnect()
        a1.RemovedConnection = nil
    end
    table.clear(a1.ObjectMetadata)
    a1.Octree:ClearNodes()
    a1.Handled = 0
    a1.Active = 0
    a1.Initialized = false
end
function tbl_1.UpdateObjectSettings(a1, a2, a3)
    --[[
      name: UpdateObjectSettings
      line: 279
      upvalues:
        u4 (copy, index: 1)
    ]]
    if typeof(a2) ~= "Instance" or typeof(a3) ~= "table" then
        return
    end
    if (a1.ObjectMetadata[a2]) or a2 == script then
        for key_2, value_3 in pairs(a3) do
            a2:SetAttribute(key_2, value_3)
        end
        u4:Fire(a2)
        return
    end
end
function tbl_1.UpdateAllObjectSettings(a1, a2)
    --[[
      name: UpdateAllObjectSettings
      line: 299
      upvalues:
        u4 (copy, index: 1)
    ]]
    if typeof(a2) ~= "table" then
        return
    end
    for key_3, _ in pairs(a1.ObjectMetadata) do
        for key_4, value_4 in pairs(a2) do
            key_3:SetAttribute(key_4, value_4)
        end
        u4:Fire(key_3)
    end
end
function tbl_1.SetDefaultSettings(a1, a2)
    --[[
      name: SetDefaultSettings
      line: 312
    ]]
    a1:UpdateObjectSettings(script, a2)
end
return tbl_1