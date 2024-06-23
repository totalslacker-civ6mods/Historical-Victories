------------------------------------------------------------------------------
--	FILE:	 InGameHSD.lua
--  Gedemon (2017)
--	totalslacker (2020-2021)
------------------------------------------------------------------------------

include("ScriptHSD.lua")

print ("loading InGameHSD.lua")

----------------------------------------------------------------------------------------
-- User Interface and Gameplay Menu Settings
----------------------------------------------------------------------------------------

--Share context via ExposedMembers for UI and Gameplay scripts to communicate
LuaEvents = ExposedMembers.LuaEvents

local defaultQuickMovement 	= UserConfiguration.GetValue("QuickMovement")
local defaultQuickCombat 	= UserConfiguration.GetValue("QuickCombat")
local defaultAutoEndTurn	= UserConfiguration.GetValue("AutoEndTurn")

----------------------------------------------------------------------------------------
-- Timeline Functions
----------------------------------------------------------------------------------------

function GetStandardTimeline(civType)
	local iStartYear = false
	-- local results = DB.ConfigurationQuery("SELECT * FROM HistoricalSpawnDates")
	local results = DB.Query("SELECT * FROM HistoricalSpawnDates")
	for i, row in ipairs(results) do
		if row.Civilization == civType then
			iStartYear = row.StartYear
			print(tostring(row.Civilization), " spawn year = ", tostring(row.StartYear))
		end
	end
	return iStartYear
end

function GetTrueHSDTimeline(civType)
	local iStartYear = false
	-- local results = DB.ConfigurationQuery("SELECT * FROM HistoricalSpawnDates_TrueHSD")
	local results = DB.Query("SELECT * FROM HistoricalSpawnDates_TrueHSD")
	for i, row in ipairs(results) do
		if row.Civilization == civType then
			iStartYear = row.StartYear
			print(tostring(row.Civilization), " spawn year = ", tostring(row.StartYear))
		end
	end
	return iStartYear
end

function GetLeaderTimeline(civType)
	local iStartYear = false
	-- local results = DB.ConfigurationQuery("SELECT * FROM HistoricalSpawnDates_LeaderHSD")
	local results = DB.Query("SELECT * FROM HistoricalSpawnDates_LeaderHSD")
	for i, row in ipairs(results) do
		if row.Civilization == civType then
			iStartYear = row.StartYear
			print(tostring(row.Civilization), " spawn year = ", tostring(row.StartYear))
		end
	end
	return iStartYear
end

function GetEraTimeline(civType)
	local iStartEra = false
	-- local results = DB.ConfigurationQuery("SELECT * FROM HistoricalSpawnEras")
	local results = DB.Query("SELECT * FROM HistoricalSpawnEras")
	for i, row in ipairs(results) do
		if row.Civilization == civType then
			iStartEra = row.Era
			print(tostring(row.Civilization), " spawn era = ", tostring(row.Era))
		end
	end
	return iStartEra
end

function GetLitemodeCivs(civType)
	-- local iStartYear = false
	-- local iStartEra = false
	local eligibleForHSD = false
	local isolated = DB.Query("SELECT * FROM IsolatedCivs")
	local colonial = DB.Query("SELECT * FROM ColonialCivs")
	for i, row in ipairs(isolated) do
		if ((row.Civilization == civType) or ((GameInfo.CivilizationLeaders[civType]) and (row.Civilization == GameInfo.CivilizationLeaders[civType].CivilizationType))) then
			eligibleForHSD = true
			print(tostring(row.Civilization), " is an isolated player.")
		end
	end
	for i, row in ipairs(colonial) do
		if ((row.Civilization == civType) or ((GameInfo.CivilizationLeaders[civType]) and (row.Civilization == GameInfo.CivilizationLeaders[civType].CivilizationType))) then
			eligibleForHSD = true
			print(tostring(row.Civilization), " is a colonial player.")
		end
	end
	return eligibleForHSD
end

----------------------------------------------------------------------------------------
-- Calendar Functions
----------------------------------------------------------------------------------------

function GetCalendarTurnYear(iTurn)
	local turnYearStr = Calendar.MakeYearStr(iTurn)
	local isBC = string.find(turnYearStr, "BC") -- Check if the year is BC
	local gSubString = string.gsub(turnYearStr, "%D", "") -- Remove all non-digit characters to get the year number
	local turnYearInt = tonumber(gSubString)

	if isBC then
		turnYearInt = -turnYearInt -- Make the year negative if it's BC
	end

	-- print("GetCalendarTurnYear returned "..tostring(turnYearStr))
	-- print("New value is "..tostring(turnYearInt))
	return turnYearInt
