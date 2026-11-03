# JE — THE ROUTING OF RECORD

Part of JE's report (`docs/reports/JE.md`). **Written before the work began** (the subjects and the matches on 2026-11-02, before any edit): the brief's subjects, the index rows whose triggers name them — each with the trigger that matched, verbatim from its row — the population rows whose triggers name a subject, the blocks those population rows add, and the core. **That list plus the core is what JE opens, the core whole.** The file read is HEAD's `docs/state.md` (`8679027`, 154 entries: 130 rows, 15 core, 9 population rows).

## THE BRIEF'S SUBJECTS

- **S1** §0.1 the trace resized — the relics reach the hero who fell, what a fall costs is the base clearing heal, fifteen points fixed; `victory_heal_pct` split into its base and its adds; Cairnmoss Poultice buys back the fifteen
- **S2** §0.2 the third zone's boss restores like the other two, the end boss fought whole, the mark goes with the wound; the 68, 32 and 30% re-read and printed
- **S3** §0.3 Ambushed's two readings pooled by inverse variance, the rule written as a refinement beside IZ §0.1's sharper-replaces; no grade moved
- **S4** §0.4 the Cairn to weight 12, and the four pool rows printed at it; *do not gate twice*
- **S5** §0.5 a hero raised takes the heal and draws no Cairn, accepted; the key's name stands; the glossary entry, if one names the mark, says what it means
- **S6** §1 the arms re-pointed and driven on a real board, with the prediction written as a file first; §0.2's three figures printed
- **S7** §2 the pooled figure in the grades table with both arms beside it; the deck closed at twenty-five
- **S8** §3 `CLAUDE.md` is cut: HERO AND ALLY's law moved to the text standard and its history to the archive, the ALLY/HERO THREAD archived whole, the four struck lines archived; II §4's rule; the reading at the open and the close, the net
- **S9** §4 the three crest runes: the turns between a fall and the fight's end by rung and by who fell, the Cleric's and the Mage's shares of falls; HQ §1's method; Dirge's question retired by the ruling
- **S10** §5 the spiral re-read on the new shape: falls, the same hero falling again, the lost finishes, the paired figure
- **S11** §6 housekeeping — the move not attempted, `./lane.sh spent`, the strays in `KNOWN_STRAYS`; lane names from `lane.sh`; every wait a DONE line and a bound; the designer's files through copies; the suite timeout override; both ceilings at JC's rate; the close's timestamp
- **S12** §7 the verification and its two cuts — the positional re-run's subset derived; a recon owed for code and gates, not for words; `check_je`, the controls C01 to C13, H01, H02 and R01; the outside readers; the push check and the two readings

## THE ROWS THE TRIGGERS MATCHED — 36

