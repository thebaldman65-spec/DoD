# Runes (Batch X, re-shaped at BATCH ES): every authored rune lives in
# data/runes.json — name, scope, price, desc, and a payload in the
# Talents.apply_payload vocabulary (stat / ability / grant_ability /
# new_ability). Adding a rune is a JSON edit; there is NO new payload
# machinery here.
#
# ── BATCH ES §1 — RARITY IS GONE, ENTIRELY ─────────────────────────────────
# There are no tiers, no rarity odds and no zone progression in rune quality.
# What rarity used to do, and where each half went:
#
#   IT MEANT KIND — common was flat stat adds, rare altered an ability's
#     numbers, epic granted an ability or inverted a rule. **THAT WAS AN
#     AUTHORING CONVENTION AND NOT A BEHAVIOUR**, and every rune goes on doing
#     exactly what it did: the kind lived in the payload, never in the label.
#     The one place it was mechanical is the generated TEMPLATE family below.
#   IT DROVE THE OFFER ODDS — 60/30/10 at zone 1 deepening to 25/45/30 by
#     zone 3, which was the only thing making a late offer differ from an early
#     one. **GONE. `generate` draws FLAT** from the eligible authored pool plus
#     the template family.
#   IT SET THE PRICE for the generated family (50/100/160 by tier). Authored
#     runes have always carried their own `price` and are untouched; the
#     template family sits on TEMPLATE_PRICE, the Common floor it already had.
#     **NO PRICING RULE IS INVENTED HERE — that is the designer's.**
#
# ── BATCH ES §3 — "SCARRED" IS GONE AS A LABEL; EVERY COST CLAUSE STAYS ─────
# There is no `scarred` flag, no Scarred prefix and no Scarred colour. A rune
# that gives and takes is simply what that rune does, and its negative terms
# are byte-unchanged. **`is_cost()` BELOW IS A DIFFERENT THING AND SURVIVES**:
# it reads a field name and a sign, never a label, and it is what holds a cost
# at its authored value under the sim's power probe.
#
# ── ELIGIBILITY (the load-bearing part) ────────────────────────────────────
# "scope" is universal | class:<key> | spec:<id> — spec runes only roll for a
# matching hero, so the awakening shapes the loot table. **ES §2 RULED THAT
# SCOPE IS SPEC AND CLASS ONLY and the five universals are RE-SCOPED, not
# retired — the class each lands on is the designer's and is unmade, so
# `universal` still resolves here.** The day the five are re-homed it can go.
# Ability-payload runes MUST carry "requires_ability": Talents.apply_payload
# matches on display_name and a rune naming an ability the hero does not own
# applies silently and does NOTHING. The derivable kit checked here: core kit
# + spec abilities + apply_kit_overrides renames + the member's bm_abilities
# (boss trophies).
class_name Runes

const DATA_PATH := "res://data/runes.json"

# BATCH ES §1 — WHAT REPLACED THE RARITY LABEL AND COLOUR ON A RUNE INSTANCE.
# The shop row, the offer button and both pouch lists showed a rarity word and
# a rarity tint. **SCOPE IS THE SURVIVING AXIS** (§2 makes it the only one), so
# it is what those surfaces show now: how narrowly a rune is written, which is
# the one thing about a rune that is not in its description. The palette is
# carried over UNCHANGED from the three tiers so nothing about the screens
# moves except what the words mean — broader reads greyer, narrower reads rarer
# to the eye. **THIS IS NOT RARITY UNDER A NEW NAME**: it drives no odds, no
# price and no magnitude, and it is derived from a field that decides
# eligibility rather than from a tier nobody can see.
const SCOPE_INFO := {
	"universal": {"label": "Universal", "color": Color(0.8, 0.8, 0.8)},
	"class": {"label": "Class", "color": Color(0.45, 0.65, 1.0)},
	"spec": {"label": "Spec", "color": Color(0.75, 0.45, 1.0)},
}

# The generated family's price. It is the Common floor these six already sat
# on, carried over so nothing moves — NOT a new pricing rule.
const TEMPLATE_PRICE := 50

# The pre-Batch-X generated family: flat stat sticks.
#
# **BATCH FM §1 — THIS IS NO LONGER `generate`'S EXHAUSTION FLOOR, AND IT IS NO
# LONGER IN ANY OFFER.** The six entries are KEPT, unmoved and still resolving,
# under ET's retirement contract — removed from the offer, not from the code.
# `DOD_SIM_RUNES=stats` is the one thing that still reaches them.
#
# **BATCH ES §1 — THE ONE PLACE RARITY WAS MECHANICAL, AND THE ONE MAGNITUDE
# THIS BATCH MOVES.** `base` used to be multiplied by the tier's ×1/×2/×3 and
# the tier's prefix went into the name, so these six were EIGHTEEN runes across
# three grades. With the tiers gone they are six, at `base`, at TEMPLATE_PRICE
# — the Common grade they were authored at, unscaled. Nothing authored moved.
const TEMPLATES := [
	{"noun": "Vitality", "stat": "max_hp", "base": 10, "fmt": "+%d max HP"},
	{"noun": "Warding", "stat": "armor", "base": 0.02, "fmt": "+%d%% armor"},
	{"noun": "Swiftness", "stat": "speed", "base": 4, "fmt": "+%d Speed"},
	{"noun": "Poise", "stat": "constitution", "base": 12, "fmt": "+%d Constitution"},
	{"noun": "Precision", "stat": "crit_bonus", "base": 0.02, "fmt": "+%d%% crit chance"},
	{"noun": "Springs", "stat": "max_resource", "base": 8, "fmt": "+%d max Mana"},
]

# JSON parses every number as a float, and typed set() on Ability chokes
# on floats (the Enemies.AB_INT_KEYS lesson) — restore ints on load.
const AB_INT_KEYS := ["damage", "pressure", "cost", "cooldown", "resource_gain",
	"multi_hits", "random_hits", "faith_cost", "bleed_build"]
