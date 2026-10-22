local s_rgb = require("../color/sRGB")
local oklab = {
    fromLinear = function(argument)
        local power = (argument.R * 0.4122214708 + argument.G * 0.5363325363 + argument.B * 0.0514459929)
            ^ 0.3333333333333333
        local power_2 = (argument.R * 0.2119034982 + argument.G * 0.6806995451 + argument.B * 0.1073969566)
            ^ 0.3333333333333333
        local power_3 = (argument.R * 0.0883024619 + argument.G * 0.2817188376 + argument.B * 0.6299787005)
            ^ 0.3333333333333333

        return Vector3.new(
            power * 0.2104542553 + power_2 * 0.793617785 - power_3 * 0.0040720468,
            power * 1.9779984951 - power_2 * 2.428592205 + power_3 * 0.4505937099,
            power * 0.0259040371 + power_2 * 0.7827717662 - power_3 * 0.808675766
        )
    end,
}

function oklab.fromSRGB(argument)
    return oklab.fromLinear(s_rgb.toLinear(argument))
end

function oklab.toLinear(argument: vector, argument_2: boolean?)
    local power = (argument.X + argument.Y * 0.3963377774 + argument.Z * 0.2158037573) ^ 3
    local power_2 = (argument.X - argument.Y * 0.1055613458 - argument.Z * 0.0638541728) ^ 3
    local power_3 = (argument.X - argument.Y * 0.0894841775 - argument.Z * 1.291485548) ^ 3
    local sum = power * 4.0767416621 - power_2 * 3.3077115913 + power_3 * 0.2309699292
    local difference = power * -1.2684380046 + power_2 * 2.6097574011 - power_3 * 0.3413193965
    local sum_2 = power * -0.0041960863 - power_2 * 0.7034186147 + power_3 * 1.707614701

    if not argument_2 then
        sum = math.clamp(sum, 0, 1)
        difference = math.clamp(difference, 0, 1)
        sum_2 = math.clamp(sum_2, 0, 1)
    end

    return Color3.new(sum, difference, sum_2)
end

function oklab.toSRGB(argument: vector, argument_2: boolean?)
    return s_rgb.fromLinear(oklab.toLinear(argument, argument_2))
end

return oklab
