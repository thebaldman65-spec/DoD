# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

*Last rewritten: 2026-08-27 (Batch DN).*

---

## WHERE THE PROJECT IS

- **Last batch: DN — THE TALENT NODES AGAINST THE NEW CHARTER. A REPORT.** Nothing was
  re-authored, no tree was restructured, no node moved. One new instrument, `check_dn.gd`,
  **read-only and NOT in `GATES`** — the standing `check_cu` and `check_cv` already have, for the
  same reason. **The audit is a new §8 inside `docs/talent-audit.html`** rather than a second
  document, so CU's reading (does the text match the code?) and DN's (guaranteed, or drawn?) sit
  together over the same 324 nodes.
- **THE TWO HALVES OF THE ANSWER DISAGREE, AND THAT IS THE FINDING.** **The CONTENT is almost
  clean: SIX of 324 nodes depend on something drawn, and only TWO are dead without the draw**
  (`bm_devoted_fury` and `bm_reserves`, both whole nodes about a `SPEC_POOLS` ability). The other
  four carry a bonus CLAUSE that is drawn and stand up without it. **The repair bill on the existing
  text is two re-authors and four clause cuts.**
- **BUT THE SHAPE CANNOT BE BUILT FROM THEM: ZERO OF TWELVE SPECS CAN FILL THREE NINE-CELL LANES,
  AND 97 NEW NODES — 30% OF THE LAYER — WOULD HAVE TO BE AUTHORED.** **Two specs hold a lane at
  ZERO**: the Cleric has no offensive node in 27 and the Sharpshooter no defensive one. **Even at
  ONE row per lane — a three-cell tree — those two still cannot fill**, so no shrinking rescues it.
  The curve bends at four rows per lane (22 nodes short, 4 of 12 specs filling).
- **TWO OF THE BRIEF'S COUNTS WERE WRONG AGAINST THE REPO AND BOTH ARE IN THE AUDIT'S §8.0.**
  **There are THIRTY-SIX capstones, not twelve** — `CAPSTONE_ROW` is 9 and `LANES` is 3, so row 9
  is three cells wide per spec; the build screens' *"ONE PER HERO, EVER · any lane"* is a PICK of
  one from a SHELF of three. And **CV cut THREE dead Perfect clauses, not four** — the audit's own
  disposition table reads *"CUT THREE; `dv_bulwark` IS NOT ONE OF THEM"*, its 5% party heal having
  been ruled UNCONDITIONAL rather than dead. **`dv_bulwark` is a capstone, so a re-author working
  from "four" would re-commit the error CV ruled against.**
- **THE CHARTER CONTRADICTS ITSELF ABOUT 75 NODES AND SOMEBODY HAS TO RULE.** Its §0 permits a node
  to be general in two ways only — *a STAT, or the spec's OWN resource and passive*; its §1 says
  *a node modifying a CORE KIT ability is guaranteed*. **The gap is 235 clean versus 318 clean, and
  it is a wording question rather than a code question.** §1's reading is the one the audit uses,
  because it is the one with a mechanical test behind it.
- **THE CAPSTONES ARE THE CLEANEST PART OF THE LAYER, NOT THE DIRTIEST.** **33 of 36 are
  GUARANTEED, 3 are tree-internal, NOT ONE IS DRAWN**; nine grant an ability outright, which makes
  them the most guaranteed nodes in the game — the talent IS the source. **The sanctioned exception
  the brief was preparing to grant does not appear to be needed.** Ruled on nowhere, as instructed.
- **THE SAVED-ALLOCATION RISK WAS MEASURED, NOT REASONED ABOUT.** A Berserker with all 27 cells
  bought reads spent 54 / available 0. Move ONE node from row 1 to row 9 and it reads **spent 56,
  available −2 — a NEGATIVE purse, with nothing to refuse it, clamp it or log it.** Delete an id
  and its point is silently refunded while the dead cell stays in the save forever. **`Profile`
  is v2, the load is TOLERANT, `version` is stamped unconditionally, and there is no migration step
  in the file** — so there is currently nothing a migration could hang on. **`cells_spent` prices
  each owned cell off the row it CURRENTLY sits in, which is why a MOVE is the dangerous edit and a
  RENAME is not.**
- **THE `lane` FIELD IS THE COUPLING, AND IT IS SIX LIVE SITES.** `data/runes.json` carries **36
  `lane` fields, every lane name exactly once**; `runes.gd`, `run_sim.gd`, `talents_screen.gd`,
  `party_screen.gd` and `battle.gd` read one. **The two screens keep working and read BETTER**;
  `run_sim` is the casualty — **every `DOD_SIM_BUILDS` value ever typed becomes invalid**, and
  `_target_lane`'s `tree[0].lane` fallback stops being twelve distinct arms. **The test tree is the
  larger surface and is not in that six: TWENTY-FIVE `test_batch_*` files reference a lane**, some
  with hard-coded name tables beside every node id.
- **CU'S CROSS-ROW CONDITIONALS ARE FIVE, NOT THREE, AND ALL SIXTEEN CROSS-NODE DEPENDENCIES
  SURVIVE.** The brief names the Berserker's three; `sm_guarded`→`sm_punish` and
  `wd_shatter_guard`→`wd_spiked` carry the same payload `condition`. **A cross-row conditional is a
  bet on a node the player CHOOSES, not on a card they are DEALT**, so it is not the defect this
  audit was looking for even though it looks like one.
- **ONE MATCHING RULE EARNED ITS PLACE THE HARD WAY: SAME-TREE NAMES BEAT THE CORPUS.** The Warden
  node `wd_spiked` is *named* **Spite** and the Berserker has a *drafted ability* called Spite; the
  first pass reported a cross-spec bet that does not exist. The same pass matched "Berserk" inside
  "Berserker" seven times and "Heal" inside "Health". **Word boundaries plus same-tree precedence
  removed all nine false bets** — the DoD-standard needle-floor fault, in a new place.
- **`master.html` DID NOT MOVE AND ITS STAMP IS STILL `(Batch DM)`.** DN changes nothing about what
  the game IS, so the fourteen self-comparing stamp gates are correct to read DM. **The two-letter
  stamp gate reads `substr(_code_at + 7, 2)` and compares lexically** — a THREE-letter code would
  break all fourteen.
- **TWO BATTERIES AT DN, AND THE FIRST ONE FOUND A REAL RED THAT WAS THE INSTRUMENT'S OWN FAULT.**
  Battery 1 ran frozen and reported **`check_da` 37 / 2** — §3's hand-rolled-corpus fingerprint is
  the two draft-pool calls, and **`check_dn.gd` carries both**, because the membership tables are
  the whole audit. **IT IS A FALSE POSITIVE AND THE FIX RECORDS WHY RATHER THAN SUPPRESSING IT:**
  `check_dn` calls `Classes.ability_corpus()` outright for the walk and reads the pools only for
  which BUCKET a named ability sits in, which the flat 216 cannot answer. `WALK_EXEMPT` holds two
  files now, and **the loop that asserts each exempt file STILL carries the marks is what makes the
  count 37** — the +1 is the exempt list, not new coverage. `baselines.json` moved 36 → 37 with
  `checks_obs` reset to 1, in a **five-line diff**.
