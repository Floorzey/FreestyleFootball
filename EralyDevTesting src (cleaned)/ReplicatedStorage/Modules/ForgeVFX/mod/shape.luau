local utility = require("./utility")
local shape = {
    getSurfaceCFrame = function(argument, argument_2: vector, argument_3: vector)
        local dot_product = argument_2:Dot(Vector3.new(0, 1, 0))
        local vector = math.abs(dot_product) > 0.99 and Vector3.new(0, 0, 1) or Vector3.new(0, 1, 0)
        local look_at_result = CFrame.lookAt(Vector3.new(0, 0, 0), argument_2, vector)

        return argument * CFrame.new(argument_3) * look_at_result
    end,
}

function shape.getPointWithinBox(argument: number, argument_2, argument_3: vector, argument_4: any)
    debug.profilebegin("getPointWithinBox")
    local random = Random.new(argument)
    local next_number_result = random:NextNumber(-1, 1)
    local next_number_result_2 = random:NextNumber(-1, 1)
    local product = Vector3.new(next_number_result, next_number_result_2, random:NextNumber(-1, 1)) * (argument_3 / 2)
    local surface_c_frame = shape.getSurfaceCFrame(argument_2, Vector3.FromNormalId(argument_4), product)
    debug.profileend()

    return surface_c_frame
end

function shape.getPointOnBox(argument: number, argument_2, argument_3: vector, argument_4: any)
    debug.profilebegin("getPointOnBox")
    local random = Random.new(argument)
    local from_normal_id_result = Vector3.FromNormalId(argument_4)
    local quotient = argument_3 / 2
    local difference = Vector3.new(1, 1, 1) - from_normal_id_result:Abs()
    local next_number_result = random:NextNumber(-1, 1)
    local next_number_result_2 = random:NextNumber(-1, 1)
    local product = Vector3.new(next_number_result, next_number_result_2, random:NextNumber(-1, 1))
        * quotient
        * difference
    local surface_c_frame =
        shape.getSurfaceCFrame(argument_2, from_normal_id_result, product + from_normal_id_result * quotient)
    debug.profileend()

    return surface_c_frame
end

function shape.getPointWithinCylinder(
    argument: number,
    argument_2: number,
    argument_3: number,
    product,
    vector: vector,
    argument_4: any
)
    debug.profilebegin("getPointWithinCylinder")
    local random = Random.new(argument)
    local next_number_result = random:NextNumber(argument_2, 1)
    local sqrt_result = math.sqrt(next_number_result)
    local next_number_result_2 = random:NextNumber(0, 6.283185307179586)

    if argument_4 == Enum.NormalId.Left or argument_4 == Enum.NormalId.Right then
        product *= CFrame.fromOrientation(0, 1.5707963267948966 * (argument_4 == Enum.NormalId.Right and -1 or 1), 0)
        vector = Vector3.new(vector.Z, vector.Y, vector.X)
    elseif argument_4 == Enum.NormalId.Front or argument_4 == Enum.NormalId.Back then
        product *= CFrame.fromOrientation(0, 3.141592653589793, 0)
    end

    local difference = 1 - random:NextNumber() ^ utility.lerp(0.5, 1, (math.sqrt(argument_3)))
    local interpolated_value = utility.lerp(1, argument_3, difference)
    local product_2 = sqrt_result * math.sin(next_number_result_2) * interpolated_value
    local product_3 = sqrt_result * math.cos(next_number_result_2) * interpolated_value
    local quotient = Vector3.new(difference * 2 - 1, product_2, product_3) * vector / 2
    local product_4 = math.sin(next_number_result_2) * interpolated_value
    local product_5 = math.cos(next_number_result_2) * interpolated_value
    local quotient_2 = Vector3.new(0, product_4, product_5) * vector / 2
    local product_6 = math.cos(next_number_result_2) * interpolated_value
    local product_7 = -math.sin(next_number_result_2) * interpolated_value
    local vector_2 = Vector3.new(0, product_6, product_7) * vector / 2
    local unit = vector_2.Magnitude > 0.001 and vector_2.Unit or product.UpVector
    local product_8 = product * CFrame.new(quotient) * CFrame.lookAt(Vector3.new(0, 0, 0), quotient_2, unit)
    debug.profileend()

    return product_8
