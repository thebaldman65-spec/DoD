# BATCH FS — CLEAN UP BEFORE THE BRANCH

**On `main`. The last batch before `class-merge` takes over.** Nothing touched `class-merge`, no
merge work was done, and **not one rune, card, ability, talent, constant or magnitude moved.** No
file under `data/` and no `.gd` under `scripts/` was edited.

---

## §0 — THE BRIEF'S PREMISES, CHECKED

| Premise | Verdict |
|---|---|
| §1 · `--quit-after` is FRAMES, not seconds | **TRUE** |
| §1 · three gates printed no verdict because they were truncated | **TRUE** — `check_cs`, `check_dk`, `check_dm` |
| §1 · that reads identically to the gates that print none by design | **TRUE**, and there are **seven** of those, not one |
| §1 · `check_cl_width` is one by design | **TRUE** |
| *(from `docs/reports/FR.md` §5a)* "`run_battery.sh` does not use the flag" | **FALSE — see §1a.** HEAD's line 176 passes `--quit-after 900` to `check_ct_map` |
| §2 · FR measured the doc-vs-code gate as not worth building: 1,265 comparisons, 3 raw flags, 0 true defects, none of the fourteen | **TRUE** |
| §2 · eight of twelve talent headings above the wrong tree's table while all 324 cells are correct | **TRUE** |
| §2 · "3 defects across 8 sites" | **PARTLY** — three defects (D10, D11, D5); **D10 alone is the 8 sites**, and the three together are ten |
| §2 · `check_es` prints the core-kit census every battery and asserts nothing about it | **TRUE** — and the arm bit **twice** on the live tree |
| §3 · reports are already deselected | **UNVERIFIABLE HERE, AND CONTRADICTED BY THE REPO** — see §3d |
| §3 · `DoD-archive/` is 14.2% of the sync | **STALE** — the same 1,680,660 B is **13.0%** today |
| §3 · the root suite block was 27% at CW with 44 suites; there are now 105 targets | **TWO POPULATIONS** — 105 was FR's battery TARGET count (this one runs 106); the FILE block is 104 at HEAD, **105 with `check_fs.gd`**, and misses five |
| §3 · `pin-manifest.json` was ruled deselected at EE | **TRUE as a ruling**; the picker's state is not in the repo |
| §3 · `text-audit.html` and `talent-audit.html` both ruled and applied | **HALF FALSE** — `docs/state.md` records that the talent audit **cannot** leave, DN §8 being open |
| §3 · the suites are at the repo ROOT, not in `scripts/` | **TRUE** — 110 root `.gd` files, `scripts/` holds zero suites |
| §5 · FR's repair shipped *"gold for maximum health for gold"* | **TRUE** (FR §5a(1)) |

---

## §1 — A TRUNCATED GATE MUST NOT READ LIKE A SILENT ONE

### §1a — THE FAULT, AND THE ONE PREMISE OF FR'S THAT WAS WRONG

`--quit-after N` counts **FRAMES**. FR used it as a hang guard on a doc pre-check, chose 900, and
three gates printed no summary line; the reading was nearly recorded as *"these three report no
readable count"*, which is a true and unremarkable property of **seven** targets in this battery.

**THE TWO OUTCOMES WERE MEASURED RATHER THAN ASSUMED TO BE INDISTINGUISHABLE.** `check_cs` was run
under `--quit-after 30` and with no flag at all:

| | exit code | log | verdict line |
|---|---|---|---|
| truncated at 30 frames | **0** | 6 lines of ordinary progress output | none |
| complete | **0** | full | `check_cs: 104 checks / 0 failures` |

**The exit code carries nothing**, which is the same reason this project's parse floor greps stderr.

**AND FR'S REASSURANCE WAS FALSE.** FR §5a(2) closes with *"`run_battery.sh` does not use the flag
— its watchdog is wall-clock — so the battery was never affected, only the pre-check."* **HEAD's
`run_battery.sh:176` reads `--quit-after 900 res://check_ct_map.tscn`.** The battery had exactly
one frame-budgeted target, and it was also one of the two targets written out by hand below the
`run_one` loop — so it had **no watchdog and no completion test either.** The one place the fault
could bite in the battery was the one place nothing was watching.

### §1b — THE FRAME BUDGETS, MEASURED

Bisected to ±14 frames, each boundary confirmed by re-running on both sides:

