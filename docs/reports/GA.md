# BATCH GA — NO ALTERNATE ON THE LIST QUALIFIES, AND EIGHTEEN STALE CLAIMS LEAVE THE INSTRUMENT RULES

**THE EIGHTH BATCH ON `class-merge`.** No game code, no data file, no node, no rune and no magnitude moved. `main` is
untouched.
- **§1: Enemies Look Past You is ruled out, and its replacement stopped at the list.** The brief said to stop if none
  of the five alternates qualified, and none does.
- **§2: the three crit nodes stay.** The ruling is recorded with its reason, and with a correction to which three it
  covers.
- **§3: `docs/instrument-rules.md` is swept.** 18 of its 81 present-tense claims about the tree were stale. The list
  was written before the first correction.
- **§4: what was deliberately not done**, the relic redirect's deferral among it.
- **§5: verification.**

---

## NEEDS A RULING

1. **ENEMIES LOOK PAST YOU STILL NEEDS ITS REPLACEMENT, AND IT IS PLAYER-FACING.** Your ruling stands, and it is
   blocked. Of the five approved alternates, three are already nodes in the tree and two pay the party once (§1a).
   **The node is unchanged**, so its card still says *"65% less likely to target this hero while another ally
   lives"*. That text is false whenever other heroes hold it, and in your save that is every class on day one.

   The table lists the rows SR-REACH says pay every class that no node writes yet, in the recon's own words. **It is
   the population the brief's test leaves, not a recommendation.** The name, the magnitude and the card text are
   yours.

   | Recon item | The thing | Reach (SR-REACH) | Field a node would write | Caveat the recon or SR-REACH carries |
   |---|---|---|---|---|
   | SR-EVADE 2 | Parry ranged blows | every class | `deflection` | none |
   | SR-BREAK 3 | Penetration is Break | every class, through his ordinary blows | `sunder_shot` | worth nothing without penetration |
   | SR-BREAK 8 | I do not break | every class | `constitution`, `stability`, `immovable`, `unrelenting_ranks`, `toughness_ranks` | the recon lists five fields, written today by spec stats |
   | SR-STATUS 1 | Statuses on this hero last longer or shorter | every class | `mod_status_turns` | the Fleeting bargain ASSIGNS over it, and it moves buffs as well as debuffs |
   | SR-STATUS 4 | Damage per debuff on the target | every class, through his ordinary blows | `overwhelm_ranks` | none |
   | SR-STATUS 6 | A heal per unique enemy debuff | every class | `pleasure_pct` | none |
   | SR-STATUS 7 | Armor per debuff landed | every class, through his ordinary blows | `dominant_ranks` | only 18 of 214 apply sites report to it |
   | SR-PARTY 2 | Cap the size of one hit | every class | `stable_ranks` | none |
   | SR-HEAL 2 | A turn-start heal for the low | every class | `beacon_ranks` | an idle field; a node writing it owes a `check_em` row |
   | SR-COOLDOWN 2 | A tick on every cast | every class | `practised_hands` | none |
   | SR-COOLDOWN 3 | The opening casts start no cooldown | every class | `improvised` | none |
   | SR-COOLDOWN 5 | A reset at low health | every class | `second_wind` | its float text names Rage whatever pool the hero holds |
   | SR-COOLDOWN 6 | A periodic extra tick | every class | `mindfulness_ranks` | an idle field; a node writing it owes a `check_em` row |

   **One more, in part:** SR-RESOURCE 4's kill half (`bloodied_momentum_ranks`). Its Break half is already Breaking
   an Enemy Refuels You, and its float text names Rage whatever pool the hero holds. §1d says how the table was taken.

**Nothing else.** §2's correction to which nodes the crit ruling names changes no node, whichever three it covers.

## THE SHORT VERSION

1. **NONE OF THE FIVE ALTERNATES QUALIFIES, SO THE REPLACEMENT STOPPED.**
   - **Three are already in the tree.** FX took *kill what is down*, *a crit pays* and *Breaking heals the party* as
     alternates for its own four. A second copy of any of them is a second node on a field the tree already writes.
   - **The other two pay the party once.** *When an ally falls low I answer* and *enemy debuffs rebound* are the
     brief's own "same defect in a different shape". Both were checked at their read sites (§1a).

   Enemies Look Past You is unchanged until you pick from the table above.
2. **HEAL MORE WHEN LOW AND WE DO NOT BREAK STAY**, as ruled.
3. **THE THREE CRIT NODES STAY.** The ruling is written where the misreading would start: in
   `docs/design-notes.md`, and in `docs/state.md`, whose queue item is now closed. **The brief named the wrong two.**
   More Crit Chance and Armor Penetration are SR-CRIT's other rows and count as distinct things. FY's three are A
   Cooldown Ticks on a Crit, A Crit Pays and Your Crits Crack Guards, at tiers 2, 3 and 3 (§2).
4. **`docs/instrument-rules.md` MADE 81 PRESENT-TENSE CLAIMS ABOUT THE TREE, AND 18 WERE STALE.**
   - FZ's two and sixteen more.
   - Nine described something gone and are deleted; four named something that moved and are corrected; five were
     stale figures and are deleted.
   - 48 hold, 12 are dated history, and 2 are dated readings that were not re-derived and are said to be so.
   - The list was written before the first correction. Three claims of the same shape outside the file are queued
     (§3).
