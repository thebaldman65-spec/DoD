# IV — THE ROUTING OF RECORD

Part of IV's report (`docs/reports/IV.md`). **Written before the work began** (23:16 on 2026-10-24, before any edit): the brief's
subjects, the index rows whose triggers name them — each with the trigger that matched, verbatim from its row — and the core.
**That list plus the core is what IV opened, the core whole.** The file read is HEAD's `docs/state.md` (`91ce490`, 135 entries).
**§6's population rows are not yet available to this routing**: they are what IV builds, so this record was routed by subject
triggers alone, the way IU's was, and the three population subjects of this brief (S3 *every figure taken from a default sim*,
S4 *every environment read*, S6 *the claims*) met rows only where a trigger happens to name a member.

## THE BRIEF'S SUBJECTS

- **S1** the bargain's rune cache the sim never answers (DV26) and the elite's order — the draft before the cache, a core rune held unworn (DV27); `map_screen._take_rune_pick`'s path; the bot's cache policy (§1a)
- **S2** the merchant's doors — the potion at the stack cap (DV24), the rune at a full bag or holding (DV25); the comment at `run_sim.gd:584-590` (§1b)
- **S3** what moved, measured: every figure taken from a default sim — the dry shares, the Hourglass readings, Sanctity's figures, completion and depth, the rune-supply figures, the bargain ladder's 26 recorded figures; the superseded-pending marks (§1c)
- **S4** the experiment arms that leak out of the sim (DV32): `DOD_SIM_RUNES`, `DOD_SIM_GRANT_ALL`; every environment read in the game scripts, one row each (§2)
- **S5** the four remaining repairs — the fallback bodies (DV11), the zone boss's pick and the cap (DV29), `_autoplay_pick` re-asking the door (DV05, DV06, DV07); the divergence census's RULE count at zero as a ceiling, beside `check_gw`'s and IU §5's (§3)
- **S6** the claims — IR01's qualification, IR09's and IR50's sentence replaced by HY §6's rule, the ledger amended in place; GK's three spine-rune names, reported read-only (§0.2, §4)
- **S7** the index question for `CLAUDE.md`, closed by IU §2's derivation, written in HN's shape-recon block; the pilot ends; the close-read renamed and kept; the 188 cheap gates and their 76 NONE rules as a standing list under a ceiling (§0.1, §5)
- **S8** the index's population rows, derived from the last ten briefs' subjects (§6)
- **S9** a rule and its own gate contradicting — the code decides; the strike-loop rule against `check_ft` §6c (§0.4)
- **S10** housekeeping — the move not attempted, `lane.sh` for every launch, the designer's files, the user-data folders and the one clearing command (§7)
- **S11** the verification — a new gate (`check_iv`), its baselines rows, the battery, the manifest, the seeded roads that re-select, the positional re-run, the controls (§9)
- **S12** the two readings, `CLAUDE.md`'s and this file's (§9)
- **S13** what is deliberately not done — the 438 pins, the thirteen standing picks, `check_it` §2c's arm, `check_hn` §2a's worn arm, the Chilled row's *4*, the latent floor shapes, the Cryomancer's route, the ally pools (POLICY), the deck's middle (§8)

## THE ROWS THE TRIGGERS MATCHED — 35

