# IY — THE ROUTING OF RECORD

Part of IY's report (`docs/reports/IY.md`). **Written before the work began** (11:55 on 2026-10-26, before any edit and before any measurement ran): the brief's subjects, the index rows whose triggers name them — each with the trigger that matched, verbatim from its row — the population rows whose triggers name a subject, the blocks those population rows add, and the core. **That list plus the core is what IY opens, the core whole.** The file read is HEAD's `docs/state.md` (`fa24c3b`, 148 entries: 124 rows, 15 core, 9 population rows).

## THE BRIEF'S SUBJECTS

- **S1** seed a fight, not a run — the sim's seeding changed so a fight draws its own seed from the run's, and nothing else; how far it can go derived (the parties diverge in state); verified on its own before anything is built: Encumbered and Frenzied re-read at sixty runs with a re-driven baseline, the paired error against the unpaired printed beside IX's (the pass: Encumbered's ratio materially below 0.91), and the two costs held to IX's as ties — a cost past two standard errors stops it; the old seeding kept if the ratio does not fall (§1, §0.1)
- **S2** nine handles, one target, nine slopes — Dull Edge (`u.crit_bonus`), Parched (`u.max_resource`), Tinderbox (`u.type_dmg_bonus["fire"]`), Frenzied (`mod_speed_mult`), Muffled (`mod_bd_mult`), Fleeting (`mod_status_turns`), Hoarfrost (the Chilled's turns), Slick Footing (`ab.delay`), Bloodletting (`mod_bleed_add`), each turned toward grade 2's centre (2.48 points); the derivation a step, not a ratio, one line of reasoning a handle; the nine and a re-driven baseline at sixty runs, paired; the report's table (old and new value, reasoning, old and new cost, z, the slope, the grade); no rule or word moves (§2, §0.2)
- **S3** the reach test — Frenzied's `mod_speed_mult` and Hoarfrost's Chilled turns at an extreme nobody would ship, sixty runs, paired; a cost appearing (reach) or not (re-key, the designer's); the healing read in the same arm, the absorption measured rather than read (§3)
- **S4** the grades — the test binds (*a band narrower than two standard errors is not a grade*): eleven inside two standard errors carry no severity; the grade takes the higher measured cost on any population: Deadened 3 and Brittle 2 from the incumbent, each with its population and batch; the rule written where the scale is; the other twenty-one swept against it (§0.1, §0.3, §4)
- **S5** the glossary's count behind a door (a count of the modifiers beneath severity 5, computed off `Run.MODIFIERS`, or the reason it stays out); the bands read, not re-set, on the deck as §2 leaves it — each rung's safe and gamble band and what each holds, and whether Warden's gamble band is still two (§0.4, §0.5, §5)
- **S6** housekeeping — the move not attempted, `./lane.sh spent` and the folder counts at the close (whether the patterns cover them), `lane.sh` for every launch, the designer's files backed up and read through copies, the clean readout's md5 at the open and the close, the one run, the close's timestamp (§6)
- **S7** what is deliberately not done — no modifier's rule or words move, no grade placed by judgement, the bands not re-set, the reference party unchanged and no second ladder, no re-key built, the target shape (5 / 5 / 5 / 4 / 4) not pursued, nothing of the playthrough, no POLICY row and RULE at 0, the ally pools, the latent offer defect left latent, `CLAUDE.md` not indexed, the 188 cheap gates, the 438 pins, the thirteen standing picks, `check_it` §2c's arm, `check_hn` §2a's worn arm, the Chilled row's *4*, the latent floor shapes, the Cryomancer's route, `check_hk`'s unseeded walk, the standing list (§7)
- **S8** the verification — the routing first; §1's seeding and its verification on its own; §3's reach test before §2's values; §2's values derived and printed, then the drive; the code and its parse; the literal sweep before recon 1's prediction (`check_ed`, the manifest's floor); recon 1 with each seeded sim road a moved cost deals attributed by HEAD's run beside IY's; the documents as scratch copies behind a hash guard; `check_iy` into the battery; the pre-run, recon 2, the positional re-run, the controls (C01–C08, H01, H02, R01), the acceptance, the close-read; the instrument's fidelity proved again, the seeding proved not to move a reading, the baseline an arm; every negative anchor paired with a positive arm; the push check; the two readings (§8)
- **S9** the routing itself, and which of the population rows routed this brief (§8.1)

## THE ROWS THE TRIGGERS MATCHED — 34

| block | subjects | the triggers that matched (verbatim from its row) |
|---|---|---|
| `` ### THE BARGAIN DECK's GRADES `` | S1 S2 S3 S4 S5 | bargain modifier severity grades; re-grade; grade scale; cost band; reference party; no severity; baseline error bar; one-sided arms; the swing; default party untalented; grade handles |
| `` ### FOUND AT IX AND NOT FIXED `` | S1 S3 S4 S5 S7 | saved offer no severity; SEVERITY 0; paired by seed; seed per fight; headroom; severity of 1 to 5; healing takes up a tempo half; reference party healing; check_hk walk not seeded |
| `` ### FOUND AT IW AND NOT FIXED `` | S1 S4 | environment read; single-party ladder; resolution against breadth |
| `` ### FOUND AT IO AND NOT FIXED `` | S2 S4 S5 | bargain modifier |
| `` ### FOUND AT ID AND NOT FIXED `` | S2 S7 | bargain modifier card words |
| `` ### FOUND AT IN AND NOT FIXED `` | S5 S7 | safe_band; DV30 bargain policy |
| `` ### HW's RULINGS OWED `` | S5 | glossary Runes Peddler Severity |
| `` ### FOUND AT IF AND NOT FIXED `` | S3 | Cryomancer chill; Chilled 0% |
| `` ### THE CRIT SURPLUS IS RULED END TO END `` | S2 | crit rule; crit chance above certainty |
| `` ### FOUND AT FW AND NOT FIXED `` | S2 S3 | effective_speed |
| `` ### FOUND AT IG AND NOT FIXED `` | S2 | max resource node +20; bar maximum |
| `` ### HOW LONG A FIGHT IS `` | S3 | fight length rounds; sim confounders |
| `` ### THE SIM's FIGURES, RE-TAKEN AT IW `` | S1 S2 | SUPERSEDED-PENDING; re-take; recorded sim figures |
| `` ### FOUND AT GJ AND NOT FIXED `` | S1 S2 | recorded sim figures; re-take owed |
| `` ### Carried, with measurements attached `` | S1 S2 | recorded sim figures; sim readings carried |
| `` ### THE FIRST CLEAN PLAYTHROUGH `` | S7 | second playthrough |
| `` ### FOUND AT GK AND NOT FIXED `` | S6 | save-backups untracked |
| `` ### FOUND AT HT AND NOT FIXED `` | S6 S8 | player-file arm; run_battery.sh game open |
| `` ### FOUND AT HW AND NOT FIXED `` | S8 | run_battery.sh game open; kill battery |
| `` ### THE TEST TREE, AS OF EF `` | S8 | baselines.json rows; new gate rows; run_battery.sh GATES; check_de differ; .ran manifest |
| `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` | S8 | build_pin_manifest.py; pin-manifest.json; check_ed |
| `` ### THE REST `` | S8 | sanctioned red baselines.json |
| `` ### FOUND AT GN AND NOT FIXED `` | S8 | check_gj 4 sanctioned red; baselines.json |
| `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` | S8 | sanctioned reds; check_cm_live; check_gj |
| `` ### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED `` | S8 | baselines.json flake field |
| `` ### FOUND AT IT AND NOT FIXED `` | S7 S8 | positional census MISSES ceiling; Chilled status row |
| `` ### Carried, and still awaiting a ruling `` | S8 | CLAUDE.md ceiling |
| `` ### Knowledge sync, re-measured at EG `` | S8 | CLAUDE.md ceiling |
| `` ### FOUND AT IQ AND NOT FIXED `` | S7 | check_hn 2a worn arm |
| `` ### FOUND AT IR AND NOT FIXED `` | S7 | latent floor of a zero |
| `` ### FOUND AT IS AND NOT FIXED `` | S7 | Cryomancer's route |
| `` ### THE RULES A GATE COULD CHEAPLY HOLD `` | S7 | cheap gate; standing list |
| `` ### FOUND AT IU AND NOT FIXED `` | S7 | cheap gate |
| `` ### FOUND AT IK AND NOT FIXED `` | S7 | check_ij 3 pins |

## THE POPULATION ROWS THE TRIGGERS MATCHED — 6, AND WHAT EACH ADDS

| population row | subjects | the triggers that matched (verbatim) | member blocks | added beyond the subject triggers and the core |
|---|---|---|---|---|
| **the sim's recorded figures** | S1 S2 S3 | recorded sim figures; sim figures; which figures move; re-take; instrument fidelity | 11 | `` ### EVERY COMPLETION FIGURE DATED BEFORE GJ EXCLUDED THE FINAL FIGHT ``; `` ### Small, and still owed ``; `` ### FOUND AT IE AND NOT FIXED ``; `` ### Carried from the code, reported and deliberately not fixed `` |
| **the figures behind doors** | S5 | every figure a text states; figures behind doors | 6 | `` ### FOUND AT IJ AND NOT FIXED ``; `` ### FOUND AT HL AND NOT FIXED ``; `` ### `master.html` §6b's "66 DAMAGING ABILITIES" RESOLVES AGAINST NO POPULATION `` |
| **the bot's divergences** | S7 | sim bot; POLICY or RULE; the bot's rules | 6 | `` ### FOUND AT GS AND NOT FIXED ``; `` ### FOUND AT IE AND NOT FIXED ``; `` ### FOUND AT IM AND NOT FIXED ``; `` ### FOUND AT GE AND NOT FIXED `` |
| **the latent shapes** | S7 | latent shapes; latent defect | 10 | `` ### FOUND AT IC AND NOT FIXED ``; `` ### FOUND AT IL AND NOT FIXED ``; `` ### FOUND AT IM AND NOT FIXED ``; `` ### FOUND AT HY AND NOT FIXED ``; `` ### FOUND AT HZ AND NOT FIXED ``; `` ### FOUND AT FX AND NOT FIXED `` |
| **the save's keys** | S7 | load door | 3 | `` ## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND ``; `` ### HA's RULINGS OWED ``; `` ### FOUND AT HL AND NOT FIXED `` |
| **the positional picks** | S7 S8 | positional picks; positional census; MISSES ceiling | 4 | `` ### FOUND AT IM AND NOT FIXED ``; `` ### GY's RULINGS OWED `` |

**WHICH POPULATION ROWS ROUTED THIS BRIEF, ANSWERED BEFORE THE WORK** (§8.1). **Six of the nine name a subject.** *The sim's recorded figures* names S1, S2 and S3 (*recorded sim figures*, *sim figures*, *which figures move*, *re-take*, *instrument fidelity* — §1 changes the instrument's seeding and re-proves its fidelity, and §2 and §3 are sim figures taken through the bot); *the figures behind doors* names S5 (*every figure a text states*, *figures behind doors* — §0.5's count is a figure a text states, put behind a door); *the bot's divergences* names S7 (no POLICY row moves and RULE stays at 0); *the latent shapes* names S7 (the latent offer defect and the latent floor shapes stay latent); *the save's keys* names S7 (*load door* — the guard a frozen offer would need, not built); *the positional picks* names S7 and S8 (the thirteen standing picks, the positional re-run). **The other three name no subject**: *the claims* (IY writes no claim and repairs none; the brief's premises are verified in the report), *the closed matter* (the close's archive cut is housekeeping the brief does not name), *the target picks*. **The prediction the close-read will test**: the subject rows and *the sim's recorded figures* carry §1–§4; if a block outside the list bore on the seeding, the handles or the grades, it is the population rows' gap, and the close says so.

**Subjects no row's triggers name**: S9 is the index section itself, read whole. **S1's *seed a fight*** is named by FOUND AT IX's *seed per fight* and *paired by seed*, and by no other row; IX's report §1c is where the figure lives. **S2's handles** are named by no trigger but the grades block's *grade handles* — the nearest rows were matched by the quantity each handle is keyed on (the crit rule, `effective_speed`, the bar maximum, Chilled); **Slick Footing's `ab.delay`, Bloodletting's `mod_bleed_add`, Muffled's `mod_bd_mult` and Fleeting's `mod_status_turns`** are named by no trigger at all. **S3's *reach*** and **S4's *the higher cost*** are named by no trigger; FOUND AT IX's *healing takes up a tempo half* and the grades block's *the swing* carry them. **S5's *Warden's gamble band*** is named by no trigger but *safe_band*; the grades block carries the band table. Recorded so the close-read can say whether a trigger was missing.

## THE CORE — 15, READ WHOLE

- `` ## WHERE THE PROJECT IS ``
- `` ## THE OPEN QUEUE ``
- `` ### IX's RULINGS OWED ``
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

**67 blocks: the core (15), the 34 matched and the 18 the population rows added — 167,711 B of HEAD's 351,886, each read whole.**

## OPENED

**The core, the 34 matched blocks and the 18 the population rows added, each read whole: 67 blocks, 167,711 B of the file's
351,886 at HEAD.** No block outside the list was opened during the work. Reads outside the file, and what led there (data, not
failures):
- **The records were read in the reports they live in**: IX's report (§1's baseline and pairing, §2's one-sided halves, §3's scale,
  §4's swing) and `docs/reports/IX-scale.tsv` and `IX-onesided.tsv` (every arm's reading and paired cost — §2's old costs and §4's
  reference readings), IV's report §1c and `docs/reports/IV-drive.tsv` (the incumbent's arms §4 re-pairs), IW's report (the bargain
  fights' natural endings, §0.4's premise) and IJ's (the 402 conversions, §0.5's premise) — not blocks of this file.
