local cast_link_attachment = {}
local debugger = require(script.Parent.Debug.Debugger)

function cast_link_attachment.solve(self, argument, argument_2)
    if argument_2 then
        debugger(
            argument.Attachment.WorldPosition - argument.Attachment0.WorldPosition,
            CFrame.new(argument.Attachment.WorldPosition, argument.Attachment0.WorldPosition)
        )
    end
    return argument.Attachment.WorldPosition, argument.Attachment0.WorldPosition - argument.Attachment.WorldPosition
end

function cast_link_attachment.lastPosition(self, argument)
    argument.LastPosition = argument.Attachment.WorldPosition
end

return cast_link_attachment
