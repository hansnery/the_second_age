----------------------------------------------------------------------
------------------------- 2.02 Helper Functions ----------------------
----------------------------------------------------------------------

verbosity = 0

---
-- GetObjString()
-- Converts the output of ObjectDescription(x) to a key that can be retrieved from globals()
--
function GetObjString(objDesc)
	local charMatch = 0

	for i = 1, strlen(objDesc) do
		local c = strsub(objDesc, i,i)
		if c == '[' then
			charMatch = i -1
			break
		end
	end

	local displ = tonumber(strsub(objDesc, 8, charMatch))

	return "ObjID#" .. format("%08x", displ)
end

---
-- GetScriptTeamName()
-- Converts a plain team name to the format used by map scripts and ExecuteAction
-- Example input: teamPlayer_1
-- Example output: Player_1/teamPlayer_1
--
function GetScriptTeamName(obj)
	return gsub(ObjectTeamName(obj),"team","") .. "/" .. ObjectTeamName(obj)
end

---
-- TransferObjectToOtherObjectTeam()
-- Transfers obj to the team of obj2
--
function TransferObjectToOtherObjectTeam(obj, obj2)
	if verbosity == 1 then 
		ExecuteAction("DISPLAY_TEXT", "Transferring shadow from " .. GetScriptTeamName(obj) .. " to " .. GetScriptTeamName(obj2)) 
	end

    ExecuteAction("UNIT_SET_TEAM", obj, GetScriptTeamName(obj2))
end

---
-- InitializeQueue() - AddToQueue() - QueuePop() - QueueIsEmpty()
-- Implements a simple FIFO queue (First-In-First-Out)
--
function InitializeQueue()
	return {first = 0, last = -1}
end
function AddToQueue(queue, value)
	local last = queue.last + 1
	queue.last = last
	queue[last] = value
end
function QueuePop(queue)
	local first = queue.first
	if first > queue.last then 
		return nil
	end
	local value = queue[first]
	queue[first] = nil        -- to allow garbage collection
	queue.first = first + 1
	if value == nil then
		return QueuePop(queue)
	end
	return value
end
function QueueIsEmpty(queue)
	if queue.first > queue.last then 
		return true
	end
	return false
end

---
-- Cleans a queue of leading nil objectss
--
function CleanQueue(queue)
	if QueueIsEmpty(queue) then return end

	local howManyLeadingNils = 0
	for i = queue.first, queue.last do 
		if queue[i] == nil then
			howManyLeadingNils = howManyLeadingNils + 1
		else
			break
		end
	end
	queue.first = queue.first + howManyLeadingNils
end

function MakeVarLabel(prefix, suffix, obj)
	return prefix .. ObjectTeamName(obj) .. suffix
end

---
-- AddToGlobalQueue()
-- Wrapper that accesses a global queue,
-- and adds an element into it. 
--
function AddToGlobalQueue(queueLabel, obj)
	local queue = getglobal(queueLabel)

	if queue == nil then
		queue = InitializeQueue()
	end

	AddToQueue(queue, obj)
	setglobal(queueLabel, queue)
end

---
-- PopFromGlobalQueue()
-- Wrapper that accesses a global queue,
-- and retrieves + removes the oldest element from it. 
--
function PopFromGlobalQueue(fortFlagQueueLabel)
	local fortFlagQueue = getglobal(fortFlagQueueLabel)

	if fortFlagQueue ~= nil then
		local value = QueuePop(fortFlagQueue)
		setglobal(fortFlagQueueLabel, fortFlagQueue)
		return value
	end
	return nil
end

----------------------------------------------------------------------


-- define lua functions 
function NoOp(self, source)
end


function LuaTickerCreate(self)
	ObjectDoSpecialPower(self, "SpecialAbilityTickerTick")
end

-- This function executes every so often in a MP game
-- You can add additional logic you wish to execute periodically here
function TickerTock(self)
	FortressDiscountTick(self)
end
function TickerFire(self)
	ObjectDoSpecialPower(self, "SpecialAbilityTickerTick")
end

function kill(self) -- Kill unit self.
	ExecuteAction("NAMED_KILL", self);
end

function RadiatePhialFear( self )
	ObjectBroadcastEventToEnemies( self, "BeAfraidOfPhial", 75 )
end

function RadiateUncontrollableFear( self )
	ObjectBroadcastEventToEnemies( self, "BeUncontrollablyAfraid", 350 )
end

-- ;;,;;
function RadiateUncontrollableFearBoromir( self )
	ObjectBroadcastEventToEnemies( self, "BeUncontrollablyAfraid", 225 ) --300
end

function RadiateGateDamageFear(self)
	ObjectBroadcastEventToAllies(self, "BeAfraidOfGateDamaged", 200)
end

function RadiateBalrogFear(self)
	ObjectBroadcastEventToEnemies(self, "BeAfraidOfBalrog", 180)
end

function OnMumakilCreated(self)
	ObjectHideSubObjectPermanently( self, "Houda", true )
	ObjectHideSubObjectPermanently( self, "Houda01", true )
end

function OnTrollCreated(self)
	ObjectHideSubObjectPermanently( self, "Trunk01", true )
	ObjectGrantUpgrade( self, "Upgrade_SwitchToRockThrowing" )
end

function OnCreepTrollCreated(self)
	ObjectHideSubObjectPermanently( self, "Trunk01", true )
	ObjectHideSubObjectPermanently( self, "ROCK", true )
end

function OnCaptureFlagGenericEvent(self,data)
	local str = ObjectCapturingObjectPlayerSide(self)
	if str == nil then
		str = ObjectPlayerSide(self)
	end


	ObjectHideSubObjectPermanently( self, "FLAG_ISENGARD", true)
	ObjectHideSubObjectPermanently( self, "FLAG_MORDOR", true)
	ObjectHideSubObjectPermanently( self, "FLAG_WILD", true)
	ObjectHideSubObjectPermanently( self, "FLAG_MEN", true)
	ObjectHideSubObjectPermanently( self, "FLAG_ELVES", true)
	ObjectHideSubObjectPermanently( self, "FLAG_DWARVES", true)
	ObjectHideSubObjectPermanently( self, "FLAG_ANGMAR", true)

	if str == "Isengard" then
		ObjectHideSubObjectPermanently( self, "FLAG_ISENGARD", false)
	elseif str == "Mordor" then
		ObjectHideSubObjectPermanently( self, "FLAG_MORDOR", false)
	elseif str == "Men" then
		ObjectHideSubObjectPermanently( self, "FLAG_MEN", false)
	elseif str == "Arnor" then	-- Added for v2.3 ;;,;;
		ObjectHideSubObjectPermanently( self, "FLAG_MEN", false)
	elseif str == "Dwarves" then
		ObjectHideSubObjectPermanently( self, "FLAG_DWARVES", false)
	elseif str == "Elves" then
		ObjectHideSubObjectPermanently( self, "FLAG_ELVES", false)
	elseif str == "Wild" then
		ObjectHideSubObjectPermanently( self, "FLAG_WILD", false)
	elseif str == "Angmar" then
		ObjectHideSubObjectPermanently( self, "FLAG_ANGMAR", false)
	else
		ObjectHideSubObjectPermanently( self, "FLAG_NEUTRAL", false)
	end