end

function SetTurnYear(iTurn)
	previousTurnYear 	= Calendar.GetTurnYearForGame( iTurn )
	currentTurnYear 	= Calendar.GetTurnYearForGame( iTurn + 1 )
	nextTurnYear 		= Calendar.GetTurnYearForGame( iTurn + 2 )
	GameConfiguration.SetValue("PreviousTurnYear", previousTurnYear)
	GameConfiguration.SetValue("CurrentTurnYear", currentTurnYear)
	GameConfiguration.SetValue("NextTurnYear", nextTurnYear)
	LuaEvents.SetPreviousTurnYear(previousTurnYear)
	LuaEvents.SetCurrentTurnYear(currentTurnYear)
	LuaEvents.SetNextTurnYear(nextTurnYear)
end

function SetAutoValues()
	--UserConfiguration.SetValue("QuickMovement", 1)
	--UserConfiguration.SetValue("QuickCombat", 1)
	UserConfiguration.SetValue("AutoEndTurn", 1)
end

function RestoreAutoValues()
	--UserConfiguration.SetValue("QuickMovement", defaultQuickMovement)
	--UserConfiguration.SetValue("QuickCombat", 	defaultQuickCombat 	)
	UserConfiguration.SetValue("AutoEndTurn", 	defaultAutoEndTurn	)
end

function SetStartingEra(iPlayer, era)
	local key = "StartingEra"..tostring(iPlayer)
	print ("saving key = "..key..", value = ".. tostring(era))
	GameConfiguration.SetValue(key, era)
end

----------------------------------------------------------------------------------------
-- Support Functions for City Conversion and Revolts
----------------------------------------------------------------------------------------

function CheckCityGovernor(pPlayerID, pCityID)
	local pPlayer = Players[pPlayerID]
	local pCity = pPlayer:GetCities():FindID(pCityID)
	local pGovernor = pCity:GetAssignedGovernor()
	local bCapital = CheckCityCapital(pPlayerID, pCityID)
	if pCity and (pGovernor == nil or not pGovernor:IsEstablished()) and not bCapital then
		print ("CheckCityGovernor returning city ID")
		local pFreeCityID = pCity:GetID()
		if pFreeCityID then
			return pFreeCityID
		else
			print("CheckCityGovernor could not return a city ID")
			return false
		end
	else
		print ("City was an original capital or had an established governor.")
		return false
	end
end

function CheckCityCapital(pPlayerID, pCityID)
	local bCapital = false
	local pPlayer = Players[pPlayerID]
	local pCity = pPlayer:GetCities():FindID(pCityID)
	if pPlayer and pCity then
		if pCity:IsOriginalCapital() and (pCity:GetOriginalOwner() == pCity:GetOwner()) then
			if pCity:IsCapital() then
				-- Original capital still owned by original owner
				-- print("Found original capital")
				bCapital = true
			else
				-- print("Found occupied capital")
				bCapital = false
			end
		elseif pCity:IsOriginalCapital() and (pCity:GetOriginalOwner() ~= pCity:GetOwner()) then
			-- print("Found occupied capital")
			bCapital = false
		elseif pCity:IsCapital() then
			-- New capital
			-- print("Found new capital")
			bCapital = false
		else
			-- Other cities
			-- print("Found non-capital city")
			bCapital = false
		end
	end
	return bCapital
end

function CheckCityOriginalCapital(iPlayer, cityID)
	local pPlayer = Players[iPlayer]
	local pCity = CityManager.GetCity(iPlayer, cityID)
	local bOriginalCapital = false
	-- if pCity:IsOriginalCapital() then
		-- print("IsOriginalCapital is "..tostring(pCity:IsOriginalCapital()))
		-- bOriginalCapital = true
	-- end
	if pPlayer:IsMajor() and pCity then
		if pCity:IsOriginalCapital() and pCity:GetOriginalOwner() == pCity:GetOwner() then
			if pCity:IsCapital() then
				-- Original capital still owned by original owner
				print("Found original capital")
				return false
			else
				local pOriginalOwner = pCity:GetOriginalOwner()
				print("Found occupied capital")
				return pOriginalOwner
			end
		elseif pCity:IsOriginalCapital() and pCity:GetOriginalOwner() ~= pCity:GetOwner() then
			local pOriginalOwner = pCity:GetOriginalOwner()
			print("Found occupied capital")
			return pOriginalOwner
		elseif pCity:IsCapital() then
			-- New capital
			print("Found new capital")
			return false
		else
			-- Other cities
			print("Found non-capital city")
			return false
		end
	end
	return bOriginalCapital
