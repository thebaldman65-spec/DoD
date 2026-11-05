# JK — THE ROUTING OF RECORD

Part of JK's report (`docs/reports/JK.md`). **Written before the work began** (the subjects and the matches on 2026-11-04, before any edit): the brief's subjects, the index rows whose triggers name them — each with the trigger that matched, verbatim from its row — the population rows whose triggers name a subject, the blocks those population rows add, and the core. **That list plus the core is what JK opens, the core whole.** The file read is HEAD's `docs/state.md` (`5ae3c6c`, 157 entries: 133 rows, 15 core, 9 population rows).

## THE BRIEF'S SUBJECTS

- **S0** §0 JJ's six rulings accepted as taken, each a document edit: a heal's price is what it restores on the body it lands on and it pays what it restored; a declared heal sets its price aside, which keeps JI's support fallback unreachable; hurt is missing at least half of what the heal would restore, Dark Vigil's condition tightening with it; nothing is tuned for the pool's timing; the strip above the warband's stack and Communion's count on the crest strip; a kill fills on every death of the warband, damage and waste on the hero side's alone; JJ's RULINGS OWED archived and its living citations re-pointed
- **S1** §1 four spends of Malice — Raise (a fallen body of the warband stood back up at 40% of its health, once a body a fight, never Broken), Rally (the warband deals 30% more damage for 2 of its turns, never reaching a heal), Entrench (the warband's armour doubles for 3 of its turns, at one door), Overrun (a whelp joins the warband at the back of the order, if a summon path exists); every one of the 21 enemy kinds can buy at least one, derived off the data by a gate, Rally and Entrench the universal pair; the kind-by-kind table kept as a `.tsv`; how many of the eleven kinds with no cooling move now hold a spend; a spend is a move on a kind's list through `_choose_enemy_action` and `_enemy_ready`, never a side-level action layer; the four premises: a summon path, `revive` and `broken`, a warband damage multiplier and the heal reserve, the armour's one door
- **S2** §2 the prices: Raise the health it stands the body up with, Overrun the whelp's health, Rally 40 flat, Entrench 30 flat; the arithmetic checked against 282.5 given a fight; each priced by JI's 1.4x line and given the cooldown that falls out
- **S3** §3 does it drain: sixty runs, fight-seeded, the reference four untalented at Warden, paired by seed against JJ's tree; completions, falls a run, health at a fight's end, hero turns a fight; the pool's ledger (given, taken, wasted, spent, the share of turns at the cap) and the spend count a fight by spend; the prediction written first
- **S4** §4 what is deliberately not done: no hexer and no debuff; no fill change; no heal change; no cooldown moves but the four spends', the line at 1.4; no new attack for the eleven; no new enemy kind; no modifier authored, removed, re-keyed or re-valued, no grade moved, the deck closed at twenty-five; Communion's figure, chip and count; `CLAUDE.md` not cut, the state's ceiling at 440; left as JJ found them: the frame crediting nobody for the Bomb's blast and a sourceless Burn, the glossary's missing Malice entry, the price not reading Frostbite's half or a refusal, Wild Growth's lost coin, the support fallback's ally target, the unpriced wards, cleanse and debuffs, the ten strays in `KNOWN_STRAYS`; `test_batch_bm` §9's window, `Gate.within`, the 187 cheap gates, the thirteen picks, `check_it` §2c, `check_hn` §2a, the latent floor shapes, the Cryomancer's route, the playthrough
- **S5** §5 the verification: the push check; the routing, the blocks' reader, the premises at source before any edit; §3's prediction as a file first; the literal sweep; the documents replayed from HEAD behind a hash guard; the new text's reader and the close-read; a recon, because `data/enemies.json`, the selection, the pool's spenders and the armour door move; the pre-run; `check_jk`; all 489 positional reads; C01 to C13, H01, H02 and R01 on the tree that lands; the fresh reader on the assembled report; the acceptance; the report's landing; the two readings at the open and the close against the state's 440 KiB, and the projected figure for JL

## THE ROWS THE TRIGGERS MATCHED — 54

| block | subjects | the triggers that matched (verbatim from its row) |
|---|---|---|
| `` ### THE WARBAND's MALICE `` | S0 S1 S2 S3 | Malice; warband pool; warband heal; heal cost; spend policy; MALICE_CAP; malice strip; JJ-malice |
| `` ### THE WARBAND's COOLDOWNS `` | S1 S2 S4 | enemy cooldown; warband cooldowns; cooldown population; 1.4x line; enemy picker; enemy selection; CD chip; before figure; fifth batch; JI-cooldowns; JI-population; TUNED |
| `` ### FOUND AT JJ AND NOT FIXED `` | S1 S4 | second move weaker; content hole; heal float; enemy descriptions literal |
| `` ### FOUND AT JI AND NOT FIXED `` | S4 S5 | support cast fallback; CD chip; unpriced ward; WHERE block pins; PROJECTED FOR |
| `` ### FOUND AT JH AND NOT FIXED `` | S4 | Communion rune |
| `` ### FOUND AT JF AND NOT FIXED `` | S3 | the bot wears a crest; crest none |
| `` ### FOUND AT JD AND NOT FIXED `` | S1 S4 | strike on a corpse; revive_pct; KNOWN_STRAYS |
| `` ### FOUND AT JA AND NOT FIXED `` | S5 | DOD_SUITE_TIMEOUT; battery watchdog |
| `` ### FOUND AT IY AND NOT FIXED `` | S3 | seed per fight; paired by seed |
| `` ### THE BARGAIN DECK's GRADES `` | S3 S4 | reference party; fight seed; deck closed |
| `` ### THE SHARE CENSUS `` | S1 | heroes vs warband; two sides' shares |
| `` ### THE SIM's FIGURES, RE-TAKEN AT IW `` | S3 S4 | SUPERSEDED-PENDING; recorded sim figures |
| `` ### THE RULES A GATE COULD CHEAPLY HOLD `` | S4 | cheap gate |
| `` ### FOUND AT IU AND NOT FIXED `` | S4 | cheap gate |
| `` ### FOUND AT IT AND NOT FIXED `` | S5 | positional census MISSES ceiling |
| `` ### FOUND AT IS AND NOT FIXED `` | S4 | Cryomancer's route |
| `` ### FOUND AT IR AND NOT FIXED `` | S4 | floor census; latent floor of a zero |
| `` ### FOUND AT IQ AND NOT FIXED `` | S4 | check_hn 2a worn arm |
| `` ### FOUND AT IO AND NOT FIXED `` | S1 | _cheapest_attack; Heads Down; enemy kit order |
| `` ### FOUND AT IM AND NOT FIXED `` | S1 | _enemy_pick_pool |
| `` ### FOUND AT IK AND NOT FIXED `` | S1 | Sunder duration; Called Shot Armor; Sundering Strike; enemies.json |
| `` ### FOUND AT IJ AND NOT FIXED `` | S1 | check_ih |
| `` ### FOUND AT II AND NOT FIXED `` | S4 | Chain Ignition Burn no source; attribution frame; frame names nobody; credit nobody |
| `` ### FOUND AT IG AND NOT FIXED `` | S1 | Melt Armor display chip |
| `` ### FOUND AT ID AND NOT FIXED `` | S1 | _resolve_special; attack vs special handler |
| `` ### FOUND AT HY AND NOT FIXED `` | S4 | attribution frame |
| `` ### FOUND AT HW AND NOT FIXED `` | S1 | companion summon fit |
| `` ### FOUND AT HT AND NOT FIXED `` | S5 | run_battery.sh game open; player-file arm |
| `` ### FOUND AT HS AND NOT FIXED `` | S4 | tick has no attacker |
| `` ### FOUND AT HF AND NOT FIXED `` | S1 | Summon Companion text three companions |
| `` ### FOUND AT GU AND NOT FIXED `` | S1 | Beastmaster summons |
| `` ### FOUND AT GN AND NOT FIXED `` | S5 | check_gj 4 sanctioned red; baselines.json |
| `` ### FOUND AT GM AND NOT FIXED `` | S1 | enemy-side status list |
| `` ### FOUND AT GL AND NOT FIXED `` | S1 | party damage buffs |
| `` ### FOUND AT GK AND NOT FIXED `` | S5 | save-backups untracked; git add -A |
| `` ### FOUND AT GJ AND NOT FIXED `` | S3 | recorded sim figures |
| `` ### FOUND AT GH AND NOT FIXED `` | S1 | _die; resumed battle |
| `` ### FOUND AT GF AND NOT FIXED `` | S1 | Melted Armor |
| `` ### FOUND AT FW AND NOT FIXED `` | S1 | death refusals |
| `` ### EVERY COMPLETION FIGURE DATED BEFORE GJ EXCLUDED THE FINAL FIGHT `` | S3 | run completion rate; untalented completion |
| `` ### HOW LONG A FIGHT IS `` | S3 | fight length rounds; turns per hero |
| `` ### THE FIRST CLEAN PLAYTHROUGH `` | S4 | second playthrough |
| `` ### THE LADDER `` | S1 | rung-tagged enemy abilities; enemies.json rung tag |
| `` ### THE SEVENTH FAMILY, FOUND AT DM AND DELIBERATELY NOT SWEPT `` | S1 | enemy description; enemies.json description |
| `` ### Small, and still owed `` | S1 | _apply_status src coverage; check_di CALL_SITES |
| `` ### Named by the designer, carried from CX `` | S4 | enemy interference status |
| `` ### Carried, and still awaiting a ruling `` | S4 | CLAUDE.md ceiling |
| `` ### Carried, with measurements attached `` | S3 | recorded sim figures |
| `` ### Carried from the code, reported and deliberately not fixed `` | S3 | SUPERSEDED-PENDING |
| `` ### Knowledge sync, re-measured at EG `` | S4 | claude_md_census.py; CLAUDE.md ceiling |
| `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` | S5 | sanctioned reds; check_cm_live; check_gj |
| `` ### THE REST `` | S5 | sanctioned red baselines.json |
| `` ### THE TEST TREE, AS OF EF `` | S5 | baselines.json rows; new gate rows; run_battery.sh GATES; check_de differ; .ran manifest |
| `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` | S5 | build_pin_manifest.py; pin-manifest.json; check_ed |

## THE POPULATION ROWS THE TRIGGERS MATCHED — 8, AND WHAT EACH ADDS

| population row | subjects | the triggers that matched (verbatim) | member blocks | added beyond the subject triggers and the core |
|---|---|---|---|---|
| **the sim's recorded figures** | S3 S4 | recorded sim figures; which figures move; SUPERSEDED-PENDING; one seed block; shared seeds | 22 | `` ### FOUND AT JG AND NOT FIXED ``; `` ### FOUND AT IE AND NOT FIXED ``; `` ### FOUND AT IF AND NOT FIXED ``; `` ### FOUND AT JE AND NOT FIXED ``; `` ### FOUND AT JC AND NOT FIXED ``; `` ### FOUND AT JB AND NOT FIXED ``; `` ### FOUND AT IZ AND NOT FIXED ``; `` ### FOUND AT HP AND NOT FIXED ``; `` ### THE THREE SPINES ARE BUILT AND ALL THREE RATES ARE SET (FU, FV); WHAT IS STILL FLAGGED `` |
| **the claims** | S0 S4 | reference claims; stale claims | 8 | `` ### FOUND AT HV AND NOT FIXED ``; `` ### FOUND AT GA AND NOT FIXED ``; `` ### FOUND AT GC AND NOT FIXED ``; `` ### FOUND AT GR AND NOT FIXED `` |
| **the figures behind doors** | S1 S2 | every figure a text states; a figure with no door; name the constants | 5 | `` ### FOUND AT HL AND NOT FIXED `` |
| **the closed matter** | S0 | archive what is closed; strike what is closed | 6 | `` ### FOUND AT HO AND NOT FIXED ``; `` ### THE CRIT SURPLUS IS RULED END TO END ``; `` ### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED `` |
| **the latent shapes** | S4 | floor census; floor of a zero | 10 | `` ### FOUND AT IX AND NOT FIXED ``; `` ### FOUND AT IW AND NOT FIXED ``; `` ### FOUND AT IC AND NOT FIXED ``; `` ### FOUND AT IL AND NOT FIXED ``; `` ### FOUND AT HZ AND NOT FIXED ``; `` ### FOUND AT FX AND NOT FIXED `` |
| **the positional picks** | S5 | positional census; MISSES ceiling | 4 | `` ### GY's RULINGS OWED `` |
| **the target picks** | S1 | every pick; _hero_side | 4 | — |
| **the bot's divergences** | S3 | sim bot; crest default; relic in a sim | 7 | `` ### FOUND AT GS AND NOT FIXED ``; `` ### FOUND AT IE AND NOT FIXED ``; `` ### FOUND AT IF AND NOT FIXED ``; `` ### FOUND AT GE AND NOT FIXED `` |

## THE CORE — 15, READ WHOLE

- `` ## WHERE THE PROJECT IS ``
- `` ## THE OPEN QUEUE ``
- `` ### JJ's RULINGS OWED ``
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

**95 blocks: the core (15), the 54 matched and the 26 the population rows added — 216,100 B of HEAD's 387,565, each read whole.**

## OPENED

**The core (15), the 54 matched blocks and the 26 the population rows added: 95 blocks, 216,100 B of the file's 387,565 at HEAD — 55.8% of it.** **Who read what, said plainly**: the core, the warband's cooldowns and Malice, FOUND AT JJ, JI and JD, the share census, the look-list and the test tree were read in the working read; **all 95 were read whole by a reader outside it** (`JK-work/route/opened_reader.md`), who checked thirteen premise items at source on a frozen copy of HEAD, each a row of §0.
- **The records were read where they live**: `data/enemies.json`, `scripts/battle.gd`'s selection, support half, Malice block, intent and re-validation, `_resolve_special`'s enemy arms, the strike loop and `_do_summon`, `scripts/unit.gd`'s `revive`, `_die`, `take_hit` and `effective_armor`, `docs/combat-rules.md`'s intent block, JA's census, JJ's and JI's reports and kept tables, and `check_ji`, `check_jj`, `check_di`, `check_dr`, `check_hi`, `check_jg`, `test_batch_bm`, `check_hu` and `check_ds` for what they pin.

## NEEDED

**The ones JK used, each for what it bore** (core marked):
- `` ## WHERE THE PROJECT IS `` (core) — replaced; JJ's projection checked, JL's written. `` ### JJ's RULINGS OWED `` (core) — answered, archived struck; JK's takes the core's place. `` ### THE PLAYTEST'S OTHER FINDINGS `` (core) — the look-list's row for the spends.
- `` ### THE WARBAND's MALICE `` — the pool, its reserve and its door, which every spend reads; THE WARBAND's SPENDS written below it. `` ### THE WARBAND's COOLDOWNS `` — JI's line, which prices the spends, and its record's needles. `` ### FOUND AT JJ AND NOT FIXED `` — the content hole's eleven and the heal multiplier, each answered in part. `` ### FOUND AT JI AND NOT FIXED `` — the support fallback's ally target, which JK widens. `` ### FOUND AT JD AND NOT FIXED `` — the strike on a corpse and `revive`. `` ### THE SHARE CENSUS `` — the warband's armor cut, which prices the Entrench, and its cooldown counts. `` ### THE BARGAIN DECK's GRADES `` — the stale-figure sentence, and `check_ji` §2's window beside it. `` ### FOUND AT HW AND NOT FIXED ``, `` ### FOUND AT HF AND NOT FIXED `` and `` ### FOUND AT GU AND NOT FIXED `` — the companion summon, the one mid-fight body. `` ### Small, and still owed `` — `check_di`'s call sites. `` ### THE TEST TREE, AS OF EF `` and `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` — the new gate's row, the battery's list and the carried reds.
- **Matched and not needed**: the other blocks the triggers routed bore on nothing JK wrote.

## FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED

**Every block JK did not route was read whole at the close — the 53 the routing left closed, and `## THE INDEX` — by a reader outside the working read** who had the brief and the built tree (`JK-work/route/close_read_findings.md`). **Of the 54, one bore plainly, three arguably, and the index bore as it does every batch.** None was routed; each that bore is listed with its diagnostic, and each row now carries the trigger that would have routed it.
- `` ### GM's RULINGS OWED `` — PLAINLY: a hero's Dispel strips *beneficial effects from an enemy*, derived as anything in neither `DEBUFF_IDS` nor `DISPEL_NEVER`, so it strips a body's Rally or Entrenched; the master document's Dispel note and two code comments said a ward was the only one, and say otherwise now; the spends block records it. NOT ROUTED: its row now carries *enemy buff*, *beneficial status on an enemy*, *warband status*, *_dispellable_buffs*.
- `` ### GO's RULINGS OWED `` — ARGUABLY: a raised body killed again is a second kill, so the Reaver's uncapped count (ruling 1's magnitude, still owed) can pass the warband's size (FOUND AT JK). NOT ROUTED: *second kill*, *kill count*, *raised body*.
- `` ### FOUND AT HA AND NOT FIXED `` — ARGUABLY: its `check_di` line citation drifted again with JK's comment in that gate. NOT ROUTED: *check_di*.
- `` ### GN's RULINGS OWED `` — ARGUABLY: its ruling 5 is the shape a name sweep reports in — exact, contained, sharing a word — which JK's ruling 7 now follows. NOT ROUTED: *label collision*, *name sweep*.
- `` ## THE INDEX `` — JK wrote three entries, took one out with its archived block, mended five by hand and re-stamped nine its edits moved; every stamp current, every block one entry; the close-read's triggers for JK's own two rows were taken. NOT ROUTED: the index's own rule has every batch read it.

## THE INDEX's UPKEEP

**17 of 159 entries in the final index touched at JK, 8 by hand** (3 written: JK's RULINGS OWED, which takes the core's place JJ's held; THE WARBAND's SPENDS; FOUND AT JK. 1 gone with its block to the archive: JJ's RULINGS OWED. 5 mended: the sim's recorded figures, which gains THE WARBAND's SPENDS and JK's record; and GM's, GO's and GN's RULINGS OWED and FOUND AT HA, each taking the triggers the close-read named). **The other 9 are stamp moves** that `index_stamp.py --write` made because their blocks' text moved: the WHERE block, the look-list's block, the bot's divergences, the grades, the share census, the cooldowns, the pool, FOUND AT JJ and the ladder. Every row stands under `check_is` §5's 400 bytes.
