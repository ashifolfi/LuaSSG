local prefpane = require "preferences.prefpane"

local AppearancePane = Class{
    __includes = prefpane,
    coloropts = {
        "Dark", "Light"
    }
}

function AppearancePane:init()
    prefpane.init(self, "Appearance")
end

function AppearancePane:renderContents()
    ImGui.Text("Global")
    ImGui.Separator()

    ImGui.Text("Color Scheme:")
    ImGui.SameLine()
    if (ImGui.BeginCombo("##confcolorscheme", Prefs.Appearance.colorscheme, 0)) then
        for _,v in ipairs(self.coloropts) do
            if ImGui.Selectable(v) then
                Prefs.Appearance.colorscheme = v
                Config.confchanged = true
            end
        end

        ImGui.EndCombo()
    end

    ImGui.Text("")
    ImGui.Text("Markdown Editor")
    ImGui.Separator()
end

return AppearancePane