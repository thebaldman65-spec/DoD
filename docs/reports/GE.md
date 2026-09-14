# Batch GE — Long Draw's miss costs Focus, and no permanent layer is spec-specific

*Branch `class-merge`, from `68d5a8f` (GC), equal to `origin/class-merge` by `git ls-remote` before anything moved.
`main` is untouched.*

## NEEDS A RULING

1. **LONG DRAW IS STILL A GAIN AT EVERY STAGE ON `check_cs`'s OWN MODEL. THE DRAIN MADE THE GAIN SMALLER; IT DID NOT
   MAKE THE RUNE A TRADE.** With the rune held, a missed press now drains 16 Focus, as ruled. Priced in Focus a basic,
   the rune against the bare chain, it is worth **+7.98 / +7.86 / +7.82 / +6.50** at the four stages, against
   **+8.22 / +8.06 / +8.01 / +7.14** before the drain (§1b). On that model a chain breaks 1.2–4.0% of the time, so the
   drain costs 0.19–0.64 Focus a basic while the added press pays about eight. **The sim bot prices the same rune the
   other way**: it lands a flat 85% of presses, and on its roll the rune with the drain is a loss at every stage
   (−1.21 / −3.43 / −5.31 / −6.92). The two models disagree because they disagree about the player, and the model's one
   assumption, the timing SD, decides it (§1b). **Which model the rune answers to is the designer's.** Rune content is
   written with the designer, so nothing moved beyond the ruled 16 and no alternative is offered.
2. **THE CARD'S NEW WORDS ARE PROPOSED FOR THE DESIGNER TO CONFIRM:** *"His basic attack runs one EXTRA press at every
   stage — but a missed press drains 16 Focus."* The first clause is the designer's own and is byte-unchanged,
   pronoun included (the live pool uses them; `docs/text-standard.html` §4.1 would not, and that is older than this
   batch). `check_ez` §5 reads the number off `SS_SEQ_MISS_DRAIN`, so a confirmed rewording that keeps *"drains 16
   Focus"* needs no gate edit.

## THE SHORT VERSION

- **§1 — WITH THE LONG DRAW HELD, A MISSED PRESS DRAINS 16 FOCUS.** `SS_SEQ_MISS_DRAIN` is written as twice
  `SS_SEQ_FOCUS_PER_PRESS`; the drain is decided in `_pay_sequence_focus`, where partial credit is, as ONE net
  `_gain_focus` call; the floor at 0 is `_gain_focus`'s own and needed no new code. The bar and the bot record the miss
  where it happens, so a cancel is not a miss. The card and the three co-sites moved with it.
- **§1 — WHAT IT IS WORTH:** still a gain at every stage on the player model, a loss at every stage on the bot's (above).
- **§2 — NO PERMANENT LAYER IS SPEC-SPECIFIC, AND THE RULE SAYS SO.** The EN §4 rule sends an effect that must know the
  spec to the RUNES. A sweep of both files found the old claim in five places, and all five are corrected; the
  `master.html` paragraph's four other wrong claims went with it.
- **§3 — NOT DONE, AS RULED.**
- **VERIFICATION** is below, written after the acceptance run.

## §0 — THE BRIEF'S PREMISES

Each was checked against the repo, the reports and the code before anything was edited.