end

----------------------------------------------------------------------------------------
-- Get city data from UI context, such as plots owned, to pass to in-game context
----------------------------------------------------------------------------------------

-- all credit for the code below goes to Tiramasu, taken from the Free City States mod
function GetPlayerCityUIDatas(pPlayerID, pCityID)
	local CityUIDataList = {}
	local pPlayer = Players[pPlayerID]
	local pCity = pPlayer:GetCities():FindID(pCityID)
	if pCity then
		local kCityUIDatas :table = {
			iPosX = nil,
			iPosY = nil,
			iCityID = nil,
			sCityName = "",
			CityPlotCoordinates = {},
			CityDistricts = {},
			CityBuildings = {},
			CityReligions = {},
			-- CityPlotImprovements = {},
		}
		--General City Datas:
		kCityUIDatas.iPosX = pCity:GetX()
		kCityUIDatas.iPosY = pCity:GetY()
		kCityUIDatas.iCityID = pCity:GetID()
		kCityUIDatas.sCityName = pCity:GetName()
		--City Tiles Datas:
		local kCityPlots :table = Map.GetCityPlots():GetPurchasedPlots( pCity )
		for _,plotID in pairs(kCityPlots) do
			local pPlot:table = Map.GetPlotByIndex(plotID)
			local kCoordinates:table = {
				iX = pPlot:GetX(),
				iY = pPlot:GetY(),
				plotID = pPlot:GetIndex(),
				plotImprovementIndex = pPlot:GetImprovementType()
			}
			table.insert(kCityUIDatas.CityPlotCoordinates, kCoordinates)
			-- local kImprovement:table = {
				-- plotID = plotID,
				-- plotImprovement = pPlot:GetImprovementType()
			-- }
			-- table.insert(kCityUIDatas.CityPlotImprovements, kImprovement)
		end
		--City District Datas:
		local pCityDistricts :table	= pCity:GetDistricts()
		for _, pDistrict in pCityDistricts:Members() do
			table.insert(kCityUIDatas.CityDistricts, {
				iPosX = pDistrict:GetX(),
				iPosY = pDistrict:GetY(),
				iType = pDistrict:GetType(),
				bPillaged = pCityDistricts:IsPillaged(pDistrict:GetType()),
			})
		end
		--City Buildings Datas: (actually these Datas can also be accessed in gameplay context)
		local pCityBuildings = pCity:GetBuildings()
		for pBuilding in GameInfo.Buildings() do
			if( pCityBuildings:HasBuilding(pBuilding.Index) ) then
				table.insert(kCityUIDatas.CityBuildings, {
					iBuildingID = pBuilding.Index,
					bIsPillaged = pCityBuildings:IsPillaged(pBuilding.Index),
				})
			end
		end
		--Religious Pressure Data:
		local pReligions :table = pCity:GetReligion():GetReligionsInCity()
		for _, religionData in pairs(pReligions) do
			table.insert(kCityUIDatas.CityReligions, {
				iReligionType = religionData.Religion,
				iPressure = religionData.Pressure,
			})
		end
		--Save all City Datas:
		table.insert(CityUIDataList, kCityUIDatas)
	end
	return CityUIDataList
end

----------------------------------------------------------------------------------------
-- Support functions for Raging Barbarians mode
----------------------------------------------------------------------------------------

function GetEraCountdown()
	local pGameEras:table = Game.GetEras()
	local nextEraCountdown = pGameEras:GetNextEraCountdown() + 1; -- 0 turns remaining is the last turn, shift by 1 to make sense to non-programmers
	-- print("nextEraCountdown is "..tostring(nextEraCountdown))
	return nextEraCountdown
end

function GetTribeNameType(iBarbarianTribe)
	local pBarbManager = Game.GetBarbarianManager()
	local iBarbType = pBarbManager:GetTribeNameType(iBarbarianTribe)
	print("GetTribeNameType returned iBarbType of "..tostring(iBarbType))
	return iBarbType
end

----------------------------------------------------------------------------------------
-- Support functions for Historical Victory Mode
----------------------------------------------------------------------------------------