| block | subjects | the triggers that matched (verbatim from its row) |
|---|---|---|
| `` ### FOUND AT IU AND NOT FIXED `` | S1 S2 S4 S5 | bot divergence census; bot plays a different game; DV05 DV07 DV24 DV25 DV26 DV27 DV29 DV32; sim experiment arm |
| `` ### FOUND AT HR AND NOT FIXED `` | S1 S3 | sim bargain rune cache; rune supply figures |
| `` ### HW's RULINGS OWED `` | S1 | class rune draft; crest rune in elite cache; roll_rune_candidates |
| `` ### GV's RULINGS OWED `` | S1 | cache rolled with engine out |
| `` ### THE BARGAIN DECK's GRADES `` | S3 S13 | bargain modifier severity grades; re-grade; bot ally pools heroes-only |
| `` ### THE FIRST CLEAN PLAYTHROUGH `` | S3 | bot sim figures Sanctity steps dry turns |
| `` ### FOUND AT IM AND NOT FIXED `` | S3 | Sanctity figures |
| `` ### FOUND AT IE AND NOT FIXED `` | S3 | Mage Burn sim figures |
| `` ### EVERY COMPLETION FIGURE DATED BEFORE GJ EXCLUDED THE FINAL FIGHT `` | S3 | run completion rate; untalented completion; depth 49 |
| `` ### Small, and still owed `` | S3 | stale sim figures |
| `` ### HOW LONG A FIGHT IS `` | S3 S4 | sim confounders; DOD_SIM_ROWS |
| `` ### HJ's RULINGS OWED `` | S4 | DOD_SIM_GRANT_ALL; debug_grant_all; sim experiment arm |
| `` ### FOUND AT GB AND NOT FIXED `` | S4 | DOD_SIM_RUNES runes_mode |
| `` ### FOUND AT GF AND NOT FIXED `` | S4 | master.html debug paragraph |
| `` ### FOUND AT GP AND NOT FIXED `` | S5 | Formless |
| `` ### FOUND AT IK AND NOT FIXED `` | S5 S13 | Mass Hysteria; check_ij 3 pins |
| `` ### FOUND AT GL AND NOT FIXED `` | S5 | Shrapnel Charge |
| `` ### FOUND AT GJ AND NOT FIXED `` | S5 | sim zone-boss awards; slot ladder 10 |
| `` ### THE BOSS-PICK POOLS `` | S5 | zone-boss award fallback |
| `` ### GW's RULINGS OWED `` | S5 | check_gw 2 ceiling 90 |
| `` ### FOUND AT IT AND NOT FIXED `` | S5 S13 | positional census MISSES ceiling; Chilled status row |
| `` ### GK's RULINGS OWED `` | S6 | Rune of the Vanguard Invoker Hierophant; SPINE_INFO |
| `` ### FOUND AT GA AND NOT FIXED `` | S6 | re-derive reference claims; stale claims |
| `` ### FOUND AT HV AND NOT FIXED `` | S6 | stale CLAUDE.md lines |
| `` ### THE REST `` | S6 S11 | sanctioned red baselines.json |
| `` ### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED `` | S6 S11 | baselines.json flake field |
| `` ### THE TEST TREE, AS OF EF `` | S11 | baselines.json rows; new gate rows; run_battery.sh GATES; check_de differ |
| `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` | S11 | build_pin_manifest.py; pin-manifest.json |
| `` ### FOUND AT HT AND NOT FIXED `` | S10 S11 | player-file arm; run_battery.sh game open |
| `` ### FOUND AT HW AND NOT FIXED `` | S11 | run_battery.sh game open; kill battery |
| `` ### FOUND AT GK AND NOT FIXED `` | S10 | save-backups untracked |
| `` ### Carried, and still awaiting a ruling `` | S12 | CLAUDE.md ceiling |
| `` ### Knowledge sync, re-measured at EG `` | S12 | CLAUDE.md ceiling |
| `` ### FOUND AT IQ AND NOT FIXED `` | S13 | check_hn 2a worn arm |
| `` ### FOUND AT IR AND NOT FIXED `` | S13 | latent floor of a zero |

**Subjects no row's triggers name**: S7 and S8 are the index section itself and the core's shape-recon block, read whole; **S9** (the strike-loop
rule against `check_ft` §6c) is named only in the core's IU's RULINGS OWED; **S13's *Cryomancer's route*** is FOUND AT IS's, whose
triggers name its cards and not the route. Each is recorded here so the close-read can say whether a trigger was missing.

## THE CORE — 15, READ WHOLE

- `` ## WHERE THE PROJECT IS ``
- `` ## THE OPEN QUEUE ``
- `` ### IU's RULINGS OWED ``
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

