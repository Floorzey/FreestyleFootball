--[[
    Script Path: Game/StarterGui/Menu/PlayButton/hoverHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:09
--]]

local Parent_upv_1 = script.Parent
local PlayButton_upv_1 = script.Parent.PlayButton
local MouseHoverModule_1 = require(game.ReplicatedStorage.Modules.MouseHoverModule)
local hasGameStarted_upv_1 = game.ReplicatedStorage.hasGameStarted
if hasGameStarted_upv_1.Value == true then
    PlayButton_upv_1.Text = "PLAY"
    PlayButton_upv_1.BackgroundColor3 = Color3.new(0, 0.66667, 0)
end
local v1, v2 = MouseHoverModule_1.MouseEnterLeaveEvent(PlayButton_upv_1)
v1:Connect(
    function()
        --[[
          line: 12
          upvalues:
            Parent_upv_1 (copy, index: 1)
            PlayButton_upv_1 (copy, index: 2)
        ]]
        if Parent_upv_1.Visible == false then
            return
        end
        local v3 = game.ReplicatedStorage.UISounds._click:Clone()
        v3.Parent = game.Workspace
        v3:Play()
        game.Debris:AddItem(v3, 0.5)
        local TweenService_1 = game:GetService("TweenService")
        local v4 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local tbl_1 = {TextSize = 32}
        tbl_1.Size = UDim2.new(0, 265, 0, 52)
        TweenService_1:Create(PlayButton_upv_1, v4, tbl_1):Play()
    end
)
v2:Connect(
    function()
        --[[
          line: 25
          upvalues:
            Parent_upv_1 (copy, index: 1)
            PlayButton_upv_1 (copy, index: 2)
        ]]
        if Parent_upv_1.Visible == false then
            return
        end
        local TweenService_2 = game:GetService("TweenService")
        local v5 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local tbl_2 = {TextSize = 28}
        tbl_2.Size = UDim2.new(0, 250, 0, 44)
        TweenService_2:Create(PlayButton_upv_1, v5, tbl_2):Play()
    end
)
game.ReplicatedStorage.hasGameStarted.Changed:Connect(
    function()
        --[[
          line: 35
          upvalues:
            hasGameStarted_upv_1 (copy, index: 1)
            PlayButton_upv_1 (copy, index: 2)
        ]]
        if hasGameStarted_upv_1.Value ~= false then
            PlayButton_upv_1.Text = "PLAY"
            local TweenService_3 = game:GetService("TweenService")
            local v6 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            local tbl_3 = {}
            tbl_3.BackgroundColor3 = Color3.new(0, 0.66667, 0)
            TweenService_3:Create(PlayButton_upv_1, v6, tbl_3):Play()
        else
            PlayButton_upv_1.Text = "SELECT TEAM"
            local TweenService_4 = game:GetService("TweenService")
            local v7 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            local tbl_4 = {}
            tbl_4.BackgroundColor3 = Color3.new(0.66667, 0.66667, 0)
            TweenService_4:Create(PlayButton_upv_1, v7, tbl_4):Play()
        end
    end
)