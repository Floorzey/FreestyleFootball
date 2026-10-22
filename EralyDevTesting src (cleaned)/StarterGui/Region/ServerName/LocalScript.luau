script.Parent.Text = game.ReplicatedStorage:WaitForChild("ServerName").Value

game.ReplicatedStorage.ServerName.Changed:Connect(function()
    script.Parent.Text = game.ReplicatedStorage:WaitForChild("ServerName").Value
end)
