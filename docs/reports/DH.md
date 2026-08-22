# BATCH DH — CROSS-SPEC SYNERGY

**Nine clauses on nine existing cards. No new abilities, no new statuses, no pool depth change.**
`SPEC_DRAFT_POOLS` is still 96, `CLASS_DRAFT_POOLS` still 24, and the draft still stands at
**120 of 120**. The ability corpus is still **216** and `check_cn` counted it again after the edits.

**Three of the brief's load-bearing claims were wrong against the repo.** All three are corrected
below, and one of them would have reproduced — inside the batch that warned about it — the exact
duplication fault §0's fourth rule exists to prevent.

---

## §0 — THE THREE CORRECTIONS, BEFORE THE NINE

### 1. "Canis's strikes apply Bleed" — ALREADY TRUE, AND FOR MANY BATCHES

`Summon Canis` reads, and has read since the Beastmaster shipped:

> *"Call the wolf (80 HP): attacks with you for 20% of your Attack, **building 20 Bleed**. …
> On arrival: BLOODHOWL — 15 Bleed to every enemy. Loyalty gift: **+2 Bleed per stack**."*

`_companion_strike`'s `canis` branch carries it (`wolf_bleed := 20 + 2 * l`, doubled under Wrath).
**Writing the clause as briefed would have been BD's Deadfall/Snare Trap duplication exactly** —
fourteen batches of a duplicate nobody read — reproduced in the batch whose own §0 warns about it.

**Two further reasons it could not have gone where the brief put it.** `Summon Canis` is a
**base-kit enabler**, not a draft card: it is in `SPEC_INFO`'s `enablers`, not in
`SPEC_DRAFT_POOLS`, so a clause there could never be drafted *for* — which is §0's first rule.
And the Beastmaster's actual draft eight are Twin Hunt, Call the Wilds, Bloodbond, Savage Sweep,
Ghostpack, Last Howl, Succession and Unleash.

**THE GAP IS THE OTHER TWO COMPANIONS.** Ursus builds no Bleed at all; Aguila lays Exposed. So the
clause moved onto **Savage Sweep**, the card that sends *whichever* companion at three enemies —
additive for two of three, and a genuine new coupling rather than a second copy of the wolf's line.

### 2. "Battle Shout already reads enemy Bleed" — IT READS A METER, NOT A STATUS

`battle_shout` sums `e.bleed_buildup` across living enemies. **There is no `bleed` row in
`STATUS_INFO`** — it was deleted at **BJ §1** as never-applied and never-displayed, and the chip a
player sees is *synthesized* from the meter by `unit.log_bleed_chip()`. An implementation taking the
brief at its word would have called `_apply_status(_, "bleed", …)` and indexed a table with no such
key. Bleed is applied through **`_add_bleed_with_burst`**, which is also what carries the
Exsanguination rune and Slaughterhouse clauses hanging off a bleedout.

**The coupling still works, and better than briefed:** the synthesized chip carries id `bleed`,
which **is** in `DEBUFF_IDS`, so it feeds Trapper *and* Battle Shout from one clause.

### 3. "If statuses do not currently carry a source, say so and report the cost" — THEY HAVE SINCE BATCH W

`_apply_status` stamps the applier onto the status it just applied:

```gdscript
var st_stamp := target.get_status(id)
if not st_stamp.is_empty():
    st_stamp["src_name"] = src.unit_name
```

The brief had budgeted Harvest's clause as possibly unaffordable and given it permission to wait.
**It cost a read, not a signature change across 244 call sites.**

**THE BRIEF WAS STILL RIGHT TO ASK, AND THE REAL ANSWER IS THE INTERESTING ONE.** The field exists
but is **partial**: of 204 single-line `_apply_status` calls, **53 pass `src` and 151 do not**. A
status applied by one of those 151 carries no stamp, reads as "not an ally's", and pays the **base**
rate. That is the safe direction — **a missed bonus, never a false one** — but it is a real
under-payment and it is recorded here rather than hidden. *"Does the field exist"* and *"is the
field populated"* are two questions, and the second is the one that bites.

---

## §1 — FEEDING THE SURVIVALIST

His Trapper multiplies damage by `1.0 + 0.08 * _status_count(target)` — **distinct statuses from any
source, allies' included**. He is the one spec already built to be fed.

### Choking Smoke also sets every enemy Burning

| | |
|---|---|
| **Card text added** | *"The smoke also sets EVERY enemy / Burning 2 turns — fuel for a / Pyromancer's Ember Debt, and one more / affliction under your own Trapper."* |
| **Reads / applies** | applies `burn`, 2 turns, at `_dot_tick("burn", attacker)` |
| **In `DEBUFF_IDS`?** | **`burn` — CONFIRMED IN** (`unit.gd:19`) |

