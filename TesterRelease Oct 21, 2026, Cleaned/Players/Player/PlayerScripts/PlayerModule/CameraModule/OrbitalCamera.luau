local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local players = game:GetService("Players")
local base_camera = require(script.Parent:WaitForChild("BaseCamera"))
local orbital_camera = setmetatable({}, base_camera)
orbital_camera.__index = orbital_camera

function orbital_camera.new()
    local base_camera_2 = base_camera.new()
    local instance = setmetatable(base_camera_2, orbital_camera)
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

function orbital_camera.LoadOrCreateNumberValueParameter(
    argument: table,
    child_name: string,
    argument_2: any,
    callback: any
)
    local first_child = script:FindFirstChild(child_name)

    if first_child and first_child:isA(argument_2) then
        argument.externalProperties[child_name] = first_child.Value
    else
        if argument.externalProperties[child_name] == nil then
            return
        end

        first_child = Instance.new(argument_2)
        first_child.Name = child_name
        first_child.Parent = script
        first_child.Value = argument.externalProperties[child_name]
    end

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
    local radians = math.rad(argument.externalProperties.ReferenceAzimuth)
    local radians_2 = math.rad(argument.externalProperties.CWAzimuthTravel)
    argument.minAzimuthAbsoluteRad = radians - math.abs(radians_2)
    local radians_3 = math.rad(argument.externalProperties.ReferenceAzimuth)
    local radians_4 = math.rad(argument.externalProperties.CCWAzimuthTravel)
    argument.maxAzimuthAbsoluteRad = radians_3 + math.abs(radians_4)
    argument.useAzimuthLimits = argument.externalProperties.UseAzimuthLimits

    if argument.useAzimuthLimits then
        argument.curAzimuthRad = math.max(argument.curAzimuthRad, argument.minAzimuthAbsoluteRad)
        argument.curAzimuthRad = math.min(argument.curAzimuthRad, argument.maxAzimuthAbsoluteRad)
    end
end

function orbital_camera.SetAndBoundsCheckElevationValues(argument)
    local maximum = math.max(argument.externalProperties.MinElevation, -80)
    local minimum = math.min(argument.externalProperties.MaxElevation, 80)
    local minimum_2 = math.min(maximum, minimum)
    argument.minElevationRad = math.rad(minimum_2)
    local maximum_2 = math.max(maximum, minimum)
    argument.maxElevationRad = math.rad(maximum_2)
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

function orbital_camera.SetInitialOrientation(argument: table, argument_2: userdata)
    if not (argument_2 and argument_2.RootPart) then
        warn("OrbitalCamera could not set initial orientation due to missing humanoid")

        return
    end

    assert(argument_2.RootPart, "")
    local unit = (argument_2.RootPart.CFrame.LookVector - Vector3.new(0, 0.23, 0)).Unit
    local angle_between_xz_vectors = camera_utils.GetAngleBetweenXZVectors(unit, argument:GetCameraLookVector())
    local y = argument:GetCameraLookVector().Y
    local difference = math.asin(y) - math.asin(unit.Y)
    camera_utils.IsFinite(angle_between_xz_vectors)
    camera_utils.IsFinite(difference)
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

function orbital_camera.CalculateNewLookVector(argument: table, argument_2: vector, argument_3)
    local camera_look_vector = argument_2 or argument:GetCameraLookVector()
    local angle = math.asin(camera_look_vector.Y)
    local clamped_value = math.clamp(argument_3.Y, angle - 1.3962634015954636, angle - -1.3962634015954636)
    local vector = Vector2.new(argument_3.X, clamped_value)
    local cframe = CFrame.new(Vector3.new(0, 0, 0), camera_look_vector)

    return (CFrame.Angles(0, -vector.X, 0) * cframe * CFrame.Angles(-vector.Y, 0, 0)).LookVector
end

function orbital_camera.Update(argument: table, argument_2: number)
    local last_update = tick()
    local difference = last_update - argument.lastUpdate
    local condition = camera_input.getRotation() ~= Vector2.new()
    local workspace_current_camera = workspace.CurrentCamera
    local c_frame2 = workspace_current_camera.CFrame
    local focus = workspace_current_camera.Focus
    local local_player = players.LocalPlayer
    local camera_subject

    if workspace_current_camera then
        camera_subject = workspace_current_camera.CameraSubject
    else
        camera_subject = workspace_current_camera
    end

    local is_a_result

    if camera_subject then
        is_a_result = camera_subject:IsA("VehicleSeat")
    else
        is_a_result = camera_subject
    end

    local is_a_result_2

    if camera_subject then
        is_a_result_2 = camera_subject:IsA("SkateboardPlatform")
    else
        is_a_result_2 = camera_subject
    end

    if argument.lastUpdate == nil or difference > 1 then
        argument.lastCameraTransform = nil
    end

    if condition then
        argument.lastUserPanCamera = tick()
    end

    local subject_position = argument:GetSubjectPosition()

    if subject_position and (local_player and workspace_current_camera) then
        if argument.gamepadDollySpeedMultiplier ~= 1 then
            argument:SetCameraToSubjectDistance(argument.currentSubjectDistance * argument.gamepadDollySpeedMultiplier)
        end

        focus = CFrame.new(subject_position)
        local rotation = camera_input.getRotation(argument_2)
        argument.curAzimuthRad = argument.curAzimuthRad - rotation.X

        if argument.useAzimuthLimits then
            argument.curAzimuthRad =
                math.clamp(argument.curAzimuthRad, argument.minAzimuthAbsoluteRad, argument.maxAzimuthAbsoluteRad)
        else
            argument.curAzimuthRad = argument.curAzimuthRad == 0 and 0
                or (math.sign(argument.curAzimuthRad) * (math.abs(argument.curAzimuthRad) % 6.283185307179586) or 0)
        end

        argument.curElevationRad =
            math.clamp(argument.curElevationRad + rotation.Y, argument.minElevationRad, argument.maxElevationRad)
        local sum = subject_position
            + argument.currentSubjectDistance
                * (CFrame.fromEulerAnglesYXZ(-argument.curElevationRad, argument.curAzimuthRad, 0) * Vector3.new(
                    0,
                    0,
                    1
                ))
        c_frame2 = CFrame.new(sum, subject_position)
        argument.lastCameraTransform = c_frame2
        argument.lastCameraFocus = focus

        if (is_a_result or is_a_result_2) and camera_subject:IsA("BasePart") then
            argument.lastSubjectCFrame = camera_subject.CFrame
        else
            argument.lastSubjectCFrame = nil
        end
    end

    argument.lastUpdate = last_update

    return c_frame2, focus
end

return orbital_camera
