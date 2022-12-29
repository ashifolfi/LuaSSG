require "utils"

local fillvars = {
    title = "$TITLE",
    files = "$FILES"
}

function CreateFilelist(data)
    local docs = {}

    local function createDoc(files, name)
        if not(docs[name]) then
            docs[name] = {
                html = ""
            }
        end

        for k,v in pairs(files) do
            if v.type == "directory" then
                docs[name..'_'..k] = {html = ""}
                docs[name..'_'..k].html = '<a href="'..name..'.html"><li>'..
                '<img style="vertical-align:middle"'..
                ' src="/resources/images/icons/folder-full.png" width=48 height=48>..</li></a>\n'

                createDoc(v.files, name.."_"..k)

                docs[name].html = docs[name].html..
'<a href="'..name..'_'..k..'.html"><li>'..
'<img style="vertical-align:middle" src="/resources/images/icons/folder-full.png" width=48 height=48>'..k..'</li></a>\n'
            else
                docs[name].html = docs[name].html..
                '<a href="'..v.filepath..'"><li>'..
                '<img style="vertical-align:middle" src="/resources/images/icons/'..
                v.filetype..'.png" width=48 height=48>'..k..'</li></a>\n'
            end
        end
    end

    createDoc(data.files, "index")

    for k,v in pairs(docs) do
        local file = io.open("output/filelist/"..k..".html", "w")

        if not(file) then
            os.execute("mkdir output/")
            os.execute("mkdir output/filelist")
            file = io.open("output/filelist/"..k..".html", "w")
        end

        local template = GetTemplateContents("filelist")

        template = template:gsub(fillvars.title, k)
        template = template:gsub(fillvars.files, v.html)

        local navcont = io.open("navcont.json", "r")
        local navdata = navcont:read("*all")
        navcont:close()
        navdata = json.decode(navdata)
        template = template:gsub("$NAV", GenerateNav(navdata))

        file:write(template)
        file:flush()
        file:close()
    end
end