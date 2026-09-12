# BATCH FZ — A BRIEF PRICES WHAT IT ASKS FOR

**THE SEVENTH BATCH ON `class-merge`. One rule, written into `docs/ways-of-working.md`.** No game code, no data
file, no node, no rune and no magnitude moved. `main` is untouched.
- **§1: the rule**, beside *DESIGN IS SETTLED BEFORE A BRIEF EXISTS*, with its three instances attached.
- **§2: the corollary was already written**, in `docs/instrument-rules.md` since DE, so it was pointed at and not
  written again.
- **§3: the rule cannot be asserted.** `check_fr.gd`'s header now says so; that header comment is the only change to
  an instrument.
- **§4: verification**, including the reconnaissance run of HEAD's unmodified gates against the new tree.

---

## NEEDS A RULING

**Nothing.** Every finding below is a queue item or a correction to a brief's quotation, and none is player-facing.

## THE SHORT VERSION

1. **THE RULE IS WRITTEN.** Before an instruction that sweeps, censuses, drives or walks a population, the brief states
   how large that population is and roughly what the work costs, and asks for the size first when it does not know.
   It carries its three instances, quoted from the briefs themselves (§1).
2. **NOTHING ALREADY RECORDED SAYS IT.** Three rule files and `docs/state.md` were swept for the concept. The nearest
   rules settle what a brief asks for and check what it claims; none prices an instruction (§1a).
3. **THE COROLLARY IS ALREADY A RULE.** `docs/instrument-rules.md`'s DE block says a suite that spawns suites squares
   the work when you widen it. The DD instance points at it. **Asking a brief to name what a widening multiplies is the
   new rule applied to a widening**, so a line of its own would have been a second copy (§2).
4. **NOTHING IN THE TREE CAN CHECK THE RULE**, because no brief is in the repository. `check_fr.gd` now says so in its
   header, beside the six rules it already could not assert. It gained no arm and stays at 25 checks (§3).
5. **THE BRIEF'S THREE INSTANCES HOLD; THREE INCIDENTAL CLAIMS DID NOT** (§0). DD's file is `test_batch_cd`, and there
   has never been a `check_cd`. DE did not undo DD's widening; it moved the comparison out of the suite. All three
   quotes are paraphrases.
6. **FOUND BESIDE THE COROLLARY:** two bullets in `docs/instrument-rules.md` still describe DD's differ in the present
   tense, about 600 lines below the DE rule that says both things went. Queued, not rewritten (§5).
7. **THE ACCEPTANCE BATTERY IS GREEN AND MOVED NOTHING.** All 108 targets read their rows, `check_de` 449 / 0 with no
   notices, and `Parse Error` appeared on 0 lines in any log. The one red is the sanctioned `check_cm_live` 13 / 4, with
   its FAIL lines unchanged. The tree and the player's four saves were identical before and after the run. HEAD's
   unmodified gates were run against the new tree first, and no red was unpredicted (§4).

---

## §0 — THE BRIEF'S PREMISES

Each was checked against the repo, the reports and the briefs themselves before anything was edited.

