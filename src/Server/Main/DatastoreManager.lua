local Packages = game:GetService("ReplicatedStorage").Shared.Packages
local canary = require(Packages.canaryengine)
local Server = canary.Server()

local Datastore = require(script.Parent.Datastore)

local __DatastoreName = "TestingFactions"
local DatastoreManager = {}
local Stores = {} :: {
    [string]: Datastore.DataStore | {
        [string]: Datastore.DataStore
    }
}
-- Stores.Scope = {
--    key = 1
--  }

function DatastoreManager.IndexDatastore(scope: string, key: string): Datastore.DataStore
    local found = Datastore.find(__DatastoreName, scope, key)

    if found then
        return found
    end

    return Datastore.new(__DatastoreName, scope, key)
end

function DatastoreManager.OpenDatastore(path: string | Datastore.DataStore, template: any)
    local Data
    if typeof(path) == "string" then
        path = string.split(path, "/")
        Data = Stores
    
        for i, v in ipairs(path) do
            Data = Data[v]
        end
    else
        Data = path
    end
    
    while Data:Open(template) ~= "Success" do
        task.wait(2.5)
    end

    Data.ProcessQueue:Connect(function(id, vals, datastore)
        if datastore:Remove(id) ~= "Success" then return end

        for i,v in pairs(vals) do
            datastore[i][v[1]] = v[2]
        end
    end)

    return Data
end

function DatastoreManager.ReadDatastore(path: string | Datastore.DataStore)
    local Data
    if typeof(path) == "string" then
        path = string.split(path, "/")
        Data = Stores
    
        for i, v in ipairs(path) do
            Data = Data[v]
        end
    else
        Data = path
    end

    while Data:Read() ~= "Success" do
        task.wait(2.5)
    end

    return Data.Value
end

function DatastoreManager.QueueIfFail(path: string | Datastore.DataStore)
    local result
    local Data: Datastore.DataStore

    if typeof(path) ~= 'string' then
        Data = path
        result = path:Open()
    elseif typeof(path) == 'string' then

    end

    if result == "Success" then
        return "Success"
    end

    return "Queue"
end

function DatastoreManager.Close(path: string | Datastore.DataStore)
    if typeof(path) == "string" then
        local Data = Datastore.find(table.unpack(string.split(path, "/")))
        if Data then Data:Close() end
    end
end

return DatastoreManager