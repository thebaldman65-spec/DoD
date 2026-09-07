# BATCH FF — THE INSTRUMENT RESIDUE FOLLOWS EF'S SEAM, AND THERE IS NO THIRD ONE

*2026-09-06. A split batch taken with headroom left rather than at the ceiling. §1 measures the
file and takes what the measurement supports; §2 proves the move; §3 corrects three stale claims in
`master.html` and finds a fourth. **Nothing was pruned, no rule was rewritten, and no game script
was touched.***

---

## §0 — THE BRIEF'S PREMISES, CHECKED FIRST

| Premise | What the repo says |
|---|---|
| *"`CLAUDE.md` is at 284 KiB against EE's 290 KiB ceiling — roughly one batch of headroom"* | **THE DIRECTION IS RIGHT AND THE NUMBER IS WRONG.** HEAD's file is **287,540 B = 280.80 KiB**, so headroom was **9.20 KiB**, not 6. The figure came from FE §5 and `docs/state.md` carried it forward — **a number quoted from one document into another** (DJ §3). At the measured mean of +4,315 B/batch that is 2.2 batches; **at the worst batch on record it is 1.1**, which is why the brief's conclusion survives its arithmetic. |
| *"ED read all 43 uncited blocks and found ZERO dead"* | **TRUE, and the census reproduces its shape.** `claude_md_census.py` at HEAD reads 105 blocks, 20 asserted / 35 quoted / **50 neither** at window 22 — 36.6% of the characters. The count moved with the file; the finding did not, and **never-quoted is still not dead**. |
| *"EF took the first seam — 26 blocks to `docs/instrument-rules.md`, leaving 175 KiB and 69 KiB"* | **TRUE.** EF's commit reads 179,674 B = **175.46 KiB** and 71,515 B = **69.84 KiB**. |
| *"EF measured the instrument half growing nearly twice as fast over its five post-prune batches"* | **TRUE, AND EF SAID IN TERMS THAT IT WAS COMPOSITION RATHER THAN A LAW. TWENTY-FIVE BATCHES SETTLE IT: IT WAS COMPOSITION.** §1a. |
| *"the seven `STANDING REFERENCE` blocks are the one [seam] still available"* — `CLAUDE.md`'s ceiling block | **FALSE TWICE.** There are **eight** (EK/EL added one), and they are **not available**: the two largest are the protected cores and the engine/axis/tag vocabulary, both of which bind what the game may contain, so EF's own tiebreak keeps them. Corrected in place. §1c. |
| *"FE found three of my premises false"* | **TRUE** — `docs/reports/FE.md` §0, and one of them decided how FE §2 was written. |

---

## §1 — THE SEAM, MEASURED RATHER THAN PROPOSED

**The brief said not to take a seam from it, because its proposals have been wrong about a
population every time. The measurement is what follows, and it changed the answer.**

### 1a. WHAT `CLAUDE.md` IS MADE OF, BY WHAT EACH BLOCK BINDS

All **105 blocks** (the preamble plus one per `##`/`###` heading — `claude_md_census.py`'s own
segmentation, asserted to partition the file) classified by EF's test: *what does this rule BIND?*

| group | blocks | KiB | share |
|---|---|---|---|
| **COMBAT RESOLUTION LAW** — the engine's rules | 24 | **66.74** | 23.8% |
| **CARD / ABILITY AUTHORING LAW** | 21 | **59.12** | 21.1% |
| BATCH METHOD / INSTRUMENT — how a batch measures and records | 15 | 31.84 | 11.3% |
| **RUNE LAW** | 10 | 25.39 | 9.0% |
| FILE CONSTITUTION — what this file is, the ceiling, the sync, verify-the-brief | 9 | 19.87 | 7.1% |
| **TALENT LAW** | 7 | 17.96 | 6.4% |
| **DIFFICULTY / LADDER / ENEMY LAW** | 7 | 17.38 | 6.2% |
| *Working agreement* — mixed: docs contract, text standard, four instrument bullets | 1 | 16.55 | 5.9% |
| CODE MAP / REFERENCE — where a thing lives | 5 | 14.60 | 5.2% |
| **MISC RULINGS** — naming, contagion, `hexed`, the autoload trap | 4 | 8.02 | 2.9% |
| **ITEMS AND THE POUCH** | 2 | 3.33 | 1.2% |
| **TOTAL** | **105** | **280.80** | |

