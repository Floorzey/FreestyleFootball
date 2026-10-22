local script_parent = require(script.Parent)
local lightning_sparks = require(script.Parent.LightningSparks)
local random = Random.new()
local os_clock = os.clock

function RandomVectorOffsetBetween(argument, argument_2, argument_3)
    local product = CFrame.lookAt(Vector3.new(), argument)
        * CFrame.Angles(0, 0, random:NextNumber(0, 6.283185307179586))
    local cframe_angles = CFrame.Angles
    local next_number_result = random:NextNumber(math.cos(argument_3), (math.cos(argument_2)))

    return (product * cframe_angles(math.acos(next_number_result), 0, 0)).LookVector
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
    local workspace_current_camera = workspace.CurrentCamera
    local lightning_explosion_2 = Instance.new("Part")
    lightning_explosion_2.Name = "LightningExplosion"
    lightning_explosion_2.Anchored = true
    lightning_explosion_2.CanCollide = false
    lightning_explosion_2.Locked = true
    lightning_explosion_2.CastShadow = false
    lightning_explosion_2.Transparency = 1
    lightning_explosion_2.Size = Vector3.new(0.05, 0.05, 0.05)
    lightning_explosion_2.CFrame = CFrame.lookAt(
        argument + Vector3.new(0, 0.5, 0),
        argument + Vector3.new(0, 0.5, 0) + instance.UpVector
    ) * CFrame.lookAt(Vector3.new(), Vector3.new(0, 1, 0)):inverse()
    lightning_explosion_2.Parent = workspace_current_camera
    local point_light = Instance.new("PointLight")
    point_light.Parent = lightning_explosion_2
    point_light.Color = Color3.new(1, 1, 0.498039)
    game:GetService("TweenService")
        :Create(point_light, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Range = 60,
            Brightness = 5,
        })
        :Play()

    task.delay(0.25, function()
        game:GetService("TweenService")
            :Create(point_light, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Range = 0,
                Brightness = 0,
            })
            :Play()
    end)

    local attachment = Instance.new("Attachment")
    attachment.Parent = lightning_explosion_2
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

    if typeof(color) == "Color3" then
        local color_sequence = ColorSequence.new(color)
        local color_sequence_2 = ColorSequence.new(color)
        clone_2.Color = color_sequence
        clone_3.Color = color_sequence_2
        local to_hsv_result, _, value = Color3.toHSV(color)
        clone.Color = ColorSequence.new(Color3.fromHSV(to_hsv_result, 0.5, value))
    else
        clone_2.Color = color
        clone_3.Color = color
        local keypoints = color.Keypoints

        for index = 1, #keypoints do
            local to_hsv_result_2, _, value_2 = Color3.toHSV(keypoints[index].Value)
            keypoints[index] =
                ColorSequenceKeypoint.new(keypoints[index].Time, Color3.fromHSV(to_hsv_result_2, 0.5, value_2))
            local _ = index
        end

        clone.Color = ColorSequence.new(keypoints)
    end

    clone.Enabled = true
    clone_2.Enabled = true
    clone_3.Enabled = true
    local bolts = {}

    for index_2 = 1, instance.NumBolts do
        local values_2 = {}
        local values_3 = {}
        local world_position = attachment.WorldPosition
        local world_axis = RandomVectorOffsetBetween(instance.UpVector, 1.1344640137963142, 1.3962634015954636)
        values_2.WorldPosition = world_position
        values_2.WorldAxis = world_axis
        local world_position_2 = attachment.WorldPosition
            + values_2.WorldAxis * random:NextNumber(20, 40) * 1.4 * clamped_value
        local world_axis_2 = RandomVectorOffsetBetween(-instance.UpVector, 1.2217304763960306, 1.9198621771937625)
        values_3.WorldPosition = world_position_2
        values_3.WorldAxis = world_axis_2
        local lightning_bolt = script_parent.new(values_2, values_3, 10)
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
        lightning_bolt.Velocity = (values_3.WorldPosition - values_2.WorldPosition).Unit * 0.1 * clamped_value
        bolts[#bolts + 1] = lightning_bolt
        local _ = index_2
    end

    instance.Bolts = bolts
    instance.Attachment = attachment
    instance.Part = lightning_explosion_2
    instance.StartT = os_clock()
    instance.RefIndex = #values + 1
    values[instance.RefIndex] = instance

    return instance
end

function lightning_explosion.Destroy(argument)
    values[argument.RefIndex] = nil
    argument.Part:Destroy()

    for index = 1, #argument.Bolts do
        argument.Bolts[index] = nil
        local _ = index
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    for _, instance in pairs(values) do
        local difference = os_clock() - instance.StartT
        local attachment = instance.Attachment

        if difference < 0.7 then
            if difference > 0.2 then
                local glare_emitter = attachment.GlareEmitter
                local plasma_emitter = attachment.PlasmaEmitter
                attachment.ExplosionBrightspot.Enabled = false
                glare_emitter.Enabled = false
                plasma_emitter.Enabled = false
            end

            local instance_2 = instance

            for index = 1, #instance.Bolts do
                local bolt_entry = instance_2.Bolts[index]
                bolt_entry.Attachment1.WorldPosition = bolt_entry.Attachment1.WorldPosition + bolt_entry.Velocity
                local _ = index
            end
        else
            instance:Destroy()
        end
    end
end)

return lightning_explosion
