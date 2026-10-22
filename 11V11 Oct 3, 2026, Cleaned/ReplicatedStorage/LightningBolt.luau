local clock = os.clock

function DiscretePulse(argument, argument_2, argument_3, argument_4, argument_5, argument_6, argument_7)
    return (
        math.clamp(
            (argument_3 / (2 * argument_4))
                - math.abs(((argument - (argument_5 * argument_2)) + (0.5 * argument_3)) / argument_4),
            argument_6,
            argument_7
        )
    )
end

function NoiseBetween(argument, argument_2, argument_3, argument_4, argument_5)
    return argument_4 + ((argument_5 - argument_4) * (math.noise(argument, argument_2, argument_3) + 0.5))
end

function CubicBezier(argument, argument_2, argument_3, argument_4, argument_5)
    return (
        ((argument * ((1 - argument_5) ^ 3)) + (((argument_2 * 3) * argument_5) * ((1 - argument_5) ^ 2)))
        + (((argument_3 * 3) * (1 - argument_5)) * (argument_5 ^ 2))
    ) + (argument_4 * (argument_5 ^ 3))
end

local part = Instance.new("Part")
part.TopSurface = 0
part.BottomSurface = 0
part.Anchored = true
part.CanCollide = false
part.Shape = "Cylinder"
part.Name = "BoltPart"
part.Material = Enum.Material.Neon
part.Color = Color3.new(1, 1, 1)
part.Transparency = 1
local _ = Random.new()
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
    instance.PulseLength = 1e+06
    instance.FadeLength = 0.2
    instance.ContractFrom = 0.5
    instance.Color = Color3.new(1, 1, 1)
    instance.ColorOffsetSpeed = 3
    instance.Parts = {}
    local temp = workspace.Temp
    local world_position = attachment0.WorldPosition
    local world_position_2 = attachment1.WorldPosition
    local number = argument or 30
    local value, value_2 = nil, nil
    local world_position_3
    value, world_position_3 = world_position, world_position
    for n = 1, number do
        local cubic_bezier_result = CubicBezier(
            world_position,
            attachment0.WorldPosition + (attachment0.WorldAxis * instance.CurveSize0),
            attachment1.WorldPosition - (attachment1.WorldAxis * instance.CurveSize1),
            world_position_2,
            n / number
        )
        if n == number then
            value_2 = cubic_bezier_result
            local clone = part:Clone()
            clone.Size = Vector3.new((value_2 - world_position_3).Magnitude, 0, 0)
            clone.CFrame = CFrame.lookAt(0.5 * (world_position_3 + value_2), value_2) * inverse_result
            clone.Parent = temp
            clone.Locked = true
            clone.CastShadow = false
            instance.Parts[n] = clone
            value, world_position_3 = cubic_bezier_result, value_2
            continue
        end
        local position = CFrame.lookAt(value, cubic_bezier_result).Position
        value_2 = position or cubic_bezier_result
        local clone_2 = part:Clone()
        clone_2.Size = Vector3.new((value_2 - world_position_3).Magnitude, 0, 0)
        clone_2.CFrame = CFrame.lookAt(0.5 * (world_position_3 + value_2), value_2) * inverse_result
        clone_2.Parent = temp
        clone_2.Locked = true
        clone_2.CastShadow = false
        instance.Parts[n] = clone_2
        value, world_position_3 = cubic_bezier_result, value_2
    end
    instance.PartsHidden = false
    instance.DisabledTransparency = 1
    instance.StartT = clock()
    instance.RanNum = math.random() * 100
    instance.RefIndex = #values + 1
    values[instance.RefIndex] = instance
    return instance
end

