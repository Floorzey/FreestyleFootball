local value = nil
local value_2 = nil
local buffer_length = nil
local buffer_offset = nil
local value_3 = nil
local instances_offset = nil
local types = {}
local reads = {}
local writes = {}
local values = {}
local values_2 = {}

local function allocate(argument: number)
    local sum = buffer_offset + argument

    if not (buffer_length < sum) then
        return
    end

    while buffer_length < sum do
        buffer_length = buffer_length * 2
    end

    local buffer_2 = buffer.create(buffer_length)
    buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
    value.Buffer = buffer_2
    value_2 = buffer_2
end

local function read_s8()
    local readi8_result = buffer.readi8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1

    return readi8_result
end

local function write_s8(argument: number)
    buffer.writei8(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 1
end

local function read_s16()
    local readi16_result = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2

    return readi16_result
end

local function write_s16(argument: number)
    buffer.writei16(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 2
end

local function read_s24()
    local difference = buffer.readbits(value_2, buffer_offset * 8, 24) - 8388608
    buffer_offset = buffer_offset + 3

    return difference
end

local function write_s24(argument: number)
    buffer.writebits(value_2, buffer_offset * 8, 24, argument + 8388608)
    buffer_offset = buffer_offset + 3
end

local function read_s32()
    local readi32_result = buffer.readi32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return readi32_result
end

local function write_s32(argument: number)
    buffer.writei32(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 4
end

local function read_u8()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1

    return readu8_result
end

local function write_u8(argument: number)
    buffer.writeu8(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 1
end

local function read_u16()
    local readu16_result = buffer.readu16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2

    return readu16_result
end

local function write_u16(argument: number)
    buffer.writeu16(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 2
end

local function read_u24()
    local readbits_result = buffer.readbits(value_2, buffer_offset * 8, 24)
    buffer_offset = buffer_offset + 3

    return readbits_result
end

local function write_u24(argument: number)
    buffer.writebits(value_2, buffer_offset * 8, 24, argument)
    buffer_offset = buffer_offset + 3
end

local function read_u32()
    local readu32_result = buffer.readu32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return readu32_result
end

local function write_u32(argument: number)
    buffer.writeu32(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 4
end

local function read_f32()
    local readf32_result = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return readf32_result
end

local function write_f32(argument: number)
    buffer.writef32(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 4
end

local function read_f64()
    local readf64_result = buffer.readf64(value_2, buffer_offset)
    buffer_offset = buffer_offset + 8

    return readf64_result
end

local function write_f64(argument: number)
    buffer.writef64(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 8
end

local function read_string(argument: number)
    local readstring_result = buffer.readstring(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + argument

    return readstring_result
end

local function write_string(argument: string)
    buffer.writestring(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + #argument
end

local function read_buffer(argument: number)
    local create_result = buffer.create(argument)
    buffer.copy(create_result, 0, value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + argument

    return create_result
end

local function write_buffer(argument: buffer)
    buffer.copy(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + buffer.len(argument)
end

local function read_instance()
    instances_offset = instances_offset + 1

    return value_3[instances_offset]
end

local function write_instance(argument)
    instances_offset = instances_offset + 1
    value_3[instances_offset] = argument
end

local function read_f16()
    local product = buffer_offset * 8
    buffer_offset = buffer_offset + 2
    local readbits_result = buffer.readbits(value_2, product + 0, 10)
    local readbits_result_2 = buffer.readbits(value_2, product + 10, 5)
    local readbits_result_3 = buffer.readbits(value_2, product + 15, 1)

    if readbits_result == 0 then
        if readbits_result_2 == 0 then
            return 0
        end

        if readbits_result_2 == 31 then
            return readbits_result_3 == 0 and (1 / 0) or (-1 / 0)
        end
    elseif readbits_result_2 == 31 then
        return 0 / 0
    end

    if readbits_result_3 == 0 then
        return (readbits_result / 1024 + 1) * 2 ^ (readbits_result_2 - 15)
    end

    return -(readbits_result / 1024 + 1) * 2 ^ (readbits_result_2 - 15)
end

local function write_f16(negated_value: number)
    local product = buffer_offset * 8
    buffer_offset = buffer_offset + 2

    if negated_value == 0 then
        buffer.writebits(value_2, product, 16, 0)

        return
    end

    if negated_value >= 65520 then
        buffer.writebits(value_2, product, 16, 31744)

        return
    end

    if negated_value <= -65520 then
        buffer.writebits(value_2, product, 16, 64512)

        return
    end

    if negated_value ~= negated_value then
        buffer.writebits(value_2, product, 16, 31745)

        return
    end

    local number

    if negated_value < 0 then
        negated_value = -negated_value
        number = 1
    else
        number = 0
    end

    local frexp_result, value_4 = math.frexp(negated_value)
    buffer.writebits(value_2, product + 0, 10, frexp_result * 2048 - 1023.5)
    buffer.writebits(value_2, product + 10, 5, value_4 + 14)
    buffer.writebits(value_2, product + 15, 1, number)
end

local function read_f24()
    local product = buffer_offset * 8
    buffer_offset = buffer_offset + 3
    local readbits_result = buffer.readbits(value_2, product + 0, 17)
    local readbits_result_2 = buffer.readbits(value_2, product + 17, 6)
    local readbits_result_3 = buffer.readbits(value_2, product + 23, 1)

    if readbits_result == 0 then
        if readbits_result_2 == 0 then
            return 0
        end

        if readbits_result_2 == 63 then
            return readbits_result_3 == 0 and (1 / 0) or (-1 / 0)
        end
    elseif readbits_result_2 == 63 then
        return 0 / 0
    end

    if readbits_result_3 == 0 then
        return (readbits_result / 131072 + 1) * 2 ^ (readbits_result_2 - 31)
    end

    return -(readbits_result / 131072 + 1) * 2 ^ (readbits_result_2 - 31)
end

local function write_f24(negated_value: number)
    local product = buffer_offset * 8
    buffer_offset = buffer_offset + 3

    if negated_value == 0 then
        buffer.writebits(value_2, product, 24, 0)

        return
    end

    if negated_value >= 4294959104 then
        buffer.writebits(value_2, product, 24, 8257536)

        return
    end

    if negated_value <= -4294959104 then
        buffer.writebits(value_2, product, 24, 16646144)

        return
    end

    if negated_value ~= negated_value then
        buffer.writebits(value_2, product, 24, 8257537)

        return
    end

    local number

    if negated_value < 0 then
        negated_value = -negated_value
        number = 1
    else
        number = 0
    end

    local frexp_result, value_4 = math.frexp(negated_value)
    buffer.writebits(value_2, product + 0, 17, frexp_result * 262144 - 131071.5)
    buffer.writebits(value_2, product + 17, 6, value_4 + 30)
    buffer.writebits(value_2, product + 23, 1, number)
end

types.Any = "Any"

function reads.Any()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1

    return values[readu8_result]()
end

function writes.Any(argument)
    values_2[typeof(argument)](argument)
end

types.Nil = "Nil"

function reads.Nil()
    return nil
end

function writes.Nil(argument: nil) end

types.NumberS8 = "NumberS8"

function reads.NumberS8()
    local readi8_result = buffer.readi8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1

    return readi8_result
end

function writes.NumberS8(argument: number)
    local sum = buffer_offset + 1

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writei8(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 1
end

types.NumberS16 = "NumberS16"

function reads.NumberS16()
    local readi16_result = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2

    return readi16_result
end

function writes.NumberS16(argument: number)
    local sum = buffer_offset + 2

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writei16(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 2
end

types.NumberS24 = "NumberS24"

function reads.NumberS24()
    local difference = buffer.readbits(value_2, buffer_offset * 8, 24) - 8388608
    buffer_offset = buffer_offset + 3

    return difference
end

function writes.NumberS24(argument: number)
    local sum = buffer_offset + 3

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writebits(value_2, buffer_offset * 8, 24, argument + 8388608)
    buffer_offset = buffer_offset + 3
end

types.NumberS32 = "NumberS32"

function reads.NumberS32()
    local readi32_result = buffer.readi32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return readi32_result
end

function writes.NumberS32(argument: number)
    local sum = buffer_offset + 4

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writei32(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 4
end

types.NumberU8 = "NumberU8"

function reads.NumberU8()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1

    return readu8_result
end

function writes.NumberU8(argument: number)
    local sum = buffer_offset + 1

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 1
end

types.NumberU16 = "NumberU16"

function reads.NumberU16()
    local readu16_result = buffer.readu16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2

    return readu16_result
end

function writes.NumberU16(argument: number)
    local sum = buffer_offset + 2

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu16(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 2
end

types.NumberU24 = "NumberU24"

function reads.NumberU24()
    local readbits_result = buffer.readbits(value_2, buffer_offset * 8, 24)
    buffer_offset = buffer_offset + 3

    return readbits_result
end

function writes.NumberU24(argument: number)
    local sum = buffer_offset + 3

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writebits(value_2, buffer_offset * 8, 24, argument)
    buffer_offset = buffer_offset + 3
end

types.NumberU32 = "NumberU32"

function reads.NumberU32()
    local readu32_result = buffer.readu32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return readu32_result
end

function writes.NumberU32(argument: number)
    local sum = buffer_offset + 4

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu32(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 4
end

types.NumberF16 = "NumberF16"

function reads.NumberF16()
    return read_f16()
end

function writes.NumberF16(negated_value: number)
    local sum = buffer_offset + 2

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    write_f16(negated_value)
end

types.NumberF24 = "NumberF24"

function reads.NumberF24()
    return read_f24()
end

function writes.NumberF24(negated_value: number)
    local sum = buffer_offset + 3

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    write_f24(negated_value)
end

types.NumberF32 = "NumberF32"

function reads.NumberF32()
    local readf32_result = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return readf32_result
end

function writes.NumberF32(argument: number)
    local sum = buffer_offset + 4

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writef32(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 4
end

types.NumberF64 = "NumberF64"

function reads.NumberF64()
    local readf64_result = buffer.readf64(value_2, buffer_offset)
    buffer_offset = buffer_offset + 8

    return readf64_result
end

function writes.NumberF64(argument: number)
    local sum = buffer_offset + 8

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writef64(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 8
end

types.String = "String"

function reads.String()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local readstring_result = buffer.readstring(value_2, buffer_offset, readu8_result)
    buffer_offset = buffer_offset + readu8_result

    return readstring_result
end

function writes.String(argument: string)
    local argument_count = #argument
    local sum = buffer_offset + (argument_count + 1)

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, argument_count)
    buffer_offset = buffer_offset + 1
    buffer.writestring(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + #argument
end

types.StringLong = "StringLong"

function reads.StringLong()
    local readu16_result = buffer.readu16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local readstring_result = buffer.readstring(value_2, buffer_offset, readu16_result)
    buffer_offset = buffer_offset + readu16_result

    return readstring_result
end

function writes.StringLong(argument: string)
    local argument_count = #argument
    local sum = buffer_offset + (argument_count + 2)

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu16(value_2, buffer_offset, argument_count)
    buffer_offset = buffer_offset + 2
    buffer.writestring(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + #argument
end

types.Buffer = "Buffer"

function reads.Buffer()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local create_result = buffer.create(readu8_result)
    buffer.copy(create_result, 0, value_2, buffer_offset, readu8_result)
    buffer_offset = buffer_offset + readu8_result

    return create_result
end

function writes.Buffer(argument: buffer)
    local length = buffer.len(argument)
    local sum = buffer_offset + (1 + length)

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, length)
    buffer_offset = buffer_offset + 1
    buffer.copy(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + buffer.len(argument)
end

types.BufferLong = "BufferLong"

function reads.BufferLong()
    local readu16_result = buffer.readu16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local create_result = buffer.create(readu16_result)
    buffer.copy(create_result, 0, value_2, buffer_offset, readu16_result)
    buffer_offset = buffer_offset + readu16_result

    return create_result
end

function writes.BufferLong(argument: buffer)
    local length = buffer.len(argument)
    local sum = buffer_offset + (2 + length)

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu16(value_2, buffer_offset, length)
    buffer_offset = buffer_offset + 2
    buffer.copy(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + buffer.len(argument)
end

types.Instance = "Instance"

function reads.Instance()
    instances_offset = instances_offset + 1

    return value_3[instances_offset]
end

function writes.Instance(argument: userdata)
    instances_offset = instances_offset + 1
    value_3[instances_offset] = argument
end

types.Boolean8 = "Boolean8"

function reads.Boolean8()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1

    return readu8_result == 1
end

function writes.Boolean8(argument: boolean)
    local sum = buffer_offset + 1

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, argument and 1 or 0)
    buffer_offset = buffer_offset + 1
end

types.NumberRange = "NumberRange"

function reads.NumberRange()
    local number_range_new = NumberRange.new
    local readf32_result = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_2 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return number_range_new(readf32_result, readf32_result_2)
end

function writes.NumberRange(argument)
    local sum = buffer_offset + 8

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writef32(value_2, buffer_offset, argument.Min)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Max)
    buffer_offset = buffer_offset + 4
end

types.BrickColor = "BrickColor"

function reads.BrickColor()
    local brick_color_new = BrickColor.new
    local readu16_result = buffer.readu16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2

    return brick_color_new(readu16_result)
end

function writes.BrickColor(argument: userdata)
    local sum = buffer_offset + 2

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu16(value_2, buffer_offset, argument.Number)
    buffer_offset = buffer_offset + 2
end

types.Color3 = "Color3"

function reads.Color3()
    local color3_from_rgb = Color3.fromRGB
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local readu8_result_2 = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local readu8_result_3 = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1

    return color3_from_rgb(readu8_result, readu8_result_2, readu8_result_3)
end

function writes.Color3(argument)
    local sum = buffer_offset + 3

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, argument.R * 255 + 0.5)
    buffer_offset = buffer_offset + 1
    buffer.writeu8(value_2, buffer_offset, argument.G * 255 + 0.5)
    buffer_offset = buffer_offset + 1
    buffer.writeu8(value_2, buffer_offset, argument.B * 255 + 0.5)
    buffer_offset = buffer_offset + 1
end

types.UDim = "UDim"

function reads.UDim()
    local u_dim_new = UDim.new
    local readi16_result = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local readi16_result_2 = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2

    return u_dim_new(readi16_result / 1000, readi16_result_2)
end

function writes.UDim(argument)
    local sum = buffer_offset + 4

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writei16(value_2, buffer_offset, argument.Scale * 1000)
    buffer_offset = buffer_offset + 2
    buffer.writei16(value_2, buffer_offset, argument.Offset)
    buffer_offset = buffer_offset + 2
end

types.UDim2 = "UDim2"

function reads.UDim2()
    local u_dim2_new = UDim2.new
    local readi16_result = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local readi16_result_2 = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local readi16_result_3 = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local readi16_result_4 = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2

    return u_dim2_new(readi16_result / 1000, readi16_result_2, readi16_result_3 / 1000, readi16_result_4)
end

function writes.UDim2(argument)
    local sum = buffer_offset + 8

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writei16(value_2, buffer_offset, argument.X.Scale * 1000)
    buffer_offset = buffer_offset + 2
    buffer.writei16(value_2, buffer_offset, argument.X.Offset)
    buffer_offset = buffer_offset + 2
    buffer.writei16(value_2, buffer_offset, argument.Y.Scale * 1000)
    buffer_offset = buffer_offset + 2
    buffer.writei16(value_2, buffer_offset, argument.Y.Offset)
    buffer_offset = buffer_offset + 2
end

types.Rect = "Rect"

function reads.Rect()
    local rect_new = Rect.new
    local readf32_result = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_2 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_3 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_4 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return rect_new(readf32_result, readf32_result_2, readf32_result_3, readf32_result_4)
end

function writes.Rect(argument)
    local sum = buffer_offset + 16

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writef32(value_2, buffer_offset, argument.Min.X)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Min.Y)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Max.X)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Max.Y)
    buffer_offset = buffer_offset + 4
end

types.Vector2S16 = "Vector2S16"

function reads.Vector2S16()
    local vector2_new = Vector2.new
    local readi16_result = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local readi16_result_2 = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2

    return vector2_new(readi16_result, readi16_result_2)
end

function writes.Vector2S16(argument)
    local sum = buffer_offset + 4

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writei16(value_2, buffer_offset, argument.X)
    buffer_offset = buffer_offset + 2
    buffer.writei16(value_2, buffer_offset, argument.Y)
    buffer_offset = buffer_offset + 2
end

types.Vector2F24 = "Vector2F24"

function reads.Vector2F24()
    return Vector2.new(read_f24(), (read_f24()))
end

function writes.Vector2F24(argument)
    local sum = buffer_offset + 6

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    write_f24(argument.X)
    write_f24(argument.Y)
end

types.Vector2F32 = "Vector2F32"

function reads.Vector2F32()
    local vector2_new = Vector2.new
    local readf32_result = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_2 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return vector2_new(readf32_result, readf32_result_2)
end

function writes.Vector2F32(argument)
    local sum = buffer_offset + 8

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writef32(value_2, buffer_offset, argument.X)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Y)
    buffer_offset = buffer_offset + 4
end

types.Vector3S16 = "Vector3S16"

function reads.Vector3S16()
    local readi16_result = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local readi16_result_2 = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local readi16_result_3 = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2

    return Vector3.new(readi16_result, readi16_result_2, readi16_result_3)
end

function writes.Vector3S16(argument: vector)
    local sum = buffer_offset + 6

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writei16(value_2, buffer_offset, argument.X)
    buffer_offset = buffer_offset + 2
    buffer.writei16(value_2, buffer_offset, argument.Y)
    buffer_offset = buffer_offset + 2
    buffer.writei16(value_2, buffer_offset, argument.Z)
    buffer_offset = buffer_offset + 2
end

types.Vector3F24 = "Vector3F24"

function reads.Vector3F24()
    local result = read_f24()
    local result_2 = read_f24()
    local result_3 = read_f24()

    return Vector3.new(result, result_2, result_3)
end

function writes.Vector3F24(argument: vector)
    local sum = buffer_offset + 9

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    write_f24(argument.X)
    write_f24(argument.Y)
    write_f24(argument.Z)
end

types.Vector3F32 = "Vector3F32"

function reads.Vector3F32()
    local readf32_result = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_2 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_3 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return Vector3.new(readf32_result, readf32_result_2, readf32_result_3)
end

function writes.Vector3F32(argument: vector)
    local sum = buffer_offset + 12

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writef32(value_2, buffer_offset, argument.X)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Y)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Z)
    buffer_offset = buffer_offset + 4
end

types.NumberU4 = "NumberU4"

function reads.NumberU4()
    local product = buffer_offset * 8
    buffer_offset = buffer_offset + 1

    return { buffer.readbits(value_2, product + 0, 4), buffer.readbits(value_2, product + 4, 4) }
end

function writes.NumberU4(argument: table)
    local sum = buffer_offset + 1

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    local product = buffer_offset * 8
    buffer_offset = buffer_offset + 1
    buffer.writebits(value_2, product + 0, 4, argument[1])
    buffer.writebits(value_2, product + 4, 4, argument[2])
end

types.BooleanNumber = "BooleanNumber"

function reads.BooleanNumber()
    local product = buffer_offset * 8
    buffer_offset = buffer_offset + 1

    return {
        Boolean = buffer.readbits(value_2, product + 0, 1) == 1,
        Number = buffer.readbits(value_2, product + 1, 7),
    }
end

function writes.BooleanNumber(argument: table)
    local sum = buffer_offset + 1

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    local product = buffer_offset * 8
    buffer_offset = buffer_offset + 1
    buffer.writebits(value_2, product + 0, 1, argument.Boolean and 1 or 0)
    buffer.writebits(value_2, product + 1, 7, argument.Number)
end

types.Boolean1 = "Boolean1"

function reads.Boolean1()
    local product = buffer_offset * 8
    buffer_offset = buffer_offset + 1

    return {
        buffer.readbits(value_2, product + 0, 1) == 1,
        buffer.readbits(value_2, product + 1, 1) == 1,
        buffer.readbits(value_2, product + 2, 1) == 1,
        buffer.readbits(value_2, product + 3, 1) == 1,
        buffer.readbits(value_2, product + 4, 1) == 1,
        buffer.readbits(value_2, product + 5, 1) == 1,
        buffer.readbits(value_2, product + 6, 1) == 1,
        buffer.readbits(value_2, product + 7, 1) == 1,
    }
end

function writes.Boolean1(argument: table)
    local sum = buffer_offset + 1

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    local product = buffer_offset * 8
    buffer_offset = buffer_offset + 1
    buffer.writebits(value_2, product + 0, 1, argument[1] and 1 or 0)
    buffer.writebits(value_2, product + 1, 1, argument[2] and 1 or 0)
    buffer.writebits(value_2, product + 2, 1, argument[3] and 1 or 0)
    buffer.writebits(value_2, product + 3, 1, argument[4] and 1 or 0)
    buffer.writebits(value_2, product + 4, 1, argument[5] and 1 or 0)
    buffer.writebits(value_2, product + 5, 1, argument[6] and 1 or 0)
    buffer.writebits(value_2, product + 6, 1, argument[7] and 1 or 0)
    buffer.writebits(value_2, product + 7, 1, argument[8] and 1 or 0)
end

types.CFrameF24U8 = "CFrameF24U8"

function reads.CFrameF24U8()
    local c_frame_from_euler_angles_xyz = CFrame.fromEulerAnglesXYZ
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local readu8_result_2 = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local readu8_result_3 = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local result = c_frame_from_euler_angles_xyz(
        readu8_result / 40.58451048843331,
        readu8_result_2 / 40.58451048843331,
        readu8_result_3 / 40.58451048843331
    )
    local result_2 = read_f24()
    local result_3 = read_f24()
    local result_4 = read_f24()

    return result + Vector3.new(result_2, result_3, result_4)
end

function writes.CFrameF24U8(argument)
    local to_euler_angles_xyz_result, value_4, value_5 = argument:ToEulerAnglesXYZ()
    local sum = buffer_offset + 12

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, to_euler_angles_xyz_result * 40.58451048843331 + 0.5)
    buffer_offset = buffer_offset + 1
    buffer.writeu8(value_2, buffer_offset, value_4 * 40.58451048843331 + 0.5)
    buffer_offset = buffer_offset + 1
    buffer.writeu8(value_2, buffer_offset, value_5 * 40.58451048843331 + 0.5)
    buffer_offset = buffer_offset + 1
    write_f24(argument.X)
    write_f24(argument.Y)
    write_f24(argument.Z)
end

types.CFrameF32U8 = "CFrameF32U8"

function reads.CFrameF32U8()
    local c_frame_from_euler_angles_xyz = CFrame.fromEulerAnglesXYZ
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local readu8_result_2 = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local readu8_result_3 = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local result = c_frame_from_euler_angles_xyz(
        readu8_result / 40.58451048843331,
        readu8_result_2 / 40.58451048843331,
        readu8_result_3 / 40.58451048843331
    )
    local readf32_result = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_2 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_3 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return result + Vector3.new(readf32_result, readf32_result_2, readf32_result_3)
end

function writes.CFrameF32U8(argument)
    local to_euler_angles_xyz_result, value_4, value_5 = argument:ToEulerAnglesXYZ()
    local sum = buffer_offset + 15

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, to_euler_angles_xyz_result * 40.58451048843331 + 0.5)
    buffer_offset = buffer_offset + 1
    buffer.writeu8(value_2, buffer_offset, value_4 * 40.58451048843331 + 0.5)
    buffer_offset = buffer_offset + 1
    buffer.writeu8(value_2, buffer_offset, value_5 * 40.58451048843331 + 0.5)
    buffer_offset = buffer_offset + 1
    buffer.writef32(value_2, buffer_offset, argument.X)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Y)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Z)
    buffer_offset = buffer_offset + 4
end

types.CFrameF32U16 = "CFrameF32U16"

function reads.CFrameF32U16()
    local c_frame_from_euler_angles_xyz = CFrame.fromEulerAnglesXYZ
    local readu16_result = buffer.readu16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local readu16_result_2 = buffer.readu16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local readu16_result_3 = buffer.readu16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local result = c_frame_from_euler_angles_xyz(
        readu16_result / 10430.219195527361,
        readu16_result_2 / 10430.219195527361,
        readu16_result_3 / 10430.219195527361
    )
    local readf32_result = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_2 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_3 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return result + Vector3.new(readf32_result, readf32_result_2, readf32_result_3)
end

function writes.CFrameF32U16(argument)
    local to_euler_angles_xyz_result, value_4, value_5 = argument:ToEulerAnglesXYZ()
    local sum = buffer_offset + 18

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu16(value_2, buffer_offset, to_euler_angles_xyz_result * 10430.219195527361 + 0.5)
    buffer_offset = buffer_offset + 2
    buffer.writeu16(value_2, buffer_offset, value_4 * 10430.219195527361 + 0.5)
    buffer_offset = buffer_offset + 2
    buffer.writeu16(value_2, buffer_offset, value_5 * 10430.219195527361 + 0.5)
    buffer_offset = buffer_offset + 2
    buffer.writef32(value_2, buffer_offset, argument.X)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Y)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Z)
    buffer_offset = buffer_offset + 4
end

types.Region3 = "Region3"

function reads.Region3()
    local region3_new = Region3.new
    local readf32_result = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_2 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_3 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local vector = Vector3.new(readf32_result, readf32_result_2, readf32_result_3)
    local readf32_result_4 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_5 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_6 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return region3_new(vector, (Vector3.new(readf32_result_4, readf32_result_5, readf32_result_6)))
end

function writes.Region3(argument: userdata)
    local quotient_2 = argument.Size / 2
    local difference = argument.CFrame.Position - quotient_2
    local sum = argument.CFrame.Position + quotient_2
    local sum_2 = buffer_offset + 24

    if buffer_length < sum_2 then
        while buffer_length < sum_2 do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writef32(value_2, buffer_offset, difference.X)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, difference.Y)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, difference.Z)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, sum.X)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, sum.Y)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, sum.Z)
    buffer_offset = buffer_offset + 4
end

types.NumberSequence = "NumberSequence"

function reads.NumberSequence()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local create_result = table.create(readu8_result)

    for index = 1, readu8_result do
        local number_sequence_keypoint_new = NumberSequenceKeypoint.new
        local readu8_result_2 = buffer.readu8(value_2, buffer_offset)
        buffer_offset = buffer_offset + 1
        local readu8_result_3 = buffer.readu8(value_2, buffer_offset)
        buffer_offset = buffer_offset + 1
        local readu8_result_4 = buffer.readu8(value_2, buffer_offset)
        buffer_offset = buffer_offset + 1
        table.insert(
            create_result,
            number_sequence_keypoint_new(readu8_result_2 / 255, readu8_result_3 / 255, readu8_result_4 / 255)
        )
        local _ = index
    end

    return NumberSequence.new(create_result)
end

function writes.NumberSequence(argument: userdata)
    local keypoints_count = #argument.Keypoints
    local sum = buffer_offset + (keypoints_count * 3 + 1)

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, keypoints_count)
    buffer_offset = buffer_offset + 1

    for _, item_6 in argument.Keypoints do
        buffer.writeu8(value_2, buffer_offset, item_6.Time * 255 + 0.5)
        buffer_offset = buffer_offset + 1
        buffer.writeu8(value_2, buffer_offset, item_6.Value * 255 + 0.5)
        buffer_offset = buffer_offset + 1
        buffer.writeu8(value_2, buffer_offset, item_6.Envelope * 255 + 0.5)
        buffer_offset = buffer_offset + 1
    end
