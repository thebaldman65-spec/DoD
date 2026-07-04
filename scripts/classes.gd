# Shared class data: hero configs, ability kits, and specialization flavor.
# Used by both the battle scene and the party screen.
class_name Classes


static func hero_config(key: String) -> Dictionary:
	var soldier := "res://assets/sprites/soldier"
	match key:
		"warrior":
			return {"unit_name": "Warrior", "is_hero": true, "sheet_dir": soldier,
				"max_hp": 140, "armor": 0.25, "speed": 95.0, "stability": 60,
				"resource_name": "Rage", "resource": 0, "max_resource": 100,
				"abilities": kit(key)}
		"mage":
			return {"unit_name": "Mage", "is_hero": true, "sheet_dir": soldier,
				"max_hp": 90, "armor": 0.10, "speed": 110.0, "stability": 40,
				"resource_name": "Mana", "resource": 100, "max_resource": 100,
				"second_resource_name": "Resonance", "second_resource": 0, "second_max": 5,
				"abilities": kit(key)}
		_:
			return {"unit_name": "Cleric", "is_hero": true, "sheet_dir": soldier,
				"max_hp": 110, "armor": 0.15, "speed": 85.0, "stability": 50,
				"resource_name": "Mana", "resource": 100, "max_resource": 100,
				"second_resource_name": "Faith", "second_resource": 0, "second_max": 100,
				"abilities": kit(key)}


static func kit(key: String) -> Array:
	match key:
		"warrior":
			return warrior_kit()
		"mage":
			return mage_kit()
		_:
			return cleric_kit()


static func warrior_kit() -> Array:
	return [
		Ability.make({"display_name": "Strike", "cost": 0, "damage": 23, "pressure": 9,
			"resource_gain": 15, "delay": 2.0, "anim": "attack01",
			"perfect_id": "rage", "perfect_text": "+10 bonus Rage",
			"description": "Basic attack. Builds 15 Rage."}),
		Ability.make({"display_name": "Taunt", "cost": 0, "special": "taunt",
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "", "perfect_text": "Also sheds 10 of the Warrior's Pressure",
			"description": "Force all enemies to attack the\nWarrior for 5 turns."}),
	]


static func mage_kit() -> Array:
	return [
		Ability.make({"display_name": "Magic Bolt", "dmg_type": "arcane", "cost": 0, "damage": 25, "pressure": 7,
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "mana", "perfect_text": "Restores 10 Mana",
			"description": "Basic arcane projectile. Builds Resonance."}),
		Ability.make({"display_name": "Arcane Surge", "cost": 15, "special": "surge",
			"delay": 3.0, "anim": "attack03",
			"perfect_id": "", "perfect_text": "+2 Resonance instead of +1",
			"description": "+20% attack on your next turn.\nGuarantees +1 Resonance."}),
	]


static func cleric_kit() -> Array:
	return [
		Ability.make({"display_name": "Smite", "dmg_type": "holy", "cost": 0, "damage": 22, "pressure": 8,
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "self_heal", "perfect_text": "Cleric recovers 8 HP",
			"description": "Basic radiant strike. Builds Faith."}),
		Ability.make({"display_name": "Mend Wounds", "cost": 25, "heal": 45,
			"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
			"perfect_id": "ward", "perfect_text": "Grants Ward (-50% Pressure taken, 2 turns)",
			"description": "Restore HP to one ally. Builds Faith."}),
		Ability.make({"display_name": "Divine Shield", "cost": 30, "special": "divine_shield",
			"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack03",
			"perfect_id": "", "perfect_text": "Shield absorbs 130 instead",
			"description": "Grant an ally a holy shield that\nabsorbs 100 damage, then breaks."}),
		Ability.make({"display_name": "Renewal", "cost": 20, "special": "renewal",
			"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
			"perfect_id": "", "perfect_text": "Also heals 8 HP instantly",
			"description": "Ally heals 8 HP at the start of each\nof their turns, for 5 turns."}),
	]


# Specializations: ordered ids per class, plus display/passive data.
# Each spec = 1 passive (implemented via passive_id hooks in battle.gd)
# + 2 abilities appended to the core kit.
const SPEC_IDS := {
	"warrior": ["berserker", "warden", "swordmaster"],
	"mage": ["pyromancer", "cryomancer", "arcanist"],
	"cleric": ["holy", "inquisitor", "occultist"],
}

