local modal = Class{}

function modal:init(tag, size)
    self.open = false

    self.tag = tag
    self.size = size
end

function modal:renderContents()

end

function modal:render()
    if self.open then
        self.open = false
        ImGui.OpenPopup(self.tag)
    end

    ImGui.SetNextWindowSize(self.size[1], self.size[2], {"ImGuiCond_Once"})
    if (ImGui.BeginPopupModal(self.tag, nil, {"ImGuiWindowFlags_NoResize", "ImGuiWindowFlags_NoMove"})) then
        self:renderContents()
        ImGui.EndPopup()
    end
end

return modal