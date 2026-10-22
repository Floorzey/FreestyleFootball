local players = game:GetService("Players")
local values = {
    LIMBS = 2,
    MOVEMENT = 3,
    CORNERS = 4,
    CIRCLE1 = 5,
    CIRCLE2 = 6,
    LIMBMOVE = 7,
    SMART_CIRCLE = 8,
    CHAR_OUTLINE = 9,
}
local values_2 = {
    Head = true,
    ["Left Arm"] = true,
    ["Right Arm"] = true,
    ["Left Leg"] = true,
    ["Right Leg"] = true,
    LeftLowerArm = true,
    RightLowerArm = true,
    LeftUpperLeg = true,
    RightUpperLeg = true,
}
local values_3 = { Vector3.new(1, 1, -1), Vector3.new(1, -1, -1), Vector3.new(-1, -1, -1), Vector3.new(-1, 1, -1) }

local function assert_types(argument, ...)
    local values_4 = {}
    local text = ""

    for _, item in pairs({ ... }) do
        values_4[item] = true
        text ..= (text == "" and "" or " or ") .. item
    end

    local value_type = type(argument)
    assert(values_4[value_type], text .. " type expected, got: " .. value_type)
end

local function det3x3(
    argument: number,
    argument_2: number,
    argument_3: number,
    argument_4: number,
    argument_5: number,
    argument_6: number,
    argument_7: number,
    argument_8: number,
    argument_9: number
)
    return argument * (argument_5 * argument_9 - argument_6 * argument_8)
        - argument_2 * (argument_4 * argument_9 - argument_6 * argument_7)
        + argument_3 * (argument_4 * argument_8 - argument_5 * argument_7)
end

local function ray_intersection(argument: vector, argument_2: vector, argument_3: vector, argument_4: vector)
    local cross_product = argument_2:Cross(argument_4)
    local difference = argument_3.X - argument.X
    local difference_2 = argument_3.Y - argument.Y
    local difference_3 = argument_3.Z - argument.Z
    local y = argument_2.Y
    local negated_value = -argument_4.Y
    local y2 = cross_product.Y
    local z = argument_2.Z
    local negated_value_2 = -argument_4.Z
    local z2 = cross_product.Z
    local sum = argument_2.X * (negated_value * z2 - y2 * negated_value_2)
        - -argument_4.X * (y * z2 - y2 * z)
        + cross_product.X * (y * negated_value_2 - negated_value * z)

    if sum == 0 then
        return Vector3.new(0, 0, 0)
    end

    local negated_value_3 = -argument_4.Y
    local y3 = cross_product.Y
    local negated_value_4 = -argument_4.Z
    local z3 = cross_product.Z
    local y4 = argument_2.Y
    local y5 = cross_product.Y
    local z4 = argument_2.Z
    local z5 = cross_product.Z
    local sum_2 = argument
        + (
                difference * (negated_value_3 * z3 - y3 * negated_value_4)
                - -argument_4.X * (difference_2 * z3 - y3 * difference_3)
                + cross_product.X * (difference_2 * negated_value_4 - negated_value_3 * difference_3)
            )
            / sum
            * argument_2
    local sum_3 = argument_3
        + (
                argument_2.X * (difference_2 * z5 - y5 * difference_3)
                - difference * (y4 * z5 - y5 * z4)
                + cross_product.X * (y4 * difference_3 - difference_2 * z4)
            )
            / sum
            * argument_4

    return (sum_3 - sum_2).Magnitude >= 0.25 and Vector3.new(0, 0, 0) or sum_2 + (sum_3 - sum_2) * 0.5
end

local base_occlusion = require(script.Parent:WaitForChild("BaseOcclusion"))
local invisicam = setmetatable({}, base_occlusion)
invisicam.__index = invisicam