end

function OnTrollGenericEvent(self,data)

	local str = tostring( data )

	if str == "show_rock" then
		ObjectHideSubObjectPermanently( self, "ROCK", false )
	elseif str == "hide_rock" then
		ObjectHideSubObjectPermanently( self, "ROCK", true )
	end
end

function OnEntCreated(self)
	--ObjectShowSubObjectPermanently( self, "ROCK", true )
	ObjectGrantUpgrade( self, "Upgrade_SwitchToRockThrowing" )
end

function OnMountainGiantCreated(self)
	--ObjectHideSubObjectPermanently( self, "ROCK", true )
	ObjectGrantUpgrade( self, "Upgrade_SwitchToRockThrowing" )
end

function OnMountainGiantGenericEvent(self)
	
	local str = tostring( data )

	if str == "show_rock" then
		ObjectHideSubObjectPermanently( self, "ROCK", false )
	elseif str == "hide_rock" then
		ObjectHideSubObjectPermanently( self, "ROCK", true )
	end
end

function GoIntoRampage(self)
	ObjectEnterRampageState(self)
		
	--Broadcast fear to surrounding unit(if we actually rampaged)
	if ObjectTestModelCondition(self, "WEAPONSET_RAMPAGE") then
		ObjectBroadcastEventToUnits(self, "BeAfraidOfRampage", 250)
	end
end

function MakeMeAlert(self)
	ObjectEnterAlertState(self)
end

function BeEnraged(self)
	--Broadcast enraged to surrounding units.
	ObjectBroadcastEventToAllies(self, "BeingEnraged", 500)
end

function BecomeEnraged(self)
	ObjectSetEnragedState(self, true)
end

function StopEnraged(self)
	ObjectSetEnragedState(self, false)
end

function BecomeUncontrollablyAfraid(self, other)
	if not ObjectTestCanSufferFear(self) then
		return
	end

	ObjectEnterUncontrollableCowerState(self, other)
end

function BecomeAfraidOfRampage(self, other)
	if not ObjectTestCanSufferFear(self) then
		return
	end

	ObjectEnterCowerState(self, other)
end

function BecomeAfraidOfBalrog(self, other)
	if not ObjectTestCanSufferFear(self) then
		return
	end

	ObjectEnterCowerState(self, other)
end

function RadiateTerror(self, other)
	ObjectBroadcastEventToEnemies(self, "BeTerrified", 180)
end
	
function RadiateTerrorEx(self, other, terrorRange)
	ObjectBroadcastEventToEnemies(self, "BeTerrified", terrorRange)
end

function BecomeTerrified(self, other)
	ObjectEnterRunAwayPanicState(self, other)
end

function BecomeAfraidOfGateDamaged(self, other)
	if not ObjectTestCanSufferFear(self) then
		return
	end

	ObjectEnterCowerState(self,other)
end


function ChantForUnit(self) -- Used by units to broadcast the chant event to their own side.
	ObjectBroadcastEventToAllies(self, "BeginChanting", 9999)
end

function StopChantForUnit(self) -- Used by units to stop the chant event to their own side.
	ObjectBroadcastEventToAllies(self, "StopChanting", 9999)
end

function BeginCheeringForGrond(self)
	ObjectSetChanting(self, true)
end

function StopCheeringForGrond(self)
	ObjectSetChanting(self, false)
end

function OnMordorArcherCreated(self)
	ObjectHideSubObjectPermanently( self, "ARROWFIRE", true )
end

function OnMordorFighterCreated(self)
	ObjectHideSubObjectPermanently( self, "FORGED_BLADE", true )
	ObjectHideSubObjectPermanently( self, "FORGED_BLADE2", true ) -- ;,;
	ObjectHideSubObjectPermanently( self, "FORGED_BLADES", true )
end

---
-- Every other newly created orc spawns a CP shadow.
-- That is, we distingiush between "odd" and "even" orcs.
-- odd orcs give 2CP and even orcs give 1CP -> resulting in 30CP per horde.
--
function OnMordorFighterCreatedMP(self)
	OnMordorFighterCreated(self)
	
	local oddEvenTrackerLabel = "OrcCreate202_" .. ObjectTeamName(self) .. "oddeven"
	local oddEvenTracker = getglobal(oddEvenTrackerLabel)

	if oddEvenTracker == nil then
		oddEvenTracker = 0
	end

	if oddEvenTracker == 1 then
		ObjectGrantUpgrade(self, "Upgrade_TriggerOrcCPShadow")
		setglobal(oddEvenTrackerLabel, 0)

		local orcListLabel = "OrcCreate202_" .. ObjectTeamName(self) .. "recorc"
		local orcList = getglobal(orcListLabel)
		if orcList == nil then
			orcList = InitializeQueue()
		end

		AddToQueue(orcList, self)
		setglobal(orcListLabel, orcList)
	else
		setglobal(oddEvenTrackerLabel, 1)
	end
end

---
-- When a CP shadow is created, it finds out which orc created it and attaches itself.
-- This allows the orc to command its shadow (if it exists) to perform actions, for instance self destruct.
--
function MordorFighterCPShadowCreated(self)
	local orcListLabel = "OrcCreate202_" .. ObjectTeamName(self) .. "recorc"
	local orcList = getglobal(orcListLabel)

	if orcList ~= nil then
		local value = QueuePop(orcList)

		local objstr = GetObjString(ObjectDescription(value))
		local foundobj = getglobal(objstr)

		if foundobj ~= nil then
			if verbosity == 1 then ExecuteAction("DISPLAY_TEXT", "Attached shadow to " .. ObjectDescription(foundobj)) end
			foundobj["cpShadow"] = self
			setglobal(objstr, foundobj)
		end

		setglobal(orcListLabel, orcList)
	end
end