**One clause, two couplings.** It widens his own breadth, and it arms the Pyromancer's Ember Debt
and Funeral Pyre, which consume Burn and have never had a second applier in the party. It goes
through `_apply_status` with `attacker` as src, which is load-bearing twice: `add_status`'s burn
branch **extends** a running fire rather than replacing it, and passing src is what lets §2's
Emberkeep see this fire at all.

### Snare Line binds harder against a Chilled target

| | |
|---|---|
| **Card text added** | *"The line binds a CHILLED enemy harder: / the spring holds it 2 turns, not 1. / A Cryomancer lays that ice."* |
| **Reads** | `u.has_status("chilled")` at the spring site; applies `stunned` for `SNARE_LINE_COLD_STUN` = 2 |
| **In `DEBUFF_IDS`?** | **`chilled` — CONFIRMED IN** (`unit.gd:19`) |

**Written at the line's spring site and deliberately NOT inside `_spring_trap`.** That helper is
shared with the placed deadfall and Snare Trap, so a clause in it would have moved a magnitude on
**two existing effects** — which §5 forbids. `add_status` MAXes turns, so this raises the spring's
own 1 rather than stacking a second stun, and the boss refusal in `_apply_status` still stands.

### Harvest pays more per status an ALLY applied

| | |
|---|---|
| **Card text added** | *"A wound an ALLY opened reaps richer: / up to 18% a status when the whole / board is the party's work."* |
| **Reads** | `src_name` on each status the purge will take, resolved against `heroes` |
| **Magnitude** | `0.12 + HARVEST_ALLY_BONUS(0.06) * ally_share` — 12% at a share of 0, 18% at a share of 1 |

**The hub stated outright: he is paid for the party working a target rather than for doing it
alone.** The snapshot is taken **before** the purge (the purge destroys the evidence) and uses
`_harvest_yield`'s own filter, so a sticky poison that survives is not credited to an ally any more
than it is billed for. `hv_ally` is then clamped to the count the purge actually took, on BA's rule.

**The name is resolved against the party rather than merely compared to his own.** `_apply_status`
stamps `src_name` for *any* source, an enemy's included, so a bare `!= attacker.unit_name` would
read a debuff one enemy laid on another as the party's work. Resolving by name through the array is
`_frostbind_partner`'s idiom. **`heroes` carries the companions, which is correct rather than
incidental** — Aguila's Exposed is the Beastmaster's work — and neither side filters on `dead`,
because a hero who has since fallen still opened the wound.

---

## §2 — FEEDING THE PYROMANCER

### Emberkeep extends Burn any HERO applies

| | |
|---|---|
| **Card text** | *"Burn ANY HERO applies lands at DOUBLE / duration — a Survivalist's Choking / Smoke burns twice as long beside you."* |
| **Changed** | `src.has_status("emberkeep")` → `src.is_hero and _emberkeep_holder() != null` |
| **Also updated** | the `emberkeep` status chip in `STATUS_INFO`, and the cast's log line |

He becomes the party's Burn amplifier — the consuming end of §1's Choking Smoke, so the two clauses
are one loop. The whole mechanic is still **one clause at `_apply_status`'s `eff_turns` block**.

**`src.is_hero` IS THE GUARD AND IT IS LOAD-BEARING.** "Anyone" means anyone in the *party*: an
enemy Ashblade's burn and a rune's burn must still land at their own length, or the card would
double the fire eating the heroes. **The old scoping did that work by accident**, because only he
could ever hold the status. `_emberkeep_holder()` mirrors `_living_hero_with` for that function's
own stated reason — the effect now outlives the applier's identity.

### Firedraw draws deeper from an already-worked body

| | |
|---|---|
| **Card text added** | *"An enemy already carrying ANOTHER / spec's debuff gives up 9, not 6."* |
| **Reads** | `_other_spec_debuff(foe)` — the curated `DEBUFF_IDS` list, minus `burn`, `slow_burn`, `broken` |
| **Magnitude** | `FIREDRAW_TAKE_PERFECT`(6) + `FIREDRAW_DEEP_BONUS`(3) |

**It is a property of each SOURCE body, not of the target**, which is what makes it a *draw* clause
rather than a damage one: a field the Cryomancer has chilled and the Occultist has marked gives up
its fire faster than a clean one. `burn` and `slow_burn` are subtracted as **his own vocabulary**;
`broken` is subtracted on `_status_count`'s standing rule — it is a Break-meter state rather than an
affliction anybody applied. **No second hand-rolled list**, per the brief.

---

## §3 — FEEDING THE OCCULTIST

### Breaking Darkness names its partners — NO MECHANICAL CHANGE

