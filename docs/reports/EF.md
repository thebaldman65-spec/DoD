# BATCH EF — THE CENSUS IS COMMITTED, AND THE GUIDE IS SPLIT AT THE INSTRUMENT SEAM

**Two things EE recommended and did not take.** The `CLAUDE.md` citation census is a committed
script now, so the figure three batches have quoted can be re-derived by anyone — and the first
thing it did was **disagree with the record by two blocks**, which is reported rather than
reconciled. And `CLAUDE.md` is **split at the seam EE measured**: twenty-six blocks of rules about
the INSTRUMENTS moved to `docs/instrument-rules.md`, a reference the guide points at rather than a
second required read.

**No game behaviour changed, no ability moved, no card was authored, and not one rule was rewritten
or retired.** `scripts/` is byte-unchanged.

---

## THE BRIEF'S FIGURES, RE-DERIVED

*Derive, do not recall.* Four of the numbers this batch was handed move when re-derived, and two of
them are EE's own.

| the brief or EE said | re-derived here | why |
|---|---|---|
| the seam is **~81 KiB across 33 of 96 blocks** | **67.56 KiB across 26 of 97** | EE's classification was keyword-weighted and said so; this one is per-block against a stated test, and nine blocks that read as instrument rules **do both** and stayed |
| **96 blocks** | **97** at EE's HEAD | EE measured at ED's HEAD; EE's own two new headings take it to 97 |
| the rebuild reads **the same 57 needles** ED read | **54** distinct positive `CLAUDE.md` needles in ED's manifest, 65 either polarity, **49 located** | no polarity or filter reproduces 57; that figure is not re-derivable from the repo either |
| headroom is **~13 batches** | **13.0** at EE's 237.50 KiB and +4,520 B/batch | reproduced |
| growth is **+4,520 B/batch** (DK→ED, prune excluded) | **+4,497** over DK→EE, 19 prune-free steps | one batch longer a window |
| the seven `STANDING REFERENCE` blocks are **24.4 KiB** | not re-measured — that cut was not taken | — |

---

## §1 — THE CENSUS IS `claude_md_census.py`, AND IT DISAGREES WITH ED BY TWO BLOCKS

### IT REPRODUCES ED'S FIXED POINTS FROM THE REPOSITORY ALONE

`--rev` reads any commit through git, so nothing depends on a tree that survived in a scratchpad:

| | EC | ED |
|---|---|---|
| sync files | **164** | **168** |
| sync bytes | **7.2277 MiB** (ED: 7.23) | **7.6027 MiB** (ED: 7.60) |
| `CLAUDE.md` | **234,401 B** | **238,678 B** |
| blocks, partitioning every character | **94** | **96** |
| characters | **232,823** | 237,073 |

**The segmentation is asserted to be a partition on every run** — every character in exactly one
block — because a census that silently drops a span reports a smaller file, not an error.

### AND IT READS 22 ASSERTED WHERE ED READ 24

**Reported, not reconciled.** The difference is neither the tree nor the quotation length: **the
asserted count reads 22 on both trees at every window swept**, 8 through 30. So it is the needle set
or the location rule, and those are the two things ED's script would have to be read to settle.

**THE TWO BLOCKS ARE IDENTIFIED, BY ARITHMETIC.** ED's asserted blocks hold 60,978 characters; this
script's hold 55,563. **Exactly one pair of blocks in the whole 94 sums to the 5,415-character
difference**: `NEVER `preload` A SCRIPT THAT NAMES AN AUTOLOAD` (1,795) and `STANDING REFERENCE —
ENEMY INTENT` (3,620). **No needle reaches either of them at any occurrence** — not in ED's own pin
manifest, not under this script's extractor, not case-blind, not at a second or third occurrence.
Under the definition stated in the script, neither block is asserted by anything.

**Which instrument is right cannot be settled, because ED's is not in the repo.** That is the defect
§1 closes, and it turned up on the first figure anybody tried to re-derive.

### THE DEFINITIONS ARE IN THE SCRIPT, WHICH IS THE HALF THAT MAKES IT AN INSTRUMENT

