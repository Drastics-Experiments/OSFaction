local Fusion = require(game:GetService("ReplicatedStorage").Packages.Fusion)
local new = Fusion.New
local children = Fusion.Children
local ref = Fusion.Ref
local val = Fusion.Value
local spring = Fusion.Spring
local observer = Fusion.Observer

local HomePos = val(UDim2.new(0,0,-1,0))
local HomeSpring = spring(HomePos, 10, 0.9)
local HomeObserve = observer(HomeSpring)



local Container = require(script.Parent.Container)
local Home = require(script.Parent.Container.Pages.Home)

local PageManager = {}

local function SwapPage(Page)
end

local function __init()
    local gui = Container.__init(game.Players.LocalPlayer.PlayerGui)
    local hpage = Home(gui)
    HomeSpring:set(UDim2.new(0,0,0,0))
    local disconnect = HomeObserve:onChange(function()
        hpage.Container.Position = HomeSpring:get()
    end)
    
end