# KF — THE ROUTING OF RECORD

Part of KF's report (`docs/reports/KF.md`). **The subjects and the matches were taken on 2026-11-24 at 14:59:05, before any edit reached a lane** (the first at 15:33:02, `logs/.first_lane_edit` in KF's work folder), with KB's work folder's `tools/route.py`, unchanged — every trigger of every index row matched, word-bounded and case set aside, against the record's subjects.

## THE BRIEF'S SUBJECTS

*The record's (`RECORD_KF.md`: the designer's three asks in conversation, 24 November, after playtesting KE's build), the subjects are KF's reading of what the asks settle. The record of the taking is `route/route.out` and `route/.taken`.*

- **S0** §0 the record: a distinction on the hero name plates between buffs and debuffs; enemies not showing up in their correct zones; a list of every enemy kind and its abilities, delivered in conversation; the look-list notes; the playtest.
- **S1** §1 the plates: the hero's nameplate; the chip row; _refresh_chips; _draw_chip; a status chip and its frame; DEBUFF_IDS; a debuff; a buff; Dispel and _dispellable_buffs; DISPEL_NEVER; a mark; count_debuffs; Iron Will; Broken; a composition, the Rupture; the engine chips; the display chips; the rune chips; the +N chip; the chip's tooltip; the glossary line; the chip tag; Berserk's risk and Formless's recoil; a companion's plate; the enemy's plate.
- **S2** §2 the rosters: ZONE_DEFS; roster 4 and roster 6; the Frozen Plains; the Drowned Barrow; the travelling core; JS's ruling 6; kinds_for_roster; enemies.json and its zones tags; the Orc Chief; an elite node; Honor Guard, Rage Company and Elite Patrol; THEMES; _theme_pick; _role_kinds; Boss Escort; the Hollow Crown; the plain fallback; four to six bodies; the warband digest; JX-rosters.tsv; rosters_before_jx; the Forest of Old and the Scarlands.
- **S3** the words: master.html's rosters and its chip row; the changelog; the design notes; the glossary's buff and debuff; the text standard; the look-list.
- **S4** the sim: battle_budget; DOD_SIM_ZONE; the run sim; the sim tests the code; the bot; a seeded road.
- **S5** out of scope (the record names none): the Orcs shared by the Forest and the Scarlands; the Ash Hurler's zone; a new elite kind; a zone's own art.
- **S6** the open questions (the batch's): which statuses draw as a debuff; whether an enemy's plate is framed; what fields an elite node in the Frozen Plains and the Drowned Barrow, a balance question for the designer.
- **S7** the verification, Lane A's floor: the push check; the routing of record; the blocks' reader; the premises at source; the literal sweep; the documents replayed from HEAD behind a hash guard; the new text's reader and the close-read; a recon; the controls; a new gate; the pin manifest; baselines.json; the subset; the sim; the fresh reader; the freeze; the pre-run of record; the listing gates; the closing block; the landing; the player's files.

## THE ROWS THE TRIGGERS MATCHED — 18

*Each trigger verbatim from its row.*

| block | subjects | the triggers that matched (verbatim from its row) |
|---|---|---|
| `` ### THE FIRST CLEAN PLAYTHROUGH `` | S0 | playtest |
| `` ### THE STAGES `` | S2 | rosters_before_jx |
| `` ### THE FROZEN PLAINS `` | S2 S6 | Frozen Plains; ZONE_DEFS; roster 4 |
| `` ### THE DROWNED BARROW `` | S2 S6 | Drowned Barrow; roster 6 |
| `` ### FOUND AT JX AND NOT FIXED `` | S4 | DOD_SIM_ZONE |
| `` ### FOUND AT JV AND NOT FIXED `` | S2 | _theme_pick |
| `` ### FOUND AT JT AND NOT FIXED `` | S7 | closing block |
| `` ### FOUND AT JS AND NOT FIXED `` | S1 S7 | companion; pin manifest |
| `` ### FOUND AT IK AND NOT FIXED `` | S2 | enemies.json |
| `` ### FOUND AT IE AND NOT FIXED `` | S4 | seeded road |
| `` ### GW's RULINGS OWED `` | S7 | new gate |
| `` ### FOUND AT GP AND NOT FIXED `` | S1 | Formless |
| `` ### FOUND AT GN AND NOT FIXED `` | S7 | baselines.json |
| `` ### FOUND AT GM AND NOT FIXED `` | S1 | DEBUFF_IDS; DISPEL_NEVER |
| `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` | S7 | new gate |
| `` ### THE LADDER `` | S2 | enemies.json |
| `` ### THE TEST TREE, AS OF EF `` | S7 | new gate |
| `` ### FIVE MORE THINGS FH FOUND AND DID NOT FIX `` | S7 | new gate |

## NAMED BY THE RECORD, AND NO TRIGGER HOLDS THE WORDS — 15

*Every section whose words name the chip row, a debuff, the registry, a roster, the travelling core, a warband digest or the sim's figures, outside the rows above and the core, that bears on the build (a search of HEAD's state below its index for those words, by count — `chip`, `debuff`, `roster`, `travel`, `nameplate` — three or more to a block).*

