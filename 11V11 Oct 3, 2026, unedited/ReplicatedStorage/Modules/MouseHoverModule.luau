--[[
    Script Path: Game/ReplicatedStorage/Modules/MouseHoverModule
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local v1 = game.Players.LocalPlayer or (game.Players:GetPropertyChangedSignal("LocalPlayer"))
local u1 = v1:GetMouse()
local tbl_upv_1 = {}
local function IsInFrame(a1)
    --[[
      name: IsInFrame
      line: 8
      upvalues:
        u1 (copy, index: 1)
    ]]
    local X_1 = u1.X
    local Y_1 = u1.Y
    if a1.AbsolutePosition.X < X_1 and a1.AbsolutePosition.Y < Y_1 and X_1 < a1.AbsolutePosition.X + a1.AbsoluteSize.X and Y_1 < a1.AbsolutePosition.Y + a1.AbsoluteSize.Y then
        return true
    end
    return false
end
local function CheckMouseExited(a1)
    --[[
      name: CheckMouseExited
      line: 20
    ]]
    if (a1.MouseIsInFrame) or not a1.MouseWasIn then
        return
    end
    a1.MouseWasIn = false
    a1.LeaveEvent:Fire()
end
local function CheckMouseEntered(a1)
    --[[
      name: CheckMouseEntered
      line: 29
    ]]
    if not a1.MouseIsInFrame or (a1.MouseWasIn) then
        return
    end
    a1.MouseWasIn = true
    a1.EnteredEvent:Fire()
end
game:GetService("RunService").Heartbeat:Connect(
    function()
        --[[
          line: 36
          upvalues:
            tbl_upv_1 (copy, index: 1)
            u1 (copy, index: 2)
        ]]
        local v2 = nil
        for _, value_1 in pairs(tbl_upv_1) do
            local UIObj_1 = value_1.UIObj
            local X_2 = u1.X
            local Y_2 = u1.Y
            if UIObj_1.AbsolutePosition.X < X_2 and UIObj_1.AbsolutePosition.Y < Y_2 and X_2 < UIObj_1.AbsolutePosition.X + UIObj_1.AbsoluteSize.X and Y_2 < UIObj_1.AbsolutePosition.Y + UIObj_1.AbsoluteSize.Y then
                v2 = true
            else
                v2 = false
            end
            value_1.MouseIsInFrame = v2
            if value_1.MouseIsInFrame then
                continue
            end
            if value_1.MouseWasIn then
                value_1.MouseWasIn = false
                value_1.LeaveEvent:Fire()
            end
        end
        for _, value_2 in pairs(tbl_upv_1) do
            if not (value_2.MouseIsInFrame) then
                continue
            end
            if not (value_2.MouseWasIn) then
                value_2.MouseWasIn = true
                value_2.EnteredEvent:Fire()
            end
        end
    end
)
local tbl_2 = {}
function tbl_2.MouseEnterLeaveEvent(a1)
    --[[
      name: MouseEnterLeaveEvent
      line: 54
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if tbl_upv_1[a1] then
        return tbl_upv_1[a1].EnteredEvent.Event, tbl_upv_1[a1].LeaveEvent.Event
    end
    local u2 = Instance.new("BindableEvent")
    local u3 = Instance.new("BindableEvent")
    tbl_upv_1[a1] = {UIObj = a1, EnteredEvent = u2, LeaveEvent = u3, MouseWasIn = false}
    a1.AncestryChanged:Connect(
        function()
            --[[
              line: 71
              upvalues:
                a1 (copy, index: 1)
                u2 (copy, index: 2)
                u3 (copy, index: 3)
                tbl_upv_1 (copy, index: 4)
            ]]
            if (a1.Parent) then
                return
            end
            u2:Destroy()
            u3:Destroy()
            tbl_upv_1[a1] = nil
        end
    )
    return u2.Event, u3.Event
end
return tbl_2