# BATCH DB — ONE `_spawn` FOR THE GATES

*2026-08-21. One consolidation, one battery, and two rules into the traps. No save version moves
(still v10). **First of two: DC consolidates the suites, which is ten times larger.***

---

## THE HEADLINE

| | |
|---|---|
| **`_spawn` is authored once.** `gate_fixture.gd` holds the battle fixture and the tally; **all seven gates go through it and none authors its own.** | **345 lines deleted, 135 added.** `check_da` §3 no longer *counts* the copies — **it asserts there are none.** |
| **The battery ran for the first time since CS — five implement-only batches.** | **45 suites, 0 throws, and 72 FAILURES across 26 suites.** All pre-existing; none is DB's. |
| **The `Profile` flag divergence is ruled, not averaged.** The flags are dead under every gate and their only live effect was writing the player's profile. | **Gates no longer mutate `user://profile.json`** — measured by mtime, before and after. |
| **Four gates could never report a check count.** Their `ok()` never counted. | `check_cm_live`, `check_co`, `check_cy` and `check_cz` **read `checks=?` in every battery ever run.** They print counts now. |

**BEHAVIOUR DID NOT CHANGE, AND THE PROOF IS THE COUNTS: every gate's FAILURE count is identical
to its pre-batch baseline, and `check_cm_live`'s four known-reds are byte-identical.** The one
deliberate movement is `check_da` **30 → 32 checks**, which is §3's two new assertions.

---

## §0 — WHAT THE FOUR BODIES ACTUALLY DIFFERED BY

The census, taken by normalising every copy (comments and trailing whitespace stripped) and
hashing it. **Seven gates, four distinct bodies**, and the divergence is on **five axes**:

| gate | signature | party | `Profile` flags | determinism | pouch |
|---|---|---|---|---|---|
| `check_co` | `_spawn(specs: Array)` | caller's | **SET** | — | — |
| `check_cy` | `_spawn(specs: Array)` | caller's | **SET** | — | — |
| `check_cz` | `_spawn(specs: Array)` | caller's | **SET** | — | — |
| `check_da` | `_spawn(specs: Array)` | caller's | **SET** | — | — |
| `check_cm_live` | `_spawn()` | hard-coded, beastmaster | **absent** | **forced** | — |
| `check_cs` | `_spawn()` | hard-coded, sharpshooter | **absent** | **forced** | — |
| `check_ct` | `_spawn(run: Node)` | hard-coded, beastmaster | **SET** | — | **`bomb: 0`** |

**THE BRIEF AND `CLAUDE.md` BOTH UNDERSTATE THE FLAG DIVERGENCE.** DA recorded CQ's removal as
having "left them standing in `check_co`'s and `check_ct`'s". **It left them standing in FIVE** —
`co`, `ct`, `cy`, `cz` and `da`. Two copies dropped them; five kept them.

### The ruling: the flags are omitted, and that is CQ's ruling applied to the other five

Not a merge preference — a fact about the code, and it is now asserted rather than argued:

- `battle._nobody_can_press()` is `sim or autoplay or DisplayServer.get_name() == "headless"`.
  **A gate is always `--headless`, so it is always true.**
- Call site one, `_run_skill_check`: `if not _nobody_can_press() and ...` — **never entered, so
  neither flag is ever READ.**
- Call site two, `_resolve`'s defensive brace: `if _nobody_can_press()` — takes the bot branch.
- **No gate asserts on either flag.**
- **Their one live effect was `Profile._save()`** — five gates writing `user://profile.json` on
  every run. **A gate that mutates the player's profile is the opposite of what `check_ct`
  promises** two hundred lines earlier when it asserts it leaves the save as it found it.

**Verified by measurement, not by reading:** `profile.json`'s mtime is unchanged across a
`check_co` run after the batch, and was not before it.

### The other three axes are real behaviour and are kept, as named arguments

`deterministic` (the AK/AL/AR forcing, `check_cm_live` and `check_cs`), `items` (`check_ct`'s held
empty slot), and `run` (`check_ct` already holds the node). **Each is now visible at the call site
as an argument with a reason beside it, instead of invisible inside a copy.**

