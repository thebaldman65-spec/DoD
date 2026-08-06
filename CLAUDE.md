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
- New `class_name` files need `--headless --import` before they resolve.
- Balance: `./sim.sh N` = N battles of the FIXED raider/chief/archer/archer
  lineup (power 7, unscaled) — kit smoke tests only; its win% carries NO
  difficulty signal (Batch R). `./sim.sh --sweep N` (DOD_SIM_SWEEP=1) = N
  battles at EACH budget 3/6/9/12, fresh fight-theme warband per battle,
  enemies unscaled (`DOD_SIM_ZONE` picks the roster); per budget it also
  prints avg enemy count, avg enemies alive entering round 3, and per-hero
  damage share (Batch S — a DOD_SIM_THEME'd sweep = per-theme share for
  free). `./sim.sh --run N` (DOD_SIM_RUN=N, def 50) = N COMPLETE runs with
  progression BOTH sides (tier scaling + slot mult, HP/mana/item carry,
  points earned AND spent, elite runes auto-equipped, trophies) → run
  report: wipe distribution, per-tier averages, measured party-vs-warband
  power table + run economy (gold earned/spent/unspent, items used/left,
  rests taken vs offered) + a per-invocation "Matrix row" line for
  cross-policy assembly. Policies env-set + printed: DOD_SIM_ROUTE
  (greedy|default|cautious|elites — Batch U: greedy = the Batch S floor
  byte-for-byte, never rests while combat is offered; default rests when
  AVG party HP <65% and a rest is reachable; cautious <80%; run all three
  for the band real play sits inside), DOD_SIM_SHOPS=off / DOD_SIM_ITEMS=off
  (both default ON: shops heal-first — hero <50% buys a Health Potion each —
  then priciest affordable offer not carried, runes incl. but only onto a
  free slot + equipped at purchase, never dipping under the 40g reserve;
  battle bot drinks a carried Health Potion opening a turn <35% HP, run
  sims ONLY — sweep/standalone stay dry so R/S baselines hold),
  DOD_SIM_BUILDS="spec:Lane,...", DOD_SIM_TROPHIES, DOD_SIM_RELICS (draft),
  DOD_SIM_ROTATE=1 (Batch W: rotate all twelve specs; see the Batch W
  block below — shares then carry sample counts), DOD_SIM_MAP=old (Batch
  Y: the pre-Y map generator — 70% link roll, blind deal; EVERY pre-Y
  baseline row incl. greedy-as-the-Batch-S-floor only reproduces at
  map=old), DOD_SIM_DIFFICULTY=wanderer (Batch Y alpha affordance,
  enemies x0.7 through zone_base_mult; default standard — NEVER set on a
  baseline row), DOD_SIM_RUNE_ECON=rich / DOD_SIM_RUNE_POWER=<mult>
  (Batch AD EXPERIMENT ARMS — measurement only, never shipped; UNLIKE
  every other flag here they are gated on Run.sim_run as well as the env,
  so a stale export cannot put a real run in an arm. rich = all 4 slots
  from t1 + a spec-eligible authored rune granted at each zone half-mark;
  power = a multiplier on authored payload UPSIDE only, costs held,
  tpl_* stat sticks untouched. Post-AD Matrix rows carry econ=/power=/
  depth= fields; pre-AD rows do not — never compare across),
  DOD_SIM_START_RUNE=off (Batch AE — reproduces the PRE-AE economy by
  suppressing the awakening pick-of-3. Default ON, and UNLIKE the two AD
  arms above it is NOT gated on Run.sim_run, because it is SHIPPED
  CONTENT rather than an experiment arm; a control row has to be
  reachable from real play or the comparison is unreproducible. Post-AE
  Matrix rows carry start=; pre-AE rows do not),
  DOD_SIM_SPEC_OPENING=off (Batch AF — drops the GUARANTEE that the
  opening triple holds a spec-scoped rune, reproducing AE's opening
  WITH THE STARTING RUNE STILL ON; that is what makes AF's control
  isolate AF rather than re-measure AE. Shipped content, so default ON
  and NOT gated on sim_run. Post-AF Matrix rows carry specopen=),
  DOD_SIM_MINIBOSS=off (Batch AH — reproduces the PRE-AH MAP: ten dealt
  tiers, the full 17-fight deck, no guaranteed mini-boss and so no
  mini-boss ability award. Shipped content, default ON, NOT gated on
  sim_run. It is an honest control for the MAP HALF ONLY: kits still
  open at 3 abilities with it off, because the trim is structural and
  has no switch. Post-AH Matrix rows carry mb=).
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
- `scripts/run_state.gd` (autoload `Run`): party/items/gold/map/zones, save
  (user://run_save.bin, auto-saved after every node), relic slots (max 3).
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
  map (burger menu, shop/rest/loot nodes) → battle → party (talents/runes).

## Current systems snapshot (2026-08-06)
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
spec rune would trip it. EXPECTED: structurally correct, NUMERICALLY WEAK
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
(b) treasure/Loot STILL outstanding since AC — six batches.
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
(d) treasure/Loot STILL outstanding since AC — five batches. (e) the
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
it as a regression. (d) treasure/Loot still outstanding from AC.
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
REPORTED NOT ACTED ON (designer's call): (a) treasure/Loot is now the
only node type a debug menu cannot reach — delete it or deal it again;
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
one half of an EXCLUSIVE talent pair (heat_haze/scorched, cold_snap/
bitter_cold, arcane_ward/still_mind, cascade/overflow, stalwart/bastion,
pact_flesh/barter); every stat field must be a real BattleUnit property or
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
REBALANCED +1→+3 pts. relic_active() legacy-kept but no site uses it.
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
Penetration/Tempo per the design doc; exclusives ss_exec_eye↔
ss_consistent, ss_tunnel↔ss_spray. Bot: works ss_t (last target),
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
→ "old_gods". RUIN = enemy-side stacks (status "ruin", add_status
branch caps 5, chip "R#", battle-long) gained whenever the Occultist
applies a debuff (generic applies_status site checks passive_id ==
"old_gods"; custom sites call _gain_ruin — Bewitch cast/Dazes, Hex
Decay, Spread, Mirror). Effects gated on _living_occultist(): target
+2%/stack in _resolve; hero strikes on Ruined targets lifesteal
(10+5×soul_leech)% of final (post-damage block). At 5: "ruin_primed"
1t → _detonate_ruin at the bearer's turn start (BEFORE tick_statuses;
50% Occ Atk shadow w/ resist via take_tick_damage + party heal 15% Occ
max HP). PSYCHOSIS status: 50%/turn in _enemy_turn — supports
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
(_apply_status guard). Talents: Corrupted Channeling now
channeling_ranks (25%/rank of a Crippled attacker's damage), Pleasure
from Pain end-of-_player_turn (0.5%/rank Occ max HP × unique enemy
debuffs — _unique_enemy_debuffs helper), Dark Infusion attacker-side,
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
PYROMANCER REWORK (07-16; the passive and Wildfire are SUPERSEDED BY
BATCH AG above — read that block, not this one): passive "inferno" =
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
Reset cooldowns, Enemy attacks OFF, per-hero turn LOCK (every HERO turn
theirs — enemies still act; displaced heroes' clocks tick as if they acted).
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
- Menu background image not yet in imported files (fallback: forest art).
- Distinct Mage/Cleric/Hunter sprites awaited from user.
- Boss tri-choice class modifiers deferred (design doc) until 3+ zones.
- Spec rune coverage COMPLETE (Warrior X, Mage+Cleric AA, Hunter AB).
  The open lever remains authored rune POWER — a runes.json data edit,
  not machinery — and the dilution question (see the AB block).
- Sim bot wins ~90%+ with 4 heroes; real difficulty tuning by user playtest.
