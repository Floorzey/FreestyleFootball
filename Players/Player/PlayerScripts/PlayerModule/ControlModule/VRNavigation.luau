--[[
    Script Path: Game/Players/Player/PlayerScripts/PlayerModule/ControlModule/VRNavigation
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local VRService_upv_1 = game:GetService("VRService")
local UserInputService_upv_1 = game:GetService("UserInputService")
local RunService_upv_1 = game:GetService("RunService")
local Players_1 = game:GetService("Players")
local PathfindingService_upv_1 = game:GetService("PathfindingService")
local ContextActionService_upv_1 = game:GetService("ContextActionService")
local StarterGui_upv_1 = game:GetService("StarterGui")
local u1 = nil
local LocalPlayer_upv_1 = Players_1.LocalPlayer
local function IsFinite(a1)
    --[[
      name: IsFinite
      line: 32
    ]]
    return (a1 == a1) and ((a1 ~= math.huge) and (a1 ~= -math.huge))
end
local function IsFiniteVector3(a1)
    --[[
      name: IsFiniteVector3
      line: 36
    ]]
    local x_1 = a1.x
    local v1 = (x_1 == x_1) and ((x_1 ~= math.huge) and (x_1 ~= -math.huge))
    if v1 then
        local y_1 = a1.y
        v1 = (y_1 == y_1) and ((y_1 ~= math.huge) and (y_1 ~= -math.huge))
        if v1 then
            local _ = a1.z
            v1 = a1.z == a1.z and a1.z ~= math.huge and a1.z ~= -math.huge
        end
    end
    return v1
end
local u2 = Instance.new("BindableEvent")
u2.Name = "MovementUpdate"
u2.Parent = script
coroutine.wrap(
    function()
        --[[
          line: 44
          upvalues:
            u1 (ref, index: 1)
        ]]
        local PathDisplay_1 = script.Parent:WaitForChild("PathDisplay")
        if not PathDisplay_1 then
            return
        end
        u1 = require(PathDisplay_1)
    end
)()
local BaseCharacterController_upv_1 = require(script.Parent:WaitForChild("BaseCharacterController"))
local u3 = setmetatable({}, BaseCharacterController_upv_1)
u3.__index = u3
function u3.new(a1)
    --[[
      name: new
      line: 57
      upvalues:
        BaseCharacterController_upv_1 (copy, index: 1)
        u3 (copy, index: 2)
    ]]
    local v2 = setmetatable(BaseCharacterController_upv_1.new(), u3)
    v2.CONTROL_ACTION_PRIORITY = a1
    v2.navigationRequestedConn = nil
    v2.heartbeatConn = nil
    v2.currentDestination = nil
    v2.currentPath = nil
    v2.currentPoints = nil
    v2.currentPointIdx = 0
    v2.expectedTimeToNextPoint = 0
    v2.timeReachedLastPoint = tick()
    v2.moving = false
    v2.isJumpBound = false
    v2.moveLatch = false
    v2.userCFrameEnabledConn = nil
    return v2
end
function u3.SetLaserPointerMode(a1, a2)
    --[[
      name: SetLaserPointerMode
      line: 82
      upvalues:
        StarterGui_upv_1 (copy, index: 1)
    ]]
    pcall(
        function()
            --[[
              line: 83
              upvalues:
                StarterGui_upv_1 (copy, index: 1)
                a2 (copy, index: 2)
            ]]
            StarterGui_upv_1:SetCore("VRLaserPointerMode", a2)
        end
    )
end
function u3.GetLocalHumanoid(a1)
    --[[
      name: GetLocalHumanoid
      line: 88
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
    ]]
    local Character_1 = LocalPlayer_upv_1.Character
    if Character_1 then
        for _, value_1 in pairs(Character_1:GetChildren()) do
            if not (value_1:IsA("Humanoid")) then
                continue
            end
            return value_1
        end
        return nil
    end
end
function u3.HasBothHandControllers(a1)
    --[[
      name: HasBothHandControllers
      line: 102
      upvalues:
        VRService_upv_1 (copy, index: 1)
    ]]
    local v3 = VRService_upv_1:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and (VRService_upv_1:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand))
    return v3
end
function u3.HasAnyHandControllers(a1)
    --[[
      name: HasAnyHandControllers
      line: 106
      upvalues:
        VRService_upv_1 (copy, index: 1)
    ]]
    local v4 = VRService_upv_1:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) or (VRService_upv_1:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand))
    return v4
end
function u3.IsMobileVR(a1)
    --[[
      name: IsMobileVR
      line: 110
      upvalues:
        UserInputService_upv_1 (copy, index: 1)
    ]]
    return UserInputService_upv_1.TouchEnabled
