local parent = script.Parent
local torso = parent:WaitForChild("Torso")
local right_shoulder = torso:WaitForChild("Right Shoulder")
local left_shoulder = torso:WaitForChild("Left Shoulder")
local right_hip = torso:WaitForChild("Right Hip")
local left_hip = torso:WaitForChild("Left Hip")
local _ = torso:WaitForChild("Neck")
local humanoid = parent:WaitForChild("Humanoid")
local text = "Standing"
local success, value = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserAnimateScaleRun")
end)
local value_2 = success and value

local function get_rig_scale()
    if value_2 then
        return parent:GetScale()
    end

    return 1
end

local text_2 = ""
local value_3 = nil
local instance = nil
local value_4 = nil
local speed = 1
local values = {}
local values_2 = {}
values_2.idle = { { id = "", weight = 9 } }
values_2.walk = { { id = "", weight = 10 } }
values_2.jump = { { id = "", weight = 9 } }
values_2.fall = { { id = "http://www.roblox.com/asset/?id=180436148", weight = 10 } }
values_2.climb = { { id = "http://www.roblox.com/asset/?id=180436334", weight = 10 } }
values_2.sit = { { id = "http://www.roblox.com/asset/?id=178130996", weight = 10 } }
values_2.toolnone = { { id = "http://www.roblox.com/asset/?id=182393478", weight = 10 } }
values_2.toolslash = { { id = "http://www.roblox.com/asset/?id=129967390", weight = 10 } }
values_2.toollunge = { { id = "http://www.roblox.com/asset/?id=129967478", weight = 10 } }
values_2.wave = { { id = "http://www.roblox.com/asset/?id=128777973", weight = 10 } }
values_2.point = { { id = "http://www.roblox.com/asset/?id=128853357", weight = 10 } }
values_2.dance1 = {
    { id = "http://www.roblox.com/asset/?id=182435998", weight = 10 },
    { id = "http://www.roblox.com/asset/?id=182491037", weight = 10 },
    { id = "http://www.roblox.com/asset/?id=182491065", weight = 10 },
}
values_2.dance2 = {
    { id = "http://www.roblox.com/asset/?id=182436842", weight = 10 },
    { id = "http://www.roblox.com/asset/?id=182491248", weight = 10 },
    { id = "http://www.roblox.com/asset/?id=182491277", weight = 10 },
}
values_2.dance3 = {
    { id = "http://www.roblox.com/asset/?id=182436935", weight = 10 },
    { id = "http://www.roblox.com/asset/?id=182491368", weight = 10 },
    { id = "http://www.roblox.com/asset/?id=182491423", weight = 10 },
}
values_2.laugh = { { id = "http://www.roblox.com/asset/?id=129423131", weight = 10 } }
values_2.cheer = { { id = "http://www.roblox.com/asset/?id=129423030", weight = 10 } }
local values_3 = { "dance1", "dance2", "dance3" }
local values_4 =
    { laugh = false, wave = false, point = false, dance2 = true, cheer = false, dance3 = true, dance1 = true }

