# BATCH EB — THE PROTECTED CORE IS THE BASELINE, AND THE FILLERS' REAL INVARIANT.
#
#   §1  the EB §1 ruling, asserted as a per-pair property with its NAMED
#       crossovers (one at EB, three at GS, one found at GU; none since, and all
#       five asserted gone for their own reasons) — not as the 13-of-17, which
#       is the intended state — over every card a hero of the class can EARN
#   §2  the invariant `test_batch_bp` §7's three hand-written fillers actually
#       rest on, measured through the game's own door
#
# WHY §1 IS NOT A SECOND COPY OF `check_ea` §4. That section asks whether the
# LAYER still leans the way EA measured it — it pins the aggregate DIRECTION so
# a re-priced pool announces the report stale. **This one asks a different
# question of the same table: has any INDIVIDUAL draft card crossed over.**
# EB §1 ruled that a protected core being cheaper and shorter than a comparable
# draft card is the design working; the case that ruling does NOT cover is the
# inversion — a draft card that is cheaper on resource AND shorter on cooldown
# than a comparable core, which is a card paying no pick and giving none back.
# The aggregate can hold while one card crosses, so the aggregate cannot catch
# it. Nothing here re-asserts `check_ea`'s numbers; the ratio is PRINTED as this
# section's own denominator and asserted nowhere.
#
# **AND THE PROPERTY IS THE CONTROLLED ONE, BECAUSE THE UNCONTROLLED ONE IS NOT
# A PROPERTY AT ALL.** Compared without the equal-initiative control, 21 of 96
# same-spec same-role pairs already have a draft card cheaper AND faster —
# Kindled Mind at 15 Mana and initiative 1.5 against Death Ray at 55 and 5.0,
# which is a nuke beside a cantrip and not a mispricing. A gate asserting that
# reads RED on the day it is written and tells the designer nothing. At EQUAL
# initiative "faster" is impossible by construction, so the tempo axis that
# survives the control is COOLDOWN, and that is the axis asserted here.
# **A NAMED POPULATION OF THE UNCONTROLLED FORM IS A RECORD, NOT A PROPERTY**:
# `check_gu` §2 walks it, and holds each card below the baseline as a row with
# its group rather than asserting that there are none.
#
# **BATCH GU — THE POPULATION WAS THE SHELVES, AND IT IS WHAT A HERO CAN EARN
# NOW.** Until GU this section walked each lineage's shelf and paired it with
# that lineage's cores alone: 158 cards. Since GP a hero draws from his whole
# CLASS pool, so the twenty class-wide cards were in no pairing at all and a
# lineage's card never met another lineage's enabler; and a zone-boss pick
# fills a slot under the same cap as a drafted card (EG), and no boss pool was
# read. It walks every card a hero of the class can earn now — the merged draft
# pool and every lineage's boss pool, GT §3's population — against every
# protected card of the class: the kit and every engine's enablers. **THE CLASS
# BASIC IS LEFT OUT, AS IT ALWAYS WAS, AND NOW ON PURPOSE**: it is free by
# construction, so nothing can be cheaper and a pair against it could only
# swell the ratio; before GU it was left out because the pool resolver cannot
# see it. The wider walk found one inversion the old one could not: Sweeping
# Strikes against the Berserker's Bloodlust, from a boss pool.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_eb.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# **THE ONE CROSSOVER THAT EXISTS, NAMED RATHER THAN SUPPRESSED.** Divine Plea
# costs 0 Mana against Renewal's 20 and carries cooldown 2 against its 3, at the
# same initiative 3.0 in the heal role. EA §3 reported it as one of two counter-cases;
# it is the only one that inverts on BOTH axes at once (against Holy's Heal it
# is cheaper and LONGER, which is an ordinary trade). It is listed so a SECOND
# crossover reds this gate instead of hiding inside a count, and so the day this
# one is re-priced the row is what says the ruling has been revisited.
#
# **BATCH GS — THAT ONE DISSOLVED AND THREE ARRIVED, AND NONE OF IT IS RETUNED
# HERE.** Renewal left Holy's opening kit for her shelf, so it is no core and the
# pair above no longer exists — asserted below as GONE, with that reason. The
# three below are GS's RETURNING cards: Fireball, Frostbolt and Aimed Shot were
# opening cards until GS, priced as opening cards (Fireball and Frostbolt were
# a lineage's free basic attack), and are draft cards now, cheaper AND shorter
# than the kit card they sit beside. That is a real design consequence of GS,
# not a gate fault, and the rebalance is the designer's: they are NAMED so a
# FOURTH inversion still reds, and each is owed a ruling.
#
# **BATCH GT §2 — RULED AND RETUNED TO THE BASELINE, SO THE NAMED LIST IS EMPTY
# AND ANY INVERSION REDS.** Each of the three takes the cost and cooldown of the
# kit card it undercut, at the same initiative; the pair is a TIE now, which is
# neither a crossover nor a pair favouring the core. `RETUNED` keeps all three
# asserted gone AND for that reason — a pair that vanished because a card left a
# pool would pass a bare "gone".
#
# **BATCH GU §2 — THE FOURTH, FROM A BOSS POOL, RETUNED THE SAME WAY (ruled: a
# genuine mispricing is retuned).** Sweeping Strikes carried no cooldown beside
# Crushing Blow's 2 at the same cost and initiative, and against Bloodlust it
# was cheaper AND shorter — this section's inversion, in a pool this section did
# not read until GU. It takes Crushing Blow's cooldown, and the rows name a
# CLASS now because the pairing is the class's.
const KNOWN_CROSSOVER := []
const RETUNED := [["mage", "Magic Missiles", "Fireball"],
	["mage", "Magic Missiles", "Frostbolt"],
	["hunter", "Powershot", "Aimed Shot"],
	["warrior", "Crushing Blow", "Sweeping Strikes"]]
