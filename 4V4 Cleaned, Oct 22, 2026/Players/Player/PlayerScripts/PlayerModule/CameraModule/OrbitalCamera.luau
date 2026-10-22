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

function orbital_camera.LoadOrCreateNumberValueParameter(argument, child_name, argument_2, callback)
    local first_child = script:FindFirstChild(child_name)

    if first_child and first_child:isA(argument_2) then
        argument.externalProperties[child_name] = first_child.Value

        if callback then
            if argument.changedSignalConnections[child_name] then
                argument.changedSignalConnections[child_name]:Disconnect()
            end

            argument.changedSignalConnections[child_name] = first_child.Changed:Connect(function(argument_3)
                argument.externalProperties[child_name] = argument_3
                callback(argument)
            end)
        end

        return
    end

    if argument.externalProperties[child_name] == nil then
        return
    end

    local instance = Instance.new(argument_2)
    instance.Name = child_name
    instance.Parent = script
    instance.Value = argument.externalProperties[child_name]
    first_child = instance

    if not callback then
        return
    end

    if argument.changedSignalConnections[child_name] then
        argument.changedSignalConnections[child_name]:Disconnect()
    end

    argument.changedSignalConnections[child_name] = first_child.Changed:Connect(function(argument_3)
        argument.externalProperties[child_name] = argument_3
        callback(argument)
    end)
end

function orbital_camera.SetAndBoundsCheckAzimuthValues(argument)
    argument.minAzimuthAbsoluteRad = math.rad(argument.externalProperties.ReferenceAzimuth)
        - math.abs(math.rad(argument.externalProperties.CWAzimuthTravel))
    argument.maxAzimuthAbsoluteRad = math.rad(argument.externalProperties.ReferenceAzimuth)
        + math.abs(math.rad(argument.externalProperties.CCWAzimuthTravel))
    argument.useAzimuthLimits = argument.externalProperties.UseAzimuthLimits

    if not argument.useAzimuthLimits then
        return
    end

    argument.curAzimuthRad = math.max(argument.curAzimuthRad, argument.minAzimuthAbsoluteRad)
    argument.curAzimuthRad = math.min(argument.curAzimuthRad, argument.maxAzimuthAbsoluteRad)
end

function orbital_camera.SetAndBoundsCheckElevationValues(argument)
    local maximum = math.max(argument.externalProperties.MinElevation, -80)
    local minimum = math.min(argument.externalProperties.MaxElevation, 80)
    argument.minElevationRad = math.rad(math.min(maximum, minimum))
    argument.maxElevationRad = math.rad(math.max(maximum, minimum))
    argument.curElevationRad = math.max(argument.curElevationRad, argument.minElevationRad)
    argument.curElevationRad = math.min(argument.curElevationRad, argument.maxElevationRad)
end

function orbital_camera.SetAndBoundsCheckDistanceValues(argument)
    argument.minDistance = argument.externalProperties.MinDistance
    argument.maxDistance = argument.externalProperties.MaxDistance
    argument.curDistance = math.max(argument.curDistance, argument.minDistance)
    argument.curDistance = math.min(argument.curDistance, argument.maxDistance)
end

function orbital_camera.LoadNumberValueParameters(argument)
    argument:LoadOrCreateNumberValueParameter("InitialElevation", "NumberValue", nil)
    argument:LoadOrCreateNumberValueParameter("InitialDistance", "NumberValue", nil)
    argument:LoadOrCreateNumberValueParameter("ReferenceAzimuth", "NumberValue", argument.SetAndBoundsCheckAzimuthValue)
    argument:LoadOrCreateNumberValueParameter("CWAzimuthTravel", "NumberValue", argument.SetAndBoundsCheckAzimuthValues)
    argument:LoadOrCreateNumberValueParameter(
        "CCWAzimuthTravel",
        "NumberValue",
        argument.SetAndBoundsCheckAzimuthValues
    )
    argument:LoadOrCreateNumberValueParameter("MinElevation", "NumberValue", argument.SetAndBoundsCheckElevationValues)
    argument:LoadOrCreateNumberValueParameter("MaxElevation", "NumberValue", argument.SetAndBoundsCheckElevationValues)
    argument:LoadOrCreateNumberValueParameter("MinDistance", "NumberValue", argument.SetAndBoundsCheckDistanceValues)
    argument:LoadOrCreateNumberValueParameter("MaxDistance", "NumberValue", argument.SetAndBoundsCheckDistanceValues)
    argument:LoadOrCreateNumberValueParameter("UseAzimuthLimits", "BoolValue", argument.SetAndBoundsCheckAzimuthValues)
    argument.curAzimuthRad = math.rad(argument.externalProperties.ReferenceAzimuth)
    argument.curElevationRad = math.rad(argument.externalProperties.InitialElevation)
    argument.curDistance = argument.externalProperties.InitialDistance
    argument:SetAndBoundsCheckAzimuthValues()
    argument:SetAndBoundsCheckElevationValues()
    argument:SetAndBoundsCheckDistanceValues()
