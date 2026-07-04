warning = function() 
    return  
end
warn = function() 
    return  
end
error = function() 
    return  
end

setDefaultTab("Main")
local function showUpdateMsg()
    modules.game_textmessage.displayGameMessage("ATUALIZACAO DISPONIVEL, LEIA A MENSAGEM NO WHATSAPP ANTES DE ATUALIZAR!!!")
    print("ATUALIZACAO DISPONIVEL, LEIA A MENSAGEM NO WHATSAPP ANTES DE ATUALIZAR!!!")
end

local function spamUpdate()
  for i = 0, 7 do
    schedule(i * 1000, function()
      showUpdateMsg()
    end)
  end
end

spamUpdate()
-- ============================================================
local GITHUB_OWNER = "gustavolunas"
local GITHUB_REPO = "LNSCUSTOMV2.0"
local GITHUB_BRANCH = "main"

local TREE_URL = "https://api.github.com/repos/" .. GITHUB_OWNER .. "/" .. GITHUB_REPO .. "/git/trees/" .. GITHUB_BRANCH .. "?recursive=1"
local RAW_URL = "https://raw.githubusercontent.com/" .. GITHUB_OWNER .. "/" .. GITHUB_REPO .. "/refs/heads/" .. GITHUB_BRANCH .. "/"

local BASE_DIR = nil

local autoHideEvent = nil
local downloadFinished = false
local downloadingNow = false

local function msg(t)
  if modules and modules.game_textmessage and modules.game_textmessage.displayGameMessage then
    modules.game_textmessage.displayGameMessage(tostring(t or ""))
  else
    print(tostring(t or ""))
  end
end

local function later(ms, fn)
  if type(schedule) == "function" then return schedule(ms, fn) end
  if type(scheduleEvent) == "function" then return scheduleEvent(fn, ms) end
  if g_dispatcher and g_dispatcher.scheduleEvent then return g_dispatcher:scheduleEvent(fn, ms) end
  return fn()
end

local function httpGet(url, cb, timeout)
  timeout = timeout or 12000
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

local function fileExists(path)
  if not g_resources or not g_resources.fileExists then return false end
  local ok, r = pcall(function() return g_resources.fileExists(path) end)
  return ok and r == true
end

local function dirExists(path)
  if not g_resources or not g_resources.directoryExists then return false end
  local ok, r = pcall(function() return g_resources.directoryExists(path) end)
  return ok and r == true
end

local function ensureDir(path)
  if dirExists(path) then return true end

  if g_resources and g_resources.makeDir then
    pcall(function()
      g_resources.makeDir(path)
    end)
  end

  if dirExists(path) then return true end

  if g_resources and g_resources.writeFileContents then
    pcall(function()
      g_resources.writeFileContents(path .. "/.keep", "ok")
    end)
  end

  return dirExists(path)
end

