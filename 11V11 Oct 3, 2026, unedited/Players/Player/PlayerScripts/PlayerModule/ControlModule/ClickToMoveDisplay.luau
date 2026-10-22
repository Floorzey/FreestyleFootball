--[[
    Script Path: Game/Players/Player/PlayerScripts/PlayerModule/ControlModule/ClickToMoveDisplay
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local tbl_1 = {}
local u1 = "rbxasset://textures/ui/traildot.png"
local u2 = "rbxasset://textures/ui/waypoint.png"
local u3 = false
local u4 = UDim2.new(0, 42, 0, 50)
local u5 = Vector2.new(0, 0.5)
local u6 = Vector2.new(0, 1)
local u7 = Vector2.new(0, 0.5)
local u8 = Vector2.new(0.1, 0.5)
local u9 = Vector2.new(-0.1, 0.5)
local u10 = Vector2.new(1.5, 1.5)
local Players_1 = game:GetService("Players")
local TweenService_upv_1 = game:GetService("TweenService")
local RunService_upv_1 = game:GetService("RunService")
local Workspace_upv_1 = game:GetService("Workspace")
local LocalPlayer_upv_1 = Players_1.LocalPlayer
local function CreateWaypointTemplates()
    --[[
      name: CreateWaypointTemplates
      line: 44
      upvalues:
        u10 (ref,  index: 1)
        u3 (ref,  index: 2)
        u1 (ref,  index: 3)
        u4 (copy, index: 4)
        u5 (copy, index: 5)
        u2 (ref,  index: 6)
        u7 (copy, index: 7)
    ]]
    local v1 = Instance.new("Part")
    v1.Size = Vector3.new(1, 1, 1)
    v1.Anchored = true
    v1.CanCollide = false
    v1.Name = "TrailDot"
    v1.Transparency = 1
    local v2 = Instance.new("ImageHandleAdornment")
    v2.Name = "TrailDotImage"
    v2.Size = u10
    v2.SizeRelativeOffset = Vector3.new(0, 0, -0.10000000149011612)
    v2.AlwaysOnTop = u3
    v2.Image = u1
    v2.Adornee = v1
    v2.Parent = v1
    local v3 = Instance.new("Part")
    v3.Size = Vector3.new(2, 2, 2)
    v3.Anchored = true
    v3.CanCollide = false
    v3.Name = "EndWaypoint"
    v3.Transparency = 1
    local v4 = Instance.new("ImageHandleAdornment")
    v4.Name = "TrailDotImage"
    v4.Size = u10
    v4.SizeRelativeOffset = Vector3.new(0, 0, -0.10000000149011612)
    v4.AlwaysOnTop = u3
    v4.Image = u1
    v4.Adornee = v3
    v4.Parent = v3
    local v5 = Instance.new("BillboardGui")
    v5.Name = "EndWaypointBillboard"
    v5.Size = u4
    v5.LightInfluence = 0
    v5.SizeOffset = u5
    v5.AlwaysOnTop = true
    v5.Adornee = v3
    v5.Parent = v3
    local v6 = Instance.new("ImageLabel")
    v6.Image = u2
    v6.BackgroundTransparency = 1
    v6.Size = UDim2.new(1, 0, 1, 0)
    v6.Parent = v5
    local v7 = Instance.new("Part")
    v7.Size = Vector3.new(2, 2, 2)
    v7.Anchored = true
    v7.CanCollide = false
    v7.Name = "FailureWaypoint"
    v7.Transparency = 1
    local v8 = Instance.new("ImageHandleAdornment")
    v8.Name = "TrailDotImage"
    v8.Size = u10
    v8.SizeRelativeOffset = Vector3.new(0, 0, -0.10000000149011612)
    v8.AlwaysOnTop = u3
    v8.Image = u1
    v8.Adornee = v7
    v8.Parent = v7
    local v9 = Instance.new("BillboardGui")
    v9.Name = "FailureWaypointBillboard"
    v9.Size = u4
    v9.LightInfluence = 0
    v9.SizeOffset = u7
    v9.AlwaysOnTop = true
    v9.Adornee = v7
    v9.Parent = v7
    local v10 = Instance.new("Frame")
    v10.BackgroundTransparency = 1
    v10.Size = UDim2.new(0, 0, 0, 0)
    v10.Position = UDim2.new(0.5, 0, 1, 0)
    v10.Parent = v9
    local v11 = Instance.new("ImageLabel")
    v11.Image = u2
    v11.BackgroundTransparency = 1
    v11.Position = UDim2.new(0, -u4.X.Offset / 2, 0, -u4.Y.Offset)
    v11.Size = u4
    v11.Parent = v10
    return v1, v3, v7
end
local u11, u12, u13 = CreateWaypointTemplates()
local function getTrailDotParent()
    --[[
      name: getTrailDotParent
      line: 130
      upvalues:
        Workspace_upv_1 (copy, index: 1)
    ]]
    local CurrentCamera_1 = Workspace_upv_1.CurrentCamera
    local v12 = CurrentCamera_1:FindFirstChild("ClickToMoveDisplay")
    if not (v12) then
        v12 = Instance.new("Model")
        v12.Name = "ClickToMoveDisplay"
        v12.Parent = CurrentCamera_1
    end
    return v12
end
local tbl_upv_2 = {}
tbl_upv_2.__index = tbl_upv_2
function tbl_upv_2.Destroy(a1)
    --[[
      name: Destroy
      line: 156
    ]]
    a1.DisplayModel:Destroy()
end
local function placePathWaypoint(a1, a2)
    --[[
      name: placePathWaypoint
      line: 141
      upvalues:
        Workspace_upv_1 (copy, index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
    ]]
    local v13, v14, v15 = Workspace_upv_1:FindPartOnRayWithIgnoreList(Ray.new(a2 + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0)), {Workspace_upv_1.CurrentCamera, LocalPlayer_upv_1.Character})
    if v13 then
        a1.CFrame = CFrame.new(v14, v14 + v15)
        local CurrentCamera_2 = Workspace_upv_1.CurrentCamera
        local v16 = CurrentCamera_2:FindFirstChild("ClickToMoveDisplay")
        if not (v16) then
            v16 = Instance.new("Model")
            v16.Name = "ClickToMoveDisplay"
            v16.Parent = CurrentCamera_2
        end
        a1.Parent = v16
    end
end
function tbl_upv_2.NewDisplayModel(a1, a2)
    --[[
      name: NewDisplayModel
      line: 160
      upvalues:
        u11 (ref,  index: 1)
        placePathWaypoint (copy, index: 2)
    ]]
    local v17 = u11:Clone()
    placePathWaypoint(v17, a2)
    return v17
end
function tbl_upv_2.new(a1, a2)
    --[[
      name: new
      line: 166
      upvalues:
        tbl_upv_2 (copy, index: 1)
    ]]
    local v18 = setmetatable({}, tbl_upv_2)
    v18.DisplayModel = v18:NewDisplayModel(a1)
    v18.ClosestWayPoint = a2
    return v18
end
local tbl_upv_3 = {}
tbl_upv_3.__index = tbl_upv_3
function tbl_upv_3.Destroy(a1)
    --[[
      name: Destroy
      line: 178
    ]]
    a1.Destroyed = true
    a1.Tween:Cancel()
    a1.DisplayModel:Destroy()
end
function tbl_upv_3.NewDisplayModel(a1, a2)
    --[[
      name: NewDisplayModel
      line: 184
      upvalues:
        u12 (ref,  index: 1)
        placePathWaypoint (copy, index: 2)
    ]]
    local v19 = u12:Clone()
    placePathWaypoint(v19, a2)
    return v19
end
function tbl_upv_3.CreateTween(a1)
    --[[
      name: CreateTween
      line: 190
      upvalues:
        TweenService_upv_1 (copy, index: 1)
        u6 (copy, index: 2)
    ]]
    local v20 = TweenService_upv_1:Create(a1.DisplayModel.EndWaypointBillboard, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true), {SizeOffset = u6})
    v20:Play()
    return v20
end
function tbl_upv_3.TweenInFrom(a1, a2)
    --[[
      name: TweenInFrom
      line: 201
      upvalues:
        TweenService_upv_1 (copy, index: 1)
    ]]
    a1.DisplayModel.EndWaypointBillboard.StudsOffset = Vector3.new(0, (a2 - a1.DisplayModel.Position).Y, 0)
    local v21 = TweenService_upv_1:Create(a1.DisplayModel.EndWaypointBillboard, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {StudsOffset = Vector3.new(0, 0, 0)})
    v21:Play()
    return v21
end
function tbl_upv_3.new(a1, a2, a3)
    --[[
      name: new
      line: 215
      upvalues:
        tbl_upv_3 (copy, index: 1)
    ]]
    local u14 = setmetatable({}, tbl_upv_3)
    u14.DisplayModel = u14:NewDisplayModel(a1)
    u14.Destroyed = false
    if (a3) and ((a3 - a1).Magnitude > 5) then
        u14.Tween = u14:TweenInFrom(a3)
        coroutine.wrap(
            function()
                --[[
                  line: 222
                  upvalues:
                    u14 (copy, index: 1)
                ]]
                u14.Tween.Completed:Wait()
                if (u14.Destroyed) then
                    return
                end
                u14.Tween = u14:CreateTween()
            end
        )()
    else
        u14.Tween = u14:CreateTween()
    end
    u14.ClosestWayPoint = a2
    return u14
end
local tbl_upv_4 = {}
tbl_upv_4.__index = tbl_upv_4
function tbl_upv_4.Hide(a1)
    --[[
      name: Hide
      line: 239
    ]]
    a1.DisplayModel.Parent = nil
end
function tbl_upv_4.Destroy(a1)
    --[[
      name: Destroy
      line: 243
    ]]
    a1.DisplayModel:Destroy()
end
function tbl_upv_4.NewDisplayModel(a1, a2)
    --[[
      name: NewDisplayModel
      line: 247
      upvalues:
        u13 (ref,  index: 1)
        placePathWaypoint (copy, index: 2)
        Workspace_upv_1 (copy, index: 3)
        LocalPlayer_upv_1 (copy, index: 4)
    ]]
    local v22 = u13:Clone()
    placePathWaypoint(v22, a2)
    local v23, v24, v25 = Workspace_upv_1:FindPartOnRayWithIgnoreList(Ray.new(a2 + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0)), {Workspace_upv_1.CurrentCamera, LocalPlayer_upv_1.Character})
    if v23 then
        v22.CFrame = CFrame.new(v24, v24 + v25)
        local CurrentCamera_3 = Workspace_upv_1.CurrentCamera
        local v26 = CurrentCamera_3:FindFirstChild("ClickToMoveDisplay")
        if not (v26) then
            v26 = Instance.new("Model")
            v26.Name = "ClickToMoveDisplay"
            v26.Parent = CurrentCamera_3
        end
        v22.Parent = v26
    end
    return v22
