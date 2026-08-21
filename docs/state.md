# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

*Last rewritten: 2026-08-21 (Batch CY).*

---

## WHERE THE PROJECT IS

- **Last batch: CY** — a buff costs half a swing. **`Ability.BUFF_DELAY_CAP := BASIC_DELAY * 0.5`
  caps a pure buff's initiative delay; 52 abilities are in the population and 51 came down to
  1.0.** Nothing else about any of them moved. §0 measured the two things the fix is aimed at and
  §2 reported the fold reaching back into CR without changing anything.
- **Next letter: CZ.**
- **Phase.** The ability draft is COMPLETE (120 of 120) and all twelve talent trees are
  purpose-authored, so the content build-out that ran from BO to CI is finished. Recent batches
  have been correction and consolidation: the skill-check rework (CM/CN/CS), the fold rulings
  (CQ/CR), the pouch (CT), the talent audit (CU reported, CV applied), the documentation split
  (CW), the archive cut (CX) and this batch's tempo rule.
- **The open work is still mostly DESIGN DECISIONS**, and CY added two more to the pile rather
  than clearing any: the shield ruling and what to do about the two ramps that still do not
  arrive.

---

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION

**Named by CY, and both are one-line rulings with the evidence already gathered:**
- **THE SHIELDS.** `divine_shield`, `magic_barrier`, `mantle`, `interpose`, `mirror_image`,
  `vespers` — six abilities at 2.0–2.5 initiative that §1 reported and did not touch. **They are
  adjacent to buffs and arguably the same case.** The criterion that excluded them is mechanical:
  a shield is a *consumable absorb pool or charge count that eats incoming attacks*. Say yes and
  they all go to 1.0 in one edit; say no and the criterion is confirmed.
