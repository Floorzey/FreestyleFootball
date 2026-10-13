local parent = require(script.Parent)
local values = {}
local random = Random.new()
local lightning_sparks = {}
lightning_sparks.__index = lightning_sparks

function lightning_sparks.new(lightning_bolt, max_spark_count, part, spark_color)
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

function lightning_sparks.Destroy(self)
    values[self.RefIndex] = nil
    for key, item in pairs(self.SlotPlayer) do
        if item.Parts[1].Parent == nil then
            self.SlotPlayer[key] = nil
        end
    end
end

function RandomVectorOffset(argument, argument_2)
    return (
        CFrame.lookAt(Vector3.new(), argument)
        * CFrame.Angles(0, 0, random:NextNumber(0, math.tau))
        * CFrame.Angles(math.acos(random:NextNumber(math.cos(argument_2), 1)), 0, 0)
    ).LookVector
end

game:GetService("RunService").Heartbeat:Connect(function()
    local part
    local value = nil
    local value_2 = nil
    for _, instance in pairs(values) do
        if instance.Enabled ~= true then
            local number = 0
            part = number
            for key, item in pairs(instance.SlotPlayer) do
                if item.Parts[1].Parent == nil then
                    instance.SlotPlayer[key] = nil
                else
                    part += 1
                end
            end
            instance.SparksN = part
            continue
        elseif instance.SparksN < instance.MaxSparkCount then
            if instance.Part == nil then
                local lightning_bolt = instance.LightningBolt
                if lightning_bolt.Parts[1].Parent ~= nil then
                    local parts = lightning_bolt.Parts
                    local parts_count = #parts
                    local values_2 = {}
                    for n = 1, #parts do
                        if parts[n].Transparency < 0.3 then
                            values_2[#values_2 + 1] = (n - 0.5) / parts_count
                        end
                    end
                    local value_3 = nil
                    local value_4 = nil
                    if #values_2 == 0 then
                        value, value_2 = value_3, value_4
                    else
                        value, value_2 =
                            math.ceil(values_2[1] * instance.MaxSparkCount),
                            math.ceil(values_2[#values_2] * instance.MaxSparkCount)
                    end
                    for index = 1, random:NextInteger(1, instance.MaxSparkCount - instance.SparksN) do
                        if #values_2 == 0 then
                            break
                        end
                        local values_3 = {}
                        for n_2 = value, value_2 do
                            if instance.SlotPlayer[n_2] == nil then
                                values_3[#values_3 + 1] = n_2
                            end
                        end
                        if #values_3 == 0 then
                            continue
                        end
                        local value_entry = values_3[random:NextInteger(1, #values_3)]
                        local next_number_result = random:NextNumber(-0.5, 0.5)
                        local number_2 = 10
                        local number_3 = 1
                        for n_3 = 1, #values_2 do
                            local absolute_value = math.abs(
                                values_2[n_3] - ((value_entry - 0.5) + next_number_result) / instance.MaxSparkCount
                            )
                            if absolute_value < number_2 then
                                number_2, number_3 =
                                    absolute_value, math.floor(((values_2[n_3] * parts_count) + 0.5) + 0.5)
                            end
                        end
                        local part_entry = parts[number_3]
                        local values_4 = {}
                        local values_5 = {}
                        values_4.WorldPosition = part_entry.Position
                            + ((next_number_result * part_entry.CFrame.RightVector) * part_entry.Size.X)
                        values_5.WorldPosition = values_4.WorldPosition
                            + (
                                RandomVectorOffset(part_entry.CFrame.RightVector, 0.7853981633974483)
                                * random:NextNumber(instance.MinDistance, instance.MaxDistance)
                            )
                        values_4.WorldAxis = (values_5.WorldPosition - values_4.WorldPosition).Unit
                        values_5.WorldAxis = values_4.WorldAxis
                        local parent_2 = parent.new(
                            values_4,
                            values_5,
                            random:NextInteger(instance.MinPartsPerSpark, instance.MaxPartsPerSpark)
                        )
                        parent_2.MinRadius = 0
                        parent_2.MaxRadius = 0.8
                        parent_2.AnimationSpeed = 0
                        parent_2.Thickness = part_entry.Size.Y / 2
                        parent_2.MinThicknessMultiplier = 1
                        parent_2.MaxThicknessMultiplier = 1
                        parent_2.PulseLength = 0.5
                        parent_2.PulseSpeed = random:NextNumber(instance.MinSpeed, instance.MaxSpeed)
                        parent_2.FadeLength = 0.25
                        local to_hsv_result, value_5, value_6 = part_entry.Color:ToHSV()
                        parent_2.Color = instance.SparkColor or Color3.fromHSV(to_hsv_result, 0.5, value_6)
                        instance.SlotPlayer[value_entry] = parent_2
                    end
                    local number_4 = 0
                    part = number_4
                    for key_2, item_2 in pairs(instance.SlotPlayer) do
                        if item_2.Parts[1].Parent == nil then
                            instance.SlotPlayer[key_2] = nil
                        else
                            part += 1
                        end
                    end
                    instance.SparksN = part
                    continue
                else
                    instance:Destroy()
                    return
                end
            else
                part = instance.Part
                if part.Parent ~= nil then
                    for index_2 = 1, random:NextInteger(1, instance.MaxSparkCount - instance.SparksN) do
                        local next_number_result_2 = random:NextNumber(-0.5, 0.5)
                        local values_6 = {}
                        local values_7 = {}
                        values_6.WorldPosition = part.Position
                            + Vector3.new(
                                math.random(-150, 150) * 0.01,
                                math.random(-150, 150) * 0.01,
                                math.random(-150, 150) * 0.01
                            )
                        values_7.WorldPosition = values_6.WorldPosition
                            + (
                                RandomVectorOffset(part.CFrame.RightVector, 0.7853981633974483)
                                * random:NextNumber(instance.MinDistance, instance.MaxDistance)
                            )
                        values_6.WorldAxis = (values_7.WorldPosition - values_6.WorldPosition).Unit
                        values_7.WorldAxis = values_6.WorldAxis
                        local parent_3 = parent.new(
                            values_6,
                            values_7,
                            random:NextInteger(instance.MinPartsPerSpark, instance.MaxPartsPerSpark)
                        )
                        parent_3.MinRadius = 0
                        parent_3.MaxRadius = 0.8
                        parent_3.AnimationSpeed = 0
                        parent_3.Thickness = part.Size.X
                        parent_3.MinThicknessMultiplier = 1
                        parent_3.MaxThicknessMultiplier = 1
                        parent_3.PulseLength = random:NextNumber(0.25, 0.75)
                        parent_3.PulseSpeed = random:NextNumber(instance.MinSpeed, instance.MaxSpeed)
                        parent_3.FadeLength = random:NextNumber(0.125, 0.375)
                        local to_hsv_result_2, value_7, value_8 = part.Color:ToHSV()
                        parent_3.Color = instance.SparkColor or Color3.fromHSV(to_hsv_result_2, 0.5, value_8)
                    end
                    local number_5 = 0
                    part = number_5
                    for key_3, item_3 in pairs(instance.SlotPlayer) do
                        if item_3.Parts[1].Parent == nil then
                            instance.SlotPlayer[key_3] = nil
                        else
                            part += 1
                        end
                    end
                    instance.SparksN = part
                    continue
                else
                    instance:Destroy()
                    return
                end
            end
        else
            local number_6 = 0
            part = number_6
            for key_4, item_4 in pairs(instance.SlotPlayer) do
                if item_4.Parts[1].Parent == nil then
                    instance.SlotPlayer[key_4] = nil
                else
                    part += 1
                end
            end
            instance.SparksN = part
        end
    end
end)

return lightning_sparks