const STAT_INT_KEYS := ["max_hp", "attack", "constitution", "max_resource",
	"resource", "bleed_bonus", "mana_regen_bonus", "blood_pact",
	# Batch AA: int counters that do NOT end in "_ranks" and so would slip
	# through as floats — BattleUnit.setup() pushes cfg straight into typed
	# vars, and a float into an int var is a runtime error, not a rounding.
	"zealous_mercy", "mercy_cap_bonus",
	# Batch AB: the Hunter trees are full of these — flag talents whose
	# payload is a bare 1. Same trap, same list. BATCH AY REMOVED
	# `loyalty_cap_bonus`: §2 gave Loyalty no ceiling, so the field has no
	# meaning, no writer and no reader left — the Rune of the Deep Bond that
	# wrote it was re-pointed at the boon's step. NOTE THE OTHER HALF OF THE
	# RULE, because AY's two new Beastmaster counters are the exception that
	# proves it: `wild_communion_step` and `absolute_step` are FLOATS (the
	# Deep Bond pays 1.5), so they must stay OUT of this list or the coercion
	# rounds them and the rune goes quietly under-strength (AT's
	# `conduit_step` precedent).
	# BATCH AZ: these three STAY, and the reason CHANGED under them. They used
	# to be flag talents whose payload was a bare 1; they are int MAGNITUDES now
	# (`deep_focus` = points the conversion point drops, `perfect_form` = Focus
	# a crit grants, `opening_volley` = Focus he opens holding), and an int
	# magnitude whose name does not end "_ranks" needs this list exactly as much
	# as a flag did. THE CLASS OF CHANGE THAT FAILS SILENTLY IS THE OTHER ONE:
	# `opp_aim_step` is a FLOAT and is deliberately ABSENT, because the coercion
	# would round 4.0 and nothing would crash.
	"deep_focus", "perfect_form", "opening_volley",
	# BATCH BA: `vulture` STAYS, and the reason changed under it too. It was a
	# Survivalist flag whose payload was a bare 1; it is an int MAGNITUDE now
	# (60 = percentage points of damage against a three-affliction target) and
	# the Rune of the Carrion Wake pays 30 into it, so it needs this list
	# exactly as much as it did as a flag. `coated_blades` stays a genuine FLAG
	# — a rule, not an amount — and stays here for the original reason.
	"coated_blades", "vulture",
	# BATCH BA, the rest of the Survivalist's additive counters that do NOT end
	# in "_ranks". None is written by a rune TODAY — the four spec:mystic runes
	# ride `potent_ranks`, `cruel_ranks`, `wire_ranks`, `scavenger_ranks`,
	# `coated_blades` and `vulture` — and they are listed for the durability
	# AW/AX listed their unwritten ones with, so a later rune cannot land on one
	# and fail to spawn a hero. NOT HERE ON PURPOSE: `max_hp_pct` is FRACTIONAL
	# (Woodcraft's 0.20, the Carrion Wake's -0.12) and coercing it would flatten
	# both to zero.
	"necrosis", "quartermaster", "quick_rigging", "caught_fast", "bone_breaker",
	"deadfall_network", "hit_and_run", "field_medic", "ghillie", "improvised",
	"perfected_toxin", "force_of_nature",
	# Batch AR: the Rune of the Cinder Trail was re-pointed onto its own term
	# when the node took cinder_trail_ranks for a new meaning. Same trap, same
	# list — it is a bare 1 that does not end in "_ranks".
	"rune_cinder_ember",
	# Batch AV: the Holy tree's counters went ADDITIVE, so none of them end in
	# "_ranks" any more. THE RULE FOR THE NEXT AUTHOR: a rune writing an int
	# BattleUnit field whose name does not end "_ranks" must be listed here,
	# or JSON's float slides straight into a typed int var and the hero fails
	# to spawn. **NO RUNE WRITES ANY OF THESE THREE ANY MORE** — EM re-keyed
	# `triage_heal` and `last_hope_pct`, and EN re-keyed `divine_presence_pct`
	# with the last three of the 59. All three stay listed for the durability
	# AW and AX list their unwritten ones with; their `rune_` halves are in
	# EM's block below.
	"triage_heal", "divine_presence_pct", "last_hope_pct",
	# Batch AW: the Devout's counters went additive too. Most kept their
	# "_ranks" names (they are still int magnitudes, just in bigger units), but
	# those holding the INCREASE on a base the kit pays without the node are
	# named "_step" — and two of them are written by runes today (the Burning
	# Censer's righteous_step, the Binding Oath's faithful_step).
	# BATCH BH §2 REMOVED `fervor_step` FROM THIS LIST WITH THE FIELD ITSELF:
	# Fervor no longer deepens Consecrated Ground's drip, so the counter has no
	# meaning, no writer and no reader (the AY `loyalty_cap_bonus` precedent —
	# a field deleted with its premise leaves this list too, or the list decays
	# into a graveyard of names nothing can write).
	# `oath_opening` JOINS IT for the ordinary reason: the Rune of the Binding
	# Oath writes a bare 1 into it and the name does not end "_ranks", which is
	# exactly the AA float-into-int trap. `oath_faith` is NOT here — no rune
	# writes it, and node payloads are GDScript ints already.
	"stalwart_step", "righteous_step", "faithful_step", "oath_opening",
	"covenant_heal", "covenant_faith",
	"resolve_extra_turns", "bulwark_extra_turns",
	# Batch AX: the Occultist's counters went additive as well. Four hold the
	# INCREASE on a base the kit already pays and are named `_step`; `spread_ruin`
	# is the stack count Spread of Madness marks with (one counter cannot hold a
	# chance AND a stack count). THREE OF THESE FIVE ARE WRITTEN BY RUNES TODAY —
	# the Deepening Ruin's `deep_hex_step`, the Hollow Chalice's `soul_leech_step`
	# and the Whispering Dark's `spread_ruin` — and the other two are listed for
	# the same durability AW listed its unwritten ones with.
	# BATCH DP: TWO OF THE FIVE CHANGED WHAT THEY MEAN AND NOT ONE CHANGED SHAPE,
	# which is why this list did not move. `whispers_step` steps `OLD_GODS_MARK`
	# now instead of Psychosis's 50%, and `spread_ranks`/`spread_ruin` describe a
	# landing MARK leaping instead of a Psychosis leaping — all three still int,
	# still additive, still written by the Whispering Dark. `broken_mind` JOINS
	# for AW's durability reason: it is a Ruin DEPTH, no rune writes it today,
	# and it does not end in `_ranks` so nothing would coerce it if one did.
	# NOT HERE ON PURPOSE: `pleasure_pct` is FRACTIONAL (2.5), so coercing it to
	# an int would silently halve Pleasure from Pain.
	"deep_hex_step", "soul_leech_step", "whispers_step", "barter_step",
	"spread_ruin", "broken_mind",
	# BATCH BS §3: the re-authored Inferno lane's counters. NONE IS WRITTEN BY A
	# RUNE TODAY — the audit in §4 came back clean, and the four spec:pyromancer
	# runes ride `accelerant_ranks`, `conflagration_ranks`, `molten_ranks`,
	# `supernova_ranks`, `blast_radius_ranks`, `rune_cinder_ember`,
	# `rune_resist_pierce` and the inert `pyromaniac_ranks` — so these are
	# listed for the durability AW and AX listed their unwritten ones with: a
	# later rune landing on one must not fail to spawn a hero. They are int
	# MAGNITUDES whose names do not end "_ranks", which is exactly the AA trap.
	# THE SIX FIELDS THE LANE DELETED LEAVE NO ENTRIES BEHIND because they never
	# had any (`fire_walker`, `invigorating_ranks`, `heat_haze_ranks`,
	# `kiln_forged`, `ash_lung`, `cauterise`, and the old `forge_body`).
	"ember_shroud", "ashen_skin", "ashen_skin_heal", "heat_haze", "backblast",
	"kiln_forged_at", "ash_lung_pct", "forge_body_pct",
	# BATCH EM — THE RE-KEY'S HALF OF THIS LIST, AND IT IS THE SAME AA TRAP
	# WEARING A PREFIX. `rune_X` inherits nothing from `X`: a `rune_` field
	# whose name does not end "_ranks" needs a row here exactly as its partner
	# did, or JSON's float slides into a typed int var and the hero fails to
	# spawn. These are the FOURTEEN of the 50 re-keyed counters whose names do
	# not end "_ranks" — the other 36 are `*_ranks` and the suffix arm covers
	# them. **BATCH EN ADDED THE FOURTEENTH**, `rune_divine_presence_pct`, with
	# the last three of the 59 (see `unit.gd`'s header block).
	# **THE NINE FLOATS ARE DELIBERATELY ABSENT** and must stay absent:
	# `rune_wild_communion_step`, `rune_absolute_step`, `rune_conduit_step`,
	# `rune_companion_hp_pct`, `rune_bloodrage_step_bonus`,
	# `rune_swordsmanship_parry`, `rune_seasoned_off_bonus` and
	# `rune_seasoned_def_bonus` are floats, and EN's `rune_pleasure_pct` is the
	# NINTH. Coercing any of them would round the rune quietly under strength
	# (AT's `conduit_step` precedent) — and the Bared Guard's -0.15 and the
	# Whispering Dark's 0.5 would both flatten to 0 outright.
	"rune_coated_blades", "rune_vulture", "rune_deep_focus", "rune_perfect_form",
	"rune_opening_volley", "rune_triage_heal", "rune_last_hope_pct",
	"rune_zealous_mercy", "rune_righteous_step", "rune_faithful_step",
	"rune_soul_leech_step", "rune_deep_hex_step", "rune_spread_ruin",
	"rune_divine_presence_pct",
	# BATCH EZ — THE FIRST TWENTY-ONE'S OWN INT FIELDS. Nineteen of the
	# twenty-one write an int and NONE of the nineteen ends in "_ranks", so
	# every one needs this list for exactly the AA reason: JSON parses `1` as a
	# float and a float into a typed int var is a runtime error at spawn, not a
	# rounding. **THE TWO FLOATS ARE DELIBERATELY ABSENT AND NAMED HERE SO THE
	# ABSENCE READS AS A DECISION**: `rune_ruin_leech_cap` (the Standing Mark's
	# 0.20) and `rune_bared_fang` (0.30) would both flatten to 0 outright, which
	# is the failure that reads exactly like the rune working — the Bared
	# Guard's -0.15 precedent, one line up.
	"rune_hex_threshold", "rune_split_tongue", "rune_wide_rite",
	"rune_open_wound",
	# BATCH FC — the Shared Ruin's flag, on the list for the same AA reason
	# as the four above it: JSON parses `1` as a float and a float into a
	# typed int var is a runtime error at spawn, not a rounding.
	"rune_shared_ruin",
	"rune_standing_wall", "rune_bracing_line",
	"rune_split_shield", "rune_long_watch", "rune_no_block",
	"rune_keen_focus", "rune_heavy_bolts", "rune_ambush", "rune_wide_watch",
	"rune_long_draw_presses", "rune_long_leash", "rune_shared_hide",
	"rune_answering_pack", "rune_second_whistle", "rune_shared_scent",
	# BATCH FK — THE EIGHT UNAUTHORED SPECS' OWN INT FIELDS. Thirty-eight of
	# the thirty-nine write an int and NONE of the thirty-eight ends in
	# "_ranks", so every one needs this list for exactly the AA reason: JSON
	# parses `1` as a float and a float into a typed int var is a runtime error
	# at spawn, not a rounding.
	#
	# **THE ONE FLOAT IS DELIBERATELY ABSENT AND NAMED HERE SO THE ABSENCE
	# READS AS A DECISION**: `rune_seasoned_off_bonus` (the Whetstone's 0.03
	# per-turn step) is a FRACTION and coercing it would flatten it to 0
	# outright — the failure that reads exactly like the rune working, which is
	# the Bared Guard's -0.15 precedent two blocks up. It is already in the
	# nine named there and stays out for the same reason.
	"rune_last_word", "rune_blood_debt", "rune_butchers_bill", "rune_open_vein",
	"rune_bleedout_action",
	"rune_long_fuse", "rune_ashfall", "rune_chain_fire", "rune_ember_leap",
	"rune_pyre_debt",
	"rune_second_winter", "rune_killing_cold", "rune_glass_prison",
	"rune_cold_snap", "rune_deep_cold",
	"rune_resonant_carry", "rune_half_note", "rune_overtone", "rune_dissonance",
	"rune_overflow",
	"rune_growing_edge", "rune_mirror_guard", "rune_open_line", "rune_long_blade",
	"rune_naked_blade",
	"rune_vigil", "rune_open_hand", "rune_long_watch_mercy", "rune_grace",
	"rune_martyr",
	"rune_layered_aegis", "rune_deep_absorb", "rune_fourth_stack",
	"rune_bare_altar",
	"rune_long_poison", "rune_second_barb", "rune_full_board", "rune_carrion",
	"rune_thin_blood"]

static var _data := {}


