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
				"resource_name": "Focus", "resource": 100, "max_resource": 100,
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
				"second_resource_name": "Faith", "second_resource": 0, "second_max": 100,
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
			"perfect_id": "focus", "perfect_text": "+10 bonus Focus",
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
	return [
		# damage 44 = 44% of the Cleric's 50 Attack -> the familiar 22.
		Ability.make({"display_name": "Smite", "dmg_type": "holy", "cost": 0, "damage": 44, "pressure": 16,
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "self_heal", "perfect_text": "Cleric recovers 8 HP",
			"description": "Basic radiant strike. Builds Faith."}),
		Ability.make({"display_name": "Mend Wounds", "cooldown": 1, "cost": 25, "heal": 45,
			"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
			"perfect_id": "ward", "perfect_text": "Grants Ward (-50% Pressure taken, 2 turns)",
			"description": "Restore HP to one ally. Builds Faith."}),
		Ability.make({"display_name": "Resurrection", "cooldown": 5, "cost": 0, "faith_cost": 40,
			"special": "resurrection", "target": Ability.Target.ALLY,
			"delay": 4.0, "anim": "attack03",
			"perfect_id": "", "perfect_text": "",
			"description": "MIRACLE: return a fallen ally to life\nwith 20% health and resource."}),
	]


# Spec kit corruption: the Occultist's Smite is warped into Shadowrend,
# the Pyromancer's Magic Bolt burns as Fireball. Applied by battle spawn
# AND the party screen.
static func apply_kit_overrides(cfg: Dictionary, spec: String) -> void:
	if spec == "occultist":
		cfg["abilities"][0] = Ability.make({"display_name": "Shadowrend",
			"dmg_type": "shadow", "cost": 0, "damage": 22, "pressure": 16,
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "self_heal", "perfect_text": "Cleric recovers 8 HP",
			"description": "Basic strike of gnawing shadow.\nBuilds Faith."})
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
			"description": "A shard of biting cold: applies 1 stack\nof Chilled (4 stacks freeze the target\nsolid)."})


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
# Attack; Attack (and max HP) scale +1% of base per completed combat node.
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


# Spec passives that are plain stat changes live here so both the battle
# spawner and the character sheet apply them identically.
# VAULTED — Bulwark (was the Warden passive): +10% armor, +30 Constitution.
static func apply_passive(cfg: Dictionary, spec: String) -> void:
	match SPEC_INFO[spec]["passive"]:
		"heavy_plating":
			# The pure tank's Block stat: 5% base; the passive adds another
			# 15% chance inside the block roll (battle.gd).
			cfg["block_chance"] = cfg.get("block_chance", 0.0) + 0.05

