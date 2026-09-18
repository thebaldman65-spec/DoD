# Batch GR — The subject seam

*Branch `class-merge`, from `07f03e1` (GQ). `main` is untouched. **IMPLEMENT ONLY.** `CLAUDE.md` had crossed its
340 KiB ceiling at GP; the designer ruled the subject seam, and this batch measured it, took it, and proved it. Nine
rules about how a fight resolves moved byte for byte to a new reference, `docs/combat-rules.md`. No code, card, engine,
rune, node or magnitude moved; no rule was rewritten; nothing was pruned.*

## NEEDS A RULING

**Neither is player-visible.** The rest is in `docs/state.md`'s queue.

1. **`docs/combat-rules.md` HAS NO STATED CEILING**, like `docs/instrument-rules.md`. EE's method on its own record —
   the file as split (29.73 KiB) plus ten of the largest single-batch growth its nine blocks have ever had (+4,340 B,
   the crit rule's birth at EW) — gives 72.11 KiB, stated **70 KiB**. It has grown +19.5 B a batch since FF, so this is
   not a wall anyone is near; adopting it or not is the designer's (§5c).
2. **THE NEXT CEILING, AND THE TWO MOVES LEFT FOR IT.** `CLAUDE.md` is 318.54 KiB, 21.46 KiB under 340:
   about 5.1 batches at FF's +4,315 B a batch, about 9.8 at the +2,247 B a batch its main half has
   grown since FF. **There is no fourth seam that batches read rarely** (§5d). Rune law would come away cleanly —
   14 of its 15 blocks, 34.25 KiB — but the merge's rune step reads it every batch. The other move is a second
   re-derivation of the ceiling, which `CLAUDE.md` itself says moves with the file. Better ruled with headroom than at
   the wall.

## THE SHORT VERSION

- **The seam was measured again, not quoted.** Every one of `CLAUDE.md`'s 113 blocks classified by subject: combat law
  **55.97 KiB** (FF: 66.74), card law **85.89** (FF: 59.12), and **engine law has grown into a subject of its own since
  FF** — 22.84 → **41.80 KiB**: the charter, the kits, the rule engines, the spines' ledgers. FF's classification was by
  what a rule binds and is not reproducible block by block; this one is by subject, and every block's call is in §1e.
- **Combat law moved because batches read it least.** Outside the two whole-file sweeps (GB's census, GC's claims pass),
  combat law was written into by **4** of the 38 batch commits since FF; card and engine law by **7** each, rune law by
  **10**. The nine blocks that moved were written into by **2** (GF, GK). Card law is the largest subject and nearly every
  content batch writes a card — the worst candidate, not the best.
- **Half of combat law stayed**, on the brief's rule: a rule about a fight that also binds a card, a rune or an engine is
  kept where a batch working on that thing meets it. 28.48 KiB stayed; **27.49 KiB moved**.
- **The one-way tiebreak's guarantee is retired in writing where it is stated** — `CLAUDE.md`'s instrument pointer block
  and `docs/instrument-rules.md`'s header — so a later batch meeting it does not refuse the split. What survives: a rule
  belonging to two subjects stays in `CLAUDE.md`.
- **No pin had to move.** The manifest's 70 `CLAUDE.md` pins land in none of the nine; a sweep of 17,652 literals found
  none of the 82 the move takes out asserted against `CLAUDE.md`; and the whole battery, run with every gate unmodified
  against the split tree, read **477 / 0 / 0** — so no re-point was necessary, measured rather than assumed.
- **Six instruments learned the new file.** Nine two-armed controls bit each of the five gate edits while HEAD's gates
  stayed green, and the manifest's five new pins are all `check_ff` §5's.
- **The rejoin is byte-exact**, proved by a second script, never by a size; a same-length misspelling inside a moved
  block is caught by the byte-exact assertions and by nothing else.
- **Sizes:** `CLAUDE.md` 348,868 → **326,190 B = 318.54 KiB**; `docs/combat-rules.md` **30,440 B**;
  the split's own cost inside `CLAUDE.md` is 5,470 B.

## §0 — THE BRIEF'S PREMISES

Read before anything was quoted: `CLAUDE.md` whole, `docs/state.md`, `docs/reports/GQ.md`, `FF.md`, `FU.md`, `EF.md`,
`docs/instrument-rules.md`'s header and ceiling rules, and every gate that names a rule file.

| The brief says | Verdict | What the repo says |
|---|---|---|
| `CLAUDE.md` passed EE's 340 KiB ceiling at GP and reads 340.69 KiB | **Held; the number is FU's** | 348,868 B = 340.69 KiB. The 340 is FU §1's re-derivation of EE's rule (EE's own figure was 290). |
| `check_fg` fails in 7,586 more bytes — roughly two batches | Held | The deadline is 340 + 8.10 = 356,454 B. 1.8 batches at FF's mean; 0.9 at the largest on record. |
| ED read 43 uncited blocks, zero dead; FF classified 105, three quarters is game law | Held | `CLAUDE.md`'s ceiling block and FF §1a (74.0%). |
| FF stated there is no third seam of its kind | Held | FF §1f. |
| FU named the subject seam and recorded it overturns **FF's** one-way tiebreak | **Held; the tiebreak is EF's** | EF §2 set *what a rule binds, not what it is about* and the one-way valve; FF applied them. |
| GQ found 22 of 24 cards scrolling, the Beastmaster's by 877 px, and that the test is the lineage, not the enabler | Held | GQ §2d and §0. |
| FU's figures (66.74 / 59.12) are FF's and old | Held | FF §1a, on a 280.80 KiB file, thirty-six batches before GQ. Re-measured in §1. |
| a third subject may now exist | **Held — engine law** | 6 blocks / 22.84 KiB at FF, 10 / 41.80 now (§1b). |
| EF established *one required read* and *both stays*; **FF's nine** such blocks stayed | **Held; the nine are EF's** | EF §2's table: nine blocks that looked like instrument rules stayed, seven on the tiebreak. |
| EF mapped 70 pins, 66 stayed, 4 re-pointed; FF mapped 65 needles across 27 readers, zero in the payload | Held | EF §2, FF §2a. |
| EF read `test_batch_ce` at 1114/2 with the un-re-pointed suites | Held | EF §6 control C. |
| **FF's** controls proved *rewording the rule reds, rewording the index does not* | **Held in substance; those controls were EF's** | EF §6 controls A and A2. FF's own control was a pin on a moved heading, which `check_ff` §4 accused while the pin passed. |
| FG proved a size check misses a same-length misspelling | Held | FG: dropped → 10, duplicated → 11, misspelt → 3; the third moves the size by zero. |
| **FF** measured the instrument half growing twice as fast over five batches, called it composition; GQ's figures can settle it over twenty-five | **Misattributed, and already settled** | EF measured the five-batch reading and called it composition; **FF settled it over twenty-five** (EF→FE: +116 B/batch against +4,315). Re-read over FF→GQ in §5b. |
| `check_fg` reads the ceiling from the rule; **GQ** found it held a copy of the last figure | **The finding is FU's** | FU §1b: the form checks carried the old ceiling as a literal until FU repaired them. Confirmed here that the gate follows without an edit (§5a). |
| the queue stands | Held | Every item is in `docs/state.md`, untouched. |
| "and the stamp" | **Read as `docs/state.md`'s *Last rewritten* line** | `docs/master.html` is not edited — nothing a player meets changed — so its stamp stays (FU §0's ruling). |

## §1 — THE SEAM, MEASURED BEFORE IT WAS TAKEN

### 1a. The subjects, by what a rule is ABOUT

Every logical block of HEAD's `CLAUDE.md` (the census segmentation; the three headings wrapped onto a second `## ` line
joined) — **113 blocks** — was given one subject, and a SECOND subject where the block states a rule for that subject's
work too (a sentence that binds it, not a mention). A block MOVES only if it has no second subject and every member of
its `##` unit (the `##` block and its `###` children) could move with it. "Touched" is a batch commit that changed the
block's text, from the history of every commit since FF mapped onto HEAD's headings; GB's census and GC's claims pass
touched blocks file-wide and are counted separately.

