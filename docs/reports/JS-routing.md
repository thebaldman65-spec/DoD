# JS — THE ROUTING OF RECORD

Part of JS's report (`docs/reports/JS.md`). **Written before the work began** (the subjects and the matches on 2026-11-09, before any edit): the brief's subjects, the index rows whose triggers name them — each with the trigger that matched, verbatim from its row — the population rows whose triggers name a subject, the blocks those population rows add, a block the brief names that no trigger reaches, and the core. **That list, the block the brief names and the core is what JS opens, the core whole.** The file read is HEAD's `docs/state.md` (`2d603b5`, 165 entries: 141 rows, 15 core, 9 population rows).

## THE BRIEF'S SUBJECTS

- **S0** §0 the state's ceiling to 520 KiB with its reason, written where the ceiling is set (HY, the preamble's sentence `check_fg` §4 reads), the routing bounding what a batch reads (JR read 286,191 B of 449,926), 5.6 batches at JG's 14,605 B; the archive's method untouched, archive what §0's rulings close; `CLAUDE.md` stays at 510; and JR's five rulings (the three carriers' tags, the sweep's reach, a citation's tree, a trigger met by the row's own, the look-list rows passed) accepted as taken as housekeeping, one line each, struck to the archive, the core's role passing to JS's.
- **S1** §1 the zone, THE FROZEN PLAINS: `ZONE_DEFS` gains it, boss `icewrought_titan`, two rosters (one for slot 1, one for slot 3, as the forest carries `{1: 1, 3: 3}`), the next two roster ids; `SLOT_POOLS` gains it at slots 1 and 3; `SLOT_COUNT` stays 3, eleven tiers, the talent economy of ~35 points a run, never a fourth slot; which existing kinds join its rosters, derived (every kind tagged for all of 1, 2 and 3 — the universal core — takes both; a zone-exclusive kind does not travel, the Ashblade the Scarlands'); a roster fields four to six bodies; the opener roster takes §2's three opener kinds, the finale all six; `zone_name` keys in the battle and map background dicts, a placeholder backdrop named on the LOOK-LIST, no crash on a missing key; premises: a fifth thing keyed on the zone count or a zone id (a save key, a wipe-table band, an achievement, the recap), and whether `DOD_ZONE_ROTATION` should be on now a pool holds two (the fixed-first-candidate order; the zone rotation; `draw_zones`; a zone no player can draw).
- **S2** §2 six new enemy kinds, JSON blocks, tint and scale over the orc sheet, no art: frost resistance, a fire weakness, slower and more armoured; no new status (Chilled, Rime, Frostbind, Glacial Hold, Bitter Cold, Frostbite are the player's; the duplicate-effect failure JL paid for); long fights, the warband's Malice economy; the opener's Frostbitten Thrall (skirmisher, power 1, damage, Slowed, Rally), Icebound Bulwark (bulwark, 2, tank, the highest armour, a Break move, Entrench), Hailcaster (sniper, 1, damage, Dazed over an area, Rally); the finale's Rimehorn (brute, 3, damage, a telegraphed charge, heavy Break, Rally), Hoarfrost Warden (mender, 2, support, a heal, Raise), The Stillwrought (hexer, 2, support, Sap, Entrench); each basic off its role's Attack (Damage 100, Tank 75, Support 50, `damage` a percentage — Hex Bolt's 44 at 50 prices 22); each second move clearing JI's 1.4× line with Break in the sum, as JN §1 and JO §1 did; every cooldown banded off the rule; a kept `.tsv`; the Warden's heal at one Malice a point restored since JJ (a warband heal); Sap's second carrier, Sap at 0.15% and the Orc Hexer in 2 of JQ's 56, and what JR's tag and this carrier do together; the roles system enrolling each in encounter themes (`bulwark`, `mender`), which themes each now appears in.
- **S3** §3 the zone boss, THE ICEWROUGHT TITAN, a controller that freezes a hero: `frozen` a hard-control id beside `stunned` in `_apply_status`'s head, Ironclad refusing it by name; a basic, a move laying `frozen` on one hero, a Malice spend, its cooldown banded on the 1.4× line; the name swept three ways (BR §1's sweep; *wrought* shared with the Ash-Wrought Tyrant, the zone bosses as a set with the Withered Warden); premises: what `frozen` does to a hero (turns lost, defences, ends early on damage, the chip), Dazed over the party if a hero cannot carry it; a boss's own immunity to hard control (unbroken), what else of the party refuses `frozen`, and whether the freeze can be blocked, missed or cleansed on JO ruling 5's shape for a status riding a blow; the end boss's rung filter (`Enemies.config` drops an ability tagged `"rung": N`), the Titan carrying no rung tag.
- **S4** §4 the count, no arm: off the fights the gates already run, with the attacking-fight number beside it, how often each of the six is fielded, each one's second move cast, Sap laid and by which carrier, a hero Frozen; a kind fielded nought times explained (which roster, why the gates never met it).
- **S5** §5 what is deliberately not done: no balance drive, the untalented line retired as an instrument; no fourth slot; no new status, no frost status; no new mechanic, special or handler beyond a kit's need; no per-kind art, the placeholder backdrop named; no dial pulled (the Cleric's cut, JO's seven, JN's ten), difficulty deferred; no existing kind's stats, kit or tags change but the two roster ids; the Scarlands keeps its single candidacy; no grade re-authored, the deck closed at twenty-five; no second forest boss (the Withered Warden met twice, named and left); the left-standing list (Boil Over's reachability; Sunder, Exposed, Cripple and Slowed unpriced; Chieftain's Maul at band 0; the crest divergence; Fleeting and Encumbered at a tie; the eight trimming plate pairings; the Regalia trap; a body over 377; Raise skipping Bloodless; a second kill and the Reaver's uncapped count; Called Shot's mode and the sim's raw armour; the Bomb's blast credit; the reserve bug); `CLAUDE.md` not cut, at 510; `test_batch_bm` §9's window, `Gate.within`, the cheap gates, the thirteen picks, `check_it` §2c, `check_hn` §2a, the latent floor shapes, the Cryomancer's route, the playthrough.
- **S6** §6 the verification, less every drive: the push check; the routing before any edit; the blocks' reader before the first edit reaches a lane; the premises at source; the literal sweep; the documents replayed from HEAD behind a hash guard; the new text's reader and the close-read; a recon (`data/enemies.json`, `run_state.gd`'s zone defs and the background dicts move); the pre-run; the new gate; all 489 positional reads; the controls (C01–C16, H01, H02, R01 a re-tune of a second move's damage at its source and every text that states it); the fresh reader; the acceptance; the landing; the two readings, the state's against 520 KiB, and the projection for JT; `master.html` §9's enemy table and the master's stamp; the ability corpus and THE LADDER's authored count; `run_state`'s single-candidate comment; `LIVE COUNTS`.

