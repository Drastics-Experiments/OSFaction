local run = game:GetService("RunService")

local Canary = require(script.Parent.Packages.canaryengine)
local Platform = if run:IsServer() then Canary.Server() else Canary.Client()

local function event(name: string)
    return Platform.Network.Event(name, true)
end

local function func(name: string)
    return Platform.Network.Function(name, true)
end

return {
    Create = func("Create"),
    Kick = func("Kick"),
}