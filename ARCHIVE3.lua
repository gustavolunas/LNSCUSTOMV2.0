do
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
local HOLD_GLOBAL_CD = 250
local TRAP_CD = 250

local mwLastCast = 0
local mwLastKey = { front = 0, back = 0 }
local mwTileCooldown = {}

local holdPressAt = 0
local holdCandidates = {}
local holdReadyAt = {}
local holdLastCast = 0

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

local function isSystemOn()
  return mwCfg and mwCfg.enabled == true
end

local function isWallId(id)
  id = tonumber(id)
  return id == tonumber(mwCfg.mwWall1) or id == tonumber(mwCfg.mwWall2) or
         id == tonumber(mwCfg.wgWall1) or id == tonumber(mwCfg.wgWall2) or
         id == 16518
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

  if useWith(tonumber(mwCfg.mwRune) or 3180, top) then
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

-- API para outros scripts/ícones chamarem sem usar _G
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
  end

  refreshMwHoldButtons()
  saveMwStorage()
  return mwCfg.iconHoldMwWg == true
end

local function isHoldMwWgIconOn()
  return mwCfg.iconHoldMwWg == true
end

local function wallTextById(id)
  id = tonumber(id)

  if id == tonumber(mwCfg.mwWall1) or id == tonumber(mwCfg.mwWall2) or id == 16518 then
    return "MW Here"
  end

  if id == tonumber(mwCfg.wgWall1) or id == tonumber(mwCfg.wgWall2) then
    return "WG Here"
  end

  return nil
end

LNS_MWSystem.isHoldMwWg = function()
  return isHoldMwWgIconOn()
end

LNS_MWSystem.setHoldMwWg = function(state)
  return setHoldMwWgIcon(state == true)
end

LNS_MWSystem.toggleHoldMwWg = function()
  return setHoldMwWgIcon(not isHoldMwWgIconOn())
end


local holdMacro = macro(20, function()
  if not holdEnabled() then return end
  if #holdCandidates == 0 then return end
  if now - holdLastCast < HOLD_GLOBAL_CD then return end

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
    if useWith(rune, top) then
      holdReadyAt[k] = now + HOLD_GLOBAL_CD
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

      if useWith(tonumber(mwCfg.mwRune) or 3180, top) then
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

  if id == tonumber(mwCfg.mwWall1) or id == tonumber(mwCfg.mwWall2) or id == 16518 then
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
    local markText = wallTextById(id)
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
end

do
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

local function getUiChild(parent, id)
  if not parent then return nil end

  local child = nil

  pcall(function()
    child = parent[id]
  end)

  if child then return child end

  if parent.getChildById then
    pcall(function()
      child = parent:getChildById(id)
    end)
  end

  if child then return child end

  if parent.recursiveGetChildById then
    pcall(function()
      child = parent:recursiveGetChildById(id)
    end)
  end

  return child
end

local contentsPanel = getUiChild(main, "contentsPanel")
local bossList = getUiChild(contentsPanel, "bossList") or getUiChild(main, "bossList")
local addBossButton = getUiChild(contentsPanel, "addBoss") or getUiChild(main, "addBoss")
local ativarBossButton = getUiChild(contentsPanel, "ativarBoss") or getUiChild(main, "ativarBoss")
local cavebotBossEdit = getUiChild(contentsPanel, "cavebotBoss") or getUiChild(main, "cavebotBoss")

if not contentsPanel or not bossList or not addBossButton or not ativarBossButton or not cavebotBossEdit then
  print("[LNS Boss Timers] ERRO: contentsPanel/bossList/buttons nao carregaram. Confira a OTUI do painel.")
  return
end

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
  if not main or not bossList then return end
  bossList:destroyChildren()

  for i, b in ipairs(cfg.bosses) do
    local row = g_ui.createWidget("BossTimerRow", bossList)

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

addBossButton.onClick = function()
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
  if not main or not bossList then return end

  local children = bossList:getChildren()
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

ativarBossButton:setOn(cfg.autoCaveEnabled)
cavebotBossEdit:setText(cfg.autoCaveName)

ativarBossButton.onClick = function(widget)
  local state = not widget:isOn()
  widget:setOn(state)
  cfg.autoCaveEnabled = state
  save()
end

cavebotBossEdit.onTextChange = function(widget, text)
  cfg.autoCaveName = text
  save()
end


local function disableAutoBossButton()
  cfg.autoCaveEnabled = false
  save()

  if main and ativarBossButton then
    ativarBossButton:setOn(false)
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
end

do
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
end