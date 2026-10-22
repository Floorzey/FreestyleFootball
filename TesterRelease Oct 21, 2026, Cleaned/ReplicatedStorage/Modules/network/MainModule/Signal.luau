local task_2 = require(script.Parent.Task)
local values = {}
local connection = {}
values.__index = values
values.Type = "Signal"

function values.Connect(next, function_value)
    local next_2 = setmetatable({}, connection)
    next_2.Previous = next.Previous
    next_2.Next = next
    next_2.Once = false
    next_2.Function = function_value
    next.Previous.Next = next_2
    next.Previous = next_2

    return next_2
end

function values.Once(next, function_value)
    local next_2 = setmetatable({}, connection)
    next_2.Previous = next.Previous
    next_2.Next = next
    next_2.Once = true
    next_2.Function = function_value
    next.Previous.Next = next_2
    next.Previous = next_2

    return next_2
end

function values.Wait(next)
    local next_2 = setmetatable({}, connection)
    next_2.Previous = next.Previous
    next_2.Next = next
    next_2.Once = true
    next_2.Thread = coroutine.running()
    next.Previous.Next = next_2
    next.Previous = next_2

    return coroutine.yield()
end

function values.Fire(argument, ...)
    local next = argument.Next

    while next.Type == "Connection" do
        if next.Function then
            task_2:Defer(next.Function, ...)
        else
            task.defer(next.Thread, ...)
        end

        if next.Once then
            next.Previous.Next = next.Next
            next.Next.Previous = next.Previous
        end

        next = next.Next
    end
end

connection.__index = connection
connection.Type = "Connection"

function connection.Disconnect(argument)
    argument.Previous.Next = argument.Next
    argument.Next.Previous = argument.Previous
end

return function()
    local previous = setmetatable({}, values)
    previous.Previous = previous
    previous.Next = previous

    return previous
end
