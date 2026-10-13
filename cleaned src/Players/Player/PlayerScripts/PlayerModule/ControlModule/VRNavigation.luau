local vr_service = game:GetService("VRService")
local user_input_service = game:GetService("UserInputService")
local run_service = game:GetService("RunService")
local players = game:GetService("Players")
local pathfinding_service = game:GetService("PathfindingService")
local context_action_service = game:GetService("ContextActionService")
local starter_gui = game:GetService("StarterGui")
local value = nil
local local_player = players.LocalPlayer

local function is_finite(argument)
    return (argument == argument) and ((argument ~= math.huge) and (argument ~= -math.huge))
end

local function is_finite_vector3(argument)
    local x = argument.x
    local is_x = (x == x) and ((x ~= math.huge) and (x ~= -math.huge))
    if is_x then
        local y = argument.y
        is_x = (y == y) and ((y ~= math.huge) and (y ~= -math.huge))
        if is_x then
            local _ = argument.z
            is_x = argument.z == argument.z and argument.z ~= math.huge and argument.z ~= -math.huge
        end
    end
    return is_x
end

local bindable_event = Instance.new("BindableEvent")
bindable_event.Name = "MovementUpdate"
bindable_event.Parent = script
coroutine.wrap(function()
    local path_display = script.Parent:WaitForChild("PathDisplay")
    if not path_display then
        return
    end
    value = require(path_display)
end)()
local base_character_controller = require(script.Parent:WaitForChild("BaseCharacterController"))
local vr_navigation = setmetatable({}, base_character_controller)
vr_navigation.__index = vr_navigation

function vr_navigation.new(control_action_priority)
    local instance = setmetatable(base_character_controller.new(), vr_navigation)
    instance.CONTROL_ACTION_PRIORITY = control_action_priority
    instance.navigationRequestedConn = nil
    instance.heartbeatConn = nil
    instance.currentDestination = nil
    instance.currentPath = nil
    instance.currentPoints = nil
    instance.currentPointIdx = 0
    instance.expectedTimeToNextPoint = 0
    instance.timeReachedLastPoint = tick()
    instance.moving = false
    instance.isJumpBound = false
    instance.moveLatch = false
    instance.userCFrameEnabledConn = nil
    return instance
end

function vr_navigation.SetLaserPointerMode(self, argument)
    pcall(function()
        starter_gui:SetCore("VRLaserPointerMode", argument)
    end)
end

function vr_navigation.GetLocalHumanoid(self)
    local character = local_player.Character
    if character then
        for _, child in pairs(character:GetChildren()) do
            if not (child:IsA("Humanoid")) then
                continue
            end
            return child
        end
        return nil
    end
end

function vr_navigation.HasBothHandControllers(self)
    local user_c_frame_enabled = vr_service:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)
        and (vr_service:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand))
    return user_c_frame_enabled
end

function vr_navigation.HasAnyHandControllers(self)
    local user_c_frame_enabled = vr_service:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)
        or (vr_service:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand))
    return user_c_frame_enabled
end

function vr_navigation.IsMobileVR(self)
    return user_input_service.TouchEnabled
end

function vr_navigation.HasGamepad(self)
    return user_input_service.GamepadEnabled
end

function vr_navigation.ShouldUseNavigationLaser(self)
    if self:IsMobileVR() then
        return true
    end
    if self:HasBothHandControllers() then
        return false
    elseif self:HasAnyHandControllers() then
        return true
    else
        return not self:HasGamepad()
    end
end

function vr_navigation.StartFollowingPath(self, argument)
    currentPath = argument
    currentPoints = currentPath:GetPointCoordinates()
    currentPointIdx = 1
    moving = true
    timeReachedLastPoint = tick()
    local local_humanoid = self:GetLocalHumanoid()
    if local_humanoid and local_humanoid.Torso and #currentPoints >= 1 then
        expectedTimeToNextPoint = (currentPoints[1] - local_humanoid.Torso.Position).magnitude
            / local_humanoid.WalkSpeed
    end
    bindable_event:Fire("targetPoint", self.currentDestination)
end

function vr_navigation.GoToPoint(self, argument)
    currentPath = true
    currentPoints = { argument }
    currentPointIdx = 1
    moving = true
    local local_humanoid = self:GetLocalHumanoid()
    timeReachedLastPoint = tick()
    expectedTimeToNextPoint = (local_humanoid.Torso.Position - argument).magnitude / local_humanoid.WalkSpeed
    bindable_event:Fire("targetPoint", argument)
end

function vr_navigation.StopFollowingPath(self)
    currentPath = nil
    currentPoints = nil
    currentPointIdx = 0
    moving = false
    self.moveVector = Vector3.new(0, 0, 0)
end