function OrcConvertCpShadow(obj)
	local myCpShadow = obj["cpShadow"]
	if myCpShadow ~= nil then
		TransferObjectToOtherObjectTeam(myCpShadow, obj)
	end
end

function SarumanCastedDominate(self)
	-- also convert CP shadow for all allied orcs
	for k,v in globals() do
		if strfind(k,"ObjID") and ObjectTeamName(self) == ObjectTeamName(v) and ObjectTemplateName(v) == "MordorFighter" then
			OrcConvertCpShadow(v)
		end
	end
end

function MordorFighterBecomeUncontrollablyAfraid(self,other)
	local wasAfraid = ObjectTestModelCondition(self, "EMOTION_AFRAID")

	BecomeUncontrollablyAfraid(self,other)                 -- Call base function appropriate to many unit types
	
	-- Play unit-specific sound, but only when first entering state (not every time troll sends out fear message!)
	-- BecomeAfraidOfTroll may fail, don't play sound if we didn't enter fear state
		if ( not wasAfraid ) and ObjectTestModelCondition(self, "EMOTION_AFRAID") then
		ObjectPlaySound(self, "MordorFighterEntFear") 
	end
end

function MordorFighterBecomeAfraidOfPhial(self,other)
	local wasAfraid = ObjectTestModelCondition(self, "EMOTION_AFRAID")

	BecomeUncontrollablyAfraid(self,other)
	-- BecomeAfraidOfTroll(self,other)                 -- Call base function appropriate to many unit types
	
	-- Play unit-specific sound, but only when first entering state (not every time troll sends out fear message!)
	-- BecomeAfraidOfTroll may fail, don't play sound if we didn't enter fear state
--		if ( not wasAfraid ) and ObjectTestModelCondition(self, "EMOTION_AFRAID") then
--			ObjectPlaySound(self, "MordorFighterEntFear") 
--		end
end

function OnMordorCorsairCreated(self)
	ObjectHideSubObjectPermanently( self, "Forged_Blade", true )
	ObjectHideSubObjectPermanently( self, "Forged_Blade01", true )
end

function WildInfantryBecomeAfraidOfPhial(self,other)
	local wasAfraid = ObjectTestModelCondition(self, "EMOTION_AFRAID")
	BecomeUncontrollablyAfraid(self,other)
end


function ShelobBecomeAfraidOfPhial(self,other)
	local wasAfraid = ObjectTestModelCondition(self, "EMOTION_AFRAID")

	BecomeUncontrollablyAfraid(self,other)
	-- BecomeAfraidOfTroll(self,other)                 -- Call base function appropriate to many unit types
	
	-- Play unit-specific sound, but only when first entering state (not every time troll sends out fear message!)
	-- BecomeAfraidOfTroll may fail, don't play sound if we didn't enter fear state
--		if ( not wasAfraid ) and ObjectTestModelCondition(self, "EMOTION_AFRAID") then
--			ObjectPlaySound(self, "MordorFighterEntFear") 
--		end
end

function OnInfantryBannerCreated(self)
	ObjectHideSubObjectPermanently( self, "Glow", true )
end

function OnCavalryCreated(self)
	ObjectHideSubObjectPermanently( self, "Glow", true )
end

function OnGondorFighterCreated(self)
	ObjectHideSubObjectPermanently( self, "Forged_Blade", true )
	ObjectHideSubObjectPermanently( self, "Hammer1", true )
	ObjectHideSubObjectPermanently( self, "Glow", true )
	ObjectHideSubObjectPermanently( self, "Glow1", true )
end

function OnAragornCreated(self)
	ObjectHideSubObjectPermanently( self, "PLANE02", true )
end

function OnGondorArcherCreated(self)
	-- ObjectHideSubObjectPermanently( self, "arrow", true )		-- This gets hidden pending the art being fixed.  it is the pre-new-archer-firing-pattern arrow
	ObjectHideSubObjectPermanently( self, "FireArowTip", true ) -- This gets hidden because the Fire Arrow upgrade turns it on.
end

function DragonStrikeDragonCreated(self)
	ObjectForbidPlayerCommands( self, true )
end

function OnLegolasCreated(self)
	-- ObjectHideSubObjectPermanently( self, "arrow02", true )		-- This gets hidden pending the art being fixed.  it is the pre-new-archer-firing-pattern arrow
	-- ObjectHideSubObjectPermanently( self, "arrow", true )		-- This gets hidden pending the art being fixed.  it is the pre-new-archer-firing-pattern arrow
end

function OnRohanArcherCreated(self)
	ObjectHideSubObjectPermanently( self, "FireArowTip", true ) -- yes, it's a typo in the art.
	-- ObjectHideSubObjectPermanently( self, "ArrowNock", true )
	-- ObjectHideSubObjectPermanently( self, "arrow", true )
end

function GondorFighterBecomeAfraid(self, other)
	local wasAfraid = ObjectTestModelCondition(self, "EMOTION_AFRAID")

	-- An object has a 100% chance to become afraid.
	-- An object has a 66% chance to be feared, 33% chance to run away.
	if GetRandomNumber() <= 0.67 then 
		ObjectEnterFearState(self, other, false) -- become afraid of other.
	else --if GetRandomNumber() > 0.67 then
		ObjectEnterRunAwayPanicState(self, other) -- run away.

	end
	
	if ( not wasAfraid ) and ObjectTestModelCondition(self, "EMOTION_AFRAID") then
		ObjectPlaySound(self, "GondorSoldierScream")	
	end
	
end


function GondorFighterBecomeAfraidOfGateDamaged(self, other)
	local wasAfraid = ObjectTestModelCondition(self, "EMOTION_AFRAID")

	BecomeAfraidOfGateDamaged(self,other)                 -- Call base function appropriate to many unit types
	
	-- Play unit-specific sound, but only when first entering state (not every time troll sends out fear message!)
	-- BecomeAfraidOfGateDamaged may fail, don't play sound if we didn't enter fear state
	
	if ( not wasAfraid ) and ObjectTestModelCondition(self, "EMOTION_AFRAID") then
		ObjectPlaySound(self, "GondorSoldierScream")	
	end
end

function GondorFighterRecoverFromTerror(self)
	-- Add recovery sound
	ObjectPlaySound(self, "GondorSoldierRecoverFromTerror")
end

function SpyMoving(self, other)
	print(ObjectDescription(self).." spying movement of "..ObjectDescription(other));
end