end

types.ColorSequence = "ColorSequence"

function reads.ColorSequence()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local create_result = table.create(readu8_result)

    for index = 1, readu8_result do
        local color_sequence_keypoint_new = ColorSequenceKeypoint.new
        local readu8_result_2 = buffer.readu8(value_2, buffer_offset)
        buffer_offset = buffer_offset + 1
        local color3_from_rgb = Color3.fromRGB
        local readu8_result_3 = buffer.readu8(value_2, buffer_offset)
        buffer_offset = buffer_offset + 1
        local readu8_result_4 = buffer.readu8(value_2, buffer_offset)
        buffer_offset = buffer_offset + 1
        local readu8_result_5 = buffer.readu8(value_2, buffer_offset)
        buffer_offset = buffer_offset + 1
        table.insert(
            create_result,
            color_sequence_keypoint_new(
                readu8_result_2 / 255,
                color3_from_rgb(readu8_result_3, readu8_result_4, readu8_result_5)
            )
        )
        local _ = index
    end

    return ColorSequence.new(create_result)
end

function writes.ColorSequence(argument: userdata)
    local keypoints_count = #argument.Keypoints
    local sum = buffer_offset + (keypoints_count * 4 + 1)

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, keypoints_count)
    buffer_offset = buffer_offset + 1

    for _, item_6 in argument.Keypoints do
        buffer.writeu8(value_2, buffer_offset, item_6.Time * 255 + 0.5)
        buffer_offset = buffer_offset + 1
        buffer.writeu8(value_2, buffer_offset, item_6.Value.R * 255 + 0.5)
        buffer_offset = buffer_offset + 1
        buffer.writeu8(value_2, buffer_offset, item_6.Value.G * 255 + 0.5)
        buffer_offset = buffer_offset + 1
        buffer.writeu8(value_2, buffer_offset, item_6.Value.B * 255 + 0.5)
        buffer_offset = buffer_offset + 1
    end
