# BATCH FG — THE CHANGELOG CUT, AND SOMETHING THAT WATCHES THE THRESHOLD

*2026-09-06. The cut CW §4 wrote a procedure for and nothing ever announced was owed. §1 takes it
and proves it; §2 builds the instrument whose absence is the actual finding; §3 corrects six false
claims — four FF named and two found beside them. **No rune, card, ability, constant or magnitude
moved, no rule was rewritten, and no file under `scenes/` was touched.***

---

## §0 — THE BRIEF'S PREMISES, CHECKED FIRST

| Premise | What the repo says |
|---|---|
| *"`docs/changelog.html` crossed CW §4's **400 KiB** threshold at FB/FC"* | **THE DIRECTION IS RIGHT AND THE UNIT IS NOT. The rule says `400 KB`** — `docs/instrument-rules.md`, CW §4, one occurrence. The two readings are **9,600 B apart** and they put the crossing a whole batch apart: **FB at 402,070 B** on the decimal reading, **FC at 409,793 B** on the binary one. **That is why "three to four batches overdue" is right either way**, and it is the reason the new gate takes the stricter reading and prints both. |
| *"is three to four batches overdue"* | **TRUE.** Measured over every commit: FA 396,126 (under both), **FB 402,070 (over on KB)**, **FC 409,793 (over on both)**, FD 417,348, FE 423,502, FF 435,335. |
| *"my headline figure came from a report via `state.md` rather than from the file"* | **THE CORRECTION APPLIES TO FF's OWN NUMBER, NOT THE CHANGELOG'S.** 280.80 KiB was `CLAUDE.md` at FE. **The changelog's headline figure in this brief is right**: HEAD reads **435,335 B = 425.13 KiB**, measured off disk. |
| *"CX cut it once at 486 KiB and left ~150"* | **FALSE TWICE, AND THE SECOND HALF MATTERS.** 486 KB is CW's reading; **CX measured 494.2 KB and left 162.1 KB**. And **CX is not the only prior cut — BZ split at BO/BP and DV cut again at DF/DG**, leaving **153,572 B = 149.97 KiB**. DV's are the figures the tree carries, and **DV's 149.97 KiB is the reading that shows the ~150 target has always been taken in KiB.** |
| *"CX found eleven readers where `state.md` recorded nine. Derive the population."* | **DERIVED: 18 files name the changelog by path — 15 read its content and 3 declare it as territory.** §1c. CX's eleven were the suites it re-pointed, which is a different population again. |
| *"FF measured 261.03 KiB with 6.9 batches of headroom at the mean and 3.6 at the worst"* | **TRUE.** HEAD's `CLAUDE.md` is **267,291 B = 261.03 KiB** against EE's **290 KiB**; headroom **28.97 KiB**. |
| *"`check_es` §1 reports the authored pool empty while 21 runes are authored, because its sample member is a Berserker"* | **TRUE, AND THE DIAGNOSIS IS EXACT.** §3a. |
| *"nothing watches the threshold"* | **TRUE, AND WIDER THAN STATED.** Nothing watched **either** bar. `CLAUDE.md`'s 290 KiB had no instrument from EE to now either. |

---

## §1 — THE CUT, AT EP/EQ

**36 entries moved** — Batch EP back to Batch DG — out of the repo into
`/Users/zipples/Documents/DoD-archive/changelog-archive.html`.

| | before | after |
|---|---|---|
| `docs/changelog.html` | 435,335 B, **52 entries** (FF → DG) | **147,929 B = 147.93 KB = 144.46 KiB**, **17 entries** (FG → EQ) |
| `DoD-archive/changelog-archive.html` | 1,345,829 B, **149 entries** | **1,646,681 B, 185 entries** (EP → Batch 1) |

**THE BOUNDARY WAS CHOSEN AGAINST THE MEASUREMENT AND THE TIEBREAK IS STATED.** The rule asks for
about 150 KB. Keeping 18 entries lands at 149.03 KB but 145.54 KiB; keeping 19 lands at 151.48 KiB.
**Keeping 16 plus this batch's own entry lands at 147.93 KB and 144.46 KiB — under 150 on BOTH
readings**, which is the same tiebreak the gate below takes on the threshold: *a bar with two
readings is met under the stricter one.* At the **7,827 B a batch** measured over the 36 batches
since DV, the next cut is **about 32 batches away** — and **DV's own cut lasted exactly 32**
before the bar was crossed at FB, which is the closest thing this project has to a check on the
arithmetic.