function HSD_GetTerritoryCache()
	local territoryCache = {}

	local nPlots = Map.GetPlotCount();
	for iPlot = 0,nPlots-1 do
		local pTerritory = Territories.GetTerritoryAt(iPlot);
		if pTerritory then
			local eTerritory = pTerritory:GetID();
			if territoryCache[eTerritory] then
				-- Add a new plot
				table.insert(territoryCache[eTerritory].pPlots, iPlot);
			else
				-- Instantiate a new territory
				territoryCache[eTerritory] = { pPlots = { iPlot } };
			end
		end
	end

	return territoryCache
end

function HSD_GetTerritoryID(plotID)
	local iTerritory = false
	local territoryObject = Territories.GetTerritoryAt(plotID)
	if territoryObject then
		iTerritory = territoryObject:GetID()
	end
	return iTerritory
end

function HSD_GetTotalIncomingRoutes(playerID)
    local totalIncomingRoutes = 0
    local player = Players[playerID]

    if player then
        local playerCities = player:GetCities()
        for _, city in playerCities:Members() do
            local incomingRoutes = city:GetTrade():GetIncomingRoutes()
            for _, route in ipairs(incomingRoutes) do
                if route.OriginCityPlayer ~= playerID then -- Check if route is from a foreign city
                    totalIncomingRoutes = totalIncomingRoutes + 1
                end
            end
        end
    end

    return totalIncomingRoutes
end

function HSD_GetRiverPlots(plot, plotIndex)
    print("HSD_GetRiverPlots initiated")
    local riverPlotIndexes = {}
	local riverTypeID = -1 -- River IDs are positive. Negative number represents no river detected.

    if plot:IsRiver() then
        print("River detected on plot")
        local pRivers = RiverManager.EnumerateRivers(plotIndex)
        if pRivers then
            for _, pRiver in pairs(pRivers) do
				if pRiver.TypeID then
					riverTypeID = pRiver.TypeID
				end
                if pRiver.Edges then
                    for _, edgeTable in ipairs(pRiver.Edges) do
                        -- Assuming each edgeTable contains two plot indexes
                        for _, edgePlotIndex in ipairs(edgeTable) do
                            -- Add the plot index to the table if it's not already there
                            if not riverPlotIndexes[edgePlotIndex] then
                                riverPlotIndexes[edgePlotIndex] = true
                                print("Added plot index:", edgePlotIndex)
                            end
                        end
                    end
                end
            end
        end
    else
        print("River not detected on plot")
    end

    -- Convert the keys of riverPlotIndexes to an array
    local riverPlotsArray = {}
    for riverPlotIndex, _ in pairs(riverPlotIndexes) do
        table.insert(riverPlotsArray, riverPlotIndex)
    end
    
    return riverTypeID, riverPlotsArray
end

function HSD_GetCultureCounts(playerID)
	-- Get player culture count
	local player = Players[playerID]
	local playerCultureCount = player:GetCulture():GetCultureYield()
	print("playerCultureCount is "..tostring(playerCultureCount))

	-- Get highest culture count of all other players
	local highestCultureCount = 0
	local allPlayerIDs = PlayerManager.GetAliveIDs()
	for _, otherPlayerID in ipairs(allPlayerIDs) do
		if otherPlayerID ~= playerID then
			local otherPlayer = Players[otherPlayerID]
			local otherCultureCount = otherPlayer:GetCulture():GetCultureYield()
			if otherCultureCount > highestCultureCount then
				highestCultureCount = otherCultureCount
			end
		end
	end
	print("highestCultureCount is "..tostring(highestCultureCount))

	return playerCultureCount, highestCultureCount
end

function HSD_GetNumTechsResearched(playerID)
	print("Calling HSD_GetNumTechsResearched...")
    local player = Players[playerID]
    if not player then
        print("Player not found for playerID:", playerID)
        return 0, 0
    end

    local playerStats = player:GetStats()
    local playerTechCount = playerStats:GetNumTechsResearched()
    local highestTechCount = 0

    for _, otherPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		if otherPlayerID ~= playerID then
			local otherPlayer = Players[otherPlayerID]
			local otherPlayerStats = otherPlayer:GetStats()
			local otherPlayerTechCount = otherPlayerStats:GetNumTechsResearched()
	
			highestTechCount = math.max(highestTechCount, otherPlayerTechCount)
		end
    end
	print("playerTechCount is "..tostring(playerTechCount)..", highestTechCount is "..tostring(highestTechCount))
    return playerTechCount, highestTechCount
end