end

local script_characters = require(script.Characters)
local values_3 = {}

for key, item in script_characters do
    values_3[item] = key
end

local log_result = math.log(#script_characters + 1, 2)
local rounded_value = math.ceil(log_result)
local quotient = rounded_value / 8
types.Characters = "Characters"

function reads.Characters()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local create_result = table.create(readu8_result)
    local product = buffer_offset * 8
    buffer_offset = buffer_offset + math.ceil(readu8_result * quotient)

    for index = 1, readu8_result do
        local script_character_entry = script_characters[buffer.readbits(value_2, product, rounded_value)]
        table.insert(create_result, script_character_entry)
        product = product + rounded_value
        local _ = index
    end

    return table.concat(create_result)
end

function writes.Characters(argument: string)
    local argument_count = #argument
    local rounded_value_2 = math.ceil(argument_count * quotient)
    local sum = buffer_offset + (rounded_value_2 + 1)

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, argument_count)
    buffer_offset = buffer_offset + 1
    local product = buffer_offset * 8

    for index = 1, argument_count do
        buffer.writebits(value_2, product, rounded_value, values_3[argument:sub(index, index)])
        product = product + rounded_value
        local _ = index
    end

    buffer_offset = buffer_offset + rounded_value_2
end

local script_enums = require(script.Enums)
local values_4 = {}

