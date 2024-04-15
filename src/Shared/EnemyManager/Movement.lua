local Canary = require(game:GetService("ReplicatedStorage").Shared.Packages.Framework)
local RunService = game:GetService("RunService")


local Server = Canary.Server()

local UpdatePos = Server.Network.Event("UpdateEnemyPos", true)

local Movement = {}
Movement.__index = Movement


function Movement.NewPath(waypoints, speed, reverse, key)
    local self = setmetatable({}, Movement)
    self.DistanceTraveled = 0
    self.CurrentPos = Vector3int16.new(0,0,0)
    self.Speed = speed
    self.Waypoints = {}
    self.CurrentWaypoint = 1
    self.Key = key

    table.sort(waypoints, function(a,b)
        local num1,num2 = tonumber(string.gsub(a.Name, "Node", "")), tonumber(string.gsub(b.Name, "Node", ""))
        return (not reverse and a > b) or (reverse and a < b)
    end)

    for i,v in waypoints do
        table.insert(self.Waypoints, v.Position)
    end
end

function Movement:GetPos()
    return self.CurrentPos
end

function Movement:Start()
    local counter = 0

    self.Connection = RunService.Heartbeat:Connect(function(dt)
        counter += 1

        if counter >= 10 then
            UpdatePos:FireAll(self.Position, self.Key)
        end
    end)
end

function Movement:Pause()
    self.Connection:Disconnect()
    self.Connection = nil
end

return Movement