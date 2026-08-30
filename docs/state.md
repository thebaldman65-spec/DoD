# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

*Last rewritten: 2026-08-29 (Batch DV).*

---

## WHERE THE PROJECT IS

- **Last batch: DV — THREE THINGS DU FOUND, AND THE CHANGELOG CUT.**
  Four items. **ONE THING CHANGED IN THE GAME** — a door that let the player waste a turn the bot
  had refused since BB — and **the other three resolved to measurement, because the brief withheld
  the ruling each of them needed.** No card was authored and the draft is untouched at 149.
  **Report: `docs/reports/DV.md`.**
- **`CLASS_POOLS` IS A LOST FEATURE, NOT SCAFFOLDING, AND NOTHING WAS DELETED.** The standing rule
  is that dead code is deleted rather than zeroed; **the brief made the deletion conditional on
  establishing WHY it is dead, and the condition fired.** Three independent sources agree it was
  WIRED and LIVE: `classes.gd`'s own header describes the Batch AH award as *"1 from its SPEC_POOLS
  entry and 2 from its class's CLASS_POOLS entry (`Run.roll_ability_offer`)"*; `run_state.gd`
  records that **Batch AN §4 re-pointed the award and left the structure standing**; and
  `test_batch_an` §1 asserts **`roll_ability_offer()` is DELETED**. **The reader was deleted and the
  pools were left on purpose — that is an orphaning, so it is a design question and this batch has
  no ruling on it.**
  - **AND A SECOND REASON THE BRIEF DID NOT ANTICIPATE: SEVEN ABILITIES DIE WITH IT.** Of the 61
    distinct names, **27 are some spec's opening kit**, **27 sit in a live pool**, and **SEVEN are
    reachable NOWHERE ELSE AT ALL** — Rallying Shout, Mana Shield, Arcane Surge, Reality Fracture,
    Dawnbreak, Sanctuary, Divine Wrath. Each is authored, resolving and fully implemented down to
    its handler, chip and glossary prose; **no rune grants any of them and
    `Classes.talent_granted_names()` is empty.** **Deleting the container would delete the record of
    the contents.** `Classes.ability_corpus()` walks `class_pool()`, so **the 227 includes seven
    abilities no run can reach.** `check_dv` §1 DERIVES the seven rather than listing them.
  - **WHAT AN ACTUALLY RETIRED WAS CROSS-SPEC ACQUISITION INSIDE A CLASS** — a Devout could once
    earn the Holy Cleric's Heal. That is a larger thing than the structure looks like from outside.
- **THE PHOENIX DOOR IS CLOSED AND THE BOT NO LONGER PLAYS BETTER THAN THE PLAYER MAY.**
  `_resolve_special` writes `ashes_return = ASHES_RETURN_PERFECT` unconditionally, so an armed hero
  could recast Ashes of Al'ar for **30 Mana and a turn, writing the same constant, every turn at
  cooldown 0**. The bot has refused exactly that since BB. It is refused at `_ability_usable` now.
  - **IT IS NOT IN `RECAST_GATED` AND THAT WAS MEASURED, NOT ARGUED.** That system reasons about
    STATUS writes and `ashes` writes an integer FIELD: driven live on a fully-armed Mage,
    **`_recast_targets` returns `[]` and `_recast_refused` returns FALSE.** **Membership would have
    changed no behaviour at all**, and its one visible effect would have been `check_co` reporting
    the card as never exercised — which reads like coverage. Both facts are asserted in `check_dv`
    §3.
  - **THE TEST IS EXACT AND FOUR STATES ARE DRIVEN**: unarmed **OPEN**, armed **REFUSED**, armed
    BELOW what the cast writes **OPEN**, spent **REFUSED**. **The third is CO §1's whole rule** —
    written `ashes_return > 0` it refuses a genuine 25 → 40 improvement, and the negative control
    fails exactly that one check and nothing else.
  - **`ASHES_RETURN` (25) IS A DEAD CONSTANT** — `FIREDRAW_TAKE`'s shape — and **it had already cost
    a documentation defect**: `master.html` said the phoenix returns at 25% where the card and the
    code both pay 40. Corrected toward the code.
- **THE CHANGELOG IS CUT AT THE DF/DG BOUNDARY AND THE SYNC FELL FOR THE FIRST TIME.** 406.0 KiB
  against CW's 400 threshold. With DV's entry the file held 34 entries; **16 stay and 18 move.**
  Live **DV → DG at 150.0 KiB**; archive **DF → Batch 1 at 1314.3 KiB and 149 entries**. **The two
  bodies rejoined are byte-identical to the original**, verified by a second script reading
  untouched backups — **and no file size was asserted anywhere**, because sizes agreeing is
  consistent with a duplicated entry and a dropped one. **ALL FOURTEEN CHANGELOG-READING TARGETS
  NEEDED NO RE-POINTING**, and that is CX's work rather than this batch's.
- **`check_dv.gd` IS THE GATE THE RULINGS NEEDED — 128 checks, `GATES` goes 24 → 25.** **FOUR
  NEGATIVE CONTROLS, ALL FOUR BIT, AND ALL FOUR ON DIFFERENT ASSERTIONS.**
- **Next letter: DW.** `DW` sorts after `DV`, so the stamp gates still work.
- **Phase.** The ability draft is **COMPLETE at 149 of 149** and all twelve talent trees are
  purpose-authored and charter-clean. Recent batches are correction and consolidation: DQ's audit,
  DR's rulings, DS's Hunter gap, DT's loose ends, DU's corpus fix and boss-pick audit, **and DV
  ruling on one of DU's three findings and measuring the other two.**
