# Shared class data: hero configs, ability kits, and specialization flavor.
# Used by both the battle scene and the party screen.
class_name Classes

# Per-slot tints distinguish heroes until distinct class sprites arrive.
const HERO_TINTS := [Color.WHITE, Color(0.65, 0.75, 1.0), Color(1.0, 0.9, 0.6),
	Color(0.7, 1.0, 0.75)]

# Class passives: one per CLASS, active for every spec of that class (and
# before awakening). Mechanics live in battle.gd, keyed by hero_key.
const CLASS_PASSIVES := {
	"warrior": {"name": "Threatening Presence",
		"desc": "Enemies are 20% more likely to attack the Warrior."},
	"cleric": {"name": "Holy Conduit",
		"desc": "All healing the Cleric receives is increased by 15%."},
	"hunter": {"name": "Tracker",
		"desc": "Always attacks first in every fight."},
	"mage": {"name": "Evocation",
		"desc": "Regenerates an additional 10 Mana per turn."},
}


# Dedicated spec portrait art (shown untinted, original colors).
const SPEC_PORTRAITS := {
	"berserker": "res://assets/sprites/berserker/Berserker_Portrait.png",
}


# List icon: the spec's portrait when it has one, else a cropped close-up
# of the class's idle sprite.
static func class_icon(key: String, spec := "") -> Texture2D:
	if spec != "" and SPEC_PORTRAITS.has(spec):
		return load(SPEC_PORTRAITS[spec])
	var sheet_dir: String = hero_config(key)["sheet_dir"]
	var prefix: String = sheet_dir.get_file().capitalize()
	var tex: Texture2D = load("%s/%s_Idle.png" % [sheet_dir, prefix])
	if tex == null:
		return null
	var crop := AtlasTexture.new()
	crop.atlas = tex
	crop.region = Rect2(28, 18, 44, 60)
	return crop


# Class bases; the spec's Attack (spec_attack) replaces "attack" once
# awakened. Hunters and Mages attack from range — their hits can't be
# parried (parry is a melee answer).
static func hero_config(key: String) -> Dictionary:
	var soldier := "res://assets/sprites/soldier"
	match key:
		"hunter":
			return {"unit_name": "Hunter", "is_hero": true, "sheet_dir": soldier,
				"max_hp": 110, "attack": 100, "armor": 0.12, "speed": 105.0,
				"stability": 100, "constitution": 95, "is_ranged": true,
				"resource_name": "Mana", "resource": 100, "max_resource": 100,
				"abilities": kit(key)}
		"warrior":
			return {"unit_name": "Warrior", "is_hero": true, "sheet_dir": soldier,
				"max_hp": 154, "attack": 100, "armor": 0.25, "speed": 95.0,
				"stability": 100, "constitution": 110,
				"resource_name": "Rage", "resource": 0, "max_resource": 100,
				"abilities": kit(key)}
		"mage":
			return {"unit_name": "Mage", "is_hero": true, "sheet_dir": soldier,
				"max_hp": 99, "attack": 100, "armor": 0.10, "speed": 110.0,
				"stability": 100, "constitution": 85, "is_ranged": true,
				"resource_name": "Mana", "resource": 100, "max_resource": 100,
				"abilities": kit(key)}
		_:
			return {"unit_name": "Cleric", "is_hero": true, "sheet_dir": soldier,
				"max_hp": 121, "attack": 50, "armor": 0.15, "speed": 85.0,
				"stability": 100, "constitution": 100,
				"resource_name": "Mana", "resource": 100, "max_resource": 100,
				"abilities": kit(key)}


static func kit(key: String) -> Array:
	match key:
		"warrior":
			return warrior_kit()
		"mage":
			return mage_kit()
		"hunter":
			return hunter_kit()
		_:
			return cleric_kit()


static func hunter_kit() -> Array:
	return [
		Ability.make({"display_name": "Quick Shot", "cost": 0, "damage": 20, "pressure": 14,
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "mana", "perfect_text": "+10 bonus Mana",
			"description": "Basic ranged shot."}),
	]


static func warrior_kit() -> Array:
	return [
		Ability.make({"display_name": "Strike", "cost": 0, "damage": 23, "pressure": 18,
			"resource_gain": 20, "delay": 2.0, "anim": "attack01",
			"perfect_id": "rage", "perfect_text": "+10 bonus Rage",
			"description": "Basic attack. Builds 20 Rage."}),
	]


# VAULTED — Mana Shield (removed from ALL mage specs 07-16, kept for
# future return): {"display_name": "Mana Shield", "cooldown": 3, "cost": 15,
#   "special": "mana_shield", "delay": 2.0, "anim": "attack03",
#   "perfect_text": "Initiative cost 1.5 instead of 2",
#   "description": "50% of damage taken converts into Mana (3 turns)."}
static func mage_kit() -> Array:
	return [
		Ability.make({"display_name": "Magic Bolt", "dmg_type": "arcane", "cost": 0, "damage": 25, "pressure": 14,
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "mana", "perfect_text": "Restores 10 Mana",
			"description": "Basic arcane projectile."}),
	]


# ---------- VAULT: removed from kits, kept for future return ----------
# Arcane Surge (was mage core): {"display_name": "Arcane Surge", "cost": 15,
#   "special": "surge", "delay": 3.0, "anim": "attack03",
#   "perfect_text": "+2 Resonance instead of +1",
#   "description": "+20% attack on your next turn. Guarantees +1 Resonance."}
# Reality Fracture (was arcanist): {"display_name": "Reality Fracture",
#   "dmg_type": "arcane", "cost": 20, "damage": 15, "pressure": 14,
#   "delay": 2.0, "anim": "attack03", "delay_push": 6.0,
#   "perfect_text": "Also +1 Resonance",
#   "description": "Shove the target far down the initiative order."}


static func cleric_kit() -> Array:
	# VAULTED — kept for future return: Mend Wounds (25 Mana flat 45 heal).
	# Resurrection now belongs to the Holy tree (pending_talent_ability).
	return [
		# damage 44 = 44% of the Cleric's 50 Attack -> the familiar 22.
		Ability.make({"display_name": "Smite", "dmg_type": "holy", "cost": 0, "damage": 44, "pressure": 16,
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "self_heal", "perfect_text": "Cleric recovers 5% max health",
			"description": "Basic radiant strike."}),
	]


# ---------- the earnable pools (Batch AH) ----------
#
# Every hero starts with its core attack plus exactly 3 spec abilities and
# EARNS 6 more over a run — two per zone, one from the mini-boss and one
# from the zone boss. Each award offers 3 abilities the hero does not own:
# 1 from its SPEC_POOLS entry and 2 from its class's CLASS_POOLS entry
# (Run.roll_ability_offer). Nothing here is new content: a pool entry is
# either an ability trimmed out of a starting kit, an ability a talent node
# grants, an ability another spec of the same class starts with, or a
# vaulted ability whose machinery never left battle.gd.
#
# SPEC_POOLS — what only THIS spec can earn: its own trims, its own
# talent-granted abilities, and its own vaulted ones.
const SPEC_POOLS := {
	# Warrior.
	"berserker": ["Blood Price", "Battle Shout", "Rampage"],
	"warden": ["War Stomp", "Interpose", "Hold the Line", "Retaliation"],
	# Batch AK: Guard Change came OUT of this pool and back into the opening
	# three; Shatterpoint went the other way.
	"swordmaster": ["Sweeping Strikes", "Shatterpoint", "Lunge", "Execute"],
	# Mage. Batch AR re-specced Flame Shield into IMMOLATE, which reads
	# Overburn and so can only ever be a spec pick.
	#
	# ASHES OF AL'AR IS IN ALL THREE MAGE POOLS (Batch BB §6), AND THAT IS A
	# CORRECTION TO THE BRIEF RATHER THAN A LIBERTY. §6 says the ability "joins
	# CLASS_POOLS["mage"]" and calls that one array entry; it IS one array entry
	# and it is made below — but **BATCH AN §4 RETIRED THE CLASS DRAW**, and
	# `award_ability_pick` has read `roll_spec_ability_offer` (SPEC POOLS ONLY)
	# ever since. `CLASS_POOLS` still resolves and nothing reads it, so the
	# class-pool entry ALONE would have given the ability a home no boss can
	# reach — an unearnable answer to a homelessness thread, which is not what
	# §6 asked for. The entry the LIVE draw needs is a spec-pool one per Mage
	# spec; the class-pool entry is made as instructed and stands ready for the
	# day the class draw reopens. "Any Mage may earn it" is the design either
	# way, and re-opening the class draw is a live change to how every one of
	# the twelve specs is offered abilities — far past this section's scope.
	"pyromancer": ["Immolate", "Firestorm", "Ashes of Al'ar"],
	"cryomancer": ["Rime", "Shatter", "Ashes of Al'ar"],
	# Batch AT: STABILIZE joins the pool — it left the opening three because it
	# is the escape hatch from the escalation, and earning it back is the right
	# shape for a safety valve. Every entry here reads Resonance, so none of
	# them can ever be class-pool-eligible (AH's curation rule).
	"arcanist": ["Overcharge", "Magi's Wrath", "Stabilize", "Ashes of Al'ar"],
	# Cleric. The Mercy/Faith spenders can only ever be spec picks — a sibling
	# has no stacks to pay them with. BATCH AV: RESURRECTION LEFT THIS POOL
	# because it joined her opening kit — a boss cannot offer what she starts
	# with. Intercession is deliberately NOT here: it is the Vigil row-4 node's
	# grant and reads Mercy on trigger, so a sibling could not pay it either.
	"holy": ["Divine Plea"],
	"inquisitor": ["Sacred Resolve", "Bulwark of Fortitude"],
	"occultist": ["Mind Flay", "Mass Hysteria", "Umbral Sigil"],
	# Hunter — the three pools that shipped in Batch 30/32, unchanged.
	"beastmaster": ["Bestial Wrath", "Spirit Bond", "Primal Surge",
		"Call of the Wild", "Mark of the Hunt"],
	"sharpshooter": ["Quick Draw", "Triple Shot", "Coup de Grâce",
		"Pinning Shot", "Called Shot"],
	"mystic": ["Explosive Shot", "Venom Coating", "Hamstring",
		"Deadfall", "Harvest"],
}

