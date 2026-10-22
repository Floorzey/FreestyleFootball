local success, value = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserExcludeNonCollidableForPathfinding")
end)
local value_2 = success and value
local success_2, value_3 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserClickToMoveSupportAgentCanClimb2")
end)
local value_4 = success_2 and value_3
local user_input_service = game:GetService("UserInputService")
local pathfinding_service = game:GetService("PathfindingService")
local players = game:GetService("Players")
local _ = game:GetService("Debris")
local starter_gui = game:GetService("StarterGui")
local workspace = game:GetService("Workspace")
local collection_service = game:GetService("CollectionService")
local gui_service = game:GetService("GuiService")
local get_user_flag_result =
    require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")).getUserFlag(
        "UserUpdateInputConnections"
    )
local enabled = true
local enabled_2 = true
local enabled_3 = false
local number = 1
local number_2 = 8
local values = {}
values[Enum.KeyCode.W] = true
values[Enum.KeyCode.A] = true
values[Enum.KeyCode.S] = true
values[Enum.KeyCode.D] = true
values[Enum.KeyCode.Up] = true
values[Enum.KeyCode.Down] = true
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

local function raycast(argument, argument_2, argument_3)
    local items_2 = argument_3 or {}
    local hit_part, value_7, value_8, value_9 = workspace:FindPartOnRayWithIgnoreList(argument, items_2)

    if not hit_part then
        return nil, nil
    end

    if argument_2 and hit_part.CanCollide == false then
        local value_10, value_11 = nil, nil

        if hit_part then
            value_10 = hit_part:FindFirstChildOfClass("Humanoid")

            if value_10 then
                value_11 = value_10
            else
                local _, value_12 = find_character_ancestor(hit_part.Parent)
                value_11 = value_12
            end
        else
            value_11 = nil
        end

        if value_11 == nil then
            table.insert(items_2, hit_part)

            return raycast(argument, argument_2, items_2)
        end
    end

    return hit_part, value_7, value_8, value_9
end

values_2.Raycast = raycast
local values_3 = {}

local function find_player_humanoid(player)
    local character = player and player.Character

    if not character then
        return
    end

    local value_entry = values_3[player]

    if value_entry and value_entry.Parent == character then
        return value_entry
    end

    values_3[player] = nil
    local humanoid = player:FindFirstChildOfClass("Humanoid")

    if humanoid then
        values_3[player] = humanoid
    end

    return humanoid
end

local items = nil
local value_5 = nil
local connection = nil
local connection_2 = nil

local function get_character()
    local character

    if local_player then
        character = local_player.Character
    else
        character = local_player
    end

    return character
end