- **PYROBLAST KEEPS COOLDOWN ZERO, AND THE RULING IS IN `CLAUDE.md` WITH ITS REASONING.** *A
  repeatable draft card is a legitimate shape when it is priced elsewhere.* **The provenance is
  identical to Lunge's and the premise is not**: Lunge cost 25 of a 100 bar at 3.5 delay, ordinary
  on both axes, so DR's *"in a pool there is no price"* was literally true of it. **Pyroblast's 6.0
  delay is the longest in the project with nothing above it** (3× `BASIC_DELAY`) and **its 45 mana
  is the second-highest cost in the game** — the only card above it is Death Ray at 55, *which
  carries cooldown 3*. **It is priced twice, just not with a cooldown**, and cooldowns tick in the
  unit's own turns. **NOTHING UNDER `scripts/` WAS TOUCHED FOR THIS.** `check_dr` §5 keeps printing
  the live list; `docs/draft-audit.html` carries a RESOLVED banner naming both halves.
- **A CRIPPLED COMPANION BIT AT FULL STRENGTH, AND `_companion_hit` READS `cripple` AND `chilled`
  NOW.** Enemies aim at `_hero_side()`, which holds the living companion; `_apply_status` lands the
  rider with no companion filter; two enemy abilities carry Cripple (Ride-by Slash, Grasping Roots).
  **MEASURED, NOT ASSERTED: 40 seeded blows read 30268 in both arms before — ratio 1.0000 — and
  30268 against 22703 after, ratio 0.7501.**
  - **THE LINE THAT SEPARATES THIS FROM DK's REFUSAL TO WIDEN IS IN `CLAUDE.md`, AND BOTH DECISIONS
    ARE CORRECT UNDER IT.** *A player effect that lands and pays nothing costs the player a card; an
    ENEMY effect that lands and pays nothing costs the player nothing.* The first is a dead card and
    narrowing the words fixes it honestly; the second is an exploit.
  - **BOTH CHILLED TERMS ARE READ AND ALL FOUR ARMS LAND ON THEIR ARITHMETIC EXACTLY** — 1.0000 at
    one stack with no node, 0.8500 at three, 0.9700 at one stack under the node, **0.7735 with both
    terms live.** The node's rank is read off `Talents.LANE_TREES` at run time rather than typed in.
  - **ONE STACK IS THE CEILING IN PLAY AND SAYING SO IS THE FINDING.** The frost bargain's stamp is
    the only application of Chilled that reaches a companion — every other one in the file targets
    an enemy — so **the `>= 3` arm is UNREACHABLE today.** It is written anyway, because the hero
    loop's two terms are one rule and half a rule here is the next thing to diverge, and **the stack
    count was NOT raised to make it reachable.**
  - **THE LOOP IS NOT WIDENED GENERALLY.** 76 of the 78 absent terms are unreachable by shape, and
    a general widening would hang visible chips on a companion that change nothing — worse than the
    narrow miss, because it reads as working. **`type_dmg_bonus` is still unread and is inert twice
    over**: a companion's blow carries no `dmg_type` at all.
- **`check_du.gd` IS THE GATE THE RULING NEEDED AND IT ASSERTS THE RATIO, NOT THE READ — 32 checks,
  `GATES` goes 23 → 24.** `check_dk` §4 and `check_dm` §2 already re-measure three statuses every
  run; `cripple` and `chilled` had no instrument in either direction, **so removing these reads
  again would have been silent.** **FOUR NEGATIVE CONTROLS, ALL FOUR BIT, AND CONTROLS 2 AND 3 BIT
  ON DIFFERENT ASSERTIONS** — which is what proves each chilled arm is separately load-bearing.
- **`Classes.ability_corpus()` COULD NOT SEE FOUR LIVE BASIC ATTACKS, AND FIFTEEN GATES INHERITED
  THAT.** `apply_kit_overrides` builds FOUR SPECS' `abilities[0]` at spawn (**THREE Mage and ONE CLERIC — DV §5 corrected DU's "four Mage specs"; Shadowrend is the OCCULTIST's and overrides Smite out of `kit("cleric")`, so TWO class kits were misread, not one**) — Shadowrend,
  Fireball, Frostbolt and Arcane Explosion — and none sits in any pool, so the walk read
  `kit("mage")` and got the **unoverridden Magic Bolt, which is nobody's live basic attack.** The
  walk applies the overrides now, using `protected_names`'s own idiom one function up. **The corpus
  goes 223 → 227.**
  - **RE-RUN THROUGH EVERY CRITERION DERIVED FROM IT, ALMOST NOTHING MOVED, AND THAT IS THE
    RESULT.** CN's population goes 223 → 227 and its no-bar count does not move at all (121 either
    way — all four attack, so all four correctly run a bar). CO's, CY's and nine others are
    unmoved. **TWO OF THE BRIEF'S FIVE NAMED CRITERIA ARE NOT DERIVED THROUGH THE CORPUS AT ALL** —
    `check_dp`'s rune-field sweep walks `runes.json` against source text, and **`check_dr` §5's
    cooldown-zero census walks the DRAFT POOLS directly**, deliberately, so that earlier readings of
    that printed line stay comparable.
  - **`check_cz` §0's WALK AGREEMENT IS A SET IDENTITY NOW RATHER THAN AN EQUALITY**, derived off
    `apply_kit_overrides` itself so a fifth override is covered by doing nothing. **The control's
    job is intact**: an ability outside every kit and pool would be in NEITHER walk and cannot hide
    inside the difference. 133 → **134**. `check_da`'s exemption REASON for that file was corrected
    for the second time; the exemption itself is untouched.
  - **THE ONE THING THE FIX MADE VISIBLE.** The width sweep now measures four descriptions and three
    `perfect_text`s it never could. **All twelve description lines are inside the 44-character
    ceiling; Shadowrend's `perfect_text` renders at 45, one over.** Pre-existing, it joins a standing
    population of authored overruns, and it is **reported rather than fixed.**
  - **THE RECORDED FIGURE IS CORRECTED IN THREE PLACES.** *"Twelve cooldown-zero abilities in the
    protected cores"* is twelve INSTANCES across twelve specs and **seven distinct names**. The
    claim is true either way; the number was the misleading half. **`check_du` §5 derives both
    numbers every run and asserts they disagree.**