# ============ BATCH EK §2 / EL §2 — THE RUNE'S ARCHETYPE TAGS ============
#
# **THE SAME WORDS THE CARDS CARRY**, keyed by rune id, so a rune and a draft
# card can be read as pointing the same direction. The vocabulary, why it is
# MECHANICS rather than status names, why EL renamed six of the seven, and the
# BR §1 name sweep are all in `Classes.CARD_TAGS`'s header — **one authored
# explanation, not two.**
#
# **DERIVED FROM THE READ SITE OF EACH PAYLOAD FIELD**, never from the rune's
# `desc` and never from its `lane`. A rune's payload is a set of FIELDS, so the
# field's read site is where the rune does its work — the instrument EJ used
# for the charter audit, one layer in. **A rune whose whole payload is an
# `ability` edit carries the tag of the EDIT rather than of the ability**: the
# Rune of Zealotry makes Smite hit harder, so it is OFFENSE, not BREAK.
#
# **EL'S SEVENTH TAG REACHES NO RUNE, AND THAT IS MEASURED RATHER THAN
# ASSUMED.** Every mark in the game is laid by a CARD; not one rune payload
# field reads `covenant`, `quarry`, `snare_line`, `feinted`, `hunt_mark`,
# `party_mark`, `blood_debt`, `vendetta`, `reacquire` or `arcane_echo`. The
# Rune of the Whispering Dark says *"each mark of Ruin"* in its `desc`, which
# is the ordinary English word for a stack and is exactly the reading this
# header forbids taking. **MARK therefore appears in `Classes.TAG_ORDER` and
# in no row below.**
#
# **MECHANICALLY INERT, AND FE §1 MEASURED HOW INERT.** `check_ek` asserts
# nothing reads these for anything but display — and the display does not exist
# yet either. The whole chain is `RUNE_TAGS` → `rune_tags()` →
# `rune_tag_line()` → **nothing**: that builder has ZERO callers in `scripts/`
# and in `scenes/`. `docs/reports/EK.md` is where it was deferred -- the rune
# offer *"wants its own rune-offer surface, which is the rune batch's work"*.
# **NEITHER RUNE CONDITION READS THIS TABLE**: `threshold_met` and
# `breadth_met_fraction` both count
# `Classes.card_tag_primary` over the hero's DRAFTED CARDS (EZ §0c), so a rune's
# own primary feeds nothing at all. **EJ SIZED THE RE-KEY THAT WOULD USE THEM**
# — 59 clauses in 32 runes — and that is still a later batch.
#
# ══ BATCH FE §1 — THE RUNE ROWS FOLLOW THE CARDS ══════════════════════
#
# **NO RUNE CARRIES BREAK AS ITS PRIMARY EITHER**, ruled by the designer, and
# the population was DERIVED off this table rather than taken from a list:
# **five rows**, `long_watch` and `bared_plate` live, `comet`, `seventh_bolt`
# and `shattered_guard` retired. All five now read `["OFFENSE", "BREAK"]`.
#
# **FOUR OF THE FIVE CARRIED BREAK AS THEIR *ONLY* TAG** and cost nothing to
# move — one tag becomes two and nothing is displaced, exactly as the 20
# single-tag cards of FD's 54 did. **`bared_plate` IS THE ONE PER-RUNE
# JUDGEMENT**: it read `["BREAK", "DEFENSE"]`, and two tags is the ceiling
# (`check_ek` §2), so retaining BREAK displaces DEFENSE. **That DEFENSE was
# recording a DRAWBACK** — the rune spends the hero's Block for +25% Break
# damage — **and the drawback is already recorded one table down**, where
# `RUNE_SHAPES["bared_plate"]` reads `["STAT", "TRADEOFF"]`. Nothing is lost
# that is not written elsewhere, which is why this is a displacement rather
# than a collision. **NO ROW WAS A FEINT**: no standing ruling pins any of the
# five rows' second slot, so BREAK is retained on all five and the demotion
# never became a removal.
#
# **THE RETIRED THREE MOVE WITH THE LIVE TWO, DELIBERATELY.** The reason for
# the ruling is that one vocabulary with two rules is the defect — `inquisitor`
# displaying as Devout has misled three briefs — and a retired entry is kept
# precisely so it can be read. A row left behind is the second rule.
const RUNE_TAGS := {
	"binding_souls": ["DEFENSE"],  # Rune of Binding Souls
	"martyr": ["DEFENSE", "TEMPO"],  # Rune of the Martyr
	"zealotry": ["OFFENSE"],  # Rune of Zealotry
	"hoarfrost_points": ["DEBUFF", "OFFENSE"],  # Rune of Hoarfrost Points
	"true_flight": ["OFFENSE"],  # Rune of True Flight
	"wolfs_hunger": ["DEFENSE", "OFFENSE"],  # Rune of the Wolf's Hunger
	"comet": ["OFFENSE", "BREAK"],  # Rune of the Comet
	"reckless_channeling": ["DEFENSE", "OFFENSE"],  # Rune of Reckless Channeling
	"wellspring": ["RESOURCE"],  # Rune of the Wellspring
	"emberforged": ["DEBUFF", "OFFENSE"],  # Emberforged Rune
	"old_wrath": ["RESOURCE"],  # Rune of Old Wrath
	"warriors_edge": ["OFFENSE", "RESOURCE"],  # Rune of the Whetted Edge
	"resonant_core": ["OFFENSE"],  # Rune of the Resonant Core
	"seventh_bolt": ["OFFENSE", "BREAK"],  # Rune of the Seventh Bolt
	"unquiet_mind": ["RESOURCE", "TEMPO"],  # Rune of the Unquiet Mind
	"wide_current": ["RESOURCE", "OFFENSE"],  # Rune of the Wide Current
	"deep_bond": ["DEBUFF", "DEFENSE"],  # Rune of the Deep Bond
	"loosened_straps": ["DEFENSE"],  # Rune of the Loosened Straps
	"shared_wild": ["DEBUFF", "OFFENSE"],  # Rune of the Shared Wild
	"turning_pack": ["DEBUFF", "OFFENSE"],  # Rune of the Turning Pack
	"boiling_blood": ["DEFENSE", "OFFENSE"],  # Rune of Boiling Blood
	"broad_path": ["DEFENSE", "DEBUFF"],  # Rune of the Broad Path
	"exsanguination": ["DEFENSE", "OFFENSE"],  # Rune of Exsanguination
	"warpath": ["DEBUFF", "RESOURCE"],  # Rune of the Warpath
	"bitter_grip": ["DEBUFF"],  # Rune of the Bitter Grip
	"honed_lance": ["OFFENSE", "RESOURCE"],  # Rune of the Honed Lance
	"killing_cold": ["DEBUFF", "DEFENSE"],  # Rune of the Killing Cold
	"long_winter": ["DEBUFF"],  # Rune of the Long Winter
	"last_rites": ["DEFENSE", "TEMPO"],  # Rune of the Last Rites
	"open_hand": ["OFFENSE"],  # Rune of the Open Hand
	"sleepless_vigil": ["DEFENSE", "TEMPO"],  # Rune of the Sleepless Vigil
	"triage_ward": ["RESOURCE", "OFFENSE"],  # Rune of the Triage Ward
	"binding_oath": ["RESOURCE", "DEFENSE"],  # Rune of the Binding Oath
	"burning_censer": ["DEFENSE", "DEBUFF"],  # Rune of the Burning Censer
	"standing_vow": ["DEFENSE", "RESOURCE"],  # Rune of the Standing Vow
	"warded_robes": ["DEFENSE"],  # Rune of the Warded Robes
	"carrion_wake": ["DEFENSE", "DEBUFF"],  # Rune of the Carrion Wake
	"long_hunt": ["DEBUFF"],  # Rune of the Long Hunt
	"quick_spring": ["DEBUFF", "TEMPO"],  # Rune of the Quick Spring
	"weeping_wound": ["DEBUFF"],  # Rune of the Weeping Wound
	"deepening_ruin": ["DEBUFF", "DEFENSE"],  # Rune of the Deepening Ruin
	"flayed_mind": ["DEBUFF", "BREAK"],  # Rune of the Flayed Mind
	"hollow_chalice": ["DEFENSE", "DEBUFF"],  # Rune of the Hollow Chalice
	"whispering_dark": ["RESOURCE", "DEBUFF"],  # Rune of the Whispering Dark
	"blast_radius": ["DEBUFF"],  # Rune of the Blast Radius
	"cinder_trail": ["DEBUFF"],  # Rune of the Cinder Trail
	"long_burn": ["DEBUFF"],  # Rune of the Long Burn
	"white_flame": ["DEFENSE", "DEBUFF"],  # Rune of the White Flame
	"deep_sight": ["RESOURCE", "OFFENSE"],  # Rune of the Deep Sight
	"level_aim": ["RESOURCE", "OFFENSE"],  # Rune of the Level Aim
	"long_draw": ["TEMPO", "RESOURCE"],  # Rune of the Long Draw
	"narrow_gap": ["OFFENSE", "DEBUFF"],  # Rune of the Narrow Gap
	"bared_guard": ["DEFENSE"],  # Rune of the Bared Guard
	"duelist": ["DEFENSE", "BREAK"],  # Rune of the Duelist
	"shattered_guard": ["OFFENSE", "BREAK"],  # Rune of the Shattered Guard
	"still_wrist": ["DEFENSE", "RESOURCE"],  # Rune of the Still Wrist
	"grudges": ["OFFENSE"],  # Rune of Grudges
	"iron_promise": ["DEFENSE", "TEMPO"],  # Rune of the Iron Promise
	"sentinel": ["DEFENSE", "BREAK"],  # Rune of the Sentinel
	"standard": ["DEFENSE"],  # Rune of the Standard
	"anchor": ["DEFENSE", "TEMPO"],  # Anchor Rune
	"colossus": ["DEFENSE"],  # Rune of the Colossus
	"glass": ["OFFENSE", "DEFENSE"],  # Glass Rune
	"reaper": ["OFFENSE"],  # Rune of the Reaper
	"vampiric": ["DEFENSE", "OFFENSE"],  # Vampiric Rune
	# ── BATCH EZ — THE FIRST TWENTY-ONE, ON THE SAME VOCABULARY ─────────────
	# **THESE ARE THE ARCHETYPE TAGS AND THEY ARE NOT §0's PRIMARY TYPE.** EZ
	# §0 gives every rune a TYPE (ABILITY / PASSIVE / STAT) and an optional
	# SECONDARY (THRESHOLD / BREADTH / TRADEOFF); those live in `RUNE_SHAPES`
	# below and are a different axis entirely — one says what a rune touches,
	# this says what it is FOR, in the same seven words every card carries.
	# Both are wanted and neither derives the other: `standing_wall` is a
	# PASSIVE with no secondary, and it is a DEFENSE rune.
	"deepening_hex": ["DEBUFF", "BREAK"],      # Deepening Hex
	"standing_mark": ["DEBUFF", "DEFENSE"],    # Standing Mark — the draught heals
	"split_tongue": ["DEBUFF"],                # Split Tongue (RETIRED at FC)
	"shared_ruin": ["DEBUFF"],                 # the Shared Ruin — it MOVES the mark
	"wide_rite": ["DEBUFF"],                   # Wide Rite
	"open_wound": ["DEBUFF"],                  # Open Wound
	"standing_wall": ["DEFENSE"],              # Standing Wall
	"bracing_line": ["DEFENSE"],               # Bracing Line
	"split_shield": ["DEFENSE"],               # Split Shield
	"long_watch": ["OFFENSE", "BREAK"],        # Long Watch
	"bared_plate": ["OFFENSE", "BREAK"],       # Bared Plate — DEFENSE displaced (FE §1)
	"keen_focus": ["RESOURCE"],                # Keen Focus
	"heavy_bolts": ["RESOURCE", "OFFENSE"],    # Heavy Bolts
	"ambush": ["OFFENSE", "RESOURCE"],         # Ambush
	"wide_watch": ["RESOURCE"],                # Wide Watch
	"long_draw_press": ["RESOURCE"],           # Long Draw — the sequence pays Focus
	"long_leash": ["OFFENSE", "RESOURCE"],     # Long Leash
	"shared_hide": ["OFFENSE"],                # Shared Hide
	"answering_pack": ["DEFENSE"],             # Answering Pack
	"second_whistle": ["RESOURCE"],            # Second Whistle
	"shared_scent": ["RESOURCE"],              # Shared Scent
	"bared_fang": ["OFFENSE", "DEFENSE"],      # Bared Fang — it SPENDS the mending
	# ── BATCH FK — THE EIGHT UNAUTHORED SPECS, ON THE SAME VOCABULARY ───────
	# **DERIVED FROM THE READ SITE OF EACH PAYLOAD FIELD**, never from the
	# rune's `desc` — this table's own rule, one header up. Where a rune's whole
	# payload is an ABILITY edit it carries the tag of the EDIT rather than of
	# the ability, which is why the Cold Snap is OFFENSE and not DEBUFF: what it
	# changes is how many bodies the lance strikes.
	#
	# **MARK STILL REACHES NO RUNE**, and it is measured rather than assumed for
	# the second time: not one of these thirty-nine payload fields is read
	# anywhere near `covenant`, `quarry`, `snare_line`, `feinted`, `hunt_mark`,
	# `party_mark`, `blood_debt`, `vendetta`, `reacquire` or `arcane_echo`. The
	# Rune of Blood Debt is the near-miss and it is a real one — it shares a NAME
	# with the card that lays the `blood_debt` mark — but its payload re-points
	# Blood PRICE's cost and touches no mark at all.
	#
	# **AND NO RUNE CARRIES BREAK AS ITS PRIMARY**, which is FE §1's ruling
	# holding: three of these read BREAK as a SECOND tag and none as a first.
	# Berserker —
	"last_word": ["TEMPO", "DEFENSE"],         # the Last Word — a turn, taken at the line
	"blood_debt_rune": ["RESOURCE", "OFFENSE"],# Blood Debt — the bill moves, the meter fills
	"butchers_bill": ["OFFENSE", "DEBUFF"],    # the Butcher's Bill — a strike, bought with a wound
	"open_vein": ["RESOURCE", "OFFENSE"],      # the Open Vein — spend feeds the band
	"slaughterhouse_rune": ["TEMPO"],          # the Slaughterhouse — a bleedout IS a turn
	# Pyromancer —
	"long_fuse": ["DEBUFF"],                   # the Long Fuse — the clock stops
	"ashfall": ["DEFENSE", "DEBUFF"],          # the Ashfall — a shield that costs no fire
	"chain_fire": ["DEBUFF"],                  # the Chain Fire — the field consolidated
	"ember_leap": ["DEBUFF"],                  # the Ember Leap — the field widened
	"pyre_debt": ["RESOURCE", "DEFENSE"],      # the Pyre Debt — Mana bought with health
	# Cryomancer —
	"second_winter": ["DEBUFF"],               # the Second Winter — the release leaves the cold
	"killing_cold_fk": ["OFFENSE", "DEBUFF"],  # the Killing Cold — the pile bites
	"glass_prison": ["DEBUFF", "DEFENSE"],     # the Glass Prison — two held, both fragile
	"cold_snap_fk": ["OFFENSE", "BREAK"],      # the Cold Snap — the lance finds every body
	"deep_cold": ["DEBUFF"],                   # the Deep Cold — the cap comes off
	# Arcanist —
	"resonant_core_fk": ["RESOURCE"],          # the Resonant Core — the meter survives the fight
	"half_note": ["RESOURCE"],                 # the Half Note — the bolt takes less
	"overtone": ["RESOURCE"],                  # the Overtone — build rate, on a cadence
	"dissonance": ["OFFENSE", "DEFENSE"],      # the Dissonance — both curves, doubled
	"overflow": ["RESOURCE", "OFFENSE"],       # the Overflow — a crit banks deeper
	# Swordmaster —
	"whetstone": ["OFFENSE"],                  # the Whetstone — the guard held sharpens
	"mirror_guard": ["DEFENSE", "OFFENSE"],    # the Mirror Guard — the refusal answers
	"open_line": ["TEMPO", "OFFENSE"],         # the Open Line — the pivot without the pivot
	"long_blade": ["TEMPO", "BREAK"],          # the Long Blade — the cooldown, not the Break
	"naked_blade": ["OFFENSE", "DEFENSE"],     # the Naked Blade — both guards, doubled
	# Holy —
	"vigil": ["RESOURCE"],                     # the Vigil — the bar reads the rescue too
	"open_hand_fk": ["DEFENSE"],               # the Open Hand — the plea reaches the party
	"long_watch_holy": ["RESOURCE"],           # the Long Watch — the bar survives the fight
	"grace": ["DEFENSE", "TEMPO"],             # the Grace — the hymn, sung twice
	"martyr_fk": ["RESOURCE", "DEFENSE"],      # the Martyr — the wound is the offering
	# Devout —
	"layered_aegis": ["DEFENSE"],              # the Layered Aegis — two bodies warded
	"deep_absorb": ["RESOURCE", "DEFENSE"],    # the Deep Absorb — the absorb pays more
	"fourth_stack": ["DEFENSE", "OFFENSE"],    # the Fourth Stack — the peak goes one higher
	"bare_altar": ["RESOURCE", "DEFENSE"],     # the Bare Altar — rate bought with size
	# Survivalist —
	"long_poison": ["DEBUFF"],                 # the Long Poison — the clock stops
	"second_barb": ["DEBUFF"],                 # the Second Barb — breadth off the counter-hit
	"full_board": ["DEBUFF", "OFFENSE"],       # the Full Board — billed, and left standing
	"carrion": ["DEBUFF"],                     # the Carrion — every body, not one
	"thin_blood": ["DEBUFF", "OFFENSE"],       # Thin Blood — certainty bought with the tick
}


