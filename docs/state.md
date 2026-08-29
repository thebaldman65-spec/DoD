# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

*Last rewritten: 2026-08-29 (Batch DT).*

---

## WHERE THE PROJECT IS

- **Last batch: DT — LOOSE ENDS.** Four items, **no new play, no magnitude moved and no card
  authored.** A gate for the two DS specials nothing covered, the second of the three flakes
  seeded, and two reports. **Report: `docs/reports/DT.md`.**
- **`check_ds.gd` IS THE PERMANENT COPY OF DS'S THROWAWAY FIXTURE — 57 checks, 4 negative
  controls, and `GATES` goes 22 → 23.** `bring_it_down` and `heads_down` had no live coverage at
  all. **BRING IT DOWN IS MEASURED RATHER THAN ASSERTED** — 10 seeded Warden strikes read 8526
  plain against 10233 under the capped +20%, ratio **1.2002** — because a status stamped in one
  place and read three thousand lines away is exactly DK's Empower shape. **A THIRD ARM STRIPS THE
  AMP FROM THE STRIKER ALONE AND REQUIRES THE RATIO BACK AT 1.0**, and the control that replaced
  the per-wearer read with a party-wide global **passed both other arms and failed only that one.**
- **AND THE HEADS DOWN ASSERTION IS THE ONE A STATIC CHECK COULD NOT MAKE.** Both versions of the
  card refuse abilities, name a criterion and log a fallback; the only thing that separates the
  shipped identity test from the `cost > 0` fault is **how many REFUSED abilities cost nothing**.
  The gate walks a live kit through `_intent_ability_usable` and asserts that count is positive.
  **Derived on every run, not quoted: 46 of 50 enemy abilities are free, and 14 of the 21 KITS
  carry a zero-cost damaging ability that is not the basic** — those are the kits a cost test
  suppresses nothing on. The control put the fault back and the raider read **"2 kept, 0 refused"**.
- **THE GATE TRIPPED `check_da` §3 ON ITS FIRST RUN, ON ITS OWN COMMENT, AND NO EXEMPTION WAS
  GRANTED.** The header named both fingerprint strings in the course of explaining that the gate
  does not use them. **An exemption granted to a sentence blinds the rule to a real walk arriving
  in that file later** — the names came out of the prose instead. The rule is in `CLAUDE.md` beside
  the comments-record-removals one it mirrors.
- **WHAT THE GAP WAS, DERIVED RATHER THAN QUOTED.** The three Hunter specs held the three
  **shallowest pools in the game** (8 apiece; next was the Warden's 9), received **none** of DO's
  twenty-two, and **not one of their twenty-four spec cards was a heal, a shield or hero-side
  mitigation** — a hunter's whole defensive option set for a run was two of the six Hunter class
  cards he had to be lucky enough to be offered. It compounded with the Sharpshooter holding no
  defensive node in his 27.
- **SIX CARDS, TWO PER SPEC, EACH READING ITS OWN ENGINE** — DR's rule applied, not a new one:
  MIT-SELF is a shared AXIS and adding it dilutes nothing, because the engine still gates all of it.
  - **BEAR THE BRUNT** (Beastmaster, MIT-SELF) — the next blow that would fell HIM is refused and
    his deepest bond takes all of it. **It is BLOODBOND inverted clause for clause** — same placed
    guard, same battle-long duration, same "and it can kill the payer", opposite direction.
  - **BRING IT DOWN** (Beastmaster, AMP-TEAM) — 4 turns, every hero +2% damage per Loyalty stack on
    his deepest bond, cap +20%, **snapshot at cast and the bond is not spent**. AMP-TEAM was absent
    from all twenty-four, and it makes an 8-of-8 engine binding pay the other three heroes.
  - **DUG IN** (Sharpshooter, MIT-SELF) — 4 turns, damage taken cut by a quarter of whatever Focus
    stands **at the blow**, cap 25%. Read live, so it rises as he commits and **falls to nothing
    when a switch breaks the meter**. Deliberately NOT evasion: Camouflage and Ghillie Suit already
    stack, and Camouflage's own header reserves evasion as the class's shape.
  - **HEADS DOWN** (Sharpshooter, CTRL) — 20 dmg / 8 BD, and 3 turns (Perfect: 4) in which that
    enemy can bring nothing but its basic attack to bear. **THE FIRST SILENCE IN THE PROJECT.**
  - **THICK HIDE** (Survivalist, MIT-SELF) — 4 turns, 6% less damage per DIFFERENT affliction on
    **whoever is striking him**, cap 30%. The first card that reads Trapper breadth on the way IN.
  - **SALVE** (Survivalist, HEAL) — 3 turns (Perfect: 4), 2% max health a turn per DIFFERENT
    affliction on the enemies, cap 10%, **counted as a UNION across the field** so a copied poison
    does not pay twice. **The first heal in any of the twenty-four**, and HARVEST's inverse.
- **THE BRIEF'S BREAK CARD WAS REFUSED ON MEASUREMENT, AND THAT IS THE BATCH'S SHARPEST FINDING.**
  It held that *"the Hunter class has no Break generation anywhere"*. **`pressure` IS Break, and
  TWELVE OF THE THIRTY HUNTER DRAFT CARDS GENERATE IT** — **Unleash already lands Break on the
  Beastmaster's own pool** and **Fault Line is a dedicated Break card** the audit scores as one of
  the Sharpshooter's five decisions. The proposed card would have been a second copy of a clause
  already in its own pool. **The rule it produced, in `CLAUDE.md` beside DR's:** *before declaring
  an axis ABSENT from a class, derive it — from the DATA, never from the card text*, because a card
  carries Break without its description ever using the word.
- **HEADS DOWN WOULD HAVE SHIPPED VIRTUALLY INERT AND ONLY DRIVING IT LIVE FOUND IT.** Its first
  version refused any ability with `cost > 0`. **46 of the 50 enemy abilities in `data/enemies.json`
  cost ZERO** — Chain Lightning and Healing Wave among them — so it would have refused four
  abilities in the whole game while reading as working. The criterion is identity against
  `_cheapest_attack` now, which is what the card text always said, and it **cannot starve the
  fallback** because the one ability it never refuses is the one the caller falls back to.
  **The refusal is one condition in `_intent_ability_usable` and NOTHING in `_choose_enemy_action`**,
  whose header forbids touching the selection policy.
- **THE SHARPSHOOTER RE-AUTHOR WAS MEASURED AND DECLINED.** Four of his eight are single-target
  strikes, but at the READ SITE they are four different decisions: Crossfire converts crits into
  area damage and reads no Focus at all, Trophy Shot is a decay-RULE change, and **Calibrating Shot
  and Drumfire are the only two alike** — both meter GENERATION, and not a domination (Drumfire
  wins damage and Focus, Calibrating Shot wins cost and **initiative 1.5 against 3.0**). Nothing was
  re-authored. **One adjacency the audit's DMG-ST label hides is recorded instead: TROPHY SHOT AND
  REACQUIRE are near-siblings** — both are "do not lose Focus when the target changes".
- **TWO STALE CLAIMS CORRECTED.** **FIELD DRESSING's "the only self-heal a Hunter can get" was
  already false when BR wrote it** — Harvest heals and sits in the Survivalist's boss pool AND in
  `CLASS_POOLS["hunter"]`. Corrected on the card, in `classes.gd` and in `master.html`; **the TREE
  half is true and is kept** (no Hunter node heals — Field Medic *cleanses*). And the **"six
  designed abilities not yet written" list is FOUR**: Field Dressing was written at BR as a
  CLASS-WIDE draft card, and Smoke Bomb's function shipped at BO as Choking Smoke. **DS did not
  spend the Sharpshooter's three reserved boss-pool names** (Disengage, Suppressing Fire, Piercing
  Arrow) on its own draft cards.
