# BATCH DI — MAKING `src` HONEST WHERE HARVEST READS IT

**36 call sites now pass the unit that actually applied the status.** No status behaviour changes,
no magnitude is retuned, no clause from DH is touched: this batch supplies an argument that was
already accepted and already read. `src` coverage goes **63 → 99 of 204** call sites, and against a
realistic board **Harvest's payout goes 3923 → 5308, a 35% correction**.

**One new gate: `check_di`, 44 checks.** It is in `run_battery.sh`'s `GATES` array and in
`baselines.json`.

---

## §0 — THE RECORDED COVERAGE FIGURE WAS WRONG, AND IT WAS WRONG BECAUSE IT WAS A `grep`

`docs/state.md`, DH's own source comment in the Harvest handler, and this batch's brief all stated
**53 of 204**. Counted properly — balancing parentheses across the whole file rather than reading
one line at a time — **the figure was 63**.

| | before DI | after DI |
|---|---|---|
| real `_apply_status` call sites | 204 | 204 |
| pass a real `src` | **63** (51 single-line + 12 multi-line) | **99** |
| pass an explicit `null` src | 2 | **0** |
| omit `src` entirely | 139 | 105 |

**25 of the 204 calls wrap across lines, and TWELVE OF THOSE ALREADY PASSED A SOURCE.** A
single-line grep cannot see any of them. The number was never re-derived; it was quoted into three
documents.

`check_di` §1 walks rather than greps, and it **skips the two COMMENTS that name
`_apply_status(`** — `battle.gd:5494` and `battle.gd:19192`. Without that skip the new count reads
206 instead of 204, which is the same fault one layer down.

---

## §1 — WHICH STATUSES HARVEST ACTUALLY READS, DERIVED FROM THE CLAUSE

Harvest counts a status on its target as an ally's work iff **all four** hold:

1. `id != "broken"` and not `sticky` — the `_harvest_yield` filter, so a sticky poison that
   survives the cleanse is not credited any more than it is billed for;
2. `BattleUnit.DEBUFF_IDS.has(id)` — the curated list, **33 ids**;
3. `src_name` is non-empty and is not the caster's own name;
4. `src_name` resolves to a member of `heroes` other than the caster.

So the read set is `DEBUFF_IDS` minus `broken` = **32 ids**, landing on an ENEMY, from a HERO.

**Of the 141 unstamped sites, 50 could apply one of those** — 48 with a literal id, and 2 computed
(`ab.applies_status["id"]` at 9971, `lunge_status` at 10014). **The narrow scope held comfortably:
this was never "most of the 151".** The population was derived by walking `_resolve_special`'s
call graph and the on-hit rider blocks in `_resolve`, not the ability fields.

---

## §2 — 36 STAMPED, 14 REPORTED RATHER THAN GUESSED

### The 36, by owner

**Two had the real source sitting unused in their own signature**, and both were the file's only
sites passing an EXPLICIT `null` — which reads as deliberate and was not:

| site | function | status | source now passed |
|---|---|---|---|
| 11430 | `_hold_freeze(target, **src**, force)` | `frozen` | `src` |
| 19959 | `_apply_poison(**src**, victim, turns)` | `poison` | `src` |

**The Survivalist's own kit** (7 sites) — these correctly pay NO ally bonus, and stamping them does
not move Harvest's number. They are stamped because the rule is about honesty, not about Harvest:
Trapper's barb (10175), Shrapnel Charge's perfect Slow (10860), Hamstring's Slow and Exposed
(10862, 10863), Tripwire's Caught (11116), Snare Trap's Snared (15160), and the spring trap's
Stun / Cripple / Caught (20264, 20266, 20274 — `placer`).

**The Pyromancer** (7): Detonation's perfect Burn (10291), Aftershock (10298), Flamewave (10318),
the Cinder Trail rune (10333), Wildfire Spread (18427), Slow Burn (16746), and **Immolate (10213),
where the source is `strike_target`** — the burning Pyromancer, not the enemy who struck him.

**The Occultist** (5): Bewitch (15008), Mass Hysteria (15065), Umbral Sigil (18280), Empowered
Hex's Decay (9998), and **Lingering Torment (13800), where `occ` was already resolved on the line
above and simply not passed.**

