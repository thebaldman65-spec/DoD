# BATCH EY — THE BASE SWEEP GOES 0.72s → 1.00s

**Ruled by the designer and built: the checks feel too hard, so the bar slows.**
`SC_PROFILE_DEFAULT.sweep_time` moves **0.72 → 1.00**. **`perfect_half` 0.045 and `good_half` 0.16
are untouched** — the bar slows, the target does not grow.

**The executable diff is ONE line.** It reaches every skill check in the game. **One gate moved with
it and had to**, and the brief did not name it.

---

## THE BRIEF'S PREMISES, RE-DERIVED

**The brief said to verify every premise. Most reproduce. Four do not, and one of them would have
shipped a red gate.**

| the brief's claim | what the tree and the readings say |
|---|---|
| *"`SC_PROFILE_DEFAULT.sweep_time` **0.72 → 1.00**"* | **BUILT. One executable line**, proved by a comment-stripped diff with identical line counts either side (14,251 both). §1. |
| *"`PERFECT_HALF` and `GOOD_HALF` are untouched at 0.045 and 0.16"* | **CONFIRMED, and the drawn zones with them** — the Good band is 2 × 0.16 of the track before and after, measured off the live `ColorRect`. §1, §5. |
| *"At `PERFECT_HALF` 0.045 the Perfect window is roughly **65ms** today and **90ms** after"* | **CONFIRMED EXACTLY: 64.80 ms → 90.00 ms.** The Good window goes 230.40 → 320.00 ms. §1. |
| *"**Every caller uses the default except the Sharpshooter's basic attack** — confirm that is still true"* | **CONFIRMED, and it is stronger than "every caller": there are exactly TWO call sites** of `_run_skill_check` in the tree. The cast path passes his profile or `{}`; the defensive check passes nothing at all. §1a. |
| *"report whether the Sharpshooter's profile inherits the base or restates it. **If it restates it, this change misses him**"* | **IT DOES BOTH, AND THE CONDITIONAL IS THE WRONG READING.** He restates `sweep_time` (a flat 0.52 s, unmoved) and **inherits both half-widths through `SC_PROFILE_DEFAULT["sweep_time"]`**. The change reaches him in full, as tolerance rather than as pace. **§1a — this is the finding the brief asked for, with the opposite answer.** |
| *"CM's five gated abilities — Death Ray, Requiem, Reckless Abandon, Boil Over, Unleash"* | **CONFIRMED — five `"gated": true` entries in `classes.gd` and no sixth**, and they are those five. §2. |
| *"The Warden braces on **every incoming attack**"* | **TWO NARROWINGS SHORT.** A counter raises no bar and neither does an attack carrying a `special` — `_defensive_brace` returns false on `is_counter`, on `ab.special != ""` and on `ab.damage <= 0`. §2a. |
| *"CM measured 9.4 a battle against 27.3 hero actions"* | **NEITHER REPRODUCES.** Measured today at rung 2 with a Warden party: **6.6 defensive bars a battle**, **29.7 hero turns**, of which only **10.9 open a bar at all**. §2a. |
| *"**The bot never runs the bar** … every completion figure this project has produced is blind to this change"* | **CONFIRMED, AND DEMONSTRATED RATHER THAN ASSERTED**: `check_cs` prints *the bot lands 2.69 of four* identically before and after. **No completion arm was run and none is quoted.** §3. |
| *"`CRIT_EXCESS_STEP` stays at 0.50, the Loyalty split at 8, `BOND_MITIGATION_MAX` at 0.75"* | **ALL THREE CONFIRMED IN PLACE AND BYTE-UNCHANGED.** §6. |
| the file list in §5 — changelog, `CLAUDE.md`, state, baselines, report, design-notes, master, glossary, stamp | **INCOMPLETE BY ONE SOURCE FILE.** `check_cn.gd` pins the profile **by number**; moving the constant without moving the pin reads **1 failure against a `fails: [0, 0]` row**. Armed both ways. **§4.** |

---

## §1 — THE CONSTANT, AND THE ARITHMETIC IT MOVES