# CLASS_POOLS — what ANY spec of the class can earn: the sibling specs'
# abilities plus the class's vaulted ones. CURATION RULE: an entry has to
# FUNCTION for a sibling. Anything that costs a spec-exclusive secondary
# resource (faith_cost), reads a passive the taker will not have (Burn to
# consume, Resonance to spend, Loyalty or a living beast, the Swordmaster's
# stance), or is a spec's signature identity piece (the summons, Kill
# Command, Hex of Ruin) stays in SPEC_POOLS only. The changelog lists every
# exclusion and its reason.
const CLASS_POOLS := {
	"warrior": ["Bloodlust", "Wildstrikes", "Hack and Slash", "Blood Price",
		"Battle Shout", "Rampage", "Mocking Blow", "Crushing Blow", "War Stomp",
		"Shieldwall", "Interpose", "Hold the Line", "Overpower", "Pommel Strike",
		"Shatterpoint", "Sweeping Strikes", "Execute", "Rallying Shout"],
	# Batch AR: "Flame Shield" LEFT this pool because it stopped existing —
	# the node that defined it is Immolate now, and Immolate reads Overburn,
	# so it fails the curation rule that a class-pool entry must FUNCTION for
	# a sibling. Pyroblast is a Pyromancer tree node and is deliberately NOT
	# listed: its bonus reads a Burn the taker cannot apply.
	# BATCH BB §6: ASHES OF AL'AR TAKES THE SLOT FLAME SHIELD LEFT, putting the
	# pool back at twelve. It passes AH's curation rule cleanly — a self-revive
	# reads nothing but the taker's own health, so it FUNCTIONS for any Mage —
	# and it is the designer's answer to the homeless-ability thread AR opened.
	# It is EARNABLE, never default: the Pyromancer can have his escape hatch
	# back only by spending a boss pick on it, which is a choice against his own
	# spine rather than the hole AR deliberately left.
	"mage": ["Flamewave", "Firestorm", "Razor Ice", "Blizzard",
		"Ice Lance", "Rime", "Arcane Barrage", "Mana Shield", "Arcane Surge",
		"Reality Fracture", "Phoenix Rebirth", "Ashes of Al'ar"],
	"cleric": ["Heal", "Renewal", "Divine Shield", "Consecrated Ground",
		"Blessing of Zeal", "Sacred Resolve", "Bulwark of Fortitude", "Bewitch",
		"Dark Pact", "Mind Flay", "Mass Hysteria", "Dawnbreak", "Sanctuary",
		"Divine Wrath"],
	"hunter": ["Hunter's Instinct", "Mark of the Hunt", "Aimed Shot", "Powershot",
		"Hold Breath", "Quick Draw", "Triple Shot", "Pinning Shot", "Called Shot",
		"Tripwire", "Shrapnel Charge", "Snare Trap", "Explosive Shot",
		"Venom Coating", "Hamstring", "Deadfall", "Harvest"],
}


static func spec_pool(spec: String) -> Array:
	return SPEC_POOLS.get(spec, [])


static func class_pool(class_name_key: String) -> Array:
	return CLASS_POOLS.get(class_name_key, [])


# The class a spec belongs to ("" when the spec is unknown/unawakened).
static func class_of_spec(spec: String) -> String:
	for class_key in SPEC_IDS:
		if SPEC_IDS[class_key].has(spec):
			return class_key
	return ""


# Resolve a pool NAME to its Ability, from either pool. The `spec` argument
# survives from the Batch 30 signature and only steers the three hunter
# trophy tables; everything else resolves by name alone, because a display
# name is unique across the whole game.
static func spec_pool_ability(spec: String, display_name: String) -> Ability:
	if spec == "sharpshooter":
		var ss := sharpshooter_pool_ability(display_name)
		if ss != null:
			return ss
	if spec == "mystic":
		var sv := survivalist_pool_ability(display_name)
		if sv != null:
			return sv
	return pool_ability(display_name)


# THE resolver. Order matters only for speed — no name lives in two of
# these. Nothing here holds a second copy of an ability that exists
# elsewhere: kit pieces are read back out of the living kits and
# talent-granted ones out of the living trees, so a pool copy can never
# drift from the copy the kit or the talent hands out.
static func pool_ability(display_name: String) -> Ability:
	var beast := beastmaster_pool_ability(display_name)
	if beast != null:
		return beast
	var ss := sharpshooter_pool_ability(display_name)
	if ss != null:
		return ss
	var sv := survivalist_pool_ability(display_name)
	if sv != null:
		return sv
	var pend := pending_talent_ability(display_name)
	if pend != null:
		return pend
	var trimmed := trimmed_kit_ability(display_name)
	if trimmed != null:
		return trimmed
	var vault := vault_ability(display_name)
	if vault != null:
		return vault
	# Another spec of the same class starts with it — read the live kit.
	for class_key in SPEC_IDS:
		for spec_id in SPEC_IDS[class_key]:
			for ab in spec_abilities(spec_id):
				if ab.display_name == display_name:
					return ab
	# A talent node grants it (new_ability payloads live in the trees).
	return Talents.granted_ability(display_name)


# ---------- the vault, unsealed ----------
#
# Abilities that left a kit but never left the code: every one of these
# still has its `special` handler in battle.gd, so they return as earnable
# picks without a line of new mechanics. FIVE could NOT come back, because
# their machinery went with them: Pyroblast, Flame Surge, Frost Bolt, Death
# Ray and Mend Wounds are prose in a comment, not code, and reviving them
# would mean AUTHORING them. BATCH AR AUTHORED PYROBLAST — it is a plain
# damage ability plus one conditional in the existing damage block, which is
# why it needed no subsystem; the other four are still prose. Three of the ten below (Mana Shield, Arcane
# Surge, Reality Fracture) kept their full dicts in the vault comments and
# come back verbatim; the other seven needed a cost/cooldown/initiative
# wrapper around effects the handler already defines exactly, and THOSE
# NUMBERS ARE NEW — the one balance judgment this batch made.
static func vault_ability(display_name: String) -> Ability:
	match display_name:
		"Rallying Shout":
			return Ability.make({"display_name": "Rallying Shout", "cost": 25,
				"special": "rally", "delay": 2.5, "anim": "attack03", "cooldown": 3,
				"perfect_id": "", "perfect_text": "-50 Pressure and +30% resource instead",
				"description": "Raise the line: the whole party sheds\n30 Pressure, and every other ally\nregains 20% of their resource."})
		"Retaliation":
			return Ability.make({"display_name": "Retaliation", "cost": 20,
				"special": "retaliate", "delay": 2.0, "anim": "attack01", "cooldown": 3,
				"perfect_id": "", "perfect_text": "Holds a 4th turn",
				"description": "Set the counter-stance: for 3 turns\nevery attacker is answered with a\nbasic strike."})
		"Mana Shield":
			return Ability.make({"display_name": "Mana Shield", "cooldown": 3,
				"cost": 15, "special": "mana_shield", "delay": 2.0, "anim": "attack03",
				"perfect_id": "", "perfect_text": "Initiative cost 1.5 instead of 2",
				"description": "50% of damage taken converts into\nMana (3 turns)."})
		# BATCH BB §6 — ASHES OF AL'AR GETS A HOME, AND IT NEEDED A WRAPPER.
		# The batch brief calls this "one array entry"; IT IS NOT, and the
		# difference is worth stating rather than quietly absorbing. Ashes of
		# Al'ar has never been an Ability — it was a Pyromancer TALENT, a passive
		# guard in `unit.take_hit` / `unit.take_tick_damage`, and AR removed the
		# node with every other defensive option in that spec. A CLASS_POOLS
		# entry has to resolve through `pool_ability` to an Ability, so putting
		# the self-revive Mage-wide means authoring the cast that arms it.
		#
		# THAT IS EXACTLY THE VAULT'S OWN PRECEDENT (Batch AH): seven of the ten
		# entries below "needed a cost/cooldown/initiative wrapper around effects
		# the handler already defines exactly, and THOSE NUMBERS ARE NEW". The
		# guard is live and untouched in unit.gd; the cost, the initiative and
		# the return share are this batch's one balance judgement, flagged here
		# rather than buried.
		#
		# ARMING IT COSTS A TURN, and for the Pyromancer that is the point: the
		# spec whose spine is having no escape hatch can buy one back only by
		# spending a boss pick AND a turn he would rather spend burning.
		"Ashes of Al'ar":
			return Ability.make({"display_name": "Ashes of Al'ar", "cost": 30,
				"special": "ashes", "delay": 2.5, "anim": "attack03", "cooldown": 0,
				"perfect_id": "", "perfect_text": "Returns at 40% health instead of 25%",
				"description": "Wreathe yourself in embers: the next\nblow that would kill you this battle\nreturns you at 25% health instead.\nOnce per battle."})
		"Arcane Surge":
			return Ability.make({"display_name": "Arcane Surge", "cost": 15,
				"special": "surge", "delay": 3.0, "anim": "attack03", "cooldown": 3,
				"perfect_id": "", "perfect_text": "+2 Resonance instead of +1",
				"description": "+20% attack on your next turn.\nAn Arcanist also banks 1 Resonance."})
		"Reality Fracture":
			return Ability.make({"display_name": "Reality Fracture",
				"dmg_type": "arcane", "cost": 20, "damage": 15, "pressure": 14,
				"delay": 2.0, "anim": "attack03", "delay_push": 6.0, "cooldown": 3,
				"perfect_id": "", "perfect_text": "An Arcanist also banks 1 Resonance",
				"description": "Shove the target far down the\ninitiative order."})
		# PHOENIX REBIRTH IS NOT HERE ANY MORE. Batch AR made it the
		# Pyromancer's Inferno capstone, so the TREE owns the only copy and
		# pool_ability finds it through Talents.granted_ability — the same
		# single-source rule every other talent grant follows. It stays in
		# CLASS_POOLS["mage"] and still resolves; only the def moved.
		"Dawnbreak":
			return Ability.make({"display_name": "Dawnbreak", "cost": 20,
				"special": "dawnbreak", "target": Ability.Target.ALLY,
				"delay": 3.0, "anim": "attack02", "cooldown": 2,
				"perfect_id": "", "perfect_text": "Heals 55 instead of 40",
				"description": "Call the dawn: heal an ally 40.\nWhatever overflows their bar heals\nthe caster instead."})
		"Sanctuary":
			return Ability.make({"display_name": "Sanctuary", "cost": 30,
				"special": "sanctuary", "delay": 3.5, "anim": "attack03", "cooldown": 4,
				"perfect_id": "", "perfect_text": "Heals 18% instead of 12%",
				"description": "Ground made safe: every ally heals\n12% of their max health."})
		"Divine Wrath":
			return Ability.make({"display_name": "Divine Wrath", "cost": 25,
				"special": "divine_wrath", "delay": 2.5, "anim": "attack03", "cooldown": 4,
				"perfect_id": "", "perfect_text": "Lasts 4 turns",
				"description": "The light answers: the whole party\ndeals +15% damage and acts 15%\nfaster for 3 turns."})
		"Umbral Sigil":
			return Ability.make({"display_name": "Umbral Sigil", "cooldown": 4,
				"cost": 20, "special": "umbral_sigil", "delay": 3.0, "anim": "attack03",
				"perfect_id": "", "perfect_text": "Lasts 4 turns",
				"description": "Brand one enemy for 3 turns: half of\nevery attack it suffers echoes through\nits whole warband."})
	return null