# ══ BATCH EZ §0 — WHAT A RUNE IS AND WHAT GATES IT ═════════════════════════
#
# **THE PRIMARY TYPE — WHAT IT TOUCHES: ABILITY, PASSIVE or STAT. THE
# SECONDARY — WHAT GATES IT, IF ANYTHING: THRESHOLD, BREADTH or TRADEOFF.** A
# rune may carry more than one secondary, or none. Authored beside the entry it
# describes rather than derived from the payload, because the two answer
# different questions: `bared_plate` writes two `stat` fields and is a STAT rune
# with a TRADEOFF, while `standing_wall` also writes one `stat` field and is a
# PASSIVE with none — the payload's SHAPE cannot tell them apart.
#
# **THE SECONDARY IS NOT THE CONDITION AND MUST NOT BE READ AS ONE.** The
# condition is in the payload, where `Talents.condition_met` reads it; this is
# the word a surface shows. They are asserted equal to each other by the gate
# rather than by one deriving the other, so a rune labelled THRESHOLD whose
# payload carries no `tag_threshold` is a defect that can be caught.
const RUNE_SHAPES := {
	"deepening_hex": ["PASSIVE", "THRESHOLD"],
	"standing_mark": ["PASSIVE"],
	"split_tongue": ["ABILITY"],
	"shared_ruin": ["PASSIVE"],
	"wide_rite": ["PASSIVE", "BREADTH"],
	"open_wound": ["ABILITY", "TRADEOFF"],
	"standing_wall": ["PASSIVE"],
	"bracing_line": ["PASSIVE", "THRESHOLD"],
	"split_shield": ["ABILITY"],
	"long_watch": ["PASSIVE", "BREADTH"],
	"bared_plate": ["STAT", "TRADEOFF"],
	"keen_focus": ["PASSIVE"],
	"heavy_bolts": ["PASSIVE", "THRESHOLD"],
	"ambush": ["ABILITY"],
	"wide_watch": ["PASSIVE", "BREADTH"],
	"long_draw_press": ["ABILITY", "TRADEOFF"],
	"long_leash": ["PASSIVE"],
	"shared_hide": ["PASSIVE"],
	"answering_pack": ["PASSIVE", "THRESHOLD"],
	"second_whistle": ["ABILITY"],
	"shared_scent": ["PASSIVE", "BREADTH"],
	"bared_fang": ["STAT", "TRADEOFF"],
	# ── BATCH FK — THE EIGHT UNAUTHORED SPECS ──────────────────────────────
	# **NOT ONE THRESHOLD AND NOT ONE BREADTH, AND THAT IS A RULING RATHER THAN
	# A GAP.** The designer has retired both secondaries going forward: a gated
	# rune at a flat price is strictly worse than a bare one, and FJ measured
	# the constraints as unworkable besides (BREAK can never carry a threshold,
	# the Devout can never satisfy breadth, and a condition can be live at one
	# rung of the ladder and dead at the next). **TRADEOFF survives** — a cost
	# paired with a bigger upside is self-balancing and reads on the card — and
	# EIGHT of these carry one, against the four the first twenty-one had.
	#
	# **THE SIX ALREADY-SHIPPED GATED RUNES ARE NOT REPAIRED HERE.** Their rows
	# above are unchanged and they are owed to a later batch.
	"last_word": ["PASSIVE"],
	"blood_debt_rune": ["ABILITY", "TRADEOFF"],
	"butchers_bill": ["ABILITY"],
	"open_vein": ["PASSIVE"],
	"slaughterhouse_rune": ["PASSIVE"],
	"long_fuse": ["PASSIVE"],
	"ashfall": ["ABILITY"],
	"chain_fire": ["ABILITY"],
	"ember_leap": ["PASSIVE"],
	"pyre_debt": ["PASSIVE", "TRADEOFF"],
	"second_winter": ["PASSIVE"],
	"killing_cold_fk": ["PASSIVE"],
	"glass_prison": ["ABILITY", "TRADEOFF"],
	"cold_snap_fk": ["ABILITY"],
	"deep_cold": ["PASSIVE"],
	"resonant_core_fk": ["PASSIVE"],
	"half_note": ["ABILITY"],
	"overtone": ["PASSIVE"],
	"dissonance": ["PASSIVE", "TRADEOFF"],
	"overflow": ["PASSIVE"],
	"whetstone": ["PASSIVE"],
	"mirror_guard": ["PASSIVE"],
	"open_line": ["ABILITY"],
	"long_blade": ["ABILITY"],
	"naked_blade": ["PASSIVE", "TRADEOFF"],
	"vigil": ["PASSIVE"],
	"open_hand_fk": ["ABILITY"],
	"long_watch_holy": ["PASSIVE"],
	"grace": ["ABILITY"],
	"martyr_fk": ["PASSIVE", "TRADEOFF"],
	"layered_aegis": ["ABILITY"],
	"deep_absorb": ["PASSIVE"],
	"fourth_stack": ["PASSIVE"],
	"bare_altar": ["PASSIVE", "TRADEOFF"],
	"long_poison": ["PASSIVE"],
	"second_barb": ["PASSIVE"],
	"full_board": ["ABILITY"],
	"carrion": ["ABILITY"],
	"thin_blood": ["PASSIVE", "TRADEOFF"],
}

