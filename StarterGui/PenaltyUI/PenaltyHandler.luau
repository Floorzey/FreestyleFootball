--[[
    Script Path: Game/StarterGui/PenaltyUI/PenaltyHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:09
--]]

local topFrame_upv_1 = script.Parent.topFrame
local bottomFrame_upv_1 = script.Parent.bottomFrame
local SHOTTYPE_upv_1 = bottomFrame_upv_1.SHOTTYPE
local ButtonRight_upv_1 = SHOTTYPE_upv_1.ButtonRight
local ButtonLeft_upv_1 = SHOTTYPE_upv_1.ButtonLeft
local ConfirmButton_upv_1 = SHOTTYPE_upv_1.ConfirmButton
local COUNTDOWN_upv_1 = topFrame_upv_1.COUNTDOWN
local TimingBar_upv_1 = script.Parent.TimingBar
local Bar_upv_1 = TimingBar_upv_1.Bar
local tbl_upv_1 = {"CENTER", "BOTTOM LEFT", "TOP LEFT", "BOTTOM RIGHT", "TOP RIGHT"}
local LocalPlayer_upv_1 = game.Players.LocalPlayer
local u1 = LocalPlayer_upv_1.Character or (LocalPlayer_upv_1.CharacterAdded:Wait())
u1:WaitForChild("Humanoid")
local u2 = LocalPlayer_upv_1:GetMouse()
local CurrentCamera_upv_1 = game.Workspace.CurrentCamera
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local v1 = Knit_1.GetService("KeyHandlerService")
local u3 = v1:GetKey("GoalClient")
local u4 = v1:GetKey("OOBClient")
local u5 = v1:GetKey("Penalty")
function pullUp()
    --[[
      name: pullUp
      line: 38
      upvalues:
        topFrame_upv_1 (copy, index: 1)
        bottomFrame_upv_1 (copy, index: 2)
    ]]
    topFrame_upv_1.Position = UDim2.new(0, 0, 0, -150)
    bottomFrame_upv_1.Position = UDim2.new(0, 0, 1, 150)
    local TweenService_1 = game:GetService("TweenService")
    local v2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_2 = {}
    tbl_2.Position = UDim2.new(0, 0, 0, 0)
    TweenService_1:Create(topFrame_upv_1, v2, tbl_2):Play()
    local TweenService_2 = game:GetService("TweenService")
    local v3 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_3 = {}
    tbl_3.Position = UDim2.new(0, 0, 1, 0)
    TweenService_2:Create(bottomFrame_upv_1, v3, tbl_3):Play()
end
function dropAway()
    --[[
      name: dropAway
      line: 49
      upvalues:
        topFrame_upv_1 (copy, index: 1)
        bottomFrame_upv_1 (copy, index: 2)
    ]]
    topFrame_upv_1.Position = UDim2.new(0, 0, 0, 0)
    bottomFrame_upv_1.Position = UDim2.new(0, 0, 1, 0)
    local TweenService_3 = game:GetService("TweenService")
    local v4 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_4 = {}
    tbl_4.Position = UDim2.new(0, 0, 0, -150)
    TweenService_3:Create(topFrame_upv_1, v4, tbl_4):Play()
    local TweenService_4 = game:GetService("TweenService")
    local v5 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_5 = {}
    tbl_5.Position = UDim2.new(0, 0, 1, 150)
    TweenService_4:Create(bottomFrame_upv_1, v5, tbl_5):Play()
