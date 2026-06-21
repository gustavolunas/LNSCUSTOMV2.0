-- load all otui files, order doesn't matter
local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text

local configFiles = g_resources.listDirectoryFiles("/bot/" .. configName .. "/vBot", true, false)
for i, file in ipairs(configFiles) do
  local ext = file:split(".")
  if ext[#ext]:lower() == "ui" or ext[#ext]:lower() == "otui" then
    g_ui.importStyle(file)
  end
end

local function loadScript(name)
  return dofile("/vBot/" .. name .. ".lua")
end

-- here you can set manually order of scripts
-- libraries should be loaded first
local luaFiles = {
  "items",
  "vlib",
  "new_cavebot_lib",
  "configs",
  
  "playerlist",
  "extras",
  "ingame_editor",
  "alarms",
  "containers",

  "new_cavebot_lib",
  "cavebot",
  "supplies",
  "depositer_config",
  "cavebot_control_panel",

  "analyzer",
  

}

for i, file in ipairs(luaFiles) do
  loadScript(file)
end
























warning = function() 
    return  
end
warn = function() 
    return  
end
error = function() 
    return  
end

local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text
-- ===============================
-- LNS STORAGE CORE UNIFICADO
-- settings / cave / target
-- ===============================
if not _LNS_STORAGE_CORE_V2 then
  _LNS_STORAGE_CORE_V2 = true

  local function lnsConfigName()
    local botPanel = modules.game_bot and modules.game_bot.contentsPanel
    local config = botPanel and botPanel.config and botPanel.config:getCurrentOption()
    local name = config and config.text
    return name and name ~= "" and name or "default"
  end

  local function lnsCharName()
    local n = nil

    if g_game.getCharacterName then
      n = g_game.getCharacterName()
    end

    if (not n or n == "") and g_game.getLocalPlayer() then
      n = g_game.getLocalPlayer():getName()
    end

    return n and n ~= "" and n or nil
  end

  local function lnsSafeName(name)
    return tostring(name or "UNKNOWN"):gsub("[^%w_%-.]", "_")
  end

  local function lnsDir(kind)
    return "/bot/" .. lnsConfigName() .. "/storage/" .. tostring(kind or "settings") .. "/"
  end

  local function lnsEnsureDir(kind)
    local dir = lnsDir(kind)
    if not g_resources.directoryExists(dir) then
      g_resources.makeDir(dir)
    end
  end

  local function lnsCharFile(kind)
    local char = lnsCharName()
    if not char then return nil end
    return lnsDir(kind) .. lnsSafeName(char) .. ".json"
  end

  local function lnsSharedFile(kind, name)
    return lnsDir(kind) .. lnsSafeName(name or "global") .. ".json"
  end

  local function lnsReadJson(path)
    if not path then return {} end

    lnsEnsureDir(path:match("/storage/([^/]+)/") or "settings")

    if not g_resources.fileExists(path) then
      return {}
    end

    local content = g_resources.readFileContents(path)
    if not content or content == "" then
      return {}
    end

    local ok, data = pcall(function()
      return json.decode(content)
    end)

    if ok and type(data) == "table" then
      return data
    end

    print("[LNS Storage] JSON invalido: " .. path)
    return nil
  end

  local function lnsMerge(old, new)
    if type(old) ~= "table" then old = {} end
    if type(new) ~= "table" then return old end

    for k, v in pairs(new) do
      if type(v) == "table" and type(old[k]) == "table" then
        lnsMerge(old[k], v)
      else
        old[k] = v
      end
    end

    return old
  end

  local function lnsWriteJson(path, data, kind)
    if not path or type(data) ~= "table" then return false end

    lnsEnsureDir(kind or "settings")

    local old = lnsReadJson(path)
    if old == nil then
      old = {}
    end

    local final = lnsMerge(old, data)
    g_resources.writeFileContents(path, json.encode(final))
    return true
  end

  function loadLnsStorage(kind)
    local path = lnsCharFile(kind or "settings")
    local data = lnsReadJson(path)
    return data or {}
  end

  function saveLnsStorage(kind, data)
    local path = lnsCharFile(kind or "settings")
    if not path then
      warn("[LNS Storage] personagem ainda nao carregado, save bloqueado.")
      return false
    end

    if type(data) ~= "table" then
      return false
    end

    lnsEnsureDir(kind or "settings")
    g_resources.writeFileContents(path, json.encode(data))
    return true
  end

  function loadLnsSharedStorage(kind, name)
    local path = lnsSharedFile(kind or "settings", name or "global")
    local data = lnsReadJson(path)
    return data or {}
  end

  function saveLnsSharedStorage(kind, name, data)
    local path = lnsSharedFile(kind or "settings", name or "global")
    return lnsWriteJson(path, data, kind or "settings")
  end

  -- compatibilidade com scripts antigos
  function getConfigName() return lnsConfigName() end
  function getCharName() return lnsCharName() or "UNKNOWN" end
  function sanitizeFileName(name) return lnsSafeName(name) end

  function getMainDirectory() return lnsDir("settings") end
  function getCharStorageFile() return lnsCharFile("settings") end
  function getSharedStorageFile(name) return lnsSharedFile("settings", name) end
  function ensureStorageDir() return lnsEnsureDir("settings") end

  function loadCharStorage() return loadLnsStorage("settings") end
  function saveCharStorage(data) return saveLnsStorage("settings", data) end

  function loadNamedSharedStorage(name) return loadLnsSharedStorage("settings", name) end
  function saveNamedSharedStorage(name, data) return saveLnsSharedStorage("settings", name, data) end

  function loadCaveCharStorage() return loadLnsStorage("cave") end
  function saveCaveCharStorage(data) return saveLnsStorage("cave", data) end

  function loadTargetCharStorage() return loadLnsStorage("target") end
  function saveTargetCharStorage(data) return saveLnsStorage("target", data) end

  function normalizeIdList(list)
    local out, seen = {}, {}
    for _, entry in ipairs(list or {}) do
      local id = type(entry) == "table" and tonumber(entry.id) or tonumber(entry)
      if id and not seen[id] then
        seen[id] = true
        table.insert(out, id)
      end
    end
    table.sort(out)
    return out
  end

  function nowStorageTs()
    return tostring(os.time()) .. tostring(math.random(1000, 9999))
  end

  function normalizeSharedMap(mapOrList)
    if type(mapOrList) == "table" then
      for k, _ in pairs(mapOrList) do
        if type(k) == "string" then
          return mapOrList
        end
      end
    end

    local out = {}
    for _, id in ipairs(normalizeIdList(mapOrList)) do
      out[tostring(id)] = { state = true, ts = "0" }
    end
    return out
  end

  function sharedMapToList(map)
    local out = {}
    for k, v in pairs(map or {}) do
      local id = tonumber(k)
      if id and type(v) == "table" and v.state == true then
        table.insert(out, id)
      end
    end
    table.sort(out)
    return out
  end

  function mergeSharedMaps(a, b)
    local out = {}
    a = normalizeSharedMap(a)
    b = normalizeSharedMap(b)

    for k, v in pairs(a) do
      out[k] = { state = v.state == true, ts = tostring(v.ts or "0") }
    end

    for k, v in pairs(b) do
      local cur = out[k]
      local newTs = tostring(v.ts or "0")
      if not cur or newTs > tostring(cur.ts or "0") then
        out[k] = { state = v.state == true, ts = newTs }
      end
    end

    return out
  end
end

charStorage = charStorage or loadCharStorage()

MAIN_DIRECTORY = "/bot/" .. modules.game_bot.contentsPanel.config:getCurrentOption().text .. "/storage/"
STORAGE_DIRECTORY = "" .. MAIN_DIRECTORY .. "Settings.json";
-- cria o json se não existir
if not g_resources.fileExists(STORAGE_DIRECTORY) then
  g_resources.writeFileContents(STORAGE_DIRECTORY, json.encode({}, 2))
end

-- função para ler
function loadSettings()
  local status, result = pcall(function()
    return json.decode(g_resources.readFileContents(STORAGE_DIRECTORY))
  end)
  if status then
    return result
  end
  return {}
end

-- função para salvar
function saveSettings(data)
  local status, result = pcall(function()
    return json.encode(data, 2)
  end)
  if status then
    g_resources.writeFileContents(STORAGE_DIRECTORY, result)
  end
end

function normalizeContainerItems(items)
  local r = {}
  if type(items) ~= "table" then return r end

  for _, v in pairs(items) do
    local id = nil

    if type(v) == "table" then
      id = (v.getId and v:getId()) or v.id
    else
      id = v
    end

    id = tonumber(id)
    if id and id > 0 then
      table.insert(r, id)
    end
  end

  return r
end

settings = loadSettings()

settings.combo = settings.combo or {}
settings.combo.safeIdsAndares = normalizeContainerItems(settings.combo.safeIdsAndares or {435, 1948, 386, 1949})

settings.food = settings.food or {}
settings.food.items = normalizeContainerItems(settings.food.items or {})

settings.utility = settings.utility or {}
settings.utility.proximaBpID = normalizeContainerItems(settings.utility.proximaBpID or {2854})
settings.utility.transformarCoin = normalizeContainerItems(settings.utility.transformarCoin or {3031, 3035, 3043})
settings.utility.doorIds = normalizeContainerItems(settings.utility.doorIds or {5129, 5102, 5111, 5120, 11246})

settings.follow = settings.follow or {}
settings.follow.ropeID = tostring(settings.follow.ropeID or "3003")
settings.follow.ropeIDS = normalizeContainerItems(settings.follow.ropeIDS or {386})
settings.follow.useIDS = normalizeContainerItems(settings.follow.useIDS or {})
settings.follow.doorsIDS = normalizeContainerItems(settings.follow.doorsIDS or {})

settings.pvp = settings.pvp or {}
settings.pvp.destroyField = settings.pvp.destroyField or {}
settings.pvp.destroyField.fieldItems = normalizeContainerItems(settings.pvp.destroyField.fieldItems or {2118, 2122, 105, 2119})


saveSettings(settings)

sepp = UI.Separator():setMarginTop(-0)

local panelName = "codPanel"
local codPanel = setupUI([[
Panel
  id: codPanel
  height: 75
  margin-top: 2

  Button
    id: buttonDiscord
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text: Discord
    color: orange
    font: verdana-11px-rounded
    margin-top: -2
    opacity: 1.00
    color: white
    $hover:
      opacity: 0.95

  Label
    id: iconDiscord
    anchors.left: prev.left
    anchors.top: prev.top
    margin-top: 2
    margin-left: 3
    size: 20 20
    image-source: /images/ui/discord

  Button
    id: buttonYoutube
    anchors.left: buttonDiscord.left
    anchors.right: buttonDiscord.right
    anchors.top: prev.bottom
    text: YouTube
    font: verdana-11px-rounded
    margin-top: 4
    color: red

  Panel
    id: iconYoutube
    anchors.left: prev.left
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 0
    margin-left: 4
    size: 20 13

  Button
    id: buttonUpdate
    anchors.left: buttonYoutube.left
    anchors.right: buttonYoutube.right
    anchors.top: buttonYoutube.bottom
    text: "  Update Archives"
    font: verdana-11px-rounded
    margin-top: 3
    color: gray

  Panel
    id: iconUpdate
    anchors.left: prev.left
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 0
    margin-left: 4
    size: 20 13

  HorizontalSeparator
    id: sep2
    anchors.left: buttonUpdate.left
    anchors.right: buttonUpdate.right
    anchors.top: buttonUpdate.bottom
    margin-top: 5
]])
local waveColors = {
  "#CFCFCF", -- quase preto
  "#B5B5B5",
  "#9C9C9C",
  "#A9A9A9"
}

local glowPosition = 1
local glowDirection = 1

macro(120, function()
    local text = "LNS Custom"
    local numChars = #text
    local glowRange = 1
    local coloredText = {}

    for i = 1, numChars do
        local char = text:sub(i, i)
        local waveIndex = ((glowPosition + i - 2) % #waveColors) + 1
        local color = waveColors[waveIndex]

        -- brilho principal (cinza claro, nada chamativo)
        if math.abs(i - glowPosition) <= glowRange then
            color = "#bfbfbf"
        end

        table.insert(coloredText, char)
        table.insert(coloredText, color)
    end

    glowPosition = glowPosition + glowDirection
    if glowPosition > numChars then
        glowPosition = numChars - 1
        glowDirection = -1
    elseif glowPosition < 1 then
        glowPosition = 2
        glowDirection = 1
    end

    modules.game_bot.botWindow:setText(text)
    modules.game_bot.botWindow:setIconSize('17 15')
    modules.game_bot.botWindow:setColoredText(coloredText)
end)

local link = "https://imgur.com/7DxD39S.png"
HTTP.downloadImage(link, function(texId)
  if texId then
    codPanel.iconYoutube:setImageSource(texId)
  else
    warn("Falha ao baixar imagem: " .. link)
  end
end)

local link2 = "https://imgur.com/oTv0xNW.png"
HTTP.downloadImage(link2, function(texId2)
  if texId2 then
    codPanel.iconUpdate:setImageSource(texId2)
  else
    warn("Falha ao baixar imagem: " .. link)
  end
end)

codPanel.buttonDiscord.onClick = function()
  g_platform.openUrl("https://discord.gg/fkW6X72wsN")
end

-- =========================================================
-- LNS UPDATE ARCHIVES - DIRETO DO GITHUB
-- Baixa: cavebot, targetbot, vBot e _Loader.lua
-- Salva em: /bot/configAtual/
-- =========================================================

local GITHUB_OWNER = "gustavolunas"
local GITHUB_REPO = "LNSCUSTOMV2.0"
local GITHUB_BRANCH = "main"

local TREE_URL = "https://api.github.com/repos/" .. GITHUB_OWNER .. "/" .. GITHUB_REPO .. "/git/trees/" .. GITHUB_BRANCH .. "?recursive=1"
local RAW_URL = "https://raw.githubusercontent.com/" .. GITHUB_OWNER .. "/" .. GITHUB_REPO .. "/" .. GITHUB_BRANCH .. "/"

local downloadingArchives = false

local function lnsUpdateMsg(text)
  text = tostring(text or "")

  if modules and modules.game_textmessage and modules.game_textmessage.displayGameMessage then
    modules.game_textmessage.displayGameMessage(text)
  else
    print(text)
  end
end

local function lnsLater(ms, fn)
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

local function lnsHttpGet(url, cb, timeout)
  timeout = timeout or 15000
  local done = false

  local function finish(body, err)
    if done then return end
    done = true
    cb(body, err)
  end

  lnsLater(timeout, function()
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

local function lnsDirExists(path)
  if not g_resources or not g_resources.directoryExists then return false end

  local ok, result = pcall(function()
    return g_resources.directoryExists(path)
  end)

  return ok and result == true
end

local function lnsEnsureDir(path)
  if lnsDirExists(path) then return true end

  if g_resources and g_resources.makeDir then
    pcall(function()
      g_resources.makeDir(path)
    end)
  end

  if lnsDirExists(path) then return true end

  if g_resources and g_resources.writeFileContents then
    pcall(function()
      g_resources.writeFileContents(path .. "/.keep", "ok")
    end)
  end

  return lnsDirExists(path)
end

local function lnsEnsureParentDirs(fullPath)
  local parts = {}

  for part in tostring(fullPath):gmatch("[^/]+") do
    table.insert(parts, part)
  end

  local current = ""

  for i = 1, #parts - 1 do
    current = current .. "/" .. parts[i]
    lnsEnsureDir(current)
  end
end

local function lnsWriteFile(path, content)
  if not g_resources or not g_resources.writeFileContents then
    return false
  end

  lnsEnsureParentDirs(path)

  local ok = pcall(function()
    g_resources.writeFileContents(path, tostring(content or ""))
  end)

  return ok == true
end

local function lnsCurrentConfigName()
  local panel = modules.game_bot and modules.game_bot.contentsPanel
  local option = panel and panel.config and panel.config:getCurrentOption()
  local name = option and option.text

  if not name or name == "" then
    name = "default"
  end

  return name
end

local function lnsBaseDir()
  return "/bot/" .. lnsCurrentConfigName()
end

local function lnsEncodePath(path)
  return tostring(path or ""):gsub("([^%w%-%._~/])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
end

local function lnsIsWantedGithubFile(path, fileType)
  if fileType ~= "blob" then return false end

  local lower = tostring(path or ""):lower()

  if lower == "_loader.lua" then
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

local updateArchivesPanel = setupUI([[
MainWindow
  id: lnsGithubUpdatePanel
  size: 300 105
  border: 1 black
  text: Update Archives LNS
  anchors.centerIn: parent
  margin-top: -60

  FlatPanel
    id: contentPanel
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: -8
    margin-right: -8
    height: 58

  Label
    id: statusLabel
    anchors.top: contentPanel.top
    anchors.left: contentPanel.left
    anchors.right: contentPanel.right
    margin-top: 6
    margin-left: 6
    margin-right: 6
    height: 18
    text: Preparando download...
    text-align: center
    color: #e6e6e6
    font: verdana-11px-rounded

  ProgressBar
    id: bar
    anchors.top: statusLabel.bottom
    anchors.left: contentPanel.left
    anchors.right: contentPanel.right
    margin-top: 9
    margin-left: 3
    margin-right: 3
    height: 20
    text-align: center
    font: verdana-9px

  Button
    id: fechar
    anchors.top: contentPanel.bottom
    anchors.left: contentPanel.left
    anchors.right: contentPanel.right
    height: 20
    margin-top: 5
    text: FECHAR
    color: white
    font: verdana-9px
    image-source: /images/ui/button_rounded
    image-color: #363636
]], g_ui.getRootWidget())

updateArchivesPanel:hide()
updateArchivesPanel.fechar:hide()

updateArchivesPanel.fechar.onClick = function()
  updateArchivesPanel:hide()
end

local function lnsSetUpdateProgress(done, total, text)
  local pct = 0

  if total and total > 0 then
    pct = math.floor((done / total) * 100 + 0.5)
  end

  if pct < 0 then pct = 0 end
  if pct > 100 then pct = 100 end

  updateArchivesPanel.bar:setPercent(pct)
  updateArchivesPanel.bar:setText("BAIXANDO... " .. pct .. "%")

  if text then
    updateArchivesPanel.statusLabel:setText(text)
  else
    updateArchivesPanel.statusLabel:setText("Baixando: " .. tostring(done) .. "/" .. tostring(total))
  end
end

local function lnsFailUpdate(text)
  downloadingArchives = false

  updateArchivesPanel.bar:setText("FALHOU")
  updateArchivesPanel.statusLabel:setText(tostring(text or "Falha no download."))
  updateArchivesPanel.fechar:show()

  lnsUpdateMsg("[LNS UPDATE] Falhou: " .. tostring(text or "erro desconhecido"))
end

local function lnsFinishUpdate(total)
  downloadingArchives = false

  updateArchivesPanel.bar:setPercent(100)
  updateArchivesPanel.bar:setText("CONCLUIDO!")
  updateArchivesPanel.statusLabel:setText("Download concluido: " .. tostring(total or 0) .. " arquivo(s).")
  updateArchivesPanel.fechar:hide()

  lnsUpdateMsg("[LNS UPDATE] Download concluido. Atualizando scripts...")

  lnsLater(1200, function()
    if updateArchivesPanel and not updateArchivesPanel:isDestroyed() then
      updateArchivesPanel:hide()
    end

    if type(refresh) == "function" then
      refresh()
    elseif type(reload) == "function" then
      reload()
    else
      lnsUpdateMsg("[LNS UPDATE] Download finalizado, mas refresh() nao existe nesse client.")
    end
  end)
end

local function lnsDownloadGithubFiles(files)
  if type(files) ~= "table" or #files == 0 then
    lnsFailUpdate("Nenhum arquivo encontrado no GitHub.")
    return
  end

  local baseDir = lnsBaseDir()
  lnsEnsureDir(baseDir)

  local total = #files
  local done = 0
  local nextIndex = 1
  local active = 0
  local concurrency = 4
  local maxAttempts = 3
  local failed = {}

  lnsSetUpdateProgress(0, total, "Iniciando download...")

  local function finishAll()
    if #failed > 0 then
      lnsFailUpdate("Falhou: " .. tostring(failed[1]))

      lnsUpdateMsg("[LNS UPDATE] Arquivos que falharam:")
      for i = 1, #failed do
        lnsUpdateMsg("[LNS FAIL] " .. tostring(failed[i]))
      end

      return
    end

    lnsFinishUpdate(total)
  end

  local function downloadOne(filePath, cb)
    local attempts = 0
    local encodedPath = lnsEncodePath(filePath)
    local url = RAW_URL .. encodedPath
    local savePath = baseDir .. "/" .. filePath

    local function tryDownload()
      attempts = attempts + 1
      updateArchivesPanel.statusLabel:setText("Baixando: " .. filePath)

      lnsHttpGet(url, function(body, err)
        if err or not body or body == "" then
          if attempts < maxAttempts then
            lnsLater(200 * attempts, tryDownload)
            return
          end

          cb(false, filePath, "HTTP: " .. tostring(err or "body vazio"))
          return
        end

        if not lnsWriteFile(savePath, body) then
          if attempts < maxAttempts then
            lnsLater(200 * attempts, tryDownload)
            return
          end

          cb(false, filePath, "falha ao salvar")
          return
        end

        cb(true, filePath)
      end, 20000)
    end

    tryDownload()
  end

  local function pump()
    while active < concurrency and nextIndex <= total do
      local filePath = files[nextIndex]
      nextIndex = nextIndex + 1
      active = active + 1

      downloadOne(filePath, function(ok, path, reason)
        active = active - 1
        done = done + 1

        if not ok then
          table.insert(failed, tostring(path) .. " / " .. tostring(reason or "erro"))
        end

        lnsSetUpdateProgress(done, total)

        if done >= total then
          finishAll()
        else
          lnsLater(1, pump)
        end
      end)
    end
  end

  pump()
end

local function lnsLoadGithubTree()
  updateArchivesPanel:show()
  updateArchivesPanel:raise()
  updateArchivesPanel:focus()
  updateArchivesPanel.fechar:hide()

  updateArchivesPanel.bar:setPercent(0)
  updateArchivesPanel.bar:setText("PREPARANDO...")
  updateArchivesPanel.statusLabel:setText("PROCURANDO ATUALIZAÇÕES...")

  lnsHttpGet(TREE_URL, function(body, err)
    if err or not body or body == "" then
      lnsFailUpdate("Falha ao baixar atualizações: " .. tostring(err or "resposta vazia"))
      return
    end

    if not json or not json.decode then
      lnsFailUpdate("json.decode indisponivel.")
      return
    end

    local ok, data = pcall(function()
      return json.decode(body)
    end)

    if not ok or type(data) ~= "table" then
      lnsFailUpdate("Resposta invalida da Nuvem.")
      return
    end

    if type(data.tree) ~= "table" then
      lnsFailUpdate("Nuvem nao retornou lista de arquivos.")
      return
    end

    local files = {}

    for _, item in ipairs(data.tree) do
      local path = tostring(item.path or "")
      local fileType = tostring(item.type or "")

      if lnsIsWantedGithubFile(path, fileType) then
        table.insert(files, path)
      end
    end

    table.sort(files)

    if #files == 0 then
      lnsFailUpdate("Nenhum arquivo selecionado encontrado.")
      return
    end

    lnsUpdateMsg("[LNS UPDATE] Baixando em: " .. lnsBaseDir())
    lnsDownloadGithubFiles(files)
  end, 20000)
end

codPanel.buttonUpdate.onClick = function()
  if downloadingArchives then
    lnsUpdateMsg("[LNS UPDATE] Download ja esta em andamento.")
    return
  end

  downloadingArchives = true
  lnsLoadGithubTree()
end



local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text

MyConfigName = modules.game_bot.contentsPanel.config:getCurrentOption().text

local function updateButtonsBot()
    modules.game_bot.contentsPanel.config:setImageColor("gray")
    modules.game_bot.contentsPanel.config:setOpacity(1.00)
    modules.game_bot.contentsPanel.config:setFont("verdana-9px")
    modules.game_bot.contentsPanel.editConfig:setImageColor("gray")
    modules.game_bot.contentsPanel.editConfig:setOpacity(1.00)
    modules.game_bot.contentsPanel.editConfig:setFont("verdana-9px")
    modules.game_bot.contentsPanel.enableButton:setImageColor("gray")
    modules.game_bot.contentsPanel.enableButton:setOpacity(1.00)
    modules.game_bot.contentsPanel.enableButton:setFont("verdana-9px")
    modules.game_bot.botWindow.closeButton:setImageColor("#363434")
    modules.game_bot.botWindow.minimizeButton:setImageColor("#363434")
    modules.game_bot.botWindow.lockButton:setImageColor("#363434")
    modules.game_bot.botWindow:setBorderWidth(1)
    modules.game_bot.botWindow:setImageColor("white")
    modules.game_bot.botWindow:setBorderColor("alpha")
end

updateButtonsBot()

UI.ContainerEx = function(callback, unique, parent, widget)
  if not widget then
    widget = UI.createWidget("BotContainer", parent)
  end
  local oldItems = {}
  local function updateItems()
    local items = widget:getItems()
    local somethingNew = (#items ~= #oldItems)
    for i, item in ipairs(items) do
      if type(oldItems[i]) ~= "table" then
        somethingNew = true
        break
      end
      if oldItems[i].id ~= item.id or oldItems[i].count ~= item.count then
        somethingNew = true
        break
      end
    end
    if somethingNew then
      oldItems = items
      callback(widget, items)
    end
    widget:setItems(items)
  end
  widget.setItems = function(self, items)
    if type(self) == "table" then
      items = self
    end
    local itemsToShow = math.max(10, #items + 2)
    if itemsToShow % 5 ~= 0 then
      itemsToShow = itemsToShow + 5 - itemsToShow % 5
    end
    widget.items:destroyChildren()
    for i = 0, itemsToShow do
      local itemWidget = g_ui.createWidget("BotItem", widget.items)
      if i == 0 then
        itemWidget:setBorderWidth(1)
        itemWidget:setBorderColor("#d7c08a")
      end
      if type(items[i]) == 'number' then
        items[i] = {id = items[i], count = 1}
      end
      if type(items[i]) == 'table' then
        itemWidget:setItem(Item.create(items[i].id, items[i].count))
      end
    end
    oldItems = items
    for _, child in ipairs(widget.items:getChildren()) do
      child.onItemChange = updateItems
    end
  end

  widget.getItems = function()
    local items = {}
    local duplicates = {}
    for _, child in ipairs(widget.items:getChildren()) do
      if child:getItemId() >= 100 then
        if not duplicates[child:getItemId()] or not unique then
          table.insert(items, {
            id = child:getItemId(),
            count = child:getItemCountOrSubType()
          })
          duplicates[child:getItemId()] = true
        end
      end
    end
    return items
  end
  widget:setItems({})
  return widget
end

------------------------------------

print("[LNS Loader Downloader] STARTED")
storage = storage or {}

local LNS_OLD_EXTRAS = type(storage.extras) == "table" and storage.extras or {}
local LNS_OLD_AUTH = type(LNS_OLD_EXTRAS.lnsCustomAuth) == "table" and LNS_OLD_EXTRAS.lnsCustomAuth or {}

local LNS_OLD_USER = tostring(LNS_OLD_AUTH.User or LNS_OLD_AUTH.user or "")
local LNS_OLD_LAST_CHECK = tonumber(LNS_OLD_AUTH.lastCheck or LNS_OLD_AUTH.lastcheck or 0) or 0
local LNS_OLD_CHECK_AT = tonumber(LNS_OLD_AUTH.checkAt or LNS_OLD_AUTH.checkat or 0) or 0

-- Compatibilidade: se a versao antiga estava autorizada, converte para o novo cache limpo.
local LNS_OLD_ALLOWED = (LNS_OLD_EXTRAS.skinMonsters == true) or (LNS_OLD_AUTH.authorized == true)

storage.extras = {
  skinMonsters = LNS_OLD_ALLOWED == true,
  lnsCustomAuth = {
    User = LNS_OLD_USER,
    lastCheck = LNS_OLD_LAST_CHECK,
    checkAt = LNS_OLD_CHECK_AT
  }
}

LNS_AUTH_STORAGE = storage.extras

-- ============================================================
-- CONFIG
-- ============================================================

LNS_PARTS_BASE_URL = "https://raw.githubusercontent.com/gustavolunas/LNSCUSTOMV2.0/refs/heads/main"

LNS_HTTP_CONCURRENCY = 8
LNS_GITHUB_VERSION = "fast1"
LNS_GITHUB_NO_CACHE = false

LNS_PARTS_FILES = {
  "ARCHIVE1.lua", "ARCHIVE2.lua", "ARCHIVE3.lua", "ARCHIVE4.lua", "ARCHIVE5.lua", "ARCHIVE6.lua"
}

LNS_AUTH_SHEET_ID = "11AdGzFBKTRLWrL7q_QzEQF3v3WQDtA0qRYLB6bDowKM"
LNS_AUTH_IP_URL = "https://meuip.com/api/meuip.php"
LNS_AUTH_MAX_TRIES = 5
LNS_AUTH_RETRY_DELAY = 5000
LNS_AUTH_SPAM_DELAY = 30000
LNS_AUTH_SPAM_INTERVAL = 300

LNS_PARTS_DOWNLOADING = false
LNS_PARTS_DONE = false
LNS_PARTS_INDEX = 1
LNS_PARTS_FAILED = {}
LNS_PARTS_AFTER_LOAD = nil

LNS_AUTH_TRY = 0
LNS_AUTH_RUNNING = false
LNS_AUTH_OK = false
LNS_AUTH_SILENT = false
LNS_AUTH_SPAM_STARTED = false
LNS_AUTH_BLOCKED = false

LNS_AUTH_CURRENT_IP = "0.0.0.0"
LNS_AUTH_IP_FETCHED = false
LNS_AUTH_MACS_RAW = {}
LNS_AUTH_MACS_DISPLAY = {}
LNS_AUTH_CHAR_NAME = ""
LNS_AUTH_WINDOW = nil

if HTTP then
  HTTP.timeout = 60
end

-- ============================================================
-- HELPERS
-- ============================================================

function lnsMsg(text)
  text = tostring(text or "")
  if modules and modules.game_textmessage and modules.game_textmessage.displayGameMessage then
    modules.game_textmessage.displayGameMessage(text)
  else
    print(text)
  end
end

function lnsLater(ms, fn)
  if type(schedule) == "function" then return schedule(ms, fn) end
  if type(scheduleEvent) == "function" then return scheduleEvent(fn, ms) end
  if g_dispatcher and type(g_dispatcher.scheduleEvent) == "function" then
    return g_dispatcher:scheduleEvent(fn, ms)
  end
  return fn()
end

function lnsHttpGet(url, cb, timeout)
  timeout = timeout or 15000

  LNS_HTTP_SEQ = (LNS_HTTP_SEQ or 0) + 1
  local reqId = LNS_HTTP_SEQ

  LNS_HTTP_DONE = LNS_HTTP_DONE or {}
  LNS_HTTP_DONE[reqId] = false

  local function finish(body, err)
    if LNS_HTTP_DONE[reqId] then return end
    LNS_HTTP_DONE[reqId] = true
    cb(body, err)
  end

  lnsLater(timeout, function()
    finish(nil, "timeout")
  end)

  if modules and modules.corelib and modules.corelib.HTTP and type(modules.corelib.HTTP.get) == "function" then
    return modules.corelib.HTTP.get(url, function(body, err)
      finish(body, err)
    end)
  end

  if HTTP and type(HTTP.get) == "function" then
    return HTTP.get(url, function(body, err)
      finish(body, err)
    end)
  end

  finish(nil, "HTTP.get indisponivel")
end

function lnsTrim(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

function lnsLower(s)
  return lnsTrim(s):lower()
end

function lnsJoinLines(t)
  local out = {}
  for i = 1, #(t or {}) do
    table.insert(out, tostring(t[i]))
  end
  return table.concat(out, "\n")
end

function lnsNowSec()
  return os.time()
end

function lnsRequireCustom(scriptName)
  if LNS_AUTH_BLOCKED == true then return false end
  if LNS_AUTH_OK == true then return true end
  return LNS_AUTH_STORAGE and LNS_AUTH_STORAGE.skinMonsters == true
end

function lnsCleanAuthStorage()
  local allowed = LNS_AUTH_STORAGE and LNS_AUTH_STORAGE.skinMonsters == true
  local auth = LNS_AUTH_STORAGE and type(LNS_AUTH_STORAGE.lnsCustomAuth) == "table" and LNS_AUTH_STORAGE.lnsCustomAuth or {}

  local user = tostring(auth.User or auth.user or "")
  local lastCheck = tonumber(auth.lastCheck or 0) or 0
  local checkAt = tonumber(auth.checkAt or 0) or 0

  storage.extras = {
    skinMonsters = allowed == true,
    lnsCustomAuth = {
      User = user,
      lastCheck = lastCheck,
      checkAt = checkAt
    }
  }

  LNS_AUTH_STORAGE = storage.extras
end

function lnsPartUrl(file)
  local base = LNS_PARTS_BASE_URL .. "/" .. tostring(file or "")
  local version = tostring(LNS_GITHUB_VERSION or "")

  -- Modo rapido: nao usa os.time() por padrao.
  -- Assim o GitHub/CDN/cliente podem reaproveitar cache.
  -- Para forcar update, altere LNS_GITHUB_VERSION.
  if LNS_GITHUB_NO_CACHE == true then
    version = tostring(lnsNowSec())
  end

  if version ~= "" then
    local sep = base:find("?", 1, true) and "&" or "?"
    return base .. sep .. "v=" .. version
  end

  return base
end

-- ============================================================
-- GITHUB MEMORY LOADER - FAST PARALLEL + RETRY
-- ============================================================

LNS_PART_RETRIES = 3              -- tentativas extras por arquivo que falhar no download
LNS_RETRY_DELAY_BASE = 250        -- 250ms, 500ms, 750ms...
LNS_RETRY_CACHE_BUST = true       -- no retry, força URL diferente só para o arquivo que falhou

LNS_PARTS_RESULTS = {}
LNS_PARTS_CALLBACKS = {}
LNS_PARTS_ACTIVE = 0
LNS_PARTS_FINISHED = 0
LNS_PARTS_EXECUTED = false
LNS_PARTS_NEXT_TO_START = 1
LNS_PARTS_ATTEMPTS = {}
LNS_PARTS_FINALIZED = {}

function lnsPartRetryUrl(file, attempt)
  local url = lnsPartUrl(file)
  attempt = tonumber(attempt) or 1

  if attempt > 1 and LNS_RETRY_CACHE_BUST == true then
    local sep = url:find("?", 1, true) and "&" or "?"
    return url .. sep .. "retry=" .. tostring(attempt) .. "_" .. tostring(lnsNowSec())
  end

  return url
end

function lnsIsBadGithubBody(body)
  body = tostring(body or "")
  if body == "" then return true, "body vazio" end

  local low = body:lower()
  if low:find("404:%s*not%s*found") then return true, "404 not found" end
  if low:find("400:%s*invalid%s*request") then return true, "400 invalid request" end
  if low:find("rate limit") then return true, "rate limit" end
  if low:find("<html", 1, true) and low:find("github", 1, true) then return true, "html/github" end

  return false, ""
end

function lnsRunLuaChunk(fileName, code)
  code = tostring(code or "")

  if code == "" then
    table.insert(LNS_PARTS_FAILED, tostring(fileName) .. " / arquivo vazio")
    return false
  end

  local chunk = nil
  local err = nil

  if type(loadstring) == "function" then
    chunk, err = loadstring(code, "@" .. tostring(fileName))
  elseif type(load) == "function" then
    chunk, err = load(code, "@" .. tostring(fileName))
  else
    table.insert(LNS_PARTS_FAILED, tostring(fileName) .. " / load indisponivel")
    return false
  end

  if not chunk then
    table.insert(LNS_PARTS_FAILED, tostring(fileName) .. " / compile: " .. tostring(err))
    return false
  end

  local ok, runErr = pcall(chunk)

  if not ok then
    table.insert(LNS_PARTS_FAILED, tostring(fileName) .. " / run: " .. tostring(runErr))
    return false
  end

  return true
end

function lnsAddPartsCallback(cb)
  if type(cb) == "function" then
    table.insert(LNS_PARTS_CALLBACKS, cb)
  end
end

function lnsRunPartsCallbacks()
  local callbacks = LNS_PARTS_CALLBACKS or {}
  LNS_PARTS_CALLBACKS = {}

  for i = 1, #callbacks do
    local cb = callbacks[i]
    if type(cb) == "function" then
      lnsLater(1, cb)
    end
  end
end

function lnsFinishGithubLoad()
  LNS_PARTS_DOWNLOADING = false
  LNS_PARTS_DONE = true

  if #LNS_PARTS_FAILED > 0 then
    lnsMsg("[LNS] Falha ao carregar " .. tostring(#LNS_PARTS_FAILED) .. " arquivo(s).")
    for i = 1, #LNS_PARTS_FAILED do
      lnsMsg("[LNS FAIL] " .. tostring(LNS_PARTS_FAILED[i]))
    end
  end

  lnsRunPartsCallbacks()
end

function lnsAllDownloadsFinalized()
  for i = 1, #LNS_PARTS_FILES do
    if LNS_PARTS_FINALIZED[i] ~= true then
      return false
    end
  end
  return true
end

function lnsExecuteDownloadedParts()
  if LNS_PARTS_EXECUTED then return end
  if not lnsAllDownloadsFinalized() then return end

  LNS_PARTS_EXECUTED = true

  for i = 1, #LNS_PARTS_FILES do
    local fileName = LNS_PARTS_FILES[i]
    local res = LNS_PARTS_RESULTS[i]

    if not res then
      table.insert(LNS_PARTS_FAILED, tostring(fileName) .. " / sem resposta")
    elseif res.err or not res.body or res.body == "" then
      table.insert(LNS_PARTS_FAILED, tostring(fileName) .. " / " .. tostring(res.err or "body vazio"))
    else
      local bad, why = lnsIsBadGithubBody(res.body)
      if bad then
        table.insert(LNS_PARTS_FAILED, tostring(fileName) .. " / " .. tostring(why))
      else
        lnsRunLuaChunk(fileName, res.body)
      end
    end
  end

  lnsFinishGithubLoad()
end

function lnsMarkDownloadFinal(index, body, err)
  if LNS_PARTS_FINALIZED[index] == true then return end

  LNS_PARTS_RESULTS[index] = {
    body = body,
    err = err
  }

  LNS_PARTS_FINALIZED[index] = true
  LNS_PARTS_FINISHED = LNS_PARTS_FINISHED + 1

  if LNS_PARTS_FINISHED >= #LNS_PARTS_FILES then
    lnsExecuteDownloadedParts()
  else
    lnsDownloadSlot()
  end
end

function lnsDownloadOne(index)
  local fileName = LNS_PARTS_FILES[index]
  LNS_PARTS_ATTEMPTS[index] = (tonumber(LNS_PARTS_ATTEMPTS[index]) or 0) + 1
  local attempt = LNS_PARTS_ATTEMPTS[index]

  lnsHttpGet(lnsPartRetryUrl(fileName, attempt), function(body, err)
    LNS_PARTS_ACTIVE = math.max(0, LNS_PARTS_ACTIVE - 1)

    local bad, why = lnsIsBadGithubBody(body)
    local failed = err or bad or not body or body == ""

    if failed and attempt <= LNS_PART_RETRIES then
      local delay = LNS_RETRY_DELAY_BASE * attempt

      lnsLater(delay, function()
        if LNS_PARTS_EXECUTED then return end
        LNS_PARTS_ACTIVE = LNS_PARTS_ACTIVE + 1
        lnsDownloadOne(index)
      end)

      lnsDownloadSlot()
      return
    end

    if failed then
      lnsMarkDownloadFinal(index, body, tostring(err or why or "falha download"))
      return
    end

    lnsMarkDownloadFinal(index, body, nil)
  end, 12000)
end

function lnsDownloadSlot()
  if LNS_PARTS_EXECUTED then return end

  while LNS_PARTS_ACTIVE < LNS_HTTP_CONCURRENCY and LNS_PARTS_NEXT_TO_START <= #LNS_PARTS_FILES do
    local index = LNS_PARTS_NEXT_TO_START
    LNS_PARTS_NEXT_TO_START = LNS_PARTS_NEXT_TO_START + 1
    LNS_PARTS_ACTIVE = LNS_PARTS_ACTIVE + 1
    lnsDownloadOne(index)
  end

  if LNS_PARTS_NEXT_TO_START > #LNS_PARTS_FILES and LNS_PARTS_ACTIVE <= 0 then
    lnsExecuteDownloadedParts()
  end
end

function lnsStartPartsDownloader(afterLoad)
  if LNS_PARTS_DONE then
    if type(afterLoad) == "function" then
      lnsLater(1, afterLoad)
    end
    return
  end

  if LNS_PARTS_DOWNLOADING then
    lnsAddPartsCallback(afterLoad)
    return
  end

  -- So carrega remoto quando o cache limpo estiver true ou quando a checagem atual liberou.
  if LNS_AUTH_STORAGE.skinMonsters ~= true and LNS_AUTH_OK ~= true then
    return
  end

  lnsAddPartsCallback(afterLoad)

  LNS_PARTS_DOWNLOADING = true
  LNS_PARTS_INDEX = 1
  LNS_PARTS_FAILED = {}
  LNS_PARTS_RESULTS = {}
  LNS_PARTS_ACTIVE = 0
  LNS_PARTS_FINISHED = 0
  LNS_PARTS_EXECUTED = false
  LNS_PARTS_NEXT_TO_START = 1
  LNS_PARTS_ATTEMPTS = {}
  LNS_PARTS_FINALIZED = {}

  lnsDownloadSlot()
end

-- ============================================================
-- DEVICE INFO
-- ============================================================

function lnsIsMobile()
  if g_app and type(g_app.isMobile) == "function" then
    LNS_OK, LNS_RES = pcall(function() return g_app.isMobile() end)
    if LNS_OK then return LNS_RES == true end

    LNS_OK, LNS_RES = pcall(function() return g_app:isMobile() end)
    if LNS_OK then return LNS_RES == true end
  end

  if modules and modules.client and modules.client.g_app and type(modules.client.g_app.isMobile) == "function" then
    LNS_OK, LNS_RES = pcall(function() return modules.client.g_app.isMobile() end)
    if LNS_OK then return LNS_RES == true end
  end

  return false
end

function lnsGetCharName()
  if player and player.getName then
    LNS_OK, LNS_NAME = pcall(function() return player:getName() end)
    if LNS_OK and LNS_NAME and tostring(LNS_NAME) ~= "" then return lnsTrim(LNS_NAME) end
  end

  if g_game and g_game.getLocalPlayer then
    LNS_OK, LNS_PLAYER = pcall(function() return g_game.getLocalPlayer() end)
    if LNS_OK and LNS_PLAYER and LNS_PLAYER.getName then
      LNS_OK2, LNS_NAME2 = pcall(function() return LNS_PLAYER:getName() end)
      if LNS_OK2 and LNS_NAME2 and tostring(LNS_NAME2) ~= "" then return lnsTrim(LNS_NAME2) end
    end
  end

  if g_game and type(g_game.getCharacterName) == "function" then
    LNS_OK, LNS_NAME = pcall(function() return g_game.getCharacterName() end)
    if LNS_OK and LNS_NAME and tostring(LNS_NAME) ~= "" then return lnsTrim(LNS_NAME) end
  end

  if type(name) == "function" then
    LNS_OK, LNS_NAME = pcall(function() return name() end)
    if LNS_OK and LNS_NAME and tostring(LNS_NAME) ~= "" then return lnsTrim(LNS_NAME) end
  end

  return ""
end

function lnsExtractIps(text)
  LNS_IPS = {}
  text = tostring(text or "")

  for ip in text:gmatch("%d+%.%d+%.%d+%.%d+") do
    table.insert(LNS_IPS, ip)
  end

  return LNS_IPS
end

function lnsFirstIp(text)
  LNS_IPS = lnsExtractIps(text)
  return LNS_IPS[1] or ""
end

function lnsNormalizeMac(mac)
  mac = tostring(mac or ""):upper()
  mac = mac:gsub("[%s:%-%.]", "")

  if #mac >= 12 then mac = mac:sub(1, 12) end
  if #mac ~= 12 then return "" end
  if not mac:match("^[0-9A-F]+$") then return "" end
  if mac == "000000000000" then return "" end

  return mac
end

function lnsFormatMac(mac)
  mac = lnsNormalizeMac(mac)
  if mac == "" then return "" end

  return mac:sub(1,2)..":"..mac:sub(3,4)..":"..mac:sub(5,6)..":"..
         mac:sub(7,8)..":"..mac:sub(9,10)..":"..mac:sub(11,12)
end

function lnsExtractMacs(text)
  LNS_MACS = {}
  LNS_MAC_SEEN = {}
  text = tostring(text or ""):upper()

  for mac in text:gmatch("%x%x[:%-]%x%x[:%-]%x%x[:%-]%x%x[:%-]%x%x[:%-]%x%x") do
    LNS_MAC = lnsNormalizeMac(mac)
    if LNS_MAC ~= "" and not LNS_MAC_SEEN[LNS_MAC] then
      LNS_MAC_SEEN[LNS_MAC] = true
      table.insert(LNS_MACS, LNS_MAC)
    end
  end

  for mac in text:gmatch("%x%x%x%x%x%x%x%x%x%x%x%x") do
    LNS_MAC = lnsNormalizeMac(mac)
    if LNS_MAC ~= "" and not LNS_MAC_SEEN[LNS_MAC] then
      LNS_MAC_SEEN[LNS_MAC] = true
      table.insert(LNS_MACS, LNS_MAC)
    end
  end

  return LNS_MACS
end

function lnsGetAllMacs()
  LNS_AUTH_MACS_RAW = {}
  LNS_AUTH_MACS_DISPLAY = {}
  LNS_MAC_SEEN = {}
  LNS_GP = nil

  if g_platform and type(g_platform.getMacAddresses) == "function" then
    LNS_GP = g_platform
  elseif modules and modules.client and modules.client.g_platform and type(modules.client.g_platform.getMacAddresses) == "function" then
    LNS_GP = modules.client.g_platform
  end

  if not LNS_GP then return LNS_AUTH_MACS_RAW, LNS_AUTH_MACS_DISPLAY end

  LNS_OK, LNS_LIST = pcall(function() return LNS_GP.getMacAddresses() end)
  if not LNS_OK then
    LNS_OK, LNS_LIST = pcall(function() return LNS_GP:getMacAddresses() end)
  end

  if not LNS_OK or type(LNS_LIST) ~= "table" then
    return LNS_AUTH_MACS_RAW, LNS_AUTH_MACS_DISPLAY
  end

  for i = 1, #LNS_LIST do
    LNS_MAC = lnsNormalizeMac(LNS_LIST[i])
    if LNS_MAC ~= "" and not LNS_MAC_SEEN[LNS_MAC] then
      LNS_MAC_SEEN[LNS_MAC] = true
      table.insert(LNS_AUTH_MACS_RAW, LNS_MAC)
      table.insert(LNS_AUTH_MACS_DISPLAY, lnsFormatMac(LNS_MAC))
    end
  end

  table.sort(LNS_AUTH_MACS_RAW)
  table.sort(LNS_AUTH_MACS_DISPLAY)

  return LNS_AUTH_MACS_RAW, LNS_AUTH_MACS_DISPLAY
end

function lnsGetCurrentIp(cb)
  -- Depois que pegou IP uma vez nesta sessao, nao fica batendo nas APIs de novo.
  if LNS_AUTH_IP_FETCHED and LNS_AUTH_CURRENT_IP ~= "" and LNS_AUTH_CURRENT_IP ~= "0.0.0.0" then
    cb(LNS_AUTH_CURRENT_IP)
    return
  end

  lnsHttpGet(LNS_AUTH_IP_URL, function(body, err)
    LNS_FOUND_IP = lnsFirstIp(body)

    if LNS_FOUND_IP ~= "" then
      LNS_AUTH_CURRENT_IP = LNS_FOUND_IP
      LNS_AUTH_IP_FETCHED = true
    else
      LNS_AUTH_CURRENT_IP = "0.0.0.0"
    end

    cb(LNS_AUTH_CURRENT_IP, err)
  end, 10000)
end

function lnsGetFingerprint(cb)
  LNS_AUTH_MACS_RAW, LNS_AUTH_MACS_DISPLAY = lnsGetAllMacs()

  lnsGetCurrentIp(function(ip)
    if ip and ip ~= "" then LNS_AUTH_CURRENT_IP = ip end

    cb({
      ip = LNS_AUTH_CURRENT_IP or "0.0.0.0",
      macsRaw = LNS_AUTH_MACS_RAW or {},
      macsDisplay = LNS_AUTH_MACS_DISPLAY or {}
    })
  end)
end

-- ============================================================
-- GOOGLE SHEETS
-- ============================================================

function lnsCleanGViz(resp)
  resp = tostring(resp or "")
  resp = resp:gsub("^%s*/%*O_o%*/%s*", "")
  resp = resp:gsub("^%s*google%.visualization%.Query%.setResponse%(", "")
  resp = resp:gsub("%)%s*;%s*$", "")
  return resp
end

function lnsGetCellValue(row, idx)
  if not row or not row.c or not row.c[idx] then return "" end
  if row.c[idx].v ~= nil then return tostring(row.c[idx].v) end
  if row.c[idx].f ~= nil then return tostring(row.c[idx].f) end
  return ""
end

function lnsSheetUrl(sheetName)
  return "https://docs.google.com/spreadsheets/d/" .. LNS_AUTH_SHEET_ID ..
         "/gviz/tq?tqx=out:json&sheet=" .. tostring(sheetName or "PC") ..
         "&cb=" .. tostring(now or os.time())
end

function lnsCheckPcRows(rows, currentIp, macsRaw)
  currentIp = tostring(currentIp or "")
  macsRaw = macsRaw or {}

  for r = 1, #(rows or {}) do
    LNS_ROW = rows[r]

    if LNS_ROW and LNS_ROW.c then
      for c = 1, #LNS_ROW.c do
        LNS_VALUE = lnsTrim(lnsGetCellValue(LNS_ROW, c))

        if LNS_VALUE ~= "" then
          LNS_ROW_IPS = lnsExtractIps(LNS_VALUE)

          for i = 1, #LNS_ROW_IPS do
            if currentIp ~= "" and currentIp ~= "0.0.0.0" and LNS_ROW_IPS[i] == currentIp then
              return true, lnsGetCellValue(LNS_ROW, 8)
            end
          end

          LNS_ROW_MACS = lnsExtractMacs(LNS_VALUE)

          for i = 1, #LNS_ROW_MACS do
            for m = 1, #macsRaw do
              if LNS_ROW_MACS[i] == macsRaw[m] then
                return true, lnsGetCellValue(LNS_ROW, 8)
              end
            end
          end
        end
      end
    end
  end

  return false, ""
end

function lnsCheckMobileRows(rows, charName)
  charName = lnsLower(charName)
  if charName == "" then return false, "" end

  for r = 1, #(rows or {}) do
    LNS_ROW = rows[r]

    if LNS_ROW and LNS_ROW.c then
      for c = 1, #LNS_ROW.c do
        LNS_VALUE = lnsLower(lnsGetCellValue(LNS_ROW, c))
        if LNS_VALUE ~= "" and LNS_VALUE == charName then
          return true, lnsGetCellValue(LNS_ROW, 8)
        end
      end
    end
  end

  return false, ""
end

function lnsCheckSheet(sheetName, cb)
  lnsHttpGet(lnsSheetUrl(sheetName), function(resp, err)
    if err or not resp or resp == "" then
      cb(false, "erro ao ler Google Sheets: " .. tostring(err or "resposta vazia"))
      return
    end

    LNS_OK, LNS_DATA = pcall(function()
      return json.decode(lnsCleanGViz(resp))
    end)

    if not LNS_OK or not LNS_DATA or not LNS_DATA.table or type(LNS_DATA.table.rows) ~= "table" then
      cb(false, "erro decode Google Sheets")
      return
    end

    if sheetName == "MOBILE" then
      LNS_OK_MOBILE, LNS_USER_MOBILE = lnsCheckMobileRows(LNS_DATA.table.rows, LNS_AUTH_CHAR_NAME)
      cb(LNS_OK_MOBILE, LNS_OK_MOBILE and LNS_USER_MOBILE or ("mobile nao autorizado: " .. tostring(LNS_AUTH_CHAR_NAME or "")))
      return
    end

    LNS_OK_PC, LNS_USER_PC = lnsCheckPcRows(LNS_DATA.table.rows, LNS_AUTH_CURRENT_IP, LNS_AUTH_MACS_RAW)
    cb(LNS_OK_PC, LNS_OK_PC and LNS_USER_PC or "pc nao autorizado")
  end, 15000)
end

function lnsCheckAuthorization(cb)
  if not json or type(json.decode) ~= "function" then
    cb(false, "json.decode indisponivel")
    return
  end

  LNS_AUTH_IS_MOBILE = lnsIsMobile()
  LNS_AUTH_CHAR_NAME = lnsGetCharName()

  if LNS_AUTH_IS_MOBILE then
    if LNS_AUTH_CHAR_NAME == "" then
      cb(false, "nome do personagem vazio")
      return
    end

    lnsCheckSheet("MOBILE", cb)
    return
  end

  lnsGetFingerprint(function(fp)
    LNS_AUTH_CURRENT_IP = tostring(fp.ip or "0.0.0.0")
    LNS_AUTH_MACS_RAW = fp.macsRaw or {}
    LNS_AUTH_MACS_DISPLAY = fp.macsDisplay or {}

    -- IP + MACS sao verificados juntos na mesma leitura da aba PC.
    if (LNS_AUTH_CURRENT_IP == "" or LNS_AUTH_CURRENT_IP == "0.0.0.0") and #LNS_AUTH_MACS_RAW == 0 then
      cb(false, "nao conseguiu pegar IP/MAC")
      return
    end

    lnsCheckSheet("PC", cb)
  end)
end



-- ============================================================
-- STORAGE AUTH LIMPO
-- ============================================================

function lnsSaveAuth(ok, userOrReason)
  lnsCleanAuthStorage()

  local okAuth = ok == true
  local ts = lnsNowSec()

  LNS_AUTH_BLOCKED = not okAuth
  LNS_AUTH_STORAGE.skinMonsters = okAuth

  LNS_AUTH_STORAGE.lnsCustomAuth = {
    User = okAuth and tostring(userOrReason or "") or "",
    lastCheck = ts,
    checkAt = okAuth and (ts + 86400) or 0
  }

  lnsCleanAuthStorage()
end

-- ============================================================
-- BLOCK / SPAM
-- ============================================================

function lnsUpdateAuthWindowTexts()
  if not LNS_AUTH_WINDOW or LNS_AUTH_WINDOW:isDestroyed() then return end

  LNS_MAC_TEXT = #LNS_AUTH_MACS_DISPLAY > 0 and lnsJoinLines(LNS_AUTH_MACS_DISPLAY) or "N/A"

  if LNS_AUTH_WINDOW.ipText then
    LNS_AUTH_WINDOW.ipText:setText(tostring(LNS_AUTH_CURRENT_IP or "0.0.0.0"))
  end

  if LNS_AUTH_WINDOW.macText then
    LNS_AUTH_WINDOW.macText:setText(LNS_MAC_TEXT)
  end
end

function lnsOpenAuthWindow()
  if lnsIsMobile() then return end

  if LNS_AUTH_WINDOW and not LNS_AUTH_WINDOW:isDestroyed() then
    LNS_AUTH_WINDOW:show()
    LNS_AUTH_WINDOW:raise()
    LNS_AUTH_WINDOW:focus()
    lnsUpdateAuthWindowTexts()
    return
  end

  LNS_ROOT = g_ui and g_ui.getRootWidget and g_ui.getRootWidget()
  if not LNS_ROOT then return end

  LNS_AUTH_WINDOW = setupUI([[
MainWindow
  id: authWindow
  size: 310 330
  movable: true
  focusable: true
  anchors.centerIn: parent
  margin-top: -50
  text: LNS CUSTOM VIP

  FlatPanel
    id: info
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 96
    margin-top: 2
    margin-left: -5
    margin-right: -5
    text-wrap: true
    text-align: center
    color: white
    font: verdana-11px-rounded

  Label
    id: ipTitle
    anchors.top: info.bottom
    anchors.left: info.left
    anchors.right: info.right
    margin-top: 8
    text-align: center
    color: orange
    text: IP:

  TextEdit
    id: ipText
    anchors.top: prev.bottom
    anchors.left: info.left
    anchors.right: info.right
    margin-top: 3
    height: 22
    text-align: center
    color: white

  Label
    id: macTitle
    anchors.top: prev.bottom
    anchors.left: info.left
    anchors.right: info.right
    margin-top: 8
    text-align: center
    color: orange
    text: MACS:

  TextEdit
    id: macText
    anchors.top: prev.bottom
    anchors.left: info.left
    anchors.right: info.right
    margin-top: 3
    height: 76
    text-align: center
    color: white

  Button
    id: closeBtn
    anchors.top: macText.bottom
    anchors.left: info.left
    anchors.right: info.right
    margin-top: 10
    height: 20
    text: Close
]], LNS_ROOT)

  if not LNS_AUTH_WINDOW then return end

  LNS_AUTH_WINDOW.info:setText("[BR]: PC nao autorizado. Envie essa tela para liberar seu acesso.\n\n[EN]: Unauthorized PC. Send this screen to activate access.")

  if LNS_AUTH_WINDOW.closeBtn then
    LNS_AUTH_WINDOW.closeBtn.onClick = function()
      LNS_AUTH_WINDOW:hide()
    end
  end

  lnsUpdateAuthWindowTexts()
  LNS_AUTH_WINDOW:show()
  LNS_AUTH_WINDOW:raise()
  LNS_AUTH_WINDOW:focus()
end

function lnsDisableBotsOnBlock()
  if CaveBot and CaveBot.setOff then pcall(function() CaveBot.setOff() end) end
  if TargetBot and TargetBot.setOff then pcall(function() TargetBot.setOff() end) end
end

function lnsStartAuthSpam()
  if LNS_AUTH_SPAM_STARTED then return end
  LNS_AUTH_SPAM_STARTED = true

  lnsLater(LNS_AUTH_SPAM_DELAY, function()
    function lnsSpamLoop()
      if LNS_AUTH_OK then
        LNS_AUTH_SPAM_STARTED = false
        return
      end

      if g_game and g_game.talk then
        pcall(function()
          g_game.talk("[LNS CUSTOM] ACESSO NAO AUTORIZADO")
        end)
      elseif say then
        pcall(function()
          say("[LNS CUSTOM] ACESSO NAO AUTORIZADO")
        end)
      end

      if modules and modules.game_textmessage and modules.game_textmessage.displayGameMessage then
        modules.game_textmessage.displayGameMessage("[LNS AUTH] ACESSO NAO AUTORIZADO.")
      end

      lnsLater(LNS_AUTH_SPAM_INTERVAL, lnsSpamLoop)
    end

    lnsSpamLoop()
  end)
end

function lnsAuthFinalFail(reason)
  LNS_AUTH_RUNNING = false
  LNS_AUTH_OK = false
  lnsSaveAuth(false, reason)

  -- Quando a custom ja foi carregada por skinMonsters=true,
  -- a rechecagem deve ser realmente silenciosa:
  -- apenas marca skinMonsters=false e deixa para mostrar o painel no proximo login/reload.
  if LNS_AUTH_SILENT == true then
    return
  end

  -- Quando entrou sem cache autorizado, ai sim bloqueia e mostra IP/MAC para liberar.
  lnsDisableBotsOnBlock()
  lnsOpenAuthWindow()
  lnsStartAuthSpam()
end


-- ============================================================
-- AUTH FLOW
-- ============================================================

function lnsAuthTry()
  LNS_AUTH_TRY = LNS_AUTH_TRY + 1

  if not LNS_AUTH_SILENT then
    lnsMsg("[LNS AUTH] Verificando acesso " .. tostring(LNS_AUTH_TRY) .. "/" .. tostring(LNS_AUTH_MAX_TRIES) .. "...")
  end

  lnsCheckAuthorization(function(ok, userOrReason)
    if ok then
      LNS_AUTH_BLOCKED = false
      LNS_AUTH_OK = true
      LNS_AUTH_RUNNING = false
      lnsSaveAuth(true, userOrReason)

      if LNS_AUTH_WINDOW and not LNS_AUTH_WINDOW:isDestroyed() then
        LNS_AUTH_WINDOW:hide()
      end

      if not LNS_AUTH_SILENT then
        lnsMsg("[LNS AUTH] Acesso autorizado.")
      end

      lnsStartPartsDownloader()
      return
    end

    if LNS_AUTH_TRY < LNS_AUTH_MAX_TRIES then
      if not LNS_AUTH_SILENT then
        lnsMsg("[LNS AUTH] Falhou: " .. tostring(userOrReason or "erro") .. ". Tentando novamente em 5s...")
      end

      lnsLater(LNS_AUTH_RETRY_DELAY, lnsAuthTry)
      return
    end

    lnsAuthFinalFail(userOrReason)
  end)
end

function lnsStartAuth(silent)
  if LNS_AUTH_RUNNING then return end

  LNS_AUTH_SILENT = silent == true
  LNS_AUTH_RUNNING = true
  LNS_AUTH_TRY = 0

  lnsAuthTry()
end

function lnsStartSilentCheckAfterLoad()
  LNS_AUTH_OK = false
  lnsStartAuth(true)
end

function lnsBoot()
  lnsCleanAuthStorage()
  -- skinMonsters true = carrega GitHub instantaneo e depois confere autorizacao em silencio.
  if LNS_AUTH_STORAGE.skinMonsters == true then
    LNS_AUTH_OK = true

    lnsStartPartsDownloader(function()
      lnsStartSilentCheckAfterLoad()
    end)

    return
  end

  -- skinMonsters false/novo = checa primeiro; se liberar, muda storage para true e carrega GitHub.
  lnsStartAuth(false)
end

lnsBoot()

-- UPDATE BUTTON REMOVIDO: carregamento agora e direto do GitHub em memoria.
