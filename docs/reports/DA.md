# BATCH DA — ROLL BACK FAITH'S BUILDERS, REFUSE GLACIAL PRISON

*2026-08-21. Two corrections, one standing rule and one sweep reported without changes. No save
version moves (still v10).*

---

## THE HEADLINE

| | |
|---|---|
| **Faith's builders go back; the threshold stays.** `FAITH_PER_ABSORB` 3 → **2**, the ground drip 2 → **1**, `FAITH_RELEASE` still **3**. | Releases a battle at rung 2: **0.81 → 2.60**, against CZ's 4.24. It landed between the two at **every** rung. |
| **Glacial Prison is refused when it would write nothing.** One entry in `RECAST_GATED`, one case in `_recast_writes`, through `_ability_usable`. | **59 gated abilities**, and the first talent-grant among them. `check_co` 0 failures with the new member driven live. |
| **A copied helper is now a named failure mode.** | The rule is in `CLAUDE.md`; the sweep found **one more copy and reports it without touching it**. |

**`check_da.gd` is new: 30 checks, 0 failures, and it joins the battery (fourteen gates).**
**Five complete runs of the game** — the four comparable arms plus one built specifically to hold
the card §2 is about.

---

## §1 — FAITH'S BUILDERS GO BACK

### What moved

- **`FAITH_PER_ABSORB` 3 → 2.**
- **`FAITH_PER_GROUND_TURN` 2 → 1.** *The constant itself is CZ's and it stays* — naming the rate
  was the durable half of that change, and a bare literal at a call site cannot be measured or
  moved. The revert moves the number and keeps the name.
- **`FAITH_RELEASE` is untouched at 3.**

### Why the threshold was the honest half and the builders were not

CZ sized the builders against CY's arrival measurement — *"Faith reaches 1.6 of the 5 a release
needs"* — and then, in the same batch, **proved that measurement was answering a different
question**: the `conviction` row samples the **Devout's own meter**, which holds at the threshold
and never releases by rule. The figure that answers *"does a release fire"* is `releases/battle`,
and it read **0.81 a battle at rung 2**, not a third of what was needed.

**When a batch discredits the measurement it was sized against, everything it sized is owed a
re-derivation — including the parts that look fine.** CZ re-derived the interpretation and shipped
the magnitudes anyway. Tripling the builders on top of a halved threshold moved releases to
**4.24**: a fivefold change sized against a number that was wrong.

### And it removed a mechanic

At **3 per absorb against a threshold of 3, one absorbed hit is a whole release.** A shielded ally
filled and paid out on the same blow, so he **never held Faith at all** — and `faith_peak`, the
high-water mark the entire lane pays its mitigation and damage on, stopped existing for allies. The
card stopped being a ramp and became a per-hit heal.

CZ recorded that concern in full rather than burying it, in the code and in its report. **It was a
larger change than the one that was asked for and nobody chose it.** That is what decided this
revert — not the size of the power swing.

**`check_da` asserts the RELATIONSHIP rather than the number:** `FAITH_PER_ABSORB < FAITH_RELEASE`
and `FAITH_PER_GROUND_TURN < FAITH_RELEASE`, plus a live absorb driven through
`_on_shield_absorbed` that must leave the ally **holding** 2 of 3 — and a second absorb that must
still release him. A revert that restored the hold by breaking the release would pass the first
half alone.

### RE-MEASURED AT EVERY RUNG, BESIDE CZ'S TWO FIGURES

**Faith releases per battle** — the row that actually answers the question. `--run 25`, three
difficulty rungs, the same four arms CZ used.

| arm | before CZ | CZ shipped (3 / 2) | **DA (2 / 1)** | where it landed |
|---|---|---|---|---|
| A rung 1 wanderer | 0.51 | 3.83 | **1.93** | between |
| B rung 2 warden | **0.81** | **4.24** | **2.60** | between |
| C rung 3 ruin | 0.75 | 5.28 | **2.48** | between |
| D rung 2, Sharpshooter | 1.49 | 6.39 | **3.62** | between |

