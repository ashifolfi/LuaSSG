--[[ Custom Error dialog type
]]

local errormodal = Class{
    __includes = Modal
}

function errormodal:init(name, message)
    Modal.init(self, name, {300, 100})
    self.message = message
end

function errormodal:renderContents()
    ImGui.TextWrapped("Error: "..self.message)

    if (ImGui.Button("Ok")) then
        ImGui.CloseCurrentPopup()
    end
end

local OpenErrorModal = {
    types = {
        InvalidFile = errormodal("Invalid File", "The file provided is not valid."),
        EmptyFile = errormodal("Empty File", "No file was provided."),
        NotImplemented = errormodal("Not Implemented", "This function is not implemented yet."),
        NonExistentHeader = errormodal("Non Existent Header", "Attempted to set active header to non existent header.\nDid you forget to add it to the list?")
    },
    __call = function(self, type)
        self.types[type].open = true
    end
}
setmetatable(OpenErrorModal, OpenErrorModal)

function OpenErrorModal:render()
    for _,v in pairs(self.types) do
        v:render()
    end
end

return OpenErrorModal