# BATCH ET — THE RUNE POOL IS RETIRED.
#
#   §1  ALL 65 ENTRIES ARE RETIRED, AND DECLARATIVELY — every one carries a
#       string naming its batch and what is lost, and nothing is offerable
#   §2  THE OFFER NEVER COMES BACK EMPTY — driven through every live door
#   §3  RETIRED IS NOT DELETED — all 65 still resolve, still apply, still grant
#   §4  WHAT THE FOUR ABILITY-GRANTING ENTRIES ACTUALLY LOSE, derived
#   §5  THE READ SITES THE RETIREMENT STRANDS, PINNED AS A RATCHET
#
# **WHY THIS BATCH EARNS A GATE.** ET carries one ruling — the 53 offerable
# runes are retired, kept, and said to be kept — and it is a ruling that can
# decay in three directions at once, two of them silently.
#
#   §2 IS THE ONE THAT IS NOT SILENT AND IS STILL THE MOST IMPORTANT. With the
#     authored pool empty the generated stat family is the ONLY thing an offer
#     can contain, so every fallback in the rune layer is now load-bearing on
#     the first Peddler of every run. An empty offer list is the most visible
#     failure this project could ship. **It is DRIVEN rather than read**: every
#     static check in the tree would pass a pool that offers nothing.
#   §3 DECAYS SILENTLY AND IS THE REASON THE ENTRIES ARE KEPT AT ALL. A retired
#     rune that stops RESOLVING is indistinguishable from a deleted one until a
#     saved run loads it or a later batch tries to point something at it. All 65
#     are driven through `config`, `build` and `display_name`, and the four
#     ability grants through the real resolver.
#   §5 DECAYS SILENTLY AND IS THE TRAP ET SETS FOR THE NEXT BATCH. 48 of the 60
#     stat fields the retired pool writes have `data/runes.json` as their only
#     writer in the project, so their read sites in `battle.gd` are branches
#     that can no longer fire. **A branch that cannot fire looks exactly like
#     dead code**, and deleting one is deleting a mechanic the pool is meant to
#     come back to. The population is pinned as a RATCHET rather than a count.
#
# §4 encodes no ruling and says so: what the pool loses is a REPORT, and the
# reason it is here rather than only in `docs/reports/ET.md` is that three of
# the four claims in the brief were wrong and a document cannot re-derive
# itself. It is asserted as a PROPERTY of each entry, so the day one is
# un-retired the section describes the new shape rather than the old one.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_et.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	seed(20260903)
	print("BATCH ET — THE RUNE POOL IS RETIRED")
	_s1_all_retired()
	_s2_the_offer_is_never_empty()
	_s3_retired_is_not_deleted()
	_s4_what_the_grants_lose()
	_s5_the_stranded_read_sites()
	_g.report(self)


func _data() -> Dictionary:
	return JSON.parse_string(FileAccess.get_file_as_string("res://data/runes.json"))


func _member(class_key: String, spec: String) -> Dictionary:
	return {"key": class_key, "spec": spec, "runes": [], "abilities": [],
		"earned_abilities": [], "bm_abilities": []}


# ── §1 — ALL 65 ARE RETIRED, AND SAID TO BE ────────────────────────────────
#
# **THE TWO VINTAGES ARE ONE DECISION NOW AND THE STRINGS SAY WHICH IS WHICH.**
# EO §3 retired twelve; ET §1 retires the other fifty-three. A later reader
# meeting a uniformly empty pool must be able to tell that it was emptied on
# purpose, in two passes, with a reason recorded per entry — which is the whole
# difference between a retirement and a deletion that nobody wrote down.
#
# **A RETIREMENT STRING THAT NAMES NO BATCH IS THE FAILURE THIS ASSERTS.** The
# `retired` key is what `eligible_ids` reads, so a bare `"retired": "yes"` would
# empty the pool exactly as effectively and record nothing; the string is the
# only place the loss lives.
const EO_MARK := "BATCH EO"
const ET_MARK := "BATCH ET"