### 1a. THE VERIFICATION, WHICH IS THE PROCEDURE AND WAS ALREADY WRITTEN

A **second script sharing nothing with the splitter**, reading untouched frozen copies of both
original files taken as this batch's first action. **24 checks, 0 failures, and NO FILE SIZE IS
COMPARED ANYWHERE IN IT:**

1. **headings extracted TWO INDEPENDENT WAYS agree on all four files** — a line scanner that
   stitches a wrapped `<h2>` and a cross-line regex — 52 / 149 / 16 / 185;
2. **the counts sum with zero overlap and order preserved on both sides**: the live half is the
   original's prefix, the moved entries lead the archive in their original order, and the
   pre-existing archive follows untouched;
3. **every heading appears exactly once across the halves**, the multiset is unchanged, none was
   invented and none was dropped;
4. **the live body plus the moved body re-concatenates to the original live body byte for byte**,
   and again by an independently-computed sha256;
5. **all 201 entries survive VERBATIM** — the whole entry text, not its heading.

### 1b. AND THE PROOF WAS ITSELF PROVED, THREE ARMS

| arm | injected into a copy | result |
|---|---|---|
| an entry **dropped** from the archive (Batch EK, 5,963 B) | 10 failures |
| an entry left in **both** halves (Batch EP, 8,401 B) | 11 failures |
| **one word misspelt inside a kept entry** (`the` → `teh`) | **3 failures** |

**THE THIRD ARM IS WHY THE SIZE RULE EXISTS AND IT IS SHARPER THAN THE RULE'S OWN STATEMENT.** The
rule says two sizes agreeing is consistent with a duplicated entry and a dropped one — which the
first two arms show, and which a size check would in fact have caught, since both changed the file's
length. **The third changes the size by exactly zero bytes and is invisible to every heading count
in the procedure.** Only the byte-for-byte rejoin sees it. **A size check cannot see an EDIT at
all**, and an edit is the failure a cut is most likely to produce by accident.

### 1c. THE READER POPULATION, DERIVED

**18 files name `docs/changelog.html` or the archive by path. 15 read the content; 3 declare it as
territory** — `check_ec`'s `DOCS` table, `build_pin_manifest.py`'s `DOCS` set, and
`docs/build_docs.py`, which reads the live file by RELATIVE name and is the reason the live file
never moves. Counted comment-stripped, because a path in a comment is not a reader: **four more files name the
path only in a comment** (`check_el`, `test_batch_as`, `test_batch_at`, `test_batch_aw`) and four
others (`check_cs`, `check_ct`, `check_de`, `check_dj`) mention the word alone. **With `check_fg`
in the tree the population is 19** — sixteen readers and the same three declarations.

**FOURTEEN OF THE FIFTEEN NEEDED NOTHING, AND THAT IS CX's WORK RATHER THAN THIS BATCH'S.** Every
one of bb, bn, bo, bp, bq, br, bs, bt, bu, bv, bw, bx, cb, ce is a **negative** pin on the live file
plus a **positive** one on the archive, with the archive reached by following the path out of the
live file's own header — so a cut can only make them more true. **All fourteen were run against the
cut tree BEFORE one assertion was edited: 0 failures, 0 throws**, alongside `check_ea`, `check_ec`,
`check_ed`, `check_es` and `check_parse`.

### 1d. A BOUNDARY LITERAL HAS TWO READERS, NOT ONE

`check_dv` §4 was the one gate the cut broke — four literals naming DV's DF/DG boundary and the
archive's 149. **I predicted those four. I did not predict that they would come back a second time
under another gate's name:** `check_ec` §2 verifies that every document pin in the tree RESOLVES, so
the same stale literals produced **3 more failures under `check_ec`**. **Re-point the gate, then
re-run the gate that reads the gates.**

