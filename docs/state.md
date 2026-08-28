# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

*Last rewritten: 2026-08-27 (Batch DO).*

---

## WHERE THE PROJECT IS

- **Last batch: DO — TALENTS STOP GRANTING ABILITIES, AND STOP BETTING ON THE DRAW. THE CHARTER IS
  SETTLED AND IMPLEMENTED.** No lane is renamed, no tree is restructured, **no node changes row or
  lane**. DN's 97-node restructure is NOT taken.
- **THE RULING THAT SETTLES DN's §0-VERSUS-§1 CONTRADICTION, AND IT IS WORTH 83 NODES: a talent
  modifying the spec's PROTECTED CORE is GUARANTEED and permitted.** The hero owns its core kit in
  every run, so modifying it is not a bet. The trees were therefore **318 of 324 clean, not 235**,
  and after DO's own work they are **324 of 324**. **It is recorded as a standing rule in
  `CLAUDE.md`, stamped into `docs/talent-audit.html` §8.1.1, and asserted by `check_do` §1 — do not
  re-open it as an open question.**
- **TWENTY-TWO NODES GRANTED AN ABILITY, NOT NINE, AND THE BRIEF'S OWN RULE IS WHAT CATCHES THE
  OTHER THIRTEEN.** DN's "nine grant a new ability outright" is a statement about the **36
  capstones** and is correct as such; the brief generalised it to the whole layer. Nine were
  capstones and **thirteen sat in rows 2, 3 and 4**. **The designer ruled ALL TWENTY-TWO**, and
  ruled that the replacement cells be AUTHORED rather than presented as options.
- **THE RUNE CHECK WAS RUN BEFORE ANYTHING MOVED AND THE ANSWER IS NO — BY ONE ROW.** Four runes
  grant an ability and the brief names all four correctly (Comet carries a `new_ability`; Binding
  Souls, the Last Rites and the Flayed Mind carry a `grant_ability`). **NOT ONE NAMES A CAPSTONE
  GRANT.** But two name a grant from the thirteen the brief's list does not reach: **Binding Souls
  and `dv_resolve` both granted Sacred Resolve, and the Flayed Mind and `oc_mind_flay` both granted
  Mind Flay** — two LIVE DUPLICATIONS, and the Flayed Mind's own `lane` field reads "Madness", the
  lane its twin sits in. Both are resolved by the move: **the rune keeps its grant, the talent does
  not.** A rune is BOUGHT with knowledge of the run in front of you; that is the whole distinction.
- **THE DRAFT IS 142 OF 142 — `SPEC_DRAFT_POOLS` 96 → 118, `CLASS_DRAFT_POOLS` untouched at 24.**
  Per spec: pyromancer 13, cryomancer 12, berserker / swordmaster / arcanist / holy / inquisitor /
  occultist 10, warden 9, and **beastmaster, sharpshooter and mystic still exactly 8** because
  their trees granted nothing to move. **NO POOL LOST ANYTHING AND THE FLOOR IS STILL EIGHT.**
  **The per-spec expectation is a TABLE now, not a multiple** — `test_batch_cd.PER_SPEC_DEPTH` is
  the one authoritative copy and every other suite asserts the FLOOR and the TOTAL.
- **SIXTEEN DEFINITIONS ACTUALLY MOVED AND SIX DID NOT, AND EIGHT OF THE SIXTEEN WERE THE SHARP
  ONES.** The six `grant_ability` nodes named a card defined in `Classes.pending_talent_ability`
  already — outside the tree. The sixteen `new_ability` nodes carried their whole `Ability` dict in
  the payload, and **eight of those were reachable ONLY through `pool_ability`'s fall-through to
  `Talents.granted_ability`** — so deleting a payload would silently have emptied a `SPEC_POOLS`
  entry the zone boss offers. They were lifted into `Classes.draft_ability` **verbatim**: not one
  number, `special`, `perfect_id` or line of `description` re-typed. **The corpus is still 216.**
