# Dawn of Decay — project guide for Claude

Turn-based party roguelike (Godot 4.7, GDScript). **`docs/master.html`
("DoD Master Document.docx") is the authoritative design reference** — keep it
updated alongside `docs/addendum.html` (the living changelog). The original
`../*.docx` concept docs are superseded by both.

## Working agreement (user's standing rules)
- User is a beginner coder: explain plainly; Claude writes all code; user is
  the designer + playtester. Iterate on their feedback each session.
- EVERY design change: (1) update `docs/master.html` (current truth) and bump
  its "Last updated" timestamp; (2) add an entry to `docs/changelog.html`
  (newest first); (3) rebuild both docx via `python3 docs/build_docs.py`
  (unwraps paragraphs — plain textutil makes Word spacing weird; exports are
  Arial size 14 by user preference); (4) append a short "why" entry to
  docs/design-notes.md — rationale only, not instructions.
- master.html shows ONLY what is currently in the game (user rule 07-20):
  no vault lists, no "was/now/moved/reworked/renamed" notes, no decision
  dates — change history belongs in changelog.html alone.
- Terminology: damage against the Break meter = "Break damage (BD)" everywhere.
- `docs/addendum.html` is RETIRED (frozen history; do not update it).
- User drops new assets in `../imported files/` — always check there.
  New character sprites need the Soldier format: 100x100 frame strips named
  `Name_Idle/Walk/Attack01-03/Hurt/Death.png`.
- Commit AND PUSH (origin/main) after each change batch. Launch the game for playtesting via
  `/Applications/Godot.app/Contents/MacOS/Godot --path <this dir>` (background,
  watch stderr for errors).

## Verify before shipping
- Parse: run each scene headless with `--quit-after 90`, grep "SCRIPT ERROR".
  **TWELVE scenes since Batch BK** (blacksmith is new). `check_parse.gd`
  force-loads every script and scene in one pass and is the faster gate.
- **`check_map.gd` (Batch BK) is the MAP GENERATION instrument**: N generated
  zones → node count, column widths, out-degree, foreclosure depth, the entry
  guarantee, reach contiguity, and the walked distribution under an unsteered
  route plus the three policies. ~0.2s a zone (26 warbands pre-rolled for
  hover-scouting), so 1500 zones is ~5 minutes.
- **`check_map_screen.tscn` (Batch BK) is the only thing that EXECUTES the
  lattice draw.** The scene-parse gate loads map.tscn with no active run, so
  it bounces to the main menu and never draws a node. This builds the screen
  against a real in-flight run at three positions and opens both overlays.
  It is a SCENE run, not `--script`: **autoloads (`Run`) do not resolve in a
  `--script` SceneTree.**
- **`test_batch_bl.gd` NEEDS `--fixed-fps 12` AND IT IS NOT THE sim.sh FLAG.** sim.sh passes
  240 to make frames run back-to-back in WALL time; this suite passes 12 to make each frame a
  big TIME step, because a real-play battle paces itself with `create_timer` waits and §2's
  ledger can only be read after a fight ENDS. At the default step a three-orc fight does not
  finish inside any sane frame budget; at 12 it finishes in ~700 frames and nothing the battle
  computes reads delta. Any future suite that has to run a REAL-PLAY battle to completion wants
  the same trick.
- New `class_name` files need `--headless --import` before they resolve.
- **RUNNING THE FULL SUITE BATTERY DESTROYS THE PLAYER'S IN-PROGRESS RUN (Batch BN, learned the
  expensive way).** Twenty-five suites spawn a live battle, which means `Run.new_run` and
  `clear_save`, and **`user://run_save.bin` is simply gone afterwards** — several suites back it
  up and restore it, but a LATER suite in the battery then wipes it again, so the individual
  backups buy nothing when the whole battery runs. `profile.json` survives with a few counters
  incremented (runs_started, occasionally a forfeit) and `relics.json` is byte-identical, so the
  META layer is safe; it is the run in flight that is lost. **Copy `run_save.bin` aside before a
  battery run if the designer has a run going**, and say so afterwards either way.
- Balance: `./sim.sh N` = N battles of the FIXED raider/chief/archer/archer
  lineup (power 7, unscaled) — kit smoke tests only; its win% carries NO
  difficulty signal (Batch R). **sim.sh passes `--fixed-fps 240` since Batch
  BJ §1 — 5.3x faster (headless frame-sync sleep removed), nothing the sim
  computes changes; a --run 100 is ~8 minutes. Every report ends with the
  BJ §3a signature-payoff table (per-spec signature moments, trash | boss).** `./sim.sh --sweep N` (DOD_SIM_SWEEP=1) = N
  battles at EACH budget 3/6/9/12, fresh fight-theme warband per battle,
  enemies unscaled (`DOD_SIM_ZONE` picks the roster); per budget it also
  prints avg enemy count, avg enemies alive entering round 3, and per-hero
  damage share (Batch S — a DOD_SIM_THEME'd sweep = per-theme share for
  free). `./sim.sh --run N` (DOD_SIM_RUN=N, def 50) = N COMPLETE runs with
  progression BOTH sides (tier scaling + slot mult, HP/mana/item carry,
  points earned AND spent, elite runes auto-equipped, trophies) → run
  report: wipe distribution, per-tier averages, measured party-vs-warband
  power table + run economy (gold earned/spent/unspent, items used/left,
  merchants/events/**blacksmiths**/bargains per run — **NOT rests: Batch AN
  deleted them and the "taken vs offered" row reads 0.0/0.0 forever**) + a
  per-invocation "Matrix row" line for cross-policy assembly. Policies
  env-set + printed: DOD_SIM_ROUTE (**greedy|balanced|cautious** since Batch
  BK, one axis — how much ELITE the bot accepts; `default` ALIASES balanced
  and `elites` ALIASES greedy so old scripts and Matrix rows still resolve).
  **BATCH BG §1 MEASURED WHAT THE THREE POLICIES WERE WORTH ON THE LINE AND
  THE ANSWER WAS NOTHING** ("Reachable nodes per step: 1.00 — steps offering
  a real choice: 0% (0 of 2764)", every node type taken == offered): from AN
  to BJ the three route rows were THREE SAMPLES OF ONE CONFIGURATION.
  **BATCH BK MADE THEM A REAL BAND AGAIN** — 1.61 reachable per step, 41% of
  steps a real choice, and the three policies walk 6.5 / 6.0 / 2.2 elites a
  run. A pre-BK three-policy row is still a triplicate, not a bracket; a
  post-BK one is a bracket.
  **BATCH BG §1 STANDING CAUTION ON EVERY RUN BAND: `DOD_SIM_BUILDS`
  DEFAULTS TO EACH TREE'S FIRST LANE, AND THAT IS A CONFOUND WITH A KNOWN
  SIGN.** For the default party the first lane is Berserker Bloodletting,
  Cryomancer Winter, **Devout BULWARK — the lane BF measured at 14% against
  FAITH's 33%** — and Beastmaster devotion. Two of those four ARE the lanes
  their own batches measured as standouts, so a default-vs-named comparison
  is a two-hero difference, not a four-hero one. **Always print the build
  string beside a run number**, DOD_SIM_SHOPS=off / DOD_SIM_ITEMS=off
  (both default ON: shops heal-first — hero <50% buys a Health Potion each —
  then priciest affordable offer not carried, runes incl. but only onto a
  free slot + equipped at purchase, never dipping under the 40g reserve;
  battle bot drinks a carried Health Potion opening a turn <35% HP, run
  sims ONLY — sweep/standalone stay dry so R/S baselines hold),
  DOD_SIM_BUILDS="spec:Lane,...", DOD_SIM_TROPHIES, DOD_SIM_RELICS (draft),
  DOD_SIM_ROTATE=1 (Batch W: rotate all twelve specs; see the Batch W
  block below — shares then carry sample counts),
  DOD_SIM_DIFFICULTY=wanderer|warden|ruin — a RUNG of BM's ladder
  (x0.50 / x1.00 / x1.30 through zone_base_mult; "standard" still
  resolves and maps to warden). **THE DEFAULT IS RUNG 1 SINCE BATCH BM
  AND THAT IS THE TRAP: an unset flag is NOT the old baseline.** A row
  meant to compare against a pre-BM number must set warden explicitly,
  and BATCH BN MOVED RUNG 1 FROM x0.70 TO x0.50, so an unset-flag row
  taken before BN is not comparable with one taken after it either),
  DOD_SIM_RUNE_ECON=rich / DOD_SIM_RUNE_POWER=<mult> (Batch AD
  EXPERIMENT ARMS — measurement only, never shipped; UNLIKE every other
  flag here they are gated on Run.sim_run as well as the env, so a stale
  export cannot put a real run in an arm. rich = all slots from t1 + a
  spec-eligible authored rune granted at each zone half-mark; power = a
  multiplier on authored payload UPSIDE only, costs held, tpl_* stat
  sticks untouched).
  RETIRED IN BATCH AN, along with the features they controlled, and NOT
  revived by BK: DOD_SIM_MAP, DOD_SIM_MINIBOSS (the mini-boss is structural
  — slot 8 of every zone), DOD_SIM_START_RUNE and DOD_SIM_SPEC_OPENING
  (heroes begin with no runes). Matrix rows read **`map=branch`** since
  Batch BK (`map=line` = an AN-to-BJ row), carry no start=/specopen=/mb=
  field, and report depth out of **48 SLOTS** — so NO PRE-BK ROW IS
  COMPARABLE WITH A POST-BK ONE, and no pre-AN row with either.
  RunSim
  (scripts/run_sim.gd statics, Run injected Events-style) owns setup/map
  walk/report; battle.gd hooks: _ready begin+note_battle_start, _check_end
  sim branch → RunSim.on_battle_end. Run.sim_run=true makes
  save_run/clear_save NO-OPS (sims can never touch the real save) and no
  Profile/Relics.unlock calls exist in RunSim. GOTCHA: children added in a
  SceneTree script's _initialize never fire _ready (root not ready) — park
  scene-spawning tests on the first process_frame (scratchpad
  test_run_harness.gd = the 3 correctness gates: hero win scaling, talent
  spend conservation, enemy tier×slot scaling — rerun it before trusting
  any --run report after touching spawn/scaling code). Batch S verdicts:
  Cryomancer share FALLS with field size (49%→38%, budgets 3→12) = baseline
  overtune, fix his NUMBERS not his AoE; fields are empty entering round 3
  at every budget; --run 50 floor = 0/50 completions, wipes cluster z1
  t4-7 where the budget ladder stepped 3-6→6-9 (pre-T) and the measured
  power ratio crossed under 1.0 (1.25 t1 → 0.80 t4-6 → 0.55 t8) — early
  attrition throttles the progression meant to close the gap (2.8
  pts/hero/run earned at the floor vs the ~35 the economy assumes).
  BATCH T (08-01) closed it, staged + measured per stage: (1) awakening
  HP sync — Run.sync_spec_hp raises current HP by the spec block's
  max-HP delta, never to full; called from BOTH paths (spec screen
  _choose + RunSim.start_run) — alone took t4 win 44%→79%; (2) budget
  ladder → continuous ramp (see ENCOUNTERS below) — killed the t4
  cliff (ratio 0.77→1.16); (3) tier scaling halved to +2% Atk/+2.5% HP
  (slot mults untouched) → FIRST completions: 2/50 full clears, 20/50
  reach the z1 boss (70% win), z1 ratios t3-8 in band (0.95-1.28),
  t1-2 high (1.37/1.42), t9-10 low (0.87/0.78), boss 0.70 (boss kept
  its 10-12 band by design — tail levers are ramp slope or boss band,
  never spec numbers); (4) income stage SKIPPED — mid-band closed
  without it; income self-recovered 3.8→9.3 pts/hero/run (the
  attrition→income loop unwinding IS the mechanism of every gain).
  Damage shares stable through all stages (Cryo 38-39%) = overtune is
  tier-independent; outlier pass still deferred. BATCH U (08-01)
  verdicts — ROUTING WAS NOT THE STORY: 4-row matrix at 50 runs
  (greedy floor-control shops/items off = T reproduced: 2/50, 22 boss
  entries 82%, boss ratio 0.69 — baseline controlled), then greedy/
  default/cautious with the economy on = 0%/6%/8% completions, wipe
  median t9-10 → z1 boss. Even at 80% rest threshold 46/50 wipe; the
  t4-7 cluster thins 15→10 but the curve's shape survives every
  policy, so T's calibration was NOT depressed-floor artifact and the
  tail levers stand (z1 t9-boss 0.86/0.82/0.68; z2 collapses by t7
  0.66; z3 tail 0.37-0.43). Rests: even cautious is only OFFERED ~4
  /run (1-step reachability hides the deck's 5/zone) and takes 2.6 vs
  floor's 1.6 — the old harness left ~1 rest/run on the table, not 5.
  Gold pile was real (422g/run unspent at the floor); policy spends
  ~half (2.2 runes + 1.5 heals/run, 40g reserve blocks the rest),
  bot drinks 3.8-4.3 potions/run — all worth +2-4 completion pts.
  Honest-floor reads: 60% of cautious runs reach the z1 boss (77%
  win, ~46% clear z1 vs T-floor's 28%) — Z1 IS ROUGHLY RIGHT, RUNS
  DIE IN Z2-Z3; Cryo 38-40%/Devout 4% at the honest floor too →
  outlier pass finally has ground to stand on. Matrix rows come from
  the per-invocation "Matrix row:" report line — assemble across
  runs, never rerun one row against another batch's flags. test_run_harness.gd RECREATED (scratchpad dies with its
  session): gate 1 win scaling + HP-sync asserts, gate 2 talent
  conservation via ceil(N/3) price replay (converted lane trees KEEP
  multi-rank nodes — extra ranks cost 1), gate 3 enemy tier×slot at
  the new rates; plus probes for ramp rolls and theme satisfiability
  (elite themes need budget ≥6 in every roster — hence the elite
  floor). Batch R baseline
  (gated kits, 200/budget, win% at budgets 3/6/9/12): roster 1
  100/100/98/93.5, roster 2 100/100/97.5/88.5, roster 3 100/100/99.5/98.5;
  deaths/battle climb 0.01→1.3-1.5 — attrition is the sensitive dial. The
  ~85% target describes top-band (budget 10-12) encounters; tune against
  the curve, never one point. `DOD_AUTOPLAY=1` = 1 debug battle
  (echoes every combat-log line as "[LOG] ..." — grep it in headless tests;
  NOTE: the end screen waits for input, so headless autoplay runs never exit
  on their own — run with a timeout/kill or they pile up as zombies).
  `DOD_SIM_SPECS="berserker,cryomancer,inquisitor,beastmaster"` picks the bot's
  specs (warrior,mage,cleric,hunter order). `DOD_SIM_ENEMIES="boss,shaman,..."`
  forces the enemy lineup in test battles. `DOD_SIM_TALENTS="bz_bloodcraze:3"`
  force-learns talents on bot heroes whose spec tree has the id.
  **STANDING NOTE — HOW TO READ A LANE ROW (Batch BC §0). THE HARNESS IS
  PER-HERO; THE FLAG STRING IS WHAT HAS ALWAYS BEEN ONE-SPEC.** It walks EVERY
  hero and keeps whichever named ids appear in THAT hero's own tree — but all
  **288 node ids across the twelve trees are disjoint** (asserted in
  test_batch_bc), so a string naming one spec's lane builds exactly ONE hero.
  **THERE IS NOTHING TO FIX HERE AND FIXING IT WOULD BE WRONG** — name four
  lanes and four heroes build. What it means is that **EVERY LANE ROW EVER
  REPORTED — the Warden's Threat at 30%, Holy's Radiance at 50%, the Devout's
  Faith at 80% — IS A FULLY-BUILT HERO MEASURED AGAINST THREE UNBUILT ONES.**
  Those rows are honest A/B comparisons of one spec's lanes AGAINST EACH OTHER,
  which is mostly what they were used for; they are NOT "how much of a real
  party's work this hero does". **A CONTRIBUTION SHARE INFLATES TWICE THAT WAY,
  and the second half is the one nobody expects**: three unbuilt allies shrink
  the DENOMINATOR, and they also feed the NUMERATOR for a support, because they
  take more punishment and fights run longer. Measured on the Devout: enemy
  damage/battle 207 -> 74 and rounds/battle 7.8 -> 5.4 once the other three are
  built, and his releases fall 32.2 -> 11.1 with them. **THE LEVEL MOVES A LOT
  AND THE LANE RANKING BARELY MOVES** (FAITH/ungeared is 4.4x one-hero and 5.0x
  all-four), so a re-measure is only owed where a row was read as an absolute.
  **BATCH BE BUILT THE ALL-FOUR LANE CONTROL SET FOR THE DEVOUT, which BC's grid
  lacked — use it rather than re-deriving it** (n=200, same lineup, other three
  on berserker Bloodletting + cryomancer Thaw + beastmaster devotion): **FAITH
  33% | ZEAL 31% | BULWARK 14% | ungeared 11%**, against the one-hero 54/42/23/18.
  **The FAITH cell is BF's re-measure (BE read 45 / 73 before its §2 condition);
  ZEAL, BULWARK and ungeared are BE's and are byte-identical by construction —
  a build without `dv_communion` makes no Communion draw at all.**
  **STANDING NOTE — WHAT A CONTRIBUTION SHARE CAN AND CANNOT SEE. THE BLIND SPOT
  BE §4 FOUND (Batch BE) IS CLOSED (Batch BF §1), AND WHAT CLOSED IT WAS TWO NEW
  COLUMNS, NOT A NEW SHARE.**
  **WHAT THE OLD COLUMN IS, AND IT IS NOW LABELLED AS SUCH: `d+h+p%` (it was
  called `contrib%`, and at least one number in this project's history was read
  the second way) = `(dmg + heal + prev) / pool`, pool built in `_stat` from
  exactly three key prefixes — `dmg_hero_`, `heal_hero_`, `prev_hero_`. THAT
  COLUMN DID NOT MOVE BY A POINT IN BF and must not: it is the control that makes
  every pre-BF row comparable with every post-BF one.** The table prints a legend
  under itself saying outright that it is not a share of the party's work.
  **WHAT IS NEW: `BD%` (a hero's Break DEALT over the party's, off its own
  `pool_bd_hero_` pool and its own `_b_bd_slice`) and `BDprev/b` (Break refused or
  reduced), plus a `break_prevented_line` audit under the table naming which
  effect refused what.**
  **BREAK IS STILL NOT FOLDED INTO `d+h+p%` AND MUST NOT BE** — that needs an
  exchange rate between a Break point and a hit point (one? a tenth?) that nobody
  can defend, and inventing it buries a guess inside every measurement taken
  afterwards. The two slices are SEPARATE DICTS for this reason: `_b_slice` is
  summed wholesale into the d+h+p pool, so a Break key living in it would fold
  Break in through nothing more than a `for` loop.
  **BREAK PREVENTED NOW HAS ONE DOOR — `_prev_bd`, on BC's `_devout_prev` pattern
  (per-hero total and named term written by the SAME call, so parts can never
  disagree with the total). SIX REDUCERS BOOK THROUGH IT** via `unit.gd`'s
  `_credit_bd` and the `bd_` term prefix that routes them: **Devoutness, Bulwark
  of Fortitude, Hold the Line, Ward, Immovable, Bracing.** Before BF exactly ONE
  of the six was booked anywhere. `faith_break_cut` survives as the Devoutness
  term's alias so `faith_report_line` and BC's test read on.
  **TWO DELIBERATE EXCLUSIONS, PINNED IN test_batch_bf SO THEY CANNOT BE QUIETLY
  REVERSED: base Constitution** (a stat block is not a contribution — the same
  rule that keeps base armor and resists out of `prev_hero_`; BRACING *is* booked,
  because a stance a talent bought is exactly what the damage side counts) **and
  the run modifiers `mod_bd_mult`/`mod_no_break`** (nobody in the party did that).
  **TWO MORE ARE ADJACENT AND ARE NOT IN THE COLUMN: Rallying Shout removes 30-50
  BANKED Break from each hero, and Battered Not Broken shrugs 30/rank off a
  blocker's meter.** Those are Break *healing*, not Break refused — a different
  question from "how much never landed" — so they are not booked; if a later batch
  wants them it wants a new column, not this one. **Nothing else in the game
  writes `pressure` downward except `revive` and `recover_from_break`, which are
  structural.**
  **WHY IT MATTERED, AND IT REACHED WELL PAST THE DEVOUT: BC's grid read
  −Devoutness at 80% — a zero — and that zero was the instrument, not the node.**
  The Warden's whole THREAT lane is Break (AL measured his BD/battle 104 -> 320
  and the party's Breaks/battle 1.02 -> 2.35), the Occultist's Broken Will and
  Entropy exist to grind a boss's meter, and BD gave a single deadfall 270 Break
  points. **A BUILD THAT PAYS IN BREAK STILL READS LOW IN `d+h+p%` BY
  CONSTRUCTION — read it in `BD%` and `BDprev/b`, and never call such a build weak
  off the d+h+p column alone.**
  `DOD_SIM_ABILITIES="Resurrection,Divine Plea"` appends pending
  talent-gated abilities (Classes.pending_talent_ability; Holy only).
  `DOD_ENEMIES_OFF=1` arms the enemy-skip debug toggle headlessly.
  `DOD_DEBUG=1` adds map-burger debug items (gold/points/heal/
  jump-to-boss/next-zone; the talent grant is +200) in an EXPORTED build;
  `DOD_DEBUG=0` FORCES THE GATE SHUT in a dev build (Batch AC — the only
  way a headless test can stand where an exported build stands).
- GDScript gotchas that bit us: multiline lambdas in call args (use named
  methods), ternaries need parens for type inference, `:=` can't infer from
  untyped funcs, edits via python heredocs (apostrophes!) — use chr(39),
  min()/max() are numeric-only (String args = runtime error mid-_init and
  a headless --script run then idles forever — compare with < instead).

## Architecture (all UI built in code, no editor scenes)
- `scripts/run_state.gd` (autoload `Run`): party/items/gold/the LINE/zones,
  save (user://run_save.bin v7, auto-saved after every slot), relic slots
  (max 3), the offer table (MODIFIERS/REWARDS), merchant+event scheduling,
  and the ability-upgrade pool.
- `scripts/settings.gd` (autoload `Settings`): volume/fullscreen.
- `scripts/classes.gd`: hero configs, core kits, spec info/abilities, passives.
- `scripts/talents.gd`: 12 fixed trees, each 3 lanes x 7 exclusive ROWS + a
  capstone row (Batch AI). {id: ranks} learned dicts (ranks always 1 now).
  `apply_payload` shared with shop runes, and the ONE read site for a
  payload's `condition`. Owns `ability_names` (Run.owned_ability_names
  forwards to it — autoloads don't resolve inside a class_name script).
- `scripts/relics.gd`: permanent unlocks (user://relics.json), 1 per boss kill.
- `scripts/battle.gd`: the big one — initiative timeline, Pressure/Break,
  skill checks, statuses, AoE/random-hits, damage types + resists, items,
  sim/autoplay modes, victory/defeat flow.
- `scripts/unit.gd`: combatant node (sheet animations, bars, status chips,
  bleed buildup meter, outline shader hover).
- Screens: main_menu → draft (pick 4 + relics) → spec_choice (permanent) →
  map (THE hub: the road, four hero cards, potions, burger) → offer (before
  every elite/mini-boss) → battle → sometimes shop and/or event → back to map.
  party.tscn is the HERO SHEET now, opened from a card.

## Current systems snapshot (2026-08-09)

### STANDING RULES — TALENTS ARE META PROGRESSION (Batch BM)
**BUYING A CELL UNLOCKS AN OPTION. IT DOES NOT EQUIP IT.** This is the load-bearing rule of the
whole talent system and it is the one a later batch would most easily collapse. A CELL is a
(spec, node) pair bought ONCE, permanently, out of that spec's banked points on `Profile`.
EQUIPPING is a separate act and it is what a run reads: **you still pick ONE node per row, and
it locks for the run.** Owning all three cells in a row makes that row a real three-way
argument; owning one leaves no argument in it. **THAT IS WHY TWENTY BATCHES OF ROW PRICING
DESCRIBE THE ENDGAME RATHER THAN NEEDING A THIRD PASS** — a row is still priced against two
closed doors. Collapsing the two into one click turns every tree into a checklist and throws
AJ-through-BA away. `Talents.can_buy` and `Talents.can_equip` are separate questions on purpose;
test_batch_bm's negative control 1 builds the collapse and proves it is rejected.
· **EARNING** — 1 point per spec per ZONE BOSS defeated (3 a completed run; a zone-2 wipe still
  banks 1 or 2, and that partial credit is the mechanism, not a rule). Only specs that PLAYED
  earn. Points are PER SPEC and never transfer; banking is uncapped. **NOTHING IN A RUN AWARDS
  ONE** and the END BOSS awards none either — it awards a relic and opens rows.
· **SPENDING** — cells cost by TIER: rows 1-3 cost 1, rows 4-6 cost 2, rows 7-9 cost 3.
  **27 cells = 54 points a spec = 18 completions.** `Talents.tier_of_row` / `cell_cost` /
  `rows_unlocked` are the ONE place any of it is decided.
· **RESPEC** — free, any time OUTSIDE a run, NEVER during one. The build screen's `_locked()`
  is the gate and every mutator re-checks it.
· **ROW GATING IS GLOBAL** — rows 1-3 at difficulty 1, 4-6 at 2, 7-9 at 3, for EVERY SPEC AT
  ONCE. Points are per spec; rows are not. A tier arrives FULLY unlocked, which is what an
  uncapped bank is for. A fresh save has NO rows, NO points and no talents at all.
· **VERSIONS** — `Profile` is **v2** (tolerant load: a v1 profile arrives at tier 0 with zero
  points, the correct state). The run save is **v10** and **a pre-v10 save is REFUSED and
  cleared** (the final zone gained a 17th slot; a v9 map has no position after its boss).
· **DELETED, NOT ZEROED** (each pinned ABSENT in test_batch_bm): `Run.award_talent_points`,
  `Run.award_spec_point`, `member["talent_points"]`, `member["talent_flex"]`,
  `Talents.can_learn`, `Talents.purse_for`, `Talents.points_spent`, `MAX_PER_ROW`, the events
  verb `talent_points` and both relics' `start_talent_points` hook. **`Run.tally` never had a
  talent counter** — checked, not assumed; the brief expected one.
· **SUPERSEDED FIGURES, NAMED AS SUPERSEDED: BK's 10.9 / 10.8 / 6.0 talent points per hero per
  run, and every "nodes owned entering a boss" reading before BM.** They measured a per-run
  purse that does not exist. Never compare a post-BM number against them.
· **THE HANDOFF** is `Run.equip_spec_talents(idx)`, called from BOTH paths (the spec screen and
  RunSim.start_run — the sync_spec_hp pattern). A real run reads `Profile.equipped_talents`; a
  SIM reads `Run.sim_talents`, installed by `RunSim.install_builds`. **RunSim CALLS Profile
  nowhere at all** — a sim that read the player's ledger would make every baseline depend on
  whoever ran it.

### STANDING RULE — WHAT MAKES A ROW-8 NODE (Batch BM §2), AND BH'S FIFTEEN POINTS
**ROW 8 IS THE NODE THAT ONLY MATTERS ONCE THE REST OF THE LANE IS BOUGHT — a payoff that reads
the build itself rather than adding to it.** Every future node authored into row 8, and any node
authored anywhere, must do ONE of these: **READ an accumulated quantity** the lane has spent
rows building and pay off its DEPTH rather than its existence; **REMOVE a constraint** the lane
has been working around all game; or **CONVERT** the lane's currency into something it could not
previously buy. **IT MUST NOT BE A LARGER MAGNITUDE OF ANY NODE ABOVE IT.** A lane whose every
node multiplies the same term is one node with several prices (BC diagnosed it, BH proved it).
**THE TEST IS MECHANICAL AND IT SHIPS: test_batch_bm fails any row-8 payload that writes a stat
field an earlier node in the SAME LANE writes.** A shared field is the signature of a re-skin.
**AND BH'S FIFTEEN-POINT RULE IS A STANDING TEST FOR ANY NEW NODE:** under leave-one-out, no
single node should move its lane's headline by more than about fifteen points. Read it with BH's
three caveats (a lane that does little passes trivially; a compounding lane under-reports every
node in it; a FLAT grid on a lane that does something is a finding, not a null result).
**THE LANE THIS IS OWED ON AND WAS NOT RUN: Harmonic Convergence (Arcanist, Resonance row 8).**
It reads the build rate, and AT §3 measured that build rate beats per-stack value QUADRATICALLY
on a triangular curve. One `DOD_SIM_TALENTS` string with the id withheld is the whole harness.

### STANDING REFERENCE — THE DIFFICULTY LADDER AND THE END BOSS (Batch BM §5/§6)
**`Run.difficulty` WAS REUSED, NOT SHADOWED** — it was already a saved String var chosen at the
draft and armable from `DOD_SIM_DIFFICULTY`, already folded into ONE multiplier at
`zone_base_mult`. What changed is the TABLE it keys into (`Run.DIFFICULTIES`). Batch Y's ids
still resolve: **"standard" maps to rung 2**, the rung it was tuned at, so every old script and
Matrix row reads. **EVERY SCALING NUMBER IS PROVISIONAL** — balance is deferred by designer
decision and the STRUCTURE is what shipped.
· **rung 1 Wanderer x0.50 (BATCH BN §2 — WAS x0.70, AND THE NEW NUMBER IS THE ONLY THING ON
  THIS LADDER CHOSEN BY MEASUREMENT).** DELIBERATELY BELOW the present balance, because this is
  the rung played with ZERO talents and it is the gate the whole meta layer sits behind. BM
  reused Batch Y's 0.70 — a float picked for the Wanderer affordance, not for this job — and an
  untalented party completed **12-13%** at it, i.e. eight attempts before the first unlock with
  nothing banked in between. **SWEPT AT n=100 A ROW, untalented (`DOD_SIM_ROWS=0`), balanced:
  x0.70 13% | x0.60 28% | x0.50 83% | x0.40 95%.** 70% (a first run won in one or two attempts)
  is the target; 0.50 is the closest of the four. **THE CURVE IS A CLIFF between 0.60 and 0.50
  — 55 points across one step — so 70% sits in an unsampled gap and 0.50 is "the nearest
  sampled value", not a number to defend to three figures.**
· **rung 2 Warden x1.00** — the present balance BYTE FOR BYTE, so every BK row still describes
  it. Twist: **the severity floor rises** (`roll_offer` reads `difficulty_def().severity_floor`
  instead of a constant 2), so the guaranteed mild bargain option may be severity 3.
· **rung 3 Ruin x1.30** — floor rises again, plus **FIXED ENCOUNTERS CARRY A MODIFIER**
  (`Run.arm_fixed_modifier`, armed at BOTH walk sites): the mini-boss and every boss, the nodes
  a route cannot duck. It is NOT a bargain — no offer, no choice, NO REWARD.
**THE END BOSS is a 17th slot on the FINAL ZONE'S BOARD, so a run is 49 encounters** (BK settled
on 48). `END_BOSS_SLOT` / `END_BOSS_KIND` / `total_slots()`. It is **FIXED, not composed** (the
one node whose lineup does not come out of the budget system), so it can be learned, and it
**gains stats AND MECHANICS with difficulty** — `Enemies.config(kind, rung)` drops any ability
tagged `"rung": N` below that rung, and **the end boss is the only user**; every other kind reads
identically at every rung. It awards a relic ALWAYS, no ability pick, no talent points, and
**`Profile.note_end_boss(rung)` is what opens the meta tree's row tiers.** ZONE BOSSES — the
third included, which used to BE the end boss — now pay a point, a relic and an ability pick and
open what follows them.

### STANDING REFERENCE — ENEMY INTENT: ONE DECLARED-ACTION STORE, THREE RE-VALIDATION BRANCHES (Batch BL §1)
**DECLARE ON SCHEDULE, RESOLVE ON TURN.** `_choose_enemy_action` is the SELECTION half lifted
out of `_enemy_turn` **byte-for-byte** — §1 forbade an AI rewrite and that function is where the
promise is kept, so a diff touching the rules inside it broke the promise. Only *when* it runs
moved. Sites:
· **Declaration**: `_declare_intent(u)` (writes `BattleUnit.intent` + the plate).
  Called from **`_declare_all_intents()`** at battle start (in `_run_battle`, after the opening
  oath/Faith hooks — they move state the policy reads) and from **the turn loop right after
  `await _enemy_turn(u)`**, NOT from the bottom of `_enemy_turn`: that function has eight
  returns and a declaration owed on all of them is a declaration owed by the caller. Also on
  each lost-turn branch (stun/freeze/broken, after the discard) and in `_hold_release`.
· **Re-validation** at resolution, `_revalidate_intent(u)`, in this fixed order — (1) **target
  gone → re-target within the SAME ability** (`_istat("intent_retarget")`); (2) **ability
  unusable → fall back to `_cheapest_attack` AND LOG IT** (`intent_fallback`; a silent
  substitution is the intent system lying); (3) **cannot act → `_discard_intent`, DISCARDED NOT
  BANKED** (`intent_discarded` + `intent_discard_<cause>`; stunned/frozen/broken/held).
  **READ THE TARGET UNTYPED FIRST** — a declared beast can be `queue_free`d between declaration
  and resolution, and a typed assignment of a freed instance errors BEFORE `is_instance_valid`
  can run. Found in a live 50-run measurement; pinned in test_batch_bl.
· **A FOURTH counter, deliberately not one of the three**: `intent_hijacked` — Hysteria,
  Bewitch and Psychosis take the turn, so the unit ACTS but not as declared. Counted at the
  moment each branch COMMITS (Psychosis is a coin-flip; clearing on the status alone would
  throw away declarations on the half of turns the madness does not take).
· **THE `charging` STATUS IS THE SAME MECHANISM, NOT A SECOND ONE.** The wind-up stores its
  blow in `intent` like everything else; the status survives only as the chip and the cancel
  hook. **Nothing reads an ability name off the status any more** (asserted). `_declare_intent`
  returns early on `has_status("charging")` — that ONE line is why a charging enemy declares
  once, not twice. `_cancel_charge` routes through `_discard_intent`, so a cancelled wind-up
  counts as exactly one discard. **A later batch wanting a multi-turn declaration sets
  `intent.turns` and adds a chip. IT DOES NOT ADD A SECOND STORE.**
· **Counters go through `_istat`, NOT `_stat`** — unconditional, not sim-gated, because the
  re-validation rates are a property of the MECHANISM and must be observable in real play or
  "a stun really discards" is only checkable by trusting the code that does it. In sim they
  land in the same `sim_stats` dict, so there is still exactly one counter.
  `intent_report_line(stats)` is a static and prints in BOTH reports.
· **Categories are DATA-DRIVEN** (`_intent_category`): windup → mend → ally-target → aoe →
  `pressure > damage` → applies_status-and-not-this-unit's-hardest-hit → strike. Order IS the
  classification. An enemy added to enemies.json classifies itself; there is no name table.
**NO PREDICTED NUMBER SHIPPED, AND THIS IS THE FINDING RATHER THAN AN OMISSION.** §1 required
the number come from the same call the real hit makes, run dry, and named the escape hatch. The
strike block is `battle.gd` ~4990-5670 (~680 lines) and fails on two counts, either fatal
alone: (a) it mutates on the way through — `crit_streak`, resource restores, `float_text`, and
writes to THREE ledgers (`_prev`, `_devout_prev`, `_stat`); (b) its FIRST line is
`randf_range(0.9, 1.1)` and a crit rolls inside it, so **the same call with identical inputs
returns a different number**, and §4's "predicted equals dealt" could not hold even after a
perfect extraction. Icon + the ABILITY'S OWN NAME is shown instead — read off the declaration,
so it cannot drift. **The negative control changed shape to match**: test_batch_bl greps the
intent block for `attacker.attack` / `effective_armor` / `randf_range` / `resists.get` and
fails if a later batch adds a preview by reimplementing the maths.
**TWO THINGS §1 DELIBERATELY DID NOT BUILD — NOT BUILT, NOT MISSED:**
· **HIDDEN INTENT** (an enemy whose intent is concealed, making information a resource the
  player fights for). A good mechanic and a DIFFERENT one; author it once the baseline is
  legible. Flagged, not built.
**MEASURED AT BL (150 runs, 50 per policy, 50,799 declarations) — the baseline a later batch
compares against.** Re-targeted **3.2 / 3.5 / 5.9%** (greedy/balanced/cautious); **fell back to
basic 0.0% in all three** (the number §1 said to watch — the declaration is NOT happening too
early); discarded **16.1 / 15.1 / 11.2%**, and it is **almost all the Cryomancer's hold** (3014
/ 2598 / 1365) with Break the remainder (103 / 94 / 162) and **zero plain stun or freeze** —
in this party his freeze always becomes a hold. **ONE IN SIX DECLARED ENEMY ACTIONS NEVER
HAPPENS.** `intent_hijacked` reads **0.0% and that is a MEASUREMENT HOLE, NOT A RESULT**: the
standard test party carries no Occultist, so no madness status was ever applied — the counter
is asserted in the suite but has never run at scale. **Completions 52 / 46 / 20% against BK's
39.3 / 43.3 / 21.3.** All three inside their 95% bands, **but greedy is +12.7 pts and near the
edge of its own, so it is a signal rather than noise.** The bot cannot benefit from SEEING an
intent, so if it is real the mechanism must be the one behavioural shift below — an enemy that
declared before a Break window opened does not take it. **NOTHING WAS TUNED**; BK's baselines
are two batches old and correcting inside the batch that moves them is the Devout mistake.
· **AN AI REWRITE.** Selection logic is untouched. **What DID change is that state-sensitive
  policies now read the board ONE TURN EARLIER** — reported, corrected nowhere: the whole of
  `_enemy_support_action` (Healing Wave <40%, Regenerate <50%, Cleansing Rite, Shielding, Wild
  Growth <70%, Dark Vigil), the **Broken-hero exploit** (the most sensitive of all — a Break
  window is short and a declaration made before it opens will not take it), `_lowest_hp` /
  `_threat_pick`, the taunt narrowing, and the Savage Presence / Ghillie Suit rolls.

### STANDING REFERENCE — THE RECAP LEDGERS AND THEIR BOUND (Batch BL §2)
**DAMAGE TAKEN WAS TRACKED NOWHERE BEFORE BL** — `_stat` knew `dmg_hero_` / `heal_hero_` /
`prev_hero_` / `bd_hero_` / `st_hero_` and nothing taken. It now hangs off ONE door:
**`BattleUnit.damage_taken_cb`**, fired by `_report_taken` from the only two places health
leaves a unit (`take_hit`, `take_tick_damage`). It reports the **DELTA, not the argument** (a
52 into a hero on 40 is 40 taken, or the column would disagree with the health bar) and sits
**BELOW ALL FOUR DEATH-REFUSALS** — Hold the Line, Undying Rage, Ashes of Al'ar,
Intercession/Martyrdom. Above them it would count health handed straight back AND file a
refused death as a killing blow. A future damage source cannot forget to report: it cannot
remove health without one of those two functions.
· **ATTRIBUTION IS A FRAME**, `_dmg_frame(src, label, src_name)`, set at **`_resolve`'s entry**
  — one site covering the strike, its splash, echoes, the reflect/retaliation it draws and the
  recoil/Blood Price it costs — **re-established after each of the TEN nested `await _resolve`
  calls** (a counter leaves the frame pointing at itself) and set explicitly at the two damage
  sites outside `_resolve`: the **DoT tick loop** (from the status's `src_name`, which
  `_apply_status` already stamps — the applier may be dead). **THE THIRD SITE WAS THE
  OVERBURN/CAUTERISE DRAIN AND BATCH BS DELETED IT WITH THE DRAIN.** **SELF-INFLICTED IS DECIDED BY IDENTITY** (`victim == _dmg_src`), which covers Blood
  Price, Dark Pact and recoil in one rule and cannot go stale
  the way a name list would.
· **BY KIND, NEVER BY INSTANCE** — `_taken_source` reads the new `BattleUnit.enemy_kind`
  (stamped in `_enemy_config` AFTER the "boss" alias resolves, so a boss books as what it is).
  `unit_name` happens to agree today; keying on that agreement would make the aggregation an
  accident the first uniquely-named enemy breaks. Negative control renames two same-kind
  instances and asserts one row.
· **New tally keys** (`Run.tally`): `dealt` hero→ability→amount, `taken`
  hero→"`<kind> / <ability>`"→amount, `taken_total` hero→amount (**exact, never folded**),
  `kills` (list), `final` (a whole copy of the other four, **overwritten every battle — so at
  run end it IS the final battle** and nothing has to know which fight that was).
  Writers `tally_dealt` / `tally_taken` / `tally_kill` / `tally_bank_final`, all through the
  ONE bounded writer `_tally_book`.
· **THE BOUND: `TALLY_KEYS_PER_HERO = 24` rows per hero per map, INCLUDING the `(other)` row**
  (so "at most 24", not "24 plus one"); `TALLY_KILLS_MAX = 12`, oldest kept. Overflow FOLDS
  into `(other)` rather than being dropped — the total stays exact and only the breakdown gets
  coarser, which is the right way round when the panel reports a top 5.
· **Banked by `_bank_run_ledgers()`**, called from `_check_end`'s run branch AND from
  `_do_forfeit` (a forfeit never reaches `_check_end`, and the abandoned fight is exactly what
  the tester wants explained). **Idempotent** — it clears the slices as it banks.
· **SAVE VERSION 8 → 9, TOLERANT** (unlike BK's v8 refusal): these are counters, not structure,
  so a v8 save loads and seeds the new keys at zero mid-run. A recap that starts counting
  halfway beats a wiped run.
· **BL DROPPED A `sim and` GUARD IN THE DoT TICK LOOP and it was a real hole, not a tidy-up**:
  in REAL PLAY a Pyromancer's Burn and a Survivalist's Poison reached neither the run summary's
  damage share nor anything else. **Sim totals are untouched** — that path already counted the
  ticks — so **no baseline moves**.
· Renderer `_append_breakdown(...)` is written ONCE and called TWICE (whole run, final battle);
  everything goes into the SAME line list `_summary_plain_text` walks, so the Copy button stays
  complete. **Not a defeat-only screen** — wipes, forfeits and completions all get it.

### STANDING RULE — FIFTEEN POINTS UNDER LEAVE-ONE-OUT IS WHAT MAKES A LANE A LANE (Batch BH §2)
**If withholding any single node moves a lane's headline contribution by more than about fifteen
points, that lane is not a set of choices — it is ONE choice with several prices, and no amount
of re-pricing will make it behave.** BC's grid had Communion at THIRTY-THREE on the Devout's
Faith lane, and four consecutive batches then tuned magnitudes on a lane whose fault was its
shape. This is a test you can run on a tree before anybody plays it, and it is cheap:
`DOD_SIM_TALENTS` with one id withheld is the whole harness.
**TWO CAVEATS THAT MUST TRAVEL WITH IT, both learned by running it (BH §2):**
· **A LANE THAT DOES LITTLE PASSES TRIVIALLY.** No node can move a headline by fifteen points
when the whole lane is worth three above ungeared. Read the grid against the lane's own
distance from the ungeared floor, never as an absolute.
· **THE GRID UNDER-REPORTS EVERY NODE IN A COMPOUNDING LANE.** Where several nodes multiply the
same term, withholding one leaves the others multiplying, so each reads small and the total is
large. BC measured Binding Oath at one point on exactly this lane. **A small leave-one-out
number is evidence of a node's marginal worth, NOT of its structural role.**
· **A THIRD CAVEAT, ADDED BY BATCH BI §1, AND IT IS THE ONE THAT NEARLY GOT MISSED: A FLAT GRID
ON A LANE THAT DOES SOMETHING IS A FINDING, NOT A NULL RESULT.** BH's grid moved by at most one
point in any cell and read as "the lane is fine, just small". It was the signature of the
antagonism in the standing rule directly below — every node's contribution was being eaten by
its neighbour's — and no amount of re-pricing would have found it.

### STANDING RULE — HELD VALUE AND SPEND FREQUENCY ARE ANTAGONISTIC ON A SINGLE METER (Batch BI §1)
**A resource that both (a) pays something while HELD and (b) is CONSUMED at a threshold has two
effects reading one number and wanting opposite things from it: the spend wants it empty, the
held value wants it full.** Whatever you do to one, you pay for on the other. **DO NOT ADD A
"SECOND AXIS" TO SUCH A LANE BY GIVING A NODE THE HELD HALF: that is not a second axis, it is a
second price on the first one.**
**THIS IS THE SAME FAULT BC DIAGNOSED, ARRIVED AT FROM THE OPPOSITE SIDE.** BC found nodes all
pushing one number the SAME way and called it one node with eight prices; this is nodes pushing
one number AGAINST each other. **DIRECTION IS NOT THE TEST. SHARING THE NUMBER IS THE TEST** —
two effects that read the same term are one effect with two prices, whichever way they push it.
**THE TEST, BEFORE ADDING ANY SECOND AXIS: ask what the new axis READS.** If it reads state the
first axis mutates, it will compound or cancel and which one is only a matter of sign.
**THE REPAIR SHAPE, FOR WHEN THIS RECURS: give the second effect its own DERIVED quantity rather
than the meter.** BI's `faith_peak` is the Devout's — a high-water mark that rises with the count
and does not fall when a spend empties it, so frequency and depth can both be real. **DO NOT
RE-COUPLE THEM.** Faith's held half must never read `faith_stacks` again; that is
test_batch_bi's first negative control, and the mis-write reads as a smaller number rather than
as a bug.

### STANDING DESIGN RULE — THE CONTAGION SPACE IS RESERVED (Batch BA §1)
**A future spec is planned whose fantasy is DISEASE AND VIRALITY. Nothing self-propagating
may be authored into the Survivalist's tree, or into any existing spec, until that spec is
built.** Off-limits: transmission between enemies, transmission from a corpse, field-wide
infection — anything that spreads WITHOUT the hero acting. **POISON ITSELF IS NOT RESERVED
AND STAYS ENTIRELY THE SURVIVALIST'S**: poison is craft — curare, hemlock, a blade wiped on
the right leaf. The distinction to hold is *a hunter who knows which plant does what* versus
*a plague that no longer needs him.* This is recorded as a RULE rather than as four edits on
purpose: without it a later batch re-adds "spreads to another enemy" innocently and spends
the new spec's idea a second time. **BA re-specced four nodes off it** — Epidemic (capstone,
every enemy permanently Poisoned), Plague Bearer (rot leaps enemy to enemy), Creeping Death
(a corpse passes its stacks to the living) and the NAME Virulence (a pathogen term). SNARES
and GUERILLA were never disease and are untouched by the rule.

### STANDING REFERENCE — THE DEBUG SURFACES, ALL OF THEM IN ONE TABLE (Batch BJ §1)
Half of these were documented only in changelog entries; this is the record. Not for deletion.
**Gate for every UI surface: `Run.debug_enabled()`** = dev build OR `DOD_DEBUG=1` (exported),
and `DOD_DEBUG=0` FORCES it shut; every use trips `Run.debug_used` → the run summary's "not a
clean data point" line. Sims can never reach the UI surfaces (`_debug_allowed()` excludes
sim/autoplay/sim_run).
· MAP BURGER debug items (map_screen, ids 10-16/20-26): +200 Gold | +200 Talent Points (all) |
  Full Heal Party | Jump to Boss Slot | Advance to Next Zone | Reroll Specs | "All Spec
  Abilities Unlocked" check = `Run.debug_grant_all`, the PRE-GRANT toggle (spec-scoped, AU §5;
  also armable headlessly via `DOD_SIM_GRANT_ALL=1`) | Free Travel check =
  `Run.debug_free_travel` | Test-a-Node submenu: Shop / ??? Event / Fight / Elite / Mini-boss
  (in place, `Run.debug_summon` books nothing).
· BATTLE `DEBUG ▾` menu (battle.gd, dev builds, not sim/autoplay): Full Restore | Kill All
  Enemies (a switch, not a hit — on-death procs reading a killing blow do not fire) |
  Cooldowns OFF (check) | Enemy attacks OFF (check; armable headlessly via
  `DOD_ENEMIES_OFF=1`) | per-hero Turn Lock (radio).
· ENV FLAGS, sim family (defaults in parens): `DOD_SIM` (battle count, standalone),
  `DOD_SIM_SWEEP` (budgets 3/6/9/12), `DOD_SIM_RUN` (full runs), `DOD_SIM_SPECS` (party,
  warrior/mage/cleric/hunter order), `DOD_SIM_ENEMIES` (forced lineup), `DOD_SIM_ZONE` (roster)
  / `DOD_SIM_THEME` (one theme) / `DOD_SIM_BUDGET` (def 6, standalone), `DOD_SIM_TALENTS`
  (force-learn ids), `DOD_SIM_ABILITIES` (append pending/pool abilities by name),
  `DOD_SIM_GRANT_ALL`, `DOD_SIM_ROTATE` (all twelve specs), `DOD_SIM_ROUTE`
  (greedy|default|cautious|elites — one walk since AN), `DOD_SIM_SHOPS`/`DOD_SIM_ITEMS`
  (economy policies, def on), `DOD_SIM_BUILDS` (def each tree's FIRST lane — the BG confound),
  `DOD_SIM_TROPHIES`, `DOD_SIM_RELICS`, `DOD_SIM_RUNES` (full|stats|off, def full),
  `DOD_SIM_RUNE_ECON=rich` / `DOD_SIM_RUNE_POWER=<mult>` (AD experiment arms, double-gated on
  Run.sim_run), `DOD_SIM_DIFFICULTY` (wanderer|warden|ruin = rungs 1-3 at x0.50 / x1.00 /
  x1.30, "standard" aliases warden; **DEFAULTS TO RUNG 1** — set warden for a baseline row),
  `DOD_SIM_DEBUG` (echo the combat log in sim mode — the hang discriminator).
· ENV FLAGS, non-sim: `DOD_AUTOPLAY` (1 debug battle, echoes "[LOG]"; never exits on its own —
  timeout/kill it), `DOD_DEBUG` (above), `DOD_ENEMIES_OFF` (above), `DOD_ZONE_ROTATION`
  (randomize zone draws within slot pools).
· RETIRED, still printed as retired in the report header: `DOD_SIM_MAP`, `DOD_SIM_MINIBOSS`,
  `DOD_SIM_START_RUNE`, `DOD_SIM_SPEC_OPENING` (Batch AN, with their features).

### STANDING REFERENCE — THE UNCAPPED-METER GOVERNOR TABLE (Batch BJ §3b)
Six ratcheting accumulators exist; every governor was VERIFIED AT ITS SITE this batch. No
meter is ungoverned. meter | what governs it | where the governor lives:
· **Overburn's field total** (burn turns, uncapped) | **REWRITTEN AT BATCH BS, NOT AMENDED —
  ITS OLD ENTRY ASSERTED THE ASYMMETRY AS THE GOVERNOR AND THAT CLAIM IS NOW FALSE.** BJ read:
  "the BONUS caps at +40 while the DRAIN never caps — the asymmetry IS the governor,
  over-lighting is how he loses". **THERE IS NO DRAIN.** The governor is now a **PLAIN FLAT
  CAP** and nothing lifts it: +2% a burn-turn to +40%, full stop. `_overburn_capped`,
  `_overburn_drain` and `_overburn_tick` are DELETED, so a meter that keeps climbing simply
  stops paying past 20 burn-turns and costs nothing to hold. **THIS IS THE ONE GOVERNOR IN THE
  TABLE THAT IS A CEILING RATHER THAN A COST**, and that is deliberate — the cost was the fault
  BS removed | `_overburn_mult` (the ONE place the cap is decided), OVERBURN_STEP/CAP consts.
· **Loyalty** (per beast, no ceiling) | the beast's DEATH breaks the meter (Steadfast Bond
  keeps a share); plus BOND_MITIGATION_MAX 0.75 clamps Savage Presence so an uncapped boon can
  never heal the hunter off enemy hits | `_on_beast_death` battle.gd ~10790; the clamp const
  beside BOND_STEP ~7370-7385; `_loyalty_cap` returns the LOYALTY_UNCAPPED sentinel (only Wild
  Rotation hands it a number — the cap IS that node's cost).
· **Focus** (uncapped; Spray caps 50) | the FIXED-100 CONVERSION: the first 100 points buy
  crit CHANCE (saturates at +50%), everything past buys MULTIPLIER only; Deep Focus moves the
  split point down, floor 1 | FOCUS_CONVERT/FOCUS_STEP + focus_convert()/focus_crit_chance()/
  focus_crit_mult()/lethal_crit_mult(), unit.gd ~605-645 (THE ONE PLACE THE SPLIT IS DECIDED).
· **Resonance** (uncapped both ends, nothing removes stacks) | the uncapped DAMAGE-TAKEN cost:
  RESONANCE_TAKEN_STEP 0.75%/curve-point on the same triangular curve T(N)=N(N+1)/2, and
  NOTHING may modify that step (deliberate — Conduit and Magi's Wrath name the damage curve
  only) | unit.gd ~543-582 (THE ONE PLACE THE CURVE IS DECIDED), read at battle.gd's
  strike-target block.
· **Ruin** (uncapped, never clears, detonates every 10th stack — Avatar installs 5) | the
  LIFESTEAL caps at RUIN_LEECH_CAP = 0.40 of the damage dealt, whatever the stacks and
  whatever the talents (Soul Glut included); the amplification is ALLOWED to run |
  battle.gd ~7846 (const), applied at the strike-loop leech block ~5680.
· **faith_peak** (never falls in battle) | the BATTLE RESET: `_reset_faith_meters()` zeroes
  count and peak together at battle start, before the opening oath; one ratchet site in
  `_gain_faith` | battle.gd ~8125-8171.

### STANDING REFERENCE — THE ABILITY DRAFT, THE SEVEN-SLOT CAP AND THE TWELVE PROTECTED CORES (Batch BO)
**A SECOND ABILITY SOURCE BESIDE THE BOSS PICK, AND IT IS A SEPARATE POOL ON PURPOSE.**
`Classes.SPEC_DRAFT_POOLS` / `CLASS_DRAFT_POOLS` are what elites, merchants and events offer;
`SPEC_POOLS` is still what a ZONE BOSS offers and it is byte-untouched. Sharing one pool would
have re-weighted every boss offer in the game the moment eighteen entries landed, which is what
"the existing pick, unchanged" forbids. **A drafted ability lands in `member["bm_abilities"]`,
the SAME list a boss pick writes**, so the battle spawn, the hero sheet, `Talents.ability_names`,
the rune eligibility filter and the upgrade pairing all pick it up with no new plumbing —
**NO SAVE VERSION MOVES (still v10)**; the new member keys (`draft_candidates`,
`draft_picks_owed`, `draft_refused`) ride the party dict, which is saved wholesale.
· **THE CAP IS 7 (`Run.ABILITY_SLOT_CAP`) AND IT BINDS EVERY SOURCE**, the boss pick included.
  §3 leaves the boss OFFER unchanged, but a cap that one pool can walk past is not a cap: a
  Beastmaster's five spec-pool entries alone reach eight. `Run.ability_slots_used` =
  `Classes.core_slots(spec)` + earned.size().
· **PROTECTED = THE OPENING KIT. EARNED = DROPPABLE.** `Run.drop_earned_ability` is THE ONE
  PLACE a drop is written and it refuses anything not in `bm_abilities` — so "a protected
  ability can never be dropped" is not a branch that could be got wrong, it is the absence of
  the name from the list. Both pick paths call it.
· **DECLINING REFUSES THE WHOLE OFFER; TAKING ONE REFUSES NOTHING.** `draft_refused` is the
  no-return ledger, per hero per run. A DROP writes it too.
· **THE OFFER FILLS SHORT rather than padding with repeats** (AP §3's rule, unchanged), and
  `Run.draft_card_is_class` is the one-in-four seam — **its own function precisely so a test
  can drive it 4000 times while both class pools are still empty.** A check on the roller could
  only ever measure zero today, and a check that can only pass is a gap (BK's zero-blacksmith
  lesson).
· **THE UI IS THE EXISTING OVERLAY, NOT A SECOND ONE.** `map_screen._open_pick_overlay` gained
  a "draft" kind and a `pending` argument; the drop step is the same overlay redrawn.
**THE TWELVE PROTECTED CORES — `Classes.PROTECTED_CORES`, AND THE `enablers` COLUMN IS THE
THING A LATER BATCH WOULD MOST EASILY BREAK.** It is AUTHORED rather than derived, and
test_batch_bo asserts every named enabler is in that spec's opening kit and in NO pool. The
failure it prevents is SILENT: a spine that stops working because its enabler became draftable.
`slots` | spec | what the passive cannot function without:
· 3 **Berserker** — nothing (Blood Frenzy reads his own health bar).
· 3 **Warden** — nothing (Heavy Plating is a Block rule, it reads no ability).
· 3 **Swordmaster** — **Guard Change**. AK called it "the only stance swap in the game" and
  **BATCH BP MADE THAT FALSE** (Precision Strike and Feint both switch). It is still the
  enabler for a sharper reason: it is his only UNCONDITIONAL swap — the other two are
  drafted, cost Rage and carry cooldowns.
· 3 **Pyromancer** — **Fireball, Detonation** (Overburn needs an applier AND a spender).
· 3 **Cryomancer** — **Frostbolt, Ice Lance** (a Chilled applier, and a release).
· 3 **Arcanist** — **Arcane Explosion** (the free cast that guarantees a build every turn).
· 4 **Holy** — **Heal, Hymn of Hope** (Mercy must be spendable; Empower needs a heal).
· 3 **Devout** — **Divine Shield, Consecrated Ground** (the only Faith trigger, and the drip BI
  measured at 66% of all Faith).
· 3 **Occultist** — **Shadowrend, Hex of Ruin** (the debuffs the passive marks off).
· 3 **Beastmaster** — **all three summons**. **FIVE ABILITIES IN THREE SLOTS** — the summon
  picker has been ONE bar entry since AH, and counting three would take a spec to two draftable
  picks for a bookkeeping reason.
· 3 **Sharpshooter** — **Quick Shot** (Lethal Aim counts consecutive single-target attacks).
· 3 **Survivalist** — nothing (Trapper's breadth term counts statuses from ANY source).
**THE WARRIOR POOLS WERE OWED AND ARE PAID (Batch BP) — do not re-record them as empty.** All
three were NAMED and EMPTY at BO because the lane names only arrived in BM; BP filled them with
two apiece (Berserker Blood Offering / Gut Rip, Warden Covering Guard / Eye of the Storm,
Swordmaster Precision Strike / Feint), so **`SPEC_DRAFT_POOLS` is 24 entries and every spec has a
draft.** **THE CLASS-WIDE TRANCHE IS PAID IN FULL (Batch BQ then BR) — DO NOT RE-RECORD ANY OF IT
AS OWED.** BQ shipped six MAGE and six CLERIC; **BR shipped six HUNTER and six WARRIOR**, so
`CLASS_DRAFT_POOLS` is 24 of a target 24 and **THE ONE-IN-FOUR CLASS SEAM DRAWS A REAL ENTRY FOR
EVERY HERO IN THE GAME** — no class rolls an empty pool and no offer loses its class card. The
draft holds **48 of a target ~96**. **WHAT IS STILL OWED IS TRANCHES 2 AND 3 OF THE SPEC POOLS**:
those are two deep apiece, so a hero worn down by the no-return ledger still fills SHORT. That is
the visible shape of the REMAINING debt, not a bug — test_batch_br asserts the two-deep spec pools
AND drives the fill-short rule on a worn-down pool, so it stays visible in code rather than only
in prose.
**CLASS-WIDE AUTHORING RULES, recorded with the arrays so they travel with the content:**
deliberately UNTIED AND GENERAL (Magic Barrier, not Frostbolt — the test is whether it would
read as off-theme for ANY spec of that class), and **WEAKER THAN SPEC ABILITIES AND
UNCONDITIONAL** — they feed no passive, so at equal power they would be a safe default that
dilutes every build. **BQ ADDS A THIRD RULE, LEARNED BY BREAKING IT: verify the "weaker" half
against the LIVE spec kits rather than trusting the brief, AND CHECK IT AGAINST THE FREE CORE
ATTACK TOO** — Chastise is dominated by Smite, and no comparison against spec ABILITIES alone
would ever have caught it.

### STANDING DESIGN RULE — THE ARRIVING-STANCE PRINCIPLE (Batch BP §3)
**EVERY STANCE ABILITY MUST BUY WHAT THE STANCE IT LEAVES HIM IN WANTS.** The Swordmaster's
stances were a binary toggle with passive numbers on each side and NOTHING in his kit ever
behaved differently depending on which one he was in; BP's two draft cards (Precision Strike,
Feint) both READ the stance and then SWITCH it, and both are authored against this rule. Cast
from Aggressive he lands in Defensive, so the ability hands him **defence**; cast from Defensive
he lands in Aggressive, so it hands him **offence**. **He is never stranded — he always arrives
holding something, and that is what makes the switch a feature rather than a tax.**
**IT IS RECORDED AS A RULE BECAUSE IT IS THE THING A LATER STANCE ABILITY WOULD MOST EASILY GET
BACKWARDS** — the intuitive authoring ("the Aggressive branch is the offensive one") produces
exactly the inverted card, and it would still read fine on the tooltip.
· **THE PIVOT IS ONE IMPLEMENTATION, THREE CALLERS — `_swordmaster_switch(u)`** (Guard Change,
  Precision Strike, Feint). Batch AK's Guard Change could afford to own the pivot inline while it
  was the only swap in the game; three copies of "flip it, restamp the chip, pay Tempo" drift.
· **TEMPO IS PART OF THE PIVOT AND NOT PART OF GUARD CHANGE**, and that is a decision: the node's
  text reads "Switching stance grants +30% damage for 1 turn" and NAMES NO ABILITY, so a swap
  that skipped it would make a shipped tooltip false. Everything Guard Change pays BEYOND the
  pivot — its Break damage, Sunder Guard, No Quarter, the parry perfect — stays on Guard Change.
· **stance-GATED ABILITIES — ones that REQUIRE a stance to cast rather than branching on it —
  ARE A NOTED FUTURE DIRECTION AND WERE DELIBERATELY NOT BUILT.** They are a different mechanic
  (they constrain when you may act rather than what the act buys) and they want their own pass.
· **"GUARD CHANGE IS THE ONLY STANCE SWAP IN THE GAME" IS NO LONGER TRUE** and `PROTECTED_CORES`
  says so. It is still the Swordmaster's enabler for a sharper reason: it is the only
  UNCONDITIONAL swap — the other two are DRAFTED (he may never be offered either), cost Rage, and
  sit on 3- and 4-turn cooldowns.

### STANDING RULE — CHARGES AND ON-HIT EFFECTS COUNT HITS, NOT CASTS (Batch BR §1)
**A multi-hit ability spends one charge PER HIT and fires its on-hit effects PER HIT.** Aimed
Volley is three shots; under Arcane Arrows it spends **three** of five charges and forks **three**
times. Magic Missiles and Called Volley behave the same way. **This is a real power increase for
multi-hit abilities and it is deliberate — it is what makes a multi-hit kit and a charge bank a
BUILD rather than a coincidence.** A strike that MISSED or was BLOCKED spends nothing, and neither
does one an absolute parry zeroed: a charge rides a blow that landed.
· **WHERE IT LIVES**: `_arcane_arrow_splash` is called from INSIDE `_resolve`'s `for hit_i in
  total_hits` loop, after the strike resolves, and ONE function both spends the charge and deals
  the blow. It reads `final` — the damage THIS hit actually dealt — rather than re-deriving from
  the ability's nominal damage, which would drift the moment a crit, a resist or an armor read
  differed.
· **APPLIED RETROACTIVELY, AND WHAT CHANGED IS ONE THING: MIRROR IMAGE** (BQ) now spends one image
  per hit of a multi-hit attack. The gate is `multi_hits` ALONE, which keeps the card's promise
  true — a multi-hit ability is repeated strikes on ONE target, i.e. single-target, while an area
  attack, a random scatter and a chosen pair are not and still spend nothing. **IT CHANGES NOTHING
  IN PLAY TODAY**: no enemy in enemies.json carries `multi_hits` or `random_hits` (asserted, not
  assumed) and heroes do not attack the Mage. It is the rule made TRUE ahead of its use.
· **THE OTHER THREE CHARGE BANKS ALREADY COUNTED HITS** — Interpose's `shield_charges` (the block
  branch), Waiting Guard's `banked_guards` and Feint's `feint_guards` (both on the parry roll).
  All three sit inside the strike loop. Verified at their sites; no change.
· **ONE PLACE THE RULE WAS DELIBERATELY NOT APPLIED, AND IT IS A FINDING RATHER THAN AN OMISSION:
  SPRAY OF ARROWS**, gated `ab.multi_hits == 0 and ab.random_hits == 0` by Batch AZ's own design
  (`spray` is how many extra ENEMIES a single shot finds; a multi-hit already finds its target
  three times). Firing it per hit would TRIPLE a shipped talent's magnitude — a balance change the
  standing testing scope forbids measuring. The same shape applies to the Survivalist's post-loop
  on-hit package (Coated Blades, Venom Coating): moving it inside the loop would triple its output
  AND change whether a missed or blocked strike still applies it, a second unasked change riding
  along. Both are pinned in test_batch_br so a later batch reads the reasoning first.

### STANDING RULE — SWEEP A NAME AGAINST THE WHOLE ROSTER BEFORE AUTHORING IT (Batch BR §1)
**Every ability, talent node, status and rune.** An ABILITY-vs-ABILITY duplicate is a real break —
`Classes.pool_ability` is keyed on `display_name`, so two abilities sharing one make the resolver
answer the wrong question — and must be RENAMED. Everything else is a LABEL collision: a node's
name is not an ability name, nothing resolves it, so it SHIPS AS SPECIFIED AND IS FLAGGED (the BO
Second Wind / BP Precision Strike / AV Shared Vigil precedent; renaming either is the designer's
call and one string).
· **RENAMED HERE: the Warrior recovery card was authored as SECOND WIND**, which Holy already holds
  as an ability (tranche 1, BO). It is **BATTLE TRANCE**.
· **REPORTED, NOT RESOLVED — RALLY** is also a Warden talent node (Banner row 2) and a live `rally`
  status label. The ability needs no status of its own, so nothing can overwrite anything.
· **REPORTED, NOT RESOLVED — IRON WILL is the worst collision the project has had.** It is a Warden
  talent node (Threat row 3) AND a live status with that exact label, and it is a WARRIOR class
  card — so **same class, same spec reachable**: a Warden holding the node can draft the card.
  Worse than BP's Precision Strike (same spec, but a node against a SPEC card). Nothing breaks, and
  **the ability's status is `ironclad` with its own chip** precisely so a Warden holding both never
  sees two chips reading the same word.

BATCH BS (08-14) — OVERBURN LOSES THE DRAIN, AND INFERNO BECOMES A LANE. **THE DIAGNOSIS IS
WORTH MORE THAN THE FIX AND IT IS THE REUSABLE HALF: AN ENTIRE COLUMN EXISTED TO MITIGATE AN
UNFAIR PASSIVE.** Seven of the eight Inferno nodes read Overburn's Mana drain — Fire Walker
reduced it, Invigorating Ashes offset it, Immolate doubled it, Kiln-Forged floored it, Ash Lung
paid him for outrunning it, Cauterise billed it to health, Forge Body threw the paid bill at an
enemy. The eighth, Heat Shimmer, read the drain's counterpart (the bonus cap), so it was the same
term from the other side rather than an exception. **A lane whose every node acts on one term is
one node with eight prices** (BC diagnosed the shape, BH proved it) **and it is worse when the
term is a punishment: the lane is not a build, it is a payment plan.** The drain is DELETED and
the lane re-authored. **No magnitude anywhere else in the game moves; no save version moves
(still v10); all eight node ids survive at their own rows.**
**§2 — OVERBURN IS TWO CLAUSES.** BONUS: +2% damage per remaining Burn turn on the enemy team,
capped at +40%, unchanged. REFUND: 1 Mana per turn of Burn CONSUMED, unchanged, and it keeps its
property-of-the-passive status. **DRAIN: DELETED, NOT ZEROED** — `_overburn_drain`,
`_overburn_tick`, `_overburn_capped` and the `_player_turn` call are gone from the source, and
test_batch_bs asserts their NON-EXISTENCE rather than that they return zero. **There is no
constant left for a later batch to flip.** `_drain_burn_turns` went with them and
`_total_burn_turns` is the single denominator again; `BattleUnit.ember_debt` went with the
exemption it served.
· **THE SPINE SURVIVES THE REMOVAL AND THIS MUST NOT BE FORGOTTEN: his damage is still
  DEFERRED.** Burn ticks are small, Detonation pays 250% of the bank, and turns spent lighting
  are turns not killing — **he is weak until he cashes in.** That was always the interesting
  half; the drain was a punishment bolted onto it. **AR's "the reward caps and the cost does not"
  ASYMMETRY IS DEAD. DO NOT RESTATE IT AND DO NOT REBUILD A COST TO JUSTIFY IT** — both the AR
  block and BJ's governor-table row were REWRITTEN rather than amended, because a half-edited
  block is worse than either version.
· **THE CAP-RAISE WAS DROPPED RATHER THAN REHOMED, AND IT IS SAID PLAINLY.** Nothing lifts
  Overburn's +40% any more. Heat Shimmer, Immolate and Cauterise-under-20-Mana were its only
  three lifters and all three were Inferno clauses this batch re-authored; raising the payoff's
  ceiling is **Detonation's** subject, and every Detonation node is already authored, so
  rehoming it meant re-speccing a node outside this batch's scope. Deleting `_overburn_capped`
  is what forces a later batch to author one deliberately.
· **THE 6% GLOBAL BURN TICK IS STILL NOT TOUCHED** — AR's reason (shared with enemies, runes and
  every other burn source) did not expire with the drain.
**§3 — INFERNO: THE FIRE THAT SHIELDS YOU.** The thesis is the one thing the Pyromancer most
lacks and his theme most obviously supports: **armoured in his own element** — 135 HP, 85
Constitution, and until now nothing at all. Rows 1-8: **Ember Shroud** (any enemy burning → -8%
damage taken, flat, on from turn one) · **Ashen Skin** (+25% fire resistance, and Burn ticks HE
applied heal 10% of the tick) · **Heat Haze** (a BURNING attacker has a 20% chance to miss him) ·
**Immolate** *re-specced* (3 turns: -20% damage taken and attackers ignite; Perfect a 4th) ·
**Backblast** (once per battle, first drop below 40% health: every enemy Burns 4 turns, he heals
15% of maximum) · **Kiln-Forged** (no single hit reduces him below 1 while THREE OR MORE enemies
burn) · **Ash Lung** (per burning enemy, -4% taken and +4% dealt, UNCAPPED) · **Forge Body**
(-1% damage taken per remaining Burn TURN on the field, capped 50%, and the prevented damage is
thrown at a random burning enemy as fire).
· **THE SHAPE, PER BM'S RULE: rows 1-7 are SEVEN DIFFERENT KINDS of protection** — flat
  mitigation, resistance and sustain, evasion, retaliation, an emergency, a death-refusal, and a
  scaling that pays both ways. **Row 8 READS the accumulated quantity the lane built and CONVERTS
  it into offence**, the row-8 shape BM specified. **No node is a larger magnitude of another**,
  which is what the old lane failed. test_batch_bs asserts the lane writes 8+ DISTINCT stat
  fields and that NONE of them is one of the seven deleted ones.
· **FORGE BODY READS BURN TURNS, NOT BURNING ENEMIES, AND THE DIFFERENCE IS THE NODE.** Four
  enemies at four turns each is 16, and Firestorm alone puts 12-16 on the field in one cast. **The
  50% cap needs about FIFTY burn-turns and will rarely be reached.** THE DESIGNER WEIGHED THE
  STACK AND IT SHIPS AS WRITTEN: at a realistic 20 burn-turns across four enemies, Ember Shroud,
  Ash Lung and Forge Body multiply to **roughly 38% reduction on a 135 HP hero.** Recorded so the
  arithmetic is on the page rather than in a conversation. The suite measures it where the two
  quantities DIFFER BY CONSTRUCTION (two enemies at six turns: 2 bodies against 12 turns), which
  a body-reading implementation fails.
· **SEVEN FIELDS DELETED WITH THEIR READ SITES, not re-pointed in place** (the BH `fervor_step` /
  BA `plague_bearer` precedent — every one changed what it MEANS, the harder failure):
  `fire_walker`, `invigorating_ranks`, `heat_haze_ranks`, `kiln_forged`, `ash_lung`, `cauterise`,
  `forge_body`. Eight replace them: `ember_shroud`, `ashen_skin` + `ashen_skin_heal` (AW's rule —
  one counter cannot hold a resistance AND a share of a tick), `heat_haze`, `backblast` +
  `backblast_used`, `kiln_forged_at`, `ash_lung_pct`, `forge_body_pct`. All eight joined
  `Runes.STAT_INT_KEYS` for the durability AW/AX listed their unwritten ones with.
· **ONE NEW CALLBACK, `burning_foes_cb`**, stamped at `_make_unit` (the one place every unit
  passes through, `blight_cb`'s reason). Kiln-Forged asks the BOARD a question and unit.gd cannot
  see it. **A METHOD REFERENCE, NOT A LAMBDA** — a nested lambda in a call argument is this
  project's oldest parse trap — and the count is read at the instant the killing blow lands
  rather than sampled at the top of a turn.
· **KILN-FORGED SITS ON EVENT HORIZON'S SHAPE, ABOVE THE SUBTRACTION, NOT WITH THE FOUR DEATH
  REFUSALS BELOW IT.** The promise is that no SINGLE HIT reduces him below 1, so nothing
  downstream may ever see a lethal number. **A BURN TICK IS NOT A HIT** and `take_tick_damage`
  deliberately carries no copy of it; the suite asserts the absence.
· **BACKBLAST RIDES BL's ONE DOOR (`damage_taken_cb`) AND SITS ABOVE THE `sim` GUARD ON PURPOSE.**
  The recap LEDGER is real-play-only; a TALENT that fired only outside the sim is a talent no
  measurement in this project could ever see (BL's own dropped `sim and` guard in the DoT loop is
  the precedent, from the other side). `_on_damage_taken`'s early return was split for it.
· **ASHEN SKIN PAYS FOR THE TICKS HE APPLIED AND NOBODY ELSE'S**, reading the `src_name`
  `_apply_status` already stamps (the applier may be dead, which is why the status carries a name
  and not a unit). A rune's burn, an enemy Ashblade's burn and a second applier's burn all
  correctly pay him nothing — driven in the suite with two fires from two appliers.
· **FORGE BODY'S THROW SAVES AND RESTORES THE DAMAGE FRAME.** It fires from inside `_resolve`'s
  strike-target block and `_dmg_frame` is set at `_resolve`'s entry, so without the restore every
  later hit of the same cast would book against Forge Body (BL §2's re-establish rule, arriving
  through a new door).
· **HEAT HAZE IS THE ATTACKER'S FIRE, NOT THE DEFENDER'S** — the reading his kit can actually
  produce (nothing in it sets HIM alight) and what makes Immolate one row above it a combo. It is
  additive percentage points in `_miss_chance`. **BOUND WORTH KNOWING: the single-target miss roll
  is gated `not ab.aoe`, so it blanks single-target blows only** — the same bound Blind has
  carried since BO. **A SUITE THAT ARMS `no_cover` ON EVERYONE FOR DETERMINISM CAN NEVER SEE IT
  WORK** (BQ's Mirror Image lesson through the other door); test_batch_bs reads `_miss_chance`
  directly and disarms `no_cover` on the one attacker it measures.
**§4 — EMBER DEBT RE-AUTHORED, NOT REPLACED.** It was entirely a drain exemption, and with no
bill it was free Burn with no clause at all, which is not an ability. **NEW AXIS: PAID BEFORE IT
BURNS** — 20 Mana, 2.0, 4cd, one enemy: 8 turns of Burn (Perfect 12), and **Overburn refunds
every one of those turns immediately, as though he had already consumed them**, while the fire
still burns its full term. Every other Burn payout EMPTIES the bank; this is the deepest
single-target Burn he can lay and the only card the passive pays for without consuming anything.
**It goes through `_overburn_refund`, THE ONE DOOR** — AR's rule working, a fourth consumer
arriving and inheriting it (Crucible doubles it too). test_batch_ar's call-site count re-pointed
**3 -> 4**, which is BO's pinned count doing its job rather than decaying.
**THE RUNE AUDIT CAME BACK CLEAN AND IS RECORDED AS A FACT RATHER THAN A NOTE**, because a rune
riding a counter that changed meaning fails SILENTLY. **NO Pyromancer or Mage rune wrote any of
the seven deleted fields**, so nothing needed re-pointing and nothing was flagged for
re-authoring. The four spec runes ride `accelerant_ranks`, `conflagration_ranks`, `molten_ranks`,
`supernova_ranks`, `blast_radius_ranks`, `rune_cinder_ember`, `rune_resist_pierce` and the inert
`pyromaniac_ranks`; every one was verified to still have a live read site. **THE WHITE FLAME'S
MIDDLE CLAUSE IS STILL ASSERTED INERT and the assertion is UNCHANGED** — this batch gave it no
home (Overburn still has no per-burning-enemy step, and inventing one is the guess AR forbade).
**THE AUTOPLAY MAGE POLICY KNEW A RULE THAT REFERENCED NOTHING** — "consume Burn when the drain
exceeds Mana regeneration". **REPLACED rather than merely dropped**, or the bot would hold fire
forever and never cash it: detonate the largest stack at `DETONATE_AT` = 4 burn-turns, Wildfire
when Detonation is cooling, Immolate whenever there is something to retaliate against.
**THREE PREMISES IN THE BRIEF WERE STALE AND ARE CORRECTED TOWARD THE CODE** (the AR §6 / AX §7 /
BD §3 / AY §1 precedent): §1 says `_overburn_refund` has **two** call sites and it has had
**three** since BO added Cinderfall (four now); §5 asks for "the Overburn entry" in
`data/glossary.json`, which **has never existed** — the Burn entry describes no cost for holding
fire, so nothing there needed correcting, and an Overburn entry was **ADDED** rather than edited
(glossary 85 -> 86); and §5 says the **known-gaps entry** for his absent defensive option is
closed, but **master.html's §13 never carried one** — the claim lived in §6.2's prose and in
`test_batch_ar._no_defence`, and both were re-pointed.
**VERIFIED — AND PER THE STANDING INSTRUCTION, THAT MEANS THE CODE LANDED AND WORKS. NO SWEEPS,
NO BANDS, NO BALANCE MEASUREMENT WAS RUN, and none should be quoted from this batch.**
check_parse 0 · check_flow 0 · run-harness gates 1/2/3 PASS · **NEW test_batch_bs.gd 262/0,
stable 3/3**.
**THIRTEEN NEGATIVE CONTROLS, each applied to product code and reverted** (battle.gd, unit.gd and
talents.gd came back byte-identical by hash): the drain RESTORED as a turn-start bill **trips 2**;
Forge Body reading burning BODIES **trips 1**; Kiln-Forged with no board gate **trips 1**;
Backblast without its once-per-battle flag **trips 2**; Ashen Skin healing on any burn tick
**trips 1**; Heat Haze reading the DEFENDER's fire **trips 2**; Ash Lung paying only the dealt
half **trips 1**; Ember Debt not paying the refund up front **trips 3**; Immolate lifting the cap
again **trips 1**; Forge Body's throw not restoring the damage frame **trips 1**.
**THREE OF THEM PASSED ON THE FIRST RUN AND ALL THREE FOUND A CHECK THAT COULD NOT FAIL — WHICH
IS THE WHOLE REASON TO RUN THEM, AND THE THIRD IS THE ONE WORTH CARRYING FORWARD:**
· **Restoring the drain tripped NOTHING.** Function-absence greps cannot see a bill written
  straight into `_player_turn`. Three source-level checks were added — and **COMMENTS ARE
  STRIPPED FIRST**, because this batch's own tombstone in that function names the deleted bill on
  purpose and a bare `contains` would fail against working code, inviting a later author to
  "fix" it by deleting the one line telling them not to put the bill back.
· **Deleting Backblast's once-per-battle flag tripped NOTHING**, because the first fire leaves
  him at 45% — ABOVE the 40% line — so the THRESHOLD refused the second call and the flag was
  never under test. He is dropped back under the line first now.
· **DISABLING ASH LUNG'S TAKEN HALF TRIPPED NOTHING, AND THE DIAGNOSIS GENERALISES TO EVERY
  ONE-BLOW-AGAINST-ONE-BLOW CHECK IN THIS PROJECT.** BQ killed the CRIT roll for exactly this
  class of check; **the ±10% VARIANCE roll is the half that survived it**, and it is worse than
  crit because it is not suppressible by a field. With the term disabled the second blow still
  read SMALLER (34 against 32) — the two blows stop consuming the RNG identically once the board
  differs, so **seeding is not enough and "it went down" is satisfied by NOISE.** THE FIX IS
  TWOFOLD AND BOTH HALVES ARE NEEDED: **amplify the term for the measurement** (20 points rather
  than the shipped 4, with the shipped value asserted separately off the payload) **and assert a
  RATIO with open ground between signal (~0.38) and noise (~0.94)**, never a bare `<`.
**FULL BATTERY GREEN**: ah 5500, ah_battle 65, ai 2217, aj 418, ak 528, al 560, **ar 735**,
as 396, at 470, au 336, av 324, aw 350, ax 338, ay 484, az 519, ba 690, bb 172, bc 91, bd 69,
be 34, bf 78, bg 47, bh 233, bi 88, bj 67, bl 88, **bm 1891**, bn 77, **bo 504**, bp 268, bq 738,
br 1441, **bs 262**, runes 2973, **rune_battle 97** — all 0 failures. **an reads 3621 and bk 129,
both inside their DOCUMENTED run-to-run drift** — neither is pinned and neither should be.
· **FOUR COUNTS MOVED AND EVERY ONE IS EXPLAINED**: ar 914 -> 735 (the asymmetry loop shed its
  cost half — 61 iterations asserting a climbing drain), bm 1890 -> 1891 (its row-8 field loop
  walks one more field, because Ashen Skin honestly writes two), bo 505 -> 504 (the
  two-denominator pair collapses into one check) and rune_battle 96 -> 97 (one check ADDED by an
  inversion). **Nothing else moved by one.**
· **SEEN ONCE, NOT REPRODUCED (the AO precedent): test_batch_br read 1441/1 on one battery pass
  and 1441/0 on FOUR runs since, and the failing check was not captured.** Recorded rather than
  claimed fixed or diagnosed. Nothing in this batch is on the Warrior or Hunter class-card path.
· **test_batch_at's Arcane Cannon flake and test_batch_al's Spite flake did NOT reproduce** in
  either battery pass; test_runes still prints its pre-existing `start_rune_enabled` SCRIPT ERROR
  and still reads 2973/0.
· **KNOWN-BAD, NOT OURS, AND UNCHANGED: test_batch_ah and test_batch_an both still call
  `Run.award_talent_points`, which BM deleted** — each throws a SCRIPT ERROR that aborts its own
  section while the suite prints 0 failures, so both have been silently under-testing since BM.
**THE DESIGNER HAD NO RUN IN FLIGHT and none was created** — no `run_save.bin` exists, and
**profile.json, relics.json AND trees.json are all byte-identical by hash** across the whole
battery (no `--run` was walked, because this batch measures nothing).
**THE MASTER.HTML STAMP GATE IS STILL DUPLICATED SEVEN TIMES** — test_batch_ah, bb, bn, bo, bp,
bq and br — **and all seven moved together to Batch BS**. test_batch_bs deliberately does NOT add
an eighth; the honest fix, if anyone wants one, is still for the newest suite to be the only one
that checks it.
**SUITES RE-POINTED IN PLACE WITH THE REASON IN EACH FILE, AND FIVE OF THE RE-POINTS ARE
INVERSIONS** — the honest treatment when a batch reverses a decision an older suite was guarding.
**test_batch_ar** is the big one (its asymmetry loop, its drain section, its chip check, its
Immolate check, its `_no_defence` and its passive-desc check all invert; the node/payload/scale
tables carry the eight re-authored nodes; the refund call-site count goes 3 -> 4) —
**735/0, was 914, and the drop is the asymmetry loop shedding its cost half** (61 iterations that
asserted a climbing drain beside a flat bonus, against a drain that no longer exists).
**test_batch_bj**'s "Cauterise states the Kiln-Forged precedence" re-points onto Kiln-Forged's own
board gate, which is the same question about the surviving node. **test_rune_battle**'s
"the chip reads the LIVE drain" inverts to "the chip must NOT advertise a term that no longer
exists" — **97/0, was 96**.
· **AND ONE OF THEM WAS FOUND BY A COUNT RATHER THAN A FAILURE, WHICH IS THE BC TRAP WORKING AS
  DOCUMENTED: test_batch_bo READ 495/0 WHERE BR RECORDED 505.** Its Ember Debt section touches
  `foes[0].ember_debt`, which BS deleted — so the section threw a SCRIPT ERROR, **aborted its own
  function, and the suite still printed "0 failures"**. Nothing failed; ten checks simply stopped
  existing. Re-pointed onto the re-authored card (it is PAID UP FRONT now, measured as a Mana
  delta rather than as a difference between two denominators) and back to **504/0** — one short
  of BR's 505 because the two-denominator pair honestly collapses into one check.
  **READ THE COUNTS, NOT ONLY THE FAILURES.**
**LIVE AUTOPLAY CLEAN, 0 SCRIPT ERROR**, with the re-specs reading correctly in ordinary fights —
"Immolate — -20% damage taken and attackers ignite (3 turns)", "Ember Debt — Orc Raider burns 8
turns, and Overburn pays the debt up front" immediately followed by "Overburn: 8 turns of Burn
consumed refunds 8 Mana", and "Backblast — Pyromancer sets 5 enemies alight (4 turns) and takes
back 20". **Forge Body is visible READING BURN TURNS rather than bodies**, its throw climbing
1 -> 2 -> 4 -> 5 across one fight as the field filled. **NO OVERBURN DRAIN LINE APPEARS ANYWHERE**
— there is none to print. **KILN-FORGED DID NOT FIRE IN ANY SMOKE and that is the branch being
rare rather than a gap** (it needs an actually lethal blow while three or more enemies burn); the
suite drives it directly, which is where a rare branch belongs (the BB precedent). **NOTE the
smoke's own artefact**: `DOD_SIM_ABILITIES` applies its list to EVERY hero, so the Devout and the
Beastmaster cast Ember Debt in the log — and **only the Pyromancer's cast pays the refund**,
which is the passive's own guard working in plain sight.

BATCH BR (08-14) — THE HUNTER AND WARRIOR CLASS POOLS. **Twelve class-wide abilities, six per
class, CLOSING the seam BO opened and BQ half-filled: all four `CLASS_DRAFT_POOLS` are populated,
so every hero's one-in-four class card draws a real entry and NO CLASS ROLLS AN EMPTY POOL.** The
draft goes 36 -> **48 of a target ~96**. Nothing else ships — no talent node, no magnitude, no
existing ability changed, no save version moves (still v10). **TRANCHES 2 AND 3 ARE STILL OWED**:
spec pools are two deep apiece, so a hero worn down by the no-return ledger still fills SHORT. The
two standing rules §1 set are the two blocks directly above; this block is the content, the
decisions and the verification.
**THE TWELVE, WITH THEIR ONE-LINE ROLES.** Defs live in `Classes.draft_ability` beside BO's, BP's
and BQ's, resolved at the top of `pool_ability` as before.
· **HUNTER** — three spines that are all CONDITIONAL (the Beastmaster needs a beast standing, the
  Sharpshooter needs to not have switched, the Survivalist needs statuses on the board), in a class
  with **no healing whatsoever** and the thinnest defensive kit in the game: **Field Dressing**
  (20 Mana, 2.0, 3cd, self — heals 18% of maximum and removes ONE harmful effect; the only self-heal
  a Hunter can get) · **Camouflage** (20, 1.5, 4cd, self — 2 turns, enemies 70% less likely to
  target him; buying time rather than soaking) · **Aimed Volley** (20, 2.5, 3cd — three shots at 12%
  of Attack, 8 BD a shot; the reliable strike, and multi-hit is what makes it play with a charge
  bank) · **Bola** (15, 1.5, 3cd — Slowed AND Crippled 3 turns, and nothing else at all) ·
  **Hunter's Mark** (15, 1.5, 4cd — the WHOLE party deals 15% more damage to it for 4 turns; the
  only party-wide amplifier the class has) · **Arcane Arrows** (25, 2.0, 5cd, self — 5 charges, each
  of his next five HITS also strikes an additional random enemy for half that hit's damage; BANKED,
  not timed).
· **WARRIOR** — three spines that are all melee, all Rage-driven and all REACTIVE, none of which can
  make something happen on turn one: **Battle Trance** (15 Rage, 1.5, 4cd, self — 3 turns of 3% of
  maximum health PLUS HALF the damage taken since his last turn) · **Rally** (15, 1.5, 4cd, one ally
  — that ally acts NEXT; the only ability in the game that hands an ally a turn) · **Charge** (20,
  **1.0**, 3cd — 25% of Attack, **20 BD**, Dazed 1 turn, **builds 30 Rage**; the fastest arrival in
  the kit, and the designer's reprice — see below) · **Cleave**
  (25, 2.5, 3cd, three CHOSEN enemies — 15% of Attack and 15 BD each) · **Warcry** (20, 2.0, 5cd —
  the whole party deals 20% more damage for 3 turns) · **Iron Will** (20, 1.5, 4cd, self — 3 turns
  of no Stun, Freeze, Daze or Break, and 15% less damage).
**ALL THREE WARRIOR SPECS USE RAGE — verified at the site rather than assumed before pricing:**
`resource_name` is decided ONCE in `CONFIGS["warrior"]` and no spec override touches it, and the
pool is 100 so every cost above is payable.
**IRON WILL'S BREAK HALF IS A CAP, NOT AN IMMUNITY, AND THE CLAMP'S POSITION IS THE WHOLE
DECISION.** While it holds his meter fills to **99** and no further; pressure still ACCUMULATES and
simply cannot cross, so the moment it lapses he is one hit from Broken and the enemy's three turns
of Break work are **deferred rather than erased**. The clamp lives in `unit.take_hit` **BELOW the
meter write and ABOVE the threshold** — the only position where the pressure is both counted and
refused. **DO NOT REWRITE IT as "the meter cannot fill"** (zeroing `pressure_add` up in the reducer
block with Bulwark and Immovable) **OR as "Broken is refused"** (a guard on the `broken = true`
line): both read identically in a short test and NEITHER leaves him at 99 — the first throws the
pressure away, the second lets the meter sit at 100 and break on the very next point.
test_batch_br asserts the **99**, not the absence of Broken.
· **BROKEN IS DELIBERATELY NOT IN THE STATUS-REFUSAL LIST.** `_apply_status` names exactly three ids
  (`stunned`, `frozen`, `dazed`). Broken is a Break-METER state written inside `take_hit`, not a
  status anyone applies; adding it there would look like the same rule and quietly replace the
  delay with a negation. **`force` does not bypass the refusal either** — that argument is the boss
  carve-out bought by two perfects, and a hero who spent 20 Rage on three turns of not losing a
  turn is a different promise.
**BATTLE TRANCE READS DAMAGE TAKEN, NOT MISSING HEALTH, AND THAT DISTINCTION IS THE ABILITY.**
`BattleUnit.trance_taken` is a dedicated accumulator written by `_report_taken` — BL's ONE door, so
it books health actually removed, below every death refusal — and **CLEARED AT EVERY TICK** (and at
the cast), which is what makes "since his last turn" true rather than "since the trance began". It
is deliberately NOT a read of BL's `dmg_by_turn`: that is a fixed two-turn window keyed on the
GLOBAL turn index, and this is the span between one hero's turns. The **3% floor pays even when he
took nothing**, which is what stops the card being dead in the fight where nobody hits him.
`_battle_trance_tick` is its own function for the standing reason (`_run_battle` cannot be driven
headlessly). **THE RECOVERY IS DELAYED AND THAT IS WHAT KEEPS IT HONEST** — it is not mitigation
and cannot save him from a killing blow.
**RALLY REUSES THE EXISTING INITIATIVE MACHINERY — `_rally_forward`, and there is NO second
turn-order manipulator.** `Ability.delay_push` and Shattered Tempo both write `next_time` to push a
unit along the timeline; this is that write aimed the other way. **It pulls to the FIELD minimum
rather than to the caster's own clock**: the Warrior has already paid his delay by then, so reading
his clock would sometimes leave the ally behind an enemy that was already sooner, and "acts next"
has to mean next. **IT CANNOT PRODUCE UNBOUNDED CONSECUTIVE TURNS, structurally**: the ally spends
the turn and re-enters the order, the Warrior spent HIS to give it, the cooldown is 4, and **the
caster is excluded from the target pool at THREE sites** (the player's picker, the bot's pool, and
`_ability_usable`, which refuses the cast outright when he is the last one standing), with the
special's own `target != attacker` guard as the belt to those braces.
**HUNTER'S MARK IS ONE MULTIPLIER WITH TWO CALLERS.** `_party_mark_mult` is read by the strike loop
AND by `_companion_hit`, because a beast is a SEPARATE damage path and the card says "the WHOLE
party" — **checked at the site rather than assumed from `comp.is_hero`**, which is true of a
companion and would have made "every beast reads it" look covered while it was not. The mark
carries **no owner index**, which is the entire distinction from the Beastmaster's `hunt_mark`
(that one stamps the hunter's index and pays HIM and his beast 25% plus Mana). One mark at a time —
marking a second enemy clears the first.
**CAMOUFLAGE AND GHILLIE SUIT STACK AS INDEPENDENT CHANCES, IN ONE FUNCTION AND ONE ROLL.**
`_evade_chance` returns `1 - (1-ghillie)(1-camo)` = **89.5%** for a hero holding both, against 65%
for the node alone — so neither silently overwrites the other and neither is summed past 100%.
**ONE COMBINED ROLL rather than one each**, because two sequential re-picks would let the second
undo the first's choice; the old Ghillie-only roll is GONE rather than left beside it.
**THREE FINDINGS, REPORTED AND NOT RE-TUNED:**
· **CAMOUFLAGE IS CLOSE TO A DEAD DRAW FOR A SURVIVALIST HOLDING GHILLIE SUIT** — the card adds
  **24.5 points** to a Ghillie build against 70 to anyone else. §2 predicted it; measured, and
  shipped as specified.
· **WARCRY OUT-SIZES BATTLE SHOUT ON ITS HEADLINE NUMBER**, which fails §4's "class abilities are
  weaker than spec abilities" in the direction that matters: +20%/3 turns party-wide against
  Battle Shout's 8%/2 base and 12%/3 or 18%/4 noded. **THE TERM THAT KEEPS THE SPEC CARD'S CEILING
  ABOVE IT IS THE ONE WARCRY HAS NO ANSWER TO** — Battle Shout adds 1% per 20 points of Bleed on
  the enemy party at cast time, so in the build it belongs to it runs well past 20%. Shipped per
  §4's instruction to confirm and REPORT; both numbers are pinned so a reprice reads the reasoning
  first. **The lever is one of Warcry's two numbers and it is the designer's.**
· **CLEAVE IS NEARLY WAR STOMP** — same 15% of Attack, same 15 BD, three targets each. The stomp
  costs 20 Rage against Cleave's 25 and refuels every ally on top, so **Cleave is unambiguously the
  lesser**, which is the direction §4 requires. **The distinction is CHOSEN three (`choose_three`)
  against RANDOM three (`random_hits: 3`, which can land twice on one body)**, and the acquisition
  channels differ (the stomp is a boss/spec pick, Cleave is drafted). Closest two cards in the draft
  since BD found Deadfall duplicating Snare Trap; recorded rather than discovered later.
**BREAK DAMAGE ASSIGNED DELIBERATELY (BO's correction, applied up front).** Cleave 15 EACH (the
brief's) · **Aimed Volley 8 A SHOT = 24 across the volley**, and that is §4's "25" read as a TOTAL
rather than per shot: the brief writes "(15 each)" for Cleave and "(25)" for the volley, 25 does
not divide by three, and 8 lands level with Triple Shot's 8 a shot and 24 across three. Reading it
per shot would have given a class card 75 Break against a Sharpshooter spec card's 24. **The
one-point deviation is stated rather than rounded away silently.** · **Charge shipped at 10, DELIBERATELY
BELOW the free Strike's 18** — BQ's rule (the floor for a class card is the FREE BASIC) applied the
other way — **AND THE DESIGNER REPRICED IT TO 20 BD AND 30 RAGE IMMEDIATELY AFTER THE BATCH
SHIPPED. See the reprice note below; the original argument is kept because a later reader would
otherwise re-derive it.** · **The other nine carry NONE** — they are not attacks. · **FIVE OF THE
SIX WARRIOR CARDS CARRY NO `resource_gain`**, which is the cleanest statement of "weaker than spec
work" a Rage class can be given: every Warrior spec ability builds 10-15 Rage while it spends, and
those five spend without building. **Charge is the exception, by the same reprice.**
**THE CHARGE REPRICE, AND WHAT IT MAKES THE CARD — the one thing a later reader will want.** At 20
BD and 30 Rage, **Charge beats the free Strike on damage (25% vs 23%), on Break (20 vs 18) and on
initiative (1.0 vs 2.0), carries a Daze, and still NET-GENERATES 10 Rage** (30 gained against its
own 20 spent). **Strike wins only on net Rage (+20) and on having no cooldown.** So it is the
**first and only class-wide card in all twenty-four that generates its resource**, and the only one
that is not weaker than the free basic on every axis — **a deliberate exception to BQ's rule rather
than a drift past it**. It also clears **Overpower** (a Warrior boss-pool card) on cost, damage,
initiative and Rage economy, losing only on cooldown (3 vs 1) and on Overpower's Break-scaling
bonus. test_batch_br pins the exception BY NAME, asserts the two axes Strike still wins, and asserts
that the other twenty-three class cards generate NOTHING — so a later batch cannot quietly add a
second generator.
**ONE CORRECTION TOWARD THE CODE: WARCRY IS +20% DAMAGE DEALT, NOT +20% ATTACK.** §3 says "gains
20% Attack"; `attack` is a raw stat read at dozens of sites (DoT snapshots, companion strikes,
poison ticks) and a temporary mutation of it needs a revert path — the exact shape that produced
this project's ~127,000 max-HP runaway (Batch W) and the reason the victory sync carries three
separate fields. It rides **Battle Shout's own read site**, so there is ONE implementation of "this
unit deals N% more damage", the two compose additively rather than one winning, and the number is
identical where it is felt.
**NEW UNIT-SIDE STATE: ONE FIELD.** `trance_taken`. The other eleven are carried entirely by
STATUSES — `camouflage`, `party_mark`, `battle_trance`, `warcry`, `ironclad`, plus `arrows` whose
COUNT lives in its status's power BATTLE-LONG (the Mirror Image precedent) — and Bola rides the
EXISTING `slow` and `cripple`, because authoring a third affliction would be the Choking Smoke
mistake. Statuses expire by themselves and cannot leak past a battle.
**VERIFIED — AND PER THE STANDING INSTRUCTION, THAT MEANS THE CODE LANDED AND WORKS. NO SWEEPS, NO
BANDS, NO BALANCE MEASUREMENT WAS RUN, and none should be quoted from this batch.**
check_parse 0 · check_flow 0 · check_map_screen OK · run-harness gates 1/2/3 PASS ·
**NEW test_batch_br.gd 1441/0** (1414 at ship; the Charge reprice added 27 checks). All six clauses §6 named as able to silently do nothing are driven
live and asserted against the state they change; **six are built so a broken implementation still
fails** (the volley's spend is an EXACT identity 5->2 with a single-strike ability asserted to
spend exactly one in the same check — which is what tells "three per volley" from "three per cast";
the charges are TICKED six times before the count is re-read; Battle Trance is measured where the
two readings differ by construction — 140 missing health against 20 taken, so the right answer is
16 and the missing-health reading would be 76; Rally is asserted to make the ally the unit
`_next_unit` actually RETURNS; Camouflage's combined chance is asserted HIGHER than either alone and
LOWER than their sum, which only independent combination gives; and Iron Will's meter is asserted at
EXACTLY 99, which both wrong implementations fail).
**LIVE AUTOPLAY CLEAN, 0 SCRIPT ERROR, ALL TWELVE FIRING IN ORDINARY FIGHTS** — "Battle Trance:
Berserker comes back 16 — 3% of maximum plus half of the 22 he took since his last turn" (the number
that tells a live read from a low-health heal), "Rally — Devout acts NEXT, straight to the front of
the order", "Warcry — 4 heroes deal 20% more damage for 3 turns", and **§1's rule visible in three
consecutive lines**: "Aimed Volley … the shot forks into Orc Chief (5 charges left)" … "(4 charges
left)" … "(3 charges left)", with a MISSED shot spending none. **NOTE the smoke's own artefact:
`DOD_SIM_ABILITIES` applies its list to EVERY hero, so a Cryomancer casts Charge in the log — the
real draft only ever offers class-matching cards.**
**ELEVEN NEGATIVE CONTROLS, each applied to product code and reverted** (battle.gd, unit.gd and
classes.gd each came back byte-identical by hash, and the suite to 1414/0 after the last — that
figure predates the Charge reprice, which took the suite to 1441): Iron Will
as "the meter cannot fill" **trips 5**; Iron Will as "Broken is refused" **trips 3**; Arcane Arrows
spending one charge per CAST **trips 3**; Arcane Arrows put on a clock **trips 5**; Battle Trance
reading MISSING HEALTH **trips 2**; Battle Trance's accumulator never cleared **trips 2**;
Camouflage OVERWRITING Ghillie Suit **trips 2**; Hunter's Mark paying only the hero who marked
**trips 2**; Mirror Image back to one image per CAST **trips 2**; a class ability leaking into
`CLASS_POOLS` **trips 2**; Rally's ally pool no longer excluding the caster **trips 1**.
**FULL BATTERY GREEN**: ah 5500, ah_battle 65, ai 2217, aj 418, ak 528, al 560, ar 914, as 396,
at 470, au 336, av 324, aw 350, ax 338, ay 484, az 519, **ba 690**, bb 172, bc 91, bd 69, be 34,
bf 78, bg 47, bh 233, bi 88, bj 67, bl 88, bm 1890, bn 77, **bo 505**, **bp 268**, **bq 738**,
**br 1441**, runes 2973, rune_battle 96 — all 0 failures. **an reads 3624 and bk 130, both inside
their DOCUMENTED run-to-run drift** — neither is pinned and neither should be.
· **THE THREE RAISED COUNTS ARE POOL LOOPS WALKING MORE ENTRIES, not new assertions** (bo 502 ->
  505, bp 260 -> 268, bq 592 -> 738): each suite iterates the LIVE pools, and twelve arrived. bq's
  jump is the largest because its "no class card is also in a spec pool" check is 12 names x 12
  specs. ba 689 -> 690 is one check ADDED by a re-point.
· **FIVE SUITES RE-POINTED IN PLACE with the reason in each file, and FOUR OF THE RE-POINTS ARE
  INVERSIONS** — the honest treatment when a batch pays a debt an older suite was recording:
  test_batch_bo's, test_batch_bp's and test_batch_bq's "the Hunter and Warrior class pools are still
  EMPTY and still owed" became "all four are FILLED at six"; bo's and bq's "a Hunter's offer fills
  SHORT at two" became "it fills THREE", with the FILL-SHORT rule kept by wearing a pool down with
  the no-return ledger instead — that rule was never about which pool is thin, it is about an offer
  never padding with repeats; and bq's doc line "master.html says the seam is HALF filled" inverted
  with the doc. **The setups are byte-identical, because they are still what tells the two answers
  apart.**
· **test_batch_ba's Ghillie Suit grep was RE-POINTED AND IT WAS A REAL CATCH** (the AZ
  Follow-Through precedent exactly): it looks for the literal `0.01 * target.ghillie` to prove the
  node reads its own counter as the CHANCE, and extracting the roll into `_evade_chance` deleted
  that exact text. The question is unchanged; the fragment is `0.01 * u.ghillie` now, with a second
  check that the function is shared with Camouflage. 690/0.
· **TWO PRE-EXISTING FLAKES IN test_batch_bq FOUND AND CLOSED BY FORCED DETERMINISM, not retried**
  (the AK/AL/AR discipline): its Unburden mitigation check and its Exhortation damage check each
  compare ONE blow against ONE blow with the CRIT ROLL LIVE, and a 20% cut or a 25% buff cannot
  survive the other side landing a x1.5 crit — each failed about one run in five against working
  code. Variance alone could never flip either (the ratio would have to exceed 1.25 and
  `randf_range` tops out at 1.1/0.9), which is what identifies the crit as the cause.
  `crit_bonus = -1.0` on the relevant unit; 5/5 clean after.
· **KNOWN-BAD, NOT OURS, AND UNCHANGED: test_batch_ah and test_batch_an both still call
  `Run.award_talent_points`, which BM deleted** — each throws a SCRIPT ERROR that aborts its own
  section while the suite still prints 0 failures, so both have been silently under-testing since
  BM. test_runes still prints its pre-existing `start_rune_enabled` SCRIPT ERROR. **test_batch_al's
  standing "Spite reflects damage at the attacker" flake reproduced once and passed on a clean
  re-run**, as recorded since BI/AQ; nothing here is on the Warden's damage path.
**THE DESIGNER HAD NO RUN IN FLIGHT and none was created** — no `run_save.bin` exists;
relics.json and trees.json are byte-identical by hash after the battery and after a `--run 6` walked
ONLY to exercise RunSim's draft path (**9.00 offers/run, 27.00 cards shown, taken 9.00** — three
cards an offer, never short, which is the seam closing measured end to end). **Its Matrix row is NOT
a difficulty reading and none is quoted.** profile.json gained the expected run counters.
**THE MASTER.HTML STAMP GATE IS DUPLICATED SEVEN TIMES** — test_batch_ah, test_batch_bb,
test_batch_bn, test_batch_bo, test_batch_bp, test_batch_bq and test_batch_br. **All seven must move
together** or a batch that bumps the timestamp trips suites it never touched. The count grows by one
every time a new suite checks the stamp; the honest fix, if anyone wants one, is for the newest
suite to be the only one that checks it.

BATCH BQ (08-13) — THE MAGE AND CLERIC CLASS POOLS. **Twelve class-wide abilities, six per
class, filling HALF the seam BO opened: one draft card in four is class-wide, and until now
that seam rolled into an empty pool for every hero in the game — a quarter of every offer was
dead.** Nothing else ships — no talent node, no magnitude, no existing ability changed, no save
version moves (still v10).
**THE HUNTER AND WARRIOR CLASS POOLS ARE STILL OWED — twelve of a target twenty-four ship here,
and a Hunter's or a Warrior's offer STILL LOSES ITS CLASS CARD.** `CLASS_DRAFT_POOLS["hunter"]`
and `["warrior"]` are still empty arrays and test_batch_bq asserts they are, so the debt stays
visible in code rather than only in prose. `SPEC_DRAFT_POOLS` is untouched at BP's 24, so the
draft holds **36 of a target 48**.
**`CLASS_DRAFT_POOLS` IS A SEPARATE STRUCTURE FROM `CLASS_POOLS` AND THAT IS THE ONE THING A
LATER BATCH WOULD MOST EASILY UNDO BY "TIDYING TWO POOLS INTO ONE".** BO's own argument, applied
to the other pool: **`CLASS_POOLS` feeds the BOSS pick**, so dropping six abilities into it
would silently re-weight every boss offer in the game as a side effect of a draft change.
**`CLASS_POOLS` is BYTE-UNTOUCHED and test_batch_bq asserts all four of its arrays AS LITERALS
rather than by size** — a swap of two names would keep the count and change every draw. That is
the negative control that matters here.
**THE TWELVE, WITH THEIR ONE-LINE ROLES.** Defs live in `Classes.draft_ability` beside BO's and
BP's, resolved at the top of `pool_ability` as before; a drafted class ability lands in
`bm_abilities` exactly as a spec one does, so battle spawn, the hero sheet, the rune filter and
upgrade pairing pick it up with no new plumbing.
· **MAGE** — the tools every spine wants and no spine provides, *because a spine that provided
  them would stop being a spine*: **Magic Barrier** (25 Mana, 2.0, 4cd, self — absorbs 15% of
  max health, 3 turns; the floor beneath all three) · **Mirror Image** (20, 2.0, 4cd, self —
  the next 3 SINGLE-TARGET attacks miss; evasion rather than absorption) · **Magic Missiles**
  (15, 2.0, 2cd — 3 bolts at 12% of Attack; the reliable filler) · **Mana Well** (20, 1.5, 5cd,
  self — regeneration DOUBLED 3 turns; costs mana to make mana) · **Dispel** (15, 1.5, 3cd —
  two harmful effects off an ally OR two beneficial off an enemy; utility nobody has) ·
  **Blink** (10, 1.0, 3cd, self — one turn off every cooldown, its own exempt; tempo).
· **CLERIC** — three support spines with enormous CONDITIONAL power and no baseline (**none of
  the three can simply heal someone on turn one**), and **the names are chosen for register**:
  priestly and old, rites and offices, so every one sits on an Occultist tongue as easily as on
  Holy's. **Ministration** (20, 2.0, 2cd, ally — heals 20% of THEIR max; the plain heal none of
  them has) · **Consecration** (25, 2.5, 5cd — party regains 5% of max a turn for 3; sustained
  rather than burst) · **Chastise** (15, 2.0, 2cd — 25% of Attack, 20 BD; see the finding) ·
  **Unburden** (20, 1.5, 4cd, ally — every harmful effect removed, then 20% less damage 2 turns;
  cleanse with a tail) · **Exhortation** (25, 2.5, 4cd — the party's NEXT attack +25%, BANKED
  not timed) · **Undying Vigil** (25, 2.0, 4cd, ally — every heal on them also mends a second
  ally on lower health for half; **the one class ability that gets BETTER the more spec-specific
  the build is**).
**THE FINDING, REPORTED AND NOT RE-TUNED — CHASTISE FAILS THE "WEAKER" RULE IN THE OTHER
DIRECTION.** The brief names both its numbers, and against them the FREE core attack wins on
damage for all three Cleric specs: Smite is 44% of Attack with 16 BD at no cost and no cooldown,
Shadowrend 25% with 16 BD plus a Cripple. Chastise pays 15 Mana and a 2-turn cooldown for 25%
and 4 more Break, so it is **DOMINATED — there is no board state on which casting it beats
simply attacking.** Shipped as specified; test_batch_bq pins the comparison so a reprice has to
read the reasoning first. **The lever is one of its two numbers and it is the designer's.**
The three comparisons that DO pass were computed, not assumed: Ministration's 20% of the
target's maximum tops out at 40 on the Warden's 200 against Heal's 40% of Holy's own 150 (60),
and one Mercy term scales both; Magic Missiles' 3x12% = 36% sits under Razor Ice's 45% and
Arcane Barrage's 48%; Magic Barrier's 15% sits under Divine Shield's 30% for more Mana and
double the cooldown.
**BREAK DAMAGE ASSIGNED DELIBERATELY (BO's correction, applied up front).** Chastise 20 (the
brief's); **Magic Missiles 3 PER BOLT** — 9 across three, below Razor Ice's 10 a shard and level
with Arcane Barrage's 3 while throwing half as many; **the other ten carry NONE** — they are not
attacks.
**DISPEL'S ENEMY HALF IS THIN AND IT WAS MEASURED BECAUSE §3 ASKED: `shielded` IS THE ONLY
BENEFICIAL STATUS AN ENEMY CAN CARRY IN THE WHOLE GAME**, applied by two of nineteen kinds (Orc
Shieldmaster's Shielding, the Hollow Crown's Regalia). That half strips at most ONE thing and
usually nothing. Reported rather than dropped — the ally half stands on its own, and authoring
enemy buffs is a content decision.
· **THE EXCLUSION LIST IS THE LOAD-BEARING HALF.** What may be stripped is DERIVED (anything not
  in `DEBUFF_IDS`), so a future enemy buff is dispellable the day it lands — but `DEBUFF_IDS`
  deliberately does NOT hold the five MARKS the party applies (`covenant`, `quarry`,
  `snare_line`, `feinted`, `hunt_mark`), and left to the derived rule **Dispel would have
  stripped the party's own work.** `ruin_primed` is the same trap through another door (the
  primer is not the mark, so it is not a debuff either, and dispelling it defuses the
  Occultist's bomb for him) and `charging` is a declared blow rather than a boon — **cancelling
  a wind-up is what a BREAK is for (Batch V)**. All eight are named in `DISPEL_NEVER`.
**THREE DECISIONS AND ONE EXTRACTION THE BRIEF DID NOT MAKE:**
· **DISPEL TARGETS EITHER SIDE THROUGH A WIDENED PICKER POOL, NOT A THIRD `Ability.Target`.** An
  enum entry would have to be understood by the enemy AI's re-validation, the intent classifier,
  the bot's targeting and `_ability_usable` — four places needing a rule for a case one card
  uses. `_resolve_special` reads `target.is_hero`; that is the whole cost of the feature.
· **THE COOLDOWN HOOK §3 SAID TO REUSE DID NOT EXIST AS A HOOK — IT EXISTED AS FOUR COPIES.**
  Follow-Through, Practised Hands, Frostbound Hours and Crusader's Tempo each carried their own
  hand-written six lines. All four call **`_tick_cooldowns(u, turns, skip)`** now and behave
  IDENTICALLY (cutting an entry already at zero was always a no-op), with Blink the fifth
  caller. The BP Eye-of-the-Storm lesson: a number written twice eventually disagrees with
  itself.
· **NO NEW UNIT FIELDS AT ALL FOR TWELVE ABILITIES.** Everything with a duration is a status
  (`barrier`, `mana_well`, `consecration`, `unburdened`, `vigil`); the two that are BANKED
  rather than timed — Mirror Image's images and Exhortation's share — **live in their status's
  `power`, BATTLE-LONG, on the INTERPOSE precedent.** Battle-long is what makes "banked, not
  timed" true. **GOTCHA: `status_power` RETURNS -1 FOR AN ABSENT STATUS, NOT 0** — every read
  site guards on `< 1` or `> 0`, but a test written the obvious way reads -1 and fails against
  working code.
· **NO COVER BYPASSES MIRROR IMAGE AND SPENDS NO IMAGE**, honouring `_miss_chance`'s documented
  absolute ("cannot be made to miss by any current or future source"). Unreachable in play (only
  the Sharpshooter carries it and heroes do not attack the Mage). **A SUITE THAT ARMS `no_cover`
  ON EVERY UNIT FOR DETERMINISM — test_batch_bp does — WILL SEE EVERY IMAGE LOOK BROKEN.**
  test_batch_bq arms it on the HEROES only and says why in its harness.
· **ONE MORE ONE-LINE RULE, worth having: `_on_vigil_heal` is guarded by `_vigil_forking`**, and
  the chain it prevents is REACHABLE rather than theoretical — the fork RAISES its recipient, so
  a second warded ally can end up above somebody who was above them a moment earlier.
**UNDYING VIGIL FIRES FROM `heal_amount`'s BOTTOM LINE** (`vigil_cb`, the `blight_cb` door), so
"healed BY ANY SOURCE" is true rather than "healed by the abilities we remembered to list" — a
cast, a Renewal tick, an item and a lifesteal all arrive there. It picks the living hero on the
LOWEST health fraction among those STRICTLY BELOW the warded ally, so the ward spreads downward
and can never re-heal the ally just healed.
**THE MASTER.HTML STAMP GATE IS DUPLICATED SIX TIMES, NOT FOUR** — test_batch_ah, test_batch_bb,
test_batch_bn, test_batch_bo, **test_batch_bp (which BP's own note forgot to count while adding
it)** and test_batch_bq. **All six must move together** or a batch that bumps the timestamp trips
suites it never touched. Correct BP's own note, which says four. The count grows by one every
time a new suite checks the stamp; the honest fix, if anyone wants one, is for the newest suite
to be the only one that checks it.
**VERIFIED — AND PER THE STANDING INSTRUCTION, THAT MEANS THE CODE LANDED AND WORKS. NO SWEEPS,
NO BANDS, NO BALANCE MEASUREMENT WAS RUN, and none should be quoted from this batch.**
check_parse 0 · check_flow 0 · check_map_screen OK · run-harness gates 1/2/3 PASS ·
**NEW test_batch_bq.gd 592/0**.
**NINE NEGATIVE CONTROLS, each applied to product code and reverted** (battle.gd and classes.gd
came back byte-identical by hash, and the suite to 592/0 after the last): an image spent by an
AREA attack **trips 3**; Mana Well doubling a hardcoded 12 **trips 1**; Dispel's exclusion list
removed **trips 3**; Blink refunding its own cooldown **trips 1**; the vigil fork's re-entrancy
guard deleted **trips 1**; Exhortation put on a clock **trips 3**; a class-wide ability leaking
into `CLASS_POOLS` **trips 2**; Ministration reading the caster's maximum **trips 1**; the
Exhortation spend site removed **trips 2**.
**LIVE AUTOPLAY CLEAN across three real battles, 0 SCRIPT ERROR, ALL TWELVE FIRING IN ORDINARY
FIGHTS** — "Magic Barrier — absorbs 27 (20% of maximum health)", **"Mana Well — regeneration
doubled to 44 a turn"** (12 plus Evocation's 10, doubled: the number that tells a live read apart
from a doubled constant), "Orc Raider strikes an image of Pyromancer (2 left)", and Exhortation
banking across turns before spending on a swing. **NOTE the smoke's own artefact:
`DOD_SIM_ABILITIES` applies its list to EVERY hero, so a Berserker casts Magic Barrier in the
log — the real draft only ever offers class-matching cards.**
**FULL BATTERY GREEN**: ah 5500, ah_battle 65, ai 2217, aj 418, ak 528, al 560, ar 914, as 396,
at 470, au 336, av 324, aw 350, ax 338, ay 484, az 519, ba 689, bb 172, bc 91, bd 69, be 34,
bf 78, bg 47, bh 233, bi 88, bj 67, bl 88, bm 1890, bn 77, bo 502, bp 260, bq 592, runes 2973,
rune_battle 96 — all 0 failures. **an reads 3617-3620 and bk 129-130, both inside their
DOCUMENTED run-to-run drift** — neither is pinned and neither should be. **test_batch_at's
Arcane Cannon flake (recorded since AV) reproduced ONCE in two battery passes** and read 470/0
on a clean re-run; nothing here is on the Arcanist's path.
· **SEVEN SUITES RE-POINTED IN PLACE with the reason in each file, and FOUR OF THE RE-POINTS ARE
  INVERSIONS**: test_batch_bo's and test_batch_bp's "every class pool is EMPTY" became "the Mage
  and Cleric ones are FILLED at six, the other two still owed"; test_batch_bo's "a thin pool
  fills SHORT" now measures a Mage at three AND a Hunter at two, because the fill-short rule has
  to be measured where it still bites; and its "the next offer is empty" became "the next offer
  cannot re-present a DECLINED card", which is what that check was always asking (it read
  `.is_empty()` only because a Holy hero's whole draft used to be the two cards she declined).
· **test_batch_az's Follow-Through check was RE-POINTED AND IT WAS A REAL CATCH.** It greps
  battle.gd for the literal `- attacker.follow_through, 0)` to prove the counter is read
  ADDITIVELY, and extracting the four cooldown walks deleted that exact text. The question is
  unchanged; the fragment is `_tick_cooldowns(attacker, attacker.follow_through)` now. 519/0.
**GOTCHA THAT COST TWO BATTERY PASSES, AND IT IS THE HARNESS RATHER THAN THE SUITE: ZSH DOES NOT
WORD-SPLIT AN UNQUOTED PARAMETER.** A battery script holding `FLAGS="--fixed-fps 12"` and passing
`$FLAGS` hands Godot ONE argument, which it ignores — so test_batch_bl ran at the default frame
step, its real-play battle never finished, and **four ledger checks failed in a way that reads
exactly like a suite fault** (88/4 in both passes, 88/0 on five standalone runs including one
replaying the whole battery order before it). Use an ARRAY (`FLAGS=(--fixed-fps 12)` /
`"${FLAGS[@]}"`). Confirmed by reproducing the 88/4 on demand with the broken quoting.

BATCH BP (08-13) — THE WARRIOR DRAFT POOLS. **Six abilities, two per Warrior spec, closing the
debt BO left open: all three Warrior draft pools were NAMED AND EMPTY, so one of four heroes in
every party had no draft at all.** Nothing else ships — no talent node, no magnitude, no existing
ability changed, no save version moves (still v10). **THE 24 CLASS-WIDE ABILITIES ARE STILL OWED**
and `CLASS_DRAFT_POOLS` is still empty and still says so. The arriving-stance principle is the
standing rule directly above; this block is the content, the decisions and the verification.
**THE SIX, WITH THEIR AXES.** `SPEC_DRAFT_POOLS` is 24 entries now (was 18); the defs are in
`Classes.draft_ability` beside BO's, resolved at the top of `pool_ability` as before.
· **Berserker — BLOOD OFFERING** (0 Rage, 1.5, 3cd, self): loses **20% of CURRENT health**, gains
  40 Rage (perfect 60). *Axis: buying the frenzy band on purpose.* **PERCENT OF CURRENT, NOT
  MAXIMUM, IS THE WHOLE SAFETY ARGUMENT** — it can never reach 0 and its absolute cost SHRINKS as
  he drops, which is correct for a spec that wants to live low rather than die low. **The health
  is removed DIRECTLY rather than through `take_hit`**: this is a price he pays, not a wound
  anyone dealt, and the damage path would have fed Blood Price, the recap's damage-taken ledger
  and every on-damage rider with an event that had no attacker.
· **Berserker — GUT RIP** (30 Rage, 2.5, 4cd, one enemy, 20 BD): **bleeds the target out at once**
  whatever its buildup, plus 6% of Attack per 10 points consumed (perfect 9%). *Axis: the bleedout
  stops being the enemy's clock* — Bloodcraze, Scent of Blood, Arterial Spray and Blood Tithe were
  four nodes waiting on a trigger he could not pull. **IT FIRES THE REAL BLEEDOUT PATH AND THAT IS
  THE LOAD-BEARING LINE**: the meter is topped up to 100 through `_add_bleed_with_burst`, not
  copied into the ability, so every talent that reads a bleedout sees this one — **SLAUGHTERHOUSE
  INCLUDED, which leaves the meter at 50 rather than 0**, so a second Gut Rip four turns later has
  half a wound waiting. A private burst is the one thing that would have made the ability do
  nothing for the lane it exists to serve.
· **Swordmaster — PRECISION STRIKE** (20 Rage, 2.0, 3cd, one enemy, **then switches stance**):
  from Aggressive, TWO strikes at 20% of Attack (6 BD each) plus **+25% parry for 3 turns**; from
  Defensive, ONE strike at 15% with **15 BD** plus **his attacks bypass ALL armor for 3 turns**
  (status `open_guard`). *Axis: the same blade, two intentions.* **ARMOR IS BYPASSED OUTRIGHT
  RATHER THAN PENETRATED BY A PERCENTAGE** — `pen` is a fraction OF the target's armor, so a
  percentage clause would be "+50% of zero" against every unarmoured enemy in the game, i.e. the
  exact dud AP §3's eligibility rule exists to prevent. It reuses the EXISTING bypass hook that
  Held Breath and Through and Through already ride.
· **Swordmaster — FEINT** (25 Rage, 2.0, 4cd, one enemy, **then switches stance**): from
  Aggressive, a 35% strike (12 BD) and **that enemy's next attack lands on one of its own allies**
  (status `feinted`); from Defensive, **no strike at all** and **2 charges** (perfect 3), each
  parrying a blow outright and dealing its damage to the attacker (`feint_guards`). *Axis: their
  swing lands somewhere they did not intend.* **CHARGES, NOT TURNS** — both halves wait until
  SPENT, so a Feint cast into a lull is not wasted and cannot be dodged by an enemy simply not
  swinging that turn.
· **Warden — COVERING GUARD** (25 Rage, 2.5, 4cd, one ALLY): for 3 turns **HIS Block chance is
  rolled against attacks aimed at that ally and a success NEGATES the attack entirely.** *Axis:
  his stat protecting someone else.* **THIS IS NOT REDIRECTION — NOTHING MOVES TO HIM**; the blow
  stops, which is what Block does and what nothing else in the game does. **IT READS HIS LIVE
  BLOCK CHANCE** (`_live_block_chance` / `_plating_slice`, extracted from the block roll so the
  two can never read different numbers), so Shieldwall, Heavy Plating's climb and Bulwark Line all
  feed a ward laid turns earlier — **a snapshot at cast time would have read exactly like the
  ability working while being quietly worse than the card.** Its own SLICE and its own LABEL in
  the roll, for Bulwark Line's reason: Tenacity and Rally test for "Heavy Plating" and must not
  fire off a covered ally's block. **A DEAD WARDEN COVERS NOBODY** (`_covering_warden` re-resolves
  the stamped `src_name` live — his body is the ward).
· **Warden — EYE OF THE STORM** (20 Rage, 2.0, 4cd, self): **taunts EVERY enemy for 2 turns** and
  he takes **8% less damage per enemy taunted**. *Axis: being outnumbered becomes the point.*
  Self-balancing by construction. The mitigation reads the number ACTUALLY TAUNTED rather than the
  number alive, and **its governor is MAX_FIELD (six bodies) rather than a cap of its own**.
  **FLAGGED AS POSSIBLY TOO STRONG AND SHIPPED UNTUNED, on the brief's explicit instruction:
  watch it in play, do not pre-tune it.**
**BREAK DAMAGE WAS ASSIGNED DELIBERATELY RATHER THAN BY OMISSION** (BO's own correction, applied
up front — the brief named only Precision Strike's Defensive 15). Constants live together beside
`SHIELDWALL_BLOCK`. **Precision Strike Aggressive 6 A STRIKE = 12 across two, DELIBERATELY BELOW
the Defensive branch's 15** — the Defensive branch is the one whose card names Break as its own
clause, so the Aggressive branch pays in damage and parry instead and must not also win on Break.
**Feint 12**, below both and well below Overpower's 20 / Pommel's 30. **Gut Rip 20**, in line with
Bloodlust's 18 and Crushing Blow's 20. **Blood Offering / Covering Guard / Eye of the Storm carry
NONE** — they are not attacks, and Break from an ability that never strikes is Break from nowhere.
**TWO ADJACENCIES FLAGGED BY THE BRIEF, AND A THIRD THE BATCH FOUND:**
· **THE REDIRECT vs THE OCCULTIST'S MADNESS LANE — distinguished STRUCTURALLY, not by
  assertion.** Feint takes ONE named attack and nothing else: no status on the victim, no Daze, no
  Ruin, no persistence, and the enemy still CHOSE its own action and still spends its own turn.
  Bewitch/Psychosis/Hysteria take the TURN and are counted as `_intent_hijacked` for that reason;
  the redirect HONOURS the declaration, so it is deliberately NOT counted as one. **The brief's
  fallback (a straight miss instead of a redirect) was not needed and was not taken.** Its site is
  BELOW `_revalidate_intent` in `_enemy_turn`, so what is redirected is the blow actually about to
  land; it redirects ATTACKS only (a mender's heal is not a swing to misdirect), and with no living
  fellow the mark **HOLDS rather than being spent** and says so in the log.
· **THE DEFENSIVE CHARGES vs RIPOSTE** — they resolve cleanly: a Feint charge IS a parry, so
  Riposte answers it once and the reflect fires once. Nothing double-counts.
· **THE CLOSER NEIGHBOUR IS WAITING GUARD** (Poise row 8, up to 3 banked guaranteed parries), and
  the batch found it rather than the brief naming it. Distinguished by the REFLECT, which only
  Feint's charges carry, and by the ORDER: **the RENEWABLE bank spends first.** Waiting Guard
  re-banks every turn he goes undamaged while a Feint charge costs 25 Rage and a turn, so spending
  the free one first preserves the paid one — the same argument that already put Waiting Guard
  BEFORE the parry roll, extended one step.
**FEINT'S REFLECT READS THE NOMINAL HIT, AND THE REASON IS STRUCTURAL RATHER THAN A SHORTCUT.**
The charge is an ABSOLUTE parry (it joins `wall_parry`), because "its damage is dealt to the
attacker INSTEAD" only reads as a redirect if none of it also lands on him — so the number cannot
come from `final`, which the parry is about to zero. It is the nominal hit through his armor,
which is **Batch W's own idiom for exactly this question** ("what the blocked swing would have
carried"; variance, crits and riders cannot be known for a hit that was never rolled).
**`feinted` IS DELIBERATELY NOT IN `DEBUFF_IDS`**, joining `covenant`/`quarry`/`snare_line` for
the same reason and one more: it is a MARK, and it waits until spent, i.e. battle-long, which
`_cleansable_debuffs` reads as 999 turns remaining — **a mender's longest-first pick would have
taken it EVERY time**, the exact fault AS carved the Glacial Hold out for.
**NEW UNIT-SIDE STATE: ONE FIELD.** `feint_guards` (a count plus a chip, exactly like
`banked_guards` beside it, and deliberately NOT folded into it — only one of the two reflects).
The other five abilities are carried entirely by STATUSES (`open_guard`, `feinted`, `feint_guard`,
`covering_guard`, `eye_storm`), which is the cheaper answer wherever an effect has a duration and
a chip: they expire by themselves and cannot leak past a battle.
**COVERING GUARD IS FOR SOMEONE ELSE, AND THAT IS STRUCTURAL RATHER THAN A TOOLTIP WARNING** —
THREE SITES, ONE RULE: the player's ally picker filters him out (Execute's precedent), the bot's
pool filters him out, and `_ability_usable` refuses the cast outright when he is the last one
standing. He already rolls his own Block; warding himself would stack a second copy of it.
**REPORTED NOT ACTED ON — A NAME COLLISION, AND IT IS WORSE THAN BO'S.** **PRECISION STRIKE** sits
one letter from **PRECISION STRIKES**, a Swordmaster talent node (Blade row 4), and unlike Second
Wind (a Berserker node against a Holy ability) **THESE TWO ARE IN THE SAME SPEC**, so a player
building a Swordmaster meets both. It is a LABEL collision only — a node's name is not an ability
name, nothing resolves it, the fields are separate (`precision_ranks` vs the `precision_strike`
special) — so nothing breaks. Shipped as specified and flagged on the Second Wind / Shared Vigil /
Overkill precedent: renaming either is the designer's call and one string.
**VERIFIED — AND PER THE STANDING INSTRUCTION, THAT MEANS THE CODE LANDED AND WORKS. NO SWEEPS,
NO BANDS, NO BALANCE MEASUREMENT WAS RUN, and none should be quoted from this batch.**
check_parse 0 · check_flow 0 (11 screens) · check_map_screen OK · run-harness gates 1/2/3 PASS ·
**NEW test_batch_bp.gd 260/0**. All five clauses §7 named as able to silently do nothing are
driven live and asserted against the state they change, never against a cast returning; **three
are built so a broken implementation still fails** (Blood Offering's cost as an exact identity at
two health levels — the floor of 1 keeps him alive under a MAX-health reading too, so only the
COST discriminates; Covering Guard's ward laid while his Block is ZERO and Shieldwall raised
AFTERWARD, the Null Field construction; and Feint's charges asserted SPENT by a real blow, since
"they persist" is trivially true if nothing ever attacks him).
**TEN NEGATIVE CONTROLS, each applied to product code and reverted** (battle.gd came back
byte-identical by hash): Blood Offering on MAXIMUM health **trips 3**; Gut Rip writing a private
burst **trips 3**; the arriving-stance principle inverted **trips 4**; Covering Guard snapshotting
the Block chance **trips 1**; Feint's charges on a clock **trips 4**; Eye of the Storm flat rather
than per-enemy **trips 1**; a Feint charge no longer absolute **trips 1**; the redirect never
firing **trips 3**; the ally pool no longer excluding the Warden **trips 1**; a self-ward becoming
a second slice of his own roll **trips 1**.
**ONE OF THEM FOUND A FAULT IN THIS BATCH'S OWN CODE AND IT IS THE WHOLE REASON TO RUN THEM:
EYE OF THE STORM'S MITIGATION WAS WRITTEN THREE TIMES IN SIX LINES** — the apply, the chip text
and the chip's power — **and the chip's power silently WON**, so a wrong figure in the apply was
unobservable and the negative control that broke it PASSED. Repaired with a local (`es_cut`): one
place decides. **The general rule this project keeps re-learning in new places: a number written
twice is a number that will eventually disagree with itself.**
**LIVE AUTOPLAY CLEAN ACROSS FIVE REAL BATTLES, 0 SCRIPT ERROR, ALL SIX FIRING IN ORDINARY
FIGHTS** — "Blood Offering — spends 35 health for 40 Rage (now 140 HP)"; "Gut Rip — Orc Archer
bleeds out on 50 buildup" followed by the REAL bleedout and Slaughterhouse re-seeding to 50;
"Precision Strike from the Aggressive guard — two cuts at 20% and +25% parry for 4 turns" then
"the guard changes — he comes up Defensive"; and **"Orc Archer swings at the opening and finds
Orc Chief instead (Feint)"**. **A log line naming the ARRIVING guard was added to both stance
cards during the smoke** — without it the switch was visible only as a float, and the switch is
the feature.
**THE MASTER.HTML STAMP GATE IS DUPLICATED FOUR TIMES, NOT THREE** — test_batch_ah, test_batch_bb,
test_batch_bn **and a fourth copy inside test_batch_bo** — and all four must move together or a
batch that bumps the timestamp trips suites it never touched. Correct BO's own note, which says
three.
**FOUR SUITES RE-POINTED IN PLACE with the reason in each file, and THREE OF THE RE-POINTS ARE
INVERSIONS** (the honest treatment when a batch pays a debt an older suite was recording):
test_batch_bo's "eighteen ship" → twenty-four, its "a Warrior's pool is EMPTY" → "a Warrior drafts
two of its own", and its "a Warrior's offer is empty and awarding one returns false" → "a Warrior
gets a REAL offer and a REAL owed pick". **The setups are byte-identical, because they are still
what tells the two answers apart.** **test_batch_bo reads 492/0** (was 449 — the count rose
because its pool loops walk every entry and six arrived).
**ZERO DRIFT EVERYWHERE ELSE**: ah 5500, ah_battle 65, ai 2217, aj 418, ak 528, al 560, ar 914,
as 396, at 470, au 336, av 324, aw 350, ax 338, ay 484, az 519, ba 689, bb 172, bc 91, bd 69,
be 34, bf 78, bg 47, bh 233, bi 88, bj 67, bm 1890, bn 77, bo 492, bp 260, runes 2973,
rune_battle 96 — all 0 failures. **an reads 3618 and bk 129, both inside their DOCUMENTED
run-to-run drift** (an 3614-3624; bk ±1 by construction) — neither is pinned and neither should
be. **TWO KNOWN FLAKES each reproduced ONCE in the battery and passed on a clean re-run**:
test_batch_at's Arcane Cannon check (recorded since AV) and test_rune_battle's
`rune_resist_pierce` check (diagnosed in BC — the forced hit still rolls the 5% miss). **Neither
is on this batch's path.**
**THE DESIGNER HAD NO RUN IN FLIGHT and none was created**; profile.json, relics.json and
trees.json are byte-identical after the battery.

BATCH BO (08-13) — THE ABILITY DRAFT, AND TRANCHE 1. **§1-§4 build the draft machinery, §5
authors the first tranche of content into it** — machinery first, because the schema decides
what an ability has to carry. **The machinery is the standing reference directly above; this
block is the content, the corrections and the verification.** No save version moves (still v10);
no talent node, no magnitude and no existing ability changed.

§5 **EIGHTEEN SHIP, NOT TWENTY-FOUR, AND IT IS SAID PLAINLY RATHER THAN LEFT AS A GAP** — six
MAGE, six CLERIC, six HUNTER. Full table in the changelog and in master.html §6b; the pools are
`Classes.SPEC_DRAFT_POOLS` and the defs `Classes.draft_ability`, a plain match hooked in at the
TOP of `pool_ability` so a drafted ability resolves everywhere an earned one already did.
**Pyromancer** Cinderfall / Ember Debt · **Cryomancer** Winter's Toll / Rimebinding ·
**Arcanist** Null Field / Kindled Mind · **Holy** Second Wind / Rite of Return · **Devout** Vow
of Suffering / Aegis Reversal · **Occultist** Blight the Well / Covenant of Ash ·
**Beastmaster** Twin Hunt / Call the Wilds · **Sharpshooter** Called Volley / Quarry's Mark ·
**Survivalist** Choking Smoke / Snare Line.
· **ONE NUMBER PER ABILITY IS THIS BATCH'S RATHER THAN THE BRIEF'S: BREAK DAMAGE.** §5
  specifies cost, initiative, cooldown, target and effect for all eighteen and says nothing
  about `pressure` — exactly as AT's brief said nothing about Death Ray's, and that omission
  became a thread three batches long. The two that are ordinary attacks carry BD in line with
  their siblings (Cinderfall 8, Called Volley 8, Kindled Mind 6, Twin Hunt 12); the rest are
  not attacks and carry none. **Flagged, not buried.**
· **NEW UNIT-SIDE STATE, one read site each**: `ember_debt` (on the ENEMY), `aegis_bonus`,
  `free_ability` (a COUNT, the `free_summons` shape), `dmg_by_turn` + `battle_turn`, and three
  callbacks — `vow_cb`, `blight_cb`, `rite_cb`. The callbacks exist for the reason every other
  one in unit.gd does: an effect that has to reach ANOTHER unit hands the number back to
  battle.gd rather than reaching across. **`blight_cb` is the load-bearing one**: dealing the
  damage inside `heal_amount` would kill a unit at a site that cannot reach `_on_enemy_death`,
  so every payoff of that kill would silently not fire.
· **`_drain_burn_turns` WAS A SECOND DENOMINATOR — DELETED BY BATCH BS §2 ALONG WITH THE BILL
  IT SERVED, and Ember Debt was RE-AUTHORED rather than left holding a dead clause.** BO's
  argument was that the exemption gap IS the ability and collapsing the two functions deletes
  it; BS deleted the DRAIN, so there was no bill to be exempt from and the gap closed by itself.
  `BattleUnit.ember_debt` went with it. See the BS block for the card's new axis.
· **RITE OF RETURN GOES FIRST in `_holy_reversal`**, ahead of Intercession and Martyrdom, and
  it is AV's own ordering argument taken one step further: the more specifically bought and the
  shorter-lived a refusal is, the sooner it should spend. It was cast on THIS ally by name,
  holds 3 turns and is already paid for.
· **VOW OF SUFFERING SITS DIRECTLY BELOW THE BARRIER BLOCK in `take_hit`** and that position is
  load-bearing: a Divine Shield is the Devout's own work and must eat first, so the vow
  relocates half of what GETS THROUGH. Above the barrier he would pay twice for one hit. It
  returns the share ACTUALLY billed, so a vow with nobody left to carry it costs the ally
  nothing rather than deleting half a wound.
· **WINTER'S TOLL ADDS NO UNGOVERNED METER — CHECKED, NOT ASSUMED.** It reads `hold_turns`,
  which `_hold_sync` already clamps at `SHATTER_TURN_CAP` (12), so the same governor Shatter
  rides bounds it. It is deliberately NOT routed through `_hold_release` (the Cryoclasm
  precedent), so no release payoff fires and the prison stands.
· **COVENANT OF ASH'S RECURSION IS BROKEN BY IDENTITY, NOT BY A FLAG**: the mirror is the last
  thing `_gain_ruin` does, the mirrored stacks land on the BEARER, and a stack landing on the
  bearer finds `mirror == target` and stops. One covenant exists at a time (the cast clears the
  field first), so there is no chain to guard.
· **CHOKING SMOKE USES THE EXISTING BLIND** and the miss stacking was READ rather than assumed:
  `_miss_chance` is `MISS_CHANCE 0.05 + 0.20 (dazed) + 0.50 (blind)`, **flat percentage POINTS,
  never a multiplier**, with `no_cover` bypassing the whole function. And **AoE ATTACKS ROLL NO
  MISS AT ALL** — the single-target branch is gated `not ab.aoe` and the per-strike roll only
  fires for multi/random/choose-N — so Blind blanks single-target blows only, which is what
  prices a field-wide 50%.

§5 **TWO PREMISES IN THE BRIEF WERE STALE AND ARE CORRECTED TOWARD THE CODE, not quietly
reinterpreted** (the AR §6 / AX §7 / BD §3 / AY §1 precedent):
· **A SWAP HAS NEVER COST LOYALTY, so Call the Wilds' stated reason is wrong.** §5 says the
  Loyalty loss is why BJ measured swaps at 0.05 per trash battle. Loyalty lives on the HUNTER's
  own dict and is written in exactly four places, **none of them a swap** — only a beast's
  DEATH breaks the meter (`_on_beast_death`) and only Primal Surge spends it; `_free_beast`
  does not touch it. What a swap actually costs is a TURN and the shared 3-turn Swap cooldown.
  **THE ABILITY SHIPS AGAINST THE REAL TAX**: it erases the shared cooldown and the arriving
  beast strikes immediately, and the Loyalty half is kept as an EXPLICIT guarantee (asserted at
  the site and in the suite) rather than dropped, because it is what the card promises and a
  later batch could make it false.
· **CALLED VOLLEY'S CLAUSE IS TRUE BUT IT IS NOT A DISTINCTION.** The Focus engine has been
  gated `not ab.aoe` since AZ, so **NO AREA ATTACK HAS EVER CLEARED FOCUS**; §5's supporting
  line ("every other multi-target option costs him his meter") does not survive reading the
  code either — `choose_two` and `multi_hits` abilities call the engine against their PRIMARY
  target and cost nothing when that is already his mark. Shipped as specified, and what the
  batch buys is that the guarantee is now NAMED and TESTED (`_focus_safe`) instead of being a
  side effect of one condition in an unrelated branch.

§3 **TWO DECISIONS THE BRIEF DID NOT MAKE, REPORTED RATHER THAN BURIED.** (a) **ONE HERO PER
ELITE, drawn at random and independently of the rune looter** — §3 says "always, on victory"
and not to whom, and offering every hero a card at every elite would hand out ~26 picks a run
against four draftable slots, which is not a draft. (b) **THE MERCHANT'S PRICE, 120 / 180 / 240
by zone**, deliberately below the blacksmith's 150/225/300: the smith buys a permanent upgrade
to something you already hold and BK measured it converting 41-47% of ALL run income, so an
ability is the cheaper, more frequent question.

§5 **REPORTED NOT ACTED ON — A NAME COLLISION THIS BATCH CREATED.** **SECOND WIND** is also the
Berserker's `bz_bloodied_hide` talent node (Warpath row 5, "the first drop below 25% grants 60
Rage"). **It is a LABEL collision only** — a talent node's name is not an ability name, nothing
resolves it, `BattleUnit.second_wind` is the Berserker's field and the ability's special is
`second_wind_holy` — so nothing breaks. It is shipped as specified and flagged, on the AV
Shared Vigil / AJ Overkill precedent: renaming either is the designer's call and one string.

§5 **THE BOT: ONE HOOK, NOT NINE ROTATIONS.** Every spec's rotation is hand-authored and names
its own kit, so a drafted ability would never be cast at all — and a spec whose new cards never
fire is a spec no sim and no live autoplay can verify. `_autoplay_pick` now wraps
`_autoplay_pick_kit` and substitutes a usable drafted ability **only when the real rotation came
back with the free basic attack**, i.e. when the bot had nothing it wanted to do anyway.
**IT RE-WEIGHTS NO EXISTING ROTATION, so no measurement taken before this batch stops being
comparable.** It is NOT a policy for playing these abilities well; that is each ability's own
tuning pass, in play.

§7 **VERIFIED — AND PER THE DESIGNER'S STANDING INSTRUCTION FROM THIS BATCH ONWARD, THAT MEANS
THE CODE LANDED AND WORKS. NO SWEEPS, NO BANDS, NO BALANCE MEASUREMENT WAS RUN, and none should
be quoted from this batch.** check_parse 0 · check_flow 0 (11 screens) · 13 scenes 0 SCRIPT
ERROR · check_map_screen OK (three positions, both overlays) · run-harness gates 1/2/3 PASS ·
**NEW test_batch_bo.gd 449/0, stable 4/4**.
**ALL EIGHT OF THE CLAUSES §7 NAMED AS ABLE TO SILENTLY DO NOTHING ARE DRIVEN LIVE** and
asserted against the state they change, never against the cast returning. **THREE OF THEM ARE
BUILT SO A BROKEN IMPLEMENTATION STILL FAILS**: Winter's Toll's "the hold continues" is
trivially true of an ability that does nothing, so the DAMAGE is asserted beside it; Null
Field's "reads current stacks" is trivially true of a cast-time stamp, so the SAME field is
measured at two different stack counts; Call the Wilds' "keeps Loyalty" is trivially true if no
swap happened, so the beast on the field is asserted to have CHANGED.
**EIGHT NEGATIVE CONTROLS, each applied to product code and reverted** (the three touched files
came back byte-identical by hash and the suite to 449/0 after the last): a protected ability
made droppable **trips 7**; Ember Debt's two denominators collapsed into one **trips 1**; Null
Field frozen at cast time **trips 1**; a decline that does not write the no-return ledger
**trips 3**; an offer padding with repeats instead of filling short **trips 3**; Winter's Toll
routed through `_hold_release` **trips 2**; an enabler moved into its own spec's draft pool
**trips 2**; and **Rite of Return billing its toll before restoring the health trips 2** — that
last is the control for the batch's one genuinely subtle ordering, below.
**ONE EDGE FOUND BY REVIEW RATHER THAN BY A TEST, AND IT IS THE ORDERING `_on_rite_return` IS
WRITTEN AROUND: HOLY CAN SWEAR THE RITE ON HERSELF.** Her 30% toll runs `take_tick_damage`,
which re-enters `_holy_reversal` — so the promise must be SPENT before the bill (or it answers
its own toll forever) and the health RESTORED before it (or the toll is billed against zero and
`_die` marks her dead one line before the restore would have run). That is why this reversal's
handler performs the restore while Intercession's and Martyrdom's do not; the deviation is
deliberate and the suite drives the self-save case.
**SCRATCHPAD, NOT COMMITTED (the AQ check_aq.gd precedent): check_bo.gd 27/0** drives the DRAWN
half test_batch_bo cannot see — the `◆ 1 draft` badge on a real map card, the CHOOSE button
naming the draft, the overlay's slot ledger and Decline button and short-offer note, the DROP
step listing only earned abilities (and never a protected one), and the merchant's counter
refusing a Warrior's empty pool rather than taking the gold.
**LIVE AUTOPLAY CLEAN across three real battles, 0 SCRIPT ERROR**, with six of the eighteen
firing in ordinary fights (Vow of Suffering, Null Field ×3, Kindled Mind, Blight the Well,
Choking Smoke) — e.g. "Devout: Vow of Suffering — half of Berserker's wounds come to him for 4
turns [PERFECT]". **A `--run 6` was walked ONLY to exercise RunSim's elite path** (8.00
offers/run, 7.50 cards shown, 4.67 taken, 4.67 short offers, 3.33 nothing-left-to-offer — the
expected shape of a thin pool); **its Matrix row is NOT a difficulty reading** and none is
quoted. profile.json / relics.json / trees.json byte-identical afterwards; no run_save.bin was
created and the designer had none in flight.
**FULL BATTERY GREEN**: ah 5500, ah_battle 65, ai 2217, an 3614, aj 418, ak 528, al 560, ar 914,
as 396, at 470, au 336, av 324, aw 350, ax 338, ay 484, az 519, ba 689, bb 172, bc 91, bd 69,
be 34, bf 78, bg 47, bh 233, bi 88, bj 67, bk 130, bm 1890, bn 77, bo 449, runes 2973,
rune_battle 96 — all 0 failures except AL's standing flake below. **ZERO DRIFT FROM THIS BATCH,
AND IT WAS MEASURED RATHER THAN ASSUMED**: ar / ai / aj / ak / al / bm / bk were re-run on
STASHED, UNMODIFIED HEAD and read the same counts to the check.
· **THE SUITE-COUNT LISTS IN THE OLDER BLOCKS BELOW ARE STALE, AND THEY WERE STALE BEFORE THIS
  BATCH** (BI's list says ah 5587, an 6053, ar 887, ai 2036; HEAD reads 5500 / 3614 / 914 /
  2217). BK, BM and BN moved them without updating that list. The line above is the current one.
· **FOUR SUITES RE-POINTED IN PLACE, with the reason in each file.** THREE OF THEM ARE THE SAME
  ASSERTION: the master.html STAMP GATE is duplicated in test_batch_ah, test_batch_bb AND
  test_batch_bn, and **all three must move together** or a batch that bumps the timestamp trips
  two suites it never touched. The fourth is test_batch_ar's `_overburn_refund` call-site count,
  **2 -> 3, INVERTED IN SPIRIT RATHER THAN DELETED**: the question — does every Burn consumer
  share the one implementation — is still worth asking, and Cinderfall inheriting it is AR's own
  rule working. A fourth consumer has to come and say so, which is the point of pinning a count.
· **KNOWN-BAD, NOT OURS, AND REPRODUCED ON UNMODIFIED HEAD: test_batch_ah AND test_batch_an BOTH
  CALL `Run.award_talent_points`, WHICH BATCH BM DELETED.** Each throws a SCRIPT ERROR that
  ABORTS ITS OWN FUNCTION while the suite still prints "0 failures" — exactly the trap BC
  documented. **Both suites have therefore been silently under-testing their reward sections for
  two batches.** Not repaired here (it is BM's thread and repairing it is authoring new
  assertions about a talent economy that no longer exists), but it should not go unrecorded
  again. test_batch_an's total also DRIFTS ~3614-3624 run to run on HEAD and on this build
  alike — never pin it.
· **test_batch_al's standing "Spite reflects damage at the attacker" FLAKE reproduced once in
  four runs**, as recorded since BI/AQ. Nothing in this batch is on the Warden's path.
· **ONE FLAKE OF THIS BATCH'S OWN WAS FOUND AND FIXED IN THE TEST, NOT WORKED AROUND**: the
  Snare Line coverage check failed ~1 run in 3 against working code, because the battle's turn
  loop advances on real timers while the suite drives `_resolve` by hand (the AQ harness race) —
  and the line SPRINGS AND REMOVES ITSELF at an enemy's turn start, leaving nothing observable
  (the stun it lands is consumed by the same turn that sprang it). The enemies' clocks are
  pushed out so none takes a turn during the check. **Forced determinism, not a retry.**

BATCH BN (08-13) — THE CRASH, AND THE GATE. Two items, both blockers, neither large. **§1 is
a bug fix. §2 is one float, chosen by measurement rather than by guess.** No save version moves
(still v10); no node, no magnitude and no ability changed.

§1 **THE `_hold_release` / `_hold_freeze` RECURSION IS CLOSED — see the entry under "Known open
threads", where the MECHANISM IS KEPT after the fix on purpose.** The guard is the only thing
preventing it and a later batch would delete it for looking redundant. Short version: a release
comes back on `HOLD_RELEASE_STACKS` (1) and Honed Shards applies 3 — exactly the 4 that
flash-freezes — while a freeze past `_hold_limit()` evicts the oldest prison, which is itself a
release. At a Thaw-lane limit of 1 the two are a **two-body cycle** that runs to GDScript's
stack limit.
· **THE FIX IS A RE-ENTRANCY GUARD, NOT A MAGNITUDE CHANGE: `var _releasing`, set at the top of
  `_hold_release` and cleared at its end, and `_hold_freeze` early-returns while it is set.**
  Cutting Honed Shards' 3 or the release's 1 to dodge the threshold would nerf a node to work
  around a control-flow bug; every authored magnitude is untouched and asserted so.
· **THE FLAG IS BRACKETED BY A WRAPPER AND THAT IS LOAD-BEARING**: `_hold_release` sets it,
  calls the new `_hold_release_body`, clears it. GDScript has no `finally`, the body already
  carries an early return (a dead target), and **a flag left standing refuses every freeze for
  the rest of the battle** — a softer failure than the crash and just as fatal. ONE setter, ONE
  clearer, both asserted by count.
· **IT ALSO CLOSES THE MILDER VERSION THAT WAS NEVER A CRASH: Ice Lance releasing a hold and
  instantly re-taking it**, which made the release read as a no-op. That is the behaviour the
  code comment beside Honed Shards has always described, and it was accurate.
· **NO RE-ARM IS NEEDED, AND THIS WAS READ RATHER THAN ASSUMED (§1's own instruction).** The
  flash-freeze threshold is **`status_stacks("chilled") >= 4`** — it reads BEING at four, not
  REACHING four — and chilled stacks clamp at 4 in `add_status`, so **an enemy parked at the cap
  with its freeze refused is frozen by the very next chill.** An `== 4`-style reach check there
  would leave enemies permanently unfreezable, which would be worse than the crash and silent;
  test_batch_bn drives the re-arm live and a negative control builds the reach-based version.
· **CRYOCLASM IS UNAFFECTED, ASSERTED BOTH WAYS.** It MOVES a hold and is deliberately not
  routed through `_hold_release` (so no release payoff fires), so the guard is never up when its
  freeze runs. The check asserts the moved hold LANDS, not merely that it was un-refused — "the
  guard does not block it" is trivially true of an ability that does nothing.
· **WHAT IT UNBLOCKS, MEASURED: A THAW CRYOMANCER RUN BAND EXISTS AGAIN.** BG had to substitute
  Deep Freeze to get a band at all. `DOD_SIM_BUILDS="cryomancer:Thaw"`, rung 2, balanced:
  **25/25 runs, ZERO stack-overflow events**, completions 16%, depth 39.40 ±1.99 of 49.
  **THE MATCHED CONTROL ON UNMODIFIED HEAD REPRODUCES THE CRASH AND CANNOT FINISH: 305 overflow
  events and 20 MB of backtrace by run 6**, in the wall clock the fixed build spent completing
  all 25. (BG read 15 events and ~1.1 MB in four runs; a deeper run reaches more of it.)

§2 **RUNG 1'S MULTIPLIER IS x0.50, WAS x0.70 — SWEPT, NOT GUESSED. The table is the
deliverable; see the difficulty-ladder standing reference above for it and for the cliff
caveat.** Untalented completion, balanced route, n=100 a row: **x0.70 13% | x0.60 28% |
x0.50 83% | x0.40 95%.** Bands at n=100 are ±6.6 to ±8.8 points, tighter than every difference
that matters. **x0.70's 13% REPRODUCES BM's 12% at n=50**, which is the control that makes the
rest readable.
· **RUNGS 2 AND 3 WERE NOT TOUCHED. NEITHER MULTIPLIER MOVED, NEITHER TWIST MOVED**, and this is
  said explicitly because a batch that moved rung 1 is exactly where a later reader would assume
  all three moved. Rung 2 is still x1.00 — the present balance byte for byte, which is what
  keeps every BK-and-earlier row readable — and rung 3 still x1.30. test_batch_bn asserts both,
  plus both severity floors and the fixed-modifier flag.
· **RUNG 1 WITH ROWS 1-3 FILLED IS NOW TRIVIAL AND THAT IS CORRECT, NOT A PROBLEM** — rung 1 is
  meant to stop being a wall the moment a player has anything, because that is the signal to
  climb. BM measured that build at 52% under x0.70; at x0.50 it reads **96% (n=100, balanced; depth 47.74 of 49)**.
  Recorded so it is on the record, not tuned.
· **THE 0% AT RUNG 2 IS NOT ADDRESSED HERE AND MUST NOT BE PAPERED OVER BY MOVING A RUNG.** BM's
  diagnosis stands: the ladder's power ratio is a clean monotone 1.26 / 0.91 / 0.67, so the
  LADDER is fine and the TREE is uneven — a capstone is worth more than the eight lane nodes
  beneath it put together (8 picks 8%, 9 picks 68%). That is a distribution problem and it is
  the next batch's, together with the leave-one-out grid owed on Harmonic Convergence.
· **THE CONSEQUENCE NOBODY ASKED FOR, REPORTED RATHER THAN DISCOVERED: `DOD_SIM_DIFFICULTY`
  DEFAULTS TO RUNG 1**, so **every run band taken without the flag since BM is a rung-1 band**,
  and BN moved rung 1. A row meant to compare against a pre-BM baseline must set
  `DOD_SIM_DIFFICULTY=warden` explicitly. sim.sh's header and both flag tables say so now.

VERIFIED: check_parse 0 · check_flow 0 (11 screens) · run-harness gates 1/2/3 PASS ·
**NEW test_batch_bn.gd 77/0**. **ONE SUITE RE-POINTED IN PLACE AND IT IS AN INVERSION**:
test_batch_as's "...which is four again, so the release re-holds it on the spot" is now "...and
BN's guard stops those four re-freezing it on the spot", with the reason in the file — the
question is still worth asking, only the correct answer moved. **test_batch_as reads 396/0 both
before and after, i.e. ZERO DRIFT** (and CLAUDE.md's older "as 387" figure was already stale;
396 is what unmodified HEAD reads).
**FOUR NEGATIVE CONTROLS RUN, each applied to product code and reverted** (battle.gd came back
byte-identical, verified by hash): **clearing the guard before Honed Shards applies RESTORES THE
CRASH — 11 checks trip and the suite spews stack overflows**; **the guard also blocking
Cryoclasm trips 4**; **a REACH-based threshold (freeze only on crossing into 4) leaves a parked
enemy permanently unfreezable and trips 4**; and **the wrapper's clear deleted, i.e. the flag
leaking, trips 10**.

BATCH BK (08-12) — THE BRANCHING MAP. **SAVE v8, AND A PRE-v8 SAVE IS REFUSED AND
CLEARED** — the second save-breaking change in the project's history, not the first (AN
refused pre-v7 for the same class of reason, and the brief's claim that this would be the
first is wrong). A run is a GENERATED LATTICE again: 3 zones x 16 slots = **48 encounters**
(the brief says 49; 3 x 16 is 48, and its own "was 36" was 3 x 12 by the same construction).

**READ THIS BEFORE TOUCHING THE GENERATOR — WHAT BATCH AN ACTUALLY SAID.** AN did NOT delete
the old branching map for being decorative, and the 0%-choice figure was never a measurement
of it. AN was a SCAFFOLD batch: it wanted a playable end-to-end run to feel the pacing before
66 pieces of content were authored. The thing it named as needing deletion rather than repair
was **the edge-column adjacency rule, documented 70% / actual 53%** — a disagreement that
survived three batches because the code still resolved. The old map ALSO carried
`_ensure_key_route` / `_route_satisfied` / `_guarantee_inbound`: **it GUARANTEED that every
route reached the node types it was supposed to reach**, which is the exact opposite of this
batch's rule. BG's "0% of 2,764 steps" is AN's LINE, and AN kept that metric reporting a
permanent zero on purpose ("a missing figure reads as a broken instrument"). Never write that
AN's forks reconverged too fast; nobody ever measured them.

THE SHAPE (§1). Slots 1-7 branch 3 wide, slot 8 is the MINI-BOSS (every path converges), 9-15
branch again, 16 is the BOSS. 14 branching columns x 3 rows = 42 positions; pruning removes 2-3,
so a real zone holds ~39.7 nodes and columns are 2 or 3 wide (**84% are 3; NONE are 1** —
MIN_COLUMN forbids it). Entry: any of column 1's three nodes; the mini-boss opens all of
column 9 the same way, so each half starts with a free pick. **`map[slot]` IS AN ARRAY OF
NODES**, `{type, visited, row, next, enemies, theme}`, and `next` holds INDICES INTO
`map[slot+1]` (not row numbers — rows get pruned, indices do not shift). Position is the PAIR
`(slot_idx, node_idx)`. `advance(node)` still takes ONE arg and it is the NODE index;
`reachable()` returns node indices into the NEXT slot. `reachable_from(slot, node)` is new.

GENERATION RULES, one line each (`Run._generate_map`, edges first then types):
· every node has 1-3 edges in and 1-3 out (measured out-degree 59/37/4% for 1/2/3);
· an edge lands on the same row or an adjacent one;
· **paths never cross** — everything row i+1 reaches is at or below everything row i reaches;
· nodes with no way in or no way out are REMOVED to a fixpoint, but never below MIN_COLUMN=2;
· no elite in column 1; no two elites in ADJACENT COLUMNS (columns run 1-14 straight through
  the mini-boss, so elite -> MINI-BOSS -> elite is barred too); at most one of each non-fight
  type per column; every entry node reaches an elite and a trade node.
**NOTHING IS ROLLED AND RE-ROLLED.** Every legal edge assignment is enumerated and drawn
WEIGHTED (`FULL_COVER_WEIGHT` 3.0 favours a step that strands no row, `BRANCH_WEIGHT` 1.5
favours more edges — those two numbers ARE the feel of the map); elite columns come from the
standard non-adjacent-subset bijection, so an illegal spread cannot be NAMED. AN's severity
floor made the same call: a retry budget quietly starts failing when the table's shape changes.

MEASURED OVER 1500 GENERATED ZONES (`check_map.gd`, and test_batch_bk asserts the invariants
over 1000): nodes/zone 39.75 · widths 2:16% 3:84% · **foreclosure 2.23 columns** a node can no
longer reach · entry guarantee 0 failures of 4500 · reach-contiguity 0 failures · copies exact
at 6 elite / 6 blacksmith / 5 merchant / 5 event, fights the remainder (17.75).
**WALKED PER ZONE BY AN UNSTEERED ROUTE — this is §1's table, confirmed:** fight 6.25, elite
2.24, blacksmith 2.04, merchant 1.73, event 1.74, and every one of them ranges 0 to its full
copy count. **A ZERO-BLACKSMITH ROUTE HAPPENS 7.7% OF ZONES AND A ZERO-ELITE ROUTE 6.1%** —
that is §1's "no node type is guaranteed", measured, and it is the design.

DELETED, NOT LEFT UNREACHABLE (test_batch_bk and test_batch_an both pin absence):
`ZONE_SHAPE`, `roll_merchant`, `roll_event`, `MERCHANT_CHANCE`, `MERCHANT_FLOOR`,
`EVENT_CHANCE`, `slots_since_merchant`, `pending_after`, map_screen's `SLOT_X_START` /
`SLOT_X_STEP` / `_on_slot_pressed` / the three inline pick-row drawers. **THE MERCHANT AND THE
EVENT ARE MAP NODES NOW** — nothing rolls behind a cleared fight. THE ONE SURVIVOR is the
severity-4 bargain's "a merchant follows the fight", kept because it is BOUGHT rather than
rolled: one boolean `pending_shop`, not a queue.

§3 THE BLACKSMITH — THE GOLD SINK. `Run.roll_blacksmith_offer` / `buy_blacksmith` /
`blacksmith_price`, screen at scenes/blacksmith.tscn. 3 pairings, ONE HERO EACH, drawn through
AP §3's eligibility filter; **gold only**; **BLACKSMITH_PRICES = [150, 225, 300]** by zone;
buying ENDS the visit. **AP'S ONCE-PER-RUN RULE DOES NOT APPLY AND THE MECHANISM IS ONE FLAG:**
a bought entry is written into the same `member["upgrades"]` list (that is what makes it land,
wear its ◆ and hover like an awarded one) but carries `"bought": true`, and **`has_upgrade`
SKIPS bought entries**. `has_upgrade` has exactly one consumer — `roll_upgrade_offer`, i.e. the
MINI-BOSS PICK POOL — so without the flag, buying Honed in zone 1 would silently delete Honed
from that hero's mini-boss offers for the rest of the run. **THE FLAG IS READ IN THAT ONE
FUNCTION AND NOWHERE ELSE**; `apply_upgrades` stamps both kinds identically and
`roll_blacksmith_offer`'s never-twice-on-ONE-ABILITY check counts both, because that rule is
about the ability rather than about either pool.
PRICES CAME FROM BJ'S NUMBERS, NOT A GUESS: 2386 earned / 881 spent at 36 encounters = 1505
dead; x48/36 = ~2050; six visits at these prices = 1350.

§4 EVENTS ARE CONVERSIONS. Every entry in data/events.json carries `kind`; **the KIND is drawn
first at 60/25/15** (`Events.KIND_WEIGHTS`) and the weight inside it picks the entry, so
authoring a ninth boon does not make boons commoner. **20 events: 8 tradeoff, 8 boon, 4 bane.**
Every tradeoff has >=2 conversions AND a decline. **THE THREE KINDS SHARE ONE ICON AND ONE
COLOUR (???) and the map screen cannot see `kind` at all** — a node that announced itself as a
bane would never be walked onto. **NO BANE CAN TAKE A HERO BELOW 1 HP**, and that is a property
of the verbs (`damage_pct` floors at 1, `max_hp_pct` floors max at 10 and re-clamps), driven at
1 HP as the negative control. ONE NEW VERB: **`rune_grant`** (§4's own "health for a rune"),
routed through `Run.grant_rune`, equipped when a slot is free. **NOT WRITTEN and the reason
stands: "a held rune for two of lower rarity" needs a rune SURRENDERED, and nothing in the
project has ever removed a rune** — `equipped` has one writer and the pouch only grows.

§5 TIER SCALING — TWO DECISIONS, DIFFERENT ANSWERS, BOTH ON PURPOSE. **`Run.battle_budget` IS
RESCALED across 16 and BOTH ENDS ARE HELD** (`lo = 3 + floor((t-1) * 5/14)`): slot 1 still
opens 3-5, slot 15 still tops at 8-10, boss band untouched at 10-12. Keeping the old 0.5/slot
SLOPE would have run slot 15 to 10-12 and collided with the boss's own band — a structural
break, not a preference. Per-slot bands now: **3-5 3-5 3-5 4-6 4-6 4-6 5-7 5-7 5-7 6-8 6-8 6-8
7-9 7-9 8-10 10-12** (elite/mini-boss floor of 6 still applies in `compose`).
**THE ENEMY STAT LADDER IS NOT RESCALED**: battle.gd's `+2% attack / +2.5% HP per tier` is a
RATE, not a curve with endpoints, and it now runs to tier 16 — slot 16 reads **x1.40 HP /
x1.32 attack** against the old slot-12 top of x1.30 / x1.24. The party's own +2%-a-win ladder
gained the same four steps. `zone_base_mult` is UNTOUCHED (it reads the ZONE slot 1-3, never
the encounter slot).

§5 THE MAP SCREEN. 3-row lattice with DRAWN EDGES inside a `clip_contents` Control plus an
HScrollBar (`VIEW_X/Y/W/H`, `LAT_X0/X_STEP/Y0/Y_STEP`), left to right, **hero cards stacked
down the LEFT EDGE** at 300x152 (`CARD_X/CARD_Y/CARD_STEP`). `_map_scroll` is a member and
**starts NEGATIVE = "not placed yet"**: the first draw of a scene centres on the party's
column, every redraw after it holds where the player left it. **A NODE THIS ROUTE CAN NO
LONGER REACH IS DRAWN NEARLY OUT** (`Run.reachable_from`) — that is the only way a player sees
what a step cost, and it is the whole visual argument of the batch. The card lost 74px in the
move, so an owed pick is a **CHOOSE button opening a three-choice overlay**
(`_open_pick_overlay`, one implementation for ability/upgrade/rune) instead of three inline
rows. Card click still opens the hero SHEET (party.tscn) — §5 asks for "current talents (not
changeable mid-run)", but **TALENTS ARE STILL SPENT IN-RUN** (the meta layer that locks them
does not exist yet) and making them read-only would have deleted the entire in-run talent
economy. Reported, not taken. FREE TRAVEL is narrowed: every node of the NEXT slot is
clickable, ignoring edges — `advance()` is the only mover on a lattice, and "Jump to Boss
Slot" now WALKS the board rather than setting `slot_idx`.

§7 THE NEW BASELINES — **EVERY NUMBER HERE IS A NEW BASELINE AND NOTHING WAS TUNED AGAINST
IT.** 48 encounters is a third more than 36, so **BG's 52.3% completions IS NOT COMPARABLE**
and a figure below it is not a regression. Three policies, default first-lane builds,
**n=150 pooled per policy** (a 50 and a 100, weighted):

| route | completions | depth (of 48) | elites | tp/hero | gold earned | unspent | smith gold | decisions |
|---|---|---|---|---|---|---|---|---|
| greedy | 39.3% ±7.8 | 30.70 ±1.37 | 6.47 | 10.9 | 1963 | 27.8% | 931 (47%) | 12.9 |
| balanced | 43.3% ±7.9 | 32.11 ±1.35 | 6.00 | 10.8 | 1930 | 25.8% | 904 (47%) | 13.1 |
| cautious | 21.3% ±6.6 | 26.24 ±1.22 | 2.03 | 6.0 | 1226 | 24.6% | 508 (41%) | 10.8 |

**DOES THE GREEDY ROUTE WIN? NO — AND IT DOES NOT LOSE EITHER.** greedy vs balanced is
**0.70σ** on completions and 0.73σ on depth: indistinguishable. Both beat cautious hard —
**+18.0 pts at 3.46σ** and **+22.0 pts at 4.19σ**, +4.5 / +5.9 slots. **THE ELITES ARE NOT
UNDERPAID**: ducking every one is unambiguously the worst play, which is what §1 said a
zero-elite route should be. **WHAT IS STILL OPEN: whether HUNTING them pays.** The two
elite-tolerant policies are only 8% apart in exposure (6.47 walked vs 6.00), so the axis is
flat where they sit; resolving its top wants a bigger n or a policy pair further apart.
**READ THE TABLE WITH DEPTH IN MIND** — gold, points and bargains all scale with how far the
run got, so cautious earning less of everything is a SURVIVAL result, not an economy one. Per
SLOT WALKED the three read **0.36 / 0.34 / 0.23** talent points and **0.21 / 0.19 / 0.08**
elites, and there the elite economy is plainly doing its job.
**AND A CAUTION THE INSTRUMENT EARNED THIS BATCH:** at n=50 these same three configs read
**30% / 50% / 18%** and would have been written up as "balanced wins by 20 points". At n=150
they are 39 / 43 / 21. The n=50 spread WAS the noise, exactly as the stage-0b resolution block
says before every report. **Never publish a three-policy completions verdict off n=50.**
ECONOMY, RE-MEASURED with the merchant's new frequency and the blacksmith both live: unspent
gold at run end **63% (BJ) -> 25-28%**; the blacksmith converts **41-47% of ALL income**,
walking 6.5-7.9 a run and buying 2.4-4.1 — **the rest refused for want of gold, which is a
sink doing what a sink is for** ("nothing eligible" is 0.00/run, so the POOL never binds, only
the purse). Bargains/run 8.4 | 8.1 | 3.8 (they gate on elites, so they moved with them).

VERIFIED: check_parse 0 · check_flow 0 (**9 screens** incl. the new blacksmith) · 12 scenes
0 SCRIPT ERROR · check_map_screen OK (three positions, both overlays) · run-harness gates
1/2/3 PASS · **NEW test_batch_bk ~130/0** (the count drifts +/-1: two report loops iterate
columns whose width the generator decides — never pin it) · full battery green (an, ah,
ah_battle, ai, aj, ak, al, ar, as, at, au, av, aw, ax, ay, az, ba, bb, bc, bd, be, bf, bg, bh,
bi, bj, runes, rune_battle). **test_batch_ah is 5624 now** (was 5587 at BJ — its map section
was rewritten).
**SEVEN NEGATIVE CONTROLS, each applied to product code and reverted** (the suite returned to
0 after the last): crossing edges permitted **trips 2**, an AN-style key-route guarantee
**trips 3**, a restored post-fight merchant roll **trips 4**, a purchase consuming a mini-boss
pick **trips 1**, `has_upgrade` counting bought entries **trips 2**, a bane allowed below 1 HP
**trips 1**, the map screen leaking an event's kind **trips 1**.
**ONE OF THEM FAILED INTERESTINGLY AND THE RESULT IS LOAD-BEARING: A GUARANTEED ROUTE CANNOT
BE BUILT AT A SINGLE COLUMN.** Both rigs were caught by the GRAPH/COPY invariants rather than
by the route check written for them, because MIN_COLUMN>=2 + one-of-each-type-per-column +
no-orphans makes a single-column guarantee unconstructible. A guarantee has to be a whole-route
repair pass — which is precisely what AN's `_ensure_key_route` was. So the zero-blacksmith check
is a MEASUREMENT, not a trip-wire, and it ships PAIRED with its companion (`_forced_smith_routes`
> 0: a route that tries to duck every blacksmith is sometimes forced onto one anyway). **A check
that can only ever pass is a gap; the pair is what makes it mean something.**
SIX SUITES RE-POINTED IN PLACE with the reason in each file: test_batch_an's line section and
its whole scheduling section (both now pin ABSENCE), test_batch_ah's mini-boss unavoidability
(a reachability WALK again rather than a fact about an authored array) and its dead
`_every_route_crosses` forward-DP (deleted — it read `FLOORS` and `links`, neither of which has
existed since AN), test_batch_ah_battle's owed-pick affordance (counts the CHOOSE button AND
opens the overlay — counting only the button would be the test giving up on the half that
matters), test_batch_ai's and test_run_harness's talent arithmetic (RANGES now, with a new
`_check_range` that states both ends).
REPORTED NOT ACTED ON: **test_runes.gd's pre-existing stale call** (`_start_rune_pool` ->
`run.start_rune_enabled`, retired in AN) still prints a SCRIPT ERROR and still reports 0
failures. Untouched — it predates this batch and is not BK's to close.

§5 RUNSIM. **DOD_SIM_ROUTE IS A REAL AXIS AGAIN** after eleven batches of being three names for
one walk. `ROUTE_ORDER` = greedy (elite first) / balanced / cautious (elite last); `default`
ALIASES balanced and `elites` ALIASES greedy, because every old script and Matrix row names
them. All three rank the blacksmith top of the non-elite order ON PURPOSE — §3 asks what a
BLACKSMITH-HEAVY route converts, and a policy that walks past the sink cannot answer it; the
unsteered distribution is measured in check_map.gd instead. The walker RESOLVES non-combat
nodes in place and keeps stepping (`while true` until it finds a fight). `deck_seen` counts
everything ever REACHABLE, not what was taken. Matrix rows read **`map=branch`** and
**depth out of 48**; `map=line` is an AN-to-BJ row. NO PRE-BK ROW IS COMPARABLE.

BATCH BJ (08-11) — THE FULL AUDIT: dead code, tooltip truth, and the coherence tables. No save
version moves (still v7); no magnitude moves, no node re-specced, no system redesigned. What
shipped: deletions of unambiguous dead code, ONE dedup, ONE sim-harness speedup, and text
corrected toward the code everywhere the two disagreed.

§1 DEAD CODE — DELETED (each pinned ABSENT in test_batch_bj, the BA pattern): unit fields
`below_half_last` (no writer, no reader), `was_frozen` (unread since AS replaced the
"shattering" passive; its one write went too), `companion_hp_bonus` (writer died in the AY
re-author; its +0 term went too), `infusion_ranks` (Dark Infusion died in the AX re-author, no
vault marker — field AND dead branch), `chain_reaction_ranks` (the one AR-vault family member
whose kept read site was ALREADY gone — no writer AND no reader, so the keep had no premise);
run_state functions `relic_active` / `slot_type` / `owed_rune_picks` / `modifier_name` /
`owed_upgrade_picks` and `Runes.generate_spec` (all zero callers; generate_spec was stranded
when AN retired the spec-opening); `STATUS_INFO["bleed"]` (never applied by any path, never
displayed — the bleed chip is synthesized from `bleed_buildup` in unit.gd); and the last REST
SURVIVORS in code — the tally template's `"rests"` key (no writer existed), the run summary's
"Rests taken: 0" line, and the report loop's `"rest"` row.
§1 DELIBERATE KEEPS, one line each, all asserted PRESENT in test_batch_bj so a later cleanup
must read the decision first: **CONVICTION_NO_CONSUME_SHARE** stays (test_batch_ay drives the
branch directly and it is a designed rule — revived by any future writer of a partial-consume
release, i.e. an effect that parks an ally at five or lets a release keep stacks);
**CLASS_POOLS** stays (ready for the day the class draw reopens — AN §4's call, unchanged);
**THE VAULT** stays whole — Retaliation, Ashes of Al'ar and Umbral Sigil are LIVE (in
SPEC_POOLS, the draw the game actually reads), the other seven (Rallying Shout, Mana Shield,
Arcane Surge, Reality Fracture, Dawnbreak, Sanctuary, Divine Wrath) are name-resolvable design
inventory no live draw can offer, and four more are prose-only (Flame Surge, Frost Bolt, Death
Ray v1, Mend Wounds — reviving any means AUTHORING); the AR/AS/AT rune-only and vault-pattern
counter families stay (documented; `icy_veins_charge` is transitively unreachable but rides its
family's comment); **the two dead `rest_heal_add` relic hooks stay** (Cairnmoss Poultice,
Martyr's Knucklebone — re-speccing a relic is design, AN's note stands).
§1 THE VICTORY SYNC IS ONE IMPLEMENTATION NOW: `BattleUnit.sync_victory_state(member)` — the
three-field arithmetic (two gains OFF, Rot's loss BACK ON), the 20% return floor, the clamp and
the Mana write — called by battle.gd's victory branch AND RunSim.on_battle_end. The two copies
begging each other not to drift are gone; the sign-order block lives above the function.
test_batch_aw and test_batch_bb RE-POINTED IN PLACE at the one site (reasons in the files).
§1 THE SIM IS 5.3x FASTER AND NOTHING IT COMPUTES CHANGED: headless Godot ticks
`process_frame` at a throttled ~146/s whatever Engine.max_fps says, so ~81% of every sim's
wall clock was the engine SLEEPING between frames (100 battles: 28.8s CPU inside 88.5s wall).
`sim.sh` passes **--fixed-fps 240** now — the flag disables real-time frame sync, the same
frames run back-to-back (100 battles 16.7s at 98% CPU, wins/rounds/deaths statistically
identical). The remaining cost is battle logic itself; sim code never reads delta. A run-100
measurement is ~8 minutes now, which changes what is affordable to measure.
§2 THE TOOLTIP AUDIT, SYSTEMATIC AND COMPLETE — 144+144 talent nodes, 84 ability dicts, 65
runes + 6 templates, 72 glossary entries, 20 enemy kinds, every desc against its payload and
read site. **THE COUNT: 38 discrepancies** (13 talent, 7 ability, 6 rune, 11 glossary, 1
enemy-data) against the four found by accident in twenty batches. ALL TEXT FIXED TOWARD THE
CODE except the two that are MISSING MECHANICS, reported not silently implemented (§2's rule):
· **Unbroken Watch's tooltip lied outright** — promised +2 Loyalty, the read site reads the
  field as a GATE and pays a fixed +1; the magnitude was never read. Desc/scale/payload all say
  1 now (behavior unchanged); paying more is a design decision needing the read site to pass
  the field as the amount. test_batch_bj pins the gate-only shape.
· **Reality Fracture's perfect ("An Arcanist also banks 1 Resonance") has NO implementation**
  — no perfect_id, no handler, nothing. Unreachable in live play (vault entry, dead class
  draw), so nobody has ever seen the lie. PINNED INERT in test_batch_bj (the White Flame
  pattern); implementing it is one branch in the perfect dispatch, made knowingly.
The rest, in one line each: Cauterise now states Kiln-Forged's precedence; Siphon says
"strikes" (Temporal Rift's echo was never siphoned); Ricochet is spelled Ricochet; three
Beastmaster descs dropped FALSE BASELINES (no code ever halved Loyalty on death, extended
Wrath per-two-stacks, or paid a dead boon "for a few turns"); Wild Rotation stopped claiming
base arrival behavior; Sacred Covenant says "a shield" (the lethal-save hook has NO divine
gate — ANY barrier pays it, Blessed Vestments included); the four authored fallbacks
(Sacred Resolve, Bulwark, Mind Flay, Mass Hysteria) state their already-owned upgrades;
Consecrated Ground's tooltip finally states its Faith drip (66% of all Faith — its principal
function was absent from its own text); Call of the Wild no longer claims 15% for LIVING
beasts (they make their real strikes; ghosts strike at 15%); Spirit Bond and Primal Surge
state their Pack behavior; Explosive Shot's perfect and Shrapnel Charge state "% of Attack"
(they read as flat); the Weeping Wound states its Cripple carrier, the Wide Current its +10%
max-Mana trip, the Whispering Dark its 1-Ruin mark (AX said it must), the Open Hand its
heal-crit gate, the Hollow Chalice its true 6%-per-stack, the Warpath its 50% roll; eleven
glossary entries rewritten off dead systems (ceil(N/3) pricing, 1/2/3 points, rests, growing
rune slots, 10-tier maps, three-spec trophies, four-a-zone bargains, '???' nodes); the boss
comment in battle.gd corrected (EVERY boss unlocks a relic — code and glossary already
agreed); enemy ability `description`s are authored text NO UI displays (reported, kept).
The White Flame's inert clause was found again independently and is NOT counted — recorded
since AR, pinned by test_batch_ar, stands.
§3a THE SIGNATURE-PAYOFF TABLE (the sim prints it now on every report — `_b_sig` slice, one
`_sig()` door, banked trash-vs-boss in _check_end beside the Ruin denominators, rendered by
`signature_report_block`, "" when nothing banked). ROTATED RUN n=100, default first-lane
builds (BG's standing confound applies: Holy's first lane never learns Intercession, so that
row's zero is the BUILD, not the bot). Per battle, trash | boss:
  Berserker bleedouts 1.40 | 2.42 · Warden blocks 6.31 | 9.16 · Swordmaster Guard Changes
  1.33 | 3.12 · Pyromancer Detonations 0.82 | 1.27 · Cryomancer freezes 7.85 | 7.33 (holds
  ≥3: 2.17 | 2.65) · Arcanist Death Rays 0.44 | 0.57 · Holy Resurrections 0.20 | 0.15
  (Intercessions 0 | 0, build-gated) · Devout releases 1.30 | 2.31 · Occultist detonations
  0.16 | 0.86 · Beastmaster swaps 0.05 | 0.13 (beast deaths 0.18 | 0.27) · Sharpshooter
  Focus conversions 1.46 | 2.05 · Survivalist 3+-status strikes 2.55 | 4.62.
**THE ANSWER TO §3a's QUESTION: boss-only payoffs are TWO SPECS, not a pattern.** Ten of
twelve signatures fire at least ~0.8/trash battle; the Occultist (5.4x boss/trash, 0.16
trash) is boss-tilted BY DESIGN (AX), and the Beastmaster's swap is nearly absent everywhere
(0.05/0.06 in both constructions) — the capstone lane's verb is not happening on this bot
(the AY §7 swap margin rule needs both slots full + a 1.25x better boon; report, don't tune).
Devout releases read 0.90-1.30 trash in RUN contexts against BI's 0.7 standalone all-four —
different instrument, both true; the run carries items, runes and deeper fights.
§3b THE GOVERNOR TABLE is under "Current systems snapshot" below (all six verified at their
sites this batch — no meter is ungoverned; finding of the first order: none).
§3c THE RUN ECONOMY, MEASURED (n=100 default party — completions 53%, inside BG's 48-60%
band — and n=100 rotated at 27%; rotation is harder, as W found): **gold earned 2386 /
spent 881 / DEAD 1505 per run (63% of income is never spent).** Shop buys 5.4 heals + 2.2
restocks + 9.0 runes; items used 10.7/run against 8.6 carried unused at the end; merchants
met 9.80/run (the rests-equivalent; taken == offered by construction — they are scheduled,
never declined); events 5.19/run; bargains 6.6/run at severity 3.67. **AO's question
answered: income is not the constraint and neither are prices — the binding refusals are
SLOTS (13.6 shop-rune refusals/run for no free slot, vs 6.8 for the 40g reserve).** The
economy generates ~2.7x what the bot can find worth buying, WITH the standing caveat that
sim acquisition is a floor on the bot's policy, not a human's. "Per route" is one row by
construction — the three policies are one walk since AN (BG §1), not re-run as a band.
§5 test_batch_bj.gd 67/0. RE-POINTED IN PLACE: test_batch_aw (victory-sync checks → the one
shared implementation + both callers), test_batch_bb (same). The signature block carries the
""-when-absent coverage in test_batch_bj.

BATCH BI (08-10) — THE TWO FAITH AXES STOP FIGHTING EACH OTHER. No save version moves (still
v7); every id survives. **§1 is a change to what the resource IS, §2 is a decomposition with one
rate change shipped beside it.**

§1 **THE HELD VALUE READS THE PEAK, NOT THE CURRENT COUNT — AND THIS IS THE STRUCTURAL NOTE THE
WHOLE BATCH EXISTS FOR. HELD VALUE AND RELEASE FREQUENCY ARE ANTAGONISTIC ON A SINGLE METER:
releases want it EMPTY, held value wants it FULL.** So the second axis BG and BH added to break
the compounding was not independent of the release engine, it was *against* it — which is why
BH's leave-one-out grid came back flat and why Communion (rolls only ON a release) and Binding
Oath (paid BY releases) both read dormant. **A LATER BATCH WOULD OTHERWISE REDISCOVER THIS BY
RE-COUPLING THEM.**
· **`faith_peak` (unit.gd)** — the highest Faith a unit has held THIS BATTLE. **ONE RATCHET**
(`u.faith_peak = maxi(...)` in `_gain_faith`, immediately after the count moves — one line where
the two can disagree), **TWO READ SITES** (the damage-dealt term at the attacker block and the
mitigation term at the strike-target block, both gated on `faith_peak > 0` too), **ONE RESET**
(`_reset_faith_meters()`, battle start, zeroing count and peak TOGETHER and running BEFORE
`_swear_opening_oath`, which grants Faith). Its own function for the standing reason —
`_run_battle` cannot be driven headlessly, so the reset's negative control is a real check.
A release resets the COUNT and leaves the peak standing, so the release is pure upside instead
of a cost paid against the lane's other half.
· **THE MAGNITUDES CAME DOWN BECAUSE PEAK-READING MULTIPLIES THEIR EFFECTIVE VALUE**: 3% → **2%**
mitigation, +2% → **+1.5%** damage, per PEAK stack. Both are FLOATS now (`"%d"` would ship +1.5
as 1 — the AA float-into-int trap from the other side); `_faith_pct_text` renders them.
· **FERVOR AND APOSTLE ARE ADDITIVE, AND THE READ SITE IS WRITTEN AS A SUM ON PURPOSE.** Base
1×, Fervor +1×, Apostle +1× → **×3, never ×4**. **THE REASON, ATTACHED: a product is the
compounding fault this arc exists to remove, rebuilt on the new axis** — and `m *= 2` is what a
later batch writes by accident, because it reads like the obvious edit and passes every
source-level check in the file. At ×3 on a peak of five that is 30% mitigation and +22.5% damage
on every ally while the ground holds.
· **THE CHIP NOW SURVIVES A RELEASE** (`_refresh_faith_chip`, the one place Faith is rendered),
at F0, stating both the count and the peak. A live benefit with no chip is a lie on the bar.

§2 **THE PER-SOURCE TABLE IS THE DELIVERABLE, THE WAY BC'S GRID WAS.** Releases sat at 0.4 a
battle and nothing in the project could say WHICH source was dry. `_faith_gained` is the one
door (total and named term written by the SAME call, `_devout_heal`'s pattern), and
**`_gain_faith` takes a `source` with NO DEFAULT** — a default is how the next Faith generator
lands silently in the wrong bucket. **SIX TERMS, NOT THE BRIEF'S FOUR**: absorbs, ground drip,
Communion, Covenant, **Binding Oath and the opening rune**, because printing four while counting
six would break the parts-sum-to-the-total property the table is worth reading for.
**TWO DENOMINATORS**: absorbed hits/battle, and the share of hero turn-starts the ground was up
(`faith_ground_turns` / `faith_hero_turns`, both banked in `_ground_faith_tick` — the ground gate
MOVED BELOW the Devout lookup so the denominator is not the numerator).
**THE RATE CHANGE: Conviction pays `FAITH_PER_ABSORB` = 2 per absorbed hit, up from 1.**

§2 MEASURED, n=200 a read, BC/BE's all-four lineup, **every row replicated because BH recorded
that this row is no longer a ±2-point instrument.** `d+h+p%` per read → median:
**FAITH + Apostle 15/14/15/15 → 15%; −Apostle 15/15/15 → 15%; ungeared 12/11/11 → 11%.**
**THE LANE IS WORTH FOUR POINTS OVER THE UNGEARED FLOOR, AGAINST BH'S TWO** — read against the
floor, never as an absolute (BH's caveat, and it is what makes this legible). Releases/battle
**0.68-0.76 against BH's 0.42-0.49**, i.e. **~1.6×, almost exactly the 1.7× §2 predicted** —
and §2 said in advance it expected that to be insufficient. **IT IS: the target was two to four
releases a battle and the lane reads 0.7.**
**NO IGNITION. The spread is 14-15 across four full-lane reads and 11-12 across three ungeared
ones; nothing came back ten points above its neighbours**, which is the runaway BH warned §2
would feed. 200/200 wins every row, 0 SCRIPT ERROR.
**THE DECOMPOSITION, full lane, per battle: ground drip 9.1 | absorbs 3.2 | Binding Oath 0.70 |
Communion 0.68 | Covenant 0.03 | opening rune 0.00 — total 13.8, of which 3.4 lands on the
Devout's own non-releasing meter.** Denominators: **absorbed hits 1.5 a battle** (2.05 Faith
each — the rate change landed exactly), **ground up on 54-56% of hero turn-starts** (9.1 of 16.6).
**THE BRIEF GUESSED THE GROUND AND THE GUESS IS RIGHT ABOUT WHICH SOURCE MATTERS AND WRONG ABOUT
WHY. The ground is not dry — it is 66% of all Faith and the only thing keeping the lane alive.
THE DRY SOURCE IS ABSORBS: 1.5 absorbed hits a battle.** And the real bottleneck is neither
rate: **~10.4 Faith a battle reaches allies, split across THREE of them, so an ally averages 3.5
against a release threshold of 5. The average ally cannot fill the meter in an average fight** —
0.73 releases × 5 = 3.65 Faith actually reaching a payout, **35% of what lands. The rest is
stranded as partial stacks when the battle ends** (~16.6 hero turn-starts ≈ 4 turns an ally).
**THE NEXT LEVER, WITH THE NUMBER BEHIND IT, AND NOTHING FURTHER WAS TAKEN: the ground's base
drip 1 → 2.** It adds ~9.1 Faith/battle, ~6.8 of it to allies, taking an ally from 3.5 to ~5.7 —
across the threshold — for an estimated **2.0-2.5 releases a battle, the bottom of the band.**
**THE ALTERNATIVE, RECORDED WITH ITS NUMBER SO THE CHOICE IS VISIBLE: the release threshold
5 → 3**, which costs no new Faith at all (3.5 per ally over a threshold of 3 ≈ 2.6-3.0 releases)
but changes the cap and the threshold, today the same number. **BOTH ARE DESIGN DECISIONS AND
NEITHER WAS TAKEN. THE DRIP IS THE TERM BH DELIBERATELY REMOVED A NODE FROM** (a deeper drip is
a frequency multiplier) — raising the BASE is a different decision from re-adding a node
multiplier, but it must be made knowingly.
**COMMUNION AND BINDING OATH WERE REPORTED AND NOT TOUCHED, on §3's instruction — AND ONLY ONE
OF THE TWO IS STILL DORMANT.** Leave-one-out, all four built, every cell replicated
(d+h+p% per read → median): **full 15/14/15/15 → 15; −Communion 15/15/14 → 15 (NO MOVE);
−Binding Oath 15/13/13 → 13.**
· **COMMUNION IS DORMANT, AS §3 PREDICTED**, and its own gain term says why outright: **0.68
Faith a battle** against the ground's 9.1. It only rolls ON a release and there are 0.7 of those.
· **BINDING OATH MAY NOT BE, AND THE HONEST ANSWER IS THAT THIS INSTRUMENT CANNOT RESOLVE IT.
REPORTED AS UNRESOLVED RATHER THAN CLAIMED EITHER WAY.** Its reads are **15/13/13 against the
full row's 14/15/15/15 — the ranges OVERLAP**, and BH's standing warning is that this row is no
longer a ±2-point instrument. What the cell tracks is releases and healing (nooath 0.76/0.57/0.64
releases, and its ONE read at 0.76 releases scored 15, the same as a full row at the same rate),
not a clean node effect.
  **THE MECHANISM THAT WOULD EXPLAIN A REAL EFFECT, AS A HYPOTHESIS WITH ITS EVIDENCE, NOT AS A
  FINDING: §1 gave the node somewhere to go.** The Devout's own Faith ratchets a PEAK now, so the
  ~0.70 stacks a battle it swears him pay him mitigation for the rest of the fight instead of
  sitting on a meter that never releases — and the numbers move the right way (Faith onto his own
  meter **3.4 with the node, 2.6 without**; absorbed hits **3.1-3.4 vs 2.6-3.3**, which is the
  documented loop: less damage taken → more Divine Shields cast → more absorbs). **IT WOULD TAKE
  MORE REPLICATES THAN THIS BATCH RAN TO SAY SO, and no lever should be aimed at this node on the
  strength of three reads.**
· **APOSTLE READS ZERO ON THE HEADLINE** (15% with, 15% without) — the capstone's whole value
is now held mitigation and damage that lands on ALLIES and raises the denominator, which is the
same shape BG recorded; read it in the ally rows, not in his `d+h+p%`.
**LIVE AUTOPLAY: 0 SCRIPT ERROR, and THE SIGNATURE PAYOFF IS BACK IN ORDINARY FIGHTS — three
releases in one battle, against BH's FIVE CONSECUTIVE AUTOPLAY BATTLES WITH NO RELEASE AT ALL.**
Binding Oath and Communion both fired in that same fight.

VERIFIED: check_parse 0, check_flow 0 (6 screens), 11 scenes 0 SCRIPT ERROR, run-harness gates
1/2/3 PASS. **EVERY SUITE IN THE PROJECT RUN AND GREEN** (ah 5587, an 6053, runes 2973, ay 457,
at 461, az 489, ba 647, ar 887, al 559, aw 340, au 340, ax 329, as 387, av 315, ai 2036, aj 403,
ak 527, bb 172, bh 233, rune_battle 96, bc 91, bi 88, bf 78, bd 69, ah_battle 63, bg 47, be 34).
**test_batch_ah's and test_batch_bb's master.html stamp gates bumped BH → BI** — they are the
same gate twice and both must move.
**ONE PRE-EXISTING FLAKE OBSERVED AND DIAGNOSED, NOT CHASED: test_batch_al's "Spite reflects
damage at the attacker" fails about 1 run in 10.** It is a rounding edge — Spite reflects 30% of
a hit that carries a ±10% roll, and a low roll under armor reflects zero — and it is
**UNREACHABLE FROM THIS BATCH: AL's party is warden/cryomancer/holy/mystic, so no Devout stands,
`_living_devout()` returns null and every Faith read site is inert.** Eight runs on an
unmodified-HEAD copy came back clean, which does not by itself distinguish 1-in-10 from zero —
the party composition is the argument, not the count.
NEGATIVE CONTROLS RUN, SEVEN, each applied to battle.gd and reverted (the file was restored and
the suite re-run green afterwards): **the held value reading the CURRENT count again trips 9;
the peak surviving a battle boundary trips 2; Fervor and Apostle multiplying to ×4 trips 4
(including the measured arm — 32.4% read against the 24% the sum pays); a peak on the DEVOUT
paying his allies trips 5; Conviction paying 1 per absorb again trips 3; the release removing the
chip again trips 1; and a source landing in the wrong bucket (the ground booking as an absorb)
trips 2.**
NEW test_batch_bi.gd **88/0**. **SEVEN SUITES RE-POINTED IN PLACE with the reason in
each file, and FOUR OF THE RE-POINTS ARE INVERSIONS** — test_batch_bg's and test_batch_bh's "the
chip is gone with the stacks" became "the chip STAYS, because the peak keeps paying";
test_batch_bh's "the two QUADRUPLE" became the additivity negative control (`x4` now FAILS it);
test_batch_bg's "the status default names Apostle as the doubler" became "it states the peak
rule", because BI made the bigger statement the one a player meets first. The mechanical
re-points: every driven `_gain_faith` call gained its source argument, the `_gain_faith(u, 1)`
source-greps in aw/ax/bh became `_gain_faith(u, 1, "ground")`, and every `_damage_dealt` /
`_damage_taken` helper in bc/bg/bh sets `faith_peak` beside `faith_stacks` — **that last one is
the trap: a helper that set only the count would measure zero and read as a magnitude bug.**

BATCH BH (08-10) — FOUR MORE ABILITY UPGRADES, AND THE FAITH LANE GETS A SECOND AXIS. Two
things that do not interact: **§1 is additive content, §2 is two re-specs.** No save version
moves (still v7); every id survives.

§1 **THE UPGRADE POOL GOES FROM FOUR TO EIGHT AND CLOSES THERE — see the entry under "Known
open threads" below**, which is where it belongs and where it will be looked for. Short version:
Weighted / Widened / Piercing / Certain, on Break, breadth, armor and status reliability; the
new ids are APPENDED to `UPGRADE_PRIORITY` because that list is AU §1's fallback order and a
compatibility surface; three of the brief's field names were corrected toward the code; and
**`up_sure` was not written because the Perfect window is a script constant a grader with no
arguments reads, and the bot never runs the bar at all.** Certain reaches 2 of 92 abilities and
that is REPORTED, not forced.

§2 **FERVOR AND BINDING OATH MOVE OFF THE RELEASE-FREQUENCY AXIS, FINISHING WHAT BG STARTED ON
THE CAPSTONE.** BC's decomposition proved this lane was one node with eight prices — three of
the eight multiplied release FREQUENCY and one multiplied release MAGNITUDE. BG moved Apostle;
BH moves the other two, leaving **Communion as the lane's single frequency node** (15, untouched)
and Sacred Covenant's +2 on a lethal save (one small frequency term is not the fault).
**BC'S GRID FIGURES TRAVEL WITH THE TWO RE-SPECS SO NOBODY RE-PRICES THEM BACK ONTO FREQUENCY**
(full lane 80% | 2255 healing | 32.21 releases): **−Fervor read 64% | 956 | 14.19 — the node
HALVED release frequency, which is exactly why its old subject had to go**; −Binding Oath read
79% | 2123 | 30.43, i.e. ONE point, and BH's own instrument later showed why that number was
misleadingly small (see the leave-one-out caveat in the standing rule above). −Communion read
47% | 444 | 7.08, THIRTY-THREE points, and Communion is the one that stays.
· **FERVOR — THE HELD HALF.** Was: the ground's Faith drip becomes 2 per ally per turn. Now:
**while Consecrated Ground holds, every ally standing on it counts each stack DOUBLE — 6%
mitigation and +4% damage dealt — and it grants no extra Faith at all.** Stacks with Apostle for
QUADRUPLE. The base drip of 1 is AW §2's and is untouched.
· **BINDING OATH — THE DEVOUT'S OWN FAITH.** Was: a release leaves 3 stacks standing, which
means the NEXT release costs two rather than five, i.e. the third frequency multiplier wearing a
"you keep some" coat. Now: **an ally's release swears the Devout a stack of his own, and HIS
never releases — it holds, paying him the same mitigation and damage it pays them.**
**THE BRIEF'S PREMISE FOR THAT NODE WAS STALE AND CORRECTING IT MADE THE CHANGE BIGGER THAN THE
BRIEF THOUGHT. It says the Devout "has no meter of his own anywhere in his kit". HE HAS HAD ONE
SINCE BATCH AW §2** — Consecrated Ground drips onto its own caster and `_gain_faith` never
excluded him — **AND IT RELEASED**, healing, growing his own maximum and rolling Communion. That
was an uncounted frequency source; closing it is what §2's own named negative control asks for,
and it is why this is a change to WHAT THE RESOURCE IS rather than to one node.
**ONE MULTIPLIER, TWO GATES, ONE READ SITE**: `_faith_stack_mult(devout, holder)` takes the
HOLDER too, because Fervor reads the CARRIER's ground — reading the Devout's would double
everybody whenever he stood on his own. `.apostle` is still read in exactly one place.
**TWO FIELDS DELETED WITH THEIR READ SITES, not re-pointed in place** (both nodes changed what
they MEAN, the harder failure — the BA `plague_bearer` precedent): `fervor_step` and
`oath_ranks`. Three replace them: `fervor` (a gate shaped like `apostle`), `oath_faith`,
`oath_opening`. `fervor_step` LEFT `Runes.STAT_INT_KEYS` with the field; `oath_opening` joined it.
**THE RUNE OF THE BINDING OATH COULD NOT PAY WHAT IT PAID — RE-POINTED, NOT DELETED, AND
REPORTED** (the AZ Deep Sight / AY Deep Bond / AX Hollow Chalice precedent): its first clause
bought the deleted remnant, so it keeps the RELATIONSHIP (Faith that persists) through
`oath_opening` — the Devout opens each battle already holding one. Second clause
(`faithful_step` 5) byte-untouched, desc rewritten. **A dead-clause repair, NOT the rune
magnitude pass closed in AF.** `_swear_opening_oath()` is its own function called from the
battle-start block (the `_run_battle`-cannot-be-driven-headlessly rule).
**AY §9's HALF-GROWTH RULE IS UNREACHABLE TWICE OVER NOW** — Apostle was the only thing that
parked an ally at five (BG) and the remnant was the last writer of a non-zero `keep` (BH), so a
release always consumes all five. Rule and argument stay in `_conviction_growth`, where
test_batch_ay drives them.

§2 MEASURED, n=200 every row, BC/BE's lineup, **ONE session, ONE instrument, with the pre-BH
rows RE-RUN on an unmodified-HEAD copy rather than quoted — and the HEAD rows REPRODUCE BG's
exactly** (BG published FAITH 38 / ZEAL 32 / BULWARK 12; HEAD reads 39 / 32 / 12).
`d+h+p%` | healing/battle | releases/battle | healing per release | growth/battle:
**ALL FOUR BUILT** — FAITH+Apostle **HEAD 39% | 331 | 4.78 | 62 | 28.6 HP** → **BH 13%/14% |
26/31 | 0.42/0.49 | 54 | 2.9 HP**; −Apostle **HEAD 38% | 312 | 4.51 | 62** → **BH 13% | 32 |
0.51 | 54**; **ZEAL 32 → 31**; **BULWARK 12 → 12**.
**ONE-HERO** — FAITH+Apostle **HEAD 63% | 918 | 12.80 | 65** → **BH 25% | 95 | 1.50 | 55**;
−Apostle **BH 24% | 100 | 1.59 | 55**.
**THE BAR: FAITH 13 | ZEAL 31 | BULWARK 12 — 0.44x, from BG's 1.19x. THE LANE WENT FROM TWICE
ITS SIBLINGS TO LEVEL WITH THE WEAKEST OF THEM. REPORTED AND NOT CORRECTED, on §2's explicit
instruction; Blessed are the Faithful is the node to raise if the designer wants it raised.**
**ZEAL AND BULWARK ARE THE CONTROL AND THEY DO NOT MOVE** — worth measuring rather than
assuming, because unlike BE's and BF's levers this batch changed a rule about the RESOURCE, so
the two lanes taking no Faith node were no longer byte-identical by construction.
**THE SHAPE TEST PASSES ON BOTH HALVES: releases/battle 4.78 → 0.42-0.49 all four and 12.80 →
1.50 one-hero, while healing per release stays flat** (62 → 54, 65 → 55; the small fall is
explained — HEAD's average included the Devout's OWN releases at his grown maximum, and only
allies release now).
**AND THE INSTRUMENT FINDING, WHICH MATTERS MORE THAN THE GRID — see the Faith entry under
"Known open threads": THE ALL-FOUR ROW IS NO LONGER A ±2-POINT INSTRUMENT.** The first read of
the −Binding Oath cell came back **24% / 2.06 releases** and does not reproduce (three later
reads: 12/13/14%).
**THE LEAVE-ONE-OUT GRID, EVERY CELL REPLICATED BECAUSE OF THAT** (all four built, n=200 a read,
d+h+p% per read → median): **full 13/14/13/13 → 13; −Communion 14/14/13 → 14; −Fervor 13/13/13
→ 13; −Binding Oath 24(runaway)/12/13/14 → 13.** Releases/battle 0.36-0.49 in every cell.
**NOTHING MOVES THE HEADLINE BY MORE THAN ONE POINT, against BC's Communion at THIRTY-THREE —
so on §2's stated test the lane is a lane. IT PASSES TRIVIALLY AND THAT MUST BE SAID: an
UNGEARED Devout beside the same three built allies reads 11%, so the whole eight-node lane is
worth about TWO POINTS over no lane at all**, and nothing inside a two-point lane can move a
headline by fifteen. That caveat is attached to the standing rule above.
**THE LANE'S ONE SURVIVING FREQUENCY NODE IS NEARLY DORMANT TOO, and so is the node re-specced
to replace one: Communion only rolls ON a release** and at 0.4 releases/battle it barely rolls
(hence its 1 point), **and Binding Oath's payer IS ally releases — the very term §2 damped.**
Both reported, neither touched.

LIVE AUTOPLAY clean (0 SCRIPT ERROR) and **FERVOR READS CORRECTLY IN A REAL FIGHT** —
"Consecrated Ground kindles Berserker (+1 Faith) — and his Faith is worth double here (Fervor)",
i.e. the flat drip and the doubling in one line. **BUT IN FIVE CONSECUTIVE AUTOPLAY BATTLES THE
FAITH NEVER RELEASED ONCE.** That is exactly what 0.4 releases/battle means and it is not a bug,
but it deserves the plainest statement available: **THE DEVOUT'S SIGNATURE PAYOFF HAS LARGELY
LEFT ORDINARY FIGHTS** — the same shape as AX's Ruin-in-trash finding, and the same rule applies
(reporting the number was the job; the decision is the designer's). Binding Oath's log line is
consequently unexercised by the smoke; test_batch_bh drives it directly, where a rare branch
belongs.
VERIFIED: check_parse 0, check_flow 0 (6 screens), 11 scenes 0 SCRIPT ERROR, run-harness gates
1/2/3 PASS. NEW test_batch_bh.gd **230/0**.
NEGATIVE CONTROLS RUN, SEVEN, each applied and reverted (the suite came back to 230/0 after the
last): **Fervor still dripping stacks trips 2, the Devout's own Faith reaching five and
releasing trips 5, a new upgrade bypassing AP's eligibility filter trips 4, Fervor reading the
DEVOUT's ground instead of the HOLDER's trips 4, Binding Oath's remnant restored trips 2, the
four new upgrades inserted AHEAD of the old four trips 9, and Weighted landing on `damage`
rather than `pressure` trips 2.**
**SIX SUITES RE-POINTED IN PLACE with the reason in each file, and THREE OF THE RE-POINTS ARE
INVERSIONS** — the honest treatment when a batch reverses a rule an older batch was guarding:
test_batch_aw's "does Fervor deepen the drip" now asks whether it leaves the drip alone;
test_batch_ax's §7 finding ("the ground already pays 2") became history and the site pins the
flat 1; test_batch_bg's "Binding Oath still keeps its 3" became "a release resets to zero,
Binding Oath or no". test_batch_an's pool-of-four literal and test_batch_au's four-entry
priority list moved to the pool's real size and to the ORIGINAL FOUR still leading it.
**ONE CHECK WAS SHARPENED RATHER THAN RE-POINTED, and the reason generalises:** test_batch_aw's
dead-counter sweep used a bare `contains`, which trips on a COMMENT naming a deleted field — and
naming them is exactly how this project asks a later batch not to re-add one — so it looks for a
read, a declaration and a rune key instead.
Regression, every suite at its BG count with ZERO DRIFT except the four this batch re-pointed —
ah **5587/0 (STAMP GATE bumped BG -> BH, in BOTH files that hold it — test_batch_ah and
test_batch_bb's duplicate)**, ah_battle 63, ai 2036, an **6053 (was 6052 — one check ADDED where
the pool-of-four literal was re-pointed: the offer still shrinks, it just needs six taken out of
eight rather than two out of four)**, aj 403, ak 527, al 559, ar 887, as 387, at 461,
au **340 (was 335 — re-pointed, and the dead-end case needed a NON-damaging ability because a
damaging one now legitimately continues into Piercing)**, av 315, aw **340 (was 338)**, ax 329,
ay **457 (was 455)**, az 489, ba 647, bb 172, bc 91, bd 69, be 34, bf 78, bg 45,
test_runes 2973, test_rune_battle 96 — all 0 failures.

BATCH BG (08-09) — THE RUN HARNESS READS DIFFICULTY, AND APOSTLE CHANGES AXIS. Two things
that cannot contaminate each other: **§1 is a measurement that ships nothing; §2 is one
capstone re-specced.** §2 ran first so §1 measured the fixed spec. No save version moves
(still v7).

§2 **APOSTLE IS OFF THE FREQUENCY AXIS. It no longer changes what a release consumes; every
stack of Faith an ally CARRIES is worth double — 6% mitigation and +4% damage dealt per
stack, against the base 3% and +2%.** Same id, same lane, same row, same `apostle` payload
field, so no save migrates.
**WHY THIS AND NOT A REPRICE, AND THIS IS THE PART THAT MUST SURVIVE: BF MEASURED THE OLD
CAPSTONE AT −8 ONE-HERO AND −2 ALL FOUR.** Taking it LOWERED the engine it sat on, because
parking allies at five made them invisible to Communion. **Re-pricing cannot fix a sign.**
Apostle multiplied release FREQUENCY — the exact term BE and BF spent two batches taming — so
a capstone whose whole effect is that term will keep inverting at ANY price. **DO NOT
RE-PRICE IT BACK ONTO THE RELEASE.**
**THE STRUCTURAL FACT THAT MAKES THE LANE MAKE SENSE, STATED ONCE PROPERLY: Conviction has
two halves — what a stack does WHILE HELD, and what happens when five of them RELEASE. All
EIGHT Faith nodes touch the release half** (Communion spreads it, Fervor and Sacred Covenant
feed it, Blessed are the Faithful deepens its heal, Binding Oath changes what it consumes,
Unwavering Faith and Devoutness sit on the payout's scale). **NOTHING HAD EVER TOUCHED THE
HELD HALF.** That is why it was both the only axis available and unmistakably capstone-sized.
**ONE MULTIPLIER, ONE GATE, THREE CALLERS**: `battle._faith_stack_mult(devout)` returns 2
under Apostle and 1 otherwise; `FAITH_MITIGATION_PCT`/`FAITH_DAMAGE_PCT` are the base rates;
the two damage sites and the status chip are the only readers, so the tooltip can never
describe a number the arithmetic does not use. `.apostle` is read in exactly ONE place and
test_batch_bg asserts that count.
**THE SMELL IS INVERTED, NOT REDUCED** — Communion pays only for allies BELOW five and
Apostle now pays for allies CARRYING stacks, so both nodes want the party in the 1-4 band.
**AY §9'S HALF-GROWTH RULE IS NOW UNREACHABLE AND THE CODE SAYS SO.** Apostle was the only
thing that ever parked an ally at five; Binding Oath's remnant is `mini(oath_ranks, 4)`, so
`keep` is capped at 4 by construction and `keep < 5` is always true. **The argument and the
rule STAY** (one `mini()` from live again) but master.html no longer claims it happens, and
test_batch_ay drives it at `_conviction_growth` instead of through a release.

§2 MEASURED — **AND THE FIRST THING THE RE-MEASURE FOUND WAS THAT ONE OF BF'S OWN ROWS DOES
NOT REPRODUCE.** Every row below is n=200, BC/BE's lineup, taken in ONE session on ONE
instrument, with the pre-BG rows re-run on an unmodified-HEAD copy rather than quoted.
**BF'S ALL-FOUR −APOSTLE CELL (31%) READS 39% ON UNMODIFIED HEAD TODAY** — an 8-point miss on
the cell BF called a natural control and computed "Apostle is worth −2 all four" from. BF's
other rows DO reproduce (one-hero FAITH 54→55, one-hero −Apostle 62→64, ZEAL 31→32, BULWARK
14→12, all within n=200's ±1-2). **QUOTE BG'S ROWS, NOT BF'S, FOR ANYTHING ALL-FOUR.**
`d+h+p%` | healing/battle | releases/battle | healing per release | prev/b | Faith-stack
prev/b:
**ONE-HERO** — FAITH+Apostle **HEAD 55% | 639 | 9.96 | 61 | 70 | 14** → **BG 61% | 857 |
11.98 | 64 | 79 | 25**; −Apostle **HEAD 64% | 958 | 13.30 | 65 | 68 | 12** → **BG 63% | 930 |
12.91 | 65 | 71 | 12**.
**ALL FOUR BUILT** (two replicates apiece — **the n=200 spread on this row is ~2 points and
that is the resolution to read every all-four number at**) — FAITH+Apostle **HEAD 36% / 35% |
271/264 | 4.18/4.12 | 47/41 | 8** → **BG 38% / 38% | 313/314 | 4.51/4.49 | 50/51 | 14**;
−Apostle **HEAD 39% | 334 | 4.79 | 43 | 6** → **BG 40% / 38% | 348/313 | 4.96/4.47 | 43/43 |
7/6**.
**THE CONTROL THAT PROVES THE CHANGE IS INERT WHERE IT SHOULD BE: the −Apostle rows do not
move** (all four 39 → 40/38, one-hero 64 → 63, Faith-stack prevented 6 → 7/6 and 12 → 12).
Seven of the eight Devout builds never take this capstone and none of them feels it.
**THE MECHANISM READS EXACTLY AS DESIGNED, in the term that is actually the capstone**:
Faith-stack prevented/battle is **2.0-2.3x the −Apostle baseline in both constructions** (all
four 7/6 → 14/14, one-hero 12 → 25). The OLD capstone moved the same term by 1.3x, and it did
it by parking rather than by doubling.
**APOSTLE'S WORTH, ON ONE INSTRUMENT: old −9 one-hero / −3.5 all four; NEW −2 one-hero and
−1 all four (inside the ±2 replicate spread, i.e. zero).** It is
still slightly negative ON THE SHARE and **that is the intended outcome, not a failure** —
the mitigation books to HIM and the +4% damage lands on his ALLIES and raises the
denominator, and a tougher party absorbs fewer hits so his engine spins slower (releases
12.91 → 11.98 one-hero). **READ IT IN prev/b AND THE STACK TERM, NEVER IN THE SHARE ALONE.**
His prevented/battle 43 → 50 all four and 71 → 79 one-hero; party damage/battle 616 → 627
(the old capstone took it 610 → 597, the wrong sign); enemy damage landed/battle 168 → 162.
`BDprev/b` is unmoved at 36 (all four) / 49 (one-hero) — Devoutness, untouched.
**THE BAR, RE-MEASURED ON THE BG TREE IN THE SAME SESSION: FAITH 38% | ZEAL 32% | BULWARK
12%.** That is **1.19x**, six points clear of ZEAL, against BF's stated 1.06x — but note
HEAD's own FAITH/ZEAL was ALREADY 1.11x before this batch (35.5 vs 32), so BG added ~2.5
points to a gap that was ~3.5. **BG'S BRIEF SAID: IF THE ROW CLIMBS PAST ZEAL BY MORE THAN A
COUPLE OF POINTS, REPORT AND STOP — DO NOT TAKE A FOURTH LEVER ON THIS LANE. IT DID, AND
NOTHING FURTHER WAS TAKEN.**

§1 **THE RUN HARNESS READS DIFFICULTY — A MEASUREMENT, NOTHING TUNED, AND THE PROPOSAL AT THE
END IS MARKED AS A PROPOSAL.** `./sim.sh --run 100`, all three route policies, TWO BUILD
LEVELS. This SUPERSEDES BF §3's sweep as the difficulty reference: the sweep's enemies are
unscaled, this carries tier scaling, the zone multiplier, carried HP/mana, points earned AND
spent, elite runes and trophies.
**THREE STALE PREMISES, CORRECTED TOWARD THE CODE BEFORE ANY NUMBER IS READ:**
· **THE THREE ROUTE POLICIES ARE ONE WALK AND HAVE BEEN SINCE BATCH AN.** The report's own
line: **"Reachable nodes per step: 1.00 — steps offering a real choice: 0% (0 of 2764)"**,
and **every node type reads taken == offered** (fight 18.6/18.6, elite 4.6/4.6, boss
2.1/2.1). **The band across policies is three samples of ONE configuration, not a band.**
**CLOSED BY BATCH BK — this paragraph is history, not current behaviour.** The branching map
reads 1.61 reachable per step and 41% of steps a real choice, and the three policies walk
different numbers of elites. **Everything below in this BG block describes the LINE and is
not comparable with a post-BK row on any field**, depth units included (36 vs 48).
· **RESTS DO NOT EXIST** (Batch AN). "rests taken vs offered" is **0.0/0.0** and always will
be; the recovery line is the per-slot heal. Do not ask a run report for it again.
· **A "route band" therefore cannot bracket real play.** What the three rows DO give is a
free triplicate measurement of the same configuration, which is how the noise below is
estimated.
**DEFAULT BUILDS (each tree's FIRST lane), n=100 per policy — greedy | default | cautious:**
completions **48% | 60% | 49%** (95% band **±9.6 points**, so the three are NOT
distinguishable and the spread IS the noise floor); depth reached of 36 **24.31±1.30 |
27.64±1.13 | 24.23±1.25**; wipe median slot **z1 t9 | z2 t0.5 | z1 t10**; talent points
earned/hero/run **9.2 | 10.4 | 9.2**, spent to within 0.1; gold unspent **1410 | 1572 |
1293** on 2221/2496/2132 earned; items used **10.2 | 11.0 | 10.5** per run against 8.3-8.9
carried unused; merchants **10.6/run**, events **5.8/run**, bargains **7.0/run at severity
3.67**; runes acquired **3.51/hero/run** with **94% of slots filled**; **8.0 talent nodes
owned entering a boss.**
**NAMED BUILDS (each hero on the lane his own batch measured strongest), n=100 per policy:**
completions **58% | 55% | 57%**, depth **27.00±1.28 | 25.81±1.29 | 27.67±1.26**, wipe median
**z1 t9** in all three, points earned/hero/run 10.2 | 9.7 | 10.4.
**SUBSTITUTION, REPORTED NOT BURIED: the Cryomancer runs DEEP FREEZE, not BE/BC's Thaw**,
because Thaw row 6 (Honed Shards) reaches the still-open `_hold_release`/`_hold_freeze`
recursion — 15 stack overflows in FOUR runs against ZERO on Deep Freeze. See the crash entry
under Known open threads.
**THE QUESTION NOBODY HAD ASKED, ANSWERED. Because the three route rows are provably one
configuration they POOL to n=300 a band:** default builds **52.3% ±5.7 (95%)**, depth
**25.39±0.71**; named builds **56.7% ±5.6**, depth **26.83±0.73**. **GAP: +4.3 points
(1.07σ) and +1.43 tiers (1.40σ) — NEITHER IS SIGNIFICANT.** Building well, on this bot, is
worth about four points of completions and cannot be told from zero at n=300 a band. **READ
IT WITH THE CAVEAT THAT MAKES IT HONEST: the two bands differ in TWO heroes, not four** (the
default first lane already IS the standout for the Berserker and the Beastmaster), so this is
"these two lane swaps are worth ~4 points", not "builds do not matter".
**PER-TIER WIN RATE IS 91-100% AT EVERY TIER OF EVERY ZONE** (default builds/default route:
z1 t8 96%, z1 boss 91%, z2 boss 100%, z3 boss 100%; named builds: z1 boss 97%, z2 boss 95%,
z3 boss 98%), with **0.3-1.1 deaths per fight** and party HP entering at **70-89%**.
**THE DEVOUT'S FAITH LANE IN A REAL RUN, THE FIRST TIME A LANE ROW HAS BEEN CROSS-CHECKED
AGAINST PROGRESSION: 37% `d+h+p%` over 2581 battles against the standalone all-four row's
38%.** The two instruments agree. Healing 456/battle, 125 per release, 3.13 releases/battle.
**CAVEAT ON ONE FIELD: `conviction_growth_max` reads 1071-6130 in the named rows and that is
a STALEMATE ARTEFACT** (2-3 per band run to a forced end and the growth clause accumulates
for hundreds of rounds). Read the mean — 26.9 HP/battle, +9.4% of base — never the max.
**THE RECONCILIATION WITH BF'S SWEEP, WHICH IS THE POINT OF THE SECTION: THE 15-POINT GAP IS
NOT AN ARTEFACT OF MISSING TIER SCALING. A REAL SCALED FIGHT IS NOT MEASURABLY HARDER THAN
ITS BUDGET ROW** — 91-100% scaled here against 93-100% unscaled in BF's sweep. **WHAT KILLS
RUNS IS COMPOUNDING, NOT SCALING**: ~24 fights a run at ~95% each is 0.95^24 ≈ 29%, and the
measured completion rate is 48-60%. **The per-fight number and the per-run number are both
correct and they are different questions.**
**THE MEASURED POWER LADDER IS D-SHAPED INSIDE EVERY ZONE AND THE FLOOR DROPS ZONE BY ZONE**
(party-vs-warband ratio, default route): z1 **1.49 → 0.83** at its boss, z2 **1.23 → 0.69**,
z3 **1.04 → 0.53**. **Wipes cluster where the ratio first crosses under 1: z1 t8-boss (19 of
40) and z2 t4-7 (10 of 40).**
**PROPOSAL, AND IT IS A PROPOSAL — NOTHING WAS TUNED. Do not pull enemy health, attack or
count.** The per-fight win rate is already inside a band the sweep says is 8-15 points too
easy, and every one of those levers moves the per-fight number the sweep already measures.
**The lever the run data argues for is TIER SCALING'S OWN SLOPE, and the number that argues
for it is the ratio floor: 0.83 / 0.69 / 0.53 at the three zone bosses.** A ladder whose top
sits at 0.53 while the fights on it are still won 100% of the time is a ladder whose SHAPE is
doing nothing — the party is nominally outgunned two to one at the z3 boss and beats it every
time. **Either the ratio model is not predictive of outcome (in which case stop steering by
it) or the slope is real and the win rate is being held up by something else.** That is the
question the next difficulty batch should answer BEFORE it moves a number.

BATCH BF (08-09) — THE INSTRUMENT LEARNS TO SEE BREAK, COMMUNION'S LAST LEVER, AND THE FIRST
HONEST DIFFICULTY READ. Three things in that order, because each changes what the next
measures. No save version moves (still v7). **§3 IS A MEASUREMENT AND NOTHING WAS TUNED.**
§1 **THE CONTRIBUTION METRIC COULD NOT SEE BREAK AND EVERY BREAK BUILD WAS MEASURED BY IT —
CLOSED. See the STANDING NOTE at `DOD_SIM_TALENTS` above for the shipped shape**, which is
where it belongs and where it will be looked for. Short version: **two new columns and
deliberately NOT one new share.** `BD%` (a hero's Break dealt over the party's, off its own
pool and its own battle slice) and `BDprev/b` (Break refused), plus a `break_prevented_line`
audit naming which effect refused what. **THE OLD SHARE DID NOT MOVE BY A POINT AND IS NOW
LABELLED `d+h+p%`** with a legend under the table stating outright that it is not a share of
the party's work. **BREAK IS NOT FOLDED IN AND MUST NOT BE** — that needs an exchange rate
between a Break point and a hit point that nobody can defend.
**THE AUDIT FOUND FIVE MORE HOLES BESIDE THE ONE THE BRIEF NAMED.** Six effects reduce or
refuse incoming Break — **Devoutness, Bulwark of Fortitude, Hold the Line, Ward, Immovable,
Bracing** — and exactly ONE (Devoutness) was booked anywhere before this batch. All six now
go through **one door, `_prev_bd`**, on BC's `_devout_prev` pattern: per-hero total and named
term written by the SAME call, so the parts can never disagree with the total. `unit.gd`'s
`_credit_bd` and the `bd_` term prefix are the routing rule, so a seventh reducer added later
names itself into the right ledger or does not book at all. Measured live: **Bulwark refuses
182 of 200 raw Break points on one hit and books all 182 to its caster.**
§2 **COMMUNION NO LONGER ROLLS FOR AN ALLY ALREADY AT FIVE FAITH.** One condition, on the
existing gate, framed as an INCLUSION because the mechanic reads better that way and the
tooltip has to say it: fervor spreads to allies **still building** it; an ally at five is at
the payout, not building. **THE CLIFF IS STATED IN THE TOOLTIP — 60% at four, 0% at five** —
because a chance that climbs with stacks and then vanishes reads as a bug otherwise. Measured
over 1200 driven releases apiece: **58.8% at four, 0.0% at five (it was 75%).**
**IT LANDED INSIDE THE BRACKET BE PRE-MEASURED FOR IT, WHICH IS WHY THIS LEVER WAS CHOSEN OVER
THE ALTERNATIVE.** Bracket 48-73% one-hero / 25-45% all four; **measured 54% and 33%.**
n=200 per row, BC's lineup, both constructions, all four rows — contribution | healing/battle
| releases/battle | healing per release:
**ONE-HERO**: FAITH all eight **73% | 1555 | 22.77 | 65 -> 54% | 618 | 9.64 | 61**;
−Apostle **63% | 910 | 12.70 | 65 -> 62% | 913 | 12.70 | 65**.
**ALL FOUR BUILT**: FAITH **45% | 429 | 6.55 | 62 -> 33% | 244 | 3.81 | 61**;
−Apostle (new row) **31% | 318 | 4.58 | 62**.
**THE −APOSTLE ROW IS A NATURAL CONTROL AND IT REPRODUCES TO THE HUNDREDTH** — releases
12.70 -> 12.70, because without Apostle an ally never sits at 5 and the condition can never
fire. **HEALING PER RELEASE DID NOT MOVE IN ANY ROW**, across BE and BF both: it was a
frequency problem and both levers bought frequency.
**THE BAR IS MET ON THE ROW THAT COUNTS: all four built, FAITH 33% against ZEAL 31% /
BULWARK 14%** — 1.06x, from 1.8x before BE and 1.45x after it. ZEAL/BULWARK were NOT re-run
and did not need to be (no `dv_communion`, no draw, byte-identical by construction).
**AND THE SIGN ON APOSTLE FLIPPED, WHICH IS THE COST THE BRIEF PREDICTED, NOW WITH A NUMBER.**
Apostle was worth +7 at Communion 40 and +10 at 15; it is now **−8 one-hero (54 vs 62) and −2
all four (33 vs 31)**. Taking the capstone LOWERS the Faith engine, because parking allies at
5 makes them invisible to Communion. **TWO NODES IN ONE LANE THAT PARTLY CANCEL EACH OTHER IS
A SMELL. RECORDED, NOT SOLVED** — if the tree wants restructuring later, this is the note to
start from, and the honest fix is probably to make one of the two something else rather than
to re-price either.
§3 **THE FIRST HONEST DIFFICULTY READ. A MEASUREMENT — NOTHING WAS TUNED, AND THE PROPOSAL AT
THE END IS STATED AS A PROPOSAL SO THAT STAYS OBVIOUS.** `./sim.sh --sweep 400`, n=400 per
budget (R used 200; at 400 the SE on a 93% row is 1.3 points), **two build levels**.
**UNGEARED — no talents, the party entering zone 1. READ THE LOW BUDGETS OFF THIS.**
budget | win% | rounds | deaths/b | foes | alive@r3:
**3 100% 5.0 0.02 2.5 0.0 | 6 100% 7.6 0.22 4.2 0.0 | 9 97% 10.0 0.59 5.4 0.1 |
12 93% 12.3 0.96 5.9 0.3**
**ALL FOUR IN FULL 8-NODE LANES — the party at zone 3, 8 points = a full path. READ THE TOP
BUDGET OFF THIS** (BE's four lanes, so it is comparable with §2's rows):
**3 100% 3.9 0.01 2.5 0.0 | 6 100% 5.3 0.06 4.2 0.0 | 9 100% 6.6 0.14 5.4 0.0 |
12 100% 7.6 0.21 5.9 0.0**
Both shares at budget 12 (dmg% | BD% | d+h+p%) — **ungeared** Beastmaster 33|10|26,
Berserker 27|44|22, Cryomancer 36|41|29, Devout 4|5|22; **built** Beastmaster 45|10|26,
Berserker 23|43|14, Cryomancer 30|43|17, Devout 2|4|43 with 55 Break prevented/battle.
**THE CONTROL, AND IT IS WHAT MAKES THE REST READABLE: THE UNGEARED ROW REPRODUCES BATCH R
ALMOST EXACTLY** — R read 100/100/98/93.5 at n=200, this reads 100/100/97/93 at n=400.
Nothing in the twelve spec batches since has moved the composition curve.
**AGAINST BATCH V's ~85% TOP-BAND TARGET: 93% UNGEARED, 100% BUILT — 8 AND 15 POINTS HIGH,
and the built party lost none of 400 top-band fights.** The 100% rows at budgets 3/6 are not
a finding; a first-zone encounter is supposed to read that way.
**THE CAVEAT IS LARGE AND MUST TRAVEL WITH THE TABLE: sweep enemies are UNSCALED and BOTH
build levels ran against the ZONE-1 roster**, so the build axis is clean and the enemy axis is
missing — a real tier-8+ zone-3 fight carries tier scaling and the zone multiplier on top.
**These are an UPPER BOUND on the party's side, not a verdict on the game.** What the table
honestly says is that COMPOSITION ALONE DOES NOT PRODUCE AN 85% TOP BAND.
**PROPOSED, NOT TAKEN — ENEMY COUNT AT THE TOP OF THE LADDER. The number: budget 12 fields 5.9
enemies against budget 9's 5.4 — 9% more bodies for 33% more budget**, so the top step buys
per-enemy quality rather than a bigger fight. Beside it, **`alive@r3` is 0.0 at EVERY budget
on the built row** (0.0-0.3 ungeared) — the field is empty entering round 3 everywhere, Batch
S's finding, unmoved. Count is the only one of the four levers that moves both: it raises
incoming actions per round (**attrition is the sensitive dial — deaths/battle swings 0.02 ->
0.96 across the ungeared ladder, 48x, while win% moves 7 points**) and it puts a field on the
board for the round the AoE specs are balanced around. Expect win% down at 9-12 and barely at
3-6, deaths/battle up at the top, `alive@r3` off the floor, and shares to shift toward the AoE
specs — which is diagnostic, not a side effect. **NOT enemy attack** (moves deaths but leaves
`alive@r3` at 0.0 — harder in the least interesting way); **NOT enemy health** (fights already
run 12.3 rounds ungeared at 12, and one stalemate already appeared); **NOT the budget curve**
(that moves WHERE a budget sits on the road, a run-shape lever for a `--run` measurement).
**THE 08-02 NOTE BELOW SAYS DIFFICULTY IS CLOSED AS A SIM QUESTION AND NOT TO PROPOSE CHANGES
UNSOLICITED. BF's brief SOLICITED this read explicitly and argued the older reason had
expired. Re-opened BY REQUEST, measured only, nothing changed** — the note stands for
unsolicited difficulty work and this was not that.
**AND THE BUILT ROW FOUND A CRASH — an infinite recursion between `_hold_release` and
`_hold_freeze` that a Cryomancer with Honed Shards reaches in normal play. PRE-EXISTING (23
events per 400 budget-12 battles, IDENTICAL COUNT on unmodified HEAD at matched n), NOT FIXED
HERE, and it is now the FIRST open thread.** The same HEAD run also reproduces the built
budget-12 row (100% / 7.8 rounds / 0.22 deaths against this build's 100% / 7.6 / 0.21), which
is the independent evidence that §1 and §2 moved no difficulty.

BATCH BD (08-09) — DEADFALL BECOMES A PLACED HAZARD. **ONE ABILITY.** No tree is touched, no
magnitude in the tree moves, no other spec is involved, no save version moves (still v7).
§0 **THE FINDING, WHICH IS WORTH MORE THAN THE RE-SPEC: DEADFALL AND SNARE TRAP WERE THE SAME
ABILITY, AND HAD BEEN FOR FOURTEEN BATCHES.** Same 20 Mana, same 2.0 initiative, same 3
cooldown, both traps, both against the same trap cap, both a 1-turn stun springing at the
victim's turn start. **The single distinction was that Deadfall does not let you pick — and its
PERFECT handed that back.** It also ran against his own spine: Trapper pays +8% per DIFFERENT
status, Snare Trap lands two (three with Quick Rigging), Deadfall landed one.
§1 **RE-SPECCED: 25 Mana, 2.0, 5cd, UNTARGETED. The next enemy to act takes 20% of Attack as
nature damage and is Stunned 1 turn; the trap then lies DORMANT 2 TURNS, re-arms and springs
again — THREE TIMES IN ALL. Perfect: FOUR.** Per-spring damage 35% -> 20% because there are
three of them. **UNTARGETED IS THE DESIGN NOW RATHER THAN THE DRAWBACK, so the perfect can no
longer name the victim — that clause is exactly what collapsed the two abilities and it would
have survived any re-spec that did not delete it deliberately.** Bosses shrug the stun unless
Broken, by the ordinary rule (the spring passes no `force_stun`); the synergy that falls out
rather than being designed in is that **three attempts across a fight means a Snares build
grinding a boss's Break gets its stun the moment the Break lands**, without the perfect rig
Snare Trap needs.
§2 **`deadfall_armed` IS THE SAME FIELD WITH A DIFFERENT UNIT — THE CLASS OF CHANGE THAT FAILS
SILENTLY.** It counted ARMED TRAPS and counts **CHARGES REMAINING** on the one deadfall a cast
places. Every read site moved with it, and **the trap-cap gate is the one that would have
failed quietly: a charged deadfall is ONE occupant however many springs it has left.** Left
alone, a three-charge trap would have filled Deadfall Network's cap of three by itself and
spent the node the rule exists to make valuable. `deadfall_dormant` is new (and is deliberately
NOT in `Runes.STAT_INT_KEYS` — no rune writes it). **`deadfall_aims` IS DELETED WITH ITS READ
SITE** (the BA precedent — a field nothing can write goes, so a later batch cannot write one);
the test asserts the field **DOES NOT EXIST** rather than that it is empty.
**THE REST-AND-SPRING RULE IS ITS OWN FUNCTION, `_deadfall_tick(u)`** — `_run_battle` cannot be
driven headlessly (the AR trap), so a rule left inside it can only ever be checked by a grep
and its negative controls could never fail (the AW `_ground_faith_tick` / BA
`_perfected_toxin_tick` precedent). **ITS POSITION IS LOAD-BEARING AND ASSERTED: it runs ABOVE
the stunned branch**, so the stun a spring lands costs the victim the very turn it walked into
the trap. Three constants in one place: `DEADFALL_CHARGES` 3, `DEADFALL_DORMANCY` 2,
`DEADFALL_SPRING_PCT` 0.20. **THE CHIP IS WRITTEN BY ONE FUNCTION, `_stamp_deadfall_chip`,
THREE CALLERS** (cast, rest, spring) — `DF3` armed and ready, **`DF2·2`** for two springs left
and two turns of rest. NOTE the visible text is `short`, not `label` (the AT gotcha).
**THREE TALENT NODES NOW PAY PER SPRING AND THAT IS THREE TIMES WHAT THEY USED TO. MEASURED,
not estimated: BONE BREAKER PAYS 90 BREAK ON EACH OF THREE SPRINGS = 270 ACROSS A FULL
DEADFALL** — the largest number in the batch and possibly the most Break any single cast in the
game produces; **Cruel Devices multiplies each spring by 1.5** (81 damage across three at 100
Attack, against 30 for one 35% spring); **Caught Fast is re-applied on every spring**, so five
turns of unhealable becomes a rolling lock. None of the three is changed here.
§1 **THE SLOT RULE SHIPPED WITH ITS NUMBER, WHICH IS THE POINT OF THE SECTION. A deadfall holds
one trap slot for as long as it has springs left**, and the gate is instrumented AT THE REFUSAL
(`trap_report_line()`, static, shared by the standalone report and RunSim's — the
`ruin_report_line` pattern; "" when no deadfall was ever armed). **KIT SMOKE, n=200, lineup
berserker,pyromancer,inquisitor,mystic with Deadfall granted:**
· **BASE CAP OF ONE (no talents): 1.06 casts/battle, 2.24 springs/battle, 2.10 springs per
cast; Snare Trap cast 1.4/battle and REFUSED BY THE CAP 3.03/battle — ALL 3.03 OF THEM WITH A
CHARGED DEADFALL HOLDING THE SLOT.**
· **FULL SNARES LANE (Deadfall Network, cap 3): 1.03 casts, 2.42 springs, 2.35 per cast;
Snare Trap cast 2.6/battle, REFUSED 0.00.**
**THE DEADFALL BLOCKS A SNARE TRAP CAST ABOUT THREE TIMES A BATTLE AT THE BASE CAP — MORE OFTEN
THAN SNARE TRAP IS ACTUALLY CAST — AND DEADFALL NETWORK NEARLY DOUBLES HIS SNARE CASTS (1.4 ->
2.6).** The clause does exactly what it was expected to do, at a size worth knowing. **SHIPPED
HOLDING A SLOT AS SPECIFIED; the alternative is ONE CONDITION at that same gate and the
decision now has a measurement instead of a guess.** **SECOND FIGURE WORTH HAVING: SPRINGS PER
CAST IS 2.10, NOT 3** — a smoke fight ends in seven rounds and the third charge often never
lands, **so the 270 Break above is a full-deadfall CEILING rather than a typical fight.** A run
is where that number will mean something. Survivalist rows for context only, NO difficulty
signal (Batch R): base cap 27% share (170/battle), breadth 1.25; SNARES 28% (178), 1.56.
§3 **THE BOT ARMS IT EARLY. Deadfall moved from LAST in the rotation to directly below Snare
Trap**, gated on `u.deadfall_armed <= 0` — the cap refuses a second at a cap of one, but
Deadfall Network would not, and two deadfalls are not a thing. **§3'S OWN INSTRUCTION TO VERIFY
THE ROTATION AT ITS SITE FOUND THE BRIEF HALF STALE**: it describes the order as `snare -> venom
coat -> hamstring -> harvest -> deadfall`, and the code reads `snare -> hamstring -> venom coat
-> harvest -> hamstring AGAIN -> deadfall` (BA put breadth before depth). Corrected toward the
code; the move is unaffected. Instrument honesty, not tuning: NO DIFFICULTY MEASUREMENT.
§4 **OPEN THREAD, RECORDED AND NOT ACTED ON — see the entry in "Known open threads" below.**
Batch AH's curation rule checks a CLASS-pool entry against a sibling spec; **nothing has ever
checked a SPEC pool for redundancy against its own base kit.**
VERIFIED: check_parse 0, check_flow 0 (6 screens), 11 scenes 0 SCRIPT ERROR, run-harness gates
1/2/3 PASS. NEW test_batch_bd.gd **69/0**.
NEGATIVE CONTROLS RUN, the three §6 named plus one of its own, each applied and reverted (the
suite came back to 69/0 after the last): **a spring not decrementing the charges trips 10**, the
dormancy not blocking a consecutive spring trips 5, the slot never freeing after the last charge
trips 2, and **the cap counting CHARGES as occupants — the unit change simply un-made — trips
2.** That last is the one worth having: it is the failure the rename invites and nothing else in
the game would have complained about it.
**THREE TEST RE-POINTS, each with the reason in the file:** test_batch_ah's perfect-text map
reads "A fourth spring."; **test_batch_ah_battle's Deadfall check was written to cover the
human-only target picker this batch DELETES**, so it drives what survives underneath (does a
perfect rig pay more) and asserts the old field gone — **65 -> 63 checks**; and test_batch_ba's
trap-cap check fills the cap with REAL occupants (a deadfall plus snares), because the unit of
the field it drove changed under it.
Regression, everything else at its BE count with ZERO DRIFT — ah 5587, ai 2036, an 6052, aj 403,
ak 527, al 559, ar 887, as 387, at 461, au 335, av 315, aw 338, ax 329, ay 455, az 489, ba 647,
bb 172, bc 91, be 31, test_runes 2973, test_rune_battle 96, all 0 failures.
LIVE AUTOPLAY clean (0 SCRIPT ERROR) and it reads correctly in a real fight: "Deadfall armed —
4 springs, and it holds a trap slot until spent" / "a perfect rig: a fourth spring", then
"springs on Orc Archer — 3 spring(s) left, resting", the stun costing the Archer that turn, and
the trap returning twice more across the fight.

BATCH BE (08-09) — COMMUNION, 40 -> 15. **ONE NUMBER.** Nothing else in the game moves — no
other magnitude, no re-spec, no spec touched, no save version (still v7). Every id survives.
§1 **`dv_communion` PAYS 15, NOT 40** — the chance is `(15 x the RECIPIENT's own Faith
stacks)%`. The counter keeps its meaning and its units (AW's reprice took it 20 -> 40; this
takes it below where it started). **THE REASON, ATTACHED SO NOBODY RE-RAISES IT: BC's
leave-one-out grid read this one row-1 node at 80% contribution against 47% withheld, healing
2255 against 444.** The mechanism the number fixes: **at 40 an ally holding three or more
stacks advanced with CERTAINTY** (120%), so a release deterministically produced further
releases and the chain sustained itself; **at 15 nothing is ever guaranteed** — 15% at one
stack, 45% at three, 60% at four — so it decays. **THE COUNTER IS WRITTEN BY EXACTLY ONE NODE
AND NO RUNE**, asserted off the live trees, so the reprice reaches every payer.
§3 **THE RE-MEASURE, BOTH METHODOLOGIES, n=200 EVERY ROW, BC's lineup
(berserker,cryomancer,inquisitor,beastmaster). Contribution | healing/battle |
releases/battle | healing per release:**
**ONE-HERO** (BC's grid, the only baseline that exists): FAITH all eight **80% | 2255 | 32.21
| 67 at 40 -> 73% | 1555 | 22.77 | 65 at 15**; −Communion **47% | 444 | 7.08 | 60 -> 48% | 450
| 7.17 | 59** (a CONTROL — a build with no Communion cannot see this change, and it reproduces);
−Apostle **73% | 1510 | 20.27 | 67 -> 63% | 910 | 12.70 | 65**.
**ALL FOUR BUILT INTO THEIR OWN FULL LANES** (the honest number): FAITH **55% | 695 | 10.54 ->
45% | 429 | 6.55 | 62**; −Communion **24% | 137 | 2.21 -> 25% | 139 | 2.25 | 59** (control,
reproduces); ungeared **11% -> 11% | 14 | 0.47 | 25**.
**HEALING PER RELEASE DOES NOT MOVE IN ANY ROW — that is the check that the lever landed on
the axis it was aimed at.** It was a frequency problem and the change bought frequency.
**NEW AND WORTH KEEPING: THE ALL-FOUR LANE CONTROL SET, which did not exist** (BC's lane
controls are one-hero only, so its all-four rows had nothing to be read against). Same lineup,
n=200: **FAITH 45% | ZEAL 31% | BULWARK 14% | ungeared 11%.** Use these rather than
re-deriving them. The other-three lanes used were berserker Bloodletting + cryomancer Thaw +
beastmaster devotion; **BC did not record its own lane string, so the all-four rows here are
comparable in CONSTRUCTION and its controls reproduce, which is the evidence they are
comparable in fact.**
**WAS IT ENOUGH? NO, AND §3's OWN BAR SAYS SO.** FAITH should sit near his other two lanes
rather than at twice them: one-hero **73% against ZEAL 42% / BULWARK 23%**, all four **45%
against ZEAL 31% / BULWARK 14%**. The gap narrowed **1.9x -> 1.7x** one-hero and **1.8x ->
1.45x** all four. **A REAL REDUCTION, NOT THE WHOLE REPAIR — and per §3 it was NOT chased with
a second change.** (BC's one-hero lane controls were NOT re-run and did not need to be: the
roll sits behind `communion_ranks > 0`, so a build without the node makes no draw at all and
those rows are byte-identical by construction.)
§2 **THE LIVE OPEN QUESTION, WITH ITS MEASURED NUMBER. COMMUNION READS THE RECIPIENT'S
*CURRENT* STACKS AND APOSTLE PARKS ALLIES AT 5 RATHER THAN RESETTING THEM — SO IN AN APOSTLE
BUILD THE CHANCE IS NOT 15%, IT IS 75%**, and every advance on a parked ally is itself a
release. Three parked allies at 75% is ~2.25 expected advances per release; above one the loop
sustains, and it does. **THE MEASUREMENT TURNS THE WORRY ROUND IN A WAY NOBODY PREDICTED: AT
40 APOSTLE WAS WORTH 7 POINTS, AT 15 IT IS WORTH 10** (80->73 against 73->63), and the releases
it buys go from +59% to +79%. **THE REPRICE MADE THE CAPSTONE MORE VALUABLE, NOT LESS**, and
the reason is BC's saturation finding: at 40, Binding Oath's three parked stacks already rolled
120% — a certainty — so Apostle's five bought nothing but redundancy; at 15 three stacks roll
45% and five roll 75%. **Two nodes stopped being redundant back-ups for each other, which is a
better tree, and it is also why the row did not fall as far as the arithmetic suggests.**
**TWO CANDIDATE LEVERS, BOTH RECORDED AS *NOT TAKEN*, so the next batch starts from a decision:**
· **COMMUNION READS STACKS ONLY BELOW 5** (a parked ally is invisible to it) — one condition at
the existing gate. **THIS IS THE ONE TO TAKE, and the reason above all others is that ITS
LANDING ZONE IS ALREADY BRACKETED BY A MEASURED ROW:** under Apostle it makes Communion nearly
inert (allies sit at 5 permanently, so it fires at most once per ally crossing 4->5), putting
the build between the −Communion row and the full row — 48-73% one-hero, 25-45% all four.
Nothing else on the table has its outcome pre-measured. It attacks the COUPLING rather than the
output, does not care WHICH node parks the ally, and leaves Communion whole in the seven builds
that never take Apostle. **Against it, honestly: 60% at four stacks and 0% at five is a cliff
that must be said in the tooltip, and two nodes in one lane cancelling each other is a smell.**
· **COMMUNION FIRES AT MOST ONCE PER BATTLE TURN** — the `_communion_chain` guard already proves
a limiter fits at that site. **Rejected for now**: its bite depends on fight length, so it
barely binds in a seven-round smoke and binds hard in a long boss fight, which is the wrong way
round, and "a battle turn" has to be defined before it can be priced.
§4 **ANSWERED, AND THE ANSWER IS THE INSTRUMENT — SEE THE STANDING NOTE "WHAT A CONTRIBUTION
SHARE CANNOT SEE" AT `_contrib_table` BELOW.** Short version: **the contribution share is
(damage + healing + damage-PREVENTED) over the same three pooled, and Break points appear in
NEITHER the numerator nor the denominator.** So Devoutness's 0 in BC's grid is a blind spot,
not a dead node — and the blind spot is far bigger than the Devout. **NOTHING CHANGED; THIS IS
THE ITEM THAT GATES A DIFFICULTY PASS, not the Devout repair.**
**THE `_communion_chain` GUARD IS NOT A MAGNITUDE AND MUST SURVIVE ANY REPRICE.** At 40 it
stopped a certainty; at 15 it stops a decaying random walk that is still unbounded. Driven at
the new value both ways: one release with three parked allies banks **at most one release per
hero** (worst seen 4 of a cap of 4), and the latch is a **re-entrancy lock, not a
once-per-battle limiter** — a second release still rolls.
VERIFIED: check_parse 0, check_flow 0 (6 screens), 11 scenes 0 SCRIPT ERROR, run-harness gates
1/2/3 PASS. NEW test_batch_be.gd **31/0**, and **the three rates in it are MEASURED over 1200
driven releases apiece rather than read off the formula** (a test that re-derives the
expression it checks proves nothing): **1 stack 14.2% (want 15), 3 stacks 47.9% (want 45, was a
CERTAINTY at 40), an Apostle-parked ally at 5 stacks 73.7% (want 75)** — so §2's concern is
pinned as a number in a test rather than as prose.
NEGATIVE CONTROLS RUN, four, each applied to the code and reverted (the suite came back to 31/0
byte-for-byte after the last): **the PAYLOAD back at 40 while the tooltip still says 15 trips 6**
(all three measured rates among them — 39.2%, 100%, 100%), **the TOOLTIP back at 40 while the
payload still pays 15 trips 3**, **the chain latch never lowered trips 66**, and **the roll
reading a CONSTANT 5 instead of the recipient's stacks trips 3** — that last is the control that
proves the rates are measured rather than re-derived, because the five-stack row still passes
while the other two do not.
Regression, every suite at its BC count with ZERO DRIFT — ah 5587, ah_battle 65, ai 2036,
an 6052, aj 403, ak 527, al 559, ar 887, as 387, at 461, au 335, av 315, aw 338, ax 329, ay 455,
az 489, ba 647, bb 172, bc 91, test_runes 2973, test_rune_battle 96, all 0 failures — with
**THREE RE-POINTS IN PLACE, each with the reason in the file**: test_batch_aw's magnitude probe
reads **15** (that file is where the node was priced at 40), test_batch_ah's master.html **STAMP
GATE bumped BB -> BE**, and test_batch_bb's DUPLICATE of that gate moved with it.
**ONE PRE-EXISTING BREAKAGE FOUND AND REPAIRED — READ THIS, IT IS A SHAPE THAT WILL RECUR.**
test_batch_bb sliced the changelog on the bare phrase `"Batch BB"` to prove its own entry carried
Batch BB's detonation numbers. **BC's entry then used that phrase in its own regression line**
("every suite at its Batch BB count"), which moved the FIRST occurrence above BB's heading — so
from BC onward the slice was the TAIL OF BC'S ENTRY and all four assertions failed for a reason
unrelated to what they asked. **REPRODUCED ON UNMODIFIED HEAD before it was touched, so it is
NOT this batch's**; the anchor is the `<h2>` heading now, ending at the next one. **The four
assertions are byte-unchanged.** The general rule: **a doc assertion anchored on a phrase a later
document can reproduce is a test that stops asking its question, silently** — and BC's own
regression line is the thing that broke it, so the next batch's changelog can do it again.
LIVE AUTOPLAY clean (0 SCRIPT ERROR) and **THE CHANGE IS VISIBLE IN A REAL FIGHT rather than
only in the aggregate**: a release under Apostle spreads to two of the other three heroes on one
turn and all three on the next. At 40 it reached all three every single time.
NO DIFFICULTY MEASUREMENT AND NO SIM ROW beyond §3's — same as AJ/.../BC.

BATCH BC (08-09) — DECOMPOSING THE DEVOUT'S FAITH ROW. **NO GAMEPLAY CHANGE SHIPPED.** No
magnitude moves, no node is re-specced, no spec is touched, no save version moves (still v7).
Instrumentation only, and the measurement it made possible.
§0 **THE INSTRUMENT, FIRST, BECAUSE IT REFRAMES EVERY LANE ROW IN THIS FILE — see the STANDING
NOTE at `DOD_SIM_TALENTS` above, which is where it belongs and where it will be looked for.**
Short version: the harness is PER-HERO, all 288 node ids are disjoint, so a one-spec flag
string builds one hero, **and nothing is broken.** Re-run with all four heroes force-learned
into their own full 8-node lanes, the FAITH row reads **55% (their standout lanes) / 58%
(their weakest) against 80% one-hero — a TIGHT BRACKET, so the answer does not depend on which
lanes the other three were given.** Roughly a quarter of the 80% was methodology. **THE LANE
COMPARISON SURVIVES INTACT** — ungeared 18% -> 11% and FAITH 80% -> 55%, i.e. 4.4x becomes
5.0x — so **only a row that was read as an ABSOLUTE owes a re-measure.**
§1/§2 **THE ANSWER IS FREQUENCY, DECISIVELY. THE ROW IS LARGE BECAUSE IT RELEASES A GREAT MANY
TIMES, NOT BECAUSE IT PAYS A LOT PER RELEASE.** Across the whole lane the payout per release
roughly triples (24 -> 67 HP) while releases go up **TWENTY-FOUR-FOLD (1.33 -> 32.2 a
battle)**. Three of the eight nodes multiply frequency, ONE multiplies magnitude.
**THE LEAVE-ONE-OUT GRID IS IN THE CHANGELOG AND IS THE DELIVERABLE — a later batch should
design against it, the way difficulty designs against Batch V's sweep table.** Fixed lineup
berserker,cryomancer,inquisitor,beastmaster, **n=200 EVERY ROW**, one node withheld at a time
(contribution | healing/battle | releases/battle | healing per release):
**full lane 80% | 2255 | 32.21 | 67**; −Communion **47% | 444 | 7.08 | 60**; −Blessed are the
Faithful 64% | 973 | 30.86 | **29**; −Fervor 64% | 956 | **14.19** | 64; −Apostle 73% | 1510 |
20.27 | 67; −Unwavering Faith 78% | 2040 | 30.66 | 64; −Sacred Covenant 79% | 2158 | 30.84 |
67; −Binding Oath 79% | 2123 | 30.43 | 67; −Devoutness **80%** | 2291 | 32.70 | 67.
Controls, same n: **BULWARK 23% | 88, ZEAL 42% | 363, ungeared 18% | 41** — so the gap to
attribute is 18% -> 80% and the other two lanes sit at 23% and 42%. **IT IS A FAITH-LANE
PROBLEM, NOT A DEVOUT PROBLEM**, and those want different repairs.
**COMMUNION IS THE ROW AND IT IS NOT CLOSE**: one row-1 node takes the headline 80% -> 47% and
the healing 2255 -> 444. The mechanism is legible once the number points at it — Communion
rolls *40% x each other member's own Faith stacks*, and **APOSTLE PARKS EVERY ALLY AT 5, SO
THE ROLL IS 200%, i.e. CERTAIN, FOR ALL THREE OF THEM. One release becomes four.** They are
not two terms, they are one engine, and Communion is the half that multiplies.
**DEVOUTNESS MOVES THE HEADLINE BY ZERO** — it pays only in Break points, which a contribution
share cannot see. Real value, invisible instrument; do not read its 0 as a dead node.
§1 **WHY THE LAST TWO FIXES UNDER-DELIVERED, WITH A NUMBER ON IT AT LAST. Conviction's growth
— the term AY halved precisely — is 97 of the row's 2255 healing a battle, 4.3%.** Halving
4.3% of something cannot move it. **THE NEXT LEVER THE ROADMAP NAMES (the growth's base step,
3% -> 2%) IS THE SAME TERM AGAIN AND IS WORTH ~1.4% OF THE ROW. EXPECT IT TO UNDER-DELIVER FOR
THE SAME REASON.** Reported, NOT acted on — the repair is its own batch.
§1 **FIVE EFFECTS WERE CREDITING NOBODY AT ALL**, two of them the largest single heal in their
own lane. Blessed Barrier's conversion and Afterglow's mend fire inside `unit.gd`, which
cannot reach the sim ledger, and simply vanished; **Healing Pulse** and the **Bulwark of
Fortitude** tick fire in battle.gd and were never booked; and **Devoutness's Break reduction
was counted nowhere in the game.** All five are instrumented now. **CONSEQUENCE, STATED SO THE
ROWS CAN BE RECONCILED RATHER THAN TRUSTED: BATCH AW'S BULWARK AND ZEAL ROWS ARE SUPERSEDED ON
THE HEALING AND CONTRIBUTION COLUMNS — ZEAL reads 42% against AW's 27% because Healing Pulse
alone is 219 of its 363 healing. Take the newly-counted terms back out and ZEAL reads 144
against AW's 134, BULWARK 50 against AW's 48, ungeared 41 against AW's 40. THE FAITH ROW IS
UNTOUCHED BY ALL OF IT** — a FAITH build learns none of the five nodes involved, which is
exactly why §2's grid is comparable with every historical FAITH row.
FIELDS/MACHINERY, all instrumentation: **`faith_report_line()`**, static, shared by the
standalone report and RunSim's on the `ruin_report_line` pattern, `""` when no Devout stood;
**`_devout_heal(owner, amount, term)` and `_devout_prev(owner, cut, term)` are ONE booking door
each**, so the parts can never disagree with the total; **`BattleUnit.credit_cb`** is one new
callback carrying the three effects unit.gd computes that battle.gd cannot see, with the TERM
NAMED AT THE SITE that computes the number; `prevented_cb` gained a 4th arg, the `divine` flag,
because "prevented" pools every barrier in the game and the split needs Divine Shield's alone.
**THE DENOMINATOR IS `conviction_battles`, THE COUNT AW ALREADY BANKED** — one denominator, one
answer. **§2 NEEDED NO NEW HARNESS FLAG**: withholding a node is seven ids where there were
eight, which `DOD_SIM_TALENTS` already does.
**ONE LOG-HONESTY FIX FOUND BY INSTRUMENTING IT:** Blessed Barrier discarded `heal_amount`'s
return, so its log line and float reported the heal it ASKED for rather than the one that
LANDED — a heal into a full bar read exactly like one into an empty bar. It reports what
landed now. (The BA "-1 turns" precedent: watching an instrument finds these.)
VERIFIED: check_parse 0, check_flow 0 (6 screens).
11 scenes 0 SCRIPT ERROR. NEW test_batch_bc.gd **91/0** (its 8 live checks each bump a counter
asserted at the end — **a live check that THROWS mid-way aborts its own function while the
suite still prints "0 failures", and this batch hit exactly that**: `_resolve` is
`(attacker, ability, target, grade)` and a wrong argument order threw silently).
Regression, EVERY suite at its BB count with ZERO drift (this batch adds no gameplay and no
pool entry, so a moved count would itself be the finding): ah 5587/0, ah_battle 65/0,
ai 2036/0, an 6052/0, aj 403/0, ak 527/0, al 559/0, ar 887/0, as 387/0, at 461/0, au 335/0,
av 315/0, aw 338/0, ax 329/0, ay 455/0, az 489/0, ba 647/0, bb 172/0, test_runes 2973/0
(with its ONE pre-existing `start_rune_enabled` SCRIPT ERROR from a name AN retired — still
0 failures), test_rune_battle 96/0. Run-harness gates 1/2/3 PASS.
NEGATIVE CONTROLS RUN, five, each applied to the code and reverted (the suite was re-run
after the last revert and came back to 91/0 byte-for-byte): **every barrier counting as a
Divine Shield trips 2, folding Devoutness's Break points into damage-prevented trips 2,
Blessed Barrier banking the heal it ASKED for rather than the one that LANDED trips 1,
un-crediting Healing Pulse again trips 2, and not banking the release COUNT at the release
trips 2.**
**KNOWN-BAD, NOT OURS, AND THE DIAGNOSIS IS NEW — AR'S "the standing test_rune_battle defect
is CLOSED, stable 5/5" IS ONLY HALF TRUE.** `"pyromancer: rune_resist_pierce never fired
against a resistant warband"` failed 1 run in 8 here (and passed 4/4 on a STASHED,
unmodified HEAD, so it is not this batch). **THE RESIDUAL CAUSE IS NAMED SO IT DOES NOT GET
RE-DIAGNOSED: the check drives `_resolve` by hand and `test_rune_battle.gd ARMS `no_cover`
NOWHERE IN THE FILE`** — grep it — **so the forced hit still rolls the 5% miss, and a missed
hit writes no resist line at all.** AR fixed whether the line SURVIVES TO BE READ (the log
snapshot); it did not fix whether the line gets WRITTEN. The fix is one line at the forced
hit, the AK/AL/AR discipline this file already states — **REPORTED, NOT TAKEN, because this
batch changes nothing.**
**master.html IS UNTOUCHED — nothing about the game changed**, so test_batch_ah's STAMP GATE
stays pinned at BB deliberately. Do not bump it for a batch that ships no design change.

BATCH BB (08-09) — CLEARING THE DECK. Six repairs carried over from the twelve spec batches.
NO spec re-authored, NO magnitude retuned, NO tree touched; every id survives, NO SAVE VERSION
MOVES (still v7).
§3 **THE NUMBER, FIRST, BECAUSE IT IS WHY THE BATCH EXISTS. `ruin_report_line()`, 40-run line,
Ruin lane rows 1-7, threshold 10: `trash 0.07 (n=566, deepest mark 31) | boss 0.60 (n=25,
deepest mark 18)`.** Against AX's **trash 0.00 (n=519, deepest 10) | boss 0.13 (n=23, deepest
12)** and AY's **trash 0.06 (n=774, deepest 20) | boss 0.35 (n=52, deepest 32)**. **TRASH IS
NOT ZERO AND THE THREAD CLOSES: §3's own condition for escalating to the *first detonation at
5, every 10 after* variant was "if trash is still zero", and it is not.** THAT VARIANT REMAINS
UNSHIPPED AND IS STILL NOT TO BE TAKEN ON A BATCH'S OWN INITIATIVE. **NO CHANGE SHIPPED OFF
THIS MEASUREMENT.** Read the boss half as the real movement (0.13 → 0.35 → 0.60) and the trash
half as flat-but-alive. **TWO HONEST CAVEATS: §3's premise was HALF STALE** — AY §8 did print
both halves, but only into CLAUDE.md's AY block; **the CHANGELOG never carried the number,
which is what §3 was really asking for and what this batch's entry fixes** — and **this row
was measured with Rot in the bargain pool** (the bot took it 0.60/run), which AX's and AY's
rows could not have, so it is a 20-modifier row against two 19-modifier ones.
§1 **THE PACK'S SWAP RULE REVERTED TO BATCH Q'S** — see the standing rule below; AY's
"replaces the older" was a regression and is named as one so it cannot be "fixed" back.
§2 **CREEPING DEATH GAINED ITS SECOND CLAUSE** (stack a permanent poison, refresh a clocked
one; the stack half governed once per enemy per turn) — see the standing rule below.
§4 **`_ghost_hit` BOOKS ITS DAMAGE NOW.** AY §0 reported Call of the Wild's bodiless blows
crediting nothing and correctly left it; BB credits them through the SAME resolution
`_companion_hit` uses (`comp_credit` / `ghost_credit`, both behind `if not victim.is_hero`),
so the two sites cannot drift. **NO BREAK HALF EXISTS TO MIRROR — VERIFIED AT THE SITE rather
than assumed: `_ghost_hit` calls `take_hit(final, 0)`, a hardcoded pressure of zero.** It is a
trophy ability, so this changes NO balance; it changes whether a Beastmaster who earned Call
of the Wild is measured honestly.
§5 **ROT, REINSTATED AT SEVERITY 4** — see the victory-sync standing rule below. AQ's stated
target of four severity-4 modifiers is met (pool 20, counts 6/6/4/4).
**ONE READ VERIFIED RATHER THAN TRUSTED, AND THE BRIEF WAS SLIGHTLY WRONG: §5 says the
percentage effects reading `max_hp` "are all ratios, so they scale correctly". THREE OF THE
FOUR ARE** — Unkillable's mend is `(max_hp - tenacity_hp_gained) * 8%/rank`, Conviction's
growth is 3% of a base captured from the halved maximum, the Mercy window is a ratio.
**TENACITY IS NOT: it adds a FLAT +15 max HP per Heavy Plating block**, so under Rot it claws
back a slightly LARGER share of a smaller pool. Nothing absurd and nothing near AQ's feared
runaway, so it ships untouched — but the paragraph should not be repeated as written.
§6 **ASHES OF AL'AR GOT ITS HOME, AND THE BRIEF'S "one array entry" WAS NOT ONE.** It has
never been an Ability — it was a Pyromancer TALENT, a passive guard in `unit.take_hit` /
`take_tick_damage` — and a pool entry must resolve through `Classes.pool_ability` to an
Ability. So the batch authored **the wrapper, exactly on AH's vault precedent** (seven of the
ten vault entries "needed a cost/cooldown/initiative wrapper around effects the handler
already defines exactly, and THOSE NUMBERS ARE NEW"): **30 Mana, 2.5 initiative, no cooldown,
self-cast, `special: "ashes"`; the next lethal blow this battle returns him at 25% health
(perfect 40%), once per battle.** THE COST OF A TURN IS THE POINT for the spec built on having
no escape hatch. **AND THE SECOND CORRECTION IS THE LOAD-BEARING ONE: `CLASS_POOLS` HAS BEEN
DEAD SINCE BATCH AN §4** — `award_ability_pick` reads `roll_spec_ability_offer`, i.e. SPEC
pools only — so the class-pool entry alone would have been an unearnable answer to a
homelessness thread. **It is in `CLASS_POOLS["mage"]` as instructed (back to twelve) AND in
all three Mage SPEC_POOLS, which is what the live boss draw reads.** Re-opening the class draw
was NOT done: that is a live change to how all twelve specs are offered abilities.
FIELD CHANGES: `rot_hp_lost` (new), `ashes_ranks` → **`ashes_return`** (a real magnitude, the
% returned, replacing a `randf() < 0.11 * ranks` roll that had NO WRITER AT ALL since AR), and
`battle._turns_taken` promoted from a local to a field. **`unit._ashes_guard()` is ONE
implementation with TWO callers** — the clause was written out twice before, which is what let
the copies be re-pointed independently. **REMOVING THE OLD `randf()` SHIFTS NO RNG SEQUENCE**:
that draw sat behind `ashes_ranks > 0`, which nothing could make true (the AQ draw-order
gotcha, checked rather than assumed).
VERIFIED: check_parse 0, check_flow 0 (6 screens), run-harness gates 1/2/3 PASS.
11 scenes 0 SCRIPT ERROR. NEW test_batch_bb.gd **172/0**.
Regression: ah **5587/0 (was 5410 — STAMP GATE bumped BA -> BB, and the count ROSE because
its offer battery walks every pool entry: the Pyromancer's and the Cryomancer's spec pools
went 2 -> 3, so their offers went from two entries to three, 40 trials apiece)**,
ah_battle 65/0, ai 2036/0,
an **6052/0 (was 6047 — the `rot is not in the pool` assertion INVERTS rather than
disappearing: what a later batch could break is not "rot came back" but "rot came back without
its guard", and test_batch_bb owns that half; the modifier count reads off `MODIFIERS.size()`
now so it cannot drift again)**, aj 403/0, ak **527/0 (was 523 — pool entries)**,
al **559/0 (was 556 — same)**, ar **887/0 (was 885 — same)**, as 387/0,
at **461/0 (was 460 — same)**, au **335/0 (was 334 — same)**, av 315/0, aw 338/0, ax 329/0,
ay **455/0, TWO CHECKS RE-POINTED IN PLACE with the reason in the file** (see the swap rule
above — the bot check now reads `_swap_victim`, and `_live_swap_replaces_older` is
`_live_swap_replaces_shallower`: INVERTED, not deleted, with its SETUP byte-identical because
that setup is still the one that tells the two rules apart), az 489/0, ba 647/0,
test_runes 2973/0, test_rune_battle 96/0.
NEGATIVE CONTROLS RUN, the three §8 named plus one of its own, each applied to the code and
reverted: **the swap taking the deeper bond trips 5, Rot's reduction persisting onto the party
member trips 7, Creeping Death stacking once per STATUS rather than once per turn trips 5, and
dropping `_ghost_hit`'s credit trips 4.**
KIT SMOKE, fixed lineup, 40 battles/row, 0 SCRIPT ERROR both rows: a Beastmaster row with The
Pack forced reads **27% damage share (170/battle), deepest Loyalty 8, two beasts standing on
61% of hunter turns**; a Survivalist VENOM row with Creeping Death AND Perfected Toxin reads
**30% (209/battle), breadth 1.94, most seen 7**. Kit-mechanics ratios ONLY; NO difficulty
signal (Batch R).
LIVE AUTOPLAY clean (0 SCRIPT ERROR) and **§2 READS CORRECTLY IN A REAL FIGHT**: "Poison on
Orc Raider (x1 — 2 nature dmg/turn, battle-long)" climbing to x3, then "Creeping Death: the
venom in Orc Raider bites deeper (x4)" ... "(x5)" ... "(x6)" — once a turn, on two different
enemies independently. **A BOT SWAP DID NOT OCCUR IN ANY SMOKE, and that is the §7 margin
rule working rather than a gap**: it needs both slots full, both beasts alive, and the
incoming boon worth 1.25x the outgoing one. The rule is driven directly in test_batch_bb
instead (three live checks plus the bot's pricing), which is where a rare branch belongs.
NO DIFFICULTY MEASUREMENT AND NO SIM ROW beyond §3's instrument row — same as
AJ/AK/AL/AR/AS/AT/AU/AV/AW/AX/AY/AZ/BA.
REPORTED NOT ACTED ON: **TENACITY'S FLAT +15 UNDER ROT** (see §5 above), and **ASHES OF AL'AR
IS A CAST, NOT A PASSIVE** — §6 describes a self-revive the Pyromancer "can have back", and
the pool machinery can only carry an ability, so arming it costs a turn. If the designer wants
the passive shape instead, the honest home is a RELIC (§6's own named alternative), and
reversing this section is four array entries plus one vault case.

BATCH BA (08-09) — THE SURVIVALIST: ATTRITION THROUGH CRAFT. **LAST OF THE TWELVE — EVERY
TALENT TREE IN THE GAME IS NOW PURPOSE-AUTHORED.** One spec only; the other eleven trees and
enemy tuning UNTOUCHED. Every one of his 24 ids survives and re-specs in place, NO SAVE
VERSION MOVES (still v7). His spec id is "mystic" and MUST NEVER BE RENAMED.
SPINE: **ATTRITION — BREADTH OF AFFLICTION, NOT DEPTH OF ONE**, which was already half
written: Trapper's +8% per DIFFERENT status is the cleanest statement of a spine in the game.
**THIS IS THE ONE SPEC WHOSE CEILING IS CORRECT AND IS DELIBERATELY NOT REMOVED.** Overburn
(AR), Loyalty (AY), Focus (AZ), Resonance (AT) and Ruin (AX) all lost theirs; breadth is
bounded by how many distinct debuffs EXIST, which is a design constant rather than a dial, so
there is nothing to take off. Master.html now says WHY, so a later batch does not read it as
an oversight.
§0 **ONE NEW NUMBER, AND FOR THIS SPEC IT IS THE WHOLE BATCH: the average count of distinct
statuses on a target when he strikes it.** That count IS his damage multiplier, so it is the
only figure that says whether §2's carrier re-specs actually worked — a damage share moves for
a dozen reasons, breadth moves for one. `breadth_report_line()` shared by the standalone report
and RunSim's (the `ruin_report_line` pattern), banked AT THE SITE THAT READS IT so what is
recorded is the number the multiplier was computed from, and printed only when a Survivalist
stood. Damage share is ALSO a valid read for him (Pressure archetype) — Batch W has him at
25/25/25/26, the most stable spec in the game across every field size.
§2/§3 **VENOM'S NODES EACH HANG A DIFFERENT AFFLICTION OFF THE POISON.** The lane named for his
signature damage was fighting his own passive: a poison build earned +8% where a five-affliction
build earned +40%. Now **Coated Blades carries Cripple, Distillate carries Exposed, Slow Acting
carries Slowed** — and the pun Slow Acting had left unclaimed since Batch 33 is finally spent.
MEASURED: one application from a Distillate + Slow Acting build lands **THREE distinct
statuses**, i.e. +24% off a single cast. **NECROSIS STAYS EXACTLY AS WRITTEN, NAME INCLUDED** —
tissue death from venom is what venomous bites do, it is craft rather than contagion, and it was
already the only Venom node pointed at breadth.
§3 ALL 24 NODES RE-PRICED AT ROW PRICING, **the Hunter's 3-4x** (AY and AZ's rate, not the
Cleric three's 4-5x). **ALL THREE LANE NAMES AND THESES STAND**, re-aimed only in what Venom's
nodes DO: *the affliction that ticks · the affliction that stops · the affliction that adds up.*
FULL TABLE IN THE CHANGELOG. **FOUR NODES ARE RE-SPECCED RATHER THAN REPRICED, and each names
what it replaced**: `sv_virulence` -> **DISTILLATE** (a rename only — the mechanic and the id
survive); `sv_creeping` -> **CREEPING DEATH, KEEPING ITS NAME** (applying any status to a
Poisoned enemy refreshes its Poison to full duration — he keeps the wound open, the corpse
transfer is gone); `sv_plague` -> **QUARTERMASTER** (his allies' basic attacks also apply HIS
poison — party-wide craft with nothing self-propagating, the closest thing to Plague Bearer's
REACH that stays out of §1's space); `sv_epidemic` -> **PERFECTED TOXIN** (his Poison cannot be
cleansed, never expires, and its tick RISES by 2 each turn it persists — it keeps the
uncleansable identity that made Epidemic a capstone and drops the field-wide infection).
**POTENT TOXINS STAYS FLAT DAMAGE RATHER THAN BECOMING A PERCENTAGE OF ATTACK, deliberately**:
converting it would change `_apply_poison`'s units and every rune riding `potent_ranks` with it,
for a gain the reprice already delivers. 8x the value, same units, no read-site change — **and
that is why the two runes paying into it needed NO re-point and are reported as such.**
**QUARTERMASTER'S POISON IS APPLIED WITH THE SURVIVALIST AS `src`, and that is load-bearing**:
the tick reads HIS Attack and HIS Potent Toxins, the Venom carriers come with it, and the sim
credits the tick to him rather than to whoever swung. Quartermaster is NOT Plague Bearer with
different numbers and nothing may be re-pointed from one to the other.
**PERFECTED TOXIN'S TICK-RISE IS ITS OWN FUNCTION, `_perfected_toxin_tick`** — `_run_battle`
cannot be driven headlessly (the AR trap), so a clause buried in its loop could only ever be
checked by a grep. **CREEPING DEATH SITS ABOVE `_apply_status`'s per-status branches**, because
chilled, burn and poison all return early and a hook below them would silently miss every status
a Cryomancer or Pyromancer lands. It reads the `full` stamp `_apply_poison` leaves rather than a
constant of its own, so a Slow Acting poison refreshes to its DOUBLED span.
§3 **LIVE BUG FOUND AND FIXED — QUICK RIGGING'S COOLDOWN CLAUSE HAS HAD NO IMPLEMENTATION SINCE
BATCH 33.** unit.gd's own comment said "Snare Trap cd -1 (payload)" and no payload existed: the
node's whole payload was `{"stat": {"quick_rigging": 1}}`, so only the Cripple half ever fired
while the tooltip promised both. Same failure shape as AJ's Measured Rage, through a different
door. It is TWO PAYLOADS now via the `also` key (AK) — `apply_payload` is an if/elif chain, so a
node carrying `stat` AND `ability` would silently drop the second, which is exactly how this
would have been "fixed" wrongly.
§6 **EVERY SURVIVALIST COUNTER IS ADDITIVE** (the AR/AS/AT/AV/AW/AX/AY/AZ form). §6 of the brief
named FIVE to convert — `potent_ranks` (8, and its units did not move), `wire_ranks` (35),
`cruel_ranks` (50), `scavenger_ranks` (25), `virulence_ranks` (2) — and **EVERY OTHER NODE WHOSE
MAGNITUDE IS A NUMBER TOOK THE SAME TREATMENT, reported rather than silently generalised** (the
AW/AX/AZ call): `necrosis` 35, `caught_fast` 5, `bone_breaker` 90, `deadfall_network` **3 — the
trap CAP it installs, gate AND magnitude in one field** (AW's `judgement`), `hit_and_run` 2,
`field_medic` 2, `vulture` 60, `ghillie` 65, `improvised` 2 with **`improvised_used` now a COUNT
not a bool** (AZ's `snap_used`), `perfected_toxin` 2, `force_of_nature` 20. **FIVE ARE STILL
HONEST FLAGS** — Coated Blades, Slow Acting, Creeping Death, Snap Shut and Quartermaster (rules,
not amounts). `max_hp_pct` already wrote a real magnitude (0.06 -> 0.20).
**THE THREE COUNTERS THAT CHANGED MEANING RATHER THAN UNITS, which is the harder failure:**
`plague_bearer` and `epidemic` **NO LONGER EXIST AS FIELDS** (deleted with their read sites, not
renamed in place, so a later batch cannot write one), and `creeping_death` **left
`_on_enemy_death` entirely** for the status-application path. **THE RUNE AUDIT CAME BACK CLEAN
AND IS RECORDED RATHER THAN ASSUMED: no spec:mystic or class:hunter rune ever rode any of the
three**, so nothing needed flagging for re-authoring. **THE FOUR SPEC RUNES ALL STILL PAY EXACTLY
WHAT THEY PAID, only the units moved:** the Long Hunt (`cruel_ranks` 1 -> 15, `wire_ranks` 1 ->
10, `potent_ranks` 1 UNTOUCHED because that counter kept its units), the Carrion Wake (`vulture`
1 -> **30**, `scavenger_ranks` 2 -> 16, the scar untouched), the Weeping Wound (untouched —
`coated_blades` is a flag and `potent_ranks` kept its units) and the Quick Spring (an ability
payload, nothing to re-point). **THE THREE HUNTER CLASS-WIDE RUNES TOUCH NO SURVIVALIST
COUNTER**, asserted. **THE FLOAT TRAP BOTH WAYS: `vulture` LEFT test_runes' `BOOLEAN_READ_FIELDS`
and STAYED IN `Runes.STAT_INT_KEYS`** — it was a flag in front of a hardcoded 1.30 and is an int
magnitude now, so it needs the int list exactly as much and the boolean alarm not at all. AZ's
comment predicted this removal by name; prediction and removal are recorded together.
**`coated_blades` IS THE LAST ENTRY IN `BOOLEAN_READ_FIELDS` and cannot leave** — it is a rule,
not an amount. `max_hp_pct` stays OUT of STAT_INT_KEYS (fractional).
§7 **HARVEST NOW PAYS FOR WHAT IT ACTUALLY REMOVED.** It counted BEFORE the purge, so a sticky
poison survived the cleanse and was billed for anyway — a known quirk since Batch 33, minor while
his breadth was narrow, and §2/§3 would have grown the over-count with the batch that caused it.
The count is MEASURED as a delta across the purge rather than predicted. **`_harvest_yield()` is
THE one answer to "what would this reap"**, shared with the bot. MEASURED: against 3 standing / 2
reapable statuses it deals 19 where the old over-count paid ~30. That is a real reduction to
Harvest under Slow Acting and Perfected Toxin builds and it is correct.
§8 THE BOT, two changes. **BREADTH BEFORE DEPTH** — his damage is the COUNT of distinct statuses,
so Snare and Hamstring are gated on the target LACKING what they would add, and another poison
application onto an already-poisoned mark waits below them. **HARVEST'S THRESHOLD MOVED OFF 4**
to `HARVEST_BOT_YIELD` = 3, read off `_harvest_yield` — the same function the ability is paid on,
so the bot and the ability can never disagree about what the button is worth (the AZ Coup
precedent). Instrument honesty, not tuning: NO DIFFICULTY MEASUREMENT IN THIS BATCH.
§4 **BOTH NAMED EXCLUSIVE PAIRS GO, AND THE PROSE LIST IS NOW EMPTY.** Virulence <-> Slow Acting
had already dissolved (Venom rows 3 and 4, so row exclusivity lets a player hold both — which
under §3 means Exposed AND Slowed together, intended and stated); Plague Bearer <-> Deadfall
Network went with Plague Bearer, and its replacement needs no pair because Quartermaster and
three traps sit in the same row 7. **NOTHING REMAINS IN THE LIST** — every pair ever authored has
either dissolved under Batch AI's row exclusivity or is a same-row pair row exclusivity already
enforces, so a later batch is not chasing pairs that have been handled for eight batches.
`test_runes._exclusives` has been a bare `pass` since AI.
§5 **THE TROPHY-POOL COLLISION CANNOT ARISE, and it is recorded rather than left to a reader.**
HIS TREE GRANTS NO ABILITIES AT ALL (Tripwire, Shrapnel Charge and Snare Trap are base kit;
Explosive Shot, Venom Coating, Hamstring, Deadfall and Harvest are boss-trophy pool), so he owes
no AU §1 fallback in either direction. **ASSERTED BOTH WAYS** — no node carries
`grant_ability`/`new_ability`, and a fully-learned tree adds NOTHING to `Talents.ability_names`.
**THAT COMPLETES THE TWELVE, so the fallback ledger closes here — and computing it found the
standing thread was STALE.** It claimed "seven specs, 11 nodes"; the live trees say **TWO specs,
NINE nodes — the Pyromancer (5) and the Cryomancer (4)**, and nobody else owes one. Counted off
`Talents.granted_name` / `Talents.collision_kind` (the two functions the tooltip itself reads),
not from memory, and the thread below is corrected toward the code. **THREE SPECS STRUCTURALLY
CANNOT OWE ONE — their trees grant no abilities at all:** the Beastmaster (AY), the Sharpshooter
(AZ) and the SURVIVALIST (BA). The Inquisitor, Holy, the Occultist, the Berserker, the
Swordmaster, the Warden and the Arcanist all GRANT abilities and all have AUTHORED answers.
VERIFIED: check_parse 0, check_flow 0 (6 screens), run-harness gates 1/2/3 PASS.
NEW test_batch_ba.gd **647/0**.
Regression: ah 5410/0 (STAMP GATE bumped AZ -> BA), ah_battle 65/0, ai 2036/0, an 6047/0,
aj 403/0, ak 523/0, al 556/0, ar 885/0, as 387/0, at 460/0,
au **334/0 (was 257 — the durable half EXTENDED, not re-pointed: the Warrior three joined the
"its batch landed, so it owes no generics" list, and a NEW half pins the three specs whose
trees grant no abilities at all, so a grant quietly added to one of them trips in the file a
later batch actually reads about fallbacks)**, av 315/0, aw 338/0, ax 329/0, ay 455/0,
az 489/0,
test_runes **2973/0 (was 2976 — `vulture` LEFT `BOOLEAN_READ_FIELDS`, taking its three
checks with it, which is the AE alarm doing its job rather than the list decaying: the field
was a flag in front of a hardcoded 1.30 and carries a real magnitude now. THE LIST HAS ONE
ENTRY LEFT, `coated_blades`, and it cannot leave — it is a rule, not an amount. With the
twelfth tree authored, a future entry would be a NEW flag field, not another one waiting its
turn.)**, test_rune_battle 96/0.
NEGATIVE CONTROLS RUN, all four the batch named, each applied to the code and reverted:
**Creeping Death still firing on death trips 2, Perfected Toxin poisoning the whole field at
battle start trips 3, Harvest counting sticky poison it did not remove trips 2, and
Quartermaster's poison being credited to the ally rather than to him trips 4.**
**ONE OF THE FOUR CAUGHT A TEST THAT COULD NOT FAIL, which is the whole reason to run them:**
the live half of negative control 2 read the enemy list 20 process_frames after spawn, but
`_run_battle` OPENS WITH `await _wait(0.6)` ON A REAL SceneTreeTimer — so a reinstated
field-wide infection sailed straight past it while only the two source greps fired. The check
sets `Engine.time_scale = 50.0` for the wait now (the AC gotcha: it scales those timers and
nothing else), and it trips.
KIT SMOKE, fixed lineup, 40 battles/row, berserker,pyromancer,inquisitor,mystic,
DOD_SIM_TALENTS force-learning full 8-node lanes. All rows 40/40 wins, 0 SCRIPT ERROR.
Survivalist damage share / **Trapper breadth (§0's number)**: **ungeared 23% (149/battle),
1.51 statuses per strike (most seen 5); VENOM 28% (187), 1.94 (most seen 7); SNARES 21%
(137), 1.65; GUERILLA 29% (200), 1.53.** Kit-mechanics ratios ONLY; NO difficulty signal
(Batch R).
**§2 ANSWERED BY ITS OWN INSTRUMENT, WHICH IS WHY §0 EXISTS: the VENOM lane raises breadth
per strike 1.51 -> 1.94 and the deepest count 5 -> 7, while its damage share moves five
points.** The carriers are doing what they were written to do, and the damage column alone
would have under-read it — GUERILLA reads a higher share (29%) off a LOWER breadth (1.53),
because Vulture and Force of Nature multiply a count they do not create.
A VENOM row with the trophy abilities granted reads **22% (151), breadth 1.57**, with the
rotation exercised: Snare Trap 1.6 casts/battle, Hamstring 0.9, Harvest 0.3, Deadfall 0.1.
LIVE AUTOPLAY BATTLES clean (0 SCRIPT ERROR), and **BOTH RE-SPECS READ CORRECTLY IN A REAL
FIGHT**: the carriers land beside the stacks ("Poison on Orc Raider (x3 — 18 nature dmg/turn,
battle-long)" then "Slowed on Orc Raider (3 turns)" then "Exposed on Orc Raider (3 turns)"),
and Creeping Death logs "the wound on Orc Archer is opened again (8 turns)" three times in one
fight while NOTHING crawls to a second body.
ONE LOG-HONESTY FIX FOUND BY WATCHING IT: the poison line printed "-1 turns" on a permanent
poison. Every other status has said "battle" for years; only Epidemic could reach that branch
before and **Perfected Toxin reaches it constantly**, so it reads "battle-long" now.
NO DIFFICULTY MEASUREMENT AND NO SIM ROW, deliberately — same as
AJ/AK/AL/AR/AS/AT/AU/AV/AW/AX/AY/AZ.
REPORTED NOT ACTED ON: **PERFECTED TOXIN SWITCHES CREEPING DEATH OFF.** The capstone makes his
poison permanent, and a poison with no clock has no duration to refresh — so a player holding
Venom row 5 AND the Venom capstone owns a node that can never fire. It is legible from both
texts, it costs a row-5 pick rather than a capstone, and the two sit in the same lane so the
build is a deliberate one; but it is a real dead combination and the designer's call, not a
batch's. **QUARTERMASTER IS UNEXERCISED BY THE SMOKE**: the bot's allies almost never take a
0-cost basic when they hold abilities, so its live coverage is the test suite's, not the sim's.

BATCH AZ (08-08) — THE SHARPSHOOTER: PATIENCE. Second of the Hunter three. One spec only;
the other eleven trees and enemy tuning UNTOUCHED. Every one of his 24 ids survives and
re-specs in place, NO SAVE VERSION MOVES (still v7).
SPINE: **PATIENCE — his power is in not looking away.** Focus already carried a real cost
(earned by staying, lost by switching) and master.html already named the tension the spec
exists for, so this is a spine that FITS plus the repricing every unauthored tree still needs.
§0 **THE STANDING INSTRUCTION ON HIS DAMAGE SHARE IS CARRIED FORWARD AND MUST NOT BE
REDISCOVERED AS A CONCERN: Batch W retired the old "Sharpshooter leads damage at 38%" flag as
a stale number from a party that no longer exists, with the words NEVER TUNE AGAINST IT.** He
is mid-pack (32-36%). Damage share IS a valid read for him (Nuker archetype) — unlike the
Cleric three — so **if his rows come back high after this batch that is not automatically a
problem: report it, do not act on it.**
ONE NEW NUMBER, the AY pattern: **the DEEPEST FOCUS reached**, paired with **the critical
multiplier it was paying at that depth** (§1 removes the ceiling, so "how deep does his
patience actually get" stopped being answerable from the design). One `focus_report_line()`
shared by the standalone report and RunSim's (the `ruin_report_line` pattern), banked AT THE
GAIN SITE because a switch, a kill and One Shot all wipe the meter, and printed only when a
Sharpshooter stood.
§1 **FOCUS HAS NO CEILING, AND ITS PAYOFF CONVERTS AT 100.** One rule, one number, split in
two: **the first 100 points each grant +0.5% CRITICAL CHANCE, and every point beyond 100
grants +0.5% of CRITICAL MULTIPLIER instead.** Lethal Aim's x2 becomes x2.5 at 200 Focus, x3
at 300, and it never stops paying — patience buys certainty first, then force. Focus is
otherwise unchanged: +20 on attacking the enemy he attacked last turn, CLEARED on switching,
up to 50 retained on a kill.
**THE CONVERSION POINT IS A FIXED 100, DELIBERATELY, AND NOT "whenever crit chance reaches
100%".** The alternative fails: with Steady Hands, Consistent Aim and Tunnel Vision a built
marksman passes 100% chance at very low Focus, which would make the chance half of his own
passive vestigial and make the conversion depend on what else he had stacked. A fixed
threshold is legible in a tooltip — *the first hundred is your aim, everything past it is your
force* — and it keeps those three nodes meaningful, because they are what buy reliable crits
while Focus is still shallow. **THE 0.5%-PAST-100 RATE IS A BEST GUESS AT A NUMBER, SAID
PLAINLY**; if the tail comes back far past x3-x3.5 the lever is THAT RATE, not the threshold.
**EXACTLY ONE IMPLEMENTATION, ON BattleUnit** (the AT Resonance discipline through a Hunter
door): `FOCUS_CONVERT` 100, `FOCUS_STEP` 0.005, `focus_convert()`, `focus_crit_chance()`,
`focus_crit_mult()` and `lethal_crit_mult()`. battle.gd reads it through the crit-chance
block and the crit-multiplier block, the NAMEPLATE reads it directly (it prints
`Focus N (+X% crit / xY.YY)` and fills toward `FOCUS_BAR_REF` 200 since there is nothing to
fill toward), and the sim instrument reads it too — so a change can never leave one behind.
**`_focus_cap` RETURNS A SENTINEL, `FOCUS_UNCAPPED := -1`, NOT A LARGE NUMBER** — a large
number is a ceiling a later batch reaches by accident (AY's `LOYALTY_UNCAPPED`). **EXACTLY ONE
NODE STILL HANDS IT A NUMBER: Spray of Arrows (50), and that cap IS its cost.**
**TWO CONSUMERS READ FOCUS AS A QUANTITY RATHER THAN A FRACTION AND BOTH WERE CHECKED AT THEIR
SITES:** Coup de Grâce still CONSUMES ALL FOCUS but **READS at most `COUP_FOCUS_CAP` = 200**
(at 400 Focus it would be 400% of missing health), and **One Shot's "at maximum Focus" became
a NUMBER, 200** — `one_shot` is the gate AND the magnitude in one field (AW's `judgement`).
**TWO OTHER `second_max` CONSUMERS NEEDED THE SENTINEL HANDLED, AND THEY ARE THE KIND OF THING
THAT FAILS SILENTLY:** Parched halved `second_max / 2`, which on an uncapped meter would have
zeroed the bar — it halves what he is HOLDING now; and the debug Full Restore set
`second_resource = second_max`, i.e. to -1 — it restores to `FOCUS_BAR_REF`.
§2 **UNWAVERING CHANGES SIDES.** It was the escape hatch (*switching halves your Focus instead
of clearing it*) — a spec about not looking away selling a discount on looking away, from
inside the spine's OWN lane, the same shape as Flame Shield and Stabilize. **RE-SPECCED to
reward staying: each consecutive turn on one enemy grants +10 additional Focus, rising by 10
each turn to a maximum of +50, resetting the moment he switches** (`same_target_turns` is the
streak; `UNWAVERING_STEPS` = 5, so **the cap moves with the magnitude** rather than being a
second number that can drift). **Spray of Arrows stays the honest way out** — it caps Focus at
50 and costs him Tunnel Vision, a real opt-out priced against the spine rather than a
softening of it.
§3 ALL 24 NODES RE-PRICED AT ROW PRICING, **3-4x** (not the Cleric three's 4-5x — his numbers
were never the smallest in the game). **ALL THREE LANE NAMES AND THESES STAND** — Precision,
Penetration and Tempo were never lying about their jobs, so unlike AS's Shatterpoint or AT's
Control nothing needed re-aiming. FULL TABLE IN THE CHANGELOG. **TWO NODES ARE RE-SPECCED
RATHER THAN REPRICED:** Deep Focus (was "the cap rises 100 -> 150", which §1 left with no
premise) now **moves the CONVERSION POINT from 100 to 60** — same name, same lane, a dial on
the new mechanic instead of a dead ceiling raise; and Unwavering, per §2. **NO FORCED
ASSIGNMENT: unlike AR's Ashes of Al'ar or AS's Frost Ward, every one of the 24 ids kept a real
thread to what it used to do**, so nothing is carrying an unrelated design because a slot had
to hold it.
**THE TWO PREMISE CHECKS THE BRIEF ASKED FOR CAME BACK CLEAN, and both are recorded rather
than assumed:** Coup de Grâce's formula at its site really is `raw += (max_hp - hp) * 0.01 *
focus` (the changelog description of it was accurate), and the bot rotation really did already
work `ss_t` — the description in this file was right about the Sharpshooter block. **THE REAL
GAP WAS SOMEWHERE THE DESCRIPTION DID NOT LOOK**, and §7 has it.
**CONSISTENT AIM'S WORDING CHANGE IS LOAD-BEARING, NOT COSMETIC.** It used to *set* the
multiplier to 1.5, coherent only while it was exclusive with Executioner's Eye — and §4 shows
that pair is dead. Written as **−0.5 (the counter holds 50 percentage POINTS)** it COMPOSES:
x1.5 alone, x2.5 with Executioner's Eye alone, **x2.0 with both**, and the trade survives in
every build. **OVERKILL GAINED A SECOND CLAUSE THAT TIES THE LANE TO THE SPINE:** a kill-chain
is the one time switching targets is not disloyalty, so **the carry keeps his Focus in FULL**
rather than dropping it to the usual 50.
§4 **EXECUTIONER'S EYE <-> CONSISTENT AIM IS DISSOLVED.** Batch 32 authored it as a fork and
they sit in Precision rows 4 and 5, so row exclusivity lets a player hold both; the pair list
survives only as prose in this file (`test_runes._exclusives` has been a bare `pass` since AI)
and **that prose is corrected** — the same correction AS, AT, AW and AY each made for their own
trees. **TUNNEL VISION <-> SPRAY OF ARROWS SURVIVES UNTOUCHED**, because both sit in ROW 7 and
row exclusivity enforces it correctly. Stated so a later batch does not "fix" it.
§5 **THE TROPHY-POOL COLLISION CANNOT ARISE, and it is recorded rather than left to a reader.**
HIS TREE GRANTS NO ABILITIES AT ALL (Aimed Shot, Powershot and Hold Breath are base kit; Quick
Draw, Triple Shot, Coup de Grâce, Pinning Shot and Called Shot are boss-trophy pool), so he
owes no AU §1 fallback in either direction. **ASSERTED BOTH WAYS** — no node carries
`grant_ability`/`new_ability`, and a fully-learned tree adds NOTHING to `Talents.ability_names`.
§6 **EVERY SHARPSHOOTER COUNTER IS ADDITIVE** (the AR/AS/AT/AV/AW/AX/AY form). §6 of the brief
named THREE to convert — `lethal_eye_ranks` (50 = percentage points of crit multiplier),
`bonecracker_ranks` (40) and `muscle_memory_ranks` (30) — and **EVERY OTHER NODE WHOSE
MAGNITUDE IS A NUMBER TOOK THE SAME TREATMENT, reported rather than silently generalised** (the
AW/AX call): `perfect_form` 40, `deep_focus` 40 (the DROP in the conversion point, which is
what keeps it additive), `consistent_aim` 50, `unwavering` 10, `tunnel_vision` 100,
`sundering_shot` 45, `exposed_nerve` 15 (gate AND magnitude), `snap_shot` 2 with `snap_used`
now a COUNT not a bool, `opening_volley` 150, `follow_through` 2, `second_nature` 4 (a TOTAL,
the `instinctive` precedent), `spray` 2, `one_shot` 200, `rapid_fire` 50. **FOUR ARE STILL
HONEST FLAGS** — No Cover, Overkill, Through and Through (rules, not amounts).
**`opp_aim` BECAME `opp_aim_step` (4.0) BECAUSE IT IS A FLOAT**: it holds the INCREASE on the
2%-per-Break-point the kit pays WITHOUT the node (AV's `guardian_step` form), and it is
**deliberately ABSENT from `Runes.STAT_INT_KEYS`** — the coercion would round it with nothing
crashing (AT's `conduit_step`, AY's `wild_communion_step`). **THE OTHER HALF OF THE TRAP IS
ASSERTED TOO: `deep_focus`, `perfect_form` and `opening_volley` STAY IN that list, and the
reason under them CHANGED** — they used to be flags whose payload was a bare 1 and they are int
MAGNITUDES now, which needs the list exactly as much.
RUNE AUDIT, all four re-pointed. **THREE STILL PAY EXACTLY WHAT THEY PAID, only the units
moved:** the Narrow Gap (`bonecracker_ranks` 1 -> 12, `pierce_bonus` untouched), the Long Draw
(`opening_volley` 1 -> 60, `muscle_memory_ranks` 1 -> 10, the scarred -10 Speed untouched) and
the Level Aim (`muscle_memory_ranks` 1 -> 10, `bonecracker_ranks` 1 -> 12). **THE RUNE OF THE
DEEP SIGHT IS THE ONE THAT COULD NOT PAY WHAT IT PAID**, and it is REPORTED not hidden (the AY
Deep Bond / AX Hollow Chalice precedent): "his Focus climbs to 150" has no equivalent value
once there is no ceiling. **RE-POINTED, NOT DELETED** — it keeps the RELATIONSHIP, dropping the
conversion point by 8, **one fifth of Deep Focus's 40, exactly AY's ratio**, and its desc was
rewritten to the new units rather than left lying. Its second clause (crits granting +20 Focus)
is untouched. **THE COLLISION §6 ASKED ABOUT, RESOLVED AND STATED: Long Draw's opening value
and Opening Volley's 150 now SUM to 210** — the additive house rule, so each pays its
advertised number alone and both stacked, and the rune's text says "60 MORE" so neither is
lying. **THE THREE HUNTER CLASS-WIDE RUNES TOUCH NO SHARPSHOOTER COUNTER**, asserted.
§7 THE BOT, two changes. **IT NEVER SWITCHES WHILE ITS MARK LIVES** — `_focus_mark(u,
fallback)` is the ONE answer to "who is he shooting" (the AX `_ruin_focus` shape) and it is
applied by REASSIGNING `target_foe` at the TOP of the hunter branch. **That position is
load-bearing, and the brief's own instruction to check the code found why: the Sharpshooter
rotation already worked `ss_t`, but the CLASS-POOL abilities he can earn — Shrapnel Charge,
Snare Trap, Hamstring, Harvest, Deadfall — each aimed at `target_foe` and would have quietly
broken the meter they were priced against.** **COUP'S THRESHOLD MOVED OFF 80** (most of a
capped meter, a fraction of an uncapped one) **to `COUP_FOCUS_CAP`** — the same constant the
damage site reads, so the bot and the ability can never disagree about what it is priced for.
Instrument honesty, not tuning: NO DIFFICULTY MEASUREMENT IN THIS BATCH.
KIT SMOKE, fixed lineup, 40 battles/row, berserker,pyromancer,inquisitor,sharpshooter,
DOD_SIM_TALENTS force-learning full 8-node lanes. All rows 40/40 wins, 0 SCRIPT ERROR.
Sharpshooter damage share / deepest Focus: **ungeared 36% (246/battle), deepest 130 (x2.15);
PRECISION 37% (249), deepest 240 (x2.9); PENETRATION 36% (237), deepest 160 (x2.3), BD/battle
138 against the other rows' 81-87; TEMPO 49% (317), deepest 50 — Spray of Arrows' cap, working.**
A PRECISION row with the trophy abilities granted reads **39% (276), deepest 280 (x3.1)**.
**§1'S OWN PREDICTION, ANSWERED TO THE NUMBER: it guessed "somewhere near x3 to x3.5 by the end
of a long fight" and a full Precision build reaches x3.1.** So the 0.5%-past-100 rate SHIPS AS
WRITTEN, and the lever named for the tail was not needed.
**TEMPO IS THE STANDOUT AT 49%, AND IT IS REPORTED, NOT ACTED ON — that is §0's standing
instruction working exactly as it was meant to.** The cause is legible: Snap Shot's two free
casts plus Rapid Fire's 50% cooldown skip plus Follow-Through's -2 put Aimed Shot at 4.0
casts/battle against the other rows' 2.4-3.3, and Spray of Arrows adds two extra bodies a shot.
Note what it costs him: the Focus meter never leaves 50, so the whole converted half of his own
passive is switched off in that build. **THE MOST DAMAGE AND THE LEAST PATIENCE ARE THE SAME
ROW**, which is the trade the lane is supposed to sell.
**PRECISION IS THE ROW WORTH A SECOND LOOK, AND IT IS A FINDING RATHER THAN A PROBLEM: it
DOUBLES the depth (130 -> 240) and moves damage share by ONE POINT.** The build holds both
halves of §4's dissolved pair, so Executioner's Eye's +0.5 and Consistent Aim's -0.5 cancel to
x2.0 and Tunnel Vision's -100% switches off crits on everything except the mark. The lane pays
in CERTAINTY, and the smoke's instrument reads damage. Kit-mechanics ratios ONLY; NO difficulty
signal (Batch R).
**COUP DE GRACE FIRES 0.1 TIMES A BATTLE at the new threshold** (trophy row; it is not in the
opening kit, so the four lane rows never press it at all). That is §7 taken to its conclusion
rather than a bug — 200 Focus is genuinely late in a fight that ends in 7 rounds — but it means
**the smoke barely exercises the ability the reading cap was written for**, and a run is where
that number will mean something. REPORTED, NOT RETUNED.
ONE INSTRUMENT FIX THE FIRST SMOKE FOUND, and it is the class of thing that reads as a broken
instrument rather than a finding: **the deepest-Focus line printed NOTHING on a Spray build.**
The meter opens at Opening Volley's value clamped to the node's cap of 50, so no gain ever
RAISES it and the banking sat inside a `> before` branch. The bank is outside that branch now —
what is being recorded is how deep the meter GOT, not whether a given call moved it.
VERIFIED: check_parse 0, check_flow 0 (6 screens), run-harness gates 1/2/3 PASS.
NEW test_batch_az.gd **489/0**.
Regression: ah 5410/0 (STAMP GATE bumped AY -> AZ), ah_battle 65/0, ai 2036/0, an 6047/0,
aj 403/0, ak 523/0, al 556/0, ar 885/0, as 387/0, at 460/0, au 257/0, av 315/0, aw 338/0,
ax 329/0, ay 455/0,
test_runes **2976/0 (was 2985 — three RE-POINTS IN PLACE with the reason in the file: §1 took
`deep_focus`, `perfect_form` and `opening_volley` out of `BOOLEAN_READ_FIELDS` because they
carry real magnitudes now, which is the AE alarm doing its job rather than the list decaying;
the AA ordering probe for `deep_focus` is INVERTED (it proves no Focus ceiling is derived at
all, the AT Resonance treatment); and the ceiling-writer floor drops 3 -> 2 with the two
survivors NAMED — Open Hand and Long Draw — so it cannot fall again by attrition)**,
test_rune_battle **96/0 (was 95 — its Sharpshooter block RE-POINTED IN PLACE: the ceiling
assertion is INVERTED, the counters read the new units, and a check was ADDED for the Deep
Sight's re-pointed clause)**.
NEGATIVE CONTROLS RUN, all four the batch named, each applied to the code and reverted:
**Focus past the split still buying chance trips 2, Consistent Aim SETTING the multiplier trips
2, Unwavering surviving a target switch trips 3, and Coup reading the whole meter trips 2.**
LIVE AUTOPLAY BATTLE clean (0 SCRIPT ERROR), and **§2'S RAMP READS CORRECTLY IN A REAL FIGHT**:
"Unwavering: +10 Focus for 1 turn on one mark" then "+20 Focus for 2 turns on one mark", then
back to +10 after the mark died — the acceleration, and the reset, visible in the log.
NO DIFFICULTY MEASUREMENT AND NO SIM ROW, deliberately — same as
AJ/AK/AL/AR/AS/AT/AU/AV/AW/AX/AY.
REPORTED NOT ACTED ON: **THE FOCUS METER IS UNCAPPED AND `_gain_focus` TAKES A SIGNED AMOUNT.**
Nothing in the game currently spends Focus through it (Coup and One Shot both assign 0
directly), so the floor at 0 is the only guard it needs today — but a later batch adding a
per-point spender should decide at that site whether spending is allowed to run the meter
backwards past what a single ability paid for.
BATCH AY (08-08) — THE BEASTMASTER: PARTNERSHIP (AND THE PACK, BUILT). First of the
Hunter three, and **he goes first rather than last** on Batch X's own precedent that the
companion machinery "deserves a pass rather than being the tired third of three." One spec
only; the other eleven trees and enemy tuning UNTOUCHED. Every one of his 24 ids survives and
re-specs in place, NO SAVE VERSION MOVES (still v7). §8 and §9 carry the two open fixes from AX.
SPINE: **PARTNERSHIP — his power lives in another body, and it is the only resource in the
game that can die.** The Hunter class's stated three-way contrast (*three meters in three
places*) is the axis the Cleric now uses, so it is retired for **partnership / patience /
attrition**. NOTE: that sentence appears ONLY in Batch AX's changelog entry — §10 asked for it
to be replaced "wherever it appears" in master.html and IT WAS NEVER THERE.
§0 **THE INSTRUMENT WAS CHECKED, NOT ASSUMED, AND THE ANSWER IS GOOD NEWS: COMPANION DAMAGE
CREDITS THE HUNTER.** `_companion_hit` books `dmg_hero_<pack_master>` at ONE named site
(`comp_credit`), so every Beastmaster number ever measured is READABLE and this batch's rows
are comparable with Batch W's 17-28%. Damage share IS a valid read for him (Ramp damage
archetype) — unlike the Cleric three. **`_ghost_hit` (Call of the Wild's bodiless blows) books
NOTHING — a pre-existing instrumentation gap, reported not fixed**, and small: it fires only
for absent kinds on a boss-trophy ability.
TWO NEW NUMBERS, one `pack_report_line()` shared by the standalone report and RunSim's (the
`ruin_report_line` pattern), printed only when a Beastmaster stood: **the DEEPEST LOYALTY
reached** (banked at the GAIN site, because Primal Surge and a beast's death both wipe the
meter) and **the share of hunter turns on which TWO beasts really stood** under The Pack.
§1 **THE PACK IS BUILT — AND THE BRIEF'S PREMISE WAS STALE.** "COMING SOON, deferred" survives
only in Batch 30's changelog entry; `_beast_cap`, `unit.beasts` and the per-kind `loyalty`
dict were all already live and master.html already documented two beasts. What this batch
actually built is the FIVE EDGE CASES that would otherwise have been decided by accident:
- **BOTH BOONS AT FULL, never half.** Menagerie stays the half-strength node and now carries a
  THIRD (absent) beast's boon rather than a first's — its magnitude is deliberately unchanged
  because §1 gave it a new job instead.
- **URSUS'S `100 + hunter_idx` TAUNT ENCODING SURVIVES TWO BEASTS** and still prefers the bear.
  The decode already read `_beasts(heroes[idx])`, i.e. a list, so it needed no change — checked
  live rather than assumed.
- **ONE SOUL SPANS THREE BODIES, and that needed a field change.** `soul_partner` was a SINGLE
  POINTER: a second summon silently overwrote it and the older beast kept a link the hunter no
  longer answered. It is **`soul_bond`, an Array holding every living member**, and
  **`battle._sync_soul_bond` is the ONE writer** (summon, free, death). A wound divides across
  everyone: 30 damage is 10/10/10.
- **THE SWAP REPLACES THE OLDER OF THE TWO, and that is a CORRECTION §2 FORCES, not a
  preference.** The code replaced the LOWER-Loyalty beast; with an uncapped meter the beast you
  just called ALWAYS holds the lower Loyalty, so the old rule would evict the newcomer
  immediately and make rotation impossible under the very capstone whose lane is named for it.
  `hunter.beasts` is append-ordered, so the oldest living beast is simply `_beasts(h)[0]`.
- **CALL OF THE WILD** already handles a two-beast field (real bodies strike, the absent kind
  ghosts) and still never sets `beast_committed` — Batch AG's fix survives. Checked, not assumed.
**LONE BOND CLOSES THE PACK — AND ROW EXCLUSIVITY WAS NOT ALREADY HANDLING IT.** §1 asserts
that it was; IT IS NOT. Lone Bond is Devotion row 7 and The Pack is a row-8 CAPSTONE with **no
lane-purity requirement** (talents.gd's own rule), so a player can hold both — "one beast per
fight" plus "two beasts at once", the one combination the brief says must be impossible.
Resolved WHERE THE NUMBER IS READ (`_beast_cap` returns 1 under Lone Bond) rather than by
building picker-level exclusion machinery, which §11 forbids, and **BOTH node descriptions say
so** so the door is visible before the point is spent.
§2 **LOYALTY HAS NO CEILING AND THE BOON IS A CURVE.** `_bond_mult` = **1 + 0.20 x Loyalty,
continuous** — x2 at five stacks (EXACTLY today's doubling, so nothing a player learned became
wrong), x3 at ten, x5 at twenty, and it never plateaus. `_bond_step(hunter)` is the ONE place
the step is decided (Absolute Devotion adds to it, Ancient Pact doubles the result).
**`_loyalty_cap` RETURNS A SENTINEL, `LOYALTY_UNCAPPED := -1`, NOT A LARGE NUMBER** — a large
number is a ceiling a later batch reaches by accident. **EXACTLY ONE NODE STILL HANDS IT A
NUMBER: Wild Rotation (3), and that cap IS its cost.** §2's own text says "three nodes still
impose caps"; that is stale against its own §3, which re-specs Absolute Devotion and Lone Bond
off caps entirely. Corrected toward §3, whose magnitudes are declared final.
**THE ONE CLAMP THE CURVE FORCED, AND IT IS A GUARD NOT A MAGNITUDE: `BOND_MITIGATION_MAX
:= 0.75`.** Ursus's Savage Presence is `1.0 - 0.10 * boon` on damage TAKEN, so an uncapped
boon crosses zero and **enemy attacks would start HEALING him** (at the Absolute Devotion +
Ancient Pact step, from Loyalty 13). The MITIGATION is bounded; the CURVE is not, because the
curve is the identity. The Ursus attack-pull is clamped at 1.0 for the same reason.
§3 ALL 24 NODES RE-PRICED AT ROW PRICING, **3-4x** (not the Cleric three's 4-5x — his numbers
were never the smallest in the game). LANE THESES SHARPENED WITHOUT RENAMING: **DEVOTION =
partnership in DEPTH · THE PACK = partnership in BREADTH · HANDLER = when the partnership is
not the answer.** FULL TABLE IN THE CHANGELOG. **THREE NODES ARE RE-SPECCED RATHER THAN
REPRICED, because §2 took their premise:** Absolute Devotion (was a ceiling dial) is now THE
LANE'S THESIS — the boon's step 20% -> 35% a stack; Ancient Pact (was a threshold triple) now
DOUBLES THE STEP AGAIN, so both taken it is +70% a stack against an unhealable beast; Lone Bond
(was a higher ceiling) now ARRIVES AT 6 LOYALTY AND DOUBLES EVERY GAIN.
**ONE JUDGEMENT CALL, FLAGGED NOT SILENT: VENGEANCE KEEPS ITS +30% DAMAGE.** §3's table
describes only the boon and contrasts only the DURATION ("full strength for the rest of the
battle, rather than for a status's duration"), so the duration is what changed — the damage
clause is not dropped. It rides the same `vengeance` status, which is now applied with -1 turns
(permanent). `vengeance_dmg` is its own field, per AW's two-magnitudes-two-fields rule.
§4 **STEADFAST BOND <-> VENGEANCE: THERE WAS NOTHING LEFT TO DISSOLVE.** Batch 30 authored the
fork and its record survives ONLY in that batch's changelog entry — not in the tree data, not
in this file's prose list, not in master.html, and `test_runes._exclusives` has been a bare
`pass` since AI. RECORDED, not actioned. **LONE BOND <-> WILD ROTATION SURVIVES UNTOUCHED**
because both sit in ROW 7 and row exclusivity enforces it correctly — stated so a later batch
does not "fix" a pair already being enforced.
§5 **THE TROPHY-POOL COLLISION CANNOT ARISE, and it is recorded rather than left to a reader.**
HIS TREE GRANTS NO ABILITIES AT ALL (the summons, Hunter's Instinct and Kill Command are base
kit; Bestial Wrath, Spirit Bond, Primal Surge, Call of the Wild and Mark of the Hunt come from
the boss-trophy pool), so he owes no AU §1 fallback in either direction and no trophy can land
on a node's grant. **ASSERTED BOTH WAYS** — no node carries `grant_ability`/`new_ability`, and
no `SPEC_POOLS["beastmaster"]` entry appears in `Talents.ability_names` for a fully-learned tree.
§6 **EVERY BEASTMASTER COUNTER IS ADDITIVE** (the AR/AS/AT/AV/AW/AX form). **TWO hold the
INCREASE on a base the kit pays WITHOUT the node and are named `_step`** — `wild_communion_step`
on the passive's own 5%, `absolute_step` on the boon's own 20% (AV's `guardian_step` precedent).
**BOTH ARE FLOATS AND ARE DELIBERATELY ABSENT FROM `Runes.STAT_INT_KEYS`** — the Rune of the
Deep Bond pays **1.5**, and the int coercion would round it to 1 with nothing crashing (AT's
`conduit_step` lesson, arriving through a Hunter door). `loyalty_cap_bonus` was **DELETED WITH
ITS PREMISE** (field, STAT_INT_KEYS entry and rune clause), not left unreachable.
**THE NAME TRAP IS ASSERTED IN BOTH DIRECTIONS**: `wild_communion_step` is NOT
`communion_ranks` (the Devout's — Batch 29 crossed them once), and the test walks BOTH trees
and proves the two specs share no counter at all.
RUNE AUDIT. **ALL FOUR RE-POINTED; THREE STILL PAY EXACTLY WHAT THEY PAID, only the units
moved:** the Turning Pack (`momentum_ranks` 1 -> 8), the Loosened Straps (`masters_aim_ranks`
2 -> 12 — it rides Quick Shot, which Master's Aim reprices 6% -> 25%, and the rune's own flat
+12% of Attack is unchanged and composes additively at the same site), the Shared Wild
(`wild_communion_ranks` 1 -> `wild_communion_step` 1.5, `momentum_ranks` 1 -> 8,
`companion_hp_pct` untouched). **THE RUNE OF THE DEEP BOND IS THE ONE THAT COULD NOT PAY WHAT
IT PAID**, and it is REPORTED not hidden (the AX Hollow Chalice precedent): "Loyalty climbs one
stack higher" has NO equivalent value once there is no ceiling, because §2 delivers that for
free. **RE-POINTED, NOT DELETED** — it keeps the RELATIONSHIP, paying into the boon's step
(`absolute_step` 3 = one fifth of the node, the same ratio its other clause already had), and
its desc was rewritten to the new units rather than left lying.
**ONE CONSEQUENCE WORTH NAMING: QUICK WHISTLE NOW SHAVES THE WHOLE SWAP COOLDOWN, so the
Turning Pack's "returns a turn sooner" is INERT for a player who takes that node.** It still
pays in every other build. `SWAP_COOLDOWN := 3` and the floor is ZERO (it was 1, which would
have made "no cooldown" unreachable). **THE THREE HUNTER CLASS-WIDE RUNES TOUCH NO BEASTMASTER
COUNTER**, asserted.
§7 THE BOT: **summon early and keep something standing** (the summon block is FIRST in the
hunter branch, asserted positionally — Loyalty only accrues while a beast lives, so a bot that
summons late measures a spec nobody plays); **under The Pack fill BOTH slots**, preferring a
second beast over swapping the first; and **SWAP ONLY WHEN THE INCOMING BOON IS THE BETTER
ONE.** `_bot_boon_worth(hunter, kind)` weighs each kind's own effect against the live field
(Canis by wounded-enemy count, Ursus doubled while the hunter is under half, Aguila flat) AND
MULTIPLIES BY THE LOYALTY CURVE, so an established beast is genuinely expensive to give up; a
25% margin stops it churning. **IT ALSO RESPECTS THE SHARED SWAP COOLDOWN EXPLICITLY** — the
bot calls "Summon X" rather than the picker's "Swap X" clone, and `_ability_usable`'s cooldown
gate only matches the latter, so a swap rule without that check would have bypassed it.
§8 **THE OCCULTIST: RUIN GENERATION DOUBLED (from AX's zero).** `const OLD_GODS_MARK := 2`,
read at the **four sites that ARE the passive marking a debuff the Occultist applied**: the
generic `applies_status` hook, Empowered Hex's Decay, Umbral Mirror's rebound (its own comment
already says the reflection is his work) and Bewitch's special path. **NODE MAGNITUDES ARE NOT
SWEPT UP IN IT** — Delirium, Unraveling and Spread of Madness keep their own. **ONE SITE
DELIBERATELY LEFT AT 1 AND REPORTED: the daze a BEWITCHED ENEMY lays on a fellow** — that is
madness-lane plumbing, not the Occultist applying a debuff. **THE THRESHOLD STAYS AT 10 AND
AVATAR OF RUIN STAYS AT 5**; the *first at 5, every 10 after* variant AX named is STILL NOT
SHIPPED.
§9 **THE DEVOUT: A RELEASE THAT CONSUMED NO STACKS GRANTS HALF GROWTH** (1.5% of base, not 3%).
`_conviction_growth(devout, consumed)` with ONE caller passing `keep < 5` — under Apostle `keep`
is 5, so nothing was consumed. `CONVICTION_NO_CONSUME_SHARE := 0.5` is a SHARE of the base
constant rather than a second magnitude, so the two cannot drift apart. It hits the multiplier
precisely and leaves the base spec, the step and the fantasy alone.
DOC DRIFT CORRECTED TOWARD THE CODE, found in passing: **the Occultist's in-game
`passive_desc` still described the PRE-AX Ruin** — "max 5", a flat 10% lifesteal, a threshold of
5, 50% of Attack and a 15% party heal. Every one of those numbers moved in Batch AX and that
string was missed. Now matches the code, with AY's generation rate in it.
VERIFIED: check_parse 0, check_flow 0 (6 screens), 11 scenes 0 SCRIPT ERROR, run-harness gates
1/2/3 PASS. NEW test_batch_ay.gd **455/0**.
Regression: ah 5410/0 (STAMP GATE bumped AX -> AY), ah_battle 65/0, ai 2036/0, an 6047/0,
aj 403/0, ak 523/0, al 556/0, ar 885/0, as 387/0, at 460/0, au 257/0, av 315/0,
aw **338/0 (was 337 — TWO checks RE-POINTED IN PLACE with the reason in the file: §9 moved the
growth percentage into a local, and the 13-release Apostle stream now reads +19% not +39%; a
THIRD check was ADDED so the halved path is covered by the same negative control)**,
ax 329/0, test_runes **2985/0 (was 2988 — two rune payloads went int -> float, so three
STAT_INT_KEYS-family checks no longer apply; the AL/AT precedent)**,
test_rune_battle **95/0 (its Beastmaster block RE-POINTED IN PLACE: the ceiling assertion is
INVERTED now — it proves no ceiling is derived — and the counters read the new units)**.
NEGATIVE CONTROLS RUN, all four the batch named plus two of its own: the boon curve stepping at
5 again trips **6**, Menagerie paying full trips **3**, Wild Communion writing the Devout's
`communion_ranks` trips **4**, a full-consumption release also paying half trips **2**, the swap
going back to lower-Loyalty trips **2**, and Lone Bond no longer closing The Pack trips **2**.
KIT SMOKE, fixed lineup, 40 battles/row, berserker,pyromancer,inquisitor,beastmaster,
DOD_SIM_TALENTS force-learning full 8-node lanes. All rows 40/40 wins, 0 SCRIPT ERROR.
Beastmaster damage share / deepest Loyalty: **ungeared 26% (159/battle), deepest 11; DEVOTION
42% (274), deepest 50; THE PACK 31% (198), deepest 3 (Wild Rotation's cap, working); HANDLER
26% (161), deepest 9.** A PACK row with row 7 swapped off Wild Rotation reads **33% (212),
deepest 13, two beasts standing on 53% of hunter turns**; the Wild Rotation row reads **63%**.
**DEVOTION IS THE STANDOUT AND IT SHIPS AS WRITTEN** — Absolute Devotion + Ancient Pact is a
+70% step against an unhealable beast, and 50 Loyalty in a 7-round smoke fight is the curve
doing exactly what §2 asked for. Kit-mechanics ratios ONLY; NO difficulty signal (Batch R).
**§0'S SECOND NUMBER, ANSWERED HONESTLY: THE PACK FIELDS TWO ON 53-63% OF HUNTER TURNS.** The
missing share is RAMP, not loss — turn 1 calls one beast and turn 2 calls the other, so in a
7-round fight two of the hunter's turns are structurally single-beast. It is the capstone it
claims to be.
§8 MEASURED, BOTH HALVES, ON AX'S OWN FLAGS. **`ruin_report_line()` RE-RUN, 40-run line,
Ruin build: trash 0.06 detonations/battle (n=774, DEEPEST MARK 20) | boss 0.35 (n=52, DEEPEST
MARK 32)** — against AX's **trash 0.00 (n=519, deepest 10) | boss 0.13 (n=23, deepest 12)**.
**THE WHOLE CURVE DOUBLED AND THEN SOME: the deepest trash mark EXACTLY doubled (10 -> 20) and
the boss half nearly TRIPLED on both axes (0.13 -> 0.35, deepest 12 -> 32).** §8 predicted
"deepest mark ~14 in trash and past 20 on a boss"; the run over-delivered on both because a run
reaches deeper tiers and longer fights than the standalone smoke does.
Standalone n=200 matched to AX's arm exactly (Ruin lane rows 1-7, threshold 10): **trash 0.05,
deepest mark 14** against AX's **0.00, deepest 7** — the deepest mark doubled there too, and 14
is §8's own prediction to the number. **TRASH IS OFF ZERO BUT ONLY BARELY, AND THAT IS
REPORTED NOT ESCALATED: §8's own condition for reopening the threshold conversation was "if
trash is still zero", and it is not.** With Avatar of Ruin's threshold of 5 the same standalone
build reads **1.83 detonations/battle, deepest 19, 63% contribution** — the capstone is now a
real answer for a player who wants the payoff back in ordinary fights, which is what AX designed
it to be and which it could not previously deliver at all.
**THE RUN ROW'S OTHER NUMBERS ARE NOT A DIFFICULTY READING** (n=40, no control row, and
./sim.sh carries no difficulty signal since Batch R) — but one is worth keeping as
instrumentation: **the deepest Loyalty reached over a full run is 90.** The curve genuinely has
no ceiling in the only place long enough to show it.
§9 MEASURED, AND THE FALLBACK IS REPORTED NOT TAKEN. FAITH row isolated on Apostle, n=200, same
flags as AW's and AX's: **76% contribution, 1766 healing/battle, +36.6% of base growth/battle,
peak 180 HP on a 175 base** — against AX's **80% / 2305 / +83.7% / 390**. **GROWTH AND PEAK BOTH
HALVED, EXACTLY AS DESIGNED**; healing fell 23% with them. **CONTRIBUTION IS STILL 76%, WHICH IS
PAST §9'S OWN ~60% TRIGGER — SO THE NEXT LEVER (the base step 3% -> 2%) IS REPORTED AND
DELIBERATELY NOT TAKEN, on §9's explicit instruction.** Note what that number means: the growth
was never the whole of the FAITH row, and halving it did not move contribution much, so a base-
step cut may not either. THE DESIGNER'S CALL.
NO DIFFICULTY MEASUREMENT AND NO SIM ROW, deliberately — same as AJ/AK/AL/AR/AS/AT/AU/AV/AW/AX.
REPORTED NOT ACTED ON: **PRIMAL SURGE SCALES LINEARLY ON AN UNCAPPED METER.** It spends ALL
Loyalty for `0.15 x stacks x Attack` per beast and buffs the hunter for that many TURNS; at the
50 Loyalty the DEVOTION row reached, that is 7.5x Attack in one button and a 50-turn buff. It is
a boss-trophy ability that RESETS the ramp, so the tension is the good kind — but §3 declared
magnitudes final and did not mention it, so it ships untouched and is flagged. Also:
**`_ghost_hit` books no damage stat** (see §0).
BATCH AX (08-08) — THE OCCULTIST: CORRUPTION. Third of the Cleric three and **THE
CLERIC CLASS IS DONE**. His tree needed the LEAST structural work of the three —
Ruin / Madness / Leech are genuinely distinct axes with real cross-lane plumbing and
no lane was lying about its job (Batch L did good work) — so this is the 4-5x
repricing plus a spine: **CORRUPTION — his power is not in him at all, it is in what
he has done to them.** One spec only; the other eleven trees and enemy tuning
UNTOUCHED. Every one of his 24 ids survives and re-specs in place, NO SAVE VERSION
MOVES (still v7).
§1 **RUIN HAS NO MAXIMUM AND NEVER CLEARS.** Corruption that resets is not corruption.
`unit.add_status`'s ruin branch dropped its `mini(..., 5)`; a detonation consumes the
PRIMER and nothing else. **THE THRESHOLD IS EVERY TENTH STACK (10, 20, 30, ...) AND
THE ARMING TEST IS A MODULO, NOT AN EQUALITY** — `st > 0 and st % step == 0` in
`_gain_ruin`. **BOTH HALVES OF THAT GUARD ARE LOAD-BEARING**: with stacks that survive,
`== 5` arms once and never again and `>= 5` arms on every stack forever; and `> 0`
exists because `_apply_status` CAN REFUSE the mark (Hallowed bounces every debuff) and
`0 % anything == 0` would arm the bomb off a refused stack. Stacks are added ONE AT A
TIME so a multi-stack gain can never step over a threshold without touching it.
**`const RUIN_THRESHOLD := 10`, one `_ruin_threshold()`, one caller-visible override:
`avatar_ruin` holds the threshold the capstone installs (5) — the GATE AND THE
MAGNITUDE in one field (AW's `judgement` precedent).** The blast is bigger because it
costs twice as long to earn: **50% -> 90% of Attack, party heal 15% -> 25% of his max
health.** The chip text moved OUT of `unit.add_status` into **`_stamp_ruin_chip`**,
because every number in it (the per-stack bite, the next threshold) moves with his
talents and add_status cannot see them.
**THE CONSEQUENCE IS STATED, NOT BURIED: his signature payoff largely leaves ordinary
fights** (~1.5 Ruin a turn focused = ~7 turns to ten; a trash fight ends in 7-8). THAT
IS THE INTENT — boss specialist by construction — but it is a real loss of feel, so §0
MEASURES it. **IT MEASURED ZERO.** Run sim, 40 runs / 519 trash battles, Ruin-lane build:
**trash 0.00 detonations/battle, deepest mark 10 | boss 0.13/battle over 23 boss fights,
deepest mark 12**. Standalone smoke, 200 battles, ENTIRE Ruin lane force-learned: **trash
0.00, deepest mark 7** — ten stacks is not rare in an ordinary fight, it is UNREACHABLE, and
the boss half is thin rather than healthy. **§1's named variant — "first detonation at 5,
every 10 after" — was DELIBERATELY NOT SHIPPED. Reporting the number was the instruction;
the decision is the designer's.**
**TWO PER-STACK EFFECTS, OPPOSITE TREATMENT.** The damage amplification is **LEFT
UNCAPPED** (+2%/stack, +5% with **Deeper Hex — now the most dangerous node in the game**,
a multiplier on a number with no ceiling; +100% at twenty stacks, measured x1.96). **The
lifesteal is CAPPED**: it went PER STACK (2% each, replacing the flat
10%-while-any-Ruin — the axis the passive was wasting) and **`const RUIN_LEECH_CAP :=
0.40`** binds it whatever the stacks and whatever the talents, Soul Glut included.
§2 **THE MADNESS LANE'S BOSS PROBLEM WAS MADE LEGIBLE, NOT PATCHED.** All four madness
effects resist a boss until Broken, so the lane read as dead in the nine fights that
decide a run. **It is gated behind a task, and the task is the RUIN lane's job** (Broken
Will and Entropy, priced with that in mind). **NO BOSS WORKAROUND WAS ADDED** — the
`_apply_status` guard and its two `force` callers are byte-untouched. What changed is
where the rule is stated: the Madness node text, the Psychosis / Bewitched / Mass
Hysteria glossary entries (**all three now NAME BREAK AS THE KEY**) and the Bewitch /
Mind Flay / Mass Hysteria ability tooltips.
§3 ALL 24 NODES RE-PRICED AT ROW PRICING, **4-5x** (Holy's and the Devout's reason).
**ALL THREE LANE NAMES AND THESES STAND** — the one Cleric tree that did not need
re-aiming. FULL OLD->NEW MAPPING IN THE CHANGELOG. **AVATAR OF RUIN IS RE-SPECCED, NOT
REPRICED**: keeping the stacks is the DEFAULT now, so its old subject is the passive and
the capstone moves the THRESHOLD instead (every 5th stack) — the answer for a player who
wants the payoff back in ordinary fights.
§4 TWO AUTHORED FALLBACKS (AU §1) replacing his generics: Mind Flay already owned ->
**three minions instead of two** (`choose_two` off, `choose_three` on, description
follows); Mass Hysteria already owned -> **cooldown 4 -> 2**. **THE CLERIC CLASS NOW OWES
NO GENERICS AT ALL**; test_batch_au's floor moved 11 -> 9 with the reason in the file
(it FALLS on purpose, one class batch at a time) and "occultist" joined its durable list.
§5 **EVERY OCCULTIST COUNTER IS ADDITIVE** (the AR/AS/AT/AV/AW form). **FOUR hold the
INCREASE on a base the kit pays WITHOUT the node and are named `_step`** —
`deep_hex_step` on the passive's 2%, `soul_leech_step` on its 2% lifesteal,
`whispers_step` on Psychosis's 50%, `barter_step` on Dark Pact's 15%. **THE BRIEF NAMED
THREE OF THOSE FOUR**; the fourth has the same shape and takes the same treatment —
reported, not silently generalised (the same call AW made). `spread_ranks` SPLIT into
`spread_ranks` (a chance) + `spread_ruin` (a stack count). **`pleasure_ranks` RENAMED
`pleasure_pct` BECAUSE ITS MAGNITUDE IS 2.5** — `Runes.STAT_INT_KEYS` coerces anything
ending in `_ranks` and would have rounded it to 2 with nothing crashing; it is
deliberately ABSENT from that list, while `deep_hex_step`, `soul_leech_step`,
`whispers_step`, `barter_step` and `spread_ruin` were ADDED to it (the AA trap).
RUNE AUDIT. **TWO RE-POINTED AND STILL PAYING EXACTLY WHAT THEY PAID — only the units
moved:** the Deepening Ruin (`deep_hex_ranks` 1 -> `deep_hex_step` 1, `entropy_ranks`
1->5) and the Whispering Dark (`broken_will_ranks` 1->5, `spread_ranks` 1->15,
`pleasure_ranks` 1 -> `pleasure_pct` 0.5, **plus `spread_ruin` 1 — the old spread site
marked the newly maddened with 1 Ruin unconditionally, so the rune WAS paying it and now
has to say so**). **THE HOLLOW CHALICE IS THE ONE THAT COULD NOT PAY WHAT IT PAID**, and
it is REPORTED not hidden: §1 changed the lifesteal's UNIT from flat to per-stack, so
"5% more from Ruined targets" has no equivalent value. It keeps the relationship it has
always had — exactly ONE NODE'S WORTH of each dial (`soul_leech_step` 3,
`gluttony_ranks` 3) — and its desc was rewritten to the new units rather than left lying.
**THE HOLLOW CHALICE CLAMP WAS CHECKED, NOT TRUSTED** (§5 named it): worst reachable
`healing_received_mult` sum is **-0.60 against a floor of -1.00**, so AA's guard comment
holds — and test_batch_ax COMPUTES it rather than believing it, beside test_runes'
`_healing_floor`. **THE THREE CLERIC CLASS-WIDE RUNES TOUCH NO OCCULTIST COUNTER**,
asserted. No rune was left homeless (this batch retires no node). **NO OCCULTIST
EXCLUSIVE PAIR SURVIVES**, in the tree data OR in this file's prose: Batch L already
retired Pact of Flesh <-> Grim Focus and no other was ever authored — so unlike AS, AT
and AW there was nothing to dissolve.
§6 THE BOT: **IT WORKS ONE TARGET.** `_ruin_focus(foes, target_foe)` aims everything he
casts at the deepest existing mark (ten-stack thresholds reward focus; a bot that
debuffed whatever was convenient would never detonate and a sim would measure a spec
nobody plays). **AN UNBROKEN BOSS OUTRANKS EVEN THAT** — Shadowrend and Hex go on it to
grind Break, while Mass Hysteria, Mind Flay and Bewitch are HELD behind `oc_gated` until
it is Broken, because they are refused outright before that. Hex is never gated: it IS
the plan.
NEW INSTRUMENT (§0's two numbers): **`Ruin detonations/battle` and the DEEPEST MARK
observed, each SPLIT TRASH VS BOSS** — one `ruin_report_line()` shared by the standalone
report and RunSim's, **because only a RUN ever meets a boss**. Printed only when an
Occultist stood.
§7 **THE DEVOUT'S FERVOR: THE BRIEF'S PREMISE WAS STALE AND THIS SHIPPED AS A FINDING,
NOT A CHANGE.** §7 asked to drop Fervor "from 2 Faith per ally per turn to 1, so
Consecrated Ground pays 2 a turn rather than 3 with the node learned". **THE GROUND
ALREADY PAID 2 WITH THE NODE LEARNED** — AW §2 put a base drip of 1 in the kit and priced
Fervor as a +1 increase — so the end state §7 named was already shipped and the
instruction is a NO-OP. Corrected toward the code, and NOT guessed into a real change:
the two readings that would have been one are `fervor_step` 1->0 (a node that does
nothing) and reverting AW §2's base drip (which §7 says stays). **THE SMOKE WAS RE-RUN
ANYWAY AND IS COMPARABLE WITH AW'S**: FAITH row isolated on Apostle, n=200 —
**80% contribution, 2305 healing/battle, +83.7% of base growth/battle, peak 390 HP on a
175 base**, against AW's 78% / 1997 / +72.9% / 360. **AW'S OVERSHOOT IS UNADDRESSED AND
STILL OPEN.**
§8 ONE MORE STALE CLAIM RECORDED RATHER THAN ACTIONED: §8 asks for "the x3 rank notation
removed" from §7's Occultist tables. **THERE IS NO SUCH NOTATION IN master.html** and has
not been since Batch AI made every node single-rank — the identical correction AW made
when its own brief claimed it.
VERIFIED: check_parse 0, check_flow 0 (6 screens), run-harness gates 1/2/3 PASS.
NEW test_batch_ax.gd **329/0**.
Regression: ah 5410/0 (STAMP GATE bumped AW -> AX), ah_battle 65/0, ai 2036/0, an 6047/0,
aj 403/0, ak 523/0, al 556/0, ar 885/0, as 387/0, at 460/0, au 257/0, av 315/0, aw 337/0,
test_runes 2988/0, test_rune_battle 95/0 (its two Occultist rune checks re-pointed IN
PLACE, with a third added for the Hollow Chalice).

BATCH AW (08-08) — THE DEVOUT: INVESTMENT. Second of the Cleric three. His tree
was purpose-designed already (Batch K), so like AV this is NOT a restructure — it is
a SPINE (**he lends out his own bulk and collects dividends**) plus the same 4-5x
repricing Holy needed. One spec only; the other eleven trees and enemy tuning
UNTOUCHED. Every one of his 24 ids survives and re-specs in place, NO SAVE VERSION
MOVES (still v7). §9 carries one Holy fix.
§0 **SAME INSTRUMENT RULE AS AV, AND IT BINDS HARDER HERE: the Devout is the LOWEST
damage-share spec in the game (2-4%) and that number is meaningless.** Read
prevented, healing landed and the normalised contribution share, at a stated sample
size and on matched flags — Batch AA measured his heal/battle going 10->14
fixed-party and 25->13 rotated, i.e. OPPOSITE SIGNS, which is what noise looks like.
§1 **CONVICTION GAINS A THIRD CLAUSE: THE PRINCIPAL GROWS.** Every Faith release
raises the Devout's maximum health by **3% of his BASE maximum** for the rest of the
battle AND heals him for the same amount (the dividend arrives as usable health, not
an empty bar). **"3% OF BASE" IS LOAD-BEARING AND IS NOT 3% OF CURRENT** — the base
is captured ONCE, at the first release, so growth is LINEAR (3% x N), never 1.03^N.
The loop still compounds THROUGH THE KIT (bigger maximum -> bigger shield -> more
absorbs -> more Faith -> more releases), which IS the design; what must not compound
is the clause against itself, because Apostle turns releases into a stream. NOTHING
ELSE NEEDED BUILDING — his whole kit already reads his maximum.
**ONE IMPLEMENTATION: `_conviction_growth(devout)`, one caller (the release branch of
`_gain_faith`), plus `CONVICTION_GROWTH_PCT = 0.03` and two fields,
`conviction_hp_gained` / `conviction_base_hp`.**
**THE LANDMINE, AND IT IS WHY `rot` WAS DROPPED FROM AQ: max_hp LEAKS OUT OF THE
BATTLE.** The battle-end save sync writes each unit's `max_hp` straight back onto the
party member, so a one-fight change follows the party out of it — the Devout would be
permanently enormous one battle at a time with NOTHING CRASHING to announce it.
`conviction_hp_gained` accumulates every point granted and **BOTH victory syncs
(battle.gd's victory branch AND run_sim.gd's) subtract it before writing max_hp back**,
beside `tenacity_hp_gained`, with `hp` clamped under the restored maximum in the same
step (the existing clampi does it). **THE FIELDS STAY SEPARATE** — but NOT for the
reason the batch brief gives. **CORRECTION TO THE BRIEF: it calls Tenacity's growth
PERMANENT. IT IS NOT** — `tenacity_hp_gained` has been subtracted at that same sync
since Batch W (the ~127,000 max-HP runaway), and unit.gd's own comment has said
"excluded from the run save" all along. The real reason not to merge them:
`tenacity_hp_gained` has a SECOND consumer, **Unkillable's mend**, which reads
`max_hp - tenacity_hp_gained` as "the pool he brought INTO the battle" and must mean
TENACITY'S growth alone — folding Conviction's in would change what a Warden's
Unkillable heals for whenever a Devout stands beside him.
§2 **CONSECRATED GROUND IS A FAITH SOURCE IN THE BASE KIT.** Faith had ONE real
source on a 2-turn cooldown — one shield, one target — so a passive promising a
party-wide system delivered to one ally at a time. Fervor's effect MOVED into the
ability: **every ally gains 1 Faith at the start of their turn while the ground
holds, NO NODE REQUIRED**; the Fervor node re-specs to DEEPEN it (2/turn). It is its
own function, **`_ground_faith_tick(u)`**, called from the turn-start block —
extracted deliberately, because `_run_battle` cannot be driven headlessly (the AR
trap) and a clause with a real gate has to be reachable by a test or its negative
control can only ever be a grep.
§3 ALL 24 NODES RE-AUTHORED AT ROW PRICING, **magnitudes 4-5x not the Mage trees' 3x**
(same reason as Holy's: rank-1 values on the smallest-numbered support in the game).
**THE LANE NAMES STAY; TWO THESES ARE RE-AIMED.** Zeal's was "everything else he
casts" — the fault Sanctuary had, a lane named after the leftovers. The three lanes are
now three shapes of one act: **BULWARK invests deeply in ONE ally · FAITH invests in
what the returns pay · ZEAL invests shallowly in EVERYONE.** FULL OLD->NEW MAPPING IN
THE CHANGELOG. **BASTION GOES TO NO COOLDOWN AT ALL** (a `set`, not the old -1 `add`)
— a shield every turn is a Faith engine, and it is the strongest node in the tree.
**UNWAVERING FAITH AT +20% MAX HEALTH is now the most investment-shaped node in the
game**: with §1 it raises the base every payout AND every growth increment scales from.
Purity is a THIRD Faith source (the blessing already doubles Faith gain, so the
doubling finally travels WITH a source). Judgement repriced 20% -> 40%.
§4 **THE STALWART <-> BASTION PAIR IS DISSOLVED and nobody had noticed.** Batch K
authored them as an in-lane fork; **Batch AI's row exclusivity destroyed it** — rows 5
and 6 of one lane, so a player holds both. Removed from CLAUDE.md's prose list (see
the AA block; `test_runes._exclusives` has been a bare `pass` since AI, so the list
survived only there — the same correction AS and AT each made). MEASURED, NOT
PRE-EMPTIVELY RE-TUNED: 50% of his maximum absorbed, on no cooldown.
§5 TWO AUTHORED FALLBACKS (AU §1) replacing his generics: Sacred Resolve already
owned -> its split lasts **5 turns instead of 3** (`resolve_extra_turns` 2); Bulwark
of Fortitude already owned -> **4 turns instead of 3** (`bulwark_extra_turns` 1).
**CORRECTION TO THE BRIEF: Bulwark is NOT "the first capstone in the game that grants
an ability" — NINE do** (bz_rampage, sm_execute, wd_hold_line, py_firestorm,
py_rebirth, cr_shatter, ar_wrath, oc_hysteria and it), eight of them predating AW.
The true half is the brief's own reason: Holy's three granted none, so it is the first
CLERIC capstone to owe a fallback. **test_batch_au's generic-count floor moved 12 -> 11
with the reason in the file** (it FALLS on purpose, one class batch at a time) plus a
durable half: arcanist/holy/inquisitor now owe NO generics at all.
§6 **EVERY DEVOUT COUNTER IS ADDITIVE** (the AR/AS/AT/AV form). **FOUR hold the
INCREASE on a base the kit pays WITHOUT the node and are named `_step` for it** —
`stalwart_step` on Divine Shield's 30%, `righteous_step` on the ground's 10%,
`faithful_step` on the release's 15%, `fervor_step` on §2's new base drip of 1 (AV's
`guardian_step` precedent). **THE BRIEF NAMED TWO OF THOSE FOUR**; the other two have
the same shape and take the same treatment — reported, not silently generalised.
`covenant_ranks` SPLIT into `covenant_heal` (25) + `covenant_faith` (2), because one
counter cannot honestly hold a percentage and a stack count. **`judgement` is the GATE
AND THE MAGNITUDE in one field** (40 = 40%).
RUNE AUDIT. **RE-POINTED, and every one still pays EXACTLY what it advertises AND
exactly what it paid before this batch — only the units moved:** Warded Robes
(blessed_barrier_ranks 1->4, warded_ranks 1->10), Binding Oath (faithful_ranks 1 ->
`faithful_step` 5), Burning Censer, the scarred one (righteous_ranks 2 ->
`righteous_step` 10, lifewell_ranks 1->20), Standing Vow (blessed_barrier_ranks 1->4,
devoutness_ranks 1->5, pulse_ranks 1->2). The four `_step` names were added to
**`Runes.STAT_INT_KEYS`** or JSON's float slides into a typed int var and the hero
fails to spawn (the AA trap). **THE THREE CLERIC CLASS-WIDE RUNES TOUCH NO DEVOUT
COUNTER**, asserted. **NO DEVOUT RUNE WAS LEFT HOMELESS — this batch retires no node**,
so there is no vault entry; the test asserts every rune-written counter still has a
live read site so a later batch that DOES retire one has to say so.
§7 THE BOT: **Consecrated Ground goes up WHENEVER IT IS OFF COOLDOWN and comes FIRST**
(the old policy laid it only at 3+ foes as a mitigation button, so a sim measured a
spec whose party-wide Faith source was mostly absent). Divine Shield onto
**`_likeliest_target(allies)`** — and the ONLY honest signal on this board is a TAUNT,
which is a certainty rather than a lean (`_enemy_turn` narrows a mocked enemy's whole
target list); everything else an enemy does is a 40/60 roll between lowest health and
`_threat_pick`, and lowest health is already the fallback, so guessing past the taunt
would be inventing policy. Companion taunts (mocked power 100+) are skipped — the beast
eats the hit and cannot hold Faith. Blessing of Zeal onto a shield-holder is the Batch K
fix and STAYS.
§9 **`hl_beacon` RENAMED "HOUR OF NEED"** — it shipped as SHARED VIGIL in AV, which
collides with the Warden's Banner row-6 node of the same name (AV flagged it rather
than shipping it silently). His triggers on standing strong and KEEPS the name; hers
triggers on a hero being near death. **A LABEL ONLY** — `holy_vigil_pct`,
`HOLY_VIGIL_AT` and every read site are byte-untouched. test_batch_av re-pointed IN
PLACE with the reason in the file (315/0 still).
NEW INSTRUMENT (§0's one new number): **`Devout max-health growth/battle`** in the
standalone sim report — average HP lent, average % of base, and the MAXIMUM OBSERVED.
Printed only when a Devout was in the party (a zero on a party without one reads as a
broken instrument).
VERIFIED: check_parse 0, check_flow 0 (6 screens), 11 scenes 0 SCRIPT ERROR,
run-harness gates 1/2/3 PASS. NEW test_batch_aw.gd **337/0**.
Regression: an 6047/0, ah 5410/0 (STAMP GATE bumped AV -> AW), ah_battle 65/0, ai 2036/0,
aj 403/0, ak 523/0, al 556/0, ar 885/0, as 387/0, at 460/0, au **255/0 (was 249 — the
generic-count floor re-pointed 12 -> 11 with the reason in the file, plus the durable
per-class half)**, av **315/0 (the rename re-pointed IN PLACE)**, test_runes 2981/0,
test_rune_battle 94/0 (its Devout checks re-pointed to the new units).
NEGATIVE CONTROLS RUN, all three the batch named: the growth reading CURRENT instead of
base trips 7 checks, the victory sync leaving the growth on the party member trips 3,
and Fervor still gating the ground's drip trips 3.
LIVE AUTOPLAY BATTLE clean (0 SCRIPT ERROR) and the loop reads correctly in a real fight:
"Consecrated Ground kindles Pyromancer (+2 Faith) (Fervor)" every turn for every hero,
then "Conviction: the principal grows — Devout's maximum health rises 6 (now 216) …
rises 6 (now 222) … rises 6 (now 228)". **THE STEP STAYS CONSTANT WHILE THE MAXIMUM
CLIMBS — that is 3%-of-base working, visible in the log.**
KIT SMOKE, **CONTRIBUTION METRICS ONLY (§0)**, fixed lineup, 40 battles/row,
berserker,pyromancer,inquisitor,beastmaster, DOD_SIM_TALENTS force-learning full 8-node
lanes. All five rows 40/40 wins, 0 SCRIPT ERROR. Devout reads (heal/battle, prevented,
contribution%, damage share, growth/battle): **ungeared 40 / 82 / 18% / 2% / +3.7% of
base; BULWARK 48 / 94 / 20% / 2% / +4.4%; FAITH 1997 / 88 / 78% / 3% / +72.9%; ZEAL 134 /
67 / 27% / 2% / +2.3%.** HIS DAMAGE SHARE NEVER LEAVES 2-3% WHILE HIS CONTRIBUTION GOES
18% -> 78% — that is §0's whole point, and reading the wrong column would call this batch
a nerf.
**THE APOSTLE ROW, ISOLATED, WHICH IS THE NUMBER §1 ASKED FOR AND EXPLICITLY DID NOT ASK
TO BE CAPPED.** Same FAITH rows 1-7 both sides, only row 8 varying (Apostle vs Bulwark of
Fortitude): **Apostle +72.9% of base per battle, MAXIMUM OBSERVED 360 HP on a 175 base
(+206%); without it +41.7%, maximum observed 180 HP (+103%).** So Apostle is worth ~1.75x
the growth — and BOTH rows are far past the brief's own projection of "a dozen releases
puts him at +36%", because §2's base-kit drip plus Fervor plus Communion feed many more
releases than that estimate modelled. Healing follows it: 1997/battle with Apostle vs
1086 without. **REPORTED AND NOT CAPPED, exactly as §1 instructed — this is a decision,
not a bug.** Note the smoke fight is over by round 7-8, so a longer fight reads HIGHER.
NO DIFFICULTY MEASUREMENT AND NO SIM ROW, deliberately — same as AJ/AK/AL/AR/AS/AT/AU/AV.
A `./sim.sh --run 15` was walked ONLY to exercise RunSim's victory sync (this batch edits
it) and to check purity: 0 SCRIPT ERROR, profile.json + relics.json BYTE-IDENTICAL, no
run_save.bin created. **Its Matrix row is NOT reported as a difficulty reading** — n=15
is far under the resolvable difference and there is no control row.
DOC-DRIFT NOTE: §8 asked for "the x3 rank notation" to be removed from master.html's
Devout lanes. **THERE IS NONE ANYWHERE IN THE FILE.** The tables were stale in a
different way — AI's magnitudes and AP's dead decimals — and were REGENERATED from the
live tree.
BATCH AV (08-08) — HOLY: REVERSAL. First of the Cleric three. Her tree was
purpose-designed already, so this is NOT a restructure — it is a SPINE (**nothing
is final, no loss permanent**) plus the most overdue repricing in the game. One
spec only; the other eleven trees and enemy tuning UNTOUCHED. Every one of her 24
ids survives and re-specs in place, NO SAVE VERSION MOVES (still v7).
§0 **READ THE RIGHT INSTRUMENT OR THIS SPEC READS AS A BROKEN HERO. DAMAGE SHARE
IS MEANINGLESS FOR HER AND IS A STANDING RULE FOR THE TWO CLERIC BATCHES STILL TO
COME.** Batch W measured 8% damage share against 33% contribution off 431 healing
a battle. Every kit smoke here reads `_stat_heal`, prevented and the normalised
contribution share; a moving damage share is NOISE. Say which numbers you read.
§1 **RESURRECTION IS IN HER OPENING KIT**, unchanged (1 Mercy, 4.0, 3cd, 20%
health+resource; Empower +1 Mercy = full + 5 turns of Renewal; Perfect 25%). It
was a row-5 node AND an Epic rune's whole payload, so her identity was a pick most
builds skipped. It **LEFT `SPEC_POOLS["holy"]`** (a boss cannot offer what she
starts with — the pool is `["Divine Plea"]` now, which is why ak reads 523 and al
556). **HER KIT IS FOUR ABILITIES WHERE EVERY OTHER SPEC HAS THREE AND THAT IS
DELIBERATE** — she attacks at 50, so her abilities are not PART of her
contribution, they are all of it. test_batch_ah's "3 spec abilities" assertion is
RE-POINTED IN PLACE and NAMES the exception so a second one cannot creep in.
**EXACTLY ONE DEF EXISTS**: the kit list calls `Classes.pending_talent_ability
("Resurrection")` rather than holding a copy (the AK resolver rule), because the
Rune of the Last Rites still grants it BY NAME and both must read one set of
numbers.
§2 **SANCTUARY IS RENAMED VIGIL.** "Radiance is heal bigger, Sanctuary is stop
people dying" was one axis with two names. Vigil takes REVERSAL — the fallen and
the nearly-fallen — so she has three real questions: how much you heal, how you
pay for it, and what you can take back. `Talents.LANE_NAMES` needs no entry; the
lane string renders directly.
§3 MAGNITUDES 4-5x, NOT the Mage trees' 3x. Radiance row 3 was a 5% dispel; Mercy
row 2 restored 1% of max Mana; Vigil row 1 moved a threshold 50 -> 53. Those were
rank-1 values in a three-rank tree. **MERCY ITSELF IS UNTOUCHED BY DESIGNER
DECISION** — generator, +5%/stack, spend costs, Empower surcharge, perfect-forgo
all stand. **GUARDIAN ANGEL 53 -> 65% IS THE LOAD-BEARING REPRICE** (the only lever
on her economy that was left). NEW DESIGNS: **GRACE** (a stack earned at the
ceiling becomes healing for the ally who earned it — the one place her reactive
economy wasted what it earned), **INTERCESSION** (the reversal button; the Mercy
is paid ON TRIGGER, not on cast, so an empty hand arms nothing), **SHARED VIGIL**,
**SANCTUM**, **MARTYRDOM**. **SERENITY DELIBERATELY DOES NOT TOUCH THE RETURN
HEALTH** — that is Empower's job and stepping on it would make Empower pointless.
It is written as an ABILITY PAYLOAD for exactly that reason: no field in it COULD
reach `rez_frac`, and the test asserts only Empower ever reassigns that.
IMPLEMENTATION NOTES worth keeping:
- **`BattleUnit._holy_reversal()` IS THE ONE PLACE HER TWO REVERSALS ANSWER A
  LETHAL BLOW**, called from take_hit AND take_tick_damage, AFTER a unit's own
  saves. Intercession goes FIRST (a paid, expiring window lapsing while a
  permanent capstone sat unused is the worse failure).
- **THE INTERCESSION HOOK RETURNS A BOOL, and that is the design**: the callback
  is asked whether the refusal can be PAID, so "she holds none" and "the stack
  leaves her hand" are the same line of code. The STATUS is the one answer to "is
  the window live", so it expires by itself and no flag can outlive it.
- **THE INTERACTION WORTH KNOWING (pinned by a test): a hero falling from ABOVE
  the Mercy window crosses it on the way down, so their own fall earns her the
  stack the refusal then spends.** It is free exactly once and only against a
  genuine one-shot. It also means a NAIVE test of "she holds nothing" measures a
  net of zero and passes — start the victim already under the line.
- **MARTYRDOM IS A REFUSAL-AND-RESTORE, NOT A DEATH THEN A REVIVE** (Undying
  Rage's machinery): the hero never leaves the initiative order and no death is
  booked. Hero deaths are detected at ~8 sites; a revive hook would have needed
  all of them.
- `_sanctified_refund` is THE ONE PLACE the Sanctified roll happens (three
  spenders: faith_cost, the Empower surcharge, an Intercession trigger — it was
  written out twice with the third missing). `_overflow_share` is THE ONE PLACE
  the overflow share is decided, so Sanctum and Overflow cannot disagree.
- **AVATAR OF MERCY LOST ITS PER-TURN +1** — it made the resource a clock rather
  than something the party earned her. It now waives the surcharge AND GRANTS a
  stack.
§5 **EVERY HOLY COUNTER IS ADDITIVE** (AR/AS/AT's form). Two are the INCREASE on a
base the passive already pays — `heavenly_step` 7 on Mercy's 5%/stack and
`guardian_step` 15 on the 50% window — AT's `cannoneer_ranks` precedent, and the
only honest additive form when the base exists without the node. **NONE OF THEM
ENDS IN "_ranks" ANY MORE, so a rune writing one MUST be added to
`Runes.STAT_INT_KEYS`** or JSON's float slides into a typed int var and the hero
fails to spawn (the AA trap). `triage_heal`, `divine_presence_pct` and
`last_hope_pct` are listed for that reason.
RUNE AUDIT. **RE-POINTED:** Triage Ward (`triage_ranks` -> `triage_heal` 3), Open
Hand (`triage_ranks` -> `triage_heal` 3, `last_hope_ranks` -> `last_hope_pct` 5),
Sleepless Vigil (`divine_presence_ranks` -> `divine_presence_pct` 2, **and its
by-name lane tag Sanctuary -> Vigil** — a renamed lane is exactly the kind of
reference that breaks quietly, the AS Honed Lance lesson). Each still pays its
advertised number. **THE THREE CLERIC CLASS-WIDE RUNES TOUCH NO HOLY COUNTER**,
asserted. **RUNE-ONLY, READ SITES KEPT AND FLAGGED FOR RE-AUTHORING** (the AR
vault pattern): `capacitor_ranks`/`stored_overheal` (Triage Ward) and
`beacon_ranks` (Sleepless Vigil) — their NODES became Martyrdom and Shared Vigil.
§4 **AU §1'S RULE ALREADY REACHED RUNE GRANTS AND THAT IS THE FINDING — NO NEW
MACHINERY WAS NEEDED.** Runes share `Talents.apply_payload`, so a rune granting an
owned ability hits the same `_collided` site, and `Run.apply_upgrades` already runs
AFTER the rune pass. **The Rune of the Last Rites is therefore no longer a dead
Epic**: Resurrection has no damage, so Honed is skipped and QUICKENED lands (3cd ->
1). Its desc was rewritten to say so (a desc rewrite is not a magnitude change —
the AT Resonant Core precedent; rune magnitude is CLOSED since AF). HER TWO
AUTHORED FALLBACKS: Divine Plea already owned -> 1 Mercy instead of 2;
Intercession already owned -> a 3-turn window. Her three capstones grant no
ability, so they owe nothing.
§6 THE BOT: raise the fallen FIRST whenever she can pay; Intercession while
someone is under 30% and she holds a stack for the trigger; Divine Plea under 30%;
Hymn at TWO or more allies below 70%; Heal otherwise. **RENEWAL IS IN THE ROTATION
AND IS NOT IN §6'S MINIMUM — reported, not silently added**: On the Mend and the
Renewal half of her throughput are unmeasurable without it. `_holy_empower_ok` is
the ONE implementation of the Empower rule and **never Empowers down past a
Resurrection she could otherwise cast**.
**ONE NAME COLLISION, FLAGGED NOT SILENT: the Warden already has a Banner row-6
node called SHARED VIGIL** (allies -12% while he is above half health). Holy's
Vigil row 5 carries the same name with the opposite trigger. Separate counters
(`shared_vigil_ranks` vs `holy_vigil_pct`), separate specs, they stack cleanly —
only the LABEL is shared, and renaming one is the designer's call. Shipped as
specified and recorded.
VERIFIED: check_parse 0, check_flow 0 (6 screens), 11 scenes 0 SCRIPT ERROR,
run-harness gates 1/2/3 PASS. NEW test_batch_av.gd **315/0**.
Regression: an 6047/0, ah 5410/0 (STAMP GATE bumped AU -> AV), ah_battle 65/0, ai
2036/0, aj 403/0, ak **523/0 (was 524 — her spec pool lost Resurrection and every
entry still resolves)**, al **556/0 (was 557 — same reason)**, ar 885/0, as 387/0,
at 460/0, au **249/0 (was 246)**, test_runes 2981/0, test_rune_battle 94/0.
LIVE AUTOPLAY BATTLE clean (0 SCRIPT ERROR), and **BOTH REVERSALS FIRED IN
SEQUENCE ON THE SAME HERO**, which is the ordering rule working in a real fight:
Intercession blankets all four heroes, one window FADES unused, the next refuses a
lethal blow ("Pyromancer survives at 1 HP (Holy spends 1 Mercy)"), and when he
falls again **Martyrdom returns him at 30%**. Shared Vigil logs -15% on every blow
once someone crosses 30%; Divine Presence drips every turn. **BLESSED VESTMENTS
HAS NO PROC LINE ON PURPOSE** — it rides EVERY heal and tick, so a log line each
time would flood the combat log; the barrier chip and its "Absorbed N" float are
the feedback, and test_batch_av measures the ward directly.
KNOWN FLAKE, NOT OURS: test_batch_at's "Cannon at 8 stacks scales by the PASSIVE
alone" tripped ONCE in five runs here and passed the other four — it has an
unsuppressed roll of its own. Nothing this batch touches is on the Arcanist path.
NEGATIVE CONTROLS RUN: Guardian Angel back at 53% trips 2, a Serenity that also
returns the ally at full health trips 3.
KIT SMOKE, **CONTRIBUTION METRICS ONLY (§0)**, fixed lineup, 40 battles/row,
berserker,pyromancer,holy,beastmaster, DOD_SIM_TALENTS force-learning full 8-node
lanes. All four rows 40/40 wins, 0 SCRIPT ERROR. Holy reads: **ungeared 222
healing/battle, 29% contribution (3% damage share); RADIANCE 615, 50% (1%); MERCY
346, 37% (3%); VIGIL 302 healing + 31 PREVENTED, 37% (4%)**. HER DAMAGE SHARE FALLS
AS HER CONTRIBUTION NEARLY DOUBLES — that is §0's whole point, and reading the
wrong column would have called RADIANCE a nerf.
NO DIFFICULTY MEASUREMENT AND NO SIM ROW, deliberately — same as AJ/AK/AL/AR/AS/AT/
AU.
REPORTED NOT ACTED ON: **RESURRECTION FIRES 0.1-0.2 TIMES A BATTLE IN THE SMOKE.**
A 40-battle fixed-lineup fight almost never kills a hero, so the kit's headline
piece is measured by the test suite rather than by the sim. A property of the
smoke, not of the spec — the same "a smoke fight is over by round 3-4" caveat AU
recorded. Intercession does fire (0.2/battle in the VIGIL row).
BATCH AU (08-08) — FOUR THINGS FROM THE AT PLAYTEST. Two game-wide fixes and two
pieces of Arcanist repair; NO CLERIC WORK (Holy starts clean at AV). Every id
survives, NO SAVE VERSION MOVES (still v7).
§1 **AN EARNED ABILITY NO LONGER KILLS ITS OWN TREE NODE.** The rule ran ONE
DIRECTION ONLY — a talent that had granted an ability stopped the boss offering
it, but taking Magi's Wrath from a zone boss left its capstone node granting
something already owned and that row silently dropped to TWO live options.
**FILTERING THE BOSS POOL IS NOT THE FIX** and must never be tried: SPEC_POOLS
entries ARE tree nodes across the roster, so filtering tree abilities out of
spec pools would empty pools. **THE NODE UPGRADES THE ABILITY INSTEAD OF
GRANTING IT.** The GENERIC fallback = the highest-priority eligible
ABILITY_UPGRADES entry the ability does not already carry, order **Honed ->
Quickened -> Effortless -> Swift** (`Run.UPGRADE_PRIORITY`), filtered by AP §3's
existing eligibility (Honed damage>0, Quickened cooldown>0, Effortless cost>0,
Swift anything). Deliberate REUSE: those upgrades are wired (AP), dud-filtered
(AP §3) and already visible with the ◆ marker and hover line (AQ §5), so a
fallback is legible the moment it fires with nothing new to build.
**IT BYPASSES AP'S ONCE-PER-RUN RULE** — that rule governs the MINI-BOSS PICK
POOL and a talent-granted upgrade is not a mini-boss pick. It still respects
"not already on THIS ability", and when nothing eligible is left the node grants
NOTHING and **says so in its tooltip** (`Run.fallback_line`).
**IT IS TWO STEPS AND THAT IS LOAD-BEARING, NOT CONVENIENCE.** The DECISION is
at the grant site — `Talents._collided`, reached from BOTH the `new_ability` and
`grant_ability` branches — which records the ability NAME on
`cfg[Talents.FALLBACK_KEY]`. The RESOLUTION is in `Run.apply_upgrades`, which
already runs LAST at both kit-assembly sites: **AP's ordering rule means several
talents and runes `set` an ability field, so an upgrade applied mid-tree is
silently overwritten.** (It also could not live in talents.gd anyway — PROVEN,
not assumed: `Run` does not resolve inside a class_name script, the compile
error is "Identifier not found: Run".) `Run._stamp_upgrade` is now THE ONE PLACE
an upgrade's effect is written, shared by the mini-boss pick and the fallback.
A node opts out with **`no_fallback: true`** inside its payload; AUTHORED
fallbacks use AK's existing `upgrade` list and win over the generic.
**THE ARCANIST'S TWO ARE AUTHORED:** Overcharge already owned -> the node makes
it usable TWICE per battle (`overcharge_extra`); Magi's Wrath already owned ->
NOTHING, and that is a consequence of §4 — the capstone carries the
step-doubling as a passive, so owning the ability already does not make it dead.
**§4 AND §1 CLOSE EACH OTHER'S WORST CASE.** Scope: game-wide, 22 ability-granting
nodes of which 15 take the generic; each class's re-author batch replaces its own
generics with authored ones. DO NOT author the other nine specs' fallbacks.
§2 **EXCLUSIVITY MADE LEGIBLE**, three changes because they fix different halves:
(a) rows 1-7 are drawn as a BAND with a **CHOOSE ONE** label (the structural fix
— it stops the misread before it happens; a decided row's band warms in colour);
(b) **hovering a node DIMS ITS TWO SIBLINGS** (the one that actually prevents the
mistake, because it fires while deciding — `_dim_siblings`/`_undim_siblings`
restore from a stored base modulate, so a locked sibling never creeps darker);
(c) a taken row LOCKS its siblings visibly — greyed, LOCK_GLYPH "⊘", and a
tooltip naming what barred them, *"Barred — you took [Name] in this row."*
ROW 8 HAS ITS OWN, STRICTER TREATMENT: the shelf reads "ONE PER HERO, EVER", the
dim applies there too, taking one locks the other two with the same named
tooltip, and an untaken capstone now also names the two it would close (it only
did that for rows 1-7 before).
**ONE VISIBLE CONSEQUENCE, FLAGGED NOT HIDDEN:** AN's surplus-point crack is
untouched IN THE RULES, but a second node in a decided row now READS as barred
(greyed + glyph) rather than as an ordinary open pick. The tooltip states the
crack under the reason — "A surplus point can force it open" — so the affordance
is legible rather than implied by colour. `Talents.can_learn`'s Locked/Closed/
Barred/Maxed PREFIX VOCABULARY IS UNTOUCHED (test_batch_ai asserts it); the
batch's player-facing sentence is built in party_screen, which is where UI text
belongs.
§3 **DEATH RAY: GATE 5 -> 8** (`DEATH_RAY_STACKS = 8`) **AND COST 40 -> 55 MANA.**
At twelve stacks it lands 325% of Attack in one hit, so a genuinely late button
is MORE on-theme, not less. Damage, initiative, cooldown and target count
UNCHANGED and it still consumes nothing. Terminal Velocity's 15 still sits clear
above the gate. **A MISS CHANCE WAS CONSIDERED AND REJECTED ON PRECEDENT** (AQ
turned down miss-chance modifiers on feel grounds; a 325% nuke that whiffs is
the strongest case FOR that objection). **BOTH CHECKS THE BATCH ASKED FOR, DONE
AND REPORTED:** a Mage's max Mana is 100, so 55 leaves 45 headroom (~2.5 turns of
regen from empty) — the cost is payable; and the greyed affordance reads
"(Requires 8 Resonance — you have N)" off the constant, asserted off a REAL
popup button rather than off the constant itself.
§4 **THE TWO CAPSTONES WERE CROSSED AND ARE UNCROSSED.** Singularity doubled the
damage STEP, which is OVERLOAD's entire thesis, while Overload's own capstone was
a plain AoE. **MAGI'S WRATH (Overload capstone) now grants the ability AND
doubles the step 1.5% -> 3%** (`wrath_step_double`, applied via `also` so it
lands whether the ability is granted or was already earned). It keeps BD = 2.5 x
stacks and its recoil and **still gets NO per-stack damage term back** — that is
the squaring trap AT exists around. **SINGULARITY (Resonance capstone) takes
BUILD RATE: crits build 2 additional Resonance, every enemy killed builds 3.**
**WHY THAT IS SMALL AND WHY SMALL IS CORRECT:** damage is step x N(N+1)/2 —
quadratic in the count, only linear in the step — so doubling the BUILD RATE
roughly QUADRUPLES the payout while doubling the step merely doubles it. A
capstone that doubled the build rate would be twice the capstone beside it on
the same shelf. It is also deliberately SELF-SCALING (the passive grants +1%
crit per stack, so crits rise with the curve and it feeds itself LATE without
compounding from turn one). MEASURED, as §4 asked: at 12 stacks Wrath is exactly
x2.00 and four more stacks is x1.74 — comparable, so BOTH SHIP AS WRITTEN.
**CRIT BUILDING IS ADDITIVE WITH EXACTLY ONE READ SITE:** base 2, Attunement
sets 3, Singularity adds 2 = 5. NOT the higher of the two, never summed twice.
The kill clause rides `_on_enemy_death` — THE one place a death is booked — so
it fires once per death. Perfect Conversion UNCHANGED.
FIELDS: `singularity` is GONE; `wrath_step_double` moves the step,
`singularity_crit_build` / `singularity_kill_build` pay the build rate.
`overcharged` (bool) became `overcharge_uses` + `overcharge_extra` decided in
ONE place, `overcharge_ready()` — and the spent CHIP only appears once the
allowance is exhausted, or it would lie about a second use still owed.
§5 **THE DEBUG GRANT IS SCOPED TO THE HERO'S OWN SPEC.** It pre-granted every
talent-granted and boss-trophy ability the CLASS could reach, so testing the
Arcanist put Pyromancer abilities in his hands. Now: that spec's tree grants,
that spec's capstones and `SPEC_POOLS[spec]`. **`CLASS_POOLS` IS EXCLUDED AND
THAT IS THE TRADE-OFF WORTH NAMING** — the sibling abilities showing up ARE the
class pool's contents (Flamewave and Firestorm are in CLASS_POOLS["mage"]), so
excluding it is what fixes the complaint. The cost: a legitimately earnable
class-pool ability is no longer covered by the toggle; the node summoner and a
real boss reward still reach them. **DO NOT BUILD A SECOND TOGGLE FOR IT.**
Default off, session-scoped, never saved; `debug_used` still trips. The map
toast says "each hero's OWN spec abilities" so the scope is stated where a tester
meets it.
VERIFIED: check_parse 0, check_flow 0 (6 screens), 11 scenes 0 SCRIPT ERROR.
NEW test_batch_au.gd **246/0**. Regression: an 6044/0, ah 5494/0 (STAMP GATE
bumped AT -> AU), ah_battle 65/0, ai 2036/0, aj 403/0, ak 524/0, al 557/0, ar
885/0, as 387/0, at **460/0** (was 457 — RE-POINTED IN PLACE with the reason in
the file: Death Ray's cost and gate, and `u.singularity` -> `u.wrath_step_double`
for the curve probe), test_runes 2981/0, test_rune_battle 94/0, run-harness
gates 1/2/3 PASS.
NEGATIVE CONTROLS RUN: putting the step-doubling back on Singularity trips 5
checks, letting the fallback consume a mini-boss upgrade slot trips 5.
KIT SMOKE, fixed lineup, 40 battles/row, berserker,arcanist,inquisitor,
beastmaster, DOD_SIM_TALENTS force-learning full builds. All rows 40/40 wins, 0
SCRIPT ERROR. **THE CAPSTONE A/B §4 ASKED FOR, ISOLATED** — SAME Resonance rows
1-7 both sides, only row 8 varying: **Singularity 604 dmg/battle (63% share) vs
Magi's Wrath 678 (66%)**. ~12% apart, with Magi's Wrath also bringing a whole
extra AoE ability, which is the direction §4 predicted (2.00x vs ~1.74x). **THE
TWO COME OUT COMPARABLE AND BOTH SHIP AS WRITTEN.** Full-lane rows for context:
ungeared 46%/311, RESONANCE 59%/544 (AT read 60%/526), OVERLOAD 52%/320 (AT read
56%/371). CAVEAT THAT MATTERS FOR BOTH: a smoke fight is over by round 3-4, so a
compounding curve is measured near the BOTTOM of itself — these rows under-read
every late-game capstone by construction.
**§3'S COST, MEASURED AND WORTH KNOWING: DEATH RAY FIRES 0.0 TIMES PER BATTLE IN
THE FULL OVERLOAD BUILD** (0.5 ungeared, 0.8-0.9 in any Resonance build; AT read
0.7-1.1 everywhere). The Overload lane carries no build-rate nodes, so at gate 8
plus 55 Mana it never gets there inside a smoke fight. That is §3 taken to its
conclusion rather than a bug — a genuinely late button is late — but it means the
Overload lane no longer presses it at all in a short fight, which is the largest
single reason that lane's damage fell 371 -> 320 despite gaining the doubled
step. REPORTED, NOT RETUNED.
NO DIFFICULTY MEASUREMENT AND NO SIM ROW, deliberately — same as AJ/AK/AL/AR/AS/
AT: no honest control row for a single-spec change, and ./sim.sh carries no
difficulty signal (Batch R).
REPORTED NOT ACTED ON: **DEATH RAY STILL CARRIES NO BREAK DAMAGE.** §3 was
offered a version trading raw damage for pressure and that option was NOT taken,
so a 55-Mana nuke still contributes nothing to the party's Break. STILL OPEN.
BATCH AT (08-07) — THE ARCANIST, RE-AUTHORED AROUND ESCALATION. Third of the
Mage three, AND THE MAGE CLASS IS DONE. One spec only (plus §8's Cryomancer
Shatter fix); the other nine trees and enemy tuning UNTOUCHED. His tree was
already purpose-designed, so this is not a restructure — it is a SPINE:
**NOTHING EARLY, EVERYTHING LATE.**
§1 ARCANE RESONANCE -> **RUNAWAY RESONANCE**, three clauses. NO CEILING (1 per
damaging cast, 2 on a crit, and NOTHING REMOVES IT — it persists to the end of
the battle; second_max is a sentinel 99). THE CURVE COMPOUNDS: damage
**1.5% x N(N+1)/2**, damage taken **0.75% x N(N+1)/2**, both uncapped. +1% CRIT
PER STACK, LINEAR (one stable term beside two that compound). Table: 5 stacks
+22%/+11%, 8 +54%/+27%, 12 +117%/+59%, 16 +204%/+102% — SO AT FIVE STACKS HE IS
WEAKER THAN HE WAS and by twelve he has roughly doubled. **COMPOUNDING RATHER
THAN LINEAR IS THE WHOLE DESIGN** (a linear per-stack term is a slope; a
triangular one is a curve) and §1's stated linear fallback was NOT taken — the
smoke came out fine, see below.
**THE CURVE HAS EXACTLY ONE IMPLEMENTATION**: `BattleUnit.resonance_curve()`
(+ resonance_dmg_step / resonance_dmg_bonus / resonance_taken_bonus), and
battle.gd reads it through TWO named sites. READ SITES, one line each:
`_resonance_dmg_mult` -> the attacker block in _resolve AND the ability
tooltip's buff_mult; `_resonance_taken_mult` -> the target block in _resolve;
crit -> the crit-chance block off the RAW stack count (linear, so it never
touches the curve); the nameplate -> refresh_bars, which prints the stack count
and BOTH live percentages and fills its bar toward RESONANCE_BAR_REF (15) since
there is no maximum to fill toward.
§2 **THE PER-STACK DAMAGE TERMS COME OFF ARCANE CANNON AND MAGI'S WRATH, AND
THAT IS THE TRAP THE BATCH EXISTS AROUND** — the passive compounds now, so an
ability-side per-stack term multiplies a curve by a slope and SQUARES the
escalation (a 12-stack Cannon would be 4.1x base instead of 2.17x). DO NOT
RE-ADD ONE. Both KEEP their Break terms (5 x stacks / 2.5 x stacks — Break is a
different axis) and Cannon keeps its 15% recoil.
**STABILIZE LEFT THE OPENING THREE FOR SPEC_POOLS["arcanist"]** (def moved to
`trimmed_kit_ability`, so exactly ONE def exists — the AK resolver rule; still
spec-only because it reads Resonance). It is the escape hatch from the ramp, so
it is EARNED, not given. **DEATH RAY CAME OUT OF THE VAULT INTO THE KIT**: 40
Mana, 5.0, 3cd, 150% of Attack arcane, single target, gated at
DEATH_RAY_STACKS = 5, and IT CONSUMES NOTHING (it still BUILDS one — "consumes
nothing" is not "is not a cast"). Losing Stabilize costs him his Mana valve as
well as his defence, INTENDED: his Mana comes from being hurt now (Conversion,
Feedback Loop, Siphon). ONE INTERPRETATION STATED, NOT GLOSSED: §1's "nothing
removes it" describes the PASSIVE (no decay, no cap, no reset); an earned
Stabilize is the deliberate exception a player buys.
§3 ALL 24 NODES RE-AUTHORED AT ROW PRICING, **EVERY ID SURVIVES AND RE-SPECS IN
PLACE**, NO SAVE VERSION MOVES (still v7). **THE CONTROL LANE IS RENAMED
ENTROPY** (after AS, "Control" is the Cryomancer's identity word, and the lane
was never about control — it turns his danger into fuel). FULL OLD->NEW MAPPING
IN THE CHANGELOG. ONE FORCED ASSIGNMENT AND ONE NEAR ONE, REPORTED NOT HIDDEN:
`ar_still` (Still Mind) -> BACKLASH, because Backlash has no ancestor and Still
Mind's whole subject left the kit; `ar_mindfulness` (Mindfulness) -> TERMINAL
VELOCITY on the thread of "both are about cooldowns". NOTHING NEEDED A NEW
SUBSYSTEM. Arcane Ward and Still Mind are gone as DESIGNS; STABLE ALIGNMENT WAS
KEPT DELIBERATELY — a single-hit cap is what makes a compounding death curve
interesting rather than random.
MAGNITUDES ARE **ADDITIVE, NOT RANKED** (conversion_ranks 30 = percentage
POINTS, stable_ranks 25 IS the cap, cannoneer_ranks 4 is the INCREASE on the
5 BD/stack). **`conduit_step` IS A FLOAT AND IS DELIBERATELY NOT NAMED
"_ranks"** — Runes.STAT_INT_KEYS coerces anything ending that way and 0.5 would
become 0, the node silently inert with nothing crashing. The test asserts the
NAME as well as the type.
**DELETED WITH THEIR PREMISE, not left unreachable: UNLIMITED POWER and BACKLASH
WARD** (both answered "what happens when the ramp runs out of room", and it
never does), plus the `unlimited` status. **UNREACHABLE BUT KEPT** (AR vault
pattern, gated `> 0`): mindfulness_ranks, arcane_mastery_ranks and
critical_mass_ranks are RUNE-ONLY with their read sites kept on purpose;
mana_attune_ranks and still_mind_ranks have NO writer at all.
NEW FIELDS, one read site each: attunement_crit, charged_bolts (re-meaning),
critical_mass_stacks, cascade_stacks, conduit_step, volatility_recoil,
terminal_velocity, on_edge_threshold + on_edge_stacks, backlash_stacks,
siphon_ranks, event_horizon, perfect_conversion (renamed from master_moments),
res_cast_this_turn (reset in _player_turn beside rampage_chains),
rune_on_edge_ranks, and hold_turns for §8. CRITICAL MASS'S THIRD-CRIT TRIPS ARE
COUNTED IN THE STRIKE LOOP AND PAID AFTER IT (`crit_mass_trips`): granting
Resonance mid-cast would let the curve read the new stack count on the very hit
that earned it — the ordering trap AG fixed for Detonation and AR for Pressure
Cooker, arriving through a third door.
§4 RUNE AUDIT. **RE-POINTED:** Resonant Core (conduit_ranks -> conduit_step 0.5
+ desc rewritten, because BOTH its clauses lost their meaning — no maximum to
raise, no linear term to deepen; the arithmetic is in the changelog and it
crosses over around 8 stacks), Unquiet Mind (feedback_ranks 2 -> **20**, and
**lane tag Control -> Entropy** — the AS Honed Lance lesson), Wide Current
(on_edge_ranks -> its own `rune_on_edge_ranks`, the AR Cinder Trail pattern; it
reproduces the OLD formula so it still pays its advertised number, and the
THRESHOLD TAKES THE MAX while the PAYOUT SUMS — summing thresholds would give a
60% window neither half asked for). Seventh Bolt UNCHANGED. **THE THREE MAGE
CLASS-WIDE RUNES TOUCH NO ARCANIST COUNTER**, asserted. Rune magnitude is CLOSED
since AF, so a rune paying a different amount is a REPORT, not a retune.
§5 `ar_ward` <-> `ar_still` DISSOLVED (both designs gone). Same correction AS
recorded: Batch AI retired test_runes._exclusives to a bare `pass`, so the pair
list is prose in this file only. Other four pairs untouched.
§6 THE BOT: **NEVER COME DOWN.** Death Ray whenever it is up and stacks >= 5
(it consumes nothing, so there is no reason to save it); Magi's Wrath at 3+
enemies; Overcharge ONCE at OVERCHARGE_BOT_STACKS = 8 (it pays HALF of what he
holds, so spending it early throws the button away); Cannon; Barrage; Arcane
Explosion as the free filler. **STABILIZE IS DELIBERATELY ABSENT and the code
says so** — do not "fix" it.
§8 **SHATTER RE-SPECCED: TIME HELD, NOT STACKS HELD** (Cryomancer). AS reported
it never firing and called it a design tension, correctly — Shatter (Thaw) and
Absolute Zero (Deep Freeze) are both capstones, so at a hold limit of one
Shatter and Ice Lance did the same job and the Lance was cheaper. NOW: 30 Mana,
4.0, 5cd, releases every hold, each released enemy takes SHATTER_PER_TURN (10%)
of Attack PER TURN HELD, capped at SHATTER_TURN_CAP (12). Resolves the tension
WITHOUT touching either capstone: 3 turns held is worth less than Ice Lance's
35% + stack bonus, the crossover is turn 4-5, past that the Lance can never
match it. THE HOLD IS A CHARGE, NOT A BINARY STATE.
IMPLEMENTATION: the counter is `BattleUnit.hold_turns`, written in EXACTLY ONE
PLACE — `_hold_sync`, walking `_holds`. NOT a dictionary beside `_holds` (that
would be a second answer to "is this held"). It advances ONCE PER TURN, NOT once
per unit per turn — a negative control nesting the increment inside a second
walk trips the test. Zeroed at `_hold_freeze`, so a re-freeze does not resume an
old charge. **THE NAMEPLATE HELD CHIP SHOWS THE COUNT** ("HELD 7") and its
tooltip says what the number buys. NOTE the chip's visible text is `short`, NOT
`label` — `_refresh_chips` renders `short` into the tag Label and `label` is the
tooltip heading; asserting the wrong one proves nothing. BOT: hold longer, and
prefer Shatter over Ice Lance at SHATTER_BOT_TURNS = 5 — the check moved ABOVE
the Lance release and the `_holds.size() >= 2` gate that made it never fire is
GONE. ONE CONSEQUENCE, INTENDED: the party spending the damage window kills the
target and the charge with it. That tension is the good kind; do NOT resolve it
by preserving the charge on death.
VERIFIED: check_parse 0, check_flow 0 (6 screens). NEW test_batch_at.gd 457/0,
STABLE 4/4. Regression: an 6044/0, ah 5494/0 (STAMP GATE bumped AS -> AT, and
its verbatim Arcanist pool assertion moved with the batch), ah_battle 65/0,
ai 2036/0, aj 403/0, ak **524/0 (was 523 — the Arcanist's spec pool gained
Stabilize and every entry still resolves)**, al **557/0 (was 556 — same reason)**, ar 885/0, as 387/0,
test_runes **2981/0 (was 2982 — the Resonant Core rune's payload went int -> float, so one
STAT_INT_KEYS-family check no longer applies; AL's precedent)**, test_rune_battle 94/0,
run-harness gates 1/2/3 PASS, 11 scenes 0 SCRIPT ERROR. LIVE AUTOPLAY BATTLE clean: Cannon
at 0 stacks logs +0 BD (BD = 5 x stacks, as it should), Charged Bolts drips, and DEATH RAY
LANDS FOR 256.
KNOWN-BAD, NOT OURS: test_batch_al's standing flake reproduced **2 runs of 4** here and it is
the check AQ named — `"Spite reflects damage at the attacker"`, a harness race in its own
`_spawn`. Nothing this batch touches is on AL's path.
TWO TEST RE-POINTS, IN PLACE WITH THE REASON IN THE FILE: test_runes' Batch AA
ordering alarm probed `resonant_core_ranks` as a CEILING field and Runaway
Resonance has none — the Resonance probe is INVERTED now (it asserts no
Resonance ceiling is derived at all, which is what a future batch could break)
and the "runes actually write a ceiling" floor drops 4 -> 3 with the three
survivors NAMED so it cannot be lowered again by attrition. The RULE is
untouched and still live for Mercy and Focus.
NEGATIVE CONTROLS RUN: making the curve LINEAR trips **34** checks, restoring
Cannon's per-stack term trips 2, Shatter back on Chilled stacks trips 1, capping
the taken curve at 5 stacks trips 1, and nesting _hold_sync's increment trips 1.
KIT SMOKE, fixed lineup, 40 battles/row, berserker,arcanist,inquisitor,
beastmaster, DOD_SIM_TALENTS force-learning full 8-node builds. All four rows
40/40 wins, 0 SCRIPT ERROR, every new piece in the rotation (Death Ray 0.7-1.1
casts/battle in EVERY row, Overcharge 0.8, Magi's Wrath 1.0). Share/BD:
ungeared **47%**/72; RESONANCE **60%**/79; OVERLOAD **56%**/54; ENTROPY
**55%**/85.
**THE FINDING WORTH KEEPING, and it is a property of compounding itself: BUILD
RATE BEATS PER-STACK VALUE, QUADRATICALLY.** Resonance is the standout (526
damage/battle vs Overload's 371) even though Overload is the lane whose whole
pitch is "each stack worth more" — because damage is step x N(N+1)/2, i.e.
QUADRATIC in the stack count and only LINEAR in the step. Doubling the build
rate roughly quadruples the payout; 1.5% -> 2% multiplies it by 1.33. **ANY
FUTURE TUNING SHOULD TREAT THE RESONANCE LANE'S BUILD-RATE NODES AS THE
EXPENSIVE ONES** — that is not obvious from the node text and it is the opposite
of how the two lanes are pitched. MEASURED AND FLAGGED, NOT NERFED; 60% sits in
the band AR (Kindling 66%) and AS (Thaw 51%) already shipped. Kit-mechanics
ratios ONLY — NO difficulty signal (Batch R).
NO DIFFICULTY MEASUREMENT AND NO SIM ROW, deliberately — same as AJ/AK/AL/AR/AS.
REPORTED NOT ACTED ON: **DEATH RAY CARRIES NO BREAK DAMAGE.** §2 specifies its
Mana, initiative, cooldown, damage, target count and gate precisely and says
nothing about BD, so it ships at pressure 0. A 40-Mana nuke contributing nothing
to the party's Break is a real design question — the designer's, not the batch's.
BATCH AS (08-07) — THE CRYOMANCER, RE-AUTHORED AROUND GLACIAL HOLD. Second of
the Mage three. One spec only; the other ten trees and enemy tuning UNTOUCHED.
§0 THE INITIATIVE AUDIT, AND THE ANSWER IS MOSTLY GOOD NEWS: **THE RESCHEDULE
HAS ALWAYS CALLED effective_speed()** — every line in battle.gd that advances a
unit on the timeline (turn loop, stun/freeze branches, debug turn lock,
enemy-skip toggle, post-cast reschedule, delay_push, the turn bar's own
preview) divides by it. CHILLED HAS ALWAYS SLOWED; every doc claiming so was
right. THE ONE HOLE WAS THE OPENING ROLL — `(100.0 / u.speed)` read the raw
stat, so Frenzied (mod_speed_mult) and Hoarfrost (Chilled), both of which live
in effective_speed(), did NOTHING to the first turn order and the comment above
`_apply_battle_modifier()` asserting otherwise HAD BEEN WRONG SINCE AN. Now
`(100.0 / maxf(u.effective_speed(), 0.1))`; the Hunter's -0.01 override
untouched. test_batch_as pins BOTH halves against the source (a seed is one
random draw; a single sample cannot tell two divisors apart).
§1 PERMAFROST -> **GLACIAL HOLD**, one mechanic in three clauses. PERMAFROST
his Chilled never expires (unchanged). THE HOLD a Frozen enemy stays Frozen
INDEFINITELY, off the initiative bar, released ONLY by Ice Lance, Shatter, or a
freeze past his limit (frees the OLDEST); a released enemy returns on 1 stack.
THE WINDOW a held enemy takes +15% from ALL sources (+30% Killing Frost).
**NOTHING ELSE THAWS IT — not ally damage, not his own Blizzard, not time.**
He holds ONE (two w/ Second Prison, any number under Absolute Zero). NO COST
CLAUSE, unlike Overburn AS IT THEN STOOD (BS deleted that cost too), deliberately: his cost is TEMPO. Bosses resist until
Broken AND a held boss releases after one turn (an indefinite boss hold is a
softlock, not a fantasy).
FIVE NAMED SITES, all together above `_apply_status`: `_holds` (the ORDERED
ledger, oldest first — the ONE answer to "is this held", so the bar, the
window, Brittle Ice, Cold Snap, Cryoclasm and the bot cannot disagree),
`_hold_freeze` (THE ONE PLACE A HOLD BEGINS; two callers — the Chilled-4 branch
and Glacial Prison), `_hold_release` (THE ONE PLACE ONE ENDS; every caller
names its reason in the log, and Honed Shards + Shattered Tempo live here so
Shatter and an evicted prison inherit them with no second copy), `_hold_sync`
(top of every turn, before the bar reads it) and `_hold_window_mult`.
THREE CONSEQUENCES THE BRIEF DID NOT ENUMERATE — DECISIONS, NOT SIDE EFFECTS:
(a) **A CLEANSING RITE CANNOT REACH A HOLD** (`_cleansable_debuffs` skips it) —
frozen is in DEBUFF_IDS and the rite takes the LONGEST-remaining debuff, and a
battle-long freeze reads 999, so a mender warband would have stripped it every
time and the indefinite prison would be worth LESS than the old one-turn
freeze. That removes the enemy's only answer; the hold limit and the boss
carve-out are the price. (b) A held enemy goes to **next_time = INF** rather
than losing a turn a round — otherwise the log fills forever and its cooldowns
tick while it sits helpless. (c) **IF THE CRYOMANCER DIES EVERY PRISON OPENS**
(in `_hold_sync`) — the same softlock through a different door.
§2 KIT: **ICE LANCE IS THE RELEASE** (damage/Break/always-crit-vs-Frozen all
kept — the auto-crit finally means something). Frostbolt/Razor Ice/Blizzard/
Rime mechanically unchanged; Blizzard's desc SAYS it does not thaw a hold.
TWO NEW ABILITIES, tree-only (both read the hold, so both fail AH's curation
rule): Glacial Prison (25/2.5/4cd, freeze outright) and Cryoclasm (20/2.0/3cd,
MOVE the hold — deliberately NOT routed through `_hold_release`, because a move
is not a release and no release payoff may fire).
§3 **SHATTERPOINT RENAMED THAW** (it was four crit dials — a control spec whose
payoff lane is burst is a damage spec wearing a coat). ALL 24 NODES RE-AUTHORED
AT ROW PRICING, **EVERY ID SURVIVES**, TEN CHANGED LANE, NO SAVE VERSION MOVES
(still v7). FULL OLD->NEW MAPPING IN THE CHANGELOG. TWO FORCED ASSIGNMENTS
REPORTED NOT HIDDEN: cr_frost_ward -> Second Prison (no ancestor exists; a slot
had to hold it) and cr_lance_focus -> Cryoclasm (the closest remaining Ice
Lance node). Cold Snap and Absolute Zero are RE-SPECCED, not repriced — "Frozen
lasts +1 turn" and "freezing no longer reduces stacks" are both meaningless
under an indefinite hold, so they became a held enemy's Break filling 15/turn
and NO LIMIT on holds.
MAGNITUDES ARE **ADDITIVE, NOT RANKED**: every counter writes its own magnitude
in the units its read site sums (frigid_ranks 10 = percentage POINTS, and
**FRIGID GRIP IS PER STACK NOW** — 1 stack -35%, 2 -70%, 3 -80%, floored at a
0.1 multiplier so a deep pile can never make a zero divisor).
NEW FIELDS, one read site each: deep_chill_ranks, killing_frost, second_prison,
shattered_tempo (the tree's only FLOAT counter — `_max_hero_rank` reads ints,
so `_hero_shattered_tempo` is its own scanner).
§4 **A HELD ENEMY LEAVES THE 14-SLOT TURN BAR ENTIRELY** and its nameplate chip
reads HELD with a tooltip naming every door out. NOTE: an ordinary hold leaves
the bar because next_time is INF, so **the bar's `_is_held` filter is
load-bearing ONLY for the held BOSS**, which keeps its clock — a negative
control stripping the filter PASSED against a raider, and the assertion that
catches it now lives in the boss check.
§5 RUNE AUDIT. **RE-POINTED:** Bitter Grip (frigid 1->3, frostbite 1->2), Long
Winter (frigid 1->3, crystal_edge 1->5), Killing Cold (numbing 1->5), Honed
Lance (**lane tag Shatterpoint -> Thaw** — a dead lane name would have left it
homeless in the bot's build policy AND the per-lane coverage test).
hungering_ranks and hypothermia_ranks did NOT move (their read sites were
already additive). **THE THREE MAGE CLASS-WIDE RUNES TOUCH NO CRYOMANCER
COUNTER**, asserted. **RUNE-ONLY, READ SITE KEPT:** `numbing_ranks` (Glacial
Prison took its node's id). FLAGGED FOR RE-AUTHORING: the Killing Cold is
tagged the WINTER rune but pays into Thaw's Hypothermia plus a node-less
counter — a design call, and rune magnitude is CLOSED since AF.
UNREACHABLE-BUT-KEPT (AR vault pattern, gated `> 0`, reported so a later batch
can re-node or delete deliberately): icy_veins_ranks/icy_veins_charge,
emp_frostbolt_ranks, freezing_ranks/freezing_adv_mark, frost_ward_ranks.
§6 `cold_snap` <-> `bitter_cold` DISSOLVED (rows 6 and 2 of the SAME lane now).
**THE BRIEF'S PREMISE WAS HALF STALE:** it called this an entry in AA's TESTED
rule, but Batch AI retired `test_runes._exclusives` to a bare `pass` — the list
survives only as prose in this file. Other five pairs untouched.
§7 THE BOT: build on the highest-Attack enemy, freeze, LEAVE IT HELD, release
with Ice Lance only when a second freeze is ready or it is the last enemy
standing; Glacial Prison on cooldown vs the highest-Attack UNHELD enemy;
Cryoclasm when a bigger threat than the one he holds appears.
VERIFIED: check_parse 0, check_flow 0 (6 screens), 11 scenes 0 SCRIPT ERROR.
NEW test_batch_as.gd 387/0, STABLE 3/3. Regression: an 6044/0, ah 5410/0 (STAMP
GATE bumped AR -> AS), ah_battle 65/0, ai 2036/0, aj 403/0, ak 523/0, al 556/0,
ar 885/0, test_runes 2982/0, test_rune_battle 94/0, run-harness gates 1/2/3
PASS.
NEGATIVE CONTROLS RUN: opening roll back on raw speed trips 3, Ice Lance not
releasing trips 2, a Cleansing Rite reaching a hold trips 1, the hold getting a
clock trips 2, Frigid Grip back at 3 trips 2. A SIXTH PASSED AND THE GAP WAS
CLOSED, not noted — see §4.
TEST GOTCHAS WORTH KEEPING: (1) `_rebuild_turn_bar` opens by `queue_free()`ing
its old slots and **queue_free is DEFERRED**, so counting immediately after
sees BOTH bars at once — that artefact read exactly like "the held enemy is
still in the bar". Park a `process_frame` between every rebuild and its count.
(2) A turn-bar assertion keyed on `unit_name` needs DISTINCT enemy kinds; three
raiders are three identical tooltips and the check proves nothing. (3) A bare
`BattleUnit.new()` has no nameplate, so `add_status` crashes in
`_refresh_chips` — build the status list by hand for pure `effective_speed()`
math.
KIT SMOKE, fixed lineup, 40 battles/row, DOD_SIM_TALENTS force-learning full
8-node builds: all four rows 40/40 wins, 0 SCRIPT ERROR, Glacial Prison at 1.0
casts/battle. **THE THREE LANES SEPARATED CLEANLY** — ungeared 39% share/146
BD/0.93 enemy Breaks/1.00 taken; WINTER 45%/130/0.68/**0.38**; DEEP FREEZE
**39% (FLAT)**/**300 BD**/**2.67**/**0.03**; THAW **51%**/346 dmg. Deep
Freeze's damage share does not move while the party's Break output nearly
triples — "control is a team resource" as a number. MEASURED AND FLAGGED, NOT
NERFED: Thaw's 51% is the tallest column and ships as written. Kit-mechanics
ratios ONLY, no difficulty signal (Batch R).
REPORTED NOT ACTED ON — **CLOSED BY BATCH AT: Shatter scales on TURNS HELD now,
so it no longer needs a second prison to beat Ice Lance and the bot casts it. Do
not re-record this as outstanding.** As AS wrote it: **SHATTER NEVER FIRED IN THE
SMOKE, and it is a design tension not a bot bug.** Shatter (Thaw) and Absolute Zero (Deep Freeze) are
both capstones and only ONE can be taken, so a Shatter build holds at most TWO
(Second Prison, which costs him Piercing Ice) — and at a limit of one, Shatter
and Ice Lance do the same job for more Mana, so the bot correctly prefers the
Lance. The intended pairing IS reachable (Shatter is in SPEC_POOLS, so he can
EARN it and take Absolute Zero), but no sim row exercised it; test_batch_as
drives the mass release directly instead.
NO DIFFICULTY MEASUREMENT AND NO SIM ROW, deliberately — same as AJ/AK/AL/AR.
BATCH AR (08-07) — THE PYROMANCER, RE-AUTHORED AROUND COMMITMENT. First of
the Mage three, and the last of the four class batches AI promised. One spec
only; the other eleven trees and enemy tuning are UNTOUCHED.
§1 INFERNO MASTER -> **OVERBURN**. **THIS PARAGRAPH IS HISTORY — READ THE
BATCH BS BLOCK AT THE TOP OF THIS FILE FOR THE LIVE PASSIVE.** AR shipped it
with THREE clauses and asserted the asymmetry between two of them as
load-bearing; **BS DELETED THE THIRD AND THE ASYMMETRY DIED WITH IT.** What AR
authored: BONUS +2% damage per remaining Burn turn, CAPPED at +40%; DRAIN 1
Mana per burn-turn at the start of each of his turns, UNCAPPED; REFUND 1 Mana
per turn of Burn CONSUMED. `_overburn_drain`, `_overburn_tick` and
`_overburn_capped` no longer exist. **DO NOT RESTORE THE DRAIN AND DO NOT
RESTATE THE ASYMMETRY** — §2 of BS carries the argument, and the seven-of-eight
diagnosis is why. What survives from this section unchanged: `_overburn_mult`
is still THE ONE PLACE THE CAP IS DECIDED, `_overburn_refund` is still the ONE
refund implementation (FOUR call sites now, not AR's two), and `_mana_regen(u)`
is still the one place the drip's size is decided.
The 6% GLOBAL BURN TICK CONSTANT IS NOT TOUCHED — and it is still not touched
after BS. AR dropped the proposal to weaken it because the drain already priced
unspent fire; **BS's reason is the durable half of AR's: that constant is
shared with enemies, runes and every other burn source in the game.**
§2 KIT: Detonation's Burn bonus 150% -> 250% (cost/cd/BD unchanged) = the
narrow release valve; Wildfire unchanged mechanically = the WIDE one, its desc
now says so; Flamewave and Fireball unchanged (Fireball stays FREE on purpose
— he can always light more, including when that is wrong). FLAME SHIELD IS
RE-SPECCED INTO **IMMOLATE** and stops being defensive: 2 turns of no cap +
DOUBLE drain + attackers set Burning 3. Its 50%-less-damage branch is DELETED,
not left unreachable. PYROBLAST + PHOENIX REBIRTH out of the vault as tree
nodes; Phoenix DROPS ITS EMPOWER CLAUSE (Empower is the Holy Cleric's named
Mercy mechanic and this was a name collision, not a design), and its def MOVED
out of `Classes.vault_ability` INTO the tree so exactly one copy exists —
pool_ability finds it via Talents.granted_ability. Pyroblast needed no
subsystem: a plain damage ability plus one conditional at the damage site.
**"THE PYROMANCER HAS NO DEFENSIVE OPTION ANYWHERE IN KIT OR TREE" WAS AR'S
RULE AND BATCH BS INVERTED IT — see the BS block.** It was correct while
commitment meant no escape hatch AND a punishing Mana drain priced every fire
he lit; with the drain deleted the absence stopped being the spec and started
being a hole in a 135 HP / 85 Constitution sheet. **THE WHOLE INFERNO LANE IS
HIS DEFENCE NOW, and it is EARNED — his OPENING KIT is still all fire**, which
is the half of AR's rule that survives and the half test_batch_ar's `_no_defence`
still asserts (re-pointed in place, with its reason, on the AV/BR precedent).
POOLS: "Flame Shield" stopped existing, so it left SPEC_POOLS["pyromancer"]
(-> "Immolate") AND CLASS_POOLS["mage"] (11 entries now, was 12). Immolate and
Pyroblast are spec-only — both read Overburn, so both fail AH's curation rule.
§3/§7 ALL 24 NODES RE-AUTHORED, **EVERY ID SURVIVES**, saved picks migrate,
NO SAVE VERSION MOVES (still v7). FOUR IDS CHANGED LANE (py_invigorating and
py_flame_shield Kindling->Inferno, py_melt and py_ashes Inferno->Kindling) —
legal, and the reason test_batch_ar repeats the shape audit test_batch_ai
already does generically. THE FULL OLD->NEW MAPPING TABLE IS IN THE CHANGELOG.
ONE FORCED ASSIGNMENT, REPORTED NOT HIDDEN: Ashes of Al'ar (self-revive) has
no successor because §2 removes every defence; py_ashes carries Wildfire
Spread purely because a slot had to hold it. If the designer wants the revive
back it belongs Mage-wide or on a relic, NOT in this tree.
MAGNITUDES ARE **ADDITIVE, NOT RANKED**. accelerant_ranks is percentage POINTS
(node 4, rune 1) and conflagration_ranks is a TURN COUNT (node 2, rune 1), so
node and rune each pay their advertised number alone AND stacked. That is AL's
repair rule applied up front rather than after the fact — the alternative
(`4 * ranks`) would silently quadruple the rune.
NEW FIELDS, one read site each: wildfire_spread, fire_walker, kiln_forged (its
+20% fire resist lands at the SPAWN site beside the relic resist block, and
party_screen mirrors it or the sheet lies), ash_lung, cauterise, focused_flame,
pressure_cooker, aftershock, crucible, total_commitment. Twin Detonation has
NO field — it SETS Detonation's cooldown the way Relentless sets Hack and
Slash's bleed_chance. PRESSURE COOKER READS A CAPTURED FLAG, not the status:
Detonation eats the Burn in the raw-damage block, which runs BEFORE the Break
calc, so `has_status("burn")` is already false on the very target it means
(the same ordering trap AG fixed for the passive).
§4 THE RUNE AUDIT. **RE-POINTED:** the Rune of the Cinder Trail -> its own
`rune_cinder_ember` term (the node took cinder_trail_ranks for a new meaning);
added to Runes.STAT_INT_KEYS because it is a bare 1 that does not end in
"_ranks" — the AA/AB float-into-int trap. **STILL LIVE, RUNE-ONLY NOW** (nodes
gone, read sites deliberately KEPT): supernova_ranks, molten_ranks,
blast_radius_ranks. **INERT AND FLAGGED, NOT GUESSED:** `pyromaniac_ranks` —
the White Flame's middle clause ("Inferno Master grants +1% per burning
enemy") has no home, because Overburn has no per-turn step and inventing one
is the guess §4 forbids. The rune is left exactly as authored; test_batch_ar
ASSERTS THE CLAUSE IS INERT, so a re-authoring has to come and change that
assertion. runes.json changed by ONE field name — a dead-counter re-point, NOT
the magnitude pass the designer closed in AF.
UNREACHABLE-BUT-KEPT (vault pattern, reported so a later batch can re-node or
delete): seeding_ranks, melt_ranks/melted, ashes_ranks, scorched_ranks,
living_flame_ranks, implosion_ranks, chain_reaction_ranks, fuse_ranks,
white_heat_ranks, avatar_flame. Each is gated `> 0` and can never be non-zero.
§5 THE BOT knew ONE new rule — "consume Burn when the drain exceeds Mana
regeneration" — and **BATCH BS §4 REPLACED IT, because it referenced nothing
once the drain was deleted.** The live rule: detonate the largest stack when it
is worth more than waiting (`DETONATE_AT` = 4 burn-turns), Wildfire when
Detonation is cooling, and Immolate whenever there is something to retaliate
against (it is a defensive card now). Instrument honesty, not tuning.
VERIFIED: check_parse 0 failures, check_flow 0 failures (6 screens), 11 scenes
0 SCRIPT ERROR. NEW test_batch_ar.gd 885 checks / 0 failures, STABLE 8/8.
ITS FIRST DRAFT WAS FLAKY AND THE FLAKE WAS CAPTURED, NOT WAITED OUT: driving
`_resolve` by hand leaves the 5% miss and 5% parry rolls live, and a skipped
damage path reads exactly like "the node did nothing" — "Fireball lit the
target" failed 1 run in 8, and a parried Detonation failed Total Commitment's
three checks together. `_spawn` now arms `no_cover` (the Sharpshooter's miss
BYPASS) and zeroes parry/block on both sides, the AK/AL discipline: FORCE
determinism, never retry until it passes. ALSO NOTE `_player_turn` CANNOT BE
DRIVEN HEADLESSLY — it awaits an ability pick that never comes, which is why
the drain lives in `_overburn_tick` and the regen-then-bill ORDER is asserted
positionally against the source instead. Regression:
test_batch_an 6044/0, test_batch_ah 5410/0 (STAMP GATE bumped AQ -> AR),
ah_battle 65/0, ai 2036/0, aj 403/0, ak 523/0 (was 524 — the mage class pool
lost one entry, every remaining one still resolves), al 556/0, test_runes
2982/0, run-harness gates 1/2/3 PASS.
**THE STANDING test_rune_battle 91/1 DEFECT IS CLOSED — 94/0, stable 5/5.**
Its Inferno chip assertion was RE-POINTED at Overburn rather than deleted (the
question it was really asking — does the live chip read live state — is still
worth asking). A SECOND, OLDER RACE IN THE SAME FILE WAS FOUND AND FIXED WHILE
THERE: the White Flame check read the combat log 900 frames AFTER the forced
hit, so it raced fight length and failed ~1 run in 3. AH's fix made the line
get WRITTEN; it did not make it survive to be READ. The log is snapshotted at
the forced hit now.
NEGATIVE CONTROLS RUN, because a test that cannot fail proves nothing: capping
the DRAIN at 40 trips 40 checks, Detonation back at 150% trips 1, renaming
py_cauterize trips 6, and flattening Crucible's refund rate trips 1.
KIT SMOKE, fixed lineup, 40 battles/row, berserker,pyromancer,inquisitor,
beastmaster, DOD_SIM_TALENTS force-learning full 8-node builds (standalone sims
spend no points, so an unloaded run never touches these nodes at all). All rows
40/40 wins, 0 SCRIPT ERROR, and every new ability appears in the rotation
(Backdraft, Immolate, Pyroblast, Firestorm). MEASURED AND FLAGGED, NOT NERFED —
**KINDLING IS THE STANDOUT**: his damage share 46% ungeared -> 66% on the full
Kindling build, vs 48% Inferno and 50% Detonation. Firestorm + Backdraft +
Accelerant's 4%/tick + Conflagration's +2 turns compound, and the drain that is
supposed to price that does not bite in a 7-round smoke fight. Kit-mechanics
ratios ONLY — the smoke lineup carries NO difficulty signal (Batch R) and these
magnitudes are the batch's own, so it ships as written.
NO DIFFICULTY MEASUREMENT AND NO SIM ROW, deliberately — same reasoning as AJ/
AK/AL: a single-spec re-author has no honest control row against a fixed
four-hero party, and ./sim.sh carries no difficulty signal (Batch R).
TWO CLAIMS IN THE BATCH BRIEF WERE STALE and are recorded rather than quietly
actioned: (a) §6 asked for master.html's Wildfire text to be corrected from
"spreads the target's Burn at half duration" — **IT ALREADY MATCHED THE CODE**,
Batch AG updated it; (b) §4 predicted spec runes would break quietly and only
ONE clause did. Same lesson as AP: a note in a brief is not evidence.
BATCH AQ (08-07) — THE MODIFIER POOL 6 -> 19, AND UPGRADES YOU CAN SEE.
Authoring plus one design change; no new subsystem.
§1/§3 THIRTEEN NEW MODIFIERS. Counts by severity 6/6/4/3 (was 1/2/2/1). THE
SIX AN PLACEHOLDERS ARE BYTE-UNTOUCHED — ids, severities, desc — so a save
holding `pending_modifier` still resolves; test_batch_an asserts each.
SIX NEW `BattleUnit` FIELDS, ONE READ SITE EACH (the AN one-line-per-field
form): `mod_bd_mult` (Muffled, INT PERCENT 100=unchanged -> the pressure_add
block in take_hit, beside the hold_bd cut; unguarded because x100/100 on an
int is the identity), `mod_status_turns` (Fleeting -> unit.add_status, and
NEGATIVE turn counts are exempt — a battle-long status is a permanence FLAG,
not a duration), `mod_no_break` (Deadened -> the same pressure_add zeroing,
but NOT `immovable` itself: that logs a Warden capstone proc and a modifier
claiming to be somebody's capstone is a lying log), `mod_no_regen` (Thin Air
-> the turn-start drip in _player_turn; stops the DRIP only, attacks that
BUILD resource are untouched, which is why Rage survives it and Mana does
not — intended), `mod_bleed_add` (Bloodletting -> the on-hit bleed in
_resolve; does NOT ride the ability's own bleed roll, gated on `ab.damage`),
`mod_recoil` (Mirrorbound -> `recoil_pct`, added AFTER Magi's Wrath's per-hit
fade; paid via take_tick_damage so recoil cannot itself recoil and Ashes of
Al'ar still catches a lethal one). The other seven ride existing hooks or
edit a stat at spawn: Parched (resource/second_resource clamp — clamps to
the CURRENT value too, Overgrown's lesson), Slick (+0.5 `delay` per ability),
Dull Edge (crit_bonus -0.05 floored at -CRIT_CHANCE so total crit can never
go negative), Hoarfrost (`_apply_status` chilled 3 — the normal door, so
Frigid Grip and every other rider behave), Feverish (attack x1.25), Miasma
(healing_received_mult x0.5 — the Holy Conduit hook), Encumbered (+2
`cooldown` ONLY where cooldown > 0).
`_apply_battle_modifier` split into `_active_modifier()` + `_stamp_modifier(u,
mod_id, inherited)` — ONE list of nineteen, two call sites.
§2 THE ONE DESIGN CHANGE: after the guaranteed low first draw, the OTHER TWO
SLOTS FILL FROM THE SEVERITY 3-4 POOL ALONE (was low+rest combined). MEASURED
BEFORE/AFTER on 2000 sampled offers: the old fill put TWO LOW OPTIONS in 1717
of 2000 (86%) once the pool was 19 — three cheap options paying three cheap
rewards. Now every offer reads ONE SAFE, TWO GAMBLES; the floor still holds by
construction. A guard falls back to the low pool if the high pool ever cannot
fill (it holds 7 and needs 2) — a guard, not a path.
**`rot` WAS AUTHORED, IMPLEMENTED AND DROPPED — READ THIS BEFORE RE-ADDING
IT.** Halving `max_hp` at spawn is fine inside the fight (Unkillable reads
max_hp - tenacity_hp_gained, Tenacity adds flat, the Mercy threshold is a
ratio — all proportional). THE KILL IS THE SAVE SYNC: battle.gd's victory
branch does `Run.party[i]["max_hp"] = heroes[i].max_hp - tenacity_hp_gained`,
so a HALVED max HP outlives the battle that charged for it — hp clamped under
it, the map card showing the halved maximum until the next victory re-syncs.
A one-battle bargain would cost half the party's HP for the rest of the run.
Undoing it needs a SEVENTH field read at the sync, over the batch's stated
budget, and the batch's own instruction for that case is drop-and-report. So
severity 4 ships THREE, not four, and the pool is 19, not 20. test_batch_an
pins `rot` ABSENT.
§4 COMPANIONS WERE MISSING EVERY MODIFIER — pre-existing, six modifiers made
it nearly invisible. `_apply_battle_modifier` walks heroes+enemies at spawn
and a beast exists at neither moment. Fixed at the `_do_summon` site beside
the armor/Stability/crit copies, with `inherited = true`. CORRECTION TO THE
BATCH DOC: it named Feverish as an example of what the beast misses. IT DOES
NOT — the beast's cfg takes `hunter.attack`, already multiplied, and
`comp.crit_bonus = hunter.crit_bonus` already carries Dull Edge. Those are
the two branches `inherited` SKIPS; stamping them again would double them.
Everything else (Hoarfrost's chill, Miasma, the six fields) genuinely was
missed. Overgrown/Parched DO now clamp a mid-fight arrival — consistent with
"binds both parties", and flagged rather than hidden.
§5 THE UPGRADES ARE VISIBLE OUTSIDE A FIGHT. (A) `_mark_upgraded(btn, u, ab)`
prefixes "◆ " and paints the label `UPGRADE_GOLD` = Color(1.0, 0.9, 0.5) (the
map card's unspent-pick gold) on THREE battle surfaces — the basic-attack
button, every `_ability_popup_button`, and the summon picker. The hero sheet's
chips get the same mark; party_screen now CAPTURES `Run.apply_upgrades`'s
return instead of discarding it, so the sheet's ◆ carries the battle
tooltip's guarantee (it can only mark what actually landed) and its hover
gains the same trailing `Honed · Swift` line. (C) map hero card: a `◆N` badge
beside the rune slots, hidden at zero, hover lists `Overpower — Honed` one
per line. IT TAKES NO CLICK — it is a Label CHILD OF THE CARD BUTTON with
MOUSE_FILTER_PASS, so the tooltip is its own and the press falls through to
the card. (D) four glossary entries: `ability_upgrades` (Progression),
`bargain`/`modifier`/`severity` (The Run), cross-linked; glossary.json 66 ->
70.
NOT AUTHORED, deliberately, and stated so the rule stays visible: hero-only
modifiers ("no items this fight", "the skill-check window shrinks") break
binds-both-parties and are a difficulty slider wearing a bargain's clothes;
miss-chance modifiers land cleanly on Dazed's hook and play as tedium.
UNCHANGED: REWARDS, the bot's severity-extreme bargain policy, the offer
screen layout, the six existing modifiers, SAVE v7 (nothing new persists).
VERIFIED: check_parse 0 failures, check_flow 0 failures (6 screens), 11
scenes 0 SCRIPT ERROR. test_batch_an 5667 -> 6044/0, test_batch_ah 5416/0
(its master.html STAMP GATE bumped AP -> AQ), ah_battle 65/0, ai 2036/0, aj
403/0, ak 524/0, test_runes 2982/0, run-harness gates 1/2/3 PASS.
NEGATIVE CONTROLS RUN, because a test that cannot fail proves nothing:
Muffled 75->80 and mod_bleed_add 15->14 both trip their checks, and restoring
the old `low + rest` fill trips the §2 assertion at 1717/2000.
SCRATCH (in the scratchpad, NOT committed — the batch forbade new
scaffolding): check_aq.gd 18/0 drives the DRAWN half test_batch_an cannot
see — the ◆2 badge on a real map card with its tooltip text, colour,
MOUSE_FILTER_PASS and Button parent; exactly one marked chip on a real hero
sheet with the trailing hover line; and exactly one ◆ button in a real battle
(Overpower is not the class core attack, so it lives in the Abilities
dropdown, not on the bar).
GOTCHA THAT COST A BISECT: splitting the on-hit bleed block moved `randf()`
out from behind its `not strike_target.dead` guard. A single extra draw
shifts EVERY later roll in the battle — the cheapest possible way to make an
unrelated probabilistic test flap. The guard is back outside the roll. When
restructuring anything in `_resolve`, PRESERVE THE DRAW ORDER.
KNOWN-BAD, NOT OURS: test_rune_battle 91/1 (the Inferno chip check), the
standing defect since AK. **test_batch_al's flake IS NOW CAPTURED AND
REPRODUCES ON UNMODIFIED HEAD** — the failing check AO could not name is
`"Spite reflects damage at the attacker"` (§11 `_live_spite_break`), and an
interleaved A/B of HEAD vs this batch's battle.gd read HEAD 2 failures of 4,
AQ 0 of 4. It is a HARNESS RACE, not product code: `_spawn` waits a fixed 20
`process_frame`s while the battle's own `_run_battle` loop is advancing on
REAL SceneTreeTimers, then drives `_resolve` by hand on top of it. Do not
chase it in product code, and do not read one clean AL run as proof.
SIM SMOKE ONLY, NO DIFFICULTY CLAIM — n=20, no control row, and ./sim.sh
carries no difficulty signal (Batch R): `./sim.sh --run 20` walked clean, 0
SCRIPT ERROR, every one of the nineteen reachable, bargains 6.6/run at avg
severity 3.52. Read that severity as INSTRUMENTATION for §2 (the bot's policy
is severity-extreme, so it takes the harshest card and §2 guarantees that
card is now a 3 or a 4) — never as a difficulty reading.
BATCH AP (08-07) — THE MINI-BOSS REWARD BECOMES REAL. `Run.ABILITY_UPGRADES`
was offered, picked, stored on the member and saved, and NOTHING READ IT AT
BATTLE SPAWN — three mini-bosses a run handed out an inert prize. Machinery
only: the pool stays FOUR and no new upgrade is authored, so the authoring
batch that replaces the four has somewhere to land.
§1 THE FOUR EFFECTS. `up_damage` Honed `damage = int(round(damage * 1.5))`;
`up_cooldown` Quickened `cooldown = maxi(cooldown - 2, 0)`; `up_free`
Effortless `cost = 0`; `up_speed` Swift `delay = maxf(delay * 0.75, 1.0)`.
TWO DESCRIPTIONS CORRECTED, because they were authored before anything read
them: EFFORTLESS ZEROES `cost` AND NEVER `faith_cost` — Mercy is the Holy
Cleric's identity resource and a free Resurrection is a different game, so it
now reads "costs no Rage / Mana / Focus (Mercy is unaffected)". SWIFT said
"+2 initiative speed" against a roster whose delays run 1.5-4.0, i.e. the
authored number was never checked against the field it names; it is 25% off
floored at 1.0, "Arrives 25% sooner". THAT FLOOR-AND-PERCENTAGE IS THE ONE
BALANCE JUDGEMENT IN THE BATCH and it is flagged, not buried. Honed and
Quickened keep their text.
§2 ONE HELPER, TWO CALL SITES, AND THE ORDER IS LOAD-BEARING.
`Run.apply_upgrades(member, abilities)` sits beside ABILITY_UPGRADES, stamps
every `member["upgrades"]` entry onto the matching ability by display_name,
and RETURNS {ability name: [upgrade names]} of what actually landed — the
battle tooltip reads that return, so it can only ever advertise an upgrade
that really applied. Called from THE TWO SITES THAT ASSEMBLE A KIT, the ones
the Batch AH ordering fix already touched: the hero spawn in battle.gd and
the sheet assembly in party_screen.gd. RunSim reloads the battle scene and
inherits the battle.gd site — no third call.
**IT RUNS AFTER `Talents.apply_from_tree` AND AFTER THE EQUIPPED-RUNE PASS,
NEVER BEFORE.** Several talents (and two rune payloads) SET an ability field
rather than add to it — `sm_lunge`'s upgrade path SETS Lunge's cost to 15 —
so an Effortless applied first is silently overwritten. UPGRADES ARE LAST, SO
THEY ALWAYS WIN. Placing it after runes rather than immediately after the
tree is a deliberate deviation from the batch doc's letter in favour of its
stated rule: runes can `set` an ability field AND can grant one, so an
upgrade naming a rune-granted ability only resolves in this position.
CORRECTION TO THE BATCH DOC: it cites "the Resonant Hymn node sets Hymn of
Hope's cost to 25". NO SUCH NODE EXISTS — Hymn of Hope is cost 0 /
faith_cost 1 and no Holy node touches its cost. The rule is right, the
example is not; `sm_lunge` is the live one.
An entry naming an ability the hero no longer holds is skipped SILENTLY (a
spec reroll can do it, and it is not an error), as is an unknown upgrade id.
Stacking and never-twice already held in has_upgrade/award_upgrade_pick and
are untouched; `upgrades` already persisted, so NO SAVE VERSION MOVES (v7).
§3 THE OFFER ONLY PAIRS AN UPGRADE WITH AN ABILITY IT CAN CHANGE.
`roll_upgrade_offer` used to take a random un-taken upgrade and a random
owned name, so it could offer Honed on Heal (damage 0), Effortless on Blood
Price (cost 0) or Quickened on a basic (cooldown 0) — a pick that reads as a
reward and does nothing, the exact bug the batch exists to close. Each owned
name resolves ONCE through the existing `Classes.pool_ability` (no second
resolver) and `Run.upgrade_fits(id, ab)` keeps damage>0 / cooldown>0 /
cost>0; up_speed fits everything. An upgrade with no eligible ability is
DROPPED rather than paired with a dud; the offer already filled short.
CONSEQUENCE WORTH KNOWING, measured not assumed: `pool_ability` resolves
spec kits, pool entries, vault and talent grants but NOT the class core
attack or its kit overrides, so exactly ONE name per hero drops out of the
candidate list — Frostbolt (cryo), Smite (holy), Quick Shot (sharpshooter);
the Berserker loses none, "Strike" was already filtered. Offers still came
out at three in 2000 rolls, so nothing shrank in practice.
§4 VISIBILITY. `BattleUnit.ability_upgrades` (new field, {name: [labels]},
fed from cfg at spawn) and one trailing line on the ability button's
tooltip — `Honed · Swift`. NAMES ONLY: the magnitudes are already in the
numbers above them, which now reflect the upgrade. The hero sheet assembles
the kit the same way, so an Effortless ability loses its cost tag there too.
Nothing else in the UI moved; the pick still resolves on the map hero card.
§5 THE THREE ONE-LINERS. (a) `Talents.desc_for` trims dead decimals — a whole
25 renders "25", a genuine 2.5 still "2.5". NOTE the standing note was
slightly wrong about the symptom: `String.num(v, 2)` was rendering "25.0",
not "25.00". Reported since AJ, closed here. (b) test_batch_ah.gd:202 `%
[cross]`. (c) **THE `treasure`/LOOT NODE TYPE NEEDED NO DELETING — IT WAS
ALREADY GONE**, taken with the whole node-map generator when AN replaced it
with the line. Nothing in any .gd/.tscn/.json names it (one line of event
flavour text uses the word "treasure" in prose). It had been listed as
outstanding since AC; THE LISTING WAS STALE, NOT THE CODE — which is the
same failure this batch's headline bug is.
DOCS: master.html stamped Batch AP; §6a corrected (Effortless/Swift, the
pairing filter, the after-talents ordering); its TALENT TABLES REGENERATED
from the live trees but ONLY where a dead decimal was the sole difference —
107 cells rewritten, 2 LEFT ALONE and reported instead (Overkill, because
the name collides across the Berserker and Sharpshooter trees and a
name-keyed rewrite would have swapped them; Rampage, whose doc text drifted
in wording before this batch). master.html never listed a Loot node.
VERIFIED: check_parse 0 failures, check_flow 0 failures (6 screens), 11
scenes 0 SCRIPT ERROR. test_batch_an 5667/0, test_batch_ah 5416/0 (stamp
gate bumped AO -> AP), ah_battle 65/0, ai 2036/0, aj 403/0, ak 524/0, al
556/0, test_runes 2982/0, run-harness gates 1/2/3 PASS.
ONE TEST WAS RE-POINTED, with the reason in the file: test_batch_aj pinned
its tooltips with `shown.contains(String.num(rendered, 2))`, i.e. against
the OLD rendering. It builds the expectation from the DESIGN value in
SCALE_VALUES now (whole numbers as integers, bz_unstoppable's genuine 3.5
kept) plus a companion check that no dead decimal survives — a test, not a
mirror of desc_for. 389 -> 403 checks.
SCRATCH (in the scratchpad, NOT committed — the batch forbade new
scaffolding): check_ap.gd 30/0 (each effect on real Ability objects, the
floors, Effortless proven to leave faith_cost alone on Resurrection,
stacking, unheld/unknown ids skipped, 2000 offers with ZERO duds, Effortless
never on a 0-cost ability over 400 rolls, desc_for's trim across all 263
tree nodes, AND THE ORDERING RULE IN BOTH DIRECTIONS — sm_lunge sets 15,
upgrades-last gives 0, upgrades-first gives 15). check_ap_live.gd 12/0
drives a REAL battle: Lunge live at cost 0 and the Swift delay, both labels
on the unit, the tooltip's last line reading "Effortless · Swift", Honed
live on Ice Lance with the tooltip's damage line already carrying the
upgraded number, an un-upgraded ability gaining no line, and the hero sheet
chip showing the upgraded cost.
KNOWN-BAD, NOT OURS: test_rune_battle 91/1 (the Inferno chip check), the
standing defect since AK. test_runes prints a `start_rune_enabled` SCRIPT
ERROR from a name AN retired — pre-existing, still 2982/0.
NO SIM RUN AND NO DIFFICULTY CLAIM: this batch turns three inert picks a run
into live ones, which is a real power delta, but ./sim.sh carries no
difficulty signal (Batch R) and there is no control row for it here.
BATCH AO (08-07) — DIRECTION, GATING, KILL SWITCH. Three changes from playing
AN. No new systems and no balance work beyond ONE gold number.
§1 THE ROAD READS LEFT TO RIGHT. `SLOT_X_START` 1196.0 -> 84.0 (the exact
mirror across the 1280-wide screen, so the margins are the old ones reversed)
and `_slot_pos()` ADDS the step; `SLOT_X_STEP` is unchanged at 98.0. Both
Line2D draws read `_slot_pos()` so the road and the walked stretch followed
with no edit. THE COMPASS LABEL IS DELETED — it existed only because the
direction was unconventional, and a caption explaining which way to read a
line is a cost the line should not need. The slot numbers 1-12 STAY (twelve
near-identical dots want a ruler either way); their comment no longer claims
the boss-on-the-left made counting hard. The `ON THE READING DIRECTION`
paragraph is gone from the file header. In-game text corrected with the code:
the Batch Z FRAMING CARD said "RIGHT TO LEFT" and it now says left to right.
§2 THE OFFER MOVES TO ELITES AND MINI-BOSSES — 4 encounters a zone, not 10. A
bargain before all eight plain fights was a toll booth; it is an event now.
Gate is `if ty in ["elite", "miniboss"]` in BOTH map_screen._on_slot_pressed
AND run_sim._walk (the harness must walk the road the player walks). Bosses
still get NOTHING. `claim_reward()` is already on every victory path and
returns empty when nothing is pending, so plain fights needed no special case.
A MINI-BOSS NOW FIGHTS UNDER A MODIFIER, deliberately: every enemy in its
warband already carries 1.5x max HP, so a severity-4 pick there is the
sharpest gamble in the run, and the severity-1-or-2 floor is what makes it a
choice rather than a trap. Its existing spoils (elite gold, 1 talent point,
the ability-upgrade pick) are untouched and STACK with the bargain reward.
offer_screen's subtitle is THREE-WAY now (elite / mini-boss "the WARDEN of
this zone blocks the road" / plain fight KEPT as a defensive default though
nothing routes there). Map dot tooltips moved with the gate: the mini-boss dot
announces the bargain, the plain-fight dot no longer does.
FIGHT GOLD 25-35 -> **45-60**, one number in one place (`Run.award_gold`).
Elite/mini-boss 80-100 and boss 110-130 UNCHANGED. Deliberately BELOW the old
bargain payout, because a plain fight no longer charges a modifier for it.
§3 BATTLE `DEBUG ▾` -> KILL ALL ENEMIES (id 3 — 0/1/2 and 10+ were taken).
`_debug_kill_enemies()`: returns on `battle_over`; for every living enemy sets
`hp = 0`, calls `_die()`, `refresh_bars()`; logs one line in the debug colour;
sets `action_panel.visible = false` (a turn parked on `await _ability_picked`
would otherwise leave live buttons under the victory panel); calls
`_check_end()` LAST so the NORMAL victory branch runs — gold, points, the 15%
heal, claim_reward, elite spoils, the summary. **IT IS A SWITCH, NOT A HIT**:
it does NOT route through `take_hit`, so no damage event, no on-hit/overkill
proc, no floating number — and the accepted cost is that ON-DEATH TALENT PROCS
READING A KILLING BLOW (Seeding Embers and friends) DO NOT FIRE. It inherits
`_debug_allowed()` and the single `Run.debug_used` honesty write at the top of
the dispatch — battle.gd still has EXACTLY ONE write site (asserted).
VERIFIED: check_parse 0 failures, check_flow 0 failures (6 screens), 11 scenes
0 SCRIPT ERROR. test_batch_an 5667/0, test_batch_ah 5416/0, ah_battle 65/0,
ai 2036/0, aj 389/0, ak 524/0, al 556/0, test_runes 2982/0, run-harness gates
1/2/3 PASS. test_batch_ah's master.html STAMP GATE was bumped AN -> AO (that
is the one thing it exists to make you do); no test asserted the old routing
or the old x-geometry, so nothing else moved. SCRATCH (moved to the
scratchpad, NOT committed — the batch forbade new scaffolding): check_ao.gd
24/0 reads the twelve slot-button x positions OFF THE LIVE SCREEN and asserts
they ascend + the compass label is absent + both gates in source + all four
gold bands over 400 rolls each; check_ao_live.gd 27/0 drives a REAL mini-boss
battle (bargain accepted, modifier armed) and a real plain fight through the
switch and reads the booking off Run — no damage in `_run_slice`, panel
hidden, battle_over, gold paid, party healed, modifier cleared, the talent
point paid on the mini-boss and NOT on the fight, four upgrade picks owed.
PURITY: profile.json/relics.json/trees.json byte-identical, no run_save.bin
left behind.
KNOWN-BAD, NOT OURS: test_rune_battle 91/1 (the Inferno chip check), the
standing defect since AK.
SEEN ONCE, NOT REPRODUCED: test_batch_al read 556/1 on one invocation and
556/0 on the eight after it; the failing check was not captured. Nothing this
batch touches is on AL's path (Warden tree, live block/taunt battles). Watch
it; do not treat 3/3 clean as proof it is gone.
SIM SMOKE ONLY, NO DIFFICULTY SIGNAL — n=20 is far below the resolvable
difference (completions band +/-17.5 pts at that n) and this batch has no
control row: `./sim.sh --run 20` walked clean, 0 SCRIPT ERROR, and the two
numbers that PROVE THE GATE MOVED are bargains taken 6.0/run (was one per
fight and elite) and gold earned 2036/run. Read those as instrumentation, not
as balance.
REPORTED NOT ACTED ON: nothing outstanding — both items (test_batch_ah.gd:202's
bare `%s`, and desc_for's two-decimal rendering) WERE CLOSED IN BATCH AP.
BATCH AN (08-07) — MAP SCAFFOLD. The branching node map is GONE; a run is a
LINE of 3 zones x 12 slots = 36. Every zone is the IDENTICAL authored shape
(Run.ZONE_SHAPE): fight fight ELITE fight fight MINI-BOSS fight fight ELITE
fight fight BOSS. Zone 3's boss is the end boss. Renders LEFT TO RIGHT (slot 1
left edge, boss right) — AN shipped it right-to-left having flagged that as
unconventional, and BATCH AO FLIPPED IT; it is SLOT_X_START/SLOT_X_STEP in
map_screen.gd.
REWARDS AND MODIFIERS IN THIS BATCH ARE PLACEHOLDERS, deliberately — the point
was a playable 36-slot run to feel the pacing before 66 pieces of content get
authored against it.
DELETED, NOT LEFT UNREACHABLE (test_batch_an pins each as ABSENT): FLOORS,
NODES_PER_TIER, FIGHT/REST/SHOP/EVENT_NODES, both DECK_FALLBACK tables,
MINIBOSS_TIER, _deal_deck/_deck_violations/_repair_deck, the link graph,
_guarantee_inbound, _ensure_key_route/_route_satisfied, map_mode(),
miniboss_on(), dealt_tiers(), award_talent_flex(), roll_ability_offer(),
grant_start_runes()/start_rune_enabled()/spec_opening_enabled()/
_generate_spec_rune(), ALL REST NODES, and the edge-column adjacency rule WITH
its documented-70%/actual-53% bug (it needed deleting, not fixing). The reason
the test pins absence: that bug survived three batches because the code still
resolved and still disagreed with its own comment.
STATE: `Run.map` is a FLAT 12-slot Array of {type,visited,enemies,theme};
`slot_idx` replaces floor_idx/node_idx everywhere. reachable() returns exactly
one slot; advance(slot) takes ONE arg. battle_budget reads the SLOT number
(1-12) and Batch T's ramp is unchanged byte-for-byte (it was fitted against
depth, and a line is nothing but depth). SAVE v7, and a pre-v7 save is REFUSED
AND CLEARED on load — a party at tier 7 column 2 has no honest position on a
line with no columns (the Batch AI call about ranked purchases, applied to the
board). _migrate_trees() lost its save_version arg with the pre-AI branch.
THE OFFER (§3, new scenes/offer.tscn + scripts/offer_screen.gd): 3 bargains
before every ELITE and MINI-BOSS (BATCH AO re-gated it; AN shipped it before
every fight and elite), none before plain fights/bosses. One MODIFIER
(binds BOTH parties) + one REWARD, both visible, no decline. Severity 1-4 is
FLAT and authored per modifier; REWARDS is keyed on it. THE FLOOR — every
offer holds a severity 1 or 2 — is guaranteed BY CONSTRUCTION (first draw out
of the low pool), never by rejecting rolls. Reward pays ON VICTORY: the
modifier is the price, and "a merchant follows the fight" cannot precede the
fight it follows.
SIX PLACEHOLDER MODIFIERS, four new BattleUnit fields with ONE read site each:
mod_ignore_armor (Brittle -> effective_armor returns 0.0 BEFORE every armor
source), mod_speed_mult (Frenzied 1.3 -> effective_speed), mod_no_heals
(Bloodless -> heal_amount, at the top with the other absolute refusals so
Bleed/DoT still tick), mod_cost_mult (Warded 1.25 -> battle._eff_cost, applied
AFTER every discount and NEVER added to a zero — "basic attacks are free"
describes the kit, Strike is cost 0 already). Overgrown and Tinderbox need no
field: hp clamp at spawn, and the existing type_dmg_bonus["fire"] hook.
Stamped by battle._apply_battle_modifier() AFTER spawn and BEFORE the opening
initiative roll (Frenzied must be on the board before next_time seeds off
speed).
MAP SCREEN IS THE PARTY SCREEN. Four hero cards (portrait, spec, HP bar with
numbers, resource bar, THREE rune slots, unspent badge); card click -> talent
tree, rune slot click -> pouch overlay; owed ability/upgrade/rune picks resolve
ON THE CARD. Potions usable on the map (bomb + defense stay battle-only and say
why). Party button and list view DELETED — party_screen.gd is now the HERO
SHEET, entered for Run.hero_screen_idx with a 4-button switcher, and its runes
are READ-ONLY (one place writes `equipped`).
REWARDS RE-CUT: mini-boss -> generic ABILITY UPGRADE pick-of-3 (placeholder
pool of 4 in Run.ABILITY_UPGRADES; upgrades STACK on one ability, the SAME
upgrade never twice — stored on the member as `upgrades`=[{id,ability}], and
NOTE: nothing reads them at battle spawn yet, they are recorded only). Zone
bosses 1-2 -> ability pick from the SPEC POOL ONLY (Classes.CLASS_POOLS is
left standing and still resolves; nothing reads it). End boss -> relic + gold
+ run ends, no pick.
SCHEDULING (§5/§7): merchant 40% after a cleared fight/elite with a FLOOR of 4
dry slots; event 25%. BOTH rolled ONCE on the victory screen and queued on
`Run.pending_after` — rolling from the map would re-roll every redraw and the
floor would mean nothing. Run.next_after_scene() is THE one place that answers
"where next"; shop and event screens both call it on leave.
ATTRITION: no rests. Clearing ANY slot heals 15% via Run.victory_heal_pct(),
which rides the SAME victory_heal_pct relic hook (Chalice stacks -> 25%, one
read site). ITEM CAP 6 per type: Run.add_item() returns what LANDED and every
grant goes through it; the shop greys a full stack rather than taking gold.
TALENT POINTS: 1 apiece from elite/miniboss/boss INCLUDING the end boss, 0
from fights = 4/zone, 12/run, +1 awakening = 13 against an 8-node tree. ONE
PURSE: at 12-vs-8 the row exclusivity does the barring AI's flex purse existed
to do, so `talent_flex` survives but nothing feeds it. `Talents.purse_for`
(NEW) is the single site deciding which wallet pays — flex first, normal
points after; hero sheet AND RunSim._spend_talents both call it.
THE ONE ARITHMETIC DEVIATION, FLAGGED NOT SILENT: §8 says 12/run and a surplus
of 4. The awakening point (award_spec_point) was KEPT because §8 enumerates
SLOT types and the awakening is not a slot — so the real totals are 13 and 5.
Removing it would push the first talent pick from "the moment you choose a
spec" out to slot 3, a live design change the batch never asks for.
test_batch_ai pins 13 explicitly, so the designer deciding otherwise trips it.
RUNES: 3 slots FLAT from run start (rune_slots() ignores zone_idx now), heroes
start with NONE. roll_rune_candidates lost its guarantee_spec param with AF's
opening pick. Rune CONTENT untouched — the rebuild is its own batch.
SIM: walk_to_next_fight walks the line (one slot, no _pick_node, no rest
policy). Bot bargain policy is SEVERITY-EXTREME (harshest above 60% avg HP,
mildest below). Report gains merchants/events/bargains-taken/avg-severity and
loses the rest lines. RETIRED FLAGS: DOD_SIM_MAP, DOD_SIM_MINIBOSS,
DOD_SIM_START_RUNE, DOD_SIM_SPEC_OPENING — all four controlled things that no
longer exist. Matrix row reads `map=line` and carries none of them; depth= is
out of 36 now, not 33, so NO PRE-AN ROW IS COMPARABLE. `choice=` is retained
and reads 0% forever BY DESIGN (a missing metric reads as a broken
instrument; a zero reads as a line).
VERIFIED: NEW test_batch_an.gd 5667 checks / 0 failures, stable 3/3 (the
line's shape and one-way walk, every deleted name pinned ABSENT, 2000 sampled
offers for the floor and for severity-matched rewards, all six modifiers on
BOTH parties in a LIVE battle at the read site each implements, a NO-modifier
battle proving the pre-AN path is untouched, upgrade stacking/never-twice,
spec-only ability draws, the merchant floor DRIVEN not sampled, the item cap
refusing, flat 3 rune slots). Regression: test_batch_ah 5416/0 (its §3 offer
and §4 map sections RE-POINTED IN PLACE with the reason in the file),
test_batch_ah_battle 65/0 (owed-pick affordance re-pointed to the card),
test_batch_ai 2036/0 (schedule + migration re-pointed), test_batch_aj 389/0,
test_batch_ak 524/0, test_batch_al 556/0, test_runes 2982/0, run-harness gates
1/2/3 PASS. 11 scenes + every script compile, 0 SCRIPT ERROR.
DELETED WITH THEIR FEATURE: test_start_rune.gd, test_start_rune_ui.gd.
KNOWN-BAD, NOT OURS: test_rune_battle 91/1 (the Inferno chip check).
NEW SCRATCH GATES (keep them; they catch what --check-only cannot):
`check_parse.gd` force-loads every script AND scene so an autoload-dependent
compile error fails loudly, and `check_flow.gd` instantiates every screen this
batch touched against a live run and fails a screen that builds < 5 nodes.
GOTCHA THE FIRST RUN HIT: `root.process_frame` DOES NOT EXIST — process_frame
is a SceneTree signal and `root` is a Window. Awaiting it never returns, and
because Godot buffers stdout when not a TTY the run produces ZERO OUTPUT and
looks like a silent hang rather than an error. Use bare `process_frame`.
SECOND GOTCHA: `--quit-after N` KILLS a --script test mid-run and it prints
nothing — the suites that spawn live battles (ak/al/rune_battle) must run
WITHOUT it.
NOT DONE, deliberately, per "Not in this batch": no new abilities, modifiers,
runes, upgrades or boss pairs authored; the nine unauthored talent trees
untouched; Cairnmoss Poultice NOT re-specced (its rest_heal_add hook is dead
and stays noted — Martyr's Knucklebone carries the same dead hook alongside a
live victory_heal_pct, so it is half-dead rather than dead).
NO EVENT IS BROKEN BY §7 (the batch asked for a list): the event requirement
vocabulary is min_gold / max_gold / zone_slot / has_item / spec_in_party /
fallen_hero — there has never been a rest-node or shop-node condition, so
nothing was gated on one and nothing silently stopped firing. Four events
mention a waystone/merchant/camp in FLAVOUR only (waystone_cache,
abandoned_wagon, old_trapper, mushroom_ring) and all still fire.
REPORTED NOT ACTED ON: (a) the three point-granting events (Blood Altar,
Training Grounds, Warden's Echo) now pay into an economy that is already 5
points in surplus — they were sized against Batch AI's exact-8 purse.
(b) SUPERSEDED BY BATCH AP — as written it said ability UPGRADES are recorded
on the member and nothing reads them at battle spawn. They are wired now:
`Run.apply_upgrades` runs at the hero spawn and on the hero sheet, AFTER
`Talents.apply_from_tree` and the rune pass. See the AP block for the
ordering rule; do not re-record this as unwired.
(c) CLOSED IN BATCH AP — desc_for's dead decimals are trimmed.
BATCH AL (08-06) — WARDEN, ALL 24 NODES. The third of the four class batches
AI promised. One spec only; the other nine trees and enemy tuning are
UNTOUCHED.
ROWS ARE THEMED: 1 who your defence pays / 2 how much you hold / 3 attrition
/ 4 what compounds / 5 active defence / 6 the engine running / 7 the last
stand / 8 capstone. Row 1 is the model for the tree — one trigger, three
beneficiaries (a block heals HIM, a block stuns THEM, a taunt empowers THE
PARTY).
MAGNITUDES, one decision applied 24 times (a node is a ROW, priced against
the two doors it closes): Unkillable 2->8%, Richocet 5->35%, Toughness
5->25%, Provoke +1->+2 foes, Rally 15%/2t -> 30%/3t, Endurance 1->3%/turn
(cap +75% unchanged and now REACHABLE — turn 25 not turn 75), Iron Will
4->12%/debuff, Tenacity +5->+15 max HP, Sundering 25->100% of the Break
splash, Elemental Weakness 5->20%, Shield Mastery +1->+2 turns, Spite
8->30%, Plate Discipline +3->+12% (climb 8->20%, caps in 2 hits not 5),
Bruising Guard 10->30 BD, Shared Vigil 3->12%, Battered Not Broken 8->30
Break shed, Grudge 6->25%, Steadfast 15->60%. EVERY ID SURVIVES, so saved
picks migrate and NO SAVE VERSION MOVES (still v6).
TWO RE-SPECS IN PLACE, BOTH FOR THE SAME REASON — AH moved the ability each
one modified into the earnable spec pool, so both were DEAD on a Warden who
never drew it. `wd_stomp_drill` (was Rallying Stomp, "War Stomp restores +5%
more") -> RALLYING CRY: every ally regains 4% of max resource at the start of
each of his turns, and War Stomp restores 20% more IF he owns it.
`wd_bannerman` (was "Interpose grants +1 charge") -> BULWARK LINE: Shieldwall
also grants every ally +10% Block chance for its duration, and Interpose
hands each ally an extra charge IF he owns it. THE RULE THIS LEAVES: a talent
may READ an earnable ability, it must not DEPEND on one.
TANK AND SPANK IS CERTAIN (was a 15% roll). Mocking Blow is free and on his
rotation constantly, so the roll fired several times a battle and changed no
decision — that is noise, not variance. The node has no {v} left to render.
ONE CROSS-ROW CONDITION: Spite + Bruising Guard used to be an EXCLUSIVE FORK
(reflect, or convert blocks to Break) — same trigger, same question, so it
was really "which number do you prefer". Split across rows 5/6 both are
reachable and the second welds them: `spite_break` makes the reflect carry
Break equal to 50% of its damage. It needed its OWN field, unlike AJ's
index-counter trick, because the two halves fire on DIFFERENT EVENTS (a
block vs the damage site).
UPGRADE PATH (the AK pattern): Hold the Line sits in SPEC_POOLS["warden"] AND
the tree. Node on an unowned ability = grant; on an owned one = upgrade —
Break cut 50%->80% via `hold_line_upgraded`, no-death window 2 status turns
-> 3 (the +1 is the hero-turn tick offset). The 50/80 rides the hold_bd
STATUS POWER so unit.gd keeps ONE read site; that read is INTEGER arithmetic
on purpose (1.0 - 80/100.0 lands at 0.19999999 and an 80% cut on 100 Break
would read 19).
NEW FIELDS, four not the doc's three (the doc's count did not allow for the
upgrade path it also asks for — exactly as AJ and AK needed theirs):
rallying_cry (the turn-start block in _run_battle, beside the Vengeful
Guardian re-arm), bulwark_ally_block (the shield_block special),
spite_break (the Spite reflect), hold_line_upgraded (the hold_the_line
special). NEW STATUS `bulwark_line`: it rides the SAME Heavy Plating SLICE of
the block roll Shieldwall's own stance does, so the cover is real Block — but
it carries its own LABEL, so an ally's covered block is logged "(Bulwark
Line)" and does NOT feed the Warden's Tenacity/Rally (both test
block_source == "Heavy Plating"). The Warden is excluded from his own grant:
his +25% stance is already up.
TWO RUNES REPAIRED IN PASSING — A TALENT RE-TUNE CAN SILENTLY RE-TUNE A RUNE.
The Rune of Grudges and the Rune of the Standard each added a RANK to
grudge_ranks / shared_vigil_ranks, whose per-rank value this batch multiplies
by four: untouched, a rune advertising "+6%" would have started paying 25%.
That IS the rune-magnitude pass the designer closed in AF, arriving by
accident. Both now carry their own term (`rune_grudge_bonus` 0.06,
`rune_vigil_bonus` 0.03) ADDED to the node's, so each pays its advertised
number alone AND stacked. Same shape as AK's Still Wrist repair. CONSEQUENCE
WORTH KNOWING: Shared Vigil can no longer use `_living_hero_with` — that
helper reads its field as an INT and a rune-only Warden (0.03) would be
invisible to it, so the scan is inlined and looks for EITHER half.
runes.json is NOT byte-unchanged; this is a dead-magnitude repair, NOT the
magnitude pass.
VERIFIED: NEW test_batch_al.gd 556 checks / 0 failures, stable 3/3 (tree
shape, all 24 ids/rows/lanes/names, every magnitude in BOTH the payload and
the tooltip it renders, all three conditional halves firing/dark/inert-on-
empty-ctx, the upgrade path in BOTH acquisition orders, both repaired runes
alone and stacked, and a live battle for the ally cover, the refuel, the
taunt spread, the block payoffs and the upgraded capstone). Its live half
spawns battles WITHOUT autoplay and forces determinism with block_chance/
plating_bonus/parry_chance + `no_cover` (the Sharpshooter's miss BYPASS)
rather than retrying — the AK discipline. GOTCHA THE FIRST RUN HIT: passing
`is_counter = true` to `_resolve` SKIPS THE WHOLE BLOCK BRANCH, so a driven
"prove the block fires" check silently proves nothing.
ONE ASSERTION IS A FLOOR, DELIBERATELY: Rally's 3-turn status reads 2 on the
Survivalist, because the Hunter class passive makes him ACT FIRST and his
opening turn has already ticked one off. That is the timeline, not the
talent.
Regression: test_batch_ai 2042/0, test_batch_ah 4284/0 (its master.html stamp
gate bumped to Batch AL), test_batch_ah_battle 63/0, test_batch_aj 389/0,
test_batch_ak 524/0, test_runes 3128/0 (was 3130 — the two repaired runes
now write FLOATS, so two STAT_INT_KEYS-family checks no longer apply),
test_start_rune 239/0, test_start_rune_ui 31/0, run-harness gates 1/2/3 PASS.
10 scenes, 0 SCRIPT ERROR.
KNOWN-BAD, NOT OURS: test_rune_battle 91/1 (the Inferno chip check), the
standing defect Batch AK recorded.
NO DIFFICULTY MEASUREMENT WAS RUN, deliberately — same reasoning as AJ/AK: a
content re-author of ONE spec has no honest control row, because the sim's
damage-share instrument reads a fixed four-hero party. ./sim.sh is a kit
smoke test only and carries no difficulty signal (Batch R).
KIT SMOKE, fixed lineup, 40 battles/row, warden,cryomancer,inquisitor,
beastmaster, DOD_SIM_TALENTS force-learning full 8-node builds (standalone
sims spend no points, so an unloaded run never touches these nodes at all).
All rows 40/40 wins, 0 SCRIPT ERROR. MEASURED AND FLAGGED, NOT NERFED — THE
THREAT LANE IS THE STANDOUT BY A DISTANCE: BD/battle 104 -> 320 and the
PARTY's Breaks/battle 1.02 -> 2.35, his damage share 17% -> 30% (Sundering at
a full 100% splash + the newly-reachable Spite/Bruising Guard pair). BANNER
shows up in statuses/battle 1.3 -> 5.7 rather than damage; PLATE barely moves
(17% -> 17%, prevented 47 -> 50) because the smoke lineup never threatens a
party already sitting at 85% health — that is the instrument's ceiling, not
the lane's. Kit-mechanics ratios ONLY.
REPORTED NOT ACTED ON: (a) Unkillable's self-mend is not booked by
`_stat_heal`, so the Warden's heal/battle column reads 0 on a Plate build —
a pre-existing instrumentation gap, not a talent bug. (b) desc_for's
two-decimal rendering — CLOSED IN BATCH AP.
BATCH AJ (08-06) — BERSERKER, ALL 24 NODES. The second of the four class
batches AI promised. One spec only; the other ten trees and enemy tuning
are UNTOUCHED.
ROWS ARE THEMED, not just exclusive: 1 the opening / 2 the wound / 3 what
the wound pays / 4 the edge / 5 what compounds / 6 refusal / 7 the finish
/ 8 capstone. AI cut the old tiers into rows BY POSITION, which left rows
with no question in them — the clearest being Deafening Cry (Battle
Shout's cooldown) landing in Battle Shout's own row.
MAGNITUDES, one decision applied 24 times (a node is a ROW, priced against
the two doors it closes): Savagery +5->+15 Bleed, Unstoppable 2.5->3.5%
step, Hemorrhage threshold 80->60, Reckless 5/5 -> 20% dealt / 15% taken,
Flurry +1->+2 strikes, Crushing Blows 3->9%, Bloodied Momentum 15->40
Rage, Arterial 25%->full transfer, Deathwish 6->25%, Relentless -5->-15
Rage, Scent 3->10%, Scar Tissue floor 60->85%, Second Wind 40->60 Rage,
Bloodcraze 3->12%, Measured Rage 8->20%, Unrelenting +10->+40 Con, Blood
Tithe 15->45 Rage, Enraged 3->12%/stack. EVERY ID SURVIVES, so saved picks
migrate and NO SAVE VERSION MOVES (still v6).
TWO RE-SPECS IN PLACE: `bz_vitality` (was Vitality, +5% max HP) -> FIRST
BLOOD, opens every battle with 40 Rage; `bz_warcry` (was Deafening Cry)
-> OVERKILL, a kill clears Hack and Slash + Wildstrikes cooldowns.
GOTCHA — THE BATCH DOC'S IDS ARE NOT THE LIVE IDS. It names bz_deafening/
bz_scar/bz_flurry/bz_momentum/bz_second_wind; the live ids are bz_warcry/
bz_frenzied_edge/bz_bloodlust_node/bz_thick_skin/bz_bloodied_hide. The
doc's own rule ("every node keeps its existing id so saved trees migrate")
is what settles it — the doc wrote the tidy version of names the nodes
already carry. Same class of thing as bz_bloodlust_node holding "Flurry".
THREE CROSS-ROW CONDITIONS (payload `condition` + has_node, Batch AI §5).
TWO OF THEM NEEDED NO NEW FIELD — both counters were already read as an
INDEX, so the conditional half adds a SECOND point and the read site knows
2 means "and the partner": crushing_blows_ranks 1=step 20 / 2=step 15 (+
Savagery); scar_tissue_ranks 1=85% floor / 2=100% and never falls (+
Unstoppable). The third could not be written that way — Measured Rage and
Reckless Fury BOTH write dmg_taken_bonus and the pair must land on exactly
ZERO, not on their sum, so `measured_cancels_reckless` zeroes the term
outright. CANCEL, DO NOT SUBTRACT: arithmetic there would silently depend
on both magnitudes never moving again.
TWO UPGRADE PATHS (the AK pattern; both sit in SPEC_POOLS["berserker"]):
Battle Shout -> +18%/4 turns (from the node's own +12%/3; a pool copy
never noded stays the pool's +8%/2) via `battle_shout_node` read as an
INDEX 0/1/2 at the special. Rampage -> the kill-recast chains TWICE a turn
via `rampage_upgraded`. RAMPAGE'S RECAST IS CAPPED FOR THE FIRST TIME (1/
turn base, `rampage_chains` reset in _player_turn) — it used to chain
unbounded, and an upgrade path has nothing to buy against no ceiling.
NEW FIELDS, five not the doc's three (the doc's count did not allow for
the two upgrade paths it also asks for, exactly as AK needed lunge_
upgraded/execute_upgraded): opening_rage (hero spawn, beside Bottled
Storm — a FLOOR not an addition), overkill_reset (_on_enemy_death),
measured_cancels_reckless (the damage-taken site), battle_shout_node
(the special), rampage_upgraded (the recast). NOT `overkill` — THE
SHARPSHOOTER HAS OWNED THAT FIELD SINCE BATCH 32 (kill overflow carries to
another enemy) and both are talents literally named Overkill. Name
collision REPORTED, NOT RESOLVED: different trees, different ids, nothing
breaks, but two nodes share a name in tooltips now.
LIVE BUG FOUND AND FIXED — MEASURED RAGE HAS BEEN INERT SINCE BATCH AI.
The damage-taken read site was guarded `> 0.0` and the node's whole
payload is a NEGATIVE, so it ate it silently: nothing crashed, nothing
logged, the tooltip kept promising 8%. Same failure shape as a typo'd stat
field, through a different door. The guard reads any non-zero value now
and credits mitigation via _prev like its neighbours.
ALSO: Relentless buys Hack and Slash's bleed RELIABILITY permanently by
`set`ting the ability's own bleed_chance to 1.0 — no new field, no second
read site (the AG rule bought once instead of earned per cast). Second
Wind clears every cooldown as well as its 60 Rage.
VERIFIED: NEW test_batch_aj.gd 389 checks / 0 failures, stable 3/3 (tree
shape, all 24 ids/rows/lanes/names, every magnitude in BOTH the payload
and the tooltip it renders — most of this tree's numbers live in a
battle.gd read site, so the tooltip is the only place the design number
appears in the data — all three conditional halves firing/dark/inert-on-
empty-ctx, both upgrade paths in BOTH acquisition orders, and a live
battle for the opening Rage, the Overkill reset, Second Wind's cleared
cooldowns, the Measured/Reckless cancellation and the Scar Tissue floor).
test_batch_ah_battle's ORDERING PROBE WAS RE-POINTED IN PLACE with the
reason in the file: it rode Deafening Cry, which no longer exists, so it
now rides Battle Shout's own upgrade path — the same question ("did the
tree run against a kit that already held the earned copy") asked of the
mechanism that is load-bearing today. It is 63 checks now.
Regression: test_batch_ai 2042/0, test_batch_ah 4284/0, test_batch_ak
524/0, test_runes 3130/0, test_start_rune 239/0, test_start_rune_ui 31/0,
run-harness gates 1/2/3 PASS. 10 scenes, 0 SCRIPT ERROR.
KNOWN-BAD, NOT OURS: test_rune_battle 91/1 (the Inferno chip check), the
standing defect Batch AK recorded.
NO DIFFICULTY MEASUREMENT WAS RUN, deliberately — same reasoning as AK: a
content re-author of ONE spec has no honest control row, because the sim's
damage-share instrument reads a fixed four-hero party. ./sim.sh is a kit
smoke test only and carries no difficulty signal (Batch R).
KIT SMOKE, fixed lineup, DOD_SIM_TALENTS force-learning a full 8-node
build (standalone sims spend no points, so an unloaded run never touches
these nodes at all — load them or the smoke test proves nothing): 40/40
wins both builds, 0 SCRIPT ERROR. His damage share 23% ungeared -> 32%
on the AGGRESSIVE build (Savagery+Crushing Blows cross-row, Reckless+
Measured cross-row, Relentless, Scar Tissue, Overkill, Rampage) and 24%
on the GRANT/BLEEDOUT build (First Blood, Flurry, Battle Shout, Arterial,
Second Wind, Unrelenting, Blood Tithe, Exsanguination). Kit-mechanics
ratios ONLY — no difficulty signal.
REPORTED NOT ACTED ON: desc_for's two-decimal rendering, which made every
tree's tooltips read "+15.0% damage" rather than "+15%" — CLOSED IN BATCH AP.
BATCH AK (08-06) — SWORDMASTER KIT CORRECTION + ALL 24 NODES. The first of
the four class batches AI promised. One spec only; the other ten trees and
enemy tuning are UNTOUCHED.
KIT: opening three = Overpower, Pommel Strike, GUARD CHANGE. Spec pool =
Sweeping Strikes, SHATTERPOINT, Lunge, Execute. This is AH's own flag being
answered — Guard Change is the ONLY stance swap in the game and four nodes
read the stance, so trimming it made a quarter of the tree inert.
Shatterpoint only accelerates a Break he reaches otherwise, so it is the
safe piece to move the other way. Guard Change's def moved OUT of
`trimmed_kit_ability` into the live kit and Shatterpoint's moved IN —
EXACTLY ONE DEF EACH, which is the whole point of the resolver stack.
Guard Change is now in NO pool (the class pool has excluded it since AH:
`stance` defaults aggressive on every unit). AH's 3-per-kit / 5-trims
counts are unchanged; test_batch_ah's trim dict was re-pointed IN PLACE
with the reason in the file.
MAGNITUDES: a node is a ROW now, not one of three ranks — priced against
the two doors it closes, which came out 3-4x the old rank-1 values across
the board. Stances 3%->12%, Sword Mastery 3%->12% parry, Killing Edge
4%->15%, Bracing +8->+30 Con, Dominant 5%->15%/debuff, Precision
5%->20%, Seasoned Fighter node 3%->15%, No Quarter 15->45 Rage, Overwhelm
3%->8%/debuff, Punishment 15%->60%, Tempo 10%->30%, Off Balance 5%->20%,
Pressure Point +8->+30 BD, High Guard 25%/1turn -> 40%/2turns (status
turns 2->3; the +1 is the hero-turn tick offset). EVERY ID SURVIVES, so
saved picks migrate and NO SAVE VERSION MOVES (still v6).
THREE NODES CHANGED WHAT THEY DO: (1) SUNDER GUARD re-pointed from
Shatterpoint (which §1 makes earnable) to GUARD CHANGE — 40 BD to EVERY
living enemy instead of 15 to the single nearest-to-Breaking mark; the old
target survives as a BONUS (+40 BD on Shatterpoint if he owns it). (2)
SWORDSMANSHIP: flat parry -> a perfect Guard Change grants +25% parry for
2 turns. (3) OFF BALANCE + PUNISHMENT stopped being an exclusive pair (they
are rows 7 and 6 now, both reachable) — with Punishment taken, Off Balance
WIDENS the window (Exposed/Crippled count) instead of stacking a second
"+% vs Broken". Also: RIPOSTE answers with a free OVERPOWER not a Strike,
and OPPORTUNIST answers a PARRY as well as a whiff — same answer from two
lanes, so A PARRY FIRES ONE COUNTER, not two (log names the payer;
Untouchable's Pommel still wins in Defensive).
NEW PAYLOAD KEYS in apply_payload, both opt-in and both arrays of full
payloads: `also` = extra payloads applied alongside, each with its OWN
`condition` (one node, two halves — Sunder Guard's owns_ability hook, Off
Balance's has_node widening); `upgrade` = payloads applied INSTEAD of
granting when the new_ability is already in cfg["abilities"].
CORRECTION TO THE BATCH DOC: it asked for `owns_ability` on the Lunge,
Shatterpoint AND Execute checks. IT IS THE WRONG INSTRUMENT FOR TWO OF
THEM — a learned node's own grant is itself in `Talents.ability_names()`,
so after taking sm_lunge, owns_ability(member,"Lunge") is true regardless
of where Lunge came from. The only honest question is "was it in the kit
when the tree ran", and cfg["abilities"] is what knows that (earned picks
go on BEFORE the tree at both call sites — the AH ordering fix). Only
Shatterpoint's hook uses owns_ability, because no node grants it.
Seasoned Fighter's Lunge half is a CAST-SITE name check, not a stat, so a
Lunge earned AFTER the node still benefits.
UPGRADE PATHS: Lunge and Execute sit in the spec pool AND the tree. Node
on an unowned ability = grant; on an owned one = upgrade. Lunge -> 15 Rage
+ BOTH Exposed and Crippled whatever the stance (`lunge_upgraded`).
Execute -> threshold 20%->35% and FREE vs a Broken target
(`execute_upgraded`). `_eff_cost` took an OPTIONAL target arg for that;
with no target it reads "a Broken enemy is alive", which is what lights
the button, and _player_turn NARROWS the pick to Broken targets when he
cannot pay full price so the two checks can never disagree.
NEW FIELDS: guard_change_bd, sunder_guard_bd, swordsmanship_parry (REPLACES
pommel_parry_bonus), off_balance_wide, lunge_upgraded, execute_upgraded.
RUNE REPAIRED IN PASSING — THE RUNE OF THE STILL WRIST. It wrote
`pommel_parry_bonus` and advertised "a perfect Pommel Strike's parry
blessing", which stopped existing in BATCH AH when Pommel's perfect became
the boss Stun; it has been half-dead for two batches and the rename would
have killed it. Re-pointed to `swordsmanship_parry` + desc names Guard
Change. THAT IS WHY THE FIELD IS ADDITIVE ON TOP OF THE ABILITY'S OWN 10%
(node 0.15, rune 0.05, so the sm_swordsmanship scale reads {base 10, step
15} = 25 rendered): a max() would leave the rune silently inert alone.
Alone 15% / node 25% / both 30%. runes.json is NO LONGER byte-unchanged —
this is a dead-field repair, NOT the magnitude pass the designer closed in
AF.
VERIFIED: NEW test_batch_ak.gd 524 checks / 0 failures, stable 3/3 (kit
swap + single-def property, every pool entry of all 12 specs and 4 classes
still resolving, all 24 nodes' id/row/lane/magnitude AND tooltip — two
hand-written places — both conditional halves firing/dark/inert-on-empty-
ctx, both upgrade paths in BOTH acquisition orders, and a live battle for
the BD spread, the parry spike, the parry counter, Execute's pricing and
the upgraded Lunge). Its live half spawns battles WITHOUT autoplay so
nothing acts on its own, and forces determinism with parry_chance=1.0 +
`no_cover` (the Sharpshooter's existing miss BYPASS) rather than retrying.
Regression: test_batch_ai 2042/0, test_batch_ah 4284/0, test_batch_ah_battle
62/0, test_runes 3130/0, test_start_rune 239/0, test_start_rune_ui 31/0,
run-harness gates 1/2/3 PASS. 10 scenes, 0 SCRIPT ERROR.
KNOWN-BAD, NOT OURS: test_rune_battle 91/1 (the Inferno chip check).
It reproduces 3 OF 3 ON UNMODIFIED HEAD in a clean worktree — CLAUDE.md's
"intermittent" note is out of date, it is a standing defect in that check.
MEASURED AND FLAGGED, NOT NERFED — SUNDER GUARD IS THE BIGGEST NODE IN THE
TREE BY A DISTANCE. Fixed smoke lineup, 60 battles, that node alone forced:
his BD/battle 158 -> 649 and the PARTY's Breaks/battle 1.33 -> 5.43 (4.1x
both). His own damage share FALLS 29% -> 23% — he spends the turns pivoting
instead of swinging, and what he is actually doing is opening windows for
the other three. That is the node as the batch specified it (40 BD to every
enemy on a 0-Rage 1cd button), so it ships as written. Smoke lineup = NO
difficulty signal (Batch R); these are kit-mechanics ratios only.
NO DIFFICULTY MEASUREMENT WAS RUN, deliberately: this is a content
re-author of ONE spec, and the sim's damage-share instrument reads a fixed
four-hero party, so a single-spec re-tune has no honest control row. The
sim smoke test (./sim.sh) is a kit smoke test only and carries no
difficulty signal (Batch R).
GOTCHA: `timeout` IS NOT ON THIS SHELL (no coreutils). A headless loop
written as `timeout 60 godot ...` returns EMPTY and a `grep -c "SCRIPT
ERROR"` over it reads 0 — a FALSE PASS that looks exactly like a clean
parse. Use Godot's own `--quit-after N` instead.
FIX (08-06) — THE RUNE TRIPLE COULD HOLD A DUPLICATE (~1 in 100). The
pick-of-3 roller drew each candidate independently, retried 4x on a
collision, then APPENDED UNCHECKED — and the check sat at the TOP of the
retry loop, so 4 checks covered 5 draws and the 5th went in blind. Fixed
by DRAWING WITHOUT REPLACEMENT: `generate_rune(member, exclude_names)` ->
`Runes.generate(member, slot, exclude_names)` folds the names already in
the triple into the SAME list the owned pouch uses, so the pool cannot
contain a sibling. `Runes.template_rune` takes exclude_names too (stats
mode); with it EMPTY the RNG order is byte-identical, so no other caller
moved. 0 dupes in 4000 triples, both paths. NOTE: the DEFAULT path had the
same bug, so its roll sequence DID move (fewer draws, smaller pool) — the
Batch AF test that pinned it against a verbatim copy of the OLD loop was
re-transcribed to the corrected one, and a distinctness assertion added
(the default path never had one, which is why only the guaranteed path
caught this, intermittently). test_start_rune is now 239 checks.

BATCH AI (08-06) — TALENT TREE STRUCTURE. Every tree is 3 lanes x 7
MUTUALLY EXCLUSIVE ROWS + a capstone row (row 8) = 24 nodes. A row holds
one node per lane, the player picks ONE, the other two grey out for good
(and an untaken node's tooltip names the two it would close). Row 1 open;
row N needs row N-1. Row 8 opens at 7/7, take one, NO LANE PURITY. EVERY
node = 1 point, `ranks: 1`, no exceptions; a complete tree is 8 nodes.
POINT SUPPLY MATCHES IT EXACTLY: spec choice 1 (Run.award_spec_point, from
BOTH the spec screen and RunSim.start_run — the sync_spec_hp pattern),
mini-boss 1, zone boss 2, fight 0, final boss 0 = 8 guaranteed.
ELITES pay 1 into a SEPARATE purse `talent_flex` (Run.award_talent_flex):
it can NEVER open a row, only buy a SECOND node in a row already picked;
the third stays shut. `can_learn` returns {ok, why, pool} — pool names
which purse pays ("points"/"flex"), and every call site charges from it.
RETIRED AND DELETED (not left unreachable): LANE_TIER_REQ, NODE_TIER_REQ,
CAPSTONE_REQ, NODE_CAPSTONE_REQ, ROW_REQ, FIXED_TREES, LANE_CONVERSIONS,
next_node_cost, node_cost, lane_nodes_bought, lane_points,
points_below_row, is_node_gated, is_lane_tree, node_gated, the per-node
`tier`, member["talent_order"], and party_screen's classic-tree renderer.
HOOKS FOR THE CLASS BATCHES (built, no node uses them yet):
`Talents.has_node(learned, id)`, `Talents.owns_ability(member, name)`
(reads Talents.ability_names = the action bar's own list), and
`payload.condition` = {"has_node": id} / {"owns_ability": name} / both,
gated at ONE site in apply_payload — NO ctx means INERT, deliberately.
apply_from_tree/apply_payload take the member + a ctx dict now; the
test_runes `_ordering` grep string moved with it.
SAVE v6: a pre-AI save is WIPED and its purse re-issued on the new
schedule (Run._migrate_trees / _batch_ai_point_schedule) — the old ranked,
point-priced purchases have no honest translation.
test_batch_ai.gd (2042 checks) pins all of it. test_runes' exclusive-pair
alarm is RETIRED with its reasoning in the file: at row granularity every
spec rune would trip it. ALL FOUR CLASS BATCHES HAVE NOW LANDED (AK Swordmaster, AJ
Berserker, AL Warden, AR Pyromancer) — the remaining EIGHT trees still carry
AI's structure at AI's magnitudes. EXPECTED: structurally correct, NUMERICALLY WEAK
— rows lopsided, single-rank = old rank-1 values (~1/3 power). DO NOT
TUNE; the four class batches re-author all 252 nodes. MEASURED (30 runs
each side, same flags): depth 17.10+/-1.55 -> 13.40+/-0.86 (bands don't
overlap), wipe median z2 t7.5 -> z1 t11.0, nodes entering a boss 5.0 ->
2.6, points/hero/run 17.4 -> 3.6. ratio@z1t8 FLAT (0.97 -> 0.98) and
completions 0% BOTH SIDES — the stat line barely moved, the lost power was
all CONDITIONAL/PROC. So completions cannot tell the two apart; DEPTH and
WIPE MEDIAN are the pair to watch when the class batches land.

BATCH AH (08-05) — ABILITY PROGRESSION. Every hero opens with its core
attack plus EXACTLY 3 spec abilities and EARNS 6 more (2/zone: mini-boss +
zone boss). NO NEW ABILITIES WERE WRITTEN — every pool entry is a trimmed
kit piece, a talent grant, a sibling spec's ability, or a vault whose
`special` never left battle.gd. TRIMMED: Blood Price (bz), War Stomp +
Interpose (wd), Sweeping Strikes + Guard Change (sm). Beastmaster was
ALREADY at 3 under the batch's own rule (the Summon picker = one slot,
which the action bar has always done) — so were Pyro/Cryo/Arcanist/Holy/
Devout/Occultist/Sharpshooter/Survivalist.
POOLS: `Classes.SPEC_POOLS` now all 12; `Classes.CLASS_POOLS` is NEW (4).
`class_pool()`, `class_of_spec()`, `pool_ability()` (THE resolver — reads
kit pieces back out of the LIVE kits and talent grants out of the LIVE
trees, so a pool copy can never drift), `vault_ability()`,
`trimmed_kit_ability()`. `Talents.granted_ability(name)` is the talent
side of that, and classes.gd -> Talents is a live cycle that GDScript
resolves fine (proven, not assumed).
CURATION RULE (class pools only): an entry must FUNCTION for a sibling.
OUT: faith_cost (Hymn/Resurrection/Divine Plea), Burn consumers
(Detonation, Wildfire), Chilled-gated (Shatter), Resonance
(Arcane Cannon/Magi's Wrath/Stabilize/Overcharge), companion/Loyalty
(Bestial Wrath/Spirit Bond/Primal Surge), Focus-spender (Coup de Grâce),
STANCE (Lunge, Guard Change — `stance` defaults "aggressive" on EVERY
unit, so a sibling's Lunge could only ever Expose), and the named identity
pieces (3 summons, Kill Command, Hex of Ruin). The line: an ability is
class-pool-eligible when its PRIMARY effect resolves without the spec
mechanic; dead riders/perfects are noted, not disqualifying.
VAULT UNSEALED: Rallying Shout, Retaliation, Mana Shield, Arcane Surge,
Reality Fracture, Phoenix Rebirth, Dawnbreak, Sanctuary, Divine Wrath,
Umbral Sigil. NOT revivable — Pyroblast, Flame Surge, Frost Bolt, Death
Ray, Mend Wounds: their specials went with them, so they are prose in a
comment and reviving = AUTHORING.
OFFER: `Run.roll_ability_offer(member)` = 1 spec + 2 class, unowned,
cross-filling either way. THE SPEC DRAW LEADS (deliberately NOT shuffled
like the rune triple — the pools OVERLAP, so nothing in the name says
which pool an entry came from; the party screen tints entry 0 gold).
`Run.award_ability_pick` stores the triple on `bm_candidates` (queue) +
`bm_picks_owed`; storage stays `bm_abilities`; SAVE STAYS v5.
`Run.owned_ability_names` counts talent-LEARNED grants too.
SPAWN-ORDERING FIX: earned abilities now go on BEFORE
`Talents.apply_from_tree` in BOTH battle.gd and the party sheet — several
talents MODIFY an ability, and Deafening Cry would have missed a
pool-bought Battle Shout. apply_from_tree already refuses to double-grant.
MINI-BOSS: `Run.MINIBOSS_TIER` = (FLOORS-1)/2 = 5 (displayed tier 6), ALL
3 columns, unroutable. Elite themes + elite budget floor, every enemy at
`battle.MINIBOSS_HP_MULT` = 1.5 max HP, attack UNTOUCHED. Elite gold, 2
talent points, one ability pick; NO item drop and NO rune cache (the AE/AF
rune economy is left alone deliberately). Deck: 27 cards over 9 tiers,
paid for out of FIGHT cards only (17->14) — rest/shop/event byte-identical
so the run-economy dials never moved. `_lay_rows` is shared by both
generators; `_deck_window` states the constraint windows in TIER terms;
`DECK_FALLBACK_MB` is the 27-card floor. FLAG `DOD_SIM_MINIBOSS=off`
reproduces the PRE-AH MAP only (kits still open at 3 — the trim has no
switch). Post-AH Matrix rows carry `mb=`.
ACTION BAR: no cap, no swap step. `ABILITY_KEYS`/`ABILITY_KEY_NAMES` gained
G as the 9th (the batch's "ability 10 = Shift+Q" only lands with nine plain
keys); slot 10-18 = SHIFT + the same key, label "[⇧Q] Blood Price"
(`_hotkey_name`). A real run tops out at 10 abilities = exactly one Shift
slot. Both `_try_ability_hotkey` call sites pass `event.shift_pressed`.
EIGHT PERFECTS -> RELIABILITY CHECKS: Hack and Slash (bleed on all 3, no
4th strike), Blizzard (2 stacks always, no Mana refund), Pommel Strike
(Stun on an unbroken boss, no parry buff), Snare Trap (same; Poison flat
4), Firestorm (even spread, no extra bolts), Arcane Barrage (no repeat
while an unstruck enemy stands, no 7th bolt), Triple Shot (one guaranteed
crit), Deadfall (GAINED a skill check; perfect names the victim, and an
aimed trap RELEASES if its mark dies so a perfect is never worth less).
Firestorm + Barrage are ONE mechanic (round-robin `_spread_struck`, per
cast). Boss immunity has exactly ONE escape: an explicit `force` arg on
`_apply_status` (+ `force_stun` on `_spring_trap`) — a call-site-visible
exception, not a name check inside. LIVE BUG FOUND: Triple Shot fired TWO
arrows (`multi_hits` 2 against its own name/description) with a SILENT
perfect third; now multi_hits 3, perfect_extra_hit off.
VERIFIED: test_batch_ah.gd 4,263/0 (incl. a forward DP proving no route
reaches the boss without crossing the mini-boss row), test_batch_ah_battle
44/0 (live: ordering fix, ⇧Q in a real bar, both force paths, Freeze
immunity untouched, mini-boss HP vs its own elite self, the Party SHEET
showing earned abilities). Regression: test_runes 3,248/0, test_start_rune
233/0, test_start_rune_ui 31/0, run-harness gates 1/2/3 PASS,
test_rune_battle 91/1 (a Batch AG Inferno-chip check that reads the chip
before any Burn exists — the SAME single failure unmodified code gives 6/6).
ITS WHITE FLAME CHECK WAS FIXED: it read a LOG LINE, so it raced how long a
fight lasts, and the kit trim shortened fights enough that the Pyromancer
sometimes never took a turn (0 fire casts in ~50% of runs; restoring Blood
Price made it 6/6, which pinned the cause). The pass now FORCES one fire hit
onto a resistant enemy. 10 scenes, 0 SCRIPT ERROR.
MEASURED (n=100/arm, control mb=off): acquisition landed — abilities/hero/run
1.18 -> 3.02 (the ceiling of 6 is not the target; a run only reaches 2.0
mini-bosses + 1.3 bosses). Difficulty did NOT move on depth: 20.15 -> 20.49
vs an MDE of 3.57, ratio@z1t8 1.00 -> 0.95, wipe median z2 t8 -> z2 t10
(DEEPER). Completions 9% -> 0% nominally clears 8.2pts (z=3.07) but is
RECORDED NOT BELIEVED: AE's own noise calibration read 7% and 14% off two
identical halves of one arm, and a discarded same-code pass read 12% and 4%.
Depth is the low-variance metric. THE ONE REAL COST IS ROUTE AGENCY: choice
77% -> 71%, rests taken 2.3 -> 1.9 — a row with one node type in all three
columns has no decision in it, which is exactly what unroutable buys.
NOT DONE, and it is a contradiction in the batch: §2 asks for six UNSHIPPED
abilities (Disengage/Suppressing Fire/Piercing Arrow, Blight/Smoke Bomb/
Field Dressing) while the header says "No new abilities are written in this
batch" and gives no specs for any of them. Header won; both Hunter pools
ship at 5. Cross-fill keeps every offer at 3 regardless.
FLAGGED FOR THE DESIGNER: GUARD CHANGE. The batch named the Swordmaster's
three keepers, which makes Guard Change earnable — and it is his ONLY
stance swap, so until he earns it back he fights every battle Aggressive,
half of Seasoned Fighter is inert, and four talent nodes sell him nothing.
Shipped as written rather than silently reinterpreted; one-line fix.
BATCH AG (08-05) — COMBAT TUNING, seven changes. (1) WILDSTRIKES gets
`bleed_chance` 0.5 (it had NONE, so it defaulted to 1.0 and landed 35 on
all four every cast); its perfect now GUARANTEES the roll on every target
instead of granting +50% buildup — the `is_perfect * 1.5` clause is gone,
the perfect sets the roll to 1.0 for the cast. A perfect on a wide swingy
ability buys RELIABILITY, not magnitude. (2) INFERNO MASTER counts total
BURN TURNS on the enemy team, not burning heads: step = 1.0 + 0.2*
pyromaniac_ranks %/turn, cap = 25*step + 10*heat_haze_ranks %. Ceilings
+25 / +40 (Pyro 3) / +70 (Pyro 3 + Haze 3, was 64). Pyromaniac now raises
the cap WITH the step. Helpers `_total_burn_turns()` and `_inferno_mult(u,
turns)` are shared by the damage calc, the spec chip and Wildfire.
CONSUMPTION ORDERING was a live bug — Detonation stripped the burn BEFORE
the passive block ran, so the consuming cast was paid on the ashes;
`inferno_turns` is now captured at the top of each strike, before
Detonation's `remove_status`. (3) WILDFIRE reworked into the wide payoff:
a `special` ("wildfire", no target pick, gated OUT with nothing alight
like Shatter), 20 Mana / 3cd / 2.5 delay / 10 BD, consumes ONE turn of
Burn from EVERY burning enemy for 18% of Attack each (perfect: 2 turns,
damage twice to anyone holding 2+). Old spread code path REMOVED. Its
inferno read is taken pre-consumption. Autoplay mage loop retargeted:
Flamewave builds (unburnt>=2), Wildfire at 3+ burning, Detonation still
takes the ripest. (4) BATTLE SHOUT is party-wide: power = 8 + total enemy
bleed/20, applied to EVERY living hero (companions excluded — their damage
runs through `_companion_hit`, which never reads the status). Delay 1.5.
Deafening Cry is `bz_warcry` (not bz_deafening) and still -1 cooldown.
(5) RAZOR ICE 20 dmg/20 cost -> 15 dmg/25 cost — the first cut at the
Cryomancer overtune S and U both measured. (6) SELF-BUFF DELAYS -0.5,
floor 1.5, on the 15 named PLUS five the sweep found: Quick Draw,
Overcharge, Hold Breath -> 1.5, Tripwire -> 2.0, Hold the Line -> 3.0.
JUDGED OUT and why: Deadfall/Snare Trap/Mass Hysteria are pointed AT the
enemy team (the rule's letter caught them; the section title "self-buff"
is what settled it), Dark Pact heals, the three Summons field a unit and
Aguila takes an enemy target so the trio would have split, Guard Change is
already at the floor. Heals excluded by the rule. (7) BUG — CALL OF THE
WILD LOCKED OUT LONE BOND. It writes kinds_summoned for all three kinds as
Feral Momentum/Menagerie bookkeeping; the Lone Bond gate read `not
kinds_summoned.is_empty()` as "you spent your beast", so one cast closed
every summon for the fight. FIX: `BattleUnit.beast_committed`, set ONLY in
`_do_summon`, and the gate reads that. kinds_summoned untouched. Two
questions sharing one variable is fine until an ability makes them
disagree — the fix is a second variable, not a cleverer read of the first.
BATCH AF (08-04) — THE OPENING PICK OFFERS A RUNE FOR YOUR SPEC. One
change, small on purpose. runes.json BYTE-UNCHANGED for the THIRD batch
running, and that is the intent — THE DESIGNER HAS CLOSED THE RUNE-
MAGNITUDE QUESTION. No multiplier pass, now or later; AE's six magnitude-
proof entries (Comet, Binding Souls, Last Rites, Flayed Mind, Quick
Spring, Deep Sight) are left exactly as they are, they only mattered as a
caveat on a pass that is no longer coming.
WHY: AE measured 0.49 spec runes worn/hero against the 1.18 projected and
its own diagnosis found the cause — the ordinary roller put a spec rune
among the three only 36-42% of the time and the policy took one at
EXACTLY that rate. THE CEILING WAS THE ROLLER, NOT THE POLICY.
STAGE 1 — GUARANTEE, NOT WEIGHTING. The opening triple ALWAYS holds one
spec-scoped candidate where the spec pool has an eligible entry; the other
two roll normally. A weighting nudges a probability and leaves the outcome
mushy; a guarantee makes the opening pick a reliable QUESTION (my spec's
rune, or the generic one that is stronger right now?). One candidate not
two — a triple of spec runes is a menu, not a question.
MACHINERY: `Runes.generate_spec(member, zone_slot)` = generate() with the
pool restricted to `spec:<id>` — SAME rarity roll, SAME widen-on-
exhaustion, so it is an ORDINARY roll in a smaller pool, NOT a forced
Epic. Returns {} when the subset is empty and NEVER substitutes a stat
stick (filler would satisfy the guarantee's letter and defeat its point).
`Run._generate_spec_rune` wraps it through the AD power choke point and
returns {} under DOD_SIM_RUNES=off/stats (no authored pool = the guarantee
is correctly a no-op, so those control rows still reproduce).
THE SHARED-ROLLER RULE: `roll_rune_candidates(member, guarantee_spec :=
false)` — OPT-IN, DEFAULTED OFF. The elite cache (run_sim + battle.gd,
both `roll_rune_candidates(looter)`) rolls byte-identically; EXACTLY ONE
caller arms it, `grant_start_runes`. The seeded rune goes in FIRST so the
other two dedupe against it for free, then the triple is SHUFFLED (a fixed
position would turn a real choice into a positional tell). Fallback is
SILENT: empty subset -> ordinary roll of three, no error, no empty slot.
FLAG: DOD_SIM_SPEC_OPENING=off reproduces AE's opening WITH THE STARTING
RUNE STILL ON — that is what makes AF's own control isolate THIS change
instead of re-measuring AE. Shipped content, so ON by default and NOT
gated on sim_run (like the AE flag, unlike AD's arms). Matrix rows carry
specopen=; pre-AF rows do not.
MEASURED (fixed party, n=200/row, control=specopen=off). THE ACQUISITION
HALF LANDED: offer rate 41% -> 100% with ZERO FALLBACKS across 800
triples; opening pick spec-scoped 41% -> 100%; SPEC RUNES WORN PER HERO
0.56 -> 1.15 (AE measured 0.49; the control reproduces it).
**THE FINDING WORTH KEEPING: THIS IS A COMPOSITION CHANGE, NOT AN
ACQUISITION-VOLUME ONE.** Acquired/hero 1.62 -> 1.67 and slots filled
1.58 -> 1.64 (59% -> 58%) — both flat. What moved is WHAT FILLS THEM:
spec 0.56 -> 1.15 while class 0.16 -> 0.10, universal 0.32 -> 0.16, stat
sticks 0.54 -> 0.23. The party does not wear MORE runes, it wears authored
spec content where it wore filler.
DIFFICULTY HALF, INFORMATION ONLY (no gate, no target, nothing
conditional): depth 15.89 -> 17.14 = +1.25 tiers vs a RESOLVABLE
DIFFERENCE OF 2.72 — DOES NOT CLEAR. Completions 7% -> 6% (resolvable 6.9
pts), ratio@z1t8 0.97 -> 0.98, wipe median IDENTICAL z1 t11.0. Reproduces
AD's and AE's central claim that acquisition alone moves nothing
detectable, and the composition finding explains WHY. NOTHING COMPENSATED.
REPORTED NOT ACTED ON: (a) **NO SPEC RUNE IN THE POOL IS COMMON** — all 44
are Rare + 4 Epics, so inside the spec subset the zone-1 Common lean has
nearly nothing to bind on and the guaranteed slot is always Rare-or-better
where it used to be ~60% Common. "The opening gift stays modest" comes
from the POOL'S COMPOSITION, not the rarity weighting; a smaller opening
gift means authoring Common spec entries, not re-weighting the roll.
(b) treasure/Loot: NOT OUTSTANDING — Batch AN deleted the node type with the
whole deck generator, and Batch AP confirmed nothing in the code names it.
VERIFIED: test_start_rune.gd 131 -> 233 checks, 0 failures (EXTENDED, and
it prints the AE/AF subtotals separately so "AE's 131 still pass" is a
number you can read off the output). The 102 AF checks: the guarantee held
across 250 rolls for EACH OF ALL TWELVE SPECS (not the four a fixed party
draws); the default path proven unchanged by SEEDING THE GLOBAL RNG and
replaying a verbatim pre-AF loop against it (plus call-site asserts, so a
future batch cannot quietly arm the elite cache); the fallback FORCED two
ways (a hero owning all four of his spec's runes, and a member with no
spec) and asserted to give three valid distinct candidates and no error;
the Epic share bounded 8-45% over 600 rolls so rarity cannot be bypassed;
never a stat stick, never pinned to one slot. test_start_rune_ui.gd 31/0
UNCHANGED, test_runes.gd 3,248/0, test_rune_battle.gd 91/0 (flaky White
Flame passed). test_run_harness gates 1/2/3 PASS before either --run row
was trusted. Purity: profile.json + relics.json byte-identical across a
real DOD_SIM_RUN; run_save.bin never created. Headless parse: all 10
scenes, 0 SCRIPT ERROR.
BATCH AE (08-04) — THE STARTING RUNE SHIPS; THE MAGNITUDE PASS DOES NOT,
and the refusal is the second deliverable. runes.json is BYTE-UNCHANGED for
the second batch running.
STAGE 1 — SHIPPED. One PICK OF THREE per hero, dealt at SPEC CONFIRMATION
(spec_choice._finish_and_fade, beside Profile.note_run_started) and NOT at
the draft: specs are chosen after the draft, so a rune rolled earlier can
never be one of the spec-scoped entries this whole arc is about. Rolled
through the EXISTING Run.roll_rune_candidates at zone slot 1 (leans Common),
queued as rune_candidates/rune_picks_owed, resolved on the Party screen by
the SAME trophy-picker the elite cache uses. NO new gear machinery. Once per
hero per run is a property of the SAVED DATA — a `start_rune_granted` marker
inside the party dict, so SAVE STAYS v5, no migration, and neither a resumed
run nor the debug spec swap can deal a second. Candidates carry
`source: "start"` so the picker panel names itself honestly ("AWAKENING
RUNE" vs "ELITE RUNE CACHE") when both are owed.
VISIBILITY (the point of a FRONT-LOADED lever): map Party button badges
"(N runes!)" in the rune purple (which OUTRANKS the talent gold) and PULSES;
the Party screen opens on the hero LIST, one click short of the picker, so
each owed row reads "◆ N RUNE(S) TO CHOOSE" in the same purple — a real gap
found by testing the scenes, not by reasoning; a one-shot first-map toast
CHAINS OFF the Batch Z framing card's dismissal so they never overlap.
FLAG: DOD_SIM_START_RUNE=off reproduces the pre-AE economy. Default ON and —
UNLIKE AD's two arms — NOT gated on sim_run, because it is shipped content.
Matrix rows now carry start=; pre-AE rows do not, never compare across.
Sim resolves it via the existing _pick_rune_candidate in RunSim.start_run.
STAGE 2 — THE CORRECTION, then the stop. AD's "detectable at x1.5" was
measured with `rich` acquisition HELD ON (~3x what one starting rune gives);
A DOSE-RESPONSE CURVE CANNOT BE READ ACROSS ACQUISITION LEVELS, so the whole
sweep was re-run at the level AE ships. FIXED PARTY n=200: x1 15.12 / x1.5
17.71 / x2 16.86 / x2.5 18.98 / x3 18.98 — x2.5 is the smallest clearing its
MDE (+3.86 vs 2.74); x1.5 MISSES BY 0.05 TIERS and is recorded as
UNDERPOWERED, not as noise. ROTATED, re-run at n=300 BECAUSE n=100's MDE
(+/-4.28) was LARGER THAN THE EFFECT IT WAS ASKED TO REPLICATE: x1 15.21 ->
x2.5 17.15 = +1.94 vs MDE 2.52 — DOES NOT CLEAR. The instrument could have
seen it and did not: a FAILURE TO REPLICATE, not an underpowered null. The
pre-registered rule said stop, so the batch STOPPED AND AUTHORED NOTHING.
REPORTED NOT ACTED ON: both arms are individually significant at .05
(t=3.94 / t=2.15), they are not distinguishable from each other (Q=2.08,
1 df), and an inverse-variance combination gives +2.82 (SE 0.663) which
WOULD clear — but that analysis was chosen AFTER seeing the rows, and the
"resolvable difference" is an 80%-POWER threshold deliberately stricter than
a significance test. The designer may overrule it; this batch may not.
NOISE CALIBRATION: two n=150 halves of the SAME rotated x2.5 arm read 16.39
and 17.91 (1.52 tiers apart, nothing changed); two identical n=150 rotated
CONTROL halves read completions 7% and 14%.
THREE FINDINGS FROM THE PASS THAT NEVER RAN — these outlive it:
(1) FIVE RUNE FIELDS ARE READ AS BOOLEANS and scaling them is a SILENT
NO-OP: coated_blades, deep_focus, perfect_form, opening_volley, vulture
(all `if x > 0` in front of hard-coded constants). THIS IS A CORRECTION TO
BATCH AD — its power arm scaled them, so its x3/x6/x10 rows never actually
multiplied those terms. Consequence: the Rune of the DEEP SIGHT carries
NOTHING BUT boolean fields and cannot move under ANY magnitude pass, so the
unscalable list is SIX entries (comet, binding_souls, last_rites,
flayed_mind, quick_spring, deep_sight), not five.
(2) ROUNDING COLLAPSES THE SWEEP FROM FIVE DOSES TO THREE. 82 of 107
scalable benefit terms are ints and 52 are a bare 1, which rounds to 2 at
BOTH x1.5 and x2 and to 3 at BOTH x2.5 and x3 — 62 of 82 int terms frozen,
23 of 65 entries byte-identical, per pair. Corollary worth more than the
caveat: the floats grow a third between x1.5 and x2 and depth does not move;
the ints step 2->3 between x2 and x2.5 and it does. THE POOL'S POWER LIVES
IN ITS TALENT-COUNTER GRANTS, NOT ITS STAT PERCENTAGES.
(3) A PROPORTIONAL COST ON healing_received_mult CROSSES A CLAMP. It is a
running SUM onto 1.0 and unit.heal_amount floors it at 0; universal Vampiric
plus the Occultist's Hollow Chalice sums to -1.50 at x2.5, so the clamp
would silently turn two runes into "you cannot be healed at all" — a RULE
change wearing a magnitude change's clothes, with nothing crashing. Batch
AA's guard comment claimed "no reachable loadout gets there today"; nothing
had been checking it. NOW test_runes DOES.
Also non-linear and un-scalable proportionally: on_edge_ranks (a threshold
with a base, 0.20 + 0.05*ranks) and mindfulness_ranks (an interval,
counter >= 7 - ranks).
STAGE 4 — DIFFICULTY MOVEMENT. Control = start=off measured BEFORE stage 3
was considered, so it means the game as it stood. THE ACQUISITION HALF
LANDED AND IS NEAR-DETERMINISTIC: acquired/hero 0.56 -> 1.47, slots filled
0.56 -> 1.46 (20% -> 55%), and AUTHORED SPEC RUNES WORN PER HERO 0.16 ->
0.49 (TRIPLED). THE DIFFICULTY HALF DID NOT MOVE: fixed n=200 depth 16.07 ->
15.12 (-0.95, MDE 2.54), completions 3% -> 4%; rotated n=300 depth 14.89 ->
15.21 (+0.32, MDE 2.39), completions 10% -> 16% vs a +/-7.7 band. OPPOSITE
SIGNS, both far inside noise; ratio curve unchanged in shape (z1t8
0.97->0.95, z1 boss 0.74->0.75). THIS INDEPENDENTLY REPRODUCES AD's CENTRAL
CLAIM at a different magnitude — AD's rich-only arm measured -0.85 tiers,
AE's shippable acquisition measured -0.95. ACQUISITION ALONE STILL MOVES
NOTHING. THE ONE-SENTENCE ANSWER: the game did not get measurably easier —
the starting rune tripled how much authored rune content a hero wears and
bought no detectable difficulty change. Nothing was nerfed to offset it
because there was nothing to offset.
TWELVE-SPEC TABLE (rotated, per-spec n~100, vs AD's ~33): FLAT. AD's flagged
Pyromancer 35->42 and Sharpshooter 25->19 DO NOT REPRODUCE (36->34 and
25->26); no spec moves more than 3 points.
VERIFIED: test_runes.gd 3,085 -> 3,248 checks, 0 failures (extended, not
replaced) with three NEW alarms — every boolean-read field asserted to STILL
be a boolean gate in battle.gd and to carry no rune value above 1; the
reachable healing_received_mult sum asserted to stay above the clamp; the
opening triple asserted to hold a spec rune within a wide 20-70% band (it
measured 42%, matching the sim's 36-42%). NEW test_start_rune.gd 131 checks
and test_start_rune_ui.gd 31 checks (the real map/party scenes: badge,
colour, that it PULSES, list rows, picker offering the three SAVED
candidates, spending clearing both, control showing nothing, nudge waiting
behind the framing card). test_rune_battle.gd 91/0 (flaky White Flame check
passed). test_run_harness.gd gates 1/2/3 PASS, rerun before any --run row
was trusted. Purity: profile.json + relics.json byte-identical across a real
DOD_SIM_RUN with the start rune ON and both AD arms armed; run_save.bin
never created. Headless parse: all 10 scenes, 0 SCRIPT ERROR.
REPORT BACK (designer's call, not taken): (a) SPEC-WEIGHT THE OPENING PICK —
the ordinary roller puts a spec rune in the triple only 36-42% of the time
and the bot takes one whenever there is one, so the ROLLER is the ceiling;
this is why spec-worn landed at 0.49 and not the 1.18 projected, and a
spec-weighted opening roughly doubles it for one line. (b) six entries are
magnitude-proof, incl. the Deep Sight nobody had noticed. (c) difficulty
does NOT need its own batch on this evidence; Wanderer x0.7 untouched.
(d) treasure/Loot — see the AP block: already deleted by AN, listing was stale. (e) the
magnitude pass is PREPARED AND RECORDED, not applied; if a second
acquisition lever lands (rest-node rune offer, touched 2.3/run vs the shop's
0.6, or a second elite cache) THE SWEEP MUST BE RE-RUN AT THAT ACQUISITION
LEVEL — the same reason AE could not reuse AD's.
BATCH AD (08-04) — THE RUNE ECONOMY, MEASURED. NO CONTENT CHANGE, and
that is the finding, not a shortfall. Instrumentation + two sim-only
experiment arms; runes.json is BYTE-UNCHANGED.
**THE HEADLINE, and it overturns how every prior rune row was read: POWER
and DILUTION were never alternatives — they are two factors of one
product, both near zero, and EACH PERFECTLY MASKS THE OTHER.** Fixed
party n=100, primary metric depth reached (resolvable difference +/-3.9
tiers): control 16.97 / rich-only 16.12 / power-x3-only 16.49 / BOTH
27.13 (completions 8% / 6% / 12% / 61%). Replicated rotated (all twelve
specs) n=100: 14.78 / 14.71 / 14.94 / 22.83 (12% / 12% / 15% / 43%) —
rich alone delivered 2.27 spec runes per hero against the control's 0.17
and moved depth by -0.07 tiers and completions by ZERO points. **Any
experiment that varies one factor at a time is GUARANTEED to report "no
effect" whichever explanation is true — which is exactly what AA and AB
did.** Do not re-run a one-factor rune experiment.
POWER ALONE IS CLOSED AT ANY REACHABLE MAGNITUDE (acquisition
untouched): x1 16.97 / x3 16.49 / x6 17.07 / x10 17.93 — a TENFOLD
magnitude increase moves the primary metric 0.96 tiers against +/-3.9.
ONCE ACQUISITION IS FIXED the dose-response is smooth and the number is
much smaller than anyone assumed: rich+x1 16.12 / x1.5 20.50 / x2 23.75
/ x3 27.13 — **detectable at ~x1.5, unambiguous by x2**. So a runes.json
magnitude pass authored against TODAY's numbers would be roughly double
what is wanted. Threshold-like because the run economy compounds (Batch
T's attrition->income loop).
**STAGE 0b — THE INSTRUMENT WAS THE PROBLEM, and this changes how EVERY
future row is read. COMPLETIONS IS DEMOTED TO SECONDARY.** At n=50 the
resolvable difference between two rows is ~15 PERCENTAGE POINTS, so
AA/AB's 4->6%, 6->2%, 8->13% "noise" verdicts were unfalsifiable rather
than wrong. Proof found by accident: the SAME COMMIT (7ec7f97) on the
SAME FLAGS measured 4% (AC), 10%, and 8%. **PRIMARY IS NOW `depth
reached`** — mean absolute tier at run end, 1-33, every run contributing
one sample. The report prints an INSTRUMENT RESOLUTION block ABOVE the
numbers it qualifies (mean/SD/SE + the resolvable difference at
n=50/100/150). Measured at n=100: depth +/-3.9 tiers, ratio@z1t8 +/-0.09,
completions +/-10.7 pts. **`ratio@z1t8` IS SURVIVAL-CONDITIONED** (49-76
of 100 runs reached t8 across these rows) — an arm that helps weak runs
live longer ADDS weak runs to the sample and pushes the mean DOWN; also
the block's per-run mean and the Matrix row's pooled figure are DIFFERENT
ESTIMATORS of the same tier. Depth has neither problem.
RUNE ECONOMY BLOCK (run report, stage 0a): offered/bought/equipped split
shop vs elite cache, refusals BY REASON (no free slot / unaffordable /
duplicate), elite runes won with no slot, slots available vs filled, and
what each hero wears split spec/class/universal/stat-stick. Header states
the confounder: the bot takes 0.6 of 5.4 shops offered, so sim
acquisition is A FLOOR ON THE BOT'S ROUTING, not a human's — and NO route
policy ranks a shop above a fight, so that ceiling is unreachable by
route choice (gap reported, no policy invented mid-batch).
LEVER VERDICTS FOR THE DESIGNER (reported, NOT chosen): control row gold
earned 582 / spent 151 / **unspent 431**, slots **2.80 available per hero
and 0.58 filled = 21%**, shops 0.6 of 5.4 taken, rests 2.3 of 5.6, elite
caches 0.82/run. **OPENING THE THIRD SLOT EARLIER IS A DEAD LEVER —
remove it from the list**: the party leaves 79% of the slots it already
owns empty. Rarity re-pricing is cheap/safe/small (across a run price is
NOT the constraint — the party dies holding 431g — yet AT THE COUNTER it
binds, 1.04 of 2.56 offers refused, because the counter is reached 0.6
times a run). Biggest levers by touch rate: a rune offer at rest nodes
(2.3/run vs the shop's 0.6) and a starting rune at the draft (+1.00/hero,
front-loaded where runs die). A second elite cache is small (~+0.2/hero).
"Change nothing and measure a human first" is a real option — the shop
rate is a BOT floor.
GOTCHA THE ARM'S OWN POSITIVE CONTROL CAUGHT: **`blood_pact` RUNS
BACKWARDS** — Exsanguination's -15 is its BENEFIT (bleedout at 85), so a
sign-based cost test holds it and the rune goes inert. Named
`Runes.INVERTED_STAT_FIELDS` beside `PENALTY_FIELDS` (positive = cost on
both). Rows already running were THROWN AWAY and re-run, not caveated.
VERIFIED: test_runes.gd EXTENDED 1,961 -> **3,085 checks, 0 failures**
(purity gate with env set + sim_run false; cost-list drift alarm; every
entry's costs held and benefits scaled at x3 with sign and int/float type
preserved; x1.0 proven to be the identity; the whole SCALED pool re-run
through the schema + scarred checks). test_rune_battle.gd 84 -> **91**: a
Berserker spawned three times (no runes / x1 / x3) and read off the LIVE
unit as deltas — blood_pact -15->-45, crit_bonus +.08->+.24,
dmg_taken_bonus +.15->+.15 HELD. Save files byte-identical with BOTH arms
armed. Control reproduces pre-batch HEAD from a clean worktree at matched
n=100 (median z1 t11.0 identical, completions 6% vs 8%, choice 79% vs
78%). Headless parse: all 10 scenes, 0 SCRIPT ERROR.
REPORTED NOT ACTED ON: (a) Pyromancer 35->42% and Sharpshooter 25->19%
are the only twelve-spec contribution moves >5pts, and only under the
combined arm — the Pyro direction is Batch W's known AoE-scales-with-
field-size signature; per-spec n is only ~33 under rotation. (b) The Rune
of Exsanguination's scarred audit passes on a term that is actually its
BENEFIT — its real cost (15% vs 20% bleedout) is a battle.gd constant no
audit can see. (c) test_rune_battle's White Flame check is FLAKY
(~1 run in 3 — the bot must land a fire hit); pre-existing, do not read
it as a regression. (d) treasure/Loot — deleted by AN, see the AP block.
BATCH AC (08-04) — THE TESTER'S WORKBENCH: reach any node on demand.
DEBUG/TESTING AFFORDANCES ONLY — no balance, no content, no difficulty
(difficulty stays CLOSED pending human playtesters). Designer's ask
verbatim in substance: "I need some way to access any node on the map
for testing — often I want to test the shop or the ???, but I have to
fight through the other nodes to get to them."
STAGE 0 RECONCILE (asserted in the test, not just remembered): map
burger DEBUG ids 10-16 and the battle `DEBUG ▾` menu already existed and
are UNTOUCHED. New map ids start at 20, the event picker at 100. NO
"Summon Boss" (Jump to Boss Tier id 13 already goes there) and LOOT IS
LISTED NOWHERE — the treasure node type is dead code (no generator has
dealt one since the Batch 38 deck); its click handler is left exactly as
Batch Z recorded it.
THE HONESTY FLAG: `Run.debug_used`, SAVE v5 (tolerant — a v4 save loads
it false). Written in EXACTLY TWO PLACES, both at the top of a debug
dispatch (map_screen._on_burger, battle._on_debug_menu), so every debug
item INCLUDING the pre-AC ones trips it without seven write sites. Check
items trip it when toggled ON; unchecking NEVER clears it. The run
summary opens with "DEBUG TOOLS WERE USED IN THIS RUN — not a clean data
point." via a new "w" line tag — rendered in the panel AND carried into
the Copy-summary clipboard text (the half that reaches feedback). Sims
can never set it (RunSim loads neither scene).
FREE TRAVEL (map DEBUG check item id 20, session-scoped, never saved):
every node on the board clickable, any tier, ignoring links and
position, backwards too. Goes through the EXISTING `_on_node_pressed` —
no parallel branch — so the run advances HONESTLY: floor_idx/node_idx/
visited true, real tier readout, real save, fight scaled by the tier it
sits on, AND IT BOOKS ITS TALLY AND PROFILE ENTRY (correct: the party
really is there). FOUR clearly separate reads, not three plus an
ambiguity — debug-only-reachable = node colour pulled toward grey and
dimmed inside a magenta outline (`DEBUG_OUTLINE`, a colour nothing else
uses) + `[DEBUG] ` tooltip prefix + a corner `DEBUG: FREE TRAVEL`
marker. A VISITED debug-reachable node keeps its dim-green history fill
and only gains the outline (judgement call — "where I have been" must
survive the toggle).
TEST A NODE ▸ (submenu, ids 21-25: Shop/Rest/??? Event/Fight/Elite):
entered IN PLACE. Does not move the party, does not touch floor_idx/
node_idx, marks NOTHING visited. Everything else real (real shop offers
and gold, real heal, real battle at current tier scaling, real rewards).
"DEBUG VISITS DON'T COUNT" IS ONE GUARD, NOT FOUR: session-scoped
`Run.debug_summon`, set at the summon and cleared in map_screen._ready
(the return point of every summon that leaves the map; the in-place rest
clears it itself). CHECKED AT EXACTLY THREE SITES — Run.tally_add,
Run.tally_damage, and battle.gd's wipe branch, which turned out to be
the ONLY Profile booking a summoned node can reach (no boss is
summonable; the picker never calls Profile.note_event nor appends to
Run.seen_events in the first place). DYING IN A SUMMONED FIGHT ends the
run but books NO wipe.
WARBAND: `Run.compose(node_type)` — the SAME call `_generate_map` makes,
already defaulting to the party's current tier, so NO extraction was
needed and there is still exactly one warband generator. Elite goes
through the elite path (keeps the budget floor of 6).
EVENT PICKER (id 23 -> a full-screen list, per-event ids 100+): does NOT
call Events.pick. Lists EVERY event in data/events.json alphabetically by
title with its id and a live pass/FAIL column naming the failing
condition. REQUIREMENT-FAILING EVENTS ARE SELECTABLE ON PURPOSE (the
greyed-out branches are the point; the event screen still runs its own
guards). Seen events repeat; picking one does NOT append seen_events and
does NOT Profile.note_event.
ONE REQUIREMENT CHECK, REUSED NOT COPIED: `Events.failed_reason(run,
req)` ("" when met, else the first failing condition as a sentence) is
now the single implementation and `Events.requires_met` is that function
read as a boolean. The picker column, the event screen's greyed-choice
tooltip and the gate that filters the real draw are therefore the same
code. event_screen's private `_req_text` is GONE (it knew 2 of the 6
conditions and said "The party cannot do this" for the rest).
DOUBLE GATE: the DEBUG section is not BUILT unless debug_enabled(), and
firing an id straight into the dispatch is refused too (pre-AC ids 10-16
were previously protected only by not being drawn). battle.gd gained
`_debug_allowed()` = debug_enabled() and not sim_run and not sim and not
autoplay — mirrors `_forfeit_allowed()`, checked at BUILD and at FIRE.
VERIFIED (scratchpad, dies with the session): test_debug_access.gd 378
checks — surface/ids/submenu contents, gate-closed with ids FIRED
DIRECTLY, sim+autoplay+sim_run on both menus, flag round-trip through
v5 + v4 tolerance + summary + clipboard, summoned rest/shop/fight
booking NOTHING while the SAME THREE VIA REAL NODE PATHS BOOK BOTH (a
guard that is always on proves nothing), board untouched, free travel
forwards AND backwards, sim_run byte-identity. test_events_all.gd 2,613
checks — 16 events x 32 choices, 142 dispatch applications, each choice
run twice (healthy party + stressed: hero down, no gold, no items),
vocabulary asserted (no unknown verb/selector/requirement key/item/spec/
class id) and the verbs' promises proven (gold never negative, max HP
floor 10, EVENTS NEVER KILL). NO EVENT FAILED. Headless parse: all 10
scenes, 0 SCRIPT ERROR.
SIM PURITY PROVEN, NOT ASSERTED (this batch touches ONE thing a sim
reads: Events.requires_met, which RunSim calls at an event node). 50-run
rows, same flags: PRE (dc7ce03) route=default map=new diff=standard
completions=2% / wipe median z1 t11.0 / ratio@z1t8=0.92 / choice=79%;
POST completions=4% / z1 t11.0 / 0.98 / 77%. Median IDENTICAL, rest is
a 1-2 run spread at n=50 = the known noise band. Row reproduces. Plus
profile.json + run_save.bin + relics.json hashed before/after a real
DOD_SIM_RUN invocation = BYTE-IDENTICAL.
GOTCHAS WORTH KEEPING: (1) `PopupMenu.add_submenu_node_item` AUTO-ASSIGNS
the submenu parent's id from its item INDEX — which landed on 13, "Jump
to Boss Tier". Always pass an explicit id (the parent carries 9,
deliberately below the debug block). (1b) Whether Godot ALSO delivers a
submenu press to the PARENT popup could NOT be determined headlessly —
`PopupMenu.activate_item` HANGS without a display. Both popups feed
`_on_burger`, so it drops a repeat of the same id INSIDE ONE FRAME
(`_burger_id_this_frame` + set_deferred reset) — correct whichever way
the engine behaves. Tested both ways: same-frame double press rests
once, and the guard does not leak to the next frame. (2) An autoplay battle paces on
REAL timers (only `sim` mode skips them) and takes ~40 wall-clock
seconds / ~5,700 frames; a frame budget does not bound it. Headless
tests set `Engine.time_scale = 50.0` — it scales the SceneTreeTimers the
battle waits on and NOTHING else (same combat decisions), turning the
battle into ~1.5s / ~160 frames. (3) macOS has no `timeout` binary — a
`timeout ... | grep -c "SCRIPT ERROR"` parse check silently reports 0
errors for every scene because "command not found" contains no match.
Use `--quit-after N` and no wrapper.
REPORTED NOT ACTED ON (designer's call): (a) treasure/Loot was
the only node type a debug menu could not reach — DELETED BY AN with the deck
generator it belonged to (confirmed absent in AP);
(b) a summoned fight still increments `Run.combat_wins` (real
progression, left real deliberately), so a debug-touched summary's
"Battles won: X of Y" can read X > Y — cosmetic, and sims cannot see it;
(c) `gold_pct` is an authored effect verb NO event uses — the sweep now
fires it directly so it cannot rot, but it is either a content gap or a
line to delete.
BATCH AB (08-03) — HUNTER SPEC RUNES + SHIELDWALL AS A BLOCK STANCE.
TWO CORRECTIONS FIRST. (a) The Holy tree's Resurrection NODE TEXT said
"spend 3 Mercy"; faith_cost has always been 1 — the DESIGN CALL WAS MADE,
1 is correct, node text fixed. Everything else (ability desc, Last Rites
rune, glossary res_mercy/res_empower, master.html) already said 1.
(b) SHIELDWALL v1 FOSSIL DELETED — the `raw *= 0.75` branch Batch Z found
was v1's corpse (party -25%, replaced by Batch G), NOT a mistuned live
ability. Removed: damage-path branch, the vaulted "shieldwall" special
that applied it, its self-cast-list entry, the vaulted Sanctuary's
shieldwall grant, master.html's "Shieldwall -25%" target modifier.
CHECKED BEFORE DELETING, as the brief demanded: the two remaining
`_apply_status(..., "shieldwall", ...)` callers were VAULTED match
branches no ability/enemy/rune references — nothing live applied it, so
this stayed hygiene. Glossary never carried it (its drift alarm covers
DEBUFF_IDS; Shieldwall is a buff) — no stale entry to fix.
SHIELDWALL IS NOW A STANCE. It and Interpose were ONE VERB POINTED TWO
WAYS (both granted shield_charges, both fully negated) and the
self-directed half was the stronger. Interpose keeps the guarantee;
Shieldwall grants NO charges and gives +25% Block chance for 2 turns (3
perfect), +1 turn per Shield Mastery rank. 25 Rage / 2.0 / 2cd /
self-cast unchanged. const SHIELDWALL_BLOCK := 25; status id "shieldwall"
REUSED (the fossil's id, new meaning), power = the percent.
THE LOAD-BEARING BIT: the bonus is added to the `plating` slice of the
block roll, NOT to block_chance — so the blocks it buys label AND count
as HEAVY PLATING blocks, which is what makes them feed Tenacity and Rally
(charges never did). Say this in the ability description; it is the whole
trade. wd_shieldwall RE-SPECCED IN PLACE (same id, saved ranks migrate,
no refund): "+1 charge/rank" -> "+1 turn of stance/rank", 2 ranks.
BLOCK-SOURCE LABELS FOLLOW THE CHARGES: charge blocks now log
"(Interpose)" and the chip reads "IP3" (STATUS_INFO shield_charges label
+ both update_status sites). PREVENTED-DAMAGE: Shieldwall is no longer
its own mitigation site — the credit belongs to the block roll's existing
_prev call, counted ONCE, not lost (the measured ~30% drop, not ~100%, is
the proof). Heavy Plating's live-total CHIP folds the stance in
(unit.gd refresh_bars) and _update_talent_chips re-reads it every turn —
without that the readout lies while the stance holds.
12 HUNTER SPEC RUNES (runes.json 53 -> 65; ALL TWELVE SPECS NOW COVERED),
4 each for beastmaster/sharpshooter/mystic, one per lane out of
LANE_TREES + 1 splash, exactly 1 scarred per set ON a lane. ZERO new cfg
fields (cap was 4; AA spent 1 for 24 runes) — every entry rides an
existing talent counter's read site. Beastmaster lanes are LOWERCASE
(devotion/pack/handler); Sharpshooter Precision/Penetration/Tempo;
Survivalist Venom/Snares/Guerilla. Runes.STAT_INT_KEYS GAINED SIX
(loyalty_cap_bonus, deep_focus, perfect_form, opening_volley,
coated_blades, vulture) — Hunter flag talents whose payload is a bare 1
and which do NOT end in "_ranks", i.e. the exact AA float-into-int trap.
TRAPS HANDLED: wild_communion_ranks NEVER communion_ranks (Devout's);
companions inherit the hunter's ARMOR at summon and per-beast terms
double under The Pack, so the Beastmaster's scarred rune puts its COST on
armor (-8%, and its text says "every beast he calls wears his plate")
and its upside on Quick Shot — the same multiplication has been true of
class:hunter wolfs_hunger since Batch X and was never written down; NO
Hunter rune carries a healing term (Ancient Pact's no_heals would make it
a dead rune); the Survivalist's meter lives on the ENEMY so his runes
write Poison-side effects. TWO SHARPSHOOTER RUNES WRITE FOCUS CEILINGS
(deep_focus 150, opening_volley 60) — the FIRST runes to exercise AA's
call-site ordering fix for real; test_runes now also asserts the POOL
CONTAINS such a rune (an ordering assertion guarding a road nothing
drives on proves nothing). No epic in the twelve: rarity means KIND
(grant/type-change/rule-invert) and none of these do that; 5 of the 9
prior spec sets have no epic either.
**THE BATCH AA ARTEFACT WARNING IS RETIRED — do NOT resurrect it.** Its
wording ("any shift disfavouring Beastmaster/Sharpshooter/Survivalist is
pool depth, not balance", pointing at Sharpshooter 25->20) expires here:
all twelve specs have sets, so the twelve-spec contribution table is
internally comparable for the first time since Batch X.
MEASURED — STAGE 2 ALONE, BEFORE STAGE 3 EXISTED (standalone sim, Batch G
Warden party warden/cryomancer/inquisitor/beastmaster, 200 battles;
standalone sims never equip runes, so these rows are stage 2 only).
FIXED: deaths/b 0.02->0.03, survivors' HP 86->84%, enemy dmg/b 126->148,
WARDEN PREVENTED 65->47/b, contribution 23->21%, damage share flat 17%.
ROTATED: deaths/b 0.21->0.20, prevented 70->49, contribution 20->19%.
HONEST READ: prevented falls ~a third, exactly what trading 3 guaranteed
blocks for a 25% chance does; deaths do not move. THE ROWS CANNOT SEE THE
OTHER HALF — a standalone sim spends NO talent points, so Tenacity and
Rally are absent from the very measurement used to price an ability whose
purpose is now to feed them. That half is proven in test_shieldwall.gd.
NOT A STALEMATE FIX, and must not be recorded as one — the balance
question stays deferred and open.
TENACITY NUMBER (asked for): a held-open Warden battle with Shield
Mastery 2 + Tenacity + Rally reached max HP 200 -> 240 over 9 blocks.
Unbounded still, but nowhere near the old runaway (~127,000, Batch W).
MEASURED — STAGE 3 / RUNE ROWS (route=default, map=new, diff=standard).
CONTROL off n=50: 6% completions / ratio@z1t8 1.00 / choice 78% =
REPRODUCES AA's off row (6% / 0.99 / 78%). FIXED PAIR n=50: off 6% ->
full 2% (ratio 1.00 -> 0.91). ROTATED PAIR n=60 each, its own control:
off 8% -> full 13% (ratio 0.94 -> 1.00). **THE ORDER FLIPPED BETWEEN THE
TWO PAIRS INSIDE ONE BATCH** — fixed says runes cost 2 completions,
rotated says they gain 3; the whole spread is a handful of runs. AA's
finding reproduced without needing two batches: the authored pool at
CURRENT power does not move completions beyond noise. Open lever is
still authored rune POWER (runes.json data edit, not machinery).
NOISE CALIBRATION WORTH KEEPING: the default sim party is berserker/
cryomancer/inquisitor/beastmaster — NO WARDEN — and the control runs
runes=off, so that row is a genuine NULL-CHANGE control (nothing in this
batch can reach it). Its wipe median still read z2 t5 vs AA's z1 t11 —
but the distributions are near-identical (23 vs 25 z1 wipes of 47) and
the median sits ON the z1/z2 boundary, so a TWO-RUN difference flips the
zone it reports. **The wipe median is a knife-edge stat at n=50; never
quote it as a trend on its own.**
TWELVE-SPEC CONTRIBUTION TABLE, INTERNALLY COMPARABLE FOR THE FIRST TIME
SINCE BATCH X (rotated, off->full): Pyro 34->33, Survivalist 29->32,
Holy 29->29, Warden 25->25, Sharpshooter 24->25, Arcanist 23->25, Cryo
27->24, Swordmaster 24->23, Beastmaster 20->21, Occultist 19->19,
Berserker 18->19, Devout 14->15. All three HUNTER specs read slightly
UP — the direction AA's (now retired) warning predicted would be DOWN
while their pool was thin. Everything is within a couple of points =
noise-sized. Pyromancer still tops the table, as Batch W measured and
deliberately left alone.
RUNE ECONOMY, REPORTED NOT CHANGED (dilution stays open, NOT this
batch's job): acquisition is 2.2 runes/run fixed (1.4 shop + 0.8 elite)
and 2.8 rotated (1.6 + 1.2) across FOUR heroes = ~0.55-0.7 per hero per
run. The pool grew by 12 while per-hero acquisition did not move, so a
Hunter still ends a run carrying 1-2 of his 4. NOTE the "~2.4 shop
runes/run" figure quoted in briefs is PRE-Y: since Batch Y the bot's
fight-first preference binds and it takes 0.7 of 5.1 shops offered.
VERIFIED (scratchpad, dies with the session): test_runes.gd 1961 checks
(coverage now spans ALL TWELVE specs read out of Classes.SPEC_IDS +
"exactly 1 scarred, on a lane" + a POSITIVE CONTROL asserting the
exclusive-pair alarm still watches 15 named fields, so a rename cannot
silently stop it watching); test_shieldwall.gd 53 checks — its core is a
CAUSAL PAIR, not an inference: base Block pinned to 0, Heavy Plating's
15% cancelled by holding plating_bonus at -0.15 and Interpose stripped
from his kit, so the ONLY live slice is the stance's 25% — STANCE UP 6
blocks / 56 attacks / Tenacity +30 max HP vs CONTROL 0 blocks / 50
attacks / +0; test_rune_battle.gd 84 checks (3 Hunter passes added: the
Beastmaster forced to TWO beasts via bm_the_pack + direct _do_summon,
both wearing his rune-reduced armor; the Sharpshooter's Focus cap reading
150 and opening on 60 = the ordering fix live; Snare Trap at 15 Mana /
2cd = the ability branch). Headless parse: all 10 scenes, 0 SCRIPT ERROR.
GOTCHA (cost a rerun): test_rune_battle's White Flame check was a coin
flip on WHICH enemy the bot burned — its warband is now ashblade/hurler/
shaman, ALL fire-resistant, so any fire hit exercises the one read site.
HOUSEKEEPING, DESIGNER-APPROVED: the nine data/talent-tree-*.json design
sources (216K) are DELETED. Nothing had read them since Batch P emptied
FIXED_TREES/LANE_CONVERSIONS, and they had drifted into being actively
misleading — the Warden file still promised "block the next 3 oncoming
attacks" — while sitting in data/, where a future batch would reasonably
look for ground truth. Recoverable from git history if ever wanted.
**Talents.LANE_TREES is the ONLY source of tree truth; do not restore a
JSON mirror of it.**
BATCH AA (08-03) — MAGE + CLERIC SPEC RUNES, AND A FORFEIT. 24 spec runes
(runes.json 29 -> 53 entries), 4 per spec, ONE PER LANE READ OUT OF
Talents.LANE_TREES + one splash; exactly 1 scarred per set, ON a lane
(splashes always clean); 3 epics (White Flame, Last Rites -> grants
Resurrection, Flayed Mind -> grants Mind Flay). Spec coverage is now
Warrior+Mage+Cleric; HUNTER HAS NO SPEC RUNES. ONE new cfg field for the
whole batch (cap was 4): rune_resist_pierce (float on BattleUnit) — thins a
target's POSITIVE resist to the attacker's type, weaknesses untouched; ONE
read site, battle.gd's resist block right after the avatar_flame branch,
logs "Rune: the flame bites through resistance". Everything else rides
talent counter fields (the point of the design: 24 runes, 0 new read
sites). ORDERING BUG FIXED — the second-resource CEILING blocks (arcanist
resonant_core_ranks/singularity, holy mercy_cap_bonus/zealous_mercy,
sharpshooter spray/deep_focus/opening_volley) were derived from cfg BEFORE
the rune-apply block; any rune writing them applied cleanly and did
NOTHING. They now sit immediately AFTER runes apply (talents unchanged —
they apply further up; the class-passive block still ASSIGNS
healing_received_mult/mana_regen_bonus, so runes must stay AFTER it or the
Martyr/Wellspring runes break). test_runes.gd asserts the call-site order
so it cannot move back — the Hunter batch would have hit this on Focus.
AUTHORING RULES THAT ARE NOW TESTED, NOT JUST WRITTEN: no rune may write
one half of an EXCLUSIVE talent pair (heat_haze/scorched,
cascade/overflow,
pact_flesh/barter — cold_snap/bitter_cold DISSOLVED IN BATCH AS: both sit
in Deep Freeze rows 6 and 2 now, a player can hold both, and a rune writing
either counter is legal. arcane_ward/still_mind DISSOLVED IN BATCH AT: both
designs are gone (their ids carry Event Horizon and Backlash), so the pair
went with them. **stalwart/bastion DISSOLVED IN BATCH AW**: Batch K authored
them as an in-lane fork (a bigger shield, or a more frequent one) and BATCH
AI'S ROW EXCLUSIVITY DESTROYED IT — they sit in Bulwark rows 5 and 6, so a
player holds both, and the combination is now legal AND large (a shield
absorbing 50% of his maximum, on no cooldown). NOTE the rule itself is no
longer a live TEST:
Batch AI retired test_runes._exclusives to a `pass` because at row
granularity it would fire on nearly every spec rune in the game); every
stat field must be a real BattleUnit property or
a cfg field battle.gd consumes (set() SILENTLY DROPS unknown names — a typo
is a dud, not a crash) AND something must actually read it; payload carries
exactly ONE branch (apply_payload is an if/elif chain — a second branch is
dropped). unit.heal_amount now FLOORS the healing multiplier at 0 —
healing_received_mult is a running sum of rune terms and a negative one
would turn every heal into damage that bypasses death handling (worst
reachable case is -0.6 vs a 1.0/1.15 base, so this is a guard, not a fix).
Scarred = "a real cost", NOT literally a negative number: Batch
X's Glass Rune pays +0.15 dmg_taken_bonus, so the check knows a
PENALTY_FIELDS list. RUNE ROLL CALL: most spec runes ride an existing
talent's proc line, so battle open now logs one grep-stable
"Rune: <hero>: <rune name>" per equipped rune. FORFEIT RUN (battle burger,
real play only) — AN ESCAPE HATCH, NOT A STALEMATE FIX; the balance
question stays deferred and open. Confirm dialog + 5-reason picker
(FORFEIT_REASONS); ends the run EXACTLY as a wipe (snapshot -> Run.active
false -> clear_save -> Batch Z summary) so there is nothing to exploit;
summary outcome reads "Forfeited" with its own colour + the reason + the
final battle's lineup; Profile.note_forfeit -> its OWN "forfeits" bucket
(never note_wipe) + forfeits_total(); chronicle gains "Cycles abandoned"
only when >0. Guard: _forfeit_allowed() = Run.active and not Run.sim_run
and not sim and not autoplay — the menu entry is not even BUILT under a
harness, and _do_forfeit re-checks. NUDGE (real play only,
FORFEIT_NUDGE_TURNS = STALEMATE_TURNS): one non-blocking label + log line,
fires ONCE, ENDS NOTHING and touches no HP. MEASURED (route=default,
map=new, diff=standard, n=50): control off = 6% completions / wipe median
z1 t11 / ratio@z1t8 0.99 / choice 78% (reproduces X's off row and Y's new
map) — stats 8% / 0.93, full 4% / 1.05. The whole spread is TWO RUNS at
n=50: authored pool at current power still does not move completions beyond
noise (X's finding), and the off/stats/full ORDER FLIPPED between batches,
which is itself the evidence. Shares flat (Cryo 39->38, Devout 4->4).
ROTATED PAIR (DOD_SIM_ROTATE=1, n=60 each, its OWN control — the fixed
party holds only 2 of the 6 new-set specs): off 15% / wipe median z1 t9 /
1.01, full 17% / z1 t11 / 1.02 = one run apart. Contribution off->full:
Pyro 36->32, Warden 29->36, Holy 29->28, Survivalist 29->30, Cryo 26->27,
Sharpshooter 25->20, Swordmaster 23->25, Arcanist 22->21, Occultist 19->15,
Beastmaster 19->18, Devout 15->13, Berserker 15->16. HOLY DOES NOT MOVE —
28-29% contribution off 5-6% damage, ~330 heal/b, reproducing Batch W
exactly. LIKELY CAUSE IS DILUTION AND IT APPLIES TO THE WHOLE BATCH: the
party buys ~2.4 shop runes/run plus elite picks across FOUR heroes, and the
mage/cleric spec pools just tripled — a given Holy carries 1-2 of her 4.
Look at the rune ECONOMY before concluding the entries are underpowered.
DO NOT read the cleric support numbers as a direction: Devout heal/b went
10->14 fixed-party and 25->13 rotated — opposite signs, i.e. noise.
ARTEFACT WARNING **RETIRED BY BATCH AB — DO NOT RESURRECT IT.** As
written it read: "any share/contribution shift DISFAVOURING Beastmaster/
Sharpshooter/Survivalist is POOL DEPTH, not balance — already visible at
Sharpshooter 25->20." That expired the moment the Hunter got its sets;
all twelve specs are covered and the table is internally comparable.
Difficulty still closed pending human playtesters. VERIFIED (scratchpad, dies with the session):
test_runes.gd 1523 checks, test_forfeit.gd 57, test_rune_battle.gd 46 (3
live autoplay battles, every rune of a spec equipped at once; ordering fix
proven live — Holy opens holding Mercy, Arcanist ceiling reads 6; counters
proven to SUM when two runes feed one; the Pyromancer's Inferno chip shows
the rune-boosted step — the live-value-chip gotcha; White Flame proven
against a deliberately fire-resistant warband because a raider lineup never
exercises it). Headless parse: all 10 scenes, 0 SCRIPT ERROR. REPORTED NOT
CHANGED: the Holy tree's Resurrection NODE TEXT says "spend 3 Mercy" but
the ability's faith_cost is 1 — in-game UI text, and which number is wrong
is a design call.
BATCH Z (08-03) — THE ALPHA SHELL: glossary, orientation, run summary.
Content-free by design; the deliverable is LEGIBILITY (Y made the map a
decision surface, Z makes the run readable). STAGE 0 RECONCILE: all of
Y's stage-4 map legibility shipped and was verified present (tooltips,
ladder readout, gold roads, 3-state nodes) — Z only ADDED a burger entry
+ the framing card; no duplicate tier readout or tooltip path exists.
GLOSSARY: data/glossary.json + scripts/glossary.gd (class_name Glossary;
Enemies/Events pattern — adding a term is a JSON edit). 66 entries, 7
categories (combat/statuses/damage/resources/progression/gear/run);
schema id/term/category/short/long/see_also. WRITTEN FROM THE CODE, not
master.html — that rule is load-bearing (Batch Y's 70%-vs-53% link drift
is the precedent; a glossary teaching intent is worse than none).
scripts/glossary_panel.gd (class_name GlossaryPanel, extends Control):
GlossaryPanel.open(parent) from the MAP burger, PARTY screen, BATTLE
burger. IN BATTLE IT IS INERT — no awaits/timers, and battle.gd's
_input/_unhandled_input early-return while `_glossary` is valid (without
that gate a click on the panel grades the live skill check underneath).
Contextual hook: unit.gd _refresh_chips appends Glossary.status_short(id)
to a chip tooltip when it adds info. Ability-tooltip + resource-bar hooks
DEFERRED (stated, not silently dropped). ORIENTATION: two one-time cards
on NEW Profile flags (profile.gd "flags" bucket + flag/set_flag; set on
DISMISSAL so quitting mid-card re-shows it) — (1) map framing card
"THE CLIMB" (map_screen._maybe_show_framing, gated floor_idx<0 and not
sim_run), (2) the SKILL-CHECK POINTER inside _run_skill_check before the
bar sweeps (gated `not sim and not autoplay and Run.active and not
Run.sim_run`) = the batch's highest-value item (a tester who never sees
the timing window reports the combat as shallow). RUN SUMMARY: replaces
BOTH end panels. battle.gd _run_snapshot/_summary_lines/_member_summary/
_summary_plain_text/_show_run_summary. TWO GOTCHAS HANDLED AS SPECIFIED:
(a) SNAPSHOT BEFORE Run.clear_save() in both branches — the save logic
was NOT reordered (a resumable dead run is worse than a missing
summary); (b) the run ledger lives on Run (Run.tally + reset_tally/
tally_add/tally_damage), NOT the battle scene (it reloads between
fights). battle _stat writes `_run_slice` ONLY when `sim` is false →
RunSim's stats path untouched, no double-count; banked once per battle at
the top of the run-mode end block. Bump sites: award_gold (gold_earned),
shop buy item/rune (gold_spent), map rest (rests), battle end
(battles/elites/damage). SAVE v4 = +tally; load tolerant (pre-Z saves
start a ledger mid-run). "Copy summary" → DisplayServer.clipboard_set
(a wipe becomes a pasteable report — feedback data, no telemetry).
VERIFIED: scratchpad test_glossary.gd 859 checks (schema, see_also
resolution, no dup ids/terms, + THE DRIFT ALARMS: every
BattleUnit.DEBUFF_IDS status, every damage school incl. a sweep of every
resists key in enemies.json, and a SPEC_RESOURCE map asserted to cover
Classes.SPEC_INFO exactly — a new spec/status FAILS the test until the
glossary learns it); test_run_summary.gd 23 checks (ledger sums across
simulated scene reloads = per-battle totals, sim _stat leaves _run_slice
empty, snapshot survives clear_save + is a deep copy, summary text builds
from the snapshot alone, save v4 round-trip, pre-Z self-heal; backs up
and restores the REAL save); test_glossary_battle.gd 6 checks (autoplay
battle, panel opened mid-fight, timeline clock still advances, closes
clean, no profile written); test_sim_purity.gd 17 checks (sim_run armed
through the whole Z path; save/clear no-ops; BOTH orientation gates
evaluated false for every sim/autoplay combination; user:// profile,
run_save and relics hashed before/after = byte-identical). Headless
parse: all 10 scenes, 0 SCRIPT ERROR. GOTCHA RE-HIT: a --script test
must park on the first process_frame — autoloads (Run) are NOT in the
tree during _initialize, and get_node("/root/Run") there returns null and
idles forever. DOC DRIFT AUDIT (the valuable output): all
load-bearing machinery MATCHED (timeline formula, skill-check windows +
mults, Break, crit/miss/parry, 7-school resist pipeline + 85%/1-dmg
clamps, all 9 resources, BOTH talent gate models, run structure) — Batch
Y's §3 episode did not repeat. 8 fixes: (1) SHIELDWALL documented −50%,
code is −25% (raw *= 0.75) — wrong at 2 master sites AND the in-game
combat log said "takes half damage" (log fixed too; the status tooltip
was already right, so doc+tooltip had been contradicting each other).
**SUPERSEDED BY BATCH AB: that −25% was Shieldwall v1's FOSSIL, not the
live ability — the whole branch is deleted. No percentage Shieldwall
ward exists; Shieldwall is a +25% Block-chance stance.**
(2) Waystone Shard §7 "+1 talent point" vs relic's +3 (§8 already said
3); (3) run-flow line "Battles / Rest / Loot" → no Loot nodes exist;
(4) Poison table "3 nature damage/stack" flat vs 3% of applier Attack
(§4.5 was right — they agree ONLY at exactly 100 Atk, which is why it
survived); (5) relic trio "all six damage schools" → seven exist, trio
covers the six NON-PHYSICAL; (6) party-screen "Resistances lists all six
elements" → seven, physical included; (7) "6 shop nodes" → 5;
(8) CLAUDE.md "26 authored" runes → 29 + Batch-28 "2/4/4" talent points
superseded by 1/2/3 since Batch 30 (annotated in place). SHAPE OF THE
DRIFT: none was a system behaving unexpectedly — all were NUMBERS THAT
MOVED ONCE AND LEFT A COPY BEHIND, i.e. exactly what a doc-sourced
glossary would have taught every tester as fact.
DEAD CODE RECORDED, NOT REMOVED: the "treasure"/Loot node type has a
label, colour and click handler in map_screen.gd but NEITHER generator
has dealt one since the Batch 38 deck (17/5/5/3) — the glossary does not
mention Loot nodes because a tester will never see one.
BATCH Y (08-03) — THE MAP NODE ECONOMY (alpha-scoped: legibility and
agency were the deliverables, difficulty deliberately left to Batch T
and human playtesters). DIAGNOSIS MEASURED FIRST: the old 70% link roll
made 53% of nodes single-link (WORSE than the 30% the rule implies —
edge columns rolled adjacents out of range), and the blind 30-card deal
constrained nothing; baseline agency (route=default, economy on, n=50)
= 1.58 reachable/step, real choice on 34% of steps, rests
ever-reachable 4.3 of 9.0 dealt. NEW GENERATOR (run_state): every node
links own column + >=1 adjacent GUARANTEED (25% both where a middle
column has two); deal stays 17/5/5/3 but rejection-sampled (40-shuffle
budget -> hill-climb swap repair -> authored fallback, never fails,
~7% of maps repair) against: no three-of-a-kind tier, rest in t2-5 AND
t6-10, shop in t7-10, >=1 elite/zone (floor AFTER the 25% roll); a
walkable 2-rest+shop+elite route is guaranteed by DP at generation
(_ensure_key_route adds links if missing — validator shows ~11 adds
per 500 maps). OLD GENERATOR KEPT VERBATIM at DOD_SIM_MAP=old.
RUN-REPORT ROUTE-AGENCY BLOCK (stage 0, run_sim): reachable/step,
choice %, taken-vs-offered and dealt-vs-ever-reachable per node type;
Matrix row gains map=/diff=/choice= fields — pre-Y rows have no such
fields, never compare across. MEASURED (route=default, n=50/row):
control at map=old reproduces baseline (0% completions, ratio@z1t8
0.97, choice 36%); new map choice 34%->80%, reach/step 1.58->2.16,
completions 0->4%, ratio@z1t8 0.95 (said in advance: completions rise
as a CONSEQUENCE of agency; report, don't tune). HONEST ARTIFACT: the
bot's fight-first prefs now BIND — shops taken 1.6->0.6/run of 5.7
offered, unspent gold doubled; the old corridor was force-feeding the
bot the economy. Do NOT tune the shop/economy on route=default rows
alone. DIFFICULTY AFFORDANCE (draft "The Road"): standard | wanderer
(x0.7), ONE mult inside zone_base_mult (the single read site — battle
spawn), saved with run (save v3), DOD_SIM_DIFFICULTY env; ALPHA
TESTING AID, NOT BALANCE — wanderer row: 58% completions, wipe median
z3 t5, z1 ratio 1.44 (easy z1 accepted; a tester can now see the whole
game). LEGIBILITY: rest/shop tooltips state what they do (rest quotes
real heal % incl. relics), event tooltip says "unknown" ON PURPOSE
(mystery stated, not blank); ladder readout "Tier 7 of 10 — the
<boss> waits" (Enemies.unit_name(Run.boss_kind())); roads out of the
current node glow gold; visited/reachable/unreachable are three
separated reads. SAVES: pre-Y saves keep old maps+links, NEVER
migrated — no runtime code may assume the new guarantees hold on a
loaded map. Scratchpad test_map_economy.gd (dies with the session):
500 new + 50 old maps, 37,710 checks — composition conserved, no
homogeneous tier, no stranded node, boss reachable from every gate,
independent-DP route check (2-rest state = bits 0+1, full mask 15),
mean links 2.09/node, 80% node choice rate, zero single-link new
nodes, old gate re-shows the 53% corridor; plus zone_base_mult
difficulty probes. Policy smokes: greedy/default/cautious ordering
survives wider reachability (greedy rests least, cautious most).
BATCH X (08-02) — RUNES BECOME A BUILD SYSTEM. Slots grow with the run:
Run.rune_slots() = 2 + zone_idx, NO cap (4th zone = 5), every old
hardcoded 2 routed through it (party equip cap+header, run_sim elite
auto-equip + shop free-slot check); zone-victory text announces the new
slot; no save field (derives from zone_idx). Party-screen rune rows now
a ScrollContainer (old code silently hid rows past 4). POOL:
scripts/runes.gd wraps data/runes.json (Enemies/Events pattern) — 29
authored: 5 universal, 3×4 class, 12 warrior-spec (one per talent lane
+ a splash-payer per spec; entries carry "lane" for the bot). RARITY =
KIND (common stat sticks incl. the 6 old TEMPLATES as filler+exhaustion
floor / rare ability-alter or talent-like / epic grant-ability,
type-change, rule-invert), weights per zone slot 60/30/10→40/40/20→
25/45/30 formulaic past 3 (Runes.rarity_weights). SCARRED = flag on
rare/epic, own prefix "Scarred"+crimson, payload MUST carry a negative
term, priced BELOW clean peer. ELIGIBILITY (load-bearing): scope
universal|class:<key>|spec:<id>; ability payloads carry
requires_ability checked vs Runes.kit_names (core + spec_abilities +
apply_kit_overrides renames + bm_abilities trophies) — apply_payload
matches display_name, an unowned name is a SILENT DUD. Exhausted pool
widens rarity then falls to the Common family — offers never empty.
JSON ints restored on load (Runes.STAT_INT_KEYS/_ranks suffix/
AB_INT_KEYS — the Ability.make typed-set gotcha). generate_rune now
takes the MEMBER dict; returns {} when off. 4 NEW cfg fields (cap was
4), each ONE battle.gd read site + "Rune:" log: blood_pact (neg shift:
enemy bleedout at 100+pact for 15%, _add_bleed_with_burst — scans for
negatives itself, _living_hero_with wants >0), rune_lifesteal (strike
loop by ab.lifesteal), rune_execute_bonus (<35% HP, raw block by
Grudge), rune_bd_bonus (pr block after Broken Will). ELITE PICK-OF-3:
Run.roll_rune_candidates at drop time → member rune_candidates (queue
of triples) + rune_picks_owed (bm_picks_owed mirror), saved with the
party dict, resolved on the Party screen via the trophy-picker pattern
(auto-equips while a slot is free); sim policy build-lane→spec→first
(_pick_rune_candidate). DOD_SIM_RUNES=full(def)|stats(old generator)|
off(none anywhere) — printed in the run-report policy header. MEASURED
(route=default, economy on, n=50/row): control sweep at off reproduces
W (100/100/98/96, Cryo 49/42/40/37); off 4% / stats 2% / full 6%
completions, ratio@z1t8 0.94-0.98 — the pool at CURRENT authored power
does not move completions beyond noise; z2 t7 ratio 0.73→0.85 under
full but the z2/z3 collapse survives; shares flat (Berserker 28% all
rows). NEXT LEVER = authored rune power (data edit, not machinery).
ARTEFACT WARNINGS: (1) SUPERSEDED BY AA, THEN RETIRED BY AB — as
written, "only the Warrior has spec runes, so any Warrior-favouring
share shift is pool depth"; all twelve specs are covered now and no
pool-depth caveat applies (see the AB block); (2) the
rotated twelve-spec table only compares to Batch W at
DOD_SIM_RUNES=off. Batch V's 14% row does NOT reproduce on this build
even at off (W's stalemate guard sits between) — never compare rows
across batches. Scratchpad test_runes.gd (920 checks) +
test_rune_battle.gd (live log proof: "+30 Bleed" altered H&S, scarred
"bleedout at 85"). Mage/Cleric spec rune sets shipped in Batch AA, the
HUNTER in Batch AB — spec rune coverage is COMPLETE.
BATCH W (08-01) — THE OUTLIER PASS, MEASURE-FIRST. Every prior sim ran
the SAME four specs, so 8 of 12 had never been measured and the cited
"worst outlier" (Sharpshooter 38%) predated half the roster's rework.
DOD_SIM_ROTATE=1 cycles each class slot's spec across battles (sweep/
standalone) or RUNS (--run; never mid-run) via Classes.rotated_specs(n)
— any 3 consecutive counters cover each class's 3 specs, drift terms
vary WHICH specs pair up (27 parties, n=66-67/spec per 200). Shares
print sample counts and divide by the spec's OWN pool (party damage of
the battles it was in), so a fixed party reproduces pre-W numbers and
a rotated one stays on the same 4-hero basis. Fixed default party
UNCHANGED — rotation is opt-in, prior-batch A/B still valid.
CONTRIBUTION METRICS (both reports): heal/prevented/BD/statuses per
hero + a normalised contribution share. Prevented is INSTRUMENTED at
existing mitigation deltas (parry, Block incl. Interpose charges →
the granting Warden, barrier absorbs → the caster via status "src",
stance, Faith, Iron Will, Shared Vigil, Consecrated
Ground, Blessed Vestments, Savage Presence, Frost Ward, Molten Core,
Flame Shield, Chilled swing malus), never derived; unattributable →
its own bucket (measured 0-1/battle). BASE ARMOR/RESISTS DELIBERATELY
EXCLUDED (a stat block is not a contribution). Helpers: _prev /
_stat_heal / _stat_bd / _contrib_name (companions route to their
hunter); _apply_status stamps "src_name" so later mitigation can
credit the caster. TWELVE-SPEC SHARES (rotated sweep, b3/6/9/12):
Pyro 42/46/46/47 (CLIMBS = true AoE outlier, THE REAL ONE, left
untouched per the brief — next conversation), Arcanist 43/44/38/34,
Cryo 38/39/40/37, Sharpshooter 36/33/32/35, Swordmaster 32/25/26/27,
Survivalist 25/25/25/26, Beastmaster 17/25/28/26, Berserker
21/20/22/21, Warden 18/16/17/18, Occultist 11/14/16/16, Holy
13/9/6/8, Devout 4/3/4/5. Rotated curve 100/98/92/82% wins — a
rotating field is HARDER than the fixed party (100/100/100/96), so
the standard test party is one of the STRONGER compositions, not a
neutral one. SUPPORTS ARE NOT WEAK, THEY WERE INVISIBLE: Holy 431
heal/b = 33% contribution (HIGHEST at b12) off 8% damage; Devout 136
prevented; Warden 165; Occultist 102 heal. CRYOMANCER: Ice Lance
+10%→+5%/stack — BARELY MOVED HIM (control 49/42/39/39 vs V's 48→40,
and he casts it a real 1.1x/battle). Second lever measured ALONE per
the brief (freeze remainder 1→0): 47/42/40/38 = noise → REVERTED,
ember stays. His fixed-party 40-48% was partly an INSTRUMENT ARTEFACT:
that party carries the Devout (3-5%), so the other three split ~96%
and every share in it is inflated; rotated he is 37-40% and his own
classmates read 34-47% — typical for a mage, and the mage CLASS
out-damaging the roster is the real question. Permafrost permanence
and Razor Ice's 3 shards NOT touched (they fixed a structural fault).
ROTATED RUN 50 (route=default, economy on): completions 12%, wipe
median z1 t9.0, ratio@z1t8 0.97 (vs V's fixed-party 14% / z2 t6) —
rotation is harder in the run harness too. Warden 206 prevented/b and
33% CONTRIBUTION = HIGHEST of any spec; Holy 28% contrib off 5%
damage (337 heal/b). Per-spec battle counts vary (n=129 Swordmaster
to n=273 Warden) because durable parties survive deeper; runs sampled
per spec are even (16-17).
ENDLESS-BATTLE / STALEMATE — CAUSE ESTABLISHED 08-02 BY EVIDENCE, after
TWO wrong diagnoses. Symptom: run sims wedge on a battle that never
ends. (1) First blamed Endurance's +97,521% armor — WRONG,
effective_armor() has always ended in minf(a, 0.85) so it never reached
the damage path; the chip was lying. (2) Then blamed Tenacity feeding
Unkillable (max HP ~127,000, mends 7,607/block) — a REAL bug and now
fixed, but NOT the cause: fixing it left the stalemate rate unchanged
(5 → 6 per 50 runs). (3) ACTUAL CAUSE, from the debug log of a stalled
battle: the party is down to ONE surviving Warden (169 of 169 hero
actions in the final window are his) against a 5-strong warband holding
a Shaman + Totemist + Shieldmaster — 92 heal/shield events in the same
window. He cannot die (0.85 armor clamp + Block + Unkillable) and his
~17-damage single-target strike cannot out-pace five enemies' healing.
NEITHER SIDE CAN FINISH. It is STRUCTURAL, not a talent bug: any
last-hero-standing durable-but-low-damage survivor vs a healing warband
reproduces it. Rotation exposed it because rotated parties include
low-damage comps the fixed party never formed. Rate ~0.9% of battles
(6 per ~700). DEFERRED BY THE DESIGNER 08-02 — "we can ignore it for now." Do NOT
propose a fix unsolicited. (If it is ever picked up: a human hitting
this state is stuck in an unwinnable-unloseable fight, and the options
are a turn limit, escalating pressure, or a flee/forfeit action.) The two fixes above are kept as hygiene on their own
merits, NOT as fixes for this. BATCH AA (08-03) SHIPPED FORFEIT RUN — READ
THIS CAREFULLY: it is an ESCAPE HATCH FOR A HUMAN, NOT A FIX. The balance
question is still deferred and still open; the stalemate can still happen
and nothing about it changed. Forfeit only means a trapped tester can end
the run deliberately instead of force-quitting. Do NOT record this as
resolved and do NOT propose the balance fix unsolicited.
STALEMATE GUARD (battle.gd STALEMATE_TURNS=600, SIMS ONLY): a battle
past ~60 rounds is force-ended, scored a LOSS (never a win — that
would inflate completions), no HP touched (death stats stay honest),
and COUNTED + PRINTED in all three reports (never a silent cap).
Measured 5 trips across a 50-run invocation. Validated: at 25 turns it
fires 8/8 and reports; at 600 a 40-battle sim is 40/40 with zero.
LIMITATION (stated): "Hero ability uses/battle" divides by ALL
battles, so under rotation it reads ~3x low; the contribution table
divides by n correctly.
ENEMIES THAT ASK QUESTIONS (08-01, Batch V): 4 kinds — chanter (mender,
z1-3), hurler (brute·sniper, z2-3), bloodcaller (hexer, z1-3),
grave_totem (mender·hexer, z1/3) — and 4 new specials, NO existing
enemy stats touched. cleanse_allies: longest-remaining debuff stripped
from EACH ally (side follows the TARGET so psychosis flips it);
chilled thaws ONE stack via set_chilled_stacks; ruin takes ruin_primed
with it; broken/bleed are meter states it skips; sticky poison holds
(_cleansable_debuffs / _turns_left helpers — turns<0 = 999). windup:
"charging" status (turns -1, pending name stashed on the status dict);
landing at the unit's next turn as an Ability.make copy resolved
through _resolve (Hysteria pattern); turn loop cancels BEFORE the
stunned/frozen/broken_pending branches via _cancel_charge — the log
says "BROKEN mid-charge ... CANCELLED", keep it grep-stable.
blood_tribute: +25% dmg/BD per dead enemy, scaled attack copy.
totem_pulse: 6% of each ally's OWN max. AI gates in
_enemy_support_action (rite: any ally strippable; vigil: ≥2 wounded);
hurler/bloodcaller need none (damage>0 → affordable pool).
MENDER CAP (run_state._combo_ok): >2 mender-TAGGED kinds per warband
rejected, counted by role tag not claiming pool (totem via hexer pool
still heals) — the old generator held 2,007 3-4-healer warbands.
Satisfiability matrices before/after: NO theme lost a budget; distinct
warbands 11,344 → 23,561 (test_zone_rosters.gd recreated in scratchpad
— diff vs a HEAD worktree needs --import there first). RE-MEASURE
FLAG, DELIBERATELY UNTUNED: sweep top band 93.5→97.5% (deaths 1.3-1.5
→1.00), run completions 6→14%, wipe median z1 t9-10 → z2 t6 — moved
>1 tier, attribution = the cap deleting top-budget heal walls (z1
curve shape unchanged, t8 0.99/boss 0.72; roster-1 sweeps never see
the hurler). The outlier pass ran as Batch W (below). THE WIPE-MEDIAN
QUESTION IS CLOSED (08-02): the designer accepted the current
difficulty — "it's good for now, to fine tune it we will need many
human play testers." Do NOT reopen difficulty as a sim batch and do
not propose ramp-slope/boss-band changes unsolicited; the next input
on difficulty is human playtest data.
PERSISTENT PROFILE (07-26, Batch 40): scripts/profile.gd (class_name
Profile), user://profile.json OUTSIDE the run save — save_path is a
static VAR (not const) so tests redirect it. Counts runs started
(spec_choice _finish_and_fade) / completed (final-boss branch) / wiped
(defeat branch, Run.active-gated) PER SPEC (a run books all 4;
read-side totals divide by 4), bosses_killed by kind + zones_cleared
(boss victory branch), events_seen with repeat counts (map event
click). CHRONICLE ONLY — GATES NOTHING (roadmap Batch 8 says "sketch
only" + baseline-stability precondition unmet; the user DECLINED the
attrition batch, see memory). Relics screen hint shows the tally when
non-zero. Sims never write it (no Run.active / no encounter type at
the hook sites — verified). Design sketch for the future pass:
../persistent-unlocks-sketch.md (3 tracks: relic pool growth past 25,
event unlock requirement family, alternate capstones after N spec
completions — all awaiting the designer). Scratchpad test_profile.gd.
RELICS 5→25 (07-26, Batch 39): relics.gd POOL entries carry tier
(common|rare — 17/8) + "hooks" dict; ALL effects flow through the
19-hook vocabulary AUDITED ATOP relics.gd (each hook read at exactly
one site). Aggregation: Relics.hook_add/hook_dict over
Run.active_relics via Run.relic_add/relic_dict — scalars SUM, dicts
merge per key. Sites: new_run (start_gold/points/items), battle hero
spawn relic block (OUTSIDE the Run.active gate so DOD_SIM_RELICS
loadouts work standalone; attack→dmg_bonus, types→type_dmg_bonus,
max_hp→max_hp_pct stacks with Vitality, armor/speed/crit/con/resists,
resource_floor AFTER member-mana sync), victory block (heal/mana/
gold), award_gold (gold_find_mult), map rest (rest_heal_add), shop
_price() (discount, min 1g), elite spoils (loot_extra). WAYSTONE
REBALANCED +1→+3 pts. relic_active() was legacy-kept with no callers until
Batch BJ §1 DELETED it (relic_add/relic_dict are the live doors).
events relic_grant takes {"tier": "..."} (collectors_grave digs a
guaranteed rare). Draft shelf + relics gallery are SCROLLING grids now
(fixed grids overflowed past ~9 relics); rares wear ◆. DECLARED OUT
(plumbing): on-kill/per-turn procs, revive-on-death, enemy auras,
DoT/BD mults. GOTCHA: stormflask (resource_floor) is a NO-OP in
standalone sims — heroes spawn full there; only real runs carry mana.
Loadout spread 40×4: offense −16% rounds, defense −28% deaths, win%
pinned 100% (attrition declined → ceiling; variance = secondary
metrics). Scratchpad test_relics.gd.
EVENT NODES (07-26, Batch 38): deck now 17 fight/5 rest/5 shop/3 event
("???" violet, map click → Events.pick(Run) → seen_events append →
event.tscn; drawn AT THE DOOR, never pre-rolled). data/events.json +
scripts/events.gd (class_name Events; RUN OBJECT INJECTED into every
static — never reads autoloads, so --script tests drive a bare
run_state). VOCABULARY (the extensible core): 12 verbs (gold/gold_pct/
heal_pct/damage_pct floors at 1hp — events NEVER kill/mana_pct/
max_hp_pct floor 10/attack_pct → member.event_attack_pct read at
battle spawn hero block/talent_points/item/random_item/revive_pct/
relic_grant → active_relics if <3 else +40g), targets party|random|
lowest_hp|class:<key> (living only), requires min_gold/max_gold/
zone_slot/has_item/spec_in_party/fallen_hero (event-level filters the
draw, choice-level greys the button w/ tooltip). Weighted
non-repeating: seen filter drops only on exhaustion. SAVE v2:
+seen_events (+zone_draw); load tolerant of v1 via .get defaults.
pending_event NOT saved (quit mid-event forfeits, node stays spent).
16 events (3 zone-gated via zone_slot, 2 spec-gated, fallen_cairn
needs a dead hero). Scratchpad: test_events.gd (schema+clamps+draws)
+ test_event_flow.gd (map→???→choice→outcome→map). Sim 40/40 flat
(events touch no combat). ROADMAP NOTE: user declined roadmap Batch 1
(attrition/wounds) — never implement it; roadmap batches 2-6 = game
batches 34-38; batch 7 (relics 5→25, tier common/rare for
relic_grant pools) + 8 (persistent unlocks) remain.
ZONE ROTATION (07-26, Batch 37): run = SLOT_COUNT(3) slots, each draws
a zone id from SLOT_POOLS (authored PER SLOT — openers are not
finales). Run.ZONE_DEFS: id → {name (art/save key), boss kind,
rosters: {slot: roster_id}} — forest is {1:1, 3:3}, scarlands {2:2}.
The old ZONES const is GONE; enemies.json "zones" tags = ROSTER ids
(Enemies.kinds_for_roster — kinds_for_zone renamed);
Run.active_roster()/boss_kind()/next_zone_name()/current_zone_id() are
the accessors (battle boss branch + victory descend-button use them).
zone_draw persists in the save (missing key = pre-rotation → fixed
order rebuild). DOD_ZONE_ROTATION=1 randomizes draws within pools;
default = fixed first-candidate order (identical while pools hold one
candidate each). 11-TIER INVARIANT: talent economy assumes 3×11 tiers
— a zone with a different tier count forces a cost-curve revisit.
Adding a zone = ZONE_DEFS + SLOT_POOLS + roster tags + bg-art keys
(battle.gd + map_screen.gd dicts). DOD_SIM_ZONE env = roster id.
Scratchpad test_rotation.gd covers order/save/legacy/pool-membership.
SCALING REBASE (07-26, Batch 36): enemy stats are ZONE-LOCAL —
battle.gd spawn block does base × Run.zone_base_mult(zone_idx+1) ×
(1 + rate × zone_tier), zone_tier = clampi(floor_idx+1, 1, 11), rates
HALVED by Batch T (+2% Atk / +2.5% HP, HP ceil to 10s). ZONE_BASE_MULTS [1.0,
1.5, 2.2] keyed by SLOT (Forest is 1.0 as opener, 2.2 as finale);
slots past 3 auto-continue ×1.5 geometric — never touch the formula
for new zones. Standalone sims stay unscaled (zone_tier 0). Old→new
at entries: z2 ×1.55→1.58 HP / ×1.44→1.56 Atk, z3 ×2.10→2.31 /
×1.88→2.29; zone ENDS run much hotter by design (z3 boss ×3.41/×3.17).
ASH TYRANT KIT v2 (chief clone GONE): Cinder Cleave 0-cost fire +15
Rage / Immolating Wave 30R aoe fire burn 80% 2t / Tyrant's Verdict 20R
44% fire + sunder 70% 2t. Warden's z3 reprise stays BY DESIGN. Zone
roster audit: all 3 pools distinct, every theme satisfiable across its
full budget band in every zone (scratchpad test_zone_rosters.gd).
RESISTS & VULNERABILITIES EVERYWHERE (07-26, Batch 35, roguelike push
II): every kind in enemies.json now carries resists AND vulns as
NEGATIVE RESISTS — the "weak" arrays are GONE from the data (unit.gd
still folds config "weak" for compat; don't reintroduce them). New
vulns: whelp nat+shad, slinger/archer frost, shieldmaster+chief arcane,
totemist/shaman/brute shadow, wolfrider+hexer nature; shieldmaster
gains phys 0.15. WARDEN AUDITED: nature 0.75→0.5 + fire -0.25 (the
Survivalist poison lane is dampened-not-dead; pyro = boss counter).
BURN TICKS ARE FIRE-TYPED at the DoT site (mirrors poison's nature
block; "(resisted)"/"(WEAK!)" tags). MAPS PRE-ROLL WARBANDS at
_generate_map (node["enemies"]+["theme"], compose(type, f+1) via
battle_budget(tier)); map click uses stored warband (fallback composes
for old saves); node hover = _warband_tooltip (theme, lineup,
"Resists: Nature x3 / Soft to: Fire x2" — resist counts SKIP entries
< 0.2 so 5-15% physical trims stay off the identity card; vulns always
count). Battle: plate hover + targeting hover = unit.resist_summary()
(exact %s, weak folded; static — elem_weak shreds stay on chips).
Enemies.unit_name/resists_for read raw JSON for the map. SIM MATRIX
HARNESS: DOD_SIM_THEME="Cursed Company" (+DOD_SIM_BUDGET def 6,
DOD_SIM_ZONE def 1) re-rolls that theme via Run.compose_test each sim
battle (push_error + default lineup when nothing fits); report prints
the theme header. Sim dmg attribution now credits DoT ticks by lane
owner (poison→Survivalist, burn→Pyromancer — heroes never DoT each
other), companion hits→pack_master, trap/tripwire/forest bites→their
hero. SIM-HANG GOTCHA — THREE look-alike failure modes; CHECK CPU FIRST,
it splits them: ~1-2% = (1) or (2), 30-50% with a growing log = (3).
(1) REAL await-deadlock: any `await _pick_target`/`_ability_picked`
reachable in autoplay hangs the run forever. Resurrection's
multi-fallen picker did this (bot now takes fallen[0]); the targeting
loop's cancelled-branch basic-attack-fallbacks + push_warning under
autoplay. New modal/picker flows MUST bot-guard their awaits.
(2) macOS USER-IDLE THROTTLE: when the user is away from the keyboard
~10+ min, new headless Godots crawl at banner-only output — IDENTICAL
code passes on retry once the user is active (caffeinate flags did NOT
reliably beat it; Batch 41's "broken" toggle was this, proven by
hunk-by-hunk bisection landing on byte-identical working code).
(3) TEXTSERVER RID EXHAUSTION (found Batch W, FIXED there): _log used
to append to the history RichTextLabel even in sim mode. Nothing can
read it headlessly, and every line allocates TextServer RIDs; a long
verbose battle exhausts the pool, after which EVERY _log call emits an
8-line engine backtrace ("Element limit reached" / 'Parameter "mem" is
null' at _allocate_rid). A 13-minute sweep ran 3+ hours and wrote a
500 MB log while still making forward progress — so it looks like a
hang but is really I/O thrash. _log now skips the panel when `sim`;
if this ever returns, the tell is stderr volume, not a stalled tail.
It surfaced only under DOD_SIM_ROTATE because the never-simulated
specs (Holy/Occultist/Survivalist) log several times more per battle.
DISCRIMINATOR before blaming code: check %CPU and the log's SIZE, then
rerun with DOD_SIM_DEBUG=1 — a deadlock's log tail names a mid-battle
action and reproduces every time; the throttle shows banner-only and
vanishes when retried while the user is active; RID exhaustion spews
engine backtraces with a GDScript frame pointing at _log.
git-stash-vs-HEAD is the definitive code check.
ENEMY ROSTER 6→15 (07-25, Batch 34, roguelike push I): all enemy data
in data/enemies.json → scripts/enemies.gd (class_name Enemies; caches
JSON; config() restores ints — JSON floats break Ability.make's typed
set()! — tint [r,g,b]→Color, "target":"ally"→Ability.Target.ALLY;
AB_INT_KEYS/CFG_INT_KEYS lists). battle._enemy_config = thin wrapper
(only resolves "boss" by zone → withered_warden / ash_tyrant kinds);
the old config match + 6 kit funcs DELETED. Support AI additions:
"Regenerate" (Bog Troll self-heal <50%, reuses healing_wave special).
THEMES ARE ROLE-BASED (run_state): pool keys = roles (skirmisher/
sniper/bulwark/mender/hexer/brute/elite/boss); _theme_combos resolves
roles → Enemies.kinds_for_zone(zone_idx+1) kinds (first pooled role
CLAIMS a multi-tagged kind so caps never double-count), then
_combo_walk over roles + _role_walk over kinds within a role's cap;
_combo_ok mins/majority read role_counts, min_weak = power ≤ 1 (fixed
from "Raiders+Archers"). ENEMY_POWER const GONE → Enemies.power().
Zone filtering LIVE (ashblade z2-only, troll z1/3, behemoth z2/3...).
2 new themes: Monster Den (≥1 brute), Cursed Company (≥2 hexers).
Swarm min_units stays 3 (4 made budget-3 unsatisfiable). 9 new kinds:
whelp/slinger/totemist (1), hexer/wolfrider/ashblade (2), brute/
bog_troll/behemoth (3 — the power-gap fillers). RULE UNCHANGED: every
enemy's FIRST ability is 0-cost (enemy AI crashes otherwise). Combo
metric: 364 → 11,344 distinct warbands (test_combos.gd in scratchpad
asserts satisfiability + MAX_FIELD). Art limit: all kinds tint the orc
sheet — per-kind art is the known next feel win. Sim 40/40.
SURVIVALIST REBUILD (07-25, Batch 33; spec id stays "mystic" — NEVER
rename it, saves/trees key on it): archetype Pressure. TRAPPER v2:
poison-on-strike clause unchanged; +8% dmg per DIFFERENT status on the
target via _status_count (counts unit.DEBUFF_IDS minus "broken" —
snared/caught added to the list). Force of Nature capstone: 0.20/status
for ALL heroes (checked via _living_hero_with("force_of_nature") —
generic field scanner using Node.get). Vulture +30% at ≥3. Necrosis:
poisoned ENEMIES take +20% from all sources (hero strike site +
_companion_hit; enemy-on-hero excluded). ALL his poison flows through
_apply_poison(src, victim, turns): tick = 3% src Atk + potent_ranks;
slow_acting halves tick/doubles turns/sticky; epidemic → turns -1 +
sticky; virulence_ranks extra applications; sticky flag checked in
unit.purge_debuffs + dispel (Slow Acting/Epidemic uncleansable).
_hit_and_run: applying statuses → self elusive 1t (elusive WORKS on
heroes — no new code needed). TRAPS: "snared" status (power = placer
hero idx, perfect flag on the status dict) + hero.deadfall_armed (DF#
chip); both spring at the victim's turn start BEFORE the stunned check
(_spring_trap: cruel_ranks dmg mult, quick_rigging cripple,
bone_breaker 30 BD, caught_fast "caught" status → unit.heal_amount
returns 0). Trap cap gate in _ability_usable (1, or 2 w/
deadfall_network). Deadfall = untargeted (first enemy to act; 35% Atk).
KIT: Tripwire + Shrapnel v2 (nature; poison+cripple both targets,
perfect +slowed/4t via post-strike block iterating [target,
second_target, third_target] — strike_targets is OUT OF SCOPE there!)
+ Snare Trap. POOL (Classes.survivalist_pool_ability; GOTCHA: match→
return branches must NOT end '}),'— array-style commas break parse):
Explosive Shot (nature, poisons), Venom Coating ("venom_coat" status →
poison every hit), Hamstring (slow+exposed extras + status_plus
perfect), Deadfall, Harvest (special: _status_count × 12% Atk +
self-heal ×1.5 perfect; purge first — sticky poison survives the purge
but was counted, known quirk). Tripwire site v2: ranged gate bypassed
by snap_shut/whole_forest, ret += 0.10×wire_ranks×Atk, ×cruel,
+bone/caught riders, _on_enemy_death on kills. The Whole Forest:
tripwire turns -1 at cast + _forest_bite(enemy) after enemy SUPPORT
casts (attacks covered by the retal block). Epidemic: _run_battle
start, _apply_poison(-1) all enemies. Turn-start upkeep block (after
spirit_mana): plague_bearer (3 stacks leap, tick copied from source
status) + field_medic (dispel_one_debuff on random debuffed ally).
Ghillie: enemy-target re-pick (40%) after Savage Presence. Improvised:
cd-skip chain at the deduct site (was_snap → improvised → rapid_fire →
start_cooldown). Scavenger + creeping_death live in _on_enemy_death.
Bot: snare → venom coat → hamstring → harvest ≥4 statuses → deadfall
(uses _ability_usable for trap gates). ONE SHOT TUNED: 35% + never
bosses (is_boss check; elites fine). SIM: 39/40, Survivalist 24%.
SHARPSHOOTER REBUILD (07-25, Batch 32): archetype NUKER. FOCUS = second
resource 0-100 (green; spawn block sets it AFTER talents so cap reads
deep_focus 150 / spray 50 / else 100 via _focus_cap; opening_volley
starts 60). Engine _sharpshooter_focus runs post-single-target-attack:
same target as last_attack_target → +20+10×muscle_memory (_gain_focus
clamps to cap); switch → 0 (half w/ unwavering); kill → mini(f,50) +
last_target null (no reset next shot). Crit: +0.005×focus in the crit
block (lethal_aim gate) + tunnel_vision ±0.5 keyed to last_attack_target.
Crit MULT site: lethal_aim = 2.0 + 0.1×lethal_eye_ranks, or 1.5 w/
consistent_aim (+0.30 crit via payload). AIMED SHOT: the old hidden
is_perfect name-site (+25% crit) REMOVED; perfect_id "focus20" → +20
Focus. POWERSHOT INVERTED: ×(1 + step×pressure/stability), step 4 w/
opp_aim. HOLD BREATH ("hold_breath" special, self-cast list): +40 Focus
+ "held_breath" status power=1 (2 w/ second_nature) → is_crit forced +
effective_armor 0 (same guard covers through_and_through + one_shot
exec); consumed post-strike-block by power. ONE SHOT capstone: Aimed at
focus ≥ cap → <40% hp: one_shot_exec local → final = max(hp, final) +
armor 0; else raw ×2; focus 0 either way. On-crit riders (strike loop
after take_hit): perfect_form +20 Focus, sundering_shot take_hit(0,15),
exposed_nerve exposed 3t, follow_through cooldowns −1 all,
through_and_through refunds ab.cost. OVERKILL: hp_before captured; died
→ excess to _lowest_hp other (full death handling + _on_enemy_death).
SPRAY: post-strike echo 50% (0.005×damage×attack) to random other;
focus cap 50. NO COVER: _miss_chance returns 0.0 EARLY for attacker
(bypass, not modifier). SNAP SHOT: _eff_cost 0 for first costed ability
+ was_snap at the deduct site skips start_cooldown; RAPID FIRE: 35%
skip at the same site. Called Shot: called_mode var + _open_called_
picker (3 buttons) intercepting _on_ability_button (bot sets mode
directly: sunder if armor else exposed); effect at the sharpshooter
post-strike block (sunder 2t / take_hit(0,30) / exposed 3t). Pinning
Shot: applies_status slow + name-keyed dazed 3t. TROPHY POOLS
GENERALIZED: Classes.SPEC_POOLS + spec_pool/spec_pool_ability
(sharpshooter ships 5 of 8: Quick Draw demoted, Triple Shot multi_hits
2, Coup [raw += missing×0.01×focus, drains], Pinning, Called; Disengage
/Suppressing Fire/Piercing Arrow later). Boss owed + party picker +
spawn grants all read the spec pool now (member keys still bm_*).
TREE = FIRST NODE-GATED LANES ("node_gated": true on the tree's first
node; is_node_gated + lane_nodes_bought; NODE_TIER_REQ {0,2,4},
NODE_CAPSTONE_REQ 6 — points-gated trees unchanged). Lanes Precision/
Penetration/Tempo per the design doc; exclusives were authored as
ss_exec_eye/ss_consistent and ss_tunnel/ss_spray — **THE FIRST PAIR IS
DISSOLVED (Batch AZ §4)**: Batch AI's row exclusivity destroyed it, since
both sit in Precision rows 4 and 5, so a player holds both and AZ reworded
Consistent Aim to −0.5 so they compose (x2.0 together). **THE SECOND
SURVIVES UNTOUCHED** because both sit in ROW 7 and row exclusivity enforces
it correctly — do not "fix" it. Bot (PRE-AZ, see the AZ block):
Hold Breath → Coup ≥80 focus & <60% hp → Triple ≥60 → Called → Aimed;
9th kit entry renders unlabeled (popup guard existed). SIM NOTE
SUPERSEDED (Batch W): the "sharpshooter leads damage 38%" flag was a
STALE number from the old fixed party, measured before Batches D-Q
rebuilt half the roster. Re-measured across all twelve specs he is
32-36% — mid-pack, not the worst outlier. Never tune against it.
ALL TREES ON LANES + ZONE 3 (07-25, Batch 31): Talents.LANE_CONVERSIONS
converts the 9 classic trees AT BUILD TIME in generate_tree — existing
node ids/payloads untouched ("map" id→[lane,tier(,"cap")(,excl)]),
~10 invented fillers + 2 invented capstones per spec appended ("new";
dials + ability tweaks on EXISTING machinery only — flagged for design
review). One exclusive pair per tree. Party screen derives lane order/
names from the tree (_tree_lanes; LANE_NAMES.get fallback prints the
key, so converted lanes use display-string keys) and sorts nodes by
tier (decorated stable sort). Audit script (scratchpad test_talents.gd)
checks 24/3/7-7-7 per spec. TESTING AID (Batch 41, relocated next
day per user: Run.debug_grant_all, DEFAULT OFF, session-scoped never
saved — MAP BURGER check "All Spec Abilities Unlocked" id 16, or
DOD_SIM_GRANT_ALL=1) pre-grants every new_ability/grant_ability node
+ the spec pools at spawn (dedupe by display_name here AND in
apply_payload). Toggle lives on the MAP (not battle — grants land at
spawn, so a mid-battle flip could never apply). ZONE 3 = "Forest of Old" repeat (ZONES third entry;
battle bg/map art key off zone_name → free; boss cfg zone check is
`zone_idx in [0, 2]` → Withered Warden rules both forests, Scarlands
keeps the Chief stand-in). FINAL BOSS = zone 3's Warden:
award_talent_points boss branch → 0 when not has_next_zone (victory
text: "the final relic is claimed"). GOTCHA re-hit: `:=` off
Ability.make fails inference (make is untyped) — annotate `: Ability`.
FIX: dv_communion payload restored to communion_ranks (the B29 rename
script had rewired the Devout onto the beastmaster's field).
TALENT OVERHAUL (07-25, Batch 30): economy 1/2/3 (fight/elite/boss,
run_state.award_talent_points; final-boss-no-points rule documented but
unattachable until a final boss exists). LANE FRAMEWORK pilot =
beastmaster (others stay row-gated flat-cost): Talents.LANE_TREES
(nodes carry lane/tier/capstone/exclusive_with/locked_note),
LANE_TIER_REQ {0,3,6}, CAPSTONE_REQ 8-in-lane + only-one-capstone,
node pricing ceil(N/3) via next_node_cost/node_cost (ranks always 1),
lane_points reconstructs per-node prices from member["talent_order"]
(party_screen appends on first rank; definition-order fallback),
can_learn(tree,id,learned,order) lane branch (locked_note = The Pack
"Coming soon."). 13-assertion headless test in scratchpad passed.
Party screen: _draw_lane_tree (LANE_COL_X/ROW_Y consts, capstone
shelf, live lane-pts headers), _make_tree_node node_size param,
cost-aware _learn_talent + tooltips, _draw_bm_pick trophy chooser
(bm_picks_owed → bm_abilities on the member; battle spawn appends via
Classes.beastmaster_pool_ability; boss victory sets owed).
BEASTMASTER KIT v5: base = summons + Hunter's Instinct + Kill Command.
BOSS-TROPHY POOL (Classes.BEASTMASTER_POOL, 1 pick/zone boss): Bestial
Wrath + Spirit Bond (demoted) + Primal Surge ("primal_surge" special —
NOT "surge", that id belongs to the old +20% buff! spends loyalty,
status 1t/stack, perfect keeps stacks) + Call of the Wild ("call_wild",
rides the summon picker + menu group filter; _ghost_hit spirits +
_arrival_for_kind(hunter,kind,body,target) refactor, body=null skips
self-buffs, taunt falls to active beast else hunter) + Mark of the Hunt
("hunt_mark" status power=hunter idx; +25% hunter/beast sites; 3% mana
per strike; _on_enemy_death resets its cd). DOD_SIM_ABILITIES now also
feeds beastmaster pool names. Node hooks: _bond_mult(hunter,kind)
centralizes boon tiers (1/2/3=Ancient Pact, 0.5=Menagerie via
kinds_summoned, Vengeance carries vengeance_kind while status lasts) —
ursus DR + attraction, canis wounded-bond, aguila _party_crit_bonus
(chip keen_eyes reads it too). _loyalty_cap (5+bonus/7/8 lone/2 wild
rotation; boon threshold FIXED at 5). _comp_dmg_mult = loyalty step
(wild_communion_ranks — NOT communion_ranks, that's the Devout's!) ×
bestial × momentum(kinds_summoned). _on_beast_death (steadfast half /
vengeance status+kind / no_beast_left free_summon → _eff_cost 0 +
ready bypass; _eff_cost also lone_hunter ×0.6). One Soul: unit.take_hit
splits via soul_partner + _soul_guard (proc-logged); Ancient Pact:
unit.no_heals rejects ALL healing. Unbroken Watch reads
damaged_since_turn (set in take_hit, cleared at hunter turn start).
Herald widens arrivals (2 taunts / 2 dives / double howl on bloodiest).
Apex: extra co-strike on Quick Shot + KC erase in _on_enemy_death.
Lone Bond: loyalty floor 3 at summon (skips arrival gain), summon gate
once beast_committed (Batch AG — it read kinds_summoned, which Call of
the Wild also writes, and that locked out every summon). Master's Aim/Instinctive/Deep Reserves/
Devoted Fury/Beast Within (companion_hp_pct — % of base; flat
companion_hp_bonus rides on top) wired at their ability sites.
BEASTMASTER v3 LOYALTY (07-24, Batch 28; replaces Ferocity/Frenzy/Wild
Call/Quarry — all machinery REMOVED): archetype RAMP. ALL HUNTERS ON
MANA (class cfg resource_name; +12/turn shared branch; Quick Shot
perfect_id "mana"; party_screen Focus tooltip dropped). LOYALTY = dict
on the HUNTER (unit.loyalty kind→0-5, chip "L#" stamped on the beast
via _stamp_loyalty_chip): +1 at hunter turn start w/ beast active
(companion-tick block) + on summon/swap (_do_summon); reset in the
strike-loop death site (is_companion → pack_master.loyalty[kind]=0).
Per stack: ×(1+.05L) in _companion_strike; gifts — ursus +3% base HP
(live in _gain_loyalty + re-applied at spawn), canis bleed 20+2L
(always, ×2 boosted), aguila pen 0.20L (pen param on _companion_hit).
At 5: bond doubles. Bonds: ursus Savage Presence (enemy-pick redirect
15/30% in _enemy_turn else-branch + hunter ×0.90/0.80 target-side),
canis hunter ×(1+0.15/0.30 per enemy <35%) attacker-side, aguila party
crit +10/20% (_living_aguila; attacker.is_hero not companion). Arrival
effects (_arrival_effect, fires on summon AND swap): ursus Guardian's
Roar (taunt lowest-HP un-mocked — MOCKED POWER ≥100 ENCODES COMPANION
TAUNTS as 100+hunter_idx, decoded in _enemy_turn — + "roar" 0.75
target-side 2t), canis Bloodhowl 15 bleed ALL, aguila dive 15% Atk +
dazed 2t (needs target: summon targeting branch exempts *Aguila from
the self-cast list; bot passes u → fallback lowest-HP). SWAP: picker
builds "Swap X" CLONES (10 Mana, delay 1.0, cooldown 0) when companion
alive; shared cd = cooldowns["Swap Companion"]=3 set in _do_summon on
was_swap; gates in _ability_usable (begins_with "Swap": shared cd +
not-active-kind). Kit v4 (07-25, Batch 29; Marking Shot + Feral Mending REMOVED —
_spirit_strike deleted): summons 20 Mana/3cd (ursus 110hp target+
_adjacent_enemies 10%; canis 80hp 20%+20bleed; aguila 80hp 20%+exposed
2t/4t boosted). BLIND keyword: +50% miss, in DEBUFF_IDS;
_miss_chance(attacker, defender) — defender param also carries
ELUSIVENESS (canis/aguila permanent "elusive" chip stamped in
_do_summon: +25% miss against them); both _resolve miss sites pass the
defender. KC modal on companion_kind (kc_mult = loyalty × 
_bestial_dmg_mult): ursus 45%+40BD; canis 3×18% bites +(10+2L+10bestial)
bleed each + feast 30% self-heal; aguila TWO targets 25% + blind 3t
(kc_two flag in the targeting flow reuses the choose_two picker; bot
falls back to _lowest_hp other). Hunter's Instinct "instinct" special
(no_skill_check): status power=3 chip HI#; Quick Shot raw += 0.10*Atk
(perfect-override block) + post-strike heal 15% comp max & decrement
(before the co-strike site). Bestial Wrath "bestial" special
(no_skill_check, 3t): ursus max_hp×2 + armor×1.5 (bestial_hp/
armor_bonus fields, reverted in the companion-tick block when the
status drops) + taunts 3 random (mocked 100+idx); canis ×1.5 dmg +10
bleed; aguila ×1.25 + blind 2t on strikes (_bestial_dmg_mult feeds
_companion_strike AND KC). Spirit Bond "spirit_bond": both heal 25%
own-max + "spirit_heal" 1t (power = 10% own max; hero side processed
in the pre-tick turn-start block, companion side pre-tick in the
companion block) + mana 15% now + "spirit_mana" 2t (5%/turn); perfect
"vigor" 5t = +10% max HP via vigor_hp_bonus (reverted post-tick both
sides). Gates: kill_command/bestial/spirit_bond need living companion.
Bot: spirit bond when hurt → bestial → KC → instinct. CHIP FIXES:
loyalty chip spells the gift + "PACK BOND BOON DOUBLED" at 5;
"keen_eyes" party chip maintained in _update_talent_chips while
_living_aguila (+10/20%). FIX 12-mana start: run_state HERO_BASE
hunter mana 0→100 (old saves keep the low value until a new run).
Talent points: award_talent_points 2/4/4 (fight/elite/boss) — SUPERSEDED
by Batch 30's 1/2/3 (final boss 0); the live code has never been 2/4/4
since. (Stale line found + flagged by Batch Z's glossary pass.)
Resurrection faith_cost 3→1. Shadowrend 50→25%.
HOLY MERCY REWORK (07-22): FAITH IS GONE from all clerics (no second
resource except Holy; the +10/action build site removed; ability
faith_cost now = generic secondary cost). MIRACLE keyword retired. Core
cleric = Smite only (Mend Wounds VAULTED; Resurrection now a Holy
talent ability). Unity 25 Mana, Umbral Sigil 20 Mana. HEALING RULE:
ability heals scale off the CASTER'S MAX HEALTH (Smite/Shadowrend
perfect = 5% max HP; "self_heal" perfect handler). MERCY (Holy only,
0-5, gold bar): +1 on any party member crossing below 50% HP
(unit.below_half_cb → battle._on_hero_below_half; fires from take_hit
AND take_tick_damage, companions excluded); +5% healing done per stack
HELD (_healing_done_mult — costs deduct BEFORE specials resolve);
spenders via faith_cost (Hymn 1, Divine Plea 2, Resurrection 3).
EMPOWER: battle.empower_armed (✦ toggle on action bar + hotkey C, reset
each turn; bot sets it in the cleric policy) → _consume_empower in
_resolve_special pays +1 stack and FORCES is_perfect=false. Kit: Heal
("holy_heal" special, 40% caster HP, empower cleanses via
unit.purge_debuffs — never strips "broken"), Renewal (tick = 15% caster
HP snapshotted Mercy-scaled into status tick field; turn-start site
reads it; empower also blankets caster), Hymn ("hymn", 20/35emp/25perf %
of each TARGET's max HP), Resurrection (20/25perf/100emp % + renewal on
empower), Divine Plea ("divine_plea", full heal; empower = purge +
"sanctified" 3t — _apply_status guard bounces ALL DEBUFF_IDS while
sanctified). Status expiry now logs "fades from" (unit.tick_statuses);
STUNNED/FROZEN lost turns tick statuses+cooldowns (fix 07-22). Arcanist
tuning (07-22): Resonance dmg-taken +5%/stack (was 10); Overcharge
recoil surcharges REMOVED (weighting = passive trio only).
OCCULTIST OLD GODS REWORK + TREE (07-24, 9th tree): passive "corrupt"
→ "old_gods". RUIN = enemy-side stacks (status "ruin", chip "R#",
battle-long, NO CAP since AX) gained whenever the Occultist
applies a debuff (generic applies_status site checks passive_id ==
"old_gods"; custom sites call _gain_ruin — Bewitch cast/Dazes, Hex
Decay, Spread, Mirror). Effects gated on _living_occultist(): target
+2%/stack in _resolve (AX: (2+deep_hex_step)%, UNCAPPED); hero
strikes on Ruined targets lifesteal (2+soul_leech_step+gluttony)% PER
STACK of final, minf'd at RUIN_LEECH_CAP 0.40. Every 10th stack (AX;
_ruin_threshold, avatar_ruin installs 5): "ruin_primed" 1t →
_detonate_ruin at the bearer's turn start (BEFORE tick_statuses; 90%
Occ Atk shadow w/ resist via take_tick_damage + party heal 25% Occ
max HP) — AND THE STACKS SURVIVE IT. PSYCHOSIS status: 50%/turn in _enemy_turn — supports
(_psychotic_support matches healing_wave/enemy_shield/wild_growth)
target HEROES, else 0-cost attack (_cheapest_attack) on a fellow;
Spread of Madness rolls first (leap + _gain_ruin; bosses excluded).
DECAY status: 10 BD/turn via take_hit(0,10) at turn start. BEWITCH
status (ex-mindflay, machinery REPLACED): _bewitched_strike = 0-cost
attack on a fellow + dazed 2t + ruin; Murderous Intent heals lowest on
bewitched kills; perfect Bewitch strikes instantly at cast. HYSTERIA
status (-1t, removed when acted, pre-psychosis in _enemy_turn): 0-cost
attack copy w/ pressure×2 + sunder 3t. Kit: Shadowrend 50% + cripple
2t, Hex of Ruin CHOOSE_THREE (new ability flag + third_target +
targeting loop + strike_targets; perfect ERASES its cooldown), Dark
Pact ("dark_pact" special: -20% self HP clamp 1, party-EXCEPT-SELF 15% own-max
heal, self renewal 3t @10%/turn, invig status = mana tick at turn
start), talent-granted Mind Flay (choose_two + psychosis
applies_status w/ status_plus perfect) + Mass Hysteria capstone
(perfect sets cd 4 = 3+tick). UMBRAL SIGIL + old Mind Flay VAULTED
(sigil status machinery kept). Boss mind-magic immunity: stunned/
frozen/psychosis/bewitch/hysteria all resist unless Broken
(_apply_status guard). Talents (ALL ADDITIVE SINCE AX — the counter
holds the magnitude): Corrupted Channeling channeling_ranks (60% of a
Crippled attacker's damage), Pleasure from Pain end-of-_player_turn
(pleasure_pct 2.5% Occ max HP × unique enemy debuffs —
_unique_enemy_debuffs helper; the field is a FLOAT and must never be
renamed back to "_ranks"), Dark Infusion attacker-side,
Broken Will pr-side (replaced the old mindflay pr site), Umbral Mirror
wraps the enemy→hero applies_status branch. GOTCHA RE-HIT: multiline
lambda in filter() args = parse error (collapse to one line).
DEVOUT CONVICTION REWORK + TREE (07-23, 8th tree): passive "devotion"
→ "conviction". FAITH = per-ALLY stacks (unit.faith_stacks 0-5, chip
"F#") gained ONLY when a DIVINE SHIELD barrier absorbs damage for the
holder (barrier status flag "divine" → unit.shield_absorbed_cb →
_gain_faith; doubled under "zeal" status — the ×2 lives in
_gain_faith) — only while a
living Devout stands (_living_devout gate on gain AND on the
per-stack combat effects: target-side −3%/stack, attacker-side
+2%/stack in _resolve; Unwavering Faith is now +5%/rank max HP via
max_hp_pct, 07-23). At 5:
_gain_faith releases — heal (15+5×faithful)% max, reset, Devout +3%
max Mana, Communion rolls (0.20×ranks×THEIR stacks per other member).
Kit: Divine Shield v2 (15 Mana, 30/35% of Devout max HP barrier, 2cd —
_grant_divine_shield stamps riders on the barrier status:
blessed_pct/afterglow; Sacred Covenant via unit.lethal_saved_cb →
_on_lethal_saved when a barrier eats a killing blow; Radient Aegis
echo roll in the special), Consecrated Ground ("cons_ground" party
status: −15% target-side + 10% reflect after the mitigation log),
Blessing of Zeal ("zeal" ALLY status: +15% dmg attacker-side, faith
×2, cooldown −1 on cast). Sacred Resolve = ex-Unity, talent-granted
(special stays "unity"; Healing Pulse/Cleansing Waters snapshotted
onto the unity status as "pulse"/"cleanse", ticked in the turn-start
block). Bulwark of Fortitude capstone ("bulwark" status: pressure_add
= 0 in take_hit, armor ×1.5 in effective_armor, 10% max HP tick at
turn start; perfect instant 5% party heal). DIVINE WRATH VAULTED ("wrath"
status machinery kept). Devoutness talent replaces the aura: devotion
status power-driven (5×ranks%, unit.take_hit reads status_power).
STATUS RENAME: "sanctified" label now "Hallowed" (Consecrated belongs
to Consecrated Ground). Holy Capacitor banks 5%/rank (07-23, was 33).
HOLY TREE (07-22, 7th fixed tree; source JSON was one column right —
normalized): Triage (triage_ranks: _heal_crit_mult ×1.5 rolls on
instant heals — holy_heal/hymn-per-target/renewal burst, NOT renewal
ticks — + flat 3%/rank in _healing_done_mult), Heavenly Aura
(heavenly_ranks deepens the Mercy per-stack term), Holy Light (perfect
casts +1%/rank max Mana — block next to the faith_cost deduction),
Guardian Angel + Last Hope are PARTY-WIDE STAMPS set after spawn
(unit.mercy_threshold 0.5+0.03r used by _check_below_half in take_hit/
take_tick_damage; unit.last_hope_bonus applied receiver-side in
heal_amount when hp<25%), Divine Presence (end of _player_turn drip to
_lowest_hp), Inner Faith (max_hp_pct payload), Holy Capacitor
(unit.last_overheal set by every heal_amount; _bank_overheal chips
"capacitor"; released by the next holy_heal), On the Mend (ranks
SNAPSHOTTED into the renewal status dict field "mend" at every apply
site; rolled at the turn-start tick via unit.dispel_one_debuff),
Sanctified (refund rolls at BOTH spend sites: faith_cost deduction +
_consume_empower). Res/Divine Plea granted via NEW apply_payload branch
{"grant_ability": name} → Classes.pending_talent_ability (single
source with DOD_SIM_ABILITIES). STATUS RENAME: "sanctified" status
label is now "Consecrated" (chip Cn) — the talent owns the Sanctified
name; internal id unchanged.
ENCOUNTERS = POWER BUDGET (07-16): enemy power {raider/archer 1, sm/shaman
2, chief 4, boss 7}; every battle SPENDS ITS BUDGET EXACTLY via themed
warbands (Run.THEMES two-step: theme → fill roles; combos enumerated in
run_state._theme_combos; theme in encounter["theme"], logged at battle
start; field caps at 6 — ENEMY_LAYOUTS has a 6-slot layout). BUDGET IS
A RAMP PER ZONE (Batch T; Run.battle_budget; in-zone tier = floor_idx+1):
fight tiers roll lo..lo+2, lo = 3+floor((tier-1)/2) → t1 3-5 … t10 7-9;
boss tier 11 KEEPS 10-12 (Escort is authored content); compose() floors
ELITE budgets at 6 (cheapest elite theme = Rage Company at 6 in every
roster — below that the node degrades to the plain-mob fallback while
still paying elite rewards); later zones restart the ladder with tougher
rosters. CHIEFS ONLY
IN ELITE FIGHTS (Honor Guard/Rage Company/Elite Patrol are elite-node
themes; Warband pool has no chief). Swarm/Poison Volley only fit low
budgets (by math). ALL HERO ABILITY COOLDOWNS -1 (07-16); ENEMIES HAVE NO
COOLDOWNS AT ALL (kits carry none; AI gates by resources/conditions; the
"bides its time" fallback was removed — every enemy always has a 0-cost
attack, keep it that way or _enemy_turn's pick_random crashes on empty).
Orc Shaman = support: Healing Wave (25% max HP, lowest sub-40% ally,
tank/support enemy_role first) + Chain Lightning; Lightning Bolt VAULTED.
Burn REAPPLICATION extends duration by the APPLIED turns (unit.add_status
burn branch). ADJACENT IS STRICT (07-16): dead neighbor = no bonus on
that side, never jumps past corpses (_adjacent_enemies). Log itemizes
mitigation: "(nature resist -8) (armor -12) (WEAK! +9)".
CRYOMANCER TREE (07-20, 5th fixed tree): Hungering Cold/Frostbite/
Hypothermia/Frigid Grip are PARTY-WIDE talent auras read via
_max_hero_rank(field) (frigid stamps unit.frigid_bonus on victims at
chilled application); Piercing Ice (Ice Lance crit_mult), Icy Veins
(unit.icy_veins_charge armed on lance kills, consumed next lance),
Splintering Shards (extra Razor hit roll in total_hits), Whiteout
(Blizzard daze 2t), Freezing Advance (rime-echo sting), Empowered
Frostbolt (flat % add). Talent abilities: Rime ("rime" special+status,
echo in _apply_status chilled branch, _rime_echoing guard stops chains;
ALSO applies frostbite 2t on cast) and Shatter capstone (aoe filtered to
chilled targets, raw ×stacks, usable gate needs a chilled enemy, perfect
sets cooldowns["Shatter"]=5). FROSTBITE STATUS (07-20): healing received
-50% for 2t (unit.heal_amount mult; heal_amount now RETURNS the final
healed int; healing_wave/wild_growth display it + log "halved by
Frostbite"); in DEBUFF_IDS; applied by Rime cast + permafrost on-hit.
Row-1 talent renamed "Brittle Ice" (id stays cr_frostbite/frostbite_ranks
— saves keep ranks). Passive "permafrost": frozen targets take +15% from
all sources (target-side in _resolve) AND frost hits 25% chance to
frostbite (on-hit passives block in _resolve). Razor Ice v3: 2 random
@20%, always chills, perfect flat 25%. Blizzard 15% Atk (07-20).
Ice Lance 35% Atk (07-20) +5% of Atk per Chilled stack (Batch W
halved it from Batch O's +10%; Crystal Edge still +5%/rank on top).
ARCANIST REWORK + TREE (07-20, 6th fixed tree): core Magic Bolt →
Arcane Explosion via apply_kit_overrides (free, 10% × 2 DISTINCT random
enemies — struck_before filter in the random-hit picker — 10BD, no
perfect). Kit: Cannon (25M, 40%, BD=5×stacks computed in the pr calc,
2cd, perfect eff_delay 3.0), Barrage (20M, 8%×6 bolts @ pool of 3
lowest-HP enemies, 3BD, 2.5, perfect 7th), Stabilize special (free,
3cd, consumes ALL stacks → +5 Mana/stack + "stabilized" chip 10%/stack
DR 2t target-side in _resolve; usable gate ≥1 stack; perfect heals 5%
max HP). DEATH RAY VAULTED ("mana15" perfect machinery kept). Talent
abilities: Overcharge special (unit.overcharged + overcharge_mult
1.5/1.65 perfect, second_max=8, once-per-battle gate; Cannon/Barrage
+15% recoil in the recoil block) and Magi's Wrath capstone (aoe 15%,
+4%/stack, BD 2.5×stacks, recoil 15%−3% per enemies_struck, perfect
eff_delay 3.5). _resonance_power(u) weights stacks 6-8 — used by
dmg/crit/dmg-taken + tooltip buff_mult + plate readout; Backlash Ward
fires at the dynamic max. Talents: Mindfulness (extra cooldown tick
every 7−ranks turns, turn-start block), Arcane Mastery (+1%/rank
crit/stack), Mana Attunement + Unlimited Power (both inside
_gain_resonance — overflow branch returns early), Temporal Rift (crit
echo after the sigil block), On the Edge (post-take_hit in the strike
loop, threshold (20+5r)% — RISES with ranks, user-corrected 07-20),
Conversion + Stable Alignment (unit.take_hit — cap (40−5r)% max HP),
Critical Mass (crit_streak in the crit branch),
Suppressing Fire (Barrage ramp in raw calc). Talents.desc_for renders 2
decimals now (0.25 steps). Bot mage rotation: Wrath ≥3 foes/≥3 stacks →
Overcharge ≥4 stacks → Stabilize at max stacks under 70% HP → Cannon ≥2
stacks → Barrage. DEBUG: "Cooldowns OFF" CHECK
toggle (debug_cooldowns_off — start_cooldown skipped while on; replaces
the old reset command).
CRYOMANCER REWORK (07-18): archetype CONTROL (new, Damage role/100 Atk,
ARCHETYPE_ROLE+DESC). CHILLED = STACKING debuff (max 4, unit.add_status
chilled branch + _chilled_desc; reapplication RESETS the 3-turn clock;
chip "C#"): x1 -25% speed, x2 -50% (effective_speed), x3 also -15% dmg
dealt (attacker-side in _resolve); 4 stacks → FROZEN in _apply_status
(stacks reset, frozen = lose next turn like stunned — own block in
_run_battle; bosses resist unless Broken; unit.was_frozen marks it).
Passive "shattering" (replaces "chill" on-hit, which is GONE): +2% crit
per enemy was_frozen this battle (live spec chip). Kit: core → Frostbolt
via apply_kit_overrides (free, 20% Atk frost, 1 chilled stack, perfect
flat 25%); Razor Ice v2 (3 random, +3%/chilled stack, perfect chills
unchilled); Blizzard v2 (aoe, 1-2 stacks each, perfect_id "mana5");
Ice Lance (auto-crit vs frozen, perfect pr=20). Old Frost Bolt VAULTED.
PYROMANCER REWORK (07-16 — **HISTORY ONLY, SUPERSEDED TWICE OVER**: Batch AG
reworked the passive and Wildfire, and BATCH AR replaced the passive outright
with OVERBURN, re-specced Flame Shield into Immolate and re-authored all 24
tree nodes. READ THE AR BLOCK, not this one; nothing below describes live
code except the Fireball override and the Flamewave/Detonation shapes):
passive "inferno" =
Inferno Master (+5% dmg per burning enemy, cap 25%; live spec chip via _update_talent_chips; the
old "ignite" on-hit passive is GONE). Core Magic Bolt → Fireball via
apply_kit_overrides (free, 20% Atk fire, 15BD, burn 3t; perfect = flat
25% Atk in _resolve). Kit: Detonation (consumes target burn pre-mitigation
for tick×turns bonus, perfect re-burns 1t), Wildfire (spreads target burn
to Adjacent at half duration rounded up — captured PRE-hit so kills still
spread), Flamewave (aoe; burning targets +2t, perfect +3t via
update_status). VAULTED: Pyroblast, Flame Surge, Phoenix Rebirth, and
Mana Shield from ALL mage specs (mage core = Magic Bolt only; specials
"phoenix"/"mana_shield" machinery kept for the vault). Resurrection
5cd. Autoplay mage policy = burn loop (Flamewave ≥2 burning / Detonation
≥3 turns / Wildfire) then the Arcanist rotation (see the 07-20 ARCANIST
block above) / Barrage / basic.
ATTACK & SCALING (07-16): every unit has an Attack stat; ability `damage`
is a PERCENT of the user's current Attack. Role bases: Damage 100 / Tank 75
/ Support 50 (Classes.spec_attack; Bruiser = Damage role; per-spec stat
blocks + "resists" dicts land class by class — spec_resists, 0% now, shown
via stat-page "Resistances" hover). Heroes: +2% of base Atk/HP per combat
win (Run.combat_wins, saved); enemies: +2% Atk / +2.5% HP of base per
zone-local tier (Batch 36 zone rebase, rates halved Batch T), HP rounded
UP to 10s.
Armor/resists/speed/con/crit/block/parry NEVER scale. DoTs (burn 6%,
poison 3%/stack) snapshot the applier's Attack ("tick" on the status);
companions hit for % of the hunter's Attack. Cleric core Smite = 44% (of
50 Atk); Warden Mocking 27%/Crushing 43%/War Stomp 15%x3 (75 Atk);
Shieldmaster Strike 37% (75); Shaman 70%/30% (50) + fire/frost 25%,
nature 50% resists. PARRY IS MELEE-ONLY (attacker.is_ranged — hunter+mage
ranged among heroes); parries and blocks log their SOURCE (reflexes/Sword
Mastery/Parry Up; Interpose/Heavy Plating/base Block — Warden Tenacity
+5 maxHP battle-long (tenacity_hp_gained excluded from save sync) and
Rally (party rally_heal +15% healing 2t) proc on HEAVY PLATING blocks
only). Warden tree v2 (07-16 JSON): Endurance 1%/rank. Talent tooltips:
desc "{v}" + "scale" {base, step} → Talents.desc_for renders invested
value (never "per rank"). Saved runs swap tree snapshots for live defs on
load (refunds orphans). War Stomp: allies regain 10% resource post-cast.
Class passive NOT on draft cards (awakening screen + party sheet only).

## Older snapshot (2026-07-10)
4 heroes (Warrior/Mage/Cleric/Hunter — one of each), 3 specs each, per-run
shuffled talent trees, damage types (7) with resists + Weaknesses (config
"weak": [types] = +25% damage taken, "WEAK!" feedback; assignments TBD),
bleed buildup (100 = 20% max HP bleedout, ignores armor; poison ticks count
as nature damage),
gold + shop runes (rarity-generated, 2 equip slots), 2 zones (Forest →
Scarlands). Basic orcs: Raider, red Archer (poison), orange Shieldmaster
(single-ally 25% ward), blue Shaman (nature caster, party-wide Chain
Lightning); Chief = elite; Withered Warden has a unique boss kit (Timber Slam
+ Dazed / Roots of Wrath / Wild Growth, 75% nature resist). Every encounter =
3-5 random-typed foes (elite/boss nodes: Chief/boss + 2-4 basics). Relics
meta layer. Map: 10 tiers × 3 nodes + boss; fixed 18 fight / 6 rest / 6 shop;
links = own column + 70% one adjacent (never all 3). Elites drop rune + item +
80-100 gold. Music autoload (menu/map/battle + boss intro; spec choice = menu
track, boss tune plays on spec-confirm fade to map), zone battle art, bow SFX,
full-scene 1:1 battle camera (sprites 3.2/3.9/4.4). Specs overhauled 07-08:
Swordmaster Seasoned Fighter + Pommel Strike, Devout (ex-Inquisitor) Unity,
Occultist Mind Flay, Beastmaster summonable companions (sphere placeholders,
no timeline turns, "Summon Companion ▸" submenu), Survivalist Trapper +
stacking Poison (3/turn/stack), Chilled = renamed Slow. Break meter 0-100 w/
numeric readout; CONSTITUTION = break resistance (pressure × 100/con; per-spec
values in SPEC_INFO, bosses 160 + stun-immune unless Broken). Talent pools are
THEMATIC per spec (8 signatures each, T5 = new ability). See master.html §6-7.
Combat: crit 10%; miss 5% (Dazed +20%); parry 5% heroes / 2.5% enemies —
a PARRIED hit lands at 25% damage + 25% BD, no auto-counter ("Counter
Attack" = parry-answer basic; Riposte talent grants it); BLOCK = full
negation (block_chance stat: Warden 5% + Heavy Plating 15%, Shieldmaster
5%; Warden Shieldwall +25% for 2t; Interpose charges guarantee); COOLDOWNS on all abilities (unit.
cooldowns, ability_ready; enemies + bot respect them); Armor Pen keyword;
Buff/Debuff keyword (DEBUFF_IDS in unit.gd); ADJACENT keyword = nearest
living enemy each side of the target in formation order (_adjacent_enemies;
Sundering splashes only there). TALENT VISIBILITY (07-16): procs log as
"Talent: ..." lines (log_proc hook on units for unit-side procs); stateful
talent buffs are chips w/ live counters (Enraged/Unrelenting 3-turn con/
Endurance/Iron Will/Crushing Blows/Battle Shout/Shieldwall +25%/Interpose IP#/Elemental
Weakness -x%) via unit.update_status + battle._update_talent_chips; buff
casts (shield_block/hold_the_line/battle_shout) are self-cast, no target.
CLASS PASSIVES (all specs): Warrior targeted 1.2x, Cleric +15% heals
received, Hunter acts first, Mage +10 mana/turn — shown on draft cards,
the awakening screen, and the party sheet (sheet stats mirror battle math:
spec constitution + Toughness, stance-aware passive text). Mocking Blow taunt; ability hotkeys by MENU slot; Tab/Space/
X/Alt controls; Space continues victory screens. TALENT TREES ARE FIXED-
ONLY (berserker/swordmaster/warden/pyromancer 12-node grids, row gating
5/10/15 + prereqs, talents.gd; others "coming soon"). Talent ranks
ADDITIVE. PYROMANCER TREE (07-18): Accelerant (+1%/rank burn tick, in
_dot_tick), Pyromaniac (+1%/rank inferno step), Super Nova (Detonation
crit), Invigorating Ashes + Melt Armor (burn-tick site in _run_battle;
melt = enemy "melted" chip + unit.melted armor shred, in DEBUFF_IDS),
Molten Core (target-side), Explosive Force (fire-crit burn extend),
Seeding Embers (unit.burn_at_death captured in _die, harvested in
_update_talent_chips → "seeding" buff), Ashes of Al'ar (self-revive in
take_hit/take_tick_damage, 11%/rank, ashes_used once/battle), Implosion
(Detonation echo via _free_copy). Talent abilities: Flame Shield
("flame_shield" special+status, self-cast, thorn burn in the Trapper
block; perfect = pulse ticks all burning) and Firestorm capstone
(random_hits, 6-8 bolts rolled by display_name in _resolve, 7-9 perfect). Warrior kits reshuffled 07-15
(Crushing Blow to Warden, Sweeping Strikes, talent-granted Lunge/Execute/
Shieldwall v2/Hold the Line/Battle Shout/Rampage-recast). Unit UI lives on NAMEPLATE stacks
(180px plates, heroes left edge, enemies right; portrait + name + bars +
chips; ACTING unit's plate = gold border, that's the turn indicator — no
arrow; hover/Tab lights plates; plain style until UI assets arrive); parties
grouped tight; combat log hideable (– button). SPECCED HEROES DISPLAY THEIR
SPEC NAME everywhere (unit_name = spec; logic keys on unit.hero_key — never
match display names!). Battle DEBUG ▾ menu (bottom-right): Full Restore,
Kill All Enemies (Batch AO, id 3), Cooldowns OFF, Enemy attacks OFF, per-hero
turn LOCK (every HERO turn theirs — enemies still act; displaced heroes'
clocks tick as if they acted).
Renewal is Holy-only (15 HP/turn). Cleric core has Resurrection (40 Faith,
revive 20% hp/resource, targets the fallen); Devout has Divine Wrath
("wrath" status +15% dmg/speed); Occultist: Shadowrend basic (via
Classes.apply_kit_overrides — call it wherever kits are assembled!),
Mind Flay 30 Mana, Umbral Sigil (50% damage echo to the branded enemy's
party). RESOLUTION TEMPLATE DECIDED 07-12: Pyromancer size wins — author
characters at 236px frames shown 1:1; Berserker (124px @1.25) is legacy
until re-generated. Own-art specs live in battle.gd SPEC_ART (untinted).
Partial sheets fall back — see unit.gd _build_sprite. Battle bg at max
zoom-out (cover 1296x736). Beastmaster: "Summon Companion" = menu slot W →
beast picker (Tab/Space/X); hotkeys map to _menu_entries slots, NOT raw
ability indices. ALL battle UI ~20% smaller (plates 144px, log 240px). Specs carry archetype
tags (Ramp/Rush/Nuker/Pressure/Healer/Warder/Tank/Bruiser) in SPEC_INFO.
Battle has burger menu (restart/settings overlay/exit); skill checks accept
Space or left click; no announcer text (combat log only).

## Known open threads
- **CLOSED IN BATCH BN §1 — THE `_hold_release` / `_hold_freeze` RECURSION. THE MECHANISM IS KEPT
  HERE ON PURPOSE, BECAUSE ONE FLAG IS THE ONLY THING PREVENTING IT AND A LATER BATCH COULD
  DELETE THAT FLAG FOR LOOKING REDUNDANT.** It stood as the first open thread from BF §3 to BN,
  six batches. Do not re-record it as outstanding.
  · **THE CYCLE WAS DETERMINISTIC, NOT A RACE, AND NEITHER HALF WAS A BUG ON ITS OWN.**
    `_hold_release` erases its target from `_holds` and calls
    `set_chilled_stacks(HOLD_RELEASE_STACKS)` — **which is 1** — and then Honed Shards
    (`cr_razor_hone`, Thaw row 6) applies **3** more. 1 + 3 is **exactly the 4 that
    flash-freezes**, so every release re-froze its own target. Meanwhile `_hold_freeze` appends
    and then runs `while _holds.size() > _hold_limit(): _hold_release(_holds[0])` — and the
    limit is **1** for a Thaw-lane Cryomancer. So freezing a SECOND enemy evicted the first,
    whose release re-froze it, which evicted the second, whose release re-froze IT, until
    GDScript's stack limit. **The comment beside Honed Shards had always warned it "can
    re-freeze the enemy it just thawed" and that warning was ACCURATE; what nobody traced was
    that a hold LIMIT turns a self-re-trigger into a two-body cycle.**
  · **THE FIX: `var _releasing`.** `_hold_release` sets it, calls `_hold_release_body`, clears
    it; `_hold_freeze` early-returns while it is set, as its FIRST gate. **THE WRAPPER IS THE
    POINT** — GDScript has no `finally`, the body carries an early return, and a leaked flag
    refuses every freeze for the rest of the battle. **NO MAGNITUDE MOVED**: cutting Honed
    Shards' 3 or the release's 1 would have nerfed a node to work around control flow.
  · **NO RE-ARM IS NEEDED** and it was read, not assumed: the threshold is
    `status_stacks("chilled") >= 4` (BEING at four, not REACHING it) and stacks clamp at 4, so a
    parked enemy is frozen by the very next chill. A reach-based check there would leave enemies
    permanently unfreezable — worse than the crash, and silent. Driven live in test_batch_bn and
    built as a negative control.
  · **HISTORICAL NUMBERS, kept because they are what an instrument looks like when it finds a
    fault reading cannot:** 23 events per 400 budget-12 battles (BF §3, identical on unmodified
    HEAD at matched n, so it was pre-existing); 15 overflows in four runs and ~1.1 MB of
    backtrace with a Thaw Cryomancer (BG §1); and BN's own matched control — **305 events and
    20 MB by run 6 on unmodified HEAD, against 25/25 runs and ZERO on the fixed build.**
  · **WHAT IT COST WHILE IT STOOD, so the price of the next one is on the record: one of twelve
    specs could not have its best lane measured by the project's best instrument.** BG
    substituted Deep Freeze for Thaw to get a run band at all. That substitution is no longer
    needed — a Thaw band now reads 16% completions, depth 39.40 ±1.99, zero events.
- **THE DEVOUT'S FAITH ROW — THE ROW IS NOT A MAGNITUDE PROBLEM AND NEVER WAS. READ THE BI
  BLOCK AT THE TOP OF THIS FILE FOR THE CURRENT NUMBERS; everything in this entry below the BI
  lines is HISTORY.** Six batches: BE, BF §2, BG §2's capstone re-spec, BH §2's two lane-body
  re-specs, then **BI §1's decoupling — the one that named the actual fault.**
  **THE FAULT WAS THAT HELD VALUE AND RELEASE FREQUENCY READ ONE METER AND WANTED OPPOSITE
  THINGS FROM IT.** BG and BH broke a compounding lane by adding a second axis, and the second
  axis was ANTAGONISTIC to the first, so the grid went flat and two nodes went dormant. BI §1
  gave the held half its own quantity (`faith_peak`, the battle's high-water mark), and the lane
  went from **two points over the ungeared floor to four** with releases up ~1.6×.
  **WHAT IS STILL OPEN, WITH THE NUMBER: RELEASES ARE 0.7 A BATTLE AGAINST A STATED TARGET OF
  TWO TO FOUR, AND THE CAUSE IS NOW MEASURED RATHER THAN GUESSED.** ~10.4 Faith a battle reaches
  three allies — 3.5 each — against a release threshold of 5, in a fight that gives an ally about
  four turns. **The average ally cannot fill the meter in an average fight; 35% of the Faith that
  lands is stranded as partial stacks at battle end.** BI named ONE lever with its arithmetic
  (**the ground's base drip 1 → 2**, worth ~+9.1 Faith/battle and an estimated 2.0-2.5 releases)
  and recorded ONE alternative (**the release threshold 5 → 3**, ~2.6-3.0 releases at no extra
  Faith). **NEITHER WAS TAKEN — both are design decisions, and the drip is the term BH
  deliberately took a node off.** Do not take a third lever without re-reading the per-source
  table, which the sim prints on every Devout row.
  **THE FAITH ROW HAS TAKEN FOUR LEVERS ALREADY (Communion twice, the capstone, the lane body).
  DO NOT RE-PRICE ANY OF THEM BACK, and do not fold held value and release frequency onto one
  number again — that is the fault BI removed.**
  **HISTORY FROM HERE DOWN.** **THE BAR AT BH READ FAITH 13% | ZEAL 31% |
  BULWARK 12%, against BG's FAITH 38 | ZEAL 32 | BULWARK 12.** BH's brief predicted the fall,
  instructed that it be reported and not chased, and **nothing was taken**. **THE NODE TO RAISE
  IF THE DESIGNER WANTS IT RAISED IS BLESSED ARE THE FAITHFUL**, the lane's only magnitude node
  — that is a decision, not a repair, and no batch should take it unasked.
  **TWO THINGS FROM BH THAT MUST TRAVEL WITH ANY FUTURE WORK ON THIS LANE:**
  **(1) THE ALL-FOUR FAITH ROW IS NO LONGER A ±2-POINT INSTRUMENT.** BH's first read of its
  −Binding Oath cell came back 24% / 2.06 releases and **does not reproduce** — three later
  reads of the same build give 12/13/13%. The cause is the loop AW documented as intended
  (release → bigger Devout maximum → bigger Divine Shield → more absorbs → more Faith), which
  is **positive feedback with an ignition threshold, and BH parks the lane just under it**, so
  a few runaway battles in 200 drag the mean ten points. **REPLICATE ANY LOAD-BEARING FAITH
  ROW; a single n=200 read is not enough on this lane any more.**
  **(2) A LEAVE-ONE-OUT GRID ON A COMPOUNDING LANE UNDER-REPORTS EVERY NODE IN IT.** BC's grid
  read Binding Oath at ONE point; BH's re-spec of that same node was part of a change that
  moved the row twenty-six. Three multipliers on one term do not add, they multiply, and
  shaving one at a time can never show how much of the total is the product.
  Everything from here down is BE/BF's record; **quote BG's rows, not BF's, for anything
  ALL-FOUR — BF's all-four −Apostle cell (31%) reads 39% on unmodified HEAD and does not
  reproduce.** Everything below is BE/BF's record, kept because the HISTORY of the row is what
  makes the fourth lever look tempting and the history is the argument against it. Every figure
  below is measured, n=200,
  BC's lineup, and BF's rows were taken with the SAME instrument as BE's (BF §1 did not move
  `d+h+p%` by a point, which is why the two batches' rows are comparable at all).
  · **WHAT SHIPPED: Communion 40 -> 15 (BE), then Communion no longer rolls for an ally
    already at 5 (BF §2).** One-hero the row went **80% -> 73% -> 54%** (healing 2255 -> 1555
    -> 618, releases 32.21 -> 22.77 -> 9.64); all four built, **55% -> 45% -> 33%** (695 ->
    429 -> 244, 10.54 -> 6.55 -> 3.81). **Healing per release has not moved in ANY row across
    either batch** (67/65/61 one-hero, 62/61 all four) — both levers landed on frequency,
    which is the axis BC identified.
  · **THE BAR IS MET ON THE ROW THAT COUNTS.** FAITH should sit near his other two lanes
    rather than at twice them: **all four built, 33% against ZEAL 31% / BULWARK 14% — a 1.06x
    gap, from 1.8x before BE and 1.45x after it.** One-hero it is **54% vs ZEAL 42% /
    BULWARK 23%**, 1.29x from 1.9x. (ZEAL/BULWARK were NOT re-run and did not need to be: a
    build without `dv_communion` makes no Communion draw at all, so those rows are
    byte-identical by construction — BE's own argument about its controls.)
  · **THE CONTROL THAT PROVES THE LEVER HIT WHAT IT AIMED AT: the −Apostle row is UNCHANGED.**
    One-hero **63% -> 62%**, releases **12.70 -> 12.70** to the hundredth, healing 910 -> 913.
    Without Apostle an ally never sits at 5, so the new condition can never fire — and it
    doesn't.
  · **THE SIGN ON APOSTLE FLIPPED, AND THIS IS THE OPEN ITEM. IT IS THE "TWO NODES IN ONE LANE
    THAT PARTLY CANCEL" SMELL, NOW WITH A NUMBER.** At 40 Apostle was worth **+7**; at 15
    **+10**; after BF §2 it is worth **−8 one-hero (54 vs 62) and −2 all four (33 vs 31)** —
    taking the capstone now LOWERS the Faith engine's output, because parking allies at 5
    makes them invisible to Communion (releases 9.64 vs 12.70 one-hero, 3.81 vs 4.58 all
    four). **RECORDED, NOT SOLVED, exactly as BF specified.** If the tree wants restructuring
    later, this is the note to start from: the honest fix is probably to make one of the two
    nodes something else, not to re-price either.
    **SOLVED BY BG §2, AND ALONG EXACTLY THAT LINE: the capstone became something else rather
    than something cheaper.** BF's −8 is the number that justifies the re-spec and it must
    travel with it — see the BG block. **DO NOT RE-PRICE APOSTLE BACK ONTO THE RELEASE.**
  · **THE CLIFF IS REAL AND IS STATED IN THE TOOLTIP: 60% at four stacks, 0% at five.**
    Measured in test_batch_bf over 1200 driven releases apiece — **58.8% at four, 0.0% at
    five** (it was 75% at five before BF). An ability whose chance climbs with stacks and then
    vanishes at the top reads as a bug unless the text says so.
  · **THE GROWTH CLAUSE IS 4.3% OF THE ROW'S HEALING.** AY halved it and the row did not move,
    for that reason. **THE LEVER THE ROADMAP NAMES — the growth's base step 3% -> 2% — IS THE
    SAME TERM AND IS WORTH ~1.4%. DO NOT TAKE IT EXPECTING IT TO MOVE THE ROW.**
  · **DEVOUTNESS NO LONGER MOVES THE HEADLINE BY ZERO BECAUSE THE INSTRUMENT CAN SEE IT NOW**
    (BF §1): it books **35-48 Break points a battle** into `BDprev/b`, which is where that
    node's work has always been. It still contributes nothing to `d+h+p%` and never should —
    see the standing note at `DOD_SIM_TALENTS`.
  · **READ THE LEVEL OFF THE ALL-FOUR ROWS, NOT THE ONE-HERO ONES** — see the same standing
    note. Both constructions agree about the cause and disagree about the level, and BF is the
    clearest case yet: Apostle reads −8 one-hero and −2 all four.
- **NOTHING HAS EVER CHECKED A SPEC POOL FOR REDUNDANCY AGAINST ITS OWN BASE KIT (Batch BD §4).
  RECORDED, NOT ACTED ON.** Batch AH's curation rule checks that a CLASS-pool entry still
  FUNCTIONS for a sibling spec — a real rule, tested, and pointed at a different question.
  **Deadfall duplicated Snare Trap for fourteen batches** (same cost, initiative, cooldown, trap
  cap and 1-turn stun, with its perfect handing back the only distinction) **and was caught by a
  player reading two tooltips, not by anything in the harness.** A pass across all twelve spec
  pools comparing each entry against its own kit is worth doing and is NOT a repair batch:
  twelve pools, five to eight entries apiece, and **any redundancy it finds is a design decision
  rather than a fix** — the answer to two similar abilities is usually to make one of them
  something else, which is authoring.
- **A DEADFALL HOLDS A TRAP SLOT UNTIL SPENT, AND THAT COSTS A MEASURED 3.03 SNARE TRAP CASTS A
  BATTLE AT THE BASE CAP (Batch BD §1).** Shipped as specified. **The alternative — a deadfall
  costs no slot at all — is ONE CONDITION in `_ability_usable`**, and the number is now on the
  table for the designer rather than a guess: at a cap of one the deadfall refuses more Snare
  Trap casts than Snare Trap actually gets (1.4/battle), every refusal is the deadfall's, and
  Deadfall Network takes refusals to zero while nearly doubling his snares (1.4 -> 2.6).
  `trap_report_line()` prints it, so a re-decision does not need a new instrument.
- Menu background image not yet in imported files (fallback: forest art).
- Distinct Mage/Cleric/Hunter sprites awaited from user.
- Boss tri-choice class modifiers deferred (design doc) until 3+ zones.
- Spec rune coverage COMPLETE (Warrior X, Mage+Cleric AA, Hunter AB).
  The open lever remains authored rune POWER — a runes.json data edit,
  not machinery — and the dilution question (see the AB block).
- Sim bot wins ~90%+ with 4 heroes; real difficulty tuning by user playtest.
- **CLOSED IN BATCH BA — ALL TWELVE TALENT TREES ARE PURPOSE-AUTHORED. Do not re-record
  this as outstanding.** The four class batches AI promised landed (AK Swordmaster, AJ
  Berserker, AL Warden, AR Pyromancer), then AS the Cryomancer and AT the Arcanist (MAGE
  DONE), AV Holy, AW the Devout and AX the Occultist (CLERIC DONE), and AY the Beastmaster,
  AZ the Sharpshooter and **BA the Survivalist (HUNTER DONE, and with it the roster)**.
  Rates for the record: the Mage three took 3x, the Cleric three 4-5x (a support's numbers
  were the smallest in the game), the Hunter three 3-4x. **The Survivalist's spec id is
  "mystic" — NEVER rename it, saves and trees key on it.**
  WHAT THIS CLOSES AND WHAT IT DOES NOT: every tree now carries authored magnitudes, so
  "structurally correct, numerically weak" is no longer true of anything. The open work that
  used to hide behind it is the per-spec AU §1 GENERIC FALLBACKS (below) and authored
  content in the ability-upgrade pool — neither is a magnitude question.
- **DEATH RAY'S ABSENT BREAK DAMAGE IS CLOSED (Batch BB §7) — THE DESIGNER CLOSED IT
  DELIBERATELY AND IT MUST STOP RESURFACING AS AN OPEN QUESTION.** It carries no BD, at
  55 Mana, on purpose. AT specified everything but BD, AU was offered a version trading
  raw damage for pressure and declined it, and BB struck the thread. **Do not re-record
  it as outstanding and do not propose the fix unsolicited.**
- **ASHES OF AL'AR HAS A HOME (CLOSED BY BATCH BB §6, the designer's own call).** It is
  Mage-wide and EARNABLE: `CLASS_POOLS["mage"]` (back to twelve entries) **and all three
  Mage SPEC_POOLS, which is where the live boss draw actually reads** — Batch AN §4
  retired the class draw, so a class-pool entry alone would have been unreachable.
  **HALF OF AR'S RULE SURVIVES AND HALF WAS INVERTED BY BATCH BS: his OPENING KIT is
  still all fire, but the INFERNO LANE is his defence now**, so Ashes of Al'ar is the
  only self-revive by CAST rather than the only defence he can have at all —
  Kiln-Forged refuses one death as a passive while three or more enemies burn. The field
  is `ashes_return` (a REAL magnitude — the % of max health handed back — not the old
  `randf() < 0.11 * ranks` roll), one guard `BattleUnit._ashes_guard()`, two callers.
- THE RUNE OF THE WHITE FLAME HAS AN INERT CLAUSE (Batch AR). "Inferno Master
  grants +1% per burning enemy" has no counterpart under Overburn; the rune is
  left as authored and test_batch_ar pins the clause inert. Re-authoring it is
  a design call, not a repair — and it is one clause of three, the other two
  are live.
- **THE ABILITY-UPGRADE POOL IS AUTHORED AND CLOSED AT EIGHT (Batch BH §1). Do not
  re-record it as a placeholder of four, and do not add a ninth.** AP built the
  machinery, AQ the three surfaces, BH authored the other four. **EIGHT IS THE
  TARGET, NOT A STEP TOWARD TWELVE** — a hero draws three a run, so a bigger pool
  stops being felt as a reward. Honed / Quickened / Effortless / Swift (AP) plus
  **Weighted** (Break doubled, `pressure > 0`), **Widened** (one more target or
  hit, `random_hits > 0 or multi_hits > 0`), **Piercing** (half the armor,
  `damage > 0 and armor_pierce < 1.0`), **Certain** (the status roll becomes a
  certainty, a partial `status_chance` WITH a status, or a partial `bleed_chance`).
  **THE EXTENDED `UPGRADE_PRIORITY` ORDER IS A COMPATIBILITY SURFACE, NOT A
  PREFERENCE — the four new ids are APPENDED** so a node that granted Honed
  yesterday grants Honed today (AU §1's fallback walks this list; inserting
  anywhere else silently re-points every live fallback in the game).
  **THREE CORRECTIONS BH MADE TOWARD THE CODE, so nobody re-derives them:**
  the brief's `bd` **IS `Ability.pressure`** (no `bd` field exists); **`aoe` is NOT
  eligible for Widened** — an area attack already hits every living enemy, so
  there is no target to add and offering it is precisely AP §3's dud; and **NO
  HERO ABILITY IN THE GAME SETS `status_chance` BELOW 1.0** (only enemy kits in
  enemies.json do, which no upgrade can reach), so **the reliability axis the
  roster actually has is `bleed_chance`** and Certain covers both fields.
  **`up_sure` (widen the Perfect window) WAS NOT WRITTEN, on the brief's own
  condition, and the reason is durable: `PERFECT_HALF` is a bare script constant
  read by `_grade_skill_check()`, WHICH TAKES NO ARGUMENTS AND CANNOT SEE THE
  ABILITY**, plus a zone rectangle built once at UI setup — and **the bot never
  runs the timing bar at all** (it rolls a grade off hardcoded probabilities), so
  a widened window is invisible to every instrument this project owns. Piercing
  took the slot. If a later batch parameterises the window, that is when to
  revisit; test_batch_bh pins all four facts.
  **MEASURED ELIGIBILITY REACH across the 92 abilities `Classes.pool_ability`
  resolves: Swift 92, Quickened 88, Effortless 84, Honed 37, Piercing 37,
  Weighted 35, Widened 8, CERTAIN 2** (Hack and Slash and Wildstrikes, both the
  Berserker's — for eleven specs Certain is simply dropped from the offer rather
  than paired with a dud). **REPORTED, NOT FORCED**: widening it means authoring
  partial status chances onto hero abilities, which is design, not repair.
- **TWO SPECS STILL TAKE THE GENERIC TALENT FALLBACK (Batch AU §1), NINE nodes of them:
  the PYROMANCER (5) and the CRYOMANCER (4). Nobody else owes one.** This entry read
  "seven specs, 11 nodes" until Batch BA; **that was stale prose, corrected toward the
  code** — the count was computed off the live trees through `Talents.granted_name` and
  `Talents.collision_kind`, the same two functions the tooltip reads, rather than counted
  from memory. **FULL OWNERSHIP LEDGER, and it is complete now that all twelve trees are
  authored:**
  · AUTHORED, owes nothing — Berserker (2), Swordmaster (2), Warden (1), Holy (2),
    Inquisitor (2), Occultist (2), Arcanist (1 authored + 1 `no_fallback`).
  · STRUCTURALLY CANNOT OWE ONE, their trees grant no abilities at all — **Beastmaster
    (AY), Sharpshooter (AZ), SURVIVALIST (BA)**. Each is asserted both ways in its own
    batch test, so a later batch adding a grant to one of them trips.
  · STILL OWED — Pyromancer, Cryomancer.
  Replace them the way AU/AV/AW/AX did: a node payload's `upgrade` list, or
  `no_fallback: true` where the node already pays through another clause. The generic is
  a floor, not a finished design. test_batch_au's floor is `generic >= 9` and FALLS on
  purpose, with a durable per-class half beside it (a spec whose batch has landed must owe
  NO generics).
- **SEVERITY 4 HOLDS FOUR MODIFIERS AGAIN — `rot` SHIPPED IN BATCH BB §5.** The pool is
  twenty (6/6/4/4). Do not re-record it as dropped.
- **THE VICTORY SYNC NOW HAS THREE FIELDS MEETING AT ONE LINE AND THEIR SIGNS DIFFER.
  READ THIS BEFORE TOUCHING IT — IT IS THE SITE WITH A ~127,000 MAX-HP RUNAWAY IN ITS
  HISTORY (Batch W) AND THE SITE THAT GOT `rot` DROPPED FROM AQ.** Since Batch BJ §1 it is
  ONE IMPLEMENTATION — `BattleUnit.sync_victory_state(member)`, called by battle.gd's
  victory branch AND run_sim.gd's `on_battle_end` (the two copies could drift; now they
  cannot). It computes:
  `max_hp - tenacity_hp_gained - conviction_hp_gained + rot_hp_lost`.
  · **`tenacity_hp_gained` — SUBTRACTED.** A one-fight gain, off since W. **IT HAS A
    SECOND CONSUMER**: Unkillable's mend reads `max_hp - tenacity_hp_gained` as "the pool
    he brought into the battle", so NOTHING may be folded into it.
  · **`conviction_hp_gained` — SUBTRACTED.** A one-fight gain (AW).
  · **`rot_hp_lost` — ADDED BACK.** A one-fight LOSS (BB §5). The only one with this
    sign, which is exactly why it is its own field.
  **ALL THREE STAY SEPARATE.** Two of them cancel arithmetically in a battle carrying
  both; that is a coincidence of the numbers, not a licence to merge. test_batch_bb's
  three-fields-one-sync check drives a Devout growing, a Warden's Tenacity growing and
  Rot active in ONE battle with DELIBERATELY DIFFERENT magnitudes, so a sign error cannot
  hide inside a cancellation.
- **THE PACK'S SWAP RULE IS BATCH Q'S AND MUST NOT BE "FIXED" BACK (Batch BB §1).** A
  summon at capacity replaces the beast holding **LESS Loyalty**, tie-breaking to the
  older; one implementation, `battle._swap_victim`, read by `_do_summon` AND the bot.
  **AY's "replaces the older of the two" was a REGRESSION, not a design** — AY is the
  batch that removed Loyalty's ceiling and measured a bond 50 stacks deep, so an age rule
  can break a 50-stack partnership for a fresh arrival inside the spec whose spine is
  partnership DEPTH. AY's stated reason ("the newcomer always holds the lowest Loyalty")
  does not survive the site: **the newcomer is not on the field yet when the victim is
  chosen.** What the age rule really bought was the ability to rotate a deep bond OUT,
  and refusing that is the point. Batch Q's **never-two-of-the-same-kind** clause is
  untouched and covers the swap clones too (`_ability_usable` slices the kind off the
  display name, so "Swap Ursus" and "Summon Ursus" hit the same gate).
- **CREEPING DEATH HAS TWO CLAUSES AND ONLY ONE OF THEM IS GOVERNED (Batch BB §2).**
  Perfected Toxin makes his poison permanent and a poison with no clock has no duration
  to refresh, so Venom row 5 + the Venom capstone owned a node that could never fire.
  **On a permanent poison the node ADDS A STACK; on a clocked one it refreshes.** Both
  halves read the `full` stamp `_apply_poison` leaves (`full < 0` = permanent), not a
  constant of their own. **THE STACK CLAUSE IS LIMITED TO ONCE PER ENEMY PER TURN AND THE
  REFRESH CLAUSE MUST NEVER GAIN THAT LIMIT**: the node fires on ANY status landing on a
  poisoned enemy, and since BA one Distillate cast lands poison + Exposed + Slowed
  together — refreshing three times is refreshing once, but adding three stacks is not
  adding one. The governor's marker rides the STATUS (`creep_turn`), so it dies with the
  poison and is per-enemy for free. **`battle._turns_taken` was PROMOTED FROM A LOCAL to
  a field for it**, because `_run_battle` cannot be driven headlessly and a governor
  keyed on a local inside it could never be tested.
