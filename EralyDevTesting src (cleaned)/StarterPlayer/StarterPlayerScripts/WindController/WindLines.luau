local run_service = game:GetService("RunService")
local terrain = workspace:FindFirstChildOfClass("Terrain")
local values = {}
local wind_lines = {
    UpdateQueue = table.create(10),
}

function wind_lines.Init(argument, argument_2)
    wind_lines.Lifetime = argument_2.Lifetime or 3
    wind_lines.Direction = argument_2.Direction or Vector3.new(1, 0, 0)
    wind_lines.Speed = argument_2.Speed or 6

    if wind_lines.UpdateConnection then
        wind_lines.UpdateConnection:Disconnect()
        wind_lines.UpdateConnection = nil
    end

    for _, item in ipairs(wind_lines.UpdateQueue) do
        item.Attachment0:Destroy()
        item.Attachment1:Destroy()
        item.Trail:Destroy()
    end

    table.clear(wind_lines.UpdateQueue)
    wind_lines.LastSpawned = os.clock()
    local quotient = 1 / (argument_2.SpawnRate or 25)
    wind_lines.UpdateConnection = run_service.Heartbeat:Connect(function()
        local last_spawned = os.clock()

        if quotient < last_spawned - wind_lines.LastSpawned then
            wind_lines:Create()
            wind_lines.LastSpawned = last_spawned
        end

        debug.profilebegin("Wind Lines")

        for index, item_2 in ipairs(wind_lines.UpdateQueue) do
            local difference = last_spawned - item_2.StartClock

            if item_2.Lifetime <= difference then
                item_2.Attachment0:Destroy()
                item_2.Attachment1:Destroy()
                item_2.Trail:Destroy()
                local update_queue_count = #wind_lines.UpdateQueue
                wind_lines.UpdateQueue[index] = wind_lines.UpdateQueue[update_queue_count]
                wind_lines.UpdateQueue[update_queue_count] = nil
            else
                item_2.Trail.MaxLength = 20 - 20 * (difference / item_2.Lifetime)
                local product = (last_spawned + item_2.Seed) * (item_2.Speed * 0.2)
                local position = item_2.Position
                local attachment0 = item_2.Attachment0
                local position2 = (CFrame.new(position, position + item_2.Direction) * CFrame.new(
                    0,
                    0,
                    item_2.Speed * -difference
                )).Position
                local product_2 = math.sin(product) * 0.5
                local product_3 = math.sin(product) * 0.8
                local product_4 = math.sin(product) * 0.5
                attachment0.WorldPosition = position2 + Vector3.new(product_2, product_3, product_4)
                item_2.Attachment1.WorldPosition = item_2.Attachment0.WorldPosition + Vector3.new(0, 0.1, 0)
            end
        end

        debug.profileend()
    end)
end

function wind_lines.Cleanup(argument)
    if wind_lines.UpdateConnection then
        wind_lines.UpdateConnection:Disconnect()
        wind_lines.UpdateConnection = nil
    end

    for _, item in ipairs(wind_lines.UpdateQueue) do
        item.Attachment0:Destroy()
        item.Attachment1:Destroy()
        item.Trail:Destroy()
    end

    table.clear(wind_lines.UpdateQueue)
end

function wind_lines.Create(argument, argument_2)
    debug.profilebegin("Add Wind Line")
    local values_2 = argument_2 or values
    local lifetime = values_2.Lifetime or wind_lines.Lifetime
    local position = values_2.Position

    if not position then
        local c_frame2 = workspace.CurrentCamera.CFrame
        local cframe_angles = CFrame.Angles
        local random_value = math.random(-30, 70)
        local radians = math.rad(random_value)
        local random_value_2 = math.random(-80, 80)
        position = c_frame2
            * cframe_angles(radians, math.rad(random_value_2), 0)
            * CFrame.new(0, 0, math.random(200, 600) * -0.1).Position
    end

    local direction = values_2.Direction or wind_lines.Direction
    local speed = values_2.Speed or wind_lines.Speed

    if speed <= 0 then
        return
    end

    local attachment = Instance.new("Attachment")
    local attachment2 = Instance.new("Attachment")
    local trail = Instance.new("Trail")
    trail.Attachment0 = attachment
    trail.Attachment1 = attachment2
    trail.Texture = "rbxassetid://5699911427"
    trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(0.2, 1.5),
        NumberSequenceKeypoint.new(0.8, 1.5),
        NumberSequenceKeypoint.new(1, 0.5),
    })
    trail.Transparency = NumberSequence.new(0.7)
    trail.FaceCamera = true
    trail.Parent = attachment
    attachment.WorldPosition = position
    attachment2.WorldPosition = position + Vector3.new(0, 0.1, 0)
    local properties = {
        Attachment0 = attachment,
        Attachment1 = attachment2,
        Trail = trail,
        Lifetime = lifetime + math.random(-10, 10) * 0.1,
        Position = position,
        Direction = direction,
        Speed = speed + math.random(-10, 10) * 0.1,
        StartClock = os.clock(),
        Seed = math.random(1, 1000) * 0.1,
    }
    wind_lines.UpdateQueue[#wind_lines.UpdateQueue + 1] = properties
    attachment.Parent = terrain
    attachment2.Parent = terrain
    debug.profileend()
end

return wind_lines
