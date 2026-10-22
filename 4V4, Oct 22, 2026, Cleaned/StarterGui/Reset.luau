local bindable_event = Instance.new("BindableEvent")
local starter_gui = game:GetService("StarterGui")

bindable_event.Event:connect(function()
    game.ReplicatedStorage.Remotes.Reset:FireServer()
end)

local enabled = false

while not enabled do
    local success = pcall(function()
        game:GetService("StarterGui"):SetCore("ResetButtonCallback", bindable_event)
    end)

    if success then
        break
    else
        print("coregui being slow for ResetButtonCallback")
        wait(0.2)
        enabled = success
    end
end

starter_gui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
starter_gui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
starter_gui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
