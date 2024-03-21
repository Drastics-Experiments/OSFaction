local ReplicatedStorage = game:GetService("ReplicatedStorage")
local http = game:GetService("HttpService")
local MemoryStoreService = game:GetService("MemoryStoreService")
local CacheMap = MemoryStoreService:GetSortedMap("FactionsCache")
local RunService = game:GetService("RunService")
local Chat = game:GetService("Chat")

local Packages = ReplicatedStorage.Packages

local DatastoreManager = require(script.Datastore)
local Canary = require(Packages.canaryengine)
local FactionDataTemplate = require(script.FactionTemplate)
local PlayerDataTemplate = require(script.PlayerDataTemplate)

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

local AllowedCharacters = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"," "}

local function IsNameFiltered(sender: Player, Name: string)
    local result = Chat:FilterStringForBroadcast(Name, sender)

    if string.find(result, "#") then
        return true
    end

    local split = string.split(Name, "")
    for i,v in pairs(split) do
        if not table.find(AllowedCharacters, v) then
            return true
        end
    end

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

local function SetDescription(sender: Player, NewDescription: string)
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

local function Kick(sender: Player, PlayerToKick: number)
    local Data = PlayerData[sender.UserId]
    local FactionData = CheckIfCached(Data.Faction)

    if FactionData.Members[sender.UserId] ~= "Owner" then return end
    
end

local function Ban(sender: Player, PlayerToBan: number)
end

local function ChangeRank(sender: Player, PlayerToChange: number, NewRank: "Admin" | "Member")
end

local Connections = {}

local function LoadPlayer(sender: Player)
    local index = DatastoreManager.IndexDatastore("PlayerData", sender.UserId)
    local Data = DatastoreManager.OpenDatastore(index, PlayerDataTemplate())

    Connections[sender.UserId] = RunService.Heartbeat:Connect(function(dt)
        Data.TimeIngame += dt
    end)
end

local function UnloadPlayer(sender: Player)
    local index = DatastoreManager.IndexDatastore("PlayerData", sender.UserId)
    DatastoreManager.Close(index)

    Connections[sender.UserId]:Disconnect()
end