--[[
    Script Path: Game/Workspace/breeh/Animate
    Class: LocalScript
    Time: 2026-10-03 12:27:01
--]]

local Parent_upv_1 = script.Parent
local Torso_1 = Parent_upv_1:WaitForChild("Torso")
local u1 = Torso_1:WaitForChild("Right Shoulder")
local u2 = Torso_1:WaitForChild("Left Shoulder")
local u3 = Torso_1:WaitForChild("Right Hip")
local u4 = Torso_1:WaitForChild("Left Hip")
local _ = Torso_1:WaitForChild("Neck")
local Humanoid_upv_1 = Parent_upv_1:WaitForChild("Humanoid")
local u5 = "Standing"
local success_1, v1 = pcall(
    function()
        --[[
          line: 15
        ]]
        return UserSettings():IsUserFeatureEnabled("UserAnimateScaleRun")
    end
)
local u6 = success_1 and v1
local function getRigScale()
    --[[
      name: getRigScale
      line: 18
      upvalues:
        u6 (copy, index: 1)
        Parent_upv_1 (copy, index: 2)
    ]]
    if u6 then
        return Parent_upv_1:GetScale()
    end
    return 1
end
local u7 = ""
local u8 = nil
local u9 = nil
local u10 = nil
local u11 = 1
local tbl_upv_1 = {}
local tbl_upv_2 = {}
tbl_upv_2.idle = {{id = "http://www.roblox.com/asset/?id=180435571", weight = 9}, {id = "http://www.roblox.com/asset/?id=180435792", weight = 1}}
tbl_upv_2.walk = {{id = "http://www.roblox.com/asset/?id=180426354", weight = 10}}
tbl_upv_2.run = {{id = "run.xml", weight = 10}}
tbl_upv_2.jump = {{id = "http://www.roblox.com/asset/?id=125750702", weight = 10}}
tbl_upv_2.fall = {{id = "http://www.roblox.com/asset/?id=180436148", weight = 10}}
tbl_upv_2.climb = {{id = "http://www.roblox.com/asset/?id=180436334", weight = 10}}
tbl_upv_2.sit = {{id = "http://www.roblox.com/asset/?id=178130996", weight = 10}}
tbl_upv_2.toolnone = {{id = "http://www.roblox.com/asset/?id=182393478", weight = 10}}
tbl_upv_2.toolslash = {{id = "http://www.roblox.com/asset/?id=129967390", weight = 10}}
tbl_upv_2.toollunge = {{id = "http://www.roblox.com/asset/?id=129967478", weight = 10}}
tbl_upv_2.wave = {{id = "http://www.roblox.com/asset/?id=128777973", weight = 10}}
tbl_upv_2.point = {{id = "http://www.roblox.com/asset/?id=128853357", weight = 10}}
tbl_upv_2.dance1 = {{id = "http://www.roblox.com/asset/?id=182435998", weight = 10}, {id = "http://www.roblox.com/asset/?id=182491037", weight = 10}, {id = "http://www.roblox.com/asset/?id=182491065", weight = 10}}
tbl_upv_2.dance2 = {{id = "http://www.roblox.com/asset/?id=182436842", weight = 10}, {id = "http://www.roblox.com/asset/?id=182491248", weight = 10}, {id = "http://www.roblox.com/asset/?id=182491277", weight = 10}}
tbl_upv_2.dance3 = {{id = "http://www.roblox.com/asset/?id=182436935", weight = 10}, {id = "http://www.roblox.com/asset/?id=182491368", weight = 10}, {id = "http://www.roblox.com/asset/?id=182491423", weight = 10}}
tbl_upv_2.laugh = {{id = "http://www.roblox.com/asset/?id=129423131", weight = 10}}
tbl_upv_2.cheer = {{id = "http://www.roblox.com/asset/?id=129423030", weight = 10}}
local tbl_upv_3 = {"dance1", "dance2", "dance3"}
local tbl_upv_4 = {laugh = false, wave = false, point = false, dance2 = true, cheer = false, dance3 = true, dance1 = true}
function configureAnimationSet(a1, a2)
    --[[
      name: configureAnimationSet
      line: 98
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if tbl_upv_1[a1] ~= nil then
        for _, value_1 in pairs(tbl_upv_1[a1].connections) do
            value_1:disconnect()
        end
    end
    tbl_upv_1[a1] = {}
    tbl_upv_1[a1].count = 0
    tbl_upv_1[a1].totalWeight = 0
    tbl_upv_1[a1].connections = {}
    local v2 = script:FindFirstChild(a1)
    if v2 ~= nil then
        table.insert(
            tbl_upv_1[a1].connections,
            v2.ChildAdded:connect(
                function(a3)
                    --[[
                      line: 113
                      upvalues:
                        a1 (copy, index: 1)
                        a2 (copy, index: 2)
                    ]]
                    configureAnimationSet(a1, a2)
                end
            )
        )
        table.insert(
            tbl_upv_1[a1].connections,
            v2.ChildRemoved:connect(
                function(a4)
                    --[[
                      line: 114
                      upvalues:
                        a1 (copy, index: 1)
                        a2 (copy, index: 2)
                    ]]
                    configureAnimationSet(a1, a2)
                end
            )
        )
        local v3 = 1
        for _, value_2 in pairs(v2:GetChildren()) do
            local v4 = value_2:IsA("Animation")
            if not (v4) then
                continue
            end
            table.insert(
                tbl_upv_1[a1].connections,
                value_2.Changed:connect(
                    function(a5)
                        --[[
                          line: 118
                          upvalues:
                            a1 (copy, index: 1)
                            a2 (copy, index: 2)
                        ]]
                        configureAnimationSet(a1, a2)
                    end
                )
            )
            tbl_upv_1[a1][v3] = {}
            tbl_upv_1[a1][v3].anim = value_2
            local Weight_1 = value_2:FindFirstChild("Weight")
            if Weight_1 ~= nil then
                tbl_upv_1[a1][v3].weight = Weight_1.Value
            else
                tbl_upv_1[a1][v3].weight = 1
            end
            tbl_upv_1[a1].count = tbl_upv_1[a1].count + 1
            tbl_upv_1[a1].totalWeight = tbl_upv_1[a1].totalWeight + tbl_upv_1[a1][v3].weight
            v3 = v3 + 1
        end
    end
    if not (tbl_upv_1[a1].count <= 0) then
        return
    end
    for key_1, value_3 in pairs(a2) do
        tbl_upv_1[a1][key_1] = {}
        tbl_upv_1[a1][key_1].anim = Instance.new("Animation")
        tbl_upv_1[a1][key_1].anim.Name = a1
        tbl_upv_1[a1][key_1].anim.AnimationId = value_3.id
        tbl_upv_1[a1][key_1].weight = value_3.weight
        tbl_upv_1[a1].count = tbl_upv_1[a1].count + 1
        tbl_upv_1[a1].totalWeight = tbl_upv_1[a1].totalWeight + value_3.weight
    end
end
function scriptChildModified(a1)
    --[[
      name: scriptChildModified
      line: 151
      upvalues:
        tbl_upv_2 (copy, index: 1)
    ]]
    local v5 = tbl_upv_2[a1.Name]
    if v5 == nil then
        return
    end
    configureAnimationSet(a1.Name, v5)
end
script.ChildAdded:connect(scriptChildModified)
script.ChildRemoved:connect(scriptChildModified)
local v6
if Humanoid_upv_1 then
    v6 = Humanoid_upv_1:FindFirstChildOfClass("Animator")
else
    v6 = nil
end
if v6 then
    for v7, value_4 in ipairs(v6:GetPlayingAnimationTracks()) do
        value_4:Stop(0)
        value_4:Destroy()
    end
end
for key_2, value_5 in pairs(tbl_upv_2) do
    configureAnimationSet(key_2, value_5)
end
local u12 = "None"
local u13 = 0
local u14 = 0
function stopAllAnimations()
    --[[
      name: stopAllAnimations
      line: 192
      upvalues:
        u7 (ref,  index: 1)
        tbl_upv_4 (copy, index: 2)
        u8 (ref,  index: 3)
        u10 (ref,  index: 4)
        u9 (ref,  index: 5)
    ]]
    local v7 = u7
    if tbl_upv_4[v7] ~= nil and tbl_upv_4[v7] == false then
        v7 = "idle"
    end
    u7 = ""
    u8 = nil
    if u10 ~= nil then
        u10:disconnect()
    end
    if u9 ~= nil then
        u9:Stop()
        u9:Destroy()
        u9 = nil
    end
    return v7
end
function setAnimationSpeed(a1)
    --[[
      name: setAnimationSpeed
      line: 214
      upvalues:
        u11 (ref, index: 1)
        u9 (ref, index: 2)
    ]]
    if a1 == u11 then
        return
    end
    u11 = a1
    u9:AdjustSpeed(u11)
end
function keyFrameReachedFunc(a1)
    --[[
      name: keyFrameReachedFunc
      line: 221
      upvalues:
        u7 (ref,  index: 1)
        tbl_upv_4 (copy, index: 2)
        u11 (ref,  index: 3)
        Humanoid_upv_1 (copy, index: 4)
    ]]
    if a1 == "End" then
        local v8 = u7
        if tbl_upv_4[v8] ~= nil and tbl_upv_4[v8] == false then
            v8 = "idle"
        end
        local v9 = u11
        playAnimation(v8, 0, Humanoid_upv_1)
        setAnimationSpeed(v9)
    end
end
function playAnimation(a1, a2, a3)
    --[[
      name: playAnimation
      line: 237
      upvalues:
        tbl_upv_1 (copy, index: 1)
        u8 (ref,  index: 2)
        u9 (ref,  index: 3)
        u11 (ref,  index: 4)
    ]]
    local v10 = math.random(1, tbl_upv_1[a1].totalWeight)
    local v11 = 1
    while tbl_upv_1[a1][v11].weight < v10 do
        v10 = v10 - tbl_upv_1[a1][v11].weight
        v11 = v11 + 1
    end
    local anim_1 = tbl_upv_1[a1][v11].anim
    if anim_1 == u8 then
        return
    end
    if u9 ~= nil then
        u9:Stop(a2)
        u9:Destroy()
    end
    u11 = 1
    u9 = a3:LoadAnimation(anim_1)
    u9.Priority = Enum.AnimationPriority.Core
    u9:Play(a2)
    u11 = a1
    u8 = anim_1
    if u11 ~= nil then
        u11:disconnect()
    end
    u11 = u9.KeyframeReached:connect(keyFrameReachedFunc)
end
local u15 = ""
local u16 = nil
local u17 = nil
local u18 = nil
function toolKeyFrameReachedFunc(a1)
    --[[
      name: toolKeyFrameReachedFunc
      line: 286
      upvalues:
        u15 (ref,  index: 1)
        Humanoid_upv_1 (copy, index: 2)
    ]]
    if a1 ~= "End" then
        return
    end
    playToolAnimation(u15, 0, Humanoid_upv_1)
end
function playToolAnimation(a1, a2, a3, a4)
    --[[
      name: playToolAnimation
      line: 294
      upvalues:
        tbl_upv_1 (copy, index: 1)
        u17 (ref,  index: 2)
        u16 (ref,  index: 3)
        u15 (ref,  index: 4)
        u18 (ref,  index: 5)
    ]]
    local v12 = math.random(1, tbl_upv_1[a1].totalWeight)
    local v13 = 1
    while tbl_upv_1[a1][v13].weight < v12 do
        v12 = v12 - tbl_upv_1[a1][v13].weight
        v13 = v13 + 1
    end
    local anim_2 = tbl_upv_1[a1][v13].anim
    if u17 == anim_2 then
        return
    end
    if u16 ~= nil then
        u16:Stop()
        u16:Destroy()
        a2 = 0
    end
    u16 = a3:LoadAnimation(anim_2)
    if a4 then
        u16.Priority = a4
    end
    u16:Play(a2)
    u15 = a1
    u17 = anim_2
    u18 = u16.KeyframeReached:connect(toolKeyFrameReachedFunc)
end
function stopToolAnimations()
    --[[
      name: stopToolAnimations
      line: 329
      upvalues:
        u15 (ref, index: 1)
        u18 (ref, index: 2)
        u17 (ref, index: 3)
        u16 (ref, index: 4)
    ]]
    if u18 ~= nil then
        u18:disconnect()
    end
    u15 = ""
    u17 = nil
    if u16 ~= nil then
        u16:Stop()
        u16:Destroy()
        u16 = nil
    end
    return u15
end
function onRunning(a1)
    --[[
      name: onRunning
      line: 352
      upvalues:
        u6 (copy, index: 1)
        Parent_upv_1 (copy, index: 2)
        Humanoid_upv_1 (copy, index: 3)
        u8 (ref,  index: 4)
        u5 (ref,  index: 5)
        tbl_upv_4 (copy, index: 6)
        u7 (ref,  index: 7)
    ]]
    local v14 = ((not u6) and 1) or (Parent_upv_1:GetScale())
    a1 = a1 / v14
    if a1 > 0.01 then
        playAnimation("walk", 0.1, Humanoid_upv_1)
        if u8 and u8.AnimationId == "http://www.roblox.com/asset/?id=180426354" then
            setAnimationSpeed(a1 / 14.5)
        end
        u5 = "Running"
    elseif tbl_upv_4[u7] == nil then
        playAnimation("idle", 0.1, Humanoid_upv_1)
        u5 = "Standing"
    end
end
function onDied()
    --[[
      name: onDied
      line: 369
      upvalues:
        u5 (ref, index: 1)
    ]]
    u5 = "Dead"
end
function onJumping()
    --[[
      name: onJumping
      line: 373
      upvalues:
        Humanoid_upv_1 (copy, index: 1)
        u14 (ref,  index: 2)
        u5 (ref,  index: 3)
    ]]
    playAnimation("jump", 0.1, Humanoid_upv_1)
    u14 = 0.3
    u5 = "Jumping"
end
function onClimbing(a1)
    --[[
      name: onClimbing
      line: 379
      upvalues:
        u6 (copy, index: 1)
        Parent_upv_1 (copy, index: 2)
        Humanoid_upv_1 (copy, index: 3)
        u5 (ref,  index: 4)
    ]]
    local v15 = ((not u6) and 1) or (Parent_upv_1:GetScale())
    playAnimation("climb", 0.1, Humanoid_upv_1)
    setAnimationSpeed((a1 / v15) / 12)
    u5 = "Climbing"
end
function onGettingUp()
    --[[
      name: onGettingUp
      line: 387
      upvalues:
        u5 (ref, index: 1)
    ]]
    u5 = "GettingUp"
end
function onFreeFall()
    --[[
      name: onFreeFall
      line: 391
      upvalues:
        u14 (ref,  index: 1)
        Humanoid_upv_1 (copy, index: 2)
        u5 (ref,  index: 3)
    ]]
    if u14 <= 0 then
        playAnimation("fall", 0.3, Humanoid_upv_1)
    end
    u5 = "FreeFall"
end
function onFallingDown()
    --[[
      name: onFallingDown
      line: 398
      upvalues:
        u5 (ref, index: 1)
    ]]
    u5 = "FallingDown"
end
function onSeated()
    --[[
      name: onSeated
      line: 402
      upvalues:
        u5 (ref, index: 1)
    ]]
    u5 = "Seated"
end
function onPlatformStanding()
    --[[
      name: onPlatformStanding
      line: 406
      upvalues:
        u5 (ref, index: 1)
    ]]
    u5 = "PlatformStanding"
end
function onSwimming(a1)
    --[[
      name: onSwimming
      line: 410
      upvalues:
        u5 (ref, index: 1)
    ]]
    if a1 > 0 then
        u5 = "Running"
    else
        u5 = "Standing"
    end
end
function getTool()
    --[[
      name: getTool
      line: 418
      upvalues:
        Parent_upv_1 (copy, index: 1)
    ]]
    for _, value_6 in ipairs(Parent_upv_1:GetChildren()) do
        if value_6.className ~= "Tool" then
            continue
        end
        return value_6
    end
    return nil
end
function getToolAnim(a1)
    --[[
      name: getToolAnim
      line: 425
    ]]
    for _, value_7 in ipairs(a1:GetChildren()) do
        if value_7.Name ~= "toolanim" or value_7.className ~= "StringValue" then
            continue
        end
        return value_7
    end
    return nil
end
function animateTool()
    --[[
      name: animateTool
      line: 434
      upvalues:
        u12 (ref,  index: 1)
        Humanoid_upv_1 (copy, index: 2)
    ]]
    if u12 == "None" then
        playToolAnimation("toolnone", 0.1, Humanoid_upv_1, Enum.AnimationPriority.Idle)
    elseif u12 == "Slash" then
        playToolAnimation("toolslash", 0, Humanoid_upv_1, Enum.AnimationPriority.Action)
    elseif u12 == "Lunge" then
        playToolAnimation("toollunge", 0, Humanoid_upv_1, Enum.AnimationPriority.Action)
    end
end
function moveSit()
    --[[
      name: moveSit
      line: 452
      upvalues:
        u1 (copy, index: 1)
        u2 (copy, index: 2)
        u3 (copy, index: 3)
        u4 (copy, index: 4)
    ]]
    u1.MaxVelocity = 0.15
    u2.MaxVelocity = 0.15
    u1:SetDesiredAngle(1.57)
    u2:SetDesiredAngle(-1.57)
    u3:SetDesiredAngle(1.57)
    u4:SetDesiredAngle(-1.57)
end
local u19 = 0
function move(a1)
    --[[
      name: move
      line: 463
      upvalues:
        u19 (ref,  index: 1)
        u14 (ref,  index: 2)
        u5 (ref,  index: 3)
        Humanoid_upv_1 (copy, index: 4)
        u1 (copy, index: 5)
        u2 (copy, index: 6)
        u3 (copy, index: 7)
        u4 (copy, index: 8)
        u12 (ref,  index: 9)
        u13 (ref,  index: 10)
        u17 (ref,  index: 11)
    ]]
    local v16 = 1
    local v17 = 1
    local v18 = a1 - u19
    u19 = a1
    local v19 = false
    if u14 > 0 then
        u14 = u14 - v18
    end
    if u5 == "FreeFall" and u14 <= 0 then
        playAnimation("fall", 0.3, Humanoid_upv_1)
        if v19 then
            local v20 = v16 * math.sin(a1 * v17)
            u1:SetDesiredAngle(v20 + 0)
            u2:SetDesiredAngle(v20 - 0)
            u3:SetDesiredAngle(-v20)
            u4:SetDesiredAngle(-v20)
        end
        local v21 = getTool()
        if v21 and v21:FindFirstChild("Handle") then
            local v22 = getToolAnim(v21)
            if v22 then
                u12 = v22.Value
                v22.Parent = nil
                u13 = a1 + 0.3
            end
            if u13 < a1 then
                u13 = 0
                u12 = "None"
            end
            animateTool()
            return
        end
        stopToolAnimations()
        u12 = "None"
        u17 = nil
        u13 = 0
        return
    end
    if u5 ~= "Seated" then
        if u5 == "Running" then
            playAnimation("walk", 0.1, Humanoid_upv_1)
        elseif u5 == "Dead" or u5 == "GettingUp" or u5 == "FallingDown" or u5 == "Seated" or u5 == "PlatformStanding" then
            stopAllAnimations()
            v19, v17, v16 = true, 1, 0.1
        end
        if v19 then
            local v20 = v16 * math.sin(a1 * v17)
            u1:SetDesiredAngle(v20 + 0)
            u2:SetDesiredAngle(v20 - 0)
            u3:SetDesiredAngle(-v20)
            u4:SetDesiredAngle(-v20)
        end
        local v21 = getTool()
        if v21 and v21:FindFirstChild("Handle") then
            local v22 = getToolAnim(v21)
            if v22 then
                u12 = v22.Value
                v22.Parent = nil
                u13 = a1 + 0.3
            end
            if u13 < a1 then
                u13 = 0
                u12 = "None"
            end
            animateTool()
            return
        end
        stopToolAnimations()
        u12 = "None"
        u17 = nil
        u13 = 0
    else
        playAnimation("sit", 0.5, Humanoid_upv_1)
    end
end
Humanoid_upv_1.Died:connect(onDied)
Humanoid_upv_1.Running:connect(onRunning)
Humanoid_upv_1.Jumping:connect(onJumping)
Humanoid_upv_1.Climbing:connect(onClimbing)
Humanoid_upv_1.GettingUp:connect(onGettingUp)
Humanoid_upv_1.FreeFalling:connect(onFreeFall)
Humanoid_upv_1.FallingDown:connect(onFallingDown)
Humanoid_upv_1.Seated:connect(onSeated)
Humanoid_upv_1.PlatformStanding:connect(onPlatformStanding)
Humanoid_upv_1.Swimming:connect(onSwimming)
game:GetService("Players").LocalPlayer.Chatted:connect(
    function(a1)
        --[[
          line: 540
          upvalues:
            tbl_upv_3 (copy, index: 1)
            u5 (ref,  index: 2)
            tbl_upv_4 (copy, index: 3)
            Humanoid_upv_1 (copy, index: 4)
        ]]
        local v23 = ""
        if a1 == "/e dance" then
            v23 = tbl_upv_3[math.random(1, #tbl_upv_3)]
        elseif string.sub(a1, 1, 3) == "/e " then
            v23 = string.sub(a1, 4)
        elseif string.sub(a1, 1, 7) == "/emote " then
            v23 = string.sub(a1, 8)
        end
        if u5 ~= "Standing" or tbl_upv_4[v23] == nil then
            return
        end
        playAnimation(v23, 0.1, Humanoid_upv_1)
    end
)
local PlayEmote_1 = script:WaitForChild("PlayEmote")
PlayEmote_1.OnInvoke = function(a1)
    --[[
      line: 557
      upvalues:
        u5 (ref,  index: 1)
        tbl_upv_4 (copy, index: 2)
        Humanoid_upv_1 (copy, index: 3)
        u9 (ref,  index: 4)
    ]]
    if u5 == "Standing" then
        if tbl_upv_4[a1] == nil then
            return false
        end
        playAnimation(a1, 0.1, Humanoid_upv_1)
        return true, u9
    end
end
playAnimation("idle", 0.1, Humanoid_upv_1)
u5 = "Standing"
while Parent_upv_1.Parent ~= nil do
    local v8, total_time_1 = wait(0.1)
    move(total_time_1)
end