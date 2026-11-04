# JI — THE ROUTING OF RECORD

Part of JI's report (`docs/reports/JI.md`). **Written before the work began** (the subjects and the matches on 2026-11-03, before any edit): the brief's subjects, the index rows whose triggers name them — each with the trigger that matched, verbatim from its row — the population rows whose triggers name a subject, the blocks those population rows add, and the core. **That list plus the core is what JI opens, the core whole.** The file read is HEAD's `docs/state.md` (`141b0be`, 153 entries: 129 rows, 15 core, 9 population rows).

## THE BRIEF'S SUBJECTS

- **S1** §1 every big move takes a cooldown: the unit is the enemy's own turns, and where it ticks (`start_cooldown`, `_tick_cooldowns`); the population derived from `data/enemies.json` by the 1.5× rule — damage, or effect priced as damage, against the enemy's own basic attack — printed with each ability's multiple and the count of the 50, the line moved if it falls in a silly place; 2 to 4 of the enemy's turns, longer for the biggest, never a basic; premise 1, the picker (the live `_enemy_turn` and the sim's bot); premise 2, an enemy whose whole kit clears the line; premise 3, the cooldown on the plate (HZ's chips and strip)
- **S2** §2 Encumbered becomes two-sided or we find out why not: its implementation read for side-agnosticism; if it is, it becomes two-sided for free and `docs/state.md`'s list of the one-sided cards loses a row; if hero-only, a finding for JJ; its grade does not move, its reading (+1.09 ± 0.31) stale and re-read in the fifth batch
- **S3** §3 does it do anything: one arm, sixty runs, fight-seeded, the reference four untalented at Warden, paired by seed against HEAD; how much easier — completions, the party's health at a fight's end, falls — the before figure for the fifth batch; no change read as the finding it would be
- **S4** §4 what is deliberately not done: no pool, healer, reviver, banner or debuff; no enemy's damage, health, armour or kit beyond a `cooldown` key and a basic where premise 2 needs one; no modifier authored, removed, re-keyed or re-valued, no grade moved, the deck closed at twenty-five; no crest rune, relic, event, card or talent, Communion as JH left it; no figure tuned; neither ceiling cut, the room and the projected figure reported; the eight strays and their count; `test_batch_bm` §9's window, `Gate.within`, the 187 cheap gates, the thirteen picks, `check_it` §2c, `check_hn` §2a, the latent floor shapes, the Cryomancer's route, the playthrough
- **S5** §5 the verification: the push check; the routing, the blocks' reader, the premises before any edit; §3's prediction as a file first; the literal sweep; the documents replayed from HEAD behind a hash guard; the new text's reader and the close-read before any pre-run; a recon, because `data/enemies.json` moves; the pre-run; `check_ji`; all 489 positional reads; C01 to C08, H01, H02 and R01 on the tree that lands; the fresh reader; the acceptance; the landing; the two readings at the open and the close with JH's projected figure

## THE ROWS THE TRIGGERS MATCHED — 31

