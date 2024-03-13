local Packages = game:GetService("ReplicatedStorage").Shared.Packages
local MemoryStoreService = game:GetService("MemoryStoreService")
local Map = MemoryStoreService:GetSortedMap("Factions")
local Players = game:GetService("Players")

local Template = require(script.FactionTemplate)
local canary = require(Packages.canaryengine)
local Datastore = require(script.Datastore)
local Manager = require(script.DatastoreManager)

local __DatastoreName = "TestingFactions"

local NameStore = Manager.IndexDatastore("Storage", "Names")

local DataCache = {}
local CurrentFactions = {}

if Manager.ReadDatastore(NameStore) == nil then
	Manager.OpenDatastore(NameStore, {})
    NameStore:Close()
end

local LastRead, LastReadTime = {}, 0

local Server = canary.Server()

local Create = Server.Network.Function("Create", true)
local Invite = Server.Network.Function("Invite", true)
local Join = Server.Network.Function("Join", true)
local Kick = Server.Network.Function("Kick", true)
local Ban = Server.Network.Function("Ban", true)
local Leave = Server.Network.Function("Leave", true)


local GetFactions = Server.Network.Function("GetFactions", true)

Create:OnInvoke(function(sender: Player, FactionID: string)
    if string.len(FactionID) > 5 then return end

    if os.clock() - LastReadTime > 5 then
        LastReadTime = os.clock()
		local CurrentRead = NameStore:Read().Value
		
        if CurrentRead ~= nil then
            LastRead = CurrentRead
        end
    end
    
    if LastRead[FactionID] then return end

    local NewFaction = Manager.IndexDatastore("Factions", FactionID)
    if Manager.ReadDatastore(NewFaction) == nil then
        Manager.OpenDatastore(NewFaction, Template())
        Manager.OpenDatastore(NameStore, {})
    end

    NewFaction.Value.Members[sender.UserId] = "Owner"
    DataCache[sender.UserId].Faction = FactionID
    NameStore.Value[FactionID] = true
    CurrentFactions[FactionID] = NewFaction.Value

    NameStore:Close()
    NewFaction:Close()
end)

Create:SetRateLimit(5, 10, function(sender)
    --TODO
    print("RATELIMIT REACHED")
end)


Join:OnInvoke(function(sender)
    
end)

local __Template = {
	Faction = "None",
	TimeIngame = 0
}

canary.Signal("PlayerJoined"):Connect(function(player)
    local Data = Manager.IndexDatastore("PlayerData", player.UserId)

    Manager.OpenDatastore(Data, {
        Faction = "None",
    })

	local FactionName = Data.Value.Faction
	print(DataCache[player.UserId])
	if FactionName ~= "None" then
		if not Map:GetAsync(FactionName) then
			local RegisteredFaction = Datastore.new(__DatastoreName, "Factions", FactionName)
			Map:SetAsync(FactionName, RegisteredFaction:Read().Value, 10000)
		end
	end
end)


canary.Signal("PlayerLeft"):Connect(function(player)
	if DataCache[player.UserId] then
		DataCache[player.UserId]:Close()
		DataCache[player.UserId] = nil
	end
end)

script:SetAttribute("__init", true)