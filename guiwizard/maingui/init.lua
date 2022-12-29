local GlobalMenuBar = require "maingui.mainmenubar"
local Sidebar = require "maingui.sidebar"
local genconf = require "maingui.genconf"

local SSGMain = Class{
    modals = {},
    editors = {},
}

CurWebConf = 1

function SSGMain:init(modals, editors)
    self.modals = modals
    self.editors = editors
    self.menubar = GlobalMenuBar(self)
    self.sidebar = Sidebar(self)
    self.genconf = genconf(self)
end

function SSGMain:newWebsiteConf()
    CurWebConf = {
        ["Main"] = {
            websitename = "",
            favicon = ""
        },
        ["Plugins"] = {}
    }
end

function SSGMain:loadWebsiteConf(dir)
    local file = io.open(dir.."/ssgfile.ini", "r")
    if not(file) then
        OpenErrorModal("FileInvalid")
        return
    end
    file:close()

    CurWebConf = INI.load(dir.."/ssgfile.ini")
    self.curwebdir = dir
end

function SSGMain:saveWebsiteConf(dir)
    INI.save((dir or self.curwebdir).."/ssgfile.ini", CurWebConf)
end

function SSGMain:render()
    self.menubar:render()

    if (CurWebConf == 1) then
        if self.modals["Preferences"] then
            self.modals["Preferences"]:render()
        end
        return
    end

    self.sidebar:render()

    for _,modal in pairs(self.modals) do
        modal:render()
    end

    for _,editor in pairs(self.editors) do
        editor:render()
    end
end

return SSGMain