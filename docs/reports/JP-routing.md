# JP — THE ROUTING OF RECORD

Part of JP's report (`docs/reports/JP.md`). **Written before the work began** (the subjects and the matches on 2026-11-07, before any edit): the brief's subjects, the index rows whose triggers name them — each with the trigger that matched, verbatim from its row — the population rows whose triggers name a subject, the blocks those population rows add, and the core. **That list plus the core is what JP opens, the core whole.** The file read is HEAD's `docs/state.md` (`37ae3dd`, 162 entries: 138 rows, 15 core, 9 population rows).

## THE BRIEF'S SUBJECTS

- **S0** §0 JO's eight rulings accepted as taken, each a document edit: the Break price in every move's worth, the basic's too (0.3471 a point, 35.15 over 101.25), the taken reading against the brief's direction, seven of the ten raised again; nine held bands at the data's figure; a hex on a blow unpriced and Fester's tick priced, JL's what-it-denies convention retired; Gall given damage, not folded; what the folds move (Sap at Bone Rattle's 3.0, Fester at the Bellow's 3.5, each on a hit and blockable, Gall, Mire and Sap laying 3 against a cooldown of 2); a hex reaches what its blow strikes, companions among them, only Gall paying there, superseding JM's ruling 3; the hex special's code deleted, JL's ruling 7 with it; the floor's supersessions recorded — and the three dials recorded and not pulled, each with its exact reversal where the change is recorded: the Cleric's Mana cut (`CLERIC_MANA_CUT`), JO's seven raises (seven data keys, back to JN's figures), JN's ten (back to HEAD-before-JN)
- **S1** §1 the count gets fights where the enemy attacks: the count taken only over the fights where the warband attacks, the number of such fights printed beside it; how many attacking fights the battery produces and whether that is enough to see a move with a cooldown of 2 cast; the cheapest fix (a gate running a handful of fights with attacks on, a flag on an existing gate), taken only if it is one flag on one gate; JO's figures kept as taken; premise — why attacks are off in most gate fights, the flag or fixture and what it is for, and a gate that needs attacks off not broken
- **S2** §2 the party's three answers, read out at source and authored nowhere: (1) taking Malice out of the pool — where Malice is added and spent, anything that subtracts, a floor at zero, whether the strip shows a fall, whether a hero's blow could carry a drain as a warband blow carries a hex, and what the +25-a-kill and the overkill terms would take to switch off conditionally; (2) refusing a hex — Gall and Fester area blows rolling no miss, Block the only defence and `block_chance` with no universal baseline (the Warden's base, Heavy Plating's slice, Interpose, Covering Guard), every door a status passes onto a hero, anything that refuses a status rather than removing it (a ward, a resistance roll, an immunity), which cleanses reach which of the four hexes, and what a base Block for every hero would touch; (3) reading what the warband declared — the `CD` chip, the two-name plate and the Malice strip, whether a declared move is reachable to a card (the field, where set, when cleared), whether the warband has a Break meter of its own beside a hero's Break discarding his intent, and whether a card could condition on a declared move's worth, its cooldown or the pool's level
- **S3** §3 what is deliberately not done: no balance drive, the untalented line retired; no player content (card, talent, rune, status, ability); no dial pulled; no basic changed, no new enemy move, kind or status; the four hexes, three spends, Malice's three terms and cap, the Break price and the nine held bands standing; JO's counts not re-derived; no grade re-authored, the deck closed at twenty-five; Sunder, Exposed, Cripple and Slowed unpriced, Dazed the Withered Warden's and the Hollow Crown's; Chieftain's Maul at its damage and band 0; Boil Over's reachability not addressed; left as JO found them — `block_chance`'s two blocks' triggers, `check_di`'s moved line citation, the crest divergence, Fleeting and Encumbered at a tie with a cut, the eight trimming plate pairings, the Regalia trap, a body over 377, Raise skipping Bloodless, a second kill and the Reaver's count, Called Shot's mode and the sim's raw armour, the Bomb's blast credit, the glossary's missing Malice entry, the ten strays in `KNOWN_STRAYS`; `CLAUDE.md` not cut, the state's ceiling at 440; `test_batch_bm` §9's window, `Gate.within`, the cheap gates, the thirteen picks, `check_it` §2c, `check_hn` §2a, the latent floor shapes, the Cryomancer's route, the playthrough
- **S4** §4 the verification, less every drive: the push check; the routing before any edit; the blocks' reader before the first edit reaches a lane; the premises at source; the literal sweep; the documents replayed from HEAD behind a hash guard; the new text's reader and the close-read; a recon only if §1's fix touches a gate's fixture; the pre-run; the new gate; all 489 positional reads; C01 to C10, H01 and H02; the fresh reader; the acceptance; the landing; the two readings at the open and the close against the state's 440 KiB, and the projected figure for JQ