- **Next letter: DU.** `DU` sorts after `DT`, so the stamp gates still work.
- **Phase.** The ability draft is **COMPLETE at 149 of 149** and all twelve talent trees are
  purpose-authored and charter-clean. Recent batches are correction and consolidation: DQ's audit
  of whether the pools hold more than one build each, DR's ruling on the two things that audit found
  were correctness rather than taste, **and DS's ruling on the largest thing it found that was
  structure rather than either.**

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION

### THE DRAFT AUDIT — TWO FINDINGS RULED AT DR, THE REST STILL OPEN

**Full evidence: `docs/draft-audit.html` (both grade-2 findings now carry a RESOLVED banner) and
`docs/reports/DQ.md`.** Everything below is still open and **no gate encodes any of it**, because
a gate encodes a ruling.

**AND ITS ARITHMETIC IS MARKED STALE AS OF DT — READ THE BANNERS BEFORE QUOTING A NUMBER FROM IT.**
The audit measured the draft at **142**; **eight cards have been authored and one retired since**
(DR net +1, DS +6) and it is **149** now. **Five of the twelve pool rows in §2 have moved and three
of those grew** — Swordmaster 10 → 12 and Cryomancer 12 → 11 at DR, and the three Hunter pools
8 → 10 at DS — and every *share of 142* in the axis table is a share of the wrong denominator.
**DT MARKED THEM RATHER THAN REFRESHING THEM, DELIBERATELY: re-deriving the counts means
re-assigning an axis to each of the nine new cards, which is that audit's own judgement call and is
authoring rather than repair.** The banners name DR and DS as the batches that superseded them and
point at `test_batch_cd.PER_SPEC_DEPTH` as the one authoritative depth table — this page is not an
instrument and nothing re-derives it, which is exactly the hazard DJ recorded a rule about.
**One thing the banner corrects outright: the Beastmaster's 8-of-8 engine binding is NOT weakened
by its row being stale — it reads 10-of-10 now**, because both of DS's cards read the companion.

- **THE TWO GRADE-2 FINDINGS ARE CLOSED.** Flash Freeze ← Glacial Prison was answered by
  **retirement**; Battle Poise ← Answering Steel by **differentiation**. `check_dr` §4 and §6 pin
  both, and §4 asserts the SURVIVOR of the pair is still there — retiring the wrong half would
  pass every other assertion.
