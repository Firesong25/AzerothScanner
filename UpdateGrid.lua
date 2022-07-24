local Grid, gTable = ...

local sixNumbersTable = {}
function UpdateGrid()
    --UpdateQuestGrid() 
    UpdateLocationSquares()
    UpdateTargetSquares()
    
    --FlagCompletedQuests()

    -- in combat?
    local incombat = UnitAffectingCombat("player")
    if incombat then
        InCombatFrame.texture:SetColorTexture(colorOne[1], colorOne[2], colorOne[3])
    else
        InCombatFrame.texture:SetColorTexture(colorZero[1], colorZero[2], colorZero[3]) 
    end


    -- player information
    sixNumbersTable = NumberToSixTable(UnitLevel("player"))
    digit = sixNumbersTable[4]
    colourTable = NumberToColour(digit)
    LevelFrame1.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = sixNumbersTable[5]
    colourTable = NumberToColour(digit)
    LevelFrame2.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = sixNumbersTable[6]
    colourTable = NumberToColour(digit)
    LevelFrame3.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

end

function UpdateTargetSquares()
    local NpcId = 0
    local guid = 0
    local target = GetUnitName("target")

    if target then
        NpcId = select(6, strsplit("-", UnitGUID("target")))
        local uniqueId = select(7, strsplit("-", UnitGUID("target")))
        guid = getUniqueId(uniqueId)
        incombat = UnitAffectingCombat("player")
        if incombat and not UnitIsFriend("player", "target") then
            CommandKill.texture:SetColorTexture(colorOne[1], colorOne[2], colorOne[3])
            BtnKill:SetText("Stop fighting")
        end
    else
        CommandKill.texture:SetColorTexture(colorZero[1], colorZero[2], colorZero[3])
        BtnKill:SetText("Kill")
    end
    
    sixNumbersTable = NumberToSixTable(NpcId)
    digit = sixNumbersTable[1]
    colourTable = NumberToColour(digit)
    NpcId1.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = sixNumbersTable[2]
    colourTable = NumberToColour(digit)
    NpcId2.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = sixNumbersTable[3]
    colourTable = NumberToColour(digit)
    NpcId3.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = sixNumbersTable[4]
    colourTable = NumberToColour(digit)
    NpcId4.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = sixNumbersTable[5]
    colourTable = NumberToColour(digit)
    NpcId5.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = sixNumbersTable[6]
    colourTable = NumberToColour(digit)
    NpcId6.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    sixNumbersTable = NumberToSixTable(guid)
    digit = sixNumbersTable[3]
    colourTable = NumberToColour(digit)
    Guid1.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = sixNumbersTable[4]
    colourTable = NumberToColour(digit)
    Guid2.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = sixNumbersTable[5]
    colourTable = NumberToColour(digit)
    Guid3.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = sixNumbersTable[6]
    colourTable = NumberToColour(digit)
    Guid4.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
end


function UpdateLocationSquares()


    if C_Map.GetBestMapForUnit("player") ~= nil and
        C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player") ~= nil then
