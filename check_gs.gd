# BATCH GS — AN ENGINE BRINGS ONLY WHAT IT CANNOT RUN WITHOUT.
#
#   §0  THE MINIMUM, PER ENGINE — for all twenty-four, what the rune's hero opens
#       with beyond a hero holding no engine is its enablers and nothing else, and
#       the enablers are the table GS §1 recorded (a change to it is a ruling); no
#       engine replaces the class basic; no lineage takes a slot, so every hero
#       opens on the kit's three
#   §1  NO CARD DELETED BY ACCIDENT — every card a lineage's definitions hold is an
#       enabler, a class-kit card, or on that lineage's shelf of the class pool, and
#       so is every basic that was a lineage's override; each returning card is in
#       its class pool once and resolves; the two deleted structures stay deleted
#   §2  WHO IS OFFERED THEM — every returning card cast on a hero of its class
#       holding NO engine: the ones the table gates are refused, every other one
#       resolves and moves the board; and the offer door agrees, both directions
#   §3  THE WARRIOR'S KIT — Crushing Blow, Pommel Strike, Mocking Blow; a Warrior
#       with no engine opens with exactly that in a live fight; a Berserker holds
#       Bloodlust once and pays no slot for it, a Warden holding the Berserker's rune
#       second too, and one who dropped it holds none; Pommel Strike reads no engine,
#       and the bot casts it
#   §4  THE RULE, WHEREVER A RUNE'S TEXT RENDERS — the door answers the rule for all
#       twenty-four, live even over an instance saved with the old words, and the
#       desc for every ordinary rune; the Peddler, the pouch, an offer and the hero
#       sheet drawn with each; no game script reads a rune's desc around the door;
#       and the fit, measured per surface and printed
#   §5  THE PLAYER'S FILES — as this gate found them
#
# ── WHY §0 PINS A TABLE ──────────────────────────────────────────────────────
# **WHICH CARD TRAVELS IS CONTENT.** Three rows are the designer's (the Berserker's
# Bloodlust, the Pyromancer's Flamewave, the Beastmaster's summons) and three were
# the batch's derivation, PROPOSED until the designer ruled them at GT (they stand).
# A table that moved without a line
# changing here would be a ruling nobody took, so the gate carries its own copy of
# `MINIMUM` on purpose — the one place a second copy is the point — and the
# derivation of what a rune ADDS is off the kit builder a fight reads, never off
# `PROTECTED_CORES`, so the two are compared rather than read twice.
#
# ── EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM ───────────────────────────────
# No lineage slot beside the six enablers that take a bar entry; no card lost
# beside every card found once; a gated card refused beside every ungated one
# resolving; no Bloodlust for a Warrior without the Berserker's rune beside one
# Bloodlust for every Warrior with it; no placeholder on any surface beside the
# rule on every one of them, and the desc of an ordinary rune beside both.
#
# ── THE PLAYER'S FILES ───────────────────────────────────────────────────────
# `Run` writes its harness path under `--script` (FI); `Profile` and `Relics` are
# pointed at scratch files of this gate's own before a screen is drawn, and §5
# reads the player's three files byte for byte.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_gs.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const NO_LINEAGE := ["", "", "", ""]
const SCRATCH_PROFILE := "user://gs_profile.json"
const SCRATCH_RELICS := "user://gs_relics.json"

# **THE TABLE GS §1 RECORDED.** An engine not named here brings nothing. The
# Sharpshooter's enabler is Quick Shot, the Hunter's class basic, so it brings
# nothing a Hunter does not already hold and is not a row.
# **BATCH HB §3 — PACK BOND'S ROW IS GONE, RULED BY THE DESIGNER.** The three
# summons were GS's one stated exception; HB put the pet in every Hunter's CLASS
# KIT (Summon Companion), so Pack Bond brings nothing, and the table names five.
const MINIMUM := {
	"bloodrage": ["Bloodlust"],                                  # ruled
	"overburn": ["Flamewave"],                                   # ruled
	"permafrost": ["Razor Ice"],                                 # ruled at GT
	"conviction": ["Divine Shield"],                             # ruled at GT
	"old_gods": ["Hex of Ruin"],                                 # ruled at GT
}
const WARRIOR_KIT := ["Crushing Blow", "Pommel Strike", "Mocking Blow"]

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _returning: Dictionary = {}   # card -> [class, lineage]


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH GS — AN ENGINE BRINGS ONLY WHAT IT CANNOT RUN WITHOUT")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before anything is drawn")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_scratch_files()
	_s0_the_minimum()
	_s1_nothing_lost()
	await _s2_who_is_offered()
	await _s3_the_warrior_kit()
	await _s4_the_rule_everywhere()
	_s5_the_players_files()
	Engine.time_scale = 1.0
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