function HSD_GetHolyCitiesCount(playerID)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local holyCityCount = 0
    local holyCityIDs = {}

    -- Gather IDs of all holy cities
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
        local otherPlayer = Players[otherPlayerID]
        local otherPlayerReligion = otherPlayer:GetReligion()
        local holyCityID = otherPlayerReligion:GetHolyCityID()
		-- print("holyCityID is "..tostring(holyCityID))
		local holyCity = CityManager.GetCity(holyCityID)
        if holyCity then
			local cityID = holyCity:GetID()
            holyCityIDs[cityID] = true
        end
    end

    -- Check if any of the player's cities are in the holy city IDs table
    for _, city in playerCities:Members() do
        local cityID = city:GetID()
		-- print("cityID is "..tostring(cityID))
        if holyCityIDs[cityID] then
            holyCityCount = holyCityCount + 1
        end
    end

    return holyCityCount
end

function HSD_GetCitiesWithGovernors(playerID)
    local player = Players[playerID]
    local totalCities = 0
    local citiesWithGovernors = 0

    -- Iterate through the player's cities
    for _, city in player:GetCities():Members() do
        totalCities = totalCities + 1
        local governor = city:GetAssignedGovernor()
        -- print("Governor assigned: "..tostring(governor))
        -- Check if the city has an assigned governor
        if governor then
            citiesWithGovernors = citiesWithGovernors + 1
        end
    end

    return citiesWithGovernors, totalCities
end

function HSD_GetUnitPromotionLevel(playerID, unitType, promotionLevel)
    local player = Players[playerID]
    local playerUnits = player:GetUnits()
    local count = 0

    for i, unit in playerUnits:Members() do
		local playerUnitType = GameInfo.Units[unit:GetUnitType()].UnitType
        -- print("Unit type is "..tostring(playerUnitType))
        if playerUnitType == unitType then
            local unitLevel = unit:GetExperience():GetLevel()
            -- print("Unit is level "..tostring(unitLevel))
            if unitLevel >= promotionLevel then
                count = count + 1
            end
        end
    end

    return count
end

function HSD_GetUnitClassLevel(playerID, promotionClass, promotionLevel)
    local player = Players[playerID]
    local playerUnits = player:GetUnits()
    local count = 0

    for i, unit in playerUnits:Members() do
        local unitType = unit:GetType()
        local unitPromotionClass = GameInfo.Units[unitType].PromotionClass
        if unitPromotionClass == promotionClass then
            local unitLevel = unit:GetExperience():GetLevel()
            print("Unit is level "..tostring(unitLevel))
            if unitLevel >= promotionLevel then
                count = count + 1
            end
        end
    end

    return count
end

function HSD_GetTourismCounts(playerID)
    -- Initialize variables to hold tourism counts
    local playerTourism = 0
    local highestOtherPlayerTourism = 0

    -- Get the player's tourism
    local player = Players[playerID]
    if player then
        local playerStats = player:GetStats()
        playerTourism = playerStats:GetTourism()
    end

    -- Iterate through all other players to find the highest tourism
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveIDs()) do
        if otherPlayerID ~= playerID then
            local otherPlayer = Players[otherPlayerID]
            local otherPlayerStats = otherPlayer:GetStats()
            local otherTourism = otherPlayerStats:GetTourism()

            if otherTourism > highestOtherPlayerTourism then
                highestOtherPlayerTourism = otherTourism
            end
        end
    end

    return playerTourism, highestOtherPlayerTourism
end

function HSD_GetPlotYield(plotID, yieldIndex)
	local plot = Map.GetPlotByIndex(plotID)
	local plotYield = plot:GetYield(yieldIndex)
	----------------------------------------------------------------------------------
	-- totalslacker: Just a test to prove that the plot yields are different in the UI
	----------------------------------------------------------------------------------
	-- for row in GameInfo.Yields() do
	-- 	plotYield = plot:GetYield(row.Index)
	-- 	print("Yield: ".. tostring(row.YieldType).. " = ".. tostring(plotYield))
	-- end
	-- print("plotYield is "..tostring(plotYield))
	return plotYield
end

-- Do not call this function from the gameplay script. The city objects are different when called in the UI. GetTrade() will fail, along with trading post checks.
local function HSD_GetTradingPost(city, playerID)
    -- Check if city is valid
    if not city then
        print("Invalid city object.")
        return false
    end

    -- Access the city's trade object safely
    local cityTrade = city:GetTrade()
    if not cityTrade then
        print("City does not have a trade object.")
        return false
    end

    -- Check for trading posts
    local hasActiveTradingPost = cityTrade.HasActiveTradingPost and cityTrade:HasActiveTradingPost(playerID)
    local hasInactiveTradingPost = cityTrade.HasInactiveTradingPost and cityTrade:HasInactiveTradingPost(playerID)

    return hasActiveTradingPost or hasInactiveTradingPost
