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

local function UpdateReading()
    if os.clock() - LastReadTime > 5 then
        LastReadTime = os.clock()
		local CurrentRead = NameStore:Read().Value
		
        if CurrentRead ~= nil then
            LastRead = CurrentRead
        end
    end
end

Create:OnInvoke(function(sender: Player, FactionID: string)
    if string.len(FactionID) > 5 then return end
    UpdateReading()

    if LastRead[FactionID] then return end

    local NewFaction = Manager.IndexDatastore("Factions", FactionID)
    if Manager.ReadDatastore(NewFaction) == nil then
        Manager.OpenDatastore(NewFaction, Template())
        Manager.OpenDatastore(NameStore, {})
    end

    NewFaction.Value.Members[sender.UserId] = "Owner"
    NameStore.Value[FactionID] = true
    CurrentFactions[FactionID] = NewFaction.Value

    NameStore:Close()
    NewFaction:Close()
end)

Join:OnInvoke(function(player, FactionID)
    local data = Manager.IndexDatastore("PlayerData", player.UserId).Value
    if data.Faction ~= "None" then return end
    if data.JoinRequests[FactionID] then return end
    UpdateReading()

    local RegisteredFaction = Manager.IndexDatastore("Factions", FactionID)
    local Read = Manager.ReadDatastore(RegisteredFaction) :: Template.factionT
    if Read == nil then return end
    if Read.JoinRequests[player.UserId] then return end
    Manager.OpenDatastore(RegisteredFaction)

    local FactionValue = RegisteredFaction.Value :: Template.factionT
    FactionValue.JoinRequests[player.UserId] = true
    data.JoinRequests[FactionID] = true

    Map:SetAsync(FactionID, FactionValue, 10000)
    RegisteredFaction:Close()
end)

Invite:OnInvoke(function(player, UserId)
    local data = Manager.IndexDatastore("PlayerData", player.UserId).Value
    if data.Faction == "None" then return end
    local invitedPLayer = Manager.IndexDatastore("PlayerData", UserId)
end)

Leave:OnInvoke(function(player)
    local data = Manager.IndexDatastore("PlayerData", player.UserId).Value
    if data.Faction == "None" then return end
    UpdateReading()
end)

local __Template = {
	Faction = "None",
    JoinRequests = {},
    Invites = {},
	TimeIngame = 0
}

canary.Signal("PlayerJoined"):Connect(function(player)
    local Data = Manager.IndexDatastore("PlayerData", player.UserId)

    Manager.OpenDatastore(Data, __Template)

	local FactionName = Data.Value.Faction
	print(Data.Value)
	if FactionName ~= "None" then
		if not Map:GetAsync(FactionName) then
			local RegisteredFaction = Manager.IndexDatastore("Factions", FactionName)
			Map:SetAsync(FactionName, Manager.ReadDatastore(RegisteredFaction), 10000)
		end
	end
end)


canary.Signal("PlayerLeft"):Connect(function(player)

end)

script:SetAttribute("__init", true)