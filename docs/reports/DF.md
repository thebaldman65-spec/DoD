# Batch DF — THE FORTY-SEVEN, SORTED

*2026-08-22. Implement-only. No save version moves (still v10).*

**Forty-seven assertions had been failing for five batches.** Every batch since DB knew the
number, carried it in `docs/state.md`, and left it — correctly each time, because the standing
instruction was that each of the 47 needed a ruling on what it should ask INSTEAD. Nobody was
careless. **The pile was deliberate, and the pile was also the hiding place.**

**Sorting all 47 before repairing any found one that was not stale at all.** `test_batch_bj` §2
asserts that Consecrated Ground's card reads "kindled 1 Faith". The card reads "kindled **2**",
against a constant that pays **1**. The check has been right, and red, and saying so, since
Batch DA — through DB, DC, DD and DE. **It is reported and not fixed**, because which side is
wrong is a design question.

**The numbers: 47 → 10, a fall of exactly 37, which is the STALE count. Every check count in the
project unmoved.**

---

## §0 — `test_rune_battle` IS SEEDED, AND THE BRIEF'S SECOND ITEM WAS ALREADY PAID

**The seed is PER-SITE, not per-suite.** `_seeded()` is called immediately before the forced White
Flame hit and nowhere else — the AT/AV/BS/BT idiom of forcing determinism at the site under test
rather than widening a tolerance until the noise fits inside it. **Seeding the whole suite would
have fixed the draw for 96 checks that never asked for it**, which is the widening this project
refuses, and it would have hidden which draw mattered.

**The check count is unchanged at 97.** Two post-seed runs read 97 / 0.

**THE BAND IS DELIBERATELY NOT TIGHTENED.** Two clean readings cannot retire a rate measured over
fifteen. Tightening `[0, 1]` to `[0, 0]` on that evidence is the same fault as writing a band from
too few readings, pointing the other way — and CLAUDE.md's own rule says a band moves where a
reading demands it and nowhere else. **Two readings do not demand it.**

**AND THE SEED IS A DIAGNOSTIC AS MUCH AS A FIX.** The assertion's own comment says its snapshot
"is the one that cannot race", and both recorded reds landed under machine load, so a race is the
first thing to look at and the seed cannot fix a race. The failure message now carries the state
the forced hit happened in — `battle_over`, both units' liveness, the target's name and health,
the ability's damage type, the target's fire resist, the pierce fraction. **If it reds again it
will say what was missing instead of only that something was.** That is the reading the brief
asked for and could not get by reading source.

**THE BRIEF'S SECOND §0 ITEM WAS ALREADY DONE.** It says `test_batch_bo`'s band is `0–1` and asks
for the red to stop being labelled a flake. **DE had already made both corrections**:
`baselines.json` carries `bo` at **1–2**, with the floor named as the deterministic CW red and the
ceiling as the flake's contribution. Derived from the file rather than recalled from the brief, so
the red was not counted twice and the 47 did not become 48.

**What was still owed is the general rule, and it is written now**, beside the band rules in
`CLAUDE.md`:

> **A band wide enough to cover a genuine failure cannot report one.** A band is for a count that
> legitimately varies. The moment a floor is set above zero to stop a known failure from shouting,
> the row has stopped being a measurement and become an excuse — and the one thing it can no
> longer do is tell you the failure is still there.

**A FAILURE COUNT'S FLOOR AND A CHECK COUNT'S FLOOR ARE NOT THE SAME KIND OF NUMBER**, and that is
the half of the rule that generalises. A check-count floor is the lowest value a healthy run
produced. A failure-count floor is a **promise that exactly that many reds are known, named and
deliberate** — so it belongs in `baselines.json` with the reason beside it, and a band around it
is only ever a flake's contribution, never a deterministic red's.

---

## §1 — THE SORT: 37 STALE, 2 WRONG, 8 UNDECIDED

**Every failure was bucketed off a battery run on unmodified HEAD before anything was edited**,
and that run reproduced the recorded figure exactly: **47 across 20 suites**, `check_cm_live`'s
four deliberate reds separate, zero throws.

