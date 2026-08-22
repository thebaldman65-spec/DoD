# Batch DE — THE DIFFER BELONGS TO THE RUN, NOT TO A SUITE

*2026-08-22. Implement-only. No save version moves (still v10).*

**DD widened `test_batch_cd`'s table from five suites to forty-five and the battery went from
29.6 minutes to about fifty**, because §1 answered its question by spawning forty-five child
Godots — it ran the battery inside the battery. **That was a design error in DD's brief, not an
implementation one:** a suite that spawns suites squares the work when you widen it, so the
instrument got more expensive exactly as it got more useful, and the only lever left was to watch
less.

**Comparing this run's counts to recorded ones is a property of the RUN.** The differ is a
post-pass now — `check_de.gd`, over the logs `run_battery.sh` already writes — the baselines are
one machine-readable file, and **the nesting is structurally impossible rather than merely
avoided**, because reading a file is not running a suite.

---

## §0 — WHAT DOES `cd` DO THAT THE RUNNER CANNOT? FOR THE DIFFER, NOTHING

The brief asked the question and asked for the honest answer. **For the differ half the answer is
nothing, and it was nothing all along.**

`test_batch_cd` did two jobs. It **diffed check counts** against a recorded table, and it
**detected that another suite threw**, which it did by spawning child Godots with stderr captured,
because a script error is invisible to the suite it happens in. Set against `run_battery.sh`:

| what `cd` §1 did | what the runner already did |
|---|---|
| `OS.execute(exe, args, out, true)` per suite | `"$GODOT" --headless --path . … &`, per target |
| read stderr (`read_stderr = true`) | `>"$log" 2>&1` — both streams, into a file |
| `RegEx` for three count shapes | `grep -oE` for the same three shapes |
| `text.count("SCRIPT ERROR") + text.count("Parse Error")` | `grep -cE 'SCRIPT ERROR\|Parse Error'` |
| per-suite flags table (`SUITE_FLAGS`) | per-suite flags table (`EXTRA`) |
| **compared the result to a baseline** | **— nothing** |

**Every row but the last is a duplicate**, and `cd`'s own comments say so: its matcher is
described in-file as "this grep, transcribed", and its throw count as "the way `run_battery.sh`
counts them". **The redundancy was hard to see because the duplicate was in a different language**
— a `grep` in bash against a `RegEx` in GDScript, a `&` against an `OS.execute`. Nothing greps as
a duplicate. The long comment at the top of `cd` explaining *why a suite must run the suites to
see a throw* was correct in every clause and the conclusion did not follow, because the runner was
already doing the running.

**So the child spawning was redundant twice over, exactly as the brief suspected: the spawn AND
the stderr capture.**

### What must stay a suite, and why — this is not "nothing"

**The other three sections do not move.** They read the project's SOURCE and its DATA:

- **`_dead_calls`** sweeps every `test_*.gd` and `check_*.gd` for three dead symbols, with a
  comment/string stripper and its own positive controls, and pins the deletions at the source
  (`run_state.gd`).
- **`_target`** asserts the draft target is stated correctly in `master.html`, `classes.gd` and
  `CLAUDE.md`'s standing reference, and that no suite carries the stale denominator.
- **`_pools`** measures all twelve spec pools and the four class pools through `Classes`.

**A shell runner has no `Classes` and no opinion about prose.** These are assertions about the
tree, they need a Godot process and the project's own types, and they belong in a suite. **`cd` is
not deleted; it returns to being the hygiene suite it was before DD widened it**, at 507 lines
down to 306.

**The one thing that did NOT survive the question:** `cd`'s table could never hold
`test_batch_cd.gd` itself — a suite that drives itself does not terminate, and the file names that
hazard in a comment. **A post-pass has no such hazard, so `test_batch_cd` is watched now**, and so
are the fourteen gates, the three harness gates and the two scene runs — **nineteen targets that
were outside the old table entirely.**

---

## §1 — THE BASELINES ARE DATA, IN ONE FILE, AND A BAND CARRIES ITS OWN EVIDENCE

`baselines.json`, at the repo ROOT beside `run_battery.sh` and the gates — **test-harness data
lives with the test harness**, the same reason `gate_fixture.gd` and `suite_fixture.gd` are not in
`scripts/`. It is not under `data/`, which is game content.

**One place, and nothing duplicates it.** `docs/state.md` and `CLAUDE.md` now POINT at it instead
of restating the table, because **a second copy of a number is this project's oldest recurring
defect** and the instrument built to catch drift must not be the thing that seeds it.

Per target:

| field | what it holds |
|---|---|
| `kind` | `suite` / `gate` / `scene` / `harness` — chooses how the log is parsed |
| `checks` | `[lo, hi]`, or **`null` when the target reports no readable count** |
| `fails` | `[lo, hi]`, or `null` — **§3, and the half that matters most** |
| `checks_obs` / `fails_obs` | **how many readings the row rests on** |
| `expect` | a verdict substring, for a target that reports no counts at all |
| `flake` | a KNOWN flake and its observed rate |
| `note` | why this row is what it is |

**`checks_obs` is the field worth arguing for.** `an`'s nine-observation band was exceeded on its
TENTH reading, inside the batch that widened it. **A band is a claim about a distribution nobody
has characterised, and the number of readings behind it is part of the claim** — a row written
from four readings and a row written from twelve are not the same assertion, and until now nothing
recorded which was which. The counting rule is stated in the file itself so the number is
auditable rather than magic, and **it is counted LOW where there is any doubt**: an under-stated
observation count says "this rests on less evidence than you might think", which is the safe
direction.

**`null` IS A RECORDED STATE, NOT AN OMISSION.** **Eight targets cannot report a check count**
(`check_parse`, `check_flow`, `check_map`, `check_cl_resolver`, `check_cl_width`, `check_cm`,
`check_cn` and `check_map_screen`) **and two cannot report a failure count** (`check_cl_width`,
`check_map_screen`) — for those two the battery cannot see whether they passed at all. That set is now a **ratchet in both directions**: a target that
LOSES its count is an error, and one that GAINS a count is a notice telling the next batch to
record the number. Previously this was a sentence in `state.md` that nothing enforced.

---

## §2 — THE DIFFER IS A POST-PASS, RUN ONCE, AND IT SPAWNS NOTHING

`check_de.gd`. It runs last of all, reads `$OUT/*.log` and `baselines.json`, and reports.

**Written in GDScript, not in shell**, for the reason the project keeps re-learning: bash string
handling is how the battery's count grep came to be too narrow three times, and a message spelling
a throw marker out in full would make the battery accuse the differ of throwing. **The count-differ
has been mis-instrumented twice; it is not a place to be clever.** So the markers are joined at
runtime and **the parser carries positive controls for all three log shapes, including `bm`'s scar
as a regression case** — written `[ \t]+` instead of a single space, the matcher reads
`sections: 8   checks: 1891   failures: 0` as *8 checks and 1891 failures*.

### A fall and a rise are not the same event, and the polarity inverts

| what moved | direction | verdict | why |
|---|---|---|---|
| check count | **FALL** | **ERROR** | the signature failure — `bb` 172→168, `bo` 505→495, gate 2 at CA, seven `SCRIPT ERROR`s hiding 2,714 assertions |
| check count | RISE | notice | usually a suite's own loop walking new content — `bx` gained five at CX |
| failure count | **RISE** | **ERROR** | the 48th failure among 47 (§3) |
| failure count | FALL | notice | something was repaired; the row must move in the batch that repaired it |

So **the FLOOR of a band is asserted and the ceiling is not** — and that turned out to be **the
same asymmetry `an`'s band rule already had written into it**: floor = the lowest observation,
ceiling = the highest plus the observed spread, because "the floor is the half that catches a real
fault". **A convention for how to WRITE a band and a rule for how to READ one are the same rule**,
and it had been sitting in a comment being applied by hand.

**The asymmetry is driven through the real functions by six probes** that roll the counters back
afterwards, so the batch's central claim cannot pass by accident and the controls cannot pad the
tally they exist to make trustworthy.

### The hazard the new shape introduces, named and closed

**Reading logs instead of spawning means a target that failed to launch would be blessed by its
PREVIOUS run's log** — `run_battery.sh` does not clear `$OUT`. That is the one fault a count-differ
must never commit, and it is new, so it is closed rather than noted:

- the runner writes a **manifest** (`$OUT/.ran`), appending each target's name **immediately
  before launching it**;
- `run_one` truncates the log at spawn (`>"$log"`), so **a log named in the manifest is always
  this run's**;