for key_2, item_2 in script_enums do
    values_4[item_2] = key_2
end

types.EnumItem = "EnumItem"

function reads.EnumItem()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local script_enum_entry = script_enums[readu8_result]
    local readu16_result = buffer.readu16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2

    return script_enum_entry:FromValue(readu16_result)
end

function writes.EnumItem(argument: userdata)
    local sum = buffer_offset + 3

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, values_4[argument.EnumType])
    buffer_offset = buffer_offset + 1
    buffer.writeu16(value_2, buffer_offset, argument.Value)
    buffer_offset = buffer_offset + 2
end

local script_static1 = require(script.Static1)
local values_5 = {}

for key_3, item_3 in script_static1 do
    values_5[item_3] = key_3
end

types.Static1 = "Static1"

function reads.Static1()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1

    return script_static1[readu8_result]
end

function writes.Static1(argument)
    local sum = buffer_offset + 1

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, values_5[argument] or 0)
    buffer_offset = buffer_offset + 1
end

local script_static2 = require(script.Static2)
local values_6 = {}

for key_4, item_4 in script_static2 do
    values_6[item_4] = key_4
end

types.Static2 = "Static2"

function reads.Static2()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1

    return script_static2[readu8_result]
end

function writes.Static2(argument)
    local sum = buffer_offset + 1

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, values_6[argument] or 0)
    buffer_offset = buffer_offset + 1
