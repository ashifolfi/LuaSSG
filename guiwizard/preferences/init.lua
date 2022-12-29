local Appearance = require "preferences.Appearance"
local Publisher  = require "preferences.Publisher"
local ArtboardEdit = require "preferences.ArtboardEdit"

local prefs = Class{
    __includes = Modal,
}

function prefs:init()
    Modal.init(self, "Preferences", {700, 500})

    self.panes = {
        Appearance(),
        Publisher(),
        ArtboardEdit(),
    }
end

function prefs:renderContents()
    local top = ImGui.GetCursorPosY()
    if (ImGui.BeginTabBar(("##prefstabbar"))) then

        for _,v in ipairs(self.panes) do
            v:render()
        end

        ImGui.EndTabBar()
    end

    local bottom = ImGui.GetWindowHeight() + top
    ImGui.SetCursorPosY(bottom-60)
    if ImGui.Button("Ok") then
        Config:saveConfig()
        Config.confchanged = true
        ImGui.CloseCurrentPopup()
    end
    ImGui.SameLine()
    if ImGui.Button("Cancel") then
        Config:loadConfig()
        Config.confchanged = true
        ImGui.CloseCurrentPopup()
    end
end

return prefs