# BATCH IQ — THE THREE DOCUMENTS, AND ONE CRASH

**On `class-merge`, from `6897d73` (IP). IMPLEMENT ONLY.** `git ls-remote origin class-merge` read `6897d73`, IP's push and local
HEAD, before anything ran. **WHAT THE READOUT HOLDS (§0.1)**: the two files it held at IP — IH's debug-touched one and the clean
`run-20261018-194229.jsonl`, which `latest.txt` names — **the clean file still the one run, zone one through its boss: it has not
grown** (24,340 B, md5 `610bcd8c2b43f97703e63053e86728fa` at the open and the close), and `run_save.bin` still holds the run at zone
two's start. Both were backed up with the player's files before anything ran (`../save-backups/IQ-20261019-143844`) and touched by
nothing. **Both readings are comfortable** — `CLAUDE.md` 19.6 batches at the IM–IQ mean, `docs/state.md` 50.3 at its honest rate
after §1's cut (THE TWO READINGS, below).

**What IQ did.** **§4 — the stale offer is guarded** (the designer's ruling): `Run.load_run` drops an offered modifier the deck no
longer holds and deals one fewer, drops an offer left empty whole, spends no die and re-rolls nothing; the screen reads the deck
straight on purpose. **The census behind it** — 167 reads of save data through a data table, 133 guarded, 34 not, 22 of them
crashers — **guarded every crasher and the one strand at the same door**, each driven through the real save and load and red on
HEAD's code. **§1 — `docs/state.md`'s census: 130 of 141 blocks bind** (92.5% by bytes); nine closed blocks and 95 closed items moved
to the archive word for word, each record read first, and eight tables struck to a pointer — **370,043 → 279,425 B before IQ wrote a
line, 284,849 B at its close.** **§2 — `master.html` swept fact by fact**: 5,157 facts, 4,949 agreeing; every disagreement
re-verified at its line and repaired (178 edits), 7 where the code looks wrong (FOUND AT IQ, ruling 5); **695 figures with a door now
read on both sides by `check_iq` §2.** **§3 — the re-measure, priced on both files and not built**: HV's shape reads `CLAUDE.md` at
about 48% less a batch (HV found 38%) and this file 71–77% less; the decision is ruling 2. **§7 — `lane.sh`**: a scratch copy that
would run as the live project does not run. **§0** — the rulings recorded where each binds. **No save version moved.**

**VERDICT: GREEN**

## NEEDS A RULING

1. **A SECOND RUN, WITH A DIFFERENT PARTY** (carried from IP's ruling 1, IQ's brief §0.1). The readout's clean file is md5-identical at
   IQ's open and close — the run has not been played on — every figure in THE FIRST CLEAN PLAYTHROUGH (`docs/state.md`) is one run and one party.
2. **THE BLOCK INDEX, PRICED ON BOTH FILES (IQ §3).** A core read whole, a 250-B index row for every other block, each batch opening
   what it needs: **`CLAUDE.md` read at about 245 KiB of 472 — 48% less (HV found 38%)**, **this file at about 85 KiB of HEAD's 361 —
   77% less** — and on IQ's own, cut file about 80 KiB of 278, 71% less. Over twenty batches the union of what they needed is 82% of `CLAUDE.md`, so the saving is per batch and the
   index must route each batch to its own few; a batch on a wrong premise because it did not open a block is not measurable before
   it happens. **Building it re-points 144 pins in 42 gates (`CLAUDE.md`) and 7 in 4 (this file), and its rows are written by hand.**
   Build it for both files, for one, a pilot first (HV §3f's), or not.
3. **A SAVE THAT NAMES A CLASS THIS BUILD DOES NOT HAVE IS REFUSED AND CLEARED (IQ §4b)** — the floor's path, chosen by IQ: a hero
   cannot be dropped from a party and a class cannot be invented, and two reads of an unknown class default to the Cleric. The
   alternative is HL's newer-save shape, refused and KEPT. No class has ever been removed, so no save has met it. Confirm, or keep it.
4. **A CARD A SAVE NAMES BY ITS OLD NAME (FOUND AT IQ).** CK renamed the Warrior's Iron Will to Ironclad and GN Magic Barrier to Nexus
   Ward, both after the v10 floor, so a save from before either can carry the old name: it holds a slot, shows as a blank takeable
   button in a queued offer, or carries an upgrade that never lands. **Nothing crashes**; the narrowest repair is a rename map at the
   load door. Build it, or leave it.
5. **SEVEN PLACES `master.html` DESCRIBED A GAME THE CODE DOES NOT PLAY, WHERE THE CODE LOOKS LIKE THE THING THAT IS WRONG (FOUND AT
   IQ)**: the Ruin mini-boss's fixed modifier, overwritten by the bargain taken; Fortified Spirit and Undying Vigil, which the picker
   lets fall on a companion, where the loan never decays and the fork never fires; two cards that say *everyone* (Aegis Wall, Hunter's
   Mark); Tithe healing 1 for an attack into a Broken enemy that lands no Break; a block sound loaded and never played; and seven
   statuses the glossary has no entry for. **Each sentence now says what the code does**; which of them the code should change is yours.
6. **185 OF `master.html`'s 871 UNITS CARRY A HISTORY OR RATIONALE CLAUSE, AND IT NAMES A BATCH 117 TIMES** (the stamp aside) — batch
   provenance, *was / now* and *since* notes and dated measurements, against the rule that it shows only what is in the game (the user
   rule of 07-20). IQ repaired what was false and stripped a clause only where it stood inside a repair; stripping the rest is one pass
   of its own. Strip them, or leave them.
7. **ABOUT 80 OF THE CATALOGUE's BEHAVIOUR FIGURES HAVE NO DOOR**: window lengths, Perfect figures and rates written as literals in
   their handlers (`aw_turns := 4`, Blood Offering's 0.20 and 60, Second Wind's 0.40 and 0.55, …). `check_iq` §2 holds every figure
   that has a door; these need a named constant first — a code batch, and a census of its own.

## THE BRIEF's PREMISES, CHECKED

| # | the brief | what the repository says |
|---|---|---|
| 1 | §7: premise 1 is IP's push hash | **`git ls-remote origin class-merge` read `6897d73`, IP's push and local HEAD, before anything ran.** |
| 2 | §0.1: `run_save.bin` stands at zone two's start, and the readout appends to the same file | **Both true.** The save (55,264 B) decodes as v15 at `zone_idx` 1, slot −1; the readout's `latest.txt` names the clean file, and a resumed run appends to the file the pointer names. **The file has not grown** (§5). |
| 3 | §0.2: Deadened and Rot 0.0006 apart, Parched and Slick Footing 0.0026 | **True** (IP §1b: against two standard errors of 0.0105 and 0.0071). |
| 4 | §0.3: §1a's removal shifted every cut one place, so none of the brief's three pairs sat at a cut | **True** (IP's premise 14). |
| 5 | §0.4: six moved where the table moved four | **True** (IP §1b). |
| 6 | §0.5: Wanderer 0.956, Warden 0.908, Ruin 0.687; gaps 0.048 and 0.221 | **True** (IP §1c), and the gaps are the subtraction. |
| 7 | §1: this file's honest rate is 9.1; `CLAUDE.md` came back 119 of 126 binding | **Both true** (IP's two readings; II §4). |
| 8 | §2: IK found `master.html`'s Blood Price row claiming 15% of current health and a halved Perfect cost, for a card that takes 7.5% and runs no check | **True** — IK's report, and the row reads 7.5% and no check today (the census agreed). |
| 9 | §2: IP alone rewrote the ladder table, the dealing paragraph and the Dark's row | **True** (IP's diff of `master.html`). |
| 10 | §2: the resolver exists and `Relics.desc_of` and its siblings are its readers | **True** — `Classes.resolve_figures`, read at the six doors `CLAUDE.md`'s IJ §2 bullet names. **But `master.html` is a document no door renders**, so its figures cannot be tokens: *convert* here means an instrument reads both sides (§2c), II §0.7's second form. |
| 11 | §3: HV priced the block index at about 38% off the read | **True** — HV §3f: 229–297 KiB a batch, 266 on the mean, of 433. |
| 12 | §4: `offer_screen._draw_option_parts` reads `Run.MODIFIERS[id]` unguarded | **True**, driven: HEAD's code draws two cards for one stale id and none for three (§4a). |
| 13 | §4: IO's two removals carried the same exposure, and nobody saw it | **Half.** IO's two did carry it; **IP saw it** — FOUND AT IP's own item names *Famine or Cruel Order* beside the Dark. |
| 14 | §4: `_active_modifier` asks the deck, and IP drove it both ways | **True** (`check_ip` §1a). |
| 15 | §4: the retired rest node, the twelve retired trees, Famine and Cruel Order, the Dark — the saves predate all of it | **Not all.** The rest node went at AN, before BM's v10 floor, so no save this build loads can name one; the twelve trees' cells are already dropped by `_migrate_trees` and the profile's fold. Famine, Cruel Order and the Dark are the three a loadable save can name (§4's census). |
| 16 | §5: the clean file's md5 is `610bcd8c2b43f97703e63053e86728fa` | **True**, at the open and the close. |
| 17 | §6: the Thin Veil shares Feverish's grade at 0.908 against 0.910; the claims stand at 86 | **Both true.** |
| 18 | §7: IP's three trace copies put the live name back, so four trace runs ran in the player's folder, two at once | **The shape is true; the count is the brief's reading.** IP's report lists *`check_gf` and `check_ih` twice, `check_io` and `check_in` once*. The instrument rule written here names no count. |
| 19 | §7: the gate-source readers were twenty-seven at IP, two routes, no third | **True** (IP's WHERE block). |
| 20 | §7: §1 and §2 move documents that thirteen-plus gates open | **Many more**: `CLAUDE.md` is opened by 47 targets, `master.html` by 34, `docs/instrument-rules.md` by 18, `docs/state.md` by 5 and the archive by 3 by its path, and by `check_hx` §2 through the live file's pointer — `check_iq` among each. |
| 21 | §7: IP read 156 targets in 87 min 21 s | **True** (IP §9). |
| 22 | §7: IP closed at `CLAUDE.md` 472.26 KiB (37.74 under; 4.7 / 19.8) and `docs/state.md` 361.37 KiB (18.63 under; 3.3 / 9.1) | **True** (IP's two readings). |

## §0 — IP's SIX RULINGS, ANSWERED

1. **The second run is carried** (IQ's ruling 1). **What the readout holds, as the brief asks first**: the two files it held at IP —
   IH's debug-touched one (16,291 B) and the clean one (`run-20261018-194229.jsonl`, 24,340 B), which `latest.txt` names — **the
   clean file still the one run, zone one through its boss; it has not grown** (md5 `610bcd8c…` at the open and the close). The save
   still stands at zone two's start, so playing it on would append to that file.
2. **The two ties stand, with no third block** — recorded in `docs/instrument-rules.md` inside the tie rule it qualifies (*a tie
   that survives its second block is a measurement that succeeded*, the designer's words beside it), and the reasoning beside the
   grades in `docs/state.md` so nobody re-measures them. **No grade, count or band moved.**
3. **The pairs are the cut's** — *a tie that matters is a tie at a cut, and the cuts move when the deck does; the pairs are derived
   at the cut, never listed in a brief*, beside IP §0.4's rule.
4. **Confirmed**, and nothing to do.
5. **Warden's target is recorded beside the grades — bargain fights ending between 0.80 and 0.85 of the party's health — and not
   pursued.**
6. **The read is guarded** (§4).

**Every rule is pinned in the file it binds** (`check_iq` §0), never against `CLAUDE.md`'s index row that names it.

## §1 — `docs/state.md`'s CLOSED BLOCKS

### §1a — THE CENSUS

**II's shape, applied to the file that binds now**: four read-only readers, one rubric, a frozen snapshot of HEAD's file (370,043 B,
4,127 lines, md5 `c3da193c…`), cut at block boundaries into four slices (lines 1–980, 981–2015, 2016–3026, 3027–4127; 94,232 /
92,107 / 85,956 / 97,748 B). **The rubric's one addition, because this file is not a rules file**: a block is CLOSED only when its
subject is settled (every ruling answered — read in the later reports' §0 sections — every finding fixed, overtaken or superseded,
verified at its line in the code, or a record that asks nothing) **and** its record stands in a report, named and read; IM §0.7's
ruling is the largest shape of the second half (a measurement's table lives in its report). OPEN is the default, and *when unsure,
OPEN*. Inside an OPEN block the readers listed **closed items** (a bullet or numbered item passing the same test, the shape the
archive has always moved one by one) and **tables** (IM §0.7's cut). **Each reader's byte totals matched its slice exactly.**

| slice | blocks | bytes | OPEN | CLOSED | closed items | tables |
|---|---|---|---|---|---|---|
| 1 (the WHERE block to GX's rulings) | 55 | 94,232 | 55 · 94,232 B | 0 | 16 · 10,648 B | 2 · 712 B |
| 2 (GW's rulings to the merge's running order) | 47 | 92,107 | 45 · 90,196 B | 2 · 1,911 B | 26 · 14,178 B | 3 · 3,533 B |
| 3 (FP's `block_chance` to the five ally-worded texts) | 24 | 85,956 | 17 · 63,447 B | 7 · 22,509 B | 29 · 21,911 B | 2 · 2,854 B |
| 4 (the small owed items to the end) | 15 | 97,748 | 13 · 94,248 B | 2 · 3,500 B | 24 · 14,400 B | 1 · 739 B |
| **all** | **141** | **370,043** | **130 · 342,123 B** | **11 · 27,920 B** | **95 · 61,137 B** | **8 · 7,838 B** |

**THE ANSWER TO II's QUESTION: 130 OF 141 BLOCKS BIND — 92.5% of the file by bytes** (`CLAUDE.md` came back 119 of 126). The file
is not mostly closeable: it is the open queue, the tuning handles and the live references, and the closed matter in it is mostly
inside open blocks — 95 items, 61,137 B, against 27,920 B of whole closed blocks. **So §3's subject is both files** (below).

**The census is kept** (ID §0.6's rule; IC's for the place): the rubric, the slices and every row — one a block, one a closed item,
each with what IQ did with it — are `docs/reports/IQ-state-census.tsv`; the four readers' reports whole and the cut's script are in
the scratchpad.

### §1b — THE CUT, AND WHAT WAS READ BEFORE EACH STRIKE

**IJ §0.2's condition, unchanged: every record was read before anything moved.** For the blocks: each of the eleven read whole
against its record by hand. **Two verdicts overruled, kept OPEN**:
- **`BOND_MITIGATION_MAX` STAYS AT 0.75** (871 B): settled, and its record is EW §3 — **but it binds**, as a do-not-re-propose ruling
  no rule file holds; HX §2 kept it for exactly that reason. A wrongly moved ruling costs more than a closed block left in place.
- **THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED** (2,962 B): its history is DB's to DY's, but it carries **two practices no
  rule file holds** (run the retired-word sweep's own strip over an edited document before the battery; build a hand-built kit
  BEFORE the draft roll, not after). Moving it would take both out of the read.

**The nine moved word for word to `DoD-archive/state-archive.md`**, under IQ's cut at the archive's top (IO §7): WHAT GK LEFT BROKEN;
THE QUIT FIGHT's accepted remainders; TEN OF FK's RUNES HAVE NO SUITE COVERAGE (superseded at GV: `check_gv` §1 drives every live
ordinary rune, the Warrior's ten among them); THE LOYALTY CURVE; THE FOUR RUNE ITEMS; THE FLAKES; NO SWEEP CAN CERTIFY THERE IS NO
NEXT ONE (its rule is the instrument file's); THE FIVE ALLY-WORDED TEXTS; and *Last measurements*, a pointer seven batches old.
**The 95 closed items moved the same way**, each under its section's heading with *— ITS CLOSED ITEMS (archived at IQ; the section
stays in `docs/state.md`)*; I read every one against its record before the cut (the census file names each record).
**The eight tables were struck to their conclusion and a pointer** (IM §0.7) — Tithe's gap figures (HO §3a), HX's claim census (HX
§1d), the three rungs both ways (GJ §1b–§1e), Long Draw's worth (GE §1), Channel's rate (FU §2), the draft audit's arithmetic (DY §5),
EA §3's layer and GZ's threshold figures (GZ §2); every figure stands in its report.

**Proved, not asserted**: a script removed the 904 lines by range and rebuilt the original from what remained and what was removed —
**byte for byte**, before a byte was written — and asserted every removed segment stands in the archive verbatim (II §4b's discipline).
**Two rule-file sentences pointed into what moved, and were re-pointed in the same batch**: `CLAUDE.md`'s GH block (*`docs/state.md`
records both as ACCEPTED*) to GI §4, and the instrument file's *pre-GJ completion* bullet (*`docs/state.md` carries the three rungs'
figures both ways*) to GJ §1b. **The census also found four of the file's own cross-references pointing the wrong way** (*THE FIRST
CLEAN PLAYTHROUGH, below*, from blocks below it); corrected to *above*.

### §1c — THE BYTES, AND THE HONEST RATE AFTER

| | bytes |
|---|---|
| HEAD (IP's close) | 370,043 |
| the census's cut: 9 blocks and 95 items to the archive | −85,225 |
| the 8 tables struck to their conclusions | −5,393 |
| **after §1's cut** | **279,425** |
| IQ's own closures (IP's six rulings, FOUND AT IP, the roadmap's two lines IQ ran) and IQ's writing (its WHERE block, rulings, finds, the grade table's two notes, the shape recon's record) | +5,424 |
| **`docs/state.md` at IQ** | **284,849 B = 278.17 KiB** |

**THE HONEST RATE AFTER.** At IP's close this file stood 18.63 KiB under its 380 KiB ceiling — 3.3 batches at IA's worst case,
9.1 at the honest rate. **At IQ's close it is 101.83 KiB under: 17.8 batches at IA's +5,860 B, and 50.3 at the honest rate** — IM
−4,046, IN +1,476, IO +1,714, IP +5,787 and IQ's own writing +5,424, a mean of 2,071 B. **The cut bought the room; the practice keeps
it** — what a batch closes goes to the archive — and the census says where that practice has to look in a file that is mostly
binding: **95 closed items stood inside open sections, 61,137 B, more than twice the bytes of the eleven closed sections.**

## §2 — `master.html`, SWEPT FACT BY FACT

### §2a — THE PARTITION (IJ's rubric, at this file's scale)

**Eight read-only readers took the frozen file (HEAD's, 3,986 lines) in eight slices of whole units** — 871 units, every paragraph,
list item, table row and heading — against the game's code, its data and a dump of every table the game holds (each ability's
fields, every engine's rule, relics through `Relics.desc_of`, the deck, the rewards, statuses, runes, the glossary, enemies,
events). **Every unit sits in exactly one list; every fact has a row and a site.** IJ's kinds: magnitude, duration, condition,
source, scope, count and name.

| | units | fact-stating | label | instruction | history only | facts | agree | disagree | unread |
|---|---|---|---|---|---|---|---|---|---|
| slice 1 (lines 2–635) | 153 | 128 | 23 | 1 | 1 | 489 | 454 | 13 | 22 |
| slice 2 (lines 636–1267) | 200 | 182 | 18 | 0 | 0 | 727 | 706 | 18 | 3 |
| slice 3 (lines 1268–1828) | 141 | 129 | 12 | 0 | 0 | 505 | 486 | 19 | 0 |
| slice 4 (lines 1829–2004) | 97 | 87 | 9 | 0 | 1 | 682 | 663 | 16 | 3 |
| slice 5 (lines 2005–2277) | 94 | 87 | 7 | 0 | 0 | 902 | 875 | 27 | 0 |
| slice 6 (lines 2279–2858) | 71 | 64 | 7 | 0 | 0 | 920 | 899 | 21 | 0 |
| slice 7 (lines 2859–3403) | 26 | 24 | 2 | 0 | 0 | 520 | 491 | 25 | 4 |
| slice 8 (lines 3404–3986) | 89 | 81 | 7 | 1 | 0 | 412 | 375 | 32 | 5 |
| **all** | **871** | **782** | **85** | **2** | **2** | **5,157** | **4,949 (96.0%)** | **171 (3.3%)** | **37** |

*(Slice 5's reader totalled 904 facts in its summary line and its table holds 902; the table is counted — a reader's prose against
its own table.)*

**Read off the source against stated as a literal.** `master.html` is a document no door renders, so no figure in it reads the code
at render time: **every figure in it is a literal**, and the agreement rate is the literal's. **Where a figure has a door, the batch
converted it the only way a document allows — an instrument that reads both sides** (II §0.7's second form, *or an instrument asserts
the two agree*): §2c.

### §2b — THE DISAGREEMENTS, AND WHAT EACH BECAME

**Every DISAGREES fact was re-verified at its line before a word moved** (the census can be wrong, and three of its proposed words
were: *at most 45 gold* for events that pay up to 200, *no run can empty* the boss award — the claim `run_state.gd` itself forbids —
and a Hex of Ruin *on its lineage's shelf* that is on none). **The words moved to the code, never the code to the words; no batch name
was written into a repair**, and every replacement was checked unique in the file and applied in one pass with the tags balanced.

| | |
|---|---|
| repaired (the code is right, the words moved) | **163** |
| a fact the readers could not settle, settled false and repaired | **8** |
| rejected at the line (the text was true) | **1** |
| the code looks wrong — the sentence made true, the question FOUND AT IQ | **7** |
| **edits applied to `master.html`** | **179** — the 178 above and IQ's own sentence on the load door's guards (§4); some findings took two edits, some two findings one |

**The corners, as the brief expected.** Counts that moved: the draft pools (42 / 52 / 43 / 42, where the text read 43 / 51 / 43 / 41
in two places), the recast gate's 63 (58), the retired runes' 68 (67), the tagged cards' 231 (227), the relic read sites' 22 (25), the
Crest's four runes (two), the bargain screen's five pips (four). Mechanisms two re-cuts old: a three-tier boss award the pool merge
made two, a "stat stick" rune era that ended at EZ, a rest node in the debug menu, the Swordmaster's Seasoned Fighter keyed on health
where it is keyed on stance, a pouch that "only grows". Figures retuned since their row: Blood Offering's 60 Rage (40), Formless's four
turns (three), Eye of the Storm's three (two), Mark of the Hunt's seven (five), Deadfall's four springs (three, with a Perfect it no
longer has), Overcharge's full stacks (half). **And the corner the brief named**: IP's ladder table said the mini-boss carries Ruin's
fixed modifier, which the code arms and then overwrites with the bargain taken (FOUND AT IQ, ruling 5).

**The full ledger** — every DISAGREES fact, its site, the code's reading and what IQ did — is `docs/reports/IQ-master-census.tsv`,
one row a fact (5,157 rows).

### §2c — THE FIGURES WITH A DOOR, HELD BY AN INSTRUMENT

**`check_iq` §2 reads both sides every battery**, a card's figures off the card itself (`Classes.ability_corpus`, the one
enumeration):
- **the draft catalogue's price column** — every row whose first cell names a card: its cost (Mercy against the card's Mercy price),
  initiative, cooldown and Break damage where stated — **124 rows, 378 figures**; one cell is prose by design, Boil Over's
  (*the whole Rage bar*), named;
- **the statlines in the class sections** — *Name — 25 Rage, 26 dmg / 18 BD / 3.0, 2cd*, anchored on a card's own name, read on the
  unwrapped text — **78 statlines, 256 figures**;
- **the bargain deck**, both directions — every row's name and severity against `Run.MODIFIERS`, and *the pool is 23*;
- **the rewards** — each severity's gold against `Run.REWARDS`;
- **the ladder** — each rung's multiplier, and Warden's and Ruin's bands, against `Run.DIFFICULTIES`.
**695 figures in all, every one agreeing after the repairs** (they all agreed before them too: the census's disagreements were
in the prose, not in the cells). **A figure a handler holds as a literal has no door** — about 80 in the catalogue's *what it does*
column alone (window lengths, Perfect figures, rates) — and converting those needs a named constant first: IQ's ruling 7.

**What the census found beside the document, and did not touch** (FOUND AT IQ): the code comments that repeat a claim it found false,
the Formless chip's *no recoil follows*, the choose-three miss rolled twice, Tithe's 1-health heal on a Broken enemy, the block sound
that is loaded and never played, seven statuses the glossary has no entry for, two card texts that say *everyone* where the rule says
hero or ally, and `CLAUDE.md`'s own *clearing rung 1 is the only door* and *25 read sites*.

## §3 — THE RE-MEASURE, PRICED AND NOT BUILT

**The subject is both files**, because §1 read `docs/state.md` as mostly binding (130 of 141 blocks). **The method is HV §3b's,
unchanged, over the twenty batches since HV (HW to IP)**: for each batch, every block of each file its brief or its report
QUOTED (four or more words verbatim, checked against the file *as that batch loaded it*), CITED (named or identifiably
paraphrased), or plainly DEPENDED on (a concrete reason required), plus every block its own commit AMENDED (by script, off the
diff). The always-read blocks are counted for every batch. **Five read-only readers took the twenty** (four each), against the
two files cut into today's blocks (`CLAUDE.md` 121, `docs/state.md` HEAD's 141); the readers' reports, the block indexes, each
batch's brief, report, diffs and loaded files, and the pricing script are kept in the scratchpad, and the per-batch needs are
in `docs/reports/IQ-remeasure.tsv`.

**The shape priced is HV §3f's recommended one, on today's files**: a CORE read whole — the always-read blocks, every block
carrying a settled-question guard (HV's broad reading, 25 of today's blocks), and every block seven or more of every nine
batches needed — an INDEX row of 250 B for every other block, and each batch opening the blocks it needs. **The coarser shape,
subjects on demand, is not re-priced**: HV §3f measured that a batch needs a thin share of nearly every large subject, so a
subject index reads 355–380 KiB of 433; a block is the only unit that saves anything, and a section of `docs/state.md` IS a
block.

**MEASURED, NOT ESTIMATED:**

| | the file | core | index | a batch reads (mean of the 20) | least / most | saving | union of the 20 | needed by none |
|---|---|---|---|---|---|---|---|---|
| `CLAUDE.md` (HEAD, 483,594 B) | 121 blocks | 31 blocks, 188,515 B | 90 rows, 22,500 B | **242.7–248.3 KiB** | 218.6 / 270.9 KiB | **47.4–48.6%** | 84 blocks, 81.6% | 37 blocks, 18.4% |
| `docs/state.md` (HEAD, 370,043 B) | 141 blocks | 12 blocks, 29,782 B | 129 rows, 32,250 B | **85.0 KiB** | 68.0 / 139.1 KiB | **76.5%** | 100 blocks, 64.6% | 41 blocks, 35.4% |
| `docs/state.md` at IQ (284,849 B) | 132 blocks | 12 blocks, 29,213 B | 120 rows, 30,000 B | **80.1–80.2 KiB** | 65.2 / 130.4 KiB | **71.2%** | — | — |

*(The range in each cell is the lower reading — quoted, cited and amended — against the upper, which adds what each batch
depended on. **The third row prices the same twenty batches' needs on IQ's own file**: HEAD's blocks mapped onto it by heading, the
ten IQ moved out opened from the archive at their archived size when a batch needed one.)*

**HV's figure holds, and it has grown.** HV priced this shape at about 38% off `CLAUDE.md`'s read (266 KiB a batch of 433). Today
it is **about 48% (245 KiB of 472)**: the file grew 50 KiB since HV and the core did not — 184 KiB against HV's 190.7, because
what grew is rules a batch reads once, not rules every batch reads. **`docs/state.md` saves more, because a batch needs less of
it**: a mean of 14.4% of the file, against 27.0–28.6% of `CLAUDE.md`. **Both files together** — 833 KiB at IP's close — would be
read at about 333 KiB a batch.

**WHAT THE FIGURE CANNOT SEE, SAID WITH IT.** A census of what a batch quoted, cited or depended on is a FLOOR on what it needed: a
rule it obeyed without naming is invisible to it (*NEVER-QUOTED IS NOT DEAD*), and the failure HV named — a batch on a wrong premise
because the block that would have stopped it was not opened — is not measurable before it happens. **Over twenty batches the
union of what they needed is 81.6% of `CLAUDE.md`**: almost every block is somebody's, once. The saving is per batch; the index has
to route every batch to its own few.

**WHAT BUILDING IT COSTS, COUNTED.** `CLAUDE.md` is read by **46** battery targets, **144** of the pin manifest's needles in **42**
of them; `docs/instrument-rules.md` by 16 (49 pins) and `docs/combat-rules.md` by 3 (8). `docs/state.md` is read by **4** (`check_fg`,
`check_hp`, `check_es`, `check_hx`; 7 pins). Every block that leaves the required read takes its pins with it, each re-pointed in the
same batch (CW's discipline), and `check_hx` §1's four seam checks grow a fifth file and a block-level index each. **Writing the
rows is by hand** — 90 for `CLAUDE.md`, each with the triggers that route a batch to it (HV §3f's 250 B a row), and the core's
membership read by hand.

**THE DECISION IS THE DESIGNER's** (IQ's ruling 2). The measurement says the index beats one file with a moving ceiling on the
read, for both files, and by more than HV found; it does not say a batch will open the right blocks, which only a pilot can.

## §4 — THE UNGUARDED SAVE READ, AND ITS FAMILY

### §4a — THE CRASH, DRIVEN BOTH WAYS

**The read.** `offer_screen._draw_option_parts` takes each option of `Run.encounter_offer()` and reads `Run.MODIFIERS[mod_id]`;
the offer is rolled once for its encounter and saved with it (GF), so a save frozen on the offer screen carries the three ids it
was dealt. **Driven on HEAD's code** (a probe and `check_iq` §4 in a HEAD lane), a save naming `hungering_dark` among three loads
untouched and the screen throws *Invalid access to property or key 'hungering_dark'* and draws two cards; **a save naming three
removed ids draws no card at all** — and the offer screen has no decline, so the run stands on a screen with nothing to press.

**The guard (the ruling, built as written).** `Run._drop_stale_offer_options`, called once, in `load_run`, right where the
encounter comes off the save:
- **an option naming an id the deck does not hold is DROPPED** and the offer is dealt one fewer (the next save writes it back);
- **an offer left with none is dropped whole**, so `encounter_offer` deals a fresh one when the screen opens — the degenerate
  re-ask, and the only one;
- **no die is spent and nothing is re-rolled otherwise** — the same seed reads the same next number on either side of the load;
- **the bargain already TAKEN needs nothing** — `_active_modifier` asks the deck (IP's `check_ip` §1a, unchanged).
**The draw site reads the deck straight on purpose**, with a comment saying so: every id that reaches it from a save has passed
the load door, and an id the CODE chose that the deck lacks is a defect that must fail there. On the new code: one stale → two
cards, the two the save kept, in their order; three stale → a fresh offer of three; none → the offer as saved.

### §4b — THE FAMILY: EVERY READ OF SAVE DATA THROUGH A DATA TABLE

**Two read-only readers took the census** (the rubric and both reports kept: the census files below), one the run save's
run-level fields with the relic ledger and the settings, one a party member's keys with the profile. **167 read sites in the
shipped game; 133 guarded, 34 not** — 22 that would crash on a save naming something gone, 9 that would show, count or pay
something false, 3 harmless:

| half | sites | guarded | crash | wrong | harmless |
|---|---|---|---|---|---|
| the run save's run-level fields, `relics.json`, `settings.cfg`, the readout | 72 | 61 | 10 | 1 | 0 |
| a member's keys, `profile.json` | 95 | 72 | 12 | 8 | 3 |
| **all** | **167** | **133** | **22** | **9** | **3** |

**Repaired: every one that would crash, and the one that strands the run**, each at the load door, each driven in `check_iq`
§4b through the real save and the real load, and each red on HEAD's code:

| the reads | what a stale key did (driven on HEAD) | the guard in `load_run` |
|---|---|---|
| the offer (1 site) | §4a | the option dropped; an empty offer dropped whole |
| the map's swap offer, `ITEM_INFO[id]` (5 sites) | the map's arrival throws on the toast or the overlay, every arrival | an item id the table lacks is dropped from the swap queue — **and from the pouch's own keys**, where it held a slot nothing draws and nothing empties (a WRONG the same filter closes) |
| `ZONE_DEFS[zone_draw[…]]` (4 sites: the map's header first, then the roster, the descent and the next zone's name) | the map header throws on Continue (`boss_kind` read `''`) | an unknown zone takes its slot's first candidate, as an empty draw already did, and the zone's name follows |
| `Events.config(pending_event)` (1 site, WRONG) | an event screen with no choice and no way out, every Continue | the id cleared: the node stays spent |
| `Classes.SPEC_INFO[spec]` (8 sites: the map card, the spawn, the sheet, the offer screen…) | `'iq_gone_spec'` kept; every reader would throw | the lineage read again off the hero's engines, as `awaken` read it, or none |
| `CLASS_PASSIVES` / `CLASS_BLURBS[key]` (3 sites; and two WRONG defaults that play an unknown class as a Cleric) | the save loaded | **refused and cleared, the floor's path** — a hero cannot be dropped and a class cannot be invented (ruling 3) |
| a saved rune's `add` (1 site, `Talents.apply_payload`) | `Nil + int` at the spawn and the hero's live config | a field a card does not have is dropped from the saved payload; the rest pays |

**What stays unguarded, and why none crashes** (each in the census file with its line):
- **Reachable, and WRONG: a card a save names by a name that has since changed** — four reads (`map_screen._offer_card`'s
  queued offer, the slot count, `apply_upgrades`, `upgrade_choice`). CK renamed the Warrior's Iron Will to Ironclad and GN
  Magic Barrier to Nexus Ward, both after BM's save floor, so a save from before either can carry the old name: it takes a slot,
  shows as a blank takeable button in a queued offer, or carries an upgrade that never lands. **Nothing crashes: every
  `pool_ability` read is null-checked.** A rename map at the load door is the narrowest repair; it is FOUND AT IQ, not built
  (the brief: repair the crashers, list the rest).
- **Latent and WRONG**: a stat payload naming a unit field since renamed pays nothing (`set()` drops it silently); a payload
  naming a card since renamed adds nothing.
- **Harmless**: a class with no bonus arm, an `Ability.make` key it ignores, an upgrade id with no stamp.
- **Already guarded, and the census says how**: the relic ledger is filtered at its load (`relics.gd`), the twelve retired trees'
  cells are dropped by `_migrate_trees` and by the profile's fold, the difficulty passes `difficulty_id`, every rune read asks the
  data, every enemy kind falls back to the Raider. **The retired rest node predates the v10 floor**, so no save this build reads
  can name one; a node type the map does not know draws as a fight (`match` defaults).

**THE DESIGNER's SAVE, READ (a byte-identical copy in a lane, never the live file)**: v15, zone two's start (`zone_idx` 1, slot
−1), and **no stale key anywhere** — 31 card names, every item, zone, relic, rune, class and lineage resolve. Nothing the guards
do would touch it.

### §4c — THE TWO ARMS (the brief's)

- **Reds on an UNGUARDED read**: the final `check_iq` run against HEAD's `scripts/` (control H01) reads **83 / 17** — every arm of §4 and §4b, each FAIL
  naming the key the load kept (and the screen's own *Invalid access* errors on the stale cards).
- **Reds if the guard SWALLOWS a key the code chose**: the session's own offer, holding an id the deck lacks, reaches the screen
  unfiltered (`check_iq` §4); every filter is called once and from `load_run` alone, and `encounter_offer` asks nothing of the deck
  (§4, §4b). The controls (§9) move the filter into `encounter_offer` — where a session's own roll would meet it — and soften the
  screen's read to `.get`, and each reds the arm it aims at.


## §5 — HOUSEKEEPING

**THE MOVE IS NOT ATTEMPTED** (IB §4). **At IQ's close 602 folders, 261,904 KiB** (IP's close: 602, 262,952). **IQ made no
folder — the tenth batch running.** It reused three of IB's (*IB work*, HEAD's code; *IB ctlA*, IQ's; *IB recon*, the recons) and
three more of IB's — *IB ctlB* (one clone a control), *IB tracenew* (the `ok()` trace) and *IB prepass* (the pre-pass); they stay, named here (HO §5). **The spent prefixes** — every *Dawn of Decay* copy from FX to IN and the five *DoD …*
copies — are **600 folders, 261,348 KiB**. **ONE command clears them**, leaving the live *Dawn of Decay* folder and
`[unnamed project]` — IP's command, unchanged, because IQ made no folder its patterns miss:

```
mkdir -p "$HOME/.Trash/DoD spent user-data folders (FX to IN)" && cd "$HOME/Library/Application Support/Godot/app_userdata" && mv "Dawn of Decay "[F-H]?" "* "Dawn of Decay I"[A-J]" "* "DoD "* "$HOME/.Trash/DoD spent user-data folders (FX to IN)/"
```

Each pattern was listed at the close before it was written here — 470, 125 and 5 folders — and none reaches the live folder. **IB's
caution, kept**: zsh aborts the whole command on a pattern that matches nothing, so a prefix already cleared is dropped from the paste
first. **And clearing them ends the reuse**: the next batch makes its lanes again.

**THE DESIGNER's FILES.** Backed up first, before anything ran, with the player's four files (`../save-backups/IQ-20261019-143844`,
14:38), read only through copies, and **never touched**: `run_save.bin` `fcb20c91…` and the clean readout `610bcd8c…` at the open
and `fcb20c91…` and `610bcd8c…` at the close, the other three files byte-identical too. **The file has not grown.** Every Godot process IQ started ran
in a lane under its own name, through `lane.sh` (§7).

## §6 — WHAT IS DELIBERATELY NOT DONE

- **Nothing from the playthrough, and nothing of the deck's middle** — §0.5's target is recorded, not pursued.
- **The re-measure is priced, not built** (§3; IQ's ruling 2).
- **The claims are the last batch and stand at 86** — and IQ found one more: `CLAUDE.md`'s starter-rung block says clearing rung 1 is
  the only door to tier 1 (FOUND AT IQ). **It is not added to the 86**; it is IR's to count.
- **No grade, count or band moved**; the two ties keep the sort's order. **The Thin Veil keeps Feverish's rule**, in Feverish's grade.
- **The reachable WRONG reads are listed, not guarded** — a card a save names by its pre-rename name (IQ's ruling 4) — because none
  crashes, which is the brief's line.
- **`master.html`'s history clauses are not stripped** (IQ's ruling 6), and its handler literals are not given doors (ruling 7).
- **The code the census found wrong is not changed**: the Ruin mini-boss's fixed modifier, the Formless chip, the choose-three miss,
  the stale comments, the silent block sound and the glossary's seven missing statuses are FOUND AT IQ (ruling 5).
- Standing and unchanged: no crest rune re-cut or authored, the crest cap at one; the vow, the recoil floor and Anointing untouched;
  the third slot ungated; the art is not commissioned; a copied Frostbind's refusal RULED, NOT BUILT; Mana stays; a meter is not a
  conjunction half; Marrowfire's re-cut and `CONJUNCTIONS` holding Rupture alone; Contagion's and Reckoning's re-cuts; the Occultist's
  Break card; the Skirmisher and the Tracker; Channel's tempo payout; the fallen-hero ruling and its seven things; Tithe's read site.

## §7 — THE LANE DRIVER, AND WHAT IT REFUSES

**IP's slip, as a check rather than a habit.** `lane.sh`, at the repository's root (IQ's only new root file):
- `lane.sh check <lane>` reads the copy's `config/name` and the live name — `config/name` in HEAD's committed `project.godot`,
  read with `git show`, never typed — and **refuses, exit 1 and one line saying why**: a copy named as the live project, a copy that
  names no project, and the repository itself (which runs as the live project on purpose, through `./run_battery.sh`).
- `lane.sh make <lane> <name> [<src>]` clones a copy with `.git` (APFS, `cp -c -R`, `save-backups/` left out), renames it, and
  checks it; it notes when the name's user folder does not exist yet (reuse an idle one first).
- `lane.sh godot <lane> …` and `lane.sh battery <lane> …` launch nothing until the check passes.

**What it cost**: 118 lines of shell, one call a launch, **about 20 ms** (measured: `git show` and two `sed` reads). **What it now
refuses** — driven every battery by `check_iq` §7 on made-up copies, and by hand on IP's shape: a copy whose `project.godot` was put
back to the live name (the IP slip's end state) — *LANE REFUSED: … runs as 'Dawn of Decay', the LIVE project*; the same copy's
`godot` launch; the repository as a lane; a copy with no name. A copy named as its own project runs. **Every Godot process IQ
started in a lane — probes, traces, controls, recons, the pre-pass — started through it**, and none ran in the player's folder.

## FOUND AT IQ AND NOT FIXED

- **THE RUIN MINI-BOSS NEVER FIGHTS ITS FIXED MODIFIER.** In play `map_screen` arms one (`Run.arm_fixed_modifier`, the severity 3–4
  band) before the bargain, and `Run.accept_offer` overwrites `pending_modifier` with the bargain taken; the sim takes the bargain
  first and the arm's *never stack two* guard skips it. Either way a Ruin mini-boss fights the bargain alone, where `CLAUDE.md`'s
  ladder block names it among the fixed encounters that carry a modifier with no reward. `master.html` now says what the code does;
  which is meant is IQ's ruling 5.
- **A CARD A SAVE NAMES BY ITS PRE-RENAME NAME** (Iron Will, Magic Barrier): four reads take it straight — `map_screen._offer_card`'s
  queued offer, the slot count, `Run.apply_upgrades` and `Run.upgrade_choice` — and none crashes. IQ's ruling 4.
- **LATENT, AND WRONG, NOT A CRASH**: a saved stat payload naming a unit field since renamed pays nothing (`set()` drops it), and a
  payload naming a card since renamed adds nothing (IQ §4b's census).
- **`CLAUDE.md`'s STARTER-RUNG BLOCK SAYS CLEARING RUNG 1 IS THE ONLY THING THAT OPENS TIER 1** — beating the end boss on any rung opens
  it (`Profile.note_end_boss` sets the tier to the rung beaten, and `Talents.tier_open` opens every tier at or below it), and the
  draft deals all three rungs with no gate. `master.html`'s copy is repaired; the rule file's is a claim for IR, and `talents.gd`'s
  comment at its head repeats it.
- **THE FORMLESS CHIP SAYS NO RECOIL FOLLOWS, AND ONE DOES** — `battle.gd`'s `formless` status text against the recoil its expiry
  applies: a player-facing sentence the census found beside `master.html`, not repaired here.
- **A CHOOSE-THREE CARD ROLLS ITS MISS TWICE.** `_resolve`'s single-target miss guard excludes `choose_two` and not `choose_three`, so
  Cleave and Hex of Ruin roll a whole-cast miss on their first target and then a miss per strike (`master.html`'s miss line now says
  what a player meets: chosen-target attacks roll per strike).
- **CODE COMMENTS REPEATING WHAT THE CENSUS FOUND FALSE** — an asserted surface (DF §1), each repaired with its subject: `talents.gd`'s
  head (*rung 1 is the only door*), `run_state.gd`'s *an event pays no gold* and *`pending_event` is not saved*, *35% → 52%* (Honed
  makes 53%), Mark of the Hunt named as an engine-gated boss card, `battle.gd`'s *59* recast-gated abilities (63 refuse), Blood
  Offering's *40* Rage (60), Berserk's *4 on a perfect* and *spends all three* (four charges, always), and *converts depth into width*
  in two places.
- **`master.html` HOLDS 185 UNITS WITH A HISTORY OR RATIONALE CLAUSE, AND NAMES A BATCH 117 TIMES** (the stamp aside) — IQ's
  ruling 6. **And its zone-boss heading still reads *a zone-boss award always pays*** inside the history it narrates, while its own
  paragraph says the chain can empty; the sentence that stated the claim as a fact is repaired.
- **FORTIFIED SPIRIT AND UNDYING VIGIL TAKE A COMPANION AND DO NOTHING ON ONE.** Both pick from `_hero_side()`, companions included,
  where Covering Guard and Rally narrow the same pool: Fortified Spirit's loan decays at its bearer's turn start, which a companion never
  takes, so a loan on one never decays; the Vigil's fork is wired on the four heroes only. IQ's ruling 5.
- **TWO CARDS SAY *EVERYONE*** — Aegis Wall and Hunter's Mark, beside the *hero* or *ally* each also states — against `CLAUDE.md`'s
  *there is no third word*. IQ's ruling 5.
- **TITHE HEALS 1 FOR AN ATTACK THAT LANDS NO BREAK** — into a Broken enemy (or under Bulwark, Immovable or Ironclad's cap) the heal falls
  to its 1-health floor, where its words say an attack that lands Break. IQ's ruling 5.
- **THE BLOCK SOUND IS LOADED AND NEVER PLAYED** (`bow_blocked`; a block plays the parry's), and a comment still promises it. IQ's ruling 5.
- **SEVEN STATUSES THE BATTLE APPLIES HAVE NO GLOSSARY ENTRY** — Slow Burn, Heads Down, Unmaking, Breaking Darkness, Penance, Suffering
  and Blighted — where `master.html`'s glossary section said every debuff had one. IQ's ruling 5.
- **`CLAUDE.md`'s RELIC BLOCK COUNTS 25 READ SITES** of `relic_add` and `relic_dict`; the game holds 22, 26 with the sim's. A claim for IR,
  beside the starter-rung one.
- **`check_hn` §2a's WORN ARM READS THE BAG's RUNE** (IQ's position census, read and not driven): `got_worn` keeps the last *Fourth
  Stack* on the Cleric's list, and since HR §1's hand-out the bag's copy lands there after the worn one, so the worn rune's rename is
  asserted by no arm — an instrument defect older than IQ.
- **`check_ho` §8 READS A FIXED 2,400 CHARACTERS AFTER ITS HEADING, PAST ITS 2,288-CHARACTER BLOCK**: its tail now reads IQ's new block's
  heading where it read HO §1's. Every needle it holds sits inside the block, so the verdict holds — the *fixed window runs past its arm*
  shape, waiting for a needle that does not.

## THE TWO READINGS

**`CLAUDE.md` is 485,156 B = 473.79 KiB against its 510 KiB ceiling — 36.21 KiB under** (+1,562 B at IQ: the save's guard in the FD §1
block, the index's two rows and its sentence, and the GH block's pointer re-pointed to GI §4): 4.5 batches at EZ's record (8,293 B), **19.6 at the mean of IM–IQ**
(1,890 B: IM +1,476, IN +1,654, IO +2,851, IP +1,908, IQ +1,562).
**`docs/state.md` is 284,849 B = 278.17 KiB against its 380 KiB ceiling — 101.83 KiB under** (−85,194 B at IQ: the census's cut
−90,618, IQ's own writing +5,424): 17.8 batches at IA's +5,860 B, the worst case; **50.3 at the honest rate**, IQ's own writing beside
IM–IP's (2,071 B). **§1's recovery, beside them**: 90,618 B out of the read — 85,225 to the archive, 5,393 struck — and the honest
rate's room from 9.1 batches to 50.3. **Which runs out first**: `CLAUDE.md`, at every rate, now — the reverse of IP's close.

## §9 — THE VERIFICATION

**WHAT WENT IN BEFORE WHICH RUN (the brief: this batch IS documentation).** In order: the code (§4's guards, `offer_screen.gd`'s
comment) and `lane.sh`, then **recon 1** (HEAD's battery on IQ's code alone); then every document — `docs/state.md`'s cut and its
rewrite, the archive's cut, `master.html`'s 179 edits and its stamp, the changelog, the design notes, `CLAUDE.md` and the instrument
rules — built in a scratch root, swept, and landed behind a hash guard; then `check_iq` joined the battery, `check_ip` §0.2 was
re-pointed, the baselines rows were written and the manifest regenerated; **then recon 2** (IQ's own battery on that tree); **then the
acceptance**. **After recon 2, four edits, each proved**: `check_iq`'s FAIL lines (§2 names the figures it found;
§4b's payload arm names the rune it read; whole figures print without a decimal) — no check added or removed, every control on them
re-run; FOUND AT IQ's two instrument findings and the WHERE block's re-taken figures in `docs/state.md`; the changelog's instrument line.
**Proved by the manifest against the copies recon 2 read: not one needle flips** (8 on `docs/state.md`, 51 on the changelog), and the
gate-source readers and `check_fg` read the final tree before the acceptance (below).

**THE SUPERLATIVE CENSUS RAN FIRST**, over every target that opens a document IQ moves or drives the load door, IO's census the
checklist and not the population (IO §0.10): a read-only reader over 84 files — the 61 targets that open
the five documents, 15 that load or save a run, the gate-source walkers and the fixtures. **100 picks whose population IQ moves: 84
sites, 16 weak; every FAIL line names its pick at 40, some do at 43, none at 17.** **IQ changes the picked member at four, every
verdict holding**: `check_io` §7 and `check_ip` §7 (the archive's first cut, IP's → IQ's) and `check_iq` §1's two, by design. **Outside
the brief's files, 17 more over the design notes and the changelog, and two change member**: `check_fg` §1 (the newest changelog entry,
by design) and **`check_ip` §0.2 — the newest design-notes entry, IQ's now — whose verdict flipped: HEAD's arm red on IQ's tree in the
pre-run, re-pointed to IP's entry by its title, green in recon 2.** **The load door moves no other gate's pick**: every key another gate
saves — party keys, lineages, items, zones, events, offers, a rune's `add` — is in its table, and no filter spends a die. **Positional
reads**: `check_ho` §8's fixed 2,400 characters run past its 2,288-character block into IQ's new heading, its needles all inside (FOUND
AT IQ); `check_iq` §2b reads 160 characters after a card's name, so a statline set further out is skipped and only its floor of 78 would
notice; and a latent defect older than IQ, `check_hn` §2a's worn arm reading the bag's rune (FOUND AT IQ).

**THE LITERAL SWEEPS, BEFORE EACH PREDICTION.** *Code* (recon 1): 0 lost; 14 gained, all words of new comments, none held against
those two files; two short flips in `offer_screen.gd` (*dl*, *Q*), neither held against it; the moved counts bracket balances.
*Documents* (recon 2): loud, as the brief said — 167 lost, 257 gained, 19 short flips, 49 counts moved — **and quiet where it binds**:
not one of the manifest's needles held against a moved document flips (122 on `master.html`, 125 on `CLAUDE.md`, 51 on the
changelog, 38 on the instrument rules, 7 on `docs/state.md`, 7 on the design notes), and every moved count is a bracket balance or an
array count on game data, none taken of a document.

**RECON 1 — HEAD's battery, IQ's code alone**, in a lane: predicted *every target at its row, `check_de` 641 / 0 / 0* — **read 156
targets, `check_de` 641 / 0 / 0, no `Parse Error`**, the two standing sanctioned reds as IP read them (`check_cm_live` 13 / 5,
`check_gj` 70 / 1).

**THE PRE-RUN — seventeen gates that read gates or rule files**, on IQ's tree before the recon: every one green but three, each
traced: `check_hx` §1d (`check_iq` unresolved — the corpus reads `run_battery.sh`, whose list lacked it), `check_ip` §0.2 (a position
pick: *the newest* design-notes entry, IQ's now — re-pointed to IP's entry by its title, and its FAIL line says whether it found it)
and `check_ed` (the manifest — regenerated, 1,879 → 1,897, every new needle resolved, the residency unchanged). `check_gw`: 96 sites in
10 targets, ceiling 96, not risen.

**RECON 2 — IQ's own battery on IQ's tree**, in a lane: predicted *every target at its row, `check_de` 645 / 0 / 0, the
two standing sanctioned reds as IP read them* — **read 157 targets (the logs 20:38:26 to 22:02:51), `check_de` 645 / 0 / 0, no `Parse
Error`**: `check_iq` 83 / 0, `check_ip` 48 / 0 (its §0.2 re-pointed, green), `check_parse` 233 / 0, `check_ed` 18 / 0, `check_hx` 39 / 0,
`check_gw` 76 / 0 (96 sites in 10 targets, ceiling 96), `check_ij` 49 / 0 (*28 gate-source readers*), `check_cm_live` 13 / 5 in its band and
`check_gj` 70 / 1 with *the card says +175 gold and the purse moved 195*, the run harness PASS 22 / 382 / 8. **No row moved that the
prediction did not name**, so nothing was traced before the freeze but the three the pre-run found.

**THE CONTROLS — one clone of the final tree each, its anchor asserted once before the edit, read by its FAIL text:**

| | the break | the arm | read |
|---|---|---|---|
| C01 | the load door's offer filter removed | §4: reds on an UNGUARDED read | 8 red — *the load kept ["deadened", "hungering_dark", "thinair"], not the two the deck holds* |
| C02 | the filter moved into `encounter_offer`, where the session's own roll meets it | §4: reds if the guard SWALLOWS a key the code chose | 2 red — *an offer this session holds was filtered before the screen* |
| C03 | the screen's read softened to `.get(mod_id, {})` | §4: a code defect must still fail loudly | 1 red — *the offer screen no longer reads the deck straight* |
| C04 | the other keys' filter removed | §4b items, zone, event | 5 red — the pouch, the swap queue, the zone, the map's boss, the event |
| C05 | the payload filter removed | §4b payload | 2 red — *add { "iq_gone_field": 3, … }* |
| C06 | the class refusal removed | §4b class | 1 red — *a save holding a class this build does not have was loaded* |
| C07 | Gut Rip's catalogue cost 30 → 31 | §2a | 1 red — *Gut Rip's cost reads 31, the card's is 30* |
| C08 | Bloodlust's statline BD 18 → 19 | §2b | 1 red — *Bloodlust's Break damage reads 19, the card's is 18* |
| C09 | Hoarfrost's row at severity 2 | §2c | 1 red — *'Hoarfrost' is listed at severity 2, the deck's is 1* |
| C10 | severity 3's gold 140 → 145 | §2d | 1 red — *the reward table does not pay severity 3 140 gold* |
| C11 | Ruin ×1.30 → ×1.35 | §2e | 1 red — *the ladder does not read '3 — Ruin ×1.30'* |
| C12 | `lane.sh` stops refusing the live name | §7 | 2 red — *a copy named 'Dawn of Decay' was not refused*, and its `godot` door |
| C13 | the tie rule's qualification reworded away | §0.2 | 1 red |
| C14 | a moved heading put back in the live file | §1 | 1 red — *the live file still holds '### THE FLAKES'* |
| **R01** | **re-tune**: severity 3's gold moved in `Run.REWARDS` and the table together | §2d | **83 / 0, green** |
| **H01** | **HEAD's code** under the final gate | §4, §4b | **17 red**, every arm naming the key the load kept |
| **H02** | **HEAD's documents** under the final gate | §0, §1 | **20 red** — §0's seven and §1's thirteen — **and §2 green**: HEAD's figures already agreed, so the conversion holds on both sides of the repair |

*(The §2 controls first read their red off a printed line above a FAIL line that gave only a count; the FAIL line now names the
first three figures it found, and C07–C11 were run again on it — a control is read by what its FAIL line says.)*

**THE OK() TRACES** (moved counts attributed, stubs for the dice): **`check_parse` 232 → 233** — `check_iq` in GATES, §A's count of the runner's targets (233 / 0 in the
pre-run and recon 2); **`check_de` 641 → 645** — one more row, its four checks; **`check_iq` new at 83** — traced in a scratch copy whose `ok()` prints each
assertion's label: §0 5, §1 15, §2 8, §4 29, §4b 15, §7 8, §9 3 (the rule pins for §4's and §7's blocks carry those labels); **`check_ip` 48 → 48 with one arm re-pointed**, HEAD's arm red on IQ's tree and the new one
green. **No other row moved**, and IQ's code spends no die (§4 asserts the load's), so no stub was needed.

**THE GATE-SOURCE READERS READ `check_iq`'s FINAL SOURCE BEFORE THE ACCEPTANCE**: **twenty-eight by `check_ij` §0.4's derivation** (27 open the root, 3
read the battery's list) — `check_iq` among them only because its §7 hands the root's path to the driver; it reads no gate's source. A
third route was not looked for again: IQ's census of the gate-source walkers (§9's first paragraph) found none, and `check_iq` adds
none. **Read after the last edit to `check_iq`** (md5 `e3b84ad2…`), in a copy of the final tree, with `check_fg`: **all 29 at their
rows, no parse or script error** — `check_iq` 83 / 0, `check_parse` 233 / 0, `check_ij` 49 / 0, `check_ed` 18 / 0 (the manifest
regenerated twice, byte-identical), `check_gw` 76 / 0, `check_hx` 39, `check_ea` 396, `check_da` 41, `check_ek` 47, `check_es` 57,
`check_hp` 171, `check_ik` 251, `check_io` 119, `check_in` 91, `check_ip` 48, `check_fg` 30, `test_batch_cd` 92.

**THE ACCEPTANCE**, on the frozen tree, in the repo, every row of `ps` logged every 15 s, the pre-pass beside it in a fresh lane:
**157 targets each — the acceptance 22:11:04 to 23:37:19, 86 min
15 s; the pre-pass (*IB prepass*) 22:11:04 to 23:37:25, 86 min 21 s** (IP: 156 in 87 min 21 s). **Both read `check_de` 645 / 0 / 0, as
predicted**, every target at its row — `check_iq` 83, `check_ip` 48, `check_parse` 233, `check_ed` 18, `check_hx` 39, `check_gw` 76 (*96
sites in 10 targets (ceiling 96)*), `check_ij` 49 — **the two standing sanctioned reds as IP read them** (`check_cm_live` 13 / 5 in its
band; `check_gj` 70 / 1, *the card says +175 gold and the purse moved 195*), the banded suites inside their bands (`test_batch_an` 6,054
and 6,048, `test_batch_bk` 129 and 130), the run harness PASS 22 / 382 / 8 in both, **and no `Parse Error` or `SCRIPT ERROR` in any log
of either.** **The rows of `ps`, read**: 348 snapshots, 22:11:04 to 23:38:07 — two Godot processes in 324, one in 21 (a battery between
targets), none in 3 (the end); two `run_battery.sh` in 344; no third Godot and nothing else at any snapshot, and none after 23:37:22.

**THE CLOSE, AND A SLIP OF MY OWN THAT IT CAUGHT.** The launcher's last `wait` also waited for its own `ps` logger, which stops only
when the step after that `wait` tells it to, so the closing checks never ran on the night: the batteries finished at 23:37 and the
script sat on the logger. **Found and released three days later; the closing checks then ran: the player's four files and the readout
md5-identical to the backup, and the tree's 563 files identical to the frozen hashes but one — `docs/.DS_Store`, Finder's folder
metadata, untracked and read by no gate**, which the Finder rewrote in the interval. **After the acceptance, one edit, proved**: the
state file's *80 KiB of 277* read *278* — the file closed at 278.17 KiB — the same three bytes in two places, the file's size unmoved
and not one of its eight needles flipping. The launcher is a scratch tool and is not in the tree.
