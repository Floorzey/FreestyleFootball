local cast_attachment = {}
local debugger = require(script.Parent.Debug.Debugger)

function cast_attachment.solve(self, argument, argument_2)
    if not argument.LastPosition then
        argument.LastPosition = argument.Attachment.WorldPosition
    end
    if argument_2 then
        debugger(
            argument.Attachment.WorldPosition - argument.LastPosition,
            CFrame.new(argument.Attachment.WorldPosition, argument.LastPosition)
        )
    end
    return argument.LastPosition, argument.Attachment.WorldPosition - argument.LastPosition
end

function cast_attachment.lastPosition(self, argument)
    argument.LastPosition = argument.Attachment.WorldPosition
end

return cast_attachment