end

local script_static3 = require(script.Static3)
local values_7 = {}

for key_5, item_5 in script_static3 do
    values_7[item_5] = key_5
end

types.Static3 = "Static3"

function reads.Static3()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1

    return script_static3[readu8_result]
end

function writes.Static3(argument)
    local sum = buffer_offset + 1

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, values_7[argument] or 0)
    buffer_offset = buffer_offset + 1
end

values[0] = function()
    return nil
end

values_2["nil"] = function(argument: nil)
    local sum = buffer_offset + 1

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 0)
    buffer_offset = buffer_offset + 1
end

values[1] = function()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1

    return -readu8_result
end

values[2] = function()
    local readu16_result = buffer.readu16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2

    return -readu16_result
end

values[3] = function()
    local readbits_result = buffer.readbits(value_2, buffer_offset * 8, 24)
    buffer_offset = buffer_offset + 3

    return -readbits_result
end

values[4] = function()
    local readu32_result = buffer.readu32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return -readu32_result
end

values[5] = function()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1

    return readu8_result
end

values[6] = function()
    local readu16_result = buffer.readu16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2

    return readu16_result
end

values[7] = function()
    local readbits_result = buffer.readbits(value_2, buffer_offset * 8, 24)
    buffer_offset = buffer_offset + 3

    return readbits_result
end

values[8] = function()
    local readu32_result = buffer.readu32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return readu32_result
end

values[9] = function()
    local readf32_result = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return readf32_result
end

values[10] = function()
    local readf64_result = buffer.readf64(value_2, buffer_offset)
    buffer_offset = buffer_offset + 8

    return readf64_result
end