function vr_navigation.TryComputePath(self, computed_value_offset, computed_value_offset_2)
    local number = 0
    local value_2 = nil
    while not value_2 and (number < 5) do
        value_2 = pathfinding_service:ComputeSmoothPathAsync(computed_value_offset, computed_value_offset_2, 200)
        number += 1
        if value_2.Status == Enum.PathStatus.ClosestNoPath or value_2.Status == Enum.PathStatus.ClosestOutOfRange then
            return nil
        end
        if value_2 and value_2.Status == Enum.PathStatus.FailStartNotEmpty then
            computed_value_offset += (computed_value_offset_2 - computed_value_offset).Unit
            value_2 = nil
        end
        if value_2 and value_2.Status == Enum.PathStatus.FailFinishNotEmpty then
            computed_value_offset_2 += Vector3.new(0, 1, 0)
            value_2 = nil
        end
    end
    return value_2
end

function vr_navigation.OnNavigationRequest(self, argument, argument_2)
    local position = argument.Position
    local current_destination = self.currentDestination
    local x = position.x
    local is_x = (x == x) and ((x ~= math.huge) and (x ~= -math.huge))
    if is_x then
        local y = position.y
        is_x = (y == y) and ((y ~= math.huge) and (y ~= -math.huge))
        if is_x then
            local _ = position.z
            is_x = position.z == position.z and position.z ~= math.huge and position.z ~= -math.huge
        end
    end
    if not is_x then
        return
    end
    self.currentDestination = position
    is_x = self:GetLocalHumanoid()
    if not is_x then
        return
    end
    if is_x.Torso then
        local position_2 = is_x.Torso.Position
        if (self.currentDestination - position_2).magnitude < 12 then
            self:GoToPoint(self.currentDestination)
        else
            if current_destination and not ((self.currentDestination - current_destination).magnitude > 4) then
                if moving then
                    self.currentPoints[#currentPoints] = self.currentDestination
                else
                    self:GoToPoint(self.currentDestination)
                end
                return
            end
            local try_compute_path_result = self:TryComputePath(position_2, self.currentDestination)
            if try_compute_path_result then
                self:StartFollowingPath(try_compute_path_result)
                if value then
                    value.setCurrentPoints(self.currentPoints)
                    value.renderPath()
                end
            else
                self:StopFollowingPath()
                if value then
                    value.clearRenderedPath()
                end
            end
        end
    end
end

function vr_navigation.OnJumpAction(self, argument, argument_2, argument_3)
    if argument_2 == Enum.UserInputState.Begin then
        self.isJumping = true
    end
    return Enum.ContextActionResult.Sink
end

function vr_navigation.BindJumpAction(self, argument)
    if argument then
        if self.isJumpBound then
            return
        end
        self.isJumpBound = true
        context_action_service:BindActionAtPriority("VRJumpAction", function()
            return self:OnJumpAction()
        end, false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA)
    elseif self.isJumpBound then
        self.isJumpBound = false
        context_action_service:UnbindAction("VRJumpAction")
    end
end

function vr_navigation.ControlCharacterGamepad(self, argument, argument_2, input)
    if input.KeyCode ~= Enum.KeyCode.Thumbstick1 then
        return
    end
    if argument_2 ~= Enum.UserInputState.Cancel then
        if argument_2 == Enum.UserInputState.End then
            self.moveVector = Vector3.new(0, 0, 0)
            if self:ShouldUseNavigationLaser() then
                self:BindJumpAction(false)
                self:SetLaserPointerMode("Navigation")
            end
            if self.moveLatch then
                self.moveLatch = false
                bindable_event:Fire("offtrack")
            end
        else
            self:StopFollowingPath()
            if value then
                value.clearRenderedPath()
            end
            if self:ShouldUseNavigationLaser() then
                self:BindJumpAction(true)
                self:SetLaserPointerMode("Hidden")
            end
            if input.Position.magnitude > 0.22 then
                self.moveVector = Vector3.new(input.Position.X, 0, -input.Position.Y)
                if self.moveVector.magnitude > 0 then
                    self.moveVector = self.moveVector.unit * math.min(1, input.Position.magnitude)
                end
                self.moveLatch = true
            end
        end
        return Enum.ContextActionResult.Sink
    end
    self.moveVector = Vector3.new(0, 0, 0)
end

function vr_navigation.OnHeartbeat(self, argument)
    local move_vector = self.moveVector
    local local_humanoid = self:GetLocalHumanoid()
    if not local_humanoid or not local_humanoid.Torso then
        return
    end
    if self.moving and self.currentPoints then
        local position = local_humanoid.Torso.Position
        local current_point_entry_offset_offset = (currentPoints[1] - position) * Vector3.new(1, 0, 1)
        local magnitude = current_point_entry_offset_offset.magnitude
        local current_point_entry_offset_offset_offset = current_point_entry_offset_offset / magnitude
        if magnitude < 1 then
            local number = 0
            local current_point_entry = currentPoints[1]
            for key, item in pairs(currentPoints) do
                if key ~= 1 then
                    number += (item - current_point_entry).magnitude / local_humanoid.WalkSpeed
                    current_point_entry = item
                end
            end
            table.remove(currentPoints, 1)
            currentPointIdx = currentPointIdx + 1
            if #currentPoints ~= 0 then
                if value then
                    value.setCurrentPoints(currentPoints)
                    value.renderPath()
                end
                expectedTimeToNextPoint = (currentPoints[1] - position).magnitude / local_humanoid.WalkSpeed
                timeReachedLastPoint = tick()
                local x = move_vector.x
                local is_x = (x == x) and ((x ~= math.huge) and (x ~= -math.huge))
                if is_x then
                    local y = move_vector.y
                    is_x = (y == y) and ((y ~= math.huge) and (y ~= -math.huge))
                    if is_x then
                        local _ = move_vector.z
                        is_x = move_vector.z == move_vector.z
                            and move_vector.z ~= math.huge
                            and move_vector.z ~= -math.huge
                    end
                end
                if is_x then
                    self.moveVector = move_vector
                end
            else
                self:StopFollowingPath()
                if value then
                    value.clearRenderedPath()
                end
            end
        else
            local values = { game.Players.LocalPlayer.Character, workspace.CurrentCamera }
            local hit_part, value_2 = workspace:FindPartOnRayWithIgnoreList(
                Ray.new(position - Vector3.new(0, 1, 0), current_point_entry_offset_offset_offset * 3),
                values
            )
            local value_3 = nil
            if hit_part then
                local _, value_4 = workspace:FindPartOnRayWithIgnoreList(
                    Ray.new(
                        (value_2 + (current_point_entry_offset_offset_offset * 0.5)) + Vector3.new(0, 100, 0),
                        Vector3.new(-0, -100, -0)
                    ),
                    values
                )
                value_3 = value_4.Y - position.Y
                if value_3 < 6 and value_3 > -2 then
                    local_humanoid.Jump = true
                end
            end
            if expectedTimeToNextPoint + 2 < tick() - timeReachedLastPoint then
                self:StopFollowingPath()
                if value then
                    value.clearRenderedPath()
                end
                bindable_event:Fire("offtrack")
            end
            move_vector = self.moveVector:Lerp(current_point_entry_offset_offset_offset, argument * 10)
            local x_2 = move_vector.x
            local is_x_2 = (x_2 == x_2) and ((x_2 ~= math.huge) and (x_2 ~= -math.huge))
            if is_x_2 then
                local y_2 = move_vector.y
                is_x_2 = (y_2 == y_2) and ((y_2 ~= math.huge) and (y_2 ~= -math.huge))
                if is_x_2 then
                    local _ = move_vector.z
                    is_x_2 = move_vector.z == move_vector.z
                        and move_vector.z ~= math.huge
                        and move_vector.z ~= -math.huge
                end
            end
            if is_x_2 then
                self.moveVector = move_vector
            end
        end
    else
        local x_3 = move_vector.x
        local is_x_3 = (x_3 == x_3) and ((x_3 ~= math.huge) and (x_3 ~= -math.huge))
        if is_x_3 then
            local y_3 = move_vector.y
            is_x_3 = (y_3 == y_3) and ((y_3 ~= math.huge) and (y_3 ~= -math.huge))
            if is_x_3 then
                local _ = move_vector.z
                is_x_3 = move_vector.z == move_vector.z and move_vector.z ~= math.huge and move_vector.z ~= -math.huge
            end
        end
        if is_x_3 then
            self.moveVector = move_vector
        end
    end
end

function vr_navigation.OnUserCFrameEnabled(self)
    if self:ShouldUseNavigationLaser() then
        self:BindJumpAction(false)
        self:SetLaserPointerMode("Navigation")
    else
        self:BindJumpAction(true)
        self:SetLaserPointerMode("Hidden")
    end
end

function vr_navigation.Enable(self, argument)
    self.moveVector = Vector3.new(0, 0, 0)
    self.isJumping = false
    if argument then
        self.navigationRequestedConn = vr_service.NavigationRequested:Connect(function(argument_2, argument_3)
            self:OnNavigationRequest(argument_2, argument_3)
        end)
        self.heartbeatConn = run_service.Heartbeat:Connect(function(delta_time)
            self:OnHeartbeat(delta_time)
        end)
        context_action_service:BindAction("MoveThumbstick", function(argument_2, argument_3, argument_4)
            return self:ControlCharacterGamepad(argument_2, argument_3, argument_4)
        end, false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Thumbstick1)
        context_action_service:BindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        self.userCFrameEnabledConn = vr_service.UserCFrameEnabled:Connect(function()
            self:OnUserCFrameEnabled()
        end)
        self:OnUserCFrameEnabled()
        vr_service:SetTouchpadMode(Enum.VRTouchpad.Left, Enum.VRTouchpadMode.VirtualThumbstick)
        vr_service:SetTouchpadMode(Enum.VRTouchpad.Right, Enum.VRTouchpadMode.ABXY)
        self.enabled = true
    else
        self:StopFollowingPath()
        context_action_service:UnbindAction("MoveThumbstick")
        context_action_service:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        self:BindJumpAction(false)
        self:SetLaserPointerMode("Disabled")
        if self.navigationRequestedConn then
            self.navigationRequestedConn:Disconnect()
            self.navigationRequestedConn = nil
        end
        if self.heartbeatConn then
            self.heartbeatConn:Disconnect()
            self.heartbeatConn = nil
        end
        if self.userCFrameEnabledConn then
            self.userCFrameEnabledConn:Disconnect()
            self.userCFrameEnabledConn = nil
        end
        self.enabled = false
    end
end

return vr_navigation