| # | Premise | Verdict | What the record says |
|---|---|---|---|
| 1 | *"On `class-merge`."* | **HELD** | HEAD was `68d5a8f` (GC), equal to `origin/class-merge` by `git ls-remote` before anything moved |
| 2 | *"GC measured that Long Draw is a GAIN at every stage including 150+"* | **THE FIGURES HOLD; THE ATTRIBUTION DOES NOT** | `docs/reports/GC.md` prices the card only as a landing rate (§2b), and no Focus figure for the rune is in it. The figures reproduce on `check_cs`'s model: at 150+ the fifth press pays 8 × 0.960 = 7.68 and the full-chain bonus, missed 2.8 points more often, costs 20 × 0.028 = 0.56, net +7.14; below 150 the gain is +8.0 to +8.2 |
| 3 | *"the chain pays 8 Focus a press plus 20 for a full chain"* | **HELD** | `SS_SEQ_FOCUS_PER_PRESS` 8 and `SS_SEQ_FULL_BONUS` 20; `check_cs` §1 pins both |
| 4 | *"Neither of the two fixes previously proposed makes it a trade; the second only makes the gain smaller"* | **HELD** | The card's words move nothing. The added press taking no widening at any stage is worth +6.34 / +6.99 / +7.11 / +7.14 on the same model (§1b) |
| 5 | *"The chain pays 8 a press landed (`battle.gd:23424`)"* | **HELD** | `var gain := landed * SS_SEQ_FOCUS_PER_PRESS`, HEAD's line 23424, in `_pay_sequence_focus` |
| 6 | *"the drain belongs where partial credit is already decided"* | **HELD** | `_pay_sequence_focus` is the game's one reader of the sequence record's `landed` and `full`; only `check_cs` and `check_fh` §7 read it besides, and both are instruments |
| 7 | *"Floor it at zero … `_gain_focus` is the only way in — `battle.gd` says so at the site, and the conversion-point signature and the deepest-Focus ledger all read through it"* | **HELD, AND THE FLOOR ALREADY EXISTED** | The comment above `_pay_sequence_focus` says it, and the `lethal_aim` signature and `focus_deepest` both sit inside `_gain_focus`. **`_gain_focus` already wrote `maxi(second_resource + amount, 0)`**, so a drain routed through it is floored with no new code. *"The only way in"* is the only way UP: the target-switch dump, One Shot's and Coup de Grâce's spend, Metronome's remainder and the Spray cap write the field directly, and each is a halving, a zeroing, a remainder or a cap, so none can take it below zero either |
| 8 | *"Its current words — 'the added press buys no widening, so the sequence is harder to hold'"* | **HELD** | `data/runes.json`, `long_draw_press` |
| 9 | *"the comment at `battle.gd:23374`"* | **HELD** | *"AND THIS CLAMP IS THE LONG DRAW'S ENTIRE COST"*, HEAD's line 23374 |
| 10 | *"`check_ez` §5's 'the cost is real'"* | **HELD** | HEAD's `check_ez.gd:774`, the message of the fifth-press arm |
| 11 | *"the sentence GC added to the sequence block in `CLAUDE.md`"* | **HELD** | *"… which is the rune's cost"*, HEAD's line 815; `git log -S` puts it at `68d5a8f` |
| 12 | *"`check_ez` §5 asserts the rune's payload and its text names the old cost"* | **ITS TEXT, AND ITS FIELD RATHER THAN ITS PAYLOAD** | §5 drives the rune's field (`rune_long_draw_presses`) through `_sequence_presses` and the profile; §4 is what lands all 60 payloads. The arm's message named the old cost |
| 13 | *"`CLAUDE.md:1547` still says an effect that must know which spec the hero is, is a TALENT"* | **HELD** | HEAD's lines 1547–1548 |
| 14 | *"Since FX there is one tree every class buys and every node must pay every class"* | **HELD** | `CLAUDE.md`'s FX block; `check_fx` §4 drives every node on all four classes |
| 15 | Runes *"are bought per hero and per run and are the only layer that can still be tied to a spec"* | **HELD, AMONG THE THREE LAYERS THE RULE SORTS** | Every rune declares a `scope` of a spec or a class, and one hero buys it for one run; a relic is party-wide and chosen before specs exist; a talent keys to the class. Draft cards are spec-keyed too, but they are what a rune modifies rather than a layer the rule sorts |
| 16 | *"`master.html` does NOT carry that sentence — GC corrected my brief"* | **THE TREE AGREES; THE ATTRIBUTION IS BACKWARDS** | `master.html` never carried the 1547 sentence: it carried `CLAUDE.md`'s HEADING in other words, at 2671–2672. `GC.md`'s own words are *"`docs/master.html`'s relic paragraph carries the same sentence"*, and GD's brief repeated them |
| 17 | *"It makes the same claim in different words at 2672"* | **HELD** | *"a talent changes what a SPEC does inside a fight"* |
| 18 | *"THE SAME PARAGRAPH LISTS 'REST NODES' AS A PLACE RELICS ARE READ, SEVEN LINES BEFORE SAYING REST NODES NO LONGER EXIST"* | **HELD, AND THE PARAGRAPH HELD THREE MORE** | Line 2674 against 2681–2682. Also false in it: *"every hook below is read at exactly one site"* (six of the 18 hooks are read at two to four sites, and `rest_heal_add` at none), *"19 hooks"* (the list atop `relics.gd` holds 18), and a run-start *"points"* hook (the relics' talent-point hook was deleted at BM) |
| 19 | *"GC found 195 stale claims in `CLAUDE.md` where a brief named three"* | **NOT AS STATED — IT WAS GB** | `docs/reports/GB.md` §4a: 76 + 41 + 78 = 195. GC's own premise table (row 17) attributes it to GB |
| 20 | *"this one has already been found in two different phrasings"* | **HELD, AND THE SWEEP FOUND IT IN FIVE PLACES** | §2a |
| 21 | §3: the cap ruling, `SS_SEQ_MAX_PRESSES` and `SS_SEQ_OPEN` | **HELD** | Neither constant moved; `check_cs` §1 pins the cap at four and one widening row per allowed press |
| 22 | §3: the player-facing items, the relic redirect, *"no spec dissolves …"* | **HELD** | Untouched. `Relics.SAVE_PATH` is still a `const`, and the three `*_active` switches are unassigned (`check_ft` §0, in the battery) |
| 23 | *"… and the stamp"* | **READ AS BOTH STAMPS** | `docs/master.html` IS edited this batch, so its *Last updated* moves to GE, and `docs/state.md`'s *Last rewritten* moves with it |
| 24 | The batch letter | **GE, AND NO GD WAS BUILT** | `docs/state.md` said *"Next letter: GD"*, and no GD commit exists on either branch. A GD brief (*"Long Draw's trade, and the seam restated"*) was written and never built: its §1 ruled GC's second fix and its §2 a different restatement of the seam, and GE's brief supersedes both. Recorded in `docs/state.md` so the letter is not read as a lost batch |

## §1 — THE MISS

### 1a. What was built

- **The constant.** `SS_SEQ_MISS_DRAIN := SS_SEQ_FOCUS_PER_PRESS * 2`, beside the two payout constants, with the ruling's
  reason at the site. It is written as the relation because the reason is one — the press attempted and one already
  banked — so moving the per-press figure moves the cost with it. `check_cs` §1 pins the 16 (the card quotes it) and the
  relation (a drain retyped as a literal reds the day the per-press figure moves).
- **The record says whether a miss ended it.** `sc_sequence` gains `missed`, written where the miss happens: the bar sets
  it at its one fail branch, the bot's roll writes `seq_landed < seq_presses`, and the bar's opening record and its
  cancel reset carry `false`. **The payout reads `missed`, never "not full"**: a cancel also leaves the chain short of
  full with nothing earned, and a cast the player withdrew is not a press he missed.
- **The payout.** `_pay_sequence_focus` takes the drain when the rune is held and a miss is recorded, keeps its *"no Focus
  from the sequence"* return for a first-press miss only when nothing is drained, and passes `gain − drain` to
  `_gain_focus` in **one** call. One call rather than a payout followed by a drain, for three reasons the code makes
  concrete: the meter moves once, by what the chain was worth; a gain that is about to be taken back never reaches the
  conversion signature or the deepest-Focus ledger on the way up; and under Spray of Arrows' 50-point cap it is the net
  that is capped — at 45 Focus a four-of-five chain nets +16 and lands at the cap, where a payout-then-drain would land
  at 34.
- **The floor is `_gain_focus`'s.** The one addition there: a loss floats over the hero (*"-16 Focus"*) the way a gain
  always has, because a meter that falls in silence reads as a bug.
- **The log.** A drained chain prints its own line, naming what the meter actually moved and adding *"(the meter stops at
  0)"* when the floor took less than the drain.
