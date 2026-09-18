# Dawn of Decay — COMBAT RULES

**THE FILE A BATCH IS REQUIRED TO READ IS `CLAUDE.md`, AT THE REPO ROOT. THIS FILE IS A REFERENCE
IT POINTS AT, OPENED WHEN A BATCH CHANGES HOW A FIGHT RESOLVES.** It holds the standing rules about
the fight's own machinery — the damage door and the attribution frame, the status door and what a
status carries, the crit roll, a multi-hit's charges, the collections a loop walks and the enemy's
declared turn — **and no rule that is also about a card, a rune, an engine, a talent, the ladder or
the run.** Those stayed in `CLAUDE.md`, where a batch that never opens this file still meets them.

**THE SEAM IS WHAT A RULE IS ABOUT (SET AT GR §2, RULED BY THE DESIGNER).** EF and FF split
`CLAUDE.md` by what a rule BINDS and sent the instrument rules to `docs/instrument-rules.md`; that
test kept every rule about the game in the required read, and FF measured that it had no third seam
of its kind. This file is the subject seam FU §1 named. **Its tiebreak is the old one's surviving half:
a rule that belongs to two subjects stays in `CLAUDE.md`.** A rule about how a batch verifies itself
is in `docs/instrument-rules.md`, whatever it is about.

The two halves were asserted to rejoin byte for byte against the pre-split `CLAUDE.md`, beside a
heading partition, before either was trusted — **never by comparing sizes** — and the proof is in
`docs/reports/GR.md` §4. **Every block below is byte-identical to what stood in `CLAUDE.md`**, in
the order it stood there, and `CLAUDE.md` indexes each by heading.

**WHEN A RULE MOVES BACK OR ACROSS, THE PIN MOVES WITH IT IN THE SAME BATCH.** None of the nine
carried a pin when it moved — measured against the pin manifest and a sweep of every suite and gate
before a byte moved. `build_pin_manifest.py`, `check_ec`, `check_ea` §3 and `check_fr` §2 treat this
file as a rule file, so a pin written against it is inside the instruments' territory, and `check_ff`
§5 asserts that every heading here has one row in `CLAUDE.md`'s index and that no rule stands in
both files.

**THIS FILE IS UNDER THE SAME CEILING PROCEDURE AS `CLAUDE.md` AND HAS NO STATED CEILING.** Deriving
one is a ruling; the arithmetic is in `docs/reports/GR.md` §5. **Do not state this file's live size
in this file.**

---

## THE CLAMPED CALL SITES, AND WHY `update_status` IS NOT CLAMPED (STANDING, SET AT CP §0)
**`update_status` ASSIGNS power where `add_status` MAXES it.** On the three sites whose power is
computed from LIVE STATE, that let a weaker recast overwrite a standing buff DOWNWARD — worse than
the waste CO's refusal was written to fix, and unreachable by that refusal because all three carry
a second payload.
- **THE CLAMP IS AT THE CALL SITE: Battle Shout, Stabilize, Eye of the Storm, and since CQ Blood
  Debt and Reckless Abandon.** Each
  reads `status_power` BEFORE `_apply_status` and writes the chip only when the new value is at
  least as strong. `status_power` returns **-1** when nothing stands, so a fresh cast always
  writes. **THE CAST STILL PAYS** — the +5 Rage, the Mana and 5% heal, and the taunts all sit
  OUTSIDE the guarded branch, which is the whole reason the fix belongs here and not in the gate.
- **DO NOT CLAMP `update_status` GLOBALLY, AND TWO SITES SETTLE IT ALONE.** `held_breath` and
  `instinct` compute `status_power(...) - 1` and write it back — they are COUNTDOWNS, and a global
  `maxi` freezes them at their opening value forever, so neither is ever spent. Six more banks
  decrement through the same door: `mirror`, `arrows`, `feint_guard`, `berserk`, `deadfall`,
  `loyalty`. **Nothing would crash and nothing would log.**
