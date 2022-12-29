require "page"
require "sitemap"
require "filelisting"
json = require "json"

print("Ashi's static site generator | v1.0")

local curconf = {}

function compileFilelist(filepath)
    local file = io.open(filepath, "r")
    if not(file) then
        error("Couldn't find file!")
    end
    local filedat = file:read("*all")
    local data = json.decode(filedat)
    file:close()
    CreateFilelist(data)
end