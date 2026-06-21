warning = function() 
    return  
end
warn = function() 
    return  
end
error = function() 
    return  
end

print("ARCHIVE1 OK")

do
  ----- ATTACKBOT
if not loadCharStorage or not saveCharStorage or not loadNamedSharedStorage or not saveNamedSharedStorage then
  return warn("[AttackBot] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()
sharedStorage_attackbot = sharedStorage_attackbot or loadNamedSharedStorage("settings_attackbot")

sharedStorage_attackbot.attackBotShared = sharedStorage_attackbot.attackBotShared or {}
sharedStorage_attackbot.attackBotShared.safeIdsAndares =
  normalizeSharedMap(sharedStorage_attackbot.attackBotShared.safeIdsAndares)

local function saveAttackBotChar()
  saveCharStorage(charStorage)
end

local function saveAttackBotShared()
  local diskData = loadNamedSharedStorage("settings_attackbot")
  diskData.attackBotShared = diskData.attackBotShared or {}

  diskData.attackBotShared.safeIdsAndares =
    mergeSharedMaps(
      diskData.attackBotShared.safeIdsAndares,
      sharedStorage_attackbot.attackBotShared.safeIdsAndares
    )

  sharedStorage_attackbot.attackBotShared.safeIdsAndares =
    diskData.attackBotShared.safeIdsAndares

  saveNamedSharedStorage("settings_attackbot", diskData)
end

switchCombo = "comboButton"
charStorage[switchCombo] = charStorage[switchCombo] or { enabled = false }

comboButton = setupUI([[
Panel
  height: 40
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: AttackBot
    height: 18
    color: white

  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Config
    opacity: 1.00
    color: white

  Button
    id: 1
    anchors.top: prev.bottom
    anchors.left: parent.left
    text: 1
    margin-right: 2
    margin-top: 4
    size: 17 17

  Button
    id: 2
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    text: 2
    margin-left: 4
    size: 17 17
    
  Button
    id: 3
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    text: 3
    margin-left: 4
    size: 17 17

  Button
    id: 4
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    text: 4
    margin-left: 4
    size: 17 17 
    
  Button
    id: 5
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    text: 5
    margin-left: 4
    size: 17 17
    
  Label
    id: name
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: parent.right
    text-align: center
    margin-left: 4
    height: 17
    text: Prof.: #1
    background: #292A2A
]])
comboButton:setId(switchCombo)
comboButton.title:setOn(charStorage[switchCombo].enabled)
comboButton.title.onClick = function(widget)
  local state = not widget:isOn()
  widget:setOn(state)
  charStorage[switchCombo].enabled = state
  saveAttackBotChar()
end

comboInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 310 388
  text: Panel AttackBot
  margin-top: -50

  Button
    id: tabConfig
    checkable: true
    anchors.top: parent.top
    anchors.left: parent.left
    height: 33
    margin-left: -5
    width: 144
    text-align: center
    text: Config

    UIItem
      id: idConfig
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -4
      margin-left: -9
      size: 33 33
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: prev.right
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 0
      margin-right: 8
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  Button
    id: tabAntired
    checkable: true
    anchors.verticalCenter: tabConfig.verticalCenter
    anchors.left: tabConfig.right
    height: 33
    margin-left: 0
    width: 145
    text-align: center
    text: Antired

    UIItem
      id: idAntired
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -4
      margin-left: -9
      size: 33 33
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: prev.right
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 0
      margin-right: 8
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  FlatPanel
    id: flatConfig
    anchors.top: tabConfig.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-bottom: 20
    margin-left: -5
    margin-top: 6
    margin-right: -5

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Configuration Spells & Runes
      margin-top: 6
      font: verdana-11px-rounded
      text-auto-resize: true

    HorizontalSeparator
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 8
      margin-right: 8

    TextList
      id: spellList
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-bottom: 33
      margin-top: 5
      margin-left: 8
      margin-right: 16
      padding: 1
      vertical-scrollbar: spellListScrollBar
      opacity: 0.95
      font: verdana-11px-rounded

    VerticalScrollBar
      id: spellListScrollBar
      anchors.top: spellList.top
      anchors.bottom: spellList.bottom
      anchors.left: spellList.right
      step: 10
      pixels-scroll: true
      visible: true
      border: 1 #1f1f1f
      image-color: #363636
      opacity: 0.90
      margin-left: 0

    Button
      id: adicionarSpell
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      margin-left: 8
      margin-bottom: 6
      width: 135
      height: 20
      text: Add Spell

    Button
      id: adicionarRuna
      anchors.right: parent.right
      anchors.verticalCenter: adicionarSpell.verticalCenter
      margin-right: 8
      width: 135
      height: 20
      text: Add Rune

  FlatPanel
    id: flatAntired
    anchors.top: flatConfig.top
    anchors.left: flatConfig.left
    anchors.right: flatConfig.right
    anchors.bottom: flatConfig.bottom

    HorizontalScrollBar
      id: minutosVoltarUnsafe
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      margin-left: 8
      margin-right: 8
      margin-top: 8
      minimum: 1
      maximum: 120
      step: 1

    Label
      id: labelReactiveUnsafe
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.verticalCenter: prev.verticalCenter
      text: Reactive in: 5 min
      margin-top: -1
      text-align: center
      text: Reactive in:

    BotSwitch
      id: manterDist
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: prev.bottom
      margin-top: 5
      margin-left: 8
      margin-right: 8
      height: 18
      text: Pause Spells Unsafe

    HorizontalSeparator
      id: HsepFrags
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 8
      margin-left: 8
      margin-right: 8

    HorizontalScrollBar
      id: qtdeFrags
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.top: prev.bottom
      margin-top: 8
      minimum: 1
      maximum: 8
      step: 1

    Label
      id: labelExitFrags
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.verticalCenter: prev.verticalCenter
      text: Amount Frags: 1
      margin-top: -1
      text-align: center

    BotSwitch
      id: deslogarFrags
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.top: prev.bottom
      margin-top: 5
      height: 18
      text: Exit on Frags

    HorizontalSeparator
      id: HsepFrags
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 8
      margin-left: 8
      margin-right: 8

    HorizontalScrollBar
      id: distSegura
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: prev.bottom
      margin-top: 6
      margin-left: 8
      margin-right: 8
      minimum: 1
      maximum: 12
      step: 1

    Label
      id: labelDistSegura
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.verticalCenter: prev.verticalCenter
      text: Dist Check Players: 0
      margin-top: -1
      text-align: center

    Panel
      id: checkPlayersLine
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.top: prev.bottom
      margin-top: 5
      height: 20

      BotSwitch
        id: checkPlayers
        anchors.left: parent.left
        anchors.top: parent.top
        width: 132
        height: 18
        text: Check Players

      BotSwitch
        id: checkFloors
        anchors.left: checkPlayers.right
        anchors.right: parent.right
        anchors.top: parent.top
        margin-left: 4
        height: 18
        text: Other Floors

    HorizontalSeparator
      id: HsepFrags
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 8
      margin-left: 8
      margin-right: 8

    HorizontalScrollBar
      id: distStairs
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.top: prev.bottom
      margin-top: 7
      minimum: 1
      maximum: 12
      step: 1

    Label
      id: labelDistStairs
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.verticalCenter: prev.verticalCenter
      text: Dist Check Stairs: 0
      margin-top: -1
      text-align: center

    Panel
      id: idsSafeAndares
      anchors.top: prev.bottom
      margin-top: 5
      anchors.left: prev.left
      anchors.right: prev.right
      height: 74

    BotSwitch
      id: checkStairs
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.top: prev.bottom
      margin-top: -1
      height: 18
      text: Check Stairs

  Button
    id: closePanel
    anchors.left: flatConfig.left
    anchors.right: flatConfig.right
    anchors.top: flatConfig.bottom
    height: 20
    margin-top: 5
    text: Close
]=], g_ui.getRootWidget())
comboInterface:hide()

local function WAttackBotPanel(root, id)
  if not root or not id then return nil end

  if root.getChildById then
    local ok, child = pcall(function() return root:getChildById(id) end)
    if ok and child then return child end
  end

  if root.recursiveGetChildById then
    local ok, child = pcall(function() return root:recursiveGetChildById(id) end)
    if ok and child then return child end
  end

  if root.getChildren then
    local ok, childs = pcall(function() return root:getChildren() end)
    if ok and childs then
      for i = 1, #childs do
        local found = WAttackBotPanel(childs[i], id)
        if found then return found end
      end
    end
  end

  return nil
end

local function bindAttackBotPanelIds()
  local ids = {
    "tabConfig", "tabAntired", "flatConfig", "flatAntired",
    "spellList", "spellListScrollBar", "adicionarSpell", "adicionarRuna",
    "labelReactiveUnsafe", "minutosVoltarUnsafe", "manterDist", "labelExitFrags",
    "qtdeFrags", "deslogarFrags", "labelDistSegura", "distSegura",
    "checkPlayers", "checkFloors", "labelDistStairs", "distStairs",
    "idsSafeAndares", "checkStairs", "closePanel"
  }

  for i = 1, #ids do
    local id = ids[i]
    if not comboInterface[id] then
      comboInterface[id] = WAttackBotPanel(comboInterface, id)
    end
  end
end

local function showAttackBotWidget(widget, visible)
  if not widget then return end
  if visible then
    if widget.show then widget:show() end
  else
    if widget.hide then widget:hide() end
  end
end

local function setAttackBotTabPressed(button, pressed)
  if not button then return end
  showAttackBotWidget(WAttackBotPanel(button, "activeLine"), pressed)

  if button.setChecked then pcall(function() button:setChecked(pressed) end) end
  if button.setPressed then pcall(function() button:setPressed(pressed) end) end
  if button.setOn then pcall(function() button:setOn(pressed) end) end

  if button.setOpacity then button:setOpacity(pressed and 1.00 or 0.74) end
  if button.setColor then button:setColor(pressed and "#d7c08a" or "#d6d6d6") end
end

local function setAttackBotPanelTab(tab)
  if tab ~= "config" and tab ~= "antired" then tab = "config" end

  showAttackBotWidget(comboInterface.flatConfig, tab == "config")
  showAttackBotWidget(comboInterface.flatAntired, tab == "antired")

  setAttackBotTabPressed(comboInterface.tabConfig, tab == "config")
  setAttackBotTabPressed(comboInterface.tabAntired, tab == "antired")
end

bindAttackBotPanelIds()

local function setAttackBotIcon(widget, id)
  if widget and widget.setItemId then
    pcall(function() widget:setItemId(tonumber(id) or 0) end)
  end
end

if comboInterface.tabConfig and not comboInterface.tabConfig.idConfig then
  comboInterface.tabConfig.idConfig = WAttackBotPanel(comboInterface.tabConfig, "idConfig")
end

if comboInterface.tabAntired and not comboInterface.tabAntired.idAntired then
  comboInterface.tabAntired.idAntired = WAttackBotPanel(comboInterface.tabAntired, "idAntired")
end

-- Troque estes IDs se quiser outros icones nas abas.
setAttackBotIcon(comboInterface.tabConfig and comboInterface.tabConfig.idConfig, 3283)
setAttackBotIcon(comboInterface.tabAntired and comboInterface.tabAntired.idAntired, 37338)

if comboInterface.tabConfig then
  comboInterface.tabConfig.onClick = function()
    setAttackBotPanelTab("config")
  end
end

if comboInterface.tabAntired then
  comboInterface.tabAntired.onClick = function()
    setAttackBotPanelTab("antired")
  end
end

setAttackBotPanelTab("config")

if g_app and g_app.isMobile and g_app.isMobile() then
  comboInterface:setSize("350 505")
end

comboButton.settings.onClick = function()
  if not comboInterface:isVisible() then
    comboInterface:show()
    comboInterface:raise()
    comboInterface:focus()
  end
end
comboInterface.closePanel.onClick = function() comboInterface:hide() end

spellAddPanel = setupUI([=[
MainWindow
  id: spellAddPanel
  size: 260 310
  anchors.centerIn: parent
  margin-top: -50
  text: Insert Spell AttackBot

  ComboBox
    id: selectType
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    margin-top: 0
    margin-left: -6
    margin-right: -6
    height: 22
    @onSetup: |
        self:addOption("Editable")
        self:addOption("Knight")
        self:addOption("Paladin")
        self:addOption("Monk")
        self:addOption("Mage")

  FlatPanel
    id: panelMain
    anchors.top: prev.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    height: 215
    margin: -6
    margin-top: 5

    Label
      id: magiaLabel
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      text: Spell Name:
      margin-left: 5
      margin-right: 5
      margin-top: 4
      font: verdana-11px-rounded

    TextEdit
      id: magia
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      placeholder: Insert spell here
      visible: true

    ComboBox
      id: magiaSelect
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.top: prev.top
      anchors.bottom: prev.bottom
      visible: false
      @onSetup: |
          self:addOption(" ")

    Label
      id: distanceLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Distance:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: distance
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 1
      maximum: 12
      step: 1

    Label
      id: manaLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Mana:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: mana
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 0
      maximum: 1000
      step: 10

    Label
      id: mobsLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Mobs:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: mobs
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 1
      maximum: 10
      step: 1

    Label
      id: cdLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Cooldown:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: cooldown
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      margin-right: 15
      minimum: 0
      maximum: 60000
      step: 1

    Button
      id: calculeCooldown
      anchors.top: prev.top
      anchors.left: prev.right
      anchors.right: cdLabel.right
      text: T
      width: 10
      height: 13
      margin-left: 2
      font: verdana-11px-rounded

    CheckBox
      id: safe
      anchors.top: prev.bottom
      anchors.left: cdLabel.left
      margin-top: 10
      text: Spell Safe?
      font: verdana-11px-rounded
      text-auto-resize: true

  Button
    id: cancelarBt
    anchors.left: panelMain.left
    anchors.top: panelMain.bottom
    width: 120
    margin-top: 5
    text: Cancel
    font: verdana-11px-rounded

  Button
    id: adicionarBt
    anchors.right: panelMain.right
    anchors.top: panelMain.bottom
    width: 120
    margin-top: 5
    text: Insert
    font: verdana-11px-rounded
]=], g_ui.getRootWidget())
spellAddPanel:hide()

runeAddPanel = setupUI([=[
MainWindow
  id: runeAddPanel
  size: 220 210
  anchors.centerIn: parent
  margin-top: -50
  text: Insert Rune AttackBot

  FlatPanel
    id: panelMain
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.left: parent.left
    height: 150
    margin: -6
    margin-top: 0

    Label
      id: runaLabel
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      text: Rune ID:
      margin-left: 5
      margin-right: 5
      margin-top: 15
      font: verdana-11px-rounded

    BotItem
      id: runa
      anchors.top: prev.top
      anchors.right: parent.right
      margin-right: 8
      margin-top: -10

    Label
      id: distanceLabel
      anchors.top: prev.bottom
      anchors.left: runaLabel.left
      anchors.right: parent.right
      margin-top: 4
      margin-right: 5
      text: Distance:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: distance
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 1
      maximum: 12
      step: 1

    Label
      id: mobsLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Mobs:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: mobs
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 1
      maximum: 10
      step: 1

    CheckBox
      id: safe
      anchors.top: mobs.bottom
      anchors.left: distanceLabel.left
      margin-top: 14
      text: Rune Safe?
      font: verdana-11px-rounded
      text-auto-resize: true

  Button
    id: cancelarBt
    anchors.left: panelMain.left
    anchors.top: panelMain.bottom
    width: 100
    margin-top: 5
    text: Cancel
    font: verdana-11px-rounded

  Button
    id: adicionarBt
    anchors.right: panelMain.right
    anchors.top: panelMain.bottom
    width: 100
    margin-top: 5
    text: Insert
    font: verdana-11px-rounded
]=], g_ui.getRootWidget())
runeAddPanel:hide()

profileNamePanel = setupUI([=[
MainWindow
  id: attackProfileNamePanel
  size: 260 120
  anchors.centerIn: parent
  margin-top: -50
  text: Rename AttackBot Profile

  FlatPanel
    id: panelMain
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 58
    margin: -6
    margin-top: 0

    Label
      id: info
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-left: 5
      margin-right: 5
      margin-top: 5
      text: Nome do profile:
      font: verdana-11px-rounded

    TextEdit
      id: profileName
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      placeholder: #N/D

  Button
    id: cancelarBt
    anchors.left: panelMain.left
    anchors.top: panelMain.bottom
    width: 120
    margin-top: 5
    text: Cancel
    font: verdana-11px-rounded

  Button
    id: salvarBt
    anchors.right: panelMain.right
    anchors.top: panelMain.bottom
    width: 120
    margin-top: 5
    text: Save
    font: verdana-11px-rounded
]=], g_ui.getRootWidget())
profileNamePanel:hide()


local sharedCfg = sharedStorage_attackbot.attackBotShared

local function cleanAttackProfileName(text)
  text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
  if #text > 18 then
    text = text:sub(1, 18)
  end
  return text
end

local function defaultAttackBotProfile()
  return {
    name = "",
    main = {
      manterDist = false,
      checkPlayers = false,
      checkStairs = false,
      checkFloors = false,
      distSegura = 10,
      distStairs = 6,

      minutosVoltarUnsafe = 5,
      disabledByUnsafePK = {},
      reenableUnsafeAt = 0,
      qtdeFrags = 1,
      deslogarFrags = false,
      fragsAtual = 0
    },
    attacks = {}
  }
end

charStorage.attackBotProfiles = charStorage.attackBotProfiles or {
  activeProfile = 1,
  profiles = {}
}

for i = 1, 5 do
  charStorage.attackBotProfiles.profiles[i] =
    charStorage.attackBotProfiles.profiles[i] or defaultAttackBotProfile()
end

charStorage.attackBotProfiles.activeProfile =
  math.max(1, math.min(5, tonumber(charStorage.attackBotProfiles.activeProfile) or 1))

charStorage.attackBotMonkHarmony = charStorage.attackBotMonkHarmony or { points = 0 }

local function getActiveAttackProfileIndex()
  return math.max(1, math.min(5, tonumber(charStorage.attackBotProfiles.activeProfile) or 1))
end

local function getActiveAttackProfile()
  local idx = getActiveAttackProfileIndex()
  charStorage.attackBotProfiles.profiles[idx] =
    charStorage.attackBotProfiles.profiles[idx] or defaultAttackBotProfile()

  local p = charStorage.attackBotProfiles.profiles[idx]
  p.main = p.main or defaultAttackBotProfile().main
  p.attacks = p.attacks or {}

  p.main.minutosVoltarUnsafe = tonumber(p.main.minutosVoltarUnsafe) or 5
  p.main.disabledByUnsafePK = type(p.main.disabledByUnsafePK) == "table" and p.main.disabledByUnsafePK or {}
  p.main.reenableUnsafeAt = tonumber(p.main.reenableUnsafeAt) or 0
  p.main.qtdeFrags = tonumber(p.main.qtdeFrags) or 1
  p.main.deslogarFrags = p.main.deslogarFrags == true
  p.main.fragsAtual = tonumber(p.main.fragsAtual) or 0

  -- limpa sobras de versoes antigas que tinham logica antiga de pause por frag
  p.main.disabledByFrag = nil

  return p
end

local function getAttackProfile(idx)
  idx = math.max(1, math.min(5, tonumber(idx) or 1))
  charStorage.attackBotProfiles.profiles[idx] =
    charStorage.attackBotProfiles.profiles[idx] or defaultAttackBotProfile()

  local p = charStorage.attackBotProfiles.profiles[idx]
  p.name = cleanAttackProfileName(p.name)
  p.main = p.main or defaultAttackBotProfile().main
  p.attacks = p.attacks or {}
  return p
end

local function getAttackProfileDisplayName(idx)
  idx = math.max(1, math.min(5, tonumber(idx) or 1))
  local p = getAttackProfile(idx)
  local name = cleanAttackProfileName(p.name)

  if name ~= "" then
    return name
  end

  return "#" .. idx
end

local cfg = getActiveAttackProfile()

local function refreshAttackProfileButtons()
  local active = getActiveAttackProfileIndex()

  for i = 1, 5 do
    local btn = comboButton and comboButton[tostring(i)]
    if btn then
      local isActive = (i == active)

      if btn.setOn then
        btn:setOn(isActive)
      end

      if btn.setColor then
        btn:setColor(isActive and "white" or "white")
      end

      if btn.setBackgroundColor then
        btn:setBackgroundColor(isActive and "alpha" or "alpha")
      end

      if btn.setImageColor then
        btn:setImageColor(isActive and "green" or "gray")
      end

      if btn.setOpacity then
        btn:setOpacity(isActive and 1.0 or 0.85)
      end

      if btn.setTooltip then
        btn:setTooltip("Profile " .. i .. ": " .. getAttackProfileDisplayName(i))
      end
    end
  end
end

local function refreshAttackProfileLabel()
  if comboButton and comboButton.name then
    comboButton.name:setText(getAttackProfileDisplayName(getActiveAttackProfileIndex()))
  end
  refreshAttackProfileButtons()
end

local function setActiveAttackProfile(idx)
  idx = math.max(1, math.min(5, tonumber(idx) or 1))
  charStorage.attackBotProfiles.activeProfile = idx
  cfg = getActiveAttackProfile()

  if comboInterface and comboInterface.distSegura then
    comboInterface.distSegura:setValue(cfg.main.distSegura or 10)
  end
  if comboInterface and comboInterface.labelDistSegura then
    comboInterface.labelDistSegura:setText("Dist Check Players: " .. (cfg.main.distSegura or 10))
  end

  if comboInterface and comboInterface.distStairs then
    comboInterface.distStairs:setValue(cfg.main.distStairs or 6)
  end
  if comboInterface and comboInterface.labelDistStairs then
    comboInterface.labelDistStairs:setText("Dist Check Stairs: " .. (cfg.main.distStairs or 6))
  end

  if comboInterface and comboInterface.manterDist then
    comboInterface.manterDist:setOn(cfg.main.manterDist == true)
  end
  if comboInterface and comboInterface.minutosVoltarUnsafe then
    comboInterface.minutosVoltarUnsafe:setValue(cfg.main.minutosVoltarUnsafe or 5)
  end
  if comboInterface and comboInterface.labelReactiveUnsafe then
    comboInterface.labelReactiveUnsafe:setText("Reactive in: " .. (cfg.main.minutosVoltarUnsafe or 5) .. " min")
  end
  if comboInterface and comboInterface.qtdeFrags then
    comboInterface.qtdeFrags:setValue(cfg.main.qtdeFrags or 1)
  end
  if comboInterface and comboInterface.labelExitFrags then
    comboInterface.labelExitFrags:setText("Amount Frags: " .. (cfg.main.qtdeFrags or 1))
  end
  if comboInterface and comboInterface.deslogarFrags then
    comboInterface.deslogarFrags:setOn(cfg.main.deslogarFrags == true)
  end
  if comboInterface and comboInterface.checkPlayers then
    comboInterface.checkPlayers:setOn(cfg.main.checkPlayers == true)
  end
  if comboInterface and comboInterface.checkStairs then
    comboInterface.checkStairs:setOn(cfg.main.checkStairs == true)
  end
  if comboInterface and comboInterface.checkFloors then
    comboInterface.checkFloors:setOn(cfg.main.checkFloors == true)
  end

  cfg.main.disabledByUnsafePK = type(cfg.main.disabledByUnsafePK) == "table" and cfg.main.disabledByUnsafePK or {}
  cfg.main.reenableUnsafeAt = tonumber(cfg.main.reenableUnsafeAt) or 0
  cfg.main.qtdeFrags = tonumber(cfg.main.qtdeFrags) or 1
  cfg.main.deslogarFrags = cfg.main.deslogarFrags == true
  cfg.main.fragsAtual = tonumber(cfg.main.fragsAtual) or 0
  cfg.main.disabledByFrag = nil

  refreshAttackProfileLabel()
  rebuildAttackList()
  saveAttackBotChar()
end

local openAttackProfileNameEditor = nil

for i = 1, 5 do
  local btn = comboButton[tostring(i)]
  if btn then
    btn.onClick = function()
      setActiveAttackProfile(i)
    end

    btn.onDoubleClick = function()
      setActiveAttackProfile(i)
      if openAttackProfileNameEditor then
        openAttackProfileNameEditor(i)
      end
    end
  end
end

refreshAttackProfileLabel()


local function W(parent, id)
  if not parent then return nil end
  return (parent.getChildById and parent:getChildById(id)) or (parent.recursiveGetChildById and parent:recursiveGetChildById(id))
end

local function trimText(s) return (s or ""):gsub("^%s+", ""):gsub("%s+$", "") end
local function trim(s) return trimText(s) end
local function clearChildren(w) if not w then return end for i = #w:getChildren(), 1, -1 do w:getChildren()[i]:destroy() end end
local function clamp(v, a, b)
  v = tonumber(v) or a
  if v < a then return a end
  if v > b then return b end
  return v
end

local profileNameInput = W(profileNamePanel, "profileName")
local profileNameSave = W(profileNamePanel, "salvarBt")
local profileNameCancel = W(profileNamePanel, "cancelarBt")
local renamingAttackProfileIndex = getActiveAttackProfileIndex()

openAttackProfileNameEditor = function(idx)
  idx = math.max(1, math.min(5, tonumber(idx) or getActiveAttackProfileIndex()))
  renamingAttackProfileIndex = idx

  local p = getAttackProfile(idx)

  if profileNameInput then
    profileNameInput:setText(cleanAttackProfileName(p.name))
  end

  if profileNamePanel then
    profileNamePanel:setText("Rename Profile #" .. idx)
    profileNamePanel:show()
    profileNamePanel:raise()
    profileNamePanel:focus()
  end

  if profileNameInput and profileNameInput.focus then
    profileNameInput:focus()
  end
end

if comboButton and comboButton.name then
  comboButton.name.onDoubleClick = function()
    openAttackProfileNameEditor(getActiveAttackProfileIndex())
  end
end

if profileNameSave then
  profileNameSave.onClick = function()
    local p = getAttackProfile(renamingAttackProfileIndex)
    p.name = cleanAttackProfileName(profileNameInput and profileNameInput:getText() or "")
    saveAttackBotChar()
    refreshAttackProfileLabel()

    if profileNamePanel then
      profileNamePanel:hide()
    end
  end
end

if profileNameCancel then
  profileNameCancel.onClick = function()
    if profileNamePanel then
      profileNamePanel:hide()
    end
  end
end
local function nowMs()
  if type(now) == "number" then return now end
  if g_clock and g_clock.millis then return g_clock.millis() end
  return (os.time() * 1000) + math.floor((os.clock() * 1000) % 1000)
end
local function setSafeLabel(w, v) if not w then return end w:setColor(v and "#00FF00" or "#FF4040") w:setText(v and "[S]" or "[N]") end
local function spellInfo(d,m) d=tonumber(d) or 1 m=tonumber(m) or 1 return "["..d.." Sqm | +"..m.." Mob(s)"..(m>1 and "s" or "").."]" end
local function runeInfo(d,m) d=tonumber(d) or 1 m=tonumber(m) or 1 return "["..d.." Sqm | +"..m.." Mob(s)"..(m>1 and "s" or "").."]" end

local function getBotItemId(widget)
  if not widget then return 0 end
  if widget.getItemId then
    local ok,id = pcall(function() return widget:getItemId() end)
    if ok and id and id > 0 then return id end
  end
  if widget.getItem then
    local ok,item = pcall(function() return widget:getItem() end)
    if ok and item and item.getId then
      local ok2,id = pcall(function() return item:getId() end)
      if ok2 and id and id > 0 then return id end
    end
  end
  return 0
end

local function setItemIcon(widget, itemId)
  itemId = tonumber(itemId)
  if not widget then return end
  if not itemId or itemId <= 0 then return widget:setVisible(false) end
  widget:setVisible(true)
  if widget.setItemId then return widget:setItemId(itemId) end
  if widget.setItem and Item and Item.create then widget:setItem(Item.create(itemId, 1)) end
end

local function bindSwitch(widget, key)
  widget:setOn(cfg.main[key])
  widget.onClick = function(w)
    local state = not w:isOn()
    w:setOn(state)
    cfg.main[key] = state
    saveAttackBotChar()
  end
end

comboButton.title:setOn(charStorage[switchCombo].enabled)
bindSwitch(comboInterface.manterDist, "manterDist")
bindSwitch(comboInterface.checkPlayers, "checkPlayers")
bindSwitch(comboInterface.checkStairs, "checkStairs")
bindSwitch(comboInterface.checkFloors, "checkFloors")

comboInterface.distSegura:setValue(cfg.main.distSegura or 0)
comboInterface.labelDistSegura:setText("Dist Check Players: " .. (cfg.main.distSegura or 0))
comboInterface.distSegura.onValueChange = function(_, value)
  cfg.main.distSegura = value
  comboInterface.labelDistSegura:setText("Dist Check Players: " .. value)
  saveAttackBotChar()
end

comboInterface.distStairs:setValue(cfg.main.distStairs or 0)
comboInterface.labelDistStairs:setText("Dist Check Stairs: " .. (cfg.main.distStairs or 0))
comboInterface.distStairs.onValueChange = function(_, value)
  cfg.main.distStairs = value
  comboInterface.labelDistStairs:setText("Dist Check Stairs: " .. value)
  saveAttackBotChar()
end

local idsSafeContainer = UI.ContainerEx(function(_, items)
  local currentMap = normalizeSharedMap(sharedCfg.safeIdsAndares)
  local newList = normalizeIdList(normalizeContainerItems(items))
  local newSet = {}
  local ts = nowStorageTs()

  for _, id in ipairs(newList) do
    newSet[id] = true
    currentMap[tostring(id)] = { state = true, ts = ts }
  end

  for k, v in pairs(currentMap) do
    local id = tonumber(k)
    if id and not newSet[id] and v.state == true then
      currentMap[k] = { state = false, ts = ts }
    end
  end

  sharedCfg.safeIdsAndares = currentMap
  saveAttackBotShared()
end, true, comboInterface.idsSafeAndares)

idsSafeContainer:setParent(comboInterface.idsSafeAndares)
idsSafeContainer:fill("parent")
idsSafeContainer:setOpacity(1.00)
idsSafeContainer:setItems(sharedMapToList(sharedCfg.safeIdsAndares))

