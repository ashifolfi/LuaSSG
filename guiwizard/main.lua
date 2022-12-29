ImGui = require "imgui"
Class = require "lib.class"
JSON = require "lib.json"

INI = require "lib.ini"

require "utils"
require "uitypes"
Config = require "config"()

local SSGMain = require "maingui"
local preferences = require "preferences"
local publisher = require "publisher"
-- local blogger = require "blogger"
local artboard = require "artboard"
-- local filelister = require "filelister"

--
-- LOVE callbacks
--
function love.load(arg)
    MainUI = SSGMain(
        -- modals
        {
            ["Preferences"] = preferences(),
            ["Publisher"] = publisher(),
        },
        -- editors
        {
            -- ["BlogEditor"] = blogger(),
            ["ArtboardEditor"] = artboard(),
            -- ["FileLister"] = filelister()
        }
    )
end

function love.update(dt)
    if Config.confchanged then
        if Prefs.Appearance.colorscheme == "Dark" then
            ImGui.StyleColorsDark()
        else
            ImGui.StyleColorsLight()
        end
        Config.confchanged = false
    end
    
    ImGui.NewFrame()
end

function love.draw()
    MainUI:render()
    OpenErrorModal:render()

    love.graphics.clear(0.2, 0.2, 0.2)
    ImGui.Render();
end

function love.quit()
    ImGui.ShutDown();
end

--
-- User inputs
--
function love.textinput(t)
    ImGui.TextInput(t)
end

function love.keypressed(key)
    ImGui.KeyPressed(key)
end

function love.keyreleased(key)
    ImGui.KeyReleased(key)
end

function love.mousemoved(x, y)
    ImGui.MouseMoved(x, y)
end

function love.mousepressed(x, y, button)
    ImGui.MousePressed(button)
end

function love.mousereleased(x, y, button)
    ImGui.MouseReleased(button)
end

function love.wheelmoved(x, y)
    ImGui.WheelMoved(y)
end