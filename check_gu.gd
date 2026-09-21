# BATCH GU — THE LAST THREE CARDS UNDER THE BASELINE, AND THE SWEEP FOR THE SHAPE.
#
#   §0  THE PLAYER'S FILES, AS FOUND — and this process writes the harness save
#   §1  THE THREE THE BRIEF NAMED, and none of them moved. Arcane Explosion and
#       Shadowrend are former basic attacks: each at the price of the class basic
#       it replaced in slot 0, with no card of its role in its class kit, and a
#       nearest card of its role in the class pool whose price it would take.
#       Guard Change is not a former basic: it opened the Swordmaster's kit until
#       GS, it is under two kit strikes on all three axes, and under the kit card
#       nearest its price — Mocking Blow — on its initiative alone
#   §2  THE SWEEP — every card a hero can earn, against his class kit, in the
#       same role, with EB's initiative control dropped: every card below the
#       baseline is a named row with its group, every named row still is one,
#       each group's ground is asked of the game, and the one genuine mispricing
#       is below nothing now
#   §3  THE RETUNE — Sweeping Strikes at Crushing Blow's cost, cooldown and
#       initiative, and nothing else of it moved
#   §4  THE CAST — every card priced at a kit card (GT's three and GU's one), cast
#       in a real fight on the same hero as that kit card: the same price paid at
#       the line every cast pays at, the same cooldown started, the same turn
#       scheduled, and the door refusing both while they cool and opening both
#       after — a price that moved in the data and not at the cast would pass
#       every section above
#   §5  THE PLAYER'S FILES, AS THEY WERE
#
# ── EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM ───────────────────────────────
# A card named below the baseline, beside every such card derived; a group's
# ground refused (Guard Change is no former basic), beside the four former
# basics derived; a card unmoved, beside the one that moved; the door refusing
# a card while it cools, beside the same door opening it before the cast and
# after the cooldown; the retuned card's cast, beside the kit card's.
#
# ── WHY THE ROLE IS `check_eb`'s ────────────────────────────────────────────
# The role is `check_ea` §4's derivation and `check_eb` §1 carries it so the two
# pairings agree. This gate asks `check_eb`'s rather than carrying a third copy:
# a helper in three gates is the tell of a copied one (DA §3).
#
# ── WHY THE TABLE IS HELD HERE ─────────────────────────────────────────────
# **WHICH CARDS SIT BELOW THE BASELINE, AND WHY, IS A POPULATION THE DESIGNER
# READS.** A new card that lands below a kit card reds §2 in the batch that adds
# it, and that batch sorts it: a former basic, a card whose advantage is what
# it is for, a card that only the field role pairs with a kit card — or a
# genuine mispricing, which is retuned to the kit card's price (GT's method) and
# joins `RETUNED`. Only the last moves a price; the others are reported and
# ruled on by nobody but the designer.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_gu.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")
const EB = preload("res://check_eb.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const NO_LINEAGE := ["", "", "", ""]

# §1 — each former basic, and the class whose basic it replaced in slot 0.
const FORMER_BASIC := {"Arcane Explosion": "mage", "Shadowrend": "cleric"}
# The nearest card of its role in its class pool — the price it would take.
# Arcane Barrage is the Arcanist's own random-hit area card; Chastise deals the
# same 25% at the same initiative. Printed, and their role asserted.
const NEAREST := {"Arcane Explosion": "Arcane Barrage", "Shadowrend": "Chastise"}
# GS's numbers for the three, unmoved: none of them is a genuine mispricing.
const UNMOVED_THREE := {
	"Arcane Explosion": {"cost": 0, "cooldown": 0, "delay": 2.0, "damage": 10,
		"pressure": 10, "random_hits": 2, "resource_gain": 0},
	"Shadowrend": {"cost": 0, "cooldown": 0, "delay": 2.0, "damage": 25,
		"pressure": 16, "random_hits": 0, "resource_gain": 0},
	"Guard Change": {"cost": 0, "cooldown": 1, "delay": 1.5, "damage": 0,
		"pressure": 0, "random_hits": 0, "resource_gain": 15},
}

# §2 — EVERY CARD BELOW THE BASELINE, WITH THE KIT CARDS IT IS BELOW AND ITS
# GROUP. The kit lists are compared with the ones the sweep derives, so a row
# whose pairing moves reds.
#   basic — a former basic attack: free by construction in slot 0 until GS §1
#   point — its advantage is what the card is for
#   role  — the field role pairs it with a kit card only through its catch-all
#           bucket; by what the two are for (the primary tag) they are not one job
const BELOW := {
	"Fireball": {"kit": ["Magic Burst"], "group": "basic",
		"why": "the Pyromancer's basic until GS; priced at Magic Missiles since GT"},
	"Frostbolt": {"kit": ["Magic Burst"], "group": "basic",
		"why": "the Cryomancer's basic until GS; priced at Magic Missiles since GT"},
	"Guard Change": {"kit": ["Crushing Blow", "Pommel Strike", "Mocking Blow"], "group": "point",
		"why": "the stance swap, priced a bargain on purpose at AK — a quick pivot, a refuel, a cooldown that stops spam; its fields call it a strike only for its 15 Break damage"},
	"Charge": {"kit": ["Pommel Strike"], "group": "point",
		"why": "its speed is the card: nothing else a Warrior holds arrives as fast, and its numbers were the designer's call"},
	"Kindled Mind": {"kit": ["Magic Burst", "Magic Missiles"], "group": "point",
		"why": "a cantrip: under half the damage of either kit card, bought for tempo"},
	"Primal Surge": {"kit": ["Powershot"], "group": "point",
		"why": "paid in Loyalty, all of it, and it sits out without Pack Bond"},
	# BATCH HB — SUMMON COMPANION JOINED THE HUNTER KIT (in Tripwire's slot) AND
	# THESE FOUR SIT BELOW IT TOO, SORTED HERE IN THE BATCH THAT MOVED THE KIT:
	# every one of them only through the field role's catch-all bucket, where a
	# card with no damage, no heal and no status lands — the summon is 20 Mana,
	# a 3-turn cooldown and 3.0 initiative, and none of the four is a summon.
	# Nothing is retuned; Bola keeps its point against Snare Trap.
	"Bola": {"kit": ["Snare Trap", "Summon Companion"], "group": "point",
		"why": "a class-wide card authored as the lesser applier: two afflictions, no damage and no Break (below Summon Companion only through the catch-all: an applier, not a summon)"},
	"Quarry's Mark": {"kit": ["Snare Trap", "Summon Companion"], "group": "role",
		"why": "a mark that pays Focus, not a trap and not a summon"},
	"Hold Breath": {"kit": ["Snare Trap", "Summon Companion"], "group": "role",
		"why": "the Sharpshooter's own Focus and crit, not a trap and not a summon"},
	"Mark of the Hunt": {"kit": ["Snare Trap", "Summon Companion"], "group": "role",
		"why": "a mark for the Beastmaster and his companion, not a trap and not a summon"},
}
# A GENUINE MISPRICING, RETUNED — and the kit card it ties now.
const RETUNED := {"Sweeping Strikes": "Crushing Blow"}
# The four cards `basic_override_ability` defines; the sweep derives the set.
const FORMER_BASICS := ["Arcane Explosion", "Fireball", "Frostbolt", "Shadowrend"]

# §3 — what GU moved of Sweeping Strikes (its cooldown) and what it did not.
const SS_UNMOVED := {"cost": 20, "delay": 3.0, "damage": 15, "pressure": 12,
	"multi_hits": 2, "resource_gain": 10, "status": "dazed", "status_turns": 3,
	"dmg_type": "physical", "perfect_text": "+25% crit chance on the second swing"}

# §4 — every card priced at a kit card, the class that holds it, and the kit card.
const PRICED_AT := {"Fireball": ["mage", "Magic Missiles"],
	"Frostbolt": ["mage", "Magic Missiles"],
	"Aimed Shot": ["hunter", "Powershot"],
	"Sweeping Strikes": ["warrior", "Crushing Blow"]}
# What a hero holds when a cast is read — enough for any of the eight, and
# room under the bar's ceiling for a card that refunds.
const PURSE := 50

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH GU — THE LAST THREE CARDS UNDER THE BASELINE, AND THE SWEEP FOR THE SHAPE")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a fight is drawn")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_s1_the_three()
	_s2_the_sweep()
	_s3_the_retune()
	await _s4_the_cast()
	_s5_the_players_files()
	Engine.time_scale = 1.0
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

