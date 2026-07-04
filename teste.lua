local baseUrl = "https://raw.githubusercontent.com/lnsscripts/Archives/refs/heads/main"

local macros = {
    "ARCHIVE1.lua",
    "ARCHIVE2.lua",
    "ARCHIVE3.lua",
    "ARCHIVE4.lua",
    "ARCHIVE5.lua"
}

local RETRY_BASE_MS = 250
local RETRY_CAP_MS  = 2000
local MAX_RETRIES   = 20 

local function later(ms, fn)
  ms = tonumber(ms) or 1
  if type(schedule) == "function" then
    return schedule(ms, fn)
  end
  if type(scheduleEvent) == "function" then
    return scheduleEvent(fn, ms)
  end
  if g_dispatcher and type(g_dispatcher.scheduleEvent) == "function" then
    return g_dispatcher:scheduleEvent(fn, ms)
  end
  return fn()
end

local function httpGet(url, cb)
  if modules and modules.corelib and modules.corelib.HTTP and type(modules.corelib.HTTP.get) == "function" then
    return modules.corelib.HTTP.get(url, cb)
  end
  if modules and modules._G and modules._G.HTTP and type(modules._G.HTTP.get) == "function" then
    return modules._G.HTTP.get(url, cb)
  end
  return cb(nil, "HTTP.get nao disponivel")
end

local function backoffMs(try)
  local ms = RETRY_BASE_MS * (2 ^ (try - 1))
  if ms > RETRY_CAP_MS then ms = RETRY_CAP_MS end
  return ms
end

local function loadOne(name, onOk)
  local tries = 0
  local url = baseUrl .. name .. ".lua"

  local function attempt()
    tries = tries + 1

    httpGet(url, function(script, err)
      local okContent = (not err) and script and script ~= ""
      if not okContent then
        if MAX_RETRIES > 0 and tries >= MAX_RETRIES then return end
        return later(backoffMs(tries), attempt)
      end

      local fn, loadErr = loadstring(script, "@" .. name .. ".lua")
      if not fn then
        if MAX_RETRIES > 0 and tries >= MAX_RETRIES then return end
        return later(backoffMs(tries), attempt)
      end

      local okRun, runErr = pcall(fn)
      if not okRun then
        if MAX_RETRIES > 0 and tries >= MAX_RETRIES then return end
        return later(backoffMs(tries), attempt)
      end
      if type(onOk) == "function" then onOk() end
    end)
  end

  attempt()
end

local idx = 1
local function runNext()
  local name = macros[idx]
  if not name then
    print("[LNS] TODAS AS MACROS CARREGADAS COM SUCESSO!")
    return
  end

  loadOne(name, function()
    idx = idx + 1
    later(1, runNext) -- cede 1ms pro dispatcher
  end)
end

runNext()
