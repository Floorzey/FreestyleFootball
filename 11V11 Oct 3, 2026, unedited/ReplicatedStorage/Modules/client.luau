--[[
    Script Path: Game/ReplicatedStorage/Modules/client
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local tbl_1 = {}
local LocalPlayer_1 = game.Players.LocalPlayer
local u1 = LocalPlayer_1.Character or (LocalPlayer_1.CharacterAdded:Wait())
LocalPlayer_1.CharacterAdded:Connect(
    function(a1)
        --[[
          line: 8
          upvalues:
            u1 (ref, index: 1)
        ]]
        u1 = a1
    end
)
local tbl_upv_2 = {}
for _, value_upv_1 in script:QueryDescendants("ModuleScript") do
    task.spawn(
        function()
            --[[
              line: 15
              upvalues:
                tbl_upv_2 (copy, index: 1)
                value_upv_1 (copy, index: 2)
            ]]
            tbl_upv_2[value_upv_1] = require(value_upv_1)
        end
    )
end
return tbl_1