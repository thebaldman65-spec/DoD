# BATCH DG — THE LAST TEN

**All ten of DF's ruling queue are closed, and both instrument faults it reported out of scope with
them.** Nine were repaired or ruled on; one — `an`'s floor — was already done at DF and is reported
rather than repeated. **The verification battery found an ELEVENTH red that no batch has recorded
before**, in `test_batch_at`, and it is reported and deliberately not fixed. §8 has the numbers.

---

## §1 — CONSECRATED GROUND'S CARD GOES BACK TO 1

**The card is corrected and `FAITH_PER_GROUND_TURN` did not move.** `scripts/classes.gd` told the
player *"every ally is kindled **2** Faith at the start of their turn"* while the constant paid
**1**. It reads *"kindled 1 Faith"* now.

**DA's revert is not reopened, and that was the ruling.** At the reverted magnitudes an absorbed hit
was very nearly a whole release and a shielded ally never held Faith at all; raising the ground drip
to match the card would have partly reopened exactly what that revert closed. **The prose was wrong,
not the constant.**

### The sweep found the card was the ONLY stale surface

The brief asked for a sweep of the card, the `passive_desc`, the chip, the glossary and
`master.html`, on the expectation that DC had reached three of four. **It was one of five, and the
other four were already right:**

| surface | reads | state |
|---|---|---|
| Consecrated Ground's card (`classes.gd`) | "kindled **2** Faith" | **the one stale site — corrected** |
| the Devout's `passive_desc` (`classes.gd`) | "2 a hit" — the ABSORB rate | correct, and a different constant |
| the `faith` status chip (`battle.gd`) | "2 a hit" — the ABSORB rate | correct, and a different constant |
| `data/glossary.json` `res_faith` | "gains **one** at the start of their turn" | correct throughout |
| `docs/master.html` (two sites) | "(1 an ally a turn)", "(1 per ally per turn)" | correct throughout |

**DC's two repairs were to the ABSORB magnitude, which DA reverted in the same batch** — a
*different* constant with different surfaces. That is the real shape of the miss, and it generalises:
**when a batch reverts two constants at once, sweep them as two sweeps**, or the one with fewer
surfaces looks finished because the other one was. Recorded in `CLAUDE.md`.

Three further comments state the drip and all three already read 1 (`classes.gd` twice, `unit.gd`
once). **Nine surfaces speak this number and exactly one was wrong.**

---

## §2 — THE EXCLUSIVE-PAIR SIX ARE DELETED

Six assertions — `as` 2, `at` 3, `aw` 1 — pinned `CLAUDE.md`'s EXCLUSIVE-PAIR LIST.

**The strings were verified absent, not assumed absent.** Every one of the six pair names was
grepped across the whole repo AND `DoD-archive/`: they survive only inside the three suites
themselves and inside DF's own changelog entry reporting the finding. **Not in `CLAUDE.md`, not in
`master.html`, not in `changelog-archive.html`** — which reaches back to Batch 1, so this is not an
archiving gap.

**And the rule they guarded was already dead when CW dropped it**, by the removed block's own
closing sentence: Batch AI retired `test_runes._exclusives` to a bare `pass`.

**THE DELETION IS RECORDED AS AN EXCEPTION, NOT TAKEN AS A LIBERTY.** It is written into
`CLAUDE.md` beside the rule it excepts, and into a comment at each of the three sites naming what
the assertions asked and why the subject is gone. The reasoning is that **the never-delete rule
protects a LIVE question from being silenced**, and a check whose subject exists nowhere is not one:
it cannot pass, cannot fail meaningfully, and cannot be repointed at anything.

**THE PREDICTION WAS THE PRICE.** `baselines.json` carried 394 / 467 / 349 **before** the battery
ran, so a fall of any other size would have been `check_de`'s error rather than a note in this
report. **The measured fall is exactly six.**

### A third vacuous sibling, found here

DF recorded two assertions in these blocks that pass VACUOUSLY. **There are three.** `aw`'s
`live_list := claude.substr(claude.find("no rune may write"), 120)` takes `find() == -1`, and Godot's
`substr` returns `""` for a negative `from`, so `not "".contains("stalwart/bastion")` is true for no
reason at all. **The battery confirms it empirically**: `aw` reads 349 checks / **0** failures, which
it could not do if that assertion were asking anything.

All three are **left standing and named at their sites**, because **six is the only sanctioned fall
in this batch** and deleting them would have broken the very acceptance test that makes the deletion
safe. They are carried in `docs/state.md` as owed.

---