- **PHOENIX REBIRTH WAS NOT EARNABLE AT ALL AND IS NOW.** It sat in `CLASS_POOLS["mage"]` and in no
  spec pool, and **Batch AN retired the class draw** — so `award_ability_pick` has read
  `roll_spec_ability_offer` (SPEC POOLS ONLY) ever since, and `py_rebirth`'s grant was its only
  source in the game.
- **TWENTY-FIVE CELLS RE-AUTHORED, EVERY ONE KEEPING ITS ID, ITS LANE AND ITS ROW.** Twenty-two are
  the granting nodes; three more read a drawn ability outright — `bm_devoted_fury` (Bestial Wrath),
  `bm_reserves` (Spirit Bond) and `cr_icy_resolve`, which read **Rime**, a card that left the tree
  in this same batch. **EVERY REPLACEMENT MODIFIES THE SPEC'S PROTECTED CORE, ITS PASSIVE OR ITS
  RESOURCE, AND NOT ONE NEEDED A NEW `battle.gd` READ SITE** — `apply_payload`'s
  `{"ability": …, "add"/"set": …}` branch has been the mechanism since Batch AI and nine nodes
  already used it. **Field collisions were checked before anything was authored**: no replacement
  writes a field another node already writes, because two nodes on one field is a silent
  order-dependence nobody would find.
- **`ar_wrath` LOST ALMOST NOTHING** — its step-doubling was an `also` payload beside the grant and
  is the whole node now, with `wrath_step_double`'s name, unit and single read site untouched, so
  AU §4's negative control still bites. **`dv_bulwark` WAS NOT TOUCHED IN THE WAY A RE-AUTHOR WOULD
  REACH FOR**: CV ruled its 5% party heal UNCONDITIONAL, and that ruling lives in the ABILITY'S
  text in `Classes.pending_talent_ability`, which DO did not open. The card moved by NAME only.
- **EIGHT CLAUSE-CUTS, AND THE PAYLOAD TERM GOES WITH THE TEXT — EXCEPT ONCE.**
  `sm_blade_dance`, `wd_stomp_drill` and `wd_bannerman` lose their Shatterpoint / War Stomp /
  Interpose riders, and **`sunder_guard_bd`, `rallying_stomp_ranks` and `bulwark_line_ranks` are
  deleted outright** — field, payload and read site. **`bm_ancient_pact` IS THE EXCEPTION AND IT IS
  NOT A LOOPHOLE**: its single `ancient_pact` flag carries BOTH halves and `battle.gd` refuses ALL
  healing rather than naming a source, so Spirit Bond appeared in an illustrative list and there
  was **no payload term to remove**. Removing `ancient_pact` would have deleted the node.
  **FOUR MORE CUTS CAME FROM THE MOVE ITSELF**: `dv_waters` and `dv_pulse` stop reading Sacred
  Resolve's banner, `sm_seasoned_node` stops sharpening Lunge, and `ar_conduit` is **RE-POINTED
  rather than cut** — its partner is still a node in its own tree, renamed **Unchained**.
- **`sm_precision` WAS WORSE THAN THE BRIEF THOUGHT, AND THIS BATCH IS WHY.** It read Dazed,
  Crippled and Exposed; Dazed came only from Charge or Sweeping Strikes (both drawn), and Crippled
  and Exposed only from `sm_lunge` — **which left the tree in this same batch, taking the last
  non-drawn source with it.** So "cutting Dazed may be the whole repair" was true when written and
  false by the time the repair was made. **Re-pointed onto STUNNED, which Pommel Strike applies and
  Pommel Strike is PROTECTED CORE**; the `battle.gd` read site moved with the text.
- **A HOLE OPEN SINCE BATCH CL IS CLOSED AS A SIDE EFFECT, AND `check_cz`'s OWN FAILURE MESSAGE IS
  THE ONE THAT CAME TRUE.** The Batch CL enumeration reached **211 of 216**; the five it missed —
  Backdraft, Pyroblast, Glacial Prison, Cryoclasm, Intercession — were talent grants living in no
  pool. **All five are in a draft pool now, so the two walks agree.** §0's assertion read *"%s IS
  in the CL walk — §0's premise has changed and the report is stale"*, had never fired in eight
  batches, and is **INVERTED rather than deleted**.