- **THE BOSS-PICK POOLS ARE AUDITED AND RULED ON NOWHERE, WHICH IS DQ'S SEQUENCE ONE CHANNEL OVER.**
  Full tables in `docs/reports/DU.md` §5. Everything it found is open; **the two cooldowns the brief
  named turned out to be two different questions and neither was ruled on.**
- **Next letter: DV.** `DV` sorts after `DU`, so the stamp gates still work.
- **Phase.** The ability draft is **COMPLETE at 149 of 149** and all twelve talent trees are
  purpose-authored and charter-clean. Recent batches are correction and consolidation: DQ's audit of
  the draft pools, DR's ruling on two of its findings, DS's Hunter gap, DT's loose ends, **and DU
  closing the last two cooldown-zero questions the draft had while opening a channel's worth of new
  ones next door.**

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
- **THE COOLDOWN-ZERO QUESTION IS CLOSED AT DU §1, IN THE DRAFT CHANNEL ONLY.** **PYROBLAST KEEPS
  COOLDOWN ZERO** and the rule is in `CLAUDE.md` **with its reasoning**, which is the half that
  stops a later batch reading Lunge and Pyroblast as an inconsistency: *a repeatable draft card is a
  legitimate shape when it is priced elsewhere.* **6.0 delay is the longest in the project and 45
  mana the second-highest cost in the game; Death Ray costs more and carries cooldown 3.** DR's
  reasoning did not transfer because Lunge was ordinary on both axes and Pyroblast is ordinary on
  neither. **If a cooldown is ever taken anyway it is on the UNIQUENESS argument and it is 2, not
  3.** `check_dr` §5 still prints the live draft list every run and still walks the DRAFT POOLS
  ONLY, deliberately. `docs/draft-audit.html` carries the RESOLVED banner naming both halves.
- **AND THE SAME QUESTION IS OPEN IN THE BOSS-PICK CHANNEL, WHERE IT IS TWO QUESTIONS AND NOT ONE.**
  **ASHES OF AL'AR RATE-LIMITS ITSELF** — `ashes_used` makes it once a battle by construction and
  its card text says so, so cooldown 0 costs nothing there. **SWEEPING STRIKES DOES NOT**: 20 Rage a
  cast at cooldown 0 while BUILDING 10, two swings, 12 Break, and a 3-turn Daze a repeatable card
  keeps permanently refreshed. **20 of a 100 bar at 3.0 delay is ordinary on both axes, which is
  LUNGE's profile and not Pyroblast's** — so DU §1's ruling does not obviously cover it. **Reported
  at DU §5 and ruled on nowhere.**
- **THE CENSUS BLIND SPOT DT FOUND IS CLOSED AT DU §4 AND THE CORPUS IS 227.**
  `apply_kit_overrides` builds FOUR SPECS' `abilities[0]` at spawn (**THREE Mage and ONE CLERIC — DV §5 corrected DU's "four Mage specs"; Shadowrend is the OCCULTIST's and overrides Smite out of `kit("cleric")`, so TWO class kits were misread, not one**) — **Shadowrend,
  Fireball, Frostbolt and Arcane Explosion** — and none sits in any pool, so the walk read
  `kit("mage")` and carried the **unoverridden Magic Bolt, which is nobody's live basic attack.**
  It applies the overrides now, using `protected_names`'s own idiom one function up. **RE-RUN
  THROUGH ALL FIFTEEN GATES THAT READ IT, ALMOST NOTHING MOVED** — CN's population goes 223 → 227
  with its no-bar count unchanged at 121 (all four attack, so all four correctly run a bar), and
  CO's, CY's and nine others do not move at all. **`check_cz` §0's agreement is a derived SET
  IDENTITY now rather than an equality** (133 → 134), so a fifth override is covered by doing
  nothing, and an ability outside every kit and pool would be in NEITHER walk and cannot hide inside
  the difference. **`check_du` §5 asserts every spec's LIVE basic is reachable, derived and never
  listed.**
  - **TWO OF THE FIVE CRITERIA DU's BRIEF NAMED ARE NOT DERIVED THROUGH THE CORPUS AT ALL.**
    `check_dp`'s rune-field sweep walks `runes.json` against the comment-stripped source of five
    scripts, and **`check_dr` §5's cooldown-zero census walks the DRAFT POOLS directly.** Neither
    moved and neither could have.
  - **THE ONE THING THE FIX SURFACED IS A TEXT-STANDARD OVERRUN NO WIDTH SWEEP COULD EVER REACH:
    Shadowrend's `perfect_text` renders at 45 against a 44-character ceiling**, one over. All twelve
    new description lines are inside it. **Pre-existing, it joins a standing population of authored
    overruns `check_cl_width` already reports, and it is reported rather than fixed.** That gate
    reports **neither a check count nor a failure count**, so its movement is invisible to the
    differ and `docs/reports/DU.md` §4 is the only record of it: description 4300 → 4348 rendered
    lines with 8 over either way, `perfect_text` 380 → 392 with 52 → 56 over.
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
### THE BOSS-PICK POOLS — AUDITED AT DU §5, RULED ON NOWHERE