local spellRowTemplate = [[
UIWidget
  id: root
  height: 38
  focusable: true
  draggable: true
  background-color: alpha
  border: 1 alpha
  opacity: 1.00
  margin-top: 2
  $hover:
    background-color: #2a2a2a
    border: 1 #3a3a3a
  $focus:
    background-color: #2a2a2a
    border: 1 #3a3a3a

  BotSwitch
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    margin-top: 0
    width: 20
    height: 20
    text-align: center
    color: white
    image-source: /images/ui/button_rounded

  Label
    id: spellName
    anchors.left: enabled.right
    anchors.top: parent.top
    margin-left: 6
    margin-top: 4
    color: orange
    text: ""
    font: verdana-11px-rounded
    text-auto-resize: true

  Label
    id: distText
    anchors.left: spellName.left
    anchors.top: spellName.bottom
    margin-top: 2
    color: #c8c8c8
    text: ""
    font: verdana-11px-rounded
    text-auto-resize: true

  Label
    id: safeText
    anchors.left: distText.right
    anchors.verticalCenter: distText.verticalCenter
    margin-left: 4
    color: #ff5a5a
    text: ""
    font: verdana-11px-rounded
    text-auto-resize: true

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 20
    height: 20
    margin-right: 4
    text: X
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/button_rounded
    image-color: red
    opacity: 1.00
    $hover:
      image-color: red
      color: #ffd0d0
      opacity: 0.95
]]

local runeRowTemplate = [[
UIWidget
  id: root
  height: 38
  focusable: true
  draggable: true
  background-color: alpha
  border: 1 alpha
  opacity: 1.00
  margin-top: 2
  $hover:
    background-color: #2a2a2a
    border: 1 #3a3a3a
  $focus:
    background-color: #2a2a2a
    border: 1 #3a3a3a

  BotSwitch
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    margin-top: 0
    width: 20
    height: 20
    text-align: center
    color: white
    image-source: /images/ui/button_rounded

  UIItem
    id: icon
    anchors.left: enabled.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 2
    size: 30 30
    visible: false

  Label
    id: distText
    anchors.left: icon.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 1
    color: #c8c8c8
    text: ""
    font: verdana-11px-rounded
    text-auto-resize: true

  Label
    id: safeText
    anchors.left: distText.right
    anchors.verticalCenter: distText.verticalCenter
    margin-left: 4
    color: #ff5a5a
    text: ""
    font: verdana-11px-rounded
    text-auto-resize: true

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 20
    height: 20
    margin-right: 4
    text: X
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/button_rounded
    image-color: red
    opacity: 1.00
    $hover:
      image-color: red
      color: #ffd0d0
      opacity: 0.95
]]

local editingSpellIndex = nil
local editingRuneIndex = nil

local selectType = W(spellAddPanel, "selectType")
local magiaSelect = W(spellAddPanel, "magiaSelect")
local spellMagia = W(spellAddPanel,"magia")
local spellDistance = W(spellAddPanel,"distance")
local spellMana = W(spellAddPanel,"mana")
local spellMobs = W(spellAddPanel,"mobs")
local spellCooldown = W(spellAddPanel,"cooldown")
local spellSafe = W(spellAddPanel,"safe")
local spellCancelarBt = W(spellAddPanel,"cancelarBt")
local spellAdicionarBt = W(spellAddPanel,"adicionarBt")
local spellDistanceLabel = W(spellAddPanel,"distanceLabel")
local spellManaLabel = W(spellAddPanel,"manaLabel")
local spellMobsLabel = W(spellAddPanel,"mobsLabel")
local spellCooldownLabel = W(spellAddPanel,"cdLabel")
local spellCalcCooldownBtn = W(spellAddPanel, "calculeCooldown")

local runeItem = W(runeAddPanel,"runa")
local runeDistance = W(runeAddPanel,"distance")
local runeMobs = W(runeAddPanel,"mobs")
local runeSafe = W(runeAddPanel,"safe")
local runeCancelarBt = W(runeAddPanel,"cancelarBt")
local runeAdicionarBt = W(runeAddPanel,"adicionarBt")
local runeDistanceLabel = W(runeAddPanel,"distanceLabel")
local runeMobsLabel = W(runeAddPanel,"mobsLabel")
local unsafeMinutos = W(comboInterface, "minutosVoltarUnsafe")
local unsafeFrags = W(comboInterface, "qtdeFrags")
local unsafeDeslogar = W(comboInterface, "deslogarFrags")
local unsafeLabelMin = W(comboInterface, "labelReactiveUnsafe")
local unsafeLabelFrags = W(comboInterface, "labelExitFrags")

if unsafeMinutos then
  if unsafeMinutos.setMinimum then unsafeMinutos:setMinimum(1) end
  if unsafeMinutos.setMaximum then unsafeMinutos:setMaximum(120) end
  if unsafeMinutos.setStep then unsafeMinutos:setStep(1) end
end

if unsafeFrags then
  if unsafeFrags.setMinimum then unsafeFrags:setMinimum(1) end
  if unsafeFrags.setMaximum then unsafeFrags:setMaximum(8) end
  if unsafeFrags.setStep then unsafeFrags:setStep(1) end
end

local function refreshUnsafePanel()
  local min = tonumber(cfg.main.minutosVoltarUnsafe) or 5
  local frags = tonumber(cfg.main.qtdeFrags) or 1

  if unsafeMinutos then
    unsafeMinutos:setValue(min)
  end

  if unsafeLabelMin then
    unsafeLabelMin:setText("Reactive in: " .. min .. " min")
  end

  if unsafeFrags then
    unsafeFrags:setValue(frags)
  end

  if unsafeLabelFrags then
    unsafeLabelFrags:setText("Amount Frags: " .. frags)
  end

  if unsafeDeslogar then
    unsafeDeslogar:setOn(cfg.main.deslogarFrags == true)
  end
end

-- Tabela com as magias pré-configuradas {Nome, Distância, Mana, Mobs, CD, Safe}
local predefinedSpells = {
  ["Paladin"] = {
    {"Exevo mas san", 4, 160, 1, 4106, false},
    {"Exori san", 9, 20, 1, 2100, true},
    {"Exori con", 9, 25, 1, 2100, true},
    {"Exori gran con", 9, 55, 1, 6080, true}
  },
  ["Knight"] = {
    {"Exori gran", 1, 340, 1, 4106, false},
    {"Exori", 1, 115, 1, 2016, false},
    {"Exori min", 1, 200, 1, 4030, false},
    {"Exori mas", 2, 160, 1, 6100, false},
    {"Exori hur", 5, 40, 1, 4060, true},
    {"Exori ico", 1, 30, 1, 2070, true},
    {"Exori gran ico", 1, 300, 1, 15020, true}
  },
  ["Mage"] = {
    {"Exori frigo", 8, 20, 1, 2027, true},
    {"Exevo gran mas frigo", 7, 1000, 1, 15055, true},
    {"Exori vis", 8, 20, 1, 2027, true},
    {"Exevo gran mas vis", 7, 600, 1, 15055, true},
    {"Exori flam", 8, 20, 1, 2027, true},
    {"Exevo gran mas flam", 7, 1000, 1, 15055, true},
    {"Exori tera", 8, 20, 1, 2027, true},
    {"Exevo gran mas tera", 7, 600, 1, 15055, true}
  },
  -- SPELL, DISTANCIA, MANA, MOBS, COOLDOWN, SAFE
  ["Monk"] = {
    {"Exori Pug", 1, 35, 1, 4096, true},
    {"Exori Amp Pug", 1, 50, 1, 20090, false},
    {"Exori Med Pug", 1, 180, 1, 4074, false},
    {"Exori Mas Pug", 2, 125, 1, 4035, false},
    {"Exori Gran Pug", 1, 325, 1, 15103, false},
    {"Exori Gran Mas Pug", 1, 315, 1, 16015, false},
    {"Exori Nia", 1, 50, 1, 8074, true},
    {"Exori Mas Nia", 1, 195, 1, 8050, false},
    {"Exori Gran Nia", 1, 210, 1, 24103, true},
    {"Exori Gran Mas Nia", 1, 425, 1, 60081, false}
  }
}

local function updateSpellPanelLabels()
  if spellDistanceLabel and spellDistance then spellDistanceLabel:setText("Distance: " .. (spellDistance:getValue() or 0)) end
  if spellManaLabel and spellMana then spellManaLabel:setText("Mana: " .. (spellMana:getValue() or 0)) end
  if spellMobsLabel and spellMobs then spellMobsLabel:setText("Mobs: " .. (spellMobs:getValue() or 0)) end
  if spellCooldownLabel and spellCooldown then spellCooldownLabel:setText("Cooldown: " .. (spellCooldown:getValue() or 0)) end
end

local function updateRunePanelLabels()
  if runeDistanceLabel and runeDistance then runeDistanceLabel:setText("Distance: " .. (runeDistance:getValue() or 0)) end
  if runeMobsLabel and runeMobs then runeMobsLabel:setText("Mobs: " .. (runeMobs:getValue() or 0)) end
end

if spellDistance then spellDistance.onValueChange = function() updateSpellPanelLabels() end end
if spellMana then spellMana.onValueChange = function() updateSpellPanelLabels() end end
if spellMobs then spellMobs.onValueChange = function() updateSpellPanelLabels() end end
if spellCooldown then spellCooldown.onValueChange = function() updateSpellPanelLabels() end end
if runeDistance then runeDistance.onValueChange = function() updateRunePanelLabels() end end
if runeMobs then runeMobs.onValueChange = function() updateRunePanelLabels() end end

if unsafeMinutos then
  unsafeMinutos.onValueChange = function(_, value)
    local v = tonumber(value) or 5
    cfg.main.minutosVoltarUnsafe = v

    if unsafeLabelMin then
      unsafeLabelMin:setText("Reactive in: " .. v .. " min")
    end

    saveAttackBotChar()
  end
end

if unsafeFrags then
  unsafeFrags.onValueChange = function(_, value)
    local v = tonumber(value) or 1
    cfg.main.qtdeFrags = v

    if unsafeLabelFrags then
      unsafeLabelFrags:setText("Amount Frags: " .. v)
    end

    saveAttackBotChar()
  end
end

if unsafeDeslogar then
  unsafeDeslogar.onClick = function(widget)
    local state = not widget:isOn()
    widget:setOn(state)
    cfg.main.deslogarFrags = state
    saveAttackBotChar()
  end
end

if selectType and magiaSelect and spellMagia then
  selectType.onOptionChange = function(comboBox, option)
    if option == "Editable" then
      spellMagia:setVisible(true)
      magiaSelect:setVisible(false)
      spellDistance:setValue(0)
      spellMana:setValue(0)
      spellMobs:setValue(1)
      spellCooldown:setValue(0)
      spellSafe:setChecked(false)
    else
      spellMagia:setVisible(false)
      magiaSelect:setVisible(true)

      magiaSelect:clearOptions()
      local vocSpells = predefinedSpells[option] or {}
      if #vocSpells == 0 then
        magiaSelect:addOption("Nenhuma magia cadastrada")
      else
        for _, s in ipairs(vocSpells) do
          magiaSelect:addOption(s[1])
        end
        local first = vocSpells[1]
        spellDistance:setValue(first[2])
        spellMana:setValue(first[3])
        spellMobs:setValue(first[4] or 1)
        spellCooldown:setValue(first[5])
        spellSafe:setChecked(first[6])
        updateSpellPanelLabels()
      end
    end
  end

  magiaSelect.onOptionChange = function(comboBox, option)
    local currentType = selectType:getCurrentOption().text
    local vocSpells = predefinedSpells[currentType] or {}
    for _, s in ipairs(vocSpells) do
      if s[1] == option then
        spellDistance:setValue(s[2])
        spellMana:setValue(s[3])
        spellMobs:setValue(s[4] or 1)
        spellCooldown:setValue(s[5])
        spellSafe:setChecked(s[6])
        updateSpellPanelLabels()
        break
      end
    end
  end
end

local function resetSpellAddPanel()
  if selectType then selectType:setOption("Editable") end
  if spellMagia then 
    spellMagia:setText("") 
    spellMagia:setVisible(true)
  end
  if magiaSelect then magiaSelect:setVisible(false) end
  if spellDistance then spellDistance:setValue(1) end
  if spellMana then spellMana:setValue(0) end
  if spellMobs then spellMobs:setValue(1) end
  if spellCooldown then spellCooldown:setValue(0) end
  if spellSafe then spellSafe:setChecked(false) end
  updateSpellPanelLabels()
end

local function resetRuneAddPanel()
  if runeItem then
    if runeItem.setItemId then
      runeItem:setItemId(0)
    elseif runeItem.setItem then
      pcall(function() runeItem:setItem(nil) end)
    end
  end
  if runeDistance then runeDistance:setValue(1) end
  if runeMobs then runeMobs:setValue(1) end
  if runeSafe then runeSafe:setChecked(false) end
  updateRunePanelLabels()
end

local function setupDragAndDrop(row)
  row.onDragEnter = function(self, mousePos)
    self:setOpacity(0.4)
    return true
  end
  row.onDragLeave = function(self, droppedWidget, mousePos)
    self:setOpacity(1.0)
  end
  row.onDrop = function(self, droppedWidget, mousePos)
    self:setOpacity(1.0)
    droppedWidget:setOpacity(1.0)
    local parent = self:getParent()
    local children = parent:getChildren()
    local fromIndex, toIndex = 0, 0
    for i, child in ipairs(children) do
      if child == droppedWidget then fromIndex = i end
      if child == self then toIndex = i end
    end
    if fromIndex > 0 and toIndex > 0 and fromIndex ~= toIndex then
      local movedItem = table.remove(cfg.attacks, fromIndex)
      table.insert(cfg.attacks, toIndex, movedItem)
      saveAttackBotChar()
      rebuildAttackList()
    end
    return true
  end
end

local function createSpellRow(data, index)
  local row = setupUI(spellRowTemplate, comboInterface.spellList)
  setupDragAndDrop(row) -- Aplica o Drag & Drop na Spell

  row.enabled:setOn(data.enabled == true)
  row.enabled.onClick = function(w)
    local state = not w:isOn()
    w:setOn(state)
    if cfg.attacks[index] then cfg.attacks[index].enabled = state end
    saveAttackBotChar()
  end
  row.spellName:setText(tostring(data.spell or ""))
  row.distText:setText(spellInfo(data.distance, data.mobs))
  setSafeLabel(row.safeText, data.safe)
  row.remove.onClick = function()
    table.remove(cfg.attacks, index)
    saveAttackBotChar()
    rebuildAttackList()
  end
  row.onDoubleClick = function()
    local data = cfg.attacks[index]
    if not data then return end
    editingIndex = index
    spellMagia:setText(data.spell or "")
    spellDistance:setValue(data.distance or 1)
    spellMana:setValue(data.mana or 0)
    spellMobs:setValue(data.mobs or 1)
    spellCooldown:setValue(data.cooldown or 0)
    spellSafe:setChecked(data.safe or false)
    updateSpellPanelLabels()
    comboInterface:hide()
    spellAddPanel:show()
    spellAddPanel:raise()
    spellAddPanel:focus()
  end
end

local function createRuneRow(data, index)
  local row = setupUI(runeRowTemplate, comboInterface.spellList)
  setupDragAndDrop(row) -- Aplica o Drag & Drop na Runa

  row.enabled:setOn(data.enabled == true)
  row.enabled.onClick = function(w)
    local state = not w:isOn()
    w:setOn(state)
    if cfg.attacks[index] then cfg.attacks[index].enabled = state end
    saveAttackBotChar()
  end
  setItemIcon(row.icon, tonumber(data.id) or 0)
  row.distText:setText(runeInfo(data.distance, data.mobs))
  setSafeLabel(row.safeText, data.safe)
  row.remove.onClick = function()
    table.remove(cfg.attacks, index)
    saveAttackBotChar()
    rebuildAttackList()
  end
  row.onDoubleClick = function()
    local data = cfg.attacks[index]
    if not data then return end
    editingIndex = index
    setItemIcon(runeItem, tonumber(data.id) or 0)
    if runeItem and runeItem.setItemId then runeItem:setItemId(tonumber(data.id) or 0) end
    runeDistance:setValue(data.distance or 1)
    runeMobs:setValue(data.mobs or 1)
    runeSafe:setChecked(data.safe or false)
    updateRunePanelLabels()
    comboInterface:hide()
    runeAddPanel:show()
    runeAddPanel:raise()
    runeAddPanel:focus()
  end
end

function rebuildAttackList()
  if not comboInterface or not comboInterface.spellList then return end
  clearChildren(comboInterface.spellList)
  for i, data in ipairs(cfg.attacks or {}) do 
    if data.type == "spell" then
      createSpellRow(data, i)
    elseif data.type == "rune" then
      createRuneRow(data, i)
    end
  end
end

comboInterface.adicionarSpell.onClick = function()
  editingIndex = nil
  resetSpellAddPanel()
  comboInterface:hide()
  spellAddPanel:show()
  spellAddPanel:focus()
  spellAddPanel:raise()
end

comboInterface.adicionarRuna.onClick = function()
  editingIndex = nil
  resetRuneAddPanel()
  comboInterface:hide()
  runeAddPanel:show()
  runeAddPanel:raise()
  runeAddPanel:focus()
end

spellAdicionarBt.onClick = function()
  local spellName = ""

  -- Verifica de onde pegar o nome da magia
  if selectType and selectType:getCurrentOption().text == "Editable" then
    spellName = trimText(spellMagia:getText())
  else
    spellName = trimText(magiaSelect:getCurrentOption().text)
    if spellName == "Nenhuma magia cadastrada" or spellName == "" then
       return warn("Nenhuma magia válida selecionada para esta vocação.")
    end
  end

  if spellName == "" then return warn("Insira ou selecione uma spell.") end

  local data = {
    type = "spell",
    enabled = true,
    spell = spellName,
    distance = spellDistance:getValue(),
    mana = spellMana:getValue(),
    mobs = spellMobs:getValue(),
    cooldown = spellCooldown:getValue(),
    safe = spellSafe:isChecked(),
    nextCast = 0
  }

  if editingIndex then
    data.enabled = cfg.attacks[editingIndex] and cfg.attacks[editingIndex].enabled ~= false or true
    data.nextCast = cfg.attacks[editingIndex] and cfg.attacks[editingIndex].nextCast or 0
    cfg.attacks[editingIndex] = data
    editingIndex = nil
  else
    table.insert(cfg.attacks, data)
  end

  saveAttackBotChar()
  rebuildAttackList()
  spellAddPanel:hide()
  comboInterface:show()
end

runeAdicionarBt.onClick = function()
  local runeId = getBotItemId(runeItem)
  if not runeId or runeId <= 0 then return warn("Selecione uma rune.") end

  local data = {
    type = "rune",
    enabled = true,
    id = runeId,
    distance = runeDistance:getValue(),
    mobs = runeMobs:getValue(),
    safe = runeSafe:isChecked(),
    nextCast = 0
  }

  if editingIndex then
    data.enabled = cfg.attacks[editingIndex] and cfg.attacks[editingIndex].enabled ~= false or true
    data.nextCast = cfg.attacks[editingIndex] and cfg.attacks[editingIndex].nextCast or 0
    cfg.attacks[editingIndex] = data
    editingIndex = nil
  else
    table.insert(cfg.attacks, data)
  end

  saveAttackBotChar()
  rebuildAttackList()
  runeAddPanel:hide()
  comboInterface:show()
end

spellCancelarBt.onClick = function()
  editingIndex = nil
  spellAddPanel:hide()
  comboInterface:show()
end

runeCancelarBt.onClick = function()
  editingIndex = nil
  comboInterface:show()
  runeAddPanel:hide()
end

setActiveAttackProfile(getActiveAttackProfileIndex())
refreshUnsafePanel()
updateSpellPanelLabels()
updateRunePanelLabels()

local SkullWhite = 3
local SkullRed = 4
local SkullBlack = 5

local PKSkulls = {
  [SkullWhite] = true,
  [SkullRed] = true,
  [SkullBlack] = true
}

local function getSafePlayerCheckDist()
  return math.max(1, tonumber(cfg.main.distSegura) or 1)
end

local function getSafeOtherFloorCheckDist()
  return math.max(1, tonumber(cfg.main.qtdePlayers) or 1)
end

local function getSafeStairsCheckDist()
  return math.max(1, tonumber(cfg.main.distStairs) or 1)
end

local function isPkSkulled(creature)
  if not creature or not creature.getSkull then return false end
  local skull = creature:getSkull()
  return PKSkulls[skull] == true
end

local function hasPartyShield(creature)
  if not creature then
    return false
  end

  if creature.isPartyMember and creature:isPartyMember() then
    return true
  end

  return false
end

local function isAttackBotFriend(creature)
  if not creature or not creature:isPlayer() or creature:isLocalPlayer() then
    return false
  end

  local cname = creature:getName()
  if not cname then return false end

  -- party real, somente pelo estado atual
  if creature.isPartyMember and creature:isPartyMember() then
    return true
  end

  charStorage.playerList = charStorage.playerList or {}
  charStorage.playerList.friendList = charStorage.playerList.friendList or {}

  for _, friendName in ipairs(charStorage.playerList.friendList) do
    if trimText(friendName):lower() == trimText(cname):lower() then
      return true
    end
  end

  if type(isFriend) == "function" and isFriend(cname) then
    return true
  end

  return false
end

local function isSpellProtectedPlayer(creature)
  if not creature or not creature:isPlayer() or creature:isLocalPlayer() then
    return false
  end

  if isAttackBotFriend(creature) then
    return false
  end

  return not isPkSkulled(creature)
end

local function getPlayerFloorScan()
  local result = {
    sameFloor = false,
    otherFloor = false
  }

  local myPos = pos()
  if not myPos then return result end

  local maxDist = getSafePlayerCheckDist()

  for _, spec in pairs(getSpectators(true)) do
    if isSpellProtectedPlayer(spec) then
      local sPos = spec:getPosition()

      if sPos then
        local dist = math.max(math.abs(myPos.x - sPos.x), math.abs(myPos.y - sPos.y))

        if sPos.z == myPos.z then
          if cfg.main.checkPlayers and dist <= maxDist then
            result.sameFloor = true
          end
        else
          if cfg.main.checkFloors and math.abs(sPos.z - myPos.z) == 1 and dist <= maxDist then
            result.otherFloor = true
          end
        end
      end
    end
  end

  return result
end

local function hasPlayerOnScreenSameFloor()
  return getPlayerFloorScan().sameFloor == true
end

local function hasPlayerOnOtherFloors()
  return getPlayerFloorScan().otherFloor == true
end

local MINIMAP_STAIRS_COLORS = {
  [210] = true,
  [211] = true,
  [212] = true,
  [213] = true,

}

local function isMinimapStairs(pos)
  if not pos or not g_map or not g_map.getMinimapColor then return false end

  local color = g_map.getMinimapColor(pos)
  color = tonumber(color)

  if not color then return false end

  return MINIMAP_STAIRS_COLORS[color] == true
end


local function hasConfiguredUnsafeId(tile)
  if not tile then return false end

  local ids = sharedMapToList(sharedCfg.safeIdsAndares)

  for _, item in pairs(tile:getItems() or {}) do
    if item and item.getId and table.find(ids, item:getId()) then
      return true
    end
  end

  return false
end

local function hasYellowMinimapStair(tile)
  if not tile then return false end
  return isMinimapStairs(tile:getPosition()) == true
end

local function isNearConfiguredStairs()
  if not cfg.main.checkStairs then return false end

  local myPos = pos()
  if not myPos then return false end

  local stairDist = getSafeStairsCheckDist()

  -- 1) ID configurado = UNSAFE direto, MAS SÓ NO ANDAR ATUAL
  for _, tile in pairs(g_map.getTiles(myPos.z) or {}) do
    local tPos = tile:getPosition()

    if tPos then
      local dist = math.max(math.abs(myPos.x - tPos.x), math.abs(myPos.y - tPos.y))

      if dist <= stairDist and hasConfiguredUnsafeId(tile) then
        return "id"
      end
    end
  end

  -- 2) Minimap amarelo = só sinalizador de escada/andar, também no andar atual
  for _, tile in pairs(g_map.getTiles(myPos.z) or {}) do
    local tPos = tile:getPosition()

    if tPos then
      local dist = math.max(math.abs(myPos.x - tPos.x), math.abs(myPos.y - tPos.y))

      if dist <= stairDist and hasYellowMinimapStair(tile) then
        return "yellow"
      end
    end
  end

  return false
end

local function hasPlayerOnOtherFloorsNearStairs()
  if not cfg.main.checkStairs then return false end

  local myPos = pos()
  if not myPos then return false end

  local maxPlayerDist = getSafePlayerCheckDist()

  for _, spec in pairs(getSpectators(true) or {}) do
    if spec and spec:isPlayer() and not spec:isLocalPlayer() and isSpellProtectedPlayer(spec) then
      local sPos = spec:getPosition()

      if sPos and sPos.z ~= myPos.z and math.abs(sPos.z - myPos.z) == 1 then
        local dist = math.max(math.abs(myPos.x - sPos.x), math.abs(myPos.y - sPos.y))

        if dist <= maxPlayerDist then
          return true
        end
      end
    end
  end

  return false
end

local function hasProtectedPlayerForUnsafe()
  local scan = getPlayerFloorScan()

  if scan.sameFloor then return true end
  if hasPlayerOnOtherFloorsNearStairs() then return true end
  if scan.otherFloor then return true end

  return false
end

function LNS_HAS_UNSAFE_CONDITION()
  local scan = getPlayerFloorScan()

  if scan.sameFloor then return true end

  local stairMode = isNearConfiguredStairs()

  if stairMode == "id" then
    return true
  end

  if stairMode == "yellow" then
    return hasPlayerOnOtherFloorsNearStairs() == true
  end

  if scan.otherFloor then return true end

  return false
end

macro(100, function()
  LNS_HAS_UNSAFE_CONDITION()
  local p = player
  if not p then return end

  local unsafe = false

  if type(LNS_HAS_UNSAFE_CONDITION) == "function" then
    unsafe = LNS_HAS_UNSAFE_CONDITION() == true
  end

  if unsafe then
    if p:getText() ~= "UNSAFE" then
      p:setText("UNSAFE")
    end
  else
    if p:getText() == "UNSAFE" then
      p:setText("")
    end
  end
end)

local worldName = g_game.getWorldName() or ""
local WORLD_COMBAT_LOCK = 1000
if worldName == "Telaria" or worldName == "Eternia" or worldName == "Aurera-Global" then
  WORLD_COMBAT_LOCK = 1900
end

local combatGlobalUntil = 0
local lastRuneGlobal = 0

local runeCooldownIcon = {
  [3155] = 21,
  [3175] = 116,
  [3202] = 117,
  [3191] = 16,
  [3161] = 115
}

local function isRuneClientCooldownActive(runeId)
  runeId = tonumber(runeId) or 0

  local iconId = runeCooldownIcon[runeId]
  if not iconId then return false end

  return modules.game_cooldown
     and modules.game_cooldown.isCooldownIconActive
     and modules.game_cooldown.isCooldownIconActive(iconId) == true
end




local MONK_HARMONY_MAX = 5
local MONK_HARMONY_BUILDERS = {
  ["exori gran pug"] = true,
  ["exori amp pug"] = true,
  ["exori gran mas pug"] = true,
  ["exori mas pug"] = true,
  ["exori med pug"] = true
}
local MONK_HARMONY_FINISHERS = {
  ["exori mas nia"] = true,
  ["exori gran nia"] = true,
  ["exori gran mas nia"] =  true,
  ["exori infir nia"] = true,
  ["exori nia"] = true,
}

local function monkSpellKey(text)
  return trimText(text):lower()
end

local function isMonkHarmonyVocation()
  local p = g_game.getLocalPlayer()
  if not p then return false end
  local voc = tonumber(p:getVocation()) or 0
  return voc == 5 or voc == 10
end

local function monkHarmonyGet()
  return math.max(0, math.min(MONK_HARMONY_MAX, tonumber(charStorage.attackBotMonkHarmony.points) or 0))
end

local function monkHarmonySet(v)
  charStorage.attackBotMonkHarmony.points = math.max(0, math.min(MONK_HARMONY_MAX, tonumber(v) or 0))
  saveAttackBotChar()
end

local function monkHarmonyAdd(v)
  monkHarmonySet(monkHarmonyGet() + (tonumber(v) or 1))
end

local function monkHarmonyReset()
  monkHarmonySet(0)
end

local function isHarmonyBuilderSpell(spell)
  return MONK_HARMONY_BUILDERS[monkSpellKey(spell)] == true
end

local function isHarmonyFinisherSpell(spell)
  return MONK_HARMONY_FINISHERS[monkSpellKey(spell)] == true
end

local function hasConfiguredHarmonyFinisher()
  for _, attack in ipairs(cfg.attacks or {}) do
    if attack.enabled and attack.type == "spell" and isHarmonyFinisherSpell(attack.spell or "") then
      return true
    end
  end
  return false
end

local function monkHarmonyFlowActive()
  return isMonkHarmonyVocation() and hasConfiguredHarmonyFinisher()
end

local function resetComboCooldowns()
  for _, attack in ipairs(cfg.attacks or {}) do
    attack.nextCast = 0
  end
  combatGlobalUntil = 0
  lastRuneGlobal = 0
  monkHarmonyReset()
end

local function iAmPK()
  local p = g_game.getLocalPlayer()
  if not p then return false end
  local skull = p.getSkull and p:getSkull() or 0
  return PKSkulls[skull] == true
end

local function iAmDead()
  local p = g_game.getLocalPlayer()
  if not p then return false end
  if p.getHealthPercent then
    return (p:getHealthPercent() or 100) <= 0
  end
  return false
end

local function normalizeUnsafePKState()
  cfg.main.disabledByUnsafePK = type(cfg.main.disabledByUnsafePK) == "table" and cfg.main.disabledByUnsafePK or {}
  cfg.main.reenableUnsafeAt = tonumber(cfg.main.reenableUnsafeAt) or 0

  -- compatibilidade/limpeza de versoes antigas
  if type(cfg.main.disabledByFrag) == "table" then
    for _, idx in ipairs(cfg.main.disabledByFrag) do
      local attack = cfg.attacks and cfg.attacks[idx]
      if attack then
        attack.disabledByUnsafePK = true
      end
    end
    cfg.main.disabledByFrag = nil
  end
