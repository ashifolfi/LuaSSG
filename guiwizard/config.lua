Prefs = {
    ["Publisher"] = {
        termprog = "xterm -e",
        reqquote = true,
        copyprog = "rsync",
        copyargs = "-alPvz $SOURCE $SERVERURL:$DESTINATION"
    },
    ["Appearance"] = {
        colorscheme = "Dark"
    },
    ["ArtboardEditor"] = {
        blockpadding = 16,
        blocksize = 64
    }
}

local config = Class{}

function config:init()
    self:loadConfig()
    self.confchanged = true
end

function config:saveConfig()
    INI.save(love.filesystem.getSourceBaseDirectory().."/sseprefs.ini", Prefs)
end

function config:loadConfig()
    local file = io.open(love.filesystem.getSourceBaseDirectory().."/sseprefs.ini", "r")
    if not(file) then
        self:saveConfig()
    else
        file:close()
    end
    Prefs = INI.load(love.filesystem.getSourceBaseDirectory().."/sseprefs.ini")
end

return config