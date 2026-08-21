# BATCH CZ — TWO RAMPS THAT DO NOT ARRIVE, AND A HOLE IN THE ENUMERATION

*2026-08-21. Four mechanical changes, one enumeration repair and one ruling reported and not
taken. No save version moves (still v10).*

---

## THE HEADLINE

| | |
|---|---|
| **Blood Frenzy has a second term he controls.** Rage spent, at the health term's own rate. | Peak **13.4 → 20.9** of 40 points at rung 2 (**33% → 52%** of the band). CY's regression is closed. |
| **Faith releases at 3, and both builders were raised.** | Releases a battle **0.81 → 4.24** at rung 2. Peak **2.3 of 5 → 2.4 of 3** (46% → 81%). |
| **The six shields take the buff delay cap.** 2.0–2.5 → 1.0. | **Heals do not, and that is now a rule with both halves asserted.** |
| **`up_speed` is alive again** on all 216 abilities. | The floor was a literal `1.0` — exactly CY's cap. It is `BUFF_DELAY_CAP × 0.5` now. |
| **The enumeration is ONE function and it reaches 216.** | Four gates carried four copies of the same hole. **CN owes nothing; CO owes one ruling on one ability.** |

**Eight complete runs of the game, four before and four after** — 25 runs each, ~2,500 battles a
pass. **Eleven gates, zero failures, zero throws.**

---

## §0 — THE ENUMERATION GAP

### The fix: one walk, and it lives on `Classes`

**`Classes.ability_corpus()` is the only enumeration in the project now.** It walks the kits, the
class pools and the spec pools exactly as the Batch CL enumeration did, and then walks
`Classes.talent_granted_names()` through `Talents.granted_ability` — the one resolver both grant
shapes go through.

**FIVE COPIES WERE CARRYING THE HOLE, NOT TWO.** The brief named `check_cn` and `check_co`.
`check_cm` walks it too, `check_cy` had built the complete version inline for its own use, and
**`check_cl_width` — the ORIGINAL, the one the other four copied — was the fifth.** All five read
the shared function now.

**IT LIVES ON `Classes` RATHER THAN IN A GATE**, because the question is about the game's data
rather than about testing it. `Classes.pool_ability` already falls through to
`Talents.granted_ability` for exactly this reason, so the reach into the trees is a dependency the
file already had, used a second time.

`check_cz.gd` re-derives the old CL walk as a **negative control** — its whole job is to still be
missing the five. If it ever stops being, the gap has closed itself and this report is stale.

| walk | reaches |
|---|---|
| the Batch CL enumeration | **211** |
| `Classes.ability_corpus()` | **216** |
| talent-granted names, all resolving | **22** |

**ONE THING THE REPAIR SURFACED AND DID NOT COST ANYTHING: `check_cl_width` had never measured
those five descriptions at all.** Re-pointed, it now does — and **all five are clean**, zero
authored lines over the 44-character ceiling. The corpus-wide figure is unchanged at 8 over.

### CN's criterion and CO's, re-run over the five

**Derived by walking `_resolve_special`, not by reading `damage` and `pressure`** — those two
fields are zero on four of the five, and every one of the four writes to an **enemy** from inside
its handler. A field read would have called them all self-buffs.

| ability | runs bar | refusable | delay | what the HANDLER does |
|---|---|---|---|---|
| Backdraft | **no** | no | 2.00 | adds turns of Burn to every already-burning enemy — additive, no damage |
| Pyroblast | yes | no | 6.00 | 55 damage and 25 Break on its own fields — an ordinary attack |
| Glacial Prison | **no** | no | 2.50 | Chilled + `_hold_freeze` on ONE enemy, and nothing else |
| Cryoclasm | **no** | no | 2.00 | MOVES the oldest hold: strips one enemy, chills and freezes another, reschedules the first |
| Intercession | **no** | no | **1.00** | a status on every living hero and nothing anywhere else — a pure buff |

**CN OWES NOTHING.** Its *criterion* already answers all five correctly: four deal no damage and
no Break damage, so the grade has nothing to multiply and the bar is correctly off; Pyroblast
attacks and correctly keeps its bar. Only CN's printed *population* was short by five, and it is
short no longer.

