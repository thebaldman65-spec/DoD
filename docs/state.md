# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

*Last rewritten: 2026-08-31 (Batch ED).*

---

## WHERE THE PROJECT IS

- **Last batch: ED — THE UNREAD THIRD WAS NOT UNREAD, AND THE PINS GET A MANIFEST.** A prune that
  retired nothing, and the coverage EC reported and ruled on nowhere. **ALL 43 NEVER-CITED BLOCKS OF
  `CLAUDE.md` WERE READ IN FULL AND EVERY ONE IS LIVE — ZERO RETIREMENTS, TWO STALE *NAMES* REPAIRED
  INSTEAD — AND THE SOURCE-PIN MANIFEST IS BUILT, DERIVED BY A COMMITTED GENERATOR AND ENFORCED BY A
  NEW GATE EVERY BATTERY.** **NO GAME BEHAVIOUR CHANGED, NO ABILITY MOVED AND NO CARD WAS
  AUTHORED.** **Report: `docs/reports/ED.md`.**
- **§1 — THE MEASUREMENT WAS SOUND AND THE INFERENCE WAS NOT.** EC measured a third of `CLAUDE.md`
  as neither asserted nor quoted since its own batch wrote it, and the brief ruled the file "a third
  unread". **Re-derived at HEAD it is 43 blocks and 33.3%, not EC's 42 and 32.0%.**
  - **THE BLOCK THAT MOVED SHOWS WHAT THE MEASURE ACTUALLY MEASURES.** *"THE PROTECTED CORE IS THE
    BASELINE (EB §1)"* was quoted for EC and is not now: **its only quotation lived in EB's
    `docs/state.md`, and EC's own rewrite of that file dropped the sentence.** This file is inside
    the knowledge sync and is rewritten every batch, so **"is this rule quoted anywhere?" is partly a
    question about what the last rewrite happened to say.**
  - **ZERO RETIREMENTS, AGAINST THE BRIEF'S THREE CATEGORIES: 0 dead rules, 0 surviving narrative,
    and 43 rules that bind future work and are simply obeyed.** Nobody quotes the rule they are
    following, so a well-obeyed rule and a dead one look identical under a citation count.
  - **BOTH HALVES WERE TESTED RATHER THAN JUDGED.** The *asserted* half is complete — an independent
    extraction of every literal tested against `CLAUDE.md` lands **ZERO** in a block the census
    called never-asserted, so nothing is load-bearing in a way the measure cannot see. The *liveness*
    half asked whether each block's SUBJECT still exists, against a declaration table with string
    literals masked (the checks that pin `roll_ability_offer` ABSENT are exactly what make a grep
    report it alive). **Its first build read `'` as a string delimiter, let an apostrophe in one
    comment swallow every declaration to the next one, and reported `_apply_status` and
    `vault_ability` as deleted — 4,348 symbols against the real 6,786. The control caught it.**
  - **TWO STALE NAMES, BOTH REPAIRED, AND BOTH ARE RENAMES RATHER THAN DELETIONS.**
    **`wild_communion_ranks` has not existed since Batch AY** — the live field is
    `wild_communion_step`, and `test_batch_ay` pins the ranked form ABSENT from `battle.gd`, so the
    guide named the dead one while a suite asserted it dead. And **the debug-surface table claimed
    four retired sim flags are "still printed as retired in the report header"; the sim prints no
    such line and `scripts/` names none of them.**
  - **THE 3% TARGET IS BELOW THE GROWTH LAW AND THAT IS NOW MEASURED.** Over **eighteen prune-free
    batches (DJ→EC)** `CLAUDE.md` grows **+4,835 B** against a sync growing **+79,726 B** — a
    **marginal rate of 6.06%**, which is where the ratio converges. Post-DZ alone it is **8.70%**.
    **3% is reachable only by pruning, about every eight batches, forever**, and this batch has
    established there is no dead weight to take it from. **RULED ON NOWHERE — carried below.**
- **§2 — THE SOURCE-PIN MANIFEST, AND EC'S CENSUS WAS SHORT BY NINETY-NINE.** EC reported the
  population two ways — **915** in its report and this file, **917** four times in the changelog.
  **Both were low. The live figure is 1014**, and the reason is EC §1's own defect in a second
  instrument: the census captured a fixed 600-character window after each locator, `finditer` resumes
  at the END of a match, **so the second member of every `contains(A) and contains(B)` fell inside
  the first match and was never seen.** Three smaller holes sat beside it — a holder bound across two
  lines never bound at all, a masker that knew only double quotes merging sixty lines into one
  statement, and format templates dropped rather than recorded.
  - **`pin-manifest.json` HOLDS 1313 PINS: 1014 INTO `.gd` SOURCE ACROSS 17 FILES, 229 INTO THE FOUR
    TRACKED DOCUMENTS, 70 ELSEWHERE.** The document instruments watch the smaller half by **4.4×**.
    **THE LIVE FIGURES ARE NOT RESTATED IN `CLAUDE.md`** — that block points at the instrument now,
    which is DJ §3's rule applied to the figure that had already rotted three ways inside one batch.
  - **EACH PIN CARRIES A RESIDENCY, RE-DERIVED RATHER THAN DECLARED: 600 anchored to CODE, 39
    resolving ONLY inside a COMMENT, 285 negative and correctly absent, 17 whose haystack is
    narrower than a file, 71 composed at runtime and 2 alternation siblings.** **926 of the 1014 are
    verified every battery and the other 88 are PRINTED as unverified**, because a coverage figure
    nobody states reads as full coverage.
  - **THE 39 COMMENT-RESIDENT PINS ARE THE FRAGILE HALF AND THEY ARE FLAGGED** — 22 into
    `classes.gd`, 14 into `battle.gd`, 2 into `run_sim.gd`, 1 into `run_state.gd`. **Thirteen are the
    `AXIS`/`SYNERGY` header convention pinned by six different tranche suites**, so one tidy-up of
    those headers reds six suites at once, and `check_ed` §3 asserts that from outside.
  - **THE SPLIT IS WHAT STOPS THE MANIFEST GOING STALE.** `build_pin_manifest.py` DERIVES it —
    attribution needs holder propagation through function parameters, since `test_batch_bl` reads
    `battle.gd` in `_run()` and asserts on it 536 lines later inside a helper it passed the holder
    to. **`check_ed` ENFORCES it and re-derives none of that**, so the enforcing half cannot drift
    from the deriving one. `build_pin_manifest.py --check` is the exact authority; **what `check_ed`
    §2 cannot see is written down at §2 itself** (DW §1).
  - **THE FIRST COMPLETENESS RULE WAS WRONG AND ITS EXEMPTION COUNT SAID SO.** Demanding an entry
    for every literal in a locator call anywhere would have needed **663 exemptions out of 1646**.
    Scoping the demand to holders bound to a real file, **per function**, brings it to **zero**;
    scoping it per FILE reds a clean tree, because `src` is bound to four different documents across
    `test_batch_bx` alone.
  - **EC'S VACUOUS CHECK IS CONFIRMED CLOSED, MEASURED RATHER THAN READ**: `test_batch_bg`'s slice
    runs **9,417 characters**, its opening anchor is asserted, and it carries a POSITIVE assertion
    that cannot pass on an empty string.
  - **AND THE SWEEP FOR THAT SHAPE FOUND THREE MORE. 87 `find`-then-`substr` slices in the tree**:
    51 guarded, 14 self-proving, 14 archive-path extraction that fails loudly, the 3 documented
    vacuous ones in `as`/`at`/`aw`, and **THREE that were live, resolving and UNGUARDED** —
    `check_dr` §5, `test_batch_bm`'s negative control 4 and `test_batch_bs`'s kiln tick. None was
    vacuous; **each was one deleted anchor away from going silent.** All three assert their anchor
    now, one check each.
