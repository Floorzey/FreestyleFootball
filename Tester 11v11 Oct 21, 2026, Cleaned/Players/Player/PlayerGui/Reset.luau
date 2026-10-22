local bindable_event = Instance.new("BindableEvent")
local starter_gui = game:GetService("StarterGui")
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key = knit.GetService("KeyHandlerService"):GetKey("Reset")

bindable_event.Event:connect(function()
    key:FireServer()
end)

local enabled = false

while true do
    enabled = enabled
        or pcall(function()
            game:GetService("StarterGui"):SetCore("ResetButtonCallback", bindable_event)
        end)

    if enabled then
        break
    end

    print("coregui being slow for ResetButtonCallback")
    wait(0.2)
end

if game.Players.LocalPlayer.UserId == 2251662460 or game.Players.LocalPlayer.UserId == 1548397120 then
    starter_gui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
else
    starter_gui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
end

starter_gui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
starter_gui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
