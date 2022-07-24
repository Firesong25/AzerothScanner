local Grid, gTable = ...

local keyToPress = '-'
local health = UnitHealth("player")
local maxHealth = UnitHealthMax("player")
local healthPercentage = health / maxHealth * 100

local mana = UnitPower("player", Enum.PowerType.Mana)
local maxMana = UnitPowerMax("player", Enum.PowerType.Mana)
local manaPercentage = mana / maxMana * 100

local myHolyPower = UnitPower("player", 9)

local function CanCastSpell(spellName)
    if not UnitExists("target") or not UnitIsVisible("target") then
        --print("No target.")
        return false
    end

    local cast = UnitCastingInfo('player')
    local chan = UnitChannelInfo('player')
    if cast or chan then
        --print("Casting.")
		return false
	end

    local start, duration, enabled, modRate = GetSpellCooldown(spellName)    

    if ( start ~= nil and duration ~= nil and start > 0 and duration > 0) then
        return false
    end

    local inRange, unit = 0, "target"
    usable, nomana = IsUsableSpell(spellName)

    if not usable then
        --print("Not usable.")
        return false
    end
    
   -- If we got this far we are good...
    return true
end



function PriestCombat()
    local target = GetUnitName("target")
    local swp
    if target then
        swp = AuraUtil.FindAuraByName("Shadow Word: Pain", "target", "HARMFUL")
    end

    log(swp)

    if swp == nil and CanCastSpell("Shadow Word: Pain") then
        CommandKeyToPress.texture:SetColorTexture(colorTwo[1], colorTwo[2], colorTwo[3])  
        message = "Lowbie Combat: Shadow Word: Pain"
    elseif CanCastSpell("Smite") then
        CommandKeyToPress.texture:SetColorTexture(colorEight[1], colorEight[2], colorEight[3])  
        message = "Lowbie Combat: Smite"
    end
end