func _scratch_files() -> void:
	Profile.save_path = SCRATCH_PROFILE
	if FileAccess.file_exists(SCRATCH_PROFILE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH_PROFILE))
	Profile.loaded = false
	Profile.data = {}
	Relics.save_path = SCRATCH_RELICS
	var rf := FileAccess.open(SCRATCH_RELICS, FileAccess.WRITE)
	rf.store_string("[]")
	rf.close()
	Relics.loaded = false


func _names(abilities: Array) -> Array:
	return abilities.map(func(a): return a.display_name)


func _all_engines() -> Array:
	var out: Array = []
	for key in SEATS:
		for pid in Classes.class_engines(key):
			out.append(String(pid))
	return out


func _hero(s: Node, key: String) -> BattleUnit:
	for h in s.get("heroes"):
		if not h.is_companion and h.hero_key == key:
			return h
	return null


func _clear(s: Node) -> void:
	s.queue_free()
	for _i in 4:
		await process_frame


func _live(n: Node) -> bool:
	return n != null and not n.is_queued_for_deletion() \
		and (not (n is CanvasItem) or (n as CanvasItem).is_visible_in_tree())


func _labels(n: Node, out: Array) -> void:
	if not _live(n):
		return
	if n is Label:
		out.append(n)
	for c in n.get_children():
		_labels(c, out)


func _label_with(n: Node, needle: String) -> Label:
	var ls: Array = []
	_labels(n, ls)
	for l in ls:
		if String((l as Label).text).contains(needle):
			return l
	return null


# A `static func`'s body out of comment-stripped source — `Gate.returning_bodies`
# reads `func` lines only, and every function in `classes.gd` is static.
func _static_body(code: String, fname: String) -> String:
	var lines := code.split("\n")
	var out := ""
	var inside := false
	for l in lines:
		if String(l).begins_with("static func %s(" % fname):
			inside = true
		elif inside and (String(l).begins_with("static func ") or String(l).begins_with("func ") \
				or String(l).begins_with("const ")):
			break
		if inside:
			out += String(l) + "\n"
	return out


func _panel_of(n: Node) -> Control:
	var p: Node = n
	while p != null and not (p is PanelContainer):
		p = p.get_parent()
	return p


# A fresh member of `key`, awakened, holding `engines` (ids) and nothing earned.
func _member(key: String, lineage: String, engines: Array) -> Dictionary:
	var m := {"key": key, "spec": lineage, "awakened": true, "bm_abilities": [],
		"runes": [], "engines": []}
	for pid in engines:
		var r: Dictionary = Runes.build(Runes.engine_rune_id(String(pid)))
		r["equipped"] = true
		m["engines"].append(r)
	return m


# ── §0 — THE MINIMUM, PER ENGINE ────────────────────────────────────────────

