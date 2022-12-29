local artentry = Class{}

function artentry:init(file, name, tags, date)
    self.file = file or ""
    self.tags = tags or {}
    self.name = name or ""
    self.date = date or {0,0,0}
end

function artentry:DoEditModal(path)
    ImGui.SetNextWindowSize(500, 200, {"ImGuiCond_Once"})
    if (ImGui.BeginPopupModal("Edit Entry##"..self.file, nil, {"ImGuiWindowFlags_AlwaysAutoResize", "ImGuiWindowFlags_NoResize"})) then
        if editentrypreview then
            local imgsize = ResizeImage(
                {editentrypreview:getWidth(), editentrypreview:getHeight()},
                {300, 300})

            ImGui.Image(editentrypreview, imgsize[1], imgsize[2])
        end

        ImGui.Text("Name:")
        editentrycopy.name = ImGui.InputText("##edit"..self.file.."name", editentrycopy.name, 1024)

        ImGui.Text("Date:")
        ImGui.Columns(3)
        editentrycopy.date[1] = ImGui.InputText("M##edit"..self.file.."dm", editentrycopy.date[1], 64)
        ImGui.NextColumn()
        editentrycopy.date[2] = ImGui.InputText("D##edit"..self.file.."dd", editentrycopy.date[2], 64)
        ImGui.NextColumn()
        editentrycopy.date[3] = ImGui.InputText("Y##edit"..self.file.."dy", editentrycopy.date[3], 64)
        ImGui.Columns(1)

        ImGui.Text("File:")
        editentrycopy.file = ImGui.InputText("##edit"..self.file.."file", editentrycopy.file, 4096)
        ImGui.Columns(2)
        if ImGui.Button("Preview") then
            if editentrycopy.file == "" then
                OpenErrorModal("EmptyFile")
            else
                local imfile = io.open(path.."/"..editentrycopy.file, "rb")
                if imfile == nil then
                    editentrypreview = love.graphics.newImage("assets/icons/file-broken.png")
                else
                    local fc = imfile:read("*all")
                    editentrypreview = love.graphics.newImage(love.filesystem.newFileData(fc, editentrycopy.file))
                    imfile:close()
                end
            end
        end
        ImGui.NextColumn()
        if (ImGui.Button("Browse")) then
            openartfile.open()
        end
        ImGui.Columns(1)

        if (ImGui.Button("Ok")) then
            local editkeys = {name = 1, date = 1, tag = 1, file = 1}
            for k,v in pairs(editentrycopy) do
                if editkeys[k] then
                    self[k] = v
                end
            end
            rawset(_G, "editentrycopy", nil)
            ImGui.CloseCurrentPopup();
        end
            
        ImGui.SameLine()
        if (ImGui.Button("Cancel")) then
            rawset(_G, "editentrycopy", nil)
            ImGui.CloseCurrentPopup();
        end


        -- the layers
        openartfile.draw()

        ImGui.EndPopup();
    end
end

function artentry:DrawListBlock(thumbsize, path)
    local didclick = false
    if not(self.image) then
        local imfile = io.open(path.."/"..self.file, "rb")
        if not(imfile) then
            self.image = love.graphics.newImage("assets/icons/file-broken.png")
        else
            local fc = imfile:read("*all")
            self.image = love.graphics.newImage(love.filesystem.newFileData(fc, self.file))
            imfile:close()
        end
    end

    ImGui.PushID(self.file)
    ImGui.PushStyleColor("ImGuiCol_Button", 0, 0, 0, 0)

    local imgsize = ResizeImage(
                {self.image:getWidth(), self.image:getHeight()},
                {thumbsize, thumbsize})

    ImGui.ImageButton(self.image, imgsize[1], imgsize[2], 0, 0, 1, 1)

    if ImGui.IsItemActivated() then
        didclick = true
    end

    ImGui.PopStyleColor()
    ImGui.TextWrapped(self.name)
    ImGui.PopID()

    -- lil bit of crazy
    if self.edit then
        ImGui.OpenPopup("Edit Entry##"..self.file)
        self.edit = false
        editentrycopy = table.table_copy(self)
    end
    -- Popup window for editing
    self:DoEditModal(path)

    return didclick
end

return artentry