--	TSL Earth Remastered Civilopedia 
--	Author: totalslacker

-- CivilopediaPageGroups
--------------------------------------------------------------
INSERT OR REPLACE INTO CivilopediaPageGroups
		(SectionID,		PageGroupId,			SortIndex,	VisibleIfEmpty,	Tooltip,	Name)
VALUES	('CONCEPTS',	'TSLEE',	-10,			0,				'',			'LOC_PEDIA_CONCEPTS_PAGEGROUP_TSLEE_NAME');
--------------------------------------------------------------

-- CivilopediaPages
--------------------------------------------------------------
INSERT OR REPLACE INTO CivilopediaPages
		(SectionId,		PageId,								PageGroupId,			SortIndex,	PageLayoutId,						Tooltip,	Name)
VALUES	('CONCEPTS',	'TSLEE_RULES',				'TSLEE',	1,			'TSLEE_RULES',				'',			'LOC_PEDIA_CONCEPTS_PAGE_TSLEE_RULES_CHAPTER_TSLEEBASE_TITLE'),
		('CONCEPTS',	'TSLEE_MAPS',				'TSLEE',	2,			'TSLEE_MAPS',				'',			'LOC_PEDIA_CONCEPTS_PAGE_TSLEE_MAPS_CHAPTER_TSLEEBASE_TITLE');
--------------------------------------------------------------

-- CivilopediaPageLayouts
--------------------------------------------------------------
INSERT OR REPLACE INTO CivilopediaPageLayouts
		(PageLayoutId,						ScriptTemplate)
VALUES	('TSLEE_RULES',	'Simple'),
		('TSLEE_MAPS',	'Simple');
--------------------------------------------------------------

-- CivilopediaPageLayoutChapters
--------------------------------------------------------------
--RULES
INSERT OR REPLACE INTO CivilopediaPageLayoutChapters
		(PageLayoutId,					ChapterId,			SortIndex)	
VALUES	('TSLEE_RULES',	'TSLEEBASE',		10);

INSERT OR REPLACE INTO CivilopediaPageLayoutChapters
		(PageLayoutId,					ChapterId,			SortIndex)	
VALUES	('TSLEE_RULES',	'TSLEELOYALTY',	20);

INSERT OR REPLACE INTO CivilopediaPageLayoutChapters
		(PageLayoutId,					ChapterId,			SortIndex)	
VALUES	('TSLEE_RULES',	'TSLEECITYMIN',	30);

INSERT OR REPLACE INTO CivilopediaPageLayoutChapters
		(PageLayoutId,					ChapterId,			SortIndex)	
VALUES	('TSLEE_RULES',	'TSLEERESOURCE',	40);

INSERT OR REPLACE INTO CivilopediaPageLayoutChapters
		(PageLayoutId,					ChapterId,			SortIndex)	
VALUES	('TSLEE_RULES',	'TSLEESETUP',	50);

INSERT OR REPLACE INTO CivilopediaPageLayoutChapters
		(PageLayoutId,					ChapterId,			SortIndex)	
VALUES	('TSLEE_RULES',	'TSLEEOPTIONAL',	60);

--MAPS
INSERT OR REPLACE INTO CivilopediaPageLayoutChapters
		(PageLayoutId,					ChapterId,			SortIndex)	
VALUES	('TSLEE_MAPS',	'TSLEEBASE',		10);

INSERT OR REPLACE INTO CivilopediaPageLayoutChapters
		(PageLayoutId,					ChapterId,			SortIndex)	
VALUES	('TSLEE_MAPS',	'TSLEEMAP01',	20);

INSERT OR REPLACE INTO CivilopediaPageLayoutChapters
		(PageLayoutId,					ChapterId,			SortIndex)	
VALUES	('TSLEE_MAPS',	'TSLEEMAP02',	30);

INSERT OR REPLACE INTO CivilopediaPageLayoutChapters
		(PageLayoutId,					ChapterId,			SortIndex)	
VALUES	('TSLEE_MAPS',	'TSLEEMAP03',	40);

INSERT OR REPLACE INTO CivilopediaPageLayoutChapters
		(PageLayoutId,					ChapterId,			SortIndex)	
VALUES	('TSLEE_MAPS',	'TSLEEMAP04',	50);

INSERT OR REPLACE INTO CivilopediaPageLayoutChapters
		(PageLayoutId,					ChapterId,			SortIndex)	
VALUES	('TSLEE_MAPS',	'TSLEEMAP05',	60);

INSERT OR REPLACE INTO CivilopediaPageLayoutChapters
		(PageLayoutId,					ChapterId,			SortIndex)	
VALUES	('TSLEE_MAPS',	'TSLEEMAPUSERSETTINGS',	70);