EE's slice sweep read 129 sites where ED's read 87 and **both were correct under their own
reading** — a census whose definition lives only in the head of whoever ran it is the same defect as
one with no script. So the sync set, the segmentation, what ASSERTED means, what QUOTED means, the
normalisation that lets a quotation survive rewrapping but not rewording, and why `docs/state.md` is
out of the corpus are all written into the file, above the code.

**THE QUOTATION LENGTH IS THE ONE FREE PARAMETER AND IT IS SWEPT RATHER THAN CHOSEN.** There is no
principled value; `--sweep` prints the whole curve, and the reading moves from 2.4% at eight words
to 55.8% at thirty on the same tree.

**THE LIVE READING IS 44.3% AT WINDOW 22 AND IT IS NOT COMPARABLE WITH 33.3%.** A third of the file
left it this batch, so the denominator moved and so did which blocks have a quoter. **The figure to
compare against next batch is this one, taken with this script.**

---

## §2 — `CLAUDE.md` IS SPLIT AT THE INSTRUMENT SEAM

### THE SEAM IS WHAT A RULE BINDS, NOT WHAT IT IS ABOUT

**"About the instruments" is a topic, and topics blur.** The save-version rule is *about* the save
format and *binds* a suite. The comment-staleness rule is *about* `battle.gd` and *binds* a sweep.
What a rule BINDS is answerable one block at a time: does this govern how a batch verifies itself,
or what the game may contain?

**WHERE A RULE DOES BOTH IT STAYED, AND THE TIEBREAK RUNS ONE WAY ONLY** — a batch that reads only
the guide must not be able to miss a rule about the game.

**NINE BLOCKS THAT READ LIKE INSTRUMENT RULES FROM THEIR HEADINGS STAYED, AND ONLY SEVEN OF THEM ON
THE TIEBREAK.** The count is worth stating exactly, because "nine blocks stayed on the does-both
rule" would have been a hand-tally of a table with two other reasons in it:

| block | why it stayed |
|---|---|
| `Working agreement` | **does both** — the drift/flake/band bullets bind the instruments; the text-standard half binds the cards |
| `VERIFY THE BRIEF AGAINST THE REPO BEFORE IMPLEMENTING IT` | **does both** — its shapes include *sweep the roster before authoring* |
| `NEVER `preload` A SCRIPT THAT NAMES AN AUTOLOAD` | **does both** — it cost a gate, and the fix moved constants into `run_state.gd` |
| `THE ENUMERATION IS `Classes.ability_corpus()`` | **does both** — *do not write a second copy in a gate*, but the answer lives on the game's data |
| `THE LITERAL-DIGIT RULE IS A BASELINE, NOT A GATE` | **does both** — it binds authored player-facing text and names the suite that pins it |
| `A DOCUMENTED EXCEPTION THAT OUTLIVES ITS JUSTIFICATIONS` | **does both** — its subject is a comment suspending a DESIGN rule |
| `THE SHELL, THE ENGINE AND THE FILES` | **does both** — the GDScript gotchas bind game code |
| `NAMES THAT LOOK WRONG AND ARE RIGHT` | **a game rule inside an instrument-looking section** — it binds identifiers, and only its parent heading made it a candidate |
| `Repo weight and the knowledge-base sync` | **binds neither** — the sync and deselection register, which defaults to the guide and which the new file had to join |

**AND `THE TRAPS` SPLIT DOWN THE MIDDLE**, three children each side, with the heading kept in both
files and each half saying so.

### `CLAUDE.md` STAYS THE REQUIRED READ

**Ruled, and built that way.** The guide carries an INDEX of what moved — headings and their
provenance, twenty-six blocks in twenty-four entries — and **no summary of any moved rule**. A
summary is a second copy, and a second copy is what let CW's split leave a `CLAUDE.md` that
contradicted itself 1900 lines apart with DL finding it still live four batches later.

**AND AN INDEX OF HEADINGS CAN SATISFY A PIN, WHICH IS WRITTEN DOWN AT THE INDEX ITSELF.**
`contains("AN INSTRUMENT'S TERRITORY IS A CLAIM")` against `CLAUDE.md` passes off the index row while
the rule itself could have been deleted — the CW/CD fault arriving through an index instead of
through prose. **`check_ec`'s two needles are pinned against `docs/instrument-rules.md` for exactly
that reason, and control A2 below proves the index is not what they read.**