**NO GATE NEEDED AN EXEMPTION.** CZ's `_cl_only_corpus` stays named as the one deliberate copy in
the project; the fixture needed no equivalent.

---

## §1 — THE CONSOLIDATION

`gate_fixture.gd` at the repo root. **A `preload`ed `RefCounted`, and the shape was chosen by
measurement rather than taste.**

### The obvious design does not work, and it fails by exiting 0

`extends GateBase` would have inherited `ok`, `_report` and `_spawn` into all seven gates with
**zero call sites changed**. It cannot be done: **a `--script` SceneTree target cannot resolve its
own base class.** Both spellings fail —

```
extends GateBase              → Parse Error: Could not find base class "GateBase".
extends "res://gate_base.gd"  → Parse Error: Could not resolve class "res://gate_base.gd".
```

— with the global class cache present and correct, **and the process exits 0 having run not one
line of the gate.** That is §3's first trap, met while building the batch that reports it.

### And the file carries no `class_name`, deliberately

`class_name` registration lives in `.godot/global_script_class_cache.cfg`, which is **gitignored
and only regenerated by an editor pass**. A `class_name` here would resolve on this machine and
fail on a fresh clone. **Consumers `preload` it by path, which needs no cache and cannot rot.**

### The autoload rule, and a correction to how it is written down

CT's rule is that a `--script` harness can only compile files that name no autoload, and this file
is compiled as a dependency of seven of them. **`Run` is never named here** — it is fetched at
runtime by string path, or passed in. But the rule's *list* is wrong where its *mechanism* is
right: `CLAUDE.md` names "`Run`, `Profile`, `Talents`, `Classes` or `Relics`" as unsafe, and
**`project.godot` registers exactly three autoloads — `Run`, `Settings` and `Music`.** The other
four are `class_name` script classes and are perfectly safe to name at compile time. The gates
have been naming `Talents` all along.

### `ok()` had to come with it

`_report` could not be unified without it. **Four gates' `ok()` never incremented a check
counter** — `check_cm_live`, `check_co`, `check_cy` and `check_cz` were structurally incapable of
printing a check count, which is why every battery ever run shows `checks=?` for all four. **A
count that reads `?` is the one thing a count-diffing rule cannot compare.** The tally is one
authored object now; each gate keeps a one-line delegating `ok()` so **not one of the several
hundred call sites moved.**

### `_report` drifted into FOUR shapes, not two

| shape | gates |
|---|---|
| `NAME: N failures` — **no check count** | `check_cm_live`, `check_co` |
| `NAME: N checks, M failures` — comma | `check_cs` |
| `NAME: N checks / M failures` — slash | `check_ct`, `check_da` |
| **no `_report` at all** — printed and quit inline, countless | `check_cy`, `check_cz` |

One shape now, and the gate's name is **derived from its own script path** rather than written in,
because a hand-written name is the next thing to drift.

### THE BATTERY'S GREP IS NOT NARROWED, AND THE BRIEF'S PREMISE FOR IT IS STALE

**§1 asked for `run_battery.sh`'s hand-rolled `grep -E "checks,"` to be fixed to read the one
format. That grep does not exist.** The only occurrence of `checks,` in the file is **inside the
header comment recording it as a scar CP already fixed** (`run_battery.sh:6`). The live matcher is
already general:

```
grep -oE '([0-9]+ (checks|passed))|(checks: *[0-9]+)'
```

**AND IT MUST STAY GENERAL, BECAUSE IT DOES NOT ONLY SERVE THE GATES.** It reads **45 suites**,
which print at least four other shapes — `BATCH AJ: N checks, M FAILED`, `checks: N   failures: N`,
`sections: N   checks: N   failures: N`, and `test_batch_as: N checks / M failures`. **Narrowing it
to the gates' one format would re-open BQ's scar and CS's, which is the third time that grep has
been too narrow.** One shape for the gates; a grep that reads everything for the battery. **The
scar is recorded in the changelog as asked — as a scar that was already healed.**