**Full tables and working in `docs/reports/DU.md` §5.** DQ dumped them and did not audit them; this
is the audit, and like DQ's it changed nothing. **`SPEC_POOLS` is 42 entries across twelve specs,
40 distinct names.** A zone boss awards ONE pick per hero from that hero's spec pool alone, there
are THREE zone bosses, and **both channels write the same `bm_abilities` list — so a drafted card
removes itself from the boss offer and vice versa.**

- **`CLASS_POOLS` IS RULED AT DV §1: IT IS A LOST FEATURE, IT WAS NOT DELETED, AND THE FEATURE'S
  RETURN IS THE DESIGNER'S.** 61 authored, resolving entries no run can reach. **Batch AH's award
  drew 1 from the spec pool and 2 from the class pool; Batch AN §4 re-pointed it and DELETED
  `roll_ability_offer`** — asserted absent by `test_batch_an` §1 — leaving the pools standing on
  purpose. **SEVEN of the 61 are reachable NOWHERE ELSE IN THE GAME**: Rallying Shout, Mana Shield,
  Arcane Surge, Reality Fracture, Dawnbreak, Sanctuary, Divine Wrath. Re-opening the class draw is
  still one line; **deleting the structure would delete the last listing of seven finished
  abilities.** `check_dv` §0 re-asserts the three premises live, so the day the draw reopens the
  gate says this is stale.
- **TWO POOLS ARE THINNER THAN THE AWARD COUNT AND SIX MORE CAN BE EMPTIED BY DRAFTING (MEASURED
  AT DV §2).** **The award count is THREE, derived from `Run.SLOT_COUNT` and `_resolve_boss`'s own
  header rather than recalled.** **Holy's pool is 1 (structural shortfall 2, and 3 if he drafts
  Divine Plea); the Inquisitor's is 2 (shortfall 1, up to 3).** Berserker, Pyromancer, Cryomancer
  and Occultist are 3 with two draftable apiece, so up to 2 can empty; Warden, Swordmaster and
  Arcanist are 4; **the three Hunter specs are 5 with NO overlap, so all three of their picks always
  land.** **The shape is the draft's INVERTED** — DS deepened the Hunter pools because they were the
  shallowest in the game. **The size of the problem is measured rather than assumed and Holy is not
  alone**, which is what the brief asked for. `check_dv` §2 derives both ends every run.
  - **THE FALLBACK IS A DESIGN DECISION, FOUR CANDIDATES ARE PRICED IN `docs/reports/DV.md` §2, AND
    NOTHING WAS AUTHORED** — the brief withheld the ruling, and the fallback's DESTINATION is the
    entire change. **A spec-draft card** costs nothing to build and dissolves the distinction
    between the two channels; **a class-wide card** is the only option that gives the dead class
    channel a live purpose, but class-wide cards are authored WEAKER on purpose so it reads as a
    consolation prize; **a rune** is mechanically cheapest (`roll_rune_candidates` and
    `rune_picks_owed` already exist) and changes what the reward IS; **gold** is free and weakest,
    since a zone boss already pays `randi_range(110, 130)`.
  - **AND THE CARD-SHAPED OPTIONS ARE WORTH LEAST EXACTLY WHERE THE HOLE IS WORST.**
    `ABILITY_SLOT_CAP` is 7 and **the Holy Cleric carries FOUR protected cores, the only spec that
    does — so he has THREE earnable slots, the fewest in the game.** Gold and a rune cost no slot;
    both card options do.
- **26 of the 42 are boss-only; 16 are also in the same spec's draft pool.** The only name in more
  than one spec pool is **Ashes of Al'ar** (pyromancer, cryomancer, arcanist), which is coherent —
  it is a Mage-wide death-save rather than a spec piece. Lunge and Execute are two of the sixteen.
- **AXIS COVERAGE: the Beastmaster's five deal no damage and no Break at all** — every one is a
  `special`, and it is the only pool in the game with no damaging card. Coherent with the spec (the
  companion is the damage) rather than obviously wrong, which is why it is reported and not ruled on.
- **NO DOMINATION, AND THE NEAREST MISS IS THE INSTRUCTIVE PART.** Called Shot and Coup de Grâce
  share cost, damage and Break, and Called Shot wins cooldown AND delay. **It does not dominate, and
  only the READ SITE says so**: Coup de Grâce cashes the whole Focus meter for up to 200% of the
  target's missing health. **An audit that scored them by their fields would have reported a
  domination that is not there** — DQ's own discipline.
- **THE CO-SHAPED DEFECT IS FIXED AT DV §3, AND IT IS NOT IN `RECAST_GATED`.** `ashes` writes an
  integer FIELD, and that system reasons about STATUS writes — **driven live on a fully-armed Mage,
  `_recast_targets` returns `[]` and `_recast_refused` returns FALSE**, so membership would have
  been a string in a table and nothing else. It is a bespoke condition at `_ability_usable`, the one
  door, with the reason on the darkened button. **`check_co` could not have found it: it saturates
  the MEMBERS of `RECAST_GATED`, so it measures the list rather than the candidates for it.**
