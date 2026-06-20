CaveBot.Editor.ExampleFunctions = {}

local function addExampleFunction(title, text)
  return table.insert(CaveBot.Editor.ExampleFunctions, {title, text:trim()})
end

addExampleFunction("Click to browse example functions", [[
-- available functions/variables:
-- prev - result of previous action (true or false)
-- retries - number of retries of current function, goes up by one when you return "retry"
-- delay(number) - delays bot next action, value in milliseconds
-- gotoLabel(string) - goes to specific label, return true if label exists
-- you can easily access bot extensions, Depositer.run() instead of CaveBot.Extensions.Depositer.run()
-- also you can access bot global variables, like CaveBot, TargetBot
-- use storage variable to store date between calls

-- function should return false, true or "retry"
-- if "retry" is returned, function will be executed again in 20 ms (so better call delay before)

return true
]])

addExampleFunction("Check for PZ and wait until dropped", [[
if retries > 25 or not isPzLocked() then
  return true
else
  if isPoisioned() then
      say("exana pox")
  end
  if isPzLocked() then
      delay(8000)
  end
  return "retry"
end
]])



addExampleFunction("Desativar TargetBot", [[
TargetBot.setOff()
return true
]])

addExampleFunction("Ativar TargetBot", [[
TargetBot.setOn()
return true
]])

addExampleFunction("Desativar CaveBot", [[
CaveBot.setOff()
return true
]])

addExampleFunction("Ativar CaveBot", [[
CaveBot.setOn()
return true
]])





addExampleFunction("Fechar Backpacks", [[
  Checker.closeBackpacks()
  return true
]])


addExampleFunction("Capacidade", [[
  Checker.cap()
  return true
]])

addExampleFunction("PZ", [[
  Checker.PZ()
  return true
]])