- **BATTERY 2 RAN AGAINST A TREE FROZEN BEFORE IT BEGAN AND UNEDITED UNTIL IT FINISHED** — 153
  files MD5-stamped at the freeze and identical after — **and it is the acceptance run. Seventy-one
  targets ran and the manifest names all seventy-one.** `check_de` reports **293 checks / 0
  failures / 0 NOTICES**, and **zero throws anywhere.** The only red is `check_cm_live`'s four, the
  standing deliberate one.
- **`check_dn` IS NOT IN THE BATTERY AND OWES NO BASELINE ROW.** It is not in `GATES`, so it writes
  no log, so the differ never sees it — which is why `baselines.json` is still **70 rows** after a
  batch that added a `check_*.gd` file. Run it by hand:
  `DOD_DN_DUMP=<path> Godot --headless --path . --script check_dn.gd`.
- **Next letter: DO.** `DO` sorts after `DN`, so the stamp gates still work.
- **Phase.** The ability draft is COMPLETE (120 of 120) and all twelve talent trees are
  purpose-authored. Recent batches are correction and consolidation: the skill-check rework
  (CM/CN/CS), the fold rulings (CQ/CR), the pouch (CT), the talent audit (CU/CV), the documentation
  split (CW), the archive cut (CX), the tempo rule (CY), CZ's two ramp repairs, DA's correction of
  one of them, DB's and DD's `_spawn` consolidations, DC's threshold repairs, DE's move of the
  count differ into the runner, DF's sort of the 47, DG's close of the ten, DH's nine cross-spec
  clauses, DI's payment of the plumbing debt, DJ's close of the half DI would not take, DK's ruling
  on the eleven, DL's close of the clause DK recorded as owed, DM's close of the ally/hero thread,
  **and DN's sizing of the talent charter.**

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION

**THE ALLY/HERO THREAD IS CLOSED AND NOTHING FROM IT IS CORRECTNESS-SHAPED ANY MORE.** What is
below is design, prose, and the standing owed items.

### THE TALENT CHARTER — SIZED AT DN, AWAITING A DESIGNER DECISION

**Nothing here is correctness-shaped. All of it is a decision, and the audit exists so the decision
is made on numbers.** Full evidence: `docs/talent-audit.html` §8 and `docs/reports/DN.md`.

- **THE ANSWER TO "IS IT WORTH IT" IS: NOT AS A RE-SORT.** 318 of 324 nodes need no charter-driven
  change; **97 NEW nodes do.** And 97 is a LARGER authoring job than the original twelve-tree pass,
  because those were written to a THEME each spec already had and these must be written to a
  CATEGORY the spec demonstrably has no material for — nine offensive nodes for a Cleric who has
  never had one, nine defensive nodes for a Sharpshooter who has never had one.
- **THREE THINGS WANT SETTLING FIRST, AND ONLY THE SECOND IS CODE.**
  1. **§0-versus-§1 of the charter** — one sentence, worth 83 nodes (235 clean or 318 clean).
  2. **The saved-allocation drift** (`Profile` v2, no migration hook, a MOVE mis-prices a cell).
     **Fix it BEFORE any restructure ships, not after** — meta progression is the one thing in this
     game that cannot be re-earned quickly, at 1 point per spec per ZONE BOSS.
  3. **Whether the tree shrinks at all.** Worth deciding on its own merits; it does not solve this.
- **THE SIX DRAWN NODES, IF THE CHARTER PROCEEDS AT ALL:** `bm_devoted_fury` and `bm_reserves`
  re-authored (each is one sentence about a `SPEC_POOLS` ability and does nothing without it);
  `sm_blade_dance`, `wd_stomp_drill`, `wd_bannerman` and `bm_ancient_pact` reworded (each stands
  without its drawn clause). **And a seventh the ability pass cannot see:** `sm_precision` reads
  Dazed, Crippled and Exposed, and the Swordmaster guarantees NONE of the three — Dazed comes only
  from Charge (class draft) or Sweeping Strikes (spec pool), the other two only from `sm_lunge`.
- **THE ONE THING THAT MUST NOT BE SILENTLY UNDONE:** CV ruled `dv_bulwark`'s 5% party heal
  **UNCONDITIONAL**, not a dead Perfect. It is a capstone, so a re-author is likely to touch it.
- **AND THE EXPENSIVE CONVENTION IS NOT AT RISK FROM THE RE-SORT — IT IS AT RISK FROM THE 97.**
  HERO-versus-ALLY took five batches (CV, DJ, DK, DL, DM). A re-sort re-opens none of it.
  **Authoring 97 new nodes writes 97 new chances to get *ally* wrong**, and
  `docs/text-standard.html` §4.9 is the test.

### THE FLAKE THAT DG FOUND, AND IT HAS NOW READ QUIET EIGHT TIMES RUNNING

- **`test_batch_at`'s §1 LIVE DAMAGE-CURVE RATIO IS UNSEEDED. IT WENT RED AT DG AND HAS READ 0 IN
  EVERY BATTERY SINCE — DH, DI, DJ, DK, DL AND DM — STILL OPEN, STILL UNSEEDED.** At a rate of about
  one red in eighteen, eight quiet readings is the common case and proves nothing. `_live_curve()`
  sums TEN casts at 0 Resonance and ten at 12, and asserts the ratio is `> 2.0 and < 2.35` against
  a table value of **2.17**. It read **2.40**. **The `_seeded()` calls in that file are all
  DOWNSTREAM of it**, so the check runs on whatever the startup RNG happens to be.
  - **THE ±10% DAMAGE ROLL ALONE DOES NOT EXPLAIN IT.** Modelled over 200,000 trials, ten summed
    casts a side put the ratio's 5th–95th percentile at **2.08–2.26** and P(over the 2.35 ceiling)
    at **0.1%**, about one run in a thousand. **2.40 is off that distribution entirely, so there is
    a SECOND random term.**
  - **THE SUITE'S OWN `_spawn` NAMES THE CANDIDATE, ON THE VERY HELPER THIS CHECK CALLS:** *"THE
    CRIT IS THE THIRD COIN AND ON THIS SPEC IT IS THE WORST ONE: Runaway Resonance adds +1% crit
    PER STACK, so a 'same cast at 0 stacks vs 12' comparison silently compares 10% crit against
    22% crit."* The fixture passes `"crit": -10.0`, which removes the **base** and not the
    **per-stack** term. **A model carrying the full differential over-predicts badly — 32% red
    against ONE RED IN EIGHTEEN READINGS observed — so the live term is smaller than that and
    larger than zero.** The size of it is not established and should not be guessed.
  - **DD FIXED TWO CHECKS OF EXACTLY THIS SPECIES IN THIS SUITE AND DID NOT REACH THIS ONE.** Its
    rule stands: **seed both blows of the compared pair, or neutralise the crit as the file's own
    comment says checks that care must do — do NOT widen the band, because the band IS the
    question.**
  - **The zeros on this row are the flake being quiet, not the flake being fixed.** **One flake at
    a time is how the effect stays attributable** — `bo`'s is still open and `test_rune_battle`'s
    is three batches old. Its band and its readings are in `baselines.json`.

### THE SEVENTH FAMILY, FOUND AT DM AND DELIBERATELY NOT SWEPT

