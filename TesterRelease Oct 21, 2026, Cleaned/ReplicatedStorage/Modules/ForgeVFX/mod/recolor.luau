local values = {
    Single = {
        Color3 = { "Decal", "Texture" },
        Color = { "Part", "Union", "MeshPart", "SpotLight", "PointLight", "SurfaceLight", "SurfaceAppearance" },
    },
    Sequence = {
        Color = { "Beam", "Trail", "ParticleEmitter" },
    },
}

local function warp(argument: number)
    return (argument % 1 + 1) % 1
end

local function multiply_hue(argument: number, argument_2: number)
    return ((argument + (argument_2 - 0.5) * 1) % 1 + 1) % 1
end

local function multiply_channel(argument: number, argument_2: number)
    local difference = argument_2 * 2 - 1

    if difference >= 0 then
        return math.clamp(argument + (1 - argument) * difference, 0, 1)
    end

    local difference_2 = argument - argument * math.abs(difference)

    return math.clamp(difference_2, 0, 1)
end

local function normalize_color(argument)
    local r = argument.R
    local g = argument.G
    local b = argument.B
    local maximum = math.max(1, r, g, b)

    return maximum, Color3.new(r / maximum, g / maximum, b / maximum)
end

local function multiply_rgb(argument, argument_2: number)
    return Color3.new(argument.R * argument_2, argument.G * argument_2, argument.B * argument_2)
end

local function recolor_obj(argument: userdata, argument_2, argument_3: string, argument_4: boolean)
    if not argument_4 and argument:IsA("BasePart") then
        return
    end

    local to_hsv_result, value_2, value_3 = argument_2:ToHSV()

    for _, item in values do
        for key, item_2 in item do
            if table.find(item_2, argument.ClassName) then
                local argument_entry = argument[key]

                if argument_3 == "multiply" then
                    if typeof(argument_entry) == "Color3" then
                        local r = argument_entry.R
                        local g = argument_entry.G
                        local b = argument_entry.B
                        local maximum = math.max(1, r, g, b)
                        local to_hsv_result_2, value_4, value_5 = Color3.new(r / maximum, g / maximum, b / maximum)
                            :ToHSV()
                        local difference = value_2 * 2 - 1
                        local clamped_value

                        if difference >= 0 then
                            clamped_value = math.clamp(value_4 + (1 - value_4) * difference, 0, 1)
                        else
                            local difference_2 = value_4 - value_4 * math.abs(difference)
                            clamped_value = math.clamp(difference_2, 0, 1)
                        end

                        local difference_3 = value_3 * 2 - 1
                        local clamped_value_2

                        if difference_3 >= 0 then
                            clamped_value_2 = math.clamp(value_5 + (1 - value_5) * difference_3, 0, 1)
                        else
                            local difference_4 = value_5 - value_5 * math.abs(difference_3)
                            clamped_value_2 = math.clamp(difference_4, 0, 1)
                        end

                        local from_hsv_result = Color3.fromHSV(
                            ((to_hsv_result_2 + (to_hsv_result - 0.5) * 1) % 1 + 1) % 1,
                            clamped_value,
                            clamped_value_2
                        )
                        argument[key] = Color3.new(
                            from_hsv_result.R * maximum,
                            from_hsv_result.G * maximum,
                            from_hsv_result.B * maximum
                        )
                    elseif typeof(argument_entry) == "ColorSequence" then
                        local items = {}

                        for _, item_3 in argument_entry.Keypoints do
                            local value = item_3.Value
                            local r_2 = value.R
                            local g_2 = value.G
                            local b_2 = value.B
                            local maximum_2 = math.max(1, r_2, g_2, b_2)
                            local to_hsv_result_3, value_6, value_7 =
                                Color3.new(r_2 / maximum_2, g_2 / maximum_2, b_2 / maximum_2):ToHSV()
                            local difference_5 = value_2 * 2 - 1
                            local clamped_value_3

                            if difference_5 >= 0 then
                                clamped_value_3 = math.clamp(value_6 + (1 - value_6) * difference_5, 0, 1)
                            else
                                local difference_6 = value_6 - value_6 * math.abs(difference_5)
                                clamped_value_3 = math.clamp(difference_6, 0, 1)
                            end

                            local difference_7 = value_3 * 2 - 1
                            local clamped_value_4

                            if difference_7 >= 0 then
                                clamped_value_4 = math.clamp(value_7 + (1 - value_7) * difference_7, 0, 1)
                            else
                                local difference_8 = value_7 - value_7 * math.abs(difference_7)
                                clamped_value_4 = math.clamp(difference_8, 0, 1)
                            end

                            local color_sequence_keypoint_new = ColorSequenceKeypoint.new
                            local time = item_3.Time
                            local from_hsv_result_2 = Color3.fromHSV(
                                ((to_hsv_result_3 + (to_hsv_result - 0.5) * 1) % 1 + 1) % 1,
                                clamped_value_3,
                                clamped_value_4
                            )
                            table.insert(
                                items,
                                color_sequence_keypoint_new(time, multiply_rgb(from_hsv_result_2, maximum_2))
                            )
                        end

                        argument[key] = ColorSequence.new(items)
                    end
                elseif typeof(argument_entry) == "Color3" then
                    local r_3 = argument_entry.R
                    local g_3 = argument_entry.G
                    local b_3 = argument_entry.B
                    local maximum_3 = math.max(1, r_3, g_3, b_3)
                    Color3.new(r_3 / maximum_3, g_3 / maximum_3, b_3 / maximum_3)
                    argument[key] =
                        Color3.new(argument_2.R * maximum_3, argument_2.G * maximum_3, argument_2.B * maximum_3)
                elseif typeof(argument_entry) == "ColorSequence" then
                    argument[key] = ColorSequence.new(argument_2)
                end
            end
        end
    end
end

return function(argument, argument_2: string, ...)
    for _, item in { ... } do
        recolor_obj(item, argument, argument_2, true)

        for _, descendant in item:GetDescendants() do
            recolor_obj(descendant, argument, argument_2, false)
        end
    end
end
