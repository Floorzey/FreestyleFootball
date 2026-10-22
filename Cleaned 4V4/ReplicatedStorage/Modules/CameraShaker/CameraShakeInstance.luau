local camera_shake_instance = {}
camera_shake_instance.__index = camera_shake_instance
local new = Vector3.new
local noise = math.noise
camera_shake_instance.CameraShakeState = { Inactive = 3, Sustained = 2, FadingIn = 0, FadingOut = 1 }

function camera_shake_instance.new(magnitude, roughness, fade_in_duration, fade_out_duration)
    if fade_in_duration == nil then
        fade_in_duration = 0
    end

    if fade_out_duration == nil then
        fade_out_duration = 0
    end

    local is_number = type(magnitude) == "number"
    assert(is_number, "Magnitude must be a number")
    is_number = type(roughness) == "number"
    assert(is_number, "Roughness must be a number")

    if type(fade_in_duration) == "number" then
        is_number = true
    else
        is_number = false
    end

    assert(is_number, "FadeInTime must be a number")

    if type(fade_out_duration) == "number" then
        is_number = true
    else
        is_number = false
    end

    assert(is_number, "FadeOutTime must be a number")
    is_number = {
        roughMod = 1,
        _camShakeInstance = true,
        tick = 0,
        currentFadeTime = 0,
        sustain = 0,
        magnMod = 1,
        DeleteOnInactive = true,
    }
    is_number.Magnitude = magnitude
    is_number.Roughness = roughness
    is_number.PositionInfluence = new()
    is_number.RotationInfluence = new()
    is_number.fadeOutDuration = fade_out_duration
    is_number.fadeInDuration = fade_in_duration
    local sustain

    if fade_in_duration > 0 then
        sustain = true
    else
        sustain = false
    end

    is_number.sustain = sustain

    if fade_in_duration > 0 then
        sustain = 0
    else
        sustain = 1
    end

    is_number.currentFadeTime = sustain
    is_number.tick = Random.new():NextNumber(-100, 100)

    return (setmetatable(is_number, camera_shake_instance))
end

function camera_shake_instance.UpdateShake(shake_instance, argument)
    local tick = shake_instance.tick
    local current_fade_time = shake_instance.currentFadeTime
    local result = new(noise(tick, 0) * 0.5, noise(0, tick) * 0.5, noise(tick, tick) * 0.5)

    if shake_instance.fadeInDuration > 0 and shake_instance.sustain then
        if current_fade_time < 1 then
            current_fade_time += argument / shake_instance.fadeInDuration
        elseif shake_instance.fadeOutDuration > 0 then
            shake_instance.sustain = false
        end
    end

    current_fade_time = shake_instance.sustain or current_fade_time - argument / shake_instance.fadeOutDuration

    if shake_instance.sustain then
        shake_instance.tick = tick + ((argument * shake_instance.Roughness) * shake_instance.roughMod)
    else
        shake_instance.tick = tick
            + (((argument * shake_instance.Roughness) * shake_instance.roughMod) * current_fade_time)
    end

    shake_instance.currentFadeTime = current_fade_time

    return ((result * shake_instance.Magnitude) * shake_instance.magnMod) * current_fade_time
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
    local enabled = true

    if not (argument.currentFadeTime > 0) then
        enabled = argument.sustain
    end

    return enabled
end

function camera_shake_instance.IsFadingOut(argument)
    return not argument.sustain and (argument.currentFadeTime > 0)
end

function camera_shake_instance.IsFadingIn(shake_instance)
    return (shake_instance.currentFadeTime < 1) and (shake_instance.sustain and (shake_instance.fadeInDuration > 0))
end

function camera_shake_instance.GetState(argument)
    if argument:IsFadingIn() then
        return camera_shake_instance.CameraShakeState.FadingIn
    end

    if argument:IsFadingOut() then
        return camera_shake_instance.CameraShakeState.FadingOut
    elseif argument:IsShaking() then
        return camera_shake_instance.CameraShakeState.Sustained
    else
        return camera_shake_instance.CameraShakeState.Inactive
    end
end

return camera_shake_instance