### Bucket 1 — STALE (37)

| family | n | suites | what a ruling moved |
|---|---|---|---|
| **F1** CY's buff-delay cap | 16 | ar av bd bt bu bv bw cb ce | a pre-CY literal delay |
| **F2** DA's constants and refactors | 5 | as aw ax | a value that gained a NAME, and one that gained a third call site |
| **F3** CW's split — batch-block pins | 4 | bb bq br bx | `CLAUDE.md` stopped carrying batch narratives |
| **F4** CW's split — collateral | 4 | bb bn br | the subject survives, elsewhere |
| **F7** `FAITH_RELEASE` 5 → 3 | 8 | bu ce | the threshold DC swept, in two suites it did not reach |

**F1 was verified rather than assumed, and that verification is the reason it is bucket 1.** For
all sixteen: the ability's `special` is in `Ability.PURE_BUFFS`, **and** its def carries
`"delay": Ability.BUFF_DELAY_CAP` written in at the def — not a clamp applied over a literal. The
cap binds them by ruling, the code applies it deliberately, and the pin is what is old. Had even
one of the sixteen carried an ordinary literal while reading 1.0, that one would have been a
WRONG.

**F7 IS THE TRANSFERABLE FINDING AND IT IS AN INDICTMENT OF SEARCH, NOT OF DC.** DC moved
`FAITH_RELEASE` 5 → 3, repaired 23 assertions across `be`, `bf`, `bg`, `bh` and `bi`, published
all five check counts either side, and reported the sweep complete. **`bu` and `ce` carried eight
more of the identical defect the whole time.** They contain neither the words `FAITH_RELEASE` nor
the number 5 anywhere a search for the threshold would find them — they read `w.faith_peak == 5`,
`m.faith_stacks == 4`, `1 + ELEVATION_STACKS_TEST`. **They are arithmetic ABOUT the threshold
rather than references to it, so no grep for the threshold can see them.**

> **A constant's blast radius is every assertion that pins a CONSEQUENCE of it, not only the ones
> that name it.** Enumerate it by driving the constant and letting the failures name themselves.

### Bucket 2 — WRONG (2). Reported, not fixed.

**W1 — Consecrated Ground's card promises double what it pays.** See §3.

**W2 — `data/glossary.json` still reads "beast"**, line 135: *"most party-wide talents deliberately
pay the four and not the beast"*, inside CV's own hero/ally entry. `test_batch_bx` §4 catches it
and is right. One word; it belongs to the prose-rename pass, which is deliberately separate from
the field rename because a missed rename in prose is a typo and a missed rename in a field is a
bug.

### Bucket 3 — UNDECIDED (8). See §4.

**U1 — the exclusive-pair list**, 6 assertions across `as`, `at` and `aw`.
**U2 — two milestones inside a standing reference that is itself stale**, `bo` and `ce`.

### And three documented facts did not survive being checked

1. **`docs/state.md` and `CLAUDE.md` both placed `ce`'s nine failures in CW's family. `ce` was
   never in it.** `BATCH CE` is still in `CLAUDE.md` — a passing mention inside a surviving rule —
   so that check **passes**, and passes by accident. `ce`'s nine are four CY pins, four threshold
   assertions and one milestone. **CW's family is eight assertions, not eleven.**
2. **There are FOUR checks passing by accident, not the two on record.**
   `test_batch_ce.gd`'s `contains("BATCH CE")` and `test_batch_br.gd`'s `contains("Arcane Arrows")`
   join `bn`'s and `bs`'s. Of BR's twelve class-draft cards **exactly four survive in `CLAUDE.md`
   as incidental mentions** (Rally, Ironclad, Bola, Arcane Arrows) — which is why one half of
   `br`'s pair failed while the other went on passing **without its subject being enumerated at
   all**. Both are repaired here as part of their suites' repairs, at no cost to the failure count.
