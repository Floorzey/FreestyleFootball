local values = {}
values.InitialDistance = 25
values.MinDistance = 10
values.MaxDistance = 100
values.InitialElevation = 35
values.MinElevation = 35
values.MaxElevation = 35
values.ReferenceAzimuth = -45
values.CWAzimuthTravel = 90
values.CCWAzimuthTravel = 90
values.UseAzimuthLimits = false
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local players = game:GetService("Players")
local base_camera = require(script.Parent:WaitForChild("BaseCamera"))
local orbital_camera = setmetatable({}, base_camera)
orbital_camera.__index = orbital_camera

function orbital_camera.new()
    local instance = setmetatable(base_camera.new(), orbital_camera)
    instance.lastUpdate = tick()
    instance.changedSignalConnections = {}
    instance.refAzimuthRad = nil
    instance.curAzimuthRad = nil
    instance.minAzimuthAbsoluteRad = nil
    instance.maxAzimuthAbsoluteRad = nil
    instance.useAzimuthLimits = nil
    instance.curElevationRad = nil
    instance.minElevationRad = nil
    instance.maxElevationRad = nil
    instance.curDistance = nil
    instance.minDistance = nil
    instance.maxDistance = nil
    instance.gamepadDollySpeedMultiplier = 1
    instance.lastUserPanCamera = tick()
    instance.externalProperties = {}
    instance.externalProperties.InitialDistance = 25
    instance.externalProperties.MinDistance = 10
    instance.externalProperties.MaxDistance = 100
    instance.externalProperties.InitialElevation = 35
    instance.externalProperties.MinElevation = 35
    instance.externalProperties.MaxElevation = 35
    instance.externalProperties.ReferenceAzimuth = -45
    instance.externalProperties.CWAzimuthTravel = 90
    instance.externalProperties.CCWAzimuthTravel = 90
    instance.externalProperties.UseAzimuthLimits = false
    instance:LoadNumberValueParameters()
    return instance
end

function orbital_camera.LoadOrCreateNumberValueParameter(self, child_name, argument, callback)
    local first_child = script:FindFirstChild(child_name)
    if first_child and first_child:isA(argument) then
        self.externalProperties[child_name] = first_child.Value
        if callback then
            if self.changedSignalConnections[child_name] then
                self.changedSignalConnections[child_name]:Disconnect()
            end
            self.changedSignalConnections[child_name] = first_child.Changed:Connect(function(argument_2)
                self.externalProperties[child_name] = argument_2
                callback(self)
            end)
        end
        return
    end
    if self.externalProperties[child_name] == nil then
        return
    end
    local instance = Instance.new(argument)
    instance.Name = child_name
    instance.Parent = script
    instance.Value = self.externalProperties[child_name]
    first_child = instance
    if not callback then
        return
    end
    if self.changedSignalConnections[child_name] then
        self.changedSignalConnections[child_name]:Disconnect()
    end
    self.changedSignalConnections[child_name] = first_child.Changed:Connect(function(argument_2)
        self.externalProperties[child_name] = argument_2
        callback(self)
    end)
end

function orbital_camera.SetAndBoundsCheckAzimuthValues(self)
    self.minAzimuthAbsoluteRad = math.rad(self.externalProperties.ReferenceAzimuth)
        - math.abs(math.rad(self.externalProperties.CWAzimuthTravel))
    self.maxAzimuthAbsoluteRad = math.rad(self.externalProperties.ReferenceAzimuth)
        + math.abs(math.rad(self.externalProperties.CCWAzimuthTravel))
    self.useAzimuthLimits = self.externalProperties.UseAzimuthLimits
    if not self.useAzimuthLimits then
        return
    end
    self.curAzimuthRad = math.max(self.curAzimuthRad, self.minAzimuthAbsoluteRad)
    self.curAzimuthRad = math.min(self.curAzimuthRad, self.maxAzimuthAbsoluteRad)
end

function orbital_camera.SetAndBoundsCheckElevationValues(self)
    local maximum = math.max(self.externalProperties.MinElevation, -80)
    local minimum = math.min(self.externalProperties.MaxElevation, 80)
    self.minElevationRad = math.rad(math.min(maximum, minimum))
    self.maxElevationRad = math.rad(math.max(maximum, minimum))
    self.curElevationRad = math.max(self.curElevationRad, self.minElevationRad)
    self.curElevationRad = math.min(self.curElevationRad, self.maxElevationRad)
end

function orbital_camera.SetAndBoundsCheckDistanceValues(self)
    self.minDistance = self.externalProperties.MinDistance
    self.maxDistance = self.externalProperties.MaxDistance
    self.curDistance = math.max(self.curDistance, self.minDistance)
    self.curDistance = math.min(self.curDistance, self.maxDistance)
end