# ---------- abilities trimmed out of a starting kit (Batch AH) ----------
#
# These left their spec's opening three and became earnable. The defs live
# here rather than in spec_abilities() so there is still exactly one copy.
static func trimmed_kit_ability(display_name: String) -> Ability:
	match display_name:
		"Blood Price":
			return Ability.make({"display_name": "Blood Price", "cost": 0,
				"special": "blood_price", "delay": 1.5, "anim": "attack02",
				"cooldown": 3,
				"perfect_id": "", "perfect_text": "The health cost is halved",
				"description": "Open his own veins: pays 15% of\ncurrent health (never lethal) for\n30 Rage and +25% damage for 2 turns.\nBlood Frenzy wakes when HE says so."})
		"War Stomp":
			return Ability.make({"display_name": "War Stomp", "cost": 20, "damage": 15,
				"pressure": 15, "delay": 3.0, "anim": "attack03", "cooldown": 3,
				"random_hits": 3, "perfect_extra_hit": false,
				"perfect_id": "", "perfect_text": "Allies regain 20% of their resource instead",
				"description": "Slam the earth: 3 shockwaves rip\nrandom enemies for 15% Attack damage\nand 15 BD each. Allies regain 10%\nof their resource."})
		"Interpose":
			return Ability.make({"display_name": "Interpose", "cost": 25,
				"special": "interpose", "delay": 2.0, "anim": "attack01",
				"cooldown": 4,
				"perfect_id": "", "perfect_text": "The Warden gains a charge too",
				"description": "Throw the wall wide: every other ally\ngains a shield charge — the next\nattack against them is BLOCKED."})
		"Sweeping Strikes":
			return Ability.make({"display_name": "Sweeping Strikes", "cost": 20,
				"damage": 15, "pressure": 12, "delay": 3.0, "anim": "attack02",
				"multi_hits": 2, "perfect_extra_hit": false, "resource_gain": 10,
				"applies_status": {"id": "dazed", "turns": 3},
				"perfect_id": "", "perfect_text": "+25% crit chance on the second swing",
				"description": "Two broad cuts that leave the target\nDazed for 3 turns. Builds 10 Rage."})
		# Batch AK: Guard Change went BACK into the opening three and
		# Shatterpoint took its place here. Guard Change is the only stance
		# swap in the game, and four nodes of the Swordmaster's tree read
		# the stance — trimming it turned a quarter of his tree inert.
		# Shatterpoint only accelerates a Break he reaches by other means,
		# so it is the safe piece to make earnable.
		# Batch AT: Stabilize came OUT of the Arcanist's opening three and into
		# SPEC_POOLS["arcanist"]. It is the escape hatch from the ramp — it
		# vents the very stacks Runaway Resonance exists to build — so it is a
		# choice a player EARNS rather than a default they start holding. Its
		# venting is the one thing that removes Resonance; the passive's "no
		# ceiling, nothing removes it" describes the passive's own rules, and
		# this is the exception the player buys deliberately.
		"Stabilize":
			return Ability.make({"display_name": "Stabilize", "cooldown": 3, "cost": 0,
				"damage": 0, "pressure": 0, "special": "stabilize", "delay": 1.5,
				"anim": "attack01",
				"perfect_id": "", "perfect_text": "Also heals 5% of max health",
				"description": "Vent the storm: consumes all\nResonance ABOVE 2 — +5 Mana and +10%\ndamage reduction (2 turns) per stack\nconsumed. Unusable at 2 or fewer."})
		"Shatterpoint":
			return Ability.make({"display_name": "Shatterpoint", "cost": 30,
				"damage": 20, "pressure": 40, "delay": 3.0, "anim": "attack03",
				"cooldown": 4,
				"perfect_id": "", "perfect_text": "+15 bonus BD",
				"description": "Find the flaw and split it — his\nheaviest Break blow. If this hit\nBREAKS the target, he instantly casts\nOverpower on them for free."})
	return null


# The Survivalist's spec pool — 5 of the designed 8. Blight, Smoke Bomb and
# Field Dressing are still unwritten (Batch AH asked for them and its own
# opening line forbade authoring new abilities; the header won). Adding
# them later is a list edit and a def, no restructuring.
static func survivalist_pool_ability(display_name: String) -> Ability:
	match display_name:
		"Explosive Shot":
			return Ability.make({"display_name": "Explosive Shot", "cooldown": 3,
				"dmg_type": "nature", "cost": 35, "damage": 10, "pressure": 20,
				"delay": 3.0, "anim": "attack03", "aoe": true,
				"applies_status": {"id": "poison", "turns": 5},
				"perfect_id": "", "perfect_text": "Deals 12 damage",
				"description": "A bursting powder charge rakes ALL\nenemies with nature damage and heavy\nBreak pressure, Poisoning each."})
		"Venom Coating":
			return Ability.make({"display_name": "Venom Coating", "cooldown": 5, "cost": 20,
				"special": "venom_coat", "delay": 1.5, "anim": "attack01", "no_skill_check": true,
				"perfect_id": "", "perfect_text": "",
				"description": "Coat your arrows: for 4 turns every\nattack applies Poison and refreshes\nexisting Poison timers."})
		"Hamstring":
			return Ability.make({"display_name": "Hamstring", "cooldown": 3, "cost": 25,
				"damage": 20, "pressure": 10, "delay": 2.5, "anim": "attack02",
				"applies_status": {"id": "cripple", "turns": 3},
				"perfect_id": "status_plus", "perfect_text": "Everything lasts 4 turns",
				"description": "A tearing shot through the leg:\nCripple, Slowed AND Exposed for\n3 turns — three statuses in one cast."})
		# BATCH BD — RE-SPECCED FROM A ONE-SHOT MINE INTO A PLACED HAZARD.
		# Read against the base kit, the old Deadfall WAS Snare Trap: same cost,
		# same initiative, same cooldown, same 1-turn stun at the victim's turn
		# start, both against the same trap cap — and the only distinction (you
		# don't pick) was handed straight back by its perfect. UNTARGETED IS THE
		# DESIGN NOW rather than the drawback, so the perfect can no longer name
		# the victim: that clause is exactly what collapsed the two abilities.
		# Per-spring damage is 35% -> 20% because there are THREE of them; the
		# payoff is three turns of denial rather than the numbers.
		"Deadfall":
			return Ability.make({"display_name": "Deadfall", "cooldown": 5, "cost": 25,
				"special": "deadfall", "delay": 2.0, "anim": "attack01",
				"perfect_id": "", "perfect_text": "A fourth spring.",
				"description": "Arm a deadfall in the path. The next\nenemy to act takes 20% Atk nature\ndamage and is Stunned 1 turn; the trap\nthen lies dormant 2 turns, re-arms and\nsprings again — THREE times in all.\nIt holds a trap slot until spent.\nA PERFECT rig gets a fourth."})
		"Harvest":
			return Ability.make({"display_name": "Harvest", "cooldown": 4, "cost": 25,
				"special": "harvest", "delay": 3.0, "anim": "attack02",
				"perfect_id": "", "perfect_text": "Heals 150% of the damage",
				"description": "CONSUME every status on one enemy:\n12% of Attack per status REMOVED,\nand you heal the same amount.\nA poison that cannot be cleansed\nstays — and is not paid for.\nCashing out strips your own Trapper\nbonus from the target — spend the\nboard wisely."})
	return null


