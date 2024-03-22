local Fusion = require(game:GetService("ReplicatedStorage").Packages.Fusion)
local new = Fusion.New
local children = Fusion.Children
local ref = Fusion.Ref
local val = Fusion.Value

local function stroke()
    return new"UIStroke" {
        Transparency = 0.6,
        Thickness = 0.6,
        Color = Color3.fromRGB(255, 255, 255),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, new"UICorner" {
        CornerRadius = UDim.new(1,0)
    }
end
return function(target, props)
    local gui =  new"Frame" {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Transparency = 1,
        Parent = target,
        
        [children] = {
            new"TextButton" {
                Size = UDim2.new(0.143, 0,0.078, 0),
                Position = UDim2.new(0.028, 0,0.048, 0),
                BackgroundTransparency = 1,
                Text = "Global",
                TextColor3 = Color3.fromRGB(255,255,255),
                FontFace = Font.fromName("GothamSSM", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal),
                [children] = {
                    stroke(),

                }
			},
            new"TextButton" {
                Size = UDim2.new(0.15, 0,0.078, 0),
                Position = UDim2.new(0.186, 0,0.048, 0),
                BackgroundTransparency = 1,
                Text = "Server",
                TextColor3 = Color3.fromRGB(255,255,255),
                FontFace = Font.fromName("GothamSSM", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal),
                [children] = {
                    stroke(),
                }
			},
            new"TextBox" {
                Size = UDim2.new(0.504, 0,0.078, 0),
                Position = UDim2.new(0.357, 0,0.048, 0),
                BackgroundTransparency = 0.8,
                TextTransparency = 0.5,
                BackgroundColor3 = Color3.new(0,0,0),
                PlaceholderText = "Search",
                FontFace = Font.fromName("GothamSSM", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal),

                [children] = {stroke()}
            },
			new"ScrollingFrame" {
				Size = UDim2.new(1, 0,0.833, 0),
				Position = UDim2.new(0, 0,0.167, 0),
				Transparency = 1,
				ClipsDescendants = true,
				[children] = {
					new"UIGridLayout" {
						CellPadding = UDim2.new(0, 10,0, 10),
						CellSize = UDim2.new(0.45, 0,0, 60),
						FillDirection = "Horizontal",
						StartCorner = "TopLeft",
                        HorizontalAlignment = "Center"
					},
					new"UIPadding" {
						PaddingTop = UDim.new(0, 1)
					}
				}
			}
        }
	}
	return gui
end