**The rest** (15): Exposed Nerve (9761), **Judgement (9894 — `cg_dv`, the Devout, applying Sunder
to the enemy who struck her)**, Crushing Blow's Elemental Weakness (10086), Shrapnel's Slow
(10164), Poisoned Arrow (10168), Lunge's Exposed/Cripple (10014), Pinning Shot (10967), Called
Shot's Exposed and Sunder (10976, 10978), Rime's Frostbite (18527), **Ricochet (7975 —
`strike_target`, the hero who blocked)**, and `_apply_perfect_bonus`'s Sunder and Burn (20946,
20949).

### The 14 left unstamped, and why

**Getting the source wrong is worse than leaving it absent**: absent under-pays, wrong mis-credits.
Every one of these is named here rather than picked.

| site | what | why it is ambiguous |
|---|---|---|
| 9971 | Umbral Mirror's rebound | an ENEMY's own debuff, reflected by a talent read via `_max_hero_rank` — **no single hero owns it**, and crediting the party would pay for the enemy's own casting |
| 1619 | the `hoarfrost` modifier stamp | a battle MODIFIER applies it; **no unit is the source** |
| 3200 | Chain Ignition | a DEAD foe's fire passed to survivors. The `ember_wind` holder is resolvable, but is not necessarily who lit it |
| 5019 | the Cursed Visage's Hexed | `_use_item(item_id)` takes **no user at all** — the party uses items |
| 6780 | Spread of Madness | psychosis leaping enemy→enemy, driven by `_max_hero_rank` |
| 13723 | the bewitched strike's Daze | an ENEMY applying to an ENEMY under the party's influence — **the exact mis-credit DH's own comment warns about** |
| 20899 | Hemorrhage's Cripple | a threshold on collective `bleed_buildup`, with `hem` taken as a max across heroes |
| 15153, 17894, 19590, 19592, 19644, 19728, 19730 | **the seven companion sites** | see §3 — the true applier is the companion, and a companion's name cannot resolve in Harvest's loop |

---

## §3 — `heroes` DOES NOT CARRY THE COMPANIONS, AND DH'S COMMENT SAYS IT DOES

DH's Harvest comment reads:

> *"`heroes` CARRIES THE COMPANIONS, which is correct rather than incidental: Aguila's Exposed is
> the Beastmaster's work…"*

**It does not.**

- `heroes.append` is reached at **exactly one site** — `battle.gd:1337`, the party spawn loop.
- A companion is appended to `companions` at `battle.gd:19517`.
- **Four sites** in `battle.gd` write `heroes + companions` (1939, 1966, 12377, 13352) precisely
  because the union is not free, and `_hero_side()` exists solely to build it.
- `_living_hero_with` filters `not h.is_companion` as though companions might be there — which is
  probably where the belief came from.

**The consequence is that Harvest's ally loop cannot resolve a companion's name**, so a wound
Aguila opened pays the base rate however it is stamped. Measured live: a companion-opened board
pays **exactly 1.0000** of a self-opened one.

**DI DID NOT CLOSE IT.** The fix is one word in DH's loop (`heroes` → `_hero_side()`) and it
**moves a magnitude**, which this batch forbids itself. Stamping the seven companion sites without
that fix would have been worse than leaving them: the sweep would have looked complete and the
wound would still pay nothing — the "looks like it works" fault this whole batch exists to correct.

`check_di` §4 asserts both halves — that `heroes` does NOT hold the companion, and that a
companion-opened board pays 1.0 — **so the day this is ruled on, the assertion is what changes
rather than the belief.**

---

## §4 — THE SIZE OF THE CORRECTION

Measured on a board laid by **real casts through the changed sites** — Bewitch, Umbral Sigil, Mass
Hysteria, Slow Burn, a poison, a hold-freeze, and one wound the Survivalist opened himself:

| | before DI | after DI |
|---|---|---|
| reapable statuses on the body | 8 | 8 |
| of those, carrying a source | **1** (`ruin`, which already passed `src`) | **8** |
| ally-opened fraction Harvest sees | 1/8 | 7/8 |
| rate paid per status | 0.1275 | **0.1725** |
| **Harvest payout** | **3923** | **5308** |

