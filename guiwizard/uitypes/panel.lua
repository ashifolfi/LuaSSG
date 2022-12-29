local panel = Class{}

function panel:init(name, open, size, flags)
    self.name = name or "Panel"
    self.open = open
    self.size = size or {64, 64}
    self.flags = flags or {"ImGuiWindowFlags_None"}
end

function panel:renderContents()

end

function panel:render()
    if self.open == true or self.open == nil then
        if self.size then
            ImGui.SetNextWindowSize(self.size[1], self.size[2], "ImGuiCond_Once")
        end
        self.open = ImGui.Begin(self.name, self.open, self.flags)
        if (self.open) then
            self:renderContents()
        end
        ImGui.End()
    end
end

return panel