- **NINE ABILITIES LOST THEIR UPGRADED VARIANT, AND THAT IS RECORDED RATHER THAN HIDDEN.** An
  `upgrade` arm fires only where a node's grant COLLIDES with an earned copy, so
  `battle_shout_node`, `lunge_upgraded`, `execute_upgraded`, `hold_line_upgraded`,
  `rampage_upgraded`, `overcharge_extra`, `intercession_long`, `resolve_extra_turns` and
  `bulwark_extra_turns` are **read-only-zero**. **The fields and their read sites are LEFT
  STANDING** — each reads a BASE beside it, deleting a branch is deleting a mechanic, and two are
  already in `runes.gd`'s `STAT_INT_KEYS`. **The suites DRIVE those branches from the test rather
  than leaving them unreachable and unproved.**
- **ONE CARD TEXT MOVED, AND IT CLOSES A DEFECT THIS FILE HAS CARRIED SINCE DM.** Battle Shout's
  `description` promised *"+12% … Lasts 3 turns"* — index **1** of `[8, 12, 18]`, the magnitudes
  the NODE paid. A pool pick has always paid **+8% for 2 turns**. There is one magnitude now and
  **the card states it**. The "one description for three magnitudes" thread is closed by
  subtraction rather than by authoring.
- **NO NODE MOVED ROW OR LANE, SO NO SAVE MIGRATION IS NEEDED AND `Profile` IS STILL v2.**
  `Talents.cells_spent` prices each owned cell off the row it CURRENTLY sits in, and DN measured a
  MOVE driving a full Berserker ledger to **−2 available points**, silently. **`check_do` §3
  asserts all twenty-five re-authored cells are in their original lane and row.**
- **THE `owns_ability` PAYLOAD CONDITION NOW HAS ZERO LIVE USERS.** The three riders DO cut were
  the only ones. **The condition kind and `Talents.owns_ability` are KEPT and still tested**
  (`test_batch_ai`) — deleting a condition kind is a design change, and it is the natural mechanism
  for a rune.
- **ONE NEW GATE, `check_do.gd`, IN `GATES`, WITH A BASELINE ROW.** It asserts the PROPERTY and
  PRINTS the count — DN's own gate asserted a NUMBER and its first battery caught it. **It reads
  only the SPEC draft pool, never the class one, so it needs no `check_da` `WALK_EXEMPT` entry at
  all** — better than having one, and DN's lesson paid forward. Its first draft went `check_da`
  37/2 anyway, because **its header NAMED the forbidden call in a sentence saying it did not make
  it**, which is the self-accusation trap `check_da`'s own header warns about.
- **Next letter: DP.** `DP` sorts after `DO`, so the stamp gates still work.
- **Phase.** The ability draft is **COMPLETE at 142 of 142** and all twelve talent trees are
  purpose-authored and charter-clean. Recent batches are correction and consolidation: the talent
  audit (CU/CV), the documentation split (CW), the archive cut (CX), the tempo rule (CY), CZ's two
  ramp repairs, DA's correction of one of them, DB's and DD's `_spawn` consolidations, DC's
  threshold repairs, DE's move of the count differ into the runner, DF's sort of the 47, DG's close
  of the ten, DH's nine cross-spec clauses, DI's payment of the plumbing debt, DJ's close of the
  half DI would not take, DK's ruling on the eleven, DL's close of the clause DK recorded as owed,
  DM's close of the ally/hero thread, DN's sizing of the talent charter, **and DO's settling and
  implementation of it.**

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION

**THE ALLY/HERO THREAD IS CLOSED AND NOTHING FROM IT IS CORRECTNESS-SHAPED ANY MORE.** What is
below is design, prose, and the standing owed items.

### THE TALENT CHARTER — SETTLED AND IMPLEMENTED AT DO; WHAT IS LEFT IS SIX STATUS BETS

