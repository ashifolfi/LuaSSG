local prefpane = require "preferences.prefpane"

local PublisherPane = Class{
    __includes = prefpane
}

function PublisherPane:init()
    prefpane.init(self, "Publisher")
end

function PublisherPane:renderContents()
    ImGui.Text("Upload Commands")
    ImGui.Separator()

    ImGui.Text("Terminal Application:")
    ImGui.SameLine()
    Prefs.Publisher.termprog =
    ImGui.InputText("##conftermprog", Prefs.Publisher.termprog, 1024)
    Prefs.Publisher.reqquote =
    ImGui.Checkbox("Add surrounding quotes", Prefs.Publisher.reqquote)

    ImGui.Text("")

    ImGui.Text("Copy Application:")
    ImGui.SameLine()
    Prefs.Publisher.copyprog =
    ImGui.InputText("##confcopyprog", Prefs.Publisher.copyprog, 1024)

    ImGui.Text("")

    ImGui.Text("Copy Args:")
    ImGui.SameLine()
    Prefs.Publisher.copyargs =
    ImGui.InputText("##confcopyargs", Prefs.Publisher.copyargs, 1024)
end

return PublisherPane