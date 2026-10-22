local run_service = game:GetService("RunService")
local logger = require("./logger")
local utility = require("./utility")
local bezier = require("../obj/Bezier")
local tween = {
    bezier_cache = {},
}

function tween.fromParams(
    encoded_bezier_path: string,
    duration: number,
    on_step: (...any) -> ...any,
    parent_connection: userdata?,
    on_complete: ((...any) -> ...any)?,
    skip_initial_step: boolean?,
    render_priority: number?
)
    local bezier_curve = tween.bezier_cache[encoded_bezier_path]

    if not bezier_curve then
        local success, result = pcall(function()
            return utility.deserializePath(encoded_bezier_path)
        end)

        if not success then
            logger.error(`failed to decode bezier path data with error: {result}`)
        end

        bezier_curve = bezier.new(result, 0)
        tween.bezier_cache[encoded_bezier_path] = bezier_curve
    end

    local elapsed_time = 0
    local disconnect = nil

    local function step(delta_time)
        if not skip_initial_step and elapsed_time == 0 then
            local maximum = math.max(duration, 0)
            elapsed_time = math.clamp(elapsed_time + delta_time, 0, maximum)
        end

        local time_step =
            on_step(1 - bezier_curve:getEase((math.clamp(elapsed_time / duration, 0, 1))).y, delta_time, elapsed_time)

        if time_step == nil then
            if not (parent_connection and parent_connection.Connected) then
                disconnect()

                if on_complete then
                    on_complete(true)
                end

                return
            end
        else
            local condition

            if duration == 0 then
                condition = duration < elapsed_time
            else
                condition = duration <= elapsed_time
            end

            if condition and not (parent_connection and parent_connection.Connected) then
                disconnect()

                if on_complete then
                    on_complete(true)
                end

                return
            end
        end

        if time_step then
            local maximum_2 = math.max(duration, 0.001)
            elapsed_time = math.clamp(elapsed_time + time_step, 0, maximum_2)
        end
    end

    if not render_priority then
        local connection = run_service.RenderStepped:Connect(step)

        disconnect = function()
            connection:Disconnect()
        end

        return connection
    end

    local random_id = utility.getRandomId()
    run_service:BindToRenderStep(random_id, render_priority, step)
    local connected = true

    disconnect = function()
        if not connected then
            return
        end

        connected = false
        run_service:UnbindFromRenderStep(random_id)
    end

    return disconnect
end

function tween.timer(
    duration: number,
    on_step: (...any) -> ...any,
    parent_connection: userdata?,
    cleanup_callbacks: table?,
    render_priority: number?
)
    local running_result = coroutine.running()
    local elapsed_time = 0
    local disconnect = nil

    local function step(delta_time)
        local time_step = on_step(delta_time, elapsed_time)

        if time_step == nil then
            if not (parent_connection and parent_connection.Connected) then
                disconnect()
                task.spawn(running_result)

                return
            end
        else
            local condition

            if duration == 0 then
                condition = duration < elapsed_time
            else
                condition = duration <= elapsed_time
            end

            if condition and not (parent_connection and parent_connection.Connected) then
                disconnect()
                task.spawn(running_result)

                return
            end
        end

        if time_step then
            local maximum = math.max(duration, 0.001)
            elapsed_time = math.clamp(elapsed_time + time_step, 0, maximum)
        end
    end

    if render_priority then
        local random_id = utility.getRandomId()
        run_service:BindToRenderStep(random_id, render_priority, step)
        local connected = true

        disconnect = function()
            if not connected then
                return
            end

            connected = false
            run_service:UnbindFromRenderStep(random_id)
        end
    else
        local connection = run_service.RenderStepped:Connect(step)

        disconnect = function()
            connection:Disconnect()
        end
    end

    if cleanup_callbacks then
        table.insert(cleanup_callbacks, disconnect)
    end

    coroutine.yield()
end

return tween
