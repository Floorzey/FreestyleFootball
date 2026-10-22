local client = {}
local local_player = game.Players.LocalPlayer
local _ = local_player.PlayerGui
local character = local_player.Character or local_player.CharacterAdded:Wait()

local_player.CharacterAdded:Connect(function(character_2)
    character = character_2
end)

local values = {}

for _, item in script:QueryDescendants("ModuleScript") do
    task.spawn(function()
        values[item] = require(item)
    end)
end

return client