**The charter question is closed.** Full evidence: `docs/talent-audit.html` §8 and
`docs/reports/DO.md`. What follows is what DO deliberately did NOT rule on.

- **SIX NODE/STATUS PAIRS WENT FROM PERMITTED TO FORBIDDEN WITHOUT A CHARACTER OF THEIR TEXT
  CHANGING, AND THEY ARE THIS BATCH'S OWN COST.** **Psychosis and Hysteria have no applier in the
  game but Mind Flay and Mass Hysteria**, and DO moved both into the draft — so `oc_spread`,
  `oc_whispers`, `oc_delirium` and `oc_permanent` now read a status the Occultist cannot guarantee.
  **Before DO those were TREE-INTERNAL dependencies, which the charter explicitly permits** (a
  cross-row dependency bets on a node the player CHOOSES, not on a card they are DEALT).
  **The brief says "report the list; rule on nothing", so nothing is ruled** — but the cost is the
  ruling's, not an oversight.
  - **`oc_delirium` and `oc_permanent` also name Bewitched, which IS core**, so both still work
    without the draw. They are the §2 "cut the bonus clause" shape and would be a REWORD.
  - **`oc_spread` and `oc_whispers` are whole-node bets** and would need re-authoring. Re-pointing
    them off Psychosis and onto Bewitchment is a re-author of the Madness lane's whole subject,
    which is why it was not taken quietly.
- **AND SIX MORE PAIRS ARE PRE-EXISTING, FOUND BY THE SAME SWEEP AND ALSO NOT RULED ON:**
  `sm_guarded` (Crippled, Exposed), `sv_virulence` (Exposed), `ss_exposed_nerve` (Exposed) and
  `ss_no_cover` (Dazed, Blind). **`check_do` §4 prints all twelve on every battery run** and
  asserts only `sm_precision`, which the brief singled out.
- **THE `owns_ability` PAYLOAD CONDITION HAS NO USER LEFT.** Kept and still tested; deleting a
  condition kind is a design change and it is the natural mechanism for a rune.
- **TWO ABILITIES RUN A SKILL CHECK AND ADVERTISE NO PERFECT, INSIDE A DRAFT POOL FOR THE FIRST
  TIME.** `Rampage` and `Pyroblast` are two of the six `test_batch_cp.CHECK_WITHOUT_PERFECT` names
  — a population that predates CN — and DO brought them into `test_batch_bo` §5's reach without
  creating them. **Both are NAMED exemptions there rather than suppressed**, and authoring a
  Perfect bonus for either is a design decision. **A THIRD name reaching that loop still trips.**
- **FIVE NODES ARE NAMED AFTER LIVE ABILITIES AND DO ADDED NO SIXTH** — Second Wind, Spite, Rally,
  Killing Frost, Divine Presence. That is the `wd_spiked`/Spite trap DN documented, and it is why
  the Arcanist's row-4 Resonance cell is **Overdraw** rather than Overcharge. Renaming the existing
  five is a save-format question and a separate pass.
- **DN'S OTHER TWO FINDINGS ARE UNTOUCHED AND STILL OPEN.** (1) **The three-lane restructure needs
  97 NEW nodes** — 30% of the layer — and **two specs hold a lane at zero** (the Cleric has no
  offensive node in 27, the Sharpshooter no defensive one), which no shrinking of the tree rescues.
  (2) **The saved-allocation drift is real, silent and cheap**: `Profile` is v2, the load is
  TOLERANT, and there is no version a migration could hang on. **DO needed neither, because nothing
  moved a cell** — but a restructure would need both.

### THE FLAKE THAT DG FOUND, AND IT HAS NOW READ QUIET TEN TIMES RUNNING

