local player_gui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local screen_gui = Instance.new("ScreenGui")
screen_gui.Name = "ViewportUI"
screen_gui.Parent = player_gui
local viewport_frame = Instance.new("ViewportFrame")
viewport_frame.Name = "TemplateViewportFrame"
viewport_frame.Size = UDim2.new(1, 0, 1.1, 0)
viewport_frame.AnchorPoint = Vector2.new(0, 0.5)
viewport_frame.Position = UDim2.new(0, 0, 0.45, 0)
viewport_frame.BackgroundTransparency = 1
viewport_frame.Visible = false
viewport_frame.CurrentCamera = workspace.CurrentCamera
viewport_frame.Parent = screen_gui
local values = {
    HumanoidRootPart = true,
    Head = true,
    Torso = true,
    ["Left Arm"] = true,
    ["Right Arm"] = true,
    ["Left Leg"] = true,
    ["Right Leg"] = true,
    Accessory = true,
}

local function clone_instance(argument: userdata)
    local afterimage = argument:Clone()
    afterimage.Name = "afterimage"

    for _, instance in afterimage:QueryDescendants("Script") do
        instance:Destroy()
    end

    for _, instance_2 in afterimage:QueryDescendants("LocalScript") do
        instance_2:Destroy()
    end

    for _, instance_3 in afterimage:QueryDescendants("BasePart") do
        if not (values[instance_3.Name] or instance_3.Parent:IsA("Accessory")) then
            instance_3:Destroy()
        end

        instance_3.CanCollide = false
        instance_3.CanQuery = false
        instance_3.CanTouch = false
    end

    local after_image_frame = viewport_frame:Clone()
    after_image_frame.CurrentCamera = workspace.CurrentCamera
    after_image_frame.Name = "AfterImageFrame"
    after_image_frame.Visible = true
    after_image_frame.Parent = screen_gui
    afterimage.Parent = after_image_frame

    return after_image_frame
end

return function(
    argument: userdata,
    argument_2: number,
    argument_3: number,
    argument_4: number,
    argument_5: number,
    argument_6: number,
    argument_7: number,
    image_color3
)
    local archivable = argument.Archivable

    if not archivable then
        argument.Archivable = true
    end

    local enabled = true
    local enabled_2

    if image_color3 == "Rainbow" then
        image_color3 = Color3.fromHSV(math.random(), 1, 1)
        enabled_2 = true
    else
        enabled_2 = false
    end

    task.spawn(function()
        while enabled do
            local instance = clone_instance(argument)

            if typeof(image_color3) == "Color3" then
                instance.ImageColor3 = image_color3
                instance.LightColor = image_color3
            end

            if enabled_2 then
                image_color3 = Color3.fromHSV(math.random(), 1, 1)
            end

            task.spawn(function()
                for index = 0, 1 - argument_4, 0.1 do
                    instance.ImageTransparency = 1 - index
                    task.wait(argument_5 / 10)
                    local _ = index
                end

                task.wait(argument_6)

                for index_2 = argument_4, 1, 0.1 do
                    instance.ImageTransparency = index_2
                    task.wait(argument_7 / 10)
                    local _ = index_2
                end

                instance:Destroy()
            end)

            task.wait(argument_3)
        end
    end)

    task.wait(argument_2)
    enabled = false
    argument.Archivable = archivable
end
