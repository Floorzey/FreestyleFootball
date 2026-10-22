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

function wind_shake.Connect(self, argument, signal)
    local callback = self[argument]
    local is_function = typeof(callback) == "function"
    assert(is_function, "Unknown function: " .. argument)
    return signal:Connect(function(...)
        return callback(self, ...)
    end)
end

function wind_shake.AddObjectShake(self, argument, argument_2)
    if typeof(argument) ~= "Instance" or not argument:IsA("BasePart") then
        return
    end
    local object_metadata = self.ObjectMetadata
    if object_metadata[argument] then
        return
    end
    self.Handled = self.Handled + 1
    object_metadata[argument] = {
        Node = self.Octree:CreateNode(argument.Position, argument),
        Settings = settings.new(argument, settings_2),
        Seed = math.random(1000) * 0.1,
        Origin = argument.CFrame,
    }
    self:UpdateObjectSettings(argument, argument_2)
    bindable_event:Fire(argument)
end

function wind_shake.RemoveObjectShake(self, argument)
    if typeof(argument) ~= "Instance" then
        return
    end
    local object_metadata = self.ObjectMetadata
    local object_metadata_entry = object_metadata[argument]
    if object_metadata_entry then
        self.Handled = self.Handled - 1
        object_metadata[argument] = nil
        object_metadata_entry.Settings:Destroy()
        object_metadata_entry.Node:Destroy()
        if argument:IsA("BasePart") then
            argument.CFrame = object_metadata_entry.Origin
        end
    end
    bindable_event_2:Fire(argument)
end

function wind_shake.Update(self)
    local last_update = os.clock()
    local last_update_offset = last_update - self.LastUpdate
    if last_update_offset < 0.022222222222222223 then
        return
    end
    self.LastUpdate = last_update
    debug.profilebegin("WindShake")
    local current_camera = workspace.CurrentCamera
    local cframe = current_camera and current_camera.CFrame
    debug.profilebegin("Octree Search")
    local radius_search_result = self.Octree:RadiusSearch(cframe.Position + (cframe.LookVector * 115), 120)
    debug.profileend()
    local active = #radius_search_result
    self.Active = active
    if active < 1 then
        return
    end
    local minimum = math.min(1, last_update_offset * 8)
    local create_result = table.create(active)
    local object_metadata = self.ObjectMetadata
    debug.profilebegin("Calc")
    for index, item in ipairs(radius_search_result) do
        local mouse = object_metadata[item]
        local origin = mouse.Origin
        if last_update - (mouse.LastCompute or 0) > 0.03333333333333333 then
            local settings_3 = mouse.Settings
            local seed = mouse.Seed
            local wind_power_offset = settings_3.WindPower * 0.1
            local last_update_offset_2 = last_update * (settings_3.WindSpeed * 0.08)
            local noise_result_offset = math.noise(last_update_offset_2, 0, seed) * wind_power_offset
            local noise_result_offset_2 = math.noise(last_update_offset_2, 0, -seed) * wind_power_offset
            local noise_result_offset_3 = math.noise(last_update_offset_2, 0, seed + seed) * wind_power_offset
            local pivot_offset = item.PivotOffset
            mouse.Target = (
                (
                    (origin * pivot_offset)
                    * CFrame.Angles(noise_result_offset, noise_result_offset_2, noise_result_offset_3)
                )
                + (
                    settings_3.WindDirection
                    * ((0.5 + math.noise(last_update_offset_2, seed, seed)) * wind_power_offset)
                )
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

function wind_shake.Pause(self)
    if self.UpdateConnection then
        self.UpdateConnection:Disconnect()
        self.UpdateConnection = nil
    end
    self.Active = 0
    self.Running = false
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

function wind_shake.Cleanup(self)
    if not self.Initialized then
        return
    end
    self:Pause()
    if self.AddedConnection then
        self.AddedConnection:Disconnect()
        self.AddedConnection = nil
    end
    if self.RemovedConnection then
        self.RemovedConnection:Disconnect()
        self.RemovedConnection = nil
    end
    table.clear(self.ObjectMetadata)
    self.Octree:ClearNodes()
    self.Handled = 0
    self.Active = 0
    self.Initialized = false
end

function wind_shake.UpdateObjectSettings(self, argument, argument_2)
    if typeof(argument) ~= "Instance" or typeof(argument_2) ~= "table" then
        return
    end
    if self.ObjectMetadata[argument] or argument == script then
        for attribute_name, attribute_value in pairs(argument_2) do
            argument:SetAttribute(attribute_name, attribute_value)
        end
        bindable_event_3:Fire(argument)
        return
    end
end

function wind_shake.UpdateAllObjectSettings(self, argument)
    if typeof(argument) ~= "table" then
        return
    end
    for key, _ in pairs(self.ObjectMetadata) do
        for attribute_name, attribute_value in pairs(argument) do
            key:SetAttribute(attribute_name, attribute_value)
        end
        bindable_event_3:Fire(key)
    end
end

function wind_shake.SetDefaultSettings(self, argument)
    self:UpdateObjectSettings(script, argument)
end

return wind_shake