| gate | needs more than | completes at | 900 was |
|---|---|---|---|
| `check_cs` | 1504 | **1518** | 59% |
| `check_dk` | 3600 | **3614** | 25% |
| `check_dm` | 7101 | **7115** | 13% |

**A budget chosen for one fixture-driven gate is not a budget for another**: what a gate spends is
`await process_frame` calls, and those scale with what it drives.

### §1c — THE MECHANISM, AND IT IS THE ONE THE PROJECT ALREADY HAD

I did not build a new one. `baselines.json` has carried an **`expect`** string per row since DE — a
line only a COMPLETE run prints, asserted by `check_de` §1 — and it was set on **one** of the seven
rows that report no check count. Four changes:

1. **`expect` on all seven no-count rows.** Five already printed `NAME: 0 failures`; two printed no
   terminal line at all and were given one (`check_cl_width: report complete`,
   `check_map: report complete`, chosen to carry no digits so the failure grep's `tail -1` still
   reads the line the band is written against).
2. **`check_de` §2 refuses a `checks: null` row with no marker.** This is the part that makes it a
   fix rather than a repair: a future no-count target cannot join the table silently.
3. **`run_battery.sh` reads the same markers live** and prints
   `*** NO VERDICT — INCOMPLETE: no count and no 'NAME:' end marker (N log lines, --quit-after M
   FRAMES) ***`, naming the budget when there is one, instead of `checks=?` for both cases. A
   target that completes with no count now says `COMPLETE (prints no count by design)`, and one
   that completes with no count and no row saying so says that instead.
4. **The frame budget moved out of an inline literal into a per-target `QAF` table**, beside the
   `EXTRA` and `TMO` tables that already exist for exactly this, **and the two scene runs go
   through `run_one`** — so `check_ct_map` has a watchdog and a completion test for the first time.

**A COUNT IS ITS OWN MARKER, WHICH IS WHY THIS IS SMALL.** Every counting target prints its tally
in its final summary, so a count present already proves the target reached its end. The rule binds
only the seven an absent verdict says nothing about; writing it wider would have been ceremony.

### §1d — THE POPULATION THAT PRINTS NO VERDICT BY DESIGN, DERIVED

**Seven, and it is derived from `baselines.json`'s `checks: null` rows rather than inferred from a
run** — `check_de` §2 fails if the two populations disagree, so the list cannot be written twice
and drift:

| target | what it prints | why |
|---|---|---|
| `check_cl_resolver` | `check_cl_resolver: 0 failures` | resolver report; failures only |
| `check_cl_width` | *(nothing — now a marker)* | width REPORT; no checks and no failures |
| `check_cm` | `check_cm: 0 failures` | gate census; failures only |
| `check_cn` | `check_cn: 0 failures` | table census; failures only |
| `check_flow` | `check_flow: 0 failures` | flow walk; failures only |
| `check_map` | *(nothing — now a marker)* | generation REPORT; distributions only |
| `check_map_screen` | `check_map_screen: OK` | scene run; the one row that already had an `expect` |

`check_cl_width`'s `baselines.json` note said outright that *"the battery cannot see whether it
passed at all. Recorded so the state is a ratchet rather than a blind spot."* It still cannot see
whether it passed. **It can see whether it FINISHED**, which is the half §1 was asked for.

### §1e — PROVED IN THE BATTERY'S OWN OUTPUT, FOUR ARMS

| arm | result |
|---|---|
| A · `check_cs` under `QAF=30`, through the real `run_one` | `*** NO VERDICT — INCOMPLETE: no count and no 'check_cs:' end marker (7 log lines, --quit-after 30 FRAMES) ***`, **and `check_de` reds** on it independently |
| B · the same gate, budget removed | `checks=104 fails=0` |
| C · the new marker stripped from a COMPLETED `check_map` log | `FAIL: check_map still prints its verdict` |
| D · `expect` deleted from `check_cn`'s row | `FAIL: every no-count row carries an 'expect' completion marker … (missing: check_cn)` |