- **THE CENSUS IS IN CP's CHANGELOG ENTRY (IN `DoD-archive/changelog-archive.html` SINCE THE CUT)
  AND IS THE ARTEFACT TO READ BEFORE TOUCHING THIS**: 69
  call sites, 42 passing a power, and 29 of them calling `_apply_status` then `update_status` on
  one status (the shape that can downgrade). **`spite` is the trap in that list** — it passes a
  CAP as the power while its chip text carries the live figure, so a naive "never write a smaller
  number" rule would be WRONG there.
- **FIXED AT CQ — TWO MORE SITES HAD THE IDENTICAL DEFECT:** `blood_debt` (35 on a
  perfect, 25 otherwise, so a non-perfect re-mark dropped the standing share) and
  `reckless_abandon` (scales with Rage spent, and the cast ZEROES the bar, so a second cast in its
  own window is necessarily smaller — CM gates it below one full step, not below the standing
  value). Both took the same three-line clamp; CP had scoped itself to the three CO recorded.

## HARD CONTROL LANDS ON A BOSS ONLY ONCE IT IS BROKEN (STANDING, SET AT BATCH CR §1)
> **Hard control lands on a boss only once that boss is BROKEN. Never before.**

**THE CHECK ALREADY EXISTED AND THERE IS STILL ONLY ONE OF IT.** `_apply_status` refuses
`stunned`, `frozen`, `psychosis`, `bewitch` and `hysteria` on `target.is_boss and not
target.broken` — the same `broken` the Occultist's Madness lane rests on. **A SECOND CHECK MUST
NOT BE WRITTEN**; an ability obeys this rule by not passing `force`.
- **WHY IT HAD TO BE RE-RULED.** Flash Freeze and Snare Trap bought the boss carve-out with their
  PERFECTS. CN took the bar off both, their Perfect became their base, and **boss immunity to
  hard control silently ceased to exist** — the Occultist's whole gate rests on Broken meaning
  something. Neither could be restored to its old condition, because **"only on a Perfect" is not
  expressible on an ability with no bar.** So the gate moved to the mechanic that already exists.
  **THIS IS BETTER THAN THE PRE-FOLD BEHAVIOUR, NOT A RESTORATION OF IT: a bypass earned through
  play rather than through timing.**
- **`force` HAS EXACTLY ONE CALLER NOW AND IT IS POMMEL STRIKE.** That card KEPT its bar (25
  damage, so `runs_skill_check()` is true), so "only on a Perfect" is still expressible there and
  its perfect still lands the Stun on an unbroken boss. **REPORTED AND DELIBERATELY NOT CHANGED
  AT CR** — it is the one ability left applying hard control to a boss on a condition other than
  Broken, and whether it joins the rule is a designer's call, not a batch's.