| # | Premise | Verdict | What the record says |
|---|---|---|---|
| 1 | *"Small. One rule, in `docs/ways-of-working.md`"* | **HELD** | One `##` block. No other rule was rewritten |
| 2 | *"On `class-merge`"* | **HELD** | HEAD was `5434130`, equal to `origin/class-merge` before anything moved |
| 3 | DD's instruction was *"widen `check_cd` to all 45 suites"* | **THE FILE IS WRONG AND THE QUOTE IS A PARAPHRASE** | DD's brief §1 reads *"Widen it to all 45, with `state.md`'s current table as the baseline"*, where "it" is `test_batch_cd`'s count table. **No `check_cd.gd` exists, and none ever has** (`git log --all` over the path is empty) |
| 4 | It was one line | **HELD** | One line of DD's brief |
| 5 | It took the battery from 29.6 to 50 minutes | **HELD** | `docs/reports/DD.md`: 29.6 min before, about 50 after. DE measured the unmodified tree at **2,996 s, 49.9 min** |
| 6 | By widening a suite that spawns suites | **HELD** | `test_batch_cd` §1 spawned a child Godot per suite (`docs/reports/DE.md`) |
| 7 | *"DE had to undo it"* | **PARTLY** | **DE did not undo the widening.** It moved the comparison out of the suite into `check_de`, a post-pass over the battery's logs, and the coverage stayed (and grew, to the gates, the harness and the scene runs). The battery came back to **29.2 min** at DE's acceptance run |
| 8 | FY's §5 census was modelled on FI's | **HELD** | FY's brief: *"the equivalent census has never been taken for the profile. Take it."* |
| 9 | FI's ran 98 targets, each alone, against a fresh copy | **HELD** | `docs/reports/FI.md` §1: every one of the 98 battery targets, alone, against a fresh copy of the run save restored before each |
| 10 | *"The sentence was eight words"* | **CLOSE, NOT EXACT** | The instruction is the clause *"report whether any OTHER target writes profile.json"* (7 words) and the sentence *"Take it."* (2). The sentence carrying the clause runs to 34 words. Counted in code |
| 11 | FY §1 said *"report the failure mode across all 27"* | **A PARAPHRASE** | The sentence is *"Report the failure mode across the whole 27, not just the four."* The heading above it reads *"ACROSS ALL 27"* |
| 12 | Read as a drive, that is 27 nodes on four classes, 108 live battles | **THE ARITHMETIC HOLDS** | 27 × 4. FY in fact read each read site to its guard chain and drove only the plumbing, on all twelve specs, in a probe (`docs/reports/FY.md` §1b) |
| 13 | FL found all six charter bullets already recorded and wrote none again | **HELD** | FL's commit, §2 |
| 14 | DE recorded the lesson and may have said it in a rule file | **HELD, WITH THE FILE NAME CORRECTED** | `docs/instrument-rules.md` line 259 onward (§2) |
| 15 | `check_fr` reads `ways-of-working.md` and asserts what it can | **HELD** | It is the file's only reader: a census of every `.gd`, `.sh` and `.py` for the path finds `check_fr.gd` alone |
| 16 | The rule is prose about how a brief is written and probably not assertable | **HELD** | No brief is tracked (`git ls-files` holds none), so no file differs by whether an instruction was priced (§3) |
| 17 | *"and the stamp"* | **READ AS `docs/state.md`'s *Last rewritten* LINE** | `docs/master.html` is not edited, because nothing a player can meet changed, so its stamp does not move. **This is FU's reading of the same words** (FU §0). FT, FU, FV and FW edited neither `master.html` nor its stamp, and FU's and FV's briefs give the reason: nothing a player can meet had changed |

**None of the three corrections changes the rule.** They change what its history says, and the history is now in the
file in the briefs' own words.

## §1 — THE RULE

### 1a. What was already there

**The brief said to check before adding, so the concept was swept, not the wording.** `CLAUDE.md`,
`docs/instrument-rules.md`, `docs/ways-of-working.md` and `docs/state.md` were grepped for pricing, a population's
size, what work costs, widening, and a brief's cost in time or batteries. **Nothing states the rule.** The nearest
three are different rules:
- *DESIGN IS SETTLED BEFORE A BRIEF EXISTS* (`docs/ways-of-working.md`) settles WHAT a brief asks for;
- *VERIFY THE BRIEF AGAINST THE REPO BEFORE IMPLEMENTING IT* (`CLAUDE.md`) checks what a brief CLAIMS;
- *RECON BEFORE AUTHORING* reads out what already exists before content is written.

None of them asks what an instruction costs.

### 1b. Where it went, and why there

**Directly after *DESIGN IS SETTLED BEFORE A BRIEF EXISTS*.** That rule makes the brief a transcription of settled
content; this one adds the price to the transcription, so they read as a pair. **It also sits above the branch
section**, which the file's preamble names as the part checked by nobody. That is true of this rule too (§3).

### 1c. What it says

The rule's three paragraphs are the brief's, transcribed. **The instances are quoted from the briefs rather than from
the brief's paraphrase of them** (§0 rows 3, 10 and 11):
- **DD §1**, *"Widen it to all 45."* Its table was `test_batch_cd`'s. The suite spawned a child Godot per suite, so
  the battery went from 29.6 minutes to about fifty. DE moved the comparison out, and the DD bullet points at DE's
  rule for why (§2).
- **FY §5**, *"report whether any OTHER target writes profile.json"*, then *"Take it."* It was modelled on FI's
  census, 98 targets each alone against a fresh copy. **FI measured the act as well** (its save functions printed),
  so the act is not the difference. **Isolation is**: FY ran every target once in a single copy, and each write
  printed its path into its own target's log, so the census fitted inside the reconnaissance battery FY already owed.
  The bullet says the method set the price, and the brief named neither. **The first wording said *"FY measured the
  act instead"*, as if FI had not; it was corrected after the reconnaissance run and before the acceptance run** (§4).
