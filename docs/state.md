# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

*Last rewritten: 2026-08-20 (Batch CW).*

---

## WHERE THE PROJECT IS

- **Last batch: CW** — documentation architecture. `CLAUDE.md` split into standing rules only,
  this file created, batch reports moved into the repo. **No game code changed.**
- **Next letter: CX.**
- **Phase.** The ability draft is COMPLETE (120 of 120) and all twelve talent trees are
  purpose-authored, so the content build-out that ran from BO to CI is finished. Recent batches
  have been correction and consolidation work: the skill-check rework (CM/CN/CS), the fold
  rulings (CQ/CR), the pouch (CT), and the talent audit (CU reported, CV applied).
- **The open work is now mostly DESIGN DECISIONS rather than implementation** — see the queue
  below. Several items need a ruling before any batch can act on them.

---

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION

**Named by the designer:**
- **Enemy interference as a status.** Not yet specified.
- **The relic family** — including the open question of **whether relics are party-wide or
  per-hero**. This is the ruling the rest of the family waits on.
- **Rune content.** The rune economy is measured and the system is built; the content pass has
  not been authored.
- **The enemy debuffs whose duration exceeds their own cooldown.** Reported by the fold census —
  the class of change that turns a timed effect into a permanent one.
- **The design review.**
- **Browser playtesting with friends.**

**Carried from the code, reported and deliberately not fixed:**
- **The Hollow Crown's `Regalia` cannot be cast, and its description names the wrong mechanic.**
  The end boss carries five abilities and this is one of them. Its description says it wards an
  ally against the next blow; its payload is `enemy_shield` (3 turns of 25% less damage), and a
  one-charge ward is `shield_charges`. **Nothing can select it**: `_enemy_support_action` chooses
  support casts by literal display name and "Regalia" is not among the six it names, while the
  attack list filters on `damage > 0` and Regalia has none. `battle.gd`'s own comment lists it as
  a live shield source, so the code's notes believe it fires. A boss met alone also has no ally
  to ward. **A DESIGN QUESTION, NOT A BUG TO FIX BLIND:** wire it into the chooser, re-point it
  at itself, or retire it the way Melted Armor is retired — kept, and SAID to be kept.
- **"Crushing Blow" is on both sides of the field.** An Orc Chief ability (damage 34, BD 56) and
  the Warrior's own earnable ability (damage 43), beside a Warrior talent called **Crushing
  Blows**. Three things share the stem in one combat log, and the log line is the only place any
  of them is named. **Worse than the card-vs-node collisions already dealt with, because both
  halves are abilities.** Renaming either is the designer's call and one string.
- **The code identifiers still reading "beast".** The PROSE was renamed; the fields were not, on
  purpose — a missed rename in prose is a typo, a missed rename in a field is a bug, so the two
  want separate passes with separate tests. **`beastmaster` / `Beastmaster` / `BEASTMASTER` are
  NOT on the list and must not be renamed** (the spec is still called the Beastmaster in game, so
  the key is a proper name). Live identifiers: `unit.gd` `beasts`, `beast_committed`,
  `no_beast_left`, `no_beast_left_loyalty`; `battle.gd` `_beasts`, `_free_beast`,
  `_on_beast_death`, `_beast_cap` (referenced by name from `talents.gd`); battle locals
  `bot_beasts`, `cw_beasts`, `kc_beasts`, `sb_beast`, `sb_beasts`, `tm_beasts`; node ids
  `bm_beast_within` and `bm_no_beast_left` — **renaming those two moves the save format.**
- **No spec pool has ever been checked for redundancy against its own base kit.**
- **Two specs still take the generic talent fallback**, nine nodes between them.
- **`docs/text-audit.html` and `docs/talent-audit.html` hold findings that have been ruled on and
  applied.** Once the designer confirms, both can leave the knowledge sync.

---

## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND

*Re-derive these before quoting them in a brief; they move.*

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
- **Test suites: 44**, spanning `test_batch_ah` to `test_batch_cp` (with gaps — they are NOT one
  per batch), plus `test_run_harness`, `test_runes` and `test_rune_battle`. **They live at the
  repo ROOT, not in `scripts/`.**
- **The master.html stamp gate is duplicated across 14 suites** (ah, bb, bn, bo, bp, bq, br, bs,
  bt, bu, bv, bw, bx, ce), all on the self-comparing pattern — no bump is owed on a re-stamp.
