# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

*Last rewritten: 2026-09-01 (Batch EN).*

---

## WHERE THE PROJECT IS

- **Last batch: EN — THE LAST THREE CLAUSES, AND THE RUNG THAT IS A DOOR.** The rune charter is
  **complete at 59 of 59**; the lowest difficulty rung was ruled removed and **was not removed**,
  because it is the only thing that opens a player's first talent row; per-hero relics **never
  landed**; and the sixteen runes the charter empties are split, derived and presented without
  anything being authored. Full working: **`docs/reports/EN.md`**.
- **§1 — THE THREE HOMELESS CLAUSES HAVE RUNE-OWNED FIELDS, AND THE MEASUREMENT IS THE PROOF.**
  `divine_presence_pct`, `entropy_ranks` and `pleasure_pct` write `rune_` fields of their own, and
  each drip's **EXISTING** per-turn tick sums the pair. **There is no second tick** — a hero
  holding the rune AND the node would be paid twice, which is a magnitude moving, and that is the
  one thing a re-key forbids. **This is EM §2's option A, taken smaller than option A described
  itself.**
  - **ALL THREE ARE PAYOUTS AND ALL THREE GUARDS ARE PRESENCE TESTS**, read at their own sites
    rather than taken by analogy from EM's 56. **AL's MAX rule now has ZERO applications across
    all 59** and On the Edge is still the only threshold any rune shares.
  - **DRIVEN LIVE, SEEDED, BEFORE AND AFTER — AND EVERY READING REPRODUCED EXACTLY.** On a hero
    holding the rune and no talents, 24 seeded autoplay battles an arm: Divine Presence **81 fires
    / 255**, Entropy **130 / 694 Break**, Pleasure from Pain **76 / 166**. Not approximately —
    exactly, which is the resolution at which a dropped clause hides.
  - **THE NEGATIVE CONTROL BIT IN THREE DIRECTIONS AT ONCE.** With the read sites taking the
    node's half alone — the exact mistake a re-key makes — all three rune-only arms went to **0**,
    **the node-only arms did not move a single fire**, and the hero holding both lost precisely
    the rune's share of the sum (17.18 → 13.39, 26.48 → 21.37, 12.55 → 10.66). The middle column
    is what makes the outer two mean anything.
- **§2 — THE SIXTEEN ARE DERIVED, SPLIT AND PRESENTED. NOTHING WAS AUTHORED.** The derivation off
  `LANE_TREES` and `runes.json` reproduces EM's sixteen exactly — **but only with
  `check_em.UNIT_MATH` excluded**; without that exemption it returns twenty-six and sweeps in the
  Colossus and the Glass Rune, which touch no tree at all.
  - **THE POOL ARITHMETIC IS FLAT AND THAT IS THE FIRST SURPRISE.** Every spec has **4 spec runes
    and 12 drawable** (4 spec + 3 class-wide + 5 universal). The 5 universal and 12 class-wide
    carry no talent clause, so the retirement is entirely a spec-scoped question. **It cannot
    blank an offer**: an exhausted rarity widens to every rarity and then to the generated Common
    family, and the rare shelf's floor after retirement is **6** against **3 rune slots**.
  - **THE THRESHOLD IS STATED AND IT IS CONTENT, NOT A COUNT:** *a spec is GUTTED when nothing
    surviving — spec, class-wide or universal — touches its own engine.* **A count cannot carry
    the ruling** because no count-based line has a consequence behind it.
  - **EXACTLY ONE SPEC FAILS IT: the BEASTMASTER.** He would keep `loosened_straps` alone, a
    Scarred rune whose only upside is **Quick Shot** — and **no class-wide or universal rune
    touches a companion either**, so after a blanket retirement there would not be one rune in the
    game that touches a companion. **The companion IS the spec.** The line is movable and the
    report shows both alternatives (a 2-survivor line catches the same one; a half-loss line
    catches five).
  - **EXACTLY ONE OF THE SIXTEEN IS SCARRED and it is flagged apart**: the Bared Guard, 75g,
    Swordmaster, whose two clauses ARE the trade — retiring it removes the cost with the upside,
    and would leave him **the only spec in the game with no Scarred rune.**
  - **THE OVERLAP THAT CANNOT BE READ APART:** the Deepening Ruin and the Whispering Dark are both
    Occultist and are the only two runes where §1 and §2 meet. Retiring them retires two of the
    three fields EN authored.
- **§3 — THE RUNG STAYS. THE STOP CLAUSE FIRED AND THE BRIEF'S OWN INSTRUCTION WAS FOLLOWED.**
  `Profile.note_end_boss(Run.difficulty_rung())` sets the talent tier to the rung cleared, and
  **`Talents.TIER_ROWS` is `[0, 3, 6, 9]` — tier 0 opens NO rows at all.** Clearing rung 1 is the
  only thing in the game that opens rows 1–3 of all twelve trees, for every spec at once.
  - **RE-MEASURED WITH BN's OWN INSTRUMENT ON THE LIVE TREE** (`DOD_SIM_ROWS=0`, `--run 30` a
    rung): **untalented completion is 97% / 3% / 0%.** Removing the rung moves a new player's
    first talent row from a one-attempt clear to roughly a thirty-attempt one — worse than the
    13% BN §2 measured at ×0.70 and deliberately fixed by choosing ×0.50.
  - **THE 100% BOT COMPLETION IS A FULLY TALENTED PARTY** (`rows=9 of 9`, CY's own named
    confounder; re-confirmed at 100 / 80 / 80% across the three rungs, n=20). **A fully talented
    party has already been through the door the rung is.**
  - **RELICS WOULD HAVE SURVIVED IT AND TALENTS WOULD NOT.** `Relics.unlock_random()` runs above
    the `is_end` branch, so every boss at every rung awards one. Only the talent ladder reads the
    rung.
  - **EVERY SITE THAT READS A RUNG BY INDEX IS LISTED IN THE REPORT.** The sharp one is
    `draft_screen.gd:147-148`, which advertises each rung's unlock as
    `rows_unlocked(rung - 1) + 1 .. rows_unlocked(rung)` — **`def["rung"]` IS the tier index**, so
    a renumbering breaks the ANNOUNCEMENT rather than the ledger, which is the failure mode that
    ships. `data/enemies.json` carries two `"rung"` tags (2 and 3, both end-boss).
    **No second save-refusal path was invented, because nothing was removed.**
- **§4 — PER-HERO RELICS NEVER LANDED, AND NEITHER DOCUMENT NOR CODE WAS WRONG.**
  `Run.active_relics` is a flat list of up to 3 ids with **no hero key**, and `relic_add` /
  `relic_dict` **both take a hook and nothing else** — party-wide at all 25 read sites, and the
  save format never moved. `master.html`'s *"up to 3 equipped per run at the draft"* was
  **accurate**; what was missing is that a ruling points the other way and is unbuilt, which it now
  says. **The code was NOT moved toward the ruling** because four hooks are still unruled, and
  choosing four designs by implementation is the guess AR §4 forbids.