### 1e. AND ONE ARM OF `check_dv` §4 COULD NOT HAVE FAILED

It asked that the live header record which batch made the cut:

```
ok(live.contains("Batch DV</b> at DF/DG") or live.contains("Batch DV"), …)
```

**The header names every cut in its own history**, so the second member holds no matter what the
first says — **the arm would have passed with the first branch deleted.** `check_ec` §1 counted it
among **nine live alternations and correctly reported it satisfied**, which is the point: reading a
group by its operator tells you the group holds, not that the group is asking anything. The `or` is
gone and the pin names FG's own boundary. **A cut writes its own batch into that header, so pin
that.**

---

## §2 — `check_fg.gd` IS NEW, AND IT IS THE BATCH'S REAL CONTENT

CW §4 wrote a threshold and a whole cut procedure and **nothing was ever built to notice the
threshold being crossed.** `check_dv` §4 printed the live changelog's **entry count** every battery
from DV onward and nothing anywhere printed its **size**, so the tree was green the whole way
across. The last recorded reading was *"about seven batches away"*; seven batches came and went. At
the moment of the crossing, `docs/state.md` carried **two contradictory estimates in one bullet** —
"about seven batches away" and "roughly seventeen batches away". **The same hole was open on
`CLAUDE.md`'s 290 KiB ceiling, from EE to now.**

### 2a. THE WARNING IS THE LINE AND THE FAILURE IS THE DEADLINE

**The brief asked for a deliberate choice between a warning and a failure. The answer is both, and
the split between them is the rule's own words rather than a margin anyone picked.**

Both halves of the brief's objection are true and both were true here concretely. **A gate that reds
the moment the bar is crossed reds on a batch whose only crime is writing its own changelog entry**
— every batch writes one — **and the answer to a crossing is a whole batch of work that this
project's rules say must not share a diff with anything else.** So a red on the crossing batch asks
for exactly the thing the rules forbid, and trains everyone to ignore it. **A gate that only warns
is ignorable, which is precisely what four batches of silence look like.**

CW's rule already contains the deadline: *cut at the **NEXT** batch boundary.* So:

- **over the bar → a printed WARNING.** You are the batch that crossed it; the cut is owed next.
- **over the bar WITHOUT this batch's own newest entry → a FAILURE.** That is the file as the
  previous batch left it, so the previous batch crossed it, this is the next boundary, and the cut
  was not taken.

**It needs no memory, no stored number and no git; it fires on exactly the batch the rule blames;
the red never lands on a batch that had no warning in front of it; and it cannot be ignored twice.**

`CLAUDE.md` has no per-entry structure to lean on, so its deadline is **the ceiling plus the largest
single-batch growth on record** — **the same figure EE's ceiling was itself derived from**, read out
of the same block. **No new magnitude is authored in either arm.**

### 2b. THE GATE HOLDS NO COPY OF EITHER NUMBER, AND IT MEASURES BYTES

**Both bars are parsed out of the rule that states them**, because a second copy of a number is this
project's oldest recurring defect. It asserts that **every statement of a bar within its own file
AGREES** — `CLAUDE.md` states its ceiling twice, in the heading and in the rule sentence — so a
half-edited rule goes red rather than leaving an instrument measuring against the copy nobody
updated. A gate that fell back to a hardcoded bar when it could not find the rule would be worse
than one that fails: **the rule is the authority, and a gate that cannot find it must say so.**

**AND IT MEASURES BYTES, NEVER CHARACTERS.** `String.length()` in Godot is a **character** count.
`CLAUDE.md` holds **1,996 bytes of multi-byte punctuation** — **1.95 KiB against a ceiling whose
entire remaining headroom is 26** — so a gate written the obvious way would report the file nearly
two KiB under its true size, every battery, in the direction of never firing, with nothing to
announce it.

### 2c. SEVEN CONTROLS, SEVEN BITES

| arm | result |
|---|---|
| changelog over the bar **by its newest entry alone** | **warning printed, 22 / 0** |
| changelog over the bar **without that entry** | **warning + 22 / 1** |
| `CLAUDE.md` over the ceiling, under the deadline | **warning printed, 22 / 0** |
| `CLAUDE.md` past the deadline | **22 / 1** |
| the threshold sentence **reworded** | **17 / 2** — "cannot find its bar" |
| a **second, disagreeing** statement of the ceiling (`999 KiB`) | **18 / 1** — "the copies disagree" |
| the standing rule's **body sentence** reworded | **22 / 1** |