end

function orbital_camera.GetModuleName(argument)
    return "OrbitalCamera"
end

function orbital_camera.SetInitialOrientation(argument, argument_2)
    if argument_2 and argument_2.RootPart then
        assert(argument_2.RootPart, "")
        local unit = (argument_2.RootPart.CFrame.LookVector - Vector3.new(0, 0.23000000417232513, 0)).Unit
        local _ = camera_utils.GetAngleBetweenXZVectors(unit, argument:GetCameraLookVector())
        local difference = math.asin(argument:GetCameraLookVector().Y) - math.asin(unit.Y)

        return
    end

    warn("OrbitalCamera could not set initial orientation due to missing humanoid")
end

function orbital_camera.GetCameraToSubjectDistance(argument)
    return argument.curDistance
end

function orbital_camera.SetCameraToSubjectDistance(argument, argument_2)
    if players.LocalPlayer then
        argument.currentSubjectDistance = math.clamp(argument_2, argument.minDistance, argument.maxDistance)
        argument.currentSubjectDistance =
            math.max(argument.currentSubjectDistance, argument.FIRST_PERSON_DISTANCE_THRESHOLD)
    end

    argument.inFirstPerson = false
    argument:UpdateMouseBehavior()

    return argument.currentSubjectDistance
end

function orbital_camera.CalculateNewLookVector(argument, argument_2, argument_3)
    local camera_look_vector = argument_2 or argument:GetCameraLookVector()
    local angle = math.asin(camera_look_vector.Y)
    angle = Vector2.new(argument_3.X, math.clamp(argument_3.Y, angle - 1.3962634015954636, angle - -1.3962634015954636))
    local cframe = CFrame.new(Vector3.new(0, 0, 0), camera_look_vector)

    return (CFrame.Angles(0, -angle.X, 0) * cframe * CFrame.Angles(-angle.Y, 0, 0)).LookVector
end

function orbital_camera.Update(argument, argument_2)
    local time = tick()
    local condition = camera_input.getRotation() ~= Vector2.new()
    local current_camera = workspace.CurrentCamera
    local cframe = current_camera.CFrame
    local focus = current_camera.Focus
    local local_player = players.LocalPlayer
    local camera_subject = current_camera and current_camera.CameraSubject
    local _ = camera_subject and camera_subject:IsA("VehicleSeat")
    local is_a_result = current_camera and current_camera:IsA("SkateboardPlatform")

    if argument.lastUpdate == nil or time - argument.lastUpdate > 1 then
        argument.lastCameraTransform = nil
    end

    if condition then
        argument.lastUserPanCamera = tick()
    end

    local subject_position = argument:GetSubjectPosition()

    if subject_position and local_player and current_camera then
        if argument.gamepadDollySpeedMultiplier ~= 1 then
            argument:SetCameraToSubjectDistance(argument.currentSubjectDistance * argument.gamepadDollySpeedMultiplier)
        end

        focus = CFrame.new(subject_position)
        local get_rotation_result = camera_input.getRotation(argument_2)
        argument.curAzimuthRad = argument.curAzimuthRad - get_rotation_result.X

        if argument.useAzimuthLimits then
            argument.curAzimuthRad =
                math.clamp(argument.curAzimuthRad, argument.minAzimuthAbsoluteRad, argument.maxAzimuthAbsoluteRad)
        else
            argument.curAzimuthRad = argument.curAzimuthRad ~= 0
                    and math.sign(argument.curAzimuthRad) * (math.abs(argument.curAzimuthRad) % math.tau)
                or 0
        end

        argument.curElevationRad = math.clamp(
            argument.curElevationRad + get_rotation_result.Y,
            argument.minElevationRad,
            argument.maxElevationRad
        )
        cframe = CFrame.new(
            subject_position
                + (
                    argument.currentSubjectDistance
                    * (
                        CFrame.fromEulerAnglesYXZ(-argument.curElevationRad, argument.curAzimuthRad, 0)
                        * Vector3.new(0, 0, 1)
                    )
                ),
            subject_position
        )
        argument.lastCameraTransform = cframe
        argument.lastCameraFocus = focus

        if not camera_subject and not current_camera or not (current_camera:IsA("BasePart")) then
            argument.lastSubjectCFrame = nil
            argument.lastUpdate = time

            return cframe, focus
        end

        argument.lastSubjectCFrame = current_camera.CFrame
    end

    argument.lastUpdate = time

    return cframe, focus
end

return orbital_camera