- **AND THE REVERSE COMPARISON IS DONE AND RULED ON NOWHERE BEYOND `ashes` (DV §3).** Every bot
  guard of the form *"only when the target does not already hold it"* was read against the player's
  door. **Seven are already covered by the general rule.** **Four look identical and are NOT no-ops
  — the bot's guard there is POLICY**: Hold Breath also pays +40 Focus, Renewal's Perfect pays a
  burst, Snare Trap also fires `_hit_and_run`, and a Fortified Spirit recast genuinely unwinds and
  re-lays the loan. **TWO ARE REAL CANDIDATES AND ARE UNRULED**: `mark_hunt` (a flat 7-turn mark,
  `rime`'s shape) and `intercession` (a window on every living hero, `cons_ground`'s shape). **AND
  ONE NARROW GAP**: Deadfall SETS `deadfall_armed`, so recasting a FULL one writes the same number,
  and **under Deadfall Network (cap 3) the door permits it** — the exact condition is
  `armed == DEADFALL_CHARGES + 1 and dormant == 0 and deadfall_network >= 2`, because a recast on a
  part-spent or DORMANT deadfall genuinely restores charges and clears the rest.
- **`ASHES_RETURN` (25) IS A DEAD CONSTANT, AND IT HAD ALREADY COST A DOCUMENTATION DEFECT.** The
  handler writes `ASHES_RETURN_PERFECT` (40) unconditionally — `FIREDRAW_TAKE`'s shape exactly.
  **`master.html` said the phoenix returns at 25% where the card and the code both pay 40**;
  corrected toward the code at DV. **Collapsing the constant moves a magnitude and was not taken.**
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
  EVERY BATTERY SINCE — DH THROUGH DU, BOTH OF DR'S TWO AND BOTH OF DS'S — STILL OPEN, STILL
  UNSEEDED.** At a rate of about one red in eighteen, **seventeen** quiet readings is the common
  case and proves nothing. `_live_curve()`
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

- **ONE PRE-EXISTING NAME NEAR-MISS IS REPORTED AND NOT FIXED.** The Beastmaster's draft card
  **Ghostpack** and his own row-8 talent node **Ghost Pack** differ by one space, on the same spec —
  a sixth member of the "five nodes named after live abilities" list below, which records only exact
  matches. Found at DS.

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
- **`_companion_hit` READS 5 OF THE HERO STRIKE LOOP'S 84 MULTIPLIER TERMS, AND THE TWO IT GAINED
  AT DU WERE THE ONLY TWO THAT WERE LIVE.** The attacker-side block is `battle.gd` **8613–9299** and
  runs **84 `raw`-mutation sites**; the five it reads are **Mark of the Hunt, the ownerless Hunter's
  Mark, Necrosis, `cripple` and `chilled` (both terms)**. **MOST OF THE REMAINING MISSES ARE
  UNREACHABLE BY SHAPE RATHER THAN BY OVERSIGHT, AND THE SHAPE IS IN THE SIGNATURE**: the function
  takes a FLOAT, not an `Ability`, so all 26 ability-keyed terms cannot apply; a companion's
  `passive_id` is `""` (10 more) and **every talent-rank field on it is zero, always** (20 more).
  **Of the 76 still absent, all 76 fail the brief's own test — a term no companion can receive is a
  non-issue.** **`check_du` §0 re-asserts all three premises live**, so the day one moves the count
  is stale rather than quietly wrong.
  - **THE TWO THAT WERE LIVE ARE FIXED AND MEASURED.** **`cripple`** — enemies target
    `_hero_side()`, which holds the living companion, and `_apply_status` lands the rider with no
    companion filter; **two enemy abilities carry it** (Ride-by Slash, Grasping Roots). **40 seeded
    blows: 30268 in both arms before, ratio 1.0000; 30268 against 22703 after, ratio 0.7501.** And
    **`chilled`** — the frost modifier stamps a summoned companion deliberately and its branch
    carries no `inherited` guard. **Both terms read; all four arms land exactly** (1.0000 / 0.8500 /
    0.9700 / 0.7735).
  - **ONE STACK IS THE CEILING AND THE `>= 3` ARM IS UNREACHABLE IN PLAY.** The frost stamp is the
    only application that reaches a companion; every other one in the file targets an enemy. **The
    stack count was NOT raised to make the arm reachable** — that would be authoring. `check_du` §3
    asserts the stamp lands 1, so the day the ceiling moves the gate says this line is stale.
  - **`cripple` AND `chilled` ARE INSTRUMENTED NOW, WHICH THEY WERE NOT.** `check_du` §1 and §2
    measure the ratios every battery run beside `check_dk` §4's `empower` and `check_dm` §2's
    `wrath` and `battle_shout`. **Before DU, removing either read would have been silent.**
  - **AND ONE IS STILL INERT TWICE OVER, DELIBERATELY.** `type_dmg_bonus` CAN reach a companion —
    the kindling modifier writes `{"fire": 0.25}` onto one, measured — but **a companion's blow
    carries no `dmg_type` at all**, so adding the read would find nothing to apply. `check_du` §4
    drives a stamped companion through forty blows and requires the total unchanged, so the day a
    companion's blow grows a type the gate says the second reason is gone. **`dmg_bonus` cannot
    reach one**: the summon copies Attack, armour, speed, crit and `companion_power` off the hunter
    and not that, measured at 0.000.
  - **NOTHING FURTHER WAS WIDENED AND THAT IS THE RULING, NOT AN OMISSION.** `CLAUDE.md` carries the
    line: **a player effect that lands and pays nothing costs the player a card; an ENEMY effect
    that lands and pays nothing costs the player nothing.** The first is a dead card, the second is
    an exploit — and **a general widening would hang visible chips on a companion that change
    nothing, which is worse than the narrow miss because it reads as working.**
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
- **THE ABILITY CORPUS IS 227, AND THE TWO WALKS DELIBERATELY DO NOT AGREE ANY MORE.** DR moved it
  net +1 (one card retired, two authored), **DS moved it +6, and DU §4 moved it +4 WITHOUT
  AUTHORING ANYTHING** — `apply_kit_overrides` builds FOUR SPECS' `abilities[0]` at spawn (**THREE Mage and ONE CLERIC — DV §5 corrected DU's "four Mage specs"; Shadowrend is the OCCULTIST's and overrides Smite out of `kit("cleric")`, so TWO class kits were misread, not one**)
  and none of them sits in any pool, so the walk read `kit("mage")` and carried the **unoverridden
  Magic Bolt, which is nobody's live basic attack.** The walk applies the overrides now. The Batch
  CL enumeration reached **211** for as long as talents granted abilities; the five it missed —
  Backdraft, Pyroblast, Glacial Prison, Cryoclasm, Intercession — were talent grants living in no
  pool. **DO put all twenty-two into `SPEC_DRAFT_POOLS`, which the CL walk reads, so it reaches all
  of those and `Classes.talent_granted_names()` is EMPTY.**
  **`check_cz` §0 ASSERTS A SET IDENTITY NOW RATHER THAN AN EQUALITY, WHICH IS NOT A LOOSENING**:
  the names the complete walk reaches and the CL walk cannot must be **exactly** the overridden
  basics, **derived off `apply_kit_overrides` itself** so a fifth override is covered by doing
  nothing. **The control's job is intact** — an ability falling outside every kit and pool would be
  in NEITHER walk and cannot hide inside the difference. **`check_da` §3 asserts that no gate
  hand-rolls the walk**, with `check_cz`'s `_cl_only_corpus` named as the one deliberate exemption
  (its REASON string has now been corrected twice, at DO and at DU, for the same reason both times:
  the exemption stood while the sentence explaining it went stale).
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