**ARM B IS THE ONE THAT MATTERS AND IT IS THE ONE THAT FOUND A DEFECT.** Arm A alone proves only
that the message can be printed. Arm B ran the same gate with the budget removed and it read
**TIMED OUT after 240s with a 2-line log** — because folding the scene runs into `run_one` I had
written `target=(${SCENE[$name]:---script $name.gd})`, and **zsh does not word-split an unquoted
expansion**, so the whole default arrived as ONE token, Godot never saw a `--script` flag and ran
the project instead. **That is the same fault as the flags STRING at the top of that very file**,
which cost a battery and carries a nine-line comment explaining itself. Reading the diff did not
find it; the second arm did. `baselines.json` and both touched files were restored by md5 and the
hashes verified after every arm.

---

## §2 — THE DOC-vs-DOC PAIRING CHECK

**`check_fs.gd`, 39 checks, no code involved, and it found a defect FR's own fourteen-defect read
missed.**

### §2a — WHAT IT ASSERTS

- **§1 — a §7 heading names the tree its table lists.** Each `<p><b>Spec</b> — <b>LANE</b> · … </p>`
  carries exactly three ALL-CAPS bold spans; the table within a few lines below carries a
  `<tr><th>Row</th><th>Lane</th>…` header. The three are compared case-blind, **in document order**,
  and three further things are asserted: that the section reads heading-then-table **twelve times
  over** (a heading that drifted below its own table still pairs by index), that twelve of each were
  found, and that **no spec heads two trees** — which is the shape a permutation repair risks and
  is *not* what caught FR's defect, because eight headings permuted among themselves leave every
  name present exactly once.
- **§2 — a count in a table's heading equals the rows in that table.** §6b states its size four
  times in one paragraph, in words. The numbers are read **as words** and not pinned as literals, so
  a batch that authors a card writes the new word and the arm follows it. Four comparisons and two
  pieces of the paragraph's own arithmetic: **127 stated = 127 rows**, **103 = rows before the
  first class-wide band**, **24 = rows in the class-wide bands**, **103 + 24 = 127**, and
  **154 − 127 = 27**, the remainder the same sentence names.
- **§3 — the liveness arm**, below.

### §2b — THE FINDING: THE ARCANIST'S THIRD LANE

The Arcanist heading named **`CONTROL`** over a table listing **`Entropy`**. `talents.gd` says why,
in its own words: *"THE LANE FORMERLY CALLED CONTROL IS **ENTROPY**: after Batch AS, 'Control' is
the Cryomancer's identity word, and the lane was never about control anyway."* The rename is Batch
AT's. **The heading has been wrong ever since, and it survived a batch that read every number in
the document.** It is the same shape as FR's D11 (the Sharpshooter's TEMPO/Pace), one spec along.

The heading now says `ENTROPY`. **It is one word and it is the only surface** — a flattened sweep
of `CLAUDE.md`, `state.md`, `master.html`, `design-notes.md`, `instrument-rules.md`,
`spec-recon.html` and `merge-recon.html` finds no second copy.

### §2c — WHAT THIS GATE CAN AND CANNOT SEE, STATED AT THE SITE

The brief asked for the boundary at the site, the way `check_fr` states first what it cannot
assert. It is in `check_fs.gd`'s header and it is printed on every run:

- **IT ASSERTS THAT TWO PARTS OF ONE DOCUMENT AGREE. IT CANNOT ASSERT THAT EITHER IS TRUE.** A
  heading and a table re-pointed at the wrong spec **together** agree, and this gate is silent on
  them. Only `master.html` §7 against `Talents.desc_for()` sees that, and FR measured all 324 cells
  clean.
- **A LANE RENAMED IN THE CODE AND IN NEITHER PLACE HERE** leaves the two halves agreeing. This is
  doc-vs-doc **by construction** — that is what makes it forty lines and what makes its failure mode
  noise rather than silence, and it is also its ceiling.
- **IT READS LANE NAMES AND ROW COUNTS. IT READS NO CELL.** A wrong magnitude inside a correctly
  paired table is invisible.
- **§2 CANNOT SAY THE POPULATION IS THE RIGHT ONE.** §6b catalogues 127 of a 154-card draft on
  purpose; which 27 are left out is an authoring decision, not a defect.

### §2d — AND THE FIRST DRAFT WAS WRONG IN THE WAY THIS SHAPE IS DANGEROUS

**It read nine headings of twelve and printed four confident mismatches, all four false.** Three
headings — the Arcanist's, the Holy's and the Devout's — wrap across a line break in the source; a
line-anchored match dropped them, and the nine survivors were then zipped against twelve tables and
slid three places out of step. **It did not look like a broken instrument. It looked like a
finding**, naming real specs with real lanes.

