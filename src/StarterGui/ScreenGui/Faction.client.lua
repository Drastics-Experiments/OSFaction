local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage.Shared
local Packages = Shared.Packages
local plr = Players.LocalPlayer

--> UI VARS
local Container = script.Parent.Container
local Home = Container.Home

local PlayerImage = Home.PlayerImage
PlayerImage.Image = game.Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)