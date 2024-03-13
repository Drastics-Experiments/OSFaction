export type factionT = {
    ID: string,
    Members: {
        [string]: "Owner" | "Admin" | "Member"
    },
    JoinRequests: { [string]: boolean },
    BannedMembers: { [string]: boolean },
    Invites: { [string]: boolean }
}

return function()
    return {
        ID = "",
        Members = {},
        JoinRequests = {},
        BannedMembers = {},
        Invites = {}
    }
end