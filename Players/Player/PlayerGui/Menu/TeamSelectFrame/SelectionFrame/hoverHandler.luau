--[[
    Script Path: Game/Players/Player/PlayerGui/Menu/TeamSelectFrame/SelectionFrame/hoverHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

local Parent_upv_1 = script.Parent
local MouseHoverModule_1 = require(game.ReplicatedStorage.Modules.MouseHoverModule)
for _, value_upv_1 in pairs(script.Parent:GetChildren()) do
    if value_upv_1:IsA("ImageButton") then
        local v1, v2 = MouseHoverModule_1.MouseEnterLeaveEvent(value_upv_1)
        v1:Connect(
            function()
                --[[
                  line: 9
                  upvalues:
                    Parent_upv_1 (copy, index: 1)
                    value_upv_1 (copy, index: 2)
                ]]
                if Parent_upv_1.Parent.Visible == false then
                    return
                end
                local v3 = game.ReplicatedStorage.UISounds._click:Clone()
                v3.Parent = game.Workspace
                v3:Play()
                game.Debris:AddItem(v3, 0.5)
                local TweenService_1 = game:GetService("TweenService")
                local v4 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                local tbl_1 = {}
                tbl_1.Size = UDim2.new(0.55, 0, 0.55, 0)
                TweenService_1:Create(value_upv_1.Crest, v4, tbl_1):Play()
            end
        )
        v2:Connect(
            function()
                --[[
                  line: 21
                  upvalues:
                    Parent_upv_1 (copy, index: 1)
                    value_upv_1 (copy, index: 2)
                ]]
                if Parent_upv_1.Parent.Visible == false then
                    return
                end
                local TweenService_2 = game:GetService("TweenService")
                local v5 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                local tbl_2 = {}
                tbl_2.Size = UDim2.new(0.5, 0, 0.5, 0)
                TweenService_2:Create(value_upv_1.Crest, v5, tbl_2):Play()
            end
        )
    end
end