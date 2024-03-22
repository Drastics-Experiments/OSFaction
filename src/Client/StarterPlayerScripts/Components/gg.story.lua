
local Container = require(script.Parent.Container)

return function(t)

    local s = Container.__init(t)
    local a = Instance.new("Folder")
    for i,v in pairs(s:GetChildren()) do
        v.Parent = a
    end
    a.Parent=t
    return function()
        a:Destroy()
    end
end