3. **The `_run` census is off by one in every document that carries it.** Re-derived: **39** `_run`
   bodies in 39 suites, **38** open with the `_had_save` preamble, **38** swap `Profile.save_path`
   to a per-suite file — not 37 — and **33 of those 38 swap it back**; `bn`, `bo`, `bp`, `bq` and
   `br` do not. `test_run_harness.gd` restores the real path without ever swapping away from it.

---

## §2 — THE REPAIRS, AND THE THREE THAT NEEDED MORE THAN A LITERAL

**Every repair is a 1-for-1 replacement inside an existing `ok()`.** No assertion was deleted, no
`ok()` was added, and no check count moves. That is the audit, and it is published in §6.

**WHERE A PINNED STRING MOVED BECAUSE A VALUE GAINED A NAME, THE REPAIR ASSERTS BOTH HALVES.** The
ground drip is now checked as `_gain_faith(u, FAITH_PER_GROUND_TURN, "ground")` **and**
`const FAITH_PER_GROUND_TURN := 1`. Following the code's new spelling alone would have left a
check that passes however deep the drip becomes; the question is "a flat 1", not "however
`battle.gd` writes it today".

**THE CW BATCH-BLOCK PINS COULD BE NEITHER REPOINTED NOR INVERTED, AND BOTH REFUSALS ARE
REASONED.** "CLAUDE.md carries the batch block" asserts the opposite of the architecture CW §1
set. Repointing at the changelog would only duplicate the assertion each suite already makes a few
lines below on CD's `<h2>` pattern. **Inverting to `not contains("BATCH BB")` was refused**: a
batch code is legitimately named in passing inside surviving rules — `CLAUDE.md` names `BATCH BN`
twice and `BATCH CE` once that way — so the inverse would fail on an ordinary citation, which is a
worse check than the one being replaced. **They anchor on the rule that replaced them**:
`DO NOT ADD A BATCH BLOCK TO THIS FILE`, the one line CW wrote to stop the blocks coming back. It
fails loudly if CW's architecture is ever reverted, which is the durable form of the question.

**FOUR PINS MOVED FROM THE DOCUMENT TO THE SITE, WHICH IS WHERE THE RULE ALWAYS LIVED.** The
three-field victory ordering is authored in `unit.gd` with the sign of each term written out above
it; `_releasing`'s cycle is written out in full in `battle.gd`. **Those are the copies a later
batch is actually standing in front of when the temptation to delete arrives**, which was the
point of the check — `test_batch_aw` already asserts the same file in the same idiom. `br`'s
enumeration of the twelve moved to the class-seam RULE, because CW ruled that `CLAUDE.md` holds
rules and not content, and `master.html` already carries the names with a loop asserting them.

**THE EIGHT THRESHOLD ASSERTIONS NEEDED THE PROBE RE-DERIVED, NOT A LITERAL SWAPPED, AND THAT IS
SAID OUT LOUD RATHER THAN BURIED.** Under `RELEASE` = 3 a grant of 4 does not come to REST at 4 —
it clamps at the threshold and releases — so the floor a card found is read off the PEAK, which is
exactly the reasoning CQ had already written into the first of them. `bu` and `ce` each gain DC's
two constants, `RELEASE` and `HELD_MAX`, so the next threshold ruling costs them one line apiece.

**ONE OF THE RE-DERIVATIONS MAKES THE CHECK STRONGER, WHICH IS WORTH SAYING BECAUSE THE INSTINCT
IS THE OPPOSITE.** `ce`'s Elevation probe drove three allies at 0, 1 and 2 to prove the card ADDS a
count rather than writing a floor. At the ruled threshold two of the three now cross the cap and
release instead of coming to rest — and **a floor-write of 2 would leave all three sitting at 2
with nobody releasing at all.** So the release is a discriminator the old construction did not
have. **Ask what a new threshold makes visible before assuming it has taken something away.**

