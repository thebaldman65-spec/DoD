# BATCH EA — A ZONE-BOSS AWARD ALWAYS PAYS

*2026-08-30. Three sections. **The fallback DZ priced is BUILT and it is a spec-draft card the
hero does not hold; six assertions pinning a batch code inside `CLAUDE.md` are re-pointed at the
rules they were reaching for; and every protected core is measured against the draft cards that do
comparable work.** No ability magnitude moved, no card was authored, and `Ability.PURE_BUFFS` was
not widened. **14 of the game's 36 zone-boss awards could pay nothing; after §1 the figure is 0.***

---

## THE BRIEF'S AND THE RECORD'S CLAIMS THAT DID NOT SURVIVE MEASUREMENT

Recorded first, because three of them changed the work.

1. **§2 SAYS "THREE ASSERTIONS PIN A BATCH CODE INSIDE `CLAUDE.md`". THERE ARE SIX, AND THEY COME
   IN TWO SHAPES.** Four are BARE pins — `BATCH BN`, `BATCH BS`, `BATCH CE` and **`BATCH CG`**,
   which is the fourth DZ predicted would not be found by reading. It sits **one line below the
   third**, in `test_batch_ce`, in the same block. **And two more are a different shape the brief
   did not describe**: rule pins whose LITERAL still carries a code —
   `"BATCH BN §2 — WAS x0.70"` and `"REWRITTEN AT BATCH BS, NOT AMENDED"`. Those are real claims
   about real rules, and they still red the day the attribution sentence is edited.
2. **§1 SAYS "THE SPEC-DRAFT POOL FLOORS AT SIX CARDS AND CANNOT ITSELF EMPTY". THE FLOOR IS SIX
   BY THE SLOT ARITHMETIC AND **FIVE** ONCE THE RUNES ARE CARRIED.** `owned_ability_names` cannot
   see an ability a RUNE grants — the grant lands on the battle `cfg` in `Talents.apply_payload`
   and never on the member dict. **Four runes grant an ability and two of the four name a card in
   the same hero's own draft pool**, which costs the Occultist one. Five still fills a three-card
   offer twice over, so the ruling is unaffected; the *number* is not the one the brief carried.
3. **§3 ASKS WHETHER THE PROTECTED CORES ARE MISPRICED LOW AND THE ANSWER IS DIRECTIONAL AND
   CONSISTENT, BUT IT IS TWO AXES OUT OF THREE, NOT THREE.** Cores are systematically cheaper on
   RESOURCE and shorter on COOLDOWN. On INITIATIVE they are systematically **slower**. The
   controlled comparison holds anyway — at equal initiative, 13 of 17 pairs favour the core — but
   "priced low" is not true across the board and saying so flat would be wrong.
4. **§1's "14 of 36" HELD EXACTLY**, re-derived rather than inherited, as did the award count of 3
   off `Run.SLOT_COUNT`, the slot cap of 7, the eight emptiable specs, and the Devout as the sharp
   case at 2 boss cards both of which are draftable.
5. **DZ's "the needle verifier was green and the extractor had one hole" UNDERSTATES IT.** The
   first-literal hole is real and is fixed. **The larger hole was in EA's own rebuild**: it counted
   brackets *inside string literals*, so a `"("` in a failure message left the depth permanently
   open and glued every following statement into one. It read **32** asserted literals where there
   are **95**. Neither hole is visible from inside the instrument.

---

## §1 — THE FALLBACK IS BUILT

**Ruled by the brief, implemented here.** When a spec's boss pool is exhausted, the award pays a
card from that spec's **draft pool** that the hero does not already hold — three offered, and
**announced exactly like any other award**.

### THE CHANGE, AND WHY IT IS TWO LINES

`Run.award_ability_pick` opened on `roll_spec_ability_offer(member)` and `return false`d when that
came back empty. **That line is untouched** — the boss pool is still the first thing a zone boss
reaches for, so AN §4's spec-lock ruling stands and `test_batch_bb` §6's pin on that exact source
line stays green. What is new is the branch under it:

```
	var offer := roll_spec_ability_offer(member)
	if offer.is_empty():
		offer = roll_spec_fallback_offer(member)
	if offer.is_empty():
		return false
```