# A card's price and shape, off the one resolver every screen and the spawn read.
func _ab(nm: String) -> Ability:
	return Classes.pool_ability(nm)


# Under on at least one of the three axes and dearer on none: the shape. The
# three are Mana or Rage, cooldown and initiative, and a card whose initiative is
# clamped to the buff cap is left out on both sides — EB's rule: a clamped
# initiative is not a price anyone chose.
func _below(card: Ability, kit: Ability) -> bool:
	var d := [kit.cost - card.cost, kit.cooldown - card.cooldown, kit.delay - card.delay]
	var under := false
	for x in d:
		if float(x) < -0.001:
			return false
		if float(x) > 0.001:
			under = true
	return under


func _primary(nm: String) -> String:
	var t: Array = Classes.card_tags(nm)
	return String(t[0]) if not t.is_empty() else ""


# Damage a cast deals across its hits, as a percentage of Attack.
func _per_cast(a: Ability) -> int:
	return a.damage * maxi(1, maxi(a.multi_hits, a.random_hits))


func _hero(s: Node, key: String) -> BattleUnit:
	for h in s.get("heroes"):
		if not h.is_companion and h.hero_key == key:
			return h
	return null


func _on_bar(u: BattleUnit, nm: String) -> Ability:
	for a in u.abilities:
		if a != null and a.display_name == nm:
			return a
	return null