- **Next letter: EE.** The stamp compare reads exactly TWO characters, so a THREE-letter code is
  what breaks it — still a long way off.
- **Phase.** The ability draft is **COMPLETE at 154 of 154** and all twelve talent trees are
  purpose-authored and charter-clean. Recent batches are correction and consolidation: DZ pricing two
  open questions without ruling on either, EA building the fallback DZ priced, EB ruling on that
  finding and discovering that a comment in a `.gd` file is an asserted surface, EC closing the
  boundary that discovery exposed, **and ED covering the half the instruments were never watching —
  and finding that the file everyone assumed was bloated is not.**

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION

### THE DRAFT AUDIT — TWO FINDINGS RULED AT DR, THE REST STILL OPEN

**Full evidence: `docs/draft-audit.html` (both grade-2 findings now carry a RESOLVED banner) and
`docs/reports/DQ.md`.** Everything below is still open and **no gate encodes any of it**, because
a gate encodes a ruling.

**ITS ARITHMETIC WAS MARKED STALE AT DT AND IS RE-DERIVED AT DY §5. §2 AND §2b ARE CURRENT OVER
THE LIVE 154.** The audit measured the draft at **142**; DR was net +1, DS +6 and DY +5.
**NINE OF THE SIXTEEN POOL ROWS MOVED AND SEVEN DID NOT** — Swordmaster and Cryomancer (DR),
Beastmaster, Sharpshooter and Survivalist (DS), Warden, Arcanist, Devout and the Mage class pool
(DY); Berserker, Holy Cleric, Occultist, Pyromancer and the Cleric, Hunter and Warrior class pools
did not. **THE METHOD IS DQ's, UNCHANGED AND DELIBERATELY SO** — one primary axis per card, and the
eleven cards authored since were assigned inside that vocabulary rather than a re-cut one, because a
refresh that also moves the definitions cannot be compared with what it replaced.
- **THE WARDEN IS THE SHARPEST RESULT: the shallowest pool in the game now holds the JOINT-WIDEST
  decision spread in it — ten decisions across ten cards, the only pool where every card makes a
  different decision.** **THE MAGE CLASS POOL IS THE OPPOSITE**: seven cards, six decisions.
- **AND TWO COUNTS IN THAT DOCUMENT WERE PRODUCED BY DIFFERENT METHODS, WHICH IS NOW LABELLED.**
  DR reported its own repair as taking the Swordmaster *"four → eight decisions"*; by DQ's method it
  is **seven**, because DR counted Wheeling Cut's self-mitigation as a second axis on one card.
  Neither is wrong and both were in the page unlabelled.
- **`test_batch_cd.PER_SPEC_DEPTH` IS STILL THE ONE AUTHORITATIVE DEPTH TABLE** — this page is not
  an instrument and nothing re-derives it, which is exactly the hazard DJ recorded a rule about.
  **The Beastmaster's 8-of-8 engine binding reads 10-of-10** and is if anything tighter.

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
is the audit, and like DQ's it changed nothing. **`SPEC_POOLS` is 44 entries across twelve specs,
42 distinct names** (DY §2 added Dawnbreak and Sanctuary to Holy's). A zone boss awards ONE pick per hero from that hero's spec pool alone, there
are THREE zone bosses, and **both channels write the same `bm_abilities` list — so a drafted card
removes itself from the boss offer and vice versa.**

- **`CLASS_POOLS` IS DELETED AT DY §3 AND THE THREAD IS CLOSED.** DV ruled it a lost feature and
  deleted nothing; DX priced the options and authored nothing; **DY took option B — re-home the
  seven, retire the container.** 61 authored entries feeding an award AN §4 re-pointed eighteen
  batches ago. **`pool_ability()` never read it, so nothing stopped resolving**; what was lost is
  the manifest, and that is the point — they are no longer a group.
  - **THE SEVEN WERE THE VAULT, AND ALL SEVEN HAVE HOMES NOW.** `Classes.vault_ability()` holds the
    ONE definition of **TEN** live cards (not the 38 this file and DX §3 both recorded — counted off
    its own `match` arms). Five went to draft pools and two to Holy's boss pool; the other three
    were already in `SPEC_POOLS`. **Its header's promise — that its entries *"return as earnable
    picks without a line of new mechanics"* — is history rather than a plan, and it cost exactly
    that: not a line.**
  - **THE STANDING RULE IT LEAVES, IN `CLAUDE.md`: A NEW VAULT ENTRY IS OWED A POOL IN THE SAME
    BATCH.** A definition no pool names is reachable by nothing, which is the state that cost this
    project eighteen batches of silent audit and three batches of measured engineering — DK widened
    `sanctuary` and drove it on a live bear, DL widened Rallying Shout's Pressure clause and authored
    a new guard for it, DM read Divine Wrath's two clauses. **Not one of them was wrong and not one
    could have known.**
  - **AND THE DELETION'S REAL COST WAS THE READERS.** **EIGHTEEN FILES read it and a grep for the
    CONSTANT found only eleven** — `class_pool()`, its accessor, had callers whose lines never name
    it. **Sweep for the accessor as well as the constant.** Every reader is re-pointed or inverted;
    none was left to pass vacuously.
  - **ONE DERIVED FIGURE MOVED FOR A REASON THAT IS NOT ABOUT THE GAME.** `check_dv` §5 counts the
    abilities outside every pool and every class kit: **16 → 43**, because `CLASS_POOLS` was the only
    structure naming the SIBLING SPECS' KIT ABILITIES as pool entries. **Nothing became less
    reachable** — all of them are in their own spec's opening kit. `check_cz`'s set identity held
    through the deletion, measured: the CL walk still reaches **223 of 227** and still misses exactly
    the four kit overrides.
- **THE FALLBACK IS BUILT AT EA §1 AND THIS WHOLE BLOCK IS NOW HISTORY WITH ONE LIVE HALF.**
  **NO ZONE-BOSS AWARD CAN PAY NOTHING ANY MORE** — an exhausted boss pool falls back to the
  hero's own spec DRAFT pool, three offered and announced like any other award. **What is still
  true, and is why the block below is kept rather than cut:** the boss POOLS are as thin as they
  ever were, eight specs can still empty one, and the Devout's is still 2 with both entries
  draftable. **Deepening a boss pool is still a live design option; it is no longer a defect.**
  `check_ea` §1 derives the depth table every run and `check_dv` §2 still measures the eight.
- **ONE POOL IS STILL THINNER THAN THE AWARD COUNT AND EIGHT SPECS CAN BE SHORT ONCE DRAFTING IS
  ACCOUNTED FOR — RE-MEASURED AT DY §2 AFTER HOLY'S FIX.** **The award count is THREE**, derived from
  `Run.SLOT_COUNT`. **HOLY'S HALF IS CLOSED** (1 → 3, Dawnbreak and Sanctuary), **AND THE GENERAL
  PROBLEM SURVIVED IT, WHICH IS THE HALF A READER WOULD OTHERWISE ASSUME WAS CLOSED.**
  - **THE DEVOUT IS THE SHARPEST CASE IN THE GAME NOW AND IS WORSE OFF THAN HOLY EVER WAS.** His pool
    is **2** — the only structural shortfall left — and **BOTH of his two are also draftable**, so
    all three of his zone-boss awards can pay nothing. Holy's was visible because it was
    structurally short; his is invisible because it depends on what the player drafted.
  - **EIGHT OF THE TWELVE CAN BE SHORT.** Devout 3 awards at risk; Berserker, Pyromancer, Cryomancer
    and Occultist 2 apiece; Swordmaster, Arcanist and Holy 1 apiece. **Only the Warden and the three
    Hunter specs cannot lose an award.** That population did not move — DY changed Holy's severity,
    not the count.
  - **THE FIGURE NOBODY HAD PUT A NUMBER ON, DERIVED AT DZ §1: 14 OF THE GAME'S 36 ZONE-BOSS
    AWARDS COULD PAY NOTHING**, in a run where every hero drafts against their own boss pool.
    **EA §1 TOOK IT TO 0**, and the thinnest fallback pool in the game is the Occultist's 5.
  - **WHAT HAPPENED BEFORE EA WAS NOT A WEAK REWARD, IT WAS NO ACKNOWLEDGEMENT AT ALL.**
    `award_ability_pick` returned false and `_award_ability_picks` **silently skipped that hero**,
    so the victory card did not name them. **That was the baseline the fallback was measured
    against, and closing it is why EA's control reads the announcement off the end card's own
    Label rather than asserting that `battle.gd` contains a line.**
  - **THE FALLBACK QUESTION IS CLOSED AT EA §1: OPTION A WAS TAKEN.** The four candidates were
    priced at 154 in `docs/reports/DZ.md` §1 (DV §2 priced them at 149, against a game that has
    moved); **EA built the spec-draft card.** The pricing is kept because it records why the other
    three were not taken:
    - **A spec-draft card or a class-wide card closes the table completely** — 8 emptiable specs →
      **0**, 14 lost awards → **0** — and **neither fallback pool can itself empty**: a hero holds
      at most `ABILITY_SLOT_CAP − core_slots` = **4** earned (3 for Holy) against spec pools of
      10–13 and class pools of 6–7. **Floors: SIX cards and TWO cards.**
    - **A rune has the lowest build cost of the four and it is measured rather than asserted** —
      the grant is the same two fields the ability pick already uses (`rune_candidates` /
      `rune_picks_owed` against `bm_candidates` / `bm_picks_owed`) and the map's owed-pick overlay
      resolves both. **But `roll_rune_candidates` returns `[]` when runes are off or the pool is
      exhausted, so this option needs its own fallback.** 3 rune slots a hero, 65 in the pool.
    - **Gold does not move the table at all** — all fourteen are still lost as ABILITY awards. A
      zone boss already pays `randi_range(110, 130)`.
    - **AND A CLASS-WIDE CARD IS NOT THE THING DY §3 FORBADE.** That rule says do not re-create
      `CLASS_POOLS`; its own next sentence says a re-opened class draw reads `CLASS_DRAFT_POOLS`,
      which is what this option reads. **Worth naming, because it looks like a violation and
      is not.**
  - **THE SLOT ARGUMENT HAS MOVED AND IT NOW POINTS AT ONE SPEC RATHER THAN AT THE FIX.** DV's
    *"the card-shaped options are worth least exactly where the hole is worst"* was true while
    Holy's pool was ONE. **She can now lose ONE award of three and the Devout can lose ALL THREE,
    and the Devout carries the normal FOUR earnable slots against her three.** The objection
    applies to Holy's single award, not to the fallback in general.
  - **AND "the only spec that carries FOUR protected cores" IS HALF RIGHT.** `core_slots("holy")`
    is 4 and is the only 4 in the table; **`protected_names("holy")` returns FIVE names and the
    Devout's returns FOUR.** `slots` is authored and deliberately not a name count — the
    Beastmaster's three summons are five abilities in three slots. **The slot claim holds; the
    phrase does not, and it is the phrase that travels.**
  - **AND DY §1 RECOMMENDS ONE MOVE THAT WOULD CLOSE THE DEVOUT'S HALF AND THE SANCTUARY OVERLAP AT
    ONCE — PUTTING SANCTUARY IN HIS BOSS POOL RATHER THAN HOLY'S. It is not taken.**
  - `check_dv` §2 derives every end of this every run and prints the table.
- **28 of the 44 are boss-only; 16 are also in the same spec's draft pool** (DY's two are boss-only). The only name in more
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