- **`test_batch_at`'s §1 LIVE DAMAGE-CURVE RATIO IS UNSEEDED. IT WENT RED AT DG AND HAS READ 0 IN
  EVERY BATTERY SINCE — DH, DI, DJ, DK, DL AND DM — STILL OPEN, STILL UNSEEDED.** At a rate of about
  one red in eighteen, ten quiet readings is the common case and proves nothing. `_live_curve()`
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
- **THE POOL-PICK BATTLE SHOUT HALF IS CLOSED AT DO, BY SUBTRACTION RATHER THAN BY AUTHORING.**
  It read: one `description` in the project for three magnitudes, a pick paying +8% for 2 turns
  while the card promised +12% for 3. `battle_shout_node` indexed `[8, 12, 18]`, and **no talent
  grants any more, so it is read-only-zero — there is ONE magnitude and the card states it.**
  The Hold the Line half of this family is closed the same way: its UPGRADED card was written by a
  collision that can no longer happen, and `check_dm` asserts it ABSENT.
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
- **THE ABILITY CORPUS IS 216 AND THE TWO WALKS NOW AGREE.** The Batch CL enumeration reached
  **211** for as long as talents granted abilities; the five it missed — Backdraft, Pyroblast,
  Glacial Prison, Cryoclasm, Intercession — were talent grants living in no pool. **DO put all
  twenty-two talent grants into `SPEC_DRAFT_POOLS`, which the CL walk reads, so it reaches all 216
  and `Classes.talent_granted_names()` is EMPTY.** `check_cz` §0 asserts the agreement — its old
  assertion is INVERTED, not deleted, so a card put back outside every pool is still caught.
  **`check_da` §3 asserts that no gate hand-rolls the walk**, with `check_cz`'s `_cl_only_corpus`
  named as the one deliberate exemption (its REASON string was corrected at DO: its job inverted
  with the premise).
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
- **The ability draft is COMPLETE at 142 of 142** — `SPEC_DRAFT_POOLS` is **118** and
  `CLASS_DRAFT_POOLS` is **24** (4 classes × 6), counted out of `classes.gd`. **The spec half is no
  longer a flat multiple**: DO's twenty-two ex-talent-grants took nine pools past eight and left
  three at exactly eight. **The one authoritative per-spec table is `test_batch_cd.PER_SPEC_DEPTH`;
  every other suite asserts the FLOOR (>= 8) and the TOTAL.** Do not write `12 * 8` again.
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

### THE TEST TREE, AS OF DO

- **47 `test_*.gd` files**: 44 `test_batch_*` spanning `ah` to `cp` (with gaps — they are NOT one
  per batch), plus `test_run_harness`, `test_runes` and `test_rune_battle`. **They live at the repo
  ROOT, not in `scripts/`.**
- **`_spawn` IS AUTHORED ONCE, IN `suite_fixture.gd`, AND 37 SUITES GO THROUGH IT.** `_kill` too, in
  14. Each suite keeps its OWN `_spawn` SIGNATURE and delegates, so **all 389 call sites are
  untouched.**
- **`run_battery.sh` RUNS 46 SUITES AND MISSES NONE.** The `GATES` array is **twenty** — DO
  added `check_do`. **There are 27 `check_*.gd` files**, so **seven are not in `GATES`** — `check_ck_width`,
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
- **THE BASELINE TABLE IS `baselines.json` AND IT IS 71 ROWS: 46 suites, 20 gates, 2 scene runs
  and 3 harness gates.** DO added `check_do` and moved **seventeen** existing rows, every one with
  its reason written into the row. **DO NOT RESTATE ITS NUMBERS HERE OR IN `CLAUDE.md`** — a second copy of a
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

**TWO BATTERIES AT DO, BOTH ON A FROZEN TREE. BATTERY 1 WAS THE DIAGNOSTIC AND IT FOUND 245
FAILURES ACROSS 30 TARGETS AND THREE THROWS; BATTERY 2 IS THE ACCEPTANCE RUN AND IT IS CLEAN.**
**140 files were MD5-stamped before battery 2 and re-compared after — the only two that moved are
`baselines.json` and `docs/state.md`**, and no suite reads either (`baselines.json` is read by
`check_de` alone; `test_batch_cd` mentions it in a comment and does not open it), which is exactly
what makes the differ re-runnable over a frozen log directory.

