-- ===========================================================================
--	Historical Victory Data
-- ===========================================================================
print("Loading HistoricalVictory_Data.lua")

-- Insert Civilizations or Leaders into this table for custom historical victories
-- Leader data is used if present, otherwise civilization data will be used
-- This table tracks the index and objective count for each challenge, to be used to generate text and check properties

HSD_victoryConditionsConfig = {

    -- LEADERS
    LEADER_ABRAHAM_LINCOLN = {
        {
            id = "LAND_OF_THE_FREE",
            index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_STATUE_LIBERTY"},
                {type = "FIRST_TECH_RESEARCHED", id = "TECH_FLIGHT"},
                {type = "GREAT_PEOPLE_ACTIVATED", count = 10},
            },
            score = 1
        },
        {
            id = "TRANSCONTINENTAL_RAILROAD",
            index = "2",
            year = 1890,
            era = nil,
            objectives = {
                {type = "ROUTE_TYPE_COUNT", id = "ROUTE_RAILROAD", count = 50},
                {type = "DISTRICT_COUNT", id = "DISTRICT_CANAL", count = 5},
            },
            score = 1
        },
        {
            id = "ARSENAL_OF_DEMOCRACY",
            index = "3",
            year = nil,
            era = "ERA_MODERN",
            objectives = {
                {type = "FIRST_GOVERNMENT", id = "GOVERNMENT_DEMOCRACY"},
                {type = "HIGHEST_PRODUCTION"},
                {type = "UNIT_KILL_COUNT", id = "UNIT_AMERICAN_P51", count = 10},
            },
            score = 1
        },
        -- end of victory conditions
    },

    LEADER_BASIL_II = {
        {
            id = "HOLY_WISDOM",
            index = "1",
            year = 700,
            era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_HAGIA_SOPHIA"},
            },
            score = 1
        },
        {
            id = "DEFENDER_OF_ORTHODOXY",
            index = "2",
            year = 1200,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_BYZANTINE_TAGMA", count = 10},
                {type = "UNIT_CONQUER_CITY_COUNT", id = "UNIT_BYZANTINE_TAGMA", count = 5},
                {type = "CONVERT_ALL_CITIES"},
            },
            score = 1
        },
        {
            id = "FALL_OF_CONSTANTINOPLE",
            index = "3",
            year = 1500,
            era = nil,
            objectives = {
                {type = "OCCUPIED_CAPITAL_COUNT", count = 3},
                {type = "HOLY_CITY_COUNT", count = 3},
                {type = "CITY_COUNT_FOREIGN_CONTINENT", count = 5},
            },
            score = 1
        },
        -- end of victory conditions
    },

    LEADER_CLEOPATRA_ALT = {
        {
			id = "PTOLEMAIC_DYNASTY",
			index = "1",
            year = nil,
			era = nil,
            objectives = {
                {type = "2_WONDERS_IN_CITY", firstID = "BUILDING_GREAT_LIGHTHOUSE", secondID = "BUILDING_GREAT_LIBRARY"},
            },
            score = 1
        },
        {
            id = "ALEXANDRIAN_KINGDOM",
			index = "2",
            year = nil,
			era = nil,
            objectives = {
                {type = "TERRITORY_CONTROL", territory = "SEA", minimumSize = 6},
                {type = "TERRITORY_CONTROL", territory = "DESERT", minimumSize = 6},
            },
            score = 1
        },
        {
            id = "NILE_DELTA",
			index = "3",
			year = -30,
			era = nil,
            objectives = {
                {type = "NUM_CITIES_POP_SIZE", cityNum = 3, popNum = 10},
                {type = "HIGHEST_CULTURE"},
            },
            score = 1
        },
		-- end of victory conditions
    },

    LEADER_ELEANOR_ENGLAND = {
        {
            id = "HUNDRED_YEARS_WAR",
            index = "1",
            year = 1450,
            era = nil,
            objectives = {
                {type = "OCCUPIED_CAPITAL_COUNT", count = 2},
                {type = "LOYALTY_CONVERT_CITY_COUNT", count = 4},
            },
            score = 1
        },
        {
            id = "ANGEVIN_DYNASTY",
            index = "2",
            year = nil,
            era = "ERA_MEDIEVAL",
            objectives = {
                {type = "HIGHEST_CITY_POPULATION"},
                {type = "GREAT_WORK_COUNT", count = 8},
            },
            score = 1
        },
        {
            id = "THE_CRUSADES",
            index = "3",
            year = nil,
            era = "ERA_MEDIEVAL",
            objectives = {
                {type = "HOLY_CITY_COUNT", count = 2},
                {type = "CITY_COUNT_FOREIGN_CONTINENT", count = 4},
            },
            score = 1
        },
        -- end of victory conditions
    },

    LEADER_ELIZABETH = {
        {
            id = "ELIZABETHAN_ERA",
            index = "1",
            year = nil,
            era = "ERA_RENAISSANCE",
            objectives = {
                {type = "CONVERT_ALL_CITIES"},
                {type = "GREAT_WORK_TYPE_COUNT", id = "GREATWORKOBJECT_WRITING", count = 6},
                {type = "GOLD_COUNT", count = 4000},
            },
            score = 1
        },
        {
            id = "AGE_OF_PIRACY",
            index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_PILLAGE_COUNT", id = "UNIT_ENGLISH_SEADOG", count = 20},
                {type = "UNIT_KILL_COUNT", id = "UNIT_ENGLISH_SEADOG", count = 10},
            },
            score = 1
        },
        {
            id = "ROYAL_NAVY",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "MOST_UNIT_FORMATION_CLASS_TYPE", id = "FORMATION_CLASS_NAVAL"},
                {type = "MOST_OUTGOING_TRADE_ROUTES"},
                {type = "TRADING_POST_WITH_ALL_PLAYERS"},
            },
            score = 1
        },
        -- end of victory conditions
    },

    LEADER_GORGO = {
        {
			id = "SPARTAN_VALOR",
			index = "1",
            year = nil,
			era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_GREEK_HOPLITE", count = 10},
                {type = "UNIT_PROMOTION_LEVEL", id = "UNIT_GREEK_HOPLITE", count = 2, level = 8},
                {type = "UNIT_CONQUER_CITY_COUNT", id = "UNIT_GREEK_HOPLITE", count = 5},
            },
            score = 1
        },
        {
            id = "DORIC_COLUMNS",
			index = "2",
            year = nil,
			era = "ERA_CLASSICAL",
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_STATUE_OF_ZEUS"},
                {type = "UNLOCK_ALL_ERA_CIVICS", id = "ERA_CLASSICAL"},
            },
            score = 1
        },
        {
            id = "PELOPONNESIAN_LEAGUE",
			index = "3",
			year = nil,
			era = "ERA_CLASSICAL",
            objectives = {
                {type = "SUZERAINTY_COUNT", count = 2},
                {type = "OCCUPIED_CAPITAL_COUNT", count = 2},
            },
            score = 1
        },
		-- end of victory conditions
    },

    LEADER_HARALD_ALT = {
        {
			id = "GREAT_HEATHEN_ARMY",
			index = "1",
            year = nil,
			era = nil,
            objectives = {
                {type = "UNIT_CONQUER_CITY_COUNT", id = "UNIT_NORWEGIAN_BERSERKER", count = 5},
                {type = "UNIT_PILLAGE_COUNT", id = "UNIT_NORWEGIAN_BERSERKER", count = 10},
                {type = "UNIT_PROMOTION_LEVEL", id = "UNIT_NORWEGIAN_BERSERKER", count = 1, level = 8},
            },
            score = 1
        },
        {
            id = "COUNCIL_OF_THE_ALTHING",
			index = "2",
            year = nil,
			era = "ERA_MEDIEVAL",
            objectives = {
                {type = "SUZERAINTY_COUNT", count = 4},
                {type = "MOMENT_COUNT", id = "MOMENT_PLAYER_LEVIED_MILITARY", count = 4}
            },
            score = 1
        },
        {
            id = "VALHALLA",
			index = "3",
			year = nil,
			era = "ERA_MEDIEVAL",
            objectives = {
                {type = "BUILDING_COUNT", id = "BUILDING_STAVE_CHURCH", count = 5},
                {type = "HOLY_CITY_COUNT", count = 3},
            },
            score = 1
        },
		-- end of victory conditions
    },

	LEADER_JULIUS_CAESAR = {
        {
			id = "GALLIC_WARS",
			index = "1",
            year = -50,
			era = nil,
            objectives = {
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_ROMAN_FORT", count = 5},
                {type = "UNIT_CONQUER_CITY_COUNT", id = "UNIT_ROMAN_LEGION", count = 5},
            },
            score = 1
        },
        {
            id = "BREAD_AND_CIRCUSES",
			index = "2",
            year = nil,
			era = nil,
            objectives = {
                {type = "WONDER_BUILT_CITIES_IN_RANGE", id = "BUILDING_COLOSSEUM", count = 6, range = 6},
                {type = "PROJECT_COUNT", id = "PROJECT_BREAD_AND_CIRCUSES", count = 10},
                {type = "FIRST_GOVERNMENT", id = "GOVERNMENT_FASCISM"},
            },
            score = 1
        },
        {
            id = "RICHER_THAN_CRASSUS",
			index = "3",
			year = nil,
			era = nil,
            objectives = {
                {type = "GOLD_COUNT", count = 10000},
            },
            score = 1
        },
		-- end of victory conditions
    },

    LEADER_KUBLAI_KHAN_CHINA = {
        {
            id = "YUAN_DYNASTY",
            index = "1",
            year = 1368,
            era = nil,
            objectives = {
                {type = "OCCUPIED_CAPITAL_COUNT", count = 3},
                {type = "LAND_AREA_HOME_CONTINENT", percent = 20},
            },
            score = 1
        },
        {
            id = "SILK_ROAD",
            index = "2",
            year = nil,
            era = "ERA_RENAISSANCE",
            objectives = {
                {type = "TRADING_POST_WITH_ALL_PLAYERS_CONTINENT"},
                {type = "MOST_ACTIVE_TRADE_ROUTES"},
                {type = "HIGHEST_GOLD_PER_TURN"},
            },
            score = 1
        },
        {
            id = "MIDDLE_KINGDOM",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "TERRITORY_CONTROL", territory = "DESERT", minimumSize = 6},
                {type = "TERRITORY_CONTROL", territory = "SEA", minimumSize = 6},
                {type = "TERRITORY_CONTROL", territory = "MOUNTAIN", minimumSize = 6},
            },
            score = 1
        },
        -- end of victory conditions
    },

    LEADER_QIN = {
        {
            id = "QIN_DYNASTY",
            index = "1",
            year = nil,
            era = "ERA_CLASSICAL",
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_TERRACOTTA_ARMY"},
                {type = "FIRST_CIVIC_RESEARCHED", id = "CIVIC_CIVIL_SERVICE"},
                {type = "GREAT_PERSON_ERA_COUNT", id = "ERA_CLASSICAL", count = 3},
            },
            score = 1
        },
        {
            id = "GRAND_CANAL",
            index = "2",
            year = nil,
            era = "ERA_MEDIEVAL",
            objectives = {
                {type = "DISTRICT_COUNT", id = "DISTRICT_CANAL", count = 5},
                {type = "GOLD_COUNT", count = 3000},
                {type = "HIGHEST_TECH_COUNT"},
            },
            score = 1
        },
        {
            id = "GREAT_WALL_OF_CHINA",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_GREAT_WALL", count = 20},
                {type = "UNIT_KILL_COUNT", id = "UNIT_CHINESE_CROUCHING_TIGER", count = 10},
                {type = "GOLDEN_AGE_COUNT", count = 3},
            },
            score = 1
        },
        -- end of victory conditions
    },

    LEADER_RAMSES = {
        {
			id = "MONUMENTS_OF_THE_PHARAOHS",
			index = "1",
            year = -1700,
			era = nil,
            objectives = {
				{type = "WONDER_ADJACENT_IMPROVEMENT", id = "BUILDING_PYRAMIDS", improvement = "IMPROVEMENT_SPHINX"},
            },
            score = 1
        },
        {
            id = "THE_NEW_KINGDOM",
			index = "2",
            year = -1050,
			era = nil,
            objectives = {
                {type = "CITY_COUNT", count = 4},
                {type = "UNIT_KILL_COUNT", id = "UNIT_EGYPTIAN_CHARIOT_ARCHER", count = 5},
            },
            score = 1
        },
        {
            id = "KARNAK",
			index = "3",
            year = nil,
			era = "ERA_CLASSICAL",
            eraLimit = "END_ERA",
            objectives = {
                {type = "FIRST_GREAT_PERSON_CLASS", id = "GREAT_PERSON_CLASS_PROPHET"},
                {type = "FIRST_BUILDING_CONSTRUCTED", id = "BUILDING_TEMPLE"},
                {type = "HIGHEST_CULTURE"},
            },
            score = 1
        },
		-- end of victory conditions
    },

    LEADER_SALADIN_ALT = {
        {
			id = "DAMASCUS_STEEL",
			index = "1",
            year = nil,
			era = nil,
            objectives = {
				{type = "UNIT_CONQUER_CITY_COUNT", id = "UNIT_ARABIAN_MAMLUK", count = 10},
            },
            score = 1
        },
        {
            id = "HOLY_WAR",
			index = "2",
            year = nil,
			era = "ERA_MEDIEVAL",
            objectives = {
                {type = "HOLY_CITY_COUNT", count = 4},
            },
            score = 1
        },
        {
            id = "DESERT_EMPIRE",
			index = "3",
            year = nil,
			era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_PETRA"},
                {type = "TERRITORY_CONTROL", territory = "DESERT", minimumSize = 12},
                {type = "RESOURCE_MONOPOLY", id = "RESOURCE_INCENSE", percent = 60},
            },
            score = 1
        },
		-- end of victory conditions
    },

    LEADER_SULEIMAN_ALT = {
        {
            id = "KAISER_I_RUM",
            index = 1,
            year = 1566,
            era = nil,
            objectives = {
                {type = "CITY_COUNT", count = 10},
                {type = "CITY_COUNT_FOREIGN_CONTINENT", count = 5},
                {type = "OCCUPIED_CAPITAL_COUNT", count = 5},
            },
        },
        {
            id = "BARBARY_PIRATES",
            index = 2,
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_PILLAGE_COUNT", id = "UNIT_OTTOMAN_BARBARY_CORSAIR", count = 50},
                {type = "TERRITORY_CONTROL", territory = "SEA", minimumSize = 8},
            },
        },
        {
            id = "EMPIRE_OF_WEALTH",
            index = 3,
            year = nil,
            era = "ERA_RENAISSANCE",
            objectives = {
                {type = "HIGHEST_CULTURE"},
                {type = "BUILDING_COUNT", id = "BUILDING_GRAND_BAZAAR", count = 7},
                {type = "HAPPIEST_POPULATION"},
            },
        },
    },

    LEADER_T_ROOSEVELT_ROUGHRIDER = {
        {
            id = "MANIFEST_DESTINY",
            index = "1",
            year = 1900,
            era = nil,
            objectives = {
                {type = "NATURAL_WONDER_COUNT", count = 4},
                {type = "UNIT_KILL_COUNT", id = "UNIT_AMERICAN_ROUGH_RIDER", count = 10},
                {type = "LAND_AREA_HOME_CONTINENT", percent = 40},
            },
            score = 1
        },
        {
            id = "AMERICANA",
            index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_BROADWAY"},
                {type = "WONDER_BUILT", id = "BUILDING_STATUE_LIBERTY"},
                {type = "WONDER_BUILT", id = "BUILDING_PANAMA_CANAL"},
            },
            score = 1
        },
        {
            id = "FOREIGN_ENTANGLEMENTS",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "SUZERAINTY_COUNT", count = 4},
                {type = "MAXIMUM_ALLIANCE_LEVEL_COUNT", count = 4},
                {type = "RESOURCE_MONOPOLY", id = "RESOURCE_OIL", percent = 40},
            },
            score = 1
        },
        -- end of victory conditions
    },

    LEADER_VICTORIA = {
        {
			id = "VICTORIAN_ERA",
			index = "1",
            year = nil,
			era = "ERA_INDUSTRIAL",
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_OXFORD_UNIVERSITY"},
				{type = "GREAT_PERSON_ERA_COUNT", id = "ERA_INDUSTRIAL", count = 5},
                {type = "GREAT_WORK_COUNT", count = 20}, -- TESTING
            },
            score = 1
        },
        {
            id = "INDUSTRIAL_REVOLUTION",
			index = "2",
            year = 1860,
            era = nil,
            objectives = {
                {type = "FIRST_TECH_RESEARCHED", id = "TECH_INDUSTRIALIZATION"},
                {type = "WONDER_BUILT", id = "BUILDING_BIG_BEN"},
                {type = "BUILDING_COUNT", id = "BUILDING_FACTORY", count = 6},
            },
            score = 1
        },
        {
            id = "SUN_NEVER_SETS",
			index = "3",
			year = 1920,
			era = nil,
            objectives = {
                {type = "CITY_COUNT_EVERY_CONTINENT", count = 1},
                {type = "CITY_COUNT_FOREIGN_CONTINENT", count = 10},
                {type = "UNIT_KILL_COUNT", id = "UNIT_ENGLISH_REDCOAT", count = 20},
            },
            score = 1
        },
		-- end of victory conditions
    },

    LEADER_WU_ZETIAN = {
        {
            id = "TANG_DYNASTY",
            index = "1",
            year = nil,
            era = "ERA_MEDIEVAL",
            objectives = {
                {type = "HIGHEST_CITY_POPULATION"},
                {type = "HIGHEST_CULTURE"},
                {type = "RESOURCE_MONOPOLY", id = "RESOURCE_SILK", percent = 60},
            },
            score = 1
        },
        {
            id = "IMPERIAL_EXAMS",
            index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "FIRST_TECH_RESEARCHED", id = "TECH_MACHINERY"},
                {type = "FIRST_TECH_RESEARCHED", id = "TECH_GUNPOWDER"},
                {type = "FIRST_TECH_RESEARCHED", id = "TECH_PRINTING"},
            },
            score = 1
        },
        {
            id = "PALACE_INTRIGUE",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_PROMOTION_LEVEL", id = "UNIT_SPY", count = 3, level = 3},
                {type = "FIRST_HISTORICAL_MOMENT", id = "MOMENT_SPY_MAX_LEVEL_FIRST"},
                {type = "COMPLETE_ESPIONAGE_MISSIONS", count = 10}, -- TESTING
            },
            score = 1
        },
        -- end of victory conditions
    },

    LEADER_YONGLE = {
        {
            id = "MING_DYNASTY",
            index = "1",
            year = nil,
            era = "ERA_RENAISSANCE",
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_FORBIDDEN_CITY"},
                {type = "SUZERAINTY_COUNT", count = 4},
                {type = "NUM_CITIES_POP_SIZE", cityNum = 10, popNum = 10},
            },
            score = 1
        },
        {
            id = "TREASURE_FLEETS",
            index = "2",
            year = nil,
            era = "ERA_RENAISSANCE",
            objectives = {
                {type = "TERRITORY_CONTROL", territory = "SEA", minimumSize = 8},
                {type = "FIRST_TECH_RESEARCHED", id = "TECH_CARTOGRAPHY"},
                {type = "MOST_OUTGOING_TRADE_ROUTES"},
            },
            score = 1
        },
        {
            id = "MYRIADS",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "PROJECT_COUNT", id = "PROJECT_LIJIA_FAITH", count = 10},
                {type = "PROJECT_COUNT", id = "PROJECT_LIJIA_FOOD", count = 10},
                {type = "PROJECT_COUNT", id = "PROJECT_LIJIA_GOLD", count = 10},
            },
            score = 1
        },
        -- end of victory conditions
    },

    -- CIVILIZATIONS

    CIVILIZATION_AMERICA = {
        {
            id = "MANIFEST_DESTINY",
            index = "1",
            year = 1900,
            era = nil,
            objectives = {
                {type = "NATURAL_WONDER_COUNT", count = 4},
                {type = "MOMENT_COUNT", id = "MOMENT_NATIONAL_PARK_CREATED", count = 4},
                {type = "LAND_AREA_HOME_CONTINENT", percent = 40},
            },
            score = 1
        },
        {
            id = "AMERICANA",
            index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_BROADWAY"},
                {type = "WONDER_BUILT", id = "BUILDING_STATUE_LIBERTY"},
                {type = "WONDER_BUILT", id = "BUILDING_GOLDEN_GATE_BRIDGE"},
            },
            score = 1
        },
        {
            id = "SPACE_RACE",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "PROJECT_FIRST_COMPLETED", id = "PROJECT_MANHATTAN_PROJECT"},
                {type = "PROJECT_FIRST_COMPLETED", id = "PROJECT_LAUNCH_MOON_LANDING"},
                {type = "HIGHEST_TOURISM"},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_ARABIA = {
        {
			id = "TRADE_CARAVANS",
			index = "1",
            year = nil,
			era = "ERA_MEDIEVAL",
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_PETRA"},
                {type = "MOST_ACTIVE_TRADE_ROUTES"},
            },
            score = 1
        },
        {
            id = "HOUSE_OF_WISDOM",
			index = "2",
            year = nil,
            era = "ERA_MEDIEVAL",
            objectives = {
                {type = "BUILDING_COUNT", id = "BUILDING_MADRASA", count = 4},
                {type = "GREAT_PERSON_ERA_COUNT", id = "ERA_MEDIEVAL", count = 4},
            },
            score = 1
        },
        {
            id = "CALIPHATE",
			index = "3",
			year = nil,
			era = "ERA_RENAISSANCE",
            objectives = {
                {type = "MOST_CITIES_FOLLOWING_RELIGION"},
                {type = "HIGHEST_FAITH_PER_TURN"},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_AUSTRALIA = {
        {
            id = "GREAT_SOUTHERN_LAND",
            index = "1",
            year = nil,
            era = "ERA_MODERN",
            objectives = {
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_OUTBACK_STATION", count = 10},
                {type = "COASTAL_CITY_COUNT", count = 7},
                {type = "NATURAL_WONDER_COUNT", count = 2},
            },
            score = 1
        },
        {
            id = "ANZAC",
            index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_DIGGER", count = 10},
                {type = "MAXIMUM_ALLIANCE_LEVEL_COUNT", count = 3},
            },
            score = 1
        },
        {
            id = "SURFERS_PARADISE",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_SYDNEY_OPERA_HOUSE"},
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_BEACH_RESORT", count = 10},
                {type = "HIGHEST_TOURISM"},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_AZTEC = {
        {
			id = "CHINAMPAS",
			index = "1",
            year = nil,
			era = "ERA_MEDIEVAL",
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_HUEY_TEOCALLI"},
                {type = "HIGHEST_CITY_POPULATION"},
            },
            score = 1
        },
        {
            id = "FLOWER_WARS",
			index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_AZTEC_EAGLE_WARRIOR", count = 20},
            },
            score = 1
        },
        {
            id = "AZATLAN",
			index = "3",
			year = nil,
			era = "ERA_INDUSTRIAL",
            eraLimt = "END_ERA",
            objectives = {
                {type = "MOST_CITIES_ON_HOME_CONTINENT"},
                {type = "BUILDING_COUNT", id = "BUILDING_TLACHTLI", count = 4},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_BABYLON_STK = {
        {
			id = "LAND_OF_TWO_RIVERS",
			index = "1",
            year = nil,
			era = nil,
            objectives = {
                {type = "CONTROL_ALL_ADJACENT_RIVER_TO_CAPITAL"},
                {type = "WONDER_BUILT", id = "BUILDING_HANGING_GARDENS"},
            },
            score = 1
        },
        {
            id = "WALLS_OF_BABYLON",
			index = "2",
            year = nil,
            era = "ERA_CLASSICAL",
            eraLimit = "END_ERA",
            objectives = {
                {type = "BUILDING_IN_CAPITAL", id = "BUILDING_CASTLE"},
                {type = "UNIT_KILL_COUNT", id = "UNIT_BABYLONIAN_SABUM_KIBITTUM", count = 10},
            },
            score = 1
        },
        {
            id = "CENTER_OF_THE_WORLD",
			index = "3",
			year = nil,
			era = "ERA_CLASSICAL",
            eraLimit = "END_ERA",
            objectives = {
                {type = "HIGHEST_CITY_POPULATION"},
                {type = "HIGHEST_CULTURE"},
                {type = "FIRST_TECH_RESEARCHED", id = "TECH_ASTRONOMY"},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_BRAZIL = {
        {
            id = "AMAZON_CIVILIZATION",
            index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "FEATURE_COUNT", id = "FEATURE_JUNGLE", count = 40},
            },
            score = 1
        },
        {
            id = "CARNIVALS",
            index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "HAPPIEST_POPULATION"},
                {type = "PROJECT_COUNT", id = "PROJECT_CARNIVAL", count = 10},
                {type = "PROJECT_COUNT", id = "PROJECT_WATER_CARNIVAL", count = 10},
            },
            score = 1
        },
        {
            id = "BRAZILIAN_ICONS",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_CRISTO_REDENTOR"},
                {type = "WONDER_BUILT", id = "BUILDING_ESTADIO_DO_MARACANA"},
                {type = "UNIT_COUNT", id = "UNIT_BRAZILIAN_MINAS_GERAES", count = 5},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_BYZANTIUM = {
        {
            id = "HOLY_WISDOM",
            index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_HAGIA_SOPHIA"},
            },
            score = 1
        },
        {
            id = "RELIGIOUS_ICONS",
            index = "2",
            year = nil,
            era = "ERA_MEDIEVAL",
            objectives = {
                {type = "HIGHEST_FAITH_PER_TURN"},
                {type = "HIGHEST_CULTURE"},
                {type = "CONVERT_ALL_CITIES"},
            },
            score = 1
        },
        {
            id = "GREEK_FIRE",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_BYZANTINE_DROMON", count = 20},
                {type = "COASTAL_CITY_COUNT", count = 10},
                {type = "TERRITORY_CONTROL", territory = "SEA", minSize = 6},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_CANADA = {
        {
            id = "WINTER_SPORTS",
            index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_SKI_RESORT", count = 10},
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_ICE_HOCKEY_RINK", count = 10},
            },
            score = 1
        },
        {
            id = "CANADIAN_SHIELD",
            index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_BIOSPHERE"},
                {type = "MOMENT_COUNT", id = "MOMENT_NATIONAL_PARK_CREATED", count = 5},
                {type = "MOST_ARCTIC_TERRAIN"},
            },
            score = 1
        },
        {
            id = "CANADIAN_DIPLOMACY",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "MAXIMUM_ALLIANCE_LEVEL_COUNT", count = 4},
                {type = "MOST_FRIENDS"},
                {type = "MOMENT_COUNT", id = "MOMENT_EMERGENCY_WON_AS_MEMBER", count = 1},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_CHINA = {
        {
            id = "DYNASTIC_CYCLE",
            index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "DIFFERENT_GOVERNMENTS_ADOPTED", count = 10},
                {type = "WONDER_BUILT", id = "BUILDING_FORBIDDEN_CITY"},
                {type = "FIRST_CIVIC_RESEARCHED", id = "CIVIC_CIVIL_SERVICE"},
            },
            score = 1
        },
        {
            id = "ART_OF_WAR",
            index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "FIRST_GREAT_PERSON_CLASS", id = "GREAT_PERSON_CLASS_GENERAL"},
                {type = "WONDER_BUILT", id = "BUILDING_TERRACOTTA_ARMY"},
                {type = "UNIT_KILL_COUNT", id = "UNIT_CHINESE_CROUCHING_TIGER", count = 10},
            },
            score = 1
        },
        {
            id = "GREAT_WALL_OF_CHINA",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_GREAT_WALL", count = 20},
                {type = "NUM_CITIES_CAPITAL_RANGE", count = 6, range = 6},
                {type = "HIGHEST_TOURISM"},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_CREE = {
        {
            id = "GREAT_PLAINS",
            index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_PROMOTION_LEVEL", id = "UNIT_CREE_OKIHTCITAW", count = 1, level = 8},
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_MEKEWAP", count = 10},
                {type = "MOST_TERRAIN_TYPE", id = "TERRAIN_PLAINS"},
            },
            score = 1
        },
        {
            id = "IRON_CONFEDERACY",
            index = "2",
            year = nil,
            era = "ERA_INDUSTRIAL",
            objectives = {
                {type = "ALLIANCE_COUNT", count = 5},
                {type = "TRADING_POST_IN_EVERY_CITY"},
                {type = "TRADING_POST_WITH_ALL_PLAYERS_CONTINENT"},
            },
            score = 1
        },
        {
            id = "FUR_TRADE",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "RESOURCE_MONOPOLY", id = "RESOURCE_FURS", percent = 60},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_EGYPT = {
        {
			id = "MONUMENTS_OF_THE_PHARAOHS",
			index = "1",
            year = nil,
			era = "ERA_ANCIENT",
            objectives = {
				{type = "WONDER_ADJACENT_IMPROVEMENT", id = "BUILDING_PYRAMIDS", improvement = "IMPROVEMENT_SPHINX"},
            },
            score = 1
        },
        {
            id = "NILE_KINGDOM",
			index = "2",
            year = nil,
			era = nil,
            objectives = {
                {type = "CONTROL_ALL_ADJACENT_RIVER_TO_CAPITAL"},
                {type = "FIRST_NUM_ACTIVE_ALLIANCES", count = 5},
                {type = "MAXIMUM_ALLIANCE_LEVEL_COUNT", count = 1},
            },
            score = 1
        },
        {
            id = "BREADBASKET_OF_ANCIENT_WORLD",
			index = "3",
			year = -30,
            yearLimit = "ON_YEAR",
			era = nil,
            objectives = {
                {type = "MOST_ACTIVE_TRADE_ROUTES"},
                {type = "HIGHEST_CITY_POPULATION"},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_ENGLAND = {
        {
			id = "VICTORIAN_ERA",
			index = "1",
            year = nil,
			era = "ERA_INDUSTRIAL",
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_OXFORD_UNIVERSITY"},
				{type = "GREAT_PERSON_ERA_COUNT", id = "ERA_INDUSTRIAL", count = 5},
                {type = "GREAT_WORK_COUNT", count = 20},
            },
            score = 1
        },
        {
            id = "INDUSTRIAL_REVOLUTION",
			index = "2",
            year = 1860,
            era = nil,
            objectives = {
                {type = "FIRST_TECH_RESEARCHED", id = "TECH_INDUSTRIALIZATION"},
                {type = "WONDER_BUILT", id = "BUILDING_BIG_BEN"},
                {type = "BUILDING_COUNT", id = "BUILDING_FACTORY", count = 6},
            },
            score = 1
        },
        {
            id = "SUN_NEVER_SETS",
			index = "3",
			year = 1920,
			era = nil,
            objectives = {
                {type = "CITY_COUNT_EVERY_CONTINENT", count = 1},
                {type = "CITY_COUNT_FOREIGN_CONTINENT", count = 10},
                {type = "MOST_UNIT_DOMAIN_TYPE", id = "DOMAIN_SEA"},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_ETHIOPIA = {
        {
            id = "KINGDOM_OF_AKSUM",
            index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "GREAT_WORK_TYPE_COUNT", id = "GREATWORKOBJECT_ARTIFACT", count = 10}, -- TESTING
                {type = "FIRST_RELIGIOUS_BELIEFS", count = 4}, -- TESTING
            },
            score = 1
        },
        {
            id = "SOLOMONIC_DYNASTY",
            index = "2",
            year = nil,
            era = "ERA_MEDIEVAL",
            objectives = {
                {type = "HIGHEST_FAITH_PER_TURN"},
                {type = "ALL_CITIES_FOLLOW_RELIGION"},
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_ROCK_HEWN_CHURCH", count = 5},
            },
            score = 1
        },
        {
            id = "ETHIOPIAN_HIGHLANDS",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_ETHIOPIAN_OROMO_CAVALRY", count = 20},
                {type = "MOST_HILL_PLOTS"},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_FRANCE = {
        {
			id = "AGE_OF_CHIVALRY",
			index = "1",
            year = 1450,
			era = nil,
            objectives = {
                {type = "CITY_WITH_IMPROVEMENT_COUNT", id = "IMPROVEMENT_CHATEAU", count = 4},
                {type = "UNIT_COUNT", id = "UNIT_KNIGHT", count = 5},
                {type = "WONDER_BUILT", id = "BUILDING_MONT_ST_MICHEL"},
            },
            score = 1
        },
        {
            id = "NAPOLEONIC_WARS",
			index = "2",
            year = 1815,
            era = nil,
            objectives = {
                {type = "UNIT_CONQUER_CITY_COUNT", id = "UNIT_FRENCH_GARDE_IMPERIALE", count = 10},
                {type = "GREAT_PERSON_TYPE_FROM_ERA", id = "GREAT_PERSON_CLASS_GENERAL", era = "ERA_INDUSTRIAL", count = 1}, -- TESTING
                {type = "FIRST_CIVIC_RESEARCHED", id = "CIVIC_NATIONALISM"},
            },
            score = 1
        },
        {
            id = "BELLE_EPOQUE",
			index = "3",
			year = 1900,
            yearLimit = "ON_YEAR",
			era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_EIFFEL_TOWER"},
                {type = "HIGHEST_CULTURE"},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_GAUL = {
        {
			id = "DRUIDIC_LORE",
			index = "1",
            year = -250,
			era = nil,
            objectives = {
                {type = "BUILDING_COUNT", id = "BUILDING_ORACLE", count = 1},
				{type = "BUILDING_COUNT", id = "BUILDING_STONEHENGE", count = 1},
                {type = "FEATURE_COUNT", id = "FEATURE_FOREST", count = 5},
            },
            score = 1
        },
        {
            id = "CELTIC_MIGRATIONS",
			index = "2",
            year = -50,
            yearLimit = "ON_YEAR",
            era = nil,
            objectives = {
                {type = "BORDERING_CITY_COUNT", count = 5},
                {type = "GOLD_COUNT", count = 1000},
            },
            score = 1
        },
        {
            id = "PAINTED_WARRIORS",
			index = "3",
			year = nil,
			era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_GAUL_GAESATAE", count = 20},
                {type = "UNIT_PILLAGE_COUNT", id = "UNIT_GAUL_GAESATAE", count = 10},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_GEORGIA = {
        {
			id = "BAGRATIONI_DYNASTY",
			index = "1",
            year = nil,
			era = nil,
            objectives = {
                {type = "MAXIMUM_ALLIANCE_LEVEL_COUNT", count = 3},
                {type = "SUZERAINTY_COUNT", count = 4},
                {type = "GOLDEN_AGE_COUNT", count = 3},
            },
            score = 1
        },
        {
            id = "DEFENDER_OF_THE_FAITH",
			index = "2",
            year = nil,
            era = "ERA_MEDIEVAL",
            objectives = {
                {type = "CONVERT_ALL_CITIES"},
                {type = "HIGHEST_FAITH_PER_TURN"},
                {type = "UNIT_KILL_COUNT", id = "UNIT_GEORGIAN_KHEVSURETI", count = 10},
            },
            score = 1
        },
        {
            id = "CAUCASIAN_IBERIA",
			index = "3",
			year = nil,
			era = "ERA_MEDIEVAL",
            objectives = {
                {type = "TERRITORY_CONTROL", territory = "MOUNTAIN", minimumSize = 4},
                {type = "BUILDING_IN_CAPITAL", id = "BUILDING_TSIKHE"},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_GERMANY = {
        {
			id = "HOLY_ROMAN_EMPIRE",
			index = "1",
            year = nil,
			era = "ERA_RENAISSANCE",
            objectives = {
                {type = "CONVERT_ALL_CITIES"},
				{type = "OCCUPIED_CAPITAL_COUNT", count = 3},
            },
            score = 1
        },
        {
            id = "HANSEATIC_LEAGUE",
			index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "DISTRICT_COUNT", id = "DISTRICT_HANSA", count = 5},
                {type = "GREAT_PEOPLE_ACTIVATED", count = 4},
                {type = "UNIT_CLASS_PROMOTION_LEVEL", id = "PROMOTION_CLASS_NAVAL_RAIDER", count = 2, level = 8},
            },
            score = 1
        },
        {
            id = "MITTELEUROPA",
			index = "3",
			year = nil,
			era = "ERA_MODERN",
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_RUHR_VALLEY"},
                {type = "HIGHEST_PRODUCTION"},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_GREECE = {
        {
			id = "CLASSICAL_AGE",
			index = "1",
            year = nil,
			era = "ERA_CLASSICAL",
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_ORACLE"},
				{type = "WONDER_BUILT", id = "BUILDING_COLOSSUS"},
                {type = "FIRST_GREAT_PERSON_CLASS", id = "GREAT_PERSON_CLASS_ADMIRAL"},
            },
            score = 1
        },
        {
            id = "CRADLE_OF_THE_WEST",
			index = "2",
            year = nil,
            era = "ERA_CLASSICAL",
            eraLimit = "END_ERA",
            objectives = {
                {type = "GREAT_PEOPLE_ACTIVATED", count = 4},
                {type = "HIGHEST_CULTURE"},
            },
            score = 1
        },
        {
            id = "PHILHELLENES",
			index = "3",
			year = nil,
			era = nil,
            objectives = {
                {type = "FIRST_NUM_ACTIVE_ALLIANCES", count = 5},
                {type = "SUZERAINTY_COUNT", count = 5},
                {type = "TERRITORY_CONTROL", territory = "SEA", minimumSize = 6},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_HUNGARY = {
        {
            id = "MAGYAR_CONQUEST",
            index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_HUNGARY_BLACK_ARMY", count = 20},
                {type = "UNIT_KILL_COUNT", id = "UNIT_HUNGARY_HUSZAR", count = 20},
            },
            score = 1
        },
        {
            id = "GOLDEN_BULL",
            index = "2",
            year = nil,
            era = "ERA_RENAISSANCE",
            objectives = {
                {type = "SUZERAINTY_COUNT", count = 3},
                {type = "DISTRICT_COUNT_CAPITAL_ADJACENT", count = 5},
                {type = "MOMENT_COUNT", id = "MOMENT_PLAYER_LEVIED_MILITARY", count = 5},
            },
            score = 1
        },
        {
            id = "GREAT_HUNGARIAN_PLAIN",
            index = "3",
            year = 1904,
            era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_ORSZAGHAZ"},
                {type = "BUILDING_COUNT", id = "BUILDING_THERMAL_BATH", count = 3},
                {type = "ALLIANCE_COUNT", count = 5},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_INCA = {
        {
            id = "MACHU_PICCHU",
			index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_MACHU_PICCHU"},
            },
            score = 1
        },
        {
            id = "SAPA_INCA",
			index = "2",
            year = 1572,
            era = nil,
            objectives = {
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_TERRACE_FARM", count = 6},
                {type = "UNIT_KILL_COUNT", id = "UNIT_INCA_WARAKAQ", count = 10},
                {type = "GOLD_IN_TREASURY", amount = 3000},
            },
            score = 1
        },
        {
            id = "ANDEAN_CIVILIZATION",
			index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "MOST_TERRAIN_CLASS", id = "TERRAIN_CLASS_MOUNTAIN"},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_INDIA = {
        {
            id = "MAURYAN_EMPIRE",
            index = "1",
            year = nil,
            era = "ERA_CLASSICAL",
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_INDIAN_VARU", count = 10},
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_STEPWELL", count = 5},
            },
            score = 1
        },
        {
            id = "SILK_ROAD_PILGRIMS",
            index = "2",
            year = nil,
            era = "ERA_MEDIEVAL",
            objectives = {
                {type = "CONVERT_MAJORITY_HOME_CONTINENT_RELIGION"},
                {type = "FIRST_RELIGIOUS_BELIEFS", count = 4},
                {type = "UNIT_COUNT", id = "UNIT_GURU", count = 10},
            },
            score = 1
        },
        {
            id = "INDIAN_WONDERS",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_TAJ_MAHAL"},
                {type = "WONDER_BUILT", id = "BUILDING_MAHABODHI_TEMPLE"},
                {type = "WONDER_BUILT", id = "BUILDING_MEENAKSHI_TEMPLE"},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_INDONESIA = {
        {
            id = "SPICE_ISLANDS",
            index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "RESOURCE_MONOPOLY", id = "RESOURCE_SPICES", percent = 60},
                {type = "ISLAND_COUNT", count = 10},
                {type = "COASTAL_CITY_COUNT", count = 6},
            },
            score = 1
        },
        {
            id = "TRADE_CENTER",
            index = "2",
            year = nil,
            era = "ERA_MEDIEVAL",
            objectives = {
                {type = "MOST_OUTGOING_TRADE_ROUTES"},
                {type = "HIGHEST_FAITH_PER_TURN"},
            },
            score = 1
        },
        {
            id = "NAVAL_POWER",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_INDONESIAN_JONG", count = 10},
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_KAMPUNG", count = 10},
                {type = "TERRITORY_CONTROL", territory = "SEA", minimumSize = 8},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_JAPAN = {
        {
            id = "LAND_OF_THE_RISING_SUN",
            index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_KOTOKU_IN"},
                {type = "HIGHEST_CULTURE"},
                {type = "FIRST_CITY_SIZE", count = 20},
            },
            score = 1
        },
        {
            id = "SAMURAI_CODE",
            index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_JAPANESE_SAMURAI", count = 20},
                {type = "UNIT_CONQUER_CITY_COUNT", id = "UNIT_JAPANESE_SAMURAI", count = 5},
                {type = "UNIT_PROMOTION_LEVEL", id = "UNIT_JAPANESE_SAMURAI", count = 1, level = 8},
            },
            score = 1
        },
        {
            id = "MEIJI_RESTORATION",
            index = "3",
            year = nil,
            era = "ERA_MODERN",
            objectives = {
                {type = "BUILDING_COUNT", id = "BUILDING_ELECTRONICS_FACTORY", count = 3},
                {type = "HIGHEST_TECH_COUNT"},
                {type = "MOST_UNIT_DOMAIN_TYPE", id = "DOMAIN_SEA"},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_KHMER = {
        {
            id = "ANGKOR_WAT",
            index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_ANGKOR_WAT"},
                {type = "UNIT_KILL_COUNT", id = "UNIT_KHMER_DOMREY", count = 10},
            },
            score = 1
        },
        {
            id = "MONASTIC_EDUCATION",
            index = "2",
            year = nil,
            era = "ERA_MEDIEVAL",
            objectives = {
                {type = "DISTRICT_COUNT", id = "DISTRICT_PRASAT", count = 4},
                {type = "CONVERT_ALL_CITIES"},
                {type = "HIGHEST_FAITH_PER_TURN"},
            },
            score = 1
        },
        {
            id = "EMPIRE_OF_WATER",
            index = "3",
            year = 1400,
            era = nil,
            objectives = {
                {type = "DISTRICT_COUNT", id = "DISTRICT_AQUEDUCT", count = 4},
                {type = "HAPPIEST_POPULATION"},
                {type = "HIGHEST_CITY_POPULATION"},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_KONGO = {
        {
            id = "KONGO_KINGDOM",
            index = "1",
            year = nil,
            era = "ERA_RENAISSANCE",
            objectives = {
                {type = "HIGHEST_POPULATION_CITY"},
                {type = "CONVERT_ALL_CITIES"},
            },
            score = 1
        },
        {
            id = "ICONS_OF_AFRICA",
            index = "2",
            year = 1800,
            era = nil,
            objectives = {
                {type = "GREAT_WORK_TYPE_COUNT", id = "GREATWORKOBJECT_RELIC", count = 5},
                {type = "GREAT_WORK_TYPE_COUNT", id = "GREATWORKOBJECT_ARTIFACT", count = 5},
                {type = "GREAT_WORK_TYPE_COUNT", id = "GREATWORKOBJECT_SCULPTURE", count = 5},
            },
            score = 1
        },
        {
            id = "KONGO_BASIN",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "RESOURCE_MONOPOLY", id = "RESOURCE_IVORY", percent = 60},
                {type = "FEATURE_COUNT", id = "FEATURE_JUNGLE", count = 20},
                {type = "CONTROL_ALL_ADJACENT_RIVER_TO_CAPITAL"},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_KOREA = {
        {
            id = "HANGUL",
            index = "1",
            year = 1500,
            era = nil,
            objectives = {
                {type = "FIRST_TECH_RESEARCHED", id = "TECH_PRINTING"},
                {type = "HIGHEST_TECH_COUNT"},
                {type = "GOVERNOR_IN_EVERY_CITY"},
            },
            score = 1
        },
        {
            id = "JOSEON_DYNASTY",
            index = "2",
            year = 1800,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_KOREAN_HWACHA", count = 20},
                {type = "HIGHEST_CULTURE"},
            },
            score = 1
        },
        {
            id = "K_POP",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_PROMOTION_LEVEL", id = "UNIT_ROCK_BAND", count = 1, level = 4},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_MACEDON = {
        {
            id = "CONQUESTS_OF_ALEXANDER",
            index = "1",
            year = -300,
            era = nil,
            objectives = {
                {type = "OCCUPIED_CAPITAL_COUNT", count = 3},
                {type = "MOMENT_COUNT", id = "MOMENT_UNIT_KILLED_ASSISTED_BY_GENERAL", count = 1},
            },
            score = 1
        },
        {
            id = "THE_DIADOCHI",
            index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "GREAT_PERSON_TYPE_COUNT", id = "GREAT_PERSON_CLASS_GENERAL", count = 5},
                {type = "UNIT_KILL_COUNT", id = "UNIT_MACEDONIAN_HETAIROI", count = 20},
                {type = "UNIT_PROMOTION_LEVEL", id = "UNIT_MACEDONIAN_HYPASPIST", count = 1, level = 8},
            },
            score = 1
        },
        {
            id = "HELLENISTIC_ERA",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "WONDER_CONTROL_ALL"},
                {type = "CITY_NAME_COUNT", id = "ALEXANDRIA", count = 10},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_MALI = {
        {
            id = "GOLDEN_AGE_OF_MALI",
            index = "1",
            year = nil,
            era = "ERA_MEDIEVAL",
            objectives = {
                {type = "GOLD_COUNT", count = 5000},
                {type = "HIGHEST_FAITH_PER_TURN"},
                {type = "WONDER_BUILT", id = "BUILDING_UNIVERSITY_SANKORE"},
            },
            score = 1
        },
        {
            id = "TRANS_SAHARAN_TRADE",
            index = "2",
            year = nil,
            era = "ERA_MEDIEVAL",
            objectives = {
                {type = "MOST_OUTGOING_TRADE_ROUTES"},
                {type = "DISTRICT_COUNT", id = "DISTRICT_SUGUBA", count = 6},
            },
            score = 1
        },
        {
            id = "SAHEL_EMPIRE",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_MALI_MANDEKALU_CAVALRY", count = 20},
                {type = "RESOURCE_MONOPOLY", id = "RESOURCE_SALT", percent = 60},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_MAORI = {
        {
            id = "WAR_DANCE",
            index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "TOA", count = 20},
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_PA", count = 10},
                {type = "BUILDING_COUNT", id = "BUILDING_MARAE", count = 5},
            },
            score = 1
        },
        {
            id = "MANA",
            index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "FEATURE_COUNT", id = "FEATURE_VOLCANO", count = 5},
                {type = "FEATURE_COUNT", id = "FEATURE_REEF", count = 10},
                {type = "FEATURE_COUNT", id = "FEATURE_JUNGLE", count = 20},
            },
            score = 1
        },
        {
            id = "OCEAN_NAVIGATORS",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "MOST_WATER_PLOTS_CONTROL"},
                {type = "SEA_TERRITORY_SIZE", name = "Named Sea", size = 6},
                {type = "COASTAL_CITY_COUNT", count = 10},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_MAPUCHE = {
        {
            id = "PEOPLE_OF_THE_WOOD",
            index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_CHEMAMULL", count = 10},
                {type = "IMPROVEMENT_YIELD_COUNT", id = "IMPROVEMENT_CHEMAMULL", yield = "YIELD_CULTURE", count = 6},
            },
            score = 1
        },
        {
            id = "MALON_RAIDERS",
            index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_MAPUCHE_MALON_RAIDER", count = 20},
                {type = "UNIT_PILLAGE_COUNT", id = "UNIT_MAPUCHE_MALON_RAIDER", count = 20},
                {type = "UNIT_CONQUER_CITY_COUNT", id = "UNIT_MAPUCHE_MALON_RAIDER", count = 5},
            },
            score = 1
        },
        {
            id = "PATAGONIA",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "TERRITORY_CONTROL", territory = "MOUNTAIN", minimumSize = 6},
                {type = "TERRITORY_CONTROL", territory = "DESERT", minimumSize = 6},
                {type = "NATURAL_WONDER_COUNT", count = 1},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_MAYA = {
        {
			id = "CHICHEN_ITZA",
			index = "1",
            year = nil,
			era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_CHICHEN_ITZA"},
            },
            score = 1
        },
        {
            id = "STAR_WARS",
			index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "NUM_CITIES_CAPITAL_RANGE", count = 6, range = 6},
                {type = "UNIT_KILL_COUNT", id = "UNIT_MAYAN_HULCHE", count = 20},
            },
            score = 1
        },
        {
            id = "LONG_COUNT_CALENDAR",
			index = "3",
			year = 2012,
			era = nil,
            objectives = {
                {type = "HIGHEST_TECH_COUNT"},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_MONGOLIA = {
        {
            id = "MONGOL_SHOT",
            index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_MONGOLIAN_KESHIG", count = 50},
                {type = "BUILDING_COUNT", id = "BUILDING_ORDU", count = 5},
            },
            score = 1
        },
        {
            id = "SILK_ROAD",
            index = "2",
            year = nil,
            era = "ERA_RENAISSANCE",
            objectives = {
                {type = "MOST_ACTIVE_TRADE_ROUTES"},
                {type = "ROUTE_COUNT", count = 40},
            },
            score = 1
        },
        {
            id = "YEKE_MONGGHOL_ULUS",
            index = "3",
            year = nil,
            era = "ERA_RENAISSANCE",
            objectives = {
                {type = "OCCUPIED_CAPITAL_COUNT", count = 10},
                {type = "GREAT_PERSON_TYPE_COUNT", id = "GREAT_PERSON_CLASS_GENERAL", count = 3},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_NETHERLANDS = {
        {
            id = "DUTCH_EMPIRE",
            index = "1",
            year = nil,
            era = "ERA_RENAISSANCE",
            objectives = {
                {type = "CITY_COUNT_EVERY_CONTINENT", count = 1},
                {type = "CITY_COUNT_FOREIGN_CONTINENT", count = 7},
                {type = "UNIT_KILL_COUNT", id = "UNIT_DE_ZEVEN_PROVINCIEN", count = 10},
            },
            score = 1
        },
        {
            id = "DUTCH_GOLDEN_AGE",
            index = "2",
            year = 1672,
            era = nil,
            objectives = {
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_POLDER", count = 6},
                {type = "GREAT_WORK_TYPE_COUNT", id = "GREATWORKOBJECT_ART", count = 10},
            },
            score = 1
        },
        {
            id = "TRADE_MASTERY",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "FIRST_BUILDING_CONSTRUCTED", id = "BUILDING_STOCK_EXCHANGE"},
                {type = "FIRST_HISTORICAL_MOMENT", id = "MOMENT_TRADING_POST_CONSTRUCTED_IN_EVERY_CIV_FIRST_IN_WORLD"},
                {type = "GOLD_COUNT", count = 7000},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_NORWAY = {
        {
			id = "VIKING_AGE",
			index = "1",
            year = nil,
			era = nil,
            objectives = {
                {type = "UNIT_PILLAGE_COUNT", id = "UNIT_NORWEGIAN_LONGSHIP", count = 30},
                {type = "OCCUPIED_CAPITAL_COUNT", count = 3},
                {type = "MOST_OUTGOING_TRADE_ROUTES"},
            },
            score = 1
        },
        {
            id = "NORSE_EXPEDITIONS",
			index = "2",
            year = nil,
            era = "ERA_MEDIEVAL",
            objectives = {
                {type = "NATURAL_WONDER_COUNT", count = 4},
                {type = "CITY_COUNT_FOREIGN_CONTINENT", count = 3},
            },
            score = 1
        },
        {
            id = "LAND_OF_THE_MIDNIGHT_SUN",
			index = "3",
			year = nil,
			era = "ERA_RENAISSANCE",
            objectives = {
                {type = "FEATURE_COUNT", id = "FEATURE_ICE", count = 15},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_NUBIA = {
        {
			id = "KINGDOM_OF_GOLD",
			index = "1",
            year = nil,
			era = "ERA_CLASSICAL",
            objectives = {
                {type = "HIGHEST_GOLD_PER_TURN"},
                {type = "GOLD_COUNT", count = 1500},
            },
            score = 1
        },
        {
            id = "BOWMEN_OF_TASETI",
			index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_NUBIAN_PITATI", count = 20},
                {type = "UNIT_PROMOTION_LEVEL", id = "UNIT_NUBIAN_PITATI", count = 1, level = 8},
            },
            score = 1
        },
        {
            id = "MONUMENTS_OF_MEROE",
			index = "3",
			year = nil,
			era = nil,
            objectives = {
                {type = "WONDER_ADJACENT_IMPROVEMENT", id = "BUILDING_JEBEL_BARKAL", improvement = "IMPROVEMENT_PYRAMID"},
                {type = "IMPROVEMENT_PYRAMID", count = 10},
                {type = "GOLD_COUNT", count = 6000},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_OTTOMAN = {
        {
            id = "KAISER_I_RUM",
            index = 1,
            year = 1566,
            era = nil,
            objectives = {
                {type = "CITY_COUNT", count = 10},
                {type = "CITY_COUNT_FOREIGN_CONTINENT", count = 5},
                {type = "OCCUPIED_CAPITAL_COUNT", count = 5},
            },
        },
        {
            id = "JANISSARY_CORP",
            index = 2,
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_COUNT", id = "UNIT_SULEIMAN_JANISSARY", count = 10},
                {type = "UNIT_CONQUER_CITY_COUNT", id = "UNIT_SULEIMAN_JANISSARY", count = 10},
                {type = "UNIT_PILLAGE_COUNT", id = "UNIT_OTTOMAN_BARBARY_CORSAIR", count = 10},
            },
        },
        {
            id = "EMPIRE_OF_WEALTH",
            index = 3,
            year = nil,
            era = "ERA_RENAISSANCE",
            objectives = {
                {type = "MOST_ACTIVE_TRADE_ROUTES"},
                {type = "BUILDING_COUNT", id = "BUILDING_GRAND_BAZAAR", count = 7},
                {type = "HAPPIEST_POPULATION"},
            },
        },
    },

    CIVILIZATION_PERSIA = {
        {
			id = "THE_IMMORTALS",
			index = "1",
            year = -450,
			era = nil,
            objectives = {
                {type = "UNIT_COUNT", id = "UNIT_PERSIAN_IMMORTAL", count = 5},
                {type = "UNIT_KILL_COUNT", id = "UNIT_PERSIAN_IMMORTAL", count = 10},
                {type = "OCCUPIED_CAPITAL_COUNT", count = 3},
            },
            score = 1
        },
        {
            id = "ACHAEMENID_ARCHITECTURE",
			index = "2",
            year = -330,
			era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_APADANA"},
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_PAIRIDAEZA", count = 5},
            },
            score = 1
        },
        {
            id = "KING_OF_KINGS",
			index = "3",
			year = nil,
			era = nil,
            objectives = {
                {type = "FIRST_GOVERNMENT", id = "GOVERNMENT_MONARCHY"},
                {type = "SUZERAINTY_COUNT", count = 5},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_PHOENICIA = {
        {
			id = "MERCANTILE_EMPIRE",
			index = "1",
            year = nil,
			era = "ERA_CLASSICAL",
            eraLimit = "END_ERA",
            objectives = {
                {type = "MOST_OUTGOING_TRADE_ROUTES"},
                {type = "GOLD_COUNT", count = 1500},
                {type = "MOST_UNIT_DOMAIN_TYPE", id = "DOMAIN_SEA"},
            },
            score = 1
        },
        {
            id = "REFUGEES_OF_TYRE",
			index = "2",
            year = nil,
			era = "ERA_CLASSICAL",
            objectives = {
                {type = "PROJECT_COUNT", id = "PROJECT_COTHON_CAPITAL_MOVE", count = 1},
                {type = "COASTAL_CITY_COUNT", count = 6},
            },
            score = 1
        },
        {
            id = "PURPLE_DYE_MONOPOLY",
			index = "3",
			year = nil,
			era = nil,
            objectives = {
                {type = "RESOURCE_MONOPOLY", id = "RESOURCE_DYES", percent = 60},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_POLAND = {
        {
            id = "PIAST_DYNASTY",
            index = "1",
            year = 1368,
            era = nil,
            objectives = {
                {type = "HIGHEST_FAITH_PER_TURN"},
                {type = "GREAT_WORK_TYPE_COUNT", id = "GREATWORKOBJECT_RELIC", count = 6},
                {type = "CONVERT_ALL_CITIES"},
            },
            score = 1
        },
        {
            id = "GOLDEN_LIBERTY",
            index = "2",
            year = nil,
            era = "ERA_RENAISSANCE",
            objectives = {
                {type = "BUILDING_IN_EVERY_CITY", id = "BUILDING_SUKIENNICE"},
                {type = "GREAT_PERSON_ERA_COUNT", id = "ERA_RENAISSANCE", count = 3},
            },
            score = 1
        },
        {
            id = "POLISH_LITHUANIAN_COMMONWEALTH",
            index = "3",
            year = 1648,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_POLISH_HUSSAR", count = 20},
                {type = "NUM_CITIES_CAPITAL_RANGE", count = 6, range = 6},
                {type = "ENVOYS_WITH_CITY_STATE", count = 10},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_PORTUGAL = {
        {
            id = "FIRST_EMPIRE",
            index = "1",
            year = 1580,
            era = nil,
            objectives = {
                {type = "CITY_COUNT_FOREIGN_CONTINENT", count = 5},
                {type = "WONDER_BUILT", id = "BUILDING_TORRE_DE_BELEM"},
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_FEITORIA", count = 10},
            },
            score = 1
        },
        {
            id = "AGE_OF_DISCOVERY",
            index = "2",
            year = nil,
            era = "ERA_RENAISSANCE",
            objectives = {
                {type = "FIRST_HISTORICAL_MOMENT", id = "MOMENT_WORLD_CIRCUMNAVIGATED_FIRST_IN_WORLD"},
                {type = "MOST_OUTGOING_TRADE_ROUTES"},
                {type = "UNIT_KILL_COUNT", id = "UNIT_PORTUGUESE_NAU", count = 10},
            },
            score = 1
        },
        {
            id = "SECOND_EMPIRE",
            index = "3",
            year = 1800,
            era = nil,
            objectives = {
                {type = "CITY_COUNT_FOREIGN_CONTINENT", count = 10},
                {type = "CONVERT_ALL_CITIES"},
            },
            score = 1
        },
        -- end of victory conditions
    },

	CIVILIZATION_ROME = {
        {
			id = "PAX_ROMANA",
			index = "1",
            year = 200,
			era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_COLOSSEUM"},
                {type = "DISTRICT_COUNT", id = "DISTRICT_BATH", count = 4},
                {type = "ROUTE_COUNT", count = 15},
            },
            score = 1
        },
        {
            id = "IMPERIUM_ROMANUM",
			index = "2",
            year = 450,
			era = nil,
            objectives = {
                {type = "LAND_AREA_HOME_CONTINENT", percent = 20},
                {type = "CITY_COUNT_FOREIGN_CONTINENT", count = 5},
            },
            score = 1
        },
        {
            id = "MARE_NOSTRUM",
			index = "3",
			year = nil,
			era = nil,
            objectives = {
                {type = "TERRITORY_CONTROL", territory = "SEA", minimumSize = 8},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_RUSSIA = {
        {
            id = "FOR_THE_MOTHERLAND",
            index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_ST_BASILS_CATHEDRAL"},
                {type = "WONDER_BUILT", id = "BUILDING_HERMITAGE"},
                {type = "WONDER_BUILT", id = "BUILDING_BOLSHOI_THEATRE"},
            },
            score = 1
        },
        {
            id = "SIBERIAN_FRONTIER",
            index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "TOTAL_LAND_AREA", percent = 15},
                {type = "UNIT_KILL_COUNT", id = "UNIT_RUSSIAN_COSSACK", count = 20},
                {type = "PROJECT_FIRST_COMPLETED", id = "PROJECT_LAUNCH_EARTH_SATELLITE"},
            },
            score = 1
        },
        {
            id = "IRON_CURTAIN",
            index = "3",
            year = nil,
            era = "ERA_ATOMIC",
            objectives = {
                {type = "FIRST_GOVERNMENT", id = "GOVERNMENT_COMMUNISM"},
                {type = "BUILDING_COUNT", id = "BUILDING_FACTORY", count = 10},
                {type = "NUCLEAR_WEAPONS_COUNT", count = 10},
            },
            score = 1
        },
        -- end of victory conditions
    },

    CIVILIZATION_SCOTLAND = {
        {
			id = "SCOTTISH_ENLIGHTENMENT",
			index = "1",
            year = nil,
			era = nil,
            objectives = {
                {type = "FIRST_CIVIC_RESEARCHED", id = "CIVIC_THE_ENLIGHTENMENT"},
                {type = "GREAT_PERSON_ERA_COUNT", id = "ERA_INDUSTRIAL", count = 3},
                {type = "IMPROVEMENT_YIELD_COUNT", id = "IMPROVEMENT_GOLF_COURSE", yield = "YIELD_CULTURE", count = 3},
            },
            score = 1
        },
        {
            id = "HIGHLAND_CHARGE",
			index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_SCOTTISH_HIGHLANDER", count = 10},
                {type = "UNIT_PROMOTION_LEVEL", id = "UNIT_SCOTTISH_HIGHLANDER", count = 1, level = 8},
            },
            score = 1
        },
        {
            id = "ACT_OF_UNION",
			index = "3",
			year = nil,
			era = nil,
            objectives = {
                {type = "ALLIANCE_COUNT", count = 5},
                {type = "MAXIMUM_ALLIANCE_LEVEL_COUNT", count = 4},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_SCYTHIA = {
        {
			id = "PARTHIAN_SHOT",
			index = "1",
            year = nil,
			era = "ERA_CLASSICAL",
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_SCYTHIAN_HORSE_ARCHER", count = 10},
                {type = "UNIT_PILLAGE_COUNT", id = "UNIT_SCYTHIAN_HORSE_ARCHER", count = 10},
                {type = "UNIT_CLASS_COUNT", id = "PROMOTION_CLASS_LIGHT_CAVALRY", count = 20},
            },
            score = 1
        },
        {
            id = "STEPPE_NOMADS",
			index = "2",
            year = nil,
            era = "ERA_CLASSICAL",
            objectives = {
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_KURGAN", count = 10},
                {type = "MOST_TERRAIN_TYPE", id = "TERRAIN_PLAINS"},
            },
            score = 1
        },
        {
            id = "HORSE_MASTERS",
			index = "3",
			year = nil,
			era = nil,
            objectives = {
                {type = "FIRST_TECH_RESEARCHED", id = "TECH_HORSEBACK_RIDING"},
                {type = "FIRST_TECH_RESEARCHED", id = "TECH_STIRRUPS"},
                {type = "RESOURCE_MONOPOLY", id = "RESOURCE_HORSES", percent = 60},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_SPAIN = {
        {
			id = "RECONQUISTA",
			index = "1",
            year = nil,
			era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_SPANISH_CONQUISTADOR", count = 10},
                {type = "UNIT_CONQUER_CITY_COUNT", id = "UNIT_SPANISH_CONQUISTADOR", count = 5},
                {type = "MOMENT_COUNT", id = "MOMENT_INQUISITION_LAUNCHED", count = 5},
            },
            score = 1
        },
        {
            id = "AGE_OF_DISCOVERY",
			index = "2",
            year = 1650,
            era = nil,
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_CASA_DE_CONTRATACION"},
                {type = "CITY_COUNT_FOREIGN_CONTINENT", count = 10},
                {type = "NATURAL_WONDER_COUNT", count = 5},
            },
            score = 1
        },
        {
            id = "MISSIONARY_ZEAL",
			index = "3",
			year = nil,
			era = nil,
            objectives = {
                {type = "CONVERT_NUM_CONTINENTS", count = 3},
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_MISSION", count = 10},
                {type = "FIRST_HISTORICAL_MOMENT", id = "MOMENT_FORMATION_ARMADA_FIRST_IN_WORLD"},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_SUMERIA = {
        {
			id = "CRADLE_OF_CIVILIZATION",
			index = "1",
            year = nil,
			era = nil,
            objectives = {
                {type = "FIRST_BUILDING_CONSTRUCTED", id = "BUILDING_LIBRARY"},
                {type = "FIRST_CIVIC_RESEARCHED", id = "CIVIC_EARLY_EMPIRE"},
                {type = "FIRST_WAR_DECLARED"},
            },
            score = 1
        },
        {
            id = "SUMERIAN_RENAISSANCE",
			index = "2",
            year = nil,
			era = "ERA_ANCIENT",
            objectives = {
                {type = "WONDER_BUILT", id = "BUILDING_ETEMENANKI"},
                {type = "IMPROVEMENT_COUNT", id = "IMPROVEMENT_ZIGGURAT", count = 3},
            },
            score = 1
        },
        {
            id = "EPIC_OF_GILGAMESH",
			index = "3",
			year = nil,
			era = "ERA_ANCIENT",
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_SUMERIAN_WAR_CART", count = 5},
				{type = "FIRST_GREAT_PERSON_CLASS", id = "GREAT_PERSON_CLASS_WRITER"},
            },
            score = 1
        },
		-- end of victory conditions
    },

    CIVILIZATION_ZULU = {
        {
            id = "ISANDLWANA",
            index = "1",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_ERA_DIFFERENCE", id = "UNIT_ZULU_IMPI", count = 2},
            },
            score = 1
        },
        {
            id = "CATTLE_WEALTH",
            index = "2",
            year = nil,
            era = nil,
            objectives = {
                {type = "RESOURCE_MONOPOLY", id = "CATTLE", percent = 60},
            },
            score = 1
        },
        {
            id = "ZULU_WARS",
            index = "3",
            year = nil,
            era = nil,
            objectives = {
                {type = "UNIT_KILL_COUNT", id = "UNIT_ZULU_IMPI", count = 50},
            },
            score = 1
        },
        -- end of victory conditions
    },
    -- Other civilizations' conditions follow...
}