- **`_spring_trap`'s `force_stun` PARAMETER SURVIVES WITH NO CALLER PASSING TRUE.** Left in place
  rather than removed (a shared helper's signature is adjacent scope), but **a future caller
  passing `true` is re-opening the door this rule closed.**
- **THE CONFORMING SET, CENSUSED AT CR AND WORTH NOT RE-DERIVING:** Mind Flay (`psychosis`),
  Bewitch, Mass Hysteria, Glacial Prison and Cryoclasm (both through `_hold_freeze` with no
  force), Spread of Madness (which filters `not e.is_boss or e.broken` itself) and Ricochet's
  stagger all already gate on Broken. **Flash Freeze and Snare Trap were the only two that did
  not.**

## STANDING REFERENCE — ENEMY INTENT: ONE DECLARED-ACTION STORE, THREE RE-VALIDATION BRANCHES (Batch BL §1)
**DECLARE ON SCHEDULE, RESOLVE ON TURN.** `_choose_enemy_action` is the SELECTION half lifted out
of `_enemy_turn` **byte-for-byte** — only *when* it runs moved, and a diff touching the rules
inside it breaks that promise.
· **Declaration**: `_declare_intent(u)`, called from `_declare_all_intents()` at battle start
  (after the opening oath/Faith hooks, which move state the policy reads), from the turn loop
  **right after** `await _enemy_turn(u)` — **NOT from the bottom of `_enemy_turn`**, which has
  eight returns, and a declaration owed on all of them is a declaration owed by the caller — on
  each lost-turn branch after the discard, and in `_hold_release`.
· **Re-validation** at resolution, `_revalidate_intent(u)`, in this fixed order: (1) ability
  unusable → fall back to `_cheapest_attack` **AND LOG IT** (a silent substitution is the intent
  system lying); (2) target gone → **re-target within the SAME ability**. A unit that cannot act
  never reaches it: each lost-turn branch calls `_discard_intent`, **DISCARDED NOT BANKED**. **READ THE TARGET UNTYPED FIRST** — a declared
  companion can be `queue_free`d between declaration and resolution, and a typed assignment of a
  freed instance errors BEFORE `is_instance_valid` can run.
· **A FOURTH counter, deliberately not one of the three**: `intent_hijacked` — Hysteria, Bewitch
  and Psychosis take the turn, so the unit ACTS but not as declared. Counted at the moment each
  branch COMMITS, never on the status alone.
· **THE `charging` STATUS IS THE SAME MECHANISM, NOT A SECOND ONE.** The wind-up stores its blow
  in `intent` like everything else. `_declare_intent` returns early on `has_status("charging")` —
  that ONE line is why a charging enemy declares once, not twice. **A later batch wanting a
  multi-turn declaration sets `intent.turns` and adds a chip. IT DOES NOT ADD A SECOND STORE.**
· **Counters go through `_istat`, NOT `_stat`** — unconditional, not sim-gated, because the
  re-validation rates are a property of the MECHANISM and must be observable in real play.
· **Categories are DATA-DRIVEN** (`_intent_category`): windup → mend → ally-target → aoe →
  `pressure > damage` → applies-status-and-not-this-unit's-hardest-hit → strike. **Order IS the
  classification**, so an enemy added to `enemies.json` classifies itself and there is no name
  table.
**NO PREDICTED DAMAGE NUMBER MAY SHIP, AND THAT IS A FINDING RATHER THAN AN OMISSION.** The strike
block fails on two counts, either fatal alone: it MUTATES on the way through (`crit_streak`,
resource restores, `float_text`, three ledgers), and its FIRST line is `randf_range(0.9, 1.1)`
with a crit rolling inside it — **the same call with identical inputs returns a different
number.** Icon plus the ability's own name is shown instead, read off the declaration so it cannot
drift. **`test_batch_bl` greps the intent block for `attacker.attack` / `effective_armor` /
`randf_range` / `resists.get` and fails if a later batch adds a preview by reimplementing the
maths.**
· **HIDDEN INTENT IS FLAGGED, NOT BUILT** — a good mechanic and a DIFFERENT one; author it once
  the baseline is legible.
· **STATE-SENSITIVE POLICIES NOW READ THE BOARD ONE TURN EARLIER**, reported and corrected
  nowhere: `_enemy_support_action`'s thresholds, the Broken-hero exploit (the most sensitive — a
  Break window is short and a declaration made before it opens will not take it), `_lowest_hp` /
  `_threat_pick`, the taunt narrowing and the presence rolls. **Selection logic itself is
  untouched; an AI rewrite is out of scope.**

