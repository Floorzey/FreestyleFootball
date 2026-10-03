--[[
    Script Path: Game/Players/Player/PlayerGui/Menu/PosSelectFrame/SelectionFrame/hoverHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

local Parent_upv_1 = script.Parent
local MouseHoverModule_1 = require(game.ReplicatedStorage.Modules.MouseHoverModule)
for _, value_1 in pairs(script.Parent:GetChildren()) do
    if value_1:IsA("TextButton") then
        local v1, v2 = MouseHoverModule_1.MouseEnterLeaveEvent(value_1)
        v1:Connect(
            function()
                --[[
                  line: 9
                  upvalues:
                    Parent_upv_1 (copy, index: 1)
                ]]
                if Parent_upv_1.Parent.Visible == false then
                    return
                end
                local v3 = game.ReplicatedStorage.UISounds._click:Clone()
                v3.Parent = game.Workspace
                v3:Play()
                game.Debris:AddItem(v3, 0.5)
            end
        )
        v2:Connect(
            function()
                --[[
                  line: 19
                  upvalues:
                    Parent_upv_1 (copy, index: 1)
                ]]
                if Parent_upv_1.Parent.Visible ~= false then
                    return
                end
            end
        )
    end
end