func _clear(s: Node) -> void:
	s.queue_free()
	for _i in 4:
		await process_frame


# ── §1 — THE THREE ──────────────────────────────────────────────────────────

func _s1_the_three() -> void:
	print("\n§1 — Arcane Explosion, Shadowrend and Guard Change, and what each is priced against")
	for nm in UNMOVED_THREE:
		var a := _ab(String(nm))
		ok(a != null, "§1: %s does not resolve" % nm)
		if a == null:
			continue
		var u: Dictionary = UNMOVED_THREE[nm]
		ok(a.cost == int(u["cost"]) and a.cooldown == int(u["cooldown"])
				and absf(a.delay - float(u["delay"])) < 0.001 and a.damage == int(u["damage"])
				and a.pressure == int(u["pressure"]) and a.random_hits == int(u["random_hits"])
				and a.resource_gain == int(u["resource_gain"]),
			"§1: %s is no longer GS's %d, cooldown %d, initiative %.1f — none of the three was ruled a mispricing" % [
				nm, int(u["cost"]), int(u["cooldown"]), float(u["delay"])])
	# THE TWO FORMER BASICS: priced as the basic they replaced, and the kit holds
	# no card of their role.
	for nm2 in FORMER_BASIC:
		var key := String(FORMER_BASIC[nm2])
		var a2 := _ab(String(nm2))
		var basic: Ability = Classes.kit(key)[0]
		ok(Classes.basic_override_ability(String(nm2)) != null,
			"§1: %s is not one of the four cards that were a lineage's basic attack" % nm2)
		ok(a2 != null and a2.cost == basic.cost and a2.cooldown == basic.cooldown
				and absf(a2.delay - basic.delay) < 0.001,
			"§1: %s is not at the price of %s, the %s basic it replaced in slot 0" % [nm2, basic.display_name, key])
		ok(Classes.draft_pool(key).has(nm2), "§1: %s is not in the %s pool" % [nm2, key])
		var role := EB._role_of(a2)
		var kit_roles: Array = []
		for kn in Classes.class_kit_names(key):
			kit_roles.append(EB._role_of(_ab(String(kn))))
		ok(not kit_roles.has(role),
			"§1: the %s kit holds a card of %s's role (%s) — it has a comparator of its own now" % [key, nm2, role])
		var near := _ab(String(NEAREST[nm2]))
		ok(near != null and Classes.draft_pool(key).has(NEAREST[nm2]) and EB._role_of(near) == role,
			"§1: %s, the nearest card of %s's role in the %s pool, is not of that role or not in the pool" % [
				NEAREST[nm2], nm2, key])
		if near != null:
			print("    %s — a former basic, at %s's price (%d, cooldown %d, %.1f); no %s card in the %s kit; nearest in the pool: %s at %d, cooldown %d, %.1f" % [
				nm2, basic.display_name, a2.cost, a2.cooldown, a2.delay, role, key, near.display_name,
				near.cost, near.cooldown, near.delay])
	ok(_ab("Arcane Barrage") != null and _ab("Arcane Barrage").random_hits > 0
			and _ab("Chastise") != null and _ab("Chastise").damage == _ab("Shadowrend").damage
			and absf(_ab("Chastise").delay - _ab("Shadowrend").delay) < 0.001,
		"§1: the nearest matches are not what the report names them for — a random-hit area card, and a strike of Shadowrend's damage at its initiative")
	# GUARD CHANGE: NOT A FORMER BASIC — a card the Swordmaster opened with until
	# GS, now on his shelf of the Warrior pool.
	var gc := _ab("Guard Change")
	ok(Classes.basic_override_ability("Guard Change") == null,
		"§1: Guard Change is defined as a former basic attack")
	var opened := false
	for sa in Classes.spec_abilities("swordmaster"):
		if sa != null and sa.display_name == "Guard Change":
			opened = true
	ok(opened and not Classes.core_enablers("swordmaster").has("Guard Change")
			and not Classes.class_kit_names("warrior").has("Guard Change")
			and Classes.draft_pool("warrior").has("Guard Change"),
		"§1: Guard Change is not the Swordmaster's former opening card, drafted from the Warrior pool")
	# ITS THREE AXES, AGAINST EACH KIT CARD.
	var three_under: Array = []
	for kn2 in ["Crushing Blow", "Pommel Strike"]:
		var k := _ab(kn2)
		if gc.cost < k.cost and gc.cooldown < k.cooldown and gc.delay < k.delay - 0.001:
			three_under.append(kn2)
	ok(three_under.size() == 2,
		"§1: Guard Change is not under Crushing Blow and Pommel Strike on cost, cooldown and initiative (under all three against: %s)" % str(three_under))
	var mb := _ab("Mocking Blow")
	ok(gc.cost == mb.cost and gc.cooldown == mb.cooldown and gc.delay < mb.delay - 0.001,
		"§1: against Mocking Blow, the kit card nearest its price, Guard Change is not under on initiative alone")
	# AND BY WHAT THE CARDS ARE FOR, IT IS NOT A STRIKE.
	for kn3 in Classes.class_kit_names("warrior"):
		ok(_primary("Guard Change") != _primary(String(kn3)),
			"§1: Guard Change's primary tag is %s's — the swap and the kit's strikes share a job" % kn3)
	print("    Guard Change — %d Rage, cooldown %d, %.1f: under Crushing Blow and Pommel Strike on all three; under Mocking Blow (%d, cooldown %d, %.1f) on initiative alone" % [
		gc.cost, gc.cooldown, gc.delay, mb.cost, mb.cooldown, mb.delay])


