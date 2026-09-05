# BATCH EW — CRIT CHANCE ABOVE CERTAINTY BECOMES CRIT MULTIPLIER

**Ruled and built: a total crit chance over 100% cannot make a hit more certain, so the surplus is
paid as critical DAMAGE instead — from every source, game-wide.**

EV §3 measured the waste and correctly reported rather than fixed it. `randf() < crit_chance` has no
`minf` anywhere near it, so nothing ever *clamped* crit chance — and yet everything past 1.0 bought
exactly nothing. **That is the quietest kind of ceiling there is**: it appears in no constant, it
appears in no diff, and every instrument that looks for clamps walks straight past it.

---

## THE BRIEF'S CLAIMS, RE-DERIVED

**The brief said to verify every premise. Two moved, one materially.**

| the brief's claim | what the tree and the arms say |
|---|---|
| *"at rows 1–9 **the party's mean total crit is 1.93** — nearly double a certainty"* | **THE FIGURE IS OVER A DIFFERENT POPULATION THAN THE SENTENCE NAMES, AND IT IS THE BATCH'S SHARPEST CORRECTION.** 1.93 is EV's mean over the rolls where **Aguila's boon is LIVE**, and those are **2.6% of the heroes' rolls**. On its own population it reproduces: **mean 2.170, max 12.24, 55.81% at or over a certainty, 65.6% of the boon above the ceiling** (EV read 1.931 / 15.85 / 58.74% / 60.3% on different seeds). **Over EVERY hero roll the mean total crit at that arm is 0.172 and only 1.47% are at or past 1.0.** §1a. |
| *"58.7% of live-boon rolls are already at or past 1.0"* | **CORRECTLY QUALIFIED IN THE BRIEF AND IT REPRODUCES** — 55.81% here. This is the one figure the brief attaches to the right population. |
| *"60.3% of every point of crit Aguila delivers lands above the ceiling"* | **REPRODUCES AND IS SLIGHTLY WORSE — 65.6%.** |
| *"at rows 1–9 the mean excess is 0.93 of a certainty, so this converts a very large surplus"* | **TRUE OF THE LIVE-BOON ROLLS AND NOT OF THE PARTY.** The mean excess over live-boon rolls is 1.17; over every hero roll it is **0.0075**, because 98.5% of rolls are nowhere near the ceiling. **The surplus converted is therefore small in aggregate and very large on the blow that carries it.** §1. |
| *"the ceiling is shared with every other crit source"* | **CONFIRMED, AND IT IS WHAT DECIDED THE BUILD.** On **zero** rolls at any arm was the total already at 1.0 without the eagle's contribution, so no source is ever the wasted one — which is why the conversion reads the assembled TOTAL and no source is told what share of the ceiling belongs to it. §0. |
| *"Focus converts at 100 from crit chance to crit multiplier. This generalises it from one meter to the total."* | **CONFIRMED, AND THE RATE IS 1:1.** `FOCUS_STEP` buys 0.005 of chance below the split and 0.005 of multiplier above it, so Focus already trades one for one. `CRIT_EXCESS_STEP` ships at that rate and is deliberately not derived from it. §1. |
| *"there must be exactly one such place"* | **THERE ARE FOUR, AND THAT IS §0's FINDING.** Reported before anything was built, as the brief instructed. |
| *"`BOND_MITIGATION_MAX` … 0.90 would make it 90%"* | **CONFIRMED.** The constant is read as `minf(SAVAGE_MITIGATION_STEP × boon, BOND_MITIGATION_MAX)` and is a damage-reduction fraction. §3. |

---

## §0 — THE ROLL HAPPENS AT FOUR SITES, NOT ONE

**The brief required the conversion to sit after assembly and before the roll, at exactly one place,
and said that if the roll happens in more than one site that is the finding and it is reported
before anything is built. It does. This is that report.**

