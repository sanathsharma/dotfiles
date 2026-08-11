#!/usr/bin/env lua

local argparse = require("argparse")
local parser = argparse("commit-claude.lua", "Generate a commit message with Claude and commit staged changes")
parser:flag("--no-verify", "Skip pre-commit hooks")
parser:flag("-p --print", "Generate and print commit message only, don't commit")
parser:flag("-v --verbose", "Show debug logs and Claude's stderr output")

local args = parser:parse()

local function log(msg)
	if args.verbose then
		print(msg)
	end
end

-- os.execute returns a boolean in Lua 5.2+, a number in 5.1
local function exec(cmd)
	local result = os.execute(cmd)
	if type(result) == "number" then
		return result == 0
	end
	return result == true
end

local no_verify = ""
if args.no_verify then
	no_verify = "--no-verify"
	log("[debug] Using --no-verify flag")
end

if args.print then
	log("[debug] Print-only mode enabled")
end

log("[debug] Checking for staged changes...")
if exec("git diff --cached --quiet 2>/dev/null") then
	io.stderr:write("Error: No staged changes to commit\n")
	os.exit(1)
end
log("[debug] Found staged changes")

log("[debug] Generating commit message with Claude...")

local err_file = os.tmpname()
local handle = io.popen('echo "/commit" | claude --print --model sonnet --allowedTools "Bash(git diff *),Bash(git log *)" 2>"' .. err_file .. '"')
if not handle then
	io.stderr:write("Error: Failed to run Claude\n")
	os.exit(1)
end
local commit_msg = handle:read("*a")
handle:close()
commit_msg = commit_msg:gsub("%s+$", "")

local ef = io.open(err_file, "r")
local claude_err = ef and ef:read("*a") or ""
if ef then
	ef:close()
end
os.remove(err_file)
claude_err = claude_err:gsub("%s+$", "")

log("[debug] Received response from Claude")

if args.verbose and claude_err ~= "" then
	io.stderr:write("[claude stderr] " .. claude_err .. "\n")
end

if commit_msg == "" then
	io.stderr:write("Error: No commit message generated\n")
	if claude_err ~= "" then
		io.stderr:write(claude_err .. "\n")
	end
	os.exit(1)
end

if args.print then
	print(commit_msg)
	os.exit(0)
end

log("[debug] Generated commit message:")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print(commit_msg)
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("")

io.write("Do you want to proceed with this commit message? [Y/n] ")
local response = io.read("*l") or ""

-- Default to 'yes' if user just presses Enter
if response == "" then
	response = "y"
end

if not response:lower():match("^y$") and not response:lower():match("^yes$") then
	print("Commit cancelled by user")
	os.exit(0)
end

log("[debug] Proceeding with commit...")

local temp_msg = os.tmpname()
local f = io.open(temp_msg, "w")
if not f then
	print("Error: Failed to create temporary file")
	os.exit(1)
end
f:write(commit_msg .. "\n")
f:close()

log("[debug] Opening editor for commit message review...")

local ok = exec("git commit " .. no_verify .. ' -e -F "' .. temp_msg .. '"')

os.remove(temp_msg)

if not ok then
	os.exit(1)
end

log("[debug] Commit successful!")