## THE ROWS THE TRIGGERS MATCHED — 65

| block | subjects | the triggers that matched (verbatim from its row) |
|---|---|---|
| `` ### THE WARBAND's COOLDOWNS `` | S2 S3 S5 | enemy cooldown; JN-population; 1.4x line; enemy picker; CD chip; JI-cooldowns; second damaging move; Break price; line_blow; Chieftain's Maul |
| `` ### THE WARBAND's MALICE `` | S2 S3 | Malice; warband heal; heal cost; spend policy |
| `` ### THE WARBAND's SPENDS `` | S2 S3 | Malice spend; warband_rally; warband_entrench; MALICE_ENTRENCH_MULT; effective_armor; _warband_spend; _raise_holds; raised body |
| `` ### THE WARBAND's HEXES `` | S2 S3 S4 | hex; Sap; SAP_CUT; Orc Hexer; rides a blow; check_jo |
| `` ### WHAT THE RAISE DID, AND THE GAME WITH TALENTS `` | S2 S5 | Withering Hex; JN's ten raises |
| `` ### THE SHARE CENSUS `` | S2 S5 | warband cooldowns; Encumbered |
| `` ### THE BARGAIN DECK's GRADES `` | S5 | deck closed; Fleeting; Encumbered |
| `` ### THE ARC, READ WHOLE `` | S5 | Fleeting; Encumbered; Bloodless |
| `` ### FOUND AT JR AND NOT FIXED `` | S0 S1 S4 | the draw; how often a kind appears; fixed boards; line-number citation; JR-citations |
| `` ### FOUND AT JQ AND NOT FIXED `` | S2 S3 | declared move; sticky status; dispel_one_debuff |
| `` ### FOUND AT JP AND NOT FIXED `` | S1 S4 S5 | DOD_ENEMIES_OFF; count denominator; JP-count; theme; reserve bug |
| `` ### FOUND AT JO AND NOT FIXED `` | S2 S5 | Break price; meter size; unpriced statuses |
| `` ### FOUND AT JN AND NOT FIXED `` | S2 S6 | intent glyph; debuff longer than cooldown; content hole; one damaging move; DATA_REST; MOVED_SINCE |
| `` ### FOUND AT JM AND NOT FIXED `` | S2 | aoe special |
| `` ### FOUND AT JL AND NOT FIXED `` | S2 | hex uptime; unpriced enemy debuffs |
| `` ### FOUND AT JK AND NOT FIXED `` | S2 S5 | Brittle Entrench; Bloodless raise; second kill; Reaver kill count; Called Shot armor |
| `` ### FOUND AT JJ AND NOT FIXED `` | S2 | warband healing a fight; enemy descriptions literal |
| `` ### FOUND AT JI AND NOT FIXED `` | S2 S6 | support cast fallback; Heads Down support; WHERE block pins; PROJECTED FOR |
| `` ### FOUND AT JH AND NOT FIXED `` | S0 | next closed block |
| `` ### FOUND AT JF AND NOT FIXED `` | S5 | Gate.within |
| `` ### FOUND AT IX AND NOT FIXED `` | S6 | check_hk walk not seeded |
| `` ### FOUND AT IW AND NOT FIXED `` | S1 | DOD_ZONE_ROTATION; zone rotation; slot pools; draw_zones; a zone no player can draw; player's zone draw |
| `` ### FOUND AT IT AND NOT FIXED `` | S6 | positional census MISSES ceiling |
| `` ### FOUND AT IS AND NOT FIXED `` | S5 | Cryomancer's route |
| `` ### FOUND AT IQ AND NOT FIXED `` | S5 | check_hn 2a worn arm |
| `` ### FOUND AT IO AND NOT FIXED `` | S2 | _cheapest_attack; enemy 0-cost attack; enemy kit order |
| `` ### FOUND AT IK AND NOT FIXED `` | S2 | enemies.json |
| `` ### FOUND AT IH AND NOT FIXED `` | S1 | map and event background |
| `` ### FOUND AT HZ AND NOT FIXED `` | S5 | Boil Over |
| `` ### FOUND AT HR AND NOT FIXED `` | S2 | Glacial Hold |
| `` ### FOUND AT HO AND NOT FIXED `` | S3 | Cleanse Debuffs talent |
| `` ### GW's RULINGS OWED `` | S6 | new gate |
| `` ### GR's RULINGS OWED `` | S0 S6 | KiB ceiling; the two readings |
| `` ### FOUND AT GP AND NOT FIXED `` | S3 | can be blocked |
| `` ### GO's RULINGS OWED `` | S5 | second kill; raised body |
| `` ### GN's RULINGS OWED `` | S3 | name sweep; label collision |
| `` ### FOUND AT GN AND NOT FIXED `` | S6 | check_gj 4 sanctioned red; baselines.json |
| `` ### GM's RULINGS OWED `` | S2 | enemy buff; warband status |
| `` ### FOUND AT GM AND NOT FIXED `` | S3 | enemy-side status list; DEBUFF_IDS |
| `` ### FOUND AT GL AND NOT FIXED `` | S5 | Called Shot |
| `` ### GJ's RULINGS OWED `` | S1 S3 | end boss rung floor; zone_base_mult |
| `` ### FOUND AT GJ AND NOT FIXED `` | S1 S3 S4 S5 | Regalia; Broken end boss freeze; end boss content; check_fh; sim zone-boss awards |
| `` ### THE TALENT LAYER IS BUILT (FX); FIVE THINGS IN IT, AND SEVEN OF FW'S EDGES, ARE THE DESIGNER'S `` | S3 | Cleanse Debuffs |
| `` ### FY §1: THREE NODES PAID BY WHO ELSE HELD THEM, AND TODAY'S COUNT DOUBLES FOUR ITEMS `` | S3 | name sweep |
| `` ### FOUR GATES CAN WRITE THE PLAYER'S `relics.json` THE DAY A RELIC IS LOCKED `` | S1 S4 | _resolve_boss; check_fh |
| `` ### THE CROSS-TARGET SUPERSESSIONS `` | S6 | MOVED_SINCE |
| `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` | S6 | pin-manifest.json |
| `` ### **AND FP's `block_chance` FINDING TRAVELS WITH IT `` | S3 | can be blocked |
| `` ### THE `master.html` STAMP CAN SIT MANY BATCHES STALE AND PASS `` | S6 | master.html Last updated stamp |
| `` ### THE LADDER `` | S1 S2 S3 | rung-tagged enemy abilities; enemies.json rung tag; wider warband encounter shape; compose floor; enemies.json |
| `` ### THE RUN REPORT'S WIPE TABLE IS BANDED FOR A TWELVE-SLOT ZONE `` | S1 | run_sim.gd wipe table |
| `` ### THE DRAFT AUDIT `` | S6 | ability corpus |
| `` ### THE SEVENTH FAMILY, FOUND AT DM AND DELIBERATELY NOT SWEPT `` | S2 | enemy description; enemies.json description |
| `` ### Small, and still owed `` | S4 | fixed boards; attacks off |
| `` ### Carried, and still awaiting a ruling `` | S0 | CLAUDE.md ceiling |
| `` ### Carried, with measurements attached `` | S6 | re-tune; every text that states it |
| `` ### Named by the designer, carried from CX `` | S2 | enemy debuff duration vs cooldown |
| `` ### Carried from the code, reported and deliberately not fixed `` | S3 | _recast_refusal_note Frozen vs Held |
| `` ### HOW LONG A FIGHT IS `` | S2 | fight length rounds |
| `` ### THE TEST TREE, AS OF EF `` | S6 | baselines.json rows; new gate rows |
| `` ### The changelog `` | S6 | changelog headroom |
| `` ### Knowledge sync, re-measured at EG `` | S0 | CLAUDE.md ceiling |
| `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` | S6 | sanctioned reds |
| `` ### THE REST `` | S6 | check_gj 4 red Tollkeeper's Bell; check_cm_live 4-5 failures |
| `` ### FIVE MORE THINGS FH FOUND AND DID NOT FIX `` | S6 | new gate |

