local click_to_move_display = {}
local image = "rbxasset://textures/ui/traildot.png"
local image_2 = "rbxasset://textures/ui/waypoint.png"
local always_on_top = false
local udim2 = UDim2.new(0, 42, 0, 50)
local vector = Vector2.new(0, 0.5)
local vector_2 = Vector2.new(0, 1)
local vector_3 = Vector2.new(0, 0.5)
local vector_4 = Vector2.new(0.1, 0.5)
local vector_5 = Vector2.new(-0.1, 0.5)
local vector_6 = Vector2.new(1.5, 1.5)
local players = game:GetService("Players")
local tween_service = game:GetService("TweenService")
local run_service = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local local_player = players.LocalPlayer

local function create_waypoint_templates()
    local part = Instance.new("Part")
    part.Size = Vector3.new(1, 1, 1)
    part.Anchored = true
    part.CanCollide = false
    part.Name = "TrailDot"
    part.Transparency = 1
    local image_handle_adornment = Instance.new("ImageHandleAdornment")
    image_handle_adornment.Name = "TrailDotImage"
    image_handle_adornment.Size = vector_6
    image_handle_adornment.SizeRelativeOffset = Vector3.new(0, 0, -0.10000000149011612)
    image_handle_adornment.AlwaysOnTop = always_on_top
    image_handle_adornment.Image = image
    image_handle_adornment.Adornee = part
    image_handle_adornment.Parent = part
    local part_2 = Instance.new("Part")
    part_2.Size = Vector3.new(2, 2, 2)
    part_2.Anchored = true
    part_2.CanCollide = false
    part_2.Name = "EndWaypoint"
    part_2.Transparency = 1
    local image_handle_adornment_2 = Instance.new("ImageHandleAdornment")
    image_handle_adornment_2.Name = "TrailDotImage"
    image_handle_adornment_2.Size = vector_6
    image_handle_adornment_2.SizeRelativeOffset = Vector3.new(0, 0, -0.10000000149011612)
    image_handle_adornment_2.AlwaysOnTop = always_on_top
    image_handle_adornment_2.Image = image
    image_handle_adornment_2.Adornee = part_2
    image_handle_adornment_2.Parent = part_2
    local billboard_gui = Instance.new("BillboardGui")
    billboard_gui.Name = "EndWaypointBillboard"
    billboard_gui.Size = udim2
    billboard_gui.LightInfluence = 0
    billboard_gui.SizeOffset = vector
    billboard_gui.AlwaysOnTop = true
    billboard_gui.Adornee = part_2
    billboard_gui.Parent = part_2
    local image_label = Instance.new("ImageLabel")
    image_label.Image = image_2
    image_label.BackgroundTransparency = 1
    image_label.Size = UDim2.new(1, 0, 1, 0)
    image_label.Parent = billboard_gui
    local part_3 = Instance.new("Part")
    part_3.Size = Vector3.new(2, 2, 2)
    part_3.Anchored = true
    part_3.CanCollide = false
    part_3.Name = "FailureWaypoint"
    part_3.Transparency = 1
    local image_handle_adornment_3 = Instance.new("ImageHandleAdornment")
    image_handle_adornment_3.Name = "TrailDotImage"
    image_handle_adornment_3.Size = vector_6
    image_handle_adornment_3.SizeRelativeOffset = Vector3.new(0, 0, -0.10000000149011612)
    image_handle_adornment_3.AlwaysOnTop = always_on_top
    image_handle_adornment_3.Image = image
    image_handle_adornment_3.Adornee = part_3
    image_handle_adornment_3.Parent = part_3
    local billboard_gui_2 = Instance.new("BillboardGui")
    billboard_gui_2.Name = "FailureWaypointBillboard"
    billboard_gui_2.Size = udim2
    billboard_gui_2.LightInfluence = 0
    billboard_gui_2.SizeOffset = vector_3
    billboard_gui_2.AlwaysOnTop = true
    billboard_gui_2.Adornee = part_3
    billboard_gui_2.Parent = part_3
    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Position = UDim2.new(0.5, 0, 1, 0)
    frame.Parent = billboard_gui_2
    local image_label_2 = Instance.new("ImageLabel")
    image_label_2.Image = image_2
    image_label_2.BackgroundTransparency = 1
    image_label_2.Position = UDim2.new(0, -udim2.X.Offset / 2, 0, -udim2.Y.Offset)
    image_label_2.Size = udim2
    image_label_2.Parent = frame
    return part, part_2, part_3
end

local result, value, value_2 = create_waypoint_templates()

local function get_trail_dot_parent()
    local current_camera = workspace.CurrentCamera
    local click_to_move_display_2 = current_camera:FindFirstChild("ClickToMoveDisplay")
    if not click_to_move_display_2 then
        click_to_move_display_2 = Instance.new("Model")
        click_to_move_display_2.Name = "ClickToMoveDisplay"
        click_to_move_display_2.Parent = current_camera
    end
    return click_to_move_display_2
end

local instance = {}
instance.__index = instance

function instance.Destroy(self)
    self.DisplayModel:Destroy()
end

