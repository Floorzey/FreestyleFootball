local cast_attachment = {}
local debugger = require(script.Parent.Debug.Debugger)

function cast_attachment.solve(argument, argument_2, argument_3)
    if not argument_2.LastPosition then
        argument_2.LastPosition = argument_2.Attachment.WorldPosition
    end

    if argument_3 then
        debugger(
            argument_2.Attachment.WorldPosition - argument_2.LastPosition,
            CFrame.new(argument_2.Attachment.WorldPosition, argument_2.LastPosition)
        )
    end

    return argument_2.LastPosition, argument_2.Attachment.WorldPosition - argument_2.LastPosition
end

function cast_attachment.lastPosition(argument, argument_2)
    argument_2.LastPosition = argument_2.Attachment.WorldPosition
end

return cast_attachment