**A TEXT THAT UNDER-STATES ITS OWN PAYLOAD.** An absent clause does not mis-say, so DM §1's test
does not reach it, and **adding a clause to a card is authoring while correcting a wrong word is
repair.** Both are reported and neither was taken.

- **BOTH *UPGRADED* CARDS DROP "Refunds 5 Rage" WHILE THE CODE STILL PAYS IT.** Battle Shout's and
  Hold the Line's upgraded `description`s both omit it; `attacker.resource = mini(attacker.resource
  + 5, …)` is outside every branch in both handlers.
- **AND THE POOL-PICK BATTLE SHOUT SHOWS THE NODE'S NUMBERS.** `pool_ability` falls through to
  `Talents.granted_ability`, so **there is one `description` in the project for three magnitudes**:
  a pick pays **+8% for 2 turns** (`shout_base[0]`, `shout_turns[0]`) and the card promises +12%
  for 3. `master.html` records the pool figures correctly; the card does not.
- **NO SYSTEMATIC SWEEP FOR EITHER WAS RUN.** DM found both by reading six cards, not by sweeping,
  and the thread stops there on purpose.

### THE FIVE ALLY-WORDED TEXTS, RE-DERIVED AT DM AND RULED ON NOWHERE

**None is a clause-level scope disagreement**; each is a single-shape text saying *ally* where its
read site means *hero*, on an effect that already behaves correctly. **Every read site was
re-derived from the source at DM; not one was moved.**

- **The Warrior's Rally** — *"Shout one ALLY forward"*. Its picker filters `not a.is_companion` at
  **three** sites, so it cannot even be aimed at one. It also carries **two clauses of different
  shape**: a turn hand-off and a resource refill.
- **Health / Mana / Revive Potion** — `_use_item` picks from `heroes.filter(not dead)`.
- **Shared Grief's log** — *"%d ally below half"*. Walks `heroes`, skips companions.
- **The Mercy `passive_desc` and the glossary's `mercy_window`** — `unit._check_below_half` gates
  on `is_hero and not is_companion`.
- **Glacial Hold's *"+15% damage from EVERY source"*** — `_hold_window_mult()` has **exactly one
  caller**, in the hero strike loop. DL corrected the glossary's "party-wide"; the card's own claim
  is still owed.
- **AND THE GLOSSARY'S `res_faith` SAYS *ally* IN FOUR MORE PLACES** — the Devout's allies, Binding
  Oath's releases, an ally's release at 3, a shielded ally holding. **Faith is heroes-only outright
  by text-standard §4.9's binding rule**, so all four are wrong; **DM corrected only the
  Consecrated Ground clause, because that clause was in scope and the rest are a sweep.**

### Small, and still owed

- **THREE ASSERTIONS PASS VACUOUSLY IN `as`, `at` AND `aw`, AND THEY ARE NAMED AT THEIR SITES.**
  Each reads a substring of a string that is now empty, left over from the exclusive-pair list DG
  deleted the red half of. **A check that passes for no reason is worse than a red**, so this is
  owed rather than settled.
- **`_apply_status`'s `src` COVERAGE IS 106 OF 204, AND THE REMAINING 98 ARE OWED.** DI stamped the
  36 sites that can apply a status **Harvest reads** and DJ added the seven companion sites; the
  rest apply buffs, marks and hero-side wards, so **nothing currently mis-credits off them**.
  **Do not quote this figure without re-deriving it** — `check_di` §1 walks the file and PRINTS the
  live count on every battery run.
- **AND ONE SITE IS OUT OF REACH BY SHAPE RATHER THAN BY SCOPE.** `melted` is applied through
  `unit.add_status`, which **accepts no source argument at all** — stamping it is a signature
  change. **It is the only Harvest-readable status applied outside `_apply_status`.**
- **`_companion_hit` READS NO `empower`, NO `wrath` AND NO `battle_shout`, AND THAT IS THE LAST
  LIVE ITEM OUT OF THE ALLY/HERO THREAD.** A beast's blows resolve on their own damage path and
  read none of the hero strike loop's multiplier block, so widening any of those three would hang
  a visible chip on a beast and move no number. **Measured at 1.0000 over 40 seeded blows for all
  three — `check_dk` §4 re-measures `empower` every run and `check_dm` §2 re-measures `wrath` and
  `battle_shout`** — so the day the read site is added, the gates say the rulings are stale rather
  than staying quietly true. **Adding it is a magnitude change on beast damage — new PLAY.**
- **DEVOUTNESS AND LAST HOPE ARE RECEIVABLE AND ARE NOT RECEIVED**, because both are stamped once
  in the party-spawn block before any companion exists. **Measured: a beast wearing `devotion` at
  20 banks 32 Break from a 40-BD blow.** Reaching a beast summoned later wants a **re-stamp on
  summon** — a second write site for one node's worth of effect.
- **NO SIM HAS RUN SINCE THE FIVE WIDENINGS, SO EVERY CARRIED SIM FIGURE IN THIS FILE IS STALE.**
  Sanctuary, Hold the Line, Rally and the Field Medic (DK) and Rallying Shout's Pressure clause
  (DL) all reach a fifth body in a Beastmaster party. **THE HEALING AND BREAK FIGURES AT THE FOOT
  OF THIS FILE ARE MARKED STALE RATHER THAN LEFT TO BE QUOTED AS CURRENT.** They are DA's, they
  predate DK and DL, and **correcting them means running the sim, which no batch since has done.**
  **DM moves no magnitude and adds nothing to that staleness.**
- **SEVEN SITES ARE DELIBERATELY UNSTAMPED BECAUSE THEIR TRUE SOURCE IS AMBIGUOUS**, and all seven
  are named in `docs/reports/DI.md` §2. **Getting the source wrong is worse than leaving it absent.**
- **`FIREDRAW_TAKE` (4) IS DEAD, AND WAS DEAD BEFORE DH.** `firedraw` uses
  `FIREDRAW_TAKE_PERFECT` (6) unconditionally. **DH deliberately did not collapse it** — that would
  move a magnitude — but it is a real dead symbol that `test_batch_cd`'s sweep does not catch.
- **`shared_grief`'s SOURCE COMMENT SAYS THE CARD PAYS "EXACTLY 3" AND `sg_grant` IS 4.**
  Pre-existing stale prose. One line.
- **`_run`'S SAVE-BACKUP PREAMBLE IS STILL THE NEXT COPIED HELPER AND IS STILL NOT TAKEN.**
  Re-derived at DF: **`_run` is 39 bodies in 39 suites and is correctly 39** — it is each suite's
  own driver. **38 of the 39 open with the same `_had_save` backup block. 38 swap
  `Profile.save_path` to a per-suite file and 33 of those 38 swap it back**; `bn`, `bo`, `bp`, `bq`
  and `br` do not. Same shape as `_spawn`, one layer in.
- **`CLAUDE.md` IS STILL OVER CW's OWN TARGET.** CW set *"under 3% of the knowledge sync and
  roughly flat over time"*. It reads **215 KiB of a 6.14 MiB sync = 3.42%** — DM added two standing
  rules and corrected one block in place, and the sync grew with it, so **the ratio is still
  roughly flat rather than rising** (3.25% at DI, 3.30% at DJ, 3.34% at DK, 3.39% at DL). Not
  urgent; **worth a prune when a batch is in the file anyway**, and DG through DM have all now
  declined it.
- **TEN HAND-BUILT BATTLE BOARDS REMAIN, IN SIX FILES** — `al` (2), `an`, `ax`, `bl`,
  `test_rune_battle` (3), `test_run_harness` (2). **None is a copied helper.** `check_da` §3
  carries them as a **named ratchet** (by file AND by count), so a new copy cannot hide among them.
- **`test_rune_battle` IS SEEDED AND THE BAND IS NOT TIGHTENED.** DF §0 put `_seeded()` immediately
  before the forced White Flame hit and nowhere else. **The check count is unchanged at 97.**
  **Readings cannot retire a rate measured over fifteen on this evidence.** **The seed cannot fix a
  race**, and the failure message now carries the state the forced hit happened in.
- **`bo`'s FLAKE IS STILL OPEN**, and is **deliberately unseeded** — one flake at a time is how the
  effect stays attributable. Its repair is `at`'s shape: seed both blows of the compared pair. Its
  rate is in `baselines.json`. **Its floor red is REPAIRED at DG**, so the row is now the flake
  alone.

### Carried, and still awaiting a ruling

- **THE ARITHMETIC PROBES IN `bg`, `bh` AND `bi` STILL SIT ABOVE THE REACHABLE BAND.**
  `STACKS := 4` is a **direct-write probe depth**, not a carry ceiling — those checks write
  `faith_stacks`/`faith_peak` onto the unit, bypass `_gain_faith`'s clamp, and measure a per-stack
  rate against **fixed percentage-point tolerances** (`< 2.0`, `< 2.5`, `> 2.5`). **Halving the
  depth halves the effect size against tolerances that do not move with it**, across roughly thirty
  currently-green live measurements. **Moving them down is a re-derivation of tolerances, which is a
  ruling, not a repair.** **DF's eight threshold repairs in `bu` and `ce` were NOT this case** — they
  involve no tolerances, only counts — which is why those could be taken and these cannot.


### Carried, with measurements attached

- **THE FRENZY RATE IS `FRENZY_RAGE_PER_STEP` = 5** and is a rule rather than a constant (five Rage
  is 5% of a full bar, the health term's own rate). Peak Frenzy 13.4 → 20.9 of 40 at rung 2 under
  CZ, and **DA re-measured it unchanged at 20.7**. **Reckless Abandon dumping a full bar books all
  twenty steps at once** — named, not discovered later.
- **THE FAITH LANE IS SETTLED, THE SUITES AGREE WITH IT, AND AS OF DG THE PROSE DOES TOO.**
  Numbers in `docs/reports/DA.md`: threshold 3, builders 2 and 1, releases **1.93 / 2.60 / 2.48 /
  3.62** across the four arms. **Elevation (2 of 3) and Blessing of the Faithful (3 of 3) were
  reported at both CZ and DA and deliberately changed at neither.** If either is revisited,
  Elevation is the one with a history of being moved by accident (CG set 2, CN's fold pushed 3, CQ
  reverted it).
  - **THE DERIVED BAND IS WHAT THE FAITH SUITES ASSERT ON SINCE DC:** the deepest an ally can
    **HOLD is 2** (`FAITH_RELEASE - 1`); **Communion's eligible band is 1–2** (the walk skips
    `faith_stacks >= FAITH_RELEASE`) and its roll `0.01 * 15 * stacks` **peaks at 30%**, measured
    at **29.8% over 1200 trials**; **two absorbs are a release.** **DC gave five suites
    `const RELEASE := 3` and `const HELD_MAX := RELEASE - 1`; DF added the same two to `bu` and
    `ce`**, so the next threshold ruling costs one line in each of seven.
  - **AND WHEN A BATCH REVERTS A CONSTANT, SWEEP THE PROSE FOR THE NUMBER IT REVERTED — INCLUDING
    THE ABILITY'S OWN CARD.** DA reverted TWO constants in one batch. DC swept the ABSORB one and
    fixed both its surfaces (the `passive_desc` and the `faith` chip); **the GROUND DRIP's card was
    the surface nobody swept, and it stood wrong from DA to DG.** **When a batch reverts two
    constants at once, sweep them as two sweeps** — the one with fewer surfaces looks finished
    because the other one was. **Grep the NUMBER, not the field**: a card says "2 Faith" and never
    says `FAITH_PER_GROUND_TURN`.
### Named by the designer, carried from CX

- **Enemy interference as a status.** Not yet specified.
- **RELICS PER-HERO — RULED, SCOPED, AND NOT STARTED.** The ruling stands (a relic is assigned to
  one hero at pickup); CX reported the scope and stopped. **It is a SAVE-FORMAT change: the run
  save goes v10 → v11.** `Run.active_relics` is a flat `Array` read back as a hard key
  (`data["active_relics"]`, no default), so every existing save breaks without a migration. It
  also touches **25 read sites** (`battle.gd` 12, `run_state.gd` 8, `run_sim.gd` 4,
  `shop_screen.gd` 1), the two aggregators (`Relics.hook_add` / `hook_dict`), the two accessors
  (`Run.relic_add` / `relic_dict`) — **all four change signature** — both acquisition sites, and
  **13 of the 25 relic descriptions**, which are worded party-wide. **It can be split; it should
  not be started casually.**
  - **FOUR HOOKS NEED A RULING BEFORE ANY OF IT.** Party-wide by nature and staying that way:
    `start_items`, `start_gold`, `gold_find_mult`, `shop_discount`, `loot_extra`, `victory_gold`.
    Per-hero already: the eleven battle-spawn hooks. **Genuinely ambiguous:**
    `victory_heal_pct` (Chalice of Dawn, Cracked Hourglass, Martyr's Knucklebone),
    `victory_mana_pct` (Cracked Hourglass), `rest_heal_add` (Cairnmoss Poultice, Martyr's
    Knucklebone), and `resource_floor_pct` (Bottled Storm).
  - **The draft assigns relics BEFORE specs are chosen**, which is the point at which "which hero
    gambles" has the least information behind it. Worth deciding whether assignment moves.
- **Rune content.** The rune economy is measured and the system is built; the content pass has
  not been authored.
- **The enemy debuffs whose duration exceeds their own cooldown.** Reported by the fold census.
- **The design review.**
- **Browser playtesting with friends.**

### Carried from the code, reported and deliberately not fixed

- **EIGHT TARGETS STILL CANNOT REPORT A CHECK COUNT, AND IT IS A RATCHET RATHER THAN A SENTENCE.**
  `check_parse`, `check_flow`, `check_map`, `check_cl_resolver`, `check_cl_width`, `check_cm`,
  `check_cn` and `check_map_screen` read `checks=?`. **Two of them — `check_cl_width` and
  `check_map_screen` — report `fails=?` as well**, so the battery cannot see whether either passed
  at all. **A count that reads `?` is the one thing a count-diffing rule cannot compare.** DE
  records that state as `null` in `baselines.json` and asserts the SET in both directions: **a
  target that LOSES its count is an error, and one that GAINS a count is a notice telling the next
  batch to record the number.** `check_map_screen`'s whole verdict is the single line
  `check_map_screen: OK`, so that line is pinned as its `expect` field.
- **THE DEFAULT SIM BUILD HAS NEVER MEASURED A NON-FIRST LANE, FOR ANY OF THE TWELVE SPECS.**
  `Talents.LANES` is **3** and there are twelve specs, so **24 of the project's 36 lanes have never
  appeared in any measurement taken here** — Glacial Prison, Second Prison, Cold Snap, Glacial
  Economy and Absolute Zero among them. Not a defect (a fixed default party is what makes arms
  comparable across batches), but **no sim figure can be quoted about a card in a non-default lane**
  and several have been. **DB made the sim print the count beside `builds=` so the caveat arrives
  with the number.** DA ran one arm on `cryomancer:Deep Freeze`.
- **`_recast_refusal_note` SAYS "FROZEN" WHERE THE NAMEPLATE SAYS "HELD".** The refusal on a held
  enemy reads *"Frozen already stands at full strength"*; Batch AS §4 renamed that chip to **HELD**
  deliberately. **The note is accurate and the vocabulary is inconsistent.** One string, and it is
  the designer's call.
- **`check_cu` AND `check_cv` ARE NOT IN `run_battery.sh`'s `GATES` ARRAY.** They are audit REPORTS
  rather than pass/fail gates, so what a failure means there is a decision rather than a detail.
- **THE CODE IDENTIFIERS STILL READING "beast", AND THE PROSE PASS IS NOW FINISHED.** DG closed the
  last prose site (`data/glossary.json`'s hero/ally entry). **The FIELDS were deliberately not
  renamed** — a missed rename in prose is a typo, a missed rename in a field is a bug, so the two
  want separate passes with separate tests. **`beastmaster` / `Beastmaster` / `BEASTMASTER` are
  NOT on the list and must not be renamed.** Live identifiers: `unit.gd` `beasts`,
  `beast_committed`, `no_beast_left`, `no_beast_left_loyalty`; `battle.gd` `_beasts`,
  `_free_beast`, `_on_beast_death`, `_beast_cap` (referenced by name from `talents.gd`); battle
  locals `bot_beasts`, `cw_beasts`, `kc_beasts`, `sb_beast`, `sb_beasts`, `tm_beasts`; node ids
  `bm_beast_within` and `bm_no_beast_left` — **renaming those two moves the save format.**
- **`master.html` credits "the Warden's Crushing Blow talent" and there is no such talent.**
  `Crushing Blows` is a **Berserker** node; `Crushing Blow` is an **ability**. One string, and it
  is the designer's call which way.
- **No spec pool has ever been checked for redundancy against its own base kit.**
- **Two specs still take the generic talent fallback**, nine nodes between them.
- **`docs/text-audit.html` holds findings that have been ruled on and applied.** Once the designer
  confirms, it can leave the knowledge sync. **`docs/talent-audit.html` CANNOT: DN's §8 is an open
  question, not a closed one**, and the file went 37 → 158 KiB carrying it.

---

## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND

*Re-derive these before quoting them in a brief; they move.*

- **THE TEMPO LADDER HAS THREE RUNGS AND EACH IS WRITTEN AGAINST THE ONE ABOVE.**
  `Ability.BASIC_DELAY` = **2.0** (the one authored copy in the project; `battle.BASIC_DELAY` is an
  alias) → `Ability.BUFF_DELAY_CAP` = `BASIC_DELAY * 0.5` = **1.0** → `Ability.DELAY_FLOOR` =
  `BUFF_DELAY_CAP * 0.5` = **0.5**, the cheapest an ability UPGRADE can buy.
- **THE CAP BINDS 58 ABILITIES IN TWO POPULATIONS.** `Ability.PURE_BUFFS` holds **52** specials
  and `Ability.SHIELD_SPECIALS` holds **6**. **`Ability.takes_delay_cap()` is the one function that
  unions them** and `Ability.make()` applies the clamp.
- **THE ABILITY CORPUS IS 216, AND `Classes.ability_corpus()` IS THE ONLY WALK THAT REACHES IT.**
  The Batch CL enumeration alone reaches **211**; the five it misses (Backdraft, Pyroblast, Glacial
  Prison, Cryoclasm, Intercession) are talent grants that live in no pool. **22 talent-granted
  names in total**, all resolving. **`check_da` §3 asserts that no gate hand-rolls the walk**, with
  `check_cz`'s `_cl_only_corpus` named as the one deliberate exemption.
- **`RECAST_GATED` HOLDS 59 ABILITIES.** `check_co` refuses 58 of the 59 after saturation;
  Interpose is additive and correctly never refuses. **Glacial Prison is the newest member and the
  reason its name appears in THREE tables in `battle.gd`** — `_recast_targets`, `_recast_writes`
  and the effect handler, DA §2's "three edits and no fourth". `test_batch_as` pins the count at 3.
- **BLOOD FRENZY: TWO TERMS, ONE BAND.** `BattleUnit.FRENZY_MAX_STEPS` = **20** and
  `FRENZY_RAGE_PER_STEP` = **5**. Steps are summed then clamped.
- **FAITH: `battle.FAITH_RELEASE` = 3**, **`FAITH_PER_ABSORB` = 2**, **`FAITH_PER_GROUND_TURN` = 1.**
  `JUBILEE_MIN_FAITH` is **3**, which is the WHOLE bar. `ELEVATION_STACKS` is **2**, which is **67%
  of a release**. **An absorbed hit pays LESS than a release costs, and `check_da` asserts that
  RELATIONSHIP rather than the numbers.** **`_gain_faith` doubles under `zeal` and under nothing
  else** — not Fervor, not Apostle. **ALL NINE PLACES THAT SPEAK EITHER MAGNITUDE NOW AGREE**, as
  of DG §1: the two cards, the `passive_desc`, the `faith` chip, the glossary, two `master.html`
  sites and two source comments.
- **The ability draft is COMPLETE at 120 of 120** — `SPEC_DRAFT_POOLS` is **96** (12 specs × 8)
  and `CLASS_DRAFT_POOLS` is **24** (4 classes × 6), counted out of `classes.gd`. **DG corrected
  the last five prose copies of that figure**, one of which was `classes.gd`'s own draft header.
- **Ability slot cap: 7** (`ABILITY_SLOT_CAP`), with twelve protected cores.
- **The pouch: 4 → 5 → 6 slots by zone** (`ITEM_SLOTS_BY_ZONE`), a slot holding one item TYPE and
  its whole stack. **Default per-type stack cap `ITEM_CAP` = 6**, with three exceptions
  (`ITEM_STACK_CAPS`): Cleansing Draught **4**, Cursed Visage **2**, Resonating Hourglass **2**.
  Sale returns `SELL_FRACTION` = **0.4** of listed price.
- **The skill check's default profile** — `battle.SC_PROFILE_DEFAULT`: `perfect_half` **0.045**,
  `good_half` **0.16**, `centre` **0.5**, `sweep_time` **0.72**, `presses` **1**, `press_taper`
  **1.0**. **Every caller uses it except the Sharpshooter's basic attack.**
- **Save versions: the run save is v10** (a pre-v10 save is REFUSED and cleared); **`Profile` is
  v2** (tolerant load). Talent cells cost 1/2/3 by tier — **27 cells = 54 points a spec.**
  **`Talents.LANES` = 3**, so the twelve trees hold **36 lanes**.
- **Relics: 25 in the pool** — 17 common, 8 rare. **Up to 3 are assigned per run**, party-wide.

### THE TEST TREE, AS OF DN

- **47 `test_*.gd` files**: 44 `test_batch_*` spanning `ah` to `cp` (with gaps — they are NOT one
  per batch), plus `test_run_harness`, `test_runes` and `test_rune_battle`. **They live at the repo
  ROOT, not in `scripts/`.**
- **`_spawn` IS AUTHORED ONCE, IN `suite_fixture.gd`, AND 37 SUITES GO THROUGH IT.** `_kill` too, in
  14. Each suite keeps its OWN `_spawn` SIGNATURE and delegates, so **all 389 call sites are
  untouched.**
- **`run_battery.sh` RUNS 46 SUITES AND MISSES NONE.** The `GATES` array is **nineteen** — DM
  added `check_dm`. **There are 26 `check_*.gd` files**, so **seven are not in `GATES`** — `check_ck_width`,
  `check_cu`, `check_cv`, `check_dn`, `check_ct_map`, `check_map_screen` and `check_de`. **`check_ct_map` and
  `check_map_screen` run in the SCENE RUNS section and `check_de` runs in its own post-pass section
  AFTER them**, so the four that run nowhere are `check_ck_width`, `check_cu`, `check_cv` and `check_dn`.
- **THE BATTERY WRITES A MANIFEST, `$OUT/.ran`, AND THE DIFFER TRUSTS IT RATHER THAN THE DIRECTORY
  LISTING.** `run_battery.sh` does NOT clear `$OUT` between runs, so a target that failed to launch
  would otherwise be blessed by its PREVIOUS run's log. A name is appended immediately before its
  target is launched and `run_one` truncates the log at spawn, so **a log named in the manifest is
  always this run's**. A subset invocation (`./run_battery.sh bo bp`) writes a short manifest and
  **the differ reports the rest as DID NOT RUN instead of certifying a clean tree.**
- **`gate_fixture.gd` AND `suite_fixture.gd` ARE NOT GATES AND ARE DELIBERATELY NOT NAMED
  `check_*`/`test_*`** — `test_batch_cd` and `check_da` both glob those prefixes.
- **THE BASELINE TABLE IS `baselines.json` AND IT IS 70 ROWS: 46 suites, 19 gates, 2 scene runs
  and 3 harness gates.** **DO NOT RESTATE ITS NUMBERS HERE OR IN `CLAUDE.md`** — a second copy of a
  number is this project's oldest recurring defect, and **DG found five live copies of one figure
  and two disagreeing copies of another.** Per target it carries the expected check count (a number
  or a band), **the expected FAILURE count**, **how many readings the row rests on**, any known
  flake and its rate, and an optional verdict string. **Every red row carries the reason it is red.**
- **`test_batch_bx` IS 157 CHECKS AND DM DID NOT MOVE IT**: §4b keeps the retired word "party"
  retired, over a WIDER file list than §4's "beast" sweep (it adds `relics.gd`, `relics_screen.gd`,
  `events.gd`, `shop_screen.gd` and `blacksmith_screen.gd`, which "beast" never reached).
- **`test_batch_al` IS 559 CHECKS AND DM RE-POINTED ONE OF ITS NEEDLES WITHOUT MOVING THE COUNT.**
  Its §3 asserted the UPGRADED Hold the Line card contains "two turns"; DM's CV §1 correction moved
  that string, **and the needle followed it** — to `"die\nfor 3 turns"`, which names its clause
  rather than matching a bare number that also appears on the Break-cut line.
- **`test_batch_cd` IS 72 CHECKS NOW** and is the hygiene suite: the dead-symbol sweep, the
  draft-target sweep and the pool measurement. **DG repaired its §2 anchor guard and added the
  assertion that the guard RESOLVED**, which is the +1.
- **`check_de.gd` IS THE DIFFER, IT SPAWNS NOTHING, AND IT HAS NO ROW OF ITS OWN** — it excludes
  itself from its own sweep, which is why its count moving 289 → 293 at DM (four assertions per
  target, and DM adds one gate) is reported by nothing. **DI's report made the same movement
  and did not predict it; DJ's, DK's, DL's and DM's prediction tables all carry it.** It runs last, reads the logs and the
  baseline file, and reports. **It is re-runnable in seconds over a log directory that already
  exists**, which is what lets a batch write `docs/state.md` and its report AFTER the battery and
  still certify the tree — neither is read by any suite, and `check_de` reads neither.
- **`run_battery.sh`'s check-count grep is GENERAL and must stay that way.** It matches three
  shapes because 45 suites print at least five between them. **The `grep -E "checks,"` in the
  battery's header is a comment recording a scar CP already fixed — it is not live code.**
- **The master.html stamp gate is duplicated across 14 suites** (ah, bb, bn, bo, bp, bq, br, bs,
  bt, bu, bv, bw, bx, ce), all on the self-comparing pattern — no bump is owed on a re-stamp.
- **Run harness gate counts: 22 / 165 / 8.**
- **master.html stamp: `Last updated: 2026-08-23 (Batch DM)`.**

### HOW LONG A FIGHT IS
**STALE SINCE DK. NOT ONE FIGURE BELOW HAS BEEN RE-MEASURED SINCE FIVE PARTY-WIDE EFFECTS BEGAN
REACHING A FIFTH BODY.** Quote none of them as current — re-run the sim first.
- **Rounds to resolution, measured as TURNS PER LIVING PARTY MEMBER** (companions excluded from
  both halves), over four `--run 25` sims, **after DA** — **DB through DG ran no sim and these are
  carried unchanged**:

  | party / rung | trash | elite | boss |
  |---|---|---|---|
  | 1 wanderer | 3.8 | 3.4 | 4.0 |
  | 2 warden | 4.4 | 3.6 | 5.3 |
  | 3 ruin | 4.4 | 4.4 | 4.4 |
  | 2 warden, Sharpshooter | 5.5 | 4.9 | 6.0 |

  **A fight is still three to six turns per hero** — the ROUNDS column is the half DK and DL do not
  move, because companions are excluded from both halves of that ratio. **The healing and Break
  columns are the stale ones.** **"Elite fights are the shortest of the three
  kinds at every rung" NO LONGER HOLDS AT RUNG 3**, where all three kinds read 4.4.
- **THE SIM'S OWN `Avg rounds/battle` LINE DIVIDES BY THREE AND THE PARTY IS FOUR.** It has been
  reading a third high since the class draft. `cy_report_line` is the one to read instead.
- **RAMP ARRIVAL, per-battle peak against what the spec is built around, AFTER DA:**

  | spec | meter | rung 1 | rung 2 | rung 3 | SS party |
  |---|---|---|---|---|---|
  | Berserker | Blood Frenzy (of 40) | 17.1 | **20.7** | 22.6 | 26.2 |
  | Devout | Faith (of 3) | 2.2 | **2.2** | 2.0 | 2.3 |
  | Devout | releases/battle | 1.93 | **2.60** | 2.48 | 3.62 |
  | Beastmaster | Loyalty (of 5) | 19.3 | 21.2 | 19.9 | — |
  | Sharpshooter | Focus (of 100) | — | — | — | 128.2 |

  **Loyalty and Focus still over-arrive and have not been touched.**
- **THE FAITH DECOMPOSITION AT RUNG 2, AFTER DA — AND STALE SINCE DK for the healing row:** absorbs **3.90**, ground drip **8.01**, total
  **12.27** a battle, of which **2.21** lands on the Devout's own held meter. **Faith per absorb
  ACTUALLY LANDED is 1.56 against the 2 the constant promises.** Ground up on **49% of hero turns**
  (8.1 of 16.5). Devout healing a battle: **74 / 133 / 130 / 184** across the four arms — **STALE: Sanctuary, Rally
  and the Field Medic now reach a fifth body, so every one of those four will rise.**
- **TWO CONFOUNDERS ON EVERY FIGURE ABOVE: the sim party is FULLY TALENTED (`rows=9 of 9`)**, and
  **it wears each tree's FIRST lane — 24 of 36 lanes have never been measured at all.**
- **AND THE INSTRUMENT'S OWN CAVEAT: the `conviction` row samples the DEVOUT'S OWN meter, which
  HOLDS at the threshold and never releases by rule.** It has never measured release frequency —
  `releases/battle` is the row that does.

### The changelog
- **The live file starts at Batch CO and holds 26 entries** (CO → DN), **339 KiB**. The 400 KB
  threshold is now close: **one more batch of this size reaches it**, and CX's cut point is CN/CO.
- **`DoD-archive/changelog-archive.html` holds 131 entries** (Batch 1 → CN) and is **1042 KiB**.
- **Fourteen suites depend on a file that is not in version control** — bp, bq, br, bs, bt, bu,
  bv, bw, bx, cb, ce, bb, bn, bo. On a machine without `DoD-archive/` they FAIL LOUDLY, which is
  correct.

### Knowledge sync, re-measured at DN
*Measured over `.gd .md .html .json .py .sh`, excluding `assets/`, `.git/` and `.godot/`.
**Treat the file COUNT as method-dependent** — the walks have differed by one before, and the
SIZES are the comparable half. **ALL SIZES BELOW ARE KiB (1024 bytes)**.*
- **138 files, 6.29 MiB** (DM measured 136 files / 6.14 MiB; DN added an instrument and a report
  and wrote 124 KiB of audit into `docs/talent-audit.html`, which is where almost all of the
  growth is).
- Heaviest: `scripts/battle.gd` **1179**, `docs/changelog.html` **337**, `docs/design-notes.md`
  **343**, `docs/master.html` **328**, `scripts/classes.gd` **276**, `CLAUDE.md` **215**,
  `scripts/talents.gd` **184**, `scripts/unit.gd` **174**.
- **The 47 suite files total 1817 KiB — 28.9% of the sync**, still the single largest block. **They
  cannot be archived (they must be in the repo to run) but they CAN be deselected from the sync.**
  The 25 gates add **269 KiB**.
- **`scripts/` contains ZERO test suites.** All game code.

---

## KNOWN-BROKEN AND DELIBERATELY UNFIXED

### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED

**DB measured 72 across 26 suites. DC repaired 23. DD and DE deliberately repaired none. DF sorted
all 47 and repaired the 37 that were STALE. DG closed the remaining ten.** **EVERY BATTERY FROM DI
FORWARD HAS READ ZERO SUITE FAILURES FROM THE THREE FLAKES — DI's two, DJ's two, DK's, DL's and
DM's — AND THAT IS NOT A REPAIR.** `test_batch_at`'s unseeded ratio, `bo`'s NULL FIELD flake and
`test_rune_battle`'s pierce **all simply did not fire**, in any of them. **All three are still open
and still unseeded.** A row that reads clean at a rate of about seventeen in eighteen has told you
nothing when it reads clean — **eight consecutive quiet readings are the expected outcome, not
evidence.** **DM's battery 1 DID read one suite failure and it was not a flake**: `test_batch_al`
went 0 → 1 on a needle DM's own text edit moved, repaired before battery 2.
**THE COUNTS AND THE BANDS ARE IN `baselines.json` AND ARE NOT REPEATED HERE.**

### THE REST

- **`check_cm_live` reports 4 failures. THIS IS THE ONE RED THAT IS ON PURPOSE.** Identical on
  unmodified HEAD, recorded as owed in the gate itself. **DB confirmed the four are byte-identical
  before and after the gate consolidation; DC through DM confirm them again.** It
  is the only thing that presses the defensive bar.
- **AND CHECKS THAT PASS BY ACCIDENT ARE STILL WORSE THAN A RED.** `bs`'s `contains("BATCH XX")`
  against `CLAUDE.md` is the one on record and is the same one-line shape DF repaired in `bn`, `ce`
  and `br`; it is left for the batch that next opens that suite. **The three vacuous exclusive-pair
  siblings in `as`, `at` and `aw` are the other live instances**, named at their sites and in the
  open queue above.
- **`test_batch_at` IS SEEDED IN PLACES AND NOT IN OTHERS.** DD seeded two flaky ratio checks here
  and pinned the suite at 470; **DG found a THIRD of the same species that DD did not reach**, and
  the suite is 467 now for a deletion rather than a repair. Its check count is rock steady across
  every reading, including SEVEN taken at DG — the battery and six ad-hoc re-runs, all 467.
- **`test_batch_bo` STILL HAS ITS FLAKY ASSERTION.** Its check count is rock steady at 1025; the §5
  NULL FIELD check requires `deep < shallow` and the damage carries a 0.9–1.1 variance roll, so both
  can land on the same integer. `test_batch_bo.gd` calls `seed()` zero times. **Its deterministic
  red is REPAIRED at DG**, so the row is now the flake alone.
- **THE SUITES THAT DRIFT IN THEIR CHECK COUNT, AND THE OBSERVATION COUNT EACH BAND RESTS ON.**
  **The bands are in `baselines.json`, with the observation count beside each.**
  **THE RULE, ASYMMETRIC ON PURPOSE: floor = the lowest observation, ceiling = the highest PLUS the
  observed spread** — the floor is the half that catches a real fault, so it stays tight and the
  ceiling takes the headroom. **`check_de` RUNS on that asymmetry: it asserts the floor and reports
  a rise as a notice.**
  - **`an`'s FLOOR MOVED AT DF, FOR A READING AND NOT FOR A REPAIR**, and **DG moved nothing** — it
    read 6054, comfortably inside the band. **DG's brief asked for a widening that DF had already
    made**, which is why every brief is told to derive from the file rather than recall.
  - **`bk` is NOT widened**, because it has not been exceeded: headroom goes where a reading demands
    it.
- **`check_map` is NOT a hang** — 99% CPU for ~5 minutes. The battery gives it a 600s bound.
- **`check_parse` does not cover the test suites.** It walks `res://scripts` and `res://scenes`
  only. **It does not cover the GATES, `gate_fixture.gd` or `suite_fixture.gd` either** — but a
  broken suite fixture fails 37 suites loudly, and **DG parse-checked every edited file with
  `--check-only`, grepping stderr, with a negative control proving the check bites.**