const SPEC_INFO := {
	"berserker": {"name": "Berserker", "constitution": 110, "archetype": "Ramp", "passive": "bloodrage",
		"passive_desc": "Blood Frenzy: +2% damage for every 5% of health missing.",
		"blurb": "Reckless savagery — grows stronger as their blood spills."},
	"warden": {"name": "Warden", "constitution": 110, "archetype": "Tank", "passive": "heavy_plating",
		"passive_desc": "Heavy Plating: 15% chance to Block an incoming attack\n(on top of the Warden's 5% base Block).",
		"blurb": "Protector of the weak — shields allies with their own body."},
	"swordmaster": {"name": "Swordmaster", "constitution": 120, "archetype": "Bruiser", "passive": "seasoned",
		"passive_desc": "Seasoned Fighter: +15% damage above half HP;\ntakes 15% less damage at or below half HP.",
		"blurb": "Precision and technique — presses hard, then weathers the storm."},
	"pyromancer": {"name": "Pyromancer", "constitution": 85, "archetype": "Nuker", "passive": "inferno",
		"passive_desc": "Inferno Master: +5% damage for each burning enemy (up to +25%).",
		"blurb": "Aggressive flame — burns that spread and stack."},
	"cryomancer": {"name": "Cryomancer", "constitution": 85, "archetype": "Control", "passive": "permafrost",
		"passive_desc": "Permafrost: Frozen enemies take 15% increased damage\nfrom all sources.",
		"blurb": "Battlefield control — chill, freeze, then shatter."},
	"arcanist": {"name": "Arcanist", "constitution": 90, "archetype": "Ramp", "passive": "resonance",
		"passive_desc": "Arcane Resonance: damaging casts build stacks (max 5) — each grants\n+15% damage and +3% crit but +10% damage taken. Max stacks trigger\nBacklash Ward (+15 Mana). Stacks persist until consumed.",
		"blurb": "Unstable raw magic — stack the storm, then release it."},
	"holy": {"name": "Holy", "constitution": 100, "archetype": "Healer", "passive": "grace",
		"passive_desc": "Grace: all healing +25%.",
		"blurb": "Pure vessel of light — mass healing and shields of faith."},
	"inquisitor": {"name": "Devout", "constitution": 110, "archetype": "Warder", "passive": "devotion",
		"passive_desc": "Devotion Aura: the whole party takes 15% less Pressure.",
		"blurb": "A living shrine — faith made armor for the whole party."},
	"occultist": {"name": "Occultist", "constitution": 95, "archetype": "Pressure", "passive": "corrupt",
		"passive_desc": "Corrupted Channeling: when a Crippled enemy attacks, a random\nhero heals for half the damage it dealt.",
		"blurb": "Forbidden rites — leech life and trade blood for power."},
	"beastmaster": {"name": "Beastmaster", "constitution": 100, "archetype": "Rush", "passive": "pack",
		"passive_desc": "Pack Bond: changes with the summoned beast — Ursus: +25% Break\ndamage; Canis: attacks build 15 Bleed; Aguila: +15% crit chance.",
		"blurb": "The wilds hunt beside them — every kill is shared."},
	"sharpshooter": {"name": "Sharpshooter", "constitution": 90, "archetype": "Rush", "passive": "lethal_aim",
		"passive_desc": "Lethal Aim: critical hits deal x2 damage instead of x1.5.",
		"blurb": "Every arrow an execution — patient, precise, final."},
	"mystic": {"name": "Survivalist", "constitution": 100, "archetype": "Pressure", "passive": "trapper",
		"passive_desc": "Trapper: enemies that strike the Hunter have a 25% chance\nto be Poisoned (5 turns).",
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
					"bleed_build": 35, "resource_gain": 10, "cooldown": 3,
					"perfect_id": "", "perfect_text": "+50% Pressure on every target",
					"description": "Savage sweep: hits ALL enemies and\nbuilds 35 Bleed on each. Builds 10 Rage."}),
				Ability.make({"display_name": "Hack and Slash", "cost": 20, "damage": 10,
					"pressure": 10, "delay": 3.0, "anim": "attack01", "multi_hits": 3,
					"bleed_build": 25, "bleed_chance": 0.5, "resource_gain": 10, "cooldown": 2,
					"perfect_id": "", "perfect_text": "4 strikes instead of 3",
					"description": "Three savage cuts at one target; each\nhit has a 50% chance to build 25 Bleed —\na full flurry can bleed them out.\nBuilds 10 Rage."}),
			]
		"warden":
			# VAULTED — Shieldwall v1 (party -25% damage, 2 turns) and
			# Retaliation (counter stance): kept for future return.
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
				Ability.make({"display_name": "War Stomp", "cost": 20, "damage": 15,
					"pressure": 15, "delay": 3.0, "anim": "attack03", "cooldown": 3,
					"random_hits": 3, "perfect_extra_hit": false,
					"perfect_id": "", "perfect_text": "",
					"description": "Slam the earth: 3 shockwaves rip\nrandom enemies for 15% Attack damage\nand 15 BD each. Allies regain 10%\nof their resource."}),
			]
		"swordmaster":
			return [
				Ability.make({"display_name": "Overpower", "cost": 30, "damage": 15,
					"pressure": 20, "delay": 2.5, "anim": "attack02", "resource_gain": 10,
					"cooldown": 1,
					"perfect_id": "rage5", "perfect_text": "+5 bonus Rage",
					"description": "Exploits instability: +0.5 damage per\npoint of the target's Break meter.\nBuilds 10 Rage."}),
				Ability.make({"display_name": "Pommel Strike", "cost": 15, "damage": 25,
					"pressure": 30, "delay": 2.0, "anim": "attack01", "resource_gain": 10,
					"cooldown": 2,
					"applies_status": {"id": "stunned", "turns": 1}, "status_chance": 0.5,
					"perfect_id": "parry_up", "perfect_text": "+15% parry chance for 3 turns",
					"description": "A skull-ringing bash with a keen 25%\ncrit chance: 50% chance to Stun — a crit\nGUARANTEES it. Builds 10 Rage.\nBosses resist Stun until Broken."}),
				Ability.make({"display_name": "Sweeping Strikes", "cost": 20, "damage": 15,
					"pressure": 8, "delay": 3.0, "anim": "attack02", "multi_hits": 2,
					"perfect_extra_hit": false, "resource_gain": 10,
					"applies_status": {"id": "dazed", "turns": 3},
					"perfect_id": "", "perfect_text": "+25% crit chance on the second swing",
					"description": "Two broad cuts that leave the target\nDazed for 3 turns. Builds 10 Rage."}),
			]
		"pyromancer":
			# Burn-centric kit (07-16 rework; the core Magic Bolt becomes
			# Fireball via apply_kit_overrides). VAULTED — kept for future
			# return: Pyroblast (45 Mana, 55%, 6.0, +50% vs Burning),
			# Flame Surge (20 Mana, 15% AoE cone), Phoenix Rebirth
			# (sacrifice 25% HP -> full Mana + Empower).
			return [
				Ability.make({"display_name": "Detonation", "cooldown": 2, "dmg_type": "fire", "cost": 20,
					"damage": 15, "pressure": 20, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Also applies 1 turn of Burn",
					"description": "Ignite the wounds: consumes the target's\nBurn, adding its remaining damage\n(tick × turns left) to this hit."}),
				Ability.make({"display_name": "Wildfire", "cooldown": 3, "dmg_type": "fire", "cost": 20,
					"damage": 20, "pressure": 10, "delay": 2.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "",
					"description": "Flames leap the gap: spreads the target's\nBurn to Adjacent enemies at half its\nduration (corpses block the spread)."}),
				Ability.make({"display_name": "Flamewave", "cooldown": 2, "dmg_type": "fire", "cost": 25,
					"damage": 15, "pressure": 5, "delay": 3.0, "anim": "attack03", "aoe": true,
					"perfect_id": "", "perfect_text": "+3 turns instead",
					"description": "A rolling wall of fire rakes ALL\nenemies; those already Burning burn\n2 turns longer."}),
			]
		"cryomancer":
			# Control kit (07-18 rework; core Magic Bolt becomes Frostbolt via
			# apply_kit_overrides). VAULTED — kept for future return:
			# Frost Bolt (25 Mana spear, 50% double vs unchilled).
			return [
				Ability.make({"display_name": "Razor Ice", "cooldown": 3, "dmg_type": "frost", "cost": 20,
					"damage": 20, "pressure": 10, "delay": 2.5, "anim": "attack02",
					"random_hits": 2, "perfect_extra_hit": false,
					"applies_status": {"id": "chilled", "turns": 3},
					"perfect_id": "", "perfect_text": "Deals 25% of Attack instead",
					"description": "Razor shards at 2 random enemies;\nevery hit applies a stack of Chilled."}),
				Ability.make({"display_name": "Blizzard", "cooldown": 4, "dmg_type": "frost", "cost": 35,
					"damage": 20, "pressure": 10, "delay": 4.0, "anim": "attack03", "aoe": true,
					"perfect_id": "mana5", "perfect_text": "Refunds 5 Mana",
					"description": "Storm of ice rakes ALL enemies,\nlayering 1-2 stacks of Chilled\non each."}),
				Ability.make({"display_name": "Ice Lance", "cooldown": 2, "dmg_type": "frost", "cost": 25,
					"damage": 40, "pressure": 15, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Deals 20 BD instead",
					"description": "A frozen spear driven deep: ALWAYS\ncrits against Frozen targets."}),
			]
		"arcanist":
			return [
				Ability.make({"display_name": "Arcane Cannon", "cooldown": 1, "dmg_type": "arcane", "cost": 30, "damage": 30,
					"pressure": 15, "delay": 3.5, "anim": "attack02", "recoil_base": 0.15,
					"perfect_id": "", "perfect_text": "+5 bonus BD",
					"description": "Channel raw Resonance into a blast:\n+7.5% DAMAGE per Resonance stack.\nRecoil: the Mage takes 15% of the\ndamage dealt."}),
				# No cooldown — the 5-stack Resonance build-up IS the gate.
				Ability.make({"display_name": "Death Ray", "dmg_type": "arcane", "cost": 0, "damage": 150,
					"pressure": 100, "delay": 8.0, "anim": "attack03",
					"perfect_id": "mana15", "perfect_text": "Restores 15 Mana",
					"description": "The stored storm, released: requires\n5 Arcane Resonance and CONSUMES all of\nit. Fixed 150 damage payoff."}),
				Ability.make({"display_name": "Arcane Barrage", "cooldown": 2, "dmg_type": "arcane", "cost": 25, "damage": 5,
					"pressure": 4, "delay": 3.5, "anim": "attack03", "random_hits": 6,
					"perfect_id": "", "perfect_text": "Fires a 7th bolt",
					"description": "Six bolts rake random enemies (30 total\ndamage); every bolt can trigger Echo."}),
			]
		"holy":
			return [
				Ability.make({"display_name": "Dawnbreak", "cooldown": 1, "cost": 20, "special": "dawnbreak",
					"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "+15 bonus healing",
					"description": "Heal an ally for 40. Overhealing\nflows back to the Cleric."}),
				Ability.make({"display_name": "Renewal", "cooldown": 3, "cost": 20, "special": "renewal",
					"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Also heals 15 HP instantly",
					"description": "Ally heals 15 HP at the start of each\nof their turns, for 5 turns."}),
				Ability.make({"display_name": "Hymn of Hope", "cooldown": 5, "cost": 0, "faith_cost": 30,
					"special": "hymn", "delay": 4.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "Heals 25% instead",
					"description": "MIRACLE: heal ALL allies for 20%\nof their max HP."}),
			]
		"inquisitor":
			return [
				Ability.make({"display_name": "Divine Shield", "cooldown": 3, "cost": 30, "special": "divine_shield",
					"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "Shield absorbs 130 instead",
					"description": "Grant an ally a holy shield that\nabsorbs 100 damage, then breaks."}),
				Ability.make({"display_name": "Divine Wrath", "cooldown": 4, "cost": 25, "special": "divine_wrath",
					"delay": 3.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "Lasts 4 turns",
					"description": "The party surges with holy fury:\n+15% damage and +15% speed\nfor 3 turns."}),
				Ability.make({"display_name": "Unity", "cooldown": 5, "cost": 0, "faith_cost": 25,
					"special": "unity", "delay": 3.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "Lasts 4 turns",
					"description": "MIRACLE: bind the party's souls — all\ndamage received is split evenly among\nthem for 3 turns."}),
			]
		"occultist":
			return [
				Ability.make({"display_name": "Hex of Ruin", "cooldown": 2, "dmg_type": "shadow", "cost": 20, "damage": 15,
					"pressure": 24, "delay": 3.0, "anim": "attack02", "random_hits": 2,
					"perfect_extra_hit": false,
					"applies_status": {"id": "cripple", "turns": 3},
					"perfect_id": "status_plus", "perfect_text": "Cripple lasts 4 turns",
					"description": "Curse 2 random enemies: 15 shadow\ndamage each and Crippled for 3 turns."}),
				Ability.make({"display_name": "Mind Flay", "cooldown": 4, "dmg_type": "shadow", "cost": 30,
					"special": "mindflay", "delay": 3.5, "anim": "attack03",
					"perfect_id": "", "perfect_text": "+115% Break damage instead",
					"description": "Shatter a mind — the target attacks\nits OWN allies for 3 turns with\n+100% Break damage."}),
				Ability.make({"display_name": "Umbral Sigil", "cooldown": 4, "cost": 0, "faith_cost": 20,
					"special": "umbral_sigil", "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Lasts 4 turns",
					"description": "MIRACLE: brand a foe — its whole party\ntakes 50% of all attack damage it\nreceives (3 turns)."}),
			]
		"beastmaster":
			return [
				Ability.make({"display_name": "Summon Ursus", "cooldown": 3, "cost": 30, "special": "summon",
					"delay": 3.0, "anim": "attack01", "no_skill_check": true,
					"perfect_id": "", "perfect_text": "",
					"description": "Call the bear (80 HP): attacks with you,\nmauling your target AND a second enemy\nfor 10 damage + 20 Pressure each.\nPack Bond: your attacks deal +25%\nPressure while Ursus prowls."}),
				Ability.make({"display_name": "Summon Canis", "cooldown": 3, "cost": 30, "special": "summon",
					"delay": 3.0, "anim": "attack01", "no_skill_check": true,
					"perfect_id": "", "perfect_text": "",
					"description": "Call the wolf (60 HP): attacks with you\nfor 20 damage, 50% chance to build\n20 Bleed. Pack Bond: your attacks build\n15 Bleed while Canis hunts."}),
				Ability.make({"display_name": "Summon Aguila", "cooldown": 3, "cost": 30, "special": "summon",
					"delay": 3.0, "anim": "attack01", "no_skill_check": true,
					"perfect_id": "", "perfect_text": "",
					"description": "Call the eagle (60 HP): attacks with you\nfor 15 damage, 50% chance to Sunder.\nPack Bond: +15% crit chance while\nAguila circles."}),
				Ability.make({"display_name": "Barbed Arrow", "cooldown": 1, "cost": 20, "damage": 20,
					"pressure": 15, "delay": 2.5, "anim": "attack02",
					"applies_status": {"id": "cripple", "turns": 3},
					"perfect_id": "status_plus", "perfect_text": "Cripple lasts 4 turns",
					"description": "A cruel barb that Cripples the target\nfor 3 turns."}),
				Ability.make({"display_name": "Poisoned Arrow", "cooldown": 2, "dmg_type": "nature",
					"cost": 20, "damage": 20,
					"pressure": 15, "delay": 2.5, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Applies 4 stacks instead",
					"description": "A venom-soaked shaft: applies 3 stacks\nof Poison (3 damage per stack per turn,\n5 turns; stacks refresh the timer)."}),
				Ability.make({"display_name": "Kill Command", "cooldown": 3, "cost": 30, "special": "kill_command",
					"delay": 4.0, "anim": "attack01",
					"perfect_id": "", "perfect_text": "+50% to the ordered strike",
					"description": "Order your companion to savage a target:\ndouble damage and doubled special effect.\nRequires a living companion."}),
			]
		"sharpshooter":
			return [
				Ability.make({"display_name": "Aimed Shot", "cooldown": 1, "cost": 20, "damage": 45,
					"pressure": 15, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "+25% crit on this shot",
					"description": "A perfect line. Patient, precise, final."}),
				Ability.make({"display_name": "Powershot", "cooldown": 2, "cost": 25, "damage": 20,
					"pressure": 20, "delay": 3.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "",
					"description": "+2% damage for every point of the\ntarget's Break bar still EMPTY."}),
				Ability.make({"display_name": "Quick Draw", "cooldown": 5, "cost": 15, "special": "quickdraw",
					"delay": 2.0, "anim": "attack01",
					"perfect_id": "", "perfect_text": "Lasts 6 turns",
					"description": "Adrenaline takes over: all your abilities\nact 50% faster for 5 turns."}),
			]
		"mystic":
			return [
				Ability.make({"display_name": "Tripwire", "cooldown": 4, "cost": 20, "special": "tripwire",
					"delay": 2.5, "anim": "attack01",
					"perfect_id": "", "perfect_text": "Lasts 6 turns",
					"description": "Rig the ground: for 5 turns, retaliate\nagainst EVERY attacking melee enemy —\neven those striking your allies."}),
				Ability.make({"display_name": "Explosive Shot", "cooldown": 3, "dmg_type": "fire", "cost": 35,
					"damage": 10, "pressure": 20, "delay": 3.0, "anim": "attack03", "aoe": true,
					"perfect_id": "", "perfect_text": "Deals 12 damage",
					"description": "A bursting charge rakes ALL enemies\nwith fire and heavy Break pressure."}),
				Ability.make({"display_name": "Shrapnel Charge", "cooldown": 2, "dmg_type": "fire",
					"cost": 25, "damage": 20,
					"pressure": 25, "delay": 3.0, "anim": "attack03", "choose_two": true,
					"applies_status": {"id": "cripple", "turns": 3},
					"perfect_id": "status_plus", "perfect_text": "Cripple and Slowed last 4 turns",
					"description": "A scattering charge rips TWO chosen\nenemies for 20 fire damage each, leaving\nthem Crippled and Slowed (3 turns)."}),
			]
	return []

const CLASS_BLURBS := {
	"hunter": "Ranged damage. Focus builds with every shot, spent on\nprecision payoffs and primal magic.",
	"warrior": "Flexible frontliner. Rage builds through attack and pain.",
	"mage": "Glass cannon. Fire that spreads, frost that controls, and\nraw Resonance banked for devastating payoffs.",
	"cleric": "Divine vessel. Faith builds with every act, awaiting Miracles.",
}