function values_2.number(argument: number)
    if argument % 1 ~= 0 then
        if argument > -1048576 and argument < 1048576 then
            local sum = buffer_offset + 5

            if buffer_length < sum then
                while buffer_length < sum do
                    buffer_length = buffer_length * 2
                end

                local buffer_2 = buffer.create(buffer_length)
                buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
                value.Buffer = buffer_2
                value_2 = buffer_2
            end

            buffer.writeu8(value_2, buffer_offset, 9)
            buffer_offset = buffer_offset + 1
            buffer.writef32(value_2, buffer_offset, argument)
            buffer_offset = buffer_offset + 4

            return
        end

        local sum_2 = buffer_offset + 9

        if buffer_length < sum_2 then
            while buffer_length < sum_2 do
                buffer_length = buffer_length * 2
            end

            local buffer_3 = buffer.create(buffer_length)
            buffer.copy(buffer_3, 0, value_2, 0, buffer_offset)
            value.Buffer = buffer_3
            value_2 = buffer_3
        end

        buffer.writeu8(value_2, buffer_offset, 10)
        buffer_offset = buffer_offset + 1
        buffer.writef64(value_2, buffer_offset, argument)
        buffer_offset = buffer_offset + 8

        return
    end

    if argument < 0 then
        if argument > -256 then
            local sum_3 = buffer_offset + 2

            if buffer_length < sum_3 then
                while buffer_length < sum_3 do
                    buffer_length = buffer_length * 2
                end

                local buffer_4 = buffer.create(buffer_length)
                buffer.copy(buffer_4, 0, value_2, 0, buffer_offset)
                value.Buffer = buffer_4
                value_2 = buffer_4
            end

            buffer.writeu8(value_2, buffer_offset, 1)
            buffer_offset = buffer_offset + 1
            buffer.writeu8(value_2, buffer_offset, -argument)
            buffer_offset = buffer_offset + 1

            return
        end

        if argument > -65536 then
            local sum_4 = buffer_offset + 3

            if buffer_length < sum_4 then
                while buffer_length < sum_4 do
                    buffer_length = buffer_length * 2
                end

                local buffer_5 = buffer.create(buffer_length)
                buffer.copy(buffer_5, 0, value_2, 0, buffer_offset)
                value.Buffer = buffer_5
                value_2 = buffer_5
            end

            buffer.writeu8(value_2, buffer_offset, 2)
            buffer_offset = buffer_offset + 1
            buffer.writeu16(value_2, buffer_offset, -argument)
            buffer_offset = buffer_offset + 2

            return
        end

        if argument > -16777216 then
            local sum_5 = buffer_offset + 4

            if buffer_length < sum_5 then
                while buffer_length < sum_5 do
                    buffer_length = buffer_length * 2
                end

                local buffer_6 = buffer.create(buffer_length)
                buffer.copy(buffer_6, 0, value_2, 0, buffer_offset)
                value.Buffer = buffer_6
                value_2 = buffer_6
            end

            buffer.writeu8(value_2, buffer_offset, 3)
            buffer_offset = buffer_offset + 1
            buffer.writebits(value_2, buffer_offset * 8, 24, -argument)
            buffer_offset = buffer_offset + 3

            return
        end

        if argument > -4294967296 then
            local sum_6 = buffer_offset + 5

            if buffer_length < sum_6 then
                while buffer_length < sum_6 do
                    buffer_length = buffer_length * 2
                end

                local buffer_7 = buffer.create(buffer_length)
                buffer.copy(buffer_7, 0, value_2, 0, buffer_offset)
                value.Buffer = buffer_7
                value_2 = buffer_7
            end

            buffer.writeu8(value_2, buffer_offset, 4)
            buffer_offset = buffer_offset + 1
            buffer.writeu32(value_2, buffer_offset, -argument)
            buffer_offset = buffer_offset + 4

            return
        end

        local sum_7 = buffer_offset + 9

        if buffer_length < sum_7 then
            while buffer_length < sum_7 do
                buffer_length = buffer_length * 2
            end

            local buffer_8 = buffer.create(buffer_length)
            buffer.copy(buffer_8, 0, value_2, 0, buffer_offset)
            value.Buffer = buffer_8
            value_2 = buffer_8
        end

        buffer.writeu8(value_2, buffer_offset, 10)
        buffer_offset = buffer_offset + 1
        buffer.writef64(value_2, buffer_offset, argument)
        buffer_offset = buffer_offset + 8

        return
    end

    if argument < 256 then
        local sum_8 = buffer_offset + 2

        if buffer_length < sum_8 then
            while buffer_length < sum_8 do
                buffer_length = buffer_length * 2
            end

            local buffer_9 = buffer.create(buffer_length)
            buffer.copy(buffer_9, 0, value_2, 0, buffer_offset)
            value.Buffer = buffer_9
            value_2 = buffer_9
        end

        buffer.writeu8(value_2, buffer_offset, 5)
        buffer_offset = buffer_offset + 1
        buffer.writeu8(value_2, buffer_offset, argument)
        buffer_offset = buffer_offset + 1

        return
    end

    if argument < 65536 then
        local sum_9 = buffer_offset + 3

        if buffer_length < sum_9 then
            while buffer_length < sum_9 do
                buffer_length = buffer_length * 2
            end

            local buffer_10 = buffer.create(buffer_length)
            buffer.copy(buffer_10, 0, value_2, 0, buffer_offset)
            value.Buffer = buffer_10
            value_2 = buffer_10
        end

        buffer.writeu8(value_2, buffer_offset, 6)
        buffer_offset = buffer_offset + 1
        buffer.writeu16(value_2, buffer_offset, argument)
        buffer_offset = buffer_offset + 2

        return
    end

    if argument < 16777216 then
        local sum_10 = buffer_offset + 4

        if buffer_length < sum_10 then
            while buffer_length < sum_10 do
                buffer_length = buffer_length * 2
            end

            local buffer_11 = buffer.create(buffer_length)
            buffer.copy(buffer_11, 0, value_2, 0, buffer_offset)
            value.Buffer = buffer_11
            value_2 = buffer_11
        end

        buffer.writeu8(value_2, buffer_offset, 7)
        buffer_offset = buffer_offset + 1
        buffer.writebits(value_2, buffer_offset * 8, 24, argument)
        buffer_offset = buffer_offset + 3

        return
    end

    if argument < 4294967296 then
        local sum_11 = buffer_offset + 5

        if buffer_length < sum_11 then
            while buffer_length < sum_11 do
                buffer_length = buffer_length * 2
            end

            local buffer_12 = buffer.create(buffer_length)
            buffer.copy(buffer_12, 0, value_2, 0, buffer_offset)
            value.Buffer = buffer_12
            value_2 = buffer_12
        end

        buffer.writeu8(value_2, buffer_offset, 8)
        buffer_offset = buffer_offset + 1
        buffer.writeu32(value_2, buffer_offset, argument)
        buffer_offset = buffer_offset + 4

        return
    end

    local sum_12 = buffer_offset + 9

    if buffer_length < sum_12 then
        while buffer_length < sum_12 do
            buffer_length = buffer_length * 2
        end

        local buffer_13 = buffer.create(buffer_length)
        buffer.copy(buffer_13, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_13
        value_2 = buffer_13
    end

    buffer.writeu8(value_2, buffer_offset, 10)
    buffer_offset = buffer_offset + 1
    buffer.writef64(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + 8
end

values[11] = function()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local readstring_result = buffer.readstring(value_2, buffer_offset, readu8_result)
    buffer_offset = buffer_offset + readu8_result

    return readstring_result
end

function values_2.string(argument: string)
    local argument_count = #argument
    local sum = buffer_offset + (argument_count + 2)

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 11)
    buffer_offset = buffer_offset + 1
    buffer.writeu8(value_2, buffer_offset, argument_count)
    buffer_offset = buffer_offset + 1
    buffer.writestring(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + #argument
end

values[12] = function()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local create_result = buffer.create(readu8_result)
    buffer.copy(create_result, 0, value_2, buffer_offset, readu8_result)
    buffer_offset = buffer_offset + readu8_result

    return create_result
end

function values_2.buffer(argument: buffer)
    local length = buffer.len(argument)
    local sum = buffer_offset + (2 + length)

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 12)
    buffer_offset = buffer_offset + 1
    buffer.writeu8(value_2, buffer_offset, length)
    buffer_offset = buffer_offset + 1
    buffer.copy(value_2, buffer_offset, argument)
    buffer_offset = buffer_offset + buffer.len(argument)
end

values[13] = function()
    instances_offset = instances_offset + 1

    return value_3[instances_offset]
end

function values_2.Instance(argument: userdata)
    local sum = buffer_offset + 1

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 13)
    buffer_offset = buffer_offset + 1
    instances_offset = instances_offset + 1
    value_3[instances_offset] = argument
