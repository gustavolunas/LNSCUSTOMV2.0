warning = function() 
    return  
end
warn = function() 
    return  
end
error = function() 
    return  
end

do

setDefaultTab("Main")

local GITHUB_OWNER = "gustavolunas"
local GITHUB_REPO = "LNSCUSTOMV2.0"
local GITHUB_BRANCH = "main"

local TREE_URL = "https://api.github.com/repos/" .. GITHUB_OWNER .. "/" .. GITHUB_REPO .. "/git/trees/" .. GITHUB_BRANCH .. "?recursive=1"
local RAW_URL = "https://raw.githubusercontent.com/" .. GITHUB_OWNER .. "/" .. GITHUB_REPO .. "/" .. GITHUB_BRANCH .. "/"

local downloadingUpdate = false

local updatePanel = setupUI([[
Panel
  id: lnsUpdatePanel
  height: 19
  margin-top: 1

  Button
    id: updateButton
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: 18
    text: Update Archives
    color: green
    font: verdana-11px-rounded
]])

local function updateMsg(text)
  text = tostring(text or "")

  if modules and modules.game_textmessage and modules.game_textmessage.displayGameMessage then
    modules.game_textmessage.displayGameMessage(text)
  else
    print(text)
  end
end

local function later(ms, fn)
  if type(schedule) == "function" then
    return schedule(ms, fn)
  end

  if type(scheduleEvent) == "function" then
    return scheduleEvent(fn, ms)
  end

  if g_dispatcher and g_dispatcher.scheduleEvent then
    return g_dispatcher:scheduleEvent(fn, ms)
  end

  return fn()
end

local function httpGet(url, cb, timeout)
  timeout = timeout or 15000
  local done = false

  local function finish(body, err)
    if done then return end
    done = true
    cb(body, err)
  end

  later(timeout, function()
    finish(nil, "timeout")
  end)

  if modules and modules.corelib and modules.corelib.HTTP and modules.corelib.HTTP.get then
    return modules.corelib.HTTP.get(url, function(body, err)
      finish(body, err)
    end)
  end

  if HTTP and HTTP.get then
    return HTTP.get(url, function(body, err)
      finish(body, err)
    end)
  end

  finish(nil, "HTTP.get indisponivel")
end

local function dirExists(path)
  if not g_resources or not g_resources.directoryExists then
    return false
  end

  local ok, result = pcall(function()
    return g_resources.directoryExists(path)
  end)

  return ok and result == true
end

local function ensureDir(path)
  if dirExists(path) then
    return true
  end

  if g_resources and g_resources.makeDir then
    pcall(function()
      g_resources.makeDir(path)
    end)
  end

  return dirExists(path)
end

local function ensureParentDirs(fullPath)
  local parts = {}

  for part in tostring(fullPath):gmatch("[^/]+") do
    table.insert(parts, part)
  end

  local current = ""

  for i = 1, #parts - 1 do
    current = current .. "/" .. parts[i]
    ensureDir(current)
  end
end

local function writeFile(path, content)
  if not g_resources or not g_resources.writeFileContents then
    return false
  end

  ensureParentDirs(path)

  local ok = pcall(function()
    g_resources.writeFileContents(path, tostring(content or ""))
  end)

  return ok == true
end

