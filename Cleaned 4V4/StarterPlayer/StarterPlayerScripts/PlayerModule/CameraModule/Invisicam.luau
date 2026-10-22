local players = game:GetService("Players")
local values =
    { CIRCLE1 = 5, CHAR_OUTLINE = 9, MOVEMENT = 3, CORNERS = 4, LIMBS = 2, SMART_CIRCLE = 8, LIMBMOVE = 7, CIRCLE2 = 6 }
local values_2 = {}
values_2.Head = true
values_2["Left Arm"] = true
values_2["Right Arm"] = true
values_2["Left Leg"] = true
values_2["Right Leg"] = true
values_2.LeftLowerArm = true
values_2.RightLowerArm = true
values_2.LeftUpperLeg = true
values_2.RightUpperLeg = true
local values_3 = { Vector3.new(1, 1, -1), Vector3.new(1, -1, -1), Vector3.new(-1, -1, -1), Vector3.new(-1, 1, -1) }

local function det3x3(
    argument,
    argument_2,
    argument_3,
    argument_4,
    argument_5,
    argument_6,
    argument_7,
    argument_8,
    argument_9
)
    return (
        (argument * ((argument_5 * argument_9) - (argument_6 * argument_8)))
        - (argument_2 * ((argument_4 * argument_9) - (argument_6 * argument_7)))
    ) + (argument_3 * ((argument_4 * argument_8) - (argument_5 * argument_7)))
end

local base_occlusion = require(script.Parent:WaitForChild("BaseOcclusion"))
local invisicam = setmetatable({}, base_occlusion)
invisicam.__index = invisicam

function invisicam.new()
    local instance = setmetatable(base_occlusion.new(), invisicam)
    instance.char = nil
    instance.humanoidRootPart = nil
    instance.torsoPart = nil
    instance.headPart = nil
    instance.childAddedConn = nil
    instance.childRemovedConn = nil
    instance.behaviors = {}
    instance.behaviors[values.LIMBS] = instance.LimbBehavior
    instance.behaviors[values.MOVEMENT] = instance.MoveBehavior
    instance.behaviors[values.CORNERS] = instance.CornerBehavior
    instance.behaviors[values.CIRCLE1] = instance.CircleBehavior
    instance.behaviors[values.CIRCLE2] = instance.CircleBehavior
    instance.behaviors[values.LIMBMOVE] = instance.LimbMoveBehavior
    instance.behaviors[values.SMART_CIRCLE] = instance.SmartCircleBehavior
    instance.behaviors[values.CHAR_OUTLINE] = instance.CharacterOutlineBehavior
    instance.mode = values.SMART_CIRCLE
    instance.behaviorFunction = instance.SmartCircleBehavior
    instance.savedHits = {}
    instance.trackedLimbs = {}
    instance.camera = game.Workspace.CurrentCamera
    instance.enabled = false

    return instance
end

function invisicam.Enable(argument, enabled)
    argument.enabled = enabled

    if enabled then
        return
    end

    argument:Cleanup()
end

function invisicam.GetOcclusionMode(argument)
    return Enum.DevCameraOcclusionMode.Invisicam
end