---

## §3 — TWO THINGS INTO THE TRAPS

**THE EXIT CODE IS NOT A SIGNAL, AND IT IS THE SAME DEFECT AS `load()` RETURNING A BROKEN SCRIPT.**
Recorded beside CP's parse rule with the reason attached, and with a reproduction: the base-class
probe above prints `Parse Error` on stderr, runs nothing, and exits 0. **`run_battery.sh`'s
`throws=` column is the only thing standing between that fault and a green report.**

**TWO THIRDS OF EVERY TALENT TREE IS OUTSIDE EVERY MEASUREMENT EVER TAKEN HERE.** `Talents.LANES`
is **3** and there are **twelve specs**, so the project has **36 lanes and every figure it has ever
published was walked on the same 12**. It is not a bug — a fixed default party is what makes arms
comparable — but it is a permanent caveat, and filing it in a document is what let it go unnoticed.
**The sim now prints it beside the number**:

```
items=on(...) builds=default(FIRST LANE of each tree — 24 of 36 lanes NEVER MEASURED) relics=none
```

**The count is derived from `Talents.LANES` and `Classes.all_specs()`**, so a lane or a spec added
later moves it without anybody remembering to.

---

## §2 — THE BATTERY, RUN TWICE

**Once before the consolidation and once after**, because §0's proof *is* the counts and a single
run proves nothing about a change. `user://` was backed up first; **no run was in flight**
(`run_save.bin` does not exist), and `profile.json` was backed up because five gates were writing
it.

### THE PROOF: 43 OF 45 SUITES ARE BYTE-IDENTICAL ACROSS THE TWO RUNS

The only two lines that differ are **`an` (6047 → 6051)** and **`bk` (129 → 130)** — **the exact
two suites `state.md` already records as bands rather than numbers**, both at zero failures. Every
gate's FAILURE count is identical. **Nothing this batch touched moved a count.**

### EVERY SUITE, EVERY COUNT

*`expected` is CS's number plus CX's re-point where `state.md` records one. ⚠ marks a line that differed between DB's two runs.*

| suite | CS baseline | expected | this batch | fails | verdict |
|---|---|---|---|---|---|
| `ah` | 5625 | 5625 | **5625** | 0 | = |
| `ah_battle` | 65 | 65 | **65** | 0 | = |
| `ai` | 2217 | 2217 | **2217** | 0 | = |
| `aj` | 418 | 418 | **418** | 0 | = |
| `ak` | 528 | 528 | **528** | 0 | = |
| `al` | 560 | 560 | **559** | 0 | **FELL 1** |
| `an` | 6052 | 6052–6054 | **6051** ⚠ | 0 | **FELL 1** |
| `ar` | 735 | 735 | **735** | 1 | = |
| `as` | 396 | 396 | **396** | 3 | = |
| `at` | 470 | 470 | **470** | 3 | = |
| `au` | 336 | 336 | **336** | 0 | = |
| `av` | 324 | 324 | **324** | 1 | = |
| `aw` | 350 | 350 | **350** | 3 | = |
| `ax` | 345 | 345 | **345** | 2 | = |
| `ay` | 484 | 484 | **484** | 0 | = |
| `az` | 519 | 519 | **519** | 0 | = |
| `ba` | 690 | 690 | **690** | 0 | = |
| `bb` | 177 | 177 | **177** | 2 | = |
| `bc` | 91 | 91 | **91** | 0 | = |
| `bd` | 71 | 71 | **71** | 1 | = |
| `be` | 34 | 34 | **34** | 3 | = |
| `bf` | 78 | 78 | **78** | 5 | = |
| `bg` | 47 | 47 | **47** | 5 | = |
| `bh` | 233 | 233 | **233** | 4 | = |
| `bi` | 91 | 91 | **91** | 6 | = |
| `bj` | 67 | 67 | **67** | 1 | = |
| `bk` | 129 | 129–130 | **130** ⚠ | 0 | = |
| `bl` | 88 | 88 | **88** | 0 | = |
| `bm` | 1891 | 1891 | **1891** | 0 | = |
| `bn` | 81 | 81 | **81** | 2 | = |
| `bo` | 1025 | 1025 | **1025** | 1 | = |
| `bp` | 272 | 275 | **275** | 0 | = (CX +3) |
| `bq` | 739 | 742 | **742** | 1 | = (CX +3) |
| `br` | 1447 | 1450 | **1450** | 2 | = (CX +3) |
| `bs` | 263 | 266 | **266** | 0 | = (CX +3) |
| `bt` | 455 | 458 | **458** | 1 | = (CX +3) |
| `bu` | 477 | 480 | **480** | 5 | = (CX +3) |
| `bv` | 897 | 900 | **900** | 2 | = (CX +3) |
| `bw` | 548 | 551 | **551** | 3 | = (CX +3) |
| `bx` | 142 | 142 | **147** | 2 | **rose 5** |
| `cb` | 1181 | 1184 | **1184** | 2 | = (CX +3) |
| `cd` | 86 | 86 | **86** | 2 | = |
| `ce` | 1112 | 1116 | **1116** | 9 | = (CX +4) |
| `runes` | 3121 | 3121 | **3121** | 0 | = |
| `rune_battle` | 97 | 97 | **97** | 0 | = |