- **The co-sites.** `battle.gd`'s clamp comment said the clamp was *"THE LONG DRAW'S ENTIRE COST"*; it now says it is not
  the cost, that the table stays at four rows by ruling, and where the cost is. The payout's header, the bar's header and
  `unit.gd`'s field comment name the miss. `check_ez` §5's arm says what it asserts — the table stays at four rows — and
  `CLAUDE.md`'s sentence says the narrowing is not the cost and points at the miss. And the card.

### 1b. What it is worth: GC's table and GE's, on `check_cs`'s own model

The model: timing error Gaussian with SD 60 ms; a press lands inside its Good window; the windows off the live constants;
the chain stops at its first miss; 8 Focus a landed press, 20 for a full chain, and 16 back on a miss with the rune.
**`check_cs` §7 prints the GE column every battery**, and a separate script that reads the constants out of `battle.gd`
agrees with the gate's print to the second decimal.

| Focus | presses, bare → rune | lands bare | lands with rune | Focus a basic, bare | with rune, no drain (GC) | with rune and drain (GE) | worth at GC | worth now |
|---|---|---|---|---|---|---|---|---|
| 0–49 | 1 → 2 | 97.7% | 98.5% | 27.34 | 35.56 | 35.32 | +8.22 | **+7.98** |
| 50–99 | 2 → 3 | 98.5% | 98.7% | 35.56 | 43.62 | 43.42 | +8.06 | **+7.86** |
| 100–149 | 3 → 4 | 98.7% | 98.8% | 43.62 | 51.63 | 51.44 | +8.01 | **+7.82** |
| 150+ | 4 → 5 | 98.8% | 96.0% | 51.63 | 58.77 | 58.14 | +7.14 | **+6.50** |