- **FY §1**, *"Report the failure mode across the whole 27, not just the four."* Read as a drive, that is 108 live
  battles, and what was wanted was a reading for the shape.

**ONE WORDING WAS FORCED BY THE FILE'S OWN READER.** The FY quote carries `profile.json` in code formatting in the
brief. **Written with backticks, it would turn `check_fr` §3 red**, because that arm resolves every backticked file
name in the document and there is no `profile.json` at `res://` or `res://docs/`. This was proved on a copy (§4b). The
quote keeps its words and drops the backticks.

**AND ON THE FILE'S *"NO HISTORY"* CLAUSE.** The preamble says the file has *"no batch blocks, no measurements that go
stale and no history"*, and the brief asked for the history. **They do not conflict in practice.** *RECON BEFORE
AUTHORING* already carries its instance with batch codes (FJ, EZ, FA–FE), and `check_fr` §5 enforces only the
batch-block heading and the timestamp. The instances are dated figures that cannot go stale, attached to a rule, and
there is no `BATCH` heading.

## §2 — THE COROLLARY IS ALREADY RECORDED, SO NOTHING WAS WRITTEN

**The brief's question: does `docs/instrument-rules.md` or `CLAUDE.md` already say this?**
- **`docs/instrument-rules.md`: YES.** *THE COUNT DIFFER IS A PROPERTY OF THE RUN, NOT OF A SUITE IN IT (STANDING, SET
  AT BATCH DE)*, lines 259–262, opens: *"A suite that spawns suites **squares the work when you widen it**, so the
  instrument gets more expensive exactly as it gets more useful — and the only lever left is to watch less."* That is
  the corollary's mechanism, with DD as its case.
- **`CLAUDE.md`: only the heading**, as a row of its index of moved rules (line 82). By `CLAUDE.md`'s own index bullet,
  heading text is not the rule.
- **DE's own report and DE's brief both call it *"a design error in DD's brief, not an implementation one"***. That is
  the brief-writing reading of it, and it lives only in a closed report and a brief.

**The corollary's first sentence — *"an instruction that WIDENS something should name what it multiplies"* — is not
written anywhere in those words.** It is §1's rule applied to one case: a widening is an instruction over a population,
and what it multiplies is its size. **A line of its own would be a second copy of §1**, which is the defect the file's
preamble exists to prevent. So nothing was written. The DD instance ends by pointing at the DE rule by its heading.

## §3 — THE RULE CANNOT BE ASSERTED, AND WHERE THAT IS SAID

**Confirmed, not assumed.** No brief is tracked: `git ls-files` holds no brief, and the briefs live outside the
repository. So there is no file whose contents differ according to whether an instruction was priced, and no arm could
tell a priced brief from an unpriced one. **An arm claiming to would always pass**, which `check_fr`'s header already
names as worse than none.

**Said in three places, none of them an assertion:**
1. **`check_fr.gd`'s header**, *"WHAT THIS GATE CANNOT DO, SAID FIRST"*. It read *"Six of its eight rule blocks"* and
   enumerated the six. **With a ninth block that count would have gone stale**, so it reads *"Seven of its nine"* now,
   names *"a brief pricing what it asks for"* among them, and gives the reason: a brief is not in the repository.
2. **The rule's own last bullet**: *NOTHING IN THE TREE CAN CHECK THIS RULE.*
3. **The file's preamble**, unedited, already says the rules above the branch section are checked by nobody. The rule
   was placed above it (§1b).

**The edit to `check_fr.gd` is comments only**, proved by a diff with comment and blank lines stripped from both sides
(empty). It gained no arm, so it stays at **25 checks** and its `baselines.json` row does not move.
`build_pin_manifest.py --check` reads *current (1460 pins)* after it.

**AND THE BRIEF'S *"PAIR EVERY NEGATIVE ANCHOR WITH A POSITIVE ARM"*.** No gate gained an arm, so no gate gained a
negative anchor. The batch's own instruments pass by finding nothing, so each was armed before it was trusted (§4b).

## §4 — VERIFICATION