### THE THREE PRICING QUESTIONS — THE LAYER-WIDE ONE IS **RULED AT EB §1**; THE OTHER TWO ARE STILL THE DESIGNER'S

**RULED AT EB §1: THE PROTECTED CORE IS THE BASELINE AND THE DRAFT CARD PAYS FOR ITS SLOT.** The
13-of-17 is the design working, not a mispricing, and `CLAUDE.md` carries the ruling with its
reasoning AND its counter-reading. **`check_eb` §1 asserts the INVERSION** — a draft card cheaper on
resource AND shorter on cooldown than a comparable core — **with exactly one crossover named
(Divine Plea against Renewal), in both directions.** The cap's 29.5%-against-12.8% is the same
relationship through the cap and is not a second finding. **`Ability.PURE_BUFFS` was not widened
and no magnitude moved.** The measurement below is kept because the ruling is *about* it.

**AND EA §3 ANSWERED THE QUESTION DZ's §2 RAISED: IT IS NOT ONE CARD, IT IS THE LAYER.** Every
protected core was compared against the draft cards that do comparable work, controlled for spec
(one currency), role (derived from the fields) and initiative, with `PURE_BUFFS` members excluded
from both sides because a clamped initiative is not a price anyone chose. **17 comparable pairs;
13 of the 17 have the core cheaper on an axis and dearer on neither. Resource: cheaper 10, dearer
2. Cooldown: shorter 13, longer 1. Both counter-cases are the same draft card — Divine Plea, at 0
Mana — against Holy's Heal and Renewal.** Cores are SLOWER in every role bucket, which is why the
equal-initiative control is the comparison that counts. **`BUFF_DELAY_CAP` binds 29.5% of the draft
layer against 12.8% of the cores.** **THE COUNTER-ARGUMENT TRAVELS WITH THE NUMBER**: a core
arrives free with the spec and a draft card costs a pick, so "cheaper to cast" is what a designer
would author on purpose if the core is the baseline — and nothing in the code distinguishes the two
readings. **EB §1 RULED IT: the first reading is intended, and `CLAUDE.md` carries the ruling with
the counter-reading beside it.** `check_ea` §4 pins the DIRECTION rather than the counts, so a pool
growing does not red it, and **`check_eb` §1 pins the per-pair INVERSION the ruling does not
cover**, with the one crossover named in both directions.

**Full working: `docs/reports/DZ.md` §2 (the first two) and `docs/reports/DY.md` §1 (all three as
first raised).** DZ measured and ruled on nothing.

