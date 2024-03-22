local Fusion = require(game:GetService("ReplicatedStorage").Packages.Fusion)
local new = Fusion.New
local children = Fusion.Children
local ref = Fusion.Ref
local val = Fusion.Value
local event = Fusion.OnEvent

return function(props)
    return new"TextButton" {
        BackgroundColor3 = Color3.fromRGB(34, 34, 34),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255,255,255),
        Position = props.Position,
        Size = props.Size,
        FontFace = Font.fromName("GothamSSM", Enum.FontWeight[props.Weight], Enum.FontStyle.Normal),
        TextTransparency = 0.5,
        Text = props.Text,
        [children] = {
            new"UICorner" {
                CornerRadius = UDim.new(0, 5)
            },
            new"UIStroke" {
                Transparency = 0.6,
                Thickness = 0.6,
                Color = Color3.fromRGB(255, 255, 255),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            },
        }
    }
end