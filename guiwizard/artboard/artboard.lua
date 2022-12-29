local artentry = require "artboard.artentry"

local artedit = Class{
    curartlist = "NONE",
    curpath = "",
    cellsize = 
    Prefs.ArtboardEditor.blocksize + Prefs.ArtboardEditor.blockpadding
}

function artedit:init(path)
    self.curpath = path
    self:ReadList(path)
end

function artedit:ReadList(path)
    local filecontents = ""

    local file = io.open(path.."/artlist.json", "r")
    filecontents = file:read("*all")
    local JSONal = JSON.decode(filecontents)
    file:close()

    self.curpath = path

    -- take the entries we have and create our list of art entries
    self.curartlist = {}
    for i,v in ipairs(JSONal["artwork"]) do
        local newentry = artentry(
            v[1], v[2], v[3], v[4]
        )
        table.insert(self.curartlist, i, newentry)
    end
end

function artedit:SaveList()
    local file = io.open(self.curpath.."/artlist.JSON", "w+")

    -- create a proper JSON list from each art element
    local JSONlist = {
        artwork = {}
    }

    for k,v in ipairs(self.curartlist) do
       local newvalue = {
           v.file, v.name, v.tags, v.date
       }
       table.insert(JSONlist.artwork, k, newvalue)
    end

    local towrite = JSON.encode(JSONlist)
    file:write(towrite)
    file:flush()
    file:close()
end

function artedit:drawBlocks()
    if not(type(self.curartlist) == "table") then return end
    local panelWidth = ImGui.GetContentRegionAvail()

    local columnCount = panelWidth/self.cellsize
    if (columnCount < 1) then
        columnCount = 1
    end
	
    ImGui.Columns(columnCount, 0, false);

    for k,v in ipairs(self.curartlist) do
        local didclick = v:DrawListBlock(Prefs.ArtboardEditor.blocksize, self.curpath)
        if didclick then
            self.selected = k
        end
        ImGui.NextColumn()
    end

    ImGui.Columns(1)
end

function artedit:newentrydialog()
    -- Popup window for adding
    ImGui.SetNextWindowSize(600, 350, {"ImGuiCond_Once"})
    if (ImGui.BeginPopupModal("New Artpiece", nil, {"ImGuiWindowFlags_NoResize"})) then
        ImGui.EndPopup();
    end
end

function artedit:draw()
    -- menubar
    if (ImGui.BeginMenuBar()) then
        if (ImGui.BeginMenu("Artpieces")) then
            if ImGui.MenuItem("New Artpiece") then
                ImGui.OpenPopup("New Artpiece")
            end
            if ImGui.MenuItem("Edit Artpiece") then
                if self.selected and self.curartlist[self.selected] then
                    self.curartlist[self.selected].edit = true
                end
            end
            if ImGui.MenuItem("Remove Artpiece") then
                if self.selected and self.curartlist[self.selected] then
                    table.remove(self.curartlist, self.selected)
                    self.selected = nil
                end
            end
            if ImGui.MenuItem("Locate Artpiece file") then
                
            end

            ImGui.EndMenu()
        end

        if ImGui.Button("New") then
            newpiece = artentry()
            newpiecepreview = nil
            ImGui.OpenPopup("New Artpiece")
        end
        if ImGui.Button("Edit") then
            if self.selected and self.curartlist[self.selected] then
                self.curartlist[self.selected].edit = true
            end
        end
        if ImGui.Button("Remove") then
            if self.selected and self.curartlist[self.selected] then
                table.remove(self.curartlist, self.selected)
                self.selected = nil
            end
        end

        -- draws a bit of info 
        ImGui.Text("Selected: "..(self.curartlist[self.selected] and self.curartlist[self.selected].name or "none"))
        
        --self:newentrydialog()

        ImGui.EndMenuBar()
    end

    self:drawBlocks()
end

return artedit