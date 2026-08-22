# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

*Last rewritten: 2026-08-22 (Batch DF).*

---

## WHERE THE PROJECT IS

- **Last batch: DF — the 47 failing assertions are SORTED, and 37 of them are repaired.** Five
  implement-only batches had left them standing, correctly, because each needed a ruling on what it
  should ask INSTEAD. **DF bucketed all 47 before touching any of them: 37 STALE, 2 WRONG, 8
  UNDECIDED.** The 37 are repaired and **the failure total falls 47 → 10, by exactly 37 and by
  nothing else**, every check count in the project unmoved. **The sort found a real bug** —
  Consecrated Ground's card has promised DOUBLE the Faith it pays since Batch DA — and it is
  **reported, not fixed**, because which side is wrong is a design question. `test_rune_battle` is
  seeded per-site. No save version moves (still v10).
- **Next letter: DG.** The two-letter stamp gate in fourteen suites reads `substr(_code_at + 7, 2)`
  out of `(Batch XX)` and compares lexically — `DG` sorts after `DF`, so it still works. **A
  THREE-letter code would break all fourteen.**
- **Phase.** The ability draft is COMPLETE (120 of 120) and all twelve talent trees are
  purpose-authored. Recent batches are correction and consolidation: the skill-check rework
  (CM/CN/CS), the fold rulings (CQ/CR), the pouch (CT), the talent audit (CU/CV), the documentation
  split (CW), the archive cut (CX), the tempo rule (CY), CZ's two ramp repairs, DA's correction of
  one of them, DB's and DD's `_spawn` consolidations, DC's threshold repairs, DE's move of the
  count differ into the runner, and DF's sort.
- **THE STALE-ASSERTION QUEUE IS EMPTY. WHAT REPLACES IT IS A RULING QUEUE OF TEN**, and it is a
  different kind of work: **2 are design questions about the game and 8 are decisions about what a
  check should ask.** Every one is in `baselines.json` with the reason beside it, so **an
  eleventh would be reported immediately.**

---

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION

### THE ONE THAT IS THE QUEUE — TEN REDS, EVERY ONE DELIBERATE

**The full statement of each is `docs/reports/DF.md` §3 and §4.** In short:

- **TWO ARE THE GAME BEING WRONG, AND BOTH ARE PROSE.**
  - **Consecrated Ground's card promises 2 Faith a turn and the code pays 1.** `classes.gd` reads
    *"every ally is kindled 2 Faith at the start of their turn"*; `battle.FAITH_PER_GROUND_TURN` is
    **1**. CZ raised the constant 1 → 2 and moved the card with it, correctly; **DA reverted the
    constant and left the card.** DC swept this exact defect, fixed the `passive_desc` and the
    `faith` chip, and did not reach the card. `master.html` says 1 and is right. **The ruling:
    revert the card to 1, or was DA's revert a step too deep?** (`test_batch_bj`, 1 red.)
  - **`data/glossary.json` still reads "beast" once**, in CV's own hero/ally entry. It belongs to
    the prose-rename pass. (`test_batch_bx`, 1 red.)
- **SIX ARE THE EXCLUSIVE-PAIR LIST, AND THERE IS NOTHING TO REPOINT AT.** CW's split removed
  `CLAUDE.md`'s pair list with Batch AA's narrative and **the strings exist nowhere in the repo or
  the archive.** The rule they guard was already dead: the removed block's own last sentence records
  that **Batch AI retired `test_runes._exclusives` to a bare `pass`**. **Two further assertions in
  the same block now pass VACUOUSLY.** **The ruling: does the rule still bind?** If it does it
  belongs in `CLAUDE.md`'s TRAPS section and the dissolution history in this file; if it does not,
  the six should point at `talents.gd`, where `as` §6's first two assertions already ask it and
  already pass. (`as` 2, `at` 3, `aw` 1.)
