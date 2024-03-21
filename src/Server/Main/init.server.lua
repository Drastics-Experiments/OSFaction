local ReplicatedStorage = game:GetService("ReplicatedStorage")
local http = game:GetService("HttpService")
local MemoryStoreService = game:GetService("MemoryStoreService")
local CacheMap = MemoryStoreService:GetSortedMap("FactionsCache")

local Packages = ReplicatedStorage.Packages

local DatastoreManager = require(script.Datastore)
local Canary = require(Packages.canaryengine)
local FactionDataTemplate = require(script.FactionTemplate)

local Server = Canary.Server()

local PlayerData = {}
local Cache = {}

local function CheckIfCached(factionID: string)
    local localCache = nil
    
    local mapResult, response = pcall(function()
        localCache = CacheMap:GetAsync(factionID)
    end)

    if not localCache then 
        local index = DatastoreManager.IndexDatastore("Factions", factionID)
        localCache = DatastoreManager.ReadDatastore(index)
        if localCache then
            pcall(function()
                CacheMap:SetAsync(localCache.ID, localCache, 10000)
            end)
        end
    end

    return localCache
end

local NameReadHistory = {}
local function checkNameUsed(factionName: string)
    if not NameReadHistory[factionName] then
        local index = DatastoreManager.IndexDatastore("Storage", "AllNames")
        NameReadHistory = DatastoreManager.ReadDatastore(index)
        if not NameReadHistory[factionName] then return end
    end
    return NameReadHistory[factionName]
end

local function CanCreate(sender: Player)
    if PlayerData[sender.UserId].Faction == "None" then
        return true
    end
    return false
end

local function IsNameFiltered(Name: string)
    return false
end

local function Create(sender: Player, Name: string)
    if not CanCreate(sender) then return "denied" end
    if IsNameFiltered(Name) then return "Name was filtered" end
    if not checkNameUsed(Name) then return "Name is already Taken" end
    
    local id = http:GenerateGUID(false)
    local DataTable = FactionDataTemplate() :: FactionDataTemplate.factionT
    
    DataTable.Members[sender.UserId] = "Owner"
    DataTable.ID = id
    DataTable.CurrentName = Name

    local newfaction = DatastoreManager.IndexDatastore("Factions", id)
    DatastoreManager.OpenDatastore(newfaction, DataTable):Close()
end

local function ChangeName(sender: Player, Name: string)
    local PlayerFaction =  PlayerData[sender.UserId].Faction
    if PlayerFaction == "None" then return "Not in a faction" end
    
    local IsCached = CheckIfCached(PlayerFaction)
    if not IsCached then return "FAILED: Unknown Error" end
    
    local rank = IsCached.Members[sender.UserId]
    if rank ~= "Owner" and rank ~= "Admin" then return "not high enough rank" end
    if IsNameFiltered(Name) then return "Name is filtered" end
    if checkNameUsed(Name) then return "Name is taken." end

    local index = DatastoreManager.IndexDatastore("Factions", IsCached.ID)
    local Data = DatastoreManager.OpenDatastore(index)
    table.insert(Data.PastNames, Data.CurrentName)
    Data.CurrentName = Name
    Data:Close()
end

local function Invite(sender: Player, recipiant: number)
end

local function Join(sender: Player, Faction: string)
    local Data = PlayerData[sender.UserId]
    if Data.Faction ~= "None" then return end

    local FactionData = CheckIfCached(Faction)

    if Data.Invites[Faction] then
        local OpenedData = DatastoreManager.OpenDatastore("Factions", Faction)
        OpenedData.Members[sender.UserId] = true
        Data.Faction = Faction
        return "Success!"
    end

    FactionData.JoinRequests[sender.UserId] = true
    
end

local function Leave(sender: Player)
    local Data = PlayerData[sender.UserId]
    if Data.Faction == "None" then return end

    local FactionData = CheckIfCached(Data.Faction)
    local StoredFactionData = DatastoreManager.OpenDatastore("Factions", FactionData.ID)
    local LeavingMember = StoredFactionData.Members[sender.UserId]

    if LeavingMember ~= "Owner" then
        StoredFactionData.Members[sender.UserId] = nil
        Data.Faction = nil
        pcall(function()
            CacheMap:SetAsync(StoredFactionData.ID, StoredFactionData, 10000)
        end)
    end
end