function configureAnimationSet(child_name_2, argument)
    if values[child_name_2] ~= nil then
        for _, item_2 in pairs(values[child_name_2].connections) do
            item_2:disconnect()
        end
    end

    values[child_name_2] = {}
    values[child_name_2].count = 0
    values[child_name_2].totalWeight = 0
    values[child_name_2].connections = {}
    local first_child = script:FindFirstChild(child_name_2)

    if first_child ~= nil then
        table.insert(
            values[child_name_2].connections,
            first_child.ChildAdded:connect(function(argument_2)
                configureAnimationSet(child_name_2, argument)
            end)
        )
        table.insert(
            values[child_name_2].connections,
            first_child.ChildRemoved:connect(function(argument_2)
                configureAnimationSet(child_name_2, argument)
            end)
        )
        local number_4 = 1

        for _, anim in pairs(first_child:GetChildren()) do
            local is_a_result = anim:IsA("Animation")

            if not is_a_result then
                continue
            end

            table.insert(
                values[child_name_2].connections,
                anim.Changed:connect(function(argument_2)
                    configureAnimationSet(child_name_2, argument)
                end)
            )
            values[child_name_2][number_4] = {}
            values[child_name_2][number_4].anim = anim
            local weight = anim:FindFirstChild("Weight")

            if weight ~= nil then
                values[child_name_2][number_4].weight = weight.Value
            else
                values[child_name_2][number_4].weight = 1
            end

            values[child_name_2].count = values[child_name_2].count + 1
            values[child_name_2].totalWeight = values[child_name_2].totalWeight + values[child_name_2][number_4].weight
            number_4 = number_4 + 1
        end
    end

    if not (values[child_name_2].count <= 0) then
        return
    end

    for key, item_3 in pairs(argument) do
        values[child_name_2][key] = {}
        values[child_name_2][key].anim = Instance.new("Animation")
        values[child_name_2][key].anim.Name = child_name_2
        values[child_name_2][key].anim.AnimationId = item_3.id
        values[child_name_2][key].weight = item_3.weight
        values[child_name_2].count = values[child_name_2].count + 1
        values[child_name_2].totalWeight = values[child_name_2].totalWeight + item_3.weight
    end
end

function scriptChildModified(argument)
    local value_entry = values_2[argument.Name]

    if value_entry == nil then
        return
    end

    configureAnimationSet(argument.Name, value_entry)
end

script.ChildAdded:connect(scriptChildModified)
script.ChildRemoved:connect(scriptChildModified)
local animator

if humanoid then
    animator = humanoid:FindFirstChildOfClass("Animator")
else
    animator = nil
end

if animator then
    for index, instance_2 in ipairs(animator:GetPlayingAnimationTracks()) do
        instance_2:Stop(0)
        instance_2:Destroy()
    end
end

for child_name, item in pairs(values_2) do
    configureAnimationSet(child_name, item)
end

local text_3 = "None"
local number = 0
local number_2 = 0

function stopAllAnimations()
    local text_5 = text_2

    if values_4[text_5] ~= nil and values_4[text_5] == false then
        text_5 = "idle"
    end

    text_2 = ""
    value_3 = nil

    if value_4 ~= nil then
        value_4:disconnect()
    end

    if instance ~= nil then
        instance:Stop()
        instance:Destroy()
        instance = nil
    end

    return text_5
end

function setAnimationSpeed(argument)
    if argument == speed then
        return
    end

    speed = argument
    instance:AdjustSpeed(speed)
end

function keyFrameReachedFunc(argument)
    if argument ~= "End" then
        return
    end

    local text_5 = text_2

    if values_4[text_5] ~= nil and values_4[text_5] == false then
        text_5 = "idle"
    end

    local speed_2 = speed
    playAnimation(text_5, 0, humanoid)
    setAnimationSpeed(speed_2)
end

function playAnimation(argument, argument_2, argument_3)
    local anim = math.random(1, values[argument].totalWeight)
    local number_4 = 1

    while values[argument][number_4].weight < anim do
        anim = anim - values[argument][number_4].weight
        number_4 = number_4 + 1
    end

    anim = values[argument][number_4].anim

    if anim == value_3 then
        return
    end

    if instance ~= nil then
        instance:Stop(argument_2)
        instance:Destroy()
    end

    speed = 1
    instance = argument_3:LoadAnimation(anim)
    instance.Priority = Enum.AnimationPriority.Core
    instance:Play(argument_2)
    speed = argument
    value_3 = anim

    if speed ~= nil then
        speed:disconnect()
    end

    speed = instance.KeyframeReached:connect(keyFrameReachedFunc)
end

local text_4 = ""
local instance_3 = nil
local value_5 = nil
local value_6 = nil