func _s1_all_retired() -> void:
	print("\n§1 — every entry is retired, and every one says why")
	var data := _data()
	ok(data.size() == 65, "§1: the authored pool is %d entries, expected 65" % data.size())

	var bare: Array = []
	var eo := 0
	var et := 0
	for id in data:
		var s := String((data[id] as Dictionary).get("retired", ""))
		if s == "":
			bare.append(String(id))
			continue
		# A string that names no batch and no loss is a filter, not a record.
		if not (s.contains(EO_MARK) or s.contains(ET_MARK)) or not s.contains("LOST:"):
			bare.append("%s (string names no batch or no loss)" % id)
			continue
		if s.contains(EO_MARK):
			eo += 1
		else:
			et += 1
	ok(bare.is_empty(),
		"§1: %s carry no retirement record — the pool must be retired DECLARATIVELY" % [bare])
	ok(eo == 12, "§1: %d entries carry EO's retirement, expected 12" % eo)
	ok(et == 53, "§1: %d entries carry ET's retirement, expected 53" % et)
	# **EO's TWELVE ARE NOT REWRITTEN.** ET §1 rules they keep their existing
	# strings; a batch that re-worded them would erase EO's own record of what
	# each of those twelve lost.
	print("    retirement vintages: %d at EO §3, %d at ET §1, 0 undeclared" % [eo, et])

	# ── AND NOTHING IS OFFERABLE, THROUGH THE LIVE DOOR ──────────────────────
	# The data half above is what a sweep can see. This is the half that matters:
	# `eligible_ids` is the ONLY door to the authored pool — `generate` and
	# `grant_rune` both reach it through here and nothing else — so an entry that
	# is offerable despite its string would show only here.
	var offerable: Array = []
	var specs := 0
	for ckey in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[ckey]:
			specs += 1
			for id2 in Runes.eligible_ids(_member(String(ckey), String(spec)), []):
				offerable.append("%s/%s" % [spec, id2])
	ok(specs == 12, "§1: walked %d specs, expected 12" % specs)
	ok(offerable.is_empty(),
		"§1: %s are still offerable against a fully retired pool" % [offerable])
	# THE SWEEP ASSERTS ITS OWN POPULATION (EA §5): a walk that read nothing
	# would report a clean tree, and "nothing is offerable" is exactly what a
	# broken walk prints.
	ok(Runes.ids().size() == 65,
		"§1: `Runes.ids()` reads %d entries — the walk lost its population" % Runes.ids().size())


# ── §2 — THE OFFER NEVER COMES BACK EMPTY ──────────────────────────────────
#
# **THIS IS THE VERIFICATION THAT MATTERS AND IT IS THE ONLY ONE THAT CANNOT BE
# FAKED BY A SOURCE READ.** `docs/master.html` says an exhausted pool falls back
# to the generated family and the offer list never comes back empty. That was a
# sentence about an edge case while 53 runes stood in front of it; it is the
# ordinary path now, on the first Peddler of every run.
#
# Every door is driven on a REAL member, including the two the pool's emptiness
# reaches in different ways: `roll_rune_candidates` draws THREE without
# replacement (a five-marker pool for a Warrior, against three draws), and the
# exhaustion floor is reached by a pouch holding every template there is.
const TRIPLE_TRIALS := 40