| block | subjects | the triggers that matched (verbatim from its row) |
|---|---|---|
| `` ### THE BARGAIN DECK's GRADES `` | S2 S3 S4 | Encumbered; reference party; fight seed; deck closed |
| `` ### THE SHARE CENSUS `` | S2 | share census; heroes vs warband; binds one side; one-sided in effect |
| `` ### THE SIM's FIGURES, RE-TAKEN AT IW `` | S3 | SUPERSEDED-PENDING; re-take; recorded sim figures |
| `` ### FOUND AT JH AND NOT FIXED `` | S5 | census since IT |
| `` ### FOUND AT JD AND NOT FIXED `` | S4 | KNOWN_STRAYS |
| `` ### FOUND AT JA AND NOT FIXED `` | S1 S5 | enemy cooldowns; DOD_SUITE_TIMEOUT; battery watchdog |
| `` ### FOUND AT IY AND NOT FIXED `` | S3 | seed per fight; paired by seed |
| `` ### THE RULES A GATE COULD CHEAPLY HOLD `` | S4 | cheap gate |
| `` ### FOUND AT IU AND NOT FIXED `` | S4 | cheap gate |
| `` ### FOUND AT IT AND NOT FIXED `` | S5 | positional census MISSES ceiling |
| `` ### FOUND AT IS AND NOT FIXED `` | S4 | Cryomancer's route |
| `` ### FOUND AT IR AND NOT FIXED `` | S4 | floor census; latent floor of a zero |
| `` ### FOUND AT IQ AND NOT FIXED `` | S4 | check_hn 2a worn arm |
| `` ### FOUND AT IO AND NOT FIXED `` | S1 | _cheapest_attack; Long Silence enemy exemption; Heads Down; enemy 0-cost attack; enemy kit order |
| `` ### FOUND AT IK AND NOT FIXED `` | S1 | Sundering Strike; Tyrant's Verdict; enemies.json |
| `` ### FOUND AT IJ AND NOT FIXED `` | S1 | Siege Stone ally |
| `` ### FOUND AT HT AND NOT FIXED `` | S5 | run_battery.sh game open; player-file arm |
| `` ### FOUND AT GN AND NOT FIXED `` | S5 | check_gj 4 sanctioned red; baselines.json |
| `` ### FOUND AT GJ AND NOT FIXED `` | S3 | recorded sim figures; re-take owed |
| `` ### EVERY COMPLETION FIGURE DATED BEFORE GJ EXCLUDED THE FINAL FIGHT `` | S3 | run completion rate; untalented completion |
| `` ### THE FIRST CLEAN PLAYTHROUGH `` | S4 | second playthrough |
| `` ### THE LADDER `` | S1 | rung-tagged enemy abilities; enemies.json rung tag |
| `` ### Named by the designer, carried from CX `` | S1 | enemy debuff duration vs cooldown; enemy interference status |
| `` ### Carried, and still awaiting a ruling `` | S4 | CLAUDE.md ceiling |
| `` ### Carried, with measurements attached `` | S3 | recorded sim figures; sim readings carried |
| `` ### Carried from the code, reported and deliberately not fixed `` | S3 | SUPERSEDED-PENDING |
| `` ### Knowledge sync, re-measured at EG `` | S4 | claude_md_census.py; CLAUDE.md ceiling |
| `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` | S5 | sanctioned reds; check_cm_live; check_gj |
| `` ### THE REST `` | S5 | sanctioned red baselines.json |
| `` ### THE TEST TREE, AS OF EF `` | S5 | baselines.json rows; new gate rows; run_battery.sh GATES; check_de differ; .ran manifest |
| `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` | S5 | build_pin_manifest.py; pin-manifest.json; check_ed |

## THE POPULATION ROWS THE TRIGGERS MATCHED — 6, AND WHAT EACH ADDS

| population row | subjects | the triggers that matched (verbatim) | member blocks | added beyond the subject triggers and the core |
|---|---|---|---|---|
| **the sim's recorded figures** | S3 | recorded sim figures; which figures move; SUPERSEDED-PENDING; figures a fix could move; one seed block; shared seeds | 14 | `` ### FOUND AT JG AND NOT FIXED ``; `` ### FOUND AT JF AND NOT FIXED ``; `` ### HOW LONG A FIGHT IS ``; `` ### Small, and still owed ``; `` ### FOUND AT IE AND NOT FIXED ``; `` ### FOUND AT IF AND NOT FIXED `` |
| **the claims** | S1 S2 | reference claims; stale claims | 8 | `` ### FOUND AT HV AND NOT FIXED ``; `` ### FOUND AT HY AND NOT FIXED ``; `` ### FOUND AT GA AND NOT FIXED ``; `` ### FOUND AT GF AND NOT FIXED ``; `` ### FOUND AT GC AND NOT FIXED ``; `` ### FOUND AT FW AND NOT FIXED ``; `` ### FOUND AT GR AND NOT FIXED `` |
| **the figures behind doors** | S1 | every figure a text states; a figure with no door | 5 | `` ### FOUND AT HL AND NOT FIXED `` |
| **the latent shapes** | S4 | floor census; floor of a zero | 10 | `` ### FOUND AT IX AND NOT FIXED ``; `` ### FOUND AT IW AND NOT FIXED ``; `` ### FOUND AT IC AND NOT FIXED ``; `` ### FOUND AT IL AND NOT FIXED ``; `` ### FOUND AT IM AND NOT FIXED ``; `` ### FOUND AT HY AND NOT FIXED ``; `` ### FOUND AT HZ AND NOT FIXED ``; `` ### FOUND AT FX AND NOT FIXED `` |
| **the positional picks** | S5 | positional census; MISSES ceiling | 4 | `` ### FOUND AT IM AND NOT FIXED ``; `` ### GY's RULINGS OWED `` |
| **the target picks** | S1 | _hero_side | 4 | `` ### FOUND AT HF AND NOT FIXED ``; `` ### FOUND AT IM AND NOT FIXED `` |