- **(1) DIVINE WRATH AGAINST BLESSING OF ZEAL — AND THE QUESTION AS ASKED HAS NO ANSWER, BECAUSE
  ONLY ONE OF THE TWO HAS A PRICE.** `divine_wrath` is in `Ability.PURE_BUFFS`, so
  `Ability.make()` clamps it to `BUFF_DELAY_CAP` and the definition writes the constant.
  **Both memberships are CORRECT, driven live**: Zeal moves the target's cooldowns at cast and
  Arcane Surge moves the caster's Resonance — the two exclusions `ability.gd`'s own header already
  names for Blink and Stabilize — while Divine Wrath writes one status to four heroes and nothing
  else. **The structural finding is that the cap is the only instrument in the project that prices
  an initiative and it binds by membership**, so a card excluded for a second payload is priced
  against nothing.
  - **THE FAMILY IS WHAT PRICES THEM, AND ARCANE SURGE IS THE CARD THAT BREAKS THE PATTERN.** Across
    the eleven second-payload exclusions the header names, Mana rises with initiative — and Arcane
    Surge carries the family's TOP initiative (3.0) on **15 Mana / cooldown 3**, against Hold the
    Line's **30 / 6** at the same 3.0. **Blessing of Zeal sits ON the line on initiative and UNDER
    it on cost and cooldown**, so **if either of the two is mispriced it is the protected core and
    it is mispriced LOW.**
  - **AND THE TWO DAMAGE TERMS STACK: a Devout who drafts Divine Wrath and casts Zeal on the same
    hero pays both**, 1.3225. Measured at 1.3333 over twelve seeded blows, with the three chipped
    arms byte-identical across both orders.
  - **NOTHING WAS RETUNED AND `PURE_BUFFS` WAS NOT WIDENED.**
- **(2) ARCANE SURGE'S 3.0 IS THE SAME QUESTION, AND IT IS ANSWERED BY THE FAMILY RATHER THAN BY THE
  CAP.** It is legitimately outside `PURE_BUFFS` — the Resonance bank is a real second cast-time
  payload, measured — so *"three times the cap"* is not the comparison that means anything. **The
  comparison that does is Hold the Line at the same initiative for double the Mana and double the
  cooldown.** For scale, the corpus holds 37 abilities at 3.0 and 19 above it.
- **(3) SANCTUARY OVERLAPS HYMN OF HOPE, HOLY'S PROTECTED CORE PARTY-HEAL, AND THAT IS UNTOUCHED
  SINCE DY.** Hymn: 0 Mana + 1 Mercy, all allies 20% of max (35% empowered), initiative 3.5,
  cooldown 2. Sanctuary: 30 Mana, no Mercy, every ally 12% (18% on a Perfect), initiative 3.5,
  cooldown 4. **It clears the LETTER of the no-duplication rule** — that rule forbids a strictly
  BETTER card in the same pool, and Sanctuary is strictly worse on magnitude and pays a different
  currency — **and raises the question the rule exists for.** DY recommended moving it to the
  DEVOUT's boss pool, which would answer this and shorten the Devout's shortfall at once.
  **It is not taken, and DZ did not revisit it.**

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

### THE FLAKES — **AND THERE ARE NONE. DY SEEDED THE LAST ONE.**

**`test_batch_at` §1 IS SEEDED AND CLOSED AT DY §4, AND IT SETTLED AT ZERO — SO IT WAS A FLAKE AND
NOT A FINDING.** **THERE ARE NO UNSEEDED FLAKES LEFT IN THE PROJECT.**
**AND THE CENSUS WAS TWO ROWS, NOT ONE — THIS FILE SAID ONE AND WAS WRONG.** DX recorded
*"`test_batch_at` is the one row still carrying a `flake` field"*; **`test_rune_battle` carries one
too**, and it is KEPT ON PURPOSE. DF §0 seeded that suite at the site that flakes, but its recorded
rate is a RACE UNDER MACHINE LOAD — 2 red in 15, both under load — and **a seed does not fix a
race**, so the field and the `[0,1]` band both stand. **ONE ROW CARRIES A `flake` FIELD NOW AND IT
IS A SEEDED ONE.** Its own `what` text still read *"test_rune_battle calls `seed()` ZERO times"*,
which DF made false and DT corrected in this file but not there; **DY corrected the record itself.**

- **WHAT IT WAS.** §1's live damage-curve check sums ten casts of Arcane Explosion at 0 Resonance
  against ten at 12 and asserts the ratio is `> 2.0 and < 2.35` against a table value of **2.17**. It
  read **2.40** at DG and clean in every battery since — **twenty consecutive quiet readings at an
  observed rate of about one in eighteen, which proves nothing.** **The file calls `seed()` in four
  places and every one of them is DOWNSTREAM of this check.**
- **THE FIX IS TWO LINES AND THEY ALREADY EXISTED TWELVE LINES BELOW.** The TAKEN half of the same
  function has called `_seeded(_i)` before each of its two compared blows since DD; the DAMAGE half
  never did. Per-PAIR, not per-loop: both arms draw one identical stream so the ±10% roll cancels,
  and `_i` varies the draw across the ten pairs so the sum is still an average of ten variances.
- **MEASURED, WITH THE STARTUP STREAM VARIED BETWEEN TRIALS: six unseeded readings spanned
  2.1189–2.2463; six seeded readings all read 2.1799.** Exactly repeatable, and it lands on the
  table's 2.17.
