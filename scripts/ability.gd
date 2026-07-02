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
var delay_push := 0.0    # pushes the target's next turn back (Frost Spike)
var description := ""


static func make(d: Dictionary):
	var a = new()
	for key in d:
		a.set(key, d[key])
	return a
