# BATCH EV — A CONVERTED STACK NEVER PAYS NOTHING

**Ruled and built: when a converted Loyalty stack would pay into a boon that is already at its
clamp, it pays the strike step instead.**

EU measured the defect and correctly reported rather than fixed it. **At rows=9 a Beastmaster
fielding Ursus lost a large share of his companion's strike step and gained exactly zero**, because
both consumers of the bear's boon were already saturated. **That arm now reads 0.00% lost, and the
boon pays exactly what it paid before** — measured over 228 companion blows on which the boon
itself was genuinely lower on 183 and the two terms it feeds differed on none.

---

## THE BRIEF'S CLAIMS, RE-DERIVED

**The brief said to verify every premise. Three moved.**

| the brief's claim | what the tree and the arms say |
|---|---|
| *"at rows=9 a Beastmaster fielding Ursus loses **36.7%** of the strike step"* | **THE FIGURE IS THE POOLED ONE ACROSS ALL THREE BEASTS, AND THE BEAR'S OWN SLICE IS WORSE.** EU §3's 36.70% is the loss over every companion blow in the arm regardless of which beast was standing. Restricted to ursus blows it is **40.17%**. The brief's sentence is about a hunter fielding Ursus, and for that hunter the loss was understated. §1. |
| *"gains exactly zero, because both boon clamps were already full"* | **CONFIRMED, AND THE MECHANISM IS CONFIRMED SEPARATELY FROM THE ZERO.** §2a. |
| *"EU proved the affected window is one stack wide — histogram `{6:13, 10:3, 14:1}`"* | **THE CONCLUSION HOLDS AND THE HISTOGRAM IS NOT WHAT PROVES IT.** That histogram is the distribution of Loyalty at 17 sampled mitigation calls; it shows that no sample LANDED in the window, which is why EU's delta read exactly zero. **The window's WIDTH comes from the arithmetic**, and this batch re-derived it live rather than quoting it: at the deep boon step the clamp is crossed at a count of 10, so Loyalty 9 is the only depth at which the conversion changes the term. §1a. |
| *"EU §4: `0.10 x _bond_mult >= 0.75` **needs a count of 11**"* | **THAT LINE IS OFF BY ONE AND EU'S OWN CONCLUSION IS RIGHT.** `0.10 × (1 + 0.70n) ≥ 0.75` gives `n ≥ 9.29`, so the count is **10**, not 11 — which is exactly what puts the window at Loyalty 9, as EU concludes two sentences later. Driven live: at Loyalty 9 the boon reads 8.0 and the term clamps; unconverted it reads 7.3 and does not. **Nothing downstream depended on the 11.** |
| *"`_bot_boon_worth` missing from ER's payout table"* | **CONFIRMED, AND EV INHERITS IT STRUCTURALLY RATHER THAN BY REMEMBERING.** It calls the same `_bond_converted` the game pays, so it took the fallback the moment the signature changed. §3. |
| *"the break-even is `s/(1+s·L)` and the split point cancels out"* | **CONFIRMED AND UNUSED.** EV moves no rate and no point, so the break-even is unchanged at every arm. It is quoted here only to record that it was checked. |
| *"`_bond_convert()` is the one place the split is decided and this belongs beside it"* | **BUILT THAT WAY, AND IT NEEDED ONE THING THE BRIEF DID NOT ANTICIPATE: THE KIND.** Saturation is a property of WHICH boon the stack would feed — the bear's is clamped, the wolf's and the eagle's are not — so `_bond_paid`/`_bond_converted` take a `kind` now. All six call sites already had one in hand. §1. |
| *"a hero-level test would be wrong most of the time"* | **CONFIRMED AND DRIVEN.** At the untalented boon step, Loyalty 21 hands back one stack of thirteen and converts the other twelve. `check_ev` §1b finds those depths rather than asserting they exist. |

---

## §1 — WHAT WAS BUILT

**`_bond_fallback(hunter, kind, l)` returns how many converted stacks fall back**, and it sits
beside `_bond_convert()` with the rest of the split.