## THE POPULATION ROWS THE TRIGGERS MATCHED — 4, AND WHAT EACH ADDS

| population row | subjects | the triggers that matched (verbatim) | member blocks | added beyond the subject triggers and the core |
|---|---|---|---|---|
| **the claims** | S6 | stale claims | 8 | `` ### FOUND AT IU AND NOT FIXED ``; `` ### FOUND AT HV AND NOT FIXED ``; `` ### FOUND AT HY AND NOT FIXED ``; `` ### FOUND AT GA AND NOT FIXED ``; `` ### FOUND AT GF AND NOT FIXED ``; `` ### FOUND AT GC AND NOT FIXED ``; `` ### FOUND AT FW AND NOT FIXED ``; `` ### FOUND AT GR AND NOT FIXED `` |
| **the closed matter** | S0 | archive what is closed; closed blocks | 6 | `` ### FOUND AT GF AND NOT FIXED ``; `` ### THE CRIT SURPLUS IS RULED END TO END ``; `` ### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED `` |
| **the positional picks** | S6 | positional census; MISSES ceiling | 4 | `` ### FOUND AT IM AND NOT FIXED ``; `` ### GY's RULINGS OWED `` |
| **the latent shapes** | S5 | latent shapes | 12 | `` ### FOUND AT IR AND NOT FIXED ``; `` ### FOUND AT IC AND NOT FIXED ``; `` ### FOUND AT IL AND NOT FIXED ``; `` ### FOUND AT IM AND NOT FIXED ``; `` ### FOUND AT HY AND NOT FIXED ``; `` ### FOUND AT FX AND NOT FIXED `` |