## STANDING REFERENCE — THE RECAP LEDGERS AND THEIR BOUND (Batch BL §2)
**DAMAGE TAKEN HANGS OFF ONE DOOR: `BattleUnit.damage_taken_cb`**, fired by `_report_taken` from
`take_hit` and `take_tick_damage`. It reports the **DELTA,
not the argument** (a 52 into a hero on 40 is 40 taken, or the column disagrees with the health
bar) and sits **BELOW ALL FOUR DEATH-REFUSALS** — above them it would count health handed straight
back AND file a refused death as a killing blow. **Five `_resolve_special` branches remove a
hero's own health directly** (`phoenix`, `dark_pact`, `blood_offering`, `blood_price`,
`shared_grief`) — a price paid, not a wound dealt, so none may feed an on-damage rider — **and each
books the delta through `_book_self_cost`, which reaches the recap's ledger and nothing else (GF).**
A new damage source goes through one of the two functions; a new direct cost calls
`_book_self_cost`. Anything else reports nothing.
· **ATTRIBUTION IS A FRAME**, `_dmg_frame(src, label, src_name)`, set at **`_resolve`'s entry** —
  one site covering the strike, its splash, echoes, the reflect/retaliation it draws and the
  recoil it costs — **re-established after each nested `await _resolve`** (a counter leaves the
  frame pointing at itself) and set explicitly at the DoT tick loop, from the status's `src_name`,
  because the applier may be dead. **SELF-INFLICTED IS DECIDED BY IDENTITY** (`victim ==
  _dmg_src`), which covers recoil and any self-cost that passes the door in one rule and cannot go
  stale the way a name list would; the five direct costs reach it through `_book_self_cost`, which
  frames the payer and the card around the one booking and restores the frame it found.
· **BY KIND, NEVER BY INSTANCE** — `_taken_source` reads `BattleUnit.enemy_kind`, stamped AFTER
  the "boss" alias resolves. `unit_name` happens to agree today; keying on that agreement would
  make the aggregation an accident the first uniquely-named enemy breaks.
· **THE BOUND: `TALLY_KEYS_PER_HERO = 24` rows per hero per map, INCLUDING the `(other)` row**;
  `TALLY_KILLS_MAX = 12`, oldest kept. **Overflow FOLDS into `(other)` rather than being
  dropped** — the total stays exact and only the breakdown gets coarser, which is the right way
  round when the panel reports a top five.
· **Banked by `_bank_run_ledgers()`**, from `_check_end`'s run branch AND from `_do_forfeit` (a
  forfeit never reaches `_check_end`, and the abandoned fight is exactly what the tester wants
  explained). **Idempotent** — it clears the slices as it banks.
· Renderer `_append_breakdown(...)` is written ONCE and called TWICE (whole run, final battle);
  everything goes into the SAME line list `_summary_plain_text` walks, so the Copy button stays
  complete. **Not a defeat-only screen** — wipes, forfeits and completions all get it.
## STANDING RULE — CRIT CHANCE ABOVE A CERTAINTY BECOMES CRIT MULTIPLIER (Batch EW; rate ruled at EX)

> **A total crit chance over 100% cannot make a hit more certain, so the surplus is paid as
> critical DAMAGE instead — from every source, game-wide, at `battle.CRIT_EXCESS_STEP`.**
> **It converts the ASSEMBLED TOTAL and never a single source**, because the ceiling belongs to no
> one term.

**THIS IS NOT FOCUS'S CONVERSION AND MUST NOT BE FOLDED INTO IT.** Focus converts at a DEPTH IN ONE
METER (`unit.focus_convert`, still 100, still `FOCUS_STEP`); this converts a TOTAL assembled over
twelve statements, carrying thirteen terms. **A hero at 80 Focus is below his own split point, is still contributing +40% crit
chance, and can be past 100% TOTAL once a Broken target and a talent are added — both conversions
fire on that blow and nothing is counted twice**, because the sub-split Focus is inside
`crit_chance` and was never paid as multiplier.

- **THE ROLL HAPPENS AT FOUR SITES AND THE BRIEF ASSUMED ONE. THIS IS THE THING TO KNOW BEFORE
  TOUCHING CRIT.** `_resolve`'s strike loop is the only one that assembles more than three terms;
  `_ghost_hit` and `_companion_hit` each assemble the base rate, `crit_bonus` and a Broken
  target's 25%, `_heal_crit_mult` the first two of those, and all three **wear none of the strike loop's other terms** — measured over
  202,000 crit rolls at three loadouts, the deepest any of the three reached was **0.37**. **So the
  RULE has one body and the four rolls spend it.** A fifth roll that forgets the call is the defect
  `check_ew` §0 exists for, and it is derived rather than listed: a crit roll is a `randf() <`
  against a NAMED variable whose declaration carries `CRIT_CHANCE`.