## THE ROWS THE TRIGGERS MATCHED — 71

| block | subjects | the triggers that matched (verbatim from its row) |
|---|---|---|
| `` ### THE WARBAND's COOLDOWNS `` | S0 S2 S3 | enemy cooldown; CD chip; Wretched Bellow; second damaging move; JN-population; Break price; line_blow; HELD; JO-break; JO-held; Chieftain's Maul |
| `` ### THE WARBAND's MALICE `` | S2 S3 | Malice; warband pool; warband heal; overkill; kill fill; spend policy; MALICE_CAP; malice strip |
| `` ### THE WARBAND's SPENDS `` | S2 S3 | Malice spend; _warband_spend; raised body; Fleeting Rally; free spend |
| `` ### THE WARBAND's HEXES `` | S0 S1 S2 S3 | hex; Gall; Sap; Mire; Fester; GALL_HEAL_CUT; SAP_CUT; MIRE_SLOW; Orc Hexer; Orc Archer; Bone Rattle; JO-hexes; rides a blow; hex on a companion; check_jo |
| `` ### WHAT THE RAISE DID, AND THE GAME WITH TALENTS `` | S0 S1 | what the raise did; hero Breaks; Skull Crack; Withering Hex; Swampy Grasp |
| `` ### FOUND AT JO AND NOT FIXED `` | S0 S1 S3 | brief premises; Break price; unpriced statuses; Sundering Decree; battery carriers; hex count; Fester growth; JO-count |
| `` ### FOUND AT JN AND NOT FIXED `` | S0 S2 | intent glyph; debuff longer than cooldown; Blood Tribute band; the cut's reach; content hole |
| `` ### FOUND AT JM AND NOT FIXED `` | S0 S3 | crest choice; aoe special; hover every hero; Gall leaning easier |
| `` ### FOUND AT JL AND NOT FIXED `` | S0 S2 | hex uptime; Returned Burden hex; Fleeting hex; unpriced enemy debuffs; spend cooldown re-derive |
| `` ### FOUND AT JK AND NOT FIXED `` | S2 S3 | Fleeting Rally; raise cap; Bloodless raise; second kill; Reaver kill count; Blood Tribute fallen; Called Shot armor |
| `` ### FOUND AT JJ AND NOT FIXED `` | S2 | warband healing a fight |
| `` ### FOUND AT JI AND NOT FIXED `` | S2 S4 | CD chip; display chip census; Blood Tribute; PROJECTED FOR |
| `` ### FOUND AT JH AND NOT FIXED `` | S4 | check_jc; next closed block |
| `` ### FOUND AT JF AND NOT FIXED `` | S3 | crest none; the bot wears a crest |
| `` ### FOUND AT JD AND NOT FIXED `` | S3 | KNOWN_STRAYS |
| `` ### FOUND AT JA AND NOT FIXED `` | S4 | DOD_SUITE_TIMEOUT; battery watchdog |
| `` ### FOUND AT IX AND NOT FIXED `` | S1 | check_hk walk not seeded |
| `` ### THE RULES A GATE COULD CHEAPLY HOLD `` | S3 | cheap gate |
| `` ### FOUND AT IU AND NOT FIXED `` | S3 | cheap gate |
| `` ### FOUND AT IT AND NOT FIXED `` | S4 | positional census MISSES ceiling; typed figure |
| `` ### FOUND AT IS AND NOT FIXED `` | S3 | Cryomancer's route |
| `` ### FOUND AT IR AND NOT FIXED `` | S3 | floor census; latent floor of a zero |
| `` ### FOUND AT IQ AND NOT FIXED `` | S3 | check_hn 2a worn arm |
| `` ### FOUND AT IO AND NOT FIXED `` | S2 | _cheapest_attack; Heads Down; enemy kit order |
| `` ### FOUND AT IL AND NOT FIXED `` | S2 | status src |
| `` ### FOUND AT IK AND NOT FIXED `` | S3 | Sunder duration; Called Shot Armor; Sundering Strike; enemies.json |
| `` ### FOUND AT IG AND NOT FIXED `` | S2 | DEBUFF_IDS melted |
| `` ### FOUND AT ID AND NOT FIXED `` | S2 | _resolve_special |
| `` ### FOUND AT IC AND NOT FIXED `` | S2 | Overkill |
| `` ### FOUND AT II AND NOT FIXED `` | S2 | attribution frame; credit nobody |
| `` ### FOUND AT HY AND NOT FIXED `` | S2 | attribution frame |
| `` ### FOUND AT HZ AND NOT FIXED `` | S3 | Boil Over |
| `` ### FOUND AT HT AND NOT FIXED `` | S4 | run_battery.sh game open; player-file arm |
| `` ### FOUND AT HP AND NOT FIXED `` | S2 | Break pay gap |
| `` ### FOUND AT HO AND NOT FIXED `` | S2 | Cleanse Debuffs talent |
| `` ### FOUND AT HF AND NOT FIXED `` | S2 | barrier absorb |
| `` ### FOUND AT HA AND NOT FIXED `` | S3 | check_di |
| `` ### THE CROSS-TARGET SUPERSESSIONS `` | S0 | supersession table; retiring a superseder; check_jj 5 |
| `` ### FOUND AT GR AND NOT FIXED `` | S1 | check_fr; which file a rule lives in |
| `` ### GR's RULINGS OWED `` | S4 | the two readings |
| `` ### GO's RULINGS OWED `` | S3 | second kill; kill count; raised body |
| `` ### GN's RULINGS OWED `` | S4 | label collision; name sweep |
| `` ### FOUND AT GN AND NOT FIXED `` | S4 | check_gj 4 sanctioned red; baselines.json |
| `` ### GM's RULINGS OWED `` | S2 | enemy buff; warband status; _dispellable_buffs; Dispel DISPEL_NEVER |
| `` ### FOUND AT GM AND NOT FIXED `` | S2 | enemy-side status list; DEBUFF_IDS; DISPEL_NEVER |
| `` ### GK's RULINGS OWED `` | S2 | Heavy Plating base stat |
| `` ### FOUND AT GK AND NOT FIXED `` | S4 | save-backups untracked; git add -A |
| `` ### FOUND AT GJ AND NOT FIXED `` | S1 S3 | Regalia; check_fh; check_gf |
| `` ### FOUND AT GA AND NOT FIXED `` | S2 | stale claims |
| `` ### FOUND AT GP AND NOT FIXED `` | S2 S3 | Covering Guard block_chance; _live_block_chance; _plating_slice Heavy Plating; Warden 0.10; can be blocked |
| `` ### **AND FP's `block_chance` FINDING TRAVELS WITH IT `` | S2 S3 | block_chance default 0; Warden 0.10; Heavy Plating _plating_slice; Covering Guard; can be blocked; parry_chance sentinel |
| `` ### THE TALENT LAYER IS BUILT (FX); FIVE THINGS IN IT, AND SEVEN OF FW'S EDGES, ARE THE DESIGNER'S `` | S2 | enemy interference |
| `` ### FOUR GATES CAN WRITE THE PLAYER'S `relics.json` THE DAY A RELIC IS LOCKED `` | S1 | check_fh |
| `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` | S1 S4 | build_pin_manifest.py; pin-manifest.json; check_ed; ways-of-working.md |
| `` ### THE `master.html` STAMP CAN SIT MANY BATCHES STALE AND PASS `` | S4 | master.html Last updated stamp; test_batch_ce |
| `` ### THE LADDER `` | S2 | enemies.json |
| `` ### THE THREE PRICING QUESTIONS `` | S0 | the Cleric's Mana gain |
| `` ### THE SEVENTH FAMILY, FOUND AT DM AND DELIBERATELY NOT SWEPT `` | S2 | enemy description |
| `` ### Carried, and still awaiting a ruling `` | S3 | CLAUDE.md ceiling |
| `` ### Named by the designer, carried from CX `` | S0 S2 | enemy interference status; enemy debuff duration vs cooldown |
| `` ### THE FIRST CLEAN PLAYTHROUGH `` | S0 S3 | playtest readout; Cleric driest hero |
| `` ### THE ARC, READ WHOLE `` | S3 | Fleeting; Encumbered; Bloodless |
| `` ### THE BARGAIN DECK's GRADES `` | S3 | re-grade; Fleeting; Encumbered; deck closed |
| `` ### THE SHARE CENSUS `` | S2 | heroes vs warband |
| `` ### THE TEST TREE, AS OF EF `` | S4 | run_battery.sh GATES; baselines.json rows; new gate rows; check_de differ |
| `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` | S4 | sanctioned reds; check_cm_live; check_gj |
| `` ### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED `` | S1 | test_rune_battle |
| `` ### THE REST `` | S2 S4 | defensive bar; _defensive_brace; _nobody_can_press; sanctioned red baselines.json |
| `` ### FIVE MORE THINGS FH FOUND AND DID NOT FIX `` | S4 | new gate; exit 0 Parse Error |
| `` ### The changelog `` | S4 | changelog headroom; next changelog cut owed |
| `` ### Knowledge sync, re-measured at EG `` | S4 | claude_md_census.py; CLAUDE.md ceiling |