end
function tbl_upv_4.RunFailureTween(a1)
    --[[
      name: RunFailureTween
      line: 261
      upvalues:
        TweenService_upv_1 (copy, index: 1)
        u8 (copy, index: 2)
        u9 (copy, index: 3)
        u7 (copy, index: 4)
    ]]
    wait(0.125)
    local v27 = TweenInfo.new(0.0625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local v28 = TweenService_upv_1:Create(a1.DisplayModel.FailureWaypointBillboard, v27, {SizeOffset = u8})
    v28:Play()
    TweenService_upv_1:Create(a1.DisplayModel.FailureWaypointBillboard.Frame, v27, {Rotation = 10}):Play()
    v28.Completed:wait()
    local v29 = TweenService_upv_1:Create(a1.DisplayModel.FailureWaypointBillboard, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3, true), {SizeOffset = u9})
    v29:Play()
    local v30 = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3, true)
    local tbl_5 = {}
    tbl_5.ImageColor3 = Color3.new(0.75, 0.75, 0.75)
    TweenService_upv_1:Create(a1.DisplayModel.FailureWaypointBillboard.Frame.ImageLabel, v30, tbl_5):Play()
    TweenService_upv_1:Create(a1.DisplayModel.FailureWaypointBillboard.Frame, v30, {Rotation = -10}):Play()
    v29.Completed:wait()
    local v31 = TweenInfo.new(0.0625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local v32 = TweenService_upv_1:Create(a1.DisplayModel.FailureWaypointBillboard, v31, {SizeOffset = u7})
    v32:Play()
    TweenService_upv_1:Create(a1.DisplayModel.FailureWaypointBillboard.Frame, v31, {Rotation = 0}):Play()
    v32.Completed:wait()
    wait(0.125)
end
function tbl_upv_4.new(a1)
    --[[
      name: new
      line: 310
      upvalues:
        tbl_upv_4 (copy, index: 1)
    ]]
    local v33 = setmetatable({}, tbl_upv_4)
    v33.DisplayModel = v33:NewDisplayModel(a1)
    return v33
end
local u15 = Instance.new("Animation")
u15.AnimationId = "rbxassetid://2874840706"
local u16 = nil
local function getFailureAnimationTrack(a1)
    --[[
      name: getFailureAnimationTrack
      line: 324
      upvalues:
        u16 (ref,  index: 1)
        u15 (copy, index: 2)
    ]]
    if a1 ~= nil then
        u16 = a1:LoadAnimation(u15)
        assert(u16, "")
        u16.Priority = Enum.AnimationPriority.Action
        u16.Looped = false
    end
    return u16
end
local function findPlayerHumanoid()
    --[[
      name: findPlayerHumanoid
      line: 335
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
    ]]
    local Character_1 = LocalPlayer_upv_1.Character
    if Character_1 then
        return Character_1:FindFirstChildOfClass("Humanoid")
    end
end
local function getTrailDotScale(a1, a2)
    --[[
      name: getTrailDotScale
      line: 367
    ]]
    return a2 * (((math.clamp(a1 - 10, 0, 90) / 90) * 1.5) + 1)
end
local u17 = 0
local function createTrailDots(a1, a2)
    --[[
      name: createTrailDots
      line: 342
      upvalues:
        tbl_upv_2 (copy, index: 1)
        tbl_upv_3 (copy, index: 2)
    ]]
    local tbl_6 = {}
    local v34 = 1
    for n_1 = 1, #a1 - 1 do
        local v35 = (a1[n_1].Position - a1[#a1].Position).Magnitude < 3
        if not v35 and n_1 % 2 == 0 then
            tbl_6[v34] = tbl_upv_2.new(a1[n_1].Position, n_1)
            v34 = v34 + 1
        end
    end
    table.insert(tbl_6, (tbl_upv_3.new(a1[#a1].Position, #a1, a2)))
    local tbl_7 = {}
    local v36 = 1
    v34 = v36
    for n_2 = #tbl_6, 1, -1 do
        tbl_7[v34] = tbl_6[n_2]
        v34 = v34 + 1
    end
    return tbl_7
end
function tbl_1.CreatePathDisplay(a1, a2)
    --[[
      name: CreatePathDisplay
      line: 376
      upvalues:
        u17 (ref,  index: 1)
        createTrailDots (copy, index: 2)
        RunService_upv_1 (copy, index: 3)
        Workspace_upv_1 (copy, index: 4)
        u10 (ref,  index: 5)
    ]]
    u17 = u17 + 1
    local u18 = createTrailDots(a1, a2)
    local u19 = "ClickToMoveResizeTrail" .. u17
    local function resizeTrailDots()
        --[[
          name: resizeTrailDots
          line: 394
          upvalues:
            u18 (copy, index: 1)
            RunService_upv_1 (copy, index: 2)
            u19 (copy, index: 3)
            Workspace_upv_1 (copy, index: 4)
            u10 (ref,  index: 5)
        ]]
        if #u18 ~= 0 then
            local p_1 = Workspace_upv_1.CurrentCamera.CFrame.p
            for n_3 = 1, #u18 do
                local TrailDotImage_1 = u18[n_3].DisplayModel:FindFirstChild("TrailDotImage")
                if TrailDotImage_1 then
                    TrailDotImage_1.Size = u10 * (((math.clamp((u18[n_3].DisplayModel.Position - p_1).Magnitude - 10, 0, 90) / 90) * 1.5) + 1)
                end
            end
        else
            RunService_upv_1:UnbindFromRenderStep(u19)
        end
    end
    RunService_upv_1:BindToRenderStep(u19, Enum.RenderPriority.Camera.Value - 1, resizeTrailDots)
    local function removePathBeforePoint(a3)
        --[[
          name: removePathBeforePoint
          line: 380
          upvalues:
            u18 (copy, index: 1)
        ]]
        for n_4 = #u18, 1, -1 do
            local v37 = u18[n_4]
            if v37.ClosestWayPoint <= a3 then
                v37:Destroy()
                u18[n_4] = nil
                continue
            else
                break
            end
        end
    end
    local function removePath()
        --[[
          name: removePath
          line: 410
          upvalues:
            removePathBeforePoint (copy, index: 1)
            a1 (copy, index: 2)
        ]]
        removePathBeforePoint(#a1)
    end
    return removePath, removePathBeforePoint
end
local u20 = nil
function tbl_1.DisplayFailureWaypoint(a1)
    --[[
      name: DisplayFailureWaypoint
      line: 418
      upvalues:
        u20 (ref,  index: 1)
        tbl_upv_4 (copy, index: 2)
    ]]
    if u20 then
        u20:Hide()
    end
    local u21 = tbl_upv_4.new(a1)
    u20 = u21
    coroutine.wrap(
        function()
            --[[
              line: 424
              upvalues:
                u21 (ref, index: 1)
            ]]
            u21:RunFailureTween()
            u21:Destroy()
            u21 = nil
        end
    )()
end
function tbl_1.CreateEndWaypoint(a1)
    --[[
      name: CreateEndWaypoint
      line: 431
      upvalues:
        tbl_upv_3 (copy, index: 1)
    ]]
    return tbl_upv_3.new(a1)
end
function tbl_1.PlayFailureAnimation()
    --[[
      name: PlayFailureAnimation
      line: 435
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        u16 (ref,  index: 2)
        u15 (copy, index: 3)
    ]]
    local Character_2 = LocalPlayer_upv_1.Character
    local v38
    if Character_2 then
        v38 = Character_2:FindFirstChildOfClass("Humanoid")
    else
        v38 = nil
    end
    if not v38 then
        return
    end
    if v38 ~= nil then
        u16 = v38:LoadAnimation(u15)
        assert(u16, "")
        u16.Priority = Enum.AnimationPriority.Action
        u16.Looped = false
    end
    u16:Play()
end
function tbl_1.CancelFailureAnimation()
    --[[
      name: CancelFailureAnimation
      line: 443
      upvalues:
        u16 (ref, index: 1)
    ]]
    if u16 == nil or not u16.IsPlaying then
        return
    end
    u16:Stop()
end
function tbl_1.SetWaypointTexture(a1)
    --[[
      name: SetWaypointTexture
      line: 449
      upvalues:
        u1 (ref,  index: 1)
        u11 (ref,  index: 2)
        u12 (ref,  index: 3)
        u13 (ref,  index: 4)
        CreateWaypointTemplates (copy, index: 5)
    ]]
    u1 = a1
    u11, u12, u13 = CreateWaypointTemplates()
end
function tbl_1.GetWaypointTexture()
    --[[
      name: GetWaypointTexture
      line: 454
      upvalues:
        u1 (ref, index: 1)
    ]]
    return u1
end
function tbl_1.SetWaypointRadius(a1)
    --[[
      name: SetWaypointRadius
      line: 458
      upvalues:
        u10 (ref,  index: 1)
        u11 (ref,  index: 2)
        u12 (ref,  index: 3)
        u13 (ref,  index: 4)
        CreateWaypointTemplates (copy, index: 5)
    ]]
    u10 = Vector2.new(a1, a1)
    u11, u12, u13 = CreateWaypointTemplates()
end
function tbl_1.GetWaypointRadius()
    --[[
      name: GetWaypointRadius
      line: 463
      upvalues:
        u10 (ref, index: 1)
    ]]
    return u10.X
end
function tbl_1.SetEndWaypointTexture(a1)
    --[[
      name: SetEndWaypointTexture
      line: 467
      upvalues:
        u2 (ref,  index: 1)
        u11 (ref,  index: 2)
        u12 (ref,  index: 3)
        u13 (ref,  index: 4)
        CreateWaypointTemplates (copy, index: 5)
    ]]
    u2 = a1
    u11, u12, u13 = CreateWaypointTemplates()
end
function tbl_1.GetEndWaypointTexture()
    --[[
      name: GetEndWaypointTexture
      line: 472
      upvalues:
        u2 (ref, index: 1)
    ]]
    return u2
end
function tbl_1.SetWaypointsAlwaysOnTop(a1)
    --[[
      name: SetWaypointsAlwaysOnTop
      line: 476
      upvalues:
        u3 (ref,  index: 1)
        u11 (ref,  index: 2)
        u12 (ref,  index: 3)
        u13 (ref,  index: 4)
        CreateWaypointTemplates (copy, index: 5)
    ]]
    u3 = a1
    u11, u12, u13 = CreateWaypointTemplates()
end
function tbl_1.GetWaypointsAlwaysOnTop()
    --[[
      name: GetWaypointsAlwaysOnTop
      line: 481
      upvalues:
        u3 (ref, index: 1)
    ]]
    return u3
end
return tbl_1