function lightning_bolt.Destroy(self)
    values[self.RefIndex] = nil
    for n = 1, #self.Parts do
        self.Parts[n]:Destroy()
        if n % 100 == 0 then
            wait()
        end
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    for _, instance in pairs(values) do
        if instance.Enabled == true then
            instance.PartsHidden = false
            local min_radius = instance.MinRadius
            local max_radius = instance.MaxRadius
            local thickness = instance.Thickness
            local parts = instance.Parts
            local parts_count = #parts
            local ran_num = instance.RanNum
            local animation_speed = instance.AnimationSpeed
            local frequency = instance.Frequency
            local min_thickness_multiplier = instance.MinThicknessMultiplier
            local max_thickness_multiplier = instance.MaxThicknessMultiplier
            local attachment0 = instance.Attachment0
            local attachment1 = instance.Attachment1
            local world_position = attachment0.WorldPosition
            local world_position_2 = attachment1.WorldPosition
            local result_offset = clock() - instance.StartT
            local pulse_length = instance.PulseLength
            local pulse_speed = instance.PulseSpeed
            local fade_length = instance.FadeLength
            local color = instance.Color
            local color_offset_speed = instance.ColorOffsetSpeed
            local number_offset = 1 - instance.ContractFrom
            if not (result_offset < (pulse_length + 1) / pulse_speed) then
                instance:Destroy()
                continue
            end
            local world_position_3, world_position_4 = world_position, world_position
            for n = 1, parts_count do
                local part_entry = parts[n]
                local n_offset = n / parts_count
                local discrete_pulse_result = DiscretePulse(
                    n_offset,
                    pulse_speed,
                    pulse_length,
                    fade_length,
                    result_offset,
                    1 - instance.MaxTransparency,
                    1 - instance.MinTransparency
                )
                local cubic_bezier_result = CubicBezier(
                    world_position,
                    attachment0.WorldPosition + (attachment0.WorldAxis * instance.CurveSize0),
                    attachment1.WorldPosition - (attachment1.WorldAxis * instance.CurveSize1),
                    world_position_2,
                    n_offset
                )
                local result_offset_offset = -result_offset
                local animation_speed_offset_offset_offset_offset = (
                    (animation_speed * result_offset_offset) + ((frequency * 10) * n_offset)
                )
                    - 0.2
                    + ran_num * 4
                local number_offset_offset = 5
                        * ((((animation_speed * 0.01) * result_offset_offset) / 10) + (frequency * n_offset))
                    + ran_num * 4
                local noise_between_result_offset = NoiseBetween(
                    5 * animation_speed_offset_offset_offset_offset,
                    1.5,
                    1 * number_offset_offset,
                    0,
                    0.6283185307179586
                ) + NoiseBetween(
                    0.5 * animation_speed_offset_offset_offset_offset,
                    1.5,
                    0.1 * number_offset_offset,
                    0,
                    5.654866776461628
                )
                local noise_between_result_offset_2 = NoiseBetween(
                    3.4,
                    number_offset_offset,
                    animation_speed_offset_offset_offset_offset,
                    min_radius,
                    max_radius
                ) * math.exp(((n_offset - 0.5) ^ 10) * -5000)
                local noise_between_result = NoiseBetween(
                    2.3,
                    number_offset_offset,
                    animation_speed_offset_offset_offset_offset,
                    min_thickness_multiplier,
                    max_thickness_multiplier
                )
                local position = (
                    (n ~= parts_count)
                    and ((CFrame.new(world_position_3, cubic_bezier_result) * CFrame.Angles(
                        0,
                        0,
                        noise_between_result_offset
                    )) * CFrame.Angles(
                        math.acos(
                            math.clamp(
                                NoiseBetween(
                                    number_offset_offset,
                                    animation_speed_offset_offset_offset_offset,
                                    2.7,
                                    6.123233995736766e-17,
                                    1
                                ),
                                -1,
                                1
                            )
                        ),
                        0,
                        0
                    ) * CFrame.new(0, 0, -noise_between_result_offset_2)).Position
                ) or cubic_bezier_result
                if number_offset < discrete_pulse_result then
                    part_entry.Size = Vector3.new(
                        (position - world_position_4).Magnitude,
                        (thickness * noise_between_result) * discrete_pulse_result,
                        (thickness * noise_between_result) * discrete_pulse_result
                    )
                    part_entry.CFrame = CFrame.lookAt(0.5 * (world_position_4 + position), position) * inverse_result
                    part_entry.Transparency = 1 - discrete_pulse_result
                elseif number_offset - 1 / (parts_count * fade_length) < discrete_pulse_result then
                    local number_offset_offset_2 = (
                        1
                        - (
                            (
                                (discrete_pulse_result - (number_offset - (1 / (parts_count * fade_length))))
                                * parts_count
                            ) * fade_length
                        )
                    )
                        * (((n_offset < (result_offset * pulse_speed) - (0.5 * pulse_length)) and 1) or -1)
                    part_entry.Size = Vector3.new(
                        (1 - math.abs(number_offset_offset_2)) * (position - world_position_4).Magnitude,
                        (thickness * noise_between_result) * discrete_pulse_result,
                        (thickness * noise_between_result) * discrete_pulse_result
                    )
                    part_entry.CFrame = CFrame.lookAt(
                        world_position_4
                            + (
                                (position - world_position_4)
                                * (math.max(0, number_offset_offset_2) + ((1 - math.abs(number_offset_offset_2)) * 0.5))
                            ),
                        position
                    ) * inverse_result
                    part_entry.Transparency = 1 - discrete_pulse_result
                else
                    part_entry.Transparency = 1
                end
                if typeof(color) == "Color3" then
                    part_entry.Color = color
                    world_position_3, world_position_4 = cubic_bezier_result, position
                    continue
                end
                n_offset = ((ran_num + n_offset) - (result_offset * color_offset_speed)) % 1
                local keypoints = color.Keypoints
                for n_2 = 1, #keypoints - 1 do
                    if not (keypoints[n_2].Time < n_offset) then
                        continue
                    end
                    if n_offset < keypoints[n_2 + 1].Time then
                        part_entry.Color = keypoints[n_2].Value:lerp(
                            keypoints[n_2 + 1].Value,
                            (n_offset - keypoints[n_2].Time) / (keypoints[n_2 + 1].Time - keypoints[n_2].Time)
                        )
                        break
                    else
                        continue
                    end
                end
                world_position_3, world_position_4 = cubic_bezier_result, position
            end
        elseif instance.PartsHidden == false then
            instance.PartsHidden = true
            local disabled_transparency = instance.DisabledTransparency
            for n_3 = 1, #instance.Parts do
                instance.Parts[n_3].Transparency = disabled_transparency
            end
        end
    end
end)

return lightning_bolt
