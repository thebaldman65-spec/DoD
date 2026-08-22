# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

*Last rewritten: 2026-08-21 (Batch DB).*

---

## WHERE THE PROJECT IS

- **Last batch: DB** — the gate fixture consolidated, and the first full battery since CS.
  **`_spawn` and the tally are authored once in `gate_fixture.gd` and all seven gates go through
  it; `check_da` §3 asserts there are no copies rather than counting them; and the battery ran
  twice, before and after, to prove the consolidation inert.** No save version moves (still v10).
- **Next letter: DC**, and **it is already specified: the SUITES.** The two-letter stamp gate in
  fourteen suites reads `substr(_code_at + 7, 2)` out of `(Batch XX)` and compares lexically —
  `DC` sorts after `DB`, so it still works. **A THREE-letter code would break all fourteen.**
- **Phase.** The ability draft is COMPLETE (120 of 120) and all twelve talent trees are
  purpose-authored. Recent batches are correction and consolidation: the skill-check rework
  (CM/CN/CS), the fold rulings (CQ/CR), the pouch (CT), the talent audit (CU/CV), the documentation
  split (CW), the archive cut (CX), the tempo rule (CY), CZ's two ramp repairs, DA's correction of
  one of them, and DB's consolidation.
- **THE OPEN WORK IS NO LONGER MOSTLY DESIGN DECISIONS.** DB measured a debt that was previously
  an estimate: **72 failing assertions across 26 suites**, and **DC's consolidation is ten times
  the size of DB's**. Those two are the queue now; the design decisions are behind them.

---

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION

**DB named two large items and closed one. Nothing else was added.**

### THE TWO THAT ARE NOW THE QUEUE

- **BATCH DC — THE SUITES, AND IT IS TEN TIMES DB's.** `_spawn` in **37 suites as 34 distinct
  bodies**, `_run` in **39 as 39**, `_kill` **byte-identical in 14**. **`gate_fixture.gd` is the
  proven shape and the `--script` base-class trap is already paid for**, but 34 bodies is not 4,
  and suites do not share one battle fixture the way seven gates did. **It wants its own
  verification pass.**
- **THE STALE-ASSERTION PASS — MEASURED, NOT ESTIMATED: 72 FAILURES ACROSS 26 SUITES.** See
  KNOWN-BROKEN below for the breakdown. **It should follow DC, because DC will move the same
  files.** Each one needs a ruling on what it should ask INSTEAD, which is why DB, DA and CX all
  left them standing.

### Carried, with measurements attached