func _s0_the_minimum() -> void:
	print("\n§0 — what each engine brings, and nothing else")
	var carrying := 0
	var engines := _all_engines()
	ok(engines.size() == 24, "§0: the classes hold %d engines, not twenty-four" % engines.size())
	for key in SEATS:
		var bare: Array = _names(Classes.opening_kit(key, "", []))
		var basic := String(Classes.kit(key)[0].display_name)
		ok(bare.size() == 4 and bare[0] == basic,
			"§0: a %s with no engine opens with %s — not his basic and his kit of three" % [key, str(bare)])
		for pid in Classes.class_engines(key):
			var lineage := Classes.engine_spec(String(pid))
			var own: Array = _names(Classes.opening_kit(key, lineage, [pid]))
			var adds: Array = own.filter(func(n): return not bare.has(n))
			var want: Array = MINIMUM.get(String(pid), [])
			ok(adds == want,
				"§0: the %s rune brings %s — the minimum recorded for it is %s" % [pid, str(adds), str(want)])
			if not want.is_empty():
				carrying += 1
			# NOTHING BARE IS TAKEN AWAY, AND THE CLASS BASIC STANDS IN SLOT 0 —
			# BUT ONE ENGINE TAKES THE PET AWAY (HB §4, ruled): the Sharpshooter's
			# Lethal Aim dismisses Summon Companion, and nothing else is ever taken.
			for n in bare:
				if String(n) == Classes.PET_CARD and Classes.dismisses_pet([pid]):
					ok(not own.has(n), "§0: the %s rune dismisses the pet and still opens with %s" % [pid, n])
				else:
					ok(own.has(n), "§0: the %s rune takes %s away from the bare kit" % [pid, n])
			ok(own[0] == basic,
				"§0: the %s rune replaces the class basic with %s" % [pid, own[0]])
			# WHAT TRAVELS IS WHAT THE TABLE NAMES, SECOND SLOT OR FIRST.
			var en: Array = Classes.engine_enablers(String(pid))
			if String(pid) == "lethal_aim":
				ok(en == [basic], "§0: the Sharpshooter's enabler is not the Hunter's own basic (%s)" % str(en))
			else:
				ok(en == want, "§0: `engine_enablers(%s)` is %s against the table's %s" % [pid, str(en), str(want)])
	ok(carrying == 5, "§0: %d engines bring a card — the table names five (HB took Pack Bond's summons into the class kit)" % carrying)
	print("    %d of 24 engines bring a card; the other %d bring nothing" % [carrying, 24 - carrying])
	# NO LINEAGE TAKES A SLOT: the authored `slots` is the enablers' bar entries,
	# so the lineage's term is zero — and the five that carry a card take one entry
	# (six until HB, when the Beastmaster's summons became the class kit's card).
	var entries := 0
	for spec in Classes.all_specs():
		ok(Classes.lineage_slots(String(spec)) == 0,
			"§0: the %s lineage takes %d slots" % [spec, Classes.lineage_slots(String(spec))])
		ok(Classes.core_slots(String(spec)) == Classes.enabler_slots(String(spec)),
			"§0: %s's authored slots (%d) are not its enablers' bar entries (%d)" % [
				spec, Classes.core_slots(String(spec)), Classes.enabler_slots(String(spec))])
		entries += Classes.enabler_slots(String(spec))
	ok(entries == 5, "§0: %d lineages' enablers take a bar entry — the five that carry a card" % entries)
	# EVERY HERO OPENS ON THE KIT'S THREE, and one earned card is a fourth — **AND
	# THE SHARPSHOOTER ON TWO (HB §4)**: his engine dismisses the pet, and the slot
	# it held is his for a drafted card. The one engine that dismisses is counted
	# apart, so the twenty-three that do not still have to read three each.
	var threes := 0
	var twos := 0
	for key in SEATS:
		for pid in Classes.class_engines(key):
			var m := _member(key, Classes.engine_spec(String(pid)), [pid])
			var want_slots := 2 if Classes.dismisses_pet([pid]) else 3
			if int(_run.ability_slots_used(m)) == want_slots:
				if want_slots == 3:
					threes += 1
				else:
					twos += 1
			else:
				ok(false, "§0: a %s holding %s opens using %d slots, not the %d his kit takes" % [
					key, pid, _run.ability_slots_used(m), want_slots])
		var none := _member(key, "", [])
		ok(int(_run.ability_slots_used(none)) == 3, "§0: a %s holding no engine opens off three slots" % key)
		var pool: Array = Classes.draft_pool(key)
		none["bm_abilities"] = [pool[0]]
		ok(int(_run.ability_slots_used(none)) == 4, "§0: one earned card is not a fourth slot for a %s" % key)
	ok(threes == 23 and twos == 1,
		"§0: %d of 24 engines open on three slots and %d on two — twenty-three and the Sharpshooter's one" % [threes, twos])


# ── §1 — NO CARD DELETED BY ACCIDENT ────────────────────────────────────────

