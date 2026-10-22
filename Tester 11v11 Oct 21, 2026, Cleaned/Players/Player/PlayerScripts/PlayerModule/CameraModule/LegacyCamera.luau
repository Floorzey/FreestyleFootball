Vector2.new()
require(script.Parent:WaitForChild("CameraUtils"))
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local players = game:GetService("Players")
local base_camera = require(script.Parent:WaitForChild("BaseCamera"))
local legacy_camera = setmetatable({}, base_camera)
legacy_camera.__index = legacy_camera

function legacy_camera.new()
    local base_camera_2 = base_camera.new()
    local instance = setmetatable(base_camera_2, legacy_camera)
    instance.cameraType = Enum.CameraType.Fixed
    instance.lastUpdate = tick()
    instance.lastDistanceToSubject = nil

    return instance
end

function legacy_camera.GetModuleName(argument)
    return "LegacyCamera"
end

function legacy_camera.SetCameraToSubjectDistance(argument, argument_2)
    return base_camera.SetCameraToSubjectDistance(argument, argument_2)
end

function legacy_camera.Update(argument: table, argument_2: number)
    if not argument.cameraType then
        return nil, nil
    end

    local last_update = tick()
    local difference = last_update - argument.lastUpdate
    local workspace_current_camera = workspace.CurrentCamera
    local c_frame2 = workspace_current_camera.CFrame
    local focus = workspace_current_camera.Focus
    local local_player = players.LocalPlayer
    local rotation = camera_input.getRotation(argument_2)

    if argument.lastUpdate == nil or difference > 1 then
        argument.lastDistanceToSubject = nil
    end

    local subject_position = argument:GetSubjectPosition()

    if argument.cameraType == Enum.CameraType.Fixed then
        if subject_position and (local_player and workspace_current_camera) then
            local camera_to_subject_distance = argument:GetCameraToSubjectDistance()
            local new_look_vector_from_arg = argument:CalculateNewLookVectorFromArg(nil, rotation)
            focus = workspace_current_camera.Focus
            c_frame2 = CFrame.new(
                workspace_current_camera.CFrame.p,
                workspace_current_camera.CFrame.p + camera_to_subject_distance * new_look_vector_from_arg
            )
        end
    elseif argument.cameraType == Enum.CameraType.Attach then
        local subject_c_frame = argument:GetSubjectCFrame()
        local to_euler_angles_yxz_result = workspace_current_camera.CFrame:ToEulerAnglesYXZ()
        local _, value = subject_c_frame:ToEulerAnglesYXZ()
        local clamped_value =
            math.clamp(to_euler_angles_yxz_result - rotation.Y, -1.3962634015954636, 1.3962634015954636)
        focus = CFrame.new(subject_c_frame.p) * CFrame.fromEulerAnglesYXZ(clamped_value, value, 0)
        c_frame2 = focus * CFrame.new(0, 0, argument:StepZoom())
    else
        if argument.cameraType ~= Enum.CameraType.Watch then
            return workspace_current_camera.CFrame, workspace_current_camera.Focus
        end

        if subject_position and (local_player and workspace_current_camera) then
            local value_2 = nil

            if subject_position == workspace_current_camera.CFrame.p then
                warn("Camera cannot watch subject in same position as itself")

                return workspace_current_camera.CFrame, workspace_current_camera.Focus
            end

            local humanoid = argument:GetHumanoid()

            if humanoid and humanoid.RootPart then
                local difference_2 = subject_position - workspace_current_camera.CFrame.p
                value_2 = difference_2.unit

                if
                    argument.lastDistanceToSubject
                    and argument.lastDistanceToSubject == argument:GetCameraToSubjectDistance()
                then
                    argument:SetCameraToSubjectDistance(difference_2.magnitude)
                end
            end

            local camera_to_subject_distance_2 = argument:GetCameraToSubjectDistance()
            local new_look_vector_from_arg_2 = argument:CalculateNewLookVectorFromArg(value_2, rotation)
            focus = CFrame.new(subject_position)
            c_frame2 = CFrame.new(
                subject_position - camera_to_subject_distance_2 * new_look_vector_from_arg_2,
                subject_position
            )
            argument.lastDistanceToSubject = camera_to_subject_distance_2
        end
    end

    argument.lastUpdate = last_update

    return c_frame2, focus
end

return legacy_camera
