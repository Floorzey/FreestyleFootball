--[[
    Script Path: Game/StarterGui/Region/ServerName/LocalScript
    Class: LocalScript
    Time: 2026-10-03 12:27:09
--]]

script.Parent.Text = game.ReplicatedStorage:WaitForChild("ServerName").Value
game.ReplicatedStorage.ServerName.Changed:Connect(
    function()
        --[[
          line: 2
        ]]
        script.Parent.Text = game.ReplicatedStorage:WaitForChild("ServerName").Value
    end
)