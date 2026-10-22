local tonumber_2 = tonumber
local byte = string.byte
local char = string.char
local sub = string.sub
local gsub = string.gsub
local rep = string.rep
local concat = table.concat
local insert = table.insert
local ldexp = math.ldexp
local getfenv_2 = getfenv

if not getfenv_2 then
    local callback_2 = function()
        return _ENV
    end
    getfenv_2 = callback_2
end

local select_2 = select
local unpack_2 = unpack or table.unpack

local function callback(result, argument, ...)
    local number = 1
    local value = nil
    local result_2 = gsub(sub(result, 5), "..", function(argument_2)
        if byte(argument_2, 2) ~= 81 then
            local result_3 = char(tonumber_2(argument_2, 16))

            if not value then
                return result_3
            end

            local result_4 = rep(result_3, value)
            value = nil

            return result_4
        end

        value = tonumber_2(sub(argument_2, 1, 1))

        return ""
    end)
    result = result_2

    local function callback_3()
        local result_3 = byte(result, number, number)
        number = number + 1

        return result_3
    end

    local function callback_4()
        local number_2 = 0
        local value_5 = nil
        local value_6 = nil
        number_2, value_6, value_5 = number_2, value_6, value_5

        while number_2 ~= 1 do
            if number_2 == 0 then
                local result_3, value_7 = byte(result, number, number + 2)
                number = number + 2
                number_2, value_6, value_5 = 1, value_7, result_3
            end
        end

        return (value_6 * 256) + value_5
    end

    local function callback_5()
        local result_3, value_5, value_6, value_7 = byte(result, number, number + 3)
        number = (number + 1) + 3

        return (((value_7 * 16777216) + (value_6 * 65536)) + (value_5 * 256)) + result_3
    end

    local function callback_6(argument_2, argument_3, argument_4)
        if argument_4 then
            local remainder = argument_2 / (2 ^ (argument_3 - 1)) % 2 ^ (((argument_4 - 1) - (argument_3 - 1)) + 1)

            return remainder - (remainder % 1)
        end

        local power = 2 ^ (argument_3 - 1)

        if power <= argument_2 % (power + power) then
            return 1
        end

        return 0
    end

    local function value_2()
        local number_2 = 0
        local value_5 = nil
        local value_6 = nil
        local value_7 = nil
        local value_8 = nil
        local value_9 = nil
        local value_10 = nil

        while true do
            if number_2 == 2 then
                value_9 = callback_6(value_6, 21, 31)
                local negated_value = ((callback_6(value_6, 32) ~= 1) and 1) or -1
                number_2, value_10 = 3, negated_value
            end

            if number_2 == 1 then
                number_2 = 2
                value_8 = callback_6(value_6, 1, 20) * 4294967296 + value_5
                value_7 = 1
            end

            if number_2 == 3 then
                break
            end

            if number_2 == 0 then
                value_5 = callback_5()
                number_2 = 1
                value_6 = callback_5()
            end
        end

        if value_9 ~= 0 then
            if value_9 == 2047 then
                local product

                if value_8 ~= 0 then
                    product = value_10 * NaN
                else
                    product = value_10 * (1 / 0)
                    product = product or value_10 * NaN
                end

                return product
            end
        elseif value_8 ~= 0 then
            value_9, value_7 = 1, 0
        else
            return value_10 * 0
        end

        return ldexp(value_10, value_9 - 1023) * (value_7 + (value_8 / 4503599627370496))
    end

    local function value_3(result_3)
        if not result_3 then
            result_3 = callback_5()

            if result_3 == 0 then
                return ""
            end
        end

        local result_4 = sub(result, number, (number + result_3) - 1)
        number = number + result_3
        local values_2 = {}

        for n = 1, #result_4 do
            values_2[n] = char(byte(sub(result_4, n, n)))
        end

        return concat(values_2)
    end

    local function value_4(...)
        return { ... }, select_2("#", ...)
    end

    local function callback_7()
        local callback_10 = (function()
            return function(
                argument_2,
                argument_3,
                argument_4,
                callback_12,
                callback_13,
                callback_14,
                argument_5,
                argument_6
            )
                local result_28 = (function()
                    return 0
                end)()
                local result_29 = (function() end)()
                local result_30 = (function() end)()
                local value_26 = nil

                while result_28 ~= 1 do
                    if result_28 ~= 0 then
                        continue
                    end

                    local result_31 = (function()
                        return 0
                    end)()
                    local _ = (function() end)()

                    while result_31 ~= 0 do
                    end

                    value_26 = (function()
                        return 0
                    end)()

                    while value_26 ~= 1 do
                        if value_26 == 0 then
                            result_29 = (function()
                                return callback_12()
                            end)()
                            result_30 = (function()
                                return nil
                            end)()
                            value_26 = (function()
                                return 1
                            end)()
                        end
                    end

                    result_28 = (function()
                        return 1
                    end)()
                end

                if result_29 == 1 then
                    result_30 = (function()
                        return callback_12() ~= 0
                    end)()
                elseif result_29 == 2 then
                    result_30 = (function()
                        return callback_13()
                    end)()
                elseif result_29 == 3 then
                    result_30 = (function()
                        return callback_14()
                    end)()
                end

                argument_5[argument_6] = (function()
                    return result_30
                end)()

                return result_28, result_29, result_30, callback_12, callback_13, callback_14, argument_5, argument_6
            end
        end)()
        local callback_11 = (function()
            return function(argument_2, argument_3, callback_12)
                local result_28 = (function()
                    return 0
                end)()
                local result_29 = (function() end)()

                while result_28 ~= 0 do
                end

                result_29 = (function()
                    return 0
                end)()

                while result_29 ~= 0 do
                end

                local result_30 = (function()
                    return 0
                end)()
                local _ = (function() end)()

                while result_30 ~= 0 do
                end

                local result_31 = (function()
                    return 0
                end)()

                while result_31 ~= 0 do
                end

                argument_2[argument_3 - 1] = (function()
                    return callback_12()
                end)()

                return argument_2, argument_3, callback_12
            end
        end)()
        local result_3 = (function()
            return {}
        end)()
        local result_4 = (function()
            return {}
        end)()
        local result_5 = (function()
            return {}
        end)()
        local result_6 = (function()
            return { result_3, result_4, nil, result_5 }
        end)()
        local result_7 = (function()
            return callback_5()
        end)()
        local result_8 = (function()
            return {}
        end)()
        local n_4

        for n = 1, result_7 do
            n_4 = n
            local result_9, value_5, value_6, value_7, value_8, value_9, value_10, value_11 = (function()
                return callback_10(FlatIdent_47A9C, Type, Cons, callback_3, value_2, value_3, result_8, n_4)
            end)()
            FlatIdent_47A9C = result_9
            Type = value_5
            Cons = value_6
            callback_3 = value_7
            value_2 = value_8
            value_3 = value_9
            result_8 = value_10
            n_4 = value_11
        end

        result_6[3] = (function()
            return callback_3()
        end)()
        n_4 = callback_5()
        local value_12, value_13, value_14, value_15, value_16, value_17, value_18, value_19, value_20, _, value_21, value_22 =
            nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil

        for n_2 = 1, n_4 do
            result_7 = (function()
                return callback_3()
            end)()

            if callback_6(result_7, 1, 1) ~= 0 then
                continue
            end

            value_18 = (function()
                return 0
            end)()
            value_22 = (function() end)()
            value_21 = (function() end)()
            local result_10 = (function() end)()
            local n_5, value_23
            n_5 = n_2

            repeat
                if value_18 == 2 then
                    if callback_6(value_21, 1, 1) == 1 then
                        local result_11 = (function()
                            return result_8[result_10[2]]
                        end)()
                        result_10[2] = result_11
                    end

                    if callback_6(value_21, 2, 2) == 1 then
                        local result_12 = (function()
                            return result_8[result_10[3]]
                        end)()
                        result_10[3] = result_12
                    end

                    value_18 = (function()
                        return 3
                    end)()
                end

                if value_18 == 1 then
                    local result_13 = (function()
                        return { callback_4(), callback_4(), nil, nil }
                    end)()
                    result_10 = result_13

                    if value_22 == 0 then
                        local result_14 = (function()
                            return 0
                        end)()
                        local result_15 = (function() end)()

                        while result_14 ~= 0 do
                        end

                        local result_16 = (function()
                            return 0
                        end)()

                        while result_16 ~= 0 do
                        end

                        local result_17 = (function()
                            return callback_4()
                        end)()
                        result_10[3] = result_17
                        local result_18 = (function()
                            return callback_4()
                        end)()
                        result_10[4] = result_18
                    elseif value_22 == 1 then
                        local result_19 = (function()
                            return callback_5()
                        end)()
                        result_10[3] = result_19
                    elseif value_22 == 2 then
                        local result_20 = (function()
                            return callback_5() - 65536
                        end)()
                        result_10[3] = result_20
                    elseif value_22 == 3 then
                        local result_21 = (function()
                            return 0
                        end)()
                        local result_22 = (function() end)()

                        while result_21 ~= 0 do
                        end

                        local result_23 = (function()
                            return 0
                        end)()

                        while result_23 ~= 0 do
                        end

                        local result_24 = (function()
                            return callback_5() - 65536
                        end)()
                        result_10[3] = result_24
                        local result_25 = (function()
                            return callback_4()
                        end)()
                        result_10[4] = result_25
                    end

                    value_18 = (function()
                        return 2
                    end)()
                end

                if value_18 == 0 then
                    value_15 = (function()
                        return 0
                    end)()

                    while value_15 ~= 1 do
                        if value_15 == 0 then
                            value_22 = (function()
                                return callback_6(result_7, 2, 3)
                            end)()
                            value_21 = (function()
                                return callback_6(result_7, 4, 6)
                            end)()
                            value_15 = (function()
                                return 1
                            end)()
                        end
                    end

                    value_18 = (function()
                        return 1
                    end)()
                end
            until value_18 == 3

            if callback_6(value_21, 3, 3) == 1 then
                local result_26 = (function()
                    return result_8[result_10[4]]
                end)()
                result_10[4] = result_26
            end

            result_3[n_5] = (function()
                return result_10
            end)()
        end

        for n_3 = 1, callback_5() do
            local n_6 = n_3
            local result_27, value_24, value_25 = (function()
                return callback_11(result_4, n_6, callback_7)
            end)()
            callback_7 = value_25
            result_4 = result_27
            n_6 = value_24
        end

        return result_6
    end

    local function callback_8(argument_2, argument_3, argument_4)
        local argument_entry = argument_2[1]
        local argument_entry_2 = argument_2[2]
        local argument_entry_3 = argument_2[3]

        return function(...)
            local number_2 = 1
            local values_2 = {}
            local values_3 = { ... }
            local values_4 = {}

            for n = 0, select_2("#", ...) - 1 do
                if argument_entry_3 <= n then
                    values_2[n - argument_entry_3] = values_3[(n + 1) + 0]
                else
                    values_4[n] = values_3[n + 1]
                end
            end

            local value_5, value_6, value_7, value_8, value_9, _, value_10, value_11, value_12, value_13 =
                nil, nil, nil, nil, nil, nil, nil, nil, nil, nil

            while true do
                value_5 = argument_entry[number_2]
                local entry = value_5[1]

                if entry <= 36 then
                    if entry <= 17 then
                        if entry <= 8 then
                            if entry <= 3 then
                                if entry <= 1 then
                                    if entry > 0 then
                                        values_4[value_5[2]] = callback_8(argument_entry_2[value_5[3]], nil, argument_4)
                                    else
                                        return values_4[value_5[2]]
                                    end

                                    value_5 = number_2
                                else
                                    if not (entry > 2) then
                                        local entry_2 = value_5[2]
                                        local value_entry = values_4[value_5[3]]
                                        values_4[entry_2 + 1] = value_entry
                                        values_4[entry_2] = value_entry[value_5[4]]
                                        value_5 = number_2
                                        number_2 = value_5 + 1
                                        continue
                                    end

                                    local entry_3 = value_5[2]
                                    local values_5 = { values_4[entry_3](values_4[entry_3 + 1]) }
                                    local number_3 = 0
                                    values_2 = number_3

                                    for n_2 = entry_3, value_5[4] do
                                        values_2 = values_2 + 1 + 0
                                        values_4[n_2] = values_5[values_2]
                                    end

                                    value_5 = number_2
                                    number_2 = value_5 + 1
                                    continue
                                end
                            elseif entry <= 5 then
                                if entry ~= 4 then
                                    values_4[value_5[2]] = values_4[value_5[3]] * values_4[value_5[4]]
                                    value_5 = number_2
                                    number_2 = value_5 + 1
                                    continue
                                end

                                local value_14 = value_5
                                local value_entry_2 = values_4[value_14[4]]

                                if value_entry_2 then
                                    values_4[value_14[2]] = value_entry_2
                                    value_5 = value_14[3]
                                else
                                    value_5 = number_2 + 1
                                end
                            else
                                if entry <= 6 then
                                    local entry_4 = value_5[2]
                                    values_4[entry_4](unpack_2(values_4, entry_4 + 1, value_5[3]))
                                    value_5 = number_2
                                    number_2 = value_5 + 1
                                    continue
                                end

                                if entry ~= 7 then
                                    values_4[value_5[2]] = values_4[value_5[3]][value_5[4]]
                                else
                                    local entry_5 = value_5[2]
                                    values_4[entry_5] = values_4[entry_5]()
                                end

                                value_5 = number_2
                            end
                        elseif entry <= 12 then
                            if entry <= 10 then
                                if entry ~= 9 then
                                    values_4[value_5[2]] = values_4[value_5[3]] / value_5[4]
                                    value_5 = number_2
                                else
                                    value_5 = value_5[3]
                                end
                            else
                                if entry > 11 then
                                    values_4[value_5[2]] = values_4[value_5[3]] * value_5[4]
                                else
                                    values_4[value_5[2]] = values_4[value_5[3]] / value_5[4]
                                end

                                value_5 = number_2
                            end
                        elseif entry <= 14 then
                            if entry > 13 then
                                value_5 = ((values_4[value_5[2]] == value_5[4]) and (number_2 + 1 + 0)) or value_5[3]
                                number_2 = value_5 + 1
                                continue
                            end

                            for n_3 = value_5[2], value_5[3] do
                                values_4[n_3] = nil
                            end

                            value_5 = number_2
                            number_2 = value_5 + 1
                            continue
                        else
                            if entry <= 15 then
                                local entry_6 = value_5[2]
                                values_4[entry_6] = values_4[entry_6](values_4[entry_6 + 1])
                                value_5 = number_2
                                number_2 = value_5 + 1
                                continue
                            end

                            if entry == 16 then
                                argument_4[value_5[3]] = values_4[value_5[2]]
                                value_5 = number_2
                            else
                                value_5 = values_4[value_5[2]] ~= value_5[4] and number_2 + 1 + 0 or value_5[3]
                            end
                        end

                        number_2 = value_5 + 1
                        continue
                    elseif entry <= 26 then
                        if entry <= 21 then
                            if entry <= 19 then
                                if entry == 18 then
                                    values_4[value_5[2]] = value_5[3] ~= 0
                                    value_5 = number_2 + 1
                                else
                                    value_5 = values_4[value_5[2]] and number_2 + 1 + 0 or value_5[3]
                                end
                            elseif entry ~= 20 then
                                value_5 = values_4[value_5[4]] < values_4[value_5[2]] and number_2 + 1
                                    or number_2 + value_5[3]
                            else
                                values_4[value_5[2]] = value_5[3]
                                value_5 = number_2
                            end
                        elseif entry <= 23 then
                            if entry > 22 then
                                values_4[value_5[2]] = values_4[value_5[3]] * values_4[value_5[4]]
                                value_5 = number_2
                                number_2 = value_5 + 1
                                continue
                            end

                            local value_entry_3 = values_4[value_5[4]]

                            if value_entry_3 then
                                values_4[value_5[2]] = value_entry_3
                                value_5 = value_5[3]
                            else
                                value_5 = number_2 + 1
                            end
                        else
                            if entry <= 24 then
                                values_4[value_5[2]][value_5[3]] = value_5[4]
                                value_5 = number_2
                                number_2 = value_5 + 1
                                continue
                            end

                            if not (entry > 25) then
                                value_5 = ((values_4[value_5[2]] == value_5[4]) and (number_2 + 1)) or value_5[3]
                                number_2 = value_5 + 1
                                continue
                            end

                            local entry_7 = value_5[2]
                            value_8 = (entry_7 + 1) + 0 + 1
                            local values_6 = { values_4[entry_7](values_4[(entry_7 + 1) + 0], values_4[value_8]) }

                            for n_4 = 1, value_5[4] do
                                values_4[value_8 + n_4] = values_6[n_4]
                            end

                            value_7 = values_6[1]

                            if value_7 then
                                values_4[value_8] = value_7
                                value_5 = value_5[3]
                            else
                                value_5 = number_2 + 1
                            end
                        end

                        number_2 = value_5 + 1
                        continue
                    elseif entry <= 31 then
                        if entry <= 28 then
                            if entry > 27 then
                                for n_5 = value_5[2], value_5[3] do
                                    values_4[n_5] = nil
                                end
                            else
                                value_11 = 0
                                value_7 = nil
                                value_8 = nil
                                value_6 = value_11

                                while value_6 ~= 1 do
                                    if value_6 ~= 0 then
                                        value_11 = value_6
                                    else
                                        value_7 = value_5[2]
                                        value_11, value_8 = 1, values_4[value_7]
                                    end

                                    value_6 = value_11
                                end

                                for n_6 = 1, value_5[3] do
                                    value_8[n_6] = values_4[value_7 + n_6]
                                end
                            end

                            value_5 = number_2
                            number_2 = value_5 + 1
                        else
                            if entry <= 29 then
                                return
                            end

                            if entry ~= 30 then
                                local entry_8 = value_5[2]
                                values_4[entry_8] = values_4[entry_8]()
                            else
                                values_4[value_5[2]] = argument_4[value_5[3]]
                            end

                            value_5 = number_2
                            number_2 = value_5 + 1
                        end
                    elseif entry <= 33 then
                        if entry > 32 then
                            value_5 = values_4[value_5[2]] and number_2 + 1 or value_5[3]
                        else
                            values_4[value_5[2]][value_5[3]] = values_4[value_5[4]]
                            value_5 = number_2
                        end

                        number_2 = value_5 + 1
                    elseif entry <= 34 then
                        local entry_9 = value_5[2]

                        return unpack_2(values_4, entry_9, entry_9 + value_5[3])
                    else
                        if entry == 35 then
                            values_4[value_5[2]] = {}
                            value_5 = number_2
                            number_2 = value_5 + 1
                            continue
                        end

                        local entry_10 = value_5[2]
                        local value_entry_4 = values_4[entry_10]

                        for n_7 = entry_10 + 1 + 0, value_5[3] do
                            insert(value_entry_4, values_4[n_7])
                        end

                        value_5 = number_2
                        number_2 = value_5 + 1
                        continue
                    end
                elseif entry <= 54 then
                    if entry <= 45 then
                        if entry <= 40 then
                            if entry <= 38 then
                                if entry > 37 then
                                    value_5 = ((value_5[2] == values_4[value_5[4]]) and (number_2 + 1 + 0))
                                        or value_5[3]
                                    number_2 = value_5 + 1
                                    continue
                                end

                                value_9 = 0
                                value_7 = nil
                                value_8 = nil
                                value_6 = value_9

                                while value_6 ~= 1 do
                                    if value_6 ~= 0 then
                                        value_9 = value_6
                                    else
                                        value_7 = value_5[2]
                                        local values_7 = { values_4[value_7](values_4[value_7 + 1]) }
                                        value_9, value_8 = 1, values_7
                                    end

                                    value_6 = value_9
                                end

                                local number_4 = 0
                                local value_15

                                for n_8 = value_7, value_5[4] do
                                    local n_11
                                    n_11 = n_8
                                    number_4 = number_4 + 1 + 0
                                    values_4[n_11] = value_8[number_4]
                                end

                                value_5 = number_2
                                number_2 = value_5 + 1
                                continue
                            else
                                if entry > 39 then
                                    values_4[value_5[2]] = values_4[value_5[3]] * value_5[4]
                                else
                                    local entry_11 = value_5[2]
                                    local value_entry_5 = values_4[value_5[3]]
                                    values_4[entry_11 + 1] = value_entry_5
                                    values_4[entry_11] = value_entry_5[value_5[4]]
                                end

                                value_5 = number_2
                            end

                            number_2 = value_5 + 1
                            continue
                        elseif entry <= 42 then
                            if not (entry > 41) then
                                local entry_12 = value_5[2]
                                values_4[entry_12] = values_4[entry_12](unpack_2(values_4, entry_12 + 1, value_5[3]))
                                value_5 = number_2
                                number_2 = value_5 + 1
                                continue
                            end

                            value_6, value_7, value_8 = 0, nil, nil

                            repeat
                                if value_6 == 0 then
                                    value_7 = value_5[2]
                                    value_6, value_8 = 1, values_4[value_7]
                                end
                            until value_6 == 1

                            for n_9 = 1, value_5[3] do
                                value_8[n_9] = values_4[value_7 + n_9]
                            end

                            value_5 = number_2
                            number_2 = value_5 + 1
                            continue
                        else
                            if entry <= 43 then
                                value_5 = ((values_4[value_5[4]] < values_4[value_5[2]]) and (number_2 + 1))
                                    or (number_2 + value_5[3])
                                number_2 = value_5 + 1
                                continue
                            end

                            if entry > 44 then
                                break
                            else
                                values_4[value_5[2]] = values_4[value_5[3]] + values_4[value_5[4]]
                                value_5 = number_2
                                number_2 = value_5 + 1
                                continue
                            end
                        end
                    else
                        if entry <= 49 then
                            if entry <= 47 then
                                if entry > 46 then
                                    values_4[value_5[2]] = -values_4[value_5[3]]
                                    value_5 = number_2
                                    number_2 = value_5 + 1
                                    continue
                                end

                                local entry_13 = value_5[2]
                                local sum = entry_13 + 1 + 1
                                local values_8 = { values_4[entry_13](values_4[entry_13 + 1], values_4[sum]) }

                                for n_10 = 1, value_5[4] do
                                    values_4[sum + n_10] = values_8[n_10]
                                end

                                local value_entry_6 = values_8[1]

                                if value_entry_6 then
                                    values_4[sum] = value_entry_6
                                    value_5 = value_5[3]
                                else
                                    value_5 = number_2 + 1
                                end
                            else
                                if entry ~= 48 then
                                    values_4[value_5[2]] = value_5[3] ~= 0
                                else
                                    values_4[value_5[2]] = value_5[3]
                                end

                                value_5 = number_2
                            end
                        elseif entry <= 51 then
                            if entry > 50 then
                                value_5 = values_4[value_5[2]] <= values_4[value_5[4]] and number_2 + 1 + 0
                                    or value_5[3]
                            else
                                argument_4[value_5[3]] = values_4[value_5[2]]
                                value_5 = number_2
                            end
                        else
                            if entry <= 52 then
                                values_4[value_5[2]] = values_4[value_5[3]][value_5[4]]
                                value_5 = number_2
                                number_2 = value_5 + 1
                                continue
                            end

                            if entry > 53 then
                                values_4[value_5[2]] = argument_4[value_5[3]]
                            else
                                local entry_14 = value_5[2]
                                values_4[entry_14] = values_4[entry_14](unpack_2(values_4, entry_14 + 1, value_5[3]))
                            end

                            value_5 = number_2
                        end

                        number_2 = value_5 + 1
                        continue
                    end
                else
                    if entry <= 63 then
                        if entry <= 58 then
                            if entry <= 56 then
                                if entry > 55 then
                                    values_4[value_5[2]] = callback_8(argument_entry_2[value_5[3]], nil, argument_4)
                                else
                                    local entry_15 = value_5[2]
                                    values_4[entry_15](unpack_2(values_4, (entry_15 + 1) + 0, value_5[3]))
                                end

                                value_5 = number_2
                            elseif entry > 57 then
                                values_4[value_5[2]] = value_5[3] ~= 0
                                value_5 = number_2
                            else
                                value_5 = not values_4[value_5[2]] and number_2 + 1 + 0 or value_5[3]
                            end
                        elseif entry <= 60 then
                            if entry > 59 then
                                value_5 = values_4[value_5[2]] ~= value_5[4] and number_2 + 1 + 0 or value_5[3]
                            else
                                values_4[value_5[2]][value_5[3]] = values_4[value_5[4]]
                                value_5 = number_2
                            end
                        else
                            if entry <= 61 then
                                values_4[value_5[2]] = -values_4[value_5[3]]
                                value_5 = number_2
                                number_2 = value_5 + 1
                                continue
                            end

                            if entry > 62 then
                                value_5 = values_4[value_5[2]] <= values_4[value_5[4]] and number_2 + 1 + 0
                                    or value_5[3]
                            else
                                values_4[value_5[2]] = values_4[value_5[3]]
                                value_5 = number_2
                            end
                        end
                    elseif entry <= 68 then
                        if entry <= 65 then
                            if entry > 64 then
                                value_5 = value_5[3]
                            else
                                values_4[value_5[2]][value_5[3]] = value_5[4]
                                value_5 = number_2
                            end
                        else
                            if entry <= 66 then
                                values_4[value_5[2]] = values_4[value_5[3]]
                                value_5 = number_2
                                number_2 = value_5 + 1
                                continue
                            end

                            if entry ~= 67 then
                                return
                            end

                            value_5 = value_5[2] == values_4[value_5[4]] and number_2 + 1 or value_5[3]
                        end
                    elseif entry <= 70 then
                        if entry ~= 69 then
                            value_5 = not values_4[value_5[2]] and number_2 + 1 or value_5[3]
                        else
                            values_4[value_5[2]] = {}
                            value_5 = number_2
                        end
                    else
                        if entry <= 71 then
                            local entry_16 = value_5[2]
                            values_4[entry_16] = values_4[entry_16](values_4[entry_16 + 1])
                            value_5 = number_2
                            number_2 = value_5 + 1
                            continue
                        end

                        if entry ~= 72 then
                            values_4[value_5[2]] = values_4[value_5[3]] + values_4[value_5[4]]
                            value_5 = number_2
                        else
                            local value_16 = value_5
                            values_4[value_16[2]] = value_16[3] ~= 0
                            value_5 = number_2 + 1
                        end
                    end

                    number_2 = value_5 + 1
                    continue
                end

                if entry > 44 then
                    break
                end

                values_4[value_5[2]] = values_4[value_5[3]] + values_4[value_5[4]]
                value_5 = number_2
                number_2 = value_5 + 1
            end

            return values_4[value_5[2]]
        end
    end

    local values = {}
    local callback_9 = callback_8(callback_7(), values, argument)

    return callback_9(...)
