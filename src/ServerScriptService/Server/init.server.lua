local Packages = game:GetService("ReplicatedStorage").Shared.Packages
local MemoryStoreService = game:GetService("MemoryStoreService")
local Map = MemoryStoreService:GetSortedMap("Factions")
local Players = game:GetService("Players")

local Template = require(script.FactionTemplate)
local canary = require(Packages.canaryengine)
local Datastore = require(script.Datastore)

local __DatastoreName = "TestingFactions"

local NameStore = Datastore.new(__DatastoreName, "Storage", "Names")

local DataCache = {}
local CurrentFactions = {}

if NameStore:Read().Value == nil then
	NameStore:Open({})
    NameStore:Close()
end

local LastRead, LastReadTime = {}, 0

local Server = canary.Server()
local Create = Server.Network.Function("CreateFaction", true)

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

    local NewFaction = Datastore.new(__DatastoreName, "Factions", FactionID)
    local NewFactionStatus = ""
    local NameStoreStatus = ""
    local T = Template()

    repeat
        if NewFactionStatus ~= "Success" then
            NewFactionStatus = NewFaction:Open(T)
        end

        if NameStoreStatus ~= "Success" then
            NameStoreStatus = NameStore:Open()
        end
        task.wait(1)
    until NameStoreStatus == "Success" and NewFactionStatus == "Success"


    NewFaction.Value.Members[sender.UserId] = "Owner"
    DataCache[sender.UserId].Faction = FactionID
    NameStore.Value[FactionID] = true
    CurrentFactions[FactionID] = NewFaction.Value

    NameStore:Close()
    NewFaction:Close()

    print(CurrentFactions)
    print(LastRead)
end)

Create:SetRateLimit(5, 10, function(sender)
    --TODO
    print("RATELIMIT REACHED")
end)


local __Template = {
	Faction = "None",
	TimeIngame = 0
}

canary.Signal("PlayerJoined"):Connect(function(player)
	DataCache[player.UserId] = Datastore.new(__DatastoreName, "PlayerData", player.UserId)
	local PlrCache = DataCache[player.UserId]
	repeat
		print("Yield")
		task.wait(5)
	until PlrCache:Open(__Template) == "Success"

	local FactionName = PlrCache.Value.Faction
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