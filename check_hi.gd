# BATCH HI §3 — ONE NAME, ONE DEFINITION.
#
#   §0  the census: every ability name the game's code and data define is
#       defined at exactly ONE site, and the census reads every definition
#       table the pool resolver walks
#   §1  the routes agree: every route that hands a hero an ability under a name
#       hands him ONE definition, and the pool resolver is one of those routes
#   §1b ...and what a real spawn seats agrees with it, card for card
#   §2  the label namespace beside it: a hero card's name on an enemy ability
#
# **NOTHING ASKED THIS BEFORE HI, ACROSS ALL 125 TARGETS (HH's finding).**
# `Classes.pool_ability`'s own comment says *"no name lives in two of these"*, and
# the resolver is what every earned card goes through — the battle spawn, the hero
# sheet, the forge, the upgrade pairing. A name defined twice resolves to whichever
# table the chain reaches first; the other copy is SHADOWED, drifts on its own, and
# every instrument that reads the pools reads the first. The per-tranche sweeps
# (`test_batch_bt`, `bu`, `bv`, `bw`, `cb`, `ce`) ask it of their own nine each,
# `test_batch_al` asks that every boss-pool entry resolves, and `check_gs` §1 counts
# RETURNING cards, which is how HH's control c9a read a second Aegis Wall as a
# thirty-first returning card. **This project has paid for the gap before**: CJ's
# Iron Will, the ten exact collisions FK found where its brief named five, and the
# file-wide rune-name rule `test_runes` pins because a retired rune still owns its
# name (FK §2a).
#
# **THE POPULATIONS, AND WHICH HALF OF THIS GATE COVERS EACH.** The census (§0) is
# read off the source, so it sees an IDENTICAL second copy, which no runtime
# comparison can: every `"display_name": "<literal>"` in the game's scripts, by
# the function that writes it — the drafted cards (`draft_ability`), the kit-only
# cards (`class_kit_ability`), the four former basic-attack overrides
# (`basic_override_ability`), the three hunter trophy tables, the pending and
# trimmed and vaulted cards, the twelve lineage definition tables with their
# enablers and the companion calls (`spec_abilities`), and the four class basics
# (`kit()`) — plus every ability a rune builds in its own payload (`new_ability`).
# The routes (§1) see a DRIFTED copy wherever it is reached from: the basics, the
# class kits, the lineage openings (the enablers), the definition tables, the
# companion calls, the four pools, the twelve boss pools, the overrides on a
# shelf, the rune grants and new abilities, the talent grants, the corpus, and a
# spawned party's bars (§1b) — each against `pool_ability` where the resolver
# reaches the name. **NOT COVERED, AND SAID SO**: the enemy abilities are a
# namespace of their own, built per kind from `data/enemies.json` and never
# resolved by name through the hero resolvers, so a shared name there is a LABEL
# collision (BR §1) and §2 holds it as a named set rather than a duplicate; and
# the abilities `battle.gd` builds at runtime under a name it did not write — the
# copies that take the name of the card they copy, and the pet picker's swap
# entries — are printed by §0 as dynamic sites, not asserted.
#
# **IT IS NOT A CORPUS WALK AND DOES NOT RETURN ONE.** Every walk below sits in a
# function that asserts and returns nothing, which is `check_da` §3b's line
# between enumerating and checking; the enumeration itself is still
# `Classes.ability_corpus()`, which §1 reads as one route among the others.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_hi.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://profile_check_hi.json"

# §2 — THE HERO CARD NAMES AN ENEMY ABILITY ALSO WEARS, NAMED. A label collision
# ships as specified and is flagged (BR §1): nothing resolves an enemy's ability
# through the hero resolvers, so the Warrior's basic and a raider's swing can
# share a word. The set is asserted as an EQUALITY so the next one is a decision
# somebody made, not a word that crept in.
const LABEL_SHARED := ["Strike"]

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	Profile.save_path = SCRATCH_PROFILE
	Profile.loaded = false
	Profile.data = {}
	print("BATCH HI — ONE NAME, ONE DEFINITION")
	_s0_census()
	_s1_routes()
	await _s1b_spawn()
	_s2_labels()
	if FileAccess.file_exists(SCRATCH_PROFILE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH_PROFILE))
	_g.report(self)


