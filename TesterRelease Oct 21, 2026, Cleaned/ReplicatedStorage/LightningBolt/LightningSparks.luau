local script_parent = require(script.Parent)
local values = {}
local random = Random.new()
local lightning_sparks = {}
lightning_sparks.__index = lightning_sparks

function lightning_sparks.new(lightning_bolt: any, max_spark_count: any, part: userdata, spark_color)
    local instance = setmetatable({}, lightning_sparks)
    instance.Enabled = true

    if part == nil then
        instance.LightningBolt = lightning_bolt
    else
        instance.Part = part
    end

    instance.SparkColor = spark_color
    instance.MaxSparkCount = max_spark_count or 10
    instance.MinSpeed = 4
    instance.MaxSpeed = 6
    instance.MinDistance = 3
    instance.MaxDistance = 6
    instance.MinPartsPerSpark = 8
    instance.MaxPartsPerSpark = 10
    instance.SparksN = 0
    instance.SlotPlayer = {}
    instance.RefIndex = #values + 1
    values[instance.RefIndex] = instance

    return instance
end

function lightning_sparks.Destroy(argument)
    values[argument.RefIndex] = nil

    for key, item in pairs(argument.SlotPlayer) do
        if item.Parts[1].Parent == nil then
            argument.SlotPlayer[key] = nil
        end
    end
end

function RandomVectorOffset(argument, argument_2)
    local product = CFrame.lookAt(Vector3.new(), argument)
        * CFrame.Angles(0, 0, random:NextNumber(0, 6.283185307179586))
    local cframe_angles = CFrame.Angles
    local next_number_result = random:NextNumber(math.cos(argument_2), 1)

    return (product * cframe_angles(math.acos(next_number_result), 0, 0)).LookVector
end