- **THE COOLDOWN-ZERO QUESTION IS PRESENTED AT DT AND IS THE DESIGNER'S TO CLOSE.** Pyroblast is
  still the only repeatable DRAFT card and `check_dr` §5 still prints the live list every run.
  **DT DERIVED IT AND CAME BACK RECOMMENDING THAT THE OBVIOUS CHANGE NOT BE MADE — options and
  full working in `docs/reports/DT.md` §2, nothing authored.**
  - **LUNGE'S REASONING DOES NOT TRANSFER, AND THE MEASUREMENT IS WHAT SAYS SO.** DR's argument
    was *at the end of a talent lane the price was the node, and in a pool there is no price*. The
    PROVENANCE is identical — both were talent grants DO moved into `SPEC_DRAFT_POOLS`. **The
    premise is not.** Lunge cost 25 of a 100 bar at 3.5 delay, ordinary on both axes. **Pyroblast's
    6.0 delay is the LONGEST IN THE PROJECT with nothing above it** (3× `BASIC_DELAY`), and its
    **45 mana is the SECOND-HIGHEST COST IN THE GAME** — the only card above it is Death Ray at 55,
    **which carries cooldown 3**. It is priced twice, just not with a cooldown.
  - **AND COOLDOWNS TICK IN THE UNIT'S OWN TURNS**, so a 6.0-delay cast has already spent three
    basic attacks' worth of tempo before a cooldown would start counting. If one is taken anyway on
    the UNIQUENESS argument rather than the price one, **2 rather than DR's 3** — 3 would price
    Pyroblast strictly above the strictly heavier card.
  - **SIX OTHER ABILITIES CARRY COOLDOWN ZERO AND FIVE ARE FREE BASIC ATTACKS WHERE IT IS
    CORRECT** (Strike, Quick Shot, Smite, Magic Bolt). **THE OTHER TWO ARE BOSS-PICK CARDS THAT
    HAVE NEVER BEEN IN THE CENSUS** — Ashes of Al'ar and Sweeping Strikes — because `check_dr` §5
    walks `SPEC_DRAFT_POOLS` only. Both are repeatable, both cost real mana, neither is a basic
    attack. That is the boss-pick-pools-were-never-audited thread producing its second thing.
- **AND THE CENSUS HAS A BLIND SPOT DT FOUND WHILE DERIVING IT: FOUR LIVE PROTECTED-CORE BASIC
  ATTACKS ARE NOT IN `Classes.ability_corpus()` AT ALL.** `apply_kit_overrides` builds the four
  mage specs' `abilities[0]` at spawn — **Shadowrend, Fireball, Frostbolt and Arcane Explosion**,
  all cost 0 and cooldown 0 — and **none sits in any pool or is returned by `spec_abilities()`**,
  so the corpus walk reads `kit("mage")` and gets the UNOVERRIDDEN Magic Bolt instead. Their NAMES
  are reachable through `Classes.protected_names()`; their `Ability` objects are not reachable
  anywhere. **This is why the recorded figure is "twelve": twelve INSTANCES across twelve specs but
  only SEVEN distinct names, and Magic Bolt — the one the corpus does carry — is nobody's live
  basic.** **Nothing is wrong at runtime.** What is worth knowing is that any sweep built on
  `ability_corpus()` has four live cards it structurally cannot see. **Widening the walk is a
  change to the one authored enumeration this project has a standing rule about, so DT reported it
  and did not take it.**
- **THE HUNTER CLASS GAP IS RULED AT DS AND ITS DRAFT HALF IS CLOSED.** All three pools are 10
  now and the class has its first heal and its first hero-side mitigation. **ONE HALF OF THE
  FINDING IS DELIBERATELY STILL OPEN AND THE AUDIT'S BANNER SAYS SO**: the Sharpshooter still has
  **no defensive node in his 27**, because DS moved no talent cell — a cell that changes row
  mis-prices the ledger. Only the DRAFT half of "both halves of his progression offer him nothing"
  is answered.
- **THE OTHER CONCENTRATION FINDINGS ARE DESIGN AND ARE UNRULED.** The Cryomancer's remaining
  **11-of-11** ice and the Pyromancer's 12-of-13 Burn are reported with their card lists.
  **THE BEASTMASTER'S 8-OF-8 IS NOW 10-OF-10 AND THAT IS NOT THE SAME FINDING WEAKENED** — DS's
  two cards both read the companion, so the ENGINE binding is untouched and is if anything tighter;
  what moved is the AXIS breadth, from 5 decisions to 7. **Whether a total engine binding is a
  problem at all is still unruled**, and DR's framework says it is not by itself.
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

### THE FLAKE THAT DG FOUND — AND SINCE DT IT IS **THE LAST ONE LEFT IN THE PROJECT**