- **It is still a gain at every stage.** The drain costs 16 × the chance a rune chain breaks: 0.24 / 0.20 / 0.19 / 0.64
  Focus a basic. The rune's worth is mostly its added press, which pays 8 × the chance of reaching and landing it — 7.7
  to 8.0 — and on this model that press lands far more often than the chain breaks.
- **No per-miss figure makes it a trade on this model.** The drain at which the rune breaks even is **555 / 634 / 656 /
  180 Focus a miss**, and at 150+ that is more than the meter holds at the bottom of the stage, while the floor caps what
  a miss can take at what is held.
- **The floor moves it only below 16 Focus, and only in his favour:** at 0 Focus the rune is worth +8.12, at 8 +8.00, and
  from 16 up +7.98.
- **GC's alternative shape, priced the same way.** The added press taking no widening at any stage is worth +6.34 / +6.99
  / +7.11 / +7.14 — the brief's *"the second only makes the gain smaller"*, reproduced. With GE's drain as well it would
  be +5.12 / +6.24 / +6.46 / +6.50.
- **The sim bot's roll prices it as a loss.** The bot lands a flat 85% of presses, with no widening and no taper; on that
  roll the rune was worth +3.23 / +2.75 / +2.33 / +1.98 before the drain and is worth **−1.21 / −3.43 / −5.31 / −6.92**
  with it, because the bot breaks a five-press chain more than half the time.
- **The model's one assumption decides which side it falls on.** At a timing SD of 80 ms the rune is worth +6.60 / +6.65
  / +6.69 / +2.06; at 100 ms +3.62 / +3.87 / +4.18 / **−3.59**; at 120 ms +0.11 / +0.31 / +0.80 / **−8.41**. `CLAUDE.md`
  already records that the SD is a guess about human reflexes that nothing in this repo can measure.

### 1c. Driven on the real bar — `check_cs` §7 (+24), and the pins in §1 (+2)

§7 drives the real bar press by press through the gate's own `_drive` — the same helper its §2/§3 drives use — and reads
what `_pay_sequence_focus` then paid. **A drain that fired on the wrong press, fired twice or never fired would pass every
static check**, and each leaves a different number at some press, so every press is driven and every figure is exact.

| arm | Focus held | presses | the plan | paid |
|---|---|---|---|---|
| with the rune, a miss at press 1 / 2 / 3 / 4 / 5 | 150 | 5 | good × (k−1), then a miss | **−16 / −8 / +0 / +8 / +16**, the bar stopping at the miss each time |
| with the rune, no miss | 150 | 5 | good × 5 | +60 (40 and the 20 bonus), nothing drained |
| with the rune, a cancel | 150 | 5 | good, cancel | 0 |
| with the rune, the floor | 8 | 2 | a miss | **Focus 0, not −8** |
| with the rune, above the floor | 24 | 2 | a miss | Focus 8, all 16 taken |
| without the rune, a miss at press 1 / 2 / 3 / 4 | 150 | 4 | good × (k−1), then a miss | +0 / +8 / +16 / +24, nothing taken |
| without the rune, "the fifth press" | 150 | 4 | good × 4, then a miss | the bar sweeps four times and the chain is full: +52 |
| without the rune, at 8 | 8 | 1 | a miss | Focus stays 8 |

