local prefpane = Class{
    name = "PREFPANE"
}

function prefpane:init(name)
    self.name = name
end

function prefpane:render()
    if (ImGui.BeginTabItem(self.name)) then
        if ImGui.BeginChild("##prefpane"..self.name, ImGui.GetWindowWidth(), 300) then
            self:renderContents()
            ImGui.EndChild()
        end
        ImGui.EndTabItem()
    end
end

function prefpane:renderContents()

end

return prefpane