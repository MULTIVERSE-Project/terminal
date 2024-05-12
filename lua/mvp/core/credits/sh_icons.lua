mvp = mvp or {}
mvp.credits = mvp.credits or {}

mvp.credits.iconsList = mvp.credits.iconsList or {}

function mvp.credits.AddIcon( icon, name, authorName, authorUrl)
    if (type(icon) ~= "IMaterial" and not icon.isImage) then
        icon = Material(icon,"smooth mips")
    end

    local isImage = false
    if (icon.isImage) then
        icon = icon.name
        isImage = true
    end
    
    mvp.credits.iconsList[#mvp.credits.iconsList + 1] = {
        icon = icon,
        isImage = isImage,
        name = name,
        author = {
            name = authorName,
            url = authorUrl
        }
    }
end

function mvp.credits.GetIcons()
    return mvp.credits.iconsList
end

function mvp.credits.ClearIcons()
    mvp.credits.iconsList = {}
end