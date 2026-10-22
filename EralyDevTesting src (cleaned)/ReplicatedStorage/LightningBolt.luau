local os_clock = os.clock

function DiscretePulse(argument, argument_2, argument_3, argument_4, argument_5, argument_6, argument_7)
    local difference = argument_3 / (2 * argument_4)
        - math.abs((argument - argument_5 * argument_2 + 0.5 * argument_3) / argument_4)

    return math.clamp(difference, argument_6, argument_7)
end

function NoiseBetween(argument, argument_2, argument_3, argument_4, argument_5)
    return argument_4 + (argument_5 - argument_4) * (math.noise(argument, argument_2, argument_3) + 0.5)
end

function CubicBezier(argument, argument_2, argument_3, argument_4, argument_5)
    return argument * (1 - argument_5) ^ 3
        + argument_2 * 3 * argument_5 * (1 - argument_5) ^ 2
        + argument_3 * 3 * (1 - argument_5) * argument_5 ^ 2
        + argument_4 * argument_5 ^ 3
end

local bolt_part = Instance.new("Part")
bolt_part.TopSurface = 0
bolt_part.BottomSurface = 0
bolt_part.Anchored = true
bolt_part.CanCollide = false
bolt_part.Shape = "Cylinder"
bolt_part.Name = "BoltPart"
bolt_part.Material = Enum.Material.Neon
bolt_part.Color = Color3.new(1, 1, 1)
bolt_part.Transparency = 1
Random.new()
local inverse_result = CFrame.lookAt(Vector3.new(), Vector3.new(1, 0, 0)):inverse()
local values = {}
local lightning_bolt = {}
lightning_bolt.__index = lightning_bolt

function lightning_bolt.new(attachment0, attachment1, argument)
    local instance = setmetatable({}, lightning_bolt)
    instance.Enabled = true
    instance.Attachment0 = attachment0
    instance.Attachment1 = attachment1
    instance.CurveSize0 = 0
    instance.CurveSize1 = 0
    instance.MinRadius = 0
    instance.MaxRadius = 2.4
    instance.Frequency = 1
    instance.AnimationSpeed = 7
    instance.Thickness = 1
    instance.MinThicknessMultiplier = 0.2
    instance.MaxThicknessMultiplier = 1
    instance.MinTransparency = 0
    instance.MaxTransparency = 1
    instance.PulseSpeed = 2
    instance.PulseLength = 1000000
    instance.FadeLength = 0.2
    instance.ContractFrom = 0.5
    instance.Color = Color3.new(1, 1, 1)
    instance.ColorOffsetSpeed = 3
    instance.Parts = {}
    local workspace_temp = workspace.Temp
    local world_position = attachment0.WorldPosition
    local sum = attachment0.WorldPosition + attachment0.WorldAxis * instance.CurveSize0
    local difference = attachment1.WorldPosition - attachment1.WorldAxis * instance.CurveSize1
    local world_position2 = attachment1.WorldPosition
    local number = argument or 30
    local world_position_2 = world_position
    local world_position_3 = world_position_2
    local world_position_4 = world_position_2
    world_position_2 = world_position_3
    world_position_4 = world_position_3

    for index = 1, number do
        local cubic_bezier_result = CubicBezier(world_position, sum, difference, world_position2, index / number)
        local cubic_bezier_result_2

        if index == number then
            cubic_bezier_result_2 = cubic_bezier_result
        else
            cubic_bezier_result_2 = CFrame.lookAt(world_position_2, cubic_bezier_result).Position or cubic_bezier_result
        end

        local clone = bolt_part:Clone()
        clone.Size = Vector3.new((cubic_bezier_result_2 - world_position_3).Magnitude, 0, 0)
        clone.CFrame = CFrame.lookAt(0.5 * (world_position_3 + cubic_bezier_result_2), cubic_bezier_result_2)
            * inverse_result
        clone.Parent = workspace_temp
        clone.Locked = true
        clone.CastShadow = false
        instance.Parts[index] = clone
        world_position_2 = cubic_bezier_result
        world_position_3 = cubic_bezier_result_2
        local _ = index
    end

    instance.PartsHidden = false
    instance.DisabledTransparency = 1
    instance.StartT = os_clock()
    instance.RanNum = math.random() * 100
    instance.RefIndex = #values + 1
    values[instance.RefIndex] = instance

    return instance
end