- **`test_batch_at`'s §1 LIVE DAMAGE-CURVE RATIO IS UNSEEDED. IT WENT RED AT DG AND HAS READ 0 IN
  EVERY BATTERY SINCE — DH THROUGH DS, BOTH OF DR'S TWO AND BOTH OF DS'S — STILL OPEN, STILL
  UNSEEDED.** At a rate of about one red in eighteen, sixteen quiet readings is the common case and
  proves nothing. `_live_curve()`
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
    Its rule stands: **seed both blows of the compared pair, or neutralise the crit as the file's own
    comment says checks that care must do — do NOT widen the band, because the band IS the
    question.**
  - **DT APPLIED THAT RULE TO `bo` AND IT WORKED, WHICH RAISES THE PRIOR ON THE CRIT HERE.** `bo`'s
    documented cause was the ±10% roll alone and **that was incomplete in exactly this file's way**:
    its compared pair ranged 16–28 over six readings, a ±10% roll on a mean of 18 spans 16.4–19.8
    and cannot reach 28, **and a crit is ×1.5 and reaches exactly there.** A per-pair seed
    neutralised every coin at once without anyone having to identify which one was biting, and the
    row settled at ZERO. **The same four lines are almost certainly this row's repair too.**
  - **AND IT IS DELIBERATELY NOT TAKEN AT DT.** `bo` was this batch's one. **One flake at a time is
    how the effect stays attributable**, and with `bo` closed and `test_rune_battle` needing
    nothing, **this is now the only unseeded flake in the project.**
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
- **`_companion_hit` READS 3 OF THE HERO STRIKE LOOP'S 84 MULTIPLIER TERMS, ENUMERATED AT DT.**
  The attacker-side block is `battle.gd` **8613–9299** and runs **84 `raw`-mutation sites**; the
  three it reads are **Mark of the Hunt, the party-wide Hunter's Mark and Necrosis**. **MOST OF THE
  MISSES ARE UNREACHABLE BY SHAPE RATHER THAN BY OVERSIGHT, AND THE SHAPE IS IN THE SIGNATURE**: the
  function takes a FLOAT, not an `Ability`, so all 26 ability-keyed terms cannot apply; a beast's
  `passive_id` is `""` (10 more) and **every talent-rank field on it is zero, always** (20 more).
  **Of the 78 genuinely absent terms, 76 fail the brief's own test — a term no companion can
  receive is a non-issue.**
  - **TWO GET THROUGH, AND NEITHER USES A DOOR ANYBODY WAS WATCHING.** **`cripple`** — enemies
    target `_hero_side()`, which holds the living beast, and `_apply_status` lands the rider with no
    companion filter; **two enemy abilities carry it** (Ride-by Slash, Grasping Roots). In the hero
    loop Cripple is `raw *= 0.75`. **A CRIPPLED BEAST BITES AT FULL STRENGTH.** And **`chilled`** —
    the HOARFROST modifier stamps a summoned companion deliberately and its branch carries no
    `inherited` guard; **measured at 1 stack**, which misses the `>= 3` term but reaches Hungering
    Cold's, gated `atk_chill > 0`.
  - **MEASURED, NOT ARGUED: 40 seeded blows, ratio 1.0000 on every one of nine statuses driven onto
    a live bear** — 30268 in every arm, which is DK's 34392-against-34392 repeating. `cripple`,
    `chilled`, `hexed`, `battle_shout`, `warcry`, `reckless_abandon`, `blood_price`, `tempo` and
    `wheeling_edge` all attach perfectly and move nothing.
  - **AND ONE IS INERT TWICE OVER.** `type_dmg_bonus` CAN reach a beast — the TINDERBOX modifier
    writes `{"fire": 0.25}` onto a summoned companion, measured — but a companion's blow carries no
    `dmg_type` at all, so even adding the read would find nothing to apply. **`dmg_bonus` cannot
    reach one**: the summon copies Attack, armour, speed, crit and `companion_power` off the hunter
    and not that, and the relic hooks run at hero spawn where no companion exists.
  - **`empower`, `wrath` AND `battle_shout` ARE THREE OF THE 76 AND ARE INSTRUMENTED; THE TWO LIVE
    ONES ARE NOT.** `check_dk` §4 and `check_dm` §2 re-measure those three every run, so the day a
    read site appears the gates say the ruling is stale. **`cripple` and `chilled` have no gate**,
    and adding one is the natural companion to whatever ruling is taken.
  - **NOTHING WAS FIXED AND THAT IS DELIBERATE.** Each is a magnitude change on beast damage — DK's
    reason for ruling Empower to *text* — and **DS has since given the Beastmaster an interception
    card and Bring It Down, so companions carry more of the party's output than they did at DK.**
    That makes the decision more clearly the designer's, not less. Full enumeration in
    `docs/reports/DT.md` §4.
- **THE ORIGINAL DK LINE, KEPT BECAUSE THE THREE IT NAMES ARE THE INSTRUMENTED ONES.** A beast's blows resolve on their own damage path and
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
- **`test_rune_battle` IS SEEDED AND THE BAND IS NOT TIGHTENED — AND DT'S BRIEF ASSERTED THE
  OPPOSITE, SO THIS LINE IS LOAD-BEARING.** DT §3 was briefed to seed it as an unseeded suite
  *"with `seed()` never called"*. **IT IS SEEDED**: DF §0 put `_seeded()` immediately before the
  forced White Flame hit — **the exact site that flakes** — and nowhere else, and this row and the
  `baselines.json` note both already said so. **Nothing was owed and nothing was done.** The one
  stale artefact is a comment at `test_rune_battle.gd:23` still reading *"`seed()` zero times"*,
  four lines above the fix that answers it; it is pre-DF prose inside DF's own header and was left
  alone. **The check count is unchanged at 97.**
  **Readings cannot retire a rate measured over fifteen on this evidence.** **The seed cannot fix a
  race**, and the failure message now carries the state the forced hit happened in.