And every sequence record `battle.gd` builds carries `missed` — **CHECKED 3**, the bar's opening record, its cancel
reset and the bot's roll — with the bar setting it at exactly one site. The bot is asserted as a property of its record
rather than driven, for the reason §5 of the same gate gives: the bot never runs the bar, and driving its branch means an
autoplay battle. **Three identical standalone readings of 130 / 0.**

`check_ez` §5 (+5) drives the rune's read site off a constructed record — without the rune a chain broken after two keeps
+16; with it the miss takes back 16; a record with no miss in it takes nothing, rune or not — and reads the card: it
names *"drains 16 Focus"* off the constant, and the widening clause is gone. **Three identical standalone readings of
103 / 0.**

**The log line, rendered.** The payout's lines reach no stdout outside a sim, so a throwaway probe — run only in a copy
of the tree, never in it — printed them for seven records:

- 150 Focus, two of five landed: *"The chain broke at 2 of 5 — the 2 shots landed pay 16, the Long Draw's miss takes back
  16: +0 Focus"*
- 150 Focus, the first press missed: *"The chain broke on the first shot — the Long Draw's miss costs 16 Focus"* (150 → 134)
- 8 Focus, the first press missed: *"… the Long Draw's miss costs 8 Focus (the meter stops at 0)"* (8 → 0)
- 150 Focus, four of five landed: *"… the 4 shots landed pay 32, the Long Draw's miss takes back 16: +16 Focus"*
- 8 Focus, one of two landed: *"… the 1 shot landed pays 8, the Long Draw's miss takes back 16: -8 Focus"* (8 → 0 exactly,
  so no floor note)
- a full chain, and a record with no miss in it, print their old lines unchanged.

**The first rendering read *"the 1 shot landed pay 8"*.** The verb now agrees with its count — found by rendering the line,
which nothing else reads — and both gates re-read 130 / 0 and 103 / 0 on the fixed tree, `check_parse` 182 / 0 with no
error line, and the pin manifest reads current. The controls below ran on the tree before that one-word fix, which moves
no arithmetic. The neighbouring pre-GE line has the same slip (*"the 1 shot already landed still pay"*) and is left.

### 1d. The negative controls

Run in an isolated copy of the tree, its `config/name` renamed so nothing it did could reach the player's save folder.
**Every injected file parsed clean in its run** (no `Parse Error`, `Compile Error` or `SCRIPT ERROR` line), and each was
restored and md5-checked against the pristine copy before the next arm.

| arm | what was changed | `check_cs` | `check_ez` | what went red |
|---|---|---|---|---|
| A | **HEAD's** `battle.gd`, `unit.gd` and `runes.json`, with only `SS_SEQ_MISS_DRAIN`'s name added so the gates reach their drives rather than throwing at the pin | 130 / 9 | 103 / 3 | the five miss arms, both floor arms, both record arms; the drain arm and both card arms |
| B | the new code, disarmed, in the copy | 130 / 0 | 103 / 0 | — |
| i | the drain taken twice | 130 / 6 | 103 / 1 | every miss arm exactly 16 short, and the 24-Focus arm (reads 0); the 8-Focus arm cannot tell a doubled drain from a single one and stays green; the drain arm reads −16 |
| ii | the drain never taken | 130 / 7 | 103 / 1 | the five miss arms and both floor arms; the drain arm reads +16 |
| iii | the drain read off "not full" instead of `missed` | 130 / 1 | 103 / 1 | the cancel arm alone (−16); the no-miss record arm alone (+0) |
| iv | the floor removed from `_gain_focus` | 130 / 1 | — | the 8-Focus arm alone (reads −8) |
| v | the drain charged on a full chain too | 130 / 1 | — | the full-chain arm alone (+44 where +60 is due) |
| vi | the bot's record written without `missed` | 130 / 1 | — | the record arm, naming the bot's record |
| vii | the bar never setting `missed` | 130 / 8 | — | the five miss arms, both floor arms and the one-site arm |
| viii | HEAD's card | — | 103 / 2 | both card arms |

**Arm A is the second arm of the repair.** HEAD's unmodified gates read 104 / 0 and 98 / 0 against the new code — they
could not see the drain — and the new gates, run on HEAD's behaviour, name exactly where it is missing.