# The fields a definition is: two routes that hand a hero the same card hand him
# these the same. A number and the text that states it are both here, so a copy
# that drifted in either reads as a second definition.
func _fp(ab: Ability) -> String:
	if ab == null:
		return "<null>"
	return "%s|cost %d|dmg %d|bd %d|heal %d|delay %.2f|cd %d|%s|%s|faith %d|aoe %s|x%d|r%d|t%d|%s|%s|%s" % [
		ab.display_name, ab.cost, ab.damage, ab.pressure, ab.heal, ab.delay, ab.cooldown,
		ab.special, ab.dmg_type, ab.faith_cost, str(ab.aoe), ab.multi_hits, ab.random_hits,
		int(ab.target), str(ab.applies_status), ab.perfect_text, ab.description]


# ── §0 — THE CENSUS ─────────────────────────────────────────────────────────
func _s0_census() -> void:
	print("\n§0 — every ability name the game defines is defined at ONE site")
	var sites: Dictionary = Gate.definition_sites()
	var names := 0
	var total := 0
	var per_fn := {}
	var twice: Array = []
	for nm in sites:
		if String(nm) == Gate.DYNAMIC:
			continue
		names += 1
		var at: Array = sites[nm]
		total += at.size()
		for s in at:
			var fn := String(s).get_slice("/", 0)
			per_fn[fn] = int(per_fn.get(fn, 0)) + 1
		if at.size() != 1:
			twice.append("%s at %d sites (%s)" % [nm, at.size(), ", ".join(PackedStringArray(at))])
	twice.sort()
	ok(twice.is_empty(),
		"§0: %d ability name(s) are defined more than once — the resolver chain answers the first and shadows the rest: %s" % [
			twice.size(), "; ".join(PackedStringArray(twice))])
	# THE CENSUS READ SOMETHING. A parser that matched nothing would print the
	# clean line above over an empty population.
	ok(names >= 200 and int(per_fn.get("classes.gd:draft_ability", 0)) >= 100,
		"§0: the census read %d names (%d drafted) — the definition parse read (almost) nothing" % [
			names, int(per_fn.get("classes.gd:draft_ability", 0))])
	# EVERY CARD IN `classes.gd` IS WRITTEN BY NAME. A card built there from a
	# variable is a definition the census cannot count, so there is none.
	var dyn: Array = sites.get(Gate.DYNAMIC, [])
	var dyn_classes: Array = dyn.filter(func(s): return String(s).begins_with("classes.gd:"))
	ok(dyn_classes.is_empty(),
		"§0: classes.gd builds an ability under a name it does not write, which the census cannot count: %s" % str(dyn_classes))
	# EVERY TABLE THE RESOLVER WALKS IS IN THE CENSUS. The chain is read off
	# `pool_ability`'s own body — each `<table>(display_name)` it asks of its own
	# file — so a resolver added to the chain and written somewhere this parse does
	# not reach reds here instead of passing as a table with nothing in it. The one
	# qualified call, the talent tree's grant resolver, is `talents.gd`'s and holds
	# no card since FX; §1 reaches it as a route.
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/classes.gd"))
	var at0 := src.find("static func pool_ability(")
	var at1 := src.find("\nstatic func ", at0 + 1)
	var chain: Array = []
	if at0 >= 0:
		var body := src.substr(at0, (at1 - at0) if at1 > at0 else 4000)
		var rx := RegEx.new()
		rx.compile("(?<![.\\w])([a-z_]+_ability)\\(display_name\\)")
		for m in rx.search_all(body):
			var t := m.get_string(1)
			if t != "pool_ability" and not chain.has(t):
				chain.append(t)
	var bare_tables: Array = chain.filter(
		func(t): return int(per_fn.get("classes.gd:" + String(t), 0)) == 0)
	ok(chain.size() >= 8 and bare_tables.is_empty(),
		"§0: the resolver chain names %d tables and the census found no definition in %s — a table it walks is outside what this gate counts" % [
			chain.size(), str(bare_tables)])
	var fns: Array = per_fn.keys()
	fns.sort()
	for f in fns:
		print("    %-44s %d" % [f, int(per_fn[f])])
	print("  CHECKED %d names over %d definition sites; %d dynamic sites outside classes.gd (runtime copies and picker entries): %s" % [
		names, total, dyn.size() - dyn_classes.size(), str(dyn)])
	print("  resolver chain: %s" % ", ".join(PackedStringArray(chain)))


