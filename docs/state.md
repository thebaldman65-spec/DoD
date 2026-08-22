# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

*Last rewritten: 2026-08-21 (Batch DD).*

---

## WHERE THE PROJECT IS

- **Last batch: DD** — the suite consolidation, and it was ten times DB's. **`_spawn` stood in 37
  suites and `_kill` in 14; both are authored once now, in `suite_fixture.gd`** — **1,128 lines
  deleted against 391 added across those 37 suites**, **not one of the 389 call sites moved**, and **no exemption was
  needed**: all 22 differences between the copies are named arguments. It also **widened
  `test_batch_cd` from five suites to forty-five** (it had been watching a ninth of the project) and
  **seeded `test_batch_at`**, which turned out to be two flaky checks rather than the one on record.
  No save version moves (still v10).
- **Next letter: DE, and the queue names it: THE REMAINING RED ASSERTIONS.** The two-letter stamp
  gate in fourteen suites reads `substr(_code_at + 7, 2)` out of `(Batch XX)` and compares
  lexically — `DE` sorts after `DD`, so it still works. **A THREE-letter code would break all
  fourteen.**
- **Phase.** The ability draft is COMPLETE (120 of 120) and all twelve talent trees are
  purpose-authored. Recent batches are correction and consolidation: the skill-check rework
  (CM/CN/CS), the fold rulings (CQ/CR), the pouch (CT), the talent audit (CU/CV), the documentation
  split (CW), the archive cut (CX), the tempo rule (CY), CZ's two ramp repairs, DA's correction of
  one of them, DB's gate consolidation, DC's threshold repairs and DD's suite consolidation.
- **THE CONSOLIDATION QUEUE IS EMPTY AND THE RULING QUEUE IS NOT.** DB and DD between them paid the
  whole `_spawn` debt. **What remains is 46 failing assertions across 19 suites, and every one needs
  a ruling on what it should ask INSTEAD** — which is why four batches have left them standing.
  **That is the next batch, and the design decisions are behind it.**

---

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION

**DD closed two items (the suite consolidation and `at`'s flake) and added four small ones.**

### THE ONE THAT IS THE QUEUE

- **THE STALE-ASSERTION PASS — 46 FAILURES ACROSS 19 SUITES.** See KNOWN-BROKEN below for the
  breakdown. **Unlike the 23 DC took, each of these needs a ruling on what the check should ask
  INSTEAD.** DD moved the same files and deliberately repaired none of them. **`test_batch_cd` now
  records where every one of them is**, so a repair that moves a count says so on the next run.

### Small, and named by DD

- **THE BATTERY IS ~50 MINUTES NOW, NOT ~30, AND WHETHER THAT PRICE BELONGS INSIDE IT IS A
  DECISION.** `test_batch_cd` §1 runs 45 suites — **it runs the battery inside the battery** — which
  is about 22 minutes on top of a 29.6-minute run. `run_battery.sh` carries
  `TMO[test_batch_cd]=2400` so the watchdog does not kill it mid-sweep. The alternatives were
  considered and rejected *here*, not ruled out: running `cd` outside the battery hides it, and
  having it read the battery's logs couples the differ to a run it did not supervise. **A parallel
  sweep was rejected on measurement grounds** — several suites time real `SceneTreeTimer` waits, so
  loading the machine is how a count-differ acquires its own flakes.
- **`_run`'S SAVE-BACKUP PREAMBLE IS THE NEXT COPIED HELPER, AND IT IS 38 SUITES WIDE.** `_run`
  itself is 39 bodies in 39 suites and is correctly 39 — it is each suite's own driver. **But 38 of
  the 39 open with the same `_had_save` backup block and 37 swap `Profile.save_path` to a per-suite
  file and swap it back.** Same shape as `_spawn`, one layer in.
- **TEN HAND-BUILT BATTLE BOARDS REMAIN, IN SIX FILES** — `al` (2), `an`, `ax`, `bl`,
  `test_rune_battle` (3), `test_run_harness` (2). **None is a copied helper**: they are bespoke
  boards inside single checks, and two of those files have no `_spawn` at all. `check_da` §3 carries
  them as a **named ratchet** (by file AND by count), so a new copy cannot hide among them.
- **`bo`'s FLAKE IS STILL OPEN**, at roughly 1 failure in 13 runs. Its repair is the same shape as
  `at`'s — seed both blows of the compared pair — and it was left alone deliberately, because one
  flake at a time is how the effect stays attributable.

### Carried, and still awaiting a ruling

- **THE ARITHMETIC PROBES IN `bg`, `bh` AND `bi` STILL SIT ABOVE THE REACHABLE BAND.**
  `STACKS := 4` is a **direct-write probe depth** now, not a carry ceiling — those checks write
  `faith_stacks`/`faith_peak` onto the unit, bypass `_gain_faith`'s clamp, and measure a per-stack
  rate against **fixed percentage-point tolerances** (`< 2.0`, `< 2.5`, `> 2.5`). **Halving the
  depth halves the effect size against tolerances that do not move with it**, across roughly
  thirty currently-green live measurements. **Moving them down is a re-derivation of tolerances,
  which is a ruling, not a repair.** The comment at each constant now says which of the two things
  it is.

### Carried, with measurements attached

- **THE FRENZY RATE IS `FRENZY_RAGE_PER_STEP` = 5** and is a rule rather than a constant (five Rage
  is 5% of a full bar, the health term's own rate). Peak Frenzy 13.4 → 20.9 of 40 at rung 2 under
  CZ, and **DA re-measured it unchanged at 20.7**. **Reckless Abandon dumping a full bar books all
  twenty steps at once** — named, not discovered later.
- **THE FAITH LANE IS SETTLED AND THE SUITES AGREE WITH IT.** Numbers in `docs/reports/DA.md`:
  threshold 3, builders 2 and 1, releases **1.93 / 2.60 / 2.48 / 3.62** across the four arms.
  **Elevation (2 of 3) and Blessing of the Faithful (3 of 3) were reported at both CZ and DA and
  deliberately changed at neither.** If either is revisited, Elevation is the one with a history of
  being moved by accident (CG set 2, CN's fold pushed 3, CQ reverted it).
  - **THE DERIVED BAND IS WHAT THE FIVE FAITH SUITES ASSERT ON SINCE DC:** the deepest an ally can
    **HOLD is 2** (`FAITH_RELEASE - 1`); **Communion's eligible band is 1–2** (the walk skips
    `faith_stacks >= FAITH_RELEASE`) and its roll `0.01 * 15 * stacks` **peaks at 30%**, measured
    at **29.8% over 1200 trials**; **two absorbs are a release.** Each of the five suites carries
    `const RELEASE := 3` and `const HELD_MAX := RELEASE - 1` **once**, so the next threshold ruling
    costs one line a suite.
  - **AND WHEN A BATCH REVERTS A CONSTANT, SWEEP THE PROSE FOR THE NUMBER IT REVERTED.** DA's
    revert left "3 a hit" standing in the Devout's `passive_desc` and the `faith` status chip for
    four batches against a constant that pays 2. Both were fixed at DC.

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
  thing a count-diffing rule cannot compare**, and `test_batch_cd`'s table cannot take them for the
  same reason.
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

*Re-derive these before quoting them in a brief; they move. DD re-derived every figure below, and
found that one of them — the `_spawn` census — had been wrong in four documents at once.*

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

### THE TEST TREE, AS OF DD

- **47 `test_*.gd` files**: 44 `test_batch_*` spanning `ah` to `cp` (with gaps — they are NOT one
  per batch), plus `test_run_harness`, `test_runes` and `test_rune_battle`. **They live at the repo
  ROOT, not in `scripts/`.**
- **`_spawn` IS AUTHORED ONCE, IN `suite_fixture.gd`, AND 37 SUITES GO THROUGH IT.** `_kill` too, in
  14. Each suite keeps its OWN `_spawn` SIGNATURE and delegates, so **all 389 call sites are
  untouched**. **The census that stood in four documents was wrong**: the 37 copies were **36 raw
  bodies, 33 with comments stripped** — never 34 — and `_kill`'s "byte-identical in 14" was four raw
  bodies that normalise to one.
- **`_run` IS 39 BODIES IN 39 SUITES AND THAT IS CORRECT** — it is each suite's own driver. **The
  copied helper is inside it: 38 open with the same save-backup preamble, 37 swap
  `Profile.save_path`.**
- **`run_battery.sh` runs 45 suites and MISSES ONE: `test_batch_cp` is not in its `SUITES`
  array** — but **`test_batch_cd` watches it now**, so it is no longer un-run. Its first recorded
  measurement is **697 checks / 0 failures**. The battery's `GATES` array is **fourteen**.
  **There are 19 `check_*.gd` files, so five are not in `GATES`** (`check_ck_width`, `check_cu`,
  `check_cv`, `check_ct_map`, `check_map_screen`) — **`check_ct_map` and `check_map_screen` do still
  run, in the SCENE RUNS section**, so the three that run nowhere are `check_ck_width`, `check_cu`
  and `check_cv`.
- **`gate_fixture.gd` AND `suite_fixture.gd` ARE NOT GATES AND ARE DELIBERATELY NOT NAMED
  `check_*`/`test_*`** — `test_batch_cd` and `check_da` both glob those prefixes, and a
  `check_`-prefixed helper would have joined the gate census.
- **`test_batch_cd`'s TABLE IS 45 ROWS AND THEY ARE NOT THE BATTERY'S 45**: the battery's suites
  minus `cd` itself (a suite that drives itself does not terminate) plus `test_batch_cp`. Each row
  is `[checks_lo, checks_hi, fails_lo, fails_hi]`. **It costs ~22 minutes — it runs the battery
  inside the battery** — and `run_battery.sh` carries `TMO[test_batch_cd]=2400` so the watchdog
  cannot kill it mid-sweep.
- **`run_battery.sh`'s check-count grep is GENERAL and must stay that way.** It matches three
  shapes because **45 suites print at least five between them**. `test_batch_cd` carries the same
  matcher, and the same per-suite FLAGS table (`test_batch_bl` under-runs silently without
  `--fixed-fps 12`). The `grep -E "checks,"` in the battery's header is a comment recording a scar
  CP already fixed — **it is not live code, and narrowing the matcher would re-open BQ's scar and
  CS's.**
- **The master.html stamp gate is duplicated across 14 suites** (ah, bb, bn, bo, bp, bq, br, bs,
  bt, bu, bv, bw, bx, ce), all on the self-comparing pattern — no bump is owed on a re-stamp.
- **Run harness gate counts: 22 / 165 / 8.**
- **master.html stamp: `Last updated: 2026-08-21 (Batch DD)`.**

### HOW LONG A FIGHT IS
- **Rounds to resolution, measured as TURNS PER LIVING PARTY MEMBER** (companions excluded from
  both halves), over four `--run 25` sims, **after DA** — **DB, DC and DD ran no sim and these are
  carried unchanged**:

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
- **The live file starts at Batch CO and holds 16 entries** (CO → DD), **240 KiB**. The 400 KB
  threshold is a long way off.
- **`DoD-archive/changelog-archive.html` holds 131 entries** (BP → CN) and is **1042 KiB**.
- **Fourteen suites depend on a file that is not in version control** — bp, bq, br, bs, bt, bu,
  bv, bw, bx, cb, ce, bb, bn, bo. On a machine without `DoD-archive/` they FAIL LOUDLY, which is
  correct.

### Knowledge sync, re-measured at DD
*Measured over `.gd .md .html .json .py .sh`, excluding `assets/`, `.git/` and `.godot/`.
**Treat the file COUNT as method-dependent** — CW's filter counted 126 and CX's 108.
**ALL SIZES BELOW ARE KiB (1024 bytes)**, so a later batch can compare like with like.*
- **120 files, 5.54 MiB.** DD adds `suite_fixture.gd` and `docs/reports/DD.md`.
- Heaviest: `scripts/battle.gd` **1149 KiB**, `docs/master.html` **320 KiB**,
  `docs/design-notes.md` **306 KiB**, `scripts/classes.gd` **274 KiB**,
  `docs/changelog.html` **240 KiB**, `scripts/talents.gd` **181 KiB**, `scripts/unit.gd` **174 KiB**,
  `CLAUDE.md` **174 KiB**.
- **The 47 suite files total 1794 KiB** (1807 before DD; the consolidation took ~13 KiB out of them
  and `suite_fixture.gd`'s 9 KiB sits outside that block). Still the single largest block. **They
  cannot be archived (they must be in the repo to run) but they CAN be deselected from the sync.**
- **`scripts/` contains ZERO test suites.** All game code. **`gate_fixture.gd` and
  `suite_fixture.gd` are test-harness code and live at the repo ROOT with the gates**, deliberately,
  to keep that true.

---

## KNOWN-BROKEN AND DELIBERATELY UNFIXED

### THE 46 THAT REMAIN — MEASURED AT DD, ZERO THROWS

**DB measured 72 across 26 suites. DC repaired the 23 that needed no ruling. DD repaired none of
them** — it is a consolidation batch, and every one of these needs a ruling on what the check should
ask INSTEAD.

**DC's total was 49 across 21. DD's is 46 across 19, and NOTHING WAS REPAIRED TO GET THERE:** the
three that left are **`cd`'s own two** — which were `bb` and `bj` being reported red a second time,
and are now recorded baselines rather than failures — and **`bo`'s flake**, which simply did not
appear in this run. **On a run where `bo` flakes the total reads 47 across 20 and that is not a
regression.**

- **CY'S 52 MOVED DELAYS AND CZ'S SIX MORE ARE THE LARGEST CAUSE** — `av` 1 (Intercession's 2.0
  initiative), `bd` 1 (reads 1.0 where 2.0 is asserted), and others among the mid-alphabet suites.
- **CW'S `CLAUDE.md` SPLIT IS THE SECOND**, and its eleven are still red exactly as CX found them:
  `bb` 2, `bn` 2, `bq` 1, `br` 2, `bx` 2, `ce` 9. **`at`'s three are the same family.**
- **`cd` NO LONGER FLAGS `bb` AND `bj` AS FAILURES — IT RECORDS THEM.** Its table holds every
  suite's expected failure count now, so a red suite at its recorded count is not news and a red
  suite that MOVES is. That is the whole point of the widening: **a failure count moving inside an
  already-red suite is invisible in an aggregate**, which is how `test_batch_bi` stayed wrong for
  four batches.
- **AND TWO THAT PASS BY ACCIDENT, WHICH IS WORSE.** `test_batch_bn.gd:505`
  `contains("BATCH BN")` and `test_batch_bs.gd:409` `contains("BATCH BS")` still match — a passing
  mention inside two surviving rules, not a batch block. **A check that has stopped asking its
  question, with no red to announce it.**
- **`data/glossary.json` still reads "beast" once in prose** — "pay the four and not the beast",
  inside CV's own hero/ally entry. `test_batch_bx` §4 catches it.

### THE REST

- **`check_cm_live` reports 4 failures. THIS IS THE ONE RED THAT IS ON PURPOSE.** Identical on
  unmodified HEAD, recorded as owed in the gate itself. **DB confirmed the four are byte-identical
  before and after the gate consolidation; DC and DD confirm them again.** It is the only thing that
  presses the defensive bar.
- **`test_batch_at` IS SEEDED AND PINNED AS OF DD — 470 checks / 3 failures over five consecutive
  runs — AND IT WAS TWO FLAKY CHECKS, NOT ONE.** The recorded one (`Cannon at 8 stacks scales by the
  PASSIVE alone`) and one nobody had recorded (`…by roughly the table's +59%`). **Both were ratios
  with margins, which is what `CLAUDE.md` recommends** — and the margin was narrower than the noise:
  a blow rolls `randf_range(0.9, 1.1)`, so a RATIO of two carries up to 22% against bands of ±20%
  and ±7%. **The fix is to seed both blows of each pair to the same value, not to widen the band** —
  the band IS the question. **§2's answer: it settles at 3, so the fourth failure was a flake and
  not a finding.**
- **`test_batch_bo` STILL HAS ITS FLAKY ASSERTION — roughly 1 failure in 13 runs.** Its check count
  is rock steady at 1025; the §5 NULL FIELD check requires `deep < shallow` and the damage carries a
  0.9–1.1 variance roll, so both can land on the same integer. `test_batch_bo.gd` calls `seed()`
  zero times. **`test_batch_cd` carries its FAILURE count as a band (0–1) for exactly this reason.**
- **THE SUITES THAT DRIFT IN THEIR CHECK COUNT, AND THE OBSERVATION COUNT EACH BAND RESTS ON.**
  **`an` is 6047–6063 on TEN observations** — DB's six (6047, 6051, 6052, 6054, 6048, 6054), DC's
  6053, DD's two batteries at 6053, and **DD's first widened `cd` sweep at 6055, which is ONE ABOVE
  the 6047–6054 band written from the other nine.** That band was exceeded inside the batch that
  wrote it. **THE RULE NOW, AND IT IS ASYMMETRIC ON PURPOSE: floor = the lowest observation, ceiling
  = the highest PLUS the observed spread.** The floor is the half that catches a real fault — a
  section of `an` that stopped running costs hundreds of checks, not five — so it stays tight and
  the ceiling takes the headroom.
  **`bk` is 129–130 on FIVE** — DB's 129 and 130, DC's 129, and DD's two batteries, which read
  **130 and then 129**. **It is NOT widened, because it has not been exceeded**: headroom goes where
  a reading demands it, so every number in `cd`'s table stays traceable to a run.
  - **AND ONE OBSERVATION ABOUT `an` THAT FOUR READINGS CANNOT YET SETTLE: both of DD's batteries
    read 6053 and both of `cd`'s sweeps read 6055.** `run_battery.sh` launches a suite from the
    shell; `cd` launches it with `OS.execute` from inside a Godot process, which hands the child a
    different environment. **Whether the two-check gap is draft randomness or a launcher difference
    is not distinguishable on four readings** — worth one deliberate experiment before anyone treats
    `an`'s spread as pure noise.
  **A band written from too few readings reads a normal run as a regression, which is the same
  failure as a wrong count in the opposite direction.** Both suites are always 0 failures, and both
  call `seed()` zero times.
- **`check_map` is NOT a hang** — 99% CPU for ~5 minutes. The battery gives it a 600s bound.
- **`check_parse` does not cover the test suites.** It walks `res://scripts` and `res://scenes`
  only. **It does not cover the GATES, `gate_fixture.gd` or `suite_fixture.gd` either** — but a
  broken suite fixture fails 37 suites loudly, and DD parse-checked every suite and the fixture with
  `--check-only`, **with a negative control proving the check bites.**
- **A GATE THAT EXITS 0 IS NOT A GATE THAT PASSED.** `check_da` hit it at DA; DB reproduced it
  deliberately: **a `--script` target whose base class does not resolve prints `Parse Error`, runs
  not one line, and exits 0.** Grep the stderr; never trust the tally and never trust `$?`.
  **`run_battery.sh`'s `throws=` column is the only thing standing between this fault and a green
  report**, and `test_batch_cd` counts both markers now, joined at runtime so its own failure
  messages cannot make the battery accuse it.
- **The `_hint_done` / `_skill_done` deadlock is real and is NOT currently biting.** Both
  skill-check orientation cards `await` a signal only a real click or key press emits. **A future
  headless modal will hit this again** — `_nobody_can_press()` is the one place the question is
  asked, and a Profile flag is not a bot guard.

### Last measurements

**TWO FULL BATTERIES AT DD — one on unmodified HEAD before anything was touched, one after.**
**THE BEFORE-BATTERY REPRODUCED DC'S TABLE EXACTLY** (45 suites, zero throws, 49 failures across 21,
`an` 6053 and `bk` 130 inside their bands, every gate identical), so the two runs compare like with
like on this machine rather than only against a document.

**ACROSS 45 SUITES AND 14 GATES, EXACTLY THREE LINES DIFFER, AND ALL THREE ARE DELIBERATE:**

| line | before | after | why |
|---|---|---|---|
| `bk` | 130 | **129** | inside its recorded band, 0 failures — not a regression |
| `test_batch_cd` | 86 / 2 | **207 / 0** | the table went from 5 rows to 45 |
| `check_da` | 33 / 0 | **36 / 0** | §3's three suite-census assertions |

**Everything else is byte-identical** — 43 of 45 suite lines, 13 of 14 gate lines,
`check_cm_live`'s four deliberate reds, the harness at 22 / 165 / 8, `check_ct_map` at 83 / 0, and
**`throws=0` everywhere in both runs**, grepped from the stream and never read off a tally.
**37 suites had their `_spawn` replaced and not one check count moved.**

**THE FAILURE TOTAL IS 47 ACROSS 20 SUITES** (46 across 19 on a run where `bo` does not flake),
**down from DC's 49 across 21 with nothing repaired**: the two that left are `cd`'s own, which were
`bb` and `bj` reported red a second time and are recorded baselines now.

Counts, with failures marked:

```
ah 5625, ah_battle 65, ai 2217, aj 418, ak 528, al 559, an 6047–6063, ar 735 /1, as 396 /3
at 470 /3 (SEEDED AT DD — pinned over five runs, no longer a flake), au 336, av 324 /1
aw 350 /3, ax 345 /2, ay 484, az 519, ba 690, bb 177 /2, bc 91, bd 71 /1, be 34, bf 78
bg 47, bh 233, bi 91, bj 67 /1, bk 129–130, bl 88, bm 1891, bn 81 /2
bo 1025 /0–1 (the known flake), bp 275, bq 742 /1, br 1450 /2, bs 266, bt 458 /1, bu 480 /5
bv 900 /2, bw 551 /3, bx 147 /2, cb 1184 /2, cd 207, ce 1116 /9, runes 3121, rune_battle 97
cp 697 — NOT in the battery's SUITES array; `test_batch_cd` is the only thing that runs it
```

**Gates, at DD — every one identical to DC except `check_da`:**
`check_cm_live` **13 / 4** (the deliberate red), `check_co` **297 / 0**, `check_cs` **104 / 0**,
`check_ct` **113 / 0**, `check_cy` **2704 / 0**, `check_cz` **131 / 0**, **`check_da` 36 / 0**.
`check_parse` 0 failures (stderr grepped for `Parse Error`, never the tally), `check_flow`,
`check_map`, `check_cl_resolver`, `check_cl_width`, `check_cm`, `check_cn` all 0 failures but
**still report no check count**. `check_ct_map` **83 / 0**. **Run harness 22 / 165 / 8, all PASS,
throws=0.**

**`test_batch_cd`'s FINAL SWEEP, run last of all against the complete tree: 207 checks / 0
failures — 45 suites swept, 0 off their recorded line, zero throw markers.** It is the batch's
acceptance test and it covers the documentation edits too, because 39 suites read `CLAUDE.md`,
`docs/master.html` or `docs/changelog.html`.

**WALL CLOCK: the battery was 29.6 minutes before DD and is about 50 after**, because
`test_batch_cd` §1 now runs 45 suites inside it (the suite section alone is 22.2 minutes). See the
queue above — whether that price belongs inside every battery is a decision.

**NO SIM HAS BEEN RUN SINCE DA.** DB, DC and DD are all test batches; every ramp and depth figure
above is DA's, carried unchanged and re-derived from `docs/reports/DA.md`.
