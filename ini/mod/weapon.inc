;//////////////////////////////////////////////////////////////////////////////
;FILE: mod/weapon.inc ////////////////////////////////////////////////////
;//////////////////////////////////////////////////////////////////////////////

#define INFINITE_CLIP_SIZE 0

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------

; Weapons now work with Nuggets (like ObjectCreationLists) where each type of nugget
; does one thing, instead of Weapon doing all things itself.  So here are the Nuggets,
; and their syntax.
;  DamageFieldNugget                   	; A Nugget that lays down an area of damage that persists independantly
;    WeaponTemplateName = SmallFireFieldWeapon  
;    Duration = 3000                            
;  End
;  DamageNugget                        	; A basic Nugget that just does damage
;    Damage        = 1      		;Damage for a normal hit    
;    Radius        = 0.0    		;Radius of damage
;    DelayTime     = 0      		;How long from hit till the damage is applied
;    DamageType    = SLASH  		;Used to cross reference with victim's armor to determine if hurt
;    DamageFXType  = SWORD_SLASH  	;used to cross with their DamageFX listing to determine what effect to play
;    DeathType     = NORMAL 		;Used as index to their Death Modules to determine which one to play
;  End
;  MetaImpactNugget                    	; A Nugget that throws things back with force
;	 HeroResist	= .75		;only knocks heroes down 75% of the time
;    ShockWaveAmount   	= 50.0
;    ShockWaveRadius   	= 10.0
;    ShockWaveArc      	= 90 		; in degrees to each side 180 is full circle
;    ShockWaveTaperOff	= 1.0
;    ShockWaveSpeed    	= 0.0
;    ShockWaveZMult    	= 1.0
;    InvertShockWave 	= Yes		; Pull instead of push
;  End
;  ProjectileNugget                    	; A Nugget that creates an Object and sends it to the target with a Warhead
;    ProjectileTemplateName = GimliAxeProjectile
;    WarheadTemplateName = RohanGimliAxeThrownWarhead
;  End
;  WeaponOCLNugget						; A Nugget that should only be used for the rarest of super special weapons.  I better not catch a Fire Field in here.
;    WeaponOCLName = OCL_SuperComplicatedFivePartMovingDeathBlossom
;  End
;  AttributeModifierNugget
;    AttributeModifier = WitchKingMorgulBladeEffect
;    DamageFXType = SWORD_SLASH  ;used to cross with their DamageFX listing to determine what effect to play
;  End
;  StealMoneyNugget
;    AmountStolenPerAttack = 3.14
;  End