**45 suites, 0 throws, 72 failures.**

### THE GATES

| gate | before | after | verdict |
|---|---|---|---|
| `check_cm_live` | `checks=?` / **4** | **13 / 4** | 4 known-reds **byte-identical**; count now printable |
| `check_co` | `checks=?` / 0 | **297 / 0** | count now printable |
| `check_cs` | **104** / 0 | **104 / 0** | identical |
| `check_ct` | **113** / 0 | **113 / 0** | identical |
| `check_cy` | `checks=?` / 0 | **2704 / 0** | count now printable |
| `check_cz` | `checks=?` / 0 | **131 / 0** | count now printable |
| `check_da` | **30** / 0 | **33 / 0** | **+3 — §3's two census assertions and §1's `flags_are_inert`, the one deliberate movement** |

Run harness **22 / 165 / 8**, all PASS, `throws=0`. `check_ct_map` **83 / 0**. **`throws=0`
everywhere, in both runs, grepped from the stream and never read off a tally.**

`check_da` §3 now prints, and asserts:

```
19 gates; 0 author their own `_spawn`, 0 instantiate the battle by hand
7 go through `gate_fixture.gd`: check_cm_live.gd, check_co.gd, check_cs.gd,
  check_ct.gd, check_cy.gd, check_cz.gd, check_da.gd
```

### A THIRD RUN, AND IT CAUGHT A SECOND FLAKY SUITE

The battery ran a **third** time, because `CLAUDE.md`, `master.html` and the changelog were edited
after the second and **~35 suites assert against those three files**. Two lines differed from the
second run: **`an` 6051 → 6052** (drift, inside the corrected band) and **`at` fails 3 → 4**.

**`at` IS A SECOND FLAKY SUITE AND NOBODY HAD RECORDED IT.** Its three failures are stable
`CLAUDE.md` assertions; the fourth is `Cannon at 8 stacks scales by the PASSIVE alone (1.27x, not
~2.5x)`, **which flaked in 2 of 5 dedicated runs** — roughly 40%, against `bo`'s 1-in-13.
`test_batch_at.gd` calls `seed()` **zero** times and its check count is rock steady at **470**.
**Only the failure count moves, which is exactly the shape a count-diffing rule misreads as a
regression.** It is not one, and it is not DB's: the three doc assertions are byte-identical
before and after every documentation edit in this batch.

### THE BILL FOR FIVE IMPLEMENT-ONLY BATCHES: 72 FAILURES ACROSS 26 SUITES, ZERO THROWS

**None of them is DB's, and none of them is a bug in the game.** They are suites asserting things
CY, CZ and DA deliberately made false, plus CW's split. The dominant cause by a wide margin is
**the Faith threshold**: `FAITH_RELEASE` is 3, so an ally can never stand at four or five stacks,
and every assertion written against that ladder now reads `0.0%` — `be`, `bf`, `bg`, `bh` and `bi`
are 23 of the 72 on their own.

