;,; 2.02 v8.4 AI Resource and CP Bonus

;,; Brutal Bonuses ;,;
Behavior = AttributeModifierUpgrade ModuleTag_BrutalAISinglePlayer
        TriggeredBy                = Upgrade_BrutalAISinglePlayer 
        AttributeModifier        = BrutalAIResourceBuildingBonus_Level1
    End
	
	Behavior = AttributeModifierUpgrade ModuleTag_BrutalAISinglePlayer2
        TriggeredBy                = Upgrade_BrutalAISinglePlayer Upgrade_StructureLevel2
        AttributeModifier        = BrutalAIResourceBuildingBonus_Level2
		RequiresAllTriggers = Yes
    End
	
	Behavior = AttributeModifierUpgrade ModuleTag_BrutalAISinglePlayer3 
        TriggeredBy                = Upgrade_BrutalAISinglePlayer Upgrade_StructureLevel3
        AttributeModifier        = BrutalAIResourceBuildingBonus_Level3
		RequiresAllTriggers = Yes
    End
	
	Behavior = AttributeModifierUpgrade ModuleTag_AIBrutalMultiplayer 
        TriggeredBy                = Upgrade_BrutalAIMultiPlayer 
        AttributeModifier        = BrutalAIResourceBuildingBonus_Level1
    End
	
	Behavior = AttributeModifierUpgrade ModuleTag_AIBrutalMultiplayer2 
        TriggeredBy                = Upgrade_BrutalAIMultiPlayer Upgrade_StructureLevel2
        AttributeModifier        = BrutalAIResourceBuildingBonus_Level2
		RequiresAllTriggers = Yes
    End
	
	Behavior = AttributeModifierUpgrade ModuleTag_AIBrutalMultiplayer3 
        TriggeredBy                = Upgrade_BrutalAIMultiPlayer Upgrade_StructureLevel3
        AttributeModifier        = BrutalAIResourceBuildingBonus_Level3
		RequiresAllTriggers = Yes
    End
	
;,; Hard Bonuses ;,;

	Behavior = AttributeModifierUpgrade ModuleTag_HardAISinglePlayer 
        TriggeredBy                = Upgrade_HardAISinglePlayer 
        AttributeModifier        = HardAIResourceBuildingBonus_Level1
    End
	
	Behavior = AttributeModifierUpgrade ModuleTag_HardAISinglePlayer2 
        TriggeredBy                = Upgrade_HardAISinglePlayer Upgrade_StructureLevel2
        AttributeModifier        = HardAIResourceBuildingBonus_Level2
		RequiresAllTriggers = Yes
    End
	
	Behavior = AttributeModifierUpgrade ModuleTag_HardAISinglePlayer3 
        TriggeredBy                = Upgrade_HardAISinglePlayer Upgrade_StructureLevel3
        AttributeModifier        = HardAIResourceBuildingBonus_Level3
		RequiresAllTriggers = Yes
    End
	
	Behavior = AttributeModifierUpgrade ModuleTag_AIHardMultiplayer 
        TriggeredBy                = Upgrade_HardAIMultiPlayer 
        AttributeModifier        = HardAIResourceBuildingBonus_Level1
    End
	
	Behavior = AttributeModifierUpgrade ModuleTag_AIHardMultiplayer2 
        TriggeredBy                = Upgrade_HardAIMultiPlayer Upgrade_StructureLevel2
        AttributeModifier        = HardAIResourceBuildingBonus_Level2
		RequiresAllTriggers = Yes
    End
	
	Behavior = AttributeModifierUpgrade ModuleTag_AIHardMultiplayer3 
        TriggeredBy                = Upgrade_HardAIMultiPlayer Upgrade_StructureLevel3
        AttributeModifier        = HardAIResourceBuildingBonus_Level3
		RequiresAllTriggers = Yes
    End