# The crossover EB named, kept as a row so its absence stays asserted.
const GONE_CROSSOVER := ["cleric", "Renewal", "Divine Plea"]

# `test_batch_bp` §7 stuffs these three onto a hand-built SWORDMASTER kit AFTER
# `award_draft_pick` has already rolled, so a filler that his draw can reach
# makes `take_draft_ability` refuse with "already known" and reds three checks
# on roughly a one-in-eight draw. DR repaired it by choosing names no draw can
# reach; the comment recording that repair was wrong about WHY until EB §2, and
# the reason it gave — "in no DRAFT pool at all" — is false of one of the three.
# **BATCH GP RE-POINTED TWO OF THE THREE, AND THIS GATE IS WHAT CAUGHT IT.** The
# pool merge made a Swordmaster's draw the whole WARRIOR pool, so Rallying Shout
# (the Warden's shelf) and Gut Rip (the Berserker's) both became reachable by the
# very draw `test_batch_bp` §7 needs them to be unreachable by — DR's one-in-eight
# flake, returning through the merge. **The durable property is "in NO draft pool
# anywhere", not "in another lineage's".** War Stomp and Interpose are `SPEC_POOLS`
# boss-pick cards of the Warden and are in no draft pool at all, as Sweeping
# Strikes and Shatterpoint are.
const BP_FILLERS := ["Sweeping Strikes", "Shatterpoint", "War Stomp", "Interpose"]
const BP_SPEC := "swordmaster"

# §1's table, built inside a `-> void` section on purpose: `check_da` §3b's rule
# is that a function RETURNING a collection built from two or more ability
# sources is a hand-rolled corpus walk. This reads the protected cores, the
# merged class pool and the boss pools, and the class-wide shelf only to prove
# the walk holds it; it never names the lineage-shelf accessor, so the two
# halves of `check_da` §3's older fingerprint are never both in this file. §2
# goes through `draft_pool_left`, the door the offer roller calls.
var _rows: Array = []
# What §1 walked, per class — the population its own check reads back.
var _walked := {}

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH EB — the cores are the baseline, and the fillers' real invariant")
	_s1_no_second_crossover()
	_s2_filler_invariant()
	_g.report(self)


