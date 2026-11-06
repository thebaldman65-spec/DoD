# JN — THE ROUTING OF RECORD

Part of JN's report (`docs/reports/JN.md`). **Written before the work began** (the subjects and the matches on 2026-11-06, before any edit): the brief's subjects, the index rows whose triggers name them — each with the trigger that matched, verbatim from its row — the population rows whose triggers name a subject, the blocks those population rows add, and the core. **That list plus the core is what JN opens, the core whole.** The file read is HEAD's `docs/state.md` (`994f747`, 163 entries: 139 rows, 15 core, 9 population rows).

## THE BRIEF'S SUBJECTS

- **S0** §0 JM's ten rulings accepted as taken, each a document edit; four corrections of the brief recorded (*HZ's tree* is JH's, Fleeting a grade 2, Encumbered a 1, three of the five grades on a run seed, the six owed index triggers JL's); and the designer's three cold decisions built as housekeeping: the Cleric's Mana gain halved at the one door named, Thin Air re-read after the cut against JM's +21.86 ± 1.10 (a band move recorded, not repaired; Parched 2, Warded 2 and Thin Air 5 key on hero resource); Boil Over at 1.5 extra damage per point of Rage, flat — what it is now, the Rage the Warrior carries when he casts it read off the sim, what the flat form does at the top of that range; Sanctity's step read out — what it is, what it steps, what reads it, what waits on it, retirement recommended if nothing, nothing changed
- **S1** §1 every enemy kind's second damaging move prices at 1.4× its own basic or better and therefore cools: the population derived off the data by JI's rule (damage plus the Burn or Poison it lays, a Poison skipping the turn it lands, times the heroes it reaches, a companion not counted), the before and after kept as a `.tsv`; the move's damage raised until it clears, its status, delay and reach unchanged; a kind already clear untouched; no basic changed; premises — the kit row's third field and whether a move's worth reads it, which named kinds hold an `aoe` second move and how small their change is, a kind whose only other move deals nothing (Shielding, Healing Wave, Cleansing Rite, Blood Tribute) left out and named, each changed move's cooldown band re-derived off the rule
- **S2** §2 two arms: Arm A, sixty runs fight-seeded, the reference four untalented at Warden, paired by seed against JM's tree — completions, falls a run, falls a fight, health at a fight's end, hero turns a fight, fights won a run and the warband's blows a fight, the prediction harder; Arm B, the game with talents — JM's played line (three relics a run, the bargains dealt, the crest as the bot wears it) plus the talents a player would have taken; the premise whether the bot can take talents and by what policy, a policy named as a divergence in the census; completion rate, falls a run, health at a fight's end, fights won a run, and whether 1 of 60 is the game or the missing talents
- **S3** §3 what is deliberately not done: no basic change, no new move, kind, status or ability; no grade re-authored, no card added, removed or re-keyed, the deck closed at twenty-five; Gall stays on the Orc Archer and every hero, the hex pricing convention known-wrong and recorded, not re-derived; no fill, heal or spend change, the spends' cooldowns not re-derived; Fester uncooled; left as JM found them — the crest divergence, Fleeting and Encumbered at a tie, Thin Air's completions, the eight trimming plate pairings, the Regalia trap, a body over 377, Raise skipping Bloodless, a second kill and the Reaver's count, Called Shot's mode and the sim's raw armour, the Bomb's blast credit, the glossary's missing Malice entry, the ten strays in `KNOWN_STRAYS`; `CLAUDE.md` not cut, the state's ceiling at 440; `test_batch_bm` §9's window, `Gate.within`, the cheap gates, the thirteen picks, `check_it` §2c, `check_hn` §2a, the latent floor shapes, the Cryomancer's route, the playthrough
- **S4** §4 the verification: the push check; the routing before any edit; the blocks' reader's findings before the first edit script; the premises at source; each arm's prediction written first; the literal sweep; the documents replayed from HEAD behind a hash guard; the new text's reader and the close-read; a recon for `data/enemies.json`, the Cleric's resource door and Boil Over; the pre-run; `check_jn`; all 489 positional reads; C01 to C13, H01, H02 and R01 on the tree that lands; the fresh reader on the assembled report; the acceptance; the report's landing; the two readings at the open and the close against the state's 440 KiB, and the projected figure for JO

