local artentry = require "artboard.artentry"

local modals = {}
local fbg = require "filebrowser"(ImGui)

--#region new art modal

modals.NewArtModal = Class{
    __includes = Modal
}

function modals.NewArtModal:init(parent)
    Modal.init(self, "New Art Entry", {600, 350})
    self.parent = parent
    
    self.openfiledialog = fbg.FileBrowser(nil,{key="loader",pattern="",
    curr_dir=self.parent.curpath},function(fname) 
        print("load",fname)
        fname = fname:gsub(self.parent.curpath.."/", "")
        print(fname)
        self.newpiece.file = fname
    end)
end

function modals.NewArtModal:Open()
    self.open = true
    self.newpiece = artentry()
    self.newpiecepreview = nil
end

function modals.NewArtModal:renderContents()
    local top = ImGui.GetCursorPosY()
    ImGui.Columns(2)
    ImGui.SetColumnWidth(-1, 300)
    if self.newpiecepreview then
        local imgsize = ResizeImage(
            {self.newpiecepreview:getWidth(), self.newpiecepreview:getHeight()},
            {300, 300})

        -- always center the image in this panel
        ImGui.SetCursorPosY((350/2)-(imgsize[2]/2))
        ImGui.Image(self.newpiecepreview, imgsize[1], imgsize[2])
    end
    ImGui.NextColumn()
    ImGui.SetColumnWidth(-1, 300)

    ImGui.Text("Name:")
    self.newpiece.name = ImGui.InputText("##newpiecename", self.newpiece.name, 1024)

    ImGui.Text("Date:")
    self.newpiece.date[1] = ImGui.InputText("M##newpiecedm", self.newpiece.date[1], 64)
    ImGui.SameLine()
    self.newpiece.date[2] = ImGui.InputText("D##newpiecedd", self.newpiece.date[2], 64)
    -- ImGui.SameLine()
    self.newpiece.date[3] = ImGui.InputText("Y##newpiecedy", self.newpiece.date[3], 64)

    ImGui.Text("File:")
    self.newpiece.file = ImGui.InputText("##newpiecefile", self.newpiece.file, 4096)
    if ImGui.Button("Preview") then
        if self.newpiece.file == "" then
            OpenErrorModal("EmptyFile")
        else
            local imfile = io.open(self.curpath.."/"..self.newpiece.file, "rb")
            if imfile == nil then
                self.newpiecepreview = love.graphics.newImage("assets/icons/file-broken.png")
            else
                local fc = imfile:read("*all")
                self.newpiecepreview = love.graphics.newImage(love.filesystem.newFileData(fc, self.newpiece.file))
                imfile:close()
            end
        end
    end
    ImGui.SameLine()
    if (ImGui.Button("Browse")) then
        self.openfiledialog.open()
    end

    ImGui.SetCursorPosY(top+350-60)
    if (ImGui.Button("Ok")) then
        if self.newpiece.file == "" then
            OpenErrorModal("EmptyFile")
        else
            table.insert(self.parent.curartlist, #self.parent.curartlist + 1, self.newpiece)
            rawset(self, "newpiece", nil)
            ImGui.CloseCurrentPopup();
        end
    end
        
    ImGui.SameLine()
    if (ImGui.Button("Cancel")) then
        rawset(self, "newpiece", nil)
        ImGui.CloseCurrentPopup();
    end
    ImGui.Columns(1)

    self.openfiledialog.draw()
end

--#endregion

return modals