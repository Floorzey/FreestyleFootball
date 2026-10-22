local run_service = game:GetService("RunService")
local candy_handler = {
    SpinSpeed = 90,
    BobHeight = 0.5,
    BobSpeed = 0.5,
    MaxAnimateDistance = 150,
}
local is_client_result = run_service:IsClient()
local values = {}
local connection = nil

local function moved_externally(argument, argument_2)
    return (
        (argument.Position - argument_2.Position).Magnitude > 0.001
        or argument.LookVector:Dot(argument_2.LookVector) < 0.9999
    )
            and true
        or argument.UpVector:Dot(argument_2.UpVector) < 0.9999
end

local function step()
    local current_camera

    if is_client_result then
        current_camera = workspace.CurrentCamera
    else
        current_camera = nil
    end

    local position

    if current_camera then
        position = current_camera.CFrame.Position
    else
        position = nil
    end

    local max_animate_distance = candy_handler.MaxAnimateDistance
    local server_time_now = workspace:GetServerTimeNow()

    for key, item in values do
        local pivot = key:GetPivot()

        if item.lastWritten then
            local last_written = item.lastWritten

            if
                (
                        (pivot.Position - last_written.Position).Magnitude > 0.001
                        or pivot.LookVector:Dot(last_written.LookVector) < 0.9999
                    )
                    and true
                or pivot.UpVector:Dot(last_written.UpVector) < 0.9999
            then
                item.restPosition = pivot.Position
                item.restRotation = pivot.Rotation
            end
        end

        if not position or max_animate_distance >= (position - item.restPosition).Magnitude then
            local options = item.options
            local spin_speed = options.SpinSpeed or candy_handler.SpinSpeed
            local bob_height = options.BobHeight or candy_handler.BobHeight
            local product = (
                math.sin(server_time_now * (options.BobSpeed or candy_handler.BobSpeed) * 2 * 3.141592653589793) + 1
            )
                * 0.5
                * bob_height
            local radians = math.rad(server_time_now * spin_speed % 360)
            local last_written_2 = CFrame.new(item.restPosition + Vector3.new(0, product, 0))
                * CFrame.Angles(0, radians, 0)
                * item.restRotation
            key:PivotTo(last_written_2)
            item.lastWritten = last_written_2
        end
    end
end

local function start_loop()
    if connection then
        return
    end

    local render_stepped

    if is_client_result then
        render_stepped = run_service.RenderStepped
    else
        render_stepped = run_service.Heartbeat
    end

    connection = render_stepped:Connect(step)
end

local function stop_loop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

function candy_handler.Init(argument)
    workspace:WaitForChild("gameArea"):WaitForChild("Candies").ChildAdded:Connect(function(child)
        candy_handler:Add(child, {
            SpinSpeed = candy_handler.SpinSpeed,
            BobSpeed = candy_handler.BobSpeed,
            BobHeight = candy_handler.BobHeight,
        })
    end)

    workspace:WaitForChild("gameArea"):WaitForChild("Candies").ChildRemoved:Connect(function(child)
        if not child then
            return
        end

        if not child.CFrame then
            return
        end

        local parent = game.ReplicatedStorage.Models.candycorn:Clone()
        parent.Parent = workspace.Temp
        parent.CFrame = child.CFrame
        local clone = game.ReplicatedStorage.SFX.CandyGrab:Clone()
        clone.Parent = parent
        clone:Play()
        game.TweenService
            :Create(parent, TweenInfo.new(2.472, Enum.EasingStyle.Linear), {
                Transparency = 1,
                CFrame = parent.CFrame * CFrame.Angles(0, 4.537856055185257, 0),
            })
            :Play()
        task.wait(2.472)
        parent:Destroy()
    end)
end

function candy_handler.Add(argument: table, instance: userdata, argument_2: table?)
    local value_entry = values[instance]

    if value_entry then
        if argument_2 then
            for key, item in argument_2 do
                value_entry.options[key] = item
            end
        end

        return
    end

    if instance:IsA("BasePart") and not instance.Anchored then
        warn(`{instance:GetFullName()} isn't Anchored, so physics will fight the animation`)
    end

    local pivot = instance:GetPivot()
    values[instance] = {
        lastWritten = nil,
        restPosition = pivot.Position,
        restRotation = pivot.Rotation,
        options = table.clone(argument_2 or {}),
        ancestryConnection = instance.AncestryChanged:Connect(function()
            if not instance:IsDescendantOf(game) then
                candy_handler:Remove(instance)
            end
        end),
    }

    if connection then
        return
    end

    local render_stepped

    if is_client_result then
        render_stepped = run_service.RenderStepped
    else
        render_stepped = run_service.Heartbeat
    end

    connection = render_stepped:Connect(step)
end

function candy_handler.Remove(argument: table, instance: userdata)
    local value_entry = values[instance]

    if not value_entry then
        return
    end

    values[instance] = nil
    value_entry.ancestryConnection:Disconnect()

    if instance:IsDescendantOf(game) then
        instance:PivotTo(CFrame.new(value_entry.restPosition) * value_entry.restRotation)
    end

    if next(values) == nil and connection then
        connection:Disconnect()
        connection = nil
    end
end

function candy_handler.Has(argument: table, argument_2: userdata)
    return values[argument_2] ~= nil
end

return candy_handler
