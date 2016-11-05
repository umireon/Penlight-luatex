#!/usr/bin/env lua
dofile('Penlight/penlight-scm-1.rockspec')
local out = io.open('lua-penlight.lua', 'w')
for name, file in pairs(build.modules) do
  out:write(string.format("package.preload['%s'] = function()\n", name))
  if name == 'pl.path' then
    out:write([[
local os = {}
for k, v in pairs(_G.os) do os[k] = v end

function os.getenv(varname)
  local is_windows = package.config:sub(1, 1) == "\\"
  if is_windows and varname == 'HOME' then
    return nil
  else
    return _G.os.getenv(varname)
  end
end
]])
  end
  if name == 'pl.compat' then
    out:write([[
local os = {}
for k, v in pairs(_G.os) do os[k] = v end

function os.execute(cmd)
  local lua51 = _VERSION == 'Lua 5.1'
  local is_windows = package.config:sub(1, 1) == "\\"
  local res = _G.os.execute(cmd)
  if is_windows then
    res = res * 256
  end
  if lua51 then
    return res
  else
    local success = res == 0
    local signal = res % 128
    local exit = math.floor(res / 256)
    if signal ~= 0 then
      return res == 0, 'signal', signal
    else
      return res == 0, 'exit', exit
    end
  end
end
]])
  end
  local f = io.open('Penlight/'..file)
  out:write(f:read("*all"))
  f:close()
  out:write("end\n")
end
out:close()
