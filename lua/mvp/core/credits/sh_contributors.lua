mvp = mvp or {}
mvp.credits = mvp.credits or {}

mvp.credits.contributorsList = mvp.credits.contributorsList or {}

function mvp.credits.AddContributor(steamId, name, role)
    mvp.credits.contributorsList[#mvp.credits.contributorsList + 1] = {
        name = name, 
        role = role, 
        steamId = steamId
    }
end

function mvp.credits.GetContributors()
    return mvp.credits.contributorsList
end