**It is this small because both channels already write the same list.** `bm_abilities` is where a
drafted card and a boss pick both land — which is exactly the mechanism that empties these pools —
so the fallback needed no new storage, no new screen and no save-format change. The award site
already banks a triple, the map's owed-pick overlay already resolves one, and `_pick_ability` is
pool-agnostic and takes a name.

### THE DEFECT WAS THE SILENCE, NOT THE REWARD

`battle._award_ability_picks` skipped a hero whose roll came back empty — its comment said so
deliberately — so **the boss died and the victory card did not name them.** A player who had
drafted well was told *less* than one who had not. `award_ability_pick` returning true is what puts
the hero into `named`, and the existing announcement line does the rest. **The comment recording
the silent arm is corrected rather than left to rot**; the one arm this loop can still skip is a
member with no spec.

### EVERY SPEC'S DEPTH AGAINST THE AWARD COUNT, AFTER THE FALLBACK

Derived live, not assumed. `earnable` is `ABILITY_SLOT_CAP − core_slots(spec)`; `rune` is the count
of ability-granting runes this spec can WEAR whose card sits in its own draft pool.

| spec | boss | draft | safe | lost BEFORE | earnable | rune | fallback floor | lost AFTER |
|---|---|---|---|---|---|---|---|---|
| **Devout (inquisitor)** | **2** | 11 | **0** | **3** | 4 | **1** | 6 | **0** |
| Berserker | 3 | 10 | 1 | 2 | 4 | 0 | 6 | 0 |
| Pyromancer | 3 | 13 | 1 | 2 | 4 | 0 | 9 | 0 |
| Cryomancer | 3 | 11 | 1 | 2 | 4 | 0 | 7 | 0 |
| **Occultist** | 3 | 10 | 1 | 2 | 4 | **1** | **5** | 0 |
| Swordmaster | 4 | 12 | 2 | 1 | 4 | 0 | 8 | 0 |
| Arcanist | 4 | 12 | 2 | 1 | 4 | 0 | 8 | 0 |
| Holy | 3 | 10 | 2 | 1 | **3** | 0 | 7 | 0 |
| Warden | 4 | 10 | 3 | 0 | 4 | 0 | 6 | 0 |
| Beastmaster | 5 | 10 | 5 | 0 | 4 | 0 | 6 | 0 |
| Sharpshooter | 5 | 10 | 5 | 0 | 4 | 0 | 6 | 0 |
| Survivalist (mystic) | 5 | 10 | 5 | 0 | 4 | 0 | 6 | 0 |

**14 → 0. No spec can still be paid nothing**, and the thinnest fallback pool in the game is the
Occultist's **5** against the **3** an offer asks for.

**THE EIGHT EMPTIABLE BOSS POOLS DID NOT MOVE AND ARE NOT SUPPOSED TO.** `check_dv` §2 measures
that population and still reads 8; what EA changed is what an emptied pool *costs*. `check_ea` §1
asserts the 8 as well, in the opposite direction: **if it ever reads 0 the fallback is dead code**,
which is worth being told rather than discovering.

### THE RUNE DRAIN, MEASURED — AND THE CONTROL THAT CAUGHT ME MEASURING NOTHING

`Runes.kit_names` reads the class kit, the spec kit, the overrides and `bm_abilities`. **It does
not read the hero's runes**, because a rune grant is applied to the battle `cfg` at spawn. So a
rune-granted card that also sits in a spec draft pool is one name the fallback's filter cannot see.

| rune | scope | grants | in a draft pool |
|---|---|---|---|
| Rune of the Comet | class:mage | Comet | — |
| **Rune of Binding Souls** | class:cleric | **Sacred Resolve** | **inquisitor** |
| Rune of the Last Rites | spec:holy | Resurrection | — |
| **Rune of the Flayed Mind** | spec:occultist | **Mind Flay** | **occultist** |