# ── §1 — THE RULING, ASSERTED AS A PER-PAIR PROPERTY ────────────────────────
func _s1_no_second_crossover() -> void:
	print("\n§1 — the protected core is the baseline; the crossover is the case to catch")
	_rows = []
	_walked = {}
	for cls in Classes.SPEC_IDS:
		# The class basic is slot 0 of the class kit; see the header for why it
		# is the one protected card left out.
		var basic := String(Classes.kit(cls)[0].display_name)
		var seen := {}
		for spec in Classes.SPEC_IDS[cls]:
			for nm in Classes.protected_names(spec):
				if seen.has(nm) or String(nm) == basic:
					continue
				seen[nm] = true
				_add_row(cls, "core", nm)
		var earned := {}
		for nm2 in Classes.draft_pool(cls):
			earned[nm2] = true
		for spec2 in Classes.SPEC_IDS[cls]:
			for nm3 in Classes.spec_pool(spec2):
				earned[nm3] = true
		for nm4 in earned:
			_add_row(cls, "earned", nm4)
		_walked[cls] = earned
	var cores: int = _rows.filter(func(r): return r["chan"] == "core").size()
	var cards: int = _rows.filter(func(r): return r["chan"] == "earned").size()
	print("    rows: %d protected cards, %d earnable cards" % [cores, cards])
	# A SWEEP MUST ASSERT ITS OWN POPULATION (EA §1's rule, from a probe that
	# read a Dictionary as an Array and reported zero). A pairing that reaches
	# nothing reports "no crossover" in exactly the same words as a clean tree.
	ok(cores >= 16 and cards >= 190,
		"§1: the walk read %d protected cards and %d earnable cards — the property is being asserted over the wrong population" % [
			cores, cards])
	# AND THE POPULATION IS THE MERGED ONE: every class-wide card and every boss
	# pick is in the walk. A walk that went back to the lineage shelves passes
	# the floor above and fails here, naming what it lost.
	for cls3 in Classes.SPEC_IDS:
		var lost := {}
		for nm5 in Classes.class_draft_pool(cls3):
			if not _walked[cls3].has(nm5):
				lost[nm5] = true
		for spec3 in Classes.SPEC_IDS[cls3]:
			for nm6 in Classes.spec_pool(spec3):
				if not _walked[cls3].has(nm6):
					lost[nm6] = true
		ok(lost.is_empty(),
			"§1: the %s walk does not hold %s — it is not asking about every card a hero can earn" % [
				cls3, ", ".join(PackedStringArray(lost.keys()))])

	var pairs := 0
	var favours_core := 0
	var crossovers: Array = []
	for c in _rows:
		if c["chan"] != "core" or c["capped"]:
			continue
		for d in _rows:
			if d["chan"] != "earned" or d["capped"]:
				continue
			if d["group"] != c["group"] or d["role"] != c["role"]:
				continue
			if absf(float(c["delay"]) - float(d["delay"])) > 0.001:
				continue
			pairs += 1
			var dc: int = int(c["cost"]) - int(d["cost"])
			var dd: int = int(c["cd"]) - int(d["cd"])
			if dc <= 0 and dd <= 0 and (dc < 0 or dd < 0):
				favours_core += 1
			# THE INVERSION: the draft card is cheaper to cast AND comes back
			# sooner, at the same initiative and in the same role.
			if dc > 0 and dd > 0:
				crossovers.append([String(c["group"]), String(c["name"]), String(d["name"])])
				print("    CROSSOVER  %-8s i%.2f %-11s core %s (%d, cd%d)  <  earned %s (%d, cd%d)" % [
					c["group"], float(c["delay"]), c["role"], c["name"], int(c["cost"]),
					int(c["cd"]), d["name"], int(d["cost"]), int(d["cd"])])
	ok(pairs >= 12,
		"§1: only %d comparable pairs — the population has collapsed and the property is vacuous" % pairs)
	# PRINTED, NOT ASSERTED. `check_ea` §4 owns the direction; this is the
	# denominator the line below is a fraction of, and a second assertion on it
	# would be a second copy of one fact in two gates.
	print("    live ratio: %d of %d comparable pairs favour the core (`check_ea` §4 asserts this direction)" % [
		favours_core, pairs])
	print("    crossovers: %d of %d" % [crossovers.size(), pairs])

	# EVERY CROSSOVER MUST BE A NAMED ONE, AND EVERY NAMED ONE MUST STILL BE
	# THERE. Asserted in both directions: an unlisted crossover is the ruling
	# inverting silently, and a listed one that has VANISHED means the pair was
	# re-priced and the ruling has been revisited without this row moving.
	for x in crossovers:
		ok(KNOWN_CROSSOVER.has(x),
			"§1: the %s card %s is now cheaper AND shorter than the core %s — a card that pays no pick and gives none back. EB §1 ruled the OTHER direction intended; this one is not covered" % [
				x[0], x[2], x[1]])
	for k in KNOWN_CROSSOVER:
		ok(crossovers.has(k),
			"§1: %s's known crossover (core %s against draft %s) is gone — the pair was re-priced, so EB §1's ruling and `docs/reports/EB.md` are stale" % [
				k[0], k[1], k[2]])
	# BATCH GS — EB's OWN CROSSOVER IS GONE, AND FOR THE REASON THAT DISSOLVES IT
	# RATHER THAN A RE-PRICE: Renewal is no protected core of any Cleric's any
	# more, it is a card in the class pool (on Holy's shelf). Both halves
	# asserted, so the day Renewal returns to a kit the pair is back under this
	# gate's eye.
	ok(not crossovers.has(GONE_CROSSOVER)
			and not _holds(String(GONE_CROSSOVER[0]), "core", String(GONE_CROSSOVER[1]))
			and Classes.draft_pool(GONE_CROSSOVER[0]).has(GONE_CROSSOVER[1]),
		"§1: the %s crossover (core %s against %s) should be gone because %s left the cores for the pool (GS §1) — the pair or its reason has moved" % [
			GONE_CROSSOVER[0], GONE_CROSSOVER[1], GONE_CROSSOVER[2], GONE_CROSSOVER[1]])
	# BATCH GT §2 AND GU §2 — EACH RETUNED PAIR IS GONE BECAUSE IT WAS PRICED AT
	# THE CORE: the card is still one a hero of the class can earn, the core is
	# still protected, and the card's cost, cooldown and initiative are the core's.
	for g in RETUNED:
		var core: Ability = Classes.pool_ability(String(g[1]))
		var card: Ability = Classes.pool_ability(String(g[2]))
		ok(not crossovers.has(g) and core != null and card != null
				and _holds(String(g[0]), "core", String(g[1]))
				and _holds(String(g[0]), "earned", String(g[2]))
				and card.cost == core.cost and card.cooldown == core.cooldown
				and absf(card.delay - core.delay) < 0.001,
			"§1: the %s card %s was priced at %s's cost and cooldown — the pair is not a tie at the baseline any more" % [
				g[0], g[2], g[1]])
	ok(crossovers.size() == KNOWN_CROSSOVER.size(),
		"§1: %d crossovers against %d named" % [crossovers.size(), KNOWN_CROSSOVER.size()])


