# BATCH DC — THE FAITH THRESHOLD ASSERTIONS

*2026-08-21. Small, mechanical, and it found two things that were not. **23 stale assertions
repaired to the ruled value, zero deleted, five check counts unchanged.** No save version moves
(still v10). **The suite consolidation is still owed and is still ten times DB's.***

---

## THE HEADLINE

| | |
|---|---|
| **The 23 threshold assertions are repaired.** `be` 3, `bf` 5, `bg` 5, `bh` 4, `bi` 6 — all to `FAITH_RELEASE` = 3, the value ruled at CZ. | **All five suites read 0 failures, and every check count is identical: 34 / 78 / 47 / 233 / 91.** |
| **NOT ONE ASSERTION WAS DELETED.** Every repair is a repoint. | **The counts are the proof and that is why they are published** — a count that moves is a deletion. |
| **TWO PIECES OF IN-GAME PROSE WERE WRONG, NOT STALE.** The Devout's passive and his status chip both promised **3 Faith an absorbed hit**. | **`FAITH_PER_ABSORB` is 2**, and `master.html` has said `(2 a hit)` the whole time. DA's revert moved the code and left the text. |
| **A moved threshold moved a DETECTOR, not just a number.** | `be`'s rate check read **0.0%** after a correct repair, because at one below the threshold an advance releases and the stack-count detector sees a miss. |

**THE BRIEF'S ARITHMETIC WAS WRONG AND IT MATTERS FOR §2's ACCEPTANCE TEST.** It said the total
should fall by "23 plus `bi`'s six if those are distinct". **They are not distinct** —
`state.md`'s own breakdown is `be` 3, `bf` 5, `bg` 5, `bh` 4, `bi` 6, which sums to 23 exactly.
**The family is 23 and the expected landing was 49, not 43.**

---

## §0 — THE BATTERY, AND IT LANDED EXACTLY WHERE IT SHOULD

**45 suites, ZERO THROWS, 49 failures across 21 suites — down from DB's 72 across 26, by exactly
23.** It fell by the threshold family and **by nothing else**, which is the acceptance test §2 set:
an improvement larger than the family would have meant something was repaired by accident.

| | DB | DC |
|---|---|---|
| suites | 45 | 45 |
| throws | 0 | **0** |
| failures | 72 | **49** |
| suites failing | 26 | **21** |

**EVERY CHECK COUNT IN THE BATTERY IS IDENTICAL TO DB's**, with `an` (6053) and `bk` (129) inside
their bands. **The only lines that moved are the five repaired suites' FAILURE counts, all to
zero.** Every gate's failure count is identical, `check_cm_live`'s four known-reds included, and
**`check_cl_width`'s log is byte-identical before and after the two prose edits** — they are
length-neutral by construction and the gate proves it, which matters because that gate reports
`fails=?` and the battery cannot see it.

**The comparison is like-for-like on the flakes:** measured with `at` at the low end of its band
(3) and `bo`'s flake present (1), which is the same condition DB's 72 was measured under. **If
`at` flakes high the total reads 50 and that is not a regression.**

---

## §1 — WHAT WAS ACTUALLY BROKEN

`battle.gd` clamps and releases in one place:

```gdscript
u.faith_stacks = mini(u.faith_stacks + n, FAITH_RELEASE)   # FAITH_RELEASE := 3
...
if own or u.faith_stacks < FAITH_RELEASE:
    _refresh_faith_chip(u, devout)
    return
# the threshold stack: an ALLY releases, always to zero
```

**An ally can therefore never be observed at four or five stacks**, and three consequences follow
that the five suites had all been written against:

1. **The deepest an ally can HOLD is 2.** At 3 he releases on the spot.
2. **Communion's eligible band is 1–2.** The walk skips `h.faith_stacks >= FAITH_RELEASE`, so the
   roll `0.01 * 15 * stacks` **peaks at 30% on two stacks**, not 60% on four. The cliff is at 3.
3. **Two absorbs are a release, not three.** `FAITH_PER_ABSORB` is 2: one absorb holds at two, the
   second reaches the threshold.

Every one of the 23 was an assertion pinned to the pre-CZ version of one of those three facts.

### The repairs, per suite

| suite | failures | what the family was |
|---|---|---|
| `be` | 3 | the Communion rate at the top of the band; the cascade driven from four stacks; the re-entrancy latch driven from four |
| `bf` | 5 | the walk's condition grepped as a literal `>= 5`; the tooltip's "60%"; the rate at four; the cascade and the latch, both from four |
| `bg` | 5 | the status chip driven through `_gain_faith` at 4 (which now releases, so it rendered `Faith x0 (peak 3)`); Communion's rate for a carrier at four |
| `bh` | 4 | the ground drip grepped as a literal `1`; "the Devout HOLDS at five"; "twenty gains release four times"; "the peak stands at five" |
| `bi` | 6 | the peak ratchet over four gains; "the peak is capped at five"; the peak after a release; the absorb ladder; the ground drip's literal; **and one that was not stale at all** (§2) |

### Three habits the repairs put in, beyond the numbers