- **THE BAND WAS NOT WIDENED — the band IS the question** (DD's rule). Opening it to swallow a 2.40
  would delete the check rather than repair it.
- **THE CHECK COUNT DID NOT MOVE: 467.** A seed is not an assertion.

### **AND NO SWEEP OF THE SOURCE CAN CERTIFY THERE IS NO NEXT ONE — ONLY READINGS CAN (DX §2)**

**A source sweep fails in BOTH directions and this is worth more than the answer it was asked for.**
**TWENTY suites and gates make unseeded random draws and are perfectly stable** (`bk` and `an`
generate whole maps), so `seed()`-count is not evidence of a flake. And **`test_batch_at` calls no
RNG function at all** — the noise was `battle.gd`'s `randf_range(0.9, 1.1)` in the strike loop, which
nothing in the suite tree can see. **THE INSTRUMENT THAT ANSWERS THIS QUESTION IS `baselines.json`:
the rows carrying a `flake` field are the answer, and nothing else is.** Four rows have carried one
in the project's history and **all four have been seeded** — `test_rune_battle` at DF §0, `bo` at
DT, `harness_2` at DX and `test_batch_at` at DY. **THREE SETTLED AT ZERO AND HAD THEIR FIELD
REMOVED; `test_rune_battle` KEEPS ITS FIELD AND ITS `[0,1]` BAND** because what it records is a race
under machine load rather than an unseeded draw.

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
- **`CLAUDE.md` IS PRUNED AT DZ §3 AND CW's TARGET IS MET ON BOTH HALVES FOR THE FIRST TIME.**
  CW set *"under 3% of the knowledge sync and roughly flat over time"*; the ratio had risen every
  batch from 3.25% at DI to **3.639%** at DY, and **DG through DY all declined the prune.** It is
  taken. **The live figures are in the knowledge-sync section below and are not restated here.**
  **THE ARITHMETIC OF THE TARGET IS NOT THE OBVIOUS ONE AND IS WORTH KEEPING**: pruning this file
  shrinks the sync's DENOMINATOR too, so clearing 3% needed **more than 47.8 KiB**, not the 46.4
  a naive subtraction gives. **AND THE PRUNE IS BOUNDED BY ASSERTIONS RATHER THAN BY JUDGEMENT** —
  **60 literals must survive verbatim** across the **26 targets that actually read the file** (9
  gates and 17 suites — a grep for the filename over-reports that population by two thirds, because
  18 more name it only in a comment), several of which read as history because a suite reads them. **THE BATCH-CODE PINS ARE CLOSED AT
  EA §2 AND THERE WERE SIX, NOT THREE** — the four bare ones (`BATCH BN`, `BATCH BS`, `BATCH CE`
  and `BATCH CG`, the fourth DZ predicted, one line under the third) plus two whose LITERAL merely
  carried a code. **All six re-pointed at the rule each was reaching for; none deleted.**
  `check_ea` §3 sweeps for a seventh every run, by the VARIABLE holding the document and scoped per
  function.
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

- **WHAT COVERS THE 915 SOURCE PINS — REPORTED AT EC §2, RULED ON NOWHERE.** Every document
  instrument watches the four tracked documents; **915 assertions across 52 suites pin a literal
  into a `.gd` file instead**, and **37 of them resolve only inside a COMMENT**, which is the
  haystack EB reworded with four instruments green. Three options with their costs are in
  `docs/reports/EC.md` §2: **extend the sweep to the edited sources** (it exists, it takes seconds,
  it fires only on files a batch edits and cannot tell a needle from prose); **a manifest of pinned
  literals** (a second place for the truth to rot); or **a rule forbidding source pins** (costs
  nothing to run, **invalidates all 915**, and is a rewrite rather than a rule). **The decision is
  the designer's, and the general shape is already in `CLAUDE.md` either way.**
- **WHETHER 3% IS STILL THE RIGHT TARGET FOR `CLAUDE.md` — MEASURED AT EC §3, RULED ON NOWHERE.**
  Three batches running have moved the ratio and the file grows by construction. **32.0% of it has
  never been asserted or quoted since its own batch wrote it**, so the pressure is not density.
  **Four options with their arithmetic — keep and prune periodically, raise the target to the
  measured steady state, cap the rule count so adding one retires one, or split the file the way
  CW split the changelog — are in `docs/reports/EC.md` §3 with no recommendation.**

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
- **THE ABILITY CORPUS IS 227 AND DY DID NOT MOVE IT — THAT WAS §0's WHOLE POINT.** Seven names
  reached it through `class_pool()` and no other route; re-homing them before deleting the container
  is why it reads 227 on both sides. **`Classes.vault_ability()` HOLDS TEN DEFINITIONS** and every
  one of them is now named by a live pool.
- **AND THE TWO WALKS DELIBERATELY DO NOT AGREE.** DR moved it
  net +1 (one card retired, two authored), **DS moved it +6, and DU §4 moved it +4 WITHOUT
  AUTHORING ANYTHING** — `apply_kit_overrides` builds FOUR SPECS' `abilities[0]` at spawn (**THREE Mage and ONE CLERIC — DV §5 corrected DU's "four Mage specs"; Shadowrend is the OCCULTIST's and overrides Smite out of `kit("cleric")`, so TWO class kits were misread, not one**)
  and none of them sits in any pool, so the walk read `kit("mage")` and carried the **unoverridden
  Magic Bolt, which is nobody's live basic attack.** The walk applies the overrides now. The Batch
  CL enumeration reached **211** for as long as talents granted abilities (and `test_batch_cp`'s
  copy of it **returned 207**, because four class basics it names do not resolve through
  `pool_ability` — DW §1); the five it missed —
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
- **The ability draft is COMPLETE at 154 of 154** — `SPEC_DRAFT_POOLS` is **129** and
  `CLASS_DRAFT_POOLS` is **25**, counted out of `classes.gd`. **NEITHER HALF IS A FLAT MULTIPLE ANY
  MORE.** DO's twenty-two took nine spec pools past eight, DR moved two of those nine (Swordmaster to
  TWELVE, Cryomancer down to ELEVEN), DS took the last three at eight to TEN, and **DY took the
  Warden to TEN, the Arcanist to TWELVE and the Devout to ELEVEN**. **THE SHALLOWEST SPEC POOL IN THE
  GAME IS TEN NOW** — the Warden's nine was the floor from DS to DY.
  **AND THE CLASS HALF STOPPED BEING 4 × 6 AT DY: the MAGE pool draws SEVEN and the other three draw
  six**, so `CLASS_TARGET` is a summed table (`test_batch_cd.PER_CLASS_DEPTH`) exactly as
  `SPEC_TARGET` has been since DO. **Do not write `12 * 8` or `4 * 6` again.**
  The asserted FLOORS are **8** (spec) and **6** (class) and both are slack everywhere; they stay
  there because they catch a pool that EMPTIES rather than tracking the deepening.
  **The one authoritative tables are `test_batch_cd.PER_SPEC_DEPTH` and `PER_CLASS_DEPTH`; every
  other suite asserts a FLOOR and the TOTAL.**
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

### THE TEST TREE, AS OF ED

- **47 `test_*.gd` files**: 44 `test_batch_*` spanning `ah` to `cp` (with gaps — they are NOT one
  per batch), plus `test_run_harness`, `test_runes` and `test_rune_battle`. **They live at the repo
  ROOT, not in `scripts/`.**
- **`_spawn` IS AUTHORED ONCE, IN `suite_fixture.gd`, AND 37 SUITES GO THROUGH IT.** `_kill` too, in
  14. Each suite keeps its OWN `_spawn` SIGNATURE and delegates, so **all 389 call sites are
  untouched.**
- **`run_battery.sh` RUNS 46 SUITES AND MISSES NONE.** The `GATES` array is **thirty** —
  **ED ADDED `check_ed`**, and before it EC added `check_ec`, EB `check_eb`, EA `check_ea`, DW
  `check_dw`, DV `check_dv` and DU `check_du`; **DZ AND DY EACH ADDED NONE.** **ED ADDED ONE BECAUSE
  §2 IS A RULING** — the manifest is the answer to the coverage question EC priced and left open,
  and a gate encodes a ruling. **§1 ADDED NOTHING, because its ruling is that nothing should
  change.** **EC ADDED ONE BECAUSE §1 IS AN
  INSTRUMENT REPAIR THAT HAS TO SURVIVE THE BATCH** — the scratchpad sweep is rebuilt every batch
  and a boundary fixed only there is a fix that expires. **§2 AND §3 ADDED NOTHING**, because both
  are measurements the brief forbids ruling on and a gate encodes a ruling. **EB ADDED ONE BECAUSE
  ITS §1 IS A RULING** — a gate
  encodes a ruling, and EB §1 is the ruling on the measurement EA handed over. **EA §3 WAS STILL A
  MEASUREMENT AND RODE IN `check_ea` PINNING A DIRECTION RATHER THAN A COUNT**, which is the
  shape that does not encode a ruling nobody made; `check_eb` §1 is the shape that does, now that
  the ruling exists. **`check_ec` IS A THIRD SHAPE: A PROPERTY OF THE INSTRUMENTS THEMSELVES**, and
  it carries its own discrimination control on synthetic input because the repair it encodes is
  dangerous in the opposite direction. **`check_dw` ASSERTS
  THE CONSEQUENCES, NOT THE SOURCE**: §1 and §2 re-derive both of `test_batch_cp`'s named
  populations LIVE and require the suite's table to equal them, because a named population is only
  useful while it is still the real one — which is what stopped being true between CN and DW. **It
  also pins `check_da`'s exemption table at ONE from outside**, so a batch adding a second has to
  move a line in another file and say why. **There are 37
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
  - **AND §3's BLIND SPOT IS CLOSED AT DW §1, WITH ONE MORE HOLE THAN DV DIAGNOSED.** Its walk
    sweep read **`check_*.gd` ONLY** and its fingerprint matched the two pool **ACCESSORS** where
    `test_batch_cp._corpus()` reads the **CONSTANTS** — both real. **THE THIRD WAS LARGER AND SAT
    INSIDE THE POPULATION IT ALREADY SWEPT**: the fingerprint assumed a corpus walk touches the
    DRAFT pools at all, and `check_cl_resolver._every_ability()` reads only `Classes.kit()` and
    `Classes.spec_abilities()` and reached **43 of 227**. **THREE WALKS: 43, 91 and 207.** A SECOND
    sweep runs over gates AND suites now, matching constants as well as accessors, and asks whether
    a function **RETURNS** a collection built from two or more ability-source families. **37 → 39,
    one exemption, and the old sweep is untouched.**