- **A GATE THAT EXITS 0 IS NOT A GATE THAT PASSED.** **A `--script` target whose base class does not
  resolve prints `Parse Error`, runs not one line, and exits 0.** Grep the stderr; never trust the
  tally and never trust `$?`. **`run_battery.sh`'s `throws=` column is the only thing standing
  between this fault and a green report.**
- **The `_hint_done` / `_skill_done` deadlock is real and is NOT currently biting.** Both
  skill-check orientation cards `await` a signal only a real click or key press emits. **A future
  headless modal will hit this again** — `_nobody_can_press()` is the one place the question is
  asked, and a Profile flag is not a bot guard.

### Last measurements

**TWO BATTERIES AT DM, BOTH RUN ON A FROZEN TREE, AND THE FIRST ONE FOUND A REAL BREAK.** Battery 1
is an honest complete reading — of a tree with a defect in it. It reported `check_de` **293 / 1**:
`test_batch_al went REDDER: 1 failures, recorded 0`. `al` §3 asserted the UPGRADED Hold the Line
card contains `"two turns"`, and DM's CV §1 correction had moved that string to "for 3 turns".
**THE NEEDLE FOLLOWED THE STRING** — `test_batch_bf`'s case at DL, not `test_batch_bj`'s: the
string moved because a binding ruling says a duration is stated as APPLIED, not for a reflow. **The
new needle names its clause** (`"die\nfor 3 turns"`). `al` is 559 either way.