- **TWO PIN MILESTONES INSIDE A BLOCK THAT CONTRADICTS ITSELF.** `bo` asks `CLAUDE.md` to name
  `TRANCHES 2 AND 3` as the debt that remains; `ce` asks it to record the Cleric as the second class
  complete. **Neither is true any more** — the draft is 120 of 120, counted from `classes.gd`. **And
  `CLAUDE.md`'s `STANDING REFERENCE — THE ABILITY DRAFT` states the size TWICE, 49 lines apart, with
  different answers**: line 2116 says *"120 OF 120 AND NOTHING IS OWED (Batch CI)"* and is right;
  lines 2160–2168 say *"`SPEC_DRAFT_POOLS` is 24 entries"*, *"the draft holds 66 of a target 120
  (Batch BU)"* and *"the HUNTER and WARRIOR six are still at TWO"*, and are superseded. **The ruling:
  cut the superseded half and invert both assertions to protect the record of COMPLETION** — the
  idiom BP, BQ and BR each used as a debt was paid — **or cut the block and point them at
  `classes.gd`.** (`bo` 1, `ce` 1.)

### Small, and still owed

- **`test_batch_cd`'s ANCHOR GUARD DOES NOT BITE, AND NOTHING IS RED (FOUND AT DF).** §2 slices
  `CLAUDE.md` from the draft anchor and its comment says it stops at the next standing block *"so a
  later batch's prose cannot quietly extend what this check is reading (the BE anchor lesson)"*.
  **It searches for `"### STANDING"` — three hashes. Every heading in the file is `## STANDING` —
  two.** `find()` returns −1, the guard falls through, and **the slice runs to the end of the file:
  20,949 characters against the block's 10,335.** The assertions still pass because the correct
  sentence also lives inside the true block, so **this is a check that has stopped asking its
  question with no failure to announce it.** **The fix is one string** — `tail.find("\n## STANDING")`
  — **but it narrows a gate's scope, so it wants its own deliberate change with the counts published
  either side.** The five sibling anchor-finders were checked: four resolve, and `test_batch_bg`'s
  documents its own fall-through on purpose.
- **`_run`'S SAVE-BACKUP PREAMBLE IS THE NEXT COPIED HELPER, AND THE CENSUS WAS OFF BY ONE.**
  Re-derived at DF: **`_run` is 39 bodies in 39 suites and is correctly 39** — it is each suite's own
  driver. **38 of the 39 open with the same `_had_save` backup block. 38 swap `Profile.save_path` to
  a per-suite file — not the 37 every document has carried — and 33 of those 38 swap it back**;
  `bn`, `bo`, `bp`, `bq` and `br` do not. `test_run_harness.gd` restores the real path without ever
  swapping away from it. Same shape as `_spawn`, one layer in. **Still not taken.**
- **`CLAUDE.md` IS OVER CW's OWN TARGET.** CW set *"under 3% of the knowledge sync and roughly flat
  over time"*. It reads **186 KiB of a 5.71 MiB sync = 3.18%**, and was already over before DF's
  additions. Not urgent; worth a prune when a batch is in the file anyway.
- **TEN HAND-BUILT BATTLE BOARDS REMAIN, IN SIX FILES** — `al` (2), `an`, `ax`, `bl`,
  `test_rune_battle` (3), `test_run_harness` (2). **None is a copied helper**: they are bespoke
  boards inside single checks, and two of those files have no `_spawn` at all. `check_da` §3 carries
  them as a **named ratchet** (by file AND by count), so a new copy cannot hide among them. Its live
  line reads *"47 suites; 37 go through `suite_fixture.gd`, 0 author their own; 10 hand-built boards
  remain in 6 files"*.
- **`test_rune_battle` IS SEEDED NOW AND THE BAND IS NOT TIGHTENED.** DF §0 put `_seeded()`
  immediately before the forced White Flame hit and nowhere else, so the other 96 checks keep their
  own stream. **The check count is unchanged at 97.** **Two clean post-seed readings cannot retire a
  rate measured over fifteen**, so `baselines.json` still carries `0–1`; tightening on that evidence
  would be the band-from-too-few-readings fault pointing the other way. **The seed cannot fix a
  race**, and both recorded reds landed under machine load, so the failure message now carries the
  state the forced hit happened in — `battle_over`, both units' liveness, the target's health, the
  ability's damage type, the target's fire resist, the pierce fraction. **The next red will say what
  was missing.**
- **`bo`'s FLAKE IS STILL OPEN**, at roughly 1 failure in 13 runs, and is **deliberately unseeded**
  — one flake at a time is how the effect stays attributable. Its repair is `at`'s shape: seed both
  blows of the compared pair.

### Carried, and still awaiting a ruling