**WHAT WAS DELIBERATELY LEFT ALONE.** The probe depths in `bg`, `bh` and `bi` are untouched. They
measure per-stack rates against fixed percentage-point tolerances, so halving a depth halves the
effect against a tolerance that does not move with it — **that is a re-derivation of tolerances,
which is a ruling and not a repair**, and it stays on the queue exactly as `docs/state.md` records
it. F7's eight involve no tolerances at all, which is what makes them repairable here.

---

## §3 — CONSECRATED GROUND HAS PROMISED DOUBLE WHAT IT PAYS FOR FOUR BATCHES

**`scripts/classes.gd` tells the player: *"every ally is kindled 2 Faith at the start of their turn
while it holds."* `battle.FAITH_PER_GROUND_TURN` is 1**, and `_ground_faith_tick` pays exactly it.

The evidence, all of it re-derived rather than reasoned from the failure message:

- **`_gain_faith` doubles under `zeal` and under nothing else.** Not Fervor, not Apostle — the one
  multiplier in the function is `if u.has_status("zeal"): n *= 2`.
- **`test_batch_aw`'s LIVE checks pass and measure it landing one at a time**, through a real turn:
  one `_ground_faith_tick` leaves the ally at 1, a second leaves him at 2. Those assertions are
  green. Only the source-string pins beside them were stale.
- **`docs/master.html` reads "standing on Consecrated Ground (1 an ally a turn)"** and has been
  right throughout. **So the design document and the game have disagreed for four batches, and the
  only thing that noticed was a suite nobody had sorted.**

**The history is unambiguous and it is a revert that did not sweep:**

| batch | `FAITH_PER_GROUND_TURN` | the card |
|---|---|---|
| BJ | 1 | "kindled **1** Faith" — authored to match |
| CZ (`ad8a52a`) | 1 → **2** | 1 → **2**, moved with it, **correctly** |
| DA (`9327194`) | 2 → **1** | **left at 2** |

**DC then swept this exact defect and fixed two instances** — the Devout's `passive_desc` ("3 a
hit") and the `faith` status chip — **and did not reach the third.** `test_batch_bj` §2 has been
red ever since, inside a pile of 47 reds that nobody had sorted.

**IT IS REPORTED AND NOT FIXED.** The code is what DA ruled; the card is what CZ wrote. Either the
card returns to "1 Faith", or DA's revert went one step too deep and the ground drip was meant to
stay at 2 — and **that is the designer's call, not a detail to guess at.** Editing the card would
have written a green check over a live question, which is the precise failure §1's sort exists to
prevent.

**THE RULE THAT WOULD HAVE CAUGHT IT IS NOW STANDING**, in `CLAUDE.md`:

> **A reverted constant must be swept through the ability CARD too** — not only the passive text,
> the status chip and the design doc. **Grep the NUMBER, not the field**: the card says "2 Faith"
> and never says `FAITH_PER_GROUND_TURN`.

**And a revert is not the inverse of a change.** A change is written by someone thinking about the
number; a revert is written by someone thinking about the constant. That asymmetry is why CZ moved
both halves and DA moved one.

---

## §4 — THE EIGHT THAT NEED A RULING

### U1 — the exclusive-pair list. 6 assertions: `as` 2, `at` 3, `aw` 1.

All six pin `CLAUDE.md`'s block:

> `no rune may write one half of an EXCLUSIVE talent pair (heat_haze/scorched, cascade/overflow,
> pact_flesh/barter — cold_snap/bitter_cold DISSOLVED IN BATCH AS … arcane_ward/still_mind
> DISSOLVED IN BATCH AT … stalwart/bastion DISSOLVED IN BATCH AW …)`

**CW's split removed it with Batch AA's narrative, and the strings exist NOWHERE** — not in
`CLAUDE.md`, `master.html`, the live changelog, or `changelog-archive.html` (which reaches back to
Batch 1, so this is not an archiving gap). **There is nothing to repoint at.**

**AND THE RULE THEY GUARD WAS ALREADY DEAD WHEN CW DROPPED IT.** The removed block's own closing
sentence says so:

> *"NOTE the rule itself is no longer a live TEST: Batch AI retired `test_runes._exclusives` to a
> `pass` because at row granularity it would fire on nearly every spec rune in the game."*