- **The logs were read where they lie**: IX's §1 logs (the twins the fidelity check re-drove) and IV's incumbent logs, copied into IY's
  work folder and read through the copies.
- **The code reads** — `scripts/run_sim.gd` (`begin`, `walk_to_next_fight`, `on_battle_end`), `scripts/run_state.gd` (`MODIFIERS`,
  `DIFFICULTIES`' bands, the map build's `compose`, the offer's draw), `scripts/battle.gd`'s `_stamp_modifier` and each of the nine
  handles' read sites, `scripts/classes.gd`'s `figure_value` and `resolve_figures`, `data/glossary.json`'s modifier entry, and `lane.sh`
  — cited no block outside the list.
- **The gates that read a grade, a band, the offer, a modifier's words, the glossary, the resolver or the sim** — the 67 targets of
  the pre-check (FA §1b: HEAD's gates against IY's code) and the holders of the literal sweep's LOST and GAINED literals, each opened
  where it reds or holds, and `CLAUDE.md`'s ladder block and figure rule, `docs/instrument-rules.md`'s tie block, and
  `docs/master.html`'s bargain section.

## NEEDED

**The ones IY used, each for what it bore** (core marked):
- `` ## WHERE THE PROJECT IS `` (core) — replaced. `` ### IX's RULINGS OWED `` (core) — the five rulings the brief answered;
  archived whole, IY's in its place. `` ## THE OPEN QUEUE `` (core) — its heading, over IY's rulings.
  `` ### THE PLAYTEST'S OTHER FINDINGS `` (core) — the roadmap's item that the free modifiers wait on IX's rulings, archived, IY's in
  its place. `` ### THE SHAPE RECON ON `CLAUDE.md` `` (core) — where the close's readings sit.
- `` ### THE BARGAIN DECK's GRADES `` — rewritten off IY's grades; IX's block archived whole. `` ### FOUND AT IX AND NOT FIXED `` —
  its pairing item built (§1, archived), its healing item read at an extreme (§3, amended in place); FOUND AT IY above it.
- `` ### THE SIM's FIGURES, RE-TAKEN AT IW `` — the incumbent's readings, §4's second population, and the bot every arm goes through.
  `` ### FOUND AT IN AND NOT FIXED `` — the rung bands read, not re-set (§5). `` ### HW's RULINGS OWED `` — the glossary's count
  IX deleted, behind its door now (§0.5). `` ### FOUND AT IO AND NOT FIXED `` and `` ### FOUND AT ID AND NOT FIXED `` — the Long
  Silence's exemption and Mirrorbound's recoil scope, beside two grades' handles §4 reads.
- `` ### THE CRIT SURPLUS IS RULED END TO END ``, `` ### FOUND AT FW AND NOT FIXED ``, `` ### FOUND AT IG AND NOT FIXED ``,
  `` ### FOUND AT IF AND NOT FIXED `` and `` ### HOW LONG A FIGHT IS `` — the quantities §2's handles are keyed on (crit and its floor,
  `effective_speed`, the bar's maximum, Chilled, the fight's length), read for the predictions; every figure IY's values were derived
  from is the code's or IY's own measurement.