`scripts/battle.gd` — `SC_PROFILE_DEFAULT["sweep_time"]` **0.72 → 1.00**. Nothing else in the
dictionary moves.

**THE WINDOWS, REPORTED AS ARITHMETIC RATHER THAN AS A VERDICT.** A window's full width is
`2 × half × sweep_time`:

| | half-width | at 0.72 | at 1.00 | change |
|---|---|---|---|---|
| **Perfect** | 0.045 | **64.80 ms** | **90.00 ms** | +25.20 ms (×1.3889) |
| **Good** | 0.16 | **230.40 ms** | **320.00 ms** | +89.60 ms (×1.3889) |

**THE PICTURE DOES NOT MOVE, AND THAT IS THE POINT OF SPENDING THE TOLERANCE HERE.** `sweep_time`
is not drawn: `_apply_sc_profile` sizes the two `ColorRect`s off `centre` and the half-widths alone.
Measured off the live rects (§5), the Good band is **0.3200 of the track** and the Perfect band
**0.0900** before and after — identical — while the marker crossing them takes 38.9% longer.
**Widening the half-widths instead would have bought the same seconds and redrawn the bar**; it was
priced and not taken, and the reason is now a standing rule in `CLAUDE.md` (§4 of the brief).

**THE MARKER TURNS ROUND RATHER THAN WRAPPING**, and every press starts at `sc_pos = 0.0`
(`battle.gd`, the per-press loop), so **a player aiming at the centre presses at exactly half a
sweep**: 0.36 s → 0.50 s. That half-sweep is the unit §2a's wall-clock is priced in.

### **§1a — THE SHARPSHOOTER: HE RESTATES `sweep_time` AND INHERITS THE TOLERANCE**

**The brief asked which, and said that if he restates it the change misses him. He does both, and it
does not miss him.**

`_sharpshooter_basic_profile` builds his dictionary like this:

```
var scale := float(SC_PROFILE_DEFAULT["sweep_time"]) * SS_SEQ_OFFSET / SS_SEQ_SWEEP
    "perfect_half": float(SC_PROFILE_DEFAULT["perfect_half"]) * scale,
    "good_half":    float(SC_PROFILE_DEFAULT["good_half"]) * scale * open_widen,
    "sweep_time":   SS_SEQ_SWEEP,
```

**`sweep_time` IS RESTATED** — the literal `SS_SEQ_SWEEP`, 0.52, and it does not move. **BOTH
HALF-WIDTHS ARE DERIVED THROUGH THE BASE SWEEP**, so `scale` goes 1.176923 → 1.634615 and his
tolerance in seconds moves by exactly the factor everyone else's does. `half × his_sweep` stays
exactly `SS_SEQ_OFFSET` × the default's, which is what CN's *fixed offset, not a slope* has to mean.

| | at 0.72 | at 1.00 | |
|---|---|---|---|
| his sweep | 0.52 s | **0.52 s** | unmoved — measured at all four press counts |
| his `perfect_half` | 0.052962 | **0.073558** | |
| **his Perfect window** | **55.08 ms** | **76.50 ms** | exactly ×0.85 of the default's, at both |
| his opening Good window, n=1 | 195.84 ms | **272.00 ms** | |
| n=2 | 255.96 ms | **355.50 ms** | |
| n=3 | 308.25 ms | **428.13 ms** | |
| n=4 | 364.46 ms | **506.19 ms** | |

**SO HE IS THE ONE CASTER WHO TAKES ALL OF THIS CHANGE'S DIFFICULTY AND NONE OF ITS WALL-CLOCK.**
Every other bar in the game pays 38.9% more seconds for 38.9% more tolerance; his pays nothing and
gets all of it. **The reading that would have missed this is a key-by-key look at the returned
dictionary** — `"sweep_time": SS_SEQ_SWEEP` really is a restatement — and the inheritance is one
line above it, in `scale`. **`CLAUDE.md` now says to read the derivation, not the key.**

### **§1b — AND HIS FOUR-PRESS OPENING WINDOW IS NOW 97.3% OF THE TRACK**

`good_half` is a half-width on a 0..1 track centred at 0.5, so **0.5 is the whole of one side**.

