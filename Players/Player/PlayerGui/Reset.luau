--[[
    Script Path: Game/Players/Player/PlayerGui/Reset
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

local u1 = Instance.new("BindableEvent")
local StarterGui_1 = game:GetService("StarterGui")
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local u2 = Knit_1.GetService("KeyHandlerService"):GetKey("Reset")
u1.Event:connect(
    function()
        --[[
          line: 10
          upvalues:
            u2 (copy, index: 1)
        ]]
        u2:FireServer()
    end
)
local v1 = false
while not (v1) do
    local success_1 = pcall(
        function()
            --[[
              line: 17
              upvalues:
                u1 (copy, index: 1)
            ]]
            game:GetService("StarterGui"):SetCore("ResetButtonCallback", u1)
        end
    )
    if success_1 then
        break
    else
        print("coregui being slow for ResetButtonCallback")
        wait(0.2)
        v1 = success_1
    end
end
if game.Players.LocalPlayer.UserId == 2251662460 or game.Players.LocalPlayer.UserId == 1548397120 then
    StarterGui_1:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
else
    StarterGui_1:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
end
StarterGui_1:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
StarterGui_1:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)