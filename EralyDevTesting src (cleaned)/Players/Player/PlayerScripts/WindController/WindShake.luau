local collection_service = game:GetService("CollectionService")
local run_service = game:GetService("RunService")
local script_settings = require(script.Settings)
local script_octree = require(script.Octree)
local script_settings_2 = script_settings.new(script, {
    WindDirection = Vector3.new(0.5, 0, 0.5),
    WindSpeed = 20,
    WindPower = 0.5,
})
local bindable_event = Instance.new("BindableEvent")
local bindable_event2 = Instance.new("BindableEvent")
local bindable_event3 = Instance.new("BindableEvent")
local bindable_event4 = Instance.new("BindableEvent")
local bindable_event5 = Instance.new("BindableEvent")

return {
    Handled = 0,
    Active = 0,
    ObjectMetadata = {},
    Octree = script_octree.new(),
    LastUpdate = os.clock(),
    ObjectShakeAdded = bindable_event.Event,
    ObjectShakeRemoved = bindable_event2.Event,
    ObjectShakeUpdated = bindable_event3.Event,
    Paused = bindable_event4.Event,
    Resumed = bindable_event5.Event,

    Connect = function(argument: table, argument_2: string, signal: userdata)
        local callback = argument[argument_2]
        local is_function = typeof(callback) == "function"
        assert(is_function, "Unknown function: " .. argument_2)

        return signal:Connect(function(...)
            return callback(argument, ...)
        end)
    end,

    AddObjectShake = function(argument: table, argument_2: userdata, argument_3: table?)
        if typeof(argument_2) ~= "Instance" then
            return
        end

        if not argument_2:IsA("BasePart") then
            return
        end

        local object_metadata = argument.ObjectMetadata

        if object_metadata[argument_2] then
            return
        end

        argument.Handled = argument.Handled + 1
        object_metadata[argument_2] = {
            Node = argument.Octree:CreateNode(argument_2.Position, argument_2),
            Settings = script_settings.new(argument_2, script_settings_2),
            Seed = math.random(1000) * 0.1,
            Origin = argument_2.CFrame,
        }
        argument:UpdateObjectSettings(argument_2, argument_3)
        bindable_event:Fire(argument_2)
    end,

    RemoveObjectShake = function(argument: table, argument_2: userdata)
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

        bindable_event2:Fire(argument_2)
    end,

    Update = function(argument)
        local last_update = os.clock()
        local difference = last_update - argument.LastUpdate

        if difference < 0.022222222222222223 then
            return
        end

        argument.LastUpdate = last_update
        debug.profilebegin("WindShake")
        local workspace_current_camera = workspace.CurrentCamera

        if workspace_current_camera then
            workspace_current_camera = workspace_current_camera.CFrame
        end

        debug.profilebegin("Octree Search")
        local radius_search_result = argument.Octree:RadiusSearch(
            workspace_current_camera.Position + workspace_current_camera.LookVector * 115,
            120
        )
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
            local cframe = mouse.CFrame or origin

            if last_update - (mouse.LastCompute or 0) > 0.03333333333333333 then
                local settings = mouse.Settings
                local seed = mouse.Seed
                local product = settings.WindPower * 0.1
                local product_2 = last_update * (settings.WindSpeed * 0.08)
                local product_3 = math.noise(product_2, 0, seed) * product
                local product_4 = math.noise(product_2, 0, -seed) * product
                local product_5 = math.noise(product_2, 0, seed + seed) * product
                local pivot_offset = item.PivotOffset
                mouse.Target = (
                    origin * pivot_offset * CFrame.Angles(product_3, product_4, product_5)
                    + settings.WindDirection * ((0.5 + math.noise(product_2, seed, seed)) * product)
                ) * pivot_offset:Inverse()
                mouse.LastCompute = last_update
            end

            local cframe_2 = cframe:Lerp(mouse.Target, minimum)
            mouse.CFrame = cframe_2
            create_result[index] = cframe_2
        end

        debug.profileend()
        workspace:BulkMoveTo(radius_search_result, create_result, Enum.BulkMoveMode.FireCFrameChanged)
        debug.profileend()
    end,

    Pause = function(argument)
        if argument.UpdateConnection then
            argument.UpdateConnection:Disconnect()
            argument.UpdateConnection = nil
        end

        argument.Active = 0
        argument.Running = false
        bindable_event4:Fire()
    end,

    Resume = function(signal)
        if signal.Running then
            return
        end

        signal.Running = true
        signal.UpdateConnection = signal:Connect("Update", run_service.Heartbeat)
        bindable_event5:Fire()
    end,

    Init = function(signal)
        if signal.Initialized then
            return
        end

        signal.Initialized = true
        local attribute = script:GetAttribute("WindPower")
        local attribute2 = script:GetAttribute("WindSpeed")
        local attribute3 = script:GetAttribute("WindDirection")

        if typeof(attribute) ~= "number" then
            script:SetAttribute("WindPower", script_settings_2.WindPower)
        end

        if typeof(attribute2) ~= "number" then
            script:SetAttribute("WindSpeed", script_settings_2.WindSpeed)
        end

        if typeof(attribute3) ~= "Vector3" then
            script:SetAttribute("WindDirection", script_settings_2.WindDirection)
        end

        signal:Cleanup()
        signal.AddedConnection =
            signal:Connect("AddObjectShake", (collection_service:GetInstanceAddedSignal("WindShake")))
        signal.RemovedConnection =
            signal:Connect("RemoveObjectShake", (collection_service:GetInstanceRemovedSignal("WindShake")))

        for _, tagged_instance in pairs(collection_service:GetTagged("WindShake")) do
            signal:AddObjectShake(tagged_instance)
        end

        signal:Resume()
    end,

    Cleanup = function(argument)
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
    end,

    UpdateObjectSettings = function(argument: table, argument_2: userdata, argument_3: table)
        if typeof(argument_2) ~= "Instance" then
            return
        end

        if typeof(argument_3) ~= "table" then
            return
        end

        if not argument.ObjectMetadata[argument_2] and argument_2 ~= script then
            return
        end

        for attribute_name, attribute_value in pairs(argument_3) do
            argument_2:SetAttribute(attribute_name, attribute_value)
        end

        bindable_event3:Fire(argument_2)
    end,

    UpdateAllObjectSettings = function(argument: table, argument_2: table)
        if typeof(argument_2) ~= "table" then
            return
        end

        for key, _ in pairs(argument.ObjectMetadata) do
            local key_2 = key

            for attribute_name, attribute_value in pairs(argument_2) do
                key_2:SetAttribute(attribute_name, attribute_value)
            end

            bindable_event3:Fire(key_2)
        end
    end,

    SetDefaultSettings = function(argument: table, argument_2: table)
        argument:UpdateObjectSettings(script, argument_2)
    end,
}