## THE POPULATION ROWS THE TRIGGERS MATCHED — 5, AND WHAT EACH ADDS

| population row | subjects | the triggers that matched (verbatim) | member blocks | added beyond the subject triggers and the core |
|---|---|---|---|---|
| **the closed matter** | S0 | archive what is closed; strike what is closed | 6 | `` ### FOUND AT GL AND NOT FIXED ``; `` ### FOUND AT GF AND NOT FIXED ``; `` ### THE CRIT SURPLUS IS RULED END TO END `` |
| **the claims** | S2 | reference claims; stale claims | 8 | `` ### FOUND AT HV AND NOT FIXED ``; `` ### FOUND AT GF AND NOT FIXED ``; `` ### FOUND AT GC AND NOT FIXED ``; `` ### FOUND AT FW AND NOT FIXED `` |
| **the figures behind doors** | S0 | name the constants | 5 | `` ### FOUND AT IJ AND NOT FIXED ``; `` ### FOUND AT HL AND NOT FIXED `` |
| **the latent shapes** | S3 | floor census; floor of a zero | 10 | `` ### FOUND AT IW AND NOT FIXED ``; `` ### FOUND AT IM AND NOT FIXED ``; `` ### FOUND AT FX AND NOT FIXED `` |
| **the positional picks** | S4 | positional census; MISSES ceiling | 4 | `` ### FOUND AT IM AND NOT FIXED ``; `` ### GY's RULINGS OWED `` |