**A DISARMED GATE SHOWS TWICE.** The bar-parse arms `return` early, so a reworded rule **drops the
check count as well as failing** — 22 → 17 and 22 → 18 measured — and a falling check count is its
own error under `check_de`. The clean arm read 22 / 0 before the controls and 22 / 0 after.

### 2d. THE RULE THAT GENERALISES IT

**A CEILING NOBODY MEASURES IS A CEILING THAT GETS CROSSED SILENTLY** — written into
`docs/instrument-rules.md` beside CW §4's own block, with both instances in a table: the changelog
at 400 KB, unwatched from CW to FG and **crossed four batches ago**; `CLAUDE.md` at 290 KiB,
unwatched from EE to FG and **not crossed — found out by measuring rather than by arriving.**

**THE COST OF THE MISS IS THE MEASURE OF THE RULE.** Four batches of drift cost one batch to repair,
36 entries moved and two gates re-pointed. That is cheap **because the changelog is append-only
prose**. `CLAUDE.md`'s would not be: FF measured that there is no third seam of its kind, so the
next batch to reach 290 KiB has two moves and both are the designer's. **Finding that out early is
the whole value.**

---

## §3 — SIX FALSE CLAIMS, CORRECTED TOWARD THE CODE

**FF reported four and left them. Two more were sitting in the same blocks**, found by sweeping the
mechanism rather than the section — EH §2's rule, paid again.

### 3a. THE ONE THAT IS AN INSTRUMENT: `check_es` §1 HAD NEVER ONCE FIRED

| | |
|---|---|
| **what it said** | `DORMANT: the authored pool is empty (ET §1), so this is 100% by construction and the flatness arm cannot fail. It wakes with the first authored rune.` |
| **what the code does** | **21 runes are authored.** The sample member is `{"key": "warrior", "spec": "berserker"}` and the Berserker is one of the **eight specs with no authored rune**, so `eligible_ids` returns `[]`, the pool is the five stat-stick templates alone, and the share reads 100% / 100% / 100% **for a second reason nobody had written down.** |
| **the claim or the instrument?** | **THE INSTRUMENT — and specifically its SAMPLE.** The assertion was correct, the arm was not broken, and no line of the check had changed. **A sample is part of an assertion's territory.** |

**THE FIX IS ONE WORD AND THREE THINGS FOLLOW FROM IT.** The member is a **Warden**: the same class
key, so `_template_markers`' warrior exclusion is untouched and the generated family is the same
five, against the five runes EZ authored for the spec. Measured across all six candidate specs —
berserker 0 eligible, **warden 5**, swordmaster 0, occultist 5, beastmaster 6, sharpshooter 4 (one
requires an ability the base kit lacks). The arm now reads **51.4% at every zone slot**.

**AND THE VACUITY IS AN ASSERTION NOW RATHER THAN A PRINT, WHICH IS THE HALF THAT GENERALISES.** The
reason this went four batches is that `DORMANT` was a `print`, and **a battery cannot go red on a
print.** ET wrote it for exactly the right reason — *a vacuous check prints exactly like a clean
one* — and stopped one step short: the condition that made the check vacuous was known, stated, and
expressible. **Two arms fail now** — the sample spec must have an authored rune, and the offer must
not be all one family.

**THE BAND CAME OFF AND THE TRIPLE IS SEEDED, AND THAT IS NOT A LOOSENING.** Awake, the share is
p ≈ 0.50, so 900 draws a slot carry a standard error of **1.67 points** and the RANGE of three lands
outside the old **4.5-point band 13.6% of the time** — **the arm would have become a coin flip the
moment it started measuring anything.** The band was sized for a distribution that never existed.
The project's own rule is exact about this: *a margin only works if it is WIDER than the noise it
sits on*, and *if the propagated noise is wider than the band the question needs, THE BAND IS NOT
AVAILABLE: seed the pair and assert exactly.* **Widening it to 8 points would have been the tempting
move and would have deleted the check.** The zone slot is an unread parameter, so three
identically-seeded runs must draw the identical **sequence** — which also catches a zone that
changed *which* authored rune came up, where a share comparison would not.

