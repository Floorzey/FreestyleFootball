local text_chat_service = game:GetService("TextChatService")
local players = game:GetService("Players")
local values = {
    Color3.fromRGB(253, 41, 67),
    Color3.fromRGB(1, 162, 255),
    Color3.fromRGB(2, 184, 87),
    BrickColor.new("Bright violet").Color,
    BrickColor.new("Bright orange").Color,
    BrickColor.new("Bright yellow").Color,
    BrickColor.new("Light reddish violet").Color,
    BrickColor.new("Brick yellow").Color,
}

local function get_name_color(argument)
    local number = 0
    for n = 1, #argument do
        local byte_result = string.byte(argument:sub(n, n))
        local argument_count_offset_offset = #argument - n + 1
        if #argument % 2 == 1 then
            argument_count_offset_offset -= 1
        end
        if argument_count_offset_offset % 4 >= 2 then
            byte_result = -byte_result
        end
        number += byte_result
    end
    return values[(number % #values) + 1]
end

text_chat_service.OnIncomingMessage = function(argument)
    if argument.TextSource then
        local player = players:GetPlayerByUserId(argument.TextSource.UserId)
        if player then
            local text_chat_message_properties = Instance.new("TextChatMessageProperties")
            local result = get_name_color(player.DisplayName)
            text_chat_message_properties.PrefixText = string.format(
                "<font color='%s'>%s</font>",
                string.format("#%02X%02X%02X", result.R * 255, result.G * 255, result.B * 255),
                player.DisplayName
            )
            text_chat_message_properties.Text = argument.Text
            return text_chat_message_properties
        end
    end
end
