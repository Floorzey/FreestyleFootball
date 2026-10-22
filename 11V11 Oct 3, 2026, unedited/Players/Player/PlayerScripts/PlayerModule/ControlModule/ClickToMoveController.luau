--[[
    Script Path: Game/Players/Player/PlayerScripts/PlayerModule/ControlModule/ClickToMoveController
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local success_1, v1 = pcall(
    function()
        --[[
          line: 10
        ]]
        return UserSettings():IsUserFeatureEnabled("UserExcludeNonCollidableForPathfinding")
    end
)
local u1 = success_1 and v1
local success_2, v2 = pcall(
    function()
        --[[
          line: 14
        ]]
        return UserSettings():IsUserFeatureEnabled("UserClickToMoveSupportAgentCanClimb2")
    end
)
local u2 = success_2 and v2
local UserInputService_upv_1 = game:GetService("UserInputService")
local PathfindingService_upv_1 = game:GetService("PathfindingService")
local Players_upv_1 = game:GetService("Players")
local _ = game:GetService("Debris")
local StarterGui_upv_1 = game:GetService("StarterGui")
local Workspace_upv_1 = game:GetService("Workspace")
local CollectionService_upv_1 = game:GetService("CollectionService")
local GuiService_upv_1 = game:GetService("GuiService")
local u3 = require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")).getUserFlag("UserUpdateInputConnections")
local u4 = true
local u5 = true
local u6 = false
local u7 = 1
local u8 = 8
local tbl_upv_1 = {}
tbl_upv_1[Enum.KeyCode.W] = true
tbl_upv_1[Enum.KeyCode.A] = true
tbl_upv_1[Enum.KeyCode.S] = true
tbl_upv_1[Enum.KeyCode.D] = true
tbl_upv_1[Enum.KeyCode.Up] = true
tbl_upv_1[Enum.KeyCode.Down] = true
local LocalPlayer_upv_1 = Players_upv_1.LocalPlayer
local ClickToMoveDisplay_upv_1 = require(script.Parent:WaitForChild("ClickToMoveDisplay"))
local tbl_upv_2 = {}
local function FindCharacterAncestor(a1)
    --[[
      name: FindCharacterAncestor
      line: 61
      upvalues:
        FindCharacterAncestor (copy, index: 1)
    ]]
    if not a1 then
        return
    end
    local v3 = a1:FindFirstChildOfClass("Humanoid")
    if v3 then
        return a1, v3
    end
    return FindCharacterAncestor(a1.Parent)
end
tbl_upv_2.FindCharacterAncestor = FindCharacterAncestor
local function Raycast(a1, a2, a3)
    --[[
      name: Raycast
      line: 73
      upvalues:
        Workspace_upv_1 (copy, index: 1)
        FindCharacterAncestor (copy, index: 2)
        Raycast (copy, index: 3)
    ]]
    local v4 = a3 or {}
    local v5, v6, v7, v8 = Workspace_upv_1:FindPartOnRayWithIgnoreList(a1, v4)
    if v5 then
        if a2 and v5.CanCollide == false then
            local v9, v10 = nil, nil
            if v5 then
                v9 = v5:FindFirstChildOfClass("Humanoid")
                if v9 then
                    v10 = v9
                else
                    local _, v11 = FindCharacterAncestor(v5.Parent)
                    v10 = v11
                end
            else
                v10 = nil
            end
            if v10 == nil then
                table.insert(v4, v5)
                return Raycast(a1, a2, v4)
            end
        end
        return v5, v6, v7, v8
    end
    return nil, nil
end
tbl_upv_2.Raycast = Raycast
local tbl_upv_3 = {}
local function findPlayerHumanoid(a1)
    --[[
      name: findPlayerHumanoid
      line: 94
      upvalues:
        tbl_upv_3 (copy, index: 1)
    ]]
    local v12 = a1 and (a1.Character)
    if not v12 then
        return
    end
    local v13 = tbl_upv_3[a1]
    if v13 and v13.Parent == v12 then
        return v13
    end
    tbl_upv_3[a1] = nil
    local v14 = a1:FindFirstChildOfClass("Humanoid")
    if v14 then
        tbl_upv_3[a1] = v14
    end
    return v14
end
local tbl_upv_4 = nil
local u9 = nil
local u10 = nil
local u11 = nil
local function GetCharacter()
    --[[
      name: GetCharacter
      line: 118
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
    ]]
    local v15
    if LocalPlayer_upv_1 then
        v15 = LocalPlayer_upv_1.Character
    else
        v15 = LocalPlayer_upv_1
    end
    return v15
end
local function UpdateIgnoreTag(a1)
    --[[
      name: UpdateIgnoreTag
      line: 122
      upvalues:
        u9 (ref,  index: 1)
        u10 (ref,  index: 2)
        u11 (ref,  index: 3)
        tbl_upv_4 (ref,  index: 4)
        LocalPlayer_upv_1 (copy, index: 5)
        CollectionService_upv_1 (copy, index: 6)
    ]]
    if a1 == u9 then
        return
    end
    if u10 then
        u10:Disconnect()
        u10 = nil
    end
    if u11 then
        u11:Disconnect()
        u11 = nil
    end
    u9 = a1
    local tbl_5 = {}
    local v16
    if LocalPlayer_upv_1 then
        v16 = LocalPlayer_upv_1.Character
    else
        v16 = LocalPlayer_upv_1
    end
    tbl_5[1] = v16
    tbl_upv_4 = tbl_5
    if u9 ~= nil then
        for _, value_1 in ipairs(CollectionService_upv_1:GetTagged(u9)) do
            table.insert(tbl_upv_4, value_1)
        end
        local v17 = CollectionService_upv_1:GetInstanceAddedSignal(u9):Connect(
            function(a2)
                --[[
                  line: 142
                  upvalues:
                    tbl_upv_4 (ref, index: 1)
                ]]
                table.insert(tbl_upv_4, a2)
            end
        )
        u10 = v17
        local v18 = CollectionService_upv_1:GetInstanceRemovedSignal(u9):Connect(
            function(a3)
                --[[
                  line: 146
                  upvalues:
                    tbl_upv_4 (ref, index: 1)
                ]]
                for n_1 = 1, #tbl_upv_4 do
                    if tbl_upv_4[n_1] ~= a3 then
                        continue
                    end
                    tbl_upv_4[n_1] = tbl_upv_4[#tbl_upv_4]
                    table.remove(tbl_upv_4)
                    return
                end
            end
        )
        u11 = v18
    end
end
local function getIgnoreList()
    --[[
      name: getIgnoreList
      line: 158
      upvalues:
        tbl_upv_4 (ref,  index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
    ]]
    if not tbl_upv_4 then
        tbl_upv_4 = {}
        assert(tbl_upv_4, "")
        table.insert(tbl_upv_4, LocalPlayer_upv_1 and (LocalPlayer_upv_1.Character))
    end
    return tbl_upv_4
end
local function minV(a1, a2)
    --[[
      name: minV
      line: 168
    ]]
    return (Vector3.new(math.min(a1.X, a2.X), math.min(a1.Y, a2.Y), math.min(a1.Z, a2.Z)))
end
local function maxV(a1, a2)
    --[[
      name: maxV
      line: 171
    ]]
    return (Vector3.new(math.max(a1.X, a2.X), math.max(a1.Y, a2.Y), math.max(a1.Z, a2.Z)))
end
local function getCollidableExtentsSize(a1)
    --[[
      name: getCollidableExtentsSize
      line: 174
    ]]
    if a1 == nil or a1.PrimaryPart == nil then
        return
    end
    assert(a1, "")
    assert(a1.PrimaryPart, "")
    local v19 = a1.PrimaryPart.CFrame:Inverse()
    local v20 = Vector3.new(inf, inf, inf)
    local v21 = Vector3.new(-inf, -inf, -inf)
    for _, value_2 in pairs(a1:GetDescendants()) do
        local v22 = value_2:IsA("BasePart")
        if not (v22) or not (value_2.CanCollide) then
            continue
        end
        local v23 = Vector3.new(value_2.Size.X / 2, value_2.Size.Y / 2, value_2.Size.Z / 2)
        for v26, value_3 in ipairs({Vector3.new(v23.X, v23.Y, v23.Z), Vector3.new(v23.X, v23.Y, -v23.Z), Vector3.new(v23.X, -v23.Y, v23.Z), Vector3.new(v23.X, -v23.Y, -v23.Z), Vector3.new(-v23.X, v23.Y, v23.Z), Vector3.new(-v23.X, v23.Y, -v23.Z), Vector3.new(-v23.X, -v23.Y, v23.Z), Vector3.new(-v23.X, -v23.Y, -v23.Z)}) do
            local v24 = v19 * value_2.CFrame * value_3
            v20 = Vector3.new(math.min(v20.X, v24.X), math.min(v20.Y, v24.Y), math.min(v20.Z, v24.Z))
            v21 = Vector3.new(math.max(v21.X, v24.X), math.max(v21.Y, v24.Y), math.max(v21.Z, v24.Z))
        end
    end
    local v25 = v21 - v20
    if not (v25.X < 0) and not (v25.Y < 0) and not (v25.Z < 0) then
        return v25
    end
    return nil
end
local function Pather(a1, a2, a3)
    --[[
      name: Pather
      line: 209
      upvalues:
        u6 (ref,  index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
        tbl_upv_3 (copy, index: 3)
        u7 (ref,  index: 4)
        u1 (copy, index: 5)
        getCollidableExtentsSize (copy, index: 6)
        u2 (copy, index: 7)
        PathfindingService_upv_1 (copy, index: 8)
        u4 (ref,  index: 9)
        ClickToMoveDisplay_upv_1 (copy, index: 10)
        u8 (ref,  index: 11)
        Workspace_upv_1 (copy, index: 12)
        tbl_upv_4 (ref,  index: 13)
    ]]
    local tbl_upv_6 = {}
    local v26, v27
    if a3 == nil then
        v26 = u6
        v27 = true
    else
        v27, v26 = a3, a3
    end
    tbl_upv_6.Cancelled = false
    tbl_upv_6.Started = false
    tbl_upv_6.Finished = Instance.new("BindableEvent")
    tbl_upv_6.PathFailed = Instance.new("BindableEvent")
    tbl_upv_6.PathComputing = false
    tbl_upv_6.PathComputed = false
    tbl_upv_6.OriginalTargetPoint = a1
    tbl_upv_6.TargetPoint = a1
    tbl_upv_6.TargetSurfaceNormal = a2
    tbl_upv_6.DiedConn = nil
    tbl_upv_6.SeatedConn = nil
    tbl_upv_6.BlockedConn = nil
    tbl_upv_6.TeleportedConn = nil
    tbl_upv_6.CurrentPoint = 0
    tbl_upv_6.HumanoidOffsetFromPath = Vector3.new(0, 0, 0)
    tbl_upv_6.CurrentWaypointPosition = nil
    tbl_upv_6.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
    tbl_upv_6.CurrentWaypointPlaneDistance = 0
    tbl_upv_6.CurrentWaypointNeedsJump = false
    tbl_upv_6.CurrentHumanoidPosition = Vector3.new(0, 0, 0)
    tbl_upv_6.CurrentHumanoidVelocity = 0
    tbl_upv_6.NextActionMoveDirection = Vector3.new(0, 0, 0)
    tbl_upv_6.NextActionJump = false
    tbl_upv_6.Timeout = 0
    local v28 = LocalPlayer_upv_1
    local v29 = v28 and (v28.Character)
    local v30, v31, v32 = nil, nil, nil
    if v29 then
        v30 = tbl_upv_3[v28]
        if (v30) and v30.Parent == v29 then
            v32 = v30
        else
            tbl_upv_3[v28] = nil
            v31 = LocalPlayer_upv_1:FindFirstChildOfClass("Humanoid")
            if v31 then
                tbl_upv_3[v28] = v31
            end
            v32 = v31
        end
    else
        v32 = nil
    end
    tbl_upv_6.Humanoid = v32
    tbl_upv_6.OriginPoint = nil
    tbl_upv_6.AgentCanFollowPath = false
    tbl_upv_6.DirectPath = false
    tbl_upv_6.DirectPathRiseFirst = false
    tbl_upv_6.stopTraverseFunc = nil
    tbl_upv_6.setPointFunc = nil
    tbl_upv_6.pointList = nil
    v32 = tbl_upv_6.Humanoid and (tbl_upv_6.Humanoid.RootPart)
    local v33 = nil
    if v32 then
        tbl_upv_6.OriginPoint = v32.CFrame.Position
        v28 = 2
        v29 = 5
        v30 = true
        v33 = tbl_upv_6.Humanoid.SeatPart
        if v33 then
            local v34 = nil
            if v33:IsA("VehicleSeat") then
                v34 = v33:FindFirstAncestorOfClass("Model")
                if v34 then
                    local PrimaryPart_1 = v34.PrimaryPart
                    v34.PrimaryPart = v33
                    if v27 then
                        local v35 = v34:GetExtentsSize()
                        local _ = u7 * 0.5 * math.sqrt((v35.X * v35.X) + (v35.Z * v35.Z))
                        local v57 = u7 * v35.Y
                        v30 = false
                        tbl_upv_6.AgentCanFollowPath = true
                        tbl_upv_6.DirectPath = v27
                    end
                    v34.PrimaryPart = PrimaryPart_1
                end
            else
                local v36 = nil
                if u1 then
                    local v37 = LocalPlayer_upv_1 and (LocalPlayer_upv_1.Character)
                    if v37 ~= nil then
                        v36 = getCollidableExtentsSize(v37)
                    end
                end
                if v36 == nil then
                    v36 = (LocalPlayer_upv_1 and (LocalPlayer_upv_1.Character)):GetExtentsSize()
                end
                assert(v36, "")
                local v38 = u7 * 0.5 * math.sqrt((v36.X * v36.X) + (v36.Z * v36.Z))
                local v39 = u7 * v36.Y
                local v40 = tbl_upv_6.Humanoid.JumpPower > 0
                tbl_upv_6.AgentCanFollowPath = true
                tbl_upv_6.DirectPath = v26
                tbl_upv_6.DirectPathRiseFirst = tbl_upv_6.Humanoid.Sit
                v28, v29, v30 = v38, v39, v40
            end
        else
            local v36 = nil
            if u1 then
                local v37 = LocalPlayer_upv_1 and (LocalPlayer_upv_1.Character)
                if v37 ~= nil then
                    v36 = getCollidableExtentsSize(v37)
                end
            end
            if v36 == nil then
                v36 = (LocalPlayer_upv_1 and (LocalPlayer_upv_1.Character)):GetExtentsSize()
            end
            assert(v36, "")
            local v38 = u7 * 0.5 * math.sqrt((v36.X * v36.X) + (v36.Z * v36.Z))
            local v39 = u7 * v36.Y
            local v40 = tbl_upv_6.Humanoid.JumpPower > 0
            tbl_upv_6.AgentCanFollowPath = true
            tbl_upv_6.DirectPath = v26
            tbl_upv_6.DirectPathRiseFirst = tbl_upv_6.Humanoid.Sit
            v28, v29, v30 = v38, v39, v40
        end
        if u2 then
            tbl_upv_6.pathResult = PathfindingService_upv_1:CreatePath({AgentCanClimb = true, AgentRadius = v28, AgentHeight = v29, AgentCanJump = v30})
        else
            tbl_upv_6.pathResult = PathfindingService_upv_1:CreatePath({AgentRadius = v28, AgentHeight = v29, AgentCanJump = v30})
        end
    end
    function tbl_upv_6.Cleanup(a4)
        --[[
          name: Cleanup
          line: 327
          upvalues:
            tbl_upv_6 (copy, index: 1)
        ]]
        if tbl_upv_6.stopTraverseFunc then
            tbl_upv_6.stopTraverseFunc()
            tbl_upv_6.stopTraverseFunc = nil
        end
        if tbl_upv_6.BlockedConn then
            tbl_upv_6.BlockedConn:Disconnect()
            tbl_upv_6.BlockedConn = nil
        end
        if tbl_upv_6.DiedConn then
            tbl_upv_6.DiedConn:Disconnect()
            tbl_upv_6.DiedConn = nil
        end
        if tbl_upv_6.SeatedConn then
            tbl_upv_6.SeatedConn:Disconnect()
            tbl_upv_6.SeatedConn = nil
        end
        if tbl_upv_6.TeleportedConn then
            tbl_upv_6.TeleportedConn:Disconnect()
            tbl_upv_6.TeleportedConn = nil
        end
        tbl_upv_6.Started = false
    end
    function tbl_upv_6.Cancel(a5)
        --[[
          name: Cancel
          line: 356
          upvalues:
            tbl_upv_6 (copy, index: 1)
        ]]
        tbl_upv_6.Cancelled = true
        tbl_upv_6:Cleanup()
    end
    function tbl_upv_6.IsActive(a6)
        --[[
          name: IsActive
          line: 361
          upvalues:
            tbl_upv_6 (copy, index: 1)
        ]]
        return tbl_upv_6.AgentCanFollowPath and (tbl_upv_6.Started and (not tbl_upv_6.Cancelled))
    end
    function tbl_upv_6.OnPathInterrupted(a7)
        --[[
          name: OnPathInterrupted
          line: 365
          upvalues:
            tbl_upv_6 (copy, index: 1)
        ]]
        tbl_upv_6.Cancelled = true
        tbl_upv_6:OnPointReached(false)
    end
    function tbl_upv_6.ComputePath(a8)
        --[[
          name: ComputePath
          line: 371
          upvalues:
            tbl_upv_6 (copy, index: 1)
        ]]
        if not tbl_upv_6.OriginPoint then
            return
        end
        if not (tbl_upv_6.PathComputed) and not (tbl_upv_6.PathComputing) then
            tbl_upv_6.PathComputing = true
            if tbl_upv_6.AgentCanFollowPath then
                if tbl_upv_6.DirectPath then
                    local v41 = PathWaypoint.new(tbl_upv_6.OriginPoint, Enum.PathWaypointAction.Walk)
                    tbl_upv_6.pointList = {v41, PathWaypoint.new(tbl_upv_6.TargetPoint, ((tbl_upv_6.DirectPathRiseFirst) and (Enum.PathWaypointAction.Jump)) or (Enum.PathWaypointAction.Walk))}
                    tbl_upv_6.PathComputed = true
                else
                    tbl_upv_6.pathResult:ComputeAsync(tbl_upv_6.OriginPoint, tbl_upv_6.TargetPoint)
                    tbl_upv_6.pointList = tbl_upv_6.pathResult:GetWaypoints()
                    tbl_upv_6.BlockedConn = tbl_upv_6.pathResult.Blocked:Connect(
                        function(a9)
                            --[[
                              line: 385
                              upvalues:
                                tbl_upv_6 (copy, index: 1)
                            ]]
                            tbl_upv_6:OnPathBlocked(a9)
                        end
                    )
                    tbl_upv_6.PathComputed = tbl_upv_6.pathResult.Status == Enum.PathStatus.Success
                end
            end
            tbl_upv_6.PathComputing = false
            return
        end
    end
    function tbl_upv_6.IsValidPath(a10)
        --[[
          name: IsValidPath
          line: 393
          upvalues:
            tbl_upv_6 (copy, index: 1)
        ]]
        tbl_upv_6:ComputePath()
        return tbl_upv_6.PathComputed and (tbl_upv_6.AgentCanFollowPath)
    end
    tbl_upv_6.Recomputing = false
    function tbl_upv_6.OnPathBlocked(a11, a12)
        --[[
          name: OnPathBlocked
          line: 399
          upvalues:
            tbl_upv_6 (copy, index: 1)
            u4 (ref,  index: 2)
            ClickToMoveDisplay_upv_1 (copy, index: 3)
        ]]
        if not (tbl_upv_6.CurrentPoint <= a12) or (tbl_upv_6.Recomputing) then
            return
        end
        tbl_upv_6.Recomputing = true
        if tbl_upv_6.stopTraverseFunc then
            tbl_upv_6.stopTraverseFunc()
            tbl_upv_6.stopTraverseFunc = nil
        end
        tbl_upv_6.OriginPoint = tbl_upv_6.Humanoid.RootPart.CFrame.p
        tbl_upv_6.pathResult:ComputeAsync(tbl_upv_6.OriginPoint, tbl_upv_6.TargetPoint)
        tbl_upv_6.pointList = tbl_upv_6.pathResult:GetWaypoints()
        if #tbl_upv_6.pointList > 0 then
            tbl_upv_6.HumanoidOffsetFromPath = tbl_upv_6.pointList[1].Position - tbl_upv_6.OriginPoint
        end
        tbl_upv_6.PathComputed = tbl_upv_6.pathResult.Status == Enum.PathStatus.Success
        if u4 then
            local v42, v43 = ClickToMoveDisplay_upv_1.CreatePathDisplay(tbl_upv_6.pointList)
            tbl_upv_6.stopTraverseFunc = v42
            tbl_upv_6.setPointFunc = v43
        end
        if tbl_upv_6.PathComputed then
            tbl_upv_6.CurrentPoint = 1
            tbl_upv_6:OnPointReached(true)
        else
            tbl_upv_6.PathFailed:Fire()
            tbl_upv_6:Cleanup()
        end
        tbl_upv_6.Recomputing = false
    end
    function tbl_upv_6.OnRenderStepped(a13, a14)
        --[[
          name: OnRenderStepped
          line: 435
          upvalues:
            tbl_upv_6 (copy, index: 1)
            u8 (ref,  index: 2)
        ]]
        if not tbl_upv_6.Started or tbl_upv_6.Cancelled then
            return
        end
        tbl_upv_6.Timeout = tbl_upv_6.Timeout + a14
        if u8 < tbl_upv_6.Timeout then
            tbl_upv_6:OnPointReached(false)
        else
            tbl_upv_6.CurrentHumanoidPosition = tbl_upv_6.Humanoid.RootPart.Position + tbl_upv_6.HumanoidOffsetFromPath
            tbl_upv_6.CurrentHumanoidVelocity = tbl_upv_6.Humanoid.RootPart.Velocity
            while tbl_upv_6.Started do
                if tbl_upv_6:IsCurrentWaypointReached() then
                    tbl_upv_6:OnPointReached(true)
                    continue
                else
                    break
                end
            end
            if not tbl_upv_6.Started then
                return
            end
            tbl_upv_6.NextActionMoveDirection = tbl_upv_6.CurrentWaypointPosition - tbl_upv_6.CurrentHumanoidPosition
            if tbl_upv_6.NextActionMoveDirection.Magnitude > 1e-06 then
                tbl_upv_6.NextActionMoveDirection = tbl_upv_6.NextActionMoveDirection.Unit
            else
                tbl_upv_6.NextActionMoveDirection = Vector3.new(0, 0, 0)
            end
            if tbl_upv_6.CurrentWaypointNeedsJump then
                tbl_upv_6.NextActionJump = true
                tbl_upv_6.CurrentWaypointNeedsJump = false
            else
                tbl_upv_6.NextActionJump = false
            end
        end
    end
    function tbl_upv_6.IsCurrentWaypointReached(a15)
        --[[
          name: IsCurrentWaypointReached
          line: 473
          upvalues:
            tbl_upv_6 (copy, index: 1)
        ]]
        local v44
        if tbl_upv_6.CurrentWaypointPlaneNormal == Vector3.new(0, 0, 0) then
            v44 = true
        else
            v44 = tbl_upv_6.CurrentWaypointPlaneNormal:Dot(tbl_upv_6.CurrentHumanoidPosition) - tbl_upv_6.CurrentWaypointPlaneDistance < math.max(1, 0.0625 * -tbl_upv_6.CurrentWaypointPlaneNormal:Dot(tbl_upv_6.CurrentHumanoidVelocity))
        end
        if v44 then
            tbl_upv_6.CurrentWaypointPosition = nil
            tbl_upv_6.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            tbl_upv_6.CurrentWaypointPlaneDistance = 0
        end
        return v44
    end
    function tbl_upv_6.OnPointReached(a16, a17)
        --[[
          name: OnPointReached
          line: 499
          upvalues:
            tbl_upv_6 (copy, index: 1)
        ]]
        if a17 and not (tbl_upv_6.Cancelled) then
            if tbl_upv_6.setPointFunc then
                tbl_upv_6.setPointFunc(tbl_upv_6.CurrentPoint)
            end
            local v45 = tbl_upv_6.CurrentPoint + 1
            local v46 = nil
            if #tbl_upv_6.pointList < v45 then
                if tbl_upv_6.stopTraverseFunc then
                    tbl_upv_6.stopTraverseFunc()
                end
                tbl_upv_6.Finished:Fire()
                tbl_upv_6:Cleanup()
            else
                local v47 = tbl_upv_6.pointList[tbl_upv_6.CurrentPoint]
                local v48 = tbl_upv_6.pointList[v45]
                v46 = tbl_upv_6.Humanoid:GetState()
                local v49 = true
                local v50
                if v46 == Enum.HumanoidStateType.FallingDown then
                    v50 = v49
                else
                    v50 = true
                    if v46 ~= Enum.HumanoidStateType.Freefall then
                        v50 = v46 == Enum.HumanoidStateType.Jumping
                    end
                end
                if v50 then
                    local v51 = v48.Action == Enum.PathWaypointAction.Jump
                    if not (v51) and tbl_upv_6.CurrentPoint > 1 then
                        local _ = v47.Position - tbl_upv_6.pointList[tbl_upv_6.CurrentPoint - 1].Position
                        local v52 = v48.Position - v47.Position
                        v51 = Vector2.new((v47.Position - tbl_upv_6.pointList[tbl_upv_6.CurrentPoint - 1].Position).x, (v47.Position - tbl_upv_6.pointList[tbl_upv_6.CurrentPoint - 1].Position).z).Unit:Dot(Vector2.new((v48.Position - v47.Position).x, (v48.Position - v47.Position).z).Unit) < 0.996
                    end
                    if v51 then
                        tbl_upv_6.Humanoid.FreeFalling:Wait()
                        wait(0.1)
                    end
                end
                tbl_upv_6:MoveToNextWayPoint(v47, v48, v45)
            end
            return
        end
        tbl_upv_6.PathFailed:Fire()
        tbl_upv_6:Cleanup()
    end
    function tbl_upv_6.MoveToNextWayPoint(a18, a19, a20, a21)
        --[[
          name: MoveToNextWayPoint
          line: 562
          upvalues:
            tbl_upv_6 (copy, index: 1)
            u2 (copy, index: 2)
        ]]
        tbl_upv_6.CurrentWaypointPlaneNormal = a19.Position - a20.Position
        if not (u2) or a20.Label ~= "Climb" then
            tbl_upv_6.CurrentWaypointPlaneNormal = Vector3.new(tbl_upv_6.CurrentWaypointPlaneNormal.X, 0, tbl_upv_6.CurrentWaypointPlaneNormal.Z)
        end
        if tbl_upv_6.CurrentWaypointPlaneNormal.Magnitude > 1e-06 then
            tbl_upv_6.CurrentWaypointPlaneNormal = tbl_upv_6.CurrentWaypointPlaneNormal.Unit
            tbl_upv_6.CurrentWaypointPlaneDistance = tbl_upv_6.CurrentWaypointPlaneNormal:Dot(a20.Position)
        else
            tbl_upv_6.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            tbl_upv_6.CurrentWaypointPlaneDistance = 0
        end
        tbl_upv_6.CurrentWaypointNeedsJump = a20.Action == Enum.PathWaypointAction.Jump
        tbl_upv_6.CurrentWaypointPosition = a20.Position
        tbl_upv_6.CurrentPoint = a21
        tbl_upv_6.Timeout = 0
    end
    function tbl_upv_6.Start(a22, a23)
        --[[
          name: Start
          line: 594
          upvalues:
            tbl_upv_6 (copy, index: 1)
            ClickToMoveDisplay_upv_1 (copy, index: 2)
            u4 (ref,  index: 3)
        ]]
        if tbl_upv_6.AgentCanFollowPath then
            if tbl_upv_6.Started then
                return
            end
            tbl_upv_6.Started = true
            ClickToMoveDisplay_upv_1.CancelFailureAnimation()
            if u4 and (a23 == nil or a23) then
                local v52, v53 = ClickToMoveDisplay_upv_1.CreatePathDisplay(tbl_upv_6.pointList, tbl_upv_6.OriginalTargetPoint)
                tbl_upv_6.stopTraverseFunc = v52
                tbl_upv_6.setPointFunc = v53
            end
            if #tbl_upv_6.pointList > 0 then
                tbl_upv_6.HumanoidOffsetFromPath = Vector3.new(0, tbl_upv_6.pointList[1].Position.Y - tbl_upv_6.OriginPoint.Y, 0)
                tbl_upv_6.CurrentHumanoidPosition = tbl_upv_6.Humanoid.RootPart.Position + tbl_upv_6.HumanoidOffsetFromPath
                tbl_upv_6.CurrentHumanoidVelocity = tbl_upv_6.Humanoid.RootPart.Velocity
                tbl_upv_6.SeatedConn = tbl_upv_6.Humanoid.Seated:Connect(
                    function(a24, a25)
                        --[[
                          line: 621
                          upvalues:
                            tbl_upv_6 (copy, index: 1)
                        ]]
                        tbl_upv_6:OnPathInterrupted()
                    end
                )
                tbl_upv_6.DiedConn = tbl_upv_6.Humanoid.Died:Connect(
                    function()
                        --[[
                          line: 622
                          upvalues:
                            tbl_upv_6 (copy, index: 1)
                        ]]
                        tbl_upv_6:OnPathInterrupted()
                    end
                )
                tbl_upv_6.TeleportedConn = tbl_upv_6.Humanoid.RootPart:GetPropertyChangedSignal("CFrame"):Connect(
                    function()
                        --[[
                          line: 623
                          upvalues:
                            tbl_upv_6 (copy, index: 1)
                        ]]
                        tbl_upv_6:OnPathInterrupted()
                    end
                )
                tbl_upv_6.CurrentPoint = 1
                tbl_upv_6:OnPointReached(true)
            else
                tbl_upv_6.PathFailed:Fire()
                if tbl_upv_6.stopTraverseFunc then
                    tbl_upv_6.stopTraverseFunc()
                end
            end
        else
            tbl_upv_6.PathFailed:Fire()
        end
    end
    local v54 = Ray.new(tbl_upv_6.TargetPoint + (tbl_upv_6.TargetSurfaceNormal * 1.5), Vector3.new(0, -50, 0))
    if not (tbl_upv_4) then
        tbl_upv_4 = {}
        assert(tbl_upv_4, "")
        table.insert(tbl_upv_4, LocalPlayer_upv_1 and (LocalPlayer_upv_1.Character))
    end
    local v55, v56 = Workspace_upv_1:FindPartOnRayWithIgnoreList(v54, tbl_upv_4)
    if v55 then
        tbl_upv_6.TargetPoint = v56
    end
    tbl_upv_6:ComputePath()
    return tbl_upv_6
end
local function CheckAlive()
    --[[
      name: CheckAlive
      line: 650
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        tbl_upv_3 (copy, index: 2)
    ]]
    local v57 = LocalPlayer_upv_1 and (LocalPlayer_upv_1.Character)
    local v58, v59, v60 = nil, nil, nil
    if v57 then
        v58 = tbl_upv_3[LocalPlayer_upv_1]
        if (v58) and v58.Parent == v57 then
            v60 = v58
        else
            tbl_upv_3[LocalPlayer_upv_1] = nil
            v59 = LocalPlayer_upv_1:FindFirstChildOfClass("Humanoid")
            if v59 then
                tbl_upv_3[LocalPlayer_upv_1] = v59
            end
            v60 = v59
        end
    else
        v60 = nil
    end
    local v61 = false
    if v60 ~= nil then
        v61 = v60.Health > 0
    end
    return v61
end
local u12 = nil
local u13 = nil
local u14 = nil
local function CleanupPath()
    --[[
      name: CleanupPath
      line: 670
      upvalues:
        u12 (ref, index: 1)
        u13 (ref, index: 2)
        u14 (ref, index: 3)
    ]]
    if u12 then
        u12:Cancel()
        u12 = nil
    end
    if u13 then
        u13:Disconnect()
        u13 = nil
    end
    if not u14 then
        return
    end
    u14:Disconnect()
    u14 = nil
end
local function GetEquippedTool(a1)
    --[[
      name: GetEquippedTool
      line: 655
    ]]
    if a1 == nil then
        return
    end
    for _, value_4 in pairs(a1:GetChildren()) do
        if not (value_4:IsA("Tool")) then
            continue
        end
        return value_4
    end
end
local function HandleMoveTo(a1, a2, a3, a4, a5)
    --[[
      name: HandleMoveTo
      line: 688
      upvalues:
        u12 (ref,  index: 1)
        u13 (ref,  index: 2)
        u14 (ref,  index: 3)
        GetEquippedTool (copy, index: 4)
        u5 (ref,  index: 5)
        ClickToMoveDisplay_upv_1 (copy, index: 6)
    ]]
    if u12 then
        if u12 then
            u12:Cancel()
            u12 = nil
        end
        if u13 then
            u13:Disconnect()
            u13 = nil
        end
        if u14 then
            u14:Disconnect()
            u14 = nil
        end
    end
    u12 = a1
    a1:Start(a5)
    local v62 = a1.Finished.Event:Connect(
        function()
            --[[
              line: 695
              upvalues:
                u12 (ref,  index: 1)
                u13 (ref,  index: 2)
                u14 (ref,  index: 3)
                a3 (copy, index: 4)
                GetEquippedTool (copy, index: 5)
                a4 (copy, index: 6)
            ]]
            if u12 then
                u12:Cancel()
                u12 = nil
            end
            if u13 then
                u13:Disconnect()
                u13 = nil
            end
            if u14 then
                u14:Disconnect()
                u14 = nil
            end
            if a3 then
                local v63 = GetEquippedTool(a4)
                if not v63 then
                    return
                end
                v63:Activate()
            end
        end
    )
    u13 = v62
    local v64 = a1.PathFailed.Event:Connect(
        function()
            --[[
              line: 704
              upvalues:
                u12 (ref,  index: 1)
                u13 (ref,  index: 2)
                u14 (ref,  index: 3)
                a5 (copy, index: 4)
                u5 (ref,  index: 5)
                ClickToMoveDisplay_upv_1 (copy, index: 6)
                a2 (copy, index: 7)
            ]]
            if u12 then
                u12:Cancel()
                u12 = nil
            end
            if u13 then
                u13:Disconnect()
                u13 = nil
            end
            if u14 then
                u14:Disconnect()
                u14 = nil
            end
            if a5 == nil or a5 then
                local v65 = u5
                if v65 then
                    local v66 = u12 and u12:IsActive()
                    v65 = not v66
                end
                if v65 then
                    ClickToMoveDisplay_upv_1.PlayFailureAnimation()
                end
                ClickToMoveDisplay_upv_1.DisplayFailureWaypoint(a2)
            end
        end
    )
    u14 = v64
end
local function ShowPathFailedFeedback(a1)
    --[[
      name: ShowPathFailedFeedback
      line: 716
      upvalues:
        u12 (ref,  index: 1)
        u5 (ref,  index: 2)
        ClickToMoveDisplay_upv_1 (copy, index: 3)
    ]]
    if u12 and u12:IsActive() then
        u12:Cancel()
    end
    if u5 then
        ClickToMoveDisplay_upv_1.PlayFailureAnimation()
    end
    ClickToMoveDisplay_upv_1.DisplayFailureWaypoint(a1)
end
function OnTap(a1, a2, a3)
    --[[
      name: OnTap
      line: 726
      upvalues:
        Workspace_upv_1 (copy, index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
        tbl_upv_3 (copy, index: 3)
        tbl_upv_2 (copy, index: 4)
        tbl_upv_4 (ref,  index: 5)
        StarterGui_upv_1 (copy, index: 6)
        Players_upv_1 (copy, index: 7)
        u12 (ref,  index: 8)
        u13 (ref,  index: 9)
        u14 (ref,  index: 10)
        Pather (copy, index: 11)
        HandleMoveTo (copy, index: 12)
        u5 (ref,  index: 13)
        ClickToMoveDisplay_upv_1 (copy, index: 14)
        GetEquippedTool (copy, index: 15)
    ]]
    local CurrentCamera_1 = Workspace_upv_1.CurrentCamera
    local Character_1 = LocalPlayer_upv_1.Character
    local v67 = LocalPlayer_upv_1 and (LocalPlayer_upv_1.Character)
    local v68, v69, v70 = nil, nil, nil
    if v67 then
        v68 = tbl_upv_3[LocalPlayer_upv_1]
        if (v68) and v68.Parent == v67 then
            v70 = v68
        else
            tbl_upv_3[LocalPlayer_upv_1] = nil
            v69 = LocalPlayer_upv_1:FindFirstChildOfClass("Humanoid")
            if v69 then
                tbl_upv_3[LocalPlayer_upv_1] = v69
            end
            v70 = v69
        end
    else
        v70 = nil
    end
    local v71 = false
    if v70 ~= nil then
        v71 = v70.Health > 0
    end
    if not v71 then
        return
    end
    if #a1 ~= 1 and not (a2) then
        if #a1 >= 2 and CurrentCamera_1 then
            v71 = GetEquippedTool(Character_1)
            if v71 then
                v71:Activate()
            end
        end
        return
    end
    if not CurrentCamera_1 then
        return
    end
    v71 = CurrentCamera_1:ScreenPointToRay(a1[1].X, a1[1].Y)
    local v72 = Ray.new(v71.Origin, v71.Direction * 1000)
    local v73 = LocalPlayer_upv_1
    local v74 = v73 and (v73.Character)
    local v75 = nil
    if v74 then
        v69 = tbl_upv_3[v73]
        if not (v69) or v69.Parent ~= v74 then
            tbl_upv_3[v73] = nil
            v75 = LocalPlayer_upv_1:FindFirstChildOfClass("Humanoid")
            if v75 then
                tbl_upv_3[v73] = v75
            end
        end
    end
    local Raycast_2 = tbl_upv_2.Raycast
    if not (tbl_upv_4) then
        tbl_upv_4 = {}
        assert(tbl_upv_4, "")
        table.insert(tbl_upv_4, LocalPlayer_upv_1 and (LocalPlayer_upv_1.Character))
    end
    local v76
    v73, v76, v69 = Raycast_2(v72, true, tbl_upv_4)
    local v77, v78 = tbl_upv_2.FindCharacterAncestor(v73)
    if a3 and v78 and StarterGui_upv_1:GetCore("AvatarContextMenuEnabled") and Players_upv_1:GetPlayerFromCharacter(v78.Parent) then
        if u12 then
            u12:Cancel()
            u12 = nil
        end
        if u13 then
            u13:Disconnect()
            u13 = nil
        end
        if u14 then
            u14:Disconnect()
            u14 = nil
        end
        return
    end
    if a2 then
        local _ = nil
        v76 = a2
    end
    if not v76 or not Character_1 then
        return
    end
    if u12 then
        u12:Cancel()
        u12 = nil
    end
    if u13 then
        u13:Disconnect()
        u13 = nil
    end
    if u14 then
        u14:Disconnect()
        u14 = nil
    end
    local v79 = Pather(v76, v69)
    if v79:IsValidPath() then
        HandleMoveTo(v79, v76, v77, Character_1)
    else
        v79:Cleanup()
        if u12 and u12:IsActive() then
            u12:Cancel()
        end
        if u5 then
            ClickToMoveDisplay_upv_1.PlayFailureAnimation()
        end
        ClickToMoveDisplay_upv_1.DisplayFailureWaypoint(v76)
    end
end
local function DisconnectEvent(a1)
    --[[
      name: DisconnectEvent
      line: 779
    ]]
    if not a1 then
        return
    end
    a1:Disconnect()
end
local Keyboard_upv_1 = require(script.Parent:WaitForChild("Keyboard"))
local u15 = setmetatable({}, Keyboard_upv_1)
u15.__index = u15
function u15.new(a1)
    --[[
      name: new
      line: 790
      upvalues:
        Keyboard_upv_1 (copy, index: 1)
        u15 (copy, index: 2)
    ]]
    local v80 = setmetatable(Keyboard_upv_1.new(a1), u15)
    v80.fingerTouches = {}
    v80.numUnsunkTouches = 0
    v80.mouse1Down = tick()
    v80.mouse1DownPos = Vector2.new()
    v80.mouse2DownTime = tick()
    v80.mouse2DownPos = Vector2.new()
    v80.mouse2UpTime = tick()
    v80.keyboardMoveVector = Vector3.new(0, 0, 0)
    v80.tapConn = nil
    v80.inputBeganConn = nil
    v80.inputChangedConn = nil
    v80.inputEndedConn = nil
    v80.humanoidDiedConn = nil
    v80.characterChildAddedConn = nil
    v80.onCharacterAddedConn = nil
    v80.characterChildRemovedConn = nil
    v80.renderSteppedConn = nil
    v80.menuOpenedConnection = nil
    v80.running = false
    v80.wasdEnabled = false
    return v80
end
function u15.DisconnectEvents(a1)
    --[[
      name: DisconnectEvents
      line: 822
    ]]
    local tapConn_1 = a1.tapConn
    if tapConn_1 then
        tapConn_1:Disconnect()
    end
    local inputBeganConn_1 = a1.inputBeganConn
    if inputBeganConn_1 then
        inputBeganConn_1:Disconnect()
    end
    local inputChangedConn_1 = a1.inputChangedConn
    if inputChangedConn_1 then
        inputChangedConn_1:Disconnect()
    end
    local inputEndedConn_1 = a1.inputEndedConn
    if inputEndedConn_1 then
        inputEndedConn_1:Disconnect()
    end
    local humanoidDiedConn_1 = a1.humanoidDiedConn
    if humanoidDiedConn_1 then
        humanoidDiedConn_1:Disconnect()
    end
    local characterChildAddedConn_1 = a1.characterChildAddedConn
    if characterChildAddedConn_1 then
        characterChildAddedConn_1:Disconnect()
    end
    local onCharacterAddedConn_1 = a1.onCharacterAddedConn
    if onCharacterAddedConn_1 then
        onCharacterAddedConn_1:Disconnect()
    end
    local renderSteppedConn_1 = a1.renderSteppedConn
    if renderSteppedConn_1 then
        renderSteppedConn_1:Disconnect()
    end
    local characterChildRemovedConn_1 = a1.characterChildRemovedConn
    if characterChildRemovedConn_1 then
        characterChildRemovedConn_1:Disconnect()
    end
    local menuOpenedConnection_1 = a1.menuOpenedConnection
    if not menuOpenedConnection_1 then
        return
    end
    menuOpenedConnection_1:Disconnect()
end
function u15.OnTouchBegan(a1, a2, a3)
    --[[
      name: OnTouchBegan
      line: 835
    ]]
    if a1.fingerTouches[a2] == nil and not (a3) then
        a1.numUnsunkTouches = a1.numUnsunkTouches + 1
    end
    a1.fingerTouches[a2] = a3
end
function u15.OnTouchChanged(a1, a2, a3)
    --[[
      name: OnTouchChanged
      line: 842
    ]]
    if a1.fingerTouches[a2] ~= nil then
        return
    end
    a1.fingerTouches[a2] = a3
    if (a3) then
        return
    end
    a1.numUnsunkTouches = a1.numUnsunkTouches + 1
end
function u15.OnTouchEnded(a1, a2, a3)
    --[[
      name: OnTouchEnded
      line: 851
    ]]
    if a1.fingerTouches[a2] ~= nil and a1.fingerTouches[a2] == false then
        a1.numUnsunkTouches = a1.numUnsunkTouches - 1
    end
    a1.fingerTouches[a2] = nil
end
function u15.OnCharacterAdded(a1, a2)
    --[[
      name: OnCharacterAdded
      line: 859
      upvalues:
        UserInputService_upv_1 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
        u12 (ref,  index: 3)
        u13 (ref,  index: 4)
        u14 (ref,  index: 5)
        ClickToMoveDisplay_upv_1 (copy, index: 6)
        GuiService_upv_1 (copy, index: 7)
    ]]
    a1:DisconnectEvents()
    a1.inputBeganConn = UserInputService_upv_1.InputBegan:Connect(
        function(a3, a4)
            --[[
              line: 862
              upvalues:
                a1 (copy, index: 1)
                tbl_upv_1 (copy, index: 2)
                u12 (ref,  index: 3)
                u13 (ref,  index: 4)
                u14 (ref,  index: 5)
                ClickToMoveDisplay_upv_1 (copy, index: 6)
            ]]
            if a3.UserInputType == Enum.UserInputType.Touch then
                a1:OnTouchBegan(a3, a4)
            end
            if a1.wasdEnabled and a4 == false and a3.UserInputType == Enum.UserInputType.Keyboard and tbl_upv_1[a3.KeyCode] then
                if u12 then
                    u12:Cancel()
                    u12 = nil
                end
                if u13 then
                    u13:Disconnect()
                    u13 = nil
                end
                if u14 then
                    u14:Disconnect()
                    u14 = nil
                end
                ClickToMoveDisplay_upv_1.CancelFailureAnimation()
            end
            if a3.UserInputType == Enum.UserInputType.MouseButton1 then
                a1.mouse1DownTime = tick()
                a1.mouse1DownPos = a3.Position
            end
            if a3.UserInputType ~= Enum.UserInputType.MouseButton2 then
                return
            end
            a1.mouse2DownTime = tick()
            a1.mouse2DownPos = a3.Position
        end
    )
    a1.inputChangedConn = UserInputService_upv_1.InputChanged:Connect(
        function(a5, a6)
            --[[
              line: 883
              upvalues:
                a1 (copy, index: 1)
            ]]
            if a5.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            a1:OnTouchChanged(a5, a6)
        end
    )
    a1.inputEndedConn = UserInputService_upv_1.InputEnded:Connect(
        function(a7, a8)
            --[[
              line: 889
              upvalues:
                a1 (copy, index: 1)
                u12 (ref,  index: 2)
            ]]
            if a7.UserInputType == Enum.UserInputType.Touch then
                a1:OnTouchEnded(a7, a8)
            end
            if a7.UserInputType == Enum.UserInputType.MouseButton2 then
                a1.mouse2UpTime = tick()
                local Position_1 = a7.Position
                local v81 = u12 or (a1.keyboardMoveVector.Magnitude <= 0)
                if not (a1.mouse2UpTime - a1.mouse2DownTime < 0.25) or not ((Position_1 - a1.mouse2DownPos).magnitude < 5) or not v81 then
                    return
                end
                OnTap({Position_1})
            end
        end
    )
    a1.tapConn = UserInputService_upv_1.TouchTap:Connect(
        function(a9, a10)
            --[[
              line: 906
            ]]
            if (a10) then
                return
            end
            OnTap(a9, nil, true)
        end
    )
    a1.menuOpenedConnection = GuiService_upv_1.MenuOpened:Connect(
        function()
            --[[
              line: 912
              upvalues:
                u12 (ref, index: 1)
                u13 (ref, index: 2)
                u14 (ref, index: 3)
            ]]
            if u12 then
                u12:Cancel()
                u12 = nil
            end
            if u13 then
                u13:Disconnect()
                u13 = nil
            end
            if not u14 then
                return
            end
            u14:Disconnect()
            u14 = nil
        end
    )
    local function OnCharacterChildAdded(a11)
        --[[
          name: OnCharacterChildAdded
          line: 916
          upvalues:
            UserInputService_upv_1 (copy, index: 1)
            a1 (copy, index: 2)
        ]]
        if UserInputService_upv_1.TouchEnabled and a11:IsA("Tool") then
            a11.ManualActivationOnly = true
        end
        if a11:IsA("Humanoid") then
            local humanoidDiedConn_2 = a1.humanoidDiedConn
            if humanoidDiedConn_2 then
                humanoidDiedConn_2:Disconnect()
            end
            a1.humanoidDiedConn = a11.Died:Connect(function()
                --[[
                  line: 924
                ]]
            end)
        end
    end
    a1.characterChildAddedConn = a2.ChildAdded:Connect(
        function(a12)
            --[[
              line: 932
              upvalues:
                OnCharacterChildAdded (copy, index: 1)
            ]]
            OnCharacterChildAdded(a12)
        end
    )
    a1.characterChildRemovedConn = a2.ChildRemoved:Connect(
        function(a13)
            --[[
              line: 935
              upvalues:
                UserInputService_upv_1 (copy, index: 1)
            ]]
            if not UserInputService_upv_1.TouchEnabled or not a13:IsA("Tool") then
                return
            end
            a13.ManualActivationOnly = false
        end
    )
    for _, value_5 in pairs(a2:GetChildren()) do
        OnCharacterChildAdded(value_5)
    end
end
function u15.Start(a1)
    --[[
      name: Start
      line: 947
    ]]
    a1:Enable(true)
end
function u15.Stop(a1)
    --[[
      name: Stop
      line: 951
    ]]
    a1:Enable(false)
end
function u15.CleanupPath(a1)
    --[[
      name: CleanupPath
      line: 955
      upvalues:
        u12 (ref, index: 1)
        u13 (ref, index: 2)
        u14 (ref, index: 3)
    ]]
    if u12 then
        u12:Cancel()
        u12 = nil
    end
    if u13 then
        u13:Disconnect()
        u13 = nil
    end
    if not u14 then
        return
    end
    u14:Disconnect()
    u14 = nil
end
function u15.Enable(a1, a2, a3, a4)
    --[[
      name: Enable
      line: 959
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        u12 (ref,  index: 2)
        u13 (ref,  index: 3)
        u14 (ref,  index: 4)
        UserInputService_upv_1 (copy, index: 5)
        u3 (copy, index: 6)
        Keyboard_upv_1 (copy, index: 7)
    ]]
    if a2 then
        if not (a1.running) then
            if LocalPlayer_upv_1.Character then
                a1:OnCharacterAdded(LocalPlayer_upv_1.Character)
            end
            a1.onCharacterAddedConn = LocalPlayer_upv_1.CharacterAdded:Connect(
                function(a5)
                    --[[
                      line: 965
                      upvalues:
                        a1 (copy, index: 1)
                    ]]
                    a1:OnCharacterAdded(a5)
                end
            )
            a1.running = true
        end
        a1.touchJumpController = a4
        if a1.touchJumpController then
            a1.touchJumpController:Enable(a1.jumpEnabled)
        end
    else
        if a1.running then
            a1:DisconnectEvents()
            if u12 then
                u12:Cancel()
                u12 = nil
            end
            if u13 then
                u13:Disconnect()
                u13 = nil
            end
            if u14 then
                u14:Disconnect()
                u14 = nil
            end
            local v82 = nil
            if UserInputService_upv_1.TouchEnabled then
                v82 = LocalPlayer_upv_1.Character
                if v82 then
                    for _, value_6 in pairs(v82:GetChildren()) do
                        if value_6:IsA("Tool") then
                            value_6.ManualActivationOnly = false
                        end
                    end
                end
            end
            a1.running = false
        end
        if a1.touchJumpController and not (a1.jumpEnabled) then
            a1.touchJumpController:Enable(true)
        end
        a1.touchJumpController = nil
    end
    if u3 then
        Keyboard_upv_1.Enable(a1, a2)
    elseif UserInputService_upv_1.KeyboardEnabled and a2 ~= a1.enabled then
        a1.forwardValue = 0
        a1.backwardValue = 0
        a1.leftValue = 0
        a1.rightValue = 0
        a1.moveVector = Vector3.new(0, 0, 0)
        if a2 then
            a1:BindContextActions()
            a1:ConnectFocusEventListeners()
        else
            a1:UnbindContextActions()
            a1:DisconnectFocusEventListeners()
        end
    end
    a1.wasdEnabled = (a2 and a3) or false
    a1.enabled = a2
end
function u15.OnRenderStepped(a1, a2)
    --[[
      name: OnRenderStepped
      line: 1024
      upvalues:
        u12 (ref, index: 1)
    ]]
    a1.isJumping = false
    if u12 then
        u12:OnRenderStepped(a2)
        if u12 then
            a1.moveVector = u12.NextActionMoveDirection
            a1.moveVectorIsCameraRelative = false
            if u12.NextActionJump then
                a1.isJumping = true
            end
        else
            a1.moveVector = a1.keyboardMoveVector
            a1.moveVectorIsCameraRelative = true
        end
    else
        a1.moveVector = a1.keyboardMoveVector
        a1.moveVectorIsCameraRelative = true
    end
    if not a1.jumpRequested then
        return
    end
    a1.isJumping = true
end
function u15.UpdateMovement(a1, a2)
    --[[
      name: UpdateMovement
      line: 1059
    ]]
    if a2 == Enum.UserInputState.Cancel then
        a1.keyboardMoveVector = Vector3.new(0, 0, 0)
    elseif a1.wasdEnabled then
        a1.keyboardMoveVector = Vector3.new(a1.leftValue + a1.rightValue, 0, a1.forwardValue + a1.backwardValue)
    end
end
function u15.UpdateJump(a1)
    --[[
      name: UpdateJump
      line: 1068
    ]]
end
function u15.SetShowPath(a1, a2)
    --[[
      name: SetShowPath
      line: 1073
      upvalues:
        u4 (ref, index: 1)
    ]]
    u4 = a2
end
function u15.GetShowPath(a1)
    --[[
      name: GetShowPath
      line: 1077
      upvalues:
        u4 (ref, index: 1)
    ]]
    return u4
end
function u15.SetWaypointTexture(a1, a2)
    --[[
      name: SetWaypointTexture
      line: 1081
      upvalues:
        ClickToMoveDisplay_upv_1 (copy, index: 1)
    ]]
    ClickToMoveDisplay_upv_1.SetWaypointTexture(a2)
end
function u15.GetWaypointTexture(a1)
    --[[
      name: GetWaypointTexture
      line: 1085
      upvalues:
        ClickToMoveDisplay_upv_1 (copy, index: 1)
    ]]
    return ClickToMoveDisplay_upv_1.GetWaypointTexture()
end
function u15.SetWaypointRadius(a1, a2)
    --[[
      name: SetWaypointRadius
      line: 1089
      upvalues:
        ClickToMoveDisplay_upv_1 (copy, index: 1)
    ]]
    ClickToMoveDisplay_upv_1.SetWaypointRadius(a2)
end
function u15.GetWaypointRadius(a1)
    --[[
      name: GetWaypointRadius
      line: 1093
      upvalues:
        ClickToMoveDisplay_upv_1 (copy, index: 1)
    ]]
    return ClickToMoveDisplay_upv_1.GetWaypointRadius()
end
function u15.SetEndWaypointTexture(a1, a2)
    --[[
      name: SetEndWaypointTexture
      line: 1097
      upvalues:
        ClickToMoveDisplay_upv_1 (copy, index: 1)
    ]]
    ClickToMoveDisplay_upv_1.SetEndWaypointTexture(a2)
end
function u15.GetEndWaypointTexture(a1)
    --[[
      name: GetEndWaypointTexture
      line: 1101
      upvalues:
        ClickToMoveDisplay_upv_1 (copy, index: 1)
    ]]
    return ClickToMoveDisplay_upv_1.GetEndWaypointTexture()
end
function u15.SetWaypointsAlwaysOnTop(a1, a2)
    --[[
      name: SetWaypointsAlwaysOnTop
      line: 1105
      upvalues:
        ClickToMoveDisplay_upv_1 (copy, index: 1)
    ]]
    ClickToMoveDisplay_upv_1.SetWaypointsAlwaysOnTop(a2)
end
function u15.GetWaypointsAlwaysOnTop(a1)
    --[[
      name: GetWaypointsAlwaysOnTop
      line: 1109
      upvalues:
        ClickToMoveDisplay_upv_1 (copy, index: 1)
    ]]
    return ClickToMoveDisplay_upv_1.GetWaypointsAlwaysOnTop()
end
function u15.SetFailureAnimationEnabled(a1, a2)
    --[[
      name: SetFailureAnimationEnabled
      line: 1113
      upvalues:
        u5 (ref, index: 1)
    ]]
    u5 = a2
end
function u15.GetFailureAnimationEnabled(a1)
    --[[
      name: GetFailureAnimationEnabled
      line: 1117
      upvalues:
        u5 (ref, index: 1)
    ]]
    return u5
end
function u15.SetIgnoredPartsTag(a1, a2)
    --[[
      name: SetIgnoredPartsTag
      line: 1121
      upvalues:
        UpdateIgnoreTag (copy, index: 1)
    ]]
    UpdateIgnoreTag(a2)
end
function u15.GetIgnoredPartsTag(a1)
    --[[
      name: GetIgnoredPartsTag
      line: 1125
      upvalues:
        u9 (ref, index: 1)
    ]]
    return u9
end
function u15.SetUseDirectPath(a1, a2)
    --[[
      name: SetUseDirectPath
      line: 1129
      upvalues:
        u6 (ref, index: 1)
    ]]
    u6 = a2
end
function u15.GetUseDirectPath(a1)
    --[[
      name: GetUseDirectPath
      line: 1133
      upvalues:
        u6 (ref, index: 1)
    ]]
    return u6
end
function u15.SetAgentSizeIncreaseFactor(a1, a2)
    --[[
      name: SetAgentSizeIncreaseFactor
      line: 1137
      upvalues:
        u7 (ref, index: 1)
    ]]
    u7 = (a2 / 100) + 1
end
function u15.GetAgentSizeIncreaseFactor(a1)
    --[[
      name: GetAgentSizeIncreaseFactor
      line: 1141
      upvalues:
        u7 (ref, index: 1)
    ]]
    return (u7 - 1) * 100
end
function u15.SetUnreachableWaypointTimeout(a1, a2)
    --[[
      name: SetUnreachableWaypointTimeout
      line: 1145
      upvalues:
        u8 (ref, index: 1)
    ]]
    u8 = a2
end
function u15.GetUnreachableWaypointTimeout(a1)
    --[[
      name: GetUnreachableWaypointTimeout
      line: 1149
      upvalues:
        u8 (ref, index: 1)
    ]]
    return u8
end
function u15.SetUserJumpEnabled(a1, a2)
    --[[
      name: SetUserJumpEnabled
      line: 1153
    ]]
    a1.jumpEnabled = a2
    if not a1.touchJumpController then
        return
    end
    a1.touchJumpController:Enable(a2)
end
function u15.GetUserJumpEnabled(a1)
    --[[
      name: GetUserJumpEnabled
      line: 1160
    ]]
    return a1.jumpEnabled
end
function u15.MoveTo(a1, a2, a3, a4)
    --[[
      name: MoveTo
      line: 1164
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        Pather (copy, index: 2)
        HandleMoveTo (copy, index: 3)
    ]]
    local Character_2 = LocalPlayer_upv_1.Character
    if Character_2 == nil then
        return false
    end
    local v83 = Pather(a2, Vector3.new(0, 1, 0), a4)
    if v83 and v83:IsValidPath() then
        HandleMoveTo(v83, a2, nil, Character_2, a3)
        return true
    end
    return false
end
return u15