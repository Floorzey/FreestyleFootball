local local_player = game.Players.LocalPlayer
repeat
    task.wait()
until local_player:FindFirstChild("dataLoaded")
local _ = game:GetService("RunService")
local ball_status = game.Workspace.ballStatus
local camera_shaker = require(game.ReplicatedStorage.Modules.CameraShaker)
local text = require("@game/ReplicatedStorage/Modules/DialogueModule")
local values = {}
values.N0tRady = true
values.AnhTuanPro123456 = true
values.rolevote = true
values.schansel = true
values.FluffyAstral = true
values.supermanjack2419 = true
values.max2847621 = true
values.Flxtraw = true
values["101extreme566"] = true
values.DaytonHD1 = true
values.denfertt = true
values.PatrickPepe_alt2 = true
values.zambrotta_z = true
values.ska5te = true
values.PAPAPATRATATA6 = true
values.noobieman_official = true
values.kaitoudono = true

local function tween_beam_transparency(argument, argument_2, tween_info, enabled)
    local number_value = Instance.new("NumberValue")
    number_value.Value = ((enabled ~= true) and 0.6) or 1
    local items = {}
    for n = 1, #argument_2.Keypoints do
        table.insert(items, n, argument_2.Keypoints[n])
    end
    number_value.Changed:Connect(function(argument_3)
        local items_2 = {}
        local value = nil
        for index, item in ipairs(items) do
            value = ((enabled == true) and (item.Value + argument_3)) or (item.Value * argument_3)
            if item.Value == 1 then
                value = 1
            end
            table.insert(items_2, index, NumberSequenceKeypoint.new(item.Time, value))
        end
        argument.Transparency = NumberSequence.new(items_2)
    end)
    local tween_properties = { Value = 0 }
    tween_properties.Value = ((enabled ~= true) and 1) or 0.6
    local tween = game.TweenService:Create(number_value, tween_info, tween_properties)
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
        local clone = game.ReplicatedStorage.SFX:FindFirstChild("Aura" .. tostring(math.random(1, 3))):Clone()
        clone.Parent = argument.TargetCharacter.HumanoidRootPart
        clone:Play()
        clone.Ended:Wait()
        clone:Destroy()
    end,
    Knuckling = function(mouse)
        local clone = script.Knuckling:Clone()
        clone.Parent = mouse.Target.PlayerGui.HUD.SkillCD
        task.delay(4.5, function()
            local tween_properties = { TextTransparency = 1, TextStrokeTransparency = 1 }
            game.TweenService:Create(clone, TweenInfo.new(0.5, Enum.EasingStyle.Linear), tween_properties):Play()
            task.wait(0.5)
            clone:Destroy()
        end)
    end,
    Heartbeat = function(argument)
        local time = argument.Time
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
            local tween = tween_service:Create(image_label, tween_info, { ImageTransparency = 0.6 })
            tween:Play()
            tween.Completed:Connect(function()
                tween_service:Create(image_label, tween_info_2, { ImageTransparency = 1 }):Play()
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
        local aura = argument.Aura
        if not aura then
            return
        end
        local instance = nil
        local value = nil
        local instance_2 = nil
        local value_2 = nil
        local instance_3 = nil
        local value_3 = nil
        local instance_4 = nil
        local instance_5 = nil
        local instance_6 = nil
        local value_4 = nil
        local value_5 = nil
        local value_6 = nil
        for _, child in pairs(aura:GetChildren()) do
            if child.Name == "Torso" then
                local clone = child:Clone()
                clone.Name = "Aura"
                clone.Parent = target_character.Torso
            end
            if child.Name == "Left Arm" then
                local clone_2 = child:Clone()
                clone_2.Name = "Aura"
                clone_2.Parent = target_character["Left Arm"]
            end
            if child.Name == "Left Leg" then
                local clone_3 = child:Clone()
                clone_3.Name = "Aura"
                clone_3.Parent = target_character["Left Leg"]
            end
            if child.Name == "Right Leg" then
                local clone_4 = child:Clone()
                clone_4.Name = "Aura"
                clone_4.Parent = target_character["Right Leg"]
            end
            if child.Name == "Right Arm" then
                local clone_5 = child:Clone()
                clone_5.Name = "Aura"
                clone_5.Parent = target_character["Right Arm"]
            end
            if child.Name == "Head" then
                local clone_6 = child:Clone()
                clone_6.Name = "Aura"
                clone_6.Parent = target_character.Head
            end
            for index, descendant in ipairs(child:GetDescendants()) do
                if descendant:IsA("Light") or descendant:IsA("Script") then
                    descendant:Destroy()
                end
            end
            if child.Name ~= "AttachmentHolder" then
                continue
            end
            for key, child_2 in pairs(child:GetChildren()) do
                if child_2.Name == "HRP" then
                    value_5 = child_2:Clone()
                    value_5.Name = "Aura"
                    value_5.Parent = target_character.HumanoidRootPart
                    if value_5:IsA("Part") and value_5:FindFirstChildOfClass("Weld") then
                        value_5:FindFirstChildOfClass("Weld").Part0 = target_character.HumanoidRootPart
                        game.Debris:AddItem(value_5, 1)
                    end
                    if aura.Name == "Flaming Wings" then
                        for index_2, descendant_2 in ipairs(value_5:GetDescendants()) do
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
                        for index_3, descendant_3 in ipairs(value_5:GetDescendants()) do
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
                        for index_4, descendant_4 in ipairs(value_5:GetDescendants()) do
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
                        for index_5, descendant_5 in ipairs(value_5:GetDescendants()) do
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
                    value_6 = value_5:FindFirstChildOfClass("Beam")
                    if not value_6 then
                        continue
                    end
                    if aura.Name ~= "Calculated Destruction" then
                        value_6.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.8),
                            NumberSequenceKeypoint.new(1, 0.8),
                        })
                    else
                        value_6.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.3),
                            NumberSequenceKeypoint.new(1, 0.3),
                        })
                    end
                elseif child_2.Name == "Head" then
                    instance_6 = child_2:Clone()
                    instance_6.Name = "Aura"
                    instance_6.Parent = target_character.Head
                    if instance_6:FindFirstChildOfClass("Weld") then
                        instance_6:FindFirstChildOfClass("Weld").Part0 = target_character.Head
                    end
                    if instance_6:GetAttribute("disband") then
                        task.spawn(function()
                            for _, value_7 in pairs(instance_6:GetChildren()) do
                                if value_7:IsA("Attachment") then
                                    task.spawn(function()
                                        for _, child_4 in pairs(value_7:GetChildren()) do
                                            child_4.Name = "Aura"
                                        end
                                    end)
                                else
                                    value_7.Name = "Aura"
                                end
                                value_7.Parent = target_character.Head
                            end
                            instance_6:Destroy()
                        end)
                    end
                    value_4 = instance_6:FindFirstChildOfClass("Beam")
                    if not value_4 then
                        continue
                    end
                    if aura.Name ~= "Monster" then
                        value_4.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.8),
                            NumberSequenceKeypoint.new(1, 0.8),
                        })
                    end
                elseif child_2.Name == "Torso" then
                    instance_5 = child_2:Clone()
                    instance_5.Name = "Aura"
                    instance_5.Parent = target_character.Torso
                    if instance_5:FindFirstChildOfClass("Weld") then
                        instance_5:FindFirstChildOfClass("Weld").Part0 = target_character.Torso
                    end
                    if instance_5:GetAttribute("disband") then
                        task.spawn(function()
                            for _, value_7 in pairs(instance_5:GetChildren()) do
                                if value_7:IsA("Attachment") then
                                    task.spawn(function()
                                        for _, child_4 in pairs(value_7:GetChildren()) do
                                            child_4.Name = "Aura"
                                        end
                                    end)
                                else
                                    value_7.Name = "Aura"
                                end
                                value_7.Parent = target_character.Torso
                            end
                            instance_5:Destroy()
                        end)
                    end
                    local beam = instance_5:FindFirstChildOfClass("Beam")
                    if aura.Name == "Flaming Wings" then
                        for index_6, descendant_6 in ipairs(instance_5:GetDescendants()) do
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
                        for index_7, descendant_7 in ipairs(instance_5:GetDescendants()) do
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
                        for index_8, descendant_8 in ipairs(instance_5:GetDescendants()) do
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
                    if beam then
                        beam.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.8),
                            NumberSequenceKeypoint.new(1, 0.8),
                        })
                    end
                elseif child_2.Name == "Left Arm" then
                    instance_4 = child_2:Clone()
                    instance_4.Name = "Aura"
                    instance_4.Parent = target_character["Left Arm"]
                    if instance_4:FindFirstChildOfClass("Weld") then
                        instance_4:FindFirstChildOfClass("Weld").Part0 = target_character["Left Arm"]
                    end
                    if instance_4:GetAttribute("disband") then
                        task.spawn(function()
                            for _, child_4 in pairs(instance_4:GetChildren()) do
                                child_4.Name = "Aura"
                                child_4.Parent = target_character["Left Arm"]
                            end
                            instance_4:Destroy()
                        end)
                    end
                    local beam_2 = instance_4:FindFirstChildOfClass("Beam")
                    if aura.Name == "Blue Rose" then
                        for index_9, descendant_9 in ipairs(instance_4:GetDescendants()) do
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
                    if beam_2 then
                        beam_2.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.8),
                            NumberSequenceKeypoint.new(1, 0.8),
                        })
                    end
                elseif child_2.Name == "Left Leg" then
                    instance_3 = child_2:Clone()
                    instance_3.Name = "Aura"
                    instance_3.Parent = target_character["Left Leg"]
                    if instance_3:FindFirstChildOfClass("Weld") then
                        instance_3:FindFirstChildOfClass("Weld").Part0 = target_character["Left Leg"]
                    end
                    if instance_3:GetAttribute("disband") then
                        task.spawn(function()
                            for _, value_7 in pairs(instance_3:GetChildren()) do
                                if value_7:IsA("Attachment") then
                                    task.spawn(function()
                                        for _, child_4 in pairs(value_7:GetChildren()) do
                                            child_4.Name = "Aura"
                                        end
                                    end)
                                else
                                    value_7.Name = "Aura"
                                end
                                value_7.Parent = target_character["Left Leg"]
                            end
                            instance_3:Destroy()
                        end)
                    end
                    value_3 = instance_3:FindFirstChildOfClass("Beam")
                    if not value_3 then
                        continue
                    end
                    if aura.Name ~= "Monster" then
                        value_3.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.8),
                            NumberSequenceKeypoint.new(1, 0.8),
                        })
                    end
                elseif child_2.Name == "Right Leg" then
                    instance_2 = child_2:Clone()
                    instance_2.Name = "Aura"
                    instance_2.Parent = target_character["Right Leg"]
                    if instance_2:FindFirstChildOfClass("Weld") then
                        game.Debris:AddItem(instance_2, 1)
                        instance_2:FindFirstChildOfClass("Weld").Part0 = target_character["Right Leg"]
                    end
                    if instance_2:GetAttribute("disband") then
                        task.spawn(function()
                            for _, value_7 in pairs(instance_2:GetChildren()) do
                                if value_7:IsA("Attachment") then
                                    task.spawn(function()
                                        for _, child_4 in pairs(value_7:GetChildren()) do
                                            child_4.Name = "Aura"
                                        end
                                    end)
                                else
                                    value_7.Name = "Aura"
                                end
                                value_7.Parent = target_character["Right Leg"]
                            end
                            instance_2:Destroy()
                        end)
                    end
                    value_2 = instance_2:FindFirstChildOfClass("Beam")
                    if not value_2 then
                        continue
                    end
                    if aura.Name ~= "Monster" then
                        value_2.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.8),
                            NumberSequenceKeypoint.new(1, 0.8),
                        })
                    end
                elseif child_2.Name == "Right Arm" then
                    instance = child_2:Clone()
                    instance.Name = "Aura"
                    instance.Parent = target_character["Right Arm"]
                    if instance:FindFirstChildOfClass("Weld") then
                        game.Debris:AddItem(instance, 1)
                        instance:FindFirstChildOfClass("Weld").Part0 = target_character["Right Arm"]
                    end
                    if instance:GetAttribute("disband") then
                        task.spawn(function()
                            for _, value_7 in pairs(instance:GetChildren()) do
                                if value_7:IsA("Attachment") then
                                    task.spawn(function()
                                        for _, child_4 in pairs(value_7:GetChildren()) do
                                            child_4.Name = "Aura"
                                        end
                                    end)
                                else
                                    value_7.Name = "Aura"
                                end
                                value_7.Parent = target_character["Right Arm"]
                            end
                            instance:Destroy()
                        end)
                    end
                    value = instance:FindFirstChildOfClass("Beam")
                    if not value then
                        continue
                    end
                    if aura.Name ~= "Monster" then
                        value.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.8),
                            NumberSequenceKeypoint.new(1, 0.8),
                        })
                    end
                end
            end
        end
        for _, parent in pairs(target_character:GetChildren()) do
            if
                parent.Name == "Right Arm"
                or parent.Name ~= "Right Arm" and parent.Name == "Left Arm"
                or parent.Name ~= "Right Arm" and parent.Name ~= "Left Arm" and parent.Name == "Left Leg"
                or parent.Name ~= "Right Arm" and parent.Name ~= "Left Arm" and parent.Name ~= "Left Leg" and parent.Name == "Right Leg"
                or parent.Name ~= "Right Arm" and parent.Name ~= "Left Arm" and parent.Name ~= "Left Leg" and parent.Name ~= "Right Leg" and parent.Name == "Head"
                or parent.Name ~= "Right Arm"
                    and parent.Name ~= "Left Arm"
                    and parent.Name ~= "Left Leg"
                    and parent.Name ~= "Right Leg"
                    and parent.Name ~= "Head"
                    and parent.Name == "Torso"
            then
                for key_2, child_3 in pairs(aura:GetChildren()) do
                    if not (child_3:IsA("ParticleEmitter")) or child_3.Name == "Torso" then
                        continue
                    end
                    local clone_7 = child_3:Clone()
                    clone_7.Name = "Aura"
                    clone_7.Parent = parent
                    clone_7.Rate = clone_7.Rate / 2
                    if aura.Name ~= "Monster" then
                        clone_7.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 1),
                            NumberSequenceKeypoint.new(0.5, 0.85),
                            NumberSequenceKeypoint.new(1, 1),
                        })
                    end
                end
            end
        end
        task.delay(1, function()
            for _, value_7 in pairs(target_character:GetDescendants()) do
                if value_7.Name == "HasAura" then
                    value_7:Destroy()
                end
                if value_7:IsA("Attachment") and value_7:FindFirstChildWhichIsA("Beam") then
                    for key_3, value_8 in pairs(value_7:GetDescendants()) do
                        if value_8:IsA("ParticleEmitter") then
                            task.spawn(function()
                                task.wait(1)
                                value_8.Enabled = false
                            end)
                            game.Debris:AddItem(value_7, 3)
                            continue
                        end
                        if value_8:IsA("Beam") then
                            task.spawn(function()
                                local number_value = Instance.new("NumberValue")
                                number_value.Parent = value_8
                                number_value.Value = 0.6
                                number_value.Changed:Connect(function(argument_2)
                                    value_8.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, argument_2),
                                        NumberSequenceKeypoint.new(1, argument_2),
                                    })
                                end)
                                local tween_properties = { Value = 1 }
                                local tween = game.TweenService:Create(number_value, TweenInfo.new(1), tween_properties)
                                tween:Play()
                                tween.Completed:Wait()
                                value_8.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 1),
                                    NumberSequenceKeypoint.new(1, 1),
                                })
                            end)
                        end
                        game.Debris:AddItem(value_7, 3)
                    end
                end
                if value_7.Name ~= "Aura" then
                    continue
                end
                if value_7:IsA("ParticleEmitter") then
                    task.spawn(function()
                        task.wait(1)
                        value_7.Enabled = false
                    end)
                end
                game.Debris:AddItem(value_7, 3)
            end
        end)
    end,
    BlueFlash = function(mouse)
        local highlight = Instance.new("Highlight")
        highlight.FillTransparency = 1
        highlight.FillColor = Color3.new(0.12549, 0.666667, 1)
        highlight.OutlineTransparency = 1
        highlight.OutlineColor = Color3.new(0.12549, 0.666667, 1)
        highlight.Parent = mouse.Target
        game.Debris:AddItem(highlight, 3)
        local tween_properties = { FillTransparency = 0, OutlineTransparency = 0 }
        game:GetService("TweenService")
            :Create(highlight, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tween_properties)
            :Play()
        task.delay(0.125, function()
            local tween_properties_2 = { FillTransparency = 1, OutlineTransparency = 1 }
            game:GetService("TweenService")
                :Create(
                    highlight,
                    TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
                    tween_properties_2
                )
                :Play()
        end)
    end,
    WhiteFlash = function(mouse)
        local highlight = Instance.new("Highlight")
        highlight.FillTransparency = 1
        highlight.FillColor = Color3.new(1, 1, 1)
        highlight.OutlineTransparency = 1
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.Parent = mouse.Target
        game.Debris:AddItem(highlight, 3)
        local tween_properties = { FillTransparency = 0, OutlineTransparency = 0 }
        game:GetService("TweenService")
            :Create(highlight, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tween_properties)
            :Play()
        task.delay(0.125, function()
            local tween_properties_2 = { FillTransparency = 1, OutlineTransparency = 1 }
            game:GetService("TweenService")
                :Create(
                    highlight,
                    TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
                    tween_properties_2
                )
                :Play()
        end)
    end,
    BlackFlash = function(mouse)
        local highlight = Instance.new("Highlight")
        highlight.FillTransparency = 1
        highlight.FillColor = Color3.new(0, 0, 0)
        highlight.OutlineTransparency = 1
        highlight.OutlineColor = Color3.new(0, 0, 0)
        highlight.Parent = mouse.Target
        game.Debris:AddItem(highlight, 3)
        local tween_properties = { FillTransparency = 0, OutlineTransparency = 0 }
        game:GetService("TweenService")
            :Create(highlight, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tween_properties)
            :Play()
        task.delay(0.125, function()
            local tween_properties_2 = { FillTransparency = 1, OutlineTransparency = 1 }
            game:GetService("TweenService")
                :Create(
                    highlight,
                    TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
                    tween_properties_2
                )
                :Play()
        end)
    end,
    BigShockwave = function(argument)
        local clone = game.ReplicatedStorage.VFX.Shockwave:Clone()
        clone.CFrame = argument.cframe
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
        if not values[mouse.name] then
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
        local weld_2 = Instance.new("Weld", part1_2)
        weld_2.Part0 = mouse.Target.HumanoidRootPart
        weld_2.Part1 = part1
        task.spawn(function()
            while part1 ~= nil do
                task.wait(0.025)
                local emoting = mouse.Target:FindFirstChild("Emoting", true)
                if not emoting then
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
                    if not (descendant:IsA("Attachment")) then
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
    ImpactShockwave = function(argument)
        local clone = game.ReplicatedStorage.VFX.ImpactTarget:Clone()
        clone.Parent = game.Workspace.FX
        clone.CFrame = argument.play.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, -argument.multi)
        clone.particleContainer.particle:Emit(1)
        game.Debris:AddItem(clone, 12)
        local clone_2 = game.ReplicatedStorage.VFX.ImpactShockwave:Clone()
        clone_2.CFrame = argument.cframe
        clone_2.Parent = game.Workspace.FX
        for _, child in pairs(clone_2.Attachment:GetChildren()) do
            child:Emit(child:GetAttribute("EmitCount"))
        end
        game.Debris:AddItem(clone_2, 3)
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
            local tween_properties = {}
            tween_properties.CFrame = clone.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)
            game.TweenService
                :Create(clone.HumanoidRootPart, TweenInfo.new(0.5, Enum.EasingStyle.Linear), tween_properties)
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
        local weld_2 = Instance.new("Weld", clone_4)
        weld_2.Part0 = target.HumanoidRootPart
        weld_2.Part1 = weld_2.Parent
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
            local tween_properties = { Saturation = -1 }
            game.TweenService
                :Create(color_correction_effect, TweenInfo.new(0.35, Enum.EasingStyle.Exponential), tween_properties)
                :Play()
            local camera_shaker_3 = camera_shaker.new(Enum.RenderPriority.Camera.Value, function(argument)
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * argument
            end)
            camera_shaker_3:Start()
            camera_shaker_3:Shake(camera_shaker.Presets.Timestop)
            local tween_properties_2 = {}
            tween_properties_2.CFrame = clone.HumanoidRootPart.CFrame * CFrame.new(0, -4, 0)
            local tween = game.TweenService:Create(
                clone.HumanoidRootPart,
                TweenInfo.new(1.25, Enum.EasingStyle.Linear),
                tween_properties_2
            )
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
                local tween_properties_3 = { Saturation = 0 }
                game.TweenService
                    :Create(color_correction_effect, TweenInfo.new(2, Enum.EasingStyle.Exponential), tween_properties_3)
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
        local clone = game.ReplicatedStorage.VFX.Formless:Clone()
        clone.CFrame = argument.cframe
        clone.Parent = game.Workspace.FX
        for _, child in pairs(clone.Attachment:GetChildren()) do
            child:Emit(child:GetAttribute("EmitCount"))
        end
        game.Debris:AddItem(clone, 3)
    end,
    SmallShockwave = function(argument)
        local clone = game.ReplicatedStorage.VFX.Shockwave:Clone()
        clone.CFrame = argument.cframe
        clone.Parent = game.Workspace.FX
        for _, item in pairs(clone.SmallShockwave:QueryDescendants("ParticleEmitter")) do
            item:Emit(item:GetAttribute("EmitCount"))
        end
        game.Debris:AddItem(clone, 2)
    end,
    Ripple = function(argument)
        local clone = game.ReplicatedStorage.VFX.Shockwave:Clone()
        clone.CFrame = argument.cframe
        clone.Parent = game.Workspace.FX
        for _, value in pairs(clone.Ripple:GetChildren()) do
            value:Emit(1)
            task.delay(0.35, function()
                value:Emit(1)
            end)
        end
        game.Debris:AddItem(clone, 2)
    end,
    Grasscutter = function(mouse)
        local clone = game.ReplicatedStorage.VFX.Grasscutter:FindFirstChild(mouse.side):Clone()
        clone.Parent = mouse.Target.HumanoidRootPart
        if local_player.Settings.Misc.SnowEnabled.Value == true then
            clone.CUTS.Color = ColorSequence.new(Color3.new(1, 1, 1))
        end
        clone.CUTS:Emit(25)
        game.Debris:AddItem(clone, 3)
    end,
    FakeShot = function(mouse)
        local clone = game.ReplicatedStorage.VFX.Shockwave.fakeShot:Clone()
        clone.Parent = mouse.Target.HumanoidRootPart
        for _, item in pairs(clone:QueryDescendants("ParticleEmitter")) do
            item:Emit(item:GetAttribute("EmitCount"))
        end
        game.Debris:AddItem(clone, 2)
    end,
    PinpointTrivelaTrail = function(argument)
        local ball = game.Workspace.Temp:FindFirstChild("Ball")
        if ball then
            ball.Trail.Attachment0 = nil
            local clone = game.ReplicatedStorage.VFX.PinpointTrivela.CurveTrail:Clone()
            clone.Parent = ball
            clone.Attachment0 = ball.Attachment0
            clone.Attachment1 = ball.Attachment1
            local clone_2 = game.ReplicatedStorage.VFX.PinpointTrivela.SMOKE:Clone()
            clone_2.Parent = ball
            local clone_3 = game.ReplicatedStorage.VFX.PinpointTrivela.SMOKE:Clone()
            clone_3.Parent = ball
            local connection_2 = nil
            local connection = ball_status.inAir.Changed:Connect(function()
                if ball_status.inAir.Value ~= false then
                    return
                end
                connection_2:Disconnect()
                clone_2.Enabled = false
                clone_3.Enabled = false
                clone.Enabled = false
            end)
            connection_2 = connection
            task.delay(argument.t or 0.5, function()
                ball.Trail.Attachment0 = ball.Attachment0
                connection_2:Disconnect()
                clone_3.Enabled = false
                clone_2.Enabled = false
                clone.Enabled = false
            end)
        end
    end,
    CurveTrail = function(argument)
        local ball = game.Workspace.Temp:FindFirstChild("Ball")
        if ball then
            ball.Trail.Attachment0 = nil
            local clone = game.ReplicatedStorage.VFX.CurveShots.CurveTrail:Clone()
            clone.Parent = ball
            clone.Attachment0 = ball.Attachment0
            clone.Attachment1 = ball.Attachment1
            local clone_2 = game.ReplicatedStorage.VFX.CurveShots.SMOKE:Clone()
            clone_2.Parent = ball
            local connection_2 = nil
            local connection = ball_status.inAir.Changed:Connect(function()
                if ball_status.inAir.Value ~= false then
                    return
                end
                connection_2:Disconnect()
                clone_2.Enabled = false
                clone.Enabled = false
            end)
            connection_2 = connection
            task.delay(argument.t or 0.5, function()
                ball.Trail.Attachment0 = ball.Attachment0
                connection_2:Disconnect()
                clone_2.Enabled = false
                clone.Enabled = false
            end)
        end
    end,
    Knuckleball = function(argument)
        local ball = game.Workspace.Temp:FindFirstChild("Ball")
        if not ball then
            return
        end
        ball.Trail.Attachment0 = nil
        task.delay(argument.t or 0.5, function()
            ball.Trail.Attachment0 = ball.Attachment0
        end)
    end,
    PowerShotTrail = function(argument)
        local ball = game.Workspace.Temp:FindFirstChild("Ball")
        if ball then
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
            task.delay(argument.t or 0.5, function()
                clone_2.CenterSpark.Enabled = false
                clone.Enabled = false
                clone_3.Enabled = false
            end)
        end
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
        local clone = game.ReplicatedStorage.VFX.Godspeed:Clone()
        clone.Parent = workspace.FX
        clone.CFrame = mouse.Target.HumanoidRootPart.CFrame
        game.Debris:AddItem(clone, 5)
        for _, descendant in pairs(clone:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                descendant:Emit(descendant:GetAttribute("EmitCount"))
            end
        end
    end,
    PlanetHotline = function(mouse)
        local planet_hotline = game.ReplicatedStorage.VFX.PlanetHotline
        local clone = planet_hotline.PlanetHotline:Clone()
        clone.Brightness = 0
        clone.Contrast = 0
        clone.Saturation = 0
        clone.Parent = game.Lighting
        local tween_properties = { Brightness = -0.1, Saturation = -1, Contrast = -2 }
        game:GetService("TweenService")
            :Create(clone, TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tween_properties)
            :Play()
        game.Debris:AddItem(clone, 15)
        local clone_2 = planet_hotline.Link:Clone()
        local attachment = Instance.new("Attachment")
        attachment.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        local attachment_2 = Instance.new("Attachment")
        attachment_2.Parent = mouse.Target.Character.HumanoidRootPart
        clone_2.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        clone_2.Attachment0 = attachment
        clone_2.Attachment1 = attachment_2
        game.Debris:AddItem(clone_2, 15)
        game.Debris:AddItem(attachment, 15)
        game.Debris:AddItem(attachment_2, 15)
        task.spawn(function()
            for n = 1, 20 do
                clone_2.Transparency = NumberSequence.new(1 - (n * 0.05))
                task.wait(0.06125)
            end
        end)
    end,
    EndPlanetHotline = function(argument)
        local link = game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Link")
        for _, value in pairs(game.Lighting:GetChildren()) do
            if value.Name == "PlanetHotline" then
                local tween_properties = { Brightness = 0, Saturation = 0, Contrast = 0 }
                game:GetService("TweenService")
                    :Create(
                        value,
                        TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                        tween_properties
                    )
                    :Play()
                task.delay(0.5, function()
                    value:Destroy()
                end)
            end
        end
        task.spawn(function()
            for n = 1, 20 do
                link.Transparency = NumberSequence.new(n * 0.05)
                task.wait(0.06125)
            end
            link:Destroy()
        end)
    end,
}
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
knit.GetService("KeyHandlerService"):GetKey("ClientFX").OnClientEvent:Connect(function(argument)
    local effect = argument.Effect
    if effect == nil then
        return
    end
    local success, value = pcall(fxFunctions[effect], argument)
    if success ~= false then
        return
    end
    warn("ClientFX threw exception: | " .. value .. " | when trying to execute " .. effect)
end)