## THE CORE — 15, READ WHOLE

- `` ## WHERE THE PROJECT IS ``
- `` ## THE OPEN QUEUE ``
- `` ### JO's RULINGS OWED ``
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

**98 blocks: the core (15), the 71 matched and the 12 the population rows added — 276,056 B of HEAD's 443,609, each read whole.**

## OPENED

**All 98 blocks of the list above, each read whole, and `## THE INDEX` whole by its own rule** — the core (15) and the index by me, and all 98 by the blocks' reader at source on a frozen copy of HEAD (`route/opened_reader.md`, written at 03:04:51; `lanes/read0`, frozen at 02:38:45). The routing of record was born at 02:38:11, before any edit. The instruments, the readout and the state's fragments were drafted while the reader read — the count tool born 02:45:22, the readout 02:48:08, the gate's draft 02:53:14, the state's fragments from 02:55:35 and the state's edit script 02:58:03 — and none reached a lane before its findings and the decisions on them (`route/decisions.md`, 03:06:55); the first edit to reach a lane was the code-stage build at 03:08:54.

## NEEDED

**11 of the 98 were needed and changed** — each by JP's work or by what it wrote:

- `` ## WHERE THE PROJECT IS `` — rewritten; five closed gates pin its words (Communion's figure, the projection's head, the spends' prices, the hexes' sentence, the Break price), and §3's line carries them.
- `` ### JO's RULINGS OWED `` — answered in JP's brief, all accepted as taken; archived struck; `` ### JP's RULINGS OWED `` and `` ### THE PARTY's THREE ANSWERS, READ OUT `` stand in its place.
- `` ### THE CLERIC's MANA RATE `` — dial 1's reversal.
- `` ### THE WARBAND's COOLDOWNS `` — dial 2's reversal; JO's rulings cited, accepted at JP §0.
- `` ### WHAT THE RAISE DID, AND THE GAME WITH TALENTS `` — dial 3's reversal, nineteen keys.
- `` ### THE WARBAND's SPENDS `` — a Break and a hold discard a spend too (the readout); JO's ruling cited, accepted.
- `` ### THE WARBAND's HEXES `` — Hallowed's refusal named beside the cleanses; JO's rulings cited, accepted.
- `` ### FOUND AT JO AND NOT FIXED `` — the carriers item, which §1 answers, archived; its row mended.
- `` ### FOUND AT JN AND NOT FIXED `` — JO's rulings cited, accepted.
- `` ### FOUND AT JM AND NOT FIXED `` — its four balance readings, which the floor leaves asking nothing, archived for the state's room; its row mended.
- `` ### FOUND AT GP AND NOT FIXED `` — Covering Guard's slice widened by Shieldwall and a Split Shield's Bulwark Line, since JP's readout.