| n | opening `good_half` at 0.72 | at 1.00 | miss band at 1.00 |
|---|---|---|---|
| 1 | 0.1883 | 0.2615 | 0.2385 of the track each side |
| 2 | 0.2461 | 0.3418 | 0.1582 |
| 3 | 0.2964 | 0.4117 | 0.0883 |
| **4** | **0.3504** | **0.4867** | **0.0133 — 6.9 ms at each end of his 520 ms pass** |

At 150+ Focus his first press is Good across **97.3% of the bar**, against 70.1% yesterday. **This
is the arithmetic working as designed and nothing in this batch touched it**: `SS_SEQ_OPEN` holds
his SEQUENCE risk flat across press counts, and holding a flatter risk constant at an easier base
necessarily opens the first window further. **It is named because there is no tolerance left to
spend on him** — one more step of this size runs the opening Good half past 0.5, at which point his
four-press opening window is the entire track and the number stops meaning anything.

---

## §2 — WHAT ONE CONSTANT REACHES

**Named in the record rather than inferred, as the brief asked.**

**THE FIVE GATED ABILITIES**, verified as exactly five `"gated": true` entries in `classes.gd` and
no sixth: **Reckless Abandon** and **Boil Over** (Berserker), **Death Ray** (Arcanist), **Requiem**
(Occultist), **Unleash** (Beastmaster). **A Sloppy loses the whole cast**, so a slower bar is a
direct difficulty reduction on the five most decisive cards in the game — not a cosmetic one.

**THE DEFENSIVE CHECK.** The Warden always; the Swordmaster while in the Defensive guard, or
holding Formless (`_has_defensive_check`, read off `passive_id` and `stance`). It is the
highest-volume bar there is.

**THE SHARPSHOOTER'S PRESS LADDER** — up to four presses, each on the new base, per §1a.

**EVERY ORDINARY CAST IN THE GAME.** There are exactly **two call sites** of `_run_skill_check` in
the tree: the cast path (`battle.gd:3894`) and the defensive check (`battle.gd:23175`). The second
passes no profile at all, so it is the pure default; the first passes the default for everything
that is not the Sharpshooter's basic.

### **§2a — THE PACING COST, MEASURED — AND CM'S FIGURES DO NOT REPRODUCE**

**The brief quotes CM: 9.4 defensive checks a battle against 27.3 hero actions. Neither number is
today's.** Re-measured on the shipped sim, n=200 battles, `DOD_SIM_DIFFICULTY=warden`, party
`warden,cryomancer,inquisitor,beastmaster`:

| | measured | the brief's figure |
|---|---|---|
| defensive bars / battle | **6.6** | 9.4 |
| hero turns / battle | **29.7** | 27.3 |
| **hero turns that OPEN A BAR** | **10.9** | not distinguished |
| **total bars / battle** | **17.5** | — |

**THE THIRD ROW IS THE ONE THE BRIEF'S COMPARISON WAS MISSING.** "27.3 hero actions" is not the
denominator a bar count belongs over: basic attacks and every ability with nothing for the grade to
multiply resolve at a fixed Good with no bar. Only **10.9 of 29.7 hero turns raise one**.

**AND CM'S OWN COMMENT IS NOW WRONG BY THE SAME AMOUNT.** `battle.gd` says the Warden's bar
*"roughly doubles the presses in a fight he is holding"*. Measured: **10.9 → 17.5, which is ×1.61**.
*(Left standing rather than corrected: it is a claim about a measurement, this batch re-measured it,
and the corrected figure is here and in `docs/state.md`. Correcting the comment would have put a
second edit in `battle.gd` for no behaviour.)*

**THE WALL-CLOCK.** A centred press costs half a sweep, so a bar costs **+0.14 s**:

| | bars/battle | +s / battle (centred press) | +s / battle (a whole pass) |
|---|---|---|---|
| Warden party, ordinary casts | 10.9 | +1.52 | +3.04 |
| Warden party, defensive bars | 6.6 | +0.92 | +1.85 |
| **Warden party, total** | **17.5** | **+2.44** | **+4.89** |
| a party with no Warden | 9.0 | +1.27 | +2.53 |