func _s1_nothing_lost() -> void:
	print("\n§1 — every card that stopped travelling is in a pool")
	var overrides := 0
	for key in SEATS:
		var kit: Array = Classes.class_kit_names(key)
		var pool: Array = Classes.draft_pool(key)
		for spec in Classes.SPEC_IDS[key]:
			var shelf: Array = Classes.spec_draft_pool(String(spec))
			var en: Array = Classes.core_enablers(String(spec))
			for ab in Classes.spec_abilities(String(spec)):
				var n := String(ab.display_name)
				# BATCH HB §1 — A FOURTH HOME: A CALL OF THE KIT'S PET CARD. The
				# three summons keep their one definition here and are the three
				# calls Summon Companion chooses between at the cast, so a summon
				# whose card is in the kit is housed; one whose card is not is not.
				var call := int(kit.has(Classes.PET_CARD) and Classes.companion_call(
					String(n).get_slice(" ", 1).to_lower()) != null and n.begins_with("Summon "))
				var homes := int(en.has(n)) + int(kit.has(n)) + int(shelf.has(n)) + call
				ok(homes == 1, "§1: %s (the %s's) has %d homes among enabler, kit, shelf and the pet's calls — one" % [n, spec, homes])
				if not en.has(n) and not kit.has(n) and call == 0:
					_returning[n] = [key, String(spec)]
			# THE BASICS THAT WERE A LINEAGE'S OVERRIDE, found on its shelf by the
			# one resolver that defines them.
			for n2 in shelf:
				if Classes.basic_override_ability(String(n2)) != null:
					_returning[String(n2)] = [key, String(spec)]
					overrides += 1
		for n3 in _returning:
			if String(_returning[n3][0]) != key:
				continue
			ok(pool.count(n3) == 1, "§1: %s is in the %s pool %d times — once" % [n3, key, pool.count(n3)])
			var ab3: Ability = Classes.pool_ability(String(n3))
			ok(ab3 != null and ab3.display_name == String(n3), "§1: %s does not resolve through the pool resolver" % n3)
			ok(not Classes.spec_pool(String(_returning[n3][1])).has(n3),
				"§1: %s is in a zone-boss pool as well" % n3)
	ok(overrides == 4, "§1: %d of the four former basic-attack overrides are on a shelf" % overrides)
	# GS §1's twenty-nine and HB §2's Tripwire, which left the class kit when
	# Summon Companion took its slot and landed on the Survivalist's shelf.
	ok(_returning.size() == 30, "§1: %d cards returned to a pool — GS §1 counted twenty-nine, and HB's Tripwire is the thirtieth" % _returning.size())
	var per := {}
	for n4 in _returning:
		per[_returning[n4][0]] = int(per.get(_returning[n4][0], 0)) + 1
	var depths := PackedStringArray()
	for key in SEATS:
		depths.append("%s %d (+%d)" % [key, Classes.draft_pool(key).size(), int(per.get(key, 0))])
	print("    %d returning cards; class pools: %s" % [_returning.size(), ", ".join(depths)])
	# THE ENABLERS ARE IN NO POOL — the failure BO's table exists to prevent.
	for pid in MINIMUM:
		for n5 in MINIMUM[pid]:
			var cls := Classes.engine_class(String(pid))
			ok(not Classes.draft_pool(cls).has(n5), "§1: the enabler %s is in the %s draft pool" % [n5, cls])
	# DELETED, NOT ZEROED — and the names that replaced them are live. The names are
	# split so this file's own source never spells them whole.
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/classes.gd"))
	for dead in ["ENGINE_" + "BOUND", "engine_" + "bound(", "apply_kit_" + "overrides(", "_carry_" + "enablers("]:
		ok(not src.contains(dead), "§1: `%s` still has code in `classes.gd`" % dead)
	for live in ["static func lineage_opening(", "static func basic_override_ability("]:
		ok(src.contains(live), "§1: `%s` is gone from `classes.gd`" % live)
	var builder := _static_body(src, "opening_kit")
	ok(builder.contains("lineage_opening("),
		"§1: the kit builder no longer reads `lineage_opening` — a lineage opens with something else")
	ok(not builder.contains("spec_abilities("),
		"§1: the kit builder reads a lineage's whole definition table again")


# ── §2 — WHO IS OFFERED THEM ────────────────────────────────────────────────

func _board() -> Node:
	var over := {}
	for seat in 4:
		over[seat] = {"engines": []}
	return await Gate.spawn(self, NO_LINEAGE, {"deterministic": true, "party": over})


func _dress(s: Node, caster: BattleUnit) -> void:
	for e in s.get("enemies"):
		if e.dead:
			continue
		e.max_hp = 100000
		e.hp = int(e.max_hp * 0.5)
		e.pressure = 30
		s._apply_status(e, "burn", 5, 12, 0, caster)
		s._apply_status(e, "chilled", 5, 0, 0, caster)
		s._apply_status(e, "poison", 5, 12, 0, caster)
	for h in s.get("heroes"):
		if h.is_companion:
			continue
		h.hp = maxi(int(h.max_hp * 0.5), 1)
		h.resource = 99999
		h.max_resource = 99999
		h.cooldowns.clear()


func _snap(s: Node) -> String:
	var parts := PackedStringArray()
	for h in s.get("heroes"):
		parts.append("%d|%d|%s|%s|%s" % [h.hp, h.resource, str(h.stance), h.second_resource,
			str(h.statuses.map(func(x): return String(x.id)))])
	for e in s.get("enemies"):
		parts.append("%d|%d|%s" % [e.hp, e.pressure, str(e.statuses.map(func(x): return String(x.id)))])
	return "/".join(parts)


