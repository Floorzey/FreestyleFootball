local camera_shake_instance = {}
camera_shake_instance.__index = camera_shake_instance
local vector3_new = Vector3.new
local math_noise = math.noise
camera_shake_instance.CameraShakeState = {
    FadingIn = 0,
    FadingOut = 1,
    Sustained = 2,
    Inactive = 3,
}

function camera_shake_instance.new(magnitude, roughness, argument, argument_2)
    local fade_in_duration = argument == nil and 0 or argument
    local fade_out_duration = argument_2 == nil and 0 or argument_2
    local is_number = type(magnitude) == "number"
    assert(is_number, "Magnitude must be a number")
    local is_number_2 = type(roughness) == "number"
    assert(is_number_2, "Roughness must be a number")
    local is_number_3 = type(fade_in_duration) == "number"
    assert(is_number_3, "FadeInTime must be a number")
    local is_number_4 = type(fade_out_duration) == "number"
    assert(is_number_4, "FadeOutTime must be a number")
    local values = {
        DeleteOnInactive = true,
        roughMod = 1,
        magnMod = 1,
        _camShakeInstance = true,
        Magnitude = magnitude,
        Roughness = roughness,
        PositionInfluence = vector3_new(),
        RotationInfluence = vector3_new(),
        fadeOutDuration = fade_out_duration,
        fadeInDuration = fade_in_duration,
        sustain = fade_in_duration > 0,
        currentFadeTime = fade_in_duration > 0 and 0 or 1,
        tick = Random.new():NextNumber(-100, 100),
    }

    return setmetatable(values, camera_shake_instance)
end

function camera_shake_instance.UpdateShake(shake_instance, argument)
    local tick = shake_instance.tick
    local current_fade_time = shake_instance.currentFadeTime
    local result = vector3_new(math_noise(tick, 0) * 0.5, math_noise(0, tick) * 0.5, math_noise(tick, tick) * 0.5)

    if shake_instance.fadeInDuration > 0 and shake_instance.sustain then
        if current_fade_time < 1 then
            current_fade_time += argument / shake_instance.fadeInDuration
        elseif shake_instance.fadeOutDuration > 0 then
            shake_instance.sustain = false
        end
    end

    if not shake_instance.sustain then
        current_fade_time -= argument / shake_instance.fadeOutDuration
    end

    if shake_instance.sustain then
        shake_instance.tick = tick + argument * shake_instance.Roughness * shake_instance.roughMod
    else
        shake_instance.tick = tick + argument * shake_instance.Roughness * shake_instance.roughMod * current_fade_time
    end

    shake_instance.currentFadeTime = current_fade_time

    return result * shake_instance.Magnitude * shake_instance.magnMod * current_fade_time
end

function camera_shake_instance.StartFadeOut(shake_instance, fade_out_duration)
    if fade_out_duration == 0 then
        shake_instance.currentFadeTime = 0
    end

    shake_instance.fadeOutDuration = fade_out_duration
    shake_instance.fadeInDuration = 0
    shake_instance.sustain = false
end

function camera_shake_instance.StartFadeIn(shake_instance, fade_in_duration)
    if fade_in_duration == 0 then
        shake_instance.currentFadeTime = 1
    end

    shake_instance.fadeInDuration = fade_in_duration or shake_instance.fadeInDuration
    shake_instance.fadeOutDuration = 0
    shake_instance.sustain = true
end

function camera_shake_instance.GetScaleRoughness(argument)
    return argument.roughMod
end

function camera_shake_instance.SetScaleRoughness(argument, rough_mod)
    argument.roughMod = rough_mod
end

function camera_shake_instance.GetScaleMagnitude(argument)
    return argument.magnMod
end

function camera_shake_instance.SetScaleMagnitude(argument, magn_mod)
    argument.magnMod = magn_mod
end

function camera_shake_instance.GetNormalizedFadeTime(argument)
    return argument.currentFadeTime
end

function camera_shake_instance.IsShaking(argument)
    return argument.currentFadeTime > 0 and true or argument.sustain
end

function camera_shake_instance.IsFadingOut(argument)
    return not argument.sustain and argument.currentFadeTime > 0
end

function camera_shake_instance.IsFadingIn(shake_instance)
    local condition

    if shake_instance.currentFadeTime < 1 then
        condition = shake_instance.sustain and shake_instance.fadeInDuration > 0
    else
        condition = false
    end

    return condition
end

function camera_shake_instance.GetState(argument)
    if argument:IsFadingIn() then
        return camera_shake_instance.CameraShakeState.FadingIn
    end

    if argument:IsFadingOut() then
        return camera_shake_instance.CameraShakeState.FadingOut
    end

    if argument:IsShaking() then
        return camera_shake_instance.CameraShakeState.Sustained
    end

    return camera_shake_instance.CameraShakeState.Inactive
end

return camera_shake_instance