Everything is matched on a **whitespace-flattened** copy now, and §3 asserts the whole of what §1
and §2 rest on: the section boundaries resolve, the walk returns twelve headings and twelve tables,
**the three wrapped headings are pinned by name** so the flattening cannot be quietly removed, the
word reader is driven on four values and on a phrase holding no number, and **the lane comparison
is driven in both directions — through the same function §1 calls**, not a private copy of it.

### §2e — FR'S SECOND RECOMMENDATION: ONE ARM ON THE CENSUS `check_es` ALREADY PRINTS

`check_es` §4(2) has computed the per-spec core-kit tag census on every battery run since ES and its
own comment said *"It is a REPORT."* FR found *"DEBUFF for seven"* — **the census says five**, and
seven is the OFFENSE column — in three documents and corrected them, reporting the sweep clean.

**THE ARM WAS ARMED ON THE LIVE TREE AND BIT TWICE.**

| document | before FS | why FR's sweep missed it |
|---|---|---|
| `docs/master.html` | five ✓ | corrected at FR |
| `CLAUDE.md` | **seven** | reported as corrected at FR §2g; it was not |
| `docs/state.md` (archetype block) | FIVE ✓ | corrected at FR |
| `docs/state.md` (design-questions block) | **seven** | **`DEBUFF for` and `seven` wrap across a line break** — invisible to a line-anchored read |

Both are corrected. The gate compares **8 stated figures across 4 claim windows in 3 documents**
every battery, and the two documents that carry the claim *by rule* — `master.html` and `CLAUDE.md`
— each have a liveness arm, so a rewording that closes the window reds instead of reading clean.

**THE ARMS ARE A FIXED TEN, ONE PER DOCUMENT AND NEVER ONE PER FIGURE.** `docs/state.md` is inside
the swept population and is rewritten every batch, behind the verification run; a check count that
rose and fell with how often that file happened to state the claim would move in the batch AFTER
the one that caused it, and no baseline could hold it. **`check_es` is now the only gate that reads
`state.md`'s CONTENT** — ten other files name that path and every one of them does so in a comment
— so a batch that rewrites it owes `check_es` a re-run against the shipped tree. That obligation is
in `docs/instrument-rules.md`, and this batch pays it in §5.

**AND TWO DOCUMENTS CARRYING THE SAME FIGURE ARE DELIBERATELY OUT OF THE POPULATION.**
`docs/changelog.html` and `docs/design-notes.md` both say *"DEBUFF for seven"* inside dated,
per-batch entries recording what ES found and why. **Correcting a dated entry is rewriting
history** — the same reason `docs/talent-audit.html` and `docs/rune-audit.html` are kept as
written. A record of a measurement is not a claim about today, and the boundary is stated in the
gate.

---

## §3 — THE SYNC DESELECTION LIST

**Not a repo change. A list for the designer's file picker.** Every file below stays tracked and
Claude Code goes on reading it off disk. **Nothing was deleted and nothing moved.**

### §3a — WHAT I CAN AND CANNOT CONFIRM, SAID FIRST

The brief asks three times to *"confirm whether it is still selected"* / *"confirm it stayed that
way."* **I cannot.** The picker's selection state lives in the connector's configuration, not in
the repo; no file in the tree records it and no instrument can read it. What the repo holds is the
**rulings** — `CLAUDE.md`'s deselection block and its MUST-STAY-SELECTED list — and those I have
read and re-derived. Where a ruling and the brief disagree, §3d says so rather than picking one.

### §3b — THE LEDGER, RE-DERIVED

*The sync set is `claude_md_census.py`'s own definition: every TRACKED file outside `assets/` whose
extension is one of `.gd .md .json .html .sh .py`. Figures are measured on the shipped tree with
this batch's files staged.*

