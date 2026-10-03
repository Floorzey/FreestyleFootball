--[[
    Script Path: Game/StarterGui/Region/Region/LocalScript
    Class: LocalScript
    Time: 2026-10-03 12:27:09
--]]

script.Parent.Text = game.ReplicatedStorage:WaitForChild("ServerRegion").Value
game.ReplicatedStorage.ServerRegion.Changed:Connect(
    function()
        --[[
          line: 2
        ]]
        script.Parent.Text = game.ReplicatedStorage:WaitForChild("ServerRegion").Value
    end
)