local function place_path_waypoint(argument, argument_2)
    local hit_part, value_5, value_6 = workspace:FindPartOnRayWithIgnoreList(
        Ray.new(argument_2 + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0)),
        { workspace.CurrentCamera, local_player.Character }
    )
    if hit_part then
        argument.CFrame = CFrame.new(value_5, value_5 + value_6)
        local current_camera = workspace.CurrentCamera
        local click_to_move_display_2 = current_camera:FindFirstChild("ClickToMoveDisplay")
        if not click_to_move_display_2 then
            click_to_move_display_2 = Instance.new("Model")
            click_to_move_display_2.Name = "ClickToMoveDisplay"
            click_to_move_display_2.Parent = current_camera
        end
        argument.Parent = click_to_move_display_2
    end
end

function instance.NewDisplayModel(self, argument)
    local clone = result:Clone()
    place_path_waypoint(clone, argument)
    return clone
end

function instance.new(argument, closest_way_point)
    local instance_4 = setmetatable({}, instance)
    instance_4.DisplayModel = instance_4:NewDisplayModel(argument)
    instance_4.ClosestWayPoint = closest_way_point
    return instance_4
end

local instance_2 = {}
instance_2.__index = instance_2

function instance_2.Destroy(self)
    self.Destroyed = true
    self.Tween:Cancel()
    self.DisplayModel:Destroy()
end

function instance_2.NewDisplayModel(self, argument)
    local clone = value:Clone()
    place_path_waypoint(clone, argument)
    return clone
end

function instance_2.CreateTween(self)
    local tween = tween_service:Create(
        self.DisplayModel.EndWaypointBillboard,
        TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true),
        { SizeOffset = vector_2 }
    )
    tween:Play()
    return tween
end

function instance_2.TweenInFrom(self, argument)
    self.DisplayModel.EndWaypointBillboard.StudsOffset = Vector3.new(0, (argument - self.DisplayModel.Position).Y, 0)
    local tween = tween_service:Create(
        self.DisplayModel.EndWaypointBillboard,
        TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        { StudsOffset = Vector3.new(0, 0, 0) }
    )
    tween:Play()
    return tween
end

function instance_2.new(argument, closest_way_point, argument_2)
    local instance_4 = setmetatable({}, instance_2)
    instance_4.DisplayModel = instance_4:NewDisplayModel(argument)
    instance_4.Destroyed = false
    if argument_2 and ((argument_2 - argument).Magnitude > 5) then
        instance_4.Tween = instance_4:TweenInFrom(argument_2)
        coroutine.wrap(function()
            instance_4.Tween.Completed:Wait()
            if instance_4.Destroyed then
                return
            end
            instance_4.Tween = instance_4:CreateTween()
        end)()
    else
        instance_4.Tween = instance_4:CreateTween()
    end
    instance_4.ClosestWayPoint = closest_way_point
    return instance_4
end

local instance_3 = {}
instance_3.__index = instance_3

function instance_3.Hide(self)
    self.DisplayModel.Parent = nil
end

function instance_3.Destroy(self)
    self.DisplayModel:Destroy()
end

function instance_3.NewDisplayModel(self, argument)
    local clone = value_2:Clone()
    place_path_waypoint(clone, argument)
    local hit_part, value_5, value_6 = workspace:FindPartOnRayWithIgnoreList(
        Ray.new(argument + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0)),
        { workspace.CurrentCamera, local_player.Character }
    )
    if hit_part then
        clone.CFrame = CFrame.new(value_5, value_5 + value_6)
        local current_camera = workspace.CurrentCamera
        local click_to_move_display_2 = current_camera:FindFirstChild("ClickToMoveDisplay")
        if not click_to_move_display_2 then
            click_to_move_display_2 = Instance.new("Model")
            click_to_move_display_2.Name = "ClickToMoveDisplay"
            click_to_move_display_2.Parent = current_camera
        end
        clone.Parent = click_to_move_display_2
    end
    return clone
end

