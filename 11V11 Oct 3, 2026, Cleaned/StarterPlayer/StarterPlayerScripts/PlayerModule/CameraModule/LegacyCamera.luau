local _ = Vector2.new()
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local players = game:GetService("Players")
local base_camera = require(script.Parent:WaitForChild("BaseCamera"))
local legacy_camera = setmetatable({}, base_camera)
legacy_camera.__index = legacy_camera

function legacy_camera.new()
    local instance = setmetatable(base_camera.new(), legacy_camera)
    instance.cameraType = Enum.CameraType.Fixed
    instance.lastUpdate = tick()
    instance.lastDistanceToSubject = nil
    return instance
end

function legacy_camera.GetModuleName(self)
    return "LegacyCamera"
end

function legacy_camera.SetCameraToSubjectDistance(self, argument)
    return base_camera.SetCameraToSubjectDistance(self, argument)
end

function legacy_camera.Update(self, argument)
    if not self.cameraType then
        return nil, nil
    end
    local time = tick()
    local current_camera = workspace.CurrentCamera
    local cframe = current_camera.CFrame
    local focus = current_camera.Focus
    local local_player = players.LocalPlayer
    local get_rotation_result = camera_input.getRotation(argument)
    if self.lastUpdate == nil or time - self.lastUpdate > 1 then
        self.lastDistanceToSubject = nil
    end
    local subject_position = self:GetSubjectPosition()
    if self.cameraType ~= Enum.CameraType.Fixed then
        if self.cameraType == Enum.CameraType.Attach then
            local subject_c_frame = self:GetSubjectCFrame()
            local to_euler_angles_yxz_result = current_camera.CFrame:ToEulerAnglesYXZ()
            local _, value = subject_c_frame:ToEulerAnglesYXZ()
            to_euler_angles_yxz_result =
                math.clamp(to_euler_angles_yxz_result - get_rotation_result.Y, -1.3962634015954636, 1.3962634015954636)
            focus = CFrame.new(subject_c_frame.p) * CFrame.fromEulerAnglesYXZ(to_euler_angles_yxz_result, value, 0)
            cframe = focus * CFrame.new(0, 0, self:StepZoom())
        elseif self.cameraType ~= Enum.CameraType.Watch then
            return current_camera.CFrame, current_camera.Focus
        elseif subject_position and local_player and current_camera then
            local value_2 = nil
            if subject_position ~= current_camera.CFrame.p then
                local humanoid = self:GetHumanoid()
                if humanoid and humanoid.RootPart then
                    local subject_position_offset = subject_position - current_camera.CFrame.p
                    local unit = subject_position_offset.unit
                    if
                        self.lastDistanceToSubject
                        and self.lastDistanceToSubject == self:GetCameraToSubjectDistance()
                    then
                        self:SetCameraToSubjectDistance(subject_position_offset.magnitude)
                    end
                    value_2 = unit
                end
                local last_distance_to_subject = self:GetCameraToSubjectDistance()
                local new_look_vector_from_arg = self:CalculateNewLookVectorFromArg(value_2, get_rotation_result)
                focus = CFrame.new(subject_position)
                cframe = CFrame.new(
                    subject_position - (last_distance_to_subject * new_look_vector_from_arg),
                    subject_position
                )
                self.lastDistanceToSubject = last_distance_to_subject
            else
                warn("Camera cannot watch subject in same position as itself")
                return current_camera.CFrame, current_camera.Focus
            end
        end
    elseif subject_position and local_player and current_camera then
        local camera_to_subject_distance = self:GetCameraToSubjectDistance()
        local new_look_vector_from_arg_2 = self:CalculateNewLookVectorFromArg(nil, get_rotation_result)
        focus = current_camera.Focus
        cframe = CFrame.new(
            current_camera.CFrame.p,
            current_camera.CFrame.p + (camera_to_subject_distance * new_look_vector_from_arg_2)
        )
    end
    self.lastUpdate = time
    return cframe, focus
end

return legacy_camera
