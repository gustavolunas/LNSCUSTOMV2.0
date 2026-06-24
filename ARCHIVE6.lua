warning = function() 
    return  
end
warn = function() 
    return  
end
error = function() 
    return  
end

print("OLD LOADER CARREGADO!")
local rawUrl = "https://raw.githubusercontent.com/gustavolunas/LNSCUSTOMV2.0/main/LnsLoader.lua"

local function getCurrentConfigName()
  local panel = modules and modules.game_bot and modules.game_bot.contentsPanel
  local cfg = panel and panel.config
  local opt = cfg and cfg:getCurrentOption()

  if opt and opt.text and opt.text ~= "" then
    return opt.text
  end

  return nil
end

local function showMsg(text)
  if modules and modules.game_textmessage then
    modules.game_textmessage.displayGameMessage(text)
  else
    print(text)
  end
end

local function downloadOldCustom()
  local configName = getCurrentConfigName()

  if not configName then
    showMsg("[LNS] Não consegui identificar o config atual.")
    return
  end

  local dirPath = "/bot/" .. configName
  local filePath = dirPath .. "/LnsLoader.lua"

  if g_resources and g_resources.makeDir then
    pcall(function()
      g_resources.makeDir(dirPath)
    end)
  end

  HTTP.get(rawUrl, function(data, err)
    if err or not data or data == "" then
      showMsg("[LNS] Falha ao baixar LnsLoader.lua.")
      return
    end

    if data:find("404: Not Found", 1, true) then
      showMsg("[LNS] Arquivo não encontrado no GitHub.")
      return
    end

    local ok = pcall(function()
      g_resources.writeFileContents(filePath, data)
    end)

    if ok then
      showMsg("[LNS] OLD_Custom baixado em: " .. filePath)
    else
      showMsg("[LNS] Baixou, mas falhou ao salvar o arquivo.")
    end
  end)
end

UI.Button("Download OLD_Custom", function()
  downloadOldCustom()
end)