| | |
|---|---|
| **Card text added** | *"EVERY source means allies too: a / Sharpshooter's Fault Line and a / Warden's Turn the Blade both land / harder while this holds."* |
| **Code changed** | **none** |

The card already amplified *every* source of Break by `BREAKING_DARKNESS_BD_PCT`, allies' included,
the day it shipped. The combo existed and was found by accident. **This is discoverability, and it
was worth a slot**: a coupling a player cannot see on the draft card is not a coupling, because the
draft is where the decision is made and it is made under time pressure against two other cards.

### Suffering deepens against a Broken enemy

| | |
|---|---|
| **Card text added** | *"Against a BROKEN enemy the wound runs / deeper: 3 Ruin a turn. Whoever breaks / them feeds your madness."* |
| **Reads** | `target.broken` — the Break METER state |
| **Magnitude** | base 2 (3 on a perfect) + `SUFFERING_BROKEN_BONUS`(1) |

Ties his Madness gate to **whoever is generating Break**, and CR made hard control Broken-gated, so
Broken is already the axis the party works toward. Nothing in the Occultist's own kit is the fastest
route there. **It reads the meter state, not a status** — `broken` is excluded from `_status_count`
by name for exactly this distinction. The perfect and the Break stack deliberately, and both halves
are on the card.

**Checked against the Occultist tree and it duplicates nothing**: Broken Will is +Break *dealt*;
Whispers and Spread of Madness name Broken only as the boss gate.

---

## §4 — THE TWO THAT COUPLE PLAYSTYLES, NOT STATUSES

### Savage Sweep opens a wound whichever companion runs it

| | |
|---|---|
| **Card text added** | *"The run opens 12 Bleed on each, ANY / companion — feeding a Berserker's / Battle Shout and a Survivalist's / Trapper."* |
| **Applies** | `_add_bleed_with_burst(ss_t, SAVAGE_SWEEP_BLEED)` = 12, per enemy struck |
| **In `DEBUFF_IDS`?** | **`bleed` — CONFIRMED IN** (`unit.gd:20`), via the chip `log_bleed_chip` synthesizes |

The consuming end is a **Berserker card that exists today with nothing to author on it**: Battle
Shout pays +1% party damage per 20 of the enemy party's `bleed_buildup`, summed across every living
enemy — so three bleeding bodies is the widest single contribution to that sum in the game.

**12 is deliberately under the wolf's own 20 a strike**: this is the *card* bleeding, not the
animal, and Canis still bleeds hardest because its own line stacks on top.

### Shared Grief reads how many allies stand below half

| | |
|---|---|
| **Card text added** | *"…and gain 4 Mercy, / +1 for every OTHER ally already below / half health. … / A Berserker lives down there — his / frenzy band is your Mercy."* |
| **Reads** | `sg_h.hp <= sg_h.max_hp * sg_h.mercy_threshold` over other living non-companion heroes |
| **Magnitude** | `4 + sg_low * SHARED_GRIEF_PER_WOUNDED`(1), still clamped by `second_max` |

**THE BEST COUPLING IN THE BATCH, AND THE REASON IS STRUCTURAL.** Mercy accrues on the **crossing**
below half — `_check_below_half` fires once, gated on `was_above` — so a hero who *parks* in that
band pays her once and then nothing. The Berserker's entire Blood Frenzy band **lives** down there
on purpose; Blood Offering exists to buy it deliberately. So the composition that keeps a hero in
her generator is precisely the one her generator cannot see, **because it measures an edge and he is
a level**. One clause reading the level converts his standing state into her resource. **The two
specs whose engines are inverted become each other's fuel.**

**It reads `mercy_threshold`, never a literal half** — Guardian Angel raises that stamp party-wide,
and a literal would silently disagree with the passive the card is named after. **Companions are
excluded and so is she**: paying her for her own wound would let the card fund its own price.

---

## §5 — WHAT THE NINE DELIBERATELY DO NOT DO

- **No new abilities.** The corpus is still 216 and the draft still 120 of 120.
- **No new statuses.** Every coupling uses vocabulary already in the game.
- **No two-way pairs.** Each clause runs one way into a hub, so no card is dead when its partner is
  absent — which matters because **a run fields four of twelve specs**.
- **No magnitude on an existing effect moves.** A lone Pyromancer draws exactly what he always drew;
  a Holy beside a healthy party gains exactly the 4 Mercy she always gained; a board the Survivalist
  opened alone still reaps at exactly 12%.

---

## §6 — VERIFICATION

**The documentation was written BEFORE the run** (`docs/changelog.html`, `CLAUDE.md`,
`docs/master.html` §6b and the stamp, `design-notes.md`), and **`baselines.json` carried the
PREDICTED after-values before the battery started**, per the rule DG recorded. `docs/state.md` and
this report are the only documents written after — **neither is read by any suite and `check_de`
reads neither** — so the run supervised every file the tree actually reads.

