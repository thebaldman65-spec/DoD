# BATCH EX — `CRIT_EXCESS_STEP` GOES TO 0.50

**Ruled by the designer and built: the surplus rate moves 1.0 → 0.50. One constant, one line.**

EW built the mechanism and flagged the rate rather than tuning it. This is the ruling, with the
reasoning recorded beside it so the priced alternative is not re-proposed later as a discovery.
**Nothing else moved**: Focus's conversion, the four roll sites, the unclamped roll,
`BOND_MITIGATION_MAX`, the Loyalty split and `_bond_fallback` are all byte-unchanged, and no rune
was authored.

---

## THE BRIEF'S PREMISES, RE-DERIVED

**The brief said to verify every premise. Most reproduce exactly. Three do not, and one of those
is a claim the brief makes twice.**

| the brief's claim | what the tree and the arms say |
|---|---|
| *"EW's exact counterfactual predicts +1.351% at rows 1–9"* | **QUOTED CORRECTLY FROM EW §1.** And the live EX arm reads **+1.235% ±0.158**, which agrees inside one standard error. §1. |
| *"At 1.00 the worst measured blow is ×12.74; at 0.50 it is ×7.12"* | **QUOTED CORRECTLY, AND THE STATISTIC DOES NOT REPRODUCE.** Across four independent rows-1–9 arms the worst total crit reads **18.09 / 12.24 / 11.12 / 7.20** — a 2.5× spread. It is a SAMPLE MAXIMUM of a term with no ceiling, so it grows with sampling instead of converging. At 0.50 my own three arms give ×10.04 / ×6.56 / ×4.60. **§1c — the ruling stands; the number it was argued on is not reproducible.** |
| *"the aggregate keeps +1.35% at rows 1–9 against 1.00's +2.70%"* | **QUOTED CORRECTLY FROM EW'S TABLE.** Re-derived here the same way it reads **+2.048%** at 0.50 and **+4.096%** at 1.00, because this run set's tail is heavier. **The RATIO — 0.50 buys exactly half of 1.00 — is exact and is the part that holds.** §1b. |
| *"0.25 … +0.68% at rows 1–9 barely clears the live comparison's own noise floor of ±0.14%"* | **THE FLOOR REPRODUCES AT ±0.11%** (rows 0 reads −0.112% ±0.115 and −0.079% ±0.114 on two independent pairs). **The conclusion survives and is sharper than the brief put it**: at rows 1–3 even 1.00 is below the floor. §1a. |
| *"rows 0 must read exactly zero … the conversion **provably cannot fire there**, 0 of 45,635 rolls reached a certainty"* | **THE REQUIREMENT IS MET AND THE REASON GIVEN FOR IT IS FALSE.** The EX arm paid exactly zero on **0 of 40,766** strikes. But the rate-0 arm at the same setting crossed a certainty **twice in 40,437**, with a distribution reaching **1.09** and 208 strikes at or past 0.50. **§2 — rows 0 is a rare event, not a structural zero.** |
| *"a total assembled from **twelve terms** across four heroes"* | **TWELVE STATEMENTS, THIRTEEN TERMS** — the first statement carries the base and a Broken target's 25% together. Derived mechanically. **And `battle.gd`'s own comment said "eight sources", which is wrong under every reading. §3.** |
| *"`check_ew`'s count is predicted UNMOVED at 38"* | **CONFIRMED — 38 / 0, three identical standalone readings at 0.50.** Nothing was pinning the value. §4. |
| *"`FOCUS_CONVERT` 100, `FOCUS_STEP` 0.005 … `BOND_MITIGATION_MAX` stays at 0.75. The Loyalty split stays at 8"* | **ALL FOUR CONFIRMED IN PLACE AND UNTOUCHED** — `unit.gd:824-825`, `battle.gd:13415`, `BOND_CONVERT := 8` at `battle.gd:13376`. §5. |

---

## §1 — THE RATE AT 0.50, MEASURED

**Arms: `--run 100` each, `DOD_SIM_DIFFICULTY=warden`, `DOD_SIM_ROUTE=balanced`, specs
`berserker,cryomancer,inquisitor,beastmaster`, at `DOD_SIM_ROWS` 0, 3 and 9 — EW's arms exactly.
Every probe is on an out-of-repo instrumented copy; not one executable byte of the shipped tree
carries one.**

