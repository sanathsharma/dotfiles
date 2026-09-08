#!/usr/bin/env lua

local argparse = require("argparse")
local parser = argparse("get-process-by-port.lua", "Get process by port number")
parser:argument("port", "Port number")

-- Check if port argument is provided
local args = parser:parse()

if not args.port then
	io.stderr:write("Error: Port number required\n")
	io.stderr:write("Usage: " .. arg[0] .. " <port>\n")
	os.exit(1)
end

-- Validate port number (digits only)
if not args.port:match("^%d+$") then
	io.stderr:write("Error: Port must be a number\n")
	os.exit(1)
end

local port = tonumber(args.port)

-- Check if port is in valid range
if port < 1 or port > 65535 then
	io.stderr:write("Error: Port must be between 1 and 65535\n")
	os.exit(1)
end

-- Run lsof command
os.execute("sudo lsof -i tcp:" .. port)
