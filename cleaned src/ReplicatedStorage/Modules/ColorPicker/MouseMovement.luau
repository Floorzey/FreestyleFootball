local user_input_service = game:GetService("UserInputService")
local mouse_movement = {}
mouse_movement.__index = mouse_movement

function mouse_movement.new(callback_func)
    local instance = setmetatable({}, mouse_movement)
    instance.CallbackFunc = callback_func
    instance.Connected = false
    return instance
end

function mouse_movement.Connect(connection, ...)
    if connection.Connected then
        return
    end
    connection.Connected = true
    local values = { ... }
    connection.CallbackFunc(...)
    connection._mouseMovement = user_input_service.InputChanged:Connect(function(input)
        if
            input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch
        then
            return
        end
        connection.CallbackFunc(table.unpack(values))
    end)
    connection._mouseUp = user_input_service.InputEnded:Connect(function(input)
        if
            input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch
        then
            return
        end
        if connection.DisconnectCallback then
            connection.DisconnectCallback()
        end
        connection:Disconnect()
    end)
end

function mouse_movement.Disconnect(self)
    self.Connected = false
    if self._mouseMovement then
        self._mouseMovement:Disconnect()
        self._mouseMovement = nil
    end
    if not self._mouseUp then
        return
    end
    self._mouseUp:Disconnect()
    self._mouseUp = nil
end

function mouse_movement.OnDisconnect(self, disconnect_callback)
    self.DisconnectCallback = disconnect_callback
end

function mouse_movement.Destroy(connection)
    connection:Disconnect()
end

return mouse_movement