| subject | blocks | KiB now | KiB at FF | touched since FF | excl. GB, GC | movable | movable KiB | movable touched (excl.) |
|---|---|---|---|---|---|---|---|---|
| **CARD** — text, words, name, tag, price, pool, draft, kit, award | 32 | **85.89** | 73.02 | 9 | **7** | 14 | 41.37 | 4 |
| **COMBAT** — the doors, a status's bookkeeping, the rolls, the collections, the enemy turn, the skill check | 18 | **55.97** | 50.62 | 6 | **4** | 9 | **27.49** | **2** |
| **ENGINE** — what an engine is, how one is held, what its meter pays | 10 | **41.80** | 22.84 | 9 | **7** | 1 | 2.00 | 0 |
| **RUNE** | 15 | 38.49 | 22.41 | 11 | **10** | 14 | 34.25 | 9 |
| CONST — the file's own constitution | 6 | 23.88 | 16.04 | 11 | 9 | — | stays | — |
| TALENT and the meta layers | 6 | 23.36 | 14.73 | 8 | 6 | 2 | 6.29 | 2 |
| RUN — offers, the save, the quit, the pouch | 7 | 19.40 | 8.84 | 6 | 5 | 4 | 10.88 | 4 |
| LADDER — rungs, the end boss, encounters | 6 | 16.99 | 13.80 | 4 | 3 | 3 | 5.95 | 1 |
| METHOD — the brief, precedents, the agreement | 3 | 16.51 | 14.87 | 5 | 3 | — | stays | — |
| CODE — the code map and code traps | 6 | 12.91 | 11.24 | 6 | 5 | 3 | 6.63 | 4 |
| MISC — reservations, naming records | 4 | 5.50 | 5.35 | 2 | 0 | 2 | 2.40 | 0 |
| **total** | **113** | **340.69** | | | | | | |

