# An Ability is one action a unit can take in battle.
# Kept as plain data so classes/talents can later be loaded from files.
class_name Ability
extends RefCounted

enum Target { ENEMY, ALLY }

var display_name := ""
var cost := 0            # class resource cost (Rage, Mana...)
var damage := 0          # base damage before variance/crit/armor
var pressure := 0        # Pressure applied to the target on hit
var heal := 0            # if > 0 this is a healing ability
var delay := 2.0         # initiative delay added after use (basic = 2)
var target := Target.ENEMY
var anim := "attack01"
var resource_gain := 0   # resource generated on use (e.g. basic attacks build Rage)
var delay_push := 0.0    # pushes the target's next turn back
var recoil_base := 0.0   # self-damage: this fraction of damage dealt per (1 + Resonance stacks)
var aoe := false         # hits every living enemy (no miss/parry rolls)
var random_hits := 0     # strikes this many random living enemies instead
var multi_hits := 0      # strikes the SAME target this many times
var perfect_extra_hit := true  # multi/random-hit attacks: Perfect adds one hit
var no_skill_check := false    # resolves without the timing bar (summons)
var choose_two := false        # the player picks TWO enemy targets (Shrapnel)
var faith_cost := 0      # secondary-resource cost (Cleric Miracles)
var heal_missing := 0.0  # attacker self-heals this fraction of their missing HP on hit
var armor_pierce := 0.0  # ignores this fraction of the target's armor
var lifesteal := 0.0     # attacker heals this fraction of damage dealt
var dmg_type := "physical"  # arcane/nature/shadow/holy/physical/fire/frost
var bleed_build := 0     # Bleed buildup added on hit (bleedout at 100)
var bleed_chance := 1.0  # probability each hit adds its bleed_build
var applies_status := {} # status applied on hit, e.g. {"id": "slow", "turns": 2}
var status_chance := 1.0 # probability the status lands (1.0 = always)
var perfect_id := ""     # unique bonus effect on a Perfect skill check
var perfect_text := ""   # tooltip text for the perfect bonus
var special := ""        # non-attack effect: rally, barrier, focus, surge, purge, renewal
var description := ""


static func make(d: Dictionary):
	var a = new()
	for key in d:
		a.set(key, d[key])
	return a
