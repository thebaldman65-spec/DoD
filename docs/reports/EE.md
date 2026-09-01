# BATCH EE — THE RATIO IS RETIRED, AND THE INSTRUMENT STOPS MEASURING ITSELF

**A target that could be met by committing an unrelated file, and a measurement whose evidence
included the batch's own output.**

The 3%-of-sync target is **retired** and replaced by a stated ceiling of **290 KiB** with a
procedure that is a SPLIT and never a prune. `docs/state.md` is **out of the citation corpus**, and
the general rule — an instrument's corpus must not contain what the instrument rewrites — is written
down with the four places that already close it. `pin-manifest.json` is **deselected from the sync**,
which is a list for the designer's file picker and not a repo change. And the slice sweep was
re-run, because §4 asked for a confirmation: **it found three more.**

**No game behaviour changed, no ability moved, no card was authored.**

---

## THE BRIEF'S FIGURES, RE-DERIVED

The brief said *derive, do not recall*, and it is right to: three of ED's figures move when
re-derived, and two of the brief's own do.

| the brief or ED said | re-derived at ED's HEAD | why |
|---|---|---|
| DZ pruned to **2.948%** | **2.929%** | different sync set; mine reproduces ED's EC and ED rows exactly |
| DZ's prune "**bought eleven batches**" | **two** (DZ 2.929 → EA 2.961 → **EB 3.044**) | eleven was a projection off the growth rate; two is what happened |
| DZ's cut was **51.21 KiB** | **51.18 KiB** (52,404 B) | rounding |
| +**4,835 B**/batch over 18 prune-free batches | +**4,520 B** over 19 (DK→ED, DZ excluded) | a different window and a different treatment of the prune batch |
| the sync grows +**79,726 B**/batch | +**92,506 B** over the same 19 | ED's own 296 KiB manifest is inside mine |

**Reproduced exactly, which is what makes the rest trustworthy:** EC at **234,401 B / 164 files /
7.23 MiB / 3.093%**, ED at **238,678 B / 168 files / 7.60 MiB / 2.994%**, and `CLAUDE.md`
segmenting into **94 blocks partitioning all 232,823 characters** at EC — ED's exact figures, off an
independently written instrument.

**THE SYNC SET IS DERIVED AND STATED, BECAUSE NOTHING IN THE REPO STATED IT.** It is every tracked
file outside `assets/` whose extension is `.gd`, `.md`, `.json`, `.html`, `.sh` or `.py` — **168
files at ED**. That definition is the one that reproduces both of ED's file counts and both of its
byte totals; it had to be recovered by search, and it is written down here so the next batch does
not.

---

## §1 — `CLAUDE.md` IS MEASURED IN KiB. THE CEILING IS 290 KiB, AND THE PROCEDURE IS A SPLIT

### THE THREE READINGS, AND ALL THREE KILL THE RATIO

**(1) THE NUMERATOR IS INSIDE THE DENOMINATOR.** `CLAUDE.md` is one of the 168 files in the sync it
was measured against. Writing a rule moves both halves; committing anything large moves only the
bottom. **ED cleared 3% while the file GREW by 4.17 KiB**, because 296 KiB of `pin-manifest.json`
arrived in the same batch. A target you can meet by committing an unrelated file is not measuring
density.

**(2) THE PRUNE HAS FAILED TWICE, AND THE SECOND TIME IT WAS MEASURED RATHER THAN ARGUED.** DZ cut
**51.18 KiB** at the cost of a whole batch. Derived from git, batch by batch:

| | `CLAUDE.md` | sync | ratio |
|---|---|---|---|
| DY | 268,048 B | 7,365,819 B | 3.639% |
| **DZ** (the prune) | **215,644 B** | 7,363,236 B | **2.929%** |
| EA | 220,492 B | 7,447,632 B | 2.961% |
| **EB** | 228,779 B | 7,515,983 B | **3.044%** |

**Two batches.** ED then read all 43 never-cited blocks and retired **none**. So the prune is not a
lever that can be pulled again — there is nothing left to pull — and the one time it was pulled it
bought two batches for a batch's work.