end

function HSD_GetCitiesWithTradingPosts(playerID)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local citiesWithTradingPosts = 0
    local totalCities = 0

    for _, city in playerCities:Members() do
        local cityID = city:GetID()
		totalCities = totalCities + 1
        local hasTradingPost = HSD_GetTradingPost(city, playerID)
        if hasTradingPost then
            citiesWithTradingPosts = citiesWithTradingPosts + 1
        end
    end

    return citiesWithTradingPosts, totalCities
end

function HSD_TradePostEveryPlayerOnContinent(playerID)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local playerContinent = nil
    local playersOnContinent = {}
    local continentPlayersWithTradingPost = 0
    
    -- Determine the player's home continent by checking their capital city's continent
    local capitalCity = playerCities:GetCapitalCity()
    if capitalCity then
		local capitalX, capitalY = capitalCity:GetX(), capitalCity:GetY()
		local capitalPlot = Map.GetPlot(capitalX, capitalY)
        playerContinent = capitalPlot:GetContinentType()
		print("Player's Continent is ".. tostring(playerContinent))
    end
    
    -- If the player's capital city's continent is not found, return counts as zero
    if not playerContinent then
        print("No home continent found for the player.")
        return 0, 0
    end
    
    -- Track all players with cities on the player's home continent
    for _, otherPlayerID in ipairs(PlayerManager.GetAliveIDs()) do
        local otherPlayer = Players[otherPlayerID]
        if (otherPlayerID ~= playerID) and (otherPlayerID ~= 62) and (not otherPlayer:IsBarbarian()) then
            local otherPlayerCities = Players[otherPlayerID]:GetCities()
            for _, city in otherPlayerCities:Members() do
				local cityPlot = Map.GetPlot(city:GetX(), city:GetY())
                if cityPlot:GetContinentType() == playerContinent then
                    if not playersOnContinent[otherPlayerID] then
                        playersOnContinent[otherPlayerID] = true
						print("Player #" .. tostring(otherPlayerID).. " is on the same continent as ".. tostring(playerID))
                    end
                    local hasTradingPost = HSD_GetTradingPost(city, playerID)
                    if hasTradingPost then
                        continentPlayersWithTradingPost = continentPlayersWithTradingPost + 1
                        break -- Found a trading post in this city, no need to check more of their cities
                    end
                end
            end
        end
    end

    local totalPlayersOnContinent = 0
    for _ in pairs(playersOnContinent) do
        totalPlayersOnContinent = totalPlayersOnContinent + 1
    end
    
    return continentPlayersWithTradingPost, totalPlayersOnContinent
end

local function HSD_GetGreatWorksCount(playerID)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    -- local greatWorks = {}
    local greatWorkCount = 0

    -- Iterate through each city
    for _, city in playerCities:Members() do
        local cityBuildings = city:GetBuildings()

        -- Check each building in the city for great works
        for building in GameInfo.Buildings() do
            local buildingIndex = building.Index
            if cityBuildings:HasBuilding(buildingIndex) then
                -- Get the number of great works in this building
                local numSlots = cityBuildings:GetNumGreatWorkSlots(buildingIndex)
                for index = 0, numSlots - 1 do
                    local greatWorkIndex = cityBuildings:GetGreatWorkInSlot(buildingIndex, index)
                    if greatWorkIndex ~= -1 then
                        -- table.insert(greatWorks, {Index=greatWorkIndex, Building=buildingIndex, City=city});
                        greatWorkCount = greatWorkCount + 1
                    end
                end
            end
        end
    end

    return greatWorkCount
end

local function HSD_GetGreatWorkTypeCount(playerID, greatWorkType)
    local player = Players[playerID]
    local playerCities = player:GetCities()
    local greatWorkCount = 0

    -- Iterate through each city
    for _, city in playerCities:Members() do
        local cityBuildings = city:GetBuildings()

        -- Check each building in the city for great works
        for building in GameInfo.Buildings() do
            local buildingIndex = building.Index
            if cityBuildings:HasBuilding(buildingIndex) then
                -- Get the number of great work slots in this building
                local numSlots = cityBuildings:GetNumGreatWorkSlots(buildingIndex)
                for slotIndex = 0, numSlots - 1 do
                    local greatWorkIndex = cityBuildings:GetGreatWorkInSlot(buildingIndex, slotIndex)
                    if greatWorkIndex ~= -1 then
                        local greatWork = GameInfo.GreatWorks[greatWorkIndex]
						local greatWorkTypeName = cityBuildings:GetGreatWorkTypeFromIndex(greatWorkIndex)
						print("Great work object type is "..tostring(greatWorkTypeName))
                        if greatWork and (greatWork.GreatWorkObjectType == greatWorkType) then
                            greatWorkCount = greatWorkCount + 1
							print("Great work count is "..tostring(greatWorkCount).." for "..tostring(greatWorkType))
                        end
                    end
                end
            end
        end
    end

    return greatWorkCount
