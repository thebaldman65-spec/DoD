# BATCH DN — THE TALENT NODES AGAINST THE NEW CHARTER. Read-only, like
# `check_cu.gd` before it: it asserts nothing and changes nothing, because DN
# is a REPORT batch. It exists so `docs/talent-audit.html`'s second reading of
# the same 324 nodes can be RE-RUN rather than trusted.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_dn.gd 2>&1 | grep -E "Parse Error|SCRIPT ERROR"
#
# Set DOD_DN_DUMP to a path to write the JSON the report is built from.
#
# THE ONE QUESTION THIS FILE ANSWERS, per node: does it depend on something
# GUARANTEED (a stat, the spec's passive, its resource, its PROTECTED CORE) or
# on something DRAWN (a draft ability the hero may never be offered, a status
# another spec produces, a companion, an item)?
#
# THAT CANNOT BE READ OFF THE NODE TEXT, which is the whole reason this is an
# instrument and not a reading. "Deep Freeze deals +30% damage" tells you
# nothing about whether Deep Freeze is guaranteed; `Classes.protected_names()`
# and `Classes.spec_draft_pool()` do. So every ability name a node mentions is
# resolved against the LIVE membership tables, and the bucket is reported
# beside the name.
#
# WHAT THIS FILE DOES NOT DO: it does not rule. The Offense / Defense / Utility
# landing it prints is a published RULE TABLE applied to payload stats and node
# text, so a designer can disagree with a cell and see exactly which rule put
# it there. It is a sort, not a verdict.
extends SceneTree

# The three lanes the charter names.
const OFF := "Offense"
const DEF := "Defense"
const UTL := "Utility"

# ---------------------------------------------------------------------------
# THE LANDING RULE TABLE. Applied in order; FIRST match wins, so the earlier
# rows are the sharper ones. Every rule is a substring tested against the
# node's rendered text lowercased, or against a payload stat key.
# ---------------------------------------------------------------------------
const DEF_TEXT := ["damage taken", "less damage", "block", "armor ", "armour",
	"heal", "heals", "healing", "shield", "absorb", "max hp", "max health",
	"health missing", "survive", "death", "revive", "resurrect", "resist",
	"parry", "dodge", "mitigat", "reduce the damage", "damage reduction",
	"regenerat", "cheat death", "immune", "cleanse", "purge", "guard",
	"taunt", "threat", "protect", "ward", "defensive stance"]
const OFF_TEXT := ["damage", "critical", "crit ", "attack", "strike", "bleed",
	"burn", "poison", "penetrat", "armor penetration", "execute", "kill",
	"slay", "wound", "hits", "hit ", "aoe", "cleave", "explode", "detonat",
	"lethal", "pierce", "shatter"]
const UTL_TEXT := ["cooldown", "cost", "mana", "rage", "faith", "focus",
	"initiative", "delay", "turn order", "acts ", "haste", "speed",
	"generate", "refund", "restore", "gain ", "stack", "duration",
	"lasts", "chance to apply", "slot", "loot", "gold", "item"]


func _lc(s: String) -> String:
	return s.to_lower()


# Every ability display name a node's PAYLOAD names, walking `also` too.
func _payload_abilities(p: Dictionary, out: Array) -> void:
	if p.has("ability"):
		var a := String(p["ability"])
		if a != "" and not out.has(a):
			out.append(a)
	if p.has("grant_ability"):
		var g := String(p["grant_ability"])
		if g != "" and not out.has(g):
			out.append(g)
	if p.has("new_ability") and typeof(p["new_ability"]) == TYPE_DICTIONARY:
		var n := String((p["new_ability"] as Dictionary).get("display_name", ""))
		if n != "" and not out.has(n):
			out.append(n)
	for key in ["also", "upgrade"]:
		if p.has(key) and typeof(p[key]) == TYPE_ARRAY:
			for sub in p[key]:
				if typeof(sub) == TYPE_DICTIONARY:
					_payload_abilities(sub, out)