- **AND `CLAUDE.md` NOW SAYS WHAT A RELIC IS FOR, DERIVED FROM THE READ SITE.** Every one of the
  19 relic hooks is read at exactly one place — run start, battle **spawn**, the victory screen,
  gold awards, rest nodes, shop prices, elite spoils — and **not one is read while a turn is
  resolving**, swept over all 25 sites. The category `relics.gd` declares OUT (on-kill and
  per-turn procs, revive-on-death, enemy auras, DoT and Break multipliers) is exactly the
  in-combat one. **A relic sets up the run; a talent changes what a spec does in a fight; a rune
  is this run's kit.** And a relic is party-wide *by construction* — it is chosen at the draft,
  before specs exist.
- **§5 — TWO ACCEPTANCES RECORDED, AND ONE STALE CAVEAT RETIRED.** Elites stay the shortest fight
  at every rung and that is **accepted by design**. **DA's "no longer holds at rung 3" caveat does
  not reproduce**: re-measured at `--run 30` a rung, elite **3.4 / 3.7 / 4.0** against trash
  3.9 / 4.3 / 4.4 and boss 3.8 / 4.4 / 5.4 — shortest at all three rungs again, by 0.4–0.5 rounds.
  **The tags stay mechanically inert and `check_ek` §3's game-side population stays at THREE.**
- **§6 — ONE GATE SECTION INVERTED RATHER THAN DELETED.** `check_em` §4 said *"the day one is
  answered this gate reds and the answer is to delete its row"*. All three were answered at once,
  and deleting the table would have left the section **looping over nothing and printing exactly
  like a clean run**. It asserts the CLOSURE now and walks EN's three in both directions over a
  live population, printing `CHECKED n of m`. §1's `NO_HOME` exemption arm went with the set.
  - **AND THE GATE'S OWN HEADER CARRIED EJ'S OFF-BY-ONE.** It read *"`crit_bonus`, `speed`,
    `armor` and seven others"* and *"the TEN fields"*; **`UNIT_MATH` holds NINE and `armor` is not
    one of them** — it is the tenth name in EJ's list precisely BECAUSE no live node writes it.
    The table was right and the sentence was wrong. `CLAUDE.md` had it right and is unchanged.
  - **AND A `runes.gd` SENTENCE HAD BEEN STALE SINCE EM.** *"These three are what the four Holy
    runes write today"* — no rune writes `triage_heal`, `divine_presence_pct` or `last_hope_pct`
    any more. All three stay listed (the AW/AX durability rule) and the sentence now says so.
- **THE BATTERY: 87 targets, 41,445 checks, 0 throws, 0 `Parse Error` in any of the 87 logs, and
  `check_de` reads 358 / 0 / 0.** The tree was frozen and the freeze PROVED — 186 files md5'd by
  absolute path before and after, identical, and `.ran` holds 87 names with no duplicate. Three
  baseline rows moved and all three were predicted: `check_em` 210 → **223**, `test_batch_av`
  350 → **351**, `test_batch_ax` 350 → **352**. The two standing reds (`test_rune_battle` 97/1
  against a 0–1 band, `check_cm_live` 13/4) did not move.
- **AND ONE REGRESSION, WHICH IS THE RETIRED-WORD RULE AND THE PRE-CHECK THAT MISSED IT.**
  `test_batch_bx` §4b went red on new `master.html` prose reading **"PARTY-WIDE"** and **"the whole
  party"** — DL §2's rule, where *party* means either *hero* or *ally* and is exactly the word
  Rallying Shout's clause hid behind. **The pre-check ran ten document-reading GATES and all ten
  were green; §4b lives in a SUITE.** The rule is not *pre-check the gates* — it is **pre-check
  every target that reads the document you edited**, which for `master.html` is **25 targets, six
  gates and nineteen suites.** Repaired to the project's vocabulary with no claim changed; a needle
  sweep against the exact file the battery read flipped **1 LOST / 0 GAINED** (and that needle is
  comment-only), **and the sweep is not the proof** — §4b tests `contains("party")` after stripping
  five marked identifiers, which `master.html` legitimately still carries, so the needle never
  flips. All 25 targets were re-run: bx reads **161 / 0**, its exact baseline, and `check_de` was
  re-run over the updated logs at 358 / 0 / 0.
- **Next letter: EO.** The stamp compare reads exactly TWO characters, so a THREE-letter code is
  what breaks it — still a long way off.
- **Phase.** The ability draft is **COMPLETE at 154 of 154**, all twelve talent trees are
  purpose-authored and charter-clean, the archetype tags have their real names and are still inert,
  and **the rune layer is charter-clean on the mechanics at 59 of 59.** What is left in the rune
  layer is design: sixteen runes, and whether the lane rule is replaced with anything.

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION

### THE ARCHETYPE TAGS — NAMED AT EL, STILL INERT, AND EVERY DESIGN QUESTION IN THEM IS OPEN

**Full evidence: `docs/reports/EK.md` (the derivation) and `docs/reports/EL.md` (the names and the
seventh).** The vocabulary is `DEBUFF · DEFENSE · BREAK · RESOURCE · OFFENSE · TEMPO · MARK`, it is
on every ability in the corpus and every authored rune, the draft card shows it, and **nothing
reads it.** `check_ek` and `check_el` assert that every battery run.

- **WHETHER THE SET IS RIGHT IS STILL THE WHOLE QUESTION AND IT IS STILL THE DESIGNER'S.** The
  alternative — six STATUS names — is measured rather than described: **40 of 154 covered, 114
  under no tag, and six of the sixteen pools reading a single value.** The seven shipped cover 154
  of 154 at **4–10 combinations a pool**. **EL proved the rename is cheap**: 292 rows, two files
  and a `sed`, because no reader outside the tables names a tag word. **Changing the set after the
  runes are re-keyed is the rune layer, and that is still true.**
- **TWO WORDS SHIP COLLIDING AND EITHER CAN BE OVERTURNED FOR ONE ROW.** **MARK** meets Hunter's
  Mark, Quarry's Mark, Mark of the Hunt and the `party_mark` chip; **DEFENSE** meets the Defense
  Potion. Both were shipped on the rule that **a same-meaning collision ships and is named**.
  **BRAND, PREY, TETHER, BOUNTY and TARGET are all swept clean** and would carry MARK's ten cards
  without one. The cost is one row of `TAG_ORDER`, one of `TAG_INFO`, and a `sed` over two tables.
- **SEVEN IS RECORDED AS THE CEILING AND AN EIGHTH NEEDS AN ARGUMENT.** The measurement is in
  `Classes.TAG_ORDER`'s header and in the WHERE block above: 42% of the draft is already the only
  card in its pool with its combination, and one pool of sixteen is fully unique.
- **57 PRIMARIES WERE A JUDGEMENT AT EK AND EIGHT MORE MOVED AT EL.** EK's 57 are listed in its
  report with the alternative beside each; **nine were flagged as genuinely arguable** — the stance
  cards, the companion cards, the marks, Anointing, Immolate, Emberkeep, Divine Presence, Fault
  Line and the three consume-cards. **EL's eight are the marks, and they are no longer arguable:
  each had been tagged for what its mark PAYS.** **Two remain arguable and are named**: Snare Line
  (MARK second because it marks the FIELD) and Feint (MARK second because it marks on one branch).