# One card cast by a hero of its class holding no engine: [usable, moved].
func _cast_bare(card: String, key: String, call_companion: bool) -> Array:
	var s: Node = await _board()
	var u: BattleUnit = _hero(s, key)
	if u == null:
		await _clear(s)
		return [false, false]
	for h in s.get("heroes"):
		h.engines = []
	_dress(s, u)
	var foes: Array = s.get("enemies").filter(func(e): return not e.dead)
	if call_companion:
		await s._resolve(u, Classes.pool_ability("Call the Wilds"), foes[0], "good")
	u.resource = 99999
	u.cooldowns.clear()
	var ab: Ability = Classes.pool_ability(card)
	var target: BattleUnit = u if ab.target == Ability.Target.ALLY else foes[0]
	seed(20260918)
	var before := _snap(s)
	var usable := bool(s._ability_usable(u, ab))
	if usable:
		await s._resolve(u, ab, target, "good")
	var moved := _snap(s) != before
	await _clear(s)
	return [usable, moved]


func _s2_who_is_offered() -> void:
	print("\n§2 — who is offered a returning card")
	var gated := 0
	var working := 0
	for card in _returning:
		var key := String(_returning[card][0])
		var eng := Classes.engine_read(String(card))
		var r: Array = await _cast_bare(String(card), key, false)
		if eng != "":
			gated += 1
			ok(not bool(r[0]), "§2: %s is gated on %s and a %s holding none can cast it" % [card, eng, key])
			# A ROW FOR KILL COMMAND WOULD PASS THE LINE ABOVE ON A BARE BOARD, so its
			# gated arm is driven with the companion an earned Call the Wilds calls —
			# the door that opens without an engine, and the reason it is not a row.
			if String(card) == "Kill Command":
				var rk: Array = await _cast_bare(String(card), key, true)
				ok(not bool(rk[0]),
					"§2: Kill Command is a row of `ENGINE_READ` and opens on an earned Call the Wilds with no engine — it is conditional on a card, not an engine")
		else:
			# KILL COMMAND IS THE ONE THAT NEEDS A BODY ON THE FIELD, AND AN EARNED
			# CALL THE WILDS SUMMONS ONE WITH NO ENGINE — the arm is that, not a bare
			# board, which is exactly why it is not a row.
			if String(card) == "Kill Command":
				ok(not bool(r[0]), "§2: Kill Command cast with no companion standing")
				r = await _cast_bare(String(card), key, true)
			ok(bool(r[0]) and bool(r[1]),
				"§2: %s is offered to a %s holding no engine and does nothing for him (usable %s, moved %s)" % [
					card, key, r[0], r[1]])
			if bool(r[0]) and bool(r[1]):
				working += 1
	print("    %d refused without their engine (rows of `ENGINE_READ`), %d work with none" % [gated, working])
	ok(gated == 3, "§2: %d returning cards are gated — GS derived three" % gated)
	ok(gated + working == _returning.size(), "§2: %d of %d returning cards were driven" % [gated + working, _returning.size()])
	# THE OFFER DOOR, BOTH DIRECTIONS: offered to none exactly when ungated, and
	# offered to the holder when gated.
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.party[i]["awakened"] = true
		_run.party[i]["spec"] = ""
		_run.party[i]["engines"] = []
	_run.specs_chosen = true
	for card in _returning:
		var key2 := String(_returning[card][0])
		var m: Dictionary = _run.party[SEATS.find(key2)]
		var eng2 := Classes.engine_read(String(card))
		var bare: Array = _run.draft_pool_left(m)
		ok(bare.has(card) == (eng2 == ""),
			"§2: a %s holding no engine is %s %s" % [key2, "offered" if bare.has(card) else "not offered", card])
		if eng2 != "":
			m["engines"] = [{"engine": eng2, "equipped": true}]
			ok((_run.draft_pool_left(m) as Array).has(card),
				"§2: a %s holding %s is not offered %s" % [key2, eng2, card])
			m["engines"] = []


# ── §3 — THE WARRIOR'S KIT ──────────────────────────────────────────────────

