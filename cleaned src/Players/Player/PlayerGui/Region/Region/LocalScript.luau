script.Parent.Text = game.ReplicatedStorage:WaitForChild("ServerRegion").Value
game.ReplicatedStorage.ServerRegion.Changed:Connect(function()
    script.Parent.Text = game.ReplicatedStorage:WaitForChild("ServerRegion").Value
end)