- **PET AND STANCE ARE THE TWO CANDIDATES LEFT, AND SEVEN IS THE STATED CEILING.** **PET** would
  carry the Beastmaster's whole **10-card pool** plus his three summons and Kill Command;
  **STANCE** would carry 3. Both are cards tagged today for what their payoff does rather than for
  what they are — **which is exactly the argument that MARK won on**, so the ceiling is what stands
  between them and a row, not the strength of the reading.
- **THE HERO SHEET IS RECOMMENDED AND NOT TAKEN.** It is the cheapest of the four remaining
  surfaces and the only screen where a player reads a whole loadout at once. **The rune offer wants
  its own surface** rather than `map_screen._pick_button`, which CK deliberately keeps on the
  mid-combat tier. **The battle tooltip and the blacksmith are recommended AGAINST.**
- **THE WORD "ARCHETYPE" STILL NAMES TWO UNRELATED THINGS AND ONLY THE CODE SIDE IS SEPARATED.**
  `ARCHETYPE_ROLE` / `ARCHETYPE_DESC` and `master.html` §6 use it for a SPEC's role, which decides
  base Attack. The constants are `CARD_TAGS` and `RUNE_TAGS` deliberately, and `master.html` §6c
  states the two are unrelated — **but the document still uses one word for both.** Renaming the
  nine spec archetypes is a design decision with a stat table under it.
- **WHAT THE TAGGING STILL HAS NOT REACHED, STATED SO IT IS NOT READ AS CLEAN.** No sim and no
  balance judgement; not one magnitude was measured. **The tags were not compared against relics,
  items, enemy abilities or events**, none of which carries one. **AND NO RUNE IS KEYED TO A TAG.**
  EM took the rune charter's MECHANICAL half — 56 clauses off the talent counters and onto fields of
  their own — and deliberately keyed nothing to a tag, because the differential mechanism (a rune
  worth more to a hero pointed the same way) is the design half and waits for a real draft screen.
  **`check_ek` §3's game-side population is still THREE.**
- **AND TWO CLOSED AUDIT REPORTS STILL SAY `Tempo`.** `docs/talent-audit.html` and
  `docs/rune-audit.html` were deliberately not edited: both are CLOSED (CV / DN) and kept *"as
  written — it is the evidence of which way each disagreement pointed"*. **A reader searching
  either file for the Sharpshooter's lanes finds the old name.** A header note on each is one line
  and is the designer's call.

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
### THE RUNE CHARTER — MECHANICS TAKEN AT EM, EVERY DESIGN QUESTION IN IT STILL OPEN

**Full evidence: `docs/rune-audit.html` (EJ's audit of all 65 runes and all 135 clauses, generated
from the data), `docs/reports/EJ.md` (the sizing) and `docs/reports/EM.md` (what was done).**
**The charter is the designer's:** *runes are disconnected from talents; they are run-specific items
only, and their purpose is to modify stats and resources, and the mechanics and values of core
abilities, draft abilities and passives.*

**THE MECHANICAL HALF IS DONE AND `check_em` HOLDS IT.** 56 of the 59 clauses were re-keyed onto
rune-owned fields; the property *no rune writes a live talent node's counter* is asserted every
battery, derived from `LANE_TREES` and `runes.json` rather than from a list. **`master.html`,
`design-notes.md` and `CLAUDE.md` all say so now.** What follows is what is NOT done.

- **THE THREE CLAUSES WITH NO HOME ARE ANSWERED AT EN AND THIS QUESTION IS CLOSED.** EM priced
  four options and authored none; **EN took option A** — `divine_presence_pct`, `entropy_ranks` and
  `pleasure_pct` each have a `rune_` field of their own and each drip's EXISTING tick sums the
  pair. **No second tick, because a hero holding both would be paid twice.** All three are payouts
  with presence tests, read at their own sites; **AL's MAX rule has zero applications across all
  59.** Driven live and seeded, before and after: **every reading reproduced exactly**, and the
  control taking the node's half alone took all three to zero. `check_em` §4 asserts the CLOSURE
  now, in both directions, over a live population of three. **Nothing else in the rune layer is
  mechanically outstanding.**
- **THE SIXTEEN THE CHARTER EMPTIES. DERIVED AND SPLIT AT EN, PRESENTED, AND STILL UNRULED —
  NOTHING WAS AUTHORED.** EN re-derived the sixteen off `LANE_TREES` and `runes.json` (they
  reproduce exactly, **but only with `check_em.UNIT_MATH` excluded** — without it the derivation
  returns twenty-six and sweeps in two universal runes that touch no tree). **Every spec has 4 spec
  runes and 12 drawable, and a retirement cannot blank an offer** — an exhausted rarity widens and
  then falls back to the generated Common family, with a rare-shelf floor of 6 against 3 slots.
  **EN's threshold, stated so it can be moved: a spec is GUTTED when nothing surviving touches its
  own engine.** By that line **only the Beastmaster** is gutted — he would keep one Scarred rune
  whose upside is Quick Shot, and **no class-wide or universal rune touches a companion either**,
  so no rune in the game would. `docs/reports/EN.md` §2 carries the re-author axis for those three,
  what each of the other thirteen loses, and the Bared Guard flagged apart. **The full list of the
  sixteen with their clauses is still `docs/reports/EM.md` §3.** Every clause these sixteen own
  was talent-keyed, so after the re-key they are mechanically whole and have lost the argument for
  existing: each was *your lane, but more*. **`docs/reports/EM.md` §3 lists all sixteen by name with
  what each does, its price, its lane and its clauses.** **Exactly one is Scarred — the Rune of the
  Bared Guard (75g), whose two clauses ARE the trade** — so retiring it removes both halves at once,
  and it is the only one of the sixteen where that is true.
  - **THE DISTRIBUTION IS UNEVEN AND IT MATTERS TO THE RULING.** All 59 clauses sat in the 48 spec
    runes; the 5 universal and 12 class-wide carried none. **The Warden is 0-of-7 and the
    Beastmaster 8-of-9** — three of the Beastmaster's four runes are in the sixteen, against none of
    the Warden's. A retirement pass would hit one spec's pool five times harder than another's.
- **WHAT SEVERING THE LANE RULE DELETES, RECORDED BECAUSE IT WAS MEASURED.** 36 lane runes and 12
  splashes — **48 of the 65** — were authored to *"one rune per talent lane, plus one splash"*, whose
  point was that a rune is *"worth more to a hero whose points went elsewhere."* **A rune with its
  own field is worth the same to every hero of its spec**, which is the power increment the rule
  existed to prevent. **The splashes lose most**: with no lanes to reach across, a splash is three
  unrelated numbers in a bundle. **The 36 `lane` fields are still authored and still shown** and now
  describe where a rune came from rather than what it reaches. **Whether anything replaces the
  variance mechanism is the open design question**, and the archetype tags are the candidate.
