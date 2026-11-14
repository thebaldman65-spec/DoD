# JW — THE ROUTING OF RECORD

Part of JW's report (`docs/reports/JW.md`). **The subjects and the matches were taken on 2026-11-14 at 02:25–02:26, before any edit reached a lane** (the first at 03:08:36, `logs/.first_lane_edit` in JW's work folder), with `tools/route.py` — every trigger of every row, matched case set aside and bounded by word against the subjects below — and judged by hand where a trigger names a subject in other words; this file is written from them. The file read is HEAD's `docs/state.md` (`b38bf2d`, 170 entries: 146 rows, 15 core, 9 population rows). **That list and the core is what JW opened, the core whole**, and a blocks' reader outside the working read read the same 42 blocks against the record and the plan, its findings written at 03:03, before the first edit reached a lane (JW's report, §4).

## THE BRIEF'S SUBJECTS

*The record's, in its own sections (`RECORD_JW.md`, md5 `f3d233a0…`).*

- **S0** §0 JV's rulings and a standing design value: JV's three rulings accepted as taken (the draw spending the same die; the list staying as the two gates' door; where the recon clause and the two habits landed) — JV's RULINGS OWED; a new standing design value set 14 November, every boss fight has a strategy specific to it, the Drowned Barrow's boss the first built to it, the Withered Warden, the Ash Tyrant and the Icewrought Titan to be revisited the same way and not touched here, placed by `CLAUDE.md`'s seam as JT placed the lane rules; `Run.advance_zone` gets its own guard, and the gate — derive the callers of `advance_zone(` in `scripts/` and red on one whose function does not ask `has_next_zone` before the call (JT §0's description), FOUND AT JS closes.
- **S1** §1 the Drowned Barrow, a fourth zone and the first candidate for slot 2, which has only ever held the Scarlands; its signature the dead get back up, on the Raise machinery JK shipped; its backdrop a named placeholder, as JS gave the Frozen Plains the Forest's art; JU's four move into it — the Mossback, the Blight-Speaker, the Grave Husk and the Carrion Pack — the rosters closing at 20, 17, 19, 16, 19 (JU §2), moving them taking roster 1 to 18 and roster 3 to 17; moving a kind adds no kind, so it costs the two gates that still list (`check_jr` §1, `check_js` §1).
- **S2** §2 the Bone Shepherd, the boss, a pure damage check — burst him down or lose to attrition, because he raises his dead; Soul Leech its basic, moderate damage healing him half the damage dealt, the heal drawing on Malice so healing and raising compete for one bar, a long fight filling the bar his win condition, the rate Q2; Call the Drowned raising one fallen ally on JK's Raise; Noxious Fumes, the whole party's chance to hit down 25% for 3 turns, renamed from Choking Miasma because Miasma is an existing status.
- **S3** §3 two new kinds: the Rotfiend — Claw its basic; Rake, small damage and one stack of Black Rot; Corpse Explosion, the Rotfiend dies, every hero takes a stack of Black Rot, one adjacent warband ally healed 15% of its own maximum health, closing the zone's loop with Call the Drowned; the Fen Lurker — Swipe its basic, damage to two heroes; Lacerate, moderate damage and 20 bleed; Submerge, untargetable 3 turns or until it acts, renamed from Mire Beast because Mire is one of the four hexes; Black Rot, a stacking disease, 1% of the target's own health a turn, a stack every application, never expiring, cleansed as Fester is; untargetability new machinery, every path that picks a target respecting it.
- **S4** out of scope: no other boss touched; no zone event of its own (the Forest has two keyed to it, the Frozen Plains none); no art beyond the placeholder backdrop, the kinds tinted orcs; no balance drive, win rate, prediction or grade re-read, a figure derivable off an existing rule set by the derivation and printed; `check_jr` §1 and `check_js` §1 not moved onto counts (JV's ruling 2); no new status that cuts or slows beyond what is named; carried, not closed: the second forest boss, the Titan `boss`-tagged in rosters 4 and 5 (S2-090), the Sleetveil Matron's heal never fired, the Titan's Entomb cast once and missed, the sim figures read on a road no longer the default; the state's ceiling stays at 520 KiB.
- **S5** the open questions, both branches decided: Q1 whether a slot-2 zone takes one roster or a pair and whether a new roster inherits a travelling core, the closing kind count printed for every roster; Q2 the Shepherd's heal priced at the rate the game already uses, Malice filling a point per ten damage and a warband heal costing a Malice a point (JJ, JK); Q3 a name sweep of Noxious Fumes, Fen Lurker, Rotfiend, Black Rot, Soul Leech, Call the Drowned, Claw, Rake, Corpse Explosion, Swipe, Lacerate and Submerge three ways as JQ's rename and JU's §1 did, the Rot Behemoth and Bone Rattle expected near-misses, the tints flagged; Q4 whether a chance to hit exists that a debuff can reduce, else the nearest lever the data carries; Q5 whether a status deals a share of maximum health a turn or stacks on reapplication — Poison, Fester — Black Rot built on that machinery; Q6 whether 20 bleed is an existing status, a bleed or a flat damage over time; Q7 whether adjacent means anything for warband bodies, the positions enemies hold; Q8 whether a warband body can take no action, the picker passing, and what stops a fight stalling when every living enemy is untargetable; Q9 how many slots a boss's kit holds; Q10 whether `advance_zone`'s guard changes a seeded road, every seeded row re-rolled with the old figure beside the new.
- **S6** the verification, Lane A's whole floor: the push check; the routing before any edit; the blocks' reader; the premises at source; the literal sweep; the documents replayed from HEAD behind a hash guard; the new text's reader and the close-read; a recon; the pre-run; a new gate; all the positional reads; the controls; the fresh reader on the assembled report; the acceptance only where an edit lands after the pre-run; the landing; the two ceiling readings and the projection for JX; the report's closing block, WHAT THE NEXT DECISION RECORD OWES.

## THE ROWS THE TRIGGERS MATCHED — 17

*Each trigger verbatim from its row; a trigger marked † matched by hand, naming the subject in other words.*

| block | subjects | the triggers that matched (verbatim from its row) |
|---|---|---|
| `` ### THE WARBAND's COOLDOWNS `` | S1 S3 S4 | Entomb; 1.4x line †; line_blow †; Break price † |
| `` ### THE WARBAND's MALICE `` | S2 S5 | Malice; warband heal |
| `` ### THE WARBAND's SPENDS `` | S2 S3 | Malice spend †; _raise_holds †; raised body † |
| `` ### THE WARBAND's HEXES `` | S3 S5 | Mire; Fester; Bone Rattle |
| `` ### THE FROZEN PLAINS `` | S0 S1 S4 | Frozen Plains; Icewrought Titan; Entomb; Sleetveil Matron; SLOT_POOLS †; ZONE_DEFS †; draw_zones † |
| `` ### FOUND AT JV AND NOT FIXED `` | S1 S4 | kinds a roster holds †; check_jr 1 list †; check_js 1 list † |
| `` ### FOUND AT JU AND NOT FIXED `` | S1 | Grave Husk; Mossback; Blight-Speaker; Carrion Pack |
| `` ### FOUND AT JT AND NOT FIXED `` | S6 | closing block |
| `` ### FOUND AT JS AND NOT FIXED `` | S0 S4 S5 | advance_zone; has_next_zone; name sweep; S2-090 |
| `` ### FOUND AT JR AND NOT FIXED `` | S1 | the draw; how often a kind appears † |
| `` ### FOUND AT IE AND NOT FIXED `` | S5 | seeded road |
| `` ### FOUND AT JQ AND NOT FIXED `` | S3 | sticky status †; dispel_one_debuff † |
| `` ### FOUND AT JO AND NOT FIXED `` | S3 | unpriced statuses †; Fester growth †; DoT tick rounding † |
| `` ### FOUND AT JL AND NOT FIXED `` | S2 S3 | unpriced enemy debuffs †; hex uptime † |
| `` ### FOUND AT JK AND NOT FIXED `` | S2 | raise cap †; second kill † |
| `` ### FOUND AT JJ AND NOT FIXED `` | S2 | warband healing a fight †; heal float † |
| `` ### GW's RULINGS OWED `` | S6 | new gate |

## NAMED BY THE RECORD, AND NO TRIGGER HOLDS THE WORDS — 10

- `` ### FOUND AT IO AND NOT FIXED `` — *enemy kit order*, *`_cheapest_attack`* (Q9: what a boss's kit holds; the Rotfiend's kit order).
- `` ### FOUND AT IH AND NOT FIXED `` — *map and event background* (S1's backdrop).
- `` ### FOUND AT HT AND NOT FIXED `` — *purge Bleed chip*, *Poison clock reset* (Q6's Bleed on a hero; Black Rot's stack on Fester's branch).
- `` ### FOUND AT HS AND NOT FIXED `` — *log_bleed_chip* (Q6).
- `` ### THE LADDER `` — *enemies.json rung tag*, *compose floor* (a new roster's composition).
- `` ### THE BOSS-PICK POOLS `` — *zone-boss award fallback* (the Shepherd's node pays the award as every zone boss's).
- `` ### THE SEVENTH FAMILY, FOUND AT DM AND DELIBERATELY NOT SWEPT `` — *enemy description* (the new moves' descriptions).
- `` ### THE TEST TREE, AS OF EF `` — *new gate rows*, *run_battery.sh GATES* (`check_jw`).
- `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` — *new gate* (`check_jw`'s needles).
- `` ### FIVE MORE THINGS FH FOUND AND DID NOT FIX `` — *new gate*, *check_map not a hang* (a new roster in the map gate).
- *And the population row* **the target picks** (`#ba7c5e`) is named by hand for S3's untargetability — its lives-in blocks (FOUND AT IJ, HF, GN, IM) were read at the close; the pick census of record is JW's own (`docs/reports/JW-picks.tsv`).

## MATCHED ON AN ORDINARY WORD, AND NOT OPENED — 4

- `` ### THE ARC, READ WHOLE `` — *Miasma* (the record names Miasma — a bargain, which it called a status — as the name its rename avoided; the block holds the arc's readings, which JW does not touch).
- `` ### GO's RULINGS OWED `` — *Leech* (the rule engine *the Leech*; Soul Leech is a warband move's name, flagged as a near-miss by Q3's sweep).
- `` ### GN's RULINGS OWED `` and `` ### FY §1: THREE NODES PAID BY WHO ELSE HELD THEM, AND TODAY'S COUNT DOUBLES FOUR ITEMS `` — *name sweep* (the blocks hold their own sweeps' rulings; JW's sweep is Q3's).

## THE POPULATION ROWS THE TRIGGERS MATCHED — 1, AND TWO NAMED BY HAND

**The sim's recorded figures** matched *sim figures* (S4's carried item): opened on Q10's branch — the zone's draw spends a third die at a run's start, so every seeded road moves (JW §6). **Named by hand**: *the target picks* (above) and *the latent shapes* (`#bc26ad`), whose row names FOUND AT JS's `advance_zone` as its one member not armed — JW arms it and the row's clause goes.

## THE CORE — 15, READ WHOLE

- `` ## WHERE THE PROJECT IS ``
- `` ## THE OPEN QUEUE ``
- `` ### JV's RULINGS OWED ``
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

**17 matched by a trigger** (the table above), **10 named by the record in words no trigger holds**, and **the core's 15** — 42 blocks, 140,720 B of HEAD's state, cut whole (`route/blocks.md` in JW's work folder; the open queue's own preamble alone, its children each their own block).

## OPENED

The 42, whole; the blocks' reader read the same 42 against the record and the plan, its findings written at 03:03, before the first edit reached a lane at 03:08.

## NEEDED

**Twenty-one of the 42 opened, each for what JW did with it:**
- `` ## WHERE THE PROJECT IS `` — rewritten; its *WHAT STANDS* and *Phase.* lines carried over by script, *WHAT STANDS*'s *no kind moved* mended (JU's four moved roster); its readings lines and projection read by gates (the blocks' reader named them).
- `` ### JV's RULINGS OWED `` — closed by the record, archived word for word, its head struck; JW's written where it stood, the first RULINGS OWED in the file.
- `` ### RULED AND NOT BUILT `` — the three older zone bosses' strategies and the end boss's, RULED, NOT BUILT.
- `` ### FOUND AT JS AND NOT FIXED `` — the `advance_zone` item closed and archived; the older build's save, the seeded roads (Q10's two causes) and S2-090 (the Shepherd beside the Titan) given what JW changed.
- `` ### FOUND AT JV AND NOT FIXED `` — *the swamp's kinds reach them* mended: roster 6 is listed by neither gate.
- `` ### FOUND AT JU AND NOT FIXED `` — the Carrion Pack's roster, 6 since JW.
- `` ### THE FROZEN PLAINS `` — its heading's four shapes, *the Scarlands keeps slot 2 alone*, the slot-dealt events, the boss tally, the travelling core and rosters 1 and 3's shares, each mended.
- `` ### THE WARBAND's COOLDOWNS `` — the Barrow's three at the line's band; JU's four named the Barrow's; Call the Drowned's hold.
- `` ### THE WARBAND's MALICE `` — the two heals that ride blows, through the one door.
- `` ### THE WARBAND's SPENDS `` — every kind holds one: the Rotfiend's and the Fen Lurker's Rally, the Shepherd's Raise and Rally.
- `` ### THE LADDER `` — the enemy ability count, 122 since JW's three.
- `` ### TO WATCH IN PLAY `` — the Barrow's figures, the designer's to tune in play.
- `` ### THE PLAYTEST'S OTHER FINDINGS `` — the LOOK-LIST's row for the Barrow.
- `` ### THE WARBAND's HEXES ``, `` ### FOUND AT JO AND NOT FIXED ``, `` ### FOUND AT JL AND NOT FIXED ``, `` ### FOUND AT JK AND NOT FIXED ``, `` ### FOUND AT JJ AND NOT FIXED `` — read for Black Rot's machinery, Returned Burden, the unpriced riders, the Raise's policy and the paid heals; what they bear on is in FOUND AT JW, the blocks unedited.
- `` ### FOUND AT IE AND NOT FIXED `` — the seeded road: Q10's answer (JW §6).
- `` ### THE TEST TREE, AS OF EF `` and `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` — `check_jw`'s rows and its needles.

**Read and needing nothing**: FOUND AT JT (the closing block, JW's report carries it), FOUND AT JR, FOUND AT JQ, FOUND AT IO, FOUND AT IH, FOUND AT HT, FOUND AT HS, THE BOSS-PICK POOLS (a zone boss's award reads `is_boss`, the Shepherd's too), THE SEVENTH FAMILY, FIVE MORE THINGS FH FOUND AND DID NOT FIX, GW's RULINGS OWED, and the core's other ten.

## FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED

- `` ### THE BARGAIN DECK's GRADES `` — *sixty-three of the warband's moves cool now*, a count false since JU (71 cooling warband moves at HEAD, the blocks' reader's count) and lengthened by JW's; made a pointer to THE WARBAND's COOLDOWNS, inside `check_ji` §2's 400-character window. **NOT ROUTED** — no trigger named a JW subject, and none is added: the row stands at 397 B against `check_is` §5's 400.
- `` ### FOUND AT IT AND NOT FIXED `` and `` ### FOUND AT IS AND NOT FIXED `` — the standing picks, twelve made eleven: JW touched `check_hy.gd` (`_black_rot_tick`'s row in §6's damage census), whose §6 trap-spring read stood as a MISSES row, and `check_iu` §5 reds a touched target whose row still stands — the documents' subset found it; repaired at JW §3 (the whole call read to its closing parenthesis) and the census row marked so. **NOT ROUTED** — the touch came from positional reader A's finding, after the routing.

## THE INDEX's UPKEEP

**34 of 172 entries touched**, each row re-read against its block and re-stamped (`index_stamp.py --write`): **the core** — the WHERE's stamp, its rulings row re-pointed from JV's to JW's, and RULED AND NOT BUILT, THE PLAYTEST'S OTHER FINDINGS and TO WATCH IN PLAY re-stamped under their mended blocks; **the rows** — THE DROWNED BARROW's and FOUND AT JW's added, FOUND AT JS's trimmed of `advance_zone` (its item closed and archived), THE FROZEN PLAINS, THE WARBAND's COOLDOWNS, MALICE and SPENDS, THE LADDER, THE SHARE CENSUS, THE BARGAIN DECK's GRADES, THE CROSS-TARGET SUPERSESSIONS and FOUND AT JV, JU and JI re-stamped under their mended blocks, FOUND AT IT's label made *11 picks* (`check_hy` §6's trap springs repaired), and FOUND AT JN, FOUND AT JM, THE RULES A GATE COULD CHEAPLY HOLD, GO's RULINGS OWED, GJ's RULINGS OWED, FOUND AT GJ, *Small, and still owed* and *Named by the designer, carried from CX* given the triggers the close-read found missing (*new enemy status*, *damaging special*, *enemy self-cast, S2-046*, *_mark_destination*, *boss strategy* twice, *new _apply_status site*, *new enemy debuff*); **the population rows** — the target picks given JW's census of record, `check_jw` §4 and *_pickable, submerged*, the latent shapes' `advance_zone` member made *armed since JW* (`check_jw` §5), and the bot's divergences, the sim's recorded figures, the figures behind doors and the positional picks re-stamped over their members. The 170 entries are 172.