end

local function HSD_GetNumBeliefs(playerID)
    local player = Players[playerID]
    local religion = player:GetReligion()
    local numBeliefs = religion:GetNumBeliefsEarned()
    return numBeliefs
end

local function HSD_GetGoldenAge(playerID)
    local gameEras = Game.GetEras()
    local goldenAgeProgress = gameEras:HasGoldenAge(playerID) or gameEras:HasHeroicGoldenAge(playerID)
    return goldenAgeProgress
end

local function HSD_OnGameHistoryMoment(momentIndex, MomentHash)
    print("MomentID = " .. tostring(momentIndex) .. ", MomentHash = " .. tostring(MomentHash))
    local interestLevel = GameInfo.Moments[MomentHash].InterestLevel
    local momentType = GameInfo.Moments[MomentHash].MomentType
    print("momentType = " .. tostring(momentType))
	local momentTypeKey = "HSD_"..tostring(momentType)
    local momentData = Game.GetHistoryManager():GetMomentData(momentIndex)
    print("momentData.Type = " .. tostring(momentData.Type) .. ", momentData.Turn = " .. tostring(momentData.Turn) .. ", momentData.GameEra = " .. tostring(momentData.GameEra))
    -- local momentDate = Calendar.MakeYearStr(momentData.Turn)
    -- print("momentDate = " .. tostring(momentDate))
    -- local firstMoment = momentData.HasEverBeenCommemorated
    -- print("firstMoment = " .. tostring(firstMoment))
	local momentPlayerID = momentData.ActingPlayer

	-- Record every moment
	if not Game:GetProperty(momentTypeKey) then
		GameConfiguration.SetValue(momentTypeKey, momentPlayerID)
		-- Game:SetProperty(momentTypeKey, momentPlayerID)
		print("Set property " .. momentTypeKey .. " for player " .. tostring(momentPlayerID))
	end

    -- Print all properties of the momentData table
    -- for key, value in pairs(momentData) do
    --     print(key .. " = " .. tostring(value))
    -- end

    -- local momentsTable = {
    --     ["HSD_MOMENT_FORMATION_ARMADA_FIRST_IN_WORLD"] = "MOMENT_FORMATION_ARMADA_FIRST_IN_WORLD",
    --     ["HSD_MOMENT_UNIT_CREATED_FIRST_DOMAIN_AIR_IN_WORLD"] = "MOMENT_UNIT_CREATED_FIRST_DOMAIN_AIR_IN_WORLD",
    --     ["HSD_MOMENT_WORLD_CIRCUMNAVIGATED_FIRST_IN_WORLD"] = "MOMENT_WORLD_CIRCUMNAVIGATED_FIRST_IN_WORLD",
    -- }

	-- Check the moment player against the moments table directly
	-- local momentSummary = Game.GetHistoryManager():GetAllMomentsData(momentPlayerID, interestLevel)
	-- for _, moment in ipairs(momentSummary) do
	-- 	local currentMomentType = GameInfo.Moments[moment.Type].MomentType
	-- 	print(currentMomentType)

	-- 	-- Use the predefined table
	-- 	for key, value in pairs(momentsTable) do
	-- 		if currentMomentType == value then
	-- 			if not Game:GetProperty(key) then
	-- 				Game:SetProperty(key, momentPlayerID)
	-- 				print("Set property " .. key .. " for player " .. tostring(momentPlayerID))
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- Iterate through all players and record the first player to complete a historical moment (slower)
    -- for _, playerID in ipairs(PlayerManager.GetAliveIDs()) do
    --     local momentSummary = Game.GetHistoryManager():GetAllMomentsData(playerID, interestLevel)
    --     for _, moment in ipairs(momentSummary) do
    --         local currentMomentType = GameInfo.Moments[moment.Type].MomentType
    --         print(currentMomentType)
    --         for key, value in pairs(momentsTable) do
    --             if currentMomentType == value then
    --                 if not Game:GetProperty(key) then
    --                     Game:SetProperty(key, playerID)
    --                     print("Set property " .. key .. " for player " .. tostring(playerID))
    --                 end
    --             end
    --         end
    --     end
    -- end