- **THE FRENZY RATE IS `FRENZY_RAGE_PER_STEP` = 5** and is a rule rather than a constant (five Rage
  is 5% of a full bar, the health term's own rate). Peak Frenzy 13.4 → 20.9 of 40 at rung 2 under
  CZ, and **DA re-measured it unchanged at 20.7**. **Reckless Abandon dumping a full bar books all
  twenty steps at once** — named, not discovered later.
- **THE FAITH LANE IS SETTLED FOR NOW AND THE NUMBERS ARE IN `docs/reports/DA.md`.** Threshold 3,
  builders 2 and 1, releases **1.93 / 2.60 / 2.48 / 3.62** across the four arms. **Elevation (2 of
  3) and Blessing of the Faithful (3 of 3) were reported at both CZ and DA and deliberately changed
  at neither.** If either is revisited, Elevation is the one with a history of being moved by
  accident (CG set 2, CN's fold pushed 3, CQ reverted it).
  - **BUT THE THRESHOLD HAS NEVER BEEN PAID FOR IN THE SUITES**, and DB measured what that costs:
    **`be`, `bf`, `bg`, `bh` and `bi` are 23 of the 72 failures**, all of them asserting a ladder
    that reaches four and five stacks. **At `FAITH_RELEASE` = 3 an ally can never stand at four.**

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

- **TEN OF NINETEEN GATES STILL CANNOT REPORT A CHECK COUNT.** DB fixed the seven it consolidated.
  `check_parse`, `check_flow`, `check_map`, `check_cl_resolver`, `check_cl_width`, `check_cm` and
  `check_cn` still read `checks=?` in the battery, **and `check_cl_width` reports `fails=?` as
  well** — the battery cannot see whether it passed at all. **A count that reads `?` is the one
  thing a count-diffing rule cannot compare.**
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
- **The code identifiers still reading "beast".** The PROSE was renamed; the fields were not, on
  purpose — a missed rename in prose is a typo, a missed rename in a field is a bug, so the two
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
- **`docs/text-audit.html` and `docs/talent-audit.html` hold findings that have been ruled on and
  applied.** Once the designer confirms, both can leave the knowledge sync.

---

## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND

*Re-derive these before quoting them in a brief; they move. DB re-derived every figure below.*

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
  Interpose is additive and correctly never refuses.
- **BLOOD FRENZY: TWO TERMS, ONE BAND.** `BattleUnit.FRENZY_MAX_STEPS` = **20** and
  `FRENZY_RAGE_PER_STEP` = **5**. Steps are summed then clamped.
- **FAITH: `battle.FAITH_RELEASE` = 3**, **`FAITH_PER_ABSORB` = 2**, **`FAITH_PER_GROUND_TURN` = 1.**
  `JUBILEE_MIN_FAITH` is **3**, which is the WHOLE bar. `ELEVATION_STACKS` is **2**, which is **67%
  of a release**. **An absorbed hit pays LESS than a release costs, and `check_da` asserts that
  RELATIONSHIP rather than the numbers.**
- **The ability draft is COMPLETE at 120 of 120** — `SPEC_DRAFT_POOLS` is **96** (12 specs × 8)
  and `CLASS_DRAFT_POOLS` is **24** (4 classes × 6).
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
- **Test suites: 44 `test_batch_*.gd` files**, spanning `ah` to `cp` (with gaps — they are NOT one
  per batch), plus `test_run_harness`, `test_runes` and `test_rune_battle`. **They live at the
  repo ROOT, not in `scripts/`.**
- **`run_battery.sh` runs 45 suites and MISSES ONE: `test_batch_cp` is not in its `SUITES`
  array.** Its `GATES` array is **fourteen**. **There are 19 `check_*.gd` files, so five gates are
  not in the battery** (`check_ck_width`, `check_cu`, `check_cv`, `check_ct_map`,
  `check_map_screen`). **`gate_fixture.gd` is NOT a gate and is deliberately not named `check_*`**
  — `test_batch_cd` and `check_da` both glob `check_*`/`test_*`, and a `check_`-prefixed helper
  would have joined the gate census as a nineteenth-and-a-half gate.
- **`run_battery.sh`'s check-count grep is GENERAL and must stay that way.** It matches three
  shapes because **45 suites print at least five between them**. The `grep -E "checks,"` in its
  header is a comment recording a scar CP already fixed — **it is not live code, and narrowing the
  matcher would re-open BQ's scar and CS's.**
- **The master.html stamp gate is duplicated across 14 suites** (ah, bb, bn, bo, bp, bq, br, bs,
  bt, bu, bv, bw, bx, ce), all on the self-comparing pattern — no bump is owed on a re-stamp.
- **Run harness gate counts: 22 / 165 / 8.**
- **master.html stamp: `Last updated: 2026-08-21 (Batch DB)`.**

### HOW LONG A FIGHT IS
- **Rounds to resolution, measured as TURNS PER LIVING PARTY MEMBER** (companions excluded from
  both halves), over four `--run 25` sims, **after DA** — **DB ran no sims and these are carried
  unchanged**:

  | party / rung | trash | elite | boss |
  |---|---|---|---|
  | 1 wanderer | 3.8 | 3.4 | 4.0 |
  | 2 warden | 4.4 | 3.6 | 5.3 |
  | 3 ruin | 4.4 | 4.4 | 4.4 |
  | 2 warden, Sharpshooter | 5.5 | 4.9 | 6.0 |

  **A fight is still three to six turns per hero.** **"Elite fights are the shortest of the three
  kinds at every rung" NO LONGER HOLDS AT RUNG 3**, where all three kinds read 4.4. It holds at
  rungs 1 and 2 and for the Sharpshooter party.
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
- **THE FAITH DECOMPOSITION AT RUNG 2, AFTER DA:** absorbs **3.90**, ground drip **8.01**, total
  **12.27** a battle, of which **2.21** lands on the Devout's own held meter. **Faith per absorb
  ACTUALLY LANDED is 1.56 against the 2 the constant promises.** Ground up on **49% of hero turns**
  (8.1 of 16.5). Devout healing a battle: **74 / 133 / 130 / 184** across the four arms.
- **TWO CONFOUNDERS ON EVERY FIGURE ABOVE, AND THE SECOND IS LARGER THAN IT LOOKS: the sim party is
  FULLY TALENTED (`rows=9 of 9`)**, and **it wears each tree's FIRST lane — 24 of 36 lanes have
  never been measured at all.** The sim prints the second one beside `builds=` since DB.
- **AND THE INSTRUMENT'S OWN CAVEAT: the `conviction` row samples the DEVOUT'S OWN meter, which
  HOLDS at the threshold and never releases by rule.** It has never measured release frequency —
  `releases/battle` is the row that does. **CY's two headline figures were both instrument faults.**

### The changelog
- **The live file starts at Batch CO and holds 14 entries** (CO → DB), **220.0 KB**. The 400 KB
  threshold is a long way off.
- **`DoD-archive/changelog-archive.html` holds 131 entries** (BP → CN) and is **1042.0 KB**.
- **Fourteen suites depend on a file that is not in version control** — bp, bq, br, bs, bt, bu,
  bv, bw, bx, cb, ce, bb, bn, bo. On a machine without `DoD-archive/` they FAIL LOUDLY, which is
  correct.

### Knowledge sync, re-measured at DB
*Measured over `.gd .md .html .json .py .sh`, excluding `assets/`, `.git/` and `.godot/`.
**Treat the file COUNT as method-dependent** — CW's filter counted 126 and CX's 108.*
- **117 files, 5.74 MB.** DB adds `gate_fixture.gd` and `docs/reports/DB.md`.
- Heaviest: `scripts/battle.gd` **~1152 KB**, `docs/design-notes.md` **~356 KB**,
  `docs/master.html` **~324 KB**, `scripts/classes.gd` **~276 KB**,
  `docs/changelog.html` **220 KB**, `scripts/talents.gd` **~184 KB**, `scripts/unit.gd` **~176 KB**,
  `CLAUDE.md` **168 KB**.
- **The 47 suite files total ~1,888 KB**, still the single largest block. **They cannot be
  archived (they must be in the repo to run) but they CAN be deselected from the sync.**
- **`scripts/` contains ZERO test suites.** All game code. **`gate_fixture.gd` is test-harness code
  and lives at the repo ROOT with the gates**, deliberately, to keep that true.

---

## KNOWN-BROKEN AND DELIBERATELY UNFIXED

### THE 72, MEASURED AT DB — 26 SUITES, ZERO THROWS

**This replaces every estimate this file has carried.** None of the 72 is a bug in the game; they
are assertions that CY, CZ, DA and CW deliberately made false. **Not one was repaired at DB**,
because §0 bound that batch to changing no behaviour and each needs a ruling on what it should ask
INSTEAD.

- **THE FAITH THRESHOLD IS THE DOMINANT CAUSE — 23 OF THE 72.** `FAITH_RELEASE` is **3**, so an
  ally can never stand at four or five stacks and every assertion written against that ladder
  reads `0.0%`: **`be` 3, `bf` 5, `bg` 5, `bh` 4, `bi` 6.**
  - **`test_batch_bi` IS THE CASE TO READ FIRST.** DA's revert **did** un-break the two checks it
    was credited with — `FAITH_PER_ABSORB` appears in no FAIL line. **`bi` is red on six OTHERS**,
    all threshold consequences (*"two absorbs are four Faith and do not release yet"* — four is
    above three, so it releases). **The revert paid for CZ's builders; nothing has paid for CZ's
    threshold.**
- **CY'S 52 MOVED DELAYS AND CZ'S SIX MORE ARE THE SECOND CAUSE** — `av` 1 (Intercession's 2.0
  initiative), `bd` 1 (reads 1.0 where 2.0 is asserted), and others among the mid-alphabet suites.
- **CW'S `CLAUDE.md` SPLIT IS THE THIRD**, and its eleven are still red exactly as CX found them:
  `bb` 2, `bn` 2, `bq` 1, `br` 2, `bx` 2, `ce` 9, **plus `cd`'s knock-on** — cd is the count-differ,
  so `FAIL: test_batch_bb.gd reports zero failures` is CW's damage arriving a second time through
  the one gate built to notice it.
- **AND TWO THAT PASS BY ACCIDENT, WHICH IS WORSE.** `contains("BATCH BN")` and
  `contains("BATCH BS")` still match — a passing mention inside two surviving rules, not a batch
  block. **A check that has stopped asking its question, with no red to announce it.**
- **`data/glossary.json` still reads "beast" once in prose** — "pay the four and not the beast",
  inside CV's own hero/ally entry. `test_batch_bx` §4 catches it.

### THE REST

- **`check_cm_live` reports 4 failures. THIS IS THE ONE RED THAT IS ON PURPOSE.** Identical on
  unmodified HEAD, recorded as owed in the gate itself. **DB confirmed the four are byte-identical
  before and after the consolidation.** It is the only thing that presses the defensive bar.
- **THERE ARE TWO FLAKY SUITES, NOT ONE. `test_batch_at` IS THE SECOND AND IT IS FAR WORSE THAN
  `bo`.** DB found it by running the battery three times: **`at` reads 3 failures or 4, and the
  fourth flaked in 2 of 5 dedicated runs (~40%)**. The flaking check is
  `Cannon at 8 stacks scales by the PASSIVE alone (1.27x, not ~2.5x)` — a damage-scaling
  assertion, and `test_batch_at.gd` calls `seed()` **zero** times. **Its check count is rock
  steady at 470**, so only the FAILURE count moves. **A count-diffing rule reads `at` 3 → 4 as a
  regression and it is not one** — this is the same fault as `bo`, three times more often, and it
  had never been recorded.
- **`test_batch_bo` has a flaky assertion — roughly 1 failure in 13 runs**, and **it flaked in
  DB's run**. Its check count is rock steady at 1025; the §5 NULL FIELD check requires
  `deep < shallow` and the damage carries a 0.9–1.1 variance roll, so both can land on the same
  integer. `test_batch_bo.gd` calls `seed()` zero times. **A count-diffing rule reads this as a
  regression and it is not one.**
- **THE SUITES THAT DRIFT IN THEIR CHECK COUNT — AND `an`'s BAND WAS WRONG UNTIL DB.**
  **`an` is 6047–6054**, not the 6052–6054 this file carried: five observations of unmodified code
  read **6047, 6051, 6052, 6054, 6048, 6054** across six, and *three fell below the old floor*. **`bk` is
  129–130** and holds. Both are always 0 failures, and both call `seed()` zero times.
- **TWO COUNTS MOVED FOR GOOD REASONS AND NOBODY WROTE THEM DOWN. BOTH ARE CORRECT AND ARE NOW
  THE BASELINE.**
  - **`al` is 559, not CS's 560.** Batch **CV** changed `PROSE_NUMBERS["wd_shieldwall"]` from
    `["4 turns", "5"]` to `["5 turns"]`, and the inner loop runs once per fragment.
  - **`bx` is 147, not CS's 142.** **CX re-pointed ELEVEN suites, not nine plus `ce`** — its own
    commit names `bp bq br bs bt bu bv bw bx cb ce`. This file previously omitted `bx`.
- **`check_map` is NOT a hang** — 99% CPU for ~5 minutes. The battery gives it a 600s bound.
- **`check_parse` does not cover the test suites.** It walks `res://scripts` and `res://scenes`
  only — **and never at all for `test_batch_cp`, which the battery does not run.** **It does not
  cover the GATES or `gate_fixture.gd` either**, but a broken fixture fails all seven gates loudly.
- **A GATE THAT EXITS 0 IS NOT A GATE THAT PASSED, AND DB REPRODUCED IT DELIBERATELY.** `check_da`
  hit it at DA. DB hit it again from a different direction: **a `--script` target whose base class
  does not resolve prints `Parse Error`, runs not one line, and exits 0.** Grep the stderr; never
  trust the tally and never trust `$?`. **`run_battery.sh`'s `throws=` column is the only thing
  standing between this fault and a green report.**
- **The `_hint_done` / `_skill_done` deadlock is real and is NOT currently biting.** Both
  skill-check orientation cards `await` a signal only a real click or key press emits. **A future
  headless modal will hit this again** — `_nobody_can_press()` is the one place the question is
  asked, and a Profile flag is not a bot guard.

### Last measurements

**DB RAN THE FULL BATTERY TWICE — ONCE BEFORE THE CONSOLIDATION AND ONCE AFTER — AND 43 OF 45
SUITES ARE BYTE-IDENTICAL ACROSS THE TWO.** The only two lines that differ are `an` and `bk`, the
two documented drifters, both at zero failures. **Every gate's failure count is identical.**

**Full-battery baseline, at DB. 45 suites, ZERO THROWS, 72 failures.** Counts, with failures marked:

```
ah 5625, ah_battle 65, ai 2217, aj 418, ak 528, al 559, an 6047–6054, ar 735 /1
as 396 /3, at 470 /3-or-4 (flake), au 336, av 324 /1, aw 350 /3, ax 345 /2, ay 484
az 519, ba 690, bb 177 /2, bc 91, bd 71 /1, be 34 /3, bf 78 /5, bg 47 /5
bh 233 /4, bi 91 /6, bj 67 /1, bk 129–130, bl 88, bm 1891, bn 81 /2
bo 1025 /1 (the known flake), bp 275, bq 742 /1, br 1450 /2, bs 266, bt 458 /1
bu 480 /5, bv 900 /2, bw 551 /3, bx 147 /2, cb 1184 /2, cd 86 /2, ce 1116 /9
runes 3121, rune_battle 97
```

**Gates, at DB — and four of them report a check count for the first time:**
`check_cm_live` **13 / 4** (the deliberate red), `check_co` **297 / 0**, `check_cs` **104 / 0**,
`check_ct` **113 / 0**, `check_cy` **2704 / 0**, `check_cz` **131 / 0**, `check_da` **33 / 0**
(30 before — §3's two census assertions and §1's `flags_are_inert` are the one deliberate movement).
`check_parse` 0 failures (stderr grepped for `Parse Error`, never the tally), `check_flow`,
`check_map`, `check_cl_resolver`, `check_cl_width`, `check_cm`, `check_cn` all 0 failures but
**still report no check count**. `check_ct_map` **83 / 0**. **Run harness 22 / 165 / 8, all PASS,
throws=0.**

**NO SIM HAS BEEN RUN SINCE DA.** DB is a consolidation and a test batch; every ramp and depth
figure above is DA's, carried unchanged and re-derived from `docs/reports/DA.md`.