**NO CODE CHANGED AFTER THE BATTERY STARTED.** `scripts/battle.gd`, `scripts/classes.gd` and
`test_batch_cb.gd` were last written at 15:47:50, 15:33:24 and 15:37:54; the battery's first log is
**15:48:34**. The four supervised documents were written between 15:42 and 15:45. **The run
certified the exact tree being shipped.**

**One disclosure about `baselines.json`.** The cb prediction (1184 → 1185) was decided and written
**before** the battery. The file was then **rewritten once at 15:50, during the run**, purely to
restore the repo's `indent=1` formatting — an earlier write had reformatted all 65 rows at
`indent=2` and buried a 4-line change in a 1742-line diff. **The values were identical across that
rewrite**, and `check_de` reads the file only in its final post-pass. The diff against HEAD is now
4 lines, which is the one row that moved.

### The parse floor, and the negative control that proves it bites

**`check_parse` reports 0 failures and the STDERR GREP IS THE FLOOR, never the tally and never the
exit code.** A `--script` target whose base class does not resolve prints `Parse Error`, runs not
one line, and **exits 0**.

| probe | `Parse Error` lines |
|---|---|
| the final tree | **0** |
| **negative control** — `func _dh_negative_control(:` appended to `battle.gd` | **2** |
| the tree again, control removed | **0** |

**And across all 66 battery logs: 0 `Parse Error`, 0 `SCRIPT ERROR`, 0 stack traces**, grepped from
the logs rather than read off any tally. `throws=0` on every target.

*(`--check-only` on `battle.gd` alone reports `Identifier not found: Run` — that is the autoload
outside project context and it is **PRE-EXISTING**: the untouched HEAD copy reports it identically.
It is not a DH fault and is not the check that matters; `check_parse` in project context is.)*

### The prediction, and what the run said about it

| | before (DG's after-battery) | **DH after** |
|---|---|---|
| **suite failures** | **1 across 1** | **0** |
| `check_cm_live` (deliberate) | 4 | **4** |
| **throws, grepped from the stream** | 0 | **0** |
| check counts outside their band | 0 | **0** |
| `check_de` | 273 / 1 / 0 | **273 / 0 / 0** |
| wall clock | 29m 19s | **29m 13s** |

**`check_de` read 0 failures AND 0 notices**, which is the differ saying that **no count fell, no
failure count rose, and nothing rose unexpectedly either** — every one of the 65 rows landed inside
its recorded band, and the one row that was predicted to move landed exactly on the predicted value.

### The one sanctioned movement, and it landed on the nose

| suite | before | after | movement |
|---|---|---|---|
| `test_batch_cb` | 1184 | **1185** | **+1, §2's guard — predicted before the run** |

**Every other check count in the project is unchanged** — all 46 suites, all 14 gate lines, the
harness at 22 / 165 / 8, `check_ct_map` at 83 / 0 and `check_map_screen` at its `OK`.

### THE ZERO IS NOT DH's, AND SAYING SO IS THE POINT

**`test_batch_at` read 0 failures, and DH did not repair it.** That row is the unseeded §1
damage-curve ratio DG found and deliberately left open; its rate is about one red in eighteen
readings and **it simply did not fire this run**. `test_batch_bo`'s flake did not fire either.
**Both remain open, both are still unseeded, and their bands in `baselines.json` are untouched.**
A zero that arrives because a flake was quiet is not a zero that was earned, and the next batch
should expect either to come back.

---

## §7 — WHAT IS OWED AFTER THIS BATCH

- **`_apply_status`'s `src` COVERAGE IS 53 OF 204, AND HARVEST IS NOW THE FIRST CARD THAT CARES.**
  Until DH the stamp fed only attribution and mitigation credit, where a miss is cosmetic. It is now
  load-bearing for a magnitude. **The under-payment is silent by construction** — an unstamped
  status is indistinguishable from one the Survivalist applied himself — so this is exactly the
  species §0 calls the Stalking Horse trap, one layer in. Widening the call sites is a mechanical
  sweep and a batch of its own.
- **`FIREDRAW_TAKE` (4) IS DEAD AND WAS DEAD BEFORE DH.** `firedraw` uses
  `FIREDRAW_TAKE_PERFECT` (6) unconditionally, so the non-perfect constant is unreachable. **DH did
  not touch it** — collapsing it would move a magnitude on an existing effect, which §5 forbids —
  but it is a real dead symbol and `test_batch_cd`'s sweep does not currently catch it.
- **`shared_grief`'s comment says the card pays "exactly 3" and `sg_grant` is 4.** Stale prose in a
  source comment, pre-existing, and now sitting directly above DH's clause. One line.