## OPENED

**The core and the 35 matched blocks, each read whole: 50 blocks, 135,555 B of the file's 326,275 at HEAD.** Reads outside the
matched list, and what led there (data, not failures):
- **§1c's figure list was swept by grep over the whole file** for rune-supply and sim figures before the drive (`runes a hero`,
  `per hero per run`, decimals beside *rune*): it met `` ### Carried from the code, reported and deliberately not fixed `` (EQ's
  3.44 acquired, which IV marked) and `` ### FOUND AT HR AND NOT FIXED ``'s cache item, already matched — **and it did not read the
  sentence it met whole**: the 6.98 bought beside the 3.44 stayed unmarked until the close-read found it.
- **§1c's records were read in the reports they live in**: HR §1c (the supply table), IP §1b (the 23 grades), IO §2–§3 (the ladder
  and Sanctity's table), IG §2a and §4c, IF §0.1b, IE §1b, GJ §1b — not blocks of this file.
- **§2's and §1a's code reads** cited `` ### HJ's RULINGS OWED `` (`DOD_SIM_GRANT_ALL`, matched) and nothing outside the list.

## NEEDED

**The ones IV used, each for what it bore** (core marked):
- `` ## WHERE THE PROJECT IS `` (core) — replaced. `` ### IU's RULINGS OWED `` (core) — the four rulings the brief answered; archived
  whole, IV's in its place. `` ## THE OPEN QUEUE `` (core) — its heading, over IV's rulings.
- `` ### THE CLERIC's MANA RATE `` and `` ### SANCTITY's STEP `` (core) — the dry shares, the Hourglass readings and Sanctity's
  figures §1c drove; the bar's pointer added. `` ### BOIL OVER'S RATE `` (core) — HZ's default-sim Rage figures, named not read.
- `` ### THE PLAYTEST'S OTHER FINDINGS `` (core) — the roadmap: the pilot's decision taken, the deck's middle owes the re-take.
  `` ### THE SHAPE RECON ON `CLAUDE.md` `` (core) — where §5's close is written.
- `` ### FOUND AT IU AND NOT FIXED `` — the ten RULE defects, built and archived (S1 S2 S4 S5). `` ### FOUND AT HR AND NOT FIXED `` —
  the bargain's cache (DV26), archived. `` ### FOUND AT GB AND NOT FIXED `` — `DOD_SIM_RUNES`, archived. `` ### HJ's RULINGS OWED `` —
  `DOD_SIM_GRANT_ALL` arms the player's debug grant (§2's premise).
