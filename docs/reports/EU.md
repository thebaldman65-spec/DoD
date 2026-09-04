# BATCH EU — LOYALTY CONVERTS AT 8

**The conversion ER ruled is built. The split point is 8, it is the only magnitude this batch
chose, and it is a live constant rather than an instrument's reference point.** Below the point
nothing moved. Above it a Loyalty stack **stops adding to the companion's strike step and feeds the
Pack Bond boon instead**. **No cap, no rate change, no rune, no node, and not one byte written into
the accrual.**

**FIVE READ SITES CHANGED AND ER's OWN TABLE NAMES FOUR OF THEM.** `_bot_boon_worth` recomputes
`_bond_mult`'s curve so the bot can price a swap it has not made yet; ER §1d's payout census omits
it and EQ §1's has it. Left behind, it would have made the bot under-value exactly the deep bonds
the conversion pays most for — **and it would have drifted in silence, because nothing in the tree
compares those two functions.**

**THE COST IS REAL, IT IS MEASURED AT THREE LOADOUTS, AND ONE ARM DOES NOT SAY WHAT THE RULING
EXPECTED.** At rows=9 the two clamped consumers of the receiving half — Ursus's mitigation and
Savage Presence's taunt — gain **exactly zero**, because both were already at their clamps at every
sampled moment. `CLAUDE.md` required this batch to say which way those two clamps went. **They bind
harder at shallow and middling depth and they are already saturated at the deepest**, which is
sharper than the sentence the rule asked for. §4.

---

## THE BRIEF'S CLAIMS, RE-DERIVED

