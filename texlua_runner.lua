#!/usr/bin/env texlua
local kpse = require 'kpse'
kpse.set_program_name('luatex', 'texlua_runner')
require 'lua-penlight'

local is_windows = package.config:sub(1, 1) == "\\"

if (arg[1] == 'test-args') then
  arg[0] = arg[1]
end

if (arg[1] == 'test-executeex') then
  if is_windows then
    local test = require 'pl.test'
    local test_asserteq = test.asserteq
    test.asserteq = function(x,y,eps,where)
      if type(x) == 'string' and type(y) == 'string' then
        y = y:gsub('\n', '\r\n')
      end
      return test_asserteq(x, y, eps, where)
    end
  end
end

if (arg[1] == 'test-date') then
  local utils = require 'pl.utils'
  utils.execute = function() return true end
end

if (arg[1] == 'test-lapp') then
  getmetatable(io.stdin).close = function()end
end

if (arg[1] == 'test-tablex') then
  zip = nil
end

dofile(arg[2])
