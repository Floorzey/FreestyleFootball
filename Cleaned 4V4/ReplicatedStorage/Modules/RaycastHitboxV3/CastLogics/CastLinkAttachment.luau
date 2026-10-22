local cast_link_attachment = {}
local debugger = require(script.Parent.Debug.Debugger)

function cast_link_attachment.solve(argument, argument_2, argument_3)
    if argument_3 then
        debugger(
            argument_2.Attachment.WorldPosition - argument_2.Attachment0.WorldPosition,
            CFrame.new(argument_2.Attachment.WorldPosition, argument_2.Attachment0.WorldPosition)
        )
    end

    return argument_2.Attachment.WorldPosition,
        argument_2.Attachment0.WorldPosition - argument_2.Attachment.WorldPosition
end

function cast_link_attachment.lastPosition(argument, argument_2)
    argument_2.LastPosition = argument_2.Attachment.WorldPosition
end

return cast_link_attachment
