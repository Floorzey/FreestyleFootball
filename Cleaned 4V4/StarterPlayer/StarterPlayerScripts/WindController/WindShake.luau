local collection_service = game:GetService("CollectionService")
local run_service = game:GetService("RunService")
local settings = require(script.Settings)
local octree = require(script.Octree)
local settings_2 = settings.new(script, { WindDirection = Vector3.new(0.5, 0, 0.5), WindPower = 0.5, WindSpeed = 20 })
local bindable_event = Instance.new("BindableEvent")
local bindable_event_2 = Instance.new("BindableEvent")
local bindable_event_3 = Instance.new("BindableEvent")
local bindable_event_4 = Instance.new("BindableEvent")
local bindable_event_5 = Instance.new("BindableEvent")
local wind_shake = { Handled = 0, Active = 0 }
wind_shake.ObjectMetadata = {}
wind_shake.Octree = octree.new()
wind_shake.LastUpdate = os.clock()
wind_shake.ObjectShakeAdded = bindable_event.Event
wind_shake.ObjectShakeRemoved = bindable_event_2.Event
wind_shake.ObjectShakeUpdated = bindable_event_3.Event
wind_shake.Paused = bindable_event_4.Event
wind_shake.Resumed = bindable_event_5.Event

function wind_shake.Connect(argument, argument_2, signal)
    local callback = argument[argument_2]
    local is_function = typeof(callback) == "function"
    assert(is_function, "Unknown function: " .. argument_2)

    return signal:Connect(function(...)
        return callback(argument, ...)
    end)
end

function wind_shake.AddObjectShake(argument, argument_2, argument_3)
    if typeof(argument_2) ~= "Instance" or not argument_2:IsA("BasePart") then
        return
    end

    local object_metadata = argument.ObjectMetadata

    if object_metadata[argument_2] then
        return
    end

    argument.Handled = argument.Handled + 1
    object_metadata[argument_2] = {
        Node = argument.Octree:CreateNode(argument_2.Position, argument_2),
        Settings = settings.new(argument_2, settings_2),
        Seed = math.random(1000) * 0.1,
        Origin = argument_2.CFrame,
    }
    argument:UpdateObjectSettings(argument_2, argument_3)
    bindable_event:Fire(argument_2)
end

function wind_shake.RemoveObjectShake(argument, argument_2)
    if typeof(argument_2) ~= "Instance" then
        return
    end

    local object_metadata = argument.ObjectMetadata
    local object_metadata_entry = object_metadata[argument_2]

    if object_metadata_entry then
        argument.Handled = argument.Handled - 1
        object_metadata[argument_2] = nil
        object_metadata_entry.Settings:Destroy()
        object_metadata_entry.Node:Destroy()

        if argument_2:IsA("BasePart") then
            argument_2.CFrame = object_metadata_entry.Origin
        end
    end

    bindable_event_2:Fire(argument_2)
end

function wind_shake.Update(argument)
    local last_update = os.clock()
    local difference = last_update - argument.LastUpdate

    if difference < 0.022222222222222223 then
        return
    end

    argument.LastUpdate = last_update
    debug.profilebegin("WindShake")
    local current_camera = workspace.CurrentCamera
    local cframe = current_camera and current_camera.CFrame
    debug.profilebegin("Octree Search")
    local radius_search_result = argument.Octree:RadiusSearch(cframe.Position + (cframe.LookVector * 115), 120)
    debug.profileend()
    local active = #radius_search_result
    argument.Active = active

    if active < 1 then
        return
    end

    local minimum = math.min(1, difference * 8)
    local create_result = table.create(active)
    local object_metadata = argument.ObjectMetadata
    debug.profilebegin("Calc")

    for index, item in ipairs(radius_search_result) do
        local mouse = object_metadata[item]
        local origin = mouse.Origin

        if last_update - (mouse.LastCompute or 0) > 0.03333333333333333 then
            local settings_3 = mouse.Settings
            local seed = mouse.Seed
            local product = settings_3.WindPower * 0.1
            local product_2 = last_update * (settings_3.WindSpeed * 0.08)
            local product_3 = math.noise(product_2, 0, seed) * product
            local product_4 = math.noise(product_2, 0, -seed) * product
            local product_5 = math.noise(product_2, 0, seed + seed) * product
            local pivot_offset = item.PivotOffset
            mouse.Target = (
                ((origin * pivot_offset) * CFrame.Angles(product_3, product_4, product_5))
                + (settings_3.WindDirection * ((0.5 + math.noise(product_2, seed, seed)) * product))
            ) * pivot_offset:Inverse()
            mouse.LastCompute = last_update
        end

        local cframe_2 = (mouse.CFrame or origin):Lerp(mouse.Target, minimum)
        mouse.CFrame = cframe_2
        create_result[index] = cframe_2
    end

    debug.profileend()
    workspace:BulkMoveTo(radius_search_result, create_result, Enum.BulkMoveMode.FireCFrameChanged)
    debug.profileend()