| claim | verdict |
|---|---|
| *"The split point is 8"* | **BUILT.** `const BOND_CONVERT := 8` beside `BOND_STEP`; `_bond_convert()` is the one place it is decided and `check_eu` §0 asserts that exactly ONE line in `battle.gd` reads the constant. |
| *"The boon was chosen on structural grounds: no new field and no new read site. Confirm that holds"* | **IT HOLDS, AND IT WAS CHECKED RATHER THAN ASSUMED.** `scripts/unit.gd` is untouched — zero new fields. **Every one of the five sites that now reads the split was ALREADY reading this meter**, so nothing gained a read it did not have; what they gained is `mini`/`maxi` around a number they already held. §2. |
| *"Each converted stack must return roughly 6.4% of a companion blow to break even"* (ER, at a split of 5) | **RE-MEASURED AT 8 AND IT BARELY MOVES, WHICH IS ITSELF THE FINDING.** 6.31% at first-clear, 4.03% untalented, 3.89% at rows=9. **The break-even is a property of the STEP, not of where the split sits** — it is `step / (1 + step x L)` — so moving the point changes how MANY stacks convert and hardly changes what each owes. §3. |
| *"a split at 8 converts far fewer stacks, so both the cost and the required return change"* | **HALF RIGHT, AND THE HALF THAT IS WRONG IS THE INTERESTING ONE.** The COST changes enormously — pooled loss 20.35% at a split of 5 (ER, rows 1–3) against **11.43%** at a split of 8 on the same arm. **The required return does NOT change materially**, for the reason above. |
| *"Report what a Beastmaster actually loses and gains at three loadouts … with n and standard error"* | **DONE, n = 1,623 / 2,120 / 2,460 battles and 6,317 / 7,263 / 4,074 companion blows.** §3. |
| *"EO's n=30 and EP's n=100 arms disagreed by fifteen points … the smaller was quoted three times"* | **HEEDED.** Every arm here is `--run 100`; the smallest per-battle standard error is ±0.05% and the largest ±0.28%. **The one figure taken at a small n is flagged as such** (§4's rows=9 mitigation sample is 102 casts). |
| *"Unleash, Primal Surge, Last Howl and Bring It Down all read the raw stack count … they keep reading raw stacks"* | **HOLDS, AND IS ASSERTED BY CASTING THEM RATHER THAN BY READING THEM.** `check_eu` §2 fires all four on a live board at two depths straddling the point. §2. |
| *"Nine payout sites take the conversion"* | **NINE READERS, FIVE SITES, AND THE TWO COUNTS ARE DIFFERENT THINGS.** Four of ER's nine (Canis, Ursus, the taunt, Aguila) reach the meter only THROUGH `_bond_mult` and needed no edit; one of the nine is the rate, which must not move. **The sites that needed editing are five, and `_bot_boon_worth` is the one ER does not list.** §2. |
| *"No cap, anywhere, ever … any cap below 8 makes Kindred — a row-8 node — unreachable"* | **HOLDS BY CONSTRUCTION AND IS ASSERTED BY GAINING.** `check_eu` §3 drives forty gains and requires forty stacks. **And the coincidence is asserted too**: the split point IS Kindred's threshold, so the stack that arms the node is the last stack that pays the strike. |
| *"There is no cliff at five … nothing is being layered on an existing threshold"* | **HOLDS AND IS UNDISTURBED.** The live curve was walked stack by stack from 0 to 20: it is smooth through 5 (x1.8, x2.0, x2.2) and the only inflection anywhere is at 8. |
| *"Bring It Down's hard cap binds on 41.5% of casts at rows 1–3"* | **REPRODUCES AT 43.0%** (52 of 121 casts, n=100 runs) — and it is **identical before and after the split**, because the card counts stacks. §4. |
| *"The game already limits Loyalty three times"* | **ALL THREE MEASURED BEFORE AND AFTER, AT ALL THREE LOADOUTS.** §4. |
| *"A silent second phase is a stat nobody knows they have"* | **ANSWERED ON SIX SURFACES**, and the chip names the point **below** it as well as above. §5. |

---

## §1 — WHAT WAS BUILT

**`const BOND_CONVERT := 8`**, beside `BOND_STEP` and documented there. Three functions:

```gdscript
func _bond_convert(_hunter: BattleUnit) -> int:      # the point — the ONE place it is decided
	return BOND_CONVERT

func _bond_paid(hunter: BattleUnit, l: int) -> int:      # focus_crit_chance's mini
	return mini(l, _bond_convert(hunter))

func _bond_converted(hunter: BattleUnit, l: int) -> int: # focus_crit_mult's maxi(..., 0)
	return maxi(l - _bond_convert(hunter), 0)
```

**THE TWO HALVES ARE DISJOINT AND SUM TO THE WHOLE METER.** That is what makes this a conversion
rather than a flattening: a stack is paid once, into one half or the other, and none is discarded.

**`hunter` IS UNREAD IN `_bond_convert` AND THE SIGNATURE IS THE POINT OF THE FUNCTION.**
`focus_convert()` is `maxi(FOCUS_CONVERT - deep_focus - rune_deep_focus, 1)` — per hunter, because
a node and a rune move it. Nothing moves Loyalty's yet and this batch authors neither, so the
parameter exists so that authoring one later is a change to **that one line** rather than to five
call sites and their suites. **`check_eu` §0 asserts exactly one line in the file reads the
constant**, which is the property that keeps a later split-point move from leaving a payout site
behind — `unit.gd`'s Focus block states that as its own reason for existing.

### THE RATE DID NOT MOVE, AND THAT IS ASSERTED IN THE DIRECTION THAT CAN BREAK IT

`BOND_STEP` is still `0.20`. The strike step is still `0.05 + 0.01 * (wild_communion_step +
rune_wild_communion_step)`. Absolute Devotion, Ancient Pact, Wild Communion and both runes are
untouched. **What moved is the COUNT each half is multiplied by.** `check_eu` §0 pins both rate
expressions at their source, because *"move the point, never the rate"* is a rule a batch could
satisfy in letter by steepening a half instead.

### WHY 8

Two reasons, and the second is the one that could not have been argued away.

**THE MEASURED ONE.** ER read Loyalty arriving at **10.08 ±0.12** at a first-clear loadout and
**6.64 ±0.09** untalented, against a nominal of 5. A split at 5 converts most of a typical meter;
this batch's own arms make that concrete — at a split of **8** the converted share of the blow's
own meter is **7.1% untalented, 24.1% at first-clear, 54.3% at rows=9**. It is nearly inert at the
bottom of the tree and continuous at the top, which is the six-to-one asymmetry EQ found for the
shapes this replaces.

**THE STRUCTURAL ONE. KINDRED IS A ROW-8 NODE KEYED TO 8 LOYALTY.** Any point below 8 puts a node
the player deliberately bought on the far side of a phase change they did not choose: they would
reach Kindred's threshold already inside the converted phase, having stopped buying strike damage
before the node that rewards the depth fires. At exactly 8 the two coincide, and `check_eu` §3
asserts the coincidence rather than trusting it — the two 8s came from different places and a later
batch moving either should be told.

---

## §2 — THE CENSUS: EVERY READ SITE, AND WHICH SIDE IT FALLS ON

**Derived from the shipped source with comments stripped**, not transcribed from ER's table.
Sixteen functions in `battle.gd` read this meter. **Five hold a split-reading line; eleven are
raw-only. Seven call sites read the split, three of them inside the chip.**

### THE FIVE THAT CONVERT

| site | what it is | what it reads |
|---|---|---|
| `_bond_mult` :13443 | the Pack Bond boon | **RECEIVES** — `l + _bond_converted(...)` |
| `_comp_dmg_mult` :21984 | the companion strike step | `_bond_paid(...)` |
| `_ghost_hit` :20845 | the bodiless blow's strike step | `_bond_paid(...)` |
| `_bot_boon_worth` :20486 | the bot's swap valuation | **RECEIVES** (mirrors `_bond_mult`) |
| `_stamp_loyalty_chip` :13529/13551/13553 | the chip's strike figure and phase line | `_bond_paid` / `_bond_converted` / `_bond_convert` |

**FOUR MORE READERS TAKE THE CONVERSION WITHOUT A LINE CHANGING**, because they reach the meter
only through `_bond_mult`: Ursus's mitigation (`:9438`), Canis's wounded bonus (`:9380`), Savage
Presence's taunt pull (`:7249`) and `_party_crit_bonus` (`:13566`). **That is why ER's "nine payout
sites" and this batch's "five edits" are both right and are not the same count.**

### THE RAW-STACK READERS, WHICH DO NOT CONVERT

**Eleven functions, and they are the thing most likely to be got wrong.**

| site | what it is |
|---|---|
| `_resolve_special` :18565 | **UNLEASH** — `0.20 x stacks x Attack`, the game's largest single Loyalty payout |
| `_resolve_special` :19047 | **PRIMAL SURGE** — `0.15 x stacks x Attack` per companion |
| `_on_beast_death` :21853 | **LAST HOWL** — banks `3 x` the meter the dying companion held |
| `_resolve_special` :18735 | **BRING IT DOWN** — `min(stacks x 2, 20)` points, party-wide |
| `_resolve_special` :16021 | Kill Command's Canis Bleed, `10 + 2 x stacks` |
| `_resolve_special` :18963 | Devoted Fury's Wrath extension |
| `_ghost_hit` :20858 / `_companion_strike` :20896 | **Aguila's armor pierce and Canis's Bleed** — both off the raw `l` read at :20838 and :20896, beside the paid half at :20845 |
| `_stamp_loyalty_chip` :13512 | the three companion gifts on the chip |
| `_row8_turn_start` :3488 | **Kindred's gate** (`>= u.kindred`) |
| `_ability_usable` :5975/:5987 | the two spender doors |
| `_do_summon` :20612-20648 | Succession, None Left Behind, Lone Bond |
| `_gain_loyalty` / `_loyalty_cap` :13479/:13484 | **the accrual and the ceiling** |
| `_deepest_bond` :20462, `_swap_victim` :20570, `_autoplay_pick_kit` :4775, `_cy_sample` :14755 | selection and instruments |

**`check_eu` §3 asserts that `_gain_loyalty` and `_loyalty_cap` contain no reference to the split at
all** — not `_bond_paid`, not `_bond_converted`, not `BOND_CONVERT`. That is the property
`CLAUDE.md` calls *"the whole reason the shape was ruled"*, stated in the direction that can break.

### **TWO FUNCTIONS HELD BOTH KINDS OF READ IN ONE VARIABLE, AND THAT IS THE SHAPE TO LOOK FOR NEXT**

`_ghost_hit` used a single `l` for its strike step **and** for Aguila's armor pierce. A conversion
applied at the top of the function would have converted the pierce as a side effect — silently, and
with nothing in the tree to notice. It now reads `l` for the pierce and `paid` for the step, and
`check_eu` §2 asserts the two apart at their source. `_companion_strike` is the same shape for
Canis's Bleed. **The read site is the line, not the function.**

---

## §3 — WHAT IT COSTS AND WHAT IT BUYS, MEASURED

**Three arms, `--run 100` each, `DOD_SIM_DIFFICULTY=warden` (rung 2), `DOD_SIM_ROUTE=balanced`,
specs `berserker,cryomancer,inquisitor,beastmaster` — ER's arms exactly, so the figures are
comparable with its own.** The loss probe sits **inside `_comp_dmg_mult` at the read site**, one
sample per companion blow, which is ER's arm B. The gain probes sit at the four places the boon is
actually **spent**, not at `_bond_mult` itself — a multiplier nobody spends is not a measurement.
**Every probe is on an out-of-repo instrumented copy; not one executable byte of the shipped tree
carries one.**

**AND THESE THREE ARMS ARE THEMSELVES THE LIVE DRIVE THE BRIEF ASKS FOR.** §6's requirement is to
drive the split at all three loadouts, because *"a split point that never fires, or fires on the
wrong side, would pass every static check."* **It fires at all three, confirmed at the read site
rather than inferred**: the converted-stack count at the blow is 0.34, 1.81 and 9.44, and the
strike-step loss is non-zero on every arm. `check_eu` proves the split is in the right PLACE on a
controlled fixture; these arms prove it is reached in ordinary play at every depth a player
occupies. **The untalented arm is the one that could have read zero and does not.**

### THE LOSS — THE COMPANION STRIKE STEP

| arm | rows | n battles | blows | mean Loyalty at the blow | converted stacks | converted share of the meter |
|---|---|---|---|---|---|---|
| untalented | 0 | 1,623 | 6,317 | 4.84 | 0.34 | **7.1%** |
| first-clear | 1–3 | 2,120 | 7,263 | 7.52 | 1.81 | **24.1%** |
| fully talented | 1–9 | 2,460 | 4,074 | 17.40 | 9.44 | **54.3%** |

| arm | strike step lost, **pooled over blows** | strike step lost, **per battle** | break-even per converted stack |
|---|---|---|---|
| untalented | **1.38%** | 0.70% ±0.05% | 4.03% of a companion blow |
| first-clear | **11.43%** | 7.02% ±0.19% | **6.31%** of a companion blow |
| fully talented | **36.70%** | 29.68% ±0.28% | 3.89% of a companion blow |

**BOTH SUMMARIES ARE PRINTED AND THEY WEIGHT DIFFERENTLY**, exactly as ER's did: the pooled figure
weights a battle by how many blows it contained and is the honest answer to *"what does the
Beastmaster lose"*; the per-battle mean carries the standard error.

**THE SPLIT AT 8 COSTS ROUGHLY HALF WHAT A SPLIT AT 5 COSTS, ON THE SAME ARM.** ER measured 20.35%
pooled at nominal, rows 1–3; this reads **11.43%** at 8. The mean Loyalty at the blow reproduces ER
to two decimals (7.52 here against ER's 7.44), so the arms are the same population and the
difference is the point.

**AND THE BREAK-EVEN BARELY MOVED, WHICH THE BRIEF DID NOT EXPECT.** The brief asked for it to be
re-measured on the reasoning that *"a split at 8 converts far fewer stacks, so both the cost and the
required return change."* **The cost does; the required return does not**, and there is an algebraic
reason rather than a coincidence. The pooled loss is `s·c / (1 + s·L)` for a step `s`, a meter `L`
and `c` converted stacks, so the loss **per converted stack** is `s / (1 + s·L)` — the value of one
stack's worth of step against the multiplier it sits in. **The split point cancels out of it
entirely.** It depends on the STEP and on how deep the meter runs, not on where the line was drawn.

**THE ALGEBRA WAS CHECKED AGAINST THE MEASUREMENT RATHER THAN ASSERTED, AND IT REPRODUCES ALL THREE
ARMS TO TWO DECIMAL PLACES:**

| arm | live step | mean Loyalty at the blow | measured break-even | `s / (1 + s·L)` |
|---|---|---|---|---|
| untalented | 0.05 | 4.84 | **4.03%** | **4.03%** |
| first-clear | 0.12 | 7.52 | **6.31%** | **6.31%** |
| fully talented | 0.12 | 17.40 | **3.89%** | **3.89%** |

**THAT ALSO CONFIRMS ER §1c's CORRECTION FROM THE OTHER SIDE.** ER found that EQ had priced its loss
table at the BASE step of 0.05 when every arm at rows ≥ 1 wears Wild Communion and runs at 0.12.
The formula only reproduces these arms at 0.12 for rows 1–3 and 1–9 and at 0.05 for rows 0 — so the
live step is confirmed by three independent readings rather than by reading the tree.

ER's 6.42% at a split of 5 and this batch's 6.31% at a split of 8 are the same number, and the small
difference is the mean Loyalty at the blow (7.44 against 7.52), not the split.

### THE GAIN — MEASURED WHERE THE BOON IS SPENT

| consumer | clamp? | untalented | first-clear | fully talented |
|---|---|---|---|---|
| **Canis** — wounded-prey bonus | none | +4.95% | **+23.19%** | **+62.63%** |
| **Aguila** — party crit | none | +2.12% | **+15.42%** | **+48.96%** |
| **Ursus** — Savage Presence mitigation | 0.75 | +0.88% | +2.18% | **+0.00%** |
| **Savage Presence** — taunt pull | 1.0 | +1.77% | +2.85% | **+0.00%** |

**THE TWO ZEROES AT ROWS=9 ARE THE BATCH'S SHARPEST FINDING AND THEY ARE NOT ROUNDING.** Both sums
are bit-for-bit identical across the arm. At that depth every sampled mitigation and taunt was
either shallow enough that no stack had converted, or already at its clamp in **both** arms — so
the converted stacks bought nothing at all on those two terms.

**WHAT THAT MEANS IN PLAY, STATED PLAINLY: A FULLY TALENTED BEASTMASTER FIELDING URSUS LOSES 36.7%
OF HIS COMPANION'S STRIKE STEP AND GAINS NOTHING.** The same hunter fielding Canis gains +62.6% on
the term that is his damage, and fielding Aguila raises every hero's crit by half again.
**The conversion's value at depth is a function of which beast is standing**, and that was not
anticipated anywhere in ER, EQ or the brief. **It is reported and NOT fixed**: the fix would be
moving a clamp, and both clamps are load-bearing guards rather than magnitudes —
`BOND_MITIGATION_MAX` exists so that mitigation cannot cross zero and start healing the hunter off
enemy attacks. **That is a designer's decision and it is now priced.**

---

## §4 — THE THREE EXISTING LIMITS, BEFORE AND AFTER

**The brief asks how the split interacts with each rather than assuming it sits above them
cleanly. It does not sit above them cleanly.**

| limit | arm | bound BEFORE | bound AFTER | reading |
|---|---|---|---|---|
| **`BOND_MITIGATION_MAX` 0.75** | rows 0 | 0 / 626 | 0 / 626 | unreachable either way |
| | rows 1–3 | 2 / 575 | **4 / 575** | **binds twice as often** |
| | rows 1–9 | 22 / 102 | 22 / 102 | **already saturated — n=102, small** |
| **Savage Presence taunt clamp 1.0** | rows 0 | 0 / 1400 | **3 / 1400** | **from unreachable to binding** |
| | rows 1–3 | 7 / 1401 | **33 / 1401** | **binds 4.7x as often** |
| | rows 1–9 | 221 / 471 | 221 / 471 | **already saturated** |
| **Bring It Down's hard cap (20 points)** | rows 0 | 18 / 156 = 11.5% | 18 / 156 | **identical — it counts stacks** |
| | rows 1–3 | 52 / 121 = **43.0%** | 52 / 121 | **identical** (EQ read 41.5%) |
| | rows 1–9 | 29 / 65 = 44.6% | 29 / 65 | **identical** |

**THE SENTENCE `CLAUDE.md` SAYS THE BUILDER OWES, ANSWERED WITH ITS EVIDENCE: THE TWO CLAMPS BIND
HARDER AND NEITHER BECOMES A DEAD CONSTANT.** That is the opposite of what capping `_bond_mult` at
nominal would have done, which by AR §4's rule would have made both unreachable at every talent
depth. **But the rule's binary framing does not survive the measurement.** The truthful version is
in three parts:

- **At shallow and middling depth they bind harder** — the taunt clamp goes from never binding to
  binding, and from 0.5% of pulls to 2.4%.
- **At rows=9 they were ALREADY saturated**, so the conversion adds nothing to how often they bind
  and nothing to what they pay. The clamp, not the conversion, is what governs that half at depth.
- **Bring It Down is untouched at every loadout**, and that is a measurement rather than an
  inference: 156, 121 and 65 casts, identical counts on both sides. It counts stacks; the split
  changes what a stack pays.

### **AND THE TWO ROWS=9 ZEROES WERE PROVED RATHER THAN EXPLAINED**

An exactly-zero delta across 102 samples is the shape of an instrument fault, not of a finding, so
it was not left to reasoning. **A second probe recorded the Loyalty at every mitigation sample and
counted the samples where the conversion changed the term at all.** On a 30-run rows=9 arm: **17
samples, 0 where the term differed**, and the histogram is `{6: 13, 10: 3, 14: 1}`.

**THE DISTRIBUTION IS BIMODAL AND THE GAP IS ONE STACK WIDE.** At rows=9 the boon step is 0.70 a
stack (Absolute Devotion + Ancient Pact), so `0.10 x _bond_mult >= 0.75` needs a count of 11.
Unconverted that is Loyalty 11; converted (`2L - 8` above the point) it is Loyalty 10. **So the only
depth at which the conversion changes this term at all is Loyalty 9** — 0.75 clamped against 0.73
unclamped — and every sample landed either below the point (6, no conversion, identical by
construction) or above 10 (clamped in both arms, identical by clamp). **Not one sample landed on 9.**

**THAT IS WHY THE ZERO IS REPORTED AS A FINDING RATHER THAN AS A RATE.** It is not that the
conversion pays a little into Ursus's mitigation at depth; it is that at a fully talented boon step
the clamp is crossed almost immediately past the split, so the term has **at most a one-stack window
in which the conversion means anything**. The taunt clamp is the same shape with a wider sample (471
casts) and the same zero.

**THE ROWS=9 MITIGATION ROW RESTS ON 102 CASTS AND IS FLAGGED FOR IT.** The count should not be
quoted as a rate; the mechanism above is what the row is evidence for.

---

## §5 — IT IS VISIBLE

**Six surfaces name the second phase, and no promise was retracted** — the meter really does stay
uncapped, which is why this cost less text than any of EQ's four flattening shapes would have.

| surface | what it now says |
|---|---|
| **the Loyalty chip** (`_stamp_loyalty_chip`) | a fourth line: *"CONVERTS at 8: stacks past it feed the / boon instead of the strike (N converted)."* |
| `STATUS_INFO["loyalty"]` | *"Past 8 the meter CONVERTS: further stacks / feed the boon instead of the strike."* |
| `Classes` `passive_desc` (Pack Bond) | *"PAST 8 THE METER CONVERTS: further stacks stop adding to the strike and feed the boon instead."* |
| `master.html` Beastmaster block | a full paragraph, including that the four raw-stack readers are untouched |
| `master.html` Loyalty chip row, Unleash row, Bring It Down row | the phase, and why the split does not reach the two cards |
| `data/glossary.json` — `res_loyalty` and `pack_bond` | both halves, with the x3.4 / x7.4 figures |

**THE CHIP PRINTS THE LINE BELOW THE POINT AS WELL AS ABOVE IT.** A phase a player only learns
about by crossing it is still a surprise, and `unit.gd`'s Focus nameplate — the precedent
`CLAUDE.md` cites — shows its second half at zero Focus. `check_eu` §4 asserts both depths.

**AND THE CHIP'S STRIKE FIGURE MOVED WITH THE MECHANIC.** It reads `_bond_paid` now. A chip still
multiplying by the whole meter would have printed a strike bonus the companion does not have, which
is **worse** than a silent phase: a silent phase is a stat nobody knows about, and a wrong figure is
a stat the game visibly disagrees with. `check_eu` §4 asserts the printed figure equals the paid
half and is the same at the point as five stacks past it.

**THE LINE CANNOT OUTGROW THE CHIP, AND THAT WAS MEASURED RATHER THAN EYEBALLED.** The live count
is a parenthetical rather than the sentence's subject, so the number and the verb cannot disagree at
one stack. Enumerating every line either block can produce at its widest substitution: **the new
block reaches 43 characters** at a three-digit converted count, against **an existing widest of 37**
(the Pack Bond boon line at a three-digit multiplier). Six characters wider than what the chip
already carries, and the count is the only part that grows.

**THIS PARAGRAPH FIRST SAID 41 AND 36, AND BOTH WERE WRONG.** They were counted by hand. The
battery had already started when the arithmetic was re-done in code; **it was killed six targets in
and restarted rather than letting a wrong number ship inside a comment**, because a comment naming
a measurement is a claim and this project's own rule is that it rots the same way a number does.

**`CY_METERS`' 5 WAS DELIBERATELY NOT REPOINTED AT `BOND_CONVERT`.** It means *where the boon reads
x2*, which is still true and is the denominator every arrival figure from EQ, ER and this batch is
quoted against. Repointing it would have silently broken comparability with every prior reading of
this meter. The header there now says so, so a later reader cannot conflate the two numbers.

---

## §6 — VERIFICATION

### THE GATE

**`check_eu.gd` — 38 checks, and every section is live.** The brief names the failure it exists
for: *"a split point that never fires, or fires on the wrong side, would pass every static check"* —
DS's Heads Down shape. §0 is the only source half and asserts the one property a live test cannot
see (exactly one line reads the constant). §1a and §1b read the two halves off a spawned battle at
four depths straddling the point, asserting the **ratio** rather than today's 0.20 so the gate stays
true at every talent depth. **§1c measures real companion blows** — twelve seeded strikes at the
point and at twice the point, required **equal as integers** rather than within a tolerance, with a
below-the-point control arm proving the instrument still moves. §2 **casts** all four raw-stack
readers. §3 asserts no cap by *gaining*, that the split point is Kindred's threshold, and that the
accrual functions never mention the split. §4 asserts the chip at both depths.

### **§6a — THE FIVE NEGATIVE CONTROLS. ALL FIVE BIT.**

Each was armed on something the gate demonstrably reads, each injection **replaced** rather than
extended (a `contains` needle that is merely extended still matches), and every restore was by `cp`
from a scratchpad backup and verified **md5-identical** — never by `git checkout`.

**THE DISARMED STATE WAS CONFIRMED GREEN BEFORE EACH ARMING — 38 / 0 — AND THE BRIEF'S WORDING IS
WORTH NAMING.** It asks to *"confirm the disarmed state is red first"*. The property that makes a
control mean anything is **green disarmed, red armed**: a check already red before the injection
proves nothing, because the red it then shows is not the injection's. Confirming red first is the
discipline that belongs to a **repair** — arm the same injection against the unrepaired tree, so
you have not merely proved the new code works (that is EU's own memory of a control that was armed
in the wrong direction and passed both arms). **Nothing here is a repair**, so the green-first form
is the one that applies, and it is what was run.

| # | injection | expected | **observed** |
|---|---|---|---|
| 1 | `_comp_dmg_mult` reads the raw meter again (the conversion never fires) | §1a, §1c red | **2 failures** — §1a flat-test, and §1c at ratio **1.2891** |
| 2 | `_bond_mult` does not receive (a flattening, not a conversion) | §1b red | **1 failure** — "0.2000 vs 0.2000 below" |
| 3 | **Unleash re-pointed at `_bond_paid`** | §2 red | **1 failure** — ratio **1.0000** where 2.0 is required |
| 4 | the chip's phase line deleted (a silent second phase) | §4 red | **2 failures** — the below-point line and the converted count |
| 5 | `BOND_CONVERT` 8 → 9 (fires on the wrong side) | §0, §1, §3 red | **3 failures** — including *"the live split point reads 8 (got 9)"* |

**CONTROL 5 IS THE ONE THAT MATTERS MOST** and it is not a deletion. A boundary assertion very
easily proves only that *a* split exists; moving the point by one proves the gate reads **where** it
is. **CONTROL 3 IS THE ONE THE BATCH IS ABOUT** — it is the silent failure §2 exists to catch, and
it is caught by a cast rather than by a source read.

### **§6b — THE GATE'S OWN INSTRUMENT WAS WRONG TWICE, AND BOTH ARE RECORDED IN THE FILE**

**Neither draft failed loudly. Both printed a number.**

- **THE FIRST DROVE CANIS AND READ A RATIO OF 1.5000 WITH THE STRIKE STEP PROVABLY FLAT.** Canis's
  blow also lays Bleed at **+2 per RAW stack** — a reader this batch deliberately did not convert —
  and against a body with 1e8 max health the bleedout (a percentage of max HP) dwarfed the strike.
  **The instrument was measuring the one term §2 exists to keep raw.**
- **THE SECOND SWITCHED TO URSUS AND STILL READ 1.0315.** The bear mauls adjacent enemies too, and
  an adjacent raider that dies in one arm and survives in the other consumes a different number of
  draws from the seeded stream — so the arms differed by the **roll** rather than by the meter.

Narrowing the field to one standing body fixed it. **The assertion is now integer equality**, because
a tolerance wide enough to absorb a desynchronised stream is wide enough to hide a real one-stack
slip in the split.

### **§6c — THE PRE-CHECKS, WRITTEN BEFORE THE BATTERY**

Every target that reads a string this batch moved was run standalone first, with the battery's own
three-shape verdict grep rather than a single-shape one.

| target | reading | baseline |
|---|---|---|
| `test_batch_ay` | 486 / 0 | [486, 486] — **re-pointed in place; the count did not move** |
| `test_batch_az` | 519 / 0 | [519, 519] |
| `test_batch_bb` | 177 / 0 | [177, 177] |
| `test_batch_bo` | 1140 / 0 | [1140, 1140] |
| `test_batch_bv` | 864 / 0 | [864, 864] |
| `test_batch_bx` | 161 / 0 | [161, 161] |
| `test_batch_cp` | 697 / 0 | [697, 697] |
| `check_cs` / `check_dm` / `check_ec` / `check_el` / `check_et` | 104 / 93 / 23 / 23 / 23, all 0 failures | all exact |
| `check_da` | 41 / 0 | **no §3 exemption needed** — 45 gates, 0 hand-rolled `_spawn` |
| `check_ed` | 18 / 0 | run against **HEAD's** manifest before regenerating |

**THE DOC NEEDLE SWEEP.** Every literal any suite pins into `CLAUDE.md`, `master.html`,
`changelog.html`, `glossary.json`, `design-notes.md` and `state.md` — **257 needles** — was counted
before and after the documentation edits. **Three moved and all three ROSE on generic structural
literals** (`</h2>` 40→41, `<code>` 1451→1473, `(Batch ` 21→22), which is this batch's own changelog
entry and master.html paragraph. **The population was then grepped for an INTEGER pin on each**,
because a count is invisible to a string sweep: `check_dv` §4's changelog-entry assertion is a
**floor** (`>= 16`, repaired at DW after DV pinned an equality that its successor broke), and
`(Batch ` is read with `.find()` on the stamp rather than counted. **No assertion changed colour.**

### **§6d — TWO BATTERIES RAN AT ONCE AND THE RUN WAS DISCARDED. THIRD OCCURRENCE.**

**`run_battery.sh`'s own header calls this "a silent data fault", and the lock exists to prevent it.
The lock did not fail; the procedure around it did.**

The first battery was stopped to correct a hand-counted width figure (§5). `pkill -f
run_battery.sh` **matched the backgrounded wrapper** — `./run_battery.sh > log; echo "BATTERY EXIT
$?"` — and killed that, which reported an exit code and **looked exactly like a successful kill**.
The real script was re-parented to PPID 1 and kept walking the target list. Godot was then checked
and one genuine orphan killed by PID, reaching zero; **the SCRIPT was never re-checked**, and the
lock was removed by hand so the restart could proceed. Two batteries wrote `/tmp/dod_battery` for
thirteen minutes.

**THE FIRST TELL WAS ALMOST EXPLAINED AWAY.** A Godot running `test_batch_bk.gd` at 100% CPU while
the log already recorded `bk` as finished reads exactly like a completed run that failed to exit —
a known and harmless shape in this project. **The decisive check is `sort .ran | uniq -d`**, which
held **17 duplicate target names**.

**EVERY COUNT FROM THAT RUN WAS DISCARDED** — with two processes writing one log directory, each
target's count is whichever process finished last. The tree was untouched throughout, both scripts
and every Godot were killed and confirmed **by two separate checks** (`pgrep -f run_battery.sh` at
0 **and** `ps aux | grep '[G]odot'` at 0), `/tmp/dod_battery` was removed, a fresh freeze stamp was
taken, and the battery reported below is a single clean run launched under `nohup` — confirmed at
exactly one `run_battery.sh` process after launch, and with `.ran` carrying no duplicate.

### **§6e — THE PREDICTED BASELINES, WRITTEN BEFORE THE RUN**

**Prediction: exactly TWO rows move, both already written into `baselines.json` before the battery
was invoked.**

- **`check_eu` — a new row, `[38, 38]` / `[0, 0]`**, off three identical standalone readings.
- **`check_parse` 163 → 164**, off three identical standalone readings. **A new gate owes TWO rows
  and this is the second**: that gate's population is derived from `run_battery.sh`, so its count IS
  its coverage and a target joining the battery raises it the same day.

**Every other row is predicted NOT to move**, and the reason is per-file rather than general: the
only suite whose assertions this batch changed is `test_batch_ay`, and it was re-pointed in place
with no assertion added or removed.

### **§6f — THE BATTERY. THE PREDICTION HELD EXACTLY.**

**`check_de` — the count differ, a post-pass over the run's own logs — read 370 checks / 0 failures
/ 0 NOTICES.** Zero notices means every count and every band held, including the two rows this batch
moved; a rise it had not been told about would have printed one.

| | reading |
|---|---|
| **THE FLOOR** — `Parse Error` grepped from **every target's stream**, never a tally and never an exit code | **0 logs contain one**, across all 90 |
| `check_parse`'s tally, read separately as a coverage ratchet | **164 / 0**, against its `[164, 164]` written before the run |
| **`check_eu`** | **38 / 0**, against its `[38, 38]` written before the run |
| `test_batch_ay` | **486 / 0** — the re-pointing moved no count |
| `check_ed` (source pins), `check_da` (corpus rule) | 18 / 0 and 41 / 0 |
| run harness, gates 1/2/3 | **22 / 166 / 8**, all PASS, 0 throws |
| **reds, in the whole battery** | **exactly one** |
| timeouts | **none** |
| throws | **none, on any target** |

**THE ONE RED IS `check_cm_live` AT 13 / 4, AND IT IS THE RECORDED CAUSE RATHER THAN A COUNT THAT
MATCHES.** `CLAUDE.md`'s rule is that a known red is a place a second red can hide, so the four FAIL
lines were read rather than counted: *"the bar appeared on the enemy's attack"*, *"the bar's top
line names the incoming blow"*, *"the brace lands near x0.85"*, *"the brace's Break half lands near
x0.75"*. **All four are the defensive-bar assertions its row names** — *"THE ONE RED THAT IS ON
PURPOSE … the only thing pressing the defensive bar"*. Nothing else is hiding behind it.

**AND `test_rune_battle` READ 97 / 0.** ER's re-pointed occultist assertion holds, and the
pyromancer flake did not fire on this run.

**THE RUN'S INTEGRITY WAS CHECKED BEFORE ITS RESULTS WERE BELIEVED**, which §6d is the reason for:
one `run_battery.sh` process, **`.ran` carrying 90 entries, 90 unique names and 90 matching logs**,
and no duplicate.

**THE FREEZE HELD FOR EVERY FILE THE BATTERY READS.** An md5 stamp over all 193 tracked `.gd`,
`.md`, `.html`, `.json` and `.sh` files, taken with absolute paths before the run and again after,
differs in **one file: `docs/reports/EU.md`** — this document, gaining §6d. **No battery target reads
any report**, verified by grep rather than assumed (every mention of `docs/reports/` in a target is
inside a comment), and the pin manifest carries **zero** needles into `docs/state.md` or any report.

---

## §7 — WHAT MOVED, AND WHAT DELIBERATELY DID NOT

| file | what |
|---|---|
| `scripts/battle.gd` | `BOND_CONVERT`; `_bond_convert` / `_bond_paid` / `_bond_converted`; five read sites; the chip's phase line and strike figure; `STATUS_INFO["loyalty"]`; the `CY_METERS` header |
| `scripts/classes.gd` | the Pack Bond `passive_desc` |
| `test_batch_ay.gd` | five boon-curve assertions **re-pointed in place**, count unmoved |
| `check_eu.gd` | **new** |
| `run_battery.sh` | `check_eu` joins `GATES` |
| `baselines.json` | the `check_eu` row; `check_parse` 163 → 164 |
| `pin-manifest.json` | regenerated — **+4 pins, all `check_eu` §0's, all resolving** |
| `docs/master.html` | the Beastmaster block, the chip row, Unleash's row, Bring It Down's row, the stamp |
| `data/glossary.json` | `res_loyalty` and `pack_bond` |
| `CLAUDE.md` | the standing rule rewritten as BUILT; the governor table's Loyalty row; the three owed sentences answered |
| `docs/changelog.html`, `docs/design-notes.md`, `docs/state.md`, `docs/reports/EU.md` | this batch |

**NOT DONE, STATED SO THE BATCH IS NOT READ AS CLEAN:**

- **NO RUNE WAS AUTHORED.** ER §2 established that a re-authored Deep Bond is `Rune of the Deep
  Sight`'s exact shape and that its direction was undecidable until the currency was chosen.
  **The currency is chosen now, so ER §2c's table resolves**: the converted half is worth more than
  the strike step at depth, so such a rune moves the point DOWN — Deep Focus's shape. **This batch
  does not write it** (ET §1 retired the pool; rune content is written with the designer), and
  `_bond_convert`'s signature is the slot it will occupy.
- **NO NODE, NO CAP, NO RATE AND NO MAGNITUDE MOVED** other than the new constant itself.
- **`CY_METERS`' DENOMINATOR WAS NOT REPOINTED** — §5, with the reason.
- **THE TWO CLAMPS WERE NOT TOUCHED.** §3's rows=9 finding is a reason to look at them and is
  **reported, not acted on**: both are guards rather than magnitudes, and moving one is a design
  decision this batch has no mandate for.
- **THE ROWS=9 MITIGATION SAMPLE IS 102 CASTS** and its rate is flagged rather than quoted.
- **NOTHING WAS MEASURED AT RUNG 1 OR RUNG 3**, and nothing on a non-devotion Beastmaster lane —
  the sim's Beastmaster wears the devotion lane, so these are the steepest-curve readings the
  default harness produces. A Beastmaster who never takes Absolute Devotion converts against a
  shallower boon and this batch did not measure him.
- **EQ's §2 LOSS TABLE IS STILL NOT REGENERATED**, as at ER.
