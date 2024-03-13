local Canary = require(game:GetService("ReplicatedStorage").Shared.Packages.canaryengine)
local Players = game:GetService("Players")
repeat
	task.wait()
until script.Parent.Server:GetAttribute("__init") == true

Players.PlayerAdded:Connect(function(plr)
	Canary.Signal("PlayerJoined"):Fire(plr)
end)

Players.PlayerRemoving:Connect(function(plr)
	Canary.Signal("PlayerLeft"):Fire(plr)
end)

for i,v in pairs(game.Players:GetPlayers()) do
	Canary.Signal("PlayerJoined"):Fire(v)
end