game:GetService("RunService").Heartbeat:Connect(function()
    for _, instance in pairs(values) do
        local instance_2

        if instance.Enabled == true and instance.SparksN < instance.MaxSparkCount then
            if instance.Part == nil then
                local lightning_bolt = instance.LightningBolt

                if lightning_bolt.Parts[1].Parent == nil then
                    instance:Destroy()

                    return
                end

                local parts = lightning_bolt.Parts
                local parts_count = #parts
                instance_2 = instance
                local values_2 = {}

                for index = 1, #parts do
                    local index_6

                    if parts[index].Transparency < 0.3 then
                        values_2[#values_2 + 1] = (index - 0.5) / parts_count
                        index_6 = index
                    else
                        index_6 = index
                    end
                end

                local value, value_2

                if #values_2 == 0 then
                    value = nil
                    value_2 = nil
                else
                    value = math.ceil(values_2[1] * instance_2.MaxSparkCount)
                    value_2 = math.ceil(values_2[#values_2] * instance_2.MaxSparkCount)
                end

                for index_2 = 1, random:NextInteger(1, instance_2.MaxSparkCount - instance_2.SparksN) do
                    if #values_2 == 0 then
                        break
                    end

                    local _ = index_2
                    local values_3 = {}

                    for index_3 = value, value_2 do
                        local index_7

                        if instance_2.SlotPlayer[index_3] == nil then
                            values_3[#values_3 + 1] = index_3
                            index_7 = index_3
                        else
                            index_7 = index_3
                        end
                    end

                    if #values_3 ~= 0 then
                        local value_entry = values_3[random:NextInteger(1, #values_3)]
                        local next_number_result = random:NextNumber(-0.5, 0.5)
                        local quotient = (value_entry - 0.5 + next_number_result) / instance_2.MaxSparkCount
                        local number = 10
                        local number_2 = 1

                        for index_4 = 1, #values_2 do
                            local absolute_value = math.abs(values_2[index_4] - quotient)
                            local index_8

                            if absolute_value < number then
                                number_2 = math.floor(values_2[index_4] * parts_count + 0.5 + 0.5)
                                number = absolute_value
                                index_8 = index_4
                            else
                                index_8 = index_4
                            end
                        end

                        local part_entry = parts[number_2]
                        local values_4 = {}
                        local values_5 = {}
                        values_4.WorldPosition = part_entry.Position
                            + next_number_result * part_entry.CFrame.RightVector * part_entry.Size.X
                        values_5.WorldPosition = values_4.WorldPosition
                            + RandomVectorOffset(part_entry.CFrame.RightVector, 0.7853981633974483)
                                * random:NextNumber(instance_2.MinDistance, instance_2.MaxDistance)
                        values_4.WorldAxis = (values_5.WorldPosition - values_4.WorldPosition).Unit
                        values_5.WorldAxis = values_4.WorldAxis
                        local script_parent_2 = script_parent.new(
                            values_4,
                            values_5,
                            random:NextInteger(instance_2.MinPartsPerSpark, instance_2.MaxPartsPerSpark)
                        )
                        script_parent_2.MinRadius = 0
                        script_parent_2.MaxRadius = 0.8
                        script_parent_2.AnimationSpeed = 0
                        script_parent_2.Thickness = part_entry.Size.Y / 2
                        script_parent_2.MinThicknessMultiplier = 1
                        script_parent_2.MaxThicknessMultiplier = 1
                        script_parent_2.PulseLength = 0.5
                        script_parent_2.PulseSpeed = random:NextNumber(instance_2.MinSpeed, instance_2.MaxSpeed)
                        script_parent_2.FadeLength = 0.25
                        local to_hsv_result, _, value_3 = part_entry.Color:ToHSV()
                        script_parent_2.Color = instance_2.SparkColor or Color3.fromHSV(to_hsv_result, 0.5, value_3)
                        instance_2.SlotPlayer[value_entry] = script_parent_2
                    end
                end
            else
                local part = instance.Part

                if part.Parent == nil then
                    instance:Destroy()

                    return
                end

                instance_2 = instance

                for index_5 = 1, random:NextInteger(1, instance.MaxSparkCount - instance.SparksN) do
                    random:NextNumber(-0.5, 0.5)
                    local values_6 = {}
                    local values_7 = {}
                    local position = part.Position
                    local product = math.random(-150, 150) * 0.01
                    local product_2 = math.random(-150, 150) * 0.01
                    local product_3 = math.random(-150, 150) * 0.01
                    values_6.WorldPosition = position + Vector3.new(product, product_2, product_3)
                    values_7.WorldPosition = values_6.WorldPosition
                        + RandomVectorOffset(part.CFrame.RightVector, 0.7853981633974483)
                            * random:NextNumber(instance_2.MinDistance, instance_2.MaxDistance)
                    values_6.WorldAxis = (values_7.WorldPosition - values_6.WorldPosition).Unit
                    values_7.WorldAxis = values_6.WorldAxis
                    local script_parent_3 = script_parent.new(
                        values_6,
                        values_7,
                        random:NextInteger(instance_2.MinPartsPerSpark, instance_2.MaxPartsPerSpark)
                    )
                    script_parent_3.MinRadius = 0
                    script_parent_3.MaxRadius = 0.8
                    script_parent_3.AnimationSpeed = 0
                    script_parent_3.Thickness = part.Size.X
                    script_parent_3.MinThicknessMultiplier = 1
                    script_parent_3.MaxThicknessMultiplier = 1
                    script_parent_3.PulseLength = random:NextNumber(0.25, 0.75)
                    script_parent_3.PulseSpeed = random:NextNumber(instance_2.MinSpeed, instance_2.MaxSpeed)
                    script_parent_3.FadeLength = random:NextNumber(0.125, 0.375)
                    local to_hsv_result_2, _, value_4 = part.Color:ToHSV()
                    script_parent_3.Color = instance_2.SparkColor or Color3.fromHSV(to_hsv_result_2, 0.5, value_4)
                    local _ = index_5
                end
            end
        else
            instance_2 = instance
        end

        local sparks_n = 0

        for key, item in pairs(instance_2.SlotPlayer) do
            if item.Parts[1].Parent == nil then
                instance_2.SlotPlayer[key] = nil
            else
                sparks_n += 1
            end
        end

        instance_2.SparksN = sparks_n
    end
end)

return lightning_sparks
