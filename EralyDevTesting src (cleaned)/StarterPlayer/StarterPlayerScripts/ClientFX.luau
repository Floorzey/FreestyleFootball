local local_player = game.Players.LocalPlayer

repeat
    task.wait()
until local_player:FindFirstChild("dataLoaded")

game:GetService("RunService")
local ball_status = game.Workspace.ballStatus
local camera_shaker = require(game.ReplicatedStorage.Modules.CameraShaker)
require("@game/ReplicatedStorage/Modules/DialogueModule")
require("@game/ReplicatedStorage/Modules/ForgeVFX").init()
local after_image = require("@game/ReplicatedStorage/Modules/AfterImage")
local candy_handler = require("@game/ReplicatedStorage/Modules/CandyHandler")

task.spawn(function()
    candy_handler:Init()
end)

local function tween_beam_transparency(argument: userdata, argument_2: userdata, tween_info: userdata, enabled: boolean)
    local number_value = Instance.new("NumberValue")
    number_value.Value = enabled == true and 1 or 0.6
    local items = {}

    for index = 1, #argument_2.Keypoints do
        table.insert(items, index, argument_2.Keypoints[index])
        local _ = index
    end

    number_value.Changed:Connect(function(argument_3)
        local items_2 = {}

        for index_2, item in ipairs(items) do
            table.insert(
                items_2,
                index_2,
                NumberSequenceKeypoint.new(
                    item.Time,
                    item.Value == 1 and 1 or (enabled == true and item.Value + argument_3 or item.Value * argument_3)
                )
            )
        end

        argument.Transparency = NumberSequence.new(items_2)
    end)

    local tween = game.TweenService:Create(number_value, tween_info, {
        Value = enabled == true and 0.6 or 1,
    })

    tween.Completed:Once(function()
        number_value:Destroy()
    end)

    tween:Play()
end

