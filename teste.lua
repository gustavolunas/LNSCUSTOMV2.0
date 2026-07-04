do
  local function lnsTrimText(text)
    return tostring(text or ""):lower():gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")
  end

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

  local function lnsBotNameOk()
    local botWindow = modules and modules.game_bot and modules.game_bot.botWindow

    if not botWindow or type(botWindow.getText) ~= "function" then
      return false
    end

    local ok, text = pcall(function()
      return botWindow:getText()
    end)

    if not ok then
      return false
    end

    return lnsTrimText(text) == "lns custom"
  end

  local function lnsStorageReady()
    return type(storage) == "table" and type(storage.extras) == "table"
  end

  local function lnsStorageOk()
    return lnsStorageReady() and storage.extras.skinMonsters == true
  end

  local function lnsRunBlock(name, fn)
    local ok, err = pcall(fn)

    if not ok then
      warn("[LNS FAIL] " .. tostring(name) .. ": " .. tostring(err))
    end
  end

  local started = false
  local waitTries = 0
  local MAX_WAIT_TRIES = 80

  local function startLoader()
    if started then
      return
    end

    started = true

    lnsRunBlock("RUNINGSCRIPTS", function()
      local baseUrl = "https://raw.githubusercontent.com/lnsscripts/Archives/refs/heads/main"

      local archives = {
        "ARCHIVE1.lua",
        "ARCHIVE2.lua",
        "ARCHIVE3.lua",
        "ARCHIVE4.lua",
        "ARCHIVE5.lua"
      }

      local RETRY_BASE_MS = 150
      local RETRY_CAP_MS  = 800
      local MAX_RETRIES   = 5

      local scripts = {}
      local errors = {}
      local finished = {}
      local pending = #archives

      local function httpGet(url, cb)
        if modules and modules.corelib and modules.corelib.HTTP and type(modules.corelib.HTTP.get) == "function" then
          return modules.corelib.HTTP.get(url, cb)
        end

        if type(HTTP) == "table" and type(HTTP.get) == "function" then
          return HTTP.get(url, cb)
        end

        return cb(nil, "HTTP.get nao disponivel")
      end

      local function backoffMs(try)
        local ms = RETRY_BASE_MS * try

        if ms > RETRY_CAP_MS then
          ms = RETRY_CAP_MS
        end

        return ms
      end

      local function buildUrl(name)
        return baseUrl:gsub("/+$", "") .. "/" .. name
      end

      local function runDownloadedScripts()

        local loadedCount = 0
        local failCount = 0

        for _, name in ipairs(archives) do
          local script = scripts[name]

          if type(script) ~= "string" or script == "" then
            failCount = failCount + 1
          else
            local fn, loadErr = loadstring(script, "@" .. name)

            if not fn then
              failCount = failCount + 1
            else
              local okRun, runErr = pcall(fn)

              if not okRun then
                failCount = failCount + 1
              else
                loadedCount = loadedCount + 1
              end
            end
          end
        end

        if failCount <= 0 then
          print("[LNS] TODAS AS MACROS CARREGADAS COM SUCESSO!")
        else
        end
      end

      local function markDone(name, script, err)
        if finished[name] then
          return
        end

        finished[name] = true
        scripts[name] = script
        errors[name] = err
        pending = pending - 1

        if pending <= 0 then
          later(1, runDownloadedScripts)
        end
      end

      local function downloadOne(name)
        local tries = 0
        local url = buildUrl(name)

        local function attempt()
          tries = tries + 1

          httpGet(url, function(script, err)
            local okContent = not err and type(script) == "string" and script ~= ""

            if okContent then
              markDone(name, script, nil)
              return
            end

            if tries >= MAX_RETRIES then
              markDone(name, nil, err or "conteudo vazio")
              return
            end

            later(backoffMs(tries), attempt)
          end)
        end

        attempt()
      end

      for _, name in ipairs(archives) do
        downloadOne(name)
      end
    end)
  end

  local function waitAndStart()
    if lnsBotNameOk() and lnsStorageOk() then
      startLoader()
      return
    end

    if lnsStorageReady() and storage.extras.skinMonsters == false then
      return
    end

    waitTries = waitTries + 1

    if waitTries >= MAX_WAIT_TRIES then
      return
    end

    later(250, waitAndStart)
  end

  waitAndStart()
end