- **`bo`'s FLAKE IS CLOSED AT DT, AND IT SETTLED AT ZERO RATHER THAN AT A RED — SO IT WAS A FLAKE
  AND NOT A FINDING.** `test_batch_bo.gd` called `seed()` zero times; **`_nf_seeded()` is now called
  immediately before EACH of §5's two compared blows with the same constant**, so both arms draw one
  identical stream and the only difference left between them is the Resonance stack count. **The
  other 1104 checks keep their own draw** — per-pair, not per-suite, which is DF's idiom and DD's
  method, and the reason the band was not touched: **the band is the question.**
  - **THE PAIR IS EXACTLY REPEATABLE NOW.** Six readings before the seed: shallow 18/16/23/18/28/17
    against deep 10/10/11/11/9/10. Six after: **17 against 10, every time.** 1106 checks / 0
    failures on all six.
  - **AND THE DOCUMENTED CAUSE WAS INCOMPLETE, WHICH IS WORTH MORE THAN THE FIX.** The recorded
    reason was the ±10% roll alone. **It spans 16.4–19.8 on a mean of 18 and cannot reach 28; a crit
    is ×1.5 and reaches exactly there.** A second and larger coin was hiding behind a variance roll
    that was taking all the blame — `at`'s shape precisely.
  - **The change is FOUR lines of code**, proven with a comment-stripped diff against `HEAD`: a
    two-line helper and its two call sites. The check count does not move.

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
- **THE CAP BINDS 61 ABILITIES IN TWO POPULATIONS.** `Ability.PURE_BUFFS` holds **55** specials
  (DS added `bear_brunt`, `dug_in`, `thick_hide`) and `Ability.SHIELD_SPECIALS` holds **6**.
  **BRING IT DOWN IS A PURE BUFF BY SHAPE AND IS DELIBERATELY NOT A MEMBER** — it is the strongest
  of DS's six, a party-wide amp scaling off an uncapped meter, and is priced at initiative 2.0 for
  that on PREPARATION's precedent; membership would have clamped it to 1.0 as a side effect.
  **AND A PURE BUFF ADVERTISES NO PERFECT**: `Ability.runs_skill_check()` gives it no bar and
  `test_batch_bo` §5 asserts the biconditional, which is what four of DS's six tripped on before
  losing theirs. SALVE kept its by joining `HEAL_SPECIALS` — its heal rides a status it applies,
  which is RENEWAL's shape. **`Ability.takes_delay_cap()` is the one function that
  unions them** and `Ability.make()` applies the clamp.
- **THE ABILITY CORPUS IS 223 AND THE TWO WALKS NOW AGREE.** DR moved it net +1 (one card
  retired, two authored) and **DS moved it +6**. The Batch CL enumeration reached
  **211** for as long as talents granted abilities; the five it missed — Backdraft, Pyroblast,
  Glacial Prison, Cryoclasm, Intercession — were talent grants living in no pool. **DO put all
  twenty-two talent grants into `SPEC_DRAFT_POOLS`, which the CL walk reads, so it reaches all 216
  and `Classes.talent_granted_names()` is EMPTY.** `check_cz` §0 asserts the agreement — its old
  assertion is INVERTED, not deleted, so a card put back outside every pool is still caught.
  **`check_da` §3 asserts that no gate hand-rolls the walk**, with `check_cz`'s `_cl_only_corpus`
  named as the one deliberate exemption (its REASON string was corrected at DO: its job inverted
  with the premise).
- **`RECAST_GATED` HOLDS 64 ABILITIES** — DS added four (Bear the Brunt, Dug In, Thick Hide,
  Salve), each of them entirely a status on the caster. **BRING IT DOWN DELIBERATELY DID NOT
  JOIN**: its number is snapshot off the deepest bond's Loyalty, which is uncapped, so a recast on
  a deeper bond genuinely buys a bigger amp and can never do nothing. **HEADS DOWN is not in the
  system at all**, because it deals damage. DR's COUNTER TIME joined for the same reason the four
  did.