## THE CORE — 15, READ WHOLE

- `` ## WHERE THE PROJECT IS ``
- `` ## THE OPEN QUEUE ``
- `` ### JH's RULINGS OWED ``
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

**69 blocks: the core (15), the 31 matched and the 23 the population rows added — 166,750 B of HEAD's 365,181, each read whole.**

## OPENED

**The core (15), the 31 matched blocks and the 23 the population rows added: 69 blocks, 166,750 B of the file's 365,181 at HEAD.** **Who read what, said plainly**: the core, the grades, the share census and the carried items were read in the working read; **all 69 were read whole by a reader outside it** (`JI-work/route/opened_reader.md`), who checked fifteen premise items at source on a frozen copy of HEAD, each a row of §0.
- **The records were read where they live**: `data/enemies.json`, `scripts/battle.gd`'s intent and turn loop, `scripts/unit.gd`'s cooldowns and display chips, `docs/combat-rules.md`'s intent block, JA's report and `docs/reports/JA-shares.tsv` for the census, IZ's report for Encumbered's grade, and JF's for the reference four at Warden.

## NEEDED

**The ones JI used, each for what it bore** (core marked):
- `` ## WHERE THE PROJECT IS `` (core) — replaced. `` ### JH's RULINGS OWED `` (core) — carried to JJ's §0 by the brief; left whole, JI's five above it. `` ### THE PLAYTEST'S OTHER FINDINGS `` (core) — the look-list's `CD` chip row. `` ### THE CREST POOL `` (core) — Communion's 37% read on a warband with no cooldowns, named in the grades' bullet, JI's RULINGS OWED 5 and the WHERE block, the block left.
- `` ### THE BARGAIN DECK's GRADES `` — Encumbered's three readings marked stale by one bullet beside them, which names every other pre-JI sim figure the file holds; its grade unmoved. `` ### THE SHARE CENSUS `` — its cooldown row, its sentence and its axes' conclusion marked; the census left JA's. The population row *the sim's recorded figures* — six members and JI's record added (the close-read). `` ### THE SIM's FIGURES, RE-TAKEN AT IW `` — the rule a re-take follows, read and not applied (JI's RULINGS OWED 5); THE WARBAND's COOLDOWNS written above it. `` ### FOUND AT JA AND NOT FIXED `` — the enemy-cooldown item closed and archived. `` ### FOUND AT IO AND NOT FIXED `` — `_cheapest_attack` and the Long Silence's declaration, the shape JI's RULINGS OWED 1 names as the alternative. `` ### FOUND AT IK AND NOT FIXED `` — Tyrant's Verdict's figures, read for the population. `` ### FOUND AT IJ AND NOT FIXED `` — Siege Stone's wind-up, which a cooldown bounds beside it. `` ### THE LADDER `` — the rung tags, carried into `JI-population.tsv`. `` ### Named by the designer, carried from CX `` — the debuff item, read (FOUND AT JI). `` ### FOUND AT JD AND NOT FIXED `` — `KNOWN_STRAYS`' count. `` ### FOUND AT IT AND NOT FIXED `` — the positional census, re-run. `` ### FOUND AT GN AND NOT FIXED `` and `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` — the sanctioned reds the recon and the acceptance carry. `` ### THE TEST TREE, AS OF EF `` — the new gate's baseline row and the battery's list. `` ### Carried, and still awaiting a ruling `` — the two ceilings, not cut.
- **Matched and not needed**: the other blocks the triggers routed bore on nothing JI wrote.

## FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED

**Every block JI did not route was read whole at the close — the 75 the routing left closed, and `## THE INDEX` — by a reader outside the working read** who had the brief and the built tree (`JI-work/route/close_read_findings.md`). **Of the 76, 4 bore, 9 arguably bore, and 1 is a block a trigger would have routed and JI did not open.** None lost anything, and none holds a line JI's change made false. Each is listed below with its diagnostic.
- `` ### THE TALENT LAYER IS BUILT (FX); FIVE THINGS IN IT, AND SEVEN OF FW'S EDGES, ARE THE DESIGNER'S `` — its item 5 says the basic attack has three definitions in the code, and JI's rule *a basic never takes one* named none of them; repaired: the rule names `_cheapest_attack`'s, the first free damaging move, which on the enemy data is each kind's first ability. **A trigger would have ROUTED it**: *basic attack*, which S1 holds verbatim.
- `` ## THE INDEX `` — JI wrote three rows, mended three and re-stamped six; every stamp current, every block one row, the rows in file order. NOT ROUTED: the index's own rule has every batch read it.
- `` ### FOUND AT GY AND NOT FIXED ``, `` ### FOUR GATES CAN WRITE THE PLAYER'S `relics.json` `` and `` ### THE `master.html` STAMP `` — each consistent with what JI did: the design note newest first, `check_ji` redirecting the player's files, the stamp moved to JI. NOT ROUTED: no trigger names a JI subject in them.
- `` ### THE DRAFT AUDIT `` — it records DU §1's ruling, which JI's RULINGS OWED 3 weighs for the Rage moves and sets aside; consistent. NOT ROUTED: no trigger names DU §1.
- `` ### GR's RULINGS OWED `` — `docs/combat-rules.md` has no ceiling, and JI grew it; consistent. NOT ROUTED: the trigger *combat-rules.md ceiling* names a file S4 does not.
- `` ### FOUND AT JE ``, `` ### FOUND AT JB ``, `` ### FOUND AT JC ``, `` ### FOUND AT IZ ``, `` ### FOUND AT HP `` and `` ### THE THREE SPINES ARE BUILT `` — each holds a sim figure read on a warband with no cooldowns, with no mark on it, and JI's RULINGS OWED 5 covered them only in name, the sentence it cited saying *as every grade here was*. **Repaired before the pre-run**: the grades' bullet names every sim figure the file holds from before JI, and the six joined *the sim's recorded figures* as members, with JI's record among its records. NOT ROUTED: none was a member of that row, the population row S3 matched.

**In JI's own text the reader found twelve things, each repaired before the pre-run**: the coverage sentence above, which reached the grades and nothing else; the basic's definition, unnamed; Encumbered's readings, not marked where RULINGS OWED 5 said, and a third reading never named; the projected room's arithmetic, which left out the archive's 0.50 KiB; *their bars*, with no bar to refer to; the instruments line, which left out `baselines.json` and the pin manifest; the axes sentence's conclusion, which fought its new parenthesis; `CLAUDE.md`'s present tense; the Orc Chief, misnamed in the changelog; the fifth batch's re-read, overpromised in the changelog; two wording slips; and the population row's missing records and members. **Beyond JI's own text, two comments and one rule still called the selection untouched** (`battle.gd`'s Heads Down comment and the Long Silence's, and `combat-rules.md`'s state-sensitive bullet), and `master.html` §4.8 omitted the cooldown skip: each now says the selection's policy is untouched and the door's refusals it asks are rules, and §4.8 says a move still cooling is never chosen. `check_ds`'s own comment still says the enemy *SELECTS freely*, which stays true of the policy; a closed gate's comment, left.

## THE INDEX's UPKEEP

**12 of 156 entries in the final index touched at JI, 6 by hand** (3 written: JI's RULINGS OWED, which takes the core's place JH's held; THE WARBAND's COOLDOWNS; FOUND AT JI. 3 mended: JH's RULINGS OWED, which leaves the core for its own row; FOUND AT JA, which lost *enemy cooldowns* with its archived item; and the sim's recorded figures, which gains THE WARBAND's COOLDOWNS, six blocks that held sim figures outside it (the close-read) and JI's record). **The other 6 are stamp moves** that `index_stamp.py --write` made because their blocks' text moved; the grades' and the census's rows took no new trigger, each standing within a few bytes of `check_is` §5's 400 (positional reader B found the first draft's three rows past it). None gone.