**BATTERY 2 RAN AGAINST A TREE FROZEN BEFORE IT BEGAN AND UNEDITED UNTIL IT FINISHED, AND IT IS THE
ACCEPTANCE RUN.** Fourteen files were MD5-stamped at the freeze and re-compared after: identical.
`baselines.json` carried the **PREDICTED** after-values before both, and `CLAUDE.md`,
`docs/changelog.html`, `docs/master.html`, `docs/text-standard.html`, `docs/design-notes.md` and
`data/glossary.json` were written before both; **`docs/state.md` and `docs/reports/DM.md` are the
only files written after, and no suite and no gate reads either.**

| | before (DL's acceptance) | DM battery 1 (found the break) | DM battery 2 (acceptance) |
|---|---|---|---|
| **suite failures** | 0 | 1 (`al`, repaired) | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 289 / 0 / 0 | 293 / 1 / 0 | **293 / 0 / 0** |

**SEVENTY-ONE TARGETS RAN AND THE MANIFEST NAMES ALL SEVENTY-ONE** — seventy at DL, plus
`check_dm`. **0 `Parse Error` and 0 `SCRIPT ERROR` across every log**, grepped from the logs rather
than read off a tally or off `$?`. `test_batch_an` read **6050**, inside its band; `check_de`
reported **0 notices**, so nothing rose unexpectedly either.

**THE SANCTIONED MOVEMENTS, PREDICTED BEFORE THE RUN:**

| target | before | after | movement |
|---|---|---|---|
| `check_dm` | — | **92 / 0** | **NEW: DM's gate.** §1 pins fourteen collection-bearing clauses and two self clauses by their own read lines, anchoring on the CLAUSE and searching BACKWARD for the walk; §2 measures all five recorded reasons on a live Ursus; §4 asserts the six cards' words and the four prose surfaces DM corrected; §5 asserts the thread's close is written down |
| `check_de` | 289 | **293** | **+4, four assertions per target, and DM adds one gate.** Predicted, as at DJ, DK and DL |
| `check_dk` | 64 / 0 | **64 / 0** | **unmoved, and that was predicted too.** Two entries renamed and one re-pointed; the table's SIZE did not change |
| `test_batch_al` | 559 / 0 | **559 / 0** | **unmoved.** One needle re-pointed and two failure messages corrected; no assertion added or removed |
| every other row | — | unchanged | unchanged |

**EVERY PREDICTION LANDED.** `check_da` (36) and `test_batch_cd` (72) both walk the gate directory
and were checked against the new gate BEFORE the run — neither emits a per-file `ok()` except on a
violation, and `check_dm` hand-rolls no corpus, authors no `_spawn` and instantiates no battle
scene. Both were unmoved.

**THE LITERAL SWEEP WAS REBUILT MID-BATCH, BECAUSE ITS FIRST VERSION MISSED THE ONE REAL BREAK.**
Its minimum needle length was **12 characters** and `"two turns"` is nine. The rebuilt sweep
evaluates every literal **≥ 4 characters** in all 47 suites and 25 gates against **both** the
`git show HEAD` version and the working version of every document in one pass — **13,781
literals**. **Eleven pairs were LOST and all eleven are accounted for**: eight are `check_dm`'s own
negative assertions (LOST by design), one is `check_dk`'s deliberately re-pointed `dv_waters` pin,
one is `test_batch_ax`'s `"per ally per turn"` (a NEGATIVE assertion reading a talent node's
`desc`, not `master.html` — `ax` read 345/0), and one is `test_batch_bx`'s `"party"` data-file
strip literal co-occurring with the replaced DK comment (`bx` read 157/0). **The twelfth was the
real one and the battery caught what the instrument did not.**