- **THREE RUNE-ONLY EFFECTS STILL ANNOUNCE THEMSELVES AS TALENTS** — `beacon_ranks`,
  `capacitor_ranks`, `mindfulness_ranks`, none of which has a node of that name in any tree — **and
  three more share a label with a node the holder may not own** (Grudge, Shared Vigil, On the Edge).
  The *"→ Rune:"* convention already exists. **Reported at EJ §2b, not fixed; player-facing text,
  and the charter makes it worse rather than better.**
- **`pyromaniac_ranks` IS STILL THE ONE CLAUSE THAT PAYS NOTHING.** The White Flame writes it and
  nothing reads it — Inferno Master's per-turn step stopped existing at AR. `unit.gd` flags it and
  AR §4 forbids inventing a read site. **A 120g scarred Epic with two live clauses of three.** It
  was NOT in the 59 (nothing reads it, so no node counter is involved) and EM did not touch it.
- **WHAT IS STILL NOT MEASURED, STATED SO THIS IS NOT READ AS CLEAN.** No sim and no balance
  judgement; **not one magnitude was measured in play, before or after.** Runes were not compared
  against each other, nor against relics, items or enemy abilities. Rune PRICING was not opened —
  and it is now a live question, because a rune whose value no longer depends on the holder's build
  is a different object to price. The 12 `lane` fields on the splash runes were never audited for
  accuracy.
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
- **AND EG §1/§2 MOVED THE ARITHMETIC UNDER ALL OF IT — THE ONE LIVE RULING THIS BATCH LEAVES.**
  EA's guarantee rested on a hero holding at most `cap − core_slots` earned cards against pools of
  ten to thirteen: a floor of SIX. **Both terms moved.** The cap is a ladder to ten, so the LOADOUT
  bound alone takes the floor to **3 for seven specs and 2 for the Occultist** — measured, and
  `check_ea` §1 went RED on it. **And the POOL is unbounded**, because a benched card is kept and
  `owned_ability_names` reads the pool, so the true worst case floors at **zero**.
  - **THE ASSERTION WAS SPLIT RATHER THAN LOOSENED, WHICH IS DC's REPAIR-TO-INTENT RULE.** EA's one
    check was asking two questions: the RULE is *an award always pays* (`floor >= 1`, still green on
    all twelve) and `>= awards` is the stricter *every award offers a full three*. At a flat cap of
    seven the floor was six everywhere and both held. **`check_ea` §1 asserts the first per spec and
    pins the specs that can fill SHORT as a NAMED SET (`[occultist]`)**, so a thirteenth trips and
    the Occultist leaving trips too. **The POOL bound is PRINTED, not asserted.**
  - **THE OPTION EA PRICED IS A CLASS-WIDE THIRD TIER, AND EH §1 TOOK IT.** EG did not, and the
    sim read `nothing left to offer` at **0.00 per run in both samples** — reachable in principle
    and not reached in fifty runs. **The chain is boss pool → spec draft pool → class-wide draft
    pool now, the loadout-bound floor runs 8–13 across the twelve, and EA's second tier is
    byte-unchanged.** **What EH did NOT take from EA's pricing is the word "completely"**: EA
    recorded a class-wide card as closing the table, and it does so only under the LOADOUT bound.
    See the WHERE block at the top of this file.
- **THE FALLBACK IS BUILT AT EA §1, WIDENED TO THREE TIERS AT EH §1, AND THIS WHOLE BLOCK IS NOW
  HISTORY WITH ONE LIVE HALF.** **NO ZONE-BOSS AWARD CAN PAY NOTHING UNDER A FULLY-HELD LOADOUT** —
  an exhausted boss pool falls back to the hero's own spec DRAFT pool and then to his CLASS-WIDE
  draft pool, three offered and announced like any other award. **What is still
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
      **0**, 14 lost awards → **0**. **THE FLOORS QUOTED HERE (SIX AND TWO) WERE DERIVED AT A FLAT
      CAP OF SEVEN AND AGAINST A LOADOUT THAT WAS ALSO THE POOL. EG BROKE BOTH TERMS** — see the
      live block above; they are kept as EA's working, not as current figures.
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

- **`master.html` SAYS GUARD CHANGE IS "the only stance swap in the game" AND BP CORRECTED THAT IN
  THE CODE.** `PROTECTED_CORES`'s own `why` has read *the only UNCONDITIONAL stance swap* since BP —
  Precision Strike and Feint both switch — and the document's protected-core table was never swept.
  **One string, in a table two lines from what EG rewrote, and reported rather than fixed**: the
  standing rule is that master.html is corrected TOWARD the code, so this is a correction the
  designer should see rather than one a batch makes in passing.

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

- **~~WHETHER THE ZONE-BOSS FALLBACK NEEDS A THIRD TIER~~ — RAISED BY EG, RULED AND BUILT AT
  EH §1.** Closed. The chain is boss pool → spec draft pool → class-wide draft pool; the
  loadout-bound floor runs 8–13 where it ran 2–6. **What is NOT closed, and is stated here so
  nobody reads this line as a guarantee: under a fully-held POOL the chain still floors at zero**,
  and that is a design decision nobody has taken rather than an oversight. Full working in
  `docs/reports/EH.md` §1.
- **WHAT COVERS THE 915 SOURCE PINS — REPORTED AT EC §2, RULED ON NOWHERE.** Every document
  instrument watches the four tracked documents; **915 assertions across 52 suites pin a literal
  into a `.gd` file instead**, and **37 of them resolve only inside a COMMENT**, which is the
  haystack EB reworded with four instruments green. Three options with their costs are in
  `docs/reports/EC.md` §2: **extend the sweep to the edited sources** (it exists, it takes seconds,
  it fires only on files a batch edits and cannot tell a needle from prose); **a manifest of pinned
  literals** (a second place for the truth to rot); or **a rule forbidding source pins** (costs
  nothing to run, **invalidates all 915**, and is a rewrite rather than a rule). **The decision is
  the designer's, and the general shape is already in `CLAUDE.md` either way.**
- **WHETHER 3% IS THE RIGHT TARGET — CLOSED. THE TARGET IS RETIRED (EE §1) AND THE SPLIT IS TAKEN
  (EF §2), WHICH WAS THE FOURTH OF EC §3's FOUR OPTIONS.** This bullet is kept only because the
  arithmetic behind the other three is still in `docs/reports/EC.md` §3 and a later batch reading
  that page needs to know which one was taken. **The live ceiling, the live sizes and the per-half
  growth rates are in the WHERE block and the knowledge-sync section; do not re-derive the ratio.**
- **WHAT A CEILING SHOULD BE FOR EACH HALF — MEASURED AT EF §2, RULED ON NOWHERE.** EE's 290 KiB
  was derived for one file and its FLOOR term held both halves, so **290 is now conservative for
  `CLAUDE.md` alone.** Per-half by EE's own method: **`CLAUDE.md` 220 KiB, `docs/instrument-rules.md`
  95 KiB**, and **the two sum to 315 rather than 290** because each half carries its own
  ten-worst-batch headroom. **Taking those numbers is the designer's; the 290 stands until then.**

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
  one hero at pickup); CX reported the scope and stopped. **VERIFIED AT EN: NOT ONE LINE OF IT
  LANDED**, and neither `master.html` nor the code was wrong about the other — they agree, and what
  was missing is that the ruling points elsewhere and is unbuilt, which `master.html` now says.
  **It is a SAVE-FORMAT change: the run save would go v12 → v13** (this block recorded v10 → v11,
  written when the save was v10; CT took it to v11 and EG to v12).** `Run.active_relics` is a flat `Array` read back as a hard key
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
  not been authored. **AND THE CHARTER DECISION COMES FIRST — see the RUNE AUDIT block below.**
