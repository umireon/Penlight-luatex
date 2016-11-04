#!/usr/bin/env texlua
local kpse = require 'kpse'
kpse.set_program_name('luatex', 'texlua_runner')
require 'lua-penlight'

if (arg[1] == 'test-args') then
  arg[0] = arg[1]
end

if (arg[1] == 'test-date') then
  local utils = require 'pl.utils'
  utils.execute = function() return true end
end

if (arg[1] == 'test-tablex') then
  zip = nil
end

dofile(arg[2])
