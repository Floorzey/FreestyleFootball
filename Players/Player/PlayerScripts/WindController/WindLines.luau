--[[
    Script Path: Game/Players/Player/PlayerScripts/WindController/WindLines
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local RunService_upv_1 = game:GetService("RunService")
local u1 = workspace:FindFirstChildOfClass("Terrain")
local tbl_upv_1 = {}
local tbl_upv_2 = {}
tbl_upv_2.UpdateQueue = table.create(10)
function tbl_upv_2.Init(a1, a2)
    --[[
      name: Init
      line: 11
      upvalues:
        tbl_upv_2 (copy, index: 1)
        RunService_upv_1 (copy, index: 2)
    ]]
    tbl_upv_2.Lifetime = a2.Lifetime or 3
    tbl_upv_2.Direction = a2.Direction or Vector3.new(1, 0, 0)
    tbl_upv_2.Speed = a2.Speed or 6
    if tbl_upv_2.UpdateConnection then
        tbl_upv_2.UpdateConnection:Disconnect()
        tbl_upv_2.UpdateConnection = nil
    end
    for _, value_1 in ipairs(tbl_upv_2.UpdateQueue) do
        value_1.Attachment0:Destroy()
        value_1.Attachment1:Destroy()
        value_1.Trail:Destroy()
    end
    table.clear(tbl_upv_2.UpdateQueue)
    tbl_upv_2.LastSpawned = os.clock()
    local u2 = 1 / (a2.SpawnRate or 25)
    tbl_upv_2.UpdateConnection = RunService_upv_1.Heartbeat:Connect(
        function()
            --[[
              line: 34
              upvalues:
                tbl_upv_2 (copy, index: 1)
                u2 (copy, index: 2)
            ]]
            local v1 = os.clock()
            if u2 < v1 - tbl_upv_2.LastSpawned then
                tbl_upv_2:Create()
                tbl_upv_2.LastSpawned = v1
            end
            debug.profilebegin("Wind Lines")
            for key_1, value_2 in ipairs(tbl_upv_2.UpdateQueue) do
                local v2 = v1 - value_2.StartClock
                if value_2.Lifetime <= v2 then
                    value_2.Attachment0:Destroy()
                    value_2.Attachment1:Destroy()
                    value_2.Trail:Destroy()
                    local v3 = #tbl_upv_2.UpdateQueue
                    tbl_upv_2.UpdateQueue[key_1] = tbl_upv_2.UpdateQueue[v3]
                    tbl_upv_2.UpdateQueue[v3] = nil
                else
                    value_2.Trail.MaxLength = 20 - (20 * (v2 / value_2.Lifetime))
                    local v4 = (v1 + value_2.Seed) * (value_2.Speed * 0.2)
                    local Position_1 = value_2.Position
                    value_2.Attachment0.WorldPosition = (CFrame.new(Position_1, Position_1 + value_2.Direction) * CFrame.new(0, 0, value_2.Speed * -v2)).Position + Vector3.new(math.sin(v4) * 0.5, math.sin(v4) * 0.8, math.sin(v4) * 0.5)
                    value_2.Attachment1.WorldPosition = value_2.Attachment0.WorldPosition + Vector3.new(0, 0.10000000149011612, 0)
                end
            end
            debug.profileend()
        end
    )
end
function tbl_upv_2.Cleanup(a1)
    --[[
      name: Cleanup
      line: 79
      upvalues:
        tbl_upv_2 (copy, index: 1)
    ]]
    if tbl_upv_2.UpdateConnection then
        tbl_upv_2.UpdateConnection:Disconnect()
        tbl_upv_2.UpdateConnection = nil
    end
    for _, value_3 in ipairs(tbl_upv_2.UpdateQueue) do
        value_3.Attachment0:Destroy()
        value_3.Attachment1:Destroy()
        value_3.Trail:Destroy()
    end
    table.clear(tbl_upv_2.UpdateQueue)
end
function tbl_upv_2.Create(a1, a2)
    --[[
      name: Create
      line: 95
      upvalues:
        tbl_upv_1 (copy, index: 1)
        tbl_upv_2 (copy, index: 2)
        u1 (copy, index: 3)
    ]]
    debug.profilebegin("Add Wind Line")
    local v5 = a2 or tbl_upv_1
    v5 = v5.Lifetime or (tbl_upv_2.Lifetime)
    local v6 = v5.Position or (workspace.CurrentCamera.CFrame * CFrame.Angles(math.rad(math.random(-30, 70)), math.rad(math.random(-80, 80)), 0) * CFrame.new(0, 0, math.random(200, 600) * -0.1).Position)
    local v7 = v5.Direction or (tbl_upv_2.Direction)
    local v8 = v5.Speed or (tbl_upv_2.Speed)
    if v8 <= 0 then
        return
    end
    local v9 = Instance.new("Attachment")
    local v10 = Instance.new("Attachment")
    local v11 = Instance.new("Trail")
    v11.Attachment0 = v9
    v11.Attachment1 = v10
    v11.Texture = "rbxassetid://5699911427"
    v11.WidthScale = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(0.2, 1.5), NumberSequenceKeypoint.new(0.8, 1.5), NumberSequenceKeypoint.new(1, 0.5)})
    v11.Transparency = NumberSequence.new(0.7)
    v11.FaceCamera = true
    v11.Parent = v9
    v9.WorldPosition = v6
    v10.WorldPosition = v6 + Vector3.new(0, 0.10000000149011612, 0)
    tbl_upv_2.UpdateQueue[#tbl_upv_2.UpdateQueue + 1] = {Attachment0 = v9, Attachment1 = v10, Trail = v11, Lifetime = v5 + (math.random(-10, 10) * 0.1), Position = v6, Direction = v7, Speed = v8 + (math.random(-10, 10) * 0.1), StartClock = os.clock(), Seed = math.random(1, 1000) * 0.1}
    v9.Parent = u1
    v10.Parent = u1
    debug.profileend()
end
return tbl_upv_2