--------------------------------------------------------------------------------
-- Swap between C header and source files
--------------------------------------------------------------------------------

require "utils"

local delim    = '/'

local cpp_ext  = 'cpp'
local cpp_ext2 = 'cc'
local c_ext    = 'c'
local h_ext    = 'h'
local f        = props['FileName'] -- e.g 'test'
local ext      = props['FileExt']  -- e.g 'cpp'
local path     = props['FileDir']  -- e.g. '/home/user/progs'

local filename = path .. delim .. f .. '.' .. ext;

if (ext == cpp_ext) or
   (ext == c_ext)   or
   (ext == cpp_ext2) then
    ext = h_ext
elseif ext == h_ext then
    ext      = cpp_ext
    filename = path .. delim .. f .. '.' .. ext
    
    if (FileExists(filename) ~= true) then
        ext      = c_ext
        filename = path .. delim .. f .. '.' .. ext
        
        if (FileExists(filename) ~= true) then
            ext      = cpp_ext2
            filename = path .. delim .. f .. '.' .. ext
            
            if (FileExists(filename) ~= true) then
                -- Nothing
            end
        end
    end
end

filename = path .. delim .. f .. '.' .. ext

-- if the file exists, open it!
if (FileExists(filename) == true) then
    scite.Open(filename)
end
