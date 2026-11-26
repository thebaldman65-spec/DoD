# KH — THE ROUTING OF RECORD

Part of KH's report (`docs/reports/KH.md`). **The subjects and the matches were taken on 2026-11-25 at 19:38:16, before any edit reached a lane** (`logs/.first_lane_edit` in KH's work folder, the first lane built after it), with KB's work folder's `tools/route.py`, unchanged — every trigger of every index row matched, word-bounded and case set aside, against the record's subjects.

## THE BRIEF'S SUBJECTS

*The record's (`RECORD_KH.md`: the designer's ask and four answers in conversation, 25 November, after KG's close), the subjects are KH's reading of what the asks settle. The record of the taking is `route/route.out` and `route/.taken`.*

- **S0** §0 the record: the designer's ask, the Orcs to the Scarlands and enemies for the Forest of Old; four answers with options — the Orcs' companions, the seven kinds, the figures, the damage type and resists; KG's content question; KF's reading 6; the Forest and the Scarlands sharing their Orcs; the Ash Hurler's zone; KG's RULINGS OWED.
- **S1** §1 the kinds: seven new kinds; a new elite kind; the Orc Chief's figures; Chieftain's Maul; the Orc Whelp; the Wolfrider; the Orc Archer; the Orc Shieldmaster; the Orc Shaman; the Orc Hexer; Shielding; Healing Wave; Entrench; Rally; Gall; Poison Arrow; Sap; Exposed; a held band; HELD; TUNED; the line; JI's line; dmg_type; a damage type; nature; resists; a weakness; fire; check_ht §3; a tint; the orc sheet; Enemies.config; enemies.json; ADDED_SINCE; a new kind; the warband digest; the spend bands; check_jk §2; the reference board.
- **S2** §2 the rosters: ZONE_DEFS; roster 1; roster 2; the Forest of Old; the Scarlands; the travelling core; the ten Orc kinds; the Orc Totemist; the Rot Behemoth; the Grave Totem; the Ash Hurler; the Bog Troll; the Withered Warden; kinds_for_roster; an elite node; Honor Guard; Rage Company; Elite Patrol; Ritual; Lightning Storm; Swarm; Poison Volley; Cursed Company; Guardian Circle; Monster Den; THEMES; _theme_pick; the composer; a mender; the Hollow Crown; Boss Escort; JX-rosters.tsv; the zone rule; check_kf §2; check_kg; the first fight; the tutorial.
- **S3** the words: master.html's enemy roster and its zones; the changelog; the design notes; the text standard; the enemy list; the look-list; the Forest's events.
- **S4** the sim: battle_budget; DOD_SIM_ZONE; the run sim; the sim tests the code; the bot; a seeded road; check_gp; check_go; check_gj; the Bell.
- **S5** out of scope (the record names none): a zone's own art; enemy art; the turn bar's NOT YET; the Drowned Barrow's look-list row.
- **S6** the open questions (the batch's): the kinds' names, tints and moves' names, as shown to the designer; a copy's held band; the Grove Tender's Entrench; the Bristleback's Rally; the Huntmaster's Maul; the runs that draw no Scarlands and meet no Orc.
- **S7** the verification, Lane A's floor: the push check; the routing of record; the blocks' reader; the premises at source; the literal sweep; the documents replayed from HEAD behind a hash guard; the new text's reader and the close-read; a recon; the controls; a new gate; the pin manifest; baselines.json; the subset; the sim; the fresh reader; the freeze; the pre-run of record; the listing gates; the closing block; the landing; the player's files.

## THE ROWS THE TRIGGERS MATCHED — 25

*Each trigger verbatim from its row.*

| block | subjects | the triggers that matched (verbatim from its row) |
|---|---|---|
| `` ### THE WARBAND's COOLDOWNS `` | S1 S6 | TUNED; HELD; Chieftain's Maul; Orc Chief |
| `` ### THE WARBAND's MALICE `` | S2 | mender |
| `` ### THE WARBAND's SPENDS `` | S1 | spend bands |
| `` ### THE WARBAND's HEXES `` | S1 | Gall; Sap; Orc Hexer; Orc Archer |
| `` ### THE FROZEN PLAINS `` | S1 S2 | ZONE_DEFS; reference board; travelling core |
| `` ### THE DROWNED BARROW `` | S2 S5 | Drowned Barrow; travelling core |
| `` ### FOUND AT JX AND NOT FIXED `` | S4 | DOD_SIM_ZONE |
| `` ### FOUND AT JV AND NOT FIXED `` | S2 | _theme_pick; composer |
| `` ### FOUND AT JT AND NOT FIXED `` | S7 | closing block |
| `` ### FOUND AT JS AND NOT FIXED `` | S7 | pin manifest |
| `` ### FOUND AT JO AND NOT FIXED `` | S1 | Orc Chief |
| `` ### FOUND AT JN AND NOT FIXED `` | S1 S2 | Orc Shaman; mender |
| `` ### THE RULES A GATE COULD CHEAPLY HOLD `` | S2 S3 | roster |
| `` ### FOUND AT IK AND NOT FIXED `` | S1 | enemies.json |
| `` ### FOUND AT IE AND NOT FIXED `` | S4 | seeded road |
| `` ### THE CROSS-TARGET SUPERSESSIONS `` | S1 | ADDED_SINCE |
| `` ### GW's RULINGS OWED `` | S7 | new gate |
| `` ### FOUND AT GN AND NOT FIXED `` | S7 | baselines.json |
| `` ### THE CLASS MERGE ~~IS MEASURED AND UNRULED~~ WAS MEASURED AT FP AND IS RULED `` | S1 | dmg_type |
| `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` | S7 | new gate |
| `` ### THE LADDER `` | S1 | enemies.json |
| `` ### THE TEST TREE, AS OF EF `` | S7 | new gate |
| `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` | S4 | check_gj |
| `` ### THE REST `` | S4 | seeded road |
| `` ### FIVE MORE THINGS FH FOUND AND DID NOT FIX `` | S7 | new gate |

## NAMED BY THE RECORD, AND NO TRIGGER HOLDS THE WORDS — 8

*Every section that bears on the build outside the rows above and the core: KG's and KF's rulings, FOUND AT KG and KF, and the blocks whose words name the Forest of Old, the Scarlands, an Orc, a roster, the Wolfrider, the Ash Hurler, the Rot Behemoth, the Grave Totem, the Bog Troll, the Withered Warden or the travelling core three or more times (a search of HEAD's state, `tools/route_cut.py list`, in KH's work folder), the routed ones aside.*

- `` ### KF's RULINGS OWED ``
- `` ### FOUND AT KG AND NOT FIXED ``
- `` ### FOUND AT KF AND NOT FIXED ``
- `` ### THE STAGES ``
- `` ### FOUND AT JW AND NOT FIXED ``
- `` ### FOUND AT JU AND NOT FIXED ``
- `` ### FOUND AT JR AND NOT FIXED ``
- `` ### WHAT THE RAISE DID ``

## THE CORE — 15, READ WHOLE

- `` ## WHERE THE PROJECT IS ``
- `` ## THE OPEN QUEUE ``
- `` ### KG's RULINGS OWED ``
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

**25 matched by a trigger** (the table above), **8 named by the record in words no trigger holds**, and **the core's 15** — 48 blocks (`route/blocks.md` in KH's work folder; 186,190 B of the state's 488,933).

## OPENED

The 48, whole, cut from HEAD's state (`route/blocks.md`, before any lane was built), and read by KH's blocks' reader against the plan (`report/blocks_reader.md`); the close-read and the new text's reader read the edits against them.

## NEEDED

Of the opened blocks, these bore on the work and were edited: the WHERE; KG's RULINGS OWED (its item 0's content question answered, struck in place and archived, item 1's zones; the core's role moved to KH's, and KG's took an ordinary row); KF's RULINGS OWED (item 0's pointer, item 6 marked superseded); THE STAGES (one roster a zone, and what JX's replay table holds); THE FROZEN PLAINS and THE DROWNED BARROW (the Orcs and the Chief since KH, the rosters, the board); THE WARBAND's COOLDOWNS (KH's seven cooling blows in the span `check_ji` §1f reads, the heals' multiples on the board moved back, the held bands, the third hand-tune, DIAL 2's seven); THE WARBAND's SPENDS (the holders, the board's worths, the seven's bands); THE WARBAND's HEXES (the copies' carriers); FOUND AT JN (the content hole's sixth and seventh); TO WATCH IN PLAY and THE PLAYTEST'S OTHER FINDINGS (the Forest's rows); THE CROSS-TARGET SUPERSESSIONS (KH's row); THE LADDER (its count); THE RULES A GATE COULD CHEAPLY HOLD (the tally, KH-001). The rest were read and bore on nothing KH changed.

## FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED

Four, from the close-read (`report/close_read.md` in KH's work folder: the 115 blocks KH did not open, with the preamble and the index, 302,695 B):

- `` ### THE BARGAIN DECK's GRADES `` — ROUTED through the population row *the sim's recorded figures* (its triggers *roster change* and *what a zone fields* name KH §1; KH's subjects worded it *the rosters*, *roster 1* and *roster 2*), its own row NOT ROUTED: the ENCUMBERED bullet's chain of stale sim figures takes KH's link.
- `` ### THE SHARE CENSUS `` — ROUTED through the same population row: its tally of cooling moves and spends takes KH's seven blows and seven spends.
- `` ### FOUND AT JL AND NOT FIXED `` — NOT ROUTED: its count of spends keeping a `delay` key takes KH's seven (49); the row gains *new kind*.
- `` ### FOUND AT KE AND NOT FIXED `` — NOT ROUTED: the Warden's Shielded stack names the Heartwood Sentinel's beside the Shieldmaster's; the row's *Entrench stack* becomes *Entrench Shielded stack*.

FOUND AT JO's count of kinds under Attack 100, read in passing in a block KH opened, was mended too.

## THE INDEX's UPKEEP

**24 of 173 entries touched** (171 at KG): three new — the core's row re-pointed to KH's RULINGS OWED, KG's RULINGS OWED as an ordinary row, and FOUND AT KH; labels or triggers mended on three — KF's RULINGS OWED (*the Orcs at home*, superseded at KH), FOUND AT KE (*Entrench Shielded stack*) and FOUND AT JL (*new kind*), the close-read's NOT ROUTED rows; the other eighteen re-stamped for their blocks' changes (the WHERE, THE PLAYTEST'S OTHER FINDINGS, TO WATCH IN PLAY, two population rows whose members moved, THE BARGAIN DECK's GRADES, THE SHARE CENSUS, the three WARBAND blocks, THE STAGES, THE FROZEN PLAINS, THE DROWNED BARROW, FOUND AT JO, FOUND AT JN, THE RULES A GATE COULD CHEAPLY HOLD, THE CROSS-TARGET SUPERSESSIONS and THE LADDER). `index_stamp.py docs/state.md --write` at the build, every row at or under 400 B.