# ── §2 — THE SWEEP ──────────────────────────────────────────────────────────

func _s2_the_sweep() -> void:
	print("\n§2 — every card a hero can earn, against his class kit, with the initiative control dropped")
	# Built inside this `-> void` section and returned from nowhere: `check_da`
	# §3b's rule is that a function RETURNING a walk of two sources is a corpus.
	var asked := 0
	var derived := {}
	var trades := 0
	var capped_skipped := 0
	var basics_found: Array = []
	var retuned_seen := {}
	for key in SEATS:
		var pop := {}
		for n in Classes.draft_pool(key):
			pop[String(n)] = true
		for sp in Classes.SPEC_IDS[key]:
			for n2 in Classes.spec_pool(String(sp)):
				pop[String(n2)] = true
		var kit: Array = []
		for kn in Classes.class_kit_names(key):
			var ka := _ab(String(kn))
			ok(ka != null, "§2: the %s kit card %s does not resolve" % [key, kn])
			if ka != null:
				kit.append(ka)
		for nm in pop:
			var a := _ab(String(nm))
			ok(a != null, "§2: the %s card %s does not resolve" % [key, nm])
			if a == null:
				continue
			asked += 1
			if Classes.basic_override_ability(String(nm)) != null:
				basics_found.append(String(nm))
			if RETUNED.has(nm):
				retuned_seen[nm] = key
			for k in kit:
				if EB._role_of(k) != EB._role_of(a):
					continue
				if Ability.takes_delay_cap(k.special) or Ability.takes_delay_cap(a.special):
					if a.cost < k.cost or a.cooldown < k.cooldown:
						capped_skipped += 1
					continue
				if _below(a, k):
					if not derived.has(nm):
						derived[nm] = []
					derived[nm].append(k.display_name)
				elif a.cost < k.cost or a.cooldown < k.cooldown or a.delay < k.delay - 0.001:
					trades += 1
	# THE POPULATION ASSERTS ITSELF (EA §5): a sweep that asked nothing reads clean.
	ok(asked >= 190, "§2: the sweep asked %d earnable cards — it is not asking about every card a hero can earn" % asked)
	# EVERY CARD BELOW THE BASELINE IS NAMED, AND EVERY NAMED ONE STILL IS — and
	# against the same kit cards.
	for nm3 in derived:
		ok(BELOW.has(nm3),
			"§2: %s is below the kit card %s on price in the same role, and no row names it — sort it: a former basic, its point, the field role's catch-all, or a mispricing to retune" % [
				nm3, ", ".join(PackedStringArray(derived[nm3]))])
	for nm4 in BELOW:
		var want: Array = BELOW[nm4]["kit"].duplicate()
		want.sort()
		var got: Array = derived.get(nm4, []).duplicate()
		got.sort()
		ok(got == want, "§2: %s sits below %s, where its row says %s" % [
			nm4, str(got), str(want)])
		ok(String(BELOW[nm4]["why"]) != "", "§2: %s's row carries no why" % nm4)
		_ground(String(nm4), String(BELOW[nm4]["group"]), BELOW[nm4]["kit"])
	# THE FORMER BASICS ARE A DERIVED POPULATION, AND GUARD CHANGE IS NOT IN IT.
	basics_found.sort()
	ok(basics_found == FORMER_BASICS,
		"§2: the former basic attacks are %s, not the four `basic_override_ability` defines" % str(basics_found))
	# THE GENUINE MISPRICING IS BELOW NOTHING NOW — it ties the kit card instead.
	for r in RETUNED:
		ok(retuned_seen.has(r) and not derived.has(r),
			"§2: %s is still below a kit card, or is no card a hero can earn" % r)
	var groups := {}
	for nm5 in BELOW:
		groups[BELOW[nm5]["group"]] = int(groups.get(BELOW[nm5]["group"], 0)) + 1
	print("    %d earnable cards asked; %d below a kit card — %d former basic, %d its point, %d the field role's catch-all; %d retuned (%s)" % [
		asked, derived.size(), int(groups.get("basic", 0)), int(groups.get("point", 0)),
		int(groups.get("role", 0)), RETUNED.size(), ", ".join(PackedStringArray(RETUNED.keys()))])
	print("    printed, not asserted: %d same-role pairs trade — under on one axis, dearer on another, which EB's ruling allows; %d pairs under on cost or cooldown were set aside because one side's initiative is the buff cap" % [
		trades, capped_skipped])


