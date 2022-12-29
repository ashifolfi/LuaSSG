--[[
    upload panel

    only works on linux rn
]]
local uppanel = Class{
    __includes = Modal,
    srcedir = "",
    destdir = "",
    servurl = "",

    usrname = "",
    passwd = "",
}

-- shortcuts
local TERM_PROG = Prefs.Publisher.termprog
local REQ_QUOTE = Prefs.Publisher.reqquote
local COPY_COMMAND = Prefs.Publisher.copycmd

local uplt = {}

function uplt:fillParam(str)
    -- fill out account info
    str = str:gsub("$USRNAME", uppanel.usrname)
    str = str:gsub("$PASSWD", uppanel.passwd)

    -- fill out paths
    str = str:gsub("$SOURCE", uppanel.srcedir)
    str = str:gsub("$SERVERURL", uppanel.servurl)
    str = str:gsub("$DESTINATION", uppanel.destdir)
    return str
end

function uplt:getCommand()
    local finalcommand = ""

    finalcommand = finalcommand..TERM_PROG.." "
    local fincopycmd = ""
    for i=1,2 do
        if REQ_QUOTE then
            fincopycmd =
            fincopycmd.."\""
        end
        if i==2 then break end
        fincopycmd = 
        fincopycmd..self:fillParam(COPY_COMMAND)
    end
end

function uppanel:init()
    Modal.init(self, "Publish Site", {500, 400})
end

function uppanel:renderContents()
    ImGui.TextWrapped("IMPORTANT: Make sure you properly configured the publisher in preferences")

    ImGui.Text("Server Url:")
    uppanel.servurl = ImGui.InputText("##servurl", uppanel.servurl, 4096)

    ImGui.Separator()

    ImGui.Columns(2)
    ImGui.Text("Source Directory:")
    uppanel.srcedir = ImGui.InputText("##srcedir", uppanel.srcedir, 4096)
    ImGui.NextColumn()
    ImGui.Text("Desination Directory:")
    uppanel.destdir = ImGui.InputText("##destdir", uppanel.destdir, 4096)
    ImGui.Columns(1)

    ImGui.Separator()

    ImGui.Columns(2)
    ImGui.Text("Username:")
    uppanel.usrname = ImGui.InputText("##usrname", uppanel.usrname, 4096)
    ImGui.NextColumn()
    ImGui.Text("Password:")
    uppanel.passwd = 
    ImGui.InputText("##passwd", uppanel.passwd, 4096, {"ImGuiTextFlags_Password"})
    ImGui.Columns(1)

    ImGui.Separator()

    ImGui.Columns(2)
    if ImGui.Button("Publish") then
        OpenErrorModal("NotImplemented")
    end
    ImGui.NextColumn()
    if ImGui.Button("Cancel") then
        ImGui.CloseCurrentPopup()
    end
    ImGui.Columns(1)
end

return uppanel