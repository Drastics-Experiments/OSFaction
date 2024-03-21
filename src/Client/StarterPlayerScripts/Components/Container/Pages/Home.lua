local Fusion = require(game:GetService("ReplicatedStorage").Packages.Fusion)
local new = Fusion.New
local children = Fusion.Children
local ref = Fusion.Ref
local val = Fusion.Value

return function(target)
    local gui = new"Frame" {
        Size = UDim2.new(1,0,1,0),
        Transparency = 1,
        Parent = target,

        [children] = {
            new"Frame" {
                Transparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0, 100, 0, 100),

                [children] = {
                    new"ImageLabel" {
                        Position = UDim2.new(-1.297, 0,-0.179, 0),
                        Size = UDim2.new(0, 100, 0, 100),
                        BackgroundTransparency = 1,

                        [children] = {
                            new"UICorner" {
                                CornerRadius = UDim.new(1, 0)
                            },
                            new"UIStroke" {
                                Transparency = 0.6,
                                Thickness = 0.6,
                            },
                            new"TextLabel" {
                                Position = UDim2.new(1.17, 0,0.24, 0),
                                Size = UDim2.new(1.37, 0,0.5, 0),
                                BackgroundTransparency = 1,
                                Text = "Hello, "..game.Players.LocalPlayer.DisplayName,
                                FontFace = Font.fromName("GothamSSM", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
                                TextSize = 25,
                                TextColor3 = Color3.new(1,1,1),
                                TextXAlignment = "Left"
                            },
                            new"TextLabel" {
                                Position = UDim2.new(1.17, 0,0.69, 0),
                                Size = UDim2.new(1.37, 0,0.21, 0),
                                BackgroundTransparency = 1,
                                FontFace = Font.fromName("GothamSSM", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
                                Text = "You are not in a Faction",
                                TextSize = 18,
                                TextTransparency = 0.5,
                                TextColor3 = Color3.new(1,1,1),
                                TextXAlignment = "Left"
                            }
                        }
                    }
                }
            }
        }
    }
end