- **AND A PROPOSAL MUST EQUAL WHAT A *GOOD* CAST WRITES, WHICH DS LEARNED FROM A RED.**
  `check_co` saturates by casting at grade `"good"`, so a `_recast_writes` entry proposing the
  PERFECT's duration improves on what is standing every time and the card never refuses. Salve did
  exactly that on the first run. `emberkeep` is not a counter-example — its handler writes
  `EMBERKEEP_TURNS + 1` unconditionally. **A `special` carrying a POWER needs its own arm rather
  than a `RECAST_SELF_PLAIN` row**, because that table writes `power: 0`.
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
- **The ability draft is COMPLETE at 149 of 149** — `SPEC_DRAFT_POOLS` is **125** and
  `CLASS_DRAFT_POOLS` is **24** (4 classes × 6), counted out of `classes.gd`. **The spec half is no
  longer a flat multiple**: DO's twenty-two took nine pools past eight and left three at exactly
  eight, DR moved two of those nine (Swordmaster to TWELVE, Cryomancer down to ELEVEN), and **DS
  took the three that were still at eight — beastmaster, sharpshooter and mystic — to TEN apiece**.
  **THE SHALLOWEST POOL IN THE GAME IS THE WARDEN'S NINE NOW**, so the asserted FLOOR of 8 is slack
  everywhere; it stays there because it catches a pool that EMPTIES rather than tracking the
  deepening. **The one authoritative per-spec table is `test_batch_cd.PER_SPEC_DEPTH`; every other
  suite asserts the FLOOR (>= 8) and the TOTAL.** Do not write `12 * 8` again.
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

### THE TEST TREE, AS OF DT

- **47 `test_*.gd` files**: 44 `test_batch_*` spanning `ah` to `cp` (with gaps — they are NOT one
  per batch), plus `test_run_harness`, `test_runes` and `test_rune_battle`. **They live at the repo
  ROOT, not in `scripts/`.**
- **`_spawn` IS AUTHORED ONCE, IN `suite_fixture.gd`, AND 37 SUITES GO THROUGH IT.** `_kill` too, in
  14. Each suite keeps its OWN `_spawn` SIGNATURE and delegates, so **all 389 call sites are
  untouched.**
- **`run_battery.sh` RUNS 46 SUITES AND MISSES NONE.** The `GATES` array is **twenty-three** —
  **DT ADDED `check_ds`, WHICH IS THE COVERAGE DS NAMED AS ITS OWN COST AND DID NOT PAY.**
  `bring_it_down` and `heads_down` had no permanent live cover; `check_co`'s saturation sweep
  exercises the other four specials as a side effect. **THE SCRATCH FIXTURE IS NOT IN THE REPO AND
  NEVER WAS — `ds_live.gd` IS UNTRACKED AND UNCOMMITTED** (a stray headless process was still
  running it 98 minutes into DT, on a script that no longer exists on disk, which is its own
  argument for a gate). **There are 30 `check_*.gd`
  files**, so **seven are not in `GATES`** — `check_ck_width`,
  `check_cu`, `check_cv`, `check_dn`, `check_ct_map`, `check_map_screen` and `check_de`. **`check_ct_map` and
  `check_map_screen` run in the SCENE RUNS section and `check_de` runs in its own post-pass section
  AFTER them**, so the four that run nowhere are `check_ck_width`, `check_cu`, `check_cv` and `check_dn`.
- **`check_ds` NEEDS NO `check_da` §3 EXEMPTION AND IT TOOK A RED TO ESTABLISH THAT.** It calls
  neither draft-pool accessor; its **header comment named both of them** while explaining that it
  does not, and §3's fingerprint is a substring match over the whole source. **The names came out of
  the prose rather than an exemption being granted** — an exemption granted to a sentence would
  blind §3 to a real walk arriving in that file later, which is worse than the violation it covers.
  `check_da` reads 37/0 again.
- **THE BATTERY WRITES A MANIFEST, `$OUT/.ran`, AND THE DIFFER TRUSTS IT RATHER THAN THE DIRECTORY
  LISTING.** `run_battery.sh` does NOT clear `$OUT` between runs, so a target that failed to launch
  would otherwise be blessed by its PREVIOUS run's log. A name is appended immediately before its
  target is launched and `run_one` truncates the log at spawn, so **a log named in the manifest is
  always this run's**. A subset invocation (`./run_battery.sh bo bp`) writes a short manifest and
  **the differ reports the rest as DID NOT RUN instead of certifying a clean tree.**
- **`gate_fixture.gd` AND `suite_fixture.gd` ARE NOT GATES AND ARE DELIBERATELY NOT NAMED
  `check_*`/`test_*`** — `test_batch_cd` and `check_da` both glob those prefixes.
- **THE BASELINE TABLE IS `baselines.json` AND IT IS 74 ROWS: 46 suites, 23 gates, 2 scene runs
  and 3 harness gates.** **DT ADDED `check_ds` AND MOVED NO OTHER ROW** — the `bo` seed does not
  move its count (1106) and no other target's arithmetic changed. **`check_de` HAS NO ROW OF ITS
  OWN, SO ITS OWN +4 FOR THE NEW GATE IS REPORTED BY NOTHING**, as always; and the battery's first
  pass necessarily reads one `check_de` failure — a target that ran with no row is UNWATCHED, which
  is that assertion working — so the row is added and `check_de` re-run over the same log directory,
  which is what it is built for. **DR ADDED `check_dr` AND MOVED FIVE ROWS** — `test_batch_bt`, `check_co`,
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
- **master.html stamp: `Last updated: 2026-08-29 (Batch DT)`** — **DT MOVED THE STAMP AND NOTHING
  ELSE IN THAT FILE**, because it adds no card, moves no magnitude and retires nothing. DS moved the three Hunter pool
  rows, the count block, Field Dressing's gloss, the stale boss-pool backlog list and Bloodbond's
  self-contradicting row (it said a QUARTER in one clause and "the half he takes can kill him" in
  the next; the code pays a quarter), and added six card rows.

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
- **The live file starts at Batch CO and holds 32 entries** (CO → DT), **395 KiB**. **The 400 KiB
  threshold is about five KiB away** — DT's entry is 6 KiB, so **the next batch of any size crosses
  it**. CX's cut point is CN/CO.
  **Re-derive this before acting on it; five batches running have now mis-predicted it, so the
  honest statement is that the NEXT ruling batch of DR's size probably reaches it.**