| item | files | bytes | MiB | share of the sync |
|---|---|---|---|---|
| **the sync set today** | **241** | **13,017,203** | **12.4142** | 100% |
| `DoD-archive/` | 2 | 1,680,660 | 1.6028 | **12.91%** |
| root `test_batch_*.gd` + `check_*.gd` | 105 | 3,107,030 | 2.9631 | **23.87%** |
| `pin-manifest.json` | 1 | 333,103 | 0.3177 | 2.56% |
| `docs/text-audit.html` + `docs/talent-audit.html` | 2 | 212,616 | 0.2028 | 1.63% |
| `docs/build_docs.py` | 1 | 1,764 | 0.0017 | 0.01% |
| **all five applied** | **130 remain** | **7,682,030** | **7.3262** | **41.0% off** |
| *(context)* `docs/reports/` | 75 | 2,041,088 | 1.9465 | 15.68% |
| *(context)* the five applied **and** `docs/reports/` | 55 remain | 5,640,942 | 5.3796 | 56.6% off |
| *(context)* `scripts/` — **stays selected in full** | 28 | 2,728,074 | 2.6017 | 20.96% |

**THE TOTAL IS SELF-REFERENTIAL AND THIS ROW IS INSIDE IT.** `docs/state.md` and this file are both
in the sync set and both are written after the verification run, so the figure moves as they are
written. It was iterated to a fixed point and verified off disk with everything staged, which is
what `git ls-files` reads. **Run `python3 claude_md_census.py` rather than quoting this table in
six batches' time** — that is the whole reason `CLAUDE.md` no longer carries a percentage.

### §3c — THE FIVE ITEMS, AND WHAT EACH IS ACTUALLY WORTH

1. **`DoD-archive/`, both files.** The bytes have not moved since FH: **1,680,660 B**. The SHARE
   has — FH wrote **14.2%** and it is **13.0%** now, with neither file changed by a byte, because
   the denominator grew. **`CLAUDE.md` carried the percentage and now carries the bytes**, with a
   pointer to the census script for the total; a share is a number about the whole tree wearing a
   claim about one file. It is still larger than every `check_*.gd` put together (61 files,
   1,236,947 B).
2. **Every `test_batch_*.gd` and `check_*.gd` at the repo ROOT — and the pattern leaves five
   behind.** The root holds **110** `.gd` files; that pattern matches **105**. The five it misses
   are `test_runes.gd`, `test_rune_battle.gd`, `test_run_harness.gd`, `gate_fixture.gd` and
   `suite_fixture.gd` — **137,755 B**, every one of them a suite or a suite fixture, i.e. exactly
   the class the rule says to deselect. **This is CW's `scripts/` error in miniature and the brief
   correctly warns about the original.** Deselect the five by name alongside the pattern, or
   deselect *all root `.gd` files*, which is the same set and needs no exception list.
   *(The brief's "there are now 105 targets" is the BATTERY's target count — FR's battery ran 105
   and this one runs 106. The file block reads 104 at HEAD and 105 with `check_fs.gd` staged. The
   two populations happen to coincide this batch and are not the same question.)*
3. **`pin-manifest.json` — 333,103 B.** EE's ruling stands and is the strongest on the list: it is
   **fully re-derivable** by `build_pin_manifest.py` and is read off disk by `check_ed` every
   battery. Nothing is lost by regenerating it. It grew 318.79 → **325.30 KiB** since FH.
4. **`docs/text-audit.html` and `docs/talent-audit.html` — 212,616 B together.** The text audit is
   ruled and applied and `docs/state.md` says so. **The talent audit is not**, by the same file's
   record: *"`docs/talent-audit.html` CANNOT: DN's §8 is an open question, not a closed one, and
   the file went 37 → 165 KiB carrying it."* §8.1.1's own heading reads *"THE CHARTER CONTRADICTS
   ITSELF ABOUT THOSE 75, AND SOMEBODY HAS TO RULE."* **Deselecting it is a ruling the repo has not
   recorded**, and it is 165.03 KiB of the 207.63.
5. **`docs/build_docs.py` — 1,764 B.** Real but negligible; it is 0.01% of the sync. **Two bigger
   instruments have exactly the same argument and are not on the list:**
   `build_pin_manifest.py` (**21,440 B**) and `claude_md_census.py` (**11,611 B**) — both are tools
   only Claude Code runs, both read off disk, and the first is the generator of a file already
   ruled deselected. Together the three are **34,815 B**; taken alone the smallest is not worth a
   line in anyone's memory.

### §3d — THE ENTRY THE REPO AND THE BRIEF DISAGREE ABOUT

**`docs/reports/` — 74 files, 2,007,731 B, growing by one every batch.** The brief opens §3 with
*"Reports are already deselected."* `CLAUDE.md`'s MUST-STAY-SELECTED list has named
`docs/reports/` since EE, and `docs/state.md` explicitly declined to recommend moving it *"because
`CLAUDE.md` lists it as MUST STAY SELECTED and moving it is a ruling."*