- **THE BATTERY WRITES A MANIFEST, `$OUT/.ran`, AND THE DIFFER TRUSTS IT RATHER THAN THE DIRECTORY
  LISTING.** `run_battery.sh` does NOT clear `$OUT` between runs, so a target that failed to launch
  would otherwise be blessed by its PREVIOUS run's log. A name is appended immediately before its
  target is launched and `run_one` truncates the log at spawn, so **a log named in the manifest is
  always this run's**. A subset invocation (`./run_battery.sh bo bp`) writes a short manifest and
  **the differ reports the rest as DID NOT RUN instead of certifying a clean tree.**
- **`gate_fixture.gd` AND `suite_fixture.gd` ARE NOT GATES AND ARE DELIBERATELY NOT NAMED
  `check_*`/`test_*`** — `test_batch_cd` and `check_da` both glob those prefixes.
- **THE BASELINE TABLE IS `baselines.json` AND IT IS 81 ROWS: 46 suites, 30 gates, 2 scene runs
  and 3 harness gates.** **ED ADDED `check_ed` AND MOVED THREE ROWS, ALL THREE PREDICTED AND ALL
  THREE CONFIRMED STANDALONE BEFORE THE BATTERY** — `check_dr` 79 → 80, `test_batch_bm`
  1888 → 1889 and `test_batch_bs` 266 → 267, one locator guard each. **Its own row was written off
  three identical standalone readings of 18**, so `check_de` certified on pass one and reported
  **ZERO NOTICES**. **EB ADDED `check_eb` AND MOVED NOTHING ELSE** — its row was written
  BEFORE the battery off three identical standalone readings of 12, so `check_de` certified on pass
  one instead of reporting an unwatched target, and it reported **ZERO NOTICES**. Before it, **EA
  ADDED `check_ea` AND MOVED EXACTLY ONE OTHER ROW** — `test_batch_ah`, which asserted the OLD
  award behaviour outright and was inverted in place rather than deleted. **DZ ADDED NO ROW AND MOVED NONE — IT WAS THE FIRST BATCH IN THIS
  FILE'S RECORD TO PREDICT A COMPLETELY FLAT TABLE AND GET ONE.** It edits no `.gd` file and no data file,
  and **every assertion against the documents it does edit is a `contains` whose COUNT is fixed**,
  so `CLAUDE.md` can lose 51 KiB without moving a single check count. **DY ADDED NO ROW EITHER AND
  MOVED MANY** — a batch that grows two pools and deletes a third moves every loop that walks one,
  which is what its prediction table is for.
  **THE `flake` FIELD IS GONE FROM THE LAST ROW THAT CARRIED IT** (`test_batch_at`), so the census
  is empty. Before it, **DX ADDED NO ROW AND MOVED EXACTLY ONE FIELD** — `harness_2`'s failure
  band, `[0,1]` → `[0,0]`, with its `flake` field REMOVED because the flake is repaired rather than
  quiet. **A BATCH THAT MOVES A FAILURE BAND DOWN IS THE ONLY KIND THAT SHOULD**, and DE's polarity
  rule is why: a FALLING failure count is a notice, a rising one is an error. DV added `check_dv`
  and moved nothing else; DU added `check_du` and moved `check_cz`. **`check_de` HAS NO ROW OF ITS
  OWN, SO ITS OWN +4 FOR A NEW GATE IS REPORTED BY NOTHING** — **EB adds `check_eb` and moves it
  325 → 329, and EA moved it 321 → 325, for exactly that reason**, and DX added no target so it did not move at all; and the battery's first pass after a new gate necessarily reads one `check_de`
  failure — a target that ran with no row is UNWATCHED, which is that assertion working — so the row
  is added and `check_de` re-run over the same log directory, which is what it is built for. **DR ADDED `check_dr` AND MOVED FIVE ROWS** — `test_batch_bt`, `check_co`,
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
  the FLOOR and the TOTAL, which is exactly what that centralisation is for. **ITS COUNT IS IN `baselines.json` AND IS NOT RESTATED HERE — THIS PROSE HAS BEEN WRONG TWICE**:
  it read 72 from DG until DP corrected it to 85, and 85 was stale again by EA. **A number this
  file restates is a second copy by construction.** It is the hygiene suite: the dead-symbol sweep, the
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
- **master.html stamp: `Last updated: 2026-08-31 (Batch ED)`.** **ED MOVED THE STAMP AND NOTHING
  ELSE IN THAT DOCUMENT — a one-line diff** — because nothing about what the game IS changed; the
  retired-word sweep read **0 *party*** and the same single lower-case `beastmaster` spec id inside a
  `DOD_SIM_SPECS` example **before and after**, and the literal-flip sweep read **0 gained / 0 lost**.
  Before it, **EB MOVED THE STAMP AND NOTHING ELSE IN THAT DOCUMENT** — §1 is a ruling about how to READ a measurement, §2 is comments and §3
  is instruments, so nothing about what the game IS moved. **EA moved the stamp and four prose
  sites; DZ moved the stamp and nothing else.** **The retired-word sweep was still run over it before the battery**, using
  `test_batch_bx` §4b's own `PARTY_IDENTS` strip and §4's `Beastmaster` strip: **0 *party* and 0
  *beast*, in the edited file and at HEAD alike** — and the literal-flip sweep read **0 gained /
  0 lost**, which is what a two-character edit should read.
  - **THE FOURTEEN STAMP GATES COMPARE AGAINST THEIR OWN BATCH CODE, NOT AGAINST THE PREVIOUS
    STAMP, AND THAT IS WHY DY'S RECORDED SORTING DEBT IS NOT ONE.** Each reads
    `substr(_code_at + 7, 2)` and asserts `>=` its own code — every one of them `CE` or older.
    **`EA` and `EZ` both pass all fourteen**, checked in GDScript rather than reasoned about.
    **What would break it is a THREE-letter code**, because the compare reads exactly two
    characters.
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
  **24 entries** (DG → ED). **DV ASSERTED THAT COUNT AS AN EQUALITY AND IT COULD ONLY
  PASS FOR ONE BATCH** — `check_dv` §4 read `live_span == 16` and **DW is the batch it broke on, on
  DW's own changelog entry.** **It asserts a FLOOR** (the cut left 16 and entries are only ever
  added, so an entry VANISHING still fails) **and prints the live figure; the ARCHIVE keeps its
  equality at 149**, because that file only moves when a cut moves it. **DX GENERALISED THAT REPAIR
  INTO A CONSTRUCTION RULE AND SWEPT FOR THE REST OF ITS FAMILY** — see `CLAUDE.md` and the WHERE
  block above. **406.0 KiB crossed CW's 400 threshold at DU exactly as DU predicted.**
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

### Knowledge sync, re-measured at ED
*Measured over `.gd .md .html .json .py .sh`, excluding `assets/`, `.git/` and `.godot/`.
**Treat the file COUNT as method-dependent** — the walks have differed by one before, and the
SIZES are the comparable half. **ALL SIZES BELOW ARE KiB (1024 bytes)**.*
- **168 files, 7.60 MiB** (EC measured 164 / 7.23 by this same walk). **ED added four
  files** — `check_ed.gd`, `build_pin_manifest.py`, `pin-manifest.json` and `docs/reports/ED.md` —
  deleted none, and grew `CLAUDE.md` by **4.17 KiB** with two standing rules, two name repairs and
  one block re-pointed at its instrument.
