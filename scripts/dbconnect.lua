#!/usr/bin/env lua

-- Picks DB connection strings out of secretspec or doppler via fzf and opens
-- them in nvim's dbui via the DBConnect command. See dbui/spec-dbui in
-- .config/fish/config.fish for the predecessor this replaces (dbui itself
-- stays as-is).

local argparse = require("argparse")

local parser = argparse("dbconnect", "Pick DB connection strings from secretspec or doppler and open them in nvim's dbui")
parser:require_command(false)

local secretspec_cmd = parser:command("secretspec", "Use secretspec as the secret provider")
secretspec_cmd:option("--profile", "secretspec profile to resolve")
secretspec_cmd:option("--scope", "secretspec scope to resolve (subset of the profile)")
secretspec_cmd:option("--vars", "Comma-separated secret names to use, skips the picker")

local doppler_cmd = parser:command("doppler", "Use doppler as the secret provider")
doppler_cmd:option("--project", "doppler project")
doppler_cmd:option("--config", "doppler config (environment)")
doppler_cmd:option("--vars", "Comma-separated secret names to use, skips the picker")

local args = parser:parse()

-- ===== shell helpers =====

local function shell_quote(s)
	return "'" .. tostring(s):gsub("'", "'\\''") .. "'"
end

-- os.execute returns a boolean in Lua 5.2+, a number in 5.1
local function exec_ok(cmd)
	local result = os.execute(cmd)
	if type(result) == "number" then
		return result == 0
	end
	return result == true
end

local function popen_read(cmd)
	local h = io.popen(cmd, "r")
	if not h then
		return ""
	end
	local out = h:read("*a") or ""
	h:close()
	return out
end

local function lines_of(text)
	local items = {}
	for line in text:gmatch("[^\n]+") do
		table.insert(items, line)
	end
	return items
end

local function require_tool(name)
	if not exec_ok("command -v " .. name .. " >/dev/null 2>&1") then
		io.stderr:write("Error: '" .. name .. "' is required but not found on PATH\n")
		os.exit(1)
	end
end

-- ===== fzf pickers =====

-- true once any input had to be collected via an fzf prompt, rather than a flag
local prompted = false

local function fzf_single(items, prompt)
	if #items == 0 then
		return nil
	end
	prompted = true
	local blob = table.concat(items, "\n")
	local cmd = "printf '%s' " .. shell_quote(blob)
		.. " | fzf --no-multi --reverse --height=20 --preview='' --prompt=" .. shell_quote(prompt)
	local out = popen_read(cmd):gsub("%s+$", "")
	if out == "" then
		return nil
	end
	return out
end

-- lines are "NAME\tVALUE"; the list shows only the name, preview shows the value
local function fzf_multi_kv(lines, prompt)
	if #lines == 0 then
		return {}
	end
	prompted = true
	local blob = table.concat(lines, "\n")
	local cmd = "printf '%s' " .. shell_quote(blob)
		.. " | fzf --multi --reverse --height=20 --delimiter=" .. shell_quote("\t")
		.. " --with-nth=1 --preview=" .. shell_quote("printf '%s' {2}")
		.. " --preview-window=wrap --prompt=" .. shell_quote(prompt)
	return lines_of(popen_read(cmd))
end