function lightning_bolt.Destroy(argument)
    values[argument.RefIndex] = nil

    for index = 1, #argument.Parts do
        argument.Parts[index]:Destroy()
        local index_2

        if index % 100 == 0 then
            wait()
            index_2 = index
        else
            index_2 = index
        end
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    for _, instance in pairs(values) do
        if instance.Enabled == true then
            instance.PartsHidden = false
            local difference = 1 - instance.MaxTransparency
            local difference_2 = 1 - instance.MinTransparency
            local min_radius = instance.MinRadius
            local max_radius = instance.MaxRadius
            local thickness = instance.Thickness
            local parts = instance.Parts
            local parts_count = #parts
            local ran_num = instance.RanNum
            local start_t = instance.StartT
            local animation_speed = instance.AnimationSpeed
            local frequency = instance.Frequency
            local min_thickness_multiplier = instance.MinThicknessMultiplier
            local max_thickness_multiplier = instance.MaxThicknessMultiplier
            local attachment0 = instance.Attachment0
            local attachment1 = instance.Attachment1
            local world_position = attachment0.WorldPosition
            local sum = attachment0.WorldPosition + attachment0.WorldAxis * instance.CurveSize0
            local difference_3 = attachment1.WorldPosition - attachment1.WorldAxis * instance.CurveSize1
            local world_position2 = attachment1.WorldPosition
            local difference_4 = os_clock() - start_t
            local pulse_length = instance.PulseLength
            local pulse_speed = instance.PulseSpeed
            local fade_length = instance.FadeLength
            local color = instance.Color
            local color_offset_speed = instance.ColorOffsetSpeed
            local difference_5 = 1 - instance.ContractFrom

            if difference_4 < (pulse_length + 1) / pulse_speed then
                local world_position_2 = world_position
                local world_position_3 = world_position_2
                local world_position_4 = world_position_2
                world_position_2 = world_position_3
                world_position_4 = world_position_3

                for index = 1, parts_count do
                    local part_entry = parts[index]
                    local quotient = index / parts_count
                    local discrete_pulse_result = DiscretePulse(
                        quotient,
                        pulse_speed,
                        pulse_length,
                        fade_length,
                        difference_4,
                        difference,
                        difference_2
                    )
                    local cubic_bezier_result =
                        CubicBezier(world_position, sum, difference_3, world_position2, quotient)
                    local negated_value = -difference_4
                    local sum_2 = animation_speed * negated_value + frequency * 10 * quotient - 0.2 + ran_num * 4
                    local sum_3 = 5 * (animation_speed * 0.01 * negated_value / 10 + frequency * quotient) + ran_num * 4
                    local sum_4 = NoiseBetween(5 * sum_2, 1.5, 1 * sum_3, 0, 0.6283185307179586)
                        + NoiseBetween(0.5 * sum_2, 1.5, 0.1 * sum_3, 0, 5.654866776461628)
                    local product = NoiseBetween(3.4, sum_3, sum_2, min_radius, max_radius)
                        * math.exp((quotient - 0.5) ^ 10 * -5000)
                    local noise_between_result =
                        NoiseBetween(2.3, sum_3, sum_2, min_thickness_multiplier, max_thickness_multiplier)
                    local cubic_bezier_result_2

                    if index == parts_count then
                        cubic_bezier_result_2 = cubic_bezier_result
                    else
                        local product_2 = CFrame.new(world_position_2, cubic_bezier_result) * CFrame.Angles(0, 0, sum_4)
                        local cframe_angles = CFrame.Angles
                        local noise_between_result_2 = NoiseBetween(sum_3, sum_2, 2.7, 6.123233995736766e-17, 1)
                        local clamped_value = math.clamp(noise_between_result_2, -1, 1)
                        cubic_bezier_result_2 = (product_2 * cframe_angles(math.acos(clamped_value), 0, 0) * CFrame.new(
                            0,
                            0,
                            -product
                        )).Position or cubic_bezier_result
                    end

                    if difference_5 < discrete_pulse_result then
                        part_entry.Size = Vector3.new(
                            (cubic_bezier_result_2 - world_position_3).Magnitude,
                            thickness * noise_between_result * discrete_pulse_result,
                            thickness * noise_between_result * discrete_pulse_result
                        )
                        part_entry.CFrame = CFrame.lookAt(
                            0.5 * (world_position_3 + cubic_bezier_result_2),
                            cubic_bezier_result_2
                        ) * inverse_result
                        part_entry.Transparency = 1 - discrete_pulse_result
                    elseif difference_5 - 1 / (parts_count * fade_length) < discrete_pulse_result then
                        local product_3 = (
                            1
                            - (discrete_pulse_result - (difference_5 - 1 / (parts_count * fade_length)))
                                * parts_count
                                * fade_length
                        )
                            * (quotient < difference_4 * pulse_speed - 0.5 * pulse_length and 1 or -1)
                        local product_4 = (1 - math.abs(product_3))
                            * (cubic_bezier_result_2 - world_position_3).Magnitude
                        part_entry.Size = Vector3.new(
                            product_4,
                            thickness * noise_between_result * discrete_pulse_result,
                            thickness * noise_between_result * discrete_pulse_result
                        )
                        part_entry.CFrame = CFrame.lookAt(
                            world_position_3
                                + (cubic_bezier_result_2 - world_position_3)
                                    * (math.max(0, product_3) + (1 - math.abs(product_3)) * 0.5),
                            cubic_bezier_result_2
                        ) * inverse_result
                        part_entry.Transparency = 1 - discrete_pulse_result
                    else
                        part_entry.Transparency = 1
                    end

                    local index_4

                    if typeof(color) == "Color3" then
                        part_entry.Color = color
                        index_4 = index
                    else
                        local remainder = (ran_num + quotient - difference_4 * color_offset_speed) % 1
                        local keypoints = color.Keypoints
                        index_4 = index

                        for index_2 = 1, #keypoints - 1 do
                            if keypoints[index_2].Time < remainder and remainder < keypoints[index_2 + 1].Time then
                                part_entry.Color = keypoints[index_2].Value:lerp(
                                    keypoints[index_2 + 1].Value,
                                    (remainder - keypoints[index_2].Time)
                                        / (keypoints[index_2 + 1].Time - keypoints[index_2].Time)
                                )
                                break
                            end

                            local _ = index_2
                        end
                    end

                    world_position_2 = cubic_bezier_result
                    world_position_3 = cubic_bezier_result_2
                end
            else
                instance:Destroy()
            end
        elseif instance.PartsHidden == false then
            instance.PartsHidden = true
            local disabled_transparency = instance.DisabledTransparency
            local instance_2 = instance

            for index_3 = 1, #instance.Parts do
                instance_2.Parts[index_3].Transparency = disabled_transparency
                local _ = index_3
            end
        end
    end
end)

return lightning_bolt
