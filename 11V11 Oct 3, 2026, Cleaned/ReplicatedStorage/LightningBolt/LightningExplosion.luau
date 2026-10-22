local parent = require(script.Parent)
local lightning_sparks = require(script.Parent.LightningSparks)
local random = Random.new()
local clock = os.clock

function RandomVectorOffsetBetween(argument, argument_2, argument_3)
    return (
        CFrame.lookAt(Vector3.new(), argument)
        * CFrame.Angles(0, 0, random:NextNumber(0, math.tau))
        * CFrame.Angles(math.acos(random:NextNumber(math.cos(argument_3), math.cos(argument_2))), 0, 0)
    ).LookVector
end

local values = {}
local lightning_explosion = {}
lightning_explosion.__index = lightning_explosion

function lightning_explosion.new(argument, size, num_bolts, color_2, bolt_color, up_vector)
    local instance = setmetatable({}, lightning_explosion)
    instance.Size = size or 1
    instance.NumBolts = num_bolts or 6
    instance.Color = color_2 or ColorSequence.new(Color3.new(1, 1, 0), Color3.new(1, 1, 0.498039))
    instance.BoltColor = bolt_color or Color3.new(1, 1, 0.498039)
    instance.UpVector = up_vector or Vector3.new(0, 1, 0)
    local part = Instance.new("Part")
    part.Name = "LightningExplosion"
    part.Anchored = true
    part.CanCollide = false
    part.Locked = true
    part.CastShadow = false
    part.Transparency = 1
    part.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
    part.CFrame = CFrame.lookAt(
        argument + Vector3.new(0, 0.5, 0),
        (argument + Vector3.new(0, 0.5, 0)) + instance.UpVector
    ) * CFrame.lookAt(Vector3.new(), Vector3.new(0, 1, 0)):inverse()
    part.Parent = workspace.CurrentCamera
    local point_light = Instance.new("PointLight")
    point_light.Parent = part
    point_light.Color = Color3.new(1, 1, 0.498039)
    local tween_properties = { Range = 60, Brightness = 5 }
    game:GetService("TweenService")
        :Create(point_light, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties)
        :Play()
    task.delay(0.25, function()
        local tween_properties_2 = { Range = 0, Brightness = 0 }
        game:GetService("TweenService")
            :Create(
                point_light,
                TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                tween_properties_2
            )
            :Play()
    end)
    local attachment = Instance.new("Attachment")
    attachment.Parent = part
    attachment.CFrame = CFrame.new()
    local clone = script.ExplosionBrightspot:Clone()
    local clone_2 = script.GlareEmitter:Clone()
    local clone_3 = script.PlasmaEmitter:Clone()
    local clamped_value = math.clamp(instance.Size, 0, 1)
    clone_2.Size = NumberSequence.new(clamped_value * 30)
    clone_3.Size = NumberSequence.new(clamped_value * 18)
    clone_3.Speed = NumberRange.new(clamped_value * 100)
    clone.Parent = attachment
    clone_2.Parent = attachment
    clone_3.Parent = attachment
    local color = instance.Color
    if typeof(color) ~= "Color3" then
        clone_2.Color = color
        clone_3.Color = color
        local keypoints = color.Keypoints
        for n = 1, #keypoints do
            local to_hsv_result, _, value = Color3.toHSV(keypoints[n].Value)
            keypoints[n] = ColorSequenceKeypoint.new(keypoints[n].Time, Color3.fromHSV(to_hsv_result, 0.5, value))
        end
        clone.Color = ColorSequence.new(keypoints)
    else
        local color_sequence = ColorSequence.new(color)
        local color_sequence_2 = ColorSequence.new(color)
        clone_2.Color = color_sequence
        clone_3.Color = color_sequence_2
        local to_hsv_result_2, _, value_2 = Color3.toHSV(color)
        clone.Color = ColorSequence.new(Color3.fromHSV(to_hsv_result_2, 0.5, value_2))
    end
    clone.Enabled = true
    clone_2.Enabled = true
    clone_3.Enabled = true
    local bolts = {}
    for _ = 1, instance.NumBolts do
        local values_2 = {}
        local values_3 = {}
        local world_axis = RandomVectorOffsetBetween(instance.UpVector, 1.1344640137963142, 1.3962634015954636)
        values_2.WorldPosition = attachment.WorldPosition
        values_2.WorldAxis = world_axis
        local world_position = attachment.WorldPosition
            + ((values_2.WorldAxis * random:NextNumber(20, 40)) * 1.4) * clamped_value
        local world_axis_2 = RandomVectorOffsetBetween(-instance.UpVector, 1.2217304763960306, 1.9198621771937625)
        values_3.WorldPosition = world_position
        values_3.WorldAxis = world_axis_2
        local lightning_bolt = parent.new(values_2, values_3, 10)
        lightning_bolt.AnimationSpeed = 0
        lightning_bolt.Thickness = 1
        lightning_bolt.Color = instance.BoltColor
        lightning_bolt.PulseLength = 0.8
        lightning_bolt.ColorOffsetSpeed = 20
        lightning_bolt.Frequency = 2
        lightning_bolt.MinRadius = 0
        lightning_bolt.MaxRadius = clamped_value * 4
        lightning_bolt.FadeLength = 0.4
        lightning_bolt.PulseSpeed = 5
        lightning_bolt.MinThicknessMultiplier = 0.7
        lightning_bolt.MaxThicknessMultiplier = 1
        local lightning_sparks_2 = lightning_sparks.new(lightning_bolt, 5)
        lightning_sparks_2.MinDistance = 7.5
        lightning_sparks_2.MaxDistance = 10
        lightning_bolt.Velocity = ((values_3.WorldPosition - values_2.WorldPosition).Unit * 0.1) * clamped_value
        bolts[#bolts + 1] = lightning_bolt
    end
    instance.Bolts = bolts
    instance.Attachment = attachment
    instance.Part = part
    instance.StartT = clock()
    instance.RefIndex = #values + 1
    values[instance.RefIndex] = instance
    return instance
end

function lightning_explosion.Destroy(self)
    values[self.RefIndex] = nil
    self.Part:Destroy()
    for n = 1, #self.Bolts do
        self.Bolts[n] = nil
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    for _, instance in pairs(values) do
        local result_offset = clock() - instance.StartT
        local attachment = instance.Attachment
        if not (result_offset < 0.7) then
            instance:Destroy()
            continue
        end
        if result_offset > 0.2 then
            local glare_emitter = attachment.GlareEmitter
            local plasma_emitter = attachment.PlasmaEmitter
            attachment.ExplosionBrightspot.Enabled = false
            glare_emitter.Enabled = false
            plasma_emitter.Enabled = false
        end
        for n = 1, #instance.Bolts do
            local bolt_entry = instance.Bolts[n]
            bolt_entry.Attachment1.WorldPosition = bolt_entry.Attachment1.WorldPosition + bolt_entry.Velocity
        end
    end
end)

return lightning_explosion
