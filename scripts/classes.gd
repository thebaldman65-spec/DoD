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
				"max_hp": 110, "armor": 0.15, "speed": 100.0, "stability": 50,
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
		Ability.make({"display_name": "Strike", "cost": 0, "damage": 23, "pressure": 10,
			"resource_gain": 15, "delay": 2.0, "anim": "attack01",
			"perfect_id": "rage", "perfect_text": "+10 bonus Rage",
			"description": "Basic attack. Builds 15 Rage."}),
		Ability.make({"display_name": "Heavy Strike", "cost": 30, "damage": 50, "pressure": 18,
			"delay": 4.0, "anim": "attack02",
			"perfect_id": "pressure", "perfect_text": "+60% Pressure",
			"description": "Big single-target damage."}),
		Ability.make({"display_name": "Rallying Shout", "cost": 0, "special": "rally",
			"resource_gain": 15, "delay": 3.0, "anim": "attack01",
			"perfect_id": "", "perfect_text": "Stronger rally (-25 Pressure, +30% resource)",
			"description": "Party-wide: allies shed 15 Pressure and\nregain 20% of their resource.\nGrants the Warrior 15 Rage."}),
		Ability.make({"display_name": "Crushing Blow", "cost": 20, "damage": 32, "pressure": 20,
			"delay": 4.0, "anim": "attack03",
			"applies_status": {"id": "sunder", "turns": 3},
			"perfect_id": "pressure", "perfect_text": "+60% Pressure",
			"description": "Moderate damage. Sunders armor (-35%) for 3 turns."}),
	]


static func mage_kit() -> Array:
	return [
		Ability.make({"display_name": "Magic Bolt", "cost": 0, "damage": 25, "pressure": 8,
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "mana", "perfect_text": "Restores 10 Mana",
			"description": "Basic arcane projectile. Builds Resonance."}),
		Ability.make({"display_name": "Arcane Cannon", "cost": 20, "damage": 30, "pressure": 12,
			"delay": 3.5, "anim": "attack02", "recoil_base": 0.05,
			"perfect_id": "", "perfect_text": "No recoil",
			"description": "Channel raw Resonance into a blast.\nRecoils on the Mage for 5% of damage\ndealt, +5% per Resonance stack."}),
		Ability.make({"display_name": "Focus", "cost": 0, "special": "focus",
			"delay": 3.0, "anim": "attack02",
			"perfect_id": "", "perfect_text": "Also restores 10 Mana instantly",
			"description": "Regenerate 10 Mana per turn for 2 turns."}),
		Ability.make({"display_name": "Arcane Surge", "cost": 15, "special": "surge",
			"delay": 3.0, "anim": "attack03",
			"perfect_id": "", "perfect_text": "+2 Resonance instead of +1",
			"description": "+20% attack on your next turn.\nGuarantees +1 Resonance."}),
	]


static func cleric_kit() -> Array:
	return [
		Ability.make({"display_name": "Smite", "cost": 0, "damage": 22, "pressure": 10,
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "self_heal", "perfect_text": "Cleric recovers 8 HP",
			"description": "Basic radiant strike. Builds Faith."}),
		Ability.make({"display_name": "Mend Wounds", "cost": 25, "heal": 45,
			"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
			"perfect_id": "ward", "perfect_text": "Grants Ward (-50% Pressure taken, 2 turns)",
			"description": "Restore HP to one ally. Builds Faith."}),
		Ability.make({"display_name": "Blessed Purge", "cost": 30, "special": "purge",
			"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack03",
			"perfect_id": "", "perfect_text": "Bigger heal",
			"description": "Heal an ally, remove 1 debuff,\nand grant +10% armor for 2 turns."}),
		Ability.make({"display_name": "Renewal", "cost": 20, "special": "renewal",
			"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
			"perfect_id": "", "perfect_text": "Also heals 8 HP instantly",
			"description": "Ally heals 8 HP at the start of each\nof their turns, for 5 turns."}),
	]


# Specialization flavor for the party screen (mechanics arrive in a later phase).
const SPECS := {
	"warrior": [
		["Berserker", "Reckless savagery — grows stronger as their blood spills."],
		["Warden", "Protector of the weak — shields allies with their own body."],
		["Swordmaster", "Precision and technique — critical hits chain into flurries."],
	],
	"mage": [
		["Pyromancer", "Aggressive flame — burns that spread and stack."],
		["Cryomancer", "Battlefield control — slow, freeze, then shatter."],
		["Arcanist", "Unstable raw magic — bends the rules of turn and time."],
	],
	"cleric": [
		["Holy", "Pure vessel of light — mass healing and shields of faith."],
		["Inquisitor", "Zealous judge — exposes and executes the corrupted."],
		["Occultist", "Forbidden rites — leech life and trade blood for power."],
	],
}

const CLASS_BLURBS := {
	"warrior": "Flexible frontliner. Rage builds through attack and pain.",
	"mage": "Glass cannon. Resonance stacks power at the cost of safety —\nonly Guard releases them.",
	"cleric": "Divine vessel. Faith builds with every act, awaiting Miracles.",
}
