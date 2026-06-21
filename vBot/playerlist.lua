local link = "https://www.gunzodus.net/character/show/"
local spacing = "_"

local tabs = {"Friends", "Enemies", "BlackList"}
local colors = {"#03C04A", "#fc4c4e", "orange"}

local panelName = "playerList"

charStorage = charStorage or loadCharStorage()

charStorage[panelName] = charStorage[panelName] or {
  enemyList = {},
  friendList = {},
  blackList = {},
  groupMembers = true,
  outfits = false,
  marks = false,
  highlight = false
}

local config = charStorage[panelName]

local function savePlayerList()
  saveCharStorage(charStorage)
end

local playerTables = {config.friendList, config.enemyList, config.blackList}

-- functions
local function clearCachedPlayers()
  CachedFriends = {}
  CachedEnemies = {}
end

local refreshStatus = function()
    for _, spec in ipairs(getSpectators()) do
      if spec:isPlayer() and not spec:isLocalPlayer() then
        if config.outfits then
          local specOutfit = spec:getOutfit()
          if isFriend(spec:getName()) then
            if config.highlight then
              spec:setMarked('#0000FF')
            end
            specOutfit.head = 88
            specOutfit.body = 88
            specOutfit.legs = 88
            specOutfit.feet = 88
            spec:setOutfit(specOutfit)
          elseif isEnemy(spec:getName()) then
            if config.highlight then
              spec:setMarked('#FF0000')
            end
            specOutfit.head = 94
            specOutfit.body = 94
            specOutfit.legs = 94
            specOutfit.feet = 94
            spec:setOutfit(specOutfit)
          end
        end
      end
    end
end
refreshStatus()

local checkStatus = function(creature)
    if not creature:isPlayer() or creature:isLocalPlayer() then return end
  
    local specName = creature:getName()
    local specOutfit = creature:getOutfit()
  
    if isFriend(specName) then
      if config.highlight then
        creature:setMarked('#0000FF')
      end
      if config.outfits then
        specOutfit.head = 88
        specOutfit.body = 88
        specOutfit.legs = 88
        specOutfit.feet = 88
        creature:setOutfit(specOutfit)
      end
    elseif isEnemy(specName) then
      if config.highlight then
        creature:setMarked('#FF0000')
      end
      if config.outfits then
        specOutfit.head = 94
        specOutfit.body = 94
        specOutfit.legs = 94
        specOutfit.feet = 94
        creature:setOutfit(specOutfit)
      end
    end
end


rootWidget = g_ui.getRootWidget()
local ListWindow = nil

function openPlayerListWindow()
  if not ListWindow or ListWindow:isDestroyed() then
    warn("[PlayerList] Janela ainda nao foi carregada.")
    return false
  end

  ListWindow:show()
  ListWindow:raise()
  ListWindow:focus()
  return true
end

