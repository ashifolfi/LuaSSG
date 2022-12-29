local fbg = require "filebrowser"(ImGui)
local GlobalMenuBar = Class{}

function GlobalMenuBar:init(parent)
    self.parent = parent
    self.filedialog = fbg.FileBrowser(nil,{key="loader",pattern="",
    curr_dir=love.filesystem.getSourceBaseDirectory()})
end

function GlobalMenuBar:render()
    local openfile = false
    -- Menu
    if ImGui.BeginMainMenuBar() then
        if ImGui.BeginMenu("File") then
            if ImGui.MenuItem("New") then
                self.parent:newWebsiteConf()
            end
            ImGui.Separator()
            ImGui.MenuItem("Open", "Ctrl+O")
            ImGui.Separator()
            if ImGui.MenuItem("Save", "Ctrl+S") then
                if not(self.parent.curwebdir) then
                    self.filedialog = fbg.FileBrowser(nil,{key="saver",
                    curr_dir=love.filesystem.getSourceBaseDirectory(),}, function(fname)
                        print(fname)
                        fname = fname:gsub("(/[A-z]+%.ini)$", "")
                        print(fname)
                        self.parent.curwebdir = fname
                        self.parent:saveWebsiteConf()
                    end)
                    openfile = true
                else
                    self.parent:saveWebsiteConf()
                end
            end
            if ImGui.MenuItem("Save As", "Ctrl+Shift+S") then
                self.filedialog = fbg.FileBrowser(nil,{key="saver",
                    curr_dir=love.filesystem.getSourceBaseDirectory(),}, function(fname)
                        print(fname)
                        fname = fname:gsub("(/[A-z]+%.ini)$", "")
                        print(fname)
                        self.parent.curwebdir = fname
                        self.parent:saveWebsiteConf()
                    end)
                openfile = true
            end
            ImGui.Separator()
            if ImGui.MenuItem("Close", "Ctrl+W") then
                CurWebConf = 1
                self.parent.curwebdir = nil
            end
            ImGui.Separator()
            if ImGui.MenuItem("Preferences") then
                self.parent.modals["Preferences"].open = true
            end
            ImGui.Separator()
            ImGui.Text("insert recent item")
            ImGui.Text("insert recent item")
            ImGui.Text("insert recent item")
            ImGui.Text("insert recent item")
            ImGui.Separator()
            if ImGui.MenuItem("Exit") then
                love.event.quit()
            end

            ImGui.EndMenu()
        end

        if (ImGui.BeginMenu("Edit")) then
            ImGui.MenuItem("Undo", "Ctrl+Z")
            ImGui.MenuItem("Redo", "Ctrl+Shift+Z")
            ImGui.Separator()
            ImGui.MenuItem("Cut", "Ctrl+X")
            ImGui.MenuItem("Copy", "Ctrl+C")
            ImGui.MenuItem("Paste", "Ctrl+V")
            ImGui.Separator()
            ImGui.MenuItem("Delete", "Del")

            ImGui.EndMenu()
        end

        if (ImGui.BeginMenu("About")) then
            ImGui.MenuItem("About SSGEN")
            ImGui.MenuItem("SSGEN Documentation")

            ImGui.EndMenu()
        end

        if ImGui.Button("Publish") then
            self.parent.modals["Publisher"].open = true
        end

        ImGui.EndMainMenuBar()
    end

    if openfile then
        self.filedialog.open()
    end
    self.filedialog.draw()
end

return GlobalMenuBar