5. **THE RELIC REDIRECT IS DEFERRED, AND FY'S MEASUREMENT SITS BESIDE IT IN THE QUEUE.** Every relic is still
   unlocked: 25 of 25, re-checked. Deepening Hex's floor stays at 8 (§4).
6. **VERIFICATION.** HEAD's unmodified gates were run against the new tree first (76 targets), and no red was unpredicted.
   - **The acceptance battery is green and moved nothing.** All 108 targets read their rows, and `check_de` read 449 / 0 with no notices.
   - `Parse Error` appeared on 0 lines in any log.
   - The one red is the sanctioned `check_cm_live` 13 / 4, with its FAIL lines unchanged.
   - The tree and your four saves were identical before and after the run (§5).

---

## §0 — THE BRIEF'S PREMISES

Each was checked against the repo, the reports and the recon before anything was edited.

| # | Premise | Verdict | What the record says |
|---|---|---|---|
| 1 | *"On `class-merge`. Small."* | **HELD** | HEAD was `8a4b2fb`, equal to `origin/class-merge` by `git ls-remote` before anything moved |
| 2 | FZ found the three quoted instances were paraphrases, and that there has never been a `check_cd` | **HELD** | FZ §0, rows 3, 10 and 11 |
| 3 | *"FY found its text is FALSE when the whole party holds it — three of the four heroes are then targeted MORE"* | **HELD** | FY §1b and SR-REACH: 22.9 / 30.4 / 23.7 / 22.9% with all four holding it, against 16.9 / 54.6 / 14.6 / 13.9% with none. Quoted, not re-measured |
| 4 | *"In a one-tree-per-class system, a whole party holding the same node is the NORMAL case"* | **HELD, WITH ONE WORD CORRECTED** | It is ONE tree, bought per class (`CLAUDE.md`, the FX block). Every hero of a class wears every cell the class owns (*A CELL BOUGHT IS A CELL WORN*). The whole party holds a node once all four classes have bought it: always at full depth, and in your save on day one, where the folded purses (65–68) exceed the tree's 54 (FX §4) |
| 5 | *"Take one alternate from the approved list"*, naming five | **THREE OF THE FIVE ARE ALREADY IN THE TREE** | FX's approved list had six (FX §2). It used four: *kill what is down* is `tn_kill_down`, *a crit pays* is `tn_crit_pays`, *Breaking heals the party* is `tn_break_heal`, and *we do not break* is `tn_unbreaking`. The two it did not use are *when an ally falls low I answer* and *enemy debuffs rebound*. The brief's five are the six minus *we do not break* |
| 6 | SR-REACH classifies the fifty: 6 by class, 1 by spec, 5 party-once, 1 relative | **HELD** | The SR-REACH table: 6, 1, 5 and 1 |
| 7 | *"The 37 that pay every class"* | **HELD** | SR-REACH's two EVERY CLASS rows: 23, plus 14 through the hero's ordinary blows |
| 8 | Heal More When Low and We Do Not Break are *"redundant when stacked, not false"* | **HELD** | FY §1b: both are party stamps that take the best holder's figure. Every hero is paid, and only one holder's copy does anything |
| 9 | §2: *"More crit chance, armor penetration and a crit pays count as one idea under the document's own counting rule"* | **FALSE AS NAMED** | Those are SR-CRIT 1, 3 and 2, and SR-CRIT's own table counts them as three distinct TODAY things. FY's three are A Cooldown Ticks on a Crit (SR-COOLDOWN 1), A Crit Pays (SR-CRIT 2) and Your Crits Crack Guards (SR-BREAK 2), and SR-CRIT 2 contains all three (FY §1c, §1e; `state.md`'s queue). **The ruling is implemented for FY's three. Nothing moves either way** (§2) |
| 10 | The counting rule *"is about how `systems-recon.html` counts distinct things"* | **HELD** | SR-HOWTO part 6 and §4's rule (*"one trigger paying in two currencies is one thing"*). The rule appears in no rule file: a sweep of `CLAUDE.md`, `docs/instrument-rules.md` and `docs/ways-of-working.md` finds it nowhere |
| 11 | *"Three different purchases at three different depths"* | **TRUE OF THE BRIEF'S THREE, NOT OF FY'S** | The brief's three sit at tiers 1, 2 and 3; FY's at tiers 2, 3 and 3. Recorded as given, with the correction beside it (§2) |
| 12 | §3: two bullets describe DD's setup in the present tense, and FZ found them | **HELD** | FZ §5. At HEAD, lines 864 and 888–890 of `docs/instrument-rules.md` |
| 13 | FY found a bullet saying the relic file is safe and a battery destroys the run save, *"both untrue since FI"* | **PARTLY; AND FY HAD ALREADY FIXED IT** | FY rewrote that bullet (FY §7, `5434130`). It now reads *"SINCE FI IT CANNOT"* and *"THE META LAYER IS SAFE BY STATE, NOT BY CONSTRUCTION"*. **The relic half was never "untrue since FI"**: `Relics.SAVE_PATH` has had no redirect at any batch, so "safe" held only while every relic was unlocked, before FI as well as after |
| 14 | *"My populations have been short every time"* | **HELD HERE TOO** | FZ found two by reading. The census found eighteen of 81 (§3) |
| 15 | DR's rule: *"where the thing it describes is gone, DELETE the claim rather than updating it"* | **HELD, FOR THE NINE THINGS THAT ARE GONE** | **Four claims name something that moved, not something gone.** This file's own EB §2 rule says to correct the name there, because deleting it throws away something true, and those four were corrected. Five stale figures were deleted under its DJ §3 rule (§3d) |
| 16 | §4: *"four gates reach the save path 14 times a battery"* | **HELD, WITH ONE PRECISION** | They reach `Relics.unlock_random()` 14 times (2, 4, 3 and 5, FY §5b's pre-pass). That call reaches `save_data()` only when a relic is locked, and `check_fh`'s share moves with how far its autoplay run gets |
| 17 | *"Harmless only because every relic is unlocked"* | **HELD, RE-CHECKED** | Your `relics.json` holds all 25 of `Relics.POOL`'s 25, and none is locked |
| 18 | *"The first locked relic makes it permanent"* | **HELD** | FY §5b |
| 19 | *"Deepening Hex's floor stays at 8"* | **HELD** | `RUIN_FLOOR := 8` (FY). This confirms FY's NEEDS A RULING #1 |
| 20 | §5: *"reading the source counted three gates where recording the calls found four"* | **HELD** | FY §5b: `check_fh` reaches it through its live run and never names the function |
| 21 | *"Drive the replacement node live on all four classes"* | **NOT APPLICABLE** | No replacement shipped (§1) |
| 22 | *"Run the unmodified gates against the new tree before editing any of them"* | **HELD** | And no gate was edited at all (§5d) |
| 23 | *"Pair every negative anchor with a positive arm"* | **NOT APPLICABLE** | No gate gained an arm. The batch's own instrument, the literal sweep, was armed before it was trusted (§5b) |
| 24 | *"`master.html`, and the stamp"* | **NOT EDITED** | No node moved, so nothing a player can meet changed. The stamp is read as `docs/state.md`'s *Last rewritten* line, which is FU's reading of the same words |
| 25 | *"`baselines.json`"* | **NOT EDITED** | No count moves. That was predicted before the battery and confirmed by it (§5) |

## §1 — ENEMIES LOOK PAST YOU: THE FIVE, AND WHY THE REPLACEMENT STOPS

### 1a. The five, by SR-REACH group, checked at the read sites

| The brief's alternate | Recon item | SR-REACH group | In the tree? | Qualifies? |
|---|---|---|---|---|
| *kill what is down* | SR-BREAK 4 (`bonecracker_ranks`, `off_balance_ranks`) | every class, through his ordinary blows | **YES**: Kill What Is Down (`tn_kill_down`, `bonecracker_ranks` 40), FX's alternate for *debuffs on you expire sooner* | **No**: already shipped |
| *a crit pays* | SR-CRIT 2 (`follow_through`, `sundering_shot`, `whetstone`, `exposed_nerve`, `temporal_ranks`, `through_and_through`) | every class, through his ordinary blows | **YES**: A Crit Pays (`tn_crit_pays`, `whetstone` 3), FX's alternate for *a Perfect pays*. The same item is also A Cooldown Ticks on a Crit and Your Crits Crack Guards | **No**: already shipped, three times over by FW's count |
| *when an ally falls low I answer* | SR-TIMELINE 2 (`watchtower`) | **the party, once** | no | **No**: `_living_hero_with("watchtower")` (`battle.gd`:3430) pulls only the first living holder, so the second, third and fourth class to buy it is paid nothing |
| *Breaking heals the party* | SR-BREAK 5 (`blood_communion`) | every class, through his ordinary blows | **YES**: Breaking Heals a Hero (`tn_break_heal`, `blood_communion` 20), FX's alternate for *regenerate more resource* | **No**: already shipped |
| *enemy debuffs rebound* | SR-STATUS 2 (`mirror_ranks`) | **the party, once** | no | **No**: `_max_hero_rank("mirror_ranks")` (`battle.gd`:10910) reads only the best holder |

**The two party-once readings were taken at the read sites, not only from SR-REACH.** The three shipped ones are read
in `_resolve`'s ordinary strike branch, which FY §1b traced and `check_fx` §4 drives.

### 1b. Why "already in the tree" disqualifies

There were two ways to take one of the three anyway, and each fails:
- **The same field again.** That is a second node on a field the tree already writes. `CLAUDE.md`'s one-tree rule
  calls that authoring the re-skin, and `check_fx` §1 would go red.
- **The same idea on a field the tree does not write.** For example, SR-CRIT 2's status or refund currency, or
  SR-BREAK 4's `off_balance_ranks`. That is new content: which currency, what magnitude, what name and what card
  text. The brief transcribes none of it, and the list item it would come from was already spent by FX. It would also
  be a second magnitude of a node the tree holds, which is the property the field rule exists to stop.

### 1c. So it stopped, and what that leaves standing

**`scripts/talents.gd` is byte-unchanged**, and so is every other file under `scripts/` and `data/`. Enemies Look Past
You is still tier 2, `ghillie` 65, with its card as it was. `docs/state.md`'s queue item now reads *RULED AT GA:
REPLACE IT, BLOCKED*, with the population above attached. **Heal More When Low and We Do Not Break stay, as ruled**,
and that item is struck through in the queue.

### 1d. How the population in NEEDS A RULING was taken

- **The candidates are SR-REACH's two EVERY CLASS rows**: 23 items, plus 14 through the hero's ordinary blows, for 37.
- **Each item's field comes from its own section's §3 table** (*What a node reaches TODAY*).
- **The tree's fields were parsed out of `talents.gd`'s `TREE`**: 27 nodes writing 28 fields (Pay a Lethal Hit writes
  two).
- **The result is 23 items whose field the tree writes, 1 in part, and 13 not at all.** It was checked in both
  directions: no "written" item's field is missing from the tree, and no "unwritten" item's field is in it. Every one
  of the 13 fields has live read sites in `battle.gd`, `unit.gd` or `run_state.gd`.
- **What was not re-taken:** SR-REACH re-took only the reach. FY §8 says so of the SMALL and LARGE costs, and none of
  these rows' costs or traps was re-checked here. Before one is authored, the author reads its section.

## §2 — THE THREE CRIT NODES STAY

### 2a. The ruling, as given

**Keep all three.** More crit chance, armor penetration and *a crit pays* count as one idea under the document's own
counting rule, **but that rule is about how `systems-recon.html` counts distinct things, not about what a tree may
contain.** They are three different purchases at three different depths, and a player meets them as three.

### 2b. Which three

| | The brief's three | FY's three (the ones `state.md` queued) |
|---|---|---|
| Tier 1 | More Crit Chance (SR-CRIT 1) | — |
| Tier 2 | Armor Penetration (SR-CRIT 3) | A Cooldown Ticks on a Crit (SR-COOLDOWN 1, inside SR-CRIT 2) |
| Tier 3 | A Crit Pays (SR-CRIT 2) | A Crit Pays (SR-CRIT 2) and Your Crits Crack Guards (SR-BREAK 2, inside SR-CRIT 2) |
| By FW's counting rule | three distinct things | one thing |

**The ruling is recorded against FY's three, because that is the question it answers.** Its operative sentence, that
the counting rule does not limit a tree, holds for any three. Its supporting clause, *"three different depths"*, is
true of the brief's three and not of FY's, and it is recorded as given with this correction beside it. No node moves
under either reading.

### 2c. Where it is recorded, and where it is not

- **`docs/design-notes.md` (GA):** the ruling and its reasoning. That file exists for *why a decision was made*.
- **`docs/state.md`:** the queue item is struck through as RULED, with the correction.
- **Not `CLAUDE.md`.** No standing rule's scope changes. `CLAUDE.md`'s one-tree block already makes the field the test
  (*"A node is a second magnitude of another only by sharing its field"*), and the counting rule appears in no rule
  file, so no rule there can be misread through it. The brief's deliverables also leave `CLAUDE.md` out.
- **Not `docs/systems-recon.html`.** `docs/ways-of-working.md` says to regenerate a recon rather than hand-edit it,
  and the brief did not ask for an edit. SR-REACH's double-count bullet states a count and names no constraint.

## §3 — THE INSTRUMENT RULES

### 3a. The census came first

The brief's order was to report the full list before correcting any of it, so the list was written to the scratchpad
at **23:25:33** and the file was not touched until **23:26:50**. The list is reproduced below as it was written.
- **The population is every sentence that states, AS CURRENT, a fact about the tree**: a file, a path, a function,
  what a gate or suite does or pins, what the runner carries, a setting, a location, or a count.
- **The whole file was read, all 1,446 lines at HEAD `8a4b2fb`, and 81 such claims were found.** Each was checked
  against the tree by grep, by reading, or against the manifest and the logs on disk.
- Past-tense history, and a figure dated by its own block or sentence, is outside the population. Where one was
  checked anyway, it is in 3c.

### 3b. The eighteen

| # | Line at HEAD | Block | The claim | What the tree says | What it became |
|---|---|---|---|---|---|
| A1 | 14–16 | preamble | *"EVERY RULE BELOW IS THE `CLAUDE.md` TEXT, MOVED AND NOT REWRITTEN. Not one character inside a moved block was edited"* | Five `##` blocks were written straight into this file: FG §2 (`0c46df5`), FH §2 twice (`8eb0057`), FI §1 (`da0673b`) and FR §5a/FS §1 (`3b80fbe`). Moved blocks were also edited in place: FG added bullets to CW §4, FI rewrote two harness bullets, FS added a zsh sub-bullet, and FX and FY each rewrote a bullet under *Verify before shipping* | **GONE: deleted.** EF §2's and FF §2's byte-for-byte history stays |
| A2 | 16–17 | preamble | *"**Only** the THREE `##` section headings that carry orphaned material are new"* | Those three are new, and so are the five above | **GONE: "Only" deleted** |
| A3 | 33 | preamble | *"the live size is in `docs/state.md`"* | `state.md`'s only reading is EG's, 104.70 KiB, under *"re-measured at EG"*. `check_fr` §5 prints the live size every battery | **MOVED:** *"the live size is printed by `check_fr` §5 every battery"* |
| A4 | 86–87 | CW §4 | *"ARCHIVE MEANS MOVE OUT OF THE REPO … to `/Users/zipples/Documents/DoD-archive/`, beside the `.docx` exports"* | FH brought the archive into the repo: `git ls-files` lists `DoD-archive/changelog-archive.html`. The old path does not exist, and the `.docx` files live outside the repo | **MOVED:** *"ARCHIVE MEANS MOVE, NEVER DELETE — to `DoD-archive/changelog-archive.html`"* |
| A5 | 133–136 | CW §4 | *"A FILE IN THE ARCHIVE IS NOT IN VERSION CONTROL AND IS NOT BACKED UP BY GITHUB … it is the designer's call to fix"* | It has been tracked since FH and is pushed with every batch. The live changelog's own header says so | **GONE: the bullet is deleted** |
| A6 | 442–443 | DX §1 | *"The changelog ARCHIVE keeps `== 149`"* | `check_dv` §4 pins **185**, since FG's cut | **FIGURE:** *"keeps its equality"* |
| A7 | 515 | EC §1 | *"MEASURED, **ON THIS TREE**: 103 asserting statements, 125 members, 10 CONJUNCTIONS and 9 ALTERNATIONS"* | `check_ec` prints the live figures every battery (§5d) | **FIGURE: "ON THIS TREE" deleted.** The figures stay as EC's evidence under the block's EC §1 heading |
| A8 | 583 | ED §2 | *"The live figure is 1014."* | The manifest holds 1,127 source-haystack pins today, and `check_ed` enforces them | **FIGURE: the sentence is deleted** |
| A9 | 864 | *Gates that pass* | *"`test_batch_cd` §1 is what diffs them."* (FZ's first) | The differ has been `check_de` since DE. The file's own DE block, and a later copy of this same bullet at lines 1120–1123, say so | **GONE: deleted** |
| A10 | 870 | *Gates that pass* (DD §1) | *"IT IS `[checks_lo, checks_hi, fails_lo, fails_hi]` PER SUITE NOW, NOT A FLOOR."* | "It" is `test_batch_cd`'s table, which DE replaced with `check_de` over `baselines.json` | **GONE: deleted.** The rest of the sub-bullet is history |
| A11 | 876–877 | *Gates that pass* (DD §1) | *"`an` 6047–6063 (ten observations), `bk` 129–130 (five), `bo` 0–1 failures"* | These are DD's table rows. The live bands are `baselines.json`'s, and the file's FF §1 block says it restates none | **GONE: the figures are deleted** |
| A12 | 887 | *Gates that pass* (DD §1) | *"`bk` has not been exceeded and was not widened"* | This describes a band in the table that is gone | **GONE: deleted** |
| A13 | 888–890 | *Gates that pass* (DD §1) | *"AND IT COSTS 22 MINUTES … `run_battery.sh` carries `TMO[test_batch_cd]=2400`"* (FZ's second) | `run_battery.sh`'s own comment records that it went at DE | **GONE: the sub-bullet is deleted** |
| A14 | 944–946 | *Suites and the harness* | *"…and why a redirect decided in `Run._ready()` fires in all 98 battery targets and not just the two scene ones"* | `run_state.gd` has no `_ready()`. FI moved the redirect to `_init()`, because `_ready()` never fires on the 24 targets that `.new()` the script. The reason given belongs to the version that was replaced | **GONE: the clause is deleted** |
| A15 | 950 | *Suites and the harness* | *"`Run._ready()` points it at `Run.TEST_SAVE_PATH`"* | `Run._init()` does, for the same three kinds of process (`run_state.gd`:213) | **MOVED:** *"`Run._init()` points it at"* |
| A16 | 1033–1034 | *Verify before shipping* | *"The rule that binds it is in `CLAUDE.md`; this line is the pointer"* | FF §1 moved the parse-floor rule into this file. `CLAUDE.md` carries only its index row | **MOVED:** *"the parse-floor bullet above, in FF §1's block"* |
| A17 | 1036 | *Verify before shipping* | *"it walks the whole 211-ability corpus"* | `check_cm` walks `Classes.ability_corpus()`. 211 was the corpus at CM | **FIGURE: "211-" deleted** |
| A18 | 1432 | FR §5a/FS §1 | *"ten others name it"* | Eight other files name `docs/state.md` today. Seven do so in a comment, and `check_fr` names it in its §4 list | **FIGURE: "ten" deleted** |

**The edit is 16 hunks: 19 lines added and 28 removed, and the file went from 119,486 B to 118,337 B.** Every hunk
was read back as flattened prose, two lines either side, and each reads as intended.

### 3c. What was checked and kept

- **48 hold today**, and each was checked. The ones a later batch is likeliest to doubt are listed here:
  - *"Fourteen suites now read the archive"*: 14 do carry the archive anchor.
  - *"FIVE DIFFERENT FORMATS"*: a census of every suite's and gate's last count line finds exactly those five, one of
    them in two spellings.
  - *"Three are in use"*: these are the three alternatives in the battery's own count grep.
  - The AXIS/SYNERGY convention is pinned by six suites: bt, bu, bv, bw, cb and ce, from the manifest.
  - `check_ed` §2's holder regex is still line-bounded.
  - bk, bl and bm all parse the save version out of the source and assert a floor.
  - `test_batch_bx` binds `master` three times.
  - `RunSim` names `Profile` only in comments.
  - The four `class_name` globals exist.
  - The data files' whitespace is as the file says.

  Every other kept claim was checked the same way.
- **12 are dated readings or history, kept as such.** Two were decided rather than obvious:
  - **DM §2's *"FIVE sites"*** is DM's reading; `check_dm` prints the live count. **The same bullet says *"the live
    count is PRINTED now and the assertion is the property (`> 1`)"***, so the prose disclaims its own number in
    place.
  - **FH §2's headline** (*"… IS WRITING `user://run_save.bin`, AND TWENTY-FOUR OF THEM DELETE IT"*) has not been true
    since FI. **But the same block says so**: *"THAT WAS TAKEN AT BATCH FI AND THE RULE ABOVE IS DISCHARGED"*.
    Deleting the headline would restructure a block that `CLAUDE.md`'s index names, which is more than a bullet
    correction.
- **2 are dated readings that were not re-derived, and are said to be so:** DX §1's *"THIRTY-FIVE ASSERT A FLOOR
  NOW"* (DX's sweep predicate was not reproduced) and EU's *"ALL FIVE ARE CORRECT TODAY"* (the five functions were only
  confirmed to exist).

### 3d. Delete, correct, or drop the figure

**The brief's rule and the file's own rules each settle a different case.**
- **Where the configuration is gone, the claim is deleted.** That is DR's rule, which the brief carried, and it
  covers nine.
- **Where the thing only moved, the name is corrected.** That is the file's own EB §2 rule: *"correct the name where
  the thing only moved … deleting it throws away something true"*. The archive, the redirect, the parse-floor rule
  and the live size all still exist, so those four are corrections.
- **A stale figure is deleted rather than updated.** That is the file's DJ §3 rule: *"the fix is not a better number,
  it is fewer copies"*. Each of the five has an instrument or a pin holding the real number.

**One clause was deleted rather than renamed, on purpose (A14).** Renaming `_ready()` to `_init()` there would have
kept the clause's reason, and the reason is about the node existing after the first frame. That was the replaced
version's mechanism, and `_init()`'s is construction. Changing only the name would have made a sentence newly false
rather than merely stale.

### 3e. What the eighteen did not disturb

**The literal sweep, over every string literal of four or more characters in all 140 `.gd` files (24,874 needles):**
- **LOST, 1 needle:** `' lost, '`, owned by `check_de`, which does not read this file. It went with A5's *"it is lost
  with it"*.
- **GAINED, 1 needle:** `'/changelog-archive.html'`, from A4's corrected path. It is owned by `check_dv` and the
  fourteen archive readers. `test_batch_ce` is one of them and does read this file, and it read **1114 / 0**, its
  row, with the edit in place (§5c).
- Every needle the file's readers pin was untouched. That covers `check_ff`'s eight headings and eight body
  sentences, `check_ec`'s two, `check_fg`'s form and its `check_fg.gd`, and `test_batch_ce`'s two.

### 3f. The same shape outside the file, queued rather than fixed

- **`CLAUDE.md`'s index of the reference file (*"WHAT IS OVER THERE"*) has three rows whose rule is not over
  there:**
  - *A FALLBACK IS WHAT MAKES ITS CONSUMERS LOOK FINE* (FM §1) is a heading in neither file;
  - *A GATED RUNE AT A FLAT PRICE IS STRICTLY WORSE THAN A BARE ONE* (FN §1) is a `##` heading in `CLAUDE.md`
    itself;
  - *THE `.docx` EXPORTS STAY STALE* (FN §3) says in its own cell that `CLAUDE.md` carries it.

  The FR §5a/FS §1 block, which **is** over there, has no row. The index's *"The last four rows are FG's, FH's and
  FI's"* stopped being true when three more rows were added after them. `check_ff` §1 and §4 read that index, and the
  brief left `CLAUDE.md` out.
- **`scripts/run_state.gd`:198**, FI's header comment, says the redirect is *"decided once in `_ready()`"*. The
  comment fifteen lines below it says **"`_init`, NOT `_ready`"**, and that matches the code. The brief touches no
  game file.
- **`docs/state.md`'s *Knowledge sync, re-measured at EG* section** still carries EG's 104.70 KiB for this file. A3
  now points readers at `check_fr` §5.

All three are in `docs/state.md`'s queue, under *FOUND AT GA AND NOT FIXED*.

## §4 — WHAT WAS DELIBERATELY NOT DONE

- **The relic redirect is deferred, as ruled**, until the game runs and can be test-played. `docs/state.md`'s item now
  leads with the ruling and FY's measurement:
  - four gates reach `Relics.unlock_random()` 14 times a battery;
  - that is harmless only while every relic is unlocked (25 of 25 at GA);
  - the first locked relic makes it permanent, at up to 14 random unlocks a battery.
- **Deepening Hex's floor stays at 8**, which confirms FY's reading. Its card wording is not touched.
- **No spec dissolved, no pool merged, no engine became a rune, and no spine was attached** (`check_ft` §0, §5).
- **No node, magnitude or rune moved.** Every file under `scripts/` and `data/` is byte-unchanged. That includes
  Enemies Look Past You, which waits on the pick in NEEDS A RULING.
- **`CLAUDE.md`, `docs/master.html` and `docs/systems-recon.html` are not edited**, for the reasons in §0 row 24 and
  §2c. `baselines.json`, `pin-manifest.json` and every gate and suite are untouched.

## §5 — VERIFICATION

**Sized first, by FZ's rule.** Each edited document's readers were taken by a census of every `.gd` file for its
`res://` path:
- `docs/instrument-rules.md` has five readers (`check_ec`, `check_ff`, `check_fg`, `check_fr`, `test_batch_ce`);
- `docs/changelog.html` has seventeen (three gates and fourteen suites);
- `docs/design-notes.md` has four (`check_ec`, `test_batch_bn`, `test_batch_bs`, `test_batch_ce`);
- `docs/state.md` has one (`check_es`);
- `docs/reports/` has none.

That set the size of each run. The reconnaissance run is 76 targets, priced at FZ's 31 m 42 s for the same 76. The
acceptance battery is 108, priced at 46 minutes.

### 5a. The saves, backed up and hashed before anything ran

`save-backups/GA-20260911-231418/` holds all four files. Each is md5-identical to the live file and to FZ's backup:

| File | md5 | Last written |
|---|---|---|
| `profile.json` | `b05e329b4d9c40cb1745602ab6d6ddb3` | 2026-09-10 21:01 |
| `run_save.bin` | `c44d45da3d06b316717f82354816ce4c` | 2026-09-08 13:45 |
| `relics.json` | `fdc12ffa02bf6e18289928bd6998a673` | 2026-08-30 17:42 |
| `settings.cfg` | `0c1b39c343382611fd6e340673ae5580` | 2026-08-21 11:43 |

**The relic file cannot be written by this batch's batteries, and that was checked rather than assumed.** It holds 25
ids, the 25 keys of `Relics.POOL`, and none is locked.

### 5b. The batch's own instrument, armed before it was trusted

**The literal sweep.** It reads every string literal of four or more characters in all 140 `.gd` files: both quote
styles, triple quotes too, with comments removed by a tokenizer and format strings split into their fixed fragments.
That is **24,874 needles**. Each was tested raw, lowered and whitespace-flattened against HEAD's copy and the working
copy of each edited document.
- **On the unedited tree it read 0 LOST and 0 GAINED** in all five documents.
- **Armed with a same-length injection on a copy**, it bit. `NEVER PROVE A SPLIT BY COMPARING SIZES` became `…SIZEX`
  at its one occurrence, and the sweep read LOST 1, owned by `check_ff` and flagged as a reader of the file.

### 5c. The edited documents, checked before any battery

- **`docs/instrument-rules.md`'s five readers, run standalone on the corrected file:** `check_ec` 23 / 0, `check_ff`
  55 / 0, `check_fg` 22 / 0, `check_fr` 25 / 0 and `test_batch_ce` 1114 / 0. Each is its row, with 0 throws.
- **`check_fr` §2, reproduced:** it compared 106 lines of 190, and no line of `docs/ways-of-working.md` is a second
  copy in either rule file.
- **`check_es` §4, reproduced on HEAD's and the new `docs/state.md`:** 2 windows and 4 figures on both (BREAK ten,
  DEBUFF FIVE, twice). `check_es` run standalone read 57 / 0.
- **The sweep over the five final documents:**
  - `docs/instrument-rules.md`: LOST `' lost, '`, owned by `check_de`, which does not read it. GAINED
    `'/changelog-archive.html'`; its one owner that reads the file is `test_batch_ce`, at 1114 / 0.
  - `docs/changelog.html`: 0 LOST. 11 needles GAINED, and two are owned by readers. `'DEFERRED'` is asserted by
    `test_batch_bs` against `master.html`, not the changelog. `'PRESENT'` is a print label in `check_ec`.
  - `docs/design-notes.md`: 0 LOST, and 5 GAINED, none owned by a reader.
  - `docs/state.md`: 4 LOST and 26 GAINED. Its one reader, `check_es`, owns only message prefixes (`'§3: \`'`,
    `'§4: '`), and its §4 window reads the file identically.
  - `docs/reports/GA.md`: no reader.
- **The flattened read-back:** 16 hunks in `docs/instrument-rules.md` and 14 in `docs/state.md`, plus one insert each
  in the changelog and the design notes. Every one was read as prose, two lines either side.
- **One markup fix before the reconnaissance run.** The changelog entry's two lists had been written inside a
  paragraph. They now close the paragraph first, as the file's other entries do, and the sweep's readings did not
  move.

### 5d. HEAD's unmodified gates against the new tree, before the acceptance battery

**No gate was edited in this batch, so this run is both FA §1b's pass and the brief's standing line.** It used
`run_battery.sh`'s own subset mode, which always runs every gate, over the fourteen suites that open the changelog.
**The predictions were written to the scratchpad before the launch, and every one held.**

| Reading | Result |
|---|---|
| Targets | **76**: the 14 changelog suites, all 56 gates, the harness, both scene runs and `check_de` |
| Manifest (`.ran`) | 76 names, 76 unique, identical to the battery's own order; every log present |
| Parse floor | `Parse Error` on 0 lines and `SCRIPT ERROR` on 0 lines, across all 76 logs |
| Truncation | none |
| Suites and gates | every one at its row with 0 failures and 0 throws, except `check_cm_live` 13 / 4, the sanctioned red. Its four FAIL lines are identical, character for character, to the reference log |
| `check_fr` | **25 / 0**, printing *"compared 106 lines of 190"* and *"instrument-rules 118337 B"* |
| `check_es` | 57 / 0, reading `docs/state.md` as *"2 claim window(s), 4 figure(s)"* |
| `check_fg` | 22 / 0, with no warning |
| `check_ff` | 55 / 0, printing *"CHECKED 64 literals across 27 readers; 0 resolve only in the index"* |
| `check_ec` | 23 / 0. Its live figures are 112 statements, 130 members, 9 conjunctions and 7 alternations, the numbers A7 leaves to the gate |
| `check_fo`, `check_ez`, `check_ft` | 87 / 0, 98 / 0 and 140 / 0 |
| `test_batch_ce` | 1114 / 0 |
| `check_fx` | 353.6 s from its log's creation to its last write, against `TMO[check_fx]` = 720 |
| Harness | 22 / 382 / 8 |
| `check_de` | **321 / 1, and the one is the differ refusing to certify a subset**: *"32 DID NOT"*. There is no notice |
| The saves | md5 and modification time unchanged after the run |
| Wall clock | 23:42:52 to 00:14:32, 31 m 40 s |

**No red was unpredicted, so no dependency hid.** Nothing a target reads was edited after this run.

### 5e. The acceptance battery: the final tree, in the real repository, frozen

**It ran once, in the real repository, after the last edit to any file a target reads.** Every file was frozen
first, and the process table was read by rows before the launch and after the finish. It was empty both times. The
predictions were written to the scratchpad before the launch, and every one held.

| Reading | Result |
|---|---|
| Manifest (`.ran`) | 108 names, 108 unique, identical to the battery's own order; every log named in it is present |
| Parse floor | `Parse Error` on **0** lines and `SCRIPT ERROR` on **0** lines, across all 108 logs |
| Truncation | no TIMED OUT, no NO VERDICT and no INCOMPLETE. The seven targets that print no count each printed their end marker |
| Suites and gates | every target at its `baselines.json` row with 0 failures and 0 throws, except `check_cm_live` at 13 / 4, the sanctioned red. Its four FAIL lines are identical to the reconnaissance run's and to the reference log |
| `check_fr` | 25 / 0, printing *"compared 106 lines of 190"* and *"ways-of-working 12399 B, CLAUDE.md 309453 B, instrument-rules 118337 B"* |
| `check_es` | 57 / 0, reading `docs/state.md` as *"2 claim window(s), 4 figure(s)"* |
| `check_fg` | 22 / 0, with no warning. The changelog is 303,715 B and GA's entry is 3,262 B, so the file without it is 300,453 B, byte for byte the file FZ left. That leaves 96,285 B under the 400,000 B bar. `CLAUDE.md` is 37.80 KiB under its 340 KiB ceiling |
| `check_ff`, `check_ec` | 55 / 0 and 23 / 0 |
| `check_parse` | 182 / 0 |
| `check_ft` | 140 / 0, so §0 holds and no spine is attached |
| `check_fo`, `check_ez` | 87 / 0 and 98 / 0 |
| `test_batch_an` | 6053, inside its 6046–6063 band |
| `test_batch_ce` | 1114 / 0 |
| `check_fx`'s time | 353.5 s from its log's creation to its last write, against `TMO[check_fx]` = 720 s |
| Harness | 22 / 382 / 8 |
| `check_de` | **449 / 0, with no notices** |
| Wall clock | 00:16:26 to 01:02:38, 46 m 12 s |

### 5f. After it

**The freeze taken after the battery is identical to the one taken before it, line for line.** It covers 481
lines:
- **477 files by absolute path**: 384 tracked, 41 untracked (this report and `save-backups/` among them) and 52
  ignored outside `.godot`;
- **the four save files, with md5, size and modification time.**

**No target wrote the player's `profile.json`, `run_save.bin`, `relics.json` or `settings.cfg`, not even with
identical bytes**, because no modification time moved. Each is still md5-identical to the backup in §5a, and the
process table was as empty after the finish as before the launch.

**This section, 5e and the sixth item of the short version were written after the battery**, into a report no target
reads (§5's opening census). **Re-stamping the tree after writing them differs from the battery's closing freeze in
exactly one file, and it is this one.**

## §6 — WHAT MOVED

**DOCUMENTS.**
- **`docs/instrument-rules.md`**: the eighteen corrections of §3b, and nothing else.
- **`docs/changelog.html`**: the GA entry.
- **`docs/design-notes.md`**: the GA entry, covering why the replacement stopped, the crit ruling and its reason, why
  some claims were deleted and others corrected, and why the relic deferral carries its number.
- **`docs/state.md`**: rewritten. That covers:
  - the WHERE block;
  - FY §1's four items, ruled;
  - the relic item, deferred with its measurement;
  - FX's item 7, confirmed;
  - FZ's instrument-rules item, closed;
  - a new *FOUND AT GA AND NOT FIXED* item.
- **`docs/reports/GA.md`**: this report (**NEW**).

**NOT EDITED:** `CLAUDE.md`, `docs/master.html` and its stamp, `docs/systems-recon.html`, `docs/ways-of-working.md`,
`baselines.json`, `pin-manifest.json`, every gate and suite, and every `scripts/` and `data/` file.

**NOT COMMITTED.** `save-backups/GA-20260911-231418/` holds the four save files, like every batch's backup. It is
untracked, as that folder has always been.

**THE PUSH CHECK.** A commit cannot carry its own hash, so the result of `git ls-remote origin class-merge`, checked against local HEAD, is reported with the handover after the push.