function invisicam.LimbBehavior(argument, argument_2)
    for key, _ in pairs(argument.trackedLimbs) do
        argument_2[#argument_2 + 1] = key.Position
    end
end

function invisicam.MoveBehavior(argument, argument_2)
    for n = 1, 3 do
        local velocity = argument.humanoidRootPart.Velocity
        argument_2[#argument_2 + 1] = argument.humanoidRootPart.Position
            + (
                ((n - 1) * argument.humanoidRootPart.CFrame.lookVector)
                * (Vector3.new(velocity.X, 0, velocity.Z).Magnitude / 2)
            )
    end
end

function invisicam.CornerBehavior(argument, argument_2)
    local cframe = argument.humanoidRootPart.CFrame
    local position = cframe.Position
    local quotient = argument.char:GetExtentsSize() / 2
    argument_2[#argument_2 + 1] = position

    for n = 1, #values_3 do
        argument_2[#argument_2 + 1] = position + ((cframe - position) * (quotient * values_3[n]))
    end
end

function invisicam.CircleBehavior(argument, argument_2)
    local sum

    if argument.mode ~= values.CIRCLE1 then
        local _ = argument.camera.CoordinateFrame
        sum = argument.camera.CoordinateFrame
            - argument.camera.CoordinateFrame.Position
            + argument.humanoidRootPart.Position
    else
        sum = argument.humanoidRootPart.CFrame
    end

    argument_2[#argument_2 + 1] = sum.Position

    for n = 0, 9 do
        local product = 0.6283185307179586 * n
        argument_2[#argument_2 + 1] = sum * (Vector3.new(math.cos(product), math.sin(product), 0) * 3)
    end
end

function invisicam.LimbMoveBehavior(argument, argument_2)
    argument:LimbBehavior(argument_2)
    argument:MoveBehavior(argument_2)
end

function invisicam.CharacterOutlineBehavior(argument, argument_2)
    local unit = argument.torsoPart.CFrame.upVector.unit
    local unit_2 = argument.torsoPart.CFrame.rightVector.unit
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p + unit
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p - unit
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p + unit_2
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p - unit_2

    if argument.headPart then
        argument_2[#argument_2 + 1] = argument.headPart.CFrame.p
    end

    local cframe = CFrame.new(
        Vector3.new(0, 0, 0),
        Vector3.new(argument.camera.CoordinateFrame.lookVector.X, 0, argument.camera.CoordinateFrame.lookVector.Z)
    )
    local position = (argument.torsoPart and argument.torsoPart.Position) or argument.humanoidRootPart.Position
    local values_4 = { argument.torsoPart }

    if argument.headPart then
        values_4[#values_4 + 1] = argument.headPart
    end

    for n = 1, 24 do
        local quotient = math.tau * n / 24
        local product = cframe * (Vector3.new(math.cos(quotient), math.sin(quotient), 0) * 3)
        local vector = Vector3.new(product.X, math.max(product.Y, -2.25), product.Z)
        local part_on_ray_with_whitelist, value =
            game.Workspace:FindPartOnRayWithWhitelist(Ray.new(position + vector, -3 * vector), values_4, false)

        if part_on_ray_with_whitelist then
            argument_2[#argument_2 + 1] = value + (0.2 * (position - value).unit)
        end
    end
end

local function ray_intersection(argument, argument_2, argument_3, argument_4)
    local cross_product = argument_2:Cross(argument_4)
    local difference = argument_3.X - argument.X
    local difference_2 = argument_3.Y - argument.Y
    local difference_3 = argument_3.Z - argument.Z
    local y = argument_2.Y
    local negated_value = -argument_4.Y
    local y_2 = cross_product.Y
    local z = argument_2.Z
    local negated_value_2 = -argument_4.Z
    local z_2 = cross_product.Z
    local sum = (argument_2.X * ((negated_value * z_2) - (y_2 * negated_value_2)))
        - (-argument_4.X * ((y * z_2) - (y_2 * z)))
        + cross_product.X * ((y * negated_value_2) - (negated_value * z))

    if sum == 0 then
        return Vector3.new(0, 0, 0)
    end

    local negated_value_3 = -argument_4.Y
    local y_3 = cross_product.Y
    local negated_value_4 = -argument_4.Z
    local z_3 = cross_product.Z
    local y_4 = argument_2.Y
    local y_5 = cross_product.Y
    local z_4 = argument_2.Z
    local z_5 = cross_product.Z
    sum = argument
        + (
                (
                    (
                        (difference * ((negated_value_3 * z_3) - (y_3 * negated_value_4)))
                        - (-argument_4.X * ((difference_2 * z_3) - (y_3 * difference_3)))
                    )
                    + (cross_product.X * ((difference_2 * negated_value_4) - (negated_value_3 * difference_3)))
                ) / sum
            )
            * argument_2
    local sum_2 = argument_3
        + (
                (
                    (
                        (argument_2.X * ((difference_2 * z_5) - (y_5 * difference_3)))
                        - (difference * ((y_4 * z_5) - (y_5 * z_4)))
                    ) + (cross_product.X * ((y_4 * difference_3) - (difference_2 * z_4)))
                ) / sum
            )
            * argument_4

    if (sum_2 - sum).Magnitude < 0.25 then
        return sum + ((sum_2 - sum) * 0.5)
    end

    return Vector3.new(0, 0, 0)
end

function invisicam.SmartCircleBehavior(argument, argument_2)
    local unit = argument.torsoPart.CFrame.upVector.unit
    local unit_2 = argument.torsoPart.CFrame.rightVector.unit
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p + unit
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p - unit
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p + unit_2
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p - unit_2

    if argument.headPart then
        argument_2[#argument_2 + 1] = argument.headPart.CFrame.p
    end

    local sum = Vector3.new(0, 0.5, 0)
        + ((argument.torsoPart and argument.torsoPart.Position) or argument.humanoidRootPart.Position)
    local value, vector = nil, nil

    for n = 1, 24 do
        local difference = 0.2617993877991494 * n - 1.5707963267948966
        local sum_2 = sum
            + (argument.camera.CFrame - argument.camera.CFrame.p)
                * (Vector3.new(math.cos(difference), math.sin(difference), 0) * 2.5)
        local difference_2 = sum_2 - argument.camera.CFrame.p
        local hit_part, value_2, value_3 =
            game.Workspace:FindPartOnRayWithIgnoreList(Ray.new(sum, sum_2 - sum), { argument.char }, false, false)

        if not hit_part then
            argument_2[#argument_2 + 1] = vector
            continue
        end

        local sum_3 = value_2 + 0.1 * value_3.unit
        local difference_3 = sum_3 - sum
        local unit_3 = difference_3:Cross(difference_2).unit:Cross(value_3).unit

        if not (difference_3.unit:Dot(-unit_3) < difference_3.unit:Dot((sum_3 - argument.camera.CFrame.p).unit)) then
            vector = sum_3
            local hit_part_2, value_4 =
                game.Workspace:FindPartOnRayWithIgnoreList(Ray.new(sum, vector - sum), { argument.char }, false, false)
            vector = (hit_part_2 and (value_4 - (0.1 * (vector - sum).unit))) or vector
            argument_2[#argument_2 + 1] = vector
            continue
        end

        vector = ray_intersection(sum_3, unit_3, sum_2, difference_2)

        if vector.Magnitude > 0 then
            local hit_part_3, value_6, value_7 = game.Workspace:FindPartOnRayWithIgnoreList(
                Ray.new(sum_3, vector - sum_3),
                { argument.char },
                false,
                false
            )
            vector = (hit_part_3 and (value_6 + (0.1 * value_7.unit))) or vector
        else
            vector = sum_3
        end

        local hit_part_4, value_8 =
            game.Workspace:FindPartOnRayWithIgnoreList(Ray.new(sum, vector - sum), { argument.char }, false, false)
        vector = (hit_part_4 and (value_8 - (0.1 * (vector - sum).unit))) or vector
        argument_2[#argument_2 + 1] = vector
    end
end

function invisicam.CheckTorsoReference(argument)
    if not argument.char then
        return
    end

    argument.torsoPart = argument.char:FindFirstChild("Torso")

    if not argument.torsoPart then
        argument.torsoPart = argument.char:FindFirstChild("UpperTorso")

        if not argument.torsoPart then
            argument.torsoPart = argument.char:FindFirstChild("HumanoidRootPart")
        end
    end

    argument.headPart = argument.char:FindFirstChild("Head")
end

function invisicam.CharacterAdded(argument, char, argument_2)
    if argument_2 ~= players.LocalPlayer then
        return
    end

    if argument.childAddedConn then
        argument.childAddedConn:Disconnect()
        argument.childAddedConn = nil
    end

    if argument.childRemovedConn then
        argument.childRemovedConn:Disconnect()
        argument.childRemovedConn = nil
    end

    argument.char = char
    argument.trackedLimbs = {}

    local function child_removed(argument_3)
        argument.trackedLimbs[argument_3] = nil
        argument:CheckTorsoReference()
    end

    local function child_added(torso_part_2)
        if not torso_part_2:IsA("BasePart") then
            return
        end

        if values_2[torso_part_2.Name] then
            argument.trackedLimbs[torso_part_2] = true
        end

        if torso_part_2.Name == "Torso" or torso_part_2.Name == "UpperTorso" then
            argument.torsoPart = torso_part_2
        end

        if torso_part_2.Name ~= "Head" then
            return
        end

        argument.headPart = torso_part_2
    end

    argument.childAddedConn = char.ChildAdded:Connect(child_added)
    argument.childRemovedConn = char.ChildRemoved:Connect(child_removed)

    for _, torso_part in pairs(argument.char:GetChildren()) do
        if not (torso_part:IsA("BasePart")) then
            continue
        end

        if values_2[torso_part.Name] then
            argument.trackedLimbs[torso_part] = true
        end

        if torso_part.Name == "Torso" or torso_part.Name == "UpperTorso" then
            argument.torsoPart = torso_part
        end

        if torso_part.Name == "Head" then
            argument.headPart = torso_part
        end
    end
end

local function assert_types(argument, ...)
    local values_4 = {}
    local text = ""

    for _, item in pairs({ ... }) do
        values_4[item] = true
        text ..= (((text ~= "") and " or ") or "") .. item
    end

    local ty = type(argument)
    assert(values_4[ty], text .. " type expected, got: " .. ty)
end

function invisicam.SetMode(argument, mode)
    assert_types(mode, "number")

    for _, item in pairs(values) do
        if item ~= mode then
            continue
        end

        argument.mode = mode
        argument.behaviorFunction = argument.behaviors[argument.mode]

        return
    end

    error("Invalid mode number")
end

function invisicam.GetObscuredParts(argument)
    return argument.savedHits
end

function invisicam.Cleanup(argument)
    for key, local_transparency_modifier in pairs(argument.savedHits) do
        key.LocalTransparencyModifier = local_transparency_modifier
    end
end

function invisicam.Update(argument, argument_2, argument_3, argument_4)
    if not argument.enabled or not argument.char then
        return argument_3, argument_4
    end

    argument.camera = game.Workspace.CurrentCamera
    local value = nil

    if not argument.humanoidRootPart then
        value = argument.char:FindFirstChildOfClass("Humanoid")

        if value and value.RootPart then
            argument.humanoidRootPart = value.RootPart
        else
            argument.humanoidRootPart = argument.char:FindFirstChild("HumanoidRootPart")

            if not argument.humanoidRootPart then
                return argument_3, argument_4
            end
        end

        local connection_2 = nil
        local connection = argument.humanoidRootPart.AncestryChanged:Connect(function(argument_5, argument_6)
            if argument_5 ~= argument.humanoidRootPart or argument_6 then
                return
            end

            argument.humanoidRootPart = nil

            if not connection_2 or not connection_2.Connected then
                return
            end

            connection_2:Disconnect()
            connection_2 = nil
        end)
        connection_2 = connection
    end

    if not argument.torsoPart then
        argument:CheckTorsoReference()

        if not argument.torsoPart then
            return argument_3, argument_4
        end
    end

    local values_4 = {}
    argument.behaviorFunction(argument, values_4)
    local values_5 = {}
    local values_6 = { argument.char }

    local function add(argument_5)
        values_5[argument_5] = true

        if argument.savedHits[argument_5] then
            return
        end

        argument.savedHits[argument_5] = argument_5.LocalTransparencyModifier
    end

    local number = 0
    local values_7 = {}
    local number_2 = 0.75
    local number_3 = 0.75
    local p = (argument.headPart and argument.headPart.CFrame.p) or values_4[1]
    local parts_obscuring_target = argument.camera:GetPartsObscuringTarget(
        { p, (argument.torsoPart and argument.torsoPart.CFrame.p) or values_4[2] },
        values_6
    )
    local number_4 = number

    for n = 1, #parts_obscuring_target do
        local parts_obscuring_target_entry = parts_obscuring_target[n]
        number_4 += 1
        values_7[parts_obscuring_target_entry] = true

        for _, child in pairs(parts_obscuring_target_entry:GetChildren()) do
            local is_a_result = child:IsA("Decal")

            if is_a_result then
                number_4 += 1
            end
        end

        local is_a_result_2 = value_5:IsA("Texture")

        if is_a_result_2 then
            number_4 += 1
        end
    end

    if number_4 > 0 then
        number_2, number_3 =
            math.pow((0.375 / number_4) + 0.375, 1 / number_4), math.pow((0.25 / number_4) + 0.25, 1 / number_4)
    end

    local parts_obscuring_target_2 = argument.camera:GetPartsObscuringTarget(values_4, values_6)
    number_4 = {}
    local value_2 = nil
    number_4 = number_4

    for n_2 = 1, #parts_obscuring_target_2 do
        local parts_obscuring_target_entry_2 = parts_obscuring_target_2[n_2]

        if values_7[parts_obscuring_target_entry_2] and number_2 then
            value_2 = number_2
        else
            value_2 = number_3
        end

        n_2[parts_obscuring_target_entry_2] = value_2

        if parts_obscuring_target_entry_2.Transparency < n_2[parts_obscuring_target_entry_2] then
            values_5[parts_obscuring_target_entry_2] = true

            if not argument.savedHits[parts_obscuring_target_entry_2] then
                argument.savedHits[parts_obscuring_target_entry_2] =
                    parts_obscuring_target_entry_2.LocalTransparencyModifier
            end
        end

        for _, child_2 in pairs(parts_obscuring_target_entry_2:GetChildren()) do
            if child_2:IsA("Decal") or child_2:IsA("Texture") then
                if not (child_2.Transparency < n_2[parts_obscuring_target_entry_2]) then
                    continue
                end

                n_2[child_2] = n_2[parts_obscuring_target_entry_2]
                values_5[child_2] = true

                if not argument.savedHits[child_2] then
                    argument.savedHits[child_2] = child_2.LocalTransparencyModifier
                end
            end
        end
    end

    for key, local_transparency_modifier in pairs(argument.savedHits) do
        if values_5[key] then
            key.LocalTransparencyModifier = (
                (key.Transparency < 1) and ((number_4[key] - key.Transparency) / (1 - key.Transparency))
            ) or 0
        else
            key.LocalTransparencyModifier = local_transparency_modifier
            argument.savedHits[key] = nil
        end
    end

    return argument_3, argument_4
end

return invisicam