end

local function hasUnsafeDisabledByPK()
  normalizeUnsafePKState()

  for _, attack in ipairs(cfg.attacks or {}) do
    if attack and attack.disabledByUnsafePK == true then
      return true
    end
  end

  return false
end

local function disableUnsafeAttacksByPK()
  normalizeUnsafePKState()

  local did = false

  for _, attack in ipairs(cfg.attacks or {}) do
    if attack and attack.enabled ~= false and attack.safe ~= true then
      attack.enabled = false
      attack.disabledByUnsafePK = true
      did = true
    end
  end

  cfg.main.reenableUnsafeAt = 0

  if did then
    rebuildAttackList()
    saveAttackBotChar()
    warn("[AttackBot] PK detectado - unsafe desligadas.")
  end
end

local function restoreUnsafeAttacksByPK()
  normalizeUnsafePKState()

  local did = false

  for _, attack in ipairs(cfg.attacks or {}) do
    if attack and attack.disabledByUnsafePK == true then
      attack.enabled = true
      attack.disabledByUnsafePK = nil
      did = true
    end
  end

  cfg.main.disabledByUnsafePK = {}
  cfg.main.reenableUnsafeAt = 0

  if did then
    rebuildAttackList()
    warn("[AttackBot] Unsafe religadas.")
  end

  saveAttackBotChar()
end

local function countAttackMonstersAround(centerPos, maxDist)
  if not centerPos then return 0 end

  local count = 0
  local specs = {}

  if g_map and g_map.getSpectators then
    local ok, res = pcall(function() return g_map.getSpectators(centerPos, false) end)
    if ok and type(res) == "table" then specs = res end
  elseif type(getSpectators) == "function" then
    local ok, res = pcall(function() return getSpectators(false) end)
    if ok and type(res) == "table" then specs = res end
  end

  for _, s in ipairs(specs) do
    if s and s.isMonster and s:isMonster() then
      local sPos = s:getPosition()
      if sPos and sPos.z == centerPos.z then
        local dist = math.max(math.abs(centerPos.x - sPos.x), math.abs(centerPos.y - sPos.y))
        if dist <= (maxDist or 7) then
          count = count + 1
        end
      end
    end
  end

  return count
end

local function isSafeAllowedForCurrentTarget(isSafe, targetIsPlayer)
  if targetIsPlayer then return true end
  if not hasProtectedPlayerForUnsafe() then return true end
  return isSafe == true
end

local function attackReady(attack)
  return now >= (tonumber(attack.nextCast) or 0)
end

local function canCastSpellAttack(attack, dist, targetIsPlayer, pPos)
  local maxDist = tonumber(attack.distance) or 8
  local manaOk = mana() >= (tonumber(attack.mana) or 0)
  local mobsOk = true
  local needMobs = tonumber(attack.mobs) or 0

  if (not targetIsPlayer) and needMobs > 0 then
    mobsOk = countAttackMonstersAround(pPos, 7) >= needMobs
  end

  return dist <= maxDist and manaOk and mobsOk and isSafeAllowedForCurrentTarget(attack.safe, targetIsPlayer)
end

local function canUseRuneAttack(attack, dist, targetIsPlayer, pPos)
  local runeId = tonumber(attack.id) or 0

  if isRuneClientCooldownActive(runeId) then
    return false
  end

  local maxDist = tonumber(attack.distance) or 8
  local mobsOk = true
  local needMobs = tonumber(attack.mobs) or 0

  if (not targetIsPlayer) and needMobs > 0 then
    mobsOk = countAttackMonstersAround(pPos, 7) >= needMobs
  end

  return dist <= maxDist and mobsOk and isSafeAllowedForCurrentTarget(attack.safe, targetIsPlayer)
end

local function isUnsafeNowForAttack(targetIsPlayer)
  if targetIsPlayer then return false end

  if type(LNS_HAS_UNSAFE_CONDITION) == "function" then
    return LNS_HAS_UNSAFE_CONDITION() == true
  end

  return hasProtectedPlayerForUnsafe() == true
end

local function tryUseAttack(attack, dist, target, targetIsPlayer, pPos, unsafeNow)
  if not attack or not attack.enabled or not attackReady(attack) then return false end

  --==================================================
  -- MONK HARMONY LOCK
  -- Builder só usa com harmonia abaixo de 5/5.
  -- Finisher só usa com harmonia cheia 5/5.
  --==================================================
  if attack.type == "spell" and monkHarmonyFlowActive() then
    local spellName = attack.spell or ""
    local harmony = monkHarmonyGet()

    if isHarmonyFinisherSpell(spellName) and harmony < MONK_HARMONY_MAX then
      return false
    end

    if isHarmonyBuilderSpell(spellName) and harmony >= MONK_HARMONY_MAX then
      return false
    end
  end

  -- se estiver unsafe, ignora imediatamente spell/rune unsafe
  if unsafeNow and attack.safe ~= true then
    return false
  end

  local maxDist = tonumber(attack.distance) or 8
  if dist > maxDist then return false end

  if attack.type == "spell" then
    local manaOk = mana() >= (tonumber(attack.mana) or 0)
    if not manaOk then return false end

    if pausandoCombo and pausandoCombo >= now then return false end

    local needMobs = tonumber(attack.mobs) or 0
    if not targetIsPlayer and needMobs > 0 then
      if countAttackMonstersAround(pPos, 7) < needMobs then
        return false
      end
    end

    local words = trimText(attack.spell)
    if words == "" then return false end

    say(words)
    combatGlobalUntil = now + WORLD_COMBAT_LOCK
    return true
  end

  if attack.type == "rune" then
    local runeId = tonumber(attack.id) or 0

    if pauseForMw and pauseForMw > now then return false end
    if pausandoCombo and pausandoCombo >= now then return false end
    if runeId <= 0 then return false end
    if isRuneClientCooldownActive(runeId) then return false end

    local needMobs = tonumber(attack.mobs) or 0
    if not targetIsPlayer and needMobs > 0 then
      if countAttackMonstersAround(pPos, 7) < needMobs then
        return false
      end
    end

    local ok = pcall(function()
      useWith(runeId, target)
    end)

    if ok then
      combatGlobalUntil = now + 50
      return true
    end
  end

  return false
end

local function tryUseMonkBuilder(dist, target, targetIsPlayer, pPos)
  for _, attack in ipairs(cfg.attacks or {}) do
    if attack.enabled and attack.type == "spell" and isHarmonyBuilderSpell(attack.spell or "") then
      if tryUseAttack(attack, dist, target, targetIsPlayer, pPos) then
        return true
      end
    end
  end
  return false
end

local function tryUseMonkFinisher(dist, target, targetIsPlayer, pPos)
  for _, attack in ipairs(cfg.attacks or {}) do
    if attack.enabled and attack.type == "spell" and isHarmonyFinisherSpell(attack.spell or "") then
      if tryUseAttack(attack, dist, target, targetIsPlayer, pPos) then
        return true
      end
    end
  end
  return false
end

local monkHarmonyIcon = addIcon("lnsAttackBotMonkHarmony", {
  text = "Harmony",
  switchable = false,
  moveable = true
}, function() end)
monkHarmonyIcon:setSize({height = 52, width = 74})
monkHarmonyIcon.text:setFont("verdana-11px-rounded")
macro(100, function()
  if not isMonkHarmonyVocation() then
    monkHarmonyIcon:hide()
    return
  end

  monkHarmonyIcon:show()
  local points = monkHarmonyGet()

  if points >= MONK_HARMONY_MAX then
    monkHarmonyIcon.text:setColoredText({tostring(points) .. "/5", "green"})
  else
    monkHarmonyIcon.text:setColoredText({tostring(points) .. "/5", "orange"})
  end
end)

resetComboCooldowns()

if g_game and connect then
  connect(g_game, {
    onGameStart = function()
      resetComboCooldowns()
    end
  })
end

local cdSpell = { active = false, spell = "", lastTime = 0 }
local function stopSpellCalc()
  cdSpell.active = false
  cdSpell.spell = ""
  cdSpell.lastTime = 0
end

macro(100, function()
  if not cdSpell.active then return end
  if cdSpell.spell == "" then stopSpellCalc(); return end
  say(cdSpell.spell)
end)

onTalk(function(name, level, mode, text, channelId, pos)
  local player = g_game.getLocalPlayer()
  if not player then return end

  if cdSpell.active and name == player:getName() then
    local msg = trimText(text):lower()
    local expected = trimText(cdSpell.spell):lower()
    if expected ~= "" and msg == expected then
      local t = nowMs()
      if cdSpell.lastTime > 0 then
        local cd = math.floor(t - cdSpell.lastTime)
        local v = clamp(cd, 0, 60000)
        if spellCooldown and spellCooldown.setValue then
          spellCooldown:setValue(v)
          if spellCooldown.onValueChange then
            pcall(function() spellCooldown.onValueChange(spellCooldown, v) end)
          end
        end
        updateSpellPanelLabels()
        warn(string.format("[CD-SPELL] %d ms (%.1fs)", v, v / 1000))
        stopSpellCalc()
      else
        cdSpell.lastTime = t
      end
    end
  end

  if name ~= player:getName() then return end

  local spoken = trimText(text):lower()

  if isMonkHarmonyVocation() then
    if MONK_HARMONY_BUILDERS[spoken] then
      monkHarmonyAdd(1)
    elseif MONK_HARMONY_FINISHERS[spoken] then
      monkHarmonyReset()
    end
  end

  for _, attack in ipairs(cfg.attacks or {}) do
    if attack.type == "spell" and attack.enabled then
      local spellWords = trimText(attack.spell):lower()
      if spellWords ~= "" and spellWords == spoken then
        attack.nextCast = now + (tonumber(attack.cooldown) or WORLD_COMBAT_LOCK)
        combatGlobalUntil = now + WORLD_COMBAT_LOCK
        return
      end
    end
  end
end)

local function getSelectedSpellNameForCooldown()
  local spell = ""

  if selectType and selectType:getCurrentOption() then
    local currentType = selectType:getCurrentOption().text or ""

    if currentType == "Editable" then
      spell = trimText(spellMagia and spellMagia:getText() or "")
    else
      if magiaSelect and magiaSelect:getCurrentOption() then
        spell = trimText(magiaSelect:getCurrentOption().text or "")
      end
    end
  else
    spell = trimText(spellMagia and spellMagia:getText() or "")
  end

  if spell == "Nenhuma magia cadastrada" then
    spell = ""
  end

  return spell
end

if spellCalcCooldownBtn then
  spellCalcCooldownBtn.onClick = function()
    local spell = getSelectedSpellNameForCooldown()

    if spell == "" then
      warn("Digite ou selecione uma spell.")
      return
    end

    cdSpell.active = true
    cdSpell.spell = spell
    cdSpell.lastTime = 0

    warn("[CD-SPELL] Iniciado para: " .. spell .. ". Fale/caste a spell 2x para calcular.")
  end
end

macro(200, function()
  normalizeUnsafePKState()

  -- usa o botão original "Pause Spells Unsafe" do painel principal
  if cfg.main.manterDist ~= true then
    if hasUnsafeDisabledByPK() then
      restoreUnsafeAttacksByPK()
    else
      cfg.main.reenableUnsafeAt = 0
    end
    return
  end

  local pk = iAmPK()

  -- enquanto estiver PK, qualquer spell/rune unsafe que estiver ligada sera desligada.
  -- A contagem de reativacao NAO comeca enquanto o PK ainda estiver ativo.
  if pk then
    disableUnsafeAttacksByPK()
    return
  end

  -- Se morreu sem estar PK, libera as unsafe marcadas pela protecao.
  if hasUnsafeDisabledByPK() and iAmDead() then
    restoreUnsafeAttacksByPK()
    return
  end

  -- Perdeu o PK: agora sim inicia/continua o tempo escolhido em "Reactive in".
  if hasUnsafeDisabledByPK() then
    local mins = tonumber(cfg.main.minutosVoltarUnsafe) or 5
    if mins < 1 then mins = 1 end

    if cfg.main.reenableUnsafeAt <= 0 then
      cfg.main.reenableUnsafeAt = nowMs() + (mins * 60 * 1000)
      saveAttackBotChar()
      warn("[AttackBot] PK removido - unsafe voltam em " .. mins .. " min.")
      return
    end

    if nowMs() >= cfg.main.reenableUnsafeAt then
      restoreUnsafeAttacksByPK()
      return
    end
  else
    cfg.main.reenableUnsafeAt = 0
  end
end)

-- =========================
-- EXIT ON FRAGS
-- =========================
cfg.main.fragsAtual = tonumber(cfg.main.fragsAtual) or 0

onTextMessage(function(mode, text)
  if not cfg or not cfg.main then return end
  if cfg.main.deslogarFrags ~= true then return end
  if type(text) ~= "string" then return end
  if not text:find("Warning! The murder of") then return end

  cfg.main.fragsAtual = tonumber(cfg.main.fragsAtual) or 0
  cfg.main.qtdeFrags = tonumber(cfg.main.qtdeFrags) or 1

  cfg.main.fragsAtual = cfg.main.fragsAtual + 1
  saveAttackBotChar()

  if cfg.main.fragsAtual >= cfg.main.qtdeFrags then
    cfg.main.fragsAtual = 0
    saveAttackBotChar()

    if modules and modules.game_interface and modules.game_interface.forceExit then
      modules.game_interface.forceExit()
    elseif g_game and g_game.safeLogout then
      g_game.safeLogout()
    end
  end
end)

macro(50, function()
  if not charStorage[switchCombo] or charStorage[switchCombo].enabled ~= true then return end
  if pausandoCombo and pausandoCombo >= now then return end

  local player = g_game.getLocalPlayer()
  local target = g_game.getAttackingCreature()

  if not player or not target then return end
  if player:isNpc() then return end

  local pPos = player:getPosition()
  local tPos = target:getPosition()

  if not pPos or not tPos or pPos.z ~= tPos.z then
    return
  end

  local dist = math.max(
    math.abs(pPos.x - tPos.x),
    math.abs(pPos.y - tPos.y)
  )

  local targetIsPlayer = (target.isPlayer and target:isPlayer()) or false

  local unsafeNow = false

  if not targetIsPlayer then
    if type(LNS_HAS_UNSAFE_CONDITION) == "function" then
      unsafeNow = LNS_HAS_UNSAFE_CONDITION() == true
    else
      unsafeNow = hasProtectedPlayerForUnsafe() == true
    end
  end

  -- respeita exhaust/global
  if combatGlobalUntil > now then
    return
  end

  -- monk system
  if monkHarmonyFlowActive() and not unsafeNow then
    if monkHarmonyGet() >= MONK_HARMONY_MAX then
      if tryUseMonkFinisher(dist, target, targetIsPlayer, pPos) then
        return
      end
    else
      if tryUseMonkBuilder(dist, target, targetIsPlayer, pPos) then
        return
      end
    end
  end

  --==================================================
  -- UNSAFE = somente magias SAFE
  --==================================================
  if unsafeNow then
    for _, attack in ipairs(cfg.attacks or {}) do
      if attack
      and attack.enabled
      and attack.safe == true then

        if tryUseAttack(
          attack,
          dist,
          target,
          targetIsPlayer,
          pPos,
          true
        ) then
          return
        end
      end
    end

    return
  end

  --==================================================
  -- SAFE = fluxo normal
  --==================================================
    for _, attack in ipairs(cfg.attacks or {}) do
      if tryUseAttack(
        attack,
        dist,
        target,
        targetIsPlayer,
        pPos,
        false
      ) then
        return
      end
    end
  end)
end