**The threshold alone lands between the two at every rung, exactly as §1 predicted, and it is not
near 0.81 — it is roughly a TRIPLING of the pre-CZ rate.** So the threshold was the half that
mattered: it does most of the work the builders were also asked to do, and it does it without
changing what the card is. CZ's own four-combination table said the same thing at one rung
(2.71 at rung 2 for the threshold alone); this confirms it at all four.

**Faith peak** — the held half, which is the half the builders were quietly deciding:

| arm | before CZ (of 5) | CZ shipped (of 3) | **DA (of 3)** |
|---|---|---|---|
| A rung 1 | 1.9 — 39% | 2.5 — 85% | **2.2 — 73%** |
| B rung 2 | 2.3 — 46% | 2.4 — 81% | **2.2 — 73%** |
| C rung 3 | 2.4 — 47% | 2.4 — 80% | **2.0 — 66%** |
| D rung 2, SS | 2.8 — 56% | 2.5 — 84% | **2.3 — 78%** |

**Devout healing per battle**, the power figure CZ flagged: A 26 → 130 → **74**, B 69 → 178 →
**133**, C 69 → 239 → **130**, D 118 → 265 → **184**. **Still well above where the lane started and
roughly a third off CZ's peak**, which is the trade the revert buys.

**The decomposition at rung 2**, so the two builders can be read separately: absorbs **3.90**,
ground drip **8.01**, total **12.27** a battle, of which **2.21** lands on the Devout's own held
meter. **Faith per absorb ACTUALLY LANDED is 1.56 against the 2 the constant promises** — the cap
at the threshold still throws the remainder away, unchanged in kind by the revert. The ground is up
on **49% of hero turns** (8.1 of 16.5).

### The two cards §1 asked about, reported and NOT changed