-- ===== secretspec.toml discovery (mirrors secretspec's own walk-up) =====

local function find_secretspec_toml()
	local dir = popen_read("pwd"):gsub("%s+$", "")
	while true do
		local candidate = dir .. "/secretspec.toml"
		local f = io.open(candidate, "r")
		if f then
			f:close()
			return candidate
		end
		if dir == "" or dir == "/" then
			return nil
		end
		dir = dir:match("^(.*)/[^/]+$") or "/"
	end
end

-- collects names from headers like "[profiles.<name>]" or "[scopes.<name>]"
local function collect_headers(path, table_name)
	local names = {}
	for line in io.lines(path) do
		local name = line:match("^%[" .. table_name .. "%.([%w_%-]+)%]")
		if name then
			table.insert(names, name)
		end
	end
	return names
end

-- ===== provider data fetchers (return list of {name, value}) =====

local KV_FILTER = [[to_entries[] | "\(.key)\t\(.value)"]]
local KV_FILTER_NO_DOPPLER = [[to_entries[] | select(.key | test("^DOPPLER_") | not) | "\(.key)\t\(.value)"]]
local REASON = "dbconnect.lua: resolving DB connection strings for nvim dbui"

local function parse_kv(text)
	local kv = {}
	for _, line in ipairs(lines_of(text)) do
		local name, value = line:match("^(.-)\t(.*)$")
		if name then
			table.insert(kv, { name = name, value = value })
		end
	end
	return kv
end

local function fetch_secretspec_kv(profile, scope)
	local cmd = "secretspec export --format json --reason " .. shell_quote(REASON)
	if profile then
		cmd = cmd .. " --profile " .. shell_quote(profile)
	end
	if scope then
		cmd = cmd .. " --scope " .. shell_quote(scope)
	end
	cmd = cmd .. " | jq -r '" .. KV_FILTER .. "'"
	return parse_kv(popen_read(cmd))
end

local function doppler_projects()
	return lines_of(popen_read("doppler projects --json | jq -r '.[].name'"))
end

local function doppler_configs(project)
	return lines_of(popen_read("doppler configs -p " .. shell_quote(project) .. " --json | jq -r '.[].name'"))
end

local function fetch_doppler_kv(project, config)
	local cmd = "doppler secrets download --no-file --format json --project " .. shell_quote(project)
		.. " --config " .. shell_quote(config)
		.. " | jq -r '" .. KV_FILTER_NO_DOPPLER .. "'"
	return parse_kv(popen_read(cmd))
end

-- ===== per-provider flows: return kv table + rerun-command fragment =====

local function run_secretspec(opts)
	require_tool("secretspec")

	local toml = find_secretspec_toml()
	if not toml then
		io.stderr:write("Error: no secretspec.toml found walking up from the current directory\n")
		os.exit(1)
	end

	local profile = opts.profile
	if not profile then
		local profiles = collect_headers(toml, "profiles")
		if #profiles > 0 then
			profile = fzf_single(profiles, "Profile: ")
			if not profile then
				io.stderr:write("No profile selected. Exiting.\n")
				os.exit(1)
			end
		end
	end

	local scope = opts.scope
	if not scope then
		local scopes = collect_headers(toml, "scopes")
		if #scopes == 0 then
			io.stderr:write("No scopes declared in " .. toml .. " -- skipping scope selection, resolving the full profile.\n")
		else
			local choices = { "(no scope -- full profile)" }
			for _, s in ipairs(scopes) do
				table.insert(choices, s)
			end
			local picked = fzf_single(choices, "Scope: ")
			if not picked then
				io.stderr:write("No scope selected. Exiting.\n")
				os.exit(1)
			end
			if picked ~= choices[1] then
				scope = picked
			end
		end
	end

	local kv = fetch_secretspec_kv(profile, scope)

	local rerun = "secretspec"
	if profile then
		rerun = rerun .. " --profile " .. profile
	end
	if scope then
		rerun = rerun .. " --scope " .. scope
	end

	return kv, rerun
end

local function run_doppler(opts)
	require_tool("doppler")

	local project = opts.project
	if not project then
		project = fzf_single(doppler_projects(), "Project: ")
		if not project then
			io.stderr:write("No project selected. Exiting.\n")
			os.exit(1)
		end
	end

	local config = opts.config
	if not config then
		config = fzf_single(doppler_configs(project), "Config: ")
		if not config then
			io.stderr:write("No config selected. Exiting.\n")
			os.exit(1)
		end
	end

	local kv = fetch_doppler_kv(project, config)

	local rerun = "doppler --project " .. project .. " --config " .. config

	return kv, rerun
end

-- ===== main =====

require_tool("fzf")
require_tool("jq")
require_tool("nvim")

local provider, opts
if args.secretspec then
	provider, opts = "secretspec", args
elseif args.doppler then
	provider, opts = "doppler", args
else
	local choice = fzf_single({ "secretspec", "doppler" }, "Provider: ")
	if not choice then
		io.stderr:write("No provider selected. Exiting.\n")
		os.exit(1)
	end
	provider, opts = choice, {}
end

local kv, rerun_prefix
if provider == "secretspec" then
	kv, rerun_prefix = run_secretspec(opts)
else
	kv, rerun_prefix = run_doppler(opts)
end

if #kv == 0 then
	io.stderr:write("No secrets resolved for this selection. Exiting.\n")
	os.exit(1)
end

local selected = {}
if opts.vars then
	local by_name = {}
	for _, pair in ipairs(kv) do
		by_name[pair.name] = pair.value
	end
	for raw_name in opts.vars:gmatch("[^,]+") do
		local name = raw_name:match("^%s*(.-)%s*$")
		local value = by_name[name]
		if value then
			table.insert(selected, { name = name, value = value })
		else
			io.stderr:write("Warning: '" .. name .. "' not found for this selection; skipping.\n")
		end
	end
else
	local lines = {}
	for _, pair in ipairs(kv) do
		table.insert(lines, pair.name .. "\t" .. pair.value)
	end
	for _, line in ipairs(fzf_multi_kv(lines, "Connections: ")) do
		local name, value = line:match("^(.-)\t(.*)$")
		table.insert(selected, { name = name, value = value })
	end
end

if #selected == 0 then
	io.stderr:write("No connection strings selected. Exiting.\n")
	os.exit(1)
end

if prompted then
	print("Selected connections:")
	local names = {}
	for _, s in ipairs(selected) do
		print("  - " .. s.name)
		table.insert(names, s.name)
	end

	print("")
	print("Rerun without prompts:")
	print("  dbconnect " .. rerun_prefix .. " --vars " .. table.concat(names, ","))
	print("")
end

local ex_cmd = "DBConnect"
for _, s in ipairs(selected) do
	ex_cmd = ex_cmd .. " " .. s.value
end

io.stdout:flush()
os.execute("nvim -c " .. shell_quote(ex_cmd))
