export type factionT = {
    ID: string,
    CurrentName: string,
    PastNames: { string },
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
        Invites = {},
        CurrentName = "",
        ForceJoinRequest = true,
        PastNames = {}
    }
end