end

function wind_shake.Pause(argument)
    if argument.UpdateConnection then
        argument.UpdateConnection:Disconnect()
        argument.UpdateConnection = nil
    end

    argument.Active = 0
    argument.Running = false
    bindable_event_4:Fire()
end

function wind_shake.Resume(signal)
    if signal.Running then
        return
    end

    signal.Running = true
    signal.UpdateConnection = signal:Connect("Update", run_service.Heartbeat)
    bindable_event_5:Fire()
end

function wind_shake.Init(signal)
    if signal.Initialized then
        return
    end

    signal.Initialized = true
    local attribute_value = script:GetAttribute("WindPower")
    local attribute_value_2 = script:GetAttribute("WindSpeed")
    local attribute_value_3 = script:GetAttribute("WindDirection")

    if typeof(attribute_value) ~= "number" then
        script:SetAttribute("WindPower", settings_2.WindPower)
    end

    if typeof(attribute_value_2) ~= "number" then
        script:SetAttribute("WindSpeed", settings_2.WindSpeed)
    end

    if typeof(attribute_value_3) ~= "Vector3" then
        script:SetAttribute("WindDirection", settings_2.WindDirection)
    end

    signal:Cleanup()
    signal.AddedConnection = signal:Connect("AddObjectShake", collection_service:GetInstanceAddedSignal("WindShake"))
    signal.RemovedConnection =
        signal:Connect("RemoveObjectShake", collection_service:GetInstanceRemovedSignal("WindShake"))

    for _, tagged_instance in pairs(collection_service:GetTagged("WindShake")) do
        signal:AddObjectShake(tagged_instance)
    end

    signal:Resume()
end

function wind_shake.Cleanup(argument)
    if not argument.Initialized then
        return
    end

    argument:Pause()

    if argument.AddedConnection then
        argument.AddedConnection:Disconnect()
        argument.AddedConnection = nil
    end

    if argument.RemovedConnection then
        argument.RemovedConnection:Disconnect()
        argument.RemovedConnection = nil
    end

    table.clear(argument.ObjectMetadata)
    argument.Octree:ClearNodes()
    argument.Handled = 0
    argument.Active = 0
    argument.Initialized = false
end

function wind_shake.UpdateObjectSettings(argument, argument_2, argument_3)
    if typeof(argument_2) ~= "Instance" or typeof(argument_3) ~= "table" then
        return
    end

    if not (argument.ObjectMetadata[argument_2] or argument_2 == script) then
        return
    end

    for attribute_name, attribute_value in pairs(argument_3) do
        argument_2:SetAttribute(attribute_name, attribute_value)
    end

    bindable_event_3:Fire(argument_2)

    return
end

function wind_shake.UpdateAllObjectSettings(argument, argument_2)
    if typeof(argument_2) ~= "table" then
        return
    end

    for key, _ in pairs(argument.ObjectMetadata) do
        for attribute_name, attribute_value in pairs(argument_2) do
            key:SetAttribute(attribute_name, attribute_value)
        end

        bindable_event_3:Fire(key)
    end
end

function wind_shake.SetDefaultSettings(argument, argument_2)
    argument:UpdateObjectSettings(script, argument_2)
end

return wind_shake