**(3) THE GROWTH IS ABOVE THE TARGET BY CONSTRUCTION.** Over the nineteen batches DK→ED with the
prune batch excluded, `CLAUDE.md` grows **+4,520 B a batch** (median +4,848, max **+8,287 at EB**)
against a sync growing +92,506. The ratio converges on the marginal rate wherever that sits;
**3% sits below it.**

### THE CEILING IS DERIVED, NOT CHOSEN

**290 KiB**, from two measured quantities and one stated rule:

- **THE FLOOR IS MEASURED: 210.59 KiB.** DZ's prune is the only reading of this file with the
  narrative removed, and ED then read every never-cited block added since and found **zero dead
  rules, zero surviving narrative, and two stale NAMES** — repairs, not retirements. Everything
  above 210.59 KiB has been tested and is live.
- **THE HEADROOM IS MEASURED: ten worst-case batches.** The largest single-batch growth on record is
  **+8.09 KiB (EB)**. **A ceiling within one batch's reach fires on whoever writes the big batch
  rather than on the file's condition** — which is the treadmill in a different unit — so the
  headroom is ten of those, **80.90 KiB**.
- 210.59 + 80.90 = **291.49 KiB, stated as 290 and rounded DOWN.** A ceiling stated above its own
  derivation is one nobody trusts.

**At the measured rate the file reaches 290 KiB in about thirteen batches; at the post-prune rate
(EA→ED, +5.62 KiB) about ten.** The live reading is in `docs/state.md` and it is deliberately **not**
in `CLAUDE.md`: a file that records its own size changes it by recording it, which is §2's shape
arriving inside §1.

### WHAT HAPPENS WHEN IT IS REACHED — THE HALF THAT MAKES IT A RULE

**IT IS A SPLIT. IT IS NEVER A PRUNE.**

**A ceiling in KiB is a ceiling on the READ, not on how many rules the project may hold.** That
distinction is the whole answer. Splitting caps the read without capping the rules; pruning caps the
rules. Both of this file's prunes were the wrong instrument aimed at the right worry.

**AND THE SEAM IS ALREADY MEASURED**, so the procedure is not an aspiration:

| candidate cut | blocks | size |
|---|---|---|
| rules about the INSTRUMENTS rather than about the game | 33 of 96 | **~81 KiB (35%)** |
| the seven `## STANDING REFERENCE —` blocks | 7 of 96 | **24.4 KiB (10.5%)** |
| rules about the game | 57 of 96 | ~143 KiB (62%) |

The instrument/game split is a keyword-weighted classification and is an approximation; the
`STANDING REFERENCE` cut is exact, because those blocks name themselves. **Either is a real seam and
neither needs a judgement call about what is still live** — which is the property a prune could
never have.

**CW's split discipline travels with it**, unchanged: both halves name each other by full path,
every suite whose pin moved is re-pointed in the SAME batch, and the halves are asserted to
re-concatenate. Fourteen suites learned that lesson from the changelog cut.

---

## §2 — THE CITATION CHECK PARTLY MEASURED ITS OWN INPUT

### ED'S ACCOUNT IS VERIFIED FROM GIT, NOT TAKEN ON TRUST

The sentence *"29.5% of the draft layer against 12.8% of the cores"* — the only quotation the
protected-core block ever had — appears **once in EB's `docs/state.md`, zero times in EC's, zero
times in ED's, and nowhere else in the repo at EC.** ED's account of why a block changed category
with nobody touching it is exactly right.

### THE INSTRUMENT HAD TO BE REBUILT, AND THAT IS ITSELF A FINDING

**EC's census script is not in the repo.** Neither is ED's re-derivation of it. So the 33.3% that
three batches have now quoted **cannot be re-derived by anyone except the batch that wrote it** —
which is a stronger version of the problem §2 is about. What follows is a reconstruction, and it is
reported as one.