**BOTH HALVES READ IT FROM ONE CALL.** `_bond_paid` adds the count; `_bond_converted` subtracts it.
So the two halves remain disjoint and still sum to the whole meter **by construction rather than by
care** — which is the failure the brief named by name: *a stack paying the boon and the strike step
because the saturation check and the payment happen in different places.* `check_ev` §0 drives that
invariant over **240 readings** (3 kinds × 40 depths × 2 talent steps) rather than trusting the
arithmetic, with a companion check that the fallback actually moved a stack somewhere in the walk.

### THE SATURATION POINT IS DERIVED FROM THE CLAMPS, NEVER WRITTEN DOWN

Savage Presence's two coefficients are named constants now — `SAVAGE_MITIGATION_STEP` 0.10 and
`SAVAGE_TAUNT_STEP` 0.15 — and **both read sites spend them**, so `_bond_saturation()` derives the
point from `BOND_MITIGATION_MAX / SAVAGE_MITIGATION_STEP` against `1.0 / SAVAGE_TAUNT_STEP`.
**A designer who moves a clamp moves the fallback with it.** Left inline, the saturation point would
have been a fourth copy of a magnitude nobody compares, which is the drift `_bot_boon_worth` already
cost this project once.

**THE LATER-BINDING CLAMP GOVERNS, AND THE CHEAPER READING WOULD HAVE BEEN WRONG.** The taunt
saturates at a boon of `1/0.15 = 6.67`; the mitigation at `0.75/0.10 = 7.50`. **Between them is a
band where a converted stack is worthless to the draw and still worth something to the cover** — it
is visible in the untalented table below at Loyalty 19 and 20, where the taunt reads 1.0000 and the
mitigation is still climbing. A `minf` there would have paid the strike step with a stack the cover
was still spending. **A stack comes back only when it is worthless to everything.**

### DRIVEN, AT BOTH TALENT DEPTHS

Ursus fielded; `sum` is `_bond_paid + _bond_converted == l`, checked at every row.