end
function u3.HasGamepad(a1)
    --[[
      name: HasGamepad
      line: 114
      upvalues:
        UserInputService_upv_1 (copy, index: 1)
    ]]
    return UserInputService_upv_1.GamepadEnabled
end
function u3.ShouldUseNavigationLaser(a1)
    --[[
      name: ShouldUseNavigationLaser
      line: 118
    ]]
    if a1:IsMobileVR() then
        return true
    end
    if a1:HasBothHandControllers() then
        return false
    elseif a1:HasAnyHandControllers() then
        return true
    else
        return not a1:HasGamepad()
    end
end
function u3.StartFollowingPath(a1, a2)
    --[[
      name: StartFollowingPath
      line: 140
      upvalues:
        u2 (copy, index: 1)
    ]]
    currentPath = a2
    currentPoints = currentPath:GetPointCoordinates()
    currentPointIdx = 1
    moving = true
    timeReachedLastPoint = tick()
    local v5 = a1:GetLocalHumanoid()
    if v5 and v5.Torso and #currentPoints >= 1 then
        expectedTimeToNextPoint = (currentPoints[1] - v5.Torso.Position).magnitude / v5.WalkSpeed
    end
    u2:Fire("targetPoint", a1.currentDestination)
end
function u3.GoToPoint(a1, a2)
    --[[
      name: GoToPoint
      line: 157
      upvalues:
        u2 (copy, index: 1)
    ]]
    currentPath = true
    currentPoints = {a2}
    currentPointIdx = 1
    moving = true
    local v6 = a1:GetLocalHumanoid()
    timeReachedLastPoint = tick()
    expectedTimeToNextPoint = (v6.Torso.Position - a2).magnitude / v6.WalkSpeed
    u2:Fire("targetPoint", a2)
end
function u3.StopFollowingPath(a1)
    --[[
      name: StopFollowingPath
      line: 173
    ]]
    currentPath = nil
    currentPoints = nil
    currentPointIdx = 0
    moving = false
    a1.moveVector = Vector3.new(0, 0, 0)
end
function u3.TryComputePath(a1, a2, a3)
    --[[
      name: TryComputePath
      line: 181
      upvalues:
        PathfindingService_upv_1 (copy, index: 1)
    ]]
    local v7 = 0
    local v8 = nil
    while not (v8) and (v7 < 5) do
        v8 = PathfindingService_upv_1:ComputeSmoothPathAsync(a2, a3, 200)
        v7 = v7 + 1
        if v8.Status == Enum.PathStatus.ClosestNoPath or v8.Status == Enum.PathStatus.ClosestOutOfRange then
            return nil
        end
        if v8 and v8.Status == Enum.PathStatus.FailStartNotEmpty then
            a2 = a2 + (a3 - a2).Unit
            v8 = nil
        end
        if (v8) and v8.Status == Enum.PathStatus.FailFinishNotEmpty then
            a3 = a3 + Vector3.new(0, 1, 0)
            v8 = nil
        end
    end
    return v8