func _s3_the_warrior_kit() -> void:
	print("\n§3 — Crushing Blow, Pommel Strike, Mocking Blow")
	ok(Classes.class_kit_names("warrior") == WARRIOR_KIT,
		"§3: the Warrior kit is %s" % str(Classes.class_kit_names("warrior")))
	for key in SEATS:
		ok(not Classes.class_kit_names(key).has("Bloodlust"), "§3: Bloodlust is in the %s kit" % key)
		ok(not Classes.draft_pool(key).has("Bloodlust") and not Classes.draft_pool(key).has("Pommel Strike"),
			"§3: Bloodlust or Pommel Strike is in the %s draft pool" % key)
	ok(Classes.core_enablers("berserker") == ["Bloodlust"], "§3: Bloodlust is not the Berserker's enabler")
	ok(Classes.engine_read("Pommel Strike") == "", "§3: Pommel Strike is gated on an engine")
	# A WARRIOR WITH NO ENGINE, IN A LIVE FIGHT.
	var s: Node = await Gate.spawn(self, NO_LINEAGE, {"party": {0: {"engines": []}}})
	var w: BattleUnit = _hero(s, "warrior")
	var got: Array = _names(w.abilities) if w != null else []
	ok(got == ["Strike"] + WARRIOR_KIT, "§3: a Warrior with no engine opens a fight with %s" % str(got))
	print("    a Warrior with no engine opens with: %s" % ", ".join(PackedStringArray(got)))
	await _clear(s)
	# BLOODLUST ONCE, AND NO SLOT FOR IT — three routes to it, and one without it.
	var cases := [
		["the Berserker", "berserker", ["bloodrage"], 1],
		["the Berserker with the Warden's rune second", "berserker", ["bloodrage", "heavy_plating"], 1],
		["a Warden with the Berserker's rune second", "warden", ["heavy_plating", "bloodrage"], 1],
		["a Berserker who dropped his rune", "berserker", [], 0],
		["a Warden", "warden", ["heavy_plating"], 0],
	]
	for c in cases:
		var m := _member("warrior", String(c[1]), c[2])
		var kit: Array = _run.opening_kit_names(m)
		ok(kit.count("Bloodlust") == int(c[3]),
			"§3: %s holds Bloodlust %d times (%s)" % [c[0], kit.count("Bloodlust"), str(kit)])
		ok(int(_run.ability_slots_used(m)) == 3, "§3: %s opens using %d slots" % [c[0], _run.ability_slots_used(m)])
		# THE SPAWN AGREES WITH THE BUILDER.
		var over := {0: {"spec": String(c[1]), "engines": m["engines"]}}
		var s2: Node = await Gate.spawn(self, [String(c[1]), "", "", ""], {"party": over})
		var w2: BattleUnit = _hero(s2, "warrior")
		var live: Array = _names(w2.abilities) if w2 != null else []
		ok(live.count("Bloodlust") == int(c[3]) and live == kit,
			"§3: in a fight %s holds %s against the builder's %s" % [c[0], str(live), str(kit)])
		await _clear(s2)
	# POMMEL STRIKE READS NO ENGINE: its Stun lands from a Warrior holding none.
	var s3: Node = await _board()
	var w3: BattleUnit = _hero(s3, "warrior")
	_dress(s3, w3)
	var foe: BattleUnit = s3.get("enemies").filter(func(e): return not e.dead and not e.is_boss)[0]
	foe.remove_status("stunned")
	w3.resource = 999
	await s3._resolve(w3, Classes.pool_ability("Pommel Strike"), foe, "good")
	ok(foe.has_status("stunned"), "§3: Pommel Strike from a Warrior holding no engine lays no Stun")
	# THE BOT CASTS IT — once the taunt is up, at a mark the Stun can land on.
	w3.cooldowns.clear()
	w3.resource = 999
	for e in s3.get("enemies"):
		e.remove_status("stunned")
		s3._apply_status(e, "mocked", 4, s3.get("heroes").find(w3))
	var pick: Array = s3._bot_class_kit_pick(w3)
	ok(not pick.is_empty() and pick[0].display_name == "Pommel Strike",
		"§3: the bot's class-kit branch does not cast Pommel Strike (%s)" % (
			"nothing" if pick.is_empty() else pick[0].display_name))
	for e2 in s3.get("enemies"):
		e2.remove_status("mocked")
	var pick2: Array = s3._bot_class_kit_pick(w3)
	ok(not pick2.is_empty() and pick2[0].display_name == "Mocking Blow",
		"§3: with no enemy held to him the bot's first kit card is not the taunt (%s)" % (
			"nothing" if pick2.is_empty() else pick2[0].display_name))
	await _clear(s3)


# ── §4 — THE RULE, WHEREVER A RUNE'S TEXT RENDERS ───────────────────────────