--  game data
    local continent = select(4, UnitPosition("player"))
    local zoneId = C_Map.GetBestMapForUnit("player")    
    local x, y = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY()  
    x = math.floor(x * 10000)
    y = math.floor(y * 10000)
    local facing = GetPlayerFacing()
    if facing ~= nil then
        facing = math.floor(facing * 100)
    end

    -- Apply colours
    fourNumbersTable = NumberToFourTable(continent)

    -- Map colours
    local digit = fourNumbersTable[1]
    local colourTable = NumberToColour(digit)
    Map1.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = fourNumbersTable[2]
    colourTable = NumberToColour(digit)
    Map2.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = fourNumbersTable[3]
    colourTable = NumberToColour(digit)
    Map3.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = fourNumbersTable[4]
    colourTable = NumberToColour(digit)
    Map4.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    -- Zone Colours
    fourNumbersTable = NumberToFourTable(zoneId)
    digit = fourNumbersTable[1]
    local colourTable = NumberToColour(digit)
    Zone1.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = fourNumbersTable[2]
    colourTable = NumberToColour(digit)
    Zone2.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = fourNumbersTable[3]
    colourTable = NumberToColour(digit)
    Zone3.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = fourNumbersTable[4]
    colourTable = NumberToColour(digit)
    Zone4.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    -- X Colours        
   local fourNumbersTable = NumberToFourTable(x)
   digit = fourNumbersTable[1]
   local colourTable = NumberToColour(digit)
   XFrame1.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

   digit = fourNumbersTable[2]
   colourTable = NumberToColour(digit)
   XFrame2.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

   digit = fourNumbersTable[3]
   colourTable = NumberToColour(digit)
   XFrame3.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

   digit = fourNumbersTable[4]
   colourTable = NumberToColour(digit)
   XFrame4.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    -- Y Colours
    fourNumbersTable = NumberToFourTable(y)
    digit = fourNumbersTable[1]
    local colourTable = NumberToColour(digit)
    YFrame1.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = fourNumbersTable[2]
    colourTable = NumberToColour(digit)
    YFrame2.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = fourNumbersTable[3]
    colourTable = NumberToColour(digit)
    YFrame3.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = fourNumbersTable[4]
    colourTable = NumberToColour(digit)
    YFrame4.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

   --Facing Colours
   if facing ~= nil and NumberToFourTable(facing) ~= nil then
    fourNumbersTable = NumberToFourTable(facing)
    digit = fourNumbersTable[1]
    colourTable = NumberToColour(digit)
    Facing1.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = fourNumbersTable[2]
    colourTable = NumberToColour(digit)
    Facing2.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = fourNumbersTable[3]
    colourTable = NumberToColour(digit)
    Facing3.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

    digit = fourNumbersTable[4]
    colourTable = NumberToColour(digit)
    Facing4.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
   end
   if UnitIsDeadOrGhost("player") then
    CommandKeyToPress0.texture:SetColorTexture(colorBackground[1], colorBackground[2], colorBackground[3])  
    CommandKeyToPress1.texture:SetColorTexture(colorBackground[1], colorBackground[2], colorBackground[3])  
   
        local om = C_Map.GetBestMapForUnit("player")
        local corpse = C_DeathInfo.GetCorpseMapPosition(om)
        if corpse then
            local cx, cy = corpse:GetXY()
            cx = cx * 10000
            cy = cy * 10000

            --CorpseX Colours
            fourNumbersTable = NumberToFourTable(cx)
            if fourNumbersTable ~= nil then
                digit = fourNumbersTable[1]
                colourTable = NumberToColour(digit)
                CorpseX1.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

                digit = fourNumbersTable[2]
                colourTable = NumberToColour(digit)
                CorpseX2.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

                digit = fourNumbersTable[3]
                colourTable = NumberToColour(digit)
                CorpseX3.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

                digit = fourNumbersTable[4]
                colourTable = NumberToColour(digit)
                CorpseX4.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])
            end

            --CorpseY Colours
            fourNumbersTable = NumberToFourTable(cy)
            if fourNumbersTable ~= nil then
                digit = fourNumbersTable[1]
                colourTable = NumberToColour(digit)
                CorpseY1.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

                digit = fourNumbersTable[2]
                colourTable = NumberToColour(digit)
                CorpseY2.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

                digit = fourNumbersTable[3]
                colourTable = NumberToColour(digit)
                CorpseY3.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])

                digit = fourNumbersTable[4]
                colourTable = NumberToColour(digit)
                CorpseY4.texture:SetColorTexture(colourTable[1], colourTable[2], colourTable[3])   
            end     
        end   
    end
    end
end




function SellAndRepair(event)
	for bag = 0,4,1 do
		for slot = 1, GetContainerNumSlots(bag), 1 do
			local name = GetContainerItemLink(bag,slot)
			if name and string.find(name,"ff9d9d9d") then
				DEFAULT_CHAT_FRAME:AddMessage("Selling "..name)
				UseContainerItem(bag,slot)
			end
		end
	end

	local repairAllCost, canRepair = GetRepairAllCost()
	if canRepair and repairAllCost > 0 then
		if GetMoney() > repairAllCost then
			RepairAllItems()
			print("Repaired all items for " .. GetCoinTextureString(repairAllCost))
			return
		else
			print("Insufficient funds to repair!")
		end
	end
end

function QuestGreeting()
    print("Quest Greeting event has fired")
	-- Turn in complete quests:
	for i = 1, GetNumActiveQuests() do
		local title, complete = GetActiveTitle(i)
		--self:Debug("Checking active quest:", title)
		if complete and not ignoreQuest[StripText(title)] then
			--self:Debug("Select!")
			SelectActiveQuest(i)
		end
	end
	-- Pick up available quests:
	for i = 1, GetNumAvailableQuests() do
		local title = StripText(GetAvailableTitle(i))
		--self:Debug("Checking available quest:", title)
		if not ignoreQuest[title] and (not IsAvailableQuestTrivial(i) or IsTrackingTrivial()) then
			--self:Debug("Select!")
			SelectAvailableQuest(i)
		end
	end