local function update_ignore_tag(argument)
    if argument == value_5 then
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

    value_5 = argument
    local values_4 = {}
    local character

    if local_player then
        character = local_player.Character
    else
        character = local_player
    end

    values_4[1] = character
    items = values_4

    if value_5 == nil then
        return
    end

    for _, tagged_instance in ipairs(collection_service:GetTagged(value_5)) do
        table.insert(items, tagged_instance)
    end

    local connection_5 = collection_service:GetInstanceAddedSignal(value_5):Connect(function(argument_2)
        table.insert(items, argument_2)
    end)
    connection = connection_5
    local connection_6 = collection_service:GetInstanceRemovedSignal(value_5):Connect(function(argument_2)
        for n = 1, #items do
            if items[n] ~= argument_2 then
                continue
            end

            items[n] = items[#items]
            table.remove(items)

            return
        end
    end)
    connection_2 = connection_6
end

local function get_ignore_list()
    if not items then
        items = {}
        assert(items, "")
        table.insert(items, local_player and local_player.Character)
    end

    return items
end

local function min_v(argument, argument_2)
    return (
        Vector3.new(
            math.min(argument.X, argument_2.X),
            math.min(argument.Y, argument_2.Y),
            math.min(argument.Z, argument_2.Z)
        )
    )
end

local function max_v(argument, argument_2)
    return (
        Vector3.new(
            math.max(argument.X, argument_2.X),
            math.max(argument.Y, argument_2.Y),
            math.max(argument.Z, argument_2.Z)
        )
    )
end

local function get_collidable_extents_size(argument)
    if argument == nil or argument.PrimaryPart == nil then
        return
    end

    assert(argument, "")
    assert(argument.PrimaryPart, "")
    local inverse_result = argument.PrimaryPart.CFrame:Inverse()
    local vector = Vector3.new((1 / 0), (1 / 0), (1 / 0))
    local vector_2 = Vector3.new((-1 / 0), (-1 / 0), (-1 / 0))

    for _, descendant in pairs(argument:GetDescendants()) do
        local is_a_result = descendant:IsA("BasePart")

        if not is_a_result or not descendant.CanCollide then
            continue
        end

        local vector_3 = Vector3.new(descendant.Size.X / 2, descendant.Size.Y / 2, descendant.Size.Z / 2)

        for index, item in ipairs({
            Vector3.new(vector_3.X, vector_3.Y, vector_3.Z),
            Vector3.new(vector_3.X, vector_3.Y, -vector_3.Z),
            Vector3.new(vector_3.X, -vector_3.Y, vector_3.Z),
            Vector3.new(vector_3.X, -vector_3.Y, -vector_3.Z),
            Vector3.new(-vector_3.X, vector_3.Y, vector_3.Z),
            Vector3.new(-vector_3.X, vector_3.Y, -vector_3.Z),
            Vector3.new(-vector_3.X, -vector_3.Y, vector_3.Z),
            Vector3.new(-vector_3.X, -vector_3.Y, -vector_3.Z),
        }) do
            local product = inverse_result * descendant.CFrame * item
            vector =
                Vector3.new(math.min(vector.X, product.X), math.min(vector.Y, product.Y), math.min(vector.Z, product.Z))
            vector_2 = Vector3.new(
                math.max(vector_2.X, product.X),
                math.max(vector_2.Y, product.Y),
                math.max(vector_2.Z, product.Z)
            )
        end
    end

    local difference = vector_2 - vector

    if not (difference.X < 0) and not (difference.Y < 0) and not (difference.Z < 0) then
        return difference
    end

    return nil
end

local function pather(original_target_point, target_surface_normal, argument)
    local character_4 = {}
    local direct_path, direct_path_2

    if argument == nil then
        direct_path = enabled_3
        direct_path_2 = true
    else
        direct_path_2, direct_path = argument, argument
    end

    character_4.Cancelled = false
    character_4.Started = false
    character_4.Finished = Instance.new("BindableEvent")
    character_4.PathFailed = Instance.new("BindableEvent")
    character_4.PathComputing = false
    character_4.PathComputed = false
    character_4.OriginalTargetPoint = original_target_point
    character_4.TargetPoint = original_target_point
    character_4.TargetSurfaceNormal = target_surface_normal
    character_4.DiedConn = nil
    character_4.SeatedConn = nil
    character_4.BlockedConn = nil
    character_4.TeleportedConn = nil
    character_4.CurrentPoint = 0
    character_4.HumanoidOffsetFromPath = Vector3.new(0, 0, 0)
    character_4.CurrentWaypointPosition = nil
    character_4.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
    character_4.CurrentWaypointPlaneDistance = 0
    character_4.CurrentWaypointNeedsJump = false
    character_4.CurrentHumanoidPosition = Vector3.new(0, 0, 0)
    character_4.CurrentHumanoidVelocity = 0
    character_4.NextActionMoveDirection = Vector3.new(0, 0, 0)
    character_4.NextActionJump = false
    character_4.Timeout = 0
    local agent_radius = local_player
    local character = agent_radius and agent_radius.Character
    local agent_can_jump, value_7, humanoid = nil, nil, nil

    if character then
        agent_can_jump = values_3[agent_radius]

        if agent_can_jump and agent_can_jump.Parent == character then
            humanoid = agent_can_jump
        else
            values_3[agent_radius] = nil
            value_7 = local_player:FindFirstChildOfClass("Humanoid")

            if value_7 then
                values_3[agent_radius] = value_7
            end

            humanoid = value_7
        end
    else
        humanoid = nil
    end

    character_4.Humanoid = humanoid
    character_4.OriginPoint = nil
    character_4.AgentCanFollowPath = false
    character_4.DirectPath = false
    character_4.DirectPathRiseFirst = false
    character_4.stopTraverseFunc = nil
    character_4.setPointFunc = nil
    character_4.pointList = nil
    humanoid = character_4.Humanoid and character_4.Humanoid.RootPart
    local primary_part_2 = nil

    if humanoid then
        character_4.OriginPoint = humanoid.CFrame.Position
        agent_radius = 2
        character = 5
        agent_can_jump = true
        primary_part_2 = character_4.Humanoid.SeatPart

        if primary_part_2 then
            local value_8 = nil

            if primary_part_2:IsA("VehicleSeat") then
                value_8 = primary_part_2:FindFirstAncestorOfClass("Model")

                if value_8 then
                    local primary_part = value_8.PrimaryPart
                    value_8.PrimaryPart = primary_part_2

                    if direct_path_2 then
                        local extents_size = value_8:GetExtentsSize()
                        local _ = number
                            * 0.5
                            * math.sqrt((extents_size.X * extents_size.X) + (extents_size.Z * extents_size.Z))
                        local product = number * extents_size.Y
                        agent_can_jump = false
                        character_4.AgentCanFollowPath = true
                        character_4.DirectPath = direct_path_2
                    end

                    value_8.PrimaryPart = primary_part
                end
            else
                local value_9 = nil

                if value_2 then
                    local character_2 = local_player and local_player.Character

                    if character_2 ~= nil then
                        value_9 = get_collidable_extents_size(character_2)
                    end
                end

                if value_9 == nil then
                    value_9 = (local_player and local_player.Character):GetExtentsSize()
                end

                assert(value_9, "")
                local product_2 = number * 0.5 * math.sqrt((value_9.X * value_9.X) + (value_9.Z * value_9.Z))
                local product_3 = number * value_9.Y
                local condition = character_4.Humanoid.JumpPower > 0
                character_4.AgentCanFollowPath = true
                character_4.DirectPath = direct_path
                character_4.DirectPathRiseFirst = character_4.Humanoid.Sit
                agent_radius, character, agent_can_jump = product_2, product_3, condition
            end
        else
            local value_10 = nil

            if value_2 then
                local character_3 = local_player and local_player.Character

                if character_3 ~= nil then
                    value_10 = get_collidable_extents_size(character_3)
                end
            end

            if value_10 == nil then
                value_10 = (local_player and local_player.Character):GetExtentsSize()
            end

            assert(value_10, "")
            local product_4 = number * 0.5 * math.sqrt((value_10.X * value_10.X) + (value_10.Z * value_10.Z))
            local product_5 = number * value_10.Y
            local condition_2 = character_4.Humanoid.JumpPower > 0
            character_4.AgentCanFollowPath = true
            character_4.DirectPath = direct_path
            character_4.DirectPathRiseFirst = character_4.Humanoid.Sit
            agent_radius, character, agent_can_jump = product_4, product_5, condition_2
        end

        if value_4 then
            character_4.pathResult = pathfinding_service:CreatePath({
                AgentCanClimb = true,
                AgentRadius = agent_radius,
                AgentHeight = character,
                AgentCanJump = agent_can_jump,
            })
        else
            character_4.pathResult = pathfinding_service:CreatePath({
                AgentRadius = agent_radius,
                AgentHeight = character,
                AgentCanJump = agent_can_jump,
            })
        end
    end

    function character_4.Cleanup(argument_2)
        if character_4.stopTraverseFunc then
            character_4.stopTraverseFunc()
            character_4.stopTraverseFunc = nil
        end

        if character_4.BlockedConn then
            character_4.BlockedConn:Disconnect()
            character_4.BlockedConn = nil
        end

        if character_4.DiedConn then
            character_4.DiedConn:Disconnect()
            character_4.DiedConn = nil
        end

        if character_4.SeatedConn then
            character_4.SeatedConn:Disconnect()
            character_4.SeatedConn = nil
        end

        if character_4.TeleportedConn then
            character_4.TeleportedConn:Disconnect()
            character_4.TeleportedConn = nil
        end

        character_4.Started = false
    end

    function character_4.Cancel(argument_2)
        character_4.Cancelled = true
        character_4:Cleanup()
    end

    function character_4.IsActive(argument_2)
        return character_4.AgentCanFollowPath and (character_4.Started and not character_4.Cancelled)
    end

    function character_4.OnPathInterrupted(argument_2)
        character_4.Cancelled = true
        character_4:OnPointReached(false)
    end

    function character_4.ComputePath(argument_2)
        if not character_4.OriginPoint then
            return
        end

        if not (not character_4.PathComputed and not character_4.PathComputing) then
            return
        end

        character_4.PathComputing = true

        if character_4.AgentCanFollowPath then
            if character_4.DirectPath then
                local path_waypoint = PathWaypoint.new(character_4.OriginPoint, Enum.PathWaypointAction.Walk)
                character_4.pointList = {
                    path_waypoint,
                    PathWaypoint.new(
                        character_4.TargetPoint,
                        (character_4.DirectPathRiseFirst and Enum.PathWaypointAction.Jump)
                            or Enum.PathWaypointAction.Walk
                    ),
                }
                character_4.PathComputed = true
            else
                character_4.pathResult:ComputeAsync(character_4.OriginPoint, character_4.TargetPoint)
                character_4.pointList = character_4.pathResult:GetWaypoints()
                character_4.BlockedConn = character_4.pathResult.Blocked:Connect(function(argument_3)
                    character_4:OnPathBlocked(argument_3)
                end)
                character_4.PathComputed = character_4.pathResult.Status == Enum.PathStatus.Success
            end
        end

        character_4.PathComputing = false

        return
    end

    function character_4.IsValidPath(argument_2)
        character_4:ComputePath()

        return character_4.PathComputed and character_4.AgentCanFollowPath
    end

    character_4.Recomputing = false

    function character_4.OnPathBlocked(argument_2, argument_3)
        if not (character_4.CurrentPoint <= argument_3) or character_4.Recomputing then
            return
        end

        character_4.Recomputing = true

        if character_4.stopTraverseFunc then
            character_4.stopTraverseFunc()
            character_4.stopTraverseFunc = nil
        end

        character_4.OriginPoint = character_4.Humanoid.RootPart.CFrame.p
        character_4.pathResult:ComputeAsync(character_4.OriginPoint, character_4.TargetPoint)
        character_4.pointList = character_4.pathResult:GetWaypoints()

        if #character_4.pointList > 0 then
            character_4.HumanoidOffsetFromPath = character_4.pointList[1].Position - character_4.OriginPoint
        end

        character_4.PathComputed = character_4.pathResult.Status == Enum.PathStatus.Success

        if enabled then
            local stop_traverse_func, set_point_func = click_to_move_display.CreatePathDisplay(character_4.pointList)
            character_4.stopTraverseFunc = stop_traverse_func
            character_4.setPointFunc = set_point_func
        end

        if character_4.PathComputed then
            character_4.CurrentPoint = 1
            character_4:OnPointReached(true)
        else
            character_4.PathFailed:Fire()
            character_4:Cleanup()
        end

        character_4.Recomputing = false
    end

    function character_4.OnRenderStepped(argument_2, argument_3)
        if not character_4.Started or character_4.Cancelled then
            return
        end

        character_4.Timeout = character_4.Timeout + argument_3

        if number_2 < character_4.Timeout then
            character_4:OnPointReached(false)
        else
            character_4.CurrentHumanoidPosition = character_4.Humanoid.RootPart.Position
                + character_4.HumanoidOffsetFromPath
            character_4.CurrentHumanoidVelocity = character_4.Humanoid.RootPart.Velocity

            while character_4.Started do
                if character_4:IsCurrentWaypointReached() then
                    character_4:OnPointReached(true)
                    continue
                else
                    break
                end
            end

            if not character_4.Started then
                return
            end

            character_4.NextActionMoveDirection = character_4.CurrentWaypointPosition
                - character_4.CurrentHumanoidPosition

            if character_4.NextActionMoveDirection.Magnitude > 1e-06 then
                character_4.NextActionMoveDirection = character_4.NextActionMoveDirection.Unit
            else
                character_4.NextActionMoveDirection = Vector3.new(0, 0, 0)
            end

            if character_4.CurrentWaypointNeedsJump then
                character_4.NextActionJump = true
                character_4.CurrentWaypointNeedsJump = false
            else
                character_4.NextActionJump = false
            end
        end
    end

    function character_4.IsCurrentWaypointReached(argument_2)
        local enabled_4

        if character_4.CurrentWaypointPlaneNormal == Vector3.new(0, 0, 0) then
            enabled_4 = true
        else
            enabled_4 = character_4.CurrentWaypointPlaneNormal:Dot(character_4.CurrentHumanoidPosition)
                    - character_4.CurrentWaypointPlaneDistance
                < math.max(1, 0.0625 * -character_4.CurrentWaypointPlaneNormal:Dot(character_4.CurrentHumanoidVelocity))
        end

        if enabled_4 then
            character_4.CurrentWaypointPosition = nil
            character_4.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            character_4.CurrentWaypointPlaneDistance = 0
        end

        return enabled_4
    end

    function character_4.OnPointReached(argument_2, argument_3)
        if argument_3 and not character_4.Cancelled then
            if character_4.setPointFunc then
                character_4.setPointFunc(character_4.CurrentPoint)
            end

            local sum = character_4.CurrentPoint + 1
            local value_11 = nil

            if #character_4.pointList < sum then
                if character_4.stopTraverseFunc then
                    character_4.stopTraverseFunc()
                end

                character_4.Finished:Fire()
                character_4:Cleanup()
            else
                local point_list_entry = character_4.pointList[character_4.CurrentPoint]
                local point_list_entry_2 = character_4.pointList[sum]
                value_11 = character_4.Humanoid:GetState()
                local enabled_4 = true
                local enabled_5

                if value_11 == Enum.HumanoidStateType.FallingDown then
                    enabled_5 = enabled_4
                else
                    enabled_5 = true

                    if value_11 ~= Enum.HumanoidStateType.Freefall then
                        enabled_5 = value_11 == Enum.HumanoidStateType.Jumping
                    end
                end

                if enabled_5 then
                    value_11 = point_list_entry_2.Action == Enum.PathWaypointAction.Jump

                    if not value_11 and character_4.CurrentPoint > 1 then
                        local _ = point_list_entry.Position
                            - character_4.pointList[character_4.CurrentPoint - 1].Position
                        local difference = point_list_entry_2.Position - point_list_entry.Position
                        value_11 = Vector2.new(
                            (point_list_entry.Position - character_4.pointList[character_4.CurrentPoint - 1].Position).x,
                            (point_list_entry.Position - character_4.pointList[character_4.CurrentPoint - 1].Position).z
                        ).Unit
                            :Dot(
                                Vector2.new(
                                    (point_list_entry_2.Position - point_list_entry.Position).x,
                                    (point_list_entry_2.Position - point_list_entry.Position).z
                                ).Unit
                            ) < 0.996
                    end

                    if value_11 then
                        character_4.Humanoid.FreeFalling:Wait()
                        wait(0.1)
                    end
                end

                character_4:MoveToNextWayPoint(point_list_entry, point_list_entry_2, sum)
            end

            return
        end

        character_4.PathFailed:Fire()
        character_4:Cleanup()
    end

    function character_4.MoveToNextWayPoint(argument_2, argument_3, argument_4, current_point)
        character_4.CurrentWaypointPlaneNormal = argument_3.Position - argument_4.Position

        if not value_4 or argument_4.Label ~= "Climb" then
            character_4.CurrentWaypointPlaneNormal =
                Vector3.new(character_4.CurrentWaypointPlaneNormal.X, 0, character_4.CurrentWaypointPlaneNormal.Z)
        end

        if character_4.CurrentWaypointPlaneNormal.Magnitude > 1e-06 then
            character_4.CurrentWaypointPlaneNormal = character_4.CurrentWaypointPlaneNormal.Unit
            character_4.CurrentWaypointPlaneDistance = character_4.CurrentWaypointPlaneNormal:Dot(argument_4.Position)
        else
            character_4.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            character_4.CurrentWaypointPlaneDistance = 0
        end

        character_4.CurrentWaypointNeedsJump = argument_4.Action == Enum.PathWaypointAction.Jump
        character_4.CurrentWaypointPosition = argument_4.Position
        character_4.CurrentPoint = current_point
        character_4.Timeout = 0
    end

    function character_4.Start(argument_2, argument_3)
        if character_4.AgentCanFollowPath then
            if character_4.Started then
                return
            end

            character_4.Started = true
            click_to_move_display.CancelFailureAnimation()

            if enabled and (argument_3 == nil or argument_3) then
                local stop_traverse_func, set_point_func =
                    click_to_move_display.CreatePathDisplay(character_4.pointList, character_4.OriginalTargetPoint)
                character_4.stopTraverseFunc = stop_traverse_func
                character_4.setPointFunc = set_point_func
            end

            if #character_4.pointList > 0 then
                character_4.HumanoidOffsetFromPath =
                    Vector3.new(0, character_4.pointList[1].Position.Y - character_4.OriginPoint.Y, 0)
                character_4.CurrentHumanoidPosition = character_4.Humanoid.RootPart.Position
                    + character_4.HumanoidOffsetFromPath
                character_4.CurrentHumanoidVelocity = character_4.Humanoid.RootPart.Velocity
                character_4.SeatedConn = character_4.Humanoid.Seated:Connect(function(argument_4, argument_5)
                    character_4:OnPathInterrupted()
                end)
                character_4.DiedConn = character_4.Humanoid.Died:Connect(function()
                    character_4:OnPathInterrupted()
                end)
                character_4.TeleportedConn = character_4.Humanoid.RootPart
                    :GetPropertyChangedSignal("CFrame")
                    :Connect(function()
                        character_4:OnPathInterrupted()
                    end)
                character_4.CurrentPoint = 1
                character_4:OnPointReached(true)
            else
                character_4.PathFailed:Fire()

                if character_4.stopTraverseFunc then
                    character_4.stopTraverseFunc()
                end
            end
        else
            character_4.PathFailed:Fire()
        end
    end

    local ray = Ray.new(character_4.TargetPoint + (character_4.TargetSurfaceNormal * 1.5), Vector3.new(0, -50, 0))

    if not items then
        items = {}
        assert(items, "")
        table.insert(items, local_player and local_player.Character)
    end

    local hit_part, target_point = workspace:FindPartOnRayWithIgnoreList(ray, items)

    if hit_part then
        character_4.TargetPoint = target_point
    end

    character_4:ComputePath()

    return character_4
end

local function check_alive()
    local character = local_player and local_player.Character
    local value_7, value_8, value_9 = nil, nil, nil

    if character then
        value_7 = values_3[local_player]

        if value_7 and value_7.Parent == character then
            value_9 = value_7
        else
            values_3[local_player] = nil
            value_8 = local_player:FindFirstChildOfClass("Humanoid")

            if value_8 then
                values_3[local_player] = value_8
            end

            value_9 = value_8
        end
    else
        value_9 = nil
    end

    local enabled_4 = false

    if value_9 ~= nil then
        enabled_4 = value_9.Health > 0
    end

    return enabled_4
end

local value_6 = nil
local connection_3 = nil
local connection_4 = nil

local function cleanup_path()
    if value_6 then
        value_6:Cancel()
        value_6 = nil
    end

    if connection_3 then
        connection_3:Disconnect()
        connection_3 = nil
    end

    if not connection_4 then
        return
    end

    connection_4:Disconnect()
    connection_4 = nil
end

local function get_equipped_tool(instance)
    if instance == nil then
        return
    end

    for _, child in pairs(instance:GetChildren()) do
        if not (child:IsA("Tool")) then
            continue
        end

        return child
    end
end

local function handle_move_to(argument, argument_2, argument_3, instance, argument_4)
    if value_6 then
        if value_6 then
            value_6:Cancel()
            value_6 = nil
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

    value_6 = argument
    argument:Start(argument_4)
    local connection_5 = argument.Finished.Event:Connect(function()
        if value_6 then
            value_6:Cancel()
            value_6 = nil
        end

        if connection_3 then
            connection_3:Disconnect()
            connection_3 = nil
        end

        if connection_4 then
            connection_4:Disconnect()
            connection_4 = nil
        end

        if not argument_3 then
            return
        end

        local result = get_equipped_tool(instance)

        if not result then
            return
        end

        result:Activate()
    end)
    connection_3 = connection_5
    local connection_6 = argument.PathFailed.Event:Connect(function()
        if value_6 then
            value_6:Cancel()
            value_6 = nil
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
            local is_active_result = value_6 and value_6:IsActive()
            enabled_4 = not is_active_result
        end

        if enabled_4 then
            click_to_move_display.PlayFailureAnimation()
        end

        click_to_move_display.DisplayFailureWaypoint(argument_2)
    end)
    connection_4 = connection_6
end

local function show_path_failed_feedback(argument)
    if value_6 and value_6:IsActive() then
        value_6:Cancel()
    end

    if enabled_2 then
        click_to_move_display.PlayFailureAnimation()
    end

    click_to_move_display.DisplayFailureWaypoint(argument)
end

function OnTap(argument, argument_2, argument_3)
    local current_camera = workspace.CurrentCamera
    local character = local_player.Character
    local character_2 = local_player and local_player.Character
    local value_7, value_8, value_9 = nil, nil, nil

    if character_2 then
        value_7 = values_3[local_player]

        if value_7 and value_7.Parent == character_2 then
            value_9 = value_7
        else
            values_3[local_player] = nil
            value_8 = local_player:FindFirstChildOfClass("Humanoid")

            if value_8 then
                values_3[local_player] = value_8
            end

            value_9 = value_8
        end
    else
        value_9 = nil
    end

    local enabled_4 = false

    if value_9 ~= nil then
        enabled_4 = value_9.Health > 0
    end

    if not enabled_4 then
        return
    end

    if #argument ~= 1 and not argument_2 then
        if #argument >= 2 and current_camera then
            enabled_4 = get_equipped_tool(character)

            if enabled_4 then
                enabled_4:Activate()
            end
        end

        return
    end

    if not current_camera then
        return
    end

    enabled_4 = current_camera:ScreenPointToRay(argument[1].X, argument[1].Y)
    local ray = Ray.new(enabled_4.Origin, enabled_4.Direction * 1000)
    local player = local_player
    local original_target_point = player and player.Character
    local value_10, value_11 = nil, nil

    if original_target_point then
        value_10 = values_3[player]

        if not value_10 or value_10.Parent ~= original_target_point then
            values_3[player] = nil
            value_11 = original_target_point:FindFirstChildOfClass("Humanoid")

            if value_11 then
                values_3[player] = value_11
            end
        end
    end

    local raycast_2 = values_2.Raycast

    if not items then
        items = {}
        assert(items, "")
        table.insert(items, local_player and local_player.Character)
    end

    local target_surface_normal
    player, original_target_point, target_surface_normal = raycast_2(ray, true, items)
    local character_ancestor, value_12 = values_2.FindCharacterAncestor(player)

    if
        argument_3
        and value_12
        and starter_gui:GetCore("AvatarContextMenuEnabled")
        and players:GetPlayerFromCharacter(value_12.Parent)
    then
        if value_6 then
            value_6:Cancel()
            value_6 = nil
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

    if argument_2 then
        local _ = nil
        original_target_point = argument_2
    end

    if not original_target_point or not character then
        return
    end

    if value_6 then
        value_6:Cancel()
        value_6 = nil
    end

    if connection_3 then
        connection_3:Disconnect()
        connection_3 = nil
    end

    if connection_4 then
        connection_4:Disconnect()
        connection_4 = nil
    end

    local result = pather(original_target_point, target_surface_normal)

    if result:IsValidPath() then
        handle_move_to(result, original_target_point, character_ancestor, character)
    else
        result:Cleanup()

        if value_6 and value_6:IsActive() then
            value_6:Cancel()
        end

        if enabled_2 then
            click_to_move_display.PlayFailureAnimation()
        end

        click_to_move_display.DisplayFailureWaypoint(original_target_point)
    end
end

local function disconnect_event(connection_5)
    if not connection_5 then
        return
    end

    connection_5:Disconnect()
end

local keyboard = require(script.Parent:WaitForChild("Keyboard"))
local click_to_move_controller = setmetatable({}, keyboard)
click_to_move_controller.__index = click_to_move_controller

function click_to_move_controller.new(argument)
    local instance = setmetatable(keyboard.new(argument), click_to_move_controller)
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

    if not menu_opened_connection then
        return
    end

    menu_opened_connection:Disconnect()
end

function click_to_move_controller.OnTouchBegan(argument, argument_2, argument_3)
    if argument.fingerTouches[argument_2] == nil and not argument_3 then
        argument.numUnsunkTouches = argument.numUnsunkTouches + 1
    end

    argument.fingerTouches[argument_2] = argument_3
end

function click_to_move_controller.OnTouchChanged(argument, argument_2, argument_3)
    if argument.fingerTouches[argument_2] ~= nil then
        return
    end

    argument.fingerTouches[argument_2] = argument_3

    if argument_3 then
        return
    end

    argument.numUnsunkTouches = argument.numUnsunkTouches + 1
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
            and game_processed == false
            and input.UserInputType == Enum.UserInputType.Keyboard
            and values[input.KeyCode]
        then
            if value_6 then
                value_6:Cancel()
                value_6 = nil
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

        if input.UserInputType ~= Enum.UserInputType.MouseButton2 then
            return
        end

        argument.mouse2DownTime = tick()
        argument.mouse2DownPos = input.Position
    end)
    argument.inputChangedConn = user_input_service.InputChanged:Connect(function(input, game_processed)
        if input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        argument:OnTouchChanged(input, game_processed)
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
        local condition = value_6 or (argument.keyboardMoveVector.Magnitude <= 0)

        if
            not (argument.mouse2UpTime - argument.mouse2DownTime < 0.25)
            or not ((position - argument.mouse2DownPos).magnitude < 5)
            or not condition
        then
            return
        end

        OnTap({ position })
    end)
    argument.tapConn = user_input_service.TouchTap:Connect(function(argument_2, argument_3)
        if argument_3 then
            return
        end

        OnTap(argument_2, nil, true)
    end)
    argument.menuOpenedConnection = gui_service.MenuOpened:Connect(function()
        if value_6 then
            value_6:Cancel()
            value_6 = nil
        end

        if connection_3 then
            connection_3:Disconnect()
            connection_3 = nil
        end

        if not connection_4 then
            return
        end

        connection_4:Disconnect()
        connection_4 = nil
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
        if not user_input_service.TouchEnabled or not child_2:IsA("Tool") then
            return
        end

        child_2.ManualActivationOnly = false
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
    if value_6 then
        value_6:Cancel()
        value_6 = nil
    end

    if connection_3 then
        connection_3:Disconnect()
        connection_3 = nil
    end

    if not connection_4 then
        return
    end

    connection_4:Disconnect()
    connection_4 = nil
end

function click_to_move_controller.Enable(argument, enabled_4, wasd_enabled, touch_jump_controller)
    if enabled_4 then
        if not argument.running then
            if local_player.Character then
                argument:OnCharacterAdded(local_player.Character)
            end

            argument.onCharacterAddedConn = local_player.CharacterAdded:Connect(function(character)
                argument:OnCharacterAdded(character)
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

            if value_6 then
                value_6:Cancel()
                value_6 = nil
            end

            if connection_3 then
                connection_3:Disconnect()
                connection_3 = nil
            end

            if connection_4 then
                connection_4:Disconnect()
                connection_4 = nil
            end

            local instance = nil

            if user_input_service.TouchEnabled then
                instance = local_player.Character

                if instance then
                    for _, child in pairs(instance:GetChildren()) do
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

    if get_user_flag_result then
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

    argument.wasdEnabled = (enabled_4 and wasd_enabled) or false
    argument.enabled = enabled_4
end

function click_to_move_controller.OnRenderStepped(argument, argument_2)
    argument.isJumping = false

    if value_6 then
        value_6:OnRenderStepped(argument_2)

        if value_6 then
            argument.moveVector = value_6.NextActionMoveDirection
            argument.moveVectorIsCameraRelative = false

            if value_6.NextActionJump then
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

    if not argument.jumpRequested then
        return
    end

    argument.isJumping = true
end

function click_to_move_controller.UpdateMovement(argument, argument_2)
    if argument_2 == Enum.UserInputState.Cancel then
        argument.keyboardMoveVector = Vector3.new(0, 0, 0)
    elseif argument.wasdEnabled then
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
    return value_5
end

function click_to_move_controller.SetUseDirectPath(argument, argument_2)
    enabled_3 = argument_2
end

function click_to_move_controller.GetUseDirectPath(argument)
    return enabled_3
end

function click_to_move_controller.SetAgentSizeIncreaseFactor(argument, argument_2)
    number = (argument_2 / 100) + 1
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

    if not argument.touchJumpController then
        return
    end

    argument.touchJumpController:Enable(jump_enabled)
end

function click_to_move_controller.GetUserJumpEnabled(argument)
    return argument.jumpEnabled
end

function click_to_move_controller.MoveTo(argument, original_target_point, argument_2, argument_3)
    local character = local_player.Character

    if character == nil then
        return false
    end

    local result = pather(original_target_point, Vector3.new(0, 1, 0), argument_3)

    if result and result:IsValidPath() then
        handle_move_to(result, original_target_point, nil, character, argument_2)

        return true
    end

    return false
end

return click_to_move_controller