**Across a 49-encounter clear that is about two minutes**, or four at the upper reading. **That is
the price of the ruling, and it was known before it shipped** — it is the pacing risk CM flagged and
deliberately left uncapped, now with a number on it.

**"EVERY INCOMING ATTACK" IS TWO NARROWINGS SHORT**, which is worth saying because it is what keeps
6.6 from being much larger: `_defensive_brace` returns false on a **counter** (a free swing drawn by
the hero's own action) and on an attack carrying a **`special`** (it never reaches the ordinary
strike loop, which is the only place the mitigation is applied), as well as on `ab.damage <= 0`.

---

## §3 — NO SIM CAN MEASURE THIS, AND NONE WAS RUN

**The bot never touches the bar.** `battle.gd`'s autoplay branch rolls a grade off two fixed
thresholds — 20% perfect, 15% sloppy — and enemies resolve at a flat Good. `_defensive_brace` takes
the same road: under `_nobody_can_press()` it rolls `randf() < DEF_BOT_PERFECT` and never opens a
bar. **So every completion, win-rate and damage figure this project has ever produced is blind to
this change**, and a run before and against after would report the difference between two seeds.

**THIS IS DEMONSTRATED RATHER THAN ASSERTED.** `check_cs` §5 prints the bot's own sequence result
every run. Before the change and after it, both readings are **`the bot lands 2.69 of four`** —
bit-identical across a change that moves every window in the game by 38.9%. That line is the
statement "the instrument cannot see this" in the instrument's own words.

**NO COMPLETION ARM WAS RUN AND NONE IS QUOTED**, per the brief. A number that cannot measure the
thing is worse than no number, because a later reader will cite it.

**THE BAR COUNT IS A DIFFERENT QUANTITY.** How often a bar *would* open is structural — it depends
on the ability, the passive and the attack, none of which the grade touches — and the sim keeps it
already (`_stat("def_checks")`, printed as *Defensive checks/battle*). That is what §2a measures,
and it is why §2a is legitimate where a completion figure would not be. The hero-side half needed one
counter that does not exist in the shipped tree, so it was added **on an out-of-repo copy**: a single
`_stat("hero_bars")` immediately above the autoplay roll, which is the exact branch a bar opens on.
**Not one executable byte of the shipped tree carries an instrument.**

---

## §4 — THE GATE THE BRIEF DID NOT NAME, AND IT WOULD HAVE SHIPPED RED

**`check_cn.gd` carries a literal copy of the whole default profile**, `sweep_time` included:

```
const WANT_PROFILE := {
	"perfect_half": 0.045, "good_half": 0.16, "centre": 0.5,
	"sweep_time": 0.72, "presses": 1, "press_taper": 1.0,
}
```

**That is the gate doing exactly the job its own header claims** — *"If a later batch edits these it
changes every check in the game at once, which is the point of asserting them here"* — and it means
moving the constant is **two edits, not one**. The brief's §5 file list has no source file in it but
`battle.gd`.

**ARMED IN BOTH DIRECTIONS, ON A CLEAN OUT-OF-REPO COPY OF THE POST-EDIT TREE:**

| arm | reading |
|---|---|
| **old pin (0.72) against the new constant** | **`FAIL: default profile sweep_time = 1.0, want 0.72` — 1 failure**, against a `fails: [0, 0]` row |
| **moved pin (1.00) against the new constant** | **0 failures** |

**THE PIN WAS MOVED TO THE NEW VALUE, NEVER LOOSENED.** The rest of `check_cn` needed nothing: its
zone-rect and grade-boundary assertions are written against `prof["good_half"]` and
`prof["perfect_half"]`, which did not move, and its field-count assertion is about the dictionary's
size. **`check_cn` reports no readable check count**, so the failure count is the whole row and the
row is unmoved at `[0, 0]`. `CLAUDE.md` now records that moving a profile value is two edits.

### **§4a — `check_cs` HOLDS AT 104 / 0, WITH A QUARTER OF THE SLACK IT HAD**