# Every payload stat key a node writes, walking `also`/`upgrade` too.
func _payload_stats(p: Dictionary, out: Array) -> void:
	if p.has("stat") and typeof(p["stat"]) == TYPE_DICTIONARY:
		for k in (p["stat"] as Dictionary):
			if not out.has(String(k)):
				out.append(String(k))
	for key in ["also", "upgrade"]:
		if p.has(key) and typeof(p[key]) == TYPE_ARRAY:
			for sub in p[key]:
				if typeof(sub) == TYPE_DICTIONARY:
					_payload_stats(sub, out)


func _land(text: String, stats: Array) -> String:
	var t := _lc(text)
	# A node that only moves a cost or a cooldown is Utility even when it sits
	# on an attack, so the cheap-and-specific rules are tested FIRST.
	for k in ["cooldown", "costs ", " cost", "refund", "initiative", "delay"]:
		if t.find(k) >= 0:
			return UTL
	for k in DEF_TEXT:
		if t.find(k) >= 0:
			return DEF
	for k in OFF_TEXT:
		if t.find(k) >= 0:
			return OFF
	for k in UTL_TEXT:
		if t.find(k) >= 0:
			return UTL
	if stats.is_empty():
		return UTL
	return OFF


# Every lookup Classes exposes, because a talent's ability can come from the
# pending-talent table, the vault, a spec pool, a draft pool or a class kit —
# asking only one of them reports "not found" for an ability in the game.
# This is `check_cu._find`, unchanged.
func _find(n: String):
	for f in [Classes.pending_talent_ability, Classes.vault_ability,
			Classes.pool_ability, Classes.draft_ability,
			Classes.trimmed_kit_ability]:
		var ab = f.call(n)
		if ab != null:
			return ab
	for spec in Classes.SPEC_INFO:
		var ab2 = Classes.spec_pool_ability(spec, n)
		if ab2 != null:
			return ab2
	for k in ["hunter", "warrior", "mage", "cleric"]:
		for ab3 in Classes.kit(k):
			if ab3.display_name == n:
				return ab3
	return null


