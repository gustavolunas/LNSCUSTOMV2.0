--[[
 ####     ##   ##   #####             #####                       ##                ##
  ##      ###  ##  ##   ##           ##   ##                                        ##
  ##      #### ##  #                 #         ####    ######    ###     ######    #####    #####
  ##      ## ####   #####             #####   ##  ##    ##  ##    ##      ##  ##    ##     ##
  ##   #  ##  ###       ##                ##  ##        ##        ##      ##  ##    ##      #####
  ##  ##  ##   ##  ##   ##           ##   ##  ##  ##    ##        ##      #####     ## ##       ##
 #######  ##   ##   #####             #####    ####    ####      ####     ##         ###   ######
                                                                         ####
]]--

-- LINK DISCORD: https://discord.gg/GeGCzyd5
-- SCRIPT DESENVOLVIDA POR LNS SCRIPTS.


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
local luaFiles = {
  "vlib",
  "new_cavebot_lib",
  "items",
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
  "exeta",
  "cavebot_control_panel",
  "npc_talk",
  "analyzer",
}
for i, file in ipairs(luaFiles) do
  loadScript(file)
end