## THE ROWS THE TRIGGERS MATCHED — 69

| block | subjects | the triggers that matched (verbatim from its row) |
|---|---|---|
| `` ### THE WARBAND's COOLDOWNS `` | S1 S3 | enemy cooldown; warband cooldowns; cooldown population; 1.4x line; enemy picker; enemy selection; CD chip; Siege Stone cooldown; Reckless Lunge; Healing Wave cooldown; before figure; JI-cooldowns; JI-population; Wretched Bellow; TUNED |
| `` ### FOUND AT JJ AND NOT FIXED `` | S1 | second move weaker; content hole; enemy descriptions literal |
| `` ### FOUND AT JK AND NOT FIXED `` | S1 S3 | content hole; Bloodless raise; second kill; Reaver kill count; Called Shot armor |
| `` ### FOUND AT JI AND NOT FIXED `` | S1 S4 | CD chip; Blood Tribute; unpriced ward; WHERE block pins; PROJECTED FOR |
| `` ### FOUND AT IO AND NOT FIXED `` | S1 | _cheapest_attack; enemy kit order; Heads Down; enemy 0-cost attack |
| `` ### FOUND AT IK AND NOT FIXED `` | S1 | Sundering Strike; Sunder duration; SUNDER_TURNS; enemies.json; Called Shot Armor |
| `` ### FOUND AT IJ AND NOT FIXED `` | S1 | Siege Stone ally |
| `` ### FOUND AT ID AND NOT FIXED `` | S1 | _resolve_special; DAMAGE_SPECIALS |
| `` ### THE LADDER `` | S1 | enemies.json; rung-tagged enemy abilities; enemies.json rung tag |
| `` ### THE SEVENTH FAMILY, FOUND AT DM AND DELIBERATELY NOT SWEPT `` | S1 | enemy description; enemies.json description |
| `` ### Named by the designer, carried from CX `` | S1 S2 | enemy debuff duration vs cooldown; relic read sites |
| `` ### THE WARBAND's HEXES `` | S0 S1 S3 | hex; Gall; Sap; Fester; resource setter; Orc Hexer; Orc Archer; JM-hexes; enemy debuff |
| `` ### THE WARBAND's MALICE `` | S3 | Malice; warband heal; kill fill |
| `` ### THE WARBAND's SPENDS `` | S3 | Malice spend; spend cooldown; free spend |
| `` ### THE SHARE CENSUS `` | S0 S1 S3 | share census; census price; what a share prices; axis table |
| `` ### THE FIRST CLEAN PLAYTHROUGH `` | S0 S3 | Sanctity events; SANCTITY_PER_STEP; Cleric driest hero; Boil Over undrafted; playtest readout |
| `` ### FOUND AT HZ AND NOT FIXED `` | S0 | boil_over status; unit.frenzy_bonus; STATUS_INFO row; Boil Over; dormant status kept |
| `` ### THE SIM's FIGURES, RE-TAKEN AT IW `` | S0 S2 | Rage a turn; recorded sim figures; re-take |
| `` ### Carried, with measurements attached `` | S0 S2 | FRENZY_RAGE_PER_STEP; recorded sim figures |
| `` ### FOUND AT IM AND NOT FIXED `` | S0 | Sanctity figures |
| `` ### FOUND AT IX AND NOT FIXED `` | S0 | severity of 1 to 5; healing takes up a tempo half; reference party healing |
| `` ### THE BARGAIN DECK's GRADES `` | S0 S3 | bargain modifier severity grades; re-grade; grade scale; reference party; the test binds; Fleeting; Encumbered; deck closed; fight seed |
| `` ### THE ARC, READ WHOLE `` | S0 S2 S3 | what the arc did; game as played; DOD_SIM_RELICS; draw3; crest not closed; JM-arc; JM-played; JM-grades; Thin Air; Fleeting; Encumbered |
| `` ### FOUND AT JM AND NOT FIXED `` | S0 S3 | brief premises; HZ's tree; ties at a cut; run-seeded grade; crest choice; Gall leaning easier |
| `` ### FOUND AT JL AND NOT FIXED `` | S1 S3 | brief premises; unpriced enemy debuffs; spend cooldown re-derive |
| `` ### THE TALENT LAYER IS BUILT (FX); FIVE THINGS IN IT, AND SEVEN OF FW'S EDGES, ARE THE DESIGNER'S `` | S2 | TIER_SPEND_MIN; talent node magnitudes; spend gate; bot never reads a skill profile |
| `` ### HOW LONG A FIGHT IS `` | S2 | DOD_SIM_ROWS; turns per hero; sim confounders |
| `` ### THE TALENT CHARTER `` | S2 | talent charter |
| `` ### HJ's RULINGS OWED `` | S2 | sim experiment arm |
| `` ### EVERY COMPLETION FIGURE DATED BEFORE GJ EXCLUDED THE FINAL FIGHT `` | S2 | run completion rate; untalented completion; end boss in sim |
| `` ### THE RUN REPORT'S WIPE TABLE IS BANDED FOR A TWELVE-SLOT ZONE `` | S2 | run completion rate |
| `` ### FOUND AT JF AND NOT FIXED `` | S2 | the bot wears a crest; crest none |
| `` ### FOUND AT JE AND NOT FIXED `` | S2 | crest arm |
| `` ### FOUND AT IY AND NOT FIXED `` | S2 | seed per fight; paired by seed |
| `` ### FOUND AT IN AND NOT FIXED `` | S2 | DV30 bargain policy |
| `` ### FOUR GATES CAN WRITE THE PLAYER'S `relics.json` THE DAY A RELIC IS LOCKED `` | S2 | Relics.unlock_random; relics unlocked; relic assignment at the draft |
| `` ### FOUND AT FW AND NOT FIXED `` | S2 | relics.gd hook read sites |
| `` ### FOUND AT GB AND NOT FIXED `` | S2 | relic unlock |
| `` ### THE RUNE CHARTER `` | S2 | crest choice |
| `` ## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND `` | S2 | relics |
| `` ### Carried from the code, reported and deliberately not fixed `` | S2 | SUPERSEDED-PENDING |
| `` ### FOUND AT GJ AND NOT FIXED `` | S2 S3 | Regalia; sim zone-boss awards; recorded sim figures |
| `` ### FOUND AT JD AND NOT FIXED `` | S3 | KNOWN_STRAYS |
| `` ### THE RULES A GATE COULD CHEAPLY HOLD `` | S3 | cheap gate |
| `` ### FOUND AT IU AND NOT FIXED `` | S3 | cheap gate |
| `` ### FOUND AT IS AND NOT FIXED `` | S3 | Cryomancer's route |
| `` ### FOUND AT IR AND NOT FIXED `` | S3 | floor census; latent floor of a zero |
| `` ### FOUND AT IQ AND NOT FIXED `` | S3 | check_hn 2a worn arm |
| `` ### FOUND AT II AND NOT FIXED `` | S3 | attribution frame; credit nobody |
| `` ### FOUND AT HY AND NOT FIXED `` | S3 | attribution frame |
| `` ### GO's RULINGS OWED `` | S3 | second kill; kill count; raised body |
| `` ### Carried, and still awaiting a ruling `` | S3 | CLAUDE.md ceiling |
| `` ### FOUND AT JH AND NOT FIXED `` | S4 | check_jc; next closed block; census since IT |
| `` ### FOUND AT JA AND NOT FIXED `` | S4 | DOD_SUITE_TIMEOUT; battery watchdog |
| `` ### FOUND AT IT AND NOT FIXED `` | S4 | positional census MISSES ceiling |
| `` ### FOUND AT HT AND NOT FIXED `` | S4 | run_battery.sh game open; player-file arm |
| `` ### THE CROSS-TARGET SUPERSESSIONS `` | S4 | test_batch_ce; supersession table |
| `` ### FOUND AT GN AND NOT FIXED `` | S4 | check_gj 4 sanctioned red; baselines.json |
| `` ### FOUND AT GK AND NOT FIXED `` | S4 | save-backups untracked; git add -A |
| `` ### FY §1: THREE NODES PAID BY WHO ELSE HELD THEM, AND TODAY'S COUNT DOUBLES FOUR ITEMS `` | S4 | name sweep |
| `` ### GN's RULINGS OWED `` | S4 | name sweep; label collision |
| `` ### THE TEST TREE, AS OF EF `` | S4 | run_battery.sh GATES; baselines.json rows; new gate rows; check_de differ |
| `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` | S4 | sanctioned reds; check_cm_live; check_gj |
| `` ### THE REST `` | S4 | sanctioned red baselines.json |
| `` ### FIVE MORE THINGS FH FOUND AND DID NOT FIX `` | S4 | new gate; exit 0 Parse Error |
| `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` | S4 | build_pin_manifest.py; pin-manifest.json; check_ed |
| `` ### The changelog `` | S4 | changelog headroom; next changelog cut owed; changelog cut |
| `` ### THE `master.html` STAMP CAN SIT MANY BATCHES STALE AND PASS `` | S4 | master.html Last updated stamp; test_batch_ce |
| `` ### Knowledge sync, re-measured at EG `` | S4 | claude_md_census.py; CLAUDE.md ceiling |