const SPEC_INFO := {
	"berserker": {"name": "Berserker", "passive": "bloodrage",
		"passive_desc": "Blood Frenzy: up to +40% damage as HP falls.",
		"blurb": "Reckless savagery — grows stronger as their blood spills."},
	"warden": {"name": "Warden", "passive": "bulwark",
		"passive_desc": "Bulwark: +10% armor, +15 Stability.",
		"blurb": "Protector of the weak — shields allies with their own body."},
	"swordmaster": {"name": "Swordmaster", "passive": "duelist",
		"passive_desc": "Duelist: +10% crit chance; crits refund 10 Rage.",
		"blurb": "Precision and technique — critical hits fuel the flurry."},
	"pyromancer": {"name": "Pyromancer", "passive": "ignite",
		"passive_desc": "Ignite: damaging spells have 50% chance to Burn (2 turns).",
		"blurb": "Aggressive flame — burns that spread and stack."},
	"cryomancer": {"name": "Cryomancer", "passive": "chill",
		"passive_desc": "Chill: damaging spells have 50% chance to Slow (2 turns).",
		"blurb": "Battlefield control — slow, freeze, then shatter."},
	"arcanist": {"name": "Arcanist", "passive": "echo",
		"passive_desc": "Echo: 15% chance spells strike again at 50% power.",
		"blurb": "Unstable raw magic — bends the rules of turn and time."},
	"holy": {"name": "Holy", "passive": "grace",
		"passive_desc": "Grace: all healing +25%.",
		"blurb": "Pure vessel of light — mass healing and shields of faith."},
	"inquisitor": {"name": "Inquisitor", "passive": "zeal",
		"passive_desc": "Zeal: +15% damage; Faith builds 13 per action.",
		"blurb": "Zealous judge — exposes and executes the corrupted."},
	"occultist": {"name": "Occultist", "passive": "corrupt",
		"passive_desc": "Corrupted Channeling: hits have 25% chance to Cripple (2 turns).",
		"blurb": "Forbidden rites — leech life and trade blood for power."},
}