| block | subjects | the triggers that matched (verbatim from its row) |
|---|---|---|
| `` ### FOUND AT JD AND NOT FIXED `` | S1 S2 S4 S5 | fell_last_fight; clearing_heal; clearing heal; RETURN_FLOOR_PCT; return floor; sync_victory_state; heal_party; Cairn of the Fallen; Cairnmoss Poultice; revive_pct; is_suspended; JD premises |
| `` ### FOUND AT JC AND NOT FIXED `` | S12 | JC premises |
| `` ### FOUND AT GB AND NOT FIXED `` | S1 | clearing heal comment |
| `` ### Named by the designer, carried from CX `` | S1 | victory_heal_pct; fallen_recover; relic read sites |
| `` ### FOUND AT FW AND NOT FIXED `` | S1 | relics.gd hook read sites |
| `` ### FOUND AT GE AND NOT FIXED `` | S1 | relics.gd header |
| `` ### FOUND AT GJ AND NOT FIXED `` | S2 S10 | end boss Hollow Crown fight length; recorded sim figures |
| `` ### GJ's RULINGS OWED `` | S2 | end_boss_mult; end boss rung floor |
| `` ### FOUND AT GH AND NOT FIXED `` | S2 | resumed battle; party losses carry across quit |
| `` ### FOUND AT HO AND NOT FIXED `` | S4 | check_gv 4 event door |
| `` ### THE BARGAIN DECK's GRADES `` | S3 S7 | bargain modifier severity grades; re-grade; reference party; highest cost measured; sharper reading; fight seed; Ambushed; deck closed |
| `` ### FOUND AT JB AND NOT FIXED `` | S3 | Ambushed curve |
| `` ### FOUND AT IY AND NOT FIXED `` | S3 S9 S10 | seed per fight; paired by seed |
| `` ### FOUND AT IX AND NOT FIXED `` | S10 | reference party healing; check_hk walk not seeded |
| `` ### THE SHARE CENSUS `` | S9 | share census; census price |
| `` ### THE SIM's FIGURES, RE-TAKEN AT IW `` | S9 S10 | re-take; recorded sim figures |
| `` ### HOW LONG A FIGHT IS `` | S9 | fight length rounds; turns per hero; sim confounders |
| `` ### FOUND AT HN AND NOT FIXED `` | S9 | crest rune conditions; heroes_ keys |
| `` ### FOUND AT HP AND NOT FIXED `` | S9 | Tithe crest rune |
| `` ### THE FIRST CLEAN PLAYTHROUGH `` | S9 S11 | playtest readout; second playthrough |
| `` ### Carried, and still awaiting a ruling `` | S8 | CLAUDE.md ceiling |
| `` ### Knowledge sync, re-measured at EG `` | S8 | CLAUDE.md ceiling; claude_md_census.py |
| `` ### FOUND AT GR AND NOT FIXED `` | S8 | which file a rule lives in; moved combat blocks |
| `` ### THE SEVENTH FAMILY, FOUND AT DM AND DELIBERATELY NOT SWEPT `` | S8 | DM 1 test |
| `` ### THE RULES A GATE COULD CHEAPLY HOLD `` | S8 | rules census; standing list |
| `` ### THE TEST TREE, AS OF EF `` | S12 | baselines.json rows; new gate rows; run_battery.sh GATES; check_de differ; .ran manifest |
| `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` | S12 | build_pin_manifest.py; pin-manifest.json; check_ed |
| `` ### FOUND AT GN AND NOT FIXED `` | S12 | check_gj 4 sanctioned red; baselines.json |
| `` ### THE REST `` | S12 | sanctioned red baselines.json |
| `` ### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED `` | S11 | baselines.json flake field |
| `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` | S12 | sanctioned reds; check_cm_live; check_gj |
| `` ### FOUND AT GK AND NOT FIXED `` | S11 | save-backups untracked |
| `` ### FOUND AT HT AND NOT FIXED `` | S11 S12 | player-file arm; run_battery.sh game open |
| `` ### FOUND AT HW AND NOT FIXED `` | S12 | run_battery.sh game open; kill battery |
| `` ### FOUND AT IT AND NOT FIXED `` | S12 | positional census MISSES ceiling; typed figure |
| `` ### FOUND AT JA AND NOT FIXED `` | S11 | DOD_SUITE_TIMEOUT; battery watchdog |

## THE POPULATION ROWS THE TRIGGERS MATCHED — 7, AND WHAT EACH ADDS

| population row | subjects | the triggers that matched (verbatim) | member blocks | added beyond the subject triggers and the core |
|---|---|---|---|---|
| **the sim's recorded figures** | S9 S10 S12 | recorded sim figures; sim figures; re-take; instrument fidelity; which figures move | 11 | `` ### EVERY COMPLETION FIGURE DATED BEFORE GJ EXCLUDED THE FINAL FIGHT ``; `` ### Carried, with measurements attached ``; `` ### Small, and still owed ``; `` ### FOUND AT IE AND NOT FIXED ``; `` ### FOUND AT IF AND NOT FIXED ``; `` ### Carried from the code, reported and deliberately not fixed `` |
| **the figures behind doors** | S1 S6 | every figure a text states; figures behind doors; typed figure | 6 | `` ### FOUND AT IK AND NOT FIXED ``; `` ### FOUND AT IJ AND NOT FIXED ``; `` ### FOUND AT IQ AND NOT FIXED ``; `` ### FOUND AT HL AND NOT FIXED ``; `` ### `master.html` §6b's "66 DAMAGING ABILITIES" RESOLVES AGAINST NO POPULATION `` |
| **the save's keys** | S1 S2 | the save's keys; a key off a save; load door | 3 | `` ## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND ``; `` ### HA's RULINGS OWED ``; `` ### FOUND AT HL AND NOT FIXED `` |
| **the claims** | S1 S8 | stale claims; reference claims | 8 | `` ### FOUND AT IU AND NOT FIXED ``; `` ### FOUND AT HV AND NOT FIXED ``; `` ### FOUND AT HY AND NOT FIXED ``; `` ### FOUND AT GA AND NOT FIXED ``; `` ### FOUND AT GF AND NOT FIXED ``; `` ### FOUND AT GC AND NOT FIXED `` |
| **the closed matter** | S8 | the closed matter; closed blocks; archive what is closed; closed items | 7 | `` ### FOUND AT IS AND NOT FIXED ``; `` ### FOUND AT GL AND NOT FIXED ``; `` ### FOUND AT GF AND NOT FIXED ``; `` ### THE CRIT SURPLUS IS RULED END TO END ``; `` ### `BOND_MITIGATION_MAX` STAYS AT 0.75 `` |
| **the positional picks** | S12 | positional picks; positional census; MISSES ceiling | 4 | `` ### FOUND AT IQ AND NOT FIXED ``; `` ### FOUND AT IM AND NOT FIXED ``; `` ### GY's RULINGS OWED `` |
| **the bot's divergences** | S2 S10 | sim bot; the bot's rules | 6 | `` ### FOUND AT GS AND NOT FIXED ``; `` ### FOUND AT IE AND NOT FIXED ``; `` ### FOUND AT IF AND NOT FIXED ``; `` ### FOUND AT IM AND NOT FIXED `` |