### 1e. HEAD's gates against the new code, before any gate was edited

Standalone: `check_cs` 104 / 0 and `check_ez` 98 / 0, both unmodified (`git diff` against HEAD empty). And **the whole
battery as reconnaissance**: every one of HEAD's 108 targets — its gates, its suites and its documents — against the new
code, in a second isolated copy, through `run_battery.sh` itself:

- **108 targets, one ascending `.ran` of 108 names in the same order as GC's acceptance run, no duplicate; 0 `Parse
  Error` and 0 `SCRIPT ERROR` lines across the logs.**
- **Every count at its HEAD row but one**: the harness at 22 / 382 / 8, `check_ct_map` 83 / 0, `check_cm_live` its
  sanctioned 13 / 4 with its four FAIL lines identical to GC's acceptance log character for character, `check_cs` 104 /
  0 and `check_ez` 98 / 0.
- **The one is the copy's, not the code's.** `check_de` read 449 / 1: *"check_fr went REDDER: 2 failures"*. Both of
  `check_fr`'s FAIL lines are its §1 branch arm — *"no .git here, so the branch arm below cannot mean anything"* and *"no
  such ref exists in this repo"* — and the copy was made without `.git`. The same gate reads 25 / 0 on the real tree,
  in the pre-pass below, as it did in GC's acceptance run. It reads `.git` directly rather than by shelling out, which is
  why a sweep for `OS.execute` did not flag it.
- **So no count HEAD's gates and suites take moved under the new code, sim-driven ones included.** Two targets do meet
  the rune — `test_rune_battle` fields a Long Draw Sharpshooter in a live battle (*"Rune: Sharpshooter: Long Draw"* in its
  log) and `check_fd` draws it into an offer overlay — and both read at their rows. Neither asserts what a broken chain
  pays, which is the half only `check_cs` §7 and `check_ez` §5 now drive.

## §2 — NO PERMANENT LAYER IS SPEC-SPECIFIC

### 2a. The sweep, and the five places

Every sentence of `CLAUDE.md` and `docs/master.html` that names a talent, a tree, a node, a cell, a meta layer or a
permanent layer AND a spec — the text unwrapped first, so a claim wrapped across a line is one sentence — was read:
**43 sentences, 21 and 22.** Then both files were swept for the claim's other shapes: *spec tree*, *per-spec*, *meta
layer*, *permanent layer*, *which spec*, *about a spec*, *about that hero*, *spec-specific*, *what a spec does* and *the
talent trees*.

| # | where (HEAD) | the claim | now |
|---|---|---|---|
| 1 | `CLAUDE.md` 1524, the block's heading | *"A TALENT CHANGES WHAT A SPEC DOES IN A FIGHT"* | *"… A TALENT CHANGES WHAT A CLASS DOES IN A FIGHT; ONLY A RUNE KNOWS THE SPEC"* |
| 2 | `CLAUDE.md` 1540–1544, the second-axis paragraph | *"so a talent can only be about that hero"* | every hero of a class wears every cell the class bought, whichever spec he is, so a talent cannot be about a spec; and a new paragraph says NO PERMANENT LAYER IS SPEC-SPECIFIC ANY MORE, that this is what FX intended, and that the rune is the one layer left that can be tied to a spec |
| 3 | `CLAUDE.md` 1547, the first rule bullet | *"… or must know which spec the hero is, it is a TALENT"* | a talent pays every hero who wears it whatever his spec, and an effect that must know the spec cannot be one; the RUNE bullet takes it |
| 4 | `CLAUDE.md` 1991–1997 and 2041, the DO block's note and its status half | *"the STAT and the RESOURCE survive"*; *"a status the spec has no guaranteed way to apply"* — halves that still bind, written for spec trees | *the spec* is read as every class that can buy the node: the resource survives only as FX's every-currency rule, and a node may read a status only if every hero who wears it can apply it |
| 5 | `docs/master.html` 2671–2677, the relic paragraph | *"a talent changes what a SPEC does inside a fight"*, and *"the talent trees are the only meta layer"* | rewritten: a relic sets up the run, a talent changes what every hero of a class does, a rune is the one layer tied to a spec, and no permanent layer is spec-specific |

`CLAUDE.md` 1538's *"the talent trees are the only meta layer"* is singular now too, beside #1–#3.

**The other 38 sentences are not the claim.** They are true (the talents file, the FX block, the fold, the build
screen); a record the FX block already tells the reader to take as history (the DO block's permitted list, the name-sweep
block's deleted Warden nodes); or the census's other direction, already queued under GC (two more of `master.html`'s
*"the talent trees"*, its pre-BM talent-point income, DO's move of twenty-two cards told as history).

### 2b. The paragraph's four other claims

- **Rest nodes as a read site** — deleted; the map has no rest node, and the paragraph now says the hook that read them has
  no reader, so Cairnmoss Poultice pays nothing and Martyr's Knucklebone only its victory heal (it carries both hooks).
- **"Every hook below is read at exactly one site"** — false by count. The 18 hooks have **25 read sites**: `shop_discount`
  4; `start_items`, `victory_mana_pct`, `victory_gold`, `loot_extra` and `gold_find_mult` 2 each; `rest_heal_add` none;
  the other eleven 1. The paragraph now says *"25 in all, and six of the hooks are read at more than one"*. Its claim that
  none is read inside a turn holds: `battle.gd`'s twelve sites are nine in `_spawn_units` and three in `_check_end`.
- **"19 hooks"** — 18, the list atop `relics.gd`.
- **"run-start gold/points/items"** — gold and items; the talent-point hook went with BM.

### 2c. Found and left

- **`relics.gd`'s header** still says every entry is read at exactly one site and names rest nodes as `rest_heal_add`'s
  site. FW queued it; it is code and the brief did not name it. `docs/state.md` cross-references it.
- **The sweep's residue** is all the census's other direction and all queued under GC, listed above.

## §3 — NOT DONE, AS RULED

- **The cap ruling is not reopened.** `SS_SEQ_MAX_PRESSES` (4) and `SS_SEQ_OPEN` (four rows) did not move: §1 changes what
  a miss costs, not how many presses there are or what each pays.
- **The five player-facing items stay queued**, and the quit/resume skip is next.
- **The relic redirect stays deferred.**
- **No spec dissolves, no pool merges, no engine becomes a rune, no spine is attached.**

## VERIFICATION

**The documentation was written before the acceptance run, and nothing in the tree was edited behind it.**

- **HEAD's gates first** (§1e): `check_cs` 104 / 0 and `check_ez` 98 / 0 unmodified against the new code, and the whole
  battery as reconnaissance in an isolated copy — every count at its HEAD row except `check_fr`'s copy artefact.
- **The new gates:** three identical standalone readings each, `check_cs` 130 / 0 and `check_ez` 103 / 0, and one more
  of each after the grammar fix.
- **The controls** (§1d): ten arms, each red exactly where it was aimed.
- **The literal sweep, bracketing every edit.** Every string literal of four characters or more in every `.gd` file —
  16,615 distinct needles over 140 files, both quote styles, comments stripped by a lexer that knows strings — matched
  raw, lowered and whitespace-flattened against HEAD's copy and the new copy of each of the eight edited files:

  | file | needles present, HEAD → new | LOST | GAINED |
  |---|---|---|---|
  | `CLAUDE.md` | 1,617 → 1,617 | 0 | 0 |
  | `docs/master.html` | 1,789 → 1,789 | 0 | 0 |
  | `docs/changelog.html` | 1,226 → 1,231 | 0 | 5 |
  | `docs/design-notes.md` | 1,536 → 1,536 | 0 | 0 |
  | `docs/state.md` | 1,340 → 1,345 | 1 | 6 |
  | `scripts/battle.gd` | 4,885 → 4,892 | 0 | 7 |
  | `scripts/unit.gd` | 2,065 → 2,066 | 0 | 1 |
  | `data/runes.json` | 942 → 943 | 1 | 2 |

  **Every one was settled at its read site.** The two LOST: *buys no widening* from `runes.json` is `check_ez` §5's new
  absence arm, which asserts exactly that; *TENTH* from `state.md` belongs to `test_batch_ax`, which does not open
  `state.md`. The GAINED in the changelog and in `state.md` each belong to a target that does not open the file, or opens
  it and asserts the literal against a different haystack: `test_batch_bs`'s and `test_batch_ar`'s *drain* read ability
  and passive descriptions, `test_batch_bo`'s *effects* is a dictionary key, and `check_ek` names `state.md` only in a
  comment. The GAINED in the source and the card are the new code's own literals, `check_cs` §7's two new pins,
  `check_ft`'s *missed* (a table label) and `classes.gd`'s *Costs %d* (game code).
- **The count sweep.** A presence sweep cannot see an integer pin move, so every `.count("…")` literal in the tree (103)
  was counted in both copies of the eight files. **One moved**: `sc_sequence["missed"] = true`, 0 → 1 in `battle.gd`,
  which is `check_cs` §7's own pin.
- **The pin manifest.** `build_pin_manifest.py --check` read STALE after the gate edits and was regenerated: **1,460 →
  1,464 pins**, +11 / −7 rows — `check_cs` §7's four new pins, six `check_ez` rows re-lined by the lines inserted above
  them, and one residency label: `test_batch_bx` §5's *all four heroes* alternative into `master.html` went from
  resolving through its sibling to resolving directly, because the new relic paragraph writes in lower case what that
  paragraph's bold line already says in capitals. `bx` lowers its haystack before matching, so its reading is unchanged.
  Regenerated once more after the grammar fix, with no row moving; `--check` reads current.
- **The doc-reader pre-pass.** Every battery target that opens one of the five edited documents by its `res://` path —
  41 — plus `check_ed` and `check_parse`, run standalone against the finished tree with the battery's own flags, frame
  budgets and bounds: **43 of 43 at 0 failures and 0 throws**, the document gates at their rows (`check_ec` 23, `check_ed`
  18, `check_es` 57, `check_ff` 55, `check_fg` 22, `check_fr` 25, `check_fs` 33) and `check_parse` 182. `check_fg` prints
  `CLAUDE.md` at 318,431 B = 310.97 KiB, 29.03 KiB under its 340 KiB ceiling, and the changelog at 317,496 B, 82,504 B
  under its 400,000 B bar.
