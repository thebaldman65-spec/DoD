# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

*Last rewritten: 2026-08-22 (Batch DE).*

---

## WHERE THE PROJECT IS

- **Last batch: DE** — the count differ moved out of a suite and into the run. DD had widened
  `test_batch_cd` to forty-five suites, and because §1 answered its question by **spawning
  forty-five child Godots** the battery went **29.6 minutes → 49.9**. **The differ is
  `check_de.gd` now**: a post-pass over the logs `run_battery.sh` already writes, which **spawns
  nothing**, so the nesting is **structurally impossible rather than merely avoided**. The
  baselines are **`baselines.json`** — one machine-readable file, and **THE ONLY PLACE THE COUNTS
  LIVE**; this file points at it and does not restate it. **The FAILURE count is baselined per
  target now, which is worth more than the check-count diffing that prompted the batch.** The
  battery is back to **29.0 minutes**. No save version moves (still v10).
- **Next letter: DF, and the queue still names it: THE REMAINING RED ASSERTIONS.** The two-letter
  stamp gate in fourteen suites reads `substr(_code_at + 7, 2)` out of `(Batch XX)` and compares
  lexically — `DF` sorts after `DE`, so it still works. **A THREE-letter code would break all
  fourteen.**
- **Phase.** The ability draft is COMPLETE (120 of 120) and all twelve talent trees are
  purpose-authored. Recent batches are correction and consolidation: the skill-check rework
  (CM/CN/CS), the fold rulings (CQ/CR), the pouch (CT), the talent audit (CU/CV), the documentation
  split (CW), the archive cut (CX), the tempo rule (CY), CZ's two ramp repairs, DA's correction of
  one of them, DB's gate consolidation, DC's threshold repairs, DD's suite consolidation and DE's
  move of the count differ into the runner.
- **THE CONSOLIDATION QUEUE IS EMPTY AND THE RULING QUEUE IS NOT.** DB and DD between them paid the
  whole `_spawn` debt; DE paid the instrument's own. **What remains is 47 failing assertions across
  20 suites** — **48 across 20 when `bo`'s flake fires, 48 across 21 when `test_rune_battle`'s
  does, 49 across 21 when both do** — **and every one needs a ruling on what it
  should ask INSTEAD** — which is why five
  batches have left them standing. **That is the next batch, and the design decisions are behind
  it.** **DE makes them safer to leave than they have ever been**: every one is now baselined by
  COUNT, so a 47th arriving inside an already-red suite is reported instead of absorbed.

---

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION

**DE closed the largest small item — the ~50-minute battery — and added none.**

### THE ONE THAT IS THE QUEUE

- **THE STALE-ASSERTION PASS — 47 FAILURES ACROSS 20 SUITES.** See KNOWN-BROKEN below for the
  breakdown. **Unlike the 23 DC took, each of these needs a ruling on what the check should ask
  INSTEAD.** DD and DE both moved the same files and deliberately repaired none of them.
  **`baselines.json` now records where every one of them is, per target**, so a repair that moves a
  count says so on the next run — and so does a NEW failure arriving underneath an existing one,
  which is the case that hid `test_batch_bi` for four batches.

### CLOSED AT DE

- **~~THE BATTERY IS ~50 MINUTES~~ — CLOSED.** DD left this as an open decision: `test_batch_cd`
  §1 ran 45 suites inside the battery, about 22 minutes on top of a 29.6-minute run. **DD's
  write-up rejected the log-reading alternative on the grounds that it "couples the differ to a run
  it did not supervise". That objection did not survive being looked at** — the runner ALREADY
  spawns every target and ALREADY captures every stream including stderr, so the differ was
  re-running the tree in order to look at it. **The one real hazard in reading logs is a STALE log
  from a previous run, because `run_battery.sh` does not clear `$OUT`; the manifest (`$OUT/.ran`)
  closes it.** Battery back to 29.0 minutes.

### Small, and still owed
- **`_run`'S SAVE-BACKUP PREAMBLE IS THE NEXT COPIED HELPER, AND IT IS 38 SUITES WIDE.** `_run`
  itself is 39 bodies in 39 suites and is correctly 39 — it is each suite's own driver. **But 38 of
  the 39 open with the same `_had_save` backup block and 37 swap `Profile.save_path` to a per-suite
  file and swap it back.** Same shape as `_spawn`, one layer in.
- **TEN HAND-BUILT BATTLE BOARDS REMAIN, IN SIX FILES** — `al` (2), `an`, `ax`, `bl`,
  `test_rune_battle` (3), `test_run_harness` (2). **None is a copied helper**: they are bespoke
  boards inside single checks, and two of those files have no `_spawn` at all. `check_da` §3 carries
  them as a **named ratchet** (by file AND by count), so a new copy cannot hide among them.