- the differ trusts the manifest and **not the directory listing**;
- a target in the manifest with no row is reported **UNWATCHED** (DD's fault, made structural);
- a row not in the manifest is reported **DID NOT RUN** — so **a subset invocation
  (`./run_battery.sh bo bp`) says so instead of reporting a clean tree.**

### And it is re-runnable in seconds

Re-checking the old differ's answer cost 22 minutes, because it re-ran the tree. Over a log
directory that already exists the answer is instant, and **it cannot drift, because the evidence is
fixed.** That is not a side benefit: it is what makes a baseline table safe to correct.

---

## §3 — THE FAILURE BASELINES, WHICH ARE THE REAL PRIZE

**With 47 known failures across 20 suites, a 48th is invisible.** Not hypothetical: DC found
`test_batch_bi` was right and the game was wrong **for four batches**, and it hid because that
suite was already red for an unrelated reason. **A red check does not announce a second problem
underneath it.**

Every target carries an expected failure count now, so **a suite going from 6 red to 7 is reported
exactly as loudly as one going from 0 to 1.** This is the fix for the exact failure mode that let a
lying passive survive four batches, and **it is worth more than the check-count diffing that
prompted the batch** — it cost three fields in a JSON file and one comparison.

---

## §4 — THE MARGIN CAVEAT, AND A CORRECTION TO THE BRIEF

**The brief says `CLAUDE.md` "recommends asserting ratios with margins" and that the
recommendation "must not stand unqualified". It does not stand unqualified — DD already qualified
it**, at `CLAUDE.md`'s flaky-assertion block, with `at`'s arithmetic spelled out: a blow rolls
`randf_range(0.9, 1.1)`, one blow carries ±10%, a ratio of two carries up to 22%, against bands of
±20% and ±7%. There is also no separate site recommending ratios-with-margins; that block is the
only place in the file that discusses them.

**What was genuinely missing is the half that generalises**, so that is what was added: the
instruction to do the arithmetic **BEFORE** choosing the band rather than after the flake, and the
consequence when it does not fit.

> **A margin only works if it is WIDER than the noise it sits on, and a ratio of two rolled
> quantities carries roughly twice the variance of either. Compute the propagated noise first. If
> it is wider than the band the question needs, THE BAND IS NOT AVAILABLE** — seed the pair and
> assert exactly.

DD's text was a narrative about `at`; this is a method, and it is stated as standing.

---

## §5 — WHAT THIS DELIBERATELY DID NOT DO

- **The 47 failing assertions are not repaired.** Each needs a ruling on what it should ask
  INSTEAD. Left red on purpose — **§3 makes them safer to leave than they have ever been.**
- **`bo`'s flake is not repaired**, and neither is the stale assertion §6 found underneath it. One
  flake at a time is how the effect stays attributable; its failure count is a band (**1–2**) for
  that reason.
- **`_run`'s save-backup preamble is still owed** — 38 of 39 suites open with it, 37 swapping
  `Profile.save_path`. **It was already recorded as owed** in `CLAUDE.md` and `state.md` at DD;
  DE carries it unchanged and takes nothing.

---

## §6 — AND §3 CAUGHT ONE ON ITS FIRST RUN: `bo`'s RED IS NOT ITS FLAKE

**Every document in the project records `test_batch_bo` as `1025 /0–1 (the known flake)`. It is
not.**

`bo`'s floor of **1 is deterministic**. The failing check is §6's:

```
FAIL: §6: ...and the spec pools' depth named as the debt that remains
```

which asserts `CLAUDE.md` contains the literal `TRANCHES 2 AND 3`. **CW's split removed that
string** — verified absent from `CLAUDE.md` at DD's own commit `66b1ea0`, not assumed. So `bo`
belongs to **CW's family** alongside `bb`, `bn`, `bq`, `br`, `bx` and `ce`, and **the NULL FIELD
flake is a SECOND failure on top of it, which would read 2.**

### Why nothing caught it

**The band `0–1` admitted the observed value, so nothing ever contradicted the label.** DD read
`bo` at 1 and recorded 0, reasoning that "`bo`'s flake simply did not appear in this run" — and the
arithmetic worked either way, because **the total is the same whether the 1 is a flake or a stale
assertion.** Nobody looked at *which* check was red, because a suite already excused by a known
cause does not invite the question.

**That is §3's thesis exactly** — *a red check does not announce a second problem underneath it* —
and it was found by §3's own instrument on its first run, in the batch that built it.

### What it changes

- **The project's standing failure total was under-stated by one suite and one failure. It is 47
  across 20**, measured twice at DE (once on unmodified HEAD), **and 48 on a run where the flake
  fires.**
- **`baselines.json` carries `bo` at `[1, 2]`**, with `fails_obs: 2` — **the floor observed twice,
  the ceiling named as the recorded flake's contribution rather than guessed at.** Recording a
  ceiling nobody has observed is exactly the thing `checks_obs` exists to make visible, so it is
  said out loud in the row's note instead of hidden in the number.
- **The standing rule, now in `CLAUDE.md`: when a suite is excused by a known cause, check that
  the red in front of you IS that cause.**

**This does not fix `bo`.** Both of its reds stay — the stale assertion needs the same ruling as
the other 46, and the flake is deliberately left for its own batch.

---

## §7 — AND IT CAUGHT A SECOND ONE, ON THE ACCEPTANCE RUN ITSELF

**The final battery — the acceptance run for this batch — came back with `check_de: 273 checks /
1 failure`, and the failure was real:**

```
FAIL: test_rune_battle went REDDER: 1 failures, recorded 0 — a red suite going
      redder is exactly the movement an aggregate hides (BATCH DE §3)
```

**`test_rune_battle` had been 97 / 0 in every recorded run of the project.** It reads none of the
documents this batch edited — checked, not assumed — and its **check count is rock steady at 97
across every reading**, so only the failure moved. That is the flake signature `CLAUDE.md` names.

The check is the pyromancer's `rune_resist_pierce`: it drives a **live battle** against a
fire-resistant warband and requires the proc to actually land, looking for `Rune: the flame bites
through resistance` in a snapshot or the log. **The suite calls `seed()` zero times.**

### Measured, not assumed

| reading | result |
|---|---|
| DE before-battery (unmodified HEAD) | clean |
| DE after-battery | clean |
| **DE acceptance battery** | **RED** |
| **next ad-hoc run** | **RED** |
| 11 further ad-hoc runs, idle machine | clean |

**2 red in 15 readings — roughly 1 in 7.** And **both reds landed under machine load**: one during
a full battery, one on the run immediately after it, against **ten consecutive clean runs on an
idle machine.**

**THAT THE LOAD MATTERS IS A HYPOTHESIS AND NOT A FINDING.** Two observations do not make a
mechanism. It is worth stating because the assertion's own comment says its snapshot *"is the one
that cannot race"* — **so a race is the first thing the next batch should look at**, and a flake
that clusters under load is a different repair from one that is purely a bad draw.

### It is recorded, not repaired

Band `0–1`, `fails_obs: 15`, the rate and the load observation in `baselines.json`. The repair is
the `at`/`bo` shape — seed the draw, or assert on the snapshot alone — and **it is deliberately
left for its own batch. One flake at a time is how the effect stays attributable.**

**The point is not the flake. It is that an instrument built this batch found, on its first
acceptance run, a red that every previous battery had either not produced or not noticed** — and
that it did so by comparing a FAILURE count, which is the half of §3 the brief called the real
prize.

---

## §8 — VERIFICATION

### Three full batteries, and the first reproduces DD exactly

**A before-battery was run on unmodified HEAD before anything was touched**, so the runs compare
like with like on this machine rather than only against a document. A third — the acceptance run —
was paid for deliberately, because the `bo` correction needed a late `CLAUDE.md` edit and **a run
that did not supervise the final tree cannot certify it.** That is this batch's own principle
applied to itself.

**THE BEFORE-BATTERY REPRODUCED DD'S TABLE EXACTLY, AND NOT BY EYE:** the baseline builder parsed
DD's own `BASELINE` table out of the pre-patch `test_batch_cd.gd` and diffed it against every count
the run produced. **Zero disagreements across 45 suites, on both halves of every row.** After the
`bo` correction there is exactly **one** deliberate disagreement, and it is §6's.

### Wall clock — the point of the batch

| | wall clock | what changed |
|---|---|---|
| before DD | 29.6 min | the differ watched five suites |
| **before DE — measured, unmodified HEAD** | **2,996 s — 49.9 min** | `test_batch_cd` §1 spawning 45 child Godots |
| **after DE — measured** | **1,738 s — 29.0 min** | the differ is a post-pass |
| **acceptance DE — measured** | **1,750 s — 29.2 min** | the final tree, docs included |

**It is BELOW the 29.6 minutes it started at, and that is with `test_batch_cp`'s 697 checks added
to the run.** The 22-minute nested sweep is gone; what replaced it costs **0.63 seconds**.

### Every count, target by target — not in aggregate

**Across 46 suites, 14 gates, 3 harness gates and 2 scene runs, exactly FIVE lines differ between
the two batteries, and all five are accounted for:**

| line | before | after | why |
|---|---|---|---|
| `an` | 6051 | **6050** | inside its band, 0 failures — the known drifter, and 6050 is a value not previously observed |
| `bk` | 129 | **130** | both ends of its recorded band again, in one batch, 0 failures |
| `test_batch_cd` | 207 / 0 | **71 / 0** | **deliberate** — the differ moved out, 136 checks with it |
| `test_batch_cp` | *(not run)* | **697 / 0** | **deliberate** — it is in `SUITES` now, and it agrees with DD's private sweep |
| `check_de` | *(did not exist)* | **273 / 0 / 0** | **deliberate** — the post-pass |

**Everything else is byte-identical** — 43 of the 45 shared suite lines, **all 14 gate lines**,
`check_cm_live`'s four deliberate reds, the harness at 22 / 165 / 8, `check_ct_map` at 83 / 0,
`check_map_screen` at its `OK`, and **`throws=0` everywhere in both runs**, grepped from the stream
and never read off a tally or an exit code.

### The differ's own verdict

```
check_de: 273 checks / 0 failures / 0 notices
  65 of 65 recorded targets swept, 0 off their recorded line
  8 recorded with no readable check count; 0 lost, 0 gained
  2 recorded with no readable failure count; 0 lost, 0 gained
```

**Zero unwatched targets and zero un-run rows** — the table and the run describe the same tree.
On the **acceptance** battery it reported `273 / 1 / 0`, and that one failure is §7's — a real red
the instrument was built to catch. With `test_rune_battle`'s band recorded, the same logs re-read
**273 / 0 / 0**.

**AND THE ACCEPTANCE RUN PROVED THE DOC EDITS MOVED NOTHING.** Between the after-battery and the
acceptance battery the only changes were to `CLAUDE.md`, `changelog.html` and `design-notes.md`.
Four lines differ between those two runs: `an` (6050 → 6055, in band), `bk` (130 → 129, in band),
`test_rune_battle`'s flake, and `check_de` reporting it. **Not one line moved because of a
document.**

### A question DD left open, answered on the way past

DD recorded that its batteries read `an` at 6053 while `test_batch_cd`'s `OS.execute` sweeps read
6055, and that whether the gap was draft randomness or a launcher difference *"is not
distinguishable on four readings"*. **DE's three batteries all use the SHELL launcher and read
6051, 6050 and 6055.** The shell launcher produced 6055 by itself, so **the gap is draft randomness
and the launcher hypothesis is dead.** 6050 is a new low, inside the 6047 floor. There is only one
launcher now in any case — but the question is answered rather than merely retired.

### The instrument was proved to bite before it was trusted

- **`check_de`'s six probes** drive a fall, a rise, an unreadable count, a redder suite, a greener
  suite and an on-the-line target **through the real comparison functions**, and assert which go
  red. They roll the counters back afterwards, so a control cannot pad the tally.
- **Its parser controls** pin all three log shapes plus `bm`'s `[ \t]+` scar as a regression case.
- **Both new files were parse-checked with a NEGATIVE CONTROL** proving the check bites: a
  deliberately broken script produced 4 markers, `check_de.gd` and `test_batch_cd.gd` produced 0.
  **Parse state was read off stderr, never off a tally and never off the exit code** — a `--script`
  target whose base class does not resolve prints a parse error, runs not one line and exits 0.
- **The differ was run against the BEFORE-battery's logs before the after-battery existed**, and it
  correctly reported `test_batch_cd`'s 207 as a *rise* against its new row of 71 (a notice, not an
  error) and `test_batch_cp` as **DID NOT RUN** — which it genuinely had not. **Both ratchets were
  observed firing on real data, not only in probes.**

---

## §9 — DOCUMENTATION AND THE PUSH CHECK

`docs/changelog.html` (the DE entry), `CLAUDE.md` (one new standing block, four amended),
**`docs/state.md` rewritten** — pointing at `baselines.json` rather than restating it, and its
per-suite count listing **deleted** rather than updated — `docs/reports/DE.md`,
`docs/design-notes.md`, and the `master.html` stamp at `Last updated: 2026-08-22 (Batch DE)`.

**THE DOCUMENTATION WAS WRITTEN BEFORE THE VERIFICATION RUN**, because 35 suites read `CLAUDE.md`,
21 read `docs/master.html`, 14 read `docs/changelog.html` and 3 read `docs/design-notes.md`. Only
`docs/state.md` and this report were written afterwards — **nothing asserts on either**, verified
by grep before relying on it. The `bo` correction required a late `CLAUDE.md` and `changelog.html`
edit; it was made **additive-only** (no asserted string removed), every absence-assertion against
`CLAUDE.md` was checked first, and the doc-heaviest suites were re-run individually rather than
paying for a third battery.

**Nothing was owed at the start of the batch:** `git ls-remote origin main` matched local HEAD at
`66b1ea0` (Batch DD) before any work began.