## THE POPULATION ROWS THE TRIGGERS MATCHED — 7, AND WHAT EACH ADDS

| population row | subjects | the triggers that matched (verbatim) | member blocks | added beyond the subject triggers and the core |
|---|---|---|---|---|
| **the sim's recorded figures** | S0 S1 S2 | recorded sim figures; which figures move; re-take; instrument fidelity; one seed block; shared seeds; worth rule | 25 | `` ### FOUND AT JG AND NOT FIXED ``; `` ### Small, and still owed ``; `` ### FOUND AT IE AND NOT FIXED ``; `` ### FOUND AT IF AND NOT FIXED ``; `` ### FOUND AT JC AND NOT FIXED ``; `` ### FOUND AT JB AND NOT FIXED ``; `` ### FOUND AT IZ AND NOT FIXED ``; `` ### FOUND AT HP AND NOT FIXED ``; `` ### THE THREE SPINES ARE BUILT AND ALL THREE RATES ARE SET (FU, FV); WHAT IS STILL FLAGGED `` |
| **the bot's divergences** | S2 | the bot's divergences; divergence census; POLICY or RULE; sim bot; DOD_SIM_RELICS; crest default | 9 | `` ### FOUND AT GS AND NOT FIXED ``; `` ### FOUND AT IE AND NOT FIXED ``; `` ### FOUND AT IF AND NOT FIXED ``; `` ### FOUND AT GE AND NOT FIXED `` |
| **the claims** | S0 | reference claims; stale claims | 8 | `` ### FOUND AT HV AND NOT FIXED ``; `` ### FOUND AT GA AND NOT FIXED ``; `` ### FOUND AT GF AND NOT FIXED ``; `` ### FOUND AT GC AND NOT FIXED ``; `` ### FOUND AT GR AND NOT FIXED `` |
| **the figures behind doors** | S0 S1 | every figure a text states; a figure with no door; name the constants | 5 | `` ### FOUND AT HL AND NOT FIXED `` |
| **the closed matter** | S0 | archive what is closed; strike what is closed | 6 | `` ### FOUND AT HO AND NOT FIXED ``; `` ### FOUND AT GL AND NOT FIXED ``; `` ### FOUND AT GF AND NOT FIXED ``; `` ### THE CRIT SURPLUS IS RULED END TO END ``; `` ### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED `` |
| **the latent shapes** | S3 | floor census; floor of a zero | 10 | `` ### FOUND AT IW AND NOT FIXED ``; `` ### FOUND AT IC AND NOT FIXED ``; `` ### FOUND AT IL AND NOT FIXED ``; `` ### FOUND AT FX AND NOT FIXED `` |
| **the positional picks** | S4 | positional census; MISSES ceiling | 4 | `` ### GY's RULINGS OWED `` |