**NINE ARMS, RUN AS A LATIN SQUARE.** Three rates × three row bands, launched three at a time so
that **each rate appears once in each batch and once in each row band**. The ordering lesson this
project already paid for is that a two-armed reading can follow the POSITION rather than the meter;
a Latin square balances position across rates instead of hoping it does not matter. Each arm wrote
its own done marker and the reader polled the markers in a foreground loop — **all nine exited 0,
with 0 `Parse Error` and 0 `SCRIPT ERROR` across every arm's stderr, and no orphan process left
spinning.**

### **§1a — LIVE, TWO-ARMED, IN EW'S TABLE SHAPE**

Independent runs, the conversion off against the conversion at 0.50:

| arm | before (rate 0) | after (rate 0.50) | swing |
|---|---|---|---|
| rows 0 | 1.07277 ±0.00088 (n=40,437) | 1.07157 ±0.00087 (n=40,766) | **−0.112% ±0.115** |
| rows 1–3 | 1.07950 ±0.00078 (n=55,053) | 1.08240 ±0.00080 (n=53,887) | **+0.269% ±0.104** |
| rows 1–9 | 1.09313 ±0.00102 (n=36,072) | 1.10664 ±0.00138 (n=36,543) | **+1.235% ±0.158** |

**THE ROWS-0 ARM IS THE NOISE FLOOR AND IT READS IT.** −0.112% ±0.115, and the conversion paid
exactly zero on every one of the 40,766 strikes in that arm, so the whole reading is run-to-run
variance. **The floor is ±0.11%.**

**AND THAT FLOOR IS WHAT MAKES ROWS 1–3 READABLE — BY SAYING IT IS NOT.** The +0.269% there looks
like a result and is not one: the exact counterfactual (below) says the conversion is worth
**+0.033%** at rows 1–3, thirty times smaller than the arm's own noise. **The rows-1–3 figure at
0.50 and at 1.00 are +0.269% and +0.280% — indistinguishable, because neither is the conversion.**
Only rows 1–9 is above the floor.

**THE SAME ARMS AT 1.00, AS A REPLICATION OF EW'S OWN TABLE:**

| arm | before (rate 0) | after (rate 1.00) | swing | EW read |
|---|---|---|---|---|
| rows 0 | 1.07277 ±0.00088 | 1.07192 ±0.00085 (n=42,138) | −0.079% ±0.114 | +0.140% ±0.104 |
| rows 1–3 | 1.07950 ±0.00078 | 1.08252 ±0.00082 (n=52,463) | +0.280% ±0.105 | +0.269% ±0.094 |
| rows 1–9 | 1.09313 ±0.00102 | 1.11697 ±0.00178 (n=36,239) | **+2.180% ±0.189** | +1.717% ±0.163 |

**EW's shape replicates; its rows-1–9 magnitude does not, and the difference is the tail rather than
the method** — see §1c.

**AND WHAT EX ACTUALLY CHANGES FROM WHAT SHIPPED YESTERDAY** (rate 1.00 against rate 0.50, both
live, independent runs):

| arm | today (1.00) | EX (0.50) | swing |
|---|---|---|---|
| rows 0 | 1.07192 ±0.00085 | 1.07157 ±0.00087 | −0.033% ±0.114 |
| rows 1–3 | 1.08252 ±0.00082 | 1.08240 ±0.00080 | −0.011% ±0.106 |
| rows 1–9 | 1.11697 ±0.00178 | 1.10664 ±0.00138 | **−0.925% ±0.201** |

**So the ruling costs the deep game about one percent of crit output and costs the other two arms
nothing measurable.**

### **§1b — THE EXACT COUNTERFACTUAL, AND WHAT ITS EXACTNESS IS ACTUALLY ABOUT**

The conversion consumes no randomness, so for a given roll the "after" multiplier is computable
exactly from the "before" one. Priced over the rate-0 arms' own rolls, EW's method:

| arm | n | before | **0.25** | **0.50** | **1.00** |
|---|---|---|---|---|---|
| rows 0 | 40,437 | 1.07277 ±0.00088 | +0.000% | +0.000% | +0.000% |
| rows 1–3 | 55,053 | 1.07950 ±0.00078 | +0.018% | **+0.037%** | +0.073% |
| rows 1–9 | 36,072 | 1.09313 ±0.00102 | +1.024% | **+2.048%** | +4.096% |

Paired deltas at 0.50: **0.00000 ±0.00000 / 0.00040 ±0.00004 / 0.02239 ±0.00123.**
**0.50 buys EXACTLY half of 1.00 at every arm**, which it must — the conversion is linear in the
rate and the pairing removes every other source of difference.

