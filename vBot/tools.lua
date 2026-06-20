-- tools tab
setDefaultTab("Tools")

macro(20, "Exchange money", function()
  if not storage.moneyItems[1] then return end
  local containers = g_game.getContainers()
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:getCount() == 100 then
          for m, moneyId in ipairs(storage.moneyItems) do
            if item:getId() == moneyId.id then
              return g_game.use(item)            
            end
          end
        end
      end
    end
  end
end)

UI.Separator()

if type(storage.moneyItems) ~= "table" then
  storage.moneyItems = {3031, 3035, 3043}
end

local moneyContainer = UI.Container(function(widget, items)
  storage.moneyItems = items
end, true)
moneyContainer:setHeight(35)
moneyContainer:setItems(storage.moneyItems)

UI.Separator()

macro(1000, "Send message on trade", function()
  local trade = getChannelId("advertising")
  if not trade then
    trade = getChannelId("trade")
  end
  if trade and storage.autoTradeMessage:len() > 0 then    
    sayChannel(trade, storage.autoTradeMessage)
    delay(30000)
  end
end)
UI.TextEdit(storage.autoTradeMessage or "I'm using LNS CUSTOM | Disc: https://discord.gg/6xUheuXSak", function(widget, text)    
  storage.autoTradeMessage = text
end)

UI.Separator()