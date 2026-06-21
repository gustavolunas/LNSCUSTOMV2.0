do
  setDefaultTab("Main")

switchTravel = "travelButton"
storage[switchTravel] = storage[switchTravel] or { enabled = false }

local STKEY = "lnsFastTravel"
storage[STKEY] = storage[STKEY] or {
  selectedNpc = "",
  npcs = {}
}
local st = storage[STKEY]

local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function normalizeText(s)
  s = tostring(s or ""):lower()
  s = s:gsub("%s+", " ")
  return trim(s)
end

local function sameText(a, b)
  return normalizeText(a) == normalizeText(b)
end

local function containsText(hay, needle)
  hay = normalizeText(hay)
  needle = normalizeText(needle)
  if needle == "" then return true end
  return hay:find(needle, 1, true) ~= nil
end

local function ensureNpc(name)
  name = trim(name)
  if name == "" then return nil end
  st.npcs[name] = st.npcs[name] or { cities = {} }
  st.npcs[name].cities = st.npcs[name].cities or {}
  return name
end

local function cityExists(cities, cityName)
  for _, c in ipairs(cities) do
    if sameText(c, cityName) then return true end
  end
  return false
end

local function addCityToNpc(npcName, cityName)
  npcName = trim(npcName)
  cityName = trim(cityName)
  if npcName == "" or cityName == "" then return false end
  if not st.npcs[npcName] then return false end
  local cities = st.npcs[npcName].cities
  if cityExists(cities, cityName) then return false end
  table.insert(cities, cityName)
  return true
end

local defaultNpcs = {
  ["Captain Bluebear"] = { cities = { "Carlin", "Ab'dendriel", "Edron", "Venore", "Port Hope", "Liberty Bay", "Yalahar", "Roshamuul", "Krailos", "Oramond", "Rangiroa", "Svargrond", "Arcadia" } },
  ["Captain Fearless"] = { cities = { "Thais", "Carlin", "Ab'dendriel", "Port Hope", "Edron", "Darashia", "Liberty Bay", "Svargrond", "Yalahar", "Gray Island", "Ankrahmun", "Issavi", "Arcadia", "Rangiroa" } },
  ["Captain Greyhound"] = { cities = { "Thais", "Ab'dendriel", "Venore", "Svargrond", "Yalahar", "Rangiroa", "Arcadia", "Edron" } },
  ["Captain Seahorse"] = { cities = { "Thais", "Carlin", "Ab'dendriel", "Venore", "Port Hope", "Ankrahmun", "Liberty Bay", "Gray Island", "Cormaya" } },
  ["Karith"] = { cities = { "Thais", "Carlin", "Ab'dendriel", "Ankrahmun", "Darashia", "Venore", "Port Hope", "Liberty Bay", "Arcadia" } },
  ["Captain Sinbeard"] = { cities = { "Darashia", "Venore", "Liberty Bay", "Port Hope", "Yalahar", "Edron" } },
  ["Petros"] = { cities = { "Venore", "Port Hope", "Liberty Bay", "Ankrahmun", "Yalahar", "Issavi", "Gray Island" } },
  ["Charles"] = { cities = { "Thais", "Darashia", "Venore", "Liberty Bay", "Ankrahmun", "Yalahar", "Edron" } },
  ["Jack Fate"] = { cities = { "Edron", "Thais", "Venore", "Darashia", "Ankrahmun", "Yalahar", "Port Hope", "Goroma", "Liberty Bay" } },
  ["Captain Seagull"] = { cities = { "Thais", "Carlin", "Venore", "Yalahar", "Edron", "Gray Island" } },
  ["Scrutinon"] = { cities = { "Ab'dendriel", "Darashia", "Edron", "Venore" } },
  ["Captain Harava"] = { cities = { "Darashia", "Krailos", "Oramond", "Venore" } },
  ["Captain Gulliver"] = { cities = { "Thais", "Edron", "Venore", "Port Hope", "Issavi", "Krailos" } },
  ["Captain Pelagia"] = { cities = { "Venore", "Edron", "Oramond", "Issavi", "Darashia" } },
  ["Captain Chelop"] = { cities = { "Thais" } },
  ["Captain Breezelda"] = { cities = { "Carlin", "Thais", "Venore", "Arcadia" } },
  ["Captain Frank"] = { cities = { "Venore" } },
  ["Captain Grenald"] = { cities = { "Carlin", "Thais", "Venore", "Yalahar", "Svargrond" } },
  ["Pemaret"] = { cities = { "Edron" } },
  ["Maris"] = { cities = { "Fenrock", "Mistrock", "Yalahar" } },
  ["Captain Cookie"] = { cities = { "Liberty Bay" } },
  ["Chemar"] = { cities = { "Farmine" } },
  ["Melian"] = { cities = { "Darashia", "Femor Hills", "Svargrond", "Issavi", "Marapur", "Edron" } },
  ["Imbul"] = { cities = { "East" } },
  ["Lorek"] = { cities = { "Banuta", "West" } },
  ["Buddel"] = { cities = { "Helheim", "Svargrond" } },
  ["Gurbasch"] = { cities = { "Gnomprona" } },
  ["Urks The Mute"] = { cities = { "Cormaya" } },
  ["Thorgrin"] = { cities = { "Cormaya" } },
  ["Eustacio"] = { cities = { "Shortcut" } },
  ["Captain Jack Rat"] = { cities = { "Sail", "Safe" } },
  ["Harlow"] = { cities = { "Yalahar", "Vengoth" } },
}

st.npcs = st.npcs or {}

for npcName, data in pairs(defaultNpcs) do
  st.npcs[npcName] = st.npcs[npcName] or { cities = {} }
  st.npcs[npcName].cities = st.npcs[npcName].cities or {}

  for _, city in ipairs(data.cities or {}) do
    if not cityExists(st.npcs[npcName].cities, city) then
      table.insert(st.npcs[npcName].cities, city)
    end
  end
end


travelInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 388 322
  anchors.centerIn: parent
  margin-top: -50
  text: Panel Fast-Travel
  opacity: 1.00

  FlatPanel
    id: fpanel
    anchors.fill: parent
    margin: -3
    margin-bottom: 18

  TextEdit
    id: pesquisarNPC
    anchors.top: prev.top
    anchors.left: prev.left
    width: 170
    margin-left: 5
    margin-top: 5
    placeholder: Search Npc Name

  TextList
    id: panelMain
    anchors.top: prev.bottom
    anchors.right: prev.right
    anchors.left: prev.left
    margin-right: 10
    margin-top: 2
    height: 205
    opacity: 0.95
    vertical-scrollbar: panelMainScroll

  VerticalScrollBar
    id: panelMainScroll
    anchors.top: panelMain.top
    anchors.bottom: panelMain.bottom
    anchors.left: panelMain.right
    width: 13
    margin-top: 1
    margin-bottom: 1
    step: 18
    pixels-scroll: true

  TextEdit
    id: inserirNpcName
    anchors.top: panelMain.bottom
    anchors.left: panelMain.left
    width: 140
    margin-top: 2
    placeholder: Insert Npc Name
  
  Button
    id: buttonAdd
    anchors.top: prev.top
    anchors.right: panelMainScroll.right
    anchors.left: prev.right
    anchors.bottom: prev.bottom
    margin-left: 2
    text: +
    font: sans-bold-16px

  VerticalSeparator
    id: vertsep
    anchors.top: pesquisarNPC.top
    anchors.left: pesquisarNPC.right
    margin-left: 5
    anchors.bottom: buttonAdd.bottom

  TextList
    id: configLista
    anchors.top: pesquisarNPC.top
    anchors.right: fpanel.right
    anchors.left: prev.right
    margin-left: 3
    margin-top: 0
    margin-right: 17
    height: 230
    vertical-scrollbar: ConfigListaScroll

  VerticalScrollBar
    id: ConfigListaScroll
    anchors.top: configLista.top
    anchors.bottom: configLista.bottom
    anchors.left: configLista.right
    width: 13
    margin-top: 1
    margin-bottom: 1
    step: 18
    pixels-scroll: true

  TextEdit
    id: inserirCityName
    anchors.top: configLista.bottom
    anchors.left: configLista.left
    width: 140
    margin-top: 2
    placeholder: Insert City Name
  
  Button
    id: buttonCity
    anchors.top: prev.top
    anchors.right: ConfigListaScroll.right
    anchors.bottom: prev.bottom
    anchors.left: prev.right
    margin-left: 2
    text: +
    font: sans-bold-16px

  Button
    id: closePanel
    anchors.left: fpanel.left
    anchors.right: fpanel.right
    anchors.top: fpanel.bottom
    margin-top: 5
    text: Close

]=], g_ui.getRootWidget())
travelInterface:hide()

travelInterface.closePanel.onClick = function()
  travelInterface:hide()
end

local npcRowTemplate = [[
UIWidget
  id: root
  height: 18
  focusable: true
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #2F2F2F
    opacity: 0.75

  $focus:
    background-color: #404040
    opacity: 0.90

  Label
    id: npcName
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    color: white
    text: ""

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 2
    text: X
    color: #FF4040
]]

local cityRowTemplate = [[
UIWidget
  id: root
  height: 18
  focusable: false
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #2F2F2F
    opacity: 0.75

  Label
    id: cityName
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    color: white
    text: ""

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 2
    text: X
    color: #FF4040
]]

local npcRows = {}
local cityRows = {}

local function sortNpcNames()
  local names = {}
  for npcName, _ in pairs(st.npcs) do
    table.insert(names, npcName)
  end
  table.sort(names, function(a, b)
    return normalizeText(a) < normalizeText(b)
  end)
  return names
end

local function refreshCitiesForSelectedNpc()
  local list = travelInterface.configLista
  if not list then return end

  if list.destroyChildren then list:destroyChildren() end
  cityRows = {}

  local npcName = trim(st.selectedNpc or "")
  if npcName == "" or not st.npcs[npcName] then return end

  local cities = st.npcs[npcName].cities or {}
  table.sort(cities, function(a, b)
    return normalizeText(a) < normalizeText(b)
  end)

  for _, cityName in ipairs(cities) do
    local row = g_ui.loadUIFromString(cityRowTemplate, list)
    row.cityName:setText(cityName)

    row.remove.onClick = function()
      local npc = st.npcs[npcName]
      if not npc or not npc.cities then return end

      for i = #npc.cities, 1, -1 do
        if sameText(npc.cities[i], cityName) then
          table.remove(npc.cities, i)
        end
      end

      refreshCitiesForSelectedNpc()
    end

    table.insert(cityRows, {
      root = row,
      nameLabel = row.cityName,
      removeBtn = row.remove
    })
  end
end

local function selectNpc(npcName)
  npcName = trim(npcName)
  if npcName == "" then
    st.selectedNpc = ""
    refreshCitiesForSelectedNpc()
    return
  end
  if not st.npcs[npcName] then return end

  st.selectedNpc = npcName
  refreshCitiesForSelectedNpc()

  for name, pack in pairs(npcRows) do
    if pack and pack.root and name == npcName then
      pack.root:focus()
    end
  end
end

local function bindNpcRowClick(row, npcName)
  row.onMouseRelease = function(widget, mousePos, button)
    if button ~= MouseLeftButton then return end
    selectNpc(npcName)
  end

  if row.npcName then
    row.npcName.onMouseRelease = function(widget, mousePos, button)
      if button ~= MouseLeftButton then return end
      selectNpc(npcName)
    end
  end

  row.onClick = function()
    selectNpc(npcName)
  end
end

local function matchesNpc(npcName, q)
  if q == "" then return true end
  return containsText(npcName, q)
end

local function filterNpcRows(query)
  local q = normalizeText(query)
  for npcName, pack in pairs(npcRows) do
    if pack and pack.root then
      if matchesNpc(npcName, q) then
        pack.root:show()
      else
        pack.root:hide()
      end
    end
  end
end

local function refreshNpcList()
  local list = travelInterface.panelMain
  if not list then return end

  if list.destroyChildren then list:destroyChildren() end
  npcRows = {}

  local names = sortNpcNames()
  for _, npcName in ipairs(names) do
    local row = g_ui.loadUIFromString(npcRowTemplate, list)
    row.npcName:setText(npcName)

    npcRows[npcName] = {
      root = row,
      nameLabel = row.npcName,
      removeBtn = row.remove
    }

    bindNpcRowClick(row, npcName)

    row.remove.onClick = function()
      if st.npcs[npcName] then st.npcs[npcName] = nil end
      if sameText(st.selectedNpc, npcName) then st.selectedNpc = "" end

      local currentFilter = travelInterface.pesquisarNPC and travelInterface.pesquisarNPC:getText() or ""
      refreshNpcList()
      filterNpcRows(currentFilter or "")
      refreshCitiesForSelectedNpc()
    end
  end

  if st.selectedNpc ~= "" and npcRows[st.selectedNpc] and npcRows[st.selectedNpc].root then
    npcRows[st.selectedNpc].root:focus()
  end
end

travelInterface.pesquisarNPC.onTextChange = function(_, text)
  filterNpcRows(text or "")
end

travelInterface.buttonAdd.onClick = function()
  local name = travelInterface.inserirNpcName:getText() or ""
  name = trim(name)
  if name == "" then return end

  ensureNpc(name)
  travelInterface.inserirNpcName:setText("")
  refreshNpcList()

  local q = travelInterface.pesquisarNPC:getText() or ""
  filterNpcRows(q)

  selectNpc(name)
end

travelInterface.buttonCity.onClick = function()
  local npcName = trim(st.selectedNpc or "")
  if npcName == "" then return end

  local cityName = travelInterface.inserirCityName:getText() or ""
  cityName = trim(cityName)
  if cityName == "" then return end

  local ok = addCityToNpc(npcName, cityName)
  if ok then
    travelInterface.inserirCityName:setText("")
    refreshCitiesForSelectedNpc()
  end
end

refreshNpcList()
refreshCitiesForSelectedNpc()

do
  local q = travelInterface.pesquisarNPC and travelInterface.pesquisarNPC:getText() or ""
  filterNpcRows(q or "")
end

local function nowMs()
  if g_clock and g_clock.millis then return g_clock.millis() end
  return os.time() * 1000
end

local function distSqm(a, b)
  if not a or not b then return 999 end
  if a.z ~= b.z then return 999 end
  return math.max(math.abs(a.x - b.x), math.abs(a.y - b.y))
end

local function sortCities(cities)
  table.sort(cities, function(a, b)
    return normalizeText(a) < normalizeText(b)
  end)
end

local function findNpcOnScreenByName(name)
  name = trim(name)
  if name == "" then return nil end

  local specs = getSpectators() or {}

  for _, cr in ipairs(specs) do
    if cr and cr.getName and cr.getPosition then
      if sameText(cr:getName(), name) then
        return cr
      end
    end
  end

  return nil
end

local function isNpcNear(name, maxDist)
  local me = g_game.getLocalPlayer()
  if not me then return false end
  local myPos = me:getPosition()
  if not myPos then return false end

  local npc = findNpcOnScreenByName(name)
  if not npc then return false end

  local npcPos = npc:getPosition()
  return distSqm(myPos, npcPos) <= (maxDist or 3)
end

local travelUII = setupUI([[
Panel
  id: travelUII
  size: 280 60
  anchors.horizontalCenter: parent.horizontalCenter
  anchors.top: parent.top
  margin-top: 100

  MainWindow
    id: panelTravelUII
    anchors.fill: parent
    text: Fast-Travel

    Label
      id: labelTraveUII
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      margin-top: 4
      margin-left: -5
      text: Select City:
      font: verdana-11px-rounded
      text-auto-resize: true

  ComboBox
    id: TravelOptions
    anchors.top: panelTravelUII.top
    anchors.right: panelTravelUII.right
    margin-right: 15
    margin-top: 25
    width: 155
    height: 22
    font: verdana-11px-rounded
]], g_ui.getRootWidget())
travelUII:hide()

local uiNpcName = ""
local lastCitiesKey = ""
local travelCooldownMs = 1200
local lastTravelAt = 0
local lockTravel = false