## THE CORE — 15, READ WHOLE

- `` ## WHERE THE PROJECT IS ``
- `` ## THE OPEN QUEUE ``
- `` ### JD's RULINGS OWED ``
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

**77 blocks: the core (15), the 36 matched and the 26 the population rows added — 180,806 B of HEAD's 354,543, each read whole.**

## OPENED

**The core (15), the 36 matched blocks and the 26 the population rows added: 77 blocks, 180,806 B of the file's 354,543 at HEAD.** **Who read what, said plainly**: the core was read whole in the working read, with the grades block and FOUND AT JD; **the other 62 (147,029 B) were read whole by a reader outside it**, given the brief and asked what bears, its table kept (`JE-work/route/opened_reader.md`).
- **The records were read in the reports they live in**: JD's report, `docs/reports/JD-arm.tsv`, `JC-fallen-rate.tsv`, `JB-grades.tsv`, HQ's §1 and HP's §2a for §4's method.

## NEEDED

**The ones JE used, each for what it bore** (core marked):
- `` ## WHERE THE PROJECT IS `` (core) — replaced. `` ### JD's RULINGS OWED `` (core) — the five the brief answered; archived whole, JE's in its place. `` ### THE CREST POOL `` (core) — the turn count and the price. `` ### THE PLAYTEST'S OTHER FINDINGS `` (core) — the look-list's row.
- `` ### FOUND AT JD AND NOT FIXED `` — its premises and what went beyond the brief, archived. `` ### THE BARGAIN DECK's GRADES `` — the pooled row, the rule beside IZ's, Porous and Fleeting. `` ### FOUND AT JB AND NOT FIXED `` — the tie at the cut. `` ### Named by the designer, carried from CX `` and `` ### FOUND AT FW AND NOT FIXED `` — the hook's read sites. `` ### HOW LONG A FIGHT IS `` — what a hero turn counts. `` ### THE TEST TREE, AS OF EF `` — the two baseline rows.

## FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED

**Every block JE did not route was read at the close, whole — 71 blocks, 175,556 B — by a reader outside the working read**, given the finished tree, and the routed ones where a word of the batch's could touch them. **Sixty-seven of the 71 bear on nothing JE touched; four do:**
- `` ## THE INDEX `` — bore, **ROUTED** (the section's own read-whole rule; it has no row).
- `` ### JE's RULINGS OWED `` — bore, **ROUTED** (the core's by role, written at JE).
- `` ### FOUND AT JE AND NOT FIXED `` — bore, **ROUTED** (its own row, written at JE).
- `` ### The changelog `` — bore, **NOT ROUTED**: it states the archive folder's size, which the batch's cut moves, and no trigger named it, so **the row is repaired** (it takes *folder size*).
**It found sixteen statements of `docs/state.md` false or stale after my edits and two outside it**, the heaviest that the completion figures stood on the return with the Ambushed arms unread, each repaired in the replay scripts before the tree was frozen; two it marked as older than this batch (the changelog's and the sync's archive sizes) are left and named in the report.

## THE INDEX's UPKEEP

**16 of 155 entries in the final index touched at JE, 7 by hand** (2 written: JE's RULINGS OWED, in the core's place by role — JD's row renamed, its block archived — and FOUND AT JE; 5 mended: the two population rows the batch's readings moved, THE BARGAIN DECK's GRADES, FOUND AT JD, losing triggers on what JE closed, and the changelog's row, which took *folder size* from the close-read). **The other 9 are stamp moves** that `index_stamp.py --write` made because their blocks' text moved: the WHERE block, THE CREST POOL, THE PLAYTEST'S OTHER FINDINGS, THE SHAPE RECON, the claims' population row, FOUND AT JB, the cheap gates, FOUND AT FW and the block carried from CX. **Upkeep as a rate: 7 hand entries in a batch of five rulings and a cut.**