- **`test_rune_battle` IS A NEWLY FOUND FLAKE — `check_de` CAUGHT IT ON ITS FIRST ACCEPTANCE
  RUN.** 97 checks, rock steady; only the failure moves. The pyromancer `rune_resist_pierce` check
  drives a live battle against a fire-resistant warband and needs the proc to LAND; the suite calls
  `seed()` zero times. **2 red in 15 readings — clean in DE's first two batteries, RED in the
  acceptance battery, RED on the next ad-hoc run, then ten consecutive clean runs on an idle
  machine. BOTH REDS LANDED UNDER LOAD**, which is a hypothesis worth one experiment and not a
  finding: the assertion's own comment says its snapshot "is the one that cannot race". Band
  `0–1` in `baselines.json`. **Repair is the `at`/`bo` shape and is deliberately left** — one flake
  at a time.
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

- **EIGHT TARGETS STILL CANNOT REPORT A CHECK COUNT, AND IT IS A RATCHET NOW RATHER THAN A
  SENTENCE.** `check_parse`, `check_flow`, `check_map`, `check_cl_resolver`, `check_cl_width`,
  `check_cm`, `check_cn` and `check_map_screen` read `checks=?`. **Two of them —
  `check_cl_width` and `check_map_screen` — report `fails=?` as well**, so the battery cannot see
  whether either passed at all. **A count that reads `?` is the one thing a count-diffing rule
  cannot compare.** DE records that state as `null` in `baselines.json` and asserts the SET in both
  directions: **a target that LOSES its count is an error, and one that GAINS a count is a notice
  telling the next batch to record the number.** `check_map_screen`'s whole verdict is the single
  line `check_map_screen: OK`, so that line is pinned as its `expect` field — otherwise nothing at
  all stood between it and a silent pass.
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

### THE TEST TREE, AS OF DE

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
- **`run_battery.sh` RUNS 46 SUITES NOW AND MISSES NONE.** `test_batch_cp` was in no array at all
  and only `test_batch_cd` ran it privately; **DE put it in `SUITES`**, which is why `cd`'s table
  had 45 rows against the battery's 45 and they were not the same 45. The `GATES` array is still
  **fourteen**. **There are 20 `check_*.gd` files** (DE adds `check_de.gd`), so **six are not in
  `GATES`** — `check_ck_width`, `check_cu`, `check_cv`, `check_ct_map`, `check_map_screen` and
  `check_de`. **`check_ct_map` and `check_map_screen` run in the SCENE RUNS section and `check_de`
  runs in its own post-pass section AFTER them**, so the three that run nowhere are still
  `check_ck_width`, `check_cu` and `check_cv`.
- **THE BATTERY WRITES A MANIFEST, `$OUT/.ran`, AND THE DIFFER TRUSTS IT RATHER THAN THE DIRECTORY
  LISTING.** `run_battery.sh` does NOT clear `$OUT` between runs, so a target that failed to launch
  would otherwise be blessed by its PREVIOUS run's log — **the one fault a count-differ must never
  commit, and a hazard that only exists because the differ reads logs now.** A name is appended
  immediately before its target is launched and `run_one` truncates the log at spawn, so **a log
  named in the manifest is always this run's**. A subset invocation (`./run_battery.sh bo bp`)
  writes a short manifest and **the differ reports the rest as DID NOT RUN instead of certifying a
  clean tree.**
- **`gate_fixture.gd` AND `suite_fixture.gd` ARE NOT GATES AND ARE DELIBERATELY NOT NAMED
  `check_*`/`test_*`** — `test_batch_cd` and `check_da` both glob those prefixes, and a
  `check_`-prefixed helper would have joined the gate census.
- **THE BASELINE TABLE IS `baselines.json` AND IT IS 65 ROWS: 46 suites, 14 gates, 2 scene runs
  and 3 harness gates.** **DO NOT RESTATE ITS NUMBERS HERE OR IN `CLAUDE.md`** — a second copy of a
  number is this project's oldest recurring defect, and the file that catches drift must not seed
  it. Per target it carries the expected check count (a number or a band), **the expected FAILURE
  count**, **how many readings the row rests on**, any known flake and its rate, and an optional
  verdict string. **Nineteen of those 65 targets were outside `test_batch_cd`'s old table
  entirely** — every gate, the harness, both scene runs, and `test_batch_cd` itself, which the old
  design could not watch because a suite that drives itself does not terminate.
