# BATCH DD — ONE `_spawn` FOR THE SUITES

*2026-08-21. The second half of DB's consolidation, ten times its size. One battery, one flake
seeded, one instrument widened from a ninth of the project to all of it. No save version moves
(still v10).*

---

## THE HEADLINE

| | |
|---|---|
| **`_spawn` is authored once for the suites.** `suite_fixture.gd` holds the party, the encounter, the env, the frame wait and the determinism forcing; **all 37 suites go through it and none authors its own.** `_kill` with it, in 14. | **1,128 lines deleted, 391 added across the 37 suites** (1,169 / 655 across every `.gd` file the batch touched), and **not one of the 389 call sites moved** — every suite keeps its OWN `_spawn` signature and delegates. |
| **NO EXEMPTION WAS NEEDED.** Every one of the **22** differences between the 37 copies is a named argument now. | **Two that look like copy slips are deliberate and are PRESERVED, not merged** — `bq`/`br` arm `no_cover` on the heroes only, because Mirror Image *is* a miss. |
| **The count-differ was watching a ninth of the project.** `test_batch_cd`'s table held **five** suites of forty-five. | It holds **forty-five rows** now — and they are **not the battery's forty-five**. |
| **`test_batch_at` was never one flaky check.** It was two, and the second had never been recorded. | **Seeded and pinned: 470 / 3 over five consecutive runs.** §2's question is answered — **it settles at 3, so the fourth failure was a flake and not a finding.** |

**BEHAVIOUR DID NOT CHANGE, AND THE PROOF IS THE COUNTS.** Every suite is compared against DC's
table line by line rather than against the failure total — because **21 suites were already red when
this batch started**, and a movement inside one of them does not show up in an aggregate.

---

## §0 — THE CENSUS, DERIVED RATHER THAN RECALLED, AND IT IS NOT 34

**Every document in the project — `CLAUDE.md`, `docs/state.md`, DB's report and this batch's own
brief — says `_spawn` stood in "37 suites as 34 distinct bodies". The number does not reproduce
either way it can be measured.**

| measurement | result |
|---|---|
| the 37 bodies hashed verbatim | **36** — only `bh`/`bi` are literally identical |
| hashed with comments and blank lines stripped | **33** — four pairs are twins: `bh`/`bi`, `bo`/`bp`, `bq`/`br`, `bt`/`cb` |
| what every document says | **34** |

**`_kill`'s "byte-identical in 14" has the same shape.** There are **four** raw bodies and **one**
normalised body: every difference between the fourteen was the wording of the comment above
`await`, which said the same thing four ways. It was still the right one to do first — there is no
ruling in it — and it went in and was verified on three suites (`av` 324/1, `bc` 91/0, `bd` 71/1,
all identical, zero throw markers) before the 37 were touched.

**`_run` IS 39 BODIES IN 39 SUITES AND IS CORRECTLY UNTOUCHED.** It is not a copied helper; it is
each suite's own driver, naming its own sections and printing its own summary line. **But a copied
helper is hiding inside it: 38 of the 39 open with the same save-backup preamble, and 37 swap
`Profile.save_path` to a per-suite file and swap it back.** That is the next duplication of this
shape, and it is recorded as owed rather than taken here.

---

## §1 — WHAT THE THIRTY-SEVEN BODIES ACTUALLY DIFFERED BY

DB's four gate bodies diverged on five axes. **Thirty-seven suite bodies diverge on twenty-two**,
and each is a key in an options dictionary at the call site instead of an invisible edit inside a
copy:

| axis | what it is | who wanted it |
|---|---|---|
| `difficulty` | `"standard"` or `"wanderer"` | 5 suites take `wanderer` (`bn`–`br`) |
| `enemies`, `node_type` | the lineup and the encounter type | every suite; several drive elites |
| `talents`, `talents_by_spec` | which member wears which loadout | keyed by index, or by spec (`bo`–`br`) |
| `bm`, `bm_by_spec`, `bm_all` | granted abilities | `al`, `bd`, `bo`–`br` |
| `runes` | equipped runes | `al` alone |
| `patch` | arbitrary member keys, written AFTER `sync_spec_hp` | `au` (member 1), `av`/`aw`/`ax` (member 2) |
| `prep` | a `Callable(run)` before the encounter is set | `ah_battle`, `ak` |
| `slot_idx`, `modifier` | `new_run` leaves `slot_idx` at **-1**; eight copies set 0 | `bb`–`bi`; only `bb` passes a live modifier |
| `autoplay` | AUTOPLAY=1 **and no ENEMIES_OFF write at all** | `ah_battle`, `bl` |
| `frames`, `fast` | 12 / 20 / 90 frames, the 90s at `time_scale = 50` | `bu`–`bx`, `ce`, `cp` run fast; `bl` passes its own |
| `deterministic`, `enemies_keep_cover` | the AK/AL/AR forcing, and who gets `no_cover` | 32 force; **`bq`/`br` arm the heroes only** |
| `crit`, `heal_mult` | `crit_bonus` at **-10.0** or **-1.0**; `healing_received_mult` pinned to 1.0 | 15 / 9 / 7 suites |
| `sim`, `slices` | `scene.sim`, `sim_stats`, `_b_slice`, `_b_bd_slice` | `bc`–`bi` |