## §3 — ONE BLOCK STATED THE DRAFT'S SIZE TWICE, AND THE SWEEP FOUND THREE MORE

`CLAUDE.md`'s `STANDING REFERENCE — THE ABILITY DRAFT` said **"120 OF 120 AND NOTHING IS OWED" at
line 2116** and, **exactly 49 lines below at 2165**, that the draft held sixty-six of a target 120,
that `SPEC_DRAFT_POOLS` was 24 entries, and that the HUNTER and WARRIOR six were still at two.

**The superseded half is cut** and replaced with the record of COMPLETION: 96 spec across twelve
specs at eight, plus 24 class-wide across four pools of six, is 120 of 120. **It survived CW's split
because that sweep was for narrative FORM, and a superseded snapshot wearing a STANDING heading is
narrative in every way but its formatting.**

### Repointing was not optional

Both assertions are INVERTED on the idiom BP, BQ and BR each used as a debt was paid.

- **`bo` §6** asserted `CLAUDE.md` named `TRANCHES 2 AND 3` as the debt that *remains*; it asserts
  they are recorded as **PAID**.
- **`ce` §5** asserted the Cleric was the "second class complete"; it asserts the completion
  **ORDER**, the Cleric second of four.

**`bo`'s could not simply have been left.** The corrected prose contains the phrase
`TRANCHES 2 AND 3`, so the old assertion would have gone **green while carrying a message stating a
debt that does not exist** — a check passing by accident, which this project treats as worse than a
red. The string and the message had to move together.

### Three more statements of the size, all in live prose

The brief said there was no reason to assume there were only two. There were five.

| site | said | status |
|---|---|---|
| `scripts/classes.gd` header | **"ONE HUNDRED AND ELEVEN OF A TARGET 120"** | corrected to 120 |
| `scripts/classes.gd` header | tranche 3 "THREE QUARTERS PAID", Warrior third "the last debt the draft carries" | corrected — CI paid it |
| `test_batch_bv` / `bw` messages | "the whole draft is **102** of a target 120" while asserting 120 | messages corrected |
| `test_batch_br` message | "`SPEC_DRAFT_POOLS` is 60 plus CB's Mage nine and CE's Cleric nine" — 78 — while asserting 96 | message corrected |
| `test_batch_cd` comment | "the draft is 102 and what is owed is the Hunter and Warrior thirds" | comment corrected |

**The worst of these is in `classes.gd`, which is the file every document says the count is derived
FROM.** A reader re-deriving the number would have opened that file and read 111 in its heading.

**Every one of these is prose or a message: no assertion changed, and no check count moved.** A
message that states a wrong size teaches it to whoever reads the failure — CD §2's rule, applied to
the size rather than to the old target it was written for.

---

## §4 — THE GLOSSARY'S REMAINING "beast" WAS PROSE

**It was PROSE, so it was fixed.** `data/glossary.json`'s `hero_vs_ally` entry read *"most
party-wide talents deliberately pay the four and not the **beast**"* — the common noun, in
player-facing text, inside CV's own hero/ally entry. It reads *"the companion"* now.

**Every other "beast" in the file is `Beastmaster`** — five occurrences across four entries
(`extra_turn`, `hero_vs_ally`, `pack_bond` twice, `res_loyalty`, `protected_core`) — **and the spec
name is on the deliberate do-not-rename list.** No identifier was touched, and
`bm_beast_within` / `bm_no_beast_left` **move the save format** if they ever are.

**A missed rename in prose is a typo; a missed rename in a field is a bug**, which is why the two
were given separate passes. This was the typo.

---

## §5 — `test_batch_cd`'s ANCHOR GUARD HAD NEVER ONCE BITTEN

§2 slices `CLAUDE.md` from the draft anchor and stops at the next standing block, *"so a later
batch's prose cannot quietly extend what this check is reading (the BE anchor lesson)"*.

**It searched for `"### STANDING"` — three hashes. All seventeen headings in the file are
`## STANDING` — two.** `find()` returned −1 every time it ran, the guard fell through, and **the
slice ran to end of file: 21,532 characters against the block's 10,917.** Nothing was ever red,
because the sentence it looks for also lives inside the true block.

**A check that cannot fail, inside the suite whose job is finding checks that cannot fail.**

### The repair, and the half that was missing

The anchor is `tail.find("\n## STANDING")`. **The leading newline is load-bearing**: `tail` opens
mid-heading at the anchor itself, so a bare `"## STANDING"` would match its OWN heading, slice the
block to nothing, and turn every assertion under it red at once.