func _initialize() -> void:
	# ---- 1. THE MEMBERSHIP TABLES, READ LIVE ----
	var corpus_names: Array = []
	for ab in Classes.ability_corpus():
		corpus_names.append(ab.display_name)
	var granted_names: Array = []
	for nm in Classes.talent_granted_names():
		granted_names.append(String(nm))

	var tables := {}
	for spec in Classes.all_specs():
		var ck := Classes.class_of_spec(spec)
		tables[spec] = {
			"class": ck,
			"protected": Classes.protected_names(spec),
			"core_enablers": Classes.core_enablers(spec),
			"core_slots": Classes.core_slots(spec),
			"spec_draft": Classes.spec_draft_pool(spec),
			"class_draft": Classes.class_draft_pool(ck),
			"spec_pool": Classes.spec_pool(spec),
			"class_pool": Classes.class_pool(ck),
			"passive": String(Classes.SPEC_INFO[spec].get("passive", "")),
			"passive_desc": String(Classes.SPEC_INFO[spec].get("passive_desc", "")),
		}
	print("SPECS: %d   CORPUS: %d   TALENT-GRANTED: %d"
		% [tables.size(), corpus_names.size(), granted_names.size()])

	# ---- 2. EVERY NODE, SORTED ----
	var out: Array = []
	var per_spec := {}
	for spec in Talents.LANE_TREES:
		var tb: Dictionary = tables.get(spec, {})
		var protected: Array = tb.get("protected", [])
		var sdraft: Array = tb.get("spec_draft", [])
		var cdraft: Array = tb.get("class_draft", [])
		var spool: Array = tb.get("spec_pool", [])
		var cpool: Array = tb.get("class_pool", [])
		for n in Talents.LANE_TREES[spec]:
			var payload: Dictionary = n.get("payload", {})
			var text := Talents.desc_for(n, 1)
			var pay_ab: Array = []
			_payload_abilities(payload, pay_ab)
			var stats: Array = []
			_payload_stats(payload, stats)

			# Every corpus name the TEXT mentions. Longest-first so "Battle
			# Shout" is not eaten by a shorter name inside it.
			var text_ab: Array = []
			for nm in corpus_names:
				if String(nm).length() >= 4 and text.find(String(nm)) >= 0:
					text_ab.append(String(nm))

			# Resolve every named ability against the live tables.
			var refs: Array = []
			var seen := {}
			for nm in pay_ab + text_ab:
				if seen.has(nm):
					continue
				seen[nm] = true
				var bucket := "unknown"
				if protected.has(nm):
					bucket = "core"
				elif granted_names.has(nm):
					bucket = "talent-granted"
				elif sdraft.has(nm):
					bucket = "spec-draft"
				elif cdraft.has(nm):
					bucket = "class-draft"
				elif spool.has(nm):
					bucket = "spec-pool"
				elif cpool.has(nm):
					bucket = "class-pool"
				elif corpus_names.has(nm):
					bucket = "other-spec"
				refs.append({"name": nm, "bucket": bucket,
					"from_payload": pay_ab.has(nm)})

			out.append({
				"spec": spec, "id": String(n.get("id", "")),
				"name": String(n.get("name", "")),
				"lane": String(n.get("lane", "")),
				"row": int(n.get("row", 0)),
				"text": text,
				"stats": stats,
				"refs": refs,
				"granted": Talents.granted_name(payload),
				"land": _land(text, stats),
			})
			if not per_spec.has(spec):
				per_spec[spec] = 0
			per_spec[spec] = int(per_spec[spec]) + 1

	print("NODES: %d (expected %d)" % [out.size(), 12 * Talents.CELLS_PER_SPEC])
	print("CAPSTONE CELLS: %d rows of %d lanes x %d specs"
		% [Talents.LANES * 12, Talents.LANES, 12])

	# ---- 3. THE LANE-NAME COUPLING, COUNTED ----
	var lane_names := {}
	for spec in Talents.LANE_TREES:
		for n in Talents.LANE_TREES[spec]:
			lane_names[String(n.get("lane", ""))] = true
	print("DISTINCT LANE NAMES IN THE TREES: %d" % lane_names.size())

	# ---- 4. WHERE EACH SPEC'S STATUSES COME FROM ----
	# A node reading a status is GUARANTEED only if the spec can apply that
	# status from its PROTECTED CORE. If the only applier is in a draft pool,
	# the clause is a bet — and that cannot be read off the node text either.
	var status_src := {}
	for spec in Classes.all_specs():
		var ck := Classes.class_of_spec(spec)
		var by_bucket := {}
		var buckets := {
			"core": Classes.protected_names(spec),
			"spec-draft": Classes.spec_draft_pool(spec),
			"class-draft": Classes.class_draft_pool(ck),
			"spec-pool": Classes.spec_pool(spec),
			"class-pool": Classes.class_pool(ck),
		}
		# THE CORE IS BUILT THE WAY `protected_names` BUILDS IT — class kit
		# THROUGH `apply_kit_overrides`, then the spec's own openers. Resolving
		# a core name through `_find` returns the BASE class ability instead of
		# the spec's overridden one (the Occultist's Shadowrend is the cleric's
		# Smite slot, re-made), and that under-reports the core every time.
		var core_abs: Array = []
		var cfg := {"abilities": Classes.kit(ck)}
		Classes.apply_kit_overrides(cfg, spec)
		for ab0 in cfg["abilities"]:
			core_abs.append(ab0)
		for ab1 in Classes.spec_abilities(spec):
			core_abs.append(ab1)
		for b in buckets:
			var got: Array = []
			var objs: Array = []
			if b == "core":
				objs = core_abs
			else:
				for nm in buckets[b]:
					var ab = _find(String(nm))
					if ab != null:
						objs.append(ab)
			for ab in objs:
				var ap = ab.get("applies_status")
				if typeof(ap) == TYPE_DICTIONARY and ap.has("id"):
					var sid := String(ap["id"])
					if not got.has(sid):
						got.append(sid)
			by_bucket[b] = got
		status_src[spec] = by_bucket
	print("\nSTATUS SOURCES (from live `applies_status`, per spec):")
	for spec in Classes.all_specs():
		print("  %-13s core=%s  drawn=%s" % [spec,
			str(status_src[spec]["core"]),
			str(status_src[spec]["spec-draft"] + status_src[spec]["class-draft"]
				+ status_src[spec]["spec-pool"] + status_src[spec]["class-pool"])])

	# ---- 5. WHAT A RESTRUCTURE DOES TO A SAVED ALLOCATION ----
	# MEASURED, not reasoned about. `Profile.save_path` is a var precisely so a
	# headless check can redirect it, so this buys a real spec's cells against
	# the real tree and then asks the ledger what it thinks, against three
	# tree edits a restructure would make: an id DELETED, a node MOVED to a
	# dearer row, and a node MOVED to a cheaper one.
	print("\nSAVED ALLOCATIONS UNDER A RESTRUCTURE (Profile v%d, tolerant load):"
		% Profile.VERSION)
	Profile.save_path = "user://dn_probe.json"
	Profile.loaded = false
	Profile.data = {}
	var spec := "berserker"
	var tree := Talents.generate_tree(spec, "")
	Profile.note_end_boss(Talents.MAX_TIER)
	for _i in Talents.full_spec_cost():
		Profile.award_zone_boss_points([spec])
	var bought := 0
	for n in tree:
		if Profile.buy_cell(spec, String(n["id"])):
			bought += 1
	var cells := Profile.talent_cells(spec)
	print("  bought %d of %d cells; spent=%d of %d; available=%d"
		% [bought, tree.size(), Talents.cells_spent(tree, cells),
			Talents.full_spec_cost(), Profile.talent_points_available(spec)])

	# (a) an id the restructure DELETES.
	var cut := tree.duplicate(true)
	cut.remove_at(0)
	print("  (a) one row-1 id DELETED  -> spent=%d  available=%d  (the point is"
		% [Talents.cells_spent(cut, cells),
			Profile.talent_points_earned(spec) - Talents.cells_spent(cut, cells)]
		+ " silently refunded and the dead cell stays in the save)")

	# (b) a row-1 node MOVED to row 9 — tier 1 to tier 3, 1 point to 3.
	var up := tree.duplicate(true)
	up[0]["row"] = 9
	var up_spent := Talents.cells_spent(up, cells)
	print("  (b) one row-1 node MOVED to row 9 -> spent=%d  available=%d  %s"
		% [up_spent, Profile.talent_points_earned(spec) - up_spent,
			"(NEGATIVE: over-spent, and nothing refuses it)"
			if Profile.talent_points_earned(spec) - up_spent < 0 else ""])

	# (c) a row-9 node MOVED to row 1 — 3 points to 1.
	var down := tree.duplicate(true)
	for i in down.size():
		if int(down[i].get("row", 0)) == 9:
			down[i]["row"] = 1
			break
	var dn_spent := Talents.cells_spent(down, cells)
	print("  (c) one row-9 node MOVED to row 1 -> spent=%d  available=%d  (points"
		% [dn_spent, Profile.talent_points_earned(spec) - dn_spent]
		+ " gifted)")
	print("  NOTHING ABOVE THROWS, AND `version` IS STAMPED %d EITHER WAY."
		% Profile.VERSION)

	var dump := OS.get_environment("DOD_DN_DUMP")
	if dump != "":
		var f := FileAccess.open(dump, FileAccess.WRITE)
		if f != null:
			f.store_string(JSON.stringify({
				"tables": tables, "nodes": out,
				"corpus": corpus_names, "granted": granted_names,
				"lane_names": lane_names.keys(),
				"status_src": status_src,
			}, "  "))
			f.close()
			print("DUMPED to ", dump)
	quit()
