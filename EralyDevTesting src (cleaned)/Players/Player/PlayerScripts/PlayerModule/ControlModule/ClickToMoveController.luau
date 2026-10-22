local success, result = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserExcludeNonCollidableForPathfinding")
end)
local result_2 = success and result
local success2, result2 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserClickToMoveSupportAgentCanClimb2")
end)
local result2_2 = success2 and result2
local user_input_service = game:GetService("UserInputService")
local pathfinding_service = game:GetService("PathfindingService")
local players = game:GetService("Players")
game:GetService("Debris")
local starter_gui = game:GetService("StarterGui")
local workspace = game:GetService("Workspace")
local collection_service = game:GetService("CollectionService")
local gui_service = game:GetService("GuiService")
local common_utils = script.Parent.Parent:WaitForChild("CommonUtils")
local user_flag = require(common_utils:WaitForChild("FlagUtil")).getUserFlag("UserUpdateInputConnections")
local enabled = true
local enabled_2 = true
local enabled_3 = false
local number = 1
local number_2 = 8
local values = {
    [Enum.KeyCode.W] = true,
    [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true,
    [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true,
    [Enum.KeyCode.Down] = true,
}
local local_player = players.LocalPlayer
local click_to_move_display = require(script.Parent:WaitForChild("ClickToMoveDisplay"))
local values_2 = {}

local function find_character_ancestor(argument)
    if not argument then
        return
    end

    local humanoid = argument:FindFirstChildOfClass("Humanoid")

    if humanoid then
        return argument, humanoid
    end

    return find_character_ancestor(argument.Parent)
end

values_2.FindCharacterAncestor = find_character_ancestor

local function raycast(argument: any, argument_2: boolean, argument_3: table)
    local items_2 = argument_3 or {}
    local hit_part, value_3, value_4, value_5 = workspace:FindPartOnRayWithIgnoreList(argument, items_2)

    if not hit_part then
        return nil, nil
    end

    if argument_2 and hit_part.CanCollide == false then
        local humanoid

        if hit_part then
            humanoid = hit_part:FindFirstChildOfClass("Humanoid")

            if not humanoid then
                local result_3
                result_3, humanoid = find_character_ancestor(hit_part.Parent)
            end
        else
            humanoid = nil
        end

        if humanoid == nil then
            table.insert(items_2, hit_part)

            return raycast(argument, argument_2, items_2)
        end
    end

    return hit_part, value_3, value_4, value_5
end

values_2.Raycast = raycast
local values_3 = {}

local function find_player_humanoid(player: userdata)
    local character

    if player then
        character = player.Character
    else
        character = player
    end

    if not character then
        return
    end

    local value_entry = values_3[player]

    if value_entry and value_entry.Parent == character then
        return value_entry
    end

    values_3[player] = nil
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        values_3[player] = humanoid
    end

    return humanoid
end

local items = nil
local value = nil
local connection = nil
local connection_2 = nil

local function get_character()
    return local_player and local_player.Character
end

local function update_ignore_tag(argument)
    if argument == value then
        return
    end

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if connection_2 then
        connection_2:Disconnect()
        connection_2 = nil
    end

    value = argument
    local values_4 = {}
    values_4[1] = local_player and local_player.Character
    items = values_4

    if value == nil then
        return
    end

    local tagged = collection_service:GetTagged(value)

    for _, item in ipairs(tagged) do
        table.insert(items, item)
    end

    connection = collection_service:GetInstanceAddedSignal(value):Connect(function(argument_2)
        table.insert(items, argument_2)
    end)
    connection_2 = collection_service:GetInstanceRemovedSignal(value):Connect(function(argument_2)
        for index = 1, #items do
            if items[index] == argument_2 then
                items[index] = items[#items]
                table.remove(items)

                return
            end

            local _ = index
        end
    end)
end

local function get_ignore_list()
    if items then
        return items
    end

    items = {}
    assert(items, "")
    table.insert(items, local_player and local_player.Character)

    return items
end

local function min_v(argument: vector, argument_2: vector)
    local minimum = math.min(argument.X, argument_2.X)
    local minimum_2 = math.min(argument.Y, argument_2.Y)
    local minimum_3 = math.min(argument.Z, argument_2.Z)

    return Vector3.new(minimum, minimum_2, minimum_3)
end

local function max_v(argument, argument_2)
    local maximum = math.max(argument.X, argument_2.X)
    local maximum_2 = math.max(argument.Y, argument_2.Y)
    local maximum_3 = math.max(argument.Z, argument_2.Z)

    return Vector3.new(maximum, maximum_2, maximum_3)
end

local function get_collidable_extents_size(argument: userdata?)
    if not (argument ~= nil and argument.PrimaryPart ~= nil) then
        return
    end

    assert(argument, "")
    assert(argument.PrimaryPart, "")
    local inverse_result = argument.PrimaryPart.CFrame:Inverse()
    local vector = Vector3.new(inf, inf, inf)
    local vector_2 = Vector3.new(-inf, -inf, -inf)

    for _, descendant in pairs(argument:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.CanCollide then
            local product = inverse_result * descendant.CFrame
            local vector_3 = Vector3.new(descendant.Size.X / 2, descendant.Size.Y / 2, descendant.Size.Z / 2)
            local values_4 = {
                Vector3.new(vector_3.X, vector_3.Y, vector_3.Z),
                Vector3.new(vector_3.X, vector_3.Y, -vector_3.Z),
                Vector3.new(vector_3.X, -vector_3.Y, vector_3.Z),
                Vector3.new(vector_3.X, -vector_3.Y, -vector_3.Z),
                Vector3.new(-vector_3.X, vector_3.Y, vector_3.Z),
                Vector3.new(-vector_3.X, vector_3.Y, -vector_3.Z),
                Vector3.new(-vector_3.X, -vector_3.Y, vector_3.Z),
                (Vector3.new(-vector_3.X, -vector_3.Y, -vector_3.Z)),
            }

            for _, item in ipairs(values_4) do
                local product_2 = product * item
                local minimum = math.min(vector.X, product_2.X)
                local minimum_2 = math.min(vector.Y, product_2.Y)
                local minimum_3 = math.min(vector.Z, product_2.Z)
                vector = Vector3.new(minimum, minimum_2, minimum_3)
                local maximum = math.max(vector_2.X, product_2.X)
                local maximum_2 = math.max(vector_2.Y, product_2.Y)
                local maximum_3 = math.max(vector_2.Z, product_2.Z)
                vector_2 = Vector3.new(maximum, maximum_2, maximum_3)
            end
        end
    end

    local difference = vector_2 - vector

    if difference.X < 0 or (difference.Y < 0 or difference.Z < 0) then
        return nil
    end

    return difference
end

local function pather(original_target_point: any, target_surface_normal: any, direct_path: boolean?)
    local character_3 = {}
    local direct_path_2

    if direct_path == nil then
        direct_path_2 = enabled_3
        direct_path = true
    else
        direct_path_2 = direct_path
    end

    character_3.Cancelled = false
    character_3.Started = false
    character_3.Finished = Instance.new("BindableEvent")
    character_3.PathFailed = Instance.new("BindableEvent")
    character_3.PathComputing = false
    character_3.PathComputed = false
    character_3.OriginalTargetPoint = original_target_point
    character_3.TargetPoint = original_target_point
    character_3.TargetSurfaceNormal = target_surface_normal
    character_3.DiedConn = nil
    character_3.SeatedConn = nil
    character_3.BlockedConn = nil
    character_3.TeleportedConn = nil
    character_3.CurrentPoint = 0
    character_3.HumanoidOffsetFromPath = Vector3.new(0, 0, 0)
    character_3.CurrentWaypointPosition = nil
    character_3.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
    character_3.CurrentWaypointPlaneDistance = 0
    character_3.CurrentWaypointNeedsJump = false
    character_3.CurrentHumanoidPosition = Vector3.new(0, 0, 0)
    character_3.CurrentHumanoidVelocity = 0
    character_3.NextActionMoveDirection = Vector3.new(0, 0, 0)
    character_3.NextActionJump = false
    character_3.Timeout = 0
    local player = local_player
    local character

    if player then
        character = player.Character
    else
        character = player
    end

    local humanoid

    if character then
        humanoid = values_3[player]

        if not humanoid or humanoid.Parent ~= character then
            values_3[player] = nil
            humanoid = character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                values_3[player] = humanoid
            end
        end
    else
        humanoid = nil
    end

    character_3.Humanoid = humanoid
    character_3.OriginPoint = nil
    character_3.AgentCanFollowPath = false
    character_3.DirectPath = false
    character_3.DirectPathRiseFirst = false
    character_3.stopTraverseFunc = nil
    character_3.setPointFunc = nil
    character_3.pointList = nil
    local root_part = character_3.Humanoid and character_3.Humanoid.RootPart

    if root_part then
        character_3.OriginPoint = root_part.CFrame.Position
        local agent_radius = 2
        local agent_height = 5
        local agent_can_jump = true
        local seat_part = character_3.Humanoid.SeatPart

        if seat_part and seat_part:IsA("VehicleSeat") then
            local first_ancestor_of_class = seat_part:FindFirstAncestorOfClass("Model")

            if first_ancestor_of_class then
                local primary_part = first_ancestor_of_class.PrimaryPart
                first_ancestor_of_class.PrimaryPart = seat_part

                if direct_path then
                    local extents_size = first_ancestor_of_class:GetExtentsSize()
                    agent_radius = number
                        * 0.5
                        * math.sqrt(extents_size.X * extents_size.X + extents_size.Z * extents_size.Z)
                    agent_height = number * extents_size.Y
                    character_3.AgentCanFollowPath = true
                    character_3.DirectPath = direct_path
                    agent_can_jump = false
                end

                first_ancestor_of_class.PrimaryPart = primary_part
            end
        else
            local value_3 = nil

            if result_2 then
                local character_2 = local_player and local_player.Character

                if character_2 ~= nil then
                    value_3 = get_collidable_extents_size(character_2)
                end
            end

            if value_3 == nil then
                value_3 = (local_player and local_player.Character):GetExtentsSize()
            end

            assert(value_3, "")
            agent_radius = number * 0.5 * math.sqrt(value_3.X * value_3.X + value_3.Z * value_3.Z)
            agent_height = number * value_3.Y
            agent_can_jump = character_3.Humanoid.JumpPower > 0
            character_3.AgentCanFollowPath = true
            character_3.DirectPath = direct_path_2
            character_3.DirectPathRiseFirst = character_3.Humanoid.Sit
        end

        if result2_2 then
            character_3.pathResult = pathfinding_service:CreatePath({
                AgentCanClimb = true,
                AgentRadius = agent_radius,
                AgentHeight = agent_height,
                AgentCanJump = agent_can_jump,
            })
        else
            character_3.pathResult = pathfinding_service:CreatePath({
                AgentRadius = agent_radius,
                AgentHeight = agent_height,
                AgentCanJump = agent_can_jump,
            })
        end
    end

    function character_3.Cleanup(argument)
        if character_3.stopTraverseFunc then
            character_3.stopTraverseFunc()
            character_3.stopTraverseFunc = nil
        end

        if character_3.BlockedConn then
            character_3.BlockedConn:Disconnect()
            character_3.BlockedConn = nil
        end

        if character_3.DiedConn then
            character_3.DiedConn:Disconnect()
            character_3.DiedConn = nil
        end

        if character_3.SeatedConn then
            character_3.SeatedConn:Disconnect()
            character_3.SeatedConn = nil
        end

        if character_3.TeleportedConn then
            character_3.TeleportedConn:Disconnect()
            character_3.TeleportedConn = nil
        end

        character_3.Started = false
    end

    function character_3.Cancel(argument)
        character_3.Cancelled = true
        character_3:Cleanup()
    end

    function character_3.IsActive(argument)
        return character_3.AgentCanFollowPath and character_3.Started and not character_3.Cancelled
    end

    function character_3.OnPathInterrupted(argument)
        character_3.Cancelled = true
        character_3:OnPointReached(false)
    end

    function character_3.ComputePath(argument)
        if not character_3.OriginPoint then
            return
        end

        if character_3.PathComputed or character_3.PathComputing then
            return
        end

        character_3.PathComputing = true

        if character_3.AgentCanFollowPath then
            if character_3.DirectPath then
                character_3.pointList = {
                    PathWaypoint.new(character_3.OriginPoint, Enum.PathWaypointAction.Walk),
                    PathWaypoint.new(
                        character_3.TargetPoint,
                        character_3.DirectPathRiseFirst and Enum.PathWaypointAction.Jump or Enum.PathWaypointAction.Walk
                    ),
                }
                character_3.PathComputed = true
            else
                character_3.pathResult:ComputeAsync(character_3.OriginPoint, character_3.TargetPoint)
                character_3.pointList = character_3.pathResult:GetWaypoints()
                character_3.BlockedConn = character_3.pathResult.Blocked:Connect(function(argument_2)
                    character_3:OnPathBlocked(argument_2)
                end)
                character_3.PathComputed = character_3.pathResult.Status == Enum.PathStatus.Success
            end
        end

        character_3.PathComputing = false
    end

    function character_3.IsValidPath(argument)
        character_3:ComputePath()

        return character_3.PathComputed and character_3.AgentCanFollowPath
    end

    character_3.Recomputing = false

    function character_3.OnPathBlocked(argument, argument_2)
        if character_3.CurrentPoint > argument_2 or character_3.Recomputing then
            return
        end

        character_3.Recomputing = true

        if character_3.stopTraverseFunc then
            character_3.stopTraverseFunc()
            character_3.stopTraverseFunc = nil
        end

        character_3.OriginPoint = character_3.Humanoid.RootPart.CFrame.p
        character_3.pathResult:ComputeAsync(character_3.OriginPoint, character_3.TargetPoint)
        character_3.pointList = character_3.pathResult:GetWaypoints()

        if #character_3.pointList > 0 then
            character_3.HumanoidOffsetFromPath = character_3.pointList[1].Position - character_3.OriginPoint
        end

        character_3.PathComputed = character_3.pathResult.Status == Enum.PathStatus.Success

        if enabled then
            local stop_traverse_func, set_point_func = click_to_move_display.CreatePathDisplay(character_3.pointList)
            character_3.stopTraverseFunc = stop_traverse_func
            character_3.setPointFunc = set_point_func
        end

        if character_3.PathComputed then
            character_3.CurrentPoint = 1
            character_3:OnPointReached(true)
        else
            character_3.PathFailed:Fire()
            character_3:Cleanup()
        end

        character_3.Recomputing = false
    end

    function character_3.OnRenderStepped(argument: table, argument_2: number)
        if not (character_3.Started and not character_3.Cancelled) then
            return
        end

        character_3.Timeout = character_3.Timeout + argument_2

        if number_2 < character_3.Timeout then
            character_3:OnPointReached(false)

            return
        end

        character_3.CurrentHumanoidPosition = character_3.Humanoid.RootPart.Position
            + character_3.HumanoidOffsetFromPath
        character_3.CurrentHumanoidVelocity = character_3.Humanoid.RootPart.Velocity

        while character_3.Started and character_3:IsCurrentWaypointReached() do
            character_3:OnPointReached(true)
        end

        if not character_3.Started then
            return
        end

        character_3.NextActionMoveDirection = character_3.CurrentWaypointPosition - character_3.CurrentHumanoidPosition

        if character_3.NextActionMoveDirection.Magnitude > 1e-6 then
            character_3.NextActionMoveDirection = character_3.NextActionMoveDirection.Unit
        else
            character_3.NextActionMoveDirection = Vector3.new(0, 0, 0)
        end

        if character_3.CurrentWaypointNeedsJump then
            character_3.NextActionJump = true
            character_3.CurrentWaypointNeedsJump = false

            return
        end

        character_3.NextActionJump = false
    end

    function character_3.IsCurrentWaypointReached(argument)
        local enabled_4

        if character_3.CurrentWaypointPlaneNormal == Vector3.new(0, 0, 0) then
            enabled_4 = true
        else
            local difference = character_3.CurrentWaypointPlaneNormal:Dot(character_3.CurrentHumanoidPosition)
                - character_3.CurrentWaypointPlaneDistance
            local product = 0.0625 * -character_3.CurrentWaypointPlaneNormal:Dot(character_3.CurrentHumanoidVelocity)
            enabled_4 = difference < math.max(1, product)
        end

        if enabled_4 then
            character_3.CurrentWaypointPosition = nil
            character_3.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            character_3.CurrentWaypointPlaneDistance = 0
        end

        return enabled_4
    end

    function character_3.OnPointReached(argument, argument_2)
        if not argument_2 or character_3.Cancelled then
            character_3.PathFailed:Fire()
            character_3:Cleanup()

            return
        end

        if character_3.setPointFunc then
            character_3.setPointFunc(character_3.CurrentPoint)
        end

        local sum = character_3.CurrentPoint + 1

        if #character_3.pointList < sum then
            if character_3.stopTraverseFunc then
                character_3.stopTraverseFunc()
            end

            character_3.Finished:Fire()
            character_3:Cleanup()

            return
        end

        local point_list_entry = character_3.pointList[character_3.CurrentPoint]
        local point_list_entry_2 = character_3.pointList[sum]
        local state = character_3.Humanoid:GetState()

        if
            (state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Freefall) and true
            or state == Enum.HumanoidStateType.Jumping
        then
            local condition = point_list_entry_2.Action == Enum.PathWaypointAction.Jump

            if not condition and character_3.CurrentPoint > 1 then
                local difference = point_list_entry.Position
                    - character_3.pointList[character_3.CurrentPoint - 1].Position
                local difference_2 = point_list_entry_2.Position - point_list_entry.Position
                condition = Vector2.new(difference.x, difference.z).Unit
                    :Dot(Vector2.new(difference_2.x, difference_2.z).Unit) < 0.996
            end

            if condition then
                character_3.Humanoid.FreeFalling:Wait()
                wait(0.1)
            end
        end

        character_3:MoveToNextWayPoint(point_list_entry, point_list_entry_2, sum)
    end

    function character_3.MoveToNextWayPoint(
        argument: table,
        argument_2: userdata,
        argument_3: userdata,
        current_point: number
    )
        character_3.CurrentWaypointPlaneNormal = argument_2.Position - argument_3.Position

        if not result2_2 or argument_3.Label ~= "Climb" then
            character_3.CurrentWaypointPlaneNormal =
                Vector3.new(character_3.CurrentWaypointPlaneNormal.X, 0, character_3.CurrentWaypointPlaneNormal.Z)
        end

        if character_3.CurrentWaypointPlaneNormal.Magnitude > 1e-6 then
            character_3.CurrentWaypointPlaneNormal = character_3.CurrentWaypointPlaneNormal.Unit
            character_3.CurrentWaypointPlaneDistance = character_3.CurrentWaypointPlaneNormal:Dot(argument_3.Position)
        else
            character_3.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            character_3.CurrentWaypointPlaneDistance = 0
        end

        character_3.CurrentWaypointNeedsJump = argument_3.Action == Enum.PathWaypointAction.Jump
        character_3.CurrentWaypointPosition = argument_3.Position
        character_3.CurrentPoint = current_point
        character_3.Timeout = 0
    end

    function character_3.Start(argument, argument_2)
        if not character_3.AgentCanFollowPath then
            character_3.PathFailed:Fire()

            return
        end

        if character_3.Started then
            return
        end

        character_3.Started = true
        click_to_move_display.CancelFailureAnimation()

        if enabled and (argument_2 == nil or argument_2) then
            local stop_traverse_func, set_point_func =
                click_to_move_display.CreatePathDisplay(character_3.pointList, character_3.OriginalTargetPoint)
            character_3.stopTraverseFunc = stop_traverse_func
            character_3.setPointFunc = set_point_func
        end

        if #character_3.pointList <= 0 then
            character_3.PathFailed:Fire()

            if character_3.stopTraverseFunc then
                character_3.stopTraverseFunc()
            end

            return
        end

        character_3.HumanoidOffsetFromPath =
            Vector3.new(0, character_3.pointList[1].Position.Y - character_3.OriginPoint.Y, 0)
        character_3.CurrentHumanoidPosition = character_3.Humanoid.RootPart.Position
            + character_3.HumanoidOffsetFromPath
        character_3.CurrentHumanoidVelocity = character_3.Humanoid.RootPart.Velocity
        character_3.SeatedConn = character_3.Humanoid.Seated:Connect(function(argument_3, argument_4)
            character_3:OnPathInterrupted()
        end)
        character_3.DiedConn = character_3.Humanoid.Died:Connect(function()
            character_3:OnPathInterrupted()
        end)
        character_3.TeleportedConn = character_3.Humanoid.RootPart:GetPropertyChangedSignal("CFrame"):Connect(function()
            character_3:OnPathInterrupted()
        end)
        character_3.CurrentPoint = 1
        character_3:OnPointReached(true)
    end

    local ray = Ray.new(character_3.TargetPoint + character_3.TargetSurfaceNormal * 1.5, Vector3.new(0, -50, 0))
    local items_2

    if items then
        items_2 = items
    else
        items = {}
        assert(items, "")
        table.insert(items, local_player and local_player.Character)
        items_2 = items
    end

    local hit_part, target_point = workspace:FindPartOnRayWithIgnoreList(ray, items_2)

    if hit_part then
        character_3.TargetPoint = target_point
    end

    character_3:ComputePath()

    return character_3
end

local function check_alive()
    local player = local_player
    local character

    if player then
        character = player.Character
    else
        character = player
    end

    local value_entry

    if character then
        value_entry = values_3[player]

        if not value_entry or value_entry.Parent ~= character then
            values_3[player] = nil
            value_entry = character:FindFirstChildOfClass("Humanoid")

            if value_entry then
                values_3[player] = value_entry
            end
        end
    else
        value_entry = nil
    end

    local enabled_4

    if value_entry == nil then
        enabled_4 = false
    else
        enabled_4 = value_entry.Health > 0
    end

    return enabled_4
end

local function get_equipped_tool(instance: userdata?)
    if instance ~= nil then
        for _, child in pairs(instance:GetChildren()) do
            if child:IsA("Tool") then
                return child
            end
        end
    end
end

local value_2 = nil
local connection_3 = nil
local connection_4 = nil

local function cleanup_path()
    if value_2 then
        value_2:Cancel()
        value_2 = nil
    end

    if connection_3 then
        connection_3:Disconnect()
        connection_3 = nil
    end

    if connection_4 then
        connection_4:Disconnect()
        connection_4 = nil
    end
end

local function handle_move_to(argument, argument_2, argument_3, instance, argument_4)
    if value_2 then
        if value_2 then
            value_2:Cancel()
            value_2 = nil
        end

        if connection_3 then
            connection_3:Disconnect()
            connection_3 = nil
        end

        if connection_4 then
            connection_4:Disconnect()
            connection_4 = nil
        end
    end

    value_2 = argument
    argument:Start(argument_4)
    connection_3 = argument.Finished.Event:Connect(function()
        if value_2 then
            value_2:Cancel()
            value_2 = nil
        end

        if connection_3 then
            connection_3:Disconnect()
            connection_3 = nil
        end

        if connection_4 then
            connection_4:Disconnect()
            connection_4 = nil
        end

        local result_3 = argument_3 and get_equipped_tool(instance)

        if result_3 then
            result_3:Activate()
        end
    end)
    connection_4 = argument.PathFailed.Event:Connect(function()
        if value_2 then
            value_2:Cancel()
            value_2 = nil
        end

        if connection_3 then
            connection_3:Disconnect()
            connection_3 = nil
        end

        if connection_4 then
            connection_4:Disconnect()
            connection_4 = nil
        end

        if not (argument_4 == nil or argument_4) then
            return
        end

        local enabled_4 = enabled_2

        if enabled_4 then
            local is_active_result = value_2 and value_2:IsActive()
            enabled_4 = not is_active_result
        end

        if enabled_4 then
            click_to_move_display.PlayFailureAnimation()
        end

        click_to_move_display.DisplayFailureWaypoint(argument_2)
    end)
end

local function show_path_failed_feedback(argument)
    if value_2 and value_2:IsActive() then
        value_2:Cancel()
    end

    if enabled_2 then
        click_to_move_display.PlayFailureAnimation()
    end

    click_to_move_display.DisplayFailureWaypoint(argument)
end

function OnTap(argument: table, original_target_point: vector?, argument_2: boolean?)
    local current_camera = workspace.CurrentCamera
    local character = local_player.Character
    local player = local_player
    local character_2

    if player then
        character_2 = player.Character
    else
        character_2 = player
    end

    local value_entry

    if character_2 then
        value_entry = values_3[player]

        if not value_entry or value_entry.Parent ~= character_2 then
            values_3[player] = nil
            value_entry = character_2:FindFirstChildOfClass("Humanoid")

            if value_entry then
                values_3[player] = value_entry
            end
        end
    else
        value_entry = nil
    end

    local enabled_4

    if value_entry == nil then
        enabled_4 = false
    else
        enabled_4 = value_entry.Health > 0
    end

    if not enabled_4 then
        return
    end

    if #argument == 1 or original_target_point then
        if current_camera then
            local screen_point_to_ray_result = current_camera:ScreenPointToRay(argument[1].X, argument[1].Y)
            local ray = Ray.new(screen_point_to_ray_result.Origin, screen_point_to_ray_result.Direction * 1000)
            local player_2 = local_player
            local character_3

            if player_2 then
                character_3 = player_2.Character
            else
                character_3 = player_2
            end

            if character_3 then
                local value_entry_2 = values_3[player_2]

                if not value_entry_2 or value_entry_2.Parent ~= character_3 then
                    values_3[player_2] = nil
                    local humanoid = character_3:FindFirstChildOfClass("Humanoid")

                    if humanoid then
                        values_3[player_2] = humanoid
                    end
                end
            end

            local raycast2 = values_2.Raycast
            local items_2

            if items then
                items_2 = items
            else
                items = {}
                assert(items, "")
                table.insert(items, local_player and local_player.Character)
                items_2 = items
            end

            local result_3, value_3, target_surface_normal = raycast2(ray, true, items_2)
            local character_ancestor, value_4 = values_2.FindCharacterAncestor(result_3)

            if
                argument_2
                and (
                    value_4
                    and (
                        starter_gui:GetCore("AvatarContextMenuEnabled")
                        and players:GetPlayerFromCharacter(value_4.Parent)
                    )
                )
            then
                if value_2 then
                    value_2:Cancel()
                    value_2 = nil
                end

                if connection_3 then
                    connection_3:Disconnect()
                    connection_3 = nil
                end

                if connection_4 then
                    connection_4:Disconnect()
                    connection_4 = nil
                end

                return
            end

            if original_target_point then
                character_ancestor = nil
            else
                original_target_point = value_3
            end

            if original_target_point and character then
                if value_2 then
                    value_2:Cancel()
                    value_2 = nil
                end

                if connection_3 then
                    connection_3:Disconnect()
                    connection_3 = nil
                end

                if connection_4 then
                    connection_4:Disconnect()
                    connection_4 = nil
                end

                local result_4 = pather(original_target_point, target_surface_normal)

                if result_4:IsValidPath() then
                    handle_move_to(result_4, original_target_point, character_ancestor, character)

                    return
                end

                result_4:Cleanup()

                if value_2 and value_2:IsActive() then
                    value_2:Cancel()
                end

                if enabled_2 then
                    click_to_move_display.PlayFailureAnimation()
                end

                click_to_move_display.DisplayFailureWaypoint(original_target_point)
            end
        end
    else
        local result_5 = #argument >= 2 and (current_camera and get_equipped_tool(character))

        if result_5 then
            result_5:Activate()
        end
    end
end

local function disconnect_event(connection_5)
    if connection_5 then
        connection_5:Disconnect()
    end
end

local keyboard = require(script.Parent:WaitForChild("Keyboard"))
local click_to_move_controller = setmetatable({}, keyboard)
click_to_move_controller.__index = click_to_move_controller

function click_to_move_controller.new(argument)
    local keyboard_2 = keyboard.new(argument)
    local instance = setmetatable(keyboard_2, click_to_move_controller)
    instance.fingerTouches = {}
    instance.numUnsunkTouches = 0
    instance.mouse1Down = tick()
    instance.mouse1DownPos = Vector2.new()
    instance.mouse2DownTime = tick()
    instance.mouse2DownPos = Vector2.new()
    instance.mouse2UpTime = tick()
    instance.keyboardMoveVector = Vector3.new(0, 0, 0)
    instance.tapConn = nil
    instance.inputBeganConn = nil
    instance.inputChangedConn = nil
    instance.inputEndedConn = nil
    instance.humanoidDiedConn = nil
    instance.characterChildAddedConn = nil
    instance.onCharacterAddedConn = nil
    instance.characterChildRemovedConn = nil
    instance.renderSteppedConn = nil
    instance.menuOpenedConnection = nil
    instance.running = false
    instance.wasdEnabled = false

    return instance
end

function click_to_move_controller.DisconnectEvents(argument)
    local tap_conn = argument.tapConn

    if tap_conn then
        tap_conn:Disconnect()
    end

    local input_began_conn = argument.inputBeganConn

    if input_began_conn then
        input_began_conn:Disconnect()
    end

    local input_changed_conn = argument.inputChangedConn

    if input_changed_conn then
        input_changed_conn:Disconnect()
    end

    local input_ended_conn = argument.inputEndedConn

    if input_ended_conn then
        input_ended_conn:Disconnect()
    end

    local humanoid_died_conn = argument.humanoidDiedConn

    if humanoid_died_conn then
        humanoid_died_conn:Disconnect()
    end

    local character_child_added_conn = argument.characterChildAddedConn

    if character_child_added_conn then
        character_child_added_conn:Disconnect()
    end

    local on_character_added_conn = argument.onCharacterAddedConn

    if on_character_added_conn then
        on_character_added_conn:Disconnect()
    end

    local render_stepped_conn = argument.renderSteppedConn

    if render_stepped_conn then
        render_stepped_conn:Disconnect()
    end

    local character_child_removed_conn = argument.characterChildRemovedConn

    if character_child_removed_conn then
        character_child_removed_conn:Disconnect()
    end

    local menu_opened_connection = argument.menuOpenedConnection

    if menu_opened_connection then
        menu_opened_connection:Disconnect()
    end
end

function click_to_move_controller.OnTouchBegan(argument, argument_2, argument_3)
    if argument.fingerTouches[argument_2] == nil and not argument_3 then
        argument.numUnsunkTouches = argument.numUnsunkTouches + 1
    end

    argument.fingerTouches[argument_2] = argument_3
end

function click_to_move_controller.OnTouchChanged(argument, argument_2, argument_3)
    if argument.fingerTouches[argument_2] == nil then
        argument.fingerTouches[argument_2] = argument_3

        if not argument_3 then
            argument.numUnsunkTouches = argument.numUnsunkTouches + 1
        end
    end
end

function click_to_move_controller.OnTouchEnded(argument, argument_2, argument_3)
    if argument.fingerTouches[argument_2] ~= nil and argument.fingerTouches[argument_2] == false then
        argument.numUnsunkTouches = argument.numUnsunkTouches - 1
    end

    argument.fingerTouches[argument_2] = nil
end

function click_to_move_controller.OnCharacterAdded(argument, instance)
    argument:DisconnectEvents()
    argument.inputBeganConn = user_input_service.InputBegan:Connect(function(input, game_processed)
        if input.UserInputType == Enum.UserInputType.Touch then
            argument:OnTouchBegan(input, game_processed)
        end

        if
            argument.wasdEnabled
            and (
                game_processed == false
                and (input.UserInputType == Enum.UserInputType.Keyboard and values[input.KeyCode])
            )
        then
            if value_2 then
                value_2:Cancel()
                value_2 = nil
            end

            if connection_3 then
                connection_3:Disconnect()
                connection_3 = nil
            end

            if connection_4 then
                connection_4:Disconnect()
                connection_4 = nil
            end

            click_to_move_display.CancelFailureAnimation()
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            argument.mouse1DownTime = tick()
            argument.mouse1DownPos = input.Position
        end

        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            argument.mouse2DownTime = tick()
            argument.mouse2DownPos = input.Position
        end
    end)
    argument.inputChangedConn = user_input_service.InputChanged:Connect(function(input, game_processed)
        if input.UserInputType == Enum.UserInputType.Touch then
            argument:OnTouchChanged(input, game_processed)
        end
    end)
    argument.inputEndedConn = user_input_service.InputEnded:Connect(function(input, game_processed)
        if input.UserInputType == Enum.UserInputType.Touch then
            argument:OnTouchEnded(input, game_processed)
        end

        if input.UserInputType ~= Enum.UserInputType.MouseButton2 then
            return
        end

        argument.mouse2UpTime = tick()
        local position = input.Position

        if
            argument.mouse2UpTime - argument.mouse2DownTime < 0.25
            and (
                (position - argument.mouse2DownPos).magnitude < 5
                and (value_2 or argument.keyboardMoveVector.Magnitude <= 0)
            )
        then
            OnTap({ position })
        end
    end)
    argument.tapConn = user_input_service.TouchTap:Connect(function(argument_2, argument_3)
        if not argument_3 then
            OnTap(argument_2, nil, true)
        end
    end)
    argument.menuOpenedConnection = gui_service.MenuOpened:Connect(function()
        if value_2 then
            value_2:Cancel()
            value_2 = nil
        end

        if connection_3 then
            connection_3:Disconnect()
            connection_3 = nil
        end

        if connection_4 then
            connection_4:Disconnect()
            connection_4 = nil
        end
    end)

    local function on_character_child_added(argument_2)
        if user_input_service.TouchEnabled and argument_2:IsA("Tool") then
            argument_2.ManualActivationOnly = true
        end

        if not (argument_2:IsA("Humanoid")) then
            return
        end

        local humanoid_died_conn = argument.humanoidDiedConn

        if humanoid_died_conn then
            humanoid_died_conn:Disconnect()
        end

        argument.humanoidDiedConn = argument_2.Died:Connect(function() end)
    end

    argument.characterChildAddedConn = instance.ChildAdded:Connect(function(child_2)
        on_character_child_added(child_2)
    end)
    argument.characterChildRemovedConn = instance.ChildRemoved:Connect(function(child_2)
        if user_input_service.TouchEnabled and child_2:IsA("Tool") then
            child_2.ManualActivationOnly = false
        end
    end)

    for _, child in pairs(instance:GetChildren()) do
        on_character_child_added(child)
    end
end

function click_to_move_controller.Start(argument)
    argument:Enable(true)
end

function click_to_move_controller.Stop(argument)
    argument:Enable(false)
end

function click_to_move_controller.CleanupPath(argument)
    if value_2 then
        value_2:Cancel()
        value_2 = nil
    end

    if connection_3 then
        connection_3:Disconnect()
        connection_3 = nil
    end

    if connection_4 then
        connection_4:Disconnect()
        connection_4 = nil
    end
end

function click_to_move_controller.Enable(
    argument: table,
    enabled_4: boolean,
    wasd_enabled: boolean,
    touch_jump_controller: any
)
    if enabled_4 then
        if not argument.running then
            if local_player.Character then
                argument:OnCharacterAdded(local_player.Character)
            end

            argument.onCharacterAddedConn = local_player.CharacterAdded:Connect(function(character_2)
                argument:OnCharacterAdded(character_2)
            end)
            argument.running = true
        end

        argument.touchJumpController = touch_jump_controller

        if argument.touchJumpController then
            argument.touchJumpController:Enable(argument.jumpEnabled)
        end
    else
        if argument.running then
            argument:DisconnectEvents()

            if value_2 then
                value_2:Cancel()
                value_2 = nil
            end

            if connection_3 then
                connection_3:Disconnect()
                connection_3 = nil
            end

            if connection_4 then
                connection_4:Disconnect()
                connection_4 = nil
            end

            if user_input_service.TouchEnabled then
                local character = local_player.Character

                if character then
                    for _, child in pairs(character:GetChildren()) do
                        if child:IsA("Tool") then
                            child.ManualActivationOnly = false
                        end
                    end
                end
            end

            argument.running = false
        end

        if argument.touchJumpController and not argument.jumpEnabled then
            argument.touchJumpController:Enable(true)
        end

        argument.touchJumpController = nil
    end

    if user_flag then
        keyboard.Enable(argument, enabled_4)
    elseif user_input_service.KeyboardEnabled and enabled_4 ~= argument.enabled then
        argument.forwardValue = 0
        argument.backwardValue = 0
        argument.leftValue = 0
        argument.rightValue = 0
        argument.moveVector = Vector3.new(0, 0, 0)

        if enabled_4 then
            argument:BindContextActions()
            argument:ConnectFocusEventListeners()
        else
            argument:UnbindContextActions()
            argument:DisconnectFocusEventListeners()
        end
    end

    argument.wasdEnabled = enabled_4 and wasd_enabled and wasd_enabled or false
    argument.enabled = enabled_4
end

function click_to_move_controller.OnRenderStepped(argument, argument_2)
    argument.isJumping = false

    if value_2 then
        value_2:OnRenderStepped(argument_2)

        if value_2 then
            argument.moveVector = value_2.NextActionMoveDirection
            argument.moveVectorIsCameraRelative = false

            if value_2.NextActionJump then
                argument.isJumping = true
            end
        else
            argument.moveVector = argument.keyboardMoveVector
            argument.moveVectorIsCameraRelative = true
        end
    else
        argument.moveVector = argument.keyboardMoveVector
        argument.moveVectorIsCameraRelative = true
    end

    if argument.jumpRequested then
        argument.isJumping = true
    end
end

function click_to_move_controller.UpdateMovement(argument, argument_2)
    if argument_2 == Enum.UserInputState.Cancel then
        argument.keyboardMoveVector = Vector3.new(0, 0, 0)

        return
    end

    if argument.wasdEnabled then
        argument.keyboardMoveVector =
            Vector3.new(argument.leftValue + argument.rightValue, 0, argument.forwardValue + argument.backwardValue)
    end
end

function click_to_move_controller.UpdateJump(argument) end

function click_to_move_controller.SetShowPath(argument, argument_2)
    enabled = argument_2
end

function click_to_move_controller.GetShowPath(argument)
    return enabled
end

function click_to_move_controller.SetWaypointTexture(argument, argument_2)
    click_to_move_display.SetWaypointTexture(argument_2)
end

function click_to_move_controller.GetWaypointTexture(argument)
    return click_to_move_display.GetWaypointTexture()
end

function click_to_move_controller.SetWaypointRadius(argument, argument_2)
    click_to_move_display.SetWaypointRadius(argument_2)
end

function click_to_move_controller.GetWaypointRadius(argument)
    return click_to_move_display.GetWaypointRadius()
end

function click_to_move_controller.SetEndWaypointTexture(argument, argument_2)
    click_to_move_display.SetEndWaypointTexture(argument_2)
end

function click_to_move_controller.GetEndWaypointTexture(argument)
    return click_to_move_display.GetEndWaypointTexture()
end

function click_to_move_controller.SetWaypointsAlwaysOnTop(argument, argument_2)
    click_to_move_display.SetWaypointsAlwaysOnTop(argument_2)
end

function click_to_move_controller.GetWaypointsAlwaysOnTop(argument)
    return click_to_move_display.GetWaypointsAlwaysOnTop()
end

function click_to_move_controller.SetFailureAnimationEnabled(argument, argument_2)
    enabled_2 = argument_2
end

function click_to_move_controller.GetFailureAnimationEnabled(argument)
    return enabled_2
end

function click_to_move_controller.SetIgnoredPartsTag(argument, argument_2)
    update_ignore_tag(argument_2)
end

function click_to_move_controller.GetIgnoredPartsTag(argument)
    return value
end

function click_to_move_controller.SetUseDirectPath(argument, argument_2)
    enabled_3 = argument_2
end

function click_to_move_controller.GetUseDirectPath(argument)
    return enabled_3
end

function click_to_move_controller.SetAgentSizeIncreaseFactor(argument: table, argument_2: number)
    number = argument_2 / 100 + 1
end

function click_to_move_controller.GetAgentSizeIncreaseFactor(argument)
    return (number - 1) * 100
end

function click_to_move_controller.SetUnreachableWaypointTimeout(argument, argument_2)
    number_2 = argument_2
end

function click_to_move_controller.GetUnreachableWaypointTimeout(argument)
    return number_2
end

function click_to_move_controller.SetUserJumpEnabled(argument, jump_enabled)
    argument.jumpEnabled = jump_enabled

    if argument.touchJumpController then
        argument.touchJumpController:Enable(jump_enabled)
    end
end

function click_to_move_controller.GetUserJumpEnabled(argument)
    return argument.jumpEnabled
end

function click_to_move_controller.MoveTo(argument, original_target_point, argument_2, direct_path)
    local character = local_player.Character

    if character == nil then
        return false
    end

    local result_3 = pather(original_target_point, Vector3.new(0, 1, 0), direct_path)

    if not (result_3 and result_3:IsValidPath()) then
        return false
    end

    handle_move_to(result_3, original_target_point, nil, character, argument_2)

    return true
end

return click_to_move_controller