- `` ### FOUND AT KE AND NOT FIXED ``
- `` ### FOUND AT JW AND NOT FIXED ``
- `` ### FOUND AT JR AND NOT FIXED ``
- `` ### FOUND AT JQ AND NOT FIXED ``
- `` ### FOUND AT JZ AND NOT FIXED ``
- `` ### FOUND AT JI AND NOT FIXED ``
- `` ### FOUND AT JH AND NOT FIXED ``
- `` ### FOUND AT IG AND NOT FIXED ``
- `` ### FOUND AT HT AND NOT FIXED ``
- `` ### THE WARBAND's HEXES ``
- `` ### THE WARBAND's SPENDS ``
- `` ### THE CROSS-TARGET SUPERSESSIONS ``
- `` ### THE SIM's FIGURES, RE-TAKEN AT IW ``
- `` ### FOUND AT JU AND NOT FIXED ``
- `` ## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND ``

## THE CORE — 15, READ WHOLE

- `` ## WHERE THE PROJECT IS ``
- `` ## THE OPEN QUEUE ``
- `` ### KE's RULINGS OWED ``
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

**18 matched by a trigger** (the table above), **15 named by the record in words no trigger holds**, and **the core's 15** — 48 blocks (`route/blocks.md` in KF's work folder; 168,873 B of the state's 470,006).

## OPENED

The 48, whole, cut from HEAD's state (`route/blocks.md`) before the first edit, and read by KF's blocks' reader against the plan (`report/blocks_reader.md`); the close-read and the new text's reader read the edits against them.

## NEEDED

