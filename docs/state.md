# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

*Last rewritten: 2026-08-21 (Batch CZ).*

---

## WHERE THE PROJECT IS

- **Last batch: CZ** — the two ramps that did not arrive, and the enumeration hole.
  **Blood Frenzy has a second term the Berserker controls (Rage spent, at the health term's own
  rate); Faith releases at 3 with both builders raised; the six shields take the buff delay cap;
  `up_speed` is revived from a floor CY's cap had made unreachable; and the ability enumeration is
  one function that reaches 216.** No save version moves (still v10).
- **Next letter: DA.** (CZ is the last two-letter code in the C block. **The stamp gate in fourteen
  suites reads a TWO-LETTER code out of `(Batch XX)` and compares it lexically — `DA` sorts AFTER
  `CZ`, so the comparison still works, but this is the boundary `CLAUDE.md` warns about: a
  three-letter code would break `substr(_code_at + 7, 2)` in all fourteen.**)
- **Phase.** The ability draft is COMPLETE (120 of 120) and all twelve talent trees are
  purpose-authored. Recent batches are correction and consolidation: the skill-check rework
  (CM/CN/CS), the fold rulings (CQ/CR), the pouch (CT), the talent audit (CU/CV), the documentation
  split (CW), the archive cut (CX), the tempo rule (CY) and this batch's two ramp repairs.
- **The open work is still mostly DESIGN DECISIONS.** CZ cleared three of CY's four (the shields,
  Blood Frenzy, Faith) and added one small one (Glacial Prison).

---

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION

**Named by CZ, and it is one line:**
- **SHOULD GLACIAL PRISON JOIN `RECAST_GATED`?** It is the one of the five talent-granted abilities
  that fits CO's refusal criterion: its whole cast-time payload is Chilled plus `_hold_freeze`, and
  `_hold_freeze` returns immediately on an already-`frozen` target — **so a recast onto a held
  enemy writes nothing at all.** One entry in one array **plus the matching `_recast_writes`
  declaration**, which must be right first (CR §3's lesson: a duration declared in the handler and
  not in the table makes the gate stop refusing). **Reported at CZ, not taken.**

**Carried, and both now have measurements attached that they did not have before:**
- **THE FAITH BUILDER RATE IS SHIPPED HOT AND THE ALTERNATIVE IS ONE CHARACTER AWAY.** At
  `FAITH_PER_ABSORB` 3 against a threshold of 3, **one absorbed hit is a whole release** and a
  shielded ally never holds Faith. Releases went **0.81 → 4.24** a battle at rung 2 and the
  Devout's total healing roughly **tripled** (69 → 178). `FAITH_PER_ABSORB := 2` measures at 3.2
  releases and costs 0.3 of the peak. **All four combinations are in `docs/reports/CZ.md`.**
