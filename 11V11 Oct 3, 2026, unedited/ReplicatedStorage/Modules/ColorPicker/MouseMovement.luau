--[[
    Script Path: Game/ReplicatedStorage/Modules/ColorPicker/MouseMovement
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local UserInputService_upv_1 = game:GetService("UserInputService")
local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new(a1)
    --[[
      name: new
      line: 6
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v1 = setmetatable({}, tbl_upv_1)
    v1.CallbackFunc = a1
    v1.Connected = false
    return v1
end
function tbl_upv_1.Connect(a1, ...)
    --[[
      name: Connect
      line: 14
      upvalues:
        UserInputService_upv_1 (copy, index: 1)
    ]]
    if a1.Connected then
        return
    end
    a1.Connected = true
    local tbl_upv_2 = {...}
    a1.CallbackFunc(...)
    a1._mouseMovement = UserInputService_upv_1.InputChanged:Connect(
        function(a2)
            --[[
              line: 21
              upvalues:
                a1 (copy, index: 1)
                tbl_upv_2 (copy, index: 2)
            ]]
            if a2.UserInputType ~= Enum.UserInputType.MouseMovement and a2.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            a1.CallbackFunc(table.unpack(tbl_upv_2))
        end
    )
    a1._mouseUp = UserInputService_upv_1.InputEnded:Connect(
        function(a3)
            --[[
              line: 27
              upvalues:
                a1 (copy, index: 1)
            ]]
            if a3.UserInputType ~= Enum.UserInputType.MouseButton1 and a3.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            if a1.DisconnectCallback then
                a1.DisconnectCallback()
            end
            a1:Disconnect()
        end
    )
end
function tbl_upv_1.Disconnect(a1)
    --[[
      name: Disconnect
      line: 38
    ]]
    a1.Connected = false
    if a1._mouseMovement then
        a1._mouseMovement:Disconnect()
        a1._mouseMovement = nil
    end
    if not a1._mouseUp then
        return
    end
    a1._mouseUp:Disconnect()
    a1._mouseUp = nil
end
function tbl_upv_1.OnDisconnect(a1, a2)
    --[[
      name: OnDisconnect
      line: 51
    ]]
    a1.DisconnectCallback = a2
end
function tbl_upv_1.Destroy(a1)
    --[[
      name: Destroy
      line: 55
    ]]
    a1:Disconnect()
end
return tbl_upv_1