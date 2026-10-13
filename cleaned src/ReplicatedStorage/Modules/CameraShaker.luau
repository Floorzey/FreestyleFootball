local camera_shaker = {}
camera_shaker.__index = camera_shaker
local begin_profile = debug.profilebegin
local end_profile = debug.profileend
local create_cframe = CFrame.new
local cframe_angles = CFrame.Angles
local to_radians = math.rad
local vector = Vector3.new()
local camera_shake_instance = require(script.CameraShakeInstance)
local camera_shake_state = camera_shake_instance.CameraShakeState
camera_shaker.CameraShakeInstance = camera_shake_instance
camera_shaker.Presets = require(script.CameraShakePresets)

function camera_shaker.new(render_priority, callback)
    local is_number = type(render_priority) == "number"
    assert(is_number, "RenderPriority must be a number (e.g.: Enum.RenderPriority.Camera.Value)")
    local is_function = type(callback) == "function"
    assert(is_function, "Callback must be a function")
    return (
        setmetatable({
            _renderName = "CameraShaker",
            _running = false,
            _renderPriority = render_priority,
            _posAddShake = vector,
            _rotAddShake = vector,
            _camShakeInstances = {},
            _removeInstances = {},
            _callback = callback,
        }, camera_shaker)
    )
end

function camera_shaker.Start(self)
    if self._running then
        return
    end
    self._running = true
    local callback = self._callback
    game:GetService("RunService"):BindToRenderStep(self._renderName, self._renderPriority, function(delta_time)
        begin_profile("CameraShakerUpdate")
        local update_result = self:Update(delta_time)
        end_profile()
        callback(update_result)
    end)
end

function camera_shaker.Stop(self)
    if not self._running then
        return
    end
    game:GetService("RunService"):UnbindFromRenderStep(self._renderName)
    self._running = false
end

function camera_shaker.StopSustained(self, fade_out_duration)
    for _, shake_instance in pairs(self._camShakeInstances) do
        if shake_instance.fadeOutDuration == 0 then
            shake_instance:StartFadeOut(fade_out_duration or shake_instance.fadeInDuration)
        end
    end
end

function camera_shaker.Update(self, delta_time)
    local cam_shake_instances = self._camShakeInstances
    for n = 1, #cam_shake_instances do
        local cam_shake_instance_entry = cam_shake_instances[n]
        local state = cam_shake_instance_entry:GetState()
        if
            (state ~= camera_shake_state.Inactive or not cam_shake_instance_entry.DeleteOnInactive)
            and state ~= camera_shake_state.Inactive
        then
            local _ = cam_shake_instance_entry:UpdateShake(delta_time)
        end
        self._removeInstances[#self._removeInstances + 1] = n
    end
    for n_2 = #self._removeInstances, 1, -1 do
        table.remove(cam_shake_instances, self._removeInstances[n_2])
        self._removeInstances[n_2] = nil
    end
    return create_cframe(vector)
        * cframe_angles(0, to_radians(vector.Y), 0)
        * cframe_angles(to_radians(vector.X), 0, to_radians(vector.Z))
end

function camera_shaker.Shake(self, shake_instance)
    local cam_shake_instance = (type(shake_instance) == "table") and shake_instance._camShakeInstance
    assert(cam_shake_instance, "ShakeInstance must be of type CameraShakeInstance")
    self._camShakeInstances[#self._camShakeInstances + 1] = shake_instance
    return shake_instance
end

function camera_shaker.ShakeSustain(self, shake_instance)
    local cam_shake_instance = (type(shake_instance) == "table") and shake_instance._camShakeInstance
    assert(cam_shake_instance, "ShakeInstance must be of type CameraShakeInstance")
    self._camShakeInstances[#self._camShakeInstances + 1] = shake_instance
    shake_instance:StartFadeIn(shake_instance.fadeInDuration)
    return shake_instance
end

function camera_shaker.ShakeOnce(
    self,
    magnitude,
    roughness,
    fade_in_duration,
    fade_out_duration,
    position_influence,
    rotation_influence
)
    local camera_shake_instance_2 = camera_shake_instance.new(magnitude, roughness, fade_in_duration, fade_out_duration)
    camera_shake_instance_2.PositionInfluence = typeof(position_influence) == "Vector3" and position_influence
        or Vector3.new(0.15000000596046448, 0.15000000596046448, 0.15000000596046448)
    camera_shake_instance_2.RotationInfluence = typeof(rotation_influence) == "Vector3" and rotation_influence
        or Vector3.new(1, 1, 1)
    self._camShakeInstances[#self._camShakeInstances + 1] = camera_shake_instance_2
    return camera_shake_instance_2
end

function camera_shaker.StartShake(self, magnitude, roughness, fade_in_duration, position_influence, rotation_influence)
    local camera_shake_instance_2 = camera_shake_instance.new(magnitude, roughness, fade_in_duration)
    camera_shake_instance_2.PositionInfluence = typeof(position_influence) == "Vector3" and position_influence
        or Vector3.new(0.15000000596046448, 0.15000000596046448, 0.15000000596046448)
    camera_shake_instance_2.RotationInfluence = typeof(rotation_influence) == "Vector3" and rotation_influence
        or Vector3.new(1, 1, 1)
    camera_shake_instance_2:StartFadeIn(fade_in_duration)
    self._camShakeInstances[#self._camShakeInstances + 1] = camera_shake_instance_2
    return camera_shake_instance_2
end

return camera_shaker