**IT REPRODUCES ED'S FIXED POINTS EXACTLY**: the segmentation (94 blocks over 232,823 characters at
EC), the sync set (164 files / 7.23 MiB at EC, 168 / 7.60 MiB at ED), and the independent needle
extraction (**57 distinct literals** tested against `CLAUDE.md`, ED's own figure). It reads **22**
blocks asserted where ED read 24, and the quoted/neither boundary depends on **how long a span
counts as a quotation** — a parameter ED's report does not state. So it is swept rather than
chosen.

### HOW THE 43 READS AFTER THE EXCLUSION

At ED's HEAD, over 96 blocks (ED added two headings after its own census ran):

| quotation length | with `state.md` a/q/n | without it | blocks moved |
|---|---|---|---|
| 14 words | 22 / 56 / 18 | 22 / 56 / 18 | 0 |
| 18 | 22 / 40 / 34 | 22 / 40 / 34 | 0 |
| 20 | 22 / 35 / 39 | 22 / 35 / 39 | 0 |
| **22** | **22 / 28 / 46** | **22 / 27 / 47** | **1** |
| 26 | 22 / 21 / 53 | 22 / 21 / 53 | 0 |
| 30 | 22 / 14 / 60 | 22 / 14 / 60 | 0 |

**THE 43 BECOMES 47, AND THE HONEST HEADLINE IS THAT THE EXCLUSION MOVES ONE BLOCK.** The artefact
is small. **It is not zero, and the block it moves is the ruling block itself** — *"NEVER-QUOTED IS
NOT DEAD, AND 3% IS BELOW THIS FILE'S GROWTH LAW"*, whose only quoter in the whole repo was
`docs/state.md`'s paragraph about it. The instrument-measuring-its-own-input shape in its purest
form: **the block stating that the corpus contains `state.md` was being held alive by `state.md`.**

### AND THE ARTEFACT IS DEMONSTRATED, NOT ARGUED

ED's `CLAUDE.md` and everything else held fixed; only `docs/state.md` swapped for each of the last
five batches' versions:

| `state.md` from | blocks `neither` (22-word) |
|---|---|
| DZ | 47 |
| EA | 47 |
| EB | 47 |
| EC | 47 |
| **ED** | **46** |
| **none (excluded)** | **47** |

**The census's answer changes with which batch's `state.md` happens to be on disk, with nothing
else touched.** 47 is the stable reading and it is the one the exclusion produces.

### THE SWEEP FOR THE SAME SHAPE

**Three live instances, and four places that already close it.**

- **THE SYNC RATIO IS THE SECOND INSTANCE, AND IT IS §1'S SUBJECT.** Its denominator holds its own
  numerator, plus `docs/state.md`, `docs/reports/<CODE>.md`, `baselines.json` and
  `pin-manifest.json` — **every one of them written by the batch doing the measuring.** ED's manifest
  moved the ratio below target without the numerator changing at all.
- **EC'S GREEDY WINDOW IS THE THIRD**, already recorded: the defect was live inside the census EC
  used to measure that defect.
- **NO COMMITTED GATE READS `docs/state.md` AT ALL.** Seven `.gd` files name it and **all seven name
  it in a comment** — so the exclusion is a change to an instrument that is not in the repo, which
  is why the rule goes in `CLAUDE.md` rather than into a gate.
- **THE FOUR THAT ALREADY CLOSE IT ARE THE PATTERN TO COPY**: `check_de` and `check_ed` each name
  themselves in a `SELF` constant and drop out of their own sweep; `check_ec` §3 deliberately binds
  **no** document holder, because a section building synthetic assertion text would otherwise be
  extracted as if a suite had written it; `check_da` §3 keeps the same discipline for a gate whose
  source carries its own fingerprint. `check_ec`'s own baseline note already calls this *"the gate
  covering itself rather than a second copy."*
- **AND ONE THAT LOOKS LIKE THE SHAPE AND IS NOT.** `check_de` reads `baselines.json`, which every
  batch rewrites. That is sound, and the distinction is the test: **is the churning file the CLAIM,
  or the EVIDENCE?** `baselines.json` is the claim being tested. `state.md` was being offered as
  evidence about a rule's life.

---

## §3 — `pin-manifest.json` IS DESELECTED

**Not a repo change.** It stays in the repo, `build_pin_manifest.py` goes on deriving it and
`check_ed` goes on reading it off disk every battery.

**THE LIST FOR THE FILE PICKER — DESELECT:**

- **`pin-manifest.json`** — 296.01 KiB, the **fifth-largest** of the sync's 168 files, fully
  re-derivable by a committed generator, and never read by the design instance.

**Already standing as deselectable and unchanged by this batch:** the 47 suite files, `docs/build_docs.py`,
the archived changelog, and any audit document whose findings have been ruled on and applied.

**WHAT MUST STAY SELECTED IS UNCHANGED:** `CLAUDE.md`, `docs/state.md`, `docs/changelog.html`,
`docs/master.html`, `docs/design-notes.md`, `docs/text-standard.html`, `docs/reports/`, and the game
scripts.

---

## §4 — THE THREE ED CLOSED ARE CONFIRMED CLOSED, AND THE SWEEP FOUND THREE MORE

### THE THREE ED CLOSED

- **`wild_communion_ranks`** — absent from `scripts/` and from `CLAUDE.md`; the live field is
  `wild_communion_step`, and `test_batch_ay` still pins the ranked form ABSENT from `battle.gd`.
  Not reopened.
- **The four retired sim flags** — `DOD_SIM_MAP`, `DOD_SIM_MINIBOSS`, `DOD_SIM_START_RUNE` and
  `DOD_SIM_SPEC_OPENING` appear nowhere in `scripts/`, and `CLAUDE.md`'s debug-surface table names
  `sim.sh` and `master.html` as where the record lives. Not reopened.
- **The three locator guards** — `check_dr` §5, `test_batch_bm`'s negative control 4 and
  `test_batch_bs`'s kiln tick all read **guarded** under an independently written classifier, each
  with an `ok()`/`_check()` on the offset. Not reopened.

### AND THE OTHER 84 WERE NOT ALL GUARDED

**The population was re-derived rather than taken from the report, and the definition is stated,
because ED's is not.** A slice counts here if a `substr` offset expression contains a `find` —
**inline, OR through a variable bound from a `find` in the same function.** That reads **129 slices
across 36 files**, a superset of ED's 87. Every site is then asked one question: **if the anchor
stopped resolving, would a check go RED?** Godot hands back `""` for a `substr` off a −1 offset, so
a positive read of the slice reds and a negative read passes in silence.

| | at ED's HEAD | after EE |
|---|---|---|
| **guarded** — an `ok()`/`_check()` asserts the offset resolved | 79 | **82** |
| **self-proving** — a positive read of the slice that cannot pass on `""` | 43 | **43** |
| protected by hand-verified reasoning (below) | 2 | **2** |
| **live, resolving and UNGUARDED** | **5** | **2** |

**The two that remain are the documented carriers** in `test_batch_at` and `test_batch_aw`, recorded
as owed with their reasons. (The third of the "documented vacuous trio", `test_batch_as`, is a bare
`contains` and not a slice at all.) **The three that were not documented are repaired**, one check
each:

1. **`test_batch_bm` §1 and `test_run_harness` gate 2 both slice on `"# The end boss."`** — a
   **COMMENT** in `battle.gd`, ED's own fragile residency class. In the harness the only assertion
   on the slice is a negative one. In `test_batch_bm` there is a positive one and **it does not
   count**: it is one member of an `or` whose sibling reads the un-sliced `body`, so an empty slice
   is covered by the sibling. **EC's group boundary, arriving one layer down.**
2. **`test_batch_bm`'s NEGATIVE 4 victory-branch slice** feeds a `for` loop rather than a
   `contains`: an empty slice yields no lines and the negative below is true of nothing. **The same
   vacuum wearing a loop.**

### TWO THINGS LOOK LIKE A GUARD AND ARE THE OPPOSITE OF ONE

**This batch's own classifier called both of them guarded on its first build**, and the two
documented carriers are what caught it — which is why a control needs a needle whose answer is
already known.

- **A TERNARY IS NOT A GUARD.** `x.substr(i, n) if i >= 0 else ""` reads exactly like one and is the
  **mechanism that makes the vacuum silent**: it converts a crash into a negative assertion that
  holds for every needle. `test_batch_at`'s documented carrier is written in exactly that shape.
- **AN ALTERNATION MEMBER DOES NOT PROVE ITS OWN SLICE.** `ok(slice.contains(A) or
  whole.contains(A), …)` is satisfied by the sibling while the slice reads nothing.

**Both are now in `CLAUDE.md` beside the rule they qualify.**

### THE TWO THAT ARE PROTECTED BY SOMETHING NO PATTERN SEES

Reported rather than repaired, because each is genuinely covered:

- **`test_batch_bm:175`** (`func _resolve_boss`) — unasserted, but **both members of the alternation
  below it read slices of `body`**, so a −1 empties both and the group reds.
- **`test_batch_bm`'s `Run_end_boss_kind()`** — unasserted, but its return feeds
  `Enemies.kinds().has(…)`, and a garbage slice fails that.

---

## §5 — WHAT IS DELIBERATELY NOT DONE

- **NO NEW GATE.** The census instrument is not committed and this batch does not commit one. The
  §2 ruling is a rule in `CLAUDE.md`, because **the thing being ruled on is an instrument that is
  not in the repo** — and a gate asserting a rule about an absent instrument would assert nothing.
  **Recommended, not taken: if the 33.3% is ever to be quoted again, commit the census.** Three
  batches have now quoted a figure no one else can re-derive.
- **THE FILE IS NOT SPLIT.** 290 KiB is not reached. The seam is measured and named so the batch
  that reaches it does not start from nothing.
- **NOTHING IS REMOVED FROM `CLAUDE.md`.** ED established there is nothing to remove; §1 replaces a
  target, not content. The file grew by **4.42 KiB**, which is the measured rate almost exactly.
- **THE TWO DOCUMENTED VACUOUS CARRIERS ARE UNTOUCHED**, in `at` and `aw`, with their reasons.
- **NO ABILITY MAGNITUDE MOVES**, no card is authored, and **`scripts/` is byte-unchanged.**
- **`docs/master.html` IS TOUCHED ONLY AT THE STAMP** — one line, `ED` → `EE`.

---

## §6 — THE CODE CHANGE

- **`CLAUDE.md`** — the 3%-of-sync target retired in three places and replaced by the 290 KiB
  ceiling block with its derivation and its procedure; a new standing block, *an instrument's corpus
  must not contain what the instrument rewrites*; `pin-manifest.json` added to the deselection list
  with its reason; and two qualifiers added to the slice-anchor rule.
- **`test_batch_bm.gd`** — two locator guards (+2 checks). **`test_run_harness.gd`** — one (+1).
- **`baselines.json`** — two rows move, each with its reason: `test_batch_bm` 1889 → 1891 and
  `harness_2` 165 → 166.
- **`pin-manifest.json`** — regenerated. **1313 pins, the same residency table, and the pin SET is
  identical ignoring the line-number provenance field** — 52 `g` values moved and nothing else, so
  the file is the same size to the byte.
- **`docs/changelog.html`**, **`docs/design-notes.md`** (two entries), **`docs/master.html`**'s stamp.
- **`scripts/` IS UNTOUCHED.** No game file changed at all.

---

## §7 — VERIFICATION

### THE DOCUMENTATION WAS WRITTEN BEFORE THE BATTERY

`CLAUDE.md`, `docs/changelog.html`, `docs/design-notes.md`, `docs/master.html`'s stamp,
`pin-manifest.json` and `baselines.json`'s two rows were all final before the certification run.
**`docs/state.md` and this report are read by nothing** — no `.gd` file opens either, and the seven
that name `docs/state.md` all name it in a **comment** — so both were written after, which is what
lets a batch certify the tree that ships.

### THE PREDICTION, WRITTEN BEFORE THE FIRST READING

**PREDICTION: EXACTLY TWO ROWS MOVE — `test_batch_bm` 1889 → 1891 and `harness_2` 165 → 166 — AND
`check_de` READS 337 / 0 / 0.**

Predicted from what each target **READS**:

- **The three `.gd` edits add exactly one assertion each**, in two files, and change no other
  condition. Each was read standalone **three times**: bm 1891 / 0, gate 2 PASS (166), 22 / 166 / 8.
- **`check_de` gains nothing** — no target arrived and none left, so its own count cannot move. This
  is the one place ED's prediction had a term that EE's does not: ED added a gate.
- **Every document edit is prose in a block no pin lands in.** All 70 `CLAUDE.md` pins were mapped
  to line numbers **before** the first edit; the nearest to the three edited blocks is
  `DO NOT ADD A BATCH BLOCK TO THIS FILE` at line 26, which four suites read and which is untouched.
- **The literal-flip sweep**, taken against `git show HEAD` rather than a snapshot, over **all eight**
  edited files at a floor of 4 characters — **0 LOST everywhere**, 14 gained, and **0 of the 14 is
  negatively pinned against the file it landed in**, cross-checked against all 347 negative pins.
- **`pin-manifest.json`'s pin SET is byte-identical** ignoring the line-number provenance field, so
  `check_ed` asks exactly the questions it asked at HEAD.
- **The fourteen stamp gates** compare `>=` their own batch code, every one `CE` or older, and
  `EE >= CE` holds lexically. **`check_dv` §4's changelog span is a FLOOR of 16**; the live file
  goes to 25 entries.
- **Eight document and fingerprint gates were read standalone against the edited tree** and every
  one matched its baseline at zero failures: `check_da` 39, `check_dw` 35, `check_ea` 60,
  `check_ec` 22, `check_ed` 18, `check_dv` 83, `check_dj` 43, `check_eb` 12.

### THE NEGATIVE CONTROLS — AND THREE OF THE FOUR ARE TWO-ARMED

**Each armed on something the target demonstrably reads, with the disarmed state confirmed GREEN
first**, and every file restored by `cp` from a scratchpad backup with the md5 compared.

| # | armed on | EE's tree | **HEAD's tree, same injection** |
|---|---|---|---|
| **A** | the literal sweep's own population: `DO NOT ADD A BATCH BLOCK TO THIS FILE` reworded in `CLAUDE.md` | **LOST 1**, naming the needle | — |
| **B** | `battle.gd`'s comment `# The end boss.` reworded | **RED**: `test_batch_bm` 1891 / **1** and harness gate 2 **FAIL**, both naming the anchor; `check_ed` 18 / **1**, *"MOVED"* with both suites | **GREEN**: bm **1889 / 0**, gate 2 **PASS (165)** |
| **C** | one extra space inside `battle.gd`'s victory-branch anchor — a no-op in GDScript | **RED**: bm 1891 / **1**, naming NEGATIVE 4's guard | **GREEN**: bm **1889 / 0** |
| **D** | `CLAUDE.md`'s batch-block rule, against a suite that reads it | `test_batch_bb` **177 / 1**, naming §7 | — |

**B AND C ARE THE ONES THAT MATTER, AND THE SECOND ARM IS WHY.** The same injection against HEAD's
copies of the two suites leaves them **green at their old counts** — so the hole was real, it was
silent, and the repair is what closes it. **A control armed only on the new code proves the new code
works and says nothing about whether it was needed.**

Restored and re-verified: `scripts/battle.gd` back to md5 `2eb5db71a9855b24c6b9a71f2044a4b7`,
`test_batch_bm.gd` to `f36ecb487f3f1aa118e31410f9cfd559`, `test_run_harness.gd` to
`939dc8e134646e415cbf10dc7f5a8554`, `CLAUDE.md` to `7215ff8bc0113dd772cb6bbedafe4d83`, and the
disarmed tree green again on every one.

### THE ACCEPTANCE RUN

**One battery, and it found nothing.** No suite failure, no throw, no notice, no timeout, and the
only red is the one that is on purpose.

| | EC's acceptance | ED's acceptance | **EE's acceptance** |
|---|---|---|---|
| **suite failures** | 0 | 0 | **0** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 333 / 0 / 0 | 337 / 0 / 0 | **337 / 0 / 0** |
| targets in the manifest | 81 | 82 | **82** |

**EIGHTY-TWO TARGETS RAN AND THE MANIFEST NAMES ALL EIGHTY-TWO**, compared both ways: no log on disk
the manifest does not name, and none named that is not on disk. **0 `Parse Error` and 0
`SCRIPT ERROR` in every one of the 82 logs**, grepped from the streams rather than read off a tally
or an exit code. `check_map_screen: OK`; `check_ct_map` 83 / 0; the run harness reads
**22 / 166 / 8**, all three PASS with no throws. **40,671 checks** across the suite and gate lines,
plus 196 from the harness and 83 from `check_ct_map`.

**AND THE PREDICTION HELD EXACTLY.** `check_de` reported **337 checks, 0 failures and ZERO
NOTICES**, with **81 of 81 recorded targets swept and 0 off their recorded line**. `test_batch_bm`
read **1891** and harness gate 2 read **166** — the two predicted movements, each landing on the
number written before the run. **No other row moved.**

### THE TREE WAS FROZEN AND IT IS PROVEN, NOT CLAIMED

**249 files were MD5-stamped before the acceptance run and re-compared after: EVERY ONE IS
BYTE-IDENTICAL.** `CLAUDE.md`, `pin-manifest.json`, `baselines.json`, `run_battery.sh` and every
`.gd` file are unchanged across the run, **so the battery certified what ships.**

**EXACTLY TWO FILES DIFFER FROM THE CERTIFIED TREE NOW, AND BOTH ARE READ BY NOTHING**:
`docs/state.md`, and this report. No `.gd` file opens either, and the seven that name
`docs/state.md` all name it in a comment.

### THE FIGURES, MEASURED ON THE CERTIFIED TREE

Stated against the frozen tree rather than the committed one, because **`docs/state.md` and this
report are inside the number** — which is §2's shape one last time.

| | value |
|---|---|
| the sync | **168 files, 7.6174 MiB** |
| `CLAUDE.md` | **243,205 B = 237.50 KiB** |
| headroom to the 290 KiB ceiling | **52.50 KiB** — about thirteen batches at the measured rate, ten at the post-prune rate |
| `pin-manifest.json` | 303,110 B = **296.01 KiB**, fifth-largest of the 168 |
| the sync after the deselection | **167 files, 7.3284 MiB** |
| `CLAUDE.md` after the deselection | **237.50 KiB — unchanged, which is the point** |

**AND THE LAST READING IS THE SHARPEST ARGUMENT IN THE BATCH.** The retired ratio reads **3.045% at
EE — back over target one batch after ED cleared it** — and **deselecting `pin-manifest.json` moves
it to 3.165%, the WRONG WAY, by 0.12 points, with `CLAUDE.md` untouched.** The act §3 asks for
would have *breached* the target §1 retires. **A target that rewards keeping a derived artefact in
the sync was never measuring density.**

### AND THE TWO POST-RUN FILES WERE PROVED HARMLESS RATHER THAN ASSUMED TO BE

`docs/state.md` loses **11 literals** under the flip sweep, and every one of them is expected:
**no pin in the manifest has `docs/state.md` as a haystack, and no `.gd` file opens it.** All eight
mentions across eight files are comment lines — checked individually, not counted. **Enumerating the
assertions is the proof; the literal count is not.**

**AND A SUBSET RUN WAS TAKEN ANYWAY, AFTER BOTH FILES WERE WRITTEN** — every gate and suite that
reads a tracked document. **All twelve green at their exact battery counts, zero throws:**
`check_ea` 60, `check_ec` 22, `check_ed` 18, `check_da` 39, `check_dv` 83, `check_dj` 43,
`check_eb` 12, `check_dm` 93, `test_batch_bb` 177, `test_batch_bx` 157, `test_batch_ce` 1114,
`test_batch_bn` 81.