--function GandalfConsiderUsingDefensePower(self, other, delay, amount)
--	-- Put up the shield if a big attack is coming and we have time to block it
--	if tonumber(delay) > 1 then
--		if tonumber(amount) >= 100 then
--			ObjectDoSpecialPower(self, "SpecialPowerShieldBubble")
--			return
--		end
--	end
--	
--	-- Or, if we are being hit and there are alot of guys arround, do our cool pushback power
--	if tonumber(ObjectCountNearbyEnemies(self, 50)) >= 4 then
--		ObjectDoSpecialPower(self, "SpecialPowerTelekeneticPush")
--		return
--	end
--end

-- Added for 2.0 from DC patch ;;,;; ;,; Removed
--function GandalfUseDefensePower(self, other, delay, amount)
--  ObjectDoSpecialPower(self, "SpecialPowerShieldBubble")
--end

function GandalfTriggerWizardBlast(self)
	ObjectCreateAndFireTempWeapon(self, "GandalfWizardBlast")
end

--function SarumanConsiderUsingDefensePower(self, other, delay, amount)
--	-- Put up the shield if a big attack is coming and we have time to block it
--E4	if tonumber(delay) > 1 then
--E4		if tonumber(amount) >= 25 then
--E4			ObjectDoSpecialPower(self, "SpecialPowerShieldBubble")
--E4			return
--E4		end
--E4	end
--	
--	-- Or, if we are being hit and there are alot of guys arround, do our cool pushback power
--	if tonumber(ObjectCountNearbyEnemies(self, 50)) >= 4 then
--		ObjectDoSpecialPower(self, "SpecialPowerTelekeneticPush")
--		return
--	end
--end

function BalrogTriggerBreatheFire(self)
	ObjectCreateAndFireTempWeapon(self, "MordorBalrogBreath")
end

function OnRohirrimCreated(self)
	ObjectHideSubObjectPermanently( self, "Forged_Blade", true )
	ObjectHideSubObjectPermanently( self, "SHIELD", true )
	ObjectHideSubObjectPermanently( self, "FireArowTip", true )
end

function OnSummonedRohirrimCreated(self)
	ObjectGrantUpgrade( self, "Upgrade_RohanHeavyArmorForRohirrim" ) -- ;,;
	ObjectGrantUpgrade( self, "Upgrade_RohanHorseShield" )
	ObjectHideSubObjectPermanently( self, "Forged_Blade", true )
	ObjectHideSubObjectPermanently( self, "FireArowTip", true ) -- ;,;
end

function OnSummonedMenofDaleCreated(self) -- ;,;
	ObjectGrantUpgrade( self, "Upgrade_DwarvenMithrilMail" )
	ObjectGrantUpgrade( self, "Upgrade_DwarvenFireArrows" )
end

-- function OnBattlewagonMenofDaleCreated(self) -- ;,;
--    ObjectGrantUpgrade( self, "Upgrade_DwarvenMithrilMail" )
--	-- ObjectGrantUpgrade( self, "Upgrade_DwarvenFireArrows" )  ;,; disabled fire arrows for v8.0.0
--	ObjectHideSubObjectPermanently( self, "FireArowTip", false ) -- ;,;
--	ObjectHideSubObjectPermanently( self, "ARMOR", false ) -- ;,;
-- end

function OnGondorCavalryCreated(self)
	ObjectHideSubObjectPermanently( self, "Forged_Blade", true )
	ObjectHideSubObjectPermanently( self, "sshield", true )
end

function OnDwarvenBattleWagonCreated(self)
	ObjectHideSubObjectPermanently( self, "dwarfHearth", true )
	ObjectHideSubObjectPermanently( self, "dwarfHearthFire", true )
	ObjectHideSubObjectPermanently( self, "Banner_L", true )
	ObjectHideSubObjectPermanently( self, "Glow", true )
end

function OnEvilMenBlackRiderCreated(self)
	-- @todo place appropriate functionality here
end

function OnBallistaCreated(self)
	ObjectHideSubObjectPermanently( self, "MinedArrow", true )
end

function OnCatapultCreated(self)
	ObjectHideSubObjectPermanently( self, "PROJECTILEROCK", true )
	ObjectHideSubObjectPermanently( self, "FIREPLANE", true )
end

function OnTrebuchetCreated(self)
	ObjectHideSubObjectPermanently( self, "FIREPLANE", true )
end

function OnTrollSlingCreated(self)
	ObjectHideSubObjectPermanently( self, "FORGED_BLADE", true )
end

function OnPorterCreated(self)
	ObjectHideSubObjectPermanently( self, "ARROWS", true )
	ObjectHideSubObjectPermanently( self, "BRAZIER", true )
	ObjectHideSubObjectPermanently( self, "BOWS", true )
	ObjectHideSubObjectPermanently( self, "TREBUCHET_FIRE", true )
	ObjectHideSubObjectPermanently( self, "SWORDS", true )
	ObjectHideSubObjectPermanently( self, "SHIELDS", true )
	ObjectHideSubObjectPermanently( self, "ARMOR", true )
	ObjectHideSubObjectPermanently( self, "BANNERS", true )
end

function OnEvilPorterCreated(self)
	ObjectHideSubObjectPermanently( self, "FIREAROWTIP", true )
	ObjectHideSubObjectPermanently( self, "FORGED_BLADE", true )
	ObjectHideSubObjectPermanently( self, "ARROW_UPGRADE", true )
	ObjectHideSubObjectPermanently( self, "ARMOR_UPGRADE", true )
	ObjectHideSubObjectPermanently( self, "GOLD", true )
	ObjectHideSubObjectPermanently( self, "SWORD_UPGRADES", true )

	PorterCreatedFortCheck(self)
end

function PorterList()
	local porters = {
		["MenPorter"] = true,
		["ElvenPorter"] = true,
		["DwarvenPorter"] = true,
		["IsengardPorter"] = true,
		["WildPorter"] = true,
		["MordorPorter"] = true,
		["AngmarPorter"] = true
	}
	return porters
end

function AllowBuildersToMakeFortAgain(self)
	local porters = PorterList()

	-- Loop over all builders belonging to my player
	for k,v in globals() do
		if strfind(k,"ObjID") and ObjectTeamName(self) == ObjectTeamName(v) and porters[ObjectTemplateName(v)] == true then
			ObjectGrantUpgrade(v, "Upgrade_User1")  -- allow builder to construct fort
		end
	end
end

function PorterCreatedFortCheck(self)
	local discounterQueueLabel = MakeVarLabel("FortDiscount202_", "DiscounterQueue", self)
	local discounterQueue = getglobal(discounterQueueLabel)

	if QueueIsEmpty(discounterQueue) then 
		ObjectGrantUpgrade(self, "Upgrade_User1")  -- allow builder to construct fort
	end