**THE THRESHOLD IS NAMED ONCE PER SUITE INSTEAD OF SPELLED EVERYWHERE.** Each of the five now
carries:

```gdscript
const RELEASE := 3              # battle.FAITH_RELEASE, ruled at CZ §2
const HELD_MAX := RELEASE - 1   # the deepest an ally can HOLD
```

**The next threshold ruling costs one line a suite rather than a dozen literals** — the same
lesson the master.html stamp gate learned at CP when it stopped being a literal.

**THE SOURCE GREPS NAME THE CONSTANTS TOO.** `bh` and `bi` grepped `battle.gd` for
`_gain_faith(u, 1, "ground")` and `bf` for `h.faith_stacks >= 5`. CZ replaced those literals with
`FAITH_PER_GROUND_TURN` and `FAITH_RELEASE`; the assertions name the constants now, so they cannot
go stale on a re-rating again.

**AND ONE REPAIR IS A `mini()` RATHER THAN A SHORTER LOOP, DELIBERATELY.** `bi` §1 ratchets the
peak over four gains and asserted `peak == i + 1`. The third gain now releases, so the fourth
cannot lift the peak past three. **Deleting the fourth iteration would have made it pass and
stopped it asking its question**; it asserts `peak == mini(i + 1, RELEASE)` and still runs four
times. This is the count discipline in miniature: the honest repair and the cheap one differ by
exactly one check.

### The counts, before and after

| suite | fails before | fails after | checks before | checks after |
|---|---|---|---|---|
| `test_batch_be` | 3 | **0** | 34 | **34** |
| `test_batch_bf` | 5 | **0** | 78 | **78** |
| `test_batch_bg` | 5 | **0** | 47 | **47** |
| `test_batch_bh` | 4 | **0** | 233 | **233** |
| `test_batch_bi` | 6 | **0** | 91 | **91** |
| **total** | **23** | **0** | — | **all identical** |

**A repaired assertion leaves the count unchanged. None of these moved.**

---

## §2 — THE ONE THAT WAS NOT STALE: TWO PIECES OF PROSE PROMISING 3 FAITH A HIT

`test_batch_bi` §1 asks that Conviction's passive block state the absorb rate as **"2 a hit"**. It
was red. **Every other red in that suite was an assertion that had fallen behind the code; this
one was the reverse — the assertion was right and the game's own text was wrong.**

| file | what it said | what it says now |
|---|---|---|
| `scripts/classes.gd` — the Devout's `passive_desc` | *"allies build Faith whenever Divine Shield absorbs damage for them — **3 a hit**, max 3 stacks"* | **2 a hit** |
| `scripts/battle.gd` — the `faith` status default, the chip a player reads mid-fight | *"Divine Shield absorbs build Faith, **3 a hit** — 2% mitigation and +1.5% damage per stack"* | **2 a hit** |

**`battle.FAITH_PER_ABSORB` is 2.** CZ tripled the builders to 3; **DA rolled the code back and did
not roll the text back with it**, so the Devout's passive and his status chip have both been
overstating his own rate by half since DA.

**`docs/master.html` already read `(2 a hit)`, and that is how the two disagreed without anything
noticing.** The documentation was right and the game was wrong — the inverse of the usual failure
here — and **the one suite that asks the question directly was already failing for an unrelated
reason**, so its red announced nothing new. A red check does not announce a second, different
problem hiding underneath it.

**THE SWEEP FOR OTHERS WAS RUN AND IS EMPTY.** `3 a hit` appears nowhere else in `.gd`, `.md`,
`.html` or `.json`; only `bg` and `bi` read that `passive_desc` at all, and both are in the family.
**Both edits are a single digit and length-neutral**, so `check_cl_width`'s wrapping measurements
are untouched by construction — confirmed by the battery, where it reports 0 failures as before.

---

## §3 — WHEN THE THRESHOLD MOVES, THE DETECTOR MOVES WITH IT

**The one repair that did not work first time, and the finding worth keeping.**

`be`'s Communion rate check parks one ally at the top of the eligible band and counts fires over
1200 trials. It was repointed from three stacks to two — correctly — and **still read 0.0%**, on
the same run where the neighbouring row measured the same node at 29.8%.

`_measure` has two detectors and takes a flag to pick one:

```gdscript
if parked:
    if _stat_of(scene, "faith_releases") - before >= 2.0:   # a SECOND release banked
        fired += 1
elif ally.faith_stacks > stacks:                            # the ally's count went up
    fired += 1
```

**At three-of-five, an advance left the ally at four and the stack count saw it. At two-of-three,
an advance takes him TO the threshold, which releases and resets him to zero — so the stack-count
detector reads every single fire as a miss.** The row had to switch to the release counter.

**A moved threshold does not only invalidate the numbers an assertion pins; it can invalidate the
way the assertion looks.** `bf` already knew this — BF moved the same band once before and left a
comment at the function saying the release counter is the only honest witness there. **The comment
was in the right file, attached to the right function, and the repair was made without reading
it.** Both suites now say so at the site that needs it.

The measured result after the switch: **29.8% over 1200 trials against a predicted 30%**, and
15.7% at one stack against 15%.