# Each group's ground, asked of the game rather than taken from the row.
func _ground(nm: String, group: String, kits: Array) -> void:
	var a := _ab(nm)
	match group:
		"basic":
			ok(Classes.basic_override_ability(nm) != null,
				"§2: %s is grouped a former basic attack and is not one" % nm)
		"role":
			for kn in kits:
				ok(_primary(nm) != _primary(String(kn)),
					"§2: %s is grouped the field role's catch-all, and its primary tag is %s's (%s)" % [
						nm, kn, _primary(nm)])
		"point":
			match nm:
				"Guard Change":
					ok(a.special == "guard_change", "§2: Guard Change is not the stance swap")
				"Charge":
					# Every card a Warrior can hold: his kit, his pool and every boss pick.
					var held: Array = Classes.draft_pool("warrior") + Classes.class_kit_names("warrior")
					for sp in Classes.SPEC_IDS["warrior"]:
						held.append_array(Classes.spec_pool(String(sp)))
					var quickest := true
					for n2 in held:
						var b := _ab(String(n2))
						if b == null or String(n2) == nm or Ability.takes_delay_cap(b.special):
							continue
						if b.delay <= a.delay + 0.001:
							quickest = false
					ok(quickest, "§2: Charge is not the quickest card a Warrior holds — its speed is no longer what it is for")
				"Kindled Mind":
					for kn2 in kits:
						ok(_per_cast(a) * 2 < _per_cast(_ab(String(kn2))),
							"§2: Kindled Mind deals %d%% a cast against %s's %d%% — not the cantrip its row says" % [
								_per_cast(a), kn2, _per_cast(_ab(String(kn2)))])
				"Primal Surge":
					ok(Classes.sits_out_engine(nm) == "pack",
						"§2: Primal Surge no longer sits out without Pack Bond — its price is not paid in Loyalty alone")
				"Bola":
					ok(Classes.class_draft_pool("hunter").has(nm) and a.damage == 0 and a.pressure == 0,
						"§2: Bola is no longer the class-wide applier with no damage and no Break")
				_:
					ok(false, "§2: %s is grouped its point with no ground asked of the game" % nm)
		_:
			ok(false, "§2: %s names no group this gate knows (%s)" % [nm, group])


