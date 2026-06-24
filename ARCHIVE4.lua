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
  local rawUrl = "https://raw.githubusercontent.com/gustavolunas/LNSCUSTOMV2.0/main/LnsLoader.lua"

  local function msg(text)
    if modules and modules.game_textmessage then
      modules.game_textmessage.displayGameMessage(text)
    else
      print(text)
    end
  end

  local function getConfigName()
    local panel = modules.game_bot and modules.game_bot.contentsPanel
    local cfg = panel and panel.config
    local opt = cfg and cfg:getCurrentOption()

    if opt and opt.text and opt.text ~= "" then
      return opt.text
    end

    return nil
  end

  local function downloadOldCustom()
    local configName = getConfigName()

    if not configName then
      msg("[LNS] Config atual nao encontrado.")
      return
    end

    local folder = "/bot/" .. configName
    local filePath = folder .. "/LnsLoader.lua"

    pcall(function()
      g_resources.makeDir(folder)
    end)

    HTTP.get(rawUrl, function(data, err)
      if err then
        msg("[LNS] Erro HTTP: " .. tostring(err))
        return
      end

      if not data or data == "" then
        msg("[LNS] Download vazio.")
        return
      end

      if data:find("404", 1, true) and data:find("Not Found", 1, true) then
        msg("[LNS] 404 no LnsLoader.lua.")
        return
      end

      local ok, saveErr = pcall(function()
        g_resources.writeFileContents(filePath, data)
      end)

      if not ok then
        msg("[LNS] Falhou ao salvar: " .. tostring(saveErr))
        return
      end

      msg("[LNS] LnsLoader.lua baixado com sucesso.")
      refresh()
    end)
  end

  UI.Button("Download OLD_Custom", function()
    downloadOldCustom()
  end)
end