end

function OnPeasantCreated(self)
	ObjectHideSubObjectPermanently( self, "HELMET", true )
	ObjectHideSubObjectPermanently( self, "SWORD", true )
	ObjectHideSubObjectPermanently( self, "HAMMER", false )
	ObjectHideSubObjectPermanently( self, "FORGED_BLADE", true )
	ObjectHideSubObjectPermanently( self, "SHIELD", true )
	ObjectHideSubObjectPermanently( self, "Broom", true )
end

function OnMordorSauronCreated(self)
	ObjectHideSubObjectPermanently( self, "SHARD01", true )
	ObjectHideSubObjectPermanently( self, "SHARD02", true )
	ObjectHideSubObjectPermanently( self, "SHARD03", true )
	ObjectHideSubObjectPermanently( self, "SHARD04", true )
	ObjectHideSubObjectPermanently( self, "SHARD05", true )
	ObjectHideSubObjectPermanently( self, "SHARD06", true )
	ObjectHideSubObjectPermanently( self, "SHARD07", true )
	ObjectHideSubObjectPermanently( self, "SHARD08", true )
	ObjectHideSubObjectPermanently( self, "SHARD09", true )
	ObjectHideSubObjectPermanently( self, "SHARD10", true )
	ObjectHideSubObjectPermanently( self, "SHARD11", true )
	ObjectHideSubObjectPermanently( self, "SHARD12", true )
	ObjectHideSubObjectPermanently( self, "SHARD13", true )
	ObjectHideSubObjectPermanently( self, "SHARD14", true )
	ObjectHideSubObjectPermanently( self, "SHARD15", true )
	ObjectHideSubObjectPermanently( self, "SHARD16", true )
	ObjectHideSubObjectPermanently( self, "SHARD17", true )
	ObjectHideSubObjectPermanently( self, "SHARD18", true )
	ObjectHideSubObjectPermanently( self, "SHARD19", true )
	ObjectHideSubObjectPermanently( self, "SHARD20", true )
	ObjectDoSpecialPower( self, "SpecialAbilitySauronDarkness" ) -- ;,;
end

function OnElvenWarriorCreated(self)
	ObjectHideSubObject( self, "ARROW", true )
	ObjectHideSubObject( self, "ARROWNOCK", true )
	ObjectHideSubObjectPermanently( self, "Forged_Blade", true )
	ObjectHideSubObjectPermanently( self, "FIREAROWTIP", true )
end

function OnIsengardFighterCreated(self)
	ObjectHideSubObjectPermanently( self, "Forged_Blade", true )
	ObjectHideSubObjectPermanently( self, "Glow", true )
end

function OnIsengardWildmanCreated(self)
	ObjectHideSubObjectPermanently( self, "Forged_Blade", true )
	ObjectHideSubObjectPermanently( self, "Torch", true )
	ObjectHideSubObjectPermanently( self, "FireArowTip", true )
end

function OnAngmarHillmanCreated(self) --;,;
	ObjectHideSubObjectPermanently( self, "FireArowTip", true )
        ObjectHideSubObjectPermanently( self, "WEAPON01", true )
        ObjectHideSubObjectPermanently( self, "WEAPON02", true )
        ObjectHideSubObjectPermanently( self, "WEAPON03", true )

        local WEAPON = GetRandomNumber()

        if WEAPON <= 0.33 then
            ObjectHideSubObjectPermanently( self, "WEAPON01", false )
        elseif WEAPON <= 0.66 then
            ObjectHideSubObjectPermanently( self, "WEAPON02", false )
        else
            ObjectHideSubObjectPermanently( self, "WEAPON03", false )
        end
end

function OnWildSpiderRiderCreated(self)
	ObjectHideSubObjectPermanently( self, "Forged_Blade", true )
	ObjectHideSubObjectPermanently( self, "FIREAROWTIP", true )
	ObjectHideSubObject( self, "ARROWNOCK", true )
end

function OnHaradrimArcherCreated(self)
	ObjectHideSubObjectPermanently( self, "FireArowTip", true )
	ObjectHideSubObject( self, "ArrowNock", true )
end

function OnIsengardArcherCreated(self)
	ObjectHideSubObject( self, "ARROWNOCK", true )
	ObjectHideSubObjectPermanently( self, "FIREAROWTIP", true )
end

function OnWildGoblinArcherCreated(self)
	ObjectHideSubObjectPermanently( self, "FIREAROWTIP", true )
end

function OnGarrisonableCreated(self)
	ObjectHideSubObjectPermanently( self, "GARRISON01", true )
	ObjectHideSubObjectPermanently( self, "GARRISON02", true )
end
function OnDwarvenGuardianCreated(self)
	ObjectHideSubObjectPermanently( self, "Forged_Blade", true )
	ObjectHideSubObjectPermanently( self, "Hammer1", true )
end