end

local function HSD_GetMomentData(momentIndex)
    local momentData = Game.GetHistoryManager():GetMomentData(momentIndex)
    -- print("momentData.Type = " .. tostring(momentData.Type) .. ", momentData.Turn = " .. tostring(momentData.Turn) .. ", momentData.GameEra = " .. tostring(momentData.GameEra))
	return momentData
end

----------------------------------------------------------------------------------------
-- Initialize all functions and link to the the necessary in-game event hooks
----------------------------------------------------------------------------------------

function InitializeHSD_UI()
	-- Update calendar functions from UI for gameplay scripts
	-- Events.TurnBegin.Add(SetTurnYear)
	Events.TurnEnd.Add(SetTurnYear)
	LuaEvents.SetTurnYear.Add(SetTurnYear)
	LuaEvents.SetAutoValues.Add(SetAutoValues)
	LuaEvents.RestoreAutoValues.Add(RestoreAutoValues)
	LuaEvents.SetStartingEra.Add( SetStartingEra )
	-- Share UI context functions with gameplay scripts
	ExposedMembers.GetStandardTimeline = GetStandardTimeline
	ExposedMembers.GetTrueHSDTimeline = GetTrueHSDTimeline
	ExposedMembers.GetLeaderTimeline = GetLeaderTimeline
	ExposedMembers.GetEraTimeline = GetEraTimeline
	ExposedMembers.GetLitemodeCivs = GetLitemodeCivs
	ExposedMembers.CheckCity.CheckCityGovernor = CheckCityGovernor
	ExposedMembers.CheckCityCapital = CheckCityCapital
	ExposedMembers.CheckCityOriginalCapital = CheckCityOriginalCapital
	ExposedMembers.GetPlayerCityUIDatas = GetPlayerCityUIDatas
	ExposedMembers.GetEraCountdown = GetEraCountdown
	ExposedMembers.GetTribeNameType = GetTribeNameType
	ExposedMembers.GetCalendarTurnYear = GetCalendarTurnYear
	ExposedMembers.HSD_GetTerritoryCache = HSD_GetTerritoryCache
	ExposedMembers.HSD_GetTerritoryID = HSD_GetTerritoryID
	ExposedMembers.HSD_GetTotalIncomingRoutes = HSD_GetTotalIncomingRoutes
	ExposedMembers.HSD_GetRiverPlots = HSD_GetRiverPlots
	ExposedMembers.HSD_GetCultureCounts = HSD_GetCultureCounts
	ExposedMembers.HSD_GetNumTechsResearched = HSD_GetNumTechsResearched
	ExposedMembers.HSD_GetHolyCitiesCount = HSD_GetHolyCitiesCount
	ExposedMembers.HSD_GetCitiesWithGovernors = HSD_GetCitiesWithGovernors
	ExposedMembers.HSD_GetUnitPromotionLevel = HSD_GetUnitPromotionLevel
	ExposedMembers.HSD_GetUnitClassLevel = HSD_GetUnitClassLevel
	ExposedMembers.HSD_GetTourismCounts = HSD_GetTourismCounts
	ExposedMembers.HSD_GetPlotYield = HSD_GetPlotYield
	ExposedMembers.HSD_GetCitiesWithTradingPosts = HSD_GetCitiesWithTradingPosts
	ExposedMembers.HSD_TradePostEveryPlayerOnContinent = HSD_TradePostEveryPlayerOnContinent
	ExposedMembers.HSD_GetGreatWorksCount = HSD_GetGreatWorksCount
	ExposedMembers.HSD_GetGreatWorkTypeCount = HSD_GetGreatWorkTypeCount
	ExposedMembers.HSD_GetNumBeliefs = HSD_GetNumBeliefs
	ExposedMembers.HSD_GetGoldenAge = HSD_GetGoldenAge
	ExposedMembers.HSD_GetMomentData = HSD_GetMomentData
	-- Set current & next turn year ASAP when (re)loading
	LuaEvents.SetCurrentTurnYear(Calendar.GetTurnYearForGame(Game.GetCurrentGameTurn()))
	LuaEvents.SetNextTurnYear(Calendar.GetTurnYearForGame(Game.GetCurrentGameTurn()+1))
	-- Broacast that we're ready to set HSD
	LuaEvents.InitializeHSD()
end

InitializeHSD_UI();

----------------------------------------------------------------------------------------
-- END
----------------------------------------------------------------------------------------