- Heaviest: `scripts/battle.gd` **1226**, `docs/design-notes.md` **405**, `docs/master.html`
  **338**, `scripts/classes.gd` **322**, **`pin-manifest.json` 296**, `CLAUDE.md` **233**,
  `docs/changelog.html` **212**, `scripts/talents.gd` **179**, `scripts/unit.gd` **177**,
  `docs/talent-audit.html` **165**. **`pin-manifest.json` ARRIVES FIFTH AND `CLAUDE.md` DROPS TO
  SIXTH**; the changelog grows about 8 KiB a batch, so CW's 400 KiB threshold is roughly
  twenty-three batches away.
- **The 47 suite files are unchanged in number and still the single largest block. They cannot be
  archived (they must be in the repo to run) but they CAN be deselected from the sync.** The gates
  are **37** — **ED ADDED `check_ed`, EC ADDED `check_ec`, EB ADDED `check_eb`, EA ADDED
  `check_ea`, AND DZ AND DY EACH ADDED NONE.**
- **`CLAUDE.md` IS 233.08 KiB = 2.994%, DOWN FROM 228.91 KiB = 3.093% AT EC — SO CW's *"under 3%"*
  IS MET FOR THE FIRST TIME SINCE DZ. AND IT WAS MET WITHOUT REMOVING A SINGLE BYTE FROM THE
  FILE.** **THE FILE GREW BY 4.17 KiB AND THE RATIO FELL ANYWAY**, because the DENOMINATOR grew by
  0.37 MiB — **296 KiB of it `pin-manifest.json`**, a derived instrument with nothing to do with
  `CLAUDE.md`. **THIS FILE IS ITSELF INSIDE THAT DENOMINATOR**, so the figure moves by about a
  thousandth of a point as this paragraph is written — measured on the tree that ships.
  - **A TARGET THAT CAN BE MET BY ADDING AN UNRELATED FILE IS NOT MEASURING WHAT IT NAMES.** This is
    the second half of §1's finding and it is stronger than the first: the file has no dead weight
    AND the metric does not track the property anyone cares about. **A batch can satisfy CW's rule by
    committing a large generated artefact**, which is the opposite of what that rule was written for.
  - **ED READ ALL 43 NEVER-CITED BLOCKS AND RETIRED NONE.** 0 dead rules, 0 surviving narrative, 43
    rules that bind future work and are simply obeyed. **The prune is not owed any more; the TARGET
    is.** The measurement, the liveness test and the growth law are in `docs/reports/ED.md` §1.
  - **THE GROWTH LAW, DERIVED FROM GIT ACROSS EIGHTEEN PRUNE-FREE BATCHES (DJ→EC): `CLAUDE.md`
    +4,835 B a batch against a sync +79,726 B a batch — a MARGINAL RATE OF 6.06%**, which is where
    the ratio converges if nothing is ever cut. Post-DZ alone it is **8.70%**. **3% sits below the
    growth law**, so it is reachable only by pruning or by denominator growth, neither of which is a
    statement about density.
  - **TWO OPTIONS REMAIN AND BOTH ARE THE DESIGNER'S**: move the target to the growth law, or split
    the file the way CW split the changelog. **The third — keep 3% and prune periodically — now has
    a measured price: a maintenance batch about every eight passes, and this one found nothing to
    cut.** **`pin-manifest.json` IS THE FIRST CANDIDATE FOR DESELECTION** from the sync if the
    denominator is to mean anything: it is derived, re-derivable in seconds, and nothing is lost by
    regenerating it.
- **`scripts/` contains ZERO test suites.** All game code.

---

## KNOWN-BROKEN AND DELIBERATELY UNFIXED

### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED

**DB measured 72 across 26 suites. DC repaired 23. DF sorted all 47 and repaired the 37 that were
STALE. DG closed the remaining ten.** **THERE WERE FOUR UNSEEDED FLAKES IN THE PROJECT'S HISTORY AND
ALL FOUR ARE NOW REPAIRED RATHER THAN QUIET.** `test_rune_battle`'s pierce was seeded at DF §0 at
the site that flakes; **`bo`'s NULL FIELD flake is seeded and closed at DT**, settling at ZERO over
six readings; **`test_run_harness` gate 2 is seeded and closed at DX §2**, settling at zero over
thirty; and **`test_batch_at`'s §1 ratio is seeded and closed at DY §4**, six seeded readings all
reading 2.1799 against six unseeded ones spanning 2.1189–2.2463. **EVERY ONE OF THE FOUR SETTLED AT
ZERO, SO ALL FOUR WERE FLAKES AND NONE WAS A FINDING** — which is worth stating as a pattern rather
than four times separately: **a band that has held over hundreds of readings is not usually hiding a
defect, and the way to establish that is to seed it, not to widen it.**
**AND NO SWEEP OF THE SOURCE CAN CERTIFY THERE IS NO FIFTH** — twenty suites draw without seeding
and are stable, and `at` itself calls no RNG at all. **`baselines.json`'s `flake` fields are the
census; no row carries one now.**

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
- **AND CHECKS THAT PASS BY ACCIDENT ARE STILL WORSE THAN A RED.** `bs`'s bare `CLAUDE.md` pin was
  the one on record; **EA §2 repaired it and found five siblings**, all of them passing off a
  standing rule that named the batch in passing rather than off the block their message claimed.
  **The three vacuous exclusive-pair siblings in `as`, `at` and `aw` are the remaining live
  instances**, named at their sites and in the open queue above.
- **`test_batch_at` IS SEEDED THROUGHOUT AS OF DY §4** — §1's damage loop was the last unseeded
  compared pair in the file, and every `_seeded()` call in it used to sit DOWNSTREAM of that check.
  Its check count is rock steady at **467** across every reading including both of DR's and all
  three of DY's.
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

**TWO BATTERIES AT EB. THE FIRST TOOK A SUITE RED AND THE SECOND FOUND NOTHING.** The second run:
no suite failure, no throw, no notice, and the only red is the one that is on purpose. **177 files
were MD5-stamped before the acceptance run and re-compared after; EVERY ONE IS BYTE-IDENTICAL.**
`CLAUDE.md`, `docs/master.html`, `docs/changelog.html`, `docs/design-notes.md`, `baselines.json`
and every `.gd` file are unchanged across the run, so the battery certified what ships. **EXACTLY
TWO FILES DIFFER FROM THE CERTIFIED TREE NOW — this one and `docs/reports/EB.md` — and both are
read by nothing**, which was checked rather than recalled: six files NAME `state.md` and all six
mentions are inside comments.

| | DZ's acceptance | EA's acceptance | EB's acceptance |
|---|---|---|---|
| **suite failures** | 0 | 0 | **0** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 321 / 0 / 0 | 325 / 0 / 0 | **329 / 0 / 0** |
| targets in the manifest | 78 | 79 | **80** |

**EIGHTY TARGETS RAN AND THE MANIFEST NAMES ALL EIGHTY. 0 `Parse Error` and 0 `SCRIPT ERROR` in
every log** — grepped from the streams rather than read off a tally or an exit code, and **not one
of the 80 logs contains either marker.** `check_map_screen: OK`; `check_ct_map` 83 / 0; the run
harness reads **22 / 165 / 8**, all three passing.