- **BLOOD FRENZY AND FAITH STILL DO NOT ARRIVE, AND THE CAP WAS NOT ENOUGH.** After the change,
  peak Faith is **2.1 of the 5** a release needs and peak Frenzy is **11.8 of 40 points** at rung
  2. **Frenzy went DOWN**, because cheaper mitigation buffs mean the Berserker takes less damage
  and his band is paid in damage taken. **§3's reserved option — a ramp spec starting a fight with
  meter on the clock — is the thing this measurement is asking for**, and it was offered to the
  designer at CY and not taken.
  - **A judgement call inside §1 that the designer may want to overturn:** the five DEATH-SAVES
    (Rite of Return, Bloodbond, Intercession, Ashes of Al'ar, Undying Vigil) and the three
    HEAL-OVER-TIME buffs (Consecration, Aegis Wall, Battle Trance) were ruled buffs and capped. If
    either group should have gone with the shields, they leave as one group.

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
- **THE BATCH CL ENUMERATION MISSES FIVE ABILITIES AND `check_cn` / `check_co` BOTH WALK IT.** It
  enumerates kits, class pools and spec pools; **a talent node that GRANTS an ability which is in
  no pool is invisible to it.** The five are **Backdraft, Pyroblast, Glacial Prison, Cryoclasm and
  Intercession** — the corpus is **216, not 211**. `check_cy.gd` walks `Talents.LANE_TREES`
  through `Talents.granted_ability` and sees all 216; **CN's and CO's tables have NOT been
  re-derived against the larger corpus.** Four of the five are enemy-facing and could not join
  either table, so the exposure is small — but it is unmeasured.
- **`up_speed` IS A DEAD PICK ON ALL 52 PURE BUFFS.** `run_state._stamp_upgrade` reads
  `ab.delay = maxf(ab.delay * 0.75, 1.0)` and that floor is a **literal 1.0**, which is now exactly
  the cap. The upgrade was live on every one of them yesterday. Reported at CY, unchanged. **The
  floor being a literal rather than `Ability.BUFF_DELAY_CAP` is the thing to look at when either
  number is next touched.**
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

*Re-derive these before quoting them in a brief; they move. CY re-derived every figure below.*

- **A PURE BUFF COSTS HALF A SWING.** `Ability.BASIC_DELAY` = **2.0** (the one authored copy in the
  project; `battle.BASIC_DELAY` is an alias) and `Ability.BUFF_DELAY_CAP` = **`BASIC_DELAY * 0.5`**
  = 1.0 today. **`Ability.PURE_BUFFS` holds 52 specials**; the clamp is applied in `Ability.make()`
  and the 52 authored definitions are written as `Ability.BUFF_DELAY_CAP`, so the two cannot
  disagree. **Feigned Guard was already at the cap and is the only member that did not move.**
- **THE ABILITY CORPUS IS 216, NOT 211.** The CL enumeration reaches 211; the five it misses are
  listed under the open queue.
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
  array.** Its `GATES` array is now **twelve** — `check_cy` was added this batch.
- **The master.html stamp gate is duplicated across 14 suites** (ah, bb, bn, bo, bp, bq, br, bs,
  bt, bu, bv, bw, bx, ce), all on the self-comparing pattern — no bump is owed on a re-stamp.
- **Run harness gate counts: 22 / 165 / 8.**
- **master.html stamp: `Last updated: 2026-08-21 (Batch CY)`.**

### HOW LONG A FIGHT IS — THE NUMBER NOTHING IN THE PROJECT HELD UNTIL CY
- **Rounds to resolution, measured as TURNS PER LIVING PARTY MEMBER** (companions excluded from
  both halves), over four `--run 25` sims:

  | rung | trash | elite | boss |
  |---|---|---|---|
  | 1 wanderer | 3.5 | 3.0 | 3.8 |
  | 2 warden | 3.8 | 3.3 | 4.3 |
  | 3 ruin | 4.1 | 3.6 | 4.5 |

  **A fight is three to five turns per hero, and ELITE FIGHTS ARE THE SHORTEST OF THE THREE KINDS
  AT EVERY RUNG.** After the cap the same measurement reads 4.4 / 3.4 / 4.1 at rung 2 — **cheaper
  buffs made fights LONGER, not shorter.**
- **THE SIM'S OWN `Avg rounds/battle` LINE DIVIDES BY THREE AND THE PARTY IS FOUR.** It has been
  reading a third high since the class draft. `cy_report_line` is the one to read instead.
- **Ramp arrival, per-battle peak against what the spec is built around** (rung 2, before → after
  the cap): **Blood Frenzy 12.2 → 11.8 of 40 points**; **Faith 1.6 → 2.1 of 5**; **Loyalty
  20.0 → 20.4 of 5**; **Focus 131.3 → 139.4 of 100** (Sharpshooter party). **Loyalty and Focus
  over-arrive; Frenzy and Faith do not arrive, and Frenzy moved the wrong way.**
- **CONFOUNDER ON EVERY FIGURE ABOVE: the sim party is FULLY TALENTED (`rows=9 of 9`)**, which is
  stronger than a real player at zone 1. The rung-1 row is the closest thing to an under-equipped
  party and it is the SHORTEST fight in the table.

### The changelog
- **The live file starts at Batch CO and holds 11 entries** (CO → CY), **176.4 KB**. The 400 KB
  threshold is a long way off.
- **`DoD-archive/changelog-archive.html` holds 131 entries** (BP → CN) and is **1042.0 KB**.
- **Fourteen suites depend on a file that is not in version control** — bp, bq, br, bs, bt, bu,
  bv, bw, bx, cb, ce, bb, bn, bo. On a machine without `DoD-archive/` they FAIL LOUDLY, which is
  correct.

### Knowledge sync, measured at CY
*Measured over `.gd .md .html .json .py .sh`, excluding `assets/`, `.git/` and `.godot/`.
**Treat the file COUNT as method-dependent** — CW's filter counted 126 and CX's 108.*
- **111 files, 5.26 MB.**
- Heaviest: `scripts/battle.gd` **1137.0 KB**, `docs/master.html` **318.8 KB**,
  `docs/design-notes.md` **279.1 KB**, `scripts/classes.gd` **270.2 KB**,
  `scripts/talents.gd` **180.9 KB**, `docs/changelog.html` **176.4 KB**, `CLAUDE.md` **150.3 KB**.
- **The 47 suite files total ~1,800 KB**, still the single largest block. **They cannot be
  archived (they must be in the repo to run) but they CAN be deselected from the sync.**
- **`scripts/` is ~2,219 KB across 28 files and contains ZERO test suites.** All game code.

---

## KNOWN-BROKEN AND DELIBERATELY UNFIXED

- **CW'S `CLAUDE.md` SPLIT LEFT ELEVEN RED ASSERTIONS ACROSS EIGHT SUITES, AND CX FOUND THEM BY
  RUNNING THEM. THEY ARE STILL RED — CY DID NOT RUN THE SUITES.** CW dropped every batch
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
- **CY MOVED 52 ABILITY DELAYS AND NO SUITE HAS BEEN RUN AGAINST THEM.** Any suite that asserts a
  delay literal, a timeline position or a battle outcome for one of the 52 may be red and nobody
  knows. **The next dedicated test batch owes a full battery for this reason as well as CW's.**
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

**CY RAN NINE GATES AND EIGHT COMPLETE RUNS OF THE GAME. ZERO GATE FAILURES, ZERO THROWS.**
`check_parse` 0, `check_cn` 0, `check_co` 0, `check_cs` 104/0, `check_ct` 113/0, `check_cu` 0,
`check_cv` 0 (324 nodes), `check_flow` 0, **`check_cy` 0** (52 pure buffs, 104 live casts across
two fixtures).

**The eight runs are four before the change and four after** — 25 runs each, three difficulty
rungs, ~2,300 battles a pass. **Completions before → after: rung 1 100→100%, rung 2 52→84%, rung 3
12→36%, Sharpshooter party 48→52%. Depth reached: 46.32→46.80, 33.16→39.88, 41.12→42.60.** Depth
rose in all three measurable arms; **only rung 3's move is bigger than the combined standard
error**, and completions are the noisy secondary the harness says never to quote alone.

**NO SUITE AND NO FULL BATTERY HAS BEEN RUN SINCE CS.** CT, CU, CV, CW, CX and CY were all
implement-only under the standing convention; **the next dedicated test batch owes one**, against
a `CLAUDE.md` that ten assertions no longer match AND 52 abilities whose initiative cost moved.

**Full-battery baseline, at CS: 45 suites, zero throws, zero failures.** Counts:
ah 5625, ah_battle 65, ai 2217, aj 418, ak 528, al 560, **an 6052**, ar 735, as 396, at 470,
au 336, av 324, aw 350, ax 345, ay 484, az 519, ba 690, bb 177, bc 91, bd 71, be 34, bf 78,
bg 47, bh 233, bi 91, bj 67, **bk 129–130**, bl 88, bm 1891, bn 81, bo 1025, bp 272, bq 739,
br 1447, bs 263, bt 455, bu 477, bv 897, bw 548, bx 142, cb 1181, cd 86, ce 1112, runes 3121,
rune_battle 97. Run harness 22 / 165 / 8, all PASS.
**Nine of those suite counts are stale by design** — CX's re-pointed suites each gained +3 (bp,
bq, br, bs, bt, bu, bv, bw, cb) and `ce` gained +4.