**TWO MORE ASSERTIONS IN THE SAME BLOCK NOW PASS VACUOUSLY, WHICH IS THE TELL.** `as`'s "the pair
left the ACTIVE list" passes because the *whole list* left; `at`'s reads a substring of an empty
string. **So the family is eight assertions in a dead subject, six of them red and two of them
green for no reason at all.**

**THE QUESTION: does the no-rune-writes-an-exclusive-half rule still bind?**

- **If it does**, it belongs in `CLAUDE.md`'s **TRAPS** section — which is CW §1's own mechanism
  for rules that were buried in batch blocks — and the dissolution history belongs in
  `docs/state.md`, per that section's own header ("live counts belong in `docs/state.md`; the rule
  is what is here").
- **If it does not**, the six should point at `talents.gd`, where "these two nodes share a lane and
  sit in different rows" is actually true and checkable — **and where `as` §6's first two
  assertions already ask it and already pass.**

### U2 — two milestones inside a standing reference that is itself stale. `bo` 1, `ce` 1.

`bo` asks `CLAUDE.md` to name `TRANCHES 2 AND 3` as "the debt that remains". `ce` asks it to record
the Cleric as "the second class complete".

**THE DEBT DOES NOT REMAIN.** Counted out of `classes.gd`: `SPEC_DRAFT_POOLS` is **96** (12 specs ×
8) and `CLASS_DRAFT_POOLS` is **24** (4 classes × 6) — **120 of 120**, which is what
`master.html` already says and what `test_batch_br` already asserts against it.

**AND THE DOCUMENT UNDERNEATH THEM CONTRADICTS ITSELF, WHICH IS THE ACTUAL FINDING AND IS NOT
WHAT IT FIRST LOOKED LIKE.** `CLAUDE.md`'s `## STANDING REFERENCE — THE ABILITY DRAFT` block runs
lines 2061–2182 and **states the draft's size twice, 49 lines apart, with different answers**:

| line | what it says | status |
|---|---|---|
| **2116** | *"96 SPEC (12 specs x 8) + 24 CLASS-WIDE = 120; **THE DRAFT STANDS AT 120 OF 120 AND NOTHING IS OWED** (Batch CI)"* | **current and correct** |
| **2160–2168** | *"`SPEC_DRAFT_POOLS` is **24 entries**"*, *"the draft holds **66 of a target 120** (Batch BU)"*, *"the HUNTER and WARRIOR six are **still at TWO**"*, *"tranche 3 after them"* | **a BU-era snapshot, superseded** |

**So the correct figure IS recorded** — `test_batch_cd` §2 asserts exactly that line and passes —
**and a superseded paragraph sits below it saying the opposite.** `bo`'s and `ce`'s assertions pin
phrases from the superseded half. **The stale prose survived CW's split because it sits under a
STANDING heading rather than in a batch block**, which is a real hole in that split's method: the
sweep was for narrative *form*, and a superseded snapshot wearing a standing heading is narrative
in every way but its formatting.

### And `test_batch_cd`'s own anchor guard does not bite — found here, still green

`test_batch_cd` §2 slices `CLAUDE.md` from the draft anchor and comments that it stops at the next
standing block *"so a later batch's prose cannot quietly extend what this check is reading (the BE
anchor lesson)"*. **It looks for `"### STANDING"` — three hashes. Every heading in `CLAUDE.md` is
`## STANDING` — two.** `find()` returns −1, the guard falls through, and **the slice runs to the
end of the file**: 20,949 characters instead of the block's 10,335.

**Nothing is red, and that is the point.** The assertions still pass because the correct sentence
happens to live inside the true block as well. But the check is currently asking *"does the rest of
`CLAUDE.md`, from here down, contain '120 OF 120' somewhere?"* — **which is the exact failure its
own comment says it exists to prevent**, in the suite whose whole job is hygiene. It is a **sixth**
check that has stopped asking its question, and unlike the other five it was found with no failure
to point at it.

