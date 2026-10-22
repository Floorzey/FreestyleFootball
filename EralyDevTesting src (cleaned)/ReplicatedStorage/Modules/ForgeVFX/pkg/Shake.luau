local run_service = game:GetService("RunService")
local random = Random.new()
local number = 0
local instance = {}
instance.__index = instance

function instance.new()
    local instance_2 = setmetatable({}, instance)
    instance_2.Amplitude = 1
    instance_2.Frequency = 1
    instance_2.FadeInTime = 1
    instance_2.FadeOutTime = 1
    instance_2.SustainTime = 0
    instance_2.Sustain = false
    instance_2.PositionInfluence = Vector3.new(1, 1, 1)
    instance_2.RotationInfluence = Vector3.new(1, 1, 1)
    local time_function

    if run_service:IsRunning() then
        time_function = time
    else
        time_function = os.clock
    end

    instance_2.TimeFunction = time_function
    instance_2._timeOffset = random:NextNumber(-1000000, 1000000)
    instance_2._startTime = 0
    instance_2._running = false
    instance_2._signalConnections = {}
    instance_2._renderBindings = {}

    return instance_2
end

function instance.InverseSquare(argument: vector, argument_2: number)
    local number_2 = argument_2 < 1 and 1 or argument_2

    return argument * (1 / (number_2 * number_2))
end

function instance.NextRenderName()
    number = number + 1

    return ("__shake_%.4i__"):format(number)
end

function instance.Start(argument)
    argument._startTime = argument.TimeFunction()
    argument._running = true
end

function instance.Stop(argument)
    argument._running = false

    for _, item in argument._renderBindings do
        run_service:UnbindFromRenderStep(item)
    end

    table.clear(argument._renderBindings)

    for _, connection in argument._signalConnections do
        connection:Disconnect()
    end

    table.clear(argument._signalConnections)
end

function instance.IsShaking(argument)
    return argument._running
end

function instance.StopSustain(argument)
    local time_function_result = argument.TimeFunction()
    argument.Sustain = false
    argument.SustainTime = time_function_result - argument._startTime - argument.FadeInTime
end

function instance.Update(argument)
    local enabled = false
    local time_function_result = argument.TimeFunction()
    local difference = time_function_result - argument._startTime
    local remainder = (time_function_result + argument._timeOffset) / argument.Frequency % 10000
    local number_2 = 1
    local quotient = difference >= argument.FadeInTime and 1 or difference / argument.FadeInTime

    if not argument.Sustain and argument.FadeInTime + argument.SustainTime < difference then
        if argument.FadeOutTime == 0 then
            enabled = true
        else
            number_2 = 1 - (difference - argument.FadeInTime - argument.SustainTime) / argument.FadeOutTime

            if
                not argument.Sustain
                and argument.FadeInTime + argument.SustainTime + argument.FadeOutTime <= difference
            then
                enabled = true
            end
        end
    end

    local quotient_2 = math.noise(remainder, 0) / 2
    local quotient_3 = math.noise(0, remainder) / 2
    local quotient_4 = math.noise(remainder, remainder) / 2
    local product = Vector3.new(quotient_2, quotient_3, quotient_4) * argument.Amplitude * math.min(quotient, number_2)

    if enabled then
        argument:Stop()
    end

    return argument.PositionInfluence * product, argument.RotationInfluence * product, enabled
end

function instance.OnSignal(argument: table, signal: any, callback: (...any) -> ...any)
    local connection = signal:Connect(function()
        callback(argument:Update())
    end)
    table.insert(argument._signalConnections, connection)

    return connection
end

function instance.BindToRenderStep(
    argument: table,
    argument_2: string,
    argument_3: number,
    callback: (...any) -> ...any
)
    run_service:BindToRenderStep(argument_2, argument_3, function()
        callback(argument:Update())
    end)

    table.insert(argument._renderBindings, argument_2)
end

function instance.Clone(argument)
    local instance_2 = instance.new()

    for _, item in
        {
            "Amplitude",
            "Frequency",
            "FadeInTime",
            "FadeOutTime",
            "SustainTime",
            "Sustain",
            "PositionInfluence",
            "RotationInfluence",
            "TimeFunction",
        }
    do
        instance_2[item] = argument[item]
    end

    return instance_2
end

function instance.Destroy(argument)
    argument:Stop()
end

return {
    new = instance.new,
    InverseSquare = instance.InverseSquare,
    NextRenderName = instance.NextRenderName,
}