- **THE ARITHMETIC PROBES IN `bg`, `bh` AND `bi` STILL SIT ABOVE THE REACHABLE BAND.**
  `STACKS := 4` is a **direct-write probe depth**, not a carry ceiling — those checks write
  `faith_stacks`/`faith_peak` onto the unit, bypass `_gain_faith`'s clamp, and measure a per-stack
  rate against **fixed percentage-point tolerances** (`< 2.0`, `< 2.5`, `> 2.5`). **Halving the
  depth halves the effect size against tolerances that do not move with it**, across roughly thirty
  currently-green live measurements. **Moving them down is a re-derivation of tolerances, which is a
  ruling, not a repair.** **DF's eight threshold repairs in `bu` and `ce` are NOT this case** — they
  involve no tolerances, only counts — which is why those could be taken and these cannot.

### Carried, with measurements attached

- **THE FRENZY RATE IS `FRENZY_RAGE_PER_STEP` = 5** and is a rule rather than a constant (five Rage
  is 5% of a full bar, the health term's own rate). Peak Frenzy 13.4 → 20.9 of 40 at rung 2 under
  CZ, and **DA re-measured it unchanged at 20.7**. **Reckless Abandon dumping a full bar books all
  twenty steps at once** — named, not discovered later.
- **THE FAITH LANE IS SETTLED AND THE SUITES AGREE WITH IT — AND AS OF DF, ALL SEVEN OF THEM DO.**
  Numbers in `docs/reports/DA.md`: threshold 3, builders 2 and 1, releases **1.93 / 2.60 / 2.48 /
  3.62** across the four arms. **Elevation (2 of 3) and Blessing of the Faithful (3 of 3) were
  reported at both CZ and DA and deliberately changed at neither.** If either is revisited,
  Elevation is the one with a history of being moved by accident (CG set 2, CN's fold pushed 3, CQ
  reverted it).
  - **THE DERIVED BAND IS WHAT THE FAITH SUITES ASSERT ON SINCE DC:** the deepest an ally can
    **HOLD is 2** (`FAITH_RELEASE - 1`); **Communion's eligible band is 1–2** (the walk skips
    `faith_stacks >= FAITH_RELEASE`) and its roll `0.01 * 15 * stacks` **peaks at 30%**, measured
    at **29.8% over 1200 trials**; **two absorbs are a release.** **DC gave five suites
    `const RELEASE := 3` and `const HELD_MAX := RELEASE - 1`; DF adds the same two to `bu` and
    `ce`**, so the next threshold ruling costs one line in each of seven.
  - **AND WHEN A BATCH REVERTS A CONSTANT, SWEEP THE PROSE FOR THE NUMBER IT REVERTED — INCLUDING
    THE ABILITY'S OWN CARD.** DA's revert left "3 a hit" in the Devout's `passive_desc` and the
    `faith` chip, both fixed at DC — **and "kindled 2 Faith" in Consecrated Ground's card, which DC
    did not reach and DF found.** **Grep the NUMBER, not the field**: a card says "2 Faith" and
    never says `FAITH_PER_GROUND_TURN`.

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

- **EIGHT TARGETS STILL CANNOT REPORT A CHECK COUNT, AND IT IS A RATCHET RATHER THAN A SENTENCE.**
  `check_parse`, `check_flow`, `check_map`, `check_cl_resolver`, `check_cl_width`, `check_cm`,
  `check_cn` and `check_map_screen` read `checks=?`. **Two of them — `check_cl_width` and
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

*Re-derive these before quoting them in a brief; they move.*

- **THE TEMPO LADDER HAS THREE RUNGS AND EACH IS WRITTEN AGAINST THE ONE ABOVE.**
  `Ability.BASIC_DELAY` = **2.0** (the one authored copy in the project; `battle.BASIC_DELAY` is an
  alias) → `Ability.BUFF_DELAY_CAP` = `BASIC_DELAY * 0.5` = **1.0** → `Ability.DELAY_FLOOR` =
  `BUFF_DELAY_CAP * 0.5` = **0.5**, the cheapest an ability UPGRADE can buy.
- **THE CAP BINDS 58 ABILITIES IN TWO POPULATIONS.** `Ability.PURE_BUFFS` holds **52** specials
  and `Ability.SHIELD_SPECIALS` holds **6**. **`Ability.takes_delay_cap()` is the one function that
  unions them** and `Ability.make()` applies the clamp. **DF re-pointed sixteen suite assertions
  that still pinned pre-CY delays for members of `PURE_BUFFS`** — every one verified against both
  the list and the def before it was touched.
