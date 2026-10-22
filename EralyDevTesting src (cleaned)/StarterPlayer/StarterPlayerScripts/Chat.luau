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

    for index = 1, #argument do
        local byte_result = string.byte(argument:sub(index, index))
        local sum = #argument - index + 1

        if #argument % 2 == 1 then
            sum -= 1
        end

        if sum % 4 >= 2 then
            byte_result = -byte_result
        end

        number += byte_result
        local _ = index
    end

    return values[number % #values + 1]
end

function text_chat_service.OnIncomingMessage(argument)
    local player = argument.TextSource and players:GetPlayerByUserId(argument.TextSource.UserId)

    if not player then
        return
    end

    local text_chat_message_properties = Instance.new("TextChatMessageProperties")
    local result = get_name_color(player.DisplayName)
    local formatted_text = string.format("#%02X%02X%02X", result.R * 255, result.G * 255, result.B * 255)
    text_chat_message_properties.PrefixText =
        string.format("<font color='%s'>%s</font>", formatted_text, player.DisplayName)
    text_chat_message_properties.Text = argument.Text

    return text_chat_message_properties
end