end

function QuestDetail()
	local giver = UnitName("questnpc")
	local item, _, _, _, minLevel = GetItemInfo(giver or "")
	if not item or not minLevel or minLevel < 2 or (UnitLevel("player") - minLevel < GetQuestGreenRange()) then
		AcceptQuest()
	end
end

function QuestAcceptConfirm(event, giver, quest)
	AcceptQuest()
end

function QuestAccepted(event, id)
	if QuestFrame:IsShown() and QuestGetAutoAccept() then
		print("Quest accepted.")
		ListActiveQuestIds()
		CloseQuest()
	end
end

function QuestProgress()
	CompleteQuest()
end

function QuestItemUpdate()
	if questChoicePending then
		QuestComplete("QUEST_ITEM_UPDATE")
	end
end

function QuestComplete()
	local choices = GetNumQuestChoices()
	if choices <= 1 then
		--self:Debug("Completing quest", StripText(GetTitleText()), choices == 1 and "with only reward" or "with no reward")
		GetQuestReward(1)
	elseif choices > 1 then
		--self:Debug("Quest has multiple rewards, not automating")
		local bestValue, bestIndex = 0
		for i = 1, choices do
			local link = GetQuestItemLink("choice", i)
			if link then
				local _, _, _, _, _, _, _, _, _, _, value = GetItemInfo(link)
				value = questRewardValues[tonumber(strmatch(link, "item:(%d+)"))] or value or 0
				if value > bestValue then
					bestValue, bestIndex = value, i
				end
			else
				questChoicePending = true
				return GetQuestItemInfo("choice", i)
			end
		end
		if bestIndex then
			questChoiceFinished = true
		end
	end
end

function QuestFinished()
	if questChoiceFinished then
		questChoicePending = false
	end
end



function NumberToSixTable(number)
    local numberTable = {0,0,0,0,0,0}

    if number == nil then
        return numberTable
    end

    local str = tostring(number)
    for i=1, string.len(str) do
        numberTable[i]= (string.sub(str,i,i))
    end
    if #str == 1 then
        table.insert(numberTable, 1, 0)
        table.insert(numberTable, 1, 0)
        table.insert(numberTable, 1, 0)
        table.insert(numberTable, 1, 0)
        table.insert(numberTable, 1, 0)
    end
    
    if #str == 2 then
        table.insert(numberTable, 1, 0)
        table.insert(numberTable, 1, 0)
        table.insert(numberTable, 1, 0)
        table.insert(numberTable, 1, 0)
    end
    
    if #str == 3 then
        table.insert(numberTable, 1, 0)
        table.insert(numberTable, 1, 0)
        table.insert(numberTable, 1, 0)
    end

    if #str == 4 then
        table.insert(numberTable, 1, 0)
        table.insert(numberTable, 1, 0)
    end

    if #str == 5 then
        table.insert(numberTable, 1, 0)
    end
        
    return numberTable
end

function NumberToFourTable(number)
    local numberTable = {0,0,0,0}
    local str = tostring(number)
    for i=1, string.len(str) do
        numberTable[i]= (string.sub(str,i,i))
    end
    if #str == 1 then
        table.insert(numberTable, 1, 0)
        table.insert(numberTable, 1, 0)
        table.insert(numberTable, 1, 0)
    end
    
    if #str == 2 then
        table.insert(numberTable, 1, 0)
        table.insert(numberTable, 1, 0)
    end
    
    if #str == 3 then
        table.insert(numberTable, 1, 0)
    end
        
    return numberTable
end

function NumberToColour(i)
    local number = tonumber(i)
    if number == 0 then
        return colorZero
    end
    if number == 1 then
        return colorOne
    end
    if number == 2 then
        return colorTwo
    end
    if number == 3 then
        return colorThree
    end
    if number == 4 then
        return colorFour
    end
    if number == 5 then
        return colorFive
    end
    if number == 6 then
        return colorSix
    end
    if number == 7 then
        return colorSeven
    end
    if number == 8 then
        return colorEight
    end
    if number == 9 then
        return colorNine
    end
end

function getUniqueId(txt)
    if txt == nil then
        return 0
    end
    local str = ""
    string.gsub(txt,"%d+",function(e) str = str .. e end)
    number = tonumber(string.sub(str, -6), 16)
    return number
end