**AND THE FIRST BATTERY IS THE ONE WORTH KEEPING.** `test_batch_bl` went **88 / 1** on a needle in
`battle.gd` that EB §2 reworded — `THIS BATCH DOES NOT SHIP ONE`, control 1's pin — and
**`check_de` reported it as REDDER, which is exactly the movement that rule exists for.** The
needle is restored word for word, the tree was re-frozen, and the battery was run again. **A batch
that edits behind its own certification run has certified nothing.**

**AND THE BASELINE PREDICTION HELD EXACTLY.** **`check_de` reported ZERO NOTICES**: `check_eb` read
**12**, the one row written BEFORE the run, and **no other row moved.** `check_de` itself went
325 → 329 — four assertions for the one new target — which is the movement nothing reports, because
it has no row of its own. `test_batch_an` read **6054**, inside its recorded [6046, 6063] band, and
the differ said so by saying nothing.

**THE CODE CHANGE IS ONE NEW FILE AND ZERO CODE LINES ANYWHERE ELSE**, proven with a
comment-stripped diff against `git show HEAD` over all twelve edited `.gd` files. `check_eb.gd` is
the new gate at 12 checks; `battle.gd`, `run_state.gd`, `run_sim.gd`, `unit.gd`, `classes.gd`,
`check_da.gd`, `check_de.gd`, `test_batch_au`, `bp`, `bq`, `br` and `cd` are **comments only, zero
code lines in every one.** `run_battery.sh` gains `check_eb` in `GATES`; `baselines.json` gains its
row at `indent=1`, a 14-line insertion with no churn.

**THE NEGATIVE CONTROLS, AND THE FIRST ONE DID NOT BITE — WHICH IS THE ONE WORTH KEEPING.**
0. **THE PARSE CONTROL WAS ARMED ON THE NEW GATE AND READ CLEAN FOR THE WRONG REASON.** A closing
   parenthesis was removed from `check_eb`'s own signature and **`check_parse` reported 0
   `Parse Error` lines**: it walks `res://scripts` and `res://scenes` and **does not cover the
   gates**. **EB §3's own new rule, biting its author.** Re-armed twice — the broken GATE launched
   directly prints `Parse Error: Expected parameter name.` to stderr, **prints no tally line at all
   and still exits 0**, which is what `run_battery.sh`'s `throws=` column exists for; and re-armed
   inside `check_parse`'s real scope on `run_state.gd`'s `draft_pool_left` signature it produced
   **22 `Parse Error` lines**, tally 7.
1. **THE NEEDLE CONTROL, ARMED ON A NEEDLE TAKEN OUT OF THE EXTRACTOR'S OWN DUMP.**
   `PROTECTED CORE is guaranteed and permitted` — `check_do`'s — split across a line wrap, **not
   one character deleted.** The verifier went **RED (1 violation)** and **`check_do` went 131 / 1.**
   Restored **by `cp` from a scratchpad backup, never by `git checkout`**; CLAUDE.md's md5 back to
   `3ab455561729c06a923b999ea8dadb35`.
2. **§1's CONTROL: A REAL SECOND CROSSOVER, INJECTED INTO THE DATA.** The Occultist's Suffering
   moved 25 Mana / cooldown 4 → **15 / cooldown 1** against Hex of Ruin's 20 / cooldown 2 at the
   same initiative. **`check_eb` went 13 / 2**, naming card, core and spec.
3. **§2's CONTROL: THE FILLER MADE REACHABLE.** Rallying Shout added to the SWORDMASTER draft pool.
   **`check_eb` went 12 / 1**, predicting `bp` §7's flake by name. Both restored by `cp`, md5s
   identical.

**THE PRE-BATTERY INSTRUMENTS, ALL RUN BEFORE THE CERTIFICATION RUN.**
- **The needle verifier**, with `or_groups()`'s residual string-masking hole closed — it counted
  brackets and the bare word `or` INSIDE string literals, the second half of the bug EA fixed in
  `statements()`. **73 positive groups, 22 or-alternatives, 30 negatives, 46 locators across 82
  files**, green at HEAD and green after; **the fix moves no number on this tree**, so it is a
  latent hole reported as one rather than a repair with an effect.
- **AND EB §3 RE-MEASURED EA's HOLE: IT NEVER LOST A LITERAL, IT LOST THE BOUNDARY.** With
  string-masking disabled the extractor finds the **same 124 distinct asserted literals** (90
  positive, 34 negative) as the fixed one. **What collapses is the GROUPING — 73 positive groups
  become 45, 30 negative become 25 — and an or-group passes when ANY member is present**, so 28
  independent assertions were satisfied by a sibling's hit. **The count to assert is the GROUP
  count**; a literal census reads 124 either way and cannot see this at all. **EA's 32-reading
  build no longer exists and could not be reproduced**, which is stated rather than worked around.
- **THREE OF THE 46 LOCATORS DO NOT RESOLVE AND ALL THREE ARE ALREADY ON RECORD** — `test_batch_at`'s
  `" — cold_snap"` and `"EXCLUSIVE talent pair ("`, and `test_batch_aw`'s `"no rune may write"`.
  They are the vacuous trio in the open queue above. **The widened extractor found the population
  the record already described and nothing the record did not.**
- **The literal-flip sweep** over the four tracked documents, 10,867 distinct literals at a floor
  of 4: `CLAUDE.md` **7 gained / 0 lost**, `master.html` **1 / 0**, `changelog.html` **6 / 0**,
  `design-notes.md` **7 / 0**. Cross-checked against the tree's **275** negative assertions:
  **0 gained literals are negatively asserted against the document they landed in.** **One gained
  literal was an accident and was reworded** — `BATCH BR` inside the prose *"AND THE BATCH BROKE A
  SUITE"*. Harmless, and a batch-code substring landing in a tracked document is not a thing to
  leave to luck.
- **AND THE SWEEP THE DOCUMENTS CANNOT DO — THE SAME ONE WITH THE EDITED SOURCES AS THE
  DOCUMENTS.** Every literal in the tree at a floor of 4, tested for presence in each edited `.gd`
  file before and after. **Five lost literals, and the first is the one that took `bl` red**:
  `battle.gd`'s `THIS BATCH DOES NOT SHIP ONE`. The other four (`roll_ability_offer` in
  `run_sim.gd`; `PERFECT` / `every hero` / `perfect` in `run_state.gd`) are substring noise with no
  assertion behind them, checked statically and confirmed by a green battery. **`battle.gd` reads
  0 lost after the repair.**
- **The retired-word sweep**, re-implemented from `test_batch_bx` §4 and §4b's own strips (the
  `PARTY_IDENTS` list read OUT of the suite rather than copied): **0 *beast* and 0 *party* across
  13 `.gd` files and `master.html`.**
- **A 39-TARGET SUBSET BATTERY** over every live reader of the four documents plus the edited
  suites and `check_da` / `check_dw` / `check_eb`: **all 39 green, 0 `Parse Error`, 0
  `SCRIPT ERROR`, every count exactly on its baseline.** **AND IT DID NOT CATCH THE `bl` BREAK** —
  `bl` reads no tracked document, so it was not in the subset. **A subset chosen by document
  readership cannot see a source-needle break; the source sweep above is what does.**
- **A COMMENT-STRIPPED DIFF** over all twelve edited `.gd` files against `git show HEAD`: **zero
  code lines changed in any of them.** **And that proof is no longer sufficient on its own** —
  see the WHERE block: it says nothing about whether a suite reads the comment.
