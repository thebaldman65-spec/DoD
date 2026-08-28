# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

*Last rewritten: 2026-08-28 (Batch DR).*

---

## WHERE THE PROJECT IS

- **Last batch: DR — THE ENGINE/AXIS FRAMEWORK, AND THE SWORDMASTER'S POOL.** DQ's two grade-2
  dominations are both **repaired**, the most concentrated pool in the game is widened, and the
  framework the audit made visible is recorded as a standing rule. **The draft moved TWICE in one
  batch and the net is +1: 142 → 143** (119 spec + 24 class-wide). **Report: `docs/reports/DR.md`.**
- **THE FRAMEWORK, AND IT IS THE THING FUTURE POOLS ARE AUTHORED AGAINST.** In `CLAUDE.md`: **an
  ENGINE is the spec's own currency and is exclusive by construction; an AXIS is an effect type and
  is SHARED, deliberately. Adding axes to a spec does not dilute its identity — the engine still
  gates everything.** A pool covering few axes holds one build however strong its engine is, and
  depth of engine is not breadth of pool.
- **ONE OF THE THREE "EXCLUSIVE AXES" THE BRIEF NAMED WAS NOT ONE, AND THAT IS THE BATCH'S SHARPEST
  FINDING.** The brief held that cooldown manipulation is the Swordmaster's — *"Answering Steel and
  Battle Poise are the only cards in the game that do it"*. **`_tick_cooldowns` HAS SEVEN CALLERS**,
  one of them **BLINK, a MAGE CLASS-WIDE DRAFT CARD whose own comment names tempo as its axis**, and
  another **BLESSING OF ZEAL, the Devout's PROTECTED CORE**; the other three are talent nodes
  (Frostbound Hours, which ticks EVERY hero's; Practised Hands; Follow-Through). Five more sites
  clear a cooldown outright through `cooldowns.erase`. **The assertion was not authored**;
  `check_dr` §3 asserts the axis is SHARED and names all seven. **The rule it produced: before
  declaring an axis exclusive, derive the population that touches it — a one-door helper that "only
  two cards call" reads like a single owner and is not the same thing.**
- **THE TWO THAT SURVIVED VERIFICATION ARE ASSERTED AS PROPERTIES, NEVER AS COUNTS.** **COMPANION
  SUMMONING is the Beastmaster's** — `special: "summon"` is on exactly three abilities, all his
  protected core, and `_do_summon`'s only other caller is his own Call the Wilds. **REVIVAL is the
  Holy Cleric's AMONG ABILITIES, with a qualifier the gate prints**: `.revive(` has TWO callers,
  `resurrection` and the **REVIVE POTION**, and `events.gd`'s `revive_pct` is a third channel —
  exclusive as an ability, not as a channel.
- **FLASH FREEZE IS RETIRED AND THE COMMENT SUSPENDING THE RULE OVER IT WAS DELETED, NOT UPDATED.**
  Its handler and Glacial Prison's were the same three steps in the same order and Glacial Prison
  is better on all four columns. **Both of the suspension's stated reasons were already dead** —
  the acquisition channel at DO, the Perfect at CR — and neither batch touched the comment.
  **A DOCUMENTED EXCEPTION THAT OUTLIVES ITS JUSTIFICATIONS IS WORSE THAN AN UNDOCUMENTED ONE,
  BECAUSE IT READS AS DELIBERATE**, and that is now a trap in `CLAUDE.md`. **The MECHANIC is
  untouched**: four Chilled stacks still flash-freeze, which is `_apply_status`'s branch and
  belonged to no card. Cryomancer pool 12 → 11.
- **BATTLE POISE'S DEFENSIVE GUARD NOW BUYS SOMETHING, AND THAT IS WHAT ENDS THE SECOND
  DOMINATION.** Once a turn a parry lets him **GUARD CHANGE without spending an action** — a clause
  Answering Steel cannot have, because it has no requirement to reward. **It is the PIVOT alone**
  (Guard Change's 15 BD, **Sunder Guard's 40 BD to every enemy**, No Quarter and Tempo stay on that
  card — a Defensive build holding Sunder Guard and parrying twice a turn would otherwise land 80
  free Break across the field every turn), it is bounded to once a turn, the cooldown tick still
  pays on every parry, and **it asks `_ability_usable` about the REAL Guard Change**, so Formless
  refuses it and the 1-turn cooldown is respected at one door rather than two. **Answering Steel is
  untouched.** The pivot throws away **Discipline's** accumulation, like every other call to the
  one pivot.
- **THE SWORDMASTER'S POOL GOES 10 → 12 AND FOUR DECISIONS → EIGHT.** All three cards read the
  stance engine and BW's rule decides how.
  - **LUNGE, RE-AUTHORED ONTO BREAK.** An entire Breaker lane is built around a window and **not
    one draft card opened it**. **Cooldown 0 → 3** (it was one of only two repeatable draft cards
    in the game) and **the guard decides where the Break lands**: Aggressive puts 15 more into one
    enemy, Defensive puts 12 on **every other** enemy. Damage 35 → 30; **Shatterpoint keeps its
    title at 40**. It stays an ordinary attack, so the crit, armour read, parry roll, Overwhelm,
    Off Balance and Whetstone all still apply.
  - **WHEELING CUT — AREA DAMAGE and SELF-MITIGATION, the card carrying two axes.** 30/2.5/4cd,
    `aoe`, 20% of Attack and 12 Break to every enemy. A **reader**: from Aggressive he lands
    Defensive and arrives holding **defence** (−20% damage taken, 3 turns); from Defensive he lands
    Aggressive and arrives holding **offence** (+20% dealt). Perfect: both at once.
  - **COUNTER TIME — CONTROL, on a pool that had none.** 25/2.0/5cd, **requires Defensive**, one
    enemy loses its next TWO turns and the card deals nothing. Pommel Strike is his only Stun and
    it is protected core. The boss rule is **inherited** (`stunned` is in `_apply_status`'s
    carve-out; nothing here passes `force`). It joins `RECAST_GATED`; Wheeling Cut deliberately
    does not, because a card that deals damage is never a wasted cast.
- **THE BRIEF SAID SHATTERPOINT IS A TALENT AND IT IS NOT** — it is a `SPEC_POOLS` boss pick (and a
  `CLASS_POOLS["warrior"]` one). The substantive point survived: no *draft* card opened the Break
  window, and the lane depended on an offer he may never see.
- **AND ONE MORE STALE COUNT, FOUND WHILE REMOVING SOMETHING ELSE.** `_hold_freeze`'s header said
  **THREE callers** while DO's Cryoclasm had made it four, and named a `force` argument **no caller
  has passed since CR**. Corrected with its reason. Same species as the comment §2 deleted, three
  hundred lines away, and neither was findable from the other.
- **Next letter: DS.** `DS` sorts after `DR`, so the stamp gates still work.
- **Phase.** The ability draft is **COMPLETE at 143 of 143** and all twelve talent trees are
  purpose-authored and charter-clean. Recent batches are correction and consolidation: DN's sizing
  of the talent charter, DO's settling and implementation of it, DP's payment of the cost DO's own
  ruling created, DQ's audit of whether the pools those two reshaped hold more than one build each,
  **and DR's ruling on the two things that audit found were correctness rather than taste.**

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION

### THE DRAFT AUDIT — TWO FINDINGS RULED AT DR, THE REST STILL OPEN

**Full evidence: `docs/draft-audit.html` (both grade-2 findings now carry a RESOLVED banner) and
`docs/reports/DQ.md`.** Everything below is still open and **no gate encodes any of it**, because
a gate encodes a ruling.

- **THE TWO GRADE-2 FINDINGS ARE CLOSED.** Flash Freeze ← Glacial Prison was answered by
  **retirement**; Battle Poise ← Answering Steel by **differentiation**. `check_dr` §4 and §6 pin
  both, and §4 asserts the SURVIVOR of the pair is still there — retiring the wrong half would
  pass every other assertion.
- **THE COOLDOWN-ZERO QUESTION IS HALF ANSWERED AND SHOULD NOT STAY OPEN.** **Lunge is off the
  list; PYROBLAST IS STILL ON IT** and is now the only repeatable draft card in the game.
  `check_dr` §5 prints the live list every battery run. Either price it as a draft card or write
  down that a repeatable card is a legitimate draft shape.
- **THE OTHER CONCENTRATION FINDINGS ARE DESIGN AND ARE UNRULED.** The Beastmaster's 8-of-8
  companion binding, the Cryomancer's remaining **11-of-11** ice and the Pyromancer's 12-of-13 Burn
  are all reported with their card lists. **THE HUNTER CLASS IS THE STRUCTURAL ONE AND IT IS
  BIGGER THAN THE SWORDMASTER'S WAS**: three shallowest pools (8 each), none of DO's twenty-two,
  and **not one of the twenty-four Hunter spec cards is a heal, a shield or hero-side mitigation**.
  It compounds with the Sharpshooter having no defensive node in his 27. **It is next, not now.**
- **`SPEC_POOLS` STILL HOLDS LUNGE AND EXECUTE ALONGSIDE THE DRAFT POOL**, so both are reachable
  through two channels. Reported at DR, out of its scope, and worth a ruling with the rest of the
  boss-pick pools DQ dumped and did not audit.
- **`icy_resolve_ranks` IS A TENTH READ-ONLY-ZERO FIELD AND DO's COMMENT NAMES NINE.** Correcting
  the count is one line in `classes.gd`; deleting the field is a mechanic deletion and is not
  proposed. **Nothing is wrong at runtime.**
- **THREE OF THE FIVE NODES NAMED AFTER LIVE ABILITIES SHARE A DRAW SPACE WITH THEIR NAMESAKE** —
  Killing Frost, Divine Presence and Rally — and the node does something different from the card in
  all three. **Renaming the node ids is a save-format question; renaming their DISPLAY names is
  not, and it is one line each.**
- **WHAT THE AUDIT DID NOT REACH, STATED SO IT IS NOT READ AS CLEAN.** No sim was run and no balance
  was judged. **Enemy abilities, relics, runes and items were not compared against draft cards at
  all**, and the rune half is a live question — two runes already grant a card their own hero can
  draft. **The boss-pick pools were dumped but not audited.** `perfect_id` bonuses were read but
  not compared as a population.

### THE TALENT CHARTER — SETTLED AT DO, ITS STATUS HALF RULED AT DP

**The charter question is closed and so is its status half.** Full evidence:
`docs/talent-audit.html` §8, `docs/reports/DO.md` and `docs/reports/DP.md`.
**THE STANDING RULE, IN `CLAUDE.md`:** *a talent may not read a status the spec has no guaranteed
way to apply. The ability rule and the status rule are the same rule.*

- **DO's SIX PAIRS ARE RULED AND GONE.** All four Occultist Madness cells are re-pointed onto Ruin
  — see the block above for what each now reads. **`check_dp` §1 asserts the property on every
  battery run and prints the live count.**
- **SIX PRE-EXISTING PAIRS REMAIN, REPORTED AND RULED ON NOWHERE, AND FOUR ARE NOT BETS.**
  `sm_guarded` (Crippled, Exposed) is the only real one and is a bonus clause gated on a
  tree-internal node, beside an unconditional base clause. `sv_virulence` and `ss_exposed_nerve`
  each APPLY the Exposed they read. `ss_no_cover` reads Blind and Dazed **on the hero**, applied by
  enemies — an immunity, not a payoff. **Each is in `check_dp.KNOWN_PAIRS` with its reason**, so
  the next batch reads why rather than re-deriving it.
- **THE MAGNITUDES ARE THE ONE THING DP AUTHORED AND THEY ARE UNMEASURED.** Spread of Madness
  keeps 60/2 and Delirium keeps 3, so the Whispering Dark's +15/+1 keeps its proportion; Whispers's
  +2 doubles a base of 2 as its old +45 nearly doubled a base of 50. **Spread and Whispers BOTH
  feed generation and a player can hold both** (rows 1 and 2 of one lane), which is **the number
  most worth a sim** — and no sim has run since DK, so every sim figure below was already stale.
- **RUINED MIND IS SCOPED TO BEWITCH ALONE, AND WIDENING IT IS A DECISION.** Extending the boss
  exception to Psychosis and Hysteria would be a BONUS rather than a bet (Bewitch carries the node
  on its own) — but a clause the text does not state is DM's seventh family.
- **TWO RUNE DESCS ARE OWED A SENTENCE.** Binding Souls and the Flayed Mind both open
  "Grants …", which is wrong whenever the card was drafted. **The Rune of the Last Rites is the one
  that says so honestly** ("She already knows Resurrection, so this hones it instead"), and it is
  the model for the other two. One line each.
- **RUINED MIND AND LINGERING TORMENT ARE NO LONGER IN TENSION, AND THAT WAS NEVER WRITTEN DOWN.**
  `oc_torment` fires on an EXPIRING madness effect; the old Permanent Delusion made his madness
  never expire, so the row-7 and row-8 cells cancelled each other. **That is gone now** — worth
  knowing, because nobody had recorded that they collided.
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

### THE FLAKE THAT DG FOUND, AND IT HAS NOW READ QUIET FIFTEEN TIMES RUNNING

- **`test_batch_at`'s §1 LIVE DAMAGE-CURVE RATIO IS UNSEEDED. IT WENT RED AT DG AND HAS READ 0 IN
  EVERY BATTERY SINCE — DH THROUGH DR, BOTH OF DR'S TWO — STILL OPEN, STILL UNSEEDED.** At a rate
  of about one red in eighteen, fifteen quiet readings is the common case and proves nothing. `_live_curve()`
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
- **`_apply_status`'s `src` COVERAGE IS 106 OF 203, AND THE REMAINING 97 ARE OWED.** DI stamped the
  36 sites that can apply a status **Harvest reads** and DJ added the seven companion sites; the
  rest apply buffs, marks and hero-side wards, so **nothing currently mis-credits off them**.
  **Do not quote this figure without re-deriving it** — `check_di` §1 walks the file and PRINTS the
  live count on every battery run. **DP MOVED THE DENOMINATOR AND NOT THE NUMERATOR**: the
  re-pointed Spread of Madness deleted `_apply_status(infected, "psychosis", 3)`, an UNSTAMPED
  site, so coverage improved without a single `src` being added. **`check_di`'s `CALL_SITES`
  equality caught it and that is what the equality is for** — a tripwire saying the ground has
  moved, where its sibling `SRC_FLOOR` is deliberately a ratchet because that one measures
  progress. **IT CAUGHT DR TOO, AND DR PREDICTED IT**: `CALL_SITES` is **205** now and
  `with_src` is still 106, so the unstamped remainder is **99**. Net +2 — the retired card's
  STAMPED `chilled` application went with it, and three arrived (Wheeling Cut's two grants, which
  are hero self-buffs and correctly unstamped, and Counter Time's Stun, which passes its
  `attacker` and exactly replaces the stamped site the retirement took). **The reason is in the
  gate's own comment, which is what that const's header demands of a batch that moves it.**
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
- **`CLAUDE.md` IS STILL OVER CW's OWN TARGET, AND THE RATIO FELL FOR THE FIRST TIME.** CW set
  *"under 3% of the knowledge sync and roughly flat over time"*. It reads **225 KiB of a 6.61 MiB
  sync = 3.33%**, down from 3.39% at DP — **not because the file shrank but because DQ added no
  rule while the sync grew** (3.25% at DI, 3.30% at DJ, 3.34% at DK, 3.39% at DL, 3.42% at DM,
  3.39% at DP). **The "roughly flat" half is met; the "under 3%" half is not.** Not urgent;
  **worth a prune when a batch is in the file anyway**, and DG through DQ have all now declined
  it.
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
- **THE BASE-KIT CHECK IS DONE AS OF DQ AND THIS LINE RECORDS THE RESULT RATHER THAN THE DEBT.**
  All twelve spec pools were compared against their protected core kits. **No draft card shares a
  NAME or a `special` id with any core ability** — asserted, not assumed. **The overlaps are all at
  the behaviour level**, and the sharpest is **Killing Frost against Blizzard**: the drafted card is
  cheaper, faster, shorter on cooldown, higher in damage, lays a flat 2 Chilled against Blizzard's
  1–2 roll, and is gated in `_ability_usable` where Blizzard is not. **Mind Flay against Hex of
  Ruin**, **Rampage against Hack and Slash**, **Divine Plea against Heal**, **Cinderfall against
  Wildfire** and **Arcane Bolt / Unmaking against Death Ray** are the rest. **Reported in
  `docs/draft-audit.html` §6, ruled on nowhere.**
- **Two specs still take the generic talent fallback**, nine nodes between them.
- **`docs/text-audit.html` holds findings that have been ruled on and applied.** Once the designer
  confirms, it can leave the knowledge sync. **`docs/talent-audit.html` CANNOT: DN's §8 is an open
  question, not a closed one**, and the file went 37 → 165 KiB carrying it. **`docs/draft-audit.html`
  is NEW at DQ and cannot leave either** — every finding in it is open.

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
- **THE ABILITY CORPUS IS 217 AND THE TWO WALKS NOW AGREE.** DR moved it net +1 (one card
  retired, two authored). The Batch CL enumeration reached
  **211** for as long as talents granted abilities; the five it missed — Backdraft, Pyroblast,
  Glacial Prison, Cryoclasm, Intercession — were talent grants living in no pool. **DO put all
  twenty-two talent grants into `SPEC_DRAFT_POOLS`, which the CL walk reads, so it reaches all 216
  and `Classes.talent_granted_names()` is EMPTY.** `check_cz` §0 asserts the agreement — its old
  assertion is INVERTED, not deleted, so a card put back outside every pool is still caught.
  **`check_da` §3 asserts that no gate hand-rolls the walk**, with `check_cz`'s `_cl_only_corpus`
  named as the one deliberate exemption (its REASON string was corrected at DO: its job inverted
  with the premise).
- **`RECAST_GATED` HOLDS 60 ABILITIES** — DR's COUNTER TIME is the newest member, because its
  entire payload is a status and a recast onto a saturated field buys literally nothing.
  **WHEELING CUT DELIBERATELY DID NOT JOIN**: it deals real AoE damage and Break, so a recast is
  never wasted, which is why no damaging card is in that list. `check_co` refuses all but
  Interpose after saturation;
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
- **The ability draft is COMPLETE at 143 of 143** — `SPEC_DRAFT_POOLS` is **119** and
  `CLASS_DRAFT_POOLS` is **24** (4 classes × 6), counted out of `classes.gd`. **The spec half is no
  longer a flat multiple**: DO's twenty-two ex-talent-grants took nine pools past eight and left
  three at exactly eight, and **DR moved two of those nine — the Swordmaster to TWELVE and the
  Cryomancer down to ELEVEN**. **The one authoritative per-spec table is `test_batch_cd.PER_SPEC_DEPTH`;
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

### THE TEST TREE, AS OF DR

- **47 `test_*.gd` files**: 44 `test_batch_*` spanning `ah` to `cp` (with gaps — they are NOT one
  per batch), plus `test_run_harness`, `test_runes` and `test_rune_battle`. **They live at the repo
  ROOT, not in `scripts/`.**
- **`_spawn` IS AUTHORED ONCE, IN `suite_fixture.gd`, AND 37 SUITES GO THROUGH IT.** `_kill` too, in
  14. Each suite keeps its OWN `_spawn` SIGNATURE and delegates, so **all 389 call sites are
  untouched.**
- **`run_battery.sh` RUNS 46 SUITES AND MISSES NONE.** The `GATES` array is **twenty-two** —
  **DR added `check_dr`**, because DR ruled where DQ only reported. **There are 29 `check_*.gd`
  files**, so **seven are not in `GATES`** — `check_ck_width`,
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
- **THE BASELINE TABLE IS `baselines.json` AND IT IS 73 ROWS: 46 suites, 22 gates, 2 scene runs
  and 3 harness gates.** **DR ADDED `check_dr` AND MOVED FIVE ROWS** — `test_batch_bt`, `check_co`,
  and the three its own first battery NOTICED and it had not predicted (`bo`, `cb`, `ce`). **IT IS
  `indent=1` AND MUST BE RE-DUMPED THAT WAY** — Python's default churns 1742 lines for a
  four-line change. **DO NOT RESTATE ITS NUMBERS HERE OR IN `CLAUDE.md`** — a second copy of a
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
- **`test_batch_cd` IS 85 CHECKS AND DR MOVED ITS TABLE WITHOUT MOVING ITS COUNT** —
  `PER_SPEC_DEPTH` is the ONE authoritative per-spec table and DR's two movements (Swordmaster
  10 → 12, Cryomancer 12 → 11) cost one edit there and none in the eleven suites that assert only
  the FLOOR and the TOTAL, which is exactly what that centralisation is for. It is 85 checks (this prose said 72 from DG until DP corrected it; the pool
  sweeps grew with DO's twenty-two and nobody moved the sentence) and is the hygiene suite: the dead-symbol sweep, the
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
- **master.html stamp: `Last updated: 2026-08-28 (Batch DR)`** — DR moved the draft tables, the
  count, the retired card's row, Battle Poise's row, §6b's Lunge entry and added two card rows.

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
- **The live file starts at Batch CO and holds 30 entries** (CO → DR), **382 KiB**. **The 400 KiB
  threshold is now about eighteen KiB away** — DR's entry is 12 KiB. CX's cut point is CN/CO.
  **Re-derive this before acting on it; four batches running have now mis-predicted it, so the
  honest statement is that the NEXT ruling batch of DR's size probably reaches it and a
  documentation batch probably does not.**
- **`DoD-archive/changelog-archive.html` holds 131 entries** (Batch 1 → CN) and is **1042 KiB**.
- **Fourteen suites depend on a file that is not in version control** — bp, bq, br, bs, bt, bu,
  bv, bw, bx, cb, ce, bb, bn, bo. On a machine without `DoD-archive/` they FAIL LOUDLY, which is
  correct.

### Knowledge sync, re-measured at DR
*Measured over `.gd .md .html .json .py .sh`, excluding `assets/`, `.git/` and `.godot/`.
**Treat the file COUNT as method-dependent** — the walks have differed by one before, and the
SIZES are the comparable half. **ALL SIZES BELOW ARE KiB (1024 bytes)**.*
- **146 files, 6.71 MiB** (DQ measured 144 / 6.61 MiB). DR added `check_dr.gd` and
  `docs/reports/DR.md`, and grew `battle.gd`, `classes.gd`, `CLAUDE.md`, `master.html` and the
  changelog.
- Heaviest: `scripts/battle.gd` **1194**, `docs/changelog.html` **382**, `docs/design-notes.md`
  **350**, `docs/master.html` **329**, `scripts/classes.gd` **299**, `CLAUDE.md` **232**,
  `scripts/talents.gd` **179**, `scripts/unit.gd` **174**, `docs/talent-audit.html` **165**.
- **The 47 suite files total 1850 KiB — 26.9% of the sync**, still the single largest block. **They
  cannot be archived (they must be in the repo to run) but they CAN be deselected from the sync.**
  The **29** gates add **348 KiB**.
- **`CLAUDE.md` IS 232 KiB = 3.37% AND THE RATIO ROSE FOR THE FIRST TIME SINCE DL** (3.33% at DQ,
  3.39% at DP), because **DR added two standing rules and a trap** where DQ added none. CW's
  *"under 3% and roughly flat"* target is still met on the second half and missed on the first.
  DG through DR have all declined the prune.
- **`scripts/` contains ZERO test suites.** All game code.

---

## KNOWN-BROKEN AND DELIBERATELY UNFIXED

### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED

**DB measured 72 across 26 suites. DC repaired 23. DF sorted all 47 and repaired the 37 that were
STALE. DG closed the remaining ten.** **EVERY ACCEPTANCE BATTERY FROM DI FORWARD HAS READ ZERO
SUITE FAILURES FROM THE THREE FLAKES, AND THAT IS NOT A REPAIR.** `test_batch_at`'s unseeded ratio,
`bo`'s NULL FIELD flake and `test_rune_battle`'s pierce **all simply did not fire**, in any of
them. **All three are still open and still unseeded.** A row that reads clean at a rate of about
seventeen in eighteen has told you nothing when it reads clean.

**DR's BATTERY 1 READ ONE SUITE FAILURE AND IT WAS NOT ONE OF THE THREE, AND IT WAS NOT DR'S
EITHER.** `test_batch_bp` went 0 → 3 on a **latent draw collision that predates the batch**: §7
hand-builds a Warrior kit to reach the 7-slot cap and then TAKES `cands[1]`, a card drawn at random
from his live draft pool — and two of the three hand-written filler names, **LUNGE and EXECUTE,
have been IN that pool since DO**. A draw landing on either made the hand-built kit already own the
card the take is about, so `take_draft_ability` correctly returned *"already known"*. **DR's own
two new cards made the collision LESS likely, not more** (the pool went 10 → 12). **Repaired
before battery 2**: all three fillers are boss-pick cards now (Sweeping Strikes, Shatterpoint,
Rallying Shout), **none of them in ANY draft pool**, so no draw can collide — the durable fix
rather than swapping one draftable name for another. The check count does not move.

**THE COUNTS AND THE BANDS ARE IN `baselines.json` AND ARE NOT REPEATED HERE.**

### THE REST

- **`check_cm_live` reports 4 failures. THIS IS THE ONE RED THAT IS ON PURPOSE.** Identical on
  unmodified HEAD, recorded as owed in the gate itself. **DB confirmed the four are byte-identical
  before and after the gate consolidation; DC through DR confirm them again.** It is the only thing
  that presses the defensive bar.
- **AND CHECKS THAT PASS BY ACCIDENT ARE STILL WORSE THAN A RED.** `bs`'s `contains("BATCH XX")`
  against `CLAUDE.md` is the one on record and is the same one-line shape DF repaired in `bn`, `ce`
  and `br`. **The three vacuous exclusive-pair siblings in `as`, `at` and `aw` are the other live
  instances**, named at their sites and in the open queue above.
- **`test_batch_at` IS SEEDED IN PLACES AND NOT IN OTHERS**, and its check count is rock steady at
  **467** across every reading including both of DR's.
- **`test_batch_bo` STILL HAS ITS FLAKY ASSERTION.** Its count is **1070** since DR moved it with
  the pool; the §5 NULL FIELD check requires `deep < shallow` and the damage carries a 0.9–1.1
  variance roll, so both can land on the same integer. `test_batch_bo.gd` calls `seed()` zero
  times.
- **THE SUITES THAT DRIFT IN THEIR CHECK COUNT, AND THE OBSERVATION COUNT EACH BAND RESTS ON.**
  **The bands are in `baselines.json`, with the observation count beside each.**
  **THE RULE, ASYMMETRIC ON PURPOSE: floor = the lowest observation, ceiling = the highest PLUS the
  observed spread** — the floor is the half that catches a real fault, so it stays tight and the
  ceiling takes the headroom. **`check_de` RUNS on that asymmetry: it asserts the floor and reports
  a rise as a notice**, and **DR's battery 1 is the case that shape exists for** — three rows rose
  because their own loops walk the draft pool, and the differ said so as NOTICES rather than reds.
  - **`an` read 6053 then 6051 across DR's two batteries**, comfortably inside its band, and DR
    moved nothing there.
  - **`bk` is NOT widened**, because it has not been exceeded: headroom goes where a reading demands
    it. It read **129**.
- **`check_map` is NOT a hang** — 99% CPU for ~5 minutes. The battery gives it a 600s bound.
- **`check_parse` does not cover the test suites.** It walks `res://scripts` and `res://scenes`
  only. **It does not cover the GATES, `gate_fixture.gd` or `suite_fixture.gd` either** — but a
  broken suite fixture fails 37 suites loudly, and **DR parse-checked its edits with a negative
  control proving the check bites** (a deliberate `func _dr_negative_control(:` produced
  `Parse Error: Expected parameter name.`, and the tree read clean again once restored **from a
  scratchpad backup rather than by `git checkout`**).
- **A GATE THAT EXITS 0 IS NOT A GATE THAT PASSED.** **A `--script` target whose base class does not
  resolve prints `Parse Error`, runs not one line, and exits 0.** Grep the stderr; never trust the
  tally and never trust `$?`. **`run_battery.sh`'s `throws=` column is the only thing standing
  between this fault and a green report.**
- **The `_hint_done` / `_skill_done` deadlock is real and is NOT currently biting.** Both
  skill-check orientation cards `await` a signal only a real click or key press emits. **A future
  headless modal will hit this again** — `_nobody_can_press()` is the one place the question is
  asked, and a Profile flag is not a bot guard.

### Last measurements

**TWO BATTERIES AT DR. BATTERY 2 IS THE ACCEPTANCE RUN BECAUSE IT CAME BACK CLEAN.**
**161 files were MD5-stamped before it and re-compared after, and NOT ONE MOVED.**
**Battery 1 was NOT discarded** — it is what found `test_batch_bp`'s latent draw collision and the
three baseline rows DR had not predicted, and both were repaired or recorded before battery 2.
**The documents written after the acceptance run — `docs/state.md`, `docs/reports/DR.md`,
`docs/draft-audit.html`'s resolution banners and `docs/design-notes.md`'s entry — are read by no
suite and by no gate**, which is the same allowance DP and DQ used.

| | DQ's acceptance | DR battery 1 | DR battery 2 (acceptance) |
|---|---|---|---|
| **suite failures** | 0 | **3** (`bp`, pre-existing, repaired) | **0** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 301 / 0 / 0 | 305 / 1 / 3 | **305 / 0 / 0 — exactly the prediction** |
| targets in the manifest | 73 | 74 | **74** |

**SEVENTY-FOUR TARGETS RAN AND THE MANIFEST NAMES ALL SEVENTY-FOUR. 0 `Parse Error` and 0
`SCRIPT ERROR` in every log.** `test_batch_an` read **6051**, inside its band; `test_batch_bk` read
**129**, likewise. Harness gates **22 / 165 / 8**, `check_ct_map` 83 / 0, `check_dr` **79 / 0**.

**FIVE BASELINE ROWS MOVED AND DR PREDICTED TWO OF THEM.** Predicted: `test_batch_bt` 458 → **407**
and `check_co` 297 → **301**, plus the new `check_dr` row and `check_de` 301 → **305** (four
assertions per target, one target added). **UNPREDICTED, AND BATTERY 1's NOTICES ARE WHAT CAUGHT
THEM: `test_batch_bo` 1064 → 1070, `test_batch_cb` 1196 → 1197, `test_batch_ce` 1138 → 1139** —
all three are their own loops walking the net +1 draft card, and all three moved in the batch that
caused them. **`check_di`'s `CALL_SITES` equality also tripped in battery 1 and DR HAD predicted
it**: 203 → **205**, with the reason written into the gate's own comment as that const's header
demands.

**AND THE ZERO IN THE FAILURE ROW IS STILL NOT A REPAIR.** `test_batch_at`'s unseeded §1 ratio
(read 467), `bo`'s §5 NULL FIELD flake (read 1070) and `test_rune_battle`'s pierce (read 97) were
quiet again in both runs — the **fifteenth** consecutive quiet reading. **All three are still open,
still unseeded and still banded. A red from any of them is not the next batch's.** At a rate of
about one in eighteen, fifteen quiet readings is the common case and proves nothing.

**FOUR NEGATIVE CONTROLS WERE RUN AND ALL FOUR BEHAVED.** A `special: "summon"` authored onto the
Sharpshooter (1 failure), a third `.revive(` call site (1), a `_tick_cooldowns` caller removed (1),
and **the comment-stripping trap controlled from BOTH sides** — the retired card's name put back as
a COMMENT left `check_dr` GREEN, the same name put back in CODE turned it RED (4 failures). **That
last pair is the one that mattered**: this batch's own `classes.gd` prose records the retirement by
naming the card, so an un-stripped absence check would have read the record as the removal not
having happened.

**THE LITERAL SWEEP: 10,415 literals at a floor of 4**, from all 78 suites and gates, evaluated
against twenty documents and sources and diffed against `git show HEAD` in one pass. **7 LOST and
every one is accounted for** — two were in the retired card's SYNERGY comment and are read by
`test_batch_as`'s node table against `talents.gd`, one was Lunge's old description and is read by
`check_do`'s `STATUS_FORMS` against `Talents.desc_for` output, one is a `scene.call` string rather
than a source `contains`, and the remaining two are **`check_dr`'s own NEGATIVE needles**, whose
absence IS the assertion. **No document edit lost a single literal.** **69 GAINED and the dangerous
kind is zero**: every negative `contains` in the tree was cross-referenced against the gained set,
five matched, and all five are **scoped to a slice or read the runtime combat log** rather than a
whole document.

**THE COMMENT-STRIPPED DIFF WAS TAKEN, WHICH IS HOW "NO COMMENT INSERT ATE CODE" IS PROVED.** With
every line-leading `#` stripped, `battle.gd` lost **17** code lines and gained 93; all seventeen are
the retired handler (13) plus four lines deliberately replaced. `classes.gd`'s losses are the
retired def and pool entry and three replaced descriptions. **Nothing was swallowed.**