local function ensureParentDirs(fullPath)
  local parts = {}

  for p in tostring(fullPath):gmatch("[^/]+") do
    parts[#parts + 1] = p
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

local function getCurrentConfigName()
  local panel = modules and modules.game_bot and modules.game_bot.contentsPanel
  local config = panel and panel.config
  local option = config and config:getCurrentOption()
  local name = option and option.text

  if name and name ~= "" then
    return tostring(name)
  end

  return "default"
end

local function resolveInstallFolder()
  local configName = getCurrentConfigName()
  BASE_DIR = "/bot/" .. configName
  return BASE_DIR
end

local function encodePath(path)
  return tostring(path or ""):gsub("([^%w%-%._~/])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
end

local function isWantedFile(path, fileType)
  if fileType ~= "blob" then return false end

  local p = tostring(path or "")
  local lower = p:lower()

  if lower:sub(1, 5) == "vbot/" then
    return true
  end

  if lower:sub(1, 8) == "cavebot/" then
    return true
  end

  if lower:sub(1, 10) == "targetbot/" then
    return true
  end

  if lower == "_loader.lua" then
    return true
  end

  if lower == "lnsloader.lua" then
    return true
  end

  if lower == "loot_items.lua" then
    return true
  end

  return false
end

local function isBadGithubBody(body)
  body = tostring(body or "")
  if body == "" then return true, "body vazio" end

  local low = body:lower()

  if low:find("404:%s*not%s*found") then return true, "404 not found" end
  if low:find("400:%s*invalid%s*request") then return true, "400 invalid request" end
  if low:find("rate limit") then return true, "rate limit" end
  if low:find("<html", 1, true) and low:find("github", 1, true) then return true, "html/github" end

  return false, ""
end

-- ============================================================
-- BOTAO UPDATE ARCHIVES + PAINEL DE PROGRESSO
-- O download so inicia quando clicar no botao.
-- ============================================================

local updateButtonPanel = setupUI([[
Panel
  id: updateButtonPanel
  height: 25
  margin-top: 2

  Button
    id: updateArchives
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: 22
    text: Update Archives
    color: white
    font: verdana-11px-rounded
    image-source: /images/ui/button_rounded
    image-color: #363636
]], parent)

local loaderInterface = setupUI([[
MainWindow
  id: mainPanel
  size: 300 100
  border: 1 black
  anchors.centerIn: parent
  margin-top: -60
  margin-left: -10

  Panel
    id: topPanel
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 15
    margin-top: -7
    text-align: center
    !text: tr('Baixando Atualizacoes, aguarde...')
    color: orange

  FlatPanel
    id: panelSpeed
    anchors.top: topPanel.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    margin-bottom: 5
    margin-top: 5
    margin-right: 2
    margin-left: 2
    height: 55

  ProgressBar
    id: bar
    anchors.top: panelSpeed.top
    anchors.left: panelSpeed.left
    anchors.right: panelSpeed.right
    margin-top: 9
    margin-left: 5
    margin-right: 5
    height: 20
    text-align: center
    font: verdana-9px

  Label
    id: textLabel2
    anchors.top: bar.bottom
    anchors.left: panelSpeed.left
    anchors.right: panelSpeed.right
    margin-top: 12
    margin-left: 6
    margin-right: 6
    height: 22
    text-align: center
    text-wrap: true
    color: #e6e6e6
    font: verdana-11px-rounded

  Button
    id: fechar
    anchors.top: panelSpeed.bottom
    anchors.left: panelSpeed.left
    anchors.right: panelSpeed.right
    margin-top: 5
    height: 20
    text: FECHAR
    color: white
    font: verdana-9px
]], g_ui.getRootWidget())

loaderInterface:hide()
loaderInterface.fechar:hide()

loaderInterface.fechar.onClick = function()
  loaderInterface:hide()
end

local function setUpdateButtonEnabled(enabled)
  if updateButtonPanel and updateButtonPanel.updateArchives then
    updateButtonPanel.updateArchives:setEnabled(enabled == true)
  end
end

local function openProgressPanel()
  loaderInterface:show()
  loaderInterface:raise()
  loaderInterface:focus()
  loaderInterface.fechar:hide()
  loaderInterface.bar:setPercent(0)
  loaderInterface.bar:setText("PREPARANDO...")
  loaderInterface.textLabel2:setText("Lendo lista de arquivos...")
end

local function setProgress(doneNow, totalNow)
  local pct = 0

  if totalNow and totalNow > 0 then
    pct = math.floor((doneNow / totalNow) * 100 + 0.5)
  end

  if pct < 0 then pct = 0 end
  if pct > 100 then pct = 100 end

  loaderInterface.bar:setPercent(pct)
  loaderInterface.bar:setText("BAIXANDO... " .. pct .. "%")
  loaderInterface.textLabel2:setText("Baixando: " .. tostring(doneNow) .. "/" .. tostring(totalNow))
end

local function failUi(text)
  downloadingNow = false
  downloadFinished = false

  setUpdateButtonEnabled(true)

  loaderInterface:show()
  loaderInterface:raise()
  loaderInterface:focus()
  loaderInterface.fechar:show()

  loaderInterface.textLabel2:setText(tostring(text or "Falha no download."))
  loaderInterface.bar:setText("FALHOU")
end

local function finishOk(total)
  downloadFinished = true
  downloadingNow = false

  setUpdateButtonEnabled(true)

  loaderInterface.bar:setPercent(100)
  loaderInterface.bar:setText("CONCLUIDO!")
  loaderInterface.textLabel2:setText("Download concluido: " .. tostring(total or 0) .. " arquivo(s).")
  loaderInterface.fechar:hide()

  msg("[LNS] Download concluido com sucesso em: " .. tostring(BASE_DIR))

  later(1200, function()
    if loaderInterface and not loaderInterface:isDestroyed() then
      loaderInterface:hide()
    end

    if type(refresh) == "function" then
      refresh()
    elseif type(reload) == "function" then
      reload()
    end
  end)
end

local function startDownload(files)
  if type(files) ~= "table" or #files == 0 then
    failUi("Nenhum arquivo encontrado no GitHub.")
    return
  end

  if not BASE_DIR then
    resolveInstallFolder()
  end

  ensureDir(BASE_DIR)

  local total = #files
  local done = 0
  local nextIndex = 1
  local active = 0
  local concurrency = 4
  local maxAttempts = 3
  local failed = {}

  setProgress(0, total)

  local function finish()
    if #failed > 0 then
      local txt = "Falhou: " .. tostring(failed[1])

      if #failed > 1 then
        txt = txt .. " +" .. tostring(#failed - 1)
      end

      failUi(txt)

      msg("[LNS] Arquivos que falharam:")

      for i = 1, #failed do
        msg("[LNS FAIL] " .. tostring(failed[i]))
      end
    else
      finishOk(total)
    end
  end

  local function downloadOne(filePath, cb)
    filePath = tostring(filePath or "")

    local fileUrl = RAW_URL .. encodePath(filePath)
    local savePath = BASE_DIR .. "/" .. filePath
    local attempts = 0

    local function try()
      attempts = attempts + 1

      loaderInterface.textLabel2:setText("Baixando: " .. filePath)

      local finalUrl = fileUrl

      if attempts > 1 then
        finalUrl = fileUrl .. "?retry=" .. tostring(attempts) .. "_" .. tostring(os.time())
      end

      httpGet(finalUrl, function(body, err)
        local bad, why = isBadGithubBody(body)

        if err or bad or not body or body == "" then
          if attempts < maxAttempts then
            later(150 * attempts, try)
            return
          end

          cb(false, filePath, "HTTP: " .. tostring(err or why or "body vazio"))
          return
        end

        if not writeFile(savePath, body) then
          if attempts < maxAttempts then
            later(150 * attempts, try)
            return
          end

          cb(false, filePath, "falha ao salvar")
          return
        end

        cb(true, filePath)
      end, 15000)
    end

    try()
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
          failed[#failed + 1] = tostring(path) .. " / " .. tostring(reason or "erro")
        end

        setProgress(done, total)

        if done >= total then
          finish()
        else
          later(1, pump)
        end
      end)
    end
  end

  pump()
end

local function loadGithubTreeAndDownload()
  if not BASE_DIR then
    resolveInstallFolder()
  end

  openProgressPanel()

  httpGet(TREE_URL, function(body, err)
    if err or not body or body == "" then
      failUi("Falha ao ler GitHub: " .. tostring(err or "resposta vazia"))
      return
    end

    if not json or not json.decode then
      failUi("json.decode indisponivel no client.")
      return
    end

    local ok, data = pcall(function()
      return json.decode(body)
    end)

    if not ok or type(data) ~= "table" then
      failUi("JSON invalido retornado pelo GitHub.")
      return
    end

    if type(data.tree) ~= "table" then
      failUi("GitHub nao retornou lista de arquivos.")
      return
    end

    local files = {}

    for _, item in ipairs(data.tree) do
      local path = tostring(item.path or "")
      local fileType = tostring(item.type or "")

      if isWantedFile(path, fileType) then
        files[#files + 1] = path
      end
    end

    table.sort(files)

    if #files == 0 then
      failUi("Nenhum arquivo selecionado encontrado.")
      return
    end

    msg("[LNS] Baixando em: " .. tostring(BASE_DIR))
    startDownload(files)
  end, 20000)
end

updateButtonPanel.updateArchives.onClick = function()
  if downloadingNow then
    msg("[LNS] Download ja esta em andamento.")
    return
  end

  resolveInstallFolder()

  downloadingNow = true
  downloadFinished = false

  setUpdateButtonEnabled(false)

  loadGithubTreeAndDownload()
end
