local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

if RunService:IsServer() then
	if not ReplicatedStorage:FindFirstChild("ReliableRedEvent") then
		local ReliableRemote = Instance.new("RemoteEvent")
		ReliableRemote.Name = "ReliableRedEvent"
		ReliableRemote.Parent = ReplicatedStorage
	end

	if not ReplicatedStorage:FindFirstChild("UnreliableRedEvent") then
		local UnreliableRemote = Instance.new("UnreliableRemoteEvent")
		UnreliableRemote.Name = "UnreliableRedEvent"
		UnreliableRemote.Parent = ReplicatedStorage
	end

	require(script.Net).Server.Start()
else
	ReplicatedStorage:WaitForChild("ReliableRedEvent")
	ReplicatedStorage:WaitForChild("UnreliableRedEvent")

	require(script.Net).Client.Start()
end

return {
	Server = require(script.Net).Server,
	Client = require(script.Net).Client,
	Identifier = require(script.Identifier),
}