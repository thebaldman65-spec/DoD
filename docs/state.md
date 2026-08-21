# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

*Last rewritten: 2026-08-20 (Batch CX).*

---

## WHERE THE PROJECT IS

- **Last batch: CX** — the changelog cut, and three rulings. §1 executed CW's archive rule, §3
  made `Regalia` castable and self-targeted, §4 renamed the Orc Chief's ability. **§2 (per-hero
  relics) was scoped and DELIBERATELY NOT STARTED** — see the queue.
- **Next letter: CY.**
- **Phase.** The ability draft is COMPLETE (120 of 120) and all twelve talent trees are
  purpose-authored, so the content build-out that ran from BO to CI is finished. Recent batches
  have been correction and consolidation: the skill-check rework (CM/CN/CS), the fold rulings
  (CQ/CR), the pouch (CT), the talent audit (CU reported, CV applied), the documentation split
  (CW) and this batch's archive cut.
- **The open work is still mostly DESIGN DECISIONS**, but **CX cleared three of them** and left
  one large scoped decision (relics) in their place.

---

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION

**Named by the designer:**
- **Enemy interference as a status.** Not yet specified.
- **RELICS PER-HERO — RULED, SCOPED, AND NOT STARTED.** The ruling stands (a relic is assigned to
  one hero at pickup); CX reported the scope and stopped, which is what the brief asked. **It is a
  SAVE-FORMAT change: the run save goes v10 → v11.** `Run.active_relics` is a flat `Array` read
  back as a hard key (`data["active_relics"]`, no default), so every existing save breaks without
  a migration. It also touches **25 read sites** (`battle.gd` 12, `run_state.gd` 8, `run_sim.gd`
  4, `shop_screen.gd` 1), the two aggregators (`Relics.hook_add` / `hook_dict`), the two accessors
  (`Run.relic_add` / `relic_dict`) — **all four change signature** — both acquisition sites (the
  draft screen's three-slot toggle needs a per-relic hero picker; the `relic_grant` event verb
  would have to choose a hero), and **13 of the 25 relic descriptions**, which are worded
  party-wide — "All heroes", "Every hero", "The party", "party recovers", "Heroes open every
  battle". **It can be split; it should not be started casually.**
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
- **The enemy debuffs whose duration exceeds their own cooldown.** Reported by the fold census —
  the class of change that turns a timed effect into a permanent one.
- **The design review.**
- **Browser playtesting with friends.**

**Carried from the code, reported and deliberately not fixed:**
- **The code identifiers still reading "beast".** The PROSE was renamed; the fields were not, on
  purpose — a missed rename in prose is a typo, a missed rename in a field is a bug, so the two
  want separate passes with separate tests. **`beastmaster` / `Beastmaster` / `BEASTMASTER` are
  NOT on the list and must not be renamed** (the spec is still called the Beastmaster in game, so
  the key is a proper name). Live identifiers: `unit.gd` `beasts`, `beast_committed`,
  `no_beast_left`, `no_beast_left_loyalty`; `battle.gd` `_beasts`, `_free_beast`,
  `_on_beast_death`, `_beast_cap` (referenced by name from `talents.gd`); battle locals
  `bot_beasts`, `cw_beasts`, `kc_beasts`, `sb_beast`, `sb_beasts`, `tm_beasts`; node ids
  `bm_beast_within` and `bm_no_beast_left` — **renaming those two moves the save format.**
- **`master.html` credits "the Warden's Crushing Blow talent" and there is no such talent.**
  `Crushing Blows` is a **Berserker** node; `Crushing Blow` is an **ability**. CX renamed the Orc
  Chief's third copy out of the collision but **deliberately did not touch either of these two**,
  so the documentation still confuses them. One string, and it is the designer's call which way.
- **No spec pool has ever been checked for redundancy against its own base kit.**
- **Two specs still take the generic talent fallback**, nine nodes between them.
- **`docs/text-audit.html` and `docs/talent-audit.html` hold findings that have been ruled on and
  applied.** Once the designer confirms, both can leave the knowledge sync.

---

## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND

*Re-derive these before quoting them in a brief; they move. CX re-derived every figure below.*

- **The ability draft is COMPLETE at 120 of 120** — `SPEC_DRAFT_POOLS` is **96** (12 specs × 8)
  and `CLASS_DRAFT_POOLS` is **24** (4 classes × 6). All twelve specs draft from eight; all four
  class pools hold six. **Do not quote the old ~96 target for the whole draft.**
- **Ability slot cap: 7** (`ABILITY_SLOT_CAP`), with twelve protected cores.
- **The pouch: 4 → 5 → 6 slots by zone** (`ITEM_SLOTS_BY_ZONE`), a slot holding one item TYPE and
  its whole stack. **Default per-type stack cap `ITEM_CAP` = 6**, with three exceptions
  (`ITEM_STACK_CAPS`): Cleansing Draught **4**, Cursed Visage **2**, Resonating Hourglass **2**.
  Sale returns `SELL_FRACTION` = **0.4** of listed price.
