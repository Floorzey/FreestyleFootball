--[[
    Script Path: Game/Players/Player/PlayerGui/Notifications/Handler
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

local OOB_upv_1 = script.Parent.OOB
local OFFSIDES_upv_1 = script.Parent.OFFSIDES
local DOUBLETOUCH_upv_1 = script.Parent.DOUBLETOUCH
local GOAL_upv_1 = script.Parent.GOAL
local TeamSteal_upv_1 = script.Parent.TeamSteal
local SELFGOAL_upv_1 = script.Parent.SELFGOAL
local UpperShutter_upv_1 = script.Parent.UpperShutter
local LowerShutter_upv_1 = script.Parent.LowerShutter
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local v1 = Knit_1.GetService("KeyHandlerService")
function shutter()
    --[[
      name: shutter
      line: 15
      upvalues:
        UpperShutter_upv_1 (copy, index: 1)
        LowerShutter_upv_1 (copy, index: 2)
        OOB_upv_1 (copy, index: 3)
        GOAL_upv_1 (copy, index: 4)
        SELFGOAL_upv_1 (copy, index: 5)
    ]]
    if game.Players.LocalPlayer:GetAttribute("Freecam") then
        return
    end
    UpperShutter_upv_1.Visible = true
    LowerShutter_upv_1.Visible = true
    local TweenService_1 = game:GetService("TweenService")
    local v2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_1 = {}
    tbl_1.Size = UDim2.new(1, 0, 0.7, 0)
    TweenService_1:Create(LowerShutter_upv_1, v2, tbl_1):Play()
    local TweenService_2 = game:GetService("TweenService")
    local v3 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_2 = {}
    tbl_2.Size = UDim2.new(1, 0, 0.7, 0)
    TweenService_2:Create(UpperShutter_upv_1, v3, tbl_2):Play()
    task.delay(
        0.5,
        function()
            --[[
              line: 25
              upvalues:
                OOB_upv_1 (copy, index: 1)
                GOAL_upv_1 (copy, index: 2)
                SELFGOAL_upv_1 (copy, index: 3)
                LowerShutter_upv_1 (copy, index: 4)
                UpperShutter_upv_1 (copy, index: 5)
            ]]
            game.Lighting.Blur.Size = 2
            OOB_upv_1.Visible = false
            GOAL_upv_1.Visible = false
            SELFGOAL_upv_1.Visible = false
            task.wait(0.5)
            local TweenService_3 = game:GetService("TweenService")
            local v4 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_3 = {}
            tbl_3.Size = UDim2.new(1, 0, 0, 0)
            TweenService_3:Create(LowerShutter_upv_1, v4, tbl_3):Play()
            local TweenService_4 = game:GetService("TweenService")
            local v5 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_4 = {}
            tbl_4.Size = UDim2.new(1, 0, 0, 0)
            TweenService_4:Create(UpperShutter_upv_1, v5, tbl_4):Play()
            task.wait(0.5)
            UpperShutter_upv_1.Visible = false
            LowerShutter_upv_1.Visible = false
        end
    )
end
v1:GetKey("OOBClient").OnClientEvent:Connect(
    function(a1)
        --[[
          line: 43
          upvalues:
            OOB_upv_1 (copy, index: 1)
        ]]
        OOB_upv_1.Visible = true
        OOB_upv_1.Size = UDim2.new(0, 0, 0, 0)
        OOB_upv_1.OOB.Text = "OUT OF BOUNDS"
        if a1 ~= nil then
            OOB_upv_1.playerName.Text = a1
        else
            OOB_upv_1.playerName.Text = "<PLAYER LEFT>"
        end
        local tbl_5 = {TextTransparency = 0, TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(OOB_upv_1.OOB, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_5):Play()
        local tbl_6 = {TextTransparency = 0, TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(OOB_upv_1.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_6):Play()
        task.delay(
            2,
            function()
                --[[
                  line: 60
                  upvalues:
                    OOB_upv_1 (copy, index: 1)
                ]]
                local tbl_7 = {TextTransparency = 1, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(OOB_upv_1.OOB, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_7):Play()
                local tbl_8 = {TextTransparency = 1, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(OOB_upv_1.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_8):Play()
                task.wait(0.5)
                OOB_upv_1.Visible = false
            end
        )
    end
)
v1:GetKey("FoulClient").OnClientEvent:Connect(
    function(a1)
        --[[
          line: 74
          upvalues:
            OOB_upv_1 (copy, index: 1)
        ]]
        OOB_upv_1.Visible = true
        OOB_upv_1.Size = UDim2.new(0, 0, 0, 0)
        OOB_upv_1.OOB.Text = "FOUL"
        if a1 ~= nil then
            OOB_upv_1.playerName.Text = a1
        else
            OOB_upv_1.playerName.Text = "<PLAYER LEFT>"
        end
        local tbl_9 = {TextTransparency = 0, TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(OOB_upv_1.OOB, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_9):Play()
        local tbl_10 = {TextTransparency = 0, TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(OOB_upv_1.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_10):Play()
        task.delay(
            2,
            function()
                --[[
                  line: 91
                  upvalues:
                    OOB_upv_1 (copy, index: 1)
                ]]
                local tbl_11 = {TextTransparency = 1, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(OOB_upv_1.OOB, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_11):Play()
                local tbl_12 = {TextTransparency = 1, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(OOB_upv_1.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_12):Play()
                task.wait(0.5)
                OOB_upv_1.Visible = false
            end
        )
    end
)
v1:GetKey("OffsidesClient").OnClientEvent:Connect(
    function(a1)
        --[[
          line: 105
          upvalues:
            OFFSIDES_upv_1 (copy, index: 1)
        ]]
        OFFSIDES_upv_1.Visible = true
        OFFSIDES_upv_1.Size = UDim2.new(0, 0, 0, 0)
        if a1 ~= nil then
            OFFSIDES_upv_1.playerName.Text = a1
        else
            OFFSIDES_upv_1.playerName.Text = "<PLAYER LEFT>"
        end
        local tbl_13 = {TextTransparency = 0, TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(OFFSIDES_upv_1.OFFSIDE, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_13):Play()
        local tbl_14 = {TextTransparency = 0, TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(OFFSIDES_upv_1.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_14):Play()
        task.delay(
            2,
            function()
                --[[
                  line: 121
                  upvalues:
                    OFFSIDES_upv_1 (copy, index: 1)
                ]]
                local tbl_15 = {TextTransparency = 1, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(OFFSIDES_upv_1.OFFSIDE, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_15):Play()
                local tbl_16 = {TextTransparency = 1, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(OFFSIDES_upv_1.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_16):Play()
                task.wait(0.5)
                OFFSIDES_upv_1.Visible = false
            end
        )
    end
)
v1:GetKey("TeamStealNotification").OnClientEvent:Connect(
    function(a1)
        --[[
          line: 135
          upvalues:
            TeamSteal_upv_1 (copy, index: 1)
        ]]
        local v6 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
        v6.Parent = game.Workspace
        v6:Play()
        game.Debris:AddItem(v6, 3)
        TeamSteal_upv_1.Visible = true
        TeamSteal_upv_1.Size = UDim2.new(0, 0, 0, 0)
        local tbl_17 = {TextTransparency = 0, TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(TeamSteal_upv_1.TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_17):Play()
        task.delay(
            2,
            function()
                --[[
                  line: 146
                  upvalues:
                    TeamSteal_upv_1 (copy, index: 1)
                ]]
                local tbl_18 = {TextTransparency = 1, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(TeamSteal_upv_1.TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_18):Play()
                task.wait(0.5)
                TeamSteal_upv_1.Visible = false
            end
        )
    end
)
v1:GetKey("NotifClient").OnClientEvent:Connect(
    function(a1, a2)
        --[[
          line: 157
          upvalues:
            DOUBLETOUCH_upv_1 (copy, index: 1)
        ]]
        DOUBLETOUCH_upv_1.Visible = true
        DOUBLETOUCH_upv_1.Size = UDim2.new(0, 0, 0, 0)
        if a1 ~= nil then
            DOUBLETOUCH_upv_1.playerName.Text = a1
        else
            DOUBLETOUCH_upv_1.playerName.Text = "<PLAYER LEFT>"
        end
        DOUBLETOUCH_upv_1.TOUCH.Text = a2
        local tbl_19 = {TextTransparency = 0, TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(DOUBLETOUCH_upv_1.TOUCH, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_19):Play()
        local tbl_20 = {TextTransparency = 0, TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(DOUBLETOUCH_upv_1.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_20):Play()
        task.delay(
            2,
            function()
                --[[
                  line: 174
                  upvalues:
                    DOUBLETOUCH_upv_1 (copy, index: 1)
                ]]
                local tbl_21 = {TextTransparency = 1, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(DOUBLETOUCH_upv_1.TOUCH, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_21):Play()
                local tbl_22 = {TextTransparency = 1, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(DOUBLETOUCH_upv_1.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_22):Play()
                task.wait(0.5)
                DOUBLETOUCH_upv_1.Visible = false
            end
        )
    end
)
v1:GetKey("GoalClient").OnClientEvent:Connect(
    function(a1, a2, a3)
        --[[
          line: 190
          upvalues:
            GOAL_upv_1 (copy, index: 1)
        ]]
        GOAL_upv_1.Visible = true
        GOAL_upv_1.Size = UDim2.new(0, 0, 0, 5)
        if a1 ~= nil then
            GOAL_upv_1.playerName.Text = a1.DisplayName
        else
            GOAL_upv_1.playerName.Text = "<PLAYER LEFT>"
        end
        local tbl_23 = {Size = 20}
        game:GetService("TweenService"):Create(game.Lighting.Blur, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_23):Play()
        local TweenService_5 = game:GetService("TweenService")
        local v7 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_24 = {}
        tbl_24.Size = UDim2.new(1, 0, 0, 5)
        TweenService_5:Create(GOAL_upv_1, v7, tbl_24):Play()
        task.delay(
            0.5,
            function()
                --[[
                  line: 205
                  upvalues:
                    GOAL_upv_1 (copy, index: 1)
                    a1 (copy, index: 2)
                ]]
                local TweenService_6 = game:GetService("TweenService")
                local v8 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_25 = {}
                tbl_25.Size = UDim2.new(1, 0, 0, 75)
                TweenService_6:Create(GOAL_upv_1, v8, tbl_25):Play()
                task.delay(
                    2,
                    function()
                        --[[
                          line: 209
                          upvalues:
                            GOAL_upv_1 (copy, index: 1)
                            a1 (copy, index: 2)
                        ]]
                        local TweenService_7 = game:GetService("TweenService")
                        local v9 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        local tbl_26 = {}
                        tbl_26.Size = UDim2.new(1, 0, 0, 5)
                        TweenService_7:Create(GOAL_upv_1, v9, tbl_26):Play()
                        shutter()
                        task.wait(0.55)
                        script.Parent.LowerCinematicBar.Visible = true
                        script.Parent.UpperCinematicBar.Visible = true
                        game.Workspace.CurrentCamera.CameraSubject = a1.Character.Humanoid
                        task.wait(5.5)
                        shutter()
                        script.Parent.LowerCinematicBar.Visible = false
                        script.Parent.UpperCinematicBar.Visible = false
                        game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Neck_CameraSubject
                    end
                )
            end
        )
    end
)
v1:GetKey("SelfGoalClient").OnClientEvent:Connect(
    function(a1)
        --[[
          line: 228
          upvalues:
            SELFGOAL_upv_1 (copy, index: 1)
        ]]
        SELFGOAL_upv_1.Visible = true
        SELFGOAL_upv_1.Size = UDim2.new(0, 0, 0, 5)
        if a1 ~= nil then
            SELFGOAL_upv_1.playerName.Text = a1
        else
            SELFGOAL_upv_1.playerName.Text = "<PLAYER LEFT>"
        end
        local tbl_27 = {Size = 20}
        game:GetService("TweenService"):Create(game.Lighting.Blur, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_27):Play()
        local TweenService_8 = game:GetService("TweenService")
        local v10 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_28 = {}
        tbl_28.Size = UDim2.new(1, 0, 0, 5)
        TweenService_8:Create(SELFGOAL_upv_1, v10, tbl_28):Play()
        task.delay(
            0.5,
            function()
                --[[
                  line: 242
                  upvalues:
                    SELFGOAL_upv_1 (copy, index: 1)
                ]]
                local TweenService_9 = game:GetService("TweenService")
                local v11 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_29 = {}
                tbl_29.Size = UDim2.new(1, 0, 0, 75)
                TweenService_9:Create(SELFGOAL_upv_1, v11, tbl_29):Play()
                task.delay(
                    2,
                    function()
                        --[[
                          line: 246
                          upvalues:
                            SELFGOAL_upv_1 (copy, index: 1)
                        ]]
                        local TweenService_10 = game:GetService("TweenService")
                        local v12 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        local tbl_30 = {}
                        tbl_30.Size = UDim2.new(1, 0, 0, 5)
                        TweenService_10:Create(SELFGOAL_upv_1, v12, tbl_30):Play()
                        shutter()
                    end
                )
            end
        )
    end
)
function shutterEventFunc()
    --[[
      name: shutterEventFunc
      line: 255
      upvalues:
        UpperShutter_upv_1 (copy, index: 1)
        LowerShutter_upv_1 (copy, index: 2)
    ]]
    UpperShutter_upv_1.Visible = true
    LowerShutter_upv_1.Visible = true
    local TweenService_11 = game:GetService("TweenService")
    local v13 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_31 = {}
    tbl_31.Size = UDim2.new(1, 0, 0.55, 0)
    TweenService_11:Create(LowerShutter_upv_1, v13, tbl_31):Play()
    local TweenService_12 = game:GetService("TweenService")
    local v14 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_32 = {}
    tbl_32.Size = UDim2.new(1, 0, 0.55, 0)
    TweenService_12:Create(UpperShutter_upv_1, v14, tbl_32):Play()
    task.delay(
        0.5,
        function()
            --[[
              line: 264
              upvalues:
                LowerShutter_upv_1 (copy, index: 1)
                UpperShutter_upv_1 (copy, index: 2)
            ]]
            task.wait(0.5)
            local TweenService_13 = game:GetService("TweenService")
            local v15 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_33 = {}
            tbl_33.Size = UDim2.new(1, 0, 0, 0)
            TweenService_13:Create(LowerShutter_upv_1, v15, tbl_33):Play()
            local TweenService_14 = game:GetService("TweenService")
            local v16 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_34 = {}
            tbl_34.Size = UDim2.new(1, 0, 0, 0)
            TweenService_14:Create(UpperShutter_upv_1, v16, tbl_34):Play()
            task.wait(0.5)
            UpperShutter_upv_1.Visible = false
            LowerShutter_upv_1.Visible = false
        end
    )
end
v1:GetKey("Shutter").OnClientEvent:Connect(shutterEventFunc)
game.ReplicatedStorage.Shutter.Event:Connect(shutterEventFunc)
v1:GetKey("GainPointsNotification").OnClientEvent:Connect(
    function(a1)
        --[[
          line: 281
        ]]
        local v17 = game.ReplicatedStorage.UISounds.notification_sound_previs1:Clone()
        v17.Parent = game.Workspace
        v17:Play()
        game.Debris:AddItem(v17, 5)
        local u1 = script.PointNotifications:Clone()
        u1.Parent = script.Parent.PointNotificationFrame
        u1.Text = a1
        local tbl_35 = {TextTransparency = 0, TextStrokeTransparency = 0}
        game:GetService("TweenService"):Create(u1, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_35):Play()
        task.delay(
            1,
            function()
                --[[
                  line: 293
                  upvalues:
                    u1 (copy, index: 1)
                ]]
                local tbl_36 = {TextTransparency = 1, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(u1, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_36):Play()
                task.wait(0.8)
                u1.Visible = false
            end
        )
        game.Debris:AddItem(u1, 3)
    end
)