end
function handleTiming()
    --[[
      name: handleTiming
      line: 60
      upvalues:
        TimingBar_upv_1 (copy, index: 1)
        Bar_upv_1 (copy, index: 2)
    ]]
    TimingBar_upv_1.Position = UDim2.new(0.5, 0, 1, 50)
    local TweenService_5 = game:GetService("TweenService")
    local v6 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_6 = {}
    tbl_6.Position = UDim2.new(0.5, 0, 1, -200)
    TweenService_5:Create(TimingBar_upv_1, v6, tbl_6):Play()
    Bar_upv_1.Position = UDim2.new(0, 0, 0.5, 0)
    task.wait(0.4)
    local u6 = game:GetService("TweenService"):Create(Bar_upv_1, TweenInfo.new(0.75, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0.5, 0)})
    u6:Play()
    local u7 = nil
    local v7 = u6.Completed:Connect(
        function()
            --[[
              line: 71
              upvalues:
                u7 (ref,  index: 1)
                Bar_upv_1 (copy, index: 2)
            ]]
            u7:Disconnect()
            local TweenService_6 = game:GetService("TweenService")
            local v8 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_7 = {}
            tbl_7.Position = UDim2.new(0, 0, 0.5, 0)
            TweenService_6:Create(Bar_upv_1, v8, tbl_7):Play()
        end
    )
    u7 = v7
    local u8 = nil
    local v9 = u6:GetPropertyChangedSignal("PlaybackState"):Connect(
        function()
            --[[
              line: 77
              upvalues:
                u6 (copy, index: 1)
                u7 (ref,  index: 2)
                u8 (ref,  index: 3)
            ]]
            if u6.PlaybackState ~= Enum.PlaybackState.Paused then
                return
            end
            u7:Disconnect()
            u8:Disconnect()
        end
    )
    u8 = v9
    u6.Destroying:Once(
        function()
            --[[
              line: 83
              upvalues:
                u8 (ref, index: 1)
                u7 (ref, index: 2)
            ]]
            u8:Disconnect()
            u7:Disconnect()
        end
    )
    return u6
end
function hideTimingBar()
    --[[
      name: hideTimingBar
      line: 90
      upvalues:
        TimingBar_upv_1 (copy, index: 1)
    ]]
    local TweenService_7 = game:GetService("TweenService")
    local v10 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_8 = {}
    tbl_8.Position = UDim2.new(0.5, 0, 1, 50)
    TweenService_7:Create(TimingBar_upv_1, v10, tbl_8):Play()
end
function clearMarkers()
    --[[
      name: clearMarkers
      line: 96
    ]]
    for _, value_1 in pairs(game.Workspace.gameArea.Field.GoalboxAway:GetDescendants()) do
        if not (value_1:IsA("ParticleEmitter")) then
            continue
        end
        if value_1.Name == "SpotMarker" then
            value_1.Enabled = false
        end
    end
    for _, value_2 in pairs(game.Workspace.gameArea.Field.GoalboxHome:GetDescendants()) do
        if not (value_2:IsA("ParticleEmitter")) then
            continue
        end
        if value_2.Name == "SpotMarker" then
            value_2.Enabled = false
        end
    end