**THE BOLD ROWS ARE RULES ABOUT WHAT THE GAME MAY CONTAIN AND THEY ARE 197.94 KiB — 70.5%.** Add
the *Working agreement*'s text-standard and docs halves (9.84 KiB of its 16.55) and it is
**207.78 KiB, 74.0%: three quarters of the required read.** EF's tiebreak — *where a rule does
both, it STAYS* — is a one-way valve, and every byte of that is behind it.

### 1b. SO THE SEAM IS THE RESIDUE, AND THE RESIDUE IS WHAT LEAKED BACK SINCE EF

**34 blocks have been added to `CLAUDE.md` since EF took the seam. Seven of them are instrument
rules that should have been written into the reference and were not.** That is the population,
derived off the diff against EF's commit rather than off a proposal — and it is the only group in
the table that EF's tiebreak does not protect.

| what moved | KiB | why it is not a rule about the game |
|---|---|---|
| *Working agreement* bullets: bands, flakes, the battery count grep, the parse floor | **6.68** | binds `baselines.json`, `run_battery.sh` and `check_parse`; names no game object |
| `### THE SHELL, THE ENGINE AND THE FILES` | 3.12 | zsh word-splitting, `json.dumps` round-trips, `class_name` imports, GDScript gotchas |
| `RUN HEAD'S OWN GATE AGAINST THE NEW CODE BEFORE RE-POINTING IT` (FA §1b) | 2.43 | binds gates |
| `A SNAPSHOT TAKEN MID-WAY…` (FA §5) | 2.48 | binds a before/after sweep |
| `THE READ SITE IS THE LINE, NOT THE FUNCTION` (EU) | 2.28 | *"it is about how a census is taken"* — its own words |
| `AN ARM IS NOT READ UNTIL ITS PROCESS HAS EXITED` (EV §6g) | 1.52 | binds reading a sim arm or a battery log |
| `AN EXACT COUNTERFACTUAL IS EXACT ABOUT THE PAIRING` (EX §1b) | 1.50 | binds how a measurement is quoted |
| `PROSE RECORDING A REMOVAL…` (EV §5) | 1.35 | binds an instrument pinning a word absent |
| **total** | **21.36** | |

**FOUR CANDIDATES WERE READ AND KEPT, PER-BLOCK RATHER THAN BY CATEGORY.** `ADDING A NAME TO A
TABLE IS NOT A CHANGE…` reads as method and ends *"DO NOT INVENT A PSEUDO-STATUS"* and *"the
bespoke condition owes the tooltip line"* — it binds the game. Same for `THE AUTOPLAY HEURISTIC'S
REFUSAL LIST` (*"that is a defect in the door"*), `ESTABLISH WHY A STRUCTURE IS DEAD` (*"the first
is a design question"*) and `A DOCUMENTED EXCEPTION THAT OUTLIVES ITS JUSTIFICATIONS` (it suspends
a game rule). **`VERIFY THE BRIEF AGAINST THE REPO` and `A PRECEDENT IS A CLAIM` were the sharpest
call and they stay**: they bind neither the game nor an instrument, they bind the batch's *reading*
— and moving the rule that catches a false premise out of the required read is the one move that
could cost more than it saves. FE proved its value three times over in one batch.

### 1c. IT WENT INTO THE FILE THAT ALREADY EXISTS, AND THAT WAS THE MEASUREMENT'S CALL

The brief's file list names *"the new reference file"*. **A third file is the wrong answer and the
repo says so in three places.**

- **THREE INSTRUMENTS NAME THE TWO HALVES BY PATH TODAY** — `check_ea` §3's sweep regex
  (`res://(?:CLAUDE\.md|docs/instrument-rules\.md)`), `check_ec`'s `DOCS` table, and
  `build_pin_manifest.py`'s. **A third file is a territory hole dug in three places at once**,
  which is precisely what EC §2 exists for; EF widened `check_ea` §3 for exactly this reason and
  wrote *"a sweep bound to `CLAUDE.md` alone would have reported a clean tree with the whole
  instrument half outside its territory."*