- `` ### THE BARGAIN DECK's GRADES `` — the 26 the drive read, and the line it gains. `` ### THE FIRST CLEAN PLAYTHROUGH `` — the
  bot's 2.2× status events beside Sanctity's figures. `` ### EVERY COMPLETION FIGURE DATED BEFORE GJ EXCLUDED THE FINAL FIGHT `` —
  what a completion figure counts (GJ's). `` ### FOUND AT IM AND NOT FIXED `` — Sanctity's population.
- `` ### FOUND AT GP AND NOT FIXED ``, `` ### FOUND AT IK AND NOT FIXED ``, `` ### FOUND AT GL AND NOT FIXED ``, `` ### FOUND AT GJ AND
  NOT FIXED `` and `` ### THE BOSS-PICK POOLS `` — Formless (DV06), Mass Hysteria (DV07), Shrapnel Charge (DV11), the zone boss's
  awards (DV29): the code each repair touched.
- `` ### GW's RULINGS OWED `` and `` ### FOUND AT IT AND NOT FIXED `` — `check_gw`'s ceiling and IU §5's, beside which RULE 0 is
  written. `` ### GK's RULINGS OWED `` — the names §4 reports.
- `` ### THE REST `` and `` ### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED `` — IR09's and IR50's restatements, which carry
  their batches and stand. `` ### THE TEST TREE, AS OF EF `` — a new gate's rows. `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT
  HOLDS ITS PATH IN A `const` `` — the shape `check_iv`'s holders avoid. `` ### FOUND AT GK AND NOT FIXED `` — `save-backups/`
  untracked, so the commit names its files.
- **Opened and not needed**: HW's and GV's RULINGS OWED, Small and still owed, HOW LONG A FIGHT IS, FOUND AT GF, GA, HV, HT and HW,
  Carried and still awaiting a ruling, Knowledge sync, FOUND AT IQ and IR, FOUND AT IE (its Burn item is DV17's, a POLICY row
  unchanged), and the core's CREST POOL, FOUND AT IA, RULED AND NOT BUILT, FOUR OTHER CONJUNCTIONS, SKIRMISHER, TO WATCH IN PLAY and
  FOUND AT HX.

## FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED

**Every block IV did not open was read at the close, whole — 85 of them (the final file's 138 blocks less the 50 opened and IV's own three new ones), 147,295 B — by a reader outside the working read** (its table is kept in IV's work folder, route/close_read.tsv). **8 bore on the work, 1 of them stale; 3 ROUTED, 5 NOT ROUTED**, every unrouted row given the trigger the reader found missing:
- `` ### FOUND AT IS AND NOT FIXED `` — bore, **NOT ROUTED**: accurate; the Cryomancer route IV §8 keeps (row given its trigger)
- `` ### FOUND AT IN AND NOT FIXED `` — bore, **NOT ROUTED**: accurate; `_take_offer`'s false comment stands BY DESIGN — DV30, a POLICY row the brief does not change, cites it (row given its trigger)
- `` ### FOUND AT IF AND NOT FIXED `` — bore, **ROUTED**: its Rupture rate is a default-sim figure the drive could not read (no cast booked) — named in WHAT IV's DRIVE MOVED for the re-take
- `` ### FOUND AT GR AND NOT FIXED `` — bore, **NOT ROUTED**: accurate; the ways-of-working header is its own recorded item, not IR01's sentence (row given its trigger)
- `` ### THE THREE SPINES ARE BUILT AND ALL THREE RATES ARE SET (FU, FV); WHAT IS STILL FLAGGED `` — bore, **ROUTED**: accurate (names proposed; the blow met, IV §0.4); its strike-loop half given a trigger
- `` ### Carried, with measurements attached `` — bore, **NOT ROUTED**: retired configurations, no mark owed; a member of the sim's recorded figures (row given triggers)
- `` ### Carried from the code, reported and deliberately not fixed `` — bore, **NOT ROUTED**: **STALE — REPAIRED**: EQ's 6.98 runes bought was a moved figure left unmarked; measured (−0.58 ± 0.10 a run) and marked, the pointer covers both, the block joins the population row and its row its triggers
- `` ## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND `` — bore, **ROUTED**: true: the pouch caps and the slot ladder the doors IV made the sim ask
- **The miss that mattered** is the one the working read made by grep: a sentence met in part is not a sentence read. **And the ROUTED three** (FOUND AT IF by *Rupture rate in sim*, THE THREE SPINES by *spine runes*, LIVE COUNTS by *ABILITY_SLOTS_BY_BOSS*) were rows whose trigger named a subject the routing step matched elsewhere and did not follow — the routing reads triggers against a subject's words, and these three name it in the record's own words.

## THE INDEX's UPKEEP

**28 of the index's 147 entries touched at IV — 24 by hand** (13 written: IV's RULINGS OWED, WHAT IV's DRIVE MOVED, FOUND AT IV, THE RULES A GATE COULD CHEAPLY HOLD and the nine population rows; one gone with its block, IU's RULINGS OWED; 10 mended — the four blocks IV changed whose labels or triggers moved, and the close-read's six) **and 4 re-stamped after a re-read left their rows as they were** (## WHERE THE PROJECT IS, ### THE CLERIC's MANA RATE, ### THE PLAYTEST'S OTHER FINDINGS, ### THE SHAPE RECON ON `CLAUDE.md`). (IU: 30 of 135, 27 by hand.)
