// mod/attributemodifier.inc
//
// A ModifierList is a set of bonuses that can be given as a package.  You can't ever be given the same list
// twice at the same time, but you can have two different lists that have the same effect.
//
// Category = 
//	LEADERSHIP, 
//	FORMATION, 
//	SPELL, 
//	WEAPON, 
//	STRUCTURE, 
//	LEVEL, 
//	BUFF, 
//	DEBUFF, 
//	STUN, 
//	INNATE_ARMOR,			// Used for the Create-a-Hero's permanent armor attribute.
//	INNATE_DAMAGEMULT		// Used for the Create-a-Hero's permanent damage multiplier attribute.
//  INNATE_VISION			// Used for the Create-a-Hero's permanent vision range attribute.
//  INNATE_AUTOHEAL			// Used for the Create-a-Hero's permanent auto-heal attribute.
//  INNATE_HEALTH			// Used for the Create-a-Hero's permanent health attribute.
//	The reason you have this bonus.  So things can affect all Leadership bonuses or dispel all spell effects
//
// In general, Additive bonuses should be things like 20% to give a bonus, and Multiplicitive bonuses should be things like 120%.
// Modifier = 
//	ARMOR,				// Additive.  The armor coefficients in Armor.ini go first to multiply the damage.  Then all of these are added together, capped at GameData's AttributeModifierArmorMaxBonus protection, and then the damage is multiplied by it again.
//	DAMAGE_ADD,			// Additive.  'Base' damage gets increased by this before hitting the DamageMult.
//	DAMAGE_MULT,			// Multiplicitive.  Then after DamageAdd, the damage is multiplied by all of these.
//	RESIST_FEAR,			// Additive.  Sum of these is a saving throw against fear (FEAR, DOOM, UNCONTROLLABLE_FEAR)
//	RESIST_TERROR,			// Additive.  Sum of these is a saving throw against terror (TERROR)
//	EXPERIENCE,			// Multiplicitive.  Experience gained multiplied by this, will compound in multiple bonuses
//	RANGE,				// Additive.  Sum of these added to max range.  20% and 10% makes range 130% normal.  (You probably want a vision range boost for targeting too.)
//	SPEED,				// Multiplicitive.  Multiply your speed by each of these numbers in turn.
//	CRUSH_DECELERATE,		// Multiplicitive.  The percentage you slow down when crushing gets multiplied by each of these.
//	RESIST_KNOCKBACK,		// Additive.  Sum of these is saving through against knockback.
//	SPELL_DAMAGE,			// Multiplicitive.  Just like DamageMult bonus, but only applies if damage type is Magic.  REPLACES DamageMult bonus.
//	RECHARGE_TIME,			// Multiplicitive.  Recharge time for all special powers multiplied by these.  Time is figured at the moment power is used, so this has no effect if gained or lost while power is recharging.
//	PRODUCTION,			// Multiplicitive.  Production speed for units and money amount produced by supply centers or money generators multiplied by these.  Again, time is computed at moment production starts.
//	HEALTH,				// Additive.  The moment you get this upgrade, this many hitpoints are added to both your max and current hitpoint scores.
//	HEALTH_MULT,			// Multiplicitive.  Multiply your hitpoints by this value. 
//	VISION,				// Additive.  Sum of these is added to vision range, which is used for targeting.
//	BOUNTY_PERCENTAGE		// Multiplicitive.  Multiply your (kill) bounty by this value.
//	MIN_CRUSH_VELOCITY_PERCENTAGE	//
//	AUTO_HEAL,			// Additive. Sum of these is added to the AutoHeal value.
//	SHROUD_CLEARING,		// Additive.  Sum of these is the % bonus to the range at which you clear fog and shroud
//	RATE_OF_FIRE,			// Multiplicitive.
//	DAMAGE_STRUCTURE_BOUNTY_ADD	// Additive.  Sum of these is added to your treasury per damage event done to a structure
//	COMMAND_POINT_BONUS		// Additive. Operates on the command point bonus.
//	CRUSHABLE_LEVEL			// Additive.  Adds the specified crushable level
//	CRUSHED_DECELERATE		// Multiplicitive.  The percentage that things crushing you slow
//	INVULNERABLE			// Currently, value does nothing (but one is required), the list of damage types after the value indicates what unit is invulnerable to
//
//	What is actually affected
//
// Duration = 1000
//	If self expiring effect, msec it lasts for

//	FX = FX_Name
//	use this to make a particle FX or tint for the attribute modifier