## THE CORE — 15, READ WHOLE

- `` ## WHERE THE PROJECT IS ``
- `` ## THE OPEN QUEUE ``
- `` ### JM's RULINGS OWED ``
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

**110 blocks: the core (15), the 69 matched and the 26 the population rows added — 307,028 B of HEAD's 439,725, each read whole.**

## OPENED

**All 110 blocks of the list above, each read whole** — the core (15), the blocks the triggers matched and those the population rows added; and the blocks' reader read the same 110 at source on a frozen copy of HEAD (`route/opened_reader.md`, written at 02:25:33, before the first edit script at 02:26:44).

## NEEDED

**23 of the 110 were needed and changed** — each by JN's work or by what it wrote:

- `` ## WHERE THE PROJECT IS `` — rewritten; closed gates pin its words.
- `` ### JM's RULINGS OWED `` — answered in JN's brief, all accepted as taken; archived struck.
- `` ### THE CLERIC's MANA RATE `` — §0.1: the cut at the bar's setter; IG's rate superseded for the Cleric, recorded.
- `` ### SANCTITY's STEP `` — §0.3: read out, unchanged, and what waits on it.
- `` ### BOIL OVER'S RATE `` — §0.2: flat, 1.5 a point; HZ's present tense of 0.8 put in the past.
- `` ### THE WARBAND's COOLDOWNS `` — §1: JI's line, the ten raised to it, the Bellow's hand-tune retired.
- `` ### THE BARGAIN DECK's GRADES `` — the scale Thin Air is banded on; a pointer to its re-read and the none's fall.
- `` ### THE ARC, READ WHOLE `` — §2's instrument, JM's arc and played lines; its *tree that lands* marked JM's.
- `` ### THE WARBAND's HEXES `` — Sap's price on a cut Cleric.
- `` ### THE WARBAND's SPENDS `` — a pointer to an item JN archived.
- `` ### THE PLAYTEST'S OTHER FINDINGS `` — MANA STAYS superseded for the Cleric; the LOOK-LIST's row.
- `` ### THE FIRST CLEAN PLAYTHROUGH `` — Boil Over never drafted (premise 12); the driest hero's rate.
- `` ### THE CROSS-TARGET SUPERSESSIONS `` — the supersessions JN wrote.
- `` ### Named by the designer, carried from CX `` — a debuff against its cooldown: Poison Arrow; the pointer to JI's archived read.
- `` ### FOUND AT JM AND NOT FIXED ``, `` ### FOUND AT JL AND NOT FIXED ``, `` ### FOUND AT JK AND NOT FIXED ``, `` ### FOUND AT JJ AND NOT FIXED ``, `` ### FOUND AT JI AND NOT FIXED `` — their closed items archived (the content hole closed for eight of its eleven; JI's debuff read superseded), labels mended.
- `` ### FOUND AT JH AND NOT FIXED ``, `` ### FOUND AT JF AND NOT FIXED ``, `` ### FOUND AT JC AND NOT FIXED ``, `` ### FOUND AT IZ AND NOT FIXED `` — their premise and beyond-the-brief records archived when the readers' repairs reached the ceiling.