do
  if not loadCharStorage or not saveCharStorage then
  return print("[Healing] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function saveHealingChar()
  saveCharStorage(charStorage)
end

local switchHealing = "healingButton"

charStorage[switchHealing] = charStorage[switchHealing] or { enabled = false }

healingButton = setupUI([[
Panel
  height: 19
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Healing
    color: white
    height: 18

  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Config
    opacity: 1.00
    color: white
]])

healingButton:setId(switchHealing)
healingButton.title:setOn(charStorage[switchHealing].enabled == true)

healingButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  charStorage[switchHealing].enabled = newState
  saveHealingChar()
end

local PROFILE = "Default"
local MAX_ROWS = 3

charStorage.healingPanel = charStorage.healingPanel or {}
charStorage.healingPanel[PROFILE] = charStorage.healingPanel[PROFILE] or {
  spells = {},
  hp = {},
  mp = {},
  counts = {
    spells = 0,
    hp = 0,
    mp = 0
  }
}

local db = charStorage.healingPanel[PROFILE]
db.spells = db.spells or {}
db.hp = db.hp or {}
db.mp = db.mp or {}
db.counts = db.counts or {}

if db.counts.spells == nil then db.counts.spells = math.min(#db.spells, MAX_ROWS) end
if db.counts.hp == nil then db.counts.hp = math.min(#db.hp, MAX_ROWS) end
if db.counts.mp == nil then db.counts.mp = math.min(#db.mp, MAX_ROWS) end

local function clampCount(n)
  n = tonumber(n) or 0
  if n < 0 then return 0 end
  if n > MAX_ROWS then return MAX_ROWS end
  return n
end

local function realCount(kind)
  db.counts = db.counts or {}
  db.counts[kind] = clampCount(db.counts[kind])
  return db.counts[kind]
end

local function forceSaveKind(kind, list)
  list = list or {}

  local clean = {}
  for i = 1, math.min(#list, MAX_ROWS) do
    clean[#clean + 1] = list[i]
  end

  db[kind] = clean
  db.counts[kind] = #clean

  charStorage.healingPanel[PROFILE][kind] = clean
  charStorage.healingPanel[PROFILE].counts = db.counts

  saveHealingChar()
end

local panelHealing = setupUI([[
MainWindow
  size: 550 337
  text: Panel Healing
  margin-top: -50

  FlatPanel
    id: flatP
    anchors.fill: parent
    margin: -8
    margin-top: -5
    margin-bottom: 20

    Panel
      id: col1
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      width: 171
      margin: 6

      Label
        text: Spells
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font: verdana-11px-rounded
        text-auto-resize: true

      HorizontalSeparator
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        margin-top: 4

      TextList
        id: list1
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: controls1.top
        margin-top: 4
        margin-bottom: 4

      Panel
        id: controls1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 20

        Button
          id: add1
          text: +
          width: 40
          height: 20
          anchors.left: parent.left
          anchors.verticalCenter: parent.verticalCenter

        Label
          id: count1
          text: 0/3
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          font: verdana-11px-rounded
          text-auto-resize: true

        Button
          id: rem1
          text: -
          width: 40
          height: 20
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter

    Panel
      id: col2
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: col1.right
      width: 171
      margin-top: 6
      margin-bottom: 6
      margin-left: 6

      Label
        text: HP
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font: verdana-11px-rounded
        text-auto-resize: true

      HorizontalSeparator
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        margin-top: 4

      TextList
        id: list2
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: controls2.top
        margin-top: 4
        margin-bottom: 4

      Panel
        id: controls2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 20

        Button
          id: add2
          text: +
          width: 40
          height: 20
          anchors.left: parent.left
          anchors.verticalCenter: parent.verticalCenter

        Label
          id: count2
          text: 0/3
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          font: verdana-11px-rounded
          text-auto-resize: true

        Button
          id: rem2
          text: -
          width: 40
          height: 20
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter

    Panel
      id: col3
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: col2.right
      width: 172
      margin: 6

      Label
        text: MP
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font: verdana-11px-rounded
        text-auto-resize: true

      HorizontalSeparator
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        margin-top: 4

      TextList
        id: list3
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: controls3.top
        margin-top: 4
        margin-bottom: 4

      Panel
        id: controls3
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 20

        Button
          id: add3
          text: +
          width: 40
          height: 20
          anchors.left: parent.left
          anchors.verticalCenter: parent.verticalCenter

        Label
          id: count3
          text: 0/3
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          font: verdana-11px-rounded
          text-auto-resize: true

        Button
          id: rem3
          text: -
          width: 40
          height: 20
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter

  Button
    id: closePanel
    anchors.left: flatP.left
    anchors.right: flatP.right
    anchors.top: flatP.bottom
    margin-left: -1
    margin-top: 5
    text: Close
]], g_ui.getRootWidget())

panelHealing:hide()

if modules._G.g_app.isMobile() then
  panelHealing:setSize("550 357")
end

panelHealing.closePanel.onClick = function()
  panelHealing:hide()
end

healingButton.settings.onClick = function()
  panelHealing:show()
  panelHealing:raise()
  panelHealing:focus()
end

g_ui.loadUIFromString([[
SpellRow < Panel
  id: root
  height: 70
  focusable: true
  background-color: #4a4a4a
  border: 1 #2a2a2a
  opacity: 1.00
  margin-top: 2

  $hover:
    background-color: #555555
    border: 1 #6a6a6a

  $focus:
    background-color: #5d5d5d
    border: 1 #808080

  BotTextEdit
    id: spellText
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    font: verdana-11px-rounded
    margin-left: 4
    margin-right: 4
    margin-top: 3
    tooltip: Insert Spell Here

  HorizontalScrollBar
    id: hpScroll
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    margin-top: 3
    minimum: 0
    maximum: 100
    step: 1
    value: 80

  BotSwitch
    id: activeSwitch
    anchors.right: parent.right
    anchors.top: hpScroll.bottom
    margin-right: 5
    margin-top: 4
    size: 35 25
    text: OFF
    font: verdana-9px

  Label
    id: hpText
    anchors.left: hpScroll.left
    anchors.top: hpScroll.bottom
    margin-top: 2
    color: white
    text: HP <= 80%
    text-auto-resize: true

  Label
    id: manaText
    anchors.left: hpScroll.left
    anchors.top: hpText.bottom
    margin-top: 2
    color: white
    text: Mana: 0
    text-auto-resize: true
]])

g_ui.loadUIFromString([[
PotionRow < Panel
  id: root
  height: 70
  focusable: true
  background-color: #4a4a4a
  border: 1 #2a2a2a
  opacity: 1.00
  margin-top: 2

  $hover:
    background-color: #5d5d5d
    border: 1 #808080

  BotItem
    id: image
    anchors.left: parent.left
    anchors.top: parent.top
    margin-left: 4
    margin-top: 25
    size: 37 37

  HorizontalScrollBar
    id: Scroll
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    margin-left: 4
    margin-right: 4
    margin-top: 3
    minimum: 0
    maximum: 100
    step: 1
    value: 80

  BotSwitch
    id: activeBox
    anchors.right: parent.right
    anchors.verticalCenter: image.verticalCenter
    margin-right: 5
    margin-top: 4
    size: 35 25
    text: OFF
    font: verdana-9px

  Label
    id: hpText
    anchors.left: image.right
    anchors.verticalCenter: image.verticalCenter
    margin-left: 10
    margin-top: -1
    color: white
    font: verdana-11px-rounded
    text: HP <= 80%
]])

local selectedRows = {
  spells = nil,
  hp = nil,
  mp = nil
}

local SPELL_MANA_COST = {
  ["exura"] = 20,
  ["exura ico"] = 40,
  ["exura gran"] = 70,
  ["exura vita"] = 160,
  ["exura gran ico"] = 200,
  ["exura med ico"] = 90,
  ["exura infir ico"] = 160,
  ["exura san"] = 160,
  ["exura gran san"] = 210,
  ["utura"] = 60,
  ["utura gran"] = 100,
  ["utura mas sio"] = 140,
  ["exura sio"] = 140,
  ["exura gran sio"] = 200,
  ["exura mas res"] = 160,
  ["exura gran mas res"] = 250
}

local function trimText(text)
  return tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function resolveSpellMana(spellName)
  spellName = trimText(spellName):lower()
  if spellName == "" then return 0 end
  return SPELL_MANA_COST[spellName] or 0
end

local function getList(kind)
  if kind == "spells" then return panelHealing.flatP.col1.list1 end
  if kind == "hp" then return panelHealing.flatP.col2.list2 end
  return panelHealing.flatP.col3.list3
end

local function getCounter(kind)
  if kind == "spells" then return panelHealing.flatP.col1.controls1.count1 end
  if kind == "hp" then return panelHealing.flatP.col2.controls2.count2 end
  return panelHealing.flatP.col3.controls3.count3
end

local function refreshCounter(kind)
  getCounter(kind):setText(tostring(realCount(kind)) .. "/" .. MAX_ROWS)
end

local function refreshAllCounters()
  refreshCounter("spells")
  refreshCounter("hp")
  refreshCounter("mp")
end

local function setRowSelected(kind, row)
  selectedRows[kind] = row

  local list = getList(kind)
  for _, child in ipairs(list:getChildren()) do
    if child.setFocused then
      child:setFocused(child == row)
    end
  end
end

local function clearRowSelected(kind)
  selectedRows[kind] = nil
end

local function makeSpellEntry(data)
  data = data or {}

  local spell = tostring(data.spell or "")
  local hpValue = tonumber(data.hp) or 80
  local manaValue = tonumber(data.mana)

  if manaValue == nil then
    manaValue = resolveSpellMana(spell)
  end

  return {
    spell = spell,
    hp = hpValue,
    mana = manaValue or 0,
    enabled = data.enabled == true
  }
end

local function makePotionEntry(data, defaultItem)
  data = data or {}

  return {
    itemId = tonumber(data.itemId) or defaultItem,
    hp = tonumber(data.hp) or 80,
    enabled = data.enabled == true
  }
end

local function formatSpellName(text)
  text = trimText(text)
  text = text:gsub("%s+", " ")

  if text == "" then return "" end

  local words = {}
  for word in text:gmatch("%S+") do
    local first = word:sub(1, 1):upper()
    local rest = word:sub(2):lower()
    table.insert(words, first .. rest)
  end

  return table.concat(words, " ")
end

local function bindSpellRow(row, entry, kind)
  row._entry = entry

  row.spellText:setText(entry.spell or "")
  row.hpScroll:setValue(entry.hp or 80)
  row.hpText:setText("HP <= " .. tostring(entry.hp or 80) .. "%")
  row.manaText:setText("Mana: " .. tostring(entry.mana or 0))
  row.activeSwitch:setOn(entry.enabled == true)
  row.activeSwitch:setText(entry.enabled and "ON" or "OFF")

  row.onClick = function(widget)
    setRowSelected(kind, widget)
  end

  row.spellText.onTextChange = function(widget, text)
    local formatted = formatSpellName(text)

    if text ~= formatted then
      widget:setText(formatted)
      return
    end

    entry.spell = formatted
    entry.mana = resolveSpellMana(formatted)
    row.manaText:setText("Mana: " .. tostring(entry.mana))
    saveHealingChar()
  end

  row.hpScroll.onValueChange = function(widget, value)
    entry.hp = tonumber(value) or 80
    row.hpText:setText("HP <= " .. tostring(entry.hp) .. "%")
    saveHealingChar()
  end

  row.activeSwitch.onClick = function(widget)
    local state = not widget:isOn()
    widget:setOn(state)
    widget:setText(state and "ON" or "OFF")
    entry.enabled = state
    saveHealingChar()
  end
end

local function bindPotionRow(row, entry, kind)
  row._entry = entry

  row.Scroll:setValue(entry.hp or 80)

  if kind == "mp" then
    row.hpText:setText("MP <= " .. tostring(entry.hp or 80) .. "%")
  else
    row.hpText:setText("HP <= " .. tostring(entry.hp or 80) .. "%")
  end

  row.activeBox:setOn(entry.enabled == true)
  row.activeBox:setText(entry.enabled and "ON" or "OFF")

  if row.image and row.image.setItemId then
    row.image:setItemId(entry.itemId or 0)
  end

  row.onClick = function(widget)
    setRowSelected(kind, widget)
  end

  row.Scroll.onValueChange = function(widget, value)
    entry.hp = tonumber(value) or 80

    if kind == "mp" then
      row.hpText:setText("MP <= " .. tostring(entry.hp) .. "%")
    else
      row.hpText:setText("HP <= " .. tostring(entry.hp) .. "%")
    end

    saveHealingChar()
  end

  row.activeBox.onClick = function(widget)
    local state = not widget:isOn()
    widget:setOn(state)
    widget:setText(state and "ON" or "OFF")
    entry.enabled = state
    saveHealingChar()
  end

  if row.image then
    row.image.onItemChange = function(widget)
      local id = 0

      if widget.getItemId then
        id = tonumber(widget:getItemId()) or 0
      elseif widget.getItem and widget:getItem() and widget:getItem().getId then
        id = tonumber(widget:getItem():getId()) or 0
      end

      if id > 0 then
        entry.itemId = id
        saveHealingChar()
      end
    end

    row.image.onItemIdChange = function(widget, itemId)
      itemId = tonumber(itemId) or 0

      if itemId > 0 then
        entry.itemId = itemId
        saveHealingChar()
      end
    end
  end
end

local function createSpellRow(kind, entry)
  local row = g_ui.createWidget("SpellRow", getList(kind))
  bindSpellRow(row, entry, kind)
  return row
end

local function createPotionRow(kind, entry)
  local row = g_ui.createWidget("PotionRow", getList(kind))
  bindPotionRow(row, entry, kind)
  return row
end

local function clearList(kind)
  local list = getList(kind)

  for _, child in ipairs(list:getChildren()) do
    child:destroy()
  end

  clearRowSelected(kind)
end

local function normalizeInitialStorage()
  local kinds = {"spells", "hp", "mp"}

  for _, kind in ipairs(kinds) do
    local count = realCount(kind)
    local clean = {}

    for i = 1, count do
      local row = db[kind] and db[kind][i]

      if row then
        if kind == "spells" then
          clean[#clean + 1] = makeSpellEntry(row)
        elseif kind == "hp" then
          clean[#clean + 1] = makePotionEntry(row, 266)
        else
          clean[#clean + 1] = makePotionEntry(row, 268)
        end
      end
    end

    forceSaveKind(kind, clean)
  end
end

local function loadRows()
  clearList("spells")
  clearList("hp")
  clearList("mp")

  for i = 1, realCount("spells") do
    local entry = db.spells[i]
    if entry then
      db.spells[i] = makeSpellEntry(entry)
      createSpellRow("spells", db.spells[i])
    end
  end

  for i = 1, realCount("hp") do
    local entry = db.hp[i]
    if entry then
      db.hp[i] = makePotionEntry(entry, 266)
      createPotionRow("hp", db.hp[i])
    end
  end

  for i = 1, realCount("mp") do
    local entry = db.mp[i]
    if entry then
      db.mp[i] = makePotionEntry(entry, 268)
      createPotionRow("mp", db.mp[i])
    end
  end

  refreshAllCounters()
end

local function addRow(kind)
  local count = realCount(kind)
  if count >= MAX_ROWS then return end

  local clean = {}

  for i = 1, count do
    if db[kind][i] then
      clean[#clean + 1] = db[kind][i]
    end
  end

  local entry

  if kind == "spells" then
    entry = makeSpellEntry()
  elseif kind == "hp" then
    entry = makePotionEntry(nil, 266)
  else
    entry = makePotionEntry(nil, 268)
  end

  clean[#clean + 1] = entry

  forceSaveKind(kind, clean)
  loadRows()
end

local function removeRow(kind)
  local count = realCount(kind)
  if count <= 0 then return end

  local list = getList(kind)
  local children = list:getChildren()
  if #children == 0 then return end

  local row = selectedRows[kind] or children[#children]
  local removeIndex = nil

  for i, child in ipairs(children) do
    if child == row then
      removeIndex = i
      break
    end
  end

  if not removeIndex then return end

  local clean = {}

  for i = 1, count do
    if i ~= removeIndex and db[kind][i] then
      clean[#clean + 1] = db[kind][i]
    end
  end

  forceSaveKind(kind, clean)
  loadRows()
end

panelHealing.flatP.col1.controls1.add1.onClick = function()
  addRow("spells")
end

panelHealing.flatP.col1.controls1.rem1.onClick = function()
  removeRow("spells")
end

panelHealing.flatP.col2.controls2.add2.onClick = function()
  addRow("hp")
end

panelHealing.flatP.col2.controls2.rem2.onClick = function()
  removeRow("hp")
end

panelHealing.flatP.col3.controls3.add3.onClick = function()
  removeRow("mp")
end

panelHealing.flatP.col3.controls3.add3.onClick = function()
  addRow("mp")
end

panelHealing.flatP.col3.controls3.rem3.onClick = function()
  removeRow("mp")
end

normalizeInitialStorage()
loadRows()

local healProfile = PROFILE
local healSpellCooldown = 900
local healPotionCooldown = 250
local lastHealSpellCast = 0
local lastHealPotionUse = 0
local lastHealMpPotionUse = 0
local spellLock = false

local function nowMs()
  if g_clock and g_clock.millis then
    return g_clock.millis()
  end
  return now or 0
end

local function getHealDB()
  charStorage.healingPanel = charStorage.healingPanel or {}
  charStorage.healingPanel[healProfile] = charStorage.healingPanel[healProfile] or {
    spells = {},
    hp = {},
    mp = {},
    counts = {
      spells = 0,
      hp = 0,
      mp = 0
    }
  }

  charStorage.healingPanel[healProfile].spells = charStorage.healingPanel[healProfile].spells or {}
  charStorage.healingPanel[healProfile].hp = charStorage.healingPanel[healProfile].hp or {}
  charStorage.healingPanel[healProfile].mp = charStorage.healingPanel[healProfile].mp or {}
  charStorage.healingPanel[healProfile].counts = charStorage.healingPanel[healProfile].counts or {}

  return charStorage.healingPanel[healProfile]
end

local function getHealCount(hdb, kind)
  hdb.counts = hdb.counts or {}
  local n = tonumber(hdb.counts[kind]) or 0

  if n < 0 then return 0 end
  if n > MAX_ROWS then return MAX_ROWS end

  return n
end

local function normalizeSpellRow(row)
  if not row then return nil end
  if row.enabled ~= true then return nil end

  local spell = tostring(row.spell or row.words or "")
  local hpValue = tonumber(row.hp) or 0
  local manaValue = tonumber(row.mana) or 0

  if spell == "" then return nil end

  return {
    spell = spell,
    hp = hpValue,
    mana = manaValue
  }
end

local function normalizePotionRow(row, mode)
  if not row then return nil end
  if row.enabled ~= true then return nil end

  local itemId = tonumber(row.itemId) or 0
  local threshold = tonumber(row.hp) or tonumber(row.mp) or 0

  if itemId <= 0 then return nil end

  return {
    itemId = itemId,
    threshold = threshold,
    mode = mode
  }
end

local function getBestHealSpell()
  local hdb = getHealDB()
  local currentHp = hppercent()
  local currentMana = mana()
  local candidates = {}
  local count = getHealCount(hdb, "spells")

  for i = 1, count do
    local row = normalizeSpellRow(hdb.spells[i])
    if row and currentHp <= row.hp then
      candidates[#candidates + 1] = row
    end
  end

  if #candidates == 0 then return nil end

  table.sort(candidates, function(a, b)
    if a.hp ~= b.hp then
      return a.hp < b.hp
    end
    return a.mana > b.mana
  end)

  for _, row in ipairs(candidates) do
    if g_game.getClientVersion() >= 960 and currentMana >= row.mana then
      return row
    elseif g_game.getClientVersion() < 960 then
      return row
    end
  end

  return nil
end

local function getBestHpPotion()
  local hdb = getHealDB()
  local currentHp = hppercent()
  local best = nil
  local count = getHealCount(hdb, "hp")

  for i = 1, count do
    local row = normalizePotionRow(hdb.hp[i], "hp")
    if row and currentHp <= row.threshold then
      if not best or row.threshold < best.threshold then
        best = row
      end
    end
  end

  return best
end

local function getBestMpPotion()
  local hdb = getHealDB()
  local currentMp = manapercent()
  local best = nil
  local count = getHealCount(hdb, "mp")

  for i = 1, count do
    local row = normalizePotionRow(hdb.mp[i], "mp")
    if row and currentMp <= row.threshold then
      if not best or row.threshold < best.threshold then
        best = row
      end
    end
  end

  return best
end

onTalk(function(name, level, mode, text, channelId, pos)
  local localPlayer = g_game.getLocalPlayer()
  if not localPlayer or name ~= localPlayer:getName() then return end

  local hdb = getHealDB()
  local msg = tostring(text or ""):lower()
  local count = getHealCount(hdb, "spells")

  for i = 1, count do
    local row = normalizeSpellRow(hdb.spells[i])
    if row then
      local words = row.spell:lower()

      if words ~= "" and msg:find(words, 1, true) then
        spellLock = true
        lastHealSpellCast = nowMs()

        schedule(healSpellCooldown, function()
          spellLock = false
        end)

        return
      end
    end
  end
end)

macro(100, function()
  if not charStorage.healingButton or charStorage.healingButton.enabled ~= true then return end
  if spellLock then return end

  local t = nowMs()
  if t - lastHealSpellCast < healSpellCooldown then return end

  local best = getBestHealSpell()
  if not best then return end

  spellLock = true
  lastHealSpellCast = t
  pauseFriendHeal = now + 500
  say(best.spell)

  schedule(healSpellCooldown, function()
    spellLock = false
  end)
end)

macro(100, function()
  if not charStorage.healingButton or charStorage.healingButton.enabled ~= true then return end
  if pauseForMw and pauseForMw > now then return end

  local t = nowMs()
  if t - lastHealPotionUse < healPotionCooldown then return end

  local best = getBestHpPotion()
  if not best then return end

  local localPlayer = g_game.getLocalPlayer()
  if not localPlayer then return end

  lastHealPotionUse = t
  useWith(best.itemId, localPlayer)
end)

macro(100, function()
  if not charStorage.healingButton or charStorage.healingButton.enabled ~= true then return end
  if pauseForMw and pauseForMw > now then return end

  local t = nowMs()
  if t - lastHealMpPotionUse < healPotionCooldown then return end

  local best = getBestMpPotion()
  if not best then return end

  local localPlayer = g_game.getLocalPlayer()
  if not localPlayer then return end

  lastHealMpPotionUse = t
  useWith(best.itemId, localPlayer)
end)

saveHealingChar()

-- Prioridade absoluta para Healing próprio
macro(50, function()
  if not charStorage.healingButton or charStorage.healingButton.enabled ~= true then return end

  local critical = false

  local hdb = getHealDB()

  for i = 1, getHealCount(hdb, "spells") do
    local row = normalizeSpellRow(hdb.spells[i])
    if row and hppercent() <= row.hp then
      critical = true
      break
    end
  end

  for i = 1, getHealCount(hdb, "hp") do
    local row = normalizePotionRow(hdb.hp[i], "hp")
    if row and hppercent() <= row.threshold then
      critical = true
      break
    end
  end

  if critical then
    pauseFriendHeal = now + 700
  end
end)
end

do
  if not loadCharStorage or not saveCharStorage then
  return print("[Conditions] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function saveConditionsChar()
  saveCharStorage(charStorage)
end

local switchConditions = "conditionsButton"
local panelName = "conditionsInterface"

storage = storage or {}
charStorage[switchConditions] = charStorage[switchConditions] or { enabled = false }
charStorage[panelName] = charStorage[panelName] or {
  switches = {},
  combos = {},
  texts = {}
}

if charStorage[panelName].switches == nil and type(charStorage[panelName].checks) == "table" then
  charStorage[panelName].switches = charStorage[panelName].checks
  charStorage[panelName].checks = nil
end

charStorage[panelName].switches = charStorage[panelName].switches or {}
charStorage[panelName].combos   = charStorage[panelName].combos or {}
charStorage[panelName].texts    = charStorage[panelName].texts or {}

if storage[panelName] and not charStorage[panelName .. "_migrated"] then
  local old = storage[panelName]
  if type(old.switches) == "table" then
    for k, v in pairs(old.switches) do
      if charStorage[panelName].switches[k] == nil then
        charStorage[panelName].switches[k] = v
      end
    end
  end
  if type(old.combos) == "table" then
    for k, v in pairs(old.combos) do
      if charStorage[panelName].combos[k] == nil then
        charStorage[panelName].combos[k] = v
      end
    end
  end
  if type(old.texts) == "table" then
    for k, v in pairs(old.texts) do
      if charStorage[panelName].texts[k] == nil then
        charStorage[panelName].texts[k] = v
      end
    end
  end
  charStorage[panelName .. "_migrated"] = true
  saveConditionsChar()
end

if storage[switchConditions] and charStorage[switchConditions] and charStorage[switchConditions].enabled == nil then
  charStorage[switchConditions].enabled = storage[switchConditions].enabled == true
  saveConditionsChar()
end


conditionsButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Conditions
    color: white
    height: 18

  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Config
    opacity: 1.00
    color: white
]])

conditionsButton:setId(switchConditions)
conditionsButton.title:setOn(charStorage[switchConditions].enabled == true)

conditionsButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  charStorage[switchConditions].enabled = newState
  saveConditionsChar()
end

conditionsInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 350 270
  text: Perfect Conditions
  margin-top: -50

  FlatPanel
    id: infolist1
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 115
    margin-left: -4
    margin-right: -4

    BotSwitch
      id: spellHaste
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: 8
      margin-left: 8
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblHaste
      anchors.left: spellHaste.right
      anchors.verticalCenter: spellHaste.verticalCenter
      margin-left: 5
      text: Haste
      font: verdana-11px-rounded
      text-auto-resize: true

    ComboBox
      id: comboHaste
      anchors.right: parent.right
      anchors.verticalCenter: spellHaste.verticalCenter
      margin-right: 8
      width: 150
      @onSetup: |
        self:addOption("")
        self:addOption("Utani Hur")
        self:addOption("Utani Gran Hur")
        self:addOption("Utani Tempo Hur")
        self:addOption("Utamo Tempo San")

    BotSwitch
      id: spellBuff
      anchors.top: spellHaste.bottom
      anchors.left: spellHaste.left
      margin-top: 6
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblBuff
      anchors.left: spellBuff.right
      anchors.verticalCenter: spellBuff.verticalCenter
      margin-left: 5
      text: Buff
      font: verdana-11px-rounded
      text-auto-resize: true

    ComboBox
      id: comboBuff
      anchors.right: comboHaste.right
      anchors.verticalCenter: spellBuff.verticalCenter
      width: 150
      @onSetup: |
        self:addOption("")
        self:addOption("Utito Tempo")
        self:addOption("Utamo Tempo")
        self:addOption("Utito Tempo San")
        self:addOption("Utito Virtu")
        self:addOption("Utori Virtu")

    BotSwitch
      id: spellAntilyze
      anchors.top: spellBuff.bottom
      anchors.left: spellBuff.left
      margin-top: 6
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblAntiLyze
      anchors.left: spellAntilyze.right
      anchors.verticalCenter: spellAntilyze.verticalCenter
      margin-left: 5
      text: Anti-Lyze
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: comboAntilyze
      anchors.right: comboBuff.right
      anchors.verticalCenter: spellAntilyze.verticalCenter
      width: 150
      height: 20
      placeholder: Insert anti-lyze spell

    BotSwitch
      id: spellUtura
      anchors.top: spellAntilyze.bottom
      anchors.left: spellAntilyze.left
      margin-top: 6
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblUtura
      anchors.left: spellUtura.right
      anchors.verticalCenter: spellUtura.verticalCenter
      margin-left: 5
      text: Utura Gran
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: textUturaGran
      anchors.right: comboAntilyze.right
      anchors.verticalCenter: spellUtura.verticalCenter
      width: 150
      height: 20
      placeholder: Insert utura spell

  FlatPanel
    id: infolist2
    anchors.top: infolist1.bottom
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    height: 178
    margin-top: 8
    margin-bottom: 20
    margin-left: -4
    margin-right: -4

    BotSwitch
      id: spellUtamo
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: 8
      margin-left: 8
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblUtamo
      anchors.left: spellUtamo.right
      anchors.verticalCenter: spellUtamo.verticalCenter
      margin-left: 5
      text: Auto Magic Shield
      font: verdana-11px-rounded
      text-auto-resize: true

    BotSwitch
      id: spellUtana
      anchors.top: spellUtamo.bottom
      anchors.left: spellUtamo.left
      margin-top: 6
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblUtana
      anchors.left: spellUtana.right
      anchors.verticalCenter: spellUtana.verticalCenter
      margin-left: 5
      text: Auto Invisible
      font: verdana-11px-rounded
      text-auto-resize: true

    BotSwitch
      id: cureStatus
      anchors.top: spellUtana.bottom
      anchors.left: spellUtana.left
      margin-top: 6
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblCureStatus
      anchors.left: cureStatus.right
      anchors.verticalCenter: cureStatus.verticalCenter
      margin-left: 5
      text: Cure Status
      font: verdana-11px-rounded
      text-auto-resize: true

  Button
    id: closePanel
    anchors.left: infolist2.left
    anchors.right: infolist2.right
    anchors.top: infolist2.bottom
    margin-top: 5
    text: Close

]=], g_ui.getRootWidget())

conditionsInterface:hide()

local function getConditionWidget(id)
  if not conditionsInterface then return nil end
  return conditionsInterface:recursiveGetChildById(id)
end

if modules._G.g_app.isMobile() then
  conditionsInterface:setSize("350 290")
end

local closeBtn = getConditionWidget("closePanel")
if closeBtn then
  closeBtn.onClick = function()
    conditionsInterface:hide()
  end
end

conditionsButton.settings.onClick = function()
  if not conditionsInterface:isVisible() then
    conditionsInterface:show()
    conditionsInterface:raise()
    conditionsInterface:focus()
  end
end

local function bindSwitch(id)
  local w = getConditionWidget(id)
  if not w then
    warn("bindSwitch nao encontrou widget: " .. tostring(id))
    return
  end

  local saved = charStorage[panelName].switches[id]
  if saved ~= nil then
    w:setOn(saved == true)
  else
    charStorage[panelName].switches[id] = w:isOn() == true
    saveConditionsChar()
  end

  w.onClick = function(widget)
    local newState = not widget:isOn()
    widget:setOn(newState)
    charStorage[panelName].switches[id] = newState
    saveConditionsChar()
  end
end

local function bindCombo(id)
  local combo = getConditionWidget(id)
  if not combo then
    warn("bindCombo nao encontrou widget: " .. tostring(id))
    return
  end

  if charStorage[panelName].combos[id] ~= nil then
    combo:setCurrentOption(charStorage[panelName].combos[id])
  else
    charStorage[panelName].combos[id] = combo:getCurrentOption()
    saveConditionsChar()
  end

  combo.onOptionChange = function(widget, option)
    charStorage[panelName].combos[id] = option
    saveConditionsChar()
  end
end

local function bindText(id)
  local w = getConditionWidget(id)
  if not w then
    warn("bindText nao encontrou widget: " .. tostring(id))
    return
  end

  if charStorage[panelName].texts[id] ~= nil then
    w:setText(tostring(charStorage[panelName].texts[id]))
  else
    charStorage[panelName].texts[id] = w:getText() or ""
    saveConditionsChar()
  end

  w.onTextChange = function(widget, text)
    charStorage[panelName].texts[id] = tostring(text or "")
    saveConditionsChar()
  end
end

bindSwitch("spellHaste")
bindCombo("comboHaste")

bindSwitch("spellBuff")
bindCombo("comboBuff")

bindSwitch("spellAntilyze")
bindText("comboAntilyze")

bindSwitch("spellUtura")
bindText("textUturaGran")

bindSwitch("spellUtamo")
bindSwitch("spellUtana")
bindSwitch("cureStatus")

local userUturaTimer = 0
local userBuffTimer = 0
local utanaCast = 0

local function _trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function conditionsEnabled()
  return charStorage[switchConditions] and charStorage[switchConditions].enabled == true
end

local function getCondCfg()
  local cfg = charStorage[panelName]
  if not cfg then return nil end
  cfg.switches = cfg.switches or {}
  cfg.combos = cfg.combos or {}
  cfg.texts = cfg.texts or {}
  return cfg
end

onTalk(function(name, level, mode, text, channelId, pos)
  local player = g_game.getLocalPlayer()
  if not player then return end
  if name ~= player:getName() then return end

  text = tostring(text or ""):lower()

  local cfg = getCondCfg()
  if not cfg then return end

  local buffSpell = _trim(cfg.combos["comboBuff"]):lower()
  if buffSpell ~= "" and text == buffSpell then
    userBuffTimer = now + 10000
  end

  local uturaSpell = _trim(cfg.texts["textUturaGran"]):lower()
  if uturaSpell ~= "" and text == uturaSpell then
    userUturaTimer = now + 60500
  end
end)

local _lastMovePos = nil
local _lastMoveMs = 0

local function isMovingRecently(ms)
  ms = ms or 250
  local p = pos()
  if not p then return false end

  if not _lastMovePos then
    _lastMovePos = {x = p.x, y = p.y, z = p.z}
    return false
  end

  if p.x ~= _lastMovePos.x or p.y ~= _lastMovePos.y or p.z ~= _lastMovePos.z then
    _lastMovePos = {x = p.x, y = p.y, z = p.z}
    _lastMoveMs = now
    return true
  end

  return _lastMoveMs > 0 and now - _lastMoveMs <= ms
end

-- ANTI-LYZE
macro(100, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellAntilyze"] then return end
  if not isParalyzed() then return end

  local spell = _trim(cfg.texts["comboAntilyze"])
  if spell == "" then return end

  say(spell)
end)

-- HASTE
macro(200, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellHaste"] then return end
  if hasHaste() then return end
  if isParalyzed() then return end
  if isInPz() then return end
  if not isMovingRecently(250) then return end

  local spell = _trim(cfg.combos["comboHaste"])
  if spell == "" then return end

  say(spell)
end)

-- BUFF / UTITO / UTAMO TEMPO / ETC
macro(200, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellBuff"] then return end
  if userBuffTimer and userBuffTimer >= now then return end
  if not g_game.isAttacking() then return end

  local spell = _trim(cfg.combos["comboBuff"])
  if spell == "" then return end

  say(spell)
  userBuffTimer = now + 10000
end)

-- UTURA GRAN / REGEN
macro(500, function()
  if not conditionsEnabled() then return end

  local player = g_game.getLocalPlayer()
  if not player then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellUtura"] then return end
  if userUturaTimer and userUturaTimer >= now then return end
  if player:getMana() < 200 then return end

  local spell = _trim(cfg.texts["textUturaGran"])
  if spell == "" then spell = "utura gran" end

  say(spell)
  userUturaTimer = now + 60500
end)

-- CURE STATUS
macro(200, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["cureStatus"] then return end
  if g_game.isAttacking() then return end

  if isPoisioned() then
    say("exana pox")
    return
  end

  if isBurning() then
    say("exana flam")
    return
  end

  if isEnergized() then
    say("exana vis")
    return
  end

  if isCursed() then
    say("exana mort")
    return
  end

  if isBleeding() then
    say("exana kor")
    return
  end
end)

-- AUTO MAGIC SHIELD
macro(200, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellUtamo"] then return end
  if hasManaShield() then return end

  say("utamo vita")
end)

-- AUTO INVISIBLE
macro(200, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellUtana"] then return end
  if mana() < 441 then return end
  if utanaCast > 0 and now - utanaCast < 120000 then return end

  say("utana vid")
  utanaCast = now
end)
end

do
  if not loadCharStorage or not saveCharStorage then
  return print("[Heal Friend] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function saveHealFriendChar()
  saveCharStorage(charStorage)
end

local function trimText(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function lowerTrim(s)
  return trimText(s):lower()
end

local function getBotItemId(widget)
  if not widget then return 0 end
  if widget.getItemId then
    local ok, id = pcall(function() return widget:getItemId() end)
    if ok and id and id > 0 then return id end
  end
  if widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and item.getId then
      local ok2, id = pcall(function() return item:getId() end)
      if ok2 and id and id > 0 then return id end
    end
  end
  return 0
end

-- ===============================
-- BUTTON
-- ===============================
switchSio = "sioButton"
charStorage[switchSio] = charStorage[switchSio] or { enabled = false }

sioButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Healing Friend
    height: 18
    color: white

  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Config
    opacity: 1.00
    color: white
]])
sioButton:setId(switchSio)
sioButton.title:setOn(charStorage[switchSio].enabled)

sioButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  charStorage[switchSio].enabled = newState
  saveHealFriendChar()
end

local prioRowTemplate = [[
UIWidget
  height: 19
  margin-top: 1
  background-color: #2a2a2a
  border: 1 #3a3a3a

  Label
    id: voc
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    color: white
    text: ""

  Button
    id: down
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 2
    text: v
    color: white

  Button
    id: up
    anchors.right: down.left
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 2
    text: ^
    color: white
]]

sioInterface = setupUI([[
MainWindow
  id: mainPanel
  size: 380 390
  border: 1 black
  text: Panel Heal-Friend
  anchors.centerIn: parent
  margin-top: -50

  Panel
    id: infolist1
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    size: 270 200
    image-source: /images/ui/miniwindow
    image-border: 20
    margin-left: -4
    margin-right: -4

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Settings for Heal Friend
      margin-top: 2

  Label
    id: labelSelectType
    anchors.top: infolist1.top
    anchors.left: infolist1.left
    margin-top: 25
    margin-left: 10
    text: Mode Healing:
    text-auto-resize: true

  BotSwitch
    id: UseSpell
    anchors.verticalCenter: labelSelectType.verticalCenter
    anchors.left: labelSelectType.right
    margin-left: 10
    size: 125 19
    text: Health Spell

  BotSwitch
    id: UsePotion
    anchors.verticalCenter: labelSelectType.verticalCenter
    anchors.left: UseSpell.right
    margin-left: 1
    size: 125 19
    text: Health Item

  Label
    id: hpCura
    anchors.top: UseSpell.bottom
    anchors.left: labelSelectType.left
    text: Friend HP%:
    margin-top: 6

  HorizontalScrollBar
    id: percentHp
    anchors.verticalCenter: hpCura.verticalCenter
    anchors.left: UseSpell.left
    anchors.right: parent.right
    margin-right: 5
    minimum: 1
    maximum: 100

  Label
    id: percentHpValue
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.left
    anchors.right: prev.right
    text-align: center
    text: 80%
    color: white

  Label
    id: distancePotion
    anchors.top: hpCura.bottom
    anchors.left: labelSelectType.left
    text: Distance Item:
    margin-top: 8

  HorizontalScrollBar
    id: distUsePot
    anchors.verticalCenter: distancePotion.verticalCenter
    anchors.left: UseSpell.left
    anchors.right: parent.right
    margin-right: 5
    minimum: 1
    maximum: 10

  Label
    id: distUsePotValue
    anchors.verticalCenter: distUsePot.verticalCenter
    anchors.left: prev.left
    anchors.right: prev.right
    text-align: center
    text: 3 Sqm
    color: white

  Label
    id: labelSolicitar
    anchors.top: distancePotion.bottom
    anchors.left: labelSelectType.left
    text: Ask Mana:
    margin-top: 8

  HorizontalScrollBar
    id: percentMp
    anchors.verticalCenter: labelSolicitar.verticalCenter
    anchors.left: UseSpell.left
    anchors.right: parent.right
    margin-right: 5
    minimum: 1
    maximum: 100

  Label
    id: percentMpValue
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.left
    anchors.right: prev.right
    text-align: center
    text: 50%
    color: white

  HorizontalSeparator
    id: sepHor
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5

  Label
    id: HealingSpells
    anchors.top: sepHor.bottom
    anchors.left: distancePotion.left
    margin-top: 10
    text: Healing Spells:

  CheckBox
    id: exuraSio
    anchors.top: HealingSpells.bottom
    anchors.left: HealingSpells.left
    margin-top: 5
    text: Exura Sio
    text-auto-resize: true
    color: gray
    $checked:
      color: green

  CheckBox
    id: masRes
    anchors.top: exuraSio.bottom
    anchors.left: exuraSio.left
    margin-top: 8
    text: Mas Res
    text-auto-resize: true
    color: gray
    $checked:
      color: green

  CheckBox
    id: checkOtherSpell
    anchors.top: masRes.bottom
    anchors.left: masRes.left
    margin-top: 8

  TextEdit
    id: otherSpell
    anchors.verticalCenter: checkOtherSpell.verticalCenter
    anchors.left: checkOtherSpell.right
    size: 110 19
    margin-left: 7
    placeholder: Other Spell

  Label
    id: labelPotion
    anchors.top: HealingSpells.top
    anchors.left: otherSpell.right
    margin-left: 40
    text: Health Potion:

  BotItem
    id: potionID
    anchors.left: prev.right
    anchors.verticalCenter: prev.verticalCenter
    margin-left: 58
    margin-top: 2

  Label
    id: labelPotionMP
    anchors.top: labelPotion.top
    anchors.left: labelPotion.left
    margin-top: 45
    text: Mana Potion:

  BotItem
    id: potionMPID
    anchors.left: potionID.left
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 3

  Panel
    id: infolist2
    anchors.top: infolist1.bottom
    anchors.left: infolist1.left
    size: 200 130
    image-source: /images/ui/miniwindow
    image-border: 20
    margin-top: 5

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Heal Toggles
      margin-top: 2

  BotSwitch
    id: friendList
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    margin: 10
    margin-top: 22
    width: 18
    text: Friend List

  BotSwitch
    id: partyMembers
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 4
    width: 18
    text: Party Members

  BotSwitch
    id: guildMembers
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 4
    width: 18
    text: Guild Members

  BotSwitch
    id: cureMPFriend
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 4
    width: 18
    text: Request Mana

  ComboBox
    id: selectChat
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 4
    height: 20
    @onSetup: |
      self:addOption("Default")
      self:addOption("Party Channel")

  Panel
    id: infolist3
    anchors.top: infolist2.top
    anchors.left: infolist2.right
    anchors.right: parent.right
    margin-right: -4
    margin-left: 7
    image-source: /images/ui/miniwindow
    image-border: 20
    height: 130

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Priority List
      margin-top: 2

  TextList
    id: prioList
    anchors.top: infolist3.top
    anchors.left: infolist3.left
    anchors.right: infolist3.right
    margin-top: 20
    margin-left: 5
    margin-right: 5
    height: 105
    image-source: ""

  BotSwitch
    id: listPrio
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    width: 18
    margin-top: 83
    text: Priority Vocation

  Button
    id: closePanel
    anchors.left: infolist2.left
    anchors.right: infolist3.right
    anchors.top: prioList.bottom
    size: 35 20
    margin-top: 9
    text: Close
]], g_ui.getRootWidget())

sioInterface:hide()

if modules._G.g_app.isMobile() then
  sioInterface:setSize("380 410")
end

sioInterface.closePanel.onClick = function()
  sioInterface:hide()
end

sioButton.settings.onClick = function()
  if sioInterface:isVisible() then
    sioInterface:hide()
  else
    sioInterface:show()
    sioInterface:raise()
    sioInterface:focus()
  end
end

-- ===============================
-- MIGRACAO STORAGE ANTIGO -> CHARSTORAGE
-- ===============================
if storage and storage.healFriend and not charStorage.healFriendMigrated then
  charStorage.healFriend = charStorage.healFriend or {}
  for k, v in pairs(storage.healFriend) do
    if charStorage.healFriend[k] == nil then
      charStorage.healFriend[k] = v
    end
  end
  charStorage.healFriendMigrated = true
  saveHealFriendChar()
end

if storage and storage[switchSio] and not charStorage.sioButtonMigrated then
  charStorage[switchSio] = charStorage[switchSio] or {}
  if charStorage[switchSio].enabled == nil then
    charStorage[switchSio].enabled = storage[switchSio].enabled == true
  end
  charStorage.sioButtonMigrated = true
  saveHealFriendChar()
end

if not charStorage.healFriend then
  charStorage.healFriend = {
    useSpell = false,
    usePotion = false,
    percentHp = 80,
    distUsePot = 3,
    percentMp = 50,
    exuraSio = true,
    masRes = false,
    checkOtherSpell = false,
    otherSpell = "",
    potionID = 0,
    potionMPID = 0,
    friendList = false,
    partyMembers = false,
    guildMembers = false,
    listPrio = false,
    cureMPFriend = false,
    selectChat = "Default",
    prioOrder = { "Knight", "Paladin", "Monk", "Mage" }
  }
end

local config = charStorage.healFriend
config.prioOrder = config.prioOrder or { "Knight", "Paladin", "Monk", "Mage" }

local function saveConfig()
  saveHealFriendChar()
end

sioInterface.selectChat:setCurrentOption(config.selectChat)

sioInterface.selectChat.onOptionChange = function(widget, option)
  config.selectChat = option
  saveConfig()
end

local function setScrollLabel(label, value, suffix)
  label:setText(tostring(value) .. (suffix or ""))
end

local function clearChildren(w)
  if not w then return end
  local ch = w:getChildren() or {}
  for i = #ch, 1, -1 do
    local c = ch[i]
    if c and not c:isDestroyed() then c:destroy() end
  end
end

local function swap(t, i, j)
  if type(t) ~= "table" then return end
  if i < 1 or j < 1 or i > #t or j > #t then return end
  t[i], t[j] = t[j], t[i]
end

local function rebuildPrioList()
  clearChildren(sioInterface.prioList)

  local fixed = { "Knight", "Paladin", "Monk", "Mage" }

  if type(config.prioOrder) ~= "table" or #config.prioOrder ~= 4 then
    config.prioOrder = fixed
    saveConfig()
  end

  for i = 1, #config.prioOrder do
    local voc = config.prioOrder[i]
    local row = setupUI(prioRowTemplate, sioInterface.prioList)

    row.voc:setText(voc)

    row.up.onClick = function()
      swap(config.prioOrder, i, i - 1)
      saveConfig()
      rebuildPrioList()
    end

    row.down.onClick = function()
      swap(config.prioOrder, i, i + 1)
      saveConfig()
      rebuildPrioList()
    end

    if i == 1 then row.up:setEnabled(false) end
    if i == #config.prioOrder then row.down:setEnabled(false) end
  end
end

rebuildPrioList()

sioInterface.UseSpell.onClick = function(widget)
  config.useSpell = not config.useSpell
  widget:setOn(config.useSpell)
  if config.useSpell then
    config.usePotion = false
    sioInterface.UsePotion:setOn(false)
  end
  saveConfig()
end
sioInterface.UseSpell:setOn(config.useSpell)

sioInterface.UsePotion.onClick = function(widget)
  config.usePotion = not config.usePotion
  widget:setOn(config.usePotion)
  if config.usePotion then
    config.useSpell = false
    sioInterface.UseSpell:setOn(false)
  end
  saveConfig()
end
sioInterface.UsePotion:setOn(config.usePotion)

sioInterface.percentHp.onValueChange = function(scroll, value)
  config.percentHp = value
  setScrollLabel(sioInterface.percentHpValue, value, "%")
  saveConfig()
end
sioInterface.percentHp:setValue(config.percentHp)
setScrollLabel(sioInterface.percentHpValue, config.percentHp, "%")

sioInterface.distUsePot.onValueChange = function(scroll, value)
  config.distUsePot = value
  setScrollLabel(sioInterface.distUsePotValue, value, " Sqm")
  saveConfig()
end
sioInterface.distUsePot:setValue(config.distUsePot)
setScrollLabel(sioInterface.distUsePotValue, config.distUsePot, " Sqm")

sioInterface.percentMp.onValueChange = function(scroll, value)
  config.percentMp = value
  setScrollLabel(sioInterface.percentMpValue, value, "%")
  saveConfig()
end
sioInterface.percentMp:setValue(config.percentMp)
setScrollLabel(sioInterface.percentMpValue, config.percentMp, "%")

sioInterface.exuraSio.onClick = function(widget)
  config.exuraSio = not config.exuraSio
  widget:setChecked(config.exuraSio)
  saveConfig()
end
sioInterface.exuraSio:setChecked(config.exuraSio)

sioInterface.masRes.onClick = function(widget)
  config.masRes = not config.masRes
  widget:setChecked(config.masRes)
  saveConfig()
end
sioInterface.masRes:setChecked(config.masRes)

sioInterface.checkOtherSpell.onClick = function(widget)
  config.checkOtherSpell = not config.checkOtherSpell
  widget:setChecked(config.checkOtherSpell)
  saveConfig()
end
sioInterface.checkOtherSpell:setChecked(config.checkOtherSpell)

sioInterface.otherSpell.onTextChange = function(widget, text)
  config.otherSpell = text
  saveConfig()
end
sioInterface.otherSpell:setText(config.otherSpell)

sioInterface.potionID.onItemChange = function(widget)
  config.potionID = getBotItemId(widget)
  saveConfig()
end
sioInterface.potionID:setItemId(config.potionID)

sioInterface.potionMPID.onItemChange = function(widget)
  config.potionMPID = getBotItemId(widget)
  saveConfig()
end
sioInterface.potionMPID:setItemId(config.potionMPID)

local toggles = {"friendList", "partyMembers", "guildMembers", "listPrio", "cureMPFriend"}
for _, id in ipairs(toggles) do
  sioInterface[id].onClick = function(widget)
    config[id] = not config[id]
    widget:setOn(config[id])
    saveConfig()
  end
  sioInterface[id]:setOn(config[id])
end

saveConfig()

-----------------------------
-- MACRO DE PEDIR MP
-----------------------------
macro(200, function()
  if not charStorage[switchSio] or not charStorage[switchSio].enabled then
    return
  end
  if not config or not config.cureMPFriend then
    return
  end

  local manaPercent = config.percentMp
  local chatSelecionado = config.selectChat
  if manapercent() <= manaPercent then
    if chatSelecionado == "Default" then
      say("p")
      delay(4000)
    elseif chatSelecionado == "Party Channel" then
      sayChannel(1, "p")
      delay(4000)
    end
  end
end)

macro(100, function()
  if pauseFriendHeal and pauseFriendHeal > now then return end
  if not charStorage[switchSio] or not charStorage[switchSio].enabled then return end

  local player = g_game.getLocalPlayer()
  if not player then return end

  local spectators = getSpectators()
  if not spectators then return end

  local targets = {}
  local minHp = config.percentHp or 80

  -- =========================
  -- COLETA PLAYERS
  -- =========================
  for _, creature in ipairs(spectators) do
    if creature:isPlayer() and creature:getName() ~= player:getName() then
      local hp = 100
      if creature.getHealthPercent then
        hp = creature:getHealthPercent()
      end

      if hp and hp > 0 and hp <= minHp then
        table.insert(targets, {
          creature = creature,
          hp = hp
        })
      end
    end
  end

  if #targets == 0 then return end

  -- =========================
  -- FILTRO (SAFE)
  -- =========================
  local function isFriendName(n)
    if storage.playerList and type(storage.playerList.friendList) == "table" then
      for _, fName in ipairs(storage.playerList.friendList) do
        if lowerTrim(fName) == lowerTrim(n) then return true end
      end
    end
    return false
  end

  local function canHeal(creature)
    local name = creature:getName()

    if config.friendList and isFriend and isFriend(name) then return true end
    if config.friendList and isFriendName(name) then return true end
    if config.partyMembers and creature.isPartyMember and creature:isPartyMember() then return true end
    if config.guildMembers and creature.isGuildMember and creature:isGuildMember() then return true end

    if not config.friendList and not config.partyMembers and not config.guildMembers then
      return true
    end

    return false
  end

  local valid = {}
  for _, t in ipairs(targets) do
    if canHeal(t.creature) then
      table.insert(valid, t)
    end
  end

  if #valid == 0 then return end

  -- =========================
  -- PRIORIDADE
  -- =========================
  local rankMap = {}
  if config.listPrio then
    local order = config.prioOrder or { "Knight", "Paladin", "Monk", "Mage" }
    for i = 1, #order do
      rankMap[order[i]:upper()] = i
    end
  end

  local function getVocCodeFromCheckText(creature)
    if not creature or not creature.getText then return nil end
    local t = creature:getText() or ""
    if t == "" then return nil end

    local code = t:match("%d+%s*(%u%u)")
    if not code then code = t:match("(%u%u)") end
    return code
  end

  local function vocGroupFromCode(code)
    if code == "EK" then return "KNIGHT" end
    if code == "RP" then return "PALADIN" end
    if code == "EM" then return "MONK" end
    if code == "MS" or code == "ED" then return "MAGE" end
    return nil
  end

  local function getPrioRankForCreature(creature)
    local code = getVocCodeFromCheckText(creature)
    local group = vocGroupFromCode(code)
    if not group then return 9999 end
    return rankMap[group] or 9999
  end

  table.sort(valid, function(a, b)
    if not config.listPrio then
      return a.hp < b.hp
    end

    local pa = getPrioRankForCreature(a.creature)
    local pb = getPrioRankForCreature(b.creature)

    if pa == pb then
      return a.hp < b.hp
    end

    return pa < pb
  end)

  local target = valid[1]
  if not target then return end

  local t = target.creature
  local tName = t:getName()

  -- =========================
  -- SPELL HEAL
  -- =========================
  if config.useSpell then
    if config.exuraSio then
      if (not pauseFriendHeal or pauseFriendHeal <= now) then
        say('exura sio "' .. tName)
      end
      delay(500)
      return
    end

    if config.masRes then
      if (not pauseFriendHeal or pauseFriendHeal <= now) then
        say("exura gran mas res")
      end
      delay(500)
      return
    end

    if config.checkOtherSpell and trimText(config.otherSpell) ~= "" then
      if (not pauseFriendHeal or pauseFriendHeal <= now) then
        say(config.otherSpell .. ' "' .. tName)
      end
      delay(500)
      return
    end
  end

  -- =========================
  -- POTION HEAL
  -- =========================
  if config.usePotion and config.potionID and config.potionID > 0 then
    local dist = getDistanceBetween(player:getPosition(), t:getPosition())

    if dist <= (config.distUsePot or 3) then
      if g_game.useInventoryItemWith then
        g_game.useInventoryItemWith(config.potionID, t)
      else
        useWith(config.potionID, t)
      end
      return
    end
  end
end)

-- =========================================
-- LISTENER: DAR MANA PARA QUEM PEDIR "P"
-- =========================================
onTalk(function(name, level, mode, text, channelId, pos)
  text = lowerTrim(text)
  if text ~= "p" then return end

  if not charStorage[switchSio] or not charStorage[switchSio].enabled then
    warn("[Mana Help] Bloqueado: O painel geral (Healing Friend) esta desligado.")
    return
  end

  local mpId = config.potionMPID
  if not mpId or mpId <= 100 then
    warn("[Mana Help] Bloqueado: Nenhuma Potion MP configurada no painel. ID lido: " .. tostring(mpId))
    return
  end

  local player = g_game.getLocalPlayer()
  if not player or name == player:getName() then return end

  local targetCreature = nil
  for _, creature in ipairs(getSpectators()) do
    if creature:isPlayer() and lowerTrim(creature:getName()) == lowerTrim(name) then
      targetCreature = creature
      break
    end
  end

  if not targetCreature then
    warn("[Mana Help] Bloqueado: O player " .. name .. " pediu mana mas nao esta na sua tela.")
    return
  end

  local dist = getDistanceBetween(player:getPosition(), targetCreature:getPosition())
  if dist > 1 then
    warn("[Mana Help] Bloqueado: O player " .. name .. " pediu mana mas esta longe. Distancia: " .. dist)
    return
  end

  local function isFriendName(n)
    if storage.playerList and type(storage.playerList.friendList) == "table" then
      for _, fName in ipairs(storage.playerList.friendList) do
        if lowerTrim(fName) == lowerTrim(n) then return true end
      end
    end
    return false
  end

  local validTarget = false
  if config.friendList and isFriend and isFriend(name) then validTarget = true end
  if config.friendList and isFriendName(name) then validTarget = true end
  if config.partyMembers and targetCreature.isPartyMember and targetCreature:isPartyMember() then validTarget = true end

  if config.guildMembers then
    if targetCreature.isGuildMember and targetCreature:isGuildMember() then validTarget = true end
    if targetCreature.getEmblem and targetCreature:getEmblem() == 1 then validTarget = true end
    if targetCreature.getShield and targetCreature:getShield() == 1 then validTarget = true end
  end

  if validTarget then
    warn("[Mana Help] Sucesso! Usando Potion no player: " .. name)

    schedule(50, function()
      if g_game.useInventoryItemWith then
        g_game.useInventoryItemWith(mpId, targetCreature)
      else
        useWith(mpId, targetCreature)
      end
    end)
  else
    warn("[Mana Help] Bloqueado: O player " .. name .. " esta colado, mas nao eh seu amigo, party ou guild ativo no painel.")
  end
end)
end

do
    setDefaultTab("Main")

PANEL_NAME = "lnsFollow"
SWITCH_FOLLOW = "followButton"

charStorage = charStorage or loadCharStorage()

local function trim(str)
  str = tostring(str or "")
  return str:match("^%s*(.-)%s*$")
end

local defaultStrings = {386, 12202, 21965, 21966}
local defaultUse = {1948, 5542, 7771, 20475, 20573, 31262, 21297, 1968, 31130, 31129, 435, 21298}
local defaultDoors = {8265, 7727, 5111, 8261, 8259, 5113, 1646, 9567, 9558, 5287, 5289, 6260, 22506, 5122, 1112, 7712, 7721, 7723, 6258}
local defaultTeleports = {}

local function copyList(t)
  local r = {}
  for i, v in ipairs(t or {}) do r[i] = v end
  return r
end

local function applyDefaultIfEmpty(target, default)
  if type(target) ~= "table" or #target == 0 then
    return copyList(default)
  end
  return target
end

charStorage.follow2Panel = charStorage.follow2Panel or {
  leaderName = "",
  followerName = "",
  ueSpell = "",
  openPt = false,
  commandAttack = false,
  selectChat = "Default",
  idsToFollow = {
    strings = {},
    use = {},
    doorsClosed = {},
    teleports = {}
  }
}

followCfg = charStorage.follow2Panel
followCfg.leaderName = tostring(followCfg.leaderName or "")
followCfg.followerName = tostring(followCfg.followerName or "")
followCfg.ueSpell = tostring(followCfg.ueSpell or "")
followCfg.openPt = followCfg.openPt == true
followCfg.commandAttack = followCfg.commandAttack == true
followCfg.selectChat = tostring(followCfg.selectChat or "Default")
followCfg.enabled = followCfg.enabled == true
followCfg.isLeader = followCfg.isLeader == true
followCfg.idsToFollow = followCfg.idsToFollow or {}
followCfg.idsToFollow.strings = applyDefaultIfEmpty(followCfg.idsToFollow.strings, defaultStrings)
followCfg.idsToFollow.use = applyDefaultIfEmpty(followCfg.idsToFollow.use, defaultUse)
followCfg.idsToFollow.doorsClosed = applyDefaultIfEmpty(followCfg.idsToFollow.doorsClosed, defaultDoors)
followCfg.idsToFollow.teleports = type(followCfg.idsToFollow.teleports) == "table" and followCfg.idsToFollow.teleports or copyList(defaultTeleports)

storage[SWITCH_FOLLOW] = storage[SWITCH_FOLLOW] or {}
storage[SWITCH_FOLLOW].enabled = followCfg.enabled
storage[SWITCH_FOLLOW].leader = followCfg.isLeader

local S = followCfg
S.texts = S.texts or {}
S.switches = S.switches or {}
S.stairIDS = S.stairIDS or {484, 17394, 1977, 414}
S.buracoIDS = S.buracoIDS or {1959}

local function syncCompat()
  S.texts.navAttack = tostring(followCfg.leaderName or "")
  S.texts.navLeader = tostring(followCfg.followerName or "")
  S.texts.UESpell = tostring(followCfg.ueSpell or "")
  S.texts.ropeID = tostring(S.texts.ropeID or "3003")

  S.switches.attackCheck = followCfg.enabled == true
  S.switches.followCheck = followCfg.enabled == true
  S.switches.useUEcheck = S.switches.useUEcheck == true
  S.switches.abrirChatParty = followCfg.openPt == true
  S.switches.debug = S.switches.debug == true

  S.ropeIDS = followCfg.idsToFollow.strings or {}
  S.useIDS = followCfg.idsToFollow.use or {}
  S.doorsIDS = followCfg.idsToFollow.doorsClosed or {}
  S.teleportIDS = followCfg.idsToFollow.teleports or {}

  storage[SWITCH_FOLLOW].enabled = followCfg.enabled == true
  storage[SWITCH_FOLLOW].leader = followCfg.isLeader == true
end

local function saveFollow2()
  syncCompat()
  saveCharStorage(charStorage)
end

syncCompat()

local State = {
  leader = nil,
  leaderPositions = {},
  leaderDirections = {},
  leaderUsePositions = {},
  lastLeaderFloor = nil,
  standTime = now,
  fecharChannel = 0,
  leaderWait = 0,
  lastTarget = nil,
  lastDoorUse = 0,
  lastRopeUse = 0,
  lastUseTry = 0,
  lastWalkTry = 0,
  lastFollowTry = 0,
  lastFloorTry = 0,
  lastLeaderSeenAt = 0,
}

-- FOLLOW AGRESSIVO ENQUANTO ATACA
-- Baseado na lógica da script 2: não usa g_game.follow(),
-- só autoWalk rápido para o melhor sqm em volta do leader.
local ATTACK_WALK_INTERVAL = 60

local AttackFollow = {
  lastWalk = 0,
  stuckCount = 0,
  lastPosKey = ""
}

local function dbg(msg)
  if S.switches.debug then
    print("[LNS FOLLOW] " .. msg)
  end
end

local function getLeaderName()
  return trim(tostring(followCfg.followerName or ""))
end

local function getAttackLeaderName()
  return trim(tostring(followCfg.leaderName or ""))
end

local function saveFollowSetting(key, value)
  S.texts[key] = value
  saveFollow2()
end

local function safeText(id, default)
  if S.texts[id] == nil then
    S.texts[id] = default
  end
  return S.texts[id]
end

local function containsId(list, id)
  if not list then return false end
  local wanted = tonumber(id)
  if not wanted then return false end

  for _, entry in ipairs(list) do
    local entryId = nil
    if type(entry) == "table" then
      entryId = tonumber(entry.id)
    else
      entryId = tonumber(entry)
    end
    if entryId == wanted then
      return true
    end
  end
  return false
end

local function isPartyReady()
  return player:isPartyMember() or player:isPartyLeader() or player:getShield() > 2
end

local function canRetry(lastTime, delayMs)
  return now >= (lastTime + delayMs)
end

local function resetLeaderCache()
  State.leader = nil
  State.leaderPositions = {}
  State.leaderDirections = {}
  State.leaderUsePositions = {}
  State.lastLeaderFloor = nil
  State.lastLeaderSeenAt = 0
end

local function setFollowEnabled(value)
  storage[SWITCH_FOLLOW].enabled = value
  if not value then
    g_game.cancelFollow()
    resetLeaderCache()
    dbg("Follow desligado e cache resetado.")
  end
end

local function updateToolsScripts()
  if storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].leader then
    if toolsScripts then toolsScripts:show() end
  else
    if toolsScripts then toolsScripts:hide() end
  end
end

local function distanceManhattan(pos1, pos2)
  pos2 = pos2 or player:getPosition()
  return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

local function matchPos(p1, p2)
  return p1 and p2 and p1.x == p2.x and p1.y == p2.y and p1.z == p2.z
end

local function getVisibleLeader()
  local name = getLeaderName()
  if name == "" then return nil end

  local c = getCreatureByName(name)
  if c and c:getPosition().z == posz() then
    return c
  end
  return nil
end

local function handleUse(pos)
  if not canRetry(State.lastUseTry, 200) then return false end
  State.lastUseTry = now

  local tile = g_map.getTile(pos)
  if tile and tile:getTopUseThing() then
    g_game.use(tile:getTopUseThing())
    dbg("Usando tile em " .. pos.x .. "," .. pos.y .. "," .. pos.z)
    return true
  end
  return false
end

local function handleRope(pos)
  if not canRetry(State.lastRopeUse, 300) then return false end
  State.lastRopeUse = now

  local ropeIdd = tonumber(S.texts.ropeID or "3003")
  local tile = g_map.getTile(pos)
  if tile and tile:getTopUseThing() and ropeIdd then
    useWith(ropeIdd, tile:getTopUseThing())
    dbg("Usando rope em " .. pos.x .. "," .. pos.y .. "," .. pos.z)
    return true
  end
  return false
end

local function handleStep(pos)
  if not canRetry(State.lastWalkTry, 200) then return false end
  State.lastWalkTry = now
  autoWalk(pos, 40, {ignoreNonPathable=true, precision=1})
  return true
end

local function executeClosest(possibilities)
  local referencePos = State.leaderPositions[posz()] or player:getPosition()
  local closest, closestDistance = nil, 99999

  for _, data in ipairs(possibilities) do
    local dist = distanceManhattan(data.pos, referencePos)
    if dist < closestDistance then
      closest = data
      closestDistance = dist
    end
  end

  if closest then
    return closest.action(closest.pos)
  end
  return false
end

local function handleFloorChange()
  if not canRetry(State.lastFloorTry, 250) then return false end
  State.lastFloorTry = now

  local p = player:getPosition()
  local possibleChangers = {}

  local actionMap = {
    { ids = S.useIDS,      action = handleUse  },
    { ids = S.ropeIDS,     action = handleRope },
    { ids = S.stairIDS,    action = handleStep },
    { ids = S.buracoIDS,   action = handleStep },
    { ids = S.teleportIDS, action = handleStep }
  }

  for _, mapEntry in ipairs(actionMap) do
    if mapEntry.ids and #mapEntry.ids > 0 then
      for x = -2, 2 do
        for y = -2, 2 do
          local checkPos = {x = p.x + x, y = p.y + y, z = p.z}
          local tile = g_map.getTile(checkPos)
          if tile then
            local topThing = tile:getTopUseThing()
            local ground = nil
            if tile.getGround then
              ground = tile:getGround()
            end

            if (topThing and containsId(mapEntry.ids, topThing:getId())) or
               (ground and containsId(mapEntry.ids, ground:getId())) then
              table.insert(possibleChangers, {action = mapEntry.action, pos = checkPos})
            end
          end
        end
      end
    end
  end

  if #possibleChangers > 0 then
    dbg("Floor changer encontrado.")
    return executeClosest(possibleChangers)
  end

  return false
end

local function useRopeNear(pos)
  if not pos then return false end

  for x = -1, 1 do
    for y = -1, 1 do
      local tpos = {x = pos.x + x, y = pos.y + y, z = posz()}
      local tile = g_map.getTile(tpos)
      if tile and tile:getGround() and containsId(S.ropeIDS, tile:getGround():getId()) then
        if handleRope(tpos) then
          delay(getDistanceBetween(player:getPosition(), tpos) * 60)
          return true
        end
      end
    end
  end
  return false
end

local function handleUsing()
  local usePos = State.leaderUsePositions[posz()]
  if not usePos then return false end

  local useTile = g_map.getOrCreateTile(usePos)
  if useTile and useTile:getTopUseThing() then
    g_game.use(useTile:getTopUseThing())
    dbg("Usando posição do leader.")
    return true
  end
  return false
end

local function getStandTime()
  return now - State.standTime
end

local function levitate(dir)
  if not dir then return false end
  turn(dir)
  schedule(200, function()
    say('exani hur "down')
    say('exani hur "up')
  end)
  dbg("Tentando levitate.")
  return true
end

local function handleDoors()
  if not canRetry(State.lastDoorUse, 400) then return false end

  local doorIds = S.doorsIDS or {}
  local ppos = player:getPosition()
  local lpos = State.leader and State.leader:getPosition() or State.leaderPositions[posz()]
  local bestDoor = nil
  local bestLeaderDist = 99999
  local bestPlayerDist = 99999

  for x = ppos.x - 4, ppos.x + 4 do
    for y = ppos.y - 4, ppos.y + 4 do
      local pos = {x = x, y = y, z = ppos.z}
      local tile = g_map.getTile(pos)

      if tile and tile:getTopUseThing() and containsId(doorIds, tile:getTopUseThing():getId()) then
        local playerDist = getDistanceBetween(ppos, pos)
        if playerDist <= 4 then
          local leaderDist = lpos and getDistanceBetween(lpos, pos) or 99999

          if not bestDoor
            or leaderDist < bestLeaderDist
            or (leaderDist == bestLeaderDist and playerDist < bestPlayerDist) then
            bestDoor = {thing = tile:getTopUseThing(), pos = pos}
            bestLeaderDist = leaderDist
            bestPlayerDist = playerDist
          end
        end
      end
    end
  end

  if not bestDoor then return false end

  State.lastDoorUse = now
  g_game.use(bestDoor.thing)
  dbg("Abrindo porta em " .. bestDoor.pos.x .. "," .. bestDoor.pos.y .. "," .. bestDoor.pos.z)

  if lpos then
    local around = {
      {x = lpos.x + 1, y = lpos.y, z = lpos.z},
      {x = lpos.x - 1, y = lpos.y, z = lpos.z},
      {x = lpos.x, y = lpos.y + 1, z = lpos.z},
      {x = lpos.x, y = lpos.y - 1, z = lpos.z},
      {x = lpos.x + 1, y = lpos.y + 1, z = lpos.z},
      {x = lpos.x + 1, y = lpos.y - 1, z = lpos.z},
      {x = lpos.x - 1, y = lpos.y + 1, z = lpos.z},
      {x = lpos.x - 1, y = lpos.y - 1, z = lpos.z},
    }

    for i = 1, #around do
      local testPos = around[i]
      local path = findPath(player:getPosition(), testPos, 20, {ignoreNonPathable=true, precision=1, ignoreCreatures=false})
      if path then
        autoWalk(testPos, 200, {ignoreNonPathable=true, precision=1})
        break
      end
    end
  end

  delay(200)
  return true
end

local function handleLeaderInteraction()
  local l = State.leader
  if not l then return false end

  local lpos = l:getPosition()
  local useIds = S.useIDS or {}

  for x = -1, 1 do
    for y = -1, 1 do
      local tpos = {x = lpos.x + x, y = lpos.y + y, z = lpos.z}
      local tile = g_map.getTile(tpos)
      if tile and tile:getTopUseThing() and containsId(useIds, tile:getTopUseThing():getId()) then
        if handleUse(tpos) then
          delay(100)
          return true
        end
      end
    end
  end

  return false
end

local function tryRecoverLeaderPath()
  local leaderPos = State.leaderPositions[posz()]
  if leaderPos and getDistanceBetween(player:getPosition(), leaderPos) > 0 then
    autoWalk(leaderPos, 200, {ignoreNonPathable=true, precision=5})
    delay(300)
    dbg("Andando para última posição do leader.")
    return true
  end

  if handleLeaderInteraction() then return true end
  if handleFloorChange() then return true end

  local dir = State.leaderDirections[posz()]
  if dir then
    return levitate(dir)
  end

  if useRopeNear(leaderPos) then return true end
  if handleUsing() then return true end

  return false
end

local function ensureFollow(creature)
  if not creature then return false end
  if not canRetry(State.lastFollowTry, 250) then return false end
  State.lastFollowTry = now

  if g_game.isFollowing() then
    if g_game.getFollowingCreature() ~= creature then
      g_game.cancelFollow()
      g_game.follow(creature)
      dbg("Reiniciando follow no leader.")
      return true
    end
  else
    g_game.follow(creature)
    dbg("Iniciando follow no leader.")
    return true
  end
  return false
end

local function followVisibleLeader(creature)
  if not creature then return false end

  local lpos = creature:getPosition()
  local dist = getDistanceBetween(player:getPosition(), lpos)
  local parameters = {ignoreNonPathable=true, precision=1, ignoreCreatures=false}
  local path = nil
  if dist > 2 then
    path = findPath(player:getPosition(), lpos, 30, parameters)
  end

  ensureFollow(creature)

  if dist > 3 then
    if handleDoors() then return true end
  end

  if g_game.isFollowing() and dist > 1 and getStandTime() > 100 then
    autoWalk(lpos, 200, parameters)
    g_game.cancelFollow()
    g_game.follow(creature)
  end

  if dist > 2 and not path then
    if handleUsing() then return true end
    if handleDoors() then return true end
    if handleFloorChange() then return true end
  elseif dist > 7 then
    if getStandTime() > 100 then
      autoWalk(lpos, 200, parameters)
      dbg("Ajustando autowalk no leader.")
      return true
    end
  end

  return false
end

local function getBestAttackFollowPos(leaderPos)
  if not leaderPos or leaderPos.z ~= posz() then return nil end

  local myPos = player:getPosition()
  if not myPos then return leaderPos end

  local candidates = {
    leaderPos,
    {x = leaderPos.x + 1, y = leaderPos.y, z = leaderPos.z},
    {x = leaderPos.x - 1, y = leaderPos.y, z = leaderPos.z},
    {x = leaderPos.x, y = leaderPos.y + 1, z = leaderPos.z},
    {x = leaderPos.x, y = leaderPos.y - 1, z = leaderPos.z},
    {x = leaderPos.x + 1, y = leaderPos.y + 1, z = leaderPos.z},
    {x = leaderPos.x - 1, y = leaderPos.y - 1, z = leaderPos.z},
    {x = leaderPos.x + 1, y = leaderPos.y - 1, z = leaderPos.z},
    {x = leaderPos.x - 1, y = leaderPos.y + 1, z = leaderPos.z}
  }

  local best = nil
  local bestLen = 999

  for _, p in ipairs(candidates) do
    local tile = g_map.getTile(p)
    if tile and tile:isWalkable() then
      local path = findPath(myPos, p, 70, {
        ignoreNonPathable = true,
        ignoreCreatures = false,
        precision = 1
      })

      if path and #path < bestLen then
        best = p
        bestLen = #path
      end
    end
  end

  return best or leaderPos
end

local function attackDoWalkTo(targetPos, precision)
  local myPos = player:getPosition()
  if not myPos or not targetPos or myPos.z ~= targetPos.z then return false end

  precision = tonumber(precision) or 1

  if getDistanceBetween(myPos, targetPos) <= precision then
    AttackFollow.stuckCount = 0
    return true
  end

  if now - AttackFollow.lastWalk < ATTACK_WALK_INTERVAL then
    return true
  end

  AttackFollow.lastWalk = now

  local walkPos = getBestAttackFollowPos(targetPos) or targetPos

  autoWalk(walkPos, 70, {
    ignoreNonPathable = true,
    ignoreCreatures = false,
    precision = 1
  })

  return false
end

local function followVisibleLeaderWhileAttacking(creature)
  if not creature then return false end

  -- IMPORTANTE: atacando não usa follow nativo.
  -- Isso evita quebrar target e deixa o MC andar agressivo igual a script 2.
  if g_game.isFollowing() then
    g_game.cancelFollow()
  end

  local lpos = creature:getPosition()
  if not lpos or lpos.z ~= posz() then return false end

  local dist = getDistanceBetween(player:getPosition(), lpos)
  if dist > 3 then
    local path = findPath(player:getPosition(), lpos, 70, {
      ignoreNonPathable = true,
      ignoreCreatures = false,
      precision = 1
    })

    if not path then
      if handleDoors() then return true end
      if handleUsing() then return true end
      if handleFloorChange() then return true end
    end
  end

  attackDoWalkTo(lpos, 1)
  dbg("Attack follow agressivo no leader.")
  return true
end

local function runFollowLogicIdle()
  if not storage[SWITCH_FOLLOW] or storage[SWITCH_FOLLOW].enabled ~= true then return end
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true) then return end
  if g_game.isAttacking() then return end

  local leaderName = getLeaderName()
  if leaderName == "" then return end

  local c = getVisibleLeader()
  State.leader = c

  -- aqui pode usar follow normal
  if c then
    return followVisibleLeader(c)
  else
    return tryRecoverLeaderPath()
  end
end

local function runFollowLogicAttacking()
  if not storage[SWITCH_FOLLOW] or storage[SWITCH_FOLLOW].enabled ~= true then return end
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true) then return end
  if not g_game.isAttacking() then return end

  local leaderName = getLeaderName()
  if leaderName == "" then return end

  local c = getVisibleLeader()
  State.leader = c

  -- sem leader visível: tenta recuperar caminho / floor / door
  if not c then
    local leaderPos = State.leaderPositions[posz()]
    if leaderPos and getDistanceBetween(player:getPosition(), leaderPos) > 0 then
      attackDoWalkTo(leaderPos, 1)
      dbg("Andando para última posição do leader enquanto ataca.")
      return true
    end

    if handleDoors() then return true end
    if handleLeaderInteraction() then return true end
    if handleFloorChange() then return true end

    local dir = State.leaderDirections[posz()]
    if dir then
      return levitate(dir)
    end

    if useRopeNear(leaderPos) then return true end
    if handleUsing() then return true end

    return false
  end

  -- com leader visível, só reposiciona sem follow bruto
  return followVisibleLeaderWhileAttacking(c)
end


followButton = setupUI([[
Panel
  height: 35

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Follow
    color: white
    height: 18

  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Config
    opacity: 1.00
    color: white

  CheckBox
    id: lider
    anchors.left: title.left
    anchors.top: title.bottom
    margin-top: 2
    image-source: /images/ui/checkbox_round
    text: I'm Leader
    text-auto-resize: true
]])

followButton.title:setOn(followCfg.enabled)
followButton.lider:setChecked(followCfg.isLeader)

followButton.title.onClick = function(widget)
  followCfg.enabled = not widget:isOn()
  widget:setOn(followCfg.enabled)

  charStorage.follow2Panel.enabled = followCfg.enabled
  charStorage.followButton = charStorage.followButton or {}
  charStorage.followButton.enabled = followCfg.enabled
  storage[SWITCH_FOLLOW].enabled = followCfg.enabled

  if not followCfg.enabled then
    g_game.cancelFollow()
    if player and player.stopAutoWalk then
      pcall(function() player:stopAutoWalk() end)
    end
  end

  saveFollow2()
end

followButton.lider.onClick = function(widget)
  followCfg.isLeader = not widget:isChecked()
  widget:setChecked(followCfg.isLeader)

  if toolsScripts and not toolsScripts:isDestroyed() then
    if followCfg.isLeader then
      toolsScripts:show()
      toolsScripts:raise()
      toolsScripts:focus()
    else
      toolsScripts:hide()
    end
  end

  storage[SWITCH_FOLLOW].leader = followCfg.isLeader
  saveFollow2()
end

schedule(500, function()
  if toolsScripts and not toolsScripts:isDestroyed() then
    if followCfg.isLeader then
      toolsScripts:show()
    else
      toolsScripts:hide()
    end
  end
end)

followButton.settings.onClick = function()
  if follow2 then
    follow2:show()
    follow2:raise()
    follow2:focus()
  end
end

local function getContainerItems(widget)
  if not widget or not widget.getItems then return {} end
  local ok, items = pcall(function() return widget:getItems() end)
  if ok and type(items) == "table" then return items end
  return {}
end

--==================================================
-- MAIN FOLLOW PANEL
--==================================================

follow2 = setupUI([=[
MainWindow
  id: mainPanel
  size: 310 395
  text: Panel Follow
  margin-top: -50

  Button
    id: tabConfig
    checkable: true
    anchors.top: parent.top
    anchors.left: parent.left
    height: 33
    margin-left: -5
    width: 144
    text-align: center
    text: Follow

    UIItem
      id: idConfig
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -4
      margin-left: -9
      size: 33 33
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: prev.right
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 0
      margin-right: 8
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  Button
    id: tabAntired
    checkable: true
    anchors.verticalCenter: tabConfig.verticalCenter
    anchors.left: tabConfig.right
    height: 33
    margin-left: 0
    width: 145
    text-align: center
    text: IDs Follow

    UIItem
      id: idAntired
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -4
      margin-left: -9
      size: 33 33
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: prev.right
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 0
      margin-right: 8
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  FlatPanel
    id: flatConfig
    anchors.top: tabConfig.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-bottom: 20
    margin-left: -5
    margin-top: 6
    margin-right: -5

    Label
      id: liderLabel
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 6
      margin-left: 8
      margin-right: 8
      text: Leader Name:  

    BotTextEdit
      id: lidername
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      placeholder: "#N/D Config..."
      text-align: left

    Label
      id: followLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Follower Name:  

    BotTextEdit
      id: followname
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      placeholder: "#N/D Config..."
      text-align: left

    Label
      id: ueLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: UE Spell Name:  

    BotTextEdit
      id: uespell
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      placeholder: "#N/D Config..."
      text-align: left

    HorizontalSeparator
      id: sep1
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8

    BotSwitch
      id: abrirPt
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 6
      height: 18
      text: Open PT Channel

    Panel
      id: commandLine
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 1
      height: 35

      BotSwitch
        id: comandoAttack
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 18
        text: Command Attack
        tooltip: Use this to send the attack command in the chat defined to the side (for knights or monks only).

      ComboBox
        id: selectChat
        anchors.top: prev.bottom
        anchors.left: prev.left
        anchors.right: prev.right
        margin-top: 2
        height: 18
        @onSetup: |
          self:addOption("Default")
          self:addOption("Party Channel")

  FlatPanel
    id: flatAntired
    anchors.top: flatConfig.top
    anchors.left: flatConfig.left
    anchors.right: flatConfig.right
    anchors.bottom: flatConfig.bottom

    FlatPanel
      id: stringsPanel
      anchors.top: parent.top
      anchors.left: parent.left
      width: 137
      height: 136
      margin-top: 6
      margin-left: 8

      Label
        id: labelStrings
        anchors.top: parent.top
        anchors.left: parent.left
        width: 82
        margin-left: 4
        margin-top: -5
        text-align: center
        color: #d7c08a
        font: verdana-11px-rounded
        text: Strings:

      BotContainer
        id: stringsContainer
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        margin-top: 2
        margin-left: 5
        margin-right: 5
        margin-bottom: 5

    FlatPanel
      id: usePanel
      anchors.top: stringsPanel.top
      anchors.left: stringsPanel.right
      anchors.right: parent.right
      height: 136
      margin-left: 6
      margin-right: 8

      Label
        id: labelUse
        anchors.top: parent.top
        anchors.left: parent.left
        width: 82
        margin-left: 4
        margin-top: -5
        text-align: center
        font: verdana-11px-rounded
        color: #d7c08a
        text: Use Ids:

      BotContainer
        id: useContainer
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        margin-top: 2
        margin-left: 5
        margin-right: 5
        margin-bottom: 5

    FlatPanel
      id: doorsPanel
      anchors.top: stringsPanel.bottom
      anchors.left: stringsPanel.left
      width: 137
      anchors.bottom: parent.bottom
      margin-top: 6
      margin-bottom: 8

      Label
        id: labelDoors
        anchors.top: parent.top
        anchors.left: parent.left
        width: 82
        margin-left: 4
        margin-top: -5
        text-align: center
        font: verdana-11px-rounded
        color: #d7c08a
        text: Doors:

      BotContainer
        id: doorsContainer
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        margin-top: 2
        margin-left: 5
        margin-right: 5
        margin-bottom: 5

    FlatPanel
      id: teleportsPanel
      anchors.top: usePanel.bottom
      anchors.left: usePanel.left
      anchors.right: usePanel.right
      anchors.bottom: parent.bottom
      margin-top: 6
      margin-bottom: 8

      Label
        id: labelTeleports
        anchors.top: parent.top
        anchors.left: parent.left
        width: 90
        margin-left: 4
        margin-top: -5
        text-align: center
        color: #d7c08a
        font: verdana-11px-rounded
        text: Teleports:

      BotContainer
        id: teleportsContainer
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        margin-top: 2
        margin-left: 5
        margin-right: 5
        margin-bottom: 5

  Button
    id: closePanel
    anchors.left: flatConfig.left
    anchors.right: flatConfig.right
    anchors.top: flatConfig.bottom
    height: 20
    margin-top: 5
    text: Close
]=], g_ui.getRootWidget())
follow2:hide()

local function WFollowPanel(root, id)
  if not root or not id then return nil end

  if root.getChildById then
    local ok, child = pcall(function() return root:getChildById(id) end)
    if ok and child then return child end
  end

  if root.recursiveGetChildById then
    local ok, child = pcall(function() return root:recursiveGetChildById(id) end)
    if ok and child then return child end
  end

  if root.getChildren then
    local ok, childs = pcall(function() return root:getChildren() end)
    if ok and childs then
      for i = 1, #childs do
        local found = WFollowPanel(childs[i], id)
        if found then return found end
      end
    end
  end

  return nil
end

local function bindFollowPanelIds()
  local ids = {
    "tabConfig", "tabAntired", "flatConfig", "flatAntired", "closePanel",
    "lidername", "followname", "uespell", "abrirPt", "comandoAttack", "selectChat",
    "stringsContainer", "useContainer", "doorsContainer", "teleportsContainer"
  }

  for i = 1, #ids do
    local id = ids[i]
    if not follow2[id] then
      follow2[id] = WFollowPanel(follow2, id)
    end
  end
end

local function showFollowWidget(widget, visible)
  if not widget then return end
  if visible then
    if widget.show then widget:show() end
  else
    if widget.hide then widget:hide() end
  end
end

local function setFollowTabPressed(button, pressed)
  if not button then return end
  showFollowWidget(WFollowPanel(button, "activeLine"), pressed)

  if button.setChecked then pcall(function() button:setChecked(pressed) end) end
  if button.setPressed then pcall(function() button:setPressed(pressed) end) end
  if button.setOn then pcall(function() button:setOn(pressed) end) end

  if button.setOpacity then button:setOpacity(pressed and 1.00 or 0.74) end
  if button.setColor then button:setColor(pressed and "#d7c08a" or "#d6d6d6") end
end

local function setFollowPanelTab(tab)
  if tab ~= "config" and tab ~= "antired" then tab = "config" end

  showFollowWidget(follow2.flatConfig, tab == "config")
  showFollowWidget(follow2.flatAntired, tab == "antired")

  setFollowTabPressed(follow2.tabConfig, tab == "config")
  setFollowTabPressed(follow2.tabAntired, tab == "antired")
end

local function setFollowIcon(widget, id)
  if widget and widget.setItemId then
    pcall(function() widget:setItemId(tonumber(id) or 0) end)
  end
end

bindFollowPanelIds()

if follow2.tabConfig and not follow2.tabConfig.idConfig then
  follow2.tabConfig.idConfig = WFollowPanel(follow2.tabConfig, "idConfig")
end

if follow2.tabAntired and not follow2.tabAntired.idAntired then
  follow2.tabAntired.idAntired = WFollowPanel(follow2.tabAntired, "idAntired")
end

setFollowIcon(follow2.tabConfig and follow2.tabConfig.idConfig, 44051)
setFollowIcon(follow2.tabAntired and follow2.tabAntired.idAntired, 1977)

if follow2.tabConfig then
  follow2.tabConfig.onClick = function()
    setFollowPanelTab("config")
  end
end

if follow2.tabAntired then
  follow2.tabAntired.onClick = function()
    setFollowPanelTab("antired")
  end
end

setFollowPanelTab("config")

if g_app and g_app.isMobile and g_app.isMobile() then
  follow2:setSize("350 505")
end

--==================================================
-- BIND MAIN PANEL
--==================================================

follow2.lidername:setText(followCfg.leaderName)
follow2.followname:setText(followCfg.followerName)
follow2.uespell:setText(followCfg.ueSpell)
follow2.abrirPt:setOn(followCfg.openPt)
follow2.comandoAttack:setOn(followCfg.commandAttack)

if follow2.selectChat.setOption then
  follow2.selectChat:setOption(followCfg.selectChat)
end

follow2.lidername.onTextChange = function(_, text)
  followCfg.leaderName = tostring(text or "")
  saveFollow2()
end

follow2.followname.onTextChange = function(_, text)
  followCfg.followerName = tostring(text or "")
  saveFollow2()
end

follow2.uespell.onTextChange = function(_, text)
  followCfg.ueSpell = tostring(text or "")
  saveFollow2()
end

follow2.abrirPt.onClick = function(widget)
  followCfg.openPt = not widget:isOn()
  widget:setOn(followCfg.openPt)
  saveFollow2()
end

follow2.comandoAttack.onClick = function(widget)
  followCfg.commandAttack = not widget:isOn()
  widget:setOn(followCfg.commandAttack)
  saveFollow2()
end

follow2.selectChat.onOptionChange = function(_, option)
  followCfg.selectChat = tostring(option or "Default")
  saveFollow2()
end

follow2.closePanel.onClick = function()
  follow2:hide()
end

--==================================================
-- BIND IDS CONTAINERS
--==================================================

UI.ContainerEx(function(widget, items)
  followCfg.idsToFollow.strings = items or {}
  saveFollow2()
end, true, nil, follow2.stringsContainer)

follow2.stringsContainer:setItems(followCfg.idsToFollow.strings)

UI.ContainerEx(function(widget, items)
  followCfg.idsToFollow.use = items or {}
  saveFollow2()
end, true, nil, follow2.useContainer)

follow2.useContainer:setItems(followCfg.idsToFollow.use)

UI.ContainerEx(function(widget, items)
  followCfg.idsToFollow.doorsClosed = items or {}
  saveFollow2()
end, true, nil, follow2.doorsContainer)

follow2.doorsContainer:setItems(followCfg.idsToFollow.doorsClosed)

UI.ContainerEx(function(widget, items)
  followCfg.idsToFollow.teleports = items or {}
  saveFollow2()
end, true, nil, follow2.teleportsContainer)

follow2.teleportsContainer:setItems(followCfg.idsToFollow.teleports)

macro(200, function()
  syncCompat()
  runFollowLogicIdle()
end)

macro(50, function()
  syncCompat()
  runFollowLogicAttacking()
end)

onCreaturePositionChange(function(creature, newPos, oldPos)
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true) then return end

  if creature:getName() == player:getName() then
    State.standTime = now
    return
  end

  if creature:getName():lower() ~= getLeaderName():lower() then return end

  if newPos then
    State.leaderPositions[newPos.z] = newPos
    State.lastLeaderFloor = newPos.z
    State.lastLeaderSeenAt = now
    if newPos.z == posz() then
      State.leader = creature
      if storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true and g_game.isAttacking() then
        attackDoWalkTo(newPos, 1)
      end
    else
      State.leader = nil
    end
  else
    State.leader = nil
  end

  if oldPos and newPos and oldPos.z ~= newPos.z then
    State.leaderDirections[oldPos.z] = creature:getDirection()
  end
end)

onCreatureAppear(function(creature)
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true) then return end
  if creature:getName():lower() == getLeaderName():lower() and creature:getPosition().z == posz() then
    State.leader = creature
    State.lastLeaderSeenAt = now
  end
end)

onCreatureDisappear(function(creature)
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true) then return end
  if creature:getName():lower() == getLeaderName():lower() then
    State.leader = nil
  end
end)

onMissle(function(missle)
  local src = missle:getSource()
  if src.z ~= posz() then return end

  local from = g_map.getTile(src)
  local to = g_map.getTile(missle:getDestination())
  if not from or not to then return end

  local fromCreatures = from:getCreatures()
  local toCreatures = to:getCreatures()
  if #fromCreatures ~= 1 or #toCreatures ~= 1 then return end

  local c1 = fromCreatures[1]
  local t1 = toCreatures[1]

  local navAttack = getAttackLeaderName():lower()
  if navAttack == "" then return end
  if t1:getName():lower() == navAttack then return end

  if c1:getName():lower() == navAttack then
    if storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true then
      local currentTarget = g_game.getAttackingCreature()
      if not currentTarget or currentTarget ~= t1 then
        g_game.attack(t1)
      end
    end
  end
end)

macro(1000, function()
  syncCompat()
  if S.switches.abrirChatParty ~= true then return end
  if not isPartyReady() then return end

  if not modules.game_console.getTab("Party") then
    g_game.requestChannels()
    g_game.joinChannel(1)
    State.fecharChannel = now + 2000
  end

  if State.fecharChannel > 0 and now >= State.fecharChannel then
    local w = nil

    if modules and modules.game_console then
      w = modules.game_console.channelsWindow
    end

    if not w then
      local root = g_ui.getRootWidget()
      if root and root.recursiveGetChildById then
        w = root:recursiveGetChildById("channelsWindow")
      end
    end

    if w then
      w:destroy()
      if modules and modules.game_console then
        modules.game_console.channelsWindow = nil
      end
    end

    State.fecharChannel = 0
  end
end)

local function encodeTargetId(id)
  local s = tostring(id)
  if #s >= 8 then
    local p1 = s:sub(1,1)
    local p2 = s:sub(2,3)
    local p3 = s:sub(4,4)
    local p4 = s:sub(5,6)
    local p5 = s:sub(7,8)
    local p6 = s:sub(9,10)
    return "." .. p1 .. "@" .. p2 .. "#" .. p3 .. "!" .. p4 .. "+" .. p5 .. "[" .. p6 .. "]"
  end
  return "." .. s
end

local function decodeTargetId(text)
  local digits = (text or ""):gsub("%D", "")
  if digits == "" then return nil end
  return tonumber(digits)
end

local function isKnight()
  local voc = player:getVocation()
  return voc == 1 or voc == 6
end

macro(500, function()
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].leader == true) then return end

  if followCfg.commandAttack ~= true then return end

  if not isKnight() then return end
  if not isPartyReady() then return end

  local t = g_game.getAttackingCreature()
  if not t then return end
  if t:getPosition().z ~= posz() then return end

  if State.leaderWait >= now and State.lastTarget == t then return end
  State.lastTarget = t

  local msg = "ATACAR: " .. encodeTargetId(t:getId())

  -- só usa party channel se estiver selecionado Party Channel
  if tostring(followCfg.selectChat or "Default") == "Party Channel" then
    sayChannel(1, msg)
  else
    say(msg)
  end

  State.leaderWait = now + 8000
end)