- **The enemy debuffs whose duration exceeds their own cooldown.** Reported by the fold census.
- **The design review.**
- **Browser playtesting with friends.**

### Carried from the code, reported and deliberately not fixed

- **`test_batch_bk`'s BASELINE ROW WAS WIDENED AT EJ, 129-130 -> 128-130, WHICH IS WHAT ITS OWN
  NOTE SAID TO DO.** EJ's battery read **128 checks / 0 failures** there. **It is not a regression
  and it is proved twice rather than argued:** EJ changed four files, all under `docs/`, and that
  suite reads seven `res://` paths all under `scripts/` and `scenes/` — **the intersection is
  EMPTY**; and **the count is stochastic by construction**, because `run._generate_map()` is
  **never seeded anywhere in the tree** and the assertions loop over the nodes the roll produced.
  **A FALL there is a thinner map, not a lost assertion** — which is why the failure count is the
  half that matters and it read 0. Two standalone re-runs on the frozen tree read 129.
  **`baselines.json` HAS EXACTLY ONE READER IN CODE** — `check_de.gd`, proved comment-stripped;
  `check_dp`, `check_parse`, `test_batch_cd` and `run_battery.sh` name it only in comments — **so
  `check_de` alone re-certifies it**, and it read 346 / 0 / 0 after the widening.
- **SEVEN TARGETS STILL CANNOT REPORT A CHECK COUNT, AND IT IS A RATCHET RATHER THAN A SENTENCE.**
  `check_flow`, `check_map`, `check_cl_resolver`, `check_cl_width`, `check_cm`, `check_cn` and
  `check_map_screen` read `checks=?`. **`check_parse` LEFT THE SET AT EI**, and its number is its
  COVERAGE rather than an assertion tally — pinned at 158 with the floor asserted, because a
  failure total reads zero whether that gate walks 158 files or 41. **Two of them — `check_cl_width` and
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
- **Ability slots are a LADDER: `ABILITY_SLOTS_BY_BOSS` = [7, 8, 9, 10]**, one rung per zone boss
  cleared, read through `Run.ability_slot_cap()` and never off a constant. Twelve protected cores,
  unchanged. **`core_slots` AND `protected_names().size()` DISAGREE ON ALL TWELVE SPECS AND THAT IS
  BY CONSTRUCTION** — one is a SLOT count and the other a NAME count. `core_slots` is 3 for eleven
  and 4 for Holy; `protected_names` returns 4 for ten, **5 for Holy and 6 for the Beastmaster**
  (three summons are one bar entry). **The cap has always used `core_slots` and still does.**
  Draftable goes 4 → 7 for eleven specs and **3 → 6 for Holy**.
- **The pouch: 4 → 5 → 6 slots by zone** (`ITEM_SLOTS_BY_ZONE`), a slot holding one item TYPE and
  its whole stack. **Default per-type stack cap `ITEM_CAP` = 6**, with three exceptions
  (`ITEM_STACK_CAPS`): Cleansing Draught **4**, Cursed Visage **2**, Resonating Hourglass **2**.
  Sale returns `SELL_FRACTION` = **0.4** of listed price.
- **The skill check's default profile** — `battle.SC_PROFILE_DEFAULT`: `perfect_half` **0.045**,
  `good_half` **0.16**, `centre` **0.5**, `sweep_time` **0.72**, `presses` **1**, `press_taper`
  **1.0**. **Every caller uses it except the Sharpshooter's basic attack.**
- **Save versions: the run save is v12** (a pre-**v10** save is REFUSED and cleared — the version
  and the threshold are different numbers and this file conflated them until EG, recording v10 while
  CT had taken it to v11). **v11 (CT) and v12 (EG) are both TOLERANT and neither moved the
  threshold.** **`Profile` is
  v2** (tolerant load). Talent cells cost 1/2/3 by tier — **27 cells = 54 points a spec.**
  **`Talents.LANES` = 3**, so the twelve trees hold **36 lanes**.
- **Relics: 25 in the pool** — 17 common, 8 rare. **Up to 3 are assigned per run**, party-wide —
  **confirmed at EN as the code's behaviour, not just this file's memory of it.** The per-hero
  ruling stands and is unbuilt. **`CLAUDE.md` now carries the division of labour:** every relic
  hook is read at run start, battle SPAWN, the victory screen, gold awards, rest nodes, shop prices
  or elite spoils — **not one while a turn resolves** — so a relic sets up the RUN and a talent
  changes what a SPEC does in a fight.

### THE TEST TREE, AS OF EF

- **47 `test_*.gd` files**: 44 `test_batch_*` spanning `ah` to `cp` (with gaps — they are NOT one
  per batch), plus `test_run_harness`, `test_runes` and `test_rune_battle`. **They live at the repo
  ROOT, not in `scripts/`.**
- **`_spawn` IS AUTHORED ONCE, IN `suite_fixture.gd`, AND 37 SUITES GO THROUGH IT.** `_kill` too, in
  14. Each suite keeps its OWN `_spawn` SIGNATURE and delegates, so **all 389 call sites are
  untouched.**
