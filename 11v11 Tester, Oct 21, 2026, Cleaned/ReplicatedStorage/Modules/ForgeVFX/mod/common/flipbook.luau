local run_service = game:GetService("RunService")
local collection_service = game:GetService("CollectionService")
local flipbook = {
    serialize = function(argument: table)
        local create_result = buffer.create(#argument * 8)

        for key, item in argument do
            buffer.writef64(create_result, (key - 1) * 8, item)
        end

        return create_result
    end,

    deserialize = function(fromstring_result)
        if typeof(fromstring_result) == "string" then
            fromstring_result = buffer.fromstring(fromstring_result) or fromstring_result
        end

        local items = {}

        for index = 0, buffer.len(fromstring_result) / 8 - 1 do
            local readf64_result = buffer.readf64(fromstring_result, index * 8)
            table.insert(items, readf64_result)
            local _ = index
        end

        return items
    end,

    isLocalFlipbook = function(argument: userdata)
        if not run_service:IsStudio() then
            return false
        end

        for _, item in collection_service:GetTags(argument) do
            if item:match("^_local_flipbook_") then
                return true
            end
        end

        return false
    end,
}

function flipbook.getTexturePrefix(argument: userdata)
    return flipbook.isLocalFlipbook(argument) and "rbxtemp://" or "rbxassetid://"
end

function flipbook.getFlipbookData(argument: userdata)
    if not argument:GetAttribute("FlipbookEnabled") then
        return nil
    end

    local attribute = argument:GetAttribute("FlipbookTextures")

    if not attribute then
        return nil
    end

    local deserialize_result = flipbook.deserialize(attribute)

    if #deserialize_result == 0 then
        return nil
    end

    return deserialize_result
end

function flipbook.getChangeDuration(argument: table)
    local duration = argument.duration

    if argument.ref:GetAttribute("SyncDuration") then
        duration = argument.effectDuration
    end

    return duration
end

function flipbook.createUpdateCallback(argument: table)
    local texture_prefix = flipbook.getTexturePrefix(argument.ref)

    return function(argument_2, argument_3)
        local rounded_value = math.round(#argument.frames * argument_2)
        local maximum = math.max(rounded_value, 1)
        argument.setTexture(`{texture_prefix}{argument.frames[maximum]}`)

        return argument_3 * argument.getSpeed()
    end
end

return flipbook
