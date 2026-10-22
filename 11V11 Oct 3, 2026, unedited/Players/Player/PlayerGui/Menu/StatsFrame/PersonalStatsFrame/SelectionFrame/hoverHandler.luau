--[[
    Script Path: Game/Players/Player/PlayerGui/Menu/StatsFrame/PersonalStatsFrame/SelectionFrame/hoverHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

local Parent_upv_1 = script.Parent
local MouseHoverModule_1 = require(game.ReplicatedStorage.Modules.MouseHoverModule)
for _, value_1 in pairs(script.Parent:GetChildren()) do
    if value_1:IsA("TextButton") then
        MouseHoverModule_1.MouseEnterLeaveEvent(value_1):Connect(
            function()
                --[[
                  line: 9
                  upvalues:
                    Parent_upv_1 (copy, index: 1)
                ]]
                if Parent_upv_1.Parent.Visible == false then
                    return
                end
                local v1 = game.ReplicatedStorage.UISounds._click:Clone()
                v1.Parent = game.Workspace
                v1:Play()
                game.Debris:AddItem(v1, 0.5)
            end
        )
    end
end