> **THE COUNTERFACTUAL'S EXACTNESS IS ABOUT THE PAIRING, NOT ABOUT THE ESTIMATE'S PRECISION.**
> The brief expected the live arm to be close to EW's +1.351% *because* the counterfactual consumes
> no randomness. It is close (+1.235% ±0.158). **But the rolls it is priced over are still random,
> and the quantity is dominated by a rare heavy tail.** Priced over each of the three rows-1–9 arms
> in turn the same rate-0.50 figure reads **2.048% / 1.211% / 1.031%** — a spread of a full
> percentage point on a number whose per-arm standard error is a tenth of that. An exact
> arithmetic over one sample is still one sample.

**AND THE SPREAD HAS A DIRECTION, WHICH MAKES IT A MECHANISM RATHER THAN NOISE.** Those three
readings are in the order rate 0 / 0.50 / 1.00 — **monotone decreasing in the arm's own rate.** A
bigger multiplier kills faster, so fights are shorter, so the uncapped Loyalty meter that feeds the
tail has less time to build. **The same effect explains why the live arm reads below the
counterfactual at both rates and in both batches** (EW: 1.717 live against 2.703 priced; EX: 1.235
live against 2.048 priced). The counterfactual is an upper reading by construction, and it was in
EW as well.

### **§1c — THE TAIL, AND THE ONE FIGURE THE BRIEF CHOSE ON THAT WILL NOT HOLD STILL**

Priced over the same rate-0 rolls:

| arm | crits past a certainty | mean total crit on them | **0.25** | **0.50** | **1.00** |
|---|---|---|---|---|---|
| rows 0 | **2** of 40,437 (0.005%) | 1.080 | ×1.520 | ×1.540 | ×1.580 |
| rows 1–3 | 185 (0.336%) | 1.235 | ×1.559 | **×1.618** | ×1.735 |
| rows 1–9 | **773 (2.143%)** | **3.089** | ×2.022 | **×2.545** | ×3.589 |
| rows 1–9, **worst single blow** | | **18.09** | ×5.77 | **×10.04** | ×18.59 |

**THE BRIEF PICKED 0.50 OFF "THE WORST MEASURED BLOW" AND THAT STATISTIC DOES NOT CONVERGE.**
Four independent rows-1–9 arms — EW's and this batch's three — give worst totals of
**12.24 / 18.09 / 11.12 / 7.20**, and past-certainty fractions of
**1.225% / 2.143% / 1.587% / 1.501%**. At 0.50 the worst blow reads **×7.12 / ×10.04 / ×6.56 /
×4.60** depending only on which hundred runs you looked at.

**This does not overturn the ruling — it strengthens the reason for it.** A term with no ceiling
produces a sample maximum that grows with sampling; that is exactly why the certainty ceiling was
worth something as a de facto clamp, and exactly why halving what is given back is the cautious
reading. **But "the worst measured blow is ×7.12" is not a fact about the game, it is a fact about
one hundred runs**, and the next hundred read ×10.04. The stable figures are the ratio (0.50 buys
half of 1.00, exactly) and the aggregate band (about +1.2% live at rows 1–9, floor ±0.11%).

---

## §2 — ROWS 0 IS A RARE EVENT, NOT A STRUCTURAL ZERO

**The brief states twice that the conversion "provably cannot fire" at rows 0. It can.**

The rate-0 arm at rows 0 crossed a certainty **twice in 40,437 hero strikes** — totals of **1.07 and
1.09**, both crits, both at a base ×1.5. And the distribution below them is not empty either:
**208 strikes at or past 0.50 and 1,443 at or past 0.35**, where the three thin roll sites cap out.

**AND THE TERM THAT DOES IT IS THE ONE TERM THAT NEEDS NO TALENT AND HAS NO CEILING.** At rows 0 no
talent counter can fire, so the total can only be built from the base rate, a Broken target's 25%,
`crit_bonus` and Aguila's party boon. `_party_crit_bonus()` is gated on `passive_id == "pack"` and
nothing else — **no talent, no row** — and it pays `0.10 * _bond_mult(h, "aguila")` off an uncapped
Loyalty meter. A total of 1.09 needs a bond multiplier around 7.4, which a long fight reaches.

**WHAT SURVIVES AND WHAT DOES NOT:**

- **The requirement survives.** The shipped EX arm converted exactly nothing at rows 0 — **0 of
  40,766** — so rows 0 remains a clean noise floor, and the two crossings would in any case have
  moved that arm's mean by **+0.0002%** against a ±0.11% floor.