**And the guard now asserts that it RESOLVED** — `ok(stop > 0, ...)`. That is the general fix rather
than the specific one: **a fall-through is only silent while nothing asks.** An anchor that stops
matching is RED now instead of quietly wide.

**THE NEGATIVE CONTROL WAS RUN, both ways** (CP's rule — an instrument repaired without one is an
instrument nobody has tested):

| tree | result |
|---|---|
| repaired | **72 checks / 0 failures** |
| anchor deliberately reverted to three hashes | **72 checks / 1 failure**, and the red is the new guard by name |
| the same break, before DG | **0 failures** — which is the whole point |

The probe was backed up to the scratchpad and restored from there, never by `git checkout`.

**The check count RISES 71 → 72, and that rise is the repair working.**

---

## §6 — `an`'s FLOOR WAS ALREADY WIDENED AT DF

**Reported, not repeated.** The brief asked for the floor to be widened 6047 → 6046 and the
observation count recorded as "now eleven". Derived from the file rather than recalled:

- **`baselines.json` already carries the floor at 6046**, widened by DF for the same reading on
  unmodified HEAD.
- **The row already rests on fifteen observations, not eleven.**
- **This battery read `an` at 6054** — comfortably inside the band. Nothing moves.

**And the observation count is stated in three places, two of which disagree with the file.** DF's
report says fifteen and `baselines.json` says fifteen; **DF's changelog entry and `docs/state.md`
both say fourteen.** The changelog is a dated record and is left as written (CA's rule);
`docs/state.md` is rewritten this batch and **now points at `baselines.json` instead of restating
the number**, which is what that file's own header asks for. **A second copy of a number is this
project's oldest recurring defect, and §3 and §6 are both instances of it in one batch.**

---

## §7 — ONE STANDING RULE, EARNED AT DF

Recorded in `CLAUDE.md`:

> **In a repair batch, write the predicted baselines BEFORE the verification run.** A baseline
> written afterwards records whatever happened; written first, it is a test. **The difference is
> whether the batch can fail.**

Written with the two-sided form spelled out: predict every row you expect to move, and by how much,
because **a movement of the wrong SIZE is the same alarm as an unsanctioned one.**

**DG is the first batch bound by it, and it paid immediately** — see §8.

---

## §8 — VERIFICATION

**ONE FULL BATTERY, A VERIFICATION RUN AGAINST THE FINAL TREE, IN 29m 19s.** DE's ~29 minutes held
(DF's pair were 29m 05s and 29m 18s). A before-battery was not run and could not have been run
honestly: **DF's own after-battery established the starting figure of 10 on the tree DG inherited.**
`docs/state.md` and this report are the only documents written after the run — **neither is read by
any suite and `check_de` reads neither** — so the battery supervised every file the tree reads.

**`baselines.json` CARRIED THE PREDICTED AFTER-VALUES BEFORE THE RUN**, per §7's own new rule.

### Failure total

| | before (DF's after-battery) | after |
|---|---|---|
| **suite failures** | **10 across 7** | **1 across 1** |
| the ten | | **all closed** |
| the one | | **`test_batch_at` — NEW, not predicted, not DG's** |
| `check_cm_live` (deliberate) | 4 | 4 |
| **throws, grepped from the stream** | **0** | **0** |
| `check_de` | 273 / 0 / 0 | **273 / 1 / 0**, then **273 / 0 / 0** once the flake was recorded |

**The expected end state was zero and the measured one is one.** All ten of the ruling queue are
closed; the remaining red is an eleventh that no reading had ever produced before.

### Check counts — the only two movements are the two that were sanctioned

| suite | before | after | movement |
|---|---|---|---|
| `as` | 396 | **394** | −2 — §2's deletion |
| `at` | 470 | **467** | −3 — §2's deletion |
| `aw` | 350 | **349** | −1 — §2's deletion |
| `cd` | 71 | **72** | **+1 — §5's repair** |

**§2's fall is exactly six and §5's rise is exactly one.** **Every other check count in the project
is inside its recorded band** — all 46 suites, all 14 gate lines, the harness at 22 / 165 / 8,
`check_ct_map` at 83 / 0, `check_map_screen` at its `OK` — which `check_de` reports as **0 notices**.
That is the audit saying no assertion was removed except the six that were meant to be.

**`throws=0` on every target**, grepped from the stream and never read off a tally.

### THE ELEVENTH RED, AND WHY IT IS THE INSTRUMENT WORKING

`check_de`'s one failure read:

> **`test_batch_at` went REDDER: 1 failures, recorded 0 — a red suite going redder is exactly the
> movement an aggregate hides (BATCH DE §3)**

**DG predicted 0 for that row BEFORE the run. The run disagreed. The differ said so.** Had
`baselines.json` been filled in from the log afterwards it would have recorded 1 and reported
nothing at all — **which is precisely the case §7's new rule exists to make impossible, on the very
first batch bound by it.**

**It is not DG's.** The failing check is `_live_curve`'s damage-curve ratio; DG's only edits to that
file were three deleted file-reading assertions, which consume no RNG, and **the suite's check count
landed exactly on prediction at 467.**

**IT IS A THIRD CHECK OF A SPECIES DD FIXED TWICE IN THIS SAME SUITE.** The check sums ten casts at
0 Resonance and ten at 12 and asserts the ratio is `> 2.0 and < 2.35` against a table value of
**2.17**. It read **2.40**. **It is unseeded** — every `_seeded()` call in the file is downstream of
it.

**THE ±10% DAMAGE ROLL ALONE DOES NOT EXPLAIN THAT NUMBER.** Modelled over 200,000 trials, ten
summed casts a side put the ratio's 5th–95th percentile at **2.08–2.26** and P(over the ceiling) at
**0.1%** — about one run in a thousand. **So there is a second random term**, and the suite's own
`_spawn` names the candidate on the very helper this check calls:

> *"THE CRIT IS THE THIRD COIN AND ON THIS SPEC IT IS THE WORST ONE: Runaway Resonance adds +1%
> crit PER STACK, so a 'same cast at 0 stacks vs 12' comparison silently compares 10% crit against
> 22% crit."*

The fixture passes `"crit": -10.0`, which removes the **base** and not the **per-stack** term — so
the two populations differ in crit chance as well as in the curve the check means to measure.
**A model carrying the full differential over-predicts badly (32% red against one red in eighteen
readings observed), so the live term is smaller than that and larger than zero. Its size is not
established and this report does not guess it.**

**CHARACTERISED RATHER THAN ASSUMED:** six ad-hoc re-runs after the battery, **all 467 checks / 0
failures**. With the eleven readings on record before DG and the battery itself, that is **one red
in eighteen**, and **the check count is rock steady at 467 across all seven DG readings** — only
the failure moves, which is the flake signature `CLAUDE.md` names.

**REPORTED AND DELIBERATELY NOT FIXED.** It is not one of the ten; the fix is DD's shape (seed both
blows, or neutralise the crit as the file's own comment instructs) and **not** widening the band,
because the band is the question; and **one flake at a time is how the effect stays attributable** —
`bo`'s and `test_rune_battle`'s are both still open. Its band is `[0, 1]` in `baselines.json` with
the full reasoning and the readings beside it.

**Zero was never the goal — "every remaining red is deliberate and recorded" is.** Every red in the
project now satisfies that: `check_cm_live`'s four are on purpose, and `at`'s one is recorded with
its rate, its mechanism, its evidence and its fix.

---

## §9 — DOCUMENTATION AND THE PUSH CHECK

Written **before** the battery, so the run supervised them: `docs/changelog.html` (the DG entry),
`CLAUDE.md` (§7's new standing rule, §2's recorded exception beside the rule it excepts, §1's case
closed in the rule it created, and §3's corrected standing block), `docs/master.html` (stamp only —
its content was right throughout), `docs/design-notes.md`, `baselines.json` with the predictions,
and both `.docx` rebuilt via `docs/build_docs.py`.

Written **after**: `docs/state.md`, rewritten, and this report — neither is read by any suite and
`check_de` reads neither, so re-certifying cost **0.51 seconds** over the logs that already existed
rather than another battery.

### Owed, and recorded as owed

- **THE `_run` SAVE-BACKUP PREAMBLE IS STILL THE NEXT COPIED HELPER AND IS STILL NOT TAKEN.** 39
  `_run` bodies in 39 suites, correctly 39 — each is its own driver. **38 of the 39 open with the
  same `_had_save` backup block; 38 swap `Profile.save_path` to a per-suite file** — not the 37
  every document carried before DF — **and 33 of those 38 swap it back.** Same shape as `_spawn`,
  one layer in.
- **THREE ASSERTIONS PASS VACUOUSLY IN `as`, `at` AND `aw`**, left standing because six was the only
  sanctioned fall. Named at their sites and carried in `docs/state.md`.
- **`CLAUDE.md` IS FURTHER OVER CW's TARGET** — 190 KiB of a 5.74 MiB sync = **3.24%**, up from
  3.18%. DG was in the file and did not prune it.
