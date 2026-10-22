repeat
    task.wait()
until game:IsLoaded()

script.Parent.Parent.Visible = true
local number = 1
local enabled = false

script.Parent.MouseButton1Click:Connect(function()
    if enabled then
        return
    end

    number = number + 1

    if number ~= 2 then
        script.Parent.Parent:Destroy()

        return
    end

    enabled = true
    script.Parent.Parent.Frame.Title.Text = "Passive Info"
    script.Parent.Parent.Frame.TextLabel.Visible = false
    script.Parent.Parent.Frame.TextLabel2.Visible = true
    script.Parent.Text = "I Understand. (5)"
    task.wait(1)
    script.Parent.Text = "I Understand. (4)"
    task.wait(1)
    script.Parent.Text = "I Understand. (3)"
    task.wait(1)
    script.Parent.Text = "I Understand. (2)"
    task.wait(1)
    script.Parent.Text = "I Understand. (1)"
    task.wait(1)
    enabled = false
    script.Parent.Text = "I Understand. "
end)