function CreateAHeroHideEverything(self)
	ObjectHideSubObjectPermanently( self, "SWORD", true )
	ObjectHideSubObjectPermanently( self, "BOW", true )
	ObjectHideSubObjectPermanently( self, "BOW_03", true )
	ObjectHideSubObjectPermanently( self, "BOW_04", true )
	ObjectHideSubObjectPermanently( self, "BOW_05", true )
	ObjectHideSubObjectPermanently( self, "TRUNK01", true )
	ObjectHideSubObjectPermanently( self, "STAFF_LIGHT", true )
	ObjectHideSubObjectPermanently( self, "OBJECT01", true )
	
	ObjectHideSubObjectPermanently( self, "SHIELD01", true )
	ObjectHideSubObjectPermanently( self, "SHIELD_01", true )
	ObjectHideSubObjectPermanently( self, "SPEAR", true )
	ObjectHideSubObjectPermanently( self, "SHIELD_B", true )
	ObjectHideSubObjectPermanently( self, "SHIELD_C", true )
	ObjectHideSubObjectPermanently( self, "SHIELD_D", true )
	ObjectHideSubObjectPermanently( self, "B_SHIELD", true )
	ObjectHideSubObjectPermanently( self, "WEAPON_A", true )
	ObjectHideSubObjectPermanently( self, "WEAPON_B", true )
	ObjectHideSubObjectPermanently( self, "WEAPON_C", true )
	ObjectHideSubObjectPermanently( self, "WEAPON_D", true )
	
	ObjectHideSubObjectPermanently( self, "AXE02", true )

	ObjectHideSubObjectPermanently( self, "AxeWeapon", true )
	ObjectHideSubObjectPermanently( self, "Belthronding", true )
	-- ObjectHideSubObjectPermanently( self, "Mithlondrecurve", true )
	ObjectHideSubObjectPermanently( self, "Dwarf_Axe01", true )
	ObjectHideSubObjectPermanently( self, "FireBrand", true )
	ObjectHideSubObjectPermanently( self, "FireBrand_SM", true )
	ObjectHideSubObjectPermanently( self, "FireBrand_FX01", true )
	ObjectHideSubObjectPermanently( self, "FireBrand_FX02", true )
	ObjectHideSubObjectPermanently( self, "Gurthang", true )
	ObjectHideSubObjectPermanently( self, "Gurthang_SM", true )
	ObjectHideSubObjectPermanently( self, "HeroOfTheWestShield", true )
	ObjectHideSubObjectPermanently( self, "HeroOfTheWestShield_SM", true )
	ObjectHideSubObjectPermanently( self, "MithlondBow", true )
	ObjectHideSubObjectPermanently( self, "TrollBane", true )
	ObjectHideSubObjectPermanently( self, "TrollBane_SM", true )
	ObjectHideSubObjectPermanently( self, "TrollBane_FX01", true )
	ObjectHideSubObjectPermanently( self, "TrollBane_FX02", true )
	ObjectHideSubObjectPermanently( self, "TrollMace", true )
	ObjectHideSubObjectPermanently( self, "TrollSword", true )
	ObjectHideSubObjectPermanently( self, "WestronSword", true )
	ObjectHideSubObjectPermanently( self, "WestronSword", true )
	ObjectHideSubObjectPermanently( self, "WestronSword_SM", true )
	ObjectHideSubObjectPermanently( self, "WizardStaff01", true )
	ObjectHideSubObjectPermanently( self, "WizStaff01_FX01", true )
	ObjectHideSubObjectPermanently( self, "WizStaff01_FX2", true )
	ObjectHideSubObjectPermanently( self, "WizStaff01_FX3", true )
	ObjectHideSubObjectPermanently( self, "WizStaff01_FX4", true )
	ObjectHideSubObjectPermanently( self, "WizardStaff02", true )
	ObjectHideSubObjectPermanently( self, "WizStaff02_FX1", true )
	ObjectHideSubObjectPermanently( self, "WizardStaff03", true )
	ObjectHideSubObjectPermanently( self, "WizStaff03_FX01", true )
	ObjectHideSubObjectPermanently( self, "WizStaff03_FX02", true )
	ObjectHideSubObjectPermanently( self, "WizardStaff04", true )
	ObjectHideSubObjectPermanently( self, "WizStaff04_FX01", true )
	ObjectHideSubObjectPermanently( self, "WizStaff04_FX02", true )
	ObjectHideSubObjectPermanently( self, "WizStaff04_FX03", true )
	ObjectHideSubObjectPermanently( self, "WizStaff04_FX04", true )
	ObjectHideSubObjectPermanently( self, "WizStaff04_FX05", true )
	ObjectHideSubObjectPermanently( self, "WizStaff04_FX06", true )
	ObjectHideSubObjectPermanently( self, "WizStaff04_FX07", true )
	ObjectHideSubObjectPermanently( self, "WizardSword", true )
	ObjectHideSubObjectPermanently( self, "CMSword01", true )
	ObjectHideSubObjectPermanently( self, "CMSword02", true )
	ObjectHideSubObjectPermanently( self, "CHEST_00", true )	
	ObjectHideSubObjectPermanently( self, "CHEST_01", true )	
	ObjectHideSubObjectPermanently( self, "CHEST_02", true )	
	ObjectHideSubObjectPermanently( self, "BOOT_00", true )
	ObjectHideSubObjectPermanently( self, "BOOT_01", true )
	ObjectHideSubObjectPermanently( self, "BOOT_02", true )
	ObjectHideSubObjectPermanently( self, "BOOT_03", true )
	ObjectHideSubObjectPermanently( self, "BOOT_04", true )
	ObjectHideSubObjectPermanently( self, "BOOT_05", true )
	ObjectHideSubObjectPermanently( self, "BOOT_06", true )
	ObjectHideSubObjectPermanently( self, "SHLD_00", true )
	ObjectHideSubObjectPermanently( self, "SHLD_01", true )
	ObjectHideSubObjectPermanently( self, "SHLD_02", true )
	ObjectHideSubObjectPermanently( self, "SHLD_03", true )
	ObjectHideSubObjectPermanently( self, "SHLD_04", true )
	ObjectHideSubObjectPermanently( self, "SLDR_00", true )
	ObjectHideSubObjectPermanently( self, "SLDR_01", true )
	ObjectHideSubObjectPermanently( self, "SLDR_02", true )
	ObjectHideSubObjectPermanently( self, "SLDR_03", true )
	ObjectHideSubObjectPermanently( self, "SLDR_04", true )
	ObjectHideSubObjectPermanently( self, "SLDR_05", true )
	ObjectHideSubObjectPermanently( self, "SLDR_06", true )
	ObjectHideSubObjectPermanently( self, "Shield_1OG", true )
	ObjectHideSubObjectPermanently( self, "Shield_2OG", true )
	ObjectHideSubObjectPermanently( self, "HAIR_00", true )
	ObjectHideSubObjectPermanently( self, "HAIR_01", true )
	ObjectHideSubObjectPermanently( self, "HLMT_00", true )
	ObjectHideSubObjectPermanently( self, "HLMT_01", true )
	ObjectHideSubObjectPermanently( self, "HLMT_02", true )
	ObjectHideSubObjectPermanently( self, "HLMT_03", true )
	ObjectHideSubObjectPermanently( self, "HLMT_04", true )
	ObjectHideSubObjectPermanently( self, "HLMT_05", true )
	ObjectHideSubObjectPermanently( self, "HLMT_06", true )
	ObjectHideSubObjectPermanently( self, "HLMT_07", true )
	ObjectHideSubObjectPermanently( self, "HLMT_07_LOD1", true )
	ObjectHideSubObjectPermanently( self, "HLMT_08", true )
	ObjectHideSubObjectPermanently( self, "HLMT_09", true )
	ObjectHideSubObjectPermanently( self, "GNLT_00", true )
	ObjectHideSubObjectPermanently( self, "GNLT_01", true )
	ObjectHideSubObjectPermanently( self, "GNLT_02", true )
	ObjectHideSubObjectPermanently( self, "GNLT_03", true )
	ObjectHideSubObjectPermanently( self, "GNLT_04", true )
	ObjectHideSubObjectPermanently( self, "GNLT_05", true )
	ObjectHideSubObjectPermanently( self, "GNLT_06", true )
	ObjectHideSubObjectPermanently( self, "GNLT_07", true )
	ObjectHideSubObjectPermanently( self, "GNLT_08", true )
	ObjectHideSubObjectPermanently( self, "GHLT_08", true )
	ObjectHideSubObjectPermanently( self, "GNLT_09", true )
	ObjectHideSubObjectPermanently( self, "GNLT_09_LOD1", true )
	ObjectHideSubObjectPermanently( self, "GNLT_10", true )
	ObjectHideSubObjectPermanently( self, "SPR_01", true )
	ObjectHideSubObjectPermanently( self, "PAXE_01", true )
	ObjectHideSubObjectPermanently( self, "PAXE_01_LOD1", true )
	ObjectHideSubObjectPermanently( self, "SWRD_01", true )
	ObjectHideSubObjectPermanently( self, "SWRD_02", true )
	ObjectHideSubObjectPermanently( self, "SWRD_03", true )
	ObjectHideSubObjectPermanently( self, "SWRD_04", true )
	ObjectHideSubObjectPermanently( self, "SWRD_05", true )
	ObjectHideSubObjectPermanently( self, "SWD_01", true )
	ObjectHideSubObjectPermanently( self, "SWD_02", true )
	ObjectHideSubObjectPermanently( self, "SWD_03", true )
	ObjectHideSubObjectPermanently( self, "SWD_04", true )
	ObjectHideSubObjectPermanently( self, "STFF_05", true )
	ObjectHideSubObjectPermanently( self, "STFF_06", true )
	ObjectHideSubObjectPermanently( self, "objSLDR_01", true )
	ObjectHideSubObjectPermanently( self, "objSLDR_02", true )
	ObjectHideSubObjectPermanently( self, "objSLDR_03", true )
	ObjectHideSubObjectPermanently( self, "objHLMT_01", true )
	ObjectHideSubObjectPermanently( self, "objHLMT_02", true )
	ObjectHideSubObjectPermanently( self, "objHLMT_03", true )
	ObjectHideSubObjectPermanently( self, "objHLMT_04", true )	
	ObjectHideSubObjectPermanently( self, "Uruk_Sword_01", true )
	ObjectHideSubObjectPermanently( self, "Uruk_Sword_02", true )
	ObjectHideSubObjectPermanently( self, "Uruk_Sword_03", true )
	ObjectHideSubObjectPermanently( self, "TrollTree", true )
	ObjectHideSubObjectPermanently( self, "TrollHammer", true )
	ObjectHideSubObjectPermanently( self, "CLUB_01", true )
	ObjectHideSubObjectPermanently( self, "CLUB_02", true )
	ObjectHideSubObjectPermanently( self, "CLUB_03", true )
	ObjectHideSubObjectPermanently( self, "HMR_01", true )
	ObjectHideSubObjectPermanently( self, "HMR_02", true )
	ObjectHideSubObjectPermanently( self, "HMR_03", true )
	ObjectHideSubObjectPermanently( self, "HMR_04", true )
	ObjectHideSubObjectPermanently( self, "AXE_01", true )
	ObjectHideSubObjectPermanently( self, "AXE_02", true )
	ObjectHideSubObjectPermanently( self, "AXE_03", true )
	ObjectHideSubObjectPermanently( self, "BARREL", true )
	ObjectHideSubObjectPermanently( self, "OBJECT02", true )	-- Barrel on the Orc Raider
	ObjectHideSubObjectPermanently( self, "ARROW", true )
	ObjectHideSubObjectPermanently( self, "PLANE02", true )	