func _s2_the_offer_is_never_empty() -> void:
	print("\n§2 — the offer never comes back empty, driven through every door")
	var run: Node = root.get_node("/root/Run")
	var had_sim: bool = run.sim_run
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")

	var empties: Array = []
	var nameless: Array = []
	var payloadless: Array = []
	var non_template: Array = []
	var drawn := 0
	for ckey in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[ckey]:
			var m := _member(String(ckey), String(spec))
			# (1) THE PEDDLER and (2) the elite cache's single-rune path.
			var one: Dictionary = run.generate_rune(m)
			drawn += 1
			if one.is_empty():
				empties.append("%s/shop" % spec)
			else:
				if String(one.get("name", "")) == "":
					nameless.append("%s/shop" % spec)
				if not (one.get("payload", {}) is Dictionary) \
						or (one["payload"] as Dictionary).is_empty():
					payloadless.append("%s/shop" % spec)
				if not String(one.get("id", "")).begins_with("tpl_"):
					non_template.append("%s/shop -> %s" % [spec, one.get("id", "")])
			# (3) THE ELITE CACHE's pick-of-three, WITHOUT REPLACEMENT. A Warrior
			# has FIVE markers (max_resource is excluded for the class) against
			# three draws, which is the tightest this gets.
			for _t in TRIPLE_TRIALS:
				var triple: Array = run.roll_rune_candidates(_member(String(ckey), String(spec)))
				drawn += 1
				if triple.size() != 3:
					empties.append("%s/cache(%d)" % [spec, triple.size()])
					continue
				var seen := {}
				for c in triple:
					seen[String(c["name"])] = true
					if not String(c.get("id", "")).begins_with("tpl_"):
						non_template.append("%s/cache -> %s" % [spec, c.get("id", "")])
				if seen.size() != 3:
					empties.append("%s/cache repeated a name" % spec)
			# (4) THE GRANT DOOR — the rich arm and the map event both reach it.
			var granted: Dictionary = run.grant_rune(_member(String(ckey), String(spec)))
			drawn += 1
			if granted.is_empty():
				empties.append("%s/grant" % spec)
			# (5) THE EXHAUSTION FLOOR: a pouch holding every template there is.
			# This is the case `master.html` promises and the one the retirement
			# makes reachable — it used to sit behind 9-12 authored runes.
			var full := _member(String(ckey), String(spec))
			for t in Runes.TEMPLATES:
				full["runes"].append({"name": "Rune of %s" % t["noun"]})
			for _e in 3:
				var last: Dictionary = run.generate_rune(full)
				drawn += 1
				if last.is_empty():
					empties.append("%s/exhausted" % spec)
				elif String(last.get("name", "")) == "":
					nameless.append("%s/exhausted" % spec)
	ok(drawn > 500, "§2: only %d draws were taken — the drive read nothing" % drawn)
	ok(empties.is_empty(), "§2: an offer came back EMPTY — %s" % [empties])
	ok(nameless.is_empty(), "§2: an offer came back with no name — %s" % [nameless])
	ok(payloadless.is_empty(), "§2: an offer came back with an empty payload — %s" % [payloadless])
	# AND EVERY ONE OF THEM IS A GENERATED STAT STICK, WHICH IS ET's RULING
	# STATED AS A MEASUREMENT. A retired entry reaching a live offer is the one
	# way this batch could be wrong in the player's favour and still be wrong.
	ok(non_template.is_empty(),
		"§2: a RETIRED authored entry reached a live offer — %s" % [non_template])
	print("    %d draws through five doors; every one a generated stat stick, none empty" % drawn)
	run.sim_run = had_sim