static func spec_abilities(spec: String) -> Array:
	match spec:
		"berserker":
			return [
				Ability.make({"display_name": "Bloodlust", "cost": 25, "damage": 26,
					"pressure": 9, "delay": 3.0, "anim": "attack02", "heal_missing": 0.3,
					"perfect_id": "", "perfect_text": "Heals 45% of missing HP instead",
					"description": "Strike and drink deep: heals the Warrior\nfor 30% of their missing HP."}),
				Ability.make({"display_name": "Wildstrikes", "cost": 35, "damage": 16,
					"pressure": 7, "delay": 4.5, "anim": "attack03", "aoe": true,
					"bleed_build": 35,
					"perfect_id": "", "perfect_text": "+50% Pressure on every target",
					"description": "Savage sweep: hits ALL enemies and\nbuilds 35 Bleed on each."}),
			]
		"warden":
			return [
				Ability.make({"display_name": "Shieldwall", "cost": 25, "special": "shieldwall",
					"delay": 3.5, "anim": "attack01",
					"perfect_id": "", "perfect_text": "Also sheds 10 Pressure from each ally",
					"description": "The party takes 50% less damage\nuntil their next turns."}),
				Ability.make({"display_name": "Retaliation", "cost": 20, "special": "retaliate",
					"delay": 3.0, "anim": "attack01",
					"perfect_id": "", "perfect_text": "Stance lasts 4 turns",
					"description": "For 3 turns, counter every attack\nthat strikes the Warrior."}),
			]
		"swordmaster":
			return [
				Ability.make({"display_name": "Overpower", "cost": 20, "damage": 30,
					"pressure": 10, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "+15% crit chance on this strike",
					"description": "Precise heavy cut. Critical hits\nrefund 20 Rage."}),
				Ability.make({"display_name": "Crushing Blow", "cost": 20, "damage": 32,
					"pressure": 17, "delay": 4.0, "anim": "attack03",
					"applies_status": {"id": "sunder", "turns": 3},
					"perfect_id": "pressure", "perfect_text": "+60% Pressure",
					"description": "Moderate damage. Sunders armor\n(-35%) for 3 turns."}),
			]
		"pyromancer":
			return [
				Ability.make({"display_name": "Flame Surge", "dmg_type": "fire", "cost": 20, "damage": 16,
					"pressure": 6, "delay": 3.5, "anim": "attack02", "aoe": true,
					"applies_status": {"id": "burn", "turns": 2},
					"perfect_id": "", "perfect_text": "Burn lasts 3 turns",
					"description": "Cone of fire: hits ALL enemies\nand sets them Burning."}),
				Ability.make({"display_name": "Phoenix Rebirth", "cost": 0, "special": "phoenix",
					"delay": 3.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "Only sacrifices 15% HP",
					"description": "Sacrifice 25% of current HP: fully\nrestore Mana and gain Empower (3 turns)."}),
			]
		"cryomancer":
			return [
				Ability.make({"display_name": "Razor Ice", "dmg_type": "frost", "cost": 20, "damage": 15,
					"pressure": 7, "delay": 3.0, "anim": "attack02", "random_hits": 2,
					"perfect_id": "", "perfect_text": "3 shards instead of 2",
					"description": "Hurl razor shards at 2 random enemies.\nAlways crits against Slowed targets."}),
				Ability.make({"display_name": "Blizzard", "dmg_type": "frost", "cost": 30, "damage": 15,
					"pressure": 6, "delay": 4.0, "anim": "attack03", "aoe": true,
					"applies_status": {"id": "slow", "turns": 2},
					"perfect_id": "", "perfect_text": "+50% Pressure on every target",
					"description": "Storm of ice: hits ALL enemies\nand Slows them."}),
			]
		"arcanist":
			return [
				Ability.make({"display_name": "Arcane Cannon", "dmg_type": "arcane", "cost": 20, "damage": 30,
					"pressure": 9, "delay": 3.5, "anim": "attack02", "recoil_base": 0.05,
					"perfect_id": "", "perfect_text": "No recoil",
					"description": "Channel raw Resonance into a blast.\nRecoils on the Mage for 5% of damage\ndealt, +5% per Resonance stack."}),
				Ability.make({"display_name": "Reality Fracture", "dmg_type": "arcane", "cost": 20, "damage": 15,
					"pressure": 7, "delay": 3.0, "anim": "attack03", "delay_push": 4.0,
					"perfect_id": "", "perfect_text": "Also +1 Resonance",
					"description": "Shove the target far down the\ninitiative order."}),
			]
		"holy":
			return [
				Ability.make({"display_name": "Dawnbreak", "cost": 20, "special": "dawnbreak",
					"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "+15 bonus healing",
					"description": "Heal an ally for 40. Overhealing\nflows back to the Cleric."}),
				Ability.make({"display_name": "Hymn of Hope", "cost": 0, "faith_cost": 60,
					"special": "hymn", "delay": 4.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "Heals 25% instead",
					"description": "MIRACLE: heal ALL allies for 20%\nof their max HP."}),
			]
		"inquisitor":
			return [
				Ability.make({"display_name": "Burning Verdict", "dmg_type": "holy", "cost": 0, "faith_cost": 40,
					"damage": 40, "pressure": 10, "delay": 3.5, "anim": "attack02",
					"applies_status": {"id": "exposed", "turns": 3},
					"perfect_id": "", "perfect_text": "+50% Pressure",
					"description": "MIRACLE: radiant execution that\nleaves the target Exposed (3 turns)."}),
				Ability.make({"display_name": "Condemn", "dmg_type": "holy", "cost": 15, "damage": 12,
					"pressure": 9, "delay": 3.5, "anim": "attack03", "aoe": true,
					"perfect_id": "", "perfect_text": "+50% Pressure on every target",
					"description": "Holy censure strikes ALL enemies."}),
			]
		"occultist":
			return [
				Ability.make({"display_name": "Hex of Ruin", "dmg_type": "shadow", "cost": 20, "damage": 14,
					"pressure": 7, "delay": 3.0, "anim": "attack02",
					"applies_status": {"id": "sunder", "turns": 3},
					"perfect_id": "", "perfect_text": "Also Crippled (2 turns)",
					"description": "Curse the target: Sunders armor\n(-35%) for 3 turns."}),
				Ability.make({"display_name": "Dark Benediction", "cost": 0, "faith_cost": 40,
					"special": "benediction", "delay": 3.5, "anim": "attack03",
					"perfect_id": "", "perfect_text": "No HP sacrifice",
					"description": "MIRACLE: sacrifice 10% max HP to heal\nall allies 15% and Empower them (2 turns)."}),
			]
	return []

const CLASS_BLURBS := {
	"warrior": "Flexible frontliner. Rage builds through attack and pain.",
	"mage": "Glass cannon. Resonance stacks power at the cost of safety —\nonly Guard releases them.",
	"cleric": "Divine vessel. Faith builds with every act, awaiting Miracles.",
}