end
function u3.OnNavigationRequest(a1, a2, a3)
    --[[
      name: OnNavigationRequest
      line: 208
      upvalues:
        u1 (ref, index: 1)
    ]]
    local Position_1 = a2.Position
    local currentDestination_1 = a1.currentDestination
    local x_2 = Position_1.x
    local v9 = (x_2 == x_2) and ((x_2 ~= math.huge) and (x_2 ~= -math.huge))
    if v9 then
        local y_2 = Position_1.y
        v9 = (y_2 == y_2) and ((y_2 ~= math.huge) and (y_2 ~= -math.huge))
        if v9 then
            local _ = Position_1.z
            v9 = Position_1.z == Position_1.z and Position_1.z ~= math.huge and Position_1.z ~= -math.huge
        end
    end
    if not v9 then
        return
    end
    a1.currentDestination = Position_1
    v9 = a1:GetLocalHumanoid()
    if not v9 then
        return
    end
    if v9.Torso then
        local Position_2 = v9.Torso.Position
        if (a1.currentDestination - Position_2).magnitude < 12 then
            a1:GoToPoint(a1.currentDestination)
        else
            if currentDestination_1 and not ((a1.currentDestination - currentDestination_1).magnitude > 4) then
                if moving then
                    a1.currentPoints[#currentPoints] = a1.currentDestination
                else
                    a1:GoToPoint(a1.currentDestination)
                end
                return
            end
            local v10 = a1:TryComputePath(Position_2, a1.currentDestination)
            if v10 then
                a1:StartFollowingPath(v10)
                if u1 then
                    u1.setCurrentPoints(a1.currentPoints)
                    u1.renderPath()
                end
            else
                a1:StopFollowingPath()
                if u1 then
                    u1.clearRenderedPath()
                end
            end
        end
    end
end
function u3.OnJumpAction(a1, a2, a3, a4)
    --[[
      name: OnJumpAction
      line: 254
    ]]
    if a3 == Enum.UserInputState.Begin then
        a1.isJumping = true
    end
    return Enum.ContextActionResult.Sink
end
function u3.BindJumpAction(a1, a2)
    --[[
      name: BindJumpAction
      line: 260
      upvalues:
        ContextActionService_upv_1 (copy, index: 1)
    ]]
    if a2 then
        if (a1.isJumpBound) then
            return
        end
        a1.isJumpBound = true
        ContextActionService_upv_1:BindActionAtPriority(
            "VRJumpAction",
            function()
                --[[
                  line: 264
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                return a1:OnJumpAction()
            end,
            false,
            a1.CONTROL_ACTION_PRIORITY,
            Enum.KeyCode.ButtonA
        )
    elseif a1.isJumpBound then
        a1.isJumpBound = false
        ContextActionService_upv_1:UnbindAction("VRJumpAction")
    end
end
function u3.ControlCharacterGamepad(a1, a2, a3, a4)
    --[[
      name: ControlCharacterGamepad
      line: 275
      upvalues:
        u1 (ref,  index: 1)
        u2 (copy, index: 2)
    ]]
    if a4.KeyCode ~= Enum.KeyCode.Thumbstick1 then
        return
    end
    if a3 ~= Enum.UserInputState.Cancel then
        if a3 == Enum.UserInputState.End then
            a1.moveVector = Vector3.new(0, 0, 0)
            if a1:ShouldUseNavigationLaser() then
                a1:BindJumpAction(false)
                a1:SetLaserPointerMode("Navigation")
            end
            if a1.moveLatch then
                a1.moveLatch = false
                u2:Fire("offtrack")
            end
        else
            a1:StopFollowingPath()
            if u1 then
                u1.clearRenderedPath()
            end
            if a1:ShouldUseNavigationLaser() then
                a1:BindJumpAction(true)
                a1:SetLaserPointerMode("Hidden")
            end
            if a4.Position.magnitude > 0.22 then
                a1.moveVector = Vector3.new(a4.Position.X, 0, -a4.Position.Y)
                if a1.moveVector.magnitude > 0 then
                    a1.moveVector = a1.moveVector.unit * math.min(1, a4.Position.magnitude)
                end
                a1.moveLatch = true
            end
        end
        return Enum.ContextActionResult.Sink
    end
    a1.moveVector = Vector3.new(0, 0, 0)
end
function u3.OnHeartbeat(a1, a2)
    --[[
      name: OnHeartbeat
      line: 318
      upvalues:
        u1 (ref,  index: 1)
        u2 (copy, index: 2)
    ]]
    local v11 = a1.moveVector
    local v12 = a1:GetLocalHumanoid()
    if not v12 or not v12.Torso then
        return
    end
    if a1.moving and a1.currentPoints then
        local v13 = v12.Torso.Position
        local v14 = (currentPoints[1] - v13) * Vector3.new(1, 0, 1)
        local magnitude_1 = v14.magnitude
        local v15 = v14 / magnitude_1
        if magnitude_1 < 1 then
            local v16 = 0
            local v17 = currentPoints[1]
            for key_1, value_2 in pairs(currentPoints) do
                if key_1 ~= 1 then
                    v16 = v16 + (value_2 - v17).magnitude / v12.WalkSpeed
                    v17 = value_2
                end
            end
            table.remove(currentPoints, 1)
            currentPointIdx = currentPointIdx + 1
            if #currentPoints ~= 0 then
                if u1 then
                    u1.setCurrentPoints(currentPoints)
                    u1.renderPath()
                end
                expectedTimeToNextPoint = (currentPoints[1] - v13).magnitude / v12.WalkSpeed
                timeReachedLastPoint = tick()
                local x_3 = v11.x
                local v13 = (x_3 == x_3) and ((x_3 ~= math.huge) and (x_3 ~= -math.huge))
                if v13 then
                    local y_3 = v11.y
                    v13 = (y_3 == y_3) and ((y_3 ~= math.huge) and (y_3 ~= -math.huge))
                    if v13 then
                        local _ = v11.z
                        v13 = v11.z == v11.z and v11.z ~= math.huge and v11.z ~= -math.huge
                    end
                end
                if v13 then
                    a1.moveVector = v11
                end
            else
                a1:StopFollowingPath()
                if u1 then
                    u1.clearRenderedPath()
                end
            end
        else
            local tbl_1 = {game.Players.LocalPlayer.Character, workspace.CurrentCamera}
            local v18, v19 = workspace:FindPartOnRayWithIgnoreList(Ray.new(v13 - Vector3.new(0, 1, 0), v15 * 3), tbl_1)
            local v20 = nil
            if v18 then
                local _, v21 = workspace:FindPartOnRayWithIgnoreList(Ray.new((v19 + (v15 * 0.5)) + Vector3.new(0, 100, 0), Vector3.new(-0, -100, -0)), tbl_1)
                v20 = v21.Y - v13.Y
                if v20 < 6 and v20 > -2 then
                    v12.Jump = true
                end
            end
            if expectedTimeToNextPoint + 2 < tick() - timeReachedLastPoint then
                a1:StopFollowingPath()
                if u1 then
                    u1.clearRenderedPath()
                end
                u2:Fire("offtrack")
            end
            v11 = a1.moveVector:Lerp(v15, a2 * 10)
            local x_3 = v11.x
            local v13 = (x_3 == x_3) and ((x_3 ~= math.huge) and (x_3 ~= -math.huge))
            if v13 then
                local y_3 = v11.y
                v13 = (y_3 == y_3) and ((y_3 ~= math.huge) and (y_3 ~= -math.huge))
                if v13 then
                    local _ = v11.z
                    v13 = v11.z == v11.z and v11.z ~= math.huge and v11.z ~= -math.huge
                end
            end
            if v13 then
                a1.moveVector = v11
            end
        end
    else
        local x_3 = v11.x
        local v13 = (x_3 == x_3) and ((x_3 ~= math.huge) and (x_3 ~= -math.huge))
        if v13 then
            local y_3 = v11.y
            v13 = (y_3 == y_3) and ((y_3 ~= math.huge) and (y_3 ~= -math.huge))
            if v13 then
                local _ = v11.z
                v13 = v11.z == v11.z and v11.z ~= math.huge and v11.z ~= -math.huge
            end
        end
        if v13 then
            a1.moveVector = v11
        end
    end
end
function u3.OnUserCFrameEnabled(a1)
    --[[
      name: OnUserCFrameEnabled
      line: 402
    ]]
    if a1:ShouldUseNavigationLaser() then
        a1:BindJumpAction(false)
        a1:SetLaserPointerMode("Navigation")
    else
        a1:BindJumpAction(true)
        a1:SetLaserPointerMode("Hidden")
    end
end
function u3.Enable(a1, a2)
    --[[
      name: Enable
      line: 412
      upvalues:
        VRService_upv_1 (copy, index: 1)
        RunService_upv_1 (copy, index: 2)
        ContextActionService_upv_1 (copy, index: 3)
    ]]
    a1.moveVector = Vector3.new(0, 0, 0)
    a1.isJumping = false
    if a2 then
        a1.navigationRequestedConn = VRService_upv_1.NavigationRequested:Connect(
            function(a3, a4)
                --[[
                  line: 418
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                a1:OnNavigationRequest(a3, a4)
            end
        )
        a1.heartbeatConn = RunService_upv_1.Heartbeat:Connect(
            function(a5)
                --[[
                  line: 419
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                a1:OnHeartbeat(a5)
            end
        )
        ContextActionService_upv_1:BindAction(
            "MoveThumbstick",
            function(a6, a7, a8)
                --[[
                  line: 421
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                return a1:ControlCharacterGamepad(a6, a7, a8)
            end,
            false,
            a1.CONTROL_ACTION_PRIORITY,
            Enum.KeyCode.Thumbstick1
        )
        ContextActionService_upv_1:BindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        a1.userCFrameEnabledConn = VRService_upv_1.UserCFrameEnabled:Connect(
            function()
                --[[
                  line: 425
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                a1:OnUserCFrameEnabled()
            end
        )
        a1:OnUserCFrameEnabled()
        VRService_upv_1:SetTouchpadMode(Enum.VRTouchpad.Left, Enum.VRTouchpadMode.VirtualThumbstick)
        VRService_upv_1:SetTouchpadMode(Enum.VRTouchpad.Right, Enum.VRTouchpadMode.ABXY)
        a1.enabled = true
    else
        a1:StopFollowingPath()
        ContextActionService_upv_1:UnbindAction("MoveThumbstick")
        ContextActionService_upv_1:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        a1:BindJumpAction(false)
        a1:SetLaserPointerMode("Disabled")
        if a1.navigationRequestedConn then
            a1.navigationRequestedConn:Disconnect()
            a1.navigationRequestedConn = nil
        end
        if a1.heartbeatConn then
            a1.heartbeatConn:Disconnect()
            a1.heartbeatConn = nil
        end
        if a1.userCFrameEnabledConn then
            a1.userCFrameEnabledConn:Disconnect()
            a1.userCFrameEnabledConn = nil
        end
        a1.enabled = false
    end
end
return u3