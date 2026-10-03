--[[
    Script Path: Game/StarterGui/FreeKickUI/FreeKickUI
    Class: LocalScript
    Time: 2026-10-03 12:27:08
--]]

local topFrame_upv_1 = script.Parent.topFrame
local bottomFrame_upv_1 = script.Parent.bottomFrame
local ConfirmButton_upv_1 = bottomFrame_upv_1.ConfirmButton
local COUNTDOWN_upv_1 = topFrame_upv_1.COUNTDOWN
local TimingBar_upv_1 = script.Parent.TimingBar
local Bar_upv_1 = TimingBar_upv_1.Bar
local LocalPlayer_1 = game.Players.LocalPlayer
local u1 = LocalPlayer_1.Character or (LocalPlayer_1.CharacterAdded:Wait())
u1:WaitForChild("Humanoid")
local _ = LocalPlayer_1:GetMouse()
local CurrentCamera_upv_1 = game.Workspace.CurrentCamera
local FreeKickUI_upv_1 = game.ReplicatedStorage.VFX.FreeKickUI
local u2 = nil
function pullUp()
    --[[
      name: pullUp
      line: 21
      upvalues:
        u2 (ref,  index: 1)
        FreeKickUI_upv_1 (copy, index: 2)
        topFrame_upv_1 (copy, index: 3)
        bottomFrame_upv_1 (copy, index: 4)
    ]]
    u2 = FreeKickUI_upv_1:Clone()
    u2.Parent = game.Workspace.Temp.Ball
    topFrame_upv_1.Position = UDim2.new(0, 0, 0, -150)
    bottomFrame_upv_1.Position = UDim2.new(0, 0, 1, 150)
    local TweenService_1 = game:GetService("TweenService")
    local v1 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_1 = {}
    tbl_1.Position = UDim2.new(0, 0, 0, 0)
    TweenService_1:Create(topFrame_upv_1, v1, tbl_1):Play()
    local TweenService_2 = game:GetService("TweenService")
    local v2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_2 = {}
    tbl_2.Position = UDim2.new(0, 0, 1, 0)
    TweenService_2:Create(bottomFrame_upv_1, v2, tbl_2):Play()
end
function dropAway()
    --[[
      name: dropAway
      line: 34
      upvalues:
        u2 (ref,  index: 1)
        topFrame_upv_1 (copy, index: 2)
        bottomFrame_upv_1 (copy, index: 3)
    ]]
    u2:Destroy()
    u2 = nil
    topFrame_upv_1.Position = UDim2.new(0, 0, 0, 0)
    bottomFrame_upv_1.Position = UDim2.new(0, 0, 1, 0)
    local TweenService_3 = game:GetService("TweenService")
    local v3 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_3 = {}
    tbl_3.Position = UDim2.new(0, 0, 0, -150)
    TweenService_3:Create(topFrame_upv_1, v3, tbl_3):Play()
    local TweenService_4 = game:GetService("TweenService")
    local v4 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_4 = {}
    tbl_4.Position = UDim2.new(0, 0, 1, 150)
    TweenService_4:Create(bottomFrame_upv_1, v4, tbl_4):Play()