# ── §1 — THE ROUTES AGREE ───────────────────────────────────────────────────
# Every route a hero can be handed a card by, keyed by the card's name. Void on
# purpose (see the header).
func _s1_routes() -> void:
	print("\n§1 — every route that hands a hero a card hands him ONE definition")
	var routes := {}
	var add := func(nm: String, route: String, ab: Ability) -> void:
		if ab == null or nm == "":
			return
		if not routes.has(nm):
			routes[nm] = {}
		(routes[nm] as Dictionary)[route] = _fp(ab)
	for ck in Classes.SPEC_IDS:
		for b in Classes.kit(String(ck)):
			add.call(b.display_name, "kit(%s)" % ck, b)
		for kc in Classes.class_kit(String(ck)):
			add.call(kc.display_name, "class_kit(%s)" % ck, kc)
		for dn in Classes.draft_pool(String(ck)):
			add.call(String(dn), "draft_pool(%s)" % ck, Classes.pool_ability(String(dn)))
			var ov := Classes.basic_override_ability(String(dn))
			if ov != null:
				add.call(String(dn), "basic_override", ov)
		for sp in Classes.SPEC_IDS[ck]:
			var spec := String(sp)
			for d in Classes.spec_abilities(spec):
				add.call(d.display_name, "spec_abilities(%s)" % spec, d)
			for o in Classes.lineage_opening(spec):
				add.call(o.display_name, "lineage_opening(%s)" % spec, o)
			for k in Classes.opening_kit(String(ck), spec, [Classes.engine_of_spec(spec)]):
				add.call(k.display_name, "opening_kit(%s)" % spec, k)
			for bn in Classes.spec_pool(spec):
				add.call(String(bn), "spec_pool(%s)" % spec, Classes.spec_pool_ability(spec, String(bn)))
	for kind in Classes.COMPANION_KINDS + Classes.RUNE_COMPANION_KINDS:
		var call := Classes.companion_call(String(kind))
		if call != null:
			add.call(call.display_name, "companion_call(%s)" % kind, call)
	var parsed = JSON.parse_string(FileAccess.get_file_as_string("res://data/runes.json"))
	var rune_routes := 0
	if parsed is Dictionary:
		for rid in parsed:
			var row = parsed[rid]
			if not (row is Dictionary):
				continue
			var pay: Dictionary = (row as Dictionary).get("payload", {})
			if pay.get("new_ability") is Dictionary:
				var na: Ability = Ability.make(pay["new_ability"])
				add.call(na.display_name, "rune new_ability(%s)" % rid, na)
				rune_routes += 1
			if pay.has("grant_ability"):
				var g := String(pay["grant_ability"])
				add.call(g, "rune grant(%s)" % rid, Classes.pending_talent_ability(g))
				rune_routes += 1
	for tn in Classes.talent_granted_names():
		add.call(String(tn), "talent grant", Talents.granted_ability(String(tn)))
	for c in Classes.ability_corpus():
		add.call(c.display_name, "ability_corpus", c)
	# THE RESOLVER, ASKED OF EVERY NAME A ROUTE REACHED. Two kinds of card are
	# never the chain's to find, so a null there is not a second definition: the
	# four class basics resolve through `kit()` alone, and an ability a rune builds
	# in its own payload is resolved from that payload where the rune is worn (the
	# retired Comet). Anywhere else a null is a card a route hands out that the
	# pool resolver cannot find.
	var basics: Array = []
	for ck2 in Classes.SPEC_IDS:
		for b2 in Classes.kit(String(ck2)):
			basics.append(b2.display_name)
	var unresolved: Array = []
	var rune_built: Array = []
	for nm2 in routes:
		var pa := Classes.pool_ability(String(nm2))
		if pa == null:
			var only_rune := true
			for r0 in (routes[nm2] as Dictionary):
				if not String(r0).begins_with("rune new_ability("):
					only_rune = false
			if only_rune:
				rune_built.append(String(nm2))
			elif not basics.has(nm2):
				unresolved.append(String(nm2))
			continue
		(routes[nm2] as Dictionary)["pool_ability"] = _fp(pa)
	unresolved.sort()
	ok(unresolved.is_empty(),
		"§1: %d name(s) a route hands a hero do not resolve through pool_ability: %s" % [
			unresolved.size(), str(unresolved)])
	var split: Array = []
	var multi := 0
	for nm3 in routes:
		var by: Dictionary = routes[nm3]
		if by.size() > 1:
			multi += 1
		var seen := {}
		for r in by:
			seen[String(by[r])] = String(r)
		if seen.size() > 1:
			var parts := PackedStringArray()
			for fp in seen:
				parts.append("%s → %s" % [seen[fp], String(fp).substr(0, 90)])
			split.append("%s: %s" % [nm3, " | ".join(parts)])
	split.sort()
	ok(split.is_empty(),
		"§1: %d name(s) resolve to two different definitions depending on the route: %s" % [
			split.size(), "; ".join(PackedStringArray(split))])
	ok(routes.size() >= 200 and multi >= 150 and rune_routes >= 1,
		"§1: the routes reached %d names, %d of them by two routes or more, and %d rune routes — the comparison read (almost) nothing" % [
			routes.size(), multi, rune_routes])
	print("  CHECKED %d names; %d reached by two or more routes; %d through a rune; built by a rune's own payload and resolved there: %s" % [
		routes.size(), multi, rune_routes, str(rune_built)])