- **Run harness gate counts: 22 / 165 / 8.**
- **master.html stamp: `Last updated: 2026-08-20 (Batch CV)`.**

### Knowledge sync, measured at CW
- **Total: 5.46 MB across 126 text files, down from 6.15 MB across 124** (`assets/` is excluded —
  a sync does not ingest mp3/wav/png/ttf). **739 KB came off `CLAUDE.md`; the net saving is
  706 KB, 11.2%**, the difference being this batch's own new files.
- **`CLAUDE.md` was 883.5 KB (14.0% of the old sync) and is 144.2 KB (2.58% of the new one)** —
  11,066 lines to 1,796, an **83.7%** cut. **The target was under 3% and it is met.**
- **If the brief's "73% of capacity" is right for the OLD sync, capacity is ~8.4 MB and the new
  sync sits at ~65%.** *(Derived, not read from the connector.)* That derivation is only as good as the 73%; check it in the connector.
- Heaviest remaining: `scripts/battle.gd` 1,127 KB (17.9%), `docs/changelog.html` 486 KB (7.7%),
  `docs/master.html` 319 KB (5.1%), `scripts/classes.gd` 269 KB (4.3%), `docs/design-notes.md`
  268 KB (4.3%).
- **The 44 test suites total 1,700 KB — 27.0% of the sync**, the single largest block. **They
  cannot be archived (they must be in the repo to run) but they CAN be deselected from the sync.**
- **`scripts/` is 34.9% and contains ZERO test suites.** It is all game code and stays selected.

---

## KNOWN-BROKEN AND DELIBERATELY UNFIXED

- **`check_cm_live` reports 4 failures. THIS IS THE ONE RED.** Identical on unmodified HEAD,
  recorded as owed in the gate itself, unchanged since. It is the only thing that presses the
  defensive bar, so the failures are worth keeping visible rather than silencing.
- **`test_batch_bo` has a flaky assertion — roughly 1 failure in 13 runs.** Its check count is
  rock steady at 1025; the §5 NULL FIELD check resolves the same enemy attack at 2 Resonance and
  at 14 and requires `deep < shallow`, but the damage carries a 0.9–1.1 variance roll, so both
  can land on the same integer (observed: 16 and 16). **`test_batch_bo.gd` calls `seed()` zero
  times**, so its stream differs every run. **A count-diffing rule reads this as a regression and
  it is not one.** The repair is to seed the suite or widen the gap the assertion measures.
- **Two suites drift in their check COUNT and must be read as bands, not numbers:** `an` at
  **6052–6054** and `bk` at **129–130**, both always 0 failures. `bk` generates real zone maps
  and then walks them, so its count is a function of the topology it rolled.
- **`check_map` is NOT a hang** — 99% CPU for ~5 minutes. The battery gives it a per-target 600s
  bound.
- **`check_parse` does not cover the test suites.** It walks `res://scripts` and `res://scenes`
  only, so a syntax error in a root-level `test_batch_*.gd` surfaces only when the battery
  reaches that suite.
- **The `_hint_done` / `_skill_done` deadlock is real and is NOT currently biting.** Both
  skill-check orientation cards `await` a signal only a real click or key press emits. The four
  suites that hung on it (al, bp, br, bw) were **closed two batches running** and produce counts;
  the diagnosis that closed them has held. **A future headless modal will hit this again** —
  `_nobody_can_press()` is the one place the question is asked, and a Profile flag is not a bot
  guard.

### Last full battery
**At CS: 45 suites, zero throws, zero failures, zero fail lines.** Counts:
ah 5625, ah_battle 65, ai 2217, aj 418, ak 528, al 560, **an 6052**, ar 735, as 396, at 470,
au 336, av 324, aw 350, ax 345, ay 484, az 519, ba 690, bb 177, bc 91, bd 71, be 34, bf 78,
bg 47, bh 233, bi 91, bj 67, **bk 129–130**, bl 88, bm 1891, bn 81, bo 1025, bp 272, bq 739,
br 1447, bs 263, bt 455, bu 477, bv 897, bw 548, bx 142, cb 1181, cd 86, ce 1112, runes 3121,
rune_battle 97. Run harness 22 / 165 / 8, all PASS.

**No battery has been run since CS.** CT, CU, CV and CW were implement-only batches under the
standing convention; the next dedicated test batch owes one.
