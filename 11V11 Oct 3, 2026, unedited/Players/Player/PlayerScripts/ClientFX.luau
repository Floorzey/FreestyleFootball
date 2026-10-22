--[[
    Script Path: Game/Players/Player/PlayerScripts/ClientFX
    Class: LocalScript
    Time: 2026-10-03 12:27:02
--]]

local LocalPlayer_upv_1 = game.Players.LocalPlayer
repeat
    task.wait()
until LocalPlayer_upv_1:FindFirstChild("dataLoaded")
local _ = game:GetService("RunService")
local ballStatus_upv_1 = game.Workspace.ballStatus
local CameraShaker_upv_1 = require(game.ReplicatedStorage.Modules.CameraShaker)
local v1 = require("@game/ReplicatedStorage/Modules/DialogueModule")
local tbl_upv_1 = {}
tbl_upv_1.N0tRady = true
tbl_upv_1.AnhTuanPro123456 = true
tbl_upv_1.rolevote = true
tbl_upv_1.schansel = true
tbl_upv_1.FluffyAstral = true
tbl_upv_1.supermanjack2419 = true
tbl_upv_1.max2847621 = true
tbl_upv_1.Flxtraw = true
tbl_upv_1["101extreme566"] = true
tbl_upv_1.DaytonHD1 = true
tbl_upv_1.denfertt = true
tbl_upv_1.PatrickPepe_alt2 = true
tbl_upv_1.zambrotta_z = true
tbl_upv_1.ska5te = true
tbl_upv_1.PAPAPATRATATA6 = true
tbl_upv_1.noobieman_official = true
tbl_upv_1.kaitoudono = true
local function tweenBeamTransparency(a1, a2, a3, a4)
    --[[
      name: tweenBeamTransparency
      line: 30
    ]]
    local u1 = Instance.new("NumberValue")
    u1.Value = ((a4 ~= true) and 0.6) or 1
    local tbl_upv_2 = {}
    for n_1 = 1, #a2.Keypoints do
        table.insert(tbl_upv_2, n_1, a2.Keypoints[n_1])
    end
    u1.Changed:Connect(
        function(a5)
            --[[
              line: 38
              upvalues:
                tbl_upv_2 (copy, index: 1)
                a4 (copy, index: 2)
                a1 (copy, index: 3)
            ]]
            local tbl_3 = {}
            local v1 = nil
            for key_1, value_1 in ipairs(tbl_upv_2) do
                v1 = ((a4 == true) and (value_1.Value + a5)) or (value_1.Value * a5)
                if value_1.Value == 1 then
                    v1 = 1
                end
                table.insert(tbl_3, key_1, NumberSequenceKeypoint.new(value_1.Time, v1))
            end
            a1.Transparency = NumberSequence.new(tbl_3)
        end
    )
    local tbl_4 = {Value = 0}
    tbl_4.Value = ((a4 ~= true) and 1) or 0.6
    local v2 = game.TweenService:Create(u1, a3, tbl_4)
    v2.Completed:Once(
        function()
            --[[
              line: 51
              upvalues:
                u1 (copy, index: 1)
            ]]
            u1:Destroy()
        end
    )
    v2:Play()