### NOTHING WAS REWRITTEN, AND THE PROOF IS BYTE-FOR-BYTE

Every moved block is byte-identical to what stood in the guide. **A second script sharing nothing
with the splitter** re-derived the headings from an untouched backup, counted them two independent
ways, required each of the 96 to appear **exactly once** across the two halves, checked order was
preserved inside each half, and **rejoined the two bodies BYTE-IDENTICAL to the pre-split file**.
**No file size was asserted anywhere** — sizes agreeing is consistent with a duplicated block and a
dropped one, and control F2 below is that case made real.

**THREE HEADINGS ARE NEW AND THE VERIFIER KNOWS ALL THREE BY NAME**, so an invented heading is as
much a failure as a dropped block: the index block in the guide, and two `##` section headings in
the new file that carry the `###` blocks whose parent stayed behind.

### THE PINS WERE MAPPED BEFORE ANYTHING MOVED

**All 70 assertions that pin a literal into `CLAUDE.md` were located to their block first**, from
the manifest and again from an independently written extractor that agreed with it. **Sixty-six sit
in blocks that stayed** — which is itself the cheapest evidence the seam was cut in the right place.

**FOUR MOVED, AND ALL FOUR WERE RE-POINTED IN THE SAME BATCH** with the needle unchanged word for
word: `check_ec` §2 twice (its own two rules) and `test_batch_ce` twice (`Verify before shipping`).
**The haystack moved and the needle did not.** `test_batch_ce` keeps a `CLAUDE.md` holder in the
same function for the two pins whose block stayed — one function, two haystacks, deliberately.

**AND FIVE POSITIVE PINS RESOLVE NOWHERE, EXACTLY AS THEY DID AT HEAD.** Three are the documented
vacuous trio (`at` twice, `aw`); the other two are alternation members whose sibling carries the
group (`test_batch_bo`'s *cap at 7*, `check_dv`'s long-form oracle sentence). **Every document pin
in the tree was re-resolved against the split tree and against HEAD: the same twelve unresolved,
the same list, both sides.**

### THE NEW FILE IS INSIDE THE INSTRUMENTS' TERRITORY, NOT OUTSIDE IT

A rules file the suites assert against, left out of the sweeps, is a population an instrument
reports clean without ever reading — **EC §2's own rule, arriving as a hole this batch would
otherwise have dug for itself.** Three one-line widenings close it:

- **`build_pin_manifest.py`'s `DOCS`** — the new file is a tracked document, so its four pins are
  classified `document` rather than `other`. **The manifest diff is exactly the four re-pointed pins
  and nothing else**: 1313 pins either side, every family count and every residency count identical.
- **`check_ec.DOCS`** — four tracked documents became five. **That is the +1 in its check count**:
  §0 asserts each member reads back over 1000 bytes, one check per document.
- **`check_ea` §3's assign regex** — the batch-code sweep now binds a holder from EITHER rule file.
  Neither half narrates batches, so the question is the same on both. **Its count does not move.**

### THE SIZES, AND THE HEADROOM

| | before | after |
|---|---|---|
| `CLAUDE.md` | **237.50 KiB** | **175.46 KiB** |
| `docs/instrument-rules.md` | — | **69.84 KiB** |
| the two together | 237.50 | **245.30** |
| headroom to the 290 KiB ceiling | 52.50 KiB ≈ **13 batches** | 114.54 KiB ≈ **26 batches** |

**THE SPLIT COST 7,984 B OF ITS OWN** — the index block, the new file's header, two section
headings and four repairs to blocks that stayed. **About one and three quarter batches of growth,
to buy thirteen.**

### AND THE INSTRUMENT HALF HAS BEEN GROWING FASTER — RECENTLY, AND ONLY RECENTLY

The brief asked. Each of the twenty-four `CLAUDE.md` revisions from DH forward was segmented and
each block attributed to the half it is in today:

| window | the main half | the instrument half |
|---|---|---|
| **DK→EE**, 19 prune-free steps | **+2,867 B/batch** (median +3,214, max +6,448 at DR) | **+1,630** (median +653, max **+5,118 at DX**) |
| **DZ→EE**, the five post-prune batches | +1,890 | **+3,623** |