**Read for the work and left as they stood**: `` ### THE TEST TREE, AS OF EF `` (the new gate's rows: the battery's list, `baselines.json`, `check_parse`), `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` (the two carried reds every prediction names), `` ### THE CREST POOL `` (Arm B's crest, the bot's), `` ### FOUND AT IY AND NOT FIXED `` (the fight seed, the pairing by seed) and `` ### FOUND AT JE AND NOT FIXED `` (the three-relic arms). The population row **the bot's divergences** was needed too: DV36, Arm B's talent policy, joined it.

## FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED

The close-read (`route/closeread_prompt.md`, `route/close_read_findings.md`) was an outside reader on the frozen tree that lands,
`lanes/read1`. It read the 44 blocks the routing left closed, each whole, and `## THE INDEX` whole. **Eight bore — one plainly, seven
arguably.** None moves a figure. The one plain bearing, THE CLASS MERGE, is owed to SANCTITY's STEP's *what waits on it*. 36 did not
bear. Three of the eight were ROUTED and missed; five were NOT ROUTED, and each of those rows takes the trigger named.

- `` ### THE CLASS MERGE ~~IS MEASURED AND UNRULED~~ WAS MEASURED AT FP AND IS RULED `` — **plainly** (S0), **ROUTED**. Its trigger *Sanctity potency layer* names S0's Sanctity, the subject the routing matched with *Sanctity events*, *SANCTITY_PER_STEP* and *Sanctity figures*, and the routing did not take it. Its measure is the strongest answer to *what waits on it*: the status-potency layer is the single largest unbuilt system, and a merged tree and any status worth more to one hero need it. SANCTITY's STEP does not say so. The row takes *Sanctity's step* as well.
- `` ### GK's RULINGS OWED `` — arguably (S0), **NOT ROUTED**. Item 2, the spines' rule texts, has waited on the designer since GK, and one of them is Sanctity's. Those words count every change, where the ledger counts one a body and status a turn. The row takes *Sanctity's step*.
- `` ### FOUND AT IG AND NOT FIXED `` — arguably (S0, S2), **NOT ROUTED**. Arm B's tier 1 wears the +20 pool node, so every run's first fight opens a Mana hero at 100 of 120, and the Cleric refills it at half since the cut. With the same node Boil Over's top of range is 120 Rage. Neither is named; the bias runs against the talented arm. The row takes *opening bar* and *tier 1 whole*.
- `` ### THE THREE PRICING QUESTIONS `` — arguably (S0), **NOT ROUTED**. Its cross-class family (Zeal and Divine Wrath against Arcane Surge and Hold the Line) and its Sanctuary-against-Hymn overlap price Cleric Mana. The cut doubles what that Mana costs him in drip-turns. Nothing is false; the currency moved. The row takes *the Cleric's Mana gain*.
- `` ### FOUND AT IH AND NOT FIXED `` — arguably (S0), **NOT ROUTED**. The cut is armed in `battle._spawn_units`, the spawn's own prologue, which the item says is a copy short of `Run.hero_live_config`. CK §1's owed helper owes that arming too. The row takes *`_spawn_units`*.
- `` ### GW's RULINGS OWED `` — arguably (S4), **ROUTED** by *new gate*, which the routing matched for FIVE MORE THINGS FH FOUND and did not follow here. `check_jn` sets no field `check_gw` §2 counts: its one `.attack =` is one of the sweep's exclusions. Nothing is false.
- `` ### GR's RULINGS OWED `` — arguably (S4), **ROUTED** by *the two readings*, which stands verbatim in S4 and was not taken. JN did not write `docs/combat-rules.md`, so no third reading is owed. Nothing is false.
- `` ### FOUND AT GY AND NOT FIXED `` — arguably (the work), **NOT ROUTED**: the brief names no document entry. JN's design-notes entry stands first, as the rule asks, so nothing is false. The row's own *design-notes entry* already names the work and needs nothing.