const RUNE_TYPES := ["ABILITY", "PASSIVE", "STAT"]
const RUNE_SECONDARIES := ["THRESHOLD", "BREADTH", "TRADEOFF"]


# A rune's shape: `[type]` or `[type, secondary...]`, `[]` for an id the table
# does not carry — the retired sixty-five and the generated TEMPLATE family.
# **THE ONE READER**, `rune_tags`'s own shape one table up.
static func rune_shape(id: String) -> Array:
	return RUNE_SHAPES.get(id, [])


# "PASSIVE · THRESHOLD", or "" — what a surface prints beside the tag line.
static func rune_shape_line(id: String) -> String:
	var t: Array = rune_shape(id)
	if t.is_empty():
		return ""
	var parts: Array = []
	for x in t:
		parts.append(String(x))
	return " · ".join(parts)


# A rune's tags: `[primary]` or `[primary, secondary]`, `[]` for an id the
# table does not carry (a generated TEMPLATE rune is not authored and has no
# row). **THE ONE READER**, same shape as `Classes.card_tags`.
static func rune_tags(id: String) -> Array:
	return RUNE_TAGS.get(id, [])


# ══ BATCH ES §4/§5 — WHAT A RUNE ASKS ABOUT ITS HOLDER ══════════════════════
#
# **THE READING MACHINERY, AND NOT ONE RUNE READS IT YET.** Rune CONTENT is
# written with the designer one rune at a time; these are the two SHAPES a
# clause comes through when one is, and they are here rather than in
# `Classes` because the vocabulary is the rune layer's: a threshold and a
# breadth test are what a rune asks, where a census is what a screen shows.
# The arithmetic underneath is `Classes.tag_count` / `Classes.tag_breadth`, so
# a clause and the surface that displays its state can never be two numbers.
#
# ── THEY TAKE THE NAME LIST, NOT THE MEMBER ────────────────────────────────
# `Run.loadout_ability_names(member)` is what a caller passes. **THAT IS A
# CONSTRAINT AND NOT A PREFERENCE**: this file is a `class_name` script and
# these are STATIC, and a static function cannot see an autoload — reaching
# `Run` from here is a compile error, found by running it rather than reasoned
# about. Splitting it this way is what keeps `run_state.gd` free of every tag
# word, which `check_ek` §3 asserts at ZERO for that file by name.
#
# ── WHAT THE LIST IS, AND WHY THAT SET ─────────────────────────────────────
# **EQUIPPED, NEVER OWNED.** A hero's POOL is everything he has drafted and
# nothing ever leaves it, so a threshold read off the pool turns on once, late,
# and never off again — a flat increment with a delay. His LOADOUT is what he
# carries, it is capped at 7-to-10, and he can bench and carry freely between
# fights. Counting it is what makes the loadout a lever: a player can swap to
# switch a rune on or off, which is the decision the whole shape exists for.
#
# **THE PROTECTED CORE IS IN THE COUNT**, because it is equipped — it is half
# to two thirds of the bar, `Run.ability_slots_used` counts it, and a census
# that skipped it would answer a question about the hero's cards with a number
# about only the swappable ones. **THE CONSEQUENCE IS MEASURED RATHER THAN LEFT
# TO BE DISCOVERED: the core kit ALONE already meets a 2+ threshold on BREAK for
# TEN of the twelve specs and on DEBUFF for SEVEN, while MARK is zero for all
# twelve and TEMPO reaches 1 on exactly one.** So a threshold's magnitude has to
# be chosen against the per-spec core baseline or it is on from the first fight
# and no swap can turn it off. `check_es` §4 PRINTS that table every battery
# run, so the day a core kit moves the baseline is re-measured, not re-assumed.
#
# ── WHERE THE COUNT IS COMPUTED, AND HOW OFTEN ─────────────────────────────
# **ON DEMAND, UNCACHED, AND THAT IS THE RIGHT SHAPE TODAY.** The census is one
# dictionary lookup per carried card — 7 to 10 of them — and its two callers are
# both SCREEN DRAWS (the loadout panel and the hero sheet), which run once per
# open and once per swap. There is nothing to invalidate, so there is no cache
# to go stale, which is the failure mode a cached count would add.
# **WHEN A RUNE FINALLY READS IT IN A FIGHT, THE PLACE IS THE SPAWN AND NOT THE
# STRIKE LOOP** — the loadout cannot change during a battle (benching is a map
# screen), so the count is a per-hero constant for the whole fight and belongs
# on the unit beside every other rune field. A per-hit recount would be 84
# multiplier terms' worth of work for a number that cannot move.


# **THE DEFAULT SHAPE: hold `need` or more equipped cards of a tag, get the
# effect.** Other shapes stay available per rune — this is the one a rune
# reaches for unless it wants otherwise.
static func tag_threshold_met(loadout_names: Array, tag: String, need: int) -> bool:
	return Classes.tag_count(loadout_names, tag) >= need


# **BATCH ES §5 — A SPLASH PAYS FOR BREADTH.** A normal rune pays for DEPTH in
# one tag; a splash pays for cards spanning `need` or more DIFFERENT tags. That
# is the inverse shape, and it is what gives the category an identity again now
# that the lanes it used to reach across are severed: TAGS are the thing to
# reach across, and a hero who is spread rather than deep is who it is for.
static func breadth_met(loadout_names: Array, need: int) -> bool:
	return Classes.tag_breadth(loadout_names) >= need


# ══ BATCH EZ §0 — THE TWO CONDITIONS THE FIRST TWENTY-ONE RUNES OBEY ═══════
#
# **THEY ARE FRACTIONS, NOT COUNTS, AND THAT IS THE DESIGNER'S REASON RATHER
# THAN AN IMPLEMENTATION CHOICE.** A hero drafts 4 earned slots at zone 1 and 7
# by the end (`ABILITY_SLOTS_BY_BOSS` 7→10 against a 3-slot core), so a FIXED
# count means two different commitments at those two moments — "3 DEBUFF cards"
# is three quarters of an opening loadout and under half of a finished one. A
# fraction is the same commitment all run, **and it can be tipped by benching
# one card**, which is what makes the loadout lever reach the rune layer.
#
# ── THE COUNTED SET IS THE DRAFTED HALF, AND IT IS THE SWAP LEVER'S OWN SET ──
# **`Run.equipped_ability_names(member)` — DRAFTED AND CARRIED. Not the pool,
# and NOT the protected core.** ES §4's helpers count the whole bar including
# the core, deliberately, because a screen showing a loadout must show all of
# it; **these do not, and the difference is load-bearing.** The core kit alone
# already meets a 2+ threshold on BREAK for ten of the twelve specs and on
# DEBUFF for seven (`check_es` §4 prints that table every run) — counting it
# would put those two magnitudes on from the first fight with no swap able to
# turn them off. **And `equip_earned_ability` / `unequip_earned_ability` write
# exactly this list**, so the counted set and the lever are the same set:
# EG §2 split pool from loadout and made only the earned half swappable.
#
# **THE COUNT IS PRIMARY-ONLY** (`Classes.primary_tag_*`) so the per-tag numbers
# partition the list and both conditions read one denominator — see that block
# for why the both-tags census is right for a screen and wrong for these.
#
# **READ AT THE SPAWN, NEVER IN THE STRIKE LOOP.** The loadout cannot change
# during a battle (benching is a map screen), so a payload gated on one of
# these is decided once, where `Talents.apply_payload` already reads its
# `condition` — see `Talents.condition_met`.