end

function shape.getPointWithinSphere(
    argument: number,
    argument_2: number,
    argument_3: number,
    argument_4,
    vector: vector,
    argument_5: any
)
    debug.profilebegin("getPointWithinSphere")
    local random = Random.new(argument)
    local next_number_result = random:NextNumber()
    local next_number_result_2 = random:NextNumber()
    local product = next_number_result * 2 * 3.141592653589793
    local product_2 = math.acos(2 * next_number_result_2 - 1) * argument_3
    local power = random:NextNumber(argument_2, 1) ^ 0.3333333333333333
    local sine = math.sin(product)
    local cosine = math.cos(product)
    local sine_2 = math.sin(product_2)
    local cosine_2 = math.cos(product_2)
    local from_normal_id_result = Vector3.FromNormalId(argument_5)

    if argument_5 == Enum.NormalId.Left or argument_5 == Enum.NormalId.Right then
        vector = Vector3.new(vector.Z, vector.Y, vector.X)
    elseif argument_5 == Enum.NormalId.Top or argument_5 == Enum.NormalId.Bottom then
        vector = Vector3.new(vector.X, vector.Z, vector.Y)
    end

    local quotient = vector / 2
    local surface_c_frame = shape.getSurfaceCFrame(argument_4, from_normal_id_result, Vector3.new(0, 0, 0))
    local product_3 = Vector3.new(power * sine_2 * cosine, power * sine_2 * sine, power * cosine_2) * quotient
    local vector_2 = Vector3.new(-sine_2 * sine, sine_2 * cosine, 0) * quotient
    local unit = vector_2.Magnitude <= 0.001 and Vector3.new(1, 0, 0) or vector_2.Unit
    local product_4 = surface_c_frame
        * CFrame.Angles(0, 3.141592653589793, 0)
        * CFrame.new(product_3)
        * CFrame.lookAt(Vector3.new(0, 0, 0), product_3, unit)
    debug.profileend()

    return product_4
end

function shape.getPointWithinDisc(
    argument: number,
    argument_2: number,
    argument_3: number,
    argument_4,
    argument_5: vector,
    argument_6: any
)
    debug.profilebegin("getPointWithinDisc")
    local random = Random.new(argument)
    local from_normal_id_result = Vector3.FromNormalId(argument_6)
    local difference = Vector3.new(1, 1, 1) - from_normal_id_result:Abs() * argument_2
    local quotient = argument_5 / 2
    local next_number_result = random:NextNumber(argument_2, 1)
    local interpolated_value = utility.lerp(1, 0.5, argument_3 ^ 4)
    local power = random:NextNumber(1 - argument_3, 1) ^ interpolated_value
    local next_number_result_2 = random:NextNumber(0, 6.283185307179586)
    local product = power * math.sin(next_number_result_2)
    local product_2 = power * math.cos(next_number_result_2)
    local vector = Vector3.new(next_number_result * 2 - 1, product, product_2)

    if argument_6 == Enum.NormalId.Bottom or argument_6 == Enum.NormalId.Top then
        vector = Vector3.new(vector.Z, vector.X, vector.Y)
    elseif argument_6 == Enum.NormalId.Front or argument_6 == Enum.NormalId.Back then
        vector = Vector3.new(vector.Y, vector.Z, vector.X)
    end

    local surface_c_frame = shape.getSurfaceCFrame(
        argument_4,
        from_normal_id_result,
        vector * (quotient * difference) + from_normal_id_result * argument_2 * quotient
    )
    debug.profileend()

    return surface_c_frame
end

return shape