# ── §3 — RETIRED IS NOT DELETED ────────────────────────────────────────────
#
# **THE ENTRIES ARE KEPT SO A LATER BATCH CAN POINT SOMETHING AT THEM AGAIN,
# AND KEPT CONTENT THAT NOTHING DRIVES IS CONTENT THAT ROTS** — EO's own words
# in `test_rune_battle`, and the reason that suite walks `Runes.ids()` rather
# than the offer pool. It still reads 97 / 0 with every entry retired, which is
# the load-bearing fact of this batch: the pool is unofferable, not broken.
#
# What this section adds is the half that suite does NOT cover — it drives the
# 48 SPEC-scoped entries, so the five universals and the twelve class runes are
# reached by nothing else — plus the resolver every ability grant depends on.
func _s3_retired_is_not_deleted() -> void:
	print("\n§3 — retired is not deleted: all 65 still resolve")
	var data := _data()
	var unresolved: Array = []
	var misnamed: Array = []
	var unbuilt: Array = []
	for id in data:
		var cfg: Dictionary = Runes.config(String(id))
		if cfg.is_empty():
			unresolved.append(String(id))
			continue
		# `display_name` is what eleven call sites read; a retired entry losing
		# its name would show as a blank shop row on a saved run.
		if Runes.display_name(cfg) != String((data[id] as Dictionary)["name"]):
			misnamed.append(String(id))
		var built: Dictionary = Runes.build(String(id))
		if built.is_empty() or String(built.get("name", "")) == "" \
				or not (built.get("payload", {}) is Dictionary) \
				or (built["payload"] as Dictionary).is_empty() \
				or int(built.get("price", 0)) <= 0:
			unbuilt.append(String(id))
	ok(unresolved.is_empty(), "§3: %s no longer resolve through `config`" % [unresolved])
	ok(misnamed.is_empty(), "§3: %s no longer return their authored name" % [misnamed])
	ok(unbuilt.is_empty(), "§3: %s no longer build a wearable instance" % [unbuilt])

	# **AND THE PAYLOAD STILL APPLIES.** A retired rune that resolved but paid
	# nothing would pass everything above. One entry of each payload shape is
	# driven through the real `Talents.apply_payload` onto a live spec config.
	var cfg2 := {"abilities": [], "armor": 0.0, "speed": 0.0}
	Talents.apply_payload(cfg2, Runes.build("anchor")["payload"], 1)
	ok(is_equal_approx(float(cfg2.get("speed", 0.0)), -10.0)
			and is_equal_approx(float(cfg2.get("armor", 0.0)), 0.12),
		"§3: a retired rune's stat payload no longer applies (armor %s, speed %s)" % [
			cfg2.get("armor", 0.0), cfg2.get("speed", 0.0)])

	# **AND EVERY ABILITY GRANT STILL RESOLVES**, which is a standing rule in
	# `CLAUDE.md`: a grant resolves through `Classes.pending_talent_ability`, not
	# through the draft resolver, and a definition that moved with its name
	# would leave its rune granting nothing, silently. Retiring the runes does
	# not retire that hazard — it hides it, which is worse.
	var dead: Array = []
	for id2 in data:
		var pay: Dictionary = (data[id2] as Dictionary).get("payload", {})
		var nm := Talents.granted_name(pay)
		if nm == "":
			continue
		if pay.has("new_ability"):
			# The definition is INLINE and this entry is its only copy.
			if Ability.make(pay["new_ability"]) == null:
				dead.append("%s (inline)" % id2)
		elif Classes.pending_talent_ability(nm) == null:
			dead.append("%s -> %s" % [id2, nm])
	ok(dead.is_empty(), "§3: %s name an ability that no longer resolves" % [dead])


