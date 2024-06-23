-- TSL Earth Remastered Civilopedia Text
-- Author: totalslacker

-- BaseGameText
--------------------------------------------------------------
INSERT OR REPLACE INTO BaseGameText
		(Tag, Text)
VALUES	-- General Text
		('LOC_PEDIA_CONCEPTS_PAGEGROUP_TSLEE_NAME',
		'TSL Earth Remastered Map Pack'),
		
		-- Rule Changes
		
		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEEBASE_TITLE',
		'Rule Changes'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEEBASE_PARA_1',
		'The rule changes in this map pack are intended for a more balanced game when using the maximum number of players (60 players with YNAMP).  42 players and 18 city-states, with the "No Duplicate Civilizations" option enabled from the setup menu, is the recommended amount to play with every Civ as of Rise and Fall and Gathering Storm. All rule changes can be disabled through the options in the UserSettings.sql file of this mod (open with a text editor to make changes) or with the instructions listed under the "User Settings" section below.'),
		
		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEEBASE_PARA_2',
		'User Settings:[NEWLINE][NEWLINE][ICON_Bullet]To change the default number of players for a new game, open Config.xml from the Data folder, and search for DefaultPlayers. Uncomment this section of the file by deleting the comment tags, <!-- --> , to activate.[NEWLINE][ICON_Bullet]Setting this to 42 will ensure that all civilizations appear in the game when using random leaders.'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEELOYALTY_TITLE',
		'Loyalty Changes'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEELOYALTY_PARA_1',
		'Due to the close start positions on the Standard and Tiny maps, and the reduced minimum city distance recommended for these maps, loyalty changes have been included to prevent Loyalty pressure from eliminating players in the first 10 turns. These changes can be disabled via User Settings.'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEELOYALTY_PARA_2',
		'[ICON_Bullet][ICON_CapitalLarge]Capital Cities of all players, including [ICON_Envoy]City-States, are permanently Loyal.[NEWLINE][ICON_Bullet]Loyalty pressure has been reduced to "Low" by default. "Normal" is the default Loyalty pressure.'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEELOYALTY_PARA_3',
		'User Settings:[NEWLINE][NEWLINE][ICON_Bullet]Loyal Capitals can be disabled from UserSettings.sql with the LOYAL_CAPITALS option.[NEWLINE][ICON_Bullet]Disable all Loyalty Pressure changes in UserSettings.sql with the LOYALTY_PRESSURE option.[NEWLINE][ICON_Bullet]Read instructions in UserSettings.sql to make your own changes or revert Loyalty Pressure to "Normal".'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEECITYMIN_TITLE',
		'Minimum City Distance'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEECITYMIN_PARA_1',
		'The smaller maps in this map pack -- TSL Earth Remastered, Cordiform Earth and Tiny Earth -- require the minimum distance between cities to be reduced to 2 tiles to fit every start position on the map without overlapping. This setting is enabled by default but is not recommended for either of the larger maps included in this mod.'),
		
		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEECITYMIN_PARA_2',
		'User Settings:[NEWLINE][NEWLINE][ICON_Bullet]Minimum City Distance can be changed from UserSettings.sql with the MIN_CITY_DISTANCE option.'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEERESOURCE_TITLE',
		'Resource Changes'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEERESOURCE_PARA_1',
		'Resources can now appear on a wider variety of terrain and features. New terrain and features for resources listed below:'),
		
		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEERESOURCE_PARA_2',
		'[ICON_Bullet][ICON_Resource_Aluminum]Aluminum: Plains Hills[NEWLINE][ICON_Bullet][ICON_Resource_Cattle] Cattle: Plains[NEWLINE][ICON_Bullet][ICON_Resource_Jade]Jade: Desert Hills, Jungle[NEWLINE][ICON_Bullet][ICON_Resource_Marble]Marble: Desert Hills[NEWLINE][ICON_Bullet][ICON_Resource_Pearls]Pearls: Reefs'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEERESOURCE_PARA_3',
		'User Settings:[NEWLINE][NEWLINE][ICON_Bullet]Changes to resources can be made from the Resources.sql file.[NEWLINE][ICON_Bullet]Remove or add comment tags to change the existing options.'),		

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEESETUP_TITLE',
		'Advanced Setup Options'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEESETUP_PARA_1',
		'Advanced Setup Options related to YNAMP are explained below (these options are only available for VIKING Huge Earth at this time):'),
		
		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEESETUP_PARA_2',
		'[NEWLINE][ICON_Bullet]Resource Exclusion Zones: Use this option for semi-random real world resource placement. Changes to resources can be made from the Resource.xml file.[NEWLINE][NEWLINE][ICON_Bullet]Civilization Requested Resources: Use this option for extra resource placement specific to each Civ. For example, Civs with a UU that requires a strategic resource will always spawn with that resource. YNAMP uses a large list by default for each Civ. See Resources.sql to activate recommended resources for each Civ that have been created specifically for this mod, and to remove the YNAMP default list.[NEWLINE][NEWLINE][ICON_Bullet]User Settings: Resource placement can be controlled for historical realism. For example, you can prevent Horses in the Americas. See the ResourceRegionExclude and ResourceRegionExclusive sections in Resource.xml to make changes to where resources spawn. Note that each Region of the map has its own sections.'),		

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEEOPTIONAL_TITLE',
		'Optional Settings'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEEOPTIONAL_PARA_1',
		'The following settings are disabled be default:'),
		
		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEEOPTIONAL_PARA_2',
		'[NEWLINE][ICON_Bullet]City-State Borders: City-States expand their borders based on the number of envoys they receive by default. When playing with the maximum number of players, this can cause City-State borders to expand exponentially as they meet all players and receive multiple envoys from each player. On the smaller maps in this mod especially, this can unbalance the game as their borders expand too quickly. See Rules_RF.sql in the Data folder for options to turn off City-State border growth completely, or to change their borders to grow by Culture instead, like other Civs.'),
		
		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEEOPTIONAL_PARA_3',
		'[NEWLINE][ICON_Bullet]Named Places: Custom map labels can be activated for real world place names, such as Sahara Desert, Atlantic Ocean, etc. This setting is incomplete and depends on the Civilizations in the game and the order they are selected in the Advanced Setup Menu. See NamedPlaces.xml and NamedPlaces.sql in the Optional folder to make your own changes. These files can be activated by removing the enclosing comment tags in the Modinfo file.'),
		
		--Maps
		
		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEBASE_TITLE',
		'Maps'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEBASE_PARA_1',
		'Features:[NEWLINE][ICON_Bullet]True-Start Locations[NEWLINE][ICON_Bullet]Real World Resource Placement[NEWLINE][ICON_Bullet]Melting Ice Caps and Random Sea Ice Generation (Gathering Storm)[NEWLINE][ICON_Bullet]Natural Disasters (Gathering Storm)'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEMAP01_TITLE',
		'TSL Earth Remastered'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEMAP01_PARA_1',
		'[ICON_Bullet]Author: totalslacker (based on the Firaxis Earth map)[NEWLINE][ICON_Bullet]Size: Standard (84*58)[NEWLINE][ICON_Bullet]Recommended Minimum City Distance: 2[NEWLINE][ICON_Bullet]Recommended Loyalty Pressure: Low[NEWLINE][ICON_Bullet]Real City Names: Yes'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEMAP02_TITLE',
		'Cordiform Earth'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEMAP02_PARA_1',
		'[ICON_Bullet]Author: smellymummy[NEWLINE][ICON_Bullet]Size: Standard (80*52)[NEWLINE][ICON_Bullet]Recommended Minimum City Distance: 2[NEWLINE][ICON_Bullet]Recommended Loyalty Pressure: Low[NEWLINE][ICON_Bullet]Real City Names: Yes'),
		
		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEMAP03_TITLE',
		'Tiny Earth'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEMAP03_PARA_1',
		'[ICON_Bullet]Author: Arendelle[NEWLINE][ICON_Bullet]Size: Tiny (44*26)[NEWLINE][ICON_Bullet]Recommended Minimum City Distance: 2[NEWLINE][ICON_Bullet]Recommended Loyalty Pressure: Low[NEWLINE][ICON_Bullet]Real City Names: No'),		

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEMAP04_TITLE',
		'Cogitator Huge Earth'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEMAP04_PARA_1',
		'[ICON_Bullet]Author: Cogitator[NEWLINE][ICON_Bullet]Size: Huge (106*66)[NEWLINE][ICON_Bullet]Recommended Minimum City Distance: 3[NEWLINE][ICON_Bullet]Recommended Loyalty Pressure: Normal[NEWLINE][ICON_Bullet]Real City Names: No'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEMAP05_TITLE',
		'VIKING Giant Earth'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEMAP05_PARA_1',
		'[ICON_Bullet]Author: VIKING[NEWLINE][ICON_Bullet]Size: Giant (150*94)[NEWLINE][ICON_Bullet]Recommended Minimum City Distance: 3[NEWLINE][ICON_Bullet]Recommended Loyalty Pressure: Normal[NEWLINE][ICON_Bullet]Real City Names: No'),
		
		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEMAP05_PARA_2',
		'[ICON_Exclamation][COLOR_FLOAT_PRODUCTION] NOTE: [ENDCOLOR]Strategic resource generation is not scaling properly with the number of players or map size. Use Resource Exclusion Zones or Civilization Requested Resources options from the Advanced Setup menu to balance strategic resource generation.'),		
		
		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEMAP05_PARA_3',
		'[ICON_Exclamation][COLOR_FLOAT_PRODUCTION] WARNING: [ENDCOLOR]Giant maps are unstable. Late game crashes have been reported with the Coastal Lowlands flooding option enabled with Gathering Storm. Recommended setting is Empty during game setup (coastal flooding due to global warming will not occur). Set Minimum City Distance to 3 or higher for this map. Please report other suggestions for map stability.'),

		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEMAPUSERSETTINGS_TITLE',
		'User Settings and Mod Support'),		
		
		('LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEMAPUSERSETTINGS_PARA_1',
		'[ICON_Bullet]Start Positions: Start positions for Civs, City-States and Natural Wonders can be changed for all maps. Support for community created Civs and Natural Wonders mods can also be added the same way. All start positions are in the [X][Y] coordinate format. Open your map of choice in the Worldbuilder to view [X][Y] coordinates for plots on the map. Start positions are found in the following files:[NEWLINE][ICON_Bullet]MapValues.xml contains all start locations for TSL Earth Remastered, Cordiform Earth and TinyEarth[NEWLINE][ICON_Bullet]CogEarthValues.xml contains all start locations for Cogitator Huge Earth[NEWLINE][ICON_Bullet]Map.xml contains start locations for Civs and City-States for VIKING Huge Earth[NEWLINE][ICON_Bullet]NaturalWonders.xml contains start locations for Natural Wonders for VIKING Huge Earth');	
		
		-- Satellite map reveal may also cause crashes, see JNRs National Project: Satellites mod to make the map reveal project optional.


--------------------------------------------------------------