- **The reason does not.** "Provably cannot fire" is false; **"fires about sixteen times in a
  million strikes"** is what was measured. Across the three rows-0 arms it is 2 in 123,341.
- **It is worth saying because the claim is load-bearing.** A negative control that is asserted as
  structural, and is really just rare, stops being a control on the day it is not rare — and the
  term that would do that is the one term in the game with no ceiling on it.

---

## §3 — THE CONSTANT'S OWN COMMENT NAMED THE WRONG NUMBER

`battle.gd`'s comment on `CRIT_EXCESS_STEP` said the open question was whether Focus's rate suits
*"a total assembled from **eight sources**"*. **Every document says twelve. Neither is right as
stated, and the code is the thing to count.**

Derived mechanically from the strike loop between `var crit_chance :=` and `var is_crit :=`:
**TWELVE statements write the total, and they carry THIRTEEN additive terms** — the first statement
is `(0.25 if Pommel Strike else CRIT_CHANCE) + (0.25 if broken)`, two terms in one line. So "twelve"
is right about the places and wrong about the terms, and "eight" is wrong about both.

**Corrected in the comment this batch was rewriting anyway**, per the standing rule that a comment
naming code is a claim and is corrected toward the code. **`docs/reports/EW.md` is left alone** —
it is EW's record, and this is not a defect in what EW built.

---

## §4 — THE GATE HELD AT 38, AND IT GOT SHARPER

**`check_ew` reads 38 / 0, three identical standalone readings at 0.50** — exactly the brief's
prediction. Nothing in the gate was pinning the value rather than the property: §1 reads the floor
over 101 readings and the slope over 1201 against the live constant, and §2 computes its prediction
from it.

**AND §2 IS TIGHTER AT 0.50 THAN AT THE RATE IT SHIPPED ON.** Driven on an instrumented copy at
three rates, §2's measured ratio against its own live prediction:

| rate | certainty arm | surplus arm | measured ratio | predicted | error |
|---|---|---|---|---|---|
| 0.25 | 436 | 544 | 1.2477 | 1.2500 | **0.0023** |
| **0.50** | **436** | **653** | **1.4977** | **1.5000** | **0.0023** |
| 1.00 | 436 | 874 | 2.0046 | 2.0000 | 0.0046 |

The certainty arm is **436 at every rate**, which it must be — zero surplus — and the surplus arm
scales linearly with the rate. **The section is not passing on a slack tolerance**: its error at
0.50 is half what it was at 1.00, against a 0.02 bound.

### **§4a — ONE CHECK OF THE 38 CANNOT FAIL, AND IT IS NAMED RATHER THAN TOUCHED**

`check_ew` §6's last assertion is `ok(step == step, …)`. **That is vacuously true for any non-NaN
float** — it prints the rate, which is useful, but it asserts nothing. It is one of the 38 and it
was one of the 38 at EW as well. **Not changed here**: this batch moves one number and a gate edit
would move the count the same brief predicts unmoved. **Recorded as owed.**

---

## §5 — WHAT DID NOT MOVE, CHECKED RATHER THAN ASSERTED

**The executable diff is ONE line.** A comment-stripped diff of `battle.gd` against HEAD's copy
shows exactly `const CRIT_EXCESS_STEP := 1.0` → `:= 0.50`, with identical line counts either side —
so the comment rewrite above it swallowed no code.

- **Focus's conversion is untouched** — `FOCUS_CONVERT := 100` and `FOCUS_STEP := 0.005` at
  `unit.gd:824-825`, both asserted live by `check_ew` §6.
- **The four roll sites keep their structure** — `check_ew` §0 derives the census through
  `CRIT_CHANCE` and still reads four rolls, four calls, one body, every rolled name a converted
  name.
- **The roll is still unclamped** and the three thin sites are still paid exactly zero.
- **`BOND_MITIGATION_MAX := 0.75`** (`battle.gd:13415`), **`BOND_CONVERT := 8`**
  (`battle.gd:13376`), **`_bond_fallback` byte-unchanged**.
- **No rune is authored.** Rune content is the designer's, one rune at a time.

---

## §6 — VERIFICATION

### **§6a — THE PRE-CHECKS, WRITTEN BEFORE THE BATTERY**

- **The parse floor, grepped from stderr and never from a tally or an exit code**: **0
  `Parse Error`**, with `check_parse` at **166 / 0** both before and after the change.