**CO OWES ONE RULING, ON ONE ABILITY. GLACIAL PRISON IS THE ONE OF THE FIVE THAT FITS THE REFUSAL
CRITERION.** Its whole cast-time payload is Chilled plus `_hold_freeze`, and `_hold_freeze`
returns immediately on a target that already has `frozen` — **so a recast onto a held enemy writes
nothing at all**, which is precisely the waste CO exists to refuse. The other four do not qualify:
Backdraft is additive (Interpose's shape — a recast always improves), Cryoclasm moves state
between two enemies and reschedules one, Pyroblast attacks, Intercession is an ally buff.

> ### ⚖ RULING OWED — should Glacial Prison join `RECAST_GATED`?
> One entry in one array, plus the matching `_recast_writes` declaration. **This batch reports it
> and does not take it**, on CQ §6's standing rule: a change to what a card does is the designer's
> call, not a batch's. The cost of getting it wrong is a darkened button on a card that would in
> fact have improved something — so the `_recast_writes` half has to be right before the table
> entry goes in.

**AND THE ONE OF THE FIVE THIS BATCH DID OWN IS ALREADY DONE.** Intercession is a pure buff, CY
had already put it in `PURE_BUFFS`, and it sits at the cap (1.00). The gate asserts it rather than
reporting it, because "apply the cap to any of the five that qualifies" was §0's instruction.

---

## §1 — BLOOD FRENZY GETS A SECOND TERM HE CONTROLS

> **+2% per 5% of health missing, and +2% per 5% of Rage spent. The same rate off either bar.**

### The shape: two terms, one band

`FRENZY_MAX_STEPS := 20` is **not a new ceiling** — it is the one the health term already had
(`int((1 − hp/max_hp) × 100 / 5)` reaches exactly 20 at zero health). Writing it down is what stops
the second term deepening the band. **The steps are summed and then clamped**, so Rage spent can
only ever fill the band *sooner*, never make it *bigger*. A Berserker already in the red gets
nothing from it — which is correct, because at that point the identity term is paying.

**His identity is not rewritten.** He still fights better hurt; he is given a floor a well-played
party cannot take away.

### The rate: FLAGGED, and the figure

**`FRENZY_RAGE_PER_STEP := 5`, and it is a rule rather than a tuning constant.** A Berserker's Rage
maximum is 100, so five Rage *is* 5% of the Rage bar — the health term's own rate off the other
bar. That symmetry is why 5 and not 6 or 10; three other values were measured and are below.

| Rage a step | peak of 40, rung 2 | share of the band |
|---|---|---|
| 10 | 14.3 | 36% |
| **5 (shipped)** | **22.2** | **55%** |

**Rage actually spent, measured over the four 25-run sims:**

| arm | Rage spent/battle | steps bought | points of the band |
|---|---|---|---|
| A rung 1 wanderer | 37.3 | 7.5 of 20 | +14.9 |
| B rung 2 warden | 39.5 | 7.9 of 20 | +15.8 |
| C rung 3 ruin | 47.9 | 9.6 of 20 | +19.2 |
| D rung 2, Sharpshooter | 57.8 | 11.6 of 20 | +23.1 |

### The ledger: what LEFT the bar

**One function, `BattleUnit.note_resource_spent`, and three callers** — the one line in `_resolve`
where every ability in the game pays, Reckless Abandon's bar dump, and Last Rites.

**It books the NET off the bar, not `ab.cost`**, and that is what makes it un-farmable: Battle
Shout costs 15 and refunds 5, so it books 10; a card that refunded itself entirely would book
nothing; Snap Shot and Twin Hunt waive the cost outright and book nothing. **All of that falls out
of measuring the bar** rather than reading a field, which is why it is measured that way.

**A JUDGEMENT CALL, RECORDED: LAST RITES IS COUNTED.** Its Rage leaves the bar to pay for a wound
rather than to cast something. It is counted because it is Rage a talent *he* chose converts into
survival, it is the one node in the game already coupling his two resources, and excluding it
would mean the deeper he invests in the Fury lane the less his own passive notices.

**AND RECKLESS ABANDON IS THE EXTREME CASE, NAMED RATHER THAN DISCOVERED LATER.** It dumps the
whole bar, so a full 100 books all twenty steps at once and the clamp eats any a wound had already
bought. That is the coupling the batch is *for* — his own card feeding his own passive — and it
costs a turn and every point of his resource. It cannot take him past a band a dying Berserker
already reaches.

### CY's four sims, re-run

**Blood Frenzy peak, of 40 points.** *"Before" is today's HEAD, measured fresh — not CY's printed
figures, which came from a different unseeded sample.*

| arm | before | after | change |
|---|---|---|---|
| A rung 1 wanderer | 6.2 (16%) | **17.4 (43%)** | +11.2 |
| B rung 2 warden | 13.4 (33%) | **20.9 (52%)** | +7.5 |
| C rung 3 ruin | 12.1 (30%) | **22.8 (57%)** | +10.7 |
| D rung 2, Sharpshooter | 13.9 (35%) | **26.2 (65%)** | +12.3 |

**The regression CY reported is closed in every arm**, and the band now arrives at half to
two-thirds rather than at a third.

**A DISCREPANCY WORTH RECORDING: CY's own after-figures do not reproduce.** CY printed Frenzy at
7.4 / 11.8 / 12.7 / 12.7 and Faith at 1.9 / 2.1 / 2.1 / 2.8. Re-measured on unmodified HEAD at the
same settings, the same instrument reads **6.2 / 13.4 / 12.1 / 13.9** and **1.9 / 2.3 / 2.4 / 2.8**.
Nothing changed between the two — this is n=25 noise on an unseeded sim, and it is the size of
noise to expect on any of these figures (roughly ±1.5 points of band, ±0.2 of a Faith stack).
**Read every row in this report with that band attached.**

---

## §2 — FAITH REACHES ITS RELEASE

### Both halves moved

- **`FAITH_RELEASE := 3`** — and it was a literal `5` in **three** places (the cap on the count,
  the release branch, and Communion's "still building" guard). It is one number now.
- **`FAITH_PER_ABSORB` 2 → 3.**
- **`FAITH_PER_GROUND_TURN` 1 → 2** — the ground drip was a bare literal at its one call site.

### What it measures out at

**Faith peak** *(the denominator moved with the threshold, so read the percentage, not the count)*:

| arm | before (of 5) | after (of 3) |
|---|---|---|
| A rung 1 | 1.9 — **39%** | 2.5 — **85%** |
| B rung 2 | 2.3 — **46%** | 2.4 — **81%** |
| C rung 3 | 2.4 — **47%** | 2.4 — **80%** |
| D rung 2, SS | 2.8 — **56%** | 2.5 — **84%** |

**Faith releases per battle** — the number that actually answers "does a release fire":

| arm | before | after | healing/battle before → after |
|---|---|---|---|
| A rung 1 | 0.51 | **3.83** | 26 → **130** |
| B rung 2 | 0.81 | **4.24** | 69 → **178** |
| C rung 3 | 0.75 | **5.28** | 69 → **239** |
| D rung 2, SS | 1.49 | **6.39** | 118 → **265** |

> ### ⚠ FLAGGED HARD — THIS IS A LARGE POWER SWING AND THE ALTERNATIVE IS ONE CHARACTER AWAY
> Releases went up **five- to seven-fold** and the Devout's total healing roughly **tripled**. That
> is more than "the average fight reaches 3", which is what the brief asked for. Four combinations
> were measured at rung 2 before shipping one:
>
> | absorb / ground | peak of 3 | releases/battle | healing/battle |
> |---|---|---|---|
> | 2 / 1 *(threshold move alone)* | 2.3 (77%) | 2.71 | 150 |
> | 3 / 1 | 2.2 (73%) | 2.81 | 167 |
> | 2 / 2 | 2.2 (74%) | 3.17 | 145 |
> | **3 / 2 (shipped)** | **2.5 (85%)** | **5.31** | **213** |
>
> **The threshold move alone already triples releases** (0.81 → 2.71). The builders take it the
> rest of the way. **`FAITH_PER_ABSORB := 2` is the measured alternative** — it holds releases near
> 3.2 a battle and costs 0.3 of the peak.

### A concern in the shipped numbers, stated rather than buried

**THREE PER ABSORB AGAINST A THRESHOLD OF THREE MEANS ONE ABSORBED HIT IS A WHOLE RELEASE.** A
shielded ally now never *holds* Faith — he fills and pays out on the same blow, and the held half
of the meter stops existing for him. Nothing is lost (the peak keeps paying, BI §1), but the card
stops being a ramp and becomes a per-hit heal. It ships because the brief names both builders as
barely firing and asks for both to move; the note is in `battle.gd` beside the constant.

**AND A MEASUREMENT NOTE THAT CHANGES HOW THE ABSORB RATE READS: raising it does not move the
figure the batch is measured on.** The Faith arrival row samples **the Devout's own meter**, and
his meter is fed by the ground drip on his own turns, not by absorbs (he is rarely the shield
holder). 3/1 measured 2.2 against 2/1's 2.3 — no gain. The absorb rate buys **ally release
frequency** and nothing else.

### THE INSTRUMENT ITSELF WAS MEASURING SOMETHING ELSE, AND IT IS WORTH KNOWING

**CY's "Faith reaches 1.6 of the 5 a release needs — so the average fight ends without a Devout
release ever firing" is not what the number says.** The `conviction` row samples the **DEVOUT'S
OWN** meter, and **his Faith holds at the threshold and never releases by rule** (Batch BH §2). It
has never been a measure of whether a release fires.

**The number that answers that question was in the same report all along**: the Faith
decomposition's `releases/battle`, which read **0.51 to 1.49** on unmodified HEAD — low, but not
zero. Releases were firing.

Both rows are reported here rather than one standing in for the other, and the caveat is now
written into `CY_METERS` beside the row itself.

### The two interactions §2 asked to be checked, not assumed

- **BLESSING OF THE FAITHFUL (`jubilee`) NEEDS 3 FAITH HELD, AND 3 IS NOW THE WHOLE BAR.**
  `JUBILEE_MIN_FAITH` was 3 against a threshold of 5 — "most of a bar". It is now **exactly the
  bar**, so the card is castable precisely when the meter is full, **and only by the Devout**: an
  ally reaching 3 releases on the spot and can never be holding three when the button is read.
  Before the change an ally at 3 or 4 could hold and cast it. **REPORTED, NOTHING CHANGED.**
- **ELEVATION GRANTS 2, WHICH IS NOW 67% OF A RELEASE** rather than 40% of one, to every ally at
  once. A flat grant against a shorter bar is worth more by construction. It is also the exact node
  the designer set to 2-with-a-raised-cost at CG and that CN's fold pushed to 3 before CQ reverted
  it — **so it is the one magnitude in this lane with a history of being moved by accident.
  REPORTED, NOTHING CHANGED.**
- **AND ONE MORE THE BRIEF DID NOT NAME: THE HELD HALF LOST TWO STACKS OF CEILING.** Faith pays
  mitigation and damage on `faith_peak`, and the count caps at the threshold — so the deepest
  benefit an ally can ever hold fell from 5 stacks (10% mitigation, +7.5% damage) to 3 (6%, +4.5%).
  **The lane trades depth of hold for frequency of release.** That is the intended shape of the
  change and it is stated so it is not discovered later.

---

## §3 — SHIELDS TAKE THE SAME DELAY CAP

> **A SHIELD TAKES THE BUFF DELAY CAP. A HEAL DOES NOT.**
> **A shield is played BEFORE the blow; a heal answers what just happened.**

| ability | special | delay before | after | cd | on CR's duration list |
|---|---|---|---|---|---|
| Divine Shield | `divine_shield` | 2.5 | **1.0** | 2 | no |
| Interpose | `interpose` | 2.0 | **1.0** | 4 | no |
| Magic Barrier | `magic_barrier` | 2.0 | **1.0** | 4 | no |
| Mantle | `mantle` | 2.5 | **1.0** | 4 | no |
| Mirror Image | `mirror_image` | 2.0 | **1.0** | 4 | no |
| Vespers | `vespers` | 2.0 | **1.0** | 4 | **YES — 4 turns against a 4-turn cooldown** |

**ONE OF THE SIX IS ON CR's LIST: VESPERS.** Its 4-turn duration meets its own 4-turn cooldown,
which CR accepted on the reasoning that holding it costs an action and its resource every cycle.
**At half delay that maintenance is now half price.** Nothing is changed — this is the same fold
CY reported for 28 of the 52, surfacing now rather than in an audit five batches out.

**THEY ARE A SEPARATE POPULATION AND STAY ONE.** `Ability.SHIELD_SPECIALS` is a second list, not
five names appended to `PURE_BUFFS` — CY's table can still be checked as the thing CY derived, and
the criterion that excluded them (a *consumable absorb pool or charge count*) is still correct.
They are capped on the **tempo** rule rather than on the payload one. `Ability.takes_delay_cap()`
is the one function that unions them, so `make()` and every gate ask the same question.

**THE HEALS ARE UNTOUCHED FOR A SECOND BATCH, AND NOW BOTH HALVES ARE ASSERTED.** `check_cz.gd`
fails if any of the fourteen drafted heals is caught by the cap or sits at or under it — a rule
with only its positive half checked would let a later batch halve every heal in the game and still
pass.

---

## §4 — `up_speed` IS REVIVED

**The floor was a literal `1.0` — exactly CY's cap — so Swift was a dead pick on all 52 pure
buffs.** `maxf(1.0 × 0.75, 1.0)` is 1.0: the reward was live on every one of them the day before
and bought nothing the day after, in silence.

**`Ability.DELAY_FLOOR := BUFF_DELAY_CAP * 0.5` = 0.50 today.** The ladder now reads:

| rung | value | what it is |
|---|---|---|
| `BASIC_DELAY` | 2.00 | a swing |
| `BUFF_DELAY_CAP` | 1.00 | setting up — half a swing (CY) |
| **`DELAY_FLOOR`** | **0.50** | the cheapest an UPGRADE can buy — half again |

**FLAGGED: half the cap is a judgement call, and the reason is stated.** It is the only value that
keeps Swift meaningful on the cheapest card in the game without making it free — 25% off a capped
buff is 0.75, which clears 0.50 with room, so one Swift always does something and no stack of them
can reach zero. **Zero is reachable elsewhere and deliberately not here**: Instinctive Rotation
sets `eff_delay = 0.0` as a talent's whole payload, and an upgrade should not buy what a node
exists to grant.

**`upgrade_fits("up_speed")` NOW ASKS A QUESTION.** It fell through to `return true` on the note
that "Swift is the one that fits everything — every ability has a delay". That was true for eight
batches and stopped being true without a line changing there. It reads `ab.delay > DELAY_FLOOR`
now. **It changes no offer today** (the cheapest card in the game is a capped buff at twice the
floor); it is what keeps the dud closed if a later batch authors something cheaper.
`check_cz.gd` proves the general property rather than a list: **Swift fits 216 of 216 abilities and
moves the delay on every one.**

### The sweep §4 asked for

**Every site in the project that floors, clamps or compares a `delay` against a literal was
swept.** There are exactly **two**, and the second is a finding:

1. **`run_state._stamp_upgrade`'s `1.0`** — fixed above.
2. **`battle.gd`'s Mana Shield clamp, `minf(eff_delay, 1.5)` — NOW INERT.** Mana Shield is a pure
   buff, so its delay *is* the cap (1.0) and the clamp can never bind. **It is reported and kept,
   not deleted**: it is a *clamp*, and what it does is keep the discount unable to *raise* the
   cost — which is the exact failure CY caught it in the act of. Its description still says "It is
   quick to cast": true, and no longer distinguishing.

**Nothing else touches a delay against a literal.** No rune, relic or talent modifies `delay` by
`add`/`set` at all (checked, not assumed), and no authored ability sits at or below the new floor.

---

## §5 — WHAT THIS DELIBERATELY DID NOT DO

- **No ramp spec starts a fight with meter on the clock.** Offered twice, not taken, and §1 and §2
  both measured well enough that it is not needed for either.
- **No enemy health changed** and the turn structure did not change.
- **No completion swing was tuned**, and bot completion rate stays retired as a difficulty verdict.
- **No ruling was taken on Glacial Prison** (see §0).
- **No heal's delay moved.**

---

## §6 — GATES, AND WHAT WAS RUN

**ELEVEN GATES, ZERO FAILURES, ZERO THROWS.**

| gate | result |
|---|---|
| `check_parse` | 0 failures (stderr grepped for `Parse Error`, not the tally) |
| `check_cm` | 0 failures |
| `check_cn` | 0 failures |
| `check_co` | 0 failures |
| `check_cs` | 104 checks, 0 failures |
| `check_ct` | 113 checks, 0 failures |
| `check_cu` | 0 failures |
| `check_cv` | 0 failures (324 nodes) |
| `check_cy` | 0 failures |
| **`check_cz`** | **0 failures** — new, and joins the battery's gate list (now **thirteen**) |
| `check_flow` | 0 failures |
| `check_cl_width` | report: 216 abilities, 8 description lines over the ceiling (unchanged) |

**`check_cz.gd` covers all five sections**, and the two halves that only a live battle can settle:
a real cast has to reach the Rage ledger with what actually left the bar, and an ally walked to the
threshold has to release while the **Devout's own meter, driven to the same count, holds** — the
negative control that keeps §2's rule from passing for the wrong reason.

**Eight complete runs of the game, four before and four after.** 25 runs each, three difficulty
rungs, ~2,500 battles a pass. Battles resolve; nothing throws.

| | rung | completions before → after | depth reached before → after |
|---|---|---|---|
| A | 1 wanderer | 100% → **100%** | 48.00 ±0.00 → **48.00 ±0.00** |
| B | 2 warden | 60% → **72%** | 45.64 ±1.11 → **46.56 ±0.75** |
| C | 3 ruin | 44% → **52%** | 43.04 ±1.60 → **42.84 ±2.14** |
| D | 2 warden, Sharpshooter | 68% → **72%** | 44.68 ±1.54 → **47.04 ±0.40** |

**Read that with the harness's own warning attached: at n=25 completions are a noisy secondary and
depth is the primary.** Depth rose in two arms, held in one and fell inside its own standard error
in the third; **only arm D's move is bigger than the combined standard error.** The honest summary
is that the batch did not make the game measurably harder or easier — which is the right outcome
for a change aimed at two specs rather than at difficulty.

**Fights got slightly longer**, as CY's did for the same reason: trash 4.2 → 4.3 at rung 2,
4.1 → 4.9 at rung 3, 5.5 → 5.8 for the Sharpshooter party.

**NO SUITE AND NO FULL BATTERY WAS RUN.** CZ is implement-only under the standing convention. **The
next dedicated test batch still owes one**, and it now owes it against CW's eleven unrepaired
assertions, CY's 52 moved delays, and this batch's six more plus a Faith threshold that three
suites may quote.

---

## FOUND WHILE WORKING, REPORTED AND NOT FIXED

- **`check_cu` AND `check_cv` ARE NOT IN THE BATTERY'S `GATES` ARRAY.** CY's report lists both
  among the nine gates it ran, and `run_battery.sh` runs neither — they are run by hand or not at
  all. Both were run by hand for this batch (0 failures each). Adding them is a one-line change,
  but they are audit *reports* rather than pass/fail gates, so what a failure means there is a
  decision rather than a detail.
- **CY's printed after-figures for Blood Frenzy and Faith do not reproduce on unmodified HEAD.**
  See §1. Not an error in CY's work — n=25 noise on an unseeded sim — but the figures in
  `docs/state.md` were quoted as though they were stable, and they are not.
- **THE BRIEF'S §1 CLAIM THAT BLOOD FRENZY "WENT BACKWARDS UNDER CY (12.2 → 11.8)" IS CY's OWN
  MEASUREMENT AND IS INSIDE THE NOISE BAND.** The inversion it describes is real and structural —
  cheaper mitigation genuinely does shallow a passive paid in damage taken — but the 0.4-point
  movement that revealed it is smaller than the ±1.5 this instrument carries at n=25. **The fix was
  worth making for the mechanism, not for the number.**
