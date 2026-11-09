# JR — THE ROUTING OF RECORD

Part of JR's report (`docs/reports/JR.md`). **Written before the work began** (the subjects and the matches on 2026-11-09, before any edit): the brief's subjects, the index rows whose triggers name them — each with the trigger that matched, verbatim from its row — the population rows whose triggers name a subject, the blocks those population rows add, and the core. **That list plus the core is what JR opens, the core whole.** The file read is HEAD's `docs/state.md` (`11756af`, 164 entries: 140 rows, 15 core, 9 population rows).

## THE BRIEF'S SUBJECTS

- **S0** §0 JQ's seven rulings accepted as taken (housekeeping): Forsaken, 3 turns, laid by Forsake on the Cleric's shelf at Unburden's price; the name sweep over 1,019 names, *Into the Opening* holding the Skirmisher's engine, so Read the Tell; a death clears Forsaken, a Raised body stands up unmarked; the cleanse aims at every single-pick site and ranks the Bleed chip last; `HEX_IDS` four ids written down; Read the Tell on the Warrior's shelf, 20 Rage, cooldown 3, +20% a turn of the declared move's cooldown; the plate's hover names that cooldown; `check_jq` §4's twenty-one fights with the warband's attacks on, the count's base 36 to 56, the Bloodcaller and the Hexer seated. JQ's rulings struck to the archive; the core's role passes to JR's.
- **S1** §1 the three rare carriers made meetable: which enemies lay which hex (Gall the Orc Archer's, Sap the Orc Hexer's on Bone Rattle, Mire the Grave Totem's, Fester the Rot Behemoth's on Wretched Bellow); how often each kind is fielded (Archer 12, Hexer 2, Grave Totem 2, Rot Behemoth 1 of JQ's 56 attacking fights; hex uptimes Gall 5.95%, Sap 0.15%, Mire 0.39%, Fester 0.07%); how a fight's bodies are picked from a roster (`run_state.gd`: a zone hosts a roster id per slot, roster ids are the `zones` tags in `enemies.json`; a flat draw, a weight, a per-kind cap, an elite-only tag, a rung tag); the smallest change that makes the Orc Hexer, the Grave Totem and the Rot Behemoth appear materially more often (a weight raised, or each added to more rosters); whether any is a boss, an elite or fielded by a rule; no hex moves, no new move, status, fold, kind or line of code; the alternative named and not taken (folding the hexes onto commoner kinds' free damaging slots — the Orc Chief's Heavy Strike or Chieftain's Maul, the Whelp's Reckless Lunge, the Brute's Overhead Crush, the Slinger's Skull Crack); the new figures as a count over the fights the gates already run (each of the three fielded, each hex laid), no drive.
- **S2** §2 every line-number citation replaced by the text it points at: every `file:NNN` citation across `docs/state.md`, `CLAUDE.md`, `docs/master.html`, `docs/instrument-rules.md`, `docs/ways-of-working.md`, `docs/combat-rules.md` and the reports, each replaced by the function and a quoted line (JP's readout's shape); the count found, replaced and unresolvable; FOUND AT HA's `check_di` citation drifting (JO's close-read); the rule written into `docs/ways-of-working.md` beside the citation rule (*a record cites a file, a function and a quoted line, never a line number*); a cheap gate holding it (a regex for `\.gd:\d+` over the documents); which citations legitimately need a line (a pin manifest, a baseline row, a gate's own internal reference), excluded in the gate.
- **S3** §3 the triggers owed and the index's amend-the-row misses: the eight close-read triggers (FOUND AT JJ: *credit nobody*, *kill term*; *Carried, with measurements attached*: *re-tune*, *every text that states it*; THE SHARE CENSUS: *Encumbered*, *warband cooldowns*; THE TALENT LAYER: *Cleanse Debuffs Each Turn*; THE DRAFT AUDIT: *ability corpus*, *PER_CLASS_DEPTH*; THE BOSS-PICK POOLS: *class-wide draft pool*; THE THREE PRICING QUESTIONS: *new draft card price*, *kit card baseline*; *Carried from the code*: *RECAST_GATED*, *new draft card*); JP's two (FOUND AT HN: *condition on* with *condition_met*; *Small, and still owed*: *fixed boards* with *attacks off*); JO's (FOUND AT GP and *AND FP's `block_chance` FINDING TRAVELS WITH IT*: *can be blocked*); `check_is` §5's 400-byte row ceiling, the weakest trigger trimmed rather than a new one skipped; THE WARBAND's COOLDOWNS and WHAT THE RAISE DID each took a dial and name none in the index; THE PARTY's THREE ANSWERS lacks *`block_chance`*; FOUND AT JO keeps *hex count* and *JO-count*; the claims population row names `IV's RULINGS OWED`; the stale claims: the Malice ledger's comment (*nothing in the game reads it*), `relics.gd`'s header (one relic a zone-boss kill; the end boss hands one too, FOUND AT GB), `KNOWN_STRAYS`' count (ten, called eight).
- **S4** §4 the ceilings and the archive: `docs/state.md` against its 440 KiB and `CLAUDE.md` against its 510, read at the open and the close; the projected figure for JS; archive a closed block by the archive's own method if the close is under one batch's room; the changelog's figure against its 400 KB bar (JL's close-read: 171,620 B) and how many batches of room.
- **S5** §5 what is deliberately not done: no balance drive, the untalented line retired; no dial pulled (the Cleric's cut, JO's seven, JN's ten); difficulty deferred; no hex moves, no new status, move, kind or card; Forsake, Read the Tell and the aiming cleanse as JQ built them; the four hexes' figures, the three spends, Malice's three terms and cap, the Break price, the nine held bands; no grade re-authored, the deck closed at twenty-five; JI's line not moved into the game; the reserve bug as found; the left-standing list (Boil Over's reachability, Sunder, Exposed, Cripple and Slowed unpriced, Chieftain's Maul at band 0, the crest divergence, Fleeting and Encumbered, the eight trimming plate pairings, the Regalia trap, a body over 377, Raise skipping Bloodless, a second kill and the Reaver's count, Called Shot's mode and the sim's raw armour, the Bomb's blast credit, the glossary's missing Malice entry; `test_batch_bm` §9's window, `Gate.within`, the cheap gates, the thirteen picks, `check_it` §2c, `check_hn` §2a, the latent floor shapes, the Cryomancer's route, the playthrough).
- **S6** §6 the verification, less every drive: the push check; the routing before any edit; the blocks' reader before the first edit reaches a lane; the premises at source; the literal sweep; the documents replayed from HEAD behind a hash guard; the new text's reader and the close-read; a recon (§1 moves `data/enemies.json`); the pre-run; the new gate; all 489 positional reads; the controls (C01–C16, H01, H02); the fresh reader; the acceptance; the landing; the two ceiling readings and the projection for JS; whether any line a fight runs through moved.

## THE ROWS THE TRIGGERS MATCHED — 61

| block | subjects | the triggers that matched (verbatim from its row) |
|---|---|---|
| `` ### THE WARBAND's HEXES `` | S1 S5 | hex; Gall; Sap; Mire; Fester; Orc Hexer; Orc Archer; Bone Rattle |
| `` ### THE WARBAND's COOLDOWNS `` | S1 S3 S5 | Wretched Bellow; Break price; HELD; Chieftain's Maul; dial 2; Read the Tell; JP-dials |
| `` ### THE WARBAND's MALICE `` | S0 S3 S5 | Malice; Forsaken; Forsake |
| `` ### THE WARBAND's SPENDS `` | S0 S5 | raised body |
| `` ### WHAT THE RAISE DID, AND THE GAME WITH TALENTS `` | S1 S3 S5 | what the raise did; Skull Crack; dial 3 |
| `` ### THE SHARE CENSUS `` | S3 S5 | share census; Encumbered |
| `` ### THE BARGAIN DECK's GRADES `` | S5 | deck closed; Fleeting; Encumbered |
| `` ### THE ARC, READ WHOLE `` | S5 | Fleeting; Encumbered; Bloodless |
| `` ### FOUND AT JQ AND NOT FIXED `` | S0 S5 | Read the Tell; declared move; punish |
| `` ### FOUND AT JP AND NOT FIXED `` | S1 S3 S5 | theme; reserve bug; DOD_ENEMIES_OFF; count denominator; JP-count |
| `` ### FOUND AT JO AND NOT FIXED `` | S3 S5 | Break price |
| `` ### FOUND AT JM AND NOT FIXED `` | S3 | end boss relic; relic grant gold |
| `` ### FOUND AT JK AND NOT FIXED `` | S5 | second kill; Reaver kill count |
| `` ### FOUND AT JJ AND NOT FIXED `` | S3 | credit nobody |
| `` ### FOUND AT JI AND NOT FIXED `` | S4 S6 | WHERE block pins; PROJECTED FOR |
| `` ### FOUND AT JH AND NOT FIXED `` | S4 | next closed block |
| `` ### FOUND AT JD AND NOT FIXED `` | S3 | KNOWN_STRAYS |
| `` ### FOUND AT IX AND NOT FIXED `` | S1 S6 | check_hk walk not seeded |
| `` ### FOUND AT IW AND NOT FIXED `` | S1 | DOD_ZONE_ROTATION; zone rotation; slot pools; draw_zones; a zone no player can draw; player's zone draw |
| `` ### THE RULES A GATE COULD CHEAPLY HOLD `` | S2 | cheap gate; standing list |
| `` ### FOUND AT IU AND NOT FIXED `` | S2 S3 | cheap gate; stale claims outside the census |
| `` ### FOUND AT IT AND NOT FIXED `` | S6 | positional census MISSES ceiling |
| `` ### FOUND AT IS AND NOT FIXED `` | S4 S5 | leftover closed items; Cryomancer's route |
| `` ### FOUND AT IQ AND NOT FIXED `` | S3 | stale code comments |
| `` ### FOUND AT IK AND NOT FIXED `` | S1 | enemies.json |
| `` ### FOUND AT II AND NOT FIXED `` | S3 | credit nobody |
| `` ### FOUND AT HZ AND NOT FIXED `` | S5 | Boil Over |
| `` ### FOUND AT HR AND NOT FIXED `` | S3 | stale code comments |
| `` ### FOUND AT HN AND NOT FIXED `` | S3 | condition on; condition_met |
| `` ### FOUND AT HA AND NOT FIXED `` | S2 | check_di |
| `` ### GW's RULINGS OWED `` | S6 | new gate |
| `` ### GR's RULINGS OWED `` | S4 S6 | the two readings; KiB ceiling |
| `` ### FOUND AT GP AND NOT FIXED `` | S3 | can be blocked |
| `` ### GO's RULINGS OWED `` | S0 S5 | Reaver; Skirmisher; second kill; raised body |
| `` ### GN's RULINGS OWED `` | S0 | name sweep |
| `` ### FOUND AT GN AND NOT FIXED `` | S6 | check_gj 4 sanctioned red; baselines.json |
| `` ### FOUND AT GL AND NOT FIXED `` | S5 | Called Shot |
| `` ### FOUND AT GJ AND NOT FIXED `` | S1 S5 S6 | Regalia; check_fh |
| `` ### THE TALENT LAYER IS BUILT (FX); FIVE THINGS IN IT, AND SEVEN OF FW'S EDGES, ARE THE DESIGNER'S `` | S3 | Cleanse Debuffs |
| `` ### FY §1: THREE NODES PAID BY WHO ELSE HELD THEM, AND TODAY'S COUNT DOUBLES FOUR ITEMS `` | S0 | name sweep |
| `` ### FOUR GATES CAN WRITE THE PLAYER'S `relics.json` THE DAY A RELIC IS LOCKED `` | S3 S6 | Relics.unlock_random; _resolve_boss; check_fh |
| `` ### FOUND AT GA AND NOT FIXED `` | S2 S3 | stale claims |
| `` ### FOUND AT GB AND NOT FIXED `` | S3 | stale comments in scripts and gates; relic unlock |
| `` ### FOUND AT FW AND NOT FIXED `` | S3 | relics.gd hook read sites; stale comments |
| `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` | S2 S6 | pin-manifest.json; ways-of-working.md |
| `` ### **AND FP's `block_chance` FINDING TRAVELS WITH IT `` | S3 | can be blocked |
| `` ### THE LADDER `` | S1 | rung-tagged enemy abilities; enemies.json rung tag; wider warband encounter shape; compose floor; enemies.json |
| `` ### THE DRAFT AUDIT `` | S3 | PER_CLASS_DEPTH |
| `` ### THE BOSS-PICK POOLS `` | S3 | class-wide draft pool |
| `` ### THE THREE PRICING QUESTIONS `` | S3 | new draft card price |
| `` ### Small, and still owed `` | S1 S3 | fixed boards; attacks off |
| `` ### Carried, and still awaiting a ruling `` | S4 | CLAUDE.md ceiling |
| `` ### Carried, with measurements attached `` | S3 | re-tune |
| `` ### Carried from the code, reported and deliberately not fixed `` | S3 | new draft card |
| `` ## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND `` | S3 | relics |
| `` ### THE TEST TREE, AS OF EF `` | S6 | baselines.json rows; new gate rows |
| `` ### The changelog `` | S4 | check_fg 1 400 KB; changelog headroom; next changelog cut owed |
| `` ### Knowledge sync, re-measured at EG `` | S4 | CLAUDE.md ceiling |
| `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` | S6 | sanctioned reds |
| `` ### THE REST `` | S6 | check_gj 4 red Tollkeeper's Bell; check_cm_live 4-5 failures |
| `` ### FIVE MORE THINGS FH FOUND AND DID NOT FIX `` | S6 | new gate |

## THE POPULATION ROWS THE TRIGGERS MATCHED — 4, AND WHAT EACH ADDS

| population row | subjects | the triggers that matched (verbatim) | member blocks | added beyond the subject triggers and the core |
|---|---|---|---|---|
| **the claims** | S2 S3 | stale claims; the claims | 8 | `` ### FOUND AT HV AND NOT FIXED ``; `` ### FOUND AT HY AND NOT FIXED ``; `` ### FOUND AT GF AND NOT FIXED ``; `` ### FOUND AT GC AND NOT FIXED ``; `` ### FOUND AT GR AND NOT FIXED `` |
| **the closed matter** | S4 | archive what is closed; closed blocks; strike what is closed | 6 | `` ### FOUND AT HO AND NOT FIXED ``; `` ### FOUND AT GF AND NOT FIXED ``; `` ### THE CRIT SURPLUS IS RULED END TO END ``; `` ### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED `` |
| **the positional picks** | S6 | positional census; MISSES ceiling | 4 | `` ### FOUND AT IM AND NOT FIXED ``; `` ### GY's RULINGS OWED `` |
| **the latent shapes** | S5 | latent shapes | 12 | `` ### FOUND AT IR AND NOT FIXED ``; `` ### FOUND AT IC AND NOT FIXED ``; `` ### FOUND AT IL AND NOT FIXED ``; `` ### FOUND AT IM AND NOT FIXED ``; `` ### FOUND AT HY AND NOT FIXED ``; `` ### FOUND AT FX AND NOT FIXED `` |

## THE CORE — 15, READ WHOLE

- `` ## WHERE THE PROJECT IS ``
- `` ## THE OPEN QUEUE ``
- `` ### JQ's RULINGS OWED ``
- `` ### THE CLERIC's MANA RATE ``
- `` ### SANCTITY's STEP ``
- `` ### BOIL OVER'S RATE ``
- `` ### THE CREST POOL ``
- `` ### FOUND AT IA AND NOT FIXED ``
- `` ### RULED AND NOT BUILT ``
- `` ### FOUND AT HX AND NOT FIXED ``
- `` ### THE PLAYTEST'S OTHER FINDINGS ``
- `` ### THE FOUR OTHER CONJUNCTIONS ``
- `` ### THE SKIRMISHER AND THE TRACKER ``
- `` ### THE SHAPE RECON ON `CLAUDE.md` ``
- `` ### TO WATCH IN PLAY ``

## THE LIST, AND ITS SIZE

**90 blocks: the core (15), the 61 matched and the 14 the population rows added — 286,191 B of HEAD's 449,926, each read whole.**

## OPENED

**All 90 blocks of the list above, each read whole, and `## THE INDEX` whole by its own rule** — the core (15) and the index by me, and all 90 by the blocks' reader at source on a frozen copy of HEAD (`route/opened_reader.md`; `lanes/read0`, frozen at 05:01:44). The routing of record was born at 05:01:32, before any edit; the reader's findings at 05:34, before the first edit reached a lane at 05:39.

