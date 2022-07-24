local Grid, gTable = ...

local lastChargeTime = time() - 10000;
local health = UnitHealth("player")
local maxHealth = UnitHealthMax("player")
local healthPercentage = health / maxHealth * 100

local myRage = UnitPower("player", 1)

function are2EnemiesInRange()
    local inRange = 0
    for id = 1, 40 do
       local unitID = "nameplate" .. id
       --https://www.wowhead.com/item=63427
       if UnitCanAttack("player", unitID) and IsItemInRange(63427, unitID) then
          inRange = inRange + 1
          if inRange >= 2 then return true end
       end
    end
 end


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

    if IsSpellInRange(spellName, "target") ~= 1 then  
        return false;
    end   
   -- If we got this far we are good...
    return true
end

local function FuryCombat()
    now=time()

    if now - lastChargeTime > 5000 and CanCastSpell("Charge") then
        CommandKeyToPress.texture:SetColorTexture(colorTwo[1], colorTwo[2], colorTwo[3])  
        message = "Fury Combat: Charge"
    elseif CanCastSpell("Execute") then
        CommandKeyToPress.texture:SetColorTexture(colorEight[1], colorEight[2], colorEight[3])  
        message = "Fury Combat: Execute"
    elseif CanCastSpell("Victory Rush") then
        CommandKeyToPress.texture:SetColorTexture(colorFour[1], colorFour[2], colorFour[3])  
        message = "Fury Combat: Victory Rush"
    elseif CanCastSpell("Raging Blow") then
        CommandKeyToPress.texture:SetColorTexture(colorFive[1], colorFive[2], colorFive[3])  
        message = "Fury Combat: Raging Blow"
    elseif CanCastSpell("Bloodthirst") then
        CommandKeyToPress.texture:SetColorTexture(colorThree[1], colorThree[2], colorThree[3])  
        message = "Fury Combat: Bloodthirst"
    elseif are2EnemiesInRange and CanCastSpell("Whirlwind") then
        CommandKeyToPress.texture:SetColorTexture(colorNine[1], colorNine[2], colorNine[3])  
        message = "Fury Combat: Whirlwind"
    elseif CanCastSpell("Slam") then
        CommandKeyToPress.texture:SetColorTexture(colorOne[1], colorOne[2], colorOne[3])  
        message = "Lowbie Combat: Slam"
    else
        CommandKeyToPress.texture:SetColorTexture(colorZero[1], colorZero[2], colorZero[3])  
        message = ""
    end
end

local function LowbieCombat()
    now=time()

    if now - lastChargeTime > 5000 and CanCastSpell("Charge") then
        CommandKeyToPress.texture:SetColorTexture(colorTwo[1], colorTwo[2], colorTwo[3])  
        message = "Lowbie Combat: Charge"
    elseif CanCastSpell("Execute") then
        CommandKeyToPress.texture:SetColorTexture(colorEight[1], colorEight[2], colorEight[3])  
        message = "Lowbie Combat: Execute"
    elseif CanCastSpell("Victory Rush") then
        CommandKeyToPress.texture:SetColorTexture(colorFour[1], colorFour[2], colorFour[3])  
        message = "Lowbie Combat: Victory Rush"
    elseif are2EnemiesInRange and CanCastSpell("Whirlwind") then
        CommandKeyToPress.texture:SetColorTexture(colorOne[1], colorOne[2], colorOne[3])  
        message = "Lowbie Combat: Whirlwind"
    elseif CanCastSpell("Shield Slam") then
        CommandKeyToPress.texture:SetColorTexture(colorThree[1], colorThree[2], colorThree[3])  
        message = "Lowbie Combat: Shield Slam"
    elseif CanCastSpell("Slam") then
        CommandKeyToPress.texture:SetColorTexture(colorOne[1], colorOne[2], colorOne[3])  
        message = "Lowbie Combat: Slam"
    else
        CommandKeyToPress.texture:SetColorTexture(colorZero[1], colorZero[2], colorZero[3])  
        message = ""
    end
end


function WarriorCombat()
    spellName, spellSubName, spellID = GetSpellBookItemName("Bloodthirst")

    if spellID ~= nil then
        FuryCombat()
        return
    end
    LowbieCombat();
end