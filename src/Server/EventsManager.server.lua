--[[
			PURPOSE OF THIS SCRIPT

	the main script doesnt get to the playeradded 
	connection before the first player joins (in studio)
	and i dont want the code to look stupid with a connection and
	function in between a bunch of variables
]]

local Canary = require(game:GetService("ReplicatedStorage").Packages.canaryengine)
local Players = game:GetService("Players")
repeat
	task.wait()
until script.Parent.Main:GetAttribute("__init") == true

Players.PlayerAdded:Connect(function(plr)
	Canary.Signal("PlayerJoined"):Fire(plr)
end)

Players.PlayerRemoving:Connect(function(plr)
	Canary.Signal("PlayerLeft"):Fire(plr)
end)

for i,v in pairs(game.Players:GetPlayers()) do
	Canary.Signal("PlayerJoined"):Fire(v)
end