- **The skill check's default profile** — `battle.SC_PROFILE_DEFAULT`: `perfect_half` **0.045**,
  `good_half` **0.16**, `centre` **0.5**, `sweep_time` **0.72**, `presses` **1**, `press_taper`
  **1.0**. **Every caller uses it except the Sharpshooter's basic attack.** Editing a value there
  changes every check in the game at once.
- **Save versions: the run save is v10** (a pre-v10 save is REFUSED and cleared); **`Profile` is
  v2** (tolerant load). Talent cells cost 1/2/3 by tier — **27 cells = 54 points a spec.**
- **Relics: 25 in the pool** — 17 common, 8 rare. **Up to 3 are assigned per run**, party-wide.
- **Test suites: 44 `test_batch_*.gd` files**, spanning `ah` to `cp` (with gaps — they are NOT one
  per batch), plus `test_run_harness`, `test_runes` and `test_rune_battle`. **They live at the
  repo ROOT, not in `scripts/`.**
- **`run_battery.sh` runs 45 of them and MISSES ONE: `test_batch_cp` is not in its `SUITES`
  array.** CP was the first dedicated test batch and its own suite has never run in the battery.
  The battery's 45 are 43 `test_batch_*` plus `test_runes` and `test_rune_battle`;
  `test_run_harness` runs separately as gates 1/2/3.
- **The master.html stamp gate is duplicated across 14 suites** (ah, bb, bn, bo, bp, bq, br, bs,
  bt, bu, bv, bw, bx, ce), all on the self-comparing pattern — no bump is owed on a re-stamp.
- **Run harness gate counts: 22 / 165 / 8.**
- **master.html stamp: `Last updated: 2026-08-20 (Batch CX)`.** *(It read CW, not CV, before this
  batch — the previous state.md had that wrong.)*

### The changelog, after CX's cut
- **The live file starts at Batch CO and holds 10 entries** (CO → CX). **162.1 KB**, cut from
  **494.2 KB**. The 400 KB threshold is a long way off again.
- **`DoD-archive/changelog-archive.html` holds 131 entries** (BP → CN prepended to the 108 it had)
  and is **1042.0 KB**. **140 entries before the cut, 140 after.**
- **Eleven suites now read the ARCHIVE, not the live file** — bp, bq, br, bs, bt, bu, bv, bw, bx,
  cb, ce — each anchored on its `<h2>` heading and reaching the archive by following the path out
  of the live header. **Fourteen suites in total now depend on a file that is not in version
  control** (those eleven plus bb, bn, bo). On a machine without `DoD-archive/` they FAIL LOUDLY,
  which is correct.

### Knowledge sync, measured at CX
*Measured over `.gd .md .html .json .py .sh`, excluding `assets/` and `.git`. **This is a
different filter from CW's**, which counted 126 files; treat the file COUNT as method-dependent
and the per-file sizes as the durable figures.*
- **108 files, 5.36 MB.** The cut took **332 KB** off `docs/changelog.html` alone
  (494.2 → 162.1 KB) and moved it outside the repo.
- Heaviest: `scripts/battle.gd` **1129.9 KB**, `docs/master.html` **318.8 KB**,
  `docs/design-notes.md` **270.6 KB**, `scripts/classes.gd` **269.3 KB**,
  `docs/changelog.html` **162.1 KB**, `CLAUDE.md` **144.2 KB**.
- **The 47 suite files total ~1,888 KB**, still the single largest block. **They cannot be
  archived (they must be in the repo to run) but they CAN be deselected from the sync.**
- **`scripts/` is ~2,376 KB and contains ZERO test suites.** It is all game code and stays
  selected.

---

## KNOWN-BROKEN AND DELIBERATELY UNFIXED

- **CW'S `CLAUDE.md` SPLIT LEFT ELEVEN RED ASSERTIONS ACROSS EIGHT SUITES, AND CX FOUND THEM BY
  RUNNING THEM.** CW dropped every batch narrative; seven suites assert against text that went
  with it. **None is a changelog check and none was caused by CX's cut.** Not repaired here,
  because what those assertions should ask INSTEAD is a decision, not a detail:
  - `test_batch_bb` — `BATCH BB`, `rot_hp_lost`
  - `test_batch_bn` — "rungs 2 and 3 were not touched", `_releasing`
  - `test_batch_bo` — `TRANCHES 2 AND 3`
  - `test_batch_bq` — `BATCH BQ`
  - `test_batch_br` — `BATCH BR`, "naming the twelve"
  - `test_batch_bx` — `BATCH BX`
  - `test_batch_ce` — `SECOND CLASS COMPLETE`
  - **AND IT HAS A KNOCK-ON: `test_batch_cd` IS RED BECAUSE `test_batch_bb` IS.** cd is the
    count-differ — it re-runs other suites and asserts each reports zero failures — so
    `FAIL: test_batch_bb.gd reports zero failures` is CW's damage arriving a second time,
    through the one gate built to notice exactly this. **Which is why the count is eleven, across eight suites, and not ten across seven.**
  - **AND TWO THAT PASS BY ACCIDENT, WHICH IS WORSE.** `contains("BATCH BN")` and
    `contains("BATCH BS")` still match — not a batch block, but a passing mention inside two
    surviving rules. **A check that has stopped asking its question, with no red to announce it.**