function orbital_camera.LoadNumberValueParameters(self)
    self:LoadOrCreateNumberValueParameter("InitialElevation", "NumberValue", nil)
    self:LoadOrCreateNumberValueParameter("InitialDistance", "NumberValue", nil)
    self:LoadOrCreateNumberValueParameter("ReferenceAzimuth", "NumberValue", self.SetAndBoundsCheckAzimuthValue)
    self:LoadOrCreateNumberValueParameter("CWAzimuthTravel", "NumberValue", self.SetAndBoundsCheckAzimuthValues)
    self:LoadOrCreateNumberValueParameter("CCWAzimuthTravel", "NumberValue", self.SetAndBoundsCheckAzimuthValues)
    self:LoadOrCreateNumberValueParameter("MinElevation", "NumberValue", self.SetAndBoundsCheckElevationValues)
    self:LoadOrCreateNumberValueParameter("MaxElevation", "NumberValue", self.SetAndBoundsCheckElevationValues)
    self:LoadOrCreateNumberValueParameter("MinDistance", "NumberValue", self.SetAndBoundsCheckDistanceValues)
    self:LoadOrCreateNumberValueParameter("MaxDistance", "NumberValue", self.SetAndBoundsCheckDistanceValues)
    self:LoadOrCreateNumberValueParameter("UseAzimuthLimits", "BoolValue", self.SetAndBoundsCheckAzimuthValues)
    self.curAzimuthRad = math.rad(self.externalProperties.ReferenceAzimuth)
    self.curElevationRad = math.rad(self.externalProperties.InitialElevation)
    self.curDistance = self.externalProperties.InitialDistance
    self:SetAndBoundsCheckAzimuthValues()
    self:SetAndBoundsCheckElevationValues()
    self:SetAndBoundsCheckDistanceValues()
end

function orbital_camera.GetModuleName(self)
    return "OrbitalCamera"
end

function orbital_camera.SetInitialOrientation(self, argument)
    if argument and argument.RootPart then
        assert(argument.RootPart, "")
        local unit = (argument.RootPart.CFrame.LookVector - Vector3.new(0, 0.23000000417232513, 0)).Unit
        local _ = camera_utils.GetAngleBetweenXZVectors(unit, self:GetCameraLookVector())
        local angle_offset = math.asin(self:GetCameraLookVector().Y) - math.asin(unit.Y)
        return
    end
    warn("OrbitalCamera could not set initial orientation due to missing humanoid")
end

function orbital_camera.GetCameraToSubjectDistance(self)
    return self.curDistance
end

function orbital_camera.SetCameraToSubjectDistance(self, argument)
    if players.LocalPlayer then
        self.currentSubjectDistance = math.clamp(argument, self.minDistance, self.maxDistance)
        self.currentSubjectDistance = math.max(self.currentSubjectDistance, self.FIRST_PERSON_DISTANCE_THRESHOLD)
    end
    self.inFirstPerson = false
    self:UpdateMouseBehavior()
    return self.currentSubjectDistance
end

function orbital_camera.CalculateNewLookVector(self, argument, argument_2)
    local camera_look_vector = argument or (self:GetCameraLookVector())
    local angle = math.asin(camera_look_vector.Y)
    local vector =
        Vector2.new(argument_2.X, math.clamp(argument_2.Y, angle - 1.3962634015954636, angle - -1.3962634015954636))
    local cframe = CFrame.new(Vector3.new(0, 0, 0), camera_look_vector)
    return (CFrame.Angles(0, -vector.X, 0) * cframe * CFrame.Angles(-vector.Y, 0, 0)).LookVector
end

function orbital_camera.Update(self, argument)
    local time = tick()
    local is_get_rotation_result = camera_input.getRotation() ~= Vector2.new()
    local current_camera = workspace.CurrentCamera
    local cframe = current_camera.CFrame
    local focus = current_camera.Focus
    local local_player = players.LocalPlayer
    local camera_subject = current_camera and current_camera.CameraSubject
    local _ = camera_subject and (camera_subject:IsA("VehicleSeat"))
    local current_camera_2 = current_camera and (current_camera:IsA("SkateboardPlatform"))
    if self.lastUpdate == nil or time - self.lastUpdate > 1 then
        self.lastCameraTransform = nil
    end
    if is_get_rotation_result then
        self.lastUserPanCamera = tick()
    end
    local subject_position = self:GetSubjectPosition()
    if subject_position and local_player and current_camera then
        if self.gamepadDollySpeedMultiplier ~= 1 then
            self:SetCameraToSubjectDistance(self.currentSubjectDistance * self.gamepadDollySpeedMultiplier)
        end
        focus = CFrame.new(subject_position)
        local get_rotation_result = camera_input.getRotation(argument)
        self.curAzimuthRad = self.curAzimuthRad - get_rotation_result.X
        if self.useAzimuthLimits then
            self.curAzimuthRad = math.clamp(self.curAzimuthRad, self.minAzimuthAbsoluteRad, self.maxAzimuthAbsoluteRad)
        else
            self.curAzimuthRad = self.curAzimuthRad ~= 0
                    and math.sign(self.curAzimuthRad) * (math.abs(self.curAzimuthRad) % math.tau)
                or 0
        end
        self.curElevationRad =
            math.clamp(self.curElevationRad + get_rotation_result.Y, self.minElevationRad, self.maxElevationRad)
        cframe = CFrame.new(
            subject_position
                + (
                    self.currentSubjectDistance
                    * (CFrame.fromEulerAnglesYXZ(-self.curElevationRad, self.curAzimuthRad, 0) * Vector3.new(0, 0, 1))
                ),
            subject_position
        )
        self.lastCameraTransform = cframe
        self.lastCameraFocus = focus
        if not camera_subject and not current_camera or not (current_camera:IsA("BasePart")) then
            self.lastSubjectCFrame = nil
            self.lastUpdate = time
            return cframe, focus
        end
        self.lastSubjectCFrame = current_camera.CFrame
    end
    self.lastUpdate = time
    return cframe, focus
end

return orbital_camera