**BOTH COLLIDING NAMES ARE ALSO IN THEIR OWN SPEC'S BOSS POOL**, so the fallback exposes nothing
the existing channel did not — this is a pre-existing property shared by `roll_spec_ability_offer`
and `draft_pool_left` alike, and `docs/state.md` already carries it as an open rune question. It is
carried in the arithmetic rather than waved off because it is the only term that can push the floor
below the slot count.

**AND THE FIRST VERSION OF THIS MEASUREMENT WAS VACUOUS.** The probe read `runes.json` as an
Array; it is a **Dictionary**, so the walk never ran and printed *"rune entries naming an ability
grant = 0"* — the wrong answer, in the safe-looking direction, from a control that looked like it
had passed. **A sweep must assert its own population**, and that rule is now in `CLAUDE.md` with
this as its case.

### THE ONE JUDGEMENT CALL: THE FALLBACK DOES NOT CONSULT `draft_refused`

Three reasons, the last decisive, and all three are at the site:

- **`roll_spec_ability_offer` has never consulted it either**, so filtering here would make the
  fallback stricter than the channel it belongs to.
- **Refusal is the DRAFT channel's own memory** — `_refuse_draft` exists so the next DRAFT offer
  does not re-present what was just turned down, and `decline_draft` refuses the whole triple. A
  zone boss is a different and much rarer event.
- **A run that declines enough offers could drain the floor back below three**, which is the exact
  defect the fallback exists to close.

### THE CONTROL, IN TWO ARMS, ON A REAL ZONE BOSS

**The brief required the control to prove the ANNOUNCEMENT, not only the grant.** A source-level
`contains` would pass on a line no path reaches, so `check_ea` §2 resolves a real zone boss and
reads the label off the end card's own `Label` node.

- **ARM A — boss pools emptied, draft pools left alone.** All four heroes are awarded, and the
  victory card reads: *"NEW ABILITY: Berserker and Pyromancer and Devout and Beastmaster may choose
  one of three on their card."* Each hero is named by `_hero_label`, and each owes exactly one pick.
- **ARM B — both pools emptied.** `_award_ability_picks()` returns `[]`, the announcement is
  **ABSENT**, and **the end card is still present** — which is what proves arm B's absence is the
  award's absence rather than a probe that stopped working.

**A control that only fires in the passing direction cannot tell an announcement from a constant.**

---

## §2 — SIX ASSERTIONS PINNED A BATCH CODE INSIDE `CLAUDE.md`

**All six are re-pointed at the RULE each was reaching for. None was deleted, because every one had
a live rule behind it.**

| site | was | is now | the rule it was actually testing |
|---|---|---|---|
| `test_batch_bn:497` | `"BATCH BN"` | `"## STANDING REFERENCE — THE DIFFICULTY LADDER AND THE END BOSS"` | the ladder is a standing reference |
| `test_batch_bn:504` | `"BATCH BN §2 — WAS x0.70"` | `"rung 1 Wanderer x0.50"` | rung 1 alone moved; the NUMBER is the claim |
| `test_batch_bs:415` | `"BATCH BS"` | `"## STANDING REFERENCE — THE UNCAPPED-METER GOVERNOR TABLE"` | the governor table BS's row lives in |
| `test_batch_bs:422` | `"REWRITTEN AT BATCH BS, NOT AMENDED"` | `"TABLE THAT IS A CEILING RATHER THAN A COST"` | Overburn is a ceiling, not a cost |
| `test_batch_ce:585` | `"BATCH CE"` | `"RE-POINTS IN PLACE, with the reason in the file"` | the re-point discipline CE helped close |
| `test_batch_ce:586` | **`"BATCH CG"`** | `"BINDING ON EVERY CONTENT BATCH FROM IT"` | the content-batch convention CG set |

### EVERY ONE OF THE SIX WAS PASSING OFF A DIFFERENT SENTENCE THAN ITS MESSAGE CLAIMED

**There is no `BATCH BS` block and no `BATCH CE` block.** CW's split ended batch narratives in that
file and DZ's prune removed the last of them. The four bare pins were satisfied by STANDING RULES
that name the batch in passing — the difficulty ladder's attribution, the governor table's rewrite
marker, the content-batch convention. `docs/state.md` already recorded `bs`'s as passing by
accident; **it was true of all four.**