# ── §4 — WHAT THE FOUR ABILITY-GRANTING ENTRIES ACTUALLY LOSE ──────────────
#
# **THE BRIEF GROUPED THESE FOUR AND THE GROUPING WAS WRONG IN BOTH DIRECTIONS,
# WHICH IS WHY THE ANSWER IS DERIVED HERE RATHER THAN WRITTEN DOWN.** It said
# Comet and Flayed Mind "grant an ability outright" while Binding Souls and Last
# Rites grant one "the hero may already hold", and that Binding Souls and Flayed
# Mind are the only way a hero obtains a card from outside his own pool.
#
# Driven through the live doors — `Run.draft_pool_left` for what a hero can
# draw and `Classes.protected_names` for what he starts with — the shape is:
#
#   comet          the ability is defined INLINE in the entry and exists in NO
#                  pool, NO kit and NO tree. **It is the only ability in the
#                  game reachable ONLY through a rune**, so this retirement is
#                  the one that removes an ability outright. The brief does not
#                  name it and it is the largest of the four losses.
#   binding_souls  the ONLY genuine out-of-pool grant, and only for two of its
#                  three buyers: Sacred Resolve is the Devout's own draft card,
#                  so for him it collides.
#   flayed_mind    NOT an out-of-pool grant at all. Mind Flay is in the
#                  Occultist's OWN draft pool and he is the only hero who can
#                  buy the rune.
#   last_rites     can NEVER grant. Resurrection is the Holy Cleric's PROTECTED
#                  CORE, so the payload always collides.
#
# **THE PROPERTY IS ASSERTED, NOT THE TABLE.** Each entry is classified live and
# the classification is printed; the day a card moves between pools this section
# reports the new shape instead of failing on the old one. What IS asserted is
# the thing a later batch could break without noticing: that `comet` is still
# the sole copy of its own ability, and that a colliding grant still has a
# fallback to pay.
func _s4_what_the_grants_lose() -> void:
	print("\n§4 — what the four ability-granting entries lose")
	var run: Node = root.get_node("/root/Run")
	var run_gd := load("res://scripts/run_state.gd")
	var data := _data()
	var granters: Array = []
	var rune_only: Array = []
	var no_fallback: Array = []
	for id in data:
		var e: Dictionary = data[id]
		var pay: Dictionary = e.get("payload", {})
		var nm := Talents.granted_name(pay)
		if nm == "":
			continue
		granters.append(String(id))
		var scope := String(e.get("scope", "universal"))
		var outside: Array = []
		var collides: Array = []
		for ckey in Classes.SPEC_IDS:
			for spec in Classes.SPEC_IDS[ckey]:
				if not _in_scope(scope, String(ckey), String(spec)):
					continue
				var m := _member(String(ckey), String(spec))
				m["spec"] = String(spec)
				# THE SINGLE DOOR the real draft reads, so this is what the hero
				# can actually draw rather than what a table says.
				var pools: Dictionary = run.draft_pool_left(m)
				var drawable: bool = Array(pools["spec"]).has(nm) \
					or Array(pools["class"]).has(nm)
				var core: bool = Classes.protected_names(String(spec)).has(nm)
				if core:
					collides.append(String(spec))
				elif not drawable:
					outside.append(String(spec))
		if outside.size() == 0 and collides.size() == 0:
			pass
		print("    %-14s grants %-16s out-of-pool for %s; always-collides for %s" % [
			id, nm, ("nobody" if outside.is_empty() else ", ".join(outside)),
			("nobody" if collides.is_empty() else ", ".join(collides))])
		# IS THIS ENTRY THE ONLY COPY OF ITS ABILITY? An inline `new_ability`
		# that resolves nowhere else is content living in the rune file, and
		# deleting the entry would delete the ability.
		if pay.has("new_ability") and Classes.pending_talent_ability(nm) == null:
			rune_only.append("%s -> %s" % [id, nm])
		# AND A COLLIDING GRANT MUST HAVE SOMETHING TO PAY. `_collided` records
		# the owed fallback and `Run.apply_upgrades` resolves it; a grant that
		# collides with nothing to fall back on is a 160g purchase that does
		# nothing, which is the defect the whole collision rule exists for.
		var held = Classes.pending_talent_ability(nm)
		if held != null:
			var cfg := {"abilities": [held]}
			Talents.apply_payload(cfg, Runes.build(String(id))["payload"], 1)
			var owed: Array = cfg.get(Talents.FALLBACK_KEY, [])
			var fits := false
			for up in run_gd.UPGRADE_PRIORITY:
				if run.upgrade_fits(String(up), held):
					fits = true
					break
			if owed.is_empty() or not fits:
				no_fallback.append("%s -> %s (owed %s, a fitting upgrade: %s)" % [
					id, nm, owed, fits])
	granters.sort()
	ok(granters.size() == 4,
		"§4: %d entries grant an ability, expected 4 — %s" % [granters.size(), granters])
	# **THE RATCHET THAT MATTERS.** `comet` is the sole copy of its own ability;
	# the assertion is that this is still TRUE and still exactly one entry, so a
	# batch that deleted the entry — or quietly re-homed COMET into a pool —
	# has to come here and say so.
	ok(rune_only == ["comet -> Comet"],
		"§4: the rune-only ability population is %s, not the recorded [comet -> Comet]" % [rune_only])
	ok(no_fallback.is_empty(),
		"§4: %s collide with an already-held card and have no upgrade to pay" % [no_fallback])


func _in_scope(scope: String, class_key: String, spec: String) -> bool:
	if scope.begins_with("class:"):
		return scope.trim_prefix("class:") == class_key
	if scope.begins_with("spec:"):
		return scope.trim_prefix("spec:") == spec
	return scope == "universal"