**Both readings are real and they point opposite ways.** Over the long window the main half grows
nearly twice as fast; over the last five batches the instrument half grows nearly twice as fast.
**The recent reading is what five instrument batches in a row look like — it is composition, not a
law** — and it is exactly why the ceiling procedure will need to bind both files rather than one.

### THE CEILING'S DERIVATION NOW COVERS TWO FILES, AND RE-DERIVING IT IS A RULING THIS BATCH DID NOT TAKE

EE derived 290 KiB as `210.59 (the DZ floor) + 10 × 8.09 (the worst batch)`. **That floor was
measured on a file that still held the instrument half**, so 290 is now conservative for
`CLAUDE.md` alone: **it fires later than its own derivation would, never earlier.** The guide says
so at the ceiling block rather than pretending the number is untouched.

**THE ARITHMETIC FOR A CEILING PER HALF, PRINTED SO THE NEXT BATCH DOES NOT START FROM NOTHING** —
EE's method exactly, with every term measured on the same segmentation:

| | floor (DZ, that half) | worst batch on record | ceiling | headroom now |
|---|---|---|---|---|
| `CLAUDE.md` | 160.71 KiB | +6.30 KiB (DR) | 160.71 + 63.0 = 223.71 → **220 KiB** | 44.54 KiB ≈ **10 batches** at +4,520 |
| `docs/instrument-rules.md` | 49.88 KiB | +5.00 KiB (DX) | 49.88 + 50.0 = 99.88 → **95 KiB** | 25.16 KiB ≈ **6** at +4,520, **16** at its own long-run rate |

**AND THE SHARP PART: the two per-half ceilings sum to 315, not 290.** Each half carries its own
ten-worst-batch headroom, so splitting a file under this formula RAISES the total allowance. **A
split does not buy rules — it buys a smaller REQUIRED READ**, which is what the ceiling block
already says a ceiling in KiB is for. **Whether to take these two numbers is the designer's, and
the 290 stands until then.**

---

## §3 — THE THREE THINGS EE LEFT ON THE RECORD