### Four differences were measured to be no-ops — measured, not ruled

- **`run.combat_wins = 0`** — `new_run` sets it to 0 five lines earlier.
- **`party[i]["runes"] = []`** and **`party[i]["talents"] = {}`** — `new_run` seeds every member
  with exactly those two.
- **`_run_obj()` vs `root.get_node("/root/Run")`** — `bh` and `bi` call a one-line helper that
  returns exactly the thing the other thirty-five write out.

**And one ORDERING difference went the same way.** `al` wrote its member-0 talents, grants and
runes AFTER the loop rather than inside it. `sync_spec_hp` reads `spec`, `max_hp` and `hp` and
nothing else, so the two orders cannot differ — **checked in `run_state.gd`, not assumed**. The
`patch` option is the one that genuinely must stay after the loop, and it does.

**`String(specs[i])` is now universal.** `bb` and `bc` cast; the other thirty-five did not. For a
`String` input the two are the same value, so the cast is the safe superset.

### And the two that look like slips are deliberate, so they are preserved

**`bq` and `br` arm `no_cover` on the HEROES only**, where the other thirty-two arm it on both
sides. Both suites say why in their own comments, and it is not a slip: **`no_cover` is an absolute
miss BYPASS and Mirror Image IS a miss**, so arming it on the enemy side makes every image look
broken; the enemy side gets it back per unit at the checks that need a blow to land. **Merging to
the majority would have changed what two suites measure.** `bs` carries the same lesson through the
other door for Heat Haze, and reads `_miss_chance` directly instead.

The same reasoning kept `crit` an argument: **two live values, -10.0 and -1.0**, and which one a
suite wants is a measurement decision, not a merge preference.

### Why each suite keeps its own `_spawn`

Two reasons, and neither is taste. **`extends SuiteBase` does not compile and fails by exiting 0** —
DB's trap, already paid for. And **thirty-seven signatures are not one signature**: they take
`learned`, `granted`, `member_patch`, `prep`, `learner`, `mod_id`, `cleric_spec`, `earned`, `runes`
and `frames` between them, across **389 call sites**. A thin delegating `_spawn` per suite is what
kept all 389 still.

**The fixture validates its own option keys** and shouts on an unknown one, because an ignored typo
in an options dictionary is a suite quietly measuring a different board — the same class of fault as
a gate that exits 0.

---

## §2 — `test_batch_cd` WAS WATCHING A NINTH OF THE PROJECT

**`cd` is the only thing in the repo that compares a check count to what it should be**, and from CD
until DD its table held **five suites**. Nothing about that was hidden — the five were written out
in a const with a comment explaining the floor. What nobody did was ask what the five were a sample
of.

**The cost came due at DC**: five suites repaired, twenty-three assertions repointed, and `cd` did
not move by one line, **because none of the five Faith suites was in the table**. The sentence that
produced — *the count-differ is unchanged* — reads exactly like the sentence a differ over the whole
tree would have produced.

### What it holds now, and why it is not "all 45"

**The battery's 45, minus this file, plus `test_batch_cp` = 45 rows.** A suite that drives itself
does not terminate, so `cd` cannot watch `cd`; and the battery's own `SUITES` array misses
`test_batch_cp`, which therefore ran nowhere at all. **Saying "all 45" without saying WHICH 45 is
how a gap survives a headline.**

**`test_batch_cp` is measured here for the first time: 697 checks / 0 failures** — and identical
before and after the consolidation, which is the only verification that file has ever had.

### A row is `[checks_lo, checks_hi, fails_lo, fails_hi]`

- **Both halves are bands** because three suites legitimately move: `an` checks, `bk` **129–130**
  (five observations), and `bo` **0–1** failures. **`bk` read 130 in DD's before-battery and 129 in
  its after-battery**, so both ends of that band were observed inside one batch. **`an`'s band was
  written from nine observations as 6047–6054 and the first correct sweep exceeded it — see §6.**
