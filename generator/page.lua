require "utils"
local md = require "md"

local fillvars = {
    content = "$CONTENT",
    title = "$TITLE",
    nav = "$NAV"
}

local function checkFile(file, filename)
    if not(file) then
        error("Couldn't find file '"..filename.."'!")
    else
        print("Found file '"..filename.."'")
    end
end

---generates html from markdown
---@param filename string full path to file
local function fromMD(filename)
    local file = io.open(filename, "r")
    checkFile(file, filename)

    local conv, err = md.renderString(file:read("*all"))
    if err then
        error("[md.lua] Error rendering string: "..err)
    end
    return conv
end

---generates a page from given data
---@param data PageData Page configuration data
---@return string page Filled out page template as a string
function CreatePage(data)
    local template = GetTemplateContents("page")

    template = template:gsub(fillvars.title, data.name)

    local pagetype = {
        ["md"] = fromMD,
        ["html"] = function(filename)
            local file = io.open(filename, "r")
            checkFile(file, filename)
            local cont = file:read("*all")
            file:close()
            return cont
        end
    }

    local contents = pagetype[data.type](data.filename)
    template = template:gsub(fillvars.content, contents)

    local navcont = io.open("navcont.json", "r")
    local navdata = navcont:read("*all")
    navcont:close()
    navdata = json.decode(navdata)
    template = template:gsub("$NAV", GenerateNav(navdata))

    return template
end

---generates a page from given data and saves it to a file
---@param data PageData page config data
---@param filename string filename to save to
function CreateAndExportPage(data, filename)
    local fileconts = CreatePage(data)
    local exitfile = io.open("output/"..filename..".html", "w")
    print("Writing data...")
    exitfile:write(fileconts)
    print("Saving...")
    exitfile:flush()
    exitfile:close()
    print("Saved Successfully!")
end