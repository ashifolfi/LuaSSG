local fbg = require "filebrowser"(ImGui)
local Artboard = require "artboard.artboard"

local ArtboardEditor = Class{
    __includes = Panel,
    artboards = {}
}

local open = false

function ArtboardEditor:init()
    Panel.init(self, "Artboard Editor", open, {850, 550}, {"ImGuiWindowFlags_MenuBar"})
    self.abfiledialog = fbg.FileBrowser(nil,{key="loader",pattern=".json",
    curr_dir=love.filesystem.getSourceBaseDirectory()},function(fname)
        print("load",fname)
        fname = fname:gsub('(/[A-z]+%.json)$', "")
        print(fname)

        -- create new artboard editor
        local newedit = Artboard(fname)
        table.insert(self.artboards, #self.artboards+1, newedit)
    end)
end

function ArtboardEditor:renderContents()
    local openfilepicker = false
    if (ImGui.BeginMenuBar()) then
        if (ImGui.BeginMenu("Artboard")) then
            ImGui.MenuItem("New Artboard")
            ImGui.Separator()
            if ImGui.MenuItem("Open Artboard") then
                openfilepicker = true
            end
            ImGui.Separator()
            if ImGui.MenuItem("Save Artboard", "Ctrl+S", false, (#self.artboards > 0)) then
                self.artboards[self.selected]:SaveList()
            end
            ImGui.MenuItem("Save Artboard As", "Ctrl+Shift+S", false, (#self.artboards > 0))
            ImGui.Separator()
            ImGui.MenuItem("Import Artboard", nil, false, (#self.artboards > 0))
            ImGui.Separator()
            if ImGui.MenuItem("Close Artboard", "Ctrl+W", false, (#self.artboards > 0)) then
                table.remove(self.artboards, self.selected)
            end

            ImGui.EndMenu()
        end
            
        ImGui.EndMenuBar()
    end

    if (ImGui.BeginTabBar("##Artboardeditortabs")) then
        for _,v in ipairs(self.artboards) do
            if (ImGui.BeginTabItem("Art Entry Editor")) then
                v:draw()
                self.selected = _
                ImGui.EndTabItem()
            end
        end

        ImGui.EndTabBar()
    end

    if openfilepicker then
        self.abfiledialog.open()
    end

    self.abfiledialog.draw()
end

return ArtboardEditor