`check_cs` §4 re-derives the Sharpshooter's model from the constants every run and asserts that the
whole sequence lands **within 2 points of a one-press cast** at every press count. **Every figure
inside it is taken RELATIVE to `SC_PROFILE_DEFAULT`**, so the base sweep moving does not move an
assertion — and it does not:

| | n=1 | n=2 | n=3 | n=4 | widest spread against n=1 |
|---|---|---|---|---|---|
| at 0.72 | 89.7% | 90.0% | 90.0% | 90.0% | **0.003** |
| at 1.00 | **97.7%** | **98.5%** | **98.7%** | **98.8%** | **0.011** |

**Still passing, against a 0.02 bound, at a quarter of the margin.** Recorded in `baselines.json`'s
own row, because the next batch to widen a window is the one that finds out. *(The model's absolute
level is not a measurement of anything — it rests on a stated Gaussian with SD 60 ms, which
`check_cs` says out loud. What is asserted is the FLATNESS, and it holds.)*

**MY OWN ARITHMETIC REPRODUCES THE GATE'S TO THE PRINTED DIGIT** — 97.7 / 98.5 / 98.7 / 98.8 from an
independent implementation of the same model, which is how the window table in §1a was checked
before the gate was run.

---

## §5 — DRIVEN LIVE, BECAUSE A STALE PROFILE WOULD PASS EVERY STATIC CHECK

**The brief's sharpest verification demand: a `sweep_time` read once at UI setup rather than per cast
would pass every static check in this report.** It is answered by driving the bar rather than by
reading the source.

**AN OUT-OF-REPO PROBE** (`ey_bar_probe.gd`, in a copy of the tree; nothing in the repo carries it)
spawns a real non-autoplay battle with a Warden and a Sharpshooter, opens real bars through
`_run_skill_check`, and **integrates `_process` by hand**: it reads `sc_pos`, calls `_process(dt)`
with a known delta and reads `sc_pos` again, with **no `await` between the two readings** so the
engine cannot tick in the middle. `dt / Δpos` is the live sweep time.

**39 checks, 0 failures, 0 `Parse Error`, 0 `SCRIPT ERROR`.**

- **The marker moves at `1.000000 s` per end-to-end pass** — and at **two different frame lengths**
  (10 ms and 37 ms), because a probe that only works at one delta is measuring the frame.
- **THE CONTROL: the probe reads `0.720000` back when a stale 0.72 is planted in the live profile.**
  Without this the reading above proves only that the probe returns 1.00, not that it could ever
  have said otherwise.
- **The drawn zones and the graded halves agree and did not move**: Good 0.3200 of the track,
  Perfect 0.0900, `good_half` 0.16, `perfect_half` 0.045.
- **His basic still runs its own ladder**: at 1 / 2 / 3 / 4 presses the profile asks for that many,
  every press was driven, and all of them landed. **His sweep reads 0.5200 at every count** and his
  Perfect time is ×0.85 of the NEW default's at every count.
- **THE PROFILE IS REBUILT PER CAST**, which is CN §1's requirement proved by driving it: four
  consecutive casts alternating Sharpshooter and ordinary read **0.52 / 1.00 / 0.52 / 1.00**. A
  value cached at UI setup would have read the same number four times.

---

## §6 — WHAT DID NOT MOVE, CHECKED RATHER THAN ASSERTED

**THE EXECUTABLE DIFF IS ONE LINE.** A comment-stripped diff of `battle.gd` against HEAD's copy
shows exactly `"sweep_time": 0.72,` → `"sweep_time": 1.00,`, with **identical stripped line counts
either side (14,251 both)** — so the comment edits above swallowed no code.

- **`perfect_half` 0.045, `good_half` 0.16, `centre` 0.5, `presses` 1, `press_taper` 1.0** — the
  other five fields, asserted live by `check_cn` and by the probe.
- **`SS_SEQ_SWEEP` 0.52, `SS_SEQ_OFFSET` 0.85, `SS_SEQ_OPEN`, `SS_SEQ_TAPER` 0.85,
  `SS_SEQ_STEP` 50, `SS_SEQ_MAX_PRESSES` 4, `SS_SEQ_FOCUS_PER_PRESS` 8, `SS_SEQ_FULL_BONUS` 20** —
  byte-unchanged, and the last four asserted by `check_cs`.
