# BATCH EB — THE PROTECTED CORE IS THE BASELINE, AND THE FILLERS' REAL INVARIANT.
#
#   §1  the EB §1 ruling, asserted as a per-pair property with ONE named
#       crossover — not as the 13-of-17, which is the intended state
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
const KNOWN_CROSSOVER := [["holy", "Renewal", "Divine Plea"]]

# `test_batch_bp` §7 stuffs these three onto a hand-built SWORDMASTER kit AFTER
# `award_draft_pick` has already rolled, so a filler that his draw can reach
# makes `take_draft_ability` refuse with "already known" and reds three checks
# on roughly a one-in-eight draw. DR repaired it by choosing names no draw can
# reach; the comment recording that repair was wrong about WHY until EB §2, and
# the reason it gave — "in no DRAFT pool at all" — is false of one of the three.
const BP_FILLERS := ["Sweeping Strikes", "Shatterpoint", "Rallying Shout"]
const BP_SPEC := "swordmaster"

# §1's table, built inside a `-> void` section on purpose: `check_da` §3b's rule
# is that a function RETURNING a collection built from two or more ability
# sources is a hand-rolled corpus walk. This reads the protected cores and the
# SPEC draft pools, and names neither class accessor — §2 goes through
# `draft_pool_left` rather than reading the class pool itself.
var _rows: Array = []

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
	for cls in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[cls]:
			var seen := {}
			for nm in Classes.protected_names(spec):
				if seen.has(nm):
					continue
				seen[nm] = true
				_add_row(spec, "core", nm)
			for nm2 in Classes.spec_draft_pool(spec):
				_add_row(spec, "draft", nm2)
	var cores: int = _rows.filter(func(r): return r["chan"] == "core").size()
	var drafts: int = _rows.filter(func(r): return r["chan"] == "draft").size()
	print("    rows: %d protected cores, %d draft cards" % [cores, drafts])
	# A SWEEP MUST ASSERT ITS OWN POPULATION (EA §1's rule, from a probe that
	# read a Dictionary as an Array and reported zero). A pairing that reaches
	# nothing reports "no crossover" in exactly the same words as a clean tree.
	ok(cores > 30 and drafts > 100,
		"§1: the walk read %d cores and %d draft cards — the property is being asserted over the wrong population" % [
			cores, drafts])

	var pairs := 0
	var favours_core := 0
	var crossovers: Array = []
	for c in _rows:
		if c["chan"] != "core" or c["capped"]:
			continue
		for d in _rows:
			if d["chan"] != "draft" or d["capped"]:
				continue
			if d["spec"] != c["spec"] or d["role"] != c["role"]:
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
				crossovers.append([String(c["spec"]), String(c["name"]), String(d["name"])])
				print("    CROSSOVER  %-13s i%.2f %-11s core %s (%d, cd%d)  <  draft %s (%d, cd%d)" % [
					c["spec"], float(c["delay"]), c["role"], c["name"], int(c["cost"]),
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
			"§1: %s's draft card %s is now cheaper AND shorter than the core %s — a draft card that pays no pick and gives none back. EB §1 ruled the OTHER direction intended; this one is not covered" % [
				x[0], x[2], x[1]])
	for k in KNOWN_CROSSOVER:
		ok(crossovers.has(k),
			"§1: %s's known crossover (core %s against draft %s) is gone — the pair was re-priced, so EB §1's ruling and `docs/reports/EB.md` are stale" % [
				k[0], k[1], k[2]])
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
	var pools: Dictionary = run.draft_pool_left(member)
	var spec_left: Array = pools["spec"]
	var class_left: Array = pools["class"]
	print("    a fresh %s can draw %d spec cards and %d class cards" % [
		BP_SPEC, spec_left.size(), class_left.size()])
	# THE POPULATION AGAIN: an empty pool makes every "is not reachable" below
	# true for the wrong reason.
	ok(spec_left.size() >= 8 and class_left.size() >= 4,
		"§2: the %s's live draw reads %d spec / %d class — a pool that small makes the checks below vacuous" % [
			BP_SPEC, spec_left.size(), class_left.size()])
	for nm in BP_FILLERS:
		ok(not spec_left.has(nm) and not class_left.has(nm),
			"§2: `test_batch_bp` §7's filler %s is reachable by a %s draw — §7's three checks will red on a draw that lands on it (DR's flake, returning)" % [
				nm, BP_SPEC])
	# AND THE FILLERS MUST STILL BE REAL CARDS. A filler that stopped resolving
	# would pass every line above by not existing.
	for nm2 in BP_FILLERS:
		ok(Classes.pool_ability(nm2) != null,
			"§2: `test_batch_bp` §7's filler %s does not resolve to an ability at all" % nm2)
	run.free()


func _add_row(spec: String, chan: String, nm: String) -> void:
	var a: Ability = Classes.spec_pool_ability(spec, nm)
	if a == null:
		a = Classes.pool_ability(nm)
	if a == null:
		return
	_rows.append({"spec": spec, "chan": chan, "name": nm, "delay": a.delay,
		"cost": a.cost, "cd": a.cooldown, "role": _role_of(a),
		"capped": Ability.takes_delay_cap(a.special)})


# THE ROLE, DERIVED FROM THE ABILITY'S OWN FIELDS AND ORDERED SO THE STRONGEST
# SIGNAL WINS — `check_ea` §4's derivation, unchanged, because two pairings that
# disagree would make the two sections' numbers incomparable.
func _role_of(a: Ability) -> String:
	if a.heal > 0 or Ability.HEAL_SPECIALS.has(a.special):
		return "heal"
	if Ability.SHIELD_SPECIALS.has(a.special):
		return "shield"
	if a.damage > 0 or Ability.DAMAGE_SPECIALS.has(a.special):
		return "aoe-damage" if (a.aoe or a.random_hits > 0) else "damage"
	if not a.applies_status.is_empty():
		return "debuff" if a.target == Ability.Target.ENEMY else "buff"
	return "buff"
