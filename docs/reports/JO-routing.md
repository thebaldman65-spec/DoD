# JO — THE ROUTING OF RECORD

Part of JO's report (`docs/reports/JO.md`). **Written before the work began** (the subjects and the matches on 2026-11-06, before any edit): the brief's subjects, the index rows whose triggers name them — each with the trigger that matched, verbatim from its row — the population rows whose triggers name a subject, the blocks those population rows add, and the core. **That list plus the core is what JO opens, the core whole.** The file read is HEAD's `docs/state.md` (`aa6f75f`, 165 entries: 141 rows, 15 core, 9 population rows).

## THE BRIEF'S SUBJECTS

- **S0** §0 JN's nine rulings accepted as taken, each a document edit: the second damaging move's population is ten; Break damage not priced (§1 changes that); the Bellow's hand-tune retired; the Cleric's cut at the bar's setter, superseding IG's *the rate stays 12* and the playtest's *Mana stays*, recorded and not deleted; Boil Over 1.5 a point as the blow's whole damage; Sanctity stays, the question open since about HX closed; Arm B's policy tier 1 whole; Thin Air recorded at +17.86, band 5; the arms beyond the brief right to run — and the new verification floor written into `docs/ways-of-working.md` beside the citation rule: balance is the designer's, judged by playing; a batch's only job is making sure its code works; no batch runs a balance drive; a plain count of whether a new mechanic fired stays, as correctness
- **S1** §1 Break damage gets a price: a point of Break damage priced at a hero turn's damage divided by the Break meter's size — the hero turn's damage JA's census (Mire priced on it at 35.15), the meter's size read in the code; the ten raised moves' worths re-derived with Break in the sum, those back under JI's 1.4× line brought down to it, those still clear left where JN put them; before, JN's and JO's figures kept as a `.tsv`; premises — whether the meter's size is one number (by hero, class or zone; the reference four's mean), whether a Break costs exactly one turn; and the unpriced statuses the ten lay (Sunder, Exposed, Cripple, Slowed, Dazed) named with their size, not priced
- **S2** §2 the hexes ride blows: no warband move lays a status on a hero unless it deals damage, derived off the data; a hex folded onto a damaging move of its carrier's that lays nothing (Fester onto the Rot Behemoth's Wretched Bellow, Sap onto the Orc Hexer's Bone Rattle, raised to clear the line), or the hex move given damage until it clears JI's line (Gall on the Orc Archer, reaching every hero; Mire on the Grave Totem); each hex's route and why, damage, reach, worth and band kept as a `.tsv`; premises — whether a move can carry the hex (no fold onto a move that already lays something), whether the rule catches Rally or Entrenched (the spends the warband lays on itself stay free), and what a damaging hex does about aim, miss and the party's draws (JL ruling 7), shaped like the warband's other status-laying blows
- **S3** §3 the count, which is correctness and not balance: off the fights the gates already run, how many times each of the four hexes was laid and on how many fights, how many times each of §1's re-derived moves was cast, and the Break count — heroes Broken, and how many by a move §1 touched; no arm, no pairing, no comparison, no prediction
- **S4** §4 what is deliberately not done: no balance drive of any kind (no arm, pairing, prediction, grade re-read or completion figure), the untalented line retired as an instrument; no basic change, no new move, kind, status or ability; the Cleric's cut, Boil Over's 1.5 and Sanctity as JN left them; no grade re-authored, no card added, removed or re-keyed, the deck closed at twenty-five, Thin Air recorded at +17.86, band 5; Sunder, Exposed, Cripple, Slowed and Dazed unpriced; Chieftain's Maul and Sundering Decree under the line and named; Boil Over's reachability not addressed; left as JN found them — the crest divergence, Fleeting and Encumbered at a tie with a cut, the eight trimming plate pairings, the Regalia trap, a body over 377, Raise skipping Bloodless, a second kill and the Reaver's count, Called Shot's mode and the sim's raw armour, the Bomb's blast credit, the glossary's missing Malice entry, the ten strays in `KNOWN_STRAYS`; `CLAUDE.md` not cut, the state's ceiling at 440; `test_batch_bm` §9's window, `Gate.within`, the cheap gates, the thirteen picks, `check_it` §2c, `check_hn` §2a, the latent floor shapes, the Cryomancer's route, the playthrough
- **S5** §5 the verification: the push check; the routing before any edit; the blocks' reader's findings before the first edit script; the premises at source; the literal sweep; the documents replayed from HEAD behind a hash guard; the new text's reader and the close-read; a recon for `data/enemies.json` and the hex handlers; the pre-run; the new gate (`check_jo`); all 489 positional reads; C01 to C14, H01, H02 and R01 on the tree that lands; the fresh reader on the assembled report; the acceptance; the report's landing; the two readings at the open and the close against the state's 440 KiB, and the projected figure for JP

## THE ROWS THE TRIGGERS MATCHED — 64

| block | subjects | the triggers that matched (verbatim from its row) |
|---|---|---|
| `` ### THE WARBAND's COOLDOWNS `` | S1 S2 | enemy cooldown; warband cooldowns; cooldown population; 1.4x line; enemy picker; enemy selection; CD chip; JI-population; Wretched Bellow; TUNED; second damaging move; JN-population |
| `` ### THE WARBAND's HEXES `` | S2 S3 | hex; warband_hex; Gall; Sap; Mire; Fester; GALL_HEAL_CUT; SAP_CUT; MIRE_SLOW; fester_grow; hex uptime; Orc Hexer; enemy debuff; Orc Archer; JL-hexes; JM-hexes |
| `` ### THE WARBAND's SPENDS `` | S2 | warband_rally; warband_entrench; Malice spend; free spend |
| `` ### THE WARBAND's MALICE `` | S2 | Malice |
| `` ### WHAT THE RAISE DID, AND THE GAME WITH TALENTS `` | S0 S1 S3 S4 | what the raise did; JN-arc; JN-played; JN-thinair; hero Breaks; Skull Crack; Withering Hex; Swampy Grasp; DOD_SIM_TIERS; talent policy; Thin Air after the cut |
| `` ### FOUND AT JN AND NOT FIXED `` | S0 S1 S2 S4 | brief premises; Break damage unpriced; later moves; intent glyph; debuff longer than cooldown; Blood Tribute band; the cut's reach; content hole; one damaging move; Honed |
| `` ### FOUND AT JM AND NOT FIXED `` | S2 S4 | ties at a cut; aoe special; Gall leaning easier; crest choice |
| `` ### FOUND AT JL AND NOT FIXED `` | S1 S2 S3 | hex uptime; Returned Burden hex; Fleeting hex; unpriced enemy debuffs; float_text die |
| `` ### FOUND AT JK AND NOT FIXED `` | S2 S4 | Fleeting Rally; Brittle Entrench; Bloodless raise; second kill; Reaver kill count; Blood Tribute fallen; Called Shot armor |
| `` ### FOUND AT JJ AND NOT FIXED `` | S2 | enemy descriptions literal |
| `` ### FOUND AT JI AND NOT FIXED `` | S1 S5 | CD chip; Blood Tribute; unpriced ward; PROJECTED FOR |
| `` ### THE SHARE CENSUS `` | S1 | share census; census price; what a share prices; heroes vs warband |
| `` ### THE ARC, READ WHOLE `` | S4 | what the arc did; JM-arc; Thin Air; Fleeting; Encumbered |
| `` ### THE BARGAIN DECK's GRADES `` | S4 | re-grade; deck closed; Fleeting; Encumbered; reference party |
| `` ### FOUND AT IO AND NOT FIXED `` | S1 S2 | _cheapest_attack; enemy kit order; Heads Down; enemy 0-cost attack |
| `` ### FOUND AT IK AND NOT FIXED `` | S1 S2 | Sunder duration; SUNDER_TURNS; Sundering Strike; enemies.json; Called Shot Armor |
| `` ### FOUND AT ID AND NOT FIXED `` | S2 | _resolve_special; DAMAGE_SPECIALS; attack vs special handler |
| `` ### THE LADDER `` | S2 | enemies.json; rung-tagged enemy abilities; enemies.json rung tag |
| `` ### THE SEVENTH FAMILY, FOUND AT DM AND DELIBERATELY NOT SWEPT `` | S2 | enemy description; enemies.json description |
| `` ### Named by the designer, carried from CX `` | S2 | enemy debuff duration vs cooldown; enemy interference status |
| `` ### FOUND AT IL AND NOT FIXED `` | S2 | status src |
| `` ### GM's RULINGS OWED `` | S2 | enemy buff; beneficial status on an enemy; warband status |
| `` ### FOUND AT GM AND NOT FIXED `` | S2 | enemy-side status list; DEBUFF_IDS |
| `` ### THE REST `` | S2 S5 | defensive bar; _defensive_brace; sanctioned red baselines.json |
| `` ### THE SIM's FIGURES, RE-TAKEN AT IW `` | S4 | recorded sim figures; re-take |
| `` ### FOUND AT IY AND NOT FIXED `` | S3 S4 | seed per fight; paired by seed |
| `` ### EVERY COMPLETION FIGURE DATED BEFORE GJ EXCLUDED THE FINAL FIGHT `` | S4 | run completion rate; untalented completion |
| `` ### THE RUN REPORT'S WIPE TABLE IS BANDED FOR A TWELVE-SLOT ZONE `` | S4 | run completion rate |
| `` ### FOUND AT JF AND NOT FIXED `` | S4 | the bot wears a crest; crest none |
| `` ### FOUND AT HZ AND NOT FIXED `` | S4 | Boil Over |
| `` ### THE FIRST CLEAN PLAYTHROUGH `` | S4 | Boil Over undrafted; playtest readout; Cleric driest hero |
| `` ### FOUND AT IG AND NOT FIXED `` | S4 | opening bar; tier 1 whole |
| `` ### THE THREE PRICING QUESTIONS `` | S4 | the Cleric's Mana gain |
| `` ### THE CLASS MERGE ~~IS MEASURED AND UNRULED~~ WAS MEASURED AT FP AND IS RULED `` | S4 | Sanctity's step |
| `` ### GK's RULINGS OWED `` | S4 | Sanctity's step |
| `` ### FOUND AT JD AND NOT FIXED `` | S4 | KNOWN_STRAYS |
| `` ### THE RULES A GATE COULD CHEAPLY HOLD `` | S4 | cheap gate |
| `` ### FOUND AT IU AND NOT FIXED `` | S4 | cheap gate |
| `` ### FOUND AT IS AND NOT FIXED `` | S4 | Cryomancer's route |
| `` ### FOUND AT IR AND NOT FIXED `` | S4 | floor census; latent floor of a zero |
| `` ### FOUND AT IQ AND NOT FIXED `` | S4 | check_hn 2a worn arm |
| `` ### FOUND AT II AND NOT FIXED `` | S4 | attribution frame; credit nobody |
| `` ### FOUND AT HY AND NOT FIXED `` | S4 | attribution frame |
| `` ### GO's RULINGS OWED `` | S4 | second kill; kill count; raised body |
| `` ### FOUND AT GJ AND NOT FIXED `` | S4 | Regalia |
| `` ### Carried, and still awaiting a ruling `` | S4 | CLAUDE.md ceiling |
| `` ### FOUND AT GR AND NOT FIXED `` | S0 | ways-of-working.md header two rule files; check_fr |
| `` ### GR's RULINGS OWED `` | S5 | the two readings |
| `` ### FOUND AT JH AND NOT FIXED `` | S5 | check_jc; next closed block; census since IT |
| `` ### FOUND AT JA AND NOT FIXED `` | S5 | DOD_SUITE_TIMEOUT; battery watchdog |
| `` ### FOUND AT IT AND NOT FIXED `` | S5 | positional census MISSES ceiling; typed figure |
| `` ### FOUND AT HT AND NOT FIXED `` | S5 | run_battery.sh game open; player-file arm |
| `` ### THE CROSS-TARGET SUPERSESSIONS `` | S0 S5 | supersession table; test_batch_ce; check_jj 5 |
| `` ### FOUND AT GN AND NOT FIXED `` | S5 | check_gj 4 sanctioned red; baselines.json |
| `` ### FOUND AT GK AND NOT FIXED `` | S5 | save-backups untracked; git add -A |
| `` ### FY §1: THREE NODES PAID BY WHO ELSE HELD THEM, AND TODAY'S COUNT DOUBLES FOUR ITEMS `` | S5 | name sweep |
| `` ### GN's RULINGS OWED `` | S5 | name sweep; label collision |
| `` ### THE TEST TREE, AS OF EF `` | S5 | run_battery.sh GATES; baselines.json rows; new gate rows; check_de differ |
| `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` | S5 | sanctioned reds; check_cm_live; check_gj |
| `` ### FIVE MORE THINGS FH FOUND AND DID NOT FIX `` | S5 | new gate; exit 0 Parse Error |
| `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` | S0 S5 | build_pin_manifest.py; pin-manifest.json; check_ed; ways-of-working.md |
| `` ### The changelog `` | S5 | changelog headroom; next changelog cut owed; changelog cut |
| `` ### THE `master.html` STAMP CAN SIT MANY BATCHES STALE AND PASS `` | S5 | master.html Last updated stamp; test_batch_ce |
| `` ### Knowledge sync, re-measured at EG `` | S5 | claude_md_census.py; CLAUDE.md ceiling |

## THE POPULATION ROWS THE TRIGGERS MATCHED — 7, AND WHAT EACH ADDS

| population row | subjects | the triggers that matched (verbatim) | member blocks | added beyond the subject triggers and the core |
|---|---|---|---|---|
| **the sim's recorded figures** | S1 S4 | recorded sim figures; which figures move; re-take; worth rule | 26 | `` ### FOUND AT JG AND NOT FIXED ``; `` ### HOW LONG A FIGHT IS ``; `` ### Carried, with measurements attached ``; `` ### Small, and still owed ``; `` ### FOUND AT IE AND NOT FIXED ``; `` ### FOUND AT IF AND NOT FIXED ``; `` ### Carried from the code, reported and deliberately not fixed ``; `` ### FOUND AT JE AND NOT FIXED ``; `` ### FOUND AT JC AND NOT FIXED ``; `` ### FOUND AT JB AND NOT FIXED ``; `` ### FOUND AT IZ AND NOT FIXED ``; `` ### FOUND AT HP AND NOT FIXED ``; `` ### THE THREE SPINES ARE BUILT AND ALL THREE RATES ARE SET (FU, FV); WHAT IS STILL FLAGGED `` |
| **the bot's divergences** | S3 | sim bot; DOD_SIM_TIERS | 10 | `` ### FOUND AT GS AND NOT FIXED ``; `` ### FOUND AT IE AND NOT FIXED ``; `` ### FOUND AT IF AND NOT FIXED ``; `` ### FOUND AT IM AND NOT FIXED ``; `` ### FOUND AT GE AND NOT FIXED `` |
| **the claims** | S0 | reference claims; stale claims | 8 | `` ### FOUND AT HV AND NOT FIXED ``; `` ### FOUND AT GA AND NOT FIXED ``; `` ### FOUND AT GF AND NOT FIXED ``; `` ### FOUND AT GC AND NOT FIXED ``; `` ### FOUND AT FW AND NOT FIXED `` |
| **the figures behind doors** | S1 S2 | every figure a text states; a figure with no door; name the constants | 5 | `` ### FOUND AT IJ AND NOT FIXED ``; `` ### FOUND AT HL AND NOT FIXED `` |
| **the closed matter** | S0 | archive what is closed; strike what is closed | 6 | `` ### FOUND AT HO AND NOT FIXED ``; `` ### FOUND AT GL AND NOT FIXED ``; `` ### FOUND AT GF AND NOT FIXED ``; `` ### THE CRIT SURPLUS IS RULED END TO END ``; `` ### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED `` |
| **the latent shapes** | S4 | floor census; floor of a zero | 10 | `` ### FOUND AT IX AND NOT FIXED ``; `` ### FOUND AT IW AND NOT FIXED ``; `` ### FOUND AT IC AND NOT FIXED ``; `` ### FOUND AT IM AND NOT FIXED ``; `` ### FOUND AT FX AND NOT FIXED `` |
| **the positional picks** | S5 | positional census; MISSES ceiling | 4 | `` ### FOUND AT IM AND NOT FIXED ``; `` ### GY's RULINGS OWED `` |

## THE CORE — 15, READ WHOLE

- `` ## WHERE THE PROJECT IS ``
- `` ## THE OPEN QUEUE ``
- `` ### JN's RULINGS OWED ``
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

**111 blocks: the core (15), the 64 matched and the 32 the population rows added — 302,091 B of HEAD's 449,864, each read whole.**

## OPENED

**All 111 blocks of the list above, each read whole** — the core (15), the 64 the triggers matched and the 32 the population rows added; and the blocks' reader read the same 111 at source on a frozen copy of HEAD (`route/opened_reader.md`, written at 14:08:17). The instruments and the edit scripts were drafted while it read (from 13:49:23, `tools/jo_line.py`; the edit scripts from 14:01:34); one ran at 14:06:33 on a scratch copy of `check_jk.gd` alone, to test its anchors; the decisions on its findings were recorded at 14:10:21 (`route/decisions.md`), and the first edit script to touch a lane ran at 14:10:29 — so its findings came before any edit reached a lane, not before the first edit script was written.

## NEEDED

**26 of the 111 were needed and changed** — each by JO's work or by what it wrote:

- `` ## WHERE THE PROJECT IS `` — rewritten; closed gates pin its words.
- `` ### JN's RULINGS OWED `` — answered in JO's brief, all accepted as taken; archived struck; `` ### JO's RULINGS OWED `` stands in its place.
- `` ### THE WARBAND's COOLDOWNS `` — §1: the line's Break price, the ten re-derived, the bands held.
- `` ### THE WARBAND's HEXES `` — §2: each hex on its blow; JM's ruling 3 and JL's ruling 7 superseded, recorded.
- `` ### THE WARBAND's SPENDS `` — the spends' worths on the priced line, five of their bands held.
- `` ### WHAT THE RAISE DID, AND THE GAME WITH TALENTS `` — marked JN's record since JO §1; the untalented line retired as an instrument.
- `` ### THE BARGAIN DECK's GRADES `` — Encumbered's count of cooling moves; Thin Air's citation of JN's ruling accepted.
- `` ### THE SHARE CENSUS `` — the hexes on the companions too; the census as the Break price's numerator.
- `` ### THE CLERIC's MANA RATE ``, `` ### SANCTITY's STEP ``, `` ### BOIL OVER'S RATE `` — JN's rulings cited, accepted at JO §0; the readings the floor retires marked.
- `` ### THE CREST POOL `` — the reading at the fight marked JH's, taken by no batch since the floor.
- `` ### THE PLAYTEST'S OTHER FINDINGS `` — the LOOK-LIST's hex row mended and JO's row added.
- `` ### THE CROSS-TARGET SUPERSESSIONS `` — the supersessions JO wrote.
- `` ### Named by the designer, carried from CX `` — a debuff against its cooldown, re-read on the hexes' blows.
- `` ### THE LADDER `` — the warband's move count, 76 since JO §2.
- `` ### FOUND AT JN AND NOT FIXED ``, `` ### FOUND AT JM AND NOT FIXED ``, `` ### FOUND AT JL AND NOT FIXED `` — their closed items archived (Break unpriced, the later moves, the hex arm and the hex uptime); JN's tripwires named JN's record.
- `` ### FOUND AT JI AND NOT FIXED ``, `` ### FOUND AT IX AND NOT FIXED `` — the unpriced debuffs past Fester's tick; the hexes' reach.
- `` ### FOUND AT JB AND NOT FIXED ``, `` ### FOUND AT IY AND NOT FIXED ``, `` ### EVERY COMPLETION FIGURE DATED BEFORE GJ EXCLUDED THE FINAL FIGHT ``, `` ### FOUND AT IZ AND NOT FIXED `` — records the floor leaves asking nothing, archived whole.
- `` ### HOW LONG A FIGHT IS `` — its figures, stale since DK, archived for the state's room; its two instrument facts stay.

**Read for the work and left as they stood**: `` ### THE TEST TREE, AS OF EF `` (the new gate's rows: the battery's list, `baselines.json`, `check_parse`), `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` (the carried reds every prediction names), `` ### THE SIM's FIGURES, RE-TAKEN AT IW `` (weighed for the archive and kept: `check_jm` §2 holds its *30 of 60* where it stood), `` ### THE ARC, READ WHOLE `` (JM's instrument, read by no batch since the floor) and `` ### THE WARBAND's MALICE `` (the Malice a spend costs, unmoved).

## FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED

# JO — THE CLOSE-READ, FOR THE ROUTING FILE

All 45 blocks JO left closed were read whole against the finished work. Three bore on it, all ARGUABLY and LOW: one ROUTED and two NOT ROUTED, with one trigger owed between the two. The other 42 bore nothing. Four of them were checked at source: FOUND AT HF, FOUND AT GY, GW's RULINGS OWED and the four gates that can write `relics.json`. The table and every finding are in `route/close_read_findings.md`.

- `` ### FOUND AT HA AND NOT FIXED `` — **ROUTED**. Its row carries `check_di`, a file JO's work edited. The routing was written from the brief before the edit, so the trigger was never followed. What bears: its `check_di:391` cites a line JO's new comment moved to 441 (it was 438 at HEAD already). Repair: cite the call by its text.
- `` ### FOUND AT GP AND NOT FIXED `` — **NOT ROUTED**. Its triggers (`Covering Guard block_chance`, `_live_block_chance`, …) name none of JO's words. Since JO §2 a hex rides a blow that meets the Block roll, and Covering Guard lends a 0% Block off a Warden's base. **Trigger owed: `can be blocked`** (JO's ruling 5's words).
- `` ### **AND FP's `block_chance` FINDING TRAVELS WITH IT `` — **NOT ROUTED**. Its triggers (`block_chance default 0`, `Warden 0.10`, `parry_chance sentinel`, …) name none of JO's words. `block_chance` has no universal baseline, so ruling 5's *a single blow can … be blocked* holds only for a hero who carries a Block source. **Trigger owed: `can be blocked`**.

The routing's real misses were not in the closed blocks. They were in blocks it opened whose text JO's own change made false and did not mend: FOUND AT JM, THE PLAYTEST's OTHER FINDINGS' LOOK-LIST, THE CROSS-TARGET SUPERSESSIONS, *Named by the designer, carried from CX*, THE LADDER, THE WARBAND's SPENDS, THE SHARE CENSUS, FOUND AT IX, FOUND AT JI, and the touched FOUND AT JN, FOUND AT JL, THE BARGAIN DECK's GRADES and SANCTITY's STEP. Each is in the findings file, as HIGH-3–6 and MED-6–12.

The routing of record matched `new gate` for FIVE MORE THINGS FH and not for GW's RULINGS OWED, which carries it verbatim. It matched `crest choice` for FOUND AT JM and not for THE RUNE CHARTER. Neither block bore.

## THE INDEX's UPKEEP

**29 of 162 entries touched** — the tree's index against HEAD's (`tools`: `edits/upkeep.py`), every block JO changed re-stamped by `index_stamp.py --write`.

**ADDED — 2**: `` ### JO's RULINGS OWED ``; `` ### FOUND AT JO AND NOT FIXED ``.

**LEFT — 5**: `` ### JN's RULINGS OWED ``; `` ### FOUND AT JB AND NOT FIXED ``; `` ### FOUND AT IZ AND NOT FIXED ``; `` ### FOUND AT IY AND NOT FIXED ``; `` ### EVERY COMPLETION FIGURE DATED BEFORE GJ EXCLUDED THE FINAL FIGHT `` (the open queue's rulings move to the newest batch's, the core's by role).

**RE-LABELLED OR RE-TRIGGERED, AND RE-STAMPED — 10**: `` the sim's recorded figures ``; `` ### THE WARBAND's COOLDOWNS ``; `` ### THE WARBAND's HEXES ``; `` ### WHAT THE RAISE DID, AND THE GAME WITH TALENTS ``; `` ### FOUND AT JN AND NOT FIXED ``; `` ### FOUND AT JM AND NOT FIXED ``; `` ### FOUND AT JL AND NOT FIXED ``; `` ### FOUND AT GP AND NOT FIXED ``; `` ### **AND FP's `block_chance` FINDING TRAVELS WITH IT ``; `` ### HOW LONG A FIGHT IS ``.

**RE-STAMPED ONLY — 17**: `` ## WHERE THE PROJECT IS ``; `` ### THE CLERIC's MANA RATE ``; `` ### SANCTITY's STEP ``; `` ### BOIL OVER'S RATE ``; `` ### THE CREST POOL ``; `` ### THE PLAYTEST'S OTHER FINDINGS ``; `` the bot's divergences ``; `` the latent shapes ``; `` ### THE BARGAIN DECK's GRADES ``; `` ### THE SHARE CENSUS ``; `` ### THE WARBAND's SPENDS ``; `` ### FOUND AT JI AND NOT FIXED ``; `` ### FOUND AT IX AND NOT FIXED ``; `` ### THE CROSS-TARGET SUPERSESSIONS ``; `` ### FOUND AT HA AND NOT FIXED ``; `` ### THE LADDER ``; `` ### Named by the designer, carried from CX `` — each block's text moved under a row whose label and triggers still hold.
