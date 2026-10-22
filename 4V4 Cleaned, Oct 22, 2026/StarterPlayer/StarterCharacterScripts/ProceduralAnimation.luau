local run_service = game:GetService("RunService")
local local_player = game.Players.LocalPlayer
local character = local_player.Character
local _ = character:WaitForChild("Humanoid")
local humanoid_root_part = character:WaitForChild("HumanoidRootPart")
local torso = character:WaitForChild("Torso")
local control_module = require(local_player.PlayerScripts.PlayerModule.ControlModule)
local c0 = humanoid_root_part.RootJoint.C0
local c0_2 = torso.Neck.C0
local c0_3 = torso["Right Hip"].C0
local c0_4 = torso["Left Hip"].C0
local number = 45
local quotient = number / 140
number = math.rad(number)
local radians = math.rad(82.5 - number)
local radians_2 = radians
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
    local product = vector_2.X * (number - (math.abs(vector_2.Z) * (number / 2)))
    local product_2 = vector_2.X * (radians_2 - (math.abs(vector_2.Z) * (radians_2 / 2)))
    local product_3 = vector_2.X * (quotient - (math.abs(vector_2.Z) * (quotient / 2)))

    if control_module:GetMoveVector().Z > 0.5 then
        product *= -1
        product_2 *= -1
        product_3 *= -1
    end

    vector = argument_2.AssemblyLinearVelocity * Vector3.new(1, 0, 1)

    if vector.Magnitude > 2 then
        unit = vector.Unit
        number_2 = argument_2.CFrame.RightVector:Dot(vector.Unit) / 8.5
        number_3 = argument_2.CFrame.LookVector:Dot(unit) / 10.5
    else
        number_2 = 0
        number_3 = 0
    end

    local product_4 = c0_3
        * CFrame.new(-product_3, 0, -math.abs(product_3) + math.abs(-product_3))
        * CFrame.Angles(0, -product, 0)
    local product_5 = c0_4
        * CFrame.new(-product_3, 0, -math.abs(-product_3) + math.abs(-product_3))
        * CFrame.Angles(0, -product, 0)
    product_3 = c0 * CFrame.Angles(number_3, -number_2, -product_2)
    product = c0_2 * CFrame.Angles(0, 0, product_2)
    product_2 = 0.2 / (0.016666666666666666 / argument)
    argument_4["Right Hip"].C0 = argument_4["Right Hip"].C0:Lerp(product_4, product_2)
    argument_4["Left Hip"].C0 = argument_4["Left Hip"].C0:Lerp(product_5, product_2)
    argument_2.RootJoint.C0 = argument_2.RootJoint.C0:Lerp(product_3, product_2)
    argument_4.Neck.C0 = argument_4.Neck.C0:Lerp(product, product_2)
end

local function reset_c0(character_2)
    character_2.Torso["Right Hip"].C0 = c0_3
    character_2.Torso["Left Hip"].C0 = c0_4
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

        if has_action_anim(character_2) then
            character_2.Torso["Right Hip"].C0 = c0_3
            character_2.Torso["Left Hip"].C0 = c0_4
            character_2.HumanoidRootPart.RootJoint.C0 = c0
            character_2.Torso.Neck.C0 = c0_2
            continue
        end

        if humanoid.WalkSpeed ~= 0 then
            Calculate(delta_time, humanoid_root_part_2, humanoid, torso_2)
        else
            character_2.Torso["Right Hip"].C0 = c0_3
            character_2.Torso["Left Hip"].C0 = c0_4
            character_2.HumanoidRootPart.RootJoint.C0 = c0
            character_2.Torso.Neck.C0 = c0_2
        end
    end
end)