**I have not changed the ruling and I have not ignored the brief.** `CLAUDE.md` now carries the
disagreement on the rule's own line: what each source says, that the picker's state is unreadable
from here, the size, and that **the absence of a change is not agreement.** This is the shape
`docs/state.md` already names as its own worst case — *a rule contradicted by a ruling that lives
only in a closed batch report is a rule a future batch follows, because `docs/reports/` is the one
file class no instrument reads and no sweep covers.* A one-line ruling from the designer closes it.

### §3e — MUST STAY SELECTED, WRITTEN DOWN SO IT IS NOT SWEPT LATER

`CLAUDE.md`, `docs/instrument-rules.md`, **`docs/ways-of-working.md`**, `docs/state.md`,
`docs/changelog.html` (the LIVE one), `docs/master.html`, `docs/design-notes.md`,
`docs/text-standard.html`, **`docs/spec-recon.html`** and **`docs/merge-recon.html`** — the last two
are what authoring and the merge read across the whole class-merge project — and **`scripts/` in
full**, which is game code and **contains zero test suites**. Three of those ten
(`ways-of-working.md`, `spec-recon.html`, `merge-recon.html`) were **absent from `CLAUDE.md`'s list
and are on it now.**

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **No merge work, and nothing touched `class-merge`.**
- **No spine is built.** That is the branch's first batch.
- **No rune, card, ability, talent, constant or magnitude moved.** No `.gd` under `scripts/` and no
  file under `data/` was edited at all.
- **Nothing is deleted from the repo.** §3 is a picker list.
- **THE `docs/reports/` QUESTION IS NOT RULED**, and neither is the talent audit's. Both are
  recorded where the rule lives. See §3d.
- **`docs/changelog.html` AND `docs/design-notes.md` KEEP THEIR *"DEBUFF for seven"*.** They are
  dated, per-batch records of what a batch found; correcting one rewrites history. The population
  the gate sweeps is the current-truth documents and the boundary is stated in the gate.
- **THE PIN MANIFEST'S BLIND SPOT IS REPORTED AND NOT CLOSED.** `build_pin_manifest.py` binds a
  holder off a literal `"res://…"` inside a `var` statement, so a gate that keeps its document path
  in a `const` contributes **zero** pins — `check_fr` contributes four and **none** into the file it
  exists to read, and `check_fs` contributes none. Extending the generator is a batch of its own.
  It is written into `docs/instrument-rules.md` beside FH's typed-holder rule, because the
  dangerous half is that regeneration then reports success.
- **THE FOUR UNDESCRIBED DRAFT CARDS, `master.html:108`'s *"the every hero"*, `events.gd`'s false
  worked example and §3b's 66-damaging-abilities denominator are all still open.** They are FR's
  queue items; this brief did not name them and none is an instrument question.

---

## §5 — VERIFICATION

### §5a — THE DOCUMENTATION WAS WRITTEN BEFORE THE VERIFICATION RUN

`docs/master.html`, `CLAUDE.md`, `docs/instrument-rules.md`, `docs/changelog.html`,
`docs/design-notes.md`, `baselines.json` and the stamp were all in the frozen tree.
**`docs/state.md` and this file were written after**, which is the convention — and this batch owes
one thing the convention did not use to owe: **`check_es` §4(2b) reads `docs/state.md`'s content**,
so it was re-run against the shipped tree afterwards. See §5f.

### §5b — THE GATES WERE RUN UNMODIFIED AGAINST THE NEW TREE, AND THEN AGAIN

**A batch that writes an instrument owes that pass twice**, and the population is every gate, not a
chosen subset.

- **PASS 1 — HEAD's `check_cl_width.gd`, `check_map.gd`, `check_de.gd`, `check_es.gd`,
  `run_battery.sh` and `baselines.json` restored into the tree**, with the new content and
  `check_fs.gd` present. **Every gate clean.** `check_es` read **47**, `check_cl_width` read
  `checks=?`, and the only red was the sanctioned `check_cm_live` 13/4. **No unmodified gate
  accused the new content** — which is what FF's `check_ea` did to FF's own new gate and what this
  pass exists to catch.
