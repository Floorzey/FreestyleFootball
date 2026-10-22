local success, value = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2")
end)
local success_2 = success and value
local values = { 0, 30 }
local user_game_settings = UserSettings():GetService("UserGameSettings")
local vr_base_camera = require(script.Parent:WaitForChild("VRBaseCamera"))
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local _ = require(script.Parent:WaitForChild("VehicleCamera"))
local vehicle_camera_core = require(script.Parent.VehicleCamera:FindFirstChild("VehicleCameraCore"))
local vehicle_camera_config = require(script.Parent.VehicleCamera:FindFirstChild("VehicleCameraConfig"))
local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local vr_service = game:GetService("VRService")
local local_player = players.LocalPlayer
local spring = camera_utils.Spring
local map_clamp = camera_utils.mapClamp
local sanitize_angle = camera_utils.sanitizeAngle

local function pitch_velocity(argument, argument_2)
    return (math.abs(argument_2.XVector:Dot(argument)))
end

local function yaw_velocity(argument, argument_2)
    return (math.abs(argument_2.YVector:Dot(argument)))
end

local number = 0.016666666666666666
local vr_vehicle_camera = setmetatable({}, vr_base_camera)
vr_vehicle_camera.__index = vr_vehicle_camera

function vr_vehicle_camera.new()
    local instance = setmetatable(vr_base_camera.new(), vr_vehicle_camera)
    instance:Reset()
    run_service.Stepped:Connect(function(elapsed_time, delta_time)
        number = delta_time
    end)
    return instance
end