**`check_es` GOES 44 → 46. THE CONTROL IS HEAD's OWN CODE:**

| arm | result |
|---|---|
| the berserker sample, against **HEAD** (measured in the pre-pass) | **44 / 0 — green** |
| the berserker sample, against the repair | **46 / 2** |
| `Runes.generate` made to READ the zone slot | **46 / 1** on the sequence arm |
| clean | **46 / 0** |

### 3b. THE FIVE THAT ARE CLAIMS

| # | what it said | what the code does | fix |
|---|---|---|---|
| 1 | `CLAUDE.md`: *"with the pool empty it is 100% at every slot BY CONSTRUCTION and the arm cannot fail. **It prints DORMANT rather than passing quietly**"* — present tense | The pool has not been empty since EZ. The arm printed DORMANT **for four batches after it should have woken**, for the reason in §3a. | **the claim** |
| 2 | `CLAUDE.md`: *"**PRICE IS THE OPEN QUESTION AND NO RULE WAS INVENTED FOR IT.** The 53 offerable runes carry prices of 50 / 75 / 100 / 120 / 160 … That is a design decision and it is the designer's."* | **EZ §0 closed it seven batches ago**: 100g flat, all 21 live runes read 100, `check_ez` §0 asserts it as an equality. **`A RUNE IS 100g, FLAT` is 330 lines below this bullet in the same file.** | **the claim** |
| 3 | `data/glossary.json` `merchant`: *"one rune offered to each hero **who has a free slot**"* | `shop_screen._roll_offers` loops **every** party member and calls `Run.rune_slots()` **nowhere**. **`_buy_rune` does not either** — so there is no refusal at the purchase: a rune bought with three worn goes into the pouch **unequipped**. The cap is enforced where a rune is **WORN**. | **the claim** |
| 4 | `CLAUDE.md`: *"it is a flat ~30% at every slot now — and **100% at every slot since ET §1 retired the authored pool**"* | False since EZ. It is flat at every slot, and the **level is the drawing spec's own pool depth**: 100% for the eight unauthored specs, 50 / 55 / 50 / 60% for Warden, Occultist, Beastmaster, Sharpshooter. | **the claim** (not named by FF) |
| 5 | `CLAUDE.md`: *"The retired **65** keep their authored prices (50g ×1, 75g ×14, **100g ×27, 120g ×6, 160g ×5**)"* | The file held **50×1, 75×14, 100×41, 120×3, 160×6 = 65** on the day that was written, and **66** today after FC. | **the claim** (not named by FF) |