- **PASS 2 — the same population with the new instruments.** `check_es` **57**, `check_fs`
  **39/0**, `check_parse` **180/0**, and all seven no-count targets reading `COMPLETE (prints no
  count by design)` where pass 1 read `checks=?`. `check_de` printed *"7 of 105 rows report no
  check count; 7 of them pin a completion marker."*
- Both passes were driven through `run_battery.sh` itself, so the flags, the watchdogs and the
  parsing were the battery's own and not a hand-rolled copy. The six files were restored from the
  scratchpad and **all six md5s verified identical** afterwards.
- **`check_parse` READ 180/1 IN BOTH PASSES AND THE 1 WAS MINE**: shrinking `SUITES` to run the
  gates alone trips its deliberate *"BATTERY EMPTY: SUITES parsed to zero targets"* hard failure. It
  reads **180 / 0** against the unmodified runner, which is the reading the baseline is written
  against. A gate refusing to certify an empty population is the gate working.

### §5c — THE NEEDLE SWEEP, AND IT IS NOT VACUOUS

Every literal held by every reader of each changed document, compared against **HEAD's copy with
the same reader set**, so a new gate joining the pool cannot be mistaken for a document change.

*Measured on the SHIPPED tree, so it covers the post-run edits in §5h as well.*

| document | readers | distinct literals | present in HEAD | LOST | GAINED |
|---|---|---|---|---|---|
| `docs/master.html` | 39 | 9,951 | 1,200 | **0** | **0** |
| `CLAUDE.md` | 64 | 13,239 | 1,148 | **0** | **0** |
| `docs/changelog.html` | 22 | 4,067 | 284 | **0** | 1 |
| `docs/instrument-rules.md` | 9 | 1,068 | 147 | **0** | 4 |
| `docs/design-notes.md` | 7 | 1,150 | 164 | **0** | 1 |
| `docs/state.md` | 12 | 2,771 | 392 | **0** | 3 |

