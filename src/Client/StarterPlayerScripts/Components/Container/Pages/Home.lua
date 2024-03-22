local Fusion = require(game:GetService("ReplicatedStorage").Packages.Fusion)
local new = Fusion.New
local children = Fusion.Children
local ref = Fusion.Ref
local val = Fusion.Value
local event = Fusion.OnEvent

return function(target, props)
    local container = val()
    local button1 = val()
    local button2 = val()

    local scale=val()
    local toval = val(1)
    local spring = spring(scale, 10, 0.9)
    local observeing = observe(spring)

    local scale2 = val()

    local gui = new"Frame" {
        Size = UDim2.new(1,0,1,0),
        Transparency = 1,
        Parent = target,
        [ref] = container,

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
                                Color = Color3.fromRGB(255, 255, 255),
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border

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
                    },
                }
            },

            new"TextButton" {
                BackgroundColor3 = Color3.fromRGB(34, 34, 34),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(255,255,255),
                Position = UDim2.new(0.018, 0,0.821, 0),
                Size = UDim2.new(0.466, 0,0.151, 0),
                FontFace = Font.fromName("GothamSSM", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal),
                TextTransparency = 0.5,
                Text = "Create Faction",
                [ref] = button2,
                [event "Activated"] = props.Page1,

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
                    new"UIScale" {
                        [ref] = scale
                        [event "MouseEnter"] = function()
                            toval:set(1.2)
                            local disconnect = observeing:OnChange(function()
                                scale:get().Scale = spring:get()
                            end)
                            repeat task.wait() until spring:get() == toval:get()

                            disconnect()
                        end
                    }
                }
            },
            new"TextButton" {
                BackgroundColor3 = Color3.fromRGB(34, 34, 34),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(255,255,255),
                Position = UDim2.new(0.518, 0,0.817, 0),
                Size = UDim2.new(0.466, 0,0.151, 0),
                FontFace = Font.fromName("GothamSSM", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal),
                TextTransparency = 0.5,
                Text = "Other Factions",
                [ref] = button1,
                [event "Activated"] = props.Page2,
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
            },
        }
    }

    return {
        Container = container:get(),
        Browser = button1:get(),
        ExtraButton = button2:get()
    }
end