- **THE ABILITY CORPUS IS 216, AND `Classes.ability_corpus()` IS THE ONLY WALK THAT REACHES IT.**
  The Batch CL enumeration alone reaches **211**; the five it misses (Backdraft, Pyroblast, Glacial
  Prison, Cryoclasm, Intercession) are talent grants that live in no pool. **22 talent-granted
  names in total**, all resolving. **`check_da` §3 asserts that no gate hand-rolls the walk**, with
  `check_cz`'s `_cl_only_corpus` named as the one deliberate exemption.
- **`RECAST_GATED` HOLDS 59 ABILITIES.** `check_co` refuses 58 of the 59 after saturation;
  Interpose is additive and correctly never refuses. **Glacial Prison is the newest member and the
  reason its name appears in THREE tables in `battle.gd`** — `_recast_targets`, `_recast_writes`
  and the effect handler, DA §2's "three edits and no fourth". `test_batch_as` pins the count at 3.
- **BLOOD FRENZY: TWO TERMS, ONE BAND.** `BattleUnit.FRENZY_MAX_STEPS` = **20** and
  `FRENZY_RAGE_PER_STEP` = **5**. Steps are summed then clamped.
- **FAITH: `battle.FAITH_RELEASE` = 3**, **`FAITH_PER_ABSORB` = 2**, **`FAITH_PER_GROUND_TURN` = 1.**
  `JUBILEE_MIN_FAITH` is **3**, which is the WHOLE bar. `ELEVATION_STACKS` is **2**, which is **67%
  of a release**. **An absorbed hit pays LESS than a release costs, and `check_da` asserts that
  RELATIONSHIP rather than the numbers.** **`_gain_faith` doubles under `zeal` and under nothing
  else** — not Fervor, not Apostle.
- **The ability draft is COMPLETE at 120 of 120** — `SPEC_DRAFT_POOLS` is **96** (12 specs × 8)
  and `CLASS_DRAFT_POOLS` is **24** (4 classes × 6), counted out of `classes.gd` at DF.
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

### THE TEST TREE, AS OF DF

- **47 `test_*.gd` files**: 44 `test_batch_*` spanning `ah` to `cp` (with gaps — they are NOT one
  per batch), plus `test_run_harness`, `test_runes` and `test_rune_battle`. **They live at the repo
  ROOT, not in `scripts/`.**
- **`_spawn` IS AUTHORED ONCE, IN `suite_fixture.gd`, AND 37 SUITES GO THROUGH IT.** `_kill` too, in
  14. Each suite keeps its OWN `_spawn` SIGNATURE and delegates, so **all 389 call sites are
  untouched.**
- **`run_battery.sh` RUNS 46 SUITES AND MISSES NONE.** The `GATES` array is **fourteen**. **There
  are 20 `check_*.gd` files**, so **six are not in `GATES`** — `check_ck_width`, `check_cu`,
  `check_cv`, `check_ct_map`, `check_map_screen` and `check_de`. **`check_ct_map` and
  `check_map_screen` run in the SCENE RUNS section and `check_de` runs in its own post-pass section
  AFTER them**, so the three that run nowhere are `check_ck_width`, `check_cu` and `check_cv`.
- **THE BATTERY WRITES A MANIFEST, `$OUT/.ran`, AND THE DIFFER TRUSTS IT RATHER THAN THE DIRECTORY
  LISTING.** `run_battery.sh` does NOT clear `$OUT` between runs, so a target that failed to launch
  would otherwise be blessed by its PREVIOUS run's log. A name is appended immediately before its
  target is launched and `run_one` truncates the log at spawn, so **a log named in the manifest is
  always this run's**. A subset invocation (`./run_battery.sh bo bp`) writes a short manifest and
  **the differ reports the rest as DID NOT RUN instead of certifying a clean tree.**
- **`gate_fixture.gd` AND `suite_fixture.gd` ARE NOT GATES AND ARE DELIBERATELY NOT NAMED
  `check_*`/`test_*`** — `test_batch_cd` and `check_da` both glob those prefixes.
