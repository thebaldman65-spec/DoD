# An Ability is one action a unit can take in battle.
# Kept as plain data so classes/talents can later be loaded from files.
class_name Ability
extends RefCounted

enum Target { ENEMY, ALLY }

var display_name := ""
var cost := 0            # class resource cost (Rage, Mana...)
var damage := 0          # PERCENT of the user's current Attack (100 = a full
                         # Attack-stat hit) before variance/crit/armor
var pressure := 0        # Pressure applied to the target on hit
var heal := 0            # if > 0 this is a healing ability
var delay := 2.0         # initiative delay added after use (basic = 2)
var target := Target.ENEMY
var anim := "attack01"
var resource_gain := 0   # resource generated on use (e.g. basic attacks build Rage)
var delay_push := 0.0    # pushes the target's next turn back
var recoil_base := 0.0   # self-damage: this fraction of the total damage dealt
var aoe := false         # hits every living enemy (no miss/parry rolls)
var random_hits := 0     # strikes this many random living enemies instead
var multi_hits := 0      # strikes the SAME target this many times
var perfect_extra_hit := true  # multi/random-hit attacks: Perfect adds one hit
# BATCH CM §1 — a SLOPPY grade loses the cast outright: no damage, no status,
# no consumption, and the turn is spent. Good and Perfect both resolve
# normally. Read at the CALL SITE (battle._hero_turn), never inside the
# grader — `_grade_skill_check()` takes no arguments and must not learn which
# ability it is grading. NO HEALING OR REVIVAL ABILITY IS EVER GATED.
var gated := false             # Sloppy = the cast does not resolve (Batch CM)
var choose_two := false        # the player picks TWO enemy targets (Shrapnel)
var choose_three := false      # the player picks THREE enemy targets (Hex)
var faith_cost := 0      # secondary-resource cost (Mercy for the Holy Cleric)
var heal_missing := 0.0  # attacker self-heals this fraction of their missing HP on hit
var armor_pierce := 0.0  # ignores this fraction of the target's armor
var lifesteal := 0.0     # attacker heals this fraction of damage dealt
var dmg_type := "physical"  # arcane/nature/shadow/holy/physical/fire/frost
var bleed_build := 0     # Bleed buildup added on hit (bleedout at 100)
var bleed_chance := 1.0  # probability each hit adds its bleed_build
var applies_status := {} # status applied on hit, e.g. {"id": "slow", "turns": 2}
var status_chance := 1.0 # probability the status lands (1.0 = always)
var perfect_id := ""     # unique bonus effect on a Perfect skill check
var perfect_text := ""   # tooltip text for the perfect bonus
var special := ""        # non-attack effect: rally, barrier, focus, surge, purge, renewal
var cooldown := 0        # turns before this ability can be used again (0 = none)
var description := ""


# ================== BATCH CY §1 — A BUFF COSTS HALF A SWING ==================
#
# **A PURE BUFF'S INITIATIVE DELAY IS CAPPED AT HALF THE BASIC ATTACK'S.** The
# design statement is *setting up costs less tempo than swinging*, which is why
# the cap is written against `BASIC_DELAY` rather than as the 1.0 it evaluates
# to today: retune the baseline and the rule stays true instead of silently
# becoming a different rule.
#
# WHY IT EXISTS. Playtesting found that the ramp specs cannot ramp inside the
# fights the game actually has, and §0 measured the reason: a fight resolves in
# **three to five turns per hero** — trash 3.5/3.8/4.1 rounds at the three
# difficulty rungs, and elite fights are the SHORTEST of the three kinds. A turn
# spent setting up is a quarter to a third of the whole fight, so the setup
# never returns its cost and Blood Frenzy, Faith and their neighbours play as if
# their engines were not there.
#
# WHAT IT IS NOT. The buff is not free and does not stack onto another action:
# it still costs its resource, its cooldown and half a swing. A free buff would
# make every buff strictly correct to cast and would delete the decision across
# the entire category — and Anvil, Formless, Discipline, Unslaked and Spite were
# all priced as turns you spend.
#
# **HALF IS THE DESIGNER'S FIRST GUESS AND IS FLAGGED, NOT TUNED.** It ships as
# written; `check_cy.gd` prints the resulting table.
const BASIC_DELAY := 2.0
const BUFF_DELAY_CAP := BASIC_DELAY * 0.5

