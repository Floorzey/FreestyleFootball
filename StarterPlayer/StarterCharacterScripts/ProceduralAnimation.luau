--[[
    Script Path: Game/StarterPlayer/StarterCharacterScripts/ProceduralAnimation
    Class: LocalScript
    Time: 2026-10-03 12:27:04
--]]

local RunService_1 = game:GetService("RunService")
local LocalPlayer_upv_1 = game.Players.LocalPlayer
local Character_1 = LocalPlayer_upv_1.Character
local _ = Character_1:WaitForChild("Humanoid")
local HumanoidRootPart_1 = Character_1:WaitForChild("HumanoidRootPart")
local Torso_1 = Character_1:WaitForChild("Torso")
local ControlModule_upv_1 = require(LocalPlayer_upv_1.PlayerScripts.PlayerModule.ControlModule)
local C0_upv_1 = HumanoidRootPart_1.RootJoint.C0
local C0_upv_2 = Torso_1.Neck.C0
local v1 = 45
local u1 = v1 / 140
local u2 = math.rad(v1)
local v2 = math.rad(90)
local u3 = v2
local Unit_upv_1 = nil
local u4 = nil
local u5 = 0
local u6 = 0
function has_action_anim(a1)
    --[[
      name: has_action_anim
      line: 35
    ]]
    for _, value_1 in a1.Humanoid.Animator:GetPlayingAnimationTracks() do
        if value_1.Priority == Enum.AnimationPriority.Movement or value_1.Priority == Enum.AnimationPriority.Core or value_1.Priority == Enum.AnimationPriority.Idle then
            continue
        end
        return true
    end
    return false
end
function Calculate(a1, a2, a3, a4)
    --[[
      name: Calculate
      line: 44
      upvalues:
        u2 (ref,  index: 1)
        u3 (ref,  index: 2)
        u1 (copy, index: 3)
        ControlModule_upv_1 (copy, index: 4)
        u4 (ref,  index: 5)
        Unit_upv_1 (ref,  index: 6)
        u5 (ref,  index: 7)
        u6 (ref,  index: 8)
        C0_upv_1 (copy, index: 9)
        C0_upv_2 (copy, index: 10)
    ]]
    if a3.WalkSpeed == 0 then
        return
    end
    local v3 = a2.CFrame:VectorToObjectSpace(a2.AssemblyLinearVelocity)
    local v4 = Vector3.new(v3.X / a3.WalkSpeed, 0, v3.Z / a3.WalkSpeed)
    local _ = v4.X * (u2 - (math.abs(v4.Z) * (u2 / 2)))
    local v5 = v4.X * (u3 - (math.abs(v4.Z) * (u3 / 2)))
    local v10 = v4.X * (u1 - (math.abs(v4.Z) * (u1 / 2)))
    local v6 = ((ControlModule_upv_1:GetMoveVector().Z > 0.5) and (v5 * -1)) or v5
    u4 = a2.AssemblyLinearVelocity * Vector3.new(1, 0, 1)
    if u4.Magnitude > 2 then
        Unit_upv_1 = u4.Unit
        u5 = a2.CFrame.RightVector:Dot(u4.Unit) / 8.5
        u6 = a2.CFrame.LookVector:Dot(Unit_upv_1) / 10.5
    else
        u5 = 0
        u6 = 0
    end
    local v7 = C0_upv_1 * CFrame.Angles(u6, -u5, -v6)
    local v8 = C0_upv_2 * CFrame.Angles(0, 0, v6)
    local v9 = 0.2 / (0.016666666666666666 / a1)
    a2.RootJoint.C0 = a2.RootJoint.C0:Lerp(v7, v9)
    a4.Neck.C0 = a4.Neck.C0:Lerp(v8, v9)
end
local function reset_c0(a1)
    --[[
      name: reset_c0
      line: 83
      upvalues:
        C0_upv_1 (copy, index: 1)
        C0_upv_2 (copy, index: 2)
    ]]
    a1.HumanoidRootPart.RootJoint.C0 = C0_upv_1
    a1.Torso.Neck.C0 = C0_upv_2
end
RunService_1.RenderStepped:Connect(
    function(a1)
        --[[
          line: 88
          upvalues:
            LocalPlayer_upv_1 (copy, index: 1)
            C0_upv_1 (copy, index: 2)
            C0_upv_2 (copy, index: 3)
        ]]
        for _, value_2 in workspace.CharacterContainer:GetChildren() do
            local HumanoidRootPart_2 = value_2:FindFirstChild("HumanoidRootPart")
            local Humanoid_1 = value_2:FindFirstChild("Humanoid")
            local Torso_2 = value_2:FindFirstChild("Torso")
            if HumanoidRootPart_2 == nil or Humanoid_1 == nil or Torso_2 == nil then
                continue
            end
            if has_action_anim(value_2) or Humanoid_1.WalkSpeed == 0 then
                value_2.HumanoidRootPart.RootJoint.C0 = C0_upv_1
                value_2.Torso.Neck.C0 = C0_upv_2
                continue
            end
            if LocalPlayer_upv_1.Settings.Misc.CharacterRotation.Value ~= false then
                Calculate(a1, HumanoidRootPart_2, Humanoid_1, Torso_2)
            else
                value_2.HumanoidRootPart.RootJoint.C0 = C0_upv_1
                value_2.Torso.Neck.C0 = C0_upv_2
            end
        end
    end
)