**THE CARD WIDTHS DID NOT MOVE.** Measured directly over `classes.gd` and `talents.gd` on the
authored `description` and `perfect_text` lines, before and after: **1284 lines, 3 over the
44-character ceiling, widest 55 — identical on both sides.**

**NO GAME CODE MOVED, AND IT IS PROVED RATHER THAN CLAIMED.** `git diff` on `scripts/battle.gd` and
`scripts/classes.gd` with comment and blank lines stripped from both sides is **empty**. **The
check was worth running**: its first pass showed one removed line — `_sfx("heal", -5.0, 0.6)`,
dropped from the `cons_ground` arm by a comment insertion that swallowed it. Restored before either
battery.

**SEVEN NEGATIVE CONTROLS, AND ALL SEVEN BIT:**

| control | result |
|---|---|
| restore Battle Shout's pre-DM Rage wording | `check_dm` **2 failures** |
| restore Hold the Line's pre-CV translated durations | `check_dm` **3 failures** |
| put *ally* back in `master.html`'s Faith drip | `check_dm` **2 failures** |
| put *ally* back in the glossary's Faith drip | `check_dm` **2 failures** |
| **WIDEN Bulwark's loop to `_hero_side()`** | `check_dm` **2 failures** — the §1 gap check (3512 characters against a 120 ceiling) and the live measurement, the beast now wearing `bulwark` |
| **NARROW Hold the Line's `undying` back to bare `heroes`** | `check_dm` **2 failures** — the chip does not reach the beast, and **the beast dies at 0 HP** instead of holding at 1 |
| restore the pre-DM upgraded wording after the `al` repair | `test_batch_al` **1 failure**, on the re-pointed needle |
| *(separately)* a deliberate syntax error in `scripts/relics.gd` | the `check_parse` **stderr** grep reports **19 `Parse Error`**, and **0** once reverted |

**THE SIXTH IS THE ONE THAT MATTERS.** Hold the Line's `undying` clause says *ally* on the card and
was pinned by nothing anywhere — `check_dk`'s entry covers `hold_bd` alone. **A clause that nothing
pins is a clause that can be un-ruled silently**, which is §2's whole subject.

**AND THE ZERO IN THE FAILURE ROW IS NOT A REPAIR.** `test_batch_at`'s unseeded §1 ratio, `bo`'s §5
NULL FIELD flake and `test_rune_battle`'s pierce were quiet in both DM runs, in DL's, in DK's, in
DJ's and in DI's. **All three are still open, still unseeded and still banded. The next batch
should expect any of them back, and a red from any of them is not that batch's.**