fxFunctions = {
    LocalAuraSound = function(argument)
        if not local_player.Settings.Misc.AuraEffects.Value then
            return
        end

        local target_character = argument.TargetCharacter
        local clone = game.ReplicatedStorage.SFX:FindFirstChild("Aura" .. tostring(math.random(1, 3))):Clone()
        clone.Parent = target_character.HumanoidRootPart
        clone:Play()
        clone.Ended:Wait()
        clone:Destroy()
    end,

    Knuckling = function(mouse)
        local target = mouse.Target
        local clone = script.Knuckling:Clone()
        clone.Parent = target.PlayerGui.HUD.SkillCD

        task.delay(4.5, function()
            game.TweenService
                :Create(clone, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
                    TextTransparency = 1,
                    TextStrokeTransparency = 1,
                })
                :Play()
            task.wait(0.5)
            clone:Destroy()
        end)
    end,

    Heartbeat = function(mouse)
        local _ = mouse.Target
        local time = mouse.Time
        local tween_service = game:GetService("TweenService")
        local screen = game:GetService("Players").LocalPlayer.PlayerGui.Screen
        local image_label = Instance.new("ImageLabel")
        image_label.Size = UDim2.fromScale(1, 1)
        image_label.Position = UDim2.fromScale(0, 0)
        image_label.BackgroundTransparency = 1
        image_label.Image = "rbxassetid://82653864607159"
        image_label.ImageColor3 = Color3.new(1)
        image_label.ImageTransparency = 1
        image_label.ScaleType = Enum.ScaleType.Stretch
        image_label.Parent = screen
        local tween_info = TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local tween_info_2 = TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.In)

        local function do_pulse()
            local tween = tween_service:Create(image_label, tween_info, {
                ImageTransparency = 0.6,
            })
            tween:Play()

            tween.Completed:Connect(function()
                tween_service
                    :Create(image_label, tween_info_2, {
                        ImageTransparency = 1,
                    })
                    :Play()
            end)
        end

        local number = 0

        local function do_double_pulse()
            do_pulse()
            local sound = Instance.new("Sound", game.SoundService)
            sound.SoundId = "rbxassetid://133239214818347"
            sound:Play()
            sound.Volume = 0.3

            task.delay(2, function()
                sound:Destroy()
            end)

            task.delay(0.15, do_pulse)
        end

        while number < time do
            do_double_pulse()
            task.wait(0.8333333333333334)
            number += 0.8333333333333334
        end
    end,

    OverchargeTrail = function(argument) end,

    AuraTrigger = function(argument)
        if not local_player.Settings.Misc.AuraEffects.Value then
            return
        end

        local target_character = argument.TargetCharacter
        local _ = argument.TargetPlayer
        local aura = argument.Aura

        if not aura then
            return
        end

        for _, child in pairs(aura:GetChildren()) do
            if child.Name == "Torso" then
                local aura_2 = child:Clone()
                aura_2.Name = "Aura"
                aura_2.Parent = target_character.Torso
            end

            if child.Name == "Left Arm" then
                local aura_3 = child:Clone()
                aura_3.Name = "Aura"
                aura_3.Parent = target_character["Left Arm"]
            end

            if child.Name == "Left Leg" then
                local aura_4 = child:Clone()
                aura_4.Name = "Aura"
                aura_4.Parent = target_character["Left Leg"]
            end

            if child.Name == "Right Leg" then
                local aura_5 = child:Clone()
                aura_5.Name = "Aura"
                aura_5.Parent = target_character["Right Leg"]
            end

            if child.Name == "Right Arm" then
                local aura_6 = child:Clone()
                aura_6.Name = "Aura"
                aura_6.Parent = target_character["Right Arm"]
            end

            if child.Name == "Head" then
                local aura_7 = child:Clone()
                aura_7.Name = "Aura"
                aura_7.Parent = target_character.Head
            end

            local child_3 = child

            for _, descendant in ipairs(child:GetDescendants()) do
                if descendant:IsA("Light") or descendant:IsA("Script") then
                    descendant:Destroy()
                end
            end

            if child_3.Name == "AttachmentHolder" then
                for _, child2 in pairs(child_3:GetChildren()) do
                    if child2.Name == "HRP" then
                        local aura_8 = child2:Clone()
                        aura_8.Name = "Aura"
                        aura_8.Parent = target_character.HumanoidRootPart

                        if aura_8:IsA("Part") and aura_8:FindFirstChildOfClass("Weld") then
                            aura_8:FindFirstChildOfClass("Weld").Part0 = target_character.HumanoidRootPart
                            game.Debris:AddItem(aura_8, 1)
                        end

                        if aura.Name == "Flaming Wings" then
                            for _, descendant_2 in ipairs(aura_8:GetDescendants()) do
                                if descendant_2:IsA("ParticleEmitter") then
                                    descendant_2.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.5, 0.95),
                                        NumberSequenceKeypoint.new(1, 1),
                                    })
                                    descendant_2.Rate = descendant_2.Rate / 2
                                end
                            end
                        elseif aura.Name == "Blue Death" or aura.Name == "Determination" then
                            for _, descendant_3 in ipairs(aura_8:GetDescendants()) do
                                if descendant_3:IsA("ParticleEmitter") then
                                    descendant_3.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.25, 0.95),
                                        NumberSequenceKeypoint.new(1, 1),
                                    })
                                    descendant_3.Rate = descendant_3.Rate / 2
                                end
                            end
                        elseif aura.Name == "A Certain Gambler" then
                            for _, descendant_4 in ipairs(aura_8:GetDescendants()) do
                                if descendant_4:IsA("ParticleEmitter") then
                                    descendant_4.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.259, 1),
                                        NumberSequenceKeypoint.new(0.26, 0.7),
                                        NumberSequenceKeypoint.new(0.76, 0.7),
                                        NumberSequenceKeypoint.new(1, 1),
                                    })
                                    descendant_4.Rate = descendant_4.Rate / 2
                                end
                            end
                        elseif aura.Name == "Sakura" then
                            for _, descendant_5 in ipairs(aura_8:GetDescendants()) do
                                if descendant_5:IsA("ParticleEmitter") then
                                    descendant_5.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.5, 0.1),
                                        NumberSequenceKeypoint.new(0.85, 0.1),
                                        NumberSequenceKeypoint.new(1, 1),
                                    })
                                    descendant_5.Rate = descendant_5.Rate / 2
                                end
                            end
                        end

                        local beam = aura_8:FindFirstChildOfClass("Beam")

                        if beam then
                            if aura.Name == "Calculated Destruction" then
                                beam.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 0.3),
                                    NumberSequenceKeypoint.new(1, 0.3),
                                })
                            else
                                beam.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 0.8),
                                    NumberSequenceKeypoint.new(1, 0.8),
                                })
                            end
                        end
                    elseif child2.Name == "Head" then
                        local aura_9 = child2:Clone()
                        aura_9.Name = "Aura"
                        aura_9.Parent = target_character.Head

                        if aura_9:FindFirstChildOfClass("Weld") then
                            aura_9:FindFirstChildOfClass("Weld").Part0 = target_character.Head
                        end

                        if aura_9:GetAttribute("disband") then
                            task.spawn(function()
                                for _, child3 in pairs(aura_9:GetChildren()) do
                                    if child3:IsA("Attachment") then
                                        task.spawn(function()
                                            for _, child4 in pairs(child3:GetChildren()) do
                                                child4.Name = "Aura"
                                            end
                                        end)
                                    else
                                        child3.Name = "Aura"
                                    end

                                    child3.Parent = target_character.Head
                                end

                                aura_9:Destroy()
                            end)
                        end

                        local beam_2 = aura_9:FindFirstChildOfClass("Beam")

                        if beam_2 and aura.Name ~= "Monster" then
                            beam_2.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0.8),
                                NumberSequenceKeypoint.new(1, 0.8),
                            })
                        end
                    elseif child2.Name == "Torso" then
                        local aura_10 = child2:Clone()
                        aura_10.Name = "Aura"
                        aura_10.Parent = target_character.Torso

                        if aura_10:FindFirstChildOfClass("Weld") then
                            aura_10:FindFirstChildOfClass("Weld").Part0 = target_character.Torso
                        end

                        if aura_10:GetAttribute("disband") then
                            task.spawn(function()
                                for _, child3 in pairs(aura_10:GetChildren()) do
                                    if child3:IsA("Attachment") then
                                        task.spawn(function()
                                            for _, child4 in pairs(child3:GetChildren()) do
                                                child4.Name = "Aura"
                                            end
                                        end)
                                    else
                                        child3.Name = "Aura"
                                    end

                                    child3.Parent = target_character.Torso
                                end

                                aura_10:Destroy()
                            end)
                        end

                        local beam_3 = aura_10:FindFirstChildOfClass("Beam")

                        if aura.Name == "Flaming Wings" then
                            for _, descendant_6 in ipairs(aura_10:GetDescendants()) do
                                if descendant_6:IsA("ParticleEmitter") then
                                    descendant_6.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.5, 0.95),
                                        NumberSequenceKeypoint.new(1, 1),
                                    })
                                    descendant_6.Rate = descendant_6.Rate / 2
                                end
                            end
                        elseif aura.Name == "Godly" then
                            for _, descendant_7 in ipairs(aura_10:GetDescendants()) do
                                if descendant_7:IsA("ParticleEmitter") then
                                    descendant_7.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.5, 0.9),
                                        NumberSequenceKeypoint.new(1, 1),
                                    })
                                    descendant_7.Rate = descendant_7.Rate / 3
                                end
                            end
                        elseif aura.Name == "Death" then
                            for _, descendant_8 in ipairs(aura_10:GetDescendants()) do
                                if descendant_8:IsA("ParticleEmitter") then
                                    descendant_8.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.5, 0.8),
                                        NumberSequenceKeypoint.new(1, 1),
                                    })
                                    descendant_8.Rate = descendant_8.Rate / 2
                                end
                            end
                        end

                        if beam_3 then
                            beam_3.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0.8),
                                NumberSequenceKeypoint.new(1, 0.8),
                            })
                        end
                    elseif child2.Name == "Left Arm" then
                        local aura_11 = child2:Clone()
                        aura_11.Name = "Aura"
                        aura_11.Parent = target_character["Left Arm"]

                        if aura_11:FindFirstChildOfClass("Weld") then
                            aura_11:FindFirstChildOfClass("Weld").Part0 = target_character["Left Arm"]
                        end

                        if aura_11:GetAttribute("disband") then
                            task.spawn(function()
                                for _, child3 in pairs(aura_11:GetChildren()) do
                                    child3.Name = "Aura"
                                    child3.Parent = target_character["Left Arm"]
                                end

                                aura_11:Destroy()
                            end)
                        end

                        local beam_4 = aura_11:FindFirstChildOfClass("Beam")

                        if aura.Name == "Blue Rose" then
                            for _, descendant_9 in ipairs(aura_11:GetDescendants()) do
                                if descendant_9:IsA("ParticleEmitter") then
                                    descendant_9.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.5, 0.95),
                                        NumberSequenceKeypoint.new(1, 1),
                                    })
                                    descendant_9.Rate = descendant_9.Rate / 2
                                end
                            end
                        end

                        if beam_4 then
                            beam_4.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0.8),
                                NumberSequenceKeypoint.new(1, 0.8),
                            })
                        end
                    elseif child2.Name == "Left Leg" then
                        local aura_12 = child2:Clone()
                        aura_12.Name = "Aura"
                        aura_12.Parent = target_character["Left Leg"]

                        if aura_12:FindFirstChildOfClass("Weld") then
                            aura_12:FindFirstChildOfClass("Weld").Part0 = target_character["Left Leg"]
                        end

                        if aura_12:GetAttribute("disband") then
                            task.spawn(function()
                                for _, child3 in pairs(aura_12:GetChildren()) do
                                    if child3:IsA("Attachment") then
                                        task.spawn(function()
                                            for _, child4 in pairs(child3:GetChildren()) do
                                                child4.Name = "Aura"
                                            end
                                        end)
                                    else
                                        child3.Name = "Aura"
                                    end

                                    child3.Parent = target_character["Left Leg"]
                                end

                                aura_12:Destroy()
                            end)
                        end

                        local beam_5 = aura_12:FindFirstChildOfClass("Beam")

                        if beam_5 and aura.Name ~= "Monster" then
                            beam_5.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0.8),
                                NumberSequenceKeypoint.new(1, 0.8),
                            })
                        end
                    elseif child2.Name == "Right Leg" then
                        local aura_13 = child2:Clone()
                        aura_13.Name = "Aura"
                        aura_13.Parent = target_character["Right Leg"]

                        if aura_13:FindFirstChildOfClass("Weld") then
                            game.Debris:AddItem(aura_13, 1)
                            aura_13:FindFirstChildOfClass("Weld").Part0 = target_character["Right Leg"]
                        end

                        if aura_13:GetAttribute("disband") then
                            task.spawn(function()
                                for _, child3 in pairs(aura_13:GetChildren()) do
                                    if child3:IsA("Attachment") then
                                        task.spawn(function()
                                            for _, child4 in pairs(child3:GetChildren()) do
                                                child4.Name = "Aura"
                                            end
                                        end)
                                    else
                                        child3.Name = "Aura"
                                    end

                                    child3.Parent = target_character["Right Leg"]
                                end

                                aura_13:Destroy()
                            end)
                        end

                        local beam_6 = aura_13:FindFirstChildOfClass("Beam")

                        if beam_6 and aura.Name ~= "Monster" then
                            beam_6.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0.8),
                                NumberSequenceKeypoint.new(1, 0.8),
                            })
                        end
                    elseif child2.Name == "Right Arm" then
                        local aura_14 = child2:Clone()
                        aura_14.Name = "Aura"
                        aura_14.Parent = target_character["Right Arm"]

                        if aura_14:FindFirstChildOfClass("Weld") then
                            game.Debris:AddItem(aura_14, 1)
                            aura_14:FindFirstChildOfClass("Weld").Part0 = target_character["Right Arm"]
                        end

                        if aura_14:GetAttribute("disband") then
                            task.spawn(function()
                                for _, child3 in pairs(aura_14:GetChildren()) do
                                    if child3:IsA("Attachment") then
                                        task.spawn(function()
                                            for _, child4 in pairs(child3:GetChildren()) do
                                                child4.Name = "Aura"
                                            end
                                        end)
                                    else
                                        child3.Name = "Aura"
                                    end

                                    child3.Parent = target_character["Right Arm"]
                                end

                                aura_14:Destroy()
                            end)
                        end

                        local beam_7 = aura_14:FindFirstChildOfClass("Beam")

                        if beam_7 and aura.Name ~= "Monster" then
                            beam_7.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0.8),
                                NumberSequenceKeypoint.new(1, 0.8),
                            })
                        end
                    end
                end
            end
        end

        for _, child_2 in pairs(target_character:GetChildren()) do
            if
                child_2.Name == "Right Arm"
                or (
                    child_2.Name == "Left Arm"
                    or (
                        child_2.Name == "Left Leg"
                        or (child_2.Name == "Right Leg" or (child_2.Name == "Head" or child_2.Name == "Torso"))
                    )
                )
            then
                local parent = child_2

                for _, child2_2 in pairs(aura:GetChildren()) do
                    if child2_2:IsA("ParticleEmitter") and child2_2.Name ~= "Torso" then
                        local aura_15 = child2_2:Clone()
                        aura_15.Name = "Aura"
                        aura_15.Parent = parent
                        aura_15.Rate = aura_15.Rate / 2

                        if aura.Name ~= "Monster" then
                            aura_15.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 1),
                                NumberSequenceKeypoint.new(0.5, 0.85),
                                NumberSequenceKeypoint.new(1, 1),
                            })
                        end
                    end
                end
            end
        end

        task.delay(1, function()
            for _, descendant_10 in pairs(target_character:GetDescendants()) do
                if descendant_10.Name == "HasAura" then
                    descendant_10:Destroy()
                end

                local descendant_11

                if descendant_10:IsA("Attachment") and descendant_10:FindFirstChildWhichIsA("Beam") then
                    descendant_11 = descendant_10

                    for _, descendant2 in pairs(descendant_10:GetDescendants()) do
                        if descendant2:IsA("ParticleEmitter") then
                            task.spawn(function()
                                task.wait(1)
                                descendant2.Enabled = false
                            end)
                        elseif descendant2:IsA("Beam") then
                            task.spawn(function()
                                local number_value = Instance.new("NumberValue")
                                number_value.Parent = descendant2
                                number_value.Value = 0.6

                                number_value.Changed:Connect(function(argument_2)
                                    descendant2.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, argument_2),
                                        NumberSequenceKeypoint.new(1, argument_2),
                                    })
                                end)

                                local tween = game.TweenService:Create(number_value, TweenInfo.new(1), {
                                    Value = 1,
                                })
                                tween:Play()
                                tween.Completed:Wait()
                                descendant2.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 1),
                                    NumberSequenceKeypoint.new(1, 1),
                                })
                            end)
                        end

                        game.Debris:AddItem(descendant_11, 3)
                    end
                else
                    descendant_11 = descendant_10
                end

                if descendant_11.Name == "Aura" then
                    if descendant_11:IsA("ParticleEmitter") then
                        task.spawn(function()
                            task.wait(1)
                            descendant_11.Enabled = false
                        end)
                    end

                    game.Debris:AddItem(descendant_11, 3)
                end
            end
        end)
    end,

    BlueFlash = function(mouse)
        local target = mouse.Target
        local highlight = Instance.new("Highlight")
        highlight.FillTransparency = 1
        highlight.FillColor = Color3.new(0.12549, 0.666667, 1)
        highlight.OutlineTransparency = 1
        highlight.OutlineColor = Color3.new(0.12549, 0.666667, 1)
        highlight.Parent = target
        game.Debris:AddItem(highlight, 3)
        game:GetService("TweenService")
            :Create(highlight, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                FillTransparency = 0,
                OutlineTransparency = 0,
            })
            :Play()

        task.delay(0.125, function()
            game:GetService("TweenService")
                :Create(highlight, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                    FillTransparency = 1,
                    OutlineTransparency = 1,
                })
                :Play()
        end)
    end,

    WhiteFlash = function(mouse)
        local target = mouse.Target
        local highlight = Instance.new("Highlight")
        highlight.FillTransparency = 1
        highlight.FillColor = Color3.new(1, 1, 1)
        highlight.OutlineTransparency = 1
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.Parent = target
        game.Debris:AddItem(highlight, 3)
        game:GetService("TweenService")
            :Create(highlight, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                FillTransparency = 0,
                OutlineTransparency = 0,
            })
            :Play()

        task.delay(0.125, function()
            game:GetService("TweenService")
                :Create(highlight, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                    FillTransparency = 1,
                    OutlineTransparency = 1,
                })
                :Play()
        end)
    end,

    BlackFlash = function(mouse)
        local target = mouse.Target
        local highlight = Instance.new("Highlight")
        highlight.FillTransparency = 1
        highlight.FillColor = Color3.new(0, 0, 0)
        highlight.OutlineTransparency = 1
        highlight.OutlineColor = Color3.new(0, 0, 0)
        highlight.Parent = target
        game.Debris:AddItem(highlight, 3)
        game:GetService("TweenService")
            :Create(highlight, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                FillTransparency = 0,
                OutlineTransparency = 0,
            })
            :Play()

        task.delay(0.125, function()
            game:GetService("TweenService")
                :Create(highlight, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                    FillTransparency = 1,
                    OutlineTransparency = 1,
                })
                :Play()
        end)
    end,

    BigShockwave = function(argument)
        local cframe = argument.cframe
        local clone = game.ReplicatedStorage.VFX.Shockwave:Clone()
        clone.CFrame = cframe
        clone.Parent = game.Workspace.FX

        for _, item in pairs(clone.Shockwave:QueryDescendants("ParticleEmitter")) do
            item:Emit(item:GetAttribute("EmitCount"))
        end

        game.Debris:AddItem(clone, 3)
    end,

    FakeSD = function(mouse)
        local clone = game.ReplicatedStorage.VFX.FakeSD:Clone()
        clone.Parent = mouse.Target.HumanoidRootPart
        clone:Emit(1)
        game.Debris:AddItem(clone, 2)
    end,

    CutInSD = function(mouse)
        local clone = game.ReplicatedStorage.VFX.CutInSD:Clone()
        clone.Parent = mouse.Target.HumanoidRootPart
        clone:Emit(1)
        game.Debris:AddItem(clone, 2)
    end,

    ShootSD = function(mouse)
        local clone = game.ReplicatedStorage.VFX.ShootSD:Clone()
        clone.Parent = mouse.Target.HumanoidRootPart
        clone:Emit(1)
        game.Debris:AddItem(clone, 2)
    end,

    ["Chosen Emperor"] = function(mouse)
        local target = mouse.Target

        if not (target and target:GetAttribute("Egoist")) then
            return
        end

        local vfx_entry = game.ReplicatedStorage.VFX["Chosen Emperor"]
        local part1 = vfx_entry.Atmosphere:Clone()
        local part1_2 = vfx_entry.EmitPart:Clone()
        part1_2.Parent = workspace.FX
        part1.Parent = workspace.FX
        local weld = Instance.new("Weld", part1_2)
        weld.Part0 = mouse.Target.HumanoidRootPart
        weld.Part1 = part1_2
        local weld2 = Instance.new("Weld", part1_2)
        weld2.Part0 = mouse.Target.HumanoidRootPart
        weld2.Part1 = part1

        task.spawn(function()
            while part1 ~= nil do
                task.wait(0.025)

                if not mouse.Target:FindFirstChild("Emoting", true) then
                    part1_2:Destroy()
                    part1:Destroy()
                    part1 = nil
                end
            end
        end)

        task.delay(0.6, function()
            local clone = game.ReplicatedStorage.SFX.diveLand1:Clone()
            clone.Parent = mouse.Target
            clone:Play()

            clone.Ended:Connect(function()
                clone:Destroy()
            end)

            for _, child in pairs(part1_2.Emit:GetChildren()) do
                if child:IsA("ParticleEmitter") then
                    child:Emit(child:GetAttribute("EmitCount"))
                end
            end
        end)

        task.delay(1, function()
            local sound = Instance.new("Sound", mouse.Target)
            sound.SoundId = "rbxassetid://112246815107129"
            sound:Play()

            sound.Ended:Connect(function()
                sound:Destroy()
            end)
        end)

        task.delay(1.533, function()
            task.spawn(function()
                for _, child in pairs(part1_2.Emit2:GetChildren()) do
                    if child:IsA("ParticleEmitter") then
                        child:Emit(child:GetAttribute("EmitCount"))
                    end
                end
            end)

            task.spawn(function()
                for _, descendant in pairs(part1:GetDescendants()) do
                    if not descendant:IsA("Attachment") then
                        descendant.Enabled = true
                    end
                end
            end)
        end)

        task.delay(3, function()
            part1:Destroy()
            part1_2:Destroy()
        end)
    end,

    ["Eagle Eye"] = function(argument)
        local cframe = argument.cframe
        local clone = game.ReplicatedStorage.VFX.EagleEye:Clone()
        clone.Parent = workspace.Temp
        clone.CFrame = cframe
        shared.vfx.emit(clone)

        task.delay(2, function()
            clone:Destroy()
        end)
    end,

    ["Comet Touch"] = function(argument)
        local cframe = argument.cframe
        local clone = game.ReplicatedStorage.VFX.CometTouch:Clone()
        clone.Parent = workspace.Temp
        clone.CFrame = cframe
        shared.vfx.emit(clone)

        task.delay(3, function()
            clone:Destroy()
        end)
    end,

    AfterImage = function(mouse)
        after_image(
            mouse.Target,
            mouse.Time,
            mouse.TimeIB,
            mouse.Transparency,
            mouse.FadeInTime,
            mouse.timeBeforeFadeOut,
            mouse.fadeOutTime,
            mouse.Color
        )
    end,

    ImpactShockwave = function(argument)
        local cframe = argument.cframe

        if argument.play == game.Players.LocalPlayer then
            shared.vfx.emit(game.ReplicatedStorage.VFX.ImpactShake)
        end

        local clone = game.ReplicatedStorage.VFX.ImpactExtra:Clone()
        clone.CFrame = cframe
        shared.vfx.emit(clone)
        local clone_2 = game.ReplicatedStorage.VFX.ImpactShockwave:Clone()
        clone_2.CFrame = cframe
        clone_2.Parent = game.Workspace.FX
        local _ = clone_2.Attachment
        shared.vfx.emit(clone_2)
        game.Debris:AddItem(clone_2, 6)
    end,

    Timestop = function(mouse)
        local target = mouse.Target
        local clone = game.ReplicatedStorage.VFX.Timestop.Stand:Clone()
        clone.Parent = workspace.FX
        clone.AnimationController.Animator:LoadAnimation(clone.Timestop):Play()
        local camera_shaker_2 = camera_shaker.new(Enum.RenderPriority.Camera.Value, function(argument)
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * argument
        end)
        camera_shaker_2:Start()
        camera_shaker_2:Shake(camera_shaker.Presets.Vibration)

        task.delay(0.2, function()
            clone:PivotTo(target.HumanoidRootPart.CFrame)
            local cframe = clone.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)
            game.TweenService
                :Create(clone.HumanoidRootPart, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
                    CFrame = cframe,
                })
                :Play()

            task.spawn(function()
                for _, item in clone:QueryDescendants("ParticleEmitter") do
                    item:Emit(item:GetAttribute("EmitCount"))
                end
            end)
        end)

        local clone_2 = game.ReplicatedStorage.VFX.Timestop.Actuate2:Clone()
        clone_2.Parent = target.HumanoidRootPart
        clone_2:Play()

        clone_2.Ended:Once(function()
            clone_2:Destroy()
        end)

        task.delay(0.06, function()
            local clone_5 = game.ReplicatedStorage.VFX.Timestop.Actuate:Clone()
            clone_5.Parent = target.HumanoidRootPart
            clone_5:Play()

            clone_5.Ended:Once(function()
                clone_5:Destroy()
            end)
        end)

        local clone_3 = game.ReplicatedStorage.VFX.Timestop.HeadVFX:Clone()
        clone_3.Parent = target
        local weld = Instance.new("Weld", clone_3)
        weld.Part0 = target.Head
        weld.Part1 = weld.Parent
        local clone_4 = game.ReplicatedStorage.VFX.Timestop.RootVFX:Clone()
        clone_4.Parent = target
        local weld2 = Instance.new("Weld", clone_4)
        weld2.Part0 = target.HumanoidRootPart
        weld2.Part1 = weld2.Parent

        task.delay(0.5, function()
            for _, item in target:QueryDescendants("ParticleEmitter") do
                if item.Name == "BlackUp" then
                    item:Emit(item:GetAttribute("EmitCount"))
                end
            end
        end)

        task.delay(1, function()
            local clone_5 = game.ReplicatedStorage.VFX.Timestop.Land:Clone()
            clone_5.Parent = target.HumanoidRootPart
            clone_5:Play()

            clone_5.Ended:Once(function()
                clone_5:Destroy()
            end)

            for _, item in target:QueryDescendants("ParticleEmitter") do
                if item.Name == "exclamation" then
                    item:Emit(1)
                end
            end
        end)

        task.delay(1.167, function()
            local color_correction_effect = Instance.new("ColorCorrectionEffect", game.Lighting)
            game.TweenService
                :Create(color_correction_effect, TweenInfo.new(0.35, Enum.EasingStyle.Exponential), {
                    Saturation = -1,
                })
                :Play()
            local camera_shaker_3 = camera_shaker.new(Enum.RenderPriority.Camera.Value, function(argument)
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * argument
            end)
            camera_shaker_3:Start()
            camera_shaker_3:Shake(camera_shaker.Presets.Timestop)
            local cframe = clone.HumanoidRootPart.CFrame * CFrame.new(0, -4, 0)
            local tween =
                game.TweenService:Create(clone.HumanoidRootPart, TweenInfo.new(1.25, Enum.EasingStyle.Linear), {
                    CFrame = cframe,
                })
            tween:Play()

            tween.Completed:Connect(function()
                clone:Destroy()
            end)

            task.spawn(function()
                local enabled = true

                task.delay(7, function()
                    enabled = false
                end)

                while enabled do
                    task.wait(1)
                    game.ReplicatedStorage.VFX.Timestop.Clock:Play()
                end

                game.TweenService
                    :Create(color_correction_effect, TweenInfo.new(2, Enum.EasingStyle.Exponential), {
                        Saturation = 0,
                    })
                    :Play()

                task.delay(2, function()
                    color_correction_effect:Destroy()
                end)

                clone_3:Destroy()
                clone_4:Destroy()
                game.ReplicatedStorage.VFX.Timestop.Resume:Play()
            end)

            for _, item in target:QueryDescendants("ParticleEmitter") do
                if item.Name == "Mencaing" then
                    item:Emit(5)
                end

                if item.Name == "Clock" then
                    item:Emit(1)
                end
            end
        end)

        task.delay(2.25, function()
            local clone_5 = game.ReplicatedStorage.VFX.Timestop.VoiceAfter:Clone()
            clone_5.Parent = target.HumanoidRootPart
            clone_5:Play()

            clone_5.Ended:Once(function()
                clone_5:Destroy()
            end)
        end)
    end,

    Formless = function(argument)
        local cframe = argument.cframe
        local clone = game.ReplicatedStorage.VFX.Formless:Clone()
        clone.CFrame = cframe
        clone.Parent = game.Workspace.FX

        for _, child in pairs(clone.Attachment:GetChildren()) do
            child:Emit(child:GetAttribute("EmitCount"))
        end

        game.Debris:AddItem(clone, 3)
    end,

    SmallShockwave = function(argument)
        local cframe = argument.cframe
        local clone = game.ReplicatedStorage.VFX.Shockwave:Clone()
        clone.CFrame = cframe
        clone.Parent = game.Workspace.FX

        for _, item in pairs(clone.SmallShockwave:QueryDescendants("ParticleEmitter")) do
            item:Emit(item:GetAttribute("EmitCount"))
        end

        game.Debris:AddItem(clone, 2)
    end,

    Ripple = function(argument)
        local cframe = argument.cframe
        local clone = game.ReplicatedStorage.VFX.Shockwave:Clone()
        clone.CFrame = cframe
        clone.Parent = game.Workspace.FX

        for _, child in pairs(clone.Ripple:GetChildren()) do
            child:Emit(1)

            task.delay(0.35, function()
                child:Emit(1)
            end)
        end

        game.Debris:AddItem(clone, 2)
    end,

    Grasscutter = function(mouse)
        local target = mouse.Target
        local clone = game.ReplicatedStorage.VFX.Grasscutter:FindFirstChild(mouse.side):Clone()
        clone.Parent = target.HumanoidRootPart

        if local_player.Settings.Misc.SnowEnabled.Value == true then
            clone.CUTS.Color = ColorSequence.new(Color3.new(1, 1, 1))
        end

        clone.CUTS:Emit(25)
        game.Debris:AddItem(clone, 3)
    end,

    FakeShot = function(mouse)
        local target = mouse.Target
        local clone = game.ReplicatedStorage.VFX.Shockwave.fakeShot:Clone()
        clone.Parent = target.HumanoidRootPart

        for _, item in pairs(clone:QueryDescendants("ParticleEmitter")) do
            item:Emit(item:GetAttribute("EmitCount"))
        end

        game.Debris:AddItem(clone, 2)
    end,

    PinpointTrivelaTrail = function(argument)
        local t = argument.t or 0.5
        local ball = game.Workspace.Temp:FindFirstChild("Ball")

        if not ball then
            return
        end

        ball.Trail.Attachment0 = nil
        local clone = game.ReplicatedStorage.VFX.PinpointTrivela.CurveTrail:Clone()
        clone.Parent = ball
        clone.Attachment0 = ball.Attachment0
        clone.Attachment1 = ball.Attachment1
        local clone_2 = game.ReplicatedStorage.VFX.PinpointTrivela.SMOKE:Clone()
        clone_2.Parent = ball
        local clone_3 = game.ReplicatedStorage.VFX.PinpointTrivela.SMOKE:Clone()
        clone_3.Parent = ball
        local connection = nil
        connection = ball_status.inAir.Changed:Connect(function()
            if ball_status.inAir.Value ~= false then
                return
            end

            connection:Disconnect()
            clone_2.Enabled = false
            clone_3.Enabled = false
            clone.Enabled = false
        end)

        task.delay(t, function()
            ball.Trail.Attachment0 = ball.Attachment0
            connection:Disconnect()
            clone_3.Enabled = false
            clone_2.Enabled = false
            clone.Enabled = false
        end)
    end,

    CurveTrail = function(argument)
        local t = argument.t or 0.5
        local ball = game.Workspace.Temp:FindFirstChild("Ball")

        if not ball then
            return
        end

        ball.Trail.Attachment0 = nil
        local clone = game.ReplicatedStorage.VFX.CurveShots.CurveTrail:Clone()
        clone.Parent = ball
        clone.Attachment0 = ball.Attachment0
        clone.Attachment1 = ball.Attachment1
        local clone_2 = game.ReplicatedStorage.VFX.CurveShots.SMOKE:Clone()
        clone_2.Parent = ball
        local connection = nil
        connection = ball_status.inAir.Changed:Connect(function()
            if ball_status.inAir.Value ~= false then
                return
            end

            connection:Disconnect()
            clone_2.Enabled = false
            clone.Enabled = false
        end)

        task.delay(t, function()
            ball.Trail.Attachment0 = ball.Attachment0
            connection:Disconnect()
            clone_2.Enabled = false
            clone.Enabled = false
        end)
    end,

    Knuckleball = function(argument)
        local t = argument.t or 0.5
        local ball = game.Workspace.Temp:FindFirstChild("Ball")

        if ball then
            ball.Trail.Attachment0 = nil

            task.delay(t, function()
                ball.Trail.Attachment0 = ball.Attachment0
            end)
        end
    end,

    PowerShotTrail = function(argument)
        local t = argument.t or 0.5
        local ball = game.Workspace.Temp:FindFirstChild("Ball")

        if not ball then
            return
        end

        local power_shot_trail = game.ReplicatedStorage.VFX.PowerShotTrail
        local clone = power_shot_trail.PowerTrail:Clone()
        clone.Parent = ball
        local attachment0 = power_shot_trail.Attachment0:Clone()
        attachment0.Parent = ball
        local attachment1 = power_shot_trail.Attachment1:Clone()
        attachment1.Parent = ball
        clone.Attachment0 = attachment0
        clone.Attachment1 = attachment1
        local clone_2 = power_shot_trail.Attachment:Clone()
        clone_2.Parent = ball
        local clone_3 = power_shot_trail.SPECKS:Clone()
        clone_3.Parent = ball

        task.delay(0.1, function()
            clone_3.Enabled = true
        end)

        task.delay(t, function()
            clone_2.CenterSpark.Enabled = false
            clone.Enabled = false
            clone_3.Enabled = false
        end)
    end,

    ExplosiveBurst = function(mouse)
        local target = mouse.Target
        local clone = game.ReplicatedStorage.VFX.SPDash.Shockwave1:Clone()
        clone.Parent = target.HumanoidRootPart
        clone.CenterSpark:Emit(2)
        game.Debris:AddItem(clone, 3)
        local clone_2 = game.ReplicatedStorage.VFX.SPDash.Shockwave2:Clone()
        clone_2.Parent = target.HumanoidRootPart
        clone_2.CenterSpark:Emit(2)
        game.Debris:AddItem(clone_2, 3)
        local clone_3 = game.ReplicatedStorage.VFX.SPDash.Strike:Clone()
        clone_3.Parent = target.HumanoidRootPart
        clone_3.STRIKES:Emit(3)
        game.Debris:AddItem(clone, 3)
        local attachment0 = game.ReplicatedStorage.VFX.SPDash.Attachment0:Clone()
        attachment0.Parent = target.Torso
        local attachment1 = game.ReplicatedStorage.VFX.SPDash.Attachment1:Clone()
        attachment1.Parent = target.Torso
        local clone_4 = game.ReplicatedStorage.VFX.SPDash.Trail:Clone()
        clone_4.Parent = target.Torso
        clone_4.Attachment0 = attachment0
        clone_4.Attachment1 = attachment1
        clone_4.Enabled = true
        game.Debris:AddItem(attachment0, 3)
        game.Debris:AddItem(attachment1, 3)
        game.Debris:AddItem(clone_4, 3)

        task.delay(0.25, function()
            clone_4.Enabled = false
        end)
    end,

    Godspeed = function(mouse)
        local target = mouse.Target
        local clone = game.ReplicatedStorage.VFX.Godspeed:Clone()
        clone.Parent = workspace.FX
        clone.CFrame = target.HumanoidRootPart.CFrame
        game.Debris:AddItem(clone, 5)

        for _, descendant in pairs(clone:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                descendant:Emit(descendant:GetAttribute("EmitCount"))
            end
        end
    end,

    PlanetHotline = function(mouse)
        local target = mouse.Target
        local planet_hotline = game.ReplicatedStorage.VFX.PlanetHotline
        local clone = planet_hotline.PlanetHotline:Clone()
        clone.Brightness = 0
        clone.Contrast = 0
        clone.Saturation = 0
        clone.Parent = game.Lighting
        game:GetService("TweenService")
            :Create(clone, TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Brightness = -0.1,
                Contrast = -2,
                Saturation = -1,
            })
            :Play()
        game.Debris:AddItem(clone, 15)
        local clone_2 = planet_hotline.Link:Clone()
        local attachment = Instance.new("Attachment")
        attachment.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        local attachment2 = Instance.new("Attachment")
        attachment2.Parent = target.Character.HumanoidRootPart
        clone_2.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        clone_2.Attachment0 = attachment
        clone_2.Attachment1 = attachment2
        game.Debris:AddItem(clone_2, 15)
        game.Debris:AddItem(attachment, 15)
        game.Debris:AddItem(attachment2, 15)

        task.spawn(function()
            for index = 1, 20 do
                clone_2.Transparency = NumberSequence.new(1 - index * 0.05)
                task.wait(0.06125)
                local _ = index
            end
        end)
    end,

    EndPlanetHotline = function(argument)
        local link = game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Link")

        for _, child in pairs(game.Lighting:GetChildren()) do
            if child.Name == "PlanetHotline" then
                game:GetService("TweenService")
                    :Create(child, TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                        Brightness = 0,
                        Contrast = 0,
                        Saturation = 0,
                    })
                    :Play()

                task.delay(0.5, function()
                    child:Destroy()
                end)
            end
        end

        task.spawn(function()
            for index = 1, 20 do
                link.Transparency = NumberSequence.new(index * 0.05)
                task.wait(0.06125)
                local _ = index
            end

            link:Destroy()
        end)
    end,
}
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()

knit.GetService("KeyHandlerService"):GetKey("ClientFX").OnClientEvent:Connect(function(argument: table)
    local effect = argument.Effect

    if effect == nil then
        return
    end

    local success, result = pcall(fxFunctions[effect], argument)

    if success == false then
        warn("ClientFX threw exception: | " .. result .. " | when trying to execute " .. effect)
    end
end)