**Predicted ratio 1.3529, measured 1.3530** — they agree to integer rounding
(`3923 × 1.352941 = 5307.6` against a measured 5308).

**The number did not barely move.** The sites that mattered were not already among the 63 — before
this batch, seven of the eight wounds on a party-built board were invisible to the clause.

---

## §5 — VERIFICATION, AND THE NEGATIVE CONTROLS

**Three controls on the gate, all run:**

| control | result |
|---|---|
| revert **all 36** edits | `check_di` **44 / 10 failures** — coverage 63, the 2 `null` sites back, and 8 named call sites reporting an empty source |
| revert **one** site (`_hold_freeze`) | `check_di` **44 / 3 failures** — caught in three independent places |
| `HARVEST_ALLY_BONUS` 0.06 → 0.0 | `check_di` **44 / 1 failure** — §2's payout band reds on its own, which is what proves it is not vacuous |

**The parse check was proved to bite**: a deliberate syntax error appended to `battle.gd` produced
1 `Parse Error` line and 0 once removed. **`battle.gd`'s stderr is byte-identical before and after
the 36 edits** (the one pre-existing `SCRIPT ERROR: Compile Error: Identifier not found: Run` is
the autoload, unreachable under `--check-only`, and it is present on unmodified HEAD too).

**AND THE GATE'S OWN FIRST RUN EXITED 0 WHILE PRINTING TWO `Parse Error` LINES** — the exact trap
`CLAUDE.md` has a rule about, hit live in this batch. The verdict was read off the grep, never off
`$?`.

**§2 is seeded on BOTH blows of the compared pair**, which is DD's rule and the repair
`test_batch_at`'s §1 ratio still owes. Harvest rolls `randf_range(0.9, 1.1)` on its damage, so an
unseeded ally-versus-self comparison would be two populations differing in the roll as well as in
the term being measured. Both arms draw the same stream; the ratio reads **1.5000 exactly across
seven readings**, and the gate takes ~3s.

The first version of §2 measured 37 against 55 damage and read 1.4865 — inside the band, but only
just, because a single point of integer rounding was 2.7% of the ratio. The caster's Attack is
scaled in both arms so the band measures the term and not the rounding.

---

## §5a — THE BASELINE PREDICTION, WRITTEN BEFORE THE BATTERY

| row | predicted | why |
|---|---|---|
| `check_di` | **NEW: 44 / 0** | the gate this batch adds; 44 is rock steady over 7 ad-hoc readings |
| `test_batch_ba` | **UNMOVED at 690 / 0** | one needle REPAIRED TO INTENT, count-neutral — see below |
| `check_cm_live` | **4 failures** | the one deliberate red, identical on unmodified HEAD |
| `test_batch_at` | 467, failures **0 or 1** | its unseeded §1 ratio is still open and still banded — **a red there is not this batch's** |
| `test_batch_bo` | 1025, failures **0 or 1** | its §5 NULL FIELD flake is still open and still banded — **not this batch's** |
| `test_rune_battle` | 97, failures **0 or 1** | banded at DF, deliberately not tightened — **not this batch's** |
| **every other row** | **UNMOVED** | DI adds no ability, no status, and no assertion to any existing suite |