**A check that passes for a reason other than the one it states has stopped asking its question —
and it reads green while it does it.** That is worse than a red, because a red gets investigated.

### THE FOURTH, AND WHY READING WOULD NOT FIND IT

`BATCH CG` is **one line below** `BATCH CE`, in the same suite, in the same block. DZ read the tree
carefully, found three, and wrote down that a fourth existed and would not be found by reading.
**What found it was matching the VARIABLE HOLDING THE DOCUMENT rather than the filename or the
literal** — and scoping that **per function**, because `test_batch_bx` binds the name `master`
three times in one file and two of them are stripped copies. A file-scoped version of the same
sweep reports a violation that is not there, which is how an instrument gets switched off.

**The sweep is now permanent as `check_ea` §3**, and it asserts its own population: at least 20
files reading `CLAUDE.md` and at least 40 asserted literals, because a regex matching nothing
reports *"no violations"* in exactly the same words as a clean tree. It reads **25 readers, 61
asserted literals, 0 batch-code pins.**

### WHAT THE SWEEP FOUND THAT IS *NOT* A DEFECT

**57 batch-code literals in the tree, and 51 of them are correct.** They are pins against
`docs/changelog.html`, its archive, `docs/design-notes.md` and `.gd` source comments — documents
whose whole purpose is a per-batch record, where a batch code is the entry's identity rather than
narrative drift. **CW's split was about `CLAUDE.md`**, and the sweep is scoped to it deliberately.

---

## §3 — THE PROTECTED CORES AGAINST COMPARABLE DRAFT CARDS

**MEASURED. RULED ON NOTHING. `Ability.PURE_BUFFS` WAS NOT WIDENED AND NO MAGNITUDE MOVED.**

DZ found Blessing of Zeal — a protected core — sitting ON its family's line on initiative and UNDER
it on both cost and cooldown, and concluded that if either of that pair is mispriced it is the
core, priced low. **§3 asks whether that is one card or the shape of the layer. It is the layer.**

### CONTROLLED THREE WAYS, BECAUSE EACH CONFOUND IS REAL

- **Same spec**, so the cost is one currency — comparing a Berserker's Rage against a Mage's Mana
  is not a comparison.
- **Same role**, derived from the ability's own fields (`heal` / `HEAL_SPECIALS` → heal,
  `SHIELD_SPECIALS` → shield, `damage` / `DAMAGE_SPECIALS` → damage or aoe-damage, else buff or
  debuff by target), ordered so the strongest signal wins.
- **Same initiative, with `PURE_BUFFS` members excluded from both sides.** `Ability.make()` clamps
  every member to `BUFF_DELAY_CAP`, so a clamped initiative is not a price anyone chose — DZ's
  central structural finding, applied as a control rather than repeated as a claim.

### THE RESULT

**17 comparable pairs. In 13 of the 17 the core is cheaper on an axis and dearer on neither.**

| | core cheaper / shorter | core dearer / longer | equal |
|---|---|---|---|
| **resource** | **10** | **2** | 5 |
| **cooldown** | **13** | **1** | 3 |

**Both counter-cases are the same draft card.** Divine Plea against Holy's Heal and Renewal — and
Divine Plea costs **0 Mana**, which is the whole of its advantage. **Exactly one draft card in the
game is cheaper than a comparable protected core.**

The wide view, cap excluded, agrees in every bucket:

| role | channel | n | initiative | cost | cooldown |
|---|---|---|---|---|---|
| damage | core | 18 | 2.89 | **22.5** | **2.06** |
| damage | draft | 37 | 2.51 | 25.8 | 3.62 |
| aoe-damage | core | 4 | 3.38 | **27.5** | **2.75** |
| aoe-damage | draft | 7 | 3.14 | 28.6 | 3.86 |
| buff | core | 8 | 2.75 | **17.5** | **3.00** |
| buff | draft | 41 | 2.16 | 21.2 | 3.88 |
| heal | core | 4 | 3.12 | **15.0** | **2.25** |
| heal | draft | 6 | 2.33 | 21.7 | 4.00 |