**And two blocks outside the list, opened before their edit** — `` ### FOUND AT HL AND NOT FIXED `` and `` ### TWO SMALL DOC REPAIRS FR FOUND AND DID NOT TAKE `` — each held a line-number citation §2 replaced, and neither row's triggers named the subject (the blocks' reader's H5). A read outside the matched list is data: these two are why the close's third list names them, and why each row now carries *line-number citation*.

## NEEDED

**26 of the 92 opened were needed, and 21 of them changed** — each by JR's work or by what it wrote:

- `` ## WHERE THE PROJECT IS `` — rewritten; six gates' needles kept in §5's line (Communion's figure, the projection's head, the spends' prices, the hexes' sentence, the Break price, the last batch's code).
- `` ### JQ's RULINGS OWED `` — answered in JR's brief, all accepted as taken; archived struck; `` ### JR's RULINGS OWED `` stands in its place, CORE by role.
- `` ### THE WARBAND's HEXES `` — which kinds lay which hex, read for §1; the block's text needed no edit (its carriers stand).
- `` ### THE WARBAND's COOLDOWNS `` — named the digest gates (`check_ji` §1a and §4, `check_jo` §1, `check_jn` §1, `check_jp` §0) that §1's data moves; read, not edited.
- `` ### THE SHARE CENSUS `` — takes *warband cooldowns*, *two sides' shares* trimmed.
- `` ### FOUND AT JP AND NOT FIXED `` — the ledger comment's item archived; its label mended.
- `` ### FOUND AT JM AND NOT FIXED `` — the relic header's item archived; *end boss relic* struck.
- `` ### FOUND AT JJ AND NOT FIXED `` — takes *kill term*.
- `` ### FOUND AT JD AND NOT FIXED `` — the strays' item says ten names.
- `` ### FOUND AT HN AND NOT FIXED ``, `` ### Small, and still owed ``, `` ### FOUND AT GP AND NOT FIXED `` and `` ### **AND FP's `block_chance` FINDING TRAVELS WITH IT `` — read for the owed triggers, already taken; the last's citation replaced.
- `` ### FOUND AT HA AND NOT FIXED `` — its citations replaced; `check_gn`'s half archived (re-pointed at HJ).
- `` ### FOUND AT GL AND NOT FIXED `` — its citations replaced; Charge's clause archived (closed at HW §3); *Charge Daze* struck.
- `` ### FOUND AT GB AND NOT FIXED `` — the relic header's sub-item archived; *relic unlock* struck; its other citations replaced.
- `` ### FOUND AT FW AND NOT FIXED `` — its citations replaced; the struck CV sentence archived.
- `` ### FOUND AT HO AND NOT FIXED `` and `` ### FOUND AT FX AND NOT FIXED `` — their citations replaced.
- `` ### GY's RULINGS OWED `` — its four arms' citations replaced (one quoted line had changed beside its place).
- `` ### THE DRAFT AUDIT ``, `` ### THE THREE PRICING QUESTIONS `` and `` ### Carried from the code, reported and deliberately not fixed `` — take *ability corpus*, *kit card baseline* and *RECAST_GATED*; `` ### Carried, with measurements attached `` takes *every text that states it*.
- `` ### FOUND AT HL AND NOT FIXED `` and `` ### TWO SMALL DOC REPAIRS FR FOUND AND DID NOT TAKE `` (outside the list) — their citations replaced; each takes *line-number citation*.

## FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED

- `` ### THE FIRST CLEAN PLAYTHROUGH `` — **PLAINLY. NOT ROUTED**: the routing carried no subject for the floor's *AND THE ARC WAS PLAYED*, and the row's `playtest readout` and `second playthrough` are not the brief's words (*the playtest*, *played*). Its *a second run with a different party is asked for* still stands. JR's WHERE names the two 9 November runs, says JR read none of them, and drops the pointer; both runs are debug-touched, so neither answers it. **Trigger owed**: `playtest`.
- `` ### FOUND AT JN AND NOT FIXED `` — **PLAINLY. NOT ROUTED**: no trigger names the warband's digests. Its *the warband's digest (`check_jn`'s `DATA_REST`) stays the tripwire — a later enemy tune re-points it* is exactly JR §1's re-point (`MOVED_SINCE`), and `check_jr` §1 is a sixth digest the next tune meets. **Trigger owed**: `DATA_REST`, `MOVED_SINCE`.
- `` ### FOUND AT JF AND NOT FIXED `` — **PLAINLY. NOT ROUTED**: the brief's §5 names its `test_batch_bm` §9 window and `Gate.within` as standing, and the row carries neither. Its *inline `_doc(…).contains(…)` pin sits outside `check_ed`'s scan* is repeated by four `check_jr` document pins missing from `pin-manifest.json`. Its partly closed FOUND AT GL Renewal and FOUND AT HO *at least 1* items stand beside JR's cut of the same GL item. **Trigger owed**: `Gate.within`, `test_batch_bm 9`, `inline _doc pin`.
- `` ### THE CROSS-TARGET SUPERSESSIONS `` — **PLAINLY. NOT ROUTED**: its `check_jp 3` and `AUTHORED_SINCE` name JR's work, not its brief. *A batch that retires or narrows a superseder reads this first*: JR narrowed `check_jo` §1 (the table's superseder for `check_jn` §1's walk) and `check_jp` §3 (re-pointed here at JQ), plus `check_ji` §4, `check_jn` §1 and `check_jq` §5, with `MOVED_SINCE`. The table has no row saying the three tags stand on `check_jr` §1 alone. **Trigger owed**: `MOVED_SINCE`.
- `` ### FOUND AT JL AND NOT FIXED `` — ARGUABLY. **NOT ROUTED**: no trigger names `CLAUDE.md`. Its *one clause, the next time that file is opened; `CLAUDE.md` takes nothing this arc* outlived the arc. JR §2 read `CLAUDE.md` whole and wrote nothing. Its Sap reach (*54 sapped hero turns in 946 fights*) is JL's dated reading. **Trigger owed**: none needed beyond the carry.
- `` ### FOUND AT GY AND NOT FIXED `` — ARGUABLY. **NOT ROUTED**: the brief names no design-notes entry. JR's entry stands first, newest first, as GY's ruling asks. Nothing owed.
- `` ### THE CLASS MERGE ~~IS MEASURED AND UNRULED~~ WAS MEASURED AT FP AND IS RULED `` — ARGUABLY. **NOT ROUTED**: it is not a member of the closed-matter population the routing took for §4. Its heading says every step is done, and its size and staging bullets are history no gate holds. §4's condition held at 0.2 batches of room, and JR archived no closed block beyond §0's. **Trigger owed**: `closed blocks`, or membership of *the closed matter*.
- `` ### TWO SYNC DESELECTIONS ARE DISPUTED BETWEEN THE REPO AND A BRIEF `` — ARGUABLY. **NOT ROUTED**: the brief names no sync item. *`docs/reports/` — growing every batch*: JR adds `docs/reports/JR-citations.tsv` (372,970 B) and rewrites 86 reports. Nothing false.
- `` ### THE `master.html` STAMP CAN SIT MANY BATCHES STALE AND PASS `` — ARGUABLY. **NOT ROUTED**: the brief names `docs/master.html` as a document to sweep, not its stamp. JR moved the stamp with its edit. Nothing owed.
- `` ### THE ARCHETYPE TAGS `` — ARGUABLY. **NOT ROUTED**: no trigger names the two closed audits. Its *both are CLOSED (CV / DN) and kept as written* is the true reason `check_jr` holds them at a count. Ruling 2 gives *the brief did not name* and offers sweeping them as the alternative. **Trigger owed**: `rune-audit.html`, `talent-audit.html`.
- `` ### THE RUNE CHARTER `` — ARGUABLY. **NOT ROUTED**: its `rune-audit.html` names JR's work (`check_jr`'s ceilings), not its brief. The page is *generated from the data*, a second reason for ruling 2's ceiling over a hand sweep.