end

return callback(
    "LOL!043Q00028Q00026Q00F03F03063Q00437265617465030F3Q006973506F696E74496E566F6C756D6500213Q0012143Q00014Q000D000100013Q001214000200013Q00260E00020003000100010004413Q0003000100260E3Q000E000100020004413Q000E0001001214000300013Q00260E00030008000100010004413Q0008000100020100045Q00103B0001000300042Q002D000100023Q0004413Q0008000100260E3Q0002000100010004413Q00020001001214000300013Q00260E00030015000100020004413Q001500010012143Q00023Q0004413Q00020001000E4300010011000100030004413Q001100012Q004500046Q0042000100043Q000201000400013Q001232000400043Q001214000300023Q0004413Q001100010004413Q000200010004413Q000300010004413Q000200012Q001D3Q00013Q00023Q003F3Q00028Q00026Q000840030A3Q0043616E436F2Q6C6964650100030E3Q00436F2Q6C6973696F6E47726F7570030B3Q004E6F436F2Q6C6973696F6E03063Q00506172656E7403043Q0067616D6503093Q00576F726B737061636503043Q0054656D702Q0103053Q00536861706503043Q00456E756D03083Q00506172745479706503043Q0042612Q6C03063Q0044656272697303073Q00412Q644974656D026Q11913F026Q001040030A3Q0047657453657276696365030A3Q0052756E5365727669636503083Q004973536572766572026Q11A13F029A5Q99B93F030D3Q0052617963617374506172616D732Q033Q006E6577030A3Q0046696C7465725479706503113Q005261796361737446696C7465725479706503073Q00496E636C756465031A3Q0046696C74657244657363656E64616E7473496E7374616E63657303113Q005265737065637443616E436F2Q6C696465026Q001440026Q00F03F03083Q006973537068657265030D3Q004F7665726C6170506172616D7303093Q00776F726B737061636503153Q0047657450617274426F756E6473496E52616469757303083Q00506F736974696F6E03013Q0058027Q0040030F3Q006973506F696E74496E566F6C756D6503073Q00566563746F7233026Q00F23F03123Q0047657450617274426F756E6473496E426F7800030A3Q005370686572656361737403043Q0053697A6503163Q00412Q73656D626C794C696E65617256656C6F6369747903053Q00706169727303043Q004E616D65030E3Q0046696E6446697273744368696C6403063Q0053636F72656403083Q00496E7374616E636503043Q005061727403063Q00434672616D6503083Q00416E63686F726564030C3Q005472616E73706172656E637903073Q00506C617965727303163Q00476574506C6179657246726F6D43686172616374657203043Q0073697A6503113Q005265706C69636174656453746F72616765030C3Q006C6F636B6564486974626F7803063Q00636672616D6502FE3Q001214000200014Q000D0003000E3Q001214000F00013Q000E430001003A0001000F0004413Q003A000100260E0002001B000100020004413Q001B0001003018000A00030004003018000A0005000600121E001000083Q00200800100010000900200800100010000A00103B000A0007001000260E000700130001000B0004413Q0013000100121E0010000D3Q00200800100010000E00200800100010000F00103B000A000C001000121E001000083Q0020080010001000100020270010001000112Q00420012000A3Q001214001300124Q00060010001300012Q000D000B000B3Q001214000200133Q00260E00020039000100130004413Q0039000100121E001000083Q002027001000100014001214001200154Q00290010001200020020270010001000162Q00470010000200020006130010002700013Q0004413Q00270001001214000B00173Q0004413Q00280001001214000B00123Q001214000C00183Q00121E001000193Q00200800100010001A2Q00070010000100022Q0042000D00103Q00121E0010000D3Q00200800100010001C00200800100010001D00103B000D001B00102Q0045001000013Q00121E001100083Q00200800110011000900200800110011000A2Q001B00100001000100103B000D001E0010003018000D001F0004001214000200203Q001214000F00213Q000E43002100BF0001000F0004413Q00BF000100260E00020084000100210004413Q0084000100200800103Q002200061600070042000100100004413Q004200012Q003A00075Q00121E001000233Q00200800100010001A2Q00070010000100022Q0042000800103Q00121E0010000D3Q00200800100010001C00200800100010001D00103B0008001B00102Q0045001000013Q00121E001100083Q00200800110011000900200800110011000A2Q001B00100001000100103B0008001E00102Q000D000900093Q00260E0007006F0001000B0004413Q006F0001001214001000013Q000E4300010054000100100004413Q0054000100121E001100243Q00202700110011002500200800130006002600200800140005002700200B0014001400282Q0042001500084Q00290011001500022Q0042000900113Q00121E001100293Q0020080012000300262Q0042001300063Q00121E0014002A3Q00200800140014001A0020080015000500270020080016000500270020080017000500272Q002900140017000200202800140014002B2Q002900110014000200063900110083000100010004413Q008300012Q001D3Q00013Q0004413Q008300010004413Q005400010004413Q00830001001214001000013Q00260E00100070000100010004413Q0070000100121E001100243Q00202700110011002C2Q0042001300064Q0042001400054Q0042001500084Q00290011001500022Q0042000900113Q00121E001100293Q0020080012000300262Q0042001300063Q00202800140005002B2Q002900110014000200063900110083000100010004413Q008300012Q001D3Q00013Q0004413Q008300010004413Q00700001001214000200283Q00260E000200BE000100200004413Q00BE0001001214001000013Q00260E0010008B000100280004413Q008B00012Q000D001100114Q002D001100023Q00260E001000AE000100210004413Q00AE000100263C000E00900001002D0004413Q009000012Q002D000300023Q00121E001100083Q002027001100110014001214001300154Q00290011001300020020270011001100162Q0047001100020002000613001100AD00013Q0004413Q00AD0001001214001100014Q000D001200123Q00260E0011009A000100010004413Q009A000100121E001300243Q00202700130013002E00200800150003002600200800160003002F0020080016001600272Q004900160016000C0020080017000300302Q003D001700174Q001700170017000B2Q00420018000D4Q00290013001800022Q0042001200133Q00263C001200AD0001002D0004413Q00AD00012Q002D000300023Q0004413Q00AD00010004413Q009A0001001214001000283Q00260E00100087000100010004413Q00870001003018000D0005000600121E001100243Q00202700110011002E00200800130003002600200800140003002F0020080014001400272Q004900140014000C0020080015000300302Q001700150015000B2Q00420016000D4Q00290011001600022Q0042000E00113Q001214001000213Q0004413Q00870001001214000F00283Q000E43002800030001000F0004413Q00030001000E43002800DC000100020004413Q00DC000100121E001000314Q0042001100094Q00030010000200120004413Q00D0000100200800150014003200260E001500D00001000F0004413Q00D00001002027001500140033001214001700344Q0029001500170002000639001500D0000100010004413Q00D000012Q002D001400023Q00061A001000C7000100020004413Q00C7000100121E001000353Q00200800100010001A001214001100364Q00470010000200022Q0042000A00103Q00103B000A002F000500103B000A00370006003018000A0038000B003018000A00390021001214000200023Q00260E00020002000100010004413Q0002000100121E001000083Q00200800100010000900200800100010000A0020270010001000330012140012000F4Q00290010001200022Q0042000300103Q000639000300E9000100010004413Q00E900012Q000D001000104Q002D001000023Q00121E001000083Q00200800100010003A00202700100010003B2Q0042001200014Q00290010001200022Q0042000400103Q00200800053Q003C00121E001000083Q00200800100010003D0020270010001000330012140012003E4Q0029001000120002000613001000F800013Q0004413Q00F8000100202800050005000200200800063Q003F001214000200213Q0004413Q000200010004413Q000300010004413Q000200012Q001D3Q00017Q00063Q00028Q0003123Q00506F696E74546F4F626A656374537061636503013Q0058027Q004003013Q005903013Q005A032E3Q001214000300014Q000D000400043Q00260E00030002000100010004413Q000200010020270005000100022Q004200076Q00290005000700022Q0042000400053Q0020080005000400030020080006000200032Q003D000600063Q00200B00060006000400063F00060029000100050004413Q0029000100200800050004000300200800060002000300200B00060006000400063F00050029000100060004413Q002900010020080005000400050020080006000200052Q003D000600063Q00200B00060006000400063F00060029000100050004413Q0029000100200800050004000500200800060002000500200B00060006000400063F00050029000100060004413Q002900010020080005000400060020080006000200062Q003D000600063Q00200B00060006000400063F00060029000100050004413Q0029000100200800050004000600200800060002000600200B00060006000400062B00050002000100060004413Q002A00012Q004800056Q003A000500014Q002D000500023Q0004413Q000200012Q001D3Q00017Q00",
    getfenv_2(),
    ...
)
