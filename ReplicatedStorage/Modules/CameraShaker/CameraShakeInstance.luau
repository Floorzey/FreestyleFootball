--[[
    Script Path: Game/ReplicatedStorage/Modules/CameraShaker/CameraShakeInstance
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
local new_upv_1 = Vector3.new
local noise_upv_1 = math.noise
tbl_upv_1.CameraShakeState = {Inactive = 3, Sustained = 2, FadingIn = 0, FadingOut = 1}
function tbl_upv_1.new(a1, a2, a3, a4)
    --[[
      name: new
      line: 28
      upvalues:
        new_upv_1 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
    ]]
    if a3 == nil then
        a3 = 0
    end
    if a4 == nil then
        a4 = 0
    end
    local tbl_2 = type(a1) == "number"
    assert(tbl_2, "Magnitude must be a number")
    tbl_2 = type(a2) == "number"
    assert(tbl_2, "Roughness must be a number")
    if type(a3) == "number" then
        tbl_2 = true
    else
        tbl_2 = false
    end
    assert(tbl_2, "FadeInTime must be a number")
    if type(a4) == "number" then
        tbl_2 = true
    else
        tbl_2 = false
    end
    assert(tbl_2, "FadeOutTime must be a number")
    tbl_2 = {roughMod = 1, _camShakeInstance = true, tick = 0, currentFadeTime = 0, sustain = 0, magnMod = 1, DeleteOnInactive = true}
    tbl_2.Magnitude = a1
    tbl_2.Roughness = a2
    tbl_2.PositionInfluence = new_upv_1()
    tbl_2.RotationInfluence = new_upv_1()
    tbl_2.fadeOutDuration = a4
    tbl_2.fadeInDuration = a3
    local v1
    if a3 > 0 then
        v1 = true
    else
        v1 = false
    end
    tbl_2.sustain = v1
    if a3 > 0 then
        v1 = 0
    else
        v1 = 1
    end
    tbl_2.currentFadeTime = v1
    tbl_2.tick = Random.new():NextNumber(-100, 100)
    return (setmetatable(tbl_2, tbl_upv_1))
end
function tbl_upv_1.UpdateShake(a1, a2)
    --[[
      name: UpdateShake
      line: 59
      upvalues:
        noise_upv_1 (copy, index: 1)
        new_upv_1 (copy, index: 2)
    ]]
    local tick_1 = a1.tick
    local currentFadeTime_1 = a1.currentFadeTime
    local v2 = new_upv_1(noise_upv_1(tick_1, 0) * 0.5, noise_upv_1(0, tick_1) * 0.5, noise_upv_1(tick_1, tick_1) * 0.5)
    if a1.fadeInDuration > 0 and a1.sustain then
        if currentFadeTime_1 < 1 then
            currentFadeTime_1 = currentFadeTime_1 + a2 / a1.fadeInDuration
        elseif a1.fadeOutDuration > 0 then
            a1.sustain = false
        end
    end
    currentFadeTime_1 = a1.sustain or currentFadeTime_1 - a2 / a1.fadeOutDuration
    if a1.sustain then
        a1.tick = tick_1 + ((a2 * a1.Roughness) * a1.roughMod)
    else
        a1.tick = tick_1 + (((a2 * a1.Roughness) * a1.roughMod) * currentFadeTime_1)
    end
    a1.currentFadeTime = currentFadeTime_1
    return ((v2 * a1.Magnitude) * a1.magnMod) * currentFadeTime_1
end
function tbl_upv_1.StartFadeOut(a1, a2)
    --[[
      name: StartFadeOut
      line: 95
    ]]
    if a2 == 0 then
        a1.currentFadeTime = 0
    end
    a1.fadeOutDuration = a2
    a1.fadeInDuration = 0
    a1.sustain = false
end
function tbl_upv_1.StartFadeIn(a1, a2)
    --[[
      name: StartFadeIn
      line: 105
    ]]
    if a2 == 0 then
        a1.currentFadeTime = 1
    end
    a1.fadeInDuration = a2 or (a1.fadeInDuration)
    a1.fadeOutDuration = 0
    a1.sustain = true
end
function tbl_upv_1.GetScaleRoughness(a1)
    --[[
      name: GetScaleRoughness
      line: 115
    ]]
    return a1.roughMod
end
function tbl_upv_1.SetScaleRoughness(a1, a2)
    --[[
      name: SetScaleRoughness
      line: 120
    ]]
    a1.roughMod = a2
end
function tbl_upv_1.GetScaleMagnitude(a1)
    --[[
      name: GetScaleMagnitude
      line: 125
    ]]
    return a1.magnMod
end
function tbl_upv_1.SetScaleMagnitude(a1, a2)
    --[[
      name: SetScaleMagnitude
      line: 130
    ]]
    a1.magnMod = a2
end
function tbl_upv_1.GetNormalizedFadeTime(a1)
    --[[
      name: GetNormalizedFadeTime
      line: 135
    ]]
    return a1.currentFadeTime
end
function tbl_upv_1.IsShaking(a1)
    --[[
      name: IsShaking
      line: 140
    ]]
    local v3 = true
    if not (a1.currentFadeTime > 0) then
        v3 = a1.sustain
    end
    return v3
end
function tbl_upv_1.IsFadingOut(a1)
    --[[
      name: IsFadingOut
      line: 145
    ]]
    return not a1.sustain and (a1.currentFadeTime > 0)
end
function tbl_upv_1.IsFadingIn(a1)
    --[[
      name: IsFadingIn
      line: 150
    ]]
    return (a1.currentFadeTime < 1) and (a1.sustain and (a1.fadeInDuration > 0))
end
function tbl_upv_1.GetState(a1)
    --[[
      name: GetState
      line: 155
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if a1:IsFadingIn() then
        return tbl_upv_1.CameraShakeState.FadingIn
    end
    if a1:IsFadingOut() then
        return tbl_upv_1.CameraShakeState.FadingOut
    elseif a1:IsShaking() then
        return tbl_upv_1.CameraShakeState.Sustained
    else
        return tbl_upv_1.CameraShakeState.Inactive
    end
end
return tbl_upv_1