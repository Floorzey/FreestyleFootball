local s_rgb = {}

local function transform(argument: number)
    if argument < 0.04045 then
        return argument / 12.92
    end

    return ((argument + 0.055) / 1.055) ^ 2.4
end

local function inverse(argument: number)
    if argument < 0.0031308 then
        return argument * 12.92
    end

    return argument ^ 0.4166666666666667 * 1.055 - 0.055
end

function s_rgb.fromLinear(argument)
    local r = argument.R
    local product

    if r < 0.0031308 then
        product = r * 12.92
    else
        product = r ^ 0.4166666666666667 * 1.055 - 0.055
    end

    local g = argument.G
    local product_2

    if g < 0.0031308 then
        product_2 = g * 12.92
    else
        product_2 = g ^ 0.4166666666666667 * 1.055 - 0.055
    end

    local b = argument.B
    local product_3

    if b < 0.0031308 then
        product_3 = b * 12.92
    else
        product_3 = b ^ 0.4166666666666667 * 1.055 - 0.055
    end

    return Color3.new(product, product_2, product_3)
end

function s_rgb.toLinear(argument)
    local r = argument.R
    local quotient

    if r < 0.04045 then
        quotient = r / 12.92
    else
        quotient = ((r + 0.055) / 1.055) ^ 2.4
    end

    local g = argument.G
    local quotient_2

    if g < 0.04045 then
        quotient_2 = g / 12.92
    else
        quotient_2 = ((g + 0.055) / 1.055) ^ 2.4
    end

    local b = argument.B
    local quotient_3

    if b < 0.04045 then
        quotient_3 = b / 12.92
    else
        quotient_3 = ((b + 0.055) / 1.055) ^ 2.4
    end

    return Color3.new(quotient, quotient_2, quotient_3)
end

return s_rgb
