# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

*Last rewritten: 2026-08-21 (Batch DA).*

---

## WHERE THE PROJECT IS

- **Last batch: DA** — the Faith revert, the Glacial Prison refusal, and the copied-helper rule.
  **`FAITH_PER_ABSORB` is back to 2 and the ground drip to 1 while the threshold stays at 3;
  Glacial Prison is the 59th member of `RECAST_GATED` and the first talent-grant in it; and
  "a helper copied between gates diverges silently" is a standing rule with a gate behind it.**
  No save version moves (still v10).
- **Next letter: DB.** **The two-letter stamp gate in fourteen suites reads `substr(_code_at + 7, 2)`
  out of `(Batch XX)` and compares lexically — `DB` sorts after `DA`, so it still works. A
  THREE-letter code would break all fourteen.** This is the second batch inside the D block and the
  boundary has been crossed without incident.
- **Phase.** The ability draft is COMPLETE (120 of 120) and all twelve talent trees are
  purpose-authored. Recent batches are correction and consolidation: the skill-check rework
  (CM/CN/CS), the fold rulings (CQ/CR), the pouch (CT), the talent audit (CU/CV), the documentation
  split (CW), the archive cut (CX), the tempo rule (CY), CZ's two ramp repairs and this batch's
  correction of one of them.
- **The open work is still mostly DESIGN DECISIONS.** DA closed the last one CZ named (Glacial
  Prison) and added none.

---

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION

**Nothing was named by DA. The queue is what it carried in, minus the two items DA closed.**