end

values[14] = function()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1

    return readu8_result == 1
end

function values_2.boolean(argument: boolean)
    local sum = buffer_offset + 2

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 14)
    buffer_offset = buffer_offset + 1
    buffer.writeu8(value_2, buffer_offset, argument and 1 or 0)
    buffer_offset = buffer_offset + 1
end

values[15] = function()
    local number_range_new = NumberRange.new
    local readf32_result = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_2 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return number_range_new(readf32_result, readf32_result_2)
end

function values_2.NumberRange(argument)
    local sum = buffer_offset + 9

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 15)
    buffer_offset = buffer_offset + 1
    buffer.writef32(value_2, buffer_offset, argument.Min)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Max)
    buffer_offset = buffer_offset + 4
end

values[16] = function()
    local brick_color_new = BrickColor.new
    local readu16_result = buffer.readu16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2

    return brick_color_new(readu16_result)
end

function values_2.BrickColor(argument: userdata)
    local sum = buffer_offset + 3

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 16)
    buffer_offset = buffer_offset + 1
    buffer.writeu16(value_2, buffer_offset, argument.Number)
    buffer_offset = buffer_offset + 2
end

values[17] = function()
    local color3_from_rgb = Color3.fromRGB
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local readu8_result_2 = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local readu8_result_3 = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1

    return color3_from_rgb(readu8_result, readu8_result_2, readu8_result_3)
end

function values_2.Color3(argument)
    local sum = buffer_offset + 4

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 17)
    buffer_offset = buffer_offset + 1
    buffer.writeu8(value_2, buffer_offset, argument.R * 255 + 0.5)
    buffer_offset = buffer_offset + 1
    buffer.writeu8(value_2, buffer_offset, argument.G * 255 + 0.5)
    buffer_offset = buffer_offset + 1
    buffer.writeu8(value_2, buffer_offset, argument.B * 255 + 0.5)
    buffer_offset = buffer_offset + 1
end

values[18] = function()
    local u_dim_new = UDim.new
    local readi16_result = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local readi16_result_2 = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2

    return u_dim_new(readi16_result / 1000, readi16_result_2)
end

function values_2.UDim(argument)
    local sum = buffer_offset + 5

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 18)
    buffer_offset = buffer_offset + 1
    buffer.writei16(value_2, buffer_offset, argument.Scale * 1000)
    buffer_offset = buffer_offset + 2
    buffer.writei16(value_2, buffer_offset, argument.Offset)
    buffer_offset = buffer_offset + 2
end

values[19] = function()
    local u_dim2_new = UDim2.new
    local readi16_result = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local readi16_result_2 = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local readi16_result_3 = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local readi16_result_4 = buffer.readi16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2

    return u_dim2_new(readi16_result / 1000, readi16_result_2, readi16_result_3 / 1000, readi16_result_4)
end

function values_2.UDim2(argument)
    local sum = buffer_offset + 9

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 19)
    buffer_offset = buffer_offset + 1
    buffer.writei16(value_2, buffer_offset, argument.X.Scale * 1000)
    buffer_offset = buffer_offset + 2
    buffer.writei16(value_2, buffer_offset, argument.X.Offset)
    buffer_offset = buffer_offset + 2
    buffer.writei16(value_2, buffer_offset, argument.Y.Scale * 1000)
    buffer_offset = buffer_offset + 2
    buffer.writei16(value_2, buffer_offset, argument.Y.Offset)
    buffer_offset = buffer_offset + 2
end

values[20] = function()
    local rect_new = Rect.new
    local readf32_result = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_2 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_3 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_4 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return rect_new(readf32_result, readf32_result_2, readf32_result_3, readf32_result_4)
end

function values_2.Rect(argument)
    local sum = buffer_offset + 17

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 20)
    buffer_offset = buffer_offset + 1
    buffer.writef32(value_2, buffer_offset, argument.Min.X)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Min.Y)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Max.X)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Max.Y)
    buffer_offset = buffer_offset + 4
end

values[21] = function()
    local vector2_new = Vector2.new
    local readf32_result = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_2 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return vector2_new(readf32_result, readf32_result_2)
end

function values_2.Vector2(argument)
    local sum = buffer_offset + 9

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 21)
    buffer_offset = buffer_offset + 1
    buffer.writef32(value_2, buffer_offset, argument.X)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Y)
    buffer_offset = buffer_offset + 4
end

values[22] = function()
    local readf32_result = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_2 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_3 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return Vector3.new(readf32_result, readf32_result_2, readf32_result_3)
end

function values_2.Vector3(argument: vector)
    local sum = buffer_offset + 13

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 22)
    buffer_offset = buffer_offset + 1
    buffer.writef32(value_2, buffer_offset, argument.X)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Y)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Z)
    buffer_offset = buffer_offset + 4
end

values[23] = function()
    local c_frame_from_euler_angles_xyz = CFrame.fromEulerAnglesXYZ
    local readu16_result = buffer.readu16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local readu16_result_2 = buffer.readu16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local readu16_result_3 = buffer.readu16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2
    local result = c_frame_from_euler_angles_xyz(
        readu16_result / 10430.219195527361,
        readu16_result_2 / 10430.219195527361,
        readu16_result_3 / 10430.219195527361
    )
    local readf32_result = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_2 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_3 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return result + Vector3.new(readf32_result, readf32_result_2, readf32_result_3)
end

function values_2.CFrame(argument)
    local to_euler_angles_xyz_result, value_4, value_5 = argument:ToEulerAnglesXYZ()
    local sum = buffer_offset + 19

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 23)
    buffer_offset = buffer_offset + 1
    buffer.writeu16(value_2, buffer_offset, to_euler_angles_xyz_result * 10430.219195527361 + 0.5)
    buffer_offset = buffer_offset + 2
    buffer.writeu16(value_2, buffer_offset, value_4 * 10430.219195527361 + 0.5)
    buffer_offset = buffer_offset + 2
    buffer.writeu16(value_2, buffer_offset, value_5 * 10430.219195527361 + 0.5)
    buffer_offset = buffer_offset + 2
    buffer.writef32(value_2, buffer_offset, argument.X)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Y)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, argument.Z)
    buffer_offset = buffer_offset + 4
end

values[24] = function()
    local region3_new = Region3.new
    local readf32_result = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_2 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_3 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local vector = Vector3.new(readf32_result, readf32_result_2, readf32_result_3)
    local readf32_result_4 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_5 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4
    local readf32_result_6 = buffer.readf32(value_2, buffer_offset)
    buffer_offset = buffer_offset + 4

    return region3_new(vector, (Vector3.new(readf32_result_4, readf32_result_5, readf32_result_6)))
end

