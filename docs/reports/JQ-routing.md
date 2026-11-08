# JQ — THE ROUTING OF RECORD

Part of JQ's report (`docs/reports/JQ.md`). **Written before the work began** (the subjects and the matches on 2026-11-07, before any edit): the brief's subjects, the index rows whose triggers name them — each with the trigger that matched, verbatim from its row — the population rows whose triggers name a subject, the blocks those population rows add, and the core. **That list plus the core is what JQ opens, the core whole.** The file read is HEAD's `docs/state.md` (`4c08af1`, 164 entries: 140 rows, 15 core, 9 population rows).

## THE BRIEF'S SUBJECTS

- **S0** §0 JP's four rulings accepted as taken (housekeeping): the count's rule in the floor's own paragraph; no one flag on one gate adds an attacking fight, and one fight a kind with attacks on in one gate through the fixture's door taken if §4's gate can carry it; the count's battery ran on HEAD; a dial's reversal names what moves with it (dial 2's seven cooldown keys go with its seven damages) — and the designer's three answers of 7 November: a kill that denies, a cleanse that aims, a punish on a cooling move; the drain riding a blow not chosen, so no `Ability` field enters the strike loop and the reserve bug (a declared spend bought without asking the pool) stays named; the batch's figures and names each in NEEDS A RULING with its reversal
- **S1** §1 Forsaken: a body that dies Forsaken gives the warband nothing — neither the kill's twenty-five (`_on_unit_died`, `_malice_fill(MALICE_PER_KILL)`, reached from `unit._die`'s `died_cb` before the statuses clear) nor the overkill (`_malice_on_damage`'s `past_last` half); the damage term stands; a status lasting 3 turns laid by a card; BR §1's name sweep three ways against every name; which class and card lays it (the roster read, a cost and cooldown recommended and taken); whether it survives a Raise (a Raised body's second fall fills again, JK's finding); which deaths reach the condition — a debug kill (`_debug_kill_enemies`), a tick kill (FW: a tick kill skips `_on_enemy_death`), a Burn tick
- **S2** §2 the cleanse aims: a single-pick cleanse (`dispel_one_debuff`, its filter and its random pick) takes a hex if the hero carries one, otherwise the debuff with the most turns left; every caller (Dispel on a hero, Field Dressing, the Rune of the Medic, the tier-2 talent Cleanse Debuffs Each Turn, and the rest) and each one's text; a buff to every site, the designer's to turn, its reversal the random pick; the multi-pick cleanses (`purge_debuffs_taken`, the Empowered heals) and the Cleansing Draught's `_cleansable_debuffs` (the Rite's filter) unchanged; whether a hex is derivable off the data or must be a list of four ids
- **S3** §3 the punish on a cooling move: a blow deals more against a body whose declared move cools, +20% a turn of the declared move's cooldown, nothing against a basic; the first party kit that reads the warband's telegraphs (`intent`, the `CD` chip, `cooldowns`, the two-name plate); a move's worth is not in the game (`check_ji.line_blow`, a gate's static) and JI's line is not moved into it; which class and card; a talent's or a rune's condition (`Talents.condition_met`) cannot read a declaration, so a card's handler; the condition shown before the cast, in the shape of the game's other conditional cards (`_pick_dud`, a dud reason)
- **S4** §4 the count, taken only on fights where the warband attacks, with that number beside it: Forsaken laid and a body dying carrying it, an aiming cleanse taking a hex or something else, the punish's condition met; JP's recommendation — one fight a kind with the warband's attacks on, in one gate, through the fixture's door, on autoplay — built if it fits, else left named; no drive; 36 attacking fights, the Orc Hexer in 2 and the Bloodcaller in none
- **S5** §5 what is deliberately not done: no balance drive, the untalented line retired; no drain riding a blow, no `Ability` field in the strike loop, the reserve bug as found; no dial pulled (the Cleric's cut, JO's seven, JN's ten); no new status refusal, no base Block, Hallowed not moved; no interrupt built; JI's line not moved into the game; no basic changed, no new enemy move, kind or status (the four hexes, the three spends, Malice's three terms and its cap, the Break price, the nine held bands); no grade re-authored, the deck closed at twenty-five; Boil Over's reachability; Sunder, Exposed, Cripple and Slowed unpriced; left as JP found them — the ledger's stale comment, the index's five amend-the-row misses, the two triggers owed on `block_chance`, `check_di`'s moved line citation, the crest divergence, Fleeting and Encumbered at a tie, the eight trimming plate pairings, the Regalia trap, a body over 377 never raised, Raise skipping Bloodless, a second kill and the Reaver's uncapped count, Called Shot's mode and the sim's raw armour, the Bomb's blast credit, the glossary's missing Malice entry, the ten strays in `KNOWN_STRAYS`; `CLAUDE.md` not cut, the state's ceiling at 440; `test_batch_bm` §9's window, `Gate.within`, the cheap gates, the thirteen picks, `check_it` §2c, `check_hn` §2a, the latent floor shapes, the Cryomancer's route, the playthrough
- **S6** §6 the verification, less every drive: the push check; the routing before any edit; the blocks' reader before the first edit reaches a lane; the premises at source; the literal sweep; the documents replayed from HEAD behind a hash guard; the new text's reader and the close-read; a recon (the death door, the damage door, the cleanse and a card's handler move); the pre-run; the new gate; all 489 positional reads; C01 to C19, H01, H02 and R01 (a re-tune of Forsaken's 3 turns or the punish's 20% at its source); the fresh reader; the acceptance; the landing; the two readings at the open and the close against the state's 440 KiB, and the projected figure for JR

## THE ROWS THE TRIGGERS MATCHED — 78

| block | subjects | the triggers that matched (verbatim from its row) |
|---|---|---|
| `` ### THE PARTY's THREE ANSWERS, READ OUT `` | S0 S1 S2 S3 S5 | three answers; drain Malice; kill term; overkill term; declared spend; base Block; Hallowed; Empowered Divine Plea; cleanse reach; intent; Malice strip; condition on; JP-answers |
| `` ### THE WARBAND's COOLDOWNS `` | S0 S3 S5 | enemy cooldown; 1.4x line; CD chip; line_blow; dial 2; JO's seven raises; JP-dials |
| `` ### THE WARBAND's MALICE `` | S1 S5 | Malice; warband pool; overkill; kill fill; past_last; MALICE_CAP; malice strip |
| `` ### THE WARBAND's SPENDS `` | S1 S5 | Malice spend; _raise_holds; raised body; free spend |
| `` ### THE WARBAND's HEXES `` | S2 S4 | hex; Gall; Sap; Mire; Fester; Orc Hexer; hex on a companion |
| `` ### WHAT THE RAISE DID, AND THE GAME WITH TALENTS `` | S0 S5 | dial 3; JN's ten raises; JP-dials |
| `` ### FOUND AT JP AND NOT FIXED `` | S0 S4 S5 | attacking fights; DOD_ENEMIES_OFF; count denominator; JP-count; one fight a kind; cheapest fix; theme; Hallowed; hero declares; Break discards; drain meets a spend |
| `` ### FOUND AT JO AND NOT FIXED `` | S5 S6 | brief premises; Break price; unpriced statuses |
| `` ### FOUND AT JN AND NOT FIXED `` | S3 | intent glyph |
| `` ### FOUND AT JL AND NOT FIXED `` | S2 | Returned Burden hex |
| `` ### FOUND AT JK AND NOT FIXED `` | S1 S5 | raise cap; Bloodless raise; second kill; Reaver kill count; Called Shot armor |
| `` ### FOUND AT JI AND NOT FIXED `` | S3 S6 | CD chip; WHERE block pins; PROJECTED FOR |
| `` ### FOUND AT JH AND NOT FIXED `` | S6 | next closed block |
| `` ### FOUND AT JF AND NOT FIXED `` | S5 | crest none; the bot wears a crest |
| `` ### FOUND AT JD AND NOT FIXED `` | S5 | KNOWN_STRAYS |
| `` ### FOUND AT JA AND NOT FIXED `` | S6 | DOD_SUITE_TIMEOUT; battery watchdog |
| `` ### FOUND AT IX AND NOT FIXED `` | S4 | check_hk walk not seeded |
| `` ### THE RULES A GATE COULD CHEAPLY HOLD `` | S5 | cheap gate |
| `` ### FOUND AT IU AND NOT FIXED `` | S5 | cheap gate |
| `` ### FOUND AT IT AND NOT FIXED `` | S6 | positional census MISSES ceiling; typed figure |
| `` ### FOUND AT IS AND NOT FIXED `` | S5 | Cryomancer's route |
| `` ### FOUND AT IR AND NOT FIXED `` | S5 | floor census; latent floor of a zero |
| `` ### FOUND AT IQ AND NOT FIXED `` | S5 | check_hn 2a worn arm |
| `` ### FOUND AT IO AND NOT FIXED `` | S5 | Heads Down |
| `` ### FOUND AT IM AND NOT FIXED `` | S3 | _enemy_pick_pool |
| `` ### FOUND AT IL AND NOT FIXED `` | S1 | status src |
| `` ### FOUND AT IK AND NOT FIXED `` | S1 S3 | handler literal; check_ij 3 pins |
| `` ### FOUND AT IJ AND NOT FIXED `` | S1 S3 | master.html repair rows |
| `` ### FOUND AT IG AND NOT FIXED `` | S2 | DEBUFF_IDS melted |
| `` ### FOUND AT IE AND NOT FIXED `` | S1 S4 | drafted hook; DISPEL_NEVER spec_passive |
| `` ### FOUND AT ID AND NOT FIXED `` | S3 | DAMAGE_SPECIALS; _resolve_special |
| `` ### FOUND AT IC AND NOT FIXED `` | S1 | Overkill |
| `` ### FOUND AT II AND NOT FIXED `` | S1 | attribution frame |
| `` ### FOUND AT HY AND NOT FIXED `` | S1 | attribution frame |
| `` ### FOUND AT HZ AND NOT FIXED `` | S1 | STATUS_INFO row |
| `` ### FOUND AT HS AND NOT FIXED `` | S1 | tick has no attacker |
| `` ### FOUND AT HO AND NOT FIXED `` | S2 | Cleanse Debuffs talent |
| `` ### FOUND AT HN AND NOT FIXED `` | S3 | condition on; condition_met |
| `` ### FOUND AT HL AND NOT FIXED `` | S1 S3 | classes.gd card text; combat-log literals |
| `` ### FOUND AT HA AND NOT FIXED `` | S1 S5 | check_di |
| `` ### GN's RULINGS OWED `` | S1 S3 | Cleric class pool three; class kit; label collision; name sweep; strike loop coverage |
| `` ### GM's RULINGS OWED `` | S1 S2 | Dispel DISPEL_NEVER; beneficial status on an enemy; _dispellable_buffs |
| `` ### FOUND AT GM AND NOT FIXED `` | S1 S2 | enemy-side status list; DEBUFF_IDS; DISPEL_NEVER; draft_ability |
| `` ### GP's RULINGS OWED `` | S1 S3 | class-wide cards rebalance; CLASS_DRAFT_POOLS weaker; two heroes one class |
| `` ### FOUND AT GP AND NOT FIXED `` | S5 | Covering Guard block_chance; _live_block_chance |
| `` ### **AND FP's `block_chance` FINDING TRAVELS WITH IT `` | S5 | block_chance default 0 |
| `` ### GO's RULINGS OWED `` | S1 S5 | Reaver; second kill; kill count; raised body |
| `` ### FOUND AT GU AND NOT FIXED `` | S1 S3 | draft_pool corpus walk; cards under an enabler |
| `` ### FOUND AT GS AND NOT FIXED `` | S1 S3 S4 | sim bot _bot_drafted_pick |
| `` ### FOUND AT GJ AND NOT FIXED `` | S4 S5 | Regalia; gate_fixture screen primitives; check_fh |
| `` ### FOUND AT GH AND NOT FIXED `` | S1 | _die |
| `` ### FOUND AT FW AND NOT FIXED `` | S1 | death refusals; tick kill skips _on_enemy_death; combat-rules.md four death-refusals |
| `` ### FY §1: THREE NODES PAID BY WHO ELSE HELD THEM, AND TODAY'S COUNT DOUBLES FOUR ITEMS `` | S1 | name sweep |
| `` ### THE ARCHETYPE TAGS `` | S1 S3 | card tags; CARD_TAGS |
| `` ### THE TALENT CHARTER `` | S3 | owns_ability condition |
| `` ### HJ's RULINGS OWED `` | S1 S3 | class draft pool |
| `` ### HD's RULINGS OWED `` | S1 S3 | class pool floors CLASS_POOL_FLOOR; card-pool floors |
| `` ### THE CROSS-TARGET SUPERSESSIONS `` | S1 S3 | class_pool_floors |
| `` ### FIVE DRAFTED ABILITIES ARE NAMED AND DESCRIBED NOWHERE `` | S1 S3 | master.html 6b drafted-abilities table; card rows |
| `` ### THE SEVENTH FAMILY, FOUND AT DM AND DELIBERATELY NOT SWEPT `` | S1 S3 | card text under-states payload |
| `` ### Small, and still owed `` | S1 | _apply_status src coverage; check_di CALL_SITES |
| `` ## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND `` | S1 S3 | ability corpus 231; draft pools 179 |
| `` ### THE TEST TREE, AS OF EF `` | S6 | run_battery.sh GATES; baselines.json rows; new gate rows; check_de differ |
| `` ### The changelog `` | S6 | changelog headroom; next changelog cut owed |
| `` ### Knowledge sync, re-measured at EG `` | S5 S6 | CLAUDE.md ceiling |
| `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` | S6 | sanctioned reds |
| `` ### THE REST `` | S6 | check_cm_live 4-5 failures; sanctioned red baselines.json; coin-flip arm |
| `` ### FIVE MORE THINGS FH FOUND AND DID NOT FIX `` | S6 | new gate; exit 0 Parse Error |
| `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` | S6 | build_pin_manifest.py; pin-manifest.json; ways-of-working.md |
| `` ### THE `master.html` STAMP CAN SIT MANY BATCHES STALE AND PASS `` | S6 | master.html Last updated stamp |
| `` ### THE BARGAIN DECK's GRADES `` | S5 | deck closed; Fleeting; Encumbered |
| `` ### THE ARC, READ WHOLE `` | S5 | Fleeting; Encumbered; Bloodless |
| `` ### FOUND AT GN AND NOT FIXED `` | S6 | baselines.json; check_gj 4 sanctioned red |
| `` ### THE FIRST CLEAN PLAYTHROUGH `` | S5 | Boil Over undrafted; second playthrough |
| `` ### GR's RULINGS OWED `` | S6 | the two readings |
| `` ### FOUND AT GR AND NOT FIXED `` | S0 | check_fr; which file a rule lives in |
| `` ### GW's RULINGS OWED `` | S6 | check_gw 2 ceiling 90; new gate |
| `` ### FOUND AT HT AND NOT FIXED `` | S6 | run_battery.sh game open; battery kill trap lock |

## THE POPULATION ROWS THE TRIGGERS MATCHED — 7, AND WHAT EACH ADDS

| population row | subjects | the triggers that matched (verbatim) | member blocks | added beyond the subject triggers and the core |
|---|---|---|---|---|
| **the figures behind doors** | S1 S3 | every figure a text states; name the constants; literals get names; pinned figures | 5 | — |
| **the target picks** | S3 | pick pool; a pick that produces nothing; every pick | 4 | `` ### FOUND AT HF AND NOT FIXED `` |
| **the bot's divergences** | S1 S3 S4 | the bot's rules; sim bot | 10 | `` ### FOUND AT IF AND NOT FIXED ``; `` ### FOUND AT GE AND NOT FIXED ``; `` ### FOUND AT JM AND NOT FIXED `` |
| **the latent shapes** | S0 S5 | latent shapes; floor census | 11 | `` ### FOUND AT IW AND NOT FIXED ``; `` ### FOUND AT FX AND NOT FIXED `` |
| **the positional picks** | S6 | positional census; MISSES ceiling | 4 | `` ### GY's RULINGS OWED `` |
| **the closed matter** | S6 | archive what is closed; strike what is closed | 6 | `` ### FOUND AT GL AND NOT FIXED ``; `` ### FOUND AT GF AND NOT FIXED ``; `` ### THE CRIT SURPLUS IS RULED END TO END ``; `` ### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED `` |
| **the claims** | S1 S2 S3 | reference claims; stale claims | 8 | `` ### FOUND AT HV AND NOT FIXED ``; `` ### FOUND AT GA AND NOT FIXED ``; `` ### FOUND AT GF AND NOT FIXED ``; `` ### FOUND AT GC AND NOT FIXED `` |

## THE CORE — 15, READ WHOLE

- `` ## WHERE THE PROJECT IS ``
- `` ## THE OPEN QUEUE ``
- `` ### JP's RULINGS OWED ``
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

**107 blocks: the core (15), the 78 matched and the 14 the population rows added — 285,231 B of HEAD's 448,094, each read whole.**

## OPENED

**All 107 blocks of the list above, each read whole, and `## THE INDEX` whole by its own rule** — the core (15) and the index by me, and all 107 by the blocks' reader at source on a frozen copy of HEAD (`route/opened_reader.md`; `lanes/read0`, frozen at 13:51). The routing of record was born at 13:51:33, before any edit. The code patch, the gate's draft, the count tool, the controls and the master document's edits were drafted as scripts in the work folder while the reader read (applied only to a scratch copy no Godot ran in; their birth times were rewritten at 14:34 by the punish's rename, `sed -i`), and none reached a lane before its findings (`route/opened_reader.md`, written at 14:32:13); the first edit to reach a lane was the code-stage build `lanes/c1`, made at 14:38:16.

## NEEDED

**15 of the 107 were needed and changed** — each by JQ's work or by what it wrote:

- `` ## WHERE THE PROJECT IS `` — rewritten; five closed gates pin its words (Communion's figure, the projection's head, the spends' prices, the hexes' sentence, the Break price), and §5's line carries them.
- `` ### JP's RULINGS OWED `` — answered in JQ's brief, all accepted as taken; archived struck; `` ### JQ's RULINGS OWED `` stands in its place, CORE by role.
- `` ### THE PARTY's THREE ANSWERS, READ OUT `` — built; archived struck, its doors kept in `docs/reports/JP-answers.md`, which `check_jp` §2 reads; its row left.
- `` ### THE WARBAND's MALICE `` — Forsaken's denial beside the fill's sentence and in the doors' bullet; its row re-triggered.
- `` ### THE WARBAND's HEXES `` — the aimed cleanse beside the cleanses; the archived block's citation re-pointed at the readout; its row re-triggered.
- `` ### THE WARBAND's COOLDOWNS `` — dial 2's reversal names Read the Tell's payoff (JP's ruling 4, accepted at JQ §0); its row takes *Read the Tell*.
- `` ### WHAT THE RAISE DID, AND THE GAME WITH TALENTS `` — dial 3's reversal names Read the Tell's payoff.
- `` ### FOUND AT JP AND NOT FIXED `` — its premises and its attacking fights' reach (answered by `check_jq` §4) archived; its row mended.
- `` ### FOUND AT JO AND NOT FIXED `` — its premises archived for the room; its row mended.
- `` ## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND `` — the corpus 233, `RECAST_GATED` 65, the draft 181 of 181 with 22 class-wide, the class half's seven and four; its row's figures.
- `` ### GN's RULINGS OWED `` and `` ### GP's RULINGS OWED `` — the Cleric's class pool four and the Warrior's seven since JQ, beside the figures they ruled on.
- `` ### THE CROSS-TARGET SUPERSESSIONS `` — `check_jp` §3's narrowing, recorded at both ends with its control (C20, C20h).
- `` ### THE PLAYTEST'S OTHER FINDINGS `` — the LOOK-LIST's row: the three answers on screen.
- `` ### THE DRAFT AUDIT `` — opened at the close (NOT ROUTED): its corpus figure, 233 since JQ.

**And `## THE INDEX`**, read whole by its own rule: the CORE row passes to JQ's rulings; two rows added (JQ's rulings, FOUND AT JQ), two left (JP's rulings, the three answers); the changed blocks' rows re-labelled, re-triggered and re-stamped; eight NOT ROUTED rows take their triggers; two population rows mended (the latent shapes and the bot's divergences take FOUND AT JQ).

**Read for the work and left as they stood**: `` ### THE WARBAND's SPENDS `` (a Raise clears every status with the death; the reserve bug, untouched), `` ### FOUND AT JK AND NOT FIXED `` (a raised body's second fall), `` ### FOUND AT FW AND NOT FIXED `` (a tick kill skips `_on_enemy_death`, irrelevant to Malice), `` ### FOUND AT GM AND NOT FIXED `` and `` ### GM's RULINGS OWED `` (the marks' convention: `DISPEL_NEVER`), `` ### THE ARCHETYPE TAGS `` (MARK on Forsake), `` ### FOUND AT HN AND NOT FIXED `` and `` ### THE TALENT CHARTER `` (a condition reads no declaration), `` ### THE TEST TREE, AS OF EF `` (the new gate's rows), `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` (the carried reds), `` ### FOUND AT IT AND NOT FIXED `` (the positional census), and the core whole.

## FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED

**10 of the 48 closed blocks** (2 plainly, 8 arguably; 2 ROUTED, 8 NOT ROUTED).

Each closed block was read whole in the tree JQ lands (`lanes/read1`). None changed under JQ. The full table and the findings are in
`route/close_read_findings.md`.

- `` ### FOUND AT JJ AND NOT FIXED `` — **PLAINLY. NOT ROUTED**: its triggers (*heal timing, warband healing a fight, heal float, enemy descriptions literal*) name none of §1's subjects. Its *damage the frame credits to nobody fills no Malice but its kill* is the population that refutes the WHERE block's *every death of the warband passes both conditions*. **Trigger owed**: `credit nobody` (FOUND AT II's row has it), `kill term`.
- `` ### Carried, with measurements attached `` — **PLAINLY. NOT ROUTED**: its *revert constant prose sweep* does not name the brief's R01 (*a re-tune … every text that states it follows the constant*). Its rule, *grep the NUMBER, not the field*, refutes ruling 1's *`FORSAKE_TURNS`, which every text reads*: master.html states "3 turns" three times and "20%" once. **Trigger owed**: `re-tune`, `every text that states it`.
- `` ### FOUR GATES CAN WRITE THE PLAYER'S `relics.json` THE DAY A RELIC IS LOCKED `` — ARGUABLY. **ROUTED**: its row carries `check_fh`, the trigger the routing matched for S4 on FOUND AT GJ's row, and this row was not taken. `check_jq` §4's 21 live fights are its hazard, and JQ redirected `Relics.save_path` and `Profile.save_path` (check_jq.gd:146, :152).
- `` ### Carried, and still awaiting a ruling `` — ARGUABLY. **ROUTED**: its row carries `CLAUDE.md ceiling`, the trigger the routing matched for S5 and S6 on *Knowledge sync*'s row. The fallback chain's class-wide tier grew for the Cleric and the Warrior, and its 510 KiB matches the WHERE line.
- `` ### THE SHARE CENSUS `` — ARGUABLY. **NOT ROUTED**: no trigger names Encumbered or the warband's cooldowns as something a card reads. Read the Tell turns Encumbered's warband half (+2 to every cooling move) into a payout beside the census's *every live modifier costs the party*. **Trigger owed**: `Encumbered`, `warband cooldowns`.
- `` ### THE TALENT LAYER IS BUILT (FX); FIVE THINGS IN IT, AND SEVEN OF FW'S EDGES, ARE THE DESIGNER'S `` — ARGUABLY. **NOT ROUTED**: the brief names *Cleanse Debuffs Each Turn*, which item 4 rules on, and the row has no such trigger. Nothing in it turned false. **Trigger owed**: `Cleanse Debuffs Each Turn`.
- `` ### THE DRAFT AUDIT `` — ARGUABLY. **NOT ROUTED**: *THE CORPUS IS 227 (228 since GN …)* stands in the present tense at 233, and `PER_CLASS_DEPTH` is the twin of its authoritative `PER_SPEC_DEPTH`. **Trigger owed**: `ability corpus`, `PER_CLASS_DEPTH`.
- `` ### THE BOSS-PICK POOLS `` — ARGUABLY. **NOT ROUTED**: the zone-boss fallback ends on the class-wide draft pool, which JQ grew for two classes. **Trigger owed**: `class-wide draft pool`.
- `` ### THE THREE PRICING QUESTIONS `` — ARGUABLY. **NOT ROUTED**: EB §1 (the draft card pays for its slot; `check_eb` §1) governs both new cards' prices, and JQ's rulings cite only `check_gu` §2. It holds (`check_eb` 21 / 0). **Trigger owed**: `new draft card price`, `kit card baseline`.
- `` ### Carried from the code, reported and deliberately not fixed `` — ARGUABLY. **NOT ROUTED**: its asserted base-kit check (no draft card shares a name or a `special` with a core) now covers both cards, and `_recast_refusal_note` now speaks for Forsake. **Trigger owed**: `RECAST_GATED`, `new draft card`.

**Rows to repair for the NOT ROUTED misses**: FOUND AT JJ, Carried with measurements attached, THE SHARE CENSUS, THE TALENT LAYER, THE
DRAFT AUDIT, THE BOSS-PICK POOLS, THE THREE PRICING QUESTIONS and Carried from the code each take the trigger owed above. Each is a
closed block's row, so each is re-read against its block and the stamp is unchanged (no block text moves).

## THE INDEX's UPKEEP

**26 of 164 entries touched** — the tree's index against HEAD's (`tools`: `edits/upkeep.py`), every block JQ changed re-stamped by `index_stamp.py --write`.

**ADDED — 2**: `` ### JQ's RULINGS OWED ``; `` ### FOUND AT JQ AND NOT FIXED ``.

**LEFT — 2**: `` ### JP's RULINGS OWED ``; `` ### THE PARTY's THREE ANSWERS, READ OUT `` (the open queue's rulings move to the newest batch's, the core's by role).

**RE-LABELLED OR RE-TRIGGERED, AND RE-STAMPED — 17**: `` the bot's divergences ``; `` the latent shapes ``; `` ### THE SHARE CENSUS ``; `` ### THE WARBAND's COOLDOWNS ``; `` ### THE WARBAND's MALICE ``; `` ### THE WARBAND's HEXES ``; `` ### FOUND AT JP AND NOT FIXED ``; `` ### FOUND AT JO AND NOT FIXED ``; `` ### FOUND AT JJ AND NOT FIXED ``; `` ### THE CROSS-TARGET SUPERSESSIONS ``; `` ### THE TALENT LAYER IS BUILT (FX); FIVE THINGS IN IT, AND SEVEN OF FW'S EDGES, ARE THE DESIGNER'S ``; `` ### THE DRAFT AUDIT ``; `` ### THE BOSS-PICK POOLS ``; `` ### THE THREE PRICING QUESTIONS ``; `` ### Carried, with measurements attached ``; `` ### Carried from the code, reported and deliberately not fixed ``; `` ## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND ``.

**RE-STAMPED ONLY — 7**: `` ## WHERE THE PROJECT IS ``; `` ### THE PLAYTEST'S OTHER FINDINGS ``; `` the save's keys ``; `` the sim's recorded figures ``; `` ### WHAT THE RAISE DID, AND THE GAME WITH TALENTS ``; `` ### GP's RULINGS OWED ``; `` ### GN's RULINGS OWED `` — each block's text moved under a row whose label and triggers still hold.
