local cast_vector_point = {}
local debugger = require(script.Parent.Debug.Debugger)

function cast_vector_point.solve(argument, argument_2, argument_3)
    local last_position = argument_2.RelativePart.Position
        + argument_2.RelativePart.CFrame:VectorToWorldSpace(argument_2.Attachment)

    if not argument_2.LastPosition then
        argument_2.LastPosition = last_position
    end

    if argument_3 then
        debugger(last_position - argument_2.LastPosition, CFrame.new(last_position, argument_2.LastPosition))
    end

    return argument_2.LastPosition,
        last_position - (argument_2.LastPosition and argument_2.LastPosition or Vector3.new()),
        last_position
end

function cast_vector_point.lastPosition(argument, argument_2, last_position)
    argument_2.LastPosition = last_position
end

return cast_vector_point