- **ELEVATION grants 2 against a threshold of 3 — 67% of a release, party-wide, in one cast.**
  Unchanged, as instructed. It is still the one magnitude in this lane with a history of being
  moved by accident (CG set it to 2, CN's fold pushed it to 3, CQ reverted it).
- **BLESSING OF THE FAITHFUL still needs 3 held of a possible 3 — the WHOLE bar** — and is still
  castable only by the Devout, since an ally reaching 3 releases on the spot. Unchanged.
- **Both are printed by `check_cz` and `check_da` every run**, so neither can drift silently.

### A CZ documentation miss the revert exposed, and it is fixed here

**`master.html`'s Elevation card still described the release threshold as 5** ("an ally already
holding 3 or more reaches the cap of 5 and RELEASES"), and the Faith status row still said "At 5
the bearer heals 15%". CZ moved the threshold and did not move those two strings. **Both are
corrected.** Its flavour line — *"2 a shielded hit, 1 an ally turn on the ground"* — was stale under
CZ and **is true again**, which is how it came to be noticed.

---

## §2 — GLACIAL PRISON IS REFUSED WHEN IT WOULD WRITE NOTHING

### Through CO's door, and only CO's door

Three edits, no fourth: **`RECAST_GATED` gains `"glacial_prison"`** (59 now), **`_recast_targets`
adds it to the living-enemies pool**, and **`_recast_writes` gains its case**. The refusal itself is
`_recast_refused`, called from `_ability_usable` exactly as it was before. **`check_da` counts the
occurrences of `_recast_refused` in `battle.gd` and fails if there is a fourth** — one definition,
the door, and the tooltip that must agree with it — so a second path cannot be added quietly.

**It is the first TALENT-GRANT in the set,** and that is what the enumeration hole actually cost:
CO's criterion could not be applied to an ability that no walk in the project could see, so the
defect was *invisible* rather than merely unfixed.

### The test is exact, and one half of it is a guard rather than a value

Glacial Prison is **the only member of the set whose handler guards its own write.** Every other
member calls `_apply_status` unconditionally and lets `add_status`'s `max()` discard the weaker
value. Glacial Prison reads `if not target.has_status("chilled")` and **never calls it at all** on a
Chilled target. So the table mirrors the guard, not the number:

- **The Chilled half is proposed ONLY when it would land.** Proposing it on an already-Chilled
  target would have the gate read its own optimism as an improvement — CR §3 from the other
  direction.
- **The freeze half is proposed unconditionally** and `_status_write_improves` decides it, exactly
  as every other member works. `_hold_freeze` returns immediately on an already-frozen target, and
  a proposed `frozen` that is neither longer nor deeper than the standing one is precisely what
  "would not improve" means.

**The duration comes out of one authored copy.** `_freeze_turns()` (with `_freeze_holds()` under it)
is new and `_hold_freeze` now calls it for the number it writes. **CR §3's defect was exactly a
duration authored in the handler and again in the gate's table** — they diverged, the gate read its
own longer number as an improvement, and it stopped refusing anything.

**ONE KNOWN INEXACTNESS, AND IT ERRS TOWARD ALLOWING.** A **non-boss** carrying a one-turn freeze
while a Cryomancer stands would read the proposed permanent hold as an improvement while the
handler wrote nothing. `_apply_status(_, "frozen", …)` has **exactly one call site** — inside
`_hold_freeze` — and it cannot produce that pairing; it needs a Cryomancer who died, let the ice
land timed, and was resurrected. **Allowing a wasted cast is the safe error; refusing a live one is
not**, which is §2's own instruction.

### WHICH HALF DECIDES IT — AND THE ANSWER IS NEITHER

**The Chilled half saves the cast approximately never, and that is a proof rather than a sample.**
`_hold_freeze` is the only site in the project that writes `frozen`, and every path through it that
lands the freeze also writes Chilled — **4 stacks for a real hold, 1 for ordinary ice**. So a frozen
body always carries Chilled, and the Chilled half is dead on exactly the targets the refusal is
about. `check_da` drives both directions live: on a held enemy the table proposes **only** the
freeze, and on a Chilled-but-unfrozen enemy it proposes the freeze and the cast is **allowed**.

**What decides the button is the POOL.** The refusal darkens a *button*, not a *pick*, so it can only
fire when **no** legal target would improve — i.e. when **every living enemy is frozen**. One
unfrozen enemy anywhere keeps it lit. `check_da` asserts that too: saturate the whole board and it
refuses with a reason; thaw one enemy and it lights back up.

**That is the honest scope of the rule and not a defect in it.** Rime, Bola, Hysteria and every
other picked-target member of the set have carried the same scope since CO. A per-pick refusal
would be a second path, and §2 forbids a second path by name.

**HOW OFTEN IT FIRES CANNOT BE READ OFF THE SIM, AND SAYING SO IS THE FINDING.** The default sim
build equips **each tree's first lane**, which for the Cryomancer is **Winter** — so the sim's
Cryomancer has never had Glacial Prison, Second Prison or Absolute Zero, and no figure in any prior
report speaks to this card at all. A fifth run was made specifically with
`DOD_SIM_BUILDS="cryomancer:Deep Freeze"` — the lane that actually holds the card — and it is a
live smoke test of §2 rather than a measurement of it:

| rung 2, 25 runs | freezes/battle (trash / boss) | holds lasting ≥3 turns | depth | completions |
|---|---|---|---|---|
| default **Winter** lane | 4.20 / 4.93 | 1.75 / 0.78 | 47.12 ±0.48 | 80% |
| **Deep Freeze** lane | 3.30 / 1.15 | **2.65** / 0.78 | 47.16 ±0.69 | 88% |

**The Deep Freeze build freezes LESS often and HOLDS far longer**, which is what the lane is for —
and it is the build that takes **Absolute Zero** (row 9, same lane), which removes the hold limit
entirely. **That is the build in which "every living enemy is frozen" is genuinely reachable**, so
the refusal is a real mechanic there rather than a curiosity, even though nothing in the current
instrumentation counts how often it fires. **25 complete runs, no throws, and the Faith figures
hold steady across the build change** (releases 2.54 against arm B's 2.60), which is the check that
matters here: §2 did not break the Cryomancer's play.

**What it would take to measure the firing rate properly** is a `_stat` counter beside BD §1's
`trap_cap_refused` and a line in the Cryomancer's report row. That is instrumentation rather than
a repair, and this batch is small on purpose.

---

## §3 — THE RULE CZ EARNED, AND THE SWEEP

### The rule, recorded in `CLAUDE.md`

> **Enumerate the ability corpus through `Classes.ability_corpus()`. Never copy another gate's
> walk.** A talent can grant an ability that lives in no pool, and a hand-rolled walk misses five.
> **A helper copied between gates inherits its bugs silently and diverges from its origin without
> anything reporting it.**

**THIS IS A DIFFERENT FAILURE FROM EVERYTHING ELSE IN `CLAUDE.md`'S TRAPS.** The rest are DRIFT:
one authority, edited, and a second copy left behind. This is **propagation by copy** — five gates
wrong in five places from birth, because four copied `check_cl_width`'s walk rather than deriving
one. **Fixing the origin leaves four.** Drift gives you one stale copy and a chance a diff notices
it; a copied helper gives you N, all born wrong, none of them diffed against anything.

**`check_da` asserts the rule rather than only stating it**: no `check_*.gd` may contain a
hand-rolled corpus walk, with **CZ's `_cl_only_corpus` named as the one exemption** — being a copy
is its job there, and the gate asserts it is *still* a copy so a later reader cannot consolidate it
into uselessness.

### THE SWEEP — REPORTED, NOTHING CHANGED

Every `check_*.gd` was compared function-by-function and by sliding 5-line block. **One helper
qualifies under §3's threshold of three or more gates:**

| helper | gates | distinct bodies | what has already gone wrong |
|---|---|---|---|
| **`_spawn`** (the battle fixture) | **7** — `check_cm_live`, `check_co`, `check_cs`, `check_ct`, `check_cy`, `check_cz`, `check_da` | **4** | **The `Profile` flag divergence.** CQ §1 deliberately deleted the two hand-set `Profile.set_flag` lines from `check_cm_live`'s copy — "a Profile flag is not a bot guard" — and left them standing in `check_co`'s and `check_ct`'s. **Nothing anywhere reported that the copies had diverged from their origin.** |
| `ok` | 7 | 2 | The two variants differ by `_checks += 1`, which is why some gates report "N failures" and others "N checks / M failures". |
| `_report` | 4 | 4 | **It has already cost the project a bug.** The copies diverged into `"N checks, M failures"` and `"N checks / M failures"`, and `run_battery.sh`'s own header records the scar: a `grep -E "checks,"` that silently missed every suite printing the second form. |

**The signature diverged too, which is the tell:** `_spawn(specs: Array)`, `_spawn()` and
`_spawn(run: Node)` are three different contracts for one fixture.

**`check_da` prints the census every run** — *"N gates; M carry their own `_spawn` battle fixture,
in K DISTINCT bodies"* — so the number cannot rot into a sentence nobody re-checks.

**CONSOLIDATING THEM IS ITS OWN BATCH AND IS NOT STARTED.** A shared fixture must serve four
legitimately different needs: a party parameter, `check_cs`'s determinism forcing (`no_cover`,
zeroed parry/block/crit), `check_ct`'s pre-loaded pouch slot, and `check_cm_live`'s deliberately
absent flags. Getting it wrong breaks every gate at once.

**AND THE SAME DEFECT IS FAR LARGER IN THE SUITES, REPORTED AND OUT OF SCOPE:** the same sweep over
the 47 `test_batch_*.gd` files finds **`_spawn` in 37 suites as 34 distinct bodies**, `_run` in 39
as 39, and `_kill` copied **byte-identically into 14**. §3 asked about gates; this is what the same
question answers one directory over.

---

## §4 — VERIFICATION

| gate | result |
|---|---|
| `check_parse` | 0 failures — **stderr grepped for `Parse Error`, never the tally** |
| **`check_da`** | **30 checks / 0 failures** — new, and joins the battery (now **fourteen** gates) |
| `check_co` | **0 failures at 59 gated abilities**, 58 refused after saturation (Interpose is additive and never refuses) |
| `check_cz` | 0 failures |
| `check_cn` | 0 failures |
| `check_cm` | 0 failures |
| `check_flow` | 0 failures |

**The parse check caught a real error in this batch and the tally did not.** `check_da`'s first run
printed `check_parse`-clean output and **exited 0 with two `Parse Error` lines on stderr** — the
exact trap the standing rule exists for.

### Five complete runs of the game

25 runs each, three difficulty rungs, ~2,500 battles a pass. **Battles resolve; nothing throws.**

| | rung | completions (CZ → DA) | depth reached (CZ → DA) |
|---|---|---|---|
| A | 1 wanderer | 100% → **100%** | 48.00 ±0.00 → **48.00 ±0.00** |
| B | 2 warden | 72% → **80%** | 46.56 ±0.75 → **47.12 ±0.48** |
| C | 3 ruin | 52% → **56%** | 42.84 ±2.14 → **44.76 ±1.31** |
| D | 2 warden, Sharpshooter | 72% → **76%** | 47.04 ±0.40 → **46.12 ±0.99** |

**NO ARM MOVED FURTHER THAN ITS OWN COMBINED STANDARD ERROR** (B ±0.89, C ±2.51, D ±1.07 against
moves of +0.56, +1.92 and −0.92). **Taking a third of the Devout's healing back off did not make
the game measurably harder** — which is the expected result for a change aimed at what a card *is*
rather than at difficulty, and it is the same honest summary CZ's own numbers earned.

**Blood Frenzy is unchanged and that is the control:** 17.1 / 20.7 / 22.6 / 26.2 against CZ's
17.4 / 20.9 / 22.8 / 26.2. **Loyalty and Focus still over-arrive** (19.3–21.2 of 5; 128.2 of 100)
and were not touched.

**Rounds to resolution (turns per living party member):**

| party / rung | trash | elite | boss |
|---|---|---|---|
| 1 wanderer | 3.8 | 3.4 | 4.0 |
| 2 warden | 4.4 | 3.6 | 5.3 |
| 3 ruin | 4.4 | 4.4 | 4.4 |
| 2 warden, Sharpshooter | 5.5 | 4.9 | 6.0 |

**Still three to six turns per hero.** One qualification on a claim `docs/state.md` has carried
since CY: **"elite fights are the shortest of the three kinds at every rung" no longer holds at
rung 3**, where all three kinds read 4.4. It holds at rungs 1 and 2 and for the Sharpshooter party.

**NO SUITE AND NO FULL BATTERY WAS RUN.** DA is implement-only under the standing convention. The
next dedicated test batch still owes one, and **`test_batch_bi` is the one piece of good news
there**: it asserts `const FAITH_PER_ABSORB := 2` and `ally.faith_stacks == 2` after one absorb, so
CZ had turned it red and **this revert turns it back green** without the suite being run.

---

## FOUND WHILE WORKING, REPORTED AND NOT FIXED

- **THE DEFAULT SIM BUILD CANNOT SEE FIVE OF THE CRYOMANCER'S CARDS.** `DOD_SIM_BUILDS` defaults to
  each tree's first lane, which is **Winter** — so Glacial Prison, Second Prison, Cold Snap, Glacial
  Economy and Absolute Zero have never appeared in any measurement in this project. The same is
  true of the non-first lane of **every one of the twelve specs**. Not a defect (a fixed default
  party is what makes arms comparable across batches), but **no sim figure can be quoted about a
  card in a non-default lane**, and several have been.
- **`master.html` HAD TWO STALE FAITH THRESHOLDS FROM CZ** — fixed here, and §1 says where. Worth
  noting as a pattern: **CZ moved a number in three code sites and two of five prose sites.**
- **`_recast_refusal_note` NAMES "FROZEN", NOT "HELD".** The refusal on a held enemy reads *"Frozen
  already stands at full strength"*, while the nameplate on that enemy reads **HELD** (Batch AS §4
  renamed it deliberately, because a player who cannot see why an enemy stopped taking turns is
  being shown a bug). **The note is accurate and the vocabulary is inconsistent.** One string, and
  it is the designer's call whether the note should read the live label.
- **`check_cu` AND `check_cv` ARE STILL NOT IN `run_battery.sh`'s `GATES` ARRAY.** Carried from CZ,
  unchanged; `check_da` was added to that array and the two audits were not, because what a failure
  means in an audit report is still a decision.