end
function handleTiming()
    --[[
      name: handleTiming
      line: 47
      upvalues:
        TimingBar_upv_1 (copy, index: 1)
        Bar_upv_1 (copy, index: 2)
    ]]
    TimingBar_upv_1.Position = UDim2.new(0.5, 0, 1, 50)
    local TweenService_5 = game:GetService("TweenService")
    local v5 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_5 = {}
    tbl_5.Position = UDim2.new(0.5, 0, 1, -200)
    TweenService_5:Create(TimingBar_upv_1, v5, tbl_5):Play()
    Bar_upv_1.Position = UDim2.new(0, 0, 0.5, 0)
    task.wait(0.45)
    local u3 = game:GetService("TweenService"):Create(Bar_upv_1, TweenInfo.new(0.867, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0.5, 0)})
    u3:Play()
    local u4 = nil
    local v6 = u3.Completed:Connect(
        function()
            --[[
              line: 58
              upvalues:
                u4 (ref,  index: 1)
                Bar_upv_1 (copy, index: 2)
            ]]
            u4:Disconnect()
            local TweenService_6 = game:GetService("TweenService")
            local v7 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_6 = {}
            tbl_6.Position = UDim2.new(0, 0, 0.5, 0)
            TweenService_6:Create(Bar_upv_1, v7, tbl_6):Play()
        end
    )
    u4 = v6
    local u5 = nil
    local v8 = u3:GetPropertyChangedSignal("PlaybackState"):Connect(
        function()
            --[[
              line: 64
              upvalues:
                u3 (copy, index: 1)
                u4 (ref,  index: 2)
                u5 (ref,  index: 3)
            ]]
            if u3.PlaybackState ~= Enum.PlaybackState.Paused then
                return
            end
            u4:Disconnect()
            u5:Disconnect()
        end
    )
    u5 = v8
    u3.Destroying:Once(
        function()
            --[[
              line: 70
              upvalues:
                u5 (ref, index: 1)
                u4 (ref, index: 2)
            ]]
            u5:Disconnect()
            u4:Disconnect()
        end
    )
    return u3
end
function hideTimingBar()
    --[[
      name: hideTimingBar
      line: 77
      upvalues:
        TimingBar_upv_1 (copy, index: 1)
    ]]
    local TweenService_7 = game:GetService("TweenService")
    local v9 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_7 = {}
    tbl_7.Position = UDim2.new(0.5, 0, 1, 50)
    TweenService_7:Create(TimingBar_upv_1, v9, tbl_7):Play()
end
local UserInputService_upv_1 = game:GetService("UserInputService")
local u6 = u1.Humanoid.Animator:LoadAnimation(game.ReplicatedStorage.AnimFolder.PenaltyIdle)
local u7 = u1.Humanoid.Animator:LoadAnimation(game.ReplicatedStorage.AnimFolder.PenaltyShotL)
local v1 = u1.Humanoid.Animator:LoadAnimation(game.ReplicatedStorage.AnimFolder.PenaltyShotR)
local RunService_upv_1 = game:GetService("RunService")
local u8 = CFrame.new(0, 4, 12)
function radifyVector(a1)
    --[[
      name: radifyVector
      line: 94
    ]]
    return CFrame.Angles(math.rad(a1.X), math.rad(a1.Y), math.rad(a1.Z))