# The Sharpshooter's spec pool — 5 of the designed 8, for the same reason
# as the Survivalist's above (Disengage, Suppressing Fire, Piercing Arrow).
static func sharpshooter_pool_ability(display_name: String) -> Ability:
	match display_name:
		"Quick Draw":
			return Ability.make({"display_name": "Quick Draw", "cooldown": 5, "cost": 15,
				"special": "quickdraw", "delay": 1.5, "anim": "attack01",
				"perfect_id": "", "perfect_text": "Lasts 6 turns",
				"description": "Adrenaline takes over: all your abilities\nact 50% faster for 5 turns."})
		"Triple Shot":
			return Ability.make({"display_name": "Triple Shot", "cooldown": 3, "cost": 30,
				"damage": 18, "multi_hits": 3, "pressure": 8, "delay": 3.0, "anim": "attack02",
				"perfect_extra_hit": false,
				"perfect_id": "", "perfect_text": "One arrow is a guaranteed critical.",
				"description": "Three arrows at one target, 18% of\nAttack each — every arrow rolls its\ncritical separately. A crit lottery\nfor a deep Focus meter."})
		"Coup de Grâce":
			return Ability.make({"display_name": "Coup de Grâce", "cooldown": 4, "cost": 25,
				"damage": 25, "pressure": 10, "delay": 3.5, "anim": "attack03",
				"perfect_id": "", "perfect_text": "",
				"description": "CONSUMES ALL FOCUS: deals 25% of\nAttack plus 1% of the target's\nMISSING health per point of Focus\nspent, reading at most 200.\nCash out the patience."})
		"Pinning Shot":
			return Ability.make({"display_name": "Pinning Shot", "cooldown": 3, "cost": 20,
				"damage": 20, "pressure": 10, "delay": 2.5, "anim": "attack02",
				"applies_status": {"id": "slow", "turns": 3},
				"perfect_id": "", "perfect_text": "",
				"description": "A shaft through the leg: the target\nis Slowed AND Dazed for 3 turns."})
		"Called Shot":
			return Ability.make({"display_name": "Called Shot", "cooldown": 3, "cost": 25,
				"damage": 25, "pressure": 10, "delay": 3.0, "anim": "attack02",
				"perfect_id": "", "perfect_text": "",
				"description": "Pick your spot before loosing:\nSUNDER the target's armor (-35%,\n2 turns), CRACK their Break meter\n(+30 BD), or lay them EXPOSED\n(3 turns)."})
	return null


static func beastmaster_pool_ability(display_name: String) -> Ability:
	match display_name:
		"Bestial Wrath":
			return Ability.make({"display_name": "Bestial Wrath", "cooldown": 3, "cost": 25,
				"special": "bestial", "delay": 3.5, "anim": "attack01", "no_skill_check": true,
				"perfect_id": "", "perfect_text": "",
				"description": "Unleash the beast for 3 turns —\nUrsus: max health DOUBLES, +50%\narmor, taunts 3 random enemies.\nCanis: +50% damage and +10 Bleed on\nits bleeding strikes. Aguila: +25%\ndamage and every strike BLINDS.\nRequires a living companion."})
		"Spirit Bond":
			return Ability.make({"display_name": "Spirit Bond", "cooldown": 3, "cost": 20,
				"special": "spirit_bond", "delay": 1.5, "anim": "attack01",
				"perfect_id": "", "perfect_text": "Both gain +10% max health for 5 turns",
				"description": "You and your companion each heal 25%\nof your max health now and 10% more\nnext turn. You restore 15% max Mana\nnow and 5% on each of your next\n2 turns. Requires a living companion."})
		"Primal Surge":
			return Ability.make({"display_name": "Primal Surge", "cooldown": 2, "cost": 20,
				"special": "primal_surge", "delay": 3.0, "anim": "attack02",
				"perfect_id": "", "perfect_text": "The Loyalty is spent but NOT lost",
				"description": "Spend ALL Loyalty on the active beast:\nit strikes for 15% of your Attack per\nstack spent, and you gain +10% damage\nfor that many turns. Loyalty resets\nto 0. Requires a beast with Loyalty."})
		"Call of the Wild":
			return Ability.make({"display_name": "Call of the Wild", "cooldown": 4, "cost": 30,
				"special": "call_wild", "delay": 4.0, "anim": "attack01", "no_skill_check": true,
				"perfect_id": "", "perfect_text": "",
				"description": "The whole pack answers: all three\nbeasts appear, each striking your\ntarget for 15% of your Attack and\nfiring its arrival effect, then the\nabsent ones depart."})
		"Mark of the Hunt":
			return Ability.make({"display_name": "Mark of the Hunt", "cooldown": 3, "cost": 15,
				"special": "mark_hunt", "delay": 2.0, "anim": "attack02",
				"perfect_id": "", "perfect_text": "The mark lasts 7 turns",
				"description": "Mark an enemy for 5 turns: you and\nyour companion deal +25% damage to it\nand every strike on it restores 3%\nof your max Mana. The cooldown resets\nif the marked enemy dies.\nWorks with or without a beast."})
	return null


# DOD_SIM_ABILITIES test hook meanwhile. faith_cost = Mercy stacks.
#
# BATCH AV: "Resurrection" is no longer talent-gated — it is in the Holy
# OPENING KIT (`spec_abilities`) and the Rune of the Last Rites still grants
# it by name. Its def stays HERE and nowhere else, because those two callers
# and `pool_ability` must all read the same numbers; the kit list calls this
# function rather than holding a second copy (the AK resolver rule).
static func pending_talent_ability(display_name: String) -> Ability:
	match display_name:
		"Resurrection":
			return Ability.make({"display_name": "Resurrection", "cooldown": 3,
				"cost": 0, "faith_cost": 1, "special": "resurrection",
				"target": Ability.Target.ALLY, "delay": 4.0, "anim": "attack03",
				"perfect_id": "", "perfect_text": "Returns them at 25% instead",
				"description": "Spend 1 Mercy: return a fallen ally\nto life with 20% health and resource.\nEmpower (+1 Mercy): full health and\nresource, plus 5 turns of Renewal."})
		"Divine Plea":
			return Ability.make({"display_name": "Divine Plea", "cooldown": 2,
				"cost": 0, "faith_cost": 2, "special": "divine_plea",
				"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
				"perfect_id": "", "perfect_text": "Restores 10 Mana",
				"description": "Spend 2 Mercy: FULLY heal an ally.\nEmpower (+1 Mercy): also cleanse all\ndebuffs and Hallow them against new\nones for 3 turns."})
		# BATCH AV — THE REVERSAL BUTTON: death itself refused rather than
		# healed away. NO faith_cost: it costs Mercy ON TRIGGER, not on cast,
		# so a Cleric holding nothing arms nothing (battle._on_intercession_save
		# is the one place that decides, and it refuses when she is empty).
		"Intercession":
			return Ability.make({"display_name": "Intercession", "cooldown": 4,
				"cost": 25, "special": "intercession", "delay": 2.0,
				"anim": "attack03",
				"perfect_id": "", "perfect_text": "The window lasts a turn longer",
				"description": "For 2 turns the next lethal blow\nagainst ANY hero is refused — they\nsurvive at 1 health and the Cleric\nloses 1 Mercy. She must be holding\none when it lands."})
		"Sacred Resolve":
			return Ability.make({"display_name": "Sacred Resolve", "cooldown": 5,
				"cost": 25, "special": "unity", "delay": 2.5, "anim": "attack03",
				"perfect_id": "", "perfect_text": "Lasts 4 turns",
				"description": "Bind the party's souls — all damage\nreceived is split evenly among them\nfor 3 turns (Break damage still lands\non the struck hero)."})
		"Mind Flay":
			return Ability.make({"display_name": "Mind Flay", "cooldown": 2,
				"dmg_type": "shadow", "cost": 25, "damage": 30, "pressure": 15,
				"choose_two": true, "delay": 3.0, "anim": "attack03",
				"applies_status": {"id": "psychosis", "turns": 3},
				"perfect_id": "status_plus", "perfect_text": "Psychosis lasts 4 turns",
				"description": "Flay TWO chosen minds: 30% of Attack\nin shadow each and Psychosis for\n3 turns — madness that turns them\non their own. A BOSS RESISTS UNTIL\nBROKEN."})
		"Mass Hysteria":
			return Ability.make({"display_name": "Mass Hysteria", "cooldown": 4,
				"cost": 30, "special": "hysteria", "delay": 4.0, "anim": "attack03",
				"perfect_id": "", "perfect_text": "Cooldown becomes 3 instead",
				"description": "The warband turns on itself: next\nturn every minion strikes a fellow\nwith DOUBLE Break damage, Sundering\nthem for 3 turns. A BOSS RESISTS\nUNTIL BROKEN."})
		"Bulwark of Fortitude":
			return Ability.make({"display_name": "Bulwark of Fortitude", "cooldown": 3,
				"cost": 30, "special": "bulwark", "delay": 3.0, "anim": "attack03",
				"perfect_id": "", "perfect_text": "Party instantly heals 5% max health",
				"description": "The unbreakable stand: for 3 turns\nthe party takes NO Break damage, has\nits armor increased by 50%, and heals\n10% of max health each turn."})
	return null