- **`data/glossary.json` still reads "beast" once in prose** — "pay the four and not the beast",
  inside CV's own hero/ally entry. `test_batch_bx` §4 catches it. One word; it belongs to the
  prose rename pass, so CX reported it rather than taking it.
- **`check_cm_live` reports 4 failures. THIS IS THE ONE RED THAT IS ON PURPOSE.** Identical on
  unmodified HEAD, recorded as owed in the gate itself, unchanged since. It is the only thing that
  presses the defensive bar, so the failures are worth keeping visible rather than silencing.
- **`test_batch_bo` has a flaky assertion — roughly 1 failure in 13 runs.** Its check count is
  rock steady at 1025; the §5 NULL FIELD check resolves the same enemy attack at 2 Resonance and
  at 14 and requires `deep < shallow`, but the damage carries a 0.9–1.1 variance roll, so both
  can land on the same integer. **`test_batch_bo.gd` calls `seed()` zero times**, so its stream
  differs every run. **A count-diffing rule reads this as a regression and it is not one.** The
  repair is to seed the suite or widen the gap the assertion measures.
- **Two suites drift in their check COUNT and must be read as bands, not numbers:** `an` at
  **6052–6054** and `bk` at **129–130**, both always 0 failures. `bk` generates real zone maps
  and then walks them, so its count is a function of the topology it rolled.
- **`check_map` is NOT a hang** — 99% CPU for ~5 minutes. The battery gives it a per-target 600s
  bound.
- **`check_parse` does not cover the test suites.** It walks `res://scripts` and `res://scenes`
  only, so a syntax error in a root-level `test_batch_*.gd` surfaces only when the battery
  reaches that suite — **and never at all for `test_batch_cp`, which the battery does not run.**
- **The `_hint_done` / `_skill_done` deadlock is real and is NOT currently biting.** Both
  skill-check orientation cards `await` a signal only a real click or key press emits. The four
  suites that hung on it (al, bp, br, bw) were **closed two batches running** and produce counts;
  the diagnosis that closed them has held. **A future headless modal will hit this again** —
  `_nobody_can_press()` is the one place the question is asked, and a Profile flag is not a bot
  guard.

### Last measurements

**CX ran 28 targets — 20 suites and 8 gates — with ZERO THROWS and zero timeouts.**
Counts and failures as measured this batch:
ah 5625/0, bb 177/**2**, bn 81/**2**, bo 1025/**1**, bp 275/0, bq 742/**1**, br 1450/**2**,
bs 266/0, bt 458/0, bu 480/0, bv 900/0, bw 551/0, bx 147/**2**, cb 1184/0, ce 1116/**1**,
ah_battle 65/0, aj 418/0, bm 1891/0, bl 88/0, cd 86/**1**.
Gates all clean: `check_parse` 0, `check_cs` 104/0, `check_ct` 113/0, `check_cn` 0, `check_co` 0,
`check_cu` 0, `check_cv` 0 (324 nodes), `check_flow` 0.
**All twelve failures are listed under KNOWN-BROKEN above; none is a changelog check, and every
suite that did not inherit CW's damage matches its CS baseline exactly** (ah, ah_battle, aj, bm,
bl, cd's check count, bb, bn, bo).
The nine re-pointed suites in that set each gained exactly **+3** checks (bp, bq, br, bs, bt, bu,
bv, bw, cb) and `ce` gained **+4**; `bx` reads 147 against CS's 142, the extra two having arrived
somewhere in CT–CW.

**No FULL battery has been run since CS.** CT, CU, CV, CW and CX were implement-only batches under
the standing convention; **the next dedicated test batch owes one**, and it now owes it against a
CLAUDE.md that ten assertions no longer match.

**Full-battery baseline, at CS: 45 suites, zero throws, zero failures.** Counts:
ah 5625, ah_battle 65, ai 2217, aj 418, ak 528, al 560, **an 6052**, ar 735, as 396, at 470,
au 336, av 324, aw 350, ax 345, ay 484, az 519, ba 690, bb 177, bc 91, bd 71, be 34, bf 78,
bg 47, bh 233, bi 91, bj 67, **bk 129–130**, bl 88, bm 1891, bn 81, bo 1025, bp 272, bq 739,
br 1447, bs 263, bt 455, bu 477, bv 897, bw 548, bx 142, cb 1181, cd 86, ce 1112, runes 3121,
rune_battle 97. Run harness 22 / 165 / 8, all PASS.
**Nine of those suite counts are now stale by design** — see the +3/+4 note above.