**FULLY TALENTED (Absolute Devotion + Ancient Pact, boon step 0.70 — EU's rows=9 arm):**

| Loyalty | nominal converted | fell back | paid | converted | boon | mitigation | taunt |
|---|---|---|---|---|---|---|---|
| 8 | 0 | 0 | 8 | 0 | 6.600 | 0.6600 | 0.9900 |
| **9** | **1** | **0** | **8** | **1** | 8.000 | **0.7500** | 1.0000 |
| 10 | 2 | **2** | **10** | 0 | 8.000 | 0.7500 | 1.0000 |
| 12 | 4 | **4** | **12** | 0 | 9.400 | 0.7500 | 1.0000 |
| 16 | 8 | **8** | **16** | 0 | 12.200 | 0.7500 | 1.0000 |
| 20 | 12 | **12** | **20** | 0 | 15.000 | 0.7500 | 1.0000 |

**LOYALTY 9 IS THE WHOLE OF THE ONE-STACK WINDOW AND THE FALLBACK DECLINES IT.** That stack lifts
the mitigation from 0.73 to its 0.75 clamp, so it is buying something and it stays converted. One
stack later the boon is saturated with no converted stacks at all, and every one of them comes back.

**UNTALENTED (boon step 0.20) — and this is the arm that shows it is per stack:**

| Loyalty | nominal converted | fell back | paid | converted | boon | mitigation | taunt |
|---|---|---|---|---|---|---|---|
| 19 | 11 | 0 | 8 | 11 | 7.000 | 0.7000 | **1.0000** |
| 20 | 12 | 0 | 8 | 12 | 7.400 | 0.7400 | 1.0000 |
| **21** | **13** | **1** | **9** | **12** | 7.600 | **0.7500** | 1.0000 |
| 22 | 14 | **3** | 11 | 11 | 7.600 | 0.7500 | 1.0000 |
| 24 | 16 | **7** | 15 | 9 | 7.600 | 0.7500 | 1.0000 |

**AT LOYALTY 21 ONE STACK OF THIRTEEN FALLS BACK AND TWELVE STAY CONVERTED, IN THE SAME BATTLE ON
THE SAME BLOW.** A hero-level test has no way to express that row. **And rows 19 and 20 are the
band the `maxf` exists for**: the draw is already a certainty and the cover is not, so nothing falls
back.

### WHAT IS SCOPED OUT, DELIBERATELY

**The ruling is a SATURATED CLAMP, not "pays nothing".** A kind the hunter cannot reach — no beast,
no Vengeance, no Menagerie — has `_bond_reach` 0.0 and its boon pays nothing at all, and Call of the
Wild's bodiless blow can read the meter in exactly that state. **Those stacks do not fall back.**
That is a boon which is absent rather than full, it is a different question, and §2 reports it.

**And the Menagerie share is why the fallback needs the reach and not just the curve**: a
half-remembered bond is half as close to its clamp as a live one, so a saturation test on the curve
alone would hand back stacks a remembered bond was still spending.

---

## §2 — CHECK EVERY CLAMP, NOT ONLY URSUS'S

**Arms: `--run 100` each, `DOD_SIM_DIFFICULTY=warden`, `DOD_SIM_ROUTE=balanced`, specs
`berserker,cryomancer,inquisitor,beastmaster` — EU's arms exactly, at `DOD_SIM_ROWS` 0, 3 and 9.
Every probe is on an out-of-repo instrumented copy; not one executable byte of the shipped tree
carries one.**

### THE ANSWER TO THE CLAMP QUESTION IS STRUCTURAL: NEITHER OF THE OTHER TWO HAS ONE

| kind | where its boon is spent | clamped? | saturation point |
|---|---|---|---|
| **Ursus** | Savage Presence's taunt draw `minf(0.15 × boon, 1.0)`; Savage Presence's cover `minf(0.10 × boon, 0.75)` | **BOTH** | **7.50** |
| **Canis** | wounded-prey bonus `raw *= 1 + 0.15 × boon × wounded` | no | `INF` |
| **Aguila** | party crit `crit_chance += 0.10 × boon` | no | `INF` |

**So neither saturates at any reachable loadout, at any row count, and that is a property of the
read sites rather than a measurement that could come out differently tomorrow.** Canis's own term is
measured anyway, because "unclamped" is a source claim until something reads it:

| arm | Canis samples | boon, mean / max | term actually paid, mean / max |
|---|---|---|---|
| rows 0 | 1,225 | 2.23 / 9.80 | ×1.348 / ×2.47 |
| rows 1–3 | 1,681 | 5.20 / 24.80 | ×1.810 / ×5.71 |
| rows 1–9 | 561 | 27.55 / 71.00 | **×6.621 / ×30.16** |

**It never stops climbing.** At rows 1–9 the wolf's term reached ×30.16 and there is nothing above
it to reach.

### **BUT AGUILA HAS AN IMPLICIT CEILING, AND IT IS WASTED FAR HARDER THAN EITHER OF THE BEAR'S CLAMPS BINDS**

**This is the batch's largest finding and it is reported, not fixed.** The eagle's boon is spent as
`crit_chance += _party_crit_bonus()` and then rolled as `randf() < crit_chance` — **there is no
`minf` anywhere on that path**. So nothing clamps it, and yet everything past a total crit of 1.0
buys nothing at all, because a certainty cannot be improved.

| arm | crit rolls | rolls with the eagle's boon live | mean total crit | max | **rolls at or over total crit 1.0** | **of the boon DELIVERED, how much lands above the ceiling** |
|---|---|---|---|---|---|---|
| rows 0 | 40,746 | 1,708 (4.2%) | 0.329 | 1.05 | **4 (0.23%)** | **0.0%** |
| rows 1–3 | 53,677 | 3,116 (5.8%) | 0.454 | 2.60 | **199 (6.39%)** | **6.0%** |
| rows 1–9 | 34,785 | 887 (2.5%) | **1.931** | 15.85 | **521 (58.74%)** | **60.3%** |

**At rows 1–9 the party is at roughly double a certainty, nearly six rolls in ten are already past
the ceiling, and 60.3% of every point of crit the eagle delivers lands above it.** The boon term
alone averages +180% crit chance against a maximum useful 100%. **EU's `+48.96%` party-crit gain at
that arm is therefore a multiplier that is substantially unspendable** — which is not an error in EU's measurement (it measured the term, correctly) but is
the sentence that was missing beside it.

**AND THE FALLBACK DELIBERATELY DOES NOT REACH IT, FOR A REASON THAT IS LOAD-BEARING RATHER THAN
PEDANTIC.** The ruling is scoped to a saturated clamp, and the eagle's ceiling is **not a property
of its boon**: it is shared with every other crit source — the base rate, `crit_bonus`, Precision
Strikes, Killing Edge, Supernova, Focus's own converted half, a Broken target's +25%. **On 0 of the
rolls measured at any arm was the total already at 1.0 without the eagle's contribution**, so the
boon is never wholly wasted; it is the thing pushing the total over, and only the part above 1.0 is
lost. Whether a given stack is wasted depends on **who is attacking, with what, and whether the
target is Broken** — a question `_bond_fallback` cannot answer from the hunter alone, which is what
makes the bear's clamps tractable and the eagle's ceiling a design decision. **It is now priced.**

### AND WHAT SET EACH CLAMP — THE BRIEF ASKED, AND THE TWO ANSWERS ARE DIFFERENT

- **Savage Presence's taunt ceiling of 1.0 is ARITHMETIC AND NOT A CHOICE.** It is `minf(..., 1.0)`
  on a probability. There is no version of the game in which it is 1.2. **Raising it is not
  available to the designer**, and this is why it is not a named constant.
- **`BOND_MITIGATION_MAX`'s 0.75 IS A CHOICE INSIDE A FORCED BAND, AND THAT IS THE ONE WORTH
  PUTTING TO THE DESIGNER.** Its own header says why it exists: an uncapped bear mitigation crosses
  zero and starts *healing* the hunter off enemy attacks. **That guard forces some value below 1.0.
  It does not force 0.75.** 0.85 or 0.90 would satisfy the guard identically and would push the
  saturation point from a boon of 7.50 to 8.50 or 9.00 — which at the deep step is one to two more
  stacks of real cover before the fallback starts, and at the untalented step five to seven more.
  **EV moves it nowhere.** The fallback is correct at any value it takes, because it derives its
  point from the constant; raising the clamp and keeping the fallback are independent decisions and
  the designer can take either, both, or neither.

**RULED ON NOWHERE, EXACTLY AS THE BRIEF ASKED.**

---

## §3 — `_bot_boon_worth` TAKES THE FALLBACK TOO

**It takes it structurally, which is better than taking it deliberately.** `_bot_boon_worth`
recomputes the boon's curve so the bot can price a swap it has not made yet. It calls
`_bond_converted` — the same function the game pays out of — so the moment that signature gained a
`kind`, the mirror was reading the same converted half. **There is no second copy of the rule to
drift.**

`check_ev` §5 asserts the consequence rather than the call: over 30 depths at the deep step its
number must equal the curve at the converted count the game uses, and the fallback must have fired
in some of them. **Armed as a control — the mirror left reading the nominal converted count — it
reds with 20 disagreements over 30.**

**ONE RESIDUAL IS REPORTED AND NOT FIXED, BECAUSE IT IS OLDER THAN THIS BATCH.** `_bot_boon_worth`
prices Ursus at `0.10 × curve`, **unclamped**, while the game clamps that same term at 0.75. So the
bot over-values a deep bear bond whether or not the fallback exists — EV makes its number lower and
therefore closer to the truth, but does not make it true. **And it prices only the boon**: the
strike step the fallback hands back is not in its swap comparison at all, so a bot deciding between
beasts still cannot see the half this batch restored. Both are pre-existing shapes in the bot's
valuation rather than regressions, and neither is a game payout.

---

## §4 — THE LESSON EU EARNED, RECORDED — AND THE SWEEP IT ASKED FOR

**Recorded in `CLAUDE.md` as a standing rule**: *the read site is the LINE, not the function.*

**AND THE SWEEP FOUND MORE THAN EU'S TWO — BUT ONLY WHEN IT FOLLOWED THE CALL.** A **direct** sweep
(a converting read and a raw read in the same body) finds six functions and **misses
`_companion_strike`, which is the one EU named**, because its converting read is inside
`_comp_dmg_mult`. A **one-hop** sweep finds four more.

**FIVE ARE THE REAL SHAPE, AND ALL FIVE ARE CORRECT TODAY:**

| function | the converting read | the raw read beside it | correct? |
|---|---|---|---|
| `_ghost_hit` | `_bond_paid` → the strike step | Aguila's armor pierce `0.20 × l` | **yes** (EU named it) |
| `_companion_strike` | `_comp_dmg_mult` (one hop) | Canis's Bleed `+2 × l` | **yes** (EU named it; a direct sweep misses it) |
| `_stamp_loyalty_chip` | `_bond_paid` / `_bond_converted` / `_bond_mult` / `_bond_fallback` | all three gifts (`3×`, `2×`, `20×` stacks) | **yes** — new to this sweep |
| `_resolve_special` (Kill Command) | `_comp_dmg_mult` (one hop) | `kc_l`, feeding the Bleed and the pierce | **yes** — new to this sweep |
| `_autoplay_pick_kit` | `_bot_boon_worth` (one hop) | Primal Surge's raw `>= 4` gate | **yes** — new to this sweep |

**A THIRD CATEGORY EXISTS AND IT IS NOT THE SHAPE.** `_gain_loyalty` and `_do_summon` hold a raw
accrual beside a call to `_stamp_loyalty_chip`, whose converting read is a **display**. A sweep that
does not separate a display call from a payout reports both as mixed reads and inflates the
population.

**AND THE FOCUS HALF CANNOT BE READ THE SAME WAY, WHICH IS WORTH KNOWING BEFORE SOMEONE TRIES.**
`second_resource` is **five specs' currencies in one field**, so a raw read of it inside a Resonance
or a Faith branch is not a raw read of Focus at all; and `refresh_bars()` is a universal display
call, so a one-hop sweep on Focus returns **eleven** functions and **not one of them is the shape**.
**The Loyalty sweep is sharp because `loyalty` is Loyalty's alone.** Reported; ruled on nowhere.

---

## §5 — MEASURED: THE ROWS=9 URSUS ARM, BEFORE AND AFTER

**The brief's stated whole verification.** Same arms as EU §3, probe at the read site inside
`_comp_dmg_mult`, one sample per companion blow. **4,093 blows against EU's 4,074 — the arm
reproduces.**

**STRIKE STEP LOST, POOLED OVER BLOWS, against an unconverted meter:**

| kind | blows | mean Loyalty at the blow | **EU (split at 8)** | **EV (8 + fallback)** |
|---|---|---|---|---|
| **Ursus** | 228 | 18.31 | **40.17%** | **0.00%** |
| Canis | 3,791 | 17.07 | 35.77% | 35.77% |
| Aguila | 74 | 24.62 | 50.52% | 50.52% |
| **all blows** | 4,093 | 17.28 | **36.37%** | **34.04%** |

**THE BEAR'S ARM READS EXACTLY ZERO AND THE OTHER TWO ARE BIT-IDENTICAL ON BOTH SIDES**, which is
the shape the ruling predicts: only a clamped boon can pay nothing, and only the bear's is clamped.

**THE POOLED FIGURE REPRODUCES EU TO A THIRD OF A POINT** (36.37% here against EU's 36.70%, on an
independent 100-run sample), which is what licenses the comparison at all.

**AND THE GAIN SIDE HELD, WHICH IS THE CLAIM THAT MATTERS:**

| | over the 228 ursus blows |
|---|---|
| blows where the boon itself was **LOWER** under EV | **183** |
| blows where the **mitigation** term differed | **0** |
| blows where the **taunt** term differed | **0** |
| stacks returned to the strike step | **2,440 (10.70 a blow)** |

**The boon genuinely lost those stacks and genuinely paid the same.** A run in which the boon had
not fallen would have shown the same two zeroes for the wrong reason, which is why the first column
is reported beside them.

---

## §6 — VERIFICATION

### THE GATE

**`check_ev` — 54 checks, and every section is live**, because the brief names the failure exactly:
*a fallback that never fires, or fires for every stack, would both pass a static check.* Those are
not hypothetical shapes; they are the two ways `_bond_fallback`'s arithmetic goes off by one.

§0 the invariant (240 live readings) · §1 it fires, per stack, and declines the one-stack window ·
§2 it costs the boon nothing (counterfactual at 40 depths, then spent on real hits) · §3 the strike
step comes back, on real companion blows · §4 the wolf and the eagle never fall back · §5 the bot
mirror · §6 the raw-stack readers **at a saturated depth** · §7 the chip.

**§6 IS A QUESTION `check_eu` CANNOT ASK.** EU casts the four raw-stack readers at the untalented
fixture, where the fallback never fires. **The fallback moves stacks INTO the paid half**, so a
reader that had been on the wrong half would now pay MORE rather than less — a regression in the
opposite direction from the one EU guarded, and one EU's own arms sit below the saturation point and
cannot see.

**§3 IS THE SAME INSTRUMENT AS `check_eu` §1c AND IT ASSERTS THE OPPOSITE.** EU §1c requires
`point` and `point × 2` to deal IDENTICAL companion damage; EV §3 requires `point × 2` to
OUT-DAMAGE `point` at a saturated boon. **Both are true, at different depths, and the two gates
agreeing would mean one of them is wrong.**

### **§6a — SEVEN NEGATIVE CONTROLS. ALL SEVEN BIT.**

| # | injection | result | the arm that caught it |
|---|---|---|---|
| **0** | **HEAD's `battle.gd` verbatim** — the repair simply absent | **7 failures + SCRIPT ERRORs** | **§3 read ratio 1.0000 (131 vs 131) — EU's shipped behaviour** |
| 1 | the fallback never fires (`return 0`) | **14 failures** | every "it fires" arm and all four vacuity controls |
| 2 | fires for every converted stack (saturation ignored) | **8 failures** | **§1a's one-stack window at Loyalty 9** |
| 3 | one stack greedy (`keep - 1`) | **7 failures** | **§1b's exactness arm** |
| 4 | the stack pays BOTH halves (`_bond_converted` stops subtracting) | **8 failures** | **§0's live invariant — 49 violations of 240** |
| 5 | `_bot_boon_worth` left behind | 1 failure | §5, 20 disagreements over 30 |
| 6 | a read site back to a literal `0.10` | 1 failure | §0's constants arm |

**Control 0 is the two-armed one and it is the one that matters**: it proves the gate detects the
ABSENCE of the repair and not merely the presence of a function. **Controls 2 and 3 are both caught
by Loyalty 9 and by nothing else in the tree**, which is why that depth is pinned by name.

`battle.gd` was backed up to a scratchpad copy and **restored by `cp` after every control, md5
verified identical all seven times (`d8a5f2ca...`), never by `git checkout`.**

### **§6b — THE GATE'S OWN INSTRUMENT WAS WRONG ONCE, AND IT IS RECORDED IN THE FILE**

**§2b read 86 against 90 and looked exactly like a clamp that was not holding.** The mitigation was
provably identical (0.7500 in both arms) and the per-hit damages still differed — 7s and 8s in
different places, so the seeded stream had diverged.

**IT WAS NOT REASONED ABOUT, IT WAS RE-ORDERED.** Driving the arms as 24-then-12 read **86 against
90 again, in the same order** — and the third and fourth arms read identically to each other at both
Loyalty values. **It is the first pass through `_resolve` against a freshly spawned board**, not the
meter. A discarded warm-up arm is the whole fix, and the finding is written into the gate beside it
because `check_eu` was wrong twice for the same family of reason and recorded both.

### **§6c — THE PRE-CHECKS, WRITTEN BEFORE THE BATTERY**

- **`check_parse` — three identical standalone readings of 165**, RESIDUE unchanged at 4, and
  **the `Parse Error` grep is over stderr, never the tally**. The two measurement probes this batch
  drove the sims with were on **out-of-repo copies** and this walk never saw them.
- **`check_ev` — three identical standalone readings of 54 / 0.**
- **`check_da` 41 / 0, 0 hand-rolled walks, 1 exempt** — `check_ev` needs no §3 exemption: it goes
  through `gate_fixture.gd`, defines no `_spawn` and names neither draft-pool accessor.
- **`check_eu` 38 / 0 — its count is UNMOVED.** One assertion moved with the signature it pins.
- **`test_batch_ay` 486 / 0 — its count is UNMOVED.**
- **`test_batch_bl` 88 / 0, run WITH the battery's own `--fixed-fps 12`**, because it reads 88/4
  without it.
- **`check_ed` 18 / 0 — after being run against HEAD's manifest FIRST.** See §6d.

### **§6d — TWO INSTRUMENTS CAUGHT WHAT A DIFF COULD NOT**

**THE LITERAL SWEEP FOUND THREE NEEDLES THE REFACTOR BROKE.** Every string literal in the tree at a
floor of 4, tested for presence in each edited source before and after. `battle.gd` lost three, and
all three were assertions in `test_batch_ay`'s negative-control block:
`"var curve := 1.0 + _bond_step(hunter) *"`, `"return curve * 0.01 * hunter.menagerie"` and
`"minf(0.10 * sp_ursus, BOND_MITIGATION_MAX)"`. **A comment-stripped diff reads all three as
ordinary code movement.** All three were **re-pointed to intent, not deleted** — and two are now
asserted more strongly than before (the curve is pinned as a named function *and* as exactly one
line computing it; the mitigation is pinned to the named constant *and* its declaration).
**`test_batch_ay`'s count is unmoved at 486.**

**AND `check_ed`, RUN AGAINST HEAD'S MANIFEST BEFORE IT WAS REGENERATED, FOUND A COLLISION.** The
obvious name for `_bond_fallback`'s local count is a word `test_batch_bg` pins **ABSENT** from
`battle.gd` (Batch BH deleted a local of that name from the Conviction release branch). `bg`'s own
pin is slice-scoped to `_gain_faith` and **would not have gone red**; `check_ed`'s file-level scan
of the same needle does, and it is right to — it is conservative in the safe direction.
**The variable was renamed rather than the pin weakened.**

**AND THE COMMENT EXPLAINING THE RENAME TRIPPED IT A SECOND TIME**, because it named the word while
explaining why the word was not used. **Prose recording a removal reads exactly like the removal not
happening.** The comment is written without it now, and says so.

### **§6e — THE PREDICTED BASELINES, WRITTEN BEFORE THE RUN**

**A new gate owes TWO rows and both are written:**

| row | from | to | why |
|---|---|---|---|
| **`check_ev`** | — | **54 / 0** | new gate, off three identical standalone readings |
| **`check_parse`** | 164 | **165** | **this gate's count IS its coverage** — `check_ev` joined `GATES`, so a target joining the battery raises it the same day |

**Every other row is predicted UNMOVED**, including `check_eu` at 38 and `test_batch_ay` at 486 —
both were re-pointed in place. `baselines.json` was written at `indent=1`; the diff is 17 insertions
and 3 deletions, with no churn.

### **§6f — THE BATTERY. THE PREDICTION HELD EXACTLY.**

**`check_de` — 374 checks / 0 failures / 0 NOTICES.** Both moved rows certified on pass one, which
is what writing them before the run buys. **91 targets, and `sort .ran | uniq -d` holds ZERO
duplicates** — one battery wrote these logs, which EU could not say of its first run.

| | |
|---|---|
| **`Parse Error` across all 91 logs** | **0** — and the verdict is read off the grep, never off a tally |
| **`SCRIPT ERROR` across all 91 logs** | **0** |
| **the only red in the run** | **`check_cm_live` 13 / 4**, and its four FAIL lines were READ and confirmed to be the defensive-bar assertions its baseline row names: *the bar appeared on the enemy's attack*, *the bar's top line names the incoming blow*, *the brace lands near x0.85*, *the brace's Break half lands near x0.75* |
| **`check_parse`** | **165** — the predicted move, RESIDUE unchanged at 4 |
| **`check_ev`** | **54 / 0** — the predicted new row |
| **`check_eu`** | **38 / 0 — unmoved**, as predicted |
| **`test_batch_ay`** | **486 / 0 — unmoved**, as predicted |
| **run harness** | GATE 1 **22**, GATE 2 **166**, GATE 3 **8**, all PASS |

**THE TREE WAS FROZEN AND THE FREEZE WAS CHECKED RATHER THAN ASSERTED.** An md5 stamp of all 212
tracked source and document files was taken with **absolute paths** immediately before the launch
and again after. **Exactly two files differ: `docs/state.md` and the new `docs/reports/EV.md`** —
the two nothing in the tree loads. Every `.gd`, every `.json`, `run_battery.sh` and all four
asserted documents are byte-identical to what the battery read.

**AND THE POST-RUN DOC EDITS CARRY THEIR NEEDLE PROOF, AND THEN A RUN ON TOP OF IT.** §6g's
corrections were swept — every literal in the tree at a floor of 4 — against **the copy the battery
itself read**, kept aside for that purpose before the run: **0 LOST and 0 GAINED in all four
asserted documents.** **A sweep has holes a run finds, so the run was done too**: every target in
the tree that loads `CLAUDE.md`, `master.html`, `changelog.html` or `design-notes.md` — **36 of
them**, derived by grepping for the `res://` paths rather than listed — was re-run against the
edited documents. **All 36 clean, and all 36 report the IDENTICAL check and failure counts the
battery read**, which is the stronger statement: not merely green, but unmoved.

### **§6g — AN ANALYSIS OVER A LOG STILL BEING WRITTEN READS A PREFIX AND REPORTS IT AS THE RUN**

**§2's figures were measured twice and the first reading was wrong.** The three clamp arms were
launched in parallel and analysed while two of them were still running, so the analysis read a
prefix of each log and reported it as the whole 100-run arm. It was not obviously wrong — the shape
and the conclusion were identical — but every count and several rates were off:

| | first (truncated) reading | complete |
|---|---|---|
| rows 1–3, crit rolls | 36,888 | **53,677** |
| rows 1–3, at the ceiling | 128 (6.57%) | **199 (6.39%)** |
| rows 1–9, crit rolls | 28,156 | **34,785** |
| rows 1–9, at the ceiling | 450 (58.37%) | **521 (58.74%)** |
| rows 1–9, mean total crit | 1.965 | **1.931** |

**THE CONTROL IS `rows 0`, WHICH HAD ALREADY FINISHED WHEN THE FIRST READING WAS TAKEN: it is
bit-identical between the two** (40,746 rolls, 1,708 live, 4 at the ceiling). That is what proves
the difference is the truncation and not the analysis. **The figures in this report, in
`CLAUDE.md`, in `docs/state.md`, in `docs/design-notes.md` and in the changelog are the complete
ones**, and the sharper measurement the second pass added — **60.3% of every point of crit the eagle
delivers at rows 1–9 lands above the ceiling** — was not available from the prefix at all.

---

## §7 — WHAT MOVED, AND WHAT DELIBERATELY DID NOT

**MOVED:** `scripts/battle.gd` (two constants, four new helpers, `_bond_paid`/`_bond_converted`'s
signature, `_bond_mult` re-expressed through the shared curve and reach, six call sites, two read
sites re-pointed at the named constants, and the chip's fifth line); `check_eu.gd` (one literal,
count unmoved); `test_batch_ay.gd` (three controls re-pointed in place, count unmoved); the new
`check_ev.gd`; `run_battery.sh`; `baselines.json`; `pin-manifest.json`; `docs/master.html` and its
stamp; `docs/changelog.html`; `CLAUDE.md`; `docs/design-notes.md`; `docs/state.md`; this report;
and both `.docx` exports.

**DELIBERATELY DID NOT MOVE:**

- **NO CLAMP WAS RAISED.** §2 reports and prices `BOND_MITIGATION_MAX`; the designer rules.
- **NO RATE, NO CAP AND NO ACCRUAL MOVED.** `BOND_STEP` 0.20, the strike step's 0.05,
  `BOND_CONVERT` 8, `_gain_loyalty` and `_loyalty_cap` are all untouched. **The split stays at 8.**
- **NO RUNE IS AUTHORED.**
- **THE FALLBACK DOES NOT REACH AGUILA'S CEILING OR AN ABSENT BOON**, and both are reported at §2
  with their measurements rather than ruled on.
