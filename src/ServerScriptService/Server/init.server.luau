local ReplicatedStorage = game:GetService("ReplicatedStorage")
local http = game:GetService("HttpService")
local MemoryStoreService = game:GetService("MemoryStoreService")
local CacheMap = MemoryStoreService:GetSortedMap("FactionsCache")

local Shared = ReplicatedStorage.Shared
local Packages = Shared.Packages

local DatastoreManager = require(script.DatastoreModule)
local Canary = require(Packages.canaryengine)
local FactionDataTemplate = require(script.FactionTemplate)

local Server = Canary.Server()

local PlayerData = {}
local Cache = {}

local function CheckIfCached(factionID: string)
    local localCache = Cache[factionID]

    if not localCache then
        local mapResult, response = pcall(function()
            localCache = CacheMap:GetAsync(factionID)
        end)
    end

    if not localCache then 
        DatastoreManager.IndexDatastore("")
    
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
    DatastoreManager.OpenDatastore(newfaction, DataTable)
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

local function Invite(sender: Player, recipiant: Number)
    

end