# ---------- WHICH ABILITIES ARE PURE BUFFS ----------
#
# **DERIVED BY WALKING `battle._resolve_special`'S CALL GRAPH, NOT BY READING
# `damage` AND `pressure`.** Those two fields are ZERO on 137 of the 216
# abilities in the corpus, including Feint, Guard Change and Kill Command, which
# hit hard from inside their handlers — a field test would have halved the price
# of every one of them. CN paid for that lesson on the timing bar and CO paid
# for it again on the recast refusal; this is the third table derived the same
# way, and `check_cy.gd` re-walks it live so it cannot rot.
#
# THE CRITERION, STATED SO A LATER BATCH CAN APPLY IT RATHER THAN GUESS AT IT:
#
#   A PURE BUFF is an ability whose ENTIRE cast-time payload is one or more
#   statuses (or status-backed flags) written to the CASTER or to LIVING ALLIES.
#   At cast it deals no damage and no Break damage, heals nobody, moves no
#   resource, no Pressure, no cooldown and no initiative, summons and revives
#   nobody, strips nothing, and writes NOTHING AT ALL to any enemy.
#
# CAST TIME IS THE WHOLE OF IT, because the delay is paid at cast. What the
# status goes on to do afterwards — Venom Coating poisoning every later hit,
# Tripwire springing on an enemy's turn, Arcane Arrows striking a second body —
# is what the buff IS, not a second payload. The alternative reading would put
# half this list outside the rule for doing its job.
#
# §1'S FOUR EXCLUDED POPULATIONS, each reported by `check_cy.gd` and each
# CHANGED IN NO WAY:
#
#   · ANYTHING WITH A SECOND PAYLOAD. Battle Shout and Hold the Line hand back
#     Rage, Stabilize vents Resonance and heals, Blink eats cooldowns,
#     Preparation buys a turn, Elevation and Ordination grant Faith, Hold
#     Breath and Quarry's Mark grant Focus, Dispel and Unburden strip effects.
#     Its delay is priced for the whole thing.
#   · HEALS. "A heal is a response to what just happened, not setup." The answer
#     to *is this card a heal* is `HEAL_SPECIALS` plus the `heal` fields — the
#     question was authored once, in CN §2, and asking it a second way here is
#     how two answers start disagreeing.
#   · SHIELDS. Divine Shield, Magic Barrier, Mantle, Interpose, Mirror Image and
#     Vespers. Adjacent to buffs and arguably the same case, so they go to the
#     designer as a list. The line is mechanical: a shield is a CONSUMABLE
#     absorb pool or charge count that eats incoming attacks. Percentage
#     mitigation running for N turns is not one — it has no pool — which is why
#     Immolate, Ironclad, Camouflage and Consecrated Ground are buffs and those
#     six are not.
#   · ENEMY ABILITIES, and anything that writes to an enemy at all. This is a
#     hero tempo problem.
#
# TWO JUDGEMENT CALLS ARE RECORDED RATHER THAN BURIED, because they are the
# designer's to overturn:
#   · THE DEATH-SAVES ARE IN — Rite of Return, Bloodbond, Intercession, Ashes of
#     Al'ar and Undying Vigil. Each is armed BEFORE the blow it answers, which is
#     setup by every test §1 states, and none of them is an absorb pool. If the
#     designer rules them shields they leave as one group.
#   · THE HEAL-OVER-TIME BUFFS ARE IN — Consecration, Aegis Wall and Battle
#     Trance heal through a status they set. `HEAL_SPECIALS` says none of them is
#     a heal card, and none heals a point at cast, so the authored answer stands.
const PURE_BUFFS := ["aegis_wall", "alms", "anointing", "answering_steel",
	"anvil", "arcane_arrows", "ashes", "battle_poise", "battle_trance",
	"berserk", "bloodbond", "camouflage", "cons_ground", "consecration",
	"covering_guard", "deadfall", "discipline", "divine_presence",
	"divine_wrath", "downwind", "emberkeep", "exhortation", "fault_line",
	"feigned_guard", "formless", "ghostpack", "hoarfrost_armor", "immolate",
	"instinct", "intercession", "ironclad", "last_howl", "mana_shield",
	"mana_well", "null_field", "quickdraw", "recompense", "resonant_field",
	"retaliate", "rite_of_return", "shield_block", "spite", "stalking_horse",
	"succession", "tripwire", "turn_the_blade", "undying_vigil", "unity",
	"unslaked", "venom_coat", "vow_suffering", "warcry"]


