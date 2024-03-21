local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")

local canary = require(game.ReplicatedStorage.Packages.canaryengine)

local server = canary.Server()

local function PlayerInvited(Data, Sent)
    local Player, FactionName = table.unpack(Data)
    local plyrs = Players:GetPlayers()

    for i = 1, #plyrs do
        if plyrs[i].UserId == Player then
        end
    end
end

local function UpdateFactionCache(Data, Sent)
end

local function KickedOrBanned(Data, Sent)
end