- **`run_battery.sh` RUNS 46 SUITES AND MISSES NONE.** The `GATES` array is **thirty-five** —
  **EM ADDED `check_em` BECAUSE EJ §5 NAMED THIS BATCH AS ITS HOME**: *the property a future gate
  wants — that no rune writes a live node's counter — belongs in the batch that takes the charter.*
  §1 derives that property from `LANE_TREES` and `runes.json` rather than from a list of names, and
  its nine unit-math exemptions are an EQUALITY. **§2 is the one that earns the gate**: splitting a
  counter is safe in the arithmetic and lethal in the GUARD, so it sweeps STATEMENTS and fails if
  any statement reads one half without the other. §3 holds the AA type trap on the `rune_` side; §4
  pins the three clauses with no home as an EQUALITY. **Five negative controls, all five bit.**
  **EL ADDED `check_el` BECAUSE THAT BATCH CARRIES THREE RULINGS**: that MARK's population is
  DERIVED from the marks the game itself names rather than listed, that `master.html` §6c's tag
  table is the code's table, and that the widest tag line is MEASURED rather than transcribed
  (DJ §3). **The first is the one that decays silently** — the day an eleventh mark is authored,
  nothing else in the tree would notice its card going untagged — so §1 pins the STATUS half from
  outside (`DISPEL_NEVER.size()`, DW's idiom) and DERIVES the CARD half live out of
  `battle.gd`'s apply sites, through both anchors, agreeing in both directions.
  **EK ADDED `check_ek` BECAUSE THAT BATCH CARRIED TWO RULINGS**: that the vocabulary is
  MECHANICS rather than status names, and that the tags are MECHANICALLY INERT. **Inertness
  is the one property nothing else in the tree would notice losing**, so §3 asserts it as a
  POPULATION — every `.gd` swept comment-stripped, and **EL SPLIT THAT ASSERTION IN TWO** because
  it was two claims: the files in the SHIPPED GAME naming a tag are pinned at THREE (and did not
  move), the TARGETS that check one are listed separately (two → three), and ZERO is still
  asserted separately in the six files a mechanic would have to live in.
  **EH ADDED `check_eh` BECAUSE §1 IS A RULING AND BECAUSE THE THIRD TIER CAN ONLY BE PROVED
  LIVE.** A tier that resolves correctly and announces nothing passes every static check in the
  tree, and silence is the exact defect EA existed to end. **EG ADDED `check_eg` BECAUSE §1 AND §2
  ARE BOTH RULINGS, AND BECAUSE §1 IS THE ONLY THING IN THE PROJECT THAT DRIVES THE THIRD
  ZONE-BOSS GRANT.** A slot ladder that never grants would pass every static check in the tree,
  which is DS's Heads Down arriving at a new mechanic.
  **EF AND EE EACH ADDED NONE, ED ADDED `check_ed`**, and before it EC added `check_ec`, EB `check_eb`, EA `check_ea`, DW
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
  move a line in another file and say why. **There are 41
  `check_*.gd` files**, so **seven are not in `GATES`** — `check_ck_width`,
  `check_cu`, `check_cv`, `check_dn`, `check_ct_map`, `check_map_screen` and `check_de`. **`check_ct_map` and
  `check_map_screen` run in the SCENE RUNS section and `check_de` runs in its own post-pass section
  AFTER them**, so the four that run nowhere are `check_ck_width`, `check_cu`, `check_cv` and `check_dn`.
  **SINCE EI THOSE FOUR ARE PARSE-COVERED AND NAMED IN `check_parse`'s OUTPUT EVERY RUN** as its
  RESIDUE — in the tree, spawned by nothing, reached by nothing. They are still not in `GATES`,
  because what a failure in an audit REPORT means is a ruling rather than a detail.
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
- **THE BASELINE TABLE IS `baselines.json` AND IT IS 86 ROWS: 46 suites, 35 gates, 2 scene runs
  and 3 harness gates.** **EM ADDED `check_em` AT [210, 210]; EN MOVED IT TO [223, 223] AND MOVED `av` AND `ax` BY ONE AND TWO. EM MOVED FIVE OTHER ROWS —
  `check_dp` 43 → 48, `check_parse` 160 → 161, `test_batch_ak` 495 → 496, `test_batch_ax`
  348 → 350 and `test_runes` 3121 → 3125 — ALL SIX WRITTEN BEFORE THE BATTERY**, three of them
  off three identical standalone readings apiece. **`check_parse` read 163 first**, and the extra
  two were scratch measurement probes sitting in the repo root that its RESIDUE walk found — the
  walk working, and they were moved out of the tree. Before it, **EL ADDED `check_el` AT [23, 23]
  AND MOVED EXACTLY TWO OTHER ROWS —
  `check_ek`, 39 → 43, and `check_parse`, 159 → 160 — ALL THREE WRITTEN BEFORE THE BATTERY OFF
  STANDALONE READINGS**, so `check_de` certified on pass one. **`check_ek`'s move is itemised in
  its own row**: §3 splits one assertion into two, §4 adds two population assertions and one more
  tag to sweep. Before it, **EK ADDED `check_ek` AT [39, 39] AND MOVED EXACTLY ONE OTHER ROW —
  `check_parse`, 158 → 159**. **The `check_parse` move is that row working
  as designed rather than drifting**: its count IS its coverage, so a target joining the battery
  raises it the same day. **EI ADDED NO ROW AND MOVED EXACTLY ONE — `check_parse`, `checks: null`
  → `[158, 158]`** — written before the battery off three identical standalone readings, so
  `check_de` certified on pass one. **THAT ROW IS A DIFFERENT KIND OF NUMBER FROM EVERY OTHER ONE
  IN THE TABLE: it is a COVERAGE count, not an assertion tally**, and it is pinned for the reason
  the batch exists — a failure total reads zero whether that gate walks 158 files or 41, which is
  how it was found short three times with nothing going red.
  **EH ADDED `check_eh` AND MOVED EXACTLY ONE OTHER ROW — `check_ea`
  62 → 86 — BOTH WRITTEN BEFORE THE BATTERY OFF THREE IDENTICAL STANDALONE READINGS**, so
  `check_de` certifies on pass one. **EG ADDED `check_eg` AND MOVED FOUR ROWS, ALL FIVE WRITTEN BEFORE THE
  BATTERY OFF STANDALONE READINGS** — `test_batch_bo` 1131 → 1140, `test_batch_bx` 157 → 161,
  `check_ea` 60 → 62, `test_batch_bp` 275 → 276, and its own row off THREE identical readings of 68,
  so `check_de` certified on pass one. **THE `bo` DELTA WAS COUNTED OFF THE DIFF RATHER THAN
  GUESSED** — +20 `ok(` against −11, every one linear. **EF ADDED NO ROW AND MOVED EXACTLY ONE — `check_ec` 22 → 23, the fifth
  tracked document, written off three identical standalone readings BEFORE the battery so
  `check_de` certified on pass one.** **ED ADDED `check_ed` AND MOVED THREE ROWS, ALL THREE PREDICTED AND ALL
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
- **Run harness gate counts: 22 / 166 / 8** — EE's locator guard moved gate 2 from 165.
- **master.html stamp: `Last updated: 2026-09-01 (Batch EL — the tags get their real names, and
  MARK is the seventh)`.** **EL MOVED THE STAMP AND EDITED SEVEN SITES IN THAT DOCUMENT**: §6c's
  tag table (all seven rows rewritten and a new paragraph on MARK and the ceiling), §7's
  Sharpshooter lane header and the lanes line (`Tempo` → `Pace`), the three node rows (`Tempo` →
  `Pivot`, `Shattered Tempo` → `Shockwave`, `Crusader's Tempo` → `Crusade`), and **Blink's *"Tempo,
  not damage"* → *"Timing, not damage"***, which is the ordinary English word colliding with a tag
  rather than a mechanic naming itself.
  - **§6c IS ASSERTED NOW AND IT WAS NOT BEFORE.** `check_el` §2 parses the tag table and requires
    its words, their order and their meanings to be `TAG_ORDER` and `TAG_INFO` word for word, and
    the five retired words to be absent from the section. **EH proved with a two-armed control that
    this document's factual prose is asserted by nothing** — that is one table's worth of it closed.
  - **THE LITERAL-FLIP SWEEP READ 18 LOST AND EVERY ONE WAS TRACED.** 11,010 gate-and-suite string
    literals against thirteen tracked documents: **17 of the 18 are in `docs/state.md`, which
    NOTHING READS** — six `.gd` files name that path and all six mentions are comments — and the
    eighteenth is `spec_draft` leaving a `baselines.json` **`note` field**, which only `check_de`
    opens and only as parsed JSON fields, never as prose. **0 LOST in `master.html`,
    `text-standard.html`, `CLAUDE.md`, the glossary or the changelog.** `bx` reads 161 / 0.
  **Before it, EI, EF and EE each moved the stamp and nothing else in that document; EG moved it
  and three prose blocks** — the draft column's cap and ledger bullets, the seven-slot-cap
  paragraph and the take-one-and-bench-one paragraph. **EA moved the stamp and four prose sites; DZ
  moved the stamp and nothing else.**
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
  columns are the stale ones.**
  - **RE-MEASURED AT EN, `--run 30` A RUNG ON THE LIVE TREE, AND THE ROUNDS TABLE ABOVE IS
    SUPERSEDED BY THIS ONE:**

    | party / rung | trash | elite | boss |
    |---|---|---|---|
    | 1 wanderer | 3.9 (n=206) | **3.4** (n=256) | 3.8 (n=60) |
    | 2 warden | 4.3 (n=240) | **3.7** (n=246) | 4.4 (n=57) |
    | 3 ruin | 4.4 (n=235) | **4.0** (n=225) | 5.4 (n=55) |

  - **DA's "NO LONGER HOLDS AT RUNG 3" CAVEAT IS RETIRED — IT DOES NOT REPRODUCE.** DA read all
    three kinds at 4.4; on the live tree the elite is **shortest at all three rungs again**, by
    0.4–0.5 rounds. **And the finding is now ACCEPTED rather than open** (EN §5): elites are burst
    checks by design and a ramp spec having least room where difficulty spikes is the intended
    tension. It is recorded in `CLAUDE.md` beside CY's cap so it is not rediscovered a third time.
    **The confounders are CY's, unchanged**: fully talented (`rows=9 of 9`), each tree's first
    lane, companions excluded from both halves.
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
  **34 entries** (DG → EN), read off `check_dv` §4 rather than counted by hand. **THIS LINE WAS STALE AT EE, WHICH READ 24 WITH THE FILE AT 25** —
  `check_dv` §4 prints the live figure every battery and is the thing to read. **DV ASSERTED THAT COUNT AS AN EQUALITY AND IT COULD ONLY
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

### Knowledge sync, re-measured at EG
*Measured over `.gd .md .html .json .py .sh`, excluding `assets/`, `.git/` and `.godot/`.
**THE SET IS STATED RATHER THAN DESCRIBED**: it is every tracked file outside `assets/` with one of
those six extensions. **IT IS THE CENSUS SCRIPT'S DEFINITION NOW, NOT A DESCRIPTION** —
`claude_md_census.py` prints the file count and the byte total for any commit, so these figures are
re-derivable rather than recorded. **ALL SIZES BELOW ARE KiB (1024 bytes)**, and all are measured on
the CERTIFIED tree — before this file and `docs/reports/EF.md` were written, because both are inside
the number.*
- **181 files, 8.1401 MiB, MEASURED ON THE TREE AS IT SHIPS** — this file and
  `docs/reports/EK.md` INCLUDED, which is the convention since EG. **EK added TWO files** —
  `check_ek.gd` and `docs/reports/EK.md` — and deleted none. **Re-derive with
  `claude_md_census.py` rather than quoting this**; the census reads `git ls-files`, so a new file
  is outside the number until it is staged.
- Heaviest: `scripts/battle.gd` **1228.75**, `docs/design-notes.md` **423.48**, `docs/master.html`
  **344.13**, `scripts/classes.gd` **336.87**, **`pin-manifest.json` 301.73**, `docs/changelog.html`
  **261.60**, `CLAUDE.md` **191.68**, `scripts/talents.gd` **178.68**, `scripts/unit.gd` **177.14**,
  `docs/talent-audit.html` **165.02**, `docs/state.md` **119.22**, **`docs/instrument-rules.md`
  70.08**. **`CLAUDE.md` IS NO LONGER IN THE TOP FIVE**, which is what the split was for.
  **`scripts/classes.gd` GREW 14.6 KiB AT EK** and it is the tag table — 227 rows and their header.
  The changelog grows about 8 KiB a batch, so CW's 400 KiB threshold is roughly seventeen batches
  away.
- **THE SHARE OF THE SYNC IS RETIRED AS A TARGET (EE §1) AND IS NOT TRACKED.** `CLAUDE.md` is
  measured in KiB against a **290 KiB ceiling** whose procedure is a SPLIT, **and EF took that
  split.** **It reads 191.69 KiB, which is 98.31 KiB of headroom — about
  twenty-one batches at +4,520 B/batch.** **EK grew it by 3,713 B (3.63 KiB)**, which is one
  standing reference: the three vocabularies, the tables and their one accessor each, the
  inertness ruling, and the rule that a new ability or rune is owed a row in the same batch.
  **`docs/instrument-rules.md` reads 70.08 KiB and has no stated ceiling**; the arithmetic for one is
  in `docs/reports/EF.md` §2 and taking it is a ruling.
  - **THE SPLIT COST 7,984 B OF ITS OWN** — the index block, the new file's header, two section
    headings and four repairs to blocks that stayed. **The two halves together read 245.30 KiB
    against 237.50 before.** About one and three quarter batches of growth, to buy thirteen.
  - **AND THE TWO HALVES DO NOT GROW AT THE SAME RATE, WHICH IS NOW MEASURED RATHER THAN ASSUMED.**
    Over the nineteen prune-free steps DK→EE the MAIN half grew **+2,867 B/batch** (median +3,214,
    max +6,448 at DR) against the instrument half's **+1,630** (median +653, max +5,118 at DX). Over
    the five post-prune batches DZ→EE it is **+1,890 against +3,623.** **Both are real and they point
    opposite ways; the recent one is what five instrument batches in a row look like.**
  - **FOR THE RECORD, AND NOT AS A TARGET: the retired ratio has not been re-derived at EF and is not
    worth re-deriving.** Its numerator is now spread over two files and its denominator gained both,
    which is the third way the same measurement can move without anything about density changing.
- **THE DESELECTION LIST FOR THE FILE PICKER.** **Deselect `pin-manifest.json`** — it stays in the
  repo and `check_ed` goes on reading it off disk. **After it: 173 files, 7.5189 MiB.** Already
  standing and unchanged: the 47 suite files, `docs/build_docs.py`, the archived changelog, and any
  audit document whose findings have been ruled on and applied. **`claude_md_census.py` IS A
  CANDIDATE TOO** by the same argument that deselects `build_pin_manifest.py` — it is a tool Claude
  Code runs off disk — **but it is 11.34 KiB and the saving is not worth a second entry to remember.**
  **WHAT MUST STAY SELECTED NOW INCLUDES `docs/instrument-rules.md`** and is listed in `CLAUDE.md`:
  **a split ADDS a file to that list and never removes one from the sync.**
- **The 47 suite files are unchanged in number and still the single largest block. They cannot be
  archived (they must be in the repo to run) but they CAN be deselected from the sync.** The gates
  are **41** — **EL ADDED `check_el`**, EK `check_ek`, EH `check_eh`, EG `check_eg`; EF and EE added none, ED added `check_ed`,
  EC `check_ec`, EB `check_eb`, EA `check_ea`, and DZ and DY each added none.
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
- **`test_batch_bo`'s FLAKY ASSERTION IS FIXED AT DT AND THAT FIX MOVED NO COUNT. THE NUMBER THIS
  LINE USED TO RESTATE (1106) WAS STALE BY FOUR BATCHES; the live figure is in `baselines.json` and
  is not repeated here.**
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
- **`check_parse` COVERS THE GATES, THE SUITES, BOTH FIXTURES AND THE DATA JSON SINCE EI**, off a
  population derived from `run_battery.sh` rather than from a directory list. **It still does not
  cover the two `.py` instruments, the shell scripts, `shaders/outline.gdshader` or the `assets/`
  binaries no dependency edge reaches** — printed in its own output every run, so the gap is stated
  rather than assumed away. **Its verdict is still read off stderr and never off the tally**: DR's
  control idiom (a deliberate `func _dr_negative_control(:`, restored **from a scratchpad backup
  rather than by `git checkout`**) is what EI's ten arms use.
- **A GATE THAT EXITS 0 IS NOT A GATE THAT PASSED.** **A `--script` target whose base class does not
  resolve prints `Parse Error`, runs not one line, and exits 0.** Grep the stderr; never trust the
  tally and never trust `$?`. **`run_battery.sh`'s `throws=` column is the only thing standing
  between this fault and a green report.**
- **The `_hint_done` / `_skill_done` deadlock is real and is NOT currently biting.** Both
  skill-check orientation cards `await` a signal only a real click or key press emits. **A future
  headless modal will hit this again** — `_nobody_can_press()` is the one place the question is
  asked, and a Profile flag is not a bot guard.

### Last measurements

**ONE BATTERY AT EM, FROZEN, AND IT CERTIFIED ON PASS ONE.** **198 files were MD5-stamped with
ABSOLUTE paths before it and re-compared after with the same absolute paths: it drifted ZERO** —
the tree the battery read is byte-for-byte the tree that ships. **The reds were all found before
it**, by nine negative controls, a two-arm literal sweep and standalone runs of every touched
target.

| | EI's acceptance | EK's acceptance | EL's acceptance | **EM's acceptance** |
|---|---|---|---|---|
| **suite failures** | 0 | 0 | 0 | **0** |
| **throws, grepped from the stream** | 0 | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | 0 | **0** |
| `check_de` | 346 / 0 / 0 | 350 / 0 / 0 | 354 / 0 / 1 → 0 | **358 / 0 / 0** |
| run harness | 22 / 166 / 8 | 22 / 166 / 8 | 22 / 166 / 8 | **22 / 166 / 8** |
| targets in the manifest | 84 | 85 | 86 | **87** |

**EIGHTY-SEVEN TARGETS RAN, THE MANIFEST NAMES ALL EIGHTY-SEVEN, AND THERE ARE EIGHTY-SEVEN LOGS**
— compared both ways and checked for duplicate names, which is the fault a shared log directory
produces. **0 `Parse Error` and 0 `SCRIPT ERROR` in every one of the 87 logs** — grepped from the
log files rather than read off a tally or an exit code. **`check_map_screen: OK`, and its live tag
drive read 12 tag lines for 12 offered cards**; `check_ct_map` 83 / 0.

**`check_de` READ 358 CHECKS, ZERO FAILURES AND ZERO NOTICES.** All six baseline rows this batch
moved were written BEFORE the run, so the differ had nothing to report in either direction —
**which is exactly the half EL's own record says it missed.** The +4 over EL's 354 is `check_em`
joining the battery; that differ makes four assertions per target.
- **THE RULE THIS HAS NOW PAID FOR THREE TIMES: `check_parse`'s COUNT IS ITS COVERAGE.** Its
  population is derived from `run_battery.sh`'s own `GATES` array, so **any batch adding a target
  moves this row**. **A batch that adds a gate owes TWO baseline rows, not one**, and EM wrote both
  before the run.
- **AND IT READ 163 BEFORE IT READ 161.** Two scratch measurement probes were sitting in the repo
  root and `check_parse`'s RESIDUE walk found them. **That is the walk working**; they were moved
  out of the tree and the residue is 4 again.

**THE EVIDENCE THAT MATTERS WAS FOUND BEFORE THE BATTERY, AND THE PIN MANIFEST WAS NOT THE
INSTRUMENT THIS TIME.** `check_ed` was run against HEAD's own manifest with every edit in place and
read **18 / 0**; regenerating moved **three line-number references and nothing else — 0 pins lost,
0 gained.** That is not this batch being small: **the 26 assertions it actually broke live in array
literals read through a variable** (`for pair in [...]` → `contains(String(pair[0]))`), which the
extractor classes as having no static needle — 93 of 1041 source pins are in that class. **The
literal sweep is what found them**, 11,249 needles over 38 haystacks, and it agreed exactly with
the set the suites reported when run: **26 LOST against HEAD's needles, 0 LOST against the current
ones.** Separately, **all 346 negative pins were re-checked** (`CHECKED 346 of 346`) and none of the
new prose put a retired string back.

**NINE NEGATIVE CONTROLS WERE ARMED. ALL NINE BIT — AND THREE OF THEM DID NOT BITE THE FIRST
TIME, WHICH IS THE PART WORTH KEEPING.** Five on `check_em`, one on the live game (the spread guard
reading the node's counter alone: **0 marks spread in 400**, against 55–66 armed), two arms on the
literal sweep, one on the negative-pin pre-check.
- **THE UNPAIRED-READ SWEEP PRINTED A CLEAN ZERO WHILE BLIND TO 80 OF ITS 85 SITES.** Its regex
  excluded a match preceded by a word character **or a dot**, and `attacker.vulture` has a dot in
  front of it. **A control armed on the one `cfg.get("…")` site DID bite and proved nothing**; the
  control that found the hole was armed on a DOTTED read.
- **THE LITERAL SWEEP'S FIRST CONTROL WAS ARMED ON A NEEDLE THAT WAS ITSELF NEW**, so breaking it
  moved the GAINED column and left LOST at zero. **Its second replaced the needle with a string
  that CONTAINED it** (`aegis_ranks` → `aegis_ranks_X`), so `contains` stayed true. A differential
  sweep can only be controlled on a needle BOTH trees carry, broken rather than extended.
- **AND ONE INSTRUMENT WAS VACUOUS BEFORE IT WAS RIGHT.** The negative-pin pre-check read the
  manifest's haystack field under the wrong key name, so every row was skipped and it reported
  **0 violations over 0 pins checked** — indistinguishable from a clean reading. It prints
  `CHECKED n of m` now.

**AND ONE SUITE WAS READING A THROW AS A PASS.** `test_batch_as` printed *"375 checks / 0
failures"* while a missing dictionary key raised at line 412 and nineteen assertions never ran; its
baseline is 394 and the battery reads 394 now. **That is CD's lesson exactly** — a suite that throws
is not a suite that passed — and it is why the throw count was read beside the check count on every
target in this batch.