# ── §3 — THE RETUNE ─────────────────────────────────────────────────────────

func _s3_the_retune() -> void:
	print("\n§3 — Sweeping Strikes at Crushing Blow's price, and nothing else moved")
	for card in RETUNED:
		var a := _ab(String(card))
		var k := _ab(String(RETUNED[card]))
		ok(a != null and k != null, "§3: %s or %s does not resolve" % [card, RETUNED[card]])
		if a == null or k == null:
			continue
		ok(a.cost == k.cost and a.cooldown == k.cooldown and absf(a.delay - k.delay) < 0.001,
			"§3: %s costs %d, cooldown %d, initiative %.1f — the baseline is %s's %d, %d, %.1f" % [
				card, a.cost, a.cooldown, a.delay, RETUNED[card], k.cost, k.cooldown, k.delay])
		print("    %s: %d Rage, cooldown %d, initiative %.1f — %s's" % [card, a.cost, a.cooldown, a.delay, RETUNED[card]])
	var ss := _ab("Sweeping Strikes")
	var st := String(ss.applies_status.get("id", "")) if not ss.applies_status.is_empty() else ""
	var stt := int(ss.applies_status.get("turns", 0)) if not ss.applies_status.is_empty() else 0
	ok(ss.cost == int(SS_UNMOVED["cost"]) and absf(ss.delay - float(SS_UNMOVED["delay"])) < 0.001
			and ss.damage == int(SS_UNMOVED["damage"]) and ss.pressure == int(SS_UNMOVED["pressure"])
			and ss.multi_hits == int(SS_UNMOVED["multi_hits"])
			and ss.resource_gain == int(SS_UNMOVED["resource_gain"])
			and st == String(SS_UNMOVED["status"]) and stt == int(SS_UNMOVED["status_turns"])
			and String(ss.dmg_type) == String(SS_UNMOVED["dmg_type"])
			and String(ss.perfect_text) == String(SS_UNMOVED["perfect_text"]),
		"§3: something of Sweeping Strikes besides its cooldown moved")
	ok(ss.cooldown == 2, "§3: Sweeping Strikes' cooldown is %d — GU priced it at 2" % ss.cooldown)
	var in_boss := false
	for sp in Classes.SPEC_IDS["warrior"]:
		if Classes.spec_pool(String(sp)).has("Sweeping Strikes"):
			in_boss = true
	ok(in_boss, "§3: Sweeping Strikes is in no Warrior boss pool")


# ── §4 — THE CAST ───────────────────────────────────────────────────────────