### THE TEST TREE, AS OF DV

- **47 `test_*.gd` files**: 44 `test_batch_*` spanning `ah` to `cp` (with gaps — they are NOT one
  per batch), plus `test_run_harness`, `test_runes` and `test_rune_battle`. **They live at the repo
  ROOT, not in `scripts/`.**
- **`_spawn` IS AUTHORED ONCE, IN `suite_fixture.gd`, AND 37 SUITES GO THROUGH IT.** `_kill` too, in
  14. Each suite keeps its OWN `_spawn` SIGNATURE and delegates, so **all 389 call sites are
  untouched.**
- **`run_battery.sh` RUNS 46 SUITES AND MISSES NONE.** The `GATES` array is **twenty-five** —
  **DV ADDED `check_dv`, THE COMPANION TO ITS OWN RULINGS**, and before it DU added `check_du`. `cripple` and `chilled` had no instrument in either direction, so the day the read was
  ADDED nothing would have noticed, and removing it again would have been silent. **IT ASSERTS THE
  RATIO AND NOT THE READ SITE** — a gate that checked `battle.gd` *contains* a cripple read would
  have passed on all nine of the statuses DT drove onto a live companion at 1.0000. **There are 32
  `check_*.gd` files**, so **seven are not in `GATES`** — `check_ck_width`,
  `check_cu`, `check_cv`, `check_dn`, `check_ct_map`, `check_map_screen` and `check_de`. **`check_ct_map` and
  `check_map_screen` run in the SCENE RUNS section and `check_de` runs in its own post-pass section
  AFTER them**, so the four that run nowhere are `check_ck_width`, `check_cu`, `check_cv` and `check_dn`.
- **`check_ds` NEEDS NO `check_da` §3 EXEMPTION AND IT TOOK A RED TO ESTABLISH THAT.** It calls
  neither draft-pool accessor; its **header comment named both of them** while explaining that it
  does not, and §3's fingerprint is a substring match over the whole source. **The names came out of
  the prose rather than an exemption being granted** — an exemption granted to a sentence would
  blind §3 to a real walk arriving in that file later, which is worse than the violation it covers.
  **`check_du` NEEDED NO EXEMPTION EITHER AND DID NOT TRIP §3 AT ALL**, because that lesson was
  applied rather than re-learned: it reads neither draft-pool accessor and its comments name
  neither. **`check_dv` NEEDED NONE EITHER**, for the same reason, and was run standalone before the
  battery to prove it: `check_da` reads **37/0 over 32 gates**.
  - **AND §3 HAS A BLIND SPOT DV §5 FOUND, WHICH IS WHERE THE LAST HAND-ROLLED WALK LIVES.** Its
    walk sweep reads **`check_*.gd` ONLY** — the suite half of §3 is about `_spawn` — and its
    fingerprint matches the two pool **ACCESSORS**, where `test_batch_cp._corpus()` reads the pool
    **CONSTANTS** and `Classes.kit(cls)`. **That walk reaches 211 where the corpus reaches 227**, so
    `check_da` reads 37/0 with a real violation standing in the tree. **Reported, not fixed.**