local function encodePath(path)
  return tostring(path or ""):gsub("([^%w%-%._~/])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
end

local function getConfigName()
  local name = nil

  pcall(function()
    name = modules.game_bot.contentsPanel.config:getCurrentOption().text
  end)

  if not name or name == "" then
    name = "default"
  end

  return name
end

local function getBaseDir()
  return "/bot/" .. getConfigName()
end

local function getProfile10Dir()
  return "/settings/profile_10"
end

local function getArchivePartName(path)
  local lower = tostring(path or ""):lower()
  local name = lower:match("([^/]+)$") or lower

  if name == "archivesfull1.lua" then
    return "archivesfull1.lua"
  end

  if name == "archivesfull2.lua" then
    return "archivesfull2.lua"
  end

  if name == "archivesfull3.lua" then
    return "archivesfull3.lua"
  end

  return nil
end

local function getSavePathForGithubFile(filePath)
  local archiveName = getArchivePartName(filePath)

  if archiveName then
    return getProfile10Dir() .. "/" .. archiveName
  end

  return getBaseDir() .. "/" .. filePath
end

local function wantedGithubFile(path, fileType)
  if fileType ~= "blob" then
    return false
  end

  local lower = tostring(path or ""):lower()

  if lower == "_loader.lua" then
    return true
  end

  if lower == "lnsloader.lua" then
    return true
  end

  if getArchivePartName(lower) then
    return true
  end

  if lower:sub(1, 8) == "cavebot/" then
    return true
  end

  if lower:sub(1, 10) == "targetbot/" then
    return true
  end

  if lower:sub(1, 5) == "vbot/" then
    return true
  end

  return false
end

local function finishUpdate(total)
  downloadingUpdate = false

  updateMsg("[LNS UPDATE] Download concluido: " .. tostring(total or 0) .. " arquivo(s).")

  later(1000, function()
    if type(refresh) == "function" then
      refresh()
    elseif type(reload) == "function" then
      reload()
    else
      updateMsg("[LNS UPDATE] Finalizado. Reabra/recarregue o bot manualmente.")
    end
  end)
end

local function failUpdate(reason)
  downloadingUpdate = false
  updateMsg("[LNS UPDATE] Falhou: " .. tostring(reason or "erro desconhecido"))
end

local function downloadFiles(files)
  if type(files) ~= "table" or #files == 0 then
    failUpdate("nenhum arquivo encontrado")
    return
  end

  ensureDir(getBaseDir())
  ensureDir(getProfile10Dir())

  local total = #files
  local done = 0
  local index = 1
  local active = 0
  local concurrency = 4
  local failed = {}

  local function downloadOne(filePath, cb)
    local url = RAW_URL .. encodePath(filePath)
    local savePath = getSavePathForGithubFile(filePath)

    httpGet(url, function(body, err)
      if err or not body or body == "" then
        cb(false, filePath, "HTTP: " .. tostring(err or "body vazio"))
        return
      end

      if not writeFile(savePath, body) then
        cb(false, filePath, "falha ao salvar")
        return
      end

      cb(true, filePath)
    end, 20000)
  end

  local function pump()
    while active < concurrency and index <= total do
      local filePath = files[index]
      index = index + 1
      active = active + 1

      downloadOne(filePath, function(ok, path, reason)
        active = active - 1
        done = done + 1

        if not ok then
          table.insert(failed, tostring(path) .. " / " .. tostring(reason or "erro"))
        end

        updateMsg("[LNS UPDATE] Progresso: " .. tostring(done) .. "/" .. tostring(total))

        if done >= total then
          if #failed > 0 then
            failUpdate(failed[1])

            for i = 1, #failed do
              updateMsg("[LNS FAIL] " .. tostring(failed[i]))
            end

            return
          end

          finishUpdate(total)
        else
          later(1, pump)
        end
      end)
    end
  end

  pump()
end

local function loadGithubTree()
  updateMsg("[LNS UPDATE] Procurando arquivos na nuvem...")

  httpGet(TREE_URL, function(body, err)
    if err or not body or body == "" then
      failUpdate("falha ao ler nuvem: " .. tostring(err or "resposta vazia"))
      return
    end

    if not json or not json.decode then
      failUpdate("json.decode indisponivel")
      return
    end

    local ok, data = pcall(function()
      return json.decode(body)
    end)

    if not ok or type(data) ~= "table" or type(data.tree) ~= "table" then
      failUpdate("resposta invalida da nuvem")
      return
    end

    local files = {}

    for _, item in ipairs(data.tree) do
      local path = tostring(item.path or "")
      local fileType = tostring(item.type or "")

      if wantedGithubFile(path, fileType) then
        table.insert(files, path)
      end
    end

    table.sort(files)

    if #files == 0 then
      failUpdate("nenhum arquivo selecionado encontrado")
      return
    end

    updateMsg("[LNS UPDATE] Arquivos encontrados. Iniciando download...")
    downloadFiles(files)
  end, 20000)
end

updatePanel.updateButton.onClick = function()
  if downloadingUpdate then
    updateMsg("[LNS UPDATE] Download ja esta em andamento.")
    return
  end

  downloadingUpdate = true
  loadGithubTree()
end

end