function values_2.Region3(argument: userdata)
    local quotient_2 = argument.Size / 2
    local difference = argument.CFrame.Position - quotient_2
    local sum = argument.CFrame.Position + quotient_2
    local sum_2 = buffer_offset + 25

    if buffer_length < sum_2 then
        while buffer_length < sum_2 do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 24)
    buffer_offset = buffer_offset + 1
    buffer.writef32(value_2, buffer_offset, difference.X)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, difference.Y)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, difference.Z)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, sum.X)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, sum.Y)
    buffer_offset = buffer_offset + 4
    buffer.writef32(value_2, buffer_offset, sum.Z)
    buffer_offset = buffer_offset + 4
end

values[25] = function()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local create_result = table.create(readu8_result)

    for index = 1, readu8_result do
        local number_sequence_keypoint_new = NumberSequenceKeypoint.new
        local readu8_result_2 = buffer.readu8(value_2, buffer_offset)
        buffer_offset = buffer_offset + 1
        local readu8_result_3 = buffer.readu8(value_2, buffer_offset)
        buffer_offset = buffer_offset + 1
        local readu8_result_4 = buffer.readu8(value_2, buffer_offset)
        buffer_offset = buffer_offset + 1
        table.insert(
            create_result,
            number_sequence_keypoint_new(readu8_result_2 / 255, readu8_result_3 / 255, readu8_result_4 / 255)
        )
        local _ = index
    end

    return NumberSequence.new(create_result)
end

function values_2.NumberSequence(argument: userdata)
    local keypoints_count = #argument.Keypoints
    local sum = buffer_offset + (keypoints_count * 3 + 2)

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 25)
    buffer_offset = buffer_offset + 1
    buffer.writeu8(value_2, buffer_offset, keypoints_count)
    buffer_offset = buffer_offset + 1

    for _, item_6 in argument.Keypoints do
        buffer.writeu8(value_2, buffer_offset, item_6.Time * 255 + 0.5)
        buffer_offset = buffer_offset + 1
        buffer.writeu8(value_2, buffer_offset, item_6.Value * 255 + 0.5)
        buffer_offset = buffer_offset + 1
        buffer.writeu8(value_2, buffer_offset, item_6.Envelope * 255 + 0.5)
        buffer_offset = buffer_offset + 1
    end
end

values[26] = function()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local create_result = table.create(readu8_result)

    for index = 1, readu8_result do
        local color_sequence_keypoint_new = ColorSequenceKeypoint.new
        local readu8_result_2 = buffer.readu8(value_2, buffer_offset)
        buffer_offset = buffer_offset + 1
        local color3_from_rgb = Color3.fromRGB
        local readu8_result_3 = buffer.readu8(value_2, buffer_offset)
        buffer_offset = buffer_offset + 1
        local readu8_result_4 = buffer.readu8(value_2, buffer_offset)
        buffer_offset = buffer_offset + 1
        local readu8_result_5 = buffer.readu8(value_2, buffer_offset)
        buffer_offset = buffer_offset + 1
        table.insert(
            create_result,
            color_sequence_keypoint_new(
                readu8_result_2 / 255,
                color3_from_rgb(readu8_result_3, readu8_result_4, readu8_result_5)
            )
        )
        local _ = index
    end

    return ColorSequence.new(create_result)
end

function values_2.ColorSequence(argument: userdata)
    local keypoints_count = #argument.Keypoints
    local sum = buffer_offset + (keypoints_count * 4 + 2)

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 26)
    buffer_offset = buffer_offset + 1
    buffer.writeu8(value_2, buffer_offset, keypoints_count)
    buffer_offset = buffer_offset + 1

    for _, item_6 in argument.Keypoints do
        buffer.writeu8(value_2, buffer_offset, item_6.Time * 255 + 0.5)
        buffer_offset = buffer_offset + 1
        buffer.writeu8(value_2, buffer_offset, item_6.Value.R * 255 + 0.5)
        buffer_offset = buffer_offset + 1
        buffer.writeu8(value_2, buffer_offset, item_6.Value.G * 255 + 0.5)
        buffer_offset = buffer_offset + 1
        buffer.writeu8(value_2, buffer_offset, item_6.Value.B * 255 + 0.5)
        buffer_offset = buffer_offset + 1
    end
end

values[27] = function()
    local readu8_result = buffer.readu8(value_2, buffer_offset)
    buffer_offset = buffer_offset + 1
    local script_enum_entry = script_enums[readu8_result]
    local readu16_result = buffer.readu16(value_2, buffer_offset)
    buffer_offset = buffer_offset + 2

    return script_enum_entry:FromValue(readu16_result)
end

function values_2.EnumItem(argument: userdata)
    local sum = buffer_offset + 4

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 27)
    buffer_offset = buffer_offset + 1
    buffer.writeu8(value_2, buffer_offset, values_4[argument.EnumType])
    buffer_offset = buffer_offset + 1
    buffer.writeu16(value_2, buffer_offset, argument.Value)
    buffer_offset = buffer_offset + 2
end

values[28] = function()
    local values_8 = {}

    while true do
        local readu8_result = buffer.readu8(value_2, buffer_offset)
        buffer_offset = buffer_offset + 1

        if readu8_result == 0 then
            break
        end

        local result = values[readu8_result]()
        local readu8_result_2 = buffer.readu8(value_2, buffer_offset)
        buffer_offset = buffer_offset + 1
        values_8[result] = values[readu8_result_2]()
    end

    return values_8
end

function values_2.table(argument: table)
    local sum = buffer_offset + 1

    if buffer_length < sum then
        while buffer_length < sum do
            buffer_length = buffer_length * 2
        end

        local buffer_2 = buffer.create(buffer_length)
        buffer.copy(buffer_2, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_2
        value_2 = buffer_2
    end

    buffer.writeu8(value_2, buffer_offset, 28)
    buffer_offset = buffer_offset + 1

    for key_6, item_6 in argument do
        values_2[typeof(key_6)](key_6)
        values_2[typeof(item_6)](item_6)
    end

    local sum_2 = buffer_offset + 1

    if buffer_length < sum_2 then
        while buffer_length < sum_2 do
            buffer_length = buffer_length * 2
        end

        local buffer_3 = buffer.create(buffer_length)
        buffer.copy(buffer_3, 0, value_2, 0, buffer_offset)
        value.Buffer = buffer_3
        value_2 = buffer_3
    end

    buffer.writeu8(value_2, buffer_offset, 0)
    buffer_offset = buffer_offset + 1
end

return {
    Import = function(argument: table)
        value = argument
        value_2 = argument.Buffer
        buffer_length = argument.BufferLength
        buffer_offset = argument.BufferOffset
        value_3 = argument.Instances
        instances_offset = argument.InstancesOffset
    end,

    Export = function()
        value.BufferLength = buffer_length
        value.BufferOffset = buffer_offset
        value.InstancesOffset = instances_offset

        return value
    end,

    Truncate = function()
        local create_result = buffer.create(buffer_offset)
        buffer.copy(create_result, 0, value_2, 0, buffer_offset)

        if instances_offset == 0 then
            return create_result
        end

        return create_result, value_3
    end,

    Ended = function()
        return buffer_length <= buffer_offset
    end,

    Types = types,
    Reads = reads,
    Writes = writes,
}
