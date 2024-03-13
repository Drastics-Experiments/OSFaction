local MessagingService = game:GetService("MessagingService")

MessagingService:SubscribeAsync("PlayerInvitesUpdated", function(UserId: number, Faction: string, State: boolean)
    
end)

MessagingService:SubscribeAsync("FactionStateUpdated", function(FactionID: string)
    
end)