- **THE BASELINE TABLE IS `baselines.json` AND IT IS 65 ROWS: 46 suites, 14 gates, 2 scene runs
  and 3 harness gates.** **DO NOT RESTATE ITS NUMBERS HERE OR IN `CLAUDE.md`** — a second copy of a
  number is this project's oldest recurring defect. Per target it carries the expected check count
  (a number or a band), **the expected FAILURE count**, **how many readings the row rests on**, any
  known flake and its rate, and an optional verdict string. **Every red row now carries the reason
  it is red**, written at DF.
- **`test_batch_cd` IS 71 CHECKS** and is the hygiene suite: the dead-symbol sweep, the draft-target
  sweep and the pool measurement. **Its §2 anchor guard is broken and reported above.**
- **`check_de.gd` IS THE DIFFER AND IT SPAWNS NOTHING.** It runs last, reads the logs and the
  baseline file, and reports. **It is re-runnable in seconds over a log directory that already
  exists**, which is what lets a batch write `docs/state.md` and its report AFTER the battery and
  still certify the tree — neither is read by any suite, and `check_de` reads neither.
- **`run_battery.sh`'s check-count grep is GENERAL and must stay that way.** It matches three
  shapes because 45 suites print at least five between them. **The `grep -E "checks,"` in the
  battery's header is a comment recording a scar CP already fixed — it is not live code.**
- **The master.html stamp gate is duplicated across 14 suites** (ah, bb, bn, bo, bp, bq, br, bs,
  bt, bu, bv, bw, bx, ce), all on the self-comparing pattern — no bump is owed on a re-stamp.
- **Run harness gate counts: 22 / 165 / 8.**
- **master.html stamp: `Last updated: 2026-08-22 (Batch DF)`.**

### HOW LONG A FIGHT IS
- **Rounds to resolution, measured as TURNS PER LIVING PARTY MEMBER** (companions excluded from
  both halves), over four `--run 25` sims, **after DA** — **DB through DF ran no sim and these are
  carried unchanged**:

  | party / rung | trash | elite | boss |
  |---|---|---|---|
  | 1 wanderer | 3.8 | 3.4 | 4.0 |
  | 2 warden | 4.4 | 3.6 | 5.3 |
  | 3 ruin | 4.4 | 4.4 | 4.4 |
  | 2 warden, Sharpshooter | 5.5 | 4.9 | 6.0 |

  **A fight is still three to six turns per hero.** **"Elite fights are the shortest of the three
  kinds at every rung" NO LONGER HOLDS AT RUNG 3**, where all three kinds read 4.4.
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
- **TWO CONFOUNDERS ON EVERY FIGURE ABOVE: the sim party is FULLY TALENTED (`rows=9 of 9`)**, and
  **it wears each tree's FIRST lane — 24 of 36 lanes have never been measured at all.**
- **AND THE INSTRUMENT'S OWN CAVEAT: the `conviction` row samples the DEVOUT'S OWN meter, which
  HOLDS at the threshold and never releases by rule.** It has never measured release frequency —
  `releases/battle` is the row that does.

### The changelog
- **The live file starts at Batch CO and holds 18 entries** (CO → DF), **273 KiB**. The 400 KB
  threshold is still some way off.
- **`DoD-archive/changelog-archive.html` holds 131 entries** (Batch 1 → CN) and is **1042 KiB**.
- **Fourteen suites depend on a file that is not in version control** — bp, bq, br, bs, bt, bu,
  bv, bw, bx, cb, ce, bb, bn, bo. On a machine without `DoD-archive/` they FAIL LOUDLY, which is
  correct.

### Knowledge sync, re-measured at DF
*Measured over `.gd .md .html .json .py .sh`, excluding `assets/`, `.git/` and `.godot/`.
**Treat the file COUNT as method-dependent.** **ALL SIZES BELOW ARE KiB (1024 bytes)**.*
- **124 files, 5.71 MiB** (DD measured 120 files / 5.54 MiB; DE and DF each added a report, DE a
  gate and a baseline file).
- Heaviest: `scripts/battle.gd` **1149**, `docs/master.html` **320**, `docs/design-notes.md`
  **314**, `scripts/classes.gd` **274**, `docs/changelog.html` **273**, `CLAUDE.md` **186**,
  `scripts/talents.gd` **181**, `scripts/unit.gd` **174**.
- **The 47 suite files total 1802 KiB — 30.8% of the sync**, still the single largest block. **They
  cannot be archived (they must be in the repo to run) but they CAN be deselected from the sync.**
  The 20 gates add **177 KiB**.
- **`scripts/` contains ZERO test suites.** All game code.

