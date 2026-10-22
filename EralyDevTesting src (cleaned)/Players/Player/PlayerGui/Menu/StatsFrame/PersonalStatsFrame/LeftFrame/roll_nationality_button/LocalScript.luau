local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key = knit.GetService("KeyHandlerService"):GetKey("RollNationality")

script.Parent.MouseButton1Click:Connect(function()
    key:FireServer()
end)
