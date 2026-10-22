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
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        then
            connection.CallbackFunc(table.unpack(values))
        end
    end)
    connection._mouseUp = user_input_service.InputEnded:Connect(function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            if connection.DisconnectCallback then
                connection.DisconnectCallback()
            end

            connection:Disconnect()
        end
    end)
end

function mouse_movement.Disconnect(argument)
    argument.Connected = false

    if argument._mouseMovement then
        argument._mouseMovement:Disconnect()
        argument._mouseMovement = nil
    end

    if argument._mouseUp then
        argument._mouseUp:Disconnect()
        argument._mouseUp = nil
    end
end

function mouse_movement.OnDisconnect(argument, disconnect_callback)
    argument.DisconnectCallback = disconnect_callback
end

function mouse_movement.Destroy(connection)
    connection:Disconnect()
end

return mouse_movement