| site | what it assembles | terms | deepest total measured |
|---|---|---|---|
| `_resolve`'s strike loop (`battle.gd:8684`) | the base (or Pommel Strike's 0.25), a Broken target's +0.25, Resonance, `crit_bonus`, **Aguila's shared boon**, Precision Strikes, Seasoned Fighter, Killing Edge, Super Nova (rune-only), Brittle Ice, the Sweeping Strikes rider, Lethal Aim's sub-split Focus and Tunnel Vision | **12** | **12.24** |
| `_heal_crit_mult` | base + `crit_bonus` | 2 | **n = 0** at all three arms |
| `_ghost_hit` (Call of the Wild) | base + `crit_bonus` + Broken | 3 | **0.37** |
| `_companion_hit` | base + `crit_bonus` + Broken | 3 | **0.37** |

**ONLY THE STRIKE LOOP CAN PASS A CERTAINTY, AND THAT IS MEASURED RATHER THAN ARGUED.** Over
**202,000 crit rolls** at three loadouts, the three thin sites never exceeded **0.37** — the base
10% plus a Broken target's 25%. They wear none of the strike loop's other terms, and none of them
carries the party boon.

### SO THE RULE HAS ONE BODY AND THE FOUR ROLLS SPEND IT

`_crit_excess_mult(chance)` is `maxf(chance - 1.0, 0.0) * CRIT_EXCESS_STEP` and it is called from
all four. **Below a certainty it returns exactly 0.0**, so the three thin sites are paid nothing and
change nothing today — and the rule holds if a later term makes one of them reachable. **A gate that
asserted those three sites do NOT call it would forbid the fix on the day they become reachable; one
that asserts they call it and are paid zero says what is actually true.**

**IT IS TOTAL-AGNOSTIC BY DESIGN.** The obvious cheaper build converts each source as it is added —
the eagle's boon knows how much of itself landed above 1.0. **It is wrong, and the measurement says
why**: on **0 of the rolls at any arm** was the total already at 1.0 without the eagle, so the eagle
is never the wasted term, it is the term that pushes the total over. Any per-source accounting has
to pick a source to blame and there is no principled way to pick.

### AND THE STRIKE LOOP'S CONVERSION READS THE VARIABLE THE ROLL SPENT

`crit_mult += _crit_excess_mult(crit_chance)` sits inside the `if is_crit:` block, one line above
`raw *= crit_mult`. **One variable, so the roll and the surplus cannot disagree.** The five
forced-crit riders above it (Ice Lance into Frozen, White Heat, a perfect Execute, Triple Shot's
last arrow, Held Breath) collect it too, deliberately: the surplus is a property of what the
attacker assembled, not of how this particular crit was won.

**THE ROLL IS DELIBERATELY NOT CLAMPED.** `randf()` returns [0,1), so `randf() < 1.93` and
`randf() < minf(1.93, 1.0)` are the same blow. A `minf` there would change no behaviour and would
add a **second place the ceiling is written down**, which is the drift the one-body rule exists to
prevent.

### THE THREE OTHER READERS OF `CRIT_CHANCE`, NAMED SO A LATER SWEEP DOES NOT MISTAKE THEM FOR ROLLS