## NAMED BY THE BRIEF, AND NO TRIGGER HOLDS THE WORDS — 1

- `` ## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND `` (S6) — the brief names *LIVE COUNTS*; no trigger of the row holds the words (its *ability corpus 233* is a figure, not the subject). **Trigger owed**: *LIVE COUNTS*.

## THE CORE — 15, READ WHOLE

- `` ## WHERE THE PROJECT IS ``
- `` ## THE OPEN QUEUE ``
- `` ### JR's RULINGS OWED ``
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

**97 blocks: the core (15), the 65 matched, the 1 named and the 16 the population rows added — 291,772 B of HEAD's 448,127, each read whole.**

## OPENED

**All 97 blocks of the list above, each read whole, and `## THE INDEX` whole by its own rule** — the core (15) and the index by me, and all 97 by the blocks' reader at source on a frozen copy of HEAD (`route/opened_reader.md`; `lanes/read0`, frozen at 12:00:18), before the first edit reached a lane (12:34).

**And the preamble whole**: its ceiling sentence is §0's subject, read where HY set it and JJ raised it. No block outside the list was opened before its edit: the close-read's eight (below) were read after the work, which is that read's job.

## NEEDED

**14 of the 97 opened were needed and changed**, and more were needed and stood — each by JS's work or by what it wrote:

- `` ## WHERE THE PROJECT IS `` — rewritten; its gates' needles kept (the readings, the projection's head, §5's line).
- `` ### JR's RULINGS OWED `` — answered in JS's brief, all accepted as taken; archived struck; `` ### JS's RULINGS OWED `` stands in its place, CORE by role.
- `` ### THE WARBAND's COOLDOWNS `` — the record takes the seven cooling moves, its heading counts them; `check_ji` §1f reads a shared name everywhere.
- `` ### THE WARBAND's SPENDS `` — the holders since JS, the armour cap's count; `check_jk` §1's population read apart.
- `` ### THE WARBAND's HEXES `` — Sap's second carrier named on its row.
- `` ### THE SHARE CENSUS `` — its cooling-blows clause takes JS's.
- `` ### THE BARGAIN DECK's GRADES `` — the Encumbered sentence's count of cooling moves (sixty-three, JS's fifteen), its window held.
- `` ### FOUND AT JN AND NOT FIXED `` — the content hole's fourth, the Hoarfrost Warden.
- `` ### FOUND AT JL AND NOT FIXED `` — the dead `delay` key's count, thirty-two, JS's eight copying it; read for the Rally a slow body buys.
- `` ### FOUND AT IW AND NOT FIXED `` — its first item, the door the draw owed, closed by ruling 1 and archived.
- `` ### THE PLAYTEST'S OTHER FINDINGS `` — the ceiling's restatement; the look-list's Frozen Plains row.
- `` ### THE CROSS-TARGET SUPERSESSIONS `` — two rows: the digests' and the counts' `ADDED_SINCE`, recorded at both ends.
- `` ### THE LADDER `` and `` ### Named by the designer, carried from CX `` — a count each (98 abilities; the debuffs longer than their cooldown).
- **Read and standing**: `` ### THE WARBAND's MALICE `` (the Warden's heal paid a point a point), `` ### FOUND AT JQ AND NOT FIXED `` (the Titan's shape, the cleanse's aim), `` ### GN's RULINGS OWED `` (a label collision ships and is flagged), `` ### FOUND AT JR AND NOT FIXED `` (the count's population, the closed core blocks), `` ### FOUND AT IT AND NOT FIXED `` (the standing picks), and the core's fifteen.

## FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED

- `` ### THE RULES A GATE COULD CHEAPLY HOLD `` — PLAINLY — **ROUTED**: its trigger *cheap gate* names the brief's §5 *the cheap gates* (S5), and the routing did not follow it. Two NONE rows on the list are JS's subject: S2-046 (enemy self-casts tagged `"ally"`) and S2-090 (a zone boss node fields `boss_kind()`, never a roster `boss`-tagged kind; the Titan is `boss`-tagged in rosters 4 and 5). Neither was built, and neither is recorded as not taken.
- `` ### FOUND AT JG AND NOT FIXED `` — ARGUABLY — **NOT ROUTED**: it is the precedent for recording standing-list rows a brief keeps, and no trigger names JS's subject. Trigger owed: *cheap gates*.
- `` ### THE SIM's FIGURES, RE-TAKEN AT IW `` — ARGUABLY — **NOT ROUTED**: since ruling 1, a default sim draws four run shapes, and only `DOD_ZONE_ROTATION=0` replays the one road every recorded sim figure was read on. The state says neither. Trigger owed: *DOD_ZONE_ROTATION*, on this row and on the population row *the sim's recorded figures*.
- `` ### FOUND AT IE AND NOT FIXED `` — ARGUABLY — **NOT ROUTED**: *"`check_gp`'s seeded road meets a Cinderfall eight times"* is a seeded player-run road that JS's two dice at `new_run` move again. Trigger owed: *seeded road*.
- `` ### TWO SMALL DOC REPAIRS FR FOUND AND DID NOT TAKE `` — ARGUABLY — **NOT ROUTED**: JS edited `scripts/events.gd` (the `zone` requirement). It left FR's header fix standing, and its own `REQUIREMENT CONDITIONS` comment now omits `zone`. Trigger owed: *events.gd*.
- `` ### FOUND AT IJ AND NOT FIXED `` — ARGUABLY — **NOT ROUTED**: JS wrote seven kinds' texts under its *warband/ally* rule, and ruling 3 rests on the Siege Stone chip it names. Nothing in it is false. Trigger owed: *enemy description*.
- `` ### THE BOSS-PICK POOLS `` — ARGUABLY — **NOT ROUTED**: *"there are THREE zone bosses … derived from `Run.SLOT_COUNT`"* still holds with a third boss kind, because `SLOT_COUNT` stays 3. Trigger owed: *SLOT_COUNT*.
- `` ### THE FIRST CLEAN PLAYTHROUGH `` — ARGUABLY — **NOT ROUTED**: the second run it asks for now draws its opener (the Forest or the Frozen Plains), so it is no longer a zone-one Forest run like-for-like. Trigger owed: *zone one*.

## THE INDEX's UPKEEP

**27 of 167 entries touched** — the tree's index against HEAD's (`edits/upkeep.py`, JR's tool), every block JS changed re-stamped by `index_stamp.py --write`.

**ADDED — 3**: `` ### JS's RULINGS OWED ``; `` ### THE FROZEN PLAINS ``; `` ### FOUND AT JS AND NOT FIXED ``.

**LEFT — 1**: `` ### JR's RULINGS OWED `` (the open queue's rulings move to the newest batch's, the core's by role).

**RE-LABELLED OR RE-TRIGGERED, AND RE-STAMPED — 13**: `` the latent shapes ``; `` the sim's recorded figures ``; `` ### THE FIRST CLEAN PLAYTHROUGH ``; `` ### THE WARBAND's COOLDOWNS ``; `` ### THE SIM's FIGURES, RE-TAKEN AT IW ``; `` ### FOUND AT JG AND NOT FIXED ``; `` ### FOUND AT IW AND NOT FIXED ``; `` ### FOUND AT IJ AND NOT FIXED ``; `` ### FOUND AT IE AND NOT FIXED ``; `` ### THE CROSS-TARGET SUPERSESSIONS ``; `` ### TWO SMALL DOC REPAIRS FR FOUND AND DID NOT TAKE ``; `` ### THE BOSS-PICK POOLS ``; `` ## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND ``.

**RE-STAMPED ONLY — 11**: `` ## WHERE THE PROJECT IS ``; `` ### THE PLAYTEST'S OTHER FINDINGS ``; `` the bot's divergences ``; `` ### THE BARGAIN DECK's GRADES ``; `` ### THE SHARE CENSUS ``; `` ### THE WARBAND's SPENDS ``; `` ### THE WARBAND's HEXES ``; `` ### FOUND AT JN AND NOT FIXED ``; `` ### FOUND AT JL AND NOT FIXED ``; `` ### THE LADDER ``; `` ### Named by the designer, carried from CX `` — each block's text moved under a row whose label and triggers still hold.