function toolKeyFrameReachedFunc(argument)
    if argument ~= "End" then
        return
    end

    playToolAnimation(text_4, 0, humanoid)
end

function playToolAnimation(argument, number_4, argument_2, priority)
    local anim = math.random(1, values[argument].totalWeight)
    local number_5 = 1

    while values[argument][number_5].weight < anim do
        anim = anim - values[argument][number_5].weight
        number_5 = number_5 + 1
    end

    anim = values[argument][number_5].anim

    if value_5 == anim then
        return
    end

    if instance_3 ~= nil then
        instance_3:Stop()
        instance_3:Destroy()
        number_4 = 0
    end

    instance_3 = argument_2:LoadAnimation(anim)

    if priority then
        instance_3.Priority = priority
    end

    instance_3:Play(number_4)
    text_4 = argument
    value_5 = anim
    value_6 = instance_3.KeyframeReached:connect(toolKeyFrameReachedFunc)
end

function stopToolAnimations()
    if value_6 ~= nil then
        value_6:disconnect()
    end

    text_4 = ""
    value_5 = nil

    if instance_3 ~= nil then
        instance_3:Stop()
        instance_3:Destroy()
        instance_3 = nil
    end

    return text_4
end

function onRunning(quotient)
    local scale = ((not value_2) and 1) or parent:GetScale()
    quotient = quotient / scale

    if quotient > 0.01 then
        playAnimation("walk", 0.1, humanoid)

        if value_3 and value_3.AnimationId == "http://www.roblox.com/asset/?id=180426354" then
            setAnimationSpeed(quotient / 14.5)
        end

        text = "Running"
    elseif values_4[text_2] == nil then
        playAnimation("idle", 0.1, humanoid)
        text = "Standing"
    end
end

function onDied()
    text = "Dead"
end

function onJumping()
    playAnimation("jump", 0.1, humanoid)
    number_2 = 0.3
    text = "Jumping"
end

function onClimbing(argument)
    local scale = ((not value_2) and 1) or parent:GetScale()
    playAnimation("climb", 0.1, humanoid)
    setAnimationSpeed((argument / scale) / 12)
    text = "Climbing"
end

function onGettingUp()
    text = "GettingUp"
end

function onFreeFall()
    if number_2 <= 0 then
        playAnimation("fall", 0.3, humanoid)
    end

    text = "FreeFall"
end

function onFallingDown()
    text = "FallingDown"
end

function onSeated()
    text = "Seated"
end

function onPlatformStanding()
    text = "PlatformStanding"
end

function onSwimming(argument)
    if argument > 0 then
        text = "Running"
    else
        text = "Standing"
    end
end

function getTool()
    for _, child in ipairs(parent:GetChildren()) do
        if child.className ~= "Tool" then
            continue
        end

        return child
    end

    return nil
end

function getToolAnim(instance_4)
    for _, child in ipairs(instance_4:GetChildren()) do
        if child.Name ~= "toolanim" or child.className ~= "StringValue" then
            continue
        end

        return child
    end

    return nil
end

function animateTool()
    if text_3 == "None" then
        playToolAnimation("toolnone", 0.1, humanoid, Enum.AnimationPriority.Idle)
    elseif text_3 == "Slash" then
        playToolAnimation("toolslash", 0, humanoid, Enum.AnimationPriority.Action)
    elseif text_3 == "Lunge" then
        playToolAnimation("toollunge", 0, humanoid, Enum.AnimationPriority.Action)
    end
end

function moveSit()
    right_shoulder.MaxVelocity = 0.15
    left_shoulder.MaxVelocity = 0.15
    right_shoulder:SetDesiredAngle(1.57)
    left_shoulder:SetDesiredAngle(-1.57)
    right_hip:SetDesiredAngle(1.57)
    left_hip:SetDesiredAngle(-1.57)
end

local number_3 = 0

