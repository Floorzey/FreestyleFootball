--[[
    Script Path: Game/Players/Player/PlayerGui/Menu/StatsFrame/PersonalStatsFrame/LeftFrame/roll_nationality_button/LocalScript
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local u1 = Knit_1.GetService("KeyHandlerService"):GetKey("RollNationality")
script.Parent.MouseButton1Click:Connect(
    function()
        --[[
          line: 7
          upvalues:
            u1 (copy, index: 1)
        ]]
        u1:FireServer()
    end
)