- **`test_batch_cd` IS 71 CHECKS NOW, DOWN FROM 207**, and it is the hygiene suite it was before DD
  widened it: the dead-symbol sweep, the draft-target sweep and the pool measurement. **Those three
  stay a suite because the runner genuinely cannot do them** — they resolve `Classes`, walk the
  twelve spec pools and read prose in four documents. **Only the differ moved.**
- **`check_de.gd` IS THE DIFFER AND IT SPAWNS NOTHING.** It runs last, reads the logs and the
  baseline file, and reports. **It is re-runnable in seconds over a log directory that already
  exists**, which is what makes a baseline table safe to correct — re-checking the old differ's
  answer cost 22 minutes.
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

### THE 47 THAT REMAIN — MEASURED TWICE AT DE, ZERO THROWS

**DB measured 72 across 26 suites. DC repaired the 23 that needed no ruling. DD repaired none of
them** — it is a consolidation batch, and every one of these needs a ruling on what the check should
ask INSTEAD.

**DC's total was 49 across 21. DD PUBLISHED 46 ACROSS 19 AND THAT FIGURE IS WRONG BY ONE SUITE AND
ONE FAILURE. THE TOTAL IS 47 ACROSS 20**, measured twice at DE — once on unmodified HEAD before
anything was touched.

- **THE TWO THAT LEFT AT DD ARE REAL:** `cd`'s own two, which were `bb` and `bj` being reported red
  a second time and are recorded baselines now rather than failures.
- **THE THIRD WAS NOT.** DD recorded `bo` dropping to 0 because "`bo`'s flake simply did not appear
  in this run". **`bo` IS NOT AT 0 AND WAS NOT AT DD EITHER.** It carries a DETERMINISTIC red: §6
  asserts `CLAUDE.md` contains the literal `TRANCHES 2 AND 3`, and **CW's split removed that
  string** — it is absent from `CLAUDE.md` at DD's own commit, checked. So `bo` belongs to CW's
  family (`bb`, `bn`, `bq`, `br`, `bx`, `ce`) and **its flake is a SECOND failure on top, which
  would read 2.**
- **THE BAND `0–1` ADMITTED THE OBSERVED VALUE, SO NOTHING EVER CONTRADICTED THE LABEL.** That is
  §3's thesis exactly — a red check does not announce a second problem underneath it — **found by
  §3's own instrument on its first run.** `baselines.json` carries `bo` at **1–2** now, with the
  floor observed twice and the ceiling named as the flake's contribution.

- **CY'S 52 MOVED DELAYS AND CZ'S SIX MORE ARE THE LARGEST CAUSE** — `av` 1 (Intercession's 2.0
  initiative), `bd` 1 (reads 1.0 where 2.0 is asserted), and others among the mid-alphabet suites.
- **CW'S `CLAUDE.md` SPLIT IS THE SECOND**, and its eleven are still red exactly as CX found them:
  `bb` 2, `bn` 2, `bq` 1, `br` 2, `bx` 2, `ce` 9. **`at`'s three are the same family.**
- **THE FAILURE COUNTS ARE BASELINED PER TARGET IN `baselines.json`**, so a red suite at its
  recorded count is not news and a red suite that MOVES is. **A failure count moving inside an
  already-red suite is invisible in an aggregate**, which is how `test_batch_bi` stayed wrong for
  four batches — and **a RISING failure count is an ERROR while a falling one is a NOTICE**, because
  the two are not the same event.
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
  **The bands themselves are in `baselines.json`, with the observation count beside each** — that
  field exists because **`an`'s nine-observation band was exceeded on its TENTH reading, inside the
  batch that wrote it** (6055 against a 6047–6054 band). **A band is a claim about a distribution
  nobody has characterised, and the number of readings behind it is part of the claim.**
  **THE RULE, ASYMMETRIC ON PURPOSE: floor = the lowest observation, ceiling = the highest PLUS the
  observed spread** — the floor is the half that catches a real fault (a section of `an` that
  stopped running costs hundreds of checks, not five), so it stays tight and the ceiling takes the
  headroom. **`check_de` now RUNS on that asymmetry rather than merely being written by it: it
  asserts the floor and reports a rise as a notice.** `bk` is **not** widened, because it has not
  been exceeded: headroom goes where a reading demands it.
  - **AND THE `an` LAUNCHER QUESTION IS ANSWERED, NOT MERELY DISSOLVED.** DD recorded that its
    batteries read `an` at 6053 while `test_batch_cd`'s `OS.execute` sweeps read 6055, and that
    whether the two-check gap was draft randomness or a launcher difference "is not distinguishable
    on four readings" — worth a deliberate experiment. **DE's three batteries, ALL on the shell
    launcher, read 6051, 6050 and 6055.** The shell launcher produced 6055 by itself, so **the gap
    is draft randomness and the launcher hypothesis is dead.** **6050 is a new low**, comfortably
    inside the 6047 floor. There is only one launcher now in any case, so the question could not
    have recurred — but it is answered rather than merely retired, which is better.
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