**IT IS REPORTED AND NOT FIXED.** The fix is one string — `tail.find("\n## STANDING")` — but
narrowing a gate's scope is a change to what an instrument measures, which is what DD got wrong by
widening one, and it must be made deliberately with the counts published either side. **It is on
the queue in `docs/state.md`, with the fix named.**

**THE QUESTION: correct the block to the completed draft and invert both assertions to protect the
record of COMPLETION** — which is exactly the idiom `bo`'s own comments show BP, BQ and BR using
three times as each debt was paid — **or rule that the block should be cut and the two assertions
pointed at `classes.gd`.** Rewriting a STANDING REFERENCE is a documentation ruling, and this
batch does not take one.

---

## §5 — WHAT THIS BATCH DELIBERATELY DID NOT DO

- **It did not fix either WRONG.** Both are design questions and §1's rule is explicit that the
  cost of misfiling one as a STALE is a green check over a real bug.
- **It did not touch `bg`, `bh` and `bi`'s probe depths.** Still a tolerance re-derivation, still a
  ruling.
- **It did not tighten `test_rune_battle`'s band on two readings**, and did not seed `bo`'s flake —
  one flake at a time is how the effect stays attributable.
- **It did not rewrite `CLAUDE.md`'s ABILITY DRAFT block**, though it is demonstrably stale. That
  is U2's ruling to make and correcting it silently would have removed the evidence for it.

---

## §6 — VERIFICATION

**Two full batteries: one on unmodified HEAD before the first edit, and a verification run against
the final tree.** A third was not needed, and the reason is worth stating because DE paid for one:
`docs/state.md` and this report are the only documents written after the run, **neither is read by
any suite, and `check_de` reads neither** — so the verification battery supervised every file the
tree actually reads. **`baselines.json` was written with the PREDICTED after-values BEFORE the run**,
so the run tested the prediction instead of recording it: a row that disagreed would have been
`check_de`'s error rather than a line in this report.

### The sort — all 47, and where each went

| bucket | n | suites |
|---|---|---|
| **STALE — repaired here** | **37** | ar 1, as 1, av 1, aw 2, ax 2, bb 2, bd 1, bn 2, bq 1, br 2, bt 1, bu 5, bv 2, bw 3, bx 1, cb 2, ce 8 |
| **WRONG — reported, not fixed** | **2** | bj 1, bx 1 |
| **UNDECIDED — reported with the question** | **8** | as 2, at 3, aw 1, bo 1, ce 1 |

Buckets 2 and 3 are written out in full in §3 and §4.

### Failure total before and after

| | before | after |
|---|---|---|
| **suite failures** | **47 across 20 suites** | **10 across 7 suites** |
| **the fall** | | **exactly 37** |
| `check_cm_live`, the deliberate red | 4 | 4 |
| **throws, grepped from the stream** | **0** | **0** |

**THE BEFORE-BATTERY REPRODUCED THE RECORDED FIGURE EXACTLY — 47 across 20** — so the number five
batches had carried is confirmed against this machine rather than only against a document.

**THE FALL IS EXACTLY THE STALE COUNT AND THE TEST IS TWO-SIDED.** A smaller fall means a repair did
not land. **A LARGER fall means something was repaired by accident** — an improvement nobody aimed
at is a change nobody understands, and it would have been reported rather than banked. It is 37.

The ten that remain: `as` 2, `at` 3, `aw` 1, `bj` 1, `bo` 1, `bx` 1, `ce` 1.

### Every check count unmoved

**Every repaired suite's check count is byte-identical across the pair:**

| ar | as | av | aw | ax | bb | bd | bn | bq | br | bt | bu | bv | bw | bx | cb | ce |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 735 | 396 | 324 | 350 | 345 | 177 | 71 | 81 | 742 | 1450 | 458 | 480 | 900 | 551 | 147 | 1184 | 1116 |

**That is the audit CQ's rule asks for**, and it is what says no assertion was deleted to reach
green: seventeen suites lost 37 failures between them and not one check.