Of the opened blocks, these bore on the work and were edited: the WHERE; KE's RULINGS OWED (the core's role moved to KF's, and KE's took an ordinary row); THE STAGES, THE FROZEN PLAINS and THE DROWNED BARROW (the rosters since KF, JS's ruling 6 marked retired, the Sap paragraph); FOUND AT JX (the Orc Brute's roster 6, until KF) and FOUND AT JS (the Titan's escort and its Sap carrier, until KF); TO WATCH IN PLAY (the frames' and the zones' rows); THE PLAYTEST'S OTHER FINDINGS (the look-list: the designer's verdicts of 24 November, thirteen rows archived, the two NOT YET marked, KF's two rows). The rest were read and bore on nothing KF changed (the blocks' reader's findings, `report/blocks_reader.md`).

## FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED

Fourteen, from the close-read (`report/close_read.md` in KF's work folder: the blocks KF did not open, with the preamble and the index, 301,195 B):

- `` ### FOUND AT HO AND NOT FIXED `` — NOT ROUTED (its row says *Cleanse Debuffs talent*; KF's subjects say *a debuff* and the plan *what a cleanse lifts*): its Bleed-chip item annotated (the chip reads *Debuff: Bleed* since KF, and the draught refuses it); KF's readings 1 and 3 re-worded — a debuff is the registry, not a promise of a cleanse; the row gains *Bleed warning chip* and *_cleansable_debuffs*.
- `` ### THE WARBAND's COOLDOWNS `` — NOT ROUTED (its row names *Chieftain's Maul*, not *Orc Chief*): the Maul's held band named beside the balance question's option (a); the row gains *Orc Chief*.
- `` ### FOUND AT JO AND NOT FIXED `` — NOT ROUTED: the same held band (JO's ruling 2); the row gains *Orc Chief*.
- `` ### FOUND AT JN AND NOT FIXED `` — NOT ROUTED: the Shaman's content hole named beside option (a); the row gains *Orc Shaman* and *mender*.
- `` ### THE BARGAIN DECK's GRADES `` — NOT ROUTED (its row has no word for a roster): its chain of the sim's recorded figures takes no link — FOUND AT KF holds KF's; the population row *the sim's recorded figures* gains *roster change* and *what a zone fields*.
- `` ### THE RULES A GATE COULD CHEAPLY HOLD `` — NOT ROUTED: S4-177 and S2-090 re-read HELD with `check_kf`, KF-001 and KF-002 written, the tally and the list's counts moved (185 and 74); S2-178, S4-176 and S2-168 named not taken (FOUND AT KF); the row gains *DEBUFF_IDS* and *roster*.
- `` ### FOUND AT IQ AND NOT FIXED `` — NOT ROUTED (its row has *Formless chip recoil*): the Formless chip's false words annotated, and named in FOUND AT KF; the row gains *Formless*.
- `` ### THE REST `` — NOT ROUTED (its row has *seeded fight*): `check_gj`'s sanctioned red read at the recon (§5); the row gains *seeded road*.
- `` ### FOUND AT FX AND NOT FIXED `` — NOT ROUTED: the display chips' names stand, each since KF leading *Buff:*; the row gains *Iron Will* and *display chip*.
- `` ### FOUND AT IT AND NOT FIXED `` — NOT ROUTED: the threshold lock's dead constant stands beside its new census row; the row gains *threshold_lock*.
- `` ### THE SHARE CENSUS `` — NOT ROUTED: its sort by `DEBUFF_IDS` and `DISPEL_NEVER` files the five costs as paying the heroes — not re-taken, named in the report; the row gains *DEBUFF_IDS*.
- `` ### THE WARBAND's MALICE `` — NOT ROUTED: the Barrow's healer population moves with its menders gone, the balance question's; the row gains *mender*.
- `` ### FOUND AT HS AND NOT FIXED `` — NOT ROUTED: `status_cut` reads a composition through its parts, the shape the item asks; nothing stale; the row gains *composition*.
- `` ### FOUND AT HZ AND NOT FIXED `` — ROUTED (its *boil_over status* and *Boil Over* triggers match the work after the blocks' reader added the cost, not the subjects written before): its item annotated — since KF the plate classes it a Cost.

## THE INDEX's UPKEEP

**29 of 169 entries touched**: two new (FOUND AT KF, and KE's RULINGS OWED as an ordinary row); the core's RULINGS OWED re-pointed to KF's; labels or triggers mended on fifteen — the population row *the sim's recorded figures*, THE SHARE CENSUS, THE WARBAND's COOLDOWNS, THE WARBAND's MALICE, THE FROZEN PLAINS, THE DROWNED BARROW, FOUND AT JO, FOUND AT JN, THE RULES A GATE COULD CHEAPLY HOLD, FOUND AT IT, FOUND AT IQ, FOUND AT HS, FOUND AT HO, FOUND AT FX and THE REST (the close-read's NOT ROUTED rows, and the two zones' *travelling core*); the other eleven re-stamped for their blocks' changes (the WHERE, THE PLAYTEST'S OTHER FINDINGS, TO WATCH IN PLAY, four population rows whose members moved, THE STAGES, FOUND AT JX, FOUND AT JS and FOUND AT HZ).

