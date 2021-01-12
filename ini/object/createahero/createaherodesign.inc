//----------------------------------------------------------
//	World Builder Grouping	
//----------------------------------------------------------
	Side					 = Men
	EditorSorting			 = UNIT
	ThreatLevel				 = 4.0
	ThingClass				 = CHARACTER_UNIT
	BuildCost				 = CREATE_A_HERO_BUILDCOST ;;,;; CAH_BUILDCOST			   
	BuildTime				 = HERO_BUILDTIME_TIER_4 ;;,;; CAH_BUILDTIME	
	ShockwaveResistance 			 = SHOCKWAVE_RESISTANCE_STRONG		   
	TransportSlotCount		 = TRANSPORTSLOTCOUNT_HERO

;//	DisplayMeleeDamage		 = FARAMIR_DAMAGE
;//	DisplayRangedDamage		 = FARAMIR_BOW_DAMAGE
	
	VisionRange				 = CREATE_A_HERO_VISION_RANGE
	ShroudClearingRange		 = SHROUD_CLEAR_CREATE_A_HERO

	BountyValue				 = 300 ;;,;; GONDOR_FARAMIR_BOUNTY_VALUE
	DisplayName				 = OBJECT:CreateAHero
	RecruitText				 = CONTROLBAR:CreateAHeroRecruit
	ReviveText				 = CONTROLBAR:CreateAHeroRevive
	Hotkey					 = CONTROLBAR:CreateAHeroHotkey
	CrusherLevel			 = 0			//Can I crush anything?
	MountedCrusherLevel		 = 1	 //Crush	level when mounted.
	CrushableLevel			 = 2		  //What	am I?:		  0	= for infantry,	1 =	for	trees, 2 = cavalry/heroes
	MountedCrushableLevel	 = 2   //Crusable level when	mounted.

	CrushWeapon				 = HeroCrush  

	MinCrushVelocityPercent	 = 65 ;;,;; 50 //	Has	to be moving at	at least 50% of	full speed.
	CrushDecelerationPercent = 30 //	Lose xx	percent	of max velocity	when crushing.
	
	CrushKnockback			 = 40
	CrushZFactor			 = 1.0

	CommandSet				 = CreateAHeroCommandSet
	CommandPoints			 = HERO_COMMAND_POINTS_TIER_4 ;;,;; CREATE_A_HERO_COMMAND_POINT_COST
	