# **THRESHOLD: at least HALF the hero's drafted cards carry the named tag.**
# Written as `x 2 >=` rather than as a float ratio because half of an odd count
# has to round the same way every time it is read, and integer arithmetic is
# the only form of that which cannot drift between a condition and the surface
# printing it.
#
# **BATCH FA §1 — AN EMPTY DRAFTED LIST NOW MEETS NEITHER CONDITION.** EZ built
# both rules literally and the literal reading is vacuous: nothing carries the
# tag, so nothing fails to be half of it (`0 * 2 >= 0`). It is REACHABLE —
# `Run.unequip_earned_ability` has no floor, so a player can bench every earned
# card — and a hero who benched everything switched on a THRESHOLD rune and a
# BREADTH rune at the same time, **the one state the two shapes were designed
# never to share.** The designer has ruled BOTH closed: a condition about a
# hero's drafted cards is not met by a hero who has drafted none.
#
# **THE GUARD IS HERE AND NOT IN `loadout_condition_met`, AND THE PLACE IS THE
# RULING.** The hero sheet and the loadout panel call THIS function for the
# tick they draw beside `threshold_line` (`party_screen._draw_detail`,
# `map_screen._open_loadout_panel`). A guard one layer up would refuse the rune
# while both screens still drew a ✓ on an empty bar — one fact rendered two
# ways, which is exactly what the ONE BUILDER rule above `threshold_line`
# exists to prevent.
static func threshold_met(drafted: Array, tag: String) -> bool:
	if drafted.is_empty():
		return false
	return Classes.primary_tag_count(drafted, tag) * 2 >= drafted.size()


# **BREADTH: NO tag exceeds a THIRD of the hero's drafted cards.** The inverse
# shape — a threshold rewards depth in one tag, this rewards a hero who is
# spread — and it is a BOUND on the peak rather than a count of how many tags
# are touched. **`ES §5`'s `breadth_met` IS A DIFFERENT QUESTION AND BOTH
# STAND**: that one asks how many different tags a list touches at all, this
# asks whether any one of them dominates.
#
# "Exceeds" is strict, so a tag sitting exactly ON a third passes: at 6 drafted
# cards a peak of 2 is fine and 3 is not. Same integer discipline as above.
#
# **AND THE EMPTY LIST IS CLOSED HERE TOO (FA §1), FOR THE REASON IT IS CLOSED
# ABOVE AND NOT FOR A WEAKER ONE.** Breadth-of-nothing is arguably harmless on
# its own — no tag dominates a list with no tags in it — but it is the same
# degenerate state, and **two conditions with different emptiness rules is a
# second thing to remember for no gain.** Ruled closed together, deliberately.
static func breadth_met_fraction(drafted: Array) -> bool:
	if drafted.is_empty():
		return false
	return Classes.primary_tag_peak(drafted) * 3 <= drafted.size()


# **THE DRAFTED-AND-CARRIED LIST, off the member dict alone.** This file is a
# `class_name` script and these are STATIC, so it cannot see the `Run` autoload
# (EQ's compile-error lesson, recorded in the block above) — it reads the same
# two keys `Run.equipped_ability_names` reads, in the same order, so a member
# that has never benched anything reads its pool exactly as the fight does.
static func drafted_names(member: Dictionary) -> Array:
	if member.is_empty():
		return []
	return member.get("bm_equipped", member.get("bm_abilities", [])).duplicate()


# **THE ONE DOOR A PAYLOAD'S CONDITION COMES THROUGH, AND THE ONLY PLACE THE
# TWO KEY NAMES ARE WRITTEN.** `Talents.condition_met` hands the whole `cond`
# dict here rather than reading `tag_threshold` / `tag_breadth` itself, because
# `check_ek` §3 asserts that the set of `.gd` files naming the tag surface is
# EXACTLY four — the two that define the tables and the two that display them —
# and `talents.gd` is not one of them. **That is not a formality**: the day a
# fifth file names a tag, that gate is what says so, and a rune layer that had
# quietly leaked its vocabulary into the talent file would have spent the
# warning on itself.
#
# **AN EMPTY MEMBER MAKES A GATED PAYLOAD INERT** rather than silently
# unconditional — `condition_met`'s own stated direction, carried through here.
# **FA §1 MADE THIS LINE REDUNDANT AND IT IS KEPT DELIBERATELY.** It was load-
# bearing while an empty drafted list read GENEROUSLY: it was the only thing
# standing between a member-less caller and an unconditional payload. Both
# predicates now refuse an empty list themselves, so a member with no dict
# would be refused by the arithmetic one line down — but this states the
# intent at the door rather than leaving it to a property of two other
# functions, and a caller with no member is a different fault from a hero who
# benched his bar.
static func loadout_condition_met(cond: Dictionary, member: Dictionary) -> bool:
	if cond.is_empty():
		return true
	var wants_tag: bool = cond.has("tag_threshold") \
		or bool(cond.get("tag_breadth", false))
	if not wants_tag:
		return true
	if member.is_empty():
		return false
	var drafted := drafted_names(member)
	if cond.has("tag_threshold") \
			and not threshold_met(drafted, String(cond["tag_threshold"])):
		return false
	if bool(cond.get("tag_breadth", false)) \
			and not breadth_met_fraction(drafted):
		return false
	return true


# **THE ONE LINE A SURFACE PRINTS FOR A THRESHOLD** — *"4 of 7 — DEBUFF"*, or
# with the tag absent, *"0 of 7 — DEBUFF"*. ES requires the state be visible and
# EZ §0 is where that earns out: a player who cannot see he is one card away
# cannot use the lever. **ONE BUILDER**, so the hero sheet and the loadout panel
# cannot render the same fact two ways.
static func threshold_line(drafted: Array, tag: String) -> String:
	return "%d of %d — %s" % [Classes.primary_tag_count(drafted, tag),
		drafted.size(), tag]


# ...and the breadth half: *"peak 2 of 7 — BREADTH"*.
static func breadth_line(drafted: Array) -> String:
	return "peak %d of %d — BREADTH" % [Classes.primary_tag_peak(drafted),
		drafted.size()]


# The tag line as a surface renders it — "DEFENSE · RESOURCE", or "".
static func rune_tag_line(id: String) -> String:
	var t: Array = rune_tags(id)
	if t.is_empty():
		return ""
	var parts: Array = []
	for x in t:
		parts.append(String(x))
	return " · ".join(parts)


static func _load() -> Dictionary:
	if _data.is_empty():
		var f := FileAccess.open(DATA_PATH, FileAccess.READ)
		_data = JSON.parse_string(f.get_as_text())
	return _data


static func ids() -> Array:
	return _load().keys()


static func config(id: String) -> Dictionary:
	return _load().get(id, {})


# The hero's derivable kit, by display name: core kit + spec abilities +
# kit-override renames + EARNED abilities (Batch AH: six a run, from either
# pool). Do NOT skip the earned list — several runes attach to abilities a
# hero only has because it picked them.
#
# **BATCH EG §2 — THIS IS THE OWNERSHIP QUESTION AND IT READS THE POOL, WHICH
# IS WHY `bm_abilities` IS THE RIGHT FIELD AND NOTHING CHANGED HERE.**
# `Talents.ability_names` is this list, `Talents.owns_ability` is that list, and
# `Run.owned_ability_names` is that — and the three callers that matter are the
# draft's `draft_pool_left`, the boss award's `roll_spec_ability_offer` and its
# fallback. Every one of them is asking "may this hero be OFFERED that card",
# and the answer for a card he holds and has BENCHED is no. Reading the loadout
# here would re-offer a benched card as if it were new, which is the defect
# `owned_ability_names` exists to prevent, arriving through the new field.
# The one reader that wants the LOADOUT is `battle.gd`'s spawn, and it names
# `Run.equipped_ability_names` directly rather than going through here.
static func kit_names(member: Dictionary) -> Array:
	var cfg: Dictionary = Classes.hero_config(String(member["key"]))
	var spec := String(member.get("spec", ""))
	if spec != "":
		cfg["abilities"] = cfg["abilities"] + Classes.spec_abilities(spec)
		Classes.apply_kit_overrides(cfg, spec)
	var names: Array = []
	for ab in cfg["abilities"]:
		names.append(ab.display_name)
	for trophy in member.get("bm_abilities", []):
		names.append(String(trophy))
	return names


# The final shop/pouch name. **BATCH ES §1/§3 — IT IS THE AUTHORED NAME NOW.**
# It used to wear a tier prefix (Cracked / Polished / Radiant) or the Scarred
# one, and both of those vocabularies are retired. The function is KEPT rather
# than inlined at its eleven call sites because it is still the one place a
# rune's display name is built, which is what stops a second surface drawing it
# a different way (CK §1's rule).
static func display_name(entry: Dictionary) -> String:
	return String(entry["name"])


# BATCH ES §1 — THE SCOPE BAND A SURFACE SHOWS, taking rarity's old slot.
# "universal" | "class" | "spec", off the same string `_scope_ok` reads.
static func scope_band(scope: String) -> String:
	if scope.begins_with("class:"):
		return "class"
	if scope.begins_with("spec:"):
		return "spec"
	return "universal"


static func _scope_ok(entry: Dictionary, member: Dictionary) -> bool:
	var scope := String(entry.get("scope", "universal"))
	if scope == "universal":
		return true
	if scope.begins_with("class:"):
		return scope.trim_prefix("class:") == String(member["key"])
	if scope.begins_with("spec:"):
		return scope.trim_prefix("spec:") == String(member.get("spec", ""))
	return false


