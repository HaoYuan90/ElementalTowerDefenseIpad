#ifndef GameTest_Constants_h
#define GameTest_Constants_h

#endif

//ENUM
typedef enum {noElement, kFire, kWater, kWood, kEarth, kMetal} ElementalType;

typedef enum {noBuff, kHealing, kStrengthening, kHastening, kSlowing, kFreeze} BuffType;

typedef enum {noTower, kFireTower, kWaterTower, kWoodTower, kEarthTower, kMetalTower, kIceTower, kWindTower, kMagmaTower, kJadeTower} TowerType;

typedef enum {kHealthChange, kSpeedChange, kResistanceChange} arrowTagType;

typedef enum {kIncrease, kDecrease} arrowTagState;

typedef enum {kBurning, kFreezing} CreepMaskType;

typedef enum {invalidComboWarning, notEnoughCoinsWarning, selectedSameTowerComboWarning, selectedSameElementComboWarning, comboContainingHighLevelTowerWarning, notBasicElementWarning} popoverWarningType;

//MACROS
#define FBOX(x) [NSNumber numberWithFloat:x]

//CONSTANTS
#define projectilePositionalOffset 1.5

// creep health bar
#define creepHealthBarWidth 3
#define creepHealthBarMaxHeight 50
#define creepHealthBarX 20
#define creepHealthBarY 20

// creep mask
#define creepBurningMaskImage (@"burningMask.png")
#define creepFreezingMaskImage (@"freezeMask.png")

#define towerImageType @".PNG"
//universal tags for hashing tower/proj
#define levelTag (@"Level")
#define typeTag (@"Type")
#define descTag (@"Desc")
#define dmgTag (@"Dmg")
#define levelLockTag (@"levelLock")


//tower
#define DEFAULT_TOWER_ATTACK_COOLDOWN 1
#define towerSellValueMultiplier 0.8
#define towerBuildCostTag (@"TowerCost")
#define towerUpgradeCostTag (@"UpgradeCost")
#define towerSellingValueTag (@"SellingValue")

// wind aura
#define WIND_AURA_MULTIPLIER 1.2

//wood tower
#define splitAttackTargetNumber (@"NumTargets")

//ice tower 
#define towerAOETag (@"aoe")
#define effectDurationTag (@"effectDuration")

#define maxLevelTag (@"MaxLevel")
#define levelPrefix (@"Level")

#define towerInfoTag (@"TowerInfo")
#define attackRadiusTag (@"AttackRadius")
#define attackCooldownTag (@"AttackCooldown")
#define specialAbilityCooldownTag (@"SpecialAbilityCooldown")

#define projectileInfoTag (@"ProjectileInfo")
#define projectileSpeedTag (@"Speed")
//fire projectile 
#define projectileAOETag (@"aoe")
//metal projectile
#define projectileCritChanceTag (@"critChance")
#define projectileCritMultTag (@"critMult")
//water projectile
#define projectileDebuffDuration (@"duration")
#define projectileDeBuffFactor (@"factor")

//universal tags for hashing creeps/waves
#define waveCountTag (@"waveNumber")
#define genRateTag (@"genRate")
#define creepSequenceTag (@"creepSequence")

#define creepInfoTag (@"creepInfo")
#define creepBuffTypeTag (@"creepBuffType")
#define creepBuffDuraTag (@"creepBuffDura")
#define creepBuffRadTag (@"creepBuffRad")
#define creepBuffFactorTag (@"creepBuffFactor")
#define hpTag (@"hp")
#define creepSpeedTag (@"speed")
#define creepBountyTag (@"bounty")
#define normalImageNameTag (@"normalImageName")
#define hurtImageNameTag (@"hurtImageName")
#define deadImageNameTag (@"deadImageName")

#define creepResistanceTag (@"resistance")
#define creepFireResistTag (@"fireRes")
#define creepWaterResistTag (@"waterRes")
#define creepMetalResistTag (@"metalRes")
#define creepWoodResistTag (@"woodRes")
#define creepEarthResistTag (@"earthRes")

//notification center Observation tags
#define towerSACDStateTag (@"specialAbilityCDChanged")

// ipad screen constants
#define IPAD_LANDSCAPE_MAX_WIDTH 1024.0
#define IPAD_LANDSCAPE_MAX_HEIGHT 748.0

// dialog img
#define DIALOG_IMG @"dialog.png"
#define NEXT_BUTTON_IMG @"next_button.png"

// game level
#define DATABASE_NAME @"ETD.sqlite"
#define LEVEL_IMG @"level.png"
#define LEVEL_VIEW_WIDTH 124.0
#define LEVEL_VIEW_HEIGHT 120.0
#define LEVEL_GAP_X 10.0
#define LEVEL_GAP_Y 10.0
#define NUMBER_LEVEL_VIEW_PER_ROW 6
#define highScoreTag @"highScore"
#define levelFileNameTag @"fileName"
#define levelNameTag @"name"
#define STARS_IMAGES [NSArray arrayWithObjects:@"0Star.png", @"1Star.png", @"2Stars.png", @"3Stars.png", nil]

// stage Tag
#define STAGE_FILE @"stages"
#define fireStageTag @"fireStage"
#define stageNameTag @"name"
#define stageLevelsTag @"levels"

//for backend data
#define SOCIAL_MODE_USER_ID @"user_id"
#define SOCIAL_MODE_STAGE @"stage"
#define SOCIAL_MODE_WAVE @"wave"
#define SOCIAL_MODE_TOWERS @"towers"
#define SOCIAL_MODE_CREDIT @"credit"

//in game pop up images
#define SCROLL_IMG @"scroll.png"
#define OPTION_SHARE_IMG @"optionShare.png"
#define OPTION_NEXT_LEVEL_IMG @"optionNextLevel.png"
#define OPTION_RESTART_IMG @"optionRestart.png"
#define OPTION_LEVEL_SELECTION_IMG @"optionLevelSelection.png"
#define OPTION_MAIN_MENUE_IMG @"optionMainMenu.png"