- **THE BATTERY WRITES A MANIFEST, `$OUT/.ran`, AND THE DIFFER TRUSTS IT RATHER THAN THE DIRECTORY
  LISTING.** `run_battery.sh` does NOT clear `$OUT` between runs, so a target that failed to launch
  would otherwise be blessed by its PREVIOUS run's log. A name is appended immediately before its
  target is launched and `run_one` truncates the log at spawn, so **a log named in the manifest is
  always this run's**. A subset invocation (`./run_battery.sh bo bp`) writes a short manifest and
  **the differ reports the rest as DID NOT RUN instead of certifying a clean tree.**
- **`gate_fixture.gd` AND `suite_fixture.gd` ARE NOT GATES AND ARE DELIBERATELY NOT NAMED
  `check_*`/`test_*`** — `test_batch_cd` and `check_da` both glob those prefixes.
- **THE BASELINE TABLE IS `baselines.json` AND IT IS 76 ROWS: 46 suites, 25 gates, 2 scene runs
  and 3 harness gates.** **DV ADDED `check_dv` AND MOVED NOTHING ELSE AT ALL** — the only row this
  batch touched is the new one, and `check_de` read ZERO NOTICES, so not one check count in the tree
  moved outside its band. DU added `check_du` and moved `check_cz`. **`check_de` HAS NO ROW OF ITS
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
- **master.html stamp: `Last updated: 2026-08-29 (Batch DV)`** — **DV MOVED THE STAMP AND TWO REAL
  THINGS, ONE OF WHICH WAS A DEFECT RATHER THAN AN ADDITION.** (1) The Ashes of Al'ar paragraph says
  the phoenix cannot be recast while it stands or after it has risen, and that the button says which
  — the player-facing half of §3. (2) **THAT PARAGRAPH SAID THE PHOENIX RETURNS AT 25% AND BOTH THE
  CARD AND THE CODE PAY 40**: it was quoting `ASHES_RETURN`, the dead constant, against the
  `ASHES_RETURN_PERFECT` the handler writes unconditionally. **Corrected toward the code**, which is
  the standing direction. **THE RETIRED-WORD SWEEP WAS RUN OVER THE EDITED PROSE BEFORE THE BATTERY
  AND READ 0 BOTH WAYS** — DU was caught by that sweep and DS took four reds from it.

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
- **THE LIVE FILE WAS CUT AT DV, AT THE DF/DG BOUNDARY.** It starts at **Batch DG** and holds
  **16 entries** (DG → DV), **150.0 KiB**. **406.0 KiB crossed CW's 400 threshold at DU exactly as
  DU predicted.** With DV's entry the file held 34; **16 stay and 18 move.**
- **`DoD-archive/changelog-archive.html` holds 149 entries** (Batch 1 → **DF**) and is
  **1314.3 KiB**. **IT IS OUTSIDE THE REPO, SO IT IS NOT IN VERSION CONTROL AND NOT BACKED UP BY
  GITHUB, AND THIS CUT MADE THAT EXPOSURE LARGER.** The entries it moved — **CO through DF** — are
  recoverable only from the commit of Batch DU. It is still the designer's call.
- **THE VERIFICATION IS THE THING TO REPEAT, NOT THE CUT.** A SECOND script reading untouched
  backups, sharing nothing with the splitter: headings counted two independent ways on all four
  files, counts summing 16 + 18 = 34, zero overlap, order preserved, every heading exactly once,
  none invented, no entry edited, and **the two bodies rejoined BYTE-IDENTICAL to the original**.
  **NO FILE SIZE WAS ASSERTED ANYWHERE** — sizes agreeing is consistent with a duplicated entry and
  a dropped one.
- **FOURTEEN SUITES DEPEND ON A FILE THAT IS NOT IN VERSION CONTROL** — bb, bn, bo, bp, bq, br, bs,
  bt, bu, bv, bw, bx, cb, ce. On a machine without `DoD-archive/` they FAIL LOUDLY, which is
  correct. **NONE OF THE FOURTEEN NEEDED RE-POINTING AT DV, AND THAT IS CX's WORK RATHER THAN DV's**:
  every live-changelog assertion in the tree is either the archive-path anchor or a **negative**
  `not contains("<h2>… Batch XX")`, which a cut can only make more true.

### Knowledge sync, re-measured at DV
*Measured over `.gd .md .html .json .py .sh`, excluding `assets/`, `.git/` and `.godot/`.
**Treat the file COUNT as method-dependent** — the walks have differed by one before, and the
SIZES are the comparable half. **ALL SIZES BELOW ARE KiB (1024 bytes)**.*
- **152 files, 6.77 MiB** (DU measured 151 / 6.97). **THE SYNC FELL FOR THE FIRST TIME IN THE
  PROJECT'S HISTORY**, and it fell because **DV §4 moved 256 KiB of changelog OUT OF THE REPO.**
  DV added two files — `check_dv.gd` and `docs/reports/DV.md`.
- Heaviest: `scripts/battle.gd` **1225**, `docs/design-notes.md` **373**, `docs/master.html`
  **336**, `scripts/classes.gd` **315**, `CLAUDE.md` **247**, `scripts/talents.gd` **179**,
  `scripts/unit.gd` **177**, `docs/talent-audit.html` **165**, `docs/changelog.html` **150**.
  **`docs/changelog.html` WAS THE SECOND-HEAVIEST FILE IN THE SYNC AND IS NOW THE NINTH** (406 →
  150).
- **The 47 suite files are unchanged in number and still the single largest block. They cannot be
  archived (they must be in the repo to run) but they CAN be deselected from the sync.** The gates
  are **32** now — `check_dv.gd` is the thirty-second.