- `` ### THE FIRST CLEAN PLAYTHROUGH `` — the one run no sim replaces (§7). `` ### FOUND AT GK AND NOT FIXED `` — `save-backups/`
  untracked, so the commit names its files. `` ### FOUND AT HT AND NOT FIXED `` and `` ### FOUND AT HW AND NOT FIXED `` — the
  acceptance with the designer's game shut. `` ### FOUND AT GN AND NOT FIXED `` — `check_gj` §4's sanctioned red, whose figures
  IY's re-grade moves again.
- `` ### THE TEST TREE, AS OF EF ``, `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` and
  `` ### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED `` — `check_iy`'s rows and holders, the manifest's floor, and the
  sanctioned reds. `` ### FOUND AT IT AND NOT FIXED `` — the positional census the re-run reads.
- **Opened and not needed**: the core's CREST POOL, FOUND AT IA, RULED AND NOT BUILT, FOUR OTHER CONJUNCTIONS, SKIRMISHER, TO WATCH
  IN PLAY, THE CLERIC's MANA RATE, SANCTITY's STEP, BOIL OVER'S RATE and FOUND AT HX; FOUND AT IW, FOUND AT GJ, Carried with
  measurements attached, THE REST, KNOWN-BROKEN AND DELIBERATELY UNFIXED, Carried and still awaiting a ruling, Knowledge sync, THE
  RULES A GATE COULD CHEAPLY HOLD; FOUND AT IQ, IR, IS, IU, IK; LIVE COUNTS AND CONSTANTS; and the population rows' Carried from the
  code, EVERY COMPLETION FIGURE DATED BEFORE GJ, FOUND AT FX, GE, GS, HL, HY, HZ, IC, IE, IJ, IL, IM, GY's and HA's RULINGS OWED,
  Small and still owed, and `master.html` §6b's 66 — each read whole and found to hold nothing IY's work used or moved.

## FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED

**Every block IY did not open was read at the close, whole — 72 of them (the 139 blocks below the index fence at HEAD less the 67
opened), 129,343 B of HEAD's text, unchanged by IY — by a reader outside the working read** (its table is kept in IY's work folder,
route/close_read.tsv; the reader was given what IY changes, the routing and the index, and nothing of the working read). **1 bore on
the work, 0 stale because of IY; it was NOT ROUTED — the index's miss, not the working read's:**
- `` ### The changelog `` — bore, **NOT ROUTED**: it holds the live changelog's 400 KB bar (`check_fg` §1, warn then fail), *do not
  count this by hand*, and what a cut owes (`check_dv` §4, `check_ec` §2, the manifest). IY adds an entry to a file that stood at
  387,694 B at HEAD (390,749 B after it), and IY's FOUND AT IY queues *the changelog nears its threshold*, which these facts govern;
  nothing in the block is made false. **No subject of the brief names the changelog**, and the block's triggers name a cut, never
  the headroom before one — so no routing could have reached it. **The upkeep adds the reader's triggers to its row** (below).
**And two lines stale before IY — not misses: neither block bore on the work — found by the reader and confirmed against the code**
(not caused by IY; each repaired to the code with its batch named): FOUND AT HA's *`check_cl_resolver` … the raw text* — `check_cl_resolver` resolves through the figure door
  since IT §2 (its `Classes.resolve_figures` read); GW's RULINGS OWED's *a ceiling of 90* — `check_gw`'s `SHAPE_CEILING` is 96.

