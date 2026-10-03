--[[
    Script Path: Game/Players/Player/PlayerScripts/Chat
    Class: LocalScript
    Time: 2026-10-03 12:27:02
--]]

local TextChatService_1 = game:GetService("TextChatService")
local Players_upv_1 = game:GetService("Players")
local tbl_upv_1 = {Color3.fromRGB(253, 41, 67), Color3.fromRGB(1, 162, 255), Color3.fromRGB(2, 184, 87), BrickColor.new("Bright violet").Color, BrickColor.new("Bright orange").Color, BrickColor.new("Bright yellow").Color, BrickColor.new("Light reddish violet").Color, BrickColor.new("Brick yellow").Color}
local function GetNameColor(a1)
    --[[
      name: GetNameColor
      line: 15
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v1 = 0
    for n_1 = 1, #a1 do
        local v2 = string.byte(a1:sub(n_1, n_1))
        local v3 = #a1 - n_1 + 1
        if #a1 % 2 == 1 then
            v3 = v3 - 1
        end
        if v3 % 4 >= 2 then
            v2 = -v2
        end
        v1 = v1 + v2
    end
    return tbl_upv_1[(v1 % #tbl_upv_1) + 1]
end
TextChatService_1.OnIncomingMessage = function(a1)
    --[[
      line: 32
      upvalues:
        Players_upv_1 (copy, index: 1)
        GetNameColor (copy, index: 2)
    ]]
    if a1.TextSource then
        local v4 = Players_upv_1:GetPlayerByUserId(a1.TextSource.UserId)
        if v4 then
            local v5 = Instance.new("TextChatMessageProperties")
            local v6 = GetNameColor(v4.DisplayName)
            v5.PrefixText = string.format("<font color='%s'>%s</font>", string.format("#%02X%02X%02X", v6.R * 255, v6.G * 255, v6.B * 255), v4.DisplayName)
            v5.Text = a1.Text
            return v5
        end
    end
end