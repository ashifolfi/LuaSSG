---@class PageData
---@field name string Friendly name of the page
---@field type string the format of the source data
---@field filename string full path to the source data file


---Attempts to open a template file and returns it's contents
---@param name string template name
---@return string
function GetTemplateContents(name)
    local file = io.open("templates/"..name..".html", "r")
    if not(file) then
        error("Could not find template '"..name.."'")
    end
    local contents = file:read("*all")
    file:close()
    return contents
end

function GenerateNav(data)
    local navdat = ""
    for _,v in ipairs(data.locations) do
        local template = string.gsub(data.template, "$NAME", v[2])
        navdat = navdat..template:gsub("$TARGET", v[1]).."\n"
    end
    return navdat
end