---

## §4 — THREE THINGS INTO THE RECORD, AND TWO WERE ALREADY THERE

### `test_batch_at` is a second flake, and it is much worse than `bo`

Recorded in `state.md` beside `bo`, **not repaired here.**

| | `at` | `bo` |
|---|---|---|
| failures | **3 or 4** | 0 or 1 |
| flake rate | **2 in 5 dedicated runs (~40%)** | roughly 1 in 13 |
| check count | rock steady at **470** | rock steady at 1025 |
| `seed()` calls | **0** | 0 |

The flaking check is *"Cannon at 8 stacks scales by the PASSIVE alone (1.27x, not ~2.5x)"* — a
damage-scaling assertion, which is the shape CLAUDE.md's flake rule already names. **Only the
FAILURE count moves, so a count-diffing rule reads `at` 3 → 4 as a regression and it is not one.**
The fix is to seed the suite or to assert a ratio with a margin instead of a bare comparison; that
is its own small job and it needs a decision about which, so it was not taken here.

### `an`'s band was already corrected at DB — what was wrong was the observation count

**The brief asked for 6047–6054 to replace `state.md`'s 6052–6054. `state.md` has carried
6047–6054 since DB.** What was actually wrong is inside that sentence: it said **"five
observations"** and then listed **six readings** — 6047, 6051, 6052, 6054, 6048, 6054.

**The band rests on six observations and it says six now**, because a band written from too few
readings reads a normal run as a regression — the same failure as a wrong count, in the opposite
direction. DC's battery adds a seventh reading and it falls inside the band.

### `cd` flags TWO suites, not one — `bb` and `bj`

`state.md` has carried CW's knock-on as *"`FAIL: test_batch_bb.gd reports zero failures`"*, naming
one suite. **`cd` reports two failures and always has:** `bb` and `bj`.

**`cd`'s `REPAIRED` table holds five suites only** — `ah`, `an`, `bb`, `bj`, `test_runes` — each
asserted to report zero failures beside a check-count floor. **`bb` is CW's damage arriving a
second time through the one gate built to notice it; `bj` is a CY delay failure arriving the same
way.**

**That five-suite subset is also why repairing `be`–`bi` did not move `cd`'s count: none of the
five Faith suites is in it**, so the count-differ never saw the largest single family of failures
in the project. Worth knowing before the next batch leans on `cd` as a safety net — **it watches
five suites, not forty-five.**

### The `--script` base-class trap needed nothing: DB recorded it twice

CLAUDE.md carries it **in the traps** — with the reproduction, the `exits 0`, and the note that
`run_battery.sh`'s `throws=` column is the only thing standing between the fault and a green
report — and **again in the fixture rule**, including that **a `preload`ed `RefCounted` with no
`class_name` is the working form** and why (`class_name` registration lives in the gitignored
`.godot/global_script_class_cache.cfg`, so it resolves here and fails on a fresh clone).

**Nothing was added. A rule written twice is not made truer by writing it a third time**, and a
third copy is one more place for the three to drift apart.

---

## §5 — WHAT IS OWED, IN ORDER

1. **THE SUITE CONSOLIDATION — still ten times DB's.** `_spawn` in **37 suites as 34 distinct
   bodies**, `_run` in **39 as 39**, `_kill` **byte-identical in 14**. `gate_fixture.gd` is the
   proven shape and the `--script` base-class trap is already paid for, but **34 bodies is not 4**
   and suites do not share one battle fixture the way seven gates did. **It wants its own
   verification pass.**
2. **THE REMAINING STALE ASSERTIONS — and every one needs a ruling.** CY's moved delays and CZ's
   six are the largest cause, CW's `CLAUDE.md` split the next. **They should follow the
   consolidation, because it will move the same files.**
3. **AND TWO THAT PASS BY ACCIDENT, WHICH IS WORSE THAN A RED.** `contains("BATCH BN")` and
   `contains("BATCH BS")` still match — a passing mention inside a surviving rule, not a batch
   block. **A check that has stopped asking its question, with no red to announce it.**

### Deliberately not done, and why

**`STACKS := 4` STAYS IN `bg`, `bh` AND `bi`, WITH ITS COMMENT CORRECTED.** It used to mean two
things — "the deepest an ally can carry" and "the depth to probe the per-stack arithmetic at" —
and CZ's threshold made the first false. The threshold-bound checks now use `HELD_MAX`; the
arithmetic checks still use `STACKS`, because **they write `faith_stacks`/`faith_peak` straight
onto the unit, bypass `_gain_faith`'s clamp, and measure a per-stack rate against fixed
percentage-point tolerances** (`< 2.0`, `< 2.5`, `> 2.5`). **Halving the probe depth halves the
effect size against tolerances that do not move with it**, across roughly thirty currently-green
live measurements. That is a re-derivation of tolerances, which is a ruling and not a repair, and
this batch was IMPLEMENT ONLY. **The comment now says which of the two things the constant is.**

**Owed, and small: decide whether those arithmetic probes should move down into the reachable
band** (with their tolerances re-derived), or stay as deliberate linear probes above it.