- **`check_ew` read 38 / 0 three times standalone** at 0.50, before anything else was touched.
- **The literal-sweep instrument was armed in BOTH directions before it was trusted** — see §6c.

### **§6b — THE PREDICTED BASELINES, WRITTEN BEFORE THE RUN**

**No row moves.** `check_ew` is predicted **unmoved at 38 / 0** and `check_parse` **unmoved at
166 / 0** — no target joins or leaves the battery, and the one changed constant is read live by the
only gate that reads it. **Every other row is predicted unmoved.** `baselines.json` carries an EX
line on `check_ew`'s note recording that the rate moved beneath the row and the row held, because
that is evidence about the row rather than a change to it.

### **§6c — THE LITERAL SWEEP, AND ITS TWO-ARMED CONTROL**

Every string literal in every `.gd` in the tree at a floor of 4 — **15,256 distinct needles from
124 files** — swept against snapshots of the documents taken **before a byte was edited**.

**THE INSTRUMENT WAS ARMED IN BOTH DIRECTIONS FIRST.** Deleting a needle that appears **exactly
once** in `master.html` (chosen out of the needle list, not invented) reads **LOST 1**; injecting a
needle the file genuinely does not carry reads **GAINED 3**. Only then was it used.

**And the extractor was checked against a population rather than trusted** — a `--include` filter
was silently disabled by a `--` earlier in the same session, so the first sweep searched every file
type while reporting as if it had filtered. Re-run with a control needle in each direction, the
filter bites.

### **§6d — THE SWEEP'S RESULT, AND THE ASSERTIONS ENUMERATED RATHER THAN THE LITERALS**

**LOST 0 and GAINED 0 in `master.html` and `data/glossary.json`.** The other five documents move
needles, and **a moved needle is only a defect if something asserts on it**, so the assertions were
enumerated rather than the literals:

| document | LOST | GAINED | what asserts on it |
|---|---|---|---|
| `docs/master.html` | 0 | 0 | 25 readers |
| `data/glossary.json` | 0 | 0 | 19 readers |
| `docs/changelog.html` | 0 | 2 (`_party_crit_bonus`) | no reader carries either as a literal |
| `CLAUDE.md` | 0 | 2 (`MAXIMUM`, `passive_id == "pack"`) | `MAXIMUM` is carried by `test_batch_at`, which asserts it against a **`passive_desc`**, not against `CLAUDE.md` |
| `baselines.json` | 0 | 1 (`CRIT_EXCESS_STEP`) | no reader carries it as a literal |
| `docs/design-notes.md` | 0 | 1 (`3 turns`) | an accidental substring of *"rows 1–3 turns out to be"*; no reader carries it |
| **`docs/state.md`** | **11** | 2 | **NOTHING OPENS THIS FILE.** `grep -rn 'res://docs/state.md'` over every `.gd` returns nothing — the nine apparent "readers" are comments naming the path. The 11 LOST needles are the old WHERE block's vocabulary (`CRIT_CHANCE`, `_heal_crit_mult`, `randf() <`, `dulledge`) and none is asserted. |

**AND THE HOLE THE SWEEP CANNOT SEE WAS CLOSED SEPARATELY.** A needle already present in a file
cannot be seen arriving a second time, so the corpus's own banned-string assertions were checked
directly instead: `test_batch_bx` §4b's *beast* strip over `glossary.json` and `master.html`, and
the fixed-window checks below.

### **§6e — A COMMENT CAN OUTGROW A SCAN WINDOW, AND THIS ONE WAS CHECKED AGAINST THAT**

The rewritten comment added **13 lines / 762 bytes** to `battle.gd`. Suites read that file through
**fixed-size `substr` windows** anchored on a `find()`, and a window that spans an insertion silently
loses content off its far end.

**Derived rather than eyeballed:** the edit's byte range was computed from the first and last
divergence against HEAD's copy (bytes 388,944–390,388), then **every `find()` anchor in the whole
corpus — 147 of them — was located in the new file** and checked against that range ±3,000 bytes
(larger than the biggest window in the tree, 2,600). **The only anchors within reach are the generic
`"\nfunc "` and `"(Batch "`**, which bound a function body relatively and read `master.html`'s stamp
respectively. **No fixed-size window over `battle.gd` spans the edit.**

---

## §7 — THE VERIFICATION RUN

### **§7a — THE FREEZE HELD EXACTLY**

An md5 stamp of **all 333 tracked files with ABSOLUTE paths**, taken immediately before the launch
and again after. **ZERO differ.** Not one `.gd`, `.json`, `.html`, `.md`, `run_battery.sh` or
`project.godot` moved while the battery read them.