- **Everything else is EXACT on both halves.** A floor cannot see a count that RISES, and `bx`
  gained five checks at CX while `al` lost one at CV — both found batches later, by accident.
- **The failure half is the half a floor never had**, and it is the one §0 of the brief is about:
  **a failure count moving inside an already-red suite is invisible in an aggregate.**
- **`cd`'s old comment says `ah` drifts run to run.** Six observations say 5625 exactly, so it is
  recorded as a number. If it ever drifts, the differ says so and the row gets a band with a reason.

### Two faults the widening found in `cd` itself

- **Its check message spelled `SCRIPT ERROR` out in full.** The day any suite threw, `cd` would
  print those words into its own log — and `run_battery.sh`'s `throws=` column would have counted
  **`cd`** as the suite that threw. **The marks are joined at runtime now**, which is the discipline
  `check_da` already used for exactly this reason.
- **Its count grep matched `N checks` and nothing else**, so it **could not read the six rows that
  print `checks: N   failures: N` at all** — `bm`, `bn`, `bo`, `bp`, `bq`, `br`. It carries the
  battery's general matcher now, and the battery's per-suite FLAGS with it, because **`test_batch_bl`
  silently under-runs without `--fixed-fps 12`**.
- **AND THE FIX FOR A TOO-NARROW GREP WAS A TOO-GREEDY ONE — caught by the instrument on its own
  first run.** Transcribed with `[ \t]+` where the battery has a single space, the first alternative
  eats the wrong number out of the colon shape: `sections: 8   checks: 1891   failures: 0` matches
  *"8   checks"* and *"1891   failures"*, so **`bm` came back as 8 checks / 1891 failures** against a
  recorded 1891 / 0. Six suites read wrong, `cd` reported seven failures, and **the widened table
  found its own author's bug on the run it was introduced.** The single space is load-bearing and
  the reason is written beside the regex.
- **CS's scar is written in three places as "seven suites print the colon shape".** The seven is the
  set whose count read `?` (`ai`, `bm`, `bn`, `bo`, `bp`, `bq`, `br`); **only six of them print that
  shape**, and `ai` prints `N passed, N FAILED` — as does `an`. Corrected in `run_battery.sh` and
  `test_batch_cd.gd`. It
  carries the battery's general matcher now — and the battery's per-suite FLAGS with it, because
  **`test_batch_bl` silently under-runs without `--fixed-fps 12`**.

### The price, stated rather than buried

**It costs about 22 minutes and it runs the battery inside the battery.** The suite section is
22.2 minutes of a 29.6-minute battery, and `cd` now repeats nearly all of it, so **a full battery
goes from about 30 minutes to about 50**. `run_battery.sh` carries `TMO[test_batch_cd]=2400` for it,
because **at the 240s default the sweep would be killed before printing a row, and a killed suite
reports NO COUNT** — the one outcome a count-diffing rule cannot read.

**Whether that price belongs inside every battery is a decision and it is recorded as owed.** The
alternative shapes — running `cd` outside the battery, or having it read the battery's logs — were
both rejected here: the first hides it, and the second couples the differ to a run it did not
supervise. **A parallel sweep was rejected on measurement grounds**: several suites time real
`SceneTreeTimer` waits, and loading the machine with six concurrent Godots is exactly how a
count-differ acquires its own flakes.

---

## §3 — `test_batch_at` WAS NEVER ONE FLAKY CHECK

It read **3 failures or 4**, the fourth flaking in **2 runs of 5** — far worse than `bo`'s 1 in 13 —
with `seed()` called zero times and its check count rock steady at **470**.

**Seeding the recorded offender fixed it and immediately exposed a second nobody had recorded**:
`…by roughly the table's +59% (ratio 1.44)`, which sums ten blows a side and still carries more
noise than its band. **Both are the same shape**, and the arithmetic is the finding:

- The first line of the strike block is `randf_range(0.9, 1.1)`. **One blow carries ±10%; a RATIO of
  two carries up to 22%.**
- The Cannon band is **1.35–1.85** around a passive that pays **1.54** — **±20%**. The take-damage
  band is **1.48–1.70** around **1.59** — **±7%**.
- **THE NOISE WAS THE WIDTH OF THE QUESTION.**

**`CLAUDE.md` already said to assert a ratio with a margin. Both of these WERE ratios with margins.**
That rule is amended in place rather than copied: the margin is not a tolerance, it is the question.
The Cannon band exists to separate **1.54** (the passive alone) from **2.46** (the passive times the
ability term AU removed); open it far enough to swallow ±22% and it stops telling those two apart.
**A margin wide enough to absorb the noise is a margin wide enough to absorb the bug.**