# BATCH EO §3 — A RETIRED RUNE IS RETIRED THE WAY MELTED ARMOR IS RETIRED:
# KEPT, AND SAID TO BE KEPT.
#
# Twelve of the sixteen the charter emptied carry a `retired` string in
# `runes.json` naming WHAT IS LOST. The entry is not deleted: `config`, `build`
# and `display_name` all still resolve it, so a saved run holding one keeps
# working and a later batch can point something at it again — the same contract
# `data/glossary.json` gives Melted Armor, which `docs/text-audit.html` calls
# the most honest string in the game.
#
# **THE FILTER LIVES HERE BECAUSE THIS IS THE ONLY DOOR.** Both offer paths —
# `generate` above and `run_state.grant_rune` — reach the authored pool through
# `eligible_ids` and nothing else, so one `continue` retires a rune everywhere
# it could be offered without touching either caller.
#
# **BATCH FM §1 — AND BOTH CAN BE BLANKED BY IT NOW, DELIBERATELY.** This block
# used to end *"neither can be blanked: `generate` falls back to the generated
# stat family, and `grant_rune` falls back to `generate_rune`"*. The second half
# still holds and the first is what FM removed: with the family out of the offer
# `generate` returns `{}` on an exhausted pool, so `grant_rune`'s fallback lands
# on an empty too. **An empty offer is a ruled outcome, not a fault** — every
# authored rune is spec-scoped and five per hero, so a hero who has seen his
# five has seen the pool. The four offer sites each say so (FM §2).
static func is_retired(id: String) -> bool:
	return String((_load().get(id, {}) as Dictionary).get("retired", "")) != ""


# Authored entries this member may roll, excluding names already in their pouch
# and every retired entry.
#
# **BATCH ES §1 — THE `rarity_key` PARAMETER IS GONE AND SO IS THE FILTER IT
# FED.** Every caller passed either a tier or "" (any), and with the tiers
# retired only the second reading survives; the signature drops the argument
# rather than keeping a parameter that can only be given one value, because a
# vestigial parameter is a place a later batch re-invents a tier. Its four
# callers — `generate`, `grant_rune`, `_start_rune_pool` and this file's own
# fallback — all passed "".
static func eligible_ids(member: Dictionary, owned_names: Array) -> Array:
	var kit := kit_names(member)
	var out: Array = []
	var data := _load()
	for id in data:
		var e: Dictionary = data[id]
		if String(e.get("retired", "")) != "":
			continue
		if not _scope_ok(e, member):
			continue
		var req := String(e.get("requires_ability", ""))
		if req != "" and not kit.has(req):
			continue
		if owned_names.has(display_name(e)):
			continue
		out.append(id)
	return out


# ══ BATCH FM §2 — WHY AN OFFER CAME BACK EMPTY, ASKED IN ONE PLACE ══════════
#
# **FOUR SITES HAVE TO SAY THE SENTENCE AND THERE IS ONE SENTENCE.** With the
# generated family out of the offer an empty draw is a ruled outcome, and CO
# §3's rule binds it: a refusal with no reason reads as a bug. The reason is
# derived here rather than written four times, so the Peddler, the elite cache,
# the bargain and the event verb cannot drift into telling the player three
# different things about one state.
#
# **AND THERE ARE GENUINELY TWO CAUSES, WHICH IS WHY THIS IS NOT A CONSTANT.**
# Measured at FM §2 over all twelve specs: a hero who has drafted nothing
# reaches **3 to 6** of his spec's authored runes, not all of them — SEVENTEEN
# live entries carry `requires_ability`, and eight of those name a DRAFT card
# rather than core kit. The Pyromancer's Ashfall waits on Funeral Pyre and his
# Chain Fire on Firedraw, so he opens a run able to roll THREE of five. **His
# pool deepens as he EARNS abilities** (`kit_names` reads `bm_abilities`, which
# is where a drafted card AND a boss trophy both land), so "he has seen them
# all" would be a LIE told to a hero with two runes still waiting behind cards.
# The two states get two sentences, and the second one is actionable.
#
# **THE WORD IS "EARNED" AND NOT "DRAFTED", FOR TWO REASONS.** `bm_abilities`
# holds boss trophies as well as drafted cards, so "earned" is the more accurate
# of the two — and `check_fh` §3 asserts the Peddler's screen carries no
# `"draft"`, FD's defect, on a bare SUBSTRING that "drafted" satisfies. The
# needle is coarser than the defect it guards and that is recorded at FM §6
# rather than loosened; the wording here was wrong on its own terms anyway.
#
# The filter chain below is `eligible_ids`' own with the `requires_ability`
# clause INVERTED — the exact complement, so a rune cannot be missing from both
# lists or present in both.
# The member's pouch by display name — the array `eligible_ids` takes as its
# second argument. Four sites built it inline; one is enough.
static func owned_names(member: Dictionary) -> Array:
	var out: Array = []
	for r in member.get("runes", []):
		out.append(String(r["name"]))
	return out


# **THE ONE QUESTION ALL FOUR OFFER SITES ASK BEFORE THEY DRAW.** "Is there a
# rune left for this hero" — the pouch and the kit both read, so it is the same
# test `generate` itself applies rather than a second opinion about it.
static func pool_empty_for(member: Dictionary) -> bool:
	return eligible_ids(member, owned_names(member)).is_empty()


static func locked_by_kit(member: Dictionary) -> Array:
	var kit := kit_names(member)
	var owned := owned_names(member)
	var out: Array = []
	var data := _load()
	for id in data:
		var e: Dictionary = data[id]
		if String(e.get("retired", "")) != "":
			continue
		if not _scope_ok(e, member):
			continue
		if owned.has(display_name(e)):
			continue
		var req := String(e.get("requires_ability", ""))
		if req != "" and not kit.has(req):
			out.append(id)
	return out


# The clause every empty offer site prints after its own em-dash. Kept as a
# CLAUSE rather than a whole sentence because each site frames it differently —
# a merchant has nothing to sell, a cache has nothing to drop — and only the
# reason is shared.
static func empty_offer_reason(member: Dictionary) -> String:
	if not locked_by_kit(member).is_empty():
		return "the runes left for that awakening wait on abilities they have not earned"
	return "they already carry every rune written for that awakening"


# One rune for this member. **BATCH ES §1 — THE DRAW IS FLAT AND THE ZONE SLOT
# NO LONGER CHANGES IT.** Every eligible authored entry goes into one pool and
# one is picked; there is no tier to roll, no pool-of-that-tier to be
# exhausted, and therefore no widening step.
#
# ══ BATCH FM §1 — THE GENERATED FAMILY IS OUT OF THE OFFER, AND `{}` IS WHAT
#    AN EXHAUSTED POOL RETURNS NOW ═══════════════════════════════════════════
#
# **TWO LINES READ THE FAMILY HERE AND BOTH ARE GONE**: the `tpl:` markers that
# were appended into the pool beside the authored ids, and the exhaustion floor
# that returned a stat stick when the pool came back empty. **THIS FUNCTION IS
# THE WHOLE REMOVAL.** The population was DERIVED rather than taken from FD's
# four: `scripts/` holds exactly one `Runes.generate(` and one
# `Runes.template_rune(` in the entire directory, both inside
# `run_state.generate_rune`, which is the single choke point every offer site
# reaches the pool through — so one function closes the Peddler, the elite
# cache, the bargain and the event verb at once, and a fifth site added later
# is closed by construction rather than by a list being kept up to date.
#
# **THE GENERATOR AND ITS ENTRIES ARE KEPT, AND SAID TO BE KEPT** — ET's own
# retirement contract, the one `data/glossary.json` gives Melted Armor.
# `TEMPLATES`, `template_rune` and `_template_markers` all still stand and all
# still resolve. **`_template_markers` HAS NO CALLER TODAY AND THAT IS THE
# POINT**: restoring a floor is these two lines coming back, not a family being
# re-authored. **The one place the family is still reachable is
# `DOD_SIM_RUNES=stats`** — an environment flag no player sets, whose whole
# purpose is to run on exactly this family; see `run_state.generate_rune`.
#
# **AN EMPTY RETURN IS A CONTRACT THAT ALREADY EXISTED.** `generate_rune` has
# returned `{}` under `DOD_SIM_RUNES=off` since Batch X and every call site
# already skips an empty. What FM changes is that the state is REACHABLE IN A
# REAL RUN — a hero who has seen his five draws nothing — so "skips it" stopped
# being good enough and all four sites now SAY so instead (FM §2).
#
# `zone_slot` IS KEPT IN THE SIGNATURE AND IS DELIBERATELY UNREAD. Its four
# call sites pass `Run.zone_idx + 1` and it is the one hook a later batch would
# want if a zone is ever allowed to change an offer again — removing it costs
# four callers and a save-shaped question, and keeping it costs a comment. The
# ruling is that quality is FLAT across the run, and a parameter nothing reads
# cannot break that.
#
# Dedupe against the pouch is by final display name (call-site retry loops keep
# working on top). exclude_names (Batch AI fix): names that are unavailable for
# this draw even though the hero does not own them — in practice, the candidates
# already sitting in the triple being rolled. It rides the SAME channel as the
# owned pouch because it is the same question: a rune already in the offer is
# exactly as unavailable as one already worn. Threading it here makes a
# multi-draw roll a draw WITHOUT REPLACEMENT, which is what the callers always
# wanted; the alternative — roll and retry on a collision — is only
# probabilistically right and fails outright on a small pool.
static func generate(member: Dictionary, _zone_slot: int,
		exclude_names: Array = []) -> Dictionary:
	var owned: Array = []
	for r in member.get("runes", []):
		owned.append(String(r["name"]))
	owned.append_array(exclude_names)
	var pool := eligible_ids(member, owned)
	if pool.is_empty():
		return {}
	return build(String(pool.pick_random()))