end
local UserInputService_upv_1 = game:GetService("UserInputService")
local u9 = u1.Humanoid.Animator:LoadAnimation(game.ReplicatedStorage.AnimFolder:FindFirstChild(LocalPlayer_upv_1.Data.animationType.Value).PenaltyIdle)
local u10 = u1.Humanoid.Animator:LoadAnimation(game.ReplicatedStorage.AnimFolder:FindFirstChild(LocalPlayer_upv_1.Data.animationType.Value).PenaltyShotL)
local u11 = u1.Humanoid.Animator:LoadAnimation(game.ReplicatedStorage.AnimFolder:FindFirstChild(LocalPlayer_upv_1.Data.animationType.Value).PenaltyShotR)
u5.OnClientEvent:Connect(
    function()
        --[[
          line: 116
          upvalues:
            u1 (copy, index: 1)
            LocalPlayer_upv_1 (copy, index: 2)
            CurrentCamera_upv_1 (copy, index: 3)
            u9 (copy, index: 4)
            u2 (copy, index: 5)
            COUNTDOWN_upv_1 (copy, index: 6)
            SHOTTYPE_upv_1 (copy, index: 7)
            tbl_upv_1 (copy, index: 8)
            ButtonRight_upv_1 (copy, index: 9)
            ButtonLeft_upv_1 (copy, index: 10)
            ConfirmButton_upv_1 (copy, index: 11)
            u10 (copy, index: 12)
            u11 (copy, index: 13)
            u3 (copy, index: 14)
            u4 (copy, index: 15)
            UserInputService_upv_1 (copy, index: 16)
            Bar_upv_1 (copy, index: 17)
            u5 (copy, index: 18)
        ]]
        if not u1 then
            return
        end
        local u12 = ((LocalPlayer_upv_1.SelectedTeam.Value ~= "Away") and "Away") or "Home"
        local u13 = Instance.new("Folder")
        u13.Name = "CameraOverride"
        u13.Parent = u1.Status
        task.spawn(
            function()
                --[[
                  line: 126
                  upvalues:
                    CurrentCamera_upv_1 (copy, index: 1)
                ]]
                repeat
                    wait()
                    CurrentCamera_upv_1.CameraType = Enum.CameraType.Scriptable
                until CurrentCamera_upv_1.CameraType == Enum.CameraType.Scriptable
            end
        )
        u9:Play()
        local ShootoutCameraPos_upv_1 = game.Workspace.PlayerPositions[LocalPlayer_upv_1.SelectedTeam.Value .. "Team"].ShootoutCameraPos
        CurrentCamera_upv_1.CFrame = ShootoutCameraPos_upv_1.CFrame
        local v11 = game:GetService("RunService").RenderStepped:Connect(
            function()
                --[[
                  line: 136
                  upvalues:
                    CurrentCamera_upv_1 (copy, index: 1)
                    ShootoutCameraPos_upv_1 (copy, index: 2)
                    u2 (copy, index: 3)
                ]]
                local TweenService_8 = game:service("TweenService")
                local v12 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_9 = {}
                tbl_9.CFrame = ShootoutCameraPos_upv_1.CFrame * CFrame.Angles(math.rad(((u2.Y - (u2.ViewSizeY / 2)) / u2.ViewSizeY) * -10), math.rad(((u2.X - (u2.ViewSizeX / 2)) / u2.ViewSizeX) * -10), 0)
                TweenService_8:Create(CurrentCamera_upv_1, v12, tbl_9):Play()
            end
        )
        task.wait(3)
        pullUp()
        local u14 = Instance.new("BindableEvent")
        local u15 = false
        task.spawn(
            function()
                --[[
                  line: 151
                  upvalues:
                    COUNTDOWN_upv_1 (copy, index: 1)
                    u15 (ref,  index: 2)
                    u14 (copy, index: 3)
                ]]
                local v13 = 10
                COUNTDOWN_upv_1.Text = v13
                for _ = 1, 10 do
                    task.wait(1)
                    if u15 ~= true then
                        v13 = v13 - 1
                        COUNTDOWN_upv_1.Text = v13
                        local v14 = game.ReplicatedStorage.UISounds.countdown_tick:Clone()
                        v14.Parent = game.Workspace
                        v14:Play()
                        game.Debris:AddItem(v14, 3)
                        continue
                    end
                    return
                end
                u14:Fire()
            end
        )
        local u16 = 1
        SHOTTYPE_upv_1.Text = tbl_upv_1[u16]
        clearMarkers()
        game.Workspace.gameArea.Field["Goalbox" .. u12][tbl_upv_1[u16]].Attachment.SpotMarker.Enabled = true
        local v15 = ButtonRight_upv_1.MouseButton1Click:Connect(
            function()
                --[[
                  line: 173
                  upvalues:
                    u16 (ref,  index: 1)
                    SHOTTYPE_upv_1 (copy, index: 2)
                    tbl_upv_1 (copy, index: 3)
                    u12 (copy, index: 4)
                ]]
                local v16 = game.ReplicatedStorage.UISounds["ui-click"]:Clone()
                v16.Parent = game.Workspace
                v16:Play()
                game.Debris:AddItem(v16, 3)
                u16 = u16 + 1
                if u16 > 5 then
                    u16 = 1
                end
                SHOTTYPE_upv_1.Text = tbl_upv_1[u16]
                clearMarkers()
                game.Workspace.gameArea.Field["Goalbox" .. u12][tbl_upv_1[u16]].Attachment.SpotMarker.Enabled = true
            end
        )
        local v17 = ButtonLeft_upv_1.MouseButton1Click:Connect(
            function()
                --[[
                  line: 186
                  upvalues:
                    u16 (ref,  index: 1)
                    SHOTTYPE_upv_1 (copy, index: 2)
                    tbl_upv_1 (copy, index: 3)
                    u12 (copy, index: 4)
                ]]
                local v18 = game.ReplicatedStorage.UISounds["ui-click"]:Clone()
                v18.Parent = game.Workspace
                v18:Play()
                game.Debris:AddItem(v18, 3)
                u16 = u16 - 1
                if u16 < 1 then
                    u16 = 5
                end
                SHOTTYPE_upv_1.Text = tbl_upv_1[u16]
                clearMarkers()
                game.Workspace.gameArea.Field["Goalbox" .. u12][tbl_upv_1[u16]].Attachment.SpotMarker.Enabled = true
            end
        )
        local v19 = ConfirmButton_upv_1.MouseButton1Click:Connect(
            function()
                --[[
                  line: 199
                  upvalues:
                    u15 (ref,  index: 1)
                    u14 (copy, index: 2)
                ]]
                local v20 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
                v20.Parent = game.Workspace
                v20:Play()
                game.Debris:AddItem(v20, 3)
                u15 = true
                u14:Fire()
            end
        )
        u14.Event:Wait()
        v11:Disconnect()
        local TweenService_9 = game:service("TweenService")
        local v21 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_10 = {}
        tbl_10.CFrame = u1.Neck_CameraSubject.CFrame * CFrame.new(u1.Humanoid.CameraOffset.X, 0.5, 0)
        TweenService_9:Create(CurrentCamera_upv_1, v21, tbl_10):Play()
        task.delay(
            0.2,
            function()
                --[[
                  line: 212
                  upvalues:
                    CurrentCamera_upv_1 (copy, index: 1)
                    u13 (copy, index: 2)
                ]]
                repeat
                    wait()
                    CurrentCamera_upv_1.CameraType = Enum.CameraType.Custom
                until CurrentCamera_upv_1.CameraType == Enum.CameraType.Custom
                u13:Destroy()
            end
        )
        dropAway()
        clearMarkers()
        v15:Disconnect()
        v17:Disconnect()
        v19:Disconnect()
        local u17 = false
        u9:Stop()
        local u18
        if u16 == 4 or u16 == 5 then
            u18 = u11
        else
            u18 = u10
        end
        u18:Play()
        local u19 = nil
        local u20 = nil
        local u21 = nil
        local v22 = u3.OnClientEvent:Connect(
            function()
                --[[
                  line: 235
                  upvalues:
                    u18 (ref, index: 1)
                    u19 (ref, index: 2)
                    u20 (ref, index: 3)
                    u21 (ref, index: 4)
                ]]
                task.wait(3)
                u18:Stop()
                u19:Disconnect()
                u20:Disconnect()
                u21:Disconnect()
            end
        )
        u19 = v22
        local v23 = u4.OnClientEvent:Connect(
            function()
                --[[
                  line: 242
                  upvalues:
                    u18 (ref, index: 1)
                    u19 (ref, index: 2)
                    u20 (ref, index: 3)
                    u21 (ref, index: 4)
                ]]
                task.wait(2)
                u18:Stop()
                u19:Disconnect()
                u20:Disconnect()
                u21:Disconnect()
            end
        )
        u20 = v23
        local v24 = game.ReplicatedStorage.ChildAdded:Connect(
            function(a1)
                --[[
                  line: 249
                  upvalues:
                    u18 (ref, index: 1)
                    u19 (ref, index: 2)
                    u20 (ref, index: 3)
                    u21 (ref, index: 4)
                ]]
                if a1.Name ~= "RedCalled" then
                    return
                end
                task.wait(2)
                u18:Stop()
                u19:Disconnect()
                u20:Disconnect()
                u21:Disconnect()
            end
        )
        u21 = v24
        local u22 = handleTiming()
        local u23 = nil
        local v25 = UserInputService_upv_1.InputBegan:Connect(
            function(a2)
                --[[
                  line: 259
                  upvalues:
                    Bar_upv_1 (copy, index: 1)
                    u17 (ref,  index: 2)
                    u22 (copy, index: 3)
                    u23 (ref,  index: 4)
                ]]
                if a2.UserInputType ~= Enum.UserInputType.MouseButton1 and a2.KeyCode ~= Enum.KeyCode.ButtonR1 and a2.KeyCode ~= Enum.KeyCode.ButtonL1 then
                    return
                end
                if Bar_upv_1.Position.X.Scale > 0.9 then
                    local v26 = game.ReplicatedStorage.UISounds.ui_achieve:Clone()
                    v26.Parent = game.Workspace
                    v26:Play()
                    game.Debris:AddItem(v26, 3)
                    u17 = true
                else
                    local v27 = game.ReplicatedStorage.UISounds["ui-error3"]:Clone()
                    v27.Parent = game.Workspace
                    v27:Play()
                    game.Debris:AddItem(v27, 3)
                end
                u22:Pause()
                u23:Disconnect()
            end
        )
        u23 = v25
        LocalPlayer_upv_1.PlayerGui.Buttons.penButtonFrame.TextButton.Visible = true
        local v28 = LocalPlayer_upv_1.PlayerGui.Buttons.penButtonFrame.TextButton.Activated:Connect(
            function()
                --[[
                  line: 278
                  upvalues:
                    Bar_upv_1 (copy, index: 1)
                    u17 (ref,  index: 2)
                    u22 (copy, index: 3)
                    LocalPlayer_upv_1 (copy, index: 4)
                    u23 (ref,  index: 5)
                ]]
                if Bar_upv_1.Position.X.Scale > 0.9 then
                    local v29 = game.ReplicatedStorage.UISounds.ui_achieve:Clone()
                    v29.Parent = game.Workspace
                    v29:Play()
                    game.Debris:AddItem(v29, 3)
                    u17 = true
                else
                    local v30 = game.ReplicatedStorage.UISounds["ui-error3"]:Clone()
                    v30.Parent = game.Workspace
                    v30:Play()
                    game.Debris:AddItem(v30, 3)
                end
                u22:Pause()
                LocalPlayer_upv_1.PlayerGui.Buttons.penButtonFrame.TextButton.Visible = false
                u23:Disconnect()
            end
        )
        task.wait(0.867)
        u22:Cancel()
        u23:Disconnect()
        v28:Disconnect()
        task.delay(
            0.4,
            function()
                --[[
                  line: 299
                  upvalues:
                    LocalPlayer_upv_1 (copy, index: 1)
                ]]
                hideTimingBar()
                LocalPlayer_upv_1.PlayerGui.Buttons.penButtonFrame.TextButton.Visible = false
            end
        )
        u5:FireServer(tbl_upv_1[u16], u17)
        u1.HumanoidRootPart.Anchored = false
        local v31 = Instance.new("Folder")
        v31.Name = "CameraLocked"
        v31.Parent = u1.Status
        game.Debris:AddItem(v31, 0.5)
        local v32 = Instance.new("BodyVelocity")
        v32.Velocity = (Vector3.new(0, 15, 0) + (u1.HumanoidRootPart.CFrame.rightVector * -15)) + (u1.HumanoidRootPart.CFrame.lookVector * 15)
        v32.MaxForce = Vector3.new(1e+05, 1e+05, 1e+05)
        v32.Parent = u1.HumanoidRootPart
        game.Debris:AddItem(v32, 0.15)
    end
)