# Spec kit corruption: the Occultist's Smite is warped into Shadowrend,
# the Pyromancer's Magic Bolt burns as Fireball. Applied by battle spawn
# AND the party screen.
static func apply_kit_overrides(cfg: Dictionary, spec: String) -> void:
	if spec == "occultist":
		cfg["abilities"][0] = Ability.make({"display_name": "Shadowrend",
			"dmg_type": "shadow", "cost": 0, "damage": 25, "pressure": 16,
			"delay": 2.0, "anim": "attack01",
			"applies_status": {"id": "cripple", "turns": 2},
			"perfect_id": "self_heal", "perfect_text": "Cleric recovers 5% max health",
			"description": "A rending strike of gnawing shadow:\nCripples the target for 2 turns."})
	elif spec == "pyromancer":
		cfg["abilities"][0] = Ability.make({"display_name": "Fireball",
			"dmg_type": "fire", "cost": 0, "damage": 20, "pressure": 15,
			"delay": 2.0, "anim": "attack01",
			"applies_status": {"id": "burn", "turns": 3},
			"perfect_id": "", "perfect_text": "Deals 25% of Attack instead",
			"description": "A crackling bolt of flame: applies\n3 turns of Burn (reapplying extends\nthe burn)."})
	elif spec == "cryomancer":
		cfg["abilities"][0] = Ability.make({"display_name": "Frostbolt",
			"dmg_type": "frost", "cost": 0, "damage": 20, "pressure": 15,
			"delay": 2.0, "anim": "attack01",
			"applies_status": {"id": "chilled", "turns": 3},
			"perfect_id": "", "perfect_text": "Deals 25% of Attack instead",
			"description": "A shard of biting cold: applies 1 stack\nof Chilled. Four stacks put the enemy in\nGlacial Hold — off the turn order until\nthe Cryomancer releases it."})
	elif spec == "arcanist":
		cfg["abilities"][0] = Ability.make({"display_name": "Arcane Explosion",
			"dmg_type": "arcane", "cost": 0, "damage": 10, "pressure": 10,
			"delay": 2.0, "anim": "attack01", "random_hits": 2,
			"perfect_extra_hit": false,
			"perfect_id": "", "perfect_text": "",
			"description": "Unstable magic detonates over TWO\nrandom enemies. Builds 1 Resonance\n(2 on a critical strike)."})


# Archetype outline (design north star for every spec's kit):
#   Damage — Ramp: starts weak, snowballs as the battle progresses.
#            Rush: starts strong, resources dwindle as it progresses.
#            Nuker: banks resources for one devastating turn; exploits weakened foes.
#            Pressure: steady damage, debuffs/DoTs, Break pressure.
#            Bruiser: damage/tank hybrid, weakens enemies, moderate damage, debuffs.
#   Support — Healer: restores HP/mana, can revive.
#             Warder: damage mitigation and buffs.
#   Tank — Tank: absorbs and redirects damage, buffs.
const ARCHETYPE_ROLE := {
	"Ramp": "Damage", "Rush": "Damage", "Nuker": "Damage", "Pressure": "Damage",
	"Bruiser": "Damage", "Control": "Damage",
	"Healer": "Support", "Warder": "Support", "Tank": "Tank",
}

# Base ATTACK by role. Ability damage is a PERCENT of the user's current
# Attack; Attack (and max HP) scale +2% of base per completed combat node.
const ROLE_ATTACK := {"Damage": 100, "Tank": 75, "Support": 50}


# A spec's base Attack: explicit "attack" in SPEC_INFO wins (per-spec stat
# blocks are coming class by class), else the archetype role's base.
static func spec_attack(spec: String) -> int:
	var info: Dictionary = SPEC_INFO[spec]
	return int(info.get("attack",
		ROLE_ATTACK[ARCHETYPE_ROLE[info["archetype"]]]))


# A spec's innate resistances (fraction reduced per damage type, like armor
# for that type). Specs override via "resists" in SPEC_INFO — being filled
# in class by class; missing keys mean 0%.
static func spec_resists(spec: String) -> Dictionary:
	return SPEC_INFO[spec].get("resists", {})


# THE spec stat block, one source of truth: the battle spawn and the
# party sheet both call this (master.html §11 — the two must never
# drift; same precedent as apply_passive). Constitution/Attack/resists
# always; max_hp and armor only once a spec declares them (the
# Berserker leads — 175 HP / 15% armor keeps his effective HP against
# physical within 0.3% of the old 154 / 25%, trading mitigation for a
# bigger visible pool: more Frenzy runway, more Rage from being hit).
# parry_chance replaces the hero baseline outright (the Swordmaster is
# the only parry-stat character, as the Warden is the only Block one).
static func apply_spec_stats(cfg: Dictionary, spec: String) -> void:
	if spec == "" or not SPEC_INFO.has(spec):
		return
	var info: Dictionary = SPEC_INFO[spec]
	cfg["constitution"] = info.get("constitution", cfg.get("constitution", 100))
	cfg["attack"] = spec_attack(spec)
	cfg["resists"] = spec_resists(spec).duplicate()
	if info.has("max_hp"):
		cfg["max_hp"] = int(info["max_hp"])
	if info.has("armor"):
		cfg["armor"] = float(info["armor"])
	if info.has("parry_chance"):
		cfg["parry_chance"] = float(info["parry_chance"])
	if info.has("block_chance"):
		cfg["block_chance"] = float(info["block_chance"])


const ARCHETYPE_DESC := {
	"Ramp": "Starts weak, snowballs as the battle progresses.",
	"Rush": "Starts strong; resources dwindle as the fight drags on.",
	"Nuker": "Banks resources to unleash a single devastating turn.",
	"Pressure": "Steady damage, debuffs and DoTs, Break pressure.",
	"Healer": "Restores lost HP and mana; can revive.",
	"Warder": "Damage mitigation and protective buffs.",
	"Tank": "Absorbs and redirects damage; buffs the line.",
	"Bruiser": "Damage/tank hybrid — weakens foes with moderate damage and debuffs.",
	"Control": "Locks the battlefield down — slows, freezes, and shatters.",
}


# Specializations: ordered ids per class, plus display/passive/archetype data.
# Each spec = 1 passive (implemented via passive_id hooks in battle.gd)
# + 2 abilities appended to the core kit.
const SPEC_IDS := {
	"warrior": ["berserker", "warden", "swordmaster"],
	"mage": ["pyromancer", "cryomancer", "arcanist"],
	"cleric": ["holy", "inquisitor", "occultist"],
	"hunter": ["beastmaster", "sharpshooter", "mystic"],
}


# Batch W (DOD_SIM_ROTATE=1): the sim rotation schedule, shared by the
# sweep (n = battle index) and the run harness (n = run index). The base
# n term makes any 3 consecutive counters sample each class's three specs
# exactly once — evenness is guaranteed regardless of where a sweep stage
# starts. The drift terms (advancing every 3 and 9 counters) reshuffle
# which specs land TOGETHER, so a spec is measured across many party
# mixes instead of one fixed trio.
static func rotated_specs(n: int) -> Array:
	var order := ["warrior", "mage", "cleric", "hunter"]
	var third := int(n / 3.0)
	var ninth := int(n / 9.0)
	var out: Array = []
	for i in order.size():
		var drift: int = third * i + (ninth if i >= 2 else 0)
		out.append(SPEC_IDS[order[i]][(n + i + drift) % 3])
	return out


# Spec passives that are plain stat changes live here so both the battle
# spawner and the character sheet apply them identically.
# VAULTED — Bulwark (was the Warden passive): +10% armor, +30 Constitution.
static func apply_passive(cfg: Dictionary, spec: String) -> void:
	match SPEC_INFO[spec]["passive"]:
		"heavy_plating":
			# The Warden's Block stat moved into the spec stat block (Batch G:
			# 10% base via apply_spec_stats); the passive's +15% and its
			# climbing pity bonus live inside the block roll (battle.gd).
			pass