## THE INDEX's UPKEEP

**32 of 165 entries touched** — the tree's index against HEAD's (`tools`: `edits/upkeep.py`), every block JN changed re-stamped by `index_stamp.py --write`.

**ADDED — 3**: `` ### JN's RULINGS OWED ``; `` ### WHAT THE RAISE DID, AND THE GAME WITH TALENTS ``; `` ### FOUND AT JN AND NOT FIXED ``.

**LEFT — 1**: `` ### JM's RULINGS OWED `` (the open queue's rulings move to the newest batch's, the core's by role).

**RE-LABELLED OR RE-TRIGGERED, AND RE-STAMPED — 17**: `` the bot's divergences ``; `` the sim's recorded figures ``; `` ### THE WARBAND's COOLDOWNS ``; `` ### FOUND AT JM AND NOT FIXED ``; `` ### FOUND AT JL AND NOT FIXED ``; `` ### FOUND AT JK AND NOT FIXED ``; `` ### FOUND AT JJ AND NOT FIXED ``; `` ### FOUND AT JI AND NOT FIXED ``; `` ### FOUND AT JH AND NOT FIXED ``; `` ### FOUND AT JC AND NOT FIXED ``; `` ### FOUND AT IZ AND NOT FIXED ``; `` ### FOUND AT IH AND NOT FIXED ``; `` ### FOUND AT IG AND NOT FIXED ``; `` ### THE CROSS-TARGET SUPERSESSIONS ``; `` ### GK's RULINGS OWED ``; `` ### THE CLASS MERGE ~~IS MEASURED AND UNRULED~~ WAS MEASURED AT FP AND IS RULED ``; `` ### THE THREE PRICING QUESTIONS ``.

**RE-STAMPED ONLY — 12**: `` ## WHERE THE PROJECT IS ``; `` ### THE CLERIC's MANA RATE ``; `` ### SANCTITY's STEP ``; `` ### BOIL OVER'S RATE ``; `` ### THE PLAYTEST'S OTHER FINDINGS ``; `` ### THE FIRST CLEAN PLAYTHROUGH ``; `` ### THE BARGAIN DECK's GRADES ``; `` ### THE WARBAND's SPENDS ``; `` ### THE WARBAND's HEXES ``; `` ### THE ARC, READ WHOLE ``; `` ### FOUND AT JF AND NOT FIXED ``; `` ### Named by the designer, carried from CX `` — each block's text moved under a row whose label and triggers still hold.