- **`DoD-archive/changelog-archive.html` holds 131 entries** (Batch 1 → CN) and is **1042 KiB**.
- **Fourteen suites depend on a file that is not in version control** — bp, bq, br, bs, bt, bu,
  bv, bw, bx, cb, ce, bb, bn, bo. On a machine without `DoD-archive/` they FAIL LOUDLY, which is
  correct.

### Knowledge sync, re-measured at DS
*Measured over `.gd .md .html .json .py .sh`, excluding `assets/`, `.git/` and `.godot/`.
**Treat the file COUNT as method-dependent** — the walks have differed by one before, and the
SIZES are the comparable half. **ALL SIZES BELOW ARE KiB (1024 bytes)**.*
- **149 files, 6.89 MiB** (DS measured 147 / 6.80 MiB). **DT added TWO files — `check_ds.gd` and
  `docs/reports/DT.md` — and grew no source file at all**, because it authored no game code: the
  only `scripts/` change this batch would have been a §4 fix, and §4 was report-only. It grew
  `CLAUDE.md`, `design-notes.md`, `draft-audit.html`, the changelog and `test_batch_bo.gd`.
- Heaviest: `scripts/battle.gd` **1218**, `docs/changelog.html` **395**, `docs/design-notes.md`
  **363**, `docs/master.html` **335**, `scripts/classes.gd` **312**, `CLAUDE.md` **236**,
  `scripts/talents.gd` **178**, `scripts/unit.gd` **176**, `docs/talent-audit.html` **165**.
- **The 47 suite files are unchanged in number and still the single largest block. They cannot be
  archived (they must be in the repo to run) but they CAN be deselected from the sync.** The gates
  are **30** now — `check_ds.gd` is the thirtieth, at **22 KiB**.
- **`CLAUDE.md` IS 236 KiB = 3.35%**, down from 3.39% at DS — **not because the file shrank but
  because DT's one added clause is smaller than the sync's growth around it**, which is the same
  reason the ratio fell at DQ. CW's *"under 3% and roughly flat"* target is still met on the second
  half and missed on the first. **DG through DT have all declined the prune**, and DT declined it
  while being in the file, which is the condition state.md says makes it worth taking — the reason
  is that DT's clause belongs beside an existing rule rather than in a new section, so the file was
  open for four lines and not for a pass.
- **`scripts/` contains ZERO test suites.** All game code.

---

## KNOWN-BROKEN AND DELIBERATELY UNFIXED

### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED

**DB measured 72 across 26 suites. DC repaired 23. DF sorted all 47 and repaired the 37 that were
STALE. DG closed the remaining ten.** **EVERY ACCEPTANCE BATTERY FROM DI FORWARD READ ZERO FROM THE THREE FLAKES, AND THAT WAS NOT A
REPAIR — IT IS A REPAIR NOW FOR TWO OF THE THREE.** `test_rune_battle`'s pierce was seeded at DF §0
at the site that flakes, and **`bo`'s NULL FIELD flake is seeded and closed at DT, settling at ZERO
over six readings.** **`test_batch_at`'s unseeded §1 ratio is the ONLY ONE LEFT**, it is still
unseeded, and a row that reads clean at a rate of about seventeen in eighteen has still told you
nothing when it reads clean.

**DS's BATTERY 1 READ FOUR SUITE FAILURES AND ALL FOUR WERE DS'S OWN — `test_batch_bx`'s
RETIRED-WORD SWEEP BITING EXACTLY AS DESIGNED.** "beast" is retired from player-facing prose, and
**Bear the Brunt's card text, its live chip and its cast message all used it**; two more were the
six new `master.html` rows, §4 for "beast" and §4b for "party". The fourth was §3's `_deepest_bond`
caller count, re-pointed 3 → 5 (Bear the Brunt and Bring It Down are both ORDERED actions and both
ask through the one door rather than reading list order). **A batch adding Beastmaster content is
precisely the batch that reintroduces the retired word, and nothing else in the tree would have
said so.** All four repaired before battery 2; the check count does not move (157).