if rootWidget then
    ListWindow = UI.createWindow('PlayerListWindow', rootWidget)
    ListWindow:hide()
    -- settings
    ListWindow.settings.Members:setChecked(config.groupMembers)
    ListWindow.settings.Members.onClick = function(widget)
      config.groupMembers = not config.groupMembers
      if not config.groupMembers then
        savePlayerList()
        clearCachedPlayers()
      end
      refreshStatus()
      widget:setChecked(config.groupMembers)
    end
    ListWindow.settings.Outfit:setChecked(config.outfits)
    ListWindow.settings.Outfit.onClick = function(widget)
      config.outfits = not config.outfits
      widget:setChecked(config.outfits)
      savePlayerList()
      refreshStatus()
    end
    ListWindow.settings.NeutralsAreEnemy:setChecked(config.marks)
    ListWindow.settings.NeutralsAreEnemy.onClick = function(widget)
      config.marks = not config.marks
      savePlayerList()
      widget:setChecked(config.marks)
    end
    ListWindow.settings.Highlight:setChecked(config.highlight)
    ListWindow.settings.Highlight.onClick = function(widget)
      config.highlight = not config.highlight
      savePlayerList()
      widget:setChecked(config.highlight)
    end

    ListWindow.settings.AutoAdd:setChecked(config.autoAdd)
    ListWindow.settings.AutoAdd.onClick = function(widget)
      config.autoAdd = not config.autoAdd
      savePlayerList()
      widget:setChecked(config.autoAdd)
    end

    local TabBar = ListWindow.tmpTabBar
    TabBar:setContentWidget(ListWindow.tmpTabContent)
    local blacklistList

    for v = 1, 3 do
        local listPanel = g_ui.createWidget("tPanel") -- Creates Panel
        local playerList = playerTables[v]
        listPanel:setId(tabs[v].."Tab")
        TabBar:addTab(tabs[v], listPanel)

        -- elements
        local addButton = listPanel.add
        local nameTab = listPanel.name
        local list = listPanel.list
        if v == 3 then
          blacklistList = list
        end

        for i, name in ipairs(playerList) do
            local label = UI.createWidget("PlayerLabel", list)
            label:setText(name)
            label.remove.onClick = function()
                table.remove(playerList, table.find(playerList, name))
                label:destroy()
                savePlayerList()
                clearCachedPlayers()
                refreshStatus()
            end
            label.onMouseRelease = function(widget, mousePos, mouseButton)
              if mouseButton == 2 then
                local child = rootWidget:recursiveGetChildByPos(mousePos)
                if child == widget then
                  local menu = g_ui.createWidget('PopupMenu')
                  menu:setId("blzMenu")
                  menu:setGameMenu(true)
                  menu:addOption('Check Player', function()
                    local name = widget:getText():gsub(" ", spacing)
                    g_platform.openUrl(link..name)
                  end, "")
                  menu:addOption('Copy Name', function()
                    g_window.setClipboardText(widget:getText())
                  end, "")
                  menu:display(mousePos)
                  return true
                end
              end
            end
        end

        local tabButton = TabBar.buttonsPanel:getChildren()[v]

        tabButton.onStyleApply = function(widget)
            if TabBar:getCurrentTab() == widget then
                widget:setColor(colors[v])
            end 
        end

        -- callbacks
        addButton.onClick = function()
            local names = string.split(nameTab:getText(), ",")

            if #names == 0 then
              warn("vBot[PlayerList]: Name is missing!")
              return
            end

            for i=1,#names do
              local name = names[i]:trim()
              if name:len() == 0 then
                  warn("vBot[PlayerList]: Name is missing!")
              else
                  if not table.find(playerList, name) then
                      table.insert(playerList, name)
                      savePlayerList()
                      local label = UI.createWidget("PlayerLabel", list)
                      label:setText(name)
                      label.remove.onClick = function()
                          table.remove(playerList, table.find(playerList, name))
                          savePlayerList()
                          label:destroy()
                      end
                      label.onMouseRelease = function(widget, mousePos, mouseButton)
                        if mouseButton == 2 then
                          local child = rootWidget:recursiveGetChildByPos(mousePos)
                          if child == widget then
                            local menu = g_ui.createWidget('PopupMenu')
                            menu:setId("blzMenu")
                            menu:setGameMenu(true)
                            menu:addOption('Check Player', function()
                              local name = widget:getText():gsub(" ", "_")
                              local link = "https://www.gunzodus.net/character/show/"
                              g_platform.openUrl(link..name)
                            end, "")
                            menu:addOption('Copy Name', function()
                              g_window.setClipboardText(widget:getText())
                            end, "")
                            menu:display(mousePos)
                            return true
                          end
                        end
                      end
                      nameTab:setText("")
                  else
                      warn("vBot[PlayerList]: Player ".. name .." is already added!")
                      nameTab:setText("")
                  end
                  savePlayerList()
                  clearCachedPlayers()
                  refreshStatus()
              end
            end
        end

        nameTab.onKeyPress = function(widget, keyCode, keyboardModifiers)
          if keyCode ~= 5 then
            return false
          end
          addButton.onClick()
          return true
        end
    end

    function addBlackListPlayer(name)
      if table.find(config.blackList, name) then return end

      table.insert(config.blackList, name)
      savePlayerList()
      local label = UI.createWidget("PlayerLabel", blacklistList)
      label:setText(name)
      label.remove.onClick = function()
          table.remove(playerList, table.find(playerList, name))
          label:destroy()
          savePlayerList()
      end
      label.onMouseRelease = function(widget, mousePos, mouseButton)
        if mouseButton == 2 then
          local child = rootWidget:recursiveGetChildByPos(mousePos)
          if child == widget then
            local menu = g_ui.createWidget('PopupMenu')
            menu:setId("blzMenu")
            menu:setGameMenu(true)
            menu:addOption('Check Player', function()
              local name = widget:getText():gsub(" ", "_")
              local link = "https://www.gunzodus.net/character/show/"
              g_platform.openUrl(link..name)
            end, "")
            menu:addOption('Copy Name', function()
              g_window.setClipboardText(widget:getText())
            end, "")
            menu:display(mousePos)
            return true
          end
        end
      end
    end
end

onTextMessage(function(mode,text)
  if not config.autoAdd then return end
  if CaveBot.isOff() or TargetBot.isOff() then return end
  if not text:find("Warning! The murder of") then return end

    text = string.split(text, "Warning! The murder of ")[1]
    text = string.split(text, " was not justified.")[1]

    addBlackListPlayer(text)
end)

onCreatureAppear(function(creature)
    checkStatus(creature)
  end)
  
onPlayerPositionChange(function(x,y)
  if x.z ~= y.z then
    schedule(20, function()
      refreshStatus()
    end)
  end
end)