**Carried, with measurements attached:**
- **THE FRENZY RATE IS `FRENZY_RAGE_PER_STEP` = 5** and is a rule rather than a constant (five Rage
  is 5% of a full bar, the health term's own rate). Peak Frenzy 13.4 → 20.9 of 40 at rung 2 under
  CZ, and **DA re-measured it unchanged at 20.7** — it is the control that says DA moved Faith and
  nothing else. **Reckless Abandon dumping a full bar books all twenty steps at once** — named, not
  discovered later.
- **THE FAITH LANE IS SETTLED FOR NOW AND THE NUMBERS ARE IN `docs/reports/DA.md`.** Threshold 3,
  builders 2 and 1, releases **1.93 / 2.60 / 2.48 / 3.62** across the four arms. **Elevation (2 of
  3, 67% of a release party-wide) and Blessing of the Faithful (3 of 3, the whole bar) were
  reported at both CZ and DA and deliberately changed at neither.** If either is ever revisited,
  Elevation is the one with a history of being moved by accident (CG set 2, CN's fold pushed 3, CQ
  reverted it).

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
- **`_spawn` IS COPIED INTO SEVEN GATES AS FOUR DIVERGENT BODIES, AND CONSOLIDATING IT IS ITS OWN
  BATCH.** DA §3 swept and reported; nothing was changed. The copies are `check_cm_live`,
  `check_co`, `check_cs`, `check_ct`, `check_cy`, `check_cz` and `check_da`, and even the SIGNATURE
  diverged (`_spawn(specs: Array)` / `_spawn()` / `_spawn(run: Node)`). **It has already cost
  twice**: the copied `_report` drifted into two output formats and `run_battery.sh`'s grep silently
  missed one, and CQ §1's deliberate removal of two `Profile.set_flag` lines from one copy left them
  standing in two others with nothing reporting it. **A shared fixture must serve four legitimately
  different needs** (a party parameter, `check_cs`'s determinism forcing, `check_ct`'s pre-loaded
  pouch, `check_cm_live`'s deliberately absent flags). `check_da` prints the census every run.
  **In the SUITES the same defect is far larger and equally untouched: `_spawn` in 37 suites as 34
  distinct bodies, `_run` in 39 as 39, `_kill` byte-identical in 14.**
- **THE DEFAULT SIM BUILD HAS NEVER MEASURED A NON-FIRST LANE, FOR ANY OF THE TWELVE SPECS.**
  `DOD_SIM_BUILDS` defaults to each tree's FIRST lane — for the Cryomancer that is **Winter**, so
  **Glacial Prison, Second Prison, Cold Snap, Glacial Economy and Absolute Zero have never appeared
  in any measurement in this project.** Not a defect (a fixed default party is what makes arms
  comparable across batches), but **no sim figure can be quoted about a card in a non-default lane**
  and several have been. DA ran one arm on `cryomancer:Deep Freeze` to smoke-test §2.
- **`_recast_refusal_note` SAYS "FROZEN" WHERE THE NAMEPLATE SAYS "HELD".** The refusal on a held
  enemy reads *"Frozen already stands at full strength"*; Batch AS §4 renamed that chip to **HELD**
  deliberately. **The note is accurate and the vocabulary is inconsistent.** One string, and it is
  the designer's call.
- **`check_cu` AND `check_cv` ARE NOT IN `run_battery.sh`'s `GATES` ARRAY.** They are audit REPORTS
  rather than pass/fail gates, so what a failure means there is a decision rather than a detail.
  `check_da` was added to the array; these two were not.
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

*Re-derive these before quoting them in a brief; they move. DA re-derived every figure below.*

- **THE TEMPO LADDER HAS THREE RUNGS AND EACH IS WRITTEN AGAINST THE ONE ABOVE.**
  `Ability.BASIC_DELAY` = **2.0** (the one authored copy in the project; `battle.BASIC_DELAY` is an
  alias) → `Ability.BUFF_DELAY_CAP` = `BASIC_DELAY * 0.5` = **1.0** → `Ability.DELAY_FLOOR` =
  `BUFF_DELAY_CAP * 0.5` = **0.5**, the cheapest an ability UPGRADE can buy.
- **THE CAP BINDS 58 ABILITIES IN TWO POPULATIONS.** `Ability.PURE_BUFFS` holds **52** specials
  and `Ability.SHIELD_SPECIALS` holds **6**. **`Ability.takes_delay_cap()` is the one function that
  unions them** and `Ability.make()` applies the clamp; the 58 authored definitions are written as
  `Ability.BUFF_DELAY_CAP`, so data and clamp cannot disagree.
- **THE ABILITY CORPUS IS 216, AND `Classes.ability_corpus()` IS THE ONLY WALK THAT REACHES IT.**
  The Batch CL enumeration alone reaches **211**; the five it misses (Backdraft, Pyroblast, Glacial
  Prison, Cryoclasm, Intercession) are talent grants that live in no pool. **22 talent-granted
  names in total**, all resolving. **`check_da` §3 asserts that no gate hand-rolls the walk**, with
  `check_cz`'s `_cl_only_corpus` named as the one deliberate exemption.
- **`RECAST_GATED` HOLDS 59 ABILITIES** — Glacial Prison joined at DA §2 and is **the first
  talent-grant in the set**. `check_co` refuses 58 of the 59 after saturation; Interpose is
  additive and correctly never refuses.
- **BLOOD FRENZY: TWO TERMS, ONE BAND.** `BattleUnit.FRENZY_MAX_STEPS` = **20** and
  `FRENZY_RAGE_PER_STEP` = **5**. Steps are summed then clamped.
- **FAITH: `battle.FAITH_RELEASE` = 3**, **`FAITH_PER_ABSORB` = 2**, **`FAITH_PER_GROUND_TURN` = 1.**
  `JUBILEE_MIN_FAITH` is **3**, which is the WHOLE bar. `ELEVATION_STACKS` is **2**, which is **67%
  of a release**. **An absorbed hit pays LESS than a release costs, and `check_da` asserts that
  RELATIONSHIP rather than the numbers** — at or above it a shielded ally never holds Faith and
  `faith_peak` stops existing for allies.
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
  array.** Its `GATES` array is now **fourteen** — `check_da` was added this batch. **There are 19
  `check_*.gd` files, so five gates are not in the battery** (`check_ck_width`, `check_cu`,
  `check_cv`, `check_ct_map`, `check_map_screen`).
- **The master.html stamp gate is duplicated across 14 suites** (ah, bb, bn, bo, bp, bq, br, bs,
  bt, bu, bv, bw, bx, ce), all on the self-comparing pattern — no bump is owed on a re-stamp.
- **Run harness gate counts: 22 / 165 / 8.**
- **master.html stamp: `Last updated: 2026-08-21 (Batch DA)`.**

### HOW LONG A FIGHT IS
- **Rounds to resolution, measured as TURNS PER LIVING PARTY MEMBER** (companions excluded from
  both halves), over four `--run 25` sims, **after DA**:

  | party / rung | trash | elite | boss |
  |---|---|---|---|
  | 1 wanderer | 3.8 | 3.4 | 4.0 |
  | 2 warden | 4.4 | 3.6 | 5.3 |
  | 3 ruin | 4.4 | 4.4 | 4.4 |
  | 2 warden, Sharpshooter | 5.5 | 4.9 | 6.0 |

  **A fight is still three to six turns per hero.** **CORRECTION TO A CLAIM THIS FILE HAS CARRIED
  SINCE CY: "elite fights are the shortest of the three kinds at every rung" NO LONGER HOLDS AT
  RUNG 3**, where all three kinds read 4.4. It holds at rungs 1 and 2 and for the Sharpshooter
  party.
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

  **Frenzy holds at 52% of its band at rung 2 — DA did not touch it, and that is the control.**
  **Faith releases sit between the pre-CZ 0.81 and CZ's 4.24 at every rung**, which is what the
  threshold buys on its own. **Loyalty and Focus still over-arrive and have not been touched.**
- **THE FAITH DECOMPOSITION AT RUNG 2, AFTER DA:** absorbs **3.90**, ground drip **8.01**, total
  **12.27** a battle, of which **2.21** lands on the Devout's own held meter. **Faith per absorb
  ACTUALLY LANDED is 1.56 against the 2 the constant promises** — the cap at the threshold throws
  the remainder away. Ground up on **49% of hero turns** (8.1 of 16.5). Devout healing a battle:
  **74 / 133 / 130 / 184** across the four arms.
- **CONFOUNDER ON EVERY FIGURE ABOVE: the sim party is FULLY TALENTED (`rows=9 of 9`)**, which is
  stronger than a real player at zone 1 — **and it wears each tree's FIRST lane**, which is a
  second confounder and a larger one than it looks (see the open queue).
- **AND THE INSTRUMENT'S OWN CAVEAT: the `conviction` row samples the DEVOUT'S OWN meter, which
  HOLDS at the threshold and never releases by rule.** It has never measured release frequency —
  `releases/battle` in the Faith decomposition is the row that does. **CY's two headline figures
  were both instrument faults and the changelog records it at DA §4:** that arrival row, and the
  12.2 → 11.8 Blood Frenzy "regression" that sat inside the instrument's own **±1.5** band at n=25.
  **CZ §1's structural reasoning stands and is not revisited; the numbers are not evidence.**

### The changelog
- **The live file starts at Batch CO and holds 13 entries** (CO → DA), **207.3 KB**. The 400 KB
  threshold is a long way off.
- **`DoD-archive/changelog-archive.html` holds 131 entries** (BP → CN) and is **1042.0 KB**.
- **Fourteen suites depend on a file that is not in version control** — bp, bq, br, bs, bt, bu,
  bv, bw, bx, cb, ce, bb, bn, bo. On a machine without `DoD-archive/` they FAIL LOUDLY, which is
  correct.

### Knowledge sync, re-measured at DA
*Measured over `.gd .md .html .json .py .sh`, excluding `assets/`, `.git/` and `.godot/`.
**Treat the file COUNT as method-dependent** — CW's filter counted 126 and CX's 108.*
- **115 files, 5.43 MB.** DA adds `check_da.gd` and `docs/reports/DA.md`.
- Heaviest: `scripts/battle.gd` **~1149 KB**, `docs/master.html` **~320 KB**,
  `docs/design-notes.md` **~294 KB**, `scripts/classes.gd` **~274 KB**,
  `docs/changelog.html` **207 KB**, `scripts/talents.gd` **~181 KB**, `scripts/unit.gd` **~174 KB**,
  `CLAUDE.md` **163 KB**.
- **The 47 suite files total ~1,800 KB**, still the single largest block. **They cannot be
  archived (they must be in the repo to run) but they CAN be deselected from the sync.**
- **`scripts/` contains ZERO test suites.** All game code.

---

## KNOWN-BROKEN AND DELIBERATELY UNFIXED

- **CW'S `CLAUDE.md` SPLIT LEFT ELEVEN RED ASSERTIONS ACROSS EIGHT SUITES, AND CX FOUND THEM BY
  RUNNING THEM. THEY ARE STILL RED — CY, CZ AND DA ALL RAN NO SUITES.** CW dropped every batch
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
- **THE FAITH THRESHOLD IS STILL AT 3 AND NO SUITE HAS BEEN RUN AGAINST IT.** `test_batch_bi`,
  `test_batch_bf`, `test_batch_be` and `test_batch_av` all drive Faith; **any of them that walks a
  meter to five or asserts a release count is a candidate.** **THE ONE PIECE OF GOOD NEWS: DA's
  revert un-breaks `test_batch_bi`**, which asserts `const FAITH_PER_ABSORB := 2` in the source and
  `ally.faith_stacks == 2` after one absorb — CZ had turned both red and they should be green
  again. **Unverified: no suite was run.** The next test batch owes this list a pass before
  anything else.
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
- **A GATE THAT EXITS 0 IS NOT A GATE THAT PASSED, AND DA HIT IT AGAIN.** `check_da`'s first run
  printed a clean-looking report and **exited 0 with two `Parse Error` lines on stderr**. Grep the
  stderr; never trust the tally.
- **The `_hint_done` / `_skill_done` deadlock is real and is NOT currently biting.** Both
  skill-check orientation cards `await` a signal only a real click or key press emits. **A future
  headless modal will hit this again** — `_nobody_can_press()` is the one place the question is
  asked, and a Profile flag is not a bot guard.

### Last measurements

**DA RAN SEVEN GATES AND FIVE COMPLETE RUNS OF THE GAME. ZERO GATE FAILURES, ZERO THROWS.**
`check_parse` 0 (stderr grepped for `Parse Error`, never the tally), **`check_da` 30 checks / 0**,
`check_co` 0 at **59** gated abilities (58 refused after saturation), `check_cz` 0, `check_cn` 0,
`check_cm` 0, `check_flow` 0.

**Five runs at `--run 25`** — the four comparable arms plus one on `DOD_SIM_BUILDS="cryomancer:Deep
Freeze"`, the lane that actually holds Glacial Prison. **Completions CZ → DA: rung 1 100→100%,
rung 2 72→80%, rung 3 52→56%, Sharpshooter party 72→76%. Depth: 48.00→48.00, 46.56→47.12,
42.84→44.76, 47.04→46.12.** **NO ARM MOVED FURTHER THAN ITS OWN COMBINED STANDARD ERROR**, so
taking roughly a third of the Devout's healing back off did not make the game measurably harder —
the expected result for a change aimed at what a card IS rather than at difficulty. The Deep Freeze
arm read depth 47.16 ±0.69 at 88% completions, freezing less often (3.30/battle against 4.20) and
holding far longer (**2.65** holds of ≥3 turns against 1.75).

**NO SUITE AND NO FULL BATTERY HAS BEEN RUN SINCE CS.** CT, CU, CV, CW, CX, CY, CZ and DA were all
implement-only under the standing convention; **the next dedicated test batch owes one**, against a
`CLAUDE.md` that ten assertions no longer match, 58 abilities whose initiative cost moved, and a
Faith threshold that several suites may quote.

**Full-battery baseline, at CS: 45 suites, zero throws, zero failures.** Counts:
ah 5625, ah_battle 65, ai 2217, aj 418, ak 528, al 560, **an 6052**, ar 735, as 396, at 470,
au 336, av 324, aw 350, ax 345, ay 484, az 519, ba 690, bb 177, bc 91, bd 71, be 34, bf 78,
bg 47, bh 233, bi 91, bj 67, **bk 129–130**, bl 88, bm 1891, bn 81, bo 1025, bp 272, bq 739,
br 1447, bs 263, bt 455, bu 477, bv 897, bw 548, bx 142, cb 1181, cd 86, ce 1112, runes 3121,
rune_battle 97. Run harness 22 / 165 / 8, all PASS.
**Nine of those suite counts are stale by design** — CX's re-pointed suites each gained +3 (bp,
bq, br, bs, bt, bu, bv, bw, cb) and `ce` gained +4.