const SPEC_INFO := {
	"berserker": {"name": "Berserker", "constitution": 110, "archetype": "Ramp", "passive": "bloodrage",
		"max_hp": 175, "armor": 0.15,
		"resists": {"shadow": 0.10, "nature": 0.10, "frost": -0.15},
		"passive_desc": "Blood Frenzy: +2% damage for every 5% of health missing.\nHalf the highest bonus reached each battle is kept as a\nfloor — his fury never fully cools.",
		"blurb": "Reckless savagery — grows stronger as their blood spills."},
	"warden": {"name": "Warden", "constitution": 130, "archetype": "Tank", "passive": "heavy_plating",
		"max_hp": 200, "armor": 0.32, "block_chance": 0.10,
		"resists": {"fire": 0.15, "frost": 0.15, "arcane": -0.20},
		"passive_desc": "Heavy Plating: +15% Block chance. Every attack against\nthe Warden that is NOT Blocked raises his Block chance\nby 8% for the rest of the battle (up to +40%);\nBlocking resets the bonus.",
		"blurb": "Protector of the weak — shields allies with their own body."},
	"swordmaster": {"name": "Swordmaster", "constitution": 120, "archetype": "Bruiser", "passive": "seasoned",
		"max_hp": 165, "armor": 0.22, "parry_chance": 0.12,
		"passive_desc": "Seasoned Fighter: fights in one of two stances.\nAGGRESSIVE — +15% damage dealt, +10% damage taken.\nDEFENSIVE — 15% less damage taken, -10% damage dealt.\nStarts each battle Aggressive; Guard Change swaps.",
		"blurb": "Precision and technique — presses hard, then weathers the storm."},
	# The Pyromancer and Cryomancer are mirror-image glass cannons: armoured
	# in their own element, soft to the opposite — a fire warband and a frost
	# warband ask different questions of the same party.
	"pyromancer": {"name": "Pyromancer", "constitution": 85, "archetype": "Nuker", "passive": "overburn",
		"max_hp": 135, "armor": 0.08,
		"resists": {"fire": 0.30, "frost": -0.20},
		"passive_desc": "Overburn: +2% damage for every turn of Burn standing on\nthe enemy team, up to +40% — but at the start of each of\nhis turns he loses 1 Mana for every one of those turns,\nand THAT has no cap. Every turn of Burn he CONSUMES\nrefunds 1 Mana.",
		"blurb": "Aggressive flame — spend everything, or the fire spends you."},
	# The passive ID stays "permafrost" (Batch AS renamed the PASSIVE to
	# GLACIAL HOLD; the id is a key battle.gd matches on, like the
	# Survivalist's spec id "mystic", and renaming it buys nothing).
	"cryomancer": {"name": "Cryomancer", "constitution": 85, "archetype": "Control", "passive": "permafrost",
		"max_hp": 135, "armor": 0.08,
		"resists": {"frost": 0.30, "fire": -0.20},
		"passive_desc": "Glacial Hold: Chilled stacks the Cryomancer applies never\nexpire, and a Frozen enemy stays Frozen INDEFINITELY — it\nleaves the turn order until he releases it with Ice Lance or\nShatter, or freezes past his limit (which frees the oldest).\nNothing else thaws it: not ally damage, not his own Blizzard,\nnot time. A held enemy takes +15% damage from all sources,\nand comes back on 1 stack of Chilled. He holds ONE enemy.\nBosses resist the freeze until Broken and shrug a hold after\none turn.",
		"blurb": "Battlefield control — you decide when the enemy acts."},
	# The Arcanist's health bar is a resource he spends (like the Devout's):
	# Resonance bills him a COMPOUNDING damage-taken penalty and Cannon recoils
	# 15%, so he carries the class's biggest pool — and no armor to speak of,
	# because raw energy in robes stops nothing that closes the distance.
	"arcanist": {"name": "Arcanist", "constitution": 90, "archetype": "Ramp", "passive": "resonance",
		"max_hp": 155, "armor": 0.06,
		"resists": {"arcane": 0.20, "shadow": 0.10, "physical": -0.15},
		"passive_desc": "Runaway Resonance: damaging casts build stacks (2 on a crit) with NO\nMAXIMUM, and nothing removes them. The bonuses COMPOUND: at N stacks\n+1.5% x N(N+1)/2 damage and +0.75% x N(N+1)/2 damage taken, plus a\nflat +1% crit per stack. 5 stacks = +22%/+11%; 12 = +117%/+59%.",
		"blurb": "Unstable raw magic — nothing early, everything late."},
	"holy": {"name": "Holy", "constitution": 100, "archetype": "Healer", "passive": "mercy",
		"max_hp": 150, "armor": 0.10,
		"resists": {"holy": 0.20, "shadow": -0.15},
		"passive_desc": "Mercy: gain a stack when an ally falls below 50% health (max 5).\nEach stack: +5% healing done. Spend stacks on Hymn of Hope and\ntalent abilities, or +1 stack to Empower a heal — Empowered casts\nforgo their perfect bonus.",
		"blurb": "Pure vessel of light — mercy hardens into miracles."},
	"inquisitor": {"name": "Devout", "constitution": 110, "archetype": "Warder", "passive": "conviction",
		"max_hp": 175, "armor": 0.18,
		"resists": {"holy": 0.15, "fire": 0.10, "shadow": -0.10},
		"passive_desc": "Conviction: allies build Faith whenever Divine Shield absorbs damage\nfor them — 2 a hit, max 5 stacks, doubled under Blessing of Zeal.\nEach stack: 2% damage mitigation and +1.5% damage dealt, PAID ON THE\nHIGHEST COUNT HELD THIS BATTLE — Apostle adds another 1x and Fervor\nanother on Consecrated Ground, so both together are triple, not\nquadruple. At 5 the ally is healed for 15% of max health, the COUNT\nresets — the peak does not, so a release never takes the benefit away\n— and the Devout recovers 3% max Mana. THE DEVOUT CARRIES FAITH OF\nHIS OWN, and his count never releases at all.",
		"blurb": "A living shrine — faith made armor for the whole party."},
	"occultist": {"name": "Occultist", "constitution": 95, "archetype": "Pressure", "passive": "old_gods",
		"max_hp": 155, "armor": 0.08,
		"resists": {"shadow": 0.25, "nature": 0.10, "fire": -0.20},
		"passive_desc": "Wrath of the Old Gods: every debuff you apply marks the target\nwith 2 Ruin. The marks have NO MAXIMUM and never wash off. Each\nstack: +2% damage taken, and heroes striking a Ruined target heal\n2% of the damage dealt per stack (up to 40%). One turn after every\ntenth stack, Ruin detonates — 90% of Attack as shadow damage, the\nparty heals 25% of your max health, and THE STACKS SURVIVE IT.",
		"blurb": "Forbidden rites — leech life and trade blood for power."},
	# Hunter stat blocks (Batch Q). The Beastmaster's armor is a multiplier
	# across up to three bodies — companions inherit it at summon — so it
	# sits below the Survivalist's despite similar Constitution.
	"beastmaster": {"name": "Beastmaster", "constitution": 100, "archetype": "Ramp", "passive": "pack",
		"max_hp": 160, "armor": 0.15,
		"resists": {"nature": 0.20, "physical": 0.05},
		"passive_desc": "Pack Bond — the active beast grants its boon: Ursus, Savage\nPresence: enemies are drawn to the bear and you take 10% less\ndamage; Canis: +15% damage per enemy under 35% health; Aguila: the\nwhole party gains +10% crit. LOYALTY (per beast, NO MAXIMUM): +1\neach turn it stands with you and on summon/swap; +5% strike damage\nper stack plus a beast-specific gift, and the boon itself grows 20%\na stack — x2 at five, and it keeps climbing. A meter dies with its\nbeast.",
		"blurb": "The wilds hunt beside them — every kill is shared."},
	# The lightest Hunter: a marksman who wants to be at range and pays for
	# being reached.
	"sharpshooter": {"name": "Sharpshooter", "constitution": 90, "archetype": "Nuker", "passive": "lethal_aim",
		"max_hp": 140, "armor": 0.10,
		"resists": {"nature": 0.10, "physical": -0.10},
		"passive_desc": "Lethal Aim: critical hits deal x2 damage instead of\nx1.5. Each consecutive attack against the same enemy\ngrants +20 FOCUS (NO CEILING; cleared on switching\ntargets, 50 retained on a kill). The first 100 points\neach grant +0.5% critical chance; every point past 100\ngrants +0.5% CRITICAL MULTIPLIER instead — patience\nbuys certainty first, then force, and never stops.",
		"blurb": "Every arrow an execution — patient, precise, final."},
	# The toughest Hunter by design: his passive rewards being struck and
	# Tripwire wants him in the fray. Deep nature affinity from a life
	# spent in it; raw arcane is the thing the woods teach nothing about.
	"mystic": {"name": "Survivalist", "constitution": 100, "archetype": "Pressure", "passive": "trapper",
		"max_hp": 170, "armor": 0.18,
		"resists": {"nature": 0.25, "shadow": 0.10, "arcane": -0.15},
		"passive_desc": "Trapper: enemies that strike the Hunter have a 25% chance\nto be Poisoned (5 turns), and the Survivalist's abilities\ndeal +8% damage per DIFFERENT status effect afflicting\nthe target — breadth of control IS the damage.",
		"blurb": "Endures the wilds and bleeds them dry — traps, powder, and steel."},
}