func _s4_the_rule_everywhere() -> void:
	print("\n§4 — an engine rune shows its rule, and nothing else")
	var ids: Array = []
	for pid in _all_engines():
		ids.append(Runes.engine_rune_id(pid))
	# THE DOOR.
	var door := 0
	for id in ids:
		var pid2 := String(Runes.config(String(id))["engine"])
		var rule: String = Runes.engine_text(pid2)
		var ph := String(Runes.config(String(id))["desc"])
		var r: Dictionary = Runes.build(String(id))
		ok(Runes.shown_desc(r) == rule, "§4: the door does not answer %s's rule" % id)
		ok(not Runes.shown_desc(r).contains(ph), "§4: %s shows its placeholder" % id)
		ok(rule.length() > ph.length() * 2, "§4: %s's rule text is no longer than its placeholder (%s)" % [id, rule])
		# LIVE, NOT OFF THE INSTANCE: an instance saved with GK's words still shows the rule.
		var stale := r.duplicate()
		stale["desc"] = "%s %s" % [ph, rule]
		ok(Runes.shown_desc(stale) == rule, "§4: a saved %s shows the words it was saved with" % id)
		door += 1
	var ordinary := 0
	for rid in Runes.ids():
		if Runes.is_engine_rune(String(rid)) or Runes.is_retired(String(rid)):
			continue
		var o: Dictionary = Runes.build(String(rid))
		ok(Runes.shown_desc(o) == String(o["desc"]), "§4: the door rewrites the ordinary rune %s" % rid)
		ordinary += 1
	ok(door == 24 and ordinary >= 20, "§4: the door was asked of %d engine runes and %d ordinary ones" % [door, ordinary])
	print("    the door: 24 engine runes answer their rule; %d ordinary runes their own desc" % ordinary)
	# NO GAME SCRIPT READS A RUNE'S DESC AROUND IT. Every rune a screen shows is
	# named `rune`, `er`, `r` or `offer["rune"]` at its render site; the positive
	# arm is the door's own six calls.
	var calls := 0
	for f in ["shop_screen.gd", "map_screen.gd", "party_screen.gd", "spec_choice_screen.gd"]:
		var code := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/" + f))
		calls += code.count("Runes.shown_desc(")
		for needle in ['rune["desc"]', 'er["desc"]', 'rune.get("desc"', 'er.get("desc"']:
			ok(not code.contains(needle), "§4: `%s` reads a rune's desc around the door (%s)" % [f, needle])
	ok(calls == 6, "§4: the four screens ask the door %d times — six surfaces render a rune's text" % calls)
	await _s4b_the_surfaces(ids)