**The reader's borderline calls, kept NO with their reasons**: FIVE MORE THINGS FH FOUND (three rules that bind `check_iy` — the
parse read off stderr, the typed-var manifest blindness, the band asymmetry — but each stated in `docs/instrument-rules.md`, which
binds IY directly); FOUND AT GY (nothing asserts design-notes order; the newest-first rule binds IY's entry through `CLAUDE.md`);
the `master.html` stamp block (IY moves the stamp with its bargain-section edit); FOUND AT GB (`check_du` §4 asserts only that
Tinderbox's stamp writes a non-empty typed bonus, which +0.75 keeps); FOUND AT HO (it cites `check_hp` §1e and §2; IY re-points only
§1b's Dull Edge needle).

## THE INDEX's UPKEEP

**13 of 149 entries in the final index touched at IY, 7 by hand** (2 written: IY's RULINGS OWED, in the
core's place by role — IX's row renamed, its block archived — and FOUND AT IY; 5 mended: THE BARGAIN DECK's GRADES (its label and
triggers), FOUND AT IX (its label and triggers, its pairing item archived), *The changelog* (two triggers the close-read proposed:
*changelog headroom*, *next changelog cut owed*), and the population rows *the sim's recorded figures* (IY's four tables and
`check_iy` §1–§4) and *the figures behind doors* (`check_iy` §2 and §5)). **The other 6 are stamp moves** that `index_stamp.py --write`
made because their blocks' text moved: the blocks IY wrote or edited (WHERE THE PROJECT IS, THE PLAYTEST'S OTHER FINDINGS' roadmap
item, FOUND AT HA's and GW's RULINGS OWED's stale lines) and two population rows whose member blocks moved (*the bot's divergences*,
which lives in THE BARGAIN DECK's GRADES, and *the latent shapes*, in FOUND AT IX). HEAD's index held 148 entries; IY's holds 149. `index_stamp.py` re-run after the write reads every stamp current.