## THE INDEX's UPKEEP

**37 of 165 entries touched** — the tree's index against HEAD's (`tools`: `edits/upkeep.py`), every block JR changed re-stamped by `index_stamp.py --write`.

**ADDED — 2**: `` ### JR's RULINGS OWED ``; `` ### FOUND AT JR AND NOT FIXED ``.

**LEFT — 1**: `` ### JQ's RULINGS OWED `` (the open queue's rulings move to the newest batch's, the core's by role).

**RE-LABELLED OR RE-TRIGGERED, AND RE-STAMPED — 18**: `` ### THE FIRST CLEAN PLAYTHROUGH ``; `` ### THE SHARE CENSUS ``; `` ### FOUND AT JP AND NOT FIXED ``; `` ### FOUND AT JN AND NOT FIXED ``; `` ### FOUND AT JM AND NOT FIXED ``; `` ### FOUND AT JJ AND NOT FIXED ``; `` ### FOUND AT JF AND NOT FIXED ``; `` ### FOUND AT HL AND NOT FIXED ``; `` ### THE CROSS-TARGET SUPERSESSIONS ``; `` ### GY's RULINGS OWED ``; `` ### FOUND AT GL AND NOT FIXED ``; `` ### FOUND AT GB AND NOT FIXED ``; `` ### TWO SMALL DOC REPAIRS FR FOUND AND DID NOT TAKE ``; `` ### THE ARCHETYPE TAGS ``; `` ### THE DRAFT AUDIT ``; `` ### THE THREE PRICING QUESTIONS ``; `` ### Carried, with measurements attached ``; `` ### Carried from the code, reported and deliberately not fixed ``.

**RE-STAMPED ONLY — 17**: `` ## WHERE THE PROJECT IS ``; `` ### THE PLAYTEST'S OTHER FINDINGS ``; `` the claims ``; `` the figures behind doors ``; `` the closed matter ``; `` the positional picks ``; `` the bot's divergences ``; `` the latent shapes ``; `` the save's keys ``; `` the sim's recorded figures ``; `` ### FOUND AT JD AND NOT FIXED ``; `` ### FOUND AT HO AND NOT FIXED ``; `` ### FOUND AT HA AND NOT FIXED ``; `` ### FOUND AT FX AND NOT FIXED ``; `` ### FOUND AT FW AND NOT FIXED ``; `` ### THE CLASS MERGE ~~IS MEASURED AND UNRULED~~ WAS MEASURED AT FP AND IS RULED ``; `` ### **AND FP's `block_chance` FINDING TRAVELS WITH IT `` — each block's text moved under a row whose label and triggers still hold.
