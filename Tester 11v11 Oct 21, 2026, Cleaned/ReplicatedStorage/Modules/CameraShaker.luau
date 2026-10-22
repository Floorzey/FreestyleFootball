local camera_shaker = {}
camera_shaker.__index = camera_shaker
local begin_profile = debug.profilebegin
local end_profile = debug.profileend
local create_cframe = CFrame.new
local cframe_angles = CFrame.Angles
local to_radians = math.rad
local vector = Vector3.new()
local script_camera_shake_instance = require(script.CameraShakeInstance)
local camera_shake_state = script_camera_shake_instance.CameraShakeState
camera_shaker.CameraShakeInstance = script_camera_shake_instance
camera_shaker.Presets = require(script.CameraShakePresets)

function camera_shaker.new(render_priority, callback)
    local is_number = type(render_priority) == "number"
    assert(is_number, "RenderPriority must be a number (e.g.: Enum.RenderPriority.Camera.Value)")
    local is_function = type(callback) == "function"
    assert(is_function, "Callback must be a function")

    return setmetatable({
        _running = false,
        _renderName = "CameraShaker",
        _renderPriority = render_priority,
        _posAddShake = vector,
        _rotAddShake = vector,
        _camShakeInstances = {},
        _removeInstances = {},
        _callback = callback,
    }, camera_shaker)
end

function camera_shaker.Start(argument)
    if argument._running then
        return
    end

    argument._running = true
    local callback = argument._callback

    game:GetService("RunService"):BindToRenderStep(argument._renderName, argument._renderPriority, function(delta_time)
        begin_profile("CameraShakerUpdate")
        local update_result = argument:Update(delta_time)
        end_profile()
        callback(update_result)
    end)
end

function camera_shaker.Stop(argument)
    if not argument._running then
        return
    end

    game:GetService("RunService"):UnbindFromRenderStep(argument._renderName)
    argument._running = false
end

function camera_shaker.StopSustained(argument, fade_out_duration)
    for _, shake_instance in pairs(argument._camShakeInstances) do
        if shake_instance.fadeOutDuration == 0 then
            shake_instance:StartFadeOut(fade_out_duration or shake_instance.fadeInDuration)
        end
    end
end

function camera_shaker.Update(argument, delta_time)
    local vector_2 = vector
    local vector_3 = vector
    local cam_shake_instances = argument._camShakeInstances

    for index = 1, #cam_shake_instances do
        local cam_shake_instance_entry = cam_shake_instances[index]
        local state = cam_shake_instance_entry:GetState()
        local index_3

        if state == camera_shake_state.Inactive and cam_shake_instance_entry.DeleteOnInactive then
            argument._removeInstances[#argument._removeInstances + 1] = index
            index_3 = index
        elseif state == camera_shake_state.Inactive then
            index_3 = index
        else
            local update_shake_result = cam_shake_instance_entry:UpdateShake(delta_time)
            vector_2 += update_shake_result * cam_shake_instance_entry.PositionInfluence
            vector_3 += update_shake_result * cam_shake_instance_entry.RotationInfluence
            index_3 = index
        end
    end

    for index_2 = #argument._removeInstances, 1, -1 do
        table.remove(cam_shake_instances, argument._removeInstances[index_2])
        argument._removeInstances[index_2] = nil
        local _ = index_2
    end

    return create_cframe(vector_2)
        * cframe_angles(0, to_radians(vector_3.Y), 0)
        * cframe_angles(to_radians(vector_3.X), 0, (to_radians(vector_3.Z)))
end

function camera_shaker.Shake(argument, shake_instance)
    local cam_shake_instance

    if type(shake_instance) == "table" then
        cam_shake_instance = shake_instance._camShakeInstance
    else
        cam_shake_instance = false
    end

    assert(cam_shake_instance, "ShakeInstance must be of type CameraShakeInstance")
    argument._camShakeInstances[#argument._camShakeInstances + 1] = shake_instance

    return shake_instance
end

function camera_shaker.ShakeSustain(argument, shake_instance)
    local cam_shake_instance

    if type(shake_instance) == "table" then
        cam_shake_instance = shake_instance._camShakeInstance
    else
        cam_shake_instance = false
    end

    assert(cam_shake_instance, "ShakeInstance must be of type CameraShakeInstance")
    argument._camShakeInstances[#argument._camShakeInstances + 1] = shake_instance
    shake_instance:StartFadeIn(shake_instance.fadeInDuration)

    return shake_instance
end

function camera_shaker.ShakeOnce(
    argument,
    magnitude,
    roughness,
    argument_2,
    argument_3,
    position_influence,
    rotation_influence
)
    local script_camera_shake_instance_2 =
        script_camera_shake_instance.new(magnitude, roughness, argument_2, argument_3)
    script_camera_shake_instance_2.PositionInfluence = typeof(position_influence) == "Vector3"
            and position_influence
            and position_influence
        or Vector3.new(0.15, 0.15, 0.15)
    script_camera_shake_instance_2.RotationInfluence = typeof(rotation_influence) == "Vector3"
            and rotation_influence
            and rotation_influence
        or Vector3.new(1, 1, 1)
    argument._camShakeInstances[#argument._camShakeInstances + 1] = script_camera_shake_instance_2

    return script_camera_shake_instance_2
end

function camera_shaker.StartShake(
    argument,
    magnitude,
    roughness,
    fade_in_duration,
    position_influence,
    rotation_influence
)
    local script_camera_shake_instance_2 = script_camera_shake_instance.new(magnitude, roughness, fade_in_duration)
    script_camera_shake_instance_2.PositionInfluence = typeof(position_influence) == "Vector3"
            and position_influence
            and position_influence
        or Vector3.new(0.15, 0.15, 0.15)
    script_camera_shake_instance_2.RotationInfluence = typeof(rotation_influence) == "Vector3"
            and rotation_influence
            and rotation_influence
        or Vector3.new(1, 1, 1)
    script_camera_shake_instance_2:StartFadeIn(fade_in_duration)
    argument._camShakeInstances[#argument._camShakeInstances + 1] = script_camera_shake_instance_2

    return script_camera_shake_instance_2
end

return camera_shaker