**AND THE THIRD AXIS RUNS THE OTHER WAY, WHICH IS WHY THE CONTROLLED COMPARISON IS THE ONE THAT
COUNTS.** Cores are *slower* in every bucket. At **equal** initiative the picture is 13 of 17
favouring the core, so the tempo the cores pay does not buy back the resource and cooldown they
save.

### THE STRUCTURAL FINDING, EXTENDING DZ's RATHER THAN REPEATING IT

**The cap binds the two layers at different rates.** `BUFF_DELAY_CAP` is the only instrument in the
project that prices an initiative and it binds by table membership — and it reaches **38 of 129
draft cards (29.5%)** against **5 of 39 cores (12.8%)**. So the one thing that prices tempo reaches
the draft layer **more than twice as often** as it reaches the cores, and the cores are
correspondingly priced by hand against nothing.

### THE COUNTER-ARGUMENT, RECORDED WITH THE NUMBER SO IT TRAVELS WITH IT

**A protected core arrives free with the spec; a draft card costs a pick.** "Cheaper to cast" is
exactly what a designer would author on purpose if the core is the baseline the spec is built
around. **Nothing in the code distinguishes that reading from a mispricing**, and choosing between
them is a balance decision across twelve specs. **This needs the designer, not a batch.**

`check_ea` §4 therefore pins the **direction** rather than the counts — a hard count would red on
any pool growth — so the day somebody re-prices a core, this report is announced stale instead of
quietly describing a game that moved.

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **No ability magnitude moved and no `PURE_BUFFS` membership moved.** §3 is a measurement.
- **No boss card was authored.** §1 is the general fix precisely so per-spec authoring is not needed.
- **`Ability.PURE_BUFFS` was not widened to bring Arcane Surge under the cap.** DZ verified both
  memberships are correct and the brief forbade it; the delay was the question, not the membership.
- **The rune blind spot is reported, not fixed.** `owned_ability_names` cannot see a rune grant;
  that is pre-existing, shared by every channel, and closing it is the open rune question
  `docs/state.md` already carries.
- **`draft_refused` is not consulted by the fallback**, for the three reasons above.
- **`run_sim._award_trophies`'s header still names `Run.roll_ability_offer`, a function DY deleted.**
  Noticed while pointing that function at the same fallback. One line, pre-existing, and out of
  scope for a batch that was not asked to sweep sim prose.

---

## §5 — VERIFICATION

### THE DOCUMENTS WERE WRITTEN BEFORE THE BATTERY

`CLAUDE.md`, `docs/master.html`, `docs/changelog.html` and `docs/design-notes.md` were all final
before the certification run. **`docs/state.md` and this report are written during it and are read
by nothing**, which is why this project writes them last.

### THE PREDICTION, WRITTEN BEFORE THE FIRST READING

**PREDICTION: EXACTLY TWO ROWS MOVE — `test_batch_ah` 5575 → 5584, and `check_ea` arrives at 60 —
AND `check_de` READS 325 / 0 / 0.**

Predicted from what each suite **READS**, not from what this batch writes:

- **`test_batch_ah`** asserted the OLD behaviour outright (*"award_ability_pick refuses when there
  is nothing to offer"*). +9: −2 inverted, +11 added.
- **`check_ea`** is a new target, so `check_de` gains four assertions (289 → 293 was DM's shape;
  321 → **325** here). **`check_de` has no row of its own, so its own movement is reported by
  nothing** — and the row is written BEFORE the battery precisely so `check_de` certifies on pass
  one instead of reporting an unwatched target.
- **`test_batch_bb` §6** pins the literal `var offer := roll_spec_ability_offer(member)`, and
  **`check_dv` §0** requires `award_ability_pick`'s body to contain `roll_spec_ability_offer`. The
  implementation keeps that line byte-identical, so neither moves. Confirmed: 177 / 0 and 83 / 0.
- **`check_dv` §2** measures the BOSS pools and `SPEC_POOLS` / `SPEC_DRAFT_POOLS` did not move, so
  it stays at 83 and its emptiable-8 assertion stays green.
- **`check_da` §3** flags a gate carrying BOTH draft-pool accessors. `check_ea` reads only the SPEC
  side and every section returns void, so it trips neither that fingerprint nor DW's returning-walk
  rule — **no exemption, and no second battery.** Confirmed live: `check_da` 39 / 0.
- **`test_batch_bn` / `bs` / `ce`** are re-pointed one-for-one, so their counts do not move: 81,
  266, 1114.
- **The four edited documents** are asserted by `contains` calls whose COUNT is fixed.

### THE PRE-BATTERY INSTRUMENTS

1. **THE NEEDLE VERIFIER, WITH THE EXTRACTOR FIXED.** DZ's took only the FIRST literal out of each
   `contains(`. This one joins **logical statements** (trailing backslash and open brackets), takes
   **every** call on the identifier, follows **chained** calls (`doc.to_lower().contains(…)`),
   models **`or` groups** (demanding both halves of an `or` is a false alarm, and a false alarm is
   how an instrument gets switched off), records **polarity**, refuses **transformed holders**
   (`_src(…).replace(…)` — the retired-word sweep owns those), and separates **`find()` locators**
   from assertions. **73 positive groups, 22 or-alternatives, 30 negatives, 46 locators, across 81
   files** — against DZ's 57–60. Green at HEAD before a line was edited, and green after.
2. **AND ITS OWN SECOND HOLE IS THE MOST USEFUL RESULT IN §5.** The first rebuild read **32**
   asserted literals. It counted brackets **inside string literals**, so a `"("` in a failure
   message left the bracket depth permanently open and glued every statement after it into one.
   **A sweep is only as wide as the convention it matches — and an extractor is a population that
   has to be asserted like any other.**
3. **THE LITERAL-FLIP SWEEP**, 10,834 distinct literals at a floor of 4 across all 81 files:
   **`CLAUDE.md` 1 gained / 0 lost; `master.html` 1 / 0; `changelog.html` 16 / 0;
   `design-notes.md` 6 / 0.** **All 24 gained literals were cross-checked against the tree's 247
   distinct negative assertions.** One matched by name — `drain` — and **all four of its negative
   assertions read ABILITY DESCRIPTIONS** (`pdesc`, `imm.description`, `ed.description`) or the
   specific CLAUDE.md string `` `_overburn_drain` (uncapped cost) ``, none of which reads
   `changelog.html`. **No gained literal is negatively asserted against a document it landed in.**
4. **THE RETIRED-WORD SWEEP** over the edited `master.html`, using `test_batch_bx` §4b's own
   `PARTY_IDENTS` strip and §4's `Beastmaster` strip: **0 *party* and 0 *beast*, in the edited file
   and at HEAD alike.** Run before the battery, which is what turned DU's *"party-wide"* into a
   five-minute fix instead of a second thirty-five-minute run.
5. **A 36-TARGET SUBSET BATTERY**, over every live reader of the four edited documents plus the
   three gates most likely to notice a new one. **All 36 green: 0 `Parse Error`, 0 `SCRIPT ERROR`,
   0 FAIL lines**, and every count on its baseline. DZ's lesson applied: this is the instrument
   that finds what the sweeps are structurally unable to see, and it costs minutes.

### THE NEGATIVE CONTROLS

1. **THE FIRST ARMED CONTROL DID NOT BITE, AND THAT IS RECORDED FIRST BECAUSE IT LOOKED EXACTLY
   LIKE A PASS.** EA's own new `CLAUDE.md` heading — *A ZONE-BOSS AWARD ALWAYS PAYS (Batch EA §1)*
   — was split across a line wrap and **both the verifier and `test_batch_bs` stayed green**, for
   the correct reason: no suite asserts that string, so it is not in the needle set. **A control
   armed on a string nobody asserts proves nothing, and it reports the same word a real pass
   does.** Check the needle is a needle before you break it.
2. **RE-ARMED ON ONE OF EA's OWN RE-POINTED NEEDLES, AND BOTH INSTRUMENTS BIT.**
   `TABLE THAT IS A CEILING RATHER THAN A COST` — the string EA §2 moved `test_batch_bs:422` onto —
   was split across a line wrap, **not one character deleted**. **The verifier named the violation
   and the file that asserts it, and `test_batch_bs` went 266 / 1** with
   *"§5: CLAUDE.md's governor row still states Overburn is a ceiling, not a cost"*. **So EA §2's
   re-points are live assertions rather than sentences nobody reads** — which is the thing a
   re-point has to prove and the thing the batch codes it replaced never did. Restored **by `cp`
   from a scratchpad backup, never by `git checkout`**; `CLAUDE.md`'s md5 returned to the
   certified run's `a5960434e60c39e313faa19b78d8316e` and both instruments went green again.
3. **THE PARSE CONTROL BIT, AND IT WAS OWED THIS TIME BECAUSE EA EDITS `.gd` FILES.** One closing
   parenthesis was removed from `roll_spec_fallback_offer`'s own signature — the function EA
   authored. **`check_parse` produced 22 `Parse Error` lines in stderr**, opening with
   *"Expected closing \")\" after function parameters."*, and its tally read 7 failures.
   **Grepped from stderr, never from the tally and never from the exit code.** Restored by `cp`;
   `scripts/run_state.gd`'s md5 is byte-identical (`ae5bd8ab9aff4daf6df5c66907c5361e`).
4. **AND THE §1 CONTROL IS PERMANENT RATHER THAN ONE-OFF.** `check_ea` §2's two arms run on every
   battery, so the day the announcement stops firing the gate says so.

### THE ACCEPTANCE RUN

**One battery, and it found nothing.** No suite failure, no throw, no notice, and the only red is
the one that is on purpose.

| | DY's acceptance | DZ's acceptance | **EA's acceptance** |
|---|---|---|---|
| **suite failures** | 0 | 0 | **0** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 321 / 0 / 0 | 321 / 0 / 0 | **325 / 0 / 0** |
| targets in the manifest | 78 | 78 | **79** |

**SEVENTY-NINE TARGETS RAN AND THE MANIFEST NAMES ALL SEVENTY-NINE. 0 `Parse Error` and 0
`SCRIPT ERROR` across all 79 logs** — grepped from the streams rather than read off a tally or an
exit code. The run harness reads **22 / 165 / 8**, all three passing; `check_map_screen: OK`;
`check_ct_map` 83 / 0.

### THE PREDICTION HELD EXACTLY, INCLUDING BOTH MOVEMENTS

**`check_de` reported 325 checks, 0 failures and ZERO NOTICES.** `test_batch_ah` read **5584** and
`check_ea` read **60** — the two rows written BEFORE the run — and **no third row moved.**
`check_de` itself went 321 → 325, four assertions for the one new target, which is the movement
nothing reports because it has no row of its own. `test_batch_an` read **6047**, inside its
recorded [6046, 6063] band, and the differ said so by saying nothing.

### THE TREE WAS FROZEN AND IT IS PROVEN, NOT CLAIMED

**175 files were MD5-stamped before the acceptance run and re-compared after. EXACTLY ONE DIFFERS
AND EXACTLY ONE IS NEW: `docs/state.md` and `docs/reports/EA.md`** — the two written during it.
**Nothing reads either, and that was checked rather than recalled**: six files NAME `state.md` and
all six mentions are inside comments. `CLAUDE.md`, `docs/master.html`, `docs/changelog.html`,
`docs/design-notes.md`, `baselines.json` and every `.gd` file are **byte-identical across the run**,
so the battery certified what ships.

### THE CODE CHANGE, PROVEN WITH A COMMENT-STRIPPED DIFF

**Thirteen added lines, zero deletions, zero in-place modifications**, against `git show HEAD`:

- **`scripts/battle.gd` — COMMENTS ONLY, zero code lines.** Its silent-skip comment was corrected;
  the diff of the comment-stripped file is empty. (A comment insert that eats a live line is a real
  failure mode in this project, so "comments only" is proven rather than asserted.)
- **`scripts/run_state.gd`** — two lines in `award_ability_pick` and the nine-line
  `roll_spec_fallback_offer`.
- **`scripts/run_sim.gd`** — the same two-line sequence, so the bot rolls what the real flow rolls.
  **A sim that kept skipping would under-measure exactly the population EA changed.**