function move(argument)
    local number_4 = 1
    local number_5 = 1
    local difference = argument - number_3
    number_3 = argument
    local instance_4 = false

    if number_2 > 0 then
        number_2 = number_2 - difference
    end

    if text == "FreeFall" and number_2 <= 0 then
        playAnimation("fall", 0.3, humanoid)

        if instance_4 then
            local product = number_4 * math.sin(argument * number_5)
            right_shoulder:SetDesiredAngle(product + 0)
            left_shoulder:SetDesiredAngle(product - 0)
            right_hip:SetDesiredAngle(-product)
            left_hip:SetDesiredAngle(-product)
        end

        instance_4 = getTool()

        if instance_4 and instance_4:FindFirstChild("Handle") then
            number_5 = getToolAnim(instance_4)

            if number_5 then
                text_3 = number_5.Value
                number_5.Parent = nil
                number = argument + 0.3
            end

            if number < argument then
                number = 0
                text_3 = "None"
            end

            animateTool()

            return
        end

        stopToolAnimations()
        text_3 = "None"
        value_5 = nil
        number = 0

        return
    end

    if text ~= "Seated" then
        if text == "Running" then
            playAnimation("walk", 0.1, humanoid)
        elseif
            text == "Dead"
            or text == "GettingUp"
            or text == "FallingDown"
            or text == "Seated"
            or text == "PlatformStanding"
        then
            stopAllAnimations()
            instance_4, number_5, number_4 = true, 1, 0.1
        end

        if instance_4 then
            local product_2 = number_4 * math.sin(argument * number_5)
            right_shoulder:SetDesiredAngle(product_2 + 0)
            left_shoulder:SetDesiredAngle(product_2 - 0)
            right_hip:SetDesiredAngle(-product_2)
            left_hip:SetDesiredAngle(-product_2)
        end

        instance_4 = getTool()

        if instance_4 and instance_4:FindFirstChild("Handle") then
            number_5 = getToolAnim(instance_4)

            if number_5 then
                text_3 = number_5.Value
                number_5.Parent = nil
                number = argument + 0.3
            end

            if number < argument then
                number = 0
                text_3 = "None"
            end

            animateTool()

            return
        end

        stopToolAnimations()
        text_3 = "None"
        value_5 = nil
        number = 0
    else
        playAnimation("sit", 0.5, humanoid)
    end
end

humanoid.Died:connect(onDied)
humanoid.Running:connect(onRunning)
humanoid.Jumping:connect(onJumping)
humanoid.Climbing:connect(onClimbing)
humanoid.GettingUp:connect(onGettingUp)
humanoid.FreeFalling:connect(onFreeFall)
humanoid.FallingDown:connect(onFallingDown)
humanoid.Seated:connect(onSeated)
humanoid.PlatformStanding:connect(onPlatformStanding)
humanoid.Swimming:connect(onSwimming)

game:GetService("Players").LocalPlayer.Chatted:connect(function(argument)
    local text_5 = ""

    if argument == "/e dance" then
        text_5 = values_3[math.random(1, #values_3)]
    elseif string.sub(argument, 1, 3) == "/e " then
        text_5 = string.sub(argument, 4)
    elseif string.sub(argument, 1, 7) == "/emote " then
        text_5 = string.sub(argument, 8)
    end

    if text ~= "Standing" or values_4[text_5] == nil then
        return
    end

    playAnimation(text_5, 0.1, humanoid)
end)

local play_emote = script:WaitForChild("PlayEmote")
play_emote.OnInvoke = function(argument)
    if text ~= "Standing" then
        return
    end

    if values_4[argument] == nil then
        return false
    end

    playAnimation(argument, 0.1, humanoid)

    return true, instance
end
playAnimation("idle", 0.1, humanoid)
text = "Standing"

while parent.Parent ~= nil do
    local wait_result, total_time = wait(0.1)
    move(total_time)
end