**`test_batch_ba`'s needle is the only suite edit in this batch, and it is count-neutral.** Its
`must` table pinned the source fragment `placer.caught_fast)` — where the **closing paren was doing
the work by accident**. DI passes the trap's placer as the status source, so the call now reads
`..., placer.caught_fast, 0, 0, placer)` and that fragment stopped matching. **The question is
unchanged** (does Caught Fast's duration come off its own counter rather than a hardcoded number),
so the needle is re-anchored on `"caught", placer.caught_fast` — which no further argument can
break. **Repaired to intent, never deleted**, on CQ §3's standing rule.

**IT WAS FOUND BY A SWEEP, NOT BY THE BATTERY.** Every string literal in all 47 suites and 21 gates
was evaluated against `battle.gd` before and after the 36 edits: **exactly one flipped**, and this
was it. The first pass of that sweep missed it — it only matched literals written inline inside
`.contains(...)`, and this one is a **dictionary KEY** fed to `ok()` through a loop. A needle
snapshot that does not read indirect literals is a snapshot with a hole in it.

**NEGATIVE CONTROL ON THE REPAIRED NEEDLE:** replacing `placer.caught_fast` with a hardcoded `3`
turns it red (`FAIL: Caught Fast's duration comes off the counter`), so the repair still asks its
question.

---

## §5b — THE BATTERY, AND THE PREDICTION THAT MISSED

**TWO FULL BATTERIES RAN. THE FIRST ONE CAUGHT A DEFECT OF THIS BATCH AND THAT IS THE HONEST
HEADLINE.**

| | battery 1 | battery 2 (acceptance) |
|---|---|---|
| suite failures | **1 across 1** (`test_batch_ax`) | **0** |
| `check_cm_live` (deliberate) | 4 | **4** |
| throws, grepped from the stream | 0 | **0** |
| `Parse Error` / `SCRIPT ERROR` across all 67 logs | 0 / 0 | **0 / 0** |
| `check_de` | 277 / 1 / 0 | **277 / 0 / 0** |
| `check_di` | **44 / 0** | **44 / 0** |

**THE PREDICTION WAS RIGHT ABOUT EVERY ROW IT NAMED AND WRONG ABOUT THE ONE IT DID NOT.** §5a
said *"every other row UNMOVED"*. `test_batch_ax` went **345 / 1**, and it was mine:

> `ok(bsrc.contains('_apply_status(target, "frozen", frozen_turns, 0, 0, null, force)'), …)`

DI changed that `null` to `src`, and the needle stopped matching. **The assertion's own comment
says it has been re-pointed twice already** — at BT and at DF — *"and the question is unchanged"*
both times. This is the third, for the same structural reason: it pins a whole call line, and the
call line keeps legitimately changing. Repaired to intent and **count-neutral at 345**; the needle
now pins the `src` slot too, so a later batch reverting either argument fails here.

**MY LITERAL SWEEP HAD TWO HOLES AND BOTH ARE WORTH RECORDING**, because the sweep is the
instrument that was supposed to make the battery's finding unnecessary:

1. **It only matched literals written inline inside `.contains(...)`.** `test_batch_ba`'s needle is
   a **dictionary KEY** fed to `ok()` through a loop. Widening to all string literals found it.
2. **It only matched DOUBLE-quoted strings.** `test_batch_ax`'s needle is **single-quoted**,
   because it contains embedded `"` characters. GDScript allows both; my regex allowed one.

With both holes closed, the sweep over all 47 suites and 21 gates reports **exactly two** literals
whose presence in `battle.gd` flipped across this batch — and they are precisely the two that had
to be repaired. **A needle snapshot that reads only one quote style and only direct call sites is a
snapshot with a hole in it**, and the battery is what found the hole.

**`check_de` MOVED 273 → 277 AND I DID NOT PREDICT THAT EITHER.** It is four assertions per
baseline row and DI adds one row, so the rise is the differ watching one more target. It is not
baselined (the differ has no row of its own, and excludes itself from its own sweep), so nothing
reported it as a movement — but a predicted table should have carried it.

**THE ZERO IN THE FAILURE ROW IS NOT A REPAIR.** `test_batch_at`'s unseeded §1 ratio, `bo`'s §5
NULL FIELD flake and `test_rune_battle`'s pyromancer pierce all read clean in both batteries.
**All three are still open, still unseeded and still banded.** A row that reads clean at a rate of
about seventeen in eighteen has told you nothing when it reads clean.

---

## §6 — WHAT THIS DELIBERATELY DOES NOT DO

- **105 call sites still pass no source**, recorded as owed. They apply statuses Harvest does not
  read — buffs, marks, hero-side wards — so nothing currently mis-credits off them. The standing
  rule now covers them and the full sweep stays visible.
- **One further site is out of reach by SHAPE rather than by scope.** `melted` is applied through
  `unit.add_status` (`battle.gd:2553`), which **accepts no source argument at all** — stamping it
  is a signature change, not an argument, and this batch's rule was "supply what is already
  accepted". It is the only Harvest-readable status applied outside `_apply_status`.
- **The seven companion sites** — §3.
- **No status behaviour changed, no magnitude moved, no clause from DH was retuned.**
