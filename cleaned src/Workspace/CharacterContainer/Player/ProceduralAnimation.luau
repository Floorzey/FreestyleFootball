local run_service = game:GetService("RunService")
local local_player = game.Players.LocalPlayer
local character = local_player.Character
local _ = character:WaitForChild("Humanoid")
local humanoid_root_part = character:WaitForChild("HumanoidRootPart")
local torso = character:WaitForChild("Torso")
local control_module = require(local_player.PlayerScripts.PlayerModule.ControlModule)
local c0 = humanoid_root_part.RootJoint.C0
local c0_2 = torso.Neck.C0
local number = 45
local number_offset = number / 140
local radians = math.rad(number)
local radians_2 = math.rad(90)
local radians_3 = radians_2
local unit = nil
local vector = nil
local number_2 = 0
local number_3 = 0

function has_action_anim(character_2)
    for _, item in character_2.Humanoid.Animator:GetPlayingAnimationTracks() do
        if
            item.Priority == Enum.AnimationPriority.Movement
            or item.Priority == Enum.AnimationPriority.Core
            or item.Priority == Enum.AnimationPriority.Idle
        then
            continue
        end
        return true
    end
    return false
end

function Calculate(argument, argument_2, argument_3, argument_4)
    if argument_3.WalkSpeed == 0 then
        return
    end
    local relative_vector = argument_2.CFrame:VectorToObjectSpace(argument_2.AssemblyLinearVelocity)
    local vector_2 = Vector3.new(relative_vector.X / argument_3.WalkSpeed, 0, relative_vector.Z / argument_3.WalkSpeed)
    local _ = vector_2.X * (radians - (math.abs(vector_2.Z) * (radians / 2)))
    local x_offset = vector_2.X * (radians_3 - (math.abs(vector_2.Z) * (radians_3 / 2)))
    local x_offset_2 = vector_2.X * (number_offset - (math.abs(vector_2.Z) * (number_offset / 2)))
    local is_z = ((control_module:GetMoveVector().Z > 0.5) and (x_offset * -1)) or x_offset
    vector = argument_2.AssemblyLinearVelocity * Vector3.new(1, 0, 1)
    if vector.Magnitude > 2 then
        unit = vector.Unit
        number_2 = argument_2.CFrame.RightVector:Dot(vector.Unit) / 8.5
        number_3 = argument_2.CFrame.LookVector:Dot(unit) / 10.5
    else
        number_2 = 0
        number_3 = 0
    end
    local c0_offset = c0 * CFrame.Angles(number_3, -number_2, -is_z)
    local c0_offset_2 = c0_2 * CFrame.Angles(0, 0, is_z)
    local number_offset_2 = 0.2 / (0.016666666666666666 / argument)
    argument_2.RootJoint.C0 = argument_2.RootJoint.C0:Lerp(c0_offset, number_offset_2)
    argument_4.Neck.C0 = argument_4.Neck.C0:Lerp(c0_offset_2, number_offset_2)
end

local function reset_c0(character_2)
    character_2.HumanoidRootPart.RootJoint.C0 = c0
    character_2.Torso.Neck.C0 = c0_2
end

run_service.RenderStepped:Connect(function(delta_time)
    for _, character_2 in workspace.CharacterContainer:GetChildren() do
        local humanoid_root_part_2 = character_2:FindFirstChild("HumanoidRootPart")
        local humanoid = character_2:FindFirstChild("Humanoid")
        local torso_2 = character_2:FindFirstChild("Torso")
        if humanoid_root_part_2 == nil or humanoid == nil or torso_2 == nil then
            continue
        end
        if has_action_anim(character_2) or humanoid.WalkSpeed == 0 then
            character_2.HumanoidRootPart.RootJoint.C0 = c0
            character_2.Torso.Neck.C0 = c0_2
            continue
        end
        if local_player.Settings.Misc.CharacterRotation.Value ~= false then
            Calculate(delta_time, humanoid_root_part_2, humanoid, torso_2)
        else
            character_2.HumanoidRootPart.RootJoint.C0 = c0
            character_2.Torso.Neck.C0 = c0_2
        end
    end
end)