func _s4b_the_surfaces(ids: Array) -> void:
	# THE PEDDLER. One offer at a time, so the height read is this rune's alone.
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.party[i]["awakened"] = true
		_run.party[i]["spec"] = ""
		_run.party[i]["engines"] = []
	_run.specs_chosen = true
	_run.active = true
	_run.gold = 999
	change_scene_to_file("res://scenes/shop.tscn")
	await Gate.frames(self, 8)
	var shop: Node = current_scene
	ok(Gate.scene_name(self) == "Shop", "§4: the Peddler is not on screen (%s)" % Gate.scene_name(self))
	var fit := {"shop": [], "pouch": [], "offer": []}
	var shown := {"shop": 0, "pouch": 0, "offer": 0, "sheet": 0}
	for id in ids:
		var cls := Classes.engine_class(String(Runes.config(String(id))["engine"]))
		var r: Dictionary = Runes.build(String(id))
		shop.offers = [{"member_idx": SEATS.find(cls), "rune": r}]
		shop._draw_screen()
		await Gate.frames(self, 3)
		var l: Label = _label_with(shop, String(r["name"]) + "  [")
		if _shows(l, String(id), "the Peddler"):
			shown["shop"] += 1
			fit["shop"].append([String(id), int(_panel_of(l).size.y)])
	# THE POUCH AND AN OFFER, ON THE MAP.
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 10)
	var mp: Node = current_scene
	ok(Gate.scene_name(self) == "Map", "§4: the map is not on screen (%s)" % Gate.scene_name(self))
	for id2 in ids:
		var cls2 := Classes.engine_class(String(Runes.config(String(id2))["engine"]))
		var idx := SEATS.find(cls2)
		var r2: Dictionary = Runes.build(String(id2))
		r2["equipped"] = true
		_run.party[idx]["engines"] = [r2]
		_close_overlays(mp)
		await Gate.frames(self, 2)
		mp._open_rune_panel(idx)
		await Gate.frames(self, 3)
		var l2: Label = _label_with(mp, String(r2["name"]) + " — ")
		if _shows(l2, String(id2), "the pouch"):
			shown["pouch"] += 1
			var pan: Control = _panel_of(l2)
			fit["pouch"].append([String(id2), int(pan.position.y + pan.size.y)])
		_run.party[idx]["engines"] = []
	_close_overlays(mp)
	for key in SEATS:
		var idx2 := SEATS.find(key)
		var six: Array = Classes.class_engines(key).map(func(p): return Runes.engine_rune_id(String(p)))
		for h in 2:
			var trip: Array = []
			for rid in six.slice(h * 3, h * 3 + 3):
				trip.append(Runes.build(String(rid)))
			_run.party[idx2]["rune_candidates"] = [trip]
			_run.party[idx2]["rune_picks_owed"] = 1
			_close_overlays(mp)
			await Gate.frames(self, 2)
			mp._open_pick_overlay(idx2)
			await Gate.frames(self, 3)
			var bottom := 0
			for rr in trip:
				var l3: Label = _label_with(mp, Runes.engine_text(String(rr["engine"])).left(40))
				if _shows(l3, String(rr["id"]), "an offer"):
					shown["offer"] += 1
					var pan3: Control = _panel_of(l3)
					bottom = int(pan3.position.y + pan3.size.y)
			fit["offer"].append(["%s %d" % [key, h], bottom])
			_run.party[idx2]["rune_picks_owed"] = 0
			_run.party[idx2]["rune_candidates"] = []
	_close_overlays(mp)
	# THE HERO SHEET.
	for id4 in ids:
		var cls4 := Classes.engine_class(String(Runes.config(String(id4))["engine"]))
		var idx4 := SEATS.find(cls4)
		var r4: Dictionary = Runes.build(String(id4))
		r4["equipped"] = true
		_run.party[idx4]["engines"] = [r4]
		_run.hero_screen_idx = idx4
		change_scene_to_file("res://scenes/party.tscn")
		await Gate.frames(self, 6)
		var l4: Label = _label_with(current_scene, String(r4["name"]) + " — ")
		if _shows(l4, String(id4), "the hero sheet"):
			shown["sheet"] += 1
		_run.party[idx4]["engines"] = []
	for k in shown:
		ok(int(shown[k]) == 24, "§4: %s showed the rule for %d of 24 engine runes" % [k, shown[k]])
	print("    the rule, and no placeholder: the Peddler %d, the pouch %d, an offer %d, the hero sheet %d — of 24 each" % [
		shown["shop"], shown["pouch"], shown["offer"], shown["sheet"]])
	# THE FIT, MEASURED AND PRINTED — the brief asked for the measurement, not a repair.
	var over_shop := 0
	var worst_shop := ["", 0]
	for e in fit["shop"]:
		if int(e[1]) > 130:
			over_shop += 1
		if int(e[1]) > int(worst_shop[1]):
			worst_shop = e
	var over_pouch := 0
	var worst_pouch := ["", 0]
	for e2 in fit["pouch"]:
		if int(e2[1]) > 720:
			over_pouch += 1
		if int(e2[1]) > int(worst_pouch[1]):
			worst_pouch = e2
	var worst_offer := 0
	for e3 in fit["offer"]:
		worst_offer = maxi(worst_offer, int(e3[1]))
	print("    FIT — the Peddler: %d of 24 rune panels outgrow their 130 px row (the tallest %s, %d px, %d over)" % [
		over_shop, worst_shop[0], worst_shop[1], int(worst_shop[1]) - 130])
	print("    FIT — the pouch, one engine held: %d of 24 run past the 720 px screen (the lowest %s, bottom %d, %d over)" % [
		over_pouch, worst_pouch[0], worst_pouch[1], int(worst_pouch[1]) - 720])
	print("    FIT — an offer of three: the lowest panel ends at %d of 720" % worst_offer)
	ok(fit["shop"].size() == 24 and fit["pouch"].size() == 24 and fit["offer"].size() == 8,
		"§4: the fit was measured on %d / %d / %d surfaces" % [fit["shop"].size(), fit["pouch"].size(), fit["offer"].size()])


func _shows(l: Label, id: String, where: String) -> bool:
	if l == null:
		ok(false, "§4: %s draws no line for %s" % [where, id])
		return false
	var pid := String(Runes.config(id)["engine"])
	var rule: String = Runes.engine_text(pid)
	var ph := String(Runes.config(id)["desc"])
	var good := String(l.text).contains(rule) and not String(l.text).contains(ph)
	ok(good, "§4: %s shows %s as `%s`" % [where, id, String(l.text).left(90)])
	return good


func _close_overlays(mp: Node) -> void:
	for c in mp.get_children():
		if c is Control and c.z_index == 60:
			c.queue_free()
	mp._rune_panel_for = -1


# ── §5 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s5_the_players_files() -> void:
	for p in _player:
		var was: Array = _player[p]
		var has := FileAccess.file_exists(p)
		ok(has == bool(was[0]), "§5: %s exists as it did before the gate (%s)" % [p, has])
		ok(not has or FileAccess.get_file_as_bytes(p) == was[1],
			"§5: %s is byte for byte what it was" % p)