### 1b. What else grew into a subject of its own: ENGINE LAW

**Six blocks and 22.84 KiB at FF; ten and 41.80 now — the fastest-growing subject in the file (+18.96 KiB).** The
charter (GK), a status spent where it pays (GM), the class kit (GN), a rule engine reads a door (GO), a class core is a
ledger (FT), beside the meters FF already carried (Frenzy, Faith, held-versus-spent, the governor table, Loyalty, the
spread rule). It is the merge's own subject and it is written into by the merge's batches: FT, FU, FV, GK, GM, GN, GO.
**Nine of its ten blocks also bind a card, a rune or a talent** — *a node or rune that steepens the converted half*,
*two spenders with one shape would be one card with two prices*, *the nine's names never reach a text* — so almost none
of it could move on the brief's rule even if it were cold, and it is not cold. RUN law grew too (8.84 → 19.40 KiB, GF's
and GH's save rules) but is small, and three of its seven blocks are also about runes or cards.

### 1c. Which subject batches read least — three readings

- **What batches wrote into (the instrument).** A batch that amends a rule has read it. Excluding the two whole-file
  sweeps, since FF: combat 4, card 7, engine 7, rune 10, talent 6, run 5, ladder 3 — and the nine blocks that moved, 2
  (GF gave the damage door `_book_self_cost`; GK renamed engine reads). Ladder is lower but small (16.99 KiB, 5.95
  movable). **Among subjects large enough to be a seam, combat law is the least written into.** This reading cannot see a
  batch that read a rule and wrote nothing; that is its limit, and the next reading is the check on it.
- **What the reports cite (weak).** A block's heading phrase quoted in a report FG–GQ: rune rules in 10 reports, card
  3, engine 2, run 2, talent 2, combat 1. Reports rarely quote headings, so this undercounts everything — but it
  undercounts in the same direction as the first.
- **What the queue will read next.** Step 5 of the merge is the 43 engine-reading runes (rune and engine law); the kit
  texts, the Nexus Ward rename and the class-wide rebalance are card law; the Crown's resistance and the kill-credit
  edge touch combat blocks that moved (hard control on a boss, the attribution frame) and will open the reference.

### 1d. The recommendation, taken: COMBAT LAW

