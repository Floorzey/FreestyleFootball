--[[
    Script Path: Game/StarterPlayer/StarterCharacterScripts/WalkingSoundsClient
    Class: LocalScript
    Time: 2026-10-03 12:27:04
--]]

local Players_1 = game:GetService("Players")
local SoundService_1 = game:GetService("SoundService")
local _ = game:GetService("ReplicatedStorage")
local LocalPlayer_1 = Players_1.LocalPlayer
local v1 = LocalPlayer_1.Character or (LocalPlayer_1.CharacterAdded:wait())
local Humanoid_upv_1 = v1.Humanoid
local id_upv_1 = nil
local u1 = nil
local u2 = nil
local FloorMaterial_upv_1 = nil
local u3 = nil
local v3 = v1:WaitForChild("HumanoidRootPart")
local u4 = SoundService_1:FindFirstChild("CurrentSound") or (Instance.new("Sound", SoundService_1))
u4.Name = "CurrentSound"
local IDlist_upv_1 = require(script.IDlist)
if v1.HumanoidRootPart:FindFirstChild("Running") then
    v1.HumanoidRootPart:FindFirstChild("Running"):Destroy()
end
local function getFloorMaterial()
    --[[
      name: getFloorMaterial
      line: 38
      upvalues:
        FloorMaterial_upv_1 (ref,  index: 1)
        Humanoid_upv_1 (copy, index: 2)
        u3 (ref,  index: 3)
    ]]
    FloorMaterial_upv_1 = Humanoid_upv_1.FloorMaterial
    u3 = string.split(tostring(FloorMaterial_upv_1), "Enum.Material.")[2]
    return u3
end
local function getSoundProperties()
    --[[
      name: getSoundProperties
      line: 46
      upvalues:
        IDlist_upv_1 (copy, index: 1)
        u3 (ref,  index: 2)
        id_upv_1 (ref,  index: 3)
        u1 (ref,  index: 4)
        u2 (ref,  index: 5)
        Humanoid_upv_1 (copy, index: 6)
    ]]
    for key_1, value_1 in pairs(IDlist_upv_1) do
        if key_1 == u3 then
            id_upv_1 = value_1.id
            u1 = 0.35
            if u3 == "Air" then
                u1 = 0
            end
            u2 = (((Humanoid_upv_1.WalkSpeed < 16) and (Humanoid_upv_1.WalkSpeed / 14)) or (Humanoid_upv_1.WalkSpeed / 24)) * value_1.speed
            return
        end
    end
end
local function update()
    --[[
      name: update
      line: 61
      upvalues:
        u4 (copy, index: 1)
        id_upv_1 (ref,  index: 2)
        u1 (ref,  index: 3)
        u2 (ref,  index: 4)
    ]]
    u4.SoundId = id_upv_1
    u4.Volume = u1
    u4.PlaybackSpeed = u2
end
FloorMaterial_upv_1 = Humanoid_upv_1.FloorMaterial
local v2 = string.split(tostring(FloorMaterial_upv_1), "Enum.Material.")
u3 = v2[2]
getSoundProperties()
u4.SoundId = id_upv_1
u4.Volume = u1
u4.PlaybackSpeed = u2
Humanoid_upv_1:GetPropertyChangedSignal("FloorMaterial"):Connect(
    function()
        --[[
          line: 73
          upvalues:
            FloorMaterial_upv_1 (ref,  index: 1)
            Humanoid_upv_1 (copy, index: 2)
            u3 (ref,  index: 3)
            getSoundProperties (copy, index: 4)
            u4 (copy, index: 5)
            id_upv_1 (ref,  index: 6)
            u1 (ref,  index: 7)
            u2 (ref,  index: 8)
        ]]
        FloorMaterial_upv_1 = Humanoid_upv_1.FloorMaterial
        u3 = string.split(tostring(FloorMaterial_upv_1), "Enum.Material.")[2]
        getSoundProperties()
        u4.SoundId = id_upv_1
        u4.Volume = u1
        u4.PlaybackSpeed = u2
        if not (Humanoid_upv_1.MoveDirection.Magnitude > 0) then
            return
        end
        u4.Playing = true
    end
)
Humanoid_upv_1.Running:Connect(
    function(a1)
        --[[
          line: 84
          upvalues:
            Humanoid_upv_1 (copy, index: 1)
            getSoundProperties (copy, index: 2)
            u4 (copy, index: 3)
            id_upv_1 (ref,  index: 4)
            u1 (ref,  index: 5)
            u2 (ref,  index: 6)
        ]]
        if Humanoid_upv_1.MoveDirection.Magnitude > 0 and a1 > 0 and Humanoid_upv_1:GetState() ~= Enum.HumanoidStateType.Climbing and Humanoid_upv_1.FloorMaterial ~= Enum.Material.Air then
            getSoundProperties()
            u4.SoundId = id_upv_1
            u4.Volume = u1
            u4.PlaybackSpeed = u2
            u4.Playing = true
            u4.Looped = true
            return
        end
        u4:Stop()
    end
)
LocalPlayer_1.CharacterAdded:Connect(
    function()
        --[[
          line: 96
          upvalues:
            u4 (copy, index: 1)
        ]]
        task.wait(1)
        if not u4.IsPlaying then
            return
        end
        u4:Stop()
    end
)