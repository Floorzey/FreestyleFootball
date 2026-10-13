local cast_vector_point = {}
local debugger = require(script.Parent.Debug.Debugger)

function cast_vector_point.solve(self, argument, argument_2)
    local last_position_3 = argument.RelativePart.Position
        + argument.RelativePart.CFrame:VectorToWorldSpace(argument.Attachment)
    if not argument.LastPosition then
        argument.LastPosition = last_position_3
    end
    if argument_2 then
        debugger(last_position_3 - argument.LastPosition, CFrame.new(last_position_3, argument.LastPosition))
    end
    local last_position = argument.LastPosition
    local last_position_2 = (argument.LastPosition and argument.LastPosition) or (Vector3.new())
    return last_position, last_position_3 - last_position_2, last_position_3
end

function cast_vector_point.lastPosition(self, argument, last_position)
    argument.LastPosition = last_position
end

return cast_vector_point