**AND DR's BATTERY 1 FOUND `test_batch_bp` §7's LATENT DRAW COLLISION, WHICH IS REPAIRED AND IS
RECORDED HERE BECAUSE THE SHAPE RECURS.** §7 hand-builds a Warrior kit and then TAKES `cands[1]`,
a card drawn from his live draft pool, and two of the three hand-written fillers were IN that pool.
It is fixed with boss-pick names no draw can reach. **DS RE-DERIVED THE UNDERLYING RULE AND IT IS
ABOUT ORDER, NOT FILLER CHOICE**: `bp` §7 stuffed `bm_abilities` *after* `award_draft_pick` had
already rolled, and `draft_pool_left` filters owned names — so a kit built BEFORE the roll can never
collide. `test_batch_bx` §2 and `check_map_screen` already do that and are safe, and
`test_batch_bo` §2's Sharpshooter block uses boss-pick names. **DS's three growing pools could not
reach `bp` §7 at all: it is a Warrior flow.**

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
- **`test_batch_bo`'s FLAKY ASSERTION IS FIXED AT DT AND THE COUNT DID NOT MOVE — still 1106.**
  §5's NULL FIELD check still requires `deep < shallow`; both blows are seeded per-pair now, so the
  pair reads 17 against 10 on every run. **`test_batch_bo.gd` called `seed()` zero times before DT
  and calls it twice now, both in `_nf_seeded()` at that one site.**
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

**TWO BATTERIES AT DS. BATTERY 2 IS THE ACCEPTANCE RUN BECAUSE IT CAME BACK CLEAN.**
**161 files were MD5-stamped before it and re-compared after, and NOT ONE MOVED.**
**Battery 1 was NOT discarded** — it is what found `test_batch_bx`'s four reds (three of them the
retired-word sweep biting on DS's own new prose) and the two baseline rows DS had not predicted.

| | DR's acceptance | DS battery 1 | DS battery 2 (acceptance) |
|---|---|---|---|
| **suite failures** | 0 | **4** (`bx`, all DS's own, repaired) | **0** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 305 / 0 / 0 | 305 / 1 / 5 | **305 / 0 / 0 — exactly the prediction** |
| targets in the manifest | 74 | 74 | **74** |

**SEVENTY-FOUR TARGETS RAN AND THE MANIFEST NAMES ALL SEVENTY-FOUR. 0 `Parse Error` and 0
`SCRIPT ERROR` in every log.**

**FIVE BASELINE ROWS MOVED AND DS PREDICTED THREE OF THEM EXACTLY.** The method was to derive the
per-card rate from DR's OWN movement rather than guess: DR moved the draft net +1 and moved `bo`
+6, `cb` +1, `ce` +1, so six cards give **+36 / +6 / +6**. Read: `test_batch_bo` 1070 → **1106**,
`test_batch_cb` 1197 → **1203**, `test_batch_ce` 1139 → **1145**. `check_co` 301 → **321** was
predicted in direction only. **`check_cy` 2704 → 2857 WAS NOT PREDICTED** — three of the six join
`Ability.PURE_BUFFS` and that gate runs its whole per-ability rule over every member; DS predicted
the three draft-pool loops and did not think about the buff table. **`bp`, `bq`, `br` and `cp` were
correctly predicted NOT to move**: they iterate per-*spec* or class×spec, so pool depth cannot
reach them. **`check_di`'s `CALL_SITES` equality also tripped in battery 1 and DS HAD predicted
it**: 205 → **210**, `SRC_FLOOR` 106 → **107**, with the reason written into the gate's own comment
as that const's header demands.

**AND THE ZERO IN THE FAILURE ROW IS STILL NOT A REPAIR.** `test_batch_at`'s unseeded §1 ratio
(read 467), `bo`'s §5 NULL FIELD flake (read 1106) and `test_rune_battle`'s pierce (read 97) were
quiet again in both runs — the **sixteenth** consecutive quiet reading. **All three are still open,
still unseeded and still banded. A red from any of them is not the next batch's.**

**THE LITERAL SWEEP: 10,589 literals at a floor of 4**, from all 76 suites and gates, evaluated
against twenty documents and sources and diffed against `git show HEAD` in one pass. **0 LOST.**
**5 GAINED and the dangerous kind is zero** — `125 spec`, `149 of`, `149 of 149`, `149 OF 149` and
`A TARGET 149`, every one a needle this batch re-pointed itself, each cross-referenced against the
tree's negative `contains` assertions with no match.

**THE COMMENT-STRIPPED DIFF WAS TAKEN.** With every line-leading `#` stripped, `battle.gd` lost
**2** code lines and `classes.gd` **4**; all six are accounted for — the two `RECAST_GATED` array
lines rewritten to take four entries, the three pool arrays rewritten to take six cards, and Field
Dressing's deliberately corrected description. `unit.gd` and `ability.gd` lost none.
**Nothing was swallowed.**

**THE PARSE CHECK WAS CONTROLLED FROM BOTH SIDES.** A deliberate `func _ds_negative_control(:`
produced `Parse Error: Expected parameter name.`; removing it restored a **byte-identical** file
(verified by `diff` against a scratchpad copy, **not** by `git checkout`), and the tree read 0.

**ONE PRE-EXISTING NAME NEAR-MISS WAS FOUND AND IS REPORTED, NOT FIXED.** The Beastmaster's draft
card **Ghostpack** and his own row-8 talent node **Ghost Pack** differ by one space, on the same
spec — a sixth member of the "five nodes named after live abilities" list below, which records only
exact matches.
