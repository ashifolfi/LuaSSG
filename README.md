# Ashi's static site generator
**HIGHLY WIP**
A lua based static site generator that uses json, markdown, and template html files to generate pages

TODO: Clean up scripts in main generator component

**HIGHLY WIP**
## requirements for wizard
- Love2D
- [love-imgui](https://github.com/MikuAuahDark/love-imgui)

## current progress

main generators:
- [x] standard pages from MD (tables are currently not working)
- [x] static file list plugin
- [ ] static artboard plugin
- [ ] blog plugin
- [ ] full site generation from single config file

GUI:
- [ ] standard site configs
- [x] artboard json editing
- [ ] blog editing
- [ ] filelist plugin support

both:
- [ ] support for loading plugins

## libraries/code used
- [love-imgui](https://github.com/MikuAuahDark/love-imgui)
- [json.lua](https://github.com/rxi/json.lua)
- [luamd](https://github.com/bakpakin/luamd)
- [lfsffi](https://github.com/sonoro1234/luafilesystem/blob/unicode/lfs_ffi.lua)
- [filebrowser.lua](https://github.com/sonoro1234/LuaJIT-ImGui/blob/docking_inter/examples/filebrowser.lua)