# ── §1b — WHAT A SPAWN SEATS ────────────────────────────────────────────────
# The kit overrides DU and DV found were built AT THE SPAWN, where no resolver
# looked, and GS §1 deleted them. A real party, one lineage per class, each
# holding its engine and seated with the cards its lineage opened with before GS
# (drafted, as a player gets them): every card on every bar must be the
# definition the resolver hands out — `kit()` for the basics.
func _s1b_spawn() -> void:
	print("\n§1b — what a real spawn seats is the definition the resolver hands out")
	var specs := ["berserker", "pyromancer", "inquisitor", "sharpshooter"]
	var scene: Node = await Gate.spawn(self, specs, {"lineage_cards": true})
	var basics := {}
	for ck in Classes.SPEC_IDS:
		for b in Classes.kit(String(ck)):
			basics[b.display_name] = _fp(b)
	var seated := 0
	var off: Array = []
	for h in scene.get("heroes"):
		if h.is_companion:
			continue
		for ab in h.abilities:
			seated += 1
			var want := ""
			if basics.has(ab.display_name):
				want = String(basics[ab.display_name])
			else:
				want = _fp(Classes.pool_ability(ab.display_name))
			if _fp(ab) != want:
				off.append("%s's %s (%s against %s)" % [h.unit_name, ab.display_name,
					_fp(ab).substr(0, 80), want.substr(0, 80)])
	ok(off.is_empty(),
		"§1b: %d seated card(s) are not the definition the resolver hands out: %s" % [
			off.size(), "; ".join(PackedStringArray(off))])
	ok(seated >= 20,
		"§1b: the spawn seated %d cards across four heroes — the comparison read (almost) nothing" % seated)
	print("  CHECKED %d cards seated across %d heroes" % [seated, specs.size()])
	scene.queue_free()
	await process_frame
	await process_frame


# ── §2 — THE LABEL NAMESPACE BESIDE IT ──────────────────────────────────────
func _s2_labels() -> void:
	print("\n§2 — a hero card's name on an enemy ability is a named label collision")
	var sites: Dictionary = Gate.definition_sites()
	var enemy_names := {}
	var parsed = JSON.parse_string(FileAccess.get_file_as_string("res://data/enemies.json"))
	if parsed is Dictionary:
		for kind in parsed:
			var cfg = parsed[kind]
			if cfg is Dictionary:
				for ea in (cfg as Dictionary).get("abilities", []):
					if ea is Dictionary:
						enemy_names[String((ea as Dictionary).get("display_name", ""))] = true
	var shared: Array = []
	for nm in enemy_names:
		if String(nm) != "" and sites.has(nm):
			shared.append(String(nm))
	shared.sort()
	ok(enemy_names.size() >= 20,
		"§2: the enemy walk read %d ability names — data/enemies.json's shape has moved" % enemy_names.size())
	ok(shared == LABEL_SHARED,
		"§2: the hero card names an enemy ability also wears are %s, not the named %s — a new one is a label collision somebody must rule on (BR §1)" % [
			str(shared), str(LABEL_SHARED)])
	print("  %d enemy ability names; shared with a hero card: %s" % [enemy_names.size(), str(shared)])
