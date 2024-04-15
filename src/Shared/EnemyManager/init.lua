local HttpService = game:GetService("HttpService")

local Behavior = script.Behaviors
local Movement = require(script:WaitForChild("Movement"))

local PartTemplate = Instance.new("Part")
PartTemplate.Anchored = true
PartTemplate.CanCollide = false
PartTemplate.Size = Vector3.new(1,1,1)
PartTemplate.Parent = game:GetService("ServerStorage")

local EnemyManager = {}
EnemyManager._EnemyStorage = {}

function EnemyManager.new(EnemyName)
    local self = setmetatable({}, require(Behavior:FindFirstChild(EnemyName)))
    self._Key = #EnemyManager._EnemyStorage + 1
    self._Path = Movement.new(workspace, self.Speed, false, self._Key)
    self._Name = EnemyName

    table.insert(EnemyManager._EnemyStorage, self)

    return self
end