# ── §2 — WHAT `test_batch_bp` §7 ACTUALLY RESTS ON ──────────────────────────
# **THE PROSE WAS WRONG AND THE PROPERTY IS RIGHT, WHICH IS WHY THIS IS A GATE
# AND NOT A CORRECTED SENTENCE.** `bp` §7's comment said the three fillers are
# "in no DRAFT pool at all" — Rallying Shout is in the WARDEN's. The invariant
# the repair really rests on is narrower: no draw in a SWORDMASTER flow can
# reach any of the three. That is a live property of the pools and it can break
# without a line of `bp` being touched, which is exactly how the original
# collision arrived — the pools grew under a hand-written kit.
#
# DRIVEN THROUGH `draft_pool_left` RATHER THAN THE TWO POOL ACCESSORS. It
# is the one function the offer roller calls, so this measures the door the game
# uses; and reading `Classes.class_draft_pool` here would put both halves of
# `check_da` §3's fingerprint in a gate that is not a corpus walk.
func _s2_filler_invariant() -> void:
	print("\n§2 — `test_batch_bp` §7's fillers against a live Swordmaster draw")
	# `Run` is an AUTOLOAD and a `--script` gate has no scene tree holding it,
	# so the script is instantiated directly — the same shape `check_ea` §0 uses
	# for `run_state.gd`'s constants. `draft_pool_left` reads only its argument
	# and the pools, so a bare instance answers exactly as the live node does.
	var run: Node = load("res://scripts/run_state.gd").new()
	var member := {"key": "warrior", "spec": BP_SPEC, "bm_abilities": []}
	# BATCH GP — ONE LIST. `draft_pool_left` returned `{"spec": [], "class": []}`
	# until the pool merge and returns the hero's whole class pool now, engine
	# gate applied. Nothing this section asks changes: it asks what a live
	# Swordmaster can DRAW, and the door is still the door.
	var drawable: Array = run.draft_pool_left(member)
	print("    a fresh %s can draw %d cards" % [BP_SPEC, drawable.size()])
	# THE POPULATION AGAIN: an empty pool makes every "is not reachable" below
	# true for the wrong reason.
	ok(drawable.size() >= 12,
		"§2: the %s's live draw reads %d cards — a pool that small makes the checks below vacuous" % [
			BP_SPEC, drawable.size()])
	for nm in BP_FILLERS:
		ok(not drawable.has(nm),
			"§2: `test_batch_bp` §7's filler %s is reachable by a %s draw — §7's three checks will red on a draw that lands on it (DR's flake, returning)" % [
				nm, BP_SPEC])
	# AND THE FILLERS MUST STILL BE REAL CARDS. A filler that stopped resolving
	# would pass every line above by not existing.
	for nm2 in BP_FILLERS:
		ok(Classes.pool_ability(nm2) != null,
			"§2: `test_batch_bp` §7's filler %s does not resolve to an ability at all" % nm2)
	run.free()