# TRUE when §1's cap binds this ability.
func is_pure_buff() -> bool:
	return special in PURE_BUFFS


# ---------- BATCH CN §2 — WHICH ABILITIES RUN A TIMING BAR ----------
#
# THE CRITERION IS MECHANICAL, NOT CATEGORICAL: the check comes off wherever the
# grade multiplier has nothing to multiply. A pure buff has no damage and no
# Break damage, so ×1.15 and ×0.6 both resolve to nothing and the bar's only
# live effect is the Perfect bonus — consequence-free upside charged as an
# attention tax on a turn that was never in doubt.
#
# THE FIELDS ARE NOT ENOUGH ON THEIR OWN, and finding that out is most of what
# §2 cost. Roughly half the corpus does its real work inside a `special`
# handler, so `damage: 0, pressure: 0` is TRUE of Feint, Guard Change, Kill
# Command and twenty others that hit somebody hard. A field-only test would have
# stripped the bar off those, which is the exact opposite of what the criterion
# says. The two tables below name the handlers that resolve something for the
# grade to move; they were derived by walking `battle._resolve_special`'s call
# graph to its damage and healing leaves, and `check_cn.gd` re-walks it so the
# tables cannot rot as handlers change.
#
# ONLY THE BASE EFFECT COUNTS. A handler whose ONLY damage sits inside its
# `if is_perfect` branch is caught, because that branch is the orphaned bonus
# §3 folds in rather than a reason to keep grading. BEWITCH is the whole of
# that case: its strike was Perfect-only, so it loses its bar.
# BATCH CR §2 — AND THE STRIKE IS REMOVED RATHER THAN FOLDED. Losing the bar is
# still correct (there is no base damage for a grade to multiply), but folding
# the strike in gave the card a free extra enemy attack with no gate on it. The
# criterion decides whether an ability GRADES; it does not decide what an
# orphaned bonus becomes, and those are two questions.
const DAMAGE_SPECIALS := ["blood_tribute", "breaking_darkness", "call_wild",
	"call_wilds", "cinderfall", "cull", "feint", "guard_change", "gut_rip",
	"harvest", "kill_command", "killing_frost", "precision_strike",
	"primal_surge", "pyre_wake", "reprisal", "requiem", "savage_sweep",
	"shield_slam", "suffering", "twin_hunt", "unleash", "wildfire",
	"winters_toll"]

# §2'S HEAL OVERRIDE, AND IT IS AN AUTHORED LIST BECAUSE IT IS A DESIGNER CALL
# RATHER THAN A CONSEQUENCE. A heal's magnitude IS multiplied by the grade, so
# heals keep their bar — but "is this a heal" cannot be read off the leaves
# alone: RENEWAL's healing is a status it applies, so nothing heals at cast
# time and a purely mechanical read would have taken its bar away while HEAL
# next to it kept one. The list is the answer to "is this ability a heal",
# which is a question about the card.
#
# WHAT IS DELIBERATELY NOT IN IT: BULWARK OF FORTITUDE and FORTIFIED SPIRIT's
# neighbours in the mitigation family, and STABILIZE. Bulwark's ten percent a
# turn rides a status whose point is armor and Break immunity — it is a shield,
# and §2 says shields lose theirs. Stabilize pays Mana and damage reduction and
# healed only on a Perfect.
const HEAL_SPECIALS := ["dark_pact", "dawnbreak", "divine_plea",
	"field_dressing", "fortified_spirit", "healing_wave", "holy_heal", "hymn",
	"jubilee", "ministration", "renewal", "reliquary", "sanctuary",
	"second_wind_holy", "spirit_bond", "totem_pulse", "wild_growth"]