**Combat law moves because it is the subject batches read least, not because it is large** — card law is larger and is
the subject nearly every batch writes. **Moving card law would also have moved 25 of the 51 manifest pins that locate in
`CLAUDE.md`**; the nine combat blocks carry none.

### 1e. Every combat block, and why it moved or stayed

| block | KiB | | the second subject, and the sentence that binds it |
|---|---|---|---|
| The skill check — four cases | 2.51 | stays | its `###` children below are both also about a card or a rune, so the unit stays |
| The rule every profile is authored to | 2.25 | stays | RUNE — *the Long Draw rune … is sanctioned where the cap is* |
| Where the check comes off | 5.02 | stays | CARD — *clear `perfect_text` / `perfect_id` wherever a bonus was folded*; *the gated tell … never authored into a description*; *no healing or revival ability is ever gated* |
| The Sharpshooter's basic is a sequence | 6.83 | stays | RUNE — *the cap is four, and a rune may raise it; a batch may not*; *price a rune's cost in what the chain pays* |
| The clamped call sites | 2.25 | **moved** | — |
| Hard control lands on a boss only once it is Broken | 2.17 | **moved** | — |
| Removing a skill check makes its Perfect-only behaviour unconditional | 0.89 | stays | CARD — a Perfect that gated a binary is ruled on before the bar comes off a card |
| A recast that would not improve is refused | 5.90 | stays | CARD — *any edit to a duration, power or rider on a `RECAST_GATED` ability owes the same edit*; *no ability description says anything about a second cast* |
| Adding a name to a table is not a change | 1.61 | stays | CARD — *the bespoke condition owes the tooltip line* |
| The autoplay heuristic's refusal list | 1.34 | stays | under the recast rule; a door gap is fixed in the card's door |
| Enemy intent | 3.63 | **moved** | — |
| The recap ledgers and their bound | 2.78 | **moved** | — |
| The companion's blow reads eleven terms | 2.12 | stays | RUNE — the Shared Hide rune's divergence: *re-point this rune* |
| Crit chance above a certainty becomes crit multiplier | 5.58 | **moved** | — |
| Charges and on-hit effects count hits | 2.59 | **moved** | — |
| A status is applied with its `src` | 2.30 | **moved** | — |
| `heroes` does not contain the companions | 3.00 | **moved** | — |
| A widening is done when the effect arrives | 3.18 | **moved** | — |

None of the nine had a `###` child, so no heading was orphaned on either side.

## §2 — THE RULES THE SPLIT OBEYS

- **`CLAUDE.md` REMAINS THE ONE FILE A BATCH MUST READ.** The new file is a reference: `CLAUDE.md` names it in its
  what-goes-where list and carries a pointer block with the index (*THE COMBAT RULES LIVE IN `docs/combat-rules.md`*,
  after the instrument pointer); the new file names `CLAUDE.md` as the required read in its first sentence. Nothing in
  either is a summary of the other.
- **A RULE THAT BELONGS TO BOTH SUBJECTS STAYED** — nine combat blocks (§1e), each with its second subject named.
- **THE TIEBREAK IT REPLACES IS RETIRED EXPLICITLY, WHERE IT IS STATED.** In `CLAUDE.md`, a bullet directly under the
  instrument pointer's blockquote marks *every rule about what the GAME may contain is in this file* retired at GR §2,
  says why (that guarantee and the binds-not-about test are what made the subject seam unavailable, and the file crossed
  its ceiling with nothing of that kind left) and says what stands (the binds-not-about test still decides what is an
  instrument rule; a rule belonging to two subjects still stays). In `docs/instrument-rules.md`, one paragraph after the
  tiebreak it states does the same. **Both say a batch meeting the old sentence must not refuse a subject split on it.**
  The sentence itself was not rewritten — it is marked, as CL §1 marked the two-tier rule.
- **EVERY OTHER CHANGE TO `CLAUDE.md` IS A POINTER THE CUT WOULD OTHERWISE HAVE LEFT FALSE**, and each is listed so the
  rejoin can revert it: the what-goes-where list gains the new file; its ways-of-working bullet said *every rule about
  what the game may contain is still here* and now says *here or in `docs/combat-rules.md`*; the ceiling block's
  *taken twice* is *three times*, and it gains one sub-bullet recording the ruling and what is left; the sync list's
  must-stay-selected entry gains the new file. **No rule was rewritten.**

