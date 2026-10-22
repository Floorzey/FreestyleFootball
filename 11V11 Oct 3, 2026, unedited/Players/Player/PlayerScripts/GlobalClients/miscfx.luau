--[[
    Script Path: Game/Players/Player/PlayerScripts/GlobalClients/miscfx
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

local ballStatus_upv_1 = game.Workspace.ballStatus
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local v1 = Knit_1.GetService("KeyHandlerService")
v1:GetKey("SharpEyesClient").OnClientEvent:Connect(
    function()
        --[[
          line: 9
          upvalues:
            ballStatus_upv_1 (copy, index: 1)
        ]]
        local TweenService_1 = game:GetService("TweenService")
        local v2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_1 = {}
        tbl_1.TintColor = Color3.fromRGB(243, 171, 172)
        TweenService_1:Create(game.Lighting.ColorCorrection, v2, tbl_1):Play()
        local u1 = game.Workspace.Temp:FindFirstChild("Ball") or (game.Workspace.Temp:WaitForChild("Ball"))
        if u1 then
            local v3 = Instance.new("Highlight")
            v3.Parent = u1
            v3.Name = "SharpEyeHighlight"
            v3.FillColor = Color3.new(0.839216, 0, 0)
            v3.OutlineTransparency = 1
            v3.FillTransparency = 1
            local tbl_2 = {FillTransparency = 0}
            game:GetService("TweenService"):Create(v3, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_2):Play()
            local v4 = game:GetService("RunService").RenderStepped:Connect(
                function()
                    --[[
                      line: 24
                      upvalues:
                        u1 (copy, index: 1)
                    ]]
                    if not game.Workspace.Temp:FindFirstChild("Ball") then
                        return
                    end
                    if not (game.Workspace.Temp.Ball:FindFirstChild("SharpEyeHighlight")) then
                        local v5 = Instance.new("Highlight")
                        v5.Parent = u1
                        v5.Name = "SharpEyeHighlight"
                        v5.FillColor = Color3.new(0.839216, 0, 0)
                        v5.OutlineTransparency = 1
                        v5.FillTransparency = 1
                        local tbl_3 = {FillTransparency = 0}
                        game:GetService("TweenService"):Create(v5, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_3):Play()
                    end
                end
            )
            local u2 = v4
            local v6 = ballStatus_upv_1.lastKicked.Changed:Connect(
                function()
                    --[[
                      line: 37
                      upvalues:
                        ballStatus_upv_1 (copy, index: 1)
                    ]]
                    if ballStatus_upv_1.lastKicked.Value == nil then
                        return
                    end
                    for _, value_1 in pairs(game.Workspace.CharacterContainer:GetChildren()) do
                        for v9, value_2 in pairs(value_1:GetChildren()) do
                            if value_2.Name == "SharpEyeHighlight" then
                                value_2:Destroy()
                            end
                        end
                    end
                    local v7 = Color3.new(0.839216, 0.486275, 0.486275)
                    if ballStatus_upv_1.lastKicked.Value.SelectedTeam.Value == game.Players.LocalPlayer.SelectedTeam.Value then
                        v7 = Color3.new(0, 1, 0)
                    end
                    local v8 = Instance.new("Highlight")
                    v8.Parent = ballStatus_upv_1.lastKicked.Value.Character
                    v8.Name = "SharpEyeHighlight"
                    v8.FillColor = v7
                    v8.OutlineTransparency = 1
                    v8.FillTransparency = 1
                    local tbl_4 = {FillTransparency = 0}
                    game:GetService("TweenService"):Create(v8, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_4):Play()
                end
            )
            local u3 = v6
            task.delay(
                10,
                function()
                    --[[
                      line: 62
                      upvalues:
                        u2 (ref, index: 1)
                        u3 (ref, index: 2)
                    ]]
                    u2:Disconnect()
                    u3:Disconnect()
                    if game.Workspace.Temp:FindFirstChild("Ball") then
                        for _, value_3 in pairs(game.Workspace.Temp.Ball:GetChildren()) do
                            if not (value_3:IsA("Highlight")) then
                                continue
                            end
                            if value_3.Name == "SharpEyeHighlight" then
                                local tbl_5 = {FillTransparency = 1}
                                game:GetService("TweenService"):Create(value_3, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_5):Play()
                                game.Debris:AddItem(value_3, 2)
                            end
                        end
                    end
                    for _, value_4 in pairs(game.Workspace.CharacterContainer:GetChildren()) do
                        for v10, value_5 in pairs(value_4:GetChildren()) do
                            if value_5.Name == "SharpEyeHighlight" then
                                value_5:Destroy()
                            end
                        end
                    end
                    local TweenService_2 = game:GetService("TweenService")
                    local v9 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tbl_6 = {}
                    tbl_6.TintColor = Color3.new(1, 1, 1)
                    TweenService_2:Create(game.Lighting.ColorCorrection, v9, tbl_6):Play()
                end
            )
        end
    end
)
v1:GetKey("ScoreSFXClient").OnClientEvent:Connect(
    function()
        --[[
          line: 89
        ]]
        if game.Players.LocalPlayer.Settings.Misc.CrowdNoise.Value == false then
            return
        end
        for _, value_6 in pairs(game.Workspace.miscFX:GetChildren()) do
            if value_6.Name == "CameraFlash" then
                local u4 = value_6["ScoreSFX" .. math.random(1, 3)]
                u4.Volume = 0
                u4:Play()
                local tbl_7 = {Volume = 2}
                game:GetService("TweenService"):Create(u4, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_7):Play()
                task.delay(
                    8,
                    function()
                        --[[
                          line: 99
                          upvalues:
                            u4 (copy, index: 1)
                        ]]
                        local tbl_8 = {Volume = 0}
                        game:GetService("TweenService"):Create(u4, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_8):Play()
                        task.wait(0.5)
                        u4:Stop()
                        u4.Volume = u4:GetAttribute("Volume")
                    end
                )
            end
        end
    end
)
v1:GetKey("GameEndSFXClient").OnClientEvent:Connect(
    function()
        --[[
          line: 111
        ]]
        if game.Players.LocalPlayer.Settings.Misc.CrowdNoise.Value == false then
            return
        end
        for _, value_7 in pairs(game.Workspace.miscFX:GetChildren()) do
            if value_7.Name == "CameraFlash" then
                local u5 = value_7["gameEndCrowd" .. math.random(1, 2)]
                u5.Volume = 0
                u5:Play()
                local tbl_9 = {Volume = 2}
                game:GetService("TweenService"):Create(u5, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_9):Play()
                task.delay(
                    24.2,
                    function()
                        --[[
                          line: 122
                          upvalues:
                            u5 (copy, index: 1)
                        ]]
                        local tbl_10 = {Volume = 0}
                        game:GetService("TweenService"):Create(u5, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_10):Play()
                        task.wait(0.5)
                        u5:Stop()
                        u5.Volume = u5:GetAttribute("Volume")
                    end
                )
            end
        end
    end
)
v1:GetKey("FailSFXClient").OnClientEvent:Connect(
    function(a1)
        --[[
          line: 135
        ]]
        if game.Players.LocalPlayer.Settings.Misc.CrowdNoise.Value == false then
            return
        end
        for _, value_8 in pairs(game.Workspace.miscFX:GetChildren()) do
            if value_8.Name == "CameraFlash" then
                local u6 = value_8["FailSFX" .. math.random(1, 3)]
                u6.Volume = 0
                u6:Play()
                local tbl_11 = {Volume = 2}
                game:GetService("TweenService"):Create(u6, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_11):Play()
                task.delay(
                    a1,
                    function()
                        --[[
                          line: 145
                          upvalues:
                            u6 (copy, index: 1)
                        ]]
                        local tbl_12 = {Volume = 0}
                        game:GetService("TweenService"):Create(u6, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_12):Play()
                        task.wait(0.5)
                        u6:Stop()
                        u6.Volume = u6:GetAttribute("Volume")
                    end
                )
            end
        end
    end
)
local LocalPlayer_upv_1 = game.Players.LocalPlayer
LocalPlayer_upv_1:WaitForChild("dataLoaded")
local function getMostOrLeastZ(a1, a2)
    --[[
      name: getMostOrLeastZ
      line: 164
    ]]
    if a2 ~= true then
        local v10 = 15.807
        local v11 = nil
        for _, value_9 in ipairs(a1) do
            if not (value_9.Character) then
                continue
            end
            if value_9.Character.HumanoidRootPart.Position.Z < v10 then
                v10, v11 = value_9.Character.HumanoidRootPart.Position.Z, value_9
            end
        end
        return v11
    else
        local v12 = 15.807
        local v13 = nil
        v13 = v13
        for _, value_10 in ipairs(a1) do
            if not (value_10.Character) then
                continue
            end
            if v12 < value_10.Character.HumanoidRootPart.Position.Z then
                v12, v13 = value_10.Character.HumanoidRootPart.Position.Z, value_10
            end
        end
        return v13
    end
end
ballStatus_upv_1.lastKicked.Changed:Connect(
    function()
        --[[
          line: 186
          upvalues:
            ballStatus_upv_1 (copy, index: 1)
            LocalPlayer_upv_1 (copy, index: 2)
        ]]
        if ballStatus_upv_1.lastKicked.Value ~= LocalPlayer_upv_1 then
            local Ball_1 = game.Workspace.Temp:FindFirstChild("Ball")
            if Ball_1 then
                for _, value_11 in pairs(Ball_1:GetChildren()) do
                    if value_11.Name == "PossessionHighlight" then
                        value_11:Destroy()
                    end
                end
            end
            for _, value_12 in pairs(game.Players:GetPlayers()) do
                if value_12.Character == nil then
                    continue
                end
                if value_12.Character:FindFirstChild("TeammateHighlight") or not value_12.Character:FindFirstChild("TeammateHighlight") and (value_12.Character:FindFirstChild("OffsideHighlight")) then
                    for v25, value_13 in pairs(value_12.Character:GetChildren()) do
                        if value_13.Name == "TeammateHighlight" then
                            value_13:Destroy()
                        end
                        if value_13.Name == "OffsideHighlight" then
                            value_13:Destroy()
                        end
                    end
                end
            end
        else
            local Ball_upv_2
            if LocalPlayer_upv_1.Settings.Misc.Highlights.Value ~= true then
                local Ball_1 = game.Workspace.Temp:FindFirstChild("Ball")
                if Ball_1 then
                    for _, value_11 in pairs(Ball_1:GetChildren()) do
                        if value_11.Name == "PossessionHighlight" then
                            value_11:Destroy()
                        end
                    end
                end
                for _, value_12 in pairs(game.Players:GetPlayers()) do
                    if value_12.Character == nil then
                        continue
                    end
                    if value_12.Character:FindFirstChild("TeammateHighlight") or not value_12.Character:FindFirstChild("TeammateHighlight") and (value_12.Character:FindFirstChild("OffsideHighlight")) then
                        for v25, value_13 in pairs(value_12.Character:GetChildren()) do
                            if value_13.Name == "TeammateHighlight" then
                                value_13:Destroy()
                            end
                            if value_13.Name == "OffsideHighlight" then
                                value_13:Destroy()
                            end
                        end
                    end
                end
            else
                Ball_upv_2 = game.Workspace.Temp:FindFirstChild("Ball")
                if Ball_upv_2 then
                    local v14 = Instance.new("Highlight")
                    v14.Name = "PossessionHighlight"
                    v14.Parent = Ball_upv_2
                    v14.OutlineColor = Color3.new(1, 1, 1)
                    v14.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    v14.OutlineTransparency = 1
                    v14.FillTransparency = 1
                    local tbl_13 = {OutlineTransparency = 0}
                    game:GetService("TweenService"):Create(v14, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_13):Play()
                end
                for _, value_14 in pairs(game.Players:GetPlayers()) do
                    if not (value_14:FindFirstChild("dataLoaded")) or value_14.SelectedTeam.Value ~= LocalPlayer_upv_1.SelectedTeam.Value then
                        continue
                    end
                    if value_14 ~= LocalPlayer_upv_1 then
                        local v15 = Instance.new("Highlight")
                        v15.Name = "TeammateHighlight"
                        v15.Parent = value_14.Character
                        v15.OutlineColor = Color3.new(0, 1, 0)
                        v15.DepthMode = Enum.HighlightDepthMode.Occluded
                        v15.OutlineTransparency = 0.6
                        v15.FillTransparency = 1
                        local tbl_14 = {OutlineTransparency = 0}
                        game:GetService("TweenService"):Create(v15, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_14):Play()
                    end
                end
                local u7 = nil
                local v16 = game:GetService("RunService").RenderStepped:Connect(
                    function()
                        --[[
                          line: 216
                          upvalues:
                            ballStatus_upv_1 (copy, index: 1)
                            LocalPlayer_upv_1 (copy, index: 2)
                            u7 (ref,  index: 3)
                            Ball_upv_2 (copy, index: 4)
                        ]]
                        if ballStatus_upv_1.lastKicked.Value == LocalPlayer_upv_1 then
                            if LocalPlayer_upv_1.SelectedTeam.Value ~= "Home" then
                                local v17 = nil
                                if LocalPlayer_upv_1.SelectedTeam.Value == "Away" then
                                    local tbl_15 = {}
                                    for _, value_15 in pairs(game.Players:GetPlayers()) do
                                        if value_15.SelectedPosition.Value == "GK" or not (value_15:FindFirstChild("InPlay")) then
                                            continue
                                        end
                                        if value_15.SelectedTeam.Value ~= LocalPlayer_upv_1.SelectedTeam.Value then
                                            table.insert(tbl_15, value_15)
                                        end
                                    end
                                    local v18 = 15.807
                                    v17 = nil
                                    local v19 = v18
                                    for _, value_16 in ipairs(tbl_15) do
                                        if not (value_16.Character) then
                                            continue
                                        end
                                        if value_16.Character.HumanoidRootPart.Position.Z < v19 then
                                            v19, v17 = value_16.Character.HumanoidRootPart.Position.Z, value_16
                                        end
                                    end
                                    if v17 and not (v17.Character:FindFirstChild("OffsideHighlight")) then
                                        v19 = Instance.new("Highlight")
                                        v19.Name = "OffsideHighlight"
                                        v19.Parent = v17.Character
                                        v19.OutlineColor = Color3.new(1, 0, 0)
                                        v19.DepthMode = Enum.HighlightDepthMode.Occluded
                                        v19.OutlineTransparency = 0.6
                                        v19.FillTransparency = 1
                                        local tbl_16 = {OutlineTransparency = 0}
                                        game:GetService("TweenService"):Create(v19, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_16):Play()
                                        for _, value_17 in pairs(game.Players:GetPlayers()) do
                                            if value_17 == v17 then
                                                continue
                                            end
                                            if value_17.Character:FindFirstChild("OffsideHighlight") then
                                                value_17.Character.OffsideHighlight:Destroy()
                                            end
                                        end
                                    end
                                end
                            else
                                local tbl_17 = {}
                                for _, value_18 in pairs(game.Players:GetPlayers()) do
                                    if value_18.SelectedPosition.Value == "GK" or not (value_18:FindFirstChild("InPlay")) then
                                        continue
                                    end
                                    if value_18.SelectedTeam.Value ~= LocalPlayer_upv_1.SelectedTeam.Value then
                                        table.insert(tbl_17, value_18)
                                    end
                                end
                                local v20 = 15.807
                                local v21 = nil
                                local v22 = v20
                                for _, value_19 in ipairs(tbl_17) do
                                    if not (value_19.Character) then
                                        continue
                                    end
                                    if v22 < value_19.Character.HumanoidRootPart.Position.Z then
                                        v22, v21 = value_19.Character.HumanoidRootPart.Position.Z, value_19
                                    end
                                end
                                if v21 and not (v21.Character:FindFirstChild("OffsideHighlight")) then
                                    v22 = Instance.new("Highlight")
                                    v22.Name = "OffsideHighlight"
                                    v22.Parent = v21.Character
                                    v22.OutlineColor = Color3.new(1, 0, 0)
                                    v22.DepthMode = Enum.HighlightDepthMode.Occluded
                                    v22.OutlineTransparency = 0.6
                                    v22.FillTransparency = 1
                                    local tbl_18 = {OutlineTransparency = 0}
                                    game:GetService("TweenService"):Create(v22, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_18):Play()
                                    for _, value_20 in pairs(game.Players:GetPlayers()) do
                                        if value_20 == v21 then
                                            continue
                                        end
                                        if value_20.Character:FindFirstChild("OffsideHighlight") then
                                            value_20.Character.OffsideHighlight:Destroy()
                                        end
                                    end
                                end
                            end
                            if Ball_upv_2 and not (Ball_upv_2:FindFirstChild("PossessionHighlight")) then
                                local v23 = Instance.new("Highlight")
                                v23.Name = "PossessionHighlight"
                                v23.Parent = Ball_upv_2
                                v23.OutlineColor = Color3.new(1, 1, 1)
                                v23.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                v23.OutlineTransparency = 1
                                v23.FillTransparency = 1
                                local tbl_19 = {OutlineTransparency = 0}
                                game:GetService("TweenService"):Create(v23, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_19):Play()
                            end
                        else
                            u7:Disconnect()
                        end
                    end
                )
                u7 = v16
                local u8 = nil
                local v24 = ballStatus_upv_1.lastKicked.Changed:Connect(
                    function()
                        --[[
                          line: 306
                          upvalues:
                            ballStatus_upv_1 (copy, index: 1)
                            LocalPlayer_upv_1 (copy, index: 2)
                            u7 (ref,  index: 3)
                            u8 (ref,  index: 4)
                        ]]
                        if ballStatus_upv_1.lastKicked.Value == LocalPlayer_upv_1 then
                            return
                        end
                        u7:Disconnect()
                        u8:Disconnect()
                    end
                )
                u8 = v24
            end
        end
    end
)
game.Workspace.Temp.ChildAdded:Connect(
    function(a1)
        --[[
          line: 337
          upvalues:
            ballStatus_upv_1 (copy, index: 1)
            LocalPlayer_upv_1 (copy, index: 2)
        ]]
        if a1.Name ~= "Ball" then
            return
        end
        if ballStatus_upv_1.lastKicked.Value == LocalPlayer_upv_1 then
            local v25 = Instance.new("Highlight")
            v25.Name = "PossessionHighlight"
            v25.Parent = a1
            v25.OutlineColor = Color3.new(1, 1, 1)
            v25.DepthMode = Enum.HighlightDepthMode.Occluded
            v25.OutlineTransparency = 1
            v25.FillTransparency = 1
            local tbl_20 = {OutlineTransparency = 0}
            game:GetService("TweenService"):Create(v25, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_20):Play()
            for _, value_21 in pairs(game.Players:GetPlayers()) do
                if not (value_21:FindFirstChild("dataLoaded")) or value_21.SelectedTeam.Value ~= LocalPlayer_upv_1.SelectedTeam.Value then
                    continue
                end
                if value_21 ~= LocalPlayer_upv_1 then
                    local v26 = Instance.new("Highlight")
                    v26.Name = "TeammateHighlight"
                    v26.Parent = value_21.Character
                    v26.OutlineColor = Color3.new(0, 1, 0)
                    v26.DepthMode = Enum.HighlightDepthMode.Occluded
                    v26.OutlineTransparency = 0.6
                    v26.FillTransparency = 1
                    local tbl_21 = {OutlineTransparency = 0}
                    game:GetService("TweenService"):Create(v26, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_21):Play()
                end
            end
        end
    end
)
v1:GetKey("passMarkerClient").OnClientEvent:Connect(
    function(a1, a2)
        --[[
          line: 367
        ]]
        for _, value_22 in pairs(game.Workspace.FX:GetChildren()) do
            if not (value_22:FindFirstChild("owner")) or value_22.Name ~= "PassMarker" then
                continue
            end
            if value_22.owner.Value == a2 then
                value_22:Destroy()
            end
        end
        local v27 = game.ReplicatedStorage.VFX.PassMarker
        if a2.SelectedTeam.Value ~= game.Players.LocalPlayer.SelectedTeam.Value then
            v27 = game.ReplicatedStorage.VFX.PassMarkerRed
        end
        local u9 = v27:Clone()
        u9.Parent = game.Workspace.FX
        u9.Position = a1
        u9.owner.Value = a2
        u9.TitleGui.TextLabel.Text = string.upper(a2.DisplayName)
        local tbl_22 = {TextTransparency = 0, TextStrokeTransparency = 0}
        game:GetService("TweenService"):Create(u9.TitleGui.TextLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_22):Play()
        local tbl_23 = {Volume = 0.25}
        game:GetService("TweenService"):Create(u9.sfx, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_23):Play()
        u9.fx.circle:Emit(1)
        u9.arrowAttach.arrow:Emit(1)
        task.delay(
            1.5,
            function()
                --[[
                  line: 393
                  upvalues:
                    u9 (copy, index: 1)
                ]]
                if u9 == nil or u9.Parent == nil then
                    return
                end
                u9.fx.circle.Enabled = false
                u9.arrowAttach.arrow.Enabled = false
                local tbl_24 = {TextTransparency = 1, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(u9.TitleGui.TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_24):Play()
                local tbl_25 = {Volume = 0}
                game:GetService("TweenService"):Create(u9.sfx, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_25):Play()
                game.Debris:AddItem(u9, 1)
            end
        )
    end
)
local Lobby_upv_1 = workspace:WaitForChild("Lobby")
LocalPlayer_upv_1.ChildAdded:Connect(
    function(a1)
        --[[
          line: 413
          upvalues:
            Lobby_upv_1 (copy, index: 1)
        ]]
        if a1.Name ~= "InPlay" or not game.Workspace:FindFirstChild("Lobby") then
            return
        end
        Lobby_upv_1.Parent = game.ReplicatedStorage
    end
)
LocalPlayer_upv_1.ChildRemoved:Connect(
    function(a1)
        --[[
          line: 422
          upvalues:
            Lobby_upv_1 (copy, index: 1)
        ]]
        if a1.Name ~= "InPlay" or (game.Workspace:FindFirstChild("Lobby")) then
            return
        end
        Lobby_upv_1.Parent = workspace
    end
)
game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LoadMapClient").OnClientEvent:Connect(
    function()
        --[[
          line: 430
          upvalues:
            Lobby_upv_1 (copy, index: 1)
        ]]
        game.Lighting.Blur.Size = 2
        if (game.Workspace:FindFirstChild("Lobby")) then
            return
        end
        Lobby_upv_1.Parent = workspace
    end
)
v1:GetKey("SetCharInvisible").OnClientEvent:Connect(
    function(a1, a2)
        --[[
          line: 437
        ]]
        if a2 == true then
            for _, value_23 in pairs(a1:GetChildren()) do
                if value_23:IsA("BasePart") then
                    value_23.Transparency = 1
                end
                if not (value_23:IsA("Accessory")) then
                    continue
                end
                for v1, value_24 in pairs(value_23:GetChildren()) do
                    if value_24:IsA("BasePart") then
                        value_24.Transparency = 1
                    end
                end
            end
            local u10 = a1.ChildAdded:Connect(
                function(a3)
                    --[[
                      line: 451
                    ]]
                    if not a3:IsA("Accessory") then
                        return
                    end
                    for _, value_25 in pairs(a3:GetChildren()) do
                        if value_25:IsA("BasePart") then
                            value_25.Transparency = 1
                        end
                    end
                end
            )
            task.delay(
                5,
                function()
                    --[[
                      line: 460
                      upvalues:
                        u10 (copy, index: 1)
                    ]]
                    u10:Disconnect()
                end
            )
        elseif a2 == false then
            for _, value_26 in pairs(a1:GetChildren()) do
                if value_26:IsA("BasePart") and value_26.Name ~= "BallWeldPos" and value_26.Name ~= "Hand" and value_26.Name ~= "HumanoidRootPart" and value_26.Name ~= "Neck_CameraSubject" and value_26.Name ~= "SlipCone" and value_26.Name ~= "CollisionBox" then
                    value_26.Transparency = 0
                end
                if not (value_26:IsA("Accessory")) then
                    continue
                end
                for v2, value_27 in pairs(value_26:GetChildren()) do
                    if value_27:IsA("BasePart") then
                        value_27.Transparency = 0
                    end
                end
            end
        end
    end
)
LocalPlayer_upv_1:WaitForChild("dataLoaded")
local _ = require(game.ReplicatedStorage.Modules:WaitForChild("ScreenRain"))
local GameSettings_1 = UserSettings().GameSettings
local SavedQualityLevel_upv_1 = GameSettings_1.SavedQualityLevel
local u11 = 0
local u12 = 5
local u13 = 10
function doGFXLevel()
    --[[
      name: doGFXLevel
      line: 487
      upvalues:
        SavedQualityLevel_upv_1 (ref, index: 1)
        u11 (ref, index: 2)
        u12 (ref, index: 3)
        u13 (ref, index: 4)
    ]]
    if SavedQualityLevel_upv_1 == Enum.SavedQualitySetting.Automatic then
        u11 = 0.5
    elseif SavedQualityLevel_upv_1 ~= Enum.SavedQualitySetting.QualityLevel10 then
        u11 = tonumber("0." .. string.sub(SavedQualityLevel_upv_1.Name, 13))
    else
        u11 = 1
    end
    if u11 < 0.8 then
        u12 = 10
        u13 = 20
        if not (u11 < 0.5) then
            return
        end
        u12 = 8
        u13 = 16
        if not (u11 < 0.25) then
            return
        end
        u12 = 5
        u13 = 10
    else
        u12 = 15
        u13 = 30
    end
end
doGFXLevel()
UserSettings().GameSettings:GetPropertyChangedSignal("SavedQualityLevel"):Connect(
    function()
        --[[
          line: 514
          upvalues:
            SavedQualityLevel_upv_1 (ref, index: 1)
        ]]
        SavedQualityLevel_upv_1 = UserSettings().GameSettings.SavedQualityLevel
        doGFXLevel()
    end
)
local Settings_upv_1 = LocalPlayer_upv_1:FindFirstChild("Settings")
function doGrass()
    --[[
      name: doGrass
      line: 522
      upvalues:
        Settings_upv_1 (copy, index: 1)
    ]]
    if Settings_upv_1.Misc.GrassVisuals.Value ~= true then
        game.Workspace.Terrain:Clear()
    else
        game.Workspace.Terrain:FillBlock(CFrame.new(Vector3.new(267, -10.25, 20)), Vector3.new(800, 32, 800), Enum.Material.Grass)
    end
end
task.delay(
    5,
    function()
        --[[
          line: 530
        ]]
        doGrass()
    end
)
Settings_upv_1.Misc.GrassVisuals.Changed:Connect(doGrass)
game.Workspace:WaitForChild("Cloud")
function doNight()
    --[[
      name: doNight
      line: 538
      upvalues:
        Settings_upv_1 (copy, index: 1)
    ]]
    if Settings_upv_1.Misc.Night.Value ~= true then
        for _, value_28 in ipairs(workspace.miscFX.NightLights:GetDescendants()) do
            if value_28:IsA("SurfaceLight") then
                value_28.Enabled = false
            end
        end
        game.Lighting.Atmosphere.Haze = 2.07
        game.Lighting.ClockTime = 13.5
        game.Lighting.Ambient = Color3.new(0, 0, 0)
        game.Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        game.Workspace.Cloud.Cloud.Transparency = NumberSequence.new(0)
        game.Workspace.Cloud.Cloud.LightEmission = 0
    else
        for _, value_29 in ipairs(workspace.miscFX.NightLights:GetDescendants()) do
            if not (value_29:IsA("SurfaceLight")) then
                continue
            end
            if Settings_upv_1.Misc.MapSelection.Value ~= "Blue Lock Chamber" then
                value_29.Enabled = true
                continue
            end
            if value_29.Parent:GetAttribute("Higher") then
                value_29.Enabled = false
            else
                value_29.Enabled = true
            end
        end
        game.Lighting.ClockTime = 22
        game.Lighting.Atmosphere.Haze = 0.2
        if Settings_upv_1.Misc.MapSelection.Value ~= "Blue Lock Chamber" then
            game.Lighting.Ambient = Color3.new(0, 0, 0)
            game.Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        else
            game.Lighting.Ambient = Color3.new(0.882353, 0.882353, 0.882353)
            game.Lighting.OutdoorAmbient = Color3.new(0.882353, 0.882353, 0.882353)
        end
        game.Workspace.Cloud.Cloud.Transparency = NumberSequence.new(0.8)
        game.Workspace.Cloud.Cloud.LightEmission = 1
    end
end
doNight()
Settings_upv_1.Misc.Night.Changed:Connect(doNight)
local u14 = LocalPlayer_upv_1.Character or (LocalPlayer_upv_1.CharacterAdded:Wait())
local u15 = nil
function doCinematic()
    --[[
      name: doCinematic
      line: 582
      upvalues:
        Settings_upv_1 (copy, index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
        u14 (copy, index: 3)
    ]]
    if Settings_upv_1.Misc.CinematicMode.Value == true then
        LocalPlayer_upv_1.PlayerGui.ScoreAndTimer.Enabled = false
        LocalPlayer_upv_1.PlayerGui.HUD.Enabled = false
        u14.HumanoidRootPart.UIAttach.ChargeGUI.Enabled = false
    elseif Settings_upv_1.Misc.CinematicMode.Value == false then
        LocalPlayer_upv_1.PlayerGui.ScoreAndTimer.Enabled = true
        LocalPlayer_upv_1.PlayerGui.HUD.Enabled = true
        u14.HumanoidRootPart.UIAttach.ChargeGUI.Enabled = true
    end
end
doCinematic()
Settings_upv_1.Misc.CinematicMode.Changed:Connect(doCinematic)
function doRain()
    --[[
      name: doRain
      line: 596
      upvalues:
        Settings_upv_1 (copy, index: 1)
    ]]
    if Settings_upv_1.Misc.RainEnabled.Value ~= false then
        game.Workspace.rain:Play()
        for _, value_30 in pairs(game.Lighting:GetChildren()) do
            if value_30:IsA("Sky") then
                value_30:Destroy()
            end
        end
        game.ReplicatedStorage.Rainy:Clone().Parent = game.Lighting
        local tbl_26 = {Density = 0.2}
        game:GetService("TweenService"):Create(game.Lighting.Atmosphere, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_26):Play()
    else
        game.Workspace.rain:Stop()
        for _, value_31 in pairs(game.Lighting:GetChildren()) do
            if value_31:IsA("Sky") then
                value_31:Destroy()
            end
        end
        game.ReplicatedStorage.Sky:Clone().Parent = game.Lighting
        local tbl_27 = {Density = 0.2}
        game:GetService("TweenService"):Create(game.Lighting.Atmosphere, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_27):Play()
    end
end
doRain()
Settings_upv_1.Misc.RainEnabled.Changed:Connect(doRain)
function doStorm()
    --[[
      name: doStorm
      line: 628
      upvalues:
        Settings_upv_1 (copy, index: 1)
    ]]
    if Settings_upv_1.Misc.StormEnabled.Value ~= false then
        game.Workspace.Rainstorm:Play()
        for _, value_32 in pairs(game.Lighting:GetChildren()) do
            if value_32:IsA("Sky") then
                value_32:Destroy()
            end
        end
        game.ReplicatedStorage.Rainy:Clone().Parent = game.Lighting
        local tbl_28 = {Density = 0.4}
        game:GetService("TweenService"):Create(game.Lighting.Atmosphere, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_28):Play()
    else
        game.Workspace.Rainstorm:Stop()
        for _, value_33 in pairs(game.Lighting:GetChildren()) do
            if value_33:IsA("Sky") then
                value_33:Destroy()
            end
        end
        game.ReplicatedStorage.Sky:Clone().Parent = game.Lighting
        local tbl_29 = {Density = 0.2}
        game:GetService("TweenService"):Create(game.Lighting.Atmosphere, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_29):Play()
    end
end
doStorm()
Settings_upv_1.Misc.StormEnabled.Changed:Connect(doStorm)
local u16 = nil
local u17 = nil
function doSnow()
    --[[
      name: doSnow
      line: 662
      upvalues:
        Settings_upv_1 (copy, index: 1)
        u17 (ref,  index: 2)
    ]]
    if Settings_upv_1.Misc.SnowEnabled.Value ~= false then
        game.Workspace.Snowstorm:Play()
        game.Workspace.Terrain:SetMaterialColor(Enum.Material.Grass, Color3.new(1, 1, 1))
        game.Lighting.Sky:Destroy()
        game.ReplicatedStorage.Rainy:Clone().Parent = game.Lighting
        local tbl_30 = {Density = 0.25}
        game:GetService("TweenService"):Create(game.Lighting.Atmosphere, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_30):Play()
        for _, value_34 in ipairs(workspace.gameArea.Grass:GetChildren()) do
            value_34.MaterialVariant = "SnowyGrass"
            value_34.Color = Color3.new(0.886275, 0.886275, 0.886275)
            if value_34:IsA("UnionOperation") then
                value_34.UsePartColor = true
            end
        end
        workspace.gameArea.Surround.MaterialVariant = "SnowyGrass"
        workspace.gameArea.Surround.Color = Color3.new(0.886275, 0.886275, 0.886275)
        workspace.gameArea.Surround.UsePartColor = true
        local v28 = game.Workspace.gameArea.Grass.ChildAdded:Connect(
            function(a1)
                --[[
                  line: 711
                ]]
                if a1.Name ~= "FieldBase" then
                    return
                end
                a1.MaterialVariant = "SnowyGrass"
                a1.Color = Color3.new(0.886275, 0.886275, 0.886275)
            end
        )
        u17 = v28
    else
        if u17 then
            u17:Disconnect()
        end
        game.Workspace.Terrain:SetMaterialColor(Enum.Material.Grass, Color3.new(0, 0.52549, 0.121569))
        game.Workspace.Snowstorm:Stop()
        for _, value_35 in pairs(game.Lighting:GetChildren()) do
            if value_35:IsA("Sky") then
                value_35:Destroy()
            end
        end
        game.ReplicatedStorage.Sky:Clone().Parent = game.Lighting
        for _, value_36 in ipairs(workspace.gameArea.Grass:GetChildren()) do
            value_36.MaterialVariant = ""
            value_36.Color = Color3.new(0.172549, 0.6, 0.0980392)
            if value_36:IsA("UnionOperation") then
                value_36.UsePartColor = false
            end
        end
        workspace.gameArea.Surround.MaterialVariant = ""
        workspace.gameArea.Surround.Color = Color3.new(0.172549, 0.6, 0.0980392)
        workspace.gameArea.Surround.UsePartColor = false
        local tbl_31 = {Density = 0.2}
        game:GetService("TweenService"):Create(game.Lighting.Atmosphere, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_31):Play()
    end
end
doSnow()
Settings_upv_1.Misc.SnowEnabled.Changed:Connect(doSnow)
function doSeasonal()
    --[[
      name: doSeasonal
      line: 722
      upvalues:
        Settings_upv_1 (copy, index: 1)
        u15 (ref,  index: 2)
    ]]
    if Settings_upv_1.Misc.Seasonal.Value ~= false then
        game.Workspace.Terrain:SetMaterialColor(Enum.Material.Grass, Color3.fromRGB(181, 181, 181))
        for _, value_37 in ipairs(workspace.gameArea.Grass:GetChildren()) do
            value_37.MaterialVariant = ""
            value_37.Color = Color3.fromRGB(181, 181, 181)
            if value_37:IsA("UnionOperation") then
                value_37.UsePartColor = true
            end
        end
        workspace.gameArea.Surround.MaterialVariant = ""
        workspace.gameArea.Surround.Color = Color3.fromRGB(134, 81, 60)
        workspace.gameArea.Surround.UsePartColor = true
        local v29 = game.Workspace.gameArea.Grass.ChildAdded:Connect(
            function(a1)
                --[[
                  line: 753
                ]]
                if a1.Name ~= "FieldBase" then
                    return
                end
                a1.MaterialVariant = ""
                a1.Color = Color3.fromRGB(134, 81, 60)
            end
        )
        u15 = v29
    elseif Settings_upv_1.Misc.SnowEnabled.Value == false then
        if u15 then
            u15:Disconnect()
        end
        game.Workspace.Terrain:SetMaterialColor(Enum.Material.Grass, Color3.new(0, 0.52549, 0.121569))
        for _, value_38 in ipairs(workspace.gameArea.Grass:GetChildren()) do
            value_38.MaterialVariant = ""
            value_38.Color = Color3.new(0.172549, 0.6, 0.0980392)
            if value_38:IsA("UnionOperation") then
                value_38.UsePartColor = false
            end
        end
        workspace.gameArea.Surround.MaterialVariant = ""
        workspace.gameArea.Surround.Color = Color3.new(0.172549, 0.6, 0.0980392)
        workspace.gameArea.Surround.UsePartColor = false
    end
end
doSeasonal()
Settings_upv_1.Misc.Seasonal.Changed:Connect(doSeasonal)
local tbl_upv_32 = {}
local LiquidModule_upv_1 = require(script.LiquidModule)
task.spawn(
    function()
        --[[
          line: 768
          upvalues:
            Settings_upv_1 (copy, index: 1)
        ]]
        while task.wait(math.random(1, 5) / 2) do
            if Settings_upv_1.Misc.StormEnabled.Value ~= false then
                local v30 = math.random(1, 2) == 1
                formLightning(v30)
            end
        end
    end
)
task.spawn(
    function()
        --[[
          line: 777
          upvalues:
            Settings_upv_1 (copy, index: 1)
            u12 (ref,  index: 2)
            u13 (ref,  index: 3)
            tbl_upv_32 (copy, index: 4)
            LiquidModule_upv_1 (copy, index: 5)
            LocalPlayer_upv_1 (copy, index: 6)
            u16 (ref,  index: 7)
        ]]
        while task.wait(0.1) do
            if Settings_upv_1.Misc.RainEnabled.Value ~= false then
                if Settings_upv_1.Misc.RainEnabled.Value == true then
                    for _ = 1, math.random(u12, u13) do
                        if #tbl_upv_32 < 400 then
                            local u18 = LiquidModule_upv_1.newWater((game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1)) + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)), Vector3.new(math.random(35, 45), -100, math.random(40, 60)))
                            table.insert(tbl_upv_32, u18)
                            u18.Destroying:Once(
                                function()
                                    --[[
                                      line: 788
                                      upvalues:
                                        tbl_upv_32 (copy, index: 1)
                                        u18 (copy, index: 2)
                                    ]]
                                    table.remove(tbl_upv_32, table.find(tbl_upv_32, u18))
                                end
                            )
                        end
                    end
                elseif Settings_upv_1.Misc.SnowEnabled.Value ~= true then
                    if Settings_upv_1.Misc.StormEnabled.Value ~= true then
                        continue
                    end
                    for _ = 1, math.random(u12, u13 * 2) do
                        if #tbl_upv_32 < 400 then
                            local u19 = LiquidModule_upv_1.newWater((game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1)) + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)), Vector3.new(math.random(35, 45), -100, math.random(40, 60)))
                            table.insert(tbl_upv_32, u19)
                            u19.Destroying:Once(
                                function()
                                    --[[
                                      line: 813
                                      upvalues:
                                        tbl_upv_32 (copy, index: 1)
                                        u19 (copy, index: 2)
                                    ]]
                                    table.remove(tbl_upv_32, table.find(tbl_upv_32, u19))
                                end
                            )
                        end
                    end
                elseif LocalPlayer_upv_1:FindFirstChild("InPlay") then
                    if not (u16) then
                        u16 = Instance.new("Part")
                        u16.Size = Vector3.new(125, 0.10000000149011612, 125)
                        u16.Transparency = 1
                        u16.CanCollide = false
                        u16.CanTouch = false
                        u16.CanQuery = false
                        u16.Anchored = true
                        u16.Parent = game.Workspace.FX
                        local v31 = game.ReplicatedStorage.VFX.snowParticle:Clone()
                        v31.Parent = u16
                    end
                    u16.Position = Vector3.new(game.Workspace.CurrentCamera.CFrame.Position.X, 50, game.Workspace.CurrentCamera.CFrame.Position.Z)
                else
                    if Settings_upv_1.Misc.StormEnabled.Value ~= true then
                        continue
                    end
                    for _ = 1, math.random(u12, u13 * 2) do
                        if #tbl_upv_32 < 400 then
                            local u19 = LiquidModule_upv_1.newWater((game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1)) + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)), Vector3.new(math.random(35, 45), -100, math.random(40, 60)))
                            table.insert(tbl_upv_32, u19)
                            u19.Destroying:Once(
                                function()
                                    --[[
                                      line: 813
                                      upvalues:
                                        tbl_upv_32 (copy, index: 1)
                                        u19 (copy, index: 2)
                                    ]]
                                    table.remove(tbl_upv_32, table.find(tbl_upv_32, u19))
                                end
                            )
                        end
                    end
                end
            elseif Settings_upv_1.Misc.SnowEnabled == false then
                if Settings_upv_1.Misc.StormEnabled == false then
                    continue
                end
                if Settings_upv_1.Misc.RainEnabled.Value == true then
                    for _ = 1, math.random(u12, u13) do
                        if #tbl_upv_32 < 400 then
                            local u18 = LiquidModule_upv_1.newWater((game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1)) + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)), Vector3.new(math.random(35, 45), -100, math.random(40, 60)))
                            table.insert(tbl_upv_32, u18)
                            u18.Destroying:Once(
                                function()
                                    --[[
                                      line: 788
                                      upvalues:
                                        tbl_upv_32 (copy, index: 1)
                                        u18 (copy, index: 2)
                                    ]]
                                    table.remove(tbl_upv_32, table.find(tbl_upv_32, u18))
                                end
                            )
                        end
                    end
                elseif Settings_upv_1.Misc.SnowEnabled.Value ~= true then
                    if Settings_upv_1.Misc.StormEnabled.Value ~= true then
                        continue
                    end
                    for _ = 1, math.random(u12, u13 * 2) do
                        if #tbl_upv_32 < 400 then
                            local u19 = LiquidModule_upv_1.newWater((game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1)) + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)), Vector3.new(math.random(35, 45), -100, math.random(40, 60)))
                            table.insert(tbl_upv_32, u19)
                            u19.Destroying:Once(
                                function()
                                    --[[
                                      line: 813
                                      upvalues:
                                        tbl_upv_32 (copy, index: 1)
                                        u19 (copy, index: 2)
                                    ]]
                                    table.remove(tbl_upv_32, table.find(tbl_upv_32, u19))
                                end
                            )
                        end
                    end
                elseif LocalPlayer_upv_1:FindFirstChild("InPlay") then
                    if not (u16) then
                        u16 = Instance.new("Part")
                        u16.Size = Vector3.new(125, 0.10000000149011612, 125)
                        u16.Transparency = 1
                        u16.CanCollide = false
                        u16.CanTouch = false
                        u16.CanQuery = false
                        u16.Anchored = true
                        u16.Parent = game.Workspace.FX
                        local v31 = game.ReplicatedStorage.VFX.snowParticle:Clone()
                        v31.Parent = u16
                    end
                    u16.Position = Vector3.new(game.Workspace.CurrentCamera.CFrame.Position.X, 50, game.Workspace.CurrentCamera.CFrame.Position.Z)
                else
                    if Settings_upv_1.Misc.StormEnabled.Value ~= true then
                        continue
                    end
                    for _ = 1, math.random(u12, u13 * 2) do
                        if #tbl_upv_32 < 400 then
                            local u19 = LiquidModule_upv_1.newWater((game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1)) + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)), Vector3.new(math.random(35, 45), -100, math.random(40, 60)))
                            table.insert(tbl_upv_32, u19)
                            u19.Destroying:Once(
                                function()
                                    --[[
                                      line: 813
                                      upvalues:
                                        tbl_upv_32 (copy, index: 1)
                                        u19 (copy, index: 2)
                                    ]]
                                    table.remove(tbl_upv_32, table.find(tbl_upv_32, u19))
                                end
                            )
                        end
                    end
                end
            elseif Settings_upv_1.Misc.RainEnabled.Value == true then
                for _ = 1, math.random(u12, u13) do
                    if #tbl_upv_32 < 400 then
                        local u18 = LiquidModule_upv_1.newWater((game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1)) + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)), Vector3.new(math.random(35, 45), -100, math.random(40, 60)))
                        table.insert(tbl_upv_32, u18)
                        u18.Destroying:Once(
                            function()
                                --[[
                                  line: 788
                                  upvalues:
                                    tbl_upv_32 (copy, index: 1)
                                    u18 (copy, index: 2)
                                ]]
                                table.remove(tbl_upv_32, table.find(tbl_upv_32, u18))
                            end
                        )
                    end
                end
            elseif Settings_upv_1.Misc.SnowEnabled.Value ~= true then
                if Settings_upv_1.Misc.StormEnabled.Value ~= true then
                    continue
                end
                for _ = 1, math.random(u12, u13 * 2) do
                    if #tbl_upv_32 < 400 then
                        local u19 = LiquidModule_upv_1.newWater((game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1)) + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)), Vector3.new(math.random(35, 45), -100, math.random(40, 60)))
                        table.insert(tbl_upv_32, u19)
                        u19.Destroying:Once(
                            function()
                                --[[
                                  line: 813
                                  upvalues:
                                    tbl_upv_32 (copy, index: 1)
                                    u19 (copy, index: 2)
                                ]]
                                table.remove(tbl_upv_32, table.find(tbl_upv_32, u19))
                            end
                        )
                    end
                end
            elseif LocalPlayer_upv_1:FindFirstChild("InPlay") then
                if not (u16) then
                    u16 = Instance.new("Part")
                    u16.Size = Vector3.new(125, 0.10000000149011612, 125)
                    u16.Transparency = 1
                    u16.CanCollide = false
                    u16.CanTouch = false
                    u16.CanQuery = false
                    u16.Anchored = true
                    u16.Parent = game.Workspace.FX
                    local v31 = game.ReplicatedStorage.VFX.snowParticle:Clone()
                    v31.Parent = u16
                end
                u16.Position = Vector3.new(game.Workspace.CurrentCamera.CFrame.Position.X, 50, game.Workspace.CurrentCamera.CFrame.Position.Z)
            else
                if Settings_upv_1.Misc.StormEnabled.Value ~= true then
                    continue
                end
                for _ = 1, math.random(u12, u13 * 2) do
                    if #tbl_upv_32 < 400 then
                        local u19 = LiquidModule_upv_1.newWater((game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1)) + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)), Vector3.new(math.random(35, 45), -100, math.random(40, 60)))
                        table.insert(tbl_upv_32, u19)
                        u19.Destroying:Once(
                            function()
                                --[[
                                  line: 813
                                  upvalues:
                                    tbl_upv_32 (copy, index: 1)
                                    u19 (copy, index: 2)
                                ]]
                                table.remove(tbl_upv_32, table.find(tbl_upv_32, u19))
                            end
                        )
                    end
                end
            end
        end
    end
)
function formLightning(a1)
    --[[
      name: formLightning
      line: 822
    ]]
    local v32 = Instance.new("Part")
    v32.Parent = game.Workspace.Temp
    v32.Transparency = 1
    v32.CanCollide = false
    v32.Anchored = true
    v32.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(math.random(-1250, 1250), 0, math.random(-1250, 1250))
    game.Debris:AddItem(v32, 3)
    local v33 = script["lightning_strike" .. math.random(1, 2)]:Clone()
    v33.Parent = v32
    v33.PlaybackSpeed = math.random(40, 60) / 100
    v33:Play()
    task.wait(0.05)
end
v1:GetKey("PSCommand").OnClientEvent:Connect(
    function(a1)
        --[[
          line: 837
        ]]
        game.TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(a1)
    end
)