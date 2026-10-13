local success, value = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserExcludeNonCollidableForPathfinding")
end)
local success_3 = success and value
local success_2, value_2 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserClickToMoveSupportAgentCanClimb2")
end)
local success_4 = success_2 and value_2
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
    local hit_part, value_5, value_6, value_7 = workspace:FindPartOnRayWithIgnoreList(argument, items_2)
    if hit_part then
        if argument_2 and hit_part.CanCollide == false then
            local value_8, value_9 = nil, nil
            if hit_part then
                value_8 = hit_part:FindFirstChildOfClass("Humanoid")
                if value_8 then
                    value_9 = value_8
                else
                    local _, value_10 = find_character_ancestor(hit_part.Parent)
                    value_9 = value_10
                end
            else
                value_9 = nil
            end
            if value_9 == nil then
                table.insert(items_2, hit_part)
                return raycast(argument, argument_2, items_2)
            end
        end
        return hit_part, value_5, value_6, value_7
    end
    return nil, nil
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
local value_3 = nil
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
    if argument == value_3 then
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
    value_3 = argument
    local values_4 = {}
    local character
    if local_player then
        character = local_player.Character
    else
        character = local_player
    end
    values_4[1] = character
    items = values_4
    if value_3 ~= nil then
        for _, tagged_instance in ipairs(collection_service:GetTagged(value_3)) do
            table.insert(items, tagged_instance)
        end
        local connection_5 = collection_service:GetInstanceAddedSignal(value_3):Connect(function(argument_2)
            table.insert(items, argument_2)
        end)
        connection = connection_5
        local connection_6 = collection_service:GetInstanceRemovedSignal(value_3):Connect(function(argument_2)
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
    local vector = Vector3.new(inf, inf, inf)
    local vector_2 = Vector3.new(-inf, -inf, -inf)
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
            local inverse_result_offset_offset = inverse_result * descendant.CFrame * item
            vector = Vector3.new(
                math.min(vector.X, inverse_result_offset_offset.X),
                math.min(vector.Y, inverse_result_offset_offset.Y),
                math.min(vector.Z, inverse_result_offset_offset.Z)
            )
            vector_2 = Vector3.new(
                math.max(vector_2.X, inverse_result_offset_offset.X),
                math.max(vector_2.Y, inverse_result_offset_offset.Y),
                math.max(vector_2.Z, inverse_result_offset_offset.Z)
            )
        end
    end
    local vector_offset = vector_2 - vector
    if not (vector_offset.X < 0) and not (vector_offset.Y < 0) and not (vector_offset.Z < 0) then
        return vector_offset
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
    local agent_can_jump, value_5, humanoid = nil, nil, nil
    if character then
        agent_can_jump = values_3[agent_radius]
        if agent_can_jump and agent_can_jump.Parent == character then
            humanoid = agent_can_jump
        else
            values_3[agent_radius] = nil
            value_5 = local_player:FindFirstChildOfClass("Humanoid")
            if value_5 then
                values_3[agent_radius] = value_5
            end
            humanoid = value_5
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
            local value_6 = nil
            if primary_part_2:IsA("VehicleSeat") then
                value_6 = primary_part_2:FindFirstAncestorOfClass("Model")
                if value_6 then
                    local primary_part = value_6.PrimaryPart
                    value_6.PrimaryPart = primary_part_2
                    if direct_path_2 then
                        local extents_size = value_6:GetExtentsSize()
                        local _ = number
                            * 0.5
                            * math.sqrt((extents_size.X * extents_size.X) + (extents_size.Z * extents_size.Z))
                        local number_offset = number * extents_size.Y
                        agent_can_jump = false
                        character_4.AgentCanFollowPath = true
                        character_4.DirectPath = direct_path_2
                    end
                    value_6.PrimaryPart = primary_part
                end
            else
                local value_7 = nil
                if success_3 then
                    local character_2 = local_player and local_player.Character
                    if character_2 ~= nil then
                        value_7 = get_collidable_extents_size(character_2)
                    end
                end
                if value_7 == nil then
                    value_7 = (local_player and local_player.Character):GetExtentsSize()
                end
                assert(value_7, "")
                local number_offset_offset = number * 0.5 * math.sqrt((value_7.X * value_7.X) + (value_7.Z * value_7.Z))
                local number_offset_2 = number * value_7.Y
                local is_jump_power = character_4.Humanoid.JumpPower > 0
                character_4.AgentCanFollowPath = true
                character_4.DirectPath = direct_path
                character_4.DirectPathRiseFirst = character_4.Humanoid.Sit
                agent_radius, character, agent_can_jump = number_offset_offset, number_offset_2, is_jump_power
            end
        else
            local value_8 = nil
            if success_3 then
                local character_3 = local_player and local_player.Character
                if character_3 ~= nil then
                    value_8 = get_collidable_extents_size(character_3)
                end
            end
            if value_8 == nil then
                value_8 = (local_player and local_player.Character):GetExtentsSize()
            end
            assert(value_8, "")
            local number_offset_offset_2 = number * 0.5 * math.sqrt((value_8.X * value_8.X) + (value_8.Z * value_8.Z))
            local number_offset_3 = number * value_8.Y
            local is_jump_power_2 = character_4.Humanoid.JumpPower > 0
            character_4.AgentCanFollowPath = true
            character_4.DirectPath = direct_path
            character_4.DirectPathRiseFirst = character_4.Humanoid.Sit
            agent_radius, character, agent_can_jump = number_offset_offset_2, number_offset_3, is_jump_power_2
        end
        if success_4 then
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
    function character_4.Cleanup(self)
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
    function character_4.Cancel(self)
        character_4.Cancelled = true
        character_4:Cleanup()
    end
    function character_4.IsActive(self)
        return character_4.AgentCanFollowPath and (character_4.Started and not character_4.Cancelled)
    end
    function character_4.OnPathInterrupted(self)
        character_4.Cancelled = true
        character_4:OnPointReached(false)
    end
    function character_4.ComputePath(self)
        if not character_4.OriginPoint then
            return
        end
        if not character_4.PathComputed and not character_4.PathComputing then
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
                    character_4.BlockedConn = character_4.pathResult.Blocked:Connect(function(argument_2)
                        character_4:OnPathBlocked(argument_2)
                    end)
                    character_4.PathComputed = character_4.pathResult.Status == Enum.PathStatus.Success
                end
            end
            character_4.PathComputing = false
            return
        end
    end
    function character_4.IsValidPath(self)
        character_4:ComputePath()
        return character_4.PathComputed and character_4.AgentCanFollowPath
    end
    character_4.Recomputing = false
    function character_4.OnPathBlocked(self, argument_2)
        if not (character_4.CurrentPoint <= argument_2) or character_4.Recomputing then
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
    function character_4.OnRenderStepped(self, argument_2)
        if not character_4.Started or character_4.Cancelled then
            return
        end
        character_4.Timeout = character_4.Timeout + argument_2
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
    function character_4.IsCurrentWaypointReached(self)
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
    function character_4.OnPointReached(self, argument_2)
        if argument_2 and not character_4.Cancelled then
            if character_4.setPointFunc then
                character_4.setPointFunc(character_4.CurrentPoint)
            end
            local current_point_offset = character_4.CurrentPoint + 1
            local value_9 = nil
            if #character_4.pointList < current_point_offset then
                if character_4.stopTraverseFunc then
                    character_4.stopTraverseFunc()
                end
                character_4.Finished:Fire()
                character_4:Cleanup()
            else
                local point_list_entry = character_4.pointList[character_4.CurrentPoint]
                local point_list_entry_2 = character_4.pointList[current_point_offset]
                value_9 = character_4.Humanoid:GetState()
                local enabled_4 = true
                local enabled_5
                if value_9 == Enum.HumanoidStateType.FallingDown then
                    enabled_5 = enabled_4
                else
                    enabled_5 = true
                    if value_9 ~= Enum.HumanoidStateType.Freefall then
                        enabled_5 = value_9 == Enum.HumanoidStateType.Jumping
                    end
                end
                if enabled_5 then
                    local is_action = point_list_entry_2.Action == Enum.PathWaypointAction.Jump
                    if not is_action and character_4.CurrentPoint > 1 then
                        local _ = point_list_entry.Position
                            - character_4.pointList[character_4.CurrentPoint - 1].Position
                        local position_offset = point_list_entry_2.Position - point_list_entry.Position
                        is_action = Vector2.new(
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
                    if is_action then
                        character_4.Humanoid.FreeFalling:Wait()
                        wait(0.1)
                    end
                end
                character_4:MoveToNextWayPoint(point_list_entry, point_list_entry_2, current_point_offset)
            end
            return
        end
        character_4.PathFailed:Fire()
        character_4:Cleanup()
    end
    function character_4.MoveToNextWayPoint(self, argument_2, argument_3, current_point)
        character_4.CurrentWaypointPlaneNormal = argument_2.Position - argument_3.Position
        if not success_4 or argument_3.Label ~= "Climb" then
            character_4.CurrentWaypointPlaneNormal =
                Vector3.new(character_4.CurrentWaypointPlaneNormal.X, 0, character_4.CurrentWaypointPlaneNormal.Z)
        end
        if character_4.CurrentWaypointPlaneNormal.Magnitude > 1e-06 then
            character_4.CurrentWaypointPlaneNormal = character_4.CurrentWaypointPlaneNormal.Unit
            character_4.CurrentWaypointPlaneDistance = character_4.CurrentWaypointPlaneNormal:Dot(argument_3.Position)
        else
            character_4.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            character_4.CurrentWaypointPlaneDistance = 0
        end
        character_4.CurrentWaypointNeedsJump = argument_3.Action == Enum.PathWaypointAction.Jump
        character_4.CurrentWaypointPosition = argument_3.Position
        character_4.CurrentPoint = current_point
        character_4.Timeout = 0
    end
    function character_4.Start(self, argument_2)
        if character_4.AgentCanFollowPath then
            if character_4.Started then
                return
            end
            character_4.Started = true
            click_to_move_display.CancelFailureAnimation()
            if enabled and (argument_2 == nil or argument_2) then
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
                character_4.SeatedConn = character_4.Humanoid.Seated:Connect(function(argument_3, argument_4)
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
    local value_5, value_6, value_7 = nil, nil, nil
    if character then
        value_5 = values_3[local_player]
        if value_5 and value_5.Parent == character then
            value_7 = value_5
        else
            values_3[local_player] = nil
            value_6 = local_player:FindFirstChildOfClass("Humanoid")
            if value_6 then
                values_3[local_player] = value_6
            end
            value_7 = value_6
        end
    else
        value_7 = nil
    end
    local enabled_4 = false
    if value_7 ~= nil then
        enabled_4 = value_7.Health > 0
    end
    return enabled_4
end

local value_4 = nil
local connection_3 = nil
local connection_4 = nil

local function cleanup_path()
    if value_4 then
        value_4:Cancel()
        value_4 = nil
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
    if value_4 then
        if value_4 then
            value_4:Cancel()
            value_4 = nil
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
    value_4 = argument
    argument:Start(argument_4)
    local connection_5 = argument.Finished.Event:Connect(function()
        if value_4 then
            value_4:Cancel()
            value_4 = nil
        end
        if connection_3 then
            connection_3:Disconnect()
            connection_3 = nil
        end
        if connection_4 then
            connection_4:Disconnect()
            connection_4 = nil
        end
        if argument_3 then
            local result = get_equipped_tool(instance)
            if not result then
                return
            end
            result:Activate()
        end
    end)
    connection_3 = connection_5
    local connection_6 = argument.PathFailed.Event:Connect(function()
        if value_4 then
            value_4:Cancel()
            value_4 = nil
        end
        if connection_3 then
            connection_3:Disconnect()
            connection_3 = nil
        end
        if connection_4 then
            connection_4:Disconnect()
            connection_4 = nil
        end
        if argument_4 == nil or argument_4 then
            local enabled_4 = enabled_2
            if enabled_4 then
                local is_active_result = value_4 and value_4:IsActive()
                enabled_4 = not is_active_result
            end
            if enabled_4 then
                click_to_move_display.PlayFailureAnimation()
            end
            click_to_move_display.DisplayFailureWaypoint(argument_2)
        end
    end)
    connection_4 = connection_6
end

local function show_path_failed_feedback(argument)
    if value_4 and value_4:IsActive() then
        value_4:Cancel()
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
    local value_5, target_surface_normal, value_6 = nil, nil, nil
    if character_2 then
        value_5 = values_3[local_player]
        if value_5 and value_5.Parent == character_2 then
            value_6 = value_5
        else
            values_3[local_player] = nil
            target_surface_normal = local_player:FindFirstChildOfClass("Humanoid")
            if target_surface_normal then
                values_3[local_player] = target_surface_normal
            end
            value_6 = target_surface_normal
        end
    else
        value_6 = nil
    end
    local enabled_4 = false
    if value_6 ~= nil then
        enabled_4 = value_6.Health > 0
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
    local character_3 = player and player.Character
    local value_7 = nil
    if character_3 then
        target_surface_normal = values_3[player]
        if not target_surface_normal or target_surface_normal.Parent ~= character_3 then
            values_3[player] = nil
            value_7 = local_player:FindFirstChildOfClass("Humanoid")
            if value_7 then
                values_3[player] = value_7
            end
        end
    end
    local raycast_2 = values_2.Raycast
    if not items then
        items = {}
        assert(items, "")
        table.insert(items, local_player and local_player.Character)
    end
    local original_target_point
    player, original_target_point, target_surface_normal = raycast_2(ray, true, items)
    local character_ancestor, value_8 = values_2.FindCharacterAncestor(player)
    if
        argument_3
        and value_8
        and starter_gui:GetCore("AvatarContextMenuEnabled")
        and players:GetPlayerFromCharacter(value_8.Parent)
    then
        if value_4 then
            value_4:Cancel()
            value_4 = nil
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
    if value_4 then
        value_4:Cancel()
        value_4 = nil
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
        if value_4 and value_4:IsActive() then
            value_4:Cancel()
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

function click_to_move_controller.DisconnectEvents(self)
    local tap_conn = self.tapConn
    if tap_conn then
        tap_conn:Disconnect()
    end
    local input_began_conn = self.inputBeganConn
    if input_began_conn then
        input_began_conn:Disconnect()
    end
    local input_changed_conn = self.inputChangedConn
    if input_changed_conn then
        input_changed_conn:Disconnect()
    end
    local input_ended_conn = self.inputEndedConn
    if input_ended_conn then
        input_ended_conn:Disconnect()
    end
    local humanoid_died_conn = self.humanoidDiedConn
    if humanoid_died_conn then
        humanoid_died_conn:Disconnect()
    end
    local character_child_added_conn = self.characterChildAddedConn
    if character_child_added_conn then
        character_child_added_conn:Disconnect()
    end
    local on_character_added_conn = self.onCharacterAddedConn
    if on_character_added_conn then
        on_character_added_conn:Disconnect()
    end
    local render_stepped_conn = self.renderSteppedConn
    if render_stepped_conn then
        render_stepped_conn:Disconnect()
    end
    local character_child_removed_conn = self.characterChildRemovedConn
    if character_child_removed_conn then
        character_child_removed_conn:Disconnect()
    end
    local menu_opened_connection = self.menuOpenedConnection
    if not menu_opened_connection then
        return
    end
    menu_opened_connection:Disconnect()
end

function click_to_move_controller.OnTouchBegan(self, argument, argument_2)
    if self.fingerTouches[argument] == nil and not argument_2 then
        self.numUnsunkTouches = self.numUnsunkTouches + 1
    end
    self.fingerTouches[argument] = argument_2
end

function click_to_move_controller.OnTouchChanged(self, argument, argument_2)
    if self.fingerTouches[argument] ~= nil then
        return
    end
    self.fingerTouches[argument] = argument_2
    if argument_2 then
        return
    end
    self.numUnsunkTouches = self.numUnsunkTouches + 1
end

function click_to_move_controller.OnTouchEnded(self, argument, argument_2)
    if self.fingerTouches[argument] ~= nil and self.fingerTouches[argument] == false then
        self.numUnsunkTouches = self.numUnsunkTouches - 1
    end
    self.fingerTouches[argument] = nil
end

function click_to_move_controller.OnCharacterAdded(self, instance)
    self:DisconnectEvents()
    self.inputBeganConn = user_input_service.InputBegan:Connect(function(input, game_processed)
        if input.UserInputType == Enum.UserInputType.Touch then
            self:OnTouchBegan(input, game_processed)
        end
        if
            self.wasdEnabled
            and game_processed == false
            and input.UserInputType == Enum.UserInputType.Keyboard
            and values[input.KeyCode]
        then
            if value_4 then
                value_4:Cancel()
                value_4 = nil
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
            self.mouse1DownTime = tick()
            self.mouse1DownPos = input.Position
        end
        if input.UserInputType ~= Enum.UserInputType.MouseButton2 then
            return
        end
        self.mouse2DownTime = tick()
        self.mouse2DownPos = input.Position
    end)
    self.inputChangedConn = user_input_service.InputChanged:Connect(function(input, game_processed)
        if input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        self:OnTouchChanged(input, game_processed)
    end)
    self.inputEndedConn = user_input_service.InputEnded:Connect(function(input, game_processed)
        if input.UserInputType == Enum.UserInputType.Touch then
            self:OnTouchEnded(input, game_processed)
        end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            self.mouse2UpTime = tick()
            local position = input.Position
            local is_magnitude = value_4 or (self.keyboardMoveVector.Magnitude <= 0)
            if
                not (self.mouse2UpTime - self.mouse2DownTime < 0.25)
                or not ((position - self.mouse2DownPos).magnitude < 5)
                or not is_magnitude
            then
                return
            end
            OnTap({ position })
        end
    end)
    self.tapConn = user_input_service.TouchTap:Connect(function(argument, argument_2)
        if argument_2 then
            return
        end
        OnTap(argument, nil, true)
    end)
    self.menuOpenedConnection = gui_service.MenuOpened:Connect(function()
        if value_4 then
            value_4:Cancel()
            value_4 = nil
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
    local function on_character_child_added(argument)
        if user_input_service.TouchEnabled and argument:IsA("Tool") then
            argument.ManualActivationOnly = true
        end
        if argument:IsA("Humanoid") then
            local humanoid_died_conn = self.humanoidDiedConn
            if humanoid_died_conn then
                humanoid_died_conn:Disconnect()
            end
            self.humanoidDiedConn = argument.Died:Connect(function() end)
        end
    end
    self.characterChildAddedConn = instance.ChildAdded:Connect(function(child_2)
        on_character_child_added(child_2)
    end)
    self.characterChildRemovedConn = instance.ChildRemoved:Connect(function(child_2)
        if not user_input_service.TouchEnabled or not child_2:IsA("Tool") then
            return
        end
        child_2.ManualActivationOnly = false
    end)
    for _, child in pairs(instance:GetChildren()) do
        on_character_child_added(child)
    end
end

function click_to_move_controller.Start(self)
    self:Enable(true)
end

function click_to_move_controller.Stop(self)
    self:Enable(false)
end

function click_to_move_controller.CleanupPath(self)
    if value_4 then
        value_4:Cancel()
        value_4 = nil
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

function click_to_move_controller.Enable(self, enabled_4, wasd_enabled, touch_jump_controller)
    if enabled_4 then
        if not self.running then
            if local_player.Character then
                self:OnCharacterAdded(local_player.Character)
            end
            self.onCharacterAddedConn = local_player.CharacterAdded:Connect(function(character)
                self:OnCharacterAdded(character)
            end)
            self.running = true
        end
        self.touchJumpController = touch_jump_controller
        if self.touchJumpController then
            self.touchJumpController:Enable(self.jumpEnabled)
        end
    else
        if self.running then
            self:DisconnectEvents()
            if value_4 then
                value_4:Cancel()
                value_4 = nil
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
            self.running = false
        end
        if self.touchJumpController and not self.jumpEnabled then
            self.touchJumpController:Enable(true)
        end
        self.touchJumpController = nil
    end
    if get_user_flag_result then
        keyboard.Enable(self, enabled_4)
    elseif user_input_service.KeyboardEnabled and enabled_4 ~= self.enabled then
        self.forwardValue = 0
        self.backwardValue = 0
        self.leftValue = 0
        self.rightValue = 0
        self.moveVector = Vector3.new(0, 0, 0)
        if enabled_4 then
            self:BindContextActions()
            self:ConnectFocusEventListeners()
        else
            self:UnbindContextActions()
            self:DisconnectFocusEventListeners()
        end
    end
    self.wasdEnabled = (enabled_4 and wasd_enabled) or false
    self.enabled = enabled_4
end

function click_to_move_controller.OnRenderStepped(self, argument)
    self.isJumping = false
    if value_4 then
        value_4:OnRenderStepped(argument)
        if value_4 then
            self.moveVector = value_4.NextActionMoveDirection
            self.moveVectorIsCameraRelative = false
            if value_4.NextActionJump then
                self.isJumping = true
            end
        else
            self.moveVector = self.keyboardMoveVector
            self.moveVectorIsCameraRelative = true
        end
    else
        self.moveVector = self.keyboardMoveVector
        self.moveVectorIsCameraRelative = true
    end
    if not self.jumpRequested then
        return
    end
    self.isJumping = true
end

function click_to_move_controller.UpdateMovement(self, argument)
    if argument == Enum.UserInputState.Cancel then
        self.keyboardMoveVector = Vector3.new(0, 0, 0)
    elseif self.wasdEnabled then
        self.keyboardMoveVector =
            Vector3.new(self.leftValue + self.rightValue, 0, self.forwardValue + self.backwardValue)
    end
end

function click_to_move_controller.UpdateJump(self) end

function click_to_move_controller.SetShowPath(self, argument)
    enabled = argument
end

function click_to_move_controller.GetShowPath(self)
    return enabled
end

function click_to_move_controller.SetWaypointTexture(self, argument)
    click_to_move_display.SetWaypointTexture(argument)
end

function click_to_move_controller.GetWaypointTexture(self)
    return click_to_move_display.GetWaypointTexture()
end

function click_to_move_controller.SetWaypointRadius(self, argument)
    click_to_move_display.SetWaypointRadius(argument)
end

function click_to_move_controller.GetWaypointRadius(self)
    return click_to_move_display.GetWaypointRadius()
end

function click_to_move_controller.SetEndWaypointTexture(self, argument)
    click_to_move_display.SetEndWaypointTexture(argument)
end

function click_to_move_controller.GetEndWaypointTexture(self)
    return click_to_move_display.GetEndWaypointTexture()
end

function click_to_move_controller.SetWaypointsAlwaysOnTop(self, argument)
    click_to_move_display.SetWaypointsAlwaysOnTop(argument)
end

function click_to_move_controller.GetWaypointsAlwaysOnTop(self)
    return click_to_move_display.GetWaypointsAlwaysOnTop()
end

function click_to_move_controller.SetFailureAnimationEnabled(self, argument)
    enabled_2 = argument
end

function click_to_move_controller.GetFailureAnimationEnabled(self)
    return enabled_2
end

function click_to_move_controller.SetIgnoredPartsTag(self, argument)
    update_ignore_tag(argument)
end

function click_to_move_controller.GetIgnoredPartsTag(self)
    return value_3
end

function click_to_move_controller.SetUseDirectPath(self, argument)
    enabled_3 = argument
end

function click_to_move_controller.GetUseDirectPath(self)
    return enabled_3
end

function click_to_move_controller.SetAgentSizeIncreaseFactor(self, argument)
    number = (argument / 100) + 1
end

function click_to_move_controller.GetAgentSizeIncreaseFactor(self)
    return (number - 1) * 100
end

function click_to_move_controller.SetUnreachableWaypointTimeout(self, argument)
    number_2 = argument
end

function click_to_move_controller.GetUnreachableWaypointTimeout(self)
    return number_2
end

function click_to_move_controller.SetUserJumpEnabled(self, jump_enabled)
    self.jumpEnabled = jump_enabled
    if not self.touchJumpController then
        return
    end
    self.touchJumpController:Enable(jump_enabled)
end

function click_to_move_controller.GetUserJumpEnabled(self)
    return self.jumpEnabled
end

function click_to_move_controller.MoveTo(self, original_target_point, argument, argument_2)
    local character = local_player.Character
    if character == nil then
        return false
    end
    local result = pather(original_target_point, Vector3.new(0, 1, 0), argument_2)
    if result and result:IsValidPath() then
        handle_move_to(result, original_target_point, nil, character, argument)
        return true
    end
    return false
end

return click_to_move_controller