- **THE CHANCE MUST BE NAMED AT EVERY ROLL SITE, AND THAT IS A PROPERTY RATHER THAN A STYLE.** A
  roll comparing against an inline expression cannot hand the SAME value to the conversion — it
  would have to recompute it, which is a second copy of the assembly, which is the drift
  `_bot_boon_worth` already cost this project once.
- **THE RATE IS `CRIT_EXCESS_STEP` AND IT WAS RULED AT EX: 1.0 → 0.50.** EW shipped it at Focus's
  own exchange rate (0.005 of chance below the split for 0.005 of multiplier above it, so one for
  one) and flagged it rather than tuning it. **The designer ruled 0.50, and the reasoning is
  recorded so the priced alternative is not re-proposed later as a discovery:** 1.0 is a rate tuned
  for ONE meter that one spec builds on one target, and this constant prices a total assembled over
  **twelve statements — thirteen terms** — and fed by the whole party. Nothing has ever tested that
  those two answers should be the same number. **It is still deliberately NOT written as a
  derivation from `FOCUS_STEP`**: a derivation would assert they must stay equal, and one line is
  what makes this constant movable. `docs/reports/EX.md` §1.
- **THE MEAN IS NOT WHERE THIS LIVES — PRICE IT ON THE TAIL.** At 0.50 and a fully-talented loadout
  the party's crit output rises about **+1.2%** live (±0.11 floor); at rows 1–3 and rows 0 the
  conversion is **below the noise floor and the arms cannot see it**. **But the blows that do land
  past a certainty go from ×1.5 to a mean ×2.5** — and the term feeding that tail (Aguila's boon on
  an uncapped Loyalty meter) has no ceiling anywhere. **A rate chosen off the party mean is a rate
  chosen at the wrong statistic.**
- **AND THE WORST-BLOW FIGURE IS A SAMPLE MAXIMUM, SO IT DOES NOT CONVERGE — DO NOT QUOTE ONE AS A
  BOUND.** Four independent rows-1–9 arms read worst totals of **7.20 / 11.12 / 12.24 / 18.09**,
  a 2.5× spread, because the term feeding them is unbounded. **The stable figures are the RATIO
  (0.50 buys exactly half of 1.00, at every arm) and the aggregate band.** EX §1c.