**THE FIX IS TO REMOVE THE NOISE, NOT TO WIDEN THE BAND.** `seed()` the same value immediately
before **each blow of a compared pair**, so both draw the identical variance and the only thing left
between them is what is under test — the AV/BS/BT idiom, which the project already had. **Where the
check averages a LOOP of pairs the seed varies per iteration** (`seed(base + i)`), or the averaging
that makes its band meaningful collapses into the same measurement ten times.

**Result: 470 checks / 3 failures over five consecutive runs.** The check count is unchanged —
nothing was added and nothing was deleted — and **§2's question is answered: it settles at 3, so the
fourth failure was a flake and not a finding.** The three that remain are the stable `CLAUDE.md`
assertions CW's split made false; they need rulings and are DE's.

**`bo` is deliberately left alone.** Its repair is the same shape, and one flake at a time is how the
effect stays attributable.

---

## §4 — THE CENSUS IS AN ASSERTION, AND THE RESIDUE IS A RATCHET

**`check_da` §3 asserts the suites now, not only the gates.** A suite carrying a `_spawn` that does
not reach `suite_fixture.gd` fails by name. That is DB's rule applied to the other side, and it
exists because **a rule with no number under it rots into a sentence nobody re-checks**. The gate
reads **36 checks** where it read 33, and those three are the only deliberate movement in any gate
this batch. It prints its census beside them:

```
19 gates; 0 author their own `_spawn`, 0 instantiate the battle by hand
7 go through `gate_fixture.gd`: …
47 suites; 37 go through `suite_fixture.gd`, 0 author their own;
   10 hand-built boards remain in 6 files
```

**AND THE RESIDUE IS NAMED RATHER THAN LEFT TO A WILDCARD.** Ten hand-built battle boards remain, in
six files — `al` (2), `an`, `ax`, `bl`, `test_rune_battle` (3), `test_run_harness` (2). **None is a
copied helper**: they are bespoke boards inside single checks, and two of those files have no
`_spawn` at all. They are recorded by name AND by count, so a new copy cannot hide among them — the
assertion fails on a file that gains a site and on a file that is not on the list. **Proved by
negative control**: a probe line added to `test_batch_bc.gd` tripped it by name, and the file was
restored byte-identical afterwards.

---

## §5 — WHAT THIS BATCH DELIBERATELY DID NOT DO

- **It repaired none of the red assertions** — 49 across 21 suites when the batch started, 46
  across 19 after §2's accounting change. They need rulings on what they should ask instead and they
  are DE's. **They are left red and the total is reported unchanged** — minus only that accounting
  change.
- **No assertion was deleted to make a count agree.** Across 45 suites and 14 gates **exactly three
  lines differ from DC's table**, and each has a reason: `cd` 86 → 207 and `check_da` 33 → 36 are
  this batch's own deliberate additions, and `bk` 130 → 129 is inside its recorded band.
- **`bo` is not seeded.** §2's rule: one flake at a time.
- **`_run` is not consolidated**, and neither are the ten hand-built boards. Both are named above.

---

## §6 — THE BATTERY, RUN TWICE

**Once on unmodified HEAD before anything was touched, once after** — because §0's proof *is* the
counts, and a single run proves nothing about a change. `user://` was backed up first and **no run
was in flight** (`run_save.bin` does not exist).

### The before-battery reproduced DC's table exactly

**45 suites, zero throws, 49 failures across 21 suites**, `an` 6053 and `bk` 130 inside their bands,
every gate identical, harness 22 / 165 / 8. **So the two runs compare like with like on this
machine, not merely against a document** — which matters, because §0 of the brief is about a
movement being invisible when 19 suites are already red.

### Across 45 suites and 14 gates, exactly three lines differ

| line | before | after | why |
|---|---|---|---|
| `bk` | 130 | **129** | inside its recorded band (129–130), 0 failures. **Not a regression, and it is why that band exists.** |
| `test_batch_cd` | 86 / 2 | **207 / 0** | §2's widening: five rows to forty-five |
| `check_da` | 33 / 0 | **36 / 0** | §4's three suite-census assertions |

**Everything else is byte-identical**: 43 of 45 suite lines, 13 of 14 gate lines,
`check_cm_live`'s four deliberate reds, the run harness at **22 / 165 / 8**, `check_ct_map` at
**83 / 0**, and **`throws=0` everywhere in both runs** — grepped from the stream, never read off a
tally, and never off an exit code. **37 suites had their `_spawn` replaced and not one check count
moved.**

### The failure total: 47 across 20, down from 49 across 21, with nothing repaired

