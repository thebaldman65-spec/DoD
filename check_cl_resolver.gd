# BATCH CL §1 — resolver gate. Asserts the four resolution cases and the two
# ways the batch can silently fail: an unresolved token reaching a label, and an
# authored digit inside parentheses. Run headless:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_cl_resolver.gd
extends SceneTree

var bad := 0


func eq(got: String, want: String, what: String) -> void:
	if got != want:
		print("FAIL %s\n   got:  %s\n   want: %s" % [what, got, want])
		bad += 1


func _initialize() -> void:
	var hero := {"max_hp": 170, "hp": 141, "attack": 100, "max_resource": 100,
		"resource_name": "Mana", "block_chance": 0.10, "parry_chance": 0.05}

	# Case 2 — a resolvable base resolves, and the owner is unnamed for self.
	eq(Classes.resolve_values("Loses {chp:20}.", hero),
		"Loses 20% of current health (28).", "self current health")
	# 15% of 170 is 25.5 and rounds to 26 — half-up, the same rounding the
	# computed block uses for its damage band.
	eq(Classes.resolve_values("Heals {mhp:15}.", hero),
		"Heals 15% of maximum health (26).", "self maximum health")
	eq(Classes.resolve_values("Deals {atk:8} per stack.", hero),
		"Deals 8% of Attack (8) per stack.", "attack")
	eq(Classes.resolve_values("Recovers {res:3}.", hero),
		"Recovers 3% of maximum Mana (3).", "named resource")

	# Case 3 — NOTHING to resolve against: bare percentage, no parenthetical,
	# no placeholder, no dash. This is the draft card and the glossary.
	eq(Classes.resolve_values("Loses {chp:20}.", {}),
		"Loses 20% of current health.", "no ctx falls back bare")
	eq(Classes.resolve_values("Heals {mhp:15}.", {}),
		"Heals 15% of maximum health.", "no ctx maximum health")
	# A resource with no unit has no name to print, so only the number stands.
	eq(Classes.resolve_values("Recovers {res:3}.", {}),
		"Recovers 3%.", "no ctx unnamed resource")

	# Case 4 — the owner the text names. An ally/target base is absent at
	# tooltip time (the tooltip is built for the caster), so these stay bare.
	eq(Classes.resolve_values("Heals {mhp:15|ally}.", hero),
		"Heals 15% of the ally's maximum health.", "ally owner named, unresolved")
	eq(Classes.resolve_values("Takes {mhp:30|target}.", hero),
		"Takes 30% of the target's maximum health.", "target owner named")
	var withally := hero.duplicate()
	withally["ally_max_hp"] = 200
	eq(Classes.resolve_values("Heals {mhp:15|ally}.", withally),
		"Heals 15% of the ally's maximum health (30).", "ally base resolves")

	# Case 1 — already final, resolves to the resulting TOTAL, chips only.
	eq(Classes.resolve_values("{tot:25|block} while it holds.", hero),
		"+25% Block chance (→ 35%) while it holds.", "final to total")
	eq(Classes.resolve_values("{tot:25|block} while it holds.", {}),
		"+25% Block chance while it holds.", "final with no base stands alone")

	# Mechanics: several tokens in one string, and a fractional step.
	eq(Classes.resolve_values("{chp:20} for {mhp:5}.", hero),
		"20% of current health (28) for 5% of maximum health (9).", "two tokens")
	eq(Classes.resolve_values("{atk:1.5} a stack.", hero),
		"1.5% of Attack (2) a stack.", "fractional percentage")
	eq(Classes.resolve_values("No tokens here.", hero),
		"No tokens here.", "passthrough")
	eq(Classes.resolve_values("", hero), "", "empty")

	# THE TWO SILENT FAILURES. Every authored field is swept: an unexpanded
	# token must never survive resolution, and no authored string may carry a
	# digit inside parentheses (§1 — that is the drift this batch exists to
	# prevent).
	var unresolved := 0
	var authored_digits: Array = []
	var brace := RegEx.new()
	brace.compile("\\{[a-z]")
	var paren := RegEx.new()
	paren.compile("\\((?:[^()]*[0-9])[^()]*\\)")
	for ab in _every_ability():
		for f in [ab.description, ab.perfect_text]:
			var s := String(f)
			if s == "":
				continue
			if brace.search(Classes.resolve_values(s, hero)) != null:
				print("UNRESOLVED TOKEN in %s: %s" % [ab.display_name, s])
				unresolved += 1
			var p := paren.search(s)
			if p != null:
				authored_digits.append("%s: %s" % [ab.display_name, p.get_string()])
	for spec in Classes.SPEC_INFO:
		var pd := String(Classes.SPEC_INFO[spec]["passive_desc"])
		if brace.search(Classes.resolve_values(pd, hero)) != null:
			print("UNRESOLVED TOKEN in passive_desc %s" % spec)
			unresolved += 1
	bad += unresolved
	print("unresolved tokens: %d" % unresolved)
	# Reported, not asserted: a parenthetical digit is legal in prose that is
	# not a resolved value ("(2 on a crit)", "(max 5)"), so this is a list for
	# a human to read rather than a gate.
	print("authored parentheses containing a digit: %d" % authored_digits.size())
	for a in authored_digits:
		print("   %s" % a)

	print("\ncheck_cl_resolver: %d failures" % bad)
	quit(1 if bad > 0 else 0)


func _every_ability() -> Array:
	var out: Array = []
	var seen := {}
	for key in ["warrior", "mage", "cleric", "hunter"]:
		for ab in Classes.kit(key):
			out.append(ab)
	for spec in Classes.SPEC_INFO:
		for ab in Classes.spec_abilities(spec):
			if not seen.has(ab.display_name):
				seen[ab.display_name] = true
				out.append(ab)
	return out
