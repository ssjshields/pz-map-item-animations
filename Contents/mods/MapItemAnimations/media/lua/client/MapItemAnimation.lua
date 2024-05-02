require "ISUI/ISInventoryPaneContextMenu"
--client\ISUI\ISInventoryPaneContextMenu.lua
local old_ISInventoryPaneContextMenu_onCheckMap = ISInventoryPaneContextMenu.onCheckMap
function ISInventoryPaneContextMenu.onCheckMap(map, player)
    local playerObj = getSpecificPlayer(player)
    if playerObj then
        ISTimedActionQueue.clear(playerObj)
        ISTimedActionQueue.add(ReadAMap:new(playerObj, map))
    end
end


require "TimedActions/ISReadWorldMap"
---@class ISReadWorldMap : ISBaseTimedAction
ReadAMap = ISReadWorldMap:derive("ReadAMap")

function ReadAMap:isValid()
    if getCore():getGameMode() == "Tutorial" then return false end
    return true
end

function ReadAMap:new(character, map)
    local o = ISReadWorldMap.new(self, character)
    o.map = map
    return o
end

function ReadAMap:start()
    self:setAnimVariable("ReadType", "newspaper")
    self:setActionAnim(CharacterActionAnims.Read)
    self:setOverrideHandModelsString(nil, "MapInHand")
end

function ReadAMap:perform()
    old_ISInventoryPaneContextMenu_onCheckMap(self.map, self.character:getPlayerNum())
    ISBaseTimedAction.perform(self)
end