## §3 — EVERY PIN MAPPED BEFORE A BLOCK MOVED

- **The manifest:** 70 pins into `CLAUDE.md` from 27 readers; 51 locate in a block and **none in the nine** (card 25,
  constitution 8, talent 5, ladder 4, misc 3, combat 3 — all three in blocks that stayed — engine 2, code 1).
- **The literal sweep, which the manifest cannot replace:** every string literal of 4+ characters in all 147 `.gd`
  files (17,652), asked of HEAD's and the split `CLAUDE.md` in three forms. **LOST 82 raw / 78 lowered / 83 flattened —
  the nine blocks' own text — and GAINED 0.** The 22 files that both read `CLAUDE.md` and carry a lost literal were
  scanned with the manifest's own extractor: the four pins on a lost literal are against `battle.gd` and
  `enemies.json`. `docs/instrument-rules.md` lost nothing and gained one path literal no negative pin holds.
- **The index hazard, proved once:** in the split `CLAUDE.md`, twelve literals resolve only inside an index — the same
  twelve as at HEAD, all inside FF's index and all FF's own intended checks (`check_ff` §1's headings, `check_fg` §3's
  row, `check_ec`'s needle, which it pins against the reference). **None resolves only inside the new one.**
- **EF's test, run as EF ran it:** **the whole battery, 115 targets, against the tree with the split documents landed
  and every suite and gate unmodified, before one instrument was edited.** `check_de` read **477 checks / 0 failures / 0
  notices**; the only reds were the two sanctioned ones, `check_cm_live` 13 / 4 and `check_gj` §4 at *"the card says
  +172 gold and the purse moved 192"* — **byte-identical to GQ's acceptance log**. Diffed target by target against GQ's
  acceptance run, **113 of 115 read the same count; the two that differ are the known drifters inside their bands**
  (`test_batch_an` 6084 → 6086 in [6076, 6093], `test_batch_bk` 130 → 129 in [128, 130], neither of which reads a
  document). **The split moved no count anywhere, so no re-point was owed** — which is EF's distinction between a
  re-point that is necessary and one that is decorative, measured. The manifest was the prediction; this was the
  reading. One ascending sequence in the runner's order, no name twice, no parse or script error in any stream; the tree
  stamped by md5 before (565 files, absolute paths, untracked included) and identical after; the player's four saves
  identical to their backup hashes after it.
- **The territory, and the six instruments that learned the file.** A rule file suites can assert against, left outside
  the sweeps, is a population an instrument reports clean without reading (EC §2):

| instrument | edit | count | control — HEAD's gate | control — GR's gate |
|---|---|---|---|---|
| `build_pin_manifest.py` | `DOCS` gains the file | — | — | pins against it classified `document`: 1,470 → **1,475**, all five `check_ff` §5's; nothing else moved |
| `check_ec` | `DOCS` gains the file (§0 +1) | 23 → **24** | a §5 needle broken in the new file: **23 / 0** | **25 / 2**, naming the needle and the file |
| `check_ea` §3 | the holder regex gains the file | 83 | a batch-code pin against it: **83 / 0** | **84 / 2**, naming `check_ff` |
| `check_fr` §2, §5 | compares against it; prints its size | 25 | a ways-of-working line copied into it: **25 / 0** | **25 / 1**, naming it |
| `check_dj` §6 | the live prose gains it (+2) — the rule its retired belief contradicts moved there | 43 → **45** | the belief written into it: **43 / 0** | **45 / 1** |
| `check_ff` §0, §4 | a second index located (+3); §4 accuses a pin resolving only inside either | 55 → **68** | a pin on a moved title: **55 / 0** | **69 / 2** — accused by name while the pin itself passes |
| `check_ff` §5 (NEW) | the seam's residency, derived from the index (+10) | | a moved heading put back / a body line copied back / a rule added with no row / a row deleted: **55 / 0** each | **68 / 1**, **68 / 1**, **68 / 1**, **68 / 2** — each naming what was aimed at |

## §4 — THE REJOIN, PROVED

A second script (`verify.py` in the scratchpad), sharing nothing with the splitter, read HEAD's files straight out of
git and asserted:

- **the headings partition, counted two independent ways** (a line regex and a character walk): HEAD's 116 are the main
  half's 107 plus the reference's 9, the two new headings known by name, zero overlap, order preserved on both sides;
- **the payload**: each moved block occurs once in HEAD, once in the reference, never in the main half, and the
  reference's header carries no heading a rule could hide under;
- **the index**: each moved heading survives in the main half as one table row and no other line;
- **the bodies rejoin byte for byte**: the main half with its pointer block removed and its declared repairs reverted,
  interleaved with the reference's payload in HEAD's heading order, **is** HEAD's `CLAUDE.md`;
- **`docs/instrument-rules.md` is HEAD's plus exactly one declared insertion.**

**NO FILE SIZE WAS COMPARED ANYWHERE.** It ran on the scratch copies, and again on the landed files: **0 failures**.

| control | failures | which assertions fired |
|---|---|---|
| C1 — a moved block dropped from the reference | 6 | the heading sums and sets (both ways), `B.found`, byte-identical |
| C2 — a moved block left in both halves | 8 | the heading overlap, sums and sets (both ways), `P.not-in-main`, the index row |
| **C3 — one word misspelt inside a moved block, same length** | **2** | **only the byte-exact ones: `B.byte-identical`, `P.in-head-once`** — every heading count passes |
| C4 — one word misspelt inside a block that stayed, same length | 1 | `B.byte-identical` |
| C5b — a declared repair's text edited | 2 | `B.repair-once`, byte-identical |
| C6 — `instrument-rules.md` edited outside its insertion | 1 | `I.rest-identical` |
| C5 — an edit inside a declared INSERTION (the retirement bullet) | **0** | **none, by design**: new prose is not part of the rejoin's population, and the rejoin claims nothing about it |

C3 is the one FG's rule exists for: it moves no heading and no size, and only the byte-exact rejoin sees it.

## §5 — THE HEADROOM BOTH HALVES HAVE

### 5a. `CLAUDE.md`

| | |
|---|---|
| before | 348,868 B = 340.69 KiB |
| after | **326,190 B = 318.54 KiB** |
| headroom to 340 KiB | **21,970 B = 21.46 KiB** |
| at FF's +4,315 B a batch | **5.1 batches** |
| at the main half's own +2,246.6 B a batch since FF | **9.8 batches** |
| at the largest single batch on record (+8,293 B, EZ) | 2.6 batches |
| to `check_fg` §2's failure line (356,454 B) | 30,264 B |
| the split's own cost inside `CLAUDE.md` | 5,470 B — the pointer block and index 3,118, the retirement and the ceiling block's record most of the rest |

**`check_fg` follows without an edit.** It parses the ceiling out of `THE CEILING IS <n> KiB` (every occurrence must
agree) and the headroom term out of the one *largest single-batch growth on record* sentence; neither moved, the new
text states no ceiling, and in the recon and the acceptance run alike it printed *"under the ceiling with 21970 B =
21.46 KiB of headroom"* and read 22 / 0, its row unmoved.

### 5b. Does the moved half grow faster than the main one? **No — it is the nearly static half.**

| window | moved half (the nine) | main half | whole `CLAUDE.md` | `docs/instrument-rules.md` |
|---|---|---|---|---|
| FF → GQ, 36 batches | **+701 B, +19.5 B/batch** | +80,876 B, **+2,246.6 B/batch** | +2,266.0 B/batch | +21,800 B, **+605.6 B/batch** |
| the last 25 batches, FQ → GQ | **+28.0 B/batch** | +2,347.1 B/batch | +2,375.2 B/batch | +301.6 B/batch |
| EF → GQ, 63 batches | +100.9 B/batch (the crit rule's birth at EW is +4,340 of it) | +2,584.7 B/batch | | |

**The brief's question was already settled**: EF read the instrument half growing twice as fast over five batches and
called it composition; FF measured twenty-five (EF→FE) and found it thirty-seven times slower. Over FF→GQ the instrument
reference grows at about a quarter of `CLAUDE.md`'s rate (it gained FG's, FH's, FI's and FR's rules and GA's
corrections, written straight into it), and the combat reference at under a hundredth.

### 5c. `docs/combat-rules.md`

**30,440 B = 29.73 KiB, no stated ceiling**, under the same procedure. EE's method on its own record: floor 29.73
KiB (the file as split — nothing in it but tested rules and its header) plus ten × +4,340 B (the largest single-batch
growth these nine blocks have had, the crit rule's birth at EW) = 72.11 KiB → **70 KiB**. On FF→GQ's record alone
(+407 B, GB) it would be 33.7 KiB — a ceiling within one batch's reach, which EE's method exists to avoid. Adopting
either is a ruling (NEEDS A RULING 1). `check_fr` §5 prints its size every battery.

### 5d. What happens when `CLAUDE.md` reaches the ceiling again

**There is no fourth seam that batches read rarely.** What is left is card law (85.89 KiB, 7 writers since FF), engine
law (41.80, 7, and nine of its ten blocks also bind a card, rune or talent) and rune law (38.49, 10) — more than half the
file — and every other subject is small or mostly one of those. **Rune law is the one that would come away cleanly**
(14 of 15 blocks, 34.25 KiB, no second subject), and step 5 of the merge reads it every batch. So the next batch at 340
has two moves and both are the designer's: split a subject batches read often and accept that more of them open two
files, or re-derive the ceiling a second time, which moves with the file. **This is recorded in `CLAUDE.md`'s ceiling
block**, where FF's equivalent was, because that is where the next batch at the ceiling reads.

## §6 — WHAT IS DELIBERATELY NOT DONE

- **Nothing is pruned.** **No rule is rewritten**: every moved byte is HEAD's, and the only new prose is the pointer
  block, the retirement (in both rule files), the ceiling block's sub-bullet and the pointer repairs listed in §2.
- **No code, card, engine, rune, node or magnitude moved.** No game script was touched.
- **`docs/master.html` is not edited**; nothing a player meets changed.
- **A pointer that was already wrong was moved as it was** (FOUND AND NOT FIXED).
- **The queue stands**: the four kit texts, the Crown's resistance, the Bell, Elemental Weakness's blind abilities,
  the Nexus Ward rename, the kill-credit edge, the class-wide rebalance, the 43 engine-reading runes, the 52 engine-bound
  gates.

## §7 — VERIFICATION

**THE ACCEPTANCE RUN IS GREEN.** 115 targets in 55 minutes, **`check_de` reading 477 / 0 / 0** — every row this batch
moved is recorded with its reason and no count drifted unrecorded. **The only two reds are the standing sanctioned
ones:** `check_cm_live` 13 / 4, unchanged since before GK, and `check_gj` §4's Tollkeeper's Bell at +172 / +192, its FAIL
line byte-identical to GQ's.

**TARGET BY TARGET AGAINST GQ'S ACCEPTANCE RUN, 111 OF 115 READ THE SAME.** The other four are the three rows this batch
moved, each at exactly its predicted count — `check_ff` 55 → **68**, `check_ec` 23 → **24**, `check_dj` 43 → **45** — and
`test_batch_an`, a known drifter, at 6,077 inside its band [6076, 6093]. **The second pass read what the acceptance run
read on 114 of 115**, `test_batch_an` the one (6,083 there). The recon, whose gates were unmodified, differs from it on
the three moved rows, as it must, and on both drifters — `test_batch_an` 6,086 there, `test_batch_bk` 129 there and 130
here, inside [128, 130].

**THE ORDER.**

1. **The four player saves backed up and verified by hash before a line was written** —
   `save-backups/GR-20260918-143634`, byte-identical to GQ's backup — and read back by hash after the recon, before
   the acceptance run and after it: unchanged every time.
2. **The brief checked against the repo before anything was measured** (§0).
3. **The seam measured** (§1): all 113 blocks classified by subject, every batch commit since FF mapped onto HEAD's
   blocks, the recommendation derived from what batches wrote into.
4. **The split built as scratch copies from HEAD's bytes**, every anchor asserted once; **the rejoin proved by a second
   script and its seven controls** (§4); the literal sweep and the manifest map run on the copies (§3).
5. **The three split documents landed behind a HEAD-hash guard**, the rejoin re-proved on the landed bytes, and the
   tree stamped by md5.
6. **The recon — the whole battery with every gate unmodified against the split tree** (§3): 477 / 0 / 0, and the
   tree's stamp identical after it.
7. **While the recon ran, everything else was built outside the tree.** The six instrument edits as scratch copies, run
   clean in an isolated copy of the tree renamed so its `user://` could not reach the player's saves, with **nine
   two-armed controls** read in HEAD's gate and the edited one; and the other documents as scratch copies, swept — the
   literal sweep over the changelog, the design notes and `docs/state.md`, and `check_es` §4's own extraction
   reproduced on HEAD's and the new `state.md` and `CLAUDE.md` (two windows and four figures, one window and two,
   identical both sides).
8. **The second pass — the whole battery again, in that copy carrying every edit** (FF's lesson: a batch that writes an
   instrument owes the pass twice): `check_de` 477 / 0 / 0, every census gate green. **The copy was the tree but for its
   name**: of the frozen tree's 565 files, 460 are byte-identical in it, `project.godot` differs by the renamed
   `config/name` alone, and the 104 save backups were left out of it on purpose; nothing in it was written after the
   pass began.
9. **Everything else landed behind the same hash guard once the recon was done**, `pin-manifest.json` reported current
   at 1,475, and **three identical standalone readings** of each moved row in the tree — `check_ff` 68 / 0,
   `check_ec` 24 / 0, `check_dj` 45 / 0 — with `check_ea` 83 / 0, `check_fr` 25 / 0 and `check_parse` 189 / 0, **no
   parse, compile or script error in any stream.**
10. **The acceptance battery, over a tree stamped by md5 before it** (565 files, absolute paths, untracked included)
    **and identical after it**; one ascending sequence in the runner's order, no name twice, no parse or script error
    in any stream.
11. **`ps` rows read after it, not a count**: no Godot and no battery running.

**WRITTEN AFTER THE RUN, AND WHY THAT IS SAFE.** This report, which no gate reads, and `docs/state.md`'s VERIFICATION
bullet, which gained the verdict in place of its sentinel. `docs/state.md` is read by `check_es` §4 alone, through its
"2+ threshold" windows: **`check_es` re-run over the final file wrote a log byte-identical to the acceptance run's**, and
the literal sweep of the copy the battery read against the final file reads **LOST 0 and GAINED 0** in all three forms,
over 17,677 literals. The player's saves read unchanged after both.

## FOUND AND NOT FIXED

- **SIX OF THE BRIEF'S ATTRIBUTIONS NAME THE WRONG BATCH** (§0). None changed the work.
- **A POINTER INSIDE A MOVED RULE HAS POINTED AT THE WRONG PLACE SINCE EF.** *A status is applied with its `src`* says
  *"see the second standing rule below, which DJ earned from this"*; that is DJ §3's *a number quoted from one document
  into another stops being a measurement*, which EF moved to `docs/instrument-rules.md`. It was wrong in `CLAUDE.md`
  and is wrong in the reference; correcting it is a rule edit.
- **`docs/ways-of-working.md`'s header still names two rule files** (*"`CLAUDE.md` and `docs/instrument-rules.md` bind
  what a batch DOES"*; *"a third file and not a third seam"*). True of what it names and silent on the third; not edited.
- **`claude_md_census.py` censuses `CLAUDE.md` alone**, so the nine blocks have left its population; its category shares
  now move by composition. A tool, not a gate.
- **Two rules share one provenance tag, and the split puts them in different files**: *charges and on-hit effects count
  hits* and *sweep a name against the whole roster* are both "BR §1". A citation by tag alone is ambiguous, as it was.
- **ONE CONTROL COPY LEFT A USER-DATA FOLDER** under Godot's `app_userdata`: "Dawn of Decay GR ctl", renamed before
  anything ran in it. It can be deleted.