`party_screen.gd:222` and two `battle.gd` sites print `CRIT_CHANCE + crit_bonus` as a **display**;
three more spend that same sum as a **Burn magnitude** (`status_meta`, Immolate's retaliation,
Detonation's perfect). **None can know the assembled total** — it depends on the ability, the target
and the board — so none was changed. Six reads, zero rolls.

---

## §1 — THE RATE, AS OPTIONS

**PRESENTED AS OPTIONS. The mechanism is ruled and built; the rate is the designer's.**
`CRIT_EXCESS_STEP` ships at **1.0** because that is Focus's own exchange rate and therefore the one
value that is not an invention — and it is a **named constant** so this is one line to move.

**Arms: `--run 100` each, `DOD_SIM_DIFFICULTY=warden`, `DOD_SIM_ROUTE=balanced`, specs
`berserker,cryomancer,inquisitor,beastmaster` — EU's and EV's arms exactly, at `DOD_SIM_ROWS`
0, 3 and 9. Every probe is on an out-of-repo instrumented copy; not one executable byte of the
shipped tree carries one.**

### THE PRICING IS AN EXACT COUNTERFACTUAL, NOT AN A/B, AND THAT IS A STRENGTH

**The conversion consumes no randomness** — it adds to a multiplier and calls no RNG — so for a
given roll the "after" multiplier is computable exactly from the "before" one. Every rate below is
priced over **the same rolls**, with no seed divergence and no sampling error between arms.
**What it does not capture is second-order effects** (bigger blows kill faster, fights shorten,
the run diverges); the live two-armed measurement below is what speaks to those.

**THE HEROES' MEAN DAMAGE MULTIPLIER APPLIED PER STRIKE, BEFORE AND AFTER:**

| arm | n (hero strikes) | before | **rate 0.25** | **rate 0.50** | **rate 1.00** |
|---|---|---|---|---|---|
| **rows 0** | 52,651 | 1.07018 ±0.00076 | **+0.000%** | **+0.000%** | **+0.000%** |
| **rows 1–3** | 64,760 | 1.07738 ±0.00071 | +0.014% | +0.027% | **+0.055%** |
| **rows 1–9** | 43,928 | 1.08686 ±0.00090 | +0.676% | +1.351% | **+2.703%** |

Paired deltas at rate 1.00: **0.00000 ±0.00000 / 0.00059 ±0.00007 / 0.02938 ±0.00169.**
**At rows 0 the swing is EXACTLY zero and structurally must be** — not one roll of 52,651 ever
reached a certainty.

### DRIVEN LIVE AS TWO INDEPENDENT ARMS, AND THE ROWS-0 ARM IS ITS OWN NOISE FLOOR

HEAD's tree and EW's tree, same flags, independent runs:

| arm | before (HEAD) | after (EW, live) | swing |
|---|---|---|---|
| rows 0 | 1.07018 ±0.00076 (n=52,651) | 1.07168 ±0.00082 (n=45,635) | **+0.140% ±0.104** |
| rows 1–3 | 1.07738 ±0.00071 (n=64,760) | 1.08028 ±0.00072 (n=66,190) | **+0.269% ±0.094** |
| rows 1–9 | 1.08686 ±0.00090 (n=43,928) | 1.10552 ±0.00152 (n=43,503) | **+1.717% ±0.163** |

**THE ROWS-0 ARM IS A BUILT-IN NEGATIVE CONTROL AND IT IS WHY THE OTHER TWO ROWS CAN BE READ.**
The conversion **provably cannot fire** there — 0 of 45,635 rolls reached a certainty in the AFTER
arm either — so its +0.140% is pure run-to-run variance and **bounds this comparison's noise floor
at about ±0.14%.** That puts rows 1–3 barely above the floor and **rows 1–9 clearly above it.**

### **THE SWING IS SMALL AT THE PARTY AND LARGE ON THE BLOW, AND THIS IS THE PART THAT MUST NOT BE BURIED**

The brief asked for this plainly, and the plain answer is that **it is a buff, and a small one in
aggregate**: about **+1.7%** of crit output at a fully-talented loadout, about **+0.3%** at
rows 1–3, and **nothing at all untalented.** A reader who took *"the party is at nearly double a
certainty"* at face value would expect far more. Both readings are true of different populations.

**WHAT THE MEAN HIDES IS THE SHAPE, AND THE SHAPE IS WHERE A RATE SHOULD BE CHOSEN:**

| arm | crits landing past a certainty | mean total crit on them | **rate 0.25** | **rate 0.50** | **rate 1.00** |
|---|---|---|---|---|---|
| rows 0 | **0** of 52,651 | — | — | — | — |
| rows 1–3 | 135 (0.208%) | 1.284 | ×1.50 → ×1.571 | ×1.50 → ×1.642 | ×1.50 → **×1.784** |
| rows 1–9 | **538 (1.225%)** | **3.399** | ×1.50 → ×2.100 | ×1.50 → ×2.699 | ×1.50 → **×3.899** |
| rows 1–9, **worst single blow** | | **12.24** | ×1.50 → **×4.31** | ×1.50 → **×7.12** | ×1.50 → **×12.74** |

*(Driven live on the shipped tree at rate 1.00, the same arm reads 499 blows of 43,503, mean total
crit 2.515, mean multiplier applied **×3.015**, worst single blow **×8.28** — the same picture on
independent seeds.)*

**AND THE TAIL IS NOT BOUNDED BY ANYTHING.** The surplus is linear in a term with no ceiling —
Aguila's boon rides an uncapped Loyalty meter — so **before this batch the certainty ceiling was
acting as a de facto clamp on it.** Removing a clamp nobody knew was there is what this change
actually does, and that is the sentence a rate should be argued against. **A rate that reads
sensible at rows 0 and doubles the deep game is a rate chosen at the wrong arm** — and 1.00 does not
double the deep game at the party level, but it does turn one blow in eighty into a ×3.9.

### WHAT WOULD MAKE 1.00 THE WRONG NUMBER

It is Focus's rate, and **Focus is one meter that one spec builds on one target**. This prices a
total assembled from twelve terms across four heroes. Writing `CRIT_EXCESS_STEP` as
`FOCUS_STEP / FOCUS_STEP` would have been tidier and would have **asserted those two answers must
always be the same number**. They may well be; nothing has tested it. **A constant with a comment
moves in one line; a derivation cannot move without also making a claim.**

---

## §2 — IT DOES NOT APPLY TO ENEMIES, AND THE QUESTION IS MOOT

**The brief said: if no enemy ever exceeds 100% total crit, the question is moot and saying so
closes it. None does, at any rung and any arm.**

| arm | enemy crit rolls | mean total | **max** | at or over 1.0 |
|---|---|---|---|---|
| rows 0 | 24,106 | 0.1053 | 0.3500 | **0** |
| rows 1–3 | 28,214 | 0.1050 | 0.3500 | **0** |
| rows 1–9 | 17,612 | 0.1015 | 0.3500 | **0** |
| **total** | **69,932** | | **0.3500** | **0** |

**0.3500 is exactly the base 10% plus a Broken target's 25%, which says the measurement is reading
what it should.** And it is **structural rather than lucky**, which is what makes it closeable:

- **`_party_crit_bonus()` is hero-gated at its read site** (`if attacker.is_hero and not
  attacker.is_companion`), so the largest crit term in the game cannot reach an enemy at all.
- **`crit_bonus` has three writers and none of them can raise an enemy's.** It is assigned on the
  **hero spawn path** (`u.crit_bonus = cfg.get("crit_bonus", 0.0)`, inside the loop that builds
  `HERO_SLOTS`), copied hunter→companion at `_spawn_companion`, and **decremented** by `dulledge`
  (`maxf(u.crit_bonus - 0.05, -CRIT_CHANCE)`). No enemy config in `data/` carries the key.
- **Every remaining term is a talent counter** — `precision_ranks`, `blade_crit_ranks`,
  `killing_edge_ranks`, `supernova_ranks`, `focus_crit_chance()`, `tunnel_vision` — **and an enemy
  is allocated no tree**, so all of them are zero.

**RULED: no difficulty change, and nothing for the designer to rule on.** `check_ew` §5 asserts all
of it, including the deepest total any spawned enemy can assemble with Broken included.

---

## §3 — `BOND_MITIGATION_MAX` STAYS AT 0.75

**Ruled: no change. Recorded with its reasoning so the priced alternative is not re-proposed as a
discovery.**

The guard the constant exists for is real and is in its own header: an uncapped bear mitigation
crosses zero and starts *healing* the hunter off enemy attacks. **That guard forces some value below
1.0. It does not force 0.75** — 0.85 or 0.90 satisfy it identically and would push the bear's
saturation point from a boon of 7.50 to 8.50 or 9.00, which is **one to two more stacks of real
cover at the deep step and five to seven at the untalented one** before EV's fallback starts.

**The ruling is that the constant is a 75% damage reduction and 0.90 would make it 90%.** That is a
large survivability change wearing a saturation fix's clothes, and **EV's fallback already answers
the waste** — a converted stack that would pay into a saturated clamp pays the strike step instead,
at any value the clamp takes, because the fallback derives its point from the constant. Raising the
clamp would buy a few more stacks of cover at the cost of a power increase nobody asked for.

**Savage Presence's taunt ceiling of 1.0 was never in this question**: it is `minf(..., 1.0)` on a
probability, so it is arithmetic and there is no version of the game in which it is 1.2.

---

## §4 — TWO INSTRUMENT LESSONS, RECORDED — AND THIS BATCH PAID BOTH AGAIN

**Both are in `CLAUDE.md` as standing rules, with the procedure the second one asked for.**

> **Prose recording a removal reads exactly like the removal not happening.** EV renamed a local to
> clear a pin `test_batch_bg` holds absent, and the comment explaining the rename tripped the same
> pin by naming the word. **The fix is never the exemption** — an exemption granted to a sentence
> blinds the rule to a real violation arriving in that file later. Either the instrument strips
> comments first, or the prose does not spell the word. **A comment cannot concatenate**, which is
> why the two halves are not symmetric: a gate can split a literal at runtime, prose cannot.

> **An analysis over a log still being written reads a prefix and reports it as the run.** EV's §2
> figures were measured twice; the first pass read three parallel arms while two were still running.
> **The shape and the conclusion were identical and every count was wrong.** The procedure recorded
> beside it: **an arm is not read until its process has exited** — each arm writes its own done
> marker, the reader polls for the marker in a FOREGROUND loop, and neither a `pgrep -f` wait loop
> (it matches itself) nor a backgrounded `sleep` (it returns instantly) will do.

**EW FOLLOWED THE SECOND ONE AND IT COST A FULL ARM SET TO GET RIGHT.** The first three arms were
launched in parallel and the done markers showed **one finished and two still running** at the first
poll — exactly EV's situation, caught by the procedure rather than by luck. Nothing was read until
all three markers were present, twice, for two independent arm sets.

---

## §5 — THE GATE, AND THE TWO INSTRUMENTS OF ITS OWN THAT WERE WRONG

`check_ew` — **38 checks**, three identical standalone readings before the battery.

| | |
|---|---|
| **§0** | the roll site census: four rolls, four calls, **derived** |
| **§1** | the rate is a named constant; the floor over 101 readings and the slope over 1201 |
| **§2** | **DRIVEN** — a crit past certainty hits harder, on real blows, at an exact predicted ratio |
| **§3** | **DRIVEN** — it is not Focus's conversion, and both fire on one roll |
| **§4** | the three thin roll sites call it and are paid exactly zero |
| **§5** | no enemy can reach it, structurally and on the spawned board |
| **§6** | Focus's own point and rate are untouched |

### **§5a — THE CENSUS FINGERPRINT WAS WRONG IN THE DIRECTION THAT PASSES**

The first version took every `randf() <` line whose text contained *"crit"* and read **THREE**.
`_heal_crit_mult`'s roll line is `if randf() < hc_chance:` and **carries the word nowhere.**
A fingerprint that reads the population short reports a clean census over a subset.

**The repaired fingerprint derives the population through the CONSTANT**: a crit roll is a
`randf() <` compared against a **named variable whose own declaration is built from `CRIT_CHANCE`**.
That is exactly the four, it cannot miss one for want of a word in a line, and **it pins the
property the conversion actually needs** — the chance must be NAMED, because a roll comparing
against an inline expression cannot hand the same value to the conversion and would have to
recompute it. §0 also asserts that each **rolled** name is a **converted** name, so four rolls and
four calls cannot tally while the conversion reads a different chance at every one of them.

### **§5b — AND §3's LIVE ARMS WERE MEASURING FOCUS ACCRUAL**

§3 drives a Sharpshooter deliberately **below** his Focus split point, so `focus_crit_mult()` is
zero and only the total's surplus can move the damage. **His basic pays Focus after it resolves**,
so sixteen blows drive the meter a long way up — and without a reset the second arm started where
the first finished, **deep past the split, wearing a `lethal_crit_mult()` the first arm never had.**

**Caught by a control, not by reading it.** With `_crit_excess_mult` stubbed to return 0.0 the
section still read **1325 against 538 and passed.** The meter is pinned before **every blow** now,
not once per arm.

### **§5c — AND THE SHARPER VERSION OF §3 DOES NOT SURVIVE THIS FIXTURE, WHICH IS RECORDED RATHER THAN HIDDEN**

The obvious sharper section recovers the base multiplier from two arms — damage is proportional to
`base + surplus`, so two surpluses give two equations — and asserts it equals `lethal_crit_mult()`.
**Driven, it recovers ×1.16 against a true ×2.00.** The blow is not purely multiplicative on the way
out: armor, a block and the `maxi(..., 1)` floor sit below the crit block, and a **subtractive** term
inflates a two-point ratio in exactly that direction. A surplus sweep at 0.5 / 1.0 / 1.5 / 3.0 reads
**610 / 731 / 852 / 1221** — perfectly linear, +242 per point of surplus, extrapolating to 489 at
zero surplus against a **measured 421**, so the total-exactly-1.0 arm is a knife edge as well.

**So §2 owns the exact ratio** (a Swordmaster's clean ×1.5, predicted from the live constant and
measured to within 0.02) **and §1 owns the arithmetic** over 1201 readings; **§3 owns the
INDEPENDENCE**, as a monotonicity a control demonstrably collapses. It is a retreat and the file
says so at the site.

### **§5d — EIGHT NEGATIVE CONTROLS. ALL EIGHT BIT.**

Every restore was by `cp` from a scratchpad backup, **md5 verified identical every time, never
`git checkout`.**

| control | result |
|---|---|
| **HEAD's own `battle.gd` verbatim** | **9 failures, 5 throws** — §0 ×5, §3, §4 ×3 |
| the conversion reads **`attacker.crit_bonus`** instead of the assembled total | **3** — §0's two, and **§2 reading 1.9335 against a predicted 2.0000** |
| the **`maxf` floor removed** (an ordinary 10% crit pays a negative multiplier) | **3** — §1's floor over 101 readings, §4, §5 |
| a **fifth roll site** added without the call | **3** — the census reads 5 rolls / 4 calls and names the stray |
| **`_companion_hit` drops the call** | **3** — 4 rolls / 3 calls, and §4 names the function |
| the **rate at 0.0** | **3** — and **§2 reads 436 against 436** |
| the conversion **stubbed to zero** (a fold into Focus's) | **4** — §1's slope, §2's two, **§3** |
| the conversion applied **before the roll instead of after** | **4** — §0's variable-name check, §2's two, §3 |

**The last two are the brief's own named failure family** — *a conversion computed after the roll,
or on a per-source total rather than the assembled one, would pass every static check* — and both
are caught **live** as well as statically.

---

## §6 — VERIFICATION

### **§6a — THE PRE-CHECKS, WRITTEN BEFORE THE BATTERY**

- **The parse floor**, grepped from stderr and never from a tally: **0 `Parse Error`**, with
  `check_parse` at **166 / 0** off three identical standalone readings.
- **`check_ed` was run against HEAD's manifest BEFORE the manifest was regenerated** — the
  pin-manifest rule — and read **18 / 0**, so no needle in the new gate or the edited documents
  collides with a pin held absent. Regenerating produced a byte-identical manifest.
- **`check_ew` read 38 / 0 three times standalone**, so its baseline row certifies on pass one.
- **The glossary's whitespace was round-tripped before it was edited**, and that is what found §7's
  documentation error.

### **§6b — THE PREDICTED BASELINES, WRITTEN BEFORE THE RUN**

**Two rows move and both were written before the launch.** `check_ew` **new at 38 / 0**, and
`check_parse` **165 → 166** — a target joining the battery raises it the same day, because that
gate's count IS its coverage. Its residue is unchanged at 4. **Every other row is predicted
unmoved.**

### **§6c — THE LITERAL SWEEP, AND ITS OWN TWO-ARMED CONTROL**

Every string literal in every `.gd` in the tree at a floor of 4 — **16,615 needles** — swept against
snapshots of the documents taken before a byte was edited.

**THE INSTRUMENT WAS ARMED IN BOTH DIRECTIONS BEFORE IT WAS TRUSTED, AND THE FIRST ARMING FAILED.**
Deleting the **first** occurrence of an asserted needle from `master.html` read **LOST 0** — the word
appears twice, so the injection did not break it. Deleting **every** occurrence reads **LOST 1**;
introducing a needle the file genuinely does not carry reads **GAINED 3**. Only then was it used.

**Final: LOST 0 in all five documents.**

### **§6d — AND THE SWEEP CAUGHT A RULE VIOLATION, AND WAS STRUCTURALLY BLIND TO THE SAME ONE**

See §7. **`data/glossary.json` GAINED the needle `"the whole party"`** — and `test_batch_bx` §4b
pins the retired word absent from that exact file. **The identical violation in `master.html` was
invisible to the same sweep**, because that file already carries `party` inside code identifiers,
so the needle was **not GAINED — it was already present.**

> **A needle sweep reports on needles that MOVE. A word already in the file cannot move, so a sweep
> cannot see it arrive a second time.** This is the concrete shape of *a sweep has holes a run
> finds*, and the run is what closed it: `test_batch_bx` was driven after the corrections and read
> **161 / 0**.

### **§6e — THE BATTERY. THE PREDICTION HELD EXACTLY.**

**`check_de` — 378 checks / 0 failures / 0 NOTICES.** Both moved rows certified on pass one, which
is what writing them before the run buys. **92 targets, and `sort .ran | uniq -d` holds ZERO
duplicates** — one battery wrote these logs.

| | |
|---|---|
| **`Parse Error` across all 92 logs** | **0** — and the verdict is read off the grep, never off a tally |
| **`SCRIPT ERROR` across all 92 logs** | **0** |
| **the only red in the run** | **`check_cm_live` 13 / 4**, and its four FAIL lines were READ and confirmed to be the defensive-bar assertions its baseline row names: *the bar appeared on the enemy's attack*, *the bar's top line names the incoming blow*, *the brace lands near x0.85*, *the brace's Break half lands near x0.75* |
| **`check_parse`** | **166** — the predicted move, RESIDUE unchanged at 4 |
| **`check_ew`** | **38 / 0** — the predicted new row |
| **`check_ev`** | **54 / 0 — unmoved**, as predicted |
| **`check_eu`** | **38 / 0 — unmoved**, as predicted |
| **run harness** | GATE 1 **22**, GATE 2 **166**, GATE 3 **8**, all PASS, throws 0 |

### **§6f — THE FREEZE, CHECKED RATHER THAN ASSERTED**

An md5 stamp of **all 215 tracked source and document files with ABSOLUTE paths**, taken immediately
before the launch and again after. **Exactly ONE file differs and it is `docs/reports/EW.md`**,
which did not exist at the first stamp and which nothing in the tree loads. Every `.gd`, every
`.json`, `run_battery.sh`, `project.godot` and all five asserted documents are byte-identical to
what the battery read — verified separately by keeping a copy of each asserted document aside
before the launch and comparing it afterwards.

*(The first comparison reported a spurious second difference, `project.godot`. It was the
instrument: the two `find` invocations used different name patterns, so the file was in one list
and not the other. Re-run with identical patterns, the difference is the report alone.)*

### **§6g — THE POST-RUN EDITS, AND THE RUN ON TOP OF THE SWEEP**

**Two lines were corrected after the battery**, both the same stale figure: `run_battery.sh`'s own
header and `CLAUDE.md`'s rule quoting it both said the run harness reads **22/165/8**, and GATE 2 is
`check_parse`, which this batch moved to **166**. Left alone it is precisely the defect this project
records as *a comment naming code is a claim, and it goes stale silently.*

- **The `run_battery.sh` edit was proved to change nothing else**: a comment-stripped diff of the
  before and after shows exactly one line, and that line is an `echo`.
- **Needle-swept against the copies the battery itself read**: **0 LOST and 0 GAINED** in both files.
- **AND THEN RUN, BECAUSE A SWEEP HAS HOLES A RUN FINDS.** Every target in the tree that reads
  `CLAUDE.md` or `run_battery.sh` — **29 of them, derived by grepping for the paths rather than
  listed** — was re-run against the edited files. **All 29 clean, 0 throws, 0 `Parse Error`, and all
  29 reporting the IDENTICAL check and failure counts the battery read.** Not merely green: unmoved.

---

## §7 — TWO CORRECTIONS TO SHIPPED DOCUMENTATION, NEITHER IN SCOPE

**Both were found on the way and both are recorded because a false claim in a document does not
decay and is not caught; it is only ever found by someone looking.**

- **`master.html` §4.3 said Aguila grants +15% crit.** The code grants **+10% scaled by the bond
  tier** (`0.10 * _bond_mult(h, "aguila")`), which is what the **same document** says in two other
  places (§5.1's companion block and §7's Beastmaster block). Corrected toward the code, per the
  standing rule.
- **`master.html` §4.3's new crit list named "Super Nova", and no talent node has that name.**
  `supernova_ranks` is **RUNE-ONLY** — `unit.gd` says so at the declaration — its only two writers
  are runes, and **all 65 runes have been retired since ET §1**, so the term cannot fire at all
  today. (`py_supernova` is a *different* node called **Pressure Cooker**, which writes
  `pressure_cooker`.) The name was dropped from the list rather than shipped.
- **`CLAUDE.md`'s claim that every `data/*.json` is TAB-indented is false for half of them.**
  `glossary.json` and `enemies.json` are indented with a **single space** and carry **no trailing
  newline**; `events.json` and `runes.json` match no simple `json.dumps` form at all. **The rule's
  own procedure is what found it** — round-trip the unmodified parse and assert byte equality before
  writing — so the bullet now leads with the round-trip and warns against assuming the style.

---

## §8 — WHAT MOVED, AND WHAT DELIBERATELY DID NOT

**MOVED:** `scripts/battle.gd` (one constant, one new helper, one call in the strike loop, three
roll sites restructured so their chance is named and converted); the new `check_ew.gd`;
`run_battery.sh`; `baselines.json`; `docs/master.html` and its stamp; `docs/changelog.html`;
`CLAUDE.md`; `docs/design-notes.md`; `data/glossary.json`; `docs/state.md`; and this report.
**Both `.docx` exports were rebuilt and they are NOT in this repo** — they live one directory up at
`/Users/zipples/Documents/DoD/`, outside version control, so they are regenerated rather than
committed.

**DELIBERATELY DID NOT MOVE:**

- **NO CLAMP WAS RAISED.** §3 rules `BOND_MITIGATION_MAX` stays at 0.75, with its reasoning.
- **FOCUS'S CONVERSION POINT AND RATE ARE UNTOUCHED.** `FOCUS_CONVERT` 100, `FOCUS_STEP` 0.005,
  both still in `unit.gd`, both asserted by `check_ew` §6.
- **THE LOYALTY SPLIT STAYS AT 8** and `_bond_fallback` is byte-unchanged.
- **NO RUNE IS AUTHORED.**
- **THE ROLL IS NOT CLAMPED**, for the reason in §0: it would change no behaviour and would add a
  second place the ceiling is written down.
- **THE SIX PARTIAL-CRIT DISPLAY AND BURN-MAGNITUDE READS ARE UNCHANGED**, because none of them can
  know the assembled total.