**AND THE LIST'S OWN GAP IS NAMED RATHER THAN LEFT IMPLIED.** The population is `git ls-files`, so
it is every TRACKED file — **this report was untracked when the stamp was taken and was therefore
outside it**, which is the one file EW's equivalent stamp also could not cover. It is checked a
different way instead: **nothing in the tree loads `docs/reports/`** (every apparent reference is a
comment naming a path — §7c), so a report cannot reach a run whatever it says.

### **§7b — THE BATTERY**

**`check_de` — 378 checks / 0 failures / 0 NOTICES.** No baseline row moved and none rose, which is
what "every row predicted unmoved" has to look like. **92 targets, and `sort .ran | uniq -d` holds
ZERO duplicates** — one battery wrote these logs.

| | |
|---|---|
| **`Parse Error` across all 92 logs** | **0** — read off the grep, never off a tally or an exit code |
| **`SCRIPT ERROR` across all 92 logs** | **0** |
| **`check_ew`** | **38 / 0 — UNMOVED**, the batch's central prediction |
| **`check_parse`** | **166 / 0 — unmoved**, residue unchanged |
| **`check_ev`** | **54 / 0 — unmoved** |
| **`check_eu`** | **38 / 0 — unmoved** |
| **run harness** | GATE 1 **22**, GATE 2 **166**, GATE 3 **8**, all PASS, throws 0 |
| **the only red in the run** | **`check_cm_live` 13 / 4**, and its four FAIL lines were READ and confirmed to be the four its baseline row names: *the bar appeared on the enemy's attack*, *the bar's top line names the incoming blow*, *the brace lands near x0.85*, *the brace's Break half lands near x0.75*. Identical on unmodified HEAD; the row carries `fails: [4, 4]` for that reason. |

### **§7c — THE POST-RUN EDITS**

**Two files were written after the battery: this report's §6d–§7, and `docs/state.md`'s battery
line.** Both were checked against the population rule rather than assumed harmless: **no `.gd` in
the tree opens either file** — `grep -rn 'res://docs/state.md'` and `grep -rn 'docs/reports'` return
only comments naming the paths, against a control of 25 real readers for `master.html`. **No
document with a reader was touched after the run**, so there is nothing that needs re-running.

**AND IT WAS RUN ANYWAY, BECAUSE A SWEEP HAS HOLES A RUN FINDS.** Six document-heavy targets were
re-driven against the post-run tree and compared against their own battery readings:
**`test_batch_bx` 161 / 0, `test_batch_ce` 1114 / 0, `test_batch_bs` 267 / 0, `test_batch_at`
467 / 0, `check_dm` 93 / 0, `check_ec` 23 / 0** — **all six IDENTICAL to the battery, 0
`Parse Error` and 0 `SCRIPT ERROR`.** Not merely green: unmoved.

*(Three of the six printed nothing under the first verdict grep, which reads as "did not run"
rather than as "the grep is too narrow" — this project's suites print at least three verdict
shapes, and `BATCH BX: 161 checks, 0 FAILED` is not the shape a gate prints. Read directly
instead.)*

**AND THE POST-RUN EDITS MOVED EXACTLY ONE NEEDLE.** Re-sweeping after them, `docs/state.md`'s
GAINED count goes from 2 to 3 and the new needle is `'freeze'`; every other document's LOST and
GAINED counts are unchanged from the pre-battery sweep.

### **§7d — THE DATE, STATED RATHER THAN QUIETLY CHOSEN**

The measurement, the ruling and the implementation were all done on **2026-09-04** and the batch is
dated for that working day, as EU, EV and EW all are. **The battery and the commit crossed midnight
into 2026-09-05.** The stamp and the changelog carry the working day; this line is here so the
one-hour discrepancy is on the record rather than discovered later.

---

## §8 — WHAT MOVED

**MOVED:** `scripts/battle.gd` (one constant and the comment above it); `docs/changelog.html`;
`CLAUDE.md`; `docs/master.html` and its stamp; `data/glossary.json`; `docs/design-notes.md`;
`baselines.json`; `docs/state.md`; and this report.

**DELIBERATELY DID NOT MOVE:** Focus's point and rate; the four roll sites and the one body;
the unclamped roll; `BOND_MITIGATION_MAX`; `BOND_CONVERT`; `_bond_fallback`; `check_ew` itself;
`run_battery.sh`; and `docs/reports/EW.md`, which is EW's record.