# A card resolves through the game's one resolver, the one GT §3's census asks.
func _add_row(group: String, chan: String, nm: String) -> void:
	var a: Ability = Classes.pool_ability(nm)
	if a == null:
		return
	_rows.append({"group": group, "chan": chan, "name": nm, "delay": a.delay,
		"cost": a.cost, "cd": a.cooldown, "role": _role_of(a),
		"capped": Ability.takes_delay_cap(a.special)})


func _holds(group: String, chan: String, nm: String) -> bool:
	for r in _rows:
		if r["group"] == group and r["chan"] == chan and r["name"] == nm:
			return true
	return false


# THE ROLE, DERIVED FROM THE ABILITY'S OWN FIELDS AND ORDERED SO THE STRONGEST
# SIGNAL WINS — `check_ea` §4's derivation, unchanged, because two pairings that
# disagree would make the two sections' numbers incomparable. **STATIC SINCE GU,
# SO `check_gu` ASKS THIS ONE** rather than carrying a third copy: a helper in
# three gates is the tell of a copied helper (DA §3).
static func _role_of(a: Ability) -> String:
	if a.heal > 0 or Ability.HEAL_SPECIALS.has(a.special):
		return "heal"
	if Ability.SHIELD_SPECIALS.has(a.special):
		return "shield"
	if a.damage > 0 or Ability.DAMAGE_SPECIALS.has(a.special):
		return "aoe-damage" if (a.aoe or a.random_hits > 0) else "damage"
	if not a.applies_status.is_empty():
		return "debuff" if a.target == Ability.Target.ENEMY else "buff"
	return "buff"