**ZERO LOST ACROSS ALL SIX.** Every GAINED was chased and every one is the instrument
over-reporting, which is the safe direction — it pools all of a reader's literals, not only the
ones aimed at the document. They are `frames` (`suite_fixture.gd`'s **option-dictionary key**),
`core`, `Entropy`, `check_es.gd`, `docs/master.html`, `res://docs/master.html` — paths and words
their readers hold for their own purposes — and `* FR found *`, a fragment of a markdown-quoted
sentence inside a comment **this batch wrote in `check_es.gd`**. **A GAINED literal can only break
a NEGATIVE assertion**, and the two `not …contains(…)`-shaped arms in the tree that name any of
these read a code body (`check_eh` §255) and a dictionary key (`test_batch_at` §487); neither is a
document.

**AND THE ZEROS ARE NOT VACUOUS — A TWO-ARMED CONTROL.** The needle
`Funeral Pyre, Firedraw, Pyre Wake, Emberkeep` was chosen **out of the present set** and is one
`test_batch_cb.gd:1198` demonstrably asserts. Removed from the shipped copy, **LOST went 0 → 1**;
removed from HEAD's copy instead, **GAINED went 0 → 1**. The sweep bites in both directions.

### §5d — EVERY CHANGED REGION READ AS FLATTENED PROSE

FR's own repair shipped *"gold for maximum health for gold"* because an anchor crossed a line break,
which looks fine in a diff. Every hunk in all six documents was re-read with its flanking lines
**flattened, one hunk at a time and never as a first-to-last range** — 2 in `master.html`, 3 in
`CLAUDE.md`, 1 in `state.md`, 2 in `instrument-rules.md`, 1 each in `changelog.html` and
`design-notes.md`. **Every insertion joins its neighbours as a sentence** and no anchor split one.

### §5e — THE TREE WAS FROZEN

**373 files — tracked AND untracked — md5'd with ABSOLUTE paths** before launch and after exit, so
a moved working directory could not report the tree as drifted and a new untracked file could not
sit outside the population. `check_fs.gd` is in that list; the save backups are excluded by name
and stated. **ZERO DIFFER** on all 373.

### §5f — THE BATTERY

**106 TARGETS. THE ONLY RED IS THE SANCTIONED ONE.**

- **`check_de` — 441 checks / 0 failures / 0 NOTICES.** Every baseline matched, **including all
  three rows this batch wrote**, and it printed *"7 of 105 rows report no check count; 7 of them pin
  a completion marker."*
- **`check_fs` — 39 / 0**, matching the row written before the run: *"12 of 12 headings pair with
  the table beneath them"*, and *"stated 127 = 103 spec + 24 class-wide, of a 154-card draft (27 not
  listed) / counted 127 = 103 spec + 24 class-wide, over 16 bands."*
- **`check_es` — 57 / 0**, matching the row written before the run: 8 stated figures, 4 claim
  windows, 3 documents.
- **`check_parse` — 180 / 0**, matching the row written before the run, with the battery manifest
  at 104 and 0 missing and the **RESIDUE still 4** — `check_fs.gd` left it, which is the half that
  says it is wired in rather than merely present.
- **ZERO TARGETS THREW.** A suite that throws is not a suite that passed; the throws column sums to
  0 across every line.
- **`check_cm_live` 13 / 4 — the one red that is on purpose.** Its four FAIL lines are the four its
  baseline note records, word for word, and this batch can prove it did not move them rather than
  argue the point: that gate reaches `gate_fixture.gd` and `scripts/`, and **neither was edited.**
- **AND `check_ct_map` RAN THROUGH `run_one` FOR THE FIRST TIME** — 83 / 0, under its budget, with
  a watchdog and a completion test.

**AND THE ONE GATE THAT READS A FILE WRITTEN AFTER THE RUN WAS RE-RUN AGAINST THE SHIPPED TREE.**
`check_es` §4(2b) sweeps `docs/state.md`, and `docs/state.md` is rewritten behind the battery by
convention. Re-run after this file and the rewrite were both written: **`check_es: 57 checks / 0 failures`**,
identical to the battery reading, with the same 8 figures over 4 claim windows in 3 documents —
`state.md`'s rewrite kept both of its claim windows and both still agree with the census. The
count is unchanged because the arms are per-document, which is why they were built that way.

### §5h — THE POST-RUN EDITS, AND THE PROOF THEY OWE

Three things were written after the battery: **`docs/state.md`** (rewritten), **this file** (new),
and **two figures in `CLAUDE.md`** — the `check_*.gd` block went 60 files / 1,215,891 B to 61 /
1,236,947 B, because `check_fs.gd` joined it and the sentence would otherwise have been false the
day it shipped. That is a post-run edit to a file **64 readers name**, and it owes evidence rather
than a judgement that it looks harmless.

- **THE NEEDLE SWEEP OVER THE SHIPPED TREE: 0 LOST on all six documents**, `CLAUDE.md` included
  (64 readers, 13,239 literals, 1,148 present). HEAD → frozen was 0/0 and HEAD → shipped is 0/0, so
  frozen → shipped moved no asserted literal either. **The GAINED are the instrument over-reporting
  and every one was chased**: `frames`, `core`, `Entropy`, `check_es.gd`, `docs/master.html` and
  `res://docs/master.html` are literals their readers hold for their own purposes, and a GAINED
  literal can only break a NEGATIVE assertion — the two `not …contains("core")`-shaped arms in the
  tree read a code body and a dictionary key, neither of them a document.
- **AND THE 24 GATES THAT READ `CLAUDE.md` OR `docs/state.md` WERE RE-RUN AGAINST THE SHIPPED
  TREE**: `check_ec` 23, `check_fg` 22, `check_fm` 81, `check_du` 32, `check_ff` 55, `check_dm` 93,
  `check_eu` 38, `check_et` 26, `check_fh` 163, `check_eh` 175, `check_dr` 80, `check_dl` 24,
  `check_fr` 25, `check_es` 57, `check_dp` 48, `check_dv` 83, `check_do` 131, `check_ev` 54,
  `check_dj` 43, `check_dk` 64, `check_fe` 78, `check_ea` 86, `check_fs` 39, `check_parse` 180 —
  **every one at its battery count, 0 failures and 0 throws.**
- **`check_fg` READ BOTH CEILINGS AFTER THE EDIT**: `CLAUDE.md` **283.79 KiB with 6,354 B of
  headroom** under the 290 KiB bar, and `docs/changelog.html` **138,632 B under CW §4's 400 KB**.

### §5g — THE DESIGNER'S SAVES

All four files were copied to ``save-backups/FS-20260909-182928/`` and md5-verified against the originals **before any
other work**, and they were verified byte-identical to **FR's** backup first, so nothing between
the two batches had touched them. All four are byte-identical after 106 targets.

