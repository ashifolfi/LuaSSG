local sidebar = Class{
    __includes = Panel
}

function sidebar:init(parent)
    Panel.init(self, "##sidebar", nil, {200, 550}, {"ImGuiWindowFlags_NoDecoration", "ImGuiWindowFlags_NoMove"})
    self.parent = parent
    self.SetActiveHeader = {
        status = {
        ["Website Config"] = 2,
        ["Assets"] = 1,
        ["Sitemap"] = 1,
        ["Editors"] = 1,
        },
        getActive = function(self, name)
            if self.status[name] == 2 then
                return true
            else
                return false
            end
        end,
        __call = function(self, name)
            if self.status[name] then
                for k,v in pairs(self.status) do
                    if k ~= name then
                        self.status[k] = 1
                    end
                end
                self.status[name] = 2
            else
                OpenErrorModal("NonExistentHeader")
            end
        end
    }
    setmetatable(self.SetActiveHeader, self.SetActiveHeader)
end

function sidebar:render()
    if self.size then
        ImGui.SetNextWindowSize(self.size[1], self.size[2], "ImGuiCond_Once")
        ImGui.SetNextWindowPos(13, 28, "ImGuiCond_Always")
    end
    if (ImGui.Begin(self.name, nil, self.flags)) then
        self:renderContents()
    end
    ImGui.End()
end

function sidebar:renderContents()
    -- just headers right now
    ImGui.SetNextTreeNodeOpen(self.SetActiveHeader:getActive("Website Config"), {"ImGuiCond_Always"})
    if ImGui.CollapsingHeader("Website Config") then
        self.SetActiveHeader("Website Config")
        -- only draw the generator configure window if this header is open
        self.parent.genconf:render()

        -- actual sidebar elements
        self.parent.genconf:sidebarElements()
    end
    ImGui.SetNextTreeNodeOpen(self.SetActiveHeader:getActive("Assets"), {"ImGuiCond_Always"})
    if ImGui.CollapsingHeader("Assets") then
        self.SetActiveHeader("Assets")
    end
    ImGui.SetNextTreeNodeOpen(self.SetActiveHeader:getActive("Sitemap"), {"ImGuiCond_Always"})
    if ImGui.CollapsingHeader("Sitemap") then
        self.SetActiveHeader("Sitemap")
    end
    ImGui.SetNextTreeNodeOpen(self.SetActiveHeader:getActive("Editors"), {"ImGuiCond_Always"})
    if ImGui.CollapsingHeader("Editors") then
        self.SetActiveHeader("Editors")
        if ImGui.Button("Artboard Editor") then
            self.parent.editors["ArtboardEditor"].open = not self.parent.editors["ArtboardEditor"].open
        end
        if ImGui.Button("Blog Editor") then
            self.parent.editors["Blogger"].open = not self.parent.editors["Blogger"].open
        end
        if ImGui.Button("File List Editor") then
            self.parent.editors["FileLister"].open = not self.parent.editors["FileLister"].open
        end
    end
end

return sidebar