func _s4_the_cast() -> void:
	print("\n§4 — each card priced at a kit card, cast in a real fight beside that kit card")
	Engine.max_fps = 0
	var over := {}
	for seat in 4:
		over[seat] = {"engines": []}
	var seat_cards := {}
	for card in PRICED_AT:
		var seat := SEATS.find(String(PRICED_AT[card][0]))
		if not seat_cards.has(seat):
			seat_cards[seat] = []
		seat_cards[seat].append(String(card))
	for seat2 in seat_cards:
		over[seat2]["bm_abilities"] = seat_cards[seat2].duplicate()
		over[seat2]["bm_equipped"] = seat_cards[seat2].duplicate()
	var s: Node = await Gate.spawn(self, NO_LINEAGE, {"deterministic": true, "party": over})
	Engine.time_scale = 20.0
	var foe: BattleUnit = null
	for e in s.get("enemies"):
		if not e.dead:
			foe = e
			break
	ok(foe != null, "§4: the fight has no enemy to cast at")
	if foe == null:
		await _clear(s)
		return
	for card2 in PRICED_AT:
		var key := String(PRICED_AT[card2][0])
		var kit_name := String(PRICED_AT[card2][1])
		var u := _hero(s, key)
		var ab := _on_bar(u, String(card2)) if u != null else null
		var kab := _on_bar(u, kit_name) if u != null else null
		ok(ab != null and kab != null,
			"§4: the fight did not seat %s and %s on the %s's bar" % [card2, kit_name, key])
		if ab == null or kab == null:
			continue
		var r: Dictionary = await _cast(s, u, ab, foe)
		var rk: Dictionary = await _cast(s, u, kab, foe)
		var kd := _ab(kit_name)
		ok(int(r["paid"]) == kd.cost and int(rk["paid"]) == kd.cost,
			"§4: the cast line took %d for %s and %d for %s — the baseline is %d" % [
				int(r["paid"]), card2, int(rk["paid"]), kit_name, kd.cost])
		ok(int(r["cd"]) == kd.cooldown + 1 and int(rk["cd"]) == kd.cooldown + 1,
			"§4: %s started a cooldown of %d and %s one of %d — %s's %d is a %d on the clock" % [
				card2, int(r["cd"]), kit_name, int(rk["cd"]), kit_name, kd.cooldown, kd.cooldown + 1])
		ok(absf(float(r["dt"]) - float(rk["dt"])) < 0.001 and float(r["dt"]) > 0.0,
			"§4: %s put %.2f on the hero's clock and %s %.2f — the same initiative is the same turn" % [
				card2, float(r["dt"]), kit_name, float(rk["dt"])])
		# THE DOOR: open before the cast, shut while it cools for exactly the
		# kit card's cooldown in the hero's own turns, open again after.
		var want: Array = [true, false]
		for _t in kd.cooldown:
			want.append(false)
		want.append(true)
		ok(r["door"] == want and rk["door"] == want,
			"§4: the door read %s for %s and %s for %s — a cooldown of %d reads %s" % [
				str(r["door"]), card2, str(rk["door"]), kit_name, kd.cooldown, str(want)])
		print("    %-16s beside %-14s — paid %d and %d, cooldown clock %d and %d, turn +%.2f and +%.2f, door %s" % [
			card2, kit_name, int(r["paid"]), int(rk["paid"]), int(r["cd"]), int(rk["cd"]),
			float(r["dt"]), float(rk["dt"]), str(r["door"])])
	Engine.time_scale = 1.0
	await _clear(s)


# One cast through `_resolve`, the line every cast pays at: what left the bar
# (the refund the card itself carries added back), the cooldown it started, the
# turn it scheduled, and the door before the cast, after it and at each of the
# hero's turn starts until the cooldown is spent.
func _cast(s: Node, u: BattleUnit, ab: Ability, foe: BattleUnit) -> Dictionary:
	foe.max_hp = 100000
	foe.hp = 50000
	foe.pressure = 0
	u.cooldowns.clear()
	u.resource = PURSE
	var door: Array = [bool(s._ability_usable(u, ab))]
	var t0: float = u.next_time
	await s._resolve(u, ab, foe, "good")
	var paid: int = PURSE - int(u.resource) + ab.resource_gain
	var cd: int = u.cooldown_left(ab)
	var dt: float = u.next_time - t0
	u.resource = PURSE
	door.append(bool(s._ability_usable(u, ab)))
	for _t in ab.cooldown + 1:
		u.tick_cooldowns()
		door.append(bool(s._ability_usable(u, ab)))
	return {"paid": paid, "cd": cd, "dt": dt, "door": door}


# ── §5 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s5_the_players_files() -> void:
	for p in _player:
		var was: Array = _player[p]
		var has := FileAccess.file_exists(p)
		ok(has == bool(was[0]), "§5: %s exists as it did before the gate (%s)" % [p, has])
		ok(not has or FileAccess.get_file_as_bytes(p) == was[1],
			"§5: %s is byte for byte what it was" % p)