local function buildCitiesKey(cities)
  if not cities then return "" end
  local tmp = {}
  for i = 1, #cities do
    tmp[#tmp + 1] = normalizeText(cities[i])
  end
  table.sort(tmp)
  return table.concat(tmp, "|")
end

local function fillCitiesCombo(cities)
  travelUII.TravelOptions:clearOptions()
  travelUII.TravelOptions:addOption("")

  if cities and #cities > 0 then
    for i = 1, #cities do
      travelUII.TravelOptions:addOption(cities[i])
    end
  end

  if travelUII.TravelOptions.setCurrentOption then
    travelUII.TravelOptions:setCurrentOption(1)
  end
  if travelUII.TravelOptions.setText then
    travelUII.TravelOptions:setText("")
  end
end

local function showTravelUIForNpc(npcName)
  npcName = trim(npcName)
  if npcName == "" or not st.npcs[npcName] then return end

  local cities = st.npcs[npcName].cities or {}
  sortCities(cities)

  local key = buildCitiesKey(cities)
  if uiNpcName ~= npcName or lastCitiesKey ~= key then
    fillCitiesCombo(cities)
    uiNpcName = npcName
    lastCitiesKey = key
  end

  if not travelUII:isVisible() then
    travelUII:show()
  end
end

local function hideTravelUI()
  if travelUII:isVisible() then
    travelUII:hide()
  end
  uiNpcName = ""
  lastCitiesKey = ""
end

local function doNpcTravel(npcName, city)
  npcName = trim(npcName)
  city = trim(city)

  if npcName == "" or city == "" then return end
  if lockTravel then return end

  local t = nowMs()
  if (t - lastTravelAt) < travelCooldownMs then return end
  if not isNpcNear(npcName, 3) then return end

  lockTravel = true
  lastTravelAt = t

  local nameCopy = npcName
  local cityCopy = city

  NPC.say("hi")

  schedule(250, function()
    if not isNpcNear(nameCopy, 3) then lockTravel = false return end
    NPC.say(cityCopy)
    if (player:isPartyMember() or player:isPartyLeader() or player:getShield() > 2) then
      sayChannel(1, "Travel to: " .. cityCopy)
    end
  end)

  schedule(500, function()
    if not isNpcNear(nameCopy, 3) then lockTravel = false return end
    NPC.say("yes")
  end)

  schedule(750, function()
    if not isNpcNear(nameCopy, 3) then lockTravel = false return end
    NPC.say("yes")
    lockTravel = false
  end)
end

local function onCitySelected(_, text)
  local city = trim(text or "")
  if city == "" then return end
  if uiNpcName == "" then return end
  doNpcTravel(uiNpcName, city)
end

travelUII.TravelOptions.onOptionChange = onCitySelected
travelUII.TravelOptions.onSelectionChange = onCitySelected
travelUII.TravelOptions.onTextChange = onCitySelected

local function isKnownTravelNpc(creature)
  if not creature or not creature.getName or not creature.getPosition then return false end

  local cname = trim(creature:getName() or "")
  if cname == "" then return false end

  for npcName, _ in pairs(st.npcs or {}) do
    if sameText(cname, npcName) then
      return npcName
    end
  end

  return false
end

macro(200, function()
  local me = g_game.getLocalPlayer()
  if not me then
    hideTravelUI()
    return
  end

  local myPos = me:getPosition()
  if not myPos then
    hideTravelUI()
    return
  end

  local bestName = ""
  local bestDist = 999

  local specs = getSpectators() or {}

  for _, cr in ipairs(specs) do
    local npcName = isKnownTravelNpc(cr)

    if npcName then
      local d = distSqm(myPos, cr:getPosition())

      if d <= 4 and d < bestDist then
        bestDist = d
        bestName = npcName
      end
    end
  end

  if bestName ~= "" then
    showTravelUIForNpc(bestName)
  else
    hideTravelUI()
  end
end)
end

do
  if not loadCharStorage or not saveCharStorage then
  return print("[Imbuements] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function saveImbuementChar()
  saveCharStorage(charStorage)
end

setDefaultTab("Tools")

panelImbuiment = setupUI([[
MainWindow
  size: 450 337
  text: Panel Imbuement

  UIButton
    id: clickHere
    anchors.top: parent.top
    anchors.left: parent.left
    text: Click Here
    margin-top: -2
    margin-left: 100
    color: #FFD700
    text-auto-resize: true
    font: verdana-11px-rounded
    opacity: 1.00
    $hover:
      opacity: 0.80

  Label
    id: labelClick
    anchors.verticalCenter: clickHere.verticalCenter
    anchors.left: clickHere.right
    margin-left: 4
    margin-top: 0
    font: verdana-11px-rounded
    text: to manage auto imbuement

  FlatPanel
    id: flatP
    anchors.fill: parent
    margin: -8
    margin-top: 15
    margin-bottom: 20
    
    Label
      text: Clean Imbuements with:
      anchors.top: parent.top
      anchors.left: parent.left
      color: gray
      margin-top: 3
      margin-left: 5

    HorizontalScrollBar
      id: limparImbuements
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      anchors.right: parent.right
      margin-left: 5
      margin-right: 5
      minimum: 1
      maximum: 1200

      Label
        id: limparText
        anchors.centerIn: parent
        font: verdana-11px-rounded
        color: #d7c08a
        text-auto-resize: true
        text: "1 min"
        phantom: true

    Label
      text: Imbuement Mode:
      anchors.top: prev.bottom
      anchors.left: parent.left
      color: gray
      margin-top: 7
      margin-left: 5

    BotSwitch
      id: imbuingShrine
      anchors.left: limparImbuements.left
      anchors.verticalCenter: prev.verticalCenter
      text: Shrine
      width: 140
      font: verdana-11px-rounded
      $on:
        image-color: green
        color: green
      $!on:
        image-color: gray
        color: white

    BotSwitch
      id: portableShrine
      anchors.left: prev.right
      anchors.verticalCenter: prev.verticalCenter
      text: Portable
      width: 140
      margin-top: 0
      margin-left: 1
      font: verdana-11px-rounded
      $on:
        image-color: green
        color: green
      $!on:
        image-color: gray
        color: white

    TextList
      id: imbueList
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin: 5
      margin-right: 15
      vertical-scrollbar: imbueListScrollBar

    VerticalScrollBar
      id: imbueListScrollBar
      anchors.top: imbueList.top
      anchors.bottom: imbueList.bottom
      anchors.left: imbueList.right
      step: 10
      pixels-scroll: true
      border: 1 #1f1f1f

  Button
    id: closePanel
    anchors.left: flatP.left
    anchors.right: flatP.right
    anchors.top: flatP.bottom
    margin-left: -1
    margin-top: 5
    text: Fechar
    font: verdana-11px-rounded
]], g_ui.getRootWidget())
panelImbuiment:hide()

local panelImbuementManager = setupUI([[
MainWindow
  id: imbuementManager
  size: 420 410
  text: Auto Imbuement Manager

  FlatPanel
    id: bg
    anchors.fill: parent
    margin: -8
    margin-top: 0
    margin-bottom: 20

    FlatPanel
      id: leftBox
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      height: 60
      margin-top: 8
      margin-left: 6
      margin-right: 6

      Label
        text: Item
        anchors.top: parent.top
        anchors.left: parent.left
        margin-left: 13
        margin-top: -5
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      BotItem
        id: itemToImbue
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        margin-top: 0
        margin-left: 12
        border: 1 #d7c08a

      VerticalSeparator
        id: vsep
        anchors.top: parent.top
        anchors.left: prev.right
        anchors.bottom: parent.bottom
        margin-left: 13

      Label
        text: Slot Equipament
        anchors.top: parent.top
        anchors.left: prev.right
        margin-left: 60
        margin-top: -5
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      UIItem
        id: head
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: vsep.right
        margin-left: 10
        image-source: /images/game/slots/head
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: body
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/body
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: legs
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/legs
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: feet
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/feet
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: left-hand
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/left-hand
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: right-hand
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/right-hand
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: back
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/back
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      VerticalSeparator
        id: vsep2
        anchors.top: parent.top
        anchors.left: prev.right
        anchors.bottom: parent.bottom
        margin-left: 13

      Label
        text: Qtd. Imbue
        anchors.top: parent.top
        anchors.left: prev.right
        margin-left: 13
        margin-top: -5
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      SpinBox
        id: qtdimbue
        anchors.verticalCenter: back.verticalCenter
        anchors.left: vsep2.right
        anchors.right: parent.right
        margin-left: 10
        margin-right: 10
        text-align: center
        font: verdana-11px-rounded
        color: gray
        minimum: 1
        maximum: 3
  
    FlatPanel
      id: bottomBox
      anchors.top: leftBox.bottom
      anchors.left: leftBox.left
      anchors.right: leftBox.right
      anchors.bottom: parent.bottom
      margin-top: 5
      margin-bottom: 5

      Label
        text: Slot Imbue 1:
        anchors.top: parent.top
        anchors.left: parent.left
        margin-left: 6
        margin-top: 2
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      TextList
        id: imbueList1
        anchors.top: prev.bottom
        anchors.left: parent.left
        height: 70
        width: 260
        margin-left: 6
        margin-right: 19
        margin-top: 2
        vertical-scrollbar: imbueScroll1
        font: verdana-11px-rounded

      VerticalScrollBar
        id: imbueScroll1
        anchors.top: imbueList1.top
        anchors.bottom: imbueList1.bottom
        anchors.left: prev.right
        margin-right: 6
        step: 10
        pixels-scroll: true
        visible: true

      TextList
        id: imbueNivel1
        anchors.top: prev.top
        anchors.left: imbueList1.right
        anchors.right: parent.right
        height: 42
        margin-left: 20
        margin-right: 10
        font: verdana-11px-rounded

      Label
        text: Slot Imbue 2:
        anchors.top: imbueList1.bottom
        anchors.left: parent.left
        margin-left: 6
        margin-top: 4
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      TextList
        id: imbueList2
        anchors.top: prev.bottom
        anchors.left: parent.left
        height: 70
        width: 260
        margin-left: 6
        margin-right: 19
        margin-top: 2
        vertical-scrollbar: imbueScroll2
        font: verdana-11px-rounded

      VerticalScrollBar
        id: imbueScroll2
        anchors.top: imbueList2.top
        anchors.bottom: imbueList2.bottom
        anchors.left: imbueList2.right
        margin-right: 6
        step: 10
        pixels-scroll: true
        visible: true

      TextList
        id: imbueNivel2
        anchors.top: prev.top
        anchors.left: imbueList2.right
        anchors.right: parent.right
        height: 42
        margin-left: 20
        margin-right: 10
        font: verdana-11px-rounded

      Label
        text: Slot Imbue 3:
        anchors.top: imbueList2.bottom
        anchors.left: parent.left
        margin-left: 6
        margin-top: 4
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      TextList
        id: imbueList3
        anchors.top: prev.bottom
        anchors.left: parent.left
        width: 260
        height: 70
        margin-left: 6
        margin-right: 19
        margin-top: 2
        vertical-scrollbar: imbueScroll3
        font: verdana-11px-rounded

      VerticalScrollBar
        id: imbueScroll3
        anchors.top: imbueList3.top
        anchors.bottom: imbueList3.bottom
        anchors.left: prev.right
        margin-right: 6
        step: 10
        pixels-scroll: true
        visible: true

      TextList
        id: imbueNivel3
        anchors.top: prev.top
        anchors.left: imbueList3.right
        anchors.right: parent.right
        height: 42
        margin-left: 20
        margin-right: 10
        font: verdana-11px-rounded

  Button
    id: cancelar
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-top: 5
    width: 200
    text: Cancelar
    font: verdana-11px-rounded

  Button
    id: confirmar
    anchors.top: prev.top
    anchors.left: prev.right
    width: 200
    margin-left: 5
    text: Confirmar
    font: verdana-11px-rounded
]], g_ui.getRootWidget())
panelImbuementManager:hide()

local function destroyImbuingPanel()
  if not g_ui or not g_ui.getRootWidget then return false end
  local root = g_ui.getRootWidget()
  if not root then return false end

  -- tente por ids comuns (se você souber o id exato, coloca aqui primeiro)
  local knownIds = { "imbuingWindow", "imbueWindow", "ImbuingWindow", "imbueItemWindow" }
  for i = 1, #knownIds do
    local w = root:recursiveGetChildById(knownIds[i])
    if w and w:isVisible() then
      w:hide()
      return true
    end
  end

  -- fallback: varre janelas procurando título "Imbue Item"
  local children = root:getChildren()
  for i = 1, #children do
    local w = children[i]
    if w and w.getClassName and w:getClassName() == "UIWindow" then
      local title = w:recursiveGetChildById("title")
      if title and title.getText and title:getText() == "Imbue Item" then
        w:hide()
        return true
      end
    end
  end

  return false
end

charStorage.autoImbuement = charStorage.autoImbuement or {
  enabled = false,
  limparMinutes = 60,
  shrineMode = "imbuing", -- "imbuing" / "portable"
  entries = {},
  nextUid = 0,
  timers = {},
  recentActions = {}
}

local db = charStorage.autoImbuement
saveImbuementChar()

db.entries = db.entries or {}
db.timers = db.timers or {}
db.recentActions = db.recentActions or {}

local panel = panelImbuiment
local manager = panelImbuementManager

-- =========================================================
-- CONST / MAPS
-- =========================================================
local IMBUE_OPTIONS = {
  "Life Leech", "Mana Leech", "Critical", "Magic Level", "Skill Boost",
  "Fire Protection", "Ice Protection", "Earth Protection", "Energy Protection",
  "Death Protection", "Holy Protection",
}

local IMBUE_LEVELS = { "Basic", "Intricate", "Powerful" }

local LOOK_NAME_TO_VISUAL = {
  ["Void"] = "Mana Leech",
  ["Vampirism"] = "Life Leech",
  ["Strike"] = "Critical",
  ["Epiphany"] = "Magic Level",

  ["Precision"] = "Skill Boost",
  ["Chop"] = "Skill Boost",
  ["Slash"] = "Skill Boost",
  ["Bash"] = "Skill Boost",

  ["Dragon Hide"] = "Fire Protection",
  ["Quara Scale"] = "Ice Protection",
  ["Snake Skin"] = "Earth Protection",
  ["Cloud Fabric"] = "Energy Protection",
  ["Lich Shroud"] = "Death Protection",
  ["Demon Presence"] = "Holy Protection",

  ["Featherweight"] = "Capacity",
  ["Swiftness"] = "Speed"
}

local IMBUE_VISUAL_TO_GROUP = {
  ["Life Leech"]        = "Vampirism",
  ["Mana Leech"]        = "Void",
  ["Critical"]          = "Strike",
  ["Magic Level"]       = "Epiphany",
  ["Skill Boost"]       = "Precision",

  ["Fire Protection"]   = "Dragon Hide",
  ["Ice Protection"]    = "Quara Scale",
  ["Earth Protection"]  = "Snake Skin",
  ["Energy Protection"] = "Cloud Fabric",
  ["Death Protection"]  = "Lich Shroud",
  ["Holy Protection"]   = "Demon Presence",
}

local GROUP_TO_SHRINE_TEXT = {
  ["Void"]           = "Mana Leech",
  ["Vampirism"]      = "Hit Points Leech",
  ["Strike"]         = "Critical",
  ["Epiphany"]       = "Magic Level",
  ["Precision"]      = "Skillboost (Distance)",
  ["Lich Shroud"]    = "Elemental Protection (Death)",
  ["Snake Skin"]     = "Elemental Protection (Earth)",
  ["Demon Presence"] = "Elemental Protection (Holy)",
  ["Dragon Hide"]    = "Elemental Protection (Fire)",
  ["Quara Scale"]    = "Elemental Protection (Ice)",
  ["Cloud Fabric"]   = "Elemental Protection (Energy)",
}

local SHRINES = {25060, 25061, 25182, 25183}
local PORTABLE_SHRINE = 14513
local RECENT_ACTION_MS = 10000

local SLOT_TO_INV = {
  head = InventorySlotHead or 1,
  back = InventorySlotBack or 3,
  body = InventorySlotBody or 4,
  ["right-hand"] = InventorySlotRight or 5,
  ["left-hand"] = InventorySlotLeft or 6,
  legs = InventorySlotLeg or 7,
  feet = InventorySlotFeet or 8,
}

local SLOT_WIDGET_IDS = {"head", "body", "legs", "feet", "left-hand", "right-hand", "back"}

-- =========================================================
-- REFS
-- =========================================================
local function W(root, id)
  if not root then return nil end
  if root.recursiveGetChildById then
    return root:recursiveGetChildById(id)
  end
  if root.getChildById then
    return root:getChildById(id)
  end
  return nil
end

local refs = {
  item = W(manager, "itemToImbue"),
  qtd = W(manager, "qtdimbue"),
  confirm = W(manager, "confirmar"),
  cancel = W(manager, "cancelar"),

  open = W(panel, "clickHere"),
  close = W(panel, "closePanel"),
  list = W(panel, "imbueList"),
  limpar = W(panel, "limparImbuements"),
  limparText = W(panel, "limparText"),
  shrine = W(panel, "imbuingShrine"),
  portable = W(panel, "portableShrine"),

  leftBox = W(manager, "leftBox"),
  bottomBox = W(manager, "bottomBox"),
}

local imbueLists = { W(manager, "imbueList1"), W(manager, "imbueList2"), W(manager, "imbueList3") }
local levelLists = { W(manager, "imbueNivel1"), W(manager, "imbueNivel2"), W(manager, "imbueNivel3") }

local slotWidgets = {
  head = W(manager, "head"),
  body = W(manager, "body"),
  legs = W(manager, "legs"),
  feet = W(manager, "feet"),
  ["left-hand"] = W(manager, "left-hand"),
  ["right-hand"] = W(manager, "right-hand"),
  back = W(manager, "back"),
}

-- =========================================================
-- TEMPLATES
-- =========================================================
local selectRowTemplate = [[
selectRow < UIWidget
  id: root
  height: 13
  focusable: true
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #2F2F2F
    opacity: 0.85

  $focus:
    background-color: #2f6f3e
    opacity: 0.95

  Label
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    color: white
    text: ""
]]

local savedRowTemplate = [[
savedRow < UIWidget
  id: root
  height: 45
  focusable: true
  background-color: alpha
  margin-top: 2
  opacity: 1.00
  border: 1 alpha

  $hover:
    background-color: #2F2F2F
    opacity: 0.80
    border: 1 gray

  $focus:
    background-color: #404040
    border: 1 gray
    opacity: 0.90

  UIItem
    id: icon
    anchors.left: parent.left
    anchors.top: parent.top
    margin-left: 4
    margin-top: 2
    size: 40 40

  Label
    id: text
    anchors.left: icon.right
    anchors.right: remove.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    margin-left: 6
    margin-right: 4
    text-align: center
    font: verdana-11px-rounded
    color: white
    text-wrap: true
    text-vertical-auto-resize: true

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 3
    text: X
    color: #FF4040
    image-color: #363636
    image-source: /images/ui/button_rounded
]]

g_ui.loadUIFromString(selectRowTemplate)
g_ui.loadUIFromString(savedRowTemplate)

-- =========================================================
-- HELPERS
-- =========================================================
local function clamp(v, a, b)
  v = tonumber(v) or a
  if v < a then return a end
  if v > b then return b end
  return v
end

local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function lowerTrim(s)
  return trim(s):lower()
end

local function cloneTable(orig)
  if type(orig) ~= "table" then return orig end
  local copy = {}
  for k, v in pairs(orig) do
    if type(v) == "table" then
      copy[k] = cloneTable(v)
    else
      copy[k] = v
    end
  end
  return copy
end

local function nowMs()
  if type(now) == "number" then return now end
  if g_clock and g_clock.millis then return g_clock.millis() end
  return os.time() * 1000
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

local function clearChildren(widget)
  if not widget or not widget.getChildren then return end
  local children = widget:getChildren()
  for i = #children, 1, -1 do
    local child = children[i]
    if child and (not child.isDestroyed or not child:isDestroyed()) then
      child:destroy()
    end
  end
end

local function getRowLabel(row)
  if not row then return nil end
  return row.text or (row.getChildById and row:getChildById("text")) or nil
end

local function getRowRemove(row)
  if not row then return nil end
  return row.remove or (row.getChildById and row:getChildById("remove")) or nil
end

local function getRowIcon(row)
  if not row then return nil end
  return row.icon or (row.getChildById and row:getChildById("icon")) or nil
end

local function clearRowFocus(listWidget)
  if not listWidget or not listWidget.getChildren then return end
  for _, child in ipairs(listWidget:getChildren()) do
    if child.setFocused then child:setFocused(false) end
    child._selected = false
  end
  listWidget._selectedRow = nil
  listWidget._selectedValue = nil
end

local function setRowFocus(listWidget, row, value)
  if not listWidget or not row then return end
  clearRowFocus(listWidget)
  if row.setFocused then row:setFocused(true) end
  row._selected = true
  listWidget._selectedRow = row
  listWidget._selectedValue = value
end

local function getSelectedRowValue(listWidget)
  if not listWidget then return "" end
  return tostring(listWidget._selectedValue or "")
end

local function createSelectRow(listWidget, text, onSelect)
  local row = g_ui.createWidget("selectRow", listWidget)
  local label = getRowLabel(row)
  row._value = tostring(text or "")

  if label then
    label:setText(row._value)
  end

  row.onClick = function(widget)
    if listWidget._locked then return end
    setRowFocus(listWidget, widget, widget._value)
    if onSelect then onSelect(widget._value, widget) end
  end

  return row
end

local function fillSelectList(listWidget, entries, onSelect)
  if not listWidget then return end
  clearChildren(listWidget)
  clearRowFocus(listWidget)
  for i = 1, #entries do
    createSelectRow(listWidget, entries[i], onSelect)
  end
end

local function selectListValue(listWidget, value)
  if not listWidget or not listWidget.getChildren then return false end
  value = tostring(value or "")
  for _, child in ipairs(listWidget:getChildren()) do
    if tostring(child._value or "") == value then
      setRowFocus(listWidget, child, child._value)
      return true
    end
  end
  clearRowFocus(listWidget)
  return false
end

local function nextUid()
  db.nextUid = (tonumber(db.nextUid) or 0) + 1
  return db.nextUid
end

local function itemTimerKey(itemId)
  return tostring(tonumber(itemId) or 0)
end

local function canonImbueName(name)
  name = trim(tostring(name or ""))
  if name == "" then return "" end

  if name == "Hit Points Leech" then return "Life Leech" end
  if name == "Mana Leech" then return "Mana Leech" end
  if name == "Critical" then return "Critical" end
  if name == "Magic Level" then return "Magic Level" end

  if name == "Skillboost (Distance)" or name == "Skillboost (Sword)" or name == "Skillboost (Club)" or name == "Skillboost (Axe)" then
    return "Skill Boost"
  end

  if name == "Elemental Protection (Fire)" then return "Fire Protection" end
  if name == "Elemental Protection (Ice)" then return "Ice Protection" end
  if name == "Elemental Protection (Earth)" then return "Earth Protection" end
  if name == "Elemental Protection (Energy)" then return "Energy Protection" end
  if name == "Elemental Protection (Death)" then return "Death Protection" end
  if name == "Elemental Protection (Holy)" then return "Holy Protection" end

  return LOOK_NAME_TO_VISUAL[name] or name
end

local function tierNameToNumber(name)
  name = lowerTrim(name)
  if name == "basic" then return 1 end
  if name == "intricate" then return 2 end
  return 3
end

local function getTierFromWindowName(name)
  name = lowerTrim(name)
  if name:find("basic", 1, true) then return 1 end
  if name:find("intricate", 1, true) then return 2 end
  if name:find("powerful", 1, true) then return 3 end
  return 3
end

local function uiItemSlotNameToType(slotId)
  if slotId == "head" then return "Helmet" end
  if slotId == "body" then return "Armor" end
  if slotId == "legs" then return "Legs" end
  if slotId == "feet" then return "Boots" end
  if slotId == "left-hand" then return "Weapon" end
  if slotId == "right-hand" then return "Shield/Book" end
  if slotId == "back" then return "Bag" end
  return ""
end

local function typeToSlotKey(typ)
  if typ == "Helmet" then return "head" end
  if typ == "Armor" then return "body" end
  if typ == "Legs" then return "legs" end
  if typ == "Boots" then return "feet" end
  if typ == "Weapon" then return "left-hand" end
  if typ == "Shield/Book" then return "right-hand" end
  if typ == "Bag" then return "back" end
  return nil
end

local function getDistance(a, b)
  return math.abs(a.x - b.x) + math.abs(a.y - b.y)
end

local function getChebyshevDistance(a, b)
  return math.max(math.abs(a.x - b.x), math.abs(a.y - b.y))
end

local function isWalkablePos(pos)
  local tile = g_map.getTile(pos)
  if not tile then return false end
  if tile.isWalkable then
    return tile:isWalkable()
  end
  return true
end

local function getBestAdjacentShrinePos(shrinePos, playerPos)
  local candidates = {
    {x = shrinePos.x + 1, y = shrinePos.y, z = shrinePos.z},
    {x = shrinePos.x - 1, y = shrinePos.y, z = shrinePos.z},
    {x = shrinePos.x, y = shrinePos.y + 1, z = shrinePos.z},
    {x = shrinePos.x, y = shrinePos.y - 1, z = shrinePos.z},
    {x = shrinePos.x + 1, y = shrinePos.y + 1, z = shrinePos.z},
    {x = shrinePos.x + 1, y = shrinePos.y - 1, z = shrinePos.z},
    {x = shrinePos.x - 1, y = shrinePos.y + 1, z = shrinePos.z},
    {x = shrinePos.x - 1, y = shrinePos.y - 1, z = shrinePos.z},
  }

  local bestPos, bestDist = nil, 99999
  for _, pos in ipairs(candidates) do
    if isWalkablePos(pos) then
      local dist = getDistance(playerPos, pos)
      if dist < bestDist then
        bestDist = dist
        bestPos = pos
      end
    end
  end

  return bestPos
end

local function normalizeEntry(entry)
  entry = entry or {}
  entry.uid = tonumber(entry.uid or 0) or 0
  entry.itemId = tonumber(entry.itemId or 0) or 0
  entry.type = entry.type or ""
  entry.slotKey = entry.slotKey or typeToSlotKey(entry.type)
  entry.slots = clamp(entry.slots or 1, 1, 3)
  entry.imbues = entry.imbues or {}

  for i = 1, entry.slots do
    entry.imbues[i] = entry.imbues[i] or {name = "", level = "Basic"}
    entry.imbues[i].name = trim(entry.imbues[i].name or "")
    entry.imbues[i].level = trim(entry.imbues[i].level or "Basic")
  end

  return entry
end

local function formatImbText(imbs, qtd)
  local parts = {}
  qtd = tonumber(qtd or #imbs) or #imbs

  for i = 1, qtd do
    local n = tostring(imbs[i] and imbs[i].name or "")
    local l = tostring(imbs[i] and imbs[i].level or "")
    if n ~= "" and n ~= "nil" then
      if l ~= "" and l ~= "nil" then
        parts[#parts + 1] = n .. " (" .. l .. ")"
      else
        parts[#parts + 1] = n
      end
    end
  end

  if #parts == 0 then return "(Nenhum)" end
  return table.concat(parts, "\n")
end

-- =========================================================
-- STATE UI
-- =========================================================
local state = {
  slot = nil,
  imbues = { nil, nil, nil },
  levels = { "Basic", "Basic", "Basic" },
  editingUid = nil
}

local imbState = {
  active = false,
  queue = {},
  idx = 1,
  waitingWindow = false,
  waitingApply = false,
  currentEntry = nil,
  currentItem = nil,
  currentItemSource = nil,
  shrine = nil,
  shrinePos = nil,
  startedAt = 0,
  lastAction = 0,
  manualMode = false, -- true quando chamado por startImbueAllFromList(true); nao mexe no CaveBot
  actionToken = 0,
  reopenAfterClear = false
}

local IMBUE_MAX_RUNTIME_MS = 120000 -- 2 minutos para evitar CaveBot desligado caso bugue
local IMBUE_WAIT_WINDOW_TIMEOUT_MS = 15000
local IMBUE_WAIT_APPLY_TIMEOUT_MS = 15000

local function imbueCaveBotSetOn()
  if CaveBot and type(CaveBot.setOn) == "function" then
    pcall(function() CaveBot.setOn() end)
  end
end

local function imbueCaveBotSetOff()
  if CaveBot and type(CaveBot.setOff) == "function" then
    pcall(function() CaveBot.setOff() end)
  end
end

-- =========================================================
-- UI HELPERS
-- =========================================================
local function refreshSlotBorders()
  for name, widget in pairs(slotWidgets) do
    if widget and widget.setBorderWidth then widget:setBorderWidth(1) end
    if widget and widget.setBorderColor then
      widget:setBorderColor(name == state.slot and "#00ff66" or "#3a3a3a")
    end
    if widget and widget.setOpacity then
      widget:setOpacity(name == state.slot and 1.0 or 0.85)
    end
  end
end

local function setSectionEnabled(i, enabled)
  local a, b = imbueLists[i], levelLists[i]

  if a then
    a._locked = not enabled
    if a.setEnabled then a:setEnabled(enabled) end
    if a.setFocusable then a:setFocusable(enabled) end
    if a.setOpacity then a:setOpacity(enabled and 1.0 or 0.40) end
  end

  if b then
    b._locked = not enabled
    if b.setEnabled then b:setEnabled(enabled) end
    if b.setFocusable then b:setFocusable(enabled) end
    if b.setOpacity then b:setOpacity(enabled and 1.0 or 0.40) end
  end
end

local function getQtd()
  if refs.qtd and refs.qtd.getValue then
    return clamp(refs.qtd:getValue(), 1, 3)
  end
  return 1
end

local function updateLimparText(v)
  v = clamp(v or 1, 1, 1200)
  db.limparMinutes = v
  if refs.limparText then refs.limparText:setText(v .. " min") end
  saveImbuementChar()
end

local function setShrine(mode)
  db.shrineMode = (mode == "portable" and "portable" or "imbuing")
  if refs.shrine and refs.shrine.setOn then refs.shrine:setOn(db.shrineMode == "imbuing") end
  if refs.portable and refs.portable.setOn then refs.portable:setOn(db.shrineMode == "portable") end
  saveImbuementChar()
end

local function buildSelectList(listWidget, options, selected, enabled, setter)
  if not listWidget then return end
  clearChildren(listWidget)

  for _, value in ipairs(options) do
    local row = g_ui.createWidget("selectRow", listWidget)
    local label = getRowLabel(row)
    row._value = value

    if label then label:setText(value) end

    if enabled and selected == value then
      setRowFocus(listWidget, row, value)
    end

    row.onClick = function(widget)
      if listWidget._locked then return end
      setRowFocus(listWidget, widget, widget._value)
      if setter then setter(value) end
    end

    if not enabled then
      if row.setEnabled then row:setEnabled(false) end
      if row.setOpacity then row:setOpacity(0.40) end
    end
  end
end

local function refreshManagerLists()
  local qtd = getQtd()

  for i = 1, 3 do
    local enabled = i <= qtd
    if not enabled then
      state.imbues[i] = nil
      state.levels[i] = "Basic"
    end

    setSectionEnabled(i, enabled)

    buildSelectList(imbueLists[i], IMBUE_OPTIONS, state.imbues[i], enabled, function(v)
      state.imbues[i] = v
    end)

    buildSelectList(levelLists[i], IMBUE_LEVELS, state.levels[i], enabled, function(v)
      state.levels[i] = v
    end)
  end
end

local function resetManager()
  state.slot = nil
  state.editingUid = nil
  state.imbues = { nil, nil, nil }
  state.levels = { "Basic", "Basic", "Basic" }

  if refs.item and refs.item.setItemId then refs.item:setItemId(0) end
  if refs.qtd and refs.qtd.setValue then refs.qtd:setValue(1) end

  refreshSlotBorders()
  refreshManagerLists()
end

local function loadEntryToManager(entry)
  entry = normalizeEntry(cloneTable(entry))
  state.editingUid = tonumber(entry.uid) or nil
  state.slot = entry.slotKey or typeToSlotKey(entry.type)
  state.imbues = { nil, nil, nil }
  state.levels = { "Basic", "Basic", "Basic" }

  if refs.item and refs.item.setItemId then refs.item:setItemId(entry.itemId or 0) end
  if refs.qtd and refs.qtd.setValue then refs.qtd:setValue(entry.slots or 1) end

  for i = 1, entry.slots do
    state.imbues[i] = entry.imbues[i] and entry.imbues[i].name or nil
    state.levels[i] = entry.imbues[i] and entry.imbues[i].level or "Basic"
  end

  refreshSlotBorders()
  refreshManagerLists()
end

local function removeEntryByUid(uid)
  uid = tonumber(uid)
  if not uid then return end

  for i = #db.entries, 1, -1 do
    if tonumber(db.entries[i].uid) == uid then
      table.remove(db.entries, i)
      break
    end
  end

  saveImbuementChar()
  rebuildMainList()
end

local function createSavedRow(listWidget, entry, onRemove)
  local row = g_ui.createWidget("savedRow", listWidget)
  local icon = getRowIcon(row)
  local label = getRowLabel(row)
  local remove = getRowRemove(row)

  row._uid = tonumber(entry.uid)

  if icon and icon.setItemId then
    icon:setItemId(tonumber(entry.itemId) or 0)
    icon.onItemChange = function() icon:setItemId(tonumber(entry.itemId) or 0) end
    icon.onDrop = function() return false end
  end

  if label then
    label:setText(formatImbText(entry.imbues or {}, entry.slots))
  end

  row.onClick = function(widget)
    setRowFocus(listWidget, widget, widget._uid)
    for i = 1, #db.entries do
      if tonumber(db.entries[i].uid) == tonumber(widget._uid) then
        loadEntryToManager(db.entries[i])
        panel:hide()
        manager:show()
        manager:raise()
        manager:focus()
        break
      end
    end
  end

  if remove then
    remove.onClick = function()
      if onRemove then onRemove(entry, row) end
    end
  end

  return row
end

function rebuildMainList()
  if not refs.list then return end
  clearChildren(refs.list)
  clearRowFocus(refs.list)

  for i = 1, #db.entries do
    local entry = normalizeEntry(db.entries[i])
    db.entries[i] = entry
    createSavedRow(refs.list, entry, function(data)
      removeEntryByUid(data.uid)
    end)
  end
end

local function saveEntry()
  local itemId = refs.item and refs.item.getItemId and tonumber(refs.item:getItemId()) or 0
  local slotKey = state.slot
  local slots = getQtd()

  if itemId <= 0 then
    warn("[Imb] Selecione um item.")
    return false
  end

  if not slotKey or slotKey == "" then
    warn("[Imb] Selecione o slot do equipamento.")
    return false
  end

  local entry = {
    uid = state.editingUid or nextUid(),
    itemId = itemId,
    slotKey = slotKey,
    type = uiItemSlotNameToType(slotKey),
    slots = slots,
    imbues = {}
  }

  for i = 1, slots do
    local name = trim(state.imbues[i] or "")
    local level = trim(state.levels[i] or "Basic")

    if name == "" then
      warn("[Imb] Selecione o imbue do slot " .. i .. ".")
      return false
    end

    if level == "" then
      warn("[Imb] Selecione o nível do slot " .. i .. ".")
      return false
    end

    entry.imbues[i] = { name = name, level = level }
  end

  local replaced = false
  for i = 1, #db.entries do
    if tonumber(db.entries[i].uid) == tonumber(entry.uid) then
      db.entries[i] = normalizeEntry(entry)
      replaced = true
      break
    end
  end

  if not replaced then
    db.entries[#db.entries + 1] = normalizeEntry(entry)
  end

  saveImbuementChar()
  return true
end

-- =========================================================
-- UI BIND
-- =========================================================
db.enabled = true
function checkerImbuementsList()
  if db.enabled ~= true then
    imbueCaveBotSetOn()
    return true
  end

  if imbState.active then
    return "retry"
  end

  local started = startImbueAllFromList()
  if started == true then
    return "retry"
  end

  -- Se lista vazia, item nao encontrado, ou qualquer falha inicial, libera a cave.
  imbueCaveBotSetOn()
  return true
end

if refs.limpar then
  if refs.limpar.setMinimum then refs.limpar:setMinimum(1) end
  if refs.limpar.setMaximum then refs.limpar:setMaximum(1200) end
  if refs.limpar.setValue then refs.limpar:setValue(clamp(db.limparMinutes or 60, 1, 1200)) end
  refs.limpar.onValueChange = function()
    updateLimparText(refs.limpar:getValue())
  end
end
updateLimparText(db.limparMinutes or 60)

if refs.shrine then
  refs.shrine.onClick = function() setShrine("imbuing") end
end
if refs.portable then
  refs.portable.onClick = function() setShrine("portable") end
end
setShrine(db.shrineMode or "imbuing")

if refs.open then
  refs.open.onClick = function()
    resetManager()
    panel:hide()
    manager:show()
    manager:raise()
    manager:focus()
  end
end

if refs.close then
  refs.close.onClick = function()
    panel:hide()
    manager:hide()
  end
end

if refs.cancel then
  refs.cancel.onClick = function()
    manager:hide()
    panel:show()
    panel:raise()
    panel:focus()
    resetManager()
  end
end

if refs.confirm then
  refs.confirm.onClick = function()
    if not saveEntry() then return end
    rebuildMainList()
    manager:hide()
    panel:show()
    panel:raise()
    panel:focus()
    resetManager()
  end
end

if refs.qtd then
  refs.qtd.onValueChange = function()
    refreshManagerLists()
  end
  refs.qtd.onValueChanged = function()
    refreshManagerLists()
  end
end

for _, id in ipairs(SLOT_WIDGET_IDS) do
  local w = slotWidgets[id]
  if w then
    w.onClick = function()
      state.slot = id
      refreshSlotBorders()
    end
    w.onMouseRelease = function(widget, mousePos, button)
      if button ~= MouseLeftButton then return false end
      state.slot = id
      refreshSlotBorders()
      return true
    end
  end
end

refreshManagerLists()
refreshSlotBorders()
rebuildMainList()

-- =========================================================
-- ITEM FIND / LOOK
-- =========================================================
local function findItemInContainers(itemId)
  if not itemId or itemId <= 0 then return nil end
  if type(getContainers) ~= "function" then return nil end

  local conts = getContainers()
  if not conts then return nil end

  for c = 1, #conts do
    local cont = conts[c]
    if cont and cont.getItems then
      local items = cont:getItems()
      if items then
        for i = 1, #items do
          local it = items[i]
          if it and it.getId and it:getId() == itemId then
            return it
          end
        end
      end
    end
  end

  return nil
end

local function getInventoryItemBySlot(slotKey)
  local invSlot = SLOT_TO_INV[slotKey]
  if not invSlot then return nil end

  if getInventoryItem then
    return getInventoryItem(invSlot)
  end

  if g_game and g_game.getLocalPlayer and g_game.getLocalPlayer() and g_game.getLocalPlayer().getInventoryItem then
    return g_game.getLocalPlayer():getInventoryItem(invSlot)
  end

  return nil
end

local function findItemObject(itemId, typText, slotKey)
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return nil end

  local equipped = slotKey and getInventoryItemBySlot(slotKey) or nil
  if equipped and equipped.getId and equipped:getId() == itemId then
    return equipped, "equip"
  end

  if type(findItem) == "function" then
    local any = findItem(itemId)
    if any and any.getId and any:getId() == itemId then
      return any, "findItem"
    end
  end

  local cont = findItemInContainers(itemId)
  if cont then return cont, "container" end

  return nil, nil
end

local function doLook(itemObj)
  if not itemObj then return false end
  if g_game and type(g_game.look) == "function" then
    g_game.look(itemObj)
    return true
  end
  if type(look) == "function" then
    look(itemObj)
    return true
  end
  return false
end

-- =========================================================
-- LOOK PARSE / TIMERS
-- =========================================================
local function parseTimeToSeconds(text)
  text = tostring(text or "")

  local hh, mm = text:match("(%d+):(%d+)%s*[hH]")
  if hh and mm then
    return (tonumber(hh) or 0) * 3600 + (tonumber(mm) or 0) * 60
  end

  hh, mm = text:match("(%d+):(%d+)")
  if hh and mm then
    return (tonumber(hh) or 0) * 3600 + (tonumber(mm) or 0) * 60
  end

  local h2, m2 = text:match("(%d+)%s*[hH]%s*(%d+)%s*[mM]")
  if h2 then
    return (tonumber(h2) or 0) * 3600 + (tonumber(m2) or 0) * 60
  end

  local h3 = text:match("(%d+)%s*[hH]")
  if h3 then
    return (tonumber(h3) or 0) * 3600
  end

  return nil
end

local function parseImbuesFromLookText(text)
  text = tostring(text or "")
  local imbBlock = text:match("Imbuements:%s*%((.-)%)")
  if not imbBlock or imbBlock == "" then return {} end

  local out = {}

  for part in imbBlock:gmatch("([^,]+)") do
    part = trim(part)
    if part ~= "" and not part:find("Free Slot", 1, true) then
      local tier, rest = part:match("^(Basic)%s+(.+)$")
      if not tier then tier, rest = part:match("^(Intricate)%s+(.+)$") end
      if not tier then tier, rest = part:match("^(Powerful)%s+(.+)$") end

      tier = trim(tier or "")
      rest = trim(rest or part)

      local timeToken = rest:match("(%d+:%d+%s*[hH])") or rest:match("(%d+%s*[hH]%s*%d+%s*[mM])")
      local rawName = rest
      if timeToken then
        rawName = trim(rest:gsub(timeToken, ""))
      end

      local visual = LOOK_NAME_TO_VISUAL[rawName] or rawName
      local sec = timeToken and parseTimeToSeconds(timeToken) or nil
      local timeStr = "--:--"

      if timeToken then
        local hh, mm = timeToken:match("(%d+):(%d+)")
        if hh and mm then
          timeStr = string.format("%02d:%02d", tonumber(hh) or 0, tonumber(mm) or 0)
        else
          local h2, m2 = timeToken:match("(%d+)%s*[hH]%s*(%d+)%s*[mM]")
          if h2 then
            timeStr = string.format("%02d:%02d", tonumber(h2) or 0, tonumber(m2) or 0)
          end
        end
      end

      out[#out + 1] = {
        tier = tier,
        raw = rawName,
        visual = visual,
        seconds = sec,
        timeStr = timeStr
      }
    end
  end

  return out
end

local function updateTimerFromLook(itemId, lookText)
  local key = tostring(tonumber(itemId) or 0)
  local detected = parseImbuesFromLookText(lookText)
  local updatedNow = nowMs()

  charStorage.autoImbuement = charStorage.autoImbuement or {}
  charStorage.autoImbuement.timers = charStorage.autoImbuement.timers or {}

  charStorage.autoImbuement.timers[key] = charStorage.autoImbuement.timers[key] or {}
  charStorage.autoImbuement.timers[key].detected = detected
  charStorage.autoImbuement.timers[key].updated = updatedNow

  db.timers = charStorage.autoImbuement.timers
  saveImbuementChar()

end

local function getDetectedImbueTimeByVisual(itemId, visualName)
  local info = db.timers[itemTimerKey(itemId)]
  if not info or type(info.detected) ~= "table" then return nil end

  visualName = tostring(visualName or "")
  for i = 1, #info.detected do
    local d = info.detected[i]
    if tostring(d.visual or "") == visualName then
      return tonumber(d.seconds or 0) or 0
    end
  end

  return nil
end

local function isRecentAction(itemId)
  local key = itemTimerKey(itemId)
  local t = tonumber(db.recentActions[key] or 0) or 0
  if t <= 0 then return false end

  local diff = nowMs() - t

  if diff < 0 then
    db.recentActions[key] = nil
    saveImbuementChar()
    return false
  end

  if diff >= RECENT_ACTION_MS then
    db.recentActions[key] = nil
    saveImbuementChar()
    return false
  end

  return true
end

local function markRecentAction(itemId)
  db.recentActions[itemTimerKey(itemId)] = nowMs()
  saveImbuementChar()
end

-- =========================================================
-- SHRINE / PORTABLE
-- =========================================================
local function findNearestShrine()
  if not player or not player.getPosition then return nil, nil end
  local playerPos = player:getPosition()
  local bestShrine, bestDist, bestPos = nil, 99999, nil

  for x = -7, 7 do
    for y = -5, 5 do
      local scanPos = {x = playerPos.x + x, y = playerPos.y + y, z = playerPos.z}
      local tile = g_map.getTile(scanPos)
      if tile then
        local items = tile:getItems()
        if items then
          for _, item in ipairs(items) do
            local itemId = item:getId()
            for _, shrineId in ipairs(SHRINES) do
              if itemId == shrineId then
                local dist = getDistance(playerPos, scanPos)
                if dist < bestDist then
                  bestDist = dist
                  bestShrine = item
                  bestPos = scanPos
                end
                break
              end
            end
          end
        end
      end
    end
  end

  return bestShrine, bestPos
end

local function isNearShrine(shrine)
  if not shrine or not shrine.getPosition or not player or not player.getPosition then return false end
  local playerPos = player:getPosition()
  local shrinePos = shrine:getPosition()
  return getChebyshevDistance(playerPos, shrinePos) <= 1
end

local function ensureNearShrine(shrine)
  if not shrine or not shrine.getPosition then return false end
  if isNearShrine(shrine) then return true end

  local playerPos = player:getPosition()
  local shrinePos = shrine:getPosition()
  local walkPos = getBestAdjacentShrinePos(shrinePos, playerPos)

  if not walkPos then
    return false
  end

  if getDistance(playerPos, walkPos) > 0 then
    autoWalk(walkPos, 20, {ignoreNonPathable = true, precision = 1})
  end

  return false
end

local function useThingWithSafe(a, b)
  -- No OTC/vBot algumas funcoes de useWith abrem a janela corretamente,
  -- mas retornam nil/false. Entao aqui o sucesso significa: conseguiu chamar
  -- a funcao sem erro. Quem confirma se abriu mesmo e o onImbuementWindow/timeout.
  if type(useThingWith) == "function" then
    local ok = pcall(function() useThingWith(a, b) end)
    return ok == true
  end

  if type(useWith) == "function" then
    local ok = pcall(function() useWith(a, b) end)
    return ok == true
  end

  if g_game and type(g_game.useWith) == "function" then
    local ok = pcall(function() g_game.useWith(a, b) end)
    return ok == true
  end

  return false
end

local function openShrineOnItem(itemObj)
  if not itemObj then return false end

  if db.shrineMode == "portable" then
    local portable = findItem and findItem(PORTABLE_SHRINE) or nil
    if not portable then
      return false
    end
    return useThingWithSafe(portable, itemObj)
  end

  local shrine, shrinePos = findNearestShrine()
  if not shrine then
    return false
  end

  imbState.shrine = shrine
  imbState.shrinePos = shrinePos

  if not isNearShrine(shrine) then
    ensureNearShrine(shrine)

    later(1800, function()
      if not imbState.active then return end
      if not imbState.currentItem then return end
      if not imbState.shrine then return end
      if not isNearShrine(imbState.shrine) then return end

      imbState.waitingWindow = true
      imbState.lastAction = nowMs()
      useThingWithSafe(imbState.shrine, imbState.currentItem)
    end)

    return true
  end

  return useThingWithSafe(shrine, itemObj)
end

-- =========================================================
-- IMB WINDOW MATCH
-- =========================================================
local function getTierFromEntryLevel(levelName)
  return tierNameToNumber(levelName)
end

local function findImbueFromWindow(windowImbuements, visualName, tierNum)
  if type(windowImbuements) ~= "table" then return nil end

  visualName = tostring(visualName or "")
  if visualName == "" then return nil end

  local groupInternal = IMBUE_VISUAL_TO_GROUP[visualName]
  if not groupInternal then
    return nil
  end

  local shrineText = GROUP_TO_SHRINE_TEXT[groupInternal] or groupInternal
  tierNum = tonumber(tierNum) or 3

  for i = 1, #windowImbuements do
    local imb = windowImbuements[i]
    local groupName = tostring(imb.group or "")
    local windowName = tostring(imb.name or "")

    local okGroup =
      (groupName == shrineText) or
      (windowName:find(shrineText, 1, true) ~= nil) or
      (windowName:find(groupInternal, 1, true) ~= nil) or
      (windowName:find(visualName, 1, true) ~= nil)

    if okGroup then
      local tier = getTierFromWindowName(windowName)
      if tier == tierNum then
        return imb
      end
    end
  end

  return nil
end

local function tryClearImbuement(slotIdx)
  slotIdx = tonumber(slotIdx) or 0

  if g_game and type(g_game.clearImbuement) == "function" then
    g_game.clearImbuement(slotIdx, true)
    return true
  end

  if g_game and type(g_game.removeImbuement) == "function" then
    g_game.removeImbuement(slotIdx, true)
    return true
  end

  if g_game and type(g_game.clearImbuementSlot) == "function" then
    g_game.clearImbuementSlot(slotIdx, true)
    return true
  end

  if type(clearImbuement) == "function" then
    clearImbuement(slotIdx, true)
    return true
  end

  if type(removeImbuement) == "function" then
    removeImbuement(slotIdx, true)
    return true
  end

  return false
end

local function tryApplyImbuement(slotIdx, imbData)
  if not imbData then return false end

  if g_game and type(g_game.applyImbuement) == "function" then
    g_game.applyImbuement(slotIdx, imbData.id, true)
    return true
  end

  return false
end

local function buildActionsForEntry(entry, activeSlots, windowImbuements)
  local actions = {}
  local thresholdSec = (tonumber(db.limparMinutes or 0) or 0) * 60

  for slotIdx = 0, entry.slots - 1 do
    local cfg = entry.imbues[slotIdx + 1]
    if cfg and trim(cfg.name) ~= "" then
      local desiredVisual = canonImbueName(cfg.name)
      local desiredTier = getTierFromEntryLevel(cfg.level)

      local active = activeSlots and activeSlots[slotIdx] or nil
      local shouldApply = false

      if active then
        local activeInfo = active[1]
        local activeTime = tonumber(active[2] or 0) or 0
        local activeName = canonImbueName(activeInfo and (activeInfo.group or activeInfo.name) or "")

        if activeName == desiredVisual then
          if activeTime <= thresholdSec then
            actions[#actions + 1] = {
              kind = "clear",
              slotIdx = slotIdx,
              visualName = desiredVisual
            }
            shouldApply = true
          end
        else
          actions[#actions + 1] = {
            kind = "clear",
            slotIdx = slotIdx,
            visualName = desiredVisual
          }
          shouldApply = true
        end
      else
        shouldApply = true
      end

      if shouldApply then
        local imbData = findImbueFromWindow(windowImbuements, desiredVisual, desiredTier)
        if imbData then
          actions[#actions + 1] = {
            kind = "apply",
            slotIdx = slotIdx,
            visualName = desiredVisual,
            imbData = imbData
          }
        else
        end
      end
    end
  end

  return actions
end

local function runActions(actions, onDone)
  local idx = 1

  local function nextAction()
    if idx > #actions then
      if onDone then onDone() end
      return
    end

    local action = actions[idx]
    idx = idx + 1

    if action.kind == "clear" then
      if not tryClearImbuement(action.slotIdx) then
        later(500, nextAction)
        return
      end
      later(1800, nextAction)
      return
    end

    if action.kind == "apply" then
      if not tryApplyImbuement(action.slotIdx, action.imbData) then
        later(500, nextAction)
        return
      end
      later(2200, nextAction)
      return
    end

    later(200, nextAction)
  end

  nextAction()
end

-- =========================================================
-- RUNTIME QUEUE
-- =========================================================
local function resetImbState()
  imbState.active = false
  imbState.queue = {}
  imbState.idx = 1
  imbState.waitingWindow = false
  imbState.waitingApply = false
  imbState.currentEntry = nil
  imbState.currentItem = nil
  imbState.currentItemSource = nil
  imbState.shrine = nil
  imbState.shrinePos = nil
  imbState.startedAt = 0
  imbState.lastAction = 0
  imbState.manualMode = false
  imbState.actionToken = 0
  imbState.reopenAfterClear = false
end

local function closeCurrentImbuingWindow()
  if g_game and type(g_game.closeImbuingWindow) == "function" then
    pcall(function() g_game.closeImbuingWindow() end)
  end

  destroyImbuingPanel()
end

local function finishImbueAndResume(reason)
  local manualMode = imbState.manualMode == true

  if reason and reason ~= "" then
    warn(reason)
  end

  closeCurrentImbuingWindow()
  resetImbState()

  -- Se foi chamado manualmente com startImbueAllFromList(true), nao liga/desliga CaveBot.
  if not manualMode then
    imbueCaveBotSetOn()
  end
end

local function finishCurrentImbueItem(reason)
  -- Finaliza somente o item atual e continua a fila.
  -- Usado quando falta material, nao abriu janela, falhou apply/clear ou item ja esta OK.
  if reason and reason ~= "" then
    warn(reason)
  end

  closeCurrentImbuingWindow()

  imbState.waitingWindow = false
  imbState.waitingApply = false
  imbState.currentEntry = nil
  imbState.currentItem = nil
  imbState.currentItemSource = nil
  imbState.shrine = nil
  imbState.shrinePos = nil
  imbState.actionToken = (tonumber(imbState.actionToken or 0) or 0) + 1
  imbState.lastAction = nowMs()
end

local function buildAutoImbueQueue()
  local q = {}

  for i, entry in ipairs(db.entries or {}) do
    entry = normalizeEntry(entry)
    local itemObj, source = findItemObject(entry.itemId, entry.type, entry.slotKey)
    if itemObj and itemObj.getId and itemObj:getId() == entry.itemId then
      q[#q + 1] = {
        entry = entry,
        itemId = entry.itemId,
        typ = entry.type,
        slotKey = entry.slotKey,
        itemObj = itemObj,
        source = source
      }
    end
  end

  return q
end


function startImbueAllFromList(manualMode)
  manualMode = manualMode == true

  if db.enabled ~= true then
    warn("[Imb] Ative o BotSwitch 'Imbuiments' para usar.")
    if not manualMode then imbueCaveBotSetOn() end
    return false
  end

  if imbState.active then
    warn("[Imb] Já está processando.")
    return true
  end

  if type(db.entries) ~= "table" or #db.entries == 0 then
    warn("[Imb] Sua lista está vazia.")
    resetImbState()
    if not manualMode then imbueCaveBotSetOn() end
    return false
  end

  local q = buildAutoImbueQueue()
  if #q == 0 then
    warn("[Imb] Nenhum item configurado foi encontrado.")
    resetImbState()
    if not manualMode then imbueCaveBotSetOn() end
    return false
  end

  local t = nowMs()

  -- Modo automatico pelo CaveBot: pausa a cave e religa no final/timeout.
  -- Modo manual startImbueAllFromList(true): nao mexe no CaveBot.
  if not manualMode then
    imbueCaveBotSetOff()
  end

  imbState.active = true
  imbState.queue = q
  imbState.idx = 1
  imbState.waitingWindow = false
  imbState.waitingApply = false
  imbState.currentEntry = nil
  imbState.currentItem = nil
  imbState.currentItemSource = nil
  imbState.shrine = nil
  imbState.shrinePos = nil
  imbState.startedAt = t
  imbState.lastAction = t
  imbState.manualMode = manualMode
  imbState.actionToken = 0
  imbState.reopenAfterClear = false

  return true
end

-- =========================================================
-- WINDOW CALLBACK
-- =========================================================
local function onWindow(itemId, slots, activeSlots, windowImbuements, needItems)
  if not imbState.active then return end
  if not imbState.currentEntry then return end

  local entry = imbState.currentEntry
  if tonumber(entry.itemId) ~= tonumber(itemId) then
    return
  end

  imbState.waitingWindow = false
  imbState.waitingApply = true
  imbState.lastAction = nowMs()

  local actions = buildActionsForEntry(entry, activeSlots or {}, windowImbuements or {})
  
  -- Se não há mais nenhuma ação na fila, o item está perfeitamente imbuido.
  -- Finaliza só este item e segue para o próximo da lista.
  if #actions == 0 then
    later(300, function()
      if imbState.active and imbState.currentEntry and tonumber(imbState.currentEntry.uid) == tonumber(entry.uid) then
        finishCurrentImbueItem("")
      end
    end)
    return
  end

  -- Pega APENAS a primeira ação e manda para o servidor.
  -- Depois aguarda o servidor responder com a janela atualizada.
  local action = actions[1]
  local sent = false

  if action.kind == "clear" then
    sent = tryClearImbuement(action.slotIdx)
  elseif action.kind == "apply" then
    sent = tryApplyImbuement(action.slotIdx, action.imbData)
  end

  if not sent then
    finishCurrentImbueItem("[Imb] Falhou ao enviar acao de imbue para este item. Pulando item e seguindo lista.")
    return
  end

  local actionUid = entry.uid
  imbState.actionToken = (tonumber(imbState.actionToken or 0) or 0) + 1
  local actionToken = imbState.actionToken

  -- Timeout de segurança por ITEM: se faltar material, gold, item de imbue, ou o servidor
  -- nao atualizar a janela, pula somente este item e continua os próximos da lista.
  later(3500, function()
    if imbState.active
      and imbState.waitingApply
      and imbState.currentEntry
      and tonumber(imbState.currentEntry.uid) == tonumber(actionUid)
      and tonumber(imbState.currentEntry.itemId) == tonumber(itemId)
      and tonumber(imbState.actionToken or 0) == tonumber(actionToken) then
        finishCurrentImbueItem("[Imb] Falhou/nao confirmou imbue deste item. Pulando item e seguindo lista.")
    end
  end)
end

if type(onImbuementWindow) == "function" then
  onImbuementWindow(onWindow)
else
end

-- =========================================================
-- MAIN ENGINE
-- =========================================================
macro(200, function()
  if db.enabled ~= true then return end
  if not imbState.active then return end

  local t = nowMs()
  local startedAt = tonumber(imbState.startedAt or 0) or 0
  local lastAction = tonumber(imbState.lastAction or 0) or 0

  if startedAt > 0 and t - startedAt > IMBUE_MAX_RUNTIME_MS then
    finishImbueAndResume("[Imb] Timeout geral do imbuement. Processo finalizado por seguranca.")
    return
  end

  if imbState.waitingWindow then
    if lastAction > 0 and t - lastAction > IMBUE_WAIT_WINDOW_TIMEOUT_MS then
      finishCurrentImbueItem("[Imb] Timeout aguardando janela de imbue deste item. Pulando item e seguindo lista.")
    end
    return
  end

  if imbState.waitingApply then
    if lastAction > 0 and t - lastAction > IMBUE_WAIT_APPLY_TIMEOUT_MS then
      finishCurrentImbueItem("[Imb] Timeout aplicando/removendo imbue deste item. Pulando item e seguindo lista.")
    end
    return
  end

  if t - (imbState.lastAction or 0) < 800 then return end

  if imbState.idx > #imbState.queue then
    finishImbueAndResume("")
    return
  end

  local data = imbState.queue[imbState.idx]
  imbState.idx = imbState.idx + 1

  local entry = data.entry
  local itemObj, source = findItemObject(data.itemId, data.typ, data.slotKey)

  if not itemObj or not itemObj.getId or itemObj:getId() ~= data.itemId then
    imbState.lastAction = t
    return
  end

  imbState.currentEntry = entry
  imbState.currentItem = itemObj
  imbState.currentItemSource = source
  imbState.waitingWindow = true
  imbState.lastAction = t

  if not openShrineOnItem(itemObj) then
    finishCurrentImbueItem("[Imb] Nao conseguiu abrir shrine/portable para este item. Pulando item e seguindo lista.")
    return
  end
end)

-- =========================================================
-- LOOK UPDATE TIMER
-- =========================================================
local lookState = {
  waitingItemId = nil,
  waitingTextUntil = 0,
  queue = {},
  idx = 1,
  running = false
}
local lookSuppress = {
  active = false,
  untilTime = 0,
  lastClear = 0
}

local function startLookSuppress(ms)
  lookSuppress.active = true
  lookSuppress.untilTime = nowMs() + (ms or 1500)
end

local function stopLookSuppress()
  lookSuppress.active = false
  lookSuppress.untilTime = 0
end

local function isLookSuppressActive()
  if not lookSuppress.active then return false end
  if nowMs() > (lookSuppress.untilTime or 0) then
    stopLookSuppress()
    return false
  end
  return true
end

local function clearGreenLookMessage()
  local t = nowMs()
  if t - (lookSuppress.lastClear or 0) < 250 then return end
  lookSuppress.lastClear = t

  if modules and modules.game_textmessage and modules.game_textmessage.clearMessages then
    modules.game_textmessage.clearMessages()
  end
end

local function buildLookQueue()
  local q = {}
  local seen = {}

  for i = 1, #db.entries do
    local entry = normalizeEntry(db.entries[i])
    if entry.itemId > 0 and not seen[entry.itemId] then
      seen[entry.itemId] = true
      q[#q + 1] = cloneTable(entry)
    end
  end

  return q
end

local function processLookQueue()
  if lookState.running ~= true then return end
  if lookState.waitingItemId then return end

  if lookState.idx > #lookState.queue then
    lookState.running = false
    return
  end

  local entry = lookState.queue[lookState.idx]
  lookState.idx = lookState.idx + 1

  local itemObj = nil
  itemObj = getInventoryItemBySlot(entry.slotKey)
  if not itemObj or not itemObj.getId or itemObj:getId() ~= entry.itemId then
    itemObj = findItemInContainers(entry.itemId)
  end

  if not itemObj then
    later(150, processLookQueue)
    return
  end

  lookState.waitingItemId = tonumber(entry.itemId)
  lookState.waitingTextUntil = nowMs() + 3000

  startLookSuppress(1500)

    if not doLook(itemObj) then
      stopLookSuppress()
      lookState.waitingItemId = nil
      later(120, processLookQueue)
      return
    end
  end

macro(30000, function()
  if #db.entries == 0 then return end
  if imbState.active then return end
  if lookState.running then return end

  lookState.queue = buildLookQueue()
  lookState.idx = 1
  lookState.running = true
  lookState.waitingItemId = nil
  processLookQueue()
end)

macro(200, function()
  if not lookState.waitingItemId then return end
  if nowMs() > (lookState.waitingTextUntil or 0) then
    lookState.waitingItemId = nil
    later(50, processLookQueue)
  end
end)

-- =========================================================
-- STATUS MESSAGE HOOK
-- =========================================================
botserver = botserver or { __callbacks = {} }

if not onStatusMessage then
  botserver.__callbacks.onStatusMessage = {}

  onStatusMessage = function(callback)
    table.insert(botserver.__callbacks.onStatusMessage, function(...)
      callback(...)
    end)

    local cb = botserver.__callbacks.onStatusMessage[#botserver.__callbacks.onStatusMessage]
    return {
      remove = function()
        for i, cb2 in ipairs(botserver.__callbacks.onStatusMessage) do
          if cb == cb2 then
            table.remove(botserver.__callbacks.onStatusMessage, i)
            break
          end
        end
      end
    }
  end
end

if modules and modules.game_textmessage and not botserver.__imbHookInstalled then
  botserver.__imbHookInstalled = true
  local oldStatus = modules.game_textmessage.displayStatusMessage

  modules.game_textmessage.displayStatusMessage = function(text, color)
    if oldStatus then
      oldStatus(text, color)
    end

    local callbacks = botserver.__callbacks.onStatusMessage or {}
    for i = 1, #callbacks do
      callbacks[i](text)
    end
  end
end

onTextMessage(function(mode, text)
  if not lookState.waitingItemId then return end
  if type(text) ~= "string" then return end
  if not text:find("Imbuements:", 1, true) then return end

  updateTimerFromLook(lookState.waitingItemId, text)
  lookState.waitingItemId = nil

  if isLookSuppressActive() then
    later(1, clearGreenLookMessage)
    later(80, clearGreenLookMessage)
  end

  stopLookSuppress()
  later(250, processLookQueue)
end)

function cavebotCheckImbueByLook()
  local db = charStorage.autoImbuement or {}

  if db.enabled ~= true then
    return "Hunt"
  end

  if type(db.entries) ~= "table" or #db.entries == 0 then
    return "Hunt"
  end

  if type(db.timers) ~= "table" then
    return "retry"
  end

  local thresholdSec = (tonumber(db.limparMinutes or 0) or 0) * 60

  local LOOK_NAME_TO_VISUAL = {
    ["Void"] = "Mana Leech",
    ["Vampirism"] = "Life Leech",
    ["Strike"] = "Critical",
    ["Epiphany"] = "Magic Level",
    ["Precision"] = "Skill Boost",
    ["Chop"] = "Skill Boost",
    ["Slash"] = "Skill Boost",
    ["Bash"] = "Skill Boost",
    ["Dragon Hide"] = "Fire Protection",
    ["Quara Scale"] = "Ice Protection",
    ["Snake Skin"] = "Earth Protection",
    ["Cloud Fabric"] = "Energy Protection",
    ["Lich Shroud"] = "Death Protection",
    ["Demon Presence"] = "Holy Protection",
    ["Featherweight"] = "Capacity",
    ["Swiftness"] = "Speed"
  }

  local function trim(s)
    return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
  end

  local function canonImbueName(name)
    name = trim(name)
    if name == "" then return "" end

    if name == "Hit Points Leech" then return "Life Leech" end
    if name == "Mana Leech" then return "Mana Leech" end
    if name == "Critical" then return "Critical" end
    if name == "Magic Level" then return "Magic Level" end

    if name == "Skillboost (Distance)" or name == "Skillboost (Sword)" or name == "Skillboost (Club)" or name == "Skillboost (Axe)" then
      return "Skill Boost"
    end

    if name == "Elemental Protection (Fire)" then return "Fire Protection" end
    if name == "Elemental Protection (Ice)" then return "Ice Protection" end
    if name == "Elemental Protection (Earth)" then return "Earth Protection" end
    if name == "Elemental Protection (Energy)" then return "Energy Protection" end
    if name == "Elemental Protection (Death)" then return "Death Protection" end
    if name == "Elemental Protection (Holy)" then return "Holy Protection" end

    return LOOK_NAME_TO_VISUAL[name] or name
  end

  for i = 1, #db.entries do
    local entry = db.entries[i]
    local itemId = tonumber(entry.itemId or 0) or 0
    local slots = tonumber(entry.slots or 1) or 1
    local imbues = entry.imbues or {}

    if itemId > 0 then
      local info = db.timers[tostring(itemId)]

      -- ainda não recebeu look desse item
      if not info or type(info.detected) ~= "table" then
        return "retry"
      end

      for slot = 1, slots do
        local cfg = imbues[slot]
        if cfg and trim(cfg.name) ~= "" then
          local wanted = canonImbueName(cfg.name)
          local found = nil

          for j = 1, #info.detected do
            local d = info.detected[j]
            if tostring(d.visual or "") == wanted then
              found = d
              break
            end
          end

          if not found then
            return "REFRESH"
          end

          local sec = tonumber(found.seconds or 0) or 0
          if sec <= thresholdSec then
            return "REFRESH"
          end
        end
      end
    end
  end

  return "Hunt"
end
-- =========================================================
-- AUTO START / INIT
-- =========================================================
panel:hide()
manager:hide()
end

do
  -- Scroll Imbue - LNS
-- Storage por personagem usando LNS Storage Core

if not loadCharStorage or not saveCharStorage then
  return print("[Scroll Imbue] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()
charStorage.scrollImbue = charStorage.scrollImbue or {
  scrolls = {},
  entries = {},
  nextUid = 0,
  selectedTab = "blank"
}

local db = charStorage.scrollImbue
db.scrolls = db.scrolls or {}
db.entries = db.entries or {}
db.nextUid = tonumber(db.nextUid or 0) or 0
db.selectedTab = db.selectedTab or "blank"

local function saveScrollImbue()
  saveCharStorage(charStorage)
end

local IMBUE_OPTIONS = {
  "Hit Points Leech",
  "Mana Leech",
  "Critical",
  "Magic Level",
  "Capacity",
  "Speed Bonus",
  "Elemental Damage (Fire)",
  "Elemental Damage (Earth)",
  "Elemental Damage (Ice)",
  "Elemental Damage (Energy)",
  "Elemental Damage (Death)",
  "Elemental Protection (Fire)",
  "Elemental Protection (Earth)",
  "Elemental Protection (Ice)",
  "Elemental Protection (Energy)",
  "Elemental Protection (Holy)",
  "Skill Bonus (Axe)",
  "Skill Bonus (Sword)",
  "Skill Bonus (Club)",
  "Skill Bonus (Distance)",
  "Skill Bonus (Fist)",
  "Skill Bonus (Shielding)"
}

local function trim(v)
  return tostring(v or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function W(root, id)
  if not root then return nil end
  if root.recursiveGetChildById then return root:recursiveGetChildById(id) end
  if root.getChildById then return root:getChildById(id) end
  return nil
end

local function clearChildren(widget)
  if not widget or not widget.getChildren then return end
  local childs = widget:getChildren()
  for i = #childs, 1, -1 do
    if childs[i] and childs[i].destroy then childs[i]:destroy() end
  end
end

local function itemId(widget)
  if not widget then return 0 end
  if widget.getItemId then return tonumber(widget:getItemId()) or 0 end
  if widget.getItem then
    local it = widget:getItem()
    if it and it.getId then return tonumber(it:getId()) or 0 end
  end
  return 0
end

local function setItem(widget, id)
  if widget and widget.setItemId then widget:setItemId(tonumber(id) or 0) end
end

local function spinValue(widget)
  if widget and widget.getValue then return tonumber(widget:getValue()) or 0 end
  return 0
end

local function setSpin(widget, value)
  if widget and widget.setValue then widget:setValue(tonumber(value) or 0) end
end

local function switchValue(widget)
  if not widget then return false end
  if widget.isOn then return widget:isOn() end
  if widget.getOn then return widget:getOn() end
  if widget.isChecked then return widget:isChecked() end
  return widget.on == true
end

local function setSwitch(widget, value)
  if not widget then return end
  value = value == true
  if widget.setOn then
    widget:setOn(value)
  elseif widget.setChecked then
    widget:setChecked(value)
  end
end

local function validImbueName(name)
  name = trim(name)
  for i = 1, #IMBUE_OPTIONS do
    if IMBUE_OPTIONS[i] == name then return name end
  end
  return nil
end

local function optionText(option)
  if type(option) == "string" then return trim(option) end
  if type(option) == "table" then
    if option.getText then
      local ok, txt = pcall(function() return option:getText() end)
      if ok then return trim(txt) end
    end
    if option.text then return trim(option.text) end
    if option.name then return trim(option.name) end
  end
  return ""
end

local function comboText(combo)
  if not combo then return IMBUE_OPTIONS[1] end

  if combo.getText then
    local txt = validImbueName(combo:getText())
    if txt then return txt end
  end

  if combo.getCurrentOption then
    local ok, option = pcall(function() return combo:getCurrentOption() end)
    if ok then
      local txt = validImbueName(optionText(option))
      if txt then return txt end
    end
  end

  return IMBUE_OPTIONS[1]
end

local function setCombo(combo, text)
  if not combo then return end
  text = validImbueName(text) or IMBUE_OPTIONS[1]

  -- NUNCA passe a tabela da option aqui. Em algumas builds isso vira "table: 0x..." no ComboBox.
  if combo.setCurrentOption then
    pcall(function() combo:setCurrentOption(text) end)
  end

  if combo.setText then
    combo:setText(text)
  end
end

local function getItemName(id)
  id = tonumber(id) or 0
  if id <= 0 then return "Item 0" end

  if g_things and g_things.getThingType then
    local ok, thing = pcall(function()
      return g_things.getThingType(id, ThingCategoryItem)
    end)
    if ok and thing and thing.getName then
      local name = trim(thing:getName())
      if name ~= "" then return name end
    end
  end

  return "Item " .. id
end

local SCROLL_ID_TO_DISPLAY_NAME = {
  [51462] = "Critical",
  [51459] = "Elemental Fire",
  [51453] = "Elemental Ice",
  [51464] = "Life Leech",
  [51467] = "Mana Leech",
  [51445] = "Shielding",
  [51455] = "Distance",
  [51450] = "Elemental Energy",
  [51465] = "Elemental Earth",
  [51461] = "Protect Earth",
  [51448] = "Protect Holy",
  [51457] = "Protect Ice",
  [51449] = "Protect Fire",
  [41454] = "Protect Death",
  [51454] = "Protect Death",
  [51447] = "Protect Energy",
  [51446] = "Axe",
  [51451] = "Magic Level"
}

local SCROLL_ID_TO_CONFIG_NAME = {
  [51462] = "Critical",
  [51459] = "Elemental Damage (Fire)",
  [51453] = "Elemental Damage (Ice)",
  [51464] = "Hit Points Leech",
  [51467] = "Mana Leech",
  [51445] = "Skill Bonus (Shielding)",
  [51455] = "Skill Bonus (Distance)",
  [51450] = "Elemental Damage (Energy)",
  [51465] = "Elemental Damage (Earth)",
  [51461] = "Elemental Protection (Earth)",
  [51448] = "Elemental Protection (Holy)",
  [51457] = "Elemental Protection (Ice)",
  [51449] = "Elemental Protection (Fire)",
  [41454] = "Elemental Protection (Death)",
  [51454] = "Elemental Protection (Death)",
  [51447] = "Elemental Protection (Energy)",
  [51446] = "Skill Bonus (Axe)",
  [51451] = "Magic Level"
}

local function scrollDisplayNameById(id)
  id = tonumber(id) or 0
  return SCROLL_ID_TO_DISPLAY_NAME[id] or ("Scroll " .. id)
end

local function scrollConfigNameById(id)
  id = tonumber(id) or 0
  return SCROLL_ID_TO_CONFIG_NAME[id] or ""
end

local function formatEntry(entry)
  local names = {}
  for _, scrollId in ipairs(entry.scrollIds or {}) do
    local name = scrollDisplayNameById(scrollId)
    if name ~= "" then names[#names + 1] = name end
  end

  if #names == 0 then
    return "sem scroll"
  end

  return table.concat(names, "\n")
end

local rowTemplate = [[
scrollImbueListRow < UIWidget
  id: root
  height: 45
  focusable: true
  background-color: alpha
  margin-top: 2
  opacity: 1.00
  border: 1 alpha

  $hover:
    background-color: #2F2F2F
    opacity: 0.85
    border: 1 gray

  $focus:
    background-color: #404040
    border: 1 gray
    opacity: 0.95

  UIItem
    id: icon
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    size: 34 34
    phantom: true

  Label
    id: text
    anchors.left: icon.right
    anchors.right: remove.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    margin-left: 7
    margin-right: 4
    text-align: center
    font: verdana-11px-rounded
    color: white
    text-wrap: true

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 18
    height: 18
    margin-right: 4
    text: X
    color: #FF4040
    image-color: #363636
    image-source: /images/ui/button_rounded
]]

g_ui.loadUIFromString(rowTemplate)

panelScrollImbue = setupUI([[
blankScroll < Panel
  height: 30
  margin-top: 0
  phantom: false

  BotItem
    id: blankScroll
    anchors.left: parent.left
    anchors.top: parent.top
    margin-top: 2
    margin-left: 5

  Label
    id: labelImbue
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 10
    margin-top: 0
    text: Slot Imbue:
    text-auto-resize: true
    font: verdana-11px-rounded

  ComboBox
    id: imbueType
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-left: 0
    margin-top: 2
    height: 18
    width: 180
    font: verdana-11px-rounded
    @onSetup: |
      self:addOption("Hit Points Leech")
      self:addOption("Mana Leech")
      self:addOption("Critical")
      self:addOption("Magic Level")
      self:addOption("Capacity")
      self:addOption("Speed Bonus")
      self:addOption("Elemental Damage (Fire)")
      self:addOption("Elemental Damage (Earth)")
      self:addOption("Elemental Damage (Ice)")
      self:addOption("Elemental Damage (Energy)")
      self:addOption("Elemental Damage (Death)")
      self:addOption("Elemental Protection (Fire)")
      self:addOption("Elemental Protection (Earth)")
      self:addOption("Elemental Protection (Ice)")
      self:addOption("Elemental Protection (Energy)")
      self:addOption("Elemental Protection (Holy)")
      self:addOption("Skill Bonus (Axe)")
      self:addOption("Skill Bonus (Sword)")
      self:addOption("Skill Bonus (Club)")
      self:addOption("Skill Bonus (Distance)")
      self:addOption("Skill Bonus (Fist)")
      self:addOption("Skill Bonus (Shielding)")

  Label
    id: labelQtde
    anchors.top: labelImbue.top
    anchors.left: prev.right
    margin-left: 10
    margin-top: 0
    text: Amount:
    text-auto-resize: true
    font: verdana-11px-rounded

  SpinBox
    id: qtdeScroll
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-left: 0
    margin-top: 2
    height: 18
    width: 80
    minimum: 0
    maximum: 100
    text-align: center

  Label
    id: labelONOFF
    anchors.top: labelQtde.top
    anchors.left: prev.right
    margin-left: 10
    margin-top: 0
    text: Status:
    text-auto-resize: true
    font: verdana-11px-rounded

  BotSwitch
    id: ativador
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-left: 0
    margin-top: 2
    height: 18
    width: 55
    font: verdana-11px-rounded
    $on:
      text: ON
      color: green
      image-color: green
    $!on:
      text: OFF
      color: white
      image-color: #7a0000

MainWindow
  size: 410 350
  text: Panel Imbue Scroll

  Button
    id: imbueBlank
    checkable: true
    anchors.top: parent.top
    anchors.left: parent.left
    height: 33
    margin-left: -5
    width: 194
    text-align: center
    text: Blank Scroll

    UIItem
      id: idBlank
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -5
      size: 33 33
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 35
      margin-right: 3
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  Button
    id: imbueItems
    checkable: true
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    height: 33
    margin-left: 0
    width: 194
    text-align: center
    text: Imbue Items

    UIItem
      id: idItem
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -5
      size: 33 33
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 35
      margin-right: 3
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  FlatPanel
    id: flatp1
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-bottom: 20
    margin-left: -5
    margin-top: 6
    margin-right: -5

    blankScroll
      id: blank1
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5

    blankScroll
      id: blank2
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 12

    blankScroll
      id: blank3
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 12

    blankScroll
      id: blank4
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 12

    blankScroll
      id: blank5
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 12

    blankScroll
      id: blank6
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 12

  FlatPanel
    id: flatp2
    anchors.top: flatp1.top
    anchors.left: flatp1.left
    anchors.right: flatp1.right
    anchors.bottom: flatp1.bottom

    UIButton
      id: clickHere
      anchors.top: parent.top
      anchors.left: parent.left
      text: Click Here
      margin-top: 5
      margin-left: 80
      color: #FFD700
      text-auto-resize: true
      font: verdana-11px-rounded
      opacity: 1.00
      $hover:
        opacity: 0.80

    Label
      id: labelClick
      anchors.verticalCenter: clickHere.verticalCenter
      anchors.left: clickHere.right
      margin-left: 4
      margin-top: 0
      font: verdana-11px-rounded
      text: to configure scroll imbue

    HorizontalSeparator
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5

    TextList
      id: scrollList
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-top: 5
      margin-left: 5
      margin-right: 15
      margin-bottom: 5
      vertical-scrollbar: scrollListBar
      font: verdana-11px-rounded

    VerticalScrollBar
      id: scrollListBar
      anchors.top: scrollList.top
      anchors.bottom: scrollList.bottom
      anchors.left: scrollList.right
      step: 10
      pixels-scroll: true
      visible: true

  Button
    id: closePanel
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    text: Close
    margin-top: 5
]], g_ui.getRootWidget())

panelScrollImbue:hide()
panelScrollImbue.imbueBlank.idBlank:setItemId(51442)
panelScrollImbue.imbueItems.idItem:setItemId(28719)

panelScrollImbue.closePanel.onClick = function()
  panelScrollImbue:hide()
end

scrollImbueCfg = setupUI([[
MainWindow
  size: 260 120
  text: Panel Imbue Scroll

  HorizontalSeparator
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 2
    margin-left: -5
    margin-right: -5

  Label
    id: label1
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 6
    margin-left: 10
    text: ITEM ID
    text-auto-resize: true
    font: cipsoftFont

  BotItem
    id: itemImbue
    anchors.top: prev.bottom
    anchors.horizontalCenter: prev.horizontalCenter
    margin-top: 7

  Label
    id: label2
    anchors.top: label1.top
    anchors.left: label1.right
    margin-top: 0
    margin-left: 37
    text: SLOT 1
    text-auto-resize: true
    font: cipsoftFont

  BotItem
    id: itemSlot1
    anchors.top: prev.bottom
    anchors.horizontalCenter: prev.horizontalCenter
    margin-top: 7

  Label
    id: label3
    anchors.top: label2.top
    anchors.left: label2.right
    margin-top: 0
    margin-left: 20
    text: SLOT 2
    text-auto-resize: true
    font: cipsoftFont

  BotItem
    id: itemSlot2
    anchors.top: prev.bottom
    anchors.horizontalCenter: prev.horizontalCenter
    margin-top: 7

  Label
    id: label4
    anchors.top: label3.top
    anchors.left: label3.right
    margin-top: 0
    margin-left: 20
    text: SLOT 3
    text-auto-resize: true
    font: cipsoftFont

  BotItem
    id: itemSlot3
    anchors.top: prev.bottom
    anchors.horizontalCenter: prev.horizontalCenter
    margin-top: 7

  HorizontalSeparator
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    margin-left: -5
    margin-right: -5

  VerticalSeparator
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.bottom: prev.bottom
    margin-top: 3
    margin-left: -5

  VerticalSeparator
    anchors.top: prev.top
    anchors.left: label1.right
    anchors.bottom: prev.bottom
    margin-left: 15

  VerticalSeparator
    anchors.top: prev.top
    anchors.left: label4.right
    anchors.bottom: prev.bottom
    margin-left: 20

  Button
    id: cancel
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-left: -5
    width: 119
    height: 20
    text: CANCEL
    font: cipsoftFont
    margin-top: 5

  Button
    id: insert
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 1
    width: 119
    height: 20
    text: INSERT
    font: cipsoftFont
    margin-top: 0
]], g_ui.getRootWidget())

scrollImbueCfg:hide()

local main = panelScrollImbue
local cfg = scrollImbueCfg
local editingUid = nil
local loadingScrollRows = false

local function eachScrollRow(fn)
  for i = 1, 6 do
    local row = main.flatp1["blank" .. i]
    if row then fn(i, row) end
  end
end

local function saveBlankRows()
  if loadingScrollRows then return end

  eachScrollRow(function(i, row)
    db.scrolls[i] = {
      itemId = itemId(row.blankScroll),
      imbue = comboText(row.imbueType),
      amount = spinValue(row.qtdeScroll),
      enabled = switchValue(row.ativador)
    }
  end)

  saveScrollImbue()
  rebuildScrollList()
end

local function loadBlankRows()
  loadingScrollRows = true

  eachScrollRow(function(i, row)
    local data = db.scrolls[i] or {}
    local imbue = validImbueName(data.imbue) or IMBUE_OPTIONS[1]
    data.imbue = imbue
    db.scrolls[i] = data

    setItem(row.blankScroll, data.itemId or 0)
    setCombo(row.imbueType, imbue)
    setSpin(row.qtdeScroll, data.amount or 0)
    setSwitch(row.ativador, data.enabled == true)
  end)

  loadingScrollRows = false
end

local function bindBlankRows()
  eachScrollRow(function(i, row)
    row.blankScroll.onItemChange = saveBlankRows
    row.imbueType.onOptionChange = saveBlankRows
    row.imbueType.onTextChange = saveBlankRows
    row.qtdeScroll.onValueChange = saveBlankRows
    row.qtdeScroll.onValueChanged = saveBlankRows
    row.ativador.onClick = function(widget)
      setSwitch(widget, not switchValue(widget))
      saveBlankRows()
      return true
    end
  end)
end

local function newUid()
  db.nextUid = (tonumber(db.nextUid) or 0) + 1
  return db.nextUid
end

local function clearCfg()
  editingUid = nil
  setItem(cfg.itemImbue, 0)
  setItem(cfg.itemSlot1, 0)
  setItem(cfg.itemSlot2, 0)
  setItem(cfg.itemSlot3, 0)
end

local function loadEntry(entry)
  editingUid = tonumber(entry.uid)
  setItem(cfg.itemImbue, entry.itemId or 0)
  setItem(cfg.itemSlot1, entry.scrollIds and entry.scrollIds[1] or 0)
  setItem(cfg.itemSlot2, entry.scrollIds and entry.scrollIds[2] or 0)
  setItem(cfg.itemSlot3, entry.scrollIds and entry.scrollIds[3] or 0)
end

local function removeEntry(uid)
  uid = tonumber(uid)
  if not uid then return end

  for i = #db.entries, 1, -1 do
    if tonumber(db.entries[i].uid) == uid then
      table.remove(db.entries, i)
      break
    end
  end

  saveScrollImbue()
  rebuildScrollList()
end

function rebuildScrollList()
  local list = main.flatp2.scrollList
  if not list then return end

  clearChildren(list)

  for _, entry in ipairs(db.entries) do
    local row = g_ui.createWidget("scrollImbueListRow", list)
    row._uid = tonumber(entry.uid)
    row.icon:setItemId(tonumber(entry.itemId) or 0)
    row.text:setText(formatEntry(entry))

    row.onClick = function(widget)
      for _, data in ipairs(db.entries) do
        if tonumber(data.uid) == tonumber(widget._uid) then
          loadEntry(data)
          cfg:show()
          cfg:raise()
          cfg:focus()
          break
        end
      end
    end

    row.remove.onClick = function()
      removeEntry(entry.uid)
      return true
    end
  end
end

local function saveEntryFromCfg()
  local targetItem = itemId(cfg.itemImbue)
  if targetItem <= 0 then
    return false
  end

  local scrollIds = {}
  local s1 = itemId(cfg.itemSlot1)
  local s2 = itemId(cfg.itemSlot2)
  local s3 = itemId(cfg.itemSlot3)

  if s1 > 0 then scrollIds[#scrollIds + 1] = s1 end
  if s2 > 0 then scrollIds[#scrollIds + 1] = s2 end
  if s3 > 0 then scrollIds[#scrollIds + 1] = s3 end

  if #scrollIds == 0 then
    return false
  end

  local entry = {
    uid = editingUid or newUid(),
    itemId = targetItem,
    scrollIds = scrollIds
  }

  local replaced = false
  for i = 1, #db.entries do
    if tonumber(db.entries[i].uid) == tonumber(entry.uid) then
      db.entries[i] = entry
      replaced = true
      break
    end
  end

  if not replaced then
    db.entries[#db.entries + 1] = entry
  end

  saveScrollImbue()
  rebuildScrollList()
  clearCfg()
  cfg:hide()
  main:show()
  main:raise()
  main:focus()
  return true
end

local function showWidget(widget, visible)
  if not widget then return end
  if visible then
    if widget.show then widget:show() end
  else
    if widget.hide then widget:hide() end
  end
end

local function setTabPressed(button, pressed)
  if not button then return end
  showWidget(W(button, "activeLine"), pressed)

  if button.setChecked then pcall(function() button:setChecked(pressed) end) end
  if button.setPressed then pcall(function() button:setPressed(pressed) end) end
  if button.setOn then pcall(function() button:setOn(pressed) end) end

  if button.setOpacity then button:setOpacity(pressed and 1.00 or 0.74) end
  if button.setColor then button:setColor(pressed and "#d7c08a" or "#d6d6d6") end

end

local function setTab(tab)
  db.selectedTab = tab

  if tab == "blank" then
    main.flatp1:show()
    main.flatp2:hide()
    setTabPressed(main.imbueBlank, true)
    setTabPressed(main.imbueItems, false)
  else
    main.flatp1:hide()
    main.flatp2:show()
    setTabPressed(main.imbueBlank, false)
    setTabPressed(main.imbueItems, true)
  end

  saveScrollImbue()
end

main.imbueBlank.onClick = function()
  setTab("blank")
end

main.imbueItems.onClick = function()
  setTab("items")
end

main.flatp2.clickHere.onClick = function()
  clearCfg()
  cfg:show()
  cfg:raise()
  cfg:focus()
end

cfg.cancel.onClick = function()
  clearCfg()
  cfg:hide()
end

cfg.insert.onClick = function()
  saveEntryFromCfg()
end

loadBlankRows()
bindBlankRows()
rebuildScrollList()
setTab(db.selectedTab or "blank")
saveScrollImbue()


-- =========================================================
-- BLANK SCROLL AUTO IMBUE ENGINE
-- =========================================================

local BLANK_SCROLL_ID = 51442
local SHRINES = {25060, 25061, 25182, 25183}

-- IDs finais dos scrolls ja imbuídos, usados para contar quanto falta fazer.
local SCROLL_RESULT_IDS = {
  ["Critical"] = 51462,
  ["Elemental Damage (Fire)"] = 51459,
  ["Elemental Damage (Ice)"] = 51453,
  ["Hit Points Leech"] = 51464,
  ["Mana Leech"] = 51467,
  ["Skill Bonus (Shielding)"] = 51445,
  ["Skill Bonus (Distance)"] = 51455,
  ["Elemental Damage (Energy)"] = 51450,
  ["Elemental Damage (Earth)"] = 51465,
  ["Elemental Protection (Earth)"] = 51461,
  ["Elemental Protection (Holy)"] = 51448,
  ["Elemental Protection (Ice)"] = 51457,
  ["Elemental Protection (Fire)"] = 51449,
  ["Elemental Protection (Death)"] = 41454,
  ["Elemental Protection (Energy)"] = 51447,
  ["Skill Bonus (Axe)"] = 51446,
  ["Magic Level"] = 51451
}

local IMBUE_ALIASES = {
  ["Hit Points Leech"] = {"Hit Points Leech", "Life Leech", "Vampirism"},
  ["Mana Leech"] = {"Mana Leech", "Void"},
  ["Critical"] = {"Critical", "Strike"},
  ["Magic Level"] = {"Magic Level", "Epiphany"},
  ["Capacity"] = {"Capacity", "Featherweight"},
  ["Speed Bonus"] = {"Speed", "Speed Bonus", "Swiftness"},

  ["Elemental Damage (Fire)"] = {"Elemental Damage (Fire)", "Fire Damage", "Scorch"},
  ["Elemental Damage (Earth)"] = {"Elemental Damage (Earth)", "Earth Damage", "Venom"},
  ["Elemental Damage (Ice)"] = {"Elemental Damage (Ice)", "Ice Damage", "Frost"},
  ["Elemental Damage (Energy)"] = {"Elemental Damage (Energy)", "Energy Damage", "Electrify"},
  ["Elemental Damage (Death)"] = {"Elemental Damage (Death)", "Death Damage", "Reap"},

  ["Elemental Protection (Fire)"] = {"Elemental Protection (Fire)", "Fire Protection", "Dragon Hide"},
  ["Elemental Protection (Earth)"] = {"Elemental Protection (Earth)", "Earth Protection", "Snake Skin"},
  ["Elemental Protection (Ice)"] = {"Elemental Protection (Ice)", "Ice Protection", "Quara Scale"},
  ["Elemental Protection (Energy)"] = {"Elemental Protection (Energy)", "Energy Protection", "Cloud Fabric"},
  ["Elemental Protection (Holy)"] = {"Elemental Protection (Holy)", "Holy Protection", "Demon Presence"},
  ["Elemental Protection (Death)"] = {"Elemental Protection (Death)", "Death Protection", "Lich Shroud"},

  ["Skill Bonus (Axe)"] = {"Skill Bonus (Axe)", "Skillboost (Axe)", "Axe", "Chop"},
  ["Skill Bonus (Sword)"] = {"Skill Bonus (Sword)", "Skillboost (Sword)", "Sword", "Slash"},
  ["Skill Bonus (Club)"] = {"Skill Bonus (Club)", "Skillboost (Club)", "Club", "Bash"},
  ["Skill Bonus (Distance)"] = {"Skill Bonus (Distance)", "Skillboost (Distance)", "Distance", "Precision"},
  ["Skill Bonus (Fist)"] = {"Skill Bonus (Fist)", "Skillboost (Fist)", "Fist"},
  ["Skill Bonus (Shielding)"] = {"Skill Bonus (Shielding)", "Skillboost (Shielding)", "Shielding", "Shield"}
}

local scrollCraftState = {
  active = false,
  queue = {},
  idx = 1,
  waitingWindow = false,
  waitingApply = false,
  current = nil,
  currentBlank = nil,
  shrine = nil,
  shrinePos = nil,
  lastAction = 0,
  startedAt = 0,
  timeoutAt = 0,
  releaseCavebotUntil = 0
}

local function nowMs()
  if type(now) == "number" then return now end
  if g_clock and g_clock.millis then return g_clock.millis() end
  return os.time() * 1000
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

local function lower(v)
  return trim(v):lower()
end

local function hasText(text, piece)
  text = lower(text)
  piece = lower(piece)
  if piece == "" then return false end
  return text:find(piece, 1, true) ~= nil
end

local function getDistance(a, b)
  return math.abs(a.x - b.x) + math.abs(a.y - b.y)
end

local function getChebyshevDistance(a, b)
  return math.max(math.abs(a.x - b.x), math.abs(a.y - b.y))
end

local function isWalkablePos(pos)
  if not g_map or not g_map.getTile then return false end
  local tile = g_map.getTile(pos)
  if not tile then return false end
  if tile.isWalkable then return tile:isWalkable() end
  return true
end

local function getBestAdjacentShrinePos(shrinePos, playerPos)
  local candidates = {
    {x = shrinePos.x + 1, y = shrinePos.y, z = shrinePos.z},
    {x = shrinePos.x - 1, y = shrinePos.y, z = shrinePos.z},
    {x = shrinePos.x, y = shrinePos.y + 1, z = shrinePos.z},
    {x = shrinePos.x, y = shrinePos.y - 1, z = shrinePos.z},
    {x = shrinePos.x + 1, y = shrinePos.y + 1, z = shrinePos.z},
    {x = shrinePos.x + 1, y = shrinePos.y - 1, z = shrinePos.z},
    {x = shrinePos.x - 1, y = shrinePos.y + 1, z = shrinePos.z},
    {x = shrinePos.x - 1, y = shrinePos.y - 1, z = shrinePos.z}
  }

  local bestPos, bestDist = nil, 99999
  for _, pos in ipairs(candidates) do
    if isWalkablePos(pos) then
      local dist = getDistance(playerPos, pos)
      if dist < bestDist then
        bestDist = dist
        bestPos = pos
      end
    end
  end

  return bestPos
end

local function findNearestShrine()
  if not player or not player.getPosition or not g_map or not g_map.getTile then return nil, nil end
  local playerPos = player:getPosition()
  local bestShrine, bestDist, bestPos = nil, 99999, nil

  for x = -7, 7 do
    for y = -5, 5 do
      local scanPos = {x = playerPos.x + x, y = playerPos.y + y, z = playerPos.z}
      local tile = g_map.getTile(scanPos)
      if tile and tile.getItems then
        local items = tile:getItems()
        if items then
          for _, item in ipairs(items) do
            local id = item:getId()
            for _, shrineId in ipairs(SHRINES) do
              if id == shrineId then
                local dist = getDistance(playerPos, scanPos)
                if dist < bestDist then
                  bestDist = dist
                  bestShrine = item
                  bestPos = scanPos
                end
                break
              end
            end
          end
        end
      end
    end
  end

  return bestShrine, bestPos
end

local function isNearShrine(shrine)
  if not shrine or not shrine.getPosition or not player or not player.getPosition then return false end
  return getChebyshevDistance(player:getPosition(), shrine:getPosition()) <= 1
end

local function ensureNearShrine(shrine)
  if not shrine or not shrine.getPosition or not player or not player.getPosition then return false end
  if isNearShrine(shrine) then return true end

  local walkPos = getBestAdjacentShrinePos(shrine:getPosition(), player:getPosition())
  if not walkPos then return false end

  if type(autoWalk) == "function" then
    autoWalk(walkPos, 20, {ignoreNonPathable = true, precision = 1})
  end

  return false
end

local function useThingWithSafe(a, b)
  -- Em algumas builds do OTC/vBot, useThingWith/useWith abre a janela mas retorna nil/false.
  -- Por isso: se a função existe e foi chamada sem erro, consideramos como tentativa válida.
  if type(useThingWith) == "function" then
    local ok = pcall(function() useThingWith(a, b) end)
    return ok == true
  end

  if type(useWith) == "function" then
    local ok = pcall(function() useWith(a, b) end)
    return ok == true
  end

  return false
end

local function openShrineOnBlankScroll(itemObj)
  if not itemObj then return false end

  local shrine, shrinePos = findNearestShrine()
  if not shrine then
    return false
  end

  scrollCraftState.shrine = shrine
  scrollCraftState.shrinePos = shrinePos

  if not isNearShrine(shrine) then
    ensureNearShrine(shrine)

    later(1800, function()
      if not scrollCraftState.active then return end
      if not scrollCraftState.currentBlank then return end
      if not scrollCraftState.shrine then return end
      if not isNearShrine(scrollCraftState.shrine) then return end

      scrollCraftState.waitingWindow = true
      scrollCraftState.lastAction = nowMs()
      useThingWithSafe(scrollCraftState.shrine, scrollCraftState.currentBlank)
    end)

    return true
  end

  return useThingWithSafe(shrine, itemObj)
end

local function itemCount(it)
  if not it then return 0 end
  if it.getCount then
    local c = tonumber(it:getCount()) or 0
    if c > 0 then return c end
  end
  if it.getSubType then
    local c = tonumber(it:getSubType()) or 0
    if c > 0 then return c end
  end
  return 1
end

local function countItemInContainers(id)
  id = tonumber(id) or 0
  if id <= 0 then return 0 end

  -- Primeiro tenta contadores nativos do bot, porque eles costumam contar melhor
  -- todos os itens visíveis nas containers abertas.
  if type(itemAmount) == "function" then
    local ok, amount = pcall(function() return itemAmount(id) end)
    amount = tonumber(ok and amount or 0) or 0
    if amount > 0 then return amount end
  end

  if type(getItemsCount) == "function" then
    local ok, amount = pcall(function() return getItemsCount(id) end)
    amount = tonumber(ok and amount or 0) or 0
    if amount > 0 then return amount end
  end

  if type(getContainers) ~= "function" then return 0 end

  local total = 0
  local conts = getContainers()
  if not conts then return 0 end

  for c = 1, #conts do
    local cont = conts[c]
    if cont and cont.getItems then
      local items = cont:getItems()
      if items then
        for i = 1, #items do
          local it = items[i]
          if it and it.getId and it:getId() == id then
            total = total + itemCount(it)
          end
        end
      end
    end
  end

  return total
end

local function findItemInContainersById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  if type(findItem) == "function" then
    local it = findItem(id)
    if it and it.getId and it:getId() == id then return it end
  end

  if type(getContainers) ~= "function" then return nil end
  local conts = getContainers()
  if not conts then return nil end

  for c = 1, #conts do
    local cont = conts[c]
    if cont and cont.getItems then
      local items = cont:getItems()
      if items then
        for i = 1, #items do
          local it = items[i]
          if it and it.getId and it:getId() == id then return it end
        end
      end
    end
  end

  return nil
end

local function tierScore(name)
  name = lower(name)
  if name:find("powerful", 1, true) then return 3 end
  if name:find("intricate", 1, true) then return 2 end
  if name:find("basic", 1, true) then return 1 end
  return 0
end

local function findImbueFromWindow(windowImbuements, desiredName)
  if type(windowImbuements) ~= "table" then return nil end

  desiredName = validImbueName(desiredName) or trim(desiredName)
  local aliases = IMBUE_ALIASES[desiredName] or {desiredName}
  local best, bestScore = nil, -1

  for i = 1, #windowImbuements do
    local imb = windowImbuements[i]
    local groupName = tostring(imb.group or "")
    local windowName = tostring(imb.name or "")
    local allText = groupName .. " " .. windowName
    local matched = false

    for _, alias in ipairs(aliases) do
      if hasText(allText, alias) then
        matched = true
        break
      end
    end

    if matched then
      local score = tierScore(windowName)
      if score >= bestScore then
        best = imb
        bestScore = score
      end
    end
  end

  return best
end

local function tryApplyImbuement(slotIdx, imbData)
  if not imbData then return false end
  if g_game and type(g_game.applyImbuement) == "function" then
    g_game.applyImbuement(slotIdx, imbData.id, true)
    return true
  end
  return false
end

local function closeImbuingWindowSafe()
  local closed = false

  if g_game and type(g_game.closeImbuingWindow) == "function" then
    pcall(function() g_game.closeImbuingWindow() end)
    closed = true
  end

  if g_ui and g_ui.getRootWidget then
    local root = g_ui.getRootWidget()
    if root and root.recursiveGetChildById then
      local knownIds = {"imbuingWindow", "imbueWindow", "ImbuingWindow", "imbueItemWindow"}
      for i = 1, #knownIds do
        local w = root:recursiveGetChildById(knownIds[i])
        if w and w.isVisible and w:isVisible() and w.hide then
          w:hide()
          closed = true
        end
      end
    end

    if root and root.getChildren then
      local childs = root:getChildren()
      for i = 1, #childs do
        local w = childs[i]
        if w and w.recursiveGetChildById then
          local title = w:recursiveGetChildById("title")
          if title and title.getText and tostring(title:getText()) == "Imbue Item" and w.hide then
            w:hide()
            closed = true
          end
        end
      end
    end
  end

  return closed
end

local function resetScrollCraftState()
  scrollCraftState.active = false
  scrollCraftState.queue = {}
  scrollCraftState.idx = 1
  scrollCraftState.waitingWindow = false
  scrollCraftState.waitingApply = false
  scrollCraftState.current = nil
  scrollCraftState.currentBlank = nil
  scrollCraftState.shrine = nil
  scrollCraftState.shrinePos = nil
  scrollCraftState.lastAction = 0
  scrollCraftState.startedAt = 0
  scrollCraftState.timeoutAt = 0
end

local function finishScrollCrafting(message, releaseCavebotMs)
  resetScrollCraftState()
  closeImbuingWindowSafe()

  if releaseCavebotMs and releaseCavebotMs > 0 then
    scrollCraftState.releaseCavebotUntil = nowMs() + releaseCavebotMs
  end

  if message and message ~= "" then warn(message) end
end

local function buildScrollCraftQueue()
  local q = {}
  local maxByResult = {}

  -- Junta linhas repetidas do mesmo imbue e usa a MAIOR quantidade configurada.
  -- Ex.: duas linhas de Mana Leech com amount 3 nao viram 6, continuam meta 3.
  for i = 1, 6 do
    local cfgData = db.scrolls[i]
    if cfgData and cfgData.enabled == true then
      local name = validImbueName(cfgData.imbue) or ""
      local amount = tonumber(cfgData.amount or 0) or 0
      local resultId = SCROLL_RESULT_IDS[name]
      local blankId = tonumber(cfgData.itemId or 0) or BLANK_SCROLL_ID
      if blankId <= 0 then blankId = BLANK_SCROLL_ID end

      if name ~= "" and amount > 0 then
        if not resultId then
        else
          local key = tostring(resultId)
          local current = maxByResult[key]
          if not current or amount > current.amount then
            maxByResult[key] = {
              row = i,
              name = name,
              amount = amount,
              resultId = resultId,
              blankId = blankId
            }
          end
        end
      end
    end
  end

  for _, data in pairs(maxByResult) do
    local currentAmount = countItemInContainers(data.resultId)
    local missing = data.amount - currentAmount

    if missing > 0 then
      for n = 1, missing do
        q[#q + 1] = {
          row = data.row,
          name = data.name,
          amount = data.amount,
          resultId = data.resultId,
          blankId = data.blankId
        }
      end
    end
  end

  return q
end

function startScrollImbueBlank()
  if scrollCraftState.active then
    return false
  end

  saveBlankRows()
  local q = buildScrollCraftQueue()

  if #q == 0 then
    return false
  end

  local t = nowMs()
  scrollCraftState.active = true
  scrollCraftState.queue = q
  scrollCraftState.idx = 1
  scrollCraftState.waitingWindow = false
  scrollCraftState.waitingApply = false
  scrollCraftState.current = nil
  scrollCraftState.currentBlank = nil
  scrollCraftState.shrine = nil
  scrollCraftState.shrinePos = nil
  scrollCraftState.lastAction = t
  scrollCraftState.startedAt = t
  scrollCraftState.timeoutAt = t + math.max(90000, (#q * 18000) + 60000)
  scrollCraftState.releaseCavebotUntil = 0

  setTab("blank")
  return true
end

function stopScrollImbueBlank()
  finishScrollCrafting("[Scroll Imbue] Parado.", 8000)
end

function checkerScrollImbueBlank()
  if scrollCraftState.active then return "retry" end

  -- Quando der timeout/parar por segurança, libera o CaveBot para continuar.
  if nowMs() < (scrollCraftState.releaseCavebotUntil or 0) then
    return true
  end

  saveBlankRows()
  if #buildScrollCraftQueue() == 0 then
    return true
  end

  if startScrollImbueBlank() then
    return "retry"
  end

  return true
end

local function onScrollImbuementWindow(itemIdFromWindow, slots, activeSlots, windowImbuements, needItems)
  if not scrollCraftState.active then return end
  if not scrollCraftState.waitingWindow then return end
  if not scrollCraftState.current then return end

  local current = scrollCraftState.current
  if tonumber(itemIdFromWindow) ~= tonumber(current.blankId) then return end

  scrollCraftState.waitingWindow = false
  scrollCraftState.waitingApply = true
  scrollCraftState.lastAction = nowMs()

  local imbData = findImbueFromWindow(windowImbuements or {}, current.name)
  if not imbData then
    finishScrollCrafting("[Scroll Imbue] Imbue nao encontrado na janela: " .. current.name, 12000)
    return
  end

  current.beforeCount = tonumber(current.beforeCount or countItemInContainers(current.resultId)) or 0

  if not tryApplyImbuement(0, imbData) then
    finishScrollCrafting("[Scroll Imbue] Falha ao aplicar: " .. current.name, 12000)
    return
  end

  -- Depois de aplicar no scroll, fecha a janela do jogo.
  -- O proximo scroll SEMPRE sera feito reabrindo a shrine no blank scroll novamente.
  later(800, function()
    if scrollCraftState.active and scrollCraftState.waitingApply then
      closeImbuingWindowSafe()
    end
  end)

  later(1600, function()
    if scrollCraftState.active and scrollCraftState.waitingApply then
      closeImbuingWindowSafe()
    end
  end)

  local applyDeadline = nowMs() + 6500
  local function releaseAfterApply()
    if not scrollCraftState.active then return end
    if not scrollCraftState.waitingApply then return end

    closeImbuingWindowSafe()

    local currentAmount = countItemInContainers(current.resultId)
    local increased = currentAmount > (tonumber(current.beforeCount or 0) or 0)
    local expired = nowMs() >= applyDeadline

    -- Espera a backpack atualizar o novo scroll antes de tentar abrir a shrine de novo.
    -- Se a contagem nao atualizar por algum motivo, segue no deadline para nao travar.
    if not increased and not expired then
      later(500, releaseAfterApply)
      return
    end

    scrollCraftState.waitingApply = false
    scrollCraftState.current = nil
    scrollCraftState.currentBlank = nil
    scrollCraftState.lastAction = nowMs()
  end

  later(2600, releaseAfterApply)
end

if type(onImbuementWindow) == "function" then
  onImbuementWindow(onScrollImbuementWindow)
else
end

macro(200, function()
  if not scrollCraftState.active then return end

  local t = nowMs()

  if (scrollCraftState.timeoutAt or 0) > 0 and t > scrollCraftState.timeoutAt then
    finishScrollCrafting("[Scroll Imbue] Timeout de seguranca. Liberando CaveBot.", 12000)
    return
  end

  if scrollCraftState.waitingWindow and t - (scrollCraftState.lastAction or 0) > 18000 then
    finishScrollCrafting("[Scroll Imbue] Travou esperando abrir a janela. Liberando CaveBot.", 12000)
    return
  end

  if scrollCraftState.waitingApply and t - (scrollCraftState.lastAction or 0) > 18000 then
    finishScrollCrafting("[Scroll Imbue] Travou aplicando o imbue. Liberando CaveBot.", 12000)
    return
  end

  if t - (scrollCraftState.lastAction or 0) < 800 then return end
  if scrollCraftState.waitingWindow or scrollCraftState.waitingApply then return end

  if scrollCraftState.idx > #scrollCraftState.queue then
    finishScrollCrafting("[Scroll Imbue] Finalizado.")
    return
  end

  local data = scrollCraftState.queue[scrollCraftState.idx]
  scrollCraftState.idx = scrollCraftState.idx + 1

  -- Reconfere a quantidade antes de gastar outro blank scroll.
  -- Isso evita imbuir se voce ja tem a quantidade configurada na backpack aberta.
  local beforeCount = countItemInContainers(data.resultId)
  if beforeCount >= data.amount then
    scrollCraftState.lastAction = t
    return
  end
  data.beforeCount = beforeCount

  local blank = findItemInContainersById(data.blankId)
  if not blank then
    finishScrollCrafting("[Scroll Imbue] Acabou blank scroll ID " .. data.blankId .. ".", 12000)
    return
  end

  scrollCraftState.current = data
  scrollCraftState.currentBlank = blank
  scrollCraftState.waitingWindow = true
  scrollCraftState.lastAction = t

  if not openShrineOnBlankScroll(blank) then
    scrollCraftState.waitingWindow = false
    scrollCraftState.current = nil
    scrollCraftState.currentBlank = nil
    finishScrollCrafting("[Scroll Imbue] Nao consegui abrir a shrine no blank scroll.", 12000)
  end
end)


-- =========================================================
-- IMBUE ITEMS WITH READY SCROLLS ENGINE
-- =========================================================

db.itemAutoEnabled = db.itemAutoEnabled == true

local itemUseState = {
  active = false,
  queue = {},
  idx = 1,
  current = nil,
  recheck = nil,
  waitingLook = false,
  waitingApply = false,
  lastAction = 0,
  timeoutAt = 0,
  releaseCavebotUntil = 0,
  nextScanAt = 0
}

local EQUIP_SLOTS = {
  InventorySlotHead or 1,
  InventorySlotNeck or 2,
  InventorySlotBack or 3,
  InventorySlotBody or 4,
  InventorySlotRight or 5,
  InventorySlotLeft or 6,
  InventorySlotLeg or 7,
  InventorySlotFeet or 8,
  InventorySlotFinger or 9,
  InventorySlotAmmo or 10
}

local function getInventoryItemSafe(slot)
  if type(getInventoryItem) == "function" then
    local ok, item = pcall(function() return getInventoryItem(slot) end)
    if ok and item then return item end
  end

  if g_game and g_game.getLocalPlayer then
    local playerObj = g_game.getLocalPlayer()
    if playerObj and playerObj.getInventoryItem then
      local ok, item = pcall(function() return playerObj:getInventoryItem(slot) end)
      if ok and item then return item end
    end
  end

  return nil
end

local function findEquippedItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  for i = 1, #EQUIP_SLOTS do
    local item = getInventoryItemSafe(EQUIP_SLOTS[i])
    if item and item.getId and tonumber(item:getId()) == id then
      return item
    end
  end

  return nil
end

local function findTargetItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  local equipped = findEquippedItemById(id)
  if equipped then return equipped, "equip" end

  local inContainer = findItemInContainersById(id)
  if inContainer then return inContainer, "container" end

  return nil, nil
end

local function doLookItem(item)
  if not item then return false end

  if g_game and type(g_game.look) == "function" then
    local ok = pcall(function() g_game.look(item) end)
    if ok then return true end
  end

  if type(look) == "function" then
    local ok = pcall(function() look(item) end)
    if ok then return true end
  end

  return false
end


local itemLookSuppress = {
  active = false,
  untilTime = 0,
  lastClear = 0
}

local function startItemLookSuppress(ms)
  itemLookSuppress.active = true
  itemLookSuppress.untilTime = nowMs() + (tonumber(ms) or 1800)
end

local function stopItemLookSuppress()
  itemLookSuppress.active = false
  itemLookSuppress.untilTime = 0
end

local function isItemLookSuppressActive()
  if itemLookSuppress.active ~= true then return false end
  if nowMs() > (itemLookSuppress.untilTime or 0) then
    stopItemLookSuppress()
    return false
  end
  return true
end

local function clearItemLookMessage()
  local t = nowMs()
  if t - (itemLookSuppress.lastClear or 0) < 200 then return end
  itemLookSuppress.lastClear = t

  if modules and modules.game_textmessage and modules.game_textmessage.clearMessages then
    modules.game_textmessage.clearMessages()
  end
end

local function cleanLookImbueName(part)
  part = trim(part)
  part = part:gsub("^Basic%s+", "")
  part = part:gsub("^Intricate%s+", "")
  part = part:gsub("^Powerful%s+", "")
  part = part:gsub("%d+:%d+%s*[hH]", "")
  part = part:gsub("%d+%s*[hH]%s*%d+%s*[mM]", "")
  part = part:gsub("%d+%s*[hH]", "")
  return trim(part)
end

local function parseItemImbueLook(text)
  local info = {
    hasBlock = false,
    freeSlots = 0,
    active = {}
  }

  text = tostring(text or "")
  local block = text:match("Imbuements:%s*%((.-)%)")
  if not block or block == "" then return info end

  info.hasBlock = true

  for part in block:gmatch("([^,]+)") do
    part = trim(part)
    local lp = lower(part)

    local isFreeSlot =
      (lp:find("free", 1, true) and lp:find("slot", 1, true)) or
      (lp:find("empty", 1, true) and lp:find("slot", 1, true)) or
      (lp:find("available", 1, true) and lp:find("slot", 1, true)) or
      (lp:find("vazio", 1, true) and lp:find("slot", 1, true))

    if isFreeSlot then
      info.freeSlots = info.freeSlots + 1
    else
      local name = cleanLookImbueName(part)
      if name ~= "" then
        info.active[#info.active + 1] = name
      end
    end
  end

  return info
end

local function sameImbueName(activeName, desiredName)
  activeName = trim(activeName)
  desiredName = trim(desiredName)
  if activeName == "" or desiredName == "" then return false end

  if hasText(activeName, desiredName) or hasText(desiredName, activeName) then
    return true
  end

  local aliases = IMBUE_ALIASES[desiredName] or {desiredName}
  for i = 1, #aliases do
    local alias = aliases[i]
    if hasText(activeName, alias) or hasText(alias, activeName) then
      return true
    end
  end

  return false
end

local function itemAlreadyHasImbue(lookInfo, desiredName)
  if not lookInfo or type(lookInfo.active) ~= "table" then return false end

  for i = 1, #lookInfo.active do
    if sameImbueName(lookInfo.active[i], desiredName) then
      return true
    end
  end

  return false
end

local function resetItemUseState()
  stopItemLookSuppress()
  itemUseState.active = false
  itemUseState.queue = {}
  itemUseState.idx = 1
  itemUseState.current = nil
  itemUseState.recheck = nil
  itemUseState.waitingLook = false
  itemUseState.waitingApply = false
  itemUseState.lastAction = 0
  itemUseState.timeoutAt = 0
end

local function scheduleNextItemScan(ms)
  if db.itemAutoEnabled == true then
    itemUseState.nextScanAt = nowMs() + (tonumber(ms) or 30000)
  else
    itemUseState.nextScanAt = 0
  end
end

local function finishScrollItems(message, releaseCavebotMs)
  local keepNextScan = itemUseState.nextScanAt or 0
  resetItemUseState()
  itemUseState.nextScanAt = keepNextScan

  if releaseCavebotMs and releaseCavebotMs > 0 then
    itemUseState.releaseCavebotUntil = nowMs() + releaseCavebotMs
  end

  scheduleNextItemScan(30000)

  if message and message ~= "" then warn(message) end
end

local function buildScrollItemQueue()
  local q = {}

  for i = 1, #db.entries do
    local entry = db.entries[i]
    if entry and tonumber(entry.itemId or 0) > 0 and type(entry.scrollIds) == "table" and #entry.scrollIds > 0 then
      local target = findTargetItemById(entry.itemId)
      if target then
        q[#q + 1] = {
          uid = entry.uid,
          itemId = tonumber(entry.itemId),
          scrollIds = entry.scrollIds
        }
      end
    end
  end

  return q
end

local function requestLookForItem(data)
  local target, source = findTargetItemById(data.itemId)
  if not target then
    itemUseState.lastAction = nowMs()
    return false
  end

  data.source = source
  itemUseState.current = data
  itemUseState.waitingLook = true
  itemUseState.lastAction = nowMs()

  startItemLookSuppress(1800)

  if not doLookItem(target) then
    stopItemLookSuppress()
    itemUseState.waitingLook = false
    itemUseState.current = nil
    itemUseState.lastAction = nowMs()
    return false
  end

  return true
end

local function applyFirstMissingScrollFromLook(text)
  if not itemUseState.active then return end
  if not itemUseState.current then return end

  local data = itemUseState.current
  local lookInfo = parseItemImbueLook(text)

  itemUseState.waitingLook = false
  itemUseState.lastAction = nowMs()

  if not lookInfo.hasBlock then
    itemUseState.current = nil
    return
  end

  if lookInfo.freeSlots <= 0 then
    itemUseState.current = nil
    return
  end

  local target = findTargetItemById(data.itemId)
  if not target then
    itemUseState.current = nil
    return
  end

  for i = 1, #data.scrollIds do
    local scrollId = tonumber(data.scrollIds[i]) or 0
    local desiredName = scrollConfigNameById(scrollId)

    if desiredName == "" then
    elseif not itemAlreadyHasImbue(lookInfo, desiredName) then
      local scrollItem = findItemInContainersById(scrollId)

      if not scrollItem then
      else
        if useThingWithSafe(scrollItem, target) then
          itemUseState.waitingApply = true
          itemUseState.lastAction = nowMs()

          later(1800, function()
            if not itemUseState.active then return end
            if not itemUseState.waitingApply then return end

            itemUseState.waitingApply = false
            itemUseState.recheck = data
            itemUseState.current = nil
            itemUseState.lastAction = nowMs()
          end)

          return
        end
      end
    end
  end

  itemUseState.current = nil
end

function startScrollImbueItems(silent)
  if itemUseState.active then
    if not silent then end
    return false
  end

  if scrollCraftState.active then
    if not silent then end
    return false
  end

  if type(db.entries) ~= "table" or #db.entries == 0 then
    if not silent then end
    return false
  end

  local q = buildScrollItemQueue()
  if #q == 0 then
    if not silent then end
    return false
  end

  local t = nowMs()
  itemUseState.active = true
  itemUseState.queue = q
  itemUseState.idx = 1
  itemUseState.current = nil
  itemUseState.recheck = nil
  itemUseState.waitingLook = false
  itemUseState.waitingApply = false
  itemUseState.lastAction = t
  itemUseState.timeoutAt = t + math.max(90000, (#q * 12000) + 30000)
  itemUseState.releaseCavebotUntil = 0
  itemUseState.nextScanAt = 0

  setTab("items")
  if not silent then end
  return true
end

function stopScrollImbueItems()
  finishScrollItems("", 8000)
end

function checkerScrollImbueItems()
  if itemUseState.active then return "retry" end

  if nowMs() < (itemUseState.releaseCavebotUntil or 0) then
    return true
  end

  if db.itemAutoEnabled ~= true then
    return true
  end

  if startScrollImbueItems(true) then
    return "retry"
  end

  return true
end

local function handleItemLookText(text)
  if not itemUseState.active then return false end
  if not itemUseState.waitingLook then return false end
  if type(text) ~= "string" then return false end
  if not text:find("Imbuements:", 1, true) then return false end

  applyFirstMissingScrollFromLook(text)

  if isItemLookSuppressActive() then
    later(1, clearItemLookMessage)
    later(80, clearItemLookMessage)
  end

  stopItemLookSuppress()
  return true
end

if type(onTextMessage) == "function" then
  onTextMessage(function(mode, text)
    handleItemLookText(text)
  end)
else
end

-- Algumas builds exibem o look por displayStatusMessage em vez de disparar onTextMessage.
-- Esse hook deixa o recheck mais confiavel e ainda limpa a mensagem da tela.
if modules and modules.game_textmessage and modules.game_textmessage.displayStatusMessage then
  local oldItemStatusMessage = modules.game_textmessage.displayStatusMessage
  modules.game_textmessage.displayStatusMessage = function(text, color)
    if oldItemStatusMessage then
      oldItemStatusMessage(text, color)
    end
    handleItemLookText(text)
  end
end

macro(200, function()
  if not itemUseState.active then return end

  local t = nowMs()

  if (itemUseState.timeoutAt or 0) > 0 and t > itemUseState.timeoutAt then
    finishScrollItems("", 12000)
    return
  end

  if itemUseState.waitingLook and t - (itemUseState.lastAction or 0) > 4500 then
    stopItemLookSuppress()
    itemUseState.waitingLook = false
    itemUseState.current = nil
    itemUseState.lastAction = t
    return
  end

  if itemUseState.waitingApply and t - (itemUseState.lastAction or 0) > 6500 then
    itemUseState.waitingApply = false
    itemUseState.current = nil
    itemUseState.lastAction = t
    return
  end

  if t - (itemUseState.lastAction or 0) < 600 then return end
  if itemUseState.waitingLook or itemUseState.waitingApply then return end

  local data = nil

  if itemUseState.recheck then
    data = itemUseState.recheck
    itemUseState.recheck = nil
  else
    if itemUseState.idx > #itemUseState.queue then
      finishScrollItems("")
      return
    end

    data = itemUseState.queue[itemUseState.idx]
    itemUseState.idx = itemUseState.idx + 1
  end

  if data then
    requestLookForItem(data)
  end
end)

-- Recheca os itens a cada 30 segundos para atualizar os slots livres.
-- Nao depende do macro de 30000ms; usa timer interno para nao perder o ciclo.
macro(1000, function()
  if db.itemAutoEnabled ~= true then
    itemUseState.nextScanAt = 0
    return
  end

  if itemUseState.active then return end
  if scrollCraftState.active then return end

  local t = nowMs()
  if (itemUseState.nextScanAt or 0) <= 0 then
    itemUseState.nextScanAt = t + 30000
    return
  end

  if t < itemUseState.nextScanAt then return end

  if startScrollImbueItems(true) then
    itemUseState.nextScanAt = 0
  else
    itemUseState.nextScanAt = t + 30000
  end
end)

-- =========================================================
-- EXTERNAL ICON API
-- Os icones ficam no painel icons.lua. Esta script so expoe as funcoes.
-- =========================================================

function isScrollImbueBlankActive()
  return scrollCraftState.active == true
end

function toggleScrollImbueBlankIcon()
  if scrollCraftState.active then
    stopScrollImbueBlank()
    return false
  end

  return startScrollImbueBlank()
end

function isScrollImbueItemsEnabled()
  return db.itemAutoEnabled == true
end

function setScrollImbueItemsAuto(state)
  state = state == true

  if db.itemAutoEnabled == state then
    if state == true and not itemUseState.active then
      itemUseState.nextScanAt = 0
      if not startScrollImbueItems(true) then
        scheduleNextItemScan(30000)
      end
    end
    return true
  end

  db.itemAutoEnabled = state
  saveScrollImbue()

  if db.itemAutoEnabled == true then
    itemUseState.nextScanAt = 0
    if not startScrollImbueItems(false) then
      scheduleNextItemScan(30000)
    end
  else
    itemUseState.nextScanAt = 0
    finishScrollItems("", 8000)
  end

  return true
end

function toggleScrollImbueItemsAuto()
  return setScrollImbueItemsAuto(not (db.itemAutoEnabled == true))
end

function debugScrollImbueItems()
  if type(db.entries) ~= "table" or #db.entries == 0 then
    return
  end

  for i = 1, #db.entries do
    local entry = db.entries[i]
    local itemId = tonumber(entry and entry.itemId or 0) or 0
    local itemObj, source = findTargetItemById(itemId)

    if entry and type(entry.scrollIds) == "table" then
      for s = 1, #entry.scrollIds do
        local sid = tonumber(entry.scrollIds[s]) or 0
        local scrollObj = findItemInContainersById(sid)
      end
    end
  end
end
end

do
  setDefaultTab("Main")

-- ===============================
-- STORAGE CORE COMPARTILHADO
-- ===============================
if not loadCharStorage or not saveCharStorage then
  return print("[Market] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function saveImbuementsChar()
  saveCharStorage(charStorage)
end

local MARKET_STORAGE_KEY = "lns_buy_market_v2"
local DEPOT_IDS = { [3497]=true, [3498]=true, [3499]=true, [2594]=true }
local MARKET_ID = 12903
local MAIL_ID = 12902

-- =========================
-- BASE
-- =========================
local function deepCopy(t)
  if type(t) ~= "table" then return t end
  local r = {}
  for k, v in pairs(t) do r[k] = deepCopy(v) end
  return r
end

local function mergeDefaults(dst, def)
  if type(dst) ~= "table" then dst = {} end
  for k, v in pairs(def) do
    if dst[k] == nil then
      dst[k] = deepCopy(v)
    elseif type(v) == "table" and type(dst[k]) == "table" then
      dst[k] = mergeDefaults(dst[k], v)
    end
  end
  return dst
end

local function clamp(n, a, b)
  n = tonumber(n) or a
  if n < a then return a end
  if n > b then return b end
  return n
end

local function trim(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalize(s)
  return trim(tostring(s or ""):lower():gsub("%s+", " "))
end

local function ms()
  if g_clock and g_clock.millis then return g_clock.millis() end
  if g_clock and g_clock.seconds then return math.floor(g_clock.seconds() * 1000) end
  return os.time() * 1000
end

local function safeChildren(w)
  if not w or not w.getChildren then return {} end
  local ok, c = pcall(function() return w:getChildren() end)
  return ok and c or {}
end

local function clearChildren(w)
  local c = safeChildren(w)
  for i = #c, 1, -1 do
    local child = c[i]
    if child and not child:isDestroyed() then child:destroy() end
  end
end

local function safeText(w)
  if not w or not w.getText then return nil end
  local ok, t = pcall(function() return w:getText() end)
  return ok and t or nil
end

local function safeVisible(w)
  if not w then return false end
  if w.isVisible then
    local ok, v = pcall(function() return w:isVisible() end)
    if ok then return v end
  end
  if w.isHidden then
    local ok, h = pcall(function() return w:isHidden() end)
    if ok then return not h end
  end
  return true
end

local function safeEnabled(w)
  if not w then return false end
  if w.isEnabled then
    local ok, v = pcall(function() return w:isEnabled() end)
    if ok then return v end
  end
  return true
end

local function click(w)
  if not w then return false end
  if w.click and pcall(function() w:click() end) then return true end
  if w.onClick and pcall(function() w:onClick() end) then return true end
  pcall(function() w:onMousePress({x=5,y=5}, 1) end)
  if w.onMouseRelease and pcall(function() w:onMouseRelease({x=5,y=5}, 1) end) then return true end
  return false
end

local function focus(w)
  if w and w.focus then pcall(function() w:focus() end) end
end

local function setText(w, text)
  if not w or not w.setText then return false end
  return pcall(function() w:setText(text) end)
end

local function parseNumber(v)
  local n = tostring(v or ""):gsub("[^%d]", "")
  return n ~= "" and tonumber(n) or nil
end

local function rfind(w, id)
  if not w then return nil end
  if w.recursiveGetChildById then
    local ok, child = pcall(function() return w:recursiveGetChildById(id) end)
    if ok and child then return child end
  end
  for _, c in ipairs(safeChildren(w)) do
    local found = rfind(c, id)
    if found then return found end
  end
  return nil
end

local function getBotItemId(w)
  if not w then return 0 end
  if w.getItemId then return tonumber(w:getItemId()) or 0 end
  if w.getItem and w:getItem() and w:getItem().getId then
    return tonumber(w:getItem():getId()) or 0
  end
  return 0
end

local function setBotItemId(w, id)
  if not w then return end
  id = tonumber(id) or 0
  if w.setItemId then
    w:setItemId(id)
    return
  end
  if w.setItem and Item and Item.create and id > 0 then
    w:setItem(Item.create(id, 1))
  end
end

local function getWidgetItemId(widget)
  if not widget then return nil end

  if widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and item.getId then
      local ok2, id = pcall(function() return item:getId() end)
      if ok2 and id then return id end
    end
  end

  if widget.item and widget.item.getId then
    local ok, id = pcall(function() return widget.item:getId() end)
    if ok and id then return id end
  end

  if widget.getItemId then
    local ok, id = pcall(function() return widget:getItemId() end)
    if ok and id then return id end
  end

  return nil
end

local function findWidgetByItemId(widget, wantedId)
  if not widget then return nil end
  if getWidgetItemId(widget) == wantedId then return widget end
  for _, child in ipairs(safeChildren(widget)) do
    local found = findWidgetByItemId(child, wantedId)
    if found then return found end
  end
  return nil
end

local function posEq(a, b)
  return a and b and a.x == b.x and a.y == b.y and a.z == b.z
end

local function mapDist(a, b)
  return getDistanceBetween and getDistanceBetween(a, b) or math.abs(a.x - b.x) + math.abs(a.y - b.y)
end

local function topThing(tile)
  if not tile or not tile.getTopUseThing then return nil end
  local ok, thing = pcall(function() return tile:getTopUseThing() end)
  return ok and thing or nil
end

local function topId(tile)
  local thing = topThing(tile)
  if not thing or not thing.getId then return nil end
  local ok, id = pcall(function() return thing:getId() end)
  return ok and id or nil
end

local function hasOtherPlayer(tile)
  if not tile or not tile.getCreatures then return false end
  local ok, list = pcall(function() return tile:getCreatures() end)
  if not ok or not list then return false end
  local me = player:getName()
  for _, c in ipairs(list) do
    if c and c.isPlayer and c:isPlayer() and c:getName() ~= me then
      return true
    end
  end
  return false
end

local function canStand(pos)
  local tile = g_map.getTile(pos)
  -- Apagamos a checagem de outros players aqui:
  if not tile then return false end 
  if posEq(player:getPosition(), pos) then return true end
  if tile.isWalkable then
    local ok, v = pcall(function() return tile:isWalkable() end)
    return ok and v or false
  end
  return false
end

local function W(root, id)
  if not root then return nil end
  if root.recursiveGetChildById then return root:recursiveGetChildById(id) end
  if root.getChildById then return root:getChildById(id) end
  return nil
end

-- =========================
-- ITEM NAMES
-- =========================
local function safeRead(path)
  if not g_resources or not g_resources.readFileContents then
    return nil
  end
  local ok, content = pcall(function() return g_resources.readFileContents(path) end)
  if not ok or not content or content == "" then return nil end
  return content
end

local function loadLootItems()
  local cfgName = (type(MyConfigName) == "string" and MyConfigName ~= "" and MyConfigName) or "CUSTOM"
  local content =
    safeRead("/bot/" .. cfgName .. "/loot_items.lua") or
    safeRead("/bot/" .. cfgName .. "/loot_items") or
    safeRead("loot_items.lua")

  if not content then
    return {}
  end

  local list, seen = {}, {}
  for name, idStr in content:gmatch('%["(.-)"%]%s*=%s*(%d+)') do
    local id = tonumber(idStr)
    if id and not seen[id] then
      seen[id] = true
      list[#list + 1] = { name = tostring(name), id = id }
    end
  end

  table.sort(list, function(a, b) return (a.id or 0) < (b.id or 0) end)
  return list
end

local itemNameById = {}
for _, e in ipairs(loadLootItems()) do
  if e.id and e.name and e.name ~= "" then
    itemNameById[e.id] = e.name
  end
end

local function getItemDisplayName(itemId)
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return "Unknown Item" end
  return itemNameById[itemId] or ("Item ID " .. itemId)
end

-- =========================
-- STORAGE
-- =========================
local function defaultMarketCfg()
  return {
    list = {},
    draft = {
      itemId = 0,
      name = "",
      amount = 1,
      maxPrice = 1
    }
  }
end

charStorage[MARKET_STORAGE_KEY] = mergeDefaults(charStorage[MARKET_STORAGE_KEY], defaultMarketCfg())
local marketCfg = charStorage[MARKET_STORAGE_KEY]
if type(marketCfg.list) ~= "table" then marketCfg.list = {} end
marketCfg.draft = marketCfg.draft or { itemId = 0, name = "", amount = 1, maxPrice = 1 }

saveImbuementsChar()

marketInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 380 320
  anchors.centerIn: parent
  margin-top: -50
  text: Panel Buy Market
  opacity: 1.00

  UIButton
    id: clickHere
    anchors.top: parent.top
    anchors.left: parent.left
    text: Click Here
    margin-top: 0
    margin-left: 65
    color: #FFD700
    font: verdana-11px-rounded
    text-auto-resize: true
    opacity: 1.00
    $hover:
      opacity: 0.80

  Label
    id: labelClick
    anchors.verticalCenter: clickHere.verticalCenter
    anchors.left: clickHere.right
    margin-left: 5
    text: to manager buy market
    text-auto-resize: true
    font: verdana-11px-rounded

  TextList
    id: marketList
    anchors.top: clickHere.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin: -5
    margin-top: 5
    margin-right: 6
    margin-bottom: 20
    vertical-scrollbar: marketListScrollBar

  VerticalScrollBar
    id: marketListScrollBar
    anchors.top: marketList.top
    anchors.bottom: marketList.bottom
    anchors.left: marketList.right
    step: 10
    pixels-scroll: true

  Button
    id: closePanel
    anchors.left: marketList.left
    anchors.right: marketListScrollBar.right
    anchors.top: marketList.bottom
    margin-top: 5
    text: Close
]=], g_ui.getRootWidget())
marketInterface:hide()

marketAdd = setupUI([=[
MainWindow
  id: mainPanel
  size: 300 125
  anchors.centerIn: parent
  margin-top: -60
  opacity: 1.00
  text: Insert Item to Buy Market

  Panel
    anchors.fill: parent
    margin-top: 0
    opacity: 0.88

  FlatPanel
    id: topBar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: -2
    image-border: 1

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: " #           Quantify          Max Price"
      text-auto-resize: true
      font: verdana-11px-rounded
      margin-top: 2

    HorizontalSeparator
      id: sepp
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-left: 2
      margin-top: 1
      margin-right: 2

  BotItem
    id: itemMarket
    anchors.top: topBar.top
    anchors.left: parent.left
    margin-top: 25
    margin-left: 15

  SpinBox
    id: amount
    anchors.verticalCenter: itemMarket.verticalCenter
    anchors.left: itemMarket.right
    width: 90
    margin-left: 18
    text-align: center
    minimum: 1
    maximum: 1000000000
    step: 1
    editable: true
    focusable: true

  SpinBox
    id: maxprice
    anchors.verticalCenter: itemMarket.verticalCenter
    anchors.left: amount.right
    width: 90
    margin-left: 15
    text-align: center
    minimum: 1
    maximum: 1000000000
    step: 1
    editable: true
    focusable: true

  Button
    id: cancelarBt
    anchors.left: topBar.left
    anchors.top: topBar.bottom
    size: 125 20
    margin-top: 5
    text: Cancel

  Button
    id: adicionarBt
    anchors.right: topBar.right
    anchors.top: cancelarBt.top
    size: 125 20
    text: Insert
]=], g_ui.getRootWidget())
marketAdd:hide()

local marketList = W(marketInterface, "marketList")
local marketClose = W(marketInterface, "closePanel")
local marketClickHere = W(marketInterface, "clickHere")

local addItemBot = W(marketAdd, "itemMarket")
local addAmount = W(marketAdd, "amount")
local addMaxPrice = W(marketAdd, "maxprice")
local addCancel = W(marketAdd, "cancelarBt")
local addConfirm = W(marketAdd, "adicionarBt")

local editingIndex = nil

local rowTemplate = [[
UIWidget
  id: root
  height: 40
  focusable: true
  background-color: alpha

  $hover:
    background-color: #2F2F2F
    opacity: 0.80

  $focus:
    background-color: #404040
    opacity: 0.90

  CheckBox
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    width: 14
    height: 14
    margin-left: 4
    image-source: /images/ui/checkbox_round

  UIItem
    id: icon
    anchors.left: enabled.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    size: 38 38

  Label
    id: itemName
    anchors.left: icon.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    font: verdana-9px
    color: white

  Label
    id: amountText
    anchors.left: itemName.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    font: verdana-9px
    color: white
    text-auto-resize: true

  Label
    id: priceText
    anchors.left: amountText.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    font: verdana-9px
    color: white
    text-auto-resize: true

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 3
    text: X
    color: #FF4040
    image-color: #363636
    image-source: /images/ui/button_rounded
]]

local function resetDraft()
  editingIndex = nil
  marketCfg.draft.itemId = 0
  marketCfg.draft.name = ""
  marketCfg.draft.amount = 1
  marketCfg.draft.maxPrice = 1
  if addItemBot then setBotItemId(addItemBot, 0) end
  if addAmount then addAmount:setValue(1) end
  if addMaxPrice then addMaxPrice:setValue(1) end
  saveImbuementsChar()
end

local function loadDraft()
  if addItemBot then setBotItemId(addItemBot, marketCfg.draft.itemId or 0) end
  if addAmount then addAmount:setValue(clamp(marketCfg.draft.amount or 1, 1, 1000000000)) end
  if addMaxPrice then addMaxPrice:setValue(clamp(marketCfg.draft.maxPrice or 1, 1, 1000000000)) end
end

local function refreshMarketList()
  if not marketList then return end
  clearChildren(marketList)

  for i, entry in ipairs(marketCfg.list) do
    entry.enabled = (entry.enabled ~= false)
    entry.itemId = tonumber(entry.itemId or 0) or 0
    entry.name = tostring(entry.name or getItemDisplayName(entry.itemId))
    entry.amount = clamp(entry.amount or 1, 1, 1000000000)
    entry.maxPrice = clamp(entry.maxPrice or 1, 1, 1000000000)

    local row = setupUI(rowTemplate, marketList)
    row.entryIndex = i
    row.enabled:setChecked(entry.enabled)

    row.enabled.onClick = function()
      entry.enabled = not entry.enabled
      row.enabled:setChecked(entry.enabled)
      saveImbuementsChar()
    end

    if row.icon and row.icon.setItemId then
      row.icon:setItemId(entry.itemId)
    elseif row.icon and row.icon.setItem and Item and Item.create and entry.itemId > 0 then
      row.icon:setItem(Item.create(entry.itemId, 1))
    end

    row.itemName:setText("[" .. string.upper(entry.name):sub(1, 12) .. "]")
    row.amountText:setText("[AMOUNT: " .. tostring(entry.amount) .. "]")
    row.priceText:setText("[MAX PRICE: " .. tostring(entry.maxPrice) .. "]")

    row.remove.onClick = function()
      table.remove(marketCfg.list, row.entryIndex)
      if editingIndex == row.entryIndex then editingIndex = nil end
      refreshMarketList()
      saveImbuementsChar()
    end

    row.onClick = function(widget)
      if marketList.focusChild then marketList:focusChild(widget) end
    end

    row.onDoubleClick = function(widget)
      local idx = widget.entryIndex
      local e = marketCfg.list[idx]
      if not e then return end

      editingIndex = idx
      marketCfg.draft.itemId = tonumber(e.itemId or 0) or 0
      marketCfg.draft.name = tostring(e.name or getItemDisplayName(e.itemId))
      marketCfg.draft.amount = clamp(e.amount or 1, 1, 1000000000)
      marketCfg.draft.maxPrice = clamp(e.maxPrice or 1, 1, 1000000000)

      loadDraft()
      marketInterface:hide()
      marketAdd:show()
      marketAdd:raise()
      marketAdd:focus()
    end
  end
end

if addItemBot and addItemBot.onItemChange then
  addItemBot.onItemChange = function(widget)
    local itemId = getBotItemId(widget)
    marketCfg.draft.itemId = itemId
    marketCfg.draft.name = getItemDisplayName(itemId)
    saveImbuementsChar()
  end
end

if addAmount then
  addAmount.onValueChange = function(widget, value)
    local v = tonumber(value)
    if not v and widget.getValue then v = tonumber(widget:getValue()) end
    marketCfg.draft.amount = clamp(v or 1, 1, 1000000000)
    saveImbuementsChar()
  end
end

if addMaxPrice then
  addMaxPrice.onValueChange = function(widget, value)
    local v = tonumber(value)
    if not v and widget.getValue then v = tonumber(widget:getValue()) end
    marketCfg.draft.maxPrice = clamp(v or 1, 1, 1000000000)
    saveImbuementsChar()
  end
end

if marketClickHere then
  marketClickHere.onClick = function()
    editingIndex = nil
    loadDraft()
    marketInterface:hide()
    marketAdd:show()
    marketAdd:raise()
    marketAdd:focus()
  end
end

if marketClose then
  marketClose.onClick = function()
    marketInterface:hide()
  end
end

if addCancel then
  addCancel.onClick = function()
    marketAdd:hide()
    marketInterface:show()
    marketInterface:raise()
    marketInterface:focus()
    resetDraft()
    saveImbuementsChar()
  end
end

if addConfirm then
  addConfirm.onClick = function()
    local itemId = getBotItemId(addItemBot)
    local amount = clamp(addAmount and addAmount:getValue() or 1, 1, 1000000000)
    local maxPrice = clamp(addMaxPrice and addMaxPrice:getValue() or 1, 1, 1000000000)

    if itemId <= 0 then
      return
    end

    local resolvedName = getItemDisplayName(itemId)
    if editingIndex and marketCfg.list[editingIndex] and resolvedName:find("^Item ID ") then
      resolvedName = tostring(marketCfg.list[editingIndex].name or resolvedName)
    end

    local entry = {
      enabled = true,
      itemId = itemId,
      name = resolvedName,
      amount = amount,
      maxPrice = maxPrice
    }

    if editingIndex and marketCfg.list[editingIndex] then
      entry.enabled = (marketCfg.list[editingIndex].enabled ~= false)
      marketCfg.list[editingIndex] = entry
    else
      table.insert(marketCfg.list, entry)
    end

    refreshMarketList()
    resetDraft()
    saveImbuementsChar()

    marketAdd:hide()
    marketInterface:show()
    marketInterface:raise()
    marketInterface:focus()
  end
end

loadDraft()
refreshMarketList()

-- =========================
-- MARKET UI
-- =========================
local function getMarketUI()
  if not rootWidget or not rootWidget.recursiveGetChildById then return nil end
  local m = rootWidget:recursiveGetChildById("marketWindow")
  if not m then return nil end
  return {
    market = m,
    searchEdit = m:recursiveGetChildById("searchEdit"),
    filterSearchAll = m:recursiveGetChildById("filterSearchAll"),
    itemsPanel = m:recursiveGetChildById("itemsPanel"),
    sellingTable = m:recursiveGetChildById("sellingTable"),
    sellingTableData = m:recursiveGetChildById("sellingTableData"),
    buyButton = m:recursiveGetChildById("buyButton"),
  }
end

local function closeMarketWindow()
  if modules and modules.game_market and modules.game_market.hide then
    local ok = pcall(function() modules.game_market.hide() end)
    if ok then return true end
  end

  local ui = getMarketUI()
  if not ui or not ui.market then return false end

  local closeBtn =
    ui.market:recursiveGetChildById("closeButton") or
    ui.market:recursiveGetChildById("closePanel") or
    ui.market:recursiveGetChildById("closeButtonTop")

  if closeBtn and click(closeBtn) then return true end
  if ui.market.hide then
    local ok = pcall(function() ui.market:hide() end)
    if ok then return true end
  end
  return false
end

local function marketReady()
  local ui = getMarketUI()
  if not ui or not ui.market then return nil end
  if ui.market.isHidden then
    local ok, hidden = pcall(function() return ui.market:isHidden() end)
    if ok and hidden then return nil end
  end
  return ui
end

local function setSearchAll(ui)
  local btn = ui and ui.filterSearchAll
  if not btn then return end
  if btn.isChecked then
    local ok, checked = pcall(function() return btn:isChecked() end)
    if ok and checked then return end
  end
  if btn.setChecked then pcall(function() btn:setChecked(true) end) end
  click(btn)
end

local function collectItemBoxes(w, out)
  out = out or {}
  if not w then return out end

  local ok, hasItem = pcall(function()
    return w.item and w.item.marketData and w.item.marketData.name
  end)

  if ok and hasItem and safeVisible(w) then
    out[#out + 1] = w
  end

  for _, c in ipairs(safeChildren(w)) do
    collectItemBoxes(c, out)
  end
  return out
end

local function findItemBox(itemsPanel, itemName)
  local wanted = normalize(itemName)
  for _, box in ipairs(collectItemBoxes(itemsPanel, {})) do
    local ok, name = pcall(function() return tostring(box.item.marketData.name) end)
    if ok and normalize(name) == wanted then return box end
  end
  return nil
end

local function selectItemBox(box)
  if not box then return false end
  if box.setChecked then pcall(function() box:setChecked(true) end) end
  if box.onCheckChange and pcall(function() box:onCheckChange(true) end) then return true end
  return click(box)
end

local function rowLooksLikeOffer(row)
  if not row or not safeVisible(row) or row.ref == nil then return false end
  local ch = safeChildren(row)
  if #ch < 4 then return false end
  for i = 1, #ch do
    local t = safeText(ch[i])
    if t and t ~= "" then return true end
  end
  return false
end

local function collectOfferRows(w, out)
  out = out or {}
  if not w then return out end
  for _, c in ipairs(safeChildren(w)) do
    if rowLooksLikeOffer(c) then
      out[#out + 1] = c
    else
      collectOfferRows(c, out)
    end
  end
  return out
end

local function firstSellRow(ui)
  local base = ui and (ui.sellingTableData or ui.sellingTable)
  local rows = collectOfferRows(base, {})
  return rows[1]
end

local function getPiecePrice(row)
  local ch = safeChildren(row)
  if #ch < 4 then return nil end
  local v3 = parseNumber(safeText(ch[3]))
  local v4 = parseNumber(safeText(ch[4]))
  if v3 and v4 then return math.min(v3, v4) end
  return v3 or v4
end

local function deepClick(row)
  if click(row) then return true end
  for _, c in ipairs(safeChildren(row)) do
    if click(c) then return true end
  end
  return false
end

local function selectOffer(ui, row)
  if not ui or not ui.sellingTable or not row or row.ref == nil then return false end

  focus(ui.sellingTable)
  focus(row)

  pcall(function() row:setChecked(true) end)
  pcall(function() row:setOn(true) end)
  pcall(function() row:setSelected(true) end)

  deepClick(row)

  if type(ui.sellingTable.onSelectionChange) == "function" then
    pcall(function() ui.sellingTable.onSelectionChange(ui.sellingTable, row, nil) end)
  end

  deepClick(row)

  if ui.buyButton and safeEnabled(ui.buyButton) then return true end

  if row.isChecked then
    local ok, v = pcall(function() return row:isChecked() end)
    if ok and v then return true end
  end
  if row.isOn then
    local ok, v = pcall(function() return row:isOn() end)
    if ok and v then return true end
  end
  if row.isSelected then
    local ok, v = pcall(function() return row:isSelected() end)
    if ok and v then return true end
  end

  return false
end

local function findAmountPopup()
  if not rootWidget then return nil end
  local sb = rootWidget:recursiveGetChildById("amountScrollBar")
  if not sb then return nil end
  if sb.getParent then
    local ok, p = pcall(function() return sb:getParent() end)
    if ok then return p end
  end
  return nil
end

local function setPopupAmount(popup, amount)
  local sb = rfind(popup, "amountScrollBar")
  if not sb or not sb.setValue then return false end
  return pcall(function() sb:setValue(amount) end)
end

local function getPopupAmount(popup)
  local sb = rfind(popup, "amountScrollBar")
  if not sb or not sb.getValue then return nil end
  local ok, v = pcall(function() return sb:getValue() end)
  return ok and tonumber(v) or nil
end

local function popupConfirm(popup)
  return click(rfind(popup, "buttonOk"))
end

local function popupCancel(popup)
  return click(rfind(popup, "buttonCancel"))
end

-- =========================
-- INVENTORY / MAIL
-- =========================
local function getAllContainers()
  if g_game and g_game.getContainers then
    local ok, containers = pcall(function() return g_game:getContainers() end)
    if ok and containers then return containers end
  end
  return {}
end

local function getContainerName(container)
  if not container or not container.getName then return "" end
  local ok, name = pcall(function() return tostring(container:getName() or "") end)
  return ok and name or ""
end

local function getContainerItems(container)
  if not container or not container.getItems then return {} end
  local ok, items = pcall(function() return container:getItems() end)
  return ok and items or {}
end

local function isBlockedContainerName(name)
  name = normalize(name)
  return name:find("your inbox", 1, true)
      or name:find("inbox", 1, true)
      or name:find("locker", 1, true)
      or name:find("depot", 1, true)
end

local function findMailContainer()
  for _, c in pairs(getAllContainers()) do
    if normalize(getContainerName(c)):find("inbox", 1, true) then
      return c
    end
  end
  return nil
end

local function getAnyOpenLootContainer()
  for _, c in pairs(getAllContainers()) do
    if not isBlockedContainerName(getContainerName(c)) then
      return c
    end
  end
  return nil
end

local function ensureLootContainerOpen()
  if getAnyOpenLootContainer() then return true end

  local playerObj = g_game.getLocalPlayer()
  if not playerObj or not playerObj.getInventoryItem or not InventorySlotFirst or not InventorySlotLast then
    return false
  end

  for slot = InventorySlotFirst, InventorySlotLast do
    local ok, item = pcall(function() return playerObj:getInventoryItem(slot) end)
    if ok and item then
      local idOk, itemId = pcall(function() return item:getId() end)
      if idOk and itemId and itemId > 0 then
        pcall(function() g_game.open(item) end)
      end
    end
  end

  schedule(150, function() end)
  return getAnyOpenLootContainer() ~= nil
end

local function getContainerDropPosition(container)
  if not container then return nil end

  if container.getItemsCount and container.getSlotPosition then
    local okCount, itemsCount = pcall(function() return container:getItemsCount() end)
    if okCount and tonumber(itemsCount) then
      local okPos, pos = pcall(function() return container:getSlotPosition(itemsCount) end)
      if okPos and pos then return pos end
    end
  end

  if container.getSlotPosition then
    local okPos, pos = pcall(function() return container:getSlotPosition(0) end)
    if okPos and pos then return pos end
  end

  return nil
end

local function moveItemToContainer(item, count, container)
  if not item or not container or not g_game or not g_game.move then return false end
  local pos = getContainerDropPosition(container)
  if not pos then return false end
  count = tonumber(count) or 1
  return pcall(function() g_game.move(item, pos, count) end)
end

local function getItemStackCount(item)
  if not item then return 0 end
  if item.getCount then
    local ok, c = pcall(function() return item:getCount() end)
    if ok and tonumber(c) then
      c = tonumber(c)
      if c > 1 then return c end
    end
  end
  return 1
end

local function countItemOpenContainersAndInventory(itemId)
  local total = 0
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return 0 end

  local playerObj = g_game.getLocalPlayer()
  if playerObj and playerObj.getInventoryItem and InventorySlotFirst and InventorySlotLast then
    for slot = InventorySlotFirst, InventorySlotLast do
      local ok, item = pcall(function() return playerObj:getInventoryItem(slot) end)
      if ok and item and item.getId then
        local ok2, id = pcall(function() return item:getId() end)
        if ok2 and tonumber(id) == itemId then
          total = total + getItemStackCount(item)
        end
      end
    end
  end

  for _, container in pairs(getAllContainers()) do
    for _, item in ipairs(getContainerItems(container)) do
      if item and item.getId then
        local ok3, id = pcall(function() return item:getId() end)
        if ok3 and tonumber(id) == itemId then
          total = total + getItemStackCount(item)
        end
      end
    end
  end

  return total
end

local function getOwnedAmount(itemId)
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return 0 end

  if type(itemAmount) == "function" then
    local ok, amount = pcall(function() return itemAmount(itemId) end)
    if ok and tonumber(amount) then
      return math.max(0, tonumber(amount))
    end
  end

  return countItemOpenContainersAndInventory(itemId)
end

local function buildAllowedMailItemOrder()
  local list, seen = {}, {}
  for _, entry in ipairs(marketCfg.list or {}) do
    if entry.enabled ~= false then
      local id = tonumber(entry.itemId or 0) or 0
      if id > 0 and not seen[id] then
        seen[id] = true
        list[#list + 1] = id
      end
    end
  end
  return list
end

local function findFirstAllowedItemInMailById(mail, wantedId)
  wantedId = tonumber(wantedId) or 0
  if wantedId <= 0 then return nil end

  for _, item in ipairs(getContainerItems(mail)) do
    if item and item.getId then
      local ok, id = pcall(function() return item:getId() end)
      id = ok and tonumber(id) or 0
      if id == wantedId then
        return item
      end
    end
  end

  return nil
end

local function collectAllowedMailItems(targetItemId)
  local mail = findMailContainer()
  if not mail then return "error", "mail container nao encontrado" end

  local dest = getAnyOpenLootContainer()
  if not dest then
    local opened = ensureLootContainerOpen()
    if opened then
      return "ensure_loot", nil
    end
    return "error", "nenhum container aberto"
  end

  local targetId = tonumber(targetItemId) or 0
  if targetId <= 0 then
    return "done_item", nil
  end

  local item = findFirstAllowedItemInMailById(mail, targetId)
  if not item then
    return "done_item", nil
  end

  local count = getItemStackCount(item)
  if moveItemToContainer(item, count, dest) then
    return "moved", nil, targetId, count
  end

  return "move_failed", "falha ao mover item id " .. tostring(targetId), targetId, count
end

-- =========================
-- DEPOT / LOCKER
-- =========================
local function bestDepot(range)
  local me = g_game.getLocalPlayer()
  if not me then return nil end
  local p = me:getPosition()
  if not p then return nil end

  local best
  local fallbackCurrent
  local offs = {{0,1},{0,-1},{1,0},{-1,0},{1,1},{-1,1},{1,-1},{-1,-1}}

  for x = -range, range do
    for y = -range, range do
      local dp = {x = p.x + x, y = p.y + y, z = p.z}
      local tile = g_map.getTile(dp)

      if tile and DEPOT_IDS[topId(tile)] then
        local foundStand = false

        for i = 1, #offs do
          local sp = {x = dp.x + offs[i][1], y = dp.y + offs[i][2], z = dp.z}
          if canStand(sp) then
            foundStand = true
            local d = mapDist(p, sp)
            if not best or d < best.d then
              best = { d = d, stand = sp, depot = dp }
            end
          end
        end

        -- fallback especial:
        -- se eu já estou colado no depot, aceita usar da posição atual
        if not foundStand and mapDist(p, dp) <= 1 then
          local d = mapDist(p, dp)
          if not fallbackCurrent or d < fallbackCurrent.d then
            fallbackCurrent = { d = d, stand = p, depot = dp }
          end
        end
      end
    end
  end

  return best or fallbackCurrent
end

local function useDepotAt(pos)
  local tile = g_map.getTile(pos)
  local thing = tile and topThing(tile)
  if not thing then return false end
  local id = topId(tile)
  if not id or not DEPOT_IDS[id] then return false end
  return pcall(function() g_game.use(thing) end)
end

local function useMarketFromLocker()
  if not rootWidget then return false end
  local widget = findWidgetByItemId(rootWidget, MARKET_ID)
  if not widget then return false end

  if widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and pcall(function() g_game.use(item) end) then return true end
  end

  if widget.item and pcall(function() g_game.use(widget.item) end) then return true end
  return click(widget)
end

local function useMailFromLocker()
  if not rootWidget then return false end
  local widget = findWidgetByItemId(rootWidget, MAIL_ID)
  if not widget then return false end

  if widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and pcall(function() g_game.use(item) end) then return true end
  end

  if widget.item and pcall(function() g_game.use(widget.item) end) then return true end
  return click(widget)
end

-- =========================
-- TASKS
-- =========================
local function buildMarketBuyListFromPanel()
  local list = {}
  for _, entry in ipairs(marketCfg.list or {}) do
    if entry.enabled ~= false then
      local itemId = tonumber(entry.itemId or 0) or 0
      local amount = tonumber(entry.amount or 0) or 0
      local maxPrice = tonumber(entry.maxPrice or 0) or 0
      local name = trim(entry.name or getItemDisplayName(itemId) or "")

      if itemId > 0 and amount > 0 and maxPrice > 0 and name ~= "" then
        list[#list + 1] = {
          itemId = itemId,
          name = name,
          amount = amount,
          maxPrice = maxPrice,
          baseOwned = nil
        }
      end
    end
  end
  return list
end

-- =========================
-- ENGINE
-- =========================
local autoBuyStep

local autoBuy = {
  running = false,
  step = "idle",
  nextAt = 0,

  tick = 50,

  waitSearch = 250,
  waitItem = 200,
  waitOffer = 180,
  waitBuy = 220,
  waitPopup = 180,

  maxSearch = 7,
  maxItem = 8,
  maxOffer = 5,
  maxSelect = 7,
  maxPopup = 7,

  retryItemMs = 200,
  closePopupOnFail = false,

  depotTarget = nil,
  depotPos = nil,
  depotTries = 0,
  openTries = 0,
  mailTries = 0,
  collectTries = 0,
  ensureLootTries = 0,

  mailItemOrder = {},
  mailItemIndex = 1,
  mailItemRetries = {},

  tasks = {},
  idx = 1,
  bought = {},
  tries = { search = 0, item = 0, offer = 0, select = 0, popup = 0 },
  row = nil
}

local lastLog = { msg = nil, at = 0 }
local function log(msg)
  msg = tostring(msg)
  local now = ms()
  if lastLog.msg == msg and now - lastLog.at < 1500 then return end
  lastLog.msg, lastLog.at = msg, now
  print("[AutoBuyMarket] " .. msg)
end

local function stopAutoBuy()
  autoBuy.running = false
  autoBuy.step = "idle"
  autoBuy.nextAt = 0
  autoBuy.depotTarget = nil
  autoBuy.depotPos = nil
  autoBuy.depotTries = 0
  autoBuy.openTries = 0
  autoBuy.mailTries = 0
  autoBuy.collectTries = 0
  autoBuy.ensureLootTries = 0
  autoBuy.mailItemOrder = {}
  autoBuy.mailItemIndex = 1
  autoBuy.mailItemRetries = {}
  autoBuy.tasks = {}
  autoBuy.idx = 1
  autoBuy.bought = {}
  autoBuy.tries = { search = 0, item = 0, offer = 0, select = 0, popup = 0 }
  autoBuy.row = nil

  if CaveBot and CaveBot.setOn then
    pcall(function() CaveBot.setOn() end)
  end
end

local function scheduleAutoBuy(delayMs)
  delayMs = math.max(1, tonumber(delayMs) or autoBuy.tick)
  autoBuy.nextAt = ms() + delayMs
  schedule(delayMs, function()
    if autoBuy.running then autoBuyStep() end
  end)
end

local function autoCurrentTask()
  return autoBuy.tasks[autoBuy.idx]
end

local function autoBoughtCount(itemId)
  return tonumber(autoBuy.bought[tonumber(itemId) or 0] or 0) or 0
end

local function autoAddBought(itemId, amount)
  itemId = tonumber(itemId) or 0
  autoBuy.bought[itemId] = autoBoughtCount(itemId) + (tonumber(amount) or 0)
end

local function autoRemaining(task)
  if not task then return 0 end

  if task.baseOwned == nil then
    task.baseOwned = getOwnedAmount(task.itemId)
    log(string.format("%s: possui %d, alvo %d, falta %d",
      tostring(task.name),
      tonumber(task.baseOwned) or 0,
      tonumber(task.amount) or 0,
      math.max(0, (tonumber(task.amount) or 0) - (tonumber(task.baseOwned) or 0))
    ))
  end

  return math.max(0, (tonumber(task.amount) or 0) - ((tonumber(task.baseOwned) or 0) + autoBoughtCount(task.itemId)))
end

local function autoResetTries()
  autoBuy.tries = { search = 0, item = 0, offer = 0, select = 0, popup = 0 }
  autoBuy.row = nil
end

local function autoNextTask()
  autoBuy.idx = autoBuy.idx + 1
  autoBuy.step = "buyer_idle"
  autoResetTries()
end

local function autoRetryItem(delayMs)
  autoBuy.step = "buyer_search"
  autoResetTries()
  scheduleAutoBuy(delayMs or autoBuy.retryItemMs)
end

local function autoCurrentMailItemId()
  return tonumber(autoBuy.mailItemOrder[autoBuy.mailItemIndex] or 0) or 0
end

local function autoNextMailItem()
  autoBuy.mailItemIndex = autoBuy.mailItemIndex + 1
  autoBuy.ensureLootTries = 0
end

autoBuyStep = function()
  if not autoBuy.running then return end

  local now = ms()
  if now < autoBuy.nextAt then
    scheduleAutoBuy(autoBuy.nextAt - now)
    return
  end

  -- DEPOT
  if autoBuy.step == "go_depot" then
    local found = bestDepot(7)
    if not found then
      stopAutoBuy()
      return
    end

    autoBuy.depotTarget = found.stand
    autoBuy.depotPos = found.depot
    autoBuy.depotTries = 0
    autoBuy.step = "walking_depot"
    scheduleAutoBuy(50)
    return
  end

  if autoBuy.step == "walking_depot" then
    local myPos = player:getPosition()
    if not myPos or not autoBuy.depotTarget or not autoBuy.depotPos then
      stopAutoBuy()
      return
    end

    if mapDist(myPos, autoBuy.depotPos) <= 1 then
      autoBuy.step = "use_depot"
      scheduleAutoBuy(50)
      return
    end

    autoBuy.depotTries = autoBuy.depotTries + 1
    if autoBuy.depotTries > 40 then
      stopAutoBuy()
      return
    end

    autoWalk(autoBuy.depotTarget, 500, {ignoreNonPathable = true, precision = 1})
    scheduleAutoBuy(1500)
    return
  end

  if autoBuy.step == "use_depot" then
    if useDepotAt(autoBuy.depotPos) then
      autoBuy.openTries = 0
      autoBuy.step = "open_market"
      scheduleAutoBuy(700)
      return
    end

    stopAutoBuy()
    return
  end

  if autoBuy.step == "open_market" then
    autoBuy.openTries = autoBuy.openTries + 1
    if autoBuy.openTries > 10 then
      stopAutoBuy()
      return
    end

    if useMarketFromLocker() then
      autoBuy.tasks = buildMarketBuyListFromPanel()

      if #autoBuy.tasks == 0 then
        closeMarketWindow()
        stopAutoBuy()
        return
      end

      autoBuy.idx = 1
      autoBuy.bought = {}
      autoBuy.step = "buyer_idle"
      autoResetTries()
      scheduleAutoBuy(900)
      return
    end

    scheduleAutoBuy(300)
    return
  end

  -- MAIL
  if autoBuy.step == "open_mail" then
    autoBuy.mailTries = autoBuy.mailTries + 1
    if autoBuy.mailTries > 10 then
      pcall(function() rootWidget:focus() end)
      stopAutoBuy()
      return
    end

    if useMailFromLocker() then
      autoBuy.collectTries = 0
      autoBuy.ensureLootTries = 0
      autoBuy.mailItemOrder = buildAllowedMailItemOrder()
      autoBuy.mailItemIndex = 1
      autoBuy.mailItemRetries = {}
      autoBuy.step = "collect_mail"
      scheduleAutoBuy(700)
      return
    end

    scheduleAutoBuy(300)
    return
  end

  if autoBuy.step == "collect_mail" then
    autoBuy.collectTries = autoBuy.collectTries + 1

    local targetId = autoCurrentMailItemId()
    if targetId <= 0 then
      pcall(function() rootWidget:focus() end)
      stopAutoBuy()
      return
    end

    local tries = tonumber(autoBuy.mailItemRetries[targetId] or 0) or 0
    local status, err, movedId, movedCount = collectAllowedMailItems(targetId)

    if status == "moved" then
      autoBuy.ensureLootTries = 0
      autoBuy.mailItemRetries[targetId] = 0
      scheduleAutoBuy(350)
      return
    end

    if status == "done_item" then
      autoBuy.mailItemRetries[targetId] = 0
      autoNextMailItem()
      scheduleAutoBuy(120)
      return
    end

    if status == "ensure_loot" then
      autoBuy.ensureLootTries = autoBuy.ensureLootTries + 1
      if autoBuy.ensureLootTries > 5 then
        autoNextMailItem()
        scheduleAutoBuy(300)
        return
      end
      scheduleAutoBuy(600)
      return
    end

    if status == "move_failed" then
      tries = tries + 1
      autoBuy.mailItemRetries[targetId] = tries
      if tries >= 3 then
        autoNextMailItem()
        scheduleAutoBuy(250)
        return
      end
      scheduleAutoBuy(350)
      return
    end

    if status == "error" then
      tries = tries + 1
      autoBuy.mailItemRetries[targetId] = tries
      if tries >= 3 then
        autoNextMailItem()
        scheduleAutoBuy(250)
        return
      end
      scheduleAutoBuy(400)
      return
    end

    if autoBuy.collectTries > 80 then
      pcall(function() rootWidget:focus() end)
      stopAutoBuy()
      return
    end

    scheduleAutoBuy(300)
    return
  end

  -- BUYER
  local task = autoCurrentTask()

  if autoBuy.step == "buyer_idle" then
    if not task then
      closeMarketWindow()
      autoBuy.mailTries = 0
      autoBuy.collectTries = 0
      autoBuy.step = "open_mail"
      scheduleAutoBuy(700)
      return
    end

    if autoRemaining(task) <= 0 then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    autoBuy.step = "buyer_search"
    scheduleAutoBuy(30)
    return
  end

  if not task then
    closeMarketWindow()
    autoBuy.mailTries = 0
    autoBuy.collectTries = 0
    autoBuy.step = "open_mail"
    scheduleAutoBuy(700)
    return
  end

  if autoRemaining(task) <= 0 then
    autoNextTask()
    scheduleAutoBuy(80)
    return
  end

  local ui = marketReady()
  if not ui then
    scheduleAutoBuy(1000)
    return
  end

  if autoBuy.step == "buyer_search" then
    if not ui.searchEdit then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    setSearchAll(ui)
    focus(ui.searchEdit)

    if not setText(ui.searchEdit, task.name) then
      autoBuy.tries.search = autoBuy.tries.search + 1
      if autoBuy.tries.search <= autoBuy.maxSearch then
        scheduleAutoBuy(autoBuy.waitSearch)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    pcall(function()
      if ui.searchEdit.onTextChange then
        ui.searchEdit.onTextChange(ui.searchEdit, task.name)
      end
    end)

    autoBuy.step = "buyer_item"
    scheduleAutoBuy(autoBuy.waitSearch)
    return
  end

  if autoBuy.step == "buyer_item" then
    local box = findItemBox(ui.itemsPanel, task.name)
    if not box then
      autoBuy.tries.item = autoBuy.tries.item + 1
      if autoBuy.tries.item <= autoBuy.maxItem then
        pcall(function()
          if ui.searchEdit and ui.searchEdit.onTextChange then
            ui.searchEdit.onTextChange(ui.searchEdit, task.name)
          end
        end)
        scheduleAutoBuy(autoBuy.waitSearch)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if not selectItemBox(box) then
      autoBuy.tries.item = autoBuy.tries.item + 1
      if autoBuy.tries.item <= autoBuy.maxItem then
        scheduleAutoBuy(autoBuy.waitItem)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    autoBuy.step = "buyer_offer"
    autoBuy.row = nil
    autoBuy.tries.offer = 0
    scheduleAutoBuy(autoBuy.waitItem)
    return
  end

  if autoBuy.step == "buyer_offer" then
    local row = firstSellRow(ui)
    if not row then
      autoBuy.tries.offer = autoBuy.tries.offer + 1
      if autoBuy.tries.offer <= autoBuy.maxOffer then
        scheduleAutoBuy(autoBuy.waitItem)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    local piecePrice = getPiecePrice(row)
    if not piecePrice then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if piecePrice > (tonumber(task.maxPrice) or 0) then
      log(task.name .. ": primeira offer acima do maxPrice (" .. piecePrice .. " > " .. tostring(task.maxPrice) .. ")")
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    autoBuy.row = row
    autoBuy.step = "buyer_select"
    autoBuy.tries.select = 0
    scheduleAutoBuy(60)
    return
  end

  if autoBuy.step == "buyer_select" then
    local row = autoBuy.row or firstSellRow(ui)
    if not row then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if selectOffer(ui, row) then
      autoBuy.step = "buyer_buy"
      scheduleAutoBuy(autoBuy.waitOffer)
      return
    end

    autoBuy.tries.select = autoBuy.tries.select + 1
    if autoBuy.tries.select <= autoBuy.maxSelect then
      scheduleAutoBuy(autoBuy.waitOffer)
      return
    end
    autoNextTask()
    scheduleAutoBuy(80)
    return
  end

  if autoBuy.step == "buyer_buy" then
    if not ui.buyButton then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if not safeEnabled(ui.buyButton) then
      autoBuy.tries.select = autoBuy.tries.select + 1
      if autoBuy.tries.select <= autoBuy.maxSelect + 4 then
        local row = autoBuy.row or firstSellRow(ui)
        if row then selectOffer(ui, row) end
        scheduleAutoBuy(autoBuy.waitOffer)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if not click(ui.buyButton) then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    autoBuy.step = "buyer_popup"
    autoBuy.tries.popup = 0
    scheduleAutoBuy(autoBuy.waitBuy)
    return
  end

  if autoBuy.step == "buyer_popup" then
    local popup = findAmountPopup()
    if not popup then
      autoBuy.tries.popup = autoBuy.tries.popup + 1
      if autoBuy.tries.popup <= autoBuy.maxPopup then
        scheduleAutoBuy(autoBuy.waitPopup)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    local want = autoRemaining(task)
    if want <= 0 then
      if autoBuy.closePopupOnFail then popupCancel(popup) end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if not setPopupAmount(popup, want) then
      setPopupAmount(popup, 1)
      want = 1
    end

    local finalAmount = getPopupAmount(popup) or want or 1
    if finalAmount < 1 then finalAmount = 1 end

    if not popupConfirm(popup) then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    autoAddBought(task.itemId, finalAmount)

    if autoRemaining(task) <= 0 then
      autoNextTask()
      scheduleAutoBuy(80)
    else
      autoRetryItem(autoBuy.retryItemMs)
    end
    return
  end

  stopAutoBuy()
end

function startAutoBuyMarket()
  if autoBuy.running then return end

  if CaveBot and CaveBot.setOff then
    pcall(function() CaveBot.setOff() end)
  end

  autoBuy.running = true
  autoBuy.step = "go_depot"
  autoBuy.nextAt = 0
  autoBuy.tasks = {}
  autoBuy.idx = 1
  autoBuy.bought = {}
  autoBuy.depotTarget = nil
  autoBuy.depotPos = nil
  autoBuy.depotTries = 0
  autoBuy.openTries = 0
  autoBuy.mailTries = 0
  autoBuy.collectTries = 0
  autoBuy.ensureLootTries = 0
  autoBuy.mailItemOrder = {}
  autoBuy.mailItemIndex = 1
  autoBuy.mailItemRetries = {}
  autoResetTries()
  autoBuyStep()
end
end

do
  -- ===============================
-- STORAGE CORE
-- ===============================
if not loadCharStorage or not saveCharStorage then
  return print("[Auto Prey] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function savePreyChar()
  saveCharStorage(charStorage)
end

setDefaultTab("Main")

-- ===============================
-- MAIN BUTTON
-- ===============================
local switchPrey = "preyButton"

charStorage[switchPrey] = charStorage[switchPrey] or { enabled = false }

preyButton = setupUI([[
Panel
  height: 19
  margin-top: 0

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-right: 45
    text-align: center
    height: 18
    text: Auto Prey
    color: white
    tooltip: Auto Prey

  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    color: white
    text: Config
]])

preyButton:setId(switchPrey)
preyButton.title:setOn(charStorage[switchPrey].enabled)

preyButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  charStorage[switchPrey].enabled = newState
  savePreyChar()
end

-- ===============================
-- PANEL
-- ===============================
preyInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 360 370
  text: Panel Auto Prey
  margin-top: -50

  Panel
    id: monstersBlock
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 170
    image-source: /images/ui/miniwindow
    image-border: 20
    margin-left: -4
    margin-right: -4

    Label
      id: infoPreyList1
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      margin-top: 2
      text: Monsters List
      text-auto-resize: true

  TextList
    id: panelPreyList1
    anchors.top: monstersBlock.top
    anchors.left: monstersBlock.left
    anchors.right: monstersBlock.right
    margin-top: 20
    margin-left: 8
    margin-right: 19
    height: 110
    padding: 1
    vertical-scrollbar: prey1Scroll
    opacity: 0.95

  VerticalScrollBar
    id: prey1Scroll
    anchors.top: panelPreyList1.top
    anchors.bottom: panelPreyList1.bottom
    anchors.left: panelPreyList1.right
    step: 18
    pixels-scroll: true
    visible: true
    opacity: 0.90
    margin-left: 0

  TextEdit
    id: inserirMobName1
    anchors.top: panelPreyList1.bottom
    anchors.left: panelPreyList1.left
    margin-top: 4
    width: 300
    height: 18
    color: #c0c0c0
    placeholder: Insert monster name

  Button
    id: buttonAdd
    anchors.top: inserirMobName1.top
    anchors.right: prey1Scroll.right
    width: 20
    height: 18
    text: +
    font: sans-bold-16px

  Panel
    id: slotsBlock
    anchors.top: monstersBlock.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 70
    image-source: /images/ui/miniwindow
    image-border: 20
    margin-top: 6
    margin-left: -4
    margin-right: -4

    Label
      id: slotsTitle
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      margin-top: 2
      text: Auto Reroll Slots
      text-auto-resize: true

  UIWidget
    id: ativarPrey1
    anchors.top: slotsBlock.top
    anchors.left: slotsBlock.left
    margin-top: 20
    margin-left: 18
    size: 35 35
    image-source: /images/game/prey/prey_select_blocked

  Label
    id: labelPrey1
    anchors.top: ativarPrey1.bottom
    anchors.horizontalCenter: ativarPrey1.horizontalCenter
    margin-top: 0
    font: verdana-11px-rounded
    text: Prey 1
    color: white
    text-auto-resize: true

  UIWidget
    id: ativarPrey2
    anchors.top: ativarPrey1.top
    anchors.horizontalCenter: slotsBlock.horizontalCenter
    size: 35 35
    image-source: /images/game/prey/prey_select_blocked

  Label
    id: labelPrey2
    anchors.top: ativarPrey2.bottom
    anchors.horizontalCenter: ativarPrey2.horizontalCenter
    margin-top: 0
    font: verdana-11px-rounded
    text: Prey 2
    color: white
    text-auto-resize: true

  UIWidget
    id: ativarPrey3
    anchors.top: ativarPrey1.top
    anchors.right: slotsBlock.right
    margin-right: 18
    size: 35 35
    image-source: /images/game/prey/prey_select_blocked

  Label
    id: labelPrey3
    anchors.top: ativarPrey3.bottom
    anchors.horizontalCenter: ativarPrey3.horizontalCenter
    margin-top: 0
    font: verdana-11px-rounded
    text: Prey 3
    color: white
    text-auto-resize: true

  Panel
    id: fundoconfigsprey
    anchors.top: slotsBlock.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 58
    image-source: /images/ui/miniwindow
    image-border: 20
    margin-top: 6
    margin-left: -4
    margin-right: -4

    Label
      id: retryTitle
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      margin-top: 2
      text: Retry Settings
      text-auto-resize: true

  Label
    id: labelMaxRetries
    anchors.top: fundoconfigsprey.top
    anchors.left: fundoconfigsprey.left
    margin-top: 24
    margin-left: 8
    text: Max Retrie
    font: verdana-11px-rounded
    text-auto-resize: true

  SpinBox
    id: maxRetriesPrey
    anchors.left: labelMaxRetries.right
    anchors.verticalCenter: labelMaxRetries.verticalCenter
    margin-left: 5
    size: 52 20
    font: verdana-11px-rounded
    text-align: center
    minimum: 0
    maximum: 300
    step: 1

  Label
    id: labelDelayRetries
    anchors.left: maxRetriesPrey.right
    anchors.verticalCenter: maxRetriesPrey.verticalCenter
    margin-left: 14
    text: Delay
    font: verdana-11px-rounded
    text-auto-resize: true

  HorizontalScrollBar
    id: delayRetries
    anchors.left: labelDelayRetries.right
    anchors.right: fundoconfigsprey.right
    anchors.verticalCenter: labelDelayRetries.verticalCenter
    margin-left: 8
    margin-right: 8
    height: 14
    minimum: 0
    maximum: 5000
    step: 100

  Label
    id: delayMsValue
    anchors.centerIn: delayRetries
    text-align: center
    text: 0ms
    font: verdana-11px-rounded
    color: white
    text-auto-resize: true

  Button
    id: closePanel
    anchors.top: fundoconfigsprey.bottom
    anchors.left: fundoconfigsprey.left
    anchors.right: fundoconfigsprey.right
    margin-top: 6
    text: Close
]=], g_ui.getRootWidget())

preyInterface:hide()

if modules._G.g_app.isMobile() then
  preyInterface:setSize("360 390")
end

preyButton.settings.onClick = function()
  preyInterface:show()
  preyInterface:raise()
  preyInterface:focus()
end

preyInterface.closePanel.onClick = function()
  preyInterface:hide()
end

-- ===============================
-- STORAGE
-- ===============================
local STKEY = "lnsPreyRerollPanel"

charStorage[STKEY] = charStorage[STKEY] or {
  lists = { [1] = {} },
  enabled = { [1] = false, [2] = false, [3] = false },
  delayMs = 400,
  maxRetries = 15
}

local st = charStorage[STKEY]
st.lists = st.lists or { [1] = {} }
st.lists[1] = st.lists[1] or {}
st.enabled = st.enabled or { [1] = false, [2] = false, [3] = false }
st.delayMs = tonumber(st.delayMs) or 400
st.maxRetries = tonumber(st.maxRetries) or 15

st.renewBelowPercent = 5

savePreyChar()

-- ===============================
-- HELPERS
-- ===============================
local PREY_ACTION_LISTREROLL = 0
local PREY_ACTION_MONSTERSELECTION = 2

local function nowMillis()
  if g_clock and type(g_clock.millis) == "function" then
    return g_clock.millis()
  end
  if g_clock and type(g_clock.seconds) == "function" then
    return math.floor(g_clock.seconds() * 1000)
  end
  return os.time() * 1000
end

local function trim(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalizeText(s)
  s = tostring(s or ""):lower()
  s = s:gsub("%s+", " ")
  return trim(s)
end

local function sameText(a, b)
  return normalizeText(a) == normalizeText(b)
end

local function capitalizeEachWord(str)
  return tostring(str or ""):gsub("(%a)([%w_']*)", function(first, rest)
    return first:upper() .. rest:lower()
  end)
end

local function clamp(n, a, b)
  n = tonumber(n) or a
  if n < a then return a end
  if n > b then return b end
  return n
end

local function desiredList()
  st.lists[1] = st.lists[1] or {}
  return st.lists[1]
end

local function listHasDesired(name)
  name = normalizeText(name)
  if name == "" then return false end

  for _, v in ipairs(desiredList()) do
    if normalizeText(v) == name then
      return true
    end
  end

  return false
end

-- ===============================
-- MONSTER LIST UI
-- ===============================
local mobRowTemplate = [[
UIWidget
  id: root
  height: 18
  focusable: false
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #2F2F2F
    opacity: 0.75

  Label
    id: mobName
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    color: white
    text: ""

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 2
    text: X
    color: #FF4040
]]

local function sortMonsterList()
  table.sort(st.lists[1], function(a, b)
    return normalizeText(a) < normalizeText(b)
  end)
end

local function refreshMobList()
  local listW = preyInterface.panelPreyList1
  if not listW then return end

  if listW.destroyChildren then
    listW:destroyChildren()
  else
    local ch = listW:getChildren()
    for i = #ch, 1, -1 do
      ch[i]:destroy()
    end
  end

  sortMonsterList()

  for _, mobName in ipairs(st.lists[1]) do
    local row = g_ui.loadUIFromString(mobRowTemplate, listW)
    row.mobName:setText(mobName)

    row.remove.onClick = function()
      local newList = {}
      for _, v in ipairs(st.lists[1]) do
        if not sameText(v, mobName) then
          table.insert(newList, v)
        end
      end
      st.lists[1] = newList
      savePreyChar()
      refreshMobList()
    end
  end
end

local function addMobFromInput()
  local edit = preyInterface.inserirMobName1
  if not edit then return end

  local name = trim(edit:getText())
  if name == "" then return end

  local pretty = capitalizeEachWord(name)

  for _, v in ipairs(st.lists[1]) do
    if sameText(v, pretty) then
      edit:setText("")
      return
    end
  end

  table.insert(st.lists[1], pretty)
  edit:setText("")
  savePreyChar()
  refreshMobList()
end

preyInterface.buttonAdd.onClick = addMobFromInput

preyInterface.inserirMobName1.onKeyPress = function(widget, keyCode)
  if keyCode == KeyEnter or keyCode == KeyReturn then
    addMobFromInput()
    return true
  end
  return false
end

-- ===============================
-- DELAY / RETRY UI
-- ===============================
local function applyDelayLabel()
  preyInterface.delayMsValue:setText(tostring(math.floor(st.delayMs)) .. "ms")
end

preyInterface.delayRetries:setValue(clamp(st.delayMs, 0, 5000))
applyDelayLabel()

preyInterface.delayRetries.onValueChange = function(_, value)
  st.delayMs = clamp(value, 0, 5000)
  applyDelayLabel()
  savePreyChar()
end

preyInterface.maxRetriesPrey:setValue(clamp(st.maxRetries, 0, 300))
preyInterface.maxRetriesPrey.onValueChange = function(_, value)
  st.maxRetries = clamp(value, 0, 300)
  savePreyChar()
end

-- ===============================
-- SLOT SWITCH UI
-- ===============================
local function getSlotSwitchWidget(i)
  if i == 1 then return preyInterface.ativarPrey1, preyInterface.labelPrey1 end
  if i == 2 then return preyInterface.ativarPrey2, preyInterface.labelPrey2 end
  if i == 3 then return preyInterface.ativarPrey3, preyInterface.labelPrey3 end
  return nil, nil
end

local function applySwitchUI(i)
  local w, lbl = getSlotSwitchWidget(i)
  if not w or not lbl then return end

  if st.enabled[i] == true then
    w:setImageSource("/images/game/prey/prey_select")
  else
    w:setImageSource("/images/game/prey/prey_select_blocked")
  end

  lbl:setText("Prey " .. i)
end

local function bindSwitch(i)
  local w = getSlotSwitchWidget(i)
  if not w then return end

  w.onClick = function()
    st.enabled[i] = not (st.enabled[i] == true)
    savePreyChar()
    applySwitchUI(i)
  end
end

for i = 1, 3 do
  bindSwitch(i)
  applySwitchUI(i)
end

refreshMobList()

-- ===============================
-- PREY CORE - BASEADO NO TRACKER
-- ===============================
local currentRolls = { [0] = 0, [1] = 0, [2] = 0 }
local lastActionAt = { [0] = 0, [1] = 0, [2] = 0 }

local function mainEnabled()
  return charStorage[switchPrey] and charStorage[switchPrey].enabled == true
end

local function slotEnabled(slotIndex)
  return mainEnabled() and st.enabled[slotIndex + 1] == true
end

local function canAction(slotIndex)
  local t = nowMillis()
  local delay = tonumber(st.delayMs) or 400
  if delay < 100 then delay = 100 end

  if t - (lastActionAt[slotIndex] or 0) < delay then
    return false
  end

  lastActionAt[slotIndex] = t
  return true
end

local function getPreyTracker()
  return modules.game_prey and modules.game_prey.preyTracker
end

local function getPreyWindow()
  return modules.game_prey and modules.game_prey.preyWindow
end

local function getSlotObjects(slotIndex)
  local tracker = getPreyTracker()
  local window = getPreyWindow()

  if not tracker or not tracker.contentsPanel then return nil, nil end
  if not window then return nil, nil end

  local slotName = "slot" .. tostring(slotIndex + 1)
  return tracker.contentsPanel[slotName], window[slotName]
end

local function getSlotCreatureName(windowSlot)
  if not windowSlot or not windowSlot.title or not windowSlot.title.getText then
    return ""
  end

  local ok, text = pcall(function()
    return windowSlot.title:getText()
  end)

  if ok then
    return normalizeText(text)
  end

  return ""
end

local function getSlotPercent(trackerSlot)
  if not trackerSlot or not trackerSlot.time or not trackerSlot.time.getPercent then
    return nil
  end

  local ok, percent = pcall(function()
    return trackerSlot.time:getPercent()
  end)

  if ok then
    return tonumber(percent)
  end

  return nil
end

local function getCreatureNameFromTracker(trackerSlot)
  if not trackerSlot or not trackerSlot.creature or not trackerSlot.creature.getTooltip then
    return ""
  end

  local ok, tip = pcall(function()
    return trackerSlot.creature:getTooltip()
  end)

  if not ok or not tip then return "" end

  local name = tostring(tip):match("Creature:%s*([^\n]+)")
  return normalizeText(name or "")
end

local function rerollSlot(slotIndex)
  if not canAction(slotIndex) then return false end

  currentRolls[slotIndex] = (currentRolls[slotIndex] or 0) + 1
  if currentRolls[slotIndex] > (tonumber(st.maxRetries) or 15) then
    return false
  end

  g_game.preyAction(slotIndex, PREY_ACTION_LISTREROLL, 0)
  return true
end

local function selectMonster(slotIndex, optionIndex)
  if not canAction(slotIndex) then return false end

  currentRolls[slotIndex] = 0
  g_game.preyAction(slotIndex, PREY_ACTION_MONSTERSELECTION, optionIndex)
  return true
end

local function handleSelectMonster(slotIndex, windowSlot)
  if not windowSlot or not windowSlot.inactive or not windowSlot.inactive.list then
    return false
  end

  local children = windowSlot.inactive.list:getChildren() or {}

  for j, child in ipairs(children) do
    local name = ""
    if child.getTooltip then
      local ok, tip = pcall(function()
        return child:getTooltip()
      end)
      if ok then name = tip or "" end
    end

    if listHasDesired(name) then
      return selectMonster(slotIndex, j - 1)
    end
  end

  return rerollSlot(slotIndex)
end

local function handleActivePrey(slotIndex, trackerSlot, creatureName)
  local percent = getSlotPercent(trackerSlot)
  if not percent then return false end

  if not listHasDesired(creatureName) then
    return false
  end

  if percent <= 5 then
    currentRolls[slotIndex] = 0
    return rerollSlot(slotIndex)
  end

  currentRolls[slotIndex] = 0
  return false
end

local preyOpenedByScript = false

macro(400, function()
  if not mainEnabled() then
    preyOpenedByScript = false
    return
  end

  if #desiredList() == 0 then return end

  if not preyOpenedByScript and modules.game_prey and modules.game_prey.show then
    modules.game_prey.show()
    preyOpenedByScript = true

    schedule(500, function()
      if modules.game_prey and modules.game_prey.hide then
        modules.game_prey.hide()
      end
    end)
  end

  for slotIndex = 0, 2 do
    if slotEnabled(slotIndex) then
      local trackerSlot, windowSlot = getSlotObjects(slotIndex)
      if trackerSlot and windowSlot then
        local creatureName = getSlotCreatureName(windowSlot)

        if creatureName == "select monster" then
          if handleSelectMonster(slotIndex, windowSlot) then
            return
          end
        else
          local trackerCreatureName = getCreatureNameFromTracker(trackerSlot)
          if trackerCreatureName ~= "" then
            creatureName = trackerCreatureName
          end

          if handleActivePrey(slotIndex, trackerSlot, creatureName) then
            return
          end
        end
      end
    end
  end
end)

UI.Separator()
end

do
  setDefaultTab("Cave")

charStorage = charStorage or loadCharStorage()

local CAVE_FUNCTIONS_STORAGE = "lnsCaveFunctions"

charStorage[CAVE_FUNCTIONS_STORAGE] = charStorage[CAVE_FUNCTIONS_STORAGE] or {
  qtdeMortes = 1,
  pauseCaveDeath = false,
  exitGameDeath = false,

  qtdeLure = 1,
  qtdeReturnlure = 1,
  startLure = false,

  pauseTargetPlayer = false
}

local caveSetCfg = charStorage[CAVE_FUNCTIONS_STORAGE]

local function saveCaveFunctions()
  saveCharStorage(charStorage)
end

addButton("", "LNS Cavebot Settings", function()
  lnsCaveSet:show()
  lnsCaveSet:raise()
  lnsCaveSet:focus()
end)

sep = UI.Separator()
sep:setImageSource("")

lnsCaveSet = setupUI([[
MainWindow
  size: 330 350
  text: Panel Cave Functions
  
  FlatPanel
    id: flatp2
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin: -5
    margin-top: 2
    margin-bottom: 20

    ScrollablePanel
      id: listaMain
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-bottom: 5
      margin-top: 5
      margin-left: 4
      margin-right: 16
      image-source: /images/ui/panel_flat
      image-border: 1
      vertical-scrollbar: mainListScrollBar
      opacity: 1.00

      Label
        id: explicDeathLogout
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        margin-left: 5
        margin-top: 2
        text-align: center
        color: orange
        text: "Deaths Control"

      HorizontalSeparator
        id: hsep
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-right: 3
        margin-top: 2

      Label
        id: labelqtdeMortes
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 5
        text-align: center
        text: Amount Deaths: 1

      HorizontalScrollBar
        id: qtdeMortes
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 2
        minimum: 1
        maximum: 10

      BotSwitch
        id: PauseCaveDeath
        anchors.top: prev.bottom
        anchors.left: prev.left
        text: Pause Cavebot
        margin-top: 5
        width: 140

      BotSwitch
        id: ExitGameDeath
        anchors.top: prev.top
        anchors.right: qtdeMortes.right
        text: Exit Game
        width: 140
        margin-top: 0

      HorizontalSeparator
        id: hsep2
        anchors.top: prev.bottom
        anchors.left: hsep.left
        anchors.right: hsep.right
        margin-top: 10

      Label
        id: labelcontroleLure
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 2
        text-align: center
        text: "Lure Control"
        color: orange

      HorizontalSeparator
        id: hsep3
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 2

      Label
        id: labelqtdelure
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 5
        text-align: center
        text: Pause lure with: 1 creatures 

      HorizontalScrollBar
        id: qtdeLure
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 2
        minimum: 1
        maximum: 10

      Label
        id: labelreturnlure
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 5
        text-align: center
        text: Return lure with: 1 creatures 

      HorizontalScrollBar
        id: qtdeReturnlure
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 2
        minimum: 1
        maximum: 10

      BotSwitch
        id: startLure
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        text: Start Lure
        width: 140
        margin-top: 5

      HorizontalSeparator
        id: hsepp
        anchors.top: prev.bottom
        anchors.left: hsep.left
        anchors.right: hsep.right
        margin-top: 10

      Label
        id: labelRagnar
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 2
        text-align: center
        text: "Pause Target"
        color: orange

      HorizontalSeparator
        id: hsepp2
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 2

      BotSwitch
        id: pauseTargetPlayer
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        text: Pause Target with Player on Screen
        width: 140
        margin-top: 5

    VerticalScrollBar
      id: mainListScrollBar
      anchors.top: listaMain.top
      anchors.bottom: listaMain.bottom
      anchors.left: listaMain.right
      step: 10
      pixels-scroll: true
      visible: true
      opacity: 1.00
      margin-left: 0

  Button
    id: closePanel
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    size: 35 20
    margin-top: 5
    text: Close
]], g_ui.getRootWidget())

lnsCaveSet:hide()

local mainPanel = lnsCaveSet.flatp2.listaMain

lnsCaveSet.closePanel.onClick = function()
  lnsCaveSet:hide()
end

local function bindSwitch(widget, key)
  if not widget then return end

  caveSetCfg[key] = caveSetCfg[key] == true
  widget:setOn(caveSetCfg[key])

  widget.onClick = function(w)
    caveSetCfg[key] = not caveSetCfg[key]
    w:setOn(caveSetCfg[key])
    saveCaveFunctions()
  end
end

local function bindScroll(widget, label, key, defaultValue, labelPrefix, labelSuffix)
  if not widget then return end

  caveSetCfg[key] = tonumber(caveSetCfg[key]) or defaultValue or 1
  widget:setValue(caveSetCfg[key])

  local function updateLabel(value)
    if label then
      label:setText((labelPrefix or "") .. tostring(value) .. (labelSuffix or ""))
    end
  end

  updateLabel(caveSetCfg[key])

  widget.onValueChange = function(_, value)
    value = tonumber(value) or defaultValue or 1
    caveSetCfg[key] = value
    updateLabel(value)
    saveCaveFunctions()
  end
end

bindScroll(mainPanel.qtdeMortes, mainPanel.labelqtdeMortes, "qtdeMortes", 1, "Amount Deaths: ", "")
bindScroll(mainPanel.qtdeLure, mainPanel.labelqtdelure, "qtdeLure", 1, "Pause lure with: ", " creatures")
bindScroll(mainPanel.qtdeReturnlure, mainPanel.labelreturnlure, "qtdeReturnlure", 1, "Return lure with: ", " creatures")

mainPanel.PauseCaveDeath:setOn(caveSetCfg.pauseCaveDeath == true)
mainPanel.ExitGameDeath:setOn(caveSetCfg.exitGameDeath == true)

mainPanel.PauseCaveDeath.onClick = function(widget)
  local state = not widget:isOn()

  caveSetCfg.pauseCaveDeath = state
  caveSetCfg.exitGameDeath = false

  widget:setOn(state)
  mainPanel.ExitGameDeath:setOn(false)

  saveCaveFunctions()
end

mainPanel.ExitGameDeath.onClick = function(widget)
  local state = not widget:isOn()

  caveSetCfg.exitGameDeath = state
  caveSetCfg.pauseCaveDeath = false

  widget:setOn(state)
  mainPanel.PauseCaveDeath:setOn(false)

  saveCaveFunctions()
end

bindSwitch(mainPanel.startLure, "startLure")
bindSwitch(mainPanel.pauseTargetPlayer, "pauseTargetPlayer")

charStorage.deathControl = charStorage.deathControl or {
  deaths = 0
}

local deathState = {
  wasAlive = true
}

local function saveDeath()
  saveCharStorage(charStorage)
end

macro(500, function()
  if not caveSetCfg then return end

  local isDead = player:getHealth() == 0

  -- DETECTA MORTE
  if isDead and deathState.wasAlive then
    deathState.wasAlive = false

    charStorage.deathControl.deaths = (charStorage.deathControl.deaths or 0) + 1
    saveDeath()

    modules.game_textmessage.displayGameMessage("[Death Control] Morte: " .. charStorage.deathControl.deaths)

    local limit = tonumber(caveSetCfg.qtdeMortes) or 1

    if charStorage.deathControl.deaths >= limit then

      if caveSetCfg.pauseCaveDeath then
        CaveBot.setOff()
        TargetBot.setOff()
        modules.game_textmessage.displayGameMessage("[Death Control] Cavebot pausado.")
      
      elseif caveSetCfg.exitGameDeath then
        modules.game_textmessage.displayGameMessage("[Death Control] Saindo do jogo.")
        schedule(200, function()
          modules.game_interface.forceExit()
        end)
      end

      charStorage.deathControl.deaths = 0
      saveDeath()
    end

  elseif not isDead then
    deathState.wasAlive = true
  end
end)

local lurePausedByScript = false

local function countScreenMonsters()
  local count = 0

  for _, spec in ipairs(getSpectators(false)) do
    if spec:isMonster() then
      count = count + 1
    end
  end

  return count
end

macro(500, function()
  if not caveSetCfg then return end
  if caveSetCfg.startLure ~= true then
    lurePausedByScript = false
    return
  end

  local mobs = countScreenMonsters()
  local pauseAt = tonumber(caveSetCfg.qtdeLure) or 6
  local returnAt = tonumber(caveSetCfg.qtdeReturnlure) or 2

  if not lurePausedByScript and mobs >= pauseAt then
    lurePausedByScript = true
    CaveBot.setOff()
    TargetBot.setOn()
    modules.game_textmessage.displayGameMessage("[Lure Control] CaveBot pausado. Mobs na tela: " .. mobs)
    return
  end

  if lurePausedByScript and mobs <= returnAt then
    lurePausedByScript = false
    CaveBot.setOn()
    TargetBot.setOff()
    modules.game_textmessage.displayGameMessage("[Lure Control] CaveBot retomado. Mobs na tela: " .. mobs)
  end
end)

local targetPausedByPlayer = false

local function hasPlayerNear()
  local ppos = pos()
  if not ppos then return false end

  for _, spec in ipairs(getSpectators(false)) do
    if spec:isPlayer() and spec ~= player then
      local spos = spec:getPosition()
      if spos and spos.z == ppos.z and getDistanceBetween(ppos, spos) <= 6 then
        return true
      end
    end
  end

  return false
end

macro(300, function()
  if not caveSetCfg then return end
  if caveSetCfg.pauseTargetPlayer ~= true then
    targetPausedByPlayer = false
    return
  end

  if hasPlayerNear() then
    if not targetPausedByPlayer then
      targetPausedByPlayer = true
      TargetBot.setOff()
      modules.game_textmessage.displayGameMessage("[Pause Target] Player perto. TargetBot pausado.")
    end
    return
  end

  if targetPausedByPlayer then
    targetPausedByPlayer = false
    TargetBot.setOn()
    modules.game_textmessage.displayGameMessage("[Pause Target] Sem player perto. TargetBot retomado.")
  end
end)
end

do
  setDefaultTab("Main")

settingsButton = setupUI([[
Panel
  height: 19
  
  Button
    id: settings
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 0
    height: 18
    text: Settings and Tools
]])
settingsButton:setId(switchTravel)

settingsInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 220 280
  anchors.centerIn: parent
  margin-top: -50
  text: Panel Settings
  opacity: 1.00

  FlatPanel
    id: panel
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin: -3
    margin-bottom: 20

    Button
      id: PlayerList
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      height: 22
      margin-left: 4
      margin-right: 4
      margin-top: 5
      text: PLAYER LIST
      font: cipsoftFont

    Button
      id: vBotSettings
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: VBOT SETTINGS
      font: cipsoftFont

    Button
      id: FastTravel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: FAST TRAVEL
      font: cipsoftFont

    Button
      id: BuyMarket
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: BUYING MARKET
      font: cipsoftFont

    Button
      id: AutoImbue
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: AUTO IMBUEMENT
      font: cipsoftFont

    Button
      id: ImbueScroll
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: IMBUE SCROLL
      font: cipsoftFont

    Button
      id: HUD
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: HUD
      font: cipsoftFont

  Button
    id: closePanel
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    margin-left: -1
    margin-top: 5
    text: Close
    color: gray

]=], g_ui.getRootWidget())
settingsInterface:hide()

if modules._G.g_app.isMobile() then
  settingsInterface:setSize("220 270")
end

settingsButton.settings.onClick = function()
  if settingsInterface:isVisible() then
    settingsInterface:hide()
  else
    settingsInterface:show()
    settingsInterface:raise()
    settingsInterface:focus()
  end
end
settingsInterface.panel.FastTravel.onClick = function()
  travelInterface:show()
  travelInterface:raise()
  travelInterface:focus()
end
settingsInterface.panel.vBotSettings.onClick = function()
  extrasWindow:show()
  extrasWindow:raise()
  extrasWindow:focus()
end
settingsInterface.panel.PlayerList.onClick = function()
  if type(openPlayerListWindow) == "function" then
    openPlayerListWindow()
  else
    warn("[PlayerList] Função openPlayerListWindow ainda nao carregou.")
  end
end
settingsInterface.panel.AutoImbue.onClick = function()
  rebuildMainList()
  panelImbuiment:show()
  panelImbuiment:raise()
  panelImbuiment:focus()
end
settingsInterface.panel.ImbueScroll.onClick = function()
  panelScrollImbue:show()
  panelScrollImbue:raise()
  panelScrollImbue:focus()
end
settingsInterface.panel.BuyMarket.onClick = function()
  marketInterface:show()
  marketInterface:raise()
  marketInterface:focus()
end
settingsInterface.panel.HUD.onClick = function()
  hudInterface:show()
  hudInterface:raise()
  hudInterface:focus()
end
settingsInterface.closePanel.onClick = function()
  settingsInterface:hide()
end


------------------------------
--------UTILITARIOS
------------------------------

settingsButton = setupUI([[
Panel
  height: 19
  
  Button
    id: settings
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 0
    height: 18
    text: Utilitys Scripts
]])
settingsButton:setId(switchTravel)

-- ============================================================
-- UTILITYS PANEL + CHAR STORAGE
-- ============================================================

charStorage = charStorage or loadCharStorage()

local UTILITY_STORAGE = "utilityPanel"

charStorage[UTILITY_STORAGE] = charStorage[UTILITY_STORAGE] or {
  proximaBp = false,

  HoldTarget = false,
  SummonF = false,
  SuperDash = false,
  Dancing = false,
  HoldPosition = false,
  SleepMode = false,
  EsconderSprites = false,
  EsconderTextos = false,
  AutoMount = false,
  AutoBan = false,
  ExetaRes = false,
  ExetaLoot = false,
  AmpRes = false,
  WallHugger = false,
  autoAol = false,
  esconderAndares = false,
  dashMouse = false,
  utevoLux = false,
  manaTrain = false,
  manaTrainMage = false,

  textutevoLux = "Utevo Lux",
  textManaTrain = "",
  textManaTrainMage = "23373",

  proximaBpID = {{id = 2854}},

  LootChest = false,
  lootAll = false,
  lootBackpackId = 2854,
  rewardChestId = 19250,
  rewardContainerId = 19202,
  maxOpennedContainers = 5,
  lootRewardDelay = 50,
  itemsToLoot = {3031, 3043}
}

local utilCfg = charStorage[UTILITY_STORAGE]

local function saveUtilitys()
  saveCharStorage(charStorage)
end

local function normalizeContainerItems(t)
  local r = {}
  for _, entry in pairs(t or {}) do
    local id = type(entry) == "table" and entry.id or entry
    id = tonumber(id)
    if id and id > 0 then
      table.insert(r, {id = id})
    end
  end
  return r
end

local function properTable(t)
  local r = {}
  for _, entry in pairs(t or {}) do
    local id = type(entry) == "table" and entry.id or entry
    id = tonumber(id)
    if id and id > 0 then
      table.insert(r, id)
    end
  end
  return r
end

local function safeSetItem(widget, id)
  if not widget then return end
  id = tonumber(id) or 0
  if id > 0 and widget.setItemId then
    widget:setItemId(id)
  elseif id > 0 and widget.setItem then
    widget:setItem(id)
  end
end

local function safeGetItem(widget)
  if not widget then return 0 end
  if widget.getItemId then
    return tonumber(widget:getItemId()) or 0
  end
  if widget.getItem then
    local it = widget:getItem()
    if it and it.getId then
      return tonumber(it:getId()) or 0
    end
  end
  return 0
end

-- ============================================================
-- UI
-- ============================================================

utilityInterface = setupUI([[
MainWindow
  id: mainPanel
  size: 478 335
  border: 1 black
  anchors.centerIn: parent
  margin-top: -50
  text: LNS Custom | Utilitys

  FlatPanel
    id: flatp2
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.bottom: closePanel.top
    width: 292
    margin: -5
    margin-top: 2
    margin-bottom: 6
    padding: 6

    BotSwitch
      id: HoldTarget
      anchors.top: parent.top
      anchors.left: parent.left
      size: 135 18
      text: Hold Target
      margin-top: 2

    BotSwitch
      id: SummonF
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Summon Familiar
      margin-top: 5

    BotSwitch
      id: SuperDash
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Super Dash
      margin-top: 5

    BotSwitch
      id: Dancing
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Dancing
      margin-top: 5

    BotSwitch
      id: HoldPosition
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Hold Position
      margin-top: 5

    BotSwitch
      id: SleepMode
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Sleep Mode
      margin-top: 5

    BotSwitch
      id: EsconderSprites
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Hide Sprites
      margin-top: 5

    BotSwitch
      id: EsconderTextos
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Hide Texts
      margin-top: 5

    BotSwitch
      id: AutoMount
      anchors.top: parent.top
      anchors.left: HoldTarget.right
      size: 135 18
      text: Auto Mount
      margin-left: 10
      margin-top: 2

    BotSwitch
      id: AutoBan
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Ban Cast
      margin-top: 5

    BotSwitch
      id: ExetaRes
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Exeta Res
      margin-top: 5

    BotSwitch
      id: ExetaLoot
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Exeta Loot
      margin-top: 5

    BotSwitch
      id: AmpRes
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Amp Res
      margin-top: 5

    BotSwitch
      id: WallHugger
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Wall Hugger
      margin-top: 5

    BotSwitch
      id: esconderAndares
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Hide Floors
      margin-top: 5

    BotSwitch
      id: dashMouse
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Dash Mouse
      margin-top: 5

    BotSwitch
      id: autoAol
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Auto Aol
      margin-top: 5

    BotSwitch
      id: utevoLux
      anchors.top: autoAol.bottom
      anchors.left: autoAol.left
      size: 135 18
      text: Utevo Lux
      margin-top: 5

    BotTextEdit
      id: textutevoLux
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      margin-top: 2
      text: Utevo Lux

    BotSwitch
      id: manaTrain
      anchors.top: EsconderTextos.bottom
      anchors.left: EsconderTextos.left
      size: 135 18
      text: Mana Train
      margin-top: 5

    BotTextEdit
      id: textManaTrain
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      margin-top: 2
      tooltip: Exura gran san

    BotSwitch
      id: manaTrainMage
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Trainer ED/MS
      margin-top: 5

    BotTextEdit
      id: textManaTrainMage
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      margin-top: 2
      text: 23373

  FlatPanel
    id: flatp
    anchors.top: parent.top
    anchors.left: flatp2.right
    anchors.right: parent.right
    anchors.bottom: closePanel.top
    margin-top: 2
    margin-left: 8
    margin-right: -5
    margin-bottom: 6
    padding: 6

    BotSwitch
      id: proximaBp
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      height: 18
      text: Open Next BP
      margin-top: 2
      text-align: center

    Panel
      id: containersBp
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: 70
      margin-top: 5
      border: 1 #444444
      background-color: #111111
      opacity: 0.85

    HorizontalSeparator
      id: hsep
      anchors.top: prev.bottom
      anchors.left: proximaBp.left
      anchors.right: proximaBp.right
      margin-top: 5

    BotSwitch
      id: LootChest
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      height: 18
      margin-right: 40
      text: Loot Chest
      margin-top: 8
      text-align: center

    BotSwitch
      id: lootAll
      anchors.top: prev.top
      anchors.left: prev.right
      anchors.right: hsep.right
      height: 18
      text: All
      margin-top: 0
      margin-left: 2
      text-align: center

    Label
      id: idlootbp
      anchors.top: prev.bottom
      anchors.left: LootChest.left
      text: ID Backpack:
      margin-top: 10
      text-auto-resize: true

    BotItem
      id: lootBp
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: lootAll.right
      margin-top: 2
      size: 30 30

    Label
      id: idReward
      anchors.top: idlootbp.bottom
      anchors.left: idlootbp.left
      text: ID Reward Bag:
      margin-top: 18
      text-auto-resize: true

    BotItem
      id: rewardChest
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: lootAll.right
      margin-top: 2
      size: 30 30

    Panel
      id: containerItemstoloot
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: 68
      margin-top: 2
      border: 1 #444444
      background-color: #111111
      opacity: 0.85

  Button
    id: closePanel
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: 20
    margin-left: -5
    margin-right: -5
    margin-bottom: -2
    text: Close
    color: gray
]], g_ui.getRootWidget())

utilityInterface:hide()

if modules._G.g_app.isMobile() then
  utilityInterface:setSize("478 355")
end

utilityInterface.closePanel.onClick = function()
  utilityInterface:hide()
end

settingsButton.settings.onClick = function()
  utilityInterface:show()
  utilityInterface:raise()
  utilityInterface:focus()
end

-- ============================================================
-- BINDS
-- ============================================================

local function bindSwitch(widget, key)
  if not widget then return end
  utilCfg[key] = utilCfg[key] == true
  widget:setOn(utilCfg[key])

  widget.onClick = function(w)
    utilCfg[key] = not utilCfg[key]
    w:setOn(utilCfg[key])
    saveUtilitys()
  end
end

local function bindText(widget, key, defaultText)
  if not widget then return end
  if utilCfg[key] == nil then utilCfg[key] = defaultText or "" end
  widget:setText(tostring(utilCfg[key] or ""))

  widget.onTextChange = function(_, text)
    utilCfg[key] = tostring(text or "")
    saveUtilitys()
  end
end

local function bindBotItem(widget, key, defaultId)
  if not widget then return end

  local id = tonumber(utilCfg[key] or 0) or 0
  if id <= 0 then
    id = tonumber(defaultId or 0) or 0
    utilCfg[key] = id
    saveUtilitys()
  end

  safeSetItem(widget, id)

  widget.onItemChange = function(w)
    utilCfg[key] = safeGetItem(w)
    saveUtilitys()
  end
end

bindSwitch(utilityInterface.flatp.proximaBp, "proximaBp")
bindSwitch(utilityInterface.flatp.LootChest, "LootChest")
bindSwitch(utilityInterface.flatp.lootAll, "lootAll")

bindSwitch(utilityInterface.flatp2.HoldTarget, "HoldTarget")
bindSwitch(utilityInterface.flatp2.SummonF, "SummonF")
bindSwitch(utilityInterface.flatp2.SuperDash, "SuperDash")
bindSwitch(utilityInterface.flatp2.Dancing, "Dancing")
bindSwitch(utilityInterface.flatp2.HoldPosition, "HoldPosition")
bindSwitch(utilityInterface.flatp2.SleepMode, "SleepMode")
bindSwitch(utilityInterface.flatp2.EsconderSprites, "EsconderSprites")
bindSwitch(utilityInterface.flatp2.EsconderTextos, "EsconderTextos")
bindSwitch(utilityInterface.flatp2.AutoMount, "AutoMount")
bindSwitch(utilityInterface.flatp2.AutoBan, "AutoBan")
bindSwitch(utilityInterface.flatp2.ExetaRes, "ExetaRes")
bindSwitch(utilityInterface.flatp2.ExetaLoot, "ExetaLoot")
bindSwitch(utilityInterface.flatp2.AmpRes, "AmpRes")
bindSwitch(utilityInterface.flatp2.WallHugger, "WallHugger")
bindSwitch(utilityInterface.flatp2.autoAol, "autoAol")
bindSwitch(utilityInterface.flatp2.esconderAndares, "esconderAndares")
bindSwitch(utilityInterface.flatp2.dashMouse, "dashMouse")
bindSwitch(utilityInterface.flatp2.utevoLux, "utevoLux")
bindSwitch(utilityInterface.flatp2.manaTrain, "manaTrain")
bindSwitch(utilityInterface.flatp2.manaTrainMage, "manaTrainMage")

bindText(utilityInterface.flatp2.textutevoLux, "textutevoLux", "Utevo Lux")
bindText(utilityInterface.flatp2.textManaTrain, "textManaTrain", "")
bindText(utilityInterface.flatp2.textManaTrainMage, "textManaTrainMage", "23373")

bindBotItem(utilityInterface.flatp.lootBp, "lootBackpackId", 2854)
bindBotItem(utilityInterface.flatp.rewardChest, "rewardContainerId", 19202)

-- ============================================================
-- CONTAINER: OPEN NEXT BP
-- ============================================================

utilCfg.proximaBpID = normalizeContainerItems(utilCfg.proximaBpID or {{id = 2854}})

local nextBpContainer = UI.ContainerEx(function(_, items)
  utilCfg.proximaBpID = normalizeContainerItems(items)
  saveUtilitys()
end, true, utilityInterface.flatp.containersBp)

nextBpContainer:setHeight(46)
nextBpContainer:setItems(utilCfg.proximaBpID)
nextBpContainer:setParent(utilityInterface.flatp.containersBp)
nextBpContainer:fill('parent')

local function getNextBpIdList()
  return properTable(utilCfg.proximaBpID or {})
end

-- ============================================================
-- CONTAINER: ITEMS TO LOOT
-- ============================================================

utilCfg.itemsToLoot = normalizeContainerItems(utilCfg.itemsToLoot or {3031, 3043})

local itemsToLootContainer = UI.ContainerEx(function(_, items)
  utilCfg.itemsToLoot = normalizeContainerItems(items)
  saveUtilitys()
end, true, utilityInterface.flatp.containerItemstoloot)

itemsToLootContainer:setHeight(55)
itemsToLootContainer:setItems(utilCfg.itemsToLoot)
itemsToLootContainer:setParent(utilityInterface.flatp.containerItemstoloot)
itemsToLootContainer:fill('parent')

local function getLootItemsIds()
  return properTable(utilCfg.itemsToLoot or {})
end

-- ============================================================
-- MACRO: OPEN NEXT BP
-- ============================================================
macro(1000, function()
  if utilCfg.proximaBp ~= true then return end

  local containerIds = getNextBpIdList()
  if #containerIds == 0 then return end

  for _, container in pairs(getContainers()) do
    local containerItem = container:getContainerItem()
    if containerItem and table.contains(containerIds, containerItem:getId()) then
      if container:getCapacity() == #container:getItems() then
        for _, item in ipairs(container:getItems()) do
          if table.contains(containerIds, item:getId()) then
            g_game.open(item, container)
            delay(200)
            return
          end
        end
      end
    end
  end
end)

-- ============================================================
-- LOOT REWARD CHEST
-- ============================================================

local containerItemlist = {}

local function printMessage(msg)
  modules.game_textmessage.displayGameMessage(msg)
end

local function closeAll()
  for _, container in pairs(getContainers()) do
    g_game.close(container)
  end
end

local function getRewardChestContainer()
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == tonumber(utilCfg.rewardChestId or 19250) then
      return container
    end
  end
  return nil
end

local function pushContainer(containerItem)
  table.insert(containerItemlist, containerItem)
end

local function popContainer()
  table.remove(containerItemlist, 1)
end

local function openNext()
  local cItem = containerItemlist[1]
  if cItem then
    popContainer()
    g_game.open(cItem)
    return true
  end
  return false
end

local function isContainerInLastPage(container)
  if not container then return true end
  local currentPage = 1 + math.floor(container:getFirstIndex() / container:getCapacity())
  local pages = 1 + math.floor(math.max(0, (container:getSize() - 1)) / container:getCapacity())
  return currentPage == pages
end

local function nextContainerPage(container)
  if not container or not container.window then return end
  local nextPageButton = container.window:recursiveGetChildById('nextPageButton')
  if nextPageButton and nextPageButton.onClick then
    nextPageButton.onClick()
  end
end

local function canCloseRewardContainer(container)
  local lootItemsIds = getLootItemsIds()

  if utilCfg.lootAll == true then
    if #container:getItems() >= 1 then
      return false
    end
  end

  for _, item in ipairs(container:getItems()) do
    if table.find(lootItemsIds, item:getId()) then
      return false
    end
  end

  if container:hasPages() and not isContainerInLastPage(container) then
    nextContainerPage(container)
    return false
  end

  container:getContainerItem().isChecked = true
  container:getContainerItem():hide()
  return true
end

local function closeCheckedContainers()
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == tonumber(utilCfg.rewardContainerId or 19202) and canCloseRewardContainer(container) then
      g_game.close(container)
    end
  end
end

local function addContainersTolist()
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == tonumber(utilCfg.rewardChestId or 19250) then
      for _, item in ipairs(container:getItems()) do
        if item:isContainer() and not item.isAdded then
          item.isAdded = true
          pushContainer(item)
        end
      end
    end
  end
end

local function hasLootedAll()
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == tonumber(utilCfg.rewardContainerId or 19202) then
      if utilCfg.lootAll == true and #container:getItems() > 1 then
        return false
      else
        for _, item in ipairs(container:getItems()) do
          if table.find(getLootItemsIds(), item:getId()) then
            return false
          end
        end
      end
    end
  end
  return true
end

local function finished()
  return #containerItemlist == 0 and hasLootedAll()
end

local function isRewardChestOpen()
  return getRewardChestContainer()
end

local function findAndOpenRewardChest()
  for _, tile in ipairs(g_map.getTiles(posz())) do
    local topT = tile:getTopThing()
    if topT and topT.getId and topT:getId() == tonumber(utilCfg.rewardChestId or 19250) then
      g_game.open(topT)
      return true
    end
  end
  return false
end

local function openBack()
  if getBack() then
    g_game.open(getBack())
  end
end

local function getMainBPId()
  local back = getBack()
  return back and back:getId() or 0
end

local function isContainerOpen(id)
  id = tonumber(id) or 0
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == id then
      return true
    end
  end
  return false
end

local function openContainerId(id)
  id = tonumber(id) or 0
  for _, container in pairs(getContainers()) do
    for _, item in ipairs(container:getItems()) do
      if item:getId() == id then
        return g_game.open(item)
      end
    end
  end
end

local function isContainerFull(id)
  id = tonumber(id) or 0
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == id then
      return #container:getItems() == container:getCapacity()
    end
  end
  return false
end

local function openNextBag()
  local lootBp = tonumber(utilCfg.lootBackpackId or 2854) or 2854

  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == lootBp then
      for _, item in ipairs(container:getItems()) do
        if item:getId() == lootBp then
          g_game.open(item)
          schedule(100, function()
            g_game.close(container)
          end)
          return true
        end
      end
    end
  end

  return false
end

local lootMainDelay = 1000 + (g_game.getPing and g_game.getPing() or 0)

local m_lootReward = macro(lootMainDelay, function(m)
  if utilCfg.LootChest ~= true then return end

  local lootBp = tonumber(utilCfg.lootBackpackId or 2854) or 2854
  local maxOpen = tonumber(utilCfg.maxOpennedContainers or 5) or 5

  if not isRewardChestOpen() then
    closeAll()
    findAndOpenRewardChest()
    delay(2000)
    return
  end

  local mainBpId = getMainBPId()
  if mainBpId > 0 and not isContainerOpen(mainBpId) then
    return openBack()
  end

  if not isContainerOpen(lootBp) then
    return openContainerId(lootBp)
  end

  if isContainerFull(lootBp) then
    if not openNextBag() then
      utilCfg.LootChest = false
      utilityInterface.flatp.LootChest:setOn(false)
      saveUtilitys()
      printMessage("Finished Looting!.")
    end
    return
  end

  closeCheckedContainers()
  addContainersTolist()

  if #getContainers() >= maxOpen then
    return
  end

  if openNext() then
    return
  elseif not isContainerInLastPage(getRewardChestContainer()) then
    return nextContainerPage(getRewardChestContainer())
  end

  if finished() then
    closeAll()
    utilCfg.LootChest = false
    utilityInterface.flatp.LootChest:setOn(false)
    saveUtilitys()
    printMessage("Finished Looting!")
  end
end)

onContainerOpen(function(container, previousContainer)
  if utilCfg.LootChest == true and container and container.window then
    container.window:setHeight(55)
  end
end)

macro(tonumber(utilCfg.lootRewardDelay or 50) or 50, function()
  if utilCfg.LootChest ~= true then return end

  local lootBp = tonumber(utilCfg.lootBackpackId or 2854) or 2854
  local rewardBag = tonumber(utilCfg.rewardContainerId or 19202) or 19202
  local lootItemsIds = getLootItemsIds()

  local itemToMove = nil

  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == rewardBag then
      for _, item in ipairs(container:getItems()) do
        if utilCfg.lootAll == true then
          itemToMove = item
          break
        elseif table.find(lootItemsIds, item:getId()) then
          itemToMove = item
          break
        end
      end
    end
    if itemToMove then break end
  end

  if itemToMove then
    for _, container in pairs(getContainers()) do
      local cItem = container:getContainerItem()
      if cItem and cItem:getId() == lootBp then
        g_game.move(itemToMove, container:getSlotPosition(container:getItemsCount()), itemToMove:getCount())
        return
      end
    end
  end
end)

macro(50, function()
  if utilCfg.dashMouse ~= true then return end

  local tile = getTileUnderCursor()
  if not tile then return end

  local player = g_game.getLocalPlayer()
  if tile:getTopThing() == player then
    return
  end

  local thing = tile:getTopUseThing()
  if thing then
    g_game.use(thing)
  end
end)


local lastEsconderAndaresState = nil

local function getMapPanelSafe()
  if modules and modules.game_interface then
    if modules.game_interface.getMapPanel then
      return modules.game_interface.getMapPanel()
    end

    if modules.game_interface.gameMapPanel then
      return modules.game_interface.gameMapPanel
    end
  end

  return nil
end

local function applyEsconderAndares()
  local gameMapPanel = getMapPanelSafe()
  if not gameMapPanel then return end

  if utilCfg.esconderAndares == true then
    gameMapPanel:lockVisibleFloor(posz())
  else
    gameMapPanel:unlockVisibleFloor()
  end
end

onPlayerPositionChange(function(pos)
  if utilCfg.esconderAndares ~= true then return end

  local gameMapPanel = getMapPanelSafe()
  if gameMapPanel then
    gameMapPanel:lockVisibleFloor(pos.z)
  end
end)

macro(250, function()
  if lastEsconderAndaresState == utilCfg.esconderAndares then return end

  lastEsconderAndaresState = utilCfg.esconderAndares
  applyEsconderAndares()
end)

macro(30000, function()
  if utilCfg.utevoLux ~= true then return end

  local spell = tostring(utilCfg.textutevoLux or "")
  if spell == "" then return end

  say(spell)
end)

macro(500, function()
  if utilCfg.Dancing ~= true then return end
  turn(math.random(0,3))
end)

local posToHold = nil

macro(500, function()
  posToHold = posToHold or pos()
  schedule(50, function() if utilCfg.HoldPosition ~= true then posToHold = nil end end)
  if utilCfg.HoldPosition ~= true then return end
  if table.equals(posToHold, pos()) then return end
  autoWalk(posToHold, 127, {ignoreNonPathable=true, precision=2, ignoreStairs=true})
end)

local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function parseTwoSpells(text)
  text = tostring(text or "")
  local a, b = text:match("^%s*([^,]+)%s*,%s*([^,]+)%s*$")
  if a then
    return trim(a), trim(b or "")
  end
  return trim(text), ""
end

local mtStep = 1
macro(1000, function()
  if utilCfg.manaTrain ~= true then return end

  local s1, s2 = parseTwoSpells(utilCfg.textManaTrain)
  if s1 == "" then return end

  if s2 == "" then
    say(s1)
    delay(500)
    return
  end

  if mtStep == 1 then
    say(s1)
    mtStep = 2
    delay(500)
  else
    say(s2)
    mtStep = 1
    delay(500)
  end
end)

local manaPercent = 30
local heal1 = "Utana Vid"
local heal2 = "Exura vita"

local train = macro(200, function()
  if utilCfg.manaTrainMage ~= true then return end

  local manaPotionId = tonumber(utilCfg.textManaTrainMage or 0) or 0
  if manaPotionId <= 0 then return end

  for i, npc in ipairs(getSpectators()) do
    if npc:isNpc() and (getDistanceBetween(pos(), npc:getPosition()) <= 5) then
      say(heal1)
      say(heal2)
    end

    if manapercent() <= manaPercent then
      usewith(manaPotionId, player)
    end
  end
end)

onTextMessage(function(mode, text)
  if utilCfg.manaTrainMage ~= true then return end

  local mp = 'Using one of ([0-9]*)'
  local re1 = regexMatch(text, mp)
  local tmp = ""

  if #re1 ~= 0 then
    tmp = tonumber(re1[1][2])

    for i, npc2 in ipairs(getSpectators()) do
      if npc2:isNpc() and (getDistanceBetween(pos(), npc2:getPosition()) <= 3) then
        if tmp <= 10 then
          local manaPotionId = tonumber(utilCfg.textManaTrainMage or 0) or 0
          if manaPotionId <= 0 then return end

          NPC.say("hi")
          schedule(1000, function() NPC.say("trade") end)
          schedule(1000, function() NPC.say("potions") end)
          schedule(1500, function() NPC.buy(manaPotionId, 300) end)
          schedule(2000, function() NPC.say("bye") end)
          schedule(2500, function() NPC.closeTrade() end)
        end
      end
    end
  end
end)

local targetID = nil

onKeyPress(function(keys)
  if keys == "Escape" and targetID then
    targetID = nil
  end
end)

macro(100, function()
  if utilCfg.HoldTarget ~= true then return end

  if target() and target():getPosition().z == posz() and not target():isNpc() then
    targetID = target():getId()
  elseif not target() then
    if not targetID then return end

    for i, spec in ipairs(getSpectators()) do
      local sameFloor = spec:getPosition().z == posz()
      local oldTarget = spec:getId() == targetID

      if sameFloor and oldTarget then
        attack(spec)
      end
    end
  end
end)

local vocationsMap = {
  [1] = "Knight", [2] = "Paladin", [3] = "Sorcerer", [4] = "Druid",
  [5] = "Monk",
  [6] = "Elite Knight", [7] = "Royal Paladin", [8] = "Master Sorcerer", [9] = "Elder Druid",
  [10] = "Exalted Monk"
}

local function getVocationType(playerObj)
  if not playerObj then return "knight" end
  local vocId = playerObj:getVocation()
  local vocName = vocationsMap[vocId] or "Unknown"

  if vocName == "Knight" or vocName == "Elite Knight" then
    return "knight"
  elseif vocName == "Paladin" or vocName == "Royal Paladin" then
    return "paladin"
  elseif vocName == "Sorcerer" or vocName == "Master Sorcerer" then
    return "sorcerer"
  elseif vocName == "Druid" or vocName == "Elder Druid" then
    return "druid"
  elseif vocName == "Monk" or vocName == "Exalted Monk" then
    return "monk"
  end

  return "knight"
end

local familiarSpellByVoc = {
  knight   = "utevo gran res eq",
  paladin  = "utevo gran res sac",
  sorcerer = "utevo gran res ven",
  druid    = " utevo gran res dru",
  monk     = "utevo gran res tio"
}

local lastSummon = 0
local summonCooldown = 1 * 60 * 1000

macro(500, function()
  if utilCfg.SummonF ~= true then return end
  if isInPz() then return end

  local playerObj = g_game.getLocalPlayer()
  if not playerObj then return end

  local vocType = getVocationType(playerObj)
  local spell = familiarSpellByVoc[vocType]
  if not spell or spell == "" then return end

  say(spell)
  delay(10000)
end)

macro(500, function()
  if utilCfg.AutoMount ~= true then return end
  if isInPz() then return end

  local outfit = player:getOutfit()
  local isMounted = outfit.mount ~= nil and outfit.mount > 0

  if not isMounted then
    player:mount()
  end
end)

local secondsToIdle = 5
local activeFPS = 60
local afkFPS = 5

function botPrintMessage(message)
  modules.game_textmessage.displayGameMessage(message)
end

local function isSameMousePos(p1, p2)
  return p1.x == p2.x and p1.y == p2.y
end

local function setAfk()
  modules.client_options.setOption("backgroundFrameRate", afkFPS)
  modules.game_interface.gameMapPanel:hide()
end

local function setActive()
  modules.client_options.setOption("backgroundFrameRate", activeFPS)
  modules.game_interface.gameMapPanel:show()
end

local lastMousePos = nil
local finalMousePos = nil
local idleCount = 0
local maxIdle = secondsToIdle * 4

macro(250, function()
  if utilCfg.SleepMode ~= true then return end

  local currentMousePos = g_window.getMousePosition()

  if finalMousePos then
    if isSameMousePos(finalMousePos, currentMousePos) then return end
    setActive()
    finalMousePos = nil
  end

  if lastMousePos and isSameMousePos(lastMousePos, currentMousePos) then
    idleCount = idleCount + 1
  else
    lastMousePos = currentMousePos
    idleCount = 0
  end

  if idleCount == maxIdle then
    setAfk()
    finalMousePos = currentMousePos
    idleCount = 0
  end
end)

onAddThing(function(tile, thing)
  if utilCfg.EsconderSprites ~= true then return end
  if thing:isEffect() then
    thing:hide()
  end
end)

onStaticText(function(thing, text)
  if utilCfg.EsconderTextos ~= true then return end
  if not text:find('says:') then
    g_map.cleanTexts()
  end
end)

onTextMessage(function(mode, text)
  if utilCfg.EsconderTextos ~= true then return end
  modules.game_textmessage.clearMessages()
  g_map.cleanTexts()
end)

macro(5000, function()
  if utilCfg.AutoBan ~= true then return end

  for _, child in ipairs(g_ui.getRootWidget():recursiveGetChildren()) do
    if child:getId() and child:getId():find("consoleLabel") then
      local text = child:getText():lower()
      text = string.sub(text, 6, #text)

      if text:find("spectator") and text:find("joined") then
        talkChannel(9, "!cast ban," .. getFirstNumberInText(text))
        child:destroy()
      end
    end
  end
end)

local wallHuggerConfig = {
  mobs = 2,
  mobDist = 7,
  chase = true,
  wallDist = 8,
  maxNearWalkableTiles = 3,

  ignoreIds = {
    [1949] = true,
  }
}

local function isIgnoredTile(tile)
  if not tile then return false end

  local things = tile:getThings()
  if not things then return false end

  for _, thing in ipairs(things) do
    if wallHuggerConfig.ignoreIds[thing:getId()] then
      return true
    end
  end

  return false
end

local s = {}

s.getNearTiles = function(pos)
  if type(pos) ~= "table" then pos = pos:getPosition() end

  local tiles = {}
  local dirs = {
      {-1, 1}, {0, 1}, {1, 1}, {-1, 0}, {1, 0}, {-1, -1}, {0, -1}, {1, -1}
  }

  for i = 1, #dirs do
      local tile = g_map.getTile({
          x = pos.x - dirs[i][1],
          y = pos.y - dirs[i][2],
          z = pos.z
      })
      if tile then table.insert(tiles, tile) end
  end

  return tiles
end

s.getMonsters = function(pos, range)
  if not pos or not range then return 0 end

  local monsters = 0
  for _, spec in pairs(getSpectators()) do
    if spec:isMonster() and getDistanceBetween(pos, spec:getPosition()) < range then
      monsters = monsters + 1
    end
  end

  return monsters
end

s.getWallTiles = function()
  local tiles = {}

  for _, t in ipairs(g_map.getTiles(posz())) do
    local tPos = t:getPosition()
    local dist = getDistanceBetween(pos(), tPos)

    if dist <= wallHuggerConfig.wallDist and not t:isWalkable() and not isIgnoredTile(t) then
      table.insert(tiles, t)
    end
  end

  return tiles
end

s.getNearWalkableTilesCount = function(tile)
  local c = 0

  for _, t in ipairs(s.getNearTiles(tile:getPosition())) do
    if t and t:isWalkable() then
      c = c + 1
    end
  end

  return c
end

s.getActualWalkPos = function(tile)
  local madeByVivoDibra = true
  if not tile then return nil end

  local tiles = {}
  if not madeByVivoDibra then return end

  for _, tt in ipairs(s.getNearTiles(tile:getPosition())) do
    local ttPos = tt:getPosition()

    if tt and tt:isWalkable() and not tt:getCreatures()[1] and findPath(pos(), ttPos, 50) then
      for _, t in ipairs(s.getNearTiles(ttPos)) do
        if t and t:isWalkable() then
          tt.sqmCount = (tt.sqmCount and tt.sqmCount + 1) or 1
        end
      end

      table.insert(tiles, tt)
    end
  end

  table.sort(tiles, function(x, y)
    return x.sqmCount < y.sqmCount
  end)

  local p = tiles[1] and tiles[1]:getPosition()

  for _, t in ipairs(tiles) do
    t.sqmCount = nil
  end

  return p
end

s.currentGotoPos = nil

s.setCurrentGotoPos = function()
  if s.currentGotoPos then return end

  local wallTiles = s.getWallTiles()

  for i, t in ipairs(wallTiles) do
    local c = s.getNearWalkableTilesCount(t)
    if c > wallHuggerConfig.maxNearWalkableTiles then
      table.remove(wallTiles, i)
    end
  end

  table.sort(wallTiles, function(x, y)
    local distX = getDistanceBetween(x:getPosition(), pos())
    local distY = getDistanceBetween(y:getPosition(), pos())
    return distX < distY
  end)
  
  s.currentGotoPos = s.getActualWalkPos(wallTiles[1])
end

s.walkToGoto = function()
  if s.currentGotoPos then
    local t = g_map.getTile(s.currentGotoPos)
    if t then
      t:setTimer(1000, "yellow")
    end

    autoWalk(s.currentGotoPos, 20, {precision=0, ignoreLastCreature=true})
  end
end

s.setChase = function(on)
  if wallHuggerConfig.chase then
    g_game.setChaseMode(on and 1 or 0)
  end
end

s.gotoWall = function()
  s.setChase(false)
  s.setCurrentGotoPos()
  s.walkToGoto()
end

s.proceedHunting = function()
  s.setChase(true)
  s.currentGotoPos = nil
end

s.reset = function(m)
  schedule(1000, function()
    if m.isOff() then
      s.currentGotoPos = nil
    end
  end)
end

macro(1000, function(m)
  if utilCfg.WallHugger ~= true then
    s.currentGotoPos = nil
    return
  end

  local mobs = s.getMonsters(pos(), wallHuggerConfig.mobDist)

  if mobs >= wallHuggerConfig.mobs then
    s.gotoWall()
  else
    s.proceedHunting()
  end

  s.reset(m)
end)

local exetaLootDelay = 1000
local nextExeta = 0

onCreatureDisappear(function(creature)
  if utilCfg.ExetaLoot ~= true then return end
  if nextExeta > now then return end
  if isInPz() then return end
  if not creature:isMonster() then return end

  local pos = player:getPosition()
  local mpos = creature:getPosition()

  if pos.z ~= mpos.z or getDistanceBetween(pos, mpos) > 1 then return end

  schedule(100, function()
    local tile = g_map.getTile(mpos)
    if not tile then return end

    local container = tile:getTopUseThing()
    if not container or not container:isContainer() then return end

    nextExeta = now + exetaLootDelay
    say("exeta loot")
  end)
end)

local autoAolConfig = {
  AOLId = 3057
}

macro(200, function()
  if utilCfg.autoAol ~= true then return end

  local hasAol = getNeck() and getNeck():getId() == autoAolConfig.AOLId
  if hasAol then return end

  local aol = findItem(autoAolConfig.AOLId)
  if aol then
    moveToSlot(aol, SlotNeck, 1)
  else
    say("!aol")
    delay(1000)
  end
end)


local pushKina = 0
local pushPallyMonk = 0
local exetaCD = 0

local function getVocType()
  local vocId = player:getVocation()
  if vocId == 1 or vocId == 6 then
    return "knight"
  elseif vocId == 2 or vocId == 7 then
    return "paladin"
  elseif vocId == 5 or vocId == 10 then
    return "monk"
  end

  return ""
end
local vocType = getVocType()

macro(200, function()
  if utilCfg.AmpRes ~= true then return end
  if isInPz() then return end
  if g_game.isAttacking() then

    if vocType == "knight" and (not pushKina or pushKina <= now) and mana() >= 200 then
      say("exeta amp res")
    elseif vocType == "paladin" and (not pushPallyMonk or pushPallyMonk <= now) and mana() >= 200 then
      say("exana amp res")
    elseif vocType == "monk" and (not pushPallyMonk or pushPallyMonk <= now) and mana() >= 200 then
      say("exori mas res")
    end
  end
end)

macro(200, function()
  if utilCfg.ExetaRes ~= true then return end
  if not g_game.isAttacking() then return end

  local target = g_game.getAttackingCreature()
  if not target then return end

  if distanceFromPlayer(target:getPosition()) <= 1 and manapercent() > 30 and (not exetaCD or exetaCD <= now) then
    say("exeta res")
  end
end)

onTalk(function(name, _, _, text)
  if name ~= player:getName() then return end
  text = tostring(text or ""):lower()
  if text == "exeta amp res" then
    pushKina = now + 6100
  end
  if text == "exana amp res" or text == "exori mas res" then
    pushPallyMonk = now + 15200
  end
  if text == "exeta res" or text == "Exeta Res" then
    exetaCD = now + 2500
  end
end)

BugMap = {}

local consoleTextEdit = g_ui.getRootWidget():recursiveGetChildById('consoleTextEdit')

local availableKeys = {
  ['W'] = { 0, -3 },
  ['S'] = { 0, 3 },
  ['A'] = { -3, 0 },
  ['D'] = { 3, 0 },
  ['C'] = { 3, 3 },
  ['Z'] = { -3, 3 },
  ['Q'] = { -3, -3 },
  ['E'] = { 3, -3 }
}

local function safeIsMobile()
  if g_app and type(g_app.isMobile) == "function" then
    local ok, res = pcall(function() return g_app:isMobile() end)
    if ok then return res == true end
  end
  return false
end

local isMobile = safeIsMobile()

macro(100, function()
  if utilCfg.SuperDash ~= true or isMobile then return end
  if modules.game_console:isChatEnabled() then return end

  local playerPos = pos()
  local tile

  for key, value in pairs(availableKeys) do
    if modules.corelib.g_keyboard.isKeyPressed(key) then
      playerPos.x = playerPos.x + value[1]
      playerPos.y = playerPos.y + value[2]
      tile = g_map.getTile(playerPos)
      break
    end
  end

  if not tile then return end

  g_game.use(tile:getTopUseThing())

  local item = tile:getTopUseThing()
  if item then
    g_game.useWith(item, g_game.getLocalPlayer())
    g_game.use(item)
  end
end)

local function checkPos(x, y)
  local xyz = g_game.getLocalPlayer():getPosition()
  xyz.x = xyz.x + x
  xyz.y = xyz.y + y

  local tile = g_map.getTile(xyz)
  if tile then
    return g_game.use(tile:getTopUseThing())
  end

  return false
end

macro(200, function()
  if utilCfg.SuperDash ~= true then return end

  if modules.corelib.g_keyboard.isKeyPressed('W') then
    turn(0)
  elseif modules.corelib.g_keyboard.isKeyPressed('S') then
    turn(2)
  elseif modules.corelib.g_keyboard.isKeyPressed('A') then
    turn(3)
  elseif modules.corelib.g_keyboard.isKeyPressed('D') then
    turn(1)
  end
end)

local cursorWidget = g_ui.getRootWidget():recursiveGetChildById('pointer')
if cursorWidget then
  local initialPos = {
    x = cursorWidget:getPosition().x / cursorWidget:getWidth(),
    y = cursorWidget:getPosition().y / cursorWidget:getHeight()
  }

  local availableKeys2 = {
    Up    = { 0, -6 },
    Down  = { 0,  6 },
    Left  = { -7, 0 },
    Right = { 7,  0 }
  }

  macro(100, function()
    if utilCfg.SuperDash ~= true then return end

    local myPos = pos()
    if not myPos then return end

    local keypadPos = {
      x = cursorWidget:getPosition().x / cursorWidget:getWidth(),
      y = cursorWidget:getPosition().y / cursorWidget:getHeight()
    }

    local diffPos = {
      x = initialPos.x - keypadPos.x,
      y = initialPos.y - keypadPos.y
    }

    if diffPos.y < 0.46 and diffPos.y > -0.46 then
      if diffPos.x > 0 then
        myPos.x = myPos.x + availableKeys2.Left[1]
      elseif diffPos.x < 0 then
        myPos.x = myPos.x + availableKeys2.Right[1]
      else
        return
      end
    elseif diffPos.x < 0.46 and diffPos.x > -0.46 then
      if diffPos.y > 0 then
        myPos.y = myPos.y + availableKeys2.Up[2]
      elseif diffPos.y < 0 then
        myPos.y = myPos.y + availableKeys2.Down[2]
      else
        return
      end
    else
      return
    end

    local tile = g_map.getTile(myPos)
    if not tile then return end

    local top = tile:getTopUseThing()
    if not top then return end

    g_game.use(top)
  end)
end
end