**#3 IS WORTH TWO EXTRA NOTES.** First, **the same false sentence was in a SECOND player-facing
surface** — `scripts/map_screen.gd`'s map-node scout tooltip, *"one rune offered to each hero who
has\na free slot"* — which nobody had named; both are corrected, and the widths are measured in code
rather than counted by hand (48 and 48 against a 53-character worst line in that function).
**Second, FF's own diagnosis was not quite what the code does.** FF wrote *"the slot refusal happens
at the purchase, which is where `master.html`'s 13.6 shop-rune refusals a run comes from"* — but
`_buy_rune` has no slot check either. **That figure is `run_sim`'s BOT policy** (`if worn >=
run.rune_slots(): rune_refused_noslot += 1`), and `master.html`'s two mentions of it both describe
the sim bot and are **accurate**. *Verify the recommended fix, not just the finding.*

**#5 IS A DIFFERENT SPECIES AND IS WORTH NAMING.** The **total** beside the breakdown was right when
it was written and has since gone stale by one in the ordinary way. **The breakdown was never true.**
So the total was measured and the split was written to look like it — in the same sentence, in the
same voice, with nothing a reader could use to tell the two halves apart.

**AND TWO MORE STALE FIGURES WERE FOUND IN `docs/state.md`'s OWN CENSUS BLOCK**, which is the block
that records its own history of arriving stale: FF's "re-measured at FF" list gives
`scripts/talents.gd` at **178.66 KiB** and `scripts/run_state.gd` at **145.34**, and both read
**180.06** and **151.97** at the very commit that wrote those figures. Neither file was touched by
FF or by FG. Corrected, and the threshold estimate is out of that block entirely — `check_fg` §1
prints it now.

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **No rune, card, ability, constant or magnitude moved. No new rune was authored** — eight specs
  and the class runes are still unwritten.
- **No rule was rewritten and no seam was moved.** The one new rule is about instruments and was
  written **straight into `docs/instrument-rules.md`** rather than moved there, so it costs
  `CLAUDE.md` one index row.
- **No entry of the changelog was edited**, proved byte for byte over all 201.
- **`check_dv` §4's boundary arms were RE-POINTED rather than made self-deriving.** They could read
  the cutting batch out of the live header instead of naming it — that arm has now been re-pointed
  three times — but rewriting another gate's shape inside a cut batch is the second change wearing
  one diff. **Recorded, not taken.**
- **`docs/instrument-rules.md` still has no stated ceiling**, so it is the one tracked document with
  nothing watching it. Deriving one is a ruling (EF §2) and it is the designer's.

---

## §5 — VERIFICATION

- **The tree was frozen with a 298-file `rsync` as this batch's FIRST action**, before the first
  byte moved, and the archive was copied with it.
- **DOCUMENTATION WRITTEN BEFORE THE VERIFICATION RUN.**
- **HEAD's unmodified gates run against the cut tree BEFORE any of them was edited** — 20 targets,
  **18 clean**, and the two reds (`check_dv` 83/4 and `check_ec` 25/3) are one cause: §1d.
- **AND RUN AGAIN ONCE THE NEW GATE WAS IN THE TREE**, which is FF §3b's rule. That pass is what
  found `check_ed` 18/1 — six new pins and four moved ones the manifest had never seen — and it is a
  pass the first one could not have made, because `check_fg.gd` did not exist yet.
- **The rejoin proved byte for byte, five ways, never by size** (§1a), and the proof proved by three
  injected arms (§1b).
- **Every negative anchor paired with a positive arm, and every control confirmed to break the
  needle it aims at** — **THIRTEEN CONTROLS, THIRTEEN BITES**: three on the rejoin verifier
  (§1b), three on `check_es` §1 (§3a — one of them is HEAD's own code), and seven on `check_fg`
  (§2c), with the clean arm read before and after each set.
- **Three baseline rows, all written before the battery**, each off **three identical standalone
  readings**: `check_es` **44 → 46**, `check_parse` **170 → 171** (a new battery target raises the
  gate whose count IS its coverage — **a new gate owes two rows**), and `check_fg` new at **22 / 0**.
- **`pin-manifest.json` regenerated: 1406 → 1412** — 13 gained, 7 lost, every one accounted for.
- **THE VERIFICATION RUN, CLEAN.** **97 targets**, `check_de` **398 checks / 0 failures / 0
  notices** — every count in the tree matches its baseline exactly. **`check_fg` 22 / 0,
  `check_parse` 171 / 0 and `check_es` 46 / 0**, all three matching the rows written before the
  run; `check_dv` 83 / 0, `check_ec` 23 / 0, `check_ed` 18 / 0, `check_ea` 86 / 0, `check_ff`
  55 / 0. **All 46 suites green, 0 failures and 0 throws.** **The only red is `check_cm_live` at
  13 / 4, which is its recorded baseline and the one red that is on purpose.**
- **Floor: `grep` stderr for `Parse Error` across all 97 logs — ZERO, and zero `SCRIPT ERROR`.**
  Never a tally and never the exit code.
- **THE TREE WAS md5-FROZEN ACROSS THE RUN: 231 files, byte-identical before and after**, the
  archive included, stamped with absolute paths so a moved working directory could not read as
  drift. **No red was repaired while the battery ran** — there was none to repair.
- **The one process on the machine that is not this batch's is the designer's open Godot EDITOR**
  (`--path`, no `--headless`, 10h elapsed at 1.6% CPU). Not an orphan sim, and not killed.

