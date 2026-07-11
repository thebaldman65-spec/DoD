# Shared class data: hero configs, ability kits, and specialization flavor.
# Used by both the battle scene and the party screen.
class_name Classes

# Per-slot tints distinguish heroes until distinct class sprites arrive.
const HERO_TINTS := [Color.WHITE, Color(0.65, 0.75, 1.0), Color(1.0, 0.9, 0.6),
	Color(0.7, 1.0, 0.75)]


# Cropped close-up of the class's idle sprite, used as a list icon.
static func class_icon(key: String) -> Texture2D:
	var sheet_dir: String = hero_config(key)["sheet_dir"]
	var prefix: String = sheet_dir.get_file().capitalize()
	var tex: Texture2D = load("%s/%s_Idle.png" % [sheet_dir, prefix])
	if tex == null:
		return null
	var crop := AtlasTexture.new()
	crop.atlas = tex
	crop.region = Rect2(28, 18, 44, 60)
	return crop


static func hero_config(key: String) -> Dictionary:
	var soldier := "res://assets/sprites/soldier"
	match key:
		"hunter":
			return {"unit_name": "Hunter", "is_hero": true, "sheet_dir": soldier,
				"max_hp": 110, "armor": 0.12, "speed": 105.0, "stability": 100,
				"constitution": 95,
				"resource_name": "Focus", "resource": 100, "max_resource": 100,
				"abilities": kit(key)}
		"warrior":
			return {"unit_name": "Warrior", "is_hero": true, "sheet_dir": soldier,
				"max_hp": 154, "armor": 0.25, "speed": 95.0, "stability": 100,
				"constitution": 110,
				"resource_name": "Rage", "resource": 0, "max_resource": 100,
				"abilities": kit(key)}
		"mage":
			return {"unit_name": "Mage", "is_hero": true, "sheet_dir": soldier,
				"max_hp": 99, "armor": 0.10, "speed": 110.0, "stability": 100,
				"constitution": 85,
				"resource_name": "Mana", "resource": 100, "max_resource": 100,
				"abilities": kit(key)}
		_:
			return {"unit_name": "Cleric", "is_hero": true, "sheet_dir": soldier,
				"max_hp": 121, "armor": 0.15, "speed": 85.0, "stability": 100,
				"constitution": 100,
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


static func mage_kit() -> Array:
	return [
		Ability.make({"display_name": "Magic Bolt", "dmg_type": "arcane", "cost": 0, "damage": 25, "pressure": 14,
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "mana", "perfect_text": "Restores 10 Mana",
			"description": "Basic arcane projectile."}),
		Ability.make({"display_name": "Mana Shield", "cost": 15, "special": "mana_shield",
			"delay": 2.0, "anim": "attack03",
			"perfect_id": "", "perfect_text": "Initiative cost 1.5 instead of 2",
			"description": "Weave a shield of raw mana: 50% of\ndamage the Mage takes converts into\nMana (3 turns)."}),
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
		Ability.make({"display_name": "Smite", "dmg_type": "holy", "cost": 0, "damage": 22, "pressure": 16,
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "self_heal", "perfect_text": "Cleric recovers 8 HP",
			"description": "Basic radiant strike. Builds Faith."}),
		Ability.make({"display_name": "Mend Wounds", "cost": 25, "heal": 45,
			"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
			"perfect_id": "ward", "perfect_text": "Grants Ward (-50% Pressure taken, 2 turns)",
			"description": "Restore HP to one ally. Builds Faith."}),
	]


# Archetype outline (design north star for every spec's kit):
#   Damage — Ramp: starts weak, snowballs as the battle progresses.
#            Rush: starts strong, resources dwindle as it progresses.
#            Nuker: banks resources for one devastating turn; exploits weakened foes.
#            Pressure: steady damage, debuffs/DoTs, Break pressure.
#   Support — Healer: restores HP/mana, can revive.
#             Warder: damage mitigation and buffs.
#   Tank — Tank: absorbs and redirects damage, buffs.
#          Bruiser: damage/tank hybrid, weakens enemies, moderate damage, debuffs.
const ARCHETYPE_DESC := {
	"Ramp": "Starts weak, snowballs as the battle progresses.",
	"Rush": "Starts strong; resources dwindle as the fight drags on.",
	"Nuker": "Banks resources to unleash a single devastating turn.",
	"Pressure": "Steady damage, debuffs and DoTs, Break pressure.",
	"Healer": "Restores lost HP and mana; can revive.",
	"Warder": "Damage mitigation and protective buffs.",
	"Tank": "Absorbs and redirects damage; buffs the line.",
	"Bruiser": "Damage/tank hybrid — weakens foes with moderate damage and debuffs.",
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
static func apply_passive(cfg: Dictionary, spec: String) -> void:
	match SPEC_INFO[spec]["passive"]:
		"bulwark":
			cfg["armor"] += 0.10
			cfg["constitution"] += 30

const SPEC_INFO := {
	"berserker": {"name": "Berserker", "constitution": 110, "archetype": "Ramp", "passive": "bloodrage",
		"passive_desc": "Blood Frenzy: up to +40% damage as HP falls.",
		"blurb": "Reckless savagery — grows stronger as their blood spills."},
	"warden": {"name": "Warden", "constitution": 110, "archetype": "Tank", "passive": "bulwark",
		"passive_desc": "Bulwark: +10% armor, +30 Constitution.",
		"blurb": "Protector of the weak — shields allies with their own body."},
	"swordmaster": {"name": "Swordmaster", "constitution": 120, "archetype": "Bruiser", "passive": "seasoned",
		"passive_desc": "Seasoned Fighter: +15% damage above half HP;\ntakes 15% less damage at or below half HP.",
		"blurb": "Precision and technique — presses hard, then weathers the storm."},
	"pyromancer": {"name": "Pyromancer", "constitution": 85, "archetype": "Nuker", "passive": "ignite",
		"passive_desc": "Ignite: damaging spells have 50% chance to Burn (2 turns).",
		"blurb": "Aggressive flame — burns that spread and stack."},
	"cryomancer": {"name": "Cryomancer", "constitution": 85, "archetype": "Nuker", "passive": "chill",
		"passive_desc": "Chill: damaging spells have 50% chance to apply Chilled (2 turns).",
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
					"resource_gain": 10,
					"perfect_id": "", "perfect_text": "Heals 45% of missing HP instead",
					"description": "Strike and drink deep: heals the Warrior\nfor 30% of their missing HP. Builds 10 Rage."}),
				Ability.make({"display_name": "Wildstrikes", "cost": 35, "damage": 16,
					"pressure": 14, "delay": 4.5, "anim": "attack03", "aoe": true,
					"bleed_build": 35, "resource_gain": 10,
					"perfect_id": "", "perfect_text": "+50% Pressure on every target",
					"description": "Savage sweep: hits ALL enemies and\nbuilds 35 Bleed on each. Builds 10 Rage."}),
				Ability.make({"display_name": "Hack and Slash", "cost": 20, "damage": 10,
					"pressure": 10, "delay": 3.0, "anim": "attack01", "multi_hits": 3,
					"bleed_build": 25, "bleed_chance": 0.5, "resource_gain": 10,
					"perfect_id": "", "perfect_text": "4 strikes instead of 3",
					"description": "Three savage cuts at one target; each\nhit has a 50% chance to build 25 Bleed —\na full flurry can bleed them out.\nBuilds 10 Rage."}),
			]
		"warden":
			return [
				Ability.make({"display_name": "Mocking Blow", "cost": 0, "damage": 20, "pressure": 15,
					"resource_gain": 20, "delay": 2.0, "anim": "attack01",
					"perfect_id": "", "perfect_text": "Taunts last 5 turns",
					"description": "Strike and humiliate: the target AND\none other enemy must attack the Warrior\nfor 4 turns. Builds 20 Rage."}),
				Ability.make({"display_name": "Shieldwall", "cost": 25, "special": "shieldwall",
					"delay": 3.0, "anim": "attack01",
					"perfect_id": "", "perfect_text": "Lasts 3 turns",
					"description": "The party takes 25% less damage\nfor 2 turns."}),
				Ability.make({"display_name": "Retaliation", "cost": 20, "special": "retaliate",
					"delay": 3.0, "anim": "attack01",
					"perfect_id": "", "perfect_text": "Stance lasts 4 turns",
					"description": "For 3 turns, counter every attack\nthat strikes the Warrior."}),
			]
		"swordmaster":
			return [
				Ability.make({"display_name": "Overpower", "cost": 20, "damage": 15,
					"pressure": 20, "delay": 2.5, "anim": "attack02", "resource_gain": 10,
					"perfect_id": "rage5", "perfect_text": "+5 bonus Rage",
					"description": "Exploits instability: +0.5 damage per\npoint of the target's Break meter.\nBuilds 10 Rage."}),
				Ability.make({"display_name": "Crushing Blow", "cost": 20, "damage": 32,
					"pressure": 20, "delay": 3.0, "anim": "attack03", "resource_gain": 10,
					"applies_status": {"id": "sunder", "turns": 3},
					"perfect_id": "", "perfect_text": "+5 bonus BD",
					"description": "Moderate damage. Sunders armor\n(-35%) for 3 turns. Builds 10 Rage."}),
				Ability.make({"display_name": "Pommel Strike", "cost": 15, "damage": 25,
					"pressure": 30, "delay": 2.0, "anim": "attack01", "resource_gain": 10,
					"applies_status": {"id": "stunned", "turns": 1}, "status_chance": 0.5,
					"perfect_id": "parry_up", "perfect_text": "+15% parry chance for 3 turns",
					"description": "A skull-ringing bash: 50% chance to Stun\n(75% if the strike crits). Builds 10 Rage.\nBosses resist Stun until Broken."}),
			]
		"pyromancer":
			return [
				Ability.make({"display_name": "Pyroblast", "dmg_type": "fire", "cost": 45,
					"damage": 55, "pressure": 20, "delay": 6.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "Also sets the target Burning (3 turns)",
					"description": "A slow, devastating comet of flame.\n+50% damage against Burning targets."}),
				Ability.make({"display_name": "Flame Surge", "dmg_type": "fire", "cost": 20, "damage": 15,
					"pressure": 10, "delay": 3.0, "anim": "attack02", "aoe": true,
					"perfect_id": "", "perfect_text": "+15 damage to enemies already Burning",
					"description": "Cone of fire rakes ALL enemies."}),
				Ability.make({"display_name": "Phoenix Rebirth", "cost": 0, "special": "phoenix",
					"delay": 3.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "Only sacrifices 15% HP",
					"description": "Sacrifice 25% of current HP: fully\nrestore Mana and gain Empower (3 turns)."}),
			]
		"cryomancer":
			return [
				Ability.make({"display_name": "Frost Bolt", "dmg_type": "frost", "cost": 25, "damage": 25,
					"pressure": 20, "delay": 3.0, "anim": "attack01",
					"perfect_id": "", "perfect_text": "+5% crit chance on this cast",
					"description": "A spear of ice. 50% chance to deal\nDOUBLE damage against unchilled targets."}),
				Ability.make({"display_name": "Razor Ice", "dmg_type": "frost", "cost": 20, "damage": 15,
					"pressure": 14, "delay": 3.0, "anim": "attack02", "random_hits": 2,
					"perfect_id": "", "perfect_text": "3 shards instead of 2",
					"description": "Hurl razor shards at 2 random enemies.\nAlways crits against Chilled targets."}),
				Ability.make({"display_name": "Blizzard", "dmg_type": "frost", "cost": 30, "damage": 15,
					"pressure": 12, "delay": 4.0, "anim": "attack03", "aoe": true,
					"applies_status": {"id": "chilled", "turns": 2},
					"perfect_id": "", "perfect_text": "+50% Pressure on every target",
					"description": "Storm of ice: hits ALL enemies\nand Chills them."}),
			]
		"arcanist":
			return [
				Ability.make({"display_name": "Arcane Cannon", "dmg_type": "arcane", "cost": 30, "damage": 30,
					"pressure": 15, "delay": 3.5, "anim": "attack02", "recoil_base": 0.15,
					"perfect_id": "", "perfect_text": "+5 bonus BD",
					"description": "Channel raw Resonance into a blast:\n+7.5% DAMAGE per Resonance stack.\nRecoil: the Mage takes 15% of the\ndamage dealt."}),
				Ability.make({"display_name": "Death Ray", "dmg_type": "arcane", "cost": 0, "damage": 150,
					"pressure": 100, "delay": 8.0, "anim": "attack03",
					"perfect_id": "mana15", "perfect_text": "Restores 15 Mana",
					"description": "The stored storm, released: requires\n5 Arcane Resonance and CONSUMES all of\nit. Fixed 150 damage payoff."}),
				Ability.make({"display_name": "Arcane Barrage", "dmg_type": "arcane", "cost": 25, "damage": 5,
					"pressure": 4, "delay": 3.5, "anim": "attack03", "random_hits": 6,
					"perfect_id": "", "perfect_text": "Fires a 7th bolt",
					"description": "Six bolts rake random enemies (30 total\ndamage); every bolt can trigger Echo."}),
			]
		"holy":
			return [
				Ability.make({"display_name": "Dawnbreak", "cost": 20, "special": "dawnbreak",
					"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "+15 bonus healing",
					"description": "Heal an ally for 40. Overhealing\nflows back to the Cleric."}),
				Ability.make({"display_name": "Renewal", "cost": 20, "special": "renewal",
					"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Also heals 15 HP instantly",
					"description": "Ally heals 15 HP at the start of each\nof their turns, for 5 turns."}),
				Ability.make({"display_name": "Hymn of Hope", "cost": 0, "faith_cost": 30,
					"special": "hymn", "delay": 4.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "Heals 25% instead",
					"description": "MIRACLE: heal ALL allies for 20%\nof their max HP."}),
			]
		"inquisitor":
			return [
				Ability.make({"display_name": "Divine Shield", "cost": 30, "special": "divine_shield",
					"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "Shield absorbs 130 instead",
					"description": "Grant an ally a holy shield that\nabsorbs 100 damage, then breaks."}),
				Ability.make({"display_name": "Unity", "cost": 0, "faith_cost": 25,
					"special": "unity", "delay": 3.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "Lasts 4 turns",
					"description": "MIRACLE: bind the party's souls — all\ndamage received is split evenly among\nthem for 3 turns."}),
			]
		"occultist":
			return [
				Ability.make({"display_name": "Hex of Ruin", "dmg_type": "shadow", "cost": 20, "damage": 15,
					"pressure": 24, "delay": 3.0, "anim": "attack02", "random_hits": 2,
					"perfect_extra_hit": false,
					"applies_status": {"id": "cripple", "turns": 3},
					"perfect_id": "status_plus", "perfect_text": "Cripple lasts 4 turns",
					"description": "Curse 2 random enemies: 15 shadow\ndamage each and Crippled for 3 turns."}),
				Ability.make({"display_name": "Mind Flay", "dmg_type": "shadow", "cost": 0, "faith_cost": 25,
					"special": "mindflay", "delay": 3.5, "anim": "attack03",
					"perfect_id": "", "perfect_text": "+115% Break damage instead",
					"description": "MIRACLE: shatter a mind — the target\nattacks its OWN allies for 3 turns with\n+100% Break damage."}),
			]
		"beastmaster":
			return [
				Ability.make({"display_name": "Summon Ursus", "cost": 30, "special": "summon",
					"delay": 3.0, "anim": "attack01", "no_skill_check": true,
					"perfect_id": "", "perfect_text": "",
					"description": "Call the bear (80 HP): attacks with you,\nmauling your target AND a second enemy\nfor 10 damage + 20 Pressure each.\nPack Bond: your attacks deal +25%\nPressure while Ursus prowls."}),
				Ability.make({"display_name": "Summon Canis", "cost": 30, "special": "summon",
					"delay": 3.0, "anim": "attack01", "no_skill_check": true,
					"perfect_id": "", "perfect_text": "",
					"description": "Call the wolf (60 HP): attacks with you\nfor 20 damage, 50% chance to build\n20 Bleed. Pack Bond: your attacks build\n15 Bleed while Canis hunts."}),
				Ability.make({"display_name": "Summon Aguila", "cost": 30, "special": "summon",
					"delay": 3.0, "anim": "attack01", "no_skill_check": true,
					"perfect_id": "", "perfect_text": "",
					"description": "Call the eagle (60 HP): attacks with you\nfor 15 damage, 50% chance to Sunder.\nPack Bond: +15% crit chance while\nAguila circles."}),
				Ability.make({"display_name": "Barbed Arrow", "cost": 20, "damage": 20,
					"pressure": 15, "delay": 2.5, "anim": "attack02",
					"applies_status": {"id": "cripple", "turns": 3},
					"perfect_id": "status_plus", "perfect_text": "Cripple lasts 4 turns",
					"description": "A cruel barb that Cripples the target\nfor 3 turns."}),
				Ability.make({"display_name": "Poisoned Arrow", "cost": 20, "damage": 20,
					"pressure": 15, "delay": 2.5, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Applies 4 stacks instead",
					"description": "A venom-soaked shaft: applies 3 stacks\nof Poison (3 damage per stack per turn,\n5 turns; stacks refresh the timer)."}),
				Ability.make({"display_name": "Kill Command", "cost": 30, "special": "kill_command",
					"delay": 4.0, "anim": "attack01",
					"perfect_id": "", "perfect_text": "+50% to the ordered strike",
					"description": "Order your companion to savage a target:\ndouble damage and doubled special effect.\nRequires a living companion."}),
			]
		"sharpshooter":
			return [
				Ability.make({"display_name": "Aimed Shot", "cost": 20, "damage": 45,
					"pressure": 15, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "+25% crit on this shot",
					"description": "A perfect line. Patient, precise, final."}),
				Ability.make({"display_name": "Powershot", "cost": 25, "damage": 20,
					"pressure": 20, "delay": 3.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "",
					"description": "+2% damage for every point of the\ntarget's Break bar still EMPTY."}),
				Ability.make({"display_name": "Quick Draw", "cost": 15, "special": "quickdraw",
					"delay": 2.0, "anim": "attack01",
					"perfect_id": "", "perfect_text": "Lasts 6 turns",
					"description": "Adrenaline takes over: all your abilities\nact 50% faster for 5 turns."}),
			]
		"mystic":
			return [
				Ability.make({"display_name": "Tripwire", "cost": 20, "special": "tripwire",
					"delay": 2.5, "anim": "attack01",
					"perfect_id": "", "perfect_text": "Lasts 6 turns",
					"description": "Rig the ground: for 5 turns, retaliate\nagainst EVERY attacking melee enemy —\neven those striking your allies."}),
				Ability.make({"display_name": "Explosive Shot", "dmg_type": "fire", "cost": 35,
					"damage": 10, "pressure": 20, "delay": 3.0, "anim": "attack03", "aoe": true,
					"perfect_id": "", "perfect_text": "Deals 12 damage",
					"description": "A bursting charge rakes ALL enemies\nwith fire and heavy Break pressure."}),
				Ability.make({"display_name": "Shrapnel Charge", "cost": 25, "damage": 20,
					"pressure": 25, "delay": 3.0, "anim": "attack03", "choose_two": true,
					"applies_status": {"id": "cripple", "turns": 3},
					"perfect_id": "status_plus", "perfect_text": "Cripple and Slowed last 4 turns",
					"description": "A scattering charge rips TWO chosen\nenemies for 20 physical each, leaving\nthem Crippled and Slowed (3 turns)."}),
			]
	return []

const CLASS_BLURBS := {
	"hunter": "Ranged damage. Focus builds with every shot, spent on\nprecision payoffs and primal magic.",
	"warrior": "Flexible frontliner. Rage builds through attack and pain.",
	"mage": "Glass cannon. Mana Shield turns pain into fuel; the Arcanist\npath stacks Arcane Resonance for devastating payoffs.",
	"cleric": "Divine vessel. Faith builds with every act, awaiting Miracles.",
}
