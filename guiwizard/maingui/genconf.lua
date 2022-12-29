local fbg = require "filebrowser"(ImGui)
local genconf = Class{
    __includes = Panel
}

function genconf:init()
    Panel.init(self, "Website Config", nil, {850, 550}, {"ImGuiWindowFlags_NoDecoration"})
    self.openfile = fbg.FileBrowser(nil,{key="loader",pattern="",
    curr_dir=love.filesystem.getSourceBaseDirectory()})
    self.currentSection = "Main"
end

function genconf:renderMain()
    local openfile = false

    ImGui.Text("Main")
    ImGui.Separator()

    ImGui.Columns(2)
    ImGui.Text("Website Name:")
    ImGui.NextColumn()
    CurWebConf["Main"]["websitename"] =
    ImGui.InputText("##Websitename", CurWebConf["Main"]["websitename"], 4096)
    ImGui.Columns(1)

    ImGui.Columns(2)
    ImGui.Text("FavIcon:")
    ImGui.NextColumn()
    CurWebConf["Main"]["favicon"] = 
    ImGui.InputText("##Faviconedit", CurWebConf["Main"]["favicon"], 4096)
    ImGui.SameLine()
    if ImGui.Button("Browse") then
        self.openfile = fbg.FileBrowser(nil,{key="loader",pattern="",
    curr_dir=love.filesystem.getSourceBaseDirectory()}, function(fname)
        CurWebConf["Main"]["favicon"] = fname
    end)
        openfile = true
    end
    ImGui.Columns(1)


    if openfile then
        self.openfile.open()
    end
    self.openfile.draw()
end

function genconf:renderPlugins()
    ImGui.Text("Plugins")
    ImGui.Separator()

    CurWebConf["Plugins"]["blogger"] =
    ImGui.Checkbox("Blogger", CurWebConf["Plugins"]["blogger"] or false)
    CurWebConf["Plugins"]["filelister"] =
    ImGui.Checkbox("Static File Lister", CurWebConf["Plugins"]["filelister"] or false)
    CurWebConf["Plugins"]["artboard"] =
    ImGui.Checkbox("Static Artboard", CurWebConf["Plugins"]["artboard"] or false)
end

function genconf:renderContents()
    --#region Main
    local switchsec = {
        ["Main"] = function()
            self:renderMain()
        end,
        ["Templates"] = function()

        end,
        ["Plugins"] = function()
            self:renderPlugins()
        end,
    }
    switchsec[self.currentSection]()
end

function genconf:sidebarElements()
    if (ImGui.Button("Main")) then
        self.currentSection = "Main"
    end
    if (ImGui.Button("Templates")) then
        self.currentSection = "Templates"
    end
    if (ImGui.Button("Plugins")) then
        self.currentSection = "Plugins"
    end
end

return genconf