- **The acceptance battery.** **All 108 targets through `run_battery.sh`, 20:53:38 → 21:40:08 (46 m 30 s)**, over the finished tree with every
  document edit in place and nothing edited after. `.ran` is one sequence of 108 names in the same order as GC's
  acceptance run, with no duplicate, and no Godot or battery process was in `ps` before the launch or after the run —
  the rows were read, not counted. **`check_de`: 449 checks / 0 failures / 0 notices**, so all 107 `baselines.json` rows
  read at their rows, the two this batch moved included: `check_cs` 130 / 0, printing the model rows §1b quotes, and
  `check_ez` 103 / 0. The harness at 22 / 382 / 8 with no throws; `check_map_screen` COMPLETE; `check_ct_map` 83 / 0;
  `test_batch_an` 6055 in [6046, 6063]; `test_batch_bk` 129 in [128, 130]; `check_fx` 496 / 0; `test_runes` 5,306 / 0
  and `test_rune_battle` 97 / 0; the document gates as in the pre-pass. **`check_cm_live`: 13 / 4, the sanctioned red,
  its four FAIL lines identical to GC's acceptance log character for character** — GC's log, copied out of its own
  scratchpad before this run began.
- **Parse.** 0 `Parse Error` lines and 0 `SCRIPT ERROR` lines across the 108 logs, read off the logs and never off a tally
  or an exit code — and 0 of each across the reconnaissance battery's 108 as well.
- **The freeze.** every file in the repo but `.git` and the `.godot` build cache — tracked, untracked and ignored, 491 files — and
  the four player saves were hashed before the launch and after the run: **495 lines, identical byte for byte**.
- **The saves** were backed up before anything moved, to `save-backups/GE-20260913-195611/`, and verified by hash: all
  four equal to the live files and to GC's backup — `profile.json` `b05e329b…`, `run_save.bin` `c44d45da…`,
  `relics.json` `fdc12ffa…`, `settings.cfg` `0c1b39c3…`. After the run all four still hash the same as that backup.
- **Left on disk, deletable:** three user-data folders under Godot's `app_userdata` — *Dawn of Decay GE recon*, *Dawn of
  Decay GE ctl* and *Dawn of Decay GE probe* — one for each copy, each renamed so its `user://` could not reach the
  player's save folder.
- **One file was written after the run: this report.** No gate or suite reads `docs/reports/`, and it was outside both
  freeze stamps by construction: it did not exist when either was taken.