---

## KNOWN-BROKEN AND DELIBERATELY UNFIXED

### THE TEN THAT REMAIN — EVERY ONE DELIBERATE, EVERY ONE IN `baselines.json` WITH ITS REASON

**DB measured 72 across 26 suites. DC repaired 23. DD and DE deliberately repaired none. DF sorted
all 47 and repaired the 37 that were STALE.** What is left is the ruling queue at the top of this
file: **2 WRONG and 8 UNDECIDED, across 7 suites** — `as` 2, `at` 3, `aw` 1, `bj` 1, `bo` 1,
`bx` 1, `ce` 1.

**THE COUNTS ARE IN `baselines.json` AND ARE NOT REPEATED HERE.** Every red row carries a `note`
saying which bucket it is in and why, so **an eleventh red is visible immediately** — which is what
DE's per-target failure baselines were built for and what DF finally gave them something exact to
hold.

### THE REST

- **`check_cm_live` reports 4 failures. THIS IS THE ONE RED THAT IS ON PURPOSE.** Identical on
  unmodified HEAD, recorded as owed in the gate itself. **DB confirmed the four are byte-identical
  before and after the gate consolidation; DC, DD, DE and DF confirm them again.** It is the only
  thing that presses the defensive bar.
- **AND FOUR CHECKS PASS BY ACCIDENT, WHICH IS WORSE THAN A RED.** Two were on record (`bn`'s and
  `bs`'s `contains("BATCH XX")` against `CLAUDE.md`); **DF found two more** —
  `test_batch_ce.gd`'s `contains("BATCH CE")` and `test_batch_br.gd`'s `contains("Arcane Arrows")`,
  where **only 4 of BR's twelve class-draft cards survive in `CLAUDE.md` as incidental mentions**.
  **`br`'s and the two `ce`/`bn` cases are repaired at DF as part of their suites' repairs**; `bs`'s
  is the same one-line shape and is left for the batch that next opens that suite. **A fifth and
  sixth of the same species sit in `as` and `at`** — assertions that now pass VACUOUSLY because the
  list they read a substring of is gone entirely — **and those are part of the exclusive-pair
  ruling above, not separate work.**
- **`test_batch_at` IS SEEDED AND PINNED — 470 checks over five consecutive runs at DD — AND IT WAS
  TWO FLAKY CHECKS, NOT ONE.** Both were ratios with margins narrower than their own propagated
  noise: a blow rolls `randf_range(0.9, 1.1)`, so a RATIO of two carries up to 22% against bands of
  ±20% and ±7%. **The fix is to seed both blows of each pair, not to widen the band** — the band IS
  the question. **Its three remaining reds are the exclusive-pair ruling and nothing else.**
- **`test_batch_bo` STILL HAS ITS FLAKY ASSERTION — roughly 1 failure in 13 runs.** Its check count
  is rock steady at 1025; the §5 NULL FIELD check requires `deep < shallow` and the damage carries a
  0.9–1.1 variance roll, so both can land on the same integer. `test_batch_bo.gd` calls `seed()`
  zero times. **Its floor of 1 is a SEPARATE, DETERMINISTIC red** and is in the ruling queue above.
- **THE SUITES THAT DRIFT IN THEIR CHECK COUNT, AND THE OBSERVATION COUNT EACH BAND RESTS ON.**
  **The bands are in `baselines.json`, with the observation count beside each.**
  **THE RULE, ASYMMETRIC ON PURPOSE: floor = the lowest observation, ceiling = the highest PLUS the
  observed spread** — the floor is the half that catches a real fault, so it stays tight and the
  ceiling takes the headroom. **`check_de` RUNS on that asymmetry: it asserts the floor and reports
  a rise as a notice.**
  - **`an`'s FLOOR MOVED AT DF, FOR A READING AND NOT FOR A REPAIR.** DF's before-battery — on
    **unmodified HEAD, before the first edit** — read **6046**, one below a floor that was itself
    the lowest of thirteen readings, and `check_de` reported it as an error. **It is drift, not a
    fault:** 0 failures, 0 throws, and all thirteen of the suite's section headers printed, so
    nothing stopped running. The floor is 6046 now and the row rests on fourteen readings.
  - **`bk` is NOT widened**, because it has not been exceeded: headroom goes where a reading demands
    it.
- **`check_map` is NOT a hang** — 99% CPU for ~5 minutes. The battery gives it a 600s bound.
- **`check_parse` does not cover the test suites.** It walks `res://scripts` and `res://scenes`
  only. **It does not cover the GATES, `gate_fixture.gd` or `suite_fixture.gd` either** — but a
  broken suite fixture fails 37 suites loudly, and **DF parse-checked every edited suite with
  `--check-only`, grepping stderr, with a negative control proving the check bites.**
- **A GATE THAT EXITS 0 IS NOT A GATE THAT PASSED.** **A `--script` target whose base class does not
  resolve prints `Parse Error`, runs not one line, and exits 0.** Grep the stderr; never trust the
  tally and never trust `$?`. **`run_battery.sh`'s `throws=` column is the only thing standing
  between this fault and a green report.**
- **The `_hint_done` / `_skill_done` deadlock is real and is NOT currently biting.** Both
  skill-check orientation cards `await` a signal only a real click or key press emits. **A future
  headless modal will hit this again** — `_nobody_can_press()` is the one place the question is
  asked, and a Profile flag is not a bot guard.

### Last measurements

**TWO FULL BATTERIES AT DF — one on unmodified HEAD before anything was touched, and a
VERIFICATION run against the final tree.** A third was not needed: `docs/state.md` and
`docs/reports/DF.md` are the only documents written after the run, **neither is read by any suite
and `check_de` reads neither**, so the verification battery supervised every file the tree reads.
`baselines.json` was written with the PREDICTED after-values BEFORE the run, so the run tested the
prediction rather than recording it.

**THE BEFORE-BATTERY REPRODUCED THE RECORDED FIGURE EXACTLY: 47 failures across 20 suites**, zero
throws — the number five batches had carried, confirmed on unmodified HEAD rather than recalled.

| | before | after |
|---|---|---|
| **suite failures** | **47 across 20** | **10 across 7** |
| fall | | **exactly 37 — the STALE count, and nothing else** |
| `check_cm_live` (deliberate) | 4 | 4 |
| **throws, grepped from the stream** | **0** | **0** |
| check counts that moved | — | **two, both known drifters inside their bands** |
| `check_de` | 273 / 1 / 0 | **273 / 0 / 0** |
| wall clock | **29m 05s** | **29m 18s** |

**THE FALL IS EXACTLY THE STALE COUNT, WHICH IS THE TWO-SIDED ACCEPTANCE TEST.** A smaller fall
would mean a repair did not land; **a LARGER fall would mean something was repaired by accident**,
and would have been reported rather than banked. It is 37 on the nose.

**EVERY REPAIRED SUITE'S CHECK COUNT IS BYTE-IDENTICAL ACROSS THE PAIR** — `ar` 735, `as` 396,
`av` 324, `aw` 350, `ax` 345, `bb` 177, `bd` 71, `bn` 81, `bq` 742, `br` 1450, `bt` 458, `bu` 480,
`bv` 900, `bw` 551, `bx` 147, `cb` 1184, `ce` 1116. **That is the audit that says no assertion was
deleted to reach green**, and it is the whole reason CQ's rule asks for the count either side.

**THE ONLY TWO CHECK COUNTS THAT MOVED ARE THE TWO KNOWN DRIFTERS**, both inside their recorded
bands and both at 0 failures throughout: **`an` 6046 → 6054** and **`bk` 129 → 130**. Everything
else is identical across the pair: all 14 gate lines, the harness at 22 / 165 / 8, `check_ct_map`
at 83 / 0, `check_map_screen` at its `OK`, and **`throws=0` everywhere in both runs**, grepped from
the stream and never read off a tally.

**THE DIFFER'S VERDICT ON THE VERIFICATION RUN: `check_de` 273 checks / 0 failures / 0 notices** —
65 of 65 recorded targets swept, zero throw markers, 0 unwatched and 0 un-run. **Every predicted
baseline was confirmed by the run.** The observation counts were then raised for DF's two readings
and **the same logs re-read 273 / 0 / 0 in 0.37 seconds**, which is what makes correcting a
baseline cost seconds rather than a battery.

**`test_rune_battle` READ 97 / 0 ON BOTH BATTERIES AND ON TWO AD-HOC RUNS AFTER THE SEED — three
post-seed readings, all clean, one of them under full battery load.** That is not enough to retire
a rate measured over fifteen and the band is unchanged at `0–1`.