- **THE FRENZY RATE IS `FRENZY_RAGE_PER_STEP` = 5** and is a rule rather than a constant (five Rage
  is 5% of a full bar, the health term's own rate). Peak Frenzy went **13.4 → 20.9 of 40** at rung
  2. **Reckless Abandon dumping a full bar books all twenty steps at once** — named, not discovered
  later.

**Named by the designer, carried from CX:**
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

**Carried from the code, reported and deliberately not fixed:**
- **`check_cu` AND `check_cv` ARE NOT IN `run_battery.sh`'s `GATES` ARRAY.** CY's report lists both
  among the nine gates it ran and the battery runs neither — they are hand-run or not run. Both
  were hand-run at CZ (0 failures each). **They are audit REPORTS rather than pass/fail gates**, so
  what a failure means there is a decision rather than a detail.
- **CY's PRINTED AFTER-FIGURES DO NOT REPRODUCE, AND NOTHING IS WRONG.** Re-measured on unmodified
  HEAD at the same settings, the same instrument reads Frenzy **6.2 / 13.4 / 12.1 / 13.9** against
  CY's **7.4 / 11.8 / 12.7 / 12.7**, and Faith **1.9 / 2.3 / 2.4 / 2.8** against **1.9 / 2.1 / 2.1
  / 2.8**. That is n=25 noise on an unseeded sim — roughly **±1.5 points of band and ±0.2 of a
  Faith stack**. **The 12.2 → 11.8 "regression" that motivated CZ §1 is smaller than the
  instrument's own error bar; the inversion it revealed is real and structural, but the number was
  not the evidence.** Quote no figure from this instrument without that band attached.
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

*Re-derive these before quoting them in a brief; they move. CZ re-derived every figure below.*

- **THE TEMPO LADDER HAS THREE RUNGS AND EACH IS WRITTEN AGAINST THE ONE ABOVE.**
  `Ability.BASIC_DELAY` = **2.0** (the one authored copy in the project; `battle.BASIC_DELAY` is an
  alias) → `Ability.BUFF_DELAY_CAP` = `BASIC_DELAY * 0.5` = **1.0** → `Ability.DELAY_FLOOR` =
  `BUFF_DELAY_CAP * 0.5` = **0.5**, the cheapest an ability UPGRADE can buy.
- **THE CAP BINDS 58 ABILITIES IN TWO POPULATIONS.** `Ability.PURE_BUFFS` holds **52** specials
  (CY's, unchanged) and `Ability.SHIELD_SPECIALS` holds **6** (CZ's). **`Ability.takes_delay_cap()`
  is the one function that unions them** and `Ability.make()` applies the clamp; the 58 authored
  definitions are written as `Ability.BUFF_DELAY_CAP`, so data and clamp cannot disagree.
- **THE ABILITY CORPUS IS 216, AND `Classes.ability_corpus()` IS THE ONLY WALK THAT REACHES IT.**
  The Batch CL enumeration alone reaches **211**; the five it misses (Backdraft, Pyroblast, Glacial
  Prison, Cryoclasm, Intercession) are talent grants that live in no pool. **22 talent-granted
  names in total**, all resolving.
- **BLOOD FRENZY: TWO TERMS, ONE BAND.** `BattleUnit.FRENZY_MAX_STEPS` = **20** (the ceiling the
  health term already had) and `FRENZY_RAGE_PER_STEP` = **5**. Steps are summed then clamped.
- **FAITH: `battle.FAITH_RELEASE` = 3**, `FAITH_PER_ABSORB` = **3**, `FAITH_PER_GROUND_TURN` =
  **2**. `JUBILEE_MIN_FAITH` is still **3**, which is now the WHOLE bar. `ELEVATION_STACKS` is
  still **2**, which is now **67% of a release**.
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
- **Relics: 25 in the pool** — 17 common, 8 rare. **Up to 3 are assigned per run**, party-wide.
- **Test suites: 44 `test_batch_*.gd` files**, spanning `ah` to `cp` (with gaps — they are NOT one
  per batch), plus `test_run_harness`, `test_runes` and `test_rune_battle`. **They live at the
  repo ROOT, not in `scripts/`.**
- **`run_battery.sh` runs 45 suites and MISSES ONE: `test_batch_cp` is not in its `SUITES`
  array.** Its `GATES` array is now **thirteen** — `check_cz` was added this batch.
- **The master.html stamp gate is duplicated across 14 suites** (ah, bb, bn, bo, bp, bq, br, bs,
  bt, bu, bv, bw, bx, ce), all on the self-comparing pattern — no bump is owed on a re-stamp.
- **Run harness gate counts: 22 / 165 / 8.**
- **master.html stamp: `Last updated: 2026-08-21 (Batch CZ)`.**

### HOW LONG A FIGHT IS
- **Rounds to resolution, measured as TURNS PER LIVING PARTY MEMBER** (companions excluded from
  both halves), over four `--run 25` sims, **after CZ**:

  | party / rung | trash | elite | boss |
  |---|---|---|---|
  | 1 wanderer | 3.9 | 3.5 | 3.9 |
  | 2 warden | 4.3 | 3.7 | 4.9 |
  | 3 ruin | 4.9 | 4.5 | 4.7 |
  | 2 warden, Sharpshooter | 5.8 | 5.0 | 6.5 |

  **A fight is still three to six turns per hero, and elite fights are the shortest of the three
  kinds at every rung.** Fights got slightly longer again for CY's reason — a party that survives
  takes more turns.
- **THE SIM'S OWN `Avg rounds/battle` LINE DIVIDES BY THREE AND THE PARTY IS FOUR.** It has been
  reading a third high since the class draft. `cy_report_line` is the one to read instead.
- **RAMP ARRIVAL, per-battle peak against what the spec is built around (before → after CZ):**

  | spec | meter | rung 1 | rung 2 | rung 3 | SS party |
  |---|---|---|---|---|---|
  | Berserker | Blood Frenzy (of 40) | 6.2 → **17.4** | 13.4 → **20.9** | 12.1 → **22.8** | 13.9 → **26.2** |
  | Devout | Faith (of 5 → of 3) | 1.9 → **2.5** | 2.3 → **2.4** | 2.4 → **2.4** | 2.8 → **2.5** |
  | Devout | releases/battle | 0.51 → **3.83** | 0.81 → **4.24** | 0.75 → **5.28** | 1.49 → **6.39** |
  | Beastmaster | Loyalty (of 5) | 19.3 → 19.0 | 23.0 → 21.2 | 20.3 → 20.6 | — |
  | Sharpshooter | Focus (of 100) | — | — | — | 131.1 → 130.9 |

  **Frenzy 33% → 52% of its band at rung 2; Faith 46% → 81% of its (new, lower) threshold.**
  **Loyalty and Focus still over-arrive and were not touched.**
- **RAGE SPENT PER BATTLE (the figure the Frenzy rate is set against): 37.3 / 39.5 / 47.9 / 57.8**
  at rungs 1/2/3 and the Sharpshooter party — **7.5 to 11.6 of the 20 steps.**
- **CONFOUNDER ON EVERY FIGURE ABOVE: the sim party is FULLY TALENTED (`rows=9 of 9`)**, which is
  stronger than a real player at zone 1.
- **AND THE INSTRUMENT'S OWN CAVEAT: the `conviction` row samples the DEVOUT'S OWN meter, which
  HOLDS at the threshold and never releases by rule.** It has never measured release frequency —
  `releases/battle` in the Faith decomposition is the row that does.

### The changelog
- **The live file starts at Batch CO and holds 12 entries** (CO → CZ), **192.7 KB**. The 400 KB
  threshold is a long way off.
- **`DoD-archive/changelog-archive.html` holds 131 entries** (BP → CN) and is **1042.0 KB**.
- **Fourteen suites depend on a file that is not in version control** — bp, bq, br, bs, bt, bu,
  bv, bw, bx, cb, ce, bb, bn, bo. On a machine without `DoD-archive/` they FAIL LOUDLY, which is
  correct.

### Knowledge sync, measured at CY
*Measured over `.gd .md .html .json .py .sh`, excluding `assets/`, `.git/` and `.godot/`.
**Treat the file COUNT as method-dependent** — CW's filter counted 126 and CX's 108.*
- **111 files, 5.26 MB** at CY; CZ adds `check_cz.gd` and `docs/reports/CZ.md`.
- Heaviest: `scripts/battle.gd` **~1140 KB**, `docs/master.html` **~320 KB**,
  `docs/design-notes.md` **~290 KB**, `scripts/classes.gd` **~271 KB**,
  `scripts/talents.gd` **~181 KB**, `docs/changelog.html` **192.7 KB**, `CLAUDE.md` **158.7 KB**.
- **The 47 suite files total ~1,800 KB**, still the single largest block. **They cannot be
  archived (they must be in the repo to run) but they CAN be deselected from the sync.**
- **`scripts/` contains ZERO test suites.** All game code.

---

## KNOWN-BROKEN AND DELIBERATELY UNFIXED

- **CW'S `CLAUDE.md` SPLIT LEFT ELEVEN RED ASSERTIONS ACROSS EIGHT SUITES, AND CX FOUND THEM BY
  RUNNING THEM. THEY ARE STILL RED — NEITHER CY NOR CZ RAN THE SUITES.** CW dropped every batch
  narrative; seven suites assert against text that went with it. **None is a changelog check.** Not
  repaired, because what those assertions should ask INSTEAD is a decision:
  - `test_batch_bb` — `BATCH BB`, `rot_hp_lost`
  - `test_batch_bn` — "rungs 2 and 3 were not touched", `_releasing`
  - `test_batch_bo` — `TRANCHES 2 AND 3`
  - `test_batch_bq` — `BATCH BQ`
  - `test_batch_br` — `BATCH BR`, "naming the twelve"
  - `test_batch_bx` — `BATCH BX`
  - `test_batch_ce` — `SECOND CLASS COMPLETE`
  - **AND IT HAS A KNOCK-ON: `test_batch_cd` IS RED BECAUSE `test_batch_bb` IS.** cd is the
    count-differ, so `FAIL: test_batch_bb.gd reports zero failures` is CW's damage arriving a
    second time through the one gate built to notice exactly this.
  - **AND TWO THAT PASS BY ACCIDENT, WHICH IS WORSE.** `contains("BATCH BN")` and
    `contains("BATCH BS")` still match — a passing mention inside two surviving rules, not a batch
    block. **A check that has stopped asking its question, with no red to announce it.**
- **CY MOVED 52 ABILITY DELAYS AND CZ MOVED SIX MORE, AND NO SUITE HAS BEEN RUN AGAINST ANY OF
  THEM.** Any suite asserting a delay literal, a timeline position or a battle outcome for one of
  the 58 may be red and nobody knows.
- **CZ MOVED THE FAITH RELEASE THRESHOLD FROM 5 TO 3 AND BOTH BUILDER RATES, AND NO SUITE HAS BEEN
  RUN AGAINST THAT EITHER.** `test_batch_bi`, `test_batch_bf`, `test_batch_be` and `test_batch_av`
  all drive Faith; **any of them that walks a meter to five or asserts a release count is a
  candidate.** The next test batch owes this list a pass before anything else.
- **`data/glossary.json` still reads "beast" once in prose** — "pay the four and not the beast",
  inside CV's own hero/ally entry. `test_batch_bx` §4 catches it. It belongs to the prose rename
  pass.
- **`check_cm_live` reports 4 failures. THIS IS THE ONE RED THAT IS ON PURPOSE.** Identical on
  unmodified HEAD, recorded as owed in the gate itself. It is the only thing that presses the
  defensive bar.
- **`test_batch_bo` has a flaky assertion — roughly 1 failure in 13 runs.** Its check count is
  rock steady at 1025; the §5 NULL FIELD check requires `deep < shallow` and the damage carries a
  0.9–1.1 variance roll, so both can land on the same integer. `test_batch_bo.gd` calls `seed()`
  zero times. **A count-diffing rule reads this as a regression and it is not one.**
- **Two suites drift in their check COUNT and must be read as bands, not numbers:** `an` at
  **6052–6054** and `bk` at **129–130**, both always 0 failures.
- **`check_map` is NOT a hang** — 99% CPU for ~5 minutes. The battery gives it a 600s bound.
- **`check_parse` does not cover the test suites.** It walks `res://scripts` and `res://scenes`
  only — **and never at all for `test_batch_cp`, which the battery does not run.**
- **The `_hint_done` / `_skill_done` deadlock is real and is NOT currently biting.** Both
  skill-check orientation cards `await` a signal only a real click or key press emits. **A future
  headless modal will hit this again** — `_nobody_can_press()` is the one place the question is
  asked, and a Profile flag is not a bot guard.

### Last measurements

**CZ RAN ELEVEN GATES AND EIGHT COMPLETE RUNS OF THE GAME. ZERO GATE FAILURES, ZERO THROWS.**
`check_parse` 0 (stderr grepped for `Parse Error`, never the tally), `check_cm` 0, `check_cn` 0,
`check_co` 0, `check_cs` 104/0, `check_ct` 113/0, `check_cu` 0, `check_cv` 0 (324 nodes),
`check_cy` 0, **`check_cz` 0**, `check_flow` 0. `check_cl_width` (a report, not a gate): 216
abilities, 8 description lines over the 44-character ceiling — **unchanged, and all five of the
newly-reached talent-granted abilities are clean.**

**The eight runs are four before the change and four after** — 25 runs each, three difficulty
rungs, ~2,500 battles a pass. **Completions before → after: rung 1 100→100%, rung 2 60→72%, rung 3
44→52%, Sharpshooter party 68→72%. Depth reached: 48.00→48.00, 45.64→46.56, 43.04→42.84,
44.68→47.04.** **Only the Sharpshooter arm's move is bigger than the combined standard error**, and
completions are the noisy secondary the harness says never to quote alone. **The honest summary is
that the batch did not make the game measurably harder or easier**, which is the right outcome for
a change aimed at two specs rather than at difficulty.

**NO SUITE AND NO FULL BATTERY HAS BEEN RUN SINCE CS.** CT, CU, CV, CW, CX, CY and CZ were all
implement-only under the standing convention; **the next dedicated test batch owes one**, against
a `CLAUDE.md` that ten assertions no longer match, 58 abilities whose initiative cost moved, and a
Faith threshold that several suites may quote.

**Full-battery baseline, at CS: 45 suites, zero throws, zero failures.** Counts:
ah 5625, ah_battle 65, ai 2217, aj 418, ak 528, al 560, **an 6052**, ar 735, as 396, at 470,
au 336, av 324, aw 350, ax 345, ay 484, az 519, ba 690, bb 177, bc 91, bd 71, be 34, bf 78,
bg 47, bh 233, bi 91, bj 67, **bk 129–130**, bl 88, bm 1891, bn 81, bo 1025, bp 272, bq 739,
br 1447, bs 263, bt 455, bu 477, bv 897, bw 548, bx 142, cb 1181, cd 86, ce 1112, runes 3121,
rune_battle 97. Run harness 22 / 165 / 8, all PASS.
**Nine of those suite counts are stale by design** — CX's re-pointed suites each gained +3 (bp,
bq, br, bs, bt, bu, bv, bw, cb) and `ce` gained +4.