end

function OnCreateAHeroFunctions(self)
	CreateAHeroHideEverything(self)
end

function OnEvilShipCreated(self)
	ObjectHideSubObjectPermanently( self, "CAULDRON", true )
	ObjectHideSubObjectPermanently( self, "CAULDRON_FIRE", true )
	ObjectHideSubObjectPermanently( self, "CAULDRON_TOP", true )
	ObjectHideSubObjectPermanently( self, "CROWSNEST", true )
	ObjectHideSubObjectPermanently( self, "FLAG", true )
	ObjectHideSubObjectPermanently( self, "BANNER", true )
end

function OnGoodShipCreated(self)
	ObjectHideSubObjectPermanently( self, "UG_FLAMING_01", true )
	ObjectHideSubObjectPermanently( self, "UG_FLAMING_02", true )
	ObjectHideSubObjectPermanently( self, "UG_FLAMING_FIRE", true )
	ObjectHideSubObjectPermanently( self, "UG_ARMOR", true )
	ObjectHideSubObjectPermanently( self, "BANNER", true )
end

function OnShipWrightCreated(self)
	ObjectHideSubObjectPermanently( self, "GoodPart_A", true )
	ObjectHideSubObjectPermanently( self, "GoodPart_B", true )
	ObjectHideSubObjectPermanently( self, "EvilPart_A", true )
	ObjectHideSubObjectPermanently( self, "EvilPart_B", true )
end

function OnDormitoryBuildVariation(self,variation)

	local var = tonumber(variation)

	if var == 1 then
		ObjectSetGeometryActive( self, "VersionOne", true )
		ObjectSetGeometryActive( self, "VersionTwo", false )
	elseif var == 2 then
		ObjectSetGeometryActive( self, "VersionOne", false )
		ObjectSetGeometryActive( self, "VersionTwo", true )
	end

end

function OnFortressCreated(self)
	ObjectHideSubObjectPermanently( self, "DBFBANNER", true )	
	ObjectSetGeometryActive( self, "HighTowerGeom", false )
end

function OnFortressInverseDiscounterCreated(self)
	local porters = PorterList()

	-- Loop over all builders belonging to my player
	for k,v in globals() do
		if strfind(k,"ObjID") and ObjectTeamName(self)==ObjectTeamName(v) and porters[ObjectTemplateName(v)] == true then
			ObjectRemoveUpgrade(v, "Upgrade_User1")   -- forbid builder to construct fort
		end
	end

	AddToGlobalQueue(MakeVarLabel("FortDiscount202_", "DiscounterQueue", self), self)

	local fortFlagQueueLabel = MakeVarLabel("FortDiscount202_",  "FortFlagQueue", self)
	local fortFlagQueue = getglobal(fortFlagQueueLabel)

	-- Attach a discounter to its corresponding fortress
	if fortFlagQueue ~= nil then
		local value = QueuePop(fortFlagQueue)
		self["fortFlagIbelongTo"] = value
		setglobal(fortFlagQueueLabel, fortFlagQueue)
	end