function vr_vehicle_camera.Reset(self)
    self.vehicleCameraCore = vehicle_camera_core.new(self:GetSubjectCFrame())
    if success_2 then
        self.pitchSpring = spring.new(0, 0)
    else
        self.pitchSpring = spring.new(0, -math.rad(vehicle_camera_config.pitchBaseAngle))
    end
    self.yawSpring = spring.new(0, 0)
    if success_2 then
        self.lastPanTick = 0
        self.currentDriftAngle = 0
        self.needsReset = true
    end
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject
    assert(current_camera, "VRVehicleCamera initialization error")
    assert(camera_subject)
    assert(camera_subject:IsA("VehicleSeat"))
    local get_loose_bounding_sphere_result, value_2 =
        camera_utils.getLooseBoundingSphere(camera_subject:GetConnectedParts(true))
    self.assemblyRadius = math.max(value_2, 5)
    self.assemblyOffset = camera_subject.CFrame:Inverse() * get_loose_bounding_sphere_result
    self.gamepadZoomLevels = {}
    for _, item in values do
        table.insert(self.gamepadZoomLevels, ((item * self.headScale) * self.assemblyRadius) / 10)
    end
    self.lastCameraFocus = nil
    self:SetCameraToSubjectDistance(self.gamepadZoomLevels[#self.gamepadZoomLevels])
end

function vr_vehicle_camera._StepRotation(self, argument, argument_2)
    local yaw_spring = self.yawSpring
    local pitch_spring = self.pitchSpring
    yaw_spring.pos = sanitize_angle(yaw_spring.pos + -self:getRotation(argument))
    pitch_spring.pos = sanitize_angle(math.clamp(pitch_spring.pos, -1.3962634015954636, 1.3962634015954636))
    if camera_input.getRotationActivated() then
        self.lastPanTick = os.clock()
    end
    local radians = math.rad(vehicle_camera_config.pitchDeadzoneAngle)
    if vehicle_camera_config.autocorrectDelay < os.clock() - self.lastPanTick then
        local freq = map_clamp(
            argument_2,
            vehicle_camera_config.autocorrectMinCarSpeed,
            vehicle_camera_config.autocorrectMaxCarSpeed,
            0,
            vehicle_camera_config.autocorrectResponse
        )
        yaw_spring.freq = freq
        pitch_spring.freq = freq
        if yaw_spring.freq < 0.001 then
            yaw_spring.vel = 0
        end
        if pitch_spring.freq < 0.001 then
            pitch_spring.vel = 0
        end
        if math.abs(sanitize_angle(0 - pitch_spring.pos)) <= radians then
            pitch_spring.goal = pitch_spring.pos
        else
            pitch_spring.goal = 0
        end
    else
        yaw_spring.freq = 0
        yaw_spring.vel = 0
        pitch_spring.freq = 0
        pitch_spring.vel = 0
        pitch_spring.goal = 0
    end
    return CFrame.fromEulerAnglesYXZ(pitch_spring:step(argument), yaw_spring:step(argument), 0)
end

function vr_vehicle_camera._GetThirdPersonLocalOffset(self)
    return self.assemblyOffset + Vector3.new(0, self.assemblyRadius * vehicle_camera_config.verticalCenterOffset, 0)
end

function vr_vehicle_camera._GetFirstPersonLocalOffset(self, argument)
    local character = local_player.Character
    if character and character.Parent then
        local head = character:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            return argument:Inverse() * head.Position
        end
    end
    return self:_GetThirdPersonLocalOffset()
end

function vr_vehicle_camera.Update(self)
    if not success_2 then
        return self:UpdateComfortCamera()
    end
    local number_2 = number
    number = 0
    self:UpdateFadeFromBlack(number_2)
    self:UpdateEdgeBlur(local_player, number_2)
    if vr_service.ThirdPersonFollowCamEnabled then
        local update_step_rotation_result, value_2 = self:UpdateStepRotation(number_2)
        return update_step_rotation_result, value_2
    else
        local update_comfort_camera_result, value_3 = self:UpdateComfortCamera(number_2)
        return update_comfort_camera_result, value_3
    end
end

function vr_vehicle_camera.addDrift(self, interpolated_value, argument)
    local function normalize_angle(computed_value_offset_offset_offset)
        computed_value_offset_offset_offset = (computed_value_offset_offset_offset + 12.566370614359172) % math.tau
        return ((computed_value_offset_offset_offset > math.pi) and (computed_value_offset_offset_offset - math.tau))
            or computed_value_offset_offset_offset
    end
    local current_camera = workspace.CurrentCamera
    local camera_to_subject_distance = self:GetCameraToSubjectDistance()
    local vector = self:GetSubjectVelocity()
    local subject_c_frame = self:GetSubjectCFrame()
    local _ = require(local_player:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))
    local value_2 = nil
    if vector.Magnitude > 0.1 then
        local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
        local cframe_offset = current_camera.CFrame
            * (user_c_frame.Rotation + (user_c_frame.Position * current_camera.HeadScale))
        local to_euler_angles_yxz_result, value_3 = cframe_offset:ToEulerAnglesYXZ()
        local to_euler_angles_yxz_result_2, value_4 = subject_c_frame:ToEulerAnglesYXZ()
        local computed_value_offset_offset = ((value_3 - self.currentDriftAngle) + 12.566370614359172) % math.tau
        local is_computed_value = (
            (computed_value_offset_offset > math.pi) and (computed_value_offset_offset - math.tau)
        ) or computed_value_offset_offset
        local computed_value_offset_offset_2 = ((value_4 - self.currentDriftAngle) + 12.566370614359172) % math.tau
        local is_computed_value_2 = (
            (computed_value_offset_offset_2 > math.pi) and (computed_value_offset_offset_2 - math.tau)
        ) or computed_value_offset_offset_2
        value_2 = math.min(is_computed_value_2, is_computed_value)
        local maximum = math.max(is_computed_value_2, is_computed_value)
        local number_2 = 0
        if value_2 > 0 then
            number_2 = value_2
        elseif maximum < 0 then
            number_2 = maximum
        end
        self.currentDriftAngle = number_2 + self.currentDriftAngle
        local look_vector = CFrame.fromEulerAnglesYXZ(0, self.currentDriftAngle, 0).LookVector
        interpolated_value = interpolated_value:Lerp(
            CFrame.new(
                (
                    current_camera.CFrame.Position
                    + (
                        argument.Position
                        - Vector3.new(look_vector.X, 0, look_vector.Z).Unit * camera_to_subject_distance
                    )
                ) - cframe_offset.Position
            ) * current_camera.CFrame.Rotation,
            0.01
        )
    end
    return interpolated_value, argument
end

function vr_vehicle_camera.UpdateRotationCamera(self, argument)
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject
    local vehicle_camera_core_2 = self.vehicleCameraCore
    assert(current_camera)
    assert(camera_subject)
    assert(camera_subject:IsA("VehicleSeat"))
    local subject_c_frame = self:GetSubjectCFrame()
    local vector = self:GetSubjectVelocity()
    local subject_rot_velocity = self:GetSubjectRotVelocity()
    local absolute_value = math.abs(vector:Dot(subject_c_frame.ZVector))
    local absolute_value_2 = math.abs(subject_c_frame.YVector:Dot(subject_rot_velocity))
    local absolute_value_3 = math.abs(subject_c_frame.XVector:Dot(subject_rot_velocity))
    local camera_to_subject_distance = self:GetCameraToSubjectDistance()
    local result = map_clamp(camera_to_subject_distance, 0.5, self.assemblyRadius, 1, 0)
    local interpolated_value = self:_GetThirdPersonLocalOffset()
        :Lerp(self:_GetFirstPersonLocalOffset(subject_c_frame), result)
    vehicle_camera_core_2:setTransform(subject_c_frame)
    local step_result = vehicle_camera_core_2:step(argument, absolute_value_3, absolute_value_2, result)
    local step_rotation_result = self:_StepRotation(argument, absolute_value)
    local vr_focus_offset_offset = self:GetVRFocus(subject_c_frame * interpolated_value, argument)
        * step_result
        * step_rotation_result
    local vr_focus_offset_offset_offset = vr_focus_offset_offset * CFrame.new(0, 0, camera_to_subject_distance)
    if vector.Magnitude > 0.1 then
        self:StartVREdgeBlur(local_player)
    end
    return vr_focus_offset_offset_offset, vr_focus_offset_offset
end

function vr_vehicle_camera.UpdateStepRotation(self, argument)
    local current_camera = workspace.CurrentCamera
    local last_subject_c_frame = self.lastSubjectCFrame
    local subject_c_frame = self:GetSubjectCFrame()
    local vector = self:GetSubjectVelocity()
    local camera_to_subject_distance = self:GetCameraToSubjectDistance()
    local result = map_clamp(camera_to_subject_distance, 0.5, self.assemblyRadius, 1, 0)
    local interpolated_value = self:_GetThirdPersonLocalOffset()
        :Lerp(self:_GetFirstPersonLocalOffset(subject_c_frame), result)
    local vr_focus = self:GetVRFocus(subject_c_frame * interpolated_value, argument)
    local _, value_2 = self:addDrift(
        vr_focus:ToWorldSpace(
            self:GetVRFocus(last_subject_c_frame * interpolated_value, argument):ToObjectSpace(current_camera.CFrame)
        ),
        vr_focus
    )
    local get_rotation_result = self:getRotation(argument)
    local computed_value_offset
    if math.abs(get_rotation_result) > 0 then
        local value_3 = nil
        local relative_cframe = value_3:ToObjectSpace(get_rotation_result)
        local computed_value_offset_2 = value_3 * CFrame.Angles(0, -get_rotation_result, 0) * relative_cframe
        local value_4 = nil
        if not user_game_settings.VRSmoothRotationEnabled then
            local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
            local rotation_offset = user_c_frame.Rotation + user_c_frame.Position * current_camera.HeadScale
            local computed_value = value_3 * subject_c_frame.Rotation
            local relative_cframe_2 = computed_value:ToObjectSpace(get_rotation_result * rotation_offset)
            value_4 = math.acos(Vector3.new(relative_cframe_2.X, 0, relative_cframe_2.Z).Unit:Dot(Vector3.new(0, 0, 1)))
            local relative_cframe_3 = computed_value:ToObjectSpace(computed_value_offset_2 * rotation_offset)
            if
                math.acos(Vector3.new(relative_cframe_3.X, 0, relative_cframe_3.Z).Unit:Dot(Vector3.new(0, 0, 1)))
                < value_4
            then
                computed_value_offset_2 = value_2
                    * CFrame.Angles(0, -(((get_rotation_result < 0) and (value_4 * -1)) or value_4), 0)
                    * relative_cframe
            end
        end
        computed_value_offset = computed_value_offset_2
    else
        computed_value_offset = get_rotation_result
    end
    if vector.Magnitude > 0.1 then
        self:StartVREdgeBlur(local_player)
    end
    if self.needsReset then
        self.needsReset = false
        vr_service:RecenterUserHeadCFrame()
        self:StartFadeFromBlack()
        self:ResetZoom()
    end
    if self.recentered then
        computed_value_offset = value_2 * subject_c_frame.Rotation * CFrame.new(0, 0, camera_to_subject_distance)
        self.recentered = false
    end
    return computed_value_offset, computed_value_offset * CFrame.new(0, 0, -camera_to_subject_distance)
end

function vr_vehicle_camera.UpdateComfortCamera(self, number_2)
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject
    local vehicle_camera_core_2 = self.vehicleCameraCore
    assert(current_camera)
    assert(camera_subject)
    assert(camera_subject:IsA("VehicleSeat"))
    if not success_2 then
        number_2 = number
        number = 0
    end
    local subject_c_frame = self:GetSubjectCFrame()
    local vector = self:GetSubjectVelocity()
    local subject_rot_velocity = self:GetSubjectRotVelocity()
    local _ = math.abs(vector:Dot(subject_c_frame.ZVector))
    local absolute_value = math.abs(subject_c_frame.YVector:Dot(subject_rot_velocity))
    local absolute_value_2 = math.abs(subject_c_frame.XVector:Dot(subject_rot_velocity))
    local step_zoom_result = self:StepZoom()
    local result = map_clamp(step_zoom_result, 0.5, self.assemblyRadius, 1, 0)
    local interpolated_value = self:_GetThirdPersonLocalOffset()
        :Lerp(self:_GetFirstPersonLocalOffset(subject_c_frame), result)
    vehicle_camera_core_2:setTransform(subject_c_frame)
    local step_result = vehicle_camera_core_2:step(number_2, absolute_value_2, absolute_value, result)
    if not success_2 then
        self:UpdateFadeFromBlack(number_2)
    end
    local last_camera_focus_offset, last_camera_focus
    if self:IsInFirstPerson() then
        local cframe =
            CFrame.new(step_result.Position, Vector3.new(step_result.LookVector.X, 0, step_result.LookVector.Z).Unit)
        last_camera_focus = CFrame.new(subject_c_frame * interpolated_value) * cframe
        last_camera_focus_offset = last_camera_focus * CFrame.new(0, 0, step_zoom_result)
        if not success_2 or vector.Magnitude > 0.1 then
            self:StartVREdgeBlur(local_player)
        end
    else
        last_camera_focus = CFrame.new(subject_c_frame * interpolated_value) * step_result
        last_camera_focus_offset = last_camera_focus * CFrame.new(0, 0, step_zoom_result)
        if not self.lastCameraFocus then
            self.lastCameraFocus = last_camera_focus
            self.needsReset = true
        end
        local position_offset = last_camera_focus.Position - current_camera.CFrame.Position
        local magnitude = position_offset.magnitude
        if position_offset.Unit:Dot(current_camera.CFrame.LookVector) > 0.56 and magnitude < 200 then
            if self.needsReset then
                self.lastCameraFocus = self:GetVRFocus(subject_c_frame.Position, number_2)
                self.needsReset = false
                self:StartFadeFromBlack()
                self:ResetZoom()
            else
                last_camera_focus = self.lastCameraFocus
                local p = self.lastCameraFocus.p
                local camera_look_vector = self:GetCameraLookVector()
                last_camera_focus_offset = CFrame.new(
                    p
                        - (
                            step_zoom_result
                            * self:CalculateNewLookVectorFromArg(
                                Vector3.new(camera_look_vector.X, 0, camera_look_vector.Z).Unit,
                                Vector2.new(0, 0)
                            )
                        ),
                    p
                )
            end
        else
            self.lastCameraFocus = self:GetVRFocus(subject_c_frame.Position, number_2)
            self.needsReset = false
            self:StartFadeFromBlack()
            self:ResetZoom()
        end
        if not success_2 then
            self:UpdateEdgeBlur(local_player, number_2)
        end
    end
    return last_camera_focus_offset, last_camera_focus
end

return vr_vehicle_camera