**Sized first, by the rule this batch writes.** Each edited document's readers were taken by a census of every `.gd`,
`.sh` and `.py` file for its path:
- `docs/ways-of-working.md` has one reader (`check_fr`);
- `docs/state.md` has one (`check_es`);
- `docs/changelog.html` has seventeen (three gates and fourteen suites);
- `docs/reports/` has none.

That set the size of each run. Priced before and measured after:
- **the reconnaissance run, 76 targets**: the fourteen changelog suites, every gate, the harness, both scene runs and
  `check_de`. It took **31 m 42 s**;
- **a pre-pass, 10 targets**: the ten that read `check_fr.gd`'s source or `ways-of-working.md`. It took **36 s**;
- **the acceptance battery, 108 targets**, priced at FY's measured 46 minutes. It took **46 m 30 s**.

No target needed running alone. Nothing in this batch touches a save, and every save write the census knows of goes to a
scratch file (FY §5b).

### 4a. The saves, backed up and hashed before anything ran

`save-backups/FZ-20260911-183001/` holds all four files, each md5-identical to the live file and to FY's backup:

| File | md5 | Last written |
|---|---|---|
| `profile.json` | `b05e329b4d9c40cb1745602ab6d6ddb3` | 2026-09-10 21:01 |
| `run_save.bin` | `c44d45da3d06b316717f82354816ce4c` | 2026-09-08 13:45 |
| `relics.json` | `fdc12ffa02bf6e18289928bd6998a673` | 2026-08-30 17:42 |
| `settings.cfg` | `0c1b39c343382611fd6e340673ae5580` | 2026-08-21 11:43 |

**The relic file cannot be written by this battery, and that was checked rather than assumed.** It is the queue item
FY found: four gates reach `unlock_random()`, which saves only when a relic is locked. The file holds 25 ids, and the
25 keys of `Relics.POOL`, parsed out of `scripts/relics.gd`, are exactly those 25. None is locked.

### 4b. The batch's own instruments, each armed before it was trusted

The first two pass by finding nothing, so each was shown to bite before it was trusted. The third was anchored to the
gate's own reading instead.
- **The literal sweep.** It reads every string literal of 4+ characters in all 140 `.gd` files in the repo (both quote
  styles, comments removed by a tokenizer, format strings split into their fixed fragments): **24,582 needles**. Each
  was tested against HEAD's copy and the working copy of each edited document, in one pass, raw, lowered and
  whitespace-flattened.
  - On the unedited tree it read **0 changes**.
  - Armed with same-length edits, it bit both times. `THE FILES EVERY BATCH WRITES` → `…WRITEZ` in a copy of
    `ways-of-working.md` read LOST, owned by `check_fr.gd`. The archive anchor `/changelog-archive.html</code>` with one
    letter recased in a copy of the changelog read LOST in its raw and flat forms, owned by `check_dv` and the suites.
    **The first changelog injection changed one of its three occurrences and read nothing**, so it was re-armed on all
    three.
- **`check_fr`'s arms, reproduced in Python** (§1's extractor, §2's 60-character comparison, §3's path resolver, §4,
  §5 and §6). They were anchored on HEAD's copy, where they reproduce the gate's own printed figures from an earlier log
  (*"compared 82 lines of 154"*, *"14 distinct paths"*). Two controls on copies bit:
  - a line copied from `docs/instrument-rules.md` read §2 red;
  - FY's quote with `profile.json` in backticks read §3 red, as a dead pointer. That is why the rule's quote has none.
- **`check_es` §4's regex window, reproduced** on HEAD's and the new `docs/state.md`: 2 windows and 4 figures on both.
  `check_es` itself printed the same reading for `docs/state.md` in both runs below.

**What the sweep found, and why none of it matters to a verdict:**
- `ways-of-working.md`: **0 LOST**, and 99 GAINED readings (44 distinct needles over the three forms). Every one is a
  short word or a print fragment owned by a target that does not read the file (for example `'seven'`, `'walk'`,
  `'test_'`, `'profile.json'` owned by `check_fq`, and `'single'` owned by `check_ec`). **None of `check_fr.gd`'s 74
  literals, at any length, changes presence in the file.**
- `docs/changelog.html`: **0 LOST**, and one needle GAINED in all three forms: `' suites; '`, a fragment of two `print`
  formats in `check_da`, which does not open the changelog.
- `docs/state.md`: 22 LOST and 8 GAINED readings (9 and 3 distinct needles), from the replaced WHERE block. **Its one
  reader, `check_es`, owns none of them**, and its §4 window reads the file identically.

