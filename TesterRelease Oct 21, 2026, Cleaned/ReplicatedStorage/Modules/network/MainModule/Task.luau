local value = nil
local task_2 = {}
local items = {}
task_2.Type = "Task"

function task_2.Spawn(argument, argument_2, ...)
    return task.spawn(table.remove(items) or task.spawn(value), argument_2, ...)
end

function task_2.Defer(argument, argument_2, ...)
    return task.defer(table.remove(items) or task.spawn(value), argument_2, ...)
end

function task_2.Delay(argument, argument_2, argument_3, ...)
    return task.delay(argument_2, table.remove(items) or task.spawn(value), argument_3, ...)
end

local function call(callback: (...any) -> ...any, ...)
    callback(...)
    table.insert(items, coroutine.running())
end

value = function()
    while true do
        call(coroutine.yield())
    end
end

return task_2