**AND `state.md`'S ONE PIECE OF GOOD NEWS IS HALF RIGHT.** It says DA's revert un-breaks
`test_batch_bi`. **The two checks it names are green** — `FAITH_PER_ABSORB` does not appear in a
FAIL line. **`bi` is red on six others**, all of them threshold consequences (*"two absorbs are
four Faith and do not release yet"* — four is above three, so it releases). The revert fixed what
CZ's **builders** broke; nothing has yet paid for what CZ's **threshold** broke.

### EVERY COUNT THAT MOVED, RUN DOWN TO ITS CAUSE — AND NONE IS A REGRESSION

**Three suites read differently from `state.md`'s CS table. All three are explained.**

- **`al` 560 → 559. STABLE at 559 across five runs — a real fall, and a CORRECT one.** **Batch CV**
  changed `PROSE_NUMBERS["wd_shieldwall"]` from `["4 turns", "5"]` to `["5 turns"]`. The inner loop
  is `for frag in PROSE_NUMBERS[id]`, so **one fewer fragment is one fewer check.** Deliberate,
  correct, and **nobody wrote down that it moved a count.**
- **`bx` 142 → 147. STABLE at 147 across five runs.** **CX re-pointed it at the archive** — its own
  commit message names **eleven** suites (`bp bq br bs bt bu bv bw bx cb ce`). **`state.md` records
  the stale-by-design set as nine suites at +3 plus `ce` at +4, and omits `bx` entirely.** The
  document is wrong, not the suite.
- **`an` — NOT A REGRESSION, AND ITS RECORDED BAND IS WRONG.** Five observations of unmodified
  code: **6047, 6051, 6054, 6048, 6054**. `state.md` records the band as **6052–6054**; **three of
  the five fall below its floor.** `an` calls `seed()` zero times and counts `for ab in
  u.abilities` over live units, so the count follows the draft. **The real spread is at least
  6047–6054 and the recorded band is less than half of it.**

**A count that falls is the finding, and all three findings turned out to be documentation debt
rather than lost coverage.** What is genuinely owed is the 72.

### WHAT DB DELIBERATELY DID NOT DO

**It did not repair one of the 72.** §0 bound this batch to changing no behaviour, and every one of
those assertions needs a ruling on *what it should ask instead* — which is the same reason CX and
DA left CW's eleven standing. **Repairing them is a batch, and it is the one that should follow
DC.**

---

## §4 — WHAT IS OWED

**BATCH DC — THE SUITES, AND IT IS TEN TIMES THIS.** `_spawn` in **37 suites as 34 distinct
bodies**, `_run` in **39 as 39**, `_kill` **byte-identical in 14**. `gate_fixture.gd` is the shape
that works and the `--script` base-class trap is already paid for, but **34 bodies is not 4** and
the suites are not gates — they do not share one battle fixture the way seven gates did.

**AND THE STALE-ASSERTION PASS, WHICH IS NOW MEASURED RATHER THAN ESTIMATED: 72 failures across 26
suites.** It should follow DC, because DC will move the same files.

**Smaller, and named so they are not rediscovered:**
- **`state.md`'s stale-by-design list is wrong in two places** — `bx` is missing from CX's
  re-pointed set, and `al`'s CV −1 was never recorded. Both are fixed in this batch's rewrite.
- **`an`'s band is wrong** — recorded 6052–6054, observed 6047–6054. Fixed in the rewrite.
- **Ten of nineteen gates still cannot report a check count.** DB fixed the seven it touched;
  `check_parse`, `check_flow`, `check_map`, `check_cl_resolver`, `check_cl_width`, `check_cm` and
  `check_cn` still read `checks=?`, and **`check_cl_width` reports `fails=?` as well**, which is
  worse — the battery cannot see whether it passed.
- **`CLAUDE.md`'s autoload rule names four script classes as autoloads.** Corrected in place.