- **ROWS 0 IS A NEAR-ZERO, NOT A STRUCTURAL ZERO, AND EW's REPORT SAYS OTHERWISE.** The conversion
  **can** fire with no talents equipped: measured **2 crossings in 40,437 hero strikes**, totals to
  **1.09**, with 208 strikes at or past 0.50. **`_party_crit_bonus()` is gated on
  `has_engine("pack")` and NOTHING ELSE** — no talent, no row — so Aguila's boon on an uncapped
  meter reaches a certainty at rows 0. It is still a sound noise floor (the crossings move that
  arm's mean by +0.0002% against a ±0.11% floor), **but it is a rare event and must not be asserted
  as impossible.** EX §2.
- **IT CANNOT REACH AN ENEMY, AND THAT IS STRUCTURAL.** `_party_crit_bonus()` is hero-gated at its
  read site; `crit_bonus` is written on the HERO spawn path and inherited only by a companion (its
  one other writer, `dulledge`, SUBTRACTS); every remaining term is a talent counter and an enemy is
  allocated no tree. **Measured: 69,932 enemy crit rolls, deepest total 0.3500, none at a
  certainty.** A future enemy ability that raised one would need this checked again.
- **THE ROLL IS DELIBERATELY NOT CLAMPED.** `randf()` returns [0,1), so `randf() < 1.93` and
  `randf() < minf(1.93, 1.0)` are the same blow. A `minf` there would change no behaviour and would
  add a SECOND place the ceiling is written down, which is the drift this rule exists to avoid.
- **ONE DISPLAY SURFACE SHOWS A PARTIAL CRIT TOTAL AND IT IS NOT A ROLL.**
  `party_screen`'s hero card prints the base rate (spelled as a literal) plus `crit_bonus`; three
  `battle.gd` sites spend `CRIT_CHANCE + crit_bonus` as a BURN MAGNITUDE rather than as a chance. **None can know the assembled
  total** — it depends on the ability, the target and the board — so none was changed, and a sweep
  for "places that read `CRIT_CHANCE`" must not mistake any of the four for a roll site.

## STANDING RULE — CHARGES AND ON-HIT EFFECTS COUNT HITS, NOT CASTS (Batch BR §1)
**A multi-hit ability spends one charge PER HIT and fires its on-hit effects PER HIT.** Aimed
Volley is three shots; under Arcane Arrows it spends **three** of its charges and forks **three**
times. Magic Missiles and Called Volley behave the same way. **This is a real power increase for
multi-hit abilities and it is deliberate — it is what makes a multi-hit kit and a charge bank a
BUILD rather than a coincidence.** A strike that MISSED or was BLOCKED spends nothing, and neither
does one an absolute parry zeroed: a charge rides a blow that landed.
· **WHERE IT LIVES**: `_arcane_arrow_splash` is called from INSIDE `_resolve`'s hit loop,
  after the strike resolves, and ONE function both spends the charge and deals
  the blow. It reads `final` — the damage THIS hit actually dealt — rather than re-deriving from
  the ability's nominal damage, which would drift the moment a crit, a resist or an armor read
  differed.
· **APPLIED RETROACTIVELY, AND WHAT CHANGED IS ONE THING: MIRROR IMAGE** (BQ) now spends one image
  per hit of a multi-hit attack. The gate is `multi_hits` ALONE, which keeps the card's promise
  true — a multi-hit ability is repeated strikes on ONE target, i.e. single-target, while an area
  attack, a random scatter and a chosen pair are not and still spend nothing. **IT CHANGES NOTHING
  IN PLAY TODAY**: no enemy in enemies.json carries `multi_hits` or `random_hits` (asserted, not
  assumed) and heroes do not attack the Mage. It is the rule made TRUE ahead of its use.
· **THE OTHER THREE CHARGE BANKS ALREADY COUNTED HITS** — Interpose's `shield_charges` (the block
  branch), Waiting Guard's `banked_guards` and Feint's `feint_guards` (both on the parry roll).
  All three sit inside the strike loop. Verified at their sites; no change.
· **ONE PLACE THE RULE WAS DELIBERATELY NOT APPLIED, AND IT IS A FINDING RATHER THAN AN OMISSION:
  SPRAY OF ARROWS**, gated `ab.multi_hits == 0 and ab.random_hits == 0` by Batch AZ's own design
  (`spray` is how many extra ENEMIES a single shot finds; a multi-hit already finds its target
  three times). Firing it per hit would TRIPLE a shipped talent's magnitude — a balance change the
  standing testing scope forbids measuring. The same shape applies to the Survivalist's post-loop
  on-hit package (Coated Blades, Venom Coating): moving it inside the loop would triple its output
  AND change whether a missed or blocked strike still applies it, a second unasked change riding
  along. Spray's is pinned in test_batch_br so a later batch reads the reasoning first.

## STANDING RULE — A STATUS IS APPLIED WITH ITS `src` (Batch DI)
**`_apply_status`'s sixth argument is not optional in spirit.** It has stamped `src_name` onto the
status since Batch W, and a site that omits it does not fail — it silently mis-credits everything
that reads the source. **A missing `src` is invisible by construction**: an unstamped status and
one the reader applied himself are the same value to every consumer, so the defect can only ever
be found by counting call sites, never by playing.
· **DH's HARVEST CLAUSE IS THE FIRST THING IN THE GAME WHOSE MAGNITUDE DEPENDS ON IT**, and it
  shipped one batch ahead of the plumbing. It pays 12% a status rising to 18% when the whole board
  is the party's work; against a realistic board DI measured the under-payment at **3923 → 5308,
  a 35% correction**. It was not a rounding error and it was not visible anywhere.
