CaveBot.Extensions.TestAction = {}

CaveBot.Extensions.TestAction.setup = function()

  local params = {
    value = "startAutoBuyMarket()\nreturn true",
    title = "LNS Functions",
    description = "Choose an option.",
    multiline = false,

    examples = {
      {"Buy Market", "startAutoBuyMarket()\nreturn true"},

      {"Auto Imbuement", "checkerImbuementsList()\nreturn true"},

      {"Check Ragnar", "checkerTaskRagnar()\nreturn true"},

      {"Check Boss", "checkerAutoBoss()\nreturn true"},

    }
  }

  CaveBot.Editor.registerAction("LNS Func.", function()
    local value = params.value

    UI.EditorWindow(value, params, function(newText)
      local focusedAction = CaveBot.actionList:getFocusedChild()
      local index = CaveBot.actionList:getChildCount()

      if focusedAction then
        index = CaveBot.actionList:getChildIndex(focusedAction)
      end

      local widget = CaveBot.addAction("function", newText)
      CaveBot.actionList:moveChildToIndex(widget, index + 1)
      CaveBot.actionList:focusChild(widget)
      CaveBot.save()
    end)
  end)

end
