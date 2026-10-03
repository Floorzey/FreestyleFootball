--[[
    Script Path: Game/StarterGui/Menu/MenuButtons/hoverHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:09
--]]

local Parent_upv_1 = script.Parent
local MouseHoverModule_1 = require(game.ReplicatedStorage.Modules.MouseHoverModule)
for _, value_upv_1 in pairs(script.Parent:GetChildren()) do
    if value_upv_1:IsA("TextButton") then
        local v1, v2 = MouseHoverModule_1.MouseEnterLeaveEvent(value_upv_1)
        v1:Connect(
            function()
                --[[
                  line: 9
                  upvalues:
                    Parent_upv_1 (copy, index: 1)
                    value_upv_1 (copy, index: 2)
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
                local tbl_1 = {}
                tbl_1.Size = UDim2.new(0, 125, 0, 125)
                TweenService_1:Create(value_upv_1, v4, tbl_1):Play()
                local TweenService_2 = game:GetService("TweenService")
                local v5 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                local tbl_2 = {}
                tbl_2.Size = UDim2.new(0, 110, 0, 85)
                TweenService_2:Create(value_upv_1.ImageLabel, v5, tbl_2):Play()
            end
        )
        v2:Connect(
            function()
                --[[
                  line: 24
                  upvalues:
                    Parent_upv_1 (copy, index: 1)
                    value_upv_1 (copy, index: 2)
                ]]
                if Parent_upv_1.Visible == false then
                    return
                end
                local TweenService_3 = game:GetService("TweenService")
                local v6 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                local tbl_3 = {}
                tbl_3.Size = UDim2.new(0, 112, 0, 112)
                TweenService_3:Create(value_upv_1, v6, tbl_3):Play()
                local TweenService_4 = game:GetService("TweenService")
                local v7 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                local tbl_4 = {}
                tbl_4.Size = UDim2.new(0, 100, 0, 75)
                TweenService_4:Create(value_upv_1.ImageLabel, v7, tbl_4):Play()
            end
        )
    end
end