**And `## THE INDEX`**, read whole by its own rule: the CORE row passes to JP's rulings, three rows are added, the dial blocks' rows are rewritten with their triggers, two NOT ROUTED rows take theirs, and two population rows are mended (the claims' stale pointer; the latent shapes take FOUND AT JP).

**Read for the work and left as they stood**: `` ### THE WARBAND's MALICE `` (the readout's doors), `` ### THE SHARE CENSUS ``, `` ### FOUND AT JL AND NOT FIXED `` and `` ### FOUND AT JK AND NOT FIXED `` (the hexes' and the spends' findings the readout reads beside), `` ### **AND FP's `block_chance` FINDING TRAVELS WITH IT `` (the Block's sources), `` ### FOUND AT IO AND NOT FIXED `` (Heads Down), `` ### THE TEST TREE, AS OF EF `` (the new gate's rows: the battery's list, `baselines.json`, `check_parse`), `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` (the carried reds every prediction names), `` ### FOUND AT IT AND NOT FIXED `` (the positional census), `` ### THE CROSS-TARGET SUPERSESSIONS `` (no superseder retired), and the core whole.

## FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED

**THE CLOSE-READ — FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED: 4 of the 57 closed** (the full table and findings:
`route/close_read_findings.md`)

- `` ## THE INDEX `` — PLAINLY — **ROUTED**. By its own rule (L46) every batch reads it whole, but the routing's 98 blocks do not
  name it. Its amend-the-row rule binds JP's work: COOLDOWNS and WHAT THE RAISE DID took dials 2 and 3 and were only re-stamped,
  so no trigger names a dial. The three answers' row lacks the brief's own *`block_chance`*. FOUND AT JO keeps *hex count* and
  *JO-count* after its item was archived. The claims row names IV's RULINGS OWED, which does not exist.
- `` ### GW's RULINGS OWED `` — ARGUABLY — **ROUTED**. Its trigger *new gate* is verbatim in S4 (*the new gate*). The same trigger
  matched FH's row, but the hand-made match list left GW's out. `check_jp` hand-sets no field, so `check_gw` §2's count does not
  move; nothing is false.
- `` ### FOUND AT HN AND NOT FIXED `` — ARGUABLY — **NOT ROUTED**. It prices a new shape in `Talents.party_condition_met`, the door
  JP's answer 3 quotes, yet answer 3 costs only a card handler. No trigger names the brief's word. Trigger owed: *condition on*
  (brief §2.3), with *condition_met* beside it.
- `` ### Small, and still owed `` — ARGUABLY — **NOT ROUTED**. Its ten hand-built boards include two that switch the warband's
  attacks off, `al` and `ax`; `check_jp` §1 holds `al` and not `ax`. Its `check_da` §3 ratchet is why ruling 2's gate must go
  through the fixture. The row's trigger is *hand-built boards*, but JP wrote *a few fixed boards*. Trigger owed: *fixed boards*,
  with *attacks off* beside it.

## THE INDEX's UPKEEP

**19 of 164 entries touched** — the tree's index against HEAD's (`tools`: `edits/upkeep.py`), every block JP changed re-stamped by `index_stamp.py --write`.

**ADDED — 3**: `` ### JP's RULINGS OWED ``; `` ### THE PARTY's THREE ANSWERS, READ OUT ``; `` ### FOUND AT JP AND NOT FIXED ``.

**LEFT — 1**: `` ### JO's RULINGS OWED `` (the open queue's rulings move to the newest batch's, the core's by role).

**RE-LABELLED OR RE-TRIGGERED, AND RE-STAMPED — 8**: `` the claims ``; `` the latent shapes ``; `` ### THE WARBAND's COOLDOWNS ``; `` ### WHAT THE RAISE DID, AND THE GAME WITH TALENTS ``; `` ### FOUND AT JO AND NOT FIXED ``; `` ### FOUND AT JM AND NOT FIXED ``; `` ### FOUND AT HN AND NOT FIXED ``; `` ### Small, and still owed ``.

**RE-STAMPED ONLY — 8**: `` ## WHERE THE PROJECT IS ``; `` ### THE CLERIC's MANA RATE ``; `` the bot's divergences ``; `` the sim's recorded figures ``; `` ### THE WARBAND's SPENDS ``; `` ### THE WARBAND's HEXES ``; `` ### FOUND AT JN AND NOT FIXED ``; `` ### FOUND AT GP AND NOT FIXED `` — each block's text moved under a row whose label and triggers still hold.
