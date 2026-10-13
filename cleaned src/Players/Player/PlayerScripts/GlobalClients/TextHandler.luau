local text_chat_service = game:GetService("TextChatService")
local players = game:GetService("Players")
text_chat_service.OnIncomingMessage = function(argument)
    local text_chat_message_properties = Instance.new("TextChatMessageProperties")
    if argument.TextSource and players:GetPlayerByUserId(argument.TextSource.UserId):GetAttribute("IsVIP") then
        text_chat_message_properties.PrefixText = "<font color='#FFD700'>[VIP]</font> " .. argument.PrefixText
    end
    return text_chat_message_properties
end
