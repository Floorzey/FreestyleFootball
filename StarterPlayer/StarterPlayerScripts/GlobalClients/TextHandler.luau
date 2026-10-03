--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/GlobalClients/TextHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:04
--]]

local TextChatService_1 = game:GetService("TextChatService")
local Players_upv_1 = game:GetService("Players")
TextChatService_1.OnIncomingMessage = function(a1)
    --[[
      line: 5
      upvalues:
        Players_upv_1 (copy, index: 1)
    ]]
    local v1 = Instance.new("TextChatMessageProperties")
    if a1.TextSource and Players_upv_1:GetPlayerByUserId(a1.TextSource.UserId):GetAttribute("IsVIP") then
        v1.PrefixText = "<font color='#FFD700'>[VIP]</font> " .. a1.PrefixText
    end
    return v1
end