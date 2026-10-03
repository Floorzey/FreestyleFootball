--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/KnitInitializer
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

if not (game:IsLoaded()) then
    game.Loaded:Wait()
end
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.Start({ServicePromises = false}):andThen(
    function()
        --[[
          line: 4
        ]]
        print("Knit initialized for " .. game.Players.LocalPlayer.Name .. "'s client.")
    end
):catch(error)
local v1 = Knit_1.GetService("KeyHandlerService")
v1.setEventNameSignal:Connect(
    function(a1, a2)
        --[[
          line: 9
        ]]
        a1.Name = a2
    end
)
v1:Initialize(game.ReplicatedStorage.Remotes)