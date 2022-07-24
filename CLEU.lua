local Grid, gTable = ...
local playerGUID = UnitGUID("player")
local MSG_CRITICAL_HIT = "Your %s critically hit %s for %d damage!"
cleuFrame = CreateFrame("Frame")
cleuFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
cleuFrame:SetScript("OnEvent", function(self, event)
	self:COMBAT_LOG_EVENT_UNFILTERED(CombatLogGetCurrentEventInfo())
end)

--"Target needs to be in front of you."
--SPELL_FAILED_UNIT_NOT_INFRONT = "Target needs to be in front of you.";

function cleuFrame:COMBAT_LOG_EVENT_UNFILTERED(...)
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, 
        destGUID, destName, destFlags, destRaidFlags = ...
	local spellId, spellName, spellSchool
	local amount, overkill, school, resisted, blocked, absorbed, 
        critical, glancing, crushing, isOffHand

    --[[
	if subevent == "SWING_DAMAGE" then
		amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
	elseif subevent == "SPELL_DAMAGE" then
		spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
	end

	if critical and sourceGUID == playerGUID then
		-- get the link of the spell or the MELEE globalstring
		local action = spellId and GetSpellLink(spellId) or MELEE
		print(MSG_CRITICAL_HIT:format(action, destName, amount))
	end
    ]]

    --local combatLogEvent = select(2, CombatLogGetCurrentEventInfo())
		
    if(subevent == "SPELL_CAST_FAILED") then
        -- The error message should be the last element
        local spellCastFailedTable = CombatLogGetCurrentEventInfo()
        local errorMessage = select(15, CombatLogGetCurrentEventInfo())

        searchString = "Target needs to be in front of you"
        local i, j = string.find(errorMessage, searchString)
        if i ~= nil then
            CommandInteractNeeded.texture:SetColorTexture(colorOne[1], colorOne[2], colorOne[3]) 
        end       
        searchString = "Out of range"
        i, j = string.find(errorMessage, searchString)
        if i ~= nil then
            CommandInteractNeeded.texture:SetColorTexture(colorOne[1], colorOne[2], colorOne[3]) 
        end    

    elseif subevent == "SPELL_CAST_SUCCESS" then
        CommandInteractNeeded.texture:SetColorTexture(colorZero[1], colorZero[2], colorZero[3]) 
    end
end