- **`CLAUDE.md` IS 247 KiB = 3.56%**, up from 3.38% at DU. **THE RATIO ROSE FOR TWO REASONS AT
  ONCE**: DV added three rules, **and the denominator shrank underneath it.** CW's *"under 3% and
  roughly flat"* is still met on the second half and missed on the first. **DG THROUGH DV HAVE ALL
  DECLINED THE PRUNE**, and DV declined it while being in the file for DT's and DU's reason — the
  rules belong beside the blocks they extend. **But the fall in the denominator means the next
  batch in this file cannot decline it on the old arithmetic.**
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
nothing when it reads clean. **DV's acceptance is its EIGHTEENTH consecutive quiet reading.**

**THE RETIRED-WORD SWEEP CAUGHT DU TOO, AND IT WAS CAUGHT BEFORE THE BATTERY RATHER THAN BY IT.**
`test_batch_bx` §4 keeps *beast* out of player-facing prose and §4b keeps *party* out; both read
`master.html`. **DU's new companion paragraph called Hunter's Mark "party-wide"** and would have
failed §4b. It says "the ownerless Hunter's Mark" now — the phrase the card's own row already used.
**A BATCH WRITING COMPANION PROSE IS THE BATCH THAT REINTRODUCES A RETIRED WORD**: DS hit the same
trap with *beast* on all four of its battery-1 reds. **The cheap defence is to run the sweep's own
strip over the edited document before the battery**, which is what turned this one into a
five-minute fix instead of a second thirty-five-minute run. `bx` reads **157 / 0**.

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

**ONE BATTERY AT DV, AND IT CERTIFIED CLEAN ON THE FIRST RUN.** **151 files were MD5-stamped before
it and re-compared after, and NOT ONE MOVED.**

| | DT's acceptance | DU's acceptance | DV's acceptance |
|---|---|---|---|
| **suite failures** | 0 | 0 | **0** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 309 / 0 / 0 | 313 / 0 / 0 | **317 / 0 / 0 — exactly the prediction** |
| targets in the manifest | 75 | 76 | **77** |

**SEVENTY-SEVEN TARGETS RAN AND THE MANIFEST NAMES ALL SEVENTY-SEVEN. 0 `Parse Error` and 0
`SCRIPT ERROR` in every log**, grepped from the streams rather than read off a tally or an exit
code. `check_map_screen: OK`; the run harness reads 22 / 165 / 8.

**ONE BASELINE ROW MOVED AND IT IS THE NEW ONE.** `check_dv` **NEW at 128 / 0**, and **nothing else
in the table moved at all** — `check_de` read **ZERO NOTICES**, so not one check count in the tree
drifted outside its band, the fourteen changelog-reading suites included. **`check_de` CERTIFIED ON
ITS FIRST PASS**, because the row was added BEFORE the battery from three identical standalone runs
of the new gate. Its own +4 for the new target is reported by nothing but this line.

**THE FLAKE ROW IS STILL NOT A REPAIR.** `test_batch_at`'s unseeded §1 ratio read **467 / 0**, the
**eighteenth** consecutive quiet reading. **It is still open, still unseeded and still banded, and a
red from it is not the next batch's.** `bo` read **1106** and `test_rune_battle` **97**, both seeded
and both closed.

**FOUR NEGATIVE CONTROLS, ALL FOUR BIT, AND ALL FOUR BIT ON DIFFERENT ASSERTIONS.** Deleting the
phoenix door's condition failed 2 (the armed and spent arms); **loosening it to `ashes_return > 0`
failed exactly 1 — the below-value arm alone**, which is what proves the exactness arm is separately
load-bearing; duplicating a heading across the two changelog halves failed 3 (the archive count, the
boundary check and the disjointness sweep); and giving one homeless ability a live home failed 4
(across §1 and §2). **`battle.gd`, `classes.gd` and the changelog archive were backed up to the
scratchpad and restored by `cp`, never by `git checkout`**, and all three md5s verified identical
afterwards.

**THE LITERAL SWEEP: 10,828 literals at a floor of 4**, from all 81 suites, gates and fixtures,
diffed against `git show HEAD` in one pass. **436 LOST, every one of them in `docs/changelog.html`,
and NOT ONE OF THEM ASSERTED THERE** — proved mechanically: every live-changelog assertion in the
tree is either the archive-path anchor or a **negative**, which the cut can only make more true.
**58 GAINED and the dangerous kind is ZERO**: every `not <doc>.contains(L)` in the tree was
cross-referenced against the gained literals, with one hit — `bx`'s identifier-stripped
`not master.contains("party")` — which the pre-battery strip cleared at 0 both now and at HEAD.

**THE COMMENT-STRIPPED DIFF WAS TAKEN AGAINST `HEAD`.** `battle.gd` GAINED exactly **8** code lines
and lost 0 (the three-line refusal and the five-line tooltip block); **`classes.gd` GAINED 0 AND
LOST 0**, which is the proof its edit really was comments-only; `run_battery.sh` changed one line.
**Nothing was swallowed.**

**THE PARSE CHECK WAS GREPPED FROM STDERR AFTER EVERY EDIT**, never from the tally and never from
the exit code.

**AND THE RETIRED-WORD SWEEP WAS RUN BEFORE THE BATTERY RATHER THAN BY IT**, using `test_batch_bx`
§4b's own `PARTY_IDENTS` strip over the edited `master.html`: **0 surviving occurrences of *party*
now and at HEAD**, and 0 of *beast* with `Beastmaster` removed. DU was caught by this sweep and DS
took four reds from it.
