#!/usr/bin/env lua
dofile('Penlight/penlight-scm-1.rockspec')
local out = io.open('lua-penlight.lua', 'w')
for name, file in pairs(build.modules) do
  out:write(string.format("package.preload['%s'] = function()\n", name))
  local f = io.open('Penlight/'..file)
  out:write(f:read("*all"))
  f:close()
  out:write("end\n")
end
out:write([[
local compat = require 'pl.compat'
function compat.execute (cmd)
    local res1, res2 = os.execute(cmd)
    if compat.lua51 then
        return res1 == 0, res1
    else
        return res1 == 0, math.floor(res1 / 256)
    end
end
]])
out:close()
