local prefpane = require "preferences.prefpane"

local ArtboardPane = Class{
    __includes = prefpane
}

function ArtboardPane:init()
    prefpane.init(self, "Artboard Editor")
end

function ArtboardPane:renderContents()
    ImGui.Text("Art Grid")
    ImGui.Separator()

    ImGui.Text("Block padding:")
    ImGui.SameLine()
    Prefs.ArtboardEditor.blockpadding =
    ImGui.SliderFloat("##blockpaddingconf", Prefs.ArtboardEditor.blockpadding, 16, 512)
    
    ImGui.Text("")
    ImGui.Text("Block size:")
    ImGui.SameLine()
    Prefs.ArtboardEditor.blocksize =
    ImGui.SliderFloat("##blockthumbsizeconf", Prefs.ArtboardEditor.blocksize, 0, 64)
end

return ArtboardPane