local run_service = game:GetService("RunService")
local local_player = game.Players.LocalPlayer
local character = local_player.Character
character:WaitForChild("Humanoid")
local humanoid_root_part = character:WaitForChild("HumanoidRootPart")
local torso = character:WaitForChild("Torso")
local control_module = require(local_player.PlayerScripts.PlayerModule.ControlModule)
local c0 = humanoid_root_part.RootJoint.C0
local c02 = torso.Neck.C0
local _ = torso["Right Hip"].C0
local _ = torso["Left Hip"].C0
local number = 45
local quotient = number / 140
local radians = math.rad(number)
local radians_2 = math.rad(90)
local value = nil
local vector = nil
local number_2 = 0
local number_3 = 0

function has_action_anim(character_2)
    for _, item in character_2.Humanoid.Animator:GetPlayingAnimationTracks() do
        if
            item.Priority ~= Enum.AnimationPriority.Movement
            and (item.Priority ~= Enum.AnimationPriority.Core and item.Priority ~= Enum.AnimationPriority.Idle)
        then
            return true
        end
    end

    return false
end

function Calculate(argument, argument_2, argument_3, argument_4)
    if argument_3.WalkSpeed == 0 then
        return
    end

    local relative_vector = argument_2.CFrame:VectorToObjectSpace(argument_2.AssemblyLinearVelocity)
    local vector_2 = Vector3.new(relative_vector.X / argument_3.WalkSpeed, 0, relative_vector.Z / argument_3.WalkSpeed)
    local product = vector_2.X * (radians - math.abs(vector_2.Z) * (radians / 2))
    local product_2 = vector_2.X * (radians_2 - math.abs(vector_2.Z) * (radians_2 / 2))
    local product_3 = vector_2.X * (quotient - math.abs(vector_2.Z) * (quotient / 2))

    if control_module:GetMoveVector().Z > 0.5 then
        local _ = product * -1
        product_2 *= -1
        local _ = product_3 * -1
    end

    vector = argument_2.AssemblyLinearVelocity * Vector3.new(1, 0, 1)

    if vector.Magnitude > 2 then
        value = vector.Unit
        number_2 = argument_2.CFrame.RightVector:Dot(value) / 8.5
        number_3 = argument_2.CFrame.LookVector:Dot(value) / 10.5
    else
        number_2 = 0
        number_3 = 0
    end

    local product_4 = c0 * CFrame.Angles(number_3, -number_2, -product_2)
    local product_5 = c02 * CFrame.Angles(0, 0, product_2)
    local quotient_2 = 0.2 / (0.016666666666666666 / argument)
    argument_2.RootJoint.C0 = argument_2.RootJoint.C0:Lerp(product_4, quotient_2)
    argument_4.Neck.C0 = argument_4.Neck.C0:Lerp(product_5, quotient_2)
end

local function reset_c0(character_2)
    character_2.HumanoidRootPart.RootJoint.C0 = c0
    character_2.Torso.Neck.C0 = c02
end

run_service.RenderStepped:Connect(function(delta_time)
    for _, child in workspace.CharacterContainer:GetChildren() do
        local humanoid_root_part2 = child:FindFirstChild("HumanoidRootPart")
        local humanoid = child:FindFirstChild("Humanoid")
        local torso2 = child:FindFirstChild("Torso")

        if humanoid_root_part2 ~= nil and (humanoid ~= nil and torso2 ~= nil) then
            if
                has_action_anim(child)
                or (humanoid.WalkSpeed == 0 or local_player.Settings.Misc.CharacterRotation.Value == false)
            then
                child.HumanoidRootPart.RootJoint.C0 = c0
                child.Torso.Neck.C0 = c02
            else
                Calculate(delta_time, humanoid_root_part2, humanoid, torso2)
            end
        end
    end
end)