Confirmed, not reopened: the three further slice repairs and the 129-slice sweep; the ternary and
the alternation member that look like guards and are the opposite; and the citation exclusion moving
exactly one block, the ruling block itself. **The census script carries the exclusion as its
default** (`--no-exclude` reproduces the pre-EE readings), which is EE §2's rule made operable
rather than restated.

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **NO NEW GATE.** Nothing this batch rules on needs one: the re-concatenation is a one-time proof
  with a second script (CW's own discipline for a split), and the four re-pointed pins are enforced
  by `check_ed` §1 and swept by `check_ec` §2 every battery. **`check_de` does not move**, because
  no target arrived or left.
- **AND THAT LEAVES ONE THING UNINSTRUMENTED, WHICH IS SAID RATHER THAN LEFT TO BE FOUND:**
  **nothing in the battery runs `claude_md_census.py`.** It is a tool, not a gate; it was run at
  three revisions here and its output is in this report, but a later batch that breaks it finds out
  by running it. Same standing as `build_pin_manifest.py` before ED gave it `check_ed`.
- **THE SEVEN `STANDING REFERENCE` BLOCKS ARE NOT CUT.** That seam is still available and is still
  exact. One cut per batch.
- **NO RULE WAS REWRITTEN, RETIRED OR PRUNED**, and no block body was edited except the four
  repairs listed in §5.
- **THE 290 KiB IS NOT RE-DERIVED**, per above.
- **`scripts/` IS BYTE-UNCHANGED** and `docs/master.html` is touched only at the stamp — one line,
  `EE` → `EF`.

---

## §5 — THE CODE CHANGE

- **`CLAUDE.md`** — twenty-six blocks removed to `docs/instrument-rules.md`; a new index block after
  the file's own charter; and **four repairs to blocks that stayed**, each one a pointer the cut
  would otherwise have left dangling: the what-goes-where list gains the new file; the ceiling block
  records that the split was taken and what the 290 now binds, and its *"the corpus rule below"*
  becomes a named cross-file reference; the sync list gains the new file under WHAT MUST STAY
  SELECTED; and `THE TRAPS` says where its instrument half went.
- **`docs/instrument-rules.md`** — NEW. A header naming `CLAUDE.md` as the required read, the seam
  test, the re-pointing rule and the ceiling position; two `##` section headings carrying orphaned
  `###` blocks; then the twenty-six blocks verbatim. **Two dangling pointers inside moved blocks
  were repaired to name `CLAUDE.md`**: *"the standing rule above"* (the no-gated-healing rule) and
  *"the DEBUG SURFACES table below"*.
- **`claude_md_census.py`** — NEW, at the repo root beside `build_pin_manifest.py`.
- **`check_ec.gd`** — `DOCS` gains the new file (+1 check); two needles re-pointed.
  **`test_batch_ce.gd`** — two needles re-pointed, count unchanged.
  **`check_ea.gd`** — §3's assign regex binds either rule file, count unchanged.
  **`build_pin_manifest.py`** — `DOCS` gains the new file.
- **`pin-manifest.json`** — regenerated. Four pins change haystack; nothing else moves.
- **`baselines.json`** — one row: `check_ec` 22 → 23, with the reason.
- **`docs/changelog.html`**, **`docs/design-notes.md`**, **`docs/master.html`**'s stamp.
- **`scripts/` IS UNTOUCHED.**

---

## §6 — VERIFICATION

### THE DOCUMENTATION WAS WRITTEN BEFORE THE BATTERY

`CLAUDE.md`, `docs/instrument-rules.md`, `claude_md_census.py`, the four `.gd`/`.py` edits,
`pin-manifest.json`, `baselines.json`'s one row, `docs/changelog.html`, `docs/design-notes.md` and
`docs/master.html`'s stamp were all final before the certification run. **`docs/state.md` and this
report are read by nothing** — no `.gd` file opens either, and the seven that name `docs/state.md`
all name it in a comment — so both were written after, which is what lets a batch certify the tree
that ships.

### THE PREDICTION, WRITTEN BEFORE THE FIRST READING

**PREDICTION: EXACTLY ONE ROW MOVES — `check_ec` 22 → 23 — AND `check_de` READS 337 / 0 / 0.**

Predicted from what each target **READS**, not from what this batch writes:

- **`check_ec` gains exactly one check** because §0 asserts each member of `DOCS` reads back over
  1000 bytes, one check per document, and `DOCS` went from four to five. **Read standalone three
  times: 23 / 0, 23 / 0, 23 / 0.**
- **`check_de` gains nothing.** No target arrived and none left, so its own count cannot move. This
  is the term ED's prediction had and EF's does not.
- **`test_batch_ce`'s count cannot move**: two `contains` became two `contains` against a different
  holder. **Read standalone: 1114 / 0**, its exact baseline.
- **`check_ea`'s count cannot move**: §3's assertions are `files > 60`, `accused.is_empty()`,
  `readers >= 20`, `scanned >= 40` — a widened regex changes the values it prints, not how many
  questions it asks, and no literal in either rule file's readers carries a batch code. **Read
  standalone: 60 / 0.**
- **`check_ed` cannot move**: its §0 reads the manifest's own recorded total, and the manifest's
  total did not move. **Read standalone: 18 / 0**, with 926 of 1014 source pins verified and 39
  comment-resident, both unchanged.
- **All 70 `CLAUDE.md` pins were mapped to their block before the first edit**; the 66 that stayed
  are in blocks that did not move, and the four that moved were re-pointed.
- **The fourteen stamp gates** compare `>=` their own batch code, every one `CE` or older, and
  `EF >= CE` holds lexically. **`check_dv` §4's changelog span is a FLOOR of 16**; the live file
  goes to 26 entries.
- **Eight document and fingerprint gates were read standalone against the edited tree** before the
  battery and every one matched its baseline at zero failures.

### THE PRE-BATTERY INSTRUMENTS

- **THE SPLIT VERIFIER — A SECOND SCRIPT SHARING NOTHING WITH THE SPLITTER.** Headings counted two
  independent ways on all three files; 71 + 28 = 96 + 3 authored; no duplicate inside either half;
  **zero overlap**; every original heading present exactly once and nothing invented; order preserved
  inside each half; **the two bodies rejoin BYTE-IDENTICAL to the pre-split `CLAUDE.md`**; and no
  block body edited. **No file size was asserted anywhere.**
- **THE PIN SWEEP, RUN BOTH WAYS.** Every document pin in the manifest re-resolved against the split
  tree, and the same sweep run against `git show HEAD`'s documents and HEAD's manifest.
  **217 pins either side; the same twelve unresolved, the same list, both sides** — eight runtime
  format strings, the three documented vacuous carriers, and the two `master.html` needles asserted
  against a stripped copy. **The split moved nothing into or out of that set.**
- **THE LITERAL-FLIP SWEEP over the five tracked documents**, 11,205 distinct literals at a floor of
  4, taken against `git show HEAD`: `CLAUDE.md` **1 gained / 71 lost**, `instrument-rules.md`
  **317 / 0**, `changelog.html` **1 / 0**, `master.html` and `design-notes.md` **0 / 0**.
  **LOST LITERALS ARE EXPECTED WHEN A THIRD OF A FILE MOVES — the proof is the assertions, not the
  count.** Cross-checked both ways: **0 gained literals are negatively pinned against the file they
  landed in, and 0 lost literals are positively pinned into it.** Against **HEAD's** manifest,
  exactly **two** of the 71 lost were pinned — `test_batch_ce`'s two — which is the re-point
  showing up as arithmetic. **The one gained literal is `docs/instrument-rules.md` itself.**
- **THE SOURCE-SIDE FLIP SWEEP over the four edited `.gd`/`.py` files**: **zero flips a pin cares
  about**, checked against both the new manifest and HEAD's.
- **THE RETIRED-WORD PRE-CHECK.** **0 *party* and 0 *beast* in every line this batch added** to
  `CLAUDE.md`, `docs/changelog.html` and `docs/design-notes.md`. The four occurrences in
  `docs/instrument-rules.md` are inside moved blocks and are pre-existing `CLAUDE.md` text; no sweep
  reads either file, checked rather than assumed — `test_batch_bx` §4 and §4b read `master.html`,
  thirteen `.gd` files and four `data/*.json`, and `master.html` is a one-line stamp diff.
- **NO DIRECTORY WALK REACHES `docs/`.** Checked before adding a file to it: nothing in the tree
  enumerates that folder, and `docs/build_docs.py` reads two named `.html` files.

### THE NEGATIVE CONTROLS — AND FOUR OF THE SIX ARE TWO-ARMED

**Each armed on something a target demonstrably reads, with the disarmed state confirmed GREEN
first**, and every file restored by `cp` from a scratchpad backup with the md5 compared.

| # | armed on | result | the second arm |
|---|---|---|---|
| **A** | `AN INSTRUMENT'S TERRITORY IS A CLAIM` reworded in `docs/instrument-rules.md`, **the index row in `CLAUDE.md` left intact** | **`check_ec` 24 / 3**, naming the file | — |
| **A2** | the same words reworded in **`CLAUDE.md`'s INDEX ROW ONLY**, the rule itself untouched | **`check_ec` 23 / 0 — GREEN** | **A + A2 together prove the pin reads the RULE and not the index** |
| **B** | `DO NOT ADD A BATCH BLOCK TO THIS FILE` reworded in `CLAUDE.md`, a block that stayed | **`test_batch_bb` 177 / 1** | proves the split did not sever the guide's own readers |
| **C** | **HEAD's un-re-pointed `test_batch_ce.gd`** run against the split tree | **1114 / 2 FAILED**, naming both moved needles | **proves the re-point was necessary, not decorative** — and the COUNT did not move, only the failure |
| **F** | one block dropped from the instrument half | **the verifier reds 5 assertions**, naming the heading | restored → ALL PASS |
| **F2** | a **BYTE-PRESERVING** edit inside a moved block (`400 KB` → `004 KB`) | **file sizes IDENTICAL**, and the rejoin catches it (2 red) | this is why *"do not assert file sizes"* is a rule |
| **D** | `func draft_pool_left(:` inside `check_parse`'s real scope | **22 `Parse Error` lines in stderr**, tally 7 | clean tree reads **0**, tally 0 |

**C IS THE ONE WORTH KEEPING.** The same suite, unmodified from HEAD, goes red against this tree at
its exact check count — so the two needles genuinely left `CLAUDE.md`, the index does not carry
them, and re-pointing was the work rather than the decoration.

**AND D IS ARMED IN `check_parse`'S REAL SCOPE ON PURPOSE.** EB §3's rule stands: `check_parse` does
not cover the gates, so a parse control armed on `check_ec.gd` would read clean for the wrong
reason. **The three edited `.gd` files were each launched directly instead** — `check_ec` three
times, `check_ea` once, `test_batch_ce` once — which is the only proof that bites for a gate.

### THE ACCEPTANCE RUN

**One battery, and it found nothing.** No suite failure, no throw, no notice, no timeout, and the
only red is the one that is on purpose.

| | ED's acceptance | EE's acceptance | **EF's acceptance** |
|---|---|---|---|
| **suite failures** | 0 | 0 | **0** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 337 / 0 / 0 | 337 / 0 / 0 | **337 / 0 / 0** |
| targets in the manifest | 82 | 82 | **82** |

**EIGHTY-TWO TARGETS RAN AND THE MANIFEST NAMES ALL EIGHTY-TWO**, compared both ways: no log on disk
the manifest does not name, and none named that is not on disk. **0 `Parse Error` and 0
`SCRIPT ERROR` in every one of the 82 logs** — grepped from the streams rather than read off a tally
or an exit code. `check_map_screen: OK`; `check_ct_map` 83 / 0; the run harness reads
**22 / 166 / 8**, all three PASS with no throws. **40,670 checks** across the suite and gate lines,
plus 196 from the harness and 83 from `check_ct_map`. **That total is a sum over drifting bands and
is not a figure to compare across batches** — `an` alone read 6049 here against 6054 at EE, well
inside its recorded band, which is what the band is for.

**AND THE PREDICTION HELD EXACTLY.** `check_de` reported **337 checks, 0 failures and ZERO NOTICES**,
with **81 of 81 recorded targets swept and 0 off their recorded line**. **`check_ec` read 23** — the
one row written before the run — and **no other row moved.**

### THE TREE WAS FROZEN AND IT IS PROVEN, NOT CLAIMED

**186 files were MD5-stamped before the acceptance run and re-compared after: EVERY ONE IS
BYTE-IDENTICAL.** `CLAUDE.md`, `docs/instrument-rules.md`, `pin-manifest.json`, `baselines.json`,
`run_battery.sh` and every `.gd` file are unchanged across the run, **so the battery certified what
ships.**

**EXACTLY TWO FILES DIFFER FROM THE CERTIFIED TREE NOW, AND BOTH ARE READ BY NOTHING**:
`docs/state.md` and this report. No `.gd` file opens either.

### THE FIGURES, MEASURED ON THE CERTIFIED TREE

Stated against the frozen tree rather than the committed one, because `docs/state.md` and this
report are inside the number.

| | value |
|---|---|
| the sync | **171 files, 7.6699 MiB** |
| `CLAUDE.md` | **179,674 B = 175.46 KiB** |
| `docs/instrument-rules.md` | **71,515 B = 69.84 KiB** |
| the two together | **251,189 B = 245.30 KiB**, against 243,205 = 237.50 before |
| the split's own cost | **7,984 B = 7.80 KiB** — about 1.8 batches of growth, to buy thirteen |
| headroom to the 290 KiB ceiling | **114.54 KiB** — about 26 batches at +4,520 B, about 41 at the main half's own rate |
| the sync after deselecting `pin-manifest.json` | **170 files, 7.3808 MiB** |
| the live census, window 22 | **18 asserted / 17 quoted / 37 neither = 44.3%** — **not comparable with 33.3%**, because a third of the file left it |

### AND THE TWO POST-RUN FILES ARE PROVED HARMLESS RATHER THAN ASSUMED TO BE

**No pin in the manifest has `docs/state.md` or `docs/reports/` as a haystack, and no `.gd` file
opens either** — checked individually rather than counted. **Enumerating the assertions is the
proof; a literal count is not.**