**ONLY TWO CHECK COUNTS IN THE PROJECT MOVED, AND BOTH ARE THE KNOWN DRIFTERS** — `an` 6046 → 6054
and `bk` 129 → 130, both inside their recorded bands, both at 0 failures throughout. Everything else
is identical across the pair: all 14 gate lines, the harness at 22 / 165 / 8, `check_ct_map` at
83 / 0, `check_map_screen` at its `OK`.

**`an`'s FLOOR MOVED, FOR A READING AND NOT FOR A REPAIR.** The before-battery read **6046** on
unmodified HEAD, one below a floor that was itself the lowest of thirteen readings, and `check_de`
reported it as an error — which is the asymmetry DE built working exactly as intended. **It is
drift, not a fault:** 0 failures, 0 throws, and all thirteen of the suite's section headers printed,
so nothing stopped running. **Nothing this batch did could have caused it — the reading predates the
first edit.** The floor is 6046 now and the row rests on fifteen readings.

### The differ

**`check_de`: 273 checks / 0 failures / 0 notices** on the verification run — 65 of 65 recorded
targets swept, zero throw markers, 0 unwatched and 0 un-run. **Every predicted baseline was
confirmed by the run.** The observation counts were then raised for DF's two readings and **the same
logs re-read 273 / 0 / 0 in 0.37 seconds.**

### Parse

**Every edited suite was parse-checked with `--check-only`, grepping stderr for `Parse Error` and
`SCRIPT ERROR` — never a tally and never the exit code** — and **a negative control was run**: a
deliberate syntax error appended to `test_batch_ce.gd` produced `1`, the file was restored, and the
re-check produced `0`. **The check bites.** `throws=0` on every target in both batteries.

### Wall clock

| | start | end | elapsed |
|---|---|---|---|
| before-battery | 11:46:53 | 12:15:58 | **29m 05s** |
| verification battery | 12:35:09 | 13:04:27 | **29m 18s** |

**DE's 29 minutes held**, on both runs, with the count differ included in each.

---

## §7 — DOCUMENTATION, AND WHAT IS RECORDED AS OWED

`docs/changelog.html`, `CLAUDE.md`, **`docs/state.md` rewritten**, `baselines.json`,
`docs/reports/DF.md`, `docs/design-notes.md`, and the `master.html` stamp
(`Last updated: 2026-08-22 (Batch DF)` — `DF` sorts after every one of the fourteen suite codes the
stamp gate compares against).

**Three standing rules were added to `CLAUDE.md`:**

1. **A band wide enough to cover a genuine failure cannot report one** (DF §0), beside the existing
   band rules — with the distinction that **a failure count's floor and a check count's floor are
   not the same kind of number.**
2. **A constant's blast radius is every assertion that pins a CONSEQUENCE of it**, not only the ones
   that name it (DF §1).
3. **A reverted constant must be swept through the ability CARD too** — grep the number, not the
   field (DF §1).

**And one correction:** `CLAUDE.md` and `docs/state.md` both named `ce` in CW's family. It was never
in it, and the family is eight assertions rather than eleven.

**RECORDED AS OWED:**

- **`_run`'s save-backup preamble, the next copied helper, and the census was off by one.**
  Re-derived: **39** `_run` bodies in 39 suites (correctly 39 — it is each suite's own driver),
  **38** opening with the same `_had_save` block, **38** swapping `Profile.save_path` to a per-suite
  file — **not the 37 every document has carried** — and **33 of those 38 swapping it back**; `bn`,
  `bo`, `bp`, `bq` and `br` do not. `test_run_harness.gd` restores the real path without ever
  swapping away from it. **Still not taken.**
- **`test_batch_cd`'s §2 anchor guard does not bite** — `"### STANDING"` against a file that only
  uses `"## STANDING"`. Nothing is red. The fix is one string and it narrows a gate's scope, so it
  wants its own change with the counts published either side.
- **`CLAUDE.md` is at 3.18% of the knowledge sync against CW's own "under 3%" target**, and was
  already over before this batch's additions.
