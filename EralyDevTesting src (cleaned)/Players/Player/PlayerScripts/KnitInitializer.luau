if not game:IsLoaded() then
    game.Loaded:Wait()
end

local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.Start({
    ServicePromises = false,
})
    :andThen(function()
        print("Knit initialized for " .. game.Players.LocalPlayer.Name .. "'s client.")
    end)
    :catch(error)
local network = require("@game/ReplicatedStorage/Modules/network")

game.RunService.RenderStepped:Connect(function()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        network.unreliable:FireServer(game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame)
    end
end)

local key_handler_service = knit.GetService("KeyHandlerService")

key_handler_service.setEventNameSignal:Connect(function(argument, name)
    argument.Name = name
end)

key_handler_service:Initialize(game.ReplicatedStorage.Remotes)