- **A THIRD FILE COSTS A SECOND POINTER BLOCK IN THE REQUIRED READ**, giving back part of what the
  move buys, and it is a third place to look — which is the direction EF's own constraint runs
  against.
- **AND THE REFERENCE HAS THE ROOM, MEASURED.** §1d.

### 1d. EF'S GROWTH-RATE PREDICTION IS SETTLED, AGAINST ITS OWN RECENT NUMBER

EF read `+1,890 B/batch` for the main half and `+3,623` for the instrument half over the five
post-prune batches, and wrote: *"the recent reading is what five instrument batches in a row look
like — it is composition, not a law."*

**Measured over the twenty-five batches from EF's split to FE, every commit:**

| | EF | FE | per batch |
|---|---|---|---|
| `CLAUDE.md` | 179,674 B | 287,540 B | **+4,314.6 B = +4.21 KiB** |
| `docs/instrument-rules.md` | 71,515 B | 74,419 B | **+116.2 B = +0.11 KiB** |

**The required read grew 37 times faster than the reference.** The reference is very nearly a
static file — 2.83 KiB in twenty-five batches. **EF was right to distrust its own most recent
number**, and the transferable half is that a five-point trend does not carry a prediction the
project should route around.

### 1e. THE RESULT, AND WHAT IT COSTS

| | FE | FF | |
|---|---|---|---|
| `CLAUDE.md` | 287,540 B = **280.80 KiB** | 267,291 B = **261.03 KiB** | −19.77 |
| `docs/instrument-rules.md` | 74,419 B = **72.67 KiB** | 97,511 B = **95.23 KiB** | +22.55 |
| the two together | 353.48 KiB | 356.25 KiB | **+2.78** |
| headroom to 290 KiB | **9.20 KiB** — 2.2 batches at the mean, **1.1 at the worst on record** | **28.97 KiB** — 6.9 mean, **3.6 worst** | |

**THE SPLIT'S OWN COST IS +2.78 KiB** — eight index rows, one new `##` heading, the two header
corrections and the ceiling block's. About two-thirds of a batch, to buy about five.

**STATED PLAINLY BECAUSE IT IS THE ONE UNCOMFORTABLE NUMBER: the reference now reads 95.23 KiB
against the 95 KiB EF derived for it.** EF costed that figure and **deliberately did not take it** —
`CLAUDE.md` says in terms that *"`docs/instrument-rules.md` is under the same procedure and has no
stated ceiling yet"*, and deriving one is a ruling. **This batch does not take it either**, and the
case against taking EF's number is in §1d: it was derived from a `+5.00 KiB` worst batch (DX) that
was itself building the file, against a file that has since grown 116 B a batch.

### 1f. AND THE FINDING WORTH MORE THAN THE BYTES: THERE IS NO THIRD SEAM OF THIS KIND

**The residue is spent.** Three quarters of the file is game-content law that the tiebreak keeps by
construction; the `STANDING REFERENCE` blocks the ceiling block named as the remaining cut are not
available; and what moved this batch is what leaked back in twenty-five batches, refilling at
roughly a block a batch.

**A later batch at 290 KiB is not looking for a seam. It has two moves and both are the
designer's:**

- **RE-DERIVE THE CEILING PER HALF.** EF costed it (`docs/reports/EF.md` §2: 220 KiB and 95 KiB)
  and left it as a ruling. Its `CLAUDE.md` term is already stale — 220 KiB is below today's file.