onTalk(function(name, level, mode, text, channelId, pos)
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true) then return end
  if channelId ~= 1 then return end

  local leaderName = getAttackLeaderName():lower()
  if leaderName == "" then return end
  if name:lower() ~= leaderName then return end

  local id = decodeTargetId(text)
  if not id then return end

  local target = getCreatureById(id)
  if not target then return end
  if target:getPosition().z ~= posz() then return end
  if g_game.getAttackingCreature() == target then return end

  g_game.attack(target)
end)
end

do
  if not loadCharStorage or not saveCharStorage then
  return print("[Eq Manager] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function saveEqManagerChar()
  saveCharStorage(charStorage)
end

UI.Separator()

local switchEqManager = "eqManagerButton"
charStorage[switchEqManager] = charStorage[switchEqManager] or { enabled = false }

eqManagerButton = setupUI([[
Panel
  height: 19
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: EQ Manager
    height: 18
    color: white
  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Config
    opacity: 1.00
    color: white
]])
eqManagerButton:setId(switchEqManager)
eqManagerButton.title:setOn(charStorage[switchEqManager].enabled)
eqManagerButton.title.onClick = function(widget)
  local state = not widget:isOn()
  widget:setOn(state)
  charStorage[switchEqManager].enabled = state
  saveEqManagerChar()
end

equipInterface = setupUI([=[
EQPanel < Panel
  size: 160 230
  padding-left: 10
  padding-right: 10
  padding-bottom: 10

  BotItem
    id: head
    image-source: /images/game/slots/head
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    margin-top: 10
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: body
    image-source: /images/game/slots/body
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: legs
    image-source: /images/game/slots/legs
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: feet
    image-source: /images/game/slots/feet
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: neck
    image-source: /images/game/slots/neck
    anchors.top: head.top
    margin-top: 13
    anchors.right: head.left
    margin-right: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: left-hand
    image-source: /images/game/slots/left-hand
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: finger
    image-source: /images/game/slots/finger
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: right-hand
    image-source: /images/game/slots/right-hand
    anchors.left: body.right
    margin-left: 5
    anchors.top: left-hand.top
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: ammo
    image-source: /images/game/slots/ammo
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

MainWindow
  id: mainPanel
  size: 453 420
  text: Panel EQ Manager
  margin-top: -50

  Panel
    id: infolist1
    anchors.top: parent.top
    anchors.left: parent.left
    size: 190 225
    image-source: /images/ui/miniwindow
    image-border: 23
    margin-left: -4
    margin-right: -4

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Settings EQ
      margin-top: 2

  EQPanel
    id: eqConfig
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 50
    margin-bottom: 30
    anchors.bottom: prev.bottom

  TextEdit
    id: nameConfig
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: -25
    margin-left: 6
    margin-right: 6
    placeholder: Profile Name

  Button
    id: cloneEq
    anchors.top: prev.bottom
    anchors.right: prev.right
    size: 35 18
    text: Clone
    margin-top: 2
    tooltip: Clone Current Equipments

  Panel
    id: panelRules
    anchors.top: infolist1.top
    anchors.left: infolist1.right
    margin-right: -8
    size: 230 225
    image-source: /images/ui/miniwindow
    image-border: 23
    margin-left: 10

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Rules to Equip
      margin-top: 2

    CheckBox
      id: hppercent
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 10
      margin-left: 10
      text: HP% below:
      $checked:
        color: #3CB371
        image-color: #3CB371
        
    SpinBox
      id: qtdHppercent
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-left: 15
      margin-right: 6
      size: 80 18
      minimum: 1
      maximum: 100
      text-align: center

    CheckBox
      id: mppercent
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 5
      margin-left: 10
      text: MP% below:
      $checked:
        color: #3CB371
        image-color: #3CB371

    SpinBox
      id: qtdMppercent
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-left: 15
      margin-right: 6
      size: 80 18
      minimum: 1
      maximum: 100
      text-align: center

    CheckBox
      id: safe
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 5
      margin-left: 10
      text: Safe (Anti-red)
      $checked:
        color: #3CB371
        image-color: #3CB371

    CheckBox
      id: targetisPlayer
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 8
      margin-left: 10
      text: Target is Player
      $checked:
        color: #3CB371
        image-color: #3CB371

    CheckBox
      id: creatures
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 8
      margin-left: 10
      text: Amount Creatures:
      $checked:
        color: #3CB371
        image-color: #3CB371

    SpinBox
      id: qtdCreatures
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-left: 15
      margin-right: 6
      size: 80 18
      minimum: 1
      maximum: 10
      text-align: center

    CheckBox
      id: noTarget
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 5
      margin-left: 10
      text: No Combat
      $checked:
        color: #3CB371
        image-color: #3CB371

    CheckBox
      id: nameCreature
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 9
      margin-left: 10
      text: Target Name
      $checked:
        color: #3CB371
        image-color: #3CB371

    Button
      id: listNameCreature
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-left: 15
      margin-right: 6
      size: 80 18
      text: List

    CheckBox
      id: distance
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 6
      margin-left: 10
      text: Distance:
      $checked:
        color: #3CB371
        image-color: #3CB371

    SpinBox
      id: distsqm
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-left: 15
      margin-right: 6
      size: 80 18
      minimum: 1
      maximum: 100
      text-align: center

    CheckBox
      id: setPrincipal
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-left: 10
      text: Default Set
      margin-bottom: 10
      $checked:
        color: #3CB371
        image-color: #3CB371

  Panel
    id: flatp
    anchors.top: eqConfig.bottom
    anchors.left: eqConfig.left
    anchors.right: panelRules.right
    anchors.bottom: parent.bottom
    image-source: /images/ui/miniwindow
    image-border: 23
    margin-top: 35
    margin-left: 1
    margin-right: 60

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: List Equipment Manager
      margin-top: 2

  TextList
    id: listSettingsEQ
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.bottom: prev.bottom
    margin: 5
    margin-top: 20
    margin-right: 17
    height: 120
    opacity: 0.95
    vertical-scrollbar: panelEQListScroll

  VerticalScrollBar
    id: panelEQListScroll
    anchors.top: listSettingsEQ.top
    anchors.bottom: listSettingsEQ.bottom
    anchors.left: listSettingsEQ.right
    width: 13
    step: 18
    pixels-scroll: true

  Button
    id: adicionar
    anchors.top: flatp.top
    anchors.left: flatp.right
    anchors.right: parent.right
    margin-right: -4
    margin-left: 5
    height: 73
    text: Add Settings
    text-wrap: true

  Button
    id: closePanel
    anchors.top: prev.bottom
    anchors.left: flatp.right
    anchors.right: parent.right
    margin-right: -4
    margin-left: 5
    height: 73
    margin-top: 4
    text: Close


]=], g_ui.getRootWidget())
equipInterface:hide()

if modules._G.g_app.isMobile() then
  equipInterface:setSize("453 440")
end

equipInterface.closePanel.onClick = function()
  equipInterface:hide()
end
eqManagerButton.settings.onClick = function()
  equipInterface:show()
end

local function W(parent, id)
  if not parent then return nil end
  return (parent.getChildById and parent:getChildById(id)) or
         (parent.recursiveGetChildById and parent:recursiveGetChildById(id))
end

local function trim(s)
  return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function clearChildren(w)
  if not w then return end
  local ch = w:getChildren()
  for i = #ch, 1, -1 do
    ch[i]:destroy()
  end
end

local SLOTS = { "head","neck","body","left-hand","right-hand","legs","feet","finger","ammo" }

charStorage.eqManagerProfiles = charStorage.eqManagerProfiles or {}
local eqProfiles = charStorage.eqManagerProfiles
local editingEqIndex = nil

local targetListPanelName = "eqManagerTargetNames"
charStorage[targetListPanelName] = charStorage[targetListPanelName] or { names = {} }

local eqRowTemplate = [[
UIWidget
  height: 24
  focusable: true
  draggable: true
  background-color: alpha
  border: 1 alpha
  opacity: 1.00
  margin-top: 0
  $hover:
    background-color: #2a2a2a
    border: 1 #3a3a3a
  $focus:
    background-color: #2a2a2a
    border: 1 #3a3a3a

  BotSwitch
    id: enabled
    anchors.left: parent.left
    margin-top: 0
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    width: 20
    height: 20
    text: ""
    image-source: /images/ui/button_rounded

  Label
    id: profileName
    anchors.left: enabled.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    text-auto-resize: true
    color: orange
    text: ""
    font: verdana-11px-rounded

  Panel
    id: itemsPanel
    anchors.left: profileName.right
    anchors.right: remove.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    margin-left: 4
    margin-top: -5
    margin-right: 4

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 20
    height: 20
    margin-right: 4
    text: X
    font: verdana-11px-rounded
    color: white
    $hover:
      image-color: red
      color: #ffd0d0
]]

local targetNameRowTemplate = [[
UIWidget
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
    id: creatureName
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    font: verdana-11px-rounded
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
    image-source: /images/ui/button_rounded
    image-color: #363636
]]

targetNameListWindow = setupUI([[
MainWindow
  id: mainPanel
  size: 250 315
  text: Target Name List
  anchors.centerIn: parent
  margin-top: -50

  Panel
    id: panelList
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 225
    margin: -6
    margin-bottom: 3
    margin-top: 1
    image-source: /images/ui/miniwindow
    image-border: 20

  TextList
    id: nameList
    anchors.top: panelList.top
    anchors.left: panelList.left
    anchors.right: panelList.right
    anchors.bottom: panelList.bottom
    margin-top: 21
    margin-left: 5
    margin-right: 17
    margin-bottom: 5
    vertical-scrollbar: nameListScroll

  VerticalScrollBar
    id: nameListScroll
    anchors.top: nameList.top
    anchors.bottom: nameList.bottom
    anchors.left: nameList.right
    width: 13
    step: 18
    pixels-scroll: true

  TextEdit
    id: inputName
    anchors.left: panelList.left
    anchors.right: addName.left
    anchors.bottom: closePanel.top
    margin-right: 3
    margin-bottom: 4
    height: 20
    placeholder: Creature name

  Button
    id: addName
    anchors.right: panelList.right
    anchors.bottom: closePanel.top
    margin-bottom: 4
    size: 35 20
    text: +

  Button
    id: closePanel
    anchors.left: panelList.left
    anchors.right: panelList.right
    anchors.bottom: parent.bottom
    height: 22
    text: Close
]], g_ui.getRootWidget())
targetNameListWindow:hide()

local function copyList(t)
  local out = {}
  for i, v in ipairs(t or {}) do out[i] = v end
  return out
end

local function getItemId(widget)
  if not widget then return 0 end
  if widget.getItemId then
    local ok, id = pcall(function() return widget:getItemId() end)
    if ok and id and id > 0 then return id end
  end
  if widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and item.getId then
      local ok2, id = pcall(function() return item:getId() end)
      if ok2 and id and id > 0 then return id end
    end
  end
  return 0
end

local function setBotItem(widget, itemId)
  itemId = tonumber(itemId) or 0
  if not widget then return end

  if widget.setItemId then
    widget:setItemId(itemId)
  elseif widget.setItem and Item and Item.create then
    if itemId > 0 then
      widget:setItem(Item.create(itemId, 1))
    else
      pcall(function() widget:setItem(nil) end)
    end
  end

  if widget.setOn then
    widget:setOn(itemId > 0)
  end
end

local function bindBotItemVisual(widget)
  if not widget then return end

  local old = widget.onItemChange
  widget.onItemChange = function(self, ...)
    if self and self.setOn then
      self:setOn(getItemId(self) > 0)
    end
    if old then old(self, ...) end
  end

  if widget.setOn then
    widget:setOn(getItemId(widget) > 0)
  end
end

local function bindEqPanelVisuals()
  local eqConfig = W(equipInterface, "eqConfig")
  if not eqConfig then return end
  for _, slot in ipairs(SLOTS) do
    local w = W(eqConfig, slot)
    if w then bindBotItemVisual(w) end
  end
end

local function normalizeTargetName(name)
  return trim(name):lower()
end

local function targetNameExists(name)
  local n = normalizeTargetName(name)
  for _, v in ipairs(charStorage[targetListPanelName].names or {}) do
    if normalizeTargetName(v) == n then
      return true
    end
  end
  return false
end

local function removeTargetName(name)
  local n = normalizeTargetName(name)
  local newList = {}
  for _, v in ipairs(charStorage[targetListPanelName].names or {}) do
    if normalizeTargetName(v) ~= n then
      table.insert(newList, v)
    end
  end
  charStorage[targetListPanelName].names = newList
  saveEqManagerChar()
end

local function refreshTargetNameList()
  local list = W(targetNameListWindow, "nameList")
  if not list then return end
  clearChildren(list)

  for _, name in ipairs(charStorage[targetListPanelName].names or {}) do
    local row = setupUI(targetNameRowTemplate, list)
    row.creatureName:setText(name)
    row.remove.onClick = function()
      removeTargetName(name)
      refreshTargetNameList()
    end
  end
end

local function addTargetNameFromInput()
  local input = W(targetNameListWindow, "inputName")
  if not input then return end

  local name = trim(input:getText())
  if name == "" then return end
  if targetNameExists(name) then
    input:setText("")
    return
  end

  table.insert(charStorage[targetListPanelName].names, name)
  saveEqManagerChar()
  input:setText("")
  refreshTargetNameList()
end

local function collectItems()
  local eqConfig = W(equipInterface, "eqConfig")
  local items = {}
  local hasAny = false

  if not eqConfig then return items, false end

  for _, slot in ipairs(SLOTS) do
    local id = getItemId(W(eqConfig, slot))
    if id > 0 then
      items[slot] = id
      hasAny = true
    end
  end

  return items, hasAny
end

local function applyItems(items)
  local eqConfig = W(equipInterface, "eqConfig")
  if not eqConfig then return end

  items = items or {}
  for _, slot in ipairs(SLOTS) do
    setBotItem(W(eqConfig, slot), tonumber(items[slot]) or 0)
  end
end

local function collectRules()
  local function checked(id)
    local w = W(equipInterface, id)
    return w and w:isChecked() or false
  end

  local function spin(id, def)
    local w = W(equipInterface, id)
    return w and w:getValue() or def
  end

  return {
    hppercent = checked("hppercent"),
    qtdHppercent = spin("qtdHppercent", 1),
    mppercent = checked("mppercent"),
    qtdMppercent = spin("qtdMppercent", 1),
    safe = checked("safe"),
    targetisPlayer = checked("targetisPlayer"),
    creatures = checked("creatures"),
    qtdCreatures = spin("qtdCreatures", 1),
    noTarget = checked("noTarget"),
    nameCreature = checked("nameCreature"),
    distance = checked("distance"),
    distsqm = spin("distsqm", 1),
    setPrincipal = checked("setPrincipal"),
    targetNames = copyList(charStorage[targetListPanelName].names or {})
  }
end

local function applyRules(rules)
  rules = rules or {}

  local function setCheck(id, val)
    local w = W(equipInterface, id)
    if w then w:setChecked(val == true) end
  end

  local function setSpin(id, val)
    local w = W(equipInterface, id)
    if w then w:setValue(tonumber(val) or 1) end
  end

  setCheck("hppercent", rules.hppercent)
  setSpin("qtdHppercent", rules.qtdHppercent)
  setCheck("mppercent", rules.mppercent)
  setCheck("safe", rules.safe)
  setSpin("qtdMppercent", rules.qtdMppercent)
  setCheck("targetisPlayer", rules.targetisPlayer)
  setCheck("creatures", rules.creatures)
  setSpin("qtdCreatures", rules.qtdCreatures)
  setCheck("noTarget", rules.noTarget)
  setCheck("nameCreature", rules.nameCreature)
  setCheck("distance", rules.distance)
  setSpin("distsqm", rules.distsqm)
  setCheck("setPrincipal", rules.setPrincipal)

  charStorage[targetListPanelName].names = copyList(rules.targetNames or {})
  refreshTargetNameList()
  saveEqManagerChar()
end

local function resetForm()
  local nameConfig = W(equipInterface, "nameConfig")
  if nameConfig then nameConfig:setText("") end

  applyItems({})
  applyRules({
    hppercent=false, qtdHppercent=1,
    mppercent=false, qtdMppercent=1,
    targetisPlayer=false,
    creatures=false, qtdCreatures=1,
    noTarget=false,
    nameCreature=false,
    distance=false, distsqm=1,
    setPrincipal=false,
    targetNames={}
  })

  editingEqIndex = nil
  local addButton = W(equipInterface, "adicionar")
  if addButton then
    addButton:setText("Add\nSettings")
  end
end

local function findProfileByName(name, ignoreIndex)
  name = trim(name):lower()
  if name == "" then return nil end

  for i, profile in ipairs(eqProfiles) do
    if i ~= ignoreIndex and trim(profile.name):lower() == name then
      return i
    end
  end
  return nil
end

local function getRowName(profile)
  return (trim(profile.name) ~= "" and profile.name or "Profile") .. ":"
end

local function orderedItemIds(items)
  local out = {}
  items = items or {}
  for _, slot in ipairs(SLOTS) do
    local id = tonumber(items[slot]) or 0
    if id > 0 then table.insert(out, id) end
  end
  return out
end

local function setupEqDragAndDrop(row)
  row.onDragEnter = function(self, mousePos)
    self:setOpacity(0.4)
    return true
  end

  row.onDragLeave = function(self, droppedWidget, mousePos)
    self:setOpacity(1.0)
  end

  row.onDrop = function(self, droppedWidget, mousePos)
    self:setOpacity(1.0)
    if droppedWidget and droppedWidget.setOpacity then
      droppedWidget:setOpacity(1.0)
    end

    local parent = self:getParent()
    if not parent then return true end

    local children = parent:getChildren()
    local fromIndex, toIndex = 0, 0

    for i, child in ipairs(children) do
      if child == droppedWidget then fromIndex = i end
      if child == self then toIndex = i end
    end

    if fromIndex > 0 and toIndex > 0 and fromIndex ~= toIndex then
      local moved = table.remove(eqProfiles, fromIndex)
      table.insert(eqProfiles, toIndex, moved)

      if editingEqIndex then
        if editingEqIndex == fromIndex then
          editingEqIndex = toIndex
        elseif fromIndex < editingEqIndex and toIndex >= editingEqIndex then
          editingEqIndex = editingEqIndex - 1
        elseif fromIndex > editingEqIndex and toIndex <= editingEqIndex then
          editingEqIndex = editingEqIndex + 1
        end
      end

      saveEqManagerChar()
      rebuildEqManagerList()
    end

    return true
  end
end

local function getEquippedSlotItemId(slotConst)
  local item = getSlot(slotConst)
  return item and item:getId() or 0
end

local function cloneCurrentEquip()
  local eqConfig = W(equipInterface, "eqConfig")
  if not eqConfig then return end

  setBotItem(W(eqConfig, "head"), getEquippedSlotItemId(SlotHead))
  setBotItem(W(eqConfig, "body"), getEquippedSlotItemId(SlotBody))
  setBotItem(W(eqConfig, "legs"), getEquippedSlotItemId(SlotLeg))
  setBotItem(W(eqConfig, "feet"), getEquippedSlotItemId(SlotFeet))
  setBotItem(W(eqConfig, "neck"), getEquippedSlotItemId(SlotNeck))
  setBotItem(W(eqConfig, "left-hand"), getEquippedSlotItemId(SlotLeft))
  setBotItem(W(eqConfig, "right-hand"), getEquippedSlotItemId(SlotRight))
  setBotItem(W(eqConfig, "finger"), getEquippedSlotItemId(SlotFinger))
  setBotItem(W(eqConfig, "ammo"), getEquippedSlotItemId(SlotAmmo))
end

function rebuildEqManagerList()
  local list = W(equipInterface, "listSettingsEQ")
  if not list then return end

  clearChildren(list)

  for index, profile in ipairs(eqProfiles) do
    local row = setupUI(eqRowTemplate, list)
    setupEqDragAndDrop(row)

    row.enabled:setOn(profile.enabled ~= false)
    row.enabled.onClick = function(widget)
      local state = not widget:isOn()
      widget:setOn(state)
      if eqProfiles[index] then
        eqProfiles[index].enabled = state
        saveEqManagerChar()
      end
    end

    row.profileName:setText(getRowName(profile))
    row.profileName:setColor(profile.rules and profile.rules.setPrincipal and "#00FF66" or "orange")

    local items = orderedItemIds(profile.items)
    for i, itemId in ipairs(items) do
      local item = setupUI(string.format([[
UIItem
  id: item%d
  size: 20 20
  focusable: false
  phantom: true
  anchors.left: parent.left
  anchors.top: parent.top
  margin-left: %d
  margin-top: 9
]], i, (i - 1) * 22), row.itemsPanel)
      setBotItem(item, itemId)
    end

    row.remove.onClick = function()
      table.remove(eqProfiles, index)
      if editingEqIndex == index then
        resetForm()
      elseif editingEqIndex and editingEqIndex > index then
        editingEqIndex = editingEqIndex - 1
      end
      saveEqManagerChar()
      rebuildEqManagerList()
    end

    row.onDoubleClick = function()
      local nameConfig = W(equipInterface, "nameConfig")
      if nameConfig then nameConfig:setText(profile.name or "") end
      applyItems(profile.items)
      applyRules(profile.rules)
      editingEqIndex = index
    
    local addButton = W(equipInterface, "adicionar")
      if addButton then
        addButton:setText("Add\nSettings")
      end
    end
  end
end

local function saveProfile()
  local nameConfig = W(equipInterface, "nameConfig")
  local profileName = trim(nameConfig and nameConfig:getText() or "")

  if profileName == "" then
    profileName = "Profile " .. tostring(editingEqIndex or (#eqProfiles + 1))
  end

  if findProfileByName(profileName, editingEqIndex) then
    return warn("Já existe um profile com esse nome.")
  end

  local items, hasAny = collectItems()
  if not hasAny then
    return warn("Selecione pelo menos 1 item no Settings EQ.")
  end

  local rules = collectRules()

  if #eqProfiles == 0 and editingEqIndex == nil and not rules.setPrincipal then
    return warn("Configure primeiro um Default Set.")
  end

  if rules.setPrincipal then
    for i = 1, #eqProfiles do
      eqProfiles[i].rules = eqProfiles[i].rules or {}
      eqProfiles[i].rules.setPrincipal = false
    end
  end

  local oldEnabled = true
  if editingEqIndex and eqProfiles[editingEqIndex] then
    oldEnabled = eqProfiles[editingEqIndex].enabled ~= false
  end

  local data = {
    enabled = oldEnabled,
    name = profileName,
    items = items,
    rules = rules
  }

  if editingEqIndex and eqProfiles[editingEqIndex] then
    eqProfiles[editingEqIndex].enabled = data.enabled
    eqProfiles[editingEqIndex].name = data.name
    eqProfiles[editingEqIndex].items = data.items
    eqProfiles[editingEqIndex].rules = data.rules
  else
    table.insert(eqProfiles, data)
  end

  charStorage.eqManagerProfiles = eqProfiles
  saveEqManagerChar()

  rebuildEqManagerList()
  resetForm()
end

local addButton = W(equipInterface, "adicionar")
if addButton then
  addButton.onClick = saveProfile
end

local cloneButton = W(equipInterface, "cloneEq")
if cloneButton then
  cloneButton.onClick = function()
    cloneCurrentEquip()
  end
end

local listNameCreatureButton = W(equipInterface, "listNameCreature")
if listNameCreatureButton then
  listNameCreatureButton.onClick = function()
    refreshTargetNameList()
    targetNameListWindow:show()
    targetNameListWindow:raise()
    targetNameListWindow:focus()
  end
end

targetNameListWindow.addName.onClick = function()
  addTargetNameFromInput()
end

targetNameListWindow.closePanel.onClick = function()
  targetNameListWindow:hide()
end

targetNameListWindow.inputName.onKeyPress = function(widget, keyCode)
  if keyCode == KeyEnter or keyCode == KeyReturn then
    addTargetNameFromInput()
    return true
  end
  return false
end

bindEqPanelVisuals()
refreshTargetNameList()
rebuildEqManagerList()

-----------------------------
local EQM_SLOT_CONST = {
  ["head"] = SlotHead,
  ["neck"] = SlotNeck,
  ["body"] = SlotBody,
  ["left-hand"] = SlotLeft,
  ["right-hand"] = SlotRight,
  ["legs"] = SlotLeg,
  ["feet"] = SlotFeet,
  ["finger"] = SlotFinger,
  ["ammo"] = SlotAmmo
}

local EQM_EQUIP_ORDER = {
  "neck", "head", "body", "legs", "feet", "right-hand", "left-hand", "finger", "ammo"
}

local EQM_IS_OLD_CLIENT = g_game.getClientVersion() < 960
local EQM_ACTION_DELAY = EQM_IS_OLD_CLIENT and 250 or 0
local eqmNextAction = 0

local function eqm_now()
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end
  if now then return now end
  return 0
end

local function eqm_getSlotItem(slotConst)
  return getSlot(slotConst)
end

local function eqm_getSlotId(slotConst)
  local it = eqm_getSlotItem(slotConst)
  return it and it:getId() or 0
end

local function eqm_getContainersSafe()
  if type(getContainers) == "function" then
    return getContainers() or {}
  end
  if g_game and type(g_game.getContainers) == "function" then
    return g_game.getContainers() or {}
  end
  return {}
end

local function eqm_findVisibleItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  if type(findItem) == "function" then
    local it = findItem(id)
    if it then return it end
  end

  for _, cont in pairs(eqm_getContainersSafe()) do
    for _, it in ipairs(cont:getItems() or {}) do
      if it and it.getId and tonumber(it:getId()) == id then
        return it
      end
    end
  end

  return nil
end

local function eqm_unequipSlot(slotConst)
  local item = eqm_getSlotItem(slotConst)
  if not item then return false end

  if EQM_IS_OLD_CLIENT then
    if moveToSlot then
      local ok = pcall(function()
        moveToSlot(item, SlotBack, item:getCount())
      end)
      if ok then return true end
    end
  end

  local ok = pcall(function()
    g_game.equipItemId(item:getId())
  end)
  return ok
end

local function eqm_equipToSlot(id, slotConst)
  id = tonumber(id) or 0
  if id <= 0 then return false end

  if not EQM_IS_OLD_CLIENT then
    local ok = pcall(function()
      g_game.equipItemId(id, slotConst)
    end)
    if ok then return true end

    ok = pcall(function()
      g_game.equipItemId(id)
    end)
    return ok
  end

  local it = eqm_findVisibleItemById(id)
  if not it then return false end

  local ok = pcall(function()
    g_game.move(it, {x = 65535, y = slotConst, z = 0}, 1)
  end)
  return ok
end

local function eqm_isPlayer(creature)
  return creature and creature.isPlayer and creature:isPlayer() or false
end

local function eqm_isMonster(creature)
  return creature and creature.isMonster and creature:isMonster() or false
end

local function eqm_localPlayer()
  return g_game.getLocalPlayer and g_game.getLocalPlayer() or nil
end

local function eqm_getTarget()
  return g_game.getAttackingCreature and g_game.getAttackingCreature() or nil
end

local function eqm_hasTarget()
  return eqm_getTarget() ~= nil
end

local function eqm_nameInList(name, list)
  local n = trim(name):lower()
  if n == "" then return false end

  for _, v in ipairs(list or {}) do
    if trim(v):lower() == n then
      return true
    end
  end

  return false
end

local function eqm_countCreatures()
  local me = pos()
  if not me then return 0 end

  local count = 0
  for _, spec in ipairs(getSpectators() or {}) do
    if eqm_isMonster(spec) then
      local sPos = spec:getPosition()
      if sPos and sPos.z == me.z then
        count = count + 1
      end
    end
  end
  return count
end

local function eqm_isCreatureAttackingMe(creature, me)
  if not creature or not me or creature == me then return false end

  if creature.getTarget then
    local ok, t = pcall(function() return creature:getTarget() end)
    if ok and t then
      if type(t) == "number" and me.getId and t == me:getId() then
        return true
      end
      if t == me then
        return true
      end
    end
  end

  return false
end

local function eqm_ruleMatches(profile)
  if not profile or profile.enabled == false then return false end
  local rules = profile.rules or {}

  if rules.hppercent and hppercent() > (tonumber(rules.qtdHppercent) or 1) then
    return false
  end

  if rules.mppercent and manapercent() > (tonumber(rules.qtdMppercent) or 1) then
    return false
  end

  if rules.targetisPlayer then
    local target = eqm_getTarget()
    if not eqm_isPlayer(target) then
      return false
    end
  end

  if rules.creatures and eqm_countCreatures() < (tonumber(rules.qtdCreatures) or 1) then
    return false
  end

  if rules.noTarget and eqm_hasTarget() then
    return false
  end

  if rules.nameCreature then
    local target = eqm_getTarget()
    local targetName = target and target:getName() or ""
    if targetName == "" then
      return false
    end
    if not eqm_nameInList(targetName, rules.targetNames or {}) then
      return false
    end
  end

  if rules.safe then
    if type(LNS_HAS_UNSAFE_CONDITION) == "function" then
      if LNS_HAS_UNSAFE_CONDITION() then
        return false
      end
    end
  end

  if rules.distance then
    local target = eqm_getTarget()
    if not target then
      return false
    end

    local tPos = target:getPosition()
    local pPos = pos()

    if not tPos or not pPos or tPos.z ~= pPos.z then
      return false
    end

    local dist = math.max(math.abs(tPos.x - pPos.x), math.abs(tPos.y - pPos.y))
    local maxDist = tonumber(rules.distsqm) or 1

    if dist > maxDist then
      return false
    end
  end

  return true
end

local function eqm_getDefaultProfile()
  for _, profile in ipairs(eqProfiles or {}) do
    if profile.enabled ~= false and profile.rules and profile.rules.setPrincipal then
      return profile
    end
  end
  return nil
end

local function eqm_buildResolvedItems(activeProfile)
  local resolved = {}
  local defaultProfile = eqm_getDefaultProfile()

  if defaultProfile and type(defaultProfile.items) == "table" then
    for _, slot in ipairs(EQM_EQUIP_ORDER) do
      local v = tonumber(defaultProfile.items[slot]) or 0
      if v > 0 then
        resolved[slot] = v
      end
    end
  end

  if activeProfile and type(activeProfile.items) == "table" then
    for _, slot in ipairs(EQM_EQUIP_ORDER) do
      local v = tonumber(activeProfile.items[slot]) or 0
      if v > 0 then
        resolved[slot] = v
      end
    end
  end

  return resolved
end

local function eqm_getMatchedProfileAndItems()
  for _, profile in ipairs(eqProfiles or {}) do
    if profile.enabled ~= false and not (profile.rules and profile.rules.setPrincipal) then
      if eqm_ruleMatches(profile) then
        return profile, eqm_buildResolvedItems(profile)
      end
    end
  end

  local defaultProfile = eqm_getDefaultProfile()
  if defaultProfile then
    return defaultProfile, eqm_buildResolvedItems(defaultProfile)
  end

  return nil, nil
end

local function eqm_prepareHands(resolvedItems)
  local wantLeft = tonumber(resolvedItems["left-hand"]) or 0
  local wantRight = tonumber(resolvedItems["right-hand"]) or 0

  -- slot nao configurado = NAO MEXE
  if wantLeft <= 0 and wantRight <= 0 then
    return false
  end

  local curLeft = eqm_getSlotId(SlotLeft)
  local curRight = eqm_getSlotId(SlotRight)

  -- se só configurou left-hand, não limpa right-hand
  if wantLeft > 0 and curLeft ~= wantLeft then
    -- só tira right se ele estiver bloqueando o left
    if curRight > 0 and curRight ~= wantRight and wantRight > 0 then
      if eqm_unequipSlot(SlotRight) then return true end
    end
  end

  -- se só configurou right-hand, não limpa left-hand
  if wantRight > 0 and curRight ~= wantRight then
    -- só tira left se ele estiver bloqueando o right
    if curLeft > 0 and curLeft ~= wantLeft and wantLeft > 0 then
      if eqm_unequipSlot(SlotLeft) then return true end
    end
  end

  return false
end

local function eqm_applyResolvedOldClient(resolvedItems)
  if not resolvedItems then return false end

  if eqm_prepareHands(resolvedItems) then
    return true
  end

  for _, part in ipairs(EQM_EQUIP_ORDER) do
    local wantedId = tonumber(resolvedItems[part]) or 0

    -- slot nao configurado = nao mexe
    if wantedId > 0 then
      local slotConst = EQM_SLOT_CONST[part]
      local currentId = eqm_getSlotId(slotConst)

      if currentId ~= wantedId then
        if eqm_equipToSlot(wantedId, slotConst) then
          return true
        end
      end
    end
  end

  return false
end

local function eqm_applyResolvedNewClient(resolvedItems)
  if not resolvedItems then return false end

  local changed = false

  for _, part in ipairs(EQM_EQUIP_ORDER) do
    local wantedId = tonumber(resolvedItems[part]) or 0

    -- slot nao configurado = nao mexe
    if wantedId > 0 then
      local slotConst = EQM_SLOT_CONST[part]
      local currentId = eqm_getSlotId(slotConst)

      if currentId ~= wantedId then
        pcall(function()
          g_game.equipItemId(wantedId)
        end)

        changed = true
      end
    end
  end

  return changed
end

macro(200, function()
  if not charStorage[switchEqManager] or charStorage[switchEqManager].enabled ~= true then return end
  if #eqProfiles == 0 then return end

  local t = eqm_now()
  if eqmNextAction > t then return end

  local profile, resolvedItems = eqm_getMatchedProfileAndItems()
  if not profile or not resolvedItems then return end

  local changed = false

  if EQM_IS_OLD_CLIENT then
    changed = eqm_applyResolvedOldClient(resolvedItems)
  else
    changed = eqm_applyResolvedNewClient(resolvedItems)
  end

  if changed then
    eqmNextAction = t + EQM_ACTION_DELAY
  end
end)
end

do 
  if not loadCharStorage or not saveCharStorage then
  return print("[Swap] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function saveSmartSwapChar()
  saveCharStorage(charStorage)
end

setDefaultTab("Main")

local switchSwap = "swapButton"
charStorage[switchSwap] = charStorage[switchSwap] or { enabled = false }

swapButton = setupUI([[
Panel
  height: 19
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Smart Swap
    height: 18
    color: white
  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Config
    opacity: 1.00
    color: white
]])
swapButton:setId(switchSwap)
swapButton.title:setOn(charStorage[switchSwap].enabled)

swapButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  charStorage[switchSwap].enabled = newState
  saveSmartSwapChar()
end

panelSwap = setupUI([[  
RingConfig < Panel
  height: 244
  margin-top: 0
  phantom: false

  Label
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: "Normal Ring ID:"
    text-auto-resize: true

  BotItem
    id: ringNormal
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: title2
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left:3
    text: Custom Ring ID:
    text-auto-resize: true

  BotItem
    id: ringCustom
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: title3
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: Custom Equipped ID:
    text-auto-resize: true

  BotItem
    id: ringCustom2
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: labelHpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: Hp% to Equip:
    text-auto-resize: true
    
  HorizontalScrollBar
    id: hpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 5
    minimum: 1
    maximum: 100

  Label
    id: labelHpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8
    margin-left: 3
    text: Hp% to Unequip:
    text-auto-resize: true
    
  HorizontalScrollBar
    id: hpUnequip
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 5
    minimum: 1
    maximum: 100

  BotSwitch
    id: ativador
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-bottom: 5
    margin-left: 3
    margin-right: 5
    text: Smart Swap

AmuletConfig < Panel
  height: 244
  margin-top: 0
  phantom: false

  Label
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: "Normal Amulet ID:"
    text-auto-resize: true

  BotItem
    id: amuletNormal
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: title2
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left:3
    text: Custom Amulet ID:
    text-auto-resize: true

  BotItem
    id: amuletCustom
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: title3
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: Custom Equipped ID:
    text-auto-resize: true

  BotItem
    id: amuletCustom2
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: labelHpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: Hp% to Equip:
    text-auto-resize: true
    
  HorizontalScrollBar
    id: hpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 5
    minimum: 1
    maximum: 100

  Label
    id: labelHpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8
    margin-left: 3
    text: Hp% to Unequip:
    text-auto-resize: true
    
  HorizontalScrollBar
    id: hpUnequip
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 5
    minimum: 1
    maximum: 100
    
  BotSwitch
    id: ativador
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-bottom: 5
    margin-left: 3
    margin-right: 5
    text: Smart Swap

EQPanel < Panel
  size: 155 190
  padding-left: 10
  padding-right: 10
  image-source: /images/ui/panel_flat
  image-border: 1
  padding-bottom: 10

  BotItem
    id: head
    image-source: /images/game/slots/head
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    margin-top: 10
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: body
    image-source: /images/game/slots/body
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: legs
    image-source: /images/game/slots/legs
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: feet
    image-source: /images/game/slots/feet
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: neck
    image-source: /images/game/slots/neck
    anchors.top: head.top
    margin-top: 13
    anchors.right: head.left
    margin-right: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: left-hand
    image-source: /images/game/slots/left-hand
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: finger
    image-source: /images/game/slots/finger
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: right-hand
    image-source: /images/game/slots/right-hand
    anchors.left: body.right
    margin-left: 5
    anchors.top: left-hand.top
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: ammo
    image-source: /images/game/slots/ammo
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotTextEdit
    id: iconName
    anchors.top: feet.bottom
    anchors.left: parent.left
    size: 120 18
    margin-top: 10
    placeholder: Icon Name
    text-align: left
    
  Button
    id: iconShow
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-top: 0
    margin-left: 2
    height: 18
    text: I
    tooltip: Show/Hide Icone Swap
    $on:
      color: green

MainWindow
  id: panelSwap
  size: 560 355
  border: 1 #000000
  anchors.centerIn: parent
  margin-top: -40
  text: Panel Smart-Swap
  background-color: #101010

  FlatPanel
    id: panelBut
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 30
    background-color: #141414
    border-right: 1 #2a2a2a

  Button
    id: Ring
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.left
    margin-left: 5
    size: 100 20
    text: Ring
    color: #e6e6e6

  Button
    id: Amulet
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    margin-left: 5
    size: 100 20
    text: Amulet
    color: #e6e6e6

  Button
    id: swapSet
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    margin-left: 5
    size: 100 20
    text: Swap Sets
    color: #e6e6e6

  Button
    id: bpConfig
    anchors.verticalCenter: prev.verticalCenter
    anchors.right: panelBut.right
    margin-right: 5
    size: 100 20
    text: Bp Control
    tooltip: Control for open containers (necessary to tibia version < 9.60) [DESATIVED]
    color: #e6e6e6

  FlatPanel
    id: scriptsPanel
    anchors.top: panelBut.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-bottom: 20
    margin-top: 5

    FlatPanel
      id: ring1
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      margin: 5
      width: 167
      layout: verticalBox
      RingConfig
        id: ring1

    FlatPanel
      id: ring2
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: prev.right
      margin: 5
      margin-left: 10
      width: 167
      layout: verticalBox
      RingConfig
        id: ring2

    FlatPanel
      id: ring3
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: prev.right
      margin: 5
      margin-left: 10
      width: 167
      layout: verticalBox
      RingConfig
        id: ring3

    FlatPanel
      id: amulet1
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      margin: 5
      width: 167
      layout: verticalBox
      AmuletConfig
        id: amulet1

    FlatPanel
      id: amulet2
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: prev.right
      margin: 5
      margin-left: 10
      width: 167
      layout: verticalBox
      AmuletConfig
        id: amulet2

    FlatPanel
      id: amulet3
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: prev.right
      margin: 5
      margin-left: 10
      width: 167
      layout: verticalBox
      AmuletConfig
        id: amulet3
      
    ScrollablePanel
      id: content
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      vertical-scrollbar: contentScroll
      margin: 5
      image-source: /images/ui/panel_flat
      image-border: 1
      margin-right: 18

      EQPanel
        id: set1
        anchors.top: parent.top
        anchors.left: parent.left
        margin-top: 10
        margin-left: 10

      EQPanel
        id: set2
        anchors.top: prev.top
        anchors.left: prev.right
        margin-left: 10

      EQPanel
        id: set3
        anchors.top: prev.top
        anchors.left: prev.right
        margin-left: 10

      EQPanel
        id: set4
        anchors.top: set1.bottom
        anchors.left: parent.left
        margin-top: 10
        margin-left: 10

      EQPanel
        id: set5
        anchors.top: prev.top
        anchors.left: prev.right
        margin-left: 10

      EQPanel
        id: set6
        anchors.top: prev.top
        anchors.left: prev.right
        margin-left: 10


    VerticalScrollBar
      id: contentScroll
      anchors.top: prev.top
      anchors.left: prev.right
      anchors.bottom: prev.bottom
      step: 28
      pixels-scroll: true
      margin-left: 0

  Button
    id: closePanel
    anchors.left: scriptsPanel.left
    anchors.right: scriptsPanel.right
    anchors.top: scriptsPanel.bottom
    margin-left: -1
    margin-top: 5
    text: Close
    
]], g_ui.getRootWidget())
panelSwap.closePanel.onClick = function()
  panelSwap:hide()
end

if modules._G.g_app.isMobile() then
  equipInterface:setSize("560 355")
end

local SMART_SWAP_STORAGE = "lnsSmartSwapPanel"

charStorage[SMART_SWAP_STORAGE] = charStorage[SMART_SWAP_STORAGE] or {}
local ssCfg = charStorage[SMART_SWAP_STORAGE]

ssCfg.selectedTab = ssCfg.selectedTab or "ring"
ssCfg.rings = ssCfg.rings or {}
ssCfg.amulets = ssCfg.amulets or {}
ssCfg.sets = ssCfg.sets or {}

for i = 1, 3 do
  ssCfg.rings[i] = ssCfg.rings[i] or {
    normalId = 0,
    customId = 0,
    equippedId = 0,
    hpEquip = 90,
    hpUnequip = 95,
    enabled = false
  }

  ssCfg.amulets[i] = ssCfg.amulets[i] or {
    normalId = 0,
    customId = 0,
    equippedId = 0,
    hpEquip = 90,
    hpUnequip = 95,
    enabled = false
  }
end

for i = 1, 6 do
  ssCfg.sets[i] = ssCfg.sets[i] or {
    iconName = "",
    iconShow = false,
    slots = {
      head = 0,
      body = 0,
      legs = 0,
      feet = 0,
      neck = 0,
      ["left-hand"] = 0,
      finger = 0,
      ["right-hand"] = 0,
      ammo = 0
    }
  }
end

local function getBotItemId(widget)
  if not widget then return 0 end
  if widget.getItemId then
    return tonumber(widget:getItemId()) or 0
  elseif widget.getItem then
    local it = widget:getItem()
    if type(it) == "number" then return it end
    if type(it) == "table" and it.getId then return it:getId() end
  end
  return 0
end

local function updateBlessedState(widget)
  if not widget or not widget.setOn then return end
  widget:setOn(getBotItemId(widget) > 0)
end

local function setBotItemId(widget, itemId)
  itemId = tonumber(itemId) or 0
  if widget.setItemId then
    widget:setItemId(itemId)
  elseif widget.setItem then
    widget:setItem(itemId)
  end
  updateBlessedState(widget)
end

local function setScrollValue(scroll, value)
  value = tonumber(value) or 0
  if scroll.setValue then scroll:setValue(value) end
  if scroll.setText then scroll:setText(value .. "%") end
end

local function updateScrollText(scroll)
  if scroll and scroll.getValue and scroll.setText then
    scroll:setText(scroll:getValue() .. "%")
  end
end

local function styleTabButton(btn, active)
  if not btn then return end
  btn:setOpacity(active and 1 or 0.78)
  btn:setOn(active)
  btn:setTextOffset(active and {x = 0, y = -1} or {x = 0, y = 0})
  btn:setColor(active and "#ffffff" or "#bcbcbc")
  if btn.setBackgroundColor then
    btn:setBackgroundColor(active and "#1f1f1f" or "#141414")
  end
end

local function animateTabButton(btn)
  if not btn then return end
  local seq = {0.70, 0.82, 0.94, 1.00}
  for i, v in ipairs(seq) do
    schedule(100, function()
      if btn and not btn:isDestroyed() then
        btn:setOpacity(v)
      end
    end, i * 35)
  end
end

local function hideAllSwapSections()
  panelSwap.scriptsPanel.ring1:hide()
  panelSwap.scriptsPanel.ring2:hide()
  panelSwap.scriptsPanel.ring3:hide()
  panelSwap.scriptsPanel.amulet1:hide()
  panelSwap.scriptsPanel.amulet2:hide()
  panelSwap.scriptsPanel.amulet3:hide()
  panelSwap.scriptsPanel.content:hide()
  panelSwap.scriptsPanel.contentScroll:hide()
end

local function showSwapTab(tabName)
  hideAllSwapSections()

  styleTabButton(panelSwap.Ring, tabName == "ring")
  styleTabButton(panelSwap.Amulet, tabName == "amulet")
  styleTabButton(panelSwap.swapSet, tabName == "set")

  if tabName == "ring" then
    panelSwap.scriptsPanel.ring1:show()
    panelSwap.scriptsPanel.ring2:show()
    panelSwap.scriptsPanel.ring3:show()
    animateTabButton(panelSwap.Ring)

  elseif tabName == "amulet" then
    panelSwap.scriptsPanel.amulet1:show()
    panelSwap.scriptsPanel.amulet2:show()
    panelSwap.scriptsPanel.amulet3:show()
    animateTabButton(panelSwap.Amulet)

  elseif tabName == "set" then
    panelSwap.scriptsPanel.content:show()
    panelSwap.scriptsPanel.contentScroll:show()
    animateTabButton(panelSwap.swapSet)
  end

  ssCfg.selectedTab = tabName
  saveSmartSwapChar()
end

local function bindRingPanel(widget, index)
  local cfg = ssCfg.rings[index]

  setBotItemId(widget.ringNormal, cfg.normalId)
  setBotItemId(widget.ringCustom, cfg.customId)
  setBotItemId(widget.ringCustom2, cfg.equippedId)
  setScrollValue(widget.hpEquip, cfg.hpEquip)
  setScrollValue(widget.hpUnequip, cfg.hpUnequip)
  widget.ativador:setOn(cfg.enabled)

  updateScrollText(widget.hpEquip)
  updateScrollText(widget.hpUnequip)

  widget.ringNormal.onItemChange = function()
    cfg.normalId = getBotItemId(widget.ringNormal)
    saveSmartSwapChar()
  end

  widget.ringCustom.onItemChange = function()
    cfg.customId = getBotItemId(widget.ringCustom)
    saveSmartSwapChar()
  end

  widget.ringCustom2.onItemChange = function()
    cfg.equippedId = getBotItemId(widget.ringCustom2)
    saveSmartSwapChar()
  end

  widget.hpEquip.onValueChange = function(scroll, value)
    cfg.hpEquip = value
    updateScrollText(scroll)
    saveSmartSwapChar()
  end

  widget.hpUnequip.onValueChange = function(scroll, value)
    cfg.hpUnequip = value
    updateScrollText(scroll)
    saveSmartSwapChar()
  end

  widget.ativador.onClick = function(bt)
    local state = not bt:isOn()
    bt:setOn(state)
    cfg.enabled = state
    saveSmartSwapChar()
  end
end

local function bindAmuletPanel(widget, index)
  local cfg = ssCfg.amulets[index]

  setBotItemId(widget.amuletNormal, cfg.normalId)
  setBotItemId(widget.amuletCustom, cfg.customId)
  setBotItemId(widget.amuletCustom2, cfg.equippedId)
  setScrollValue(widget.hpEquip, cfg.hpEquip)
  setScrollValue(widget.hpUnequip, cfg.hpUnequip)
  widget.ativador:setOn(cfg.enabled)

  updateScrollText(widget.hpEquip)
  updateScrollText(widget.hpUnequip)

  widget.amuletNormal.onItemChange = function()
    cfg.normalId = getBotItemId(widget.amuletNormal)
    saveSmartSwapChar()
  end

  widget.amuletCustom.onItemChange = function()
    cfg.customId = getBotItemId(widget.amuletCustom)
    saveSmartSwapChar()
  end

  widget.amuletCustom2.onItemChange = function()
    cfg.equippedId = getBotItemId(widget.amuletCustom2)
    saveSmartSwapChar()
  end

  widget.hpEquip.onValueChange = function(scroll, value)
    cfg.hpEquip = value
    updateScrollText(scroll)
    saveSmartSwapChar()
  end

  widget.hpUnequip.onValueChange = function(scroll, value)
    cfg.hpUnequip = value
    updateScrollText(scroll)
    saveSmartSwapChar()
  end

  widget.ativador.onClick = function(bt)
    local state = not bt:isOn()
    bt:setOn(state)
    cfg.enabled = state
    saveSmartSwapChar()
  end
end

local function bindSetPanel(widget, index)
  local cfg = ssCfg.sets[index]

  local slotIds = {
    "head", "body", "legs", "feet", "neck",
    "left-hand", "finger", "right-hand", "ammo"
  }

  for _, slot in ipairs(slotIds) do
    if widget[slot] then
      setBotItemId(widget[slot], cfg.slots[slot] or 0)
      updateBlessedState(widget[slot])

      local oldOnItemChange = widget[slot].onItemChange
      widget[slot].onItemChange = function(self)
        cfg.slots[slot] = getBotItemId(self)
        updateBlessedState(self)
        saveSmartSwapChar()
        if oldOnItemChange then oldOnItemChange(self) end
      end
    end
  end

  if widget.iconName then
    widget.iconName:setText(cfg.iconName or "")
    widget.iconName.onTextChange = function(edit, text)
      cfg.iconName = text
      saveSmartSwapChar()
    end
  end

  if widget.iconShow then
    widget.iconShow:setOn(cfg.iconShow or false)
    widget.iconShow.onClick = function(bt)
      local state = not bt:isOn()
      bt:setOn(state)
      cfg.iconShow = state
      saveSmartSwapChar()
    end
  end
end

bindRingPanel(panelSwap.scriptsPanel.ring1.ring1, 1)
bindRingPanel(panelSwap.scriptsPanel.ring2.ring2, 2)
bindRingPanel(panelSwap.scriptsPanel.ring3.ring3, 3)

bindAmuletPanel(panelSwap.scriptsPanel.amulet1.amulet1, 1)
bindAmuletPanel(panelSwap.scriptsPanel.amulet2.amulet2, 2)
bindAmuletPanel(panelSwap.scriptsPanel.amulet3.amulet3, 3)

bindSetPanel(panelSwap.scriptsPanel.content.set1, 1)
bindSetPanel(panelSwap.scriptsPanel.content.set2, 2)
bindSetPanel(panelSwap.scriptsPanel.content.set3, 3)
bindSetPanel(panelSwap.scriptsPanel.content.set4, 4)
bindSetPanel(panelSwap.scriptsPanel.content.set5, 5)
bindSetPanel(panelSwap.scriptsPanel.content.set6, 6)

panelSwap.Ring.onClick = function()
  showSwapTab("ring")
end

panelSwap.Amulet.onClick = function()
  showSwapTab("amulet")
end

panelSwap.swapSet.onClick = function()
  showSwapTab("set")
end

showSwapTab(ssCfg.selectedTab or "ring")
panelSwap:hide()

swapButton.settings.onClick = function()
  if panelSwap:isVisible() then
    panelSwap:hide()
  else
    panelSwap:show()
    panelSwap:raise()
    panelSwap:focus()
    showSwapTab(ssCfg.selectedTab or "ring")
  end
end

local SMART_SWAP_COOLDOWN_MS = 350

local CD_MIGHT_RING = 3048
local CD_SSA_AMULET = 3081

local SMART_SLOT_FINGER = SlotFinger or 9
local SMART_SLOT_NECK   = SlotNeck or 2

local ringCdUntil = 0
local amuletCdUntil = { [1] = 0, [2] = 0, [3] = 0 }

local function smartNow()
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end
  if now then return now end
  return 0
end

local function smartItemId(it)
  if not it then return 0 end
  if it.getId then return tonumber(it:getId()) or 0 end
  return 0
end

local function smartGetFinger()
  if type(getFinger) == "function" then return getFinger() end
  return getSlot(SMART_SLOT_FINGER)
end

local function smartGetNeck()
  if type(getNeck) == "function" then return getNeck() end
  return getSlot(SMART_SLOT_NECK)
end

local function smartIsIdIn(id, a, b)
  id = tonumber(id) or 0
  a = tonumber(a) or 0
  b = tonumber(b) or 0
  if id <= 0 then return false end
  return (a > 0 and id == a) or (b > 0 and id == b)
end

local function smartUseCooldown(kind, item2, item3)
  item2 = tonumber(item2) or 0
  item3 = tonumber(item3) or 0

  if kind == "ring" then
    return item2 == CD_MIGHT_RING or item3 == CD_MIGHT_RING
  end

  if kind == "amulet" then
    return item2 == CD_SSA_AMULET or item3 == CD_SSA_AMULET
  end

  return false
end

local function smartGetContainers()
  if type(getContainers) == "function" then
    return getContainers() or {}
  end
  if g_game and type(g_game.getContainers) == "function" then
    return g_game.getContainers() or {}
  end
  return {}
end

local function smartFindItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  if type(findItem) == "function" then
    local it = findItem(id)
    if it then return it end
  end

  for _, c in ipairs(smartGetContainers()) do
    for _, it in ipairs(c:getItems() or {}) do
      if it and it.getId and tonumber(it:getId()) == id then
        return it
      end
    end
  end

  return nil
end

local function smartGetContainerCount(container)
  if not container then return 0 end
  if container.getItemsCount then return tonumber(container:getItemsCount()) or 0 end
  return #(container:getItems() or {})
end

local function smartGetContainerCapacity(container)
  if not container then return 0 end
  if container.getCapacity then return tonumber(container:getCapacity()) or 0 end
  return 0
end

local function smartGetFreeContainer()
  for _, container in ipairs(smartGetContainers()) do
    local name = (container.getName and container:getName() or ""):lower()
    local cap = smartGetContainerCapacity(container)
    local count = smartGetContainerCount(container)

    if (cap <= 0 or count < cap)
      and not name:find("dead")
      and not name:find("slain")
      and not name:find("depot")
      and not name:find("quiver") then
      return container
    end
  end

  return nil
end

local function smartUnequip(slot)
  local item = getSlot(slot)
  if not item then return false end

  if g_game.getClientVersion() >= 959 then
    g_game.equipItemId(item:getId())
    return true
  end

  local dest = smartGetFreeContainer()
  if not dest then return false end

  local pos = dest:getSlotPosition(smartGetContainerCount(dest))
  g_game.move(item, pos, item:getCount())
  return true
end

local function smartEquipToSlot(id, slot)
  id = tonumber(id) or 0
  if id <= 0 then return false end

  if g_game.getClientVersion() >= 959 then
    g_game.equipItemId(id)
    return true
  end

  local it = smartFindItemById(id)
  if not it then return false end

  g_game.move(it, {x = 65535, y = slot, z = 0}, 1)
  return true
end

local function smartEquipSpecial(id1, id2, slot)
  id1 = tonumber(id1) or 0
  id2 = tonumber(id2) or 0

  if g_game.getClientVersion() >= 959 then
    local pick = id1 > 0 and id1 or id2
    if pick <= 0 then return false end
    g_game.equipItemId(pick)
    return true
  end

  local it = smartFindItemById(id1) or smartFindItemById(id2)
  if not it then return false end

  g_game.move(it, {x = 65535, y = slot, z = 0}, 1)
  return true
end

local function getEnabledRingRows()
  local rows = {}
  if not ssCfg or not ssCfg.rings then return rows end

  for i = 1, 3 do
    local row = ssCfg.rings[i]
    if row and row.enabled == true then
      rows[#rows + 1] = {
        index = i,
        normalId = tonumber(row.normalId) or 0,
        customId = tonumber(row.customId) or 0,
        equippedId = tonumber(row.equippedId) or 0,
        hpEquip = tonumber(row.hpEquip) or 0,
        hpUnequip = tonumber(row.hpUnequip) or tonumber(row.hpEquip) or 0
      }
    end
  end

  table.sort(rows, function(a, b)
    if a.hpEquip == b.hpEquip then
      return a.index < b.index
    end
    return a.hpEquip < b.hpEquip
  end)

  return rows
end

local function getCurrentEquippedRingRow(equippedId, rows)
  equippedId = tonumber(equippedId) or 0
  if equippedId <= 0 then return nil end

  for _, row in ipairs(rows) do
    if smartIsIdIn(equippedId, row.customId, row.equippedId) then
      return row
    end
  end

  return nil
end

local function getBestRingRowToEquip(hp, rows)
  local best = nil

  for _, row in ipairs(rows) do
    if hp < row.hpEquip and (row.customId > 0 or row.equippedId > 0) then
      best = row
      break
    end
  end

  return best
end

local function getRingNormalId(rows)
  for _, row in ipairs(rows) do
    if row.normalId > 0 then
      return row.normalId
    end
  end
  return 0
end

local function processRingSwapSystem()
  local hp = hppercent()
  local t = smartNow()
  local finger = smartGetFinger()
  local equippedId = smartItemId(finger)
  local rows = getEnabledRingRows()

  if #rows == 0 then return false end

  local currentRow = getCurrentEquippedRingRow(equippedId, rows)
  local bestRow = getBestRingRowToEquip(hp, rows)
  local normalId = getRingNormalId(rows)
  local cdActive = ringCdUntil > t

  if currentRow then
    local currentIsCooldownRing = smartUseCooldown("ring", currentRow.customId, currentRow.equippedId)

    if bestRow and bestRow.index ~= currentRow.index and bestRow.hpEquip <= currentRow.hpEquip then
      if not (cdActive and currentIsCooldownRing) then
        if smartEquipSpecial(bestRow.customId, bestRow.equippedId, SMART_SLOT_FINGER) then
          if smartUseCooldown("ring", bestRow.customId, bestRow.equippedId) then
            ringCdUntil = t + SMART_SWAP_COOLDOWN_MS
          end
          delay(120)
          return true
        end
      end
      return false
    end

    if hp <= currentRow.hpUnequip then
      return false
    end
  end

  if bestRow then
    if not currentRow or currentRow.index ~= bestRow.index then
      if smartEquipSpecial(bestRow.customId, bestRow.equippedId, SMART_SLOT_FINGER) then
        if smartUseCooldown("ring", bestRow.customId, bestRow.equippedId) then
          ringCdUntil = t + SMART_SWAP_COOLDOWN_MS
        end
        delay(120)
        return true
      end
    end
    return false
  end

  if cdActive then
    return false
  end

  if normalId > 0 then
    if equippedId ~= normalId then
      if smartEquipToSlot(normalId, SMART_SLOT_FINGER) then
        delay(120)
        return true
      end
    end
    return false
  end

  if equippedId ~= 0 then
    if smartUnequip(SMART_SLOT_FINGER) then
      delay(120)
      return true
    end
  end

  return false
end

local function processAmuletSwap(index, row)
  if not row or row.enabled ~= true then return false end

  local hp = hppercent()
  local t = smartNow()

  local neck = smartGetNeck()
  local equippedId = smartItemId(neck)

  local normalId   = tonumber(row.normalId) or 0
  local specialId  = tonumber(row.customId) or 0
  local specialEq  = tonumber(row.equippedId) or 0
  local equipPct   = tonumber(row.hpEquip) or 0
  local unequipPct = tonumber(row.hpUnequip) or equipPct

  local hasNormal = normalId > 0
  local useCd = smartUseCooldown("amulet", specialId, specialEq)
  local cdActive = useCd and ((amuletCdUntil[index] or 0) > t) or false

  if hp < equipPct then
    if smartIsIdIn(equippedId, specialId, specialEq) then return false end

    if smartEquipSpecial(specialId, specialEq, SMART_SLOT_NECK) then
      if useCd then
        amuletCdUntil[index] = t + SMART_SWAP_COOLDOWN_MS
      end
      delay(120)
      return true
    end
    return false
  end

  if useCd and cdActive then
    if hp > unequipPct and equippedId ~= 0 then
      if smartUnequip(SMART_SLOT_NECK) then
        delay(120)
        return true
      end
    end
    return false
  end

  if hp > unequipPct then
    if hasNormal then
      if equippedId ~= normalId then
        if smartEquipToSlot(normalId, SMART_SLOT_NECK) then
          delay(120)
          return true
        end
      end
      return false
    end

    if equippedId ~= 0 then
      if smartUnequip(SMART_SLOT_NECK) then
        delay(120)
        return true
      end
    end
  end

  return false
end

local function fullTankIsOn()
  return charStorage
    and charStorage.lnsFullTank
    and charStorage.lnsFullTank.enabled == true
end

macro(50, function()
  if fullTankIsOn() then return end
  if not charStorage[switchSwap] or charStorage[switchSwap].enabled ~= true then return end
  if not ssCfg or not ssCfg.rings then return end
  processRingSwapSystem()
end)

macro(50, function()
  if fullTankIsOn() then return end
  if not charStorage[switchSwap] or charStorage[switchSwap].enabled ~= true then return end
  if not ssCfg or not ssCfg.amulets then return end

  for i = 1, 3 do
    if processAmuletSwap(i, ssCfg.amulets[i]) then
      return
    end
  end
end)

-- =========================
-- SWAP SET ICONS / EQUIP FAST
-- =========================

local SWAPSET_SLOT_CONST = {
  head = SlotHead,
  neck = SlotNeck,
  body = SlotBody,
  ["left-hand"] = SlotLeft,
  ["right-hand"] = SlotRight,
  legs = SlotLeg,
  feet = SlotFeet,
  finger = SlotFinger,
  ammo = SlotAmmo
}

local SWAPSET_ORDER = {
  "neck", "head", "body", "legs", "feet", "right-hand", "left-hand", "finger", "ammo"
}

local SWAPSET_IS_OLD_CLIENT = g_game.getClientVersion() < 960
local SWAPSET_ACTION_DELAY = SWAPSET_IS_OLD_CLIENT and 250 or 25

local swapSetIcons = {}
local swapSetRuntime = {}

local function sswapNow()
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end
  if now then return now end
  return 0
end

local function sswapTrim(s)
  return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function sswapGetSet(index)
  if not ssCfg or not ssCfg.sets then return nil end
  local cfg = ssCfg.sets[index]
  if type(cfg) ~= "table" then return nil end
  return cfg
end

local function sswapGetState(index)
  if not swapSetRuntime[index] then
    swapSetRuntime[index] = { active = false, nextAction = 0 }
  end
  return swapSetRuntime[index]
end

local function sswapGetSetName(index)
  local cfg = sswapGetSet(index) or {}
  local txt = sswapTrim(cfg.iconName or "")
  if txt == "" then txt = "SET" .. index end
  return txt
end

local function sswapGetIconItemId(index)
  local cfg = sswapGetSet(index) or {}
  local slots = cfg.slots or {}
  return tonumber(slots["left-hand"]) or 0
end

local function sswapSetIconItem(icon, itemId)
  itemId = tonumber(itemId) or 0
  if not icon then return end

  if icon.item and icon.item.setItemId then
    icon.item:setItemId(itemId)
    return
  end

  if icon.getChildById then
    local child = icon:getChildById("item")
    if child and child.setItemId then
      child:setItemId(itemId)
    end
  end
end

local function sswapGetSlotItem(slotConst)
  return getSlot(slotConst)
end

local function sswapGetSlotId(slotConst)
  local it = sswapGetSlotItem(slotConst)
  return it and it:getId() or 0
end

local function sswapGetContainers()
  if type(getContainers) == "function" then
    return getContainers() or {}
  end
  if g_game and type(g_game.getContainers) == "function" then
    return g_game.getContainers() or {}
  end
  return {}
end

local function sswapFindItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  if type(findItem) == "function" then
    local it = findItem(id)
    if it then return it end
  end

  for _, cont in pairs(sswapGetContainers()) do
    for _, it in ipairs(cont:getItems() or {}) do
      if it and it.getId and tonumber(it:getId()) == id then
        return it
      end
    end
  end

  return nil
end

local function sswapGetFreeContainer()
  for _, container in ipairs(sswapGetContainers()) do
    local name = (container.getName and container:getName() or ""):lower()
    local cap = container.getCapacity and tonumber(container:getCapacity()) or 0
    local count = container.getItemsCount and tonumber(container:getItemsCount()) or #(container:getItems() or {})

    if (cap <= 0 or count < cap)
      and not name:find("dead")
      and not name:find("slain")
      and not name:find("depot")
      and not name:find("locker")
      and not name:find("quiver") then
      return container
    end
  end
  return nil
end

local function sswapUnequipSlot(slotConst)
  local item = sswapGetSlotItem(slotConst)
  if not item then return false end

  if not SWAPSET_IS_OLD_CLIENT then
    local ok = pcall(function()
      g_game.equipItemId(item:getId())
    end)
    return ok
  end

  local dest = sswapGetFreeContainer()
  if not dest then return false end

  local pos = dest.getSlotPosition and dest:getSlotPosition(dest.getItemsCount and dest:getItemsCount() or #(dest:getItems() or {}))
  if not pos then return false end

  local ok = pcall(function()
    g_game.move(item, pos, item:getCount())
  end)
  return ok
end

local function sswapEquipToSlot(itemId, slotConst)
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return false end

  if not SWAPSET_IS_OLD_CLIENT then
    local ok = pcall(function()
      g_game.equipItemId(itemId, slotConst)
    end)
    if ok then return true end

    ok = pcall(function()
      g_game.equipItemId(itemId)
    end)
    return ok
  end

  local it = sswapFindItemById(itemId)
  if not it then return false end

  local ok = pcall(function()
    g_game.move(it, {x = 65535, y = slotConst, z = 0}, 1)
  end)
  return ok
end

local function sswapPrepareHands(slots)
  local wantLeft = tonumber(slots["left-hand"]) or 0
  local wantRight = tonumber(slots["right-hand"]) or 0

  local curLeft = sswapGetSlotId(SlotLeft)
  local curRight = sswapGetSlotId(SlotRight)

  if curLeft > 0 and wantLeft == 0 and wantRight > 0 then
    if sswapUnequipSlot(SlotLeft) then return true end
  end

  if curRight > 0 and wantRight == 0 and wantLeft > 0 then
    if sswapUnequipSlot(SlotRight) then return true end
  end

  if wantRight > 0 and curLeft > 0 and curLeft ~= wantLeft then
    if sswapUnequipSlot(SlotLeft) then return true end
  end

  if wantLeft > 0 and curRight > 0 and curRight ~= wantRight then
    if sswapUnequipSlot(SlotRight) then return true end
  end

  return false
end

local function sswapApplyOldClient(index)
  local cfg = sswapGetSet(index)
  if not cfg then return false, true end

  local slots = cfg.slots or {}

  if sswapPrepareHands(slots) then
    return true, false
  end

  for _, part in ipairs(SWAPSET_ORDER) do
    local wantedId = tonumber(slots[part]) or 0
    local slotConst = SWAPSET_SLOT_CONST[part]
    local currentId = sswapGetSlotId(slotConst)

    if wantedId <= 0 then
      if currentId > 0 then
        if sswapUnequipSlot(slotConst) then
          return true, false
        end
      end
    else
      if currentId ~= wantedId then
        if sswapEquipToSlot(wantedId, slotConst) then
          return true, false
        end
        return false, false
      end
    end
  end

  return false, true
end

local function sswapApplyNewClient(index)
  local cfg = sswapGetSet(index)
  if not cfg then return false, true end

  local slots = cfg.slots or {}
  local changed = false

  if sswapPrepareHands(slots) then
    changed = true
  end

  for _, part in ipairs(SWAPSET_ORDER) do
    local wantedId = tonumber(slots[part]) or 0
    local slotConst = SWAPSET_SLOT_CONST[part]
    local currentId = sswapGetSlotId(slotConst)

    if wantedId <= 0 then
      if currentId > 0 then
        if sswapUnequipSlot(slotConst) then
          changed = true
        end
      end
    else
      if currentId ~= wantedId then
        local ok = pcall(function()
          g_game.equipItemId(wantedId)
        end)

        if not ok then
          ok = pcall(function()
            g_game.equipItemId(wantedId)
          end)
        end

        if ok then
          changed = true
        end
      end
    end
  end

  for _, part in ipairs(SWAPSET_ORDER) do
    local wantedId = tonumber(slots[part]) or 0
    local slotConst = SWAPSET_SLOT_CONST[part]
    local currentId = sswapGetSlotId(slotConst)

    if wantedId > 0 and currentId ~= wantedId then
      return changed, false
    end

    if wantedId <= 0 and currentId > 0 then
      return changed, false
    end
  end

  return changed, true
end

local function sswapRefreshIcon(index)
  local icon = swapSetIcons[index]
  if not icon then return end

  local cfg = sswapGetSet(index)
  local state = sswapGetState(index)

  if not charStorage[switchSwap] or charStorage[switchSwap].enabled ~= true or not cfg or cfg.iconShow ~= true then
    state.active = false
    icon:hide()
    return
  end

  local iconItemId = sswapGetIconItemId(index)
  local name = sswapGetSetName(index)

  sswapSetIconItem(icon, iconItemId)

  if state.active then
    icon.text:setColoredText({name, "green"})
    icon.text:setFont("verdana-11px-rounded")
  else
    icon.text:setColoredText({name, "white"})
    icon.text:setFont("verdana-11px-rounded")
  end

  icon:show()
end

local function sswapRefreshAllIcons()
  for i = 1, 6 do
    sswapRefreshIcon(i)
  end
end

local function sswapStart(index)
  local cfg = sswapGetSet(index)
  if not cfg or cfg.iconShow ~= true then return end
  if not charStorage[switchSwap] or charStorage[switchSwap].enabled ~= true then return end

  local state = sswapGetState(index)
  state.active = true
  state.nextAction = 0
  sswapRefreshIcon(index)
end

local function sswapStop(index)
  local state = sswapGetState(index)
  state.active = false
  sswapRefreshIcon(index)
end

local function sswapCreateIcon(index)
  local icon = addIcon("LNS_SWAP_SET_ICON_" .. index, {
    item = {id = 0, count = 1},
    text = "SET" .. index,
    switchable = false,
    moveable = true
  }, function()
    sswapStart(index)
  end)

  icon:setSize({height = 50, width = 52})
  icon:hide()
  swapSetIcons[index] = icon
end

for i = 1, 6 do
  sswapCreateIcon(i)
end

macro(100, function()
  sswapRefreshAllIcons()
end)

macro(200, function()
  if fullTankIsOn() then return end
  if not charStorage[switchSwap] or charStorage[switchSwap].enabled ~= true then
    for i = 1, 6 do
      sswapGetState(i).active = false
    end
    sswapRefreshAllIcons()
    return
  end

  local t = sswapNow()

  for i = 1, 6 do
    local state = sswapGetState(i)

    if state.active and state.nextAction <= t then
      local changed, finished

      if SWAPSET_IS_OLD_CLIENT then
        changed, finished = sswapApplyOldClient(i)
      else
        changed, finished = sswapApplyNewClient(i)
      end

      if finished then
        sswapStop(i)
      elseif changed then
        state.nextAction = t + SWAPSET_ACTION_DELAY
      end
    end
  end
end)
end