end

function OnFortressFlagCreated(self)
	ObjectHideSubObjectPermanently( self, "DBFBANNER", true )	
	ObjectSetGeometryActive( self, "HighTowerGeom", false )

	AddToGlobalQueue(MakeVarLabel("FortDiscount202_", "FortFlagQueue", self), self)

	ExecuteAction("CREATE_OBJECT", "FortressInverseDiscounter", GetScriptTeamName(self), "((0.00,0.00,0.00))", 0)
end

---
-- This function loops over all discounters and sees whether they need to be killed.
-- the kill criterion is specified via functionToCall
--
function DiscounterLoop(self, discounterQueue, functionToCall)
	for i=discounterQueue.first, discounterQueue.last do 
		local currElem = discounterQueue[i]

		if currElem ~= nil then
			local fortIbelongto = currElem["fortFlagIbelongTo"] 

			if fortIbelongto ~= nil then
				local shouldBreak = functionToCall(fortIbelongto, currElem, discounterQueue, i, self)

				if shouldBreak then
					break
				end
			end
		end
	end
end

function DestroyOnFortComplete(fortIbelongto, currElem, discounterQueue, i, obj)
	if ObjectDescription(fortIbelongto) == ObjectDescription(obj) then
		kill(currElem)
		discounterQueue[i] = nil
		return true
	end

	return false
end

function DestroyIfFortGone(fortIbelongto, currElem, discounterQueue, i, obj)
	if strfind(ObjectDescription(fortIbelongto),"<No Object>") then
		kill(currElem)
		discounterQueue[i] = nil
	end

	return false
end

function OnFortressFlagComplete(self)
	local discounterQueueLabel = MakeVarLabel("FortDiscount202_", "DiscounterQueue", self)
	local discounterQueue = getglobal(discounterQueueLabel)

	if QueueIsEmpty(discounterQueue) then return end

	-- Loop through all discounters, find the one belonging to this fortress and destroy it
	DiscounterLoop(self, discounterQueue, DestroyOnFortComplete)

	setglobal(discounterQueueLabel, discounterQueue)
end

function FortressDiscountTick(self)
	local discounterQueueLabel = MakeVarLabel("FortDiscount202_", "DiscounterQueue", self)
	local discounterQueue = getglobal(discounterQueueLabel)

	-- This should happen 99% of times and then this function just does nothing
	if QueueIsEmpty(discounterQueue) then return end

	CleanQueue(discounterQueue)
	if(QueueIsEmpty(discounterQueue)) then
		AllowBuildersToMakeFortAgain(self)
	end

	-- Loop through all discounters, destroying any whose fort no longer exists
	DiscounterLoop(self, discounterQueue, DestroyIfFortGone)

	CleanQueue(discounterQueue)
	if(QueueIsEmpty(discounterQueue)) then
		AllowBuildersToMakeFortAgain(self)
	end

	setglobal(discounterQueueLabel, discounterQueue)
end

function OnGateWatcherBuilt(self)
	ObjectDoSpecialPower(self, "SpecialAbilityGateWatchersFear")
end	

function NeutralGollum_RingStealerDamaged(self,other)

	if ObjectHasUpgrade( other, "Upgrade_RingHero" ) == 0 then
		ObjectChangeAllegianceFromNonPlayablePlayer( self, other )
	end
	
end

function NeutralGollum_RingStealerSlaughtered(self,other)
	ObjectRemoveUpgrade( other, "Upgrade_RingHero" )
end

function OnNecromancerStatueCreated(self)
	ObjectDoSpecialPower(self, "SpecialAbilityGateWatchersFear")
end

function OnKennelWolfCreated(self) -- Added for 2.1, using this to show Dire Wolf Kennel Wolf Spiked Collars ;;,;;
	ObjectGrantUpgrade( self, "Upgrade_AngmarSpikedCollar" )
	ObjectHideSubObjectPermanently( self, "Forged_Blade", true )
	ObjectHideSubObjectPermanently( self, "Glow", true )
end

function BecomeDismounted(self) -- Added for 2.1, Sûlherokhh AI ;;,;;
    ObjectRemoveUpgrade( self, "Upgrade_AITriggerMount" )
    ObjectGrantUpgrade( self, "Upgrade_AITriggerDismount" )
end

function BecomeMounted(self) -- Added for 2.1, Sûlherokhh AI ;;,;;
    ObjectRemoveUpgrade( self, "Upgrade_AITriggerDismount" )
    ObjectGrantUpgrade( self, "Upgrade_AITriggerMount" )
end

function OnStarlightActivated(self) -- Added for 2.1 ;;,;;
	ObjectBroadcastEventToEnemies( self, "BeUncontrollablyAfraid", 350 )
end

function OnRohanEowynCreated(self) -- Added for v7, by Sûlherokhh. ;,;
    ObjectRemoveUpgrade( self, "Upgrade_EowynConditionDisguised" )
end

function OnRohanEowynDisguised(self) -- Added for v7, by Sûlherokhh. ;,;
    ObjectGrantUpgrade( self, "Upgrade_EowynConditionDisguised" )
end

function OnRohanEowynDisguiseCanceled(self) -- Added for v7, by Sûlherokhh. ;,;
    ObjectRemoveUpgrade( self, "Upgrade_EowynConditionDisguised" )
    end

function OnRohanEowynStealthed(self) -- Added for v7, by Sûlherokhh. ;,;
    ObjectRemoveUpgrade( self, "Upgrade_EowynConditionNotStealthed" )
    ObjectGrantUpgrade( self, "Upgrade_EowynConditionStealthed" )
end

function OnRohanEowynNotStealthed(self) -- Added for v7, by Sûlherokhh. ;,;
    ObjectRemoveUpgrade( self, "Upgrade_EowynConditionStealthed" )
    ObjectGrantUpgrade( self, "Upgrade_EowynConditionNotStealthed" )
end

function OnTrollEating(self) -- Added by Miraak. ;,;
    ObjectRemoveUpgrade( self, "Upgrade_TrollNotEating" )
    ObjectGrantUpgrade( self, "Upgrade_TrollEating" )
end

function OnTrollNotEating(self)  -- Added by Miraak. ;,;
    ObjectRemoveUpgrade( self, "Upgrade_TrollEating" )
    ObjectGrantUpgrade( self, "Upgrade_TrollNotEating" )
end