# eligible_ids returns authored ids only (never a "tpl:" marker), so this
# filter can read each entry's scope straight off the config.
static func _scoped_ids(ids: Array, scope: String) -> Array:
	var out: Array = []
	for id in ids:
		if String(config(id).get("scope", "")) == scope:
			out.append(id)
	return out


# **BATCH FM §1 — ZERO CALLERS, KEPT ON PURPOSE.** `generate` appended these
# markers into the offer pool and no longer does. It is left standing so that
# restoring a floor is one `append_array` coming back rather than a family being
# re-authored — the same "kept, and said to be kept" contract the retired
# entries in `runes.json` carry.
static func _template_markers(member: Dictionary, owned_names: Array) -> Array:
	var out: Array = []
	for t in TEMPLATES:
		if t["stat"] == "max_resource" and String(member["key"]) == "warrior":
			continue
		if owned_names.has("Rune of %s" % t["noun"]):
			continue
		out.append("tpl:%s" % t["noun"])
	return out


# The generated stat family — DOD_SIM_RUNES=stats runs on exactly this.
# `noun` pins the template (pool draws).
#
# **BATCH FM §1 — `generate` NO LONGER CALLS THIS AND NOTHING IN A REAL RUN
# DOES.** Its one surviving caller is `run_state.generate_rune`'s `"stats"`
# branch, which is an environment-flag sim arm; the `noun` and `exclude_names`
# parameters are unreached from there and are kept for the same reason the
# family is.
#
# **BATCH ES §1 — THE `rarity_key` PARAMETER IS GONE WITH THE TIERS, AND SO IS
# THE ×1/×2/×3 MAGNITUDE LADDER AND THE 60/30/10 ROLL THAT PICKED AMONG THEM.**
# These six were eighteen runes across three grades wearing three prefixes;
# they are six now, at their authored `base` and at TEMPLATE_PRICE — the Common
# grade, unscaled. **THIS IS THE ONLY MAGNITUDE THIS BATCH MOVES AND IT MOVES
# NOTHING AUTHORED**: the ladder was `RARITIES[rk]["mult"]`, so it went with the
# table that held it.
#
# The two-branch shape survives because the exclusion branch is still needed:
# `exclude_names` makes a multi-draw roll a draw WITHOUT REPLACEMENT, and a
# stat stick's name is now its noun alone, so the filter reads the noun
# directly instead of having to roll a tier first to know what the name will be.
static func template_rune(class_key: String, noun := "",
		exclude_names: Array = []) -> Dictionary:
	var pool := TEMPLATES.filter(
		func(t): return not (t["stat"] == "max_resource" and class_key == "warrior"))
	var template: Dictionary
	if exclude_names.is_empty():
		template = pool.pick_random()
	else:
		var open_pool := pool.filter(func(t): return not exclude_names.has(
			"Rune of %s" % t["noun"]))
		# Every noun spent is the exhausted case; six nouns against at most two
		# exclusions means it cannot happen today.
		template = (open_pool if not open_pool.is_empty() else pool).pick_random()
	if noun != "":
		for t in TEMPLATES:
			if t["noun"] == noun:
				template = t
	var value = template["base"]
	var shown: int = int(value * 100) if template["base"] is float else int(value)
	return {
		"id": "tpl_%s" % String(template["noun"]).to_lower(),
		"name": "Rune of %s" % template["noun"],
		"scope_label": SCOPE_INFO["universal"]["label"],
		"scope_color": SCOPE_INFO["universal"]["color"],
		"price": TEMPLATE_PRICE,
		"desc": template["fmt"] % shown,
		"payload": {"stat": {template["stat"]: value}},
		"scope": "universal",
		"lane": "",
		"equipped": false,
	}


# An authored entry as a pouch-ready rune instance (payload int-restored).
#
# **BATCH ES §1/§3 — `rarity`, `rarity_color` AND `scarred` ARE GONE FROM THE
# INSTANCE.** `scope_label` / `scope_color` take the two display slots; the
# payload, the price and the desc are byte-unchanged, so what the rune DOES and
# what it COSTS are exactly what they were.
static func build(id: String) -> Dictionary:
	var e: Dictionary = _load()[id]
	var scope := String(e.get("scope", "universal"))
	var band: Dictionary = SCOPE_INFO[scope_band(scope)]
	return {
		"id": id,
		"name": display_name(e),
		"scope_label": String(band["label"]),
		"scope_color": band["color"],
		"price": int(e["price"]),
		"desc": String(e["desc"]),
		"payload": _typed_payload(e["payload"]),
		"scope": scope,
		"lane": String(e.get("lane", "")),
		"requires_ability": String(e.get("requires_ability", "")),
		"equipped": false,
	}


# ---------- Batch AD: the power probe (DOD_SIM_RUNE_POWER) ----------
#
# A blanket multiplier on the numeric MAGNITUDES of an authored payload,
# for the stage-1 experiment arm only (Run.rune_power gates it on sim_run —
# nothing here reads the environment). It scales the UPSIDE and holds every
# COST at its authored value, deliberately: the arm asks "are the entries
# too weak", and a multiplier that grew the drawbacks in step would answer
# a different question. That makes the arm strictly generous to a rune that
# CHARGES for its upside, which is why it is a probe and not a design.
# (BATCH ES §3: the word for those used to be "scarred". The label is retired
# and this machinery is not — `is_cost` below reads a field and a sign, never a
# label, so every cost is held at its authored value exactly as before.)
#
# A cost is found two ways. Usually it is a NEGATIVE value on an ordinary
# field (-10 Speed, -0.3 healing received, -8% armor). Sometimes it is a
# POSITIVE value on a field where positive IS the cost — PENALTY_FIELDS,
# which exists entirely because of the Glass Rune's dmg_taken_bonus. A
# naive `v * mult` would scale that penalty up and quietly make the rune
# worse the harder the arm pushed.
#
# NOT SCALED, each for a reason worth stating out loud rather than hiding:
#   grant_ability / new_ability — there is no magnitude to scale. Four
#     entries (Comet, Binding Souls, Last Rites, Flayed Mind) are therefore
#     identical in every arm, and the power arm cannot speak for them.
#   "set" fields — absolute assignments (a damage TYPE, a status duration),
#     not magnitudes.
#   ability "cost" / "cooldown" — INVERTED fields, where the benefit is
#     already a negative number. Scaling -5 Rage to -15 makes an ability
#     nearly free and -1 cooldown to -3 makes it negative: that measures
#     "what if abilities were free", not "what if runes were stronger". One
#     rune (Rune of the Quick Spring) is wholly unscaled as a result.
# Fields where a POSITIVE number is the rune's price: "+15% damage taken"
# is a cost even though the term reads +0.15. The Glass Rune is why this
# list exists.
const PENALTY_FIELDS := ["dmg_taken_bonus"]
# Fields that run BACKWARDS — a negative number is the rune's promise, not
# its price. blood_pact shifts the bleedout threshold DOWN from 100 (the
# Rune of Exsanguination's -15 pops enemy veins at 85), so sign alone reads
# its whole benefit as a drawback and holds it: without this list that rune
# is inert in every arm, which is how it was caught (the power arm's
# positive control failed on it).
const INVERTED_STAT_FIELDS := ["blood_pact"]
const INVERTED_AB_FIELDS := ["cost", "cooldown"]


# True when this value is the payload's price rather than its promise. Both
# named lists invert the sign test for the same reason from opposite ends —
# on either, a positive number is what the rune charges you.
static func is_cost(field: String, value: float) -> bool:
	if PENALTY_FIELDS.has(field) or INVERTED_STAT_FIELDS.has(field):
		return value > 0.0
	return value < 0.0


# Type is PRESERVED, not re-derived: by the time a payload reaches here
# _typed_payload has already restored the ints, and pushing a float into a
# typed BattleUnit var is a runtime error, not a rounding (the Batch AA
# trap). An int field therefore scales to a rounded int.
static func _scaled(v, mult: float):
	if v is int:
		return int(round(float(v) * mult))
	return float(v) * mult


static func scale_payload(payload: Dictionary, mult: float) -> Dictionary:
	if is_equal_approx(mult, 1.0):
		return payload
	var out: Dictionary = payload.duplicate(true)
	for field in out.get("stat", {}):
		var v = out["stat"][field]
		if not (v is int or v is float) or is_cost(String(field), float(v)):
			continue
		out["stat"][field] = _scaled(v, mult)
	for field in out.get("add", {}):
		var av = out["add"][field]
		if not (av is int or av is float) or INVERTED_AB_FIELDS.has(field):
			continue
		if float(av) < 0.0:
			continue  # a negative add on a normal field is a cost
		out["add"][field] = _scaled(av, mult)
	return out


static func _typed_payload(p: Dictionary) -> Dictionary:
	var out: Dictionary = p.duplicate(true)
	if out.has("stat"):
		for field in out["stat"]:
			var v = out["stat"][field]
			if v is float and (STAT_INT_KEYS.has(field)
					or String(field).ends_with("_ranks")):
				out["stat"][field] = int(v)
	if out.has("ability"):
		for part in ["add", "set"]:
			for field in out.get(part, {}):
				if AB_INT_KEYS.has(field) and out[part][field] is float:
					out[part][field] = int(out[part][field])
		if out.has("status_turns"):
			out["status_turns"] = int(out["status_turns"])
	if out.has("new_ability"):
		var d: Dictionary = out["new_ability"]
		for field in AB_INT_KEYS:
			if d.has(field):
				d[field] = int(d[field])
		if d.has("applies_status") and d["applies_status"].has("turns"):
			d["applies_status"]["turns"] = int(d["applies_status"]["turns"])
		if str(d.get("target", "")) == "ally":
			d["target"] = Ability.Target.ALLY
	return out
