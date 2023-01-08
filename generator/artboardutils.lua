local json = require "json"

function abFilelist(filename, pathto)
    local file = io.open(filename, "r")
    local dat = file:read("*all")
    dat = json.decode(dat)
    file:close();

    local newdata = {
    files = {
    }
    }

    for k,v in ipairs(dat.artwork) do
    local entname = string.gsub(v.fspath, "/", "")

    newdata.files[entname] = {
        type = "file",
        filetype = "picture",
        filepath = pathto..v.fspath
    }
    end

    local ndtw = json.encode(newdata)
    local file = io.open("filelist-"..filename, "w+")
    file:write(ndtw)
    file:flush()
    file:close()
end

function createThumbnails(filename)
    local file = io.open(filename, "r")
    local dat = file:read("*all")
    dat = json.decode(dat)
    file:close();

    for k,v in ipairs(dat.artwork) do
        local path = "./art-source"..v.fspath
        print("resizing image '"..v.fspath.."' by 4")

        os.execute("ffmpeg -f image2 -i "..path.." -vf \"scale=iw/4:ih/4\" ./thumbnails"..
        v.fspath..".gif")
        print("resized image '"..v.fspath.."' by 4")
    end
end