- **The grades, the multipliers, CM's gating, the mitigate-only defensive rule and the press
  ladder** — untouched. `_grade_skill_check` still takes no arguments.
- **`CRIT_EXCESS_STEP` 0.50, `BOND_CONVERT` 8, `BOND_MITIGATION_MAX` 0.75** — in place and
  byte-unchanged.
- **NO RUNE IS AUTHORED.** The twenty-one are EZ, and the whole reason EY shipped alone is that a
  fight that feels better must be attributable to one of the two.

**THREE COMMENTS MOVED IN `battle.gd` AND NOTHING ELSE DID.** Two named `0.72` in a way that read as
the live value while recording history (*"the 0.72s sweep was a literal in `_process`"*, *"what the
0.72 always meant"*) and now name it as the pre-CN literal; the third records this ruling and the
`check_cn` trap at the constant itself, which is where a batch about to edit it looks. **After the
edits the only `0.72` anywhere in a `.gd` is in those three comments** — `grep` for `0.72s`,
`0.7s each way` and `about 0.7s` across the corpus returns the one comment and nothing else, against
a control of 15 hits for `sweep_time`.

---

## §7 — VERIFICATION

### **§7a — THE PRE-CHECKS, WRITTEN BEFORE ANYTHING WAS EDITED**

- **The parse floor, grepped from stderr and never from a tally or an exit code**: **0
  `Parse Error`**, `check_parse` **166 / 0**, before and after.
- **`check_cn` 0 failures and `check_cs` 104 / 0**, both read standalone at 0.72 first, with the
  battery's own flags (neither carries an `EXTRA` entry, so bare `--headless --path .` is exact).
- **The documents were snapshotted and their readers counted before a byte moved**: `CLAUDE.md` 27,
  `docs/master.html` 25, `data/glossary.json` 18, `docs/changelog.html` 16, `docs/design-notes.md` 4,
  `baselines.json` 1, **`docs/state.md` 0**.

### **§7b — THE PREDICTED BASELINES, WRITTEN BEFORE THE RUN**

**No row moves.** `check_cn` predicted **unmoved at 0 failures** *(given the pin moves with the
constant — the whole of §4)*, `check_cs` **unmoved at 104 / 0**, `check_parse` **unmoved at 166 / 0**.
No target joins or leaves the battery and no new gate was written, so **no baseline row was added.**
`baselines.json` carries an EY note on `check_cn` and on `check_cs` recording what happened
*beneath* those rows while the rows held.

### **§7c — THE INSTRUMENTS, AND TWO OF THEM HAD HOLES FOUND BEFORE THEY WERE TRUSTED**

**THE SCAN-WINDOW CENSUS, AND ITS EXTRACTOR WAS A POPULATION.** Suites read `battle.gd` through
fixed-size `substr` windows anchored on a `find()`, and a window spanning an insertion silently loses
content off its far end. The four edit ranges were derived from an opcode diff against HEAD
(bytes 950–1033, 1920–2710, 3409–3430 and 1173671–1173743) and every `find()` anchor in the corpus
was located in the new file and checked against them.

**The first pass matched only DOUBLE-quoted anchors and read 160.** The tree holds **198**, and
**48 of the literals are single-quoted** — including `find('\t\t"precision_strike":')`, which is the
anchor of the widest fixed-size window in the whole tree (3,000 bytes). Re-run over both quote forms
and checked at ±3,400 bytes: **16 anchors land in reach and every one of them is generic**
(`'\nfunc '`, `'\n\t\t"'`, `'else:'`), used to bound a body relatively. **No specific anchor is
within reach of any edit, and none is anywhere near the three at the top of the file.**

**THE LITERAL SWEEP — 18,790 needles from 124 `.gd` files, floor 4 — WAS ARMED IN BOTH DIRECTIONS
BEFORE IT WAS USED.** Needles chosen out of the list rather than invented: deleting one that
`master.html` carries **exactly once** reads **LOST 1**; injecting one the file genuinely does not
carry reads **GAINED 3**; an unchanged copy reads **0 / 0**.

**AND A `grep -rn -- "$n" --include='*.gd'` SILENTLY SEARCHED EVERY FILE TYPE AGAIN** — the bare
`--` turns `--include` into a file operand, which is the exact fault EX recorded. Caught on the
warning line, redone without it. It fails toward MORE results, so the corrected reading is the
narrower one.

### **§7d — THE SWEEP'S RESULT, AND THE ASSERTIONS ENUMERATED RATHER THAN THE LITERALS**

**LOST 0 in every document.** That is the half that matters: nothing an assertion reads was removed.

| document | LOST | GAINED | what asserts on it |
|---|---|---|---|
| `docs/master.html` | **0** | **0** | 25 readers — and the file carries three changed numbers, so 0/0 is the proof that no suite pins `0.72s` |
| `data/glossary.json` | **0** | **0** | 18 readers |
| `CLAUDE.md` | 0 | 1 (`sweep_time`) | 27 readers; no reader carries it as a literal against `CLAUDE.md` |
| `docs/changelog.html` | 0 | 15 | 16 readers; the changelog windows are anchored on `&mdash; Batch XX:` and bounded by the next `<h2>`, and the EY entry is above all of them |
| `baselines.json` | 0 | 5 | 1 reader (`check_de`), which JSON-parses it and never prints a note into a log |
| `docs/design-notes.md` | 0 | 4 | 4 readers |

**AND THE GAINED NEEDLES WERE CHECKED AGAINST EVERY NEGATIVE ASSERTION IN THE TREE**, because a
needle a document *gains* is only dangerous if something forbids it. **311 `not X.contains(…)`
assertions** were extracted from the corpus and cross-matched against all 25 gained needles:
**zero collisions.** *(Three apparent hits were one assertion, `not bsrc.contains(".")`, whose
holder is `battle.gd` source and not a document — a substring artefact of the matcher, checked by
hand.)* The sharpest of these is `FAIL: default profile`, which the `baselines.json` note now
carries: the battery counts failures with `grep -cE '^ *FAIL'` **over the logs**, `check_de` never
prints a baseline note, and no `.gd` greps `baselines.json` as text.

**THE HOLE THE SWEEP CANNOT SEE — a needle already present cannot be seen arriving a second time —
was closed directly instead**: the strings this batch REMOVED were grepped for by hand across the
whole corpus (`0.72s`, `0.7s`, `about 0.7s`, `0.7s each way`), and **not one appears in any `.gd`
except my own comment.**

### **§7e — THE FREEZE**

An md5 stamp of **all 334 files with ABSOLUTE paths**, taken immediately before the launch and again
after. **ZERO DIFFER.** Not one `.gd`, `.json`, `.html`, `.md`, `run_battery.sh` or `project.godot`
moved while the battery read them.

**AND THE POPULATION CLOSES THE GAP EX NAMED.** EX's list was `git ls-files`, so its own untracked
report sat outside it. This one is `git ls-files` **plus** `git ls-files --others
--exclude-standard` — every tracked *and* untracked file — and it was re-derived after the run as
well: **nothing appeared in the tree that the list did not already cover.** (There were no untracked
files at launch: `docs/reports/EY.md` did not exist yet, which is §7g.)

### **§7f — THE BATTERY**

**92 targets, `sort .ran | uniq -d` holds ZERO duplicates** — one battery wrote these logs — and
**0 `Parse Error`, 0 `SCRIPT ERROR` and 0 `*** TIMED OUT ***` across every one of the 92 logs.**
The parse floor is read off the grep, never off a tally and never off an exit code.

| | |
|---|---|
| **`check_de` — the count differ** | **378 checks / 0 failures / 0 NOTICES.** No baseline row moved and none rose, which is what "every row predicted unmoved" has to look like |
| **`check_cn`** | **0 failures — UNMOVED**, the batch's central prediction, with the pin moved beneath it (§4). It reports no readable check count, as its row records |
| **`check_cs`** | **104 / 0 — unmoved**, at 0.011 of its 0.02 bound instead of 0.003 (§4a) |
| **`check_parse`** | **166 / 0 — unmoved**, residue unchanged at 4 |
| **`check_ed`** (the pin manifest) | **18 / 0** | 
| **`check_ec`, `check_dm`, `check_el`, `check_da`** (the document-heavy gates) | **23 / 0, 93 / 0, 23 / 0, 41 / 0** |
| **`check_ew`, `check_ev`, `check_eu`** | **38 / 0, 54 / 0, 38 / 0 — all unmoved** |
| **run harness** | GATE 1 **22**, GATE 2 **166**, GATE 3 **8**, all PASS, throws 0 |
| **scene runs** | `check_map_screen` throws 0; `check_ct_map` **83 / 0** |
| **the only red in the run** | **`check_cm_live` 13 / 4** |

**THE ONE RED WAS READ AND CONTROLLED RATHER THAN ASSUMED.** Its four FAIL lines are exactly the
four its baseline row names — *the bar appeared on the enemy's attack*, *the bar's top line names
the incoming blow*, *the brace lands near ×0.85*, *the brace's Break half lands near ×0.75* — and
because **this gate is the only thing in the tree that presses the defensive bar**, "it was already
red" is not good enough here: a change to the bar could plausibly have moved it. **It was re-run on
an out-of-repo copy of the tree with `battle.gd` and `check_cn.gd` restored to HEAD** (`sweep_time`
0.72 verified in place) and reads **13 / 4 with the same four lines, character for character.**

### **§7g — THE POST-RUN EDITS**

**Two files were written after the battery: this report, and `docs/state.md`'s §7 line.** Both were
checked against the population rule rather than assumed harmless. **No `.gd` in the tree opens
either**: `grep -rn 'res://docs/state.md'` and `grep -rn 'res://docs/reports'` both return **0**,
against a control of **29 load sites for `res://docs/master.html`**. Every apparent reference to
either path in a `.gd` is a comment naming it. **No document with a reader was touched after the
run**, so there is nothing that needs re-running.

**AND IT WAS RUN ANYWAY, BECAUSE A SWEEP HAS HOLES A RUN FINDS.** Six document-heavy targets were
re-driven against the post-run tree and compared against their own battery readings:
****`test_batch_bx` 161 / 0, `test_batch_ce` 1114 / 0, `test_batch_bs` 267 / 0, `test_batch_at` 467 / 0, `check_dm` 93 / 0, `check_ec` 23 / 0** — all six IDENTICAL to their battery readings** — 0 `Parse Error` and 0 `SCRIPT ERROR`. Not merely green: **unmoved**.

**AND THE POST-RUN EDITS MOVED NO NEEDLE IN ANY DOCUMENT THAT HAS A READER.** Re-sweeping every
document after them against the same pre-edit snapshots, `docs/master.html`, `data/glossary.json`,
`CLAUDE.md`, `docs/changelog.html`, `baselines.json` and `docs/design-notes.md` are **identical to
the pre-battery sweep, LOST and GAINED both** — **master 0/0, glossary 0/0, `CLAUDE.md` 0/1, changelog 0/15, baselines 0/5, design-notes 0/4, exactly as before** — so the post-run edits moved nothing at all in a document anything reads.

### **§7h — THE DATE**

The measurement, the implementation, the battery and the commit were all done on **2026-09-05**, and
the stamp, the changelog and this report all carry that day. EX's entry is dated 2026-09-04 and its
own §7d records that its battery crossed midnight into the 5th; **there is no gap between them.**

---

## §8 — WHAT MOVED

**MOVED:** `scripts/battle.gd` (one constant and three comments); `check_cn.gd` (the pin);
`docs/changelog.html`; `CLAUDE.md`; `docs/master.html` and its stamp; `data/glossary.json`;
`docs/design-notes.md`; `baselines.json`; `docs/state.md`; and this report.

**DELIBERATELY DID NOT MOVE:** the other five profile fields; all eight `SS_SEQ_*` constants; the
grades and multipliers; CM's gating and the mitigate-only defensive rule; `CRIT_EXCESS_STEP`,
`BOND_CONVERT` and `BOND_MITIGATION_MAX`; `check_cs` and every other gate; `run_battery.sh`; every
baseline COUNT; and `docs/reports/EX.md`, which is EX's record.