function instance_3.RunFailureTween(self)
    wait(0.125)
    local tween_info = TweenInfo.new(0.0625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local tween =
        tween_service:Create(self.DisplayModel.FailureWaypointBillboard, tween_info, { SizeOffset = vector_4 })
    tween:Play()
    tween_service:Create(self.DisplayModel.FailureWaypointBillboard.Frame, tween_info, { Rotation = 10 }):Play()
    tween.Completed:wait()
    local tween_2 = tween_service:Create(
        self.DisplayModel.FailureWaypointBillboard,
        TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3, true),
        { SizeOffset = vector_5 }
    )
    tween_2:Play()
    local tween_info_2 = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3, true)
    local tween_properties = {}
    tween_properties.ImageColor3 = Color3.new(0.75, 0.75, 0.75)
    tween_service
        :Create(self.DisplayModel.FailureWaypointBillboard.Frame.ImageLabel, tween_info_2, tween_properties)
        :Play()
    tween_service:Create(self.DisplayModel.FailureWaypointBillboard.Frame, tween_info_2, { Rotation = -10 }):Play()
    tween_2.Completed:wait()
    local tween_info_3 = TweenInfo.new(0.0625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local tween_3 =
        tween_service:Create(self.DisplayModel.FailureWaypointBillboard, tween_info_3, { SizeOffset = vector_3 })
    tween_3:Play()
    tween_service:Create(self.DisplayModel.FailureWaypointBillboard.Frame, tween_info_3, { Rotation = 0 }):Play()
    tween_3.Completed:wait()
    wait(0.125)
end

function instance_3.new(argument)
    local instance_4 = setmetatable({}, instance_3)
    instance_4.DisplayModel = instance_4:NewDisplayModel(argument)
    return instance_4
end

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://2874840706"
local value_3 = nil

local function get_failure_animation_track(argument)
    if argument ~= nil then
        value_3 = argument:LoadAnimation(animation)
        assert(value_3, "")
        value_3.Priority = Enum.AnimationPriority.Action
        value_3.Looped = false
    end
    return value_3
end

local function find_player_humanoid()
    local character = local_player.Character
    if character then
        return character:FindFirstChildOfClass("Humanoid")
    end
end

local function get_trail_dot_scale(argument, argument_2)
    return argument_2 * (((math.clamp(argument - 10, 0, 90) / 90) * 1.5) + 1)
end

local number = 0

local function create_trail_dots(argument, argument_2)
    local items = {}
    local number_2 = 1
    for n = 1, #argument - 1 do
        local is_magnitude = (argument[n].Position - argument[#argument].Position).Magnitude < 3
        if not is_magnitude and n % 2 == 0 then
            items[number_2] = instance.new(argument[n].Position, n)
            number_2 = number_2 + 1
        end
    end
    table.insert(items, (instance_2.new(argument[#argument].Position, #argument, argument_2)))
    local values = {}
    local number_3 = 1
    number_2 = number_3
    for n_2 = #items, 1, -1 do
        values[number_2] = items[n_2]
        number_2 = number_2 + 1
    end
    return values
end

function click_to_move_display.CreatePathDisplay(self, argument)
    number = number + 1
    local result_2 = create_trail_dots(self, argument)
    local text = "ClickToMoveResizeTrail" .. number
    local function resize_trail_dots()
        if #result_2 ~= 0 then
            local p = workspace.CurrentCamera.CFrame.p
            for n = 1, #result_2 do
                local trail_dot_image = result_2[n].DisplayModel:FindFirstChild("TrailDotImage")
                if trail_dot_image then
                    trail_dot_image.Size = vector_6
                        * (((math.clamp((result_2[n].DisplayModel.Position - p).Magnitude - 10, 0, 90) / 90) * 1.5) + 1)
                end
            end
        else
            run_service:UnbindFromRenderStep(text)
        end
    end
    run_service:BindToRenderStep(text, Enum.RenderPriority.Camera.Value - 1, resize_trail_dots)
    local function remove_path_before_point(argument_2)
        for n = #result_2, 1, -1 do
            local result_entry = result_2[n]
            if result_entry.ClosestWayPoint <= argument_2 then
                result_entry:Destroy()
                result_2[n] = nil
                continue
            else
                break
            end
        end
    end
    local function remove_path()
        remove_path_before_point(#self)
    end
    return remove_path, remove_path_before_point
end

local value_4 = nil

function click_to_move_display.DisplayFailureWaypoint(self)
    if value_4 then
        value_4:Hide()
    end
    local instance_4 = instance_3.new(self)
    value_4 = instance_4
    coroutine.wrap(function()
        instance_4:RunFailureTween()
        instance_4:Destroy()
        instance_4 = nil
    end)()
end

function click_to_move_display.CreateEndWaypoint(self)
    return instance_2.new(self)
end

function click_to_move_display.PlayFailureAnimation()
    local character = local_player.Character
    local humanoid
    if character then
        humanoid = character:FindFirstChildOfClass("Humanoid")
    else
        humanoid = nil
    end
    if not humanoid then
        return
    end
    if humanoid ~= nil then
        value_3 = humanoid:LoadAnimation(animation)
        assert(value_3, "")
        value_3.Priority = Enum.AnimationPriority.Action
        value_3.Looped = false
    end
    value_3:Play()
end

function click_to_move_display.CancelFailureAnimation()
    if value_3 == nil or not value_3.IsPlaying then
        return
    end
    value_3:Stop()
end

function click_to_move_display.SetWaypointTexture(self)
    image = self
    result, value, value_2 = create_waypoint_templates()
end

function click_to_move_display.GetWaypointTexture()
    return image
end

function click_to_move_display.SetWaypointRadius(self)
    vector_6 = Vector2.new(self, self)
    result, value, value_2 = create_waypoint_templates()
end

function click_to_move_display.GetWaypointRadius()
    return vector_6.X
end

function click_to_move_display.SetEndWaypointTexture(self)
    image_2 = self
    result, value, value_2 = create_waypoint_templates()
end

function click_to_move_display.GetEndWaypointTexture()
    return image_2
end

function click_to_move_display.SetWaypointsAlwaysOnTop(self)
    always_on_top = self
    result, value, value_2 = create_waypoint_templates()
end

function click_to_move_display.GetWaypointsAlwaysOnTop()
    return always_on_top
end

return click_to_move_display