**The two that left are `cd`'s own** — they were `bb` and `bj` being reported red a second time, and
the widened table records their failure counts as baselines instead of re-reporting them.
**It is an accounting change and it is the only movement in the project's failure total.**

Measured with **`bo`'s flake PRESENT (1)**, the same condition DB's 72 and DC's 49 were measured
under; **on a run where `bo` does not flake the total reads 46 across 19**, and that is not a
repair either.

### And the widened table caught its own author's bug on the run it was introduced

`cd` reported **seven failures** on its first widened run: `bm` as *8 checks / 1891 failures*
against a recorded 1891 / 0, plus five more suites' failure counts. **Every one was the greedy-space
regex** — `[ \t]+` where `run_battery.sh` has a single space — eating the wrong number out of the
colon shape.

**A count-differ that could not find a fault in itself would not be worth 22 minutes.**

### And on the run after that, it found the brief's own instruction to be too tight

Fixed, re-derived against all six printed formats, and re-run: **45 suites swept, 1 off its recorded
line — `an` at 6055 checks against the 6047–6054 band, at 0 failures.**

**That band had just been written from nine observations, and it was exceeded inside the batch that
wrote it.** §1 of the brief asked for `an` and `bk` to be carried as bands *with the observation
count beside them*, because "a band written too tight is a false alarm generator" — and the
nine-observation band was one. **A band written to a sample's exact extremes is exceeded by roughly
two runs in eleven.**

**The rule the table carries now is asymmetric on purpose:**

- **floor = the lowest observation. It stays tight, because it is the half that catches a real
  fault** — a section of `an` that stopped running costs hundreds of checks, not five.
- **ceiling = the highest observation plus the observed spread.** `an` is **6047–6063** on ten
  readings (6055 + 8).
- **`bk` is NOT widened**, because it has not been exceeded. **Headroom goes where a reading demands
  it**, so every number in the table stays traceable to a run.

**THE FINAL SWEEP, RUN LAST OF ALL AGAINST THE COMPLETE TREE: `test_batch_cd` 207 checks / 0
failures — 45 suites swept, 0 off their recorded line, zero throw markers.** That is the batch's
acceptance test, and it covers the documentation edits as well, because **39 suites read `CLAUDE.md`,
`docs/master.html` or `docs/changelog.html`** and the sweep re-ran every one of them after the last
of those edits landed.

**One observation four readings cannot settle:** both batteries read `an` at **6053** and both of
`cd`'s sweeps read **6055**. `run_battery.sh` launches a suite from the shell; `cd` launches it with
`OS.execute` from inside a Godot process, which hands the child a different environment. **Whether
that two-check gap is draft randomness or a launcher difference is not distinguishable on four
readings**, and it is worth one deliberate experiment before anyone treats `an`'s spread as pure
noise.

### Verification of the batch's own edits, per surface

- **Every suite and the fixture parse-checked** with `--check-only`, **with a negative control**: a
  deliberate syntax error in `suite_fixture.gd` produced a `Parse Error` line, and the file was
  restored from the scratchpad and re-verified.
- **`_kill` was consolidated and verified FIRST**, on `av` (324 / 1), `bc` (91 / 0) and `bd`
  (71 / 1) — identical, zero throw markers — before the 37 `_spawn`s were touched.
- **Sixteen suites spanning every divergence class** were run individually after the `_spawn`
  consolidation and before the battery: `ah_battle`, `ak`, `al`, `av`, `ay`, `bb`, `bc`, `bd`, `bf`,
  `bi`, `bl`, `bp`, `bq`, `bx`, `cp` and `at`. All identical.
- **`test_batch_cp` was measured before AND after the consolidation** — **697 / 0 both times** —
  because the battery does not run it and nothing else would have caught a break.
- **`check_da`'s new ratchet was proved to bite**: a probe line added to `test_batch_bc.gd` tripped
  it by name, and `bc` was restored byte-identical afterwards.
- **`test_batch_at` was run five consecutive times after seeding**: 470 / 3 every time.

### The wall clock, stated because it is now the battery's dominant cost

| | before DD | after DD |
|---|---|---|
| suite section | 22.2 min | 22.2 min |
| whole battery | **29.6 min** | **~50 min** |

`test_batch_cd` alone accounts for the difference: **it runs the battery inside the battery.**
`run_battery.sh` carries `TMO[test_batch_cd]=2400`, because at the 240s default the sweep is killed
before it prints a row — **and a killed suite reports NO COUNT, which is the one outcome a
count-diffing rule cannot read.** **Whether that price belongs inside every battery is recorded as
owed.**