end
fxFunctions = {
    LocalAuraSound = (function(a1)
        --[[
          line: 59
          upvalues:
            LocalPlayer_upv_1 (copy, index: 1)
        ]]
        if not LocalPlayer_upv_1.Settings.Misc.AuraEffects.Value then
            return
        end
        local v3 = game.ReplicatedStorage.SFX:FindFirstChild("Aura" .. tostring(math.random(1, 3))):Clone()
        v3.Parent = a1.TargetCharacter.HumanoidRootPart
        v3:Play()
        v3.Ended:Wait()
        v3:Destroy()
    end),
    Knuckling = (function(a1)
        --[[
          line: 68
        ]]
        local u2 = script.Knuckling:Clone()
        u2.Parent = a1.Target.PlayerGui.HUD.SkillCD
        task.delay(
            4.5,
            function()
                --[[
                  line: 75
                  upvalues:
                    u2 (copy, index: 1)
                ]]
                local tbl_5 = {TextTransparency = 1, TextStrokeTransparency = 1}
                game.TweenService:Create(u2, TweenInfo.new(0.5, Enum.EasingStyle.Linear), tbl_5):Play()
                task.wait(0.5)
                u2:Destroy()
            end
        )
    end),
    Heartbeat = (function(a1)
        --[[
          line: 82
        ]]
        local Time_1 = a1.Time
        local TweenService_upv_1 = game:GetService("TweenService")
        local Screen_1 = game:GetService("Players").LocalPlayer.PlayerGui.Screen
        local u3 = Instance.new("ImageLabel")
        u3.Size = UDim2.fromScale(1, 1)
        u3.Position = UDim2.fromScale(0, 0)
        u3.BackgroundTransparency = 1
        u3.Image = "rbxassetid://82653864607159"
        u3.ImageColor3 = Color3.new(1)
        u3.ImageTransparency = 1
        u3.ScaleType = Enum.ScaleType.Stretch
        u3.Parent = Screen_1
        local u4 = TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local u5 = TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local function doPulse()
            --[[
              name: doPulse
              line: 110
              upvalues:
                TweenService_upv_1 (copy, index: 1)
                u3 (copy, index: 2)
                u4 (copy, index: 3)
                u5 (copy, index: 4)
            ]]
            local v4 = TweenService_upv_1:Create(u3, u4, {ImageTransparency = 0.6})
            v4:Play()
            v4.Completed:Connect(
                function()
                    --[[
                      line: 115
                      upvalues:
                        TweenService_upv_1 (copy, index: 1)
                        u3 (copy, index: 2)
                        u5 (copy, index: 3)
                    ]]
                    TweenService_upv_1:Create(u3, u5, {ImageTransparency = 1}):Play()
                end
            )
        end
        local v5 = 0
        local function doDoublePulse()
            --[[
              name: doDoublePulse
              line: 121
              upvalues:
                doPulse (copy, index: 1)
            ]]
            doPulse()
            local u6 = Instance.new("Sound", game.SoundService)
            u6.SoundId = "rbxassetid://133239214818347"
            u6:Play()
            u6.Volume = 0.3
            task.delay(
                2,
                function()
                    --[[
                      line: 129
                      upvalues:
                        u6 (copy, index: 1)
                    ]]
                    u6:Destroy()
                end
            )
            task.delay(0.15, doPulse)
        end
        while v5 < Time_1 do
            doDoublePulse()
            task.wait(0.8333333333333334)
            v5 = v5 + 0.8333333333333334
        end
    end),
    OverchargeTrail = (function(a1)
        --[[
          line: 143
        ]]
    end),
    AuraTrigger = (function(a1)
        --[[
          line: 176
          upvalues:
            LocalPlayer_upv_1 (copy, index: 1)
        ]]
        if not LocalPlayer_upv_1.Settings.Misc.AuraEffects.Value then
            return
        end
        local TargetCharacter_upv_1 = a1.TargetCharacter
        local Aura_1 = a1.Aura
        if not Aura_1 then
            return
        end
        local u7 = nil
        local v6 = nil
        local u8 = nil
        local v7 = nil
        local u9 = nil
        local v8 = nil
        local u10 = nil
        local u11 = nil
        local u12 = nil
        local v9 = nil
        local v10 = nil
        local v11 = nil
        for _, value_2 in pairs(Aura_1:GetChildren()) do
            if value_2.Name == "Torso" then
                local v12 = value_2:Clone()
                v12.Name = "Aura"
                v12.Parent = TargetCharacter_upv_1.Torso
            end
            if value_2.Name == "Left Arm" then
                local v13 = value_2:Clone()
                v13.Name = "Aura"
                v13.Parent = TargetCharacter_upv_1["Left Arm"]
            end
            if value_2.Name == "Left Leg" then
                local v14 = value_2:Clone()
                v14.Name = "Aura"
                v14.Parent = TargetCharacter_upv_1["Left Leg"]
            end
            if value_2.Name == "Right Leg" then
                local v15 = value_2:Clone()
                v15.Name = "Aura"
                v15.Parent = TargetCharacter_upv_1["Right Leg"]
            end
            if value_2.Name == "Right Arm" then
                local v16 = value_2:Clone()
                v16.Name = "Aura"
                v16.Parent = TargetCharacter_upv_1["Right Arm"]
            end
            if value_2.Name == "Head" then
                local v17 = value_2:Clone()
                v17.Name = "Aura"
                v17.Parent = TargetCharacter_upv_1.Head
            end
            for v21, value_3 in ipairs(value_2:GetDescendants()) do
                if value_3:IsA("Light") or value_3:IsA("Script") then
                    value_3:Destroy()
                end
            end
            if value_2.Name ~= "AttachmentHolder" then
                continue
            end
            for v22, value_4 in pairs(value_2:GetChildren()) do
                if value_4.Name == "HRP" then
                    v10 = value_4:Clone()
                    v10.Name = "Aura"
                    v10.Parent = TargetCharacter_upv_1.HumanoidRootPart
                    if v10:IsA("Part") and v10:FindFirstChildOfClass("Weld") then
                        v10:FindFirstChildOfClass("Weld").Part0 = TargetCharacter_upv_1.HumanoidRootPart
                        game.Debris:AddItem(v10, 1)
                    end
                    if Aura_1.Name == "Flaming Wings" then
                        for v23, value_5 in ipairs(v10:GetDescendants()) do
                            if value_5:IsA("ParticleEmitter") then
                                value_5.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.95), NumberSequenceKeypoint.new(1, 1)})
                                value_5.Rate = value_5.Rate / 2
                            end
                        end
                    elseif Aura_1.Name == "Blue Death" or Aura_1.Name == "Determination" then
                        for v24, value_6 in ipairs(v10:GetDescendants()) do
                            if value_6:IsA("ParticleEmitter") then
                                value_6.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.25, 0.95), NumberSequenceKeypoint.new(1, 1)})
                                value_6.Rate = value_6.Rate / 2
                            end
                        end
                    elseif Aura_1.Name == "A Certain Gambler" then
                        for v25, value_7 in ipairs(v10:GetDescendants()) do
                            if value_7:IsA("ParticleEmitter") then
                                value_7.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.259, 1), NumberSequenceKeypoint.new(0.26, 0.7), NumberSequenceKeypoint.new(0.76, 0.7), NumberSequenceKeypoint.new(1, 1)})
                                value_7.Rate = value_7.Rate / 2
                            end
                        end
                    elseif Aura_1.Name == "Sakura" then
                        for v26, value_8 in ipairs(v10:GetDescendants()) do
                            if value_8:IsA("ParticleEmitter") then
                                value_8.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.1), NumberSequenceKeypoint.new(0.85, 0.1), NumberSequenceKeypoint.new(1, 1)})
                                value_8.Rate = value_8.Rate / 2
                            end
                        end
                    end
                    v11 = v10:FindFirstChildOfClass("Beam")
                    if not (v11) then
                        continue
                    end
                    if Aura_1.Name ~= "Calculated Destruction" then
                        v11.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0.8)})
                    else
                        v11.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 0.3)})
                    end
                elseif value_4.Name == "Head" then
                    u12 = value_4:Clone()
                    u12.Name = "Aura"
                    u12.Parent = TargetCharacter_upv_1.Head
                    if u12:FindFirstChildOfClass("Weld") then
                        u12:FindFirstChildOfClass("Weld").Part0 = TargetCharacter_upv_1.Head
                    end
                    if u12:GetAttribute("disband") then
                        task.spawn(
                            function()
                                --[[
                                  line: 304
                                  upvalues:
                                    u12 (copy, index: 1)
                                    TargetCharacter_upv_1 (copy, index: 2)
                                ]]
                                for _, value_upv_9 in pairs(u12:GetChildren()) do
                                    if value_upv_9:IsA("Attachment") then
                                        task.spawn(
                                            function()
                                                --[[
                                                  line: 309
                                                  upvalues:
                                                    value_upv_9 (copy, index: 1)
                                                ]]
                                                for _, value_10 in pairs(value_upv_9:GetChildren()) do
                                                    value_10.Name = "Aura"
                                                end
                                            end
                                        )
                                    else
                                        value_upv_9.Name = "Aura"
                                    end
                                    value_upv_9.Parent = TargetCharacter_upv_1.Head
                                end
                                u12:Destroy()
                            end
                        )
                    end
                    v9 = u12:FindFirstChildOfClass("Beam")
                    if not (v9) then
                        continue
                    end
                    if Aura_1.Name ~= "Monster" then
                        v9.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0.8)})
                    end
                elseif value_4.Name == "Torso" then
                    u11 = value_4:Clone()
                    u11.Name = "Aura"
                    u11.Parent = TargetCharacter_upv_1.Torso
                    if u11:FindFirstChildOfClass("Weld") then
                        u11:FindFirstChildOfClass("Weld").Part0 = TargetCharacter_upv_1.Torso
                    end
                    if u11:GetAttribute("disband") then
                        task.spawn(
                            function()
                                --[[
                                  line: 335
                                  upvalues:
                                    u11 (copy, index: 1)
                                    TargetCharacter_upv_1 (copy, index: 2)
                                ]]
                                for _, value_upv_11 in pairs(u11:GetChildren()) do
                                    if value_upv_11:IsA("Attachment") then
                                        task.spawn(
                                            function()
                                                --[[
                                                  line: 340
                                                  upvalues:
                                                    value_upv_11 (copy, index: 1)
                                                ]]
                                                for _, value_12 in pairs(value_upv_11:GetChildren()) do
                                                    value_12.Name = "Aura"
                                                end
                                            end
                                        )
                                    else
                                        value_upv_11.Name = "Aura"
                                    end
                                    value_upv_11.Parent = TargetCharacter_upv_1.Torso
                                end
                                u11:Destroy()
                            end
                        )
                    end
                    local v18 = u11:FindFirstChildOfClass("Beam")
                    if Aura_1.Name == "Flaming Wings" then
                        for v27, value_13 in ipairs(u11:GetDescendants()) do
                            if value_13:IsA("ParticleEmitter") then
                                value_13.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.95), NumberSequenceKeypoint.new(1, 1)})
                                value_13.Rate = value_13.Rate / 2
                            end
                        end
                    elseif Aura_1.Name == "Godly" then
                        for v28, value_14 in ipairs(u11:GetDescendants()) do
                            if value_14:IsA("ParticleEmitter") then
                                value_14.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.9), NumberSequenceKeypoint.new(1, 1)})
                                value_14.Rate = value_14.Rate / 3
                            end
                        end
                    elseif Aura_1.Name == "Death" then
                        for v29, value_15 in ipairs(u11:GetDescendants()) do
                            if value_15:IsA("ParticleEmitter") then
                                value_15.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.8), NumberSequenceKeypoint.new(1, 1)})
                                value_15.Rate = value_15.Rate / 2
                            end
                        end
                    end
                    if v18 then
                        v18.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0.8)})
                    end
                elseif value_4.Name == "Left Arm" then
                    u10 = value_4:Clone()
                    u10.Name = "Aura"
                    u10.Parent = TargetCharacter_upv_1["Left Arm"]
                    if u10:FindFirstChildOfClass("Weld") then
                        u10:FindFirstChildOfClass("Weld").Part0 = TargetCharacter_upv_1["Left Arm"]
                    end
                    if u10:GetAttribute("disband") then
                        task.spawn(
                            function()
                                --[[
                                  line: 401
                                  upvalues:
                                    u10 (copy, index: 1)
                                    TargetCharacter_upv_1 (copy, index: 2)
                                ]]
                                for _, value_16 in pairs(u10:GetChildren()) do
                                    value_16.Name = "Aura"
                                    value_16.Parent = TargetCharacter_upv_1["Left Arm"]
                                end
                                u10:Destroy()
                            end
                        )
                    end
                    local v19 = u10:FindFirstChildOfClass("Beam")
                    if Aura_1.Name == "Blue Rose" then
                        for v30, value_17 in ipairs(u10:GetDescendants()) do
                            if value_17:IsA("ParticleEmitter") then
                                value_17.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.95), NumberSequenceKeypoint.new(1, 1)})
                                value_17.Rate = value_17.Rate / 2
                            end
                        end
                    end
                    if v19 then
                        v19.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0.8)})
                    end
                elseif value_4.Name == "Left Leg" then
                    u9 = value_4:Clone()
                    u9.Name = "Aura"
                    u9.Parent = TargetCharacter_upv_1["Left Leg"]
                    if u9:FindFirstChildOfClass("Weld") then
                        u9:FindFirstChildOfClass("Weld").Part0 = TargetCharacter_upv_1["Left Leg"]
                    end
                    if u9:GetAttribute("disband") then
                        task.spawn(
                            function()
                                --[[
                                  line: 437
                                  upvalues:
                                    u9 (copy, index: 1)
                                    TargetCharacter_upv_1 (copy, index: 2)
                                ]]
                                for _, value_upv_18 in pairs(u9:GetChildren()) do
                                    if value_upv_18:IsA("Attachment") then
                                        task.spawn(
                                            function()
                                                --[[
                                                  line: 442
                                                  upvalues:
                                                    value_upv_18 (copy, index: 1)
                                                ]]
                                                for _, value_19 in pairs(value_upv_18:GetChildren()) do
                                                    value_19.Name = "Aura"
                                                end
                                            end
                                        )
                                    else
                                        value_upv_18.Name = "Aura"
                                    end
                                    value_upv_18.Parent = TargetCharacter_upv_1["Left Leg"]
                                end
                                u9:Destroy()
                            end
                        )
                    end
                    v8 = u9:FindFirstChildOfClass("Beam")
                    if not (v8) then
                        continue
                    end
                    if Aura_1.Name ~= "Monster" then
                        v8.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0.8)})
                    end
                elseif value_4.Name == "Right Leg" then
                    u8 = value_4:Clone()
                    u8.Name = "Aura"
                    u8.Parent = TargetCharacter_upv_1["Right Leg"]
                    if u8:FindFirstChildOfClass("Weld") then
                        game.Debris:AddItem(u8, 1)
                        u8:FindFirstChildOfClass("Weld").Part0 = TargetCharacter_upv_1["Right Leg"]
                    end
                    if u8:GetAttribute("disband") then
                        task.spawn(
                            function()
                                --[[
                                  line: 469
                                  upvalues:
                                    u8 (copy, index: 1)
                                    TargetCharacter_upv_1 (copy, index: 2)
                                ]]
                                for _, value_upv_20 in pairs(u8:GetChildren()) do
                                    if value_upv_20:IsA("Attachment") then
                                        task.spawn(
                                            function()
                                                --[[
                                                  line: 474
                                                  upvalues:
                                                    value_upv_20 (copy, index: 1)
                                                ]]
                                                for _, value_21 in pairs(value_upv_20:GetChildren()) do
                                                    value_21.Name = "Aura"
                                                end
                                            end
                                        )
                                    else
                                        value_upv_20.Name = "Aura"
                                    end
                                    value_upv_20.Parent = TargetCharacter_upv_1["Right Leg"]
                                end
                                u8:Destroy()
                            end
                        )
                    end
                    v7 = u8:FindFirstChildOfClass("Beam")
                    if not (v7) then
                        continue
                    end
                    if Aura_1.Name ~= "Monster" then
                        v7.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0.8)})
                    end
                elseif value_4.Name == "Right Arm" then
                    u7 = value_4:Clone()
                    u7.Name = "Aura"
                    u7.Parent = TargetCharacter_upv_1["Right Arm"]
                    if u7:FindFirstChildOfClass("Weld") then
                        game.Debris:AddItem(u7, 1)
                        u7:FindFirstChildOfClass("Weld").Part0 = TargetCharacter_upv_1["Right Arm"]
                    end
                    if u7:GetAttribute("disband") then
                        task.spawn(
                            function()
                                --[[
                                  line: 501
                                  upvalues:
                                    u7 (copy, index: 1)
                                    TargetCharacter_upv_1 (copy, index: 2)
                                ]]
                                for _, value_upv_22 in pairs(u7:GetChildren()) do
                                    if value_upv_22:IsA("Attachment") then
                                        task.spawn(
                                            function()
                                                --[[
                                                  line: 506
                                                  upvalues:
                                                    value_upv_22 (copy, index: 1)
                                                ]]
                                                for _, value_23 in pairs(value_upv_22:GetChildren()) do
                                                    value_23.Name = "Aura"
                                                end
                                            end
                                        )
                                    else
                                        value_upv_22.Name = "Aura"
                                    end
                                    value_upv_22.Parent = TargetCharacter_upv_1["Right Arm"]
                                end
                                u7:Destroy()
                            end
                        )
                    end
                    v6 = u7:FindFirstChildOfClass("Beam")
                    if not (v6) then
                        continue
                    end
                    if Aura_1.Name ~= "Monster" then
                        v6.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0.8)})
                    end
                end
            end
        end
        for _, value_24 in pairs(TargetCharacter_upv_1:GetChildren()) do
            if value_24.Name == "Right Arm" or value_24.Name ~= "Right Arm" and value_24.Name == "Left Arm" or value_24.Name ~= "Right Arm" and value_24.Name ~= "Left Arm" and value_24.Name == "Left Leg" or value_24.Name ~= "Right Arm" and value_24.Name ~= "Left Arm" and value_24.Name ~= "Left Leg" and value_24.Name == "Right Leg" or value_24.Name ~= "Right Arm" and value_24.Name ~= "Left Arm" and value_24.Name ~= "Left Leg" and value_24.Name ~= "Right Leg" and value_24.Name == "Head"
                or value_24.Name ~= "Right Arm" and value_24.Name ~= "Left Arm" and value_24.Name ~= "Left Leg" and value_24.Name ~= "Right Leg" and value_24.Name ~= "Head" and value_24.Name == "Torso" then
                for v31, value_25 in pairs(Aura_1:GetChildren()) do
                    if not (value_25:IsA("ParticleEmitter")) or value_25.Name == "Torso" then
                        continue
                    end
                    local v20 = value_25:Clone()
                    v20.Name = "Aura"
                    v20.Parent = value_24
                    v20.Rate = v20.Rate / 2
                    if Aura_1.Name ~= "Monster" then
                        v20.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.85), NumberSequenceKeypoint.new(1, 1)})
                    end
                end
            end
        end
        task.delay(
            1,
            function()
                --[[
                  line: 547
                  upvalues:
                    TargetCharacter_upv_1 (copy, index: 1)
                ]]
                for _, value_upv_26 in pairs(TargetCharacter_upv_1:GetDescendants()) do
                    if value_upv_26.Name == "HasAura" then
                        value_upv_26:Destroy()
                    end
                    if value_upv_26:IsA("Attachment") and value_upv_26:FindFirstChildWhichIsA("Beam") then
                        for v1, value_upv_27 in pairs(value_upv_26:GetDescendants()) do
                            if value_upv_27:IsA("ParticleEmitter") then
                                task.spawn(
                                    function()
                                        --[[
                                          line: 555
                                          upvalues:
                                            value_upv_27 (copy, index: 1)
                                        ]]
                                        task.wait(1)
                                        value_upv_27.Enabled = false
                                    end
                                )
                                game.Debris:AddItem(value_upv_26, 3)
                                continue
                            end
                            if value_upv_27:IsA("Beam") then
                                task.spawn(
                                    function()
                                        --[[
                                          line: 560
                                          upvalues:
                                            value_upv_27 (copy, index: 1)
                                        ]]
                                        local v21 = Instance.new("NumberValue")
                                        v21.Parent = value_upv_27
                                        v21.Value = 0.6
                                        v21.Changed:Connect(
                                            function(a2)
                                                --[[
                                                  line: 565
                                                  upvalues:
                                                    value_upv_27 (copy, index: 1)
                                                ]]
                                                value_upv_27.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, a2), NumberSequenceKeypoint.new(1, a2)})
                                            end
                                        )
                                        local tbl_6 = {Value = 1}
                                        local v22 = game.TweenService:Create(v21, TweenInfo.new(1), tbl_6)
                                        v22:Play()
                                        v22.Completed:Wait()
                                        value_upv_27.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 1)})
                                    end
                                )
                            end
                            game.Debris:AddItem(value_upv_26, 3)
                        end
                    end
                    if value_upv_26.Name ~= "Aura" then
                        continue
                    end
                    if value_upv_26:IsA("ParticleEmitter") then
                        task.spawn(
                            function()
                                --[[
                                  line: 586
                                  upvalues:
                                    value_upv_26 (copy, index: 1)
                                ]]
                                task.wait(1)
                                value_upv_26.Enabled = false
                            end
                        )
                    end
                    game.Debris:AddItem(value_upv_26, 3)
                end
            end
        )
    end),
    BlueFlash = (function(a1)
        --[[
          line: 596
        ]]
        local u13 = Instance.new("Highlight")
        u13.FillTransparency = 1
        u13.FillColor = Color3.new(0.12549, 0.666667, 1)
        u13.OutlineTransparency = 1
        u13.OutlineColor = Color3.new(0.12549, 0.666667, 1)
        u13.Parent = a1.Target
        game.Debris:AddItem(u13, 3)
        local tbl_7 = {FillTransparency = 0, OutlineTransparency = 0}
        game:GetService("TweenService"):Create(u13, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tbl_7):Play()
        task.delay(
            0.125,
            function()
                --[[
                  line: 609
                  upvalues:
                    u13 (copy, index: 1)
                ]]
                local tbl_8 = {FillTransparency = 1, OutlineTransparency = 1}
                game:GetService("TweenService"):Create(u13, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.In), tbl_8):Play()
            end
        )
    end),
    WhiteFlash = (function(a1)
        --[[
          line: 616
        ]]
        local u14 = Instance.new("Highlight")
        u14.FillTransparency = 1
        u14.FillColor = Color3.new(1, 1, 1)
        u14.OutlineTransparency = 1
        u14.OutlineColor = Color3.new(1, 1, 1)
        u14.Parent = a1.Target
        game.Debris:AddItem(u14, 3)
        local tbl_9 = {FillTransparency = 0, OutlineTransparency = 0}
        game:GetService("TweenService"):Create(u14, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tbl_9):Play()
        task.delay(
            0.125,
            function()
                --[[
                  line: 629
                  upvalues:
                    u14 (copy, index: 1)
                ]]
                local tbl_10 = {FillTransparency = 1, OutlineTransparency = 1}
                game:GetService("TweenService"):Create(u14, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.In), tbl_10):Play()
            end
        )
    end),
    BlackFlash = (function(a1)
        --[[
          line: 636
        ]]
        local u15 = Instance.new("Highlight")
        u15.FillTransparency = 1
        u15.FillColor = Color3.new(0, 0, 0)
        u15.OutlineTransparency = 1
        u15.OutlineColor = Color3.new(0, 0, 0)
        u15.Parent = a1.Target
        game.Debris:AddItem(u15, 3)
        local tbl_11 = {FillTransparency = 0, OutlineTransparency = 0}
        game:GetService("TweenService"):Create(u15, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tbl_11):Play()
        task.delay(
            0.125,
            function()
                --[[
                  line: 649
                  upvalues:
                    u15 (copy, index: 1)
                ]]
                local tbl_12 = {FillTransparency = 1, OutlineTransparency = 1}
                game:GetService("TweenService"):Create(u15, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.In), tbl_12):Play()
            end
        )
    end),
    BigShockwave = (function(a1)
        --[[
          line: 656
        ]]
        local v23 = game.ReplicatedStorage.VFX.Shockwave:Clone()
        v23.CFrame = a1.cframe
        v23.Parent = game.Workspace.FX
        for _, value_28 in pairs(v23.Shockwave:QueryDescendants("ParticleEmitter")) do
            value_28:Emit(value_28:GetAttribute("EmitCount"))
        end
        game.Debris:AddItem(v23, 3)
    end),
    FakeSD = (function(a1)
        --[[
          line: 667
        ]]
        local v24 = game.ReplicatedStorage.VFX.FakeSD:Clone()
        v24.Parent = a1.Target.HumanoidRootPart
        v24:Emit(1)
        game.Debris:AddItem(v24, 2)
    end),
    CutInSD = (function(a1)
        --[[
          line: 678
        ]]
        local v25 = game.ReplicatedStorage.VFX.CutInSD:Clone()
        v25.Parent = a1.Target.HumanoidRootPart
        v25:Emit(1)
        game.Debris:AddItem(v25, 2)
    end),
    ShootSD = (function(a1)
        --[[
          line: 689
        ]]
        local v26 = game.ReplicatedStorage.VFX.ShootSD:Clone()
        v26.Parent = a1.Target.HumanoidRootPart
        v26:Emit(1)
        game.Debris:AddItem(v26, 2)
    end),
    ["Chosen Emperor"] = (function(a1)
        --[[
          line: 700
          upvalues:
            tbl_upv_1 (copy, index: 1)
        ]]
        if not tbl_upv_1[a1.name] then
            return
        end
        local v27 = game.ReplicatedStorage.VFX["Chosen Emperor"]
        local u16 = v27.Atmosphere:Clone()
        local u17 = v27.EmitPart:Clone()
        u17.Parent = workspace.FX
        u16.Parent = workspace.FX
        local v28 = Instance.new("Weld", u17)
        v28.Part0 = a1.Target.HumanoidRootPart
        v28.Part1 = u17
        local v29 = Instance.new("Weld", u17)
        v29.Part0 = a1.Target.HumanoidRootPart
        v29.Part1 = u16
        task.spawn(
            function()
                --[[
                  line: 720
                  upvalues:
                    u16 (ref,  index: 1)
                    a1 (copy, index: 2)
                    u17 (copy, index: 3)
                ]]
                while u16 ~= nil do
                    task.wait(0.025)
                    local v30 = a1.Target:FindFirstChild("Emoting", true)
                    if not (v30) then
                        u17:Destroy()
                        u16:Destroy()
                        u16 = nil
                    end
                end
            end
        )
        task.delay(
            0.6,
            function()
                --[[
                  line: 731
                  upvalues:
                    a1 (copy, index: 1)
                    u17 (copy, index: 2)
                ]]
                local u18 = game.ReplicatedStorage.SFX.diveLand1:Clone()
                u18.Parent = a1.Target
                u18:Play()
                u18.Ended:Connect(
                    function()
                        --[[
                          line: 735
                          upvalues:
                            u18 (copy, index: 1)
                        ]]
                        u18:Destroy()
                    end
                )
                for _, value_29 in pairs(u17.Emit:GetChildren()) do
                    if value_29:IsA("ParticleEmitter") then
                        value_29:Emit(value_29:GetAttribute("EmitCount"))
                    end
                end
            end
        )
        task.delay(
            1,
            function()
                --[[
                  line: 746
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                local u19 = Instance.new("Sound", a1.Target)
                u19.SoundId = "rbxassetid://112246815107129"
                u19:Play()
                u19.Ended:Connect(
                    function()
                        --[[
                          line: 750
                          upvalues:
                            u19 (copy, index: 1)
                        ]]
                        u19:Destroy()
                    end
                )
            end
        )
        task.delay(
            1.533,
            function()
                --[[
                  line: 755
                  upvalues:
                    u17 (copy, index: 1)
                    u16 (ref,  index: 2)
                ]]
                task.spawn(
                    function()
                        --[[
                          line: 756
                          upvalues:
                            u17 (copy, index: 1)
                        ]]
                        for _, value_30 in pairs(u17.Emit2:GetChildren()) do
                            if value_30:IsA("ParticleEmitter") then
                                value_30:Emit(value_30:GetAttribute("EmitCount"))
                            end
                        end
                    end
                )
                task.spawn(
                    function()
                        --[[
                          line: 765
                          upvalues:
                            u16 (ref, index: 1)
                        ]]
                        for _, value_31 in pairs(u16:GetDescendants()) do
                            if not (value_31:IsA("Attachment")) then
                                value_31.Enabled = true
                            end
                        end
                    end
                )
            end
        )
        task.delay(
            3,
            function()
                --[[
                  line: 778
                  upvalues:
                    u16 (ref,  index: 1)
                    u17 (copy, index: 2)
                ]]
                u16:Destroy()
                u17:Destroy()
            end
        )
    end),
    ImpactShockwave = (function(a1)
        --[[
          line: 784
        ]]
        local v31 = game.ReplicatedStorage.VFX.ImpactTarget:Clone()
        v31.Parent = game.Workspace.FX
        v31.CFrame = a1.play.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, -a1.multi)
        v31.particleContainer.particle:Emit(1)
        game.Debris:AddItem(v31, 12)
        local v32 = game.ReplicatedStorage.VFX.ImpactShockwave:Clone()
        v32.CFrame = a1.cframe
        v32.Parent = game.Workspace.FX
        for _, value_32 in pairs(v32.Attachment:GetChildren()) do
            value_32:Emit(value_32:GetAttribute("EmitCount"))
        end
        game.Debris:AddItem(v32, 3)
    end),
    Timestop = (function(a1)
        --[[
          line: 802
          upvalues:
            CameraShaker_upv_1 (copy, index: 1)
        ]]
        local Target_upv_1 = a1.Target
        local u20 = game.ReplicatedStorage.VFX.Timestop.Stand:Clone()
        u20.Parent = workspace.FX
        u20.AnimationController.Animator:LoadAnimation(u20.Timestop):Play()
        local v33 = CameraShaker_upv_1.new(
            Enum.RenderPriority.Camera.Value,
            function(a2)
                --[[
                  line: 808
                ]]
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * a2
            end
        )
        v33:Start()
        v33:Shake(CameraShaker_upv_1.Presets.Vibration)
        task.delay(
            0.2,
            function()
                --[[
                  line: 816
                  upvalues:
                    u20 (copy, index: 1)
                    Target_upv_1 (copy, index: 2)
                ]]
                u20:PivotTo(Target_upv_1.HumanoidRootPart.CFrame)
                local tbl_13 = {}
                tbl_13.CFrame = u20.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)
                game.TweenService:Create(u20.HumanoidRootPart, TweenInfo.new(0.5, Enum.EasingStyle.Linear), tbl_13):Play()
                task.spawn(
                    function()
                        --[[
                          line: 820
                          upvalues:
                            u20 (copy, index: 1)
                        ]]
                        for _, value_33 in u20:QueryDescendants("ParticleEmitter") do
                            value_33:Emit(value_33:GetAttribute("EmitCount"))
                        end
                    end
                )
            end
        )
        local u21 = game.ReplicatedStorage.VFX.Timestop.Actuate2:Clone()
        u21.Parent = Target_upv_1.HumanoidRootPart
        u21:Play()
        u21.Ended:Once(
            function()
                --[[
                  line: 832
                  upvalues:
                    u21 (copy, index: 1)
                ]]
                u21:Destroy()
            end
        )
        task.delay(
            0.06,
            function()
                --[[
                  line: 835
                  upvalues:
                    Target_upv_1 (copy, index: 1)
                ]]
                local u22 = game.ReplicatedStorage.VFX.Timestop.Actuate:Clone()
                u22.Parent = Target_upv_1.HumanoidRootPart
                u22:Play()
                u22.Ended:Once(
                    function()
                        --[[
                          line: 839
                          upvalues:
                            u22 (copy, index: 1)
                        ]]
                        u22:Destroy()
                    end
                )
            end
        )
        local u23 = game.ReplicatedStorage.VFX.Timestop.HeadVFX:Clone()
        u23.Parent = Target_upv_1
        local v34 = Instance.new("Weld", u23)
        v34.Part0 = Target_upv_1.Head
        v34.Part1 = v34.Parent
        local u24 = game.ReplicatedStorage.VFX.Timestop.RootVFX:Clone()
        u24.Parent = Target_upv_1
        local v35 = Instance.new("Weld", u24)
        v35.Part0 = Target_upv_1.HumanoidRootPart
        v35.Part1 = v35.Parent
        task.delay(
            0.5,
            function()
                --[[
                  line: 855
                  upvalues:
                    Target_upv_1 (copy, index: 1)
                ]]
                for _, value_34 in Target_upv_1:QueryDescendants("ParticleEmitter") do
                    if value_34.Name == "BlackUp" then
                        value_34:Emit(value_34:GetAttribute("EmitCount"))
                    end
                end
            end
        )
        task.delay(
            1,
            function()
                --[[
                  line: 863
                  upvalues:
                    Target_upv_1 (copy, index: 1)
                ]]
                local u25 = game.ReplicatedStorage.VFX.Timestop.Land:Clone()
                u25.Parent = Target_upv_1.HumanoidRootPart
                u25:Play()
                u25.Ended:Once(
                    function()
                        --[[
                          line: 867
                          upvalues:
                            u25 (copy, index: 1)
                        ]]
                        u25:Destroy()
                    end
                )
                for _, value_35 in Target_upv_1:QueryDescendants("ParticleEmitter") do
                    if value_35.Name == "exclamation" then
                        value_35:Emit(1)
                    end
                end
            end
        )
        task.delay(
            1.167,
            function()
                --[[
                  line: 878
                  upvalues:
                    CameraShaker_upv_1 (copy, index: 1)
                    u20 (copy, index: 2)
                    u23 (copy, index: 3)
                    u24 (copy, index: 4)
                    Target_upv_1 (copy, index: 5)
                ]]
                local u26 = Instance.new("ColorCorrectionEffect", game.Lighting)
                local tbl_14 = {Saturation = -1}
                game.TweenService:Create(u26, TweenInfo.new(0.35, Enum.EasingStyle.Exponential), tbl_14):Play()
                local v36 = CameraShaker_upv_1.new(
                    Enum.RenderPriority.Camera.Value,
                    function(a3)
                        --[[
                          line: 883
                        ]]
                        workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * a3
                    end
                )
                v36:Start()
                v36:Shake(CameraShaker_upv_1.Presets.Timestop)
                local tbl_15 = {}
                tbl_15.CFrame = u20.HumanoidRootPart.CFrame * CFrame.new(0, -4, 0)
                local v37 = game.TweenService:Create(u20.HumanoidRootPart, TweenInfo.new(1.25, Enum.EasingStyle.Linear), tbl_15)
                v37:Play()
                v37.Completed:Connect(
                    function()
                        --[[
                          line: 894
                          upvalues:
                            u20 (copy, index: 1)
                        ]]
                        u20:Destroy()
                    end
                )
                task.spawn(
                    function()
                        --[[
                          line: 897
                          upvalues:
                            u26 (copy, index: 1)
                            u23 (copy, index: 2)
                            u24 (copy, index: 3)
                        ]]
                        local u27 = true
                        task.delay(
                            7,
                            function()
                                --[[
                                  line: 900
                                  upvalues:
                                    u27 (ref, index: 1)
                                ]]
                                u27 = false
                            end
                        )
                        while u27 do
                            task.wait(1)
                            game.ReplicatedStorage.VFX.Timestop.Clock:Play()
                        end
                        local tbl_16 = {Saturation = 0}
                        game.TweenService:Create(u26, TweenInfo.new(2, Enum.EasingStyle.Exponential), tbl_16):Play()
                        task.delay(
                            2,
                            function()
                                --[[
                                  line: 909
                                  upvalues:
                                    u26 (copy, index: 1)
                                ]]
                                u26:Destroy()
                            end
                        )
                        u23:Destroy()
                        u24:Destroy()
                        game.ReplicatedStorage.VFX.Timestop.Resume:Play()
                    end
                )
                for _, value_36 in Target_upv_1:QueryDescendants("ParticleEmitter") do
                    if value_36.Name == "Mencaing" then
                        value_36:Emit(5)
                    end
                    if value_36.Name == "Clock" then
                        value_36:Emit(1)
                    end
                end
            end
        )
        task.delay(
            2.25,
            function()
                --[[
                  line: 927
                  upvalues:
                    Target_upv_1 (copy, index: 1)
                ]]
                local u28 = game.ReplicatedStorage.VFX.Timestop.VoiceAfter:Clone()
                u28.Parent = Target_upv_1.HumanoidRootPart
                u28:Play()
                u28.Ended:Once(
                    function()
                        --[[
                          line: 931
                          upvalues:
                            u28 (copy, index: 1)
                        ]]
                        u28:Destroy()
                    end
                )
            end
        )
    end),
    Formless = (function(a1)
        --[[
          line: 937
        ]]
        local v38 = game.ReplicatedStorage.VFX.Formless:Clone()
        v38.CFrame = a1.cframe
        v38.Parent = game.Workspace.FX
        for _, value_37 in pairs(v38.Attachment:GetChildren()) do
            value_37:Emit(value_37:GetAttribute("EmitCount"))
        end
        game.Debris:AddItem(v38, 3)
    end),
    SmallShockwave = (function(a1)
        --[[
          line: 949
        ]]
        local v39 = game.ReplicatedStorage.VFX.Shockwave:Clone()
        v39.CFrame = a1.cframe
        v39.Parent = game.Workspace.FX
        for _, value_38 in pairs(v39.SmallShockwave:QueryDescendants("ParticleEmitter")) do
            value_38:Emit(value_38:GetAttribute("EmitCount"))
        end
        game.Debris:AddItem(v39, 2)
    end),
    Ripple = (function(a1)
        --[[
          line: 960
        ]]
        local v40 = game.ReplicatedStorage.VFX.Shockwave:Clone()
        v40.CFrame = a1.cframe
        v40.Parent = game.Workspace.FX
        for _, value_upv_39 in pairs(v40.Ripple:GetChildren()) do
            value_upv_39:Emit(1)
            task.delay(
                0.35,
                function()
                    --[[
                      line: 968
                      upvalues:
                        value_upv_39 (copy, index: 1)
                    ]]
                    value_upv_39:Emit(1)
                end
            )
        end
        game.Debris:AddItem(v40, 2)
    end),
    Grasscutter = (function(a1)
        --[[
          line: 975
          upvalues:
            LocalPlayer_upv_1 (copy, index: 1)
        ]]
        local v41 = game.ReplicatedStorage.VFX.Grasscutter:FindFirstChild(a1.side):Clone()
        v41.Parent = a1.Target.HumanoidRootPart
        if LocalPlayer_upv_1.Settings.Misc.SnowEnabled.Value == true then
            v41.CUTS.Color = ColorSequence.new(Color3.new(1, 1, 1))
        end
        v41.CUTS:Emit(25)
        game.Debris:AddItem(v41, 3)
    end),
    FakeShot = (function(a1)
        --[[
          line: 986
        ]]
        local v42 = game.ReplicatedStorage.VFX.Shockwave.fakeShot:Clone()
        v42.Parent = a1.Target.HumanoidRootPart
        for _, value_40 in pairs(v42:QueryDescendants("ParticleEmitter")) do
            value_40:Emit(value_40:GetAttribute("EmitCount"))
        end
        game.Debris:AddItem(v42, 2)
    end),
    PinpointTrivelaTrail = (function(a1)
        --[[
          line: 995
          upvalues:
            ballStatus_upv_1 (copy, index: 1)
        ]]
        local Ball_upv_1 = game.Workspace.Temp:FindFirstChild("Ball")
        if Ball_upv_1 then
            Ball_upv_1.Trail.Attachment0 = nil
            local u29 = game.ReplicatedStorage.VFX.PinpointTrivela.CurveTrail:Clone()
            u29.Parent = Ball_upv_1
            u29.Attachment0 = Ball_upv_1.Attachment0
            u29.Attachment1 = Ball_upv_1.Attachment1
            local u30 = game.ReplicatedStorage.VFX.PinpointTrivela.SMOKE:Clone()
            u30.Parent = Ball_upv_1
            local u31 = game.ReplicatedStorage.VFX.PinpointTrivela.SMOKE:Clone()
            u31.Parent = Ball_upv_1
            local u32 = nil
            local v43 = ballStatus_upv_1.inAir.Changed:Connect(
                function()
                    --[[
                      line: 1008
                      upvalues:
                        ballStatus_upv_1 (copy, index: 1)
                        u32 (ref,  index: 2)
                        u30 (copy, index: 3)
                        u31 (copy, index: 4)
                        u29 (copy, index: 5)
                    ]]
                    if ballStatus_upv_1.inAir.Value ~= false then
                        return
                    end
                    u32:Disconnect()
                    u30.Enabled = false
                    u31.Enabled = false
                    u29.Enabled = false
                end
            )
            u32 = v43
            task.delay(
                a1.t or 0.5,
                function()
                    --[[
                      line: 1016
                      upvalues:
                        Ball_upv_1 (copy, index: 1)
                        u32 (ref,  index: 2)
                        u31 (copy, index: 3)
                        u30 (copy, index: 4)
                        u29 (copy, index: 5)
                    ]]
                    Ball_upv_1.Trail.Attachment0 = Ball_upv_1.Attachment0
                    u32:Disconnect()
                    u31.Enabled = false
                    u30.Enabled = false
                    u29.Enabled = false
                end
            )
        end
    end),
    CurveTrail = (function(a1)
        --[[
          line: 1025
          upvalues:
            ballStatus_upv_1 (copy, index: 1)
        ]]
        local Ball_upv_2 = game.Workspace.Temp:FindFirstChild("Ball")
        if Ball_upv_2 then
            Ball_upv_2.Trail.Attachment0 = nil
            local u33 = game.ReplicatedStorage.VFX.CurveShots.CurveTrail:Clone()
            u33.Parent = Ball_upv_2
            u33.Attachment0 = Ball_upv_2.Attachment0
            u33.Attachment1 = Ball_upv_2.Attachment1
            local u34 = game.ReplicatedStorage.VFX.CurveShots.SMOKE:Clone()
            u34.Parent = Ball_upv_2
            local u35 = nil
            local v44 = ballStatus_upv_1.inAir.Changed:Connect(
                function()
                    --[[
                      line: 1036
                      upvalues:
                        ballStatus_upv_1 (copy, index: 1)
                        u35 (ref,  index: 2)
                        u34 (copy, index: 3)
                        u33 (copy, index: 4)
                    ]]
                    if ballStatus_upv_1.inAir.Value ~= false then
                        return
                    end
                    u35:Disconnect()
                    u34.Enabled = false
                    u33.Enabled = false
                end
            )
            u35 = v44
            task.delay(
                a1.t or 0.5,
                function()
                    --[[
                      line: 1043
                      upvalues:
                        Ball_upv_2 (copy, index: 1)
                        u35 (ref,  index: 2)
                        u34 (copy, index: 3)
                        u33 (copy, index: 4)
                    ]]
                    Ball_upv_2.Trail.Attachment0 = Ball_upv_2.Attachment0
                    u35:Disconnect()
                    u34.Enabled = false
                    u33.Enabled = false
                end
            )
        end
    end),
    Knuckleball = (function(a1)
        --[[
          line: 1051
        ]]
        local Ball_upv_3 = game.Workspace.Temp:FindFirstChild("Ball")
        if not Ball_upv_3 then
            return
        end
        Ball_upv_3.Trail.Attachment0 = nil
        task.delay(
            a1.t or 0.5,
            function()
                --[[
                  line: 1056
                  upvalues:
                    Ball_upv_3 (copy, index: 1)
                ]]
                Ball_upv_3.Trail.Attachment0 = Ball_upv_3.Attachment0
            end
        )
    end),
    PowerShotTrail = (function(a1)
        --[[
          line: 1061
        ]]
        local Ball_4 = game.Workspace.Temp:FindFirstChild("Ball")
        if Ball_4 then
            local PowerShotTrail_1 = game.ReplicatedStorage.VFX.PowerShotTrail
            local u36 = PowerShotTrail_1.PowerTrail:Clone()
            u36.Parent = Ball_4
            local v45 = PowerShotTrail_1.Attachment0:Clone()
            v45.Parent = Ball_4
            local v46 = PowerShotTrail_1.Attachment1:Clone()
            v46.Parent = Ball_4
            u36.Attachment0 = v45
            u36.Attachment1 = v46
            local u37 = PowerShotTrail_1.Attachment:Clone()
            u37.Parent = Ball_4
            local u38 = PowerShotTrail_1.SPECKS:Clone()
            u38.Parent = Ball_4
            task.delay(
                0.1,
                function()
                    --[[
                      line: 1078
                      upvalues:
                        u38 (copy, index: 1)
                    ]]
                    u38.Enabled = true
                end
            )
            task.delay(
                a1.t or 0.5,
                function()
                    --[[
                      line: 1081
                      upvalues:
                        u37 (copy, index: 1)
                        u36 (copy, index: 2)
                        u38 (copy, index: 3)
                    ]]
                    u37.CenterSpark.Enabled = false
                    u36.Enabled = false
                    u38.Enabled = false
                end
            )
        end
    end),
    ExplosiveBurst = (function(a1)
        --[[
          line: 1088
        ]]
        local Target_2 = a1.Target
        local v47 = game.ReplicatedStorage.VFX.SPDash.Shockwave1:Clone()
        v47.Parent = Target_2.HumanoidRootPart
        v47.CenterSpark:Emit(2)
        game.Debris:AddItem(v47, 3)
        local v48 = game.ReplicatedStorage.VFX.SPDash.Shockwave2:Clone()
        v48.Parent = Target_2.HumanoidRootPart
        v48.CenterSpark:Emit(2)
        game.Debris:AddItem(v48, 3)
        local v49 = game.ReplicatedStorage.VFX.SPDash.Strike:Clone()
        v49.Parent = Target_2.HumanoidRootPart
        v49.STRIKES:Emit(3)
        game.Debris:AddItem(v47, 3)
        local v50 = game.ReplicatedStorage.VFX.SPDash.Attachment0:Clone()
        v50.Parent = Target_2.Torso
        local v51 = game.ReplicatedStorage.VFX.SPDash.Attachment1:Clone()
        v51.Parent = Target_2.Torso
        local u39 = game.ReplicatedStorage.VFX.SPDash.Trail:Clone()
        u39.Parent = Target_2.Torso
        u39.Attachment0 = v50
        u39.Attachment1 = v51
        u39.Enabled = true
        game.Debris:AddItem(v50, 3)
        game.Debris:AddItem(v51, 3)
        game.Debris:AddItem(u39, 3)
        task.delay(
            0.25,
            function()
                --[[
                  line: 1114
                  upvalues:
                    u39 (copy, index: 1)
                ]]
                u39.Enabled = false
            end
        )
    end),
    Godspeed = (function(a1)
        --[[
          line: 1118
        ]]
        local v52 = game.ReplicatedStorage.VFX.Godspeed:Clone()
        v52.Parent = workspace.FX
        v52.CFrame = a1.Target.HumanoidRootPart.CFrame
        game.Debris:AddItem(v52, 5)
        for _, value_41 in pairs(v52:GetDescendants()) do
            if value_41:IsA("ParticleEmitter") then
                value_41:Emit(value_41:GetAttribute("EmitCount"))
            end
        end
    end),
    PlanetHotline = (function(a1)
        --[[
          line: 1132
        ]]
        local PlanetHotline_1 = game.ReplicatedStorage.VFX.PlanetHotline
        local v53 = PlanetHotline_1.PlanetHotline:Clone()
        v53.Brightness = 0
        v53.Contrast = 0
        v53.Saturation = 0
        v53.Parent = game.Lighting
        local tbl_17 = {Brightness = -0.1, Saturation = -1, Contrast = -2}
        game:GetService("TweenService"):Create(v53, TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tbl_17):Play()
        game.Debris:AddItem(v53, 15)
        local u40 = PlanetHotline_1.Link:Clone()
        local v54 = Instance.new("Attachment")
        v54.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        local v55 = Instance.new("Attachment")
        v55.Parent = a1.Target.Character.HumanoidRootPart
        u40.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        u40.Attachment0 = v54
        u40.Attachment1 = v55
        game.Debris:AddItem(u40, 15)
        game.Debris:AddItem(v54, 15)
        game.Debris:AddItem(v55, 15)
        task.spawn(
            function()
                --[[
                  line: 1157
                  upvalues:
                    u40 (copy, index: 1)
                ]]
                for n_2 = 1, 20 do
                    u40.Transparency = NumberSequence.new(1 - (n_2 * 0.05))
                    task.wait(0.06125)
                end
            end
        )
    end),
    EndPlanetHotline = (function(a1)
        --[[
          line: 1164
        ]]
        local Link_upv_1 = game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Link")
        for _, value_upv_42 in pairs(game.Lighting:GetChildren()) do
            if value_upv_42.Name == "PlanetHotline" then
                local tbl_18 = {Brightness = 0, Saturation = 0, Contrast = 0}
                game:GetService("TweenService"):Create(value_upv_42, TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tbl_18):Play()
                task.delay(
                    0.5,
                    function()
                        --[[
                          line: 1173
                          upvalues:
                            value_upv_42 (copy, index: 1)
                        ]]
                        value_upv_42:Destroy()
                    end
                )
            end
        end
        task.spawn(
            function()
                --[[
                  line: 1178
                  upvalues:
                    Link_upv_1 (copy, index: 1)
                ]]
                for n_3 = 1, 20 do
                    Link_upv_1.Transparency = NumberSequence.new(n_3 * 0.05)
                    task.wait(0.06125)
                end
                Link_upv_1:Destroy()
            end
        )
    end)
}
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
Knit_1.GetService("KeyHandlerService"):GetKey("ClientFX").OnClientEvent:Connect(
    function(a1)
        --[[
          line: 1199
        ]]
        local Effect_1 = a1.Effect
        if Effect_1 == nil then
            return
        end
        local success_1, v56 = pcall(fxFunctions[Effect_1], a1)
        if success_1 ~= false then
            return
        end
        warn("ClientFX threw exception: | " .. v56 .. " | when trying to execute " .. Effect_1)
    end
)