· **A CLAUSE WHOSE MAGNITUDE DEPENDS ON INCOMPLETE PLUMBING IS WORSE THAN ONE THAT DOES NOT
  EXIST**, because it looks like it works. When a clause starts reading a field, the same batch
  owes a count of how many writers actually write it.
· **WHERE THE TRUE SOURCE IS AMBIGUOUS, REPORT IT — DO NOT PICK.** A status applied BY a status, a
  reflected effect, an item nobody holds, an environmental stamp. **Getting the source wrong is
  worse than leaving it absent**: absent under-pays, wrong mis-credits. DI left fourteen sites
  unstamped for exactly this reason and named every one in `docs/reports/DI.md` §2.
· **AND RESOLVE THE NAME AGAINST THE PARTY, NEVER MERELY COMPARE IT TO YOUR OWN.** `_apply_status`
  stamps for ANY source, an enemy's included, so `src != self.unit_name` reads one enemy's debuff
  on another as the party's work.
· **`heroes` DOES NOT CARRY THE COMPANIONS** — see the standing rule of its own below, which DJ
  earned by closing this. Harvest's ally loop walked `heroes`, so a wound Aguila opened paid the
  base rate however it was stamped; **DI left the seven companion sites unstamped rather than let
  the sweep look complete while the wound still paid nothing**, and DJ stamped them with the loop.
· **AND MEASURE COVERAGE WITH A WALK, NOT A `grep`** — see the second standing rule below, which
  DJ earned from this. `check_di` §1 balances parens, skips comments, and PRINTS the live figure
  on every battery run.

## STANDING RULE — `heroes` DOES NOT CONTAIN THE COMPANIONS; `companions` DOES (Batch DJ §1)
> **Any loop implementing the *ally* convention must read BOTH.** A loop over `heroes` alone
> silently excludes companions and **reports nothing** — it looks like a balance quirk, not a bug.

**`heroes.append` is reached at exactly ONE site**, the party spawn; a summoned beast is appended
to `companions` at the one place a companion is built. Nothing else ever adds to either array.
**The line numbers that used to stand here are deleted rather than re-numbered** — DK's own edits
moved one of them, which is this block's neighbouring rule met in the wild.
· **THE THREE IDIOMS, AND THEY ARE NOT INTERCHANGEABLE.** `heroes + companions` is the union **dead
  or alive**; `_hero_side()` is the union **of the living only**; bare `heroes` is the four, and no
  `not h.is_companion` clause on it changes that — **every such filter in `battle.gd` is
  filtering an array that cannot hold one.** They record the author's INTENT, which is worth
  reading. They are not what does the excluding.
· **AND A PER-TURN EFFECT IS A FOURTH EXCLUSION NOBODY WRITES DOWN.** `_next_unit()` walks
  `heroes + enemies`, so a companion takes no turns — a "each ally, each turn" clause can never
  reach one however its collection is spelled.
· **PICKING THE UNION IS A DECISION ABOUT `dead`, NOT ONLY ABOUT COMPANIONS.** `docs/reports/DI.md`
  proposed DJ's fix as *"one word: `heroes` → `_hero_side()`"*. **That word would have been
  wrong.** Harvest's loop deliberately does not filter `dead` — a hero who has since fallen still
  opened the wound — and `_hero_side()` does. Measured: the suggested fix passes the companion
  check at 1.5000 and drops a fallen opener's board to **0.6664**, a fresh 33% under-payment in the
  same loop, in the same shape, introduced by the fix for the first one. **`check_dj` §4 is the
  control that catches it.**
· **THE COST OF GETTING IT WRONG IS SILENCE.** Before DJ, a companion-opened board paid **exactly
  1.0000** of a self-opened one — the bonus simply did not arrive, and no log, no test and no
  battery said so. It now pays **1.5000**, which is what a hero's wound pays.
