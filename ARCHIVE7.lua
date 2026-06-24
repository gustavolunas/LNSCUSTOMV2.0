do
  local function lnsTrimText(text)
    return tostring(text or ""):lower():gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")
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

  local function lnsStorageOk()
    return type(storage) == "table"
      and type(storage.extras) == "table"
      and storage.extras.skinMonsters == true
  end

  if not lnsBotNameOk() or not lnsStorageOk() then
    return
  end
end

local function lnsRunBlock(name, fn)
  local ok, err = pcall(fn)
  if not ok then
    warn("[LNS FAIL] " .. tostring(name) .. ": " .. tostring(err))
  end
end

lnsRunBlock("ATTACKBOT", function()
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
end)

lnsRunBlock("HEALING", function()
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
end)

lnsRunBlock("CONDITIONS", function()
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
end)

lnsRunBlock("HEALFRIEND", function()
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
    if config.guildMembers and creature.getEmblem then
      local emblem = creature:getEmblem()
      if emblem == 1 or emblem == 4 then return true end
    end

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
    return
  end

  local mpId = config.potionMPID
  if not mpId or mpId <= 100 then
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
    return
  end

  local dist = getDistanceBetween(player:getPosition(), targetCreature:getPosition())
  if dist > 1 then
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

  if config.guildMembers and targetCreature.getEmblem then
    local emblem = targetCreature:getEmblem()
    if emblem == 1 or emblem == 4 then
      validTarget = true
    end
  end

  if validTarget then

    schedule(50, function()
      if g_game.useInventoryItemWith then
        g_game.useInventoryItemWith(mpId, targetCreature)
      else
        useWith(mpId, targetCreature)
      end
    end)
  else
  end
end)
end)

lnsRunBlock("CONTROL_FOLLOW", function()
  local PANEL_NAME = "lnsFollow"
local FOLLOW_SWITCH_ID = "followButton"

local category = "lns"
local MW_RUNE_ID = 3180
local WG_RUNE_ID = 3156
local SD_RUNE_ID = 3155
local ATTACKBOT_SWITCH_ID = "comboButton"
local MINI_WINDOW_NAME = "ingameScriptWindow"
local HOLD_STORAGE_KEY = "lnsLeaderHoldMwWg"

local leaderCommandDelay = 200
local lastLeaderCommand = 0

pausandoCombo = 0

charStorage = charStorage or loadCharStorage()

local function saveLeaderControl()
  saveCharStorage(charStorage)
end

charStorage[PANEL_NAME] = charStorage[PANEL_NAME] or {
  texts = {},
  switches = {}
}

charStorage.follow2Panel = charStorage.follow2Panel or {
  leaderName = "",
  followerName = "",
  ueSpell = ""
}

charStorage[HOLD_STORAGE_KEY] = charStorage[HOLD_STORAGE_KEY] or {
  enabled = { mw = false, wg = false },
  marks = {}
}

charStorage[MINI_WINDOW_NAME] = charStorage[MINI_WINDOW_NAME] or {}
charStorage[ATTACKBOT_SWITCH_ID] = charStorage[ATTACKBOT_SWITCH_ID] or { enabled = false }
charStorage[FOLLOW_SWITCH_ID] = charStorage[FOLLOW_SWITCH_ID] or { enabled = false }

if modules.game_interface and modules.game_interface.removeMenuHook then
  modules.game_interface.removeMenuHook(category)
end

local function normalizeText(s)
  s = tostring(s or "")
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  return s
end

local function lowerText(s)
  return normalizeText(s):lower()
end

local function getPanelDb()
  charStorage[PANEL_NAME] = charStorage[PANEL_NAME] or {}
  charStorage[PANEL_NAME].texts = charStorage[PANEL_NAME].texts or {}
  charStorage[PANEL_NAME].switches = charStorage[PANEL_NAME].switches or {}
  return charStorage[PANEL_NAME]
end

local function getFollow2Db()
  charStorage.follow2Panel = charStorage.follow2Panel or {}
  return charStorage.follow2Panel
end

local function getLeaderNameFromFollow2()
  return lowerText(getFollow2Db().leaderName or "")
end

local function getUeSpellFromFollow2()
  return normalizeText(getFollow2Db().ueSpell or "")
end

local function findWidgetById(id)
  local root = g_ui and g_ui.getRootWidget and g_ui.getRootWidget()
  if not root or not root.recursiveGetChildById then return nil end
  return root:recursiveGetChildById(id)
end

local function getHookPos(pos, lookThing, useThing, creatureThing)
  if pos and pos.x and pos.y and pos.z then return pos end

  for _, thing in ipairs({lookThing, useThing, creatureThing}) do
    if thing and thing.getPosition then
      local p = thing:getPosition()
      if p and p.x and p.y and p.z then return p end
    end
  end

  return nil
end

local function parseCommandPos(text, prefix)
  local pattern = "^" .. prefix .. "%s*:%s*(%-?%d+)%s*,%s*(%-?%d+)%s*,%s*(%-?%d+)%s*$"
  local x, y, z = normalizeText(text):match(pattern)
  if not x then return nil end
  return {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
end

local function sayHookPos(prefix, pos, lookThing, useThing, creatureThing)
  local p = getHookPos(pos, lookThing, useThing, creatureThing)
  if not p then return end
  sayChannel(1, string.format("%s: %d,%d,%d", prefix, p.x, p.y, p.z))
end

local function safeUseWithItem(itemId, target)
  if not itemId or not target then return false end

  local item = findItem(itemId)
  if not item then return false end

  return useWith(item, target) and true or false
end

local function useRuneOnPos(itemId, pos)
  if not itemId or not pos then return false end

  local tile = g_map.getTile(pos)
  if not tile then return false end

  local topThing = tile:getTopUseThing()
  if not topThing then return false end

  return safeUseWithItem(itemId, topThing)
end

local function syncSwitchVisual(panelGlobal, switchId, state)
  if panelGlobal and panelGlobal.title and panelGlobal.title.setOn then
    panelGlobal.title:setOn(state)
    return
  end

  local panel = findWidgetById(switchId)
  if not panel then return end

  local title = panel.getChildById and panel:getChildById("title")
  if not title then return end

  title:setOn(state)
end

local function setAttackBotState(state)
  state = state == true

  charStorage[ATTACKBOT_SWITCH_ID] = charStorage[ATTACKBOT_SWITCH_ID] or {}
  charStorage[ATTACKBOT_SWITCH_ID].enabled = state
  saveLeaderControl()

  if comboButton and comboButton.title and comboButton.title.setOn then
    comboButton.title:setOn(state)
  else
    syncSwitchVisual(comboButton, ATTACKBOT_SWITCH_ID, state)
  end
end

local function setFollowState(state)
  state = state == true

  charStorage.follow2Panel = charStorage.follow2Panel or {}
  charStorage.follow2Panel.enabled = state

  charStorage[FOLLOW_SWITCH_ID] = charStorage[FOLLOW_SWITCH_ID] or {}
  charStorage[FOLLOW_SWITCH_ID].enabled = state

  if not state then
    g_game.cancelFollow()

    if g_game.cancelAttack then
      -- não cancela ataque, só follow
    end

    if player and player.stopAutoWalk then
      pcall(function() player:stopAutoWalk() end)
    end
  end

  if followButton and followButton.title and followButton.title.setOn then
    followButton.title:setOn(state)
  else
    syncSwitchVisual(followButton, FOLLOW_SWITCH_ID, state)
  end

  saveLeaderControl()
end

local function getHoldDb()
  charStorage[HOLD_STORAGE_KEY] = charStorage[HOLD_STORAGE_KEY] or {}
  charStorage[HOLD_STORAGE_KEY].enabled = charStorage[HOLD_STORAGE_KEY].enabled or { mw = false, wg = false }
  charStorage[HOLD_STORAGE_KEY].marks = charStorage[HOLD_STORAGE_KEY].marks or {}
  return charStorage[HOLD_STORAGE_KEY]
end

local function holdPosKey(pos)
  return string.format("%d,%d,%d", pos.x, pos.y, pos.z)
end

local function splitHoldPosKey(key)
  local x, y, z = tostring(key):match("^(%-?%d+),(%-?%d+),(%-?%d+)$")
  if not x then return nil end
  return {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
end

local function isHoldMwEnabled()
  return getHoldDb().enabled.mw == true
end

local function isHoldWgEnabled()
  return getHoldDb().enabled.wg == true
end

local function addHoldMark(pos, text)
  if not pos or not text then return end
  getHoldDb().marks[holdPosKey(pos)] = text
  saveLeaderControl()
end

local function clearHoldMarksByText(text)
  local db = getHoldDb()
  local keep = {}

  for key, value in pairs(db.marks or {}) do
    local pos = splitHoldPosKey(key)
    local tile = pos and g_map.getTile(pos)

    if value == text then
      if tile and tile.getText and tile:getText() == text then
        pcall(function()
          tile:setText("")
        end)
      end
    else
      keep[key] = value
    end
  end

  db.marks = keep
  charStorage[HOLD_STORAGE_KEY].marks = keep
  saveLeaderControl()
end

local function setHoldMwState(state)
  local db = getHoldDb()
  db.enabled.mw = state == true

  if db.enabled.mw ~= true then
    clearHoldMarksByText("HOLD MW")
    db = getHoldDb()
    db.enabled.mw = false
    db.marks = db.marks or {}
  end

  saveLeaderControl()
end

local function setHoldWgState(state)
  local db = getHoldDb()
  db.enabled.wg = state == true

  if db.enabled.wg ~= true then
    clearHoldMarksByText("HOLD WG")
    db = getHoldDb()
    db.enabled.wg = false
    db.marks = db.marks or {}
  end

  saveLeaderControl()
end

local function tileHasHoldField(tile)
  if not tile then return false end

  local items = tile:getItems()
  if not items then return false end

  for i = 1, #items do
    local item = items[i]
    if item and item.getId then
      local id = item:getId()
      if id == 2129 or id == 2130 then
        return true
      end
    end
  end

  return false
end

local function canUseHoldOnTile(tile)
  if not tile then return false end
  if isInPz() then return false end
  if not tile:canShoot() then return false end
  if not tile:isWalkable() then return false end

  local top = tile:getTopUseThing()
  if not top then return false end
  if top:getId() == 2130 then return false end

  local ppos = player and player:getPosition()
  local tpos = tile:getPosition()
  if not ppos or not tpos then return false end
  if ppos.z ~= tpos.z then return false end
  if math.abs(ppos.x - tpos.x) >= 8 or math.abs(ppos.y - tpos.y) >= 6 then return false end

  return true
end

local HOLD_CAST_COOLDOWN_MS = 200
local HOLD_TILE_COOLDOWN_MS = 200
local HOLD_FAIL_COOLDOWN_MS = 100
local HOLD_REMOVE_DEBOUNCE_MS = 170
local lastHoldCastAt = 0
local lastHoldCastByTile = {}

local function tryUseHold(tile, holdText)
  if not tile or not holdText then return false end

  local runeId = nil

  if holdText == "HOLD MW" then
    if not isHoldMwEnabled() then return false end
    runeId = MW_RUNE_ID
  elseif holdText == "HOLD WG" then
    if not isHoldWgEnabled() then return false end
    runeId = WG_RUNE_ID
  else
    return false
  end

  if tileHasHoldField(tile) then return false end
  if not canUseHoldOnTile(tile) then return false end
  if now - lastHoldCastAt < HOLD_CAST_COOLDOWN_MS then return false end

  local pos = tile:getPosition()
  local key = holdPosKey(pos)
  local lastTileCast = lastHoldCastByTile[key] or 0

  if lastTileCast > now then return false end
  if now - lastTileCast < HOLD_TILE_COOLDOWN_MS then return false end

  local used = safeUseWithItem(runeId, tile:getTopUseThing())
  lastHoldCastAt = now

  if used then
    lastHoldCastByTile[key] = now
    return true
  end

  lastHoldCastByTile[key] = now + HOLD_FAIL_COOLDOWN_MS
  return false
end

--==================================================
-- COMBO SIMPLES
-- pause runtime: pausandoCombo = now + 3000
--==================================================

local comboExecutando = false

local function setComboPause(ms)
  pausandoCombo = now + (ms or 3000)
end

local function clearComboPause()
  pausandoCombo = 0
end

local function triggerComboUE()
  if comboExecutando then return false end

  local ueSpell = getUeSpellFromFollow2()
  if ueSpell == "" then return false end

  comboExecutando = true
  setComboPause(3000)

  if type(startComboCountdown) == "function" then
    startComboCountdown("ue")
  end

  schedule(3000, function()
    local spell = getUeSpellFromFollow2()

    if spell ~= "" then
      say(spell)
    end

    schedule(300, function()
      comboExecutando = false
      clearComboPause()
    end)
  end)

  return true
end

local function triggerComboSD()
  if comboExecutando then return false end

  local currentTarget = g_game.getAttackingCreature()
  if not currentTarget then return false end
  if not findItem(SD_RUNE_ID) then return false end

  local targetId = currentTarget:getId()

  comboExecutando = true
  setComboPause(3000)

  if type(startComboCountdown) == "function" then
    startComboCountdown("sd")
  end

  schedule(3000, function()
    if not findItem(SD_RUNE_ID) then
      comboExecutando = false
      clearComboPause()
      return
    end

    local target = getCreatureById(targetId) or g_game.getAttackingCreature()
    if target then
      useWith(SD_RUNE_ID, target)
    end

    schedule(300, function()
      comboExecutando = false
      clearComboPause()
    end)
  end)

  return true
end

local function executeLeaderCommand(text)
  local msg = normalizeText(text)
  local msgLower = msg:lower()

  if msgLower == "set: attackbot [on]" then
    setAttackBotState(true)
    return true
  end

  if msgLower == "set: attackbot [off]" then
    setAttackBotState(false)
    return true
  end

  if msgLower == "set: follow [on]" then
    setFollowState(true)
    return true
  end

  if msgLower == "set: follow [off]" then
    setFollowState(false)
    return true
  end

  if msgLower == "set: targetbot [on]" then
    if TargetBot and TargetBot.setOn then TargetBot.setOn() end
    return true
  end

  if msgLower == "set: targetbot [off]" then
    if TargetBot and TargetBot.setOff then TargetBot.setOff() end
    return true
  end

  if msgLower == "set: cavebot [on]" then
    if CaveBot and CaveBot.setOn then CaveBot.setOn() end
    return true
  end

  if msgLower == "set: cavebot [off]" then
    if CaveBot and CaveBot.setOff then CaveBot.setOff() end
    return true
  end

  if msgLower == "set: combo ue [on]" then
    triggerComboUE()
    return true
  end

  if msgLower == "set: combo sd [on]" then
    triggerComboSD()
    return true
  end

  if msgLower == "set: stop attack" then
    g_game.cancelAttack()
    oldTarget = nil
    targetID = nil
    return true
  end

  if msgLower == "set: hold mw [on]" or msgLower == "hold mw on" then
    setHoldMwState(true)
    return true
  end

  if msgLower == "set: hold mw [off]" or msgLower == "hold mw off" then
    setHoldMwState(false)
    return true
  end

  if msgLower == "set: hold wg [on]" or msgLower == "hold wg on" then
    setHoldWgState(true)
    return true
  end

  if msgLower == "set: hold wg [off]" or msgLower == "hold wg off" then
    setHoldWgState(false)
    return true
  end

  local movePos = parseCommandPos(msg, "MOVE POS")
  if movePos then
    if movePos.z ~= posz() then return true end
    autoWalk(movePos, 100, {ignoreNonPathable = true, ignoreCreatures = true, precision = 1})
    return true
  end

  local mwPos = parseCommandPos(msg, "MW IN")
  if mwPos then
    useRuneOnPos(MW_RUNE_ID, mwPos)
    return true
  end

  local wgPos = parseCommandPos(msg, "WG IN")
  if wgPos then
    useRuneOnPos(WG_RUNE_ID, wgPos)
    return true
  end

  local travelCity = msg:match("Travel to:%s*(.+)")
  if travelCity then
    travelCity = normalizeText(travelCity)

    schedule(200, function()
      NPC.say("hi")
      schedule(200, function()
        NPC.say(travelCity)
        schedule(200, function()
          NPC.say("yes")
          schedule(200, function()
            NPC.say("yes")
          end)
        end)
      end)
    end)

    return true
  end

  return false
end

local hooks = {
  {label = "LNS | MC Use Here", prefix = "USE TO"},
  {label = "LNS | Move Pos", prefix = "MOVE POS"},
  {label = "LNS | MC Use MW", prefix = "MW IN"},
  {label = "LNS | MC Use WG", prefix = "WG IN"},
}

for i = 1, #hooks do
  local hook = hooks[i]
  modules.game_interface.addMenuHook(category, hook.label, function(pos, lookThing, useThing, creatureThing)
    sayHookPos(hook.prefix, pos, lookThing, useThing, creatureThing)
  end, function() return true end)
end

--==================================================
-- MC LÊ COMANDOS SOMENTE DO LEADER NAME DO FOLLOW 2.0
--==================================================

onTalk(function(name, level, mode, text, channelId, pos)
  if channelId ~= 1 then return end

  local leaderName = getLeaderNameFromFollow2()
  if leaderName == "" then return end
  if lowerText(name) ~= leaderName then return end

  if now < lastLeaderCommand then return end
  lastLeaderCommand = now + leaderCommandDelay

  executeLeaderCommand(text)
end)

onUseWith(function(pos, itemId, target)
  if not target or not target.getPosition then return end

  if itemId == MW_RUNE_ID then
    if not isHoldMwEnabled() then return end

    local tpos = target:getPosition()
    if not tpos then return end

    local tile = g_map.getTile(tpos)
    if not tile then return end

    tile:setText("HOLD MW")
    addHoldMark(tpos, "HOLD MW")
    return
  end

  if itemId == WG_RUNE_ID then
    if not isHoldWgEnabled() then return end

    local tpos = target:getPosition()
    if not tpos then return end

    local tile = g_map.getTile(tpos)
    if not tile then return end

    tile:setText("HOLD WG")
    addHoldMark(tpos, "HOLD WG")
    return
  end
end)

onRemoveThing(function(tile, thing)
  if not tile or not thing or not thing.getId then return end

  local id = thing:getId()
  if id ~= 2129 and id ~= 2130 then return end

  local txt = tile:getText()
  if txt ~= "HOLD MW" and txt ~= "HOLD WG" then return end

  local pos = tile:getPosition()
  if not pos then return end

  local key = holdPosKey(pos)
  local current = lastHoldCastByTile[key] or 0
  lastHoldCastByTile[key] = math.max(current, now + HOLD_REMOVE_DEBOUNCE_MS)
end)

macro(20, function()
  local db = getHoldDb()

  for key, holdText in pairs(db.marks or {}) do
    local enabled = false

    if holdText == "HOLD MW" then
      enabled = isHoldMwEnabled()
    elseif holdText == "HOLD WG" then
      enabled = isHoldWgEnabled()
    end

    if enabled then
      local pos = splitHoldPosKey(key)
      if pos then
        local tile = g_map.getTile(pos)
        if tile then
          if tile:getText() ~= holdText then
            tile:setText(holdText)
          end

          if tryUseHold(tile, holdText) then
            return
          end
        end
      end
    end
  end
end)

toolsScripts = setupUI([[
MiniWindow
  id: toolsScripts
  text: Leader Control
  height: 270
  width: 175
  icon: /images/topbuttons/combatcontrols
  icon-size: 15 15

  Panel
    id: panelScripts
    anchors.fill: parent
    margin-top: 20
    margin-left: 5
    margin-right: 5
    margin-bottom: 5
    layout:
      type: verticalBox
]], g_ui.getRootWidget())
toolsScripts:hide()

g_ui.loadUIFromString([[
LeaderRow < Panel
  height: 22
  margin-top: 2

  HorizontalSeparator
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.left: parent.left

  Label
    id: label
    anchors.left: parent.left
    anchors.top: prev.top
    margin-top: 5
    width: 110
    color: white
    font: verdana-11px-rounded
    text: Command

  Button
    id: onBtn
    anchors.right: offBtn.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 1
    width: 40
    height: 18
    font: verdana-11px-rounded
    text: ON
    color: #98FB98

  Button
    id: offBtn
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 40
    height: 18
    font: verdana-11px-rounded
    text: OFF
    color: #CD5C5C
]])

local saved = charStorage[MINI_WINDOW_NAME]
saved.minimized = saved.minimized == true

if saved.x and saved.y then
  toolsScripts:setX(saved.x)
  toolsScripts:setY(saved.y)
end

local normalHeight = tonumber(saved.normalHeight) or 270
local minimizedHeight = 25

local function setLeaderWindowMinimized(state)
  state = state == true

  saved.minimized = state
  saved.normalHeight = normalHeight

  if state then
    normalHeight = toolsScripts:getHeight() > minimizedHeight and toolsScripts:getHeight() or normalHeight
    saved.normalHeight = normalHeight
    toolsScripts.panelScripts:hide()
    toolsScripts:setHeight(minimizedHeight)
  else
    toolsScripts:setHeight(saved.normalHeight or 270)
    toolsScripts.panelScripts:show()
  end

  saveLeaderControl()
end

toolsScripts.onGeometryChange = function(widget, oldRect, newRect)
  if oldRect.width == 0 and oldRect.height == 0 then return end

  saved.x = widget:getX()
  saved.y = widget:getY()

  if not saved.minimized then
    normalHeight = widget:getHeight()
    saved.normalHeight = normalHeight
  end

  saveLeaderControl()
end

schedule(100, function()
  setLeaderWindowMinimized(saved.minimized)
end)

local scrollBar = toolsScripts:getChildById("miniwindowScrollBar")
if scrollBar then scrollBar:hide() end

toolsScripts.closeButton.onClick = function()
  toolsScripts:hide()
end

toolsScripts.minimizeButton:setMarginLeft(23)
toolsScripts.minimizeButton.onClick = function()
  setLeaderWindowMinimized(not saved.minimized)
end

toolsScripts.lockButton:hide()

local scriptsLeaderControl = toolsScripts.panelScripts

local controls = {
  {text = "AttackBot", on = "set: AttackBot [ON]", off = "set: AttackBot [OFF]"},
  {text = "Follow",    on = "set: Follow [ON]",    off = "set: Follow [OFF]"},
  {text = "TargetBot", on = "set: TargetBot [ON]", off = "set: TargetBot [OFF]"},
  {text = "CaveBot",   on = "set: CaveBot [ON]",   off = "set: CaveBot [OFF]"},
  {text = "Hold MW",   on = "set: Hold MW [ON]",   off = "set: Hold MW [OFF]"},
  {text = "Hold WG",   on = "set: Hold WG [ON]",   off = "set: Hold WG [OFF]"},
  -- {text = "No Escape", on = "set: No Escape [ON]", off = "set: No Escape [OFF]"},
}

for i = 1, #controls do
  local cfg = controls[i]
  local row = g_ui.createWidget("LeaderRow", scriptsLeaderControl)

  row.label:setText(cfg.text)

  row.onBtn.onClick = function()
    sayChannel(1, cfg.on)
  end

  row.offBtn.onClick = function()
    sayChannel(1, cfg.off)
  end
end

local comboCountdownWidget = nil
local comboCountdownRunning = false

local function getComboCountdownWidget()
  if comboCountdownWidget and not comboCountdownWidget:isDestroyed() then
    return comboCountdownWidget
  end

  local root = g_ui.getRootWidget()
  if not root then return nil end

  comboCountdownWidget = g_ui.loadUIFromString([[
Panel
  id: comboCountdownWidget
  size: 90 21
  anchors.centerIn: parent
  margin-top: -180
  margin-left: -17

  Label
    id: text
    anchors.fill: parent
    text-align: center
    font: verdana-11px-rounded
    color: #EEC900
    text: COMBO
]], root)

  return comboCountdownWidget
end

local function showComboCountdownText(text, color)
  local widget = getComboCountdownWidget()
  if not widget then return end

  local label = widget:getChildById("text")
  if not label then return end

  label:setText(text)

  if color then
    label:setColor(color)
  end

  widget:show()
  widget:raise()
end

function startComboCountdown(kind)
  if comboCountdownRunning then return end
  comboCountdownRunning = true

  local prefix = kind == "sd" and "EXEC SD: " or "EXEC UE: "
  local lastText = kind == "sd" and "SD!!!" or "BUUUM!!!"
  local color = kind == "sd" and "#AAAAAA" or "#EEC900"
  local finalColor = kind == "sd" and "white" or "red"

  showComboCountdownText(prefix .. "3", color)

  schedule(1000, function()
    showComboCountdownText(prefix .. "2", color)

    schedule(1000, function()
      showComboCountdownText(prefix .. "1", color)

      schedule(1000, function()
        showComboCountdownText(lastText, finalColor)

        schedule(1200, function()
          if comboCountdownWidget and not comboCountdownWidget:isDestroyed() then
            comboCountdownWidget:hide()
          end
          comboCountdownRunning = false
        end)
      end)
    end)
  end)
end

local butSD = g_ui.createWidget("Button", scriptsLeaderControl)
butSD:setText("Combo SD")
butSD:setMarginTop(3)
butSD.onClick = function()
  sayChannel(1, "set: Combo SD [ON]")
  startComboCountdown("sd")
end
butSD:setHeight(22)
butSD:setFont("verdana-11px-rounded")
butSD:setColor("#696969")

local butUE = g_ui.createWidget("Button", scriptsLeaderControl)
butUE:setText("Combo UE")
butUE.onClick = function()
  sayChannel(1, "set: Combo UE [ON]")
  startComboCountdown("ue")
end
butUE:setHeight(22)
butUE:setMarginTop(1)
butUE:setFont("verdana-11px-rounded")
butUE:setColor("#EEC900")

local butCancelAtk = g_ui.createWidget("Button", scriptsLeaderControl)
butCancelAtk:setText("Stop Attack")
butCancelAtk.onClick = function()
  sayChannel(1, "set: Stop Attack")
end
butCancelAtk:setHeight(22)
butCancelAtk:setMarginTop(1)
butCancelAtk:setFont("verdana-11px-rounded")
butCancelAtk:setColor("white")
end)

lnsRunBlock("FOLLOW", function()
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

end)

lnsRunBlock("SWAPPING", function()
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

end)

lnsRunBlock("SWAP", function()
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
end)

lnsRunBlock("FAST_TRAVEL", function()
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
end)

lnsRunBlock("IMBUEMENTS", function()
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

end)

lnsRunBlock("IMBUE_SCROLL", function()
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
  releaseCavebotUntil = 0,

  -- Controle usado APENAS pelo checker do CaveBot.
  -- startScrollImbueBlank(), stopScrollImbueBlank() e icones NAO desligam/ligam CaveBot.
  cavebotControl = false,
  cavebotWasOn = false,
  cavebotFallbackAt = 0
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

local BLANK_CAVEBOT_FALLBACK_BASE_MS = 60000
local BLANK_CAVEBOT_FALLBACK_PER_SCROLL_MS = 18000

local function caveBotIsOnSafe()
  if not CaveBot then return true end

  if type(CaveBot.isOn) == "function" then
    local ok, result = pcall(function()
      return CaveBot.isOn()
    end)
    if ok then return result == true end
  end

  if type(CaveBot.isOff) == "function" then
    local ok, result = pcall(function()
      return CaveBot.isOff()
    end)
    if ok then return result ~= true end
  end

  -- Se nao tiver isOn/isOff, considera ligado porque esta vindo de uma Action do CaveBot.
  return true
end

local function caveBotSetOffSafe()
  if CaveBot and type(CaveBot.setOff) == "function" then
    return pcall(function()
      CaveBot.setOff()
    end)
  end
  return false
end

local function caveBotSetOnSafe()
  if CaveBot and type(CaveBot.setOn) == "function" then
    return pcall(function()
      CaveBot.setOn()
    end)
  end
  return false
end

local function calcBlankCavebotFallbackMs(queue)
  local total = type(queue) == "table" and #queue or 0
  return math.max(
    BLANK_CAVEBOT_FALLBACK_BASE_MS,
    15000 + (total * BLANK_CAVEBOT_FALLBACK_PER_SCROLL_MS)
  )
end

local function pauseCaveBotForBlank(queue)
  scrollCraftState.cavebotControl = true
  scrollCraftState.cavebotWasOn = caveBotIsOnSafe()
  scrollCraftState.cavebotFallbackAt = nowMs() + calcBlankCavebotFallbackMs(queue)

  if scrollCraftState.cavebotWasOn == true then
    caveBotSetOffSafe()
  end
end

local function releaseCaveBotFromBlank()
  if scrollCraftState.cavebotControl == true and scrollCraftState.cavebotWasOn == true then
    caveBotSetOnSafe()
  end

  scrollCraftState.cavebotControl = false
  scrollCraftState.cavebotWasOn = false
  scrollCraftState.cavebotFallbackAt = 0
end

local function keepCaveBotOffDuringBlank()
  if scrollCraftState.cavebotControl == true and scrollCraftState.cavebotWasOn == true then
    caveBotSetOffSafe()
  end
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
  scrollCraftState.cavebotControl = false
  scrollCraftState.cavebotWasOn = false
  scrollCraftState.cavebotFallbackAt = 0
end

local function finishScrollCrafting(message, releaseCavebotMs)
  -- So religa o CaveBot se o processo foi iniciado pelo checker especifico do CaveBot.
  releaseCaveBotFromBlank()

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

function startScrollImbueBlankCaveBot()
  if scrollCraftState.active then
    keepCaveBotOffDuringBlank()
    return true
  end

  saveBlankRows()
  local q = buildScrollCraftQueue()

  if #q == 0 then
    return false
  end

  if startScrollImbueBlank() then
    pauseCaveBotForBlank(q)
    return true
  end

  return false
end

function checkerScrollImbueBlankCaveBot()
  if scrollCraftState.active then
    keepCaveBotOffDuringBlank()
    return "retry"
  end

  if nowMs() < (scrollCraftState.releaseCavebotUntil or 0) then
    return true
  end

  saveBlankRows()
  local q = buildScrollCraftQueue()

  if #q == 0 then
    return true
  end

  if startScrollImbueBlank() then
    pauseCaveBotForBlank(q)
    return "retry"
  end

  return true
end

function checkerScrollImbueBlankWithCaveBot()
  return checkerScrollImbueBlankCaveBot()
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

  if scrollCraftState.cavebotControl == true then
    keepCaveBotOffDuringBlank()

    if (scrollCraftState.cavebotFallbackAt or 0) > 0 and t > scrollCraftState.cavebotFallbackAt then
      finishScrollCrafting("[Scroll Imbue] Fallback CaveBot: tempo limite atingido, religando CaveBot.", 12000)
      return
    end
  end

  if (scrollCraftState.timeoutAt or 0) > 0 and t > scrollCraftState.timeoutAt then
    finishScrollCrafting("[Scroll Imbue] Timeout de seguranca.", 12000)
    return
  end

  if scrollCraftState.waitingWindow and t - (scrollCraftState.lastAction or 0) > 18000 then
    finishScrollCrafting("[Scroll Imbue] Travou esperando abrir a janela.", 12000)
    return
  end

  if scrollCraftState.waitingApply and t - (scrollCraftState.lastAction or 0) > 18000 then
    finishScrollCrafting("[Scroll Imbue] Travou aplicando o imbue.", 12000)
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

end)

lnsRunBlock("BUY_MARKET", function()
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
end)

lnsRunBlock("AUTO_PREY", function()
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
end)

lnsRunBlock("FUNCTION_CAVEBOT", function()
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
end)

lnsRunBlock("SETTINGS", function()
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

end)

lnsRunBlock("TOOLS", function()
  setDefaultTab("Tools")

UI.Separator():setMarginTop(0)

charStorage = charStorage or loadCharStorage()

local function saveMoneyTrade()
  saveCharStorage(charStorage)
end
local function saveTradeMsg()
  saveCharStorage(charStorage)
end
local function saveDropperItens()
  saveCharStorage(charStorage)
end

charStorage.moneySystem = charStorage.moneySystem or {
  exchangeMoney = false,
  sendTrade = false,
  dropperEnabled = false,
  moneyItems = {3031, 3035, 3043},
  autoTradeMessage = "I'm using LNS CUSTOM | Disc: https://discord.gg/6xUheuXSak",
  dropper = {
    trashItems = {283, 284, 285},
    useItems = {21203, 14758},
    capItems = {21175}
  }
}

local cfg = charStorage.moneySystem

cfg.moneyItems = type(cfg.moneyItems) == "table" and cfg.moneyItems or {3031, 3035, 3043}
cfg.autoTradeMessage = cfg.autoTradeMessage or "I'm using LNS CUSTOM | Disc: https://discord.gg/6xUheuXSak"
cfg.dropper = cfg.dropper or {}
cfg.dropper.trashItems = type(cfg.dropper.trashItems) == "table" and cfg.dropper.trashItems or {283, 284, 285}
cfg.dropper.useItems = type(cfg.dropper.useItems) == "table" and cfg.dropper.useItems or {21203, 14758}
cfg.dropper.capItems = type(cfg.dropper.capItems) == "table" and cfg.dropper.capItems or {21175}

-- =========================
-- EXCHANGE MONEY
-- =========================
exchangeButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: exchangeMoney
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Exchange Money
    height: 18
    color: white
]])

exchangeButton.exchangeMoney:setOn(cfg.exchangeMoney)

exchangeButton.exchangeMoney.onClick = function(widget)
  cfg.exchangeMoney = not widget:isOn()
  widget:setOn(cfg.exchangeMoney)
  saveMoneyTrade()
end

macro(20, function()
  if not cfg.exchangeMoney then return end
  if not cfg.moneyItems[1] then return end

  for _, container in pairs(g_game.getContainers()) do
    if not container.lootContainer then
      for _, item in ipairs(container:getItems()) do
        if item:getCount() == 100 then
          for _, moneyId in ipairs(cfg.moneyItems) do
            local id = type(moneyId) == "table" and moneyId.id or moneyId
            if item:getId() == tonumber(id) then
              return g_game.use(item)
            end
          end
        end
      end
    end
  end
end)

local moneyContainer = UI.Container(function(widget, items)
  cfg.moneyItems = items
  saveMoneyTrade()
end, true)

moneyContainer:setHeight(35)
moneyContainer:setItems(cfg.moneyItems)

UI.Separator()

-- =========================
-- SEND TRADE MESSAGE
-- =========================
sendTrade = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Send message on trade
    height: 18
    color: white
]])

sendTrade.title:setOn(cfg.sendTrade)

sendTrade.title.onClick = function(widget)
  cfg.sendTrade = not widget:isOn()
  widget:setOn(cfg.sendTrade)
  saveTradeMsg()
end

macro(1000, function()
  if not cfg.sendTrade then return end

  local msg = tostring(cfg.autoTradeMessage or "")
  if msg:len() <= 0 then return end

  local trade = getChannelId("advertising")
  if not trade then
    trade = getChannelId("trade")
  end

  if trade then
    sayChannel(trade, msg)
    delay(30000)
  end
end)

UI.TextEdit(cfg.autoTradeMessage, function(widget, text)
  cfg.autoTradeMessage = text
  saveTradeMsg()
end)

UI.Separator()

-- =========================
-- DROPPER
-- =========================
dropper = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Dropper
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

local edit = setupUI([[
Panel
  height: 150
    
  Label
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    text-align: center
    text: Trash:

  BotContainer
    id: TrashItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 32

  Label
    anchors.top: prev.bottom
    margin-top: 5
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Use:

  BotContainer
    id: UseItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 32

  Label
    anchors.top: prev.bottom
    margin-top: 5
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Drop if below 150 cap:

  BotContainer
    id: CapItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 32   
]])

edit:hide()

local showEdit = false
dropper.settings.onClick = function(widget)
  showEdit = not showEdit
  if showEdit then
    edit:show()
  else
    edit:hide()
  end
end

dropper.title:setOn(cfg.dropperEnabled)

dropper.title.onClick = function(widget)
  cfg.dropperEnabled = not widget:isOn()
  widget:setOn(cfg.dropperEnabled)
  saveDropperItens()
end

UI.Container(function()
  cfg.dropper.trashItems = edit.TrashItems:getItems()
  saveDropperItens()
end, true, nil, edit.TrashItems)
edit.TrashItems:setItems(cfg.dropper.trashItems)

UI.Container(function()
  cfg.dropper.useItems = edit.UseItems:getItems()
  saveDropperItens()
end, true, nil, edit.UseItems)
edit.UseItems:setItems(cfg.dropper.useItems)

UI.Container(function()
  cfg.dropper.capItems = edit.CapItems:getItems()
  saveDropperItens()
end, true, nil, edit.CapItems)
edit.CapItems:setItems(cfg.dropper.capItems)

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

macro(200, function()
  if not cfg.dropperEnabled then return end

  local tables = {
    properTable(cfg.dropper.capItems),
    properTable(cfg.dropper.useItems),
    properTable(cfg.dropper.trashItems)
  }

  local containers = getContainers()
  for i = 1, 3 do
    for _, container in pairs(containers) do
      for _, item in ipairs(container:getItems()) do
        for _, userItem in ipairs(tables[i]) do
          if item:getId() == userItem then
            return i == 1 and freecap() < 150 and dropItem(item) or
                   i == 2 and use(item) or
                   i == 3 and dropItem(item)
          end
        end
      end
    end
  end
end)

UI.Separator()

-- =========================
-- PARTY
-- =========================
setDefaultTab("Tools")

local panelPartyName = "autoParty"

charStorage = charStorage or loadCharStorage()

charStorage[panelPartyName] = charStorage[panelPartyName] or {
  leaderName = "Leader",
  autoPartyList = {},
  enabled = false,
  onMove = false,
  soulider = false,
  autoShare = false,

  palavraInvite = "",
  soulider2 = false,
  minLevel = "",
  maxLevel = "",
  palavraPedirPT = "",
  pedirParty = false,
  aceitarParty = false,
  banListPlayers = {},
  selectedTab = "invite",
  maxPartyPlayers = 30
}

local cfgParty = charStorage[panelPartyName]

local function clampMaxPartyPlayers(value)
  value = tonumber(value) or 30
  value = math.floor(value)
  if value < 1 then value = 1 end
  if value > 30 then value = 30 end
  return value
end

local function getMaxPartyPlayers()
  cfgParty.maxPartyPlayers = clampMaxPartyPlayers(cfgParty.maxPartyPlayers)
  return cfgParty.maxPartyPlayers
end

local function saveAutoParty()
  saveCharStorage(charStorage)
end

if cfgParty.onMove == nil then cfgParty.onMove = false end
if cfgParty.soulider == nil then cfgParty.soulider = false end
if cfgParty.autoShare == nil then cfgParty.autoShare = false end
if cfgParty.leaderName == nil then cfgParty.leaderName = "" end
if not cfgParty.autoPartyList then cfgParty.autoPartyList = {} end
if cfgParty.enabled == nil then cfgParty.enabled = true end

if cfgParty.palavraInvite == nil then cfgParty.palavraInvite = "" end
if cfgParty.soulider2 == nil then cfgParty.soulider2 = false end
if cfgParty.minLevel == nil then cfgParty.minLevel = "" end
if cfgParty.maxLevel == nil then cfgParty.maxLevel = "" end
if cfgParty.palavraPedirPT == nil then cfgParty.palavraPedirPT = "" end
if cfgParty.pedirParty == nil then cfgParty.pedirParty = false end
if cfgParty.aceitarParty == nil then cfgParty.aceitarParty = false end
if not cfgParty.banListPlayers then cfgParty.banListPlayers = {} end
if cfgParty.selectedTab == nil then cfgParty.selectedTab = "invite" end
if cfgParty.maxPartyPlayers == nil then cfgParty.maxPartyPlayers = 30 end
cfgParty.maxPartyPlayers = clampMaxPartyPlayers(cfgParty.maxPartyPlayers)

saveAutoParty()

autopartyui = setupUI([[
Panel
  height: 18

  BotSwitch
    id: status
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    height: 18
    margin-right: 45
    text: Auto Party
    color: white

  Button
    id: editPlayerList
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 0
    height: 18
    text: Config
    color: white

]], parent)

g_ui.loadUIFromString([[
AutoPartyName < Label
  height: 20
  focusable: true
  background-color: alpha
  opacity: 1.00
  margin-top: 1
  margin-left: 2
  padding-left: 4
  color: white
  font: verdana-11px-rounded

  $hover:
    background-color: #2F2F2F
    opacity: 0.85

  $focus:
    background-color: #404040
    opacity: 0.95

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

AutoPartyBanName < Label
  height: 20
  focusable: true
  background-color: alpha
  opacity: 1.00
  margin-top: 1
  margin-left: 2
  padding-left: 4
  color: white
  font: verdana-11px-rounded

  $hover:
    background-color: #2F2F2F
    opacity: 0.85

  $focus:
    background-color: #404040
    opacity: 0.95

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

AutoPartyListWindow < MainWindow
  text: Panel Auto Party
  size: 430 370
  anchors.centerIn: parent
  margin-top: -60

  Button
    id: tabInvite
    checkable: true
    anchors.top: parent.top
    anchors.left: parent.left
    height: 33
    margin-left: -5
    width: 134
    text-align: center
    text: Invite List

    UIItem
      id: idInvite
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -3
      margin-left: -10
      size: 33 33
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: prev.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 35
      margin-right: 3
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  Button
    id: tabSay
    checkable: true
    anchors.verticalCenter: tabInvite.verticalCenter
    anchors.left: tabInvite.right
    height: 33
    margin-left: 0
    width: 134
    text-align: center
    text: Say PT

    UIItem
      id: idSay
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -9
      margin-left: -13
      size: 36 36
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: prev.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 38
      margin-right: 3
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  Button
    id: tabBan
    checkable: true
    anchors.verticalCenter: tabSay.verticalCenter
    anchors.left: tabSay.right
    height: 33
    margin-left: 0
    width: 134
    text-align: center
    text: Ban List

    UIItem
      id: idBan
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: -2
      margin-left: -8
      size: 33 33
      padding: 3
      phantom: true

    UIWidget
      id: activeLine
      anchors.left: prev.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-left: 35
      margin-right: 3
      height: 2
      background-color: #d7c08a
      visible: false
      phantom: true

  FlatPanel
    id: flatInvite
    anchors.top: tabInvite.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-bottom: 20
    margin-left: -5
    margin-top: 6
    margin-right: -5

    Label
      id: labeltxtLeader
      text: Leader Name
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: 7
      margin-left: 10
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: txtLeader
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 3
      margin-left: 8
      margin-right: 8
      height: 20
      placeholder: Leader name

    CheckBox
      id: soulider
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 6
      margin-left: 8
      text: I'm Leader
      text-auto-resize: true

    CheckBox
      id: creatureMove
      anchors.top: soulider.top
      anchors.left: soulider.right
      margin-left: 28
      text: Automatic Invite
      text-auto-resize: true

    CheckBox
      id: autoShare
      anchors.top: soulider.top
      anchors.left: creatureMove.right
      margin-left: 28
      text: Auto Share
      text-auto-resize: true

    HorizontalSeparator
      anchors.top: soulider.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 7
      margin-left: 8
      margin-right: 8

    Label
      text: Party Invite List
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 6
      margin-left: 10
      font: verdana-11px-rounded
      text-auto-resize: true

    TextList
      id: lstAutoParty
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 4
      margin-left: 8
      margin-right: 15
      height: 145
      padding: 1
      vertical-scrollbar: AutoPartyListListScrollBar
      font: verdana-11px-rounded

    VerticalScrollBar
      id: AutoPartyListListScrollBar
      anchors.top: lstAutoParty.top
      anchors.bottom: lstAutoParty.bottom
      anchors.left: lstAutoParty.right
      step: 14
      pixels-scroll: true
      visible: true

    TextEdit
      id: playerName
      anchors.top: lstAutoParty.bottom
      anchors.left: parent.left
      anchors.right: addPlayer.left
      margin-top: 7
      margin-left: 8
      margin-right: 5
      height: 20
      placeholder: Player Name

    Button
      id: addPlayer
      text: +
      anchors.right: parent.right
      anchors.top: lstAutoParty.bottom
      margin-top: 7
      width: 45
      height: 20
      margin-right: 8

  FlatPanel
    id: flatSay
    anchors.top: flatInvite.top
    anchors.left: flatInvite.left
    anchors.right: flatInvite.right
    anchors.bottom: flatInvite.bottom

    Label
      text: Party Say Keyword
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: 7
      margin-left: 10
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: palavraInvite
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 3
      margin-left: 8
      margin-right: 8
      height: 20
      placeholder: Keyword

    CheckBox
      id: soulider2
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 6
      margin-left: 8
      text: I'm Leader
      text-auto-resize: true

    HorizontalSeparator
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 7
      margin-left: 8
      margin-right: 8

    Label
      id: lvlminimolabel
      text: Level Minimo:
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 7
      margin-left: 10
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: textMinLevel
      anchors.top: prev.bottom
      anchors.left: parent.left
      width: 195
      margin-top: 3
      margin-left: 8
      height: 20
      placeholder: Level Minimum

    Label
      text: Level Maximo:
      anchors.top: lvlminimolabel.top
      anchors.left: parent.horizontalCenter
      margin-top: 0
      margin-left: 8
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: textMaxLevel
      anchors.top: prev.bottom
      anchors.left: parent.horizontalCenter
      anchors.right: parent.right
      margin-top: 3
      margin-left: 8
      margin-right: 8
      height: 20
      placeholder: Level Maximum

    Label
      id: maxPartyPlayersLabel
      text: Max Party Players: 30
      anchors.top: textMinLevel.bottom
      anchors.left: parent.left
      margin-top: 7
      margin-left: 10
      font: verdana-11px-rounded
      text-auto-resize: true

    HorizontalScrollBar
      id: maxPartyPlayersScroll
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 4
      margin-left: 8
      margin-right: 8
      minimum: 1
      maximum: 30
      step: 1

    HorizontalSeparator
      anchors.top: maxPartyPlayersScroll.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 8
      margin-left: 8
      margin-right: 8

    Label
      text: Ask Party Message
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 7
      margin-left: 10
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: palavraPedirPT
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 3
      margin-left: 8
      margin-right: 8
      height: 20
      placeholder: Ask for party

    CheckBox
      id: pedirParty
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 7
      margin-left: 8
      text: Request Party
      text-auto-resize: true

    CheckBox
      id: aceitarParty
      anchors.top: pedirParty.top
      anchors.left: pedirParty.right
      margin-left: 36
      text: Accept Party
      text-auto-resize: true

  FlatPanel
    id: flatBan
    anchors.top: flatInvite.top
    anchors.left: flatInvite.left
    anchors.right: flatInvite.right
    anchors.bottom: flatInvite.bottom

    Label
      text: Players Banidos
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      margin-top: 7
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
      id: lstBan
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 6
      margin-left: 8
      margin-right: 15
      height: 197
      padding: 1
      vertical-scrollbar: AutoPartyBanListScrollBar
      font: verdana-11px-rounded

    VerticalScrollBar
      id: AutoPartyBanListScrollBar
      anchors.top: lstBan.top
      anchors.bottom: lstBan.bottom
      anchors.left: lstBan.right
      step: 14
      pixels-scroll: true
      visible: true

    TextEdit
      id: txtBan
      anchors.left: parent.left
      anchors.top: lstBan.bottom
      anchors.right: btnAddBan.left
      margin-top: 7
      margin-left: 8
      margin-right: 5
      height: 20
      placeholder: Player Name

    Button
      id: btnAddBan
      text: +
      anchors.right: parent.right
      anchors.top: lstBan.bottom
      margin-top: 7
      width: 45
      height: 20
      margin-right: 8

  Button
    id: closePanel
    anchors.left: flatInvite.left
    anchors.right: flatInvite.right
    anchors.top: flatInvite.bottom
    margin-top: 5
    height: 20
    text: Close
]])

local rootWidget = g_ui.getRootWidget()
if rootWidget then
  tcAutoParty = autopartyui.status

  autoPartyListWindow = UI.createWindow("AutoPartyListWindow", rootWidget)
  autoPartyListWindow:hide()


  local function WParty(root, id)
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
          local child = childs[i]
          if child and child.getId then
            local okId, childId = pcall(function() return child:getId() end)
            if okId and childId == id then return child end
          end

          local found = WParty(child, id)
          if found then return found end
        end
      end
    end

    return nil
  end

  local function showPartyWidget(widget, visible)
    if not widget then return end
    if visible then
      if widget.show then widget:show() end
    else
      if widget.hide then widget:hide() end
    end
  end

  local function setPartyTabPressed(button, pressed)
    if not button then return end
    showPartyWidget(WParty(button, "activeLine"), pressed)

    if button.setChecked then pcall(function() button:setChecked(pressed) end) end
    if button.setPressed then pcall(function() button:setPressed(pressed) end) end
    if button.setOn then pcall(function() button:setOn(pressed) end) end
    if button.setOpacity then button:setOpacity(pressed and 1.00 or 0.74) end
    if button.setColor then button:setColor(pressed and "#d7c08a" or "#d6d6d6") end
  end

  local function setPartyTab(tab)
    if tab ~= "invite" and tab ~= "say" and tab ~= "ban" then tab = "invite" end

    cfgParty.selectedTab = tab

    showPartyWidget(autoPartyListWindow.flatInvite, tab == "invite")
    showPartyWidget(autoPartyListWindow.flatSay, tab == "say")
    showPartyWidget(autoPartyListWindow.flatBan, tab == "ban")

    setPartyTabPressed(autoPartyListWindow.tabInvite, tab == "invite")
    setPartyTabPressed(autoPartyListWindow.tabSay, tab == "say")
    setPartyTabPressed(autoPartyListWindow.tabBan, tab == "ban")

    saveAutoParty()
  end

  local function setPartyIcon(widget, id)
    if widget and widget.setItemId then
      pcall(function() widget:setItemId(tonumber(id) or 0) end)
    end
  end

  local function bindPartyWindowIds()
    local ids = {
      "tabInvite", "tabSay", "tabBan",
      "flatInvite", "flatSay", "flatBan",
      "txtLeader", "soulider", "creatureMove", "autoShare",
      "lstAutoParty", "playerName", "addPlayer",
      "palavraInvite", "soulider2", "textMinLevel", "textMaxLevel",
      "palavraPedirPT", "pedirParty", "aceitarParty",
      "maxPartyPlayersLabel", "maxPartyPlayersScroll",
      "lstBan", "txtBan", "btnAddBan", "closePanel"
    }

    for i = 1, #ids do
      local id = ids[i]
      if not autoPartyListWindow[id] then
        autoPartyListWindow[id] = WParty(autoPartyListWindow, id)
      end
    end

    if autoPartyListWindow.tabInvite and not autoPartyListWindow.tabInvite.idInvite then
      autoPartyListWindow.tabInvite.idInvite = WParty(autoPartyListWindow.tabInvite, "idInvite")
    end

    if autoPartyListWindow.tabSay and not autoPartyListWindow.tabSay.idSay then
      autoPartyListWindow.tabSay.idSay = WParty(autoPartyListWindow.tabSay, "idSay")
    end

    if autoPartyListWindow.tabBan and not autoPartyListWindow.tabBan.idBan then
      autoPartyListWindow.tabBan.idBan = WParty(autoPartyListWindow.tabBan, "idBan")
    end
  end

  bindPartyWindowIds()

  -- Troque estes IDs se quiser outros icones nas abas.
  setPartyIcon(autoPartyListWindow.tabInvite and autoPartyListWindow.tabInvite.idInvite, 31717)
  setPartyIcon(autoPartyListWindow.tabSay and autoPartyListWindow.tabSay.idSay, 24432)
  setPartyIcon(autoPartyListWindow.tabBan and autoPartyListWindow.tabBan.idBan, 3547)

  if autoPartyListWindow.tabInvite then
    autoPartyListWindow.tabInvite.onClick = function()
      setPartyTab("invite")
    end
  end

  if autoPartyListWindow.tabSay then
    autoPartyListWindow.tabSay.onClick = function()
      setPartyTab("say")
    end
  end

  if autoPartyListWindow.tabBan then
    autoPartyListWindow.tabBan.onClick = function()
      setPartyTab("ban")
    end
  end

  setPartyTab(cfgParty.selectedTab or "invite")

  autopartyui.status.onMouseRelease = function(widget, mousePos, mouseButton)
    if mouseButton == 2 then
      if not autoPartyListWindow:isVisible() then
        autoPartyListWindow:show()
        autoPartyListWindow:raise()
        autoPartyListWindow:focus()
      else
        autoPartyListWindow:hide()
      end
    end
  end

  autopartyui.editPlayerList.onClick = function()
    autoPartyListWindow:show()
    autoPartyListWindow:raise()
    autoPartyListWindow:focus()
  end

  if autoPartyListWindow.closePanel then
    autoPartyListWindow.closePanel.onClick = function()
      autoPartyListWindow:hide()
    end
  end

  -- =========================
  -- LISTA
  -- =========================
  if cfgParty.autoPartyList and #cfgParty.autoPartyList > 0 then
    for _, pName in ipairs(cfgParty.autoPartyList) do
      local label = g_ui.createWidget("AutoPartyName", autoPartyListWindow.lstAutoParty)
      label.remove.onClick = function()
        table.removevalue(cfgParty.autoPartyList, label:getText())
        label:destroy()
        saveAutoParty()
      end
      label:setText(pName)
    end
  end

  autoPartyListWindow.addPlayer.onClick = function()
    local pName = autoPartyListWindow.playerName:getText()
    if pName:len() > 0 and not (table.contains(cfgParty.autoPartyList, pName, true) or cfgParty.leaderName == pName) then
      table.insert(cfgParty.autoPartyList, pName)
      saveAutoParty()

      local label = g_ui.createWidget("AutoPartyName", autoPartyListWindow.lstAutoParty)
      label.remove.onClick = function()
        table.removevalue(cfgParty.autoPartyList, label:getText())
        label:destroy()
        saveAutoParty()
      end
      label:setText(pName)
      autoPartyListWindow.playerName:setText("")
    end
  end

  autoPartyListWindow.playerName.onKeyPress = function(_, keyCode)
    if keyCode ~= 5 then return false end
    autoPartyListWindow.addPlayer.onClick()
    return true
  end

  autoPartyListWindow.playerName.onTextChange = function(_, text)
    if table.contains(cfgParty.autoPartyList, text, true) then
      autoPartyListWindow.addPlayer:setColor("#FF0000")
    else
      autoPartyListWindow.addPlayer:setColor("#FFFFFF")
    end
  end

  -- =========================
  -- ENABLE
  -- =========================
  tcAutoParty:setOn(cfgParty.enabled == true)
  tcAutoParty.onClick = function(widget)
    cfgParty.enabled = not (cfgParty.enabled == true)
    widget:setOn(cfgParty.enabled)
    saveAutoParty()
  end

  -- =========================
  -- AUTOMATIC INVITE
  -- =========================
  autoPartyListWindow.creatureMove:setChecked(cfgParty.onMove == true)
  autoPartyListWindow.creatureMove.onClick = function(widget)
    cfgParty.onMove = not (cfgParty.onMove == true)
    widget:setChecked(cfgParty.onMove)
    saveAutoParty()
  end

  -- =========================
  -- TXT LEADER
  -- =========================
  autoPartyListWindow.txtLeader.onTextChange = function(_, text)
    cfgParty.leaderName = text
    saveAutoParty()
  end
  autoPartyListWindow.txtLeader:setText(cfgParty.leaderName or "")

  -- =========================
  -- SOU LIDER
  -- =========================
  autoPartyListWindow.soulider:setChecked(cfgParty.soulider == true)

  local function applySouLider()
    if cfgParty.soulider then
      local myName = player:getName()
      cfgParty.leaderName = myName
      autoPartyListWindow.txtLeader:setText(myName)
    else
      cfgParty.leaderName = ""
      autoPartyListWindow.txtLeader:setText("")
    end
    saveAutoParty()
  end

  autoPartyListWindow.soulider.onClick = function(widget)
    cfgParty.soulider = not (cfgParty.soulider == true)
    widget:setChecked(cfgParty.soulider)
    applySouLider()
  end

  applySouLider()

  -- =========================
  -- AUTO SHAREAR
  -- =========================
  autoPartyListWindow.autoShare:setChecked(cfgParty.autoShare == true)
  autoPartyListWindow.autoShare.onClick = function(widget)
    cfgParty.autoShare = not (cfgParty.autoShare == true)
    widget:setChecked(cfgParty.autoShare)
    saveAutoParty()
  end

  macro(2000, function()
    if not tcAutoParty:isOn() then return end
    if cfgParty.autoShare then
      if player:isPartyLeader() then
        if not player:isPartySharedExperienceActive() then
          g_game.partyShareExperience(true)
        end
      end
    end
  end)

  -- =========================
  -- LADO DIREITO
  -- =========================
  autoPartyListWindow.palavraInvite:setText(cfgParty.palavraInvite or "")
  autoPartyListWindow.palavraInvite.onTextChange = function(_, text)
    cfgParty.palavraInvite = text or ""
    saveAutoParty()
  end

  autoPartyListWindow.soulider2:setChecked(cfgParty.soulider2 == true)
  autoPartyListWindow.soulider2.onClick = function(widget)
    cfgParty.soulider2 = not (cfgParty.soulider2 == true)
    widget:setChecked(cfgParty.soulider2)
    saveAutoParty()
  end

  autoPartyListWindow.textMinLevel:setText(tostring(cfgParty.minLevel or ""))
  autoPartyListWindow.textMinLevel.onTextChange = function(_, text)
    cfgParty.minLevel = text or ""
    saveAutoParty()
  end

  autoPartyListWindow.textMaxLevel:setText(tostring(cfgParty.maxLevel or ""))
  autoPartyListWindow.textMaxLevel.onTextChange = function(_, text)
    cfgParty.maxLevel = text or ""
    saveAutoParty()
  end

  autoPartyListWindow.palavraPedirPT:setText(cfgParty.palavraPedirPT or "")
  autoPartyListWindow.palavraPedirPT.onTextChange = function(_, text)
    cfgParty.palavraPedirPT = text or ""
    saveAutoParty()
  end

  autoPartyListWindow.pedirParty:setChecked(cfgParty.pedirParty == true)
  autoPartyListWindow.pedirParty.onClick = function(widget)
    cfgParty.pedirParty = not (cfgParty.pedirParty == true)
    widget:setChecked(cfgParty.pedirParty)
    saveAutoParty()
  end

  autoPartyListWindow.aceitarParty:setChecked(cfgParty.aceitarParty == true)
  autoPartyListWindow.aceitarParty.onClick = function(widget)
    cfgParty.aceitarParty = not (cfgParty.aceitarParty == true)
    widget:setChecked(cfgParty.aceitarParty)
    saveAutoParty()
  end

  -- =========================
  -- MAX PARTY PLAYERS
  -- =========================
  local loadingMaxPartyPlayers = false

  local function updateMaxPartyPlayersLabel()
    if autoPartyListWindow.maxPartyPlayersLabel then
      autoPartyListWindow.maxPartyPlayersLabel:setText("Max Party Players: " .. getMaxPartyPlayers())
    end
  end

  local function setMaxPartyScrollValue(value)
    local scroll = autoPartyListWindow.maxPartyPlayersScroll
    if not scroll then return end

    if scroll.setMinimum then pcall(function() scroll:setMinimum(1) end) end
    if scroll.setMaximum then pcall(function() scroll:setMaximum(30) end) end
    if scroll.setStep then pcall(function() scroll:setStep(1) end) end
    if scroll.setValue then pcall(function() scroll:setValue(clampMaxPartyPlayers(value)) end) end
  end

  local function readMaxPartyScrollValue(widget, value)
    local v = tonumber(value)
    if not v and widget and widget.getValue then
      local ok, result = pcall(function() return widget:getValue() end)
      if ok then v = tonumber(result) end
    end
    return clampMaxPartyPlayers(v)
  end

  local function saveMaxPartyPlayersFromScroll(widget, value)
    if loadingMaxPartyPlayers then return end
    cfgParty.maxPartyPlayers = readMaxPartyScrollValue(widget, value)
    updateMaxPartyPlayersLabel()
    saveAutoParty()
  end

  loadingMaxPartyPlayers = true
  setMaxPartyScrollValue(getMaxPartyPlayers())
  loadingMaxPartyPlayers = false
  updateMaxPartyPlayersLabel()

  if autoPartyListWindow.maxPartyPlayersScroll then
    autoPartyListWindow.maxPartyPlayersScroll.onValueChange = saveMaxPartyPlayersFromScroll
    autoPartyListWindow.maxPartyPlayersScroll.onValueChanged = saveMaxPartyPlayersFromScroll
  end

  -- =========================
  -- BAN LIST
  -- =========================
  local function reloadBanList()
    if not autoPartyListWindow.lstBan then return end
    autoPartyListWindow.lstBan:destroyChildren()

    for _, name in ipairs(cfgParty.banListPlayers or {}) do
      local row = g_ui.createWidget("AutoPartyBanName", autoPartyListWindow.lstBan)
      row:setText(name)
      row.remove.onClick = function()
        table.removevalue(cfgParty.banListPlayers, row:getText())
        row:destroy()
        saveAutoParty()
      end
    end
  end

  reloadBanList()

  autoPartyListWindow.btnAddBan.onClick = function()
    local name = autoPartyListWindow.txtBan:getText()
    if not name or name:len() == 0 then return end

    if not table.contains(cfgParty.banListPlayers, name, true) then
      table.insert(cfgParty.banListPlayers, name)
      saveAutoParty()
      reloadBanList()
    end

    autoPartyListWindow.txtBan:setText("")
  end

  autoPartyListWindow.txtBan.onKeyPress = function(_, keyCode)
    if keyCode ~= 5 then return false end
    autoPartyListWindow.btnAddBan.onClick()
    return true
  end

  -- =========================
  -- MENSAGENS
  -- =========================
  onTextMessage(function(mode, text)
    if not tcAutoParty:isOn() then return end
    if mode ~= 20 then return end

    if text:find("has joined the party") then
      local data = regexMatch(text, "([a-z A-Z-]*) has joined the party")[1][2]
      if data and table.contains(cfgParty.autoPartyList, data, true) then
        if cfgParty.autoShare and not player:isPartySharedExperienceActive() then
          g_game.partyShareExperience(true)
        end
      end
      return
    end

    if text:find("has invited you") then
      if player:getName():lower() == (cfgParty.leaderName or ""):lower() then
        return
      end

      local data = regexMatch(text, "([a-z A-Z-]*) has invited you")[1][2]
      if data and (cfgParty.leaderName or ""):lower() == data:lower() then
        local leader = getCreatureByName(data, true)
        if leader then
          g_game.partyJoin(leader:getId())
          return
        end
      end
    end
  end)

  -- =========================
  -- INVITES
  -- =========================
  local function creatureInvites(creature)
    if not creature:isPlayer() or creature == player then return end

    if creature:getName():lower() == (cfgParty.leaderName or ""):lower() then
      if creature:getShield() == 1 then
        g_game.partyJoin(creature:getId())
        return
      end
    end

    if player:getName():lower() ~= (cfgParty.leaderName or ""):lower() then return end
    if not table.contains(cfgParty.autoPartyList, creature:getName(), true) then return end
    if creature:isPartyMember() or creature:getShield() == 2 then return end

    g_game.partyInvite(creature:getId())
  end

  onCreatureAppear(function(creature)
    if tcAutoParty:isOn() then
      creatureInvites(creature)
    end
  end)

  onCreaturePositionChange(function(creature)
    if tcAutoParty:isOn() and cfgParty.onMove then
      creatureInvites(creature)
    end
  end)
end

-- =====================================================
-- == LÓGICA COMPLETA AUTO PARTY
-- =====================================================
local infoTime = 0
local talkTime = 0
local justForInfo = true
local canSeeInfo = true
local partyMembersCount = 0

local lastInfoAt = 0
local lastUnlockAt = 0

local lastCloseAt = 0

macro(1000, function()
  if not cfgParty.enabled then return end

  local now = os.time()

  if fecharPaineis and fecharPaineis > 0 and now <= fecharPaineis then
    if lastCloseAt == 0 or (now - lastCloseAt) >= 3 then
      local root = g_ui.getRootWidget()
      if root then
        for _, widget in ipairs(root:recursiveGetChildren()) do
          if widget:getStyleName() == 'MessageBoxLabel' then
            local parent = widget:getParent()
            if parent and parent.destroy then
              parent:destroy()
            end
            lastCloseAt = now
            break
          end
        end
      end
    end
  end

  if not cfgParty.soulider2 then
    justForInfo = true
    partyMembersCount = 0
    infoTime = 0
    lastInfoAt = 0
    canSeeInfo = true
    return
  end

  if not player:isPartyLeader() then
    justForInfo = true
    partyMembersCount = 0
    infoTime = 0
    lastInfoAt = 0
    canSeeInfo = true
    return
  end

  if not canSeeInfo then
    if lastUnlockAt == 0 then lastUnlockAt = now end
    if (now - lastUnlockAt) >= 3 then
      canSeeInfo = true
      lastUnlockAt = 0
    end
  end

  if justForInfo and canSeeInfo then
    local partyId = getChannelId("party")
    if partyId then
      sayChannel(partyId, "!party info")
    else
      say("!party info")
    end

    fecharPaineis = now + 5
    lastInfoAt = now
    return
  end

  if canSeeInfo and (lastInfoAt == 0 or (now - lastInfoAt) >= 15) then
    local partyId = getChannelId("party")
    if partyId then
      sayChannel(partyId, "!party info")
    else
      say("!party info")
    end

    fecharPaineis = now + 5
    lastInfoAt = now
    return
  end

  if talkTime > 0 then
    talkTime = talkTime - 1
  end
end)

onLoginAdvice(function(text)
  if not cfgParty.enabled or not cfgParty.soulider2 then return end
  if not player:isPartyLeader() then return end

  local explode1 = string.explode(text, "*")
  local explode2 = string.explode(explode1[8], ":")[2]

  local rawMax = tonumber(string.explode(explode1[4], ":")[2]) or 0
  local rawMin = tonumber(string.explode(explode1[3], ":")[2]) or 0
  
  local calcMax = math.ceil(rawMax * 1.5)
  local calcMin = math.ceil(rawMin * 0.66)

  cfgParty.maxLevel = tostring(calcMax)
  cfgParty.minLevel = tostring(calcMin)
  saveAutoParty()

  autoPartyListWindow.textMaxLevel:setText(cfgParty.maxLevel)
  autoPartyListWindow.textMinLevel:setText(cfgParty.minLevel)

  partyMembersCount = tonumber(string.explode(explode1[2], ":")[2]) or 0
  if justForInfo then
    justForInfo = false
    return
  end

  if explode2:find(",") then
    local names = string.explode(explode2, ",")
    for i = 1, #names do
      canSeeInfo = false
      schedule(10 * i, function()
        if i == #names then
          canSeeInfo = true
        end
        sayChannel(getChannelId("party"), "!party kick," .. names[i])
      end)
    end
  elseif explode2 ~= "" then
    schedule(10, function() sayChannel(getChannelId("party"), "!party kick," .. explode2) end)
  end
end)

onTalk(function(name, level, mode, text, channelId, pos)
  if not cfgParty.enabled or not cfgParty.soulider2 then return end
  if name == player:getName() then return end

  local keyword = cfgParty.palavraInvite:lower()
  if keyword == "" then return end

  if text:lower():find(keyword) then
    if table.contains(cfgParty.banListPlayers, name, true) then
      g_game.talkPrivate(5, name, "You are banned from my party.")
      return
    end

    local minL = tonumber(cfgParty.minLevel) or 0
    local maxL = tonumber(cfgParty.maxLevel) or 9999
    if level < minL or level > maxL then
      g_game.talkPrivate(5, name, "Min level: " .. minL .. " | Max level: " .. maxL)
      return
    end

    local maxPartyPlayers = getMaxPartyPlayers()
    if partyMembersCount >= maxPartyPlayers then
      g_game.talkPrivate(5, name, "Party is full (" .. maxPartyPlayers .. " members).")
      return
    end

    local spec = getCreatureByName(name)
    if spec then
      if spec:isPartyMember() or spec:getShield() == 2 then return end
      g_game.partyInvite(spec:getId())
    end
  end
end)

local lastAppearTalk = 0
onCreatureAppear(function(creature)
  if not cfgParty.enabled or not cfgParty.soulider2 then return end
  if not creature:isPlayer() or creature:isLocalPlayer() then return end

  if creature:isPartyMember() or creature:getShield() == 2 then return end

  local now = os.time()

  if partyMembersCount < getMaxPartyPlayers() and (lastAppearTalk == 0 or (now - lastAppearTalk) >= 10) then
    local key = cfgParty.palavraInvite
    if key and key ~= "" then
      say("Fale '" .. key .. "' para ser invitado na party!")
      lastAppearTalk = now
    end
  end
end)

onTextMessage(function(mode, text)
  if not cfgParty.enabled or not cfgParty.soulider2 then return end
  
  local t = text:lower()
  if t:find("you are now the leader") or t:find("has joined the party") or (t:find("has left the party") and canSeeInfo) then
    justForInfo = true
  end

  if t:find("level para compartilhamento") then
    local lMax, lMin = text:match("de (%d+) até (%d+)")
    if lMin and lMax then
      cfgParty.minLevel = lMin
      cfgParty.maxLevel = lMax
      saveAutoParty()

      autoPartyListWindow.textMinLevel:setText(lMin)
      autoPartyListWindow.textMaxLevel:setText(lMax)
    end
  end
end)

local lastsayparty = 0
macro(200, function()
  if not cfgParty.enabled then return end
  if not cfgParty.pedirParty then return end

  if player:getShield() > 2 then return end

  local frase = cfgParty.palavraPedirPT
  if not frase or frase == "" then return end

  local now = os.time()

  if (lastsayparty == 0 or (now - lastsayparty) >= 10) then
    say(frase)
    lastsayparty = now
  end
end)

macro(200, function()
  if not cfgParty.enabled then return end
  if not cfgParty.aceitarParty then return end

  if player:getShield() > 2 then return end

  for _, spec in pairs(getSpectators(false)) do
    if spec:isPlayer() and spec:getShield() == 1 then
      g_game.partyJoin(spec:getId())
      return
    end
  end
end)


-- =========================
-- EATFOOD
-- =========================

UI.Separator()

charStorage = charStorage or loadCharStorage()

local function saveEatFood()
  saveCharStorage(charStorage)
end

charStorage.eatFoodSystem = charStorage.eatFoodSystem or {
  enabled = false,
  foodItems = {3582, 3577}
}

local foodCfg = charStorage.eatFoodSystem

if type(foodCfg.foodItems) ~= "table" then
  foodCfg.foodItems = {3582, 3577}
  saveEatFood()
end

eatFood = setupUI([[
Panel
  height: 19

  BotSwitch
    id: eatFood
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Eat Food
    height: 18
    color: white
]])

eatFood.eatFood:setOn(foodCfg.enabled)

eatFood.eatFood.onClick = function(widget)
  foodCfg.enabled = not widget:isOn()
  widget:setOn(foodCfg.enabled)
  saveEatFood()
end

local foodContainer = UI.Container(function(widget, items)
  foodCfg.foodItems = items
  saveEatFood()
end, true)

foodContainer:setHeight(35)
foodContainer:setItems(foodCfg.foodItems)

local function getFoodIds()
  local ids = {}

  for _, entry in pairs(foodCfg.foodItems or {}) do
    local id = nil

    if type(entry) == "table" then
      id = tonumber(entry.id)
    else
      id = tonumber(entry)
    end

    if id and id > 0 then
      table.insert(ids, id)
    end
  end

  return ids
end

local nextFoodUse = 0

macro(500, function()
  if not foodCfg.enabled then return end

  local isOldClient = g_game.getClientVersion() <= 960

  if isOldClient then
    if nextFoodUse > now then
      return
    end
  else
    if player:getRegenerationTime() > 400 then
      return
    end
  end

  local foodIds = getFoodIds()
  if #foodIds == 0 then return end

  for _, foodId in ipairs(foodIds) do
    use(foodId)

    -- fallback antigo
    local item = findItem(foodId)
    if item then
      use(item)

      if isOldClient then
        nextFoodUse = now + 60000
      end

      return
    end
  end
end)

----------------------------------
--------STAMINA
----------------------------------
UI.Separator()

charStorage = charStorage or loadCharStorage()

charStorage.staminaUse = charStorage.staminaUse or {
  enabled = false,
  itemId = 0,
  value = 1
}

local staminaCfg = charStorage.staminaUse

local function saveStaminaUse()
  saveCharStorage(charStorage)
end

stamina = setupUI([[
Panel
  height: 55

  BotItem
    id: staminaId
    anchors.top: parent.top
    anchors.left: parent.left

  Label
    id: Labelstamina
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 8
    height: 18
    text-align: center
    text: Stamina: 1h
    color: gray

  HorizontalScrollBar
    id: stamina
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 2
    minimum: 1
    maximum: 43

  BotSwitch
    id: staminacheck
    anchors.top: staminaId.bottom
    anchors.left: staminaId.left
    anchors.right: prev.right
    height: 18
    text: Use Stamina
    color: white
    margin-top: 5
]])

local function updateStaminaLabel()
  stamina.Labelstamina:setText("Stamina: " .. tostring(staminaCfg.value or 1) .. "h")
end

if stamina.staminaId.setItemId then
  stamina.staminaId:setItemId(staminaCfg.itemId or 0)
end

stamina.staminaId.onItemChange = function(widget)
  staminaCfg.itemId = widget:getItemId()
  saveStaminaUse()
end

stamina.stamina:setValue(staminaCfg.value or 1)
updateStaminaLabel()

stamina.stamina.onValueChange = function(widget, value)
  staminaCfg.value = value
  updateStaminaLabel()
  saveStaminaUse()
end

stamina.staminacheck:setOn(staminaCfg.enabled == true)

stamina.staminacheck.onClick = function(widget)
  staminaCfg.enabled = not widget:isOn()
  widget:setOn(staminaCfg.enabled)
  saveStaminaUse()
end

macro(1000, function()
  if staminaCfg.enabled ~= true then return end

  local itemId = tonumber(staminaCfg.itemId or 0)
  if itemId <= 0 then return end

  local minStamina = (tonumber(staminaCfg.value) or 1) * 60

  if player:getStamina() <= minStamina then
    use(itemId)
    delay(5000)
  end
end)

------------------------------
--- VIPWARD / WARN DISCORD
------------------------------
UI.Separator()

charStorage = charStorage or loadCharStorage()

charStorage.warnDiscord = charStorage.warnDiscord or {
  enabled = false,
  location = "",
  webhook = "",
  warnGuild = false,
  warnPlayer = false,
  delayWarn = 5,
  sayGuild = false,
  discordWarn = false,
  guildList = "",
  playerList = ""
}

local warnCfg = charStorage.warnDiscord

warnCfg.enabled = warnCfg.enabled == true
warnCfg.location = tostring(warnCfg.location or "")
warnCfg.webhook = tostring(warnCfg.webhook or "")
warnCfg.warnGuild = warnCfg.warnGuild == true
warnCfg.warnPlayer = warnCfg.warnPlayer == true
warnCfg.delayWarn = tonumber(warnCfg.delayWarn) or 5
warnCfg.sayGuild = warnCfg.sayGuild == true
warnCfg.discordWarn = warnCfg.discordWarn == true
warnCfg.guildList = tostring(warnCfg.guildList or "")
warnCfg.playerList = tostring(warnCfg.playerList or "")

local function saveWarn()
  saveCharStorage(charStorage)
end

local cachedPlayerList = {}
local cachedGuildList = {}

local function trimWarn(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function splitList(text)
  local t = {}
  for v in tostring(text or ""):gmatch("[^,]+") do
    v = trimWarn(v):lower()
    if v ~= "" then
      t[v] = true
    end
  end
  return t
end

local function rebuildLists()
  cachedPlayerList = splitList(warnCfg.playerList)
  cachedGuildList = splitList(warnCfg.guildList)
end

rebuildLists()

warnButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Warn Discord
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

warnInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 260 315
  text: Warn Discord
  margin-top: -50

  FlatPanel
    id: flatp
    anchors.fill: parent
    margin: -6
    margin-top: 2
    margin-bottom: 20

    Label
      id: labelLocation
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 5
      text: Location to Warn:

    BotTextEdit
      id: Location
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-right: 5
      margin-top: 5
      placeholder: Insert Text Location
      text-align: left

    Label
      id: labelDiscord
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      text: Link Webhook:

    BotTextEdit
      id: Webhook
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      placeholder: Insert Link Discord Webhook
      text-align: left
      
    HorizontalSeparator
      id: sep1
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5

    Button
      id: filtroGuild
      anchors.top: prev.bottom
      margin-top: 5
      anchors.left: prev.left
      anchors.right: prev.right
      text: List Guilds
      height: 18

    Button
      id: filtroPlayers
      anchors.top: prev.bottom
      margin-top: 2
      anchors.left: prev.left
      anchors.right: prev.right
      text: List Players
      height: 18

    BotSwitch
      id: WarnGuild
      anchors.top: prev.bottom
      anchors.left: prev.left
      margin-top: 5
      width: 115
      text: Warn Guild

    BotSwitch
      id: WarnPlayer
      anchors.top: filtroPlayers.bottom
      anchors.right: filtroPlayers.right
      margin-top: 5
      width: 115
      text: Warn Players

    HorizontalSeparator
      id: sep2
      anchors.top: prev.bottom
      anchors.left: filtroPlayers.left
      anchors.right: filtroPlayers.right
      margin-top: 5

    Label
      id: LabelDelay
      anchors.top: prev.bottom
      margin-top: 5
      anchors.left: prev.left
      anchors.right: prev.right
      text: Delay to Warn: 5s
      text-align: center

    HorizontalScrollBar
      id: delayWarn
      anchors.top: prev.bottom
      margin-top: 5
      anchors.left: prev.left
      anchors.right: prev.right
      step: 1
      minimum: 1
      maximum: 30

    BotSwitch
      id: ativarGuild
      anchors.top: prev.bottom
      anchors.right: prev.right
      anchors.left: prev.left
      margin-top: 5
      text: Say Guild Chat

    BotSwitch
      id: ativarDiscord
      anchors.top: prev.bottom
      anchors.right: prev.right
      anchors.left: prev.left
      margin-top: 5
      text: Active Discord Warn
    
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
]=], g_ui.getRootWidget())

warnInterface:hide()

if modules._G.g_app.isMobile() then
  equipInterface:setSize("260 335")
end

local function updateDelay()
  warnInterface.flatp.LabelDelay:setText("Delay to Warn: " .. tostring(warnCfg.delayWarn or 5) .. "s")
end

warnInterface.flatp.Location:setText(warnCfg.location)
warnInterface.flatp.Webhook:setText(warnCfg.webhook)
warnInterface.flatp.delayWarn:setValue(warnCfg.delayWarn)
warnInterface.flatp.WarnGuild:setOn(warnCfg.warnGuild)
warnInterface.flatp.WarnPlayer:setOn(warnCfg.warnPlayer)
warnInterface.flatp.ativarGuild:setOn(warnCfg.sayGuild)
warnInterface.flatp.ativarDiscord:setOn(warnCfg.discordWarn)
warnButton.title:setOn(warnCfg.enabled)

updateDelay()

warnInterface.flatp.Location.onTextChange = function(_, text)
  warnCfg.location = tostring(text or "")
  saveWarn()
end

warnInterface.flatp.Webhook.onTextChange = function(_, text)
  warnCfg.webhook = tostring(text or "")
  saveWarn()
end

warnInterface.flatp.delayWarn.onValueChange = function(_, value)
  warnCfg.delayWarn = tonumber(value) or 5
  updateDelay()
  saveWarn()
end

warnInterface.flatp.WarnGuild.onClick = function(widget)
  warnCfg.warnGuild = not widget:isOn()
  widget:setOn(warnCfg.warnGuild)
  saveWarn()
end

warnInterface.flatp.WarnPlayer.onClick = function(widget)
  warnCfg.warnPlayer = not widget:isOn()
  widget:setOn(warnCfg.warnPlayer)
  saveWarn()
end

warnInterface.flatp.ativarGuild.onClick = function(widget)
  warnCfg.sayGuild = not widget:isOn()
  widget:setOn(warnCfg.sayGuild)
  saveWarn()
end

warnInterface.flatp.ativarDiscord.onClick = function(widget)
  warnCfg.discordWarn = not widget:isOn()
  widget:setOn(warnCfg.discordWarn)
  saveWarn()
end

warnButton.title.onClick = function(widget)
  warnCfg.enabled = not widget:isOn()
  widget:setOn(warnCfg.enabled)
  saveWarn()
end

warnButton.settings.onClick = function()
  if warnInterface:isVisible() then
    warnInterface:hide()
  else
    warnInterface:show()
    warnInterface:raise()
    warnInterface:focus()
  end
end

warnInterface.closePanel.onClick = function()
  warnInterface:hide()
end

g_ui.loadUIFromString([[
LnsWarnListWindow < MainWindow
  id: mainPanel
  size: 420 300
  text: Setup List
  anchors.centerIn: parent
  margin-top: -50

  FlatPanel
    id: flatp
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: ok.top
    margin: -6
    margin-top: 2
    margin-bottom: 5

    Label
      id: titleLabel
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 7
      margin-left: 8
      margin-right: 8
      text-align: center
      color: #d7c08a
      font: verdana-11px-rounded
      text: Lista

    Label
      id: descLabel
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 8
      margin-right: 8
      text-align: center
      text-wrap: true
      height: 30
      text: Insira os nomes separados por virgula ou um por linha.

    TextEdit
      id: listText
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-top: 8
      margin-left: 8
      margin-right: 8
      margin-bottom: 8
      color: white
      text-wrap: true

  Button
    id: ok
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.bottom: parent.bottom
    height: 20
    margin-left: -5
    margin-right: 2
    margin-bottom: -2
    text: OK

  Button
    id: cancel
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: 20
    margin-left: 2
    margin-right: -5
    margin-bottom: -2
    text: Cancel
]])

local warnListWindow = nil

local function cleanListText(text)
  text = tostring(text or "")
  text = text:gsub("\r", "")
  text = text:gsub("\n", ",")
  text = text:gsub(",+", ",")
  text = text:gsub("^,", "")
  text = text:gsub(",$", "")
  return text
end

local function storageListToText(text)
  return tostring(text or ""):gsub(",", "\n")
end

local function openWarnListWindow(title, desc, storageKey)
  if warnListWindow then
    warnListWindow:destroy()
    warnListWindow = nil
  end

  warnListWindow = UI.createWindow("LnsWarnListWindow", g_ui.getRootWidget())
  warnListWindow:setText(title)
  warnListWindow.flatp.titleLabel:setText(title)
  warnListWindow.flatp.descLabel:setText(desc)
  warnListWindow.flatp.listText:setText(storageListToText(warnCfg[storageKey]))

  warnListWindow:show()
  warnListWindow:raise()
  warnListWindow:focus()

  warnListWindow.ok.onClick = function()
    warnCfg[storageKey] = cleanListText(warnListWindow.flatp.listText:getText())
    rebuildLists()
    saveWarn()

    warnListWindow:destroy()
    warnListWindow = nil

    if modules.game_textmessage then
      modules.game_textmessage.displayBroadcastMessage(title .. " salva com sucesso!", "#00FF00")
    end
  end

  warnListWindow.cancel.onClick = function()
    warnListWindow:destroy()
    warnListWindow = nil
  end
end

warnInterface.flatp.filtroGuild.onClick = function()
  openWarnListWindow(
    "LIST GUILDS",
    "Insira uma guild por linha ou separada por virgula.",
    "guildList"
  )
end

warnInterface.flatp.filtroPlayers.onClick = function()
  openWarnListWindow(
    "LIST PLAYERS",
    "Insira um player por linha ou separado por virgula.",
    "playerList"
  )
end

local playerInfos = {}
local lastWarnCheck = 0
local lastLookCheck = 0
local foundLook = 0

local function getVoc(text)
  text = tostring(text or ""):lower()

  if text:find("sorcerer") then return "MS" end
  if text:find("druid") then return "ED" end
  if text:find("knight") then return "EK" end
  if text:find("paladin") then return "RP" end
  if text:find("monk") then return "EM" end

  return ""
end

local function getWarnPlayersOnScreen()
  local list = {}

  for _, spec in ipairs(getSpectators() or {}) do
    if spec and spec:isPlayer() and spec ~= player and spec:getPosition().z == posz() then
      table.insert(list, spec)
    end
  end

  return list
end

local function requestLookPlayers(force)
  if not force and now - lastLookCheck < 3000 then return end
  lastLookCheck = now

  for _, spec in ipairs(getWarnPlayersOnScreen()) do
    local name = spec:getName()
    if name then
      local info = playerInfos[name:lower()]
      if force or not info or now - (info.updated or 0) > 10000 then
        g_game.look(spec)
        foundLook = now
      end
    end
  end
end

local lookRegex = [[You see ([^\(]*) \(Level ([0-9]*)\)((?:.)* of the ([\w ]*),|)]]

onTextMessage(function(mode, text)
  if not warnCfg.enabled then return end

  local re = regexMatch(text, lookRegex)
  if #re == 0 then return end

  local name = trimWarn(re[1][2])
  local level = trimWarn(re[1][3])
  local guild = trimWarn(re[1][5] or "")
  local voc = getVoc(text)

  if name == "" then return end

  playerInfos[name:lower()] = {
    name = name,
    level = level,
    guild = guild,
    voc = voc,
    updated = now
  }

  local creature = getCreatureByName(name)
  if creature then
    local showGuild = guild
    if showGuild:len() > 10 then
      showGuild = showGuild:sub(1, 10) .. "..."
    end
    creature:setText("\n" .. level .. voc .. "\n" .. showGuild)
  end

  if foundLook and now - foundLook < 500 and modules.game_textmessage then
    modules.game_textmessage.clearMessages()
  end
end)

onCreatureAppear(function(creature)
  if not warnCfg.enabled then return end
  if not creature or not creature:isPlayer() then return end
  if creature == player then return end
  if creature:getPosition().z ~= posz() then return end

  schedule(200, function()
    if creature and creature:isPlayer() and creature:getPosition().z == posz() then
      local name = creature:getName()
      if name and not playerInfos[name:lower()] then
        g_game.look(creature)
        foundLook = now
      end
    end
  end)
end)

onPlayerPositionChange(function(newPos, oldPos)
  if not warnCfg.enabled then return end
  if not newPos or not oldPos then return end

  if newPos.z ~= oldPos.z then
    schedule(500, function()
      requestLookPlayers(true)
    end)
  end
end)

local function isTarget(info)
  if not info then return false end

  local name = tostring(info.name or ""):lower()
  local guild = tostring(info.guild or ""):lower()

  if warnCfg.warnPlayer == true and cachedPlayerList[name] then return true end
  if warnCfg.warnGuild == true and cachedGuildList[guild] then return true end

  return false
end

local function sendDiscord(data)
  if tostring(warnCfg.webhook or "") == "" then return end
  if not HTTP or not HTTP.postJSON then return end

  local payload = {
    username = "LNS Custom",
    embeds = {{
      title = "[LNS] Player Detection",
      color = 10038562,
      fields = {
        { name = "Local:", value = tostring(data.location or "-") },
        { name = "Amount Players on Screen:", value = tostring(data.amountScreen or 0) },
        { name = "Amount Players list:", value = tostring(data.amountList or 0) },
        { name = "Name:", value = tostring(data.name or "-") },
        { name = "Guild:", value = tostring(data.guild or "-") },
        { name = "Level:", value = tostring(data.level or "-") },
        { name = "Voc:", value = tostring(data.voc or "-") }
      },
      footer = {
        text = "LNS Custom"
      }
    }}
  }

  HTTP.postJSON(warnCfg.webhook, payload, function(_, err)
    if err then
      print("Discord Webhook Error: " .. tostring(err))
    end
  end)
end

macro(1000, function()
  if warnCfg.enabled ~= true then return end

  local delaySec = tonumber(warnCfg.delayWarn) or 5
  if now - lastWarnCheck < delaySec * 1000 then return end
  lastWarnCheck = now

  requestLookPlayers(false)

  local players = getWarnPlayersOnScreen()
  local amountScreen = #players
  local matched = {}

  for _, creature in ipairs(players) do
    local name = creature:getName()
    local info = name and playerInfos[name:lower()]

    if info and isTarget(info) then
      matched[name:lower()] = info
    end
  end

  local amountList = 0
  for _ in pairs(matched) do
    amountList = amountList + 1
  end

  if amountList <= 0 then return end

  for _, info in pairs(matched) do
    if warnCfg.discordWarn == true then
      sendDiscord({
        location = warnCfg.location,
        amountScreen = amountScreen,
        amountList = amountList,
        name = info.name,
        guild = info.guild ~= "" and info.guild or "-",
        level = info.level,
        voc = info.voc ~= "" and info.voc or "-"
      })
    end

    if warnCfg.sayGuild == true then
      local ch = getChannelId and getChannelId("guild")
      if ch then
        sayChannel(ch, "[LNS] Player Detection: " .. info.name .. " | Guild: " .. (info.guild ~= "" and info.guild or "-") .. " | Level: " .. info.level .. " | Voc: " .. (info.voc ~= "" and info.voc or "-"))
      end
    end
  end
end)

macro(30000, function()
  local fresh = {}
  for k, info in pairs(playerInfos) do
    if info.updated and now - info.updated < 60000 then
      fresh[k] = info
    end
  end
  playerInfos = fresh
end)

UI.Separator()

if not loadCharStorage or not saveCharStorage then
  return print("[Dummy Train] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function saveDummyChar()
  saveCharStorage(charStorage)
end

local panelName = "Dummy Train"

charStorage[panelName] = charStorage[panelName] or {
  id = 28557,
  id2 = 28559,
  enabled = false,
  training = false,
  lastStart = 0,
  lastTry = 0,
  lastUsePos = nil
}

local cfg = charStorage[panelName]

cfg.training = false
cfg.lastStart = 0
cfg.lastTry = 0
cfg.lastUsePos = nil

local ui = setupUI([[
Panel
  height: 80

  Label
    id: itemLabel
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 5
    margin-left: 2
    text: Exercise
    text-auto-resize: true
    font: verdana-11px-rounded
    color: lightGray

  Label
    id: targetLabel
    anchors.top: parent.top
    anchors.right: parent.right
    margin-top: 5
    margin-right: 12
    text: Dummy
    font: verdana-11px-rounded
    color: lightGray

  BotItem
    id: item
    anchors.top: itemLabel.bottom
    anchors.left: itemLabel.left
    margin-top: 3
    margin-left: 9

  BotItem
    id: Target
    anchors.top: targetLabel.bottom
    anchors.right: targetLabel.right
    margin-top: 3
    margin-right: 6

  BotSwitch
    id: title
    anchors.top: item.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    height: 18
    text-align: center
    !text: tr('Dummy Train')
]], parent)

ui:setId(panelName)

ui.title:setOn(cfg.enabled)

ui.title.onClick = function(widget)
  cfg.enabled = not cfg.enabled
  widget:setOn(cfg.enabled)

  if not cfg.enabled then
    cfg.training = false
    cfg.lastStart = 0
    cfg.lastTry = 0
  end

  saveDummyChar()
end

ui.item:setItemId(cfg.id)

ui.item.onItemChange = function(widget)
  cfg.id = widget:getItemId()
  saveDummyChar()
end

ui.Target:setItemId(cfg.id2)

ui.Target.onItemChange = function(widget)
  cfg.id2 = widget:getItemId()
  saveDummyChar()
end

function setDummyOff()
  cfg.enabled = false
  cfg.training = false
  cfg.lastStart = 0
  cfg.lastTry = 0

  ui.title:setOn(false)

  saveDummyChar()
end

function setDummyOn()
  cfg.enabled = true

  ui.title:setOn(true)

  saveDummyChar()
end

local function safeLower(s)
  return tostring(s or ""):lower()
end

local function isDummyTile(tile)
  if not tile then return false end

  local top = tile:getTopUseThing()
  if not top then return false end

  return top:getId() == cfg.id2
end

local function getClosestDummy()
  local playerPos = pos()
  if not playerPos then return nil end

  local bestTile = nil
  local bestDist = 999

  for _, tile in ipairs(g_map.getTiles(posz())) do
    if isDummyTile(tile) then
      local tPos = tile:getPosition()

      if tPos and tPos.z == playerPos.z then
        local dist = getDistanceBetween(playerPos, tPos)

        if dist <= 7 and dist < bestDist then
          bestDist = dist
          bestTile = tile
        end
      end
    end
  end

  return bestTile
end

local function tryStartTraining()
  local tile = getClosestDummy()
  if not tile then return false end

  local top = tile:getTopUseThing()
  if not top then return false end

  cfg.lastTry = now
  cfg.lastUsePos = tile:getPosition()

  useWith(cfg.id, top)

  return true
end

onTextMessage(function(mode, text)
  if not cfg.enabled then return end

  local msg = safeLower(text)

  if msg:find("you started your training", 1, true) then
    cfg.training = true
    cfg.lastStart = now
    return
  end

  if msg:find("your training has stopped", 1, true)
  or msg:find("your training has been canceled", 1, true)
  or msg:find("training has ended", 1, true)
  or msg:find("you are not training", 1, true)
  or msg:find("there is no dummy", 1, true)
  or msg:find("not possible", 1, true)
  or msg:find("you are too far away", 1, true) then
    cfg.training = false
    cfg.lastStart = 0
    cfg.lastTry = now
    return
  end
end)

cfg.training = false

macro(500, function()
  if not cfg.enabled then return end

  local tile = getClosestDummy()

  if not tile then
    cfg.training = false
    return
  end

  -- se ja iniciou o treino, NAO USA MAIS O ITEM NO DUMMY
  -- isso evita cancelar/reativar em loop
  if cfg.training then
    return
  end

  -- tenta iniciar somente quando realmente nao esta treinando
  if now - (cfg.lastTry or 0) > 3000 then
    tryStartTraining()
  end
end)


-----------------------------------
---------- HUD
-----------------------------------
if not loadCharStorage or not saveCharStorage then
  return print("[HUD] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local switchHud = "hudButton"
local panelName = "hudInterface"

charStorage[switchHud] = charStorage[switchHud] or {
  enabled = false
}

charStorage[panelName] = charStorage[panelName] or {
  switches = {},
  targetInfoPos = nil
}

charStorage[panelName].switches = charStorage[panelName].switches or {}

local function saveHudChar()
  saveCharStorage(charStorage)
end

local hudCfg = charStorage[panelName]

charStorage[switchHud].enabled = true

--==================================================
-- HUD INTERFACE
--==================================================

hudInterface = setupUI([[
MainWindow
  id: mainPanel
  size: 260 230
  border: 1 black
  anchors.centerIn: parent
  margin-top: -60
  text: HUD Settings

  TextList
    id: panelMain
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    margin-bottom: 25
    margin-top: 0
    margin-right: 7
    margin-left: -3
    height: 235
    vertical-scrollbar: spellListScrollBar
    layout: verticalBox

    BotSwitch
      id: barLifeMana
      margin-top: 10
      margin-right: 5
      width: 25
      text: Life/Mana Bar Edited
      font: verdana-11px-rounded
      image-source: ""
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: white
        opacity: 0.80

    BotSwitch
      id: targetInfo
      margin-top: 10
      margin-right: 5
      width: 25
      text: Target Info
      font: verdana-11px-rounded
      image-source: ""
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: white
        opacity: 0.80

    BotSwitch
      id: taskTracker
      margin-top: 10
      margin-right: 5
      width: 25
      text: Task Ragnar
      font: verdana-11px-rounded
      image-source: ""
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: white
        opacity: 0.80

    BotSwitch
      id: comboManager
      margin-top: 10
      margin-right: 5
      width: 25
      text: Manager Attackbot
      font: verdana-11px-rounded
      image-source: ""
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: white
        opacity: 0.80

    BotSwitch
      id: autoBoss
      margin-top: 10
      margin-right: 5
      width: 25
      text: Auto Boss
      font: verdana-11px-rounded
      image-source: ""
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: white
        opacity: 0.80
      
  VerticalScrollBar
    id: spellListScrollBar
    anchors.top: panelMain.top
    anchors.bottom: panelMain.bottom
    anchors.left: panelMain.right
    pixels-scroll: true
    image-color: #363636
    margin-top: 0
    margin-bottom: 0
    step: 10

  Button
    id: closePanel
    anchors.left: panelMain.left
    anchors.right: spellListScrollBar.right
    anchors.top: panelMain.bottom
    margin-left: 0
    margin-top: 5
    text: Close
    color: gray
]], g_ui.getRootWidget())

hudInterface:hide()

local function getHudWidget(id)
  if not hudInterface then return nil end
  return hudInterface:recursiveGetChildById(id)
end

local function bindHudSwitch(id)
  local widget = getHudWidget(id)
  if not widget then
    warn("[HUD] Widget nao encontrado: " .. tostring(id))
    return
  end

  if hudCfg.switches[id] == nil then
    hudCfg.switches[id] = false
    saveHudChar()
  end

  widget:setOn(hudCfg.switches[id] == true)

  widget.onClick = function(w)
    local state = not w:isOn()
    w:setOn(state)
    hudCfg.switches[id] = state
    saveHudChar()
  end
end

bindHudSwitch("barLifeMana")
bindHudSwitch("targetInfo")
bindHudSwitch("taskTracker")
bindHudSwitch("comboManager")
bindHudSwitch("autoBoss")

hudInterface.closePanel.onClick = function()
  hudInterface:hide()
end



--==================================================
-- HELPERS HUD
--==================================================

local function hudMasterOn()
  return true
end

local function hudSwitchOn(id)
  return charStorage[panelName]
    and charStorage[panelName].switches
    and charStorage[panelName].switches[id] == true
end

--==================================================
-- LIFE / MANA BAR
--==================================================

local function hpColor(p)
  return "red"
end

local function mpColor(p)
  if p <= 35 then return "#000099" end
  if p <= 75 then return "#3333CC" end
  return "#4D4DFF"
end

local HP_UI = [[
ProgressBar
  id: barHp
  anchors.centerIn: parent
  margin-top: -255
  margin-left: -20
  height: 11
  width: 320
  border: 1 black
  opacity: 0.60
  text-align: center
  background-color: red
]]

local MP_UI = [[
ProgressBar
  id: barMp
  anchors.centerIn: parent
  margin-top: -243
  margin-left: -20
  height: 11
  width: 240
  border: 1 black
  opacity: 0.60
  text-align: center
  background-color: blue
]]

local bars = {
  hp = nil,
  mp = nil
}

local function ensureBars()
  if bars.hp and not bars.hp:isDestroyed() and bars.mp and not bars.mp:isDestroyed() then
    return
  end

  bars.hp = setupUI(HP_UI, g_ui.getRootWidget())
  bars.mp = setupUI(MP_UI, g_ui.getRootWidget())

  bars.hp:hide()
  bars.mp:hide()
end

local function setBarsVisible(v)
  ensureBars()

  if v then
    bars.hp:show()
    bars.mp:show()
  else
    bars.hp:hide()
    bars.mp:hide()
  end
end

local function updateBars()
  if not bars.hp or not bars.mp then return end

  local hp = hppercent()
  local mp = manapercent()

  bars.hp:setPercent(hp)
  bars.hp:setText(string.format("HP: %d%%", hp))
  bars.hp:setBackgroundColor(hpColor(hp))

  bars.mp:setPercent(mp)
  bars.mp:setText(string.format("MP: %d%%", mp))
  bars.mp:setBackgroundColor(mpColor(mp))
end

macro(100, function()
  if not hudMasterOn() or not hudSwitchOn("barLifeMana") then
    setBarsVisible(false)
    return
  end

  setBarsVisible(true)
  updateBars()
end)

--==================================================
-- TARGET INFO
--==================================================

local targetLifeColors = {
  { percent = 35, color = "red" },
  { percent = 75, color = "yellow" },
  { percent = 100, color = "green" }
}

local function getTargetColor(percent)
  for i = 1, #targetLifeColors do
    if percent <= targetLifeColors[i].percent then
      return targetLifeColors[i].color
    end
  end
  return "green"
end

local targetUI = setupUI([[
UIWindow
  id: targetInfoHUD
  anchors.centerIn: parent
  height: 62
  width: 260
  opacity: 1.00
  padding: 4
  background-color: alpha

  UICreature
    id: targetSprite
    width: 70
    height: 80
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: -18
    margin-top: -4

  Label
    id: targetName
    anchors.left: targetSprite.right
    anchors.right: parent.right
    anchors.top: parent.top
    margin-left: 5
    margin-top: 3
    font: verdana-11px-rounded
    color: white
    text: TARGET

  Label
    id: targetDistance
    anchors.left: targetName.left
    anchors.right: targetName.right
    anchors.top: targetName.bottom
    margin-top: 2
    font: verdana-11px-rounded
    color: white
    text: Distance:

  ProgressBar
    id: targetHpBar
    anchors.left: targetName.left
    anchors.right: parent.right
    anchors.top: targetDistance.bottom
    margin-top: 4
    height: 13
    border: 1 black
    opacity: 0.85
    text-align: center
    background-color: red
]], g_ui.getRootWidget())

targetUI:hide()

local function isMoveKeyPressed()
  if g_app and type(g_app.isMobile) == "function" and g_app:isMobile() then
    return true
  end

  return g_keyboard and g_keyboard.isCtrlPressed and g_keyboard.isCtrlPressed()
end

local function applyTargetPos()
  local p = charStorage[panelName].targetInfoPos

  targetUI:breakAnchors()

  if not p or not p.x or not p.y or (p.x == 0 and p.y == 0) then
    targetUI:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
    targetUI:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
    return
  end

  targetUI:setPosition({ x = p.x, y = p.y })
end

local function saveTargetPos()
  local p = targetUI:getPosition()
  if not p then return end

  charStorage[panelName].targetInfoPos = {
    x = p.x,
    y = p.y
  }

  saveHudChar()
end

local function disableDrag()
  targetUI.onDragEnter = nil
  targetUI.onDragMove = nil
  targetUI:setFocusable(false)
  targetUI:setPhantom(true)
  targetUI:setDraggable(false)
  targetUI:setOpacity(1.00)
end

local function enableDrag()
  targetUI:setFocusable(true)
  targetUI:setPhantom(false)
  targetUI:setDraggable(true)
  targetUI:setOpacity(1.00)

  targetUI.onDragEnter = function(widget, mousePos)
    widget:breakAnchors()
    widget.movingReference = {
      x = mousePos.x - widget:getX(),
      y = mousePos.y - widget:getY()
    }
    return true
  end

  targetUI.onDragMove = function(widget, mousePos)
    local parent = widget:getParent()
    if not parent or not parent.getRect then return true end

    local r = parent:getRect()
    local ref = widget.movingReference or { x = 0, y = 0 }

    local x = mousePos.x - ref.x
    local y = mousePos.y - ref.y

    x = math.min(math.max(r.x, x), r.x + r.width - widget:getWidth())
    y = math.min(math.max(r.y, y), r.y + r.height - widget:getHeight())

    widget:move(x, y)

    charStorage[panelName].targetInfoPos = {
      x = x,
      y = y
    }

    saveHudChar()
    return true
  end
end

local function sqmDistance(a, b)
  if not a or not b then return 0 end

  local dx = math.abs((a.x or 0) - (b.x or 0))
  local dy = math.abs((a.y or 0) - (b.y or 0))

  return math.max(dx, dy)
end

applyTargetPos()

local lastPressed = nil
local lastSavePos = 0

if g_app and type(g_app.isMobile) == "function" and g_app:isMobile() then
  enableDrag()
  lastPressed = true
else
  disableDrag()
end

macro(100, function()
  if not hudMasterOn() or not hudSwitchOn("targetInfo") then
    if targetUI:isVisible() then targetUI:hide() end
    return
  end

  if not g_game.isAttacking() then
    if targetUI:isVisible() then targetUI:hide() end
    return
  end

  if not targetUI:isVisible() then
    targetUI:show()
    applyTargetPos()
  end

  local pressed = isMoveKeyPressed()
  if pressed ~= lastPressed then
    if pressed then
      enableDrag()
    else
      disableDrag()
      saveTargetPos()
    end
    lastPressed = pressed
  end

  if pressed and now - lastSavePos > 500 then
    saveTargetPos()
    lastSavePos = now
  end

  local target = g_game.getAttackingCreature and g_game.getAttackingCreature() or nil
  if not target then
    targetUI:hide()
    return
  end

  if target.getOutfit then
    targetUI.targetSprite:setOutfit(target:getOutfit())
  end

  local name = target.getName and target:getName() or "-"
  local hp = target.getHealthPercent and target:getHealthPercent() or 0

  local myPos = pos and pos() or nil
  local targetPos = target.getPosition and target:getPosition() or nil
  local dist = sqmDistance(myPos, targetPos)

  targetUI.targetName:setText(name)
  targetUI.targetDistance:setText("Distance: " .. dist)

  targetUI.targetHpBar:setPercent(hp)
  targetUI.targetHpBar:setText(hp .. "%")
  targetUI.targetHpBar:setBackgroundColor(getTargetColor(hp))
end)

--==================================================
-- MANAGER ATTACKBOT - LISTA SPELL/RUNE + CD
--==================================================

charStorage[panelName].managerAttackbotPos = charStorage[panelName].managerAttackbotPos or { x = 0, y = 0 }
charStorage[panelName].managerAttackbotMinimized = charStorage[panelName].managerAttackbotMinimized or false

local managerAttackUI = setupUI([[
MiniWindow
  id: managerAttackbotHUD
  size: 270 160
  opacity: 1.00
  text: Manager AttackBot
  icon: /images/topbuttons/combatcontrols
  icon-size: 18 18

  TextList
    id: list
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-left: 7
    margin-top: 22
    margin-right: 15
    margin-bottom: 5
    vertical-scrollbar: scroll
    layout: verticalBox

  VerticalScrollBar
    id: scroll
    anchors.top: list.top
    anchors.bottom: list.bottom
    anchors.right: parent.right
    width: 12
    margin-right: 6
    pixels-scroll: true
    step: 24
]], g_ui.getRootWidget())

managerAttackUI:hide()
local managerAttackRow = [[
Panel
  height: 25
  margin-top: 1
  background-color: alpha
  focusable: true
  $hover:
    background-color: #242424

  BotSwitch
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 2
    size: 21 21
    text: ""
    $on:
      image-color: green
    $!on:
      image-color: #202020

  UIItem
    id: icon
    anchors.left: enabled.right
    anchors.verticalCenter: enabled.verticalCenter
    margin-left: 5
    size: 20 20
    visible: false

  Label
    id: name
    anchors.left: icon.right
    anchors.right: status.left
    anchors.verticalCenter: enabled.verticalCenter
    margin-left: 8
    margin-right: 5
    font: verdana-11px-rounded
    color: white
    text: -
    phantom: false

  Label
    id: status
    anchors.right: parent.right
    anchors.verticalCenter: enabled.verticalCenter
    margin-right: -2
    width: 42
    font: verdana-11px-rounded
    text-align: center
    color: green
    text: ON
]]

local function managerAtkSave()
  if type(saveAttackBotChar) == "function" then
    saveAttackBotChar()
  elseif type(saveCharStorage) == "function" then
    saveCharStorage(charStorage)
  end
end


local function managerAtkProfile()
  charStorage.attackBotProfiles = charStorage.attackBotProfiles or {
    activeProfile = 1,
    profiles = {}
  }

  local idx = math.max(1, math.min(5, tonumber(charStorage.attackBotProfiles.activeProfile) or 1))

  charStorage.attackBotProfiles.profiles[idx] =
    charStorage.attackBotProfiles.profiles[idx] or {
      main = {},
      attacks = {}
    }

  local p = charStorage.attackBotProfiles.profiles[idx]
  p.main = p.main or {}
  p.attacks = p.attacks or {}

  return p
end

local function managerAtkClear()
  local children = managerAttackUI.list:getChildren()
  for i = #children, 1, -1 do
    children[i]:destroy()
  end
end

local function setRowItem(widget, itemId)
  itemId = tonumber(itemId) or 0
  if not widget then return end

  if itemId <= 0 then
    widget:setVisible(false)
    return
  end

  widget:setVisible(true)

  if widget.setItemId then
    widget:setItemId(itemId)
  elseif widget.setItem and Item and Item.create then
    widget:setItem(Item.create(itemId, 1))
  end
end

local function managerAtkName(data)
  if not data then return "-" end

  if data.type == "spell" then
    return tostring(data.spell or "-")
  end

  if data.type == "rune" then
    return "Rune: [" .. tostring(data.id or 0) .. "]"
  end

  return "-"
end

local function managerAtkCooldownText(data)
  local cd = tonumber(data.nextCast) or 0
  if cd > now then
    local left = math.ceil((cd - now) / 1000)
    return tostring(left) .. "s"
  end

  return nil
end

local function managerAtkUpdateRow(row, data)
  local enabled = data and data.enabled == true
  local cdText = managerAtkCooldownText(data)

  row.enabled:setOn(enabled)

  if cdText then
    row.status:setText(cdText)
    row.status:setColor("yellow")
  elseif enabled then
    row.status:setText("ON")
    row.status:setColor("green")
  else
    row.status:setText("OFF")
    row.status:setColor("red")
  end
end


local function managerAtkToggle(index, row)
  local p = managerAtkProfile()
  local atk = p.attacks and p.attacks[index]
  if not atk then return end

  atk.enabled = not (atk.enabled == true)

  managerAtkUpdateRow(row, atk)
  managerAtkSave()

  if type(rebuildAttackList) == "function" then
    rebuildAttackList()
  end
end

local managerRows = {}

local function managerAtkRefresh()
  managerAtkClear()
  managerRows = {}

  local profile = managerAtkProfile()

  for index, attack in ipairs(profile.attacks or {}) do
    local row = setupUI(managerAttackRow, managerAttackUI.list)

    row.name:setText(managerAtkName(attack))

    if attack.type == "rune" then
      setRowItem(row.icon, attack.id)
      row.name:setMarginLeft(5)
    else
      setRowItem(row.icon, 0)
      row.icon:setVisible(false)
      row.name:setMarginLeft(-15)
    end

    managerAtkUpdateRow(row, attack)

    local tip =
      "Distance: " .. tostring(attack.distance or 1) ..
      "\nMobs: " .. tostring(attack.mobs or 1) ..
      "\nSafe: " .. ((attack.safe and "Yes") or "No")

    row:setTooltip(tip)
    row.enabled:setTooltip(tip)
    row.icon:setTooltip(tip)
    row.name:setTooltip(tip)
    row.status:setTooltip(tip)

    local function clickLine()
      managerAtkToggle(index, row)
    end

    row.onClick = clickLine
    row.enabled.onClick = clickLine
    row.icon.onClick = clickLine
    row.name.onClick = clickLine
    row.status.onClick = clickLine

    table.insert(managerRows, {
      row = row,
      index = index
    })
  end
  lastManagerAttackCount = #(profile.attacks or {})
end

local function managerAtkUpdateCooldowns()
  local p = managerAtkProfile()

  for _, data in ipairs(managerRows) do
    local atk = p.attacks and p.attacks[data.index]
    if data.row and atk then
      managerAtkUpdateRow(data.row, atk)
    end
  end
end

local function managerAtkApplyPos()
  local p = charStorage[panelName].managerAttackbotPos

  managerAttackUI:breakAnchors()

  if not p or not p.x or not p.y or (p.x == 0 and p.y == 0) then
    managerAttackUI:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
    managerAttackUI:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
    managerAttackUI:setMarginTop(80)
    return
  end

  managerAttackUI:setPosition({ x = p.x, y = p.y })
end

local function managerAtkSavePos()
  local p = managerAttackUI:getPosition()
  if not p then return end

  charStorage[panelName].managerAttackbotPos = {
    x = p.x,
    y = p.y
  }

  saveHudChar()
end

managerAttackUI.onDragEnter = function(widget, mousePos)
  widget:breakAnchors()
  widget.movingReference = {
    x = mousePos.x - widget:getX(),
    y = mousePos.y - widget:getY()
  }

  return true
end

managerAttackUI.onDragMove = function(widget, mousePos)
  local parent = widget:getParent()
  if not parent or not parent.getRect then return true end

  local r = parent:getRect()
  local ref = widget.movingReference or { x = 0, y = 0 }

  local x = mousePos.x - ref.x
  local y = mousePos.y - ref.y

  x = math.min(math.max(r.x, x), r.x + r.width - widget:getWidth())
  y = math.min(math.max(r.y, y), r.y + r.height - widget:getHeight())

  widget:move(x, y)
  return true
end

managerAttackUI.onDragLeave = function()
  managerAtkSavePos()
  return true
end

managerAtkApplyPos()
managerAtkRefresh()

local managerNormalHeight = 160
local managerMinimizedHeight = 25

local function managerAtkSetMinimized(state)
  state = state == true

  charStorage[panelName].managerAttackbotMinimized = state

  if state then
    managerNormalHeight = managerAttackUI:getHeight() > managerMinimizedHeight and managerAttackUI:getHeight() or managerNormalHeight

    if managerAttackUI.list then managerAttackUI.list:hide() end
    if managerAttackUI.scroll then managerAttackUI.scroll:hide() end
    if managerAttackUI.title then managerAttackUI.title:hide() end

    managerAttackUI:setHeight(managerMinimizedHeight)
  else
    managerAttackUI:setHeight(managerNormalHeight)

    if managerAttackUI.list then managerAttackUI.list:show() end
    if managerAttackUI.scroll then managerAttackUI.scroll:show() end
    if managerAttackUI.title then managerAttackUI.title:hide() end

    managerAtkRefresh()
  end

  managerAtkSave()
end

schedule(100, function()
  managerAtkSetMinimized(charStorage[panelName].managerAttackbotMinimized == true)
end)

local miniScroll = managerAttackUI:getChildById("miniwindowScrollBar")
if miniScroll then miniScroll:hide() end

if managerAttackUI.closeButton then
  managerAttackUI.closeButton:hide()
end

if managerAttackUI.lockButton then
  managerAttackUI.lockButton:hide()
end

if managerAttackUI.minimizeButton then
  managerAttackUI.minimizeButton:setMarginRight(-13)
  managerAttackUI.minimizeButton.onClick = function()
    managerAtkSetMinimized(not (charStorage[panelName].managerAttackbotMinimized == true))
  end
end

macro(300, function()
  if not hudSwitchOn("comboManager") then
    if managerAttackUI:isVisible() then
      managerAttackUI:hide()
    end
    return
  end

  if not managerAttackUI:isVisible() then
    managerAttackUI:show()
    managerAtkApplyPos()
    managerAtkSetMinimized(charStorage[panelName].managerAttackbotMinimized == true)

    if not charStorage[panelName].managerAttackbotMinimized then
      managerAtkRefresh()
    end
  end

  if not charStorage[panelName].managerAttackbotMinimized then
    managerAtkUpdateCooldowns()
  end
end)

local lastManagerAttackCount = 0

macro(1000, function()
  if not managerAttackUI:isVisible() then return end
  if charStorage[panelName].managerAttackbotMinimized then return end

  local p = managerAtkProfile()
  local count = #(p.attacks or {})

  if count ~= lastManagerAttackCount then
    lastManagerAttackCount = count
    managerAtkRefresh()
  else
    managerAtkUpdateCooldowns()
  end
end)

macro(300, function()
  if type(LNS_SET_BOSS_WINDOW_VISIBLE) ~= "function" then return end

  LNS_SET_BOSS_WINDOW_VISIBLE(hudSwitchOn("autoBoss") == true)
end)
end)

lnsRunBlock("WAR", function()
  setDefaultTab("Cave")
  setDefaultTab("Target")
  setDefaultTab("War")

UI.Separator():setMarginTop(0)
if not loadCharStorage or not saveCharStorage then
  return print("[War Scripts] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function saveComboLeaderChar()
  saveCharStorage(charStorage)
end

local function trimText(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local switchComboLeader = "comboLeaderButton"
charStorage[switchComboLeader] = charStorage[switchComboLeader] or { enabled = false }

charStorage.comboLeaderPanel = charStorage.comboLeaderPanel or {
  lider1 = "",
  lider2 = "",
  lider3 = "",
  lider4 = "",
  liderCommand = false,
  selectChat = "Default"
}

local comboLeaderCfg = charStorage.comboLeaderPanel

comboLeaderButton = setupUI([[
Panel
  height: 19
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Multi Leader
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
comboLeaderButton:setId(switchComboLeader)
comboLeaderButton.title:setOn(charStorage[switchComboLeader].enabled)

comboLeaderButton.title.onClick = function(widget)
  local state = not widget:isOn()
  widget:setOn(state)
  charStorage[switchComboLeader].enabled = state
  saveComboLeaderChar()
end

comboLeader = setupUI([=[
MainWindow
  id: mainPanel
  size: 250 320
  text: Panel Multi Leader
  margin-top: -50

  FlatPanel
    id: flatp
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin: -6
    margin-top: 0
    margin-bottom: 20

    Label
      id: info
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 5
      margin-right: 0
      text-wrap: true
      text-auto-resize: true
      text: "[BR]: Insira o nome dos lideres em ordem de prioridade para seguir o target.\n\n[EN]: Enter the names of the leaders in order of priority to follow the tgt."

    HorizontalSeparator
      id: hsep
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 4
      margin-right: 4

    TextEdit
      id: lider1
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      placeholder: Insert Leader Name 1

    TextEdit
      id: lider2
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      placeholder: Insert Leader Name 2
    
    TextEdit
      id: lider3
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      placeholder: Insert Leader Name 3

    TextEdit
      id: lider4
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      placeholder: Insert Leader Name 4

    HorizontalSeparator
      id: hsep
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 4
      margin-right: 4

    BotSwitch
      id: liderCommand
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.bottom: parent.bottom
      margin-bottom: 6
      margin-top: 4
      width: 70
      text-wrap: true
      text-auto-resize: true
      text: Leader Command
      tooltip: Use this to send the attack command in the chat defined to the side (for knights or monks only).
      $on:
        image-color: green
        color: white

      $!on:
        image-color: red
        color: white

    Label
      id: channel
      anchors.top: prev.top
      anchors.left: prev.right
      margin-left: 5
      margin-top: -1
      text: Channel to send attack:

    ComboBox
      id: selectChat
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: parent.right
      margin-top: 1
      margin-right: 4
      height: 20
      @onSetup: |
        self:addOption("Default")
        self:addOption("Party Channel")
      
  Button
    id: closePanel
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    size: 35 20
    margin-top: 6
    text: Close
]=], g_ui.getRootWidget())
comboLeader:hide()

local function W(parent, id)
  if not parent then return nil end
  return (parent.getChildById and parent:getChildById(id)) or
         (parent.recursiveGetChildById and parent:recursiveGetChildById(id))
end

local leader1 = W(comboLeader, "lider1")
local leader2 = W(comboLeader, "lider2")
local leader3 = W(comboLeader, "lider3")
local leader4 = W(comboLeader, "lider4")
local liderCommand = W(comboLeader, "liderCommand")
local selectChat = W(comboLeader, "selectChat")
local closePanel = W(comboLeader, "closePanel")

local loadingComboLeaderFields = false

local function loadComboLeaderFields()
  loadingComboLeaderFields = true

  if leader1 then leader1:setText(comboLeaderCfg.lider1 or "") end
  if leader2 then leader2:setText(comboLeaderCfg.lider2 or "") end
  if leader3 then leader3:setText(comboLeaderCfg.lider3 or "") end
  if leader4 then leader4:setText(comboLeaderCfg.lider4 or "") end

  if liderCommand and liderCommand.setOn then
    liderCommand:setOn(comboLeaderCfg.liderCommand == true)
  end

  if selectChat and selectChat.setOption then
    selectChat:setOption(comboLeaderCfg.selectChat or "Default")
  end

  loadingComboLeaderFields = false
end

local function saveComboLeaderFields()
  if loadingComboLeaderFields then return end

  comboLeaderCfg.lider1 = trimText(leader1 and leader1:getText() or "")
  comboLeaderCfg.lider2 = trimText(leader2 and leader2:getText() or "")
  comboLeaderCfg.lider3 = trimText(leader3 and leader3:getText() or "")
  comboLeaderCfg.lider4 = trimText(leader4 and leader4:getText() or "")
  comboLeaderCfg.liderCommand = liderCommand and liderCommand:isOn() or false
  comboLeaderCfg.selectChat = selectChat and selectChat:getCurrentOption().text or "Default"

  saveComboLeaderChar()
end

comboLeaderButton.settings.onClick = function()
  loadComboLeaderFields()
  if not comboLeader:isVisible() then
    comboLeader:show()
    comboLeader:raise()
    comboLeader:focus()
  end
end

if closePanel then
  closePanel.onClick = function()
    saveComboLeaderFields()
    comboLeader:hide()
  end
end

if leader1 then
  leader1.onTextChange = function()
    saveComboLeaderFields()
  end
end

if leader2 then
  leader2.onTextChange = function()
    saveComboLeaderFields()
  end
end

if leader3 then
  leader3.onTextChange = function()
    saveComboLeaderFields()
  end
end

if leader4 then
  leader4.onTextChange = function()
    saveComboLeaderFields()
  end
end

if selectChat then
  selectChat.onOptionChange = function(widget, optionText)
    if loadingComboLeaderFields then return end
    comboLeaderCfg.selectChat = optionText
    saveComboLeaderChar()
  end
end

if liderCommand then
  liderCommand:setOn(comboLeaderCfg.liderCommand == true)

  liderCommand.onClick = function(widget)
    if loadingComboLeaderFields then return end
    comboLeaderCfg.liderCommand = not comboLeaderCfg.liderCommand
    widget:setOn(comboLeaderCfg.liderCommand)
    saveComboLeaderChar()
  end
end

loadComboLeaderFields()

local function lowerTrim(s)
  return trimText(s):lower()
end

local function getMultiLeaderPriority()
  return {
    lowerTrim(comboLeaderCfg.lider1),
    lowerTrim(comboLeaderCfg.lider2),
    lowerTrim(comboLeaderCfg.lider3),
    lowerTrim(comboLeaderCfg.lider4)
  }
end

local function getLeaderOnScreenByPriority()
  local leaders = getMultiLeaderPriority()
  local specs = getSpectators(false) or {}

  for i = 1, #leaders do
    local leaderName = leaders[i]
    if leaderName ~= "" then
      for _, creature in ipairs(specs) do
        if creature and creature:isPlayer() and lowerTrim(creature:getName()) == leaderName then
          return leaderName, creature
        end
      end
    end
  end

  return "", nil
end

local function getAttackLeaderName()
  local leaderName = getLeaderOnScreenByPriority()
  return leaderName or ""
end

onMissle(function(missle)
  if not charStorage[switchComboLeader] or not charStorage[switchComboLeader].enabled then return end

  local leaderName, leaderCreature = getLeaderOnScreenByPriority()
  if leaderName == "" or not leaderCreature then return end

  local src = missle:getSource()
  if not src or src.z ~= posz() then return end

  local from = g_map.getTile(src)
  local to = g_map.getTile(missle:getDestination())
  if not from or not to then return end

  local fromCreatures = from:getCreatures()
  local toCreatures = to:getCreatures()
  if #fromCreatures ~= 1 or #toCreatures ~= 1 then return end

  local attacker = fromCreatures[1]
  local target = toCreatures[1]

  if not attacker or not target then return end
  if lowerTrim(attacker:getName()) ~= leaderName then return end
  if lowerTrim(target:getName()) == leaderName then return end

  local currentTarget = g_game.getAttackingCreature()
  if not currentTarget or currentTarget ~= target then
    g_game.attack(target)
  end
end)

local function decodeTargetId(text)
  local digits = (text or ""):gsub("%D", "")
  if digits == "" then return nil end
  return tonumber(digits)
end

local function sendAttackCommand(target)
  if not target then return end

  local msg = "ATACAR: " .. encodeTargetId(target:getId())

  if comboLeaderCfg.selectChat == "Party Channel" then
    sayChannel(1, msg)
  else
    say(msg)
  end
end

onTalk(function(name, level, mode, text, channelId, pos)
  if not charStorage[switchComboLeader] or not charStorage[switchComboLeader].enabled then return end
  if not comboLeaderCfg.liderCommand then return end

  local leaderName = getAttackLeaderName()
  if leaderName == "" then return end
  if lowerTrim(name) ~= leaderName then return end

  if comboLeaderCfg.selectChat == "Party Channel" and channelId ~= 1 then
    return
  end

  if not text or not text:find("ATACAR:", 1, true) then return end

  local id = decodeTargetId(text)
  if not id then return end

  local target = getCreatureById(id)
  if not target then return end
  if target:getPosition().z ~= posz() then return end
  if g_game.getAttackingCreature() == target then return end

  g_game.attack(target)
end)

---------------------------------
------ MWSYSTEM
---------------------------------
charStorage = charStorage or loadCharStorage()

local MW_STORAGE = "holdMwWgPanel"

charStorage[MW_STORAGE] = charStorage[MW_STORAGE] or {
  enabled = false,

  mwRune = 3180,
  mwWall1 = 2129,
  mwWall2 = 16518,

  wgRune = 3156,
  wgWall1 = 2130,

  holdMw = false,
  holdWg = false,
  mwFront = false,
  mwBack = false,
  mwTrap = false,
  pause = false,

  -- usado pelo icone unico Hold MW/WG
  iconHoldMwWg = false,

  keyHoldMw = "",
  keyHoldWg = "",
  keyMwFront = "",
  keyMwBack = "",
  keyMwTrap = "",

  tempo = 0
}

local mwCfg = charStorage[MW_STORAGE]

if mwCfg.iconHoldMwWg == nil then
  mwCfg.iconHoldMwWg = false
end

local function saveMwStorage()
  saveCharStorage(charStorage)
end

local function getBotItemId(widget)
  if not widget then return 0 end
  if widget.getItemId then
    return tonumber(widget:getItemId()) or 0
  end
  if widget.getItem then
    local item = widget:getItem()
    if item and item.getId then
      return tonumber(item:getId()) or 0
    end
  end
  return 0
end

local function setBotItemId(widget, id)
  id = tonumber(id) or 0
  if not widget then return end
  if widget.setItemId then
    widget:setItemId(id)
  elseif widget.setItem then
    widget:setItem(id)
  end
end

mwButton = setupUI([[
Panel
  height: 19
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Hold MW/WG
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

mwInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 400 298
  text: Hold MW / WG
  margin-top: -50

  Panel
    anchors.fill: parent
    margin: 5
    margin-left: -3

  FlatPanel
    id: panelMw
    anchors.top: parent.top
    anchors.left: parent.left
    width: 185
    height: 110

    Label
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      margin-top: 5
      text: Magic Wall
      color: #e6d2a6
      text-auto-resize: true
      font: verdana-11px-rounded

    Label
      id: runa1
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 12
      margin-left: 8
      text: Rune:

    BotItem
      id: mwRune
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-right: 8

    Label
      anchors.top: runa1.bottom
      anchors.left: runa1.left
      margin-top: 34
      text: Walls:

    BotItem
      id: mwWall1
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-right: 8

    BotItem
      id: mwWall2
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: mwWall1.left
      margin-right: 4

  FlatPanel
    id: panelWG
    anchors.top: panelMw.bottom
    anchors.left: panelMw.left
    margin-top: 10
    width: 185
    height: 120

    Label
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      margin-top: 5
      text: Wild Growth
      color: #e6d2a6
      text-auto-resize: true
      font: verdana-11px-rounded

    Label
      id: rune2
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 15
      margin-left: 8
      text: Rune:

    BotItem
      id: wgRune
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-right: 8

    Label
      anchors.top: rune2.bottom
      anchors.left: rune2.left
      margin-top: 38
      text: Walls:

    BotItem
      id: wgWall1
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-right: 8

    BotItem
      id: wgWall2
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: wgWall1.left
      margin-right: 4

  FlatPanel
    id: previewPanel
    anchors.top: panelMw.top
    anchors.left: panelMw.right
    anchors.bottom: panelWG.bottom
    margin-left: 10
    width: 180

    BotSwitch
      id: holdMw
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: 8
      margin-left: 5
      size: 30 20
      text: OFF

    Label
      id: labelHoldMw
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      margin-left: 5
      text: Hold MW:

    TextEdit
      id: keyHoldMw
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      anchors.right: parent.right
      margin-left: 15
      margin-right: 5
      placeholder: Key

    BotSwitch
      id: holdWg
      anchors.top: holdMw.bottom
      anchors.left: holdMw.left
      margin-top: 12
      size: 30 20
      text: OFF

    Label
      id: labelHoldWg
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      margin-left: 5
      text: Hold WG:

    TextEdit
      id: keyHoldWg
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      anchors.right: parent.right
      margin-left: 15
      margin-right: 5
      placeholder: Key

    BotSwitch
      id: mwFront
      anchors.top: holdWg.bottom
      anchors.left: holdWg.left
      margin-top: 12
      size: 30 20
      text: OFF

    Label
      id: labelMwFront
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      margin-left: 5
      text: Mw Front:

    TextEdit
      id: keyMwFront
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: keyHoldWg.left
      anchors.right: keyHoldWg.right
      placeholder: Key

    BotSwitch
      id: mwBack
      anchors.top: mwFront.bottom
      anchors.left: mwFront.left
      margin-top: 12
      size: 30 20
      text: OFF

    Label
      id: labelMwBack
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      margin-left: 5
      text: Mw Back:

    TextEdit
      id: keyMwBack
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: keyHoldWg.left
      anchors.right: keyHoldWg.right
      placeholder: Key

    BotSwitch
      id: mwTrap
      anchors.top: mwBack.bottom
      anchors.left: mwBack.left
      margin-top: 12
      size: 30 20
      text: OFF

    Label
      id: labelMwTrap
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      margin-left: 5
      text: Mw Trap:

    TextEdit
      id: keyMwTrap
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: keyHoldWg.left
      anchors.right: keyHoldWg.right
      placeholder: Key

    HorizontalSeparator
      id: sep1
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-left: 5
      margin-right: 5
      margin-top: 9

    Label
      id: remainingTime
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text-align: center
      text: Remaining Time: 0

    HorizontalScrollBar
      id: tempo
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      minimum: 0
      maximum: 3000
      step: 100

    BotSwitch
      id: pause
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Pause to use MW

  Button
    id: closePanel
    anchors.left: panelMw.left
    anchors.right: previewPanel.right
    anchors.top: previewPanel.bottom
    size: 35 20
    margin-top: 5
    text: Close
]=], g_ui.getRootWidget())

mwInterface:hide()

local function bindSwitch(widget, key)
  if not widget then return end
  mwCfg[key] = mwCfg[key] == true
  widget:setOn(mwCfg[key])

  widget.onClick = function(w)
    mwCfg[key] = not mwCfg[key]
    w:setOn(mwCfg[key])
    saveMwStorage()
  end
end

local function bindText(widget, key)
  if not widget then return end
  widget:setText(tostring(mwCfg[key] or ""))

  widget.onTextChange = function(_, text)
    mwCfg[key] = tostring(text or "")
    saveMwStorage()
  end
end

local function bindBotItem(widget, key, defaultId)
  if not widget then return end

  mwCfg[key] = tonumber(mwCfg[key]) or tonumber(defaultId) or 0
  setBotItemId(widget, mwCfg[key])

  widget.onItemChange = function(w)
    mwCfg[key] = getBotItemId(w)
    saveMwStorage()
  end
end

local function updateTempoLabel(value)
  value = tonumber(value) or 0
  mwInterface.previewPanel.remainingTime:setText("Remaining Time: " .. value .. " ms")
end

mwButton.title:setOn(mwCfg.enabled == true)
mwButton.title.onClick = function(widget)
  mwCfg.enabled = not widget:isOn()
  widget:setOn(mwCfg.enabled)
  saveMwStorage()
end

mwButton.settings.onClick = function()
  if mwInterface:isVisible() then
    mwInterface:hide()
  else
    mwInterface:show()
    mwInterface:raise()
    mwInterface:focus()
  end
end

mwInterface.closePanel.onClick = function()
  mwInterface:hide()
end

bindBotItem(mwInterface.panelMw.mwRune, "mwRune", 3180)
bindBotItem(mwInterface.panelMw.mwWall1, "mwWall1", 2129)
bindBotItem(mwInterface.panelMw.mwWall2, "mwWall2", 2128)

bindBotItem(mwInterface.panelWG.wgRune, "wgRune", 3156)
bindBotItem(mwInterface.panelWG.wgWall1, "wgWall1", 2130)
bindBotItem(mwInterface.panelWG.wgWall2, "wgWall2", 0)

bindSwitch(mwInterface.previewPanel.holdMw, "holdMw")
bindSwitch(mwInterface.previewPanel.holdWg, "holdWg")
bindSwitch(mwInterface.previewPanel.mwFront, "mwFront")
bindSwitch(mwInterface.previewPanel.mwBack, "mwBack")
bindSwitch(mwInterface.previewPanel.mwTrap, "mwTrap")
bindSwitch(mwInterface.previewPanel.pause, "pause")

bindText(mwInterface.previewPanel.keyHoldMw, "keyHoldMw")
bindText(mwInterface.previewPanel.keyHoldWg, "keyHoldWg")
bindText(mwInterface.previewPanel.keyMwFront, "keyMwFront")
bindText(mwInterface.previewPanel.keyMwBack, "keyMwBack")
bindText(mwInterface.previewPanel.keyMwTrap, "keyMwTrap")

mwCfg.tempo = tonumber(mwCfg.tempo) or 0
mwInterface.previewPanel.tempo:setValue(mwCfg.tempo)
updateTempoLabel(mwCfg.tempo)

mwInterface.previewPanel.tempo.onValueChange = function(_, value)
  mwCfg.tempo = tonumber(value) or 0
  updateTempoLabel(mwCfg.tempo)
  saveMwStorage()
end

-- =========================================================
-- LNS HOLD MW/WG SYSTEM
-- Painel/Storage usado: mwCfg
-- =========================================================

pauseForMw = pauseForMw or 0

local MW_CAST_COOLDOWN = 200
local MW_KEY_COOLDOWN = 200
local MW_FAIL_COOLDOWN = 100
local HOLD_RECAST_DELAY = 300
local HOLD_ALL_CD = 250
local TRAP_CD = 250
local OWN_WALL_CAST_WINDOW = 3000
local CURSOR_REOPEN_DELAY = 50

local mwLastCast = 0
local mwLastKey = { front = 0, back = 0 }
local mwTileCooldown = {}

local holdPressAt = 0
local holdCandidates = {}
local holdReadyAt = {}
local holdLastCast = 0

local ownWallCasts = {}
local cursorCast = nil
local cursorActiveKind = nil
local cancelCursorCast

local trapCheckPos = nil
local trapMwPos = nil
local lastTrapCast = 0

local mwWgTimers = {}
local pauseTriggeredByTile = {}

local function keyPos(p)
  return p.x .. "," .. p.y .. "," .. p.z
end

local function samePos(a, b)
  return a and b and a.x == b.x and a.y == b.y and a.z == b.z
end

local function wallTextFromRuneId(id)
  id = tonumber(id)

  if id == tonumber(mwCfg.mwRune) then
    return "MW Here"
  end

  if id == tonumber(mwCfg.wgRune) then
    return "WG Here"
  end

  return nil
end

local function wallTextFromWallId(id)
  id = tonumber(id)

  if id == tonumber(mwCfg.mwWall1) or id == tonumber(mwCfg.mwWall2) or id == 16518 or id == 2128 then
    return "MW Here"
  end

  if id == tonumber(mwCfg.wgWall1) or id == tonumber(mwCfg.wgWall2) then
    return "WG Here"
  end

  return nil
end

local function cleanOwnWallCasts()
  for k, data in pairs(ownWallCasts) do
    if not data or (data.expires or 0) < now then
      ownWallCasts[k] = nil
    end
  end
end

local function registerOwnWallCast(pos, runeId)
  if not pos then return end

  local text = wallTextFromRuneId(runeId)
  if not text then return end

  cleanOwnWallCasts()

  ownWallCasts[keyPos(pos)] = {
    text = text,
    expires = now + OWN_WALL_CAST_WINDOW
  }
end

local function takeOwnWallCast(pos, wallId)
  if not pos then return nil end

  local k = keyPos(pos)
  local data = ownWallCasts[k]
  if not data then return nil end

  if (data.expires or 0) < now then
    ownWallCasts[k] = nil
    return nil
  end

  local wallText = wallTextFromWallId(wallId)
  if not wallText or wallText ~= data.text then
    return nil
  end

  ownWallCasts[k] = nil
  return wallText
end

local function isSystemOn()
  return mwCfg and mwCfg.enabled == true
end

local function isWallId(id)
  id = tonumber(id)
  return id == tonumber(mwCfg.mwWall1) or id == tonumber(mwCfg.mwWall2) or
         id == tonumber(mwCfg.wgWall1) or id == tonumber(mwCfg.wgWall2) or
         id == 16518 or id == 2128
end

local function hasWall(tile)
  if not tile then return false end
  for _, item in ipairs(tile:getItems() or {}) do
    if item.getId and isWallId(item:getId()) then
      return true
    end
  end
  return false
end

local function inRange(pos)
  local ppos = player:getPosition()
  return ppos and pos and ppos.z == pos.z and math.abs(ppos.x - pos.x) < 8 and math.abs(ppos.y - pos.y) < 6
end

local tryUseRuneOnThing

local function canUseOnTile(pos)
  if not pos or pos.z ~= posz() then return nil end
  if isInPz() then return nil end
  if not inRange(pos) then return nil end

  local tile = g_map.getTile(pos)
  if not tile then return nil end
  if not tile:canShoot() then return nil end
  if tile.isWalkable and not tile:isWalkable() then return nil end
  if hasWall(tile) then return nil end

  local top = tile:getTopUseThing()
  if not top then return nil end

  return tile, top
end

local function useMwAt(pos)
  local tile, top = canUseOnTile(pos)
  if not tile or not top then return false end

  if now - mwLastCast < MW_CAST_COOLDOWN then return false end

  local k = keyPos(tile:getPosition())
  if (mwTileCooldown[k] or 0) > now then return false end

  mwLastCast = now

  local runeId = tonumber(mwCfg.mwRune) or 3180

  if tryUseRuneOnThing(runeId, top) then
    registerOwnWallCast(tile:getPosition(), runeId)
    mwTileCooldown[k] = now + MW_CAST_COOLDOWN
    return true
  end

  mwTileCooldown[k] = now + MW_FAIL_COOLDOWN
  return false
end

-- =========================================================
-- MW FRONT / BACK
-- =========================================================

local function getTargetPosByDir(target, front)
  local tpos = target:getPosition()
  local dir = target:getDirection()
  if not tpos or dir == nil then return nil end

  local dx, dy = 0, 0
  if dir == 0 then dy = -1
  elseif dir == 1 then dx = 1
  elseif dir == 2 then dy = 1
  elseif dir == 3 then dx = -1 end

  if not front then
    dx, dy = -dx, -dy
  end

  return {x = tpos.x + dx, y = tpos.y + dy, z = tpos.z}, dir
end

local function getSpread(base, dir)
  local list = {base}

  if dir == 0 or dir == 2 then
    table.insert(list, {x = base.x - 1, y = base.y, z = base.z})
    table.insert(list, {x = base.x + 1, y = base.y, z = base.z})
  else
    table.insert(list, {x = base.x, y = base.y - 1, z = base.z})
    table.insert(list, {x = base.x, y = base.y + 1, z = base.z})
  end

  return list
end

local function castMwFrontBack(front)
  local target = g_game.getAttackingCreature()
  if not target then return end

  local tpos = target:getPosition()
  if not tpos or tpos.z ~= posz() then return end

  local base, dir = getTargetPosByDir(target, front)
  if not base then return end

  for _, p in ipairs(getSpread(base, dir)) do
    if useMwAt(p) then return true end
  end
end

local function executeMwFrontBack(front)
  if not isSystemOn() then return false end

  local mode = front and "front" or "back"
  if now - (mwLastKey[mode] or 0) < MW_KEY_COOLDOWN then return false end

  mwLastKey[mode] = now
  return castMwFrontBack(front) == true
end

-- API para outros scripts/ícones chamarem
LNS_MWSystem = LNS_MWSystem or {}
LNS_MWSystem.mwFront = function()
  return executeMwFrontBack(true)
end
LNS_MWSystem.mwBack = function()
  return executeMwFrontBack(false)
end
LNS_MWSystem.castFront = LNS_MWSystem.mwFront
LNS_MWSystem.castBack = LNS_MWSystem.mwBack


onKeyPress(function(keys)
  local key = tostring(keys or ""):lower()
  if key == "" then return end

  local frontKey = tostring(mwCfg.keyMwFront or ""):lower()
  local backKey = tostring(mwCfg.keyMwBack or ""):lower()

  local isFront = mwCfg.mwFront == true and frontKey ~= "" and key == frontKey
  local isBack = mwCfg.mwBack == true and backKey ~= "" and key == backKey

  if not isFront and not isBack then return end

  executeMwFrontBack(isFront)
end)

-- =========================================================
-- HOLD MW / WG
-- =========================================================

local function holdEnabled()
  return isSystemOn() and (mwCfg.holdMw == true or mwCfg.holdWg == true)
end

local function getRuneByText(text)
  if text == "MW Here" and mwCfg.holdMw == true then
    return tonumber(mwCfg.mwRune) or 3180
  end

  if text == "WG Here" and mwCfg.holdWg == true then
    return tonumber(mwCfg.wgRune) or 3156
  end

  return nil
end

local function addHoldCandidate(pos)
  if not pos then return end
  for _, p in ipairs(holdCandidates) do
    if samePos(p, pos) then return end
  end
  table.insert(holdCandidates, pos)
end

local function removeHoldCandidate(pos)
  for i = #holdCandidates, 1, -1 do
    if samePos(holdCandidates[i], pos) then
      table.remove(holdCandidates, i)
      return
    end
  end
end

local function clearHoldMarks()
  holdCandidates = {}
  holdReadyAt = {}

  for _, tile in ipairs(g_map.getTiles(posz())) do
    local text = tile:getText() or ""
    if text == "MW Here" or text == "WG Here" then
      tile:setText("")
    end
  end
end

local function setMwUiSwitch(widget, state)
  if widget and widget.setOn then
    widget:setOn(state == true)
  end
end

local function refreshMwHoldButtons()
  if mwButton and mwButton.title then
    setMwUiSwitch(mwButton.title, mwCfg.enabled == true)
  end

  if mwInterface and mwInterface.previewPanel then
    setMwUiSwitch(mwInterface.previewPanel.holdMw, mwCfg.holdMw == true)
    setMwUiSwitch(mwInterface.previewPanel.holdWg, mwCfg.holdWg == true)
  end
end

local function setHoldMwWgIcon(state)
  state = state == true
  mwCfg.iconHoldMwWg = state

  if state then
    mwCfg.enabled = true
    mwCfg.holdMw = true
    mwCfg.holdWg = true
  else
    mwCfg.holdMw = false
    mwCfg.holdWg = false
    clearHoldMarks()
    if type(cancelCursorCast) == "function" then
      cancelCursorCast()
    end
  end

  refreshMwHoldButtons()
  saveMwStorage()
  return mwCfg.iconHoldMwWg == true
end

local function isHoldMwWgIconOn()
  return mwCfg.iconHoldMwWg == true
end

local function wallTextById(id)
  return wallTextFromWallId(id)
end

local function mwLater(ms, fn)
  if type(schedule) == "function" then return schedule(ms, fn) end
  if type(scheduleEvent) == "function" then return scheduleEvent(fn, ms) end
  if g_dispatcher and type(g_dispatcher.scheduleEvent) == "function" then return g_dispatcher:scheduleEvent(fn, ms) end
  return fn()
end

local function showMwMessage(text)
  if modules and modules.game_textmessage and type(modules.game_textmessage.displayGameMessage) == "function" then
    modules.game_textmessage.displayGameMessage(text)
  elseif type(warn) == "function" then
    warn(text)
  end
end

tryUseRuneOnThing = function(runeId, thing)
  runeId = tonumber(runeId)
  if not runeId or not thing then return false end

  -- Caminho principal: usa o useWith padrao do vBot/OTC pelo ID da runa.
  -- Esse e o jeito mais compativel para BP aberta/fechada em clients que ja resolvem itemId internamente.
  if type(useWith) == "function" then
    local ok, ret = pcall(function()
      return useWith(runeId, thing)
    end)

    -- Alguns OTCs retornam nil/false mesmo enviando a acao para o servidor.
    -- Entao aqui so tratamos erro real de pcall como falha.
    if ok then return true end
  end

  -- Fallback por ID do client, quando existir.
  if g_game and type(g_game.useInventoryItemWith) == "function" then
    local ok = pcall(function()
      g_game.useInventoryItemWith(runeId, thing)
    end)
    if ok then return true end
  end

  return false
end

local scriptCursorVisualOn = false

local function setScriptCursorVisual(state)
  state = state == true

  if state and scriptCursorVisualOn then return end
  if not state and not scriptCursorVisualOn then return end

  if state then
    scriptCursorVisualOn = true

    -- Apenas visual. Nao usa Item.create/startUseWith falso, porque isso pode debuggar o client.
    if g_mouse and type(g_mouse.pushCursor) == "function" then
      pcall(function() g_mouse.pushCursor("target") end)
      return
    end

    if g_window and type(g_window.setMouseCursor) == "function" then
      pcall(function() g_window.setMouseCursor("/cursors/crosshair") end)
      return
    end

    return
  end

  scriptCursorVisualOn = false

  if g_mouse and type(g_mouse.popCursor) == "function" then
    pcall(function() g_mouse.popCursor() end)
    return
  end

  if g_window and type(g_window.restoreMouseCursor) == "function" then
    pcall(function() g_window.restoreMouseCursor() end)
    return
  end
end

local handleCursorMapTile = nil
local lastCursorMapClick = { at = 0, key = "" }
local cursorMouseDown = false
local cursorMouseDownAt = 0
local cursorMouseDownPos = nil

local function isLeftCursorButton(button)
  if button == nil then return false end

  if MouseLeftButton ~= nil and button == MouseLeftButton then
    return true
  end

  if button == 1 or button == 0 then
    return true
  end

  local s = tostring(button):lower()
  return s == "left" or s == "mouseleftbutton" or s == "mouseleft" or s == "1" or s == "0"
end

local function cursorMouseMovedTooMuch(a, b)
  if not a or not b then return false end
  local dx = math.abs((a.x or 0) - (b.x or 0))
  local dy = math.abs((a.y or 0) - (b.y or 0))
  return dx > 14 or dy > 14
end

local function callOldMapMouse(widget, mousePos, button, oldFn)
  if type(oldFn) == "function" then
    local ok, ret = pcall(oldFn, widget, mousePos, button)
    if ok then return ret end
  end
  return false
end

local function restoreOldCursorMapHook()
  cursorMouseDown = false
  cursorMouseDownAt = 0
  cursorMouseDownPos = nil

  local panel = modules.game_interface and modules.game_interface.gameMapPanel
  if not panel then return end

  if panel.lnsMwCursorOldMousePress then
    panel.onMousePress = panel.lnsMwCursorOldMousePress
    panel.lnsMwCursorOldMousePress = nil
  end

  if panel.lnsMwCursorOldMouseRelease then
    panel.onMouseRelease = panel.lnsMwCursorOldMouseRelease
    panel.lnsMwCursorOldMouseRelease = nil
  end

  panel.lnsMwCursorHooked = nil
end

local function installCursorMapHook()
  local panel = modules.game_interface and modules.game_interface.gameMapPanel
  if not panel then return false end
  if panel.lnsMwCursorHooked then return true end

  panel.lnsMwCursorOldMousePress = panel.onMousePress
  panel.lnsMwCursorOldMouseRelease = panel.onMouseRelease
  panel.lnsMwCursorHooked = true

  panel.onMousePress = function(widget, mousePos, button)
    if cursorCast and cursorActiveKind and isLeftCursorButton(button) then
      cursorMouseDown = true
      cursorMouseDownAt = now
      cursorMouseDownPos = mousePos and { x = mousePos.x, y = mousePos.y } or nil
      return true
    end

    return callOldMapMouse(widget, mousePos, button, widget.lnsMwCursorOldMousePress)
  end

  panel.onMouseRelease = function(widget, mousePos, button)
    if cursorCast and cursorActiveKind and isLeftCursorButton(button) then
      local validClick = cursorMouseDown == true
        and now - (cursorMouseDownAt or 0) <= 1500
        and not cursorMouseMovedTooMuch(cursorMouseDownPos, mousePos)

      cursorMouseDown = false
      cursorMouseDownAt = 0
      cursorMouseDownPos = nil

      if validClick and handleCursorMapTile and handleCursorMapTile(mousePos, button) then
        return true
      end

      return true
    end

    return callOldMapMouse(widget, mousePos, button, widget.lnsMwCursorOldMouseRelease)
  end

  return true
end

restoreOldCursorMapHook()

local function stopNativeCrosshair()
  restoreOldCursorMapHook()
  setScriptCursorVisual(false)

  if modules and modules.game_interface and type(modules.game_interface.stopUseWith) == "function" then
    pcall(function() modules.game_interface.stopUseWith() end)
    return
  end

  if g_game and type(g_game.cancelUse) == "function" then
    pcall(function() g_game.cancelUse() end)
  end
end

cancelCursorCast = function()
  cursorCast = nil
  cursorActiveKind = nil
  stopNativeCrosshair()
end

local function startNativeCrosshair(runeId)
  runeId = tonumber(runeId)
  if not runeId then return false end

  local openedNative = false

  -- Se a runa estiver visivel, abre o cursor nativo real e NAO instala hook no mapa.
  -- Isso evita marcar tile por movimento/hover e deixa o client cuidar do clique normal.
  if type(findItem) == "function" and modules and modules.game_interface and type(modules.game_interface.startUseWith) == "function" then
    local item = nil
    local okFind, found = pcall(function() return findItem(runeId) end)
    if okFind then item = found end

    if item then
      local okStart = pcall(function() modules.game_interface.startUseWith(item) end)
      openedNative = okStart == true
    end
  end

  if openedNative then
    restoreOldCursorMapHook()
    setScriptCursorVisual(false)
    return true
  end

  -- Se a runa nao estiver visivel, ai sim entra o cursor seguro da script.
  -- Ele so executa no CLIQUE esquerdo real, tratado no onMouseRelease.
  if installCursorMapHook() then
    setScriptCursorVisual(true)
    return true
  end

  return false
end

local function getCursorRuneId(kind)
  if kind == "mw" then
    return tonumber(mwCfg.mwRune) or 3180
  end

  if kind == "wg" then
    return tonumber(mwCfg.wgRune) or 3156
  end

  return nil
end

local function isCursorKindActive(kind)
  return cursorActiveKind == kind
end

local function reopenActiveCursor(kind)
  kind = kind or cursorActiveKind
  if not kind or cursorActiveKind ~= kind then return end
  if mwCfg.iconHoldMwWg ~= true then return end

  local runeId = getCursorRuneId(kind)
  if not runeId then return end

  cursorCast = {
    kind = kind,
    runeId = runeId
  }

  startNativeCrosshair(runeId)
end

local function activateCursorCast(kind)
  if not isSystemOn() then
    mwCfg.enabled = true
    refreshMwHoldButtons()
    saveMwStorage()
  end

  if mwCfg.iconHoldMwWg ~= true then
    showMwMessage("Ligue o icone Hold MW/WG antes de usar o cursor.")
    return false
  end

  local runeId = getCursorRuneId(kind)
  if not runeId then return false end

  -- clique no mesmo cursor = desliga. Clique no outro = troca MW <-> WG.
  if cursorActiveKind == kind then
    cancelCursorCast()
    return false
  end

  cursorActiveKind = kind
  cursorCast = {
    kind = kind,
    runeId = runeId
  }

  if not startNativeCrosshair(runeId) then
    cancelCursorCast()
    return false
  end

  return true
end

local function getUseWithTargetPos(pos, target)
  if target and target.getPosition then
    local ok, tpos = pcall(function() return target:getPosition() end)
    if ok and tpos then
      return { x = tpos.x, y = tpos.y, z = tpos.z }
    end
  end

  if type(pos) == "table" and pos.x and pos.y and pos.z then
    return { x = pos.x, y = pos.y, z = pos.z }
  end

  return nil
end

local function markCursorHoldTile(pos, runeId)
  if not pos then return end

  local text = wallTextFromRuneId(runeId)
  if not text then return end

  registerOwnWallCast(pos, runeId)

  local tile = g_map.getTile(pos)
  if tile then
    tile:setText(text)
  end

  addHoldCandidate(pos)
  holdReadyAt[keyPos(pos)] = now + 1200
end

handleCursorMapTile = function(mousePos, button)
  if not cursorCast or not cursorActiveKind then return false end
  if not isLeftCursorButton(button) then return false end
  if mwCfg.iconHoldMwWg ~= true then return false end

  local tile = getTileUnderCursor()
  if not tile then return true end

  local pos = tile:getPosition()
  if not pos then return true end

  local clickKey = keyPos(pos)
  if lastCursorMapClick.key == clickKey and now - (lastCursorMapClick.at or 0) < 120 then
    return true
  end

  lastCursorMapClick.key = clickKey
  lastCursorMapClick.at = now

  local runeId = tonumber(cursorCast.runeId)
  if not runeId then return true end

  local _, top = canUseOnTile(pos)
  if not top then return true end

  markCursorHoldTile(pos, runeId)
  tryUseRuneOnThing(runeId, top)

  -- Como o cursor fica ligado, reforca o crosshair visual apos cada clique.
  local activeKind = cursorActiveKind
  mwLater(CURSOR_REOPEN_DELAY, function()
    reopenActiveCursor(activeKind)
  end)

  return true
end

onUseWith(function(pos, itemId, target, subType)
  if not cursorCast or not cursorActiveKind then return end

  itemId = tonumber(itemId)
  if not itemId or itemId ~= tonumber(cursorCast.runeId) then return end

  local activeKind = cursorActiveKind
  local tpos = getUseWithTargetPos(pos, target)
  if tpos then
    markCursorHoldTile(tpos, itemId)
  end

  -- Se o client disparar onUseWith pelo cursor nativo, ele ja tentou o uso normal.
  -- Nao fazemos outro use aqui para evitar double-use/debug. O hook proprio do mapa ja resolve o modo sem runa visivel.

  -- Mantem o cursor ligado: depois de cada clique no mapa, abre o cursor de novo.
  mwLater(CURSOR_REOPEN_DELAY, function()
    reopenActiveCursor(activeKind)
  end)
end)

LNS_MWSystem.isHoldMwWg = function()
  return isHoldMwWgIconOn()
end

LNS_MWSystem.setHoldMwWg = function(state)
  return setHoldMwWgIcon(state == true)
end

LNS_MWSystem.toggleHoldMwWg = function()
  return setHoldMwWgIcon(not isHoldMwWgIconOn())
end

LNS_MWSystem.cursorMw = function()
  return activateCursorCast("mw")
end

LNS_MWSystem.cursorWg = function()
  return activateCursorCast("wg")
end

LNS_MWSystem.stopCursor = function()
  cancelCursorCast()
  return true
end

LNS_MWSystem.isCursorMw = function()
  return isCursorKindActive("mw")
end

LNS_MWSystem.isCursorWg = function()
  return isCursorKindActive("wg")
end

LNS_MWSystem.isCursorActive = function()
  return cursorActiveKind ~= nil
end

LNS_MWSystem.startCursorMw = LNS_MWSystem.cursorMw
LNS_MWSystem.startCursorWg = LNS_MWSystem.cursorWg


local holdMacro = macro(20, function()
  if not holdEnabled() then return end
  if #holdCandidates == 0 then return end
  if now - holdLastCast < HOLD_ALL_CD then return end

  for i = #holdCandidates, 1, -1 do
    local pos = holdCandidates[i]
    local k = keyPos(pos)

    if (holdReadyAt[k] or 0) > now then
      goto continue
    end

    local tile = g_map.getTile(pos)
    if not tile then
      table.remove(holdCandidates, i)
      goto continue
    end

    local text = tile:getText() or ""
    local rune = getRuneByText(text)

    if not rune then
      table.remove(holdCandidates, i)
      goto continue
    end

    local _, top = canUseOnTile(pos)
    if not top then goto continue end

    holdLastCast = now
    if tryUseRuneOnThing(rune, top) then
      registerOwnWallCast(pos, rune)
      holdReadyAt[k] = now + HOLD_ALL_CD
      return
    end

    holdReadyAt[k] = now + MW_FAIL_COOLDOWN

    ::continue::
  end
end)

onKeyDown(function(keys)
  if not holdEnabled() or holdMacro.isOff() then return end

  local key = tostring(keys or ""):lower()
  local mwKey = tostring(mwCfg.keyHoldMw or ""):lower()
  local wgKey = tostring(mwCfg.keyHoldWg or ""):lower()

  local isMw = mwCfg.holdMw == true and mwKey ~= "" and key == mwKey
  local isWg = mwCfg.holdWg == true and wgKey ~= "" and key == wgKey

  if not isMw and not isWg then return end

  holdPressAt = now

  local tile = getTileUnderCursor()
  if not tile then return end

  local pos = tile:getPosition()
  local text = tile:getText() or ""

  if text == "MW Here" or text == "WG Here" then
    tile:setText("")
    removeHoldCandidate(pos)
    holdReadyAt[keyPos(pos)] = nil
  else
    tile:setText(isMw and "MW Here" or "WG Here")
    addHoldCandidate(pos)
    holdReadyAt[keyPos(pos)] = now
  end
end)

onKeyPress(function(keys)
  if not holdEnabled() or holdMacro.isOff() then return end

  local key = tostring(keys or ""):lower()
  local mwKey = tostring(mwCfg.keyHoldMw or ""):lower()
  local wgKey = tostring(mwCfg.keyHoldWg or ""):lower()

  if key ~= mwKey and key ~= wgKey then return end

  if now - holdPressAt > 1000 then
    clearHoldMarks()
  end
end)

macro(500, function()
  if mwCfg.iconHoldMwWg ~= true then return end

  local changed = false

  if mwCfg.enabled ~= true then
    mwCfg.enabled = true
    changed = true
  end

  if mwCfg.holdMw ~= true then
    mwCfg.holdMw = true
    changed = true
  end

  if mwCfg.holdWg ~= true then
    mwCfg.holdWg = true
    changed = true
  end

  if changed then
    refreshMwHoldButtons()
    saveMwStorage()
  end
end)

-- =========================================================
-- MW TRAP
-- =========================================================

local function isFriendSafe(name)
  if not name then return false end

  if type(isFriend) == "function" and isFriend(name) then
    return true
  end

  if charStorage.playerList and charStorage.playerList.friendList then
    for _, v in ipairs(charStorage.playerList.friendList) do
      if tostring(v):lower() == tostring(name):lower() then
        return true
      end
    end
  end

  local c = getCreatureByName(name)
  if c and c:isPlayer() and c:isPartyMember() then
    return true
  end

  return false
end

local function isEnemyPlayer(creature)
  if not creature or not creature:isPlayer() or creature:isLocalPlayer() then
    return false
  end
  return not isFriendSafe(creature:getName())
end

onKeyDown(function(keys)
  if not isSystemOn() then return end
  if mwCfg.mwTrap ~= true then return end

  local key = tostring(keys or ""):lower()
  local trapKey = tostring(mwCfg.keyMwTrap or ""):lower()

  if key == "" or key ~= trapKey then return end

  local tile = getTileUnderCursor()
  if not tile then return end

  local pos = tile:getPosition()
  local text = tile:getText() or ""

  if text == "Check" or text == "MW Trap" then
    tile:setText("")
    if samePos(pos, trapCheckPos) then trapCheckPos = nil end
    if samePos(pos, trapMwPos) then trapMwPos = nil end
    return
  end

  if not trapCheckPos then
    trapCheckPos = pos
    tile:setText("Check")
    return
  end

  if not trapMwPos then
    trapMwPos = pos
    tile:setText("MW Trap")
    return
  end

  local oldCheckTile = g_map.getTile(trapCheckPos)
  local oldTrapTile = g_map.getTile(trapMwPos)

  if oldCheckTile and oldCheckTile:getText() == "Check" then oldCheckTile:setText("") end
  if oldTrapTile and oldTrapTile:getText() == "MW Trap" then oldTrapTile:setText("") end

  trapCheckPos = pos
  trapMwPos = nil
  tile:setText("Check")
end)

macro(50, function()
  if not isSystemOn() then return end
  if mwCfg.mwTrap ~= true then return end
  if not trapCheckPos or not trapMwPos then return end
  if now - lastTrapCast < TRAP_CD then return end

  for _, spec in ipairs(getSpectators()) do
    if isEnemyPlayer(spec) and samePos(spec:getPosition(), trapCheckPos) then
      local tile = g_map.getTile(trapMwPos)
      if not tile or hasWall(tile) then return end

      local top = tile:getTopUseThing()
      if not top then return end

      local runeId = tonumber(mwCfg.mwRune) or 3180

      if tryUseRuneOnThing(runeId, top) then
        registerOwnWallCast(trapMwPos, runeId)
        lastTrapCast = now
        return
      end
    end
  end
end)

-- =========================================================
-- TIMER PAUSE PARA POT/RUNE
-- NÃO INTERFERE NO HOLD MW/WG
-- Use nas outras macros:
-- if pauseForMw and pauseForMw > now then return end
-- =========================================================

local function getWallDuration(id)
  id = tonumber(id)

  if id == tonumber(mwCfg.mwWall1) or id == tonumber(mwCfg.mwWall2) or id == 16518 or id == 2128 then
    return 20000
  end

  if id == tonumber(mwCfg.wgWall1) or id == tonumber(mwCfg.wgWall2) then
    return 45000
  end

  return 0
end

onAddThing(function(tile, thing)
  if not isSystemOn() then return end
  if not thing or not thing.isItem or not thing:isItem() then return end

  local id = thing:getId()
  local duration = getWallDuration(id)
  if duration <= 0 then return end

  local pos = tile:getPosition()
  local key = keyPos(pos)
  mwWgTimers[key] = now + duration
  pauseTriggeredByTile[key] = nil

  if mwCfg.iconHoldMwWg == true then
    local markText = takeOwnWallCast(pos, id)
    if markText then
      tile:setText(markText)
      addHoldCandidate(pos)
      holdReadyAt[key] = now + duration + HOLD_RECAST_DELAY
    end
  end
end)

onRemoveThing(function(tile, thing)
  if not thing or not thing.isItem or not thing:isItem() then return end
  if not isWallId(thing:getId()) then return end

  local pos = tile:getPosition()
  local key = keyPos(pos)

  mwWgTimers[key] = nil
  pauseTriggeredByTile[key] = nil

  local text = tile:getText() or ""
  if text == "MW Here" or text == "WG Here" then
    addHoldCandidate(pos)
    holdReadyAt[key] = now + HOLD_RECAST_DELAY
  end
end)

macro(50, function()
  if not isSystemOn() then return end
  if mwCfg.pause ~= true then return end

  local pauseTime = tonumber(mwCfg.tempo or 0) or 0
  if pauseTime <= 0 then return end

  for key, expireAt in pairs(mwWgTimers) do
    local remaining = expireAt - now

    if remaining <= 0 then
      mwWgTimers[key] = nil
      pauseTriggeredByTile[key] = nil
    elseif remaining <= pauseTime and not pauseTriggeredByTile[key] then
      pauseTriggeredByTile[key] = true
      pauseForMw = math.max(pauseForMw or 0, now + pauseTime + 500)
    end
  end
end)

onKeyPress(function(keys)
  local key = tostring(keys or ""):lower()
  if key ~= "escape" and key ~= "esc" then return end

  cancelCursorCast()
  clearHoldMarks()

  if trapCheckPos then
    local tile = g_map.getTile(trapCheckPos)
    if tile and tile:getText() == "Check" then
      tile:setText("")
    end
  end

  if trapMwPos then
    local tile = g_map.getTile(trapMwPos)
    if tile and tile:getText() == "MW Trap" then
      tile:setText("")
    end
  end

  trapCheckPos = nil
  trapMwPos = nil
end)
-- ============================================================
--  PUSHMAX
-- ============================================================
charStorage = charStorage or loadCharStorage()

local function savePushMaxChar()
  saveCharStorage(charStorage)
end

charStorage.pvpSystem = charStorage.pvpSystem or {}

charStorage.pvpSystem.pushSystem = charStorage.pvpSystem.pushSystem or {
    enabled = false,
    mode = "marcacao",  -- "marcacao" ou "numpad"
    
    -- Delays
    pushDelay = 1060,
    cancelDelayOnRetreat = false,
    
    -- Runa para items bloqueadores
    runeId = 3188,
    useRune = false,
    blockingItems = {3147, 2595, 2118, 2119, 2120, 2129},
    
    -- Destroy Field (limpar fields no caminho)
    destroyField = {
        enabled = false,
        runeId = 3148,
        fieldItems = {2118, 2122, 105, 2119}
    },
    
    -- Modo Marcacao
    marcacao = {
        hotkey = "F1",
        autoPush = false,
        showMarkers = true
    },
    
    -- Modo Numpad
    numpad = {
        maxDistance = 7,
        autoRetreat = true,
        keys = {
            ["1"] = "Numpad1",
            ["2"] = "Numpad2",
            ["3"] = "Numpad3",
            ["4"] = "Numpad4",
            ["6"] = "Numpad6",
            ["7"] = "Numpad7",
            ["8"] = "Numpad8",
            ["9"] = "Numpad9"
        }
    }
}

local config = charStorage.pvpSystem.pushSystem

local function saveConfig()
    savePushMaxChar()
end

-- Garantir que destroyField existe (compatibilidade com storages antigos)
if not config.destroyField then
    config.destroyField = {
        enabled = false,
        runeId = 3148,
        fieldItems = {2118, 2122, 105, 2119}
    }
    saveConfig()
end

-- Garantir que fieldItems existe
config.destroyField.fieldItems = config.destroyField.fieldItems or {2118, 2122, 105, 2119}

-- Garantir que numpad existe
config.numpad = config.numpad or {}

-- Garantir que numpad.keys existe (compatibilidade)
if not config.numpad.keys then
    config.numpad.keys = {
        ["1"] = "Numpad1",
        ["2"] = "Numpad2",
        ["3"] = "Numpad3",
        ["4"] = "Numpad4",
        ["6"] = "Numpad6",
        ["7"] = "Numpad7",
        ["8"] = "Numpad8",
        ["9"] = "Numpad9"
    }
    saveConfig()
end

-- ============================================================
--  HELPERS
-- ============================================================

local Helpers = {}

function Helpers.showMessage(msg)
    modules.game_textmessage.displayGameMessage(msg)
end

function Helpers.getDistance(pos1, pos2)
    if not pos1 or not pos2 then return 999 end
    return math.max(math.abs(pos1.x - pos2.x), math.abs(pos1.y - pos2.y))
end

function Helpers.isValidTile(tile)
    if not tile then return false end
    local pos = tile:getPosition()
    if not pos or pos.z ~= posz() then return false end
    if not tile:isWalkable() then return false end
    if tile:hasCreature() then return false end
    return true
end

-- ============================================================
--  UI DEFINITIONS
-- ============================================================

g_ui.loadUIFromString([[
ScrollDetector < UIWidget
  focusable: false
  phantom: true

PVPPushScrollBar < Panel
  height: 35
  margin-top: 7

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    
  HorizontalScrollBar
    id: scroll
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 3
    minimum: 10
    maximum: 3000
    step: 10

PVPPushItem < Panel
  height: 40
  margin-top: 7

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.verticalCenter: next.verticalCenter

  BotItem
    id: item
    anchors.top: parent.top
    anchors.right: parent.right

PVPPushTextEdit < Panel
  height: 50
  margin-top: 7

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    
  TextEdit
    id: textEdit
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 5
    text-align: center

PVPPushCheckBox < BotSwitch
  height: 20
  margin-top: 7

PVPModeButton < Button
  height: 35
  margin-top: 7
  font: verdana-11px-rounded

PVPTabPanel < Panel
  margin: 3

  VerticalScrollBar
    id: panelScroll
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    step: 28
    pixels-scroll: true
    image-color: #87CEEB

  ScrollablePanel
    id: panelContent
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-left: 6
    margin-right: 10
    padding: 5
    padding-left: 8
    padding-top: 8
    padding-bottom: 8
    vertical-scrollbar: panelScroll
    layout:
      type: verticalBox
      spacing: 5

PVPKeysWindow < MainWindow
  size: 245 230
  border: 1 black
  anchors.centerIn: parent
  margin-top: -60

  FlatPanel
    id: content
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin: -6
    margin-top: 1
    margin-bottom: 0

    Label
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      id: configureKeys
      margin-top: 5
      margin-left: 8
      margin-right: 8
      text-align: center
      text: Settings to Push:

    TextEdit
      id: NW
      anchors.top: prev.bottom
      anchors.left: prev.left
      margin-top: 10
      placeholder: NW
      width: 65

    TextEdit
      id: N
      anchors.top: prev.top
      anchors.left: prev.right
      margin-top: 0
      margin-left: 10
      placeholder: N
      width: 65
      
    TextEdit
      id: NE
      anchors.top: prev.top
      anchors.left: prev.right
      margin-top: 0
      margin-left: 10
      placeholder: NE
      width: 65

    TextEdit
      id: W
      anchors.top: NW.bottom
      anchors.left: NW.left
      margin-top: 28
      placeholder: W
      width: 65

    TextEdit
      id: E
      anchors.top: NE.bottom
      anchors.left: NE.left
      margin-top: 28
      placeholder: E
      width: 65

    TextEdit
      id: SW
      anchors.top: W.bottom
      anchors.left: NW.left
      margin-top: 28
      placeholder: SW
      width: 65

    TextEdit
      id: S
      anchors.top: W.bottom
      anchors.left: N.left
      margin-top: 28
      placeholder: S
      width: 65
      
    TextEdit
      id: SE
      anchors.top: W.bottom
      anchors.left: NE.left
      margin-top: 28
      placeholder: SE
      width: 65

    Button
      id: saveBtn
      anchors.top: prev.bottom
      anchors.left: SW.left
      size: 105 20
      margin-top: 10
      text: Save

    Button
      id: resetBtn
      anchors.top: prev.top
      anchors.left: prev.right
      margin-top: 0
      margin-left: 3
      size: 105 20
      text: Reset

PVPMainWindow < MainWindow
  size: 315 340
  border: 1 black
  anchors.centerIn: parent
  margin-top: -50
  text: Panel PushMax

  FlatPanel
    id: content
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.left: parent.left
    margin: -5
    margin-top: 2
    height: 140
    layout: verticalBox

  Label
    id: tipoPush
    anchors.top: prev.top
    anchors.left: content.left
    margin-top: 7
    margin-left: 5
    text: Push Type:

  Button
    id: buttonNumpad
    anchors.left: prev.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-left: 5
    size: 70 21
    text: NUMPAD/WASD

  Button
    id: setupTeclas
    anchors.left: prev.right
    anchors.top: prev.top
    margin-top: 0
    margin-left: 2
    text: Cfg
    size: 30 21

  Button
    id: buttonMarcacao
    anchors.left: setupTeclas.right
    anchors.top: buttonNumpad.top
    size: 70 21
    margin-left: 10
    margin-top: 0
    text: Marcacao

  BotTextEdit
    id: pushKeyEdit
    anchors.left: buttonMarcacao.right
    anchors.top: buttonMarcacao.top
    anchors.right: content.right
    margin-right: 5
    margin-left: 2
    height: 20
    margin-top: 1
    placeholder: Atalho

  HorizontalSeparator
    id: hsep
    anchors.top: prev.bottom
    anchors.left: content.left
    anchors.right: content.right
    margin-left: 5
    margin-right: 5
    margin-top: 5

  Label
    id: labelDistance
    anchors.top: prev.bottom
    anchors.left: content.left
    anchors.right: content.right
    margin-top: 5

  HorizontalScrollBar
    id: distancePush
    anchors.top: labelDistance.bottom
    anchors.left: content.left
    anchors.right: content.right
    margin-right: 5
    margin-left: 5
    margin-top: 3
    minimum: 1
    maximum: 9
    step: 1

  Label
    id: distanceText
    anchors.centerIn: labelDistance
    text: ""

  Label
    id: labelDelay
    anchors.top: distancePush.bottom
    anchors.left: content.left
    anchors.right: content.right
    margin-top: 8

  HorizontalScrollBar
    id: delayPush
    anchors.top: labelDelay.bottom
    anchors.left: content.left
    anchors.right: content.right
    margin-right: 5
    margin-top: 3
    margin-left: 5
    minimum: 10
    maximum: 2000
    step: 10

  Label
    id: delayText
    anchors.centerIn: labelDelay
    text: ""

  CheckBox
    id: autoAfastar
    anchors.top: delayPush.bottom
    anchors.left: labelDelay.left
    margin-top: 15
    margin-left: 5
    text: Auto Move Away
    text-auto-resize: true

  FlatPanel
    id: panelRunas
    anchors.top: content.bottom
    anchors.right: content.right
    anchors.left: content.left
    margin-top: 10
    height: 130
    layout: verticalBox

  CheckBox
    id: firefield
    anchors.top: panelRunas.top
    anchors.left: autoAfastar.left
    margin-top: 14
    text: Fire Field Rune:
    text-auto-resize: true
    
  BotItem
    id: fireFieldId
    anchors.top: firefield.top
    anchors.left: firefield.right
    margin-top: -7
    margin-left: 140
    image-source: /images/ui/item

  CheckBox
    id: destroyField
    anchors.top: firefield.bottom
    anchors.left: autoAfastar.left
    margin-top: 25
    text: Destroy Field Rune:
    text-auto-resize: true
    
  BotItem
    id: destroyFieldId
    anchors.top: destroyField.top
    anchors.left: fireFieldId.left
    margin-top: -8
    image-source: /images/ui/item

  Panel
    id: destroyFieldList
    anchors.top: destroyFieldId.bottom
    anchors.left: destroyField.left
    anchors.right: panelRunas.right
    anchors.bottom: panelRunas.bottom
    margin-right: 5
    margin-top: 3
    margin-bottom: 5

  Button
    id: closePanel
    anchors.left: content.left
    anchors.right: content.right
    anchors.top: panelRunas.bottom
    size: 35 20
    margin-top: 5
    text: Close
]])

-- ============================================================
--  PAINEL PRINCIPAL
-- ============================================================

mainUI = setupUI([[
Panel
  height: 19

  BotSwitch
    id: switch
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: PushMax
    height: 18
    color: white

  Button
    id: setup
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Config
    opacity: 1.00
    color: white
]])

pvpWindow = UI.createWindow('PVPMainWindow', rootWidget)
pvpWindow:hide()
pvpWindow.closePanel.onClick = function()
    pvpWindow:hide()
end

pushPanel = UI.createWidget('PVPTabPanel', pvpWindow.content)
pushPanel:setId('pushPanel')

local mainPanel = pvpWindow.content
btnNumpad = pvpWindow.buttonNumpad
btnMarcacao = pvpWindow.buttonMarcacao
hkMarcacao = pvpWindow.buttonMarcacao
pvpWindow.pushKeyEdit.onTextChange = function(w, text)
    config.marcacao.hotkey = text
    saveConfig()
end
pvpWindow.pushKeyEdit:setText(config.marcacao.hotkey)

mainUI.switch:setOn(config.enabled)
mainUI.switch.onClick = function(widget)
    config.enabled = not config.enabled
    widget:setOn(config.enabled)
    saveConfig()
end

mainUI.setup.onClick = function()
    pvpWindow:show()
    pvpWindow:raise()
    pvpWindow:focus()
end

local function updateModeButtons()
    if config.mode == "marcacao" then
        btnMarcacao:setColor("white")
        btnMarcacao:setText("Marcacao")
        btnMarcacao:setImageColor("green")
        btnNumpad:setColor("#FFFFFF")
        btnNumpad:setText("Tecla")
        btnNumpad:setImageColor("red")
    else
        btnMarcacao:setColor("#FFFFFF")
        btnMarcacao:setText("Marcacao")
        btnMarcacao:setImageColor("red")
        btnNumpad:setColor("white")
        btnNumpad:setText("Tecla")
        btnNumpad:setImageColor("green")
    end
end

btnMarcacao.onClick = function()
    if config.mode == "marcacao" then
        config.marcacao.autoPush = not config.marcacao.autoPush
        btnMarcacao:setOn(config.marcacao.autoPush)
    else
        config.mode = "marcacao"
    end

    updateModeButtons()
    saveConfig()
end

btnNumpad.onClick = function()
    config.mode = "numpad"
    updateModeButtons()
    saveConfig()
end

updateModeButtons()

local function getKeyName(keyCode, keyboardModifiers)
    local keyNames = {
        [48] = "0", [49] = "1", [50] = "2", [51] = "3", [52] = "4",
        [53] = "5", [54] = "6", [55] = "7", [56] = "8", [57] = "9",
        [65] = "A", [66] = "B", [67] = "C", [68] = "D", [69] = "E",
        [70] = "F", [71] = "G", [72] = "H", [73] = "I", [74] = "J",
        [75] = "K", [76] = "L", [77] = "M", [78] = "N", [79] = "O",
        [80] = "P", [81] = "Q", [82] = "R", [83] = "S", [84] = "T",
        [85] = "U", [86] = "V", [87] = "W", [88] = "X", [89] = "Y",
        [90] = "Z",
        [32] = "Space",
        [16777219] = "Backspace",
        [16777220] = "Enter",
        [16777217] = "Tab",
        [16777216] = "Escape",
        [96] = "Numpad0", [97] = "Numpad1", [98] = "Numpad2",
        [99] = "Numpad3", [100] = "Numpad4", [101] = "Numpad5",
        [102] = "Numpad6", [103] = "Numpad7", [104] = "Numpad8",
        [105] = "Numpad9",
        [16777234] = "Left", [16777235] = "Up", [16777236] = "Right", [16777237] = "Down",
        [16777264] = "F1", [16777265] = "F2", [16777266] = "F3", [16777267] = "F4",
        [16777268] = "F5", [16777269] = "F6", [16777270] = "F7", [16777271] = "F8",
        [16777272] = "F9", [16777273] = "F10", [16777274] = "F11", [16777275] = "F12",
        [16777238] = "Insert", [16777239] = "Delete", [16777232] = "Home", 
        [16777233] = "End", [16777238] = "PageUp", [16777239] = "PageDown"
    }
    
    local keyName = keyNames[keyCode] or "Key" .. keyCode
    
    if keyboardModifiers == KeyboardCtrlModifier then
        keyName = "Ctrl+" .. keyName
    elseif keyboardModifiers == KeyboardShiftModifier then
        keyName = "Shift+" .. keyName
    elseif keyboardModifiers == KeyboardAltModifier then
        keyName = "Alt+" .. keyName
    end
    
    return keyName
end

local function openKeysSetupWindow()
  local keysWindow = UI.createWindow('PVPKeysWindow', rootWidget)
  keysWindow:show()
  keysWindow:raise()
  keysWindow:focus()

  config = config or {}
  config.numpad = config.numpad or {}
  if not config.numpad.keys then
    config.numpad.keys = {
      ["1"] = "Numpad1",
      ["2"] = "Numpad2",
      ["3"] = "Numpad3",
      ["4"] = "Numpad4",
      ["6"] = "Numpad6",
      ["7"] = "Numpad7",
      ["8"] = "Numpad8",
      ["9"] = "Numpad9"
    }
  end

  local function safeKeyName(keyCode, keyboardModifiers)
    if type(getKeyName) == "function" then
      return getKeyName(keyCode, keyboardModifiers)
    end
    return tostring(keyCode or "")
  end

  local function setFieldText(field, text)
    if not field then return end
    field:setText(text or "")
  end

  local content = keysWindow:getChildById('content')
  if not content then
    keysWindow:destroy()
    return
  end

  local keyFields = {
    ["7"] = content:getChildById("NW"),
    ["8"] = content:getChildById("N"),
    ["9"] = content:getChildById("NE"),
    ["4"] = content:getChildById("W"),
    ["6"] = content:getChildById("E"),
    ["1"] = content:getChildById("SW"),
    ["2"] = content:getChildById("S"),
    ["3"] = content:getChildById("SE"),
  }
  local labels = {
    ["7"] = "^< Noroeste (7):",
    ["8"] = "^ Norte (8):",
    ["9"] = "^> Nordeste (9):",
    ["4"] = "< Oeste (4):",
    ["6"] = "> Leste (6):",
    ["1"] = "v< Sudoeste (1):",
    ["2"] = "v Sul (2):",
    ["3"] = "v> Sudeste (3):"
  }

  for pos, field in pairs(keyFields) do
    local fallback = "Numpad" .. pos
    setFieldText(field, config.numpad.keys[pos] or fallback)
  end

  for pos, field in pairs(keyFields) do
    if field then
      field.onKeyPress = function(widget, keyCode, keyboardModifiers)
          local keyName = safeKeyName(keyCode, keyboardModifiers)
          widget:setText(keyName)
          config.numpad.keys[pos] = keyName
          saveConfig()
          return true
      end
    end
  end

  local saveBtn = content:getChildById("saveBtn")
  local resetBtn = content:getChildById("resetBtn")

  if saveBtn then
    saveBtn.onClick = function()
      if Helpers and type(Helpers.showMessage) == "function" then
      end
      keysWindow:hide()
      keysWindow:destroy()
    end
  end

  if resetBtn then
    resetBtn.onClick = function()
      config.numpad.keys = {
        ["1"] = "1",
        ["2"] = "2",
        ["3"] = "3",
        ["4"] = "4",
        ["6"] = "6",
        ["7"] = "7",
        ["8"] = "8",
        ["9"] = "9"
      }

      for pos, field in pairs(keyFields) do
        if field then
          field:setText(config.numpad.keys[pos])
        end
      end

      saveConfig()
    end
  end

  if keysWindow.closeButton then
    keysWindow.closeButton.onClick = function()
      keysWindow:hide()
    end
  end
end

pvpWindow.setupTeclas.onClick = function()
    openKeysSetupWindow()
end

config = config or {}
config.numpad = config.numpad or {}
if not config.numpad.maxDistance then config.numpad.maxDistance = 1 end
if not config.pushDelay then config.pushDelay = 200 end

local distanceScroll = pvpWindow:recursiveGetChildById('distancePush')
local distanceText   = pvpWindow:recursiveGetChildById('distanceText')

local delayScroll = pvpWindow:recursiveGetChildById('delayPush')
local delayText   = pvpWindow:recursiveGetChildById('delayText')

if distanceScroll and distanceText then
  distanceScroll:setRange(1, 9) 
  distanceScroll:setStep(1)

  -- clamp simples pra não estourar
  local v = tonumber(config.numpad.maxDistance) or 1
  if v < 1 then v = 1 end
  if v > 9 then v = 9 end
  config.numpad.maxDistance = v

  distanceScroll:setValue(v)
  distanceText:setText("Max Distance Push: " .. v)

  distanceScroll.onValueChange = function(scroll, value)
    config.numpad.maxDistance = value
    distanceText:setText("Max Distance Push: " .. value)
    saveConfig()
  end
end

if delayScroll and delayText then
  delayScroll:setRange(10, 2000)
  delayScroll:setStep(10)

  local d = tonumber(config.pushDelay) or 200
  if d < 10 then d = 10 end
  if d > 2000 then d = 2000 end
  d = math.floor(d / 10) * 10
  config.pushDelay = d

  delayScroll:setValue(d)
  delayText:setText("Delay Push: " .. d .. "ms")

  delayScroll.onValueChange = function(scroll, value)
    config.pushDelay = value
    delayText:setText("Delay Push: " .. value .. "ms")
    saveConfig()
  end
end

config = config or {}
config.numpad = config.numpad or {}
pvpWindow.autoAfastar:setChecked(config.numpad.autoRetreat == true)
pvpWindow.autoAfastar.onCheckChange = function(_, checked)
  config.numpad.autoRetreat = checked == true
  saveConfig()
end

local runaSeparator = UI.createWidget('HorizontalSeparator', mainPanel)
runaSeparator:setMarginTop(300)

config.fireField = config.fireField or { enabled = false, runeId = 3188 }
config.fireField.key = nil

local uiFireCheck = pvpWindow:recursiveGetChildById('firefield')
local uiFireItem  = pvpWindow:recursiveGetChildById('fireFieldId')

if uiFireCheck then
  uiFireCheck:setChecked(config.fireField.enabled == true)
  uiFireCheck.onCheckChange = function(_, checked)
    config.fireField.enabled = checked == true
    saveConfig()
  end
end

if uiFireItem then
  if uiFireItem.setItemId then
    uiFireItem:setItemId(tonumber(config.fireField.runeId) or 0)
  end
  uiFireItem.onItemChange = function(widget)
    if widget and widget.getItemId then
      config.fireField.runeId = widget:getItemId()
      saveConfig()
    end
  end
end

local function trim(s)
  s = tostring(s or "")
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local lastFireAt = 0
local function nowMs()
  if g_clock and g_clock.millis then return g_clock.millis() end
  return math.floor(os.clock() * 1000)
end

config = config or {}
config.destroyField = config.destroyField or { enabled = false, runeId = 0, fieldItems = {} }

local destroyFieldLookup = {}

local function rebuildDestroyFieldLookup()
    destroyFieldLookup = {}

    for _, fieldId in ipairs(config.destroyField.fieldItems or {}) do
        local id = fieldId

        if type(fieldId) == "table" then
            id = fieldId.id or fieldId.itemId
        end

        id = tonumber(id)

        if id then
            destroyFieldLookup[id] = true
        end
    end
end

rebuildDestroyFieldLookup()

local useDestroyFieldCheck = pvpWindow:recursiveGetChildById('destroyField')
local destroyFieldItem = pvpWindow:recursiveGetChildById('destroyFieldId')

if useDestroyFieldCheck then
  useDestroyFieldCheck:setChecked(config.destroyField.enabled == true)

  useDestroyFieldCheck.onCheckChange = function(_, checked)
    config.destroyField.enabled = checked == true
    saveConfig()
  end
end

if destroyFieldItem then
  if destroyFieldItem.setItemId then
    destroyFieldItem:setItemId(tonumber(config.destroyField.runeId) or 0)
  end

  destroyFieldItem.onItemChange = function(widget)
    if widget and widget.getItemId then
      config.destroyField.runeId = widget:getItemId()
      saveConfig()
    end
  end
end

local fieldItemsLabel = UI.createWidget('UIWidget', mainPanel)
fieldItemsLabel:setHeight(20)
fieldItemsLabel:setMarginTop(10)
fieldItemsLabel:setText("Fields/Walls para Destruir:")
fieldItemsLabel:setTextAlign(AlignCenter)
fieldItemsLabel:setColor("#FFAA00")

config = config or {}
config.destroyField = config.destroyField or { enabled = false, runeId = 0, fieldItems = {} }

local hostPanel = pvpWindow:recursiveGetChildById('destroyFieldList')
if not hostPanel then
  print("[DESTROY CONFIG] ERRO: nao achei Panel destroyFieldList no OTUI")
  return
end

if hostPanel._dfContainer and hostPanel._dfContainer.destroy then
  pcall(function() hostPanel._dfContainer:destroy() end)
  hostPanel._dfContainer = nil
end

local fieldItemsContainer = UI.ContainerEx(function(_, items)
  local itemIds = normalizeContainerItems(items)

  config.destroyField.fieldItems = itemIds
  saveConfig()

end, true, hostPanel)

fieldItemsContainer:setParent(hostPanel)
fieldItemsContainer:fill('parent')

fieldItemsContainer:setItems(config.destroyField.fieldItems or {})

if fieldItemsContainer.setTooltip then
  fieldItemsContainer:setTooltip("Clique para adicionar IDs de fields/walls que devem ser destruidos (fire, poison, energy, magic wall). O destroy field sera usado automaticamente quando detectar.")
end

hostPanel._dfContainer = fieldItemsContainer

local blockingInfo = UI.createWidget('UIWidget', mainPanel)
blockingInfo:setHeight(50)
blockingInfo:setMarginTop(5)
blockingInfo:setTextWrap(true)
blockingInfo:setTextAlign(AlignCenter)
blockingInfo:setColor("#AAAAAA")
blockingInfo:setText("Clique no box acima para adicionar IDs.\nExemplos: 3147 (parcel), 2595 (box),\n2118 (fire field), 2119 (energy field)")

local infoLabel = UI.createWidget('UIWidget', mainPanel)
infoLabel:setHeight(100)
infoLabel:setMarginTop(15)
infoLabel:setTextWrap(true)
infoLabel:setTextAlign(AlignCenter)
infoLabel:setColor("#FFFF00")

btnMarcacao.onClick = function()
    config.mode = "marcacao"
    updateModeButtons()
    saveConfig()
end

btnNumpad.onClick = function()
    config.mode = "numpad"
    updateModeButtons()
    saveConfig()
end

do

PushState = {
    retreatLockUntil = 0,
    markedTarget = nil,
    markedTargetPos = nil,
    markedDest = nil,
    markStep = 0, 
    isProgressive = false,
    manualPush = false,
    
    currentTarget = nil,
    lastLookName = nil,
    
    lastPush = 0,
    
    justRetreated = false,
    retreatTime = 0,
    lastPlayerMove = 0,
    
    blockedPlayerPos = nil,
    blockedUntil = 0,
    
    lastDebugMsg = 0
}

local function clearMarkers()
    for _, tile in pairs(g_map.getTiles(posz())) do
        local text = tile:getText()
        if text == "Target" or text == "Dest" then
            tile:setText('')
        end
    end
    if PushState.markedTarget then
        PushState.markedTarget:setMarked(nil)
    end
end

local lastTargetPos = nil
local lastDestCheck = 0

local function updateMarkers()
    local currentTime = now
    
    if PushState.markedTarget then
        local targetPos = PushState.markedTarget:getPosition()
        if targetPos and targetPos.z == posz() then

            local posChanged = not lastTargetPos or 
                             lastTargetPos.x ~= targetPos.x or 
                             lastTargetPos.y ~= targetPos.y
            
            if posChanged then
                if lastTargetPos then
                    local oldTile = g_map.getTile(lastTargetPos)
                    if oldTile and oldTile:getText() == "Target" then
                        oldTile:setText('')
                    end
                end
                
                local targetTile = g_map.getTile(targetPos)
                if targetTile then
                    targetTile:setText('Target')
                end
                
                lastTargetPos = {x = targetPos.x, y = targetPos.y, z = targetPos.z}
            end
            
            if currentTime - lastDestCheck > 1000 then
                PushState.markedTarget:setMarked('red')
            end
        end
    end

    if PushState.markedDest and PushState.markedDest.z == posz() then
        if currentTime - lastDestCheck > 1000 then
            local destTile = g_map.getTile(PushState.markedDest)
            if destTile then
                local currentText = destTile:getText()
                if currentText ~= "Dest" then
                    destTile:setText('Dest')
                end
            end
            lastDestCheck = currentTime
        end
    end
end

local function clearDestMarker()
    for _, tile in pairs(g_map.getTiles(posz())) do
        if tile and tile:getText() == "Dest" then
            pcall(function() tile:setText('') end)
        end
    end
end

local function resetPush()
    clearMarkers()
    PushState.iconPushTask = nil
    PushState.markedTarget = nil
    PushState.markedTargetPos = nil
    PushState.markedDest = nil
    PushState.markStep = 0 
    PushState.isProgressive = false
    PushState.manualPush = false
    PushState.justRetreated = false
    lastTargetPos = nil
  
    for _, tile in pairs(g_map.getTiles(posz())) do
        local text = tile:getText()
        if text and text ~= "" then
            tile:setText("")
        end
    end
end

local function hasObstacle(checkPos)
    if not checkPos then return true end
    
    local tile = g_map.getTile(checkPos)
    if not tile then return true end
    if not tile:isWalkable() then return true end
    
    local playerPos = pos()
    
    if playerPos.x == checkPos.x and playerPos.y == checkPos.y and playerPos.z == checkPos.z then
        return true
    end
    
    if PushState.blockedPlayerPos and now < PushState.blockedUntil then
        if PushState.blockedPlayerPos.x == checkPos.x and 
           PushState.blockedPlayerPos.y == checkPos.y and 
           PushState.blockedPlayerPos.z == checkPos.z then
            return true
        end
    end

    local creatures = tile:getCreatures()
    if #creatures > 0 then
        if #creatures == 1 and PushState.markedTarget then
            if creatures[1]:getId() == PushState.markedTarget:getId() then
                return false
            end
        end
        return true
    end
    
    return false
end

local function getNextStep(currentPos, targetPos)
    if not currentPos or not targetPos then return nil end

    local allDirections = {
        {x = currentPos.x + 1, y = currentPos.y,     z = currentPos.z, name = "L"},  -- Leste
        {x = currentPos.x - 1, y = currentPos.y,     z = currentPos.z, name = "O"},  -- Oeste
        {x = currentPos.x,     y = currentPos.y + 1, z = currentPos.z, name = "S"},  -- Sul
        {x = currentPos.x,     y = currentPos.y - 1, z = currentPos.z, name = "N"},  -- Norte
        {x = currentPos.x + 1, y = currentPos.y + 1, z = currentPos.z, name = "SE"}, -- Sudeste
        {x = currentPos.x - 1, y = currentPos.y + 1, z = currentPos.z, name = "SO"}, -- Sudoeste
        {x = currentPos.x + 1, y = currentPos.y - 1, z = currentPos.z, name = "NE"}, -- Nordeste
        {x = currentPos.x - 1, y = currentPos.y - 1, z = currentPos.z, name = "NO"}  -- Noroeste
    }

    local freeDirections = {}
    for _, dir in ipairs(allDirections) do
        local isBlocked = hasObstacle(dir)
        
        if not isBlocked then
            dir.distToTarget = Helpers.getDistance(dir, targetPos)
            table.insert(freeDirections, dir)
        end
    end
    
    if #freeDirections == 0 then
        return nil
    end

    local bestDir = freeDirections[1]
    for _, dir in ipairs(freeDirections) do
        if dir.distToTarget < bestDir.distToTarget then
            bestDir = dir
        end
    end
    
    return bestDir
end

local function hasFieldInTile(checkPos)
    if not checkPos then return false end

    local tile = g_map.getTile(checkPos)
    if not tile then return false end

    local items = tile:getItems()
    if not items then return false end

    for _, item in ipairs(items) do
        if item and item.getId then
            local id = item:getId()
            if destroyFieldLookup[id] then
                return true
            end
        end
    end

    return false
end

local function useDestroyFieldFast(destPos)
    if not config.destroyField.enabled then return false end

    local runeId = tonumber(config.destroyField.runeId) or 0
    if runeId <= 0 then return false end
    if not hasFieldInTile(destPos) then return false end

    local tile = g_map.getTile(destPos)
    if not tile then return false end

    local ground = tile:getGround()
    if not ground then return false end

    pausandoCombo = now + 2000
    g_game.useInventoryItemWith(runeId, ground)
    return true
end

local function executePush(creature, destPos)
    if not config.enabled then return false end
    if not creature or not destPos then return false end
    
    local currentTime = now
    local pushDelay = tonumber(config.pushDelay) or 0
    if pushDelay > 0 and currentTime - PushState.lastPush < pushDelay then
        return false
    end
    
    local creaturePos = creature:getPosition()
    if not creaturePos then return false end

    local dist = Helpers.getDistance(creaturePos, destPos)
    if dist ~= 1 then
        return false
    end

    local destTile = g_map.getTile(destPos)
    if not destTile then return false end

    -- Icon/API support: se o destino tiver field/wall configurado, tenta quebrar antes.
    -- O push em si fica para uma nova tentativa, porque o tile pode continuar bloqueado
    -- até o servidor atualizar o mapa.
    if not destTile:isWalkable() or destTile:hasCreature() then
        useDestroyFieldFast(destPos)
        return false
    end

    useDestroyFieldFast(destPos)

    if config.fireField and config.fireField.enabled == true then
        local runeId = tonumber(config.fireField.runeId) or 0

        if runeId > 0 then
            local targetTile = g_map.getTile(creaturePos)
            if targetTile then
                local topThing = targetTile:getTopUseThing()

                if topThing and (topThing:isPickupable() or not topThing:isNotMoveable()) then
                    pausandoCombo = now + 2000
                    useWith(runeId, creature)
                end
            end
        end
    end

    g_game.move(creature, destPos)

    PushState.lastPush = currentTime
    return true
end

local function autoRetreat(targetPos, pushDirection)
    if not config.numpad.autoRetreat then return false end
    if not targetPos or not pushDirection then return false end
    
    local currentTime = now

    if PushState.justRetreated and (currentTime - PushState.retreatTime) < 200 then
        return false
    end

    if (currentTime - PushState.lastPlayerMove) < 200 then
        return false
    end
    
    local playerPos = pos()
    local distance = Helpers.getDistance(playerPos, targetPos)

    if distance <= 1 then
        local relativeX = playerPos.x - targetPos.x
        local relativeY = playerPos.y - targetPos.y

        local retreatPos = {
            x = playerPos.x,
            y = playerPos.y,
            z = playerPos.z
        }

        if relativeX == 0 then
            if relativeY < 0 then
                retreatPos.y = playerPos.y - 1
            else
                retreatPos.y = playerPos.y + 1 
            end

        elseif relativeY == 0 then
            if relativeX < 0 then
                retreatPos.x = playerPos.x - 1 
            else
                retreatPos.x = playerPos.x + 1
            end
        else
            if relativeX < 0 then
                retreatPos.x = playerPos.x - 1
            else
                retreatPos.x = playerPos.x + 1
            end
        end
        
        local retreatTile = g_map.getTile(retreatPos)
        if retreatTile and retreatTile:isWalkable() and not retreatTile:hasCreature() then
            local playerCurrentPos = pos()
            PushState.blockedPlayerPos = {
                x = playerCurrentPos.x,
                y = playerCurrentPos.y,
                z = playerCurrentPos.z
            }
            PushState.blockedUntil = now + 200 
            
            autoWalk(retreatPos, true, true)
            
            PushState.justRetreated = true
            PushState.retreatTime = now
            
            return true
        else
            local alternativeRetreat = {
                {x = playerPos.x - 1, y = playerPos.y},
                {x = playerPos.x + 1, y = playerPos.y},
                {x = playerPos.x, y = playerPos.y - 1},
                {x = playerPos.x, y = playerPos.y + 1}
            }
            
            for _, altPos in ipairs(alternativeRetreat) do
                altPos.z = playerPos.z
                local altTile = g_map.getTile(altPos)
                if altTile and altTile:isWalkable() and not altTile:hasCreature() then
                    local newDist = Helpers.getDistance(altPos, targetPos)
                    if newDist > distance then
                        local playerCurrentPos = pos()
                        PushState.blockedPlayerPos = {
                            x = playerCurrentPos.x,
                            y = playerCurrentPos.y,
                            z = playerCurrentPos.z
                        }
                        PushState.blockedUntil = now + 50
                        
                        autoWalk(altPos, true, true)
                        
                        PushState.justRetreated = true
                        PushState.retreatTime = now
                        
                        return true
                    end
                end
            end
        end
    end
    
    return false
end


-- ============================================================
--  API PUBLICA PARA ICONES PUSHMAX
--  Use: LNS_PushMaxIconPush(dx, dy)
--  dx/dy seguem o padrao do numpad:
--  NW(-1,-1), N(0,-1), NE(1,-1), W(-1,0), E(1,0), SW(-1,1), S(0,1), SE(1,1)
-- ============================================================

local function samePosition(a, b)
    return a and b and a.x == b.x and a.y == b.y and a.z == b.z
end

local function pushMaxLater(ms, fn)
    if type(schedule) == "function" then return schedule(ms, fn) end
    if type(scheduleEvent) == "function" then return scheduleEvent(fn, ms) end
    if g_dispatcher and type(g_dispatcher.scheduleEvent) == "function" then
        return g_dispatcher:scheduleEvent(fn, ms)
    end
    return fn()
end

local function useFireFieldOnCreature(creature)
    if not config.fireField or config.fireField.enabled ~= true then return false end

    local runeId = tonumber(config.fireField.runeId) or 0
    if runeId <= 0 or not creature then return false end

    local currentTime = now
    if currentTime and lastFireAt and (currentTime - lastFireAt) < 350 then
        return false
    end

    local cpos = creature:getPosition()
    if not cpos then return false end

    local tile = g_map.getTile(cpos)
    local used = false

    -- Primeiro tenta diretamente na criatura, que funciona em boa parte dos OTC/vBot.
    if type(useWith) == "function" then
        local ok = pcall(function() 
          pausandoCombo = now + 2000
          useWith(runeId, creature) 
        end)
        if ok then used = true end
    end

    -- Fallback: usa no top use thing/ground do SQM do alvo.
    if not used then
        local thing = nil
        if tile then
            if tile.getTopUseThing then
                local ok, res = pcall(function() return tile:getTopUseThing() end)
                if ok then thing = res end
            end
            if not thing and tile.getGround then
                local ok, res = pcall(function() return tile:getGround() end)
                if ok then thing = res end
            end
        end

        if thing and g_game and g_game.useInventoryItemWith then
            local ok = pcall(function() pausandoCombo = now + 2000
              g_game.useInventoryItemWith(runeId, thing) end)
            if ok then used = true end
        end
    end

    if used then
        lastFireAt = currentTime or nowMs()
    end

    return used
end

local function getPushMaxIconTarget()
    local function validCreature(creature)
        if not creature then return nil end
        local cpos = creature:getPosition()
        if not cpos or cpos.z ~= posz() then return nil end
        return creature
    end

    local creature =
        validCreature(PushState.currentTarget) or
        validCreature(PushState.markedTarget) or
        validCreature(g_game.getAttackingCreature and g_game.getAttackingCreature()) or
        validCreature(g_game.getFollowingCreature and g_game.getFollowingCreature())

    if creature then
        PushState.currentTarget = creature
        return creature
    end

    return nil
end

local function stopIconPush()
    PushState.iconPushTask = nil
end

local function startIconPushTask(creature, dx, dy)
    if not creature then return false end

    local targetPos = creature:getPosition()
    if not targetPos or targetPos.z ~= posz() then return false end

    local maxDistance = tonumber(config.numpad and config.numpad.maxDistance) or 7
    if Helpers.getDistance(pos(), targetPos) > maxDistance then
        return false
    end

    local destPos = {
        x = targetPos.x + dx,
        y = targetPos.y + dy,
        z = targetPos.z
    }

    -- Uma seta = uma ordem ate o alvo chegar neste SQM final.
    -- Isso imita o modo marcacao: clica uma vez e a macro continua tentando.
    PushState.iconPushTask = {
        creature = creature,
        dx = dx,
        dy = dy,
        destPos = destPos,
        startedAt = now,
        lastDestroyAt = 0,
        lastFireAt = 0,
        lastMoveTryAt = 0,
        fireDone = false,
        attempts = 0
    }

    return true
end

local function listHasId(list, id)
    id = tonumber(id)
    if not id then return false end

    for _, entry in ipairs(list or {}) do
        local entryId = entry
        if type(entry) == "table" then
            entryId = entry.id or entry.itemId
        end

        if tonumber(entryId) == id then
            return true
        end
    end

    return false
end

local function hasBlockingItemUnderCreature(creature)
    if not creature then return false end

    local cpos = creature:getPosition()
    if not cpos then return false end

    local tile = g_map.getTile(cpos)
    if not tile then return false end

    local function isBlockingId(id)
        id = tonumber(id)
        if not id then return false end

        if listHasId(config.blockingItems, id) then
            return true
        end

        if config.destroyField and listHasId(config.destroyField.fieldItems, id) then
            return true
        end

        return false
    end

    -- Melhor caso: varre todos os things do SQM.
    if tile.getThings then
        local ok, things = pcall(function()
            return tile:getThings()
        end)

        if ok and type(things) == "table" then
            for _, thing in ipairs(things) do
                if thing and thing.getId then
                    local okId, id = pcall(function()
                        return thing:getId()
                    end)

                    if okId and isBlockingId(id) then
                        return true, id
                    end
                end
            end
        end
    end

    -- Fallbacks para OTC/vBot que não retornam getThings direito.
    local getters = {
        "getTopMoveThing",
        "getTopUseThing",
        "getTopThing"
    }

    for _, fn in ipairs(getters) do
        if tile[fn] then
            local ok, thing = pcall(function()
                return tile[fn](tile)
            end)

            if ok and thing and thing.getId then
                local okId, id = pcall(function()
                    return thing:getId()
                end)

                if okId and isBlockingId(id) then
                    return true, id
                end
            end
        end
    end

    return false
end

local function processIconPushTask()
    local task = PushState.iconPushTask
    if not task then return end

    if not config.enabled then
        stopIconPush()
        return
    end

    local currentTime = now
    if currentTime - (task.startedAt or currentTime) > 5000 then
        stopIconPush()
        return
    end

    local creature = task.creature
    if not creature then
        stopIconPush()
        return
    end

    local targetPos = creature:getPosition()
    if not targetPos or targetPos.z ~= posz() then
        stopIconPush()
        return
    end

    local destPos = task.destPos
    if not destPos then
        stopIconPush()
        return
    end

    -- Chegou no SQM pedido pela seta.
    if samePosition(targetPos, destPos) then
        stopIconPush()
        return
    end

    -- Se o target saiu de perto do SQM final, encerra para nao puxar coisa errada.
    if Helpers.getDistance(targetPos, destPos) ~= 1 then
        stopIconPush()
        return
    end

    local maxDistance = tonumber(config.numpad and config.numpad.maxDistance) or 7
    if Helpers.getDistance(pos(), targetPos) > maxDistance then
        return
    end

    local destTile = g_map.getTile(destPos)
    if not destTile then return end

    local pushDir = {
        x = destPos.x - targetPos.x,
        y = destPos.y - targetPos.y
    }

    if config.numpad and config.numpad.autoRetreat and Helpers.getDistance(pos(), targetPos) <= 1 then
        if autoRetreat(targetPos, pushDir) then
            return
        end
    end

    -- 1) Se tem field/wall configurado no destino, fica usando Destroy Field ate limpar.
    -- Nao para aqui: a task continua viva e volta no proximo tick para tacar fire/puxar.
    if hasFieldInTile(destPos) then
        if currentTime - (task.lastDestroyAt or 0) >= 450 then
            useDestroyFieldFast(destPos)
            task.lastDestroyAt = currentTime
        end
        return
    end

    -- 2) Se ainda esta bloqueado, tenta Destroy Field mesmo assim quando estiver habilitado.
    -- Isso cobre MW/field que deixam o tile non-walkable antes do mapa atualizar.
    if (not destTile:isWalkable() or destTile:hasCreature()) then
        if currentTime - (task.lastDestroyAt or 0) >= 450 then
            useDestroyFieldFast(destPos)
            task.lastDestroyAt = currentTime
        end
        return
    end

    -- 3) Destino liberado: joga Fire Field no pe do target uma vez antes do drag.
    local minTryDelay = math.max(60, tonumber(config.pushDelay) or 0)
    if currentTime - (task.lastMoveTryAt or 0) < minTryDelay then
        return
    end

    task.lastMoveTryAt = currentTime
    task.attempts = (task.attempts or 0) + 1

    local beforePos = creature:getPosition()
    local ok = executePush(creature, destPos)

    -- 4) Se o push nao andar e tiver item configurado embaixo do alvo,
    -- ai sim joga Fire Field UMA vez.
    pushMaxLater(120, function()
        if not PushState.iconPushTask or PushState.iconPushTask ~= task then return end
        if not creature then return end
        if task.fireDone then return end
        if not config.fireField or config.fireField.enabled ~= true then return end

        local afterPos = creature:getPosition()
        if not afterPos or not beforePos then return end

        local stillSameSqm =
            afterPos.x == beforePos.x and
            afterPos.y == beforePos.y and
            afterPos.z == beforePos.z

        if not stillSameSqm then
            return
        end

        local hasBlocker = hasBlockingItemUnderCreature(creature)
        if not hasBlocker then
            return
        end

        if useFireFieldOnCreature(creature) then
            task.fireDone = true
            task.lastFireAt = now
        else
            task.fireDone = true
        end
    end)

    -- Caso o executePush tenha voltado falso por algum estado temporario,
    -- deixa a task rodando para repetir sem precisar clicar de novo.
    if ok then
        PushState.justRetreated = false
        PushState.blockedPlayerPos = nil
        PushState.blockedUntil = 0
        PushState.retreatLockUntil = 0
    end
end

macro(50, function()
    processIconPushTask()
end)

local function iconPushDirection(dx, dy)
    if not config.enabled then return false end

    dx, dy = tonumber(dx) or 0, tonumber(dy) or 0
    if dx == 0 and dy == 0 then return false end
    if dx < -1 or dx > 1 or dy < -1 or dy > 1 then return false end

    local creature = getPushMaxIconTarget()
    if not creature then
        Helpers.showMessage("Selecione/ataque/siga o player que deseja empurrar")
        return false
    end

    return startIconPushTask(creature, dx, dy)
end

LNS_PushMaxIconPush = iconPushDirection
LNSPushMaxIconTarget = getPushMaxIconTarget


local function doMark()
  if PushState.markStep == 2 and PushState.markedDest then
    if not PushState.markedTarget and PushState.markedTargetPos then
      local targetTile = g_map.getTile(PushState.markedTargetPos)
      if targetTile then
        local creatures = targetTile:getCreatures()
        if #creatures > 0 then
          PushState.markedTarget = creatures[1]
          PushState.markedTarget:setMarked('red')
        end
      end
    end
    return
  end

  local tile = getTileUnderCursor()
  if not tile then return end

  if PushState.markStep == 0 then
    local creatures = tile:getCreatures()

    if #creatures > 0 then
      PushState.markedTarget = creatures[1]
      PushState.markedTarget:setMarked('red')
      PushState.markedTargetPos = nil
    else
      PushState.markedTarget = nil
      PushState.markedTargetPos = tile:getPosition()
    end

    tile:setText('Target')
    PushState.markStep = 1

  elseif PushState.markStep == 1 then
    if Helpers.isValidTile(tile) then
      local destPos = tile:getPosition()

      pcall(function() tile:setText('Dest') end)
      PushState.markedDest = destPos
      PushState.markStep = 2

      PushState.isProgressive = true

    else
      resetPush()
    end
  end
end


onKeyDown(function(keys)
    if not config.enabled then return end
    if config.mode ~= "marcacao" then return end

    local normalizedKeys = string.lower(keys or "")
    local hotkey = string.lower(config.marcacao.hotkey or "")

    if normalizedKeys == hotkey then
        doMark()
    end
    
end)

macro(200, function()
    if not config.enabled then return end
    if config.mode ~= "marcacao" then return end
    if PushState.markStep < 1 then return end

    if not PushState.markedTarget and PushState.markedTargetPos then
        local targetTile = g_map.getTile(PushState.markedTargetPos)
        if targetTile then
            local creatures = targetTile:getCreatures()
            if #creatures > 0 then
                if not PushState.markedTarget then
                    PushState.markedTarget = creatures[1]
                    PushState.markedTarget:setMarked('red')

                    if PushState.markedDest then
                        PushState.isProgressive = true
                    else
                    end
                end
            end
        end
    end
end)

macro(200, function()
    if not config.enabled then return end
    if config.mode ~= "marcacao" then return end
    if PushState.markStep > 0 then
        updateMarkers()
    end
end)

macro(50, function()
    if not config.enabled then return end
    if config.mode ~= "marcacao" then return end
    if not PushState.isProgressive then return end
    if not PushState.markedTarget or not PushState.markedDest then return end

    local targetPos = PushState.markedTarget:getPosition()
    if not targetPos or targetPos.z ~= posz() then
        if PushState.markedDest then
            PushState.markedTarget = nil
            PushState.markStep = 1
            PushState.isProgressive = false
        else
            resetPush()
        end
        return
    end
    
    if targetPos.x == PushState.markedDest.x and 
       targetPos.y == PushState.markedDest.y and 
       targetPos.z == PushState.markedDest.z then
        if PushState.isProgressive then

            clearDestMarker()
            PushState.markedDest = nil
            PushState.isProgressive = false
            PushState.markStep = 1

            if not PushState.markedTarget and PushState.markedTargetPos then
            end
        end

        clearDestMarker()
        PushState.markedDest = nil
        PushState.markStep = 1 
        
        return 
    end

    local currentTime = now
    if currentTime - PushState.lastPush < config.pushDelay then
        return
    end

    local nextStep = getNextStep(targetPos, PushState.markedDest)
    
    if not nextStep then
        if (now - (PushState.lastDebugMsg or 0)) > 20 then
            PushState.lastDebugMsg = now
        end
        return
    end

    local distToNext = Helpers.getDistance(targetPos, nextStep)
    if distToNext ~= 1 then
        return
    end

    local destTile = g_map.getTile(nextStep)
    if Helpers.isValidTile(destTile) then
        local playerPos = pos()
        local playerToTargetDist = Helpers.getDistance(playerPos, targetPos)

        if playerToTargetDist <= 1 and config.numpad.autoRetreat then
            local pushDir = {
                x = nextStep.x - targetPos.x,
                y = nextStep.y - targetPos.y
            }

            if autoRetreat(targetPos, pushDir) then
                return
            end
        end
        
        local pushResult = executePush(PushState.markedTarget, nextStep)
        if pushResult then
            -- Push executado com sucesso!
            PushState.justRetreated = false
            -- Limpar bloqueio da posicao antiga do jogador
            PushState.blockedPlayerPos = nil
            PushState.blockedUntil = 0
            PushState.retreatLockUntil = 0
        end
    end
end)

onKeyDown(function(keys)
    if not config.enabled then return end
    if keys == "Escape" then
        -- Sempre limpar TUDO com ESC, mesmo sem marcações
        resetPush()
        PushState.iconPushTask = nil
        PushState.currentTarget = nil
    end
end)

onTextMessage(function(mode, text)
    if not config.enabled then return end
    if config.mode ~= "numpad" then return end
    
    local name = text:match("You see ([^%(]+)")
    if name then
        name = name:gsub("^%s*(.-)%s*$", "%1")  -- trim
        PushState.lastLookName = name

        for _, creature in ipairs(getSpectators()) do
            if creature:getName() == name and creature:getPosition().z == posz() then
                PushState.currentTarget = creature
                return
            end
        end
    end
end)

macro(100, function()
    if not config.enabled then return end
    if config.mode ~= "numpad" then return end
    
    local attacking = g_game.getAttackingCreature()
    local following = g_game.getFollowingCreature()
    
    if attacking then
        PushState.currentTarget = attacking
    elseif following then
        PushState.currentTarget = following
    end
end)

onKeyDown(function(keys)
    if not config.enabled then return end
    if config.mode ~= "numpad" then return end
    
    local directionVectors = {
        ["1"] = {x = -1, y =  1},  -- Sudoeste
        ["2"] = {x =  0, y =  1},  -- Sul
        ["3"] = {x =  1, y =  1},  -- Sudeste
        ["4"] = {x = -1, y =  0},  -- Oeste
        ["6"] = {x =  1, y =  0},  -- Leste
        ["7"] = {x = -1, y = -1},  -- Noroeste
        ["8"] = {x =  0, y = -1},  -- Norte
        ["9"] = {x =  1, y = -1}   -- Nordeste
    }

    local dir = nil
    local dirPos = nil

    local normalizedKeys = string.lower(keys or "")
    
    if config.numpad.keys then
        for pos, keyName in pairs(config.numpad.keys) do
            local normalizedKeyName = string.lower(keyName or "")
            if normalizedKeys == normalizedKeyName then
                dir = directionVectors[pos]
                dirPos = pos
                break
            end
        end
    end
    
    if not dir then return end
    
    if not PushState.currentTarget then
        Helpers.showMessage("Selecione o Player que deseja empurrar")
        return
    end
    
    local targetPos = PushState.currentTarget:getPosition()
    if not targetPos or targetPos.z ~= posz() then
        PushState.currentTarget = nil
        return
    end

    local distance = Helpers.getDistance(pos(), targetPos)
    
    if distance > config.numpad.maxDistance then
        return
    end

    local destPos = {
        x = targetPos.x + dir.x,
        y = targetPos.y + dir.y,
        z = targetPos.z
    }

    local destTile = g_map.getTile(destPos)
    if not Helpers.isValidTile(destTile) then
        Helpers.showMessage("Impossivel arastar para este SQM")
        return
    end

    if autoRetreat(targetPos, dir) then
      executePush(PushState.currentTarget, destPos)
    else
      executePush(PushState.currentTarget, destPos)
    end
end)

onPlayerPositionChange(function(newPos, oldPos)
    if not config.enabled then return end
    
    if oldPos and newPos then
        local moved = (oldPos.x ~= newPos.x or oldPos.y ~= newPos.y)
        
        if moved then
            PushState.lastPlayerMove = now
            
            if config.cancelDelayOnRetreat then
                -- Resetar delay para permitir push imediato
                PushState.lastPush = 0

                if config.mode == "numpad" and PushState.currentTarget then
                elseif config.mode == "marcacao" and PushState.isProgressive then
                end
            end
        end
    end
end)

end

-------------------------
--- DROP FLOWERS - SEM LOCAL NO MAIN
-------------------------
switchDropFlor = "dropFlorButton"

charStorage = charStorage or loadCharStorage()
charStorage[switchDropFlor] = charStorage[switchDropFlor] or { enabled = false }

function saveDropFlorChar()
  saveCharStorage(charStorage)
end

dropFlorButton = setupUI([[
Panel
  height: 19
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Drop Flowers
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

dropFlorButton:setId(switchDropFlor)
dropFlorButton.title:setOn(charStorage[switchDropFlor].enabled)

dropFlorButton.title.onClick = function(widget)
  newState = not widget:isOn()
  widget:setOn(newState)
  charStorage[switchDropFlor].enabled = newState
  saveDropFlorChar()
end

dropFlorInterface = setupUI([[
MainWindow
  id: mainPanel
  size: 250 270
  anchors.centerIn: parent
  margin-top: -60
  text: Panel DropFlowers
  opacity: 1.00

  FlatPanel
    id: cardFlower
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 110
    opacity: 0.95
    margin: -5
    margin-top: 2

  Label
    id: labelcontainer
    anchors.top: prev.top
    anchors.left: prev.left
    margin-top: 16
    margin-left: 7
    text: ID Flowers:

  BotItem
    id: idFlower
    anchors.left: prev.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-left: 5

  BotItem
    id: idFlower2
    anchors.left: prev.right
    anchors.verticalCenter: prev.verticalCenter
    margin-left: 3

  BotItem
    id: idFlower3
    anchors.left: prev.right
    anchors.verticalCenter: prev.verticalCenter
    margin-left: 3

  BotItem
    id: idFlower4
    anchors.left: prev.right
    anchors.verticalCenter: prev.verticalCenter
    margin-left: 3

  Label
    anchors.top: prev.bottom
    anchors.left: labelcontainer.left
    margin-top: 11
    text: Key Drop Back:
    width: 110

  TextEdit
    id: keyDropBACK
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: cardFlower.right
    margin-top: 0
    margin-right: 10
    placeholder: Key Here

  Label
    anchors.top: prev.bottom
    anchors.left: labelcontainer.left
    margin-top: 11
    text: Shortcut Marking:
    width: 110

  TextEdit
    id: keyMarking
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: cardFlower.right
    margin-top: 0
    margin-right: 10
    placeholder: Key Here

  FlatPanel
    id: cardCollect
    anchors.top: cardFlower.bottom
    anchors.left: cardFlower.left
    anchors.right: cardFlower.right
    height: 85
    opacity: 1.00
    margin-top: 10

  Label
    id: labelCollect
    anchors.top: prev.top
    anchors.left: prev.left
    margin-top: 16
    margin-left: 10
    text: ID Container Collect:

  BotItem
    id: idContainerCollect
    anchors.right: cardCollect.right
    anchors.verticalCenter: prev.verticalCenter
    image-source: /images/ui/item-blessed
    margin-top: 2
    margin-right: 10

  Label
    anchors.top: prev.bottom
    anchors.left: labelCollect.left
    margin-top: 11
    text: Key to Collect:
    width: 110

  TextEdit
    id: keyCollectFlower
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: cardCollect.right
    margin-top: 0
    margin-right: 10
    placeholder: Key Here

  Button
    id: closePanel
    anchors.left: cardCollect.left
    anchors.right: cardCollect.right
    anchors.top: cardCollect.bottom
    margin-top: 5
    text: Close
]], g_ui.getRootWidget())

dropFlorInterface:hide()

dropFlorInterface.closePanel.onClick = function()
  dropFlorInterface:hide()
end

DropFlorMobileOk = false
DropFlorIsMobile = false
if g_app and type(g_app.isMobile) == "function" then
  DropFlorMobileOk, DropFlorIsMobile = pcall(function() return g_app:isMobile() end)
  if not DropFlorMobileOk then
    DropFlorMobileOk, DropFlorIsMobile = pcall(function() return g_app.isMobile() end)
  end
end
if DropFlorIsMobile == true then
  if comboLeader then comboLeader:setSize("250 340") end
  if mwInterface then mwInterface:setSize("400 320") end
  if pvpWindow then pvpWindow:setSize("315 360") end
  if dropFlorInterface then dropFlorInterface:setSize("250 250") end
end

dropFlorButton.settings.onClick = function()
  dropFlorInterface:setVisible(not dropFlorInterface:isVisible())
  if dropFlorInterface:isVisible() then
    dropFlorInterface:raise()
    dropFlorInterface:focus()
  end
end

-- =========================================
-- CHAR STORAGE + BINDS
-- =========================================
panelStoreName = "panelDropFlorStorage"

charStorage[panelStoreName] = charStorage[panelStoreName] or {
  flowerId = 2981,
  flowerId2 = 0,
  flowerId3 = 0,
  flowerId4 = 0,
  containerCollectId = 2854,
  keyDropBACK = "",
  keyMarking = "",
  keyCollectFlower = "F2"
}

cfg = charStorage[panelStoreName]

function saveCfg()
  saveDropFlorChar()
end

function sched(ms, fn)
  if type(scheduleEvent) == "function" then
    return scheduleEvent(fn, ms)
  end
  if type(schedule) == "function" then
    return schedule(ms, fn)
  end
  if g_dispatcher and type(g_dispatcher.scheduleEvent) == "function" then
    return g_dispatcher:scheduleEvent(fn, ms)
  end
  if g_dispatcher and type(g_dispatcher.addEvent) == "function" then
    return g_dispatcher:addEvent(fn)
  end
  return nil
end

function safeSetItem(widget, id)
  if not widget then return end
  id = tonumber(id) or 0
  if id > 0 and widget.setItemId then widget:setItemId(id) end
  if id > 0 and (not widget.setItemId) and widget.setItem then widget:setItem(id) end
end

function safeGetItem(widget)
  if not widget then return 0 end
  if widget.getItemId then return tonumber(widget:getItemId()) or 0 end
  if widget.getItem then
    it = widget:getItem()
    if it and it.getId then return tonumber(it:getId()) or 0 end
  end
  return 0
end

function bindBotItem(widget, store, key, defaultId)
  if not widget then return end
  v = tonumber(store[key]) or 0
  if (v <= 0) and (tonumber(defaultId) or 0) > 0 then
    v = tonumber(defaultId)
    store[key] = v
    saveCfg()
  end
  safeSetItem(widget, v)
  widget.onItemChange = function(w)
    store[key] = safeGetItem(w)
    saveCfg()
  end
end

function bindTextEdit(widget, store, key, defaultText)
  if not widget then return end
  v = store[key]
  if v == nil then
    v = tostring(defaultText or "")
    store[key] = v
    saveCfg()
  end
  store[key] = tostring(v or "")
  if widget.setText then widget:setText(store[key]) end
  widget.onTextChange = function(_, text)
    store[key] = tostring(text or "")
    saveCfg()
  end
end

bindBotItem(dropFlorInterface.idFlower,  cfg, "flowerId",  2981)
bindBotItem(dropFlorInterface.idFlower2, cfg, "flowerId2", 0)
bindBotItem(dropFlorInterface.idFlower3, cfg, "flowerId3", 0)
bindBotItem(dropFlorInterface.idFlower4, cfg, "flowerId4", 0)
bindBotItem(dropFlorInterface.idContainerCollect, cfg, "containerCollectId", 2854)

bindTextEdit(dropFlorInterface.keyDropBACK, cfg, "keyDropBACK", "")
bindTextEdit(dropFlorInterface.keyMarking, cfg, "keyMarking", "")
bindTextEdit(dropFlorInterface.keyCollectFlower, cfg, "keyCollectFlower", "F2")

-- =========================================
-- HELPERS
-- =========================================
function tableContains(t, value)
  for i = 1, #t do
    if t[i] == value then return true end
  end
  return false
end

function normalizeFlowerIds()
  ids = {}
  added = {}

  list = {
    tonumber(cfg.flowerId or 0) or 0,
    tonumber(cfg.flowerId2 or 0) or 0,
    tonumber(cfg.flowerId3 or 0) or 0,
    tonumber(cfg.flowerId4 or 0) or 0
  }

  for i = 1, #list do
    id = list[i]
    if id > 0 and not added[id] then
      added[id] = true
      table.insert(ids, id)
    end
  end

  return ids
end

function findItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  for _, c in pairs(g_game.getContainers() or {}) do
    for _, it in ipairs(c:getItems() or {}) do
      if it and it.getId and tonumber(it:getId()) == id then
        return it
      end
    end
  end

  return nil
end

function findAnyFlowerItem()
  flowerIds = normalizeFlowerIds()
  for i = 1, #flowerIds do
    it = findItemById(flowerIds[i])
    if it then
      return it, flowerIds[i]
    end
  end
  return nil, 0
end

function collectFlowers()
  if not pos() then return end

  flowerIds = normalizeFlowerIds()
  if #flowerIds == 0 then return end

  containerId = tonumber(cfg.containerCollectId or 0) or 0
  if containerId <= 0 then return end

  dest = nil
  for _, c in pairs(g_game.getContainers() or {}) do
    bpItem = c:getContainerItem()
    if bpItem and bpItem.getId and tonumber(bpItem:getId()) == containerId then
      dest = c
      break
    end
  end
  if not dest then return end

  slotPos = dest:getSlotPosition(0)
  if not slotPos then return end

  for dx = -1, 1 do
    for dy = -1, 1 do
      tile = g_map.getTile({x = posx() + dx, y = posy() + dy, z = posz()})
      if tile then
        for _, it in ipairs(tile:getItems() or {}) do
          if it and it.isItem and it:isItem() and it.getId then
            itemId = tonumber(it:getId()) or 0
            if tableContains(flowerIds, itemId) then
              g_game.move(it, slotPos, it:getCount())
            end
          end
        end
      end
    end
  end
end

-- =========================================
-- HOTKEYS
-- =========================================
function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

function normKey(s)
  return trim(s):lower()
end

-- =========================================
-- SHORTCUT MARKING FAST
-- Marca sqm pelo mouse, sem setTimer/contagem feia.
-- Usa setMarked se existir; se nao existir, fica com texto fixo.
-- =========================================
MARK_FLOWER_TEXT = "Flower"
MARK_DROP_COOLDOWN = 2
MARK_VISUAL_INTERVAL = 50

__markedFlowerTiles = {}
__markedFlowerCooldown = {}
__markBlink = false
__nextMarkVisual = 0

function markTimeMs()
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end
  if now then return now end
  return 0
end

function markPosKey(p)
  if not p then return "" end
  return tostring(p.x) .. "," .. tostring(p.y) .. "," .. tostring(p.z)
end

function copyMarkPos(p)
  return {x = p.x, y = p.y, z = p.z}
end

function clearTileMarkVisual(tile)
  if not tile then return end

  if tile.setText and tile.getText then
    ok, txt = pcall(function() return tile:getText() end)
    if ok and txt == MARK_FLOWER_TEXT then
      pcall(function() tile:setText("") end)
    end
  elseif tile.setText then
    pcall(function() tile:setText("") end)
  end

  -- Alguns OTCv8 aceitam setMarked em tile; se nao aceitar, o pcall ignora.
  if tile.setMarked then
    pcall(function() tile:setMarked(nil) end)
  end
end

function setMarkedTileVisual(tile)
  if not tile then return end

  -- Mantem a frase marcada no SQM, sem timer/contador.
  if tile.setText then
    pcall(function() tile:setText(MARK_FLOWER_TEXT) end)
  end

  -- Pisca o SQM sem usar setTimer. setTimer mostra contagem, por isso foi removido.
  if tile.setMarked then
    color = __markBlink and "#00FFFF" or "#FFFF00"
    pcall(function() tile:setMarked(color) end)
  end
end

function clearOneMarkedFlower(key)
  p = __markedFlowerTiles[key]
  if p then
    clearTileMarkVisual(g_map.getTile(p))
  end

  __markedFlowerTiles[key] = nil
  __markedFlowerCooldown[key] = nil
end

function clearAllMarkedFlowers()
  for key in pairs(__markedFlowerTiles) do
    clearOneMarkedFlower(key)
  end
end

function toggleMarkedFlowerTile(tile)
  if not tile then return nil end

  p = tile:getPosition()
  if not p or p.z ~= posz() then return nil end

  key = markPosKey(p)

  if __markedFlowerTiles[key] then
    clearOneMarkedFlower(key)
    return nil
  end

  __markedFlowerTiles[key] = copyMarkPos(p)
  __markedFlowerCooldown[key] = 0
  setMarkedTileVisual(tile)
  return key
end

function isMwOrWgId(id)
  id = tonumber(id) or 0

  -- IDs padrao mais comuns de MW/WG.
  if id == 2129 or id == 16518 or id == 2130 then
    return true
  end

  -- Se o painel MW/WG estiver no mesmo charStorage, respeita os IDs configurados nele tambem.
  mwStore = charStorage and charStorage.holdMwWgPanel
  if type(mwStore) == "table" then
    if id == tonumber(mwStore.mwWall1 or 0) then return true end
    if id == tonumber(mwStore.mwWall2 or 0) then return true end
    if id == tonumber(mwStore.wgWall1 or 0) then return true end
    if id == tonumber(mwStore.wgWall2 or 0) then return true end
  end

  return false
end

function tileHasPlayer(tile)
  if not tile then return false end

  for _, creature in ipairs(tile:getCreatures() or {}) do
    if creature and creature.isPlayer and creature:isPlayer() then
      return true
    end
  end

  return false
end

function tileHasMwOrWg(tile)
  if not tile then return false end

  for _, it in ipairs(tile:getItems() or {}) do
    if it and it.getId and isMwOrWgId(it:getId()) then
      return true
    end
  end

  return false
end

function tileHasFlower(tile)
  if not tile then return false end

  flowerIds = normalizeFlowerIds()
  if #flowerIds == 0 then return false end

  for _, it in ipairs(tile:getItems() or {}) do
    if it and it.getId and tableContains(flowerIds, tonumber(it:getId()) or 0) then
      return true
    end
  end

  return false
end

function canDropFlowerOnMarkedTile(tile)
  if not tile then return false end

  p = tile:getPosition()
  if not p or p.z ~= posz() then return false end

  if tileHasPlayer(tile) then return false end
  if tileHasMwOrWg(tile) then return false end
  if tileHasFlower(tile) then return false end

  return true
end

function dropFlowerOnMarkedTile(key, tile, force)
  if not key or not tile then return false end
  if not canDropFlowerOnMarkedTile(tile) then return false end

  t = markTimeMs()
  if not force and (__markedFlowerCooldown[key] or 0) > t then return false end
  __markedFlowerCooldown[key] = t + MARK_DROP_COOLDOWN

  flower = findAnyFlowerItem()
  if not flower then return false end

  g_game.move(flower, tile:getPosition(), 1)
  return true
end

macro(10, function()
  if not charStorage[switchDropFlor] or charStorage[switchDropFlor].enabled ~= true then return end
  if not pos() then return end

  t = markTimeMs()
  updateVisual = false

  if t >= __nextMarkVisual then
    __nextMarkVisual = t + MARK_VISUAL_INTERVAL
    __markBlink = not __markBlink
    updateVisual = true
  end

  for key, markedPos in pairs(__markedFlowerTiles) do
    if markedPos and markedPos.z == posz() then
      tile = g_map.getTile(markedPos)
      if tile then
        if updateVisual then
          setMarkedTileVisual(tile)
        end
        dropFlowerOnMarkedTile(key, tile, false)
      end
    end
  end
end)

onKeyPress(function(keys)
  if not charStorage[switchDropFlor] or charStorage[switchDropFlor].enabled ~= true then return end

  k = normKey(keys)
  if k == "" then return end

  if k == "escape" or k == "esc" then
    clearAllMarkedFlowers()
    return true
  end

  kMarking = normKey(cfg.keyMarking)
  if kMarking ~= "" and k == kMarking then
    tile = getTileUnderCursor()
    if tile then
      key = toggleMarkedFlowerTile(tile)
      if key then
        -- tenta jogar no mesmo instante em que marcou, sem esperar o macro.
        dropFlowerOnMarkedTile(key, tile, true)
      end
    end
    return true
  end

  kCollect = normKey(cfg.keyCollectFlower)
  if kCollect ~= "" and k == kCollect then
    collectFlowers()
    return true
  end
end)

__dropBackRunning = false
__dropBackTickUntil = 0

function nowMs()
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end
  if now then return now end
  return 0
end

function getMyDir()
  if g_game and g_game.getLocalPlayer then
    p = g_game.getLocalPlayer()
    if p and p.getDirection then
      d = p:getDirection()
      if d ~= nil then return tonumber(d) end
    end
  end
  if player and player.getDirection then
    d = player:getDirection()
    if d ~= nil then return tonumber(d) end
  end
  return nil
end

function getBackOffsets(dir)
  if dir == 0 then
    return { {0, 1}, {-1, 1}, {1, 1} }
  elseif dir == 2 then
    return { {0, -1}, {1, -1}, {-1, -1} }
  elseif dir == 1 then
    return { {-1, 0}, {-1, -1}, {-1, 1} }
  elseif dir == 3 then
    return { {1, 0}, {1, 1}, {1, -1} }
  end
  return { {0, 1}, {-1, 1}, {1, 1} }
end

function canPlaceFlowerOnTile(tile, flowerIds, myPos)
  if not tile then return false end
  tilePos = tile:getPosition()
  if not tilePos then return false end

  isSelf = (tilePos.x == myPos.x and tilePos.y == myPos.y and tilePos.z == myPos.z)
  topThing = tile:getTopThing()

  return isSelf or (not topThing or (topThing:isItem() and not tableContains(flowerIds, topThing:getId())))
end

function startDropBack()
  if __dropBackRunning then return end

  myPos = pos()
  if not myPos then return end

  flowerIds = normalizeFlowerIds()
  if #flowerIds == 0 then return end

  dir = getMyDir()
  if dir == nil then return end

  order = getBackOffsets(dir)
  tiles = {}

  for i = 1, #order do
    off = order[i]
    t = g_map.getTile({ x = myPos.x + off[1], y = myPos.y + off[2], z = myPos.z })
    if t then
      table.insert(tiles, t)
    end
  end

  if #tiles == 0 then return end

  __dropBackRunning = true
  idx = 1

  function step()
    if not charStorage[switchDropFlor] or charStorage[switchDropFlor].enabled ~= true then
      __dropBackRunning = false
      return
    end

    t = nowMs()
    if __dropBackTickUntil > t then
      sched(20, step)
      return
    end
    __dropBackTickUntil = t + 50

    if idx > #tiles then
      __dropBackRunning = false
      return
    end

    tile = tiles[idx]
    idx = idx + 1

    if tile and canPlaceFlowerOnTile(tile, flowerIds, myPos) then
      it = findAnyFlowerItem()
      if it then
        g_game.move(it, tile:getPosition(), 1)
      end
    end

    sched(110, step)
  end

  step()
end

macro(30, function()
  if not pos() then return end
  if not charStorage[switchDropFlor] or charStorage[switchDropFlor].enabled ~= true then return end
  if __dropBackRunning then return end

  if cfg.keyDropBACK ~= "" and modules.corelib.g_keyboard.isKeyPressed(cfg.keyDropBACK) then
    startDropBack()
  end
end)

UI.Separator()

--========================================================
-- ANTI PUSH / PICK UP / PUSH ALL
-- CHAR STORAGE
--========================================================
charStorage = charStorage or loadCharStorage()

local function saveThisCharStorage()
  saveCharStorage(charStorage)
end
local function savepickUp()
  saveCharStorage(charStorage)
end


local function normalizeContainerItems(items)
  local r = {}
  if type(items) ~= "table" then return r end

  for _, v in pairs(items) do
    local id = nil

    if type(v) == "table" then
      id = tonumber(v.id)
      if not id and v.getId then
        local ok, got = pcall(function() return v:getId() end)
        if ok then id = tonumber(got) end
      end
    else
      id = tonumber(v)
    end

    if id and id > 0 then
      table.insert(r, id)
    end
  end

  return r
end

local function properTable(t)
  local r = {}
  for _, entry in pairs(t or {}) do
    local id = tonumber(entry) or tonumber(entry and entry.id)
    if id and id > 0 then
      table.insert(r, id)
    end
  end
  return r
end

local function getDropIdsFromContainer(list)
  local t = {}
  for _, entry in pairs(list or {}) do
    local id = nil
    if type(entry) == "table" then
      id = tonumber(entry.id)
    else
      id = tonumber(entry)
    end
    if id and id > 0 then
      table.insert(t, id)
    end
  end
  return t
end

--========================================================
-- ANTI PUSH
--========================================================
local switchAntiPush = "AntiPushButton"

charStorage[switchAntiPush] = charStorage[switchAntiPush] or {
  enabled = false,
  items = {3031, 3035}
}

local antiCfg = charStorage[switchAntiPush]

if type(antiCfg.items) ~= "table" or #antiCfg.items == 0 then
  antiCfg.items = {3031, 3035}
  saveThisCharStorage()
end

AntiPushButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-right: 45
    height: 18
    text-align: center
    text: Anti-Push
    color: white

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Show
    opacity: 1.00
    color: white
]])

AntiPushButton:setId(switchAntiPush)
AntiPushButton.title:setOn(antiCfg.enabled)

AntiPushButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  antiCfg.enabled = newState
  saveThisCharStorage()
end

antiPushInterface = setupUI([[
Panel
  height: 100
    
  Label
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    text-align: center
    text: Items to Drop
    color: gray

  BotContainer
    id: antiPushItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 73
]])

antiPushInterface:hide()

UI.ContainerEx(function(widget, items)
  antiCfg.items = normalizeContainerItems(items)
  if #antiCfg.items == 0 then
    antiCfg.items = {3031, 3035}
  end
  saveThisCharStorage()
end, true, nil, antiPushInterface.antiPushItems)

antiPushInterface.antiPushItems:setItems(antiCfg.items)

AntiPushButton.edit.onClick = function()
  if antiPushInterface:isVisible() then
    antiPushInterface:hide()
    AntiPushButton.edit:setText("Show")
  else
    antiPushInterface:show()
    AntiPushButton.edit:setText("Hide")
  end
end

local currencyBreak = {
  [3031] = 3035, -- se faltar gold, usa platinum
  [3035] = 3043  -- se faltar platinum, usa crystal
}

local lastCurrencyUse = 0
local currencyDelay = 800

local function tryBreakCurrency(itemId)
  if now - lastCurrencyUse < currencyDelay then return false end

  local currencyId = currencyBreak[itemId]
  if not currencyId then return false end

  local currency = findItem(currencyId)
  if not currency then return false end

  lastCurrencyUse = now
  g_game.use(currency)
  return true
end

local function AntiPush()
  if antiCfg.enabled ~= true then return end

  local dropItems = getDropIdsFromContainer(antiCfg.items)
  if #dropItems == 0 then return end

  local tile = g_map.getTile(pos())
  if not tile then return end

  local thing = tile:getTopThing()
  local topId = thing and thing.getId and thing:getId() or 0

  for _, itemId in pairs(dropItems) do
    if itemId ~= topId then
      local dropItem = findItem(itemId)

      if dropItem then
        local count = dropItem:getCount() or 1

        if count <= 2 then
          tryBreakCurrency(itemId)
        end

        g_game.move(dropItem, pos(), count == 1 and 1 or 2)
        return
      else
        if tryBreakCurrency(itemId) then
          return
        end
      end
    end
  end
end

macro(250, function()
  if antiCfg.enabled ~= true then return end
  AntiPush()
end)

--========================================================
-- PICK UP
--========================================================
local switchPickUp = "PickUpButton"

charStorage[switchPickUp] = charStorage[switchPickUp] or {
  enabled = false,
  items = {3031, 3035},
  containerId = 2854,
  containerCount = 1
}

local pickCfg = charStorage[switchPickUp]

if type(pickCfg.items) ~= "table" or #pickCfg.items == 0 then
  pickCfg.items = {3031, 3035}
end

pickCfg.containerId = tonumber(pickCfg.containerId or 0) or 0
if pickCfg.containerId <= 0 then
  pickCfg.containerId = 2854
end

pickCfg.containerCount = tonumber(pickCfg.containerCount or 0) or 0
if pickCfg.containerCount <= 0 then
  pickCfg.containerCount = 1
end

local config = {
  enabled = pickCfg.enabled,
  pickUpItems = pickCfg.items,
  containerPickUpItems = {}
}

local function syncConfig()
  config.enabled = (pickCfg.enabled == true)
  config.pickUpItems = pickCfg.items or {}

  local cid = tonumber(pickCfg.containerId or 0) or 0
  if cid > 0 then
    config.containerPickUpItems = { { id = cid } }
  else
    config.containerPickUpItems = {}
  end
end

syncConfig()

PickUpButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-right: 45
    text-align: center
    height: 18
    text: Pick Up
    color: white

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    height: 18
    margin-left: 2
    text: Show
    opacity: 1.00
    color: white
]])

PickUpButton:setId(switchPickUp)
PickUpButton.title:setOn(pickCfg.enabled)

PickUpButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  pickCfg.enabled = newState
  syncConfig()
  savepickUp()
end

pickUpInterface = setupUI([[
Panel
  height: 130

  Label
    id: labelcontainer
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 10
    margin-left: 5
    text: ID Container:
    color: gray

  BotItem
    id: idContainerPick
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    image-source: /images/ui/item-blessed
    margin-top: 5

  Label
    anchors.top: prev.bottom
    anchors.left: labelcontainer.left
    margin-top: -1
    text: Items to Collect:
    color: gray

  BotContainer
    id: pickUpItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 73
]])

pickUpInterface:hide()

do
  local wid = pickUpInterface.idContainerPick
  local id = tonumber(pickCfg.containerId or 0) or 0

  if type(wid.setItemId) == "function" then
    wid:setItemId(id)
  elseif type(wid.setItem) == "function" then
    wid:setItem(id)
  end

  if type(wid.setItemCount) == "function" then
    wid:setItemCount(tonumber(pickCfg.containerCount or 1) or 1)
  end

  wid.onItemChange = function(widget)
    local item = widget:getItem()
    if item then
      pickCfg.containerId = item:getId()
      pickCfg.containerCount = item:getCount() or 1
    else
      pickCfg.containerId = 2854
      pickCfg.containerCount = 1
    end
    syncConfig()
    savepickUp()
  end
end

UI.ContainerEx(function(widget, items)
  pickCfg.items = normalizeContainerItems(items)
  if #pickCfg.items == 0 then
    pickCfg.items = {3031, 3035}
  end
  syncConfig()
  savepickUp()
end, true, nil, pickUpInterface.pickUpItems)

pickUpInterface.pickUpItems:setItems(pickCfg.items)

PickUpButton.edit.onClick = function()
  if pickUpInterface:isVisible() then
    pickUpInterface:hide()
    PickUpButton.edit:setText("Show")
  else
    pickUpInterface:show()
    PickUpButton.edit:setText("Hide")
  end
end

local CheckPOS = 1

local pickUpMacro = macro(200, function()
  if not config.enabled then return end

  local pickUpIds = properTable(config.pickUpItems)
  local containerIds = properTable(config.containerPickUpItems)

  if #pickUpIds == 0 or #containerIds == 0 then return end

  for x = -CheckPOS, CheckPOS do
    for y = -CheckPOS, CheckPOS do
      local tile = g_map.getTile({x = posx() + x, y = posy() + y, z = posz()})
      if tile then
        for _, item in pairs(tile:getThings()) do
          if table.find(pickUpIds, item:getId()) then
            for _, container in pairs(getContainers()) do
              local cItem = container:getContainerItem()
              if cItem and table.find(containerIds, cItem:getId()) then
                g_game.move(item, container:getSlotPosition(container:getItemsCount()), item:getCount())
                return
              end
            end
          end
        end
      end
    end
  end
end)

--========================================================
-- PUSH ALL
--========================================================
local switchPushAll = "pushAllButton"

charStorage[switchPushAll] = charStorage[switchPushAll] or {
  enabled = false
}

local pushAllCfg = charStorage[switchPushAll]

pushAllButton = setupUI([[
Panel
  height: 19
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Pull Nearby Items
    height: 18
    color: white
]])

pushAllButton:setId(switchPushAll)
pushAllButton.title:setOn(pushAllCfg.enabled)

pushAllButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  pushAllCfg.enabled = newState
  saveThisCharStorage()
end

macro(100, function()
  if not pushAllCfg.enabled then return end

  for _, tile in pairs(g_map.getTiles(posz())) do
    local tilePos = tile:getPosition()
    if distanceFromPlayer(tilePos) == 1 then
      local top = tile:getTopUseThing()
      if top and not top:isNotMoveable() then
        if distanceFromPlayer(tilePos) > 1 then return end
        g_game.move(top, pos(), top:getCount())
        return
      end
    end
  end
end)

--========================================================
-- FULL TANK
--========================================================
UI.Separator()

if not loadCharStorage or not saveCharStorage then
  return print("[FullTank] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function saveFullTank()
  saveCharStorage(charStorage)
end

local STORAGE_KEY = "lnsFullTank"

charStorage[STORAGE_KEY] = charStorage[STORAGE_KEY] or {
  enabled = false,
  ringId = 3048,   -- might ring
  amuletId = 3081, -- ssa
  hotkey = "F12"
}

local cfg = charStorage[STORAGE_KEY]

local FULL_SLOT_NECK = SlotNeck or 2
local FULL_SLOT_FINGER = SlotFinger or 9
local FULL_IS_OLD_CLIENT = g_game.getClientVersion() < 960
local FULL_ACTION_DELAY = FULL_IS_OLD_CLIENT and 250 or 0

local ui = setupUI([[
Panel
  height: 60

  Label
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 18
    text-align: center
    text: FULL TANK
    visible: false
    color: white
    font: verdana-11px-rounded

  BotItem
    id: ringItem
    anchors.top: title.top
    anchors.horizontalCenter: parent.horizontalCenter
    margin-right: 18
    margin-top: 0
    tooltip: ID RING

  BotItem
    id: amuletItem
    anchors.top: title.top
    anchors.left: ringItem.right
    margin-left: 8
    margin-top: 0
    tooltip: ID AMULET

  BotSwitch
    id: enable
    anchors.top: ringItem.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 19
    margin-top: 6
    margin-right: 40
    color: white
    text: Full Equip

  BotTextEdit
    id: hotkey
    anchors.top: ringItem.bottom
    anchors.left: prev.right
    anchors.right: parent.right
    height: 19
    margin-top: 6
    margin-left: 3
    text: F12
]], parent)

local function getBotItemId(widget)
  if not widget then return 0 end

  if widget.getItemId then
    local id = tonumber(widget:getItemId()) or 0
    if id > 0 then return id end
  end

  if widget.getItem then
    local item = widget:getItem()
    if type(item) == "number" then return item end
    if item and item.getId then return tonumber(item:getId()) or 0 end
  end

  return 0
end

local function setBotItemId(widget, itemId)
  itemId = tonumber(itemId) or 0
  if not widget then return end

  if widget.setItemId then
    widget:setItemId(itemId)
  elseif widget.setItem then
    widget:setItem(itemId)
  end
end

local function fullGetContainers()
  if type(getContainers) == "function" then
    return getContainers() or {}
  end

  if g_game and type(g_game.getContainers) == "function" then
    return g_game.getContainers() or {}
  end

  return {}
end

local function fullFindItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  if type(findItem) == "function" then
    local item = findItem(id)
    if item then return item end
  end

  for _, container in ipairs(fullGetContainers()) do
    for _, item in ipairs(container:getItems() or {}) do
      if item and item.getId and tonumber(item:getId()) == id then
        return item
      end
    end
  end

  return nil
end

local function fullGetSlotId(slot)
  local item = getSlot(slot)
  if item and item.getId then
    return tonumber(item:getId()) or 0
  end
  return 0
end

local function fullEquipToSlot(itemId, slot)
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return false end

  if not FULL_IS_OLD_CLIENT then
    local ok = pcall(function()
      g_game.equipItemId(itemId)
    end)

    if ok then return true end

    ok = pcall(function()
      g_game.equipItemId(itemId)
    end)

    return ok
  end

  local item = fullFindItemById(itemId)
  if not item then return false end

  local ok = pcall(function()
    g_game.move(item, {x = 65535, y = slot, z = 0}, 1)
  end)

  return ok
end

local function setFullTankEnabled(state)
  cfg.enabled = state == true

  ui.enable:setOn(cfg.enabled)
  ui.enable:setText(cfg.enabled and "Full Equip" or "Full Equip")

  saveFullTank()
end

setBotItemId(ui.ringItem, cfg.ringId or 3048)
setBotItemId(ui.amuletItem, cfg.amuletId or 3081)
ui.enable:setOn(cfg.enabled == true)
ui.enable:setText(cfg.enabled and "Full Equip" or "Full Equip")
ui.hotkey:setText(cfg.hotkey or "F12")

ui.enable.onClick = function(widget)
  setFullTankEnabled(not widget:isOn())
end

ui.ringItem.onItemChange = function(widget)
  cfg.ringId = getBotItemId(widget)
  saveFullTank()
end

ui.amuletItem.onItemChange = function(widget)
  cfg.amuletId = getBotItemId(widget)
  saveFullTank()
end

ui.hotkey.onTextChange = function(widget, text)
  cfg.hotkey = tostring(text or ""):upper():gsub("%s+", "")
  widget:setText(cfg.hotkey)
  saveFullTank()
end

local function isHotkeyPressed()
  local key = tostring(cfg.hotkey or ""):upper():gsub("%s+", "")
  if key == "" then return false end

  if not g_keyboard or not g_keyboard.isKeyPressed then
    return false
  end

  return g_keyboard.isKeyPressed(key) or g_keyboard.isKeyPressed(key:lower())
end

local lastHotkey = 0

macro(20, function()
  if isHotkeyPressed() and now - lastHotkey > 350 then
    lastHotkey = now
    setFullTankEnabled(not cfg.enabled)
  end
end)

local nextEquipAction = 0
pauseSwapRing = pauseSwapRing or 0
local nextEquipAction = 0

macro(20, function()
  if cfg.enabled ~= true then return end
  if now < nextEquipAction then return end

  local ringId = tonumber(cfg.ringId) or 0
  local amuletId = tonumber(cfg.amuletId) or 0

  if not FULL_IS_OLD_CLIENT then
    if ringId > 0 and fullGetSlotId(FULL_SLOT_FINGER) ~= ringId then
      pcall(function()
        g_game.equipItemId(ringId, FULL_SLOT_FINGER)
      end)
    end

    if amuletId > 0 and fullGetSlotId(FULL_SLOT_NECK) ~= amuletId then
      pcall(function()
        g_game.equipItemId(amuletId, FULL_SLOT_NECK)
      end)
    end

    return
  end

  -- old client: precisa mover um por vez para evitar bug/exhaust
  if ringId > 0 and fullGetSlotId(FULL_SLOT_FINGER) ~= ringId then
    if fullEquipToSlot(ringId, FULL_SLOT_FINGER) then
      nextEquipAction = now + FULL_ACTION_DELAY
      return
    end
  end

  if amuletId > 0 and fullGetSlotId(FULL_SLOT_NECK) ~= amuletId then
    if fullEquipToSlot(amuletId, FULL_SLOT_NECK) then
      nextEquipAction = now + FULL_ACTION_DELAY
      return
    end
  end
end)

--========================================================
-- DOUBLE UE
--========================================================
UI.Separator()

if not loadCharStorage or not saveCharStorage then
  return print("[Double UE] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

lnsDoubleUE = lnsDoubleUE or {}
lnsDoubleUE.panelName = "doubleUEInterface"

charStorage[lnsDoubleUE.panelName] = charStorage[lnsDoubleUE.panelName] or {
  switches = {},
  checks = {},
  texts = {},
  items = {}
}

charStorage[lnsDoubleUE.panelName].switches = charStorage[lnsDoubleUE.panelName].switches or {}
charStorage[lnsDoubleUE.panelName].checks   = charStorage[lnsDoubleUE.panelName].checks or {}
charStorage[lnsDoubleUE.panelName].texts    = charStorage[lnsDoubleUE.panelName].texts or {}
charStorage[lnsDoubleUE.panelName].items    = charStorage[lnsDoubleUE.panelName].items or {}

if charStorage[lnsDoubleUE.panelName].items.potionItem == nil and charStorage[lnsDoubleUE.panelName].items.ringItem ~= nil then
  charStorage[lnsDoubleUE.panelName].items.potionItem = charStorage[lnsDoubleUE.panelName].items.ringItem
  charStorage[lnsDoubleUE.panelName].items.ringItem = nil
end

lnsDoubleUE.save = function()
  saveCharStorage(charStorage)
end

doubleUE = setupUI([[
Panel
  height: 130

  Label
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-auto-resize: true
    text-align: center
    margin-top: 10
    text: Pot Cooldown:
    color: white
    font: verdana-11px-rounded

  BotItem
    id: potionItem
    anchors.verticalCenter: prev.verticalCenter
    anchors.right: parent.right
    margin-top: 0

  Label
    id: spellLabel
    anchors.top: prev.bottom
    anchors.left: title.left
    margin-top: 1
    text: Spell:
    text-auto-resize: true
    color: white
    font: verdana-11px-rounded

  BotTextEdit
    id: spellEdit
    anchors.left: prev.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 3
    
  Label
    id: hotkeyLabel
    anchors.top: prev.bottom
    anchors.left: title.left
    margin-top: 5
    text: Atalho:
    text-auto-resize: true
    color: white
    font: verdana-11px-rounded

  BotTextEdit
    id: hotkeyEdit
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    width: 80

  BotSwitch
    id: ativarDoubleUE
    anchors.top: prev.bottom
    anchors.left: title.left
    anchors.right: prev.right
    margin-top: 5
    text: Active Double UE

  CheckBox
    id: ativarAvatar
    anchors.top: prev.bottom
    anchors.left: prev.left
    text: Auto Avatar
    margin-top: 5
    size: 100 20
    text-align: verticalCenter

]], parent)

lnsDoubleUE.getWidget = function(id)
  if not doubleUE then return nil end
  if doubleUE.recursiveGetChildById then
    return doubleUE:recursiveGetChildById(id)
  end
  return doubleUE[id]
end

lnsDoubleUE.bindSwitch = function(id)
  lnsDoubleUE.widget = lnsDoubleUE.getWidget(id)
  if not lnsDoubleUE.widget then
    warn("[Double UE] bindSwitch nao encontrou widget: " .. tostring(id))
    return
  end

  if charStorage[lnsDoubleUE.panelName].switches[id] ~= nil then
    lnsDoubleUE.widget:setOn(charStorage[lnsDoubleUE.panelName].switches[id] == true)
  else
    charStorage[lnsDoubleUE.panelName].switches[id] = lnsDoubleUE.widget:isOn() == true
    lnsDoubleUE.save()
  end

  lnsDoubleUE.widget.onClick = function(widget)
    lnsDoubleUE.state = not widget:isOn()
    widget:setOn(lnsDoubleUE.state)
    charStorage[lnsDoubleUE.panelName].switches[id] = lnsDoubleUE.state
    lnsDoubleUE.save()
  end
end

lnsDoubleUE.bindCheck = function(id)
  lnsDoubleUE.widget = lnsDoubleUE.getWidget(id)
  if not lnsDoubleUE.widget then
    warn("[Double UE] bindCheck nao encontrou widget: " .. tostring(id))
    return
  end

  if charStorage[lnsDoubleUE.panelName].checks[id] ~= nil then
    lnsDoubleUE.widget:setChecked(charStorage[lnsDoubleUE.panelName].checks[id] == true)
  else
    charStorage[lnsDoubleUE.panelName].checks[id] = lnsDoubleUE.widget:isChecked() == true
    lnsDoubleUE.save()
  end

  lnsDoubleUE.widget.onCheckChange = function(widget, checked)
    charStorage[lnsDoubleUE.panelName].checks[id] = checked == true
    lnsDoubleUE.save()
  end
end

lnsDoubleUE.bindText = function(id)
  lnsDoubleUE.widget = lnsDoubleUE.getWidget(id)
  if not lnsDoubleUE.widget then
    warn("[Double UE] bindText nao encontrou widget: " .. tostring(id))
    return
  end

  if charStorage[lnsDoubleUE.panelName].texts[id] ~= nil then
    lnsDoubleUE.widget:setText(tostring(charStorage[lnsDoubleUE.panelName].texts[id]))
  else
    charStorage[lnsDoubleUE.panelName].texts[id] = lnsDoubleUE.widget:getText() or ""
    lnsDoubleUE.save()
  end

  lnsDoubleUE.widget.onTextChange = function(widget, text)
    charStorage[lnsDoubleUE.panelName].texts[id] = tostring(text or widget:getText() or "")
    lnsDoubleUE.save()
  end
end

lnsDoubleUE.readBotItemId = function(widget)
  if not widget then return 0 end

  if widget.getItemId then
    lnsDoubleUE.tmpItemId = tonumber(widget:getItemId()) or 0
    if lnsDoubleUE.tmpItemId > 0 then
      return lnsDoubleUE.tmpItemId
    end
  end

  if widget.getItem and widget:getItem() then
    lnsDoubleUE.tmpItemObj = widget:getItem()

    if lnsDoubleUE.tmpItemObj and lnsDoubleUE.tmpItemObj.getId then
      lnsDoubleUE.tmpItemId = tonumber(lnsDoubleUE.tmpItemObj:getId()) or 0
      if lnsDoubleUE.tmpItemId > 0 then
        return lnsDoubleUE.tmpItemId
      end
    end
  end

  return 0
end

lnsDoubleUE.bindItem = function(id)
  lnsDoubleUE.widget = lnsDoubleUE.getWidget(id)
  if not lnsDoubleUE.widget then
    warn("[Double UE] bindItem nao encontrou widget: " .. tostring(id))
    return
  end

  lnsDoubleUE.savedItem = tonumber(charStorage[lnsDoubleUE.panelName].items[id]) or 0

  if lnsDoubleUE.savedItem > 0 then
    lnsDoubleUE.widget:setItemId(lnsDoubleUE.savedItem)
  else
    lnsDoubleUE.itemId = lnsDoubleUE.readBotItemId(lnsDoubleUE.widget)

    if lnsDoubleUE.itemId > 0 then
      charStorage[lnsDoubleUE.panelName].items[id] = lnsDoubleUE.itemId
      lnsDoubleUE.save()
    end
  end

  lnsDoubleUE.widget.onItemChange = function(widget)
    lnsDoubleUE.itemId = lnsDoubleUE.readBotItemId(widget)

    if lnsDoubleUE.itemId > 0 then
      charStorage[lnsDoubleUE.panelName].items[id] = lnsDoubleUE.itemId
      lnsDoubleUE.save()
    end
  end

  lnsDoubleUE.widget.onItemIdChange = function(widget, itemId)
    lnsDoubleUE.itemId = tonumber(itemId) or 0

    if lnsDoubleUE.itemId <= 0 then
      lnsDoubleUE.itemId = lnsDoubleUE.readBotItemId(widget)
    end

    if lnsDoubleUE.itemId > 0 then
      charStorage[lnsDoubleUE.panelName].items[id] = lnsDoubleUE.itemId
      lnsDoubleUE.save()
    end
  end

  macro(100, function()
    lnsDoubleUE.itemWidget = lnsDoubleUE.getWidget(id)
    if not lnsDoubleUE.itemWidget then return end

    lnsDoubleUE.itemId = lnsDoubleUE.readBotItemId(lnsDoubleUE.itemWidget)
    if lnsDoubleUE.itemId <= 0 then return end

    if tonumber(charStorage[lnsDoubleUE.panelName].items[id]) == lnsDoubleUE.itemId then return end

    charStorage[lnsDoubleUE.panelName].items[id] = lnsDoubleUE.itemId
    lnsDoubleUE.save()
  end)
end

lnsDoubleUE.bindItem("potionItem")
lnsDoubleUE.bindText("spellEdit")
lnsDoubleUE.bindText("hotkeyEdit")
lnsDoubleUE.bindSwitch("ativarDoubleUE")
lnsDoubleUE.bindCheck("ativarAvatar")

lnsDoubleUE.trim = function(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

lnsDoubleUE.enabled = function()
  return charStorage[lnsDoubleUE.panelName]
    and charStorage[lnsDoubleUE.panelName].switches
    and charStorage[lnsDoubleUE.panelName].switches.ativarDoubleUE == true
end

lnsDoubleUE.avatarEnabled = function()
  return charStorage[lnsDoubleUE.panelName]
    and charStorage[lnsDoubleUE.panelName].checks
    and charStorage[lnsDoubleUE.panelName].checks.ativarAvatar == true
end

lnsDoubleUE.getSpell = function()
  return lnsDoubleUE.trim(charStorage[lnsDoubleUE.panelName].texts.spellEdit or "")
end

lnsDoubleUE.getHotkey = function()
  return lnsDoubleUE.trim(charStorage[lnsDoubleUE.panelName].texts.hotkeyEdit or "")
end

lnsDoubleUE.getPotion = function()
  lnsDoubleUE.potionWidget = lnsDoubleUE.getWidget("potionItem")

  if lnsDoubleUE.potionWidget then
    lnsDoubleUE.potionId = lnsDoubleUE.readBotItemId(lnsDoubleUE.potionWidget)

    if lnsDoubleUE.potionId > 0 then
      charStorage[lnsDoubleUE.panelName].items.potionItem = lnsDoubleUE.potionId
      return lnsDoubleUE.potionId
    end
  end

  return tonumber(charStorage[lnsDoubleUE.panelName].items.potionItem) or 0
end

lnsDoubleUE.vocationsMap = {
  [1] = "Knight",
  [2] = "Paladin",
  [3] = "Sorcerer",
  [4] = "Druid",
  [5] = "Monk",
  [6] = "Elite Knight",
  [7] = "Royal Paladin",
  [8] = "Master Sorcerer",
  [9] = "Elder Druid",
  [10] = "Exalted Monk"
}

lnsDoubleUE.avatarSpellByVoc = {
  knight = "uteta res eq",
  paladin = "uteta res sac",
  sorcerer = "uteta res ven",
  druid = "uteta res dru",
  monk = "uteta res tio"
}

lnsDoubleUE.getVocationType = function(playerObj)
  if not playerObj then return "knight" end

  lnsDoubleUE.vocId = playerObj:getVocation()
  lnsDoubleUE.vocName = lnsDoubleUE.vocationsMap[lnsDoubleUE.vocId] or "Unknown"

  if lnsDoubleUE.vocName == "Knight" or lnsDoubleUE.vocName == "Elite Knight" then
    return "knight"
  end

  if lnsDoubleUE.vocName == "Paladin" or lnsDoubleUE.vocName == "Royal Paladin" then
    return "paladin"
  end

  if lnsDoubleUE.vocName == "Sorcerer" or lnsDoubleUE.vocName == "Master Sorcerer" then
    return "sorcerer"
  end

  if lnsDoubleUE.vocName == "Druid" or lnsDoubleUE.vocName == "Elder Druid" then
    return "druid"
  end

  if lnsDoubleUE.vocName == "Monk" or lnsDoubleUE.vocName == "Exalted Monk" then
    return "monk"
  end

  return "knight"
end

lnsDoubleUE.getAvatarSpell = function()
  lnsDoubleUE.playerObj = g_game.getLocalPlayer()
  if not lnsDoubleUE.playerObj then return "" end

  lnsDoubleUE.vocType = lnsDoubleUE.getVocationType(lnsDoubleUE.playerObj)
  return lnsDoubleUE.avatarSpellByVoc[lnsDoubleUE.vocType] or lnsDoubleUE.avatarSpellByVoc.knight or ""
end

lnsDoubleUE.lastCast = 0
lnsDoubleUE.keyDown = false

lnsDoubleUE.usePotion = function(itemId)
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return false end

  lnsDoubleUE.localPlayer = g_game.getLocalPlayer()
  if not lnsDoubleUE.localPlayer then return false end

  use(itemId)
  return true
end

lnsDoubleUE.execute = function()
  if not lnsDoubleUE.enabled() then return end
  if lnsDoubleUE.lastCast > now then return end

  lnsDoubleUE.spell = lnsDoubleUE.getSpell()
  lnsDoubleUE.potionId = lnsDoubleUE.getPotion()

  if lnsDoubleUE.spell == "" then return end
  if lnsDoubleUE.potionId <= 0 then
    warn("[Double UE] Potion ID invalido no BotItem.")
    return
  end

  lnsDoubleUE.lastCast = now + 200

  if lnsDoubleUE.avatarEnabled() then
    lnsDoubleUE.avatarSpell = lnsDoubleUE.getAvatarSpell()
    if lnsDoubleUE.avatarSpell ~= "" then
      say(lnsDoubleUE.avatarSpell)
    end
  end

  say(lnsDoubleUE.spell)
  lnsDoubleUE.usePotion(lnsDoubleUE.potionId)
  say(lnsDoubleUE.spell)
end

lnsDoubleUE.iconExecute = function()
  if not lnsDoubleUE or not lnsDoubleUE.panelName then return end
  if not charStorage or not charStorage[lnsDoubleUE.panelName] then return end
  if not charStorage[lnsDoubleUE.panelName].switches then return end

  local oldState = charStorage[lnsDoubleUE.panelName].switches.ativarDoubleUE

  -- libera a execução só nesse clique
  charStorage[lnsDoubleUE.panelName].switches.ativarDoubleUE = true

  if lnsDoubleUE.execute then
    lnsDoubleUE.execute()
  end

  -- volta para o estado original, então não deixa a script ligada
  charStorage[lnsDoubleUE.panelName].switches.ativarDoubleUE = oldState == true
end

macro(20, function()
  if not lnsDoubleUE.enabled() then
    lnsDoubleUE.keyDown = false
    return
  end

  lnsDoubleUE.key = lnsDoubleUE.getHotkey()

  if lnsDoubleUE.key == "" then
    lnsDoubleUE.keyDown = false
    return
  end

  if not g_keyboard or not g_keyboard.isKeyPressed then return end

  lnsDoubleUE.pressed = g_keyboard.isKeyPressed(lnsDoubleUE.key)

  if not lnsDoubleUE.pressed then
    lnsDoubleUE.keyDown = false
    return
  end

  if lnsDoubleUE.keyDown then return end

  lnsDoubleUE.keyDown = true
  lnsDoubleUE.execute()
end)


--========================================================
-- EXIVAS
--========================================================
UI.Separator()

charStorage = charStorage or loadCharStorage()

local function saveExivaChar()
  saveCharStorage(charStorage)
end

local exivaTargetSwitch = "exivaTargetSwitch"
local xExivaSwitch      = "xExivaSwitch"
local exivaArrowSwitch  = "exivaArrowSwitch"

charStorage[exivaTargetSwitch] = charStorage[exivaTargetSwitch] or { enabled = false }
charStorage[xExivaSwitch]      = charStorage[xExivaSwitch] or { enabled = false }
charStorage[exivaArrowSwitch]  = charStorage[exivaArrowSwitch] or { enabled = true }

charStorage.Sense       = charStorage.Sense or false
charStorage.SenseTarget = charStorage.SenseTarget or false

exivaInterface = setupUI([[
Panel
  height: 53

  BotSwitch
    id: exivaTarget
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Exiva Target
    height: 18
    color: white

  BotSwitch
    id: xExiva
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: xExiva
    height: 18
    color: white

  BotSwitch
    id: exivaArrow
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Show Animation Exiva
    height: 18
    color: white
]])
exivaInterface:show()

-- =========================
-- HELPERS
-- =========================
local Directions = {
  ["east"]       = {x = 1,  y = 0},
  ["west"]       = {x = -1, y = 0},
  ["north"]      = {x = 0,  y = -1},
  ["south"]      = {x = 0,  y = 1},
  ["north-east"] = {x = 1,  y = -1},
  ["north-west"] = {x = -1, y = -1},
  ["south-east"] = {x = 1,  y = 1},
  ["south-west"] = {x = -1, y = 1},
}

local EXIVA_DIR_REGEX = "(south-east|north-east|south-west|north-west|north|south|west|east)"
local EXIVA_NAME_DIR_REGEX = "(.+) is to the (south-east|north-east|south-west|north-west|north|south|west|east)"

local CurrentDirection = nil
local VirtualTargetPos = nil
local LastExivaMode = nil
local LastAnimName = nil
local LastSenseAt = 0
local LastAnimAt = 0

local SHOOT_DELAY = 160
local EXIVA_DELAY = 2300
local PROJECT_DISTANCE = 30
local MISSILE_ID = 9

local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function nowMs()
  if type(now) == "number" then return now end
  if g_clock and g_clock.millis then return g_clock.millis() end
  return os.time() * 1000
end

local function getPlayerByNameSafe(name)
  name = trim(name):lower()
  if name == "" then return nil end

  local specs = getSpectators(pos(), false)
  if not specs then return nil end

  for _, spec in ipairs(specs) do
    if spec and spec:isPlayer() and spec:getName() and spec:getName():lower() == name then
      return spec
    end
  end

  return nil
end

local function getProjectedPos(direction, dist)
  local dir = Directions[direction]
  if not dir then return nil end
  dist = dist or PROJECT_DISTANCE

  return {
    x = posx() + (dir.x * dist),
    y = posy() + (dir.y * dist),
    z = posz()
  }
end

local function refreshVirtualTarget()
  if not CurrentDirection then
    VirtualTargetPos = nil
    return
  end
  VirtualTargetPos = getProjectedPos(CurrentDirection, PROJECT_DISTANCE)
end

local function shootEffect(targetPos)
  if not targetPos then return end

  local effect = Missile.create()
  if not effect then return end

  effect:setId(MISSILE_ID)
  effect:setPath(pos(), targetPos)
  g_map.addThing(effect, pos())
end

local function clearAnimation()
  CurrentDirection = nil
  VirtualTargetPos = nil
  LastAnimName = nil
  LastExivaMode = nil
end

local function setAnimationTarget(name, mode)
  LastAnimName = trim(name or "")
  LastExivaMode = mode
end

-- =========================
-- UI BINDS
-- =========================
exivaInterface.exivaTarget:setOn(charStorage[exivaTargetSwitch].enabled)
exivaInterface.exivaTarget.onClick = function(widget)
  charStorage[exivaTargetSwitch].enabled = not charStorage[exivaTargetSwitch].enabled
  widget:setOn(charStorage[exivaTargetSwitch].enabled)
  saveExivaChar()
end

exivaInterface.xExiva:setOn(charStorage[xExivaSwitch].enabled)
exivaInterface.xExiva.onClick = function(widget)
  charStorage[xExivaSwitch].enabled = not charStorage[xExivaSwitch].enabled
  widget:setOn(charStorage[xExivaSwitch].enabled)
  saveExivaChar()
end

exivaInterface.exivaArrow:setOn(charStorage[exivaArrowSwitch].enabled)
exivaInterface.exivaArrow.onClick = function(widget)
  charStorage[exivaArrowSwitch].enabled = not charStorage[exivaArrowSwitch].enabled
  widget:setOn(charStorage[exivaArrowSwitch].enabled)

  if not charStorage[exivaArrowSwitch].enabled then
    clearAnimation()
  end

  saveExivaChar()
end

-- =========================
-- EXIVA TARGET
-- =========================
macro(200, function()
  if not charStorage[exivaTargetSwitch].enabled then return end

  local target = g_game.getAttackingCreature()
  if target and target:isPlayer() then
    charStorage.SenseTarget = target:getName()
    saveExivaChar()
  end

  if not charStorage.SenseTarget or charStorage.SenseTarget == "" then return end

  local creature = getPlayerByNameSafe(charStorage.SenseTarget)
  if not (creature and creature:getPosition().z == player:getPosition().z and getDistanceBetween(pos(), creature:getPosition()) <= 6) then
    LastExivaMode = "target"
    say('exiva "' .. charStorage.SenseTarget)
    LastSenseAt = nowMs()
    delay(2300)
  end
end)

-- =========================
-- xEXIVA
-- =========================
macro(200, function()
  if not charStorage[xExivaSwitch].enabled then return end
  if not charStorage.Sense or charStorage.Sense == "" then return end

  local creature = getPlayerByNameSafe(charStorage.Sense)
  if not (creature and creature:getPosition().z == player:getPosition().z and getDistanceBetween(pos(), creature:getPosition()) <= 6) then
    LastExivaMode = "manual"
    say('exiva "' .. charStorage.Sense)
    LastSenseAt = nowMs()
    delay(2300)
  end
end)

-- =========================
-- xNOME
-- =========================
onTalk(function(name, level, mode, text, channelId, talkPos)
  if name ~= player:getName() then return end
  if type(text) ~= "string" or text:len() < 1 then return end

  if text:sub(1, 1):lower() == "x" then
    local checkMsg = trim(text:sub(2))

    if checkMsg == "0" then
      charStorage.Sense = false
    elseif checkMsg ~= "" then
      charStorage.Sense = checkMsg
    end

    saveExivaChar()
  end
end)

-- =========================
-- RESULTADO DO EXIVA
-- =========================
onTextMessage(function(mode, text)
  text = tostring(text or "")

  local byName = regexMatch(text, EXIVA_NAME_DIR_REGEX)
  if byName and #byName > 0 then
    for _, v in pairs(byName) do
      local sensedName = trim(v[2] or "")
      local dir = trim(v[3] or "")

      if sensedName ~= "" then
        if LastExivaMode == "target" and charStorage[exivaTargetSwitch].enabled then
          setAnimationTarget(sensedName, "target")
        elseif LastExivaMode == "manual" and charStorage[xExivaSwitch].enabled then
          setAnimationTarget(sensedName, "manual")
        else
          setAnimationTarget(sensedName, LastExivaMode)
        end
      end

      if dir ~= "" then
        CurrentDirection = dir
        refreshVirtualTarget()
      end
    end
    return
  end

  local onlyDir = regexMatch(text, EXIVA_DIR_REGEX)
  if onlyDir and #onlyDir > 0 then
    for _, v in pairs(onlyDir) do
      local dir = trim(v[2] or "")
      if dir ~= "" then
        CurrentDirection = dir
        refreshVirtualTarget()

        if LastExivaMode == "target" and charStorage[exivaTargetSwitch].enabled then
          setAnimationTarget(charStorage.SenseTarget, "target")
        elseif LastExivaMode == "manual" and charStorage[xExivaSwitch].enabled then
          setAnimationTarget(charStorage.Sense, "manual")
        end
      end
    end
  end
end)

-- =========================
-- ANIMAÇÃO CONTÍNUA
-- =========================
macro(100, function()
  if not charStorage[exivaArrowSwitch].enabled then return end
  if not LastAnimName or LastAnimName == "" then return end
  if not CurrentDirection then return end

  if LastExivaMode == "target" and not charStorage[exivaTargetSwitch].enabled then return end
  if LastExivaMode == "manual" and not charStorage[xExivaSwitch].enabled then return end

  local targetPos = nil

  -- prioridade: alvo real visível
  local realTarget = getPlayerByNameSafe(LastAnimName)
  if realTarget and realTarget:getPosition() then
    targetPos = realTarget:getPosition()
  end

  -- fallback: posição virtual da direção do último exiva
  if not targetPos then
    if not VirtualTargetPos and CurrentDirection then
      refreshVirtualTarget()
    end
    targetPos = VirtualTargetPos
  end

  if not targetPos then return end
  if nowMs() - LastAnimAt < SHOOT_DELAY then return end

  LastAnimAt = nowMs()
  shootEffect(targetPos)
end)

-- =========================
-- RESET
-- =========================
if g_keyboard and g_keyboard.bindKeyDown then
  g_keyboard.bindKeyDown("Escape", function()
    charStorage.SenseTarget = false
    saveExivaChar()
    clearAnimation()
  end)
end
end)

lnsRunBlock("BOSS_RAGNAR", function()
  local KEY = "lnsBossTimers"
storage[KEY] = storage[KEY] or {
  bosses = {},
  autoCaveEnabled = false,
  autoCaveName = ""
}

local cfg = storage[KEY]
cfg.bosses = cfg.bosses or {}
cfg.autoCaveEnabled = cfg.autoCaveEnabled == true
cfg.autoCaveName = cfg.autoCaveName or ""

local editingIndex = nil

local function save()
  storage[KEY] = cfg
end

local function trim(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function fmt(sec)
  sec = math.max(0, tonumber(sec) or 0)
  local h = math.floor(sec / 3600)
  local m = math.floor((sec % 3600) / 60)
  local s = sec % 60
  if h > 0 then return string.format("%02d:%02d:%02d", h, m, s) end
  return string.format("%02d:%02d", m, s)
end

g_ui.loadUIFromString([[
BossTimerRow < UIWidget
  height: 26
  focusable: true
  background-color: alpha
  opacity: 1.00
  margin-top: 2

  $hover:
    background-color: #2a2a2a

  CheckBox
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 3
    margin-top: 3
    width: 18
    height: 18

  Label
    id: bossName
    anchors.left: enabled.right
    anchors.right: parent.right
    anchors.top: parent.top
    margin-left: 5
    margin-top: 0
    color: white
    text-auto-resize: true

  Label
    id: status
    anchors.left: bossName.left
    anchors.right: parent.right
    anchors.top: bossName.bottom
    margin-top: 2
    color: green
    font: cipsoftFont
    text-auto-resize: true

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 3
    size: 18 18
    text: X
    color: white
]])

local function destroyOldWindow(id)
  local root = g_ui.getRootWidget()
  if not root then return end

  local old = root:recursiveGetChildById(id)
  while old do
    old:destroy()
    old = root:recursiveGetChildById(id)
  end
end

destroyOldWindow("bossWindow")
destroyOldWindow("addBossWindow")

local main = setupUI([[
MiniWindow
  id: bossWindow
  size: 180 300
  text: [LNS] Boss Timers
  opacity: 1.00
  icon: /images/topbuttons/motd
  icon-size: 15 15

  MiniWindowContents
    id: contentsPanel

    Button
      id: addBoss
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 3
      margin-left: 2
      margin-right: 2
      height: 20
      text: ADD NEW BOSS
      font: cipsoftFont

    BotSwitch
      id: ativarBoss
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      height: 20
      text: Active Auto Boss

    BotTextEdit
      id: cavebotBoss
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      placeholder: Name Cavebot Boss
      text-align: left

    HorizontalSeparator
      id: sep
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5

    TextList
      id: bossList
      anchors.top: sep.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-top: 5
      margin-left: 2
      margin-right: 2
      margin-bottom: 2
      padding: 1
      vertical-scrollbar: bossScroll
      layout: verticalBox

    VerticalScrollBar
      id: bossScroll
      anchors.top: bossList.top
      anchors.bottom: bossList.bottom
      anchors.left: bossList.right
      step: 10
      pixels-scroll: true
      visible: true
]], g_ui.getRootWidget())

main.save = true
main:setup()
main:setContentMinimumHeight(120)
main:setContentMaximumHeight(500)

main:hide()

local add = setupUI([[
MainWindow
  id: addBossWindow
  size: 200 230
  anchors.centerIn: parent
  margin-top: -60
  text: Add Boss
  opacity: 1.00

  TextEdit
    id: name
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: -6
    margin-right: -6
    placeholder: Name boss

  Label
    anchors.top: name.bottom
    anchors.left: name.left
    margin-top: 8
    text: Cooldown:

  TextEdit
    id: h
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 5
    margin-left: -6
    size: 50 20
    placeholder: Hours

  TextEdit
    id: m
    anchors.top: h.top
    anchors.left: h.right
    margin-left: 15
    size: 50 20
    placeholder: Minutes

  TextEdit
    id: s
    anchors.top: h.top
    anchors.left: m.right
    margin-left: 15
    size: 50 20
    placeholder: Seconds

  Label
    anchors.top: h.bottom
    anchors.left: h.left
    margin-top: 8
    text: Active To:

  BotSwitch
    id: goLabel
    anchors.top: prev.bottom
    anchors.left: h.left
    margin-top: 5
    width: 90
    height: 18
    text: Go Label

  BotSwitch
    id: goCave
    anchors.top: goLabel.top
    anchors.right: parent.right
    margin-right: -6
    margin-top: 0
    width: 90
    height: 18
    text: Go Cave

  TextEdit
    id: target
    anchors.top: goLabel.bottom
    anchors.left: goLabel.left
    anchors.right: goCave.right
    margin-top: 5
    placeholder: Name Label or Cave

  Button
    id: ok
    anchors.top: target.bottom
    anchors.left: target.left
    anchors.right: target.right
    margin-top: 10
    text: INSERT
    font: cipsoftFont
    color: green

  Button
    id: close
    anchors.top: ok.bottom
    anchors.left: ok.left
    anchors.right: ok.right
    margin-top: 5
    text: CLOSE
    font: cipsoftFont
    color: gray
]], g_ui.getRootWidget())
add:hide()


local function runAction(b)
  local target = trim(b.target)
  if target == "" then return end

  if b.goLabel and CaveBot and CaveBot.gotoLabel then
    CaveBot.gotoLabel(target)
  elseif b.goCave and CaveBot and CaveBot.setCurrentProfile then
    CaveBot.setCurrentProfile(target)
  end
end

local function updateBossRow(row, b)
  if not row or not b then return end

  if b.enabled ~= true then
    row.status:setText("DESATIVADO")
    row.status:setColor("gray")
    return
  end

  local left = (tonumber(b.endTime) or 0) - os.time()

  if left > 0 then
    b.done = false
    row.status:setText("CD: [" .. fmt(left) .. "]")
    row.status:setColor("orange")
  else
    row.status:setText("DISPONIVEL")
    row.status:setColor("green")

    if (tonumber(b.endTime) or 0) > 0 and b.done ~= true then
      b.done = true
      save()
    end
  end
end

local function clearAdd()
  editingIndex = nil
  add.name:setText("")
  add.h:setText("")
  add.m:setText("")
  add.s:setText("")
  add.target:setText("")
  add.goLabel:setOn(false)
  add.goCave:setOn(false)
end

local function openEdit(index)
  local b = cfg.bosses[index]
  if not b then return end

  editingIndex = index

  local cd = tonumber(b.cooldown) or 0
  local h = math.floor(cd / 3600)
  local m = math.floor((cd % 3600) / 60)
  local s = cd % 60

  add.name:setText(b.name or "")
  add.h:setText(tostring(h))
  add.m:setText(tostring(m))
  add.s:setText(tostring(s))
  add.target:setText(b.target or "")
  add.goLabel:setOn(b.goLabel == true)
  add.goCave:setOn(b.goCave == true)
  add.ok:setText("SAVE")

  main:hide()
  add:show()
  add:raise()
  add:focus()
end

function rebuildBossList()
  if not main or not main.contentsPanel.bossList then return end
  main.contentsPanel.bossList:destroyChildren()

  for i, b in ipairs(cfg.bosses) do
    local row = g_ui.createWidget("BossTimerRow", main.contentsPanel.bossList)

    row.bossName:setText(tostring(b.name or "Boss"))
    row.enabled:setChecked(b.enabled ~= false)

    row.enabled.onClick = function(widget)
      b.enabled = not b.enabled
      widget:setChecked(b.enabled)
      save()
      updateBossRow(row, b)
    end

    row.remove.onClick = function()
      table.remove(cfg.bosses, i)
      save()
      rebuildBossList()
    end

    row.onDoubleClick = function()
      openEdit(i)
    end

    row.bossName.onDoubleClick = function()
      openEdit(i)
    end

    row.status.onDoubleClick = function()
      openEdit(i)
    end

    updateBossRow(row, b)
  end
end

add.goLabel:setOn(false)
add.goCave:setOn(false)

add.goLabel.onClick = function(widget)
  local state = not widget:isOn()
  widget:setOn(state)
  if state then add.goCave:setOn(false) end
end

add.goCave.onClick = function(widget)
  local state = not widget:isOn()
  widget:setOn(state)
  if state then add.goLabel:setOn(false) end
end

main.contentsPanel.addBoss.onClick = function()
  clearAdd()
  add:show()
  add:raise()
  add:focus()
end

add.close.onClick = function()
  add:hide()
  clearAdd()
end

add.ok.onClick = function()
  local name = trim(add.name:getText())
  if name == "" then return end

  local h = tonumber(add.h:getText()) or 0
  local m = tonumber(add.m:getText()) or 0
  local s = tonumber(add.s:getText()) or 0
  local cd = h * 3600 + m * 60 + s
  if cd <= 0 then return end

  local data = {
    name = name,
    cooldown = cd,
    endTime = editingIndex and (cfg.bosses[editingIndex].endTime or 0) or 0,
    enabled = editingIndex and (cfg.bosses[editingIndex].enabled ~= false) or true,
    goLabel = add.goLabel:isOn(),
    goCave = add.goCave:isOn(),
    target = trim(add.target:getText()),
    done = editingIndex and (cfg.bosses[editingIndex].done == true) or false
  }

  if editingIndex and cfg.bosses[editingIndex] then
    cfg.bosses[editingIndex] = data
  else
    table.insert(cfg.bosses, data)
  end

  save()
  add:hide()
  main:show()
  clearAdd()
  rebuildBossList()
end

macro(500, function()
  if not main or not main.contentsPanel.bossList then return end

  local children = main.contentsPanel.bossList:getChildren()
  for i, row in ipairs(children) do
    updateBossRow(row, cfg.bosses[i])
  end
end)

rebuildBossList()

local function normalizeBossName(s)
  s = tostring(s or ""):lower()
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  s = s:gsub("^a%s+", "")
  s = s:gsub("^an%s+", "")
  s = s:gsub("^the%s+", "")
  return s
end

local function setBossCooldownByName(name)
  local killName = normalizeBossName(name)

  for _, b in ipairs(cfg.bosses or {}) do
    if b.enabled == true and normalizeBossName(b.name) == killName then

      local left = (tonumber(b.endTime) or 0) - os.time()

      if left > 0 then
        return false
      end

      b.endTime = os.time() + (tonumber(b.cooldown) or 0)
      b.done = false

      save()
      rebuildBossList()

      return true
    end
  end

  return false
end

onTextMessage(function(mode, text)
  text = tostring(text or "")

  local bossName = text:match("[Ll]oot of ([^:]+):")
  if bossName then
    setBossCooldownByName(bossName)
  end
end)

local lastBossTarget = ""

macro(1000, function()
  local target = g_game.getAttackingCreature()

  if target then
    if target:getHealthPercent() <= 10 then
      lastBossTarget = target:getName()
    end
    return
  end

  if lastBossTarget ~= "" then
    setBossCooldownByName(lastBossTarget)
    lastBossTarget = ""
  end
end)

function checkerAutoBoss()
  for _, b in ipairs(cfg.bosses or {}) do
    if b.enabled == true then
      local left = (tonumber(b.endTime) or 0) - os.time()

      if left <= 0 then
        local target = trim(b.target)

        if target ~= "" then
          if b.goLabel == true and CaveBot and CaveBot.gotoLabel then
            CaveBot.gotoLabel(target)
            return true
          end

          if b.goCave == true and CaveBot then
            CaveBot.setOff()
            storage._configs = storage._configs or {}
            storage._configs.cavebot_configs = storage._configs.cavebot_configs or {}
            storage._configs.cavebot_configs.selected = target
            CaveBot.setOn()
            return true
          end
        end
      end
    end
  end

  return false
end

function LNS_SET_BOSS_WINDOW_VISIBLE(state)
  if not main then return end

  if state then
    if not main:isVisible() then
      main:show()
      main:raise()
      main:focus()
    end
  else
    if main:isVisible() then
      main:hide()
    end

    if add and add:isVisible() then
      add:hide()
    end
  end
end

main.contentsPanel.ativarBoss:setOn(cfg.autoCaveEnabled)
main.contentsPanel.cavebotBoss:setText(cfg.autoCaveName)

main.contentsPanel.ativarBoss.onClick = function(widget)
  local state = not widget:isOn()
  widget:setOn(state)
  cfg.autoCaveEnabled = state
  save()
end

main.contentsPanel.cavebotBoss.onTextChange = function(widget, text)
  cfg.autoCaveName = text
  save()
end


local function disableAutoBossButton()
  cfg.autoCaveEnabled = false
  save()

  if main and main.contentsPanel and main.contentsPanel.ativarBoss then
    main.contentsPanel.ativarBoss:setOn(false)
  end
end

local function turnOnTargetBot()
  if TargetBot and TargetBot.setOn then
    TargetBot.setOn()
  end
end

macro(500, function()
  if not cfg.autoCaveEnabled then return end
  if not CaveBot then return end

  local target = trim(cfg.autoCaveName)
  if target == "" then return end

  storage._configs = storage._configs or {}
  storage._configs.cavebot_configs = storage._configs.cavebot_configs or {}

  local current = storage._configs.cavebot_configs.selected or ""

  if current ~= target then
    CaveBot.setOff()

    modules.game_textmessage.displayGameMessage("Iniciando Auto Boss! by: LNS")

    storage._configs.cavebot_configs.selected = target

    CaveBot.setOn()
    turnOnTargetBot()

    disableAutoBossButton()
    return
  end

  if CaveBot.isOff and CaveBot.isOff() then
    modules.game_textmessage.displayGameMessage("Iniciando Auto Boss! by: LNS")
    CaveBot.setOn()
  end

  turnOnTargetBot()
  disableAutoBossButton()
end)


---------------------------------------
---------TASK RAGNAR
---------------------------------------
local switchTaskT = "taskButton"

if not loadCharStorage or not saveCharStorage then
  return print("[Task Tracker] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local STKEY = "lnsTaskTracker"
local HUD_STORAGE_KEY = "hudInterface"
local HUD_TASK_SWITCH_ID = "taskTracker"

local function saveTaskChar()
  saveCharStorage(charStorage)
end

charStorage[STKEY] = type(charStorage[STKEY]) == "table" and charStorage[STKEY] or {}
local st = charStorage[STKEY]

st.enabled = st.enabled ~= false
st.current = st.current or nil
st.kills = tonumber(st.kills or 0) or 0
st.required = tonumber(st.required or 0) or 0
st.progress = type(st.progress) == "table" and st.progress or {}

local function saveTaskStorage()
  charStorage[STKEY] = st
  charStorage.widgetPos = type(charStorage.widgetPos) == "table" and charStorage.widgetPos or {}
  saveTaskChar()
end

local function getLiveHudTaskSwitch()
  local widget = nil

  if hudInterface and hudInterface.recursiveGetChildById then
    widget = hudInterface:recursiveGetChildById(HUD_TASK_SWITCH_ID)
  end

  if (not widget) and g_ui and g_ui.getRootWidget then
    local root = g_ui.getRootWidget()
    if root and root.recursiveGetChildById then
      widget = root:recursiveGetChildById(HUD_TASK_SWITCH_ID)
    end
  end

  if widget and widget.isOn then
    return widget:isOn() == true
  end

  return nil
end

local function isTaskTrackerOn()
  local live = getLiveHudTaskSwitch()
  if live ~= nil then
    return live
  end

  -- Le o switch novo do HUD salvo no charStorage global: charStorage["hudInterface"].switches.taskTracker
  local hud = charStorage and charStorage[HUD_STORAGE_KEY]
  if type(hud) == "table" and type(hud.switches) == "table" then
    return hud.switches[HUD_TASK_SWITCH_ID] == true
  end

  -- Fallback apenas para quem usar esse arquivo separado, sem HUD carregado.
  return st.enabled == true
end

-- =========================
-- TASKS
-- =========================
local TASKS = {
  goblins = { label="Goblins", required=100, iconId=61, creatures={ "Goblin", "Goblin Assassin", "Goblin Leader", "Goblin Scavenger" } },
  trolls = { label="Trolls", required=100, iconId=15, creatures={ "Troll", "Swamp Troll", "Frost Troll", "Island Troll" } },
  orcs = { label="Orcs", required=250, iconId=5, creatures={ "Orc", "Orc Spearman", "Orc Warrior", "Orc Shaman", "Orc Rider", "Orc Berserker", "Orc Leader", "Orc Warlord" } },
  rotworms = { label="RotWorms", required=200, iconId=26, creatures={ "Rotworm", "Carrion Worm" } },
  minotaurs = { label="Minotaurs", required=300, iconId=25, creatures={ "Minotaur", "Minotaur Archer", "Minotaur Guard", "Minotaur Mage" } },
  dwarfs = { label="Dwarfs", required=300, iconId=69, creatures={ "Dwarf", "Dwarf Soldier", "Dwarf Guard", "Dwarf Geomancer" } },
  dworcs = { label="Dworcs", required=300, iconId=216, creatures={ "Dworc Venomsniper", "Dworc Voodoomaster", "Dworc Fleshhunter" } },
  elves = { label="Elves", required=400, iconId=62, creatures={ "Elf", "Elf Scout", "Elf Arcanist", "Firestarter" } }, -- Elf=62 :contentReference[oaicite:1]{index=1}
  dark_cathedral = { label="Dark Cathedral", required=500, iconId=372, creatures={ "Dark Apprentice", "Dark Magician", "Dark Monk", "Assassin", "Smuggler", "Bandit", "Wild Warrior", "Witch", "Ghost", "Hunter", "Stone Golem", "Demon Skeleton" } }, -- Dark Apprentice=372 :contentReference[oaicite:2]{index=2}
  tombs = { label="Tombs", required=800, iconId=85, creatures={ "Ghost", "Mummy", "Ghoul", "Demon Skeleton", "Skeleton", "Crypt Shambler" } },
  scarabs = { label="Scarabs", required=600, iconId=83, creatures={ "Scarab" } }, -- Scarab=83 :contentReference[oaicite:3]{index=3}
  cyclops = { label="Cyclops", required=500, iconId=22, creatures={ "Cyclops", "Cyclops Smith", "Cyclops Drone" } }, -- Cyclops=22 :contentReference[oaicite:4]{index=4}
  mutateds = { label="Mutateds", required=600, iconId=521, creatures={ "Mutated Human", "Mutated Bat", "Mutated Rat", "Mutated Tiger" } }, -- Mutated Human=521 :contentReference[oaicite:5]{index=5}
  coryms = { label="Coryms", required=400, iconId=916, creatures={ "Corym Charlatan", "Corym Skirmisher", "Corym Vanguard" } }, -- Corym Charlatan=916 :contentReference[oaicite:6]{index=6}
  banuta_surface = { label="Banuta Surface", required=600, iconId=116, creatures={ "Kongra", "Sibang", "Merlkin" } }, -- Kongra=116 :contentReference[oaicite:7]{index=7}
  pirates = { label="Pirates", required=600, iconId=247, creatures={ "Pirate Marauder", "Pirate Cutthroat", "Pirate Corsair", "Pirate Buccaneer" } }, -- Pirate Marauder=247 :contentReference[oaicite:8]{index=8}
  barbarians = { label="Barbarians", required=600, iconId=323, creatures={ "Barbarian Bloodwalker", "Barbarian Brutetamer", "Barbarian Headsplitter", "Barbarian Skullhunter" } }, -- Bloodwalker=323 :contentReference[oaicite:9]{index=9}
  djinns = { label="Djinss", required=600, iconId=104, creatures={ "Marid", "Efreet", "Green Djinn", "Blue Djinn" } }, -- Marid=104 :contentReference[oaicite:10]{index=10}
  stonerefiners = { label="Stonerefiners", required=500, iconId=1525, creatures={ "Stonerefiner" } }, -- 1525 :contentReference[oaicite:11]{index=11}
  dragons = { label="Dragons", required=500, iconId=34, creatures={ "Dragon", "Dragon Hatchling" } }, -- Dragon=34 :contentReference[oaicite:12]{index=12}
  quaras = { label="Quaras", required=500, iconId=241, creatures={ "Quara Mantassin", "Quara Mantassin Scout", "Quara Constrictor", "Quara Constrictor Scout", "Quara Pincher", "Quara Pincher Scout", "Quara Predator", "Quara Predator Scout", "Quara Hydromancer", "Quara Hydromancer Scout" } }, -- Mantassin=241 :contentReference[oaicite:13]{index=13}
  drefia_crypts = { label="Drefia Crypts", required=600, iconId=975, creatures={ "Gravedigger", "Zombie", "Blood Hand", "Necromancer" } }, -- Gravedigger=975 :contentReference[oaicite:14]{index=14}
  ancient_scarabs = { label="Ancient Scarabs", required=500, iconId=79, creatures={ "Ancient Scarab" } }, -- 79 :contentReference[oaicite:15]{index=15}
  giant_spiders = { label="Giant Spiders", required=500, iconId=38, creatures={ "Giant Spider" } }, -- 38 :contentReference[oaicite:16]{index=16}
  laguna_islands = { label="Laguna Islands", required=500, iconId=259, creatures={ "Thornback Tortoise", "Tortoise", "Toad", "Blood Crab" } }, -- Thornback Tortoise=259 :contentReference[oaicite:17]{index=17}
  oramond = { label="Oramond", required=1000, iconId=1052, creatures={ "Minotaur Hunter", "Mooh'Tah Warrior", "Minotaur Amazon", "Worm Priestess", "Execowtioner", "Moohtant" } }, -- Minotaur Hunter=1052 :contentReference[oaicite:18]{index=18}
  wyrms = { label="Wyrms", required=1000, iconId=461, creatures={ "Wyrm", "Elder Wyrm" } }, -- Wyrm=461 :contentReference[oaicite:19]{index=19}
  book_world = { label="Book World", required=2000, iconId=2673, creatures={ "Bluebeak", "Bramble Wyrmling", "Crusader", "Hawk Hopper", "Headwalker", "Lion Hydra" } }, -- Bluebeak=2673 :contentReference[oaicite:20]{index=20}
  cults = { label="Cults", required=1500, iconId=1512, creatures={ "Cult Believer", "Vicious Squire", "Cult Enforcer", "Renegade Knight", "Vile Grandmaster", "Cult Scholar", "Hero" } }, -- Cult Believer=1512 :contentReference[oaicite:21]{index=21}
  barkless = { label="Barkless", required=1000, iconId=1486, creatures={ "Barkless Devotee", "Barkless Fanatic" } }, -- 1486 :contentReference[oaicite:22]{index=22}
  feyrist_surface = { label="Feyrist Surface", required=1500, iconId=1434, creatures={ "Faun", "Dark Faun", "Nymph", "Pixie", "Pooka", "Twisted Pooka", "Swan Maiden" } }, -- Faun=1434 :contentReference[oaicite:23]{index=23}
  deeplings = { label="Deeplings", required=1000, iconId=772, creatures={ "Deepling Spellsinger", "Deepling Scout", "Deepling Warrior", "Deepling Guard" } }, -- 772 :contentReference[oaicite:24]{index=24}
  wereboars = { label="Wereboars", required=1500, iconId=1549, creatures={ "Werefox", "Werebadger", "Wereboar", "Werebear", "Werewolf" } }, -- Werefox=1549 :contentReference[oaicite:25]{index=25}
  minotaur_cults = { label="Minotaur Cults", required=1800, iconId=1508, creatures={ "Minotaur Cult Follower", "Minotaur Cult Prophet", "Minotaur Cult Zealot" } }, -- 1508 :contentReference[oaicite:26]{index=26}
  orc_cults = { label="Orc Cults", required=2000, iconId=2438, creatures={ "Orc Cult Fanatic", "Orc Cult Inquisitor", "Orc Cult Minion", "Orc Cult Priest", "Orc Cultist" } }, -- 2438 :contentReference[oaicite:27]{index=27}
  feyrist_nightmares = { label="Feyrist Nightmares", required=2000, iconId=1442, creatures={ "Weakened Frazzlemaw", "Enfeebled Silencer" } }, -- 1442/1443
  bandits = { label="Bandits", required=3000, iconId=1119, creatures={ "Glooth Bandit", "Glooth Brigand" } },
  exotics = { label="Exotics", required=3500, iconId=2024, creatures={ "Exotic Cave Spider", "Exotic Bat" } },
  pirats = { label="Pirats", required=2000, iconId=2038, creatures={ "Pirat Bombardier", "Pirat Cutthroat", "Pirat Mate", "Pirat Scoundrel" } },
  werehyaenas = { label="Werehyaenas", required=2000, iconId=1963, creatures={ "Werehyaena", "Werehyaena Shaman" } },
  dragon_lords = { label="Dragon Lords", required=2000, iconId=39, creatures={ "Dragon Lord", "Dragon Lord Hatchling" } },
  frost_dragons = { label="Frost Dragons", required=2000, iconId=317, creatures={ "Frost Dragon", "Frost Dragon Hatchling" } },
  banuta_deeper = { label="Banuta Deeper", required=2000, iconId=120, creatures={ "Medusa", "Serpent Spawn", "Hydra", "Eternal Guardian" } },
  nightmares = { label="Nightmares", required=2000, iconId=33, creatures={ "Nightmare", "Nightmare Scion" } },
  drakens = { label="Drakens", required=3000, iconId=673, creatures={ "Draken Abomination", "Draken Elite", "Draken Spellweaver", "Draken Warmaster", "Lizard Legionnaire", "Lizard Magistratus", "Lizard Noble", "Lizard Chosen", "Lizard Dragon Priest", "Lizard High Guard" } },
  the_hive = { label="The Hive", required=3000, iconId=785, creatures={ "Waspoid", "Crawler", "Spitter", "Kollos", "Spidris", "Spidris Elite", "Hive Overseer" } },
  iksupan = { label="Iksupan", required=5000, iconId=2437, creatures={ "Iks Yapunac", "Mitmah Scout", "Mitmah Seer" } },
  carnivors = { label="Carnivors", required=5000, iconId=1723, creatures={ "Lumbering Carnivor", "Spiky Carnivor", "Menacing Carnivor" } },
  nightmare_isles = { label="Nightmare Isles", required=3000, iconId=1017, creatures={ "Choking Fear", "Retching Horror", "Silencer" } },
  warlock = { label="Warlock", required=2000, iconId=10, creatures={ "Warlock" } },
  mota = { label="Mota", required=3000, iconId=291, creatures={ "Fury", "Floating Savant", "Demon", "Retching Horror", "Hellhound" } },
  grim_reapers = { label="Grim Reapers", required=3000, iconId=519, creatures={ "Hellspawn", "Grim Reaper" } },
  candia = { label="Candia", required=3500, iconId=2535, creatures={ "Candy Horror", "Nibblemaw", "Honey Elemental", "Angry Sugar Fairy", "Candy Floss Elemental", "Goggle Cake" } },
  lycanthropes = { label="Lycanthropes", required=4000, iconId=1965, creatures={ "Werelion", "Werelioness" } },
  the_void = { label="The Void", required=5000, iconId=1696, creatures={ "Breach Brood", "Dread Intruder", "Sparkion", "Reality Reaver" } },
  asuras = { label="Asuras", required=5000, iconId=1134, creatures={ "Dawnfire Asura", "Midnight Asura", "Frost Flower Asura" } },
  buried_cathedral = { label="Buried Cathedral", required=5000, iconId=1725, creatures={ "Gazer Spectre", "Burster Spectre", "Ripper Spectre", "Thanatursus", "Arachnophobica" } },
  rathleton_catacombs = { label="Rathleton Catacombs", required=6000, iconId=287, creatures={ "Destroyer", "Dark Torturer", "Demon", "Grim Reaper", "Hellhound", "Hellspawn", "Juggernaut" } },
  roshamuul = { label="Roshamuul", required=8000, iconId=2682, creatures={ "Guzzlemaw", "Frazzlemaw", "Silencer", "Choking Fear", "Retching Horror" } },
  warzone_1 = { label="Warzone 1", required=3000, iconId=891, creatures={ "Hideous Fungus", "Humongous Fungus" } },
  warzone_2 = { label="Warzone 2", required=5000, iconId=882, creatures={ "Weeper", "Magma Crawler", "Lost Berserker" } },
  warzone_3 = { label="Warzone 3", required=5000, iconId=889, creatures={ "Cliff Strider", "Ironblight", "Orewalker" } },
  weretigers = { label="Weretigers", required=6000, iconId=2386, creatures={ "Weretiger", "White Weretiger", "Cunning Werepanther" } },
  winter_elves = { label="Winter Elves", required=10000, iconId=1734, creatures={ "Soul-broken Harbinger", "Crazed Winter Vanguard", "Crazed Winter Rearguard", "Arachnophobica" } },
  summer_elves = { label="Summer Elves", required=8000, iconId=1733, creatures={ "Crazed Summer Rearguard", "Crazed Summer Vanguard", "Insane Siren", "Arachnophobica" } },
  deathlings = { label="Deathlings", required=4000, iconId=1667, creatures={ "Deathling Scout", "Deathling Spellsinger" } },
  great_pearl = { label="Great Pearl", required=8000, iconId=2259, creatures={ "Foam Stalker", "Two-headed Turtle" } },
  nagas = { label="Nagas", required=8000, iconId=2262, creatures={ "Makara", "Naga Archer", "Naga Warrior" } },
  carnisylvans = { label="Carnisylvans", required=8000, iconId=2109, creatures={ "Dark Carnisylvan", "Hulking Carnisylvan", "Poisonous Carnisylvan" } },
  warzone_4 = { label="Warzone 4", required=7000, iconId=1546, creatures={ "Chasm Spawn", "Drillworm", "Elder Wyrm", "Lava Lurker" } },
  warzone_5 = { label="Warzone 5", required=7000, iconId=1544, creatures={ "Cave Devourer", "High Voltage Elemental", "Tunnel Tyrant" } },
  warzone_6 = { label="Warzone 6", required=12000, iconId=1531, creatures={ "Deepworm", "Diremaw", "Humongous Fungus" } },
  seacrest = { label="Seacrest", required=5000, iconId=1096, creatures={ "Seacrest Serpent", "Sea Serpent", "Young Sea Serpent" } },
  kilmaresh_deeper = { label="Kilmaresh Deeper", required=8000, iconId=1798, creatures={ "Burning Gladiator", "Black Sphinx Acolyte", "Priestess Of The Wild Sun" } },
  kilmaresh_surface = { label="Kilmaresh Surface", required=15000, iconId=1808, creatures={ "Sphinx", "Manticore", "Lamassu", "Feral Sphinx", "Crypt Warden", "Young Goanna", "Adult Goanna" } },
  falcon_bastion = { label="Falcon Bastion", required=16000, iconId=1646, creatures={ "Falcon Knight", "Falcon Paladin" } },
  kilmaresh_mountains = { label="Kilmaresh Mountains", required=10000, iconId=1821, creatures={ "Ogre Rowdy", "Ogre Ruffian", "Ogre Sage" } },
  roshamuul_prison = { label="Roshamuul Prison", required=12000, iconId=1019, creatures={ "Demon Outcast", "Blightwalker", "Plaguesmith", "Dark Torturer", "Hellhound", "Juggernaut" } },
  cobra_bastion = { label="Cobra Bastion", required=20000, iconId=1775, creatures={ "Cobra Assassin", "Cobra Scout", "Cobra Vizier" } },
  bulltaur_lair = { label="Bulltaur Lair", required=15000, iconId=2448, creatures={ "Bulltaur Alchemist", "Bulltaur Brute", "Bulltaur Forgepriest" } },
  netherworld = { label="Netherworld", required=15000, iconId=1864, creatures={ "Flimsy Lost Soul", "Mean Lost Soul", "Freakish Lost Soul" } },
  deep_desert = { label="Deep Desert", required=13000, iconId=46, creatures={ "Black Knight", "Guardian of the Sands", "Undead Sun Soldier", "Undead Cobra Scout" } },
  nimmersatts = { label="Nimmersatt's", required=20000, iconId=2456, creatures={ "Dragolisk", "Mega Dragon", "Wardragon" } },
  bashmus = { label="Bashmus", required=20000, iconId=2100, creatures={ "Bashmu", "Juvenile Bashmu" } },
  girtablilu = { label="Girtablilu", required=15000, iconId=2099, creatures={ "Girtablilu Warrior", "Venerable Girtablilu" } },
  true_asuras = { label="True Asuras", required=12000, iconId=1620, creatures={ "True Dawnfire Asura", "True Frost Flower Asura", "True Midnight Asura", "Hellhound" } },
  ingol = { label="Ingol", required=25000, iconId=2339, creatures={ "Boar Man", "Carnivostrich", "Crape Man", "Harpy", "Liodile", "Rhindeer" } },
  ferumbras_seal = { label="Ferumbras Seal", required=15000, iconId=1197, creatures={ "Vexclaw", "Grimeleech", "Hellflayer" } },
  warzone_7 = { label="Warzone 7", required=20000, iconId=2094, creatures={ "Afflicted Strider", "Blemished Spawn", "Eyeless Devourer" } },
  warzone_8 = { label="Warzone 8", required=15000, iconId=2095, creatures={ "Lavafungus", "Lavaworm", "Streaked Devourer" } },
  warzone_9 = { label="Warzone 9", required=15000, iconId=2096, creatures={ "Cave Chimera", "Tremendous Tyrant", "Varnished Diremaw" } },
  podzilla = { label="Podzilla", required=25000, iconId=2539, creatures={ "Rootthing Amber Shaper", "Rootthing Nutshell", "Rootthing Bug Tracker" } },
  podzilla_deep = { label="Podzilla Deep", required=20000, iconId=2543, creatures={ "Quara Looter", "Quara Plunderer", "Quara Raider" } },
  inferniarchs_castle = { label="Inferniarchs Castle", required=15000, iconId=2603, creatures={ "Broodrider Inferniarch", "Gorger Inferniarch", "Sineater Inferniarch" } },
  earth_library = { label="Earth Library", required=12000, iconId=1652, creatures={ "Cursed Book", "Ink Blob", "Biting Book" } },
  ice_library = { label="Ice Library", required=20000, iconId=1664, creatures={ "Icecold Book", "Squid Warden", "Animated Feather" } },
  fire_library = { label="Fire Library", required=20000, iconId=1663, creatures={ "Burning Book", "Rage Squid", "Guardian Of Tales" } },
  energy_library = { label="Energy Library", required=20000, iconId=1665, creatures={ "Energetic Book", "Brain Squid", "Energuardian Of Tales" } },
  furious_crater = { label="Furious Crater", required=25000, iconId=1929, creatures={ "Vibrant Phantom", "Courage Leech", "Cloak Of Terror" } },
  dark_thais = { label="Dark Thais", required=25000, iconId=1927, creatures={ "Many Faces", "Druid’s Apparition", "Knight’s Apparition", "Paladin’s Apparition", "Sorcerer’s Apparition", "Monk’s Apparition", "Distorted Phantom" } },
  rotten_wasteland = { label="Rotten Wasteland", required=25000, iconId=0, creatures={ } },
  claustrophobic_inferno = { label="Claustrophobic Inferno", required=25000, iconId=1930, creatures={ "Brachiodemon", "Infernal Demon", "Infernal Phantom" } },
  inferniarchs_catacombs = { label="Inferniarchs Catacombs", required=25000, iconId=2601, creatures={ "Brinebrute Inferniarch", "Hellhunter Inferniarch", "Spellreaper Inferniarch" } },
  ebb_and_flow = { label="Ebb And Flow", required=25000, iconId=1926, creatures={ "Bony Sea Devil", "Turbulent Elemental", "Capricious Phantom" } },
  crystal_enigma = { label="Crystal Enigma", required=30000, iconId=2268, creatures={ "Emerald Tortoise", "Gore Horn", "Gorerilla", "Hulking Prehemoth", "Sabretooth" } },
  sparkling_pools = { label="Sparkling Pools", required=30000, iconId=2275, creatures={ "Headpecker", "Mantosaurus", "Mercurial Menace", "Noxious Ripptor", "Shrieking Cry-stal" } },
  graveyard = { label="Graveyard", required=30000, iconId=2264, creatures={ "Sulphider", "Sulphur Spouter", "Nighthunter", "Stalking Stalk", "Undertaker" } },
  putrefatory = { label="Putrefatory", required=40000, iconId=2394, creatures={ "Meandering Mushroom", "Oozing Carcass", "Rotten Man-maggot", "Sopping Carcass" } },
  gloom_pillars = { label="Gloom Pillars", required=40000, iconId=2379, creatures={ "Converter", "Darklight Construct", "Darklight Emitter", "Wandering Pillar" } },
  jaded_roots = { label="Jaded Roots", required=40000, iconId=2392, creatures={ "Bloated Man-maggot", "Mycobiontic Beetle", "Oozing Corpus", "Sopping Corpus" } },
  darklight_core = { label="Darklight Core", required=40000, iconId=2380, creatures={ "Darklight Matter", "Darklight Source", "Darklight Striker", "Walking Pillar" } },
}

local function norm(s)
  s = tostring(s or ""):lower()
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  s = s:gsub("%s+", " ")
  return s
end

local function smartNormalize(s)
  s = tostring(s or ""):lower()
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  s = s:gsub("^the%s+", "")        -- remove "the "
  s = s:gsub("%s+", " ")           -- limpa espaços duplicados

  if s:sub(-1) == "s" then
    s = s:sub(1, -2)
  end

  return s
end


local function parseHunt(text)
  local msg = tostring(text or "")
  local hunt = msg:match("[Yy]our hunt for%s+([%a%s']+)%s+has begun")
  if not hunt then return nil end

  local normalizedHunt = smartNormalize(hunt)

  for key, cfg in pairs(TASKS) do
    -- compara com key
    if smartNormalize(key) == normalizedHunt then
      return key
    end

    -- compara com label
    if smartNormalize(cfg.label) == normalizedHunt then
      return key
    end
  end

  return nil
end

-- =========================
-- UI PRINCIPAL
-- =========================
taskInterface = setupUI([=[
UIWindow
  size: 235 100
  image-color: gray
  image-source: /images/ui/window_headless
  image-border: 6

  Panel
    anchors.fill: parent
    image-border: 1

  Panel
    id: topBar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 25

  Label
    id: title
    anchors.centerIn: topBar
    text: Task Tracker
    color: orange
    margin-top: 0
    font: verdana-11px-rounded
    text-auto-resize: true

  Button
    id: minimize
    anchors.top: prev.top
    anchors.right: parent.right
    margin-right: 7
    size: 20 18
    text: -
    font: verdana-11px-rounded
    color: orange

  TextList
    id: taskList
    anchors.top: topBar.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin: 6
    margin-top: 1
    padding: 2
]=], g_ui.getRootWidget())
taskInterface:hide()
local taskList = taskInterface.taskList

taskInterface.minimize.onClick = function()
  if taskList:isVisible() then
    taskList:hide()
    taskInterface:setHeight(35)
    taskInterface.minimize:setText("+")
  else
    taskList:show()
    taskInterface:setHeight(100)
    taskInterface.minimize:setText("-")
  end
end

charStorage.widgetPos = type(charStorage.widgetPos) == "table" and charStorage.widgetPos or {}

charStorage.widgetPos["taskInterface"] = charStorage.widgetPos["taskInterface"] or {}

-- restaura pos
taskInterface:setPosition({
  x = charStorage.widgetPos["taskInterface"].x or taskInterface:getX(),
  y = charStorage.widgetPos["taskInterface"].y or taskInterface:getY()
})



taskInterface.onDragEnter = function(widget, mousePos)
  widget:breakAnchors()
  widget.movingReference = {
    x = mousePos.x - widget:getX(),
    y = mousePos.y - widget:getY()
  }
  return true
end

taskInterface.onDragMove = function(widget, mousePos, moved)
  local parentRect = widget:getParent():getRect()

  local x = math.min(
    math.max(parentRect.x, mousePos.x - widget.movingReference.x),
    parentRect.x + parentRect.width - widget:getWidth()
  )

  local y = math.min(
    math.max(parentRect.y - widget:getParent():getMarginTop(), mousePos.y - widget.movingReference.y),
    parentRect.y + parentRect.height - widget:getHeight()
  )

  widget:move(x, y)
  charStorage.widgetPos["taskInterface"] = { x = x, y = y }
  saveTaskStorage()
  return true
end

local lastTaskTrackerState = nil
local function syncTaskTrackerVisibility()
  local enabled = isTaskTrackerOn()

  if lastTaskTrackerState == enabled then
    return
  end

  lastTaskTrackerState = enabled
  st.enabled = enabled == true

  if enabled then
    taskInterface:show()
    taskInterface:raise()
  else
    taskInterface:hide()
  end

  saveTaskStorage()
end

macro(200, function()
  syncTaskTrackerVisibility()
end)

schedule(100, function()
  syncTaskTrackerVisibility()
end)
-- =========================
-- ROW TEMPLATE (layout antigo)
-- =========================
local rowTemplate = [[
UIWidget
  height: 60
  focusable: true
  background-color: alpha
  opacity: 1.00

  UICreature
    id: icon
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 0
    size: 60 60
    margin-top: 2
    border: 1 gray
    visible: true

  Label
    id: spellName
    anchors.left: icon.right
    anchors.top: parent.top
    margin-left: 8
    margin-top: 15
    width: 70
    font: verdana-11px-rounded
    color: orange
    text: ""

  Label
    id: distText
    anchors.left: icon.right
    anchors.top: spellName.bottom
    margin-left: 8
    margin-top: 4
    text-auto-resize: true
    color: #dcdcdc
    text: "0/0"

  Label
    id: mobsText
    anchors.left: distText.right
    anchors.verticalCenter: distText.verticalCenter
    margin-left: 3
    text-auto-resize: true
    color: #dcdcdc
    text: "KILLS"

  Label
    id: safeText
    anchors.left: mobsText.right
    anchors.verticalCenter: distText.verticalCenter
    margin-left: 8
    text-auto-resize: true
    color: gray
    text: "[0%]"

  Button
    id: remove
    anchors.right: parent.right
    anchors.top: parent.top
    width: 16
    height: 16
    margin-right: 6
    margin-top: 6
    text: X
    color: white
    tooltip: Exclude Task
]]

-- =========================
-- Helpers list (igual AttackBot)
-- =========================
local function clearChildren(w)
  local children = w:getChildren() or {}
  for i = #children, 1, -1 do
    children[i]:destroy()
  end
end

local function getProgressKey(taskKey)
  st.progress[taskKey] = st.progress[taskKey] or { kills = 0 }
  st.progress[taskKey].kills = tonumber(st.progress[taskKey].kills or 0) or 0
  return st.progress[taskKey]
end

local function calcPct(kills, req)
  kills = tonumber(kills or 0) or 0
  req = tonumber(req or 0) or 0
  if req <= 0 then return 0 end
  local pct = math.floor((kills * 100) / req)
  if pct < 0 then pct = 0 end
  if pct > 100 then pct = 100 end
  return pct
end

-- =========================
-- REFRESH LIST (ONLINE)
-- =========================
local function refreshList()
  clearChildren(taskList)

  if not st.current or not TASKS[st.current] then
    return
  end

  local cfg = TASKS[st.current]
  local kills = tonumber(st.kills or 0) or 0
  local req = tonumber(st.required or cfg.required) or cfg.required
  if kills > req then kills = req end

  local pct = calcPct(kills, req)
  local done = (kills >= req)

  local row = setupUI(rowTemplate, taskList)

  -- =========================
  -- AQUI É O IMPORTANTE (UICreature)
  -- =========================
  if row.icon and row.icon.setOutfit then
    local outfit = nil

    if player and player.getOutfit then
      local ok, base = pcall(function() return player:getOutfit() end)
      if ok and type(base) == "table" then
        base.type = tonumber(cfg.iconId) or 0
        base.addons = 0
        outfit = base
      end
    end

    outfit = outfit or {
      mount = 0,
      feet = 0,
      legs = 0,
      body = cfg.iconId,
      type = 0,
      auxType = 0,
      addons = 0,
      head = 0
    }

    pcall(function()
      row.icon:setOutfit(outfit)
    end)
  end

  -- =========================

  row.spellName:setText(cfg.label)
  row.distText:setText(kills .. "/" .. req)
  row.mobsText:setText("KILLS")

  row.safeText:setText("[" .. pct .. "%]")
  row.safeText:setColor(done and "#66ff66" or "gray")

  row.remove.onClick = function()
    -- guarda qual task está sendo cancelada
    local key = st.current

    -- limpa progresso salvo dessa task
    if key and st.progress then
      st.progress[key] = nil
    end

    -- reseta estado atual
    st.current = nil
    st.kills = 0
    st.required = 0

    saveTaskStorage()
    refreshList()
  end
end

-- =========================
-- SET TASK (carrega progresso salvo)
-- =========================
local function setTask(key)
  if not TASKS[key] then return end
  st.current = key
  st.required = TASKS[key].required

  local p = getProgressKey(key)
  st.kills = tonumber(p.kills or 0) or 0
  if st.kills > st.required then st.kills = st.required end

  saveTaskStorage()
  refreshList()
end

-- =========================
-- AUTO KILL COUNT (salva + atualiza online)
-- =========================
local function addKill()
  local row = setupUI(rowTemplate, taskList)
  if not st.current or not TASKS[st.current] then return end

  st.kills = (tonumber(st.kills or 0) or 0) + 1
  if st.kills > st.required then st.kills = st.required end

  local p = getProgressKey(st.current)
  p.kills = st.kills

  saveTaskStorage()
  refreshList()
end

local function isTaskCreatureName(mobName)
  if not st.current or not TASKS[st.current] then return false end
  mobName = norm(mobName)

  for _, cname in ipairs(TASKS[st.current].creatures) do
    if mobName == norm(cname) then
      return true
    end
  end
  return false
end

local function extractLootMobName(text)
  local mobName = nil
  local reg = { "Loot of a (.*):", "Loot of an (.*):", "Loot of the (.*):", "Loot of (.*):" }
  for i = 1, #reg do
    local _, _, m = string.find(text, reg[i])
    if m then
      mobName = m
      break
    end
  end
  return mobName
end

local function handleLootText(text)
  if not isTaskTrackerOn() then return end
  if not st.current then return end
  if type(text) ~= "string" then return end

  local mobName = extractLootMobName(text)
  if not mobName then return end

  if not isTaskCreatureName(mobName) then return end

  addKill()
end

onTalk(function(name, level, mode, text, channelId, pos)
  if channelId == 11 then
    handleLootText(text)
  end
end)

onTextMessage(function(mode, text)
  handleLootText(text)
end)

-- =========================
-- CAPTURA Ragnar (ONLINE)
-- =========================
onTalk(function(name, level, mode, text)
  if not isTaskTrackerOn() then return end
  if not name then return end
  if norm(name) ~= "ragnar" then return end

  local key = parseHunt(text)
  if key then
    setTask(key)
  end
end)

onTextMessage(function(mode, text)
  if not isTaskTrackerOn() then return end
  local key = parseHunt(text)
  if key then
    setTask(key)
  end
end)

-- INIT
if st.current and TASKS[st.current] then
  setTask(st.current) -- recarrega progresso salvo e desenha
else
  refreshList()
end

-- =========================
-- CAVEBOT CHECKER TASK TRACKER
-- =========================
local checkerTaskPendingLabel = nil
local checkerTaskPendingUntil = 0
local checkerTaskLastTry = 0
local checkerTaskLastMsg = 0

local function checkerTaskNow()
  return tonumber(now) or (os.time() * 1000)
end

local function checkerTaskMsg(text)
  local t = checkerTaskNow()
  if t - checkerTaskLastMsg < 2000 then return end
  checkerTaskLastMsg = t

  if modules and modules.game_textmessage then
    modules.game_textmessage.displayGameMessage(text)
  end
end

local function checkerTaskGoto(label)
  label = tostring(label or "")
  if label == "" then return false end

  local ok = false

  -- dentro da function do CaveBot, geralmente o gotoLabel existe
  if gotoLabel then
    ok = pcall(function()
      gotoLabel(label)
    end)
  end

  -- fallback caso sua base tenha CaveBot.gotoLabel
  if not ok and CaveBot and CaveBot.gotoLabel then
    ok = pcall(function()
      CaveBot.gotoLabel(label)
    end)
  end

  if ok and CaveBot and CaveBot.delay then
    pcall(function()
      CaveBot.delay(300)
    end)
  end

  if not ok then
    checkerTaskMsg("[LNS] ERRO: gotoLabel nao encontrado para: " .. label)
  end

  return ok
end

local function checkerTaskRequestGoto(label)
  label = tostring(label or "")
  if label == "" then return end

  checkerTaskPendingLabel = label
  checkerTaskPendingUntil = checkerTaskNow() + 3500
  checkerTaskLastTry = 0

  checkerTaskGoto(label)
end

macro(50, function()
  if not checkerTaskPendingLabel then return end

  local t = checkerTaskNow()

  if t > checkerTaskPendingUntil then
    checkerTaskPendingLabel = nil
    return
  end

  if t - checkerTaskLastTry < 100 then return end
  checkerTaskLastTry = t

  checkerTaskGoto(checkerTaskPendingLabel)
end)

function checkerTaskTracker(labelProgress, labelDone, labelNoTask)
  labelProgress = tostring(labelProgress or "startHunt")

  local data = st

  if type(data) ~= "table" then
    charStorage = charStorage or loadCharStorage()
    data = charStorage and charStorage[STKEY or "lnsTaskTracker"]
  end

  if type(data) ~= "table" then
    checkerTaskMsg("[LNS] Task Tracker sem storage.")
    if labelNoTask and labelNoTask ~= "" then
      checkerTaskRequestGoto(labelNoTask)
    end
    return true
  end

  local current = data.current

  if not current or not TASKS[current] then
    checkerTaskMsg("[LNS] Nenhuma task ativa.")
    if labelNoTask and labelNoTask ~= "" then
      checkerTaskRequestGoto(labelNoTask)
    end
    return true
  end

  local taskCfg = TASKS[current]
  local kills = tonumber(data.kills or 0) or 0
  local required = tonumber(data.required or taskCfg.required or 0) or 0

  if required <= 0 then
    checkerTaskMsg("[LNS] Task invalida.")
    if labelNoTask and labelNoTask ~= "" then
      checkerTaskRequestGoto(labelNoTask)
    end
    return true
  end

  if kills >= required then
    checkerTaskPendingLabel = nil

    checkerTaskMsg("[LNS] Task finalizada: " .. kills .. "/" .. required)

    if labelDone and labelDone ~= "" then
      checkerTaskRequestGoto(labelDone)
    end

    return true
  end

  checkerTaskMsg("[LNS] Task em andamento: " .. kills .. "/" .. required .. " | Voltando para " .. labelProgress)

  checkerTaskRequestGoto(labelProgress)

  return true
end 
end)

lnsRunBlock("ICONS", function()
  setDefaultTab("Main")

--==================================================
-- STORAGE FIXO DOS ICONES
--==================================================

storage.lnsIconsPanel = storage.lnsIconsPanel or {}
local iconsStorage = storage.lnsIconsPanel

--==================================================
-- HELPERS BASE
--==================================================

local function later(ms, fn)
  if type(schedule) == "function" then return schedule(ms, fn) end
  if type(scheduleEvent) == "function" then return scheduleEvent(fn, ms) end
  if g_dispatcher and type(g_dispatcher.scheduleEvent) == "function" then return g_dispatcher:scheduleEvent(fn, ms) end
  return fn()
end

local function lnsIsMobile()
  if g_app and type(g_app.isMobile) == "function" then
    local ok, res = pcall(function() return g_app.isMobile() end)
    return ok and res == true
  end
  return false
end

local function clamp(v, a, b)
  v = tonumber(v) or 0
  if v < a then return a end
  if v > b then return b end
  return v
end

local function pctTo01(v)
  return clamp(v, 0, 100) / 100
end

local function normalizeText(s)
  s = tostring(s or ""):lower()
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  return s
end

local function getConfigNameSafe()
  local botPanel = modules.game_bot and modules.game_bot.contentsPanel
  local config = botPanel and botPanel.config and botPanel.config:getCurrentOption()
  return (config and config.text) or "default"
end

local MyConfigName = getConfigNameSafe()

local function saveIcons()
  storage.lnsIconsPanel = iconsStorage
end

local function getItemId(widget)
  if widget and widget.getItemId then
    local ok, id = pcall(function() return widget:getItemId() end)
    if ok and tonumber(id) then return tonumber(id) end
  end

  if widget and widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and item.getId then
      local ok2, id = pcall(function() return item:getId() end)
      if ok2 and tonumber(id) then return tonumber(id) end
    end
  end

  return 0
end

local function setBotItemId(widget, itemId)
  if not widget then return end
  itemId = tonumber(itemId) or 0

  if widget.setItemId then
    widget:setItemId(itemId)
    return
  end

  if widget.setItem and Item and Item.create then
    if itemId > 0 then
      widget:setItem(Item.create(itemId, 1))
    else
      pcall(function() widget:setItem(nil) end)
    end
  end
end

local function applyIconItem(icon, itemId)
  if not icon or not icon.item then return end
  itemId = tonumber(itemId) or 0

  if icon.creature and icon.creature.setVisible then
    icon.creature:setVisible(false)
  end

  if icon.item.setVisible then
    icon.item:setVisible(true)
  end

  if icon.item.setItemId then
    icon.item:setItemId(itemId)
    return
  end

  if icon.item.setItem and Item and Item.create then
    if itemId > 0 then
      icon.item:setItem(Item.create(itemId, 1))
    else
      pcall(function() icon.item:setItem(nil) end)
    end
  end
end

local function applyRelativePos(widget, st)
  if not widget or not st then return end

  local parent = widget:getParent()
  if not parent then return end

  local r = parent:getRect()
  local w = r.width - widget:getWidth()
  local h = r.height - widget:getHeight()

  local x = pctTo01(st.x or 0)
  local y = pctTo01(st.y or 0)

  widget:setMarginLeft(w * (-0.5 + x))
  widget:setMarginTop(math.max(h * (-0.5) - parent:getMarginTop(), h * (-0.5 + y)))
end

--==================================================
-- PAINEL
--==================================================

iconesInterface = setupUI([=[
iconesRow < Panel
  height: 43
  margin-top: 2
  margin-left: 3
  margin-right: 3
  border: 1 #696969

  BotItem
    id: itemIcone
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5

  Button
    id: listaIcone
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    width: 20
    text: L
    tooltip: Lista de items

  TextEdit
    id: textIcone
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    width: 90

  Label
    id: lblX
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 10
    width: 14
    color: #d7c08a
    text: X:

  BotTextEdit
    id: editX
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 2
    width: 38
    height: 22
    text-align: center
    color: white
    text: 0

  Label
    id: lblY
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 3
    width: 14
    color: #d7c08a
    text: Y:

  BotTextEdit
    id: editY
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 2
    width: 38
    height: 22
    text-align: center
    color: white
    text: 0

  BotSwitch
    id: ativarIcone
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    margin-top: -1
    height: 22
    width: 38
    image-source: ""
    font: verdana-11px-rounded
    $on:
      text: HIDE
      color: red
    $!on:
      text: SHOW
      color: green

MainWindow
  id: mainPanel
  size: 367 400
  text: Panel Icones
  margin-top: -50

  Label
    text: Search Icones:
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 2
    margin-left: -5
    text-auto-resize: true

  TextEdit
    id: pesquisaIcons
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: parent.right
    margin-right: -5
    margin-top: 2
    placeholder: Search icon name
    phantom: true

  FlatPanel
    id: flatp
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.bottom: closePanel.top
    margin-bottom: 5
    margin-top: 8

    TextList
      id: lista
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin: 3
      margin-right: 16
      vertical-scrollbar: scrollLista

    VerticalScrollBar
      id: scrollLista
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      width: 13
      margin-top: 3
      margin-bottom: 3
      margin-right: 3
      step: 43
      pixels-scroll: true
      visible: true

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

]=], g_ui.getRootWidget())

iconesInterface:hide()

if lnsIsMobile() then
  equipInterface:setSize("367 420")
end

local buticon = addButton("", "Icones", function()
  iconesInterface:show()
  iconesInterface:raise()
  iconesInterface:focus()
end)
buticon:setMarginTop(0)

iconesInterface.closePanel.onClick = function()
  iconesInterface:hide()
end

--==================================================
-- LISTA DE ITEMS COM PESQUISA POR NOME / ID
--==================================================

local idPicker = {
  win = nil,
  itemList = nil,
  pageLabel = nil,
  btnBack = nil,
  btnNext = nil,
  btnClose = nil,
  searchEdit = nil,
  target = nil,
  lootList = {},
  filteredList = {},
  itemIndex = 1,
  pageSize = 104,
  query = ""
}

local function safeRead(path)
  if not g_resources or type(g_resources.readFileContents) ~= "function" then return nil end
  local ok, content = pcall(function() return g_resources.readFileContents(path) end)
  if not ok or not content or content == "" then return nil end
  return content
end

local function loadLootItems()
  local content =
    safeRead("/bot/" .. MyConfigName .. "/loot_items.lua") or
    safeRead("/bot/" .. MyConfigName .. "/loot_items") or
    safeRead("loot_items.lua")

  if not content then
    warn("[LNS Icones] Nao achei loot_items.lua em /bot/" .. MyConfigName .. "/")
    return {}
  end

  local list, seen = {}, {}
  for name, idStr in content:gmatch('%["(.-)"%]%s*=%s*(%d+)') do
    local id = tonumber(idStr)
    if id and not seen[id] then
      seen[id] = true
      table.insert(list, { name = tostring(name), id = id })
    end
  end

  table.sort(list, function(a, b) return normalizeText(a.name) < normalizeText(b.name) end)
  return list
end

local function pickerW(win, id)
  if win and win.recursiveGetChildById then return win:recursiveGetChildById(id) end
  if win and win.getChildById then return win:getChildById(id) end
  return nil
end

local function refreshPickerFilter()
  local q = normalizeText(idPicker.query)
  idPicker.filteredList = {}

  for _, it in ipairs(idPicker.lootList or {}) do
    local n = normalizeText(it.name)
    local sid = tostring(it.id or "")
    if q == "" or n:find(q, 1, true) or sid:find(q, 1, true) then
      table.insert(idPicker.filteredList, it)
    end
  end

  idPicker.itemIndex = 1
end

local function renderItemPicker()
  if not idPicker.itemList then return end
  idPicker.itemList:destroyChildren()

  local list = idPicker.filteredList or {}
  local total = #list

  if total == 0 then
    if idPicker.pageLabel then idPicker.pageLabel:setText("0/0") end
    return
  end

  if idPicker.itemIndex < 1 then idPicker.itemIndex = 1 end
  if idPicker.itemIndex > total then idPicker.itemIndex = total end

  local toIndex = idPicker.itemIndex + idPicker.pageSize - 1
  if toIndex > total then toIndex = total end

  for i = idPicker.itemIndex, toIndex do
    local entry = list[i]
    if entry then
      local w = UI.createWidget("LnsIconItemPickerEntry", idPicker.itemList)
      w.item:setSize({ width = 50, height = 50 })
      w.item:setItemId(entry.id)
      w.item:setTooltip(tostring(entry.name or "") .. " (" .. tostring(entry.id) .. ")")

      w.onDoubleClick = function()
        local t = idPicker.target
        if not t or not t.key then return end

        iconsStorage[t.key].itemId = tonumber(entry.id) or 0

        if t.row and t.row.itemIcone then
          setBotItemId(t.row.itemIcone, iconsStorage[t.key].itemId)
        end

        saveIcons()
        updateIcon(t.key)

        if idPicker.win then idPicker.win:hide() end
      end
    end
  end

  if idPicker.pageLabel then
    idPicker.pageLabel:setText(idPicker.itemIndex .. " - " .. toIndex .. " / " .. total)
  end
end

local function buildItemPickerUI()
  if idPicker.win then return end

  g_ui.loadUIFromString([[
LnsIconItemPickerWindow < MainWindow
  size: 685 520
  anchors.centerIn: parent
  margin-top: -60
  text: Panel Select Icone x Item
  @onEscape: self:hide()

  TextEdit
    id: searchItem
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 2
    margin-left: 0
    margin-right: 0
    height: 22
    placeholder: Search item by name or ID
    phantom: true

  Panel
    id: itemList
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    anchors.bottom: separator.top
    margin-left: -5
    margin-top: 5
    layout:
      type: grid
      cell-size: 50 50
      flow: true

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    margin-bottom: 45

  Button
    id: backButton
    !text: tr('Previous')
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-left: 0
    margin-top: 4
    width: 200

  Label
    id: page
    text: 0/0
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.left: prev.right
    anchors.top: prev.top
    width: 220
    margin-top: 2
    font: terminus-14px-bold
    text-align: center

  Button
    id: nextButton
    !text: tr('Next')
    margin-right: 0
    anchors.left: page.right
    anchors.top: backButton.top
    margin-top: 0
    width: 200

  Button
    id: closePanel
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    text: Close

LnsIconItemPickerEntry < UIWidget
  size: 40 40
  margin-left: 6
  margin-top: 0

  Item
    id: item
    size: 20 20
    phantom: false
    anchors.top: parent.top
    anchors.left: parent.left
    padding: 5
    border: 1 alpha
    $hover:
      border: 1 white
  ]])

  idPicker.win = UI.createWindow("LnsIconItemPickerWindow", g_ui.getRootWidget())
  idPicker.win:hide()

  idPicker.itemList = pickerW(idPicker.win, "itemList")
  idPicker.pageLabel = pickerW(idPicker.win, "page")
  idPicker.btnBack = pickerW(idPicker.win, "backButton")
  idPicker.btnNext = pickerW(idPicker.win, "nextButton")
  idPicker.btnClose = pickerW(idPicker.win, "closePanel")
  idPicker.searchEdit = pickerW(idPicker.win, "searchItem")

  if idPicker.btnClose then
    idPicker.btnClose.onClick = function()
      idPicker.win:hide()
    end
  end

  if idPicker.searchEdit then
    idPicker.searchEdit.onTextChange = function(_, text)
      idPicker.query = tostring(text or "")
      refreshPickerFilter()
      renderItemPicker()
    end
  end

  if idPicker.btnBack then
    idPicker.btnBack.onClick = function()
      idPicker.itemIndex = idPicker.itemIndex - idPicker.pageSize
      if idPicker.itemIndex < 1 then idPicker.itemIndex = 1 end
      renderItemPicker()
    end
  end

  if idPicker.btnNext then
    idPicker.btnNext.onClick = function()
      local total = #(idPicker.filteredList or {})
      idPicker.itemIndex = idPicker.itemIndex + idPicker.pageSize
      if idPicker.itemIndex > total then idPicker.itemIndex = total end
      renderItemPicker()
    end
  end
end

local function openItemPicker(key, row)
  buildItemPickerUI()
  idPicker.target = { key = key, row = row }
  idPicker.lootList = loadLootItems()
  idPicker.query = ""

  if idPicker.searchEdit then
    idPicker.searchEdit:setText("")
  end

  refreshPickerFilter()

  if idPicker.win then
    idPicker.win:show()
    idPicker.win:raise()
    idPicker.win:focus()
  end

  renderItemPicker()
end

--==================================================
-- CORE ICONES
--==================================================

local LNS_ICON = {
  icons = {},
  rows = {}
}

function updateIcon(key)
  local pack = LNS_ICON.icons[key]
  if not pack or not pack.icon then return end

  local st = iconsStorage[key]
  local def = pack.def
  local icon = pack.icon
  if not st then return end

  applyIconItem(icon, st.itemId)

  if icon.text then
    icon.text:setText(st.text or def.text or key)
    icon.text:setFont(def.font or "verdana-9px")
    icon.text:setColor("white")
  end

  icon.onMousePress = function(widget, mousePos, button)
    return true
  end

  icon.onMouseRelease = function(widget, mousePos, button)
    return true
  end

  if icon.status then
    icon.status:show()
    local ok, state = false, false
    if def.getState then
      ok, state = pcall(def.getState)
    end
    icon.status:setOn(ok and state == true)
  end

  if lnsIsMobile() then
    icon:setSize('50 50')
  else
    icon:setSize('65 50')
  end
  
  icon:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
  icon:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)

  applyRelativePos(icon, st)

  if st.show == true then
    icon:show()
    icon:raise()
  else
    icon:hide()
  end
end

local function createIcon(key)
  local pack = LNS_ICON.icons[key]
  if not pack then return end

  if pack.icon then
    updateIcon(key)
    return
  end

  local panel = modules.game_interface.gameMapPanel
  if not panel then
    warn("LNS ICON: gameMapPanel nao encontrado.")
    return
  end

  local icon = g_ui.createWidget("BotIcon", panel)
  icon.botWidget = true
  icon.botIcon = true

  icon.onDragEnter = function(widget, mousePos)
    if not modules.corelib.g_keyboard.isCtrlPressed() then return false end

    widget:breakAnchors()
    widget.movingReference = {
      x = mousePos.x - widget:getX(),
      y = mousePos.y - widget:getY()
    }

    return true
  end

  icon.onDragMove = function(widget, mousePos)
    local parent = widget:getParent()
    if not parent or not widget.movingReference then return false end

    local pr = parent:getRect()
    local x = mousePos.x - widget.movingReference.x
    local y = mousePos.y - widget.movingReference.y

    x = clamp(x, pr.x, pr.x + pr.width - widget:getWidth())
    y = clamp(y, pr.y - parent:getMarginTop(), pr.y + pr.height - widget:getHeight())

    widget:move(x, y)
    return true
  end

  icon.onDragLeave = function(widget)
    local st = iconsStorage[key]
    local row = LNS_ICON.rows[key]
    local parent = widget:getParent()
    if not st or not parent then return true end

    local pr = parent:getRect()
    local x = widget:getX() - pr.x
    local y = widget:getY() - pr.y
    local width = pr.width - widget:getWidth()
    local height = pr.height - widget:getHeight()

    st.x = math.floor(clamp((x / math.max(1, width)) * 100, 0, 100) + 0.5)
    st.y = math.floor(clamp((y / math.max(1, height)) * 100, 0, 100) + 0.5)

    widget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
    widget:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
    applyRelativePos(widget, st)

    if row then
      row.editX._lnsBlock = true
      row.editY._lnsBlock = true
      row.editX:setText(tostring(st.x))
      row.editY:setText(tostring(st.y))
      row.editX._lnsBlock = false
      row.editY._lnsBlock = false
    end

    saveIcons()
    return true
  end

  icon.onClick = function()
    if pack.def and pack.def.onClick then
      pcall(pack.def.onClick)
    end
    updateIcon(key)
  end

  icon.onGeometryChange = function(widget)
    if widget:isDragging() then return end
    local st = iconsStorage[key]
    if st then applyRelativePos(widget, st) end
  end

  pack.icon = icon
  updateIcon(key)
end

local function bindRow(key, row)
  local pack = LNS_ICON.icons[key]
  local def = pack.def
  local st = iconsStorage[key]

  setBotItemId(row.itemIcone, tonumber(st.itemId) or def.itemId or 3555)
  row.textIcone:setText(st.text or def.text or key)
  row.editX:setText(tostring(st.x or 0))
  row.editY:setText(tostring(st.y or 0))
  row.ativarIcone:setOn(st.show == true)

  row.listaIcone.onClick = function()
    openItemPicker(key, row)
  end

  row.itemIcone.onItemChange = function(widget)
    local id = getItemId(widget)
    if id <= 0 then return end

    st.itemId = id
    saveIcons()
    updateIcon(key)
  end

  row.itemIcone.onItemIdChange = row.itemIcone.onItemChange

  row.textIcone.onTextChange = function(_, text)
    st.text = tostring(text or "")
    saveIcons()
    updateIcon(key)
  end

  row.editX.onTextChange = function(w, text)
    if w._lnsBlock then return end
    local n = tonumber(text)
    if not n then return end
    st.x = clamp(n, 0, 100)
    saveIcons()
    updateIcon(key)
  end

  row.editY.onTextChange = function(w, text)
    if w._lnsBlock then return end
    local n = tonumber(text)
    if not n then return end
    st.y = clamp(n, 0, 100)
    saveIcons()
    updateIcon(key)
  end

  row.ativarIcone.onClick = function(widget)
    local state = not widget:isOn()
    widget:setOn(state)
    st.show = state == true
    saveIcons()
    createIcon(key)
    updateIcon(key)
  end
end

local function registerIcon(def)
  local key = def.key
  if not key then return end

  iconsStorage[key] = iconsStorage[key] or {
    show = def.show == true,
    itemId = def.itemId or 3555,
    text = def.text or key,
    x = def.x or 0,
    y = def.y or 0
  }

  local st = iconsStorage[key]
  st.x = clamp(st.x or 0, 0, 100)
  st.y = clamp(st.y or 0, 0, 100)
  st.itemId = tonumber(st.itemId) or def.itemId or 3555
  st.text = st.text or def.text or key
  st.show = st.show == true

  LNS_ICON.icons[key] = {
    def = def,
    icon = nil
  }

  local row = g_ui.createWidget("iconesRow", iconesInterface.flatp.lista)
  row:setId("row_" .. key)

  LNS_ICON.rows[key] = row

  bindRow(key, row)
  createIcon(key)
  saveIcons()
end

local function updateAllIcons()
  for key in pairs(LNS_ICON.icons) do
    updateIcon(key)
  end
end

--==================================================
-- AUTO ICONS MODEL
--==================================================

local boundStates = {}

local function callSave(saveFn)
  if type(saveFn) == "function" then
    pcall(saveFn)
  elseif type(saveCharStorage) == "function" and type(charStorage) == "table" then
    pcall(function() saveCharStorage(charStorage) end)
  end
  saveIcons()
end

local function isToggleWidget(toggle)
  local t = type(toggle)
  return t == "table" or t == "userdata"
end

local function getToggle(def)
  if type(def.getButton) ~= "function" then return nil end
  local ok, res = pcall(def.getButton)
  if ok and isToggleWidget(res) then return res end
  return nil
end

local function readToggle(toggle)
  if not isToggleWidget(toggle) then return nil end

  if toggle.isOn then
    local ok, res = pcall(function() return toggle:isOn() end)
    if ok then return res == true end
  end

  if toggle.isChecked then
    local ok, res = pcall(function() return toggle:isChecked() end)
    if ok then return res == true end
  end

  return nil
end

local function setToggle(toggle, state)
  if not isToggleWidget(toggle) then return end
  state = state == true

  if toggle.setOn then
    pcall(function() toggle:setOn(state) end)
    return
  end

  if toggle.setChecked then
    pcall(function() toggle:setChecked(state) end)
    return
  end
end

local function safeStoreTable(store)
  if type(store) == "table" then return store end
  if type(charStorage) == "table" then return charStorage end
  return storage
end

local function readStorage(def)
  local store = safeStoreTable(type(def.store) == "function" and def.store() or nil)
  local key = def.storageKey or def.switch or def.button or def.key

  if type(store[key]) == "table" then
    if store[key].enabled ~= nil then return store[key].enabled == true end
    if store[key].active ~= nil then return store[key].active == true end
    if store[key].isOn ~= nil then return store[key].isOn == true end
    if store[key].value ~= nil then return store[key].value == true end
    return false
  end

  return store[key] == true
end

local function writeStorage(def, state)
  local store = safeStoreTable(type(def.store) == "function" and def.store() or nil)
  local key = def.storageKey or def.switch or def.button or def.key
  state = state == true

  if type(store[key]) == "table" then
    if store[key].enabled ~= nil then
      store[key].enabled = state
    elseif store[key].active ~= nil then
      store[key].active = state
    elseif store[key].isOn ~= nil then
      store[key].isOn = state
    elseif store[key].value ~= nil then
      store[key].value = state
    else
      store[key].enabled = state
    end
  else
    store[key] = state
  end
end

local function readState(def)
  if type(def.read) == "function" then
    local ok, res = pcall(def.read)
    if ok and res ~= nil then return res == true end
  end

  local toggle = getToggle(def)
  local tState = readToggle(toggle)
  if tState ~= nil then return tState end

  return readStorage(def)
end

local function applyVisual(def, state, toggle)
  boundStates[def.key] = state == true
  setToggle(toggle, state)

  local pack = LNS_ICON.icons[def.key]
  local icon = pack and pack.icon

  if icon and icon.status then
    icon.status:show()
    icon.status:setOn(state == true)
  end

  callSave(def.save)
end

local function setState(def, state, toggle)
  state = state == true

  if type(def.write) == "function" then
    pcall(def.write, state)
  else
    writeStorage(def, state)
  end

  applyVisual(def, state, toggle)
end

local function clickRealButton(def, toggle)
  if not isToggleWidget(toggle) then
    setState(def, not readState(def), nil)
    return
  end

  if type(toggle.onClick) == "function" then
    pcall(toggle.onClick, toggle)
  else
    local current = readToggle(toggle)
    setToggle(toggle, not (current == true))
  end

  local state = readToggle(toggle)
  if state == nil then
    state = readState(def)
  end

  if type(def.write) == "function" then
    pcall(def.write, state == true)
  else
    writeStorage(def, state == true)
  end

  applyVisual(def, state == true, toggle)
end

local function makeAutoIcon(def)
  return {
    key = def.key,
    itemId = def.itemId or 3555,
    text = def.text or def.key,
    font = def.font or "verdana-9px",
    x = def.x or 0,
    y = def.y or 0,
    show = def.show == true,

    getState = function()
      return readState(def)
    end,

    onClick = function()
      clickRealButton(def, getToggle(def))
    end,

    _autoBind = def
  }
end

local function bindAutoIcon(def)
  local tries = 0
  local maxTries = 200
  local lock = false

  local function tryBind()
    tries = tries + 1

    local pack = LNS_ICON.icons[def.key]
    local icon = pack and pack.icon
    local toggle = getToggle(def)

    if not icon then
      if tries < maxTries then later(100, tryBind) end
      return
    end

    applyVisual(def, readState(def), toggle)

    if isToggleWidget(toggle) then
      local oldClick = toggle.onClick

      toggle.onClick = function(widget, ...)
        if lock then return end
        lock = true

        if type(oldClick) == "function" then
          pcall(oldClick, widget, ...)
        else
          local current = readToggle(widget)
          setToggle(widget, not (current == true))
        end

        local state = readToggle(widget)
        if state == nil then state = readState(def) end

        applyVisual(def, state == true, widget)

        lock = false
      end
    end

    icon.onClick = function()
      if lock then return end

      clickRealButton(def, getToggle(def))
      updateIcon(def.key)
    end
  end

  tryBind()
end

--==================================================
-- HELPERS CONDITIONS
--==================================================

local function getConditionsSwitch(id)
  if not conditionsInterface then return nil end
  if conditionsInterface.recursiveGetChildById then
    return conditionsInterface:recursiveGetChildById(id)
  end
  return nil
end

local function readConditionSwitch(id)
  if type(charStorage) ~= "table" then return false end
  charStorage.conditionsInterface = charStorage.conditionsInterface or {}
  charStorage.conditionsInterface.switches = charStorage.conditionsInterface.switches or {}
  return charStorage.conditionsInterface.switches[id] == true
end

local function writeConditionSwitch(id, state)
  if type(charStorage) ~= "table" then return end
  charStorage.conditionsInterface = charStorage.conditionsInterface or {}
  charStorage.conditionsInterface.switches = charStorage.conditionsInterface.switches or {}
  charStorage.conditionsInterface.switches[id] = state == true
end

local function saveConditionsIcon()
  if type(saveConditionsChar) == "function" then
    saveConditionsChar()
  elseif type(saveCharStorage) == "function" and type(charStorage) == "table" then
    saveCharStorage(charStorage)
  end
end

--==================================================
-- AUTO_ICONS
--==================================================

local AUTO_ICONS = {
  {
    key = "attackbot",
    storageKey = "comboButton",
    itemId = 3555,
    text = "ATK",
    store = function() return charStorage end,
    getButton = function() return comboButton and comboButton.title end,
    save = function() if type(saveAttackBotChar) == "function" then saveAttackBotChar() end end
  },

  {
    key = "attackbot_antired_full",
    itemId = 37339,
    text = "ANTI-RED FULL",
    show = false,

    read = function()
      local function isOn(widget)
        if not widget then return false end

        if widget.isOn then
          local ok, res = pcall(function() return widget:isOn() end)
          if ok then return res == true end
        end

        if widget.isChecked then
          local ok, res = pcall(function() return widget:isChecked() end)
          if ok then return res == true end
        end

        return false
      end

      local exitFragsWidget =
        (comboInterface and comboInterface.deslogarFrags) or
        (panelSpellsUnsafe and panelSpellsUnsafe.deslogarFrags)

      return isOn(comboInterface and comboInterface.manterDist)
        and isOn(comboInterface and comboInterface.checkPlayers)
        and isOn(comboInterface and comboInterface.checkFloors)
        and isOn(comboInterface and comboInterface.checkStairs)
        and isOn(exitFragsWidget)
    end,

    write = function(state)
      state = state == true

      local function isOn(widget)
        if not widget then return false end

        if widget.isOn then
          local ok, res = pcall(function() return widget:isOn() end)
          if ok then return res == true end
        end

        if widget.isChecked then
          local ok, res = pcall(function() return widget:isChecked() end)
          if ok then return res == true end
        end

        return false
      end

      local function setWanted(widget, wanted)
        if not widget then return false end
        if isOn(widget) == wanted then return true end

        if type(widget.onClick) == "function" then
          pcall(widget.onClick, widget)
          return true
        end

        if widget.setOn then
          pcall(function() widget:setOn(wanted) end)
          return true
        end

        if widget.setChecked then
          pcall(function() widget:setChecked(wanted) end)
          return true
        end

        return false
      end

      local exitFragsWidget =
        (comboInterface and comboInterface.deslogarFrags) or
        (panelSpellsUnsafe and panelSpellsUnsafe.deslogarFrags)

      local ok = true
      ok = setWanted(comboInterface and comboInterface.manterDist, state) and ok
      ok = setWanted(comboInterface and comboInterface.checkPlayers, state) and ok
      ok = setWanted(comboInterface and comboInterface.checkFloors, state) and ok
      ok = setWanted(comboInterface and comboInterface.checkStairs, state) and ok
      ok = setWanted(exitFragsWidget, state) and ok

      if not ok then
        warn("[Icon ANTI-RED FULL] Carregue o AttackBot antes dos icones ou abra o painel do AttackBot uma vez.")
      end

      if type(saveAttackBotChar) == "function" then
        saveAttackBotChar()
      elseif type(saveCharStorage) == "function" and type(charStorage) == "table" then
        saveCharStorage(charStorage)
      end
    end,

    save = function()
      if type(saveAttackBotChar) == "function" then
        saveAttackBotChar()
      elseif type(saveCharStorage) == "function" and type(charStorage) == "table" then
        saveCharStorage(charStorage)
      end
    end
  },

  {
    key = "healing",
    storageKey = "healingButton",
    itemId = 7643,
    text = "HEALING",
    store = function()
      if type(charStorage) == "table" and charStorage.healingButton ~= nil then return charStorage end
      return storage
    end,
    getButton = function() return healingButton and healingButton.title end,
    save = function() if type(saveHealingChar) == "function" then saveHealingChar() end end
  },

  {
    key = "conditions",
    storageKey = "conditionsButton",
    itemId = 4115,
    text = "CONDITIONS",
    store = function() return charStorage end,
    getButton = function() return conditionsButton and conditionsButton.title end,
    save = function() if type(saveConditionsChar) == "function" then saveConditionsChar() end end
  },

  {
    key = "cond_haste",
    itemId = 3079,
    text = "HASTE",
    show = false,
    read = function() return readConditionSwitch("spellHaste") end,
    write = function(state) writeConditionSwitch("spellHaste", state) end,
    getButton = function() return getConditionsSwitch("spellHaste") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_buff",
    itemId = 3411,
    text = "BUFF",
    show = false,
    read = function() return readConditionSwitch("spellBuff") end,
    write = function(state) writeConditionSwitch("spellBuff", state) end,
    getButton = function() return getConditionsSwitch("spellBuff") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_antilyze",
    itemId = 3160,
    text = "ANTI LYZE",
    show = false,
    read = function() return readConditionSwitch("spellAntilyze") end,
    write = function(state) writeConditionSwitch("spellAntilyze", state) end,
    getButton = function() return getConditionsSwitch("spellAntilyze") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_utura",
    itemId = 3160,
    text = "UTURA",
    show = false,
    read = function() return readConditionSwitch("spellUtura") end,
    write = function(state) writeConditionSwitch("spellUtura", state) end,
    getButton = function() return getConditionsSwitch("spellUtura") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_utamo",
    itemId = 3051,
    text = "UTAMO",
    show = false,
    read = function() return readConditionSwitch("spellUtamo") end,
    write = function(state) writeConditionSwitch("spellUtamo", state) end,
    getButton = function() return getConditionsSwitch("spellUtamo") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_utana",
    itemId = 3086,
    text = "UTANA",
    show = false,
    read = function() return readConditionSwitch("spellUtana") end,
    write = function(state) writeConditionSwitch("spellUtana", state) end,
    getButton = function() return getConditionsSwitch("spellUtana") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_cure_status",
    itemId = 3153,
    text = "CURE",
    show = false,
    read = function() return readConditionSwitch("cureStatus") end,
    write = function(state) writeConditionSwitch("cureStatus", state) end,
    getButton = function() return getConditionsSwitch("cureStatus") end,
    save = saveConditionsIcon
  },

  {
    key = "healingfriend",
    storageKey = "sioButton",
    itemId = 3160,
    text = "HEALFRIEND",
    store = function() return charStorage end,
    getButton = function() return sioButton and sioButton.title end,
    save = function() if type(saveHealFriendChar) == "function" then saveHealFriendChar() end end
  },

  {
    key = "follow",
    storageKey = "followButton",
    itemId = 10798,
    text = "FOLLOW",
    store = function() return charStorage end,
    getButton = function() return followButton and followButton.title end,
    save = function() if type(saveFollow2) == "function" then saveFollow2() end end
  },

  {
    key = "eqmanager",
    storageKey = "eqManagerButton",
    itemId = 28719,
    text = "EQ MANAGER",
    store = function() return charStorage end,
    getButton = function() return eqManagerButton and eqManagerButton.title end,
    save = function() if type(saveEqManagerChar) == "function" then saveEqManagerChar() end end
  },

  {
    key = "swap",
    storageKey = "swapButton",
    itemId = 3081,
    text = "SWAP",
    store = function() return charStorage end,
    getButton = function() return swapButton and swapButton.title end,
    save = function() if type(saveSmartSwapChar) == "function" then saveSmartSwapChar() end end
  },

  {
    key = "prey",
    storageKey = "preyButton",
    itemId = 9056,
    text = "AUTO PREY",
    store = function() return charStorage end,
    getButton = function() return preyButton and preyButton.title end,
    save = function() if type(savePreyChar) == "function" then savePreyChar() end end
  },

  {
    key = "money",
    storageKey = "exchangeButton",
    itemId = 3043,
    text = "EXCHANGE",
    store = function() return charStorage end,
    getButton = function() return exchangeButton and exchangeButton.exchangeMoney end,
    save = function() if type(saveMoneyTrade) == "function" then saveMoneyTrade() end end
  },

  {
    key = "trade",
    itemId = 3232,
    text = "TRADE",
    read = function() return charStorage.moneySystem and charStorage.moneySystem.sendTrade == true end,
    write = function(state)
      charStorage.moneySystem = charStorage.moneySystem or {}
      charStorage.moneySystem.sendTrade = state
    end,
    getButton = function() return sendTrade and sendTrade.title end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "dropper",
    itemId = 2526,
    text = "DROPPER",
    read = function() return charStorage.moneySystem and charStorage.moneySystem.dropperEnabled == true end,
    write = function(state)
      charStorage.moneySystem = charStorage.moneySystem or {}
      charStorage.moneySystem.dropperEnabled = state
    end,
    getButton = function() return dropper and dropper.title end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "autoPT",
    storageKey = "autopartyui",
    itemId = 3435,
    text = "PARTY",
    store = function() return charStorage end,
    getButton = function() return autopartyui and autopartyui.status end,
    save = function() if type(saveAutoParty) == "function" then saveAutoParty() end end
  },

  {
    key = "food",
    storageKey = "eatFood",
    itemId = 6279,
    text = "FOOD",
    store = function() return charStorage end,
    getButton = function() return eatFood and eatFood.eatFood end,
    save = function() if type(saveEatFood) == "function" then saveEatFood() end end
  },

  {
    key = "stamina",
    itemId = 11372,
    text = "STAMINA",
    read = function() return charStorage.staminaUse and charStorage.staminaUse.enabled == true end,
    write = function(state)
      charStorage.staminaUse = charStorage.staminaUse or {}
      charStorage.staminaUse.enabled = state
    end,
    getButton = function() return stamina and stamina.staminacheck end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "comboLeader",
    storageKey = "comboLeaderButton",
    itemId = 3546,
    text = "ATK-LEADER",
    store = function() return charStorage end,
    getButton = function() return comboLeaderButton and comboLeaderButton.title end,
    save = function() if type(saveComboLeaderChar) == "function" then saveComboLeaderChar() end end
  },

  {
    key = "mwsystem",
    itemId = 10181,
    text = "MW SYSTEM",
    read = function() return charStorage.holdMwWgPanel and charStorage.holdMwWgPanel.enabled == true end,
    write = function(state)
      charStorage.holdMwWgPanel = charStorage.holdMwWgPanel or {}
      charStorage.holdMwWgPanel.enabled = state
    end,
    getButton = function() return mwButton and mwButton.title end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "mwsystem_hold_mw_wg",
    itemId = 3180,
    text = "HOLD MW/WG",
    show = false,

    read = function()
      if LNS_MWSystem and type(LNS_MWSystem.isHoldMwWg) == "function" then
        return LNS_MWSystem.isHoldMwWg() == true
      end

      return type(charStorage) == "table"
        and type(charStorage.holdMwWgPanel) == "table"
        and charStorage.holdMwWgPanel.iconHoldMwWg == true
    end,

    write = function(state)
      if LNS_MWSystem and type(LNS_MWSystem.setHoldMwWg) == "function" then
        LNS_MWSystem.setHoldMwWg(state == true)
      else
        warn("[Icon Hold MW/WG] LNS_MWSystem.setHoldMwWg nao encontrada. Carregue o MW System antes dos icones.")
      end
    end,

    save = function()
      if type(saveCharStorage) == "function" and type(charStorage) == "table" then
        saveCharStorage(charStorage)
      end
    end
  },

  {
    key = "mwsystem_front_click",
    itemId = 3180,
    text = "MW FRONT",
    show = false,

    -- ícone de ação: não é switch, só executa ao clicar
    read = function()
      return false
    end,

    write = function()
      if LNS_MWSystem and type(LNS_MWSystem.mwFront) == "function" then
        LNS_MWSystem.mwFront()
      else
        warn("[Icon MW Front] LNS_MWSystem.mwFront nao encontrada. Carregue o MW System antes dos icones.")
      end
    end
  },

  {
    key = "mwsystem_back_click",
    itemId = 3180,
    text = "MW BACK",
    show = false,

    -- ícone de ação: não é switch, só executa ao clicar
    read = function()
      return false
    end,

    write = function()
      if LNS_MWSystem and type(LNS_MWSystem.mwBack) == "function" then
        LNS_MWSystem.mwBack()
      else
        warn("[Icon MW Back] LNS_MWSystem.mwBack nao encontrada. Carregue o MW System antes dos icones.")
      end
    end
  },

  {
    key = "pushmax",
    itemId = 5090,
    text = "PUSHMAX",
    getButton = function() return mainUI and mainUI.switch end,
    save = function() if type(saveConfig) == "function" then saveConfig() end end
  },

  {
    key = "dropFlower",
    storageKey = "dropFlorButton",
    itemId = 2981,
    text = "DROP FLOWER",
    store = function() return charStorage end,
    getButton = function() return dropFlorButton and dropFlorButton.title end,
    save = function() if type(saveDropFlorChar) == "function" then saveDropFlorChar() end end
  },

  {
    key = "antipush",
    storageKey = "AntiPushButton",
    itemId = 3492,
    text = "ANTI PUSH",
    store = function() return charStorage end,
    getButton = function() return AntiPushButton and AntiPushButton.title end,
    save = function() if type(saveThisCharStorage) == "function" then saveThisCharStorage() end end
  },

  {
    key = "pickup",
    storageKey = "PickUpButton",
    itemId = 3217,
    text = "PICK ITEMS",
    store = function() return charStorage end,
    getButton = function() return PickUpButton and PickUpButton.title end,
    save = function() if type(savepickUp) == "function" then savepickUp() end end
  },

  {
    key = "pullall",
    storageKey = "pushAllButton",
    itemId = 34079,
    text = "PULL ITEMS",
    store = function() return charStorage end,
    getButton = function() return pushAllButton and pushAllButton.title end,
    save = function() if type(saveThisCharStorage) == "function" then saveThisCharStorage() end end
  },

  {
    key = "war_full_equip",
    storageKey = "lnsFullTank",
    itemId = 21435,
    text = "FULL EQ",
    store = function()
      return charStorage
    end,
    getButton = function()
      return ui and ui.enable
    end,
    save = function()
      if type(saveCharStorage) == "function" then
        saveCharStorage(charStorage)
      end
    end
  },

  {
    key = "war_double_ue_click",
    itemId = 21463,
    text = "DOUBLE UE",
    show = false,

    -- sempre falso porque esse icone nao é switch, é botao de ação
    read = function()
      return false
    end,

    -- ao clicar no icone, executa a Double UE direto
    write = function()
      if lnsDoubleUE and lnsDoubleUE.iconExecute then
        lnsDoubleUE.iconExecute()
      else
        warn("[Icon Double UE] lnsDoubleUE.iconExecute nao encontrada. Verifique se o bloco foi colado no war.lua.")
      end
    end
  },

  {
    key = "exivaTarget",
    storageKey = "exivaTargetSwitch",
    itemId = 29342,
    text = "EXIVA TARGET",
    store = function() return charStorage end,
    getButton = function() return exivaInterface and exivaInterface.exivaTarget end,
    save = function() if type(saveExivaChar) == "function" then saveExivaChar() end end
  },

  {
    key = "exivax",
    storageKey = "xExivaSwitch",
    itemId = 29343,
    text = "xEXIVA",
    store = function() return charStorage end,
    getButton = function() return exivaInterface and exivaInterface.xExiva end,
    save = function() if type(saveExivaChar) == "function" then saveExivaChar() end end
  },

  {
    key = "targetbot",
    itemId = 3283,
    text = "TARGETBOT",
    show = false,
    read = function() return TargetBot and TargetBot.isOn and TargetBot.isOn() end,
    write = function(state)
      if not TargetBot then return end
      if state then
        if TargetBot.setOn then TargetBot.setOn() end
      else
        if TargetBot.setOff then TargetBot.setOff() end
      end
    end
  },

  {
    key = "cavebot",
    itemId = 9196,
    text = "CAVEBOT",
    show = false,
    read = function() return CaveBot and CaveBot.isOn and CaveBot.isOn() end,
    write = function(state)
      if not CaveBot then return end
      if state then
        if CaveBot.setOn then CaveBot.setOn() end
      else
        if CaveBot.setOff then CaveBot.setOff() end
      end
    end
  },

  {
    key = "chase_mode",
    itemId = 52662,
    text = "CHASE",
    show = false,

    read = function()
      return g_game and g_game.getChaseMode and g_game.getChaseMode() == 1
    end,

    write = function(state)
      if not g_game or not g_game.setChaseMode or not g_game.getChaseMode then return end

      if state == true then
        if g_game.getChaseMode() ~= 1 then
          g_game.setChaseMode(1)
        end
      else
        if g_game.getChaseMode() ~= 0 then
          g_game.setChaseMode(0)
        end
      end
    end
  },

  {
    key = "util_open_next_bp",
    storageKey = "proximaBp",
    itemId = 2854,
    text = "NEXT BP",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp and utilityInterface.flatp.proximaBp end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_loot_chest",
    storageKey = "LootChest",
    itemId = 19250,
    text = "LOOT CHEST",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp and utilityInterface.flatp.LootChest end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_hold_target",
    storageKey = "HoldTarget",
    itemId = 3409,
    text = "HOLD TARGET",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.HoldTarget end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_super_dash",
    storageKey = "SuperDash",
    itemId = 3079,
    text = "DASH",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.SuperDash end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_dancing",
    storageKey = "Dancing",
    itemId = 6576,
    text = "DANCING",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.Dancing end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_hold_position",
    storageKey = "HoldPosition",
    itemId = 2025,
    text = "HOLD POS",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.HoldPosition end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_sleep_mode",
    storageKey = "SleepMode",
    itemId = 694,
    text = "SLEEP",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.SleepMode end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_hide_sprites",
    storageKey = "EsconderSprites",
    itemId = 3248,
    text = "HIDE SPRITE",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.EsconderSprites end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_hide_texts",
    storageKey = "EsconderTextos",
    itemId = 3509,
    text = "HIDE TXT",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.EsconderTextos end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_auto_mount",
    storageKey = "AutoMount",
    itemId = 9196,
    text = "FULL MOUNT",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.AutoMount end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_auto_ban",
    storageKey = "AutoBan",
    itemId = 3547,
    text = "BAN CAST",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.AutoBan end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_auto_summon",
    storageKey = "SummonF",
    itemId = 38677,
    text = "SUMMON",
    store = function()
      charStorage.utilityPanel = charStorage.utilityPanel or {}
      return charStorage.utilityPanel
    end,
    getButton = function()
      return utilityInterface
        and utilityInterface.flatp2
        and utilityInterface.flatp2.SummonF
    end,
    save = function()
      if type(saveCharStorage) == "function" then
        saveCharStorage(charStorage)
      end
    end
  },

  {
    key = "util_exeta_res",
    storageKey = "ExetaRes",
    itemId = 3077,
    text = "EXETA RES",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.ExetaRes end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_exeta_loot",
    storageKey = "ExetaLoot",
    itemId = 3031,
    text = "EXETA LOOT",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.ExetaLoot end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_amp_res",
    storageKey = "AmpRes",
    itemId = 3160,
    text = "AMP RES",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.AmpRes end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_wall_hugger",
    storageKey = "WallHugger",
    itemId = 10455,
    text = "WALL HUGGER",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.WallHugger end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_auto_aol",
    storageKey = "autoAol",
    itemId = 3057,
    text = "AUTO AOL",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.autoAol end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_esconder_andares",
    storageKey = "esconderAndares",
    itemId = 20478,
    text = "HIDE FLOOR",
    store = function() return charStorage.utilityPanel end,
    getButton = function()
      return utilityInterface
        and utilityInterface.flatp2
        and utilityInterface.flatp2.esconderAndares
    end,
    save = function()
      if type(saveCharStorage) == "function" then
        saveCharStorage(charStorage)
      end
    end
  },

  {
    key = "util_dash_mouse",
    storageKey = "dashMouse",
    itemId = 3079,
    text = "DASH MOUSE",
    store = function() return charStorage.utilityPanel end,
    getButton = function()
      return utilityInterface
        and utilityInterface.flatp2
        and utilityInterface.flatp2.dashMouse
    end,
    save = function()
      if type(saveCharStorage) == "function" then
        saveCharStorage(charStorage)
      end
    end
  },

  {
    key = "util_utevo_lux",
    storageKey = "utevoLux",
    itemId = 3241,
    text = "UTEVO LUX",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.utevoLux end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_mana_train",
    storageKey = "manaTrain",
    itemId = 3160,
    text = "MANA TRAIN",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.manaTrain end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_mana_train_mage",
    storageKey = "manaTrainMage",
    itemId = 23373,
    text = "TRAIN MAGE",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.manaTrainMage end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "manual_imbue_all",
    itemId = 14513,
    text = "M.IMBUE",
    show = false,

    -- icone de ação, não fica ligado/desligado
    read = function()
      return false
    end,

    write = function()
      if type(startImbueAllFromList) == "function" then
        startImbueAllFromList(true)
      else
        warn("[Icon M.IMBUE] startImbueAllFromList nao encontrada. Carregue a script de Imbue antes dos icones.")
      end
    end
  },
  
  {
    key = "scroll_blank_imbue",
    itemId = 51442,
    text = "S.IMBUE",
    show = false,
    read = function()
      return type(isScrollImbueBlankActive) == "function" and isScrollImbueBlankActive() == true
    end,
    write = function(state)
      if state == true then
        if type(startScrollImbueBlank) == "function" then
          startScrollImbueBlank()
        else
          warn("[Icones] startScrollImbueBlank nao encontrada. Carregue o Imbue Scroll antes dos icones.")
        end
      else
        if type(stopScrollImbueBlank) == "function" then
          stopScrollImbueBlank()
        end
      end
    end,
    save = function()
      if type(saveCharStorage) == "function" and type(charStorage) == "table" then
        saveCharStorage(charStorage)
      end
    end
  },

  {
    key = "scroll_item_imbue",
    itemId = 51464,
    text = "I.SCROLL",
    show = false,
    read = function()
      if type(isScrollImbueItemsEnabled) == "function" then
        return isScrollImbueItemsEnabled() == true
      end
      return type(charStorage) == "table"
        and type(charStorage.scrollImbue) == "table"
        and charStorage.scrollImbue.itemAutoEnabled == true
    end,
    write = function(state)
      if type(setScrollImbueItemsAuto) == "function" then
        setScrollImbueItemsAuto(state == true)
        return
      end

      if type(charStorage) == "table" then
        charStorage.scrollImbue = charStorage.scrollImbue or {}
        charStorage.scrollImbue.itemAutoEnabled = state == true
        if type(saveCharStorage) == "function" then
          saveCharStorage(charStorage)
        end
      else
        warn("[Icones] setScrollImbueItemsAuto nao encontrada. Carregue o Imbue Scroll antes dos icones.")
      end
    end,
    save = function()
      if type(saveCharStorage) == "function" and type(charStorage) == "table" then
        saveCharStorage(charStorage)
      end
    end
  }

}

local ICON_DEFS = {}
for _, def in ipairs(AUTO_ICONS) do
  table.insert(ICON_DEFS, makeAutoIcon(def))
end

for _, def in ipairs(ICON_DEFS) do
  registerIcon(def)
end

for _, def in ipairs(AUTO_ICONS) do
  bindAutoIcon(def)
end


--==================================================
-- PUSHMAX: SETAS AO REDOR DO ICONE
--==================================================

local LNS_PUSHMAX_ARROWS = {
  widgets = {},
  size = lnsIsMobile() and 34 or 28,
  defs = {
    { id = "nw", text = "NW", dx = -1, dy = -1, ox = -54, oy = -45 },
    { id = "n",  text = "N", dx =  0, dy = -1, ox =   0, oy = -58 },
    { id = "ne", text = "NE", dx =  1, dy = -1, ox =  54, oy = -45 },
    { id = "w",  text = "W", dx = -1, dy =  0, ox = -70, oy =   0 },
    { id = "e",  text = "E", dx =  1, dy =  0, ox =  70, oy =   0 },
    { id = "sw", text = "SW", dx = -1, dy =  1, ox = -54, oy =  48 },
    { id = "s",  text = "S", dx =  0, dy =  1, ox =   0, oy =  62 },
    { id = "se", text = "SE", dx =  1, dy =  1, ox =  54, oy =  48 }
  }
}

local function pushMaxIconWidget()
  local pack = LNS_ICON.icons["pushmax"]
  return pack and pack.icon or nil
end

local function isWidgetVisible(widget)
  if not widget then return false end
  if widget.isVisible then
    local ok, res = pcall(function() return widget:isVisible() end)
    if ok then return res == true end
  end
  if widget.isHidden then
    local ok, res = pcall(function() return widget:isHidden() end)
    if ok then return res ~= true end
  end
  return true
end

local function isPushMaxEnabledForArrows()
  local st = iconsStorage["pushmax"]
  local icon = pushMaxIconWidget()

  if not st or st.show ~= true or not isWidgetVisible(icon) then
    return false
  end

  -- Se o script PushMax ja carregou, usa o botao real dele.
  local btn = mainUI and mainUI.switch
  if btn then
    if btn.isOn then
      local ok, res = pcall(function() return btn:isOn() end)
      if ok then return res == true end
    end

    if btn.isChecked then
      local ok, res = pcall(function() return btn:isChecked() end)
      if ok then return res == true end
    end
  end

  -- Fallback direto no charStorage, caso o botao ainda nao tenha bindado.
  return type(charStorage) == "table"
    and type(charStorage.pvpSystem) == "table"
    and type(charStorage.pvpSystem.pushSystem) == "table"
    and charStorage.pvpSystem.pushSystem.enabled == true
end

local function hidePushMaxArrows()
  for _, w in pairs(LNS_PUSHMAX_ARROWS.widgets) do
    if w then pcall(function() w:hide() end) end
  end
end

if not LNS_PUSHMAX_ARROW_UI_LOADED then
  LNS_PUSHMAX_ARROW_UI_LOADED = true

  g_ui.loadUIFromString([[
LNSPushMaxArrow < UIWidget
  size: 34 34
  phantom: false
  focusable: false

  Item
    id: item
    anchors.centerIn: parent
    size: 32 32
    phantom: true

  Label
    id: dir
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.bottom: prev.bottom
    margin-bottom: 1
    margin-left: 5
    color: #ff7a00
    font: verdana-11px-rounded
    phantom: true
]])
end

local function setArrowItem(widget, itemId)
  if not widget then return end
  itemId = tonumber(itemId) or 3541

  if widget.setItemId then
    widget:setItemId(itemId)
    return
  end

  if widget.setItem and Item and Item.create then
    widget:setItem(Item.create(itemId, 1))
  end
end

local function ensurePushMaxArrow(def)
  local w = LNS_PUSHMAX_ARROWS.widgets[def.id]
  if w then return w end

  local panel = modules.game_interface and modules.game_interface.gameMapPanel
  if not panel then return nil end

  w = g_ui.createWidget("LNSPushMaxArrow", panel)
  w.botWidget = true
  w.botIcon = true
  w:setId("lnsPushMaxArrow_" .. def.id)
  w:setTooltip("PushMax " .. def.text)
  w:setSize(LNS_PUSHMAX_ARROWS.size .. " " .. LNS_PUSHMAX_ARROWS.size)

  if w.item then
    setArrowItem(w.item, 3541)
  end

  if w.dir then
    w.dir:setText(def.text)
    w.dir:setTextAlign(AlignCenter)
    w.dir:setColor("#ff7a00")
    if w.dir.setFont then
      w.dir:setFont("verdana-11px-rounded")
    end
  end

  if w.setOpacity then
    w:setOpacity(0.95)
  end

  local function executeArrowPush()
    if type(LNS_PushMaxIconPush) == "function" then
        pcall(LNS_PushMaxIconPush, def.dx, def.dy)
    elseif modules and modules.game_textmessage then
        modules.game_textmessage.displayGameMessage("Carregue o PushMax antes dos icones.")
    end
  end

  w.onMousePress = function(widget, mousePos, button)
    executeArrowPush()
      return true
  end

  w.onMouseRelease = function(widget, mousePos, button)
      if button == MouseLeftButton or button == nil then
      end
      return true
  end

  w.onClick = function()
      return true
  end

  w.onDoubleClick = function()
      return true
  end

  LNS_PUSHMAX_ARROWS.widgets[def.id] = w
  return w
end

local function updatePushMaxArrows()
  local icon = pushMaxIconWidget()
  if not icon or not isPushMaxEnabledForArrows() then
    hidePushMaxArrows()
    return
  end

  local cx = icon:getX() + (icon:getWidth() / 2)
  local cy = icon:getY() + (icon:getHeight() / 2)

  for _, def in ipairs(LNS_PUSHMAX_ARROWS.defs) do
    local w = ensurePushMaxArrow(def)
    if w then
      local x = math.floor(cx + def.ox - (w:getWidth() / 2))
      local y = math.floor(cy + def.oy - (w:getHeight() / 2))

      w:breakAnchors()
      w:move(x, y)
      w:show()
      w:raise()
    end
  end

  -- Mantem o icone central acima/visivel junto com as setas.
  pcall(function() icon:raise() end)
end

macro(80, function()
  updatePushMaxArrows()
end)


--==================================================
-- MW/WG: CURSORES AO LADO DO ICONE HOLD MW/WG
--==================================================

local LNS_MW_CURSOR_ICONS = {
  widgets = {},
  width = lnsIsMobile() and 64 or 58,
  height = lnsIsMobile() and 46 or 42,
  defs = {
    -- ficam embaixo do HOLD MW/WG, nos dois quadrados marcados
    { id = "mw", text = "CURSOR MW", fn = "cursorMw", stateFn = "isCursorMw", itemId = 3180, storageRune = "mwRune", ox = -33, oy = 52 },
    { id = "wg", text = "CURSOR WG", fn = "cursorWg", stateFn = "isCursorWg", itemId = 3156, storageRune = "wgRune", ox =  33, oy = 52 }
  }
}

local function holdMwWgIconWidget()
  local pack = LNS_ICON.icons["mwsystem_hold_mw_wg"]
  return pack and pack.icon or nil
end

local function isHoldMwWgEnabledForCursorIcons()
  local st = iconsStorage["mwsystem_hold_mw_wg"]
  local icon = holdMwWgIconWidget()

  if not st or st.show ~= true or not isWidgetVisible(icon) then
    return false
  end

  if LNS_MWSystem and type(LNS_MWSystem.isHoldMwWg) == "function" then
    local ok, res = pcall(LNS_MWSystem.isHoldMwWg)
    if ok then return res == true end
  end

  return type(charStorage) == "table"
    and type(charStorage.holdMwWgPanel) == "table"
    and charStorage.holdMwWgPanel.iconHoldMwWg == true
end

local function hideMwCursorIcons()
  for _, w in pairs(LNS_MW_CURSOR_ICONS.widgets) do
    if w then pcall(function() w:hide() end) end
  end

  if LNS_MWSystem and type(LNS_MWSystem.stopCursor) == "function" then
    pcall(LNS_MWSystem.stopCursor)
  end
end

if not LNS_MW_CURSOR_ICON_UI_LOADED then
  LNS_MW_CURSOR_ICON_UI_LOADED = true

  g_ui.loadUIFromString([[
LNSMWCursorIcon < UIWidget
  size: 58 42
  phantom: false
  focusable: false

  Item
    id: item
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    margin-top: -1
    size: 28 28
    phantom: true

  Label
    id: title
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-bottom: 0
    color: white
    font: verdana-9px
    text-align: center
    phantom: true
]])
end

local function getMwCursorIconItemId(def)
  local cfg = type(charStorage) == "table" and charStorage.holdMwWgPanel or nil
  return tonumber(cfg and cfg[def.storageRune]) or tonumber(def.itemId) or 0
end

local function isMwCursorIconActive(def)
  if LNS_MWSystem and def and def.stateFn and type(LNS_MWSystem[def.stateFn]) == "function" then
    local ok, res = pcall(LNS_MWSystem[def.stateFn])
    return ok and res == true
  end
  return false
end

local function applyMwCursorIconVisual(w, def)
  if not w then return end

  local active = isMwCursorIconActive(def)

  if w.title then
    w.title:setColor(active and "#00ff00" or "white")
  end

  if w.setOpacity then
    w:setOpacity(active and 1.00 or 0.90)
  end

  if w.setTooltip then
    w:setTooltip(def.text .. (active and " ON" or " OFF"))
  end
end

local function ensureMwCursorIcon(def)
  local w = LNS_MW_CURSOR_ICONS.widgets[def.id]
  if w then return w end

  local panel = modules.game_interface and modules.game_interface.gameMapPanel
  if not panel then return nil end

  w = g_ui.createWidget("LNSMWCursorIcon", panel)
  w.botWidget = true
  w.botIcon = true
  w:setId("lnsMwCursorIcon_" .. def.id)
  w:setTooltip(def.text)
  w:setSize(LNS_MW_CURSOR_ICONS.width .. " " .. LNS_MW_CURSOR_ICONS.height)

  if w.title then
    w.title:setText(def.text)
    w.title:setTextAlign(AlignCenter)
    w.title:setColor("white")
    if w.title.setFont then
      w.title:setFont("verdana-9px")
    end
  end

  if w.setOpacity then
    w:setOpacity(0.95)
  end

  local function executeCursor()
    if LNS_MWSystem and type(LNS_MWSystem[def.fn]) == "function" then
      pcall(LNS_MWSystem[def.fn])
      applyMwCursorIconVisual(w, def)
    elseif modules and modules.game_textmessage then
      modules.game_textmessage.displayGameMessage("Carregue o MW System antes dos icones.")
    end
  end

  w.onMousePress = function(widget, mousePos, button)
    executeCursor()
    return true
  end

  w.onMouseRelease = function(widget, mousePos, button)
    return true
  end

  w.onClick = function()
    return true
  end

  w.onDoubleClick = function()
    return true
  end

  LNS_MW_CURSOR_ICONS.widgets[def.id] = w
  return w
end

local function updateMwCursorIcons()
  local icon = holdMwWgIconWidget()
  if not icon or not isHoldMwWgEnabledForCursorIcons() then
    hideMwCursorIcons()
    return
  end

  local cx = icon:getX() + (icon:getWidth() / 2)
  local cy = icon:getY() + (icon:getHeight() / 2)

  for _, def in ipairs(LNS_MW_CURSOR_ICONS.defs) do
    local w = ensureMwCursorIcon(def)
    if w then
      if w.item then
        setArrowItem(w.item, getMwCursorIconItemId(def))
      end

      applyMwCursorIconVisual(w, def)

      local x = math.floor(cx + def.ox - (w:getWidth() / 2))
      local y = math.floor(cy + def.oy - (w:getHeight() / 2))

      w:breakAnchors()
      w:move(x, y)
      w:show()
      w:raise()
    end
  end

  pcall(function() icon:raise() end)
end

macro(120, function()
  updateMwCursorIcons()
end)


--==================================================
-- PESQUISA DE ICONES
--==================================================

iconesInterface.pesquisaIcons.onTextChange = function(_, text)
  local q = normalizeText(text)

  for _, def in ipairs(ICON_DEFS) do
    local row = LNS_ICON.rows[def.key]
    if row then
      local a = normalizeText(def.key)
      local b = normalizeText(def.text)

      if q == "" or a:find(q, 1, true) or b:find(q, 1, true) then
        row:show()
      else
        row:hide()
      end
    end
  end
end

macro(2000, function()
  updateAllIcons()
end)

updateAllIcons()
saveIcons()
end)