- **OVERTURN THE ONE-WAY TIEBREAK**, and accept that a batch may have to open two files to find a
  rule about the game. That is the constraint doing all the work here, and it is EF's, not a law.

**Written into the ceiling block so it is not re-derived from a proposal**, which is the failure
this batch was told to avoid.

---

## §2 — EVERY PIN CHECKED BEFORE A BYTE MOVED, AND THE REJOIN PROVED BYTE FOR BYTE

### 2a. THE PIN MAP: 65 NEEDLES, 27 READERS, ZERO IN THE PAYLOAD

**Two independent needle sources, unioned**, because either alone has a hole: `pin-manifest.json`
(ED §2's authority, 66 `CLAUDE.md` entries) and a source extractor matching **the identifier
ASSIGNED from `res://CLAUDE.md`** rather than the literal — DZ §3's lesson, a needle can sit three
hundred lines below its read. Escaped quotes resolved, the `.to_lower()` hop allowed for.

**65 distinct needles. 47 locate outside the payload, 18 resolve nowhere, and ZERO locate inside
it.** The 18 are pre-existing and correctly so: most are negative pins asserting absence, and the
positive ones are **or-group siblings** — `check_dv` §6 is `ok(cm.contains(A) or cm.contains(B))`
where `B` resolves and `A` does not, which is what `check_ec` §1 exists to read correctly.

**THE READER POPULATION IS 27, NOT THE MANIFEST'S 25.** `check_dj` and `check_ec` reach the file
through a **dictionary of paths** rather than a `var` assignment, so neither the manifest's
extractor nor `check_ea` §3's regex sees them. Recorded, not repaired — both are correct today.

### 2b. AND THE SWEEP WAS CHECKED THE WAY EF PROVED IT HAS TO BE

**A needle sweep has holes a run finds.** So: **40 unmodified suites and gates — every reader of
`CLAUDE.md`, `docs/instrument-rules.md` or `docs/master.html`, plus `check_ea`, `check_ed`,
`check_es` and `check_parse` — were run against the split tree BEFORE one assertion was edited.**
FA §1b's rule, and this is the pass it exists for.

**All forty green. 0 failures, 0 throws.** No re-point was necessary, and that is measured rather
than assumed — which is EF's own distinction between a re-point that is necessary and one that is
decorative.

**TWO CONTROLS, BOTH BIT, ONE PER HALF:**

| arm | what was broken | result |
|---|---|---|
| the main half | `A DOCUMENTED EXCEPTION THAT OUTLIVES ITS JUSTIFICATIONS` broken in `CLAUDE.md` | `check_dr` **80 / 1** |
| the reference | `BINDING ON EVERY CONTENT BATCH FROM IT` broken in `docs/instrument-rules.md` | `test_batch_ce` **1114 / 1** |

**THE FIRST ARMING OF THE FIRST CONTROL DID NOT BITE, AND THAT IS THE ENTRY WORTH HAVING.** The
needle occurs **twice** in `CLAUDE.md` — once as the `###` heading and once inside a `·` bullet —
and breaking only the first left the pin satisfied by the survivor. **80 / 0: identical to the
clean run.** A control that reads green because it did not actually break its needle is
indistinguishable from a suite that has stopped reading.

### 2c. THE REJOIN, PROVED FOUR WAYS AND NEVER BY SIZE

Against `git show HEAD:` for both halves, in one script:

1. **the main half plus the payload re-concatenates to HEAD's `CLAUDE.md`, byte for byte** (287,540 B);
2. **each of the 8 payload ranges appears verbatim EXACTLY ONCE in the reference and NOT AT ALL in `CLAUDE.md`**;
3. **the reference equals HEAD's reference plus exactly three insertions, byte for byte** (74,419 → 96,893 B before the header correction);
4. **the headings partition: 104 = 97 main + 7 moved**, zero overlap, order preserved on both sides.

**NO SIZE WAS COMPARED.** Two sizes agreeing is consistent with a duplicated block and a dropped
one. That is now a rule in the reference file's header, where the next split will read it.

### 2d. THE INDEX HAZARD, WHICH THIS BATCH MADE EIGHT TIMES LARGER

EF proved by two-armed control that **an index of headings can satisfy a pin**: rewording the rule
reds, rewording the index does not. **FF adds eight index rows, so it adds eight more places a
future pin can pass without ever reading a rule.**

- **CHECKED ONCE, FOR THIS BATCH:** every one of the eight moved headings is a heading line in the
  reference **exactly once**, is a heading line in `CLAUDE.md` **zero times**, and survives in
  `CLAUDE.md` as **exactly one table row and no other line**. No needle in the whole 63-literal
  population resolves only inside the index span.
- **AND SWEPT LIVE, WHICH IS THE HALF THAT KEEPS WORKING.** `check_ff` §4 walks every suite and
  gate, matches the variable assigned from `res://CLAUDE.md`, locates every literal, and **fails on
  any whose only occurrence is inside the index table.** It prints `CHECKED 63 literals across 26
  readers` and asserts both floors, because a regex that stopped matching reports a clean tree
  exactly as loudly as a clean tree.

### 2e. `check_ff.gd` IS NEW — 55 CHECKS, AND ITS THREE CONTROLS ALL BIT

**§2's body needles are the sharp half.** A heading can be an index row; **a sentence out of the
middle of a rule cannot**, so §2 is what separates *the rule moved* from *the title moved and the
rule was dropped*.

| control | result |
|---|---|
| a moved rule put back into `CLAUDE.md` as a heading | **2 reds in §1** |
| `A COMMENT CANNOT CONCATENATE` deleted from the reference | **1 red in §2** |
| a pin armed on a moved heading, whose only `CLAUDE.md` occurrence is now an index row | **§4 accused it by name — while the pin itself PASSED** |

**The third arm is the whole fault in one line**: the assertion goes green, and §4 is the only thing
that says the rule it names is not in the file.

**AND THE GATE'S OWN TERRITORY WAS A CLAIM IT FAILED FIRST.** Its initial draft read the two
documents into member vars (`_cm = cm`), which breaks `build_pin_manifest.py`'s holder propagation
— **so all six of its document pins were invisible to the manifest and unenforceable by
`check_ed`**, and `--check` reported the manifest *current*. Caught by running the builder rather
than by reading the gate. §3's holders are now assigned from the path literal in the function that
asserts, the manifest went 1400 → **1406 pins**, and `check_ed` enforces all six.

---

## §3 — THE STALE `master.html` CLAIMS, CORRECTED TOWARD THE CODE

FD named three and FE left them deliberately as a different mechanism. **All three sat in the rune
section roughly a hundred lines BELOW a passage stating the current truth** — the document
contradicted itself inside one section, under two headings.

| the claim | what the code says | measured from |
|---|---|---|
| *"the 53 ET retires"* | **87 entries, 66 retired.** ET retired 65; EO's twelve are inside that, and FC's Split Tongue is the 66th. | `data/runes.json` |
| *"Flat pricing is ruled; the number is not, and with the pool empty there is nothing left to price"* | **BOTH HALVES FALSE.** 21 live runes, and the number was ruled at EZ §0 — **100g flat**, which all 21 read. The 66 retired keep their authored prices: 100 ×42, 75 ×14, 160 ×6, 120 ×3, 50 ×1. | `data/runes.json`, `CLAUDE.md`'s `A RUNE IS 100g, FLAT` |
| *"Spec coverage: 65 authored runes — 5 universal, 3 class-wide for each of the four classes"* | **That is the RETIRED pool's authoring structure.** The live pool is **21 runes, every one `spec:`-scoped, across four specs** (beastmaster 6, occultist 5, warden 5, sharpshooter 5). **No universal and no class-wide rune is in the game.** | `data/runes.json` |

**AND SWEEPING FOR THE MECHANISM FOUND A FOURTH THE BRIEF DID NOT NAME, ONE LINE ABOVE THE SENTENCE
BEING FIXED**: the headline *"PRICE IS THE OPEN QUESTION RARITY LEAVES BEHIND, AND ET DOES NOT
ANSWER IT EITHER"*, which the correction directly contradicts. It now reads *"PRICE WAS THE OPEN
QUESTION RARITY LEFT BEHIND, AND EZ §0 ANSWERED IT: 100g, FLAT."* **A batch sweeps the section it
is writing in; the mechanism does not respect section boundaries** — EH §2's rule, paid again.

**A FIFTH CANDIDATE WAS READ AND CORRECTLY LEFT.** `master.html`'s *"AND TWELVE OF THEM ARE RETIRED
(Batch EO §3): 65 authored, 53 OFFERABLE"* already carries an explicit `(SUPERSEDED TWICE …)`
banner naming both supersessions. **A labelled-superseded claim is not a stale claim** — it is the
reasoning the next retirement is argued against, kept on purpose.

### 3a. THREE MORE FALSE CLAIMS, REPORTED AND DELIBERATELY NOT FIXED

**A split batch that also repairs the rune layer is two changes wearing one diff** — §4's own rule,
applied to the instrument side.

- **`check_es` §1 STILL PRINTS `DORMANT: the authored pool is empty (ET §1) … It wakes with the
  first authored rune`. TWENTY-ONE RUNES HAVE BEEN AUTHORED AND IT DID NOT WAKE.** The arm is not
  broken and the gate is not red; **its stated reason is false**. Its sample member is
  `{"key": "warrior", "spec": "berserker"}`, and the Berserker is one of the **eight specs with no
  authored rune**, so `Runes.generate` returns only `tpl_` stat sticks and the share reads
  100% / 100% / 100% exactly as it did when the pool was empty. **The fix is one word — a spec that
  has authored runes — and it changes what the flatness arm measures, so it needs its own arming
  and its own controls.** This is a check that has stopped asking its question while printing that
  it knows it has.
- **`CLAUDE.md` STATES THAT DORMANCY AS PRESENT-TENSE FACT** inside `THE OFFERABLE RUNE POOL IS
  RETIRED`. §4 of the brief: a rule that needs correcting is reported and left.
- **AND THE SAME BLOCK'S NEIGHBOUR CONTRADICTS A LATER RULING IN THE SAME FILE.** `THERE ARE NO
  RUNE RARITY TIERS` still reads *"The 53 offerable runes carry prices of 50 / 75 / 100 / 120 / 160
  … That is a design decision and it is the designer's"*, which `A RUNE IS 100g, FLAT` (EZ §0)
  overturned. **Two blocks of one file, 330 lines apart, giving opposite answers** — the same shape
  DL found after CW's split.
- **THE `merchant` GLOSSARY ENTRY IS FALSE ABOUT THE OFFER.** It says the Peddler offers a rune
  *"to each hero who has a free slot"*. `shop_screen._roll_offers` loops **every** party member and
  **never calls `Run.rune_slots()`** — it skips only when runes are off or when four draws all
  duplicate a rune the hero owns. The slot refusal happens at the **purchase**, which is where
  `master.html`'s own *"13.6 shop-rune refusals a run for no free slot"* comes from. **Player-facing
  text: it goes through `docs/text-standard.html`, not through a split batch.**

---

## §3b — THE BATTERY'S ONE UNPREDICTED RED, AND IT IS A HOLE IN MY OWN PRE-PASS

**`check_ea` came back 87 / 2 against a recorded 86 / 0.** Its §3 forbids any literal matching
`BATCH <1–3 capitals>` from being pinned into either rule file — EA §2's repair made permanent,
because a check reading `CLAUDE.md.contains("BATCH XX")` asserts the presence of a structure that
no longer exists and passes off a standing rule that names the batch in passing.

**The accused literal was `check_ff`'s own.** §3 pinned the reference's opening sentence — *"THE
FILE A BATCH IS REQUIRED TO READ IS `CLAUDE.md`"* — and the regex reads **`BATCH IS`** as the
two-letter batch code `IS`.

**THE GATE IS RIGHT AND THE NEEDLE IS THE HALF THAT MOVED.** `check_ea` §3 is deliberately blunt;
narrowing it to exclude English words is editing another batch's instrument to accommodate this
one, and the needle costs nothing to move. It now reads `REQUIRED TO READ IS \`CLAUDE.md\`` — the
same sentence, one clause later. **`check_ea` returns to 86 / 0 exactly**, so no baseline moved.

**TWO-ARMED CONTROL, BOTH ARMS READ:** the batch-code-shaped needle restored → **87 / 2**, naming
`check_ff.gd` by file; repaired → **86 / 0**. The diagnosis is not inferred from the fix.

**AND THE TRANSFERABLE HALF IS ABOUT WHEN FA §1b's PASS IS RUN.** I ran it — forty unmodified
targets against the split tree, all green — **and it could not have caught this, because
`check_ff.gd` did not exist yet.** FA §1b's rule is *run HEAD's own gate against the new CODE
before re-pointing it*; the case it does not cover is **HEAD's own gate against the new GATE**. A
batch that writes a new instrument owes the pass **twice**: once against the changed tree, and
again once its own instrument is in the tree. The first pass is about what the batch changed; the
second is about what the batch added, and the second is the one that found this.

**IT COST NOTHING BECAUSE THE RED WAS NOT REPAIRED WHILE THE BATTERY RAN.** The run was allowed to
finish and every count read first — 91 targets, and `check_ea` was the only movement in the whole
tree. The tree was **md5-frozen across the run and 229 files came back byte-identical.**

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **Nothing was pruned.** ED measured zero dead blocks and that measurement stands.
- **No rule was rewritten.** Every moved byte is byte-identical to what stood in `CLAUDE.md`, proved
  in §2c. The only new prose is one `##` heading marked as the reference file's own, eight index
  rows, and factual corrections to two headers and the ceiling block.
- **No rune, card, constant, ability or magnitude moved. No game script was touched.**
- **No new rune was authored.** Eight specs and the class runes are still unwritten.
- **No existing suite or gate was edited** — `check_ff.gd` is new and nothing else changed.
- **The four rune-layer findings in §3a were reported and left**, with the one-line fix named.

---

## §5 — VERIFICATION

- **Documentation written BEFORE the verification run**, and the tree frozen with a 295-file
  `rsync` taken as this batch's **first action**, before the first byte moved (FA §5).
- **HEAD's unmodified gates run against the new tree before any of them was edited** — 40 targets,
  **0 failures, 0 throws** (§2b).
- **The rejoin proved byte for byte, four ways, never by size** (§2c).
- **Every negative anchor paired with a positive arm, and every control confirmed to break the
  needle it aims at** — five controls, five bites, and one first arming that did not bite and was
  re-armed (§2b, §2e).
- **The battery run twice: once to collect (91 targets, one unpredicted red, tree md5-frozen and
  229 files byte-identical across it), then re-frozen and run again clean after the repair.**
- **Two baseline rows, both written before the battery**: `check_ff` at 55 / 0 off three identical
  standalone readings, and `check_parse` **169 → 170**, because a new battery target raises the
  gate whose count IS its coverage and **a new gate owes two rows**.
- **`pin-manifest.json` regenerated: 1400 → 1406.**
- **THE VERIFICATION RUN, CLEAN.** 96 targets, `check_de` **394 checks / 0 failures / 0 notices** —
  every count in the tree matches its baseline exactly. **`check_ff` 55 / 0 and `check_parse`
  170 / 0**, both matching the rows written before the run. **The only red is `check_cm_live` at
  13 / 4, which is its recorded baseline and the one red that is on purpose.**
- **Floor: `grep` stderr for `Parse Error` across all 96 logs — ZERO, and zero `SCRIPT ERROR`.**
  Never a tally and never the exit code.
- **The tree was md5-frozen across the run: 229 files, byte-identical before and after.**