### 4c. HEAD's unmodified gates against the new tree, before any gate was edited

The brief's standing line, and FA §1b's rule. The tree carried FZ's three documents, and `check_fr.gd` was
byte-identical to HEAD. **The predictions were written to the scratchpad before the run was read.** Every one held:

| Reading | Result |
|---|---|
| Targets | **76**: the 14 suites that open the changelog, all 56 gates, the harness, both scene runs and `check_de` (`run_battery.sh`'s own subset mode, which always runs every gate) |
| Parse floor | `Parse Error` on 0 lines and `SCRIPT ERROR` on 0 lines, across all 76 logs |
| Truncation | none |
| Suites and gates | every one at its row with 0 failures and 0 throws, except `check_cm_live` 13 / 4 (the sanctioned red). Its four FAIL lines are identical, character for character, to a same-day reference log |
| `check_fr` | **25 / 0**, printing *"compared 105 lines of 190"*, *"14 distinct paths named"* and *"ways-of-working 12352 B"*, exactly as reproduced beforehand |
| `check_es` | 57 / 0, reading `docs/state.md` as *"2 claim window(s), 4 figure(s) read"* |
| `check_fg` | 22 / 0, the changelog at 300,453 B against a 400,000 B bar, with no warning |
| Harness | 22 / 382 / 8 |
| `check_de` | **321 / 1, and the one is the differ refusing to certify a subset**: *"every recorded target ran in this battery — 32 DID NOT"*. That was predicted, and no other arm moved |
| The tree | frozen across the run: 475 lines (471 files by absolute path, tracked, untracked and ignored outside `.godot`, plus the four saves), 0 differ |
| Wall clock | 18:42:28 to 19:14:10 |

**No red was unpredicted, so no dependency hid.**

### 4d. What changed after it, and the pre-pass over the final tree

**Two edits, both after that run and before the acceptance run:**
- **`check_fr.gd`'s header comment**, now that the unmodified gate had read the new rule. The diff of `check_fr.gd`
  against HEAD, with comment and blank lines stripped from both sides, is empty. Its 74 string literals are identical
  to HEAD's, and `build_pin_manifest.py --check` reads *current (1460 pins)*.
- **One bullet of the rule itself: the FY §5 instance.** It said *"FY measured the act instead"*, and FI measured the
  act as well. The difference is isolation against attribution by log, and the bullet now says that (§1c). It is one
  sentence inside one bullet, and it touches no backticked path and no heading. `check_fr`'s reproduction reads it at
  0 failures (*"compared 106 lines of 190"*), and the literal sweep's only new presence is `'single'`, owned by
  `check_ec`, which does not read the file.

**Then a pre-pass on the final tree, of every target that reads `check_fr.gd`'s source or `ways-of-working.md`**, run
with `run_battery.sh`'s own command line:
`check_fr` 25, `check_parse` 182, `check_da` 43, `check_ec` 23, `check_ed` 18, `check_ea` 86, `check_ff` 55,
`check_ek` 46, `check_es` 57 and `test_batch_cd` 99. **Every one is at its row with 0 failures**, and there were 0
`Parse Error` or `SCRIPT ERROR` lines. `check_fr` printed *"compared 106 lines of 190"* and *"ways-of-working 12399 B"*.

### 4e. The acceptance battery: the final tree, in the real repository, frozen

**It ran once, in the real repository, after the last edit to any file a target reads.** Every file was frozen first,
and the process table was read by rows before the launch and after the finish. Nothing else was running either time.
The predictions were written to the scratchpad before the launch, and every one held:

| Reading | Result |
|---|---|
| Manifest (`.ran`) | 108 names, 108 unique, in the battery's own order; every log named in it is present |
| Parse floor | `Parse Error` on **0** lines and `SCRIPT ERROR` on **0** lines, across all 108 logs |
| Truncation | no TIMED OUT, no NO VERDICT and no INCOMPLETE; `check_map_screen`, which prints no count by design, printed its end marker |
| Suites and gates | every target at its `baselines.json` row with 0 failures and 0 throws, except `check_cm_live` at 13 / 4 (the sanctioned red). Its four FAIL lines are identical to the reconnaissance run's and to the same-day reference |
| `check_fr` | **25 / 0**, printing *"compared 106 lines of 190"*, *"14 distinct paths named, 1 template shape(s) exempt"* and *"ways-of-working 12399 B, CLAUDE.md 309453 B, instrument-rules 119486 B"* |
| `check_es` | 57 / 0, reading `docs/state.md` as *"2 claim window(s), 4 figure(s) read"* |
| `check_fg` | 22 / 0. The changelog is 300,453 B with FZ's entry at 2,131 B, which leaves 99,547 B under the 400,000 B bar. `CLAUDE.md` is 37.80 KiB under its 340 KiB ceiling. No warning |
| `check_parse`, `check_ed` | 182 / 0 and 18 / 0 |
| `check_ft` | 140 / 0, so §0 holds and no spine is attached |
| `check_fo`, `check_ez` | 87 / 0 and 98 / 0, FY's rows |
| `test_batch_an` | 6054, inside its 6046–6063 band |
| `check_fx`'s time | **354 s** from its log's creation to its last write, against `TMO[check_fx]` = 720 s |
| Harness | 22 / 382 / 8 |
| `check_de` | **449 / 0, with no notices** |
| Wall clock | 19:17:07 to 20:03:37, 46 m 30 s |

### 4f. After it

**The freeze taken after the battery is identical to the one taken before it, line for line.** It covers 476 lines:
- **472 files by absolute path**: 383 tracked, 37 untracked (this report's draft and `save-backups/` among them) and
  52 ignored outside `.godot`;
- **the four save files, with md5, size and modification time.**

**No target wrote the player's `profile.json`, `run_save.bin`, `relics.json` or `settings.cfg`**, not even with
identical bytes, because no modification time moved. Each is still md5-identical to the backup in §4a.

**This section and the short version were written after the battery**, into a report no target reads (§4's opening
census). **Re-stamping the tree after writing them differs from the battery's closing stamp in exactly one file, and
it is this one.**

## §5 — FOUND AND NOT FIXED

**`docs/instrument-rules.md` STILL DESCRIBES DD's DIFFER IN THE PRESENT TENSE.** Two bullets under *GATES THAT PASS
WITHOUT ASKING THEIR QUESTION* were written at DD:
- line 864: *"`test_batch_cd` §1 is what diffs them."*
- line 888: *"AND IT COSTS 22 MINUTES: IT RUNS THE BATTERY INSIDE THE BATTERY. `run_battery.sh` carries
  `TMO[test_batch_cd]=2400` for that"*

**Both went at DE.** The DE rule at line 255 says *"`TMO[test_batch_cd]=2400` is gone"* and that the differ is
`check_de`. `run_battery.sh`'s own comment (line 171) says the same, and `test_batch_cd.gd`'s header says its §1
*"USED TO SPAWN FORTY-FIVE CHILD GODOTS"*. **One file gives two readings of one fact, about 600 lines apart.**
- No gate pins either sentence (a sweep of every `.gd` for both found nothing).
- The repair is a change of tense and a pointer to the DE block. **It is not taken here**, because the brief forbade
  rewriting any other rule. It is queued in `docs/state.md`.

**AN OBSERVATION ON THE RULE'S REACH, RECORDED AND NOT QUEUED.** The verification lines every brief carries —
*"Run the unmodified gates against the new tree"*, and the acceptance battery — are instructions over a population, and
they arrive without a size. This batch sized them itself from a census of each document's readers, and §4 opens with
what that came to.

## §6 — WHAT MOVED

**DOCUMENTS.**
- **`docs/ways-of-working.md`**: *A BRIEF PRICES WHAT IT ASKS FOR*, a new `##` block after *DESIGN IS SETTLED BEFORE A
  BRIEF EXISTS*. Nothing else in the file changed.
- **`docs/changelog.html`**: the FZ entry.
- **`docs/state.md`**: rewritten. The WHERE block is FZ's, and one queue item is new (§5).
- **`docs/reports/FZ.md`**: this report (**NEW**).

**INSTRUMENTS.**
- **`check_fr.gd`**: its header comment only (§3). Still 25 checks.

**NOT EDITED:** `CLAUDE.md`, `docs/instrument-rules.md`, `docs/master.html` and its stamp, `docs/design-notes.md`,
`baselines.json`, `pin-manifest.json`, every `scripts/` and `data/` file, and every other gate and suite.

**NOT COMMITTED.** `save-backups/FZ-20260911-183001/` holds the four save files, like every batch's backup. It is
untracked, as that folder has always been.