| | DN's acceptance | DO battery 1 | DO battery 2 (acceptance) |
|---|---|---|---|
| **suite failures** | 0 | 245 across 30 targets | **0** |
| **throws, grepped from the stream** | 0 | 3 (`ak`, `al`, `as`) | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | many | **0** |
| `check_de` | 293 / 0 / 0 | 293 / 45 / 6 | **297 / 0 / 0** |
| targets in the manifest | 71 | 72 | **72** |

**SEVENTY-TWO TARGETS RAN AND THE MANIFEST NAMES ALL SEVENTY-TWO. 0 `Parse Error` and 0
`SCRIPT ERROR` in every log.** `test_batch_an` read **6049**, inside its band.

**THE THREE THROWS WERE ONE FAULT.** All three suites applied a granting node's payload and then
read the ability out of `cfg["abilities"]`; with nothing granted the array is empty. **A suite that
needs a moved card now EARNS it**, through `suite_fixture`'s existing `bm` option — which is what a
player does.

**ONE ROW MOVED AFTER THE RUN AND THE CODE DID NOT.** `check_de` read **297 / 1** in the battery:
*"test_batch_bm FELL to 1888 checks, recorded 1891"* — a fall with zero failures, in a suite DO
never edited. Its §1 row-8 duplicate-detector emits one check per **TOP-LEVEL `payload.stat`
field** of every rows-1-to-7 node in a row-8 node's own lane, and **three mid-tree cells stopped
writing one because DO re-authored them onto a PROTECTED CORE ability**: `cr_icy_resolve`,
`bm_devoted_fury` and `bm_reserves`. **Measured rather than reasoned: the loop reads 238 live and
241 with the three restored — a delta of exactly 3.** The `also`-borne terms DO also cut do not
appear, because the loop reads the top level only. **The row moved with that reason and the differ,
re-run over the same frozen logs, reads 297 / 0 / 0.** It was the one movement not predicted.

**EIGHT NEGATIVE CONTROLS, AND ALL EIGHT BIT** — the three cut terms restored, a grant put back on
`ar_wrath`, a cell MOVED from row 3 to row 7, `sm_precision`'s Dazed restored, Backdraft pulled
from its draft pool, and a deliberate syntax error in `relics.gd` (26 `Parse Error` on the stderr
grep, 0 once reverted). Every probed file was restored from a **scratchpad copy** and re-compared
byte-for-byte — never `git checkout`.
**AND THE THIRD CONTROL FOUND A FAULT IN THE GATE RATHER THAN IN THE CODE**: arming the first made
`check_do` §3 report all THREE terms surviving, because the other two matched DO's own COMMENTS —
the prose recording a cut necessarily names what was cut. That is `check_da`'s self-accusation trap
in a second place; **the gate strips comment lines before the sweep now**, and only a negative
control could have shown it.

**THE LITERAL SWEEP: 9,948 literals at a floor of 4**, from all 74 suites and gates, evaluated
against **both** the `git show HEAD` and working versions of thirteen documents in one pass.
**52 LOST pairs, all accounted for** — almost all are definitions that moved from `talents.gd` into
`classes.gd` and appear in the GAINED list there; the rest are the three cut terms, the nine
read-only-zero flags, and two pins this batch deliberately INVERTED. **181 GAINED pairs, and the
dangerous kind is ZERO: all 254 negative `contains` assertions in the tree were cross-checked
against all 181 gained pairs and none collides.**

**THE CARD WIDTHS DID NOT MOVE**, by construction: the census counts `description` and
`perfect_text` lines over `classes.gd` and `talents.gd` together, and DO moved sixteen
`description` blocks from one to the other verbatim.

**AND THE ZERO IN THE FAILURE ROW IS NOT A REPAIR.** `test_batch_at`'s unseeded §1 ratio, `bo`'s §5
NULL FIELD flake and `test_rune_battle`'s pierce were quiet in both DO runs — the **tenth**
consecutive quiet reading. **All three are still open, still unseeded and still banded. A red from
any of them is not the next batch's.**