· **DJ SWEPT ELEVEN AND RULED ON NONE; DK RULED ON ALL ELEVEN AND THEY SPLIT FOUR AND SEVEN.**
  **FOUR had their CODE corrected** and now read `_hero_side()` — Rally, Hold the Line, Sanctuary,
  Field Medic. **SEVEN had their TEXT corrected to "hero"** — Rallying Cry, War Stomp and Rallying
  Shout's RESOURCE clause (a beast has no resource bar — **its Pressure clause is a separate
  ruling and DL §1 widened it**), Devoutness and Last Hope (stamped at party spawn, before a
  beast exists), Cleansing Waters (per-turn, and a companion takes none) and Tank and Spank (the
  chip lands and pays nothing). **The reason is recorded beside each one in the source**, because
  "hero" alone is a decision the next author re-litigates. `check_dk` §1 pins both populations by
  their own read lines, so neither half can rot without saying so.

## STANDING RULE — A WIDENING IS DONE WHEN THE EFFECT ARRIVES, NOT WHEN THE COLLECTION WIDENS (Batch DK §1)
> **Widen the loop, then walk the chain to the number that moves, then measure it on a live body.**
> A widening that changes no measurement is not a smaller fix — it is **worse than the narrow
> word**, because a chip appears on the unit and it reads as working.

DK widened five candidates and **only four of them landed**. The fifth, `wd_tank_spank`, applies
`empower` to a companion perfectly cleanly: the status attaches, the chip renders, the tooltip
reads. **It pays exactly nothing.** A beast strikes through `_companion_hit`, which is its own
damage path and reads only a handful of the hero strike loop's multiplier terms (`empower` only
when its hunter holds the Shared Hide rune) — measured over 40 seeded blows with the chip
standing, **ratio 1.0000.** Its TEXT was corrected
instead.
· **THE THREE PLACES A WIDENING DIES, AND ONLY THE FIRST IS THE COLLECTION.** (1) the loop walks
  bare `heroes`; (2) a filter downstream removes it — this is the one CV §4 believed was the
  mechanism and it never was, since **every `is_companion` filter walks `heroes` and removes
  nothing**; (3) **the READ SITE below simply never runs for that body.** The third is invisible to
  every source grep and to every check that asserts on a collection.
· **SO THE EVIDENCE IS A LIVE MEASUREMENT ON THE ACTUAL BODY, NOT A COLLECTION ASSERTION.**
  `check_dk` §2 summons a real bear and reads what each of the four pays it: Sanctuary heals it
  **1200 of a 10000 body**, Hold the Line leaves it at **20 Break from a 40-BD blow** against an
  unheld 40 and holds it at 1 HP through a lethal one, Rally turns a 1000 heal into **1300**, and
  the Field Medic's pool holds it once it is poisoned.
· **AND THE CONTROL IS NOT OPTIONAL, BECAUSE THE BUG WAS INVISIBLE.** Four effects paid four units
  instead of five for the life of the project and no log, no suite and no battery ever said so — so
  a check that passes on the fixed tree proves nothing. `check_dk` §2 empties `companions` for the
  length of one arm, which is exactly the pre-DK collection, and asserts the beast is untouched:
  **Sanctuary heals it 0, Hold the Line leaves it the full 40.**
· **PIN THE REASON YOU DID *NOT* WIDEN, AS A MEASUREMENT.** `check_dk` §4 re-measures Tank and
  Spank's 1.0000 on every battery run. A ruling of the form "we left this narrow BECAUSE widening
  would pay nothing" is a claim about a code path, and a claim about a code path rots — pinned this
  way, the day `_companion_hit` reads `empower` without the Shared Hide rune, the gate says the ruling is stale
  instead of staying quietly true.
· **A RECEIVE-SITE TAKES `_hero_side()`; A SITE ASKING WHO *DID* SOMETHING TAKES `heroes +
  companions`.** All four of DK's widenings ask who RECEIVES an effect, and a corpse receives
  nothing — so all four take the living, by the authored name rather than by a fifth hand-rolled
  copy of the predicate. **Harvest is the counter-case and must not be dragged along**: it asks who
  *opened* a wound, and a hero who has since fallen still opened it, so it spells its union out.
  Both are `heroes + companions`; only one filters `dead`.