function invisicam.new()
    local base_occlusion_2 = base_occlusion.new()
    local instance = setmetatable(base_occlusion_2, invisicam)
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

    if not enabled then
        argument:Cleanup()
    end
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
    for index = 1, 3 do
        local position = argument.humanoidRootPart.Position
        local velocity = argument.humanoidRootPart.Velocity
        local quotient = Vector3.new(velocity.X, 0, velocity.Z).Magnitude / 2
        argument_2[#argument_2 + 1] = position + (index - 1) * argument.humanoidRootPart.CFrame.lookVector * quotient
        local _ = index
    end
end

function invisicam.CornerBehavior(argument, argument_2)
    local c_frame2 = argument.humanoidRootPart.CFrame
    local position = c_frame2.Position
    local difference = c_frame2 - position
    local quotient = argument.char:GetExtentsSize() / 2
    argument_2[#argument_2 + 1] = position

    for index = 1, #values_3 do
        argument_2[#argument_2 + 1] = position + difference * (quotient * values_3[index])
        local _ = index
    end
end

function invisicam.CircleBehavior(argument, argument_2)
    local cframe

    if argument.mode == values.CIRCLE1 then
        cframe = argument.humanoidRootPart.CFrame
    else
        local coordinate_frame = argument.camera.CoordinateFrame
        cframe = coordinate_frame - coordinate_frame.Position + argument.humanoidRootPart.Position
    end

    argument_2[#argument_2 + 1] = cframe.Position

    for index = 0, 9 do
        local product = 0.6283185307179586 * index
        local cosine = math.cos(product)
        local sine = math.sin(product)
        local product_2 = Vector3.new(cosine, sine, 0) * 3
        argument_2[#argument_2 + 1] = cframe * product_2
        local _ = index
    end
end

function invisicam.LimbMoveBehavior(argument, argument_2)
    argument:LimbBehavior(argument_2)
    argument:MoveBehavior(argument_2)
end

function invisicam.CharacterOutlineBehavior(argument, argument_2)
    local unit = argument.torsoPart.CFrame.upVector.unit
    local unit2 = argument.torsoPart.CFrame.rightVector.unit
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p + unit
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p - unit
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p + unit2
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p - unit2

    if argument.headPart then
        argument_2[#argument_2 + 1] = argument.headPart.CFrame.p
    end

    local cframe = CFrame.new(
        Vector3.new(0, 0, 0),
        (Vector3.new(argument.camera.CoordinateFrame.lookVector.X, 0, argument.camera.CoordinateFrame.lookVector.Z))
    )
    local position = argument.torsoPart and argument.torsoPart.Position or argument.humanoidRootPart.Position
    local values_4 = { argument.torsoPart }

    if argument.headPart then
        values_4[#values_4 + 1] = argument.headPart
    end

    for index = 1, 24 do
        local quotient = 6.283185307179586 * index / 24
        local cosine = math.cos(quotient)
        local sine = math.sin(quotient)
        local product = cframe * (Vector3.new(cosine, sine, 0) * 3)
        local x = product.X
        local maximum = math.max(product.Y, -2.25)
        local vector = Vector3.new(x, maximum, product.Z)
        local ray = Ray.new(position + vector, -3 * vector)
        local part_on_ray_with_whitelist, value = game.Workspace:FindPartOnRayWithWhitelist(ray, values_4, false)
        local index_2

        if part_on_ray_with_whitelist then
            argument_2[#argument_2 + 1] = value + 0.2 * (position - value).unit
            index_2 = index
        else
            index_2 = index
        end
    end
end

function invisicam.SmartCircleBehavior(argument, argument_2)
    local unit = argument.torsoPart.CFrame.upVector.unit
    local unit2 = argument.torsoPart.CFrame.rightVector.unit
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p + unit
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p - unit
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p + unit2
    argument_2[#argument_2 + 1] = argument.torsoPart.CFrame.p - unit2

    if argument.headPart then
        argument_2[#argument_2 + 1] = argument.headPart.CFrame.p
    end

    local difference = argument.camera.CFrame - argument.camera.CFrame.p
    local sum = Vector3.new(0, 0.5, 0)
        + (argument.torsoPart and argument.torsoPart.Position or argument.humanoidRootPart.Position)

    for index = 1, 24 do
        local difference_2 = 0.2617993877991494 * index - 1.5707963267948966
        local cosine = math.cos(difference_2)
        local sine = math.sin(difference_2)
        local vector = sum + difference * (Vector3.new(cosine, sine, 0) * 2.5)
        local difference_3 = vector - argument.camera.CFrame.p
        local ray = Ray.new(sum, vector - sum)
        local hit_part, value, value_2 =
            game.Workspace:FindPartOnRayWithIgnoreList(ray, { argument.char }, false, false)

        if hit_part then
            local sum_2 = value + 0.1 * value_2.unit
            local difference_4 = sum_2 - sum
            local unit3 = difference_4:Cross(difference_3).unit:Cross(value_2).unit
            local unit4 = (sum_2 - argument.camera.CFrame.p).unit

            if difference_4.unit:Dot(-unit3) < difference_4.unit:Dot(unit4) then
                vector = ray_intersection(sum_2, unit3, vector, difference_3)

                if vector.Magnitude > 0 then
                    local ray_2 = Ray.new(sum_2, vector - sum_2)
                    local hit_part_2, value_3, value_4 =
                        game.Workspace:FindPartOnRayWithIgnoreList(ray_2, { argument.char }, false, false)

                    if hit_part_2 then
                        vector = value_3 + 0.1 * value_4.unit
                    end
                else
                    vector = sum_2
                end
            else
                vector = sum_2
            end

            local ray_3 = Ray.new(sum, vector - sum)
            local hit_part_3, value_5, _ =
                game.Workspace:FindPartOnRayWithIgnoreList(ray_3, { argument.char }, false, false)

            if hit_part_3 then
                vector = value_5 - 0.1 * (vector - sum).unit
            end
        end

        argument_2[#argument_2 + 1] = vector
        local _ = index
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

function invisicam.CharacterAdded(argument: table, char: userdata, argument_2: userdata)
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
    argument.childAddedConn = char.ChildAdded:Connect(function(child_2)
        if not (child_2:IsA("BasePart")) then
            return
        end

        if values_2[child_2.Name] then
            argument.trackedLimbs[child_2] = true
        end

        if child_2.Name == "Torso" or child_2.Name == "UpperTorso" then
            argument.torsoPart = child_2
        end

        if child_2.Name == "Head" then
            argument.headPart = child_2
        end
    end)
    argument.childRemovedConn = char.ChildRemoved:Connect(function(child_2)
        argument.trackedLimbs[child_2] = nil
        argument:CheckTorsoReference()
    end)

    for _, child in pairs(argument.char:GetChildren()) do
        if child:IsA("BasePart") then
            if values_2[child.Name] then
                argument.trackedLimbs[child] = true
            end

            if child.Name == "Torso" or child.Name == "UpperTorso" then
                argument.torsoPart = child
            end

            if child.Name == "Head" then
                argument.headPart = child
            end
        end
    end
end

function invisicam.SetMode(argument: table, mode: number)
    assert_types(mode, "number")

    for _, item in pairs(values) do
        if item == mode then
            argument.mode = mode
            argument.behaviorFunction = argument.behaviors[argument.mode]

            return
        end
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

function invisicam.Update(argument: table, argument_2: number, argument_3, argument_4)
    if not (argument.enabled and argument.char) then
        return argument_3, argument_4
    end

    argument.camera = game.Workspace.CurrentCamera

    if not argument.humanoidRootPart then
        local humanoid = argument.char:FindFirstChildOfClass("Humanoid")

        if humanoid and humanoid.RootPart then
            argument.humanoidRootPart = humanoid.RootPart
        else
            argument.humanoidRootPart = argument.char:FindFirstChild("HumanoidRootPart")

            if not argument.humanoidRootPart then
                return argument_3, argument_4
            end
        end

        local connection = nil
        connection = argument.humanoidRootPart.AncestryChanged:Connect(function(argument_5, argument_6)
            if argument_5 == argument.humanoidRootPart and not argument_6 then
                argument.humanoidRootPart = nil

                if connection and connection.Connected then
                    connection:Disconnect()
                    connection = nil
                end
            end
        end)
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

        if not argument.savedHits[argument_5] then
            argument.savedHits[argument_5] = argument_5.LocalTransparencyModifier
        end
    end

    local parts_obscuring_target = argument.camera:GetPartsObscuringTarget({
        argument.headPart and argument.headPart.CFrame.p or values_4[1],
        argument.torsoPart and argument.torsoPart.CFrame.p or values_4[2],
    }, values_6)
    local number = 0
    local values_7 = {}
    local number_2 = 0.75
    local number_3 = 0.75

    for index = 1, #parts_obscuring_target do
        local parts_obscuring_target_entry = parts_obscuring_target[index]
        number += 1
        values_7[parts_obscuring_target_entry] = true
        local _ = index

        for _, child in pairs(parts_obscuring_target_entry:GetChildren()) do
            if child:IsA("Decal") or child:IsA("Texture") then
                number += 1
                break
            end
        end
    end

    if number > 0 then
        number_2 = math.pow(0.375 / number + 0.375, 1 / number)
        number_3 = math.pow(0.25 / number + 0.25, 1 / number)
    end

    local parts_obscuring_target2 = argument.camera:GetPartsObscuringTarget(values_4, values_6)
    local values_8 = {}

    for index_2 = 1, #parts_obscuring_target2 do
        local parts_obscuring_target2_entry = parts_obscuring_target2[index_2]
        values_8[parts_obscuring_target2_entry] = values_7[parts_obscuring_target2_entry] and number_2 and number_2
            or number_3

        if parts_obscuring_target2_entry.Transparency < values_8[parts_obscuring_target2_entry] then
            values_5[parts_obscuring_target2_entry] = true

            if not argument.savedHits[parts_obscuring_target2_entry] then
                argument.savedHits[parts_obscuring_target2_entry] =
                    parts_obscuring_target2_entry.LocalTransparencyModifier
            end
        end

        local _ = index_2

        for _, child_2 in pairs(parts_obscuring_target2_entry:GetChildren()) do
            if
                (child_2:IsA("Decal") or child_2:IsA("Texture"))
                and child_2.Transparency < values_8[parts_obscuring_target2_entry]
            then
                values_8[child_2] = values_8[parts_obscuring_target2_entry]
                values_5[child_2] = true

                if not argument.savedHits[child_2] then
                    argument.savedHits[child_2] = child_2.LocalTransparencyModifier
                end
            end
        end
    end

    for key, local_transparency_modifier in pairs(argument.savedHits) do
        if values_5[key] then
            key.LocalTransparencyModifier = key.Transparency < 1
                    and ((values_8[key] - key.Transparency) / (1 - key.Transparency) or 0)
                or 0
        else
            key.LocalTransparencyModifier = local_transparency_modifier
            argument.savedHits[key] = nil
        end
    end

    return argument_3, argument_4
end

return invisicam