# ── §5 — THE READ SITES THE RETIREMENT STRANDS ─────────────────────────────
#
# **THIS IS THE TRAP ET SETS FOR THE NEXT BATCH AND IT IS WORTH A GATE BY
# ITSELF.** Of the 60 stat fields ET's own 53 entries write, 48 have
# `data/runes.json` as their only writer anywhere in the project; over the whole
# retired pool of 65 it is **72 of 84**, which is the population below. Their read
# sites in `battle.gd` and `unit.gd` still stand and can no longer fire — and a
# branch that cannot fire is indistinguishable, to every instrument this project
# owns, from dead code. **Deleting one is deleting a mechanic the pool is meant
# to come back to**, and it would be the smaller diff and the quieter one.
#
# `check_dp` §4 already asserts the forward direction — every field a rune
# writes has a live read site. **THAT PROPERTY IS UNCHANGED BY THE RETIREMENT
# AND THAT IS EXACTLY WHY IT IS NOT ENOUGH**: it would go on passing while the
# fields themselves were deleted from `runes.json` alongside their read sites.
# This asserts the population instead, as an ASYMMETRIC RATCHET: it may GROW (a
# rune authored onto a new field) and it may not SHRINK without a line changing
# here.
# **THE FLOOR IS THE LIVE NUMBER, NOT A ROUND ONE.** A floor set below what the
# tree actually carries is slack a deletion fits through: this gate's first
# reading was written against ET's own 53 (48 of 60) while the sweep walks all
# 65, and a floor of 48 would have let two dozen fields go without a word.
const RUNE_ONLY_FIELD_FLOOR := 72

func _s5_the_stranded_read_sites() -> void:
	print("\n§5 — the read sites the retirement strands")
	var data := _data()
	var fields := {}
	for id in data:
		for f in ((data[id] as Dictionary).get("payload", {}) as Dictionary).get("stat", {}):
			fields[String(f)] = true

	# WHO ELSE WRITES EACH FIELD. A payload key is `"field":`; a READ is
	# `cfg.get("field", 0)` or `u.field`, so the colon is what separates them.
	var sources: Array = []
	var d := DirAccess.open("res://scripts")
	if d != null:
		d.list_dir_begin()
		var f2 := d.get_next()
		while f2 != "":
			if f2.ends_with(".gd"):
				sources.append("res://scripts/" + f2)
			f2 = d.get_next()
		d.list_dir_end()
	sources.sort()
	ok(sources.size() >= 15, "§5: the sweep read %d scripts — too few" % sources.size())
	var blobs: Array = []
	for p in sources:
		blobs.append(Gate.strip_comments(FileAccess.get_file_as_string(p)))

	var only_runes: Array = []
	var shared := 0
	for f3 in fields:
		var elsewhere := false
		for b in blobs:
			if String(b).contains('"%s":' % f3) or String(b).contains('"%s" :' % f3):
				elsewhere = true
				break
		if elsewhere:
			shared += 1
		else:
			only_runes.append(String(f3))
	only_runes.sort()
	print("    %d stat fields written by the pool; %d written ONLY by data/runes.json" % [
		fields.size(), only_runes.size()])
	ok(only_runes.size() >= RUNE_ONLY_FIELD_FLOOR,
		"§5: %d fields are rune-only, below the floor of %d — a read site or a payload term was deleted while nothing could reach it" % [
			only_runes.size(), RUNE_ONLY_FIELD_FLOOR])

	# **AND EVERY ONE OF THEM IS STILL READ SOMEWHERE.** This is the assertion
	# `check_dp` §4 makes for the whole pool; it is re-made here over the
	# STRANDED subset alone, because that subset is the one whose read sites now
	# look dead. A field with no reader left is the deletion this section exists
	# to catch, arriving one branch at a time.
	var unread: Array = []
	for f4 in only_runes:
		var read := false
		for b2 in blobs:
			if String(b2).contains(String(f4)):
				read = true
				break
		if not read:
			unread.append(String(f4))
	ok(unread.is_empty(),
		"§5: %s are written by a retired rune and read by NOTHING — the branch was deleted" % [unread])
