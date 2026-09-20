# BATCH GY — THE CEILING, THE CONVENTION, AND THE SHAPE GW MISSED

**On `class-merge`, from `ec412f0` (GX). IMPLEMENT ONLY.** Three small things, none of them
player-visible: `CLAUDE.md`'s ceiling is re-derived for the third time, `docs/design-notes.md`'s two
conventions are resolved and the instruction that caused the drift is repaired, and the sweep GW's
shape suggested is run and reported. **No rune, card, kit, engine, pool or node moved and no
magnitude was retuned; no `.gd` file in the tree was edited at all.** `main` is untouched.

---

## §0 — THE BRIEF'S PREMISES, CHECKED

**Twenty-one premises are checkable. Fifteen held, four did not, and two more are true as far as
they go.** One of the four changes which argument this batch records.

**HELD (fifteen).** `CLAUDE.md` read **336.63 KiB** against 340 — 344,706 B, so 3,454 B = **3.37
KiB** of headroom, less than half the 8.10 KiB record. GR measured rune law as the subject batches
read most (**10** of the 38 batch commits since FF, against card law's 7, engine law's 7 and combat
law's 4) and named it the one that would come away cleanly. GX found Sanctity's queue item is the
**status-potency layer**, not its text. `docs/design-notes.md`'s header says *"Newest first"* and
GV's and GW's entries sat below the file's older notes. Nothing asserts on position — the three
suites that read that file (`test_batch_bn`, `test_batch_bs`, `test_batch_ce`) ask only that their
own batch is named. GX's own `slotword` control found a slot arm located by the face it was about to
assert, so a wrong face read as a missing one and the width assertion beside it never ran. GW swept
92 arranging sites, 90 legitimate and two hiding a dead rune. FZ's pricing rule is in
`docs/ways-of-working.md`. `check_fg` reads the ceiling out of the rule. The Shared Hide stays at
100g, the Crown's resistance and Sanctity's potency layer stay queued, and the 52 engine-bound gates
are the next stage. **And GU's `check_eb` did sweep its own shelf and miss a permanent Daze**: §1
paired each lineage's shelf with that lineage's protected names alone, and **Sweeping Strikes** —
which *"keeps a 3-turn Daze permanently refreshed at a net 10 Rage a cast"* (DU §5) — sat in a
zone-boss pool the sweep never read. **That premise earned its place in the brief twice over**: it
is the argument for taking §2's census, and §3's own sweep committed the same fault and had to catch
itself doing it (§3b).

**DID NOT HOLD:**

1. ***"EF forbade that"* — EF's GUARANTEE WAS RETIRED AT GR §2 AND CANNOT BE THE ARGUMENT.** EF §2
   did set *"There are not two files a batch must read"*, but `CLAUDE.md` twenty lines from its own
   top now reads: ***"THE BLOCKQUOTE'S every rule about what the GAME may contain is in this file IS
   RETIRED AT GR §2, BY THE DESIGNER'S RULING — A BATCH THAT MEETS IT MUST NOT REFUSE A SUBJECT
   SPLIT ON ITS STRENGTH."*** **A batch that refused the rune-law split on EF's strength would be
   doing the exact thing that retirement forbids.** What rules rune law out is the test GR left in
   its place — *the subject a batch reads least often, never the largest one* — and rune law is the
   one batches read **most**. **The conclusion is unchanged and its reason is stronger**: the
   measurement rules it out rather than a retired guarantee, and §1 records it that way.
2. ***"DL found the resulting contradiction still live four batches later"* — DL's CONTRADICTION IS
   ABOUT A SECOND COPY, NOT ABOUT TWO FILES.** `CLAUDE.md`: *"WHEN A NEW RULE IS WRITTEN, IT GOES IN
   ONE FILE AND IS NOT SUMMARISED IN THE OTHER. A summary is a second copy of a rule, and a second
   copy is what let this file contradict itself 1900 lines apart after CW's split — DL found that
   contradiction four batches later."* That is a finding about **summarising**, which a split must
   not do; it is not a finding about a batch opening two files. Both rules are live and neither is
   the one the brief cites.
3. ***"GQ found it held a COPY and went red on a correct file"* — THE FINDING IS FU's, AND GR
   ALREADY SETTLED THIS EXACT MISATTRIBUTION.** `CLAUDE.md`: *"since FU §1 it holds no copy of the
   number anywhere — its form check carried the old ceiling as a literal until the ceiling moved and
   took it red."* GR §0's own premise table carries the row: *"`check_fg` reads the ceiling from the
   rule; **GQ** found it held a copy of the last figure — **The finding is FU's**."* **The brief
   inherited GR's brief's error along with GR's sentence.** The instruction it carries is right and
   was followed: §5c confirms the gate follows the rule with no edit, in both directions.
4. ***"+138% needs four buffs, not three"* — IT NEEDS FOUR DAMAGE EFFECTS, THREE OF WHICH ARE
   BUFFS.** GX §2's own words: *"FOUR SEPARATE DAMAGE EFFECTS STANDING ON THE COMPANION AT ONCE — a
   Warcry, an Empower, a Battle Shout and the Pivot. **Three are party buffs and the fourth is
   not**: the Pivot is `tempo`, a two-turn damage status a stance switch grants."* GX's own first
   draft of the changelog and the design notes stated this loosely and GX repaired both; the brief
   restates the loose form. Nothing in this batch turns on it.

**AND ONE QUOTE IS MISATTRIBUTED WITHOUT BEING WRONG.** *"benching has no tell; sitting out does"*
is **GX's report's** wording, not `CLAUDE.md`'s. `CLAUDE.md` says ***"Sitting out is not
benching"*** — the words the brief credits it with are the paraphrase GX §0 used when it reported
the same correction. The distinction itself is in the file and holds. *(The phrase is wrapped
across a line break at `CLAUDE.md:1961`, so a sweep for it on one line reads zero — which is how
this check very nearly went the other way.)*

**AND ONE IS A COUNT THAT IS RIGHT BUT NOT THE WHOLE COUNT.** *"Two consecutive batches appended
against a stated convention"* — GV and GW are two, and they are the two the brief rules on, but
**six** entries were at the foot (GK, GM, GN, GO, GV, GW) and the census in §2 says the number is
larger still.

---

## §1 — THE CEILING IS 410 KiB

**RULED: EE's method, third run, with current inputs.** The number is arithmetic on two measured
quantities; nothing about it is chosen.

| term | value | where it comes from |
|---|---|---|
| FLOOR — a rules-only reading of this file | **336.63 KiB** | GX's reading, 344,706 B. Three audits have read this file for dead weight and retired **nothing** — ED all 43 never-cited blocks, FF all 105 by what each binds, GR all 113 by subject — so a rules-only reading of it *is* its reading. |
| HEADROOM — ten of the largest single-batch growth on record | **81.00 KiB** | ten × **+8.10 KiB**. *A ceiling within one batch's reach fires on whoever writes the big batch rather than on the file's condition* (EE §1). |
| the sum | 336.63 + 81.00 = **417.63 KiB** | |
| **STATED** | **410 KiB**, rounded DOWN | *a ceiling above its own derivation is one nobody trusts.* |

### §1a — The growth figure, re-derived: it did not move, and EZ's still stands

**THE BRIEF SAID BOTH FIGURES ARE OLD. ONE IS; THE OTHER IS STILL THE RECORD.** Measured rather
than quoted: every commit in the branch's 307-commit history, `git cat-file -s <rev>:CLAUDE.md` at
each, aggregated per batch.

| window | the largest single-batch growth in it |
|---|---|
| **EE's own window — the 92 batches since DK** (the window FU §1 names) | **EZ, +8,293 B = 8.0986 KiB → 8.10** |
| since FF, 44 batches | FK, +6,957 B |
| since GR's split, 7 batches | GS, +5,137 B |
| since EA | EZ, +8,293 B |

**FU's +8,287 B is EB's and it IS stale** — GR replaced it with EZ's in `CLAUDE.md` and that is what
the file carries. **EZ's +8,293 B is not stale: it has stood for thirty-two batches and nothing
since has come within 1,336 B of it.** So the headroom term is unchanged and only the floor moved.
*(`main` carries two commits `class-merge` does not — GG and GI, documentation only — and neither
changes `CLAUDE.md` by a byte, so the record is the same on both branches.)*

### §1b — What the third run means, recorded because it is the thing worth recording

**THE METHOD HAS NOW RUN THREE TIMES AND THE CEILING HAS BEEN RE-DERIVED TWICE:** EE 290, FU 340,
GY 410. **Over the same span the split has been taken three times** — EF §2 at the instrument seam,
FF §1 at its residue, GR §2 at the subject seam — **after CW's split before them, which is four.**

**A file split four times whose ceiling has moved twice is a file that grows faster than any
structure contains**, and the two instruments say so from opposite ends:

- **Nothing in it is dead.** Three separate audits looked and retired zero rules between them.
- **Nothing left in it comes away cleanly.** FF measured that there is no third seam of the kind its
  tiebreak takes; GR measured the subject seam and took the only subject batches read rarely.

**So the re-derivation is not a retreat and it is not a repair. It is the only move the procedure
has left that costs less than it buys** — and because every audit finds nothing dead, the floor is
always the file's own reading, so the same arithmetic re-runs whenever it is needed. **That is what
makes it cheap, which is exactly why this batch wrote down what it costs as well as what it buys.**

**THE ROUNDING COST MORE THIS TIME.** EE's 291.49 became 290 and discarded 1.49 KiB; FU's 342.03
became 340 and discarded 2.03; **GY's 417.63 becomes 410 and discards 7.63**, because the derived
figure lands just past a ten. The stated ceiling therefore carries **9.1** worst batches of headroom
where EE's carried 9.8 and FU's 9.75. It is still rounded DOWN, which is the rule — but a later
batch checking the arithmetic would otherwise find a multiple that does not read as *ten* and
wonder, so the file says it.

### §1c — Whether a fourth is expected, and when

**GR's inherited estimate was 5.1 batches at FF's mean and 9.8 at its main half's. GY's is five
times further out.** From GX's reading, 73.37 KiB of headroom:

| at | batches |
|---|---|
| **+3,086 B a batch** — this file's own rate over the six batches since GR's split | **23.8** |
| **+2,383 B a batch** — its rate over the 42 batches since FF, splits and prunes excluded | **31.5** |
| **+8,293 B** — the largest single batch on record | **9.1** |

**ROUGHLY 24 TO 31 BATCHES, AND NO SOONER THAN 9.** After GY's own writing the live headroom is
smaller — `check_fg` read **67.64 KiB** on the shipped tree, which is 22.4 batches at the first rate
— and that live reading belongs in `docs/state.md` and this report rather than in `CLAUDE.md`, which
is the file's own standing rule about not recording its own size.

### §1d — The third option, weighed and rejected in writing

**SPLITTING THE REASONING OUT IS THE OBVIOUS NEXT MOVE AND IT MUST NOT BE TAKEN.** Much of
`CLAUDE.md` is reasoning recorded beside a rule *so it is not re-litigated* rather than rule that
binds. **Measured: 97.04 KiB across 202 `·` sub-bullets, 28.8% of the file** — larger than any
subject seam anyone has measured (GR's card law 85.89 KiB, engine law 41.80, rune law 38.49), so by
size it is the best seam in the file and it is the first thing a batch at the wall will reach for.

**It stays, for three reasons, all of them already rules in this project:**

- **A rule without its reason gets re-litigated.** `CLAUDE.md` says so in its own words and the
  file carries a whole block explaining *why this pool, recorded with the ruling so it is not
  re-litigated*. The reasoning is the thing that stops a batch re-proposing a settled question.
- **A batch only meets the reason by reading it.** Moving it behind a pointer leaves the rule
  standing with its *why* one file away, which is the same as not having written it — the batch
  argues first and follows the pointer afterwards, if at all.
- **It is the half no citation count can see.** *NEVER-QUOTED IS NOT DEAD* — nobody quotes the rule
  they are obeying — so the seam that looks cheapest under a reference count is the one that costs
  the most. ED tested that and retired zero.

**Recorded in the ceiling block so it is not re-proposed.**

### §1e — `check_fg` follows without an edit

Confirmed, and proved in both directions — §5c. The gate parses the bar out of `THE CEILING IS <n>
KiB` (every occurrence must agree) and the headroom term out of the one *largest single-batch growth
on record* sentence. **Both statements of the ceiling were moved and the gate read 410 with no edit
to the gate**, printing *"ceiling 410 KiB = 419840 B; deadline 410 + 8.10 = 418.10 KiB = 428134 B"*,
its row unmoved at 22 / 0.

**AND THE FIRST DRAFT OF THIS EDIT BROKE THE PARSE, WHICH IS WORTH THE LINE.** The re-written
derivation wrapped *"the largest single-batch growth on record is"* onto one line and **+8.10 KiB**
onto the next; the gate's regex does not cross a newline, so it read **zero** growth figures and
would have failed with *"the ceiling's own derivation states 0 DIFFERENT largest-batch figures"*.
Caught by re-running the two regexes over the edited file before anything else, and the sentence was
re-wrapped so the phrase sits whole on one line. **A doc edit whose anchor spans a line break is
invisible to the instrument that reads it.**

---

## §2 — `docs/design-notes.md`: THE MOVE, AND THE INSTRUCTION THAT CAUSED IT

**RULED: NEWEST FIRST WINS.** GV's and GW's entries are at the top, under GX's and above GU's.

### §2a — The move is a permutation, proved

**Both blocks moved verbatim: no byte of either was rewritten.** Proved by multiset rather than by
eye — the file's non-blank lines before and after are the **same 7,826 lines**, and the byte delta
is **−1**, which is one blank line at the old foot. GV's moved block md5s
`6424b6af4f784e1a6e1e70fe31e058cb` and GW's `162943afb018bdf8434ee31e484fd0be`.

**The two moved entries keep the heading form they were written in** (`## Batch GW — <title>`, with
no date) while the block they join uses `## <Title> (Batch XX) — <date>`. **That was not touched**:
the ruling is about position and only the file's header states a convention about it. The form
difference is reported below rather than repaired.

### §2b — What told them to append, and it was not a habit

**SOMETHING DID INSTRUCT IT, IN TWO PLACES, AND BOTH ARE REPAIRED.**

| where | what it said | what it says now |
|---|---|---|
| `CLAUDE.md`, the working agreement's four steps | step (2) *"add an entry to `docs/changelog.html` **(newest first)**"*; step (4) *"**append** a short "why" entry to docs/design-notes.md"* | step (4) *"add a short "why" entry **AT THE TOP** of docs/design-notes.md — newest first, which is that file's own header"* |
| `docs/ways-of-working.md`, the merge conflict table | `docs/changelog.html` → *"**Append-only at the top**"*; `docs/design-notes.md` → *"**Append-only.** Both sides survive."* | *"**Newest first, at the top** — its own header, and `CLAUDE.md`'s step (4). Both sides survive."* |

**THE DEFECT IS THE CONTRAST AND NOT EITHER WORD ALONE.** Both documents state the position for the
changelog in the line immediately next to the one about the design notes, and state no position for
the design notes — so *append* read as *append at the end*, which is also what the word means. **Two
documents said append and one header said top**, and the batch that opens `CLAUDE.md` to find out
what it owes meets the instruction, not the header.

**AND IT IS NOT THE CHANGELOG HABIT.** The brief offered that as a candidate: the changelog genuinely
is append-at-top, so a habit copied from it would have put these entries at the **top**, not the
foot. The candidate is ruled out by the direction of the error.

**SO THE FIX IS A RULE EDIT AND NOT ONLY A CORRECTION.** Moving the entries without changing the
words would have bought exactly one batch of order.

### §2c — How many OTHER entries are out of order: **73**

**The file is not a drifted newest-first list. It is TWO ordered blocks with opposite conventions**,
and the census says so from the ordering rather than from reading:

| | |
|---|---|
| `## ` entries in the file (after GY's) | **186** — 182 carrying a batch label, 4 carrying none |
| **the top block**, lines 1–5120 | **111 entries, newest-first**, with exactly **one** inversion inside it: *A node is a row now (Batch AK)* sits **below** *Rows should ask a question (Batch AJ)* |
| **the tail block**, lines 5121–end | **75 entries, OLDEST-first** — a second, chronological log running Batch V → GO. 70 of its 72 labelled adjacencies ascend, and **all 72 are newer than the top block's oldest entry** |
| **MINIMUM entries that must move** to make the whole file newest-first | **73** |

**73 IS THE ANSWER TO THE BRIEF'S QUESTION.** It is derived twice and the two agree: the minimum-move
figure was **75** before this batch and is **73** after it, which is exactly GV and GW leaving; and
72 tail entries + 1 top-block inversion = 73. **Nothing was repaired**: moving 73 entries is a file
rewrite, not a batch's incidental edit, and nothing asserts on position so it is free whenever it is
ruled.

**THE FOUR UNLABELLED ENTRIES** are *Berserker rework* (at the foot of the top block, where its date
puts it) and three in the tail: *the difficulty question, closed*, *the Warden softlock, and a lying
chip*, and *The duplicate rune triple*. They are excluded from the ordering figures because a label
is what the ordering is computed from, and they are named here so the exclusion is visible.

---

## §3 — A GATE THAT FINDS ITS SUBJECT BY THE PROPERTY UNDER TEST

**REPORT ONLY. NOTHING FOUND HERE IS REPAIRED, AND FZ's PRICING RULE IS WHY:** repairing them is a
change to three gates that each need their own two-armed control, which is its own batch.

### §3a — The shape, and how it differs from GW's

**GW swept for a gate that ARRANGES the state it tests** — a gate that writes its own precondition
cannot fail when the path that should write it is broken. **This is a gate that FINDS its subject by
the state it tests**, which fails the same way and looks nothing like it: the subject is *selected*
by the value the assertion is about, so a subject carrying the **wrong** value is not selected at
all. GX's own formulation, from the control that found it: **an arm that locates a thing by the
value it is about to assert can only ever fail by absence.**

**THE SWEEP FOUND THAT IS TRUE OF HALF THE INSTANCES AND TOO KIND ABOUT THE OTHER HALF.** It holds
where the assertion is about a subject that should be PRESENT — the arm reds, names the wrong cause,
and everything guarded behind the locate is skipped. **Where the assertion is that the subject is
ABSENT — a count of zero, a list that must be empty, a maximum that must not be reached — the wrong
value makes the filter match nothing and the arm does not fail at all.** Two of this sweep's four
findings are in that second direction, and they are the ones worth the batch: a red naming the wrong
cause is still a red, and a silent pass reads exactly like a clean run (`check_dv`, and GX's own
`slotword`).

### §3b — The population, and the count

**384 SITES ACROSS 121 FILES.** The population is **every `.gd` the battery launches** — the 115 in
`run_battery.sh`'s `SUITES` and `GATES`, read off the script rather than listed, plus the four it
launches outside those arrays (`check_de`, `check_map_screen`, `check_ct_map`, `test_run_harness`)
— **and the two fixtures whose locators every one of them calls** (`gate_fixture`,
`suite_fixture`). Comments are stripped first (`check_ds`'s ruling) with both quote kinds honoured,
so prose describing a locate is not a locate.

**THAT IS GU's SHAPE, COMMITTED BY THE SWEEP THAT WAS LOOKING FOR IT.** `check_eb` §1 walked each
lineage's shelf and missed a card sitting in a boss pool; this sweep walked `check_gw`'s two arrays
and missed a target sitting in a third. **A population copied from a neighbouring instrument
inherits its boundary, and the boundary is rarely a fact about the subject** — `check_gw`'s is an
array in a shell script, `check_eb`'s was a resolver call.

**AND THE LOCATOR SET IS DERIVED RATHER THAN LISTED**, which is the third thing the sweep had to
learn. The first pass carried a hand-written list of selector names and it was wrong twice over: it
missed `check_gt`'s own `_buttons_from` and it missed a whole family. A locator is now **any
function that takes a needle, compares or searches with it, and returns what matched** — 151 of
them across the 121 files — plus the fixtures' shared four. **The derivation is deliberately broad**:
the finding rests on the classification, not on the denominator, and a wide population with a strict
classification is the safer way round.

**THE FIRST PASS SWEPT ONLY THE 115 AND MISSED A REAL ONE.** `check_gw` §2's own population is
`SUITES` + `GATES`, and copying it left `check_ct_map` — which the runner launches from a separate
array because it is a scene rather than a script — outside the sweep. **One of the four findings
below lives in it.** The four root gates `run_battery.sh` names nowhere (`check_ck_width`,
`check_cu`, `check_cv`, `check_dn`) are outside the battery and are outside this sweep; that is
stated rather than implied.

| family | what it is | sites |
|---|---|---|
| **A** | a subject located into a variable by a locator call, with at least one `ok()` reachable only when the locate succeeded — an early-out guard, or a positive `if X != null:` block | **95** |
| **B** | a loop that filters a collection by a property and tallies, collects or captures, with the assertion made on the tally after the loop | **283** |
| **C** | a lambda `filter` / `any` / `all` whose predicate reads a drawn value, whose result is then asserted on (following one rename) | **6** |

**362 OF THE 384 KEY ON SOMETHING STABLE and are the legitimate case** — a signal binding
(`Gate.bound_button`, `check_gx`'s own `_slot_buttons`), a z-index (`Gate.overlay`), an ability's
`display_name`, a rune id, a field name, a file path, a function signature, a dict key, a document
heading.

**TWENTY-TWO KEY ON A VALUE THE SCREEN RENDERS** — a `Button.text`, a `Label`'s text, a
`tooltip_text` — and those twenty-two are where the shape can live. **Eighteen of the twenty-two
are still legitimate**, because the needle is a name the widget draws in *every* arm (`"Close"`, a
rune's own name, an engine's name, `"Sell +"`, a bullet prefix) while the assertion is about
something else entirely, usually geometry or a count — and each has a paired arm that reds when the
name itself moves. **Four are the shape, and two of those four do not fail at all.**

### §3c — The four, and what each would miss

**THE SHAPE HAS TWO DIRECTIONS AND THE SECOND IS THE DANGEROUS ONE.** Where the assertion is about
a PRESENT subject, a wrong value reads as a missing one: the arm reds, but it names the wrong cause
and the assertions guarded behind it never run. Where the assertion is that the subject is ABSENT —
a count of zero, a list that must be empty, a maximum that must not be reached — a wrong value
makes the filter match nothing, and **the arm passes**.

**FAILS BY ABSENCE INSTEAD OF BY MEASUREMENT (two):**

| site | the key it locates by | what it would miss |
|---|---|---|
| **`check_gx.gd:412`** `_s3_the_three_surfaces` — `_label_with(ov, "✦ %s — %s" % [rname, GT_HEAD])` | **`GT_HEAD`, the tell's own first line** — the sentence the arm exists to check | A pouch row carrying a **third** text — neither the tell nor the rune's own rule — reads identically to a row that is missing: the arm prints *"the pouch row does not say the rune is sitting out"* without saying what it **did** say, and the three exactness assertions beside it (the row equals the flattened sentence; it names the engine rune; it carries no raw line break) **never execute**. That is the class of defect GX's own first draft committed one surface over — *"a fourth phrasing"* of the same two facts, in the battle log rather than in the pouch, and GX caught it by reading rather than by an arm. **Mitigated, not cured**: the `ordinary` locate beside it separates "shows the tell" from "shows its own rule", so only a third text collapses. |
| **`check_gx.gd:769`** `_s4b_the_panels_worst_case` — `_label_with(ov, "✦ %s — %s" % [String(nm), GT_HEAD])` | **`GT_HEAD` again** | This is the **layout** arm: it asserts the tell is drawn inside the scroller and at size 12. A reworded tell is not found, the arm reports *"%s is not told it sits out"*, and **both layout assertions never run** — so a batch that reworded the sentence and overflowed GT's panel would be told only about the wording. **A stable alternative exists and is used 264 lines earlier**: `check_gx.gd:505` finds the hero sheet's row by `"✦ %s — " % rname`, the prefix drawn in both arms, and asserts the text separately. |

**DOES NOT FAIL AT ALL (two):**

| site | the key it locates by | what it would miss |
|---|---|---|
| **`test_batch_as.gd:900`** `_live_boss` — `slot.get_child(0).tooltip_text.begins_with(boss.unit_name)` | **the turn-bar slot's rendered tooltip** | The assertion is `boss_slots == 0` — *a held BOSS is off the turn bar too*. **If the slot's tooltip ever stops beginning with the unit's name, every slot fails the filter, the count is 0, and the arm PASSES on a bar still full of the boss.** **The cure is twelve lines down in its own file**: `_live_turn_bar` runs the identical filter and asserts `seen_before > 0` before it asserts `seen_after == 0`, so a tooltip reformat reds there — but that liveness arm is in a different function and does not reach this one. |
| **`check_ct_map.gd:96`** `_process` — `n is Label and String(n.text).begins_with("THE DRAFT")` | **the shop's draft header, by its wording** | `draft_top` is initialised to **1e9** and lowered only by a Label that matches; the assertion is `lowest <= draft_top` — *supplies end above the draft header*. **Reword the header and nothing matches, `draft_top` stays at a billion, and the collision check passes on a shop whose supply column runs straight through the header** — which is the exact defect this arm was written for (*"at the old 56 pitch row 8 ended at y=600, straight through the DRAFT header at 452"*). The `print` beside it would read *"draft at y=1000000000"* and nothing asserts on it. **This is the one the first pass missed**, because it lives in the file the runner launches from a separate array. |

**THE CLOSEST NEAR-MISS, NAMED SO THE LINE BETWEEN THEM IS VISIBLE.** `check_gq.gd:489` filters the
class-selection screen's labels by the passive's **full rendered line** and then asserts
`pl.size() == 1 and pl[0].position.y == 110.0 and ...` — *the class passive stands where it stood*.
Reword the passive and the filter matches nothing, so the arm **reds with a message about
position**. It is not one of the four because **nothing is skipped**: the locate and the geometry
are one compound `ok()`, which still fires. What it loses is the *cause*, not the check. **The two
sites beside it are the model for doing this right** — `check_gq.gd:416` and `:417` PARTITION the
card's labels (`text == name` and `text != name`) rather than filtering one side out, so a wrong
heading moves a label from one array to the other and the count arm reds carrying both sizes.

### §3d — The sweep was armed before it was trusted

**TWO ARMS ON GX's OWN DEFECT, WHICH IS THE ONE INSTANCE THE PROJECT ALREADY KNOWS IS REAL.** GX's
pre-repair slot arm was put back into a scratch copy of `check_gx.gd` in the form GX's report records
— `var face: Button = _button(mp, SLOT_MARK + rname)` — against HEAD's repaired form, which finds
every slot by the door it opens (`_open_rune_panel(seat)`) and only then narrows by the rune's bare
name.

| arm | drawn-key guarded locates in the file | naming `SLOT_MARK` |
|---|---|---|
| GX's **pre-repair** slot arm put back | **6** | **1** — *`var face: Button = _button(mp, SLOT_MARK + rname)`* |
| HEAD's **repaired** file | **5** | **0** |

**The injection is the historical defect rather than an invented one**, and the discriminator the
sweep turns on — a binding versus a face — is the discriminator GX's repair turned on.

### §3e — What the sweep costs, priced

**A script, not a battery.** The population is read statically off 115 files; the run is under a
second and it was re-run four times while its two families were widened. **The repair is the
expensive half and it is not taken**: four arms across three gates and a suite, each owing a
two-armed control of its own on a live drive — and two of the four owe a liveness arm rather than a
re-point, which is a different repair again. That is the shape of a batch rather than of a section.

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **No rune, engine, card, kit, pool or node changes, and no magnitude is retuned.** No `.gd` file
  in the tree was edited by this batch, and no `.tscn`, `.json` game data or scene either.
- **The Shared Hide stays at 100g**, ruled at GX and judged in play.
- **The Crown's Break and freeze resistance, Sanctity's status-potency layer and GQ's two
  class-selection text rulings stay queued.** The 52 engine-bound gates are the next stage.
- **§3 repairs nothing**, and the 73 out-of-order design-notes entries are reported and not moved.
- **No new gate.** The brief named the files that move and `run_battery.sh` was not among them;
  §1's claim is asserted by `check_fg`, which already reads the ceiling out of the rule, and §2's is
  a rule with no instrument — which is itself the finding, recorded below.
- **`docs/master.html` is not edited and its stamp is not bumped**, because nothing a player meets
  changed. **The brief's *"and the stamp"* is read as `docs/state.md`'s *Last rewritten*** — FU §0's
  reading of the same phrase in the same position, named here so the reading is visible.
- **GR's RULING 1 IS NOT TAKEN WITH GR's RULING 2.** `docs/combat-rules.md` still has no stated
  ceiling, and EE's method on its own record gives it 70 KiB (GR §5c). It sits beside this batch's
  subject and it is a different file and a different ruling; it stays queued, unmoved.

---

## §5 — VERIFICATION

### §5a — The acceptance run

**121 TARGETS ON A TREE FROZEN BY md5 BEFORE AND AFTER, AND 598 OF THE 599 FILES ARE BYTE-IDENTICAL
ACROSS THE RUN.** The one that differs is `docs/reports/GY.md` — this report, which is written after
the run by rule and which **no target opens** (§5e) — so every count below is one tree's reading.

| | |
|---|---|
| suites | **46 of 46 clean** — zero fails, zero throws, zero FAIL lines |
| gates | **70 of 72 clean**, the two standing sanctioned reds being the other two |
| the run harness | **22 / 382 / 8**, throws=0, all three gates PASS |
| the scene runs | `check_map_screen` complete, `check_ct_map` **83 / 0** |
| `check_parse` | **195 / 0** |
| `check_de`, the count differ | **501 checks / 0 failures / 0 NOTICES** |
| the player's four saves | byte-identical to the backup taken before any Godot process ran |
| `Parse Error` / `SCRIPT ERROR` | **none in any of the 121 logs**, grepped out of the logs rather than read off a tally or an exit code |
| targets named in `.ran` vs logs written | **121 and 121** — no target failed to launch |

**NOT ONE BASELINE MOVED, AND THE DIFFER SAYS SO ITSELF.** `check_de` read **zero notices** as well
as zero failures, which is the reading that means no count rose and none fell. `baselines.json` is
therefore untouched: *a baseline moves only in the batch that causes the movement.* **This is the
cleanest possible answer for a batch that edited no `.gd` file**, and it is the answer the brief's
file list anticipated but did not get to need.

**EVERY NEIGHBOUR READS EXACTLY WHAT GX RECORDED**: `check_gt` **3157 / 0**, `check_gu` **317 / 0**,
`check_gv` **877 / 0**, `check_gw` **76 / 0**, `check_gx` **1130 / 0**, `check_ez` **114 / 0**,
`check_fg` **22 / 0**, `check_ec` **24 / 0**, `check_es` **57 / 0**, `check_ff` **68 / 0**,
`check_fr` **25 / 0**.

### §5a(i) — The two sanctioned reds, diffed against an isolated rebuild of `ec412f0`

**BOTH ARE BYTE-IDENTICAL TO HEAD's.** The rebuild is an `rsync` of the tree with
`git archive ec412f0 | tar -x` over it — so it carries the ignored files and the `.godot` cache a
checkout would not — with `config/name` renamed first and this batch's untracked report removed.

| gate | new tree | HEAD rebuild | the FAIL text |
|---|---|---|---|
| `check_cm_live` | **13 / 4** | **13 / 4** | four lines, **diff empty** |
| `check_gj` | **70 / 1** | **70 / 1** | *"§4: the card says +158 gold and the purse moved 178"*, **diff empty** |

**THE REBUILD WAS RUN EVEN THOUGH THE ANSWER IS DERIVABLE**, and the reason is worth a line: this
batch edited no `.gd`, no `.tscn` and no `data/` file, and neither gate opens a document, so nothing
it touched could reach either reading. **A derivation that says a control is unnecessary is the
argument every skipped control is skipped on**, so the control was run and the diffs are the
evidence rather than the reasoning.

### §5b — What was run BEFORE the acceptance run, and what was not edited

**NO GATE AND NO SUITE WAS EDITED BY THIS BATCH, AND NO `.gd` FILE IN THE TREE WAS EDITED AT ALL.**
So *"run the unmodified gates against the new tree before editing any of them"* is the whole of the
verification here rather than a preliminary to a re-point, and `run_battery.sh` and `baselines.json`
gained no row.

**THE DOC AND SOURCE-SCANNING GATES WERE RUN AGAINST THE NEW TREE FIRST, THREE TIMES** — once after
each of the three document passes — so a two-hour battery was not spent discovering a doc typo.
**All fourteen read identically on all three passes**: `check_parse` 195 / 0, `check_fg` 22 / 0,
`check_ec` 24 / 0, `check_ed` 18 / 0, `check_eh` 156 / 0, `check_ek` 47 / 0, `check_es` 57 / 0,
`check_ff` 68 / 0, `check_fr` 25 / 0, `check_da` 43 / 0, `check_ds` 57 / 0, `check_dv` 83 / 0,
`check_dw` 35 / 0, `test_batch_bx` 157 / 0.

**AND `pin-manifest.json` WAS RE-DERIVED AND CAME BACK BYTE-IDENTICAL** — 1,494 pins, the same
`{source 1153, other 96, document 245}` and the same residency histogram. It is derived from gate
sources and this batch edited none, so that is the expected answer; it was run rather than assumed
because the manifest is the one file the rules say must never be hand-merged.

### §5c — The controls: five injections, each naming its own defect, and one positive arm

**EVERY COPY IS AN `rsync` OF THE FROZEN TREE WITH `config/name` RENAMED FIRST**, so its `user://`
can never reach the player's saves, and each was run on its own.

**THE CEILING, FOUR ARMS.** The claim under test is *`check_fg` reads the ceiling out of the rule
and holds no copy of it* — which is the brief's §1 instruction, and which GR §0 had to correct a
misattribution about. It is proved in both directions rather than one:

| control | what was injected | tally | the FAIL line, or the reading |
|---|---|---|---|
| `disagree` | the blockquote's ceiling put back to 340 while the heading reads 410 | **18 / 1** | *"CLAUDE.md states 2 DIFFERENT ceilings [410.0, 340.0] — the copies disagree"* |
| `low` | the stated ceiling lowered to 300 KiB | **22 / 1** | the WARNING prints, then *"CLAUDE.md is 342.36 KiB, past its ceiling by more than the largest single batch on record (8.10 KiB) — the split is overdue by a batch"* |
| `grow` | the derivation's growth sentence reworded (*"the biggest single-batch growth ever recorded"*) | **18 / 1** | *"the ceiling's own derivation states 0 DIFFERENT largest-batch figures []"* |
| **`raise`** — **the positive arm** | the stated ceiling raised to **999 KiB** | **22 / 0** | *"ceiling 999 KiB = 1022976 B; deadline 999 + 8.10 = 1007.10 KiB = 1031270 B … under the ceiling with 656.64 KiB of headroom"* |

**`raise` IS THE ARM THAT MATTERS AND IT IS THE ONE A DELETION CONTROL CANNOT GIVE YOU.** Three
controls that all red prove only that the gate is upset by an edit. **The fourth proves the gate
FOLLOWS the number** — it computed a bar and a deadline off 999 that it can have got from nowhere
but the rule, and passed. Together they say the gate reads the rule in both directions and carries
no literal of either figure.

**THE DESIGN NOTES, TWO ARMS.** The report's claim is a NEGATIVE — *nothing asserts on an entry's
position* — and an absence is only a measurement if the thing that would have caught it is shown to
be alive (DS §1). So the file's three readers were run against a copy with **their own needles
removed** (`Batch BS` → `Batch B_S`, and the same for BN and CE, six replacements in all), beside
the same copy unedited:

| arm | `test_batch_bn` | `test_batch_bs` | `test_batch_ce` |
|---|---|---|---|
| the file as shipped, GV and GW moved to the top | **80 / 0** | **246 / 0** | **942 / 0** |
| the same file with each suite's own needle spelled differently | **80 / 1** | **246 / 1** | **942 / 1** |

Each names its own needle: *"design-notes.md carries a Batch BN entry"*, *"§5: design-notes has a
Batch BS entry"*, *"design-notes.md carries a why entry"*. **So the three suites DO read the file
and DO bite on its contents** — and they still passed with
the two entries moved from the foot to the top, which is the measurement behind *nothing asserts on
position*. The absence is now a reading rather than a silence.

### §5d — The sweep was armed before it was trusted

**TWO ARMS ON GX's OWN DEFECT, WHICH IS THE ONE INSTANCE OF THIS SHAPE THE PROJECT ALREADY KNOWS IS
REAL.** GX's pre-repair slot arm was put back into a scratch copy of `check_gx.gd` in the form GX's
report records — `var face: Button = _button(mp, SLOT_MARK + rname)` — against HEAD's repaired form,
which finds every slot by the door it opens (`_open_rune_panel(seat)`) and only then narrows by the
rune's bare name.

| arm | drawn-key guarded locates in the file | naming `SLOT_MARK` |
|---|---|---|
| GX's **pre-repair** slot arm put back | **6** | **1** — *`var face: Button = _button(mp, SLOT_MARK + rname)`* |
| HEAD's **repaired** file | **5** | **0** |

**The injection is the historical defect rather than an invented one**, and the discriminator the
sweep turns on — a binding versus a face — is the discriminator GX's repair turned on.

### §5e — The post-run documents, and the population that had to be re-run

**`docs/state.md` AND THIS REPORT ARE WRITTEN AFTER THE VERIFICATION RUN BY RULE** — `check_es`'s
own comment says so, and `state.md` holds the run's figures. **The re-run population is derived
rather than guessed**, by grepping every battery target for the `res://` path it opens:

| document | targets that OPEN it | when it was written |
|---|---|---|
| `CLAUDE.md` | **31** — 17 suites and 14 gates | **before** the run |
| `docs/changelog.html` | **17** | **before** the run |
| `docs/design-notes.md` | **4** (`check_ec`, `test_batch_bn`, `test_batch_bs`, `test_batch_ce`) | **before** the run |
| `docs/ways-of-working.md` | **1** (`check_fr`) | **before** the run |
| `docs/state.md` | **1** (`check_es`) | after |
| `docs/reports/…` | **0** — nothing opens that directory | after |
| `baselines.json` | 1 (`check_de`) | not written at all |

**SO THE RE-RUN POPULATION IS ONE TARGET**, `check_es`, and it is re-run against the written
`state.md` below. **Every other moved document was written BEFORE the freeze and is inside the
acceptance run**, which is a better sequencing than GX's: GX wrote its changelog and design-notes
entries after its run and owed 34 targets a re-run; this batch owes one.

**AND THE BRIEF's *"~35 suites assert against `CLAUDE.md`"* IS HIGH IN BOTH DIRECTIONS.** Sixty-six
`.gd` files in the tree NAME `CLAUDE.md`, but **31 targets actually open it — 17 suites and 14
gates.** The rest name it in a comment. This is GX's `master.html` measurement run in the other
direction: a pre-pass that counts mentions over-states as easily as it under-states, and only the
`res://` path is the reader.

### §5f — The literal sweep over every document edit

**EVERY STRING LITERAL OF FOUR CHARACTERS OR MORE IN ALL 115 BATTERY TARGETS** was collected with
comments stripped, and matched against the eight tracked documents before the first edit and after
each document pass — four passes in all, because the documents were edited three times before the
run and once after it.

| pass | LOST | GAINED | MOVED |
|---|---|---|---|
| after each of the three **pre-run** passes | **0** | **0** | **0** |
| after the **post-run** pass (`state.md` rewritten, this report written) | **0** | **1** | **12** |

**THE THIRTEEN ARE ALL `docs/state.md` AND NONE OF THEM CAN CHANGE A READING.** Twelve moved only
into or out of that file — `scripts/battle.gd`, `scripts/map_screen.gd`, `engine out` and the rest
left with GX's WHERE block, `positive` and `result` arrived with GY's — and the one GAINED,
`turn_bar`, belongs to `test_batch_as`, which uses it as `scene.get("turn_bar")`, a runtime property
name and not a document assertion. **`docs/state.md` is opened by exactly one target**, `check_es`,
which is not an owner of any of the thirteen and which sweeps for a claim pattern rather than for
these strings. **It was re-run against the written file and read 57 / 0**, which is the empirical
half of the same answer. **A GAINED literal is the dangerous direction — it can flip a red to a
green — so it is named rather than counted.**

## §6 — FOUND AT GY AND NOT FIXED

- **`docs/changelog.html` CROSSED ITS THRESHOLD ON THIS BATCH'S OWN ENTRY** — 400,021 B against
  400,000, and `check_fg` §1 printed its CEILING WARNING on the acceptance run while still reading
  22 / 0. That is the gate working: the file WITHOUT this entry is 396,730 B, so the red does not
  land on a batch with no warning in front of it. **The cut is owed at the next batch boundary.**
  The entry was **not trimmed to clear 21 bytes** — at 3,291 B it sits mid-range against the last
  seven (2,871–4,838 B), and shrinking it would be writing to the instrument. Ruling 1.
- **THE §2 REPAIR IS A RULE WITH NO INSTRUMENT**, which is why the drift lasted six batches with
  every battery green. §5c's control makes that a measurement rather than a silence: the three
  suites DO read the file and DO bite, and they passed with the entries moved. **A gate is
  buildable and was not built** — an order assertion over the whole file would red on the 75-entry
  tail this batch deliberately left standing, so ruling 2 decides whether that arm can exist.
- **THE SWEEP'S FIRST POPULATION WAS `check_gw` §2's AND IT MISSED ONE OF THE FOUR FINDINGS** (§3b),
  and **its locator set was hand-listed until the last pass**, which missed a whole family. Three
  widenings: 109 → 289 → 384 sites, and 3 → 4 findings. **Each widening moved both the count and
  the findings**, which is the argument for deriving a population instead of copying one.
- **A DOC EDIT WHOSE ANCHOR SPANNED A LINE BREAK BROKE `check_fg`'s PARSE, AND WAS CAUGHT BEFORE THE
  RUN** (§1e). The gate asserts that the two statements of a bar AGREE; nothing asserts that either
  is on one line, and its regex does not cross a newline.
- **`check_gv` COMPLETES PAST ITS WATCHDOG's NOMINAL BOUND AND IS SAVED ONLY BY THE WATCHDOG's OWN
  DRIFT.** It was observed in `ps` still running at **4 minutes 17 seconds** of elapsed time against
  a **240-second** bound, and came back **877 / 0** shortly after; `check_gp` was observed at 3:26
  on the same bound. **The bound is not wall time**: `run_one` counts `sleep 2` iterations, so its
  clock runs slow by whatever each iteration costs, and that drift is the only reason these two are
  not already TIMEOUTs. *(The figures are `ps` readings taken during the run, not log arithmetic —
  a log's mtime delta carries the previous target's runtime with it.)* **A gate that times out reads exactly like a
  hang** (CP's own taxonomy), so the next batch that adds a frame to `check_gv` will get a hang
  report for a slow gate. Reported, not repaired: the fix is a per-target `TMO` row, which is a
  one-line edit to a file this batch had no other reason to touch.
- **FOUR ISOLATED COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata` — "Dawn of Decay GY
  disagree", "GY low", "GY grow", "GY raise" — plus the HEAD rebuild's and the two design-notes
  arms'. **Each was renamed before anything ran in it**, so its `user://` could not reach the
  player's saves, and each holds only a `logs` directory. **There are 95 such folders now**, GX's
  nine among them; nothing prunes them and each batch adds a few.
- **THE BRIEF'S FOUR PREMISES THAT DID NOT HOLD** are in §0 and none changed what was built; the
  first strengthens the argument §1 records rather than weakening it.
- **`check_fg`'s OWN COMMENTS STILL NARRATE THE MOVE TO 340** (`check_fg.gd:46`, `:181`). True as
  history — it is FU's event — but they are the only remaining `340`s in the instrument layer.
  Left as written: a comment is not a copy, and the gate holds no literal of the number it reads.
- **GR's RULING 1 IS STILL OWED.** `docs/combat-rules.md` has no stated ceiling; EE's method on its
  own record gives it 70 KiB (GR §5c). A different file and a different ruling.
