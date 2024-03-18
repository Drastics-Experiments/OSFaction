local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")

local canary = require(game.ReplicatedStorage.Shared.Packages.canaryengine)

local server = canary.Server()
local function Network(name)
    return server.Network.Function(name, true)

end

MessagingService:SubscribeAsync("PlayerInvited", function(UserId: number, Faction: string, State: boolean)
    local plrs = Players:GetPlayers()

    for i = 1, #plrs do
        if plrs[i].UserId == UserId then
            canary.Signal("GetUpdatedFaction"):Fire(Faction)
        end
    end
end)

MessagingService:SubscribeAsync("FactionStateUpdated", function(FactionID: string)
    
end)

canary.Signal("MessagingPublish"):Connect(function(topic, args)
    MessagingService:PublishAsync(topic, args)
end)