static func spec_abilities(spec: String) -> Array:
	match spec:
		"berserker":
			return [
				Ability.make({"display_name": "Bloodlust", "cost": 25, "damage": 26,
					"pressure": 18, "delay": 3.0, "anim": "attack02", "heal_missing": 0.3,
					"resource_gain": 10, "cooldown": 2,
					"perfect_id": "", "perfect_text": "Heals 45% of missing HP instead",
					"description": "Strike and drink deep: heals the Warrior\nfor 30% of their missing HP. Builds 10 Rage."}),
				Ability.make({"display_name": "Wildstrikes", "cost": 35, "damage": 16,
					"pressure": 14, "delay": 4.5, "anim": "attack03", "aoe": true,
					"bleed_build": 35, "bleed_chance": 0.5, "resource_gain": 10, "cooldown": 3,
					"perfect_id": "", "perfect_text": "Bleed lands on every target",
					"description": "Savage sweep: hits ALL enemies; each\nhas a 50% chance to build 35 Bleed.\nBuilds 10 Rage."}),
				Ability.make({"display_name": "Hack and Slash", "cost": 20, "damage": 10,
					"pressure": 10, "delay": 3.0, "anim": "attack01", "multi_hits": 3,
					"perfect_extra_hit": false,
					"bleed_build": 25, "bleed_chance": 0.5, "resource_gain": 10, "cooldown": 2,
					"perfect_id": "", "perfect_text": "Bleed lands on every strike.",
					"description": "Three savage cuts at one target; each\nhit has a 50% chance to build 25 Bleed —\na full flurry can bleed them out.\nBuilds 10 Rage."}),
			]
		"warden":
			# VAULTED — Retaliation (counter stance): kept for future return.
			# Shieldwall v1 (party -25% damage, 2 turns) was DELETED in Batch
			# AB: Batch G had already replaced it and its leftover machinery
			# was applying nothing. The live Shieldwall is the Block stance.
			# Damage %s are tuned against the Warden's 75 Attack (Tank role):
			# Mocking 27% ≈ 20, Crushing 43% ≈ 32 — the pre-scaling numbers.
			return [
				Ability.make({"display_name": "Mocking Blow", "cost": 0, "damage": 27, "pressure": 15,
					"resource_gain": 10, "delay": 2.0, "anim": "attack01", "cooldown": 1,
					"perfect_id": "", "perfect_text": "Taunts last 5 turns",
					"description": "Strike and humiliate: the target AND\none other enemy must attack the Warrior\nfor 4 turns. Builds 10 Rage."}),
				Ability.make({"display_name": "Crushing Blow", "cost": 20, "damage": 43,
					"pressure": 20, "delay": 3.0, "anim": "attack03", "resource_gain": 10,
					"cooldown": 2,
					"applies_status": {"id": "sunder", "turns": 3},
					"perfect_id": "", "perfect_text": "+5 bonus BD",
					"description": "Moderate damage. Sunders armor\n(-35%) for 3 turns. Builds 10 Rage."}),
				# Shieldwall graduated from the talent tree (Batch G): his one
				# moment of control over the Block identity belongs in the base
				# kit. Batch AB made it a STANCE — it and Interpose were the
				# same verb pointed two ways, and the self-directed half was
				# the stronger. He now guarantees the line and gambles for
				# himself; the wd_shieldwall node buys duration.
				Ability.make({"display_name": "Shieldwall", "cost": 25,
					"special": "shield_block", "delay": 1.5, "anim": "attack01",
					"cooldown": 2,
					"perfect_id": "", "perfect_text": "Holds a third turn",
					"description": "Set the wall: +25% Block chance for\n2 turns. These count as HEAVY PLATING\nblocks, so they feed Tenacity and\nRally — Interpose's charges never do."}),
			]
		"swordmaster":
			return [
				Ability.make({"display_name": "Overpower", "cost": 25, "damage": 15,
					"pressure": 20, "delay": 2.5, "anim": "attack02", "resource_gain": 10,
					"cooldown": 1,
					"perfect_id": "rage5", "perfect_text": "+5 bonus Rage",
					"description": "Exploits instability: +0.5 damage per\npoint of the target's Break meter;\na Broken target is held Broken one\nturn longer. Builds 10 Rage."}),
				Ability.make({"display_name": "Pommel Strike", "cost": 20, "damage": 25,
					"pressure": 30, "delay": 2.0, "anim": "attack01", "resource_gain": 10,
					"cooldown": 3,
					"applies_status": {"id": "stunned", "turns": 1},
					"perfect_id": "", "perfect_text": "The Stun lands even on a boss.",
					"description": "A skull-ringing bash with a keen 25%\ncrit chance: ALWAYS Stuns for 1 turn.\nBuilds 10 Rage.\nBosses resist Stun until Broken —\nunless the strike is PERFECT."}),
				# Batch AK put Guard Change back in the opening three (see
				# trimmed_kit_ability for why) — not a free action on
				# purpose: turn-less actions need engine support, so the
				# swap does double duty (stance, pressure, refuel) at a
				# bargain 1.5 initiative. The 1cd stops spam.
				Ability.make({"display_name": "Guard Change", "cost": 0,
					"special": "guard_change", "delay": 1.5, "anim": "attack01",
					"cooldown": 1, "resource_gain": 15,
					"perfect_id": "", "perfect_text": "+10% parry chance for 2 turns",
					"description": "Shift to the other stance mid-flow.\nThe pivot presses the opening: 15 BD\nto the enemy nearest to Breaking.\nBuilds 15 Rage."}),
			]
		"pyromancer":
			# Burn-centric kit (07-16 rework; the core Magic Bolt becomes
			# Fireball via apply_kit_overrides). Batch AR made Detonation the
			# win condition and re-specced Flame Shield into Immolate, so the
			# spec has no defensive option anywhere in kit or tree — that is
			# deliberate, and it is the whole point of the commitment spec.
			# Pyroblast and Phoenix Rebirth came OUT of the vault as tree
			# nodes. STILL VAULTED: Flame Surge (20 Mana, 15% AoE cone).
			return [
				Ability.make({"display_name": "Detonation", "cooldown": 2, "dmg_type": "fire", "cost": 25,
					"damage": 25, "pressure": 20, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Also applies 2 turns of Burn",
					"description": "The narrow release valve: consumes ONE\ntarget's Burn, adding 250% of its\nremaining damage (tick × turns left\n× 2.5) to this hit. Overburn refunds\n1 Mana for every turn consumed."}),
				Ability.make({"display_name": "Wildfire", "cooldown": 3, "dmg_type": "fire", "cost": 20,
					"damage": 0, "pressure": 10, "delay": 2.5, "anim": "attack02",
					"special": "wildfire",
					"perfect_id": "", "perfect_text": "Consumes 2 turns from each instead",
					"description": "The WIDE release valve: every burning\nenemy loses a turn of Burn and takes\n18% of Attack in fire. Detonation\nempties one bank; this one skims them\nall — and Overburn refunds every\nturn it takes."}),
				Ability.make({"display_name": "Flamewave", "cooldown": 2, "dmg_type": "fire", "cost": 25,
					"damage": 15, "pressure": 5, "delay": 3.0, "anim": "attack03", "aoe": true,
					"perfect_id": "", "perfect_text": "3 turns of Burn instead",
					"description": "A rolling wall of fire rakes ALL\nenemies: applies 2 turns of Burn;\nthose already Burning burn 2 turns\nlonger instead."}),
			]
		"cryomancer":
			# Control kit (Batch O: Razor Ice concentrates on ONE target — the
			# spec's win condition is 4 stacks on a chosen enemy, so its main
			# applier stopped scattering them). VAULTED — kept for future
			# return: Frost Bolt (25 Mana spear, 50% double vs unchilled).
			return [
				Ability.make({"display_name": "Razor Ice", "cooldown": 3, "dmg_type": "frost", "cost": 25,
					"damage": 15, "pressure": 10, "delay": 2.5, "anim": "attack02",
					"multi_hits": 3, "perfect_extra_hit": false,
					"applies_status": {"id": "chilled", "turns": 3},
					"perfect_id": "", "perfect_text": "Deals 25% of Attack instead",
					"description": "Three razor shards driven into ONE\ntarget; every shard applies a stack\nof Chilled — three quarters of a hold\nin a single cast."}),
				Ability.make({"display_name": "Blizzard", "cooldown": 4, "dmg_type": "frost", "cost": 30,
					"damage": 15, "pressure": 10, "delay": 3.5, "anim": "attack03", "aoe": true,
					"perfect_id": "", "perfect_text": "Two stacks of Chilled on every enemy.",
					"description": "Storm of ice rakes ALL enemies,\nlayering 1-2 stacks of Chilled\non each. It does NOT thaw a hold —\nno damage does."}),
				Ability.make({"display_name": "Ice Lance", "cooldown": 2, "dmg_type": "frost", "cost": 25,
					"damage": 35, "pressure": 15, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Deals 20 BD instead",
					"description": "A frozen spear driven deep: +5% of\nAttack per Chilled stack on the target,\nand it ALWAYS crits against Frozen\ntargets. Cast on a HELD enemy it is\nthe RELEASE — the ice breaks and the\nenemy returns on 1 stack of Chilled."}),
			]
		"arcanist":
			# Resonance-engine kit (07-20 rework; core Magic Bolt becomes Arcane
			# Explosion via apply_kit_overrides). BATCH AT: **DEATH RAY IS OUT
			# OF THE VAULT AND STABILIZE IS IN THE SPEC POOL.** Stabilize was
			# the escape hatch from the ramp — it vents the stacks the whole
			# spec exists to build — so it becomes something a player EARNS if
			# they want the safety valve back, and its def moved to
			# `trimmed_kit_ability` (exactly ONE def, the AK resolver rule).
			# Death Ray is what a ramp is FOR: a button greyed out for the
			# first four turns and then the only thing he wants to press.
			# Cannon KEEPS BD = 5 x stacks and its 15% recoil; its own
			# +7.5%-per-stack damage term is GONE — the passive compounds now,
			# and an ability-side per-stack term would square it.
			return [
				Ability.make({"display_name": "Arcane Cannon", "cooldown": 2, "dmg_type": "arcane", "cost": 25, "damage": 40,
					"pressure": 0, "delay": 3.5, "anim": "attack02", "recoil_base": 0.15,
					"perfect_id": "", "perfect_text": "Costs 3.0 initiative instead",
					"description": "Channel raw Resonance into a blast:\n40% of Attack, and BD = 5 x current\nstacks. Recoil: the Mage takes 15%\nof the damage dealt."}),
				Ability.make({"display_name": "Arcane Barrage", "cooldown": 2, "dmg_type": "arcane", "cost": 20, "damage": 8,
					"pressure": 3, "delay": 2.5, "anim": "attack03", "random_hits": 6,
					"perfect_extra_hit": false,
					"perfect_id": "", "perfect_text": "No two bolts strike the same enemy.",
					"description": "Six bolts hound the weakest: each\nstrikes one of the 2-3 enemies with\nthe lowest health."}),
				# BATCH AU: gate 5 -> 8 Resonance, cost 40 -> 55 Mana. At twelve
				# stacks it lands 325% of Attack in one hit, so it is a genuinely
				# LATE button now rather than a turn-five one — and at a Mage's 22
				# regen, 55 Mana is most of three turns' saving with Cannon and
				# Barrage competing for the same pool. Damage, initiative, cooldown
				# and target count are UNCHANGED and it still consumes nothing.
				# STILL NO BREAK DAMAGE — reported, not acted on (see CLAUDE.md).
				Ability.make({"display_name": "Death Ray", "cooldown": 3, "dmg_type": "arcane", "cost": 55,
					"damage": 150, "pressure": 0, "delay": 5.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "",
					"description": "The payoff: 150% of Attack as arcane\nto one enemy. Unusable below 8\nResonance — and it CONSUMES NO\nSTACKS. The ramp never comes down."}),
			]
		"holy":
			# Mercy kit (07-22 rework): heals scale off the CASTER's max
			# health; Mercy stacks fuel Hymn and Empowered casts. VAULTED —
			# kept for future return: Dawnbreak (20 Mana flat 40, overflow).
			#
			# BATCH AV — FOUR ABILITIES, WHERE EVERY OTHER SPEC HAS THREE, AND
			# THAT IS DELIBERATE. Resurrection is the thing that most means
			# "nothing is final", and as a row-5 node it was a pick most builds
			# skipped. She attacks at 50, so her abilities are not PART of her
			# contribution — they are all of it, and the parity break buys the
			# identity. Its def is NOT copied here: `pending_talent_ability`
			# stays the single source (the AK resolver rule), because the Rune
			# of the Last Rites still grants it by name and both must read the
			# same numbers. It LEFT `SPEC_POOLS["holy"]` for the same reason.
			return [
				Ability.make({"display_name": "Heal", "cooldown": 1, "cost": 20, "special": "holy_heal",
					"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Cleric also recovers 5% max health",
					"description": "Mend an ally for 40% of the Cleric's\nmax health. Empower (1 Mercy): also\ncleanses all harmful effects."}),
				Ability.make({"display_name": "Renewal", "cooldown": 3, "cost": 20, "special": "renewal",
					"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Also heals 5% of the Cleric's health instantly",
					"description": "Ally heals 15% of the Cleric's max\nhealth at the start of each of their\nturns, for 5 turns. Empower (1 Mercy):\nRenewal also blankets the Cleric."}),
				Ability.make({"display_name": "Hymn of Hope", "cooldown": 2, "cost": 0, "faith_cost": 1,
					"special": "hymn", "delay": 3.5, "anim": "attack03",
					"perfect_id": "", "perfect_text": "Heals 25% instead",
					"description": "Spend 1 Mercy: heal ALL allies for\n20% of their max health. Empower\n(+1 Mercy): 35% instead."}),
				pending_talent_ability("Resurrection"),
			]
		"inquisitor":
			# Conviction kit (07-23 rework). VAULTED — kept for future return:
			# Divine Wrath (25 Mana party +15% damage/speed) and the old flat
			# Divine Shield. Sacred Resolve (ex-Unity) and Bulwark of Fortitude
			# are talent-granted (pending_talent_ability).
			return [
				Ability.make({"display_name": "Divine Shield", "cooldown": 2, "cost": 15, "special": "divine_shield",
					"target": Ability.Target.ALLY, "delay": 2.5, "anim": "attack03",
					"perfect_id": "", "perfect_text": "Absorbs 35% instead",
					"description": "Grant an ally a holy shield that\nabsorbs 30% of the Devout's max\nhealth, then breaks."}),
				Ability.make({"display_name": "Consecrated Ground", "cooldown": 3, "cost": 25, "special": "cons_ground",
					"delay": 3.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "Lasts 3 turns",
					"description": "Holy ground blooms underfoot: the\nparty takes 15% less damage and\nreflects 10% of damage taken,\nfor 2 turns."}),
				Ability.make({"display_name": "Blessing of Zeal", "cooldown": 2, "cost": 20, "special": "zeal",
					"target": Ability.Target.ALLY, "delay": 2.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Lasts 4 turns",
					"description": "Kindle an ally: +15% damage for\n3 turns, their cooldowns tick down\n1 turn NOW, and their Faith gain is\ndoubled while the zeal burns."}),
			]
		"occultist":
			# Old Gods kit (07-24 rework). VAULTED — kept for future return:
			# Umbral Sigil (20 Mana warband brand) and the old Mind Flay
			# (maddened abilities at +100% BD). Mass Hysteria and the new
			# Mind Flay are talent-granted (pending_talent_ability).
			return [
				Ability.make({"display_name": "Hex of Ruin", "cooldown": 2, "dmg_type": "shadow", "cost": 20, "damage": 20,
					"pressure": 15, "delay": 2.5, "anim": "attack02", "choose_three": true,
					"applies_status": {"id": "exposed", "turns": 3},
					"perfect_id": "", "perfect_text": "No cooldown",
					"description": "Curse THREE chosen enemies: 20% of\nAttack in shadow each, leaving them\nExposed for 3 turns."}),
				Ability.make({"display_name": "Bewitch", "cooldown": 4, "cost": 25,
					"special": "bewitch", "delay": 3.5, "anim": "attack03",
					"perfect_id": "", "perfect_text": "The target attacks instantly",
					"description": "Charm a mind — for 3 turns the target\nbasic-attacks its OWN allies, Dazing\nthem with every strike.\nA BOSS RESISTS UNTIL BROKEN."}),
				Ability.make({"display_name": "Dark Pact", "cooldown": 3, "cost": 20,
					"special": "dark_pact", "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Restores 5 Mana",
					"description": "Bleed for them: lose 20% max health;\nevery OTHER ally heals 15% of their\nmax health, and the Occultist regains\n30% of max health over 3 turns."}),
			]
		"beastmaster":
			return [
				Ability.make({"display_name": "Summon Ursus", "cooldown": 3, "cost": 20, "special": "summon",
					"delay": 3.0, "anim": "attack01", "no_skill_check": true,
					"perfect_id": "", "perfect_text": "",
					"description": "Call the bear (110 HP): attacks with\nyou, striking your target AND adjacent\nenemies for 10% of your Attack.\nSavage Presence: enemies are drawn to\nUrsus; you take 10% less damage.\nOn arrival: GUARDIAN'S ROAR — taunts\nthe weakest enemy, bear takes 25% less\ndamage for 2 turns.\nLoyalty gift: +3% max health per stack."}),
				Ability.make({"display_name": "Summon Canis", "cooldown": 3, "cost": 20, "special": "summon",
					"delay": 3.0, "anim": "attack01", "no_skill_check": true,
					"perfect_id": "", "perfect_text": "",
					"description": "Call the wolf (80 HP): attacks with you\nfor 20% of your Attack, building\n20 Bleed. Always ELUSIVE: enemies miss\nit 25% more. Pack Bond: +15% damage\nper enemy under 35% health.\nOn arrival: BLOODHOWL — 15 Bleed\nto every enemy.\nLoyalty gift: +2 Bleed per stack."}),
				Ability.make({"display_name": "Summon Aguila", "cooldown": 3, "cost": 20, "special": "summon",
					"delay": 3.0, "anim": "attack01", "no_skill_check": true,
					"perfect_id": "", "perfect_text": "",
					"description": "Call the eagle (80 HP): attacks with you\nfor 20% of your Attack, applying\nExposed. Always ELUSIVE: enemies miss\nit 25% more. Pack Bond: the whole\nparty gains +10% crit chance.\nOn arrival: dives a chosen enemy for\n15% of your Attack, Dazing them.\nLoyalty gift: ignores 20% armor\nper stack."}),
				Ability.make({"display_name": "Hunter's Instinct", "cooldown": 3, "cost": 20, "special": "instinct",
					"delay": 2.5, "anim": "attack01", "no_skill_check": true,
					"perfect_id": "", "perfect_text": "",
					"description": "Empower your next 3 Quick Shots:\neach deals +10% of your Attack and\nheals your companion for 15% of\nits max health."}),
				Ability.make({"display_name": "Kill Command", "cooldown": 3, "cost": 30, "special": "kill_command",
					"delay": 4.0, "anim": "attack01",
					"perfect_id": "", "perfect_text": "The beast gains 1 Loyalty",
					"description": "The order depends on the beast —\nUrsus: mauls for 45% of your Attack\nplus 40 Break damage. Canis: 3 bites\nof 18% Attack, 10 Bleed each; the wolf\nfeasts, healing 30% of its max health.\nAguila: strikes TWO chosen enemies for\n25% Attack, BLINDING them 3 turns.\nRequires a living companion.\nThe Pack: BOTH beasts obey."}),
			]
		"sharpshooter":
			return [
				Ability.make({"display_name": "Aimed Shot", "cooldown": 1, "cost": 20, "damage": 45,
					"pressure": 15, "delay": 3.0, "anim": "attack02",
					"perfect_id": "focus20", "perfect_text": "+20 Focus",
					"description": "A perfect line. Patient, precise, final."}),
				Ability.make({"display_name": "Powershot", "cooldown": 2, "cost": 25, "damage": 20,
					"pressure": 20, "delay": 3.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "",
					"description": "+2% damage for every point of the\ntarget's Break bar already FULL —\nthe team breaks them, the marksman\nends them."}),
				Ability.make({"display_name": "Hold Breath", "cooldown": 3, "cost": 15, "special": "hold_breath",
					"delay": 1.5, "anim": "attack01", "no_skill_check": true,
					"perfect_id": "", "perfect_text": "",
					"description": "Patience made literal: gain +40 Focus,\nand your next attack is a GUARANTEED\ncritical that ignores all armor."}),
			]
		"mystic":
			return [
				Ability.make({"display_name": "Tripwire", "cooldown": 4, "cost": 20, "special": "tripwire",
					"delay": 2.0, "anim": "attack01",
					"perfect_id": "", "perfect_text": "Lasts 6 turns",
					"description": "Rig the ground: for 5 turns, retaliate\nagainst EVERY attacking melee enemy —\neven those striking your allies."}),
				Ability.make({"display_name": "Shrapnel Charge", "cooldown": 2, "dmg_type": "nature",
					"cost": 25, "damage": 20,
					"pressure": 25, "delay": 3.0, "anim": "attack03", "choose_two": true,
					"applies_status": {"id": "cripple", "turns": 3},
					"perfect_id": "status_plus", "perfect_text": "Adds Slowed; everything lasts 4 turns",
					"description": "A scattering charge rips TWO chosen\nenemies for 20 nature damage each,\nleaving them Poisoned AND Crippled\n(3 turns). Two statuses on two targets\n— the engine of the hunt."}),
				Ability.make({"display_name": "Snare Trap", "cooldown": 3, "cost": 20, "special": "snare_trap",
					"delay": 2.0, "anim": "attack01",
					"perfect_id": "", "perfect_text": "The Stun lands even on a boss.",
					"description": "Rig a snare on one enemy: the next\ntime it acts, it is STUNNED for 1 turn\nand Poisoned for 4. Bosses shrug off\nthe stun unless Broken — unless the\nsnare was rigged PERFECTLY."}),
			]
	return []

const CLASS_BLURBS := {
	"hunter": "Ranged damage. Mana fuels precision payoffs\nand primal magic.",
	"warrior": "Flexible frontliner. Rage builds through attack and pain.",
	"mage": "Glass cannon. Fire that spreads, frost that controls, and\nraw Resonance banked for devastating payoffs.",
	"cleric": "Divine vessel of the light — smite, mend, and shepherd the party.",
}
