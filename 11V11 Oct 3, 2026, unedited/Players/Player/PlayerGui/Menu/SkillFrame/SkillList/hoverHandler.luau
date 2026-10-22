--[[
    Script Path: Game/Players/Player/PlayerGui/Menu/SkillFrame/SkillList/hoverHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

local Parent_upv_1 = script.Parent
local MouseHoverModule_upv_1 = require(game.ReplicatedStorage.Modules.MouseHoverModule)
for _, value_upv_1 in pairs(script.Parent:GetChildren()) do
    if value_upv_1:IsA("TextButton") then
        local v1, v2 = MouseHoverModule_upv_1.MouseEnterLeaveEvent(value_upv_1)
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
                tbl_1.Size = UDim2.new(0, 102, 0, 90)
                TweenService_1:Create(value_upv_1.skillIcon, v4, tbl_1):Play()
                local tbl_2 = {TextStrokeTransparency = 0}
                game:GetService("TweenService"):Create(value_upv_1, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tbl_2):Play()
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
                if Parent_upv_1.Parent.Visible == false then
                    return
                end
                local TweenService_2 = game:GetService("TweenService")
                local v5 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                local tbl_3 = {}
                tbl_3.Size = UDim2.new(0, 97, 0, 85)
                TweenService_2:Create(value_upv_1.skillIcon, v5, tbl_3):Play()
                local tbl_4 = {TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(value_upv_1, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tbl_4):Play()
            end
        )
    end
end
script.Parent.ChildAdded:Connect(
    function(a1)
        --[[
          line: 38
          upvalues:
            MouseHoverModule_upv_1 (copy, index: 1)
            Parent_upv_1 (copy, index: 2)
        ]]
        if a1:IsA("TextButton") then
            local v6, v7 = MouseHoverModule_upv_1.MouseEnterLeaveEvent(a1)
            v6:Connect(
                function()
                    --[[
                      line: 41
                      upvalues:
                        Parent_upv_1 (copy, index: 1)
                        a1 (copy, index: 2)
                    ]]
                    if Parent_upv_1.Parent.Visible == false then
                        return
                    end
                    local v8 = game.ReplicatedStorage.UISounds._click:Clone()
                    v8.Parent = game.Workspace
                    v8:Play()
                    game.Debris:AddItem(v8, 0.5)
                    local TweenService_3 = game:GetService("TweenService")
                    local v9 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                    local tbl_5 = {}
                    tbl_5.Size = UDim2.new(0, 102, 0, 90)
                    TweenService_3:Create(a1.skillIcon, v9, tbl_5):Play()
                    local tbl_6 = {TextStrokeTransparency = 0}
                    game:GetService("TweenService"):Create(a1, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tbl_6):Play()
                end
            )
            v7:Connect(
                function()
                    --[[
                      line: 56
                      upvalues:
                        Parent_upv_1 (copy, index: 1)
                        a1 (copy, index: 2)
                    ]]
                    if Parent_upv_1.Parent.Visible == false then
                        return
                    end
                    local TweenService_4 = game:GetService("TweenService")
                    local v10 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                    local tbl_7 = {}
                    tbl_7.Size = UDim2.new(0, 97, 0, 85)
                    TweenService_4:Create(a1.skillIcon, v10, tbl_7):Play()
                    local tbl_8 = {TextStrokeTransparency = 1}
                    game:GetService("TweenService"):Create(a1, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tbl_8):Play()
                end
            )
        end
    end
)