# TRUE when this ability still puts a bar on screen.
#
# BATCH CQ §5 — `no_skill_check` IS GONE AND THIS FUNCTION IS THE ONLY ANSWER.
# The field was a SECOND way to ask the same question, and two answers is how
# they disagree silently: on DEADFALL the flag said "runs a bar" (it was never
# set) while the criterion had already taken the bar away, and `test_batch_ah`
# passed by reading the flag — the right answer from the wrong oracle.
#
# DELETING IT WAS NOT FREE AND THE PRICE IS RECORDED HERE. The flag was
# load-bearing on FOUR of its thirteen carriers, where the criterion would
# have handed back a bar the game does not draw today:
#
#   · SUMMON AGUILA / CANIS / URSUS — the table was simply WRONG. `_do_summon`
#     is 139 lines and reaches no damage leaf at all: a summon puts a beast on
#     the field and the beast strikes on ITS OWN later turns. `"summon"` is
#     struck from DAMAGE_SPECIALS above, which is a correction to a derived
#     table rather than a change to a card, and all three keep resolving
#     silently for the criterion's own reason.
#
#   · CALL OF THE WILD is the one real disagreement, and it is NOT this
#     batch's to settle. It DOES deal damage at cast — `_companion_strike`
#     for each beast standing, `_ghost_hit` for each absent one — so the
#     criterion says it earns a bar, while the flag has always said it does
#     not, alongside every other beast-command card in its family. Handing it
#     a timing bar is a design change and goes to the designer as a report.
#     Until he answers, the exception is NAMED HERE rather than hidden in a
#     data field, so there is still exactly one place that knows.
const NO_BAR_BY_DESIGN := ["call_wild"]

# A GATED ABILITY ALWAYS KEEPS ITS BAR, and this clause is the one addition §2
# did not ask for. Batch CM's RECKLESS ABANDON has no damage and no Break damage
# — it spends the whole Rage bar for a three-turn multiplier — so the criterion
# catches it cleanly, and obeying the criterion there would have deleted a CM
# feature in silence: an ability whose Sloppy loses the cast cannot lose the
# check that produces the Sloppy. The gate is the largest thing a grade moves
# anywhere in the game, which makes this the criterion's own logic rather than
# an exception to it.
func runs_skill_check() -> bool:
	if special in NO_BAR_BY_DESIGN:
		return false
	if gated:
		return true
	if damage > 0 or pressure > 0 or heal > 0 or heal_missing > 0.0:
		return true
	return special in DAMAGE_SPECIALS or special in HEAL_SPECIALS


static func make(d: Dictionary):
	var a = new()
	for key in d:
		a.set(key, d[key])
	# BATCH CY §1 — THE CAP, AT THE ONE PLACE AN ABILITY IS EVER BUILT. Every
	# definition in the game reaches this function, so there is exactly one
	# answer to "what does this buff cost" and every reader — the draft card,
	# the tooltip, the timeline preview, the cast itself — gets the same one.
	#
	# THE AUTHORED DEFINITIONS ARE ALREADY AT THE CAP, so this clamp is a no-op
	# on today's data and `check_cy.gd` asserts that it is. It is not redundant:
	# it is what makes the rule true for content a later batch adds, including
	# content added by somebody who has not read this file.
	if a.special in PURE_BUFFS:
		a.delay = minf(a.delay, BUFF_DELAY_CAP)
	return a