end
game.ReplicatedStorage.Remotes.FreeKick.OnClientEvent:Connect(
    function()
        --[[
          line: 98
          upvalues:
            u1 (copy, index: 1)
            CurrentCamera_upv_1 (copy, index: 3)
            u6 (copy, index: 4)
            u8 (copy, index: 5)
            RunService_upv_1 (copy, index: 6)
            UserInputService_upv_1 (copy, index: 7)
            u2 (ref,  index: 8)
            COUNTDOWN_upv_1 (copy, index: 9)
            ConfirmButton_upv_1 (copy, index: 10)
            u7 (copy, index: 11)
            Bar_upv_1 (copy, index: 12)
        ]]
        if not u1 then
            return
        end
        local Ball_upv_1 = game.Workspace.Temp:FindFirstChild("Ball")
        if not Ball_upv_1 then
            return
        end
        local u9 = Instance.new("Folder")
        u9.Name = "CameraOverride"
        u9.Parent = u1.Status
        task.spawn(
            function()
                --[[
                  line: 110
                  upvalues:
                    CurrentCamera_upv_1 (copy, index: 1)
                ]]
                repeat
                    CurrentCamera_upv_1.CameraType = Enum.CameraType.Scriptable
                    wait()
                until CurrentCamera_upv_1.CameraType == Enum.CameraType.Scriptable
            end
        )
        u6:Play()
        local u10 = 0
        CurrentCamera_upv_1.CFrame = (Ball_upv_1.CFrame * radifyVector(Vector3.new(0, 3, 0) * u10)) * u8
        local v10 = RunService_upv_1.RenderStepped:Connect(
            function(a1)
                --[[
                  line: 121
                  upvalues:
                    UserInputService_upv_1 (copy, index: 1)
                    u10 (ref,  index: 2)
                    CurrentCamera_upv_1 (copy, index: 3)
                    Ball_upv_1 (copy, index: 4)
                    u8 (copy, index: 5)
                ]]
                if UserInputService_upv_1:IsKeyDown("D") then
                    u10 = u10 + (30 * a1)
                elseif UserInputService_upv_1:IsKeyDown("A") then
                    u10 = u10 - (30 * a1)
                end
                if u10 > 120 then
                    u10 = 120
                end
                if u10 < -120 then
                    u10 = -120
                end
                CurrentCamera_upv_1.CFrame = (Ball_upv_1.CFrame * radifyVector(Vector3.new(0, 3, 0) * u10)) * u8
            end
        )
        task.wait(3)
        pullUp()
        local u11 = false
        local u12 = false
        local v11 = u2.Frame.MouseEnter:Connect(
            function()
                --[[
                  line: 139
                  upvalues:
                    u11 (ref, index: 1)
                ]]
                u11 = true
            end
        )
        local v12 = u2.Frame.MouseLeave:Connect(
            function()
                --[[
                  line: 142
                  upvalues:
                    u11 (ref, index: 1)
                    u12 (ref, index: 2)
                ]]
                u11 = false
                u12 = false
            end
        )
        local v13 = UserInputService_upv_1.InputBegan:Connect(
            function(a2)
                --[[
                  line: 147
                  upvalues:
                    u11 (ref, index: 1)
                    u12 (ref, index: 2)
                    u2 (ref, index: 3)
                ]]
                if u11 == false then
                    return
                end
                if a2.UserInputType == Enum.UserInputType.MouseButton1 then
                    u12 = not u12
                    local TweenService_8 = game:GetService("TweenService")
                    local Frame_1 = u2.Frame
                    local v14 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tbl_8 = {}
                    tbl_8.BackgroundColor3 = Color3.new(1, 1, 1)
                    TweenService_8:Create(Frame_1, v14, tbl_8):Play()
                    task.delay(
                        0.1,
                        function()
                            --[[
                              line: 154
                              upvalues:
                                u2 (ref, index: 1)
                            ]]
                            local TweenService_9 = game:GetService("TweenService")
                            local Frame_2 = u2.Frame
                            local v15 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                            local tbl_9 = {}
                            tbl_9.BackgroundColor3 = Color3.new(0, 0, 0)
                            TweenService_9:Create(Frame_2, v15, tbl_9):Play()
                        end
                    )
                end
            end
        )
        local u13 = Vector2.new(0, 0)
        local v16 = RunService_upv_1.RenderStepped:Connect(
            function()
                --[[
                  line: 163
                  upvalues:
                    u12 (ref,  index: 1)
                    u11 (ref,  index: 2)
                    UserInputService_upv_1 (copy, index: 3)
                    u13 (ref,  index: 4)
                    u2 (ref,  index: 5)
                ]]
                if u12 ~= true then
                    return
                end
                if u11 == true then
                    local v17 = UserInputService_upv_1:GetMouseLocation() - Vector2.new(608.5, 463)
                    if v17.X < 0 then
                        v17 = Vector2.new(0, v17.Y)
                    end
                    if v17.X > 1 then
                        v17 = Vector2.new(1, v17.Y)
                    end
                    if v17.Y < 0 then
                        v17 = Vector2.new(v17.X, 0)
                    end
                    if v17.Y > 1 then
                        v17 = Vector2.new(v17.Y, 1)
                    end
                    u13 = Vector2.new(v17.X, v17.Y)
                    local CursorPoint_1 = u2.Frame.CursorPoint
                    CursorPoint_1.Position = UDim2.new(v17.X, 0, v17.Y, 0)
                end
            end
        )
        local u14 = Instance.new("BindableEvent")
        local u15 = false
        task.spawn(
            function()
                --[[
                  line: 185
                  upvalues:
                    COUNTDOWN_upv_1 (copy, index: 1)
                    u15 (ref,  index: 2)
                    u14 (copy, index: 3)
                ]]
                local v18 = 10
                COUNTDOWN_upv_1.Text = v18
                for _ = 1, 10 do
                    task.wait(1)
                    if u15 ~= true then
                        v18 = v18 - 1
                        COUNTDOWN_upv_1.Text = v18
                        continue
                    end
                    return
                end
                u14:Fire()
            end
        )
        local v19 = ConfirmButton_upv_1.MouseButton1Click:Connect(
            function()
                --[[
                  line: 200
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
        v10:Disconnect()
        v11:Disconnect()
        v12:Disconnect()
        v13:Disconnect()
        v16:Disconnect()
        local TweenService_10 = game:service("TweenService")
        local v21 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_10 = {}
        tbl_10.CFrame = u1.Neck_CameraSubject.CFrame * CFrame.new(u1.Humanoid.CameraOffset.X, 0.5, 0)
        TweenService_10:Create(CurrentCamera_upv_1, v21, tbl_10):Play()
        task.delay(
            0.2,
            function()
                --[[
                  line: 217
                  upvalues:
                    CurrentCamera_upv_1 (copy, index: 1)
                    u9 (copy, index: 2)
                ]]
                repeat
                    wait()
                    CurrentCamera_upv_1.CameraType = Enum.CameraType.Custom
                until CurrentCamera_upv_1.CameraType == Enum.CameraType.Custom
                u9:Destroy()
            end
        )
        dropAway()
        v19:Disconnect()
        local u16 = false
        u6:Stop()
        u7:Play()
        local u17 = handleTiming()
        local u18 = nil
        local v22 = UserInputService_upv_1.InputBegan:Connect(
            function(a3)
                --[[
                  line: 235
                  upvalues:
                    Bar_upv_1 (copy, index: 1)
                    u16 (ref,  index: 2)
                    u17 (copy, index: 3)
                    u18 (ref,  index: 4)
                ]]
                if a3.UserInputType ~= Enum.UserInputType.MouseButton1 then
                    return
                end
                if Bar_upv_1.Position.X.Scale > 0.9 then
                    local v23 = game.ReplicatedStorage.UISounds.ui_achieve:Clone()
                    v23.Parent = game.Workspace
                    v23:Play()
                    game.Debris:AddItem(v23, 3)
                    u16 = true
                else
                    local v24 = game.ReplicatedStorage.UISounds["ui-error3"]:Clone()
                    v24.Parent = game.Workspace
                    v24:Play()
                    game.Debris:AddItem(v24, 3)
                end
                u17:Pause()
                u18:Disconnect()
            end
        )
        u18 = v22
        task.wait(0.867)
        u17:Cancel()
        u18:Disconnect()
        task.delay(
            0.4,
            function()
                --[[
                  line: 256
                ]]
                hideTimingBar()
            end
        )
        game.ReplicatedStorage.Remotes.FreeKick:FireServer(u10, u16)
        u1.HumanoidRootPart.Anchored = false
        local v25 = Instance.new("Folder")
        v25.Name = "CameraLocked"
        v25.Parent = u1.Status
        game.Debris:AddItem(0.5)
        local v26 = Instance.new("BodyVelocity")
        v26.Velocity = (Vector3.new(0, 15, 0) + (u1.HumanoidRootPart.CFrame.rightVector * -15)) + (u1.HumanoidRootPart.CFrame.lookVector * 15)
        v26.MaxForce = Vector3.new(1e+05, 1e+05, 1e+05)
        v26.Parent = u1.HumanoidRootPart
        game.Debris:AddItem(v26, 0.15)
    end
)