**THREE FULL BATTERIES AT DE — one on unmodified HEAD before anything was touched, one after, and
an ACCEPTANCE run against the final tree.** The third was paid for deliberately: the `bo`
correction needed a late `CLAUDE.md` edit, and **a run that did not supervise the final tree cannot
certify it** — this batch's own principle, applied to itself.
**THE BEFORE-BATTERY REPRODUCED DD'S TABLE EXACTLY**, and not by eye: the baseline builder parsed
DD's own `BASELINE` out of the pre-patch `test_batch_cd.gd` and diffed it against every count the
run produced — **zero disagreements across 45 suites, on both halves of every row.** So the two
runs compare like with like on this machine rather than only against a document.

**THE COUNTS THEMSELVES ARE IN `baselines.json` AND ARE NOT REPEATED HERE.** That is the point of
the batch: one machine-readable file, read by `check_de`, with the observation count beside every
band. **Re-derive from there; a second copy of a number is this project's oldest recurring
defect.**

**ACROSS 46 SUITES, 14 GATES, 3 HARNESS GATES AND 2 SCENE RUNS, EXACTLY FIVE LINES DIFFER BETWEEN
THE TWO RUNS, AND ALL FIVE ARE ACCOUNTED FOR:**

| line | before | after | acceptance | why |
|---|---|---|---|---|
| `an` | 6051 | 6050 | **6055** | inside its band, 0 failures throughout — the known drifter |
| `bk` | 129 | 130 | **129** | both ends of its recorded band, twice over, 0 failures |
| `test_batch_cd` | 207 / 0 | **71 / 0** | 71 / 0 | the differ moved out — 136 checks went with it |
| `test_batch_cp` | *(not run)* | **697 / 0** | 697 / 0 | it is in `SUITES` now; agrees with DD's private sweep |
| `test_rune_battle` | 97 / 0 | 97 / 0 | **97 / 1** | **a flake `check_de` found — see the queue above** |
| `check_de` | *(did not exist)* | 273 / 0 / 0 | **273 / 1 / 0** | the post-pass, reporting the row above |

**Everything else is byte-identical** — 43 of the 45 shared suite lines, **all 14 gate lines**,
`check_cm_live`'s four deliberate reds, the harness at 22 / 165 / 8, `check_ct_map` at 83 / 0,
`check_map_screen` at its `OK`, and **`throws=0` everywhere in both runs**, grepped from the stream
and never read off a tally.

**THE DIFFER'S OWN VERDICT ON THE ACCEPTANCE RUN: `check_de` 273 checks / 1 failure / 0 notices —
65 of 65 recorded targets swept, zero throw markers, 0 unwatched and 0 un-run.** The one failure is
`test_rune_battle`'s newly-found flake, which is the instrument doing exactly the job it was built
for. **With that band recorded, the same logs re-read 273 / 0 / 0 in 0.63 seconds** — which is the
other half of the point: correcting a baseline no longer costs a battery.

**AND THE ACCEPTANCE RUN PROVED THE LATE DOC EDITS MOVED NOTHING.** Between the after-battery and
the acceptance battery, the only changes were to `CLAUDE.md`, `changelog.html` and
`design-notes.md`. **Four lines differ between those two runs** — `an` and `bk` inside their bands,
`test_rune_battle`'s flake, and `check_de` reporting it. **Not one line moved because of a
document**, and 35 suites read `CLAUDE.md`.

**WALL CLOCK — THE POINT OF THE BATCH:**

| | wall clock | |
|---|---|---|
| before DD | 29.6 min | the differ watched five suites |
| **before DE (measured, unmodified HEAD)** | **2,996 s — 49.9 min** | `test_batch_cd` §1 spawning 45 child Godots |
| **after DE (measured)** | **1,738 s — 29.0 min** | the differ is a post-pass |
| **acceptance DE (measured)** | **1,750 s — 29.2 min** | the final tree, documentation included |

**It is BELOW the 29.6 it started at, and that is with `test_batch_cp`'s 697 checks added to the
run.** The 22-minute nested sweep is gone; what replaced it costs 0.63 seconds.

**NO SIM HAS BEEN RUN SINCE DA.** DB, DC, DD and DE are all test batches; every